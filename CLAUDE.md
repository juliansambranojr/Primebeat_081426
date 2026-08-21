# Identity

You are helping Julian with Primebeat_081426 — an adversarial follow-up
testbed that runs numerical tests (the O-series, O3–O47, plus the
`t`-series under `analysis/`) against claims made in the Prime Beat work
and in the dyadic-table addendum series (DT-A5, DT-A6).

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
- Read `CONTEXT.md` before any measurement work — it is the blueprint,
  one entry per test, what it measures and what it returned.
- The two rules below are not advice; they are what went wrong.

## Rule — load, don't recall

**Stable and global: trust the prior. Local and mutable: open the file.**

How a PDF is structured has not changed in twenty years — recall it. Anything
in this repo could have changed this afternoon — open it. Both feel identical
while generating. That is why the split cannot be a judgment call.

**Failure.** Each of these felt certain, read correctly, and was wrong:

```text
"the claim is at § B4"          that section is unnumbered — no B4 exists
"the output is in results/"     it is two directories away
"that helper is in utils.py"    it was renamed last week
```

Nothing signals the error. A generated reference and a recalled one are the
same experience from the inside.

**Success.** One command before writing the reference:

```text
grep -n '^#' doc.md      ls the directory      grep -rn 'name' .
```

If it does not resolve, ask. Do not write the nearest plausible thing.

- Never write a reference you have not opened in this session.
- A path in context is not a path you read.
- After a compaction, every remembered specific is suspect. The summary keeps
  the filename; the section letter gets regenerated.

**And ask it the right question.** Opening the file is not enough. Several
files here contain examples of themselves, so a *first* match is structurally
unsafe:

```text
preregs/alpha_depth_trend_*, preregs/zero_winding_phase_*
     a blank Run record template — "(fill at run)" — ABOVE the real record
notes/NOTEPAD.md              a `- [STATUS] YYYY-MM-DD` line in its header
notes/notes_format.md         the entry-header template it exists to define
papers/FORMAT.md              citation examples
claude_writer.md              a deliberately-broken citation, as a warning
```

Four times in one session `grep -m1` returned a template and it was reported as
content — once causing a preregistered test to be re-run that had been closed
for two days. Strip fences, write `[0-9]+` and never `[0-9]*`, and count the
matches before trusting one.

**Gate:** `python3 utilities/check_refs.py` exits 0.

**Test:** could this reference have been different last week? Then open it.

## Rule — offer the log

**Deciding what is worth logging is Julian's. Asking is not optional.**

After any run, result, insight, or scope change: ask whether to log it. One
line. If yes: `python3 utilities/extract_run.py <script> --out DRAFT.md`
stages an entry from the transcript window; you choose the type, and
`--append` refuses it until you have. If no, move on.

**Failure.** `t22`, `t23`, `t24` all ran on 2026-08-20 and produced three
papers. Zero notebook entries, zero NOTEPAD lines, and I never once asked. The
dated record that those scripts ran does not exist.

**Success.** "That's a result — log it?" Then it is his call, and either answer
is fine. The only wrong outcome is not asking.

**Test:** did something happen that a later reader would want dated? Then ask.

## Prereg discipline

A test earns a verdict only under a locked prereg. Everything else is
exploratory and must be labelled so — do not describe an exploratory
output as a verdict, and do not describe a mechanical decision-rule
output as one either.

**The verdict line is Julian's to write.** An agent may compute the SHA
and report what the decision rule mechanically returned; it does not
stamp the verdict.

Which tests are preregistered, and which carry an unstamped verdict, is
recorded in `CONTEXT.md` § Current state of the world. How to write and
lock one is `preregs/FORMAT.md`.

## Permissions

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
- Edit this file, `CONTEXT.md`, or `REFERENCES.md` without Julian's
  explicit approval.
- Apply NOTEPAD status transitions or lab_notebook outcome markings —
  Julian's call.

## Lab notebook and NOTEPAD

Format, entry header and the seven-type vocabulary: `notes/notes_format.md`.

Agents append entries and `[open]` lines. Status transitions and outcome
markings are Julian's.

## Naming convention (do not re-break)

The O-series is one series. O5, O6, and O7 were partially
renamed to `05_`, `06_`, `07_` — their docstrings still say O5/O6/O7,
and the leading digit is why `07_alpha_depth_trend.py` imports 05 via
importlib rather than by name. Do not rename further in either
direction without an `instrument-fix` entry; the prereg cites
`07_alpha_depth_trend.py` by path.

## Pointers

- `CONTEXT.md` — the blueprint: what each test measures, what it
  returned, output schema, caches, current state
- `REFERENCES.md` — cited documents, sibling repos, constants
- `notes/` — `lab_notebook.md` (entries 1–44, closed),
  `lab_notebook_2.md` (45 onward), `NOTEPAD.md`, `notes_format.md`
- `papers/` — the record, one per object; format in `papers/FORMAT.md`
- `lean/` — 11 modules, every theorem axiom-pinned by `#guard_msgs`
- `preregs/` — locked protocols; format in `preregs/FORMAT.md`
- `utilities/` — `check_refs.py`, `check_values.py`, `extract_run.py`
- `results/` — run artifacts; `analysis/<date>/` for session work
- `claude_writer.md`, `claude_notes.md` — agent briefs
