# Prereg — does exact-zero density step at the Nyquist boundary b* = exp(π/γ₁)? (v1)

STATUS: **LOCKED**

## Background

`lean/Nyquist.lean` `base_bound_of_resolvable` caps a base that resolves
γ₁ at `b* = exp(π/γ₁) = 1.2488968`. Entry 199 showed that in O45's own
coordinate that condition is exactly `θ = γ₁·log b < 180°`, and that
O45's eleven bases **cannot** test it: θ is strictly increasing in `b`,
so splitting at `θ = 180°` *is* splitting at `b = 1.2488968`, and O45's
whole table varies monotonically along that same axis — resolved cells
fall 14028 → 496 in θ order. A level difference between two groups is
what a smooth trend in `b` produces anyway. Entry 199 recorded the
resolvable/aliased means (0.00267 against 0.00533) with **"do not read
this"** beside them, for that reason.

What separates a threshold from a trend is a **discontinuity**: bases
sampled densely on both sides of `b*`, close enough that the smooth
trend is locally flat, asking whether the statistic steps. That is arm
1. Entry 199 called it "a new scan, and it is cheap — the machinery is
O45's"; entry 211 kept it as a separate line rather than folding it into
O95.

Entry 199 also offered one hint at `n = 1`: `2^(1/3) = 1.2599` sits at
`θ = 187.12°`, the closest base above the boundary, and carries the
lowest zeros-per-resolved-cell of all eleven O45 bases, 0.00084. Arm 2
takes that hint to `n = 7` and separates the three accounts of it.

## Primary hypothesis

**H0.** Exact-zero density in the resolved stratum is continuous in `b`
across `b*`: the 13 bases above `b*` and the 13 below are one sample
from a locally smooth trend, and their contrast `D` is an ordinary draw
from the placebo distribution of the same contrast at matched geometry
elsewhere.

**H1.** Density steps at `b*`: `D` falls outside the placebo
distribution. **Predicted direction: none.** The test is two-sided
because nothing predicts a sign.

**No mechanism predicts a step, and the expected outcome is `no_step`.**
This is stated here, before the run, and not discovered afterwards. The
difference filter's per-rung gain at γ₁ is `|1 − e^{iθ}|^d =
(2 sin(θ/2))^d`, which is smooth at `θ = π` and in fact **stationary**
there — `b*` is a smooth maximum of the γ₁ response, not a break in it.
Every other ingredient of the table — `floor(b^r)`, `W(r)`, π, `r_thick`,
the resolved stratum — is either continuous in `b` or piecewise constant
on intervals that do not end at `b*`. `Nyquist.base_bound_of_resolvable`
is a statement about resolving a mode from an infinite rung set; nothing
in it says a finite zero census has a discontinuity there. A step would
therefore be the interesting outcome, and its absence is the expected
one.

## Locked parameters

| parameter | value |
|---|---|
| script | `O96_dense_boundary_scan.py --cache pi2n_cache.json --prereg preregs/dense_boundary_scan_v1_20260827.md --out results/dense_boundary_scan.json` |
| γ₁ | `14.134725141734693` (REFERENCES.md § Constants) |
| boundary | `b* = exp(π/γ₁) = 1.248896812346038861164` |
| value ceiling | `V = exp(99.5·log b*) = 4021540381.586396 = 2^31.905101` — generic, deliberately NOT `2^32` |
| plateau | `r_max = 99` on `b ∈ (1.2475096804, 1.2502995216]`, width 0.0027898; `b*` sits 7.79e−06 from its centre |
| grid | 26 bases: `b* ∓ (i + ½)·1e-4`, `i = 0..12`, 13 per side, half-window 0.0013, extremes 1.2476468 and 1.2501468. `b*` itself is never a base and the two sides are exactly symmetric |
| plateau-constancy gate | all 26 grid bases must carry `(r_max, r_thick, cells, resolved) = (99, 12, 4851, 3828)` — a varying denominator invalidates the design, so this is a run-time gate, not an assumption |
| convention | THIS PROJECT'S: 2 and 3 counted as primes, `π(1) = 0`, `N(r) = π(⌊b^r⌋) − π(⌊b^(r−1)⌋)` on `(b^(r−1), b^r]`, `⌊b^0⌋ = 1` (CONTEXT.md § Core quantities; identical to O45's) |
| resolved stratum | `r − d ≥ r_thick(b)`, `r_thick` the smallest `R` with `W(r)/ln(b^r) ≥ 1` for every `r ≥ R`. O45's criterion, pure geometry |
| depth | zeros counted at `d ≥ 1` |
| statistic | `D = (Z_above − Z_below)/(Z_above + Z_below)`, `Z_side` = exact zeros in the resolved stratum summed over that side's 13 bases. Resolved cells are constant across the window, so zeros-per-resolved-cell and zero counts differ by a fixed factor and `D` is identical under either |
| null | EMPIRICAL: 116 placebo windows, centres locked in the list below, each of matched geometry (own `r_max = 99` plateau, 13 bases/side, spacing 1e-4, constant `(r_max, r_thick, resolved)` across its own 26 bases), every one disjoint from `b*`'s plateau |
| p-rule | `p = 2·min(1 + #{D_i ≤ D_obs}, 1 + #{D_i ≥ D_obs})/(N + 1)`, capped at 1 — exactly valid under exchangeability, no distributional assumption |
| α | 0.05, two-sided |
| secondary | internal circular-rotation null: `D` over the 25 non-trivial rotations of the window's own 26-base sequence. **Labelled, and it cannot move the label** |
| arithmetic | exact Python integers for every floor, `W`, `N`, table cell and stencil mass; mpmath dps 60 only for `⌊b^r⌋` at ordinary real bases; exact integer `m`-th roots at every `2^(1/m)` |
| floor determinacy | grid bases must keep min relative distance of `b^r` to an integer above `1e-30` (O45's threshold) |
| π backend | `primecountpy.prime_pi`, audited against all 33 entries of `pi2n_cache.json` for `π(2^n)`, `n = 0..32`, exact integer equality |
| kernel verification | base 2 at `V = 2^32` must reproduce 496 cells and zeros exactly `{(2,1),(4,1),(8,3),(20,6)}` with stencil masses `{2, 4, 88, 492384}`; `exp(π·2/(2γ₁))` and `exp(π·5/(4γ₁))` must reproduce O45's published rows; `2^(1/2)` and `2^(1/3)` must reproduce them through the **exact integer root** path |
| arm 2 | `2^(1/m)`, `m = 2..8`, at the same generic `V`; each against 12 neighbours at `b_m ± j·δ_m`, `j = 1..6`, `δ_m = (plateau width)/64`; statistic `ζ = z_res/resolved` per base |
| randomness | none in the measurement. The power table was measured before lock with seed 2026; `--power-check` recomputes it and is off by default |

### Locked placebo centres (N = 116)

Deterministic output of a **geometry-only** rule — step 0.0005 from
1.2260, keep `b0` iff its own `r_max = 99` plateau contains all 26
window bases, the window's `(r_max, r_thick, resolved)` is constant
across them, and the plateau is disjoint from `b*`'s. No prime is
counted to select a centre. Listed so a later reader need not re-derive
them.

```text
1.2265 1.2270 1.2275 1.2280 1.2285 1.2345 1.2350 1.2355 1.2360 1.2365
1.2370 1.2400 1.2405 1.2410 1.2415 1.2420 1.2520 1.2550 1.2555 1.2560
1.2565 1.2570 1.2575 1.2605 1.2610 1.2640 1.2645 1.2650 1.2655 1.2660
1.2665 1.2670 1.2675 1.2680 1.2685 1.2690 1.2695 1.2725 1.2730 1.2735
1.2740 1.2745 1.2750 1.2780 1.2785 1.2790 1.2795 1.2800 1.2805 1.2835
1.2840 1.2845 1.2850 1.2855 1.2860 1.2865 1.2870 1.2875 1.2880 1.2885
1.2890 1.2895 1.2900 1.2940 1.2945 1.2950 1.2955 1.2985 1.2990 1.2995
1.3000 1.3005 1.3010 1.3015 1.3020 1.3025 1.3030 1.3035 1.3040 1.3070
1.3075 1.3080 1.3085 1.3090 1.3095 1.3100 1.3105 1.3110 1.3115 1.3120
1.3125 1.3130 1.3135 1.3140 1.3145 1.3220 1.3225 1.3230 1.3235 1.3240
1.3245 1.3250 1.3255 1.3260 1.3265 1.3270 1.3275 1.3280 1.3285 1.3290
1.3295 1.3300 1.3305 1.3310 1.3315 1.3320
```

## The null, and the level mismatch

**Poisson and binomial nulls are wrong here and are not used anywhere.**
Zero counts are strongly autocorrelated in `b`. Under independence
`Var(D) = 1/T` with `T` the window's total; measured on the placebo set
the overdispersion `sd(D)²·T` is **5.9 pooled**, and 2.6 to 12.6 across
`b0` bins whose individual estimates carry about 33% error. Any test
built on an independence assumption would be anti-conservative by that
factor.

**The mismatch the design flagged.** The placebo centres run over
`b ∈ [1.2260, 1.3320]`, where the mean zero count per base is about 9.2
against `b*`'s ≈ 14 (O45's published `z_res = 14` at the same plateau
class), and where the null sd of the raw contrast varies across the
range. The instruction was to match the placebo set more tightly in μ or
to studentise. **Both were tried; the matched-μ route was measured and
rejected, and the statistic is studentised instead.**

**Why matching was rejected.** Requiring a placebo window to carry `b*`'s
exact `(99, 12, 3828)` leaves 17 candidate centres in `b ∈ [1.2400,
1.2610]`, several of which lie inside the `b*` plateau itself. Seventeen
heavily-overlapping windows cannot support an ≥80-realisation power
table or a 5% two-sided rank rule. The route is closed by arithmetic,
not by preference.

**The studentisation, and the measurement that justifies it.** The
design proposed `D = Z_above − Z_below`. The locked statistic is the
ratio `D = (Z_above − Z_below)/(Z_above + Z_below)`. Binomially thinning
every placebo window to half its counts — level changed by a factor of
two, location held fixed — moves the null sd by:

```text
statistic                       sd at level 239.4   at level 119.7   change
raw   Z_above - Z_below                   40.6073          21.6980   -46.6%
sqrt  (Zh-Zl)/sqrt(Zh+Zl)                  2.4755           1.8816   -24.0%
ratio (Zh-Zl)/(Zh+Zl)                      0.1567           0.1700    +8.5%
```

The counts fluctuate **multiplicatively**, not as Poisson counts, so the
total in the denominator is exactly the scale the level mismatch would
otherwise move; the sqrt form, which assumes Poisson, over-corrects in
the opposite direction. The residual 8.5% sensitivity, over a level
change twice as large as the placebo/`b*` gap and in the conservative
direction (the placebo band is slightly wide for a higher-count window),
is the price and it is small.

**A third candidate was measured and rejected.** Self-normalising by the
window's own circular-rotation sd gives the flattest null (bin sd
max/min 1.42 against the ratio's 2.10) and **destroys the power**:
0.139 at ρ = 2 and 0.119 at ρ = 3, against the ratio's 0.580 and 0.927.
A real step inflates the rotation spread that would have to detect it,
so the statistic differences away the signal. That is also why the
rotation null is carried only as a labelled secondary and can never move
the label.

**The residual location variation is not significant.** Binned by `b0`
the ratio's null sd reads 0.1392 / 0.1223 / 0.1005 / 0.1434 / 0.1413 /
0.1632 / 0.2109 across seven bins, but the windows overlap (0.0026 wide,
0.0005 apart), so a bin holds about 4.6 independent windows and its sd
carries about 33% error. On **non-overlapping** windows only, the split
at `b0 = 1.29` gives sd 0.1660 (n = 13) against 0.2227 (n = 10),
`F = 1.80` against a two-sided 5% critical value near 3.7. The range is
pooled, and it is pooled because the homogeneity test does not reject,
not because the variation was trimmed away.

**The null is not centred at zero.** The placebo mean of `D` is +0.0255:
the local trend in `b` is real, and the placebo windows carry it. That
is the entire reason the null is empirical. Placebo `D`: mean +0.0255,
median +0.0309, sd 0.1567, min −0.5018, max +0.3626; the rank rule's
operative order statistics are the 2nd smallest, −0.4077, and the 2nd
largest, +0.3333.

## Power

Measured **before this draft was locked**, on the 116 placebo windows,
on real prime counts. Multiplicative step ρ planted on the above side —
binomial thinning for `ρ ≤ 1`, a Poisson addition of mean `z·(ρ−1)` for
`ρ > 1` — 60 draws per window per ρ, leave-one-out null (the band comes
from the other 115), seed 2026, α = 0.05 two-sided.

```text
    rho   detect
   0.25    0.922
   0.50    0.227
   0.75    0.049
   1.00    0.034     <- calibration; rho = 1 is the identity, so this row
   1.25    0.080        is measured, not asserted
   1.50    0.237
   2.00    0.580
   3.00    0.927
```

Calibration sits at 0.034 against a nominal 0.05. The rank rule is
conservative by construction at `N = 116`: `p ≤ 0.05` requires `D_obs`
to be among the two most extreme of the 117 values on one side, which is
2/117 = 1.7% per side. The test is powered for steps of a factor of 3 or
of 4 down (0.93, 0.92), has about 58% power at a doubling, and about 23%
at ρ = 1.5 or ρ = 0.5. **It is not powered for anything under ±50%**,
and a `no_step` output must be read against that ceiling rather than as
evidence of exact continuity.

## Decision rule — a predicate table

This is the **first prereg in the tree whose decision rule is a
predicate table** rather than an if/elif chain. `O96` implements the
table literally: an ordered list of `(label, predicate)` pairs. Labels
verbatim.

| # | label | predicate |
|---|---|---|
| 1 | `compromised` | any gate below failed |
| 2 | `step_above` | not compromised, `p ≤ 0.05`, and `D_obs` above the placebo median |
| 3 | `step_below` | not compromised, `p ≤ 0.05`, and `D_obs` below the placebo median |
| 4 | `no_step` | not compromised and `p > 0.05` |
| 5 | `undetermined` | **the literal constant `True`** — the residue |

Rows 1–4 are mutually exclusive by construction. Row 5's predicate is
unconditionally true, so the table is **total**: some row always matches,
whatever a later edit does to the rows above it. Selection is the first
row whose predicate holds.

**The assertion.** `O96` asserts that **exactly one of rows 1–4 fires**,
so the residue is never the selection. If zero fire or two fire, the
assertion has failed: `undetermined` is what the table would select,
`decision_rule_partition_failed` is appended to the compromised list,
`compromised` is what the run reports, and **that outcome is a finding
about this convention, not a result about the boundary.** It is recorded
as such and the boundary question stays open.

`compromised` fires on any of: the π backend audit failing any of its 33
comparisons; the kernel verification failing at base 2, at either
transcendental base, or at either exact-root base; the plateau-constancy
gate reading anything other than `(99, 12, 4851, 3828)` on all 26 grid
bases; the grid's floor determinacy falling below 1e-30; the placebo
list length differing from 116; any locked placebo centre failing its own
geometry gate at run time; an exact-root self-check failure in arm 2; the
partition assertion failing.

The mechanical output may be reported by an agent. **The verdict line is
Julian's to write.**

## Vacuousness check

The rule can fire in both directions on the measured power surface.
`no_step` fires with probability 0.966 when nothing is there, which is
the expected outcome and is stated as such above. `step_above` and
`step_below` each fire at 0.93 against a factor-of-three step in their
own direction and at 0.58/0.23 against a doubling or a halving — real
probabilities on real placebo data, not assumed ones. The calibration
row is measured at ρ = 1 rather than asserted: 0.034.

`compromised` is reachable and not decorative: its geometry branch was
exercised before lock. Running `O96 --self-test-centre 1.2900` — the
identical code path at a placebo centre — reads `(99, 10, 4851, 4005)`,
trips the plateau-constancy gate, and selects `compromised` with the
partition assertion holding at one fired predicate.

The one direction the rule **cannot** fire in is a step under ±50%. That
is a power ceiling, it is tabulated above, and `no_step` must be read
against it.

## Provenance — what has been seen

- **The 26 measurement bases of the `b*` grid have not been evaluated
  for their zero counts.** During design they were passed through the
  **geometry gate only**: the tuple `(r_max, r_thick, cells, resolved)`
  was computed and displayed, and it read `(99, 12, 4851, 3828)` on all
  26. No zero count, no per-side total, no `D` and no `p` at the `b*`
  grid has been displayed to any agent or to Julian. That is the blind
  arm.
- **The 116 placebo windows have been fully computed on real prime
  counts**, by the design agent and again by the build agent: their zero
  counts, the null distribution of `D`, the studentisation comparison
  and the power table are all measured numbers and are quoted above.
  Placebos are the null; seeing them is the point.
- `b*`'s own published numbers at O45's ceiling `V = 2^32` are prior
  knowledge: `results/sub_integer_base_scan.json` records `r_max 99,
  r_thick 12, 3828 resolved cells, 14 resolved zeros` for family member
  `k = 2`, which is `b*`. That is what the ≈14 zeros-per-base
  expectation above rests on, and it is a published number from a locked,
  verdict-carrying test rather than a peek at this grid.
- **Arm 2's bases were partially inspected during feasibility work.**
  Zero counts at `2^(1/m)` and at some of its neighbours were displayed
  for `m = 2..8` while the neighbour spacing rule was being chosen, at
  spacings and at one ceiling that are not the locked ones. **Arm 2
  therefore carries no verdict label**, is reported as a descriptive
  companion, and no branch of the decision rule reads it.
- Entry 199's hint — `2^(1/3)` carrying the lowest `z/cell` of O45's
  eleven — is published and is the reason arm 2 exists.
- No `π` value used by arm 1's grid was computed before this file was
  written except through the geometry gate, which counts no primes at
  all.

## Arm 2 — the companion. An arithmetic question, not a Nyquist one.

Not part of the decision rule. Stated here so its readout is fixed
before the run rather than chosen after it.

O45's `2^(1/3)` anomaly has **three** candidate accounts, not two:

1. **Above the boundary.** `θ(2^(1/3)) = 187.12°`, the closest base above
   180°.
2. **Integer-root arithmetic.** `⌊b^r⌋` is exact whenever `m | r`, so
   every `m`-th rung of `2^(1/m)` lands on a power of two and the rung
   populations are not generic.
3. **Ceiling attainment.** At O45's `V = 2^32`, `log V / log b` is
   exactly 96.0000 for `2^(1/3)` and 64.0000 for `2^(1/2)`. Both sit on
   `r_max` staircase edges, where O45's eight transcendental bases sit at
   generic fractional positions.

Arm 2 breaks (3) by construction: at the locked generic `V`,
`log V / log b` has fractional part 0.810, 0.715, 0.620, 0.526, 0.431,
0.336, 0.241 for `m = 2..8`, every one of them interior. Each `b_m` is
read against 12 local non-root neighbours inside its own `r_max`
plateau, so the smooth trend in `b` is differenced out. `n = 7` instead
of `n = 1`.

The three accounts have three distinct signatures and the design cannot
confuse them:

```text
account              which m should read low
(i)   Nyquist        m = 2, 3 only      (θ = 280.68°, 187.12° > 180°)
(ii)  arithmetic     all seven          (m | r is an m-independent fact)
(iii) ceiling        none               (broken by the generic V)
```

Readout, fixed here: per `m`, `ζ = z_res/resolved` for `b_m`, the
neighbour mean, sd and median, `b_m`'s rank among the 13, and its
standardised deviation. Across `m`, the count `k` of bases below their
own neighbour median with the one-sided binomial `p` at `n = 7`,
`q = 1/2`, and which of those are above the Nyquist boundary. Seven is a
small `n` and the binomial `p` cannot reach 0.05 below `k = 0`
(`p = 0.0078`) or `k = 1` (`p = 0.0625`); the arm is a signature test,
not a significance test, and is reported as one.

## Run record

(fill at run)
