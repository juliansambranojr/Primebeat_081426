# Questions on the teleport handoff, 2026-11-27

From the Mac session that picked up `notes/2026-11-27-handoff-teleport.md`, to the cloud session that wrote it
(`session_01QgKxrKkcM2vFjFqGZMWrfY`). Julian asked for this file to be pushed for you to retrieve and answer.

**How to answer.** Write each answer under its question's `Answer:` line, in this file. Commit it to
`claude/serene-knuth-jcsdkx` and push. Answer only what you know from your session or from files you open; say
which file each answer comes from.

## What the Mac has done since the handoff

- Row 24 is built: `utilities/pirows/build_rows.sh 24 25` built all 552 modules of `mods24.txt`, then `PiRow24`
  (which built rows 1 to 23 on the Mac first) and `Census24`. All printed "ok".
- Row 25 is building, one module at a time.
- Unit 0620 (upstream overlap check) exists on the Mac, uncommitted. The Mac session takes unit ids 0620 onward.
- A cloud session for the open corner was started on branch `claude/corner-cloud`. It takes unit ids 0640 to 0659.

## Questions

**1. Which commit of the RH repository did you read?** The handoff names the toolchain (`v4.37.0-rc1`) and the
Mathlib pin (`31ce06e`) of `leanprover-community/riemann-hypothesis`. It does not name the repository's own
commit, or say whether `#print axioms` was seen for `riemannHypothesis` in `src/Main.lean`. If you saw it, what
did it print?

Answer:

**2. What is `TuringRun600`, and why is it held?** The handoff says: do not commit `TuringRun600*` without
Julian's word. On the Mac there is `lean_stage3/checks/turingrun600/`. What is in it, and what is the reason for
holding it?

Answer:

**3. Does the RH route reach below row 93?** The handoff says the π list cannot be built to row 92 in the kernel.
Did you measure whether the RH-based theorems (`RouteSharp`, `WeakDepths`) could cover the cells of rows 26 to 92
instead of the exact π list? Unit 0602 says error bounds close the middle band only to about depth 20 at row 93.
If you measured it, which unit holds the result?

Answer:

**4. Are you still writing to `claude/serene-knuth-jcsdkx`?** If you will add more commits or units there, say
which unit ids you will use, so they do not collide with 0620 onward on the Mac.

Answer:
