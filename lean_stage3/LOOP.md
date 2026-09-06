# The module loop

version: 1

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

## 1. Freeze the design: the header first

Write the module's header comment before any proof. It lists every
theorem in words, states its hypotheses, and ends with what the next
slice needs. The header is the contract; the unit's prose paraphrases it.
Name the pinned theorems now: the `#guard_msgs in #print axioms` lines
are fixed targets.

If a proof route is still open, do not start the file. Write the route
down (a decision unit, `python3 -m lab new <slug> --type decision`) and
decide first.

## 2. Verify every name before writing

One batched grep for every Mathlib lemma the file will use:

```sh
cd lean_stage3/.lake/packages/mathlib/Mathlib
grep -rn 'theorem NAME1\b\|theorem NAME2\b' . --include='*.lean' | head
```

A guessed name is an error on the first build, every time. Names that
resolve on this toolchain are listed in `TRAPS.md` § Names.

## 3. Reuse by copying

When a module repeats an old one with a term or a window replaced, read
the old module in full (`Read`, the whole file) and copy each proof with
the names changed. Copied modules build with zero errors; abstracting
them costs more than copying.

## 4. Build, classify, fix

```sh
cd lean_stage3 && lake build Stage3.<Module> 2>&1 \
  | grep -v 'Replayed\|push_cast.*nothing\|linter\|^$\|^trace' \
  | grep -B2 -A25 'error\|Built Stage3.<Module>'
```

Classify every error against `TRAPS.md` before fixing any. Most fall
into a row there. A `linear_combination` residual is read, never
recomputed. For one stubborn lemma, iterate in a scratch file at seconds
per try:

```sh
lake env lean Stage3/Scratch.lean      # delete the file before the commit
```

Record the first-build error count; it goes in `values.tsv` as
`errors_first`.

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

Four files. `run/run.sh` is the build. `question.md` quotes the transcript
verbatim and carries the statements as fenced blocks copied from the
module. `values.tsv` has one row per number in the prose, including unit
ids and numbers inside inline math, and the row `loop_version`. `unit.md`
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
  that caused it. The next units record the new `loop_version`.
- Keep an edit when `errors_first` and the minutes per module trend down
  over the following units; revert it when they do not. The evaluation is
  fixed: the build passes with the pin, both checkers pass, the counts
  match. The recipe is what moves.

The learning curve is already in the bench: `errors_first` across the
units, in order. Read it before editing the recipe.
