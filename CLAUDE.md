# Identity

You are helping Julian with Primebeat_081426 — an adversarial follow-up
testbed that runs numerical tests (the O-series, O1–O9) against claims
made in the Prime Beat work and in the dyadic-table addendum series
(DT-A5, DT-A6).

The folder is a working measurement bench, not a library. Nothing here
is importable by `primebeat/` or `primebeat_lean/`, and nothing there
imports from here. The dependence is one-way: this folder cites those
documents; they do not cite back.

The load-bearing deliverable is the **recorded verdict under a locked
protocol** — a prereg written before the run, a decision rule that can
fire in both directions, and a result JSON whose SHA matches the
sidecar. Numbers produced outside that discipline are exploratory and
must be labelled as such.

## Rules

This file extends the rules in `/Users/juliansambrano/GitHub/CLAUDE.md`.
Project-specific rules below take precedence on conflict.

- Spawn-time orientation: every agent brief in this project opens with
  the AGENT_CLAUDE.md preamble (see system-wide
  `/Users/juliansambrano/GitHub/AGENT_CLAUDE.md`).
- Read `CONTEXT.md` and `REFERENCES.md` before any measurement work.

## Prereg discipline

The pattern established by `preregs/alpha_depth_trend_v1_locked_20260814.md`
is the house standard. A test earns a verdict only if, **before the run**:

1. H0 and H1 are stated, with a predicted direction under H1.
2. Every parameter is locked in a table (no `--seed` flags added later).
3. The decision rule names its verdict labels verbatim, including a
   `compromised` branch and a precedence order.
4. A vacuousness check states that the criterion has a realistic chance
   of firing in both directions.
5. Provenance is disclosed: which data has already been inspected by
   Julian or an assistant, and which arm is blind.

After the run, the prereg's Run record gets `run_start_at`,
`run_end_at`, `verdict`, `post_compute_sha256`, and a sidecar match
statement. **The verdict line is Julian's to write.** An agent may
compute the SHA and report the decision rule's mechanical output; it
does not stamp the verdict.

Currently only 07/O7 is preregistered. O3, O4, 05, 06, O8, and O9 are
exploratory. Do not describe their outputs as verdicts.

## Permissions

**CAN:**

- Read everything in this tree.
- Run any `O*.py` / `0*.py` script with explicit flags; write under
  `results/`.
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
- Edit this file, `CONTEXT.md`, or `REFERENCES.md` without Julian's
  explicit approval.
- Apply NOTEPAD status transitions or lab_notebook outcome markings —
  Julian's call.

## Lab notebook conventions

Lab notebook lives at
`/Users/juliansambrano/GitHub/Primebeat_081426/lab_notebook.md`.
Newest at top.

Entry header format:

```text
## YYYY-MM-DD — Entry N — <title>
type: <one-of-six>
refs: <entry numbers, comma-separated, or empty>

<body>
```

Type vocabulary (entry must use exactly one):

- `motivation` — why this test exists, what claim it is arguing with,
  scope shifts, what the next deliverable is for
- `prereg` — writing or locking a protocol before a run; records the
  hypothesis, decision rule, locked parameters, and pre-compute SHA
- `run` — one script execution: script, full flags, dps/N/pmax
  settings, headline numbers, output path, completed-or-errored
- `instrument-fix` — a change to a script that affects what it measures
  or whether it completes; always paired with a re-run and a note on
  whether prior results are still comparable
- `result-triage` — close reading of an existing result or log: what
  the number means, whether the instrument's own readability
  precondition was met, what would sharpen it
- `provenance` — where a file came from, script lineage and renames,
  which cited document is missing, cache coverage

If a new entry doesn't fit any of the six types, flag it and stop — do
not invent new types.

NOTEPAD.md follows `/Users/juliansambrano/GitHub/NOTEPAD_TEMPLATE.md`.

Division of labor: agents append `[open]` NOTEPAD lines and new
lab_notebook entries. Status transitions and verdict markings belong to
Julian.

## Naming convention (do not re-break)

The scripts are one series, O1–O9. O5, O6, and O7 were partially
renamed to `05_`, `06_`, `07_` — their docstrings still say O5/O6/O7,
and the leading digit is why `07_alpha_depth_trend.py` imports 05 via
importlib rather than by name. Do not rename further in either
direction without an `instrument-fix` entry; the prereg cites
`07_alpha_depth_trend.py` by path.

## Pointers

- `lab_notebook.md` — chronological record of runs, preregs, triage
- `NOTEPAD.md` — one-line index of open threads
- `CONTEXT.md` — what each test measures, output schema, current state
- `REFERENCES.md` — cited documents, sibling repos, packages, constants
