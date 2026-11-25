---
id: 0567
date: 2026-11-25
type: formalization
title: "diag-long"
refs: [lean_stage3/Stage3/DiagLong.lean::diag_split, lean_stage3/Stage3/DiagLong.lean::short_part, lean_stage3/Stage3/DiagLong.lean::stmtDiagTail_of_le, lean_stage3/Stage3/DiagLong.lean::stmtDiagErr_of_tail, lean_stage3/Stage3/DiagLong.lean::tail_of_stmtDiagErr, lean_stage3/Stage3/DiagLong.lean::stmtDiagErr_holds]
supersedes: []
follows: 0566
context: block S13 of `lean_stage3/design/stencil.md`, its B3 round, took the diagonal at lengths of one half and more for bookkeeping; this tried it and found what it needs
sealed: false
---

**Question.** Block S13 of `lean_stage3/design/stencil.md`, the diagonal at any length. Does the diagonal's shifted integral stay below the height over its logarithm for mollifiers of length one half and more?

**What was proved.** `lean_stage3/Stage3/DiagLong.lean`: `module_lines` 756 lines, `theorems_proved` 22 theorems, `defs` 8 definitions, `sorries` 0 sorries, `pins` 6 axiom pins. The first build had `errors_first` 1 error lines; clean on build `builds` 4. The package builds at `jobs_package` 8993 jobs, the module at `jobs_module` 8837. Traps added, `traps_added` 1; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`diag_split`: the diagonal written as its residue plus two shifted integrals, the pairs of reduced indices with product at most a cut and those above it. `short_part`: the short pairs, cut at the height to a power below one, at most a constant times the height over its logarithm for every length. `stmtDiagTail_of_le`: below one half there are no long pairs. `stmtDiagErr_of_tail` and `tail_of_stmtDiagErr`: the diagonal's error statement of unit 0553 equivalent to one statement about the long pairs, `StmtDiagTail`, at every length. `stmtDiagErr_holds`: the error statement below one half.

**The finding.** Moving the contour, in the shift alone or with Young's two Mellin variables as in his section six, costs the height to the power of the shift times twice the length less one, which is at least one from one half on; Young's own route stops at one half, read against his text. The long pairs need the cancellation of the Moebius function in tails with a rate, a power of the logarithm, uniformly over the coprimality modulus: the prime number theorem for the Moebius function with a classical error term. The worker's numeric check, saved in `lean_stage3/checks/diaglong/`, fits that cancellation and proves nothing. The dependency proves the prime number theorem with such an error for the Chebyshev function and not yet for the Moebius function.

**Who wrote it.** One worker. The file was searched here for `sorry`, added axioms and `native_decide`, of which it has none, the package was rebuilt here, and each pin reads the standard axioms. Trap: TRAPS.md row `trap_row` 132.

What remains. The prime number theorem for the Moebius function with a rate, then the long pairs from it.
