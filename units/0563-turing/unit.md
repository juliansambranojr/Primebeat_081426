---
id: 0563
date: 2026-11-25
type: formalization
title: "turing"
refs: [lean_stage3/Stage3/TuringCert.lean::defect_mono, lean_stage3/Stage3/TuringCert.lean::count_le_N_sub, lean_stage3/Stage3/TuringCert.lean::defect_zero_of_signs]
supersedes: []
follows: 0562
context: block S14 of `lean_stage3/design/stencil.md` records Turing's method as a verification of each finite range; this builds its analytic half
sealed: false
---

**Question.** Block S14 of `lean_stage3/design/stencil.md`, Turing's method. Given sign changes of the completed zeta on the line below and above a height, and Littlewood's bound on the integral of the argument's remainder, is the defect zero up to that height?

**What was proved.** `lean_stage3/Stage3/TuringCert.lean`: `module_lines` 344 lines, `theorems_proved` 7 theorems, `defs` 3 definitions, `sorries` 0 sorries, `pins` 3 axiom pins. The first build had `errors_first` 0 error lines; clean on build `builds` 5. The package builds at `jobs_package` 8986 jobs, the module at `jobs_module` 8871. Traps added, `traps_added` 2; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`TuringS.lean`: the argument's remainder and its integral; the crude bound, whose factor of the interval's length gives back only the pointwise bound; the upper side of the horizontal integral; and `littlewood_of_pieces`, Littlewood's bound from three named pieces: the imaginary part of the integrated argument principle, the oscillation on the line of real part two, and a lower bound on the horizontal integral of the logarithm of zeta. `TuringAvg.lean`: `S_le_of_count` and `turing_S_le`, Turing's lemma, the remainder at a height at most the averaged integral over a window less the counted zeros, plus the horizon's turning. `defect_mono` and `count_le_N_sub`: the defect does not decrease, and counted sign changes bound the zero count's growth. `defect_zero_of_signs`: from sign changes of the completed zeta on the line below and above a height, Littlewood's bound and a numerical inequality, the defect is zero at every height up to it; the defect's evenness lets a bound below two force zero.

What remains. Littlewood's bound, through its three pieces, the lower horizontal bound the largest; and the sign data, which needs a rigorous evaluation of the completed zeta on the line.

**Who wrote it.** One worker, `files` 4 files. The files were searched here for `sorry`, added axioms and `native_decide`, of which they have none, the package was rebuilt here, and each pin reads the standard axioms. Traps: TRAPS.md rows `trap_first` 119 to `trap_last` 120.
