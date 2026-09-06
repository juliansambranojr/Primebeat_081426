# Agent card — Primebeat_081426

Read this before anything else. Open a full commitment file only when
your task touches its subject or a line below sends you there.

## Role

- `/Users/juliansambrano/GitHub/AGENT_CLAUDE.md` — your role. Read it.
- You append; Julian decides. Never transition a NOTEPAD line, never
  stamp a verdict or outcome, never retitle an old entry. Corrections
  are new entries.
- Never edit `CLAUDE.md`, `CONTEXT.md`, `REFERENCES.md`, `files (2)/`,
  `results/*.json`, any `.log`, or a locked prereg. (`AGENT_CARD.md` § Permissions)

## Three rules that were failures

- Load, don't recall (`CLAUDE.md` § Rule — load, don't recall): open every file before citing
  it; count grep matches — several files contain templates of
  themselves; write `[0-9]+` never `[0-9]*`. A path in context is not a
  path you read.
- Offer the log (`CLAUDE.md` § Rule — offer the log): after any run or result, ask in
  one line whether to log it.
- Say what is (`CLAUDE.md` § Rule — say what is): no `X, not Y`; state the positive
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

## Permissions

Enforced by `utilities/hooks/check_protected_write.py` (writes) and the
pre-commit (commits); the list here is the same list.

**CAN:**

- Read everything in this tree.
- Run any `O*.py` / `0*.py` / `t*.py` script with explicit flags; write
  under `results/` or the session's `analysis/<date>/results/`.
- Run anything in `utilities/`; it is read-only over the tree except
  `extract_run.py --append`, which needs a reviewed draft.
- Read `/Users/juliansambrano/GitHub/primebeat/` and
  `/Users/juliansambrano/GitHub/primebeat_lean/` read-only for
  orientation.
- Append lab_notebook entries and `[open]` NOTEPAD lines.

**CANNOT:**

- Modify or delete anything under `files (2)/` — that is an imported
  bundle and the only surviving record of O1, O2, and O3b. Treat it as
  frozen evidence.
- Delete `results/*.json` or the `.log` files. O8 has no results JSON;
  its three logs are its entire record.
- Delete `preregs/*` or edit a `LOCKED` prereg's locked-parameter
  table. A locked prereg is immutable except for its Run record.
- Modify anything in `primebeat/` or `primebeat_lean/`.
- Edit `CLAUDE.md`, `CONTEXT.md`, or `REFERENCES.md` without Julian's
  explicit approval (a one-use flag, `touch .approve/<basename>`).
- Apply NOTEPAD status transitions or lab_notebook outcome markings —
  Julian's call.

The O-series naming convention (O5–O7 partially renamed to `05_`–`07_`;
no further renames without an `instrument-fix` entry) is held by
`utilities/check_naming.py`, which the pre-commit runs.

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
