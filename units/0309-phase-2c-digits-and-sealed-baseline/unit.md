---
id: 0309
date: 2026-09-03
type: instrument-fix
title: lab Phase 2c — digits enforcement, sealed-unit baseline, 7 findings closed
refs: [0305, 0306, 0307, 0308]
supersedes: []
follows: 0308
agents:
  - id: phase-2c-build
    role: build
    block: transcript/b01.md
sealed: false
---

**Exploratory.** No prereg, no decision rule, no verdict. This unit records
the 7 findings Phase 2c closed, the 2 decisions it made, and the 6 design
corrections it surfaced. The build enforces the digits rule it introduced:
counts in prose are written in digits.

**What Phase 2c built.** 7 findings, each a change to the `lab` program or its
gate. The transcript block at `transcript/b01.md` carries the before/after for
each one.

1. Digits for counts. `lab/counts.py` detects counts spelled in words and
   reports a `DIGITS` finding with the digit form. The boundary is a closed
   noun list: the noun after the word is what fires, so `four-line` triggers
   (a count of lines) while `four-or-more-digit` stays silent (`digit` is not
   a thing the archive holds). `one` is excluded because English uses it as an
   article.

2. Unit 0308 sealed and baselined in `utilities/lab_check_baseline.txt` with
   its reason. The baseline suppresses the whole check for a sealed unit, and
   the gate refuses a staged sealed unit before reaching it.

3. Nested `agents:` in `lab/unit.py`. The parser gains 1 nesting level: a
   block sequence of flat mappings, plus the formatter's inverse. 8 rejection
   cases still refused by name.

4. `lab new` id floor. The floor is read out of the frozen
   `notes/lab_notebook_2.md` via `max(dir_id,floor)+1`. A constant would be
   a second copy of a count; the file being frozen makes the read stable. This
   unit was scaffolded by that fix: floor at entry 307, newest sealed unit 0308,
   next unit 0309.

5. Run record before the run. `lab run` allocates the index and writes the
   record with `status:started` before invoking the runnable. A SIGKILLed
   `lab run` leaves `status:started`, no `exit_code`, `command` and
   `run_start` intact.

6. `follows:` validation. `lab new` writes it (newest sealed unit, omitted
   when none); `lab check` validates existence and refuses self-reference.

7. `check_refs` scans `units/*/unit.md`. It walks unit prose (not
   `question.md` or `transcript/`, which are quoted rather than claimed).
   The state line gains `FROZEN` and a units count. No edit under
   `utilities/hooks/` — the gate already calls both scripts.

An 8th item — a correction's evidence — is a practice recorded in
`lab_design.md`, a convention rather than a mechanism.

**The 2 decisions.** The digits boundary uses a closed noun list, implemented
and usable. The sealed-unit mechanism is baseline, not supersede: a supersede
points past a predecessor rather than repairing its prose, so it cannot fix
unit 0308's word-form counts. The baseline is the mechanism that already exists
for "expected to fail, reason written down."

**The 6 design corrections.** Each is something the design said that contact
with the build revealed as silent or wrong.

The `check_refs` finding attributed to unit 0308 is not in unit 0308. Grep of
the whole unit directory finds `check_refs` only in `question.md` and 1 gate
line in `b01`.

`follows:` cannot express the first unit's predecessor. Unit 0308 follows
entry 307, which is not a unit — the field assumes the walk lives entirely
inside `units/`. That is why unit 0308 reports a `FOLLOWS` finding.

The digits rule and the invariant pull against each other. A count in digits is
itself a number in prose and needs a `values.tsv` line. `number` is off the noun
list for that reason, recorded in `lab/counts.py`.

"The record carrying the index" is unimplementable as written. A numeric index
in the record body enters the pool; it stays in the filename, as `run.py`
already reasoned.

Baseline coarseness: a line suppresses the whole check, digest included, and for
a sealed unit the gate refuses before reaching it.

The live hazard designed around: the YAML workflow reads the newest entry number
off the state line via sed and does shell arithmetic on it; a zero-padded number
there triggers an invalid octal. The units half says `latest` rather than
`newest`, and a test asserts the sed parse still yields the notebook floor.

**Gates.** 242 tests passed, 2 failed (tree-state assertions in
`test_phase2c.py` that expect unit 0309 as the next id; the tree now holds it).
`lab check` over all 7 units — unit 0000 fails (its permanent job), unit 0001
through unit 0004 pass, unit 0308 fails (baselined). Pre-commit staged passed;
`check_refs.py` passed.
