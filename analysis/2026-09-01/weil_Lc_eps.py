"""weil_Lc_eps.py — support length L_c(eps) at which the restricted Weil form first
detects the first zero pair moved off the line to 1/2 +- eps +- i gamma_1.
EXPLORATORY.  No prereg, no decision rule, no verdict.

Reuses weil_rung_min.py (Legendre basis, spherical-Bessel Ghat, zero loading, tail
estimate) and weil_QX.py (Bombieri 2000 eq. 12.2 normalisation, ZEROS_FILE).

ZERO SIDE ONLY
--------------
The arithmetic side (pole - prime + arch, the true primes) is untouched.  The form
under study is the zero side with the first pair's term replaced:

    Q_eps(G) = Z'(G) + tail(G) + T_eps(G),
    Z'(G)    = 2 sum_{k>=2} |Ghat(gamma_k)|^2      (zeros 2..100000 of zeros1.txt)
    tail(G)  = (G(h)^2 + G(-h)^2)/pi (log(gamma_N/2pi) + 1)/gamma_N   [weil_rung_min.zero_tail]
    T_eps(G) = the moved pair's term (below);  T_0(G) = 2 |Ghat(gamma_1)|^2.

so that Q_0 = Z' + tail + 2|Ghat(gamma_1)|^2 is the zero side of weil_rung_min, and
Q_eps = Q_0 - (true first pair) + (moved pair).  G real, supp G = [-h, h], h = L/2.

THE MOVED PAIR'S TERM (derivation, in the instrument's normalisation)
--------------------------------------------------------------------
Additive variable, Ghat(t) = int G(u) e^{iut} du, continued to complex t; the Weil
sum is sum_rho ghat(rho) ghat(1-rho) with ghat(s) = int G(u) e^{(s-1/2)u} du, so
ghat(1/2 + it) = Ghat(t) and, for complex s, ghat(s) = Ghat(-i(s - 1/2)).
F = G * G~ has Fhat(t) = Ghat(t) Ghat(-t) (even in t), and for real G
conj(Ghat(t)) = Ghat(-conj t).

The four points 1/2 +- eps +- i gamma_1 have t = -i(rho - 1/2) in
    {gamma_1 - i eps,  -gamma_1 - i eps,  gamma_1 + i eps,  -gamma_1 + i eps}
and Fhat at them is, using evenness and the conjugation rule,
    Fhat(gamma_1 - i eps) = Ghat(gamma_1 - i eps) conj(Ghat(gamma_1 + i eps)),
    Fhat(gamma_1 + i eps) = conj of the same,
each appearing twice.  Hence

    sum over the four points, unit multiplicity  = 4 Re[ Ghat(g1 - i eps) conj Ghat(g1 + i eps) ],

and with A = (Ghat(g1 - i eps) + Ghat(g1 + i eps))/2 = int G(u) cosh(eps u) e^{i u g1} du,
         B = (Ghat(g1 - i eps) - Ghat(g1 + i eps))/2 = int G(u) sinh(eps u) e^{i u g1} du,
    Re[ Ghat(g1 - i eps) conj Ghat(g1 + i eps) ] = |A|^2 - |B|^2       (real, as required).

Multiplicity.  A simple pair 1/2 +- i gamma_1 carries two zeros; the four points of
the quadruple carry four.  The unit-multiplicity four-point sum at eps = 0 is
4|Ghat(gamma_1)|^2, TWICE the pair's term — the brief's eps = 0 test (must equal
2|Ghat(gamma_1)|^2) fails for it by exactly the factor 2 (unit test [D0] below
records both numbers).  The multiplicity-conserving move — the pair's two zeros
become the four points with weight 1/2 each, equivalently the pair {rho, conj rho}
moves to {rho', conj rho'} with rho' = 1/2 + eps + i gamma_1 (entry 297's move
formula 2Re[ghat(rho')ghat(1-rho')]) — is

    T_eps(G) = 2 Re[ Ghat(gamma_1 - i eps) conj Ghat(gamma_1 + i eps) ] = 2(|A|^2 - |B|^2),

which equals 2|Ghat(gamma_1)|^2 at eps = 0.  T_eps is the primary term of this
script; the unit-multiplicity quadruple is 2 T_eps and its L_c is reported as a
secondary column (weight w = 1 per point vs the primary w = 1/2).

As a matrix in the orthonormal Legendre basis G_n = sqrt((2n+1)/(2h)) P_n(u/h):
    T_eps = 2 ( Re[A A^H] - Re[B B^H] ),   A_n, B_n the transforms above,
computed in mpmath by Gauss-Legendre quadrature (384 nodes, exact for the polynomial
x entire integrand to the working precision) and checked against the spherical-
Bessel closed form Ghat_n(t) = sqrt(2h(2n+1)) i^n j_n(h t) at complex t.

PRECISION
---------
The eps-effect at small L is far below double precision (the RH minimum is 1e-13
at L = 1.4 and falls super-exponentially), and a double-precision zero-side matrix
has spurious eigenvalues at -1e-14 (weil_rung_min zero checks).  So:
  * Z' is the Gram matrix 2 R^T R of the (N-1) x M array R of Ghat_n(gamma_k) (k>=2),
    with R in double precision but the Gram accumulated in DOUBLE-DOUBLE arithmetic
    (Dekker TwoProd / Knuth TwoSum, ~1e-32 relative) and then lifted to mpmath.
    A Gram matrix of any R is positive semidefinite, so Z' cannot manufacture a
    negative eigenvalue; the only error is the O(1e-16) relative perturbation of
    the entries of R, which perturbs Z'(G) by at most
        2 ||R G|| ||dR G|| <= 2 sqrt(Z'(G)/2) * 1e-15 * sqrt(tr Z'/2)
    (1e-15 = the validated accuracy of the spherical-Bessel table).  That is the
    roundoff FLOOR used for the sign call: lam_min counts as negative only if
    lam_min < -max(floor(G*), floor_rel * max|Q|).  At the eps = 0 control this
    predicts |lam| ~ 1e-32 at L = 8 where the true value is 1e-34, and the smoke
    run saw -4.3e-32 there — the model is the right size.
  * tail, T_eps and the first pair's term are built in mpmath at the working
    precision (gamma_1 from mp.zetazero(1)); zero 1 is EXCLUDED from R so that the
    double-precision pair term is never subtracted from a high-precision one.
  * eigenvalues via mp.eigsy at dps >= 30.  The Legendre basis makes every term
    block-diagonal by parity (Ghat_n is real for even n, imaginary for odd n;
    cosh/sinh weights preserve/flip parity), so the two parity blocks are solved
    separately and the minimiser is exactly even or exactly odd.

GRID
----
eps in {0.001, 0.003, 0.01, 0.02, 0.05, 0.1, 0.2} (+ eps = 0 control), L on a
geometric grid 0.3 .. 8 (ratio 1.1466, 25 points), M = 16, 32 (64 by --Ms);
once lambda_min changes sign between grid neighbours the bracket is bisected
(geometric midpoints) to ratio < 1.02.  L_c(eps) = the first bracketed L with
lambda_min < 0; lambda_min is also evaluated at 1.5 L_c and 2 L_c.

HOW IT WAS RUN
--------------
    cd /Users/juliansambrano/GitHub/Primebeat_081426
    .venv/bin/python analysis/2026-09-01/weil_Lc_eps.py 2>&1 | tee analysis/2026-09-01/results/weil_Lc_eps.log

Outputs: analysis/2026-09-01/results/weil_Lc_eps.json, analysis/2026-09-01/weil_Lc_eps.txt
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
from numpy.polynomial.legendre import leggauss

from mpmath import mp, mpf, mpc, matrix as mpmatrix

_HERE = os.path.dirname(os.path.abspath(__file__))
_ROOT = os.path.abspath(os.path.join(_HERE, "..", ".."))
RESULTS = os.path.join(_HERE, "results")


def _load(name):
    spec = importlib.util.spec_from_file_location(name, os.path.join(_HERE, name + ".py"))
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


wr = _load("weil_rung_min")     # Legendre basis, spherical Bessel table, zero_tail, describe_G, gap_matrix
wq = _load("weil_QX")           # ZEROS_FILE, load_zeros


def _code_version():
    with open(os.path.abspath(__file__), "rb") as fh:
        return hashlib.sha256(fh.read()).hexdigest()


# ------------------------------------------------------------ closed-form Ghat, exact phases
_PHASE = np.array([1.0 + 0j, 1j, -1.0 + 0j, -1j])


def ghat_legendre(M, h, t):
    """(M, len(t)) complex: Ghat_n(t) = sqrt(2h(2n+1)) i^n j_n(h t), i^n taken EXACTLY from
    the 4-cycle so even n are exactly real and odd n exactly imaginary (weil_rung_min's
    1j**n has 1e-16 leakage across parity)."""
    t = np.asarray(t, dtype=float)
    J = wr.spherical_jn_table(M - 1, h * t)
    n = np.arange(M)
    return (np.sqrt(2 * h * (2 * n + 1)) * _PHASE[n % 4])[:, None] * J


# ------------------------------------------------------------ double-double Gram
_SPLIT = 134217729.0   # 2^27 + 1


def _two_prod(a, b):
    p = a * b
    ah = a * _SPLIT
    ah = ah - (ah - a)
    al = a - ah
    bh = b * _SPLIT
    bh = bh - (bh - b)
    bl = b - bh
    e = ((ah * bh - p) + ah * bl + al * bh) + al * bl
    return p, e


def _two_sum(a, b):
    s = a + b
    bb = s - a
    e = (a - (s - bb)) + (b - bb)
    return s, e


def dd_sum0(x):
    """Double-double sum along axis 0 of a float64 array: returns (hi, lo) arrays."""
    hi = np.array(x, dtype=float, copy=True)
    lo = np.zeros_like(hi)
    while hi.shape[0] > 1:
        n = hi.shape[0]
        if n % 2:
            hi = np.concatenate([hi, np.zeros((1,) + hi.shape[1:])], axis=0)
            lo = np.concatenate([lo, np.zeros((1,) + lo.shape[1:])], axis=0)
            n += 1
        m = n // 2
        s, e = _two_sum(hi[:m], hi[m:])
        hi = s
        lo = lo[:m] + lo[m:] + e
    s, e = _two_sum(hi[0], lo[0])
    return s, e


def dd_gram(R):
    """R (N, m) float64 -> (hi, lo) of R^T R, each (m, m), accumulated in double-double."""
    N, m = R.shape
    hi = np.zeros((m, m))
    lo = np.zeros((m, m))
    for i in range(m):
        p, e = _two_prod(R[:, i:i + 1], R[:, i:])
        s, t = dd_sum0(p)
        es = np.sum(e, axis=0)          # error terms ~1e-16 relative; plain sum is enough
        s2, t2 = _two_sum(s, t + es)
        hi[i, i:] = s2
        lo[i, i:] = t2
        hi[i:, i] = s2
        lo[i:, i] = t2
    return hi, lo


def to_mp(hi, lo):
    m = hi.shape[0]
    A = mpmatrix(m, m)
    for i in range(m):
        for j in range(m):
            A[i, j] = mpf(float(hi[i, j])) + mpf(float(lo[i, j]))
    return A


# ------------------------------------------------------------ zero side in parity blocks
def zero_side_dd(M, h, gam, chunk=25000):
    """Z = 2 sum_k Re[Ghat_i(gamma_k) conj Ghat_j(gamma_k)] over the given zeros, as mp matrix
    (double-double accumulated).  Even n: Ghat real; odd n: Ghat imaginary; cross-parity
    entries are exactly zero."""
    hi = np.zeros((M, M))
    lo = np.zeros((M, M))
    ev = np.arange(0, M, 2)
    od = np.arange(1, M, 2)
    parts = []
    for i in range(0, len(gam), chunk):
        Gh = ghat_legendre(M, h, gam[i:i + chunk])
        parts.append((np.ascontiguousarray(Gh[ev].real.T), np.ascontiguousarray(Gh[od].imag.T)))
    Re = np.concatenate([p[0] for p in parts], axis=0)
    Im = np.concatenate([p[1] for p in parts], axis=0)
    he, le = dd_gram(Re)
    ho, lo_ = dd_gram(Im)
    hi[np.ix_(ev, ev)], lo[np.ix_(ev, ev)] = he, le
    hi[np.ix_(od, od)], lo[np.ix_(od, od)] = ho, lo_
    return to_mp(2 * hi, 2 * lo), (hi, lo)


def tail_matrix(M, h, gam_N):
    """(G(h)^2 + G(-h)^2)/pi (log(gamma_N/2pi)+1)/gamma_N as a matrix: weil_rung_min.zero_tail."""
    c = (mp.log(mpf(gam_N) / (2 * mp.pi)) + 1) / (mp.pi * mpf(gam_N))
    T = mpmatrix(M, M)
    hh = mpf(h)
    for i in range(M):
        for j in range(M):
            gi = mp.sqrt((2 * i + 1) / (2 * hh))
            gj = mp.sqrt((2 * j + 1) / (2 * hh))
            T[i, j] = c * gi * gj * (1 + (-1) ** (i + j))
    return T


# ------------------------------------------------------------ mp transforms at complex t
class MPTransform:
    """Ghat_n(t), A_n, B_n for the Legendre basis by 384-node Gauss-Legendre in mpmath."""

    def __init__(self, degree=8):
        from mpmath.calculus.quadrature import GaussLegendre
        gl = GaussLegendre(mp)
        self.nodes = gl.calc_nodes(degree, mp.prec)      # (x, w) on [-1, 1]
        self._P = {}

    def legendre_table(self, M):
        if M in self._P:
            return self._P[M]
        tab = []
        for x, w in self.nodes:
            p = [mpf(1), x]
            for n in range(1, M - 1):
                p.append(((2 * n + 1) * x * p[n] - n * p[n - 1]) / (n + 1))
            tab.append(p[:M])
        self._P[M] = tab
        return tab

    def transforms(self, M, h, gamma1, eps):
        """Returns (A, B): lists of mpc, A_n = int G_n cosh(eps u) e^{i u gamma1} du,
        B_n = int G_n sinh(eps u) e^{i u gamma1} du   (B = 0 exactly when eps = 0)."""
        h = mpf(h)
        g1 = mpf(gamma1)
        e = mpf(eps)
        P = self.legendre_table(M)
        norms = [mp.sqrt((2 * n + 1) / (2 * h)) * h for n in range(M)]
        A = [mpc(0) for _ in range(M)]
        B = [mpc(0) for _ in range(M)]
        for (x, w), prow in zip(self.nodes, P):
            u = h * x
            ph = w * mp.expj(u * g1)
            ch = ph * mp.cosh(e * u)
            sh = ph * mp.sinh(e * u) if eps != 0 else None
            for n in range(M):
                A[n] += prow[n] * ch
                if sh is not None:
                    B[n] += prow[n] * sh
        A = [norms[n] * A[n] for n in range(M)]
        B = [norms[n] * B[n] for n in range(M)]
        return A, B

    def ghat_complex(self, M, h, t):
        """Ghat_n(t) at complex t, same quadrature (for the closed-form cross-check)."""
        h = mpf(h)
        P = self.legendre_table(M)
        out = [mpc(0) for _ in range(M)]
        for (x, w), prow in zip(self.nodes, P):
            ph = w * mp.exp(1j * h * x * t)
            for n in range(M):
                out[n] += prow[n] * ph
        return [mp.sqrt((2 * n + 1) / (2 * h)) * h * out[n] for n in range(M)]


def ghat_bessel_complex(n, h, t):
    """sqrt(2h(2n+1)) i^n j_n(h t), j_n(z) = sqrt(pi/(2z)) J_{n+1/2}(z), complex z."""
    z = mpf(h) * t
    jn = mp.sqrt(mp.pi / (2 * z)) * mp.besselj(n + mpf(1) / 2, z)
    return mp.sqrt(2 * mpf(h) * (2 * n + 1)) * (1j) ** n * jn


def pair_matrix(A, B, weight=mpf(1) / 2):
    """T = 4 w ( Re[A A^H] - Re[B B^H] );  w = 1/2 is the multiplicity-conserving move."""
    M = len(A)
    T = mpmatrix(M, M)
    for i in range(M):
        for j in range(i, M):
            v = 4 * weight * (mp.re(A[i] * mp.conj(A[j])) - mp.re(B[i] * mp.conj(B[j])))
            T[i, j] = v
            T[j, i] = v
    return T


def pair_matrix_direct(gm, gp, weight=mpf(1) / 2):
    """Same via 2w Re[g- g+^H + g+ g-^H], g-/g+ = Ghat(gamma1 -/+ i eps) (consistency check)."""
    M = len(gm)
    T = mpmatrix(M, M)
    for i in range(M):
        for j in range(M):
            T[i, j] = 2 * weight * mp.re(gm[i] * mp.conj(gp[j]) + gp[i] * mp.conj(gm[j]))
    return T


# ------------------------------------------------------------ eigen-solve by parity block
def lam_min_parity(Q, M):
    """Smallest eigenvalue of the M x M leading block of Q, solved on the even and odd
    sub-blocks separately.  Returns (lam, vec (numpy float, length M), parity, lam_other,
    lam_even, lam_odd)."""
    res = {}
    for par, idx in (("even", list(range(0, M, 2))), ("odd", list(range(1, M, 2)))):
        m = len(idx)
        S = mpmatrix(m, m)
        for a, i in enumerate(idx):
            for b, j in enumerate(idx):
                S[a, b] = Q[i, j]
        E, V = mp.eigsy(S)
        k = min(range(m), key=lambda r: E[r])
        vec = np.zeros(M)
        for a, i in enumerate(idx):
            vec[i] = float(V[a, k])
        res[par] = (E[k], vec)
    if res["even"][0] <= res["odd"][0]:
        par, oth = "even", "odd"
    else:
        par, oth = "odd", "even"
    return res[par][0], res[par][1], par, res[oth][0], res["even"][0], res["odd"][0]


def mp_add(*mats):
    out = mats[0].copy()
    for m in mats[1:]:
        out += m
    return out


def fourier_energy_near(M, h, c, gamma1, halfwidth=1.0, nodes=24):
    """(1/2pi) int_{gamma1-hw}^{gamma1+hw} |Ghat(t)|^2 dt for G = sum c_i G_i, ||G|| = 1."""
    period = math.pi / h
    npan = int(math.ceil(2 * halfwidth / (period / 4))) + 2
    edges = np.linspace(gamma1 - halfwidth, gamma1 + halfwidth, npan + 1)
    xg, wg = leggauss(nodes)
    tt = (((edges[:-1] + edges[1:]) / 2)[:, None] + ((edges[1:] - edges[:-1]) / 2)[:, None] * xg[None, :]).ravel()
    tw = (((edges[1:] - edges[:-1]) / 2)[:, None] * wg[None, :]).ravel()
    gc = c @ ghat_legendre(M, h, tt)
    return float(np.sum(np.abs(gc) ** 2 * tw) / (2 * math.pi))


# ------------------------------------------------------------------ main
def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    ap.add_argument("--eps", type=str, default="0.001,0.003,0.01,0.02,0.05,0.1,0.2")
    ap.add_argument("--Ms", type=str, default="16,32")
    ap.add_argument("--dps", type=int, default=40)
    ap.add_argument("--Lmin", type=float, default=0.3)
    ap.add_argument("--Lmax", type=float, default=8.0)
    ap.add_argument("--npts", type=int, default=25)
    ap.add_argument("--bisect-ratio", type=float, default=1.02)
    ap.add_argument("--floor-rel", type=float, default=1e-30,
                    help="flat part of the floor: floor_rel * max|Q| (double-double Gram roundoff)")
    ap.add_argument("--bessel-rel", type=float, default=1e-15,
                    help="relative accuracy of the double-precision Ghat_n(gamma_k) entries (floor model)")
    ap.add_argument("--out", type=str, default=os.path.join(RESULTS, "weil_Lc_eps.json"))
    args = ap.parse_args()

    mp.dps = args.dps
    os.makedirs(RESULTS, exist_ok=True)
    started = datetime.datetime.now(datetime.timezone.utc)
    eps_list = [float(e) for e in args.eps.split(",")]
    Ms = sorted(int(m) for m in args.Ms.split(","))
    Mmax = max(Ms)
    weights = [("w=1/2", mpf(1) / 2), ("w=1", mpf(1))]
    grid = [args.Lmin * (args.Lmax / args.Lmin) ** (k / (args.npts - 1)) for k in range(args.npts)]

    print("weil_Lc_eps  EXPLORATORY - no prereg, no decision rule, no verdict.")
    print(f"  eps={eps_list}  M={Ms}  dps={args.dps}  L grid {args.Lmin}..{args.Lmax} ({args.npts} pts, ratio "
          f"{(args.Lmax/args.Lmin)**(1/(args.npts-1)):.4f}), bisect to {args.bisect_ratio}")
    print("  primary term w=1/2: T_eps = 2 Re[Ghat(g1 - i eps) conj Ghat(g1 + i eps)]  (pair -> pair, entry 297 move formula)")
    print("  secondary   w=1  : 2 T_eps, the four points 1/2 +- eps +- i g1 each with multiplicity one")

    gfile = np.array([float(l.split()[0]) for l in open(wq.ZEROS_FILE)])
    g_rest = gfile[1:]
    gam_N = float(gfile[-1])
    g1 = mp.zetazero(1).imag
    print(f"  zeros1.txt: {len(gfile)} zeros, gamma_1 {gfile[0]:.9f} .. gamma_N {gam_N:.3f}; "
          f"mp.zetazero(1) = {mp.nstr(g1, 30)}; |file - mp| = {abs(float(g1) - gfile[0]):.1e}")
    print(f"  zero side uses zeros 2..{len(gfile)} in double-double; zero 1, tail and T_eps in mpmath dps {args.dps}")
    tr = MPTransform(8)
    print(f"  mp Gauss-Legendre nodes: {len(tr.nodes)}")

    # ============================================================ unit tests
    print("\n===== unit tests =====")
    tests = {}
    h = 0.75
    # [T1] mp transform at eps = 0 vs numpy closed form (spherical Bessel) at gamma_1
    A0, B0 = tr.transforms(Mmax, h, g1, 0.0)
    Gn = ghat_legendre(Mmax, h, np.array([float(g1)]))[:, 0]
    e1 = max(abs(complex(A0[n]) - Gn[n]) for n in range(Mmax))
    tests["T1_mp_transform_vs_numpy_closed_form_eps0"] = {"h": h, "M": Mmax, "max_abs_err": e1}
    print(f"  [T1] h={h} M={Mmax}: mp quadrature Ghat_n(gamma_1) vs numpy sqrt(2h(2n+1)) i^n j_n(h gamma_1): max |diff| {e1:.2e}")
    # [T2] mp quadrature at complex t vs mp Bessel closed form, and A,B vs (g- +- g+)/2
    rows = []
    for eps in (0.02, 0.2):
        for hh in (0.3, 2.0, 4.0):
            A, B = tr.transforms(Mmax, hh, g1, eps)
            gm = tr.ghat_complex(Mmax, hh, g1 - 1j * mpf(eps))
            gp = tr.ghat_complex(Mmax, hh, g1 + 1j * mpf(eps))
            eA = max(abs((gm[n] + gp[n]) / 2 - A[n]) for n in range(Mmax))
            eB = max(abs((gm[n] - gp[n]) / 2 - B[n]) for n in range(Mmax))
            eJ = max(abs(ghat_bessel_complex(n, hh, g1 - 1j * mpf(eps)) - gm[n]) for n in (0, 1, 5, 17, Mmax - 1))
            rows.append({"eps": eps, "h": hh, "err_A": float(eA), "err_B": float(eB), "err_bessel": float(eJ)})
            print(f"  [T2] eps={eps} h={hh}: A vs (g-+g+)/2 {mp.nstr(eA, 3)}, B vs (g- - g+)/2 {mp.nstr(eB, 3)}, "
                  f"quadrature vs besselj(n+1/2) at complex t {mp.nstr(eJ, 3)}")
    tests["T2_complex_t_transform_checks"] = rows
    # [D0] derivation test at eps = 0: T_0 must equal the pair term 2|Ghat(gamma_1)|^2
    T0 = pair_matrix(A0, B0, mpf(1) / 2)
    P1 = mpmatrix(Mmax, Mmax)
    for i in range(Mmax):
        for j in range(Mmax):
            P1[i, j] = 2 * mp.re(A0[i] * mp.conj(A0[j]))
    d0 = max(abs(T0[i, j] - P1[i, j]) for i in range(Mmax) for j in range(Mmax))
    T0w1 = pair_matrix(A0, B0, mpf(1))
    d0w1 = max(abs(T0w1[i, j] - P1[i, j]) for i in range(Mmax) for j in range(Mmax))
    ind = mp.sqrt(2 * mpf(h))          # indicator = sqrt(2h) G_0
    tests["D0_eps0_equals_pair"] = {"h": h, "M": Mmax, "max_abs_T0_minus_2absGhat2_w_half": float(d0),
                                    "max_abs_T0_minus_2absGhat2_w_one": float(d0w1),
                                    "indicator_T0_w_half": float(ind ** 2 * T0[0, 0]),
                                    "indicator_T0_w_one": float(ind ** 2 * T0w1[0, 0]),
                                    "indicator_2absGhat2": float(ind ** 2 * P1[0, 0])}
    print(f"  [D0] eps=0, h={h}: max |T_0 - 2 Re[Ghat Ghat^H]| = {mp.nstr(d0, 3)} (w=1/2, PASS at machine precision); "
          f"unit-multiplicity four-point sum (w=1): max |.| = {mp.nstr(d0w1, 3)} = the pair term itself: FAILS by the factor 2")
    print(f"       indicator: 2|Ghat(g1)|^2 = {mp.nstr(ind**2 * P1[0,0], 12)}, T_0(w=1/2) = {mp.nstr(ind**2 * T0[0,0], 12)}, "
          f"four points w=1: {mp.nstr(ind**2 * T0w1[0,0], 12)}")
    # [D1] eps != 0, G = indicator: closed form 2 sin(ht)/t at complex t  vs  matrix element  vs  direct quadrature
    #      of A, B  vs  direct sum over the four points of Fhat with F(x) = 2h - |x|
    rows = []
    for eps in eps_list:
        for hh in (0.5, 2.0):
            e = mpf(eps)
            tm, tp = g1 - 1j * e, g1 + 1j * e
            Gc = lambda t: 2 * mp.sin(mpf(hh) * t) / t
            closed = 2 * mp.re(Gc(tm) * mp.conj(Gc(tp)))
            A, B = tr.transforms(4, hh, g1, eps)
            Tm = pair_matrix(A, B, mpf(1) / 2)
            matrix_el = 2 * mpf(hh) * Tm[0, 0]
            Aq = mp.quad(lambda u: mp.cosh(e * u) * mp.expj(u * g1), [-mpf(hh), 0, mpf(hh)])
            Bq = mp.quad(lambda u: mp.sinh(e * u) * mp.expj(u * g1), [-mpf(hh), 0, mpf(hh)])
            direct_AB = 2 * (abs(Aq) ** 2 - abs(Bq) ** 2)
            Fh = lambda t: mp.quad(lambda x: (2 * mpf(hh) - abs(x)) * mp.exp(1j * x * t), [-2 * mpf(hh), 0, 2 * mpf(hh)])
            four = mp.fsum(Fh(t) for t in (tm, -tm, tp, -tp))
            four_w_half = four / 2
            rows.append({"eps": eps, "h": hh, "closed_form": float(closed), "matrix_element": float(matrix_el),
                         "direct_quadrature_AB": float(direct_AB), "four_point_sum_w_half": float(mp.re(four_w_half)),
                         "four_point_sum_imag": float(mp.im(four)),
                         "err_matrix": float(abs(matrix_el - closed)), "err_direct_AB": float(abs(direct_AB - closed)),
                         "err_four_point": float(abs(four_w_half - closed))})
            print(f"  [D1] eps={eps:<6g} h={hh}: closed form {mp.nstr(closed, 15)}; matrix el diff {mp.nstr(abs(matrix_el-closed), 2)}; "
                  f"direct quad A,B diff {mp.nstr(abs(direct_AB-closed), 2)}; (1/2) sum of Fhat over the four points diff "
                  f"{mp.nstr(abs(four_w_half-closed), 2)} (Im {mp.nstr(mp.im(four), 2)})")
    tests["D1_indicator_eps_nonzero"] = rows
    # [T3] double-double Gram vs exact mp Gram on a subset
    R = ghat_legendre(8, h, g_rest[:3000])[::2].real.T.copy()
    hi, lo = dd_gram(R)
    err = mpf(0)
    for i in range(4):
        for j in range(4):
            ref = mp.fsum(mpf(float(R[k, i])) * mpf(float(R[k, j])) for k in range(R.shape[0]))
            err = max(err, abs(mpf(float(hi[i, j])) + mpf(float(lo[i, j])) - ref))
    tests["T3_dd_gram_vs_mp_exact"] = float(err)
    print(f"  [T3] double-double Gram vs exact mp Gram (3000 zeros, 4 even fns, entries ~{float(hi[0,0]):.3f}): max |diff| {mp.nstr(err, 3)}")
    # [T4] Z_all (double-double incl. zero 1) - P1(mp) vs Z' (zeros 2..N): the reason zero 1 is excluded
    Zall, _ = zero_side_dd(Mmax, h, gfile)
    Zrest, (zh, zl) = zero_side_dd(Mmax, h, g_rest)
    d4 = max(abs(Zall[i, j] - P1[i, j] - Zrest[i, j]) for i in range(Mmax) for j in range(Mmax))
    tests["T4_Zall_minus_P1_vs_Zrest"] = float(d4)
    print(f"  [T4] h={h}: max |Z_all - P1(mp) - Z'| = {mp.nstr(d4, 3)}  (double-precision zero-1 term vs mp: this is why zero 1 is excluded from R)")
    # [T5] Z' + tail vs weil_rung_min's double-precision zero-side at the same G: X = 3 minimiser check
    rm = json.load(open(os.path.join(RESULTS, "weil_rung_min.json")))
    zc = next(z for z in rm["zero_checks"] if z["X"] == 3.0 and z["basis"] == "legendre")
    r3 = next(r for r in rm["rows"] if r["X"] == 3.0 and r["basis"] == "legendre" and r["M"] == zc["M"])
    hh = math.log(3.0) / 2
    Mz = zc["M"]
    Zr3, _ = zero_side_dd(Mz, hh, g_rest)
    A3, B3 = tr.transforms(Mz, hh, g1, 0.0)
    Q3 = Zr3 + tail_matrix(Mz, hh, gam_N) + pair_matrix(A3, B3)
    c3 = np.array(r3["minimiser_coeffs"])
    cm = mpmatrix(c3.tolist())
    val = (cm.T * Q3 * cm)[0, 0]
    tests["T5_zero_side_at_rung_min_minimiser_X3"] = {"M": Mz, "this": float(val), "weil_rung_min_Z_file_plus_tail": zc["Z_file"] + zc["tail_file"],
                                                       "weil_rung_min_lam_min_Q": zc["lam_min"]}
    print(f"  [T5] X=3 M={Mz}, weil_rung_min's minimiser: Z'+tail+pair here {mp.nstr(val, 10)}; weil_rung_min Z_file+tail "
          f"{zc['Z_file']+zc['tail_file']:.10e}; lam_min(Q) {zc['lam_min']:.10e}")

    # ============================================================ caches
    cache_Z = {}
    cache_T = {}
    tstat = {"Z": 0.0, "T": 0.0, "eig": 0.0, "nZ": 0, "nT": 0, "neig": 0}

    def get_Z(hh):
        if hh not in cache_Z:
            t0 = time.time()
            Zp, _ = zero_side_dd(Mmax, hh, g_rest)
            Z = Zp + tail_matrix(Mmax, hh, gam_N)
            cache_Z[hh] = (Z, Zp)
            tstat["Z"] += time.time() - t0
            tstat["nZ"] += 1
        return cache_Z[hh]

    def get_T(hh, eps):
        key = (hh, eps)
        if key not in cache_T:
            t0 = time.time()
            A, B = tr.transforms(Mmax, hh, g1, eps)
            cache_T[key] = (pair_matrix(A, B, mpf(1) / 2), A, B)
            tstat["T"] += time.time() - t0
            tstat["nT"] += 1
        return cache_T[key]

    def solve(L, eps, M, w):
        hh = L / 2
        Z, Zp = get_Z(hh)
        T, A, B = get_T(hh, eps)
        Q = Z + (2 * w) * T
        t0 = time.time()
        lam, vec, par, lam_other, lam_e, lam_o = lam_min_parity(Q, M)
        tstat["eig"] += time.time() - t0
        tstat["neig"] += 1
        qmax = max(abs(Q[i, j]) for i in range(M) for j in range(M))
        vm = mpmatrix(vec.tolist())
        # roundoff floor: 2 ||R G|| ||dR G|| <= 2 sqrt(Z'(G)/2) * bessel_rel * sqrt(tr Z'/2)   (header, PRECISION)
        ZpG = (vm.T * Zp[:M, :M] * vm)[0, 0]
        trZp = mp.fsum(Zp[i, i] for i in range(M))
        floor_model = 2 * mp.sqrt(max(ZpG, mpf(0)) / 2) * args.bessel_rel * mp.sqrt(trZp / 2)
        floor = max(float(floor_model), args.floor_rel * float(qmax))
        Av = mp.fsum(vm[i] * A[i] for i in range(M))
        Bv = mp.fsum(vm[i] * B[i] for i in range(M))
        return {"L": L, "h": hh, "eps": eps, "M": M, "w": float(w), "lam_min": float(lam), "lam_min_str": mp.nstr(lam, 12),
                "parity": par, "lam_other_parity": float(lam_other), "lam_even": float(lam_e), "lam_odd": float(lam_o),
                "floor": floor, "floor_model": float(floor_model), "Zprime_at_min": float(ZpG),
                "negative": bool(lam < -floor), "raw_negative": bool(lam < 0),
                "A2": float(abs(Av) ** 2), "B2": float(abs(Bv) ** 2),
                "T_at_min": float((2 * w) * 2 * (abs(Av) ** 2 - abs(Bv) ** 2)),
                "vec": vec}

    # ============================================================ sanity: eps = 0 vs weil_rung_min
    print("\n===== sanity: eps = 0 (zero side of weil_rung_min) vs its arithmetic-side lam_min (legendre) =====")
    sanity = []
    ref_by_M = {X: rm["summary"]["by_X"][str(X)]["legendre"]["lam_min_by_M"] for X in (2.0, 2.5, 3.0, 3.5, 4.0)}
    for X in (2.0, 2.5, 3.0, 3.5, 4.0):
        L = math.log(X)
        for M in Ms:
            r = solve(L, 0.0, M, mpf(1) / 2)
            ref = ref_by_M[X].get(str(M))
            sanity.append({"X": X, "L": L, "M": M, "lam_min_zero_side": r["lam_min"], "weil_rung_min_lam_min": ref,
                           "rel_diff": (r["lam_min"] - ref) / ref if ref else None, "parity": r["parity"],
                           "weil_rung_min_lam_min_M64": ref_by_M[X].get("64")})
            print(f"  X={X:<4g} L={L:.4f} M={M:2d}: lam_min(zero side, mp) {r['lam_min']:.6e} ({r['parity']})   "
                  f"weil_rung_min (arith side, double) {ref:.6e}   rel diff {(r['lam_min']-ref)/ref:+.2e}")
    print("  brief's targets 1.33e-3, 1.03e-5, 5.55e-8 at X = 2, 2.5, 3 against weil_rung_min.txt:11-13 columns:")
    for X, tgt in ((2.0, "1.33e-3"), (2.5, "1.03e-5"), (3.0, "5.55e-8")):
        print(f"    X={X:<4g} target {tgt}: weil_rung_min M=32 {ref_by_M[X]['32']:.4e}, M=64 {ref_by_M[X]['64']:.4e}; "
              f"this script M=32 {next(s['lam_min_zero_side'] for s in sanity if s['X'] == X and s['M'] == 32):.4e}")

    # ============================================================ ladder
    print("\n===== ladder: lam_min(Q_eps; L) =====")
    print("  lam_min printed as sign-mantissa; '-' entries beyond the floor are detections; parity e/o of the minimiser")
    ladder = {}
    Lc_table = []
    all_eps = [0.0] + eps_list
    for eps in all_eps:
        for M in Ms:
            for wname, w in weights:
                if eps == 0.0 and wname == "w=1":
                    continue
                key = f"eps={eps:g}|M={M}|{wname}"
                t0 = time.time()
                pts = [solve(L, eps, M, w) for L in grid]
                # first sign change
                first = next((k for k, p in enumerate(pts) if p["negative"]), None)
                rec = {"eps": eps, "M": M, "weight": wname, "grid": [{k2: v for k2, v in p.items() if k2 != "vec"} for p in pts],
                       "L_c": None}
                if first is not None and first > 0:
                    La, Lb = grid[first - 1], grid[first]
                    pa, pb = pts[first - 1], pts[first]
                    nb = 0
                    while Lb / La > args.bisect_ratio:
                        Lm = math.sqrt(La * Lb)
                        pm = solve(Lm, eps, M, w)
                        nb += 1
                        if pm["negative"]:
                            Lb, pb = Lm, pm
                        else:
                            La, pa = Lm, pm
                    Lc = Lb
                    p15 = solve(1.5 * Lc, eps, M, w)
                    p2 = solve(2.0 * Lc, eps, M, w)
                    above = [p for p in pts if p["L"] > Lc]
                    n_pos_above = sum(1 for p in above if not p["negative"])
                    desc = wr.describe_G("legendre", M, Lc / 2, pb["vec"])
                    e_near = fourier_energy_near(M, Lc / 2, pb["vec"], float(g1), 1.0)
                    gapm = wr.gap_matrix("legendre", M, Lc / 2, float(g1))
                    e_gap = float(pb["vec"] @ gapm @ pb["vec"])
                    rec.update({"L_c": Lc, "L_c_bracket": [La, Lb], "X_c": math.exp(Lc), "n_bisect": nb,
                                "lam_at_bracket": [pa["lam_min"], pb["lam_min"]],
                                "lam_at_1.5Lc": p15["lam_min"], "lam_at_2Lc": p2["lam_min"],
                                "negative_at_1.5Lc": p15["negative"], "negative_at_2Lc": p2["negative"],
                                "grid_points_above_Lc": len(above), "grid_points_above_Lc_positive": n_pos_above,
                                "minimiser_at_Lc": {"parity": pb["parity"], "lam_even": pb["lam_even"], "lam_odd": pb["lam_odd"],
                                                    "A2": pb["A2"], "B2": pb["B2"], "T_at_min": pb["T_at_min"],
                                                    "fourier_energy_within_1_of_gamma1": e_near,
                                                    "energy_below_gamma1": e_gap,
                                                    "coeffs": [float(v) for v in pb["vec"]], **desc}})
                elif first == 0:
                    rec["L_c"] = grid[0]
                    rec["note"] = "negative already at the first grid point"
                ladder[key] = rec
                lam_s = " ".join(f"{p['lam_min']:+.1e}{p['parity'][0]}" for p in pts)
                lc = f"L_c={rec['L_c']:.4f} X_c={math.exp(rec['L_c']):.3f} [{rec['L_c_bracket'][0]:.4f},{rec['L_c_bracket'][1]:.4f}] " \
                     f"lam(1.5Lc)={rec['lam_at_1.5Lc']:+.2e} lam(2Lc)={rec['lam_at_2Lc']:+.2e} pos-above={rec['grid_points_above_Lc_positive']}/{rec['grid_points_above_Lc']}" \
                    if rec.get("L_c_bracket") else f"L_c={rec['L_c']}"
                print(f"  {key:<26s} {lc}   [{time.time()-t0:.1f}s]")
                print(f"      grid: {lam_s}")
                if rec.get("L_c_bracket"):
                    Lc_table.append({"eps": eps, "M": M, "weight": wname, "L_c": rec["L_c"], "X_c": rec["X_c"],
                                     "parity": rec["minimiser_at_Lc"]["parity"]})
    print(f"\n  timings: Z builds {tstat['nZ']} ({tstat['Z']:.1f}s), T builds {tstat['nT']} ({tstat['T']:.1f}s), eigs {tstat['neig']} ({tstat['eig']:.1f}s)")
    print("  L grid: " + " ".join(f"{L:.3f}" for L in grid))

    # ============================================================ L_c summary, fits
    print("\n===== L_c(eps) =====")
    hdr = f"{'eps':>7} " + " ".join(f"{'M='+str(M)+' '+wn:>16}" for M in Ms for wn, _ in weights) + f" {'Lc*eps (Mmax,w=1/2)':>20} {'log(1/eps)/eps':>15} {'1/eps':>8}"
    print(hdr)
    for eps in eps_list:
        cells = []
        for M in Ms:
            for wn, _ in weights:
                r = ladder.get(f"eps={eps:g}|M={M}|{wn}", {})
                cells.append(f"{r['L_c']:>16.4f}" if r.get("L_c") else f"{'none':>16}")
        rmax = ladder.get(f"eps={eps:g}|M={Mmax}|w=1/2", {})
        lce = f"{rmax['L_c']*eps:>20.5f}" if rmax.get("L_c") else f"{'':>20}"
        print(f"{eps:>7g} " + " ".join(cells) + f" {lce} {math.log(1/eps)/eps:>15.3f} {1/eps:>8.1f}")

    fits = {}
    for M in Ms:
        for wn, _ in weights:
            pts = [(eps, ladder[f"eps={eps:g}|M={M}|{wn}"]["L_c"]) for eps in eps_list
                   if ladder.get(f"eps={eps:g}|M={M}|{wn}", {}).get("L_c")]
            if len(pts) < 3:
                continue
            ee = np.array([p[0] for p in pts])
            LL = np.array([p[1] for p in pts])
            out = {"n": len(pts), "eps": ee.tolist(), "L_c": LL.tolist(), "Lc_times_eps": (LL * ee).tolist()}
            for name, x in (("log(1/eps)/eps", np.log(1 / ee) / ee), ("1/eps", 1 / ee), ("log(1/eps)", np.log(1 / ee))):
                X = np.column_stack([np.ones_like(x), x])
                coef, *_ = np.linalg.lstsq(X, LL, rcond=None)
                resid = LL - X @ coef
                out[name] = {"a": float(coef[0]), "b": float(coef[1]), "residuals": resid.tolist(),
                             "rms_resid": float(np.sqrt(np.mean(resid ** 2))),
                             "R2": float(1 - np.sum(resid ** 2) / np.sum((LL - LL.mean()) ** 2))}
            fits[f"M={M}|{wn}"] = out
            print(f"\n  fit M={M} {wn} ({len(pts)} points): L_c*eps = " + ", ".join(f"{v:.4f}" for v in LL * ee))
            for name in ("log(1/eps)/eps", "1/eps", "log(1/eps)"):
                f = out[name]
                print(f"    L_c = {f['a']:+.4f} + {f['b']:+.5f} * {name:<14s}  rms resid {f['rms_resid']:.4f}  R^2 {f['R2']:.4f}  "
                      f"resid " + " ".join(f"{r:+.3f}" for r in f["residuals"]))

    # ============================================================ minimiser shapes at L_c
    print("\n===== minimiser at L_c (w=1/2) =====")
    for eps in (0.02, 0.1):
        for M in Ms:
            r = ladder.get(f"eps={eps:g}|M={M}|w=1/2", {})
            d = r.get("minimiser_at_Lc")
            if not d:
                print(f"  eps={eps} M={M}: no L_c")
                continue
            print(f"  eps={eps:<5g} M={M:2d} L_c={r['L_c']:.4f} (h={r['L_c']/2:.4f}): parity {d['parity']} (lam even {d['lam_even']:+.2e}, odd {d['lam_odd']:+.2e}); "
                  f"|A|^2={d['A2']:.3e} |B|^2={d['B2']:.3e} T={d['T_at_min']:+.3e}")
            print(f"      mass: central half {d['mass_central_half']:.4f}, central tenth {d['mass_central_tenth']:.4f}, end tenths {d['mass_end_tenths']:.4f}, "
                  f"|G|max at u/h={d['abs_max_at_u_over_h']:+.3f}, sign changes {d['sign_changes']}, G(0)={d['G_at_0']:+.3f}, G(+-h)={d['G_at_ends'][0]:+.2e},{d['G_at_ends'][1]:+.2e}")
            print(f"      Fourier energy within |t-gamma_1|<1: {d['fourier_energy_within_1_of_gamma1']:.4f} of ||G||^2 (x2 for the mirror lobe at -gamma_1); "
                  f"energy in |t|<gamma_1: {d['energy_below_gamma1']:.4f}")
            print("      G(u/h=-1..1): " + " ".join(f"{v:+.2f}" for v in d["grid_G"][::2]))
    r02 = ladder.get(f"eps=0.02|M={Mmax}|w=1/2", {})
    print(f"\n  eps = 0.02 (cf. Bombieri 2000 s13's fake zero 0.52 + 3.14i, height 3.14, not replicated): "
          f"L_c = {r02.get('L_c')}, X_c = {r02.get('X_c')}  (M={Mmax}, w=1/2); w=1: L_c = {ladder.get(f'eps=0.02|M={Mmax}|w=1', {}).get('L_c')}")

    # ============================================================ outputs
    ended = datetime.datetime.now(datetime.timezone.utc)
    payload = {
        "schema_version": "1",
        "script": os.path.abspath(__file__),
        "generated_utc": ended.strftime("%Y-%m-%dT%H:%M:%SZ"),
        "status": "EXPLORATORY - no prereg, no decision rule, no verdict.",
        "params": {"code_version": _code_version(), "eps": eps_list, "Ms": Ms, "dps": args.dps,
                   "L_grid": grid, "bisect_ratio": args.bisect_ratio, "floor_rel": args.floor_rel, "bessel_rel": args.bessel_rel,
                   "zeros_file": wq.ZEROS_FILE, "n_zeros": int(len(gfile)), "gamma_1_mp": mp.nstr(g1, 35),
                   "gamma_N": gam_N, "mp_gl_nodes": len(tr.nodes),
                   "instrument": os.path.join(_HERE, "weil_rung_min.py"),
                   "run_start_at": started.strftime("%Y-%m-%dT%H:%M:%SZ"),
                   "run_end_at": ended.strftime("%Y-%m-%dT%H:%M:%SZ")},
        "constants": {
            "Q_eps": "Z' + tail + 2w T_eps;  Z' = 2 sum_{k>=2} |Ghat(gamma_k)|^2 (double-double Gram), tail = weil_rung_min.zero_tail, "
                     "T_eps = 2 Re[Ghat(g1 - i eps) conj Ghat(g1 + i eps)] = 2(|A|^2 - |B|^2)",
            "A": "int G(u) cosh(eps u) e^{i u gamma_1} du", "B": "int G(u) sinh(eps u) e^{i u gamma_1} du",
            "weights": {"w=1/2": "pair {rho, conj rho} -> {rho', conj rho'}, rho' = 1/2 + eps + i gamma_1 (T_0 = pair term)",
                        "w=1": "four points 1/2 +- eps +- i gamma_1 each with multiplicity one (= 2 T_eps; 2x the pair at eps = 0)"},
            "L_c": "first L in the bisected bracket with lam_min < -floor, floor = max(2 sqrt(Z'(G*)/2) bessel_rel sqrt(tr Z'/2), floor_rel * max|Q|)",
            "basis": "legendre sqrt((2n+1)/(2h)) P_n(u/h), n = 0..M-1, on [-h, h], h = L/2",
        },
        "unit_tests": tests,
        "sanity_eps0_vs_weil_rung_min": sanity,
        "L_c_table": Lc_table,
        "fits": fits,
        "ladder": ladder,
        "timings": tstat,
    }
    with open(args.out, "w") as fh:
        json.dump(payload, fh, indent=1)
    print(f"\n  results written to {args.out}")

    txt = os.path.join(_HERE, "weil_Lc_eps.txt")
    with open(txt, "w") as fh:
        fh.write("weil_Lc_eps  EXPLORATORY - no prereg, no decision rule, no verdict.\n")
        fh.write(f"generated {payload['generated_utc']}  code_version {payload['params']['code_version'][:16]}\n")
        fh.write("Q_eps = Z' + tail + 2w T_eps on the Legendre subspace of L2[-L/2, L/2]; Z' = 2 sum_{k>=2}|Ghat(gamma_k)|^2 over zeros1.txt,\n")
        fh.write("T_eps = 2 Re[Ghat(g1 - i eps) conj Ghat(g1 + i eps)] = 2(|A|^2 - |B|^2); w=1/2 pair->pair (primary), w=1 four points, multiplicity one.\n")
        fh.write(f"dps {args.dps}; floor = max(2 sqrt(Z'(G*)/2) {args.bessel_rel:g} sqrt(tr Z'/2), {args.floor_rel:g} max|Q|) "
                 f"(double-precision Ghat at the zeros; double-double Gram); lam_min relative to ||G||_2 = 1.\n\n")
        fh.write("L_c(eps): first bisected L with lam_min < -floor (bracket ratio < %.3f)\n" % args.bisect_ratio)
        fh.write(hdr + "\n")
        for eps in eps_list:
            cells = []
            for M in Ms:
                for wn, _ in weights:
                    r = ladder.get(f"eps={eps:g}|M={M}|{wn}", {})
                    cells.append(f"{r['L_c']:>16.4f}" if r.get("L_c") else f"{'none':>16}")
            rmax = ladder.get(f"eps={eps:g}|M={Mmax}|w=1/2", {})
            lce = f"{rmax['L_c']*eps:>20.5f}" if rmax.get("L_c") else f"{'':>20}"
            fh.write(f"{eps:>7g} " + " ".join(cells) + f" {lce} {math.log(1/eps)/eps:>15.3f} {1/eps:>8.1f}\n")
        fh.write("\nper (eps, M, w): L_c, bracket, X_c, lam at 1.5 L_c and 2 L_c, grid points above L_c that are positive, parity at L_c\n")
        for key, r in ladder.items():
            if r.get("L_c_bracket"):
                d = r["minimiser_at_Lc"]
                fh.write(f"  {key:<26s} L_c {r['L_c']:.4f} [{r['L_c_bracket'][0]:.4f}, {r['L_c_bracket'][1]:.4f}] X_c {r['X_c']:.3f}  "
                         f"lam(1.5Lc) {r['lam_at_1.5Lc']:+.3e}  lam(2Lc) {r['lam_at_2Lc']:+.3e}  pos above {r['grid_points_above_Lc_positive']}/{r['grid_points_above_Lc']}  "
                         f"{d['parity']}  m_half {d['mass_central_half']:.3f}  E(|t-g1|<1) {d['fourier_energy_within_1_of_gamma1']:.3f}  E(|t|<g1) {d['energy_below_gamma1']:.3f}\n")
            else:
                fh.write(f"  {key:<26s} L_c {r.get('L_c')}  {r.get('note', 'no sign change on the grid')}\n")
        fh.write("\nlam_min(Q_eps; L) along the grid (parity e/o), one row per (eps, M, w)\n")
        fh.write("  L: " + " ".join(f"{L:8.3f}" for L in grid) + "\n")
        for key, r in ladder.items():
            fh.write(f"  {key:<26s} " + " ".join(f"{p['lam_min']:+.1e}{p['parity'][0]}" for p in r["grid"]) + "\n")
        fh.write("\nfits (least squares L_c = a + b x)\n")
        for k, f in fits.items():
            fh.write(f"  {k}: L_c*eps = " + ", ".join(f"{v:.4f}" for v in f["Lc_times_eps"]) + "\n")
            for name in ("log(1/eps)/eps", "1/eps", "log(1/eps)"):
                g = f[name]
                fh.write(f"    x = {name:<14s} a {g['a']:+.4f} b {g['b']:+.5f} rms resid {g['rms_resid']:.4f} R^2 {g['R2']:.4f} resid "
                         + " ".join(f"{v:+.3f}" for v in g["residuals"]) + "\n")
        fh.write("\nsanity eps = 0 vs weil_rung_min (legendre, arithmetic side, double precision; last column = weil_rung_min at M=64)\n")
        for s in sanity:
            fh.write(f"  X={s['X']:<4g} M={s['M']:2d} zero side {s['lam_min_zero_side']:.6e}  weil_rung_min {s['weil_rung_min_lam_min']:.6e}  rel {s['rel_diff']:+.2e}"
                     f"  (M=64: {s['weil_rung_min_lam_min_M64']:.6e})\n")
        fh.write("\nunit tests\n")
        fh.write(f"  [T1] mp transform vs numpy closed form at gamma_1 (eps=0): {tests['T1_mp_transform_vs_numpy_closed_form_eps0']['max_abs_err']:.2e}\n")
        fh.write(f"  [T2] complex-t checks: max err_A {max(r['err_A'] for r in tests['T2_complex_t_transform_checks']):.1e}, "
                 f"err_B {max(r['err_B'] for r in tests['T2_complex_t_transform_checks']):.1e}, "
                 f"vs besselj {max(r['err_bessel'] for r in tests['T2_complex_t_transform_checks']):.1e}\n")
        t = tests["D0_eps0_equals_pair"]
        fh.write(f"  [D0] eps=0: |T_0 - 2|Ghat(g1)|^2| max {t['max_abs_T0_minus_2absGhat2_w_half']:.1e} (w=1/2); unit multiplicity four points: "
                 f"{t['max_abs_T0_minus_2absGhat2_w_one']:.3e} = pair term (factor 2)\n")
        fh.write(f"  [D1] indicator, eps != 0: max |matrix - closed| {max(r['err_matrix'] for r in tests['D1_indicator_eps_nonzero']):.1e}, "
                 f"|direct quad A,B - closed| {max(r['err_direct_AB'] for r in tests['D1_indicator_eps_nonzero']):.1e}, "
                 f"|(1/2) four-point Fhat sum - closed| {max(r['err_four_point'] for r in tests['D1_indicator_eps_nonzero']):.1e}\n")
        fh.write(f"  [T3] double-double Gram vs exact: {tests['T3_dd_gram_vs_mp_exact']:.1e}\n")
        fh.write(f"  [T4] Z_all(dd) - P1(mp) - Z'(dd): {tests['T4_Zall_minus_P1_vs_Zrest']:.1e}\n")
        t = tests["T5_zero_side_at_rung_min_minimiser_X3"]
        fh.write(f"  [T5] X=3 M={t['M']} at weil_rung_min's minimiser: {t['this']:.6e} vs Z_file+tail {t['weil_rung_min_Z_file_plus_tail']:.6e}, lam_min(Q) {t['weil_rung_min_lam_min_Q']:.6e}\n")
        fh.write("\nminimiser at L_c (w=1/2), eps = 0.02 and 0.1\n")
        for eps in (0.02, 0.1):
            for M in Ms:
                r = ladder.get(f"eps={eps:g}|M={M}|w=1/2", {})
                d = r.get("minimiser_at_Lc")
                if not d:
                    continue
                fh.write(f"  eps={eps:<5g} M={M:2d} L_c={r['L_c']:.4f}: {d['parity']}; |A|^2 {d['A2']:.3e} |B|^2 {d['B2']:.3e}; mass central half {d['mass_central_half']:.4f}, "
                         f"end tenths {d['mass_end_tenths']:.4f}, |G|max at u/h {d['abs_max_at_u_over_h']:+.3f}, sign changes {d['sign_changes']}; "
                         f"E(|t-g1|<1) {d['fourier_energy_within_1_of_gamma1']:.4f}, E(|t|<g1) {d['energy_below_gamma1']:.4f}\n")
                fh.write("    " + " ".join(f"{v:+.3f}" for v in d["grid_G"]) + "\n")
    print(f"  table written to {txt}")
    print("\nEXPLORATORY - no prereg, no decision rule, no verdict.")


if __name__ == "__main__":
    main()
