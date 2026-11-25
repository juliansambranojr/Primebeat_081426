---
id: 0538
date: 2026-11-25
type: formalization
title: "diagonal-shift"
refs: [lean_stage3/Stage3/Diagonal.lean::diag_reindex, lean_stage3/Stage3/Diagonal.lean::ell_sum, lean_stage3/Stage3/Diagonal.lean::joint_integrable, lean_stage3/Stage3/Diagonal.lean::wVI_swap, lean_stage3/Stage3/Diagonal.lean::inner_hk, lean_stage3/Stage3/Diagonal.lean::diag_per_t, lean_stage3/Stage3/Diagonal.lean::diag_mellin, lean_stage3/Stage3/Diagonal.lean::Ez_differentiable, lean_stage3/Stage3/Diagonal.lean::Hf_local, lean_stage3/Stage3/Diagonal.lean::shift_t, lean_stage3/Stage3/Diagonal.lean::diag_shift, lean_stage3/Stage3/Diagonal.lean::shifted_bound, lean_stage3/Stage3/Diagonal.lean::gcd_sum, lean_stage3/Stage3/Diagonal.lean::SB_young, lean_stage3/Stage3/Diagonal.lean::final_size_diag, lean_stage3/Stage3/Diagonal.lean::diag_young, lean_stage3/Stage3/Diagonal.lean::stmtDiag_of_main]
supersedes: []
follows: 0537
context: unit 0537 closed the off-diagonal of the twisted moment; this proves the diagonal's Mellin form and its shift, and reduces the diagonal to its arithmetic main term, in block S12 of `lean_stage3/design/stencil.md`
sealed: false
---

**Question.** Block S12 of `lean_stage3/design/stencil.md`, the diagonal. Does the diagonal of the twisted moment equal its residue at zero up to the size Levinson's method needs, for every mollifier shorter than the square root of the height?

**What was proved.** `lean_stage3/Stage3/Diagonal.lean`: `module_lines` 1890 lines, `theorems_proved` 70 theorems, `defs` 12 definitions, `sorries` 0 sorries, `pins` 17 axiom pins. The first build had `errors_first` 3 error lines; clean on build `builds` 5. The package builds at `jobs_package` 8914 jobs, the module at `jobs_module` 8814. One trap added, `traps_added` 1; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`diag_reindex`: the diagonal condition hm = kn reindexed through the greatest common divisor. `ell_sum` and `diag_per_t`: the free sum summed to the zeta factor, each swap of sum and integral by absolute convergence. `diag_mellin`: the diagonal as one contour integral on every line right of one tenth. `shift_t` and `diag_shift`: the contour moved to real part minus a quarter, the pole of the zeta factor cancelled exactly by an entire function, the residue at zero the weight's mean times zeta times the mollifier sum at zero. `shifted_bound`, `SB_young` and `diag_young`: the moved integral at most a constant times the height over its logarithm for every length exponent below one half. `stmtDiag_of_main`: the named diagonal statement from one open statement, `StmtDiagMain`, the arithmetic evaluation of zeta times the mollifier sum at zero (Young's Lemma 7).

**Who wrote it.** One worker. The file was searched here for `sorry`, added axioms and `native_decide`, of which it has none, the module and the package were rebuilt here, and each pin reads the standard axioms. One trap was new and is TRAPS.md row 56: `set` on the log of the height rewrote the weight's type and shadowed it.

**The decision on the main term.** The PNT+ Moebius theorem `mu_pnt` gives a sum of Moebius values that is little o of its length, with no rate; it carries the main term up to little o of one and the diagonal up to little o of the height. Levinson's floor needs only the leading term, so the next block restates the main term and the parts built on it with a little o error.

What remains. The main term in its little o form, the swapped term, the operator and the unsmoothing.
