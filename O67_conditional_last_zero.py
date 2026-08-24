#!/usr/bin/env python3
"""O67 — the RH-conditional nonvanishing theorem, with explicit constants.

NOT a measurement: a derivation with numerically verified constants, and the
R(d) table. EXPLORATORY in the sense that no prereg governs it; the theorem
itself is conditional mathematics, stated below and checked here.

THE CLAIM (entry 26 called it "THEOREM AVAILABLE"; this supplies it).

  Under RH, cell(r,d) != 0 whenever
     (i)   r - d - 1 >= 12                       (Schoenfeld's x >= 2657)
     (ii)  d <= 0.34 * (r - d - 1)               (the wedge)
     (iii) M_low(r,d) > E_high(r,d)              (main term beats error)
  and (iii) holds for all r >= R(d), tabulated below: R(d) ~ 5d + 11.

  COMBINED WITH O43 (no exact zeros for r <= 92 beyond the four, verified on
  published pi(2^n)): under RH, (20,6) is the LAST exact zero at every depth
  d <= 15, for all r. At d >= 16 a finite strip r in (92, R(d)) is unchecked,
  and the deep region d > 0.34(r-d-1) is not covered by this argument at all.

THE PROOF, in five steps, each checked numerically in this script.

  1. cell(r,d) = sum_{k=0}^{d+1} (-1)^k C(d+1,k) pi(2^(r-k))   [the stencil;
     Zeros.tableFrom_eq_stencil applied to the row pi(2^r) - pi(2^(r-1))].
  2. Split pi = li + (pi - li). The li part is a (d+1)-fold backward
     difference of g(x) = li(2^x) at unit step, so by the iterated mean value
     theorem it equals g^(d+1)(xi) for some xi in (r-d-1, r).
  3. g'(x) = 2^x/x, and the d-th derivative of 2^x/x is
        2^x * sum_{j=0}^d C(d,j) (log 2)^(d-j) (-1)^j j! x^(-1-j),
     an alternating series whose term ratio is (d-j)/((log 2) x) <= 0.4905
     under (ii). Alternating with decreasing terms gives
        M >= (1 - 0.4905) * 2^xi (log 2)^d / xi
          >= 0.5095 * 2^(r-d-1) (log 2)^d / r        =: M_low(r,d)
     (the script uses 0.5, slightly weaker, so the check is conservative).
  4. Schoenfeld under RH: |pi(x) - li(x)| <= sqrt(x) log(x) / (8 pi) for
     x >= 2657. Summing over the window with binomial weights:
        E <= (log 2 / (8 pi)) * r * 2^(r/2) * (1 + 2^(-1/2))^(d+1)
          =: E_high(r,d).
  5. M_low > E_high forces cell != 0. R(d) is the smallest such r.

WHAT THIS DOES NOT DO. It is conditional on RH; it says nothing at depths
d >= 16 in the strip (92, R(d)); and the deep region is untouched — there the
window bottom is small, Schoenfeld does not apply to the whole window, and the
derivative series is uncontrolled. A different argument is needed there.

Reads with: papers/The-Four-Zeros.md § H, preregs/extended_zero_census (O43),
lean/Zeros.lean (tableFrom_eq_stencil), notes/lab_notebook_2.md entry 112.
"""
import json, math, pathlib
import mpmath as mp

_HERE = pathlib.Path(__file__).resolve().parent
mp.mp.dps = 40
LOG2 = math.log(2)
O43_EXTENT = 92


def g_deriv(x, dp1):
    """(d+1)-th derivative of li(2^x): the d-th derivative of 2^x/x."""
    d = dp1 - 1
    s = mp.mpf(0)
    for j in range(d + 1):
        s += (mp.binomial(d, j) * mp.mpf(LOG2) ** (d - j)
              * (-1) ** j * mp.factorial(j) * mp.mpf(x) ** (-1 - j))
    return mp.mpf(2) ** x * s


def li_stencil(r, d):
    dp1 = d + 1
    return sum((-1) ** k * mp.binomial(dp1, k) * mp.li(mp.mpf(2) ** (r - k))
               for k in range(dp1 + 1))


def M_low(r, d):
    return mp.mpf('0.5') * mp.mpf(2) ** (r - d - 1) * mp.mpf(LOG2) ** d / r


def E_high(r, d):
    return (mp.mpf(LOG2) / (8 * mp.pi)) * r * mp.mpf(2) ** (mp.mpf(r) / 2) \
        * mp.mpf(1 + 2 ** -0.5) ** (d + 1)


def R_of(d, rmax=600):
    r = max(d + 13, 14)
    while r <= rmax:
        if M_low(r, d) > E_high(r, d) and d <= 0.34 * (r - d - 1):
            return r
        r += 1
    return None


def main():
    print("O67 — under RH, cell(r,d) != 0 beyond an explicit R(d).")
    print("Derivation checked numerically; see the docstring for the proof.\n")

    print("CHECK 1 — the alternating-series lower bound (step 3) is honest:")
    ok1 = True
    for (r, d) in [(16, 1), (30, 4), (48, 6), (60, 8), (80, 12), (120, 20)]:
        act = abs(li_stencil(r, d))
        ok = act >= M_low(r, d) and d <= 0.34 * (r - d - 1)
        ok1 &= ok
        print(f"   (r={r},d={d}): |stencil li| {float(act):.4g}"
              f"  >= M_low {float(M_low(r, d)):.4g}  {ok}")
    print(f"   all pass: {ok1}\n")

    print("CHECK 2 — the MVT placement (step 2): stencil inside derivative range:")
    ok2 = True
    for (r, d) in [(20, 6), (40, 8), (60, 10)]:
        dp1 = d + 1
        sten = li_stencil(r, d)
        vals = [g_deriv(r - dp1 + i / 4, dp1) for i in range(4 * dp1 + 1)]
        ok = min(vals) <= sten <= max(vals)
        ok2 &= ok
        print(f"   (r={r},d={d}): {ok}")
    print(f"   all pass: {ok2}\n")

    print("THE TABLE — R(d), and whether O43's r <= 92 census closes the gap:")
    print(f"   {'d':>3} {'R(d)':>6} {'gap (92, R(d))':>16}")
    rows = []
    covered_to = None
    for d in range(1, 25):
        R = R_of(d)
        gap = "covered" if (R is not None and R <= O43_EXTENT + 1) else \
              (f"UNCHECKED r in (92,{R})" if R else "no R found <= 600")
        rows.append({"d": d, "R": R, "gap_closed": R is not None and R <= O43_EXTENT + 1})
        if rows[-1]["gap_closed"]:
            covered_to = d
        print(f"   {d:>3} {R!s:>6} {gap:>16}")

    print(f"\nTHEOREM (conditional). Under RH, combining R(d) with O43's census:")
    print(f"   (20,6) is the LAST exact zero at every depth d <= {covered_to},")
    print(f"   for ALL r. First uncovered: d = {covered_to + 1}, strip "
          f"(92, {R_of(covered_to + 1)}).")
    print("   The deep region d > 0.34(r-d-1) is not covered by this argument.")

    (_HERE / "results" / "conditional_last_zero.json").write_text(json.dumps(
        {"schema_version": "1", "script": "O67_conditional_last_zero.py",
         "exploratory": True, "prereg": None,
         "params": {"dps": 40, "o43_extent": O43_EXTENT,
                    "schoenfeld_floor_r_minus_d_minus_1": 12,
                    "wedge": "d <= 0.34*(r-d-1)", "main_constant": 0.5},
         "checks": {"alternating_lower_bound": ok1, "mvt_placement": ok2},
         "rows": rows,
         "conclusion": {"last_zero_depth_covered": covered_to,
                        "first_uncovered_depth": covered_to + 1}}, indent=2))
    print(f"\nwrote {_HERE / 'results' / 'conditional_last_zero.json'}")


if __name__ == "__main__":
    main()
