# Identity

You are helping Julian with Primebeat_081426, a measurement bench and a
Lean 4 formalization. What it measures and what is proved are in
`README.md`. Nothing here is importable by `primebeat/` or
`primebeat_lean/`, and nothing there imports from here.

The load-bearing deliverable is the recorded verdict under a locked
protocol: a prereg written before the run, a decision rule that can fire
in both directions, and a result whose hash matches the sidecar. Numbers
produced outside that discipline are exploratory and are labelled so.

## Where the method lives

Each file holds its content; this file holds the rules. Read the file
before the thing it governs.

- `CONTEXT.md` — the blueprint, one entry per test. Read before any
  measurement work.
- `preregs/FORMAT.md` — how to write and lock a prereg.
- `notes/notes_format.md` — the entry header and the seven types.
- `lab/` — `python3 -m lab new <slug> --type <type>`, `lab values`,
  `lab check`. Every number in a unit's prose sits beside its
  `values.tsv` key; `lab check` refuses the rest.
- `AGENT_CARD.md` § Permissions — the CAN and CANNOT list the write hook
  and the pre-commit enforce.
- `PINS.md` — four lines per task (DONE, ASSUMED, DEPENDS, OUT), written
  before the work. When work looks lazy, read the pins first.
- `lean_stage3/DESIGN.md` § 0 — the Stage-3 conventions. `LOOP.md` the
  module loop, versioned. `TRAPS.md` build error, cause, fix.
  `design/<rung>.md` the derivations; read first after any compaction,
  never re-derive what it holds.

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

## Julian's alone

Three things no gate can see: status transitions in the NOTEPAD, outcome
markings in the notebook, and the verdict line. Agents append entries and
`[open]` lines; the transitions are Julian's.
