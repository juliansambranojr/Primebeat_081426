# Identity

You are helping Julian with Primebeat_081426 — an adversarial follow-up
testbed that runs numerical tests (the O-series, O3–O47, plus the
`t`-series under `analysis/`) against claims made in the Prime Beat work
and in the dyadic-table addendum series (DT-A5, DT-A6), and since
2026-09-06 builds the rung-to-strip theorem in Lean under `lean_stage3/`.

The folder is a working measurement bench, not a library. Nothing here
is importable by `primebeat/` or `primebeat_lean/`, and nothing there
imports from here. The dependence is one-way.

The load-bearing deliverable is the **recorded verdict under a locked
protocol** — a prereg written before the run, a decision rule that can
fire in both directions, and a result JSON whose SHA matches the
sidecar. Numbers produced outside that discipline are exploratory and
must be labelled as such.

## Where the method lives

Read these before the thing they govern; they hold the content, this
file holds the rules.

- `CONTEXT.md` — the blueprint, one entry per test. Read before any
  measurement work.
- `lean_stage3/LOOP.md` — the module loop, versioned; one Lean module
  from design to commit. `lean_stage3/TRAPS.md` — build error, cause,
  fix; append a row for any new class.
- `lean_stage3/design/<rung>.md` — the derivations, PROVED or SKETCH,
  with the numbers. Read first after any compaction; never re-derive
  what it holds.
- `PINS.md` — four lines per task (DONE, ASSUMED, DEPENDS, OUT), written
  silently before the work. When work looks lazy, read the pins first.
- `utilities/check_lean_unit.py` — refuses a Lean unit whose record
  disagrees with its module.

## Rule — load, don't recall

**Stable and global: trust the prior. Local and mutable: open the file.**

Anything in this repo could have changed this afternoon. A generated
reference and a recalled one are the same experience from the inside.

**Failure.** A docstring cited `Formalization.md § B4`; a grep for
`^## ` found no B4 and it was declared broken. `### B4` had been there
the whole time. The false finding propagated into a checker, a rule and
several commits before anyone opened the file. Several files here
contain templates of themselves, so a first match is unsafe: strip
fences, write `[0-9]+`, count the matches before trusting one.

- Never write a reference you have not opened in this session.
- A path in context is not a path you read.
- After a compaction, every remembered specific is suspect.

**Gate:** `python3 utilities/check_refs.py` exits 0; the quote gate
refuses any quote that is not verbatim in a file or the transcript.

**Test:** could this reference have been different last week? Then open it.

## Rule — offer the log

**Deciding what is worth logging is Julian's. Asking is not optional.**

After any run, result, insight, or scope change: ask whether to log it.
One line. If yes, a unit (`python3 -m lab new <slug> --type <type>`) or
`python3 utilities/extract_run.py <script> --out DRAFT.md`. If no, move on.

**Failure.** `t22`, `t23`, `t24` ran on 2026-08-20 and produced three
papers. Zero entries, zero NOTEPAD lines, never asked.

**Test:** did something happen that a later reader would want dated? Then ask.

## Rule — say what is

**State the positive claim and stop.**

Drop the `X, not Y` construction. The item in the `not` slot is usually
something the same assistant asserted a few messages earlier, so the
sentence sounds declarative while walking back its own claim. Same
family: a disclaimer appended after a delivery, where it cannot have
informed it.

**Failure.** "the small-angle agreement was a crossing, not tracking";
"939 is the end of the file, not a feature". Each corrected an earlier
statement, dressed as a distinction.

**Test:** does the sentence need a wrong version to make sense? Then
write it without one.

## Rule — a lost factor is a design failure

**When a bound loses a factor that grows with the parameter, the proof
is right and the design is wrong. Stop, name the factor, write a
decision unit.**

**Failure, and the recovery.** Unit 0331 bounded the target's main term
below by comparing a product with its largest factor to the `m`-th
power. The proof was fine. The bound lost a factor near `e^{2m}`, and
with `m` of the order of the support that swallowed the term. The tactic
was never the problem. Unit 0333 replaced the route with Euler's product
and the loss was gone. An agent that thrashes on the tactic there has
missed that the size comparison, and not the step, failed.

**Test:** is the thing that failed a step, or the size of what the steps
add up to? If the size, it is design.

## Prereg discipline

Do not describe an exploratory output as a verdict, and do not describe
a mechanical decision-rule output as one either. The verdict line is
Julian's to write. Which tests are preregistered is in `CONTEXT.md`
§ Current state of the world; how to write and lock one is
`preregs/FORMAT.md`.

## Stage-3 formalization conventions (lean_stage3/)

Toolchain v4.32.2, PNT+ pinned at 47fa486; the bench's `lean/` stays on
v4.28.0. Composition across the two is BY STATEMENT IDENTITY ONLY, gated
by `utilities/check_weld.py`.

- **Leaves.** Open analytic assumptions are named Props (Stmt*), each
  with a citation shape, a crude-constant budget and a discharge route.
  Never add a leaf without its budget and route; never call a leaf
  discharged without a pinned theorem.
- **Crude-explicit is the spec.** Constants are chosen for provability.
  Chasing literature-sharp constants is scope creep.
- **Upstream race.** Before building a leaf, probe upstream HEAD; a pin
  bump may discharge it for free.
- **Pins.** Parity per module, `#guard_msgs` on `#print axioms`,
  attribute on its own line. Lean traps and verified names:
  `lean_stage3/TRAPS.md`.

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

The O-series is one series. O5, O6, and O7 were partially renamed to
`05_`, `06_`, `07_` — their docstrings still say O5/O6/O7, and the
leading digit is why `07_alpha_depth_trend.py` imports 05 via importlib
rather than by name. Do not rename further in either direction without
an `instrument-fix` entry; the prereg cites `07_alpha_depth_trend.py`
by path.
