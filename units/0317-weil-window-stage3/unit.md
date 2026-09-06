---
id: 0317
date: 2026-09-06
type: formalization
title: WeilWindow.lean: the raised-cosine window, its second moment bounded, and the odd envelope bounded below
refs: [lean_stage3/Stage3/WeilWindow.lean::m2_ge, lean_stage3/Stage3/WeilWindow.lean::m2_le, lean_stage3/Stage3/WeilWindow.lean::Sigma_ge]
supersedes: []
follows: 0308
sealed: false
---

**Question.** Unit 0316 stated the detection lemma and left it open. Its
proof needs the off-line term `2|B|²` of entry 302's window bounded BELOW,
which needs the window's second moment `m₂` and the odd-envelope integral
`Σ(s)` bounded below. Can those two bounds be proved in Stage 3 with crude
constants, without the series entry 302 used?

**What ran.** `lean_stage3/Stage3/WeilWindow.lean`, new, `module_lines` 171
lines, imported from `Stage3.lean`. First compile: `errors_first` 6 errors (an
argument shape on the interval-inclusion lemma, `fun_prop` unable to see
through the window's definition, and a renamed case-split lemma); after the
fixes the module built and the full package built, `jobs_package` 8738 jobs.
`run/build.log` is the record.

**What it shows.** `theorems_proved` 12 theorems, each pinned by
`#guard_msgs` to `axioms` 3 axioms, `sorries` 0 sorries, over `defs` 3
definitions (`P`, `m2`, `Sigma`).

The window `P(x) = cos²(πx/2)` is nonnegative, at most `p_max` 1, vanishes
at both ends, and is at least `1/2` on `|x| ≤ 1/2` (`P_ge_half`, from
`cos(πx/2) ≥ cos(π/4) = √2/2` there).

The second moment `m₂ = ∫₋₁¹ x²·P(x) dx` satisfies `m2_lower` 1/24 ≤ m₂ ≤ `m2_upper` 2/3.
The lower bound uses the middle half alone: `∫₋½^½ x²/2 = 1/24`. The true
value is `m2_true` 0.130691 (entry 302, `1/3 − 2/π²`). Crude is the spec: the
ladder's consumer is a lower bound and `1/24` is one.

The odd envelope `Σ(s) = ∫₋₁¹ x·P(x)·sinh(s x) dx` satisfies `Σ(s) ≥ s·m₂`
for every `s ≥ 0` (`Sigma_ge_mul`), hence `Σ(s) ≥ s/24` (`Sigma_ge`). The one
idea is `mul_sinh_ge`: `x·sinh(s x) ≥ s·x²` for every real `x` when `s ≥ 0`,
because `sinh` lies above its argument on the right and below it on the
left and the factor `x` flips the sign back. No series and no small-`s`
hypothesis; entry 302's `s³` term is a gain the bound does not need.

What this buys the detection lemma: to first order `|B| = (N h/2)·Σ(ε h)`,
so `|B| ≥ (N h/2)·ε h/24` with a proof behind it. Next rung: the transform
of the tuned window `G(u) = N·(u/h)·P(u/h)·cos(γu)` in closed form, then
the on-line background bounded above through the window's decay and
`JensenCount.zeta_local_zero_count`.
