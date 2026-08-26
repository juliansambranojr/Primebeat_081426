#!/usr/bin/env python3
"""O84 — EXPLORATORY. No prereg, no verdict.

Can an AGGREGATE observable see what single peaks cannot? The power
measurement, again before any prereg.

WHY THIS EXISTS. O83 (entry 173) sized single-zero detection on the
pooled incommensurate orbit and found it deaf: the amplitude needed to
clear P/median > 5 runs 1.46x, 3.72x and 6.11x the 1/|rho| the explicit
formula gives one zero, and sqrt(n) scaling puts the fix near 2^116.
That entry closed by naming, without proposing, the one design the
measurement does NOT rule out: a statistic that pools all the targets
at once. Pooling N targets buys about sqrt(N) in aggregate
signal-to-noise, and list A has 15 entries — sqrt(15) = 3.87 against
O83's 3.72x shortfall. Close enough that it must be measured rather
than argued.

THE STATISTIC. For each target list, the mean of P(gamma)/median(P)
over its own frequencies; then

    D = score(list A) - score(list B)

Entry 163's factoring predicts D > 0: the DH-weighted prime residual
should carry L(s,chi)'s zeros (list A) and not DH's own (list B). The
two lists are disjoint — no pair within 0.01 against a band half-width
of 0.6 — which is what makes the difference meaningful rather than a
comparison of a set with itself.

THE POWER TEST. Permute the real residual to destroy its structure,
then add the signal the explicit formula actually predicts: a mode at
every list-A frequency with amplitude 1/|rho| and a random phase.
Measure how often D clears the permutation null's 95th percentile.
That fraction IS the power, and a prereg written on this design must
quote it.

WHAT IS NOT DONE HERE. The unblinded D on the real residual is not
computed. This script sizes the instrument; it does not look at the
answer. Same discipline as O83.

Construction copied verbatim from O83_pooled_power.py (orbit, psi_DH,
residual, Hann window), which copied O81's, which copied O18's ladder
design.

Reads with: notes/lab_notebook_2.md entries 163, 164, 171, 172, 173;
lean/Nyquist.lean; O83_pooled_power.py.

HOW IT WAS RUN
--------------
    .venv/bin/python O84_aggregate_power.py
"""
import argparse
import hashlib
import math
import os
import sys
from datetime import datetime, timezone

import numpy as np
import mpmath as mp

_HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, _HERE)
from utilities.resultsguard import guarded_write

DEFAULT_RESULTS_DIR = os.path.join(_HERE, "results")
DEFAULT_OUT_JSON = os.path.join(DEFAULT_RESULTS_DIR, "aggregate_power.json")

LIST_A = [6.183578, 8.457229, 12.674946, 14.825026, 17.337802, 18.998588,
          22.487585, 24.365280, 25.531187, 27.982757, 30.463641, 32.195160,
          34.457229, 35.490893, 37.271951]
LIST_B = [5.0941598, 8.9399144, 12.133545, 14.404003, 17.130239, 19.308800,
          22.159708, 23.345370]


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
                new.append(w)
                w *= g
        pts = new
    return sorted(set(p for p in pts if 2 <= p <= xmax))


def psi_dh(xs, tau):
    a = {0: 0.0, 1: 1.0, 2: float(tau), 3: -float(tau), 4: -1.0}
    top = int(xs[-1])
    lim = int(top ** 0.5) + 1
    s = np.ones(lim + 1, dtype=bool)
    s[:2] = False
    for i in range(2, int(lim ** 0.5) + 1):
        if s[i]:
            s[i * i::i] = False
    base = np.flatnonzero(s).astype(np.int64)
    extra = []
    for p in base:
        v = int(p) * int(p)
        while v <= top:
            extra.append((v, math.log(int(p))))
            v *= int(p)
    extra.sort()
    vals = np.zeros(len(xs))
    cum, lo, ci, ex = 0.0, 2, 0, 0
    cps = [int(x) for x in xs]
    seg = 1 << 24
    while lo <= top:
        hi = min(lo + seg, top + 1)
        blk = np.ones(hi - lo, dtype=bool)
        for p in base:
            if p * p >= hi:
                break
            st = max(p * p, ((lo + p - 1) // p) * p)
            blk[st - lo::p] = False
        idx = (np.flatnonzero(blk) + lo).astype(np.int64)
        w = np.array([a[int(v) % 5] for v in idx]) * np.log(idx)
        cs = np.cumsum(w)
        while ci < len(cps) and cps[ci] < hi:
            k = int(np.searchsorted(idx, cps[ci], side="right"))
            part = cum + (cs[k - 1] if k > 0 else 0.0)
            while ex < len(extra) and extra[ex][0] <= cps[ci]:
                part += a[extra[ex][0] % 5] * extra[ex][1]
                ex += 1
            vals[ci] = part
            ci += 1
        cum += float(cs[-1]) if len(cs) else 0.0
        lo = hi
    while ci < len(cps):
        vals[ci] = cum
        ci += 1
    return vals


def main():
    ap = argparse.ArgumentParser(
        description=("O84 - power of an aggregate list-A-vs-list-B "
                     "statistic on the pooled orbit, measured before any "
                     "prereg. EXPLORATORY: no prereg, no decision rule, "
                     "no verdict."))
    ap.add_argument("--generators", type=str, default="2,3")
    ap.add_argument("--rmax", type=int, default=30)
    ap.add_argument("--nperm", type=int, default=400,
                    help="permutation draws for the null (default 400)")
    ap.add_argument("--trials", type=int, default=200,
                    help="injection trials for the power estimate "
                         "(default 200)")
    ap.add_argument("--seed", type=int, default=2026)
    ap.add_argument("--results-dir", type=str, default=DEFAULT_RESULTS_DIR)
    ap.add_argument("--out", type=str, default=DEFAULT_OUT_JSON)
    ap.add_argument("--no-json", action="store_true")
    args = ap.parse_args()

    rng = np.random.default_rng(args.seed)
    mp.mp.dps = 20
    tau = (mp.sqrt(10 - 2 * mp.sqrt(5)) - 2) / (mp.sqrt(5) - 1)
    gens = [int(g) for g in args.generators.split(",")]
    xmax = 1 << args.rmax

    print("O84 — can the aggregate see what single peaks cannot?  "
          "EXPLORATORY.\n")
    xs = np.array(orbit(gens, xmax), dtype=float)
    psi = psi_dh(xs, tau)
    ehat = np.diff(psi) / np.sqrt(xs[:-1])
    lx = np.log(xs[:-1])
    n = len(ehat)
    w = 0.5 - 0.5 * np.cos(2 * np.pi * np.arange(n) / (n - 1))
    grid = np.linspace(0.5, 40.0, 1600)
    EA = np.exp(-1j * np.outer(np.array(LIST_A), lx))
    EB = np.exp(-1j * np.outer(np.array(LIST_B), lx))
    EG = np.exp(-1j * np.outer(grid, lx))
    print(f"  {n} blocks, orbit {gens} to 2^{args.rmax}, "
          f"residual rms {np.sqrt((ehat**2).mean()):.4f}")
    print(f"  list A {len(LIST_A)} targets, list B {len(LIST_B)}; "
          f"sqrt(15) = {math.sqrt(len(LIST_A)):.2f} against O83's 3.72x "
          f"shortfall\n")

    def D_of(v):
        vw = w * v
        med = np.median(np.abs(EG @ vw))
        if med <= 0:
            return 0.0
        return float(np.abs(EA @ vw).mean() / med
                     - np.abs(EB @ vw).mean() / med)

    print("NULL — D under permutation of the residual:")
    null = np.array([D_of(rng.permutation(ehat)) for _ in range(args.nperm)])
    p95 = float(np.percentile(null, 95))
    print(f"   mean {null.mean():+.4f}   sd {null.std():.4f}   "
          f"p95 {p95:+.4f}   ({args.nperm} draws)")

    print("\nPOWER — inject every list-A mode at 1/|rho| with random "
          "phase, into a permuted residual:")
    for scale, lab in ((1.0, "1.0x (the explicit formula's own amplitude)"),
                       (1.5, "1.5x"), (2.0, "2.0x"), (3.0, "3.0x")):
        hits = 0
        for _ in range(args.trials):
            base_v = rng.permutation(ehat)
            sig = np.zeros(n)
            for g0 in LIST_A:
                amp = scale / math.sqrt(0.25 + g0 * g0)
                sig += amp * np.cos(g0 * lx + rng.uniform(0, 2 * math.pi))
            if D_of(base_v + sig) > p95:
                hits += 1
        rate = hits / args.trials
        print(f"   {lab:>44}: power {rate:.3f}")
        if scale == 1.0:
            power1 = rate

    print("\n  READ. Power at 1.0x is the number a prereg on this design")
    print("  must quote. Below ~0.5 the design cannot be relied on to")
    print("  fire when H1 is true, and a null from it would be")
    print("  uninformative in exactly the way O81's was.")
    print("  The unblinded D on the real residual is NOT computed here.")

    if not args.no_json:
        guarded_write({
            "schema_version": "1", "script": "O84_aggregate_power.py",
            "generated_utc": datetime.now(timezone.utc).isoformat(),
            "exploratory": True, "prereg": None,
            "params": {"code_version": _code_version(), "generators": gens,
                       "rmax": args.rmax, "nperm": args.nperm,
                       "trials": args.trials, "seed": args.seed,
                       "n_blocks": int(n),
                       "statistic": "D = mean_A P/median - mean_B P/median",
                       "note": "power sizing only; unblinded D not computed"},
            "list_A": LIST_A, "list_B": LIST_B,
            "null": {"mean": float(null.mean()), "sd": float(null.std()),
                     "p95": p95},
            "power_at_1x": float(power1)}, args.out)


if __name__ == "__main__":
    main()
