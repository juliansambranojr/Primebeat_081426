---
id: 0341
date: 2026-09-06
type: formalization
title: "WeilPowerCompare.lean: the comparison at another off-line zero, the two Gaussian upper bounds unified, the rate against the quartic error"
refs: [lean_stage3/Stage3/WeilPowerCompare.lean::norm_S_le_gauss, lean_stage3/Stage3/WeilPowerCompare.lean::compare_le, lean_stage3/Stage3/WeilPowerCompare.lean::exponent_eq, lean_stage3/Stage3/WeilPowerCompare.lean::compare_suppressed]
supersedes: []
follows: 0335
sealed: false
---

**Question.** Rung `rung` 5, `slice` 9. Unit 0333 bounds the switched
window's transform in the Gaussian regime from above at every point of the
strip and from below on the real axis. Worksheet `section` 7 asks what
those two bounds say when they are read at two points at once: the target
`(ε, 0)` at `s = εh` and another off-line zero `(ε', Δ)` at `w = (ε' +
iΔ)h`. When is the second zero's term small beside the target's?

**What ran.** `lean_stage3/Stage3/WeilPowerCompare.lean`, new,
`module_lines` 340 lines, imported from `Stage3.lean`. `errors_first` 5
errors on the first build. Full package built, `jobs_package` 8754 jobs;
the module alone is `jobs_module` 8662 jobs. `run/build.log` is the
record.

**What it shows.** `theorems_proved` 21 theorems and `defs` 8 definitions
(`cP`, `cE`, `cQ`, `Eup`, `Elow`, `wOf`, `rate`, `qerr`), the pinned
theorems by `#guard_msgs` to `axioms` 3 axioms, `sorries` 0 sorries.

The two upper bounds are one bound. Unit 0333 splits its upper bound on
the sign of `Re(w²)`: the strong coefficient `cP m = 1/(π²(m+1))` where the
real part of the square is nonnegative, the weak `cE m = (m+2)/(π²(2m+3)²)`
where it is not. `Eup m w = cE m·Re(w²) + (cP m − cE m)·max (Re(w²)) 0 +
cQ m·‖w‖⁴` picks whichever applies, and `norm_S_le_gauss` is the single
upper bound over the whole regime `‖w‖² ≤ π²(m+2)²/2`. The inequality that
makes the two coefficients comparable is `cE_le_cP`, which is
`(m+1)(m+2) ≤ (2m+3)²`; the ratio `cE/cP` starts at `ratio_min` 2/9 at
`m = 0` and climbs to its limit `ratio_max` 1/4, so it is the worksheet's
`c` between 1/4 and 1 read from the other side.

The comparison. `S_real_ge_low` is unit 0333's lower bound written with the
matching exponent `Elow m s = cE m·s² − cQ m·s⁴`, and `S_real_pos` says the
target's transform is positive inside the regime. `compare_le` divides
one by the other: the transform at any point of the regime is at most
`(2m+3)·(‖w‖/s)·exp(Eup m w − Elow m s)` times the target's. The prefactor
loss is the single factor `2m+3`, which is what worksheet § 5 records as
the loss between the upper and the lower constant. That factor is the
whole of the worksheet's `poly(h, m)`.

The exponent. `wOf ε' Δ h = (ε' + iΔ)h` is the point the window reads;
`wOf_sq_re` and `norm_wOf_sq` give `Re(w²) = (ε'² − Δ²)h²` and
`‖w‖² = (ε'² + Δ²)h²`. `exponent_eq` then splits the exponent difference
with no sign hypothesis at all:

`Eup m (wOf ε' Δ h) − Elow m (εh) = rate m ε' Δ ε·h² + qerr m ε' Δ ε·h⁴`,

`rate` the quadratic part and `qerr = cQ m·((ε'² + Δ²)² + ε⁴)` the
quartic. `rate_eq_of_le`: at `Δ² ≥ ε'²` the rate is `−cE m·(Δ² + ε² − ε'²)`.
`rate_neg_of_le`: that rate is negative for any positive `ε` with no
condition on `ε'` — the worksheet's zero suppressed at every real part.
`rate_neg_of_ge`: at `Δ² ≤ ε'²` the rate is negative exactly when
`cP m·(ε'² − Δ²) < cE m·ε²`, the same criterion with the constant `cE/cP`
in front of `ε²`.

`compare_suppressed` is the deliverable: for `h` in the range where
`qerr·h² ≤ −rate/2` the comparison reads `‖S m (wOf ε' Δ h)‖ ≤
(2m+3)·(‖w‖/(εh))·exp(rate·h²/2)·Re (S m (εh))`. The sign of the rate is
carried by that range condition rather than assumed: `qerr_pos` and
`rate_neg_of_qerr` show a positive quartic error forces `rate < 0`, so the
hypothesis was dropped and the theorem is stated without it.

What this leaves out. The heights outside `‖w‖² ≤ π²(m+2)²/2` are unit
0331's `norm_S_le_far`, whose decay `(2/(Im w)²)^{m+1}` needs no Gaussian;
worksheet § 7's second paragraph is that bound and is cited in the header
rather than restated. The module is stated in `m` and `h`, with no
`m + 1 = λh` imposed, so `λ` stays a parameter of the assembly.

What the next slice needs. Worksheet § 8: the selection of the target, a
zero of largest real part in a widened box, so that every other zero has
`ε'² − Δ²` below `ε² + K'π²λ/h` and `rate_neg_of_ge` covers the whole
cluster in one application. The shape there is a maximum over a finite
set and an induction on the box's widening steps; nothing in this module
constrains it beyond fixing the criterion it has to meet. Unit 0316's
arrow still waits on the assembly of worksheet § 10.
