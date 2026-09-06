---
id: 0329
date: 2026-09-06
type: formalization
title: "WeilPower.lean: the m-th power window's transform in closed form, by a recurrence in m"
refs: [lean_stage3/Stage3/WeilPower.lean::K_succ, lean_stage3/Stage3/WeilPower.lean::K_mul_Q, lean_stage3/Stage3/WeilPower.lean::K_one_mul]
supersedes: []
follows: 0328
sealed: false
---

**Question.** Julian chose the switch of unit 0327: the envelope becomes
the `m`-th power of the raised cosine, with `m` of the order of the
support. Rung `rung` 5, second slice. What is the transform of that
envelope, `K m w`, the integral over the unit interval of `P^m` times
`e^{wx}`, in closed form?

**What ran.** `lean_stage3/Stage3/WeilPower.lean`, new, `module_lines` 303
lines, imported from `Stage3.lean`. `errors_first` 5 errors on the first
build, all mechanical: a `simp` set that rewrote a power it should have
left alone, `fun_prop` blind to a new definition until given the
attribute, a `congr` that closed early, a constant identity, a cast. Two
of the fixes were iterated in a scratch file at seconds per try. Full
package built, `jobs_package` 8747 jobs. `run/build.log` is the record.

**What it shows.** `theorems_proved` 24 theorems and `defs` 6 definitions
(`c`, `f1`, `f2`, `K`, `Q`, `cK`), the pinned theorems by `#guard_msgs` to
`axioms` 3 axioms, `sorries` 0 sorries.

The route. Unit 0327 sketched a binomial expansion of the envelope and a
partial-fraction identity. The module takes a shorter road. With `c` the
half-angle cosine, `P^m` is `c` to the power `2m`, and the second
derivative of `c^n` is `n(n−1)θ²·c^{n−2} − n²θ²·c^n` with `θ` equal to
`π` over `half_denom` 2. Integrating that against `e^{wx}` and integrating
by parts twice, with every boundary term zero because `c` and the first
derivative of `c^n` vanish at the ends, gives the transform of `c^n` times
`w²`. So the transform at `m` is a rational multiple of the transform at
`m − 1`.

The statements. `K_succ`: `K (m+1) w` times `w² + π²(m+1)²` equals
`(m+1)(2m+1)π²/2` times `K m w`. `K_mul_Q`: `K m w` times
`w·∏(w² + π²j²)` over `j` from 1 to `m` equals `2·π^{2m}·(2m)!/4^m` times
`sinh w`, by induction from `K 0 w · w = 2 sinh w`. Both are multiplied
out, so they hold at every `w`, the poles included, and no division ever
enters. `K_one_mul`: at `m` equal `m_check` 1 the product identity reads
`π²·sinh w` over `w(w² + π²)`, unit 0328's hand check, now a theorem.

What this closes. The transform of the new envelope is known exactly at
every order. The decay in height that unit 0328 measured as minus four m
plus two for the transform squared is now readable off the degree of the
product, `2m + 1` in `w`.

What the next slices need from it. An upper bound on the norm of `K m w`
through `cosh(Re w)` over the product, and a lower bound at real `w`, in
the regime where the product behaves like a Gaussian in `w`. Then the
window's own transform, the odd one with the factor `x`, which is the
`w`-derivative of `K`.
