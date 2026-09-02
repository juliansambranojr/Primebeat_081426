"""weil_Lc_theory.py — L_c(eps, gamma) for a FIXED test function, derived in closed form
and tested against the 24 (k, eps) rows of results/weil_Lc_mod.json.  EXPLORATORY.
No prereg, no decision rule, no verdict.

Derivation page: weil_Lc_theory.md (same directory).  Conventions are weil_Lc_mod.py's
(Bombieri 2000 eq. 12.2 normalisation, w = 1/2 pair -> pair primary):

    Q(G) = Z'_k + tail + 2w T_eps,   T_eps = 2(|A|^2 - |B|^2),
    Z'_k = 2 sum_{j != k} |Ghat(gamma_j)|^2,   Ghat(t) = int G(u) e^{iut} du,
    A = (Ghat(g - i eps) + Ghat(g + i eps))/2,  B = (Ghat(g - i eps) - Ghat(g + i eps))/2.

THE FIXED WINDOW
----------------
    G(u) = N (u/h) P(u/h) cos(gamma u),   P(x) = cos^2(pi x/2) on [-1, 1],   ||G||_2 = 1.

The envelope is ODD.  An even envelope P(u/h) cos(gamma u) has Ghat(gamma) = (Nh/2) int P
+ O(1/(gamma h)^3) = O(1), so |A|^2 = O(1) and T_eps > 0 at every h: it never detects.
The measured minimisers have |A|^2/|B|^2 <= 3.4e-3 (weil_Lc_mod.json, minimiser_at_Lc),
i.e. Ghat(gamma_k) = 0 to leading order, and their cos-block / sin-block Legendre
coefficients sit in opposite parities at every (k, eps) (section 0 below): the first-order
structure of the minimiser is an odd envelope.  x P(x) is the simplest odd envelope with a
closed-form transform; the raised cosine is chosen over the Slepian because (a) its
transform is elementary, (b) P(+-1) = P'(+-1) = 0 so the instrument's tail term
(G(h)^2 + G(-h)^2) vanishes identically, (c) its transform decays as pi^2 cos s / s^3 with
an explicit envelope bound, which is what the N(T)-bounded far tail needs.  The k = 1000
minimiser envelope has no simple description (section 0: nearest candidate at normalised
L2 distance 0.43).

CLOSED FORMS (x = u/h; all integrals over [-1, 1])
--------------------------------------------------
    Psi(s)   = int x P(x) sin(s x) dx  = iota(s) + [iota(s + pi) + iota(s - pi)]/2,
               iota(a) = (sin a - a cos a)/a^2 = a/3 - a^3/30 + a^5/840 - ...
             = pi^2 cos s /(s (s^2 - pi^2)) + (pi^4 - 3 pi^2 s^2) sin s /(s^2 (s^2 - pi^2)^2)
    Sigma(s) = int x P(x) sinh(s x) dx = -i Psi(i s) = s m2 + s^3 m4/6 + ...,  m2 = 1/3 - 2/pi^2
    Ghat(t)  = (i N h/2) [Psi(h(t - gamma)) + Psi(h(t + gamma))]
    ||G||^2  = N^2 h [m22 + C(2 gamma h)]/2,   m22 = int x^2 P^2 = (2 - 15/pi^2)/8,
               C(w) = int x^2 P(x)^2 cos(w x) dx (elementary, K(a) = int x^2 cos(ax) dx)
    A = (i N h/2) [Psi(2 gamma h - i eps h) + Psi(2 gamma h + i eps h)]/2          (2 gamma lobe only)
    B = (N h/2) [Sigma(eps h) + i (Psi(2 gamma h - i eps h) - Psi(2 gamma h + i eps h))/2]
    first order:  |B|^2 = eps^2 |int u G(u) e^{i u gamma} du|^2 + O(eps^4)
                        = eps^2 (N h^2 m2 / 2)^2 + O(eps^4)  ->  2|B|^2 = eps^2 h^3 m2^2 / m22
    Z'  = 2 (N h/2)^2 sum_{j != k} [Psi(h(gamma_j - gamma)) + Psi(h(gamma_j + gamma))]^2
    tail (instrument form) = (G(h)^2 + G(-h)^2)(...) = 0 exactly;  beyond-file zeros bounded via N(T)
    pole = int F(u) 2 cosh(u/2) du = 2 Ghat(i/2) Ghat(-i/2)   (arithmetic side; outside Q)

NEAR / FAR SPLIT AND THE N(T) BOUND
-----------------------------------
near lobe: |gamma_j - gamma_k| <= W = (--near-gaps) mean gaps, summed exactly over the file.
far tail:  exact file sum, and separately the bound
    sum_{far} f(gamma_j) <= int f dNbar + |int f dR|,   N = Nbar + R,
    Nbar(T) = (T/2pi) log(T/2pi) - T/2pi + 7/8,   |R(T)| <= Rmax(T) = 0.137 log T + 0.443 log log T + 4.35
    (Rosser 1941 form; ASSUMED here, stated in the .md),  |int_a^inf f dR| <= Rmax(a) f(a) + int Rmax |f'|,
with f built from Psi_b(s) = min(1/2 - 2/pi^2, pi^2/(s(s^2-pi^2)) + (3 pi^2 s^2 - pi^4)/(s^2 (s^2-pi^2)^2)),
which dominates |Psi| (checked numerically, unit test U3).

STRIP WORST CASE
----------------
Ghat entire, supp G in [-h, h]  =>  |Ghat(sigma + i t)| <= e^{|sigma - 1/2| h} sup ... ; with the
other zeros anywhere in the strip each |Ghat(gamma_j)|^2 is replaced by e^{h} |Ghat(gamma_j)|^2:
Z'_worst = e^{h} Z'.

SOLVE
-----
L_c^theory = 2 h* with 2|B|^2(h*) = Z'(h*) + tail(h*) (w = 1/2), root of the first sign change on
the instrument's L grid (extended downward with the same ratio), refined by bisection in log h.
Variants: Z' -> near-only, far-only (exact), far-only (N(T) bound), e^{h} Z'; |B|^2 -> first order;
w = 1.  Fits L_c^theory = a + b log gamma_k per eps, slopes against the measured ones.

Unit tests: Psi / Sigma / C / m2 / m22 against quadrature, Psi_b domination, the fixed G projected
onto the modulated basis at k = 10, eps = 0.01, h = L_c/2 and evaluated with the instrument's
own Z' matrix and transforms (weil_Lc_mod.zero_side_mod, transforms_mod, gram_mod), pole term
against quadrature, far-bound integral convergence.

Outputs: weil_Lc_theory.txt, results/weil_Lc_theory.json (results/weil_Lc_theory.log via tee).
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
from mpmath import mp, mpf, mpc, matrix as mpmatrix

_HERE = os.path.dirname(os.path.abspath(__file__))
RESULTS = os.path.join(_HERE, "results")
PI = math.pi


def _load(name):
    spec = importlib.util.spec_from_file_location(name, os.path.join(_HERE, name + ".py"))
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


wm = _load("weil_Lc_mod")        # zero_side_mod, ghat_row_as_in_gram, transforms_mod, gram_mod, adams_table, basis_eval_np
le = wm.le                       # weil_Lc_eps
lh = wm.lh                       # weil_Lc_height: rank_one_mp, lstsq_line
wq = wm.wq                       # weil_QX: ZEROS_FILE

M2 = 1.0 / 3.0 - 2.0 / PI ** 2                    # int x^2 P
M22 = (2.0 - 15.0 / PI ** 2) / 8.0               # int x^2 P^2
ABSMOM = 0.5 - 2.0 / PI ** 2                      # int |x| P  (trivial bound on |Psi|)


# ------------------------------------------------------------ elementary pieces (complex-safe, vectorised)
def iota(a):
    """(sin a - a cos a)/a^2, series for |a| < 0.5 (complex ok)."""
    a = np.asarray(a, dtype=complex)
    out = np.empty_like(a)
    small = np.abs(a) < 0.5
    big = ~small
    ab = a[big]
    out[big] = (np.sin(ab) - ab * np.cos(ab)) / ab ** 2
    asm = a[small]
    s = np.zeros_like(asm)
    for m in range(1, 16):
        s += (-1) ** (m + 1) * 2 * m * asm ** (2 * m - 1) / math.factorial(2 * m + 1)
    out[small] = s
    return out


def Psi(s):
    """int x cos^2(pi x/2) sin(s x) dx (complex ok)."""
    s = np.asarray(s, dtype=complex)
    return iota(s) + (iota(s + PI) + iota(s - PI)) / 2


def Psi_real(s):
    return Psi(s).real


def Sigma(s):
    """int x cos^2(pi x/2) sinh(s x) dx = -i Psi(i s)."""
    s = np.asarray(s, dtype=complex)
    return (-1j * Psi(1j * s)).real


def Kmom(a):
    """int_{-1}^{1} x^2 cos(a x) dx, series for |a| < 0.5."""
    a = np.asarray(a, dtype=float)
    out = np.empty_like(a)
    small = np.abs(a) < 0.5
    ab = a[~small]
    out[~small] = 2 * ((ab ** 2 - 2) * np.sin(ab) + 2 * ab * np.cos(ab)) / ab ** 3
    asm = a[small]
    s = np.zeros_like(asm)
    for m in range(0, 14):
        s += (-1) ** m * 2 * asm ** (2 * m) / (math.factorial(2 * m) * (2 * m + 3))
    out[small] = s
    return out


def Cmom(w):
    """int x^2 cos^4(pi x/2) cos(w x) dx."""
    w = np.asarray(w, dtype=float)
    return (3 * Kmom(w) + 2 * Kmom(w + PI) + 2 * Kmom(w - PI) + (Kmom(w + 2 * PI) + Kmom(w - 2 * PI)) / 2) / 8


def Psi_bound(s):
    """Envelope >= |Psi(s)| for s >= 0: trivial int|x|P below 2 pi, the s^-3 closed bound above."""
    s = np.asarray(s, dtype=float)
    out = np.full_like(s, ABSMOM)
    big = s >= 2 * PI
    sb = s[big]
    cb = PI ** 2 / (sb * (sb ** 2 - PI ** 2)) + (3 * PI ** 2 * sb ** 2 - PI ** 4) / (sb ** 2 * (sb ** 2 - PI ** 2) ** 2)
    out[big] = np.minimum(ABSMOM, cb)
    return out


def wfac(h, g):
    """(N h/2)^2 = h / (2 (m22 + C(2 gamma h))) for ||G|| = 1."""
    return h / (2 * (M22 + float(Cmom(2 * g * h))))


def AB_exact(h, g, eps):
    """(A, B) complex for the fixed window (exact in eps, both lobes)."""
    Nh2 = math.sqrt(wfac(h, g))                   # N h / 2
    pm = complex(Psi(2 * g * h - 1j * eps * h)[()])
    pp = complex(Psi(2 * g * h + 1j * eps * h)[()])
    A = 1j * Nh2 * (pm + pp) / 2
    B = Nh2 * (float(Sigma(eps * h)[()]) + 1j * (pm - pp) / 2)
    return A, B


def B2_first_order(h, g, eps):
    """eps^2 (N h^2 m2/2)^2 with the exact norm."""
    return eps ** 2 * wfac(h, g) * h ** 2 * M2 ** 2


def pole_term(h, g):
    """int F 2cosh(u/2) du = 2 Ghat(i/2) Ghat(-i/2), Ghat(t) = (i N h/2)[Psi(h(t-g)) + Psi(h(t+g))]."""
    Nh2 = math.sqrt(wfac(h, g))
    gp = 1j * Nh2 * (Psi(h * (0.5j - g)) + Psi(h * (0.5j + g)))[()]
    gm = 1j * Nh2 * (Psi(h * (-0.5j - g)) + Psi(h * (-0.5j + g)))[()]
    return complex(2 * gp * gm)


# ------------------------------------------------------------ N(T) machinery
def Nbar_prime(t):
    return np.log(np.maximum(t, 1e-300) / (2 * PI)) / (2 * PI)


def Rmax(t):
    t = np.maximum(np.asarray(t, dtype=float), 3.0)
    return 0.137 * np.log(t) + 0.443 * np.log(np.log(t)) + 4.35


def right_bound(h, g, a, npts=6000, ymax=24.0):
    """Upper bound on sum_{gamma_j > a} [Psi_b(h(gamma_j-g)) + Psi_b(h(gamma_j+g))]^2 via N(T)."""
    y = np.linspace(0.0, ymax, npts)
    d = (a - g) * np.exp(y)                       # t - g on a log grid from a - g
    t = g + d
    f = (Psi_bound(h * d) + Psi_bound(h * (t + g))) ** 2
    integ = np.trapezoid(f * Nbar_prime(t) * d, y)    # dt = d dy
    # |int f dR| <= Rmax(a) f(a) + sum Rmax(t_{i+1}) (f_i - f_{i+1})   (f decreasing, Rmax increasing)
    rterm = float(Rmax(t[0]) * f[0] + np.sum(Rmax(t[1:]) * np.maximum(f[:-1] - f[1:], 0.0)))
    return float(integ), rterm


def left_bound(h, g, b, npts=6000):
    """Upper bound on sum_{0 < gamma_j < b} 2[Psi_b(h(g-gamma_j))^2 + Psi_b(h(gamma_j+g))^2] via N(T); b = g - W > 0."""
    if b <= 0:
        return 0.0, 0.0
    W = g - b
    y = np.linspace(0.0, math.log(g / W), npts)
    d = W * np.exp(y)                              # g - t
    t = g - d
    f1 = 2 * Psi_bound(h * d) ** 2
    f2 = 2 * Psi_bound(h * (t + g)) ** 2
    integ = np.trapezoid((f1 + f2) * Nbar_prime(np.maximum(t, 1e-2)) * d, y)   # log singularity of Nbar' at t -> 0 clipped (integrable, negligible)
    rterm = float(2 * Rmax(b) * (f1.max() + f2.max()))
    return float(integ), rterm


# ------------------------------------------------------------ quadrature helpers (numpy)
def gl_panels(a, b, panels, nodes=20):
    x, w = leggauss(nodes)
    edges = np.linspace(a, b, panels + 1)
    c = (edges[:-1] + edges[1:]) / 2
    r = (edges[1:] - edges[:-1]) / 2
    X = (c[:, None] + r[:, None] * x[None, :]).ravel()
    Wt = (r[:, None] * w[None, :]).ravel()
    return X, Wt


def P_rc(x):
    return np.cos(PI * x / 2) ** 2


def envelope_from_coeffs(M, coeffs, x):
    """a(x), b(x): cos-block and sin-block envelopes of the minimiser at x = u/h, in the orthonormal-on-[-1,1] Legendre basis."""
    c = np.asarray(coeffs, dtype=float)
    n = np.arange(M)
    V = legvander(x, M - 1) * np.sqrt((2 * n + 1) / 2.0)[None, :]
    return V @ c[:M], V @ c[M:]


# ------------------------------------------------------------------ main
def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    ap.add_argument("--mod-json", type=str, default=os.path.join(RESULTS, "weil_Lc_mod.json"))
    ap.add_argument("--near-gaps", type=float, default=4.0, help="near lobe half-width in mean gaps")
    ap.add_argument("--Lmin-ext", type=float, default=0.02, help="extend the instrument grid downward to this L")
    ap.add_argument("--bisect-rel", type=float, default=1e-10)
    ap.add_argument("--bisect-ratio", type=float, default=1.02, help="instrument-style bracket ratio, reported alongside")
    ap.add_argument("--dps", type=int, default=40)
    ap.add_argument("--no-unit-tests", action="store_true")
    ap.add_argument("--out", type=str, default=os.path.join(RESULTS, "weil_Lc_theory.json"))
    ap.add_argument("--txt", type=str, default=os.path.join(_HERE, "weil_Lc_theory.txt"))
    args = ap.parse_args()
    mp.dps = args.dps
    T0 = time.time()
    out_lines = []

    def say(s=""):
        print(s)
        sys.stdout.flush()
        out_lines.append(s)

    with open(args.mod_json) as fh:
        mod = json.load(fh)
    mod_sha = hashlib.sha256(open(args.mod_json, "rb").read()).hexdigest()
    ks = mod["params"]["ks"]
    eps_list = [e for e in mod["params"]["eps"] if e > 0]
    Mmod = mod["params"]["M"]
    Lgrid_inst = mod["params"]["L_grid"]
    ratio = Lgrid_inst[1] / Lgrid_inst[0]
    grid = list(Lgrid_inst)
    while grid[0] / ratio >= args.Lmin_ext:
        grid.insert(0, grid[0] / ratio)
    hgrid = [L / 2 for L in grid]

    gfile = np.array([float(l.split()[0]) for l in open(wq.ZEROS_FILE)])
    gam_N = float(gfile[-1])
    gk_mp = {}

    def gz(k):
        if k not in gk_mp:
            gk_mp[k] = mp.zetazero(k).imag
        return gk_mp[k]

    mean_gap = {k: 2 * PI / math.log(float(gz(k)) / (2 * PI)) for k in ks}

    say("weil_Lc_theory  EXPLORATORY - no prereg, no decision rule, no verdict.")
    say(f"  fixed window G = N (u/h) cos^2(pi u/2h) cos(gamma_k u), ||G|| = 1;  m2 = {M2:.10f}  m22 = {M22:.10f}  int|x|P = {ABSMOM:.10f}")
    say(f"  measured rows: {args.mod_json} (sha256 {mod_sha[:16]}...), k={ks}, eps={eps_list}, M={Mmod}")
    say(f"  zeros1.txt: {len(gfile)} zeros, gamma_N {gam_N:.3f};  near lobe |gamma_j - gamma_k| <= {args.near_gaps:g} mean gaps")
    say(f"  L grid {grid[0]:.4f}..{grid[-1]:.3f} ({len(grid)} pts, ratio {ratio:.4f}; instrument grid extended downward), bisection to rel {args.bisect_rel:g}")
    say(f"  Rmax(T) = 0.137 log T + 0.443 log log T + 4.35 (ASSUMED bound on |N - Nbar|)")
    say("")

    # ============================================================ unit tests
    tests = {}
    if not args.no_unit_tests:
        t0 = time.time()
        say("Unit tests")
        X, Wq = gl_panels(-1.0, 1.0, 400, 20)
        xP = X * P_rc(X)
        # U1 Psi closed form vs quadrature (real and complex s)
        rows = []
        for s in [1e-4, 0.3, 1.0, PI - 1e-3, PI, PI + 1e-9, 5.0, 20.0, 100.0, 1000.0, 2 + 0.5j, 1e-3j, 30 - 0.05j]:
            q = complex(np.sum(Wq * xP * np.sin(s * X)))
            c = complex(Psi(s)[()])
            rows.append({"s": str(s), "closed": [c.real, c.imag], "quad": [q.real, q.imag], "abs_err": abs(c - q), "rel_err": abs(c - q) / max(abs(q), 1e-300)})
        worst = max(r["abs_err"] for r in rows)
        say(f"  [U1] Psi closed form vs 8000-node GL quadrature, {len(rows)} arguments: max abs err {worst:.1e} (max rel {max(r['rel_err'] for r in rows):.1e})")
        tests["U1_Psi_vs_quad"] = rows
        # U2 Sigma vs quadrature and first order
        rows = []
        for s in [1e-4, 1e-3, 0.01, 0.1, 0.5, 1.0]:
            q = float(np.sum(Wq * xP * np.sinh(s * X)))
            c = float(Sigma(s)[()])
            rows.append({"s": s, "closed": c, "quad": q, "rel_err": abs(c - q) / abs(q), "first_order": s * M2, "first_order_rel_dev": s * M2 / q - 1})
        say(f"  [U2] Sigma(s) closed vs quad: max rel err {max(r['rel_err'] for r in rows):.1e};  s m2 / Sigma - 1 at s=0.1: {rows[3]['first_order_rel_dev']:.2e}, s=0.5: {rows[4]['first_order_rel_dev']:.2e}")
        tests["U2_Sigma"] = rows
        # U3 Psi_bound dominates |Psi|
        sg = np.concatenate([np.linspace(0, 50, 200001), np.exp(np.linspace(math.log(50), math.log(2e5), 200001))])
        rat = np.abs(Psi_real(sg)) / Psi_bound(sg)
        i = int(np.argmax(rat))
        say(f"  [U3] max |Psi|/Psi_bound on [0, 2e5] ({len(sg)} pts): {rat[i]:.6f} at s = {sg[i]:.4f};  Psi_bound(2pi) = {float(Psi_bound(2*PI)):.5f}, |Psi(2pi)| = {abs(float(Psi_real(2*PI))):.5f}")
        tests["U3_Psi_bound"] = {"max_ratio": float(rat[i]), "at_s": float(sg[i]), "npts": int(len(sg))}
        # U4 moments and C(w)
        rows = []
        for w in [0.0, 0.3, 4.2, 2 * PI, 50.0, 1000.0]:
            q = float(np.sum(Wq * X ** 2 * P_rc(X) ** 2 * np.cos(w * X)))
            c = float(Cmom(w)[()])
            rows.append({"w": w, "closed": c, "quad": q, "abs_err": abs(c - q)})
        m2q = float(np.sum(Wq * X ** 2 * P_rc(X)))
        say(f"  [U4] m2 closed {M2:.12f} quad {m2q:.12f} (diff {abs(M2-m2q):.1e});  m22 closed {M22:.12f} quad {rows[0]['quad']:.12f} (diff {rows[0]['abs_err']:.1e});  C(w) max abs err {max(r['abs_err'] for r in rows):.1e}")
        tests["U4_moments"] = {"m2_closed": M2, "m2_quad": m2q, "C_rows": rows}
        # U5 norm at k=10, h = L_c/2 by quadrature on u
        k, eps = 10, 0.01
        row10 = mod["ladder"][f"k={k}|eps={eps}|M={Mmod}|w=1/2"]
        h10 = row10["L_c"] / 2
        g10 = float(gz(10))
        Nh2 = math.sqrt(wfac(h10, g10))
        N10 = 2 * Nh2 / h10
        U, Wu = gl_panels(-h10, h10, int(math.ceil(4 * g10 * h10 / PI)) + 8, 20)
        Gu = N10 * (U / h10) * P_rc(U / h10) * np.cos(g10 * U)
        nrm = float(np.sum(Wu * Gu ** 2))
        say(f"  [U5] ||G||^2 by quadrature at k=10, h={h10:.5f}: {nrm:.15f} (exact-norm N = {N10:.8f}; C(2 gamma h)/m22 = {float(Cmom(2*g10*h10)[()])/M22:.2e})")
        tests["U5_norm"] = {"k": k, "h": h10, "norm2_quad": nrm, "N": N10}
        # U6 projection onto the modulated basis, evaluated with the instrument's matrices
        t1 = time.time()
        Mp = Mmod
        n = np.arange(Mp)
        Vx = legvander(X, Mp - 1)                                  # P_n(x)
        proj = N10 * np.sqrt((2 * n + 1) / (2 * h10)) * h10 * ((Wq * xP) @ Vx)   # c_n = int G_env G_n^Leg du
        cvec = [mpf(float(v)) for v in proj] + [mpf(0)] * Mp
        adams = wm.adams_table(Mp)
        S = wm.gram_mod(Mp, h10, gz(k), adams)
        Za, _ = wm.zero_side_mod(Mp, h10, g10, gfile)
        Rk = wm.ghat_row_as_in_gram(Mp, h10, g10, gfile, k)
        Zp = Za - lh.rank_one_mp(Rk)
        Tl = wm.tail_mod(Mp, h10, gz(k), gam_N)
        A_i, B_i = wm.transforms_mod(Mp, h10, gz(k), eps)

        def quad_form(Mat):
            return float(mp.fsum(cvec[i] * Mat[i, j] * cvec[j] for i in range(2 * Mp) for j in range(2 * Mp)))

        Snorm = quad_form(S)
        Zinst = quad_form(Zp)
        Tinst = quad_form(Tl)
        Binst = abs(complex(mp.fsum(cvec[a] * B_i[a] for a in range(2 * Mp)))) ** 2
        Ainst = abs(complex(mp.fsum(cvec[a] * A_i[a] for a in range(2 * Mp)))) ** 2
        # closed forms at the same h, gamma (file zeros, j != k)
        d = np.delete(gfile, k - 1) - g10
        sp = np.delete(gfile, k - 1) + g10
        Zclosed = 2 * wfac(h10, g10) * float(np.sum((Psi_real(h10 * d) + Psi_real(h10 * sp)) ** 2))
        Ac, Bc = AB_exact(h10, g10, eps)
        trunc = float(np.sum(Wq * xP ** 2) - np.sum(((Wq * xP) @ Vx) ** 2 * (2 * n + 1) / 2))   # L2 mass of xP beyond n < M
        say(f"  [U6] k=10 eps=0.01 h={h10:.5f}: fixed G projected on the modulated basis (cos block, odd n < {Mp}); L2 mass of xP beyond n<{Mp}: {trunc:.2e}")
        say(f"       c^T S c = {Snorm:.12f}   c^T Z' c = {Zinst:.10e} vs closed {Zclosed:.10e} (rel {Zinst/Zclosed-1:+.2e})   tail c^T T c = {Tinst:.2e} (closed 0)")
        say(f"       |B.c|^2 = {Binst:.10e} vs closed {abs(Bc)**2:.10e} (rel {Binst/abs(Bc)**2-1:+.2e})   |A.c|^2 = {Ainst:.4e} vs closed {abs(Ac)**2:.4e}   first-order 2|B|^2 = {2*B2_first_order(h10,g10,eps):.10e}")
        say(f"       instrument minimiser at this h: Z' {row10['minimiser_at_Lc']['Zprime_at_min']:.4e}  |B|^2 {row10['minimiser_at_Lc']['B2']:.4e};  {time.time()-t1:.1f}s")
        tests["U6_projection_vs_instrument"] = {"k": k, "eps": eps, "h": h10, "M": Mp, "coeffs_cos_block": proj.tolist(), "trunc_mass": trunc,
                                                "cSc": Snorm, "Zprime_instrument": Zinst, "Zprime_closed": Zclosed, "Zprime_rel": Zinst / Zclosed - 1,
                                                "tail_instrument": Tinst, "B2_instrument": Binst, "B2_closed": abs(Bc) ** 2, "B2_rel": Binst / abs(Bc) ** 2 - 1,
                                                "A2_instrument": Ainst, "A2_closed": abs(Ac) ** 2, "B2_first_order": B2_first_order(h10, g10, eps),
                                                "minimiser_Zprime": row10["minimiser_at_Lc"]["Zprime_at_min"], "minimiser_B2": row10["minimiser_at_Lc"]["B2"]}
        # U7 pole term vs quadrature
        pq = float(np.sum(Wu * Gu * np.exp(-U / 2)) * np.sum(Wu * Gu * np.exp(U / 2)) * 2)
        pc = pole_term(h10, g10)
        say(f"  [U7] pole term 2 Ghat(i/2) Ghat(-i/2) at k=10, h={h10:.5f}: closed {pc.real:.6e}{pc.imag:+.1e}i  quad {pq:.6e}  (abs diff {abs(pc.real-pq):.1e})")
        tests["U7_pole"] = {"closed": [pc.real, pc.imag], "quad": pq}
        # U8 far-bound convergence
        gk = float(gz(1000))
        W = args.near_gaps * mean_gap[1000]
        r1 = right_bound(2.0, gk, gk + W, npts=6000)
        r2 = right_bound(2.0, gk, gk + W, npts=24000, ymax=30.0)
        l1 = left_bound(2.0, gk, gk - W, npts=6000)
        l2 = left_bound(2.0, gk, gk - W, npts=24000)
        say(f"  [U8] far-bound integrals at k=1000, h=2: right {r1[0]:.6e} + R {r1[1]:.3e} (24000 pts: {r2[0]:.6e} + {r2[1]:.3e});  left {l1[0]:.6e} + R {l1[1]:.3e} (24000 pts: {l2[0]:.6e} + {l2[1]:.3e})")
        tests["U8_far_bound_convergence"] = {"right_6000": r1, "right_24000": r2, "left_6000": l1, "left_24000": l2}
        say(f"  unit tests: {time.time()-t0:.1f}s")
        say("")

    # ============================================================ section 0: the measured minimisers
    say("Section 0 - measured minimisers (w = 1/2, at the recorded L_c): parity split, envelope distances, first-order |B|^2")
    say(f"{'k':>5} {'eps':>6} {'L_c':>8} {'cos:even':>9} {'cos:odd':>8} {'sin:even':>9} {'sin:odd':>8} {'d(|x|P)':>8} {'d(P)':>7} {'d(x(1-x2))':>10} "
        f"{'B2_json':>10} {'B2_quad':>10} {'B2_1st':>10} {'1st/exact':>9} {'A2_json':>9} {'A2_quad':>9}")
    xg = np.linspace(-1, 1, 4001)
    cand = {"|x|P": np.abs(xg) * P_rc(xg), "P": P_rc(xg), "x(1-x2)": np.abs(xg * (1 - xg ** 2))}
    for kk in cand:
        cand[kk] = cand[kk] / math.sqrt(np.trapezoid(cand[kk] ** 2, xg))
    sec0 = []
    for k in ks:
        g = float(gz(k))
        for eps in eps_list:
            r = mod["ladder"][f"k={k}|eps={eps}|M={Mmod}|w=1/2"]
            if r.get("L_c") is None:
                continue
            h = r["L_c"] / 2
            c = np.array(r["minimiser_at_Lc"]["coeffs"], dtype=float)
            n = np.arange(Mmod)
            ce, co = float(np.linalg.norm(c[:Mmod][n % 2 == 0])), float(np.linalg.norm(c[:Mmod][n % 2 == 1]))
            se, so = float(np.linalg.norm(c[Mmod:][n % 2 == 0])), float(np.linalg.norm(c[Mmod:][n % 2 == 1]))
            a_x, b_x = envelope_from_coeffs(Mmod, c, xg)
            R = np.sqrt(a_x ** 2 + b_x ** 2)
            R = R / math.sqrt(np.trapezoid(R ** 2, xg))
            dist = {kk: float(math.sqrt(np.trapezoid((R - v) ** 2, xg))) for kk, v in cand.items()}
            U, Wu = gl_panels(-h, h, int(math.ceil(4 * g * h / PI)) + 8, 20)
            Gs = c @ wm.basis_eval_np(Mmod, h, g, U)
            ph = np.exp(1j * g * U)
            Bq = complex(np.sum(Wu * Gs * ph * np.sinh(eps * U)))
            B1 = eps * complex(np.sum(Wu * Gs * ph * U))
            Aq = complex(np.sum(Wu * Gs * ph * np.cosh(eps * U)))
            nq = float(np.sum(Wu * Gs ** 2))
            m = r["minimiser_at_Lc"]
            row = {"k": k, "eps": eps, "L_c": r["L_c"], "h": h, "cos_even": ce, "cos_odd": co, "sin_even": se, "sin_odd": so,
                   "envelope_L2_dist": dist, "norm2_quad": nq,
                   "B2_json": m["B2"], "B2_quad_exact": abs(Bq) ** 2, "B2_first_order": abs(B1) ** 2,
                   "first_over_exact": abs(B1) ** 2 / abs(Bq) ** 2, "quad_over_json": abs(Bq) ** 2 / m["B2"],
                   "A2_json": m["A2"], "A2_quad": abs(Aq) ** 2}
            sec0.append(row)
            say(f"{k:>5} {eps:>6g} {r['L_c']:>8.4f} {ce:>9.3f} {co:>8.3f} {se:>9.3f} {so:>8.3f} {dist['|x|P']:>8.3f} {dist['P']:>7.3f} {dist['x(1-x2)']:>10.3f} "
                f"{m['B2']:>10.3e} {abs(Bq)**2:>10.3e} {abs(B1)**2:>10.3e} {abs(B1)**2/abs(Bq)**2:>9.5f} {m['A2']:>9.2e} {abs(Aq)**2:>9.2e}")
    say("  (parity columns: 2-norms of the Legendre coefficients by n parity; d(.) = L2 distance on [-1,1] between unit-normalised envelope sqrt(a^2+b^2) and the candidate;")
    say("   B2_quad = |int G* e^{i gamma u} sinh(eps u) du|^2 by quadrature from the JSON coefficients, B2_1st = eps^2 |int u G* e^{i gamma u} du|^2)")
    say("")

    # ============================================================ pieces of the theory at (k, h)
    piece_cache = {}

    def pieces(k, h):
        key = (k, h)
        if key in piece_cache:
            return piece_cache[key]
        g = float(gz(k))
        W = args.near_gaps * mean_gap[k]
        others = np.delete(gfile, k - 1)
        d = others - g
        val = (Psi_real(h * d) + Psi_real(h * (others + g))) ** 2
        near = np.abs(d) <= W
        wf = wfac(h, g)
        Znear = 2 * wf * float(np.sum(val[near]))
        Zfar = 2 * wf * float(np.sum(val[~near]))
        rb = right_bound(h, g, g + W)
        lb = left_bound(h, g, g - W)
        Zfar_bound = 2 * wf * (rb[0] + rb[1] + lb[0] + lb[1])
        bf = right_bound(h, g, gam_N)
        beyond = 2 * wf * (bf[0] + bf[1])
        res = {"Znear": Znear, "Zfar": Zfar, "Zfar_bound": Zfar_bound, "Zfar_bound_integral": 2 * wf * (rb[0] + lb[0]),
               "Zfar_bound_Rterm": 2 * wf * (rb[1] + lb[1]), "beyond_file_bound": beyond, "tail_instrument": 0.0,
               "n_near": int(np.sum(near)), "wfac": wf, "W": W}
        piece_cache[key] = res
        return res

    VARIANTS = ["full", "near_only", "far_only_exact", "far_only_bound", "strip_worst_eh", "first_order_B", "w1"]

    def Qfun(variant, k, eps, h):
        p = pieces(k, h)
        g = float(gz(k))
        A, B = AB_exact(h, g, eps)
        B2 = abs(B) ** 2
        tail = p["tail_instrument"] + p["beyond_file_bound"]
        if variant == "full":
            return p["Znear"] + p["Zfar"] + tail - 2 * B2
        if variant == "near_only":
            return p["Znear"] - 2 * B2
        if variant == "far_only_exact":
            return p["Zfar"] + tail - 2 * B2
        if variant == "far_only_bound":
            return p["Zfar_bound"] - 2 * B2
        if variant == "strip_worst_eh":
            return math.exp(h) * (p["Znear"] + p["Zfar"]) + tail - 2 * B2
        if variant == "first_order_B":
            return p["Znear"] + p["Zfar"] + tail - 2 * B2_first_order(h, g, eps)
        if variant == "w1":
            return p["Znear"] + p["Zfar"] + tail - 4 * B2
        raise ValueError(variant)

    def solve(variant, k, eps):
        vals = [Qfun(variant, k, eps, h) for h in hgrid]
        idx = None
        for i in range(1, len(hgrid)):
            if vals[i] < 0 and vals[i - 1] > 0:
                idx = i
                break
        if idx is None:
            if vals[0] < 0:
                return {"L_c": None, "note": f"negative already at L = {grid[0]:.4f}", "grid_Q": vals}
            return {"L_c": None, "note": f"no sign change up to L = {grid[-1]:.3f} (min Q {min(vals):.3e})", "grid_Q": vals}
        lo, hi = hgrid[idx - 1], hgrid[idx]
        flo, fhi = vals[idx - 1], vals[idx]
        bracket_inst = None
        nb = 0
        while hi / lo - 1 > args.bisect_rel and nb < 200:
            mid = math.sqrt(lo * hi)
            fm = Qfun(variant, k, eps, mid)
            if fm < 0:
                hi, fhi = mid, fm
            else:
                lo, flo = mid, fm
            nb += 1
            if bracket_inst is None and hi / lo < args.bisect_ratio:
                bracket_inst = [2 * lo, 2 * hi]
        root = math.sqrt(lo * hi)
        return {"L_c": 2 * root, "h": root, "bracket_instrument_style": bracket_inst, "n_bisect": nb,
                "grid_first_negative_L": grid[idx], "n_grid_positive_after": int(sum(1 for v in vals[idx:] if v > 0))}

    # ============================================================ main tables
    t0 = time.time()
    theory = {}
    say("Section 1 - L_c^theory (fixed window, w = 1/2, 2|B|^2 = Z' + tail) against the measured L_c (w = 1/2, upper bracket end)")
    say(f"{'k':>5} {'gamma_k':>10} {'eps':>6} {'L_c_meas':>9} {'L_c_th':>9} {'meas/th':>8} {'h*':>7} {'2|B|^2':>10} {'Z_near':>10} {'Z_far':>10} {'Zfar_bnd':>10} {'beyond':>9} {'2|A|^2':>9} {'n_near':>6} {'eps*h':>7} {'B2_1st/ex':>9}")
    for k in ks:
        g = float(gz(k))
        for eps in eps_list:
            r = mod["ladder"][f"k={k}|eps={eps}|M={Mmod}|w=1/2"]
            Lm = r.get("L_c")
            res = {v: solve(v, k, eps) for v in VARIANTS}
            f = res["full"]
            row = {"k": k, "eps": eps, "gamma_k": g, "log_gamma_k": math.log(g), "mean_gap": mean_gap[k],
                   "L_c_meas": Lm, "L_c_meas_bracket": r.get("L_c_bracket"), "L_c_meas_w1": r.get("L_c_w1"),
                   "variants": res}
            if f["L_c"] is not None:
                hs = f["h"]
                p = pieces(k, hs)
                A, B = AB_exact(hs, g, eps)
                row["at_root"] = {"h": hs, "two_B2": 2 * abs(B) ** 2, "two_B2_first_order": 2 * B2_first_order(hs, g, eps),
                                  "two_A2": 2 * abs(A) ** 2, "Z_near": p["Znear"], "Z_far_exact": p["Zfar"], "Z_far_bound": p["Zfar_bound"],
                                  "Z_far_bound_integral": p["Zfar_bound_integral"], "Z_far_bound_Rterm": p["Zfar_bound_Rterm"],
                                  "beyond_file_bound": p["beyond_file_bound"], "tail_instrument": 0.0, "n_near": p["n_near"], "W": p["W"],
                                  "pole": [pole_term(hs, g).real, pole_term(hs, g).imag], "eps_h": eps * hs,
                                  "N": 2 * math.sqrt(p["wfac"]) / hs, "C_over_m22": float(Cmom(2 * g * hs)[()]) / M22}
                row["ratio_meas_over_theory"] = Lm / f["L_c"] if Lm else None
                ar = row["at_root"]
                say(f"{k:>5} {g:>10.3f} {eps:>6g} {Lm if Lm else float('nan'):>9.4f} {f['L_c']:>9.4f} {row['ratio_meas_over_theory'] if Lm else float('nan'):>8.4f} {hs:>7.4f} "
                    f"{ar['two_B2']:>10.3e} {ar['Z_near']:>10.3e} {ar['Z_far_exact']:>10.3e} {ar['Z_far_bound']:>10.3e} {ar['beyond_file_bound']:>9.1e} {ar['two_A2']:>9.1e} {ar['n_near']:>6d} {ar['eps_h']:>7.4f} {ar['two_B2_first_order']/ar['two_B2']:>9.5f}")
            else:
                say(f"{k:>5} {g:>10.3f} {eps:>6g} {Lm if Lm else float('nan'):>9.4f} {'none':>9}   {f['note']}")
            theory[f"k={k}|eps={eps}"] = row
    say("  (columns at h* = L_c^theory/2: Z_near = exact sum over |gamma_j - gamma_k| <= W, Z_far = exact file sum beyond W, Zfar_bnd = N(T) bound on it,")
    say("   beyond = N(T) bound on zeros past gamma_N (the tail for this G; the instrument's (G(h)^2+G(-h)^2) tail is 0), B2_1st/ex = first-order / exact |B|^2)")
    say("")

    say("Section 2 - which piece sets L_c: L_c^theory with Z' replaced piecewise, and the strip worst case e^{h} Z'")
    say(f"{'k':>5} {'eps':>6} {'L_c_meas':>9} {'full':>8} {'near':>8} {'far_ex':>8} {'far_bnd':>8} {'e^h Z':>8} {'1st-B':>8} {'w=1':>8} {'w1_meas':>8}   {'e^h/full':>8} {'near/full':>9} {'farbnd/full':>11}")
    for k in ks:
        for eps in eps_list:
            row = theory[f"k={k}|eps={eps}"]
            v = row["variants"]

            def fmt(x):
                return f"{x:>8.4f}" if x is not None else f"{'none':>8}"

            Lf = v["full"]["L_c"]
            rat = {name: (v[name]["L_c"] / Lf if (Lf and v[name]["L_c"]) else None) for name in VARIANTS}
            row["variant_over_full"] = rat
            say(f"{k:>5} {eps:>6g} {fmt(row['L_c_meas'])} {fmt(Lf)} {fmt(v['near_only']['L_c'])} {fmt(v['far_only_exact']['L_c'])} {fmt(v['far_only_bound']['L_c'])} "
                f"{fmt(v['strip_worst_eh']['L_c'])} {fmt(v['first_order_B']['L_c'])} {fmt(v['w1']['L_c'])} {fmt(row['L_c_meas_w1'])}   "
                f"{fmt(rat['strip_worst_eh'])} {fmt(rat['near_only']):>9} {fmt(rat['far_only_bound']):>11}")
    say("")

    # ============================================================ fits
    say("Section 3 - fits L_c = a + b log gamma_k per eps (w = 1/2), theory variants against the measured slope")
    fits = {}
    for eps in eps_list:
        fits[str(eps)] = {}
        meas = mod["fits"][str(eps)]["log_gamma_k"]
        xs = np.array([theory[f"k={k}|eps={eps}"]["log_gamma_k"] for k in ks])
        Lmeas = np.array([theory[f"k={k}|eps={eps}"]["L_c_meas"] if theory[f"k={k}|eps={eps}"]["L_c_meas"] else np.nan for k in ks])
        fits[str(eps)]["measured"] = {"a": meas["a"], "b": meas["b"], "rms_resid": meas["rms_resid"], "R2": meas["R2"], "n": meas.get("n", len(ks))}
        say(f"  eps={eps:<6g} measured: a {meas['a']:>8.4f}  b {meas['b']:>7.4f}  rms {meas['rms_resid']:.4f}  R2 {meas['R2']:.4f}")
        for name in VARIANTS:
            Lth = np.array([theory[f"k={k}|eps={eps}"]["variants"][name]["L_c"] or np.nan for k in ks])
            ok = ~np.isnan(Lth)
            if ok.sum() >= 2:
                ft = lh.lstsq_line(xs[ok], Lth[ok])
                ft["n"] = int(ok.sum())
                ft["ks"] = [k for k, o in zip(ks, ok) if o]
                ft["slope_over_measured"] = ft["b"] / meas["b"]
                okm = ok & ~np.isnan(Lmeas)
                if okm.sum() >= 2:
                    ft["meas_vs_theory"] = lh.lstsq_line(Lth[okm], Lmeas[okm])
                    ft["mean_ratio_meas_over_theory"] = float(np.mean(Lmeas[okm] / Lth[okm]))
                    ft["ratio_range_meas_over_theory"] = [float(np.min(Lmeas[okm] / Lth[okm])), float(np.max(Lmeas[okm] / Lth[okm]))]
                fits[str(eps)][name] = ft
                mv = ft.get("meas_vs_theory")
                say(f"           {name:<15}: a {ft['a']:>8.4f}  b {ft['b']:>7.4f}  rms {ft['rms_resid']:.4f}  R2 {ft['R2']:.4f}  b/b_meas {ft['slope_over_measured']:.4f}  n {ft['n']}"
                    + (f"   meas = {mv['a']:+.4f} + {mv['b']:.4f} th (R2 {mv['R2']:.4f}); mean meas/th {ft['mean_ratio_meas_over_theory']:.4f} [{ft['ratio_range_meas_over_theory'][0]:.4f}, {ft['ratio_range_meas_over_theory'][1]:.4f}]" if mv else ""))
            else:
                fits[str(eps)][name] = {"note": "fewer than 2 points", "n": int(ok.sum())}
                say(f"           {name:<15}: fewer than 2 points")
    say("")
    say("Section 3b - eps exponent per k: log L_c = c + p log eps (theory full vs measured)")
    eps_exp = {}
    le_ = np.log(np.array(eps_list))
    for k in ks:
        Lth = np.array([theory[f"k={k}|eps={eps}"]["variants"]["full"]["L_c"] or np.nan for eps in eps_list])
        Lm = np.array([theory[f"k={k}|eps={eps}"]["L_c_meas"] or np.nan for eps in eps_list])
        ent = {}
        for nm, arr in (("theory_full", Lth), ("measured", Lm)):
            ok = ~np.isnan(arr)
            ent[nm] = lh.lstsq_line(le_[ok], np.log(arr[ok])) if ok.sum() >= 2 else {"note": "fewer than 2 points"}
        eps_exp[str(k)] = ent
        say(f"  k={k:<5d} theory p {ent['theory_full'].get('b', float('nan')):>8.4f} (R2 {ent['theory_full'].get('R2', float('nan')):.4f})   measured p {ent['measured'].get('b', float('nan')):>8.4f} (R2 {ent['measured'].get('R2', float('nan')):.4f})")
    say(f"  (asymptotic forms from the .md: h g << 1 -> p = -2/3; h g >> 1 -> p = -1/4)")
    say(f"  tables: {time.time()-t0:.1f}s")
    say("")

    # ============================================================ write
    payload = {"script": "weil_Lc_theory.py", "status": "EXPLORATORY - no prereg, no decision rule, no verdict",
               "timestamp": datetime.datetime.now().isoformat(timespec="seconds"),
               "params": {"mod_json": args.mod_json, "mod_json_sha256": mod_sha, "ks": ks, "eps": eps_list, "M_instrument": Mmod,
                          "near_gaps": args.near_gaps, "L_grid": grid, "bisect_rel": args.bisect_rel, "bisect_ratio": args.bisect_ratio,
                          "dps": args.dps, "zeros_file": wq.ZEROS_FILE, "n_zeros": int(len(gfile)), "gamma_N": gam_N,
                          "Rmax_form": "0.137 log T + 0.443 log log T + 4.35 (assumed)",
                          "window": {"G": "N (u/h) cos^2(pi u/(2h)) cos(gamma_k u)", "m2": M2, "m22": M22, "int_abs_x_P": ABSMOM,
                                     "mean_gap": {str(k): mean_gap[k] for k in ks}},
                          "variants": VARIANTS},
               "unit_tests": tests, "section0_minimisers": sec0, "theory": theory, "fits": fits, "eps_exponent": eps_exp,
               "timings": {"total_s": time.time() - T0}}
    os.makedirs(RESULTS, exist_ok=True)
    with open(args.out, "w") as fh:
        json.dump(payload, fh, indent=1)
    with open(args.txt, "w") as fh:
        fh.write("\n".join(out_lines) + "\n")
    sha = hashlib.sha256(open(args.out, "rb").read()).hexdigest()
    print(f"wrote {args.out} (sha256 {sha}) and {args.txt};  total {time.time()-T0:.1f}s")


if __name__ == "__main__":
    main()
