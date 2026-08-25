#!/usr/bin/env python3
"""O69 — how many windings until the angle count becomes the logarithm?

EXPLORATORY: no prereg. Julian's question, verbatim: the zero count enters
at T*log T "because after enough angles it becomes a curve — what if we
calculate how many times the angles create the crossover to a logarithm."

THE STRUCTURE BEING MEASURED. N(T) is an angle count: each zero is one
full 2*pi winding of xi(s) around the rectangle (the argument principle).
The winding splits into a smooth part carried by the Gamma factor's phase
-- theta(T) ~ (T/2)log(T/2pi), which IS the logarithm -- and a
fluctuating part S(T) = (1/pi) arg zeta(1/2 + iT). Rosser's Theorem 19
(the hNT leaf, entry 119's find) says the fluctuation stays inside
   R(T) = 0.137 log T + 0.443 log log T + 1.588   for T >= 1467.
PNT+'s crude majorant A*T^(3/2) is what a count costs WITHOUT the
argument principle (its docstring: "no argument-principle input"); O68's
x^(2/3) check showed that shape cannot feed the census. This script
measures, on the first 100000 zeros (imported/twin_count/zeros1.txt,
gamma <= ~74921), what counting the angles buys and when.

FOUR NUMBERS.
  1. Band entry: the last zero index at which |N(T) - mainterm(T)|
     exceeds R(T), sampled at every zero (from below and above the
     jump). After that index, the angle count IS the log curve to
     within Rosser's band -- the crossover, in windings.
  2. Curve lock-on: the number of windings after which the relative
     deviation |N - mainterm|/N stays below 1% and 0.1%.
  3. The price of skipping angles: A* = max_T N(T)/T^(3/2) over the
     range (the smallest constant the crude majorant could possibly
     carry here), where the max sits, and the waste factor
     A* * T^(3/2) / N(T) at the top of the range.
  4. The phase split: max |S-part| = max |N - mainterm| against the
     smooth term's size at range top -- how much of the winding is
     logarithm and how much is fluctuation.

mainterm(T) = T/(2pi) * log(T/(2pi)) - T/(2pi) + 7/8.

Reads with: notes/lab_notebook_2.md entries 116, 118, 119;
PrimeNumberTheoremAnd/Backlund/ZeroCountCrude.lean (the majorant),
IEANTN/RosserSchoenfeld/RosserSchoenfeldZeta.lean theorem_19 (the band).
"""
import json, math, pathlib

_HERE = pathlib.Path(__file__).resolve().parent
TWO_PI = 2 * math.pi


def mainterm(T):
    return T / TWO_PI * math.log(T / TWO_PI) - T / TWO_PI + 7 / 8


def band(T):
    return 0.137 * math.log(T) + 0.443 * math.log(math.log(T)) + 1.588


def main():
    zeros = [float(s) for s in
             (_HERE / "imported" / "twin_count" / "zeros1.txt").read_text().split()]
    n_z = len(zeros)
    print(f"O69 — the angle count vs the logarithm, on {n_z} zeros "
          f"(gamma <= {zeros[-1]:.1f}).\n")

    # 1. band entry — check the count against the Rosser band at each jump.
    #    At gamma_j the count is j-1 from below and j from above.
    last_out, n_checked = None, 0
    for j, g in enumerate(zeros, start=1):
        if g <= math.e:
            continue
        n_checked += 1
        m, R = mainterm(g), band(g)
        if abs((j - 1) - m) > R or abs(j - m) > R:
            last_out = (j, g, (j - 1) - m, j - m, R)
    print("1. BAND ENTRY (Rosser Th. 19 band, checked at every jump):")
    if last_out is None:
        print(f"   the count never leaves the band on this range "
              f"({n_checked} jumps checked) — the crossover happened "
              f"before the first zero: 0 windings needed.")
    else:
        j, g, lo, hi, R = last_out
        print(f"   last excursion at winding {j} (gamma = {g:.3f}): "
              f"deviations {lo:+.3f}/{hi:+.3f} vs band {R:.3f}. "
              f"Inside the band for all later zeros.")

    # 2. curve lock-on — relative deviation thresholds.
    locks = {}
    for thresh in (0.01, 0.001):
        last_bad = 0
        for j, g in enumerate(zeros, start=1):
            m = mainterm(g)
            if m <= 0:
                last_bad = j
                continue
            if abs(j - m) / j > thresh:
                last_bad = j
        locks[thresh] = last_bad + 1
    print("\n2. CURVE LOCK-ON (relative deviation |N - mainterm|/N):")
    for thresh, j in locks.items():
        g = zeros[j - 1] if j <= n_z else None
        print(f"   stays below {thresh:g} from winding {j} "
              f"(gamma = {g:.3f})" if g else f"   never locks at {thresh:g}")

    # 3. the price of skipping the angles.
    A_star, arg_j = 0.0, 0
    for j, g in enumerate(zeros, start=1):
        v = j / g ** 1.5
        if v > A_star:
            A_star, arg_j = v, j
    top = zeros[-1]
    waste = A_star * top ** 1.5 / n_z
    print(f"\n3. THE PRICE OF SKIPPING ANGLES (crude majorant A*T^(3/2)):")
    print(f"   smallest possible A on this range: {A_star:.6f}, "
          f"attained at winding {arg_j} (gamma = {zeros[arg_j-1]:.3f})")
    print(f"   waste at range top: A*.T^(3/2) / N = {waste:,.0f}x")

    # 4. the phase split.
    max_dev = max(abs(j - mainterm(g)) for j, g in enumerate(zeros, start=1))
    m_top = mainterm(top)
    print(f"\n4. THE PHASE SPLIT at range top (gamma = {top:.1f}):")
    print(f"   smooth (Gamma-phase logarithm) term: {m_top:,.1f} windings")
    print(f"   max fluctuation |S-part| over range: {max_dev:.3f} windings")
    print(f"   the logarithm carries {m_top / n_z * 100:.4f}% of the count; "
          f"the fluctuation never exceeds {max_dev / band(top) * 100:.0f}% "
          f"of the Rosser band at range top.")

    out = {"schema_version": "1", "script": "O69_angle_crossover.py",
           "exploratory": True, "prereg": None,
           "params": {"zeros_file": "imported/twin_count/zeros1.txt",
                      "n_zeros": n_z, "gamma_max": top,
                      "band": "0.137*log T + 0.443*log log T + 1.588",
                      "mainterm": "T/2pi*log(T/2pi) - T/2pi + 7/8"},
           "band_entry": {"last_excursion_winding": last_out[0] if last_out else 0,
                          "inside_band_from_first_zero": last_out is None},
           "lock_on": {str(k): v for k, v in locks.items()},
           "crude_majorant": {"A_star": A_star, "attained_at_winding": arg_j,
                              "waste_at_top": waste},
           "phase_split": {"mainterm_at_top": m_top,
                           "max_fluctuation": max_dev}}
    (_HERE / "results" / "angle_crossover.json").write_text(
        json.dumps(out, indent=2))
    print(f"\nwrote {_HERE / 'results' / 'angle_crossover.json'}")


if __name__ == "__main__":
    main()
