#!/usr/bin/env python3
"""
probe_window_m.py -- EXPLORATORY.  No prereg, no decision rule, no verdict.

The quadratic Weil form at the tuned window of lean_stage3 (WeilBackground:
phi(u) = G(u) e^{-u/2} on [-h, h], G(u) = (u/h) P(u/h)^m cos(gamma u),
P(x) = cos^2(pi x / 2)), read on both sides of the explicit formula.

The zero side of WeilDetect.zeroForm at phi is  sum_rho -ghat(rho - 1/2)^2 ord rho
(WeilOffLine.term_eq_neg_sq).  Under RH that is  sum_gamma' |Ghat(gamma')|^2,
with Ghat(r) = int G(u) e^{i r u} du.  The same number is the value at the even
test function A = G * G (autocorrelation) of the Riemann-Weil formula

    sum_gamma' Ahat(gamma') = Ahat(i/2) + Ahat(-i/2) - A(0) log pi
                              + (1/2pi) int Ahat(r) Re psi(1/4 + i r/2) dr
                              - 2 sum_n Lambda(n) n^{-1/2} A(log n),

Ahat(r) = int A(t) e^{i r t} dt = |Ghat(r)|^2.  The prime sum runs over
n <= e^{2h}: the support of A.

Three things this script measures.

  1. CONVENTION PIN.  prime side vs zero side, at a grid of (h, m, gamma).
     The residual is the check that the object is the right one (O8's rule:
     reproduce before comparing).  If no residual is small, the script is
     wrong, and nothing downstream means anything.
  2. CONTRAST.  The zero-side image I(gamma) = form at the window tuned at
     gamma, swept in gamma at fixed h, for several m.  Contrast at a zero
     = I(gamma_k) / I(midpoint to the neighbours).  Reported per m; the
     m at which contrast peaks is the turnover (neighbours merge when the
     window's effective width in gamma, ~ sqrt(m)/h, reaches the spacing).
  3. DECAY EXPONENT.  Psi_m(s) = int x P(x)^m sin(s x) dx for large s:
     slope of log Psi_m^2 against log s.  Prediction from the boundary
     reading: -(4m + 2).

Outputs to --out (the unit's run/ directory; results/ trees are frozen) and
prints a table.  Zeros are cached beside the output.
"""
import argparse, json, math, os, sys, time
import numpy as np
import mpmath as mp

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, "results")


def P(x):
    return np.cos(np.pi * x / 2) ** 2


def window(h, m, gamma, N):
    u = np.linspace(-h, h, N, endpoint=False)
    du = u[1] - u[0]
    x = u / h
    G = x * P(x) ** m * np.cos(gamma * u)
    return u, du, G


def autocorr(G, du):
    """A(t) = int G(v+t) G(v) dv on the lag grid t = k du, k = -N..N-1."""
    N = len(G)
    M = 2 * N
    F = np.fft.rfft(G, M)
    c = np.fft.irfft(F * np.conj(F), M) * du
    A = np.concatenate([c[N:], c[:N]])
    t = np.arange(-N, N) * du
    return t, A


def lambda_sieve(Nmax):
    """von Mangoldt Lambda(n), n <= Nmax, as float64."""
    Nmax = int(Nmax)
    is_p = np.ones(Nmax + 1, dtype=bool)
    is_p[:2] = False
    for p in range(2, int(Nmax ** 0.5) + 1):
        if is_p[p]:
            is_p[p * p::p] = False
    primes = np.nonzero(is_p)[0]
    Lam = np.zeros(Nmax + 1)
    Lam[primes] = np.log(primes)
    for p in primes[primes <= int(Nmax ** 0.5)]:
        q = p * p
        while q <= Nmax:
            Lam[q] = math.log(p)
            q *= p
    return Lam


def zeros(K, cache):
    if os.path.exists(cache):
        z = np.loadtxt(cache)
        if len(z) >= K:
            return z[:K]
    mp.mp.dps = 15
    z = np.array([float(mp.zetazero(k).imag) for k in range(1, K + 1)])
    np.savetxt(cache, z, fmt="%.12f")
    return z


def digamma_grid(r):
    mp.mp.dps = 15
    return np.array([float(mp.re(mp.digamma(mp.mpc(0.25, rr / 2)))) for rr in r])


def form_both_sides(h, m, gamma, N, Lam, gam, rgrid, psi_re):
    u, du, G = window(h, m, gamma, N)
    t, A = autocorr(G, du)
    pos = t >= 0
    tp, Ap = t[pos], A[pos]
    # one-sided trapezoid weights for the even integrand: half weight at t = 0
    Aw = Ap.copy()
    Aw[0] *= 0.5
    # zero side: 2 * sum_k Ahat(gamma_k), Ahat(r) = 2 int_0^{2h} A cos(r t) dt
    Ahat_k = np.empty(len(gam))
    for i in range(0, len(gam), 100):
        Ahat_k[i:i + 100] = 2 * (np.cos(np.outer(gam[i:i + 100], tp)) @ Aw) * du
    zero_side = 2 * Ahat_k.sum()
    tail_last = 2 * abs(Ahat_k[-5:]).max()
    # pole terms: Ahat(i/2) + Ahat(-i/2) = 2 int A cosh(t/2) dt
    pole = 2 * (2 * (Aw * np.cosh(tp / 2)).sum() * du)
    # archimedean: (1/2pi) int_{-inf}^{inf} Ahat(r) Re psi(1/4 + i r/2) dr
    step = 8
    ts, As = tp[::step], Aw[::step]
    Ahat_r = 2 * (np.cos(np.outer(rgrid, ts)) @ As) * (du * step)
    arch = (1 / math.pi) * np.trapezoid(Ahat_r * psi_re, rgrid)
    A0 = Ap[0]
    # prime side
    Nmax = int(math.exp(2 * h))
    n = np.arange(2, Nmax + 1)
    L = Lam[2:Nmax + 1]
    sel = L > 0
    n, L = n[sel], L[sel]
    Alog = np.interp(np.log(n), tp, Ap)
    prime_sum = -2 * (L / np.sqrt(n) * Alog).sum()
    prime_side = pole - A0 * math.log(math.pi) + arch + prime_sum
    return dict(h=h, m=m, gamma=gamma, zero_side=zero_side, prime_side=prime_side,
                residual=prime_side - zero_side, pole=pole, arch=arch, A0=A0,
                prime_sum=prime_sum, n_prime_powers=int(sel.sum()), Nmax=Nmax,
                tail_last=tail_last)


def psi_m_table(m, s, nodes=2 ** 15 + 1, kind="odd"):
    """odd:  Psi_m(s) = int_{-1}^{1} x P(x)^m sin(s x) dx   (the window's transform)
       even: K_m(s)   = int_{-1}^{1}   P(x)^m cos(s x) dx   (the even envelope's)"""
    x = np.linspace(-1, 1, nodes)
    dx = x[1] - x[0]
    if kind == "odd":
        w, osc = x * P(x) ** m, np.sin
    else:
        w, osc = P(x) ** m, np.cos
    w = w.copy()
    w[0] *= 0.5
    w[-1] *= 0.5
    out = np.empty(len(s))
    chunk = 512
    for i in range(0, len(s), chunk):
        S = s[i:i + chunk]
        out[i:i + chunk] = (osc(np.outer(S, x)) @ w) * dx
    return out


def image(h, m, gam, gammas, reach=40.0, kind="odd"):
    """zero-side form at the window tuned at each gamma in gammas:
    2 sum_k (h/2)^2 [T(h(gamma_k + gamma)) + T(h(gamma_k - gamma))]^2,
    T = Psi_m (odd window, node at each zero) or K_m (even envelope, peak)."""
    I = np.zeros(len(gammas))
    for j, g in enumerate(gammas):
        near = gam[np.abs(gam - g) <= reach]
        s = np.concatenate([h * (near + g), h * (near - g)])
        Ps = psi_m_table(m, s, kind=kind)
        k = len(near)
        term = (h / 2) ** 2 * (Ps[:k] + Ps[k:]) ** 2
        I[j] = 2 * term.sum()
    return I


def contrasts(gammas, I, first, kind):
    """odd: hump (max within 1 of the zero) over the floor (mean of I on the
    stretch between neighbouring zeros, 1 away from each); even: peak at the
    zero over the same floor."""
    out = []
    for k in range(len(first)):
        g = first[k]
        if kind == "odd":
            sel = np.abs(gammas - g) <= 1.0
            top = I[sel].max()
        else:
            top = np.interp(g, gammas, I)
        floors = []
        if k > 0:
            sel = (gammas > first[k - 1] + 1.0) & (gammas < g - 1.0)
            if sel.any():
                floors.append(I[sel].mean())
        if k < len(first) - 1:
            sel = (gammas > g + 1.0) & (gammas < first[k + 1] - 1.0)
            if sel.any():
                floors.append(I[sel].mean())
        out.append(float(top / np.mean(floors)) if floors else float("nan"))
    return out


def decay_slope(m, kind="odd"):
    """slope of log T_m^2 vs log s on the envelope's local maxima, s in [50, 500]."""
    s = np.arange(50.0, 500.0, 0.05)
    T = np.abs(psi_m_table(m, s, kind=kind))
    mx = (T[1:-1] > T[:-2]) & (T[1:-1] > T[2:])
    sm, Tm = s[1:-1][mx], T[1:-1][mx]
    keep = Tm > 0
    return float(np.polyfit(np.log(sm[keep]), np.log(Tm[keep] ** 2), 1)[0]), int(keep.sum())


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--N", type=int, default=2 ** 17)
    ap.add_argument("--zeros", type=int, default=600)
    ap.add_argument("--hs", default="4,6,8")
    ap.add_argument("--ms", default="1,4,16")
    ap.add_argument("--gammas", default="14.134725,17.5,21.022040")
    ap.add_argument("--sweep-h", type=float, default=6.0)
    ap.add_argument("--sweep-ms", default="1,2,4,8,16,32")
    ap.add_argument("--out", required=True, help="output JSON, inside a unit's run/")
    ap.add_argument("--skip-pin", action="store_true", help="image sweeps only (no primes)")
    args = ap.parse_args()
    outdir = os.path.dirname(os.path.abspath(args.out))
    os.makedirs(outdir, exist_ok=True)
    print("EXPLORATORY -- no prereg, no verdict.  probe_window_m.py", flush=True)
    t0 = time.time()
    gam = zeros(args.zeros, os.path.join(outdir, f"zeros_{args.zeros}.txt"))
    print(f"zeros: {len(gam)}, last {gam[-1]:.3f}  ({time.time()-t0:.1f}s)", flush=True)
    hs = [float(v) for v in args.hs.split(",")]
    ms = [int(v) for v in args.ms.split(",")]
    gs = [float(v) for v in args.gammas.split(",")]
    rows = []
    if not args.skip_pin:
        Nmax = int(math.exp(2 * max(hs)))
        t1 = time.time()
        Lam = lambda_sieve(Nmax)
        print(f"Lambda sieve to {Nmax}  ({time.time()-t1:.1f}s)", flush=True)
        rgrid = np.arange(0, 300.0, 0.02)
        t2 = time.time()
        psi_re = digamma_grid(rgrid)
        print(f"digamma grid {len(rgrid)} pts  ({time.time()-t2:.1f}s)", flush=True)
        print("\n== 1. convention pin: prime side vs zero side ==")
        print(f"{'h':>4} {'m':>3} {'gamma':>10} {'zero_side':>14} {'prime_side':>14} {'residual':>12} {'rel':>10} {'#pp':>8}")
        for h in hs:
            for m in ms:
                for g in gs:
                    r = form_both_sides(h, m, g, args.N, Lam, gam, rgrid, psi_re)
                    rows.append(r)
                    rel = r["residual"] / max(abs(r["zero_side"]), 1e-300)
                    print(f"{h:4.1f} {m:3d} {g:10.6f} {r['zero_side']:14.6e} {r['prime_side']:14.6e} "
                          f"{r['residual']:12.3e} {rel:10.2e} {r['n_prime_powers']:8d}", flush=True)

    sweep_ms = [int(v) for v in args.sweep_ms.split(",")]
    gammas = np.arange(10.0, 60.0, 0.02)
    first = gam[gam < 58]
    sweep = {}
    for kind in ("odd", "even"):
        print(f"\n== 2. contrast at the first zeros, zero-side image, h = {args.sweep_h}, {kind} window ==")
        contrast, images = {}, {}
        for m in sweep_ms:
            I = image(args.sweep_h, m, gam, gammas, kind=kind)
            images[m] = I
            c = contrasts(gammas, I, first, kind)
            contrast[m] = c
            print(f"m={m:3d}  contrast at zeros 1..5: " + " ".join(f"{v:9.2f}" for v in c[:5])
                  + f"   median(1..{len(c)}): {np.nanmedian(c):9.2f}", flush=True)
        best = {int(k + 1): int(max(sweep_ms, key=lambda m: contrast[m][k])) for k in range(min(5, len(first)))}
        print("m of peak contrast, zeros 1..5:", best)
        sweep[kind] = dict(images={str(m): images[m].tolist() for m in sweep_ms},
                           contrast={str(m): contrast[m] for m in sweep_ms}, peak_m=best)

    print("\n== 3. decay exponent of the transform squared, envelope maxima, s in [50, 500] ==")
    decay = {}
    for kind in ("odd", "even"):
        decay[kind] = {}
        for m in sweep_ms:
            slope, npts = decay_slope(m, kind=kind)
            decay[kind][str(m)] = slope
            pred = -(4 * m + 2) if kind == "odd" else -(4 * m + 2)
            print(f"{kind:4s} m={m:3d}  slope {slope:8.2f}   predicted {pred:5d}   ({npts} maxima)", flush=True)

    out = dict(label="EXPLORATORY -- no prereg, no verdict",
               script="analysis/2026-09-06/probe_window_m.py",
               N=args.N, zeros=len(gam), zero_max=float(gam[-1]),
               pin=rows,
               sweep=dict(h=args.sweep_h, ms=sweep_ms, gammas=gammas.tolist(),
                          first_zeros=first.tolist(), **sweep),
               decay=decay, seconds=time.time() - t0)
    with open(args.out, "w") as f:
        json.dump(out, f, indent=1)
    print(f"\nwrote {args.out}  ({time.time()-t0:.1f}s)")


if __name__ == "__main__":
    main()
