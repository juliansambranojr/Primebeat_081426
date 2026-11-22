---
id: 0414
date: 2026-11-22
type: formalization
title: "RealSegment.lean: zeta has no zero on the real segment between zero and one, so the bucket of real nontrivial zeros in the route's constant is zero"
refs: [lean_stage3/Stage3/RealSegment.lean::zeta_real_ne_zero, lean_stage3/Stage3/RealSegment.lean::weightedZeroHeightBucket_eq_zero]
supersedes: []
follows: 0413
context: unit 0413 left four unnamed quantities under the route's constants; the count of zeros on the real segment was the one with a route visible in the packages; Julian said to keep going on the stretch, 2026-11-22
sealed: false
---

**Question.** Block E5 of `lean_stage3/design/joints.md`. Is the bucket `W` of real nontrivial zeros zero, from what the packages already hold?

**What was proved.** `lean_stage3/Stage3/RealSegment.lean`: `module_lines` 139 lines, `theorems_proved` 4 theorems, `defs` 0 definitions, `sorries` 0 sorries, `pins` 2 axiom pins each at `axioms` 3 axioms. The first build had `errors_first` 2 error lines, a destructuring pattern in the last lemma and the pin above it; the analytic steps passed as written. Clean on build `builds` 2. The package builds at `jobs_package` 8798 jobs, the module at `jobs_module` 8709. Traps unchanged, `traps_added` 0; no hypothesis beyond the block's, `assumed_pins` 0. Loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`zeta_real_ne_zero`: zeta does not vanish at any real point strictly between zero and one. Two cases meeting at `split` 1/3. Above it, the upstream strip formula at its first level writes zeta as one half, minus one over one minus the point, plus a term the upstream bound holds to norm at most one; a zero would force the point to be at most one third. At or below it, the functional equation at one minus the point, which lies in the first case; the other factors are a power, a Gamma value and a cosine, none zero there.

`isEmpty_zeroHeight` and `weightedZeroHeightBucket_eq_zero`: the upstream type of nontrivial zeros of height zero is empty, and the weighted bucket that every constant on this route carries as `W` is zero.

**What it settles.** `W` is a number, and the number is zero. Of the quantities under the route's constants that were unnamed, `unnamed_before` 4 before this unit, `unnamed_after` 3 remain. `W` is proved zero but not yet substituted: the route's theorems still carry it by name.

What remains. The count of zeros below height six, the supremum of the logarithmic derivative on the short segment, and the bound on the compact patch. All three ask for zeta to be bounded, above or away from zero, on a bounded region of the plane, and nothing in the packages does that. That is a design question before it is a build.
