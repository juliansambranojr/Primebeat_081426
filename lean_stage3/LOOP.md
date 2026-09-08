# The module loop

version: 21

One Stage-3 module, from block to commit. Commands in order. The checkers
behind them refuse what is skipped (`utilities/check_lean_unit.py`, the
pre-commit). The reason for every line is in the unit it cites; the error
classes are in `TRAPS.md`; the block's shape and the brief are in
`DESIGN.md`. A unit records the version it was built under in
`values.tsv` as `loop_version`. A module may carry declared sorries when
the block itself names them as OPEN and the unit records the count in
`values.tsv` under `sorries` (unit 0368 was the first partial Lean unit
under this rule, block 15 rung5.md#15). The checker compares the grep
count against the declared count and refuses drift.

## 0. Orient

```sh
python3 ~/.claude/hooks/orient_gate.py --orient
```

Bare, nothing piped. Again after any move into `lean_stage3/.lake/packages/mathlib`.

## 0b. Pin

Four lines in `PINS.md` § Current before the work: DONE, ASSUMED, DEPENDS,
OUT. The checker refuses a unit whose module or block is not named in
`PINS.md`.

## 1. Header

The block is `DESIGN.md` § 1, the orchestrator's, written before the run.
Write the module's header comment before any proof: the block's id, the
theorem list with hypotheses copied from the block's Theorems lines, what
the next slice needs. A hypothesis the block does not list is an ASSUMED
pin and a line in the report, never a silent addition. A size that does not
close: stop and report. Name the pinned theorems now. The checker refuses a
header that does not name the block.

## 2. Names and casts

```sh
M=lean_stage3/.lake/packages/mathlib/Mathlib
grep -rn 'theorem NAME1\b\|theorem NAME2\b\|lemma NAME3\b' $M --include='*.lean' | sed "s|$M/||" | head
```

Full path, no `cd` (`TRAPS.md` B11). A `to_additive` name: grep the
multiplicative one. Verified names are in `TRAPS.md` § Names. Then one
scratch pass before the module is written: every cast identity and every
name one-liner as an `example` at the module's own types, never a bare
`#check` (row 37, unit 0365), in `Stage3/Scratch.lean`, run with
`lake env lean Stage3/Scratch.lean` from `lean_stage3`. Delete the file
before the commit; the checker refuses a tree that has it (unit 0349).

## 3. Parameterize downstream, copy upstream

A module downstream of the window takes the term as a parameter with its
bounds as hypotheses (units 0334–0335). A module that repeats an old one
copies the old one in full with the names changed.

## 4. Build

```sh
grep -n -A1 'field_simp' lean_stage3/Stage3/<Module>.lean | grep 'ring$'
cd lean_stage3 && lake build Stage3.<Module> 2>&1 \
  | grep -v 'Replayed\|push_cast.*nothing\|linter\|^$\|^trace' \
  | grep -B2 -A25 'error\|Built Stage3.<Module>'
```

Every `ring` the first command lists becomes `try ring` before the build;
the checker refuses a bare one (`TRAPS.md` row 1). Classify every error
against `TRAPS.md` before fixing any. `errors_first` is the count of lines
`error: Stage3/<Module>.lean:<line>:<col>:` on the first build: a pin that
fails because its proof did counts (row 19), a warning does not; fix a
row-20 binder before counting. A stubborn lemma iterates in
`Stage3/Scratch.lean`.

## 4b. The relay

Builder: § 0 to § 4 once. One try per proof from the block's hint; a step
that does not close is `sorry` with its goal in a comment, the rest of the
proof kept, never a second attempt (unit 0364: six one-line sorries closed
on one rebuild). `Scratch.lean` serves § 2's names and casts only; § 4's "iterate a
stubborn lemma there" is the foreman's, after the handoff (unit 0362). Build again; the pins of sorried theorems fail until the proof is
closed, leave them. Stop with: the file; every `sorry` line with its goal;
`errors_first` and its roots; `TRAPS.md` rows hit and added; every ASSUMED
pin; where the block or this loop was unclear. Wait for the signal.

A name the block got wrong is § 2 work, fixed and reported as an ASSUMED
pin; it is not the one try.

Foreman: replace every `sorry`, build clean, signal "done, resume at § 5".

Builder, same context: delete `Stage3/Scratch.lean`, then § 5 and the
scaffold half of § 6 (`values.tsv`, `run/`). Stop with the unit path and
the counts.

Foreman: `unit.md`, `question.md`, the checkers, the commit, § 7.

## 5. Import, full build, counts, scaffold

```sh
cd lean_stage3
sed -i '' 's/^import Stage3.<Previous>$/import Stage3.<Previous>\nimport Stage3.<Module>/' Stage3.lean
lake build 2>&1 | grep 'error\|completed'
wc -l Stage3/<Module>.lean; grep -c '^theorem' Stage3/<Module>.lean; grep -c '^def' Stage3/<Module>.lean
cd <repo>
python3 -m lab new <slug> --type formalization --title "<Module>.lean: <one line>"
rm -f units/<unit>/run/.gitkeep
(cd lean_stage3 && lake build Stage3.<Module> 2>&1) > units/<unit>/run/build.log
```

Counts after the last edit, never from memory. Outputs go under the unit's
`run/`, never `results/`.

## 6. The unit

`run/run.sh`: three lines, `cd` to `lean_stage3` and the build command
(copy unit 0341's, module name changed). `question.md`: the transcript
verbatim and the pinned statements as fenced blocks copied from the
module. `values.tsv`: one row per number in the prose, `loop_version`,
`design <rung>.md#<section or sub-block>`, a source per row. `unit.md`:
paraphrases the header, keys every number beside its backticked key
(digits inside code spans are formula), ends with a paragraph beginning
`What the next slice` or `What remains`.

```sh
python3 utilities/check_prose_source.py units/<unit>
python3 -m lab check units/<unit>
python3 utilities/check_lean_unit.py units/<unit>
git add lean_stage3/Stage3/<Module>.lean lean_stage3/Stage3.lean units/<unit>
git commit -q -m "<Module>.lean: <what>; unit <id> logged"
```

Checkers in one call, the commit in another. The worksheet block's mark
goes to PROVED naming the theorems in the same commit. A hook edit needs
`touch .approve/pre-commit` from Julian.

## 7. Retrospective

One edit, every time: a first-build error class with no row in `TRAPS.md`
gets one; a step reordered or skipped without loss gets its line here
edited; any edit bumps `version:` and is committed with the unit. Keep an
edit when `errors_first` and the minutes trend down over the next units;
revert it when they do not. Read `errors_first` across the units before
editing.
