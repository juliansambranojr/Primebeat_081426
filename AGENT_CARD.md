# Agent card — Primebeat_081426

Read this before anything else. Open a full commitment file only when
your task touches its subject or a line below sends you there.

## Role

- `/Users/juliansambrano/GitHub/AGENT_CLAUDE.md` — your role. Read it.
- You append; Julian decides. Never transition a NOTEPAD line, never
  stamp a verdict or outcome, never retitle an old entry. Corrections
  are new entries.
- Never edit `CLAUDE.md`, `CONTEXT.md`, `REFERENCES.md`, `files (2)/`,
  `results/*.json`, any `.log`, or a locked prereg. (`CLAUDE.md:200–228`)

## Three rules that were failures

- Load, don't recall (`CLAUDE.md:31–90`): open every file before citing
  it; count grep matches — several files contain templates of
  themselves; write `[0-9]+` never `[0-9]*`. A path in context is not a
  path you read.
- Offer the log (`CLAUDE.md:92–108`): after any run or result, ask in
  one line whether to log it.
- Say what is (`CLAUDE.md:110–137`): no `X, not Y`; state the positive
  claim; correct an earlier statement as its own sentence.

## Numbers

- Every results JSON has a sibling `<name>.numbers` (flat `key<TAB>value`,
  sha256 of the JSON on line 1, `meta.*` for timing/hash fields), made by
  `utilities/flatten_results.py`. Cite a number by its key; read the
  value from the file; never retype a number from a report or a brief.
- Gate before commit, separate command: `python3 utilities/check_refs.py`
  exits 0. Backticked result paths are written in full
  (`analysis/<date>/results/<file>`); every bare script filename you
  mention must exist in the tree.

## Where things are

- Notebook: `notes/lab_notebook_2.md`, newest entry at the TOP; header
  and the type vocabulary in `notes/notes_format.md`. NOTEPAD lines
  ≤ 400 chars, format `~/GitHub/NOTEPAD_TEMPLATE.md`.
- Preregs and verdicts: `CLAUDE.md` § Prereg discipline, `preregs/FORMAT.md`.
  A run without a locked prereg is exploratory and is labelled so.
- Lean: `lean/` (v4.28) and `lean_stage3/` (v4.32, PNT+ pin 47fa486);
  conventions in
  CLAUDE.md § Stage-3 formalization conventions (lean_stage3/)
  The method for one module: `lean_stage3/LOOP.md` (the loop, versioned),
  `lean_stage3/TRAPS.md` (build error, cause, fix),
  `lean_stage3/design/<rung>.md` (the derivations; read first after a
  compaction), `PINS.md` (four lines per task, written before the work),
  `utilities/check_lean_unit.py` (refuses a Lean unit that disagrees with
  its module; the pre-commit runs it).
- Blueprint of every test and the current state: `CONTEXT.md` — open
  the section for your test only.
- Cited documents and constants: `REFERENCES.md` — grep for the item.
