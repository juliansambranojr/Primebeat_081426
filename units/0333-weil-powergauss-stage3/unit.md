---
id: 0333
date: 2026-09-06
type: formalization
title: "WeilPowerGauss.lean: the odd transform in the Gaussian regime through Euler's product for sinh, upper bounds at every zero and a lower bound at the target with one constant"
refs: [lean_stage3/Stage3/WeilPowerGauss.lean::euler_sinh, lean_stage3/Stage3/WeilPowerGauss.lean::norm_S_le_gauss_pos, lean_stage3/Stage3/WeilPowerGauss.lean::norm_S_le_gauss_neg, lean_stage3/Stage3/WeilPowerGauss.lean::S_real_ge_gauss]
supersedes: []
follows: 0332
sealed: false
---

**Question.** Rung `rung` 5, sixth slice. Unit 0331's lower bound at the
target compares the product in the closed form with its largest factor
to the power `m+1`, and that loses a factor near `e` to the `2m` against
the true product. With `m` of the order of the support the loss swallows
the main term. Can the transform be bounded above at every zero and
below at the target with one and the same constant, so that the
comparison between them is exact?

**What ran.** `lean_stage3/Stage3/WeilPowerGauss.lean`, new,
`module_lines` 564 lines, imported from `Stage3.lean`. `errors_first` 8
errors on the first build, `errors_second` 1 on the second: a `ring` that
needed the denominators cleared first, five tactics left standing after
their goal had closed, two arithmetic closes that wanted the product
hypothesis multiplied out, and one coefficient in a linear combination,
which the build's printed residual gave exactly. Full package built,
`jobs_package` 8751 jobs. `run/build.log` is the record.

**What it shows.** `theorems_proved` 25 theorems and `defs` 4 definitions
(`g`, `D`, `T`, `Tr`), the pinned theorems by `#guard_msgs` to `axioms` 3
axioms, `sorries` 0 sorries.

Euler's product. `euler_sinh`: Mathlib's product for the sine, read at
`iw` over `π`, gives `sinh w` as the limit of `w` times the product of
`1 + w²/(π²(j+1)²)` over `j` below `n`. The head of that product, the
factors up to `m+1`, is the closed form's denominator over `D m`, the
product of `π²(j+1)²` (`QS_eq_D_mul`, `D_eq`). So the transform is the
limit of `cS m / D m` times `w` times the tail from `m+1` to `n`
(`tendsto_S`).

The constant. `cprime_eq`: `cS m / D m` is the central binomial
coefficient at `m+1` over `π(m+1)4^m`. Mathlib's two bounds on the
central binomial give `cprime_le`, at most `4/(π(m+1))`, and `cprime_ge`,
at least `4/(π(m+1)(2m+3))`. That is the one constant on both sides.

The tail, factor by factor. `norm_one_add_le`: for a complex `x` of norm
at most `half` 1/2, the norm of `1 + x` is at most the exponential of
the real part of `x` plus its norm squared. `exp_le_one_add`: for real
`x` in `[0, 1/2]`, the exponential of `x − x²` is at most `1 + x`. Both
from Mathlib's bound on `log(1 + x) − x`.

The tail sums. `sum_inv_sq_le`: the sum of `1/(j+1)²` over the tail is at
most `1/(m+1)`, by telescoping. `sum_inv_sq_ge`: over the tail up to
`2m+3` it is at least `(m+2)/(2m+3)²`. `sum_inv_pow4_le`: the fourth
powers sum to at most `1/(m+1)³`.

The bounds. Under `‖w‖²` at most `π²(m+2)²/2`, every tail factor's
argument is within `1/2` of zero (`norm_x_le`). `norm_S_le_gauss_pos`,
for `Re(w²)` at least zero: the norm of `S m w` is at most `4/(π(m+1))`
times `‖w‖` times the exponential of `Re(w²)/(π²(m+1))` plus
`‖w‖⁴/(π⁴(m+1)³)`. `norm_S_le_gauss_neg`, for `Re(w²)` at most zero: the
same with `Re(w²)(m+2)/(π²(2m+3)²)` in the exponent. `S_real_ge_gauss`,
for real `s` above zero: the real part of `S m s` is at least
`4/(π(m+1)(2m+3))` times `s` times the exponential of
`s²(m+2)/(π²(2m+3)²)` minus `s⁴/(π⁴(m+1)³)`.

What this closes. At `w` equal to `(ε' + iΔ)h` with `m+1` equal to `λh`,
the exponent is `(ε'² − Δ²)h/(π²λ)` up to the quartic error
`(ε'² + Δ²)²h/(π⁴λ³)`. That is the Gaussian amplitude unit 0327 asked the
new window for: exponential in the real part squared, suppressed in the
height squared, and the comparison between a zero's reading and the
target's is a ratio of exponentials with a polynomial in front.

What it leaves. The regime condition `‖w‖² ≤ π²(m+2)²/2` and the quartic
error both need `λ` of order one or more; the assembly fixes `λ`. The
constant `4/(π(m+1))` against `4/(π(m+1)(2m+3))` costs a factor `2m+3`,
polynomial. Unit 0331's far bound still covers the heights outside this
regime.
