---
id: 0477
date: 2026-11-23
type: formalization
title: "The spiral link stated: the walk closes only at rest, and there is one zero at each height"
refs: [lean_stage3/Stage3/SpiralLink.lean::mirrorZ_eq_iff, lean_stage3/Stage3/SpiralLink.lean::off_line_is_two, lean_stage3/Stage3/SpiralLink.lean::rh_iff_spiralLink, lean_stage3/Stage3/SpiralLink.lean::rh_iff_one_at_each_height, lean_stage3/Stage3/SpiralLink.lean::spiralLink_iff_one]
supersedes: []
follows: 0476
context: unit 0476 joined the closed loop's restoring force and handshake to the tree's mirror; Julian's paper gives, in its section on the phasor mechanism, the sentence that the spiral can only converge at one half, and Julian holds that there is just one zero; neither had a Lean statement on the zeros
sealed: false
---

**Question.** Block J2 of `lean_stage3/design/closedloop.md`. What is the sentence that the spiral can only converge at one half, as a Lean statement about the zeros of zeta, and how does it stand to the statement that there is one zero?

**What was proved.** `lean_stage3/Stage3/SpiralLink.lean`: `module_lines` 170 lines, `theorems_proved` 9 theorems, `defs` 3 definitions, `sorries` 0 sorries, `pins` 5 axiom pins. The first build had `errors_first` 1 error lines; clean on build `builds` 2. The package builds at `jobs_package` 8863 jobs, the module at `jobs_module` 8761. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`SpiralLink`: the Hermitian handshake of the closed loop holds at every nontrivial zero of zeta. It is the Lean form of the paper's sentence that the spiral can only converge at one half: the walk closing is a zero, and it closes only where the loop is at rest.

`OneAtEachHeight`: no two nontrivial zeros have the same height. It is the Lean form of Julian's statement that there is just one zero.

`mirrorZ`: the mirror of a zero, the unit less its conjugate, is again a zero. `mirrorZ_im`, `mirrorZ_re`: it is at the same height, with the real part reflected in one half. `mirrorZ_eq_iff`: a zero is its own mirror exactly when its real part is one half. `mirror_pair_area`: at any base the sizes of a zero's mode and of its mirror's mode multiply to the base, so the pair keeps pace however the two differ.

`off_line_is_two`: a nontrivial zero off the line has a mirror that is a different zero at the same height, and the handshake fails at both.

`rh_iff_spiralLink`, `rh_iff_one_at_each_height`, `spiralLink_iff_one`: the Riemann hypothesis, the spiral link, and one zero at each height are the same statement.

How. That the mirror of a zero is a zero is the functional equation at the conjugate. A zero off the line and its mirror have the same height and different real parts, so they are two; on the line the mirror is the zero itself. The rest is unit `unit_join` 476.

**Who wrote it.** Written and built here, in one sitting. The file was searched for `sorry`, added axioms and `native_decide`, of which it has none, and each pin reads the standard three axioms.

**What it says.** The `statements` 2 statements Julian has made in words, that the spiral converges only at one half and that there is one zero, are now Lean propositions about the zeros of zeta, and they are proved to be one proposition. The mirror is what ties them: off the glass a zero and its reflection are two things at one height; on the glass they are one. An off-line zero cannot be alone.

What remains. Neither proposition is proved. Each is the Riemann hypothesis in these terms. The paper's reason for it, that the integers force the offset of one half at every doubling, is a theorem about the doublings in Julian's file and is not yet an argument in Lean that reaches the zeros. That is the link the map marks.
