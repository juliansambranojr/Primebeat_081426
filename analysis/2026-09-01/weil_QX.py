"""weil_QX.py — the prime side of Weil's quadratic form as a numerical instrument,
on a ladder of truncation lengths X.  EXPLORATORY.  No prereg, no decision rule,
no verdict.

THE IDENTITY IMPLEMENTED (pinned from source, 2026-09-01)
----------------------------------------------------------
Bombieri 2000, "Remarks on Weil's quadratic functional in the theory of prime
numbers, I", Rend. Lincei (9) 11 (2000) 183-233, §12 eq. (12.2), additive form
(x = log of the multiplicative variable), quoted:

    T[F] = int 2 cosh(x/2) F(x) dx
           - sum_{n>=1} Lambda(n)/sqrt(n) (F(log n) + F(-log n))
           - (log 4pi + gamma) F(0)
           - int_0^inf ( e^{x/2}(F(x)+F(-x)) - 2F(0) ) dx/(e^x - e^{-x})

with T[F] = sum_gamma Fhat(gamma) over the zeros 1/2 + i gamma (both signs),
and "the last two terms in this formula can be written as
    -(log pi) F(0) + (1/2pi) int Gamma'/Gamma(1/4 + iv/2) Fhat(v) dv".

Connes-Consani 2020 (arXiv:2006.13771) Appendix B eqs (148)-(153) is the same
formula in the multiplicative variable, and the bench's own normalisation
(O36_weil_calibration.py:29-41, O37_weil_form_on_stencil.py:243-267) is the
same formula again with H(1/2+it) = int f(u) e^{iut} du:

    SUM_rho H(rho) = H(0) + H(1)
                     - 2 SUM_{n>=2} Lambda(n) n^{-1/2} f(log n)
                     + (1/2pi) int H(1/2+it) [Re psi(1/4+it/2) - log pi] dt

Weil's criterion (Bombieri Thm 1): RH  <=>  sum_rho gtilde(rho) gtilde(1-rho) > 0
for every g in C_0^inf((0,inf)) not identically 0, where f = g * g^* and
ftilde(s) = gtilde(s) gtilde(1-s).  Under RH the zero side is sum |gtilde(rho)|^2.

WHAT THIS COMPUTES
------------------
For a base function G(u) supported in [-L/2, L/2], L = log X, the Weil test
function is F = G * G~ (autocorrelation), supported in [-L, L], so exactly the
prime powers n <= X enter the prime sum.  Three arithmetic terms:

    pole  = int F(u) 2cosh(u/2) du           = 2 Ghat(i/2)^2   [= H(0)+H(1)]
    prime = 2 sum_{n<=X} Lambda(n) n^{-1/2} F(log n)
    arch  = -(log 4pi + gamma) F(0)
            - int_0^L (e^{x/2}(F(x)+F(-x)) - 2F(0)) dx/(e^x - e^{-x})
            + F(0) log coth(L/2)              [the exact tail x > L]

    total = pole - prime + arch                (= SUM_rho Fhat(rho))

and, independently, the zero side  Z_N = 2 sum_{k<=N} Ghat(gamma_k)^2  over the
first N zeros from mpmath.zetazero (cached), plus an extended sum over the
99,998 zeros in imported/twin_count/zeros1.txt, each with its tail estimate.
The archimedean term is also evaluated on the Fourier side,
(1/2pi) int Ghat(t)^2 [Re psi(1/4+it/2) - log pi] dt, as a cross-check of the
real-space form.

Two families:
    triangle : G = indicator of [-L/2, L/2];  F(u) = L - |u|;  Ghat(t) = 2 sin(Lt/2)/t
    bump     : G(u) = exp(-1/(1-(2u/L)^2)) on |u| < L/2, the standard C_c^inf bump

HOW IT WAS RUN
--------------
    cd /Users/juliansambrano/GitHub/Primebeat_081426
    .venv/bin/python analysis/2026-09-01/weil_QX.py

Outputs: analysis/2026-09-01/results/weil_QX.json, weil_QX.txt, zetazeros_N.json (cache).
"""
import argparse
import datetime
import hashlib
import json
import math
import os
import sys
import time

import numpy as np
from mpmath import (mp, mpf, mpc, quad, log, exp, sin, cos, sinh, cosh, sqrt, pi,
                    euler, digamma, re, zetazero, tanh, coth)
from sympy import primerange

_HERE = os.path.dirname(os.path.abspath(__file__))
_ROOT = os.path.abspath(os.path.join(_HERE, "..", ".."))
RESULTS = os.path.join(_HERE, "results")
ZEROS_FILE = os.path.join(_ROOT, "imported", "twin_count", "zeros1.txt")


def _code_version():
    with open(os.path.abspath(__file__), "rb") as fh:
        return hashlib.sha256(fh.read()).hexdigest()


# ----------------------------------------------------------------- zeros
def load_zeros(n, cache_path):
    """First n zeta zeros (imag parts) via mpmath.zetazero, cached as strings."""
    zs = []
    if os.path.exists(cache_path):
        zs = json.load(open(cache_path))
    if len(zs) < n:
        t0 = time.time()
        for k in range(len(zs) + 1, n + 1):
            zs.append(str(zetazero(k).imag))
            if k % 250 == 0:
                print(f"    zetazero {k}  {time.time()-t0:.1f}s", flush=True)
        json.dump(zs, open(cache_path, "w"))
    return [mpf(z) for z in zs[:n]]


def tail_estimate(gam_N):
    """sum_{gamma > gam_N} 8 sin^2(L gamma/2)/gamma^2 with sin^2 -> 1/2 and
    density (1/2pi) log(t/2pi):  (2/pi) (log(gam_N/2pi) + 1)/gam_N.
    Same leading form as the archimedean tail; for the bump family the true
    tail is far smaller (Ghat decays super-polynomially)."""
    return (2 / pi) * (log(gam_N / (2 * pi)) + 1) / gam_N


# ------------------------------------------------------------- families
class Triangle:
    name = "triangle"

    def __init__(self, L):
        self.L = L

    def F(self, v):                       # autocorrelation of the indicator
        v = abs(v)
        return self.L - v if v < self.L else mpf(0)

    def F0(self):
        return self.L

    def Ghat(self, t):                    # int_{-L/2}^{L/2} e^{iut} du
        if t == 0:
            return self.L
        return 2 * sin(self.L * t / 2) / t

    def Ghat_i_half(self):                # Ghat at t = i/2:  4 sinh(L/4)
        return 4 * sinh(self.L / 4)

    def Ghat_np(self, t):
        t = np.asarray(t, dtype=float)
        L = float(self.L)
        out = np.where(t == 0, L, 2 * np.sin(L * t / 2) / np.where(t == 0, 1, t))
        return out

    def fourier_support_T(self):
        return None                       # 1/t^2 decay: no finite cutoff


class Bump:
    name = "bump"

    def __init__(self, L):
        self.L = L
        self.h = L / 2
        self._F0 = None

    def G(self, u):
        s = u / self.h
        s2 = s * s
        if s2 >= 1:
            return mpf(0)
        return exp(-1 / (1 - s2))

    def G_np(self, u):
        s2 = (np.asarray(u, dtype=float) / float(self.h)) ** 2
        out = np.zeros_like(s2)
        m = s2 < 1
        out[m] = np.exp(-1 / (1 - s2[m]))
        return out

    def F(self, v):                       # int G(u) G(u - v) du
        v = abs(v)
        if v >= self.L:
            return mpf(0)
        return quad(lambda u: self.G(u) * self.G(u - v), [v - self.h, self.h])

    def F0(self):
        if self._F0 is None:
            self._F0 = quad(lambda u: self.G(u) ** 2, [-self.h, 0, self.h])
        return self._F0

    def Ghat(self, t):
        return 2 * quad(lambda u: self.G(u) * cos(u * t), [0, self.h])

    def Ghat_i_half(self):
        return 2 * quad(lambda u: self.G(u) * cosh(u / 2), [0, self.h])

    # composite Gauss-Legendre in double precision for the oscillatory FT
    def _nodes(self, tmax):
        period = 2 * math.pi / max(tmax, 1.0)
        width = min(period / 2, float(self.h) / 16)
        npan = int(math.ceil(float(self.h) / width))
        x, w = np.polynomial.legendre.leggauss(16)
        edges = np.linspace(0.0, float(self.h), npan + 1)
        a, b = edges[:-1, None], edges[1:, None]
        U = (a + b) / 2 + (b - a) / 2 * x[None, :]
        W = (b - a) / 2 * w[None, :]
        return U.ravel(), W.ravel()

    def Ghat_np(self, t, tmax=None):
        t = np.asarray(t, dtype=float)
        if tmax is None:
            tmax = float(np.max(np.abs(t))) if t.size else 1.0
        U, W = self._nodes(tmax)
        GU = self.G_np(U) * W
        out = np.empty(t.shape)
        for i in range(0, t.size, 512):
            tt = t.ravel()[i:i + 512]
            out.ravel()[i:i + 512] = 2 * (np.cos(np.outer(tt, U)) @ GU)
        return out


# ------------------------------------------------------------ the three terms
def arch_real(fam):
    """-(log 4pi + gamma)F(0) - int_0^L (e^{x/2}(F(x)+F(-x)) - 2F(0))/(e^x-e^{-x}) dx
       + F(0) log coth(L/2).   Bombieri (12.2) / Connes-Consani (150)."""
    L, F0 = fam.L, fam.F0()

    def integrand(x):
        return (exp(x / 2) * 2 * fam.F(x) - 2 * F0) / (exp(x) - exp(-x))
    pts = [mpf(0), L / 4, L / 2, 3 * L / 4, L] if L > 1 else [mpf(0), L]
    core = quad(integrand, pts)
    return -(log(4 * pi) + euler) * F0 - core + F0 * log(coth(L / 2))


def hplus(t):
    return re(digamma(mpf('0.25') + mpc(0, t) / 2)) - log(pi)


def arch_fourier_triangle(fam, T):
    """(1/2pi) int_{-T}^{T} Ghat(t)^2 hplus(t) dt + analytic tail (2/pi)(log(T/2pi)+1)/T."""
    L = fam.L
    period = 2 * pi / L
    pts = [mpf(0)]
    k = 1
    while pts[-1] < T:
        pts.append(min(k * period, mpf(T)))
        k += 1
    val = 2 * quad(lambda t: fam.Ghat(t) ** 2 * hplus(t), pts) / (2 * pi)
    tail = (2 / pi) * (log(mpf(T) / (2 * pi)) + 1) / mpf(T)
    return val, tail


def arch_fourier_bump(fam):
    """Same integral for the bump, on a double-precision grid out to where
    Ghat^2 has fallen below 1e-18 of its peak.  hplus via mpmath per node."""
    tmax = 20.0
    while True:
        gh = fam.Ghat_np(np.array([tmax]), tmax=tmax)[0]
        if gh ** 2 < 1e-18 * float(fam.F0()) ** 2 or tmax > 4000:
            break
        tmax *= 1.5
    n = int(max(4000, 40 * tmax))
    ts = np.linspace(0.0, tmax, n + 1)
    gh2 = fam.Ghat_np(ts, tmax=tmax) ** 2
    hp = np.array([float(hplus(mpf(t))) for t in ts])
    val = 2 * np.trapezoid(gh2 * hp, ts) / (2 * math.pi)
    return val, tmax


def prime_term(fam, X, pp):
    """2 sum_{n<=X} Lambda(n) n^{-1/2} F(log n) over prime powers n = p^m <= X."""
    tot = mpf(0)
    rows = []
    for n, lp in pp:
        if n > X:
            break
        Fv = fam.F(log(mpf(n)))
        c = 2 * lp * mpf(n) ** mpf('-0.5') * Fv
        tot += c
        rows.append((n, float(c)))
    return tot, rows


# --------------------------------------------------------------------- main
def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    ap.add_argument("--xs", type=str, default="2,3,5,10,20,50,100,1000,10000")
    ap.add_argument("--nzeros", type=int, default=2000)
    ap.add_argument("--dps", type=int, default=25)
    ap.add_argument("--arch-T", type=float, default=400.0,
                    help="Fourier-side archimedean cutoff for the triangle cross-check")
    ap.add_argument("--families", type=str, default="triangle,bump")
    ap.add_argument("--no-scan", dest="scan", action="store_false",
                    help="skip the fine X scan for the triangle crossover (default: run it)")
    ap.add_argument("--out", type=str, default=os.path.join(RESULTS, "weil_QX.json"))
    args = ap.parse_args()

    mp.dps = args.dps
    os.makedirs(RESULTS, exist_ok=True)
    started = datetime.datetime.now(datetime.timezone.utc)
    xs = [float(x) for x in args.xs.split(",")]
    Xmax = max(xs)

    print("weil_QX  EXPLORATORY - no prereg, no decision rule, no verdict.")
    print(f"  dps={args.dps}  X ladder={xs}  N zeros={args.nzeros}")

    # prime powers up to Xmax
    pp = []
    for p in primerange(2, int(Xmax) + 1):
        q, lp = p, log(mpf(p))
        while q <= Xmax:
            pp.append((q, lp))
            q *= p
    pp.sort()
    print(f"  prime powers <= {Xmax:g}: {len(pp)}")

    # zeros
    print("  loading zeros (mpmath.zetazero, cached) ...", flush=True)
    zcache = os.path.join(RESULTS, f"zetazeros_{args.nzeros}.json")
    gam = load_zeros(args.nzeros, zcache)
    gam_np = np.array([float(g) for g in gam])
    print(f"    gamma_1 = {gam[0]}   gamma_{args.nzeros} = {gam[-1]}")
    gfile = np.array([float(l.split()[0]) for l in open(ZEROS_FILE)])
    # sanity: file vs mpmath on the overlap
    dz = np.max(np.abs(gfile[:args.nzeros] - gam_np))
    print(f"    zeros1.txt: {len(gfile)} zeros to {gfile[-1]:.3f}; max |file - zetazero| on first {args.nzeros}: {dz:.2e}")

    rows = []
    families = args.families.split(",")
    for famname in families:
        print(f"\n===== family: {famname} =====")
        hdr = (f"{'X':>8} {'L':>8} {'pole':>16} {'prime':>16} {'arch':>14} "
               f"{'total':>13} {'Z_N':>13} {'resid_N':>10} {'tail_N':>9} "
               f"{'Z_file':>13} {'resid_f':>10} {'tail_f':>9} {'sign':>4} {'dominant':>8}")
        print(hdr)
        for X in xs:
            L = log(mpf(X))
            fam = Triangle(L) if famname == "triangle" else Bump(L)
            t0 = time.time()
            F0 = fam.F0()
            pole = 2 * fam.Ghat_i_half() ** 2
            pole_quad = quad(lambda u: fam.F(u) * 2 * cosh(u / 2), [-L, 0, L])
            prime, prows = prime_term(fam, X, pp)
            arch = arch_real(fam)
            total = pole - prime + arch

            if famname == "triangle":
                ghat = fam.Ghat_np(gam_np)
                ZN = 2 * float(np.sum(ghat ** 2))
                ghf = fam.Ghat_np(gfile)
                Zf = 2 * float(np.sum(ghf ** 2))
                archF, archF_tail = arch_fourier_triangle(fam, args.arch_T)
                archF_note = f"T={args.arch_T:g}"
                # partial sums for the residual trajectory
                cum = 2 * np.cumsum(ghat ** 2)
                traj = {str(k): float(cum[k - 1]) for k in (10, 100, 500, 1000, 2000) if k <= len(cum)}
            else:
                ghat = fam.Ghat_np(gam_np, tmax=float(gam_np[-1]))
                ZN = 2 * float(np.sum(ghat ** 2))
                # bump: only zeros below the decay cutoff matter; find it
                g2 = ghat ** 2
                peak = float(F0) ** 2
                kcut = int(np.argmax(g2 < 1e-16 * peak)) if np.any(g2 < 1e-16 * peak) else len(g2)
                Zf = ZN            # file extension irrelevant: terms beyond kcut are < 1e-16 peak
                archF, archF_T = arch_fourier_bump(fam)
                archF_note = f"tmax={archF_T:.1f}"
                archF_tail = 0.0
                cum = 2 * np.cumsum(g2)
                traj = {str(k): float(cum[k - 1]) for k in (10, 100, 500, 1000, 2000) if k <= len(cum)}
                traj["k_cut_1e-16"] = kcut
            if famname == "triangle":
                tailN = float(tail_estimate(gam[-1]))
                tailf = float(tail_estimate(mpf(gfile[-1])))
            else:
                # bump: Ghat decays super-polynomially; report the last included term
                tailN = 2 * float(g2[-1])
                tailf = tailN
            residN = float(total) - ZN
            residf = float(total) - Zf
            mags = {"pole": abs(float(pole)), "prime": abs(float(prime)), "arch": abs(float(arch))}
            dom = max(mags, key=mags.get)
            sign = "+" if total > 0 else ("-" if total < 0 else "0")
            print(f"{X:>8g} {float(L):>8.4f} {float(pole):>16.8f} {float(prime):>16.8f} "
                  f"{float(arch):>14.8f} {float(total):>13.8f} {ZN:>13.8f} {residN:>10.2e} "
                  f"{tailN:>9.2e} {Zf:>13.8f} {residf:>10.2e} {tailf:>9.2e} {sign:>4} {dom:>8}"
                  f"    [{time.time()-t0:.1f}s]")
            print(f"           pole(quad) {float(pole_quad):.8f}  arch(Fourier,{archF_note}) "
                  f"{float(archF):.8f} +tail {float(archF_tail):.2e} = {float(archF)+float(archF_tail):.8f}"
                  f"   |arch_real - arch_F(+tail)| = {abs(float(arch)-float(archF)-float(archF_tail)):.2e}"
                  f"   prime powers in: {len(prows)}  F(0)={float(F0):.6f}")
            rows.append({
                "family": famname, "X": X, "L": float(L), "F0": float(F0),
                "pole": float(pole), "pole_quad_check": float(pole_quad),
                "prime": float(prime), "n_prime_powers": len(prows),
                "prime_per_n": prows[:60],
                "arch_real": float(arch),
                "arch_fourier": float(archF), "arch_fourier_tail": float(archF_tail),
                "arch_fourier_note": archF_note,
                "total": float(total), "sign": sign, "dominant_term": dom,
                "pole_plus_arch": float(pole + arch),
                "prime_exceeds_pole_plus_arch": bool(abs(prime) > abs(pole + arch)),
                "Z_N": ZN, "N": args.nzeros, "gamma_N": float(gam[-1]),
                "resid_N": residN, "tail_est_N": tailN,
                "Z_file": Zf, "N_file": int(len(gfile)), "gamma_file": float(gfile[-1]),
                "resid_file": residf, "tail_est_file": tailf,
                "Z_partial": traj,
                "total_str": mp.nstr(total, 15),
            })

    # fine scan for the triangle crossover  |prime| > |pole + arch|
    scan = []
    if args.scan and "triangle" in families:
        print("\n===== triangle fine scan: |prime| vs |pole + arch| =====")
        grid = sorted(set([float(x) for x in np.round(np.geomspace(2, 1e4, 121), 4)] + list(range(2, 41))))
        first_cross = None
        first_neg = None
        first_prime_gt_arch = None
        first_prime_gt_half_pole = None
        for X in grid:
            L = log(mpf(X))
            fam = Triangle(L)
            pole = 2 * fam.Ghat_i_half() ** 2
            prime, _ = prime_term(fam, X, pp)
            arch = arch_real(fam)
            total = pole - prime + arch
            cross = abs(prime) > abs(pole + arch)
            if cross and first_cross is None:
                first_cross = X
            if total < 0 and first_neg is None:
                first_neg = X
            if abs(prime) > abs(arch) and first_prime_gt_arch is None:
                first_prime_gt_arch = X
            if abs(prime) > abs(pole) / 2 and first_prime_gt_half_pole is None:
                first_prime_gt_half_pole = X
            scan.append({"X": X, "pole": float(pole), "prime": float(prime),
                         "arch": float(arch), "total": float(total),
                         "pole_plus_arch": float(pole + arch), "cross": bool(cross),
                         "prime_gt_arch": bool(abs(prime) > abs(arch))})
        print(f"  grid points: {len(scan)}   smallest X with |prime| > |pole+arch|: {first_cross}"
              f"   smallest X with total < 0: {first_neg}")
        print(f"  (since pole+arch > 0 and total = pole+arch-prime, |prime| > |pole+arch| <=> total < 0)")
        print(f"  smallest X with |prime| > |arch|: {first_prime_gt_arch}"
              f"   smallest X with |prime| > pole/2: {first_prime_gt_half_pole}")
        # the a-priori ceiling on the triangle total: 2 sum_all Ghat(gamma)^2 <= 8 sum_{gamma>0} 1/gamma^2
        s_inv2 = float(np.sum(1.0 / gfile ** 2)) + float((log(mpf(gfile[-1]) / (2 * pi)) + 1) / (2 * pi * mpf(gfile[-1])))
        print(f"  sum_{{gamma>0}} 1/gamma^2 = {s_inv2:.9f} (file + RvM tail)  =>  triangle total <= {8*s_inv2:.6f} for every L")
        print(f"  {'X':>9} {'pole':>14} {'prime':>14} {'arch':>12} {'pole+arch':>14} {'total':>12}")
        for r in scan:
            if r["X"] <= 12 or r["X"] in (20, 50, 100, 1000, 10000) or abs(r["X"] - (first_cross or -1)) < 1e-9:
                print(f"  {r['X']:>9g} {r['pole']:>14.6f} {r['prime']:>14.6f} {r['arch']:>12.6f} "
                      f"{r['pole_plus_arch']:>14.6f} {r['total']:>12.6f}{'  <-- cross' if r['cross'] else ''}")
        print(f"  min total over scan: {min(r['total'] for r in scan):.6f} at X = "
              f"{min(scan, key=lambda r: r['total'])['X']:g}")
        print(f"  max total over scan: {max(r['total'] for r in scan):.6f} at X = "
              f"{max(scan, key=lambda r: r['total'])['X']:g}")

    ended = datetime.datetime.now(datetime.timezone.utc)
    payload = {
        "schema_version": "1",
        "script": os.path.abspath(__file__),
        "generated_utc": ended.strftime("%Y-%m-%dT%H:%M:%SZ"),
        "status": "EXPLORATORY - no prereg, no decision rule, no verdict.",
        "params": {"code_version": _code_version(), "xs": xs, "nzeros": args.nzeros,
                   "dps": args.dps, "arch_T": args.arch_T, "families": families,
                   "zeros_file": ZEROS_FILE, "zeros_cache": zcache,
                   "run_start_at": started.strftime("%Y-%m-%dT%H:%M:%SZ"),
                   "run_end_at": ended.strftime("%Y-%m-%dT%H:%M:%SZ")},
        "constants": {
            "identity": "sum_rho Fhat(rho) = pole - prime + arch  (Bombieri 2000 eq. 12.2; "
                        "Connes-Consani 2020 eqs 148-153; bench O36:29-41)",
            "pole": "int F(u) 2cosh(u/2) du = 2 Ghat(i/2)^2",
            "prime": "2 sum_{n<=X} Lambda(n) n^{-1/2} F(log n)",
            "arch": "-(log 4pi+gamma)F(0) - int_0^L (e^{x/2}(F(x)+F(-x))-2F(0))/(e^x-e^{-x}) dx + F(0) log coth(L/2)",
            "zero_side": "2 sum_{k<=N} Ghat(gamma_k)^2  (Weil criterion: RH <=> this is >= 0 for all G)",
            "tail_estimate": "(2/pi)(log(gamma_N/2pi)+1)/gamma_N  (triangle; sin^2 -> 1/2, RvM density)",
            "families": {"triangle": "G = 1_[-L/2,L/2], F(u) = L-|u|, Ghat = 2 sin(Lt/2)/t",
                         "bump": "G(u) = exp(-1/(1-(2u/L)^2)), F = G*G~ by quadrature"},
        },
        "summary": {
            "triangle_first_X_prime_exceeds_pole_plus_arch": (
                next((r["X"] for r in scan if r["cross"]), None) if scan else None),
            "triangle_first_X_total_negative": (
                next((r["X"] for r in scan if r["total"] < 0), None) if scan else None),
            "triangle_scan_min_total": (min(r["total"] for r in scan) if scan else None),
            "triangle_first_X_prime_exceeds_arch": (
                next((r["X"] for r in scan if r["prime_gt_arch"]), None) if scan else None),
            "sum_inv_gamma_sq_gamma_pos": (s_inv2 if scan else None),
            "triangle_total_ceiling_8_sum_inv_gamma_sq": (8 * s_inv2 if scan else None),
            "max_abs_resid_file_triangle": max((abs(r["resid_file"]) for r in rows if r["family"] == "triangle"), default=None),
            "max_abs_resid_N_bump": max((abs(r["resid_N"]) for r in rows if r["family"] == "bump"), default=None),
        },
        "rows": rows,
        "scan": scan,
    }
    with open(args.out, "w") as fh:
        json.dump(payload, fh, indent=1)
    print(f"\n  results written to {args.out}")

    # plain-text table
    txt = os.path.join(RESULTS, "weil_QX.txt")
    with open(txt, "w") as fh:
        fh.write("weil_QX  EXPLORATORY - no prereg, no decision rule, no verdict.\n")
        fh.write(f"generated {payload['generated_utc']}  code_version {payload['params']['code_version'][:16]}\n")
        fh.write("total = pole - prime + arch = sum_rho Fhat(rho); Z_N = 2 sum_{k<=N} Ghat(gamma_k)^2\n\n")
        for famname in families:
            fh.write(f"family: {famname}\n")
            fh.write(f"{'X':>8} {'L':>8} {'pole':>16} {'prime':>16} {'arch':>14} {'total':>13} "
                     f"{'Z_N':>13} {'resid_N':>10} {'tail_N':>9} {'Z_file':>13} {'resid_f':>10} {'tail_f':>9} sign dominant\n")
            for r in rows:
                if r["family"] != famname:
                    continue
                fh.write(f"{r['X']:>8g} {r['L']:>8.4f} {r['pole']:>16.8f} {r['prime']:>16.8f} {r['arch_real']:>14.8f} "
                         f"{r['total']:>13.8f} {r['Z_N']:>13.8f} {r['resid_N']:>10.2e} {r['tail_est_N']:>9.2e} "
                         f"{r['Z_file']:>13.8f} {r['resid_file']:>10.2e} {r['tail_est_file']:>9.2e} "
                         f"{r['sign']:>4} {r['dominant_term']:>8}\n")
            fh.write("\n")
        if scan:
            fh.write(f"triangle fine scan: first X with |prime| > |pole+arch| = "
                     f"{payload['summary']['triangle_first_X_prime_exceeds_pole_plus_arch']}; "
                     f"first X with total < 0 = {payload['summary']['triangle_first_X_total_negative']}; "
                     f"min total = {payload['summary']['triangle_scan_min_total']:.6f}\n")
    print(f"  table written to {txt}")
    print("\nEXPLORATORY - no prereg, no decision rule, no verdict.")


if __name__ == "__main__":
    main()
