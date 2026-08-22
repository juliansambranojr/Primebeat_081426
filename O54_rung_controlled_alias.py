#!/usr/bin/env python3
"""O54 — EXPLORATORY. No prereg, no verdict.

Does base 2's alias-fold result come from its BASE or from its RUNG COUNT?

O53 run 2 found base 2 beating chance at every target density (0.18-0.49) while
bases 3,4,6,8,9 wandered around 1. Base 2 also has the most rungs, 36 against
base 9's 11, so extent and base are confounded.

They cannot be separated by choosing bases: rungs = log(ceiling)/log(b) and the
diagonal drift is (b-1), and both are functions of b alone. Vary b and both move.

They CAN be separated by holding b = 2 and moving the ceiling. This runs base 2
at the rung counts the other bases had -- 11, 12, 14, 18, 23, 36 -- and reports
the same statistic at each.

  If base 2 at 11 rungs performs like base 9 at 11 rungs, extent explains it.
  If base 2 at 11 rungs still beats chance, the base is doing work.

Reads with: O53_alias_tau.py, results/alias_tau_run2.json, notes entry 85
"""
import json, math, pathlib
import numpy as np
import mpmath as mp
from primecountpy import prime_pi

_HERE = pathlib.Path(__file__).resolve().parent
mp.mp.dps = 30
ZEROS = [float(z) for z in json.load(open(_HERE / "zeros600.json"))]
B, FLOOR, NZ = 2, 10 ** 4, 6
# rung counts observed in O53 run 2, and the base that had each
TARGETS = [(11, "base 9"), (12, "base 8"), (14, "base 6"),
           (18, "base 4"), (23, "base 3"), (36, "base 2")]


def fold(g, tau):
    m = g % tau
    return min(m, tau - m)


def measure(n_rungs, rng):
    tau = 2 * math.pi / math.log(B)
    r0 = math.ceil(math.log(FLOOR) / math.log(B))
    rs = list(range(r0, r0 + n_rungs))
    e = []
    for r in rs:
        c = prime_pi(B ** r) - prime_pi(B ** (r - 1))
        s = float(mp.li(mp.mpf(B ** r)) - mp.li(mp.mpf(B ** (r - 1))))
        e.append(c - s)
    e = np.array(e); lx = np.array([r * math.log(B) for r in rs])
    eh = e / (np.sqrt(np.exp(lx)) / lx)
    w = np.hanning(len(eh)); z = (eh - eh.mean()) * w
    gam = np.arange(0.02, tau / 2, 0.002)
    P = np.array([abs(np.sum(z * np.exp(-1j * g * lx))) ** 2 for g in gam])
    loc = [i for i in range(1, len(P) - 1) if P[i] > P[i - 1] and P[i] > P[i + 1]]
    peaks = sorted(float(gam[i]) for i in sorted(loc, key=lambda i: -P[i])[:5])
    F = sorted({round(fold(g, tau), 6) for g in ZEROS[:NZ]})
    obs = float(np.mean([min(abs(f - p) for f in F) for p in peaks]))
    q = rng.uniform(0.02, tau / 2, 40000)
    ch = float(np.mean([min(abs(f - x) for f in F) for x in q]))
    return {"n_rungs": n_rungs, "ceiling": B ** rs[-1], "peaks": peaks,
            "observed": obs, "chance": ch, "ratio": obs / ch}


def main():
    print("O54 - rung-controlled alias test.  EXPLORATORY, no prereg, no verdict.")
    print(f"base {B} held fixed, ceiling varied.  tau = {2*math.pi/math.log(B):.4f}, "
          f"{NZ} zeros folded\n")
    rng = np.random.default_rng(2026)
    o53 = {r["base"]: r["sweep"]["6"]["ratio"]
           for r in json.load(open(_HERE / "results/alias_tau_run2.json"))["rows"]}
    b_of = {11: 9, 12: 8, 14: 6, 18: 4, 23: 3, 36: 2}
    print(f"{'rungs':>6} {'ceiling':>12} {'obs':>8} {'chance':>8} {'ratio':>7}"
          f"   | that base at same rungs")
    rows = []
    for n, who in TARGETS:
        r = measure(n, rng); rows.append(r)
        other = o53[b_of[n]]
        print(f"{n:>6} {r['ceiling']:>12.3e} {r['observed']:>8.4f} "
              f"{r['chance']:>8.4f} {r['ratio']:>7.2f}   | {who:<7} {other:.2f}")
    p = _HERE / "results" / "rung_controlled_alias.json"
    p.write_text(json.dumps({"schema_version": "1",
                             "script": "O54_rung_controlled_alias.py",
                             "exploratory": True, "prereg": None,
                             "params": {"base": B, "floor": FLOOR,
                                        "n_zeros_folded": NZ,
                                        "rung_targets": [t[0] for t in TARGETS]},
                             "rows": rows}, indent=2))
    print(f"\nwrote {p}")


if __name__ == "__main__":
    main()
