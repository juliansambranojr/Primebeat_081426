"""weil_rung_min.py — minimise Weil's quadratic functional Q_L(G) over G at fixed
support, on a ladder of truncation lengths X.  EXPLORATORY.  No prereg, no
decision rule, no verdict.

THE FUNCTIONAL (pinned from weil_QX.py, 2026-09-01; Bombieri 2000 eq. 12.2)
----------------------------------------------------------------------------
For a real G supported in [-h, h], h = L/2, L = log X, and F = G * G~ (the
autocorrelation, even, supported in [-L, L]):

    pole  = int F(u) 2cosh(u/2) du
    prime = 2 sum_{n<=X} Lambda(n) n^{-1/2} F(log n)
    arch  = -(log 4pi + gamma) F(0)
            - int_0^L (e^{x/2}(F(x)+F(-x)) - 2F(0)) dx/(e^x - e^{-x})
            + F(0) log coth(L/2)
    Q_L(G) = pole - prime + arch  = sum_rho Fhat(rho)  (= 2 sum_{gamma>0} |Ghat(gamma)|^2 under RH)

Every term is a symmetric bilinear form in G, so in an orthonormal basis
{G_i} of L^2[-h, h] the functional is an M x M symmetric matrix Q_ij, built
from F_ij(x) = int G_i(u) G_j(u - x) du (symmetrised in i, j so that
F_ij(x) + F_ij(-x) is what enters).  The pole term is 2 a b with
a = int G e^{-u/2}, b = int G e^{u/2} — i.e. 2 Ghat(i/2) Ghat(-i/2), which is
2 Ghat(i/2)^2 for even G and is negative for odd G.  F_ij(0) = delta_ij.

    lambda_min(Q)   = min over ||G||_2 = 1 of Q_L(G)   (in the M-dim subspace)
    lambda_min(Q0)  = the same for the no-prime form pole + arch
    ||P||_op        = largest |eigenvalue| of the prime term alone

Two bases, both orthonormal on [-h, h]:
    legendre : G_n(u) = sqrt((2n+1)/(2h)) P_n(u/h), n = 0..M-1  (G_0 = the indicator/sqrt(2h))
    sine     : G_k(u) = h^{-1/2} sin(k pi (u+h)/(2h)), k = 1..M   (vanishes at the ends)

Closed-form transforms used for the zero-side check:
    legendre : Ghat_n(t) = sqrt(2h(2n+1)) i^n j_n(h t)      (spherical Bessel)
    sine     : Ghat_k(t) = h^{-1/2} omega_k ((-1)^k e^{iht} - e^{-iht})/(t^2 - omega_k^2),
               omega_k = k pi/(2h)
Zero side: Z = 2 sum_k |Ghat(gamma_k)|^2 over the cached 2000 zeros and the
99,998-zero file, with tail (G(h)^2 + G(-h)^2)/pi (log(gamma_N/2pi) + 1)/gamma_N
(the instrument's tail_estimate, generalised from G = indicator).

HOW IT WAS RUN
--------------
    cd /Users/juliansambrano/GitHub/Primebeat_081426
    .venv/bin/python analysis/2026-09-01/weil_rung_min.py

Outputs: analysis/2026-09-01/results/weil_rung_min.json, analysis/2026-09-01/weil_rung_min.txt
"""
import argparse
import datetime
import hashlib
import importlib.util
import json
import math
import os
import sys
import time

import numpy as np
from numpy.polynomial.legendre import leggauss, legvander

_HERE = os.path.dirname(os.path.abspath(__file__))
_ROOT = os.path.abspath(os.path.join(_HERE, "..", ".."))
RESULTS = os.path.join(_HERE, "results")

# ---- reuse the instrument (weil_QX.py) for the mpmath reference values, zeros, hplus
_spec = importlib.util.spec_from_file_location("weil_QX", os.path.join(_HERE, "weil_QX.py"))
wq = importlib.util.module_from_spec(_spec)
_spec.loader.exec_module(wq)
from mpmath import mp, mpf, log as mlog  # noqa: E402

EULER = 0.57721566490153286061
LOG4PI = math.log(4 * math.pi)


def _code_version():
    with open(os.path.abspath(__file__), "rb") as fh:
        return hashlib.sha256(fh.read()).hexdigest()


# ------------------------------------------------------------------ bases
def basis_eval(kind, M, h, u):
    """(M, len(u)) array of the orthonormal basis functions at u (zero outside [-h,h])."""
    u = np.asarray(u, dtype=float)
    inside = (u >= -h - 1e-15) & (u <= h + 1e-15)
    if kind == "legendre":
        s = np.clip(u / h, -1.0, 1.0)
        V = legvander(s, M - 1)                              # (len(u), M)
        norms = np.sqrt((2 * np.arange(M) + 1) / (2 * h))
        B = (V * norms).T
    elif kind == "sine":
        k = np.arange(1, M + 1)
        B = np.sin(np.outer(k, np.pi * (u + h) / (2 * h))) / math.sqrt(h)
    else:
        raise ValueError(kind)
    return B * inside[None, :]


def gl_nodes(a, b, n):
    x, w = leggauss(n)
    return (a + b) / 2 + (b - a) / 2 * x, (b - a) / 2 * w


def F_matrices(kind, M, h, xs, nu):
    """F_ij(x) symmetrised: (1/2)(int G_i(u)G_j(u-x)du + int G_j(u)G_i(u-x)du), x >= 0."""
    out = np.zeros((len(xs), M, M))
    for k, x in enumerate(xs):
        a, b = x - h, h
        if b - a <= 0:
            continue
        u, w = gl_nodes(a, b, nu)
        Bu = basis_eval(kind, M, h, u)
        Bux = basis_eval(kind, M, h, u - x)
        Fk = (Bu * w) @ Bux.T
        out[k] = 0.5 * (Fk + Fk.T)
    return out


def build_matrices(kind, M, h, pp, X, npan=None, nx=24, nu=None):
    """Return dict with pole, prime, arch matrices (M x M) plus diagnostics."""
    L = 2 * h
    if npan is None:
        npan = max(8, M // 2)
    if nu is None:
        nu = max(160, 4 * M)
    # F(0) = Gram matrix = identity for an orthonormal basis; measure the deviation
    F0 = F_matrices(kind, M, h, [0.0], nu)[0]
    gram_err = float(np.max(np.abs(F0 - np.eye(M))))
    # pole: 2 a b with a = int G e^{-u/2}, b = int G e^{u/2}
    u, w = gl_nodes(-h, h, nu)
    B = basis_eval(kind, M, h, u)
    a = B @ (w * np.exp(-u / 2))
    b = B @ (w * np.exp(u / 2))
    pole = np.outer(a, b) + np.outer(b, a)
    # prime: 2 sum Lambda(n) n^{-1/2} F(log n), n <= X
    logs = [(math.log(n), lp) for n, lp in pp if n <= X]
    if logs:
        Fn = F_matrices(kind, M, h, [ln for ln, _ in logs], nu)
        prime = np.zeros((M, M))
        for (ln, lp), Fk in zip(logs, Fn):
            prime += 2 * lp * math.exp(-ln / 2) * Fk
    else:
        prime = np.zeros((M, M))
    # arch: real-space form with exact tail, panels on [0, L]
    edges = np.linspace(0.0, L, npan + 1)
    xs, ws = [], []
    for e0, e1 in zip(edges[:-1], edges[1:]):
        xx, ww = gl_nodes(e0, e1, nx)
        xs.append(xx)
        ws.append(ww)
    xs = np.concatenate(xs)
    ws = np.concatenate(ws)
    Fx = F_matrices(kind, M, h, xs, nu)
    core = np.zeros((M, M))
    for x, wgt, Fk in zip(xs, ws, Fx):
        core += wgt * (2 * math.exp(x / 2) * Fk - 2 * F0) / (math.exp(x) - math.exp(-x))
    arch = -(LOG4PI + EULER) * F0 - core + F0 * math.log(1 / math.tanh(L / 2))
    return {"pole": pole, "prime": prime, "arch": arch, "a": a, "b": b,
            "gram_err": gram_err, "n_prime_powers": len(logs),
            "quad": {"npan": npan, "nx": nx, "nu": nu}}


def eig_min(A):
    vals, vecs = np.linalg.eigh(0.5 * (A + A.T))
    return float(vals[0]), vecs[:, 0], vals


# ------------------------------------------------------- transforms at zeros
def spherical_jn_table(nmax, z):
    """j_n(z) for n = 0..nmax at each z (1-d array); upward recurrence for z > nmax+20,
    Miller downward recurrence otherwise.  Returns (nmax+1, len(z))."""
    z = np.asarray(z, dtype=float)
    out = np.empty((nmax + 1, z.size))
    big = z > nmax + 20
    # upward
    if np.any(big):
        zb = z[big]
        j0 = np.sin(zb) / zb
        j1 = np.sin(zb) / zb ** 2 - np.cos(zb) / zb
        col = np.empty((nmax + 1, zb.size))
        col[0] = j0
        if nmax >= 1:
            col[1] = j1
        for n in range(1, nmax):
            col[n + 1] = (2 * n + 1) / zb * col[n] - col[n - 1]
        out[:, big] = col
    # Miller downward
    if np.any(~big):
        zs = z[~big]
        N = nmax + 60 + int(np.max(zs)) if zs.size else nmax + 60
        jp = np.zeros(zs.size)           # j_{N+1}
        jc = np.full(zs.size, 1e-300)    # j_N (arbitrary tiny seed)
        col = np.zeros((nmax + 1, zs.size))
        for n in range(N, 0, -1):
            jm = (2 * n + 1) / zs * jc - jp
            jp, jc = jc, jm
            if n - 1 <= nmax:
                col[n - 1] = jc
            # renormalise to avoid overflow
            scale = np.abs(jc) > 1e200
            if np.any(scale):
                jc[scale] *= 1e-200
                jp[scale] *= 1e-200
                col[:, scale] *= 1e-200
        j0 = np.sin(zs) / zs
        out[:, ~big] = col * (j0 / col[0])[None, :]
    return out


def ghat_closed(kind, M, h, t):
    """(M, len(t)) complex array of Ghat_i(t) = int G_i(u) e^{iut} du."""
    t = np.asarray(t, dtype=float)
    if kind == "legendre":
        J = spherical_jn_table(M - 1, h * t)
        n = np.arange(M)
        return (np.sqrt(2 * h * (2 * n + 1)) * (1j ** n))[:, None] * J
    else:
        k = np.arange(1, M + 1)
        om = k * np.pi / (2 * h)
        sgn = (-1.0) ** k
        num = sgn[:, None] * np.exp(1j * h * t)[None, :] - np.exp(-1j * h * t)[None, :]
        den = t[None, :] ** 2 - om[:, None] ** 2
        near = np.abs(den) < 1e-6
        den_safe = np.where(near, 1.0, den)
        G = om[:, None] * num / den_safe / math.sqrt(h)
        if np.any(near):
            # removable singularity: fall back to quadrature for those entries
            ii, jj = np.nonzero(near)
            Gq = ghat_quad(kind, M, h, t[jj])
            G[ii, jj] = Gq[ii, np.arange(len(jj))]
        return G


def ghat_quad(kind, M, h, t, nodes_per_period=8):
    """Direct composite Gauss-Legendre transform, for cross-checks (small t arrays)."""
    t = np.asarray(t, dtype=float)
    tmax = max(float(np.max(np.abs(t))) if t.size else 1.0, 1.0)
    period = 2 * math.pi / tmax
    width = min(period / 2, h / 16)
    npan = int(math.ceil(2 * h / width))
    edges = np.linspace(-h, h, npan + 1)
    xg, wg = leggauss(16)
    U = ((edges[:-1] + edges[1:]) / 2)[:, None] + ((edges[1:] - edges[:-1]) / 2)[:, None] * xg[None, :]
    W = ((edges[1:] - edges[:-1]) / 2)[:, None] * wg[None, :]
    U, W = U.ravel(), W.ravel()
    B = basis_eval(kind, M, h, U) * W
    out = np.empty((M, t.size), dtype=complex)
    for i in range(0, t.size, 256):
        tt = t[i:i + 256]
        out[:, i:i + 256] = B @ np.exp(1j * np.outer(U, tt))
    return out


def zero_side(kind, M, h, c, gam, chunk=20000):
    """2 sum_k |Ghat(gamma_k)|^2 for G = sum c_i G_i, plus the M x M zero-side matrix."""
    Z = 0.0
    Zmat = np.zeros((M, M))
    for i in range(0, len(gam), chunk):
        Gh = ghat_closed(kind, M, h, gam[i:i + chunk])       # (M, n)
        gc = c @ Gh
        Z += 2 * float(np.sum(np.abs(gc) ** 2))
        Zmat += 2 * np.real(Gh @ Gh.conj().T)
    return Z, Zmat


def gap_matrix(kind, M, h, gamma1, nodes_per_period=12):
    """(1/2pi) int_{-gamma1}^{gamma1} Ghat_i(t) conj(Ghat_j(t)) dt  (real part): the energy
    of G inside the zero-free band |t| < gamma_1.  I - gap is the band-limitation
    leakage form, whose smallest eigenvalue is 1 - lambda_0 of the prolate problem
    with c = h gamma_1, restricted to the M-dim subspace."""
    period = math.pi / h
    npan = int(math.ceil(gamma1 / (period / 2))) + 4
    edges = np.linspace(0.0, gamma1, npan + 1)
    xg, wg = leggauss(nodes_per_period)
    tt = (((edges[:-1] + edges[1:]) / 2)[:, None] + ((edges[1:] - edges[:-1]) / 2)[:, None] * xg[None, :]).ravel()
    tw = (((edges[1:] - edges[:-1]) / 2)[:, None] * wg[None, :]).ravel()
    Gh = ghat_closed(kind, M, h, tt)
    return 2 * np.real((Gh * tw) @ Gh.conj().T) / (2 * math.pi)


def zero_tail(G_end_sq_sum, gam_N):
    """(G(h)^2 + G(-h)^2)/pi (log(gamma_N/2pi) + 1)/gamma_N; = instrument tail for the indicator."""
    return G_end_sq_sum / math.pi * (math.log(gam_N / (2 * math.pi)) + 1) / gam_N


def describe_G(kind, M, h, c, ngrid=2001):
    u = np.linspace(-h, h, ngrid)
    g = c @ basis_eval(kind, M, h, u)
    g2 = g ** 2
    tot = np.trapezoid(g2, u)
    q = lambda lo, hi: float(np.trapezoid(g2[(u >= lo) & (u <= hi)], u[(u >= lo) & (u <= hi)]) / tot)
    even = c @ basis_eval(kind, M, h, -u)
    par_even = float(np.linalg.norm(g - even) / np.linalg.norm(g))
    par_odd = float(np.linalg.norm(g + even) / np.linalg.norm(g))
    parity = "even" if par_even < 1e-6 else ("odd" if par_odd < 1e-6 else "mixed")
    sign_changes = int(np.sum(np.diff(np.sign(g[np.abs(g) > 1e-12 * np.max(np.abs(g))])) != 0))
    imax = int(np.argmax(np.abs(g)))
    return {
        "parity": parity, "parity_resid_even": par_even, "parity_resid_odd": par_odd,
        "mass_central_half": q(-h / 2, h / 2),
        "mass_outer_quarters": q(-h, -h / 2) + q(h / 2, h),
        "mass_central_tenth": q(-h / 10, h / 10),
        "mass_end_tenths": q(-h, -0.8 * h) + q(0.8 * h, h),
        "abs_max_at_u_over_h": float(u[imax] / h),
        "abs_max": float(np.abs(g[imax])),
        "G_at_ends": [float(g[0]), float(g[-1])],
        "G_at_0": float(g[ngrid // 2]),
        "sign_changes": sign_changes,
        "grid_u_over_h": [float(v) for v in np.linspace(-1, 1, 41)],
        "grid_G": [float(v) for v in (c @ basis_eval(kind, M, h, np.linspace(-h, h, 41)))],
    }


# -------------------------------------------------------------------- main
def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    ap.add_argument("--xs", type=str, default="2,2.5,3,3.5,4,5,6,7,8,9,10,12,15,20,30,50,70,100")
    ap.add_argument("--Ms", type=str, default="8,16,32,64")
    ap.add_argument("--bases", type=str, default="legendre,sine")
    ap.add_argument("--zero-check-xs", type=str, default="3,10,100")
    ap.add_argument("--nzeros", type=int, default=2000)
    ap.add_argument("--dps", type=int, default=25)
    ap.add_argument("--out", type=str, default=os.path.join(RESULTS, "weil_rung_min.json"))
    args = ap.parse_args()

    mp.dps = args.dps
    os.makedirs(RESULTS, exist_ok=True)
    started = datetime.datetime.now(datetime.timezone.utc)
    xs = [float(x) for x in args.xs.split(",")]
    Ms = [int(m) for m in args.Ms.split(",")]
    bases = args.bases.split(",")
    zc_xs = [float(x) for x in args.zero_check_xs.split(",")]
    Xmax = max(xs)

    print("weil_rung_min  EXPLORATORY - no prereg, no decision rule, no verdict.")
    print(f"  X ladder={xs}\n  M={Ms}  bases={bases}  zero-side checks at X={zc_xs}")

    # prime powers (same construction as weil_QX.main): (n, Lambda(n) = log p)
    from sympy import primerange
    pp, pp_mp = [], []
    for p in primerange(2, int(Xmax) + 1):
        q, lp, lpm = p, math.log(p), mlog(mpf(p))
        while q <= Xmax:
            pp.append((q, lp))
            pp_mp.append((q, lpm))
            q *= p
    pp.sort()
    pp_mp.sort()
    print(f"  prime powers <= {Xmax:g}: {len(pp)}")
    # the instrument's recorded rows, for the literal unit-test targets
    qx = json.load(open(os.path.join(RESULTS, "weil_QX.json")))
    qx_tri = {r["X"]: r for r in qx["rows"] if r["family"] == "triangle"}
    print(f"  weil_QX.json: triangle prime at X=3 = {qx_tri[3.0]['prime']:.8f}, total at X=10 = {qx_tri[10.0]['total']:.8f}")

    # zeros: cached 2000 (mpmath) + the file
    zcache = os.path.join(RESULTS, f"zetazeros_{args.nzeros}.json")
    gam = np.array([float(g) for g in wq.load_zeros(args.nzeros, zcache)])
    gfile = np.array([float(l.split()[0]) for l in open(wq.ZEROS_FILE)])
    print(f"  zeros: cache {len(gam)} to {gam[-1]:.3f}; file {len(gfile)} to {gfile[-1]:.3f}; "
          f"max |file - cache| on overlap {np.max(np.abs(gfile[:len(gam)] - gam)):.2e}")

    # ================================================================ unit tests
    print("\n===== unit tests =====")
    tests = {}

    # (a) X = 3: prime term for the indicator vs the instrument's mpmath triangle value
    X = 3.0
    L = math.log(X)
    h = L / 2
    fam = wq.Triangle(mlog(mpf(X)))
    ref_prime3, _ = wq.prime_term(fam, X, pp_mp)
    ref_prime3 = float(ref_prime3)
    rec_prime3 = qx_tri[3.0]["prime"]
    print(f"  [X=3] instrument in-process prime {ref_prime3:.10f}; recorded in weil_QX.json {rec_prime3:.10f}"
          f"; triangle value 2 log2 / sqrt2 (L - log 2) = {2*math.log(2)/math.sqrt(2)*(L-math.log(2)):.10f}")
    for kind in bases:
        row = {}
        for M in Ms:
            mats = build_matrices(kind, M, h, pp, X)
            u, w = gl_nodes(-h, h, mats["quad"]["nu"])
            c = basis_eval(kind, M, h, u) @ w             # expansion coeffs of the indicator
            ind_norm2 = float(c @ c)                       # should be 2h = L
            pr = float(c @ mats["prime"] @ c)
            row[str(M)] = {"prime_indicator": pr, "ref": ref_prime3, "recorded": rec_prime3,
                           "discrepancy": pr - ref_prime3, "discrepancy_vs_recorded": pr - rec_prime3,
                           "indicator_coef_norm2": ind_norm2, "L": L,
                           "indicator_L2_deficit": L - ind_norm2}
            print(f"  [X=3] {kind:8s} M={M:2d}  prime(indicator expansion) = {pr:.8f}  ref {ref_prime3:.8f}"
                  f"  disc {pr - ref_prime3:+.2e}   ||indicator_M||^2 = {ind_norm2:.6f} (L = {L:.6f})")
        tests[f"X3_prime_indicator_{kind}"] = row

    # (b) X = 10: total for the indicator vs the instrument's 0.07685392
    X = 10.0
    L = math.log(X)
    h = L / 2
    fam = wq.Triangle(mlog(mpf(X)))
    ref_pole = float(2 * fam.Ghat_i_half() ** 2)
    ref_prime, _ = wq.prime_term(fam, X, pp_mp)
    ref_prime = float(ref_prime)
    ref_arch = float(wq.arch_real(fam))
    ref_total = ref_pole - ref_prime + ref_arch
    rec_total = qx_tri[10.0]["total"]
    print(f"  [X=10] instrument in-process total {ref_total:.10f}; recorded in weil_QX.json {rec_total:.10f}")
    for kind in bases:
        row = {}
        for M in Ms:
            mats = build_matrices(kind, M, h, pp, X)
            u, w = gl_nodes(-h, h, mats["quad"]["nu"])
            c = basis_eval(kind, M, h, u) @ w
            po, pr, ar = (float(c @ mats[k] @ c) for k in ("pole", "prime", "arch"))
            tot = po - pr + ar
            row[str(M)] = {"pole": po, "prime": pr, "arch": ar, "total": tot,
                           "ref": {"pole": ref_pole, "prime": ref_prime, "arch": ref_arch, "total": ref_total},
                           "recorded_total": rec_total,
                           "discrepancy_total": tot - ref_total, "discrepancy_vs_recorded": tot - rec_total,
                           "indicator_coef_norm2": float(c @ c), "L": L,
                           "gram_err": mats["gram_err"]}
            print(f"  [X=10] {kind:8s} M={M:2d}  pole {po:.8f} ({po-ref_pole:+.1e})  prime {pr:.8f} ({pr-ref_prime:+.1e})"
                  f"  arch {ar:.8f} ({ar-ref_arch:+.1e})  total {tot:.8f}  ref {ref_total:.8f}  disc {tot-ref_total:+.2e}"
                  f"  ||indicator_M||^2 = {float(c @ c):.6f} (L = {L:.6f})  gram_err {mats['gram_err']:.1e}")
        tests[f"X10_total_indicator_{kind}"] = row

    # (c) quadrature convergence: M = 16 legendre at X = 10 with doubled nodes
    m1 = build_matrices("legendre", 16, h, pp, X)
    m2 = build_matrices("legendre", 16, h, pp, X, npan=32, nx=48, nu=512)
    qc = {k: float(np.max(np.abs(m1[k] - m2[k]))) for k in ("pole", "prime", "arch")}
    tests["quadrature_doubling_X10_legendre_M16"] = qc
    print(f"  [X=10] quadrature doubling (legendre M=16): max |dQ| pole {qc['pole']:.1e} prime {qc['prime']:.1e} arch {qc['arch']:.1e}")
    m1 = build_matrices("sine", 64, h, pp, X)
    m2 = build_matrices("sine", 64, h, pp, X, npan=64, nx=48, nu=512)
    qc2 = {k: float(np.max(np.abs(m1[k] - m2[k]))) for k in ("pole", "prime", "arch")}
    tests["quadrature_doubling_X10_sine_M64"] = qc2
    print(f"  [X=10] quadrature doubling (sine M=64):     max |dQ| pole {qc2['pole']:.1e} prime {qc2['prime']:.1e} arch {qc2['arch']:.1e}")

    # (d) arch matrix, Fourier side: (1/2pi) int |Ghat_i|^2 hplus dt + tail, diagonal, legendre M=8
    mats = build_matrices("legendre", 8, h, pp, X)
    T = 2000.0
    period = math.pi / h
    npan = int(math.ceil(T / (period / 4)))
    edges = np.linspace(0.0, T, npan + 1)
    xg, wg = leggauss(12)
    tt = (((edges[:-1] + edges[1:]) / 2)[:, None] + ((edges[1:] - edges[:-1]) / 2)[:, None] * xg[None, :]).ravel()
    tw = (((edges[1:] - edges[:-1]) / 2)[:, None] * wg[None, :]).ravel()
    hp = np.array([float(wq.hplus(mpf(t))) for t in tt])
    Gh = ghat_closed("legendre", 8, h, tt)
    Gend = basis_eval("legendre", 8, h, np.array([-h, h]))
    fdiag = []
    for i in range(8):
        val = 2 * float(np.sum(np.abs(Gh[i]) ** 2 * hp * tw)) / (2 * math.pi)
        tail = (Gend[i, 0] ** 2 + Gend[i, 1] ** 2) / math.pi * (math.log(T / (2 * math.pi)) + 1) / T
        fdiag.append({"i": i, "arch_real": float(mats["arch"][i, i]), "arch_fourier": val,
                      "tail": tail, "diff": float(mats["arch"][i, i]) - val - tail})
        print(f"  [X=10] arch diag i={i}: real {mats['arch'][i,i]:.8f}  Fourier(T=2000) {val:.8f} + tail {tail:.2e}"
              f"  diff {mats['arch'][i,i]-val-tail:+.2e}")
    tests["arch_fourier_diag_X10_legendre_M8"] = fdiag

    # (e) closed-form transforms vs quadrature at 40 sample t, both bases, M = 64
    tsamp = np.concatenate([np.linspace(0.3, 60, 30), gam[:10]])
    for kind in bases:
        Gc = ghat_closed(kind, 64, h, tsamp)
        Gq = ghat_quad(kind, 64, h, tsamp)
        err = float(np.max(np.abs(Gc - Gq)))
        tests[f"ghat_closed_vs_quad_{kind}_M64"] = err
        print(f"  Ghat closed-form vs quadrature ({kind}, M=64, 40 t in [0.3, 60]): max abs err {err:.2e}")
    # Bessel table vs quadrature deep in the Miller regime and at large z
    zt = np.array([5.0, 20.0, 80.0, 90.0, 5000.0])
    Jt = spherical_jn_table(63, zt)
    Gq = ghat_quad("legendre", 64, 1.0, zt)
    n = np.arange(64)
    Jq = np.real(Gq / (np.sqrt(2 * (2 * n + 1)) * (1j ** n))[:, None])
    errJ = float(np.max(np.abs(Jt - Jq)))
    tests["spherical_jn_vs_quad_max_abs_err"] = errJ
    print(f"  spherical j_n (n<=63) recurrence vs quadrature at z={zt.tolist()}: max abs err {errJ:.2e}")

    # (f) identity check for a random (asymmetric) G at X = 10, legendre M = 8
    rng = np.random.default_rng(2026)
    c = rng.standard_normal(8)
    c /= np.linalg.norm(c)
    Qrand = float(c @ (mats["pole"] - mats["prime"] + mats["arch"]) @ c)
    Zr, _ = zero_side("legendre", 8, h, c, gfile)
    gend = c @ Gend
    tailr = zero_tail(float(gend[0] ** 2 + gend[1] ** 2), gfile[-1])
    tests["random_G_identity_X10_legendre_M8"] = {"Q": Qrand, "Z_file": Zr, "tail": tailr, "resid": Qrand - Zr - tailr,
                                                  "pole_term": float(c @ mats["pole"] @ c)}
    print(f"  random asymmetric G (X=10, legendre M=8): Q = {Qrand:.8f}  Z_file = {Zr:.8f} + tail {tailr:.2e}"
          f"  resid {Qrand - Zr - tailr:+.2e}   (pole term {float(c @ mats['pole'] @ c):+.6f})")

    # ================================================================ the ladder
    print("\n===== ladder =====")
    print("  floor = 2.2e-16 * (||pole||+||prime||+||arch||), the roundoff of the three-term cancellation;")
    print("  gap_leak = lam_min of the band-limitation form (energy outside |t| < gamma_1), no arithmetic in it.")
    rows = []
    gamma1 = float(gam[0])
    hdr = (f"{'X':>6} {'basis':>8} {'M':>3} {'lam_min(Q)':>13} {'floor':>9} {'lam_min(Q0)':>13} {'||P||op':>11} "
           f"{'||P||/lam0':>10} {'gap_leak':>10} {'E_gap(G*)':>10} {'parity':>6} {'m_half':>7} {'npp':>4}")
    print(hdr)
    for X in xs:
        L = math.log(X)
        h = L / 2
        for kind in bases:
            for M in Ms:
                t0 = time.time()
                mats = build_matrices(kind, M, h, pp, X)
                Q = mats["pole"] - mats["prime"] + mats["arch"]
                Q0 = mats["pole"] + mats["arch"]
                lam, vec, vals = eig_min(Q)
                lam0, vec0, vals0 = eig_min(Q0)
                pvals = np.linalg.eigvalsh(0.5 * (mats["prime"] + mats["prime"].T))
                pnorm = float(np.max(np.abs(pvals)))
                # Q is a cancellation of three terms each O(pole); double-precision roundoff in that
                # cancellation is eps * (sum of the three operator norms), which dominates the
                # eigenvalue resolution of the assembled Q.
                term_norms = sum(float(np.max(np.abs(np.linalg.eigvalsh(0.5 * (mats[k] + mats[k].T)))))
                                 for k in ("pole", "prime", "arch"))
                floor = 2.2e-16 * term_norms
                pmin, pmax = float(pvals[0]), float(pvals[-1])
                desc = describe_G(kind, M, h, vec)
                gap = gap_matrix(kind, M, h, gamma1)
                gap_leak = 1.0 - float(np.linalg.eigvalsh(0.5 * (gap + gap.T))[-1])
                e_gap = float(vec @ gap @ vec)
                # component values at the minimiser
                terms = {k: float(vec @ mats[k] @ vec) for k in ("pole", "prime", "arch")}
                rows.append({
                    "X": X, "L": L, "h": h, "basis": kind, "M": M,
                    "lam_min": lam, "roundoff_floor": floor,
                    "lam_min_negative": bool(lam < 0), "lam_min_below_10x_floor": bool(abs(lam) < 10 * floor),
                    "lam_min_noprime": lam0,
                    "prime_opnorm": pnorm, "prime_eig_min": pmin, "prime_eig_max": pmax,
                    "ratio_prime_over_noprime": pnorm / lam0 if lam0 != 0 else None,
                    "gap_leak_min": gap_leak, "energy_in_gap_at_minimiser": e_gap,
                    "terms_at_minimiser": terms,
                    "eig_low5": [float(v) for v in vals[:5]],
                    "eig_noprime_low5": [float(v) for v in vals0[:5]],
                    "eig_max": float(vals[-1]),
                    "gram_err": mats["gram_err"], "n_prime_powers": mats["n_prime_powers"],
                    "quad": mats["quad"],
                    "minimiser_coeffs": [float(v) for v in vec],
                    "minimiser": desc,
                    "seconds": time.time() - t0,
                })
                print(f"{X:>6g} {kind:>8} {M:>3d} {lam:>13.4e} {floor:>9.1e} {lam0:>13.8f} {pnorm:>11.6f} "
                      f"{pnorm/lam0:>10.4f} {gap_leak:>10.3e} {e_gap:>10.6f} {desc['parity']:>6} "
                      f"{desc['mass_central_half']:>7.4f} {mats['n_prime_powers']:>4d}   [{time.time()-t0:.1f}s]")

    # ================================================================ zero-side cross-checks
    print("\n===== zero-side cross-checks at the minimiser (largest M) =====")
    Mbig = max(Ms)
    zchecks = []
    for X in zc_xs:
        L = math.log(X)
        h = L / 2
        for kind in bases:
            r = next(r for r in rows if r["X"] == X and r["basis"] == kind and r["M"] == Mbig)
            c = np.array(r["minimiser_coeffs"])
            ZN, ZmatN = zero_side(kind, Mbig, h, c, gam)
            Zf, Zmatf = zero_side(kind, Mbig, h, c, gfile)
            gend = c @ basis_eval(kind, Mbig, h, np.array([-h, h]))
            e2 = float(gend[0] ** 2 + gend[1] ** 2)
            tailN = zero_tail(e2, gam[-1])
            tailf = zero_tail(e2, gfile[-1])
            # last included term, as the tail proxy for the sine basis (Ghat ~ 1/t^2)
            last = 2 * float(np.abs(c @ ghat_closed(kind, Mbig, h, gfile[-1:]))[0] ** 2)
            lamZN = float(np.linalg.eigvalsh(ZmatN)[0])
            lamZf = float(np.linalg.eigvalsh(Zmatf)[0])
            # also the zero-side quadratic form on the 2000 cached zeros via quadrature (independent transform)
            Gq = ghat_quad(kind, Mbig, h, gam)
            ZN_quad = 2 * float(np.sum(np.abs(c @ Gq) ** 2))
            # where the zero-side sum comes from: first 10 zeros vs the rest
            Gh10 = c @ ghat_closed(kind, Mbig, h, gam[:10])
            Z10 = 2 * float(np.sum(np.abs(Gh10) ** 2))
            zchecks.append({
                "X": X, "basis": kind, "M": Mbig, "lam_min": r["lam_min"], "roundoff_floor": r["roundoff_floor"],
                "Z_N": ZN, "N": len(gam), "gamma_N": float(gam[-1]), "tail_N": tailN,
                "resid_N": r["lam_min"] - ZN - tailN,
                "Z_N_quadrature_transform": ZN_quad, "Z_N_closed_minus_quad": ZN - ZN_quad,
                "Z_file": Zf, "N_file": len(gfile), "gamma_file": float(gfile[-1]), "tail_file": tailf,
                "resid_file": r["lam_min"] - Zf - tailf,
                "Z_first10": Z10, "per_zero_2absGhat2_first10": [2 * float(abs(v) ** 2) for v in Gh10],
                "last_term_file": last, "G_ends_sq_sum": e2,
                "lam_min_zero_matrix_N": lamZN, "lam_min_zero_matrix_file": lamZf,
                "lam_min_zero_matrix_file_minus_lam_min": lamZf - r["lam_min"],
                "energy_in_gap_at_minimiser": r["energy_in_gap_at_minimiser"],
            })
            print(f"  X={X:g} {kind:8s} M={Mbig}: lam_min {r['lam_min']:.6e}  (floor {r['roundoff_floor']:.1e})")
            print(f"      Z_2000 {ZN:.6e} + tail {tailN:.2e} -> resid {r['lam_min']-ZN-tailN:+.2e}"
                  f"   (closed-form vs quadrature transform: {ZN-ZN_quad:+.1e})")
            print(f"      Z_file {Zf:.6e} + tail {tailf:.2e} -> resid {r['lam_min']-Zf-tailf:+.2e}"
                  f"   last term {last:.1e}   G(-h)^2+G(h)^2 = {e2:.3e}   first-10-zero share {Z10:.3e}")
            print(f"      lam_min of the zero-side matrix: 2000 zeros {lamZN:.6e}, file {lamZf:.6e}"
                  f"  (file - lam_min(Q) = {lamZf - r['lam_min']:+.2e});  energy of G* inside |t|<gamma_1: {r['energy_in_gap_at_minimiser']:.10f}")

    print("\n===== minimiser shape at largest M =====")
    for X in zc_xs:
        for kind in bases:
            r = next(r for r in rows if r["X"] == X and r["basis"] == kind and r["M"] == Mbig)
            d = r["minimiser"]
            print(f"  X={X:g} {kind:8s} parity {d['parity']}  |G|max at u/h={d['abs_max_at_u_over_h']:+.3f}  "
                  f"G(0)={d['G_at_0']:+.4f}  G(-h),G(h)={d['G_at_ends'][0]:+.2e},{d['G_at_ends'][1]:+.2e}  "
                  f"mass central half {d['mass_central_half']:.4f}, central tenth {d['mass_central_tenth']:.4f}, "
                  f"end tenths {d['mass_end_tenths']:.2e}, sign changes {d['sign_changes']}")
            print("    G(u/h=-1..1): " + " ".join(f"{v:+.3f}" for v in d["grid_G"][::2]))

    # ================================================================ summary + outputs
    neg = [r for r in rows if r["lam_min"] < 0]
    by_X = {}
    for X in xs:
        d = {"X": X, "L": math.log(X)}
        for kind in bases:
            seq = [next(r for r in rows if r["X"] == X and r["basis"] == kind and r["M"] == M) for M in Ms]
            d[kind] = {
                "lam_min_by_M": {str(M): s["lam_min"] for M, s in zip(Ms, seq)},
                "lam_min_noprime_by_M": {str(M): s["lam_min_noprime"] for M, s in zip(Ms, seq)},
                "prime_opnorm_by_M": {str(M): s["prime_opnorm"] for M, s in zip(Ms, seq)},
                "lam_min": seq[-1]["lam_min"], "roundoff_floor": seq[-1]["roundoff_floor"],
                "lam_min_noprime": seq[-1]["lam_min_noprime"],
                "prime_opnorm": seq[-1]["prime_opnorm"],
                "ratio": seq[-1]["ratio_prime_over_noprime"],
                "gap_leak_min": seq[-1]["gap_leak_min"],
                "energy_in_gap_at_minimiser": seq[-1]["energy_in_gap_at_minimiser"],
                "parity": seq[-1]["minimiser"]["parity"],
                "mass_central_half": seq[-1]["minimiser"]["mass_central_half"],
                "abs_max_at_u_over_h": seq[-1]["minimiser"]["abs_max_at_u_over_h"],
            }
        if len(bases) == 2:
            d["basis_gap_lam_min"] = d[bases[0]]["lam_min"] - d[bases[1]]["lam_min"]
        by_X[str(X)] = d

    ended = datetime.datetime.now(datetime.timezone.utc)
    payload = {
        "schema_version": "1",
        "script": os.path.abspath(__file__),
        "generated_utc": ended.strftime("%Y-%m-%dT%H:%M:%SZ"),
        "status": "EXPLORATORY - no prereg, no decision rule, no verdict.",
        "params": {"code_version": _code_version(), "xs": xs, "Ms": Ms, "bases": bases,
                   "zero_check_xs": zc_xs, "nzeros": args.nzeros, "dps": args.dps,
                   "zeros_file": wq.ZEROS_FILE, "zeros_cache": zcache,
                   "instrument": os.path.join(_HERE, "weil_QX.py"),
                   "run_start_at": started.strftime("%Y-%m-%dT%H:%M:%SZ"),
                   "run_end_at": ended.strftime("%Y-%m-%dT%H:%M:%SZ")},
        "constants": {
            "functional": "Q_L(G) = pole - prime + arch = sum_rho Fhat(rho), F = G*G~, supp G = [-L/2, L/2], L = log X",
            "pole": "2 a b, a = int G e^{-u/2}, b = int G e^{u/2}  (= 2 Ghat(i/2)^2 for even G; < 0 for odd G)",
            "prime": "2 sum_{n<=X} Lambda(n) n^{-1/2} F(log n)",
            "arch": "-(log 4pi+gamma)F(0) - int_0^L (2e^{x/2}F(x)-2F(0))/(e^x-e^{-x}) dx + F(0) log coth(L/2)   [weil_QX.arch_real]",
            "lam_min": "smallest eigenvalue of the M x M matrix of Q_L in an orthonormal basis of L2[-L/2, L/2]; >= inf_G Q_L(G)/||G||^2",
            "bases": {"legendre": "sqrt((2n+1)/(2h)) P_n(u/h), n=0..M-1", "sine": "h^{-1/2} sin(k pi (u+h)/(2h)), k=1..M"},
            "zero_side": "2 sum_k |Ghat(gamma_k)|^2 (+ tail (G(h)^2+G(-h)^2)/pi (log(gamma_N/2pi)+1)/gamma_N)",
        },
        "summary": {
            "n_rows": len(rows),
            "negative_lam_min_rows": [{"X": r["X"], "basis": r["basis"], "M": r["M"], "lam_min": r["lam_min"],
                                       "roundoff_floor": r["roundoff_floor"],
                                       "within_10x_floor": r["lam_min_below_10x_floor"]} for r in neg],
            "negative_rows_beyond_10x_floor": [{"X": r["X"], "basis": r["basis"], "M": r["M"], "lam_min": r["lam_min"],
                                                "roundoff_floor": r["roundoff_floor"]}
                                               for r in neg if not r["lam_min_below_10x_floor"]],
            "min_lam_min_over_ladder": min(r["lam_min"] for r in rows),
            "gamma1": gamma1,
            "max_abs_zero_resid_file": max(abs(z["resid_file"]) for z in zchecks) if zchecks else None,
            "max_abs_basis_gap_lam_min": max(abs(d["basis_gap_lam_min"]) for d in by_X.values()) if len(bases) == 2 else None,
            "by_X": by_X,
        },
        "unit_tests": tests,
        "zero_checks": zchecks,
        "rows": rows,
    }
    with open(args.out, "w") as fh:
        json.dump(payload, fh, indent=1)
    print(f"\n  results written to {args.out}")

    txt = os.path.join(_HERE, "weil_rung_min.txt")
    with open(txt, "w") as fh:
        fh.write("weil_rung_min  EXPLORATORY - no prereg, no decision rule, no verdict.\n")
        fh.write(f"generated {payload['generated_utc']}  code_version {payload['params']['code_version'][:16]}\n")
        fh.write("Q_L(G) = pole - prime + arch on G in L2[-L/2, L/2], L = log X; lam_min relative to ||G||_2 = 1.\n")
        fh.write("Q0 = pole + arch (no primes); ||P||op = operator norm of the prime term alone.\n")
        fh.write("floor = 2.2e-16 (||pole||+||prime||+||arch||) (roundoff of the three-term cancellation); gap_leak = lam_min of the band-limitation form\n")
        fh.write(f"(energy outside |t| < gamma_1 = {gamma1:.6f}), no arithmetic in it; E_gap = energy of the minimiser inside |t| < gamma_1;\n")
        fh.write("m_half = fraction of ||G*||^2 in the central half of the support.\n\n")
        for kind in bases:
            fh.write(f"basis: {kind}   (values at M = {Mbig}; convergence columns are lam_min(Q) at M = {Ms})\n")
            fh.write(f"{'X':>6} {'L':>7} {'lam_min(Q)':>12} {'floor':>8} {'lam_min(Q0)':>12} {'||P||op':>10} {'||P||/lam0':>10} "
                     f"{'gap_leak':>10} {'E_gap':>12} {'parity':>6} {'m_half':>7} " + " ".join(f"{'M='+str(M):>11}" for M in Ms) + "\n")
            for X in xs:
                d = by_X[str(X)][kind]
                fh.write(f"{X:>6g} {math.log(X):>7.4f} {d['lam_min']:>12.4e} {d['roundoff_floor']:>8.1e} {d['lam_min_noprime']:>12.7f} "
                         f"{d['prime_opnorm']:>10.6f} {d['ratio']:>10.4f} {d['gap_leak_min']:>10.3e} {d['energy_in_gap_at_minimiser']:>12.10f} "
                         f"{d['parity']:>6} {d['mass_central_half']:>7.4f} "
                         + " ".join(f"{d['lam_min_by_M'][str(M)]:>11.4e}" for M in Ms) + "\n")
            fh.write("\n")
        if len(bases) == 2:
            fh.write(f"basis gap at M={Mbig}: max |lam_min(legendre) - lam_min(sine)| = "
                     f"{payload['summary']['max_abs_basis_gap_lam_min']:.2e}\n")
        fh.write(f"negative lam_min rows: {len(neg)} of {len(rows)}; beyond 10x the roundoff floor: "
                 f"{len(payload['summary']['negative_rows_beyond_10x_floor'])}\n")
        for r in neg:
            fh.write(f"  X={r['X']:g} {r['basis']:8s} M={r['M']:2d} lam_min {r['lam_min']:+.3e} floor {r['roundoff_floor']:.1e}\n")
        fh.write("\nunit tests\n")
        for kind in bases:
            for M in Ms:
                t = tests[f"X3_prime_indicator_{kind}"][str(M)]
                fh.write(f"  X=3  {kind:8s} M={M:2d} prime(indicator_M) {t['prime_indicator']:.8f} ref {t['ref']:.8f} "
                         f"disc {t['discrepancy']:+.2e}  ||indicator_M||^2 {t['indicator_coef_norm2']:.6f} (L {t['L']:.6f})\n")
        for kind in bases:
            for M in Ms:
                t = tests[f"X10_total_indicator_{kind}"][str(M)]
                fh.write(f"  X=10 {kind:8s} M={M:2d} total(indicator_M) {t['total']:.8f} ref {t['ref']['total']:.8f} "
                         f"disc {t['discrepancy_total']:+.2e}  ||indicator_M||^2 {t['indicator_coef_norm2']:.6f} (L {t['L']:.6f})\n")
        fh.write(f"  random asymmetric G identity resid (X=10, legendre M=8): {tests['random_G_identity_X10_legendre_M8']['resid']:+.2e}\n")
        fh.write(f"  arch real-space vs Fourier(T=2000)+tail, legendre M=8 diagonal at X=10: max |diff| "
                 f"{max(abs(d['diff']) for d in tests['arch_fourier_diag_X10_legendre_M8']):.2e}\n")
        fh.write(f"  quadrature doubling max |dQ|: legendre M=16 {max(tests['quadrature_doubling_X10_legendre_M16'].values()):.1e}, "
                 f"sine M=64 {max(tests['quadrature_doubling_X10_sine_M64'].values()):.1e}\n\n")
        fh.write("zero-side cross-checks at the minimiser\n")
        for z in zchecks:
            fh.write(f"  X={z['X']:g} {z['basis']:8s} lam_min {z['lam_min']:.4e} (floor {z['roundoff_floor']:.1e})"
                     f"  Z_2000 {z['Z_N']:.4e}+{z['tail_N']:.1e} resid {z['resid_N']:+.1e}"
                     f"  Z_file {z['Z_file']:.4e}+{z['tail_file']:.1e} resid {z['resid_file']:+.1e}"
                     f"  lam_min(Zmat_file) {z['lam_min_zero_matrix_file']:.4e}  E_gap {z['energy_in_gap_at_minimiser']:.10f}\n")
        fh.write("\nminimiser shape at largest M (G on 41 points u/h = -1..1)\n")
        for X in zc_xs:
            for kind in bases:
                r = next(r for r in rows if r["X"] == X and r["basis"] == kind and r["M"] == Mbig)
                d = r["minimiser"]
                fh.write(f"  X={X:g} {kind:8s} parity {d['parity']} |G|max at u/h={d['abs_max_at_u_over_h']:+.3f} "
                         f"G(0)={d['G_at_0']:+.4f} G(+-h)={d['G_at_ends'][0]:+.2e},{d['G_at_ends'][1]:+.2e} "
                         f"mass: central half {d['mass_central_half']:.4f}, central tenth {d['mass_central_tenth']:.4f}, "
                         f"end tenths {d['mass_end_tenths']:.2e}, sign changes {d['sign_changes']}\n")
                fh.write("    " + " ".join(f"{v:+.3f}" for v in d["grid_G"]) + "\n")
    print(f"  table written to {txt}")
    print("\nEXPLORATORY - no prereg, no decision rule, no verdict.")


if __name__ == "__main__":
    main()
