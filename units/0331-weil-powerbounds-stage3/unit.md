---
id: 0331
date: 2026-09-06
type: formalization
title: "WeilPowerBounds.lean: the odd transform bounded off the axis, far up in height, and from below on the real axis"
refs: [lean_stage3/Stage3/WeilPowerBounds.lean::norm_S_le, lean_stage3/Stage3/WeilPowerBounds.lean::norm_S_le_far, lean_stage3/Stage3/WeilPowerBounds.lean::S_real_ge]
supersedes: []
follows: 0330
sealed: false
---

**Question.** Rung `rung` 5, fourth slice. Unit 0330 put the switched
window's transform in closed form: `sinh` over a product of `m+1`
quadratic factors. What bounds does that polynomial give, crude and
explicit, in the three places the assembly reads the transform: a zero
off the axis at any height, a zero far up in height, and the target on
the real axis?

**What ran.** `lean_stage3/Stage3/WeilPowerBounds.lean`, new,
`module_lines` 249 lines, imported from `Stage3.lean`. `errors_first` 1
error on the first build, a cast form in the real-axis identity. Full
package built, `jobs_package` 8749 jobs. `run/build.log` is the record.

**What it shows.** `theorems_proved` 19 theorems and `defs` 1 definition
(`Ps`, the real product), the pinned theorems by `#guard_msgs` to
`axioms` 3 axioms, `sorries` 0 sorries.

Off the axis. Each factor `w² + a²` is `(w − ia)(w + ia)`, and both of
those have real part `Re w`, so each factor has norm at least `(Re w)²`
(`norm_factor_ge`) and the product has norm at least `(Re w)` to the
power `2(m+1)` (`norm_QS_ge`). The product is nonzero off the imaginary
axis, the closed form is a quotient there (`S_eq_div`), and `norm_S_le`
bounds the transform by `cS m` times `cosh(Re w)` over the product's norm,
`sinh` being at most `cosh` of the real part in norm (unit 0319's
`norm_sinh_le`).

Far up in height. When `(Im w)²` is at least `far_mult` 2 times
`(Re w)² + π²(m+1)²`, each factor has real part at most minus half of
`(Im w)²`, so each factor has norm at least `(Im w)²/2`
(`norm_factor_ge_far`), and `norm_S_le_far` bounds the transform by
`cS m · cosh(Re w)` times `(2/(Im w)²)` to the power `m+1`. That is the
decay of order `2m+2` in the height, at every real part.

On the real axis. `S_real_eq`: at real `s` the transform is the real
number `cS m · sinh s / Ps m s`. `Ps_le`: the real product is at most
the largest factor to the power `m+1`. `sinh_ge`: `sinh s` is at least
`e^s` over `sinh_denom` 4 for `s` at least `s_min` 1. `S_real_ge`: the
transform at real `s ≥ 1` is at least `cS m · e^s` over `4` times
`(s² + π²(m+1)²)` to the power `m+1`. That is the target's main term,
bounded below.

What this closes. The three readings the assembly needs are bounded. For
a zero at `1/2 + ε' + iγ'` and the window tuned at `γ` with support `h`,
the transform is read at `w` with real part `ε'h` and imaginary part
`(γ' − γ)h`. With `m` of the order of `h`, the far bound makes every zero
farther than a fixed height from the target exponentially small against
the target's main term, whatever its real part. That is the suppression
unit 0327 asked the new window for.

What the next slices need. The background of the new window: `W` times
`e^{−u/2}` cut to `[−h, h]` as the test function, its Laplace transform
as `what` at `−z − 1/2`, every term of the zero form as minus a square of
`what`, the on-line terms as squares of real numbers. Then the near zeros,
the cluster, where the per-factor ratio between a zero's reading and the
target's is the object.
