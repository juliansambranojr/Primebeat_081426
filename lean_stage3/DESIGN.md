# The design loop

version: 7

What LOOP.md is for the executor, this file is for the orchestrator. One
worksheet block, from the sketch to a briefed agent to a checked unit.
The executor never designs; the orchestrator never proves. Unit 0348.

## 1. The block

Every section or sub-section of `lean_stage3/design/<rung>.md` that an
agent will build is written in this shape before the brief. Placeholders
in angle brackets; delete a line only when it has nothing to say.

    ### <id> <title> — SKETCH | PROVED (unit <NNNN>)
    Objects.   <each quantity, defined, with its size at the working point
                w = (ε' + iΔ)h, s = εh, m + 1 = λh>
    Sizes.     <what beats what and by what factor; the lost-factor check:
                any factor that grows with m or h between an upper and a
                lower bound is named here or the block is not done>
    Regime.    <every hypothesis as a one-line inequality, each named>
    Defs.      <each definition the module introduces, name and body; the
                checker counts `^def` and `^theorem` apart, so a def listed
                as a theorem breaks the unit's counts (unit 0348)>
    Theorems.  <one line each: name — hypotheses by the names above —
                conclusion in symbols. Every lemma the proof will state is a
                line, the telescoping identities included; a "via" clause is
                a lemma without a name and the count will not reconcile. The
                executor copies these into the module header; a hypothesis
                it needs that is not here is a design gap, recorded as an
                ASSUMED pin and reported>
    Composes.  <existing Lean theorems it uses, full names, grepped>
    Module.    <file, namespace, the pinned theorems (three or four)>
    Open.      <the one number that decides the next block, or "none">

## 2. The checklist, before the brief

- [ ] Pins for the block in `PINS.md` § Current (DONE, ASSUMED, DEPENDS, OUT).
- [ ] Every theorem line has its hypotheses; none says "suitable". A sign or
      positivity the proof idea uses is cited on that line even when it is
      already a Regime line (unit 0350: `sin_im_ge_gen` used G1 uncited).
- [ ] Every constant is a number or the name of an existing theorem.
- [ ] Sizes carries the lost-factor check, with the factor named or "none".
- [ ] Every name under Composes exists: one grep, full path, no `cd`, the
      pattern `theorem NAME\b\|lemma NAME\b` (unit 0349: `geom_sum_Ico` is a
      `lemma`; a `theorem`-only grep declared it absent and the block said so).
- [ ] The block's arithmetic was checked once by hand in the block itself,
      not in the session.
- [ ] Every window parameter (`λ`, `h`, `m`) is free in the block unless the
      block says why it is fixed (blocks 13c–13d fixed `λ = 1` silently and
      13e had to restate 13d with the slope free).
- [ ] The brief names one block and one module.
- [ ] A hint on a product of three bounded factors names the factorwise
      chain, never `nlinarith` (unit 0352: the run's one `sorry`; `nlinarith`
      multiplies pairs). A Composes entry is the name that resolves, without a
      `to_additive` aside when the additive name has its own `theorem` line
      (unit 0352: `Finset.sum_congr`).

## 3. The brief

Fixed text; fill the brackets. Nothing else goes in.

    You are working in /Users/juliansambrano/GitHub/Primebeat_081426, a git
    repository on branch main. Build one Lean module under the repo's module
    loop: block <id> of lean_stage3/design/<rung>.md, module
    lean_stage3/Stage3/<Module>.lean, and commit it through the pre-commit
    gate with its unit.

    Read, in this order and nothing else first: lean_stage3/LOOP.md,
    lean_stage3/TRAPS.md, the block <id> of lean_stage3/design/<rung>.md
    (the section heading and its lines, not the whole file), PINS.md
    § Current, and the modules named under the block's Composes line. Then
    follow LOOP.md top to bottom, including the retrospective. LOOP.md and
    TRAPS.md are yours: a recipe edit or a new trap row is committed with
    the unit.

    Nobody is available to answer questions. A hypothesis the block does
    not list is recorded as an ASSUMED pin and named in the report. A size
    that does not close is a design failure: stop, say where, and report.
    Touch nothing outside what the loop names.

    Report in plain text: module and commit hash; errors_first with its
    root causes; checker runs before both passed; pre-commit refusals;
    TRAPS rows hit and rows added; every ASSUMED pin; every place the
    block or the loop was unclear or wrong.

The agent tier is Opus until a run says otherwise.

Relay variant (LOOP.md § 4b, from unit 0352): the first paragraph of the
brief ends with "under the relay of LOOP.md § 4b: stop after the first
build with the report it names and wait for the signal; a proof that does
not close on one try is a `sorry` with its goal in a comment, never a
second attempt." The report paragraph is replaced by § 4b's two reports.
The agent is spawned in the foreground and resumed with SendMessage, so
its context survives between the two passes.

## 3b. The foreman's pass

Between the builder's two reports the orchestrator opens the module,
replaces each `sorry` from the block's proof idea, builds with the § 4
command until clean, and signals. Then writes `unit.md` and `question.md`
(LOOP.md § 6), runs `check_prose_source.py`, `lab check` and
`check_lean_unit.py` in one call, commits in a separate call, and does the
retrospective from the two reports. The block's prose is the foreman's,
the counts are the builder's: never retype a count the builder reported;
read it from `values.tsv`.

## 4. The check, after the run

Read from the tree, never from the report: the commit is on `main`;
`check_lean_unit.py` passes on the agent's unit; the module is imported
and the package builds; the block's mark is PROVED naming the theorems;
`errors_first` and the ASSUMED pins are read from the unit and `PINS.md`.
Each ASSUMED pin is a line the block should have had: the block is edited
for the next run, and § 2 gains a line if the gap was structural. Report
to Julian: what was proved, the measures, and the next block.

## 5. Retrospective

One edit here per run, from the agent's report: what the block did not
say, what the brief made the agent read that it did not need. Bump
`version:`; commit with the block's PROVED mark.
