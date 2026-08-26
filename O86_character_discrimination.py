#!/usr/bin/env python3
"""O86 — EXPLORATORY. No prereg, no verdict.

The cross-character control, and the half of the prediction the O85
design never used.

WHY THIS EXISTS. The adversarial check on O85 (entry 175) produced
stronger evidence than the preregistered statistic did, and produced it
in a scratchpad — no script, no artifact, nothing in the tree. That is
the O61 situation from entry 168 repeating: decisive numbers with
nothing behind them. This script is that evidence, made reproducible.

TWO THINGS THE O85 DESIGN MISSED.

  THE OTHER HALF. Entry 163 factors psi_DH = c*psi(x,chi) +
  conj(c)*psi(x,conj chi). Both terms carry zeros, and chi is COMPLEX,
  so L(s,chi) and L(s,conj chi) have different ordinates. O85's list A
  was only half the predicted frequencies. The other half — call it
  A' — was never tested, which makes it an out-of-sample prediction
  with no freedom to fit.

  THE CROSS-CHARACTER CONTROL. Reweight the SAME primes on the SAME
  orbit by a different character mod 5 and the elevated list should
  change with it. Feed the quadratic character's primes and the
  quadratic character's zeros should light while chi's go flat. That
  is a positive control and a specificity control in one table, and no
  gamma-trend, window, grid or normalisation artifact can produce it,
  because all four are identical across the rows.

THE psi FIX. O83, O84 and O85 share a defect the same check found:
prime-power mass never accumulates, because the `extra` pointer
advances while the running total is rebuilt at each rung, giving
P(x_j) + [E(x_j) - E(x_{j-1})] instead of P(x_j) + E(x_j). Max error
9.604 at 2^14 against 6.4e-14 for the cumulative form. This script uses
the cumulative form and checks it against brute force before measuring.

THE CONTROL. Significance is against RANGE-MATCHED random frequency
sets, not against a permutation of the residual. Permuting flattens the
spectrum by construction, so it cannot see a gamma-trend — which is the
correction the same check forced on O85's Run record.

Reads with: notes/lab_notebook_2.md entries 163, 175; O85_dh_aggregate.py;
preregs/dh_aggregate_spectrum_v1_20260825.md.

HOW IT WAS RUN
--------------
    .venv/bin/python O86_character_discrimination.py
"""
import argparse, hashlib, math, os, sys
from datetime import datetime, timezone
import numpy as np
import mpmath as mp

_HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, _HERE)
from utilities.resultsguard import guarded_write

DEFAULT_OUT = os.path.join(_HERE, "results", "character_discrimination.json")


def _code_version():
    with open(os.path.abspath(__file__), "rb") as f:
        return hashlib.sha256(f.read()).hexdigest()


def orbit(gens, xmax):
    pts = [1]
    for g in gens:
        new = []
        for v in pts:
            w = v
            while w <= xmax:
                new.append(w); w *= g
        pts = new
    return sorted(set(p for p in pts if 2 <= p <= xmax))


def psi_weighted(xs, a):
    """sum over prime powers p^k <= x of log p * a[p^k mod 5].
    CUMULATIVE in the prime-power term — this is the O83/O84/O85 fix."""
    top = int(xs[-1]); lim = int(top ** 0.5) + 1
    s = np.ones(lim + 1, dtype=bool); s[:2] = False
    for i in range(2, int(lim ** 0.5) + 1):
        if s[i]: s[i * i::i] = False
    base = np.flatnonzero(s).astype(np.int64)
    extra = []
    for p in base:
        v = int(p) * int(p)
        while v <= top:
            extra.append((v, math.log(int(p)))); v *= int(p)
    extra.sort()
    vals = np.zeros(len(xs)); cum = 0.0; lo = 2; ci = 0; ex = 0; ecum = 0.0
    cps = [int(x) for x in xs]; seg = 1 << 24
    while lo <= top:
        hi = min(lo + seg, top + 1)
        blk = np.ones(hi - lo, dtype=bool)
        for p in base:
            if p * p >= hi: break
            st = max(p * p, ((lo + p - 1) // p) * p)
            blk[st - lo::p] = False
        idx = (np.flatnonzero(blk) + lo).astype(np.int64)
        w = np.array([a[int(v) % 5] for v in idx]) * np.log(idx)
        cs = np.cumsum(w)
        while ci < len(cps) and cps[ci] < hi:
            k = int(np.searchsorted(idx, cps[ci], side="right"))
            while ex < len(extra) and extra[ex][0] <= cps[ci]:
                ecum += a[extra[ex][0] % 5] * extra[ex][1]; ex += 1
            vals[ci] = cum + (cs[k - 1] if k > 0 else 0.0) + ecum
            ci += 1
        cum += float(cs[-1]) if len(cs) else 0.0
        lo = hi
    while ci < len(cps):
        while ex < len(extra) and extra[ex][0] <= cps[ci]:
            ecum += a[extra[ex][0] % 5] * extra[ex][1]; ex += 1
        vals[ci] = cum + ecum; ci += 1
    return vals


def zeros_of(chi, tmax, step=0.05):
    """On-line zeros of L(s,chi), 0 < t < tmax, by |L| minima."""
    def L(s):
        return 5 ** (-s) * sum(chi[j] * mp.zeta(s, mp.mpf(j) / 5)
                               for j in (1, 2, 3, 4))
    def aL(t): return abs(L(mp.mpf('0.5') + 1j * t))
    out = []; t = mp.mpf('0.2'); prev = aL(t); prev2 = None
    while t < tmax:
        t += mp.mpf(str(step)); cur = aL(t)
        if prev2 is not None and prev < prev2 and prev < cur and prev < 0.35:
            tm = mp.findroot(aL, t - mp.mpf(str(step)), solver='secant',
                             tol=mp.mpf('1e-12'))
            if aL(tm) < 1e-8: out.append(float(tm))
        prev2, prev = prev, cur
    return sorted(set(round(v, 6) for v in out))


def main():
    ap = argparse.ArgumentParser(
        description=("O86 - cross-character discrimination and the "
                     "out-of-sample half of entry 163's prediction. "
                     "EXPLORATORY: no prereg, no decision rule, no "
                     "verdict."))
    ap.add_argument("--generators", type=str, default="2,3")
    ap.add_argument("--rmax", type=int, default=30)
    ap.add_argument("--tmax", type=float, default=40.0)
    ap.add_argument("--controls", type=int, default=4000)
    ap.add_argument("--seed", type=int, default=2026)
    ap.add_argument("--out", type=str, default=DEFAULT_OUT)
    ap.add_argument("--no-json", action="store_true")
    args = ap.parse_args()

    rng = np.random.default_rng(args.seed); mp.mp.dps = 20
    tau = (mp.sqrt(10 - 2 * mp.sqrt(5)) - 2) / (mp.sqrt(5) - 1)
    print("O86 — cross-character discrimination.  EXPLORATORY.\n")

    chi4 = {1: mp.mpc(1, 0), 2: mp.mpc(0, 1), 3: mp.mpc(0, -1), 4: mp.mpc(-1, 0)}
    chi4b = {k: mp.conj(v) for k, v in chi4.items()}
    chi2 = {1: mp.mpc(1, 0), 2: mp.mpc(-1, 0), 3: mp.mpc(-1, 0), 4: mp.mpc(1, 0)}
    print("computing zeros of the three characters mod 5 ...")
    A = zeros_of(chi4, args.tmax)
    Ap = zeros_of(chi4b, args.tmax)
    A2 = zeros_of(chi2, args.tmax)
    B = [5.0941598, 8.9399144, 12.133545, 14.404003, 17.130239, 19.308800,
         22.159708, 23.345370]
    print(f"   A  (L,chi)      {len(A)} zeros, {A[0]:.4f} .. {A[-1]:.4f}")
    print(f"   A' (L,conj chi) {len(Ap)} zeros, {Ap[0]:.4f} .. {Ap[-1]:.4f}")
    print(f"   A2 (L,chi_quad) {len(A2)} zeros, {A2[0]:.4f} .. {A2[-1]:.4f}")
    print(f"   B  (DH's own)   {len(B)} zeros, {B[0]:.4f} .. {B[-1]:.4f}\n")

    xs = np.array(orbit([int(g) for g in args.generators.split(",")],
                        1 << args.rmax), dtype=float)
    W_DH = {0: 0.0, 1: 1.0, 2: float(tau), 3: -float(tau), 4: -1.0}
    W_Q = {0: 0.0, 1: 1.0, 2: -1.0, 3: -1.0, 4: 1.0}

    # psi fix check against brute force at a small ceiling
    small = np.array(orbit([2, 3], 1 << 14), dtype=float)
    got = psi_weighted(small, W_DH)
    import sympy
    def brute(x):
        tot = 0.0
        for p in sympy.primerange(2, int(x) + 1):
            v = p
            while v <= x:
                tot += W_DH[v % 5] * math.log(p); v *= p
        return tot
    err = max(abs(got[i] - brute(small[i])) for i in range(0, len(small), 7))
    print(f"psi FIX CHECK vs brute force at 2^14: max |err| = {err:.2e}")
    if err > 1e-9:
        print("   FIX CHECK FAILED"); raise SystemExit(1)
    print("   passed\n")

    grid = np.linspace(0.5, args.tmax, 1600)
    results = {}
    print(f"{'weighting':>22} " + "".join(f"{n:>22}" for n in
          ("A (L,chi)", "A' (L,conj chi)", "A2 (L,chi_quad)", "B (DH own)")))
    for wname, wvec in (("DH  a=(1,t,-t,-1)", W_DH),
                        ("quad a=(1,-1,-1,1)", W_Q)):
        psi = psi_weighted(xs, wvec)
        ehat = np.diff(psi) / np.sqrt(xs[:-1]); lx = np.log(xs[:-1])
        n = len(ehat)
        w = 0.5 - 0.5 * np.cos(2 * np.pi * np.arange(n) / (n - 1))
        vw = w * ehat
        med = float(np.median(np.abs(np.exp(-1j * np.outer(grid, lx)) @ vw)))
        row = {}
        cells = []
        for lname, L in (("A", A), ("Ap", Ap), ("A2", A2), ("B", B)):
            score = float(np.abs(np.exp(-1j * np.outer(np.array(L), lx))
                                 @ vw).mean() / med)
            lo, hi = min(L), max(L)
            ctrl = np.empty(args.controls)
            for i in range(args.controls):
                r = rng.uniform(lo, hi, len(L))
                ctrl[i] = float(np.abs(np.exp(-1j * np.outer(r, lx))
                                       @ vw).mean() / med)
            pv = float((ctrl >= score).mean())
            row[lname] = {"score": score, "p_range_matched": pv,
                          "control_mean": float(ctrl.mean())}
            cells.append(f"{score:>10.3f} p{pv:<10.4f}")
        results[wname] = row
        print(f"{wname:>22} " + "".join(f"{c:>22}" for c in cells))

    print("\n  READ. The diagonal is the claim: DH's weighting elevates")
    print("  chi's and conj-chi's zeros; the quadratic weighting elevates")
    print("  the quadratic character's. Orbit, window, grid and")
    print("  normalisation are identical across the two rows, so no")
    print("  gamma-trend or windowing artifact can produce a difference")
    print("  between them. A' was never used in O85's design.")

    if not args.no_json:
        guarded_write({
            "schema_version": "1", "script": "O86_character_discrimination.py",
            "generated_utc": datetime.now(timezone.utc).isoformat(),
            "exploratory": True, "prereg": None,
            "params": {"code_version": _code_version(),
                       "generators": args.generators, "rmax": args.rmax,
                       "tmax": args.tmax, "controls": args.controls,
                       "seed": args.seed, "psi_fix_err": err,
                       "control": "range-matched random frequency sets, "
                                  "not permutation of the residual"},
            "zeros": {"A": A, "Ap": Ap, "A2": A2, "B": B},
            "matrix": results}, args.out)


if __name__ == "__main__":
    main()
