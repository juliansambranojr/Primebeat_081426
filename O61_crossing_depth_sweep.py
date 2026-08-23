#!/usr/bin/env python3
"""O61 — EXPLORATORY. No prereg, no verdict.

Does the table's transform cross the critical radius at a depth that MEANS
anything, or is it a truncation artifact?

WHY. O60 found the dyadic table's mean root modulus walking outward with depth
and passing the critical radius b^(-1/2) at d ~ 11.93, landing inside the band
the six measured zeros occupy at d = 12. Two constructions coinciding once is
not evidence. This tries to break it.

TWO TESTS, and the second is the decisive one.

  BASE SWEEP. The critical radius b^(-1/2) moves with b. If the crossing is
  structural the crossing depth should move with it in some stated way. If it
  is erratic, or tracks nothing but the rung count, the coincidence is
  numerology.

  TRUNCATION CONTROL, at fixed base 2. Hold the arithmetic completely fixed and
  vary ONLY how many rungs the polynomial is built from. The critical radius
  does not move. The primes do not move. If the crossing depth moves anyway,
  it is a property of the coefficient count and nothing else, and O60's d = 12
  is an artifact.

  The confound the base sweep cannot escape, stated in advance: rungs = log
  (ceiling) / log b, so a higher base has fewer rungs and less usable depth.
  Base 9 at ceiling 1e12 has 12 rungs and cannot reach depth 12 at all. Any
  apparent b-dependence is therefore contaminated by rung count, which is why
  the truncation control at fixed b is the test that decides.

CONSTRUCTION identical to O39_transform_radius.py:437-450 and O60.

Reads with: O39_transform_radius.py, O60_table_torus.py, lean/Crossover.lean,
results/table_torus.json, results/per_zero_exponent_run2.json
"""
import json, math, pathlib
import numpy as np
from primecountpy import prime_pi

_HERE = pathlib.Path(__file__).resolve().parent
CEIL = 10 ** 12
BASES = [2, 3, 4, 5, 6, 7, 8, 9]
TRUNCATIONS = [45, 40, 35, 30, 25, 20]     # base-2 rung counts to test
MIN_COEFFS = 3


def row_for(b, rmax):
    pis = [prime_pi(b ** r) for r in range(rmax + 1)]
    return [float(pis[r] - pis[r - 1]) if r > 0 else 0.0 for r in range(rmax + 1)]


def table_from(row, rmax):
    T = {(r, 0): row[r] for r in range(rmax + 1)}
    for d in range(1, rmax + 1):
        for r in range(d, rmax + 1):
            T[(r, d)] = T[(r, d - 1)] - T[(r - 1, d - 1)]
    return T


def mean_abs(T, d, rmax):
    co = [T[(r, d)] for r in range(d + 1, rmax + 1)]
    if len(co) < MIN_COEFFS:
        return None
    a = np.array(co[::-1], dtype=float)
    if not np.all(np.isfinite(a)) or np.all(a == 0.0):
        return None
    m = np.abs(np.roots(a))
    return float(m.mean()) if m.size else None


def crossing(T, rmax, crit):
    """First depth where mean|z| rises through crit; linear interpolation."""
    prev = None
    for d in range(0, rmax):
        m = mean_abs(T, d, rmax)
        if m is None:
            break
        if prev is not None and prev[1] < crit <= m:
            f = (crit - prev[1]) / (m - prev[1])
            return prev[0] + f, d
        prev = (d, m)
    return None, None


def main():
    print("O61 - is the critical-radius crossing structural or a truncation artifact?")
    print("EXPLORATORY, no prereg, no verdict.\n")

    print("=== 1. BASE SWEEP  (ceiling 1e12, rungs = floor(log ceil / log b))")
    print(f"   {'b':>3} {'rungs':>6} {'crit=b^-1/2':>12} {'cross depth':>12}"
          f" {'cross/rungs':>12}")
    base_rows = []
    for b in BASES:
        rmax = int(math.log(CEIL) / math.log(b))
        row = row_for(b, rmax)
        T = table_from(row, rmax)
        crit = b ** -0.5
        xd, _ = crossing(T, rmax, crit)
        base_rows.append({"base": b, "rungs": rmax, "crit": crit,
                          "cross_depth": xd,
                          "cross_over_rungs": (xd / rmax) if xd else None})
        s = f"{xd:.2f}" if xd else "never"
        f = f"{xd/rmax:.3f}" if xd else "-"
        print(f"   {b:>3} {rmax:>6} {crit:>12.6f} {s:>12} {f:>12}")

    print("\n=== 2. TRUNCATION CONTROL, base 2 fixed")
    print("   Same primes, same critical radius. Only the rung count changes.")
    print(f"   {'rungs':>6} {'cross depth':>12} {'cross/rungs':>12}")
    trunc_rows = []
    full = row_for(2, max(TRUNCATIONS))
    for rmax in TRUNCATIONS:
        T = table_from(full[:rmax + 1], rmax)
        xd, _ = crossing(T, rmax, 2 ** -0.5)
        trunc_rows.append({"rungs": rmax, "cross_depth": xd,
                           "cross_over_rungs": (xd / rmax) if xd else None})
        s = f"{xd:.2f}" if xd else "never"
        f = f"{xd/rmax:.3f}" if xd else "-"
        print(f"   {rmax:>6} {s:>12} {f:>12}")

    xs = [w["cross_depth"] for w in trunc_rows if w["cross_depth"]]
    fs = [w["cross_over_rungs"] for w in trunc_rows if w["cross_over_rungs"]]
    print(f"\n   crossing depth across truncations: spread {max(xs)-min(xs):.2f}"
          f"  (min {min(xs):.2f}, max {max(xs):.2f})")
    print(f"   as a FRACTION of rungs:            spread {max(fs)-min(fs):.3f}"
          f"  (min {min(fs):.3f}, max {max(fs):.3f})")
    print("\n   READ: if the absolute depth is stable and the fraction moves, the")
    print("   crossing is a property of the arithmetic. If the fraction is stable")
    print("   and the absolute depth moves, it is the coefficient count.")

    (_HERE / "results" / "crossing_depth_sweep.json").write_text(json.dumps(
        {"schema_version": "1", "script": "O61_crossing_depth_sweep.py",
         "exploratory": True, "prereg": None,
         "params": {"ceiling": CEIL, "bases": BASES,
                    "truncations": TRUNCATIONS, "min_coeffs": MIN_COEFFS},
         "rows": {"base_sweep": base_rows, "truncation_control": trunc_rows}},
        indent=2))
    print(f"\nwrote {_HERE / 'results' / 'crossing_depth_sweep.json'}")


if __name__ == "__main__":
    main()
