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

### 2026-09-07 · rung 5, the averaging route after unit 0351

    DONE        StmtDetect ε T L proved with L explicit and polynomial,
                conditional on a short-interval zero count leaf; the route
                is section 13, blocks 13c-13g proved (units 0348-0354),
                13h the clean shell, 13i the leaf, then the assembly
    ASSUMED     λ free and polynomial in the range (13e), never 1; the
                member split is helping (13g), bounded (13f), blocked
                (13h); crude-explicit constants; one unit per module; the
                builder lays the module and the foreman closes what one
                try does not, LOOP.md § 4b
    DEPENDS     nothing from Julian until a design choice changes the
                route, which becomes a decision unit first
    OUT         section 9's alignment (dead, unit 0345); sharp constants
                beyond the one leaf; the old-window modules; porting

### 2026-09-07 · block 13h, WeilPowerClean, under the relay at loop v16

    DONE        the four pinned theorems of rung5.md#13h built and committed
                with unit 0357: a member blocks at most W+1 consecutive
                shells, and more shells than the count leaves one clean
    ASSUMED     the window ratio hi/lo is an absolute constant, so W is
                one; the block corrects unit 0351's 1.23 to c₁·ln(hi/lo) < 1
                and the leaf it names is unchanged; the module is pure
                combinatorics and imports no rung module
    DEPENDS     nothing from Julian; 0351's finding stands as corrected here
    OUT         instantiating B from 13f and 13g (that is 13i); the leaf's
                own proof; the assembly; any second attempt by the builder

## Archive

### 2026-09-07 · block 13g, WeilPowerNear, under the relay at loop v16

    DONE        the four pinned theorems of rung5.md#13g built and committed
                with unit 0354: the near members' terms are nonnegative at
                every h in the range, so their sum helps the target
    ASSUMED     the crude sign condition N2 (sin θ ≤ θ, cos θ ≥ 1 − 2θ/π)
                is the one the assembly will use; the Lean statements in
                the block are copied, so no shape reading is needed; the run
                measures a 13e-sized block under the relay and v16
    DEPENDS     nothing from Julian; 0351 stands
    OUT         the shell between 13g's boundary and 13f's; the tight count;
                the assembly; any second attempt by the builder
    OUTCOME     PROVED, unit 0354, commit with the module; one sorry at the
                first stop (bracket_nonneg, linarith's atoms), closed by the
                foreman in two edits, two builds; builder 104519 + 9960
                tokens, 34 calls; the block's Lean statements were copied,
                no shape reading


### 2026-09-06 · block 13f, WeilPowerShell, under the relay

    DONE        the four pinned theorems of rung5.md#13f built and committed
                with unit 0352; Opus lays the module and stops at the first
                build, I finish the sorrys, Opus resumes for counts and the
                unit scaffold, I write the prose and commit
    ASSUMED     13e's G7 at k = 0 is the only gap in composing
                norm_sum_exp_u_le_gen, closed by uSh; the relay's two
                reports carry errors_first and the counts; the run is the
                measure of the relay against runs 13c–13e
                — builder's run, 2026-09-06: no hypothesis outside the
                block's per-theorem lists was needed; three readings of
                the block's shapes were taken: uSh_bracket keeps the
                block's `∀ k` inside the statement so it is
                norm_sum_exp_u_le_gen's `hu` after one `ring` step on the
                affine form `α·k + β₀`; norm_zOf_c_le takes the block's
                `∀ a : ℕ` as an explicit argument; shellSum_le_abs reads
                "the bound with |Δ| in place of Δ" as the substitution at
                every occurrence, |Δ|² included, the same real number as
                substituting only in 4ε'Δ since |Δ|² = Δ²
    DEPENDS     nothing from Julian; the finding of unit 0351 stands and
                this block is the far-member bound any variant needs
    OUT         the shell below Δ ≈ λ/(εX); the tight count leaf; the
                assembly; any second attempt by the builder on a proof
    OUTCOME     PROVED, unit 0352, commit with the module; one sorry at the
                first stop, closed by the foreman in one edit; builder
                164440 + 13164 tokens, 47 calls, against 13e's 138681 / 40


### 2026-09-06 · block 13e, the geometric bound with a free slope and uLam (Opus run)

    DONE        WeilPowerGeomGen.lean committed by the agent with its unit:
                13d restated with slope, intercept and correction scale free,
                and the bracket for uLam λ h = h²σ(λh−1) at general λ
    ASSUMED     λ is a positive integer and m + 1 = λh; the special case
                α = 1/π², β₀ = ½/π², c = 1/(4π²) is 13d and need not be
                re-derived; the casts around λh − 1 are the executor's;
                sin_im_ge_gen takes G1 as well as G2 and G3, the block's
                Theorems line naming only the latter two, G1 being in its
                own Regime list (unit 0350)
    DEPENDS     nothing
    OUT         the shell reading (13f); the error term q at the shell
    OUTCOME     built by the agent: WeilPowerGeomGen.lean, unit 0350, commit
                947ac9b, 11 minutes, errors_first 1, one ASSUMED pin (G1
                uncited on one theorem line, DESIGN.md v5); LOOP.md v13 by
                the agent

### 2026-09-06 · block 13d, the geometric sum and the harmonic correction (Opus run)

    DONE        WeilPowerGeom.lean committed by the agent with its unit: the
                geometric sum bounded independently of the range length, the
                correction sum bounded by a logarithm
    ASSUMED     u is an abstract sequence with 13c's bracket as hypothesis
                R6, so the module does not import WeilPowerSigma; Jordan's
                inequality is Mathlib's Real.mul_le_sin; geom_sum_Ico is
                absent on this Mathlib and the block says so
    DEPENDS     nothing
    OUT         reading z and Mab at the shell (13e); the on-line and
                suppressed sums with the same weights (13e/f)
    OUTCOME     built by the agent: WeilPowerGeom.lean, unit 0349, commit
                13979b4, 14 minutes, errors_first 5 from three roots, no
                ASSUMED pin; the ASSUMED line on geom_sum_Ico was wrong
                (misreads table); LOOP.md v12 by the agent

### 2026-09-06 · block 13c, the tail sum to order 1/h (Opus run under DESIGN.md v1)

    DONE        WeilPowerSigma.lean committed by the agent with its unit;
                σ(m) bracketed to order 1/m² and u(m) = (m+1)²σ(m) within
                [1/(2π²(m+2)²), 1/(π²(4m+6))] of (m+½)/π²
    ASSUMED     λ = 1 so h = m+1 and the block is stated in m alone; the
                two telescoping inequalities are elementary and the block's
                arithmetic was checked in the block; no pre-registration
                unit per run, the agent's unit is the record
    DEPENDS     nothing
    OUT         the geometric sum and the harmonic bound (13d); the
                Re(w²) ≤ 0 sharp exponent
    OUTCOME     built by the agent: WeilPowerSigma.lean, unit 0348, commit
                7539dae, 12 minutes, errors_first 3 from one root, no
                ASSUMED pin; the two r bounds are equalities against the
                brackets; block gaps: u listed as a theorem, two lemmas
                hidden in "via" clauses (DESIGN.md v2)

### 2026-09-06 · section 13 (b), the phase module (unit 0347) — pins written AFTER the work

    DONE        WeilPowerPhase.lean committed with unit 0347: the tail product
                split into principal part and error, S within 2q of c·w·P,
                Re S² bounded below in closed form
    ASSUMED     the principal part is exp(w²σ) with σ the full tail tsum,
                bracketed rather than evaluated; the regime hypothesis q ≤ 1
                is carried as a hypothesis, traced to h and λ later
    DEPENDS     nothing
    OUT         requirement (c) onward; the neg-case sharp exponent
    OUTCOME     built; step 0b was skipped and these lines were written
                after the commit, which is the misread below

### 2026-09-06 · the orchestrator runs the loop: section 9 design, then one module

    DONE        a decision unit that prices section 9 as sketched and names the
                route change, the worksheet updated, and one module committed
                under LOOP.md v8 with its unit; the run's own errors_first,
                minutes and refusals recorded for comparison with units 0340
                and 0343
    ASSUMED     the module is whatever the decision unit says every route
                needs first; the comparison measures are read the same way
                as for the agents (git log for minutes, values.tsv for
                errors_first); the loop's text is followed literally, and
                each place it fails me is named in the retrospective
    DEPENDS     nothing from Julian; a route change becomes a decision unit,
                which this run makes
    OUT         the remaining sections after this module; any agent spawn
                during the run
    OUTCOME     built: unit 0345 (section 9 dies on size, section 13), then
                WeilPowerSharp.lean, unit 0346; errors_first 4, two root
                causes; two bench traps hit (B10, B11), LOOP.md v9

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
| 2026-09-06 | section 13 (b) (unit 0347) | (none written) | step 0b skipped: the orchestrator went from the worksheet to the module | pins are written before the module, every run; the checker cannot see this, the retrospective can |
| 2026-09-06 | block 13d (unit 0349) | ASSUMED | `geom_sum_Ico` is absent on this Mathlib | it is present as a `lemma`; the checklist grep matched `theorem` only; DESIGN.md v3 fixes the pattern |
| 2026-09-06 | blocks 13c–13d | ASSUMED | λ = 1, silently in 13c ("With λ = 1") and by inheritance in 13d | the shell forces λ³ ~ N e^{K'} H/ε², so λ is free; 13e restates 13d parameterized (LOOP § 3, DESIGN.md v4) |
