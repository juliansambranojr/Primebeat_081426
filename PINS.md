# Pins

What a theorem's `#print axioms` does for a proof, this file does for a
task: it certifies what the deliverable rests on. Four lines per task,
written silently by the model when the task starts, before any work, and
read by Julian when something looks lazy. Unit 0339.

    DONE        one line: what the deliverable is, so it can be checked
    ASSUMED     ambiguities resolved the model's way, each as one sentence
    DEPENDS     what the task needs from Julian (a flag, a decision, a file)
    OUT         what the model decided is out of scope, and why

When a task looks lazy, read its pins. One of three things shows: an
ASSUMED line is wrong (misalignment, one line to fix); a DEPENDS line is
unmet (blocked, on a named thing); or DONE was narrower than intended
(scope, at a boundary drawn here). Each wrong pin, once seen, goes into
the misreads table at the end, the way a build error goes into
`lean_stage3/TRAPS.md`.

The current task's pins sit at the top. Earlier tasks move to the archive
below with their outcome.

## Current

### 2026-09-06 · rung 5 from the worksheet, section 7 onward

    DONE        StmtDetect ε T L proved with L explicit, through the modules
                the worksheet lists in §7–§10, each logged and committed
    ASSUMED     the order is §7 comparison, §8 selection, §9 cluster, §10
                assembly, with the test-function (C¹) proof and the tsum
                split taken when the assembly needs them; λ = 1;
                crude-explicit constants throughout; one unit per module
    DEPENDS     nothing from Julian until a design choice changes the
                route, which becomes a decision unit first
    OUT         sharp constants; the old-window modules; porting; anything
                on the prime side beyond the probe already run

## Archive

### 2026-09-06 · rung 5 §7 in Lean: the comparison at another off-line zero

    DONE        one module, `lean_stage3/Stage3/WeilPowerCompare.lean`, and
                its unit, committed through the pre-commit: the Gaussian
                comparison of `‖S m w‖` at an off-line zero `(ε', Δ)` with
                `Re (S m s)` at the target `(ε, 0)`, both read by the same
                window, with the exponent explicit
    ASSUMED     §7's `poly(h, m)` prefactor is the single factor `2m+3`, the
                loss between the upper and the lower Gaussian constant
                (§5's "Prefactor loss between upper and lower bound: one
                factor `2m+3`"), times `‖w‖/s`; the comparison is stated at
                the transform `S`, the window's `what` and the term's square
                being one multiplication away and belonging to the assembly;
                the two sign cases of `Re(w²)` are unified by one exponent
                `Eup` written with `max _ 0`, so the module has one upper
                bound instead of two; §7's second paragraph (the crude far
                regime) is already `WeilPowerBounds.norm_S_le_far` and is
                cited, not restated; `λ` stays a parameter, so the module is
                stated in `m` and `h` and no `m + 1 = λh` is imposed
    DEPENDS     nothing; the worksheet's §7 is the whole input
    OUT         §8 selection, §9 cluster, §10 assembly; sharp constants; any
                edit to §7 of the worksheet itself (a route change would be
                a decision unit first)
    OUTCOME     built: WeilPowerCompare.lean, unit 0341, commit 94febea

### 2026-09-06 · rung 5 §8 in Lean: selection of the target

    DONE        one Lean module (`lean_stage3/Stage3/WeilPowerSelect.lean`) and
                its unit, committed through the pre-commit: the target-selection
                argument of `rung5.md#8` — a monotone-bounded-sequence pigeonhole
                lemma, applied to give an explicit step `k` and height bound, plus
                the trivial "large `Δ`" case that needs no selection at all
    ASSUMED     the "max real part over zeros in the box of height `T+k/2`" is a
                parameter `E : ℕ → ℝ` (monotone, bounded by `1/2`, `0 ≤ E 0`), not
                derived here from an actual finite zero set — the same
                parameterize-downstream choice unit 0341 made for `ε', Δ, ε, h`;
                the "maximum over a finite set" half of the worksheet's "Lean
                shape" note is deferred to whichever later module wires `E` to a
                real zero set (band count or `WeilOnLine.lowSet_finite`'s
                argument, widened); `K'` stays a free positive parameter, as it is
                in the worksheet itself (never given a value there); `ε' ≥ 0`
                (only the symmetric half of zeros, real part at or above the
                line) is assumed alongside the worksheet's `ε' ≤ 1/2`, needed to
                square the inequality; this module does not import
                `Stage3.WeilPowerCompare` — nothing in it is used, so the module
                is stated over bare Mathlib order/real-number lemmas
    DEPENDS     nothing; the worksheet's §8 is the whole input
    OUT         §9 cluster, §10 assembly; wiring `E` to an actual off-line zero
                set; sharp constants; matching the sketch's rough "`+1`" slop
                term literally — the module's own constant is computed and the
                worksheet is corrected to it, not forced to agree with the sketch
    OUTCOME     built and committed: 7 theorems, 1 def, 3 axioms, 0 sorries,
                190 lines, `errors_first` 3, worksheet §8 flipped to PROVED
                (unit 0344) in the same commit; `check_lean_unit.py` refused
                once (DEFS/PIN, TRAPS row B9, new) before passing; `lab check`
                passed on every run
    OUTCOME     built: WeilPowerSelect.lean, unit 0344, commit 0c97dec

### 2026-09-06 · probe: the loop on a Sonnet agent, section 8 (unit 0343)

    DONE        one Sonnet subagent given the Opus agent's prompt with the
                section changed to 8; report and tree measures recorded in
                unit 0343 against predictions written before the spawn,
                with a recurrence count over the seven defects of unit 0340
    ASSUMED     section 8 is the right next section (7 is PROVED); the same
                decision rule with the error band widened to 20 for the
                tier; the orchestrator writes nothing into the module or
                unit; a recurrence is the same defect met again, by text
    DEPENDS     nothing; Julian reads the outcome
    OUT         fixing the agent's module if it fails; a third agent; any
                edit to the loop while the agent runs
    OUTCOME     transferred, fixes held: commit through the gate, no
                restart, errors_first 3, 19 minutes, section 8 PROVED in
                the same commit, none of the seven defects recurred; three
                new ones, one now TRAPS B9, one LOOP.md v8 (run.sh)

### 2026-09-06 · probe: does the loop transfer to a weaker agent (unit 0340)

    DONE        one Opus subagent given only the repo's files and section 7,
                its report and the tree's measures recorded in unit 0340
                against predictions written before the spawn
    ASSUMED     the harness's `opus` option stands for the weaker agent
                Julian named; the orchestrator writes nothing into the
                agent's module or unit; the agent's commits are real
                commits on main; a restart counts against transfer
    DEPENDS     nothing; Julian reads the outcome and decides what the
                loop's next edit is
    OUT         fixing the agent's module if it fails (that would measure
                the orchestrator); a second agent; sharpening the
                predictions after the run
    OUTCOME     transferred: commit landed through the gate, no restart,
                errors_first 5, first commit 14 minutes after the spawn;
                the agent left section 7 marked SKETCH; four loop defects
                named, fixed in LOOP.md v7 and check_lean_unit.py

### 2026-09-06 · the pins file itself

    DONE        this file, the loop pointing at it, one commit
    ASSUMED     one file at the repo root is easier to read than a
                directory; four lines is the whole format; the model writes
                pins without announcing them
    DEPENDS     none
    OUT         a checker for pins (nothing mechanical to check yet)
    OUTCOME     built

## Misreads

Pins that turned out wrong, with what was meant. Appended when Julian
reads the pins and finds the misalignment.

| date | task | pin | what it said | what was meant |
|---|---|---|---|---|
| 2026-09-06 | rung 5 pricing | ASSUMED | a rung costs a person's day | a rung costs 6–25 min of clock; price from the log |
| 2026-09-06 | rung 5 route (unit 0325) | DONE | the isolated case, then a window family | the general case with explicit L; the window had to change |
