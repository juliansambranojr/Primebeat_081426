---
id: 0544
date: 2026-11-25
type: formalization
title: "arith-lemma3"
refs: [lean_stage3/Stage3/Arith.lean::meanSig3, lean_stage3/Stage3/Arith.lean::divLog, lean_stage3/Stage3/Arith.lean::gmuLog, lean_stage3/Stage3/Arith.lean::sum_sdm_eq, lean_stage3/Stage3/Arith.lean::stmtArith_holds]
supersedes: []
follows: 0543
context: unit 0542 left the diagonal main term on six elementary arithmetic facts; this proves them and composes Young's Lemma 3 with a little o error with no open hypothesis, in block S12 of `lean_stage3/design/stencil.md`
sealed: false
---

**Question.** Block S12 of `lean_stage3/design/stencil.md`, the arithmetic facts. Do the six facts about squarefree numbers and Euler's phi hold with constants free of the mollifier length, so that the main term and Young's Lemma 3 hold with no open hypothesis?

**What was proved.** `lean_stage3/Stage3/Arith.lean`: `module_lines` 274 lines, `theorems_proved` 15 theorems, `defs` 1 definitions, `sorries` 0 sorries, `pins` 5 axiom pins. The first build had `errors_first` 15 error lines; clean on build `builds` 9. The package builds at `jobs_package` 8935 jobs, the module at `jobs_module` 8830. Traps added, `traps_added` 5; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`meanSig3`, `divLog` and `gmuLog`, with `sdmLe`, `tailFixed` and `tailAvg` in `ArithBase.lean` and `ArithTail.lean`: the six facts, through one multiplicative majorant written as a convolution and Mathlib's Euler products over factored and smooth numbers; every constant is free of the mollifier length. `sum_sdm_eq`: the exact bijection from a number to its radical and the rest. `stmtArith_holds`: the six together. `stmtDiagMainO_holds'`: the diagonal main term in little o form for a polynomial vanishing at zero and a length exponent between zero and one half, with no further hypothesis. `Lemma3.lean`, a short composition written here, proves `lemma3_resO_holds`: Young's Lemma 3 up to its remainder, with a little o error, unconditional over the windows bounded to every order.

**Who wrote it.** One worker, `files` 3 files; `Lemma3.lean` written here. The files were searched here for `sorry`, added axioms and `native_decide`, of which they have none, the package was rebuilt here, and the axioms of both endpoints were printed here, the standard ones. Traps: TRAPS.md rows `trap_first` 71 to `trap_last` 75.

What remains. The operator, the unsmoothing and the assembly with the Levinson window.
