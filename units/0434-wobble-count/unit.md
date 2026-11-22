---
id: 0434
date: 2026-11-22
type: formalization
title: "WobbleCount.lean: a wobble is invisible to the integer count exactly when it sits at a zero"
refs: [lean_stage3/Stage3/WobbleCount.lean::invisible_iff, lean_stage3/Stage3/WobbleCount.lean::count_identity, lean_stage3/Stage3/WobbleCount.lean::wobbleSum_expansion]
supersedes: []
follows: 0433
context: Julian asked, 2026-11-22, why the number line needs the zeros of zeta at all, with no mention of Euler or Riemann in the question; the answer given in the session was that the zeros are the wobbles the prime count can carry while the integers stay evenly spaced, and he asked for it built
sealed: false
---

**Question.** Block W1 of `lean_stage3/design/joints.md`. Stated as counting: which wobbles in the prime count leave the count of the integers undisturbed?

**What was proved.** `lean_stage3/Stage3/WobbleCount.lean`: `module_lines` 190 lines, `theorems_proved` 4 theorems, `defs` 1 definition, `sorries` 0 sorries, `pins` 3 axiom pins at `axioms` 3 axioms. The first build had `errors_first` 4 error lines from one root; clean on build `builds` 2. The package builds at `jobs_package` 8830 jobs, the module at `jobs_module` 8721. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`count_identity`: the logarithms of the integers up to a bound add to the prime content read at the bound, at half of it, at a third of it, and so on. Each integer is built from primes in one way, and this is that fact summed. The left side is as smooth as the integers are evenly spaced.

`wobbleSum`: a wobble, a power of the variable with a complex exponent, read at those same points and added. `wobbleSum_expansion`: it equals zeta at the exponent times the wobble at the bound, plus a smooth term linear in the bound, plus one half, plus a term that stays bounded.

`invisible_iff`: with the smooth term taken off, the sum stays bounded as the bound grows exactly when zeta vanishes at the exponent. The wobble's own size is unbounded, so only a zero of zeta removes it.

**What it says.** The zeros of zeta are the wobbles the prime count can carry while the integers stay evenly spaced. Zeta enters only as the name of the bracket: one, plus the reciprocal of two to the exponent, plus the reciprocal of three to the exponent, and on.

What remains. Nothing here says which real parts those wobbles have. The identity is exact at every bound whatever the zeros do, so it cannot place them.
