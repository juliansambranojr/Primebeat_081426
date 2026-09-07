# The module loop

version: 12

One Stage-3 module, from design to commit. Every step is a command or a
file. An instance that has never seen this repo follows it top to bottom.
The recipe is versioned; a unit built under it records `loop_version` in
its `values.tsv`, and `utilities/check_lean_unit.py` refuses a unit whose
version does not match the line above.

## 0. Orient

From inside the repo, bare, nothing piped after it:

```sh
python3 ~/.claude/hooks/orient_gate.py --orient
```

Re-run it whenever the working directory has moved into
`lean_stage3/.lake/packages/mathlib`: the gate refuses Bash from there.

## 0b. Pin the task

Before any work on a task above trivial, write its four pins in
`PINS.md` at the repo root (DONE, ASSUMED, DEPENDS, OUT), silently. When
the work looks lazy, the pins are read before anything is said; a wrong
pin goes into the misreads table there.

## 1. Freeze the design: the worksheet, then the header

The derivation lives in a file, never only in the session. Each rung has
a worksheet, `lean_stage3/design/<rung>.md`, with one section per piece
of analysis, each marked PROVED (names the Lean theorem) or SKETCH (the
numbers and the plan). Do the analysis there first: the quantities and
their sizes, the regime conditions, the constants, the comparison, the
open questions. Append as you go. Re-read it instead of re-deriving. A
compaction loses nothing in it, and a fresh instance starts from it.

The worksheet block is the orchestrator's and is written before the run
in the shape `DESIGN.md` § 1 gives (Objects, Sizes, Regime, Theorems,
Composes, Module, Open). Then write the module's header comment before any
proof. Its theorem list is copied from the block's Theorems lines, with
their hypotheses; a hypothesis the proof needs that the block does not
list is an ASSUMED pin and a line in the report, never a silent addition.
A size that does not close is the orchestrator's decision: stop and
report. The header cites the block and ends with what the next slice
needs. The header is the
contract; the unit's prose paraphrases it. Name the pinned theorems now:
the `#guard_msgs in #print axioms` lines are fixed targets.

When the analysis changes the route, it is also a decision unit
(`python3 -m lab new <slug> --type decision`), which carries the quote
gate and the values rows. The worksheet is the scratch; the unit is the
record. A numerical probe takes its predictions from the worksheet,
written before the run.

The unit's `values.tsv` names its section: `design	<rung>.md#<n>`, the
section number (`rung5.md#7`); a slug of the heading in lower case with
dashes also resolves, and so does a lettered sub-block of a section
(`rung5.md#13c` for `### 13c`, unit 0348). The checker refuses a unit without it or with a
section that does not exist. When the module lands, the section's mark
changes from SKETCH to PROVED naming the theorem, in the same commit.

## 2. Verify every name before writing

One batched grep for every Mathlib lemma the file will use:

```sh
M=lean_stage3/.lake/packages/mathlib/Mathlib
grep -rn 'theorem NAME1\b\|theorem NAME2\b' $M --include='*.lean' | sed "s|$M/||" | head
```

By full path from the repo root, with no `cd`: the orient gate reads the
whole command text and refuses one that mentions the library path beside a
write anywhere in the tree (`TRAPS.md` B11); a command that only greps
passes. A name made by `@[to_additive]` (`sum_*` from `prod_*`,
`Tendsto.sub` from `Tendsto.div`) has no `theorem` line of its own; grep
the multiplicative name.

A guessed name is an error on the first build, every time. Names that
resolve on this toolchain are listed in `TRAPS.md` § Names.

When the statements carry coercions — `(z / (π:ℂ)^2).re`, `((u m : ℝ) : ℂ)`,
`‖(r : ℝ) : ℂ‖` — one scratch pass comes before the module is written, not
after the build: put each cast identity and each name-resolution one-liner
in `Stage3/Scratch.lean` as an `example` and run it with the § 4 command,
seconds per pass and no package rebuild. Unit 0349 ran two such passes and
every cast in the module then compiled on the first build; what remained
was a renamed lemma and a `ring` after `field_simp`. Delete the file before
the commit.

## 3. Parameterize downstream, copy upstream

Anything downstream of the window takes the term as a parameter: a band,
tile or series module is stated for `term : ℂ → ℝ` with the nonnegativity
and the bounds as hypotheses, never for one window's test function.
Units 0321–0324 were stated for one window and had to be copied in full
when the window changed (units 0334–0335, six hundred lines).

When a module does repeat an old one, read the old module in full
(`Read`, the whole file) and copy each proof with the names changed.
Copied modules build with zero errors.

## 4. Build, classify, fix

```sh
cd lean_stage3 && lake build Stage3.<Module> 2>&1 \
  | grep -v 'Replayed\|push_cast.*nothing\|linter\|^$\|^trace' \
  | grep -B2 -A25 'error\|Built Stage3.<Module>'
```

Classify every error against `TRAPS.md` before fixing any. Most fall
into a row there. After a `field_simp`, write `try ring`, never a bare
`ring`: whether `field_simp` closes the goal depends on the denominators
it clears, and a bare `ring` on a goal already closed is `TRAPS.md` row 1,
costing one error plus one more for every pin downstream (unit 0348's
whole first build was that, in one of five `field_simp`s). A `linear_combination` residual is read, never
recomputed. For one stubborn lemma, iterate in a scratch file at seconds
per try:

```sh
lake env lean Stage3/Scratch.lean      # delete the file before the commit
```

Record the first-build error count; it goes in `values.tsv` as
`errors_first`. It is the count of lines matching
`error: Stage3/<Module>.lean:<line>:<col>:`, so the two lines lake ends
with (`Lean exited with code 1`, `build failed`) are outside it and the
`#guard_msgs` pins that failed only because an earlier proof did are
inside it: a failed proof costs its own error and one more for every pin
that reads it (`TRAPS.md` row 19). Warnings are not errors and the § 4
filter does not remove them; an unused binder in a statement is
`TRAPS.md` row 20 and is fixed before the counts are taken.

## 5. Import, full build, counts, log

Counts come after the last edit to the module, never from memory:

```sh
cd lean_stage3
sed -i '' 's/^import Stage3.<Previous>$/import Stage3.<Previous>\nimport Stage3.<Module>/' Stage3.lean
lake build 2>&1 | grep 'error\|completed'
wc -l Stage3/<Module>.lean
grep -c '^theorem' Stage3/<Module>.lean
grep -c '^def' Stage3/<Module>.lean
```

Then the unit:

```sh
cd <repo>
python3 -m lab new <slug> --type formalization --title "<Module>.lean: <one line>"
rm -f units/<unit>/run/.gitkeep
(cd lean_stage3 && lake build Stage3.<Module> 2>&1) > units/<unit>/run/build.log
```

Outputs never go under `results/` or `analysis/**/results/`; the gate
refuses them. The unit's `run/` is the place.

## 6. The unit

Six files: three written (`question.md`, `unit.md`, `values.tsv`), two
left by the build (`run/run.sh`, `run/build.log`), one written by
`check_prose_source.py` below (`sources.log`). `run/run.sh` is hand-written:
three lines, `cd` to `lean_stage3` and the `lake build Stage3.<Module>`
command whose output is `run/build.log` (copy unit 0341's and change the
module name); `lab new` does not write it. `question.md` quotes the transcript
verbatim and carries the statements as fenced blocks copied from the
module; no boilerplate lines. Digits inside inline code spans are
formula and are not checked; the measured digit sits outside the span,
beside its backticked key. `values.tsv` has one row per number in the prose, including unit
ids and numbers inside inline math, the row `loop_version`, and the row
`design` naming the worksheet section. `unit.md`
paraphrases the header, keys every number beside its backticked key, and
ends with a paragraph beginning `What the next slice` or `What remains`:
that paragraph is the next module's question.

```sh
python3 utilities/check_prose_source.py units/<unit>
python3 -m lab check units/<unit>
python3 utilities/check_lean_unit.py units/<unit>
git add lean_stage3/Stage3/<Module>.lean lean_stage3/Stage3.lean units/<unit>
git commit -q -m "<Module>.lean: <what>; unit <id> logged"
```

The pre-commit runs `check_lean_unit.py` on every staged unit whose
`values.tsv` carries `loop_version` (its step 9). Edits to
`utilities/hooks/` need Julian's one-use approve flag, created from the
repo root:

```sh
touch .approve/pre-commit
```

Steps that do not depend on each other run in one call: the scaffold
while the build runs, the two files that need no counts before the counts
arrive, both checkers together, the commit with the memory edit.

## 7. Retrospective: one edit to the recipe

After the commit, one step, every time:

- Classify each first-build error. A class with no row in `TRAPS.md` gets
  one: pattern, cause, fix.
- A step that was reordered, batched, or skipped without loss gets the
  checklist edited.
- Any recipe edit bumps `version:` above and is committed with the unit
  that caused it. The next units record the new `loop_version`. The
  checker accepts a unit whose `loop_version` is at or below the line
  above: a unit records the recipe it was built under (unit 0340).
- Keep an edit when `errors_first` and the minutes per module trend down
  over the following units; revert it when they do not. The evaluation is
  fixed: the build passes with the pin, both checkers pass, the counts
  match. The recipe is what moves.

The learning curve is already in the bench: `errors_first` across the
units, in order. Read it before editing the recipe.
