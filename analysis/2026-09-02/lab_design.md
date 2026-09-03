# lab — the program, the container, and the phases

Written 2026-09-02 by the orchestrator, from what this session measured.
Design only. Nothing in the tree changes until a phase is approved.

## The one measurement this rests on

Discrimination is a property of scope. Holding the matching rule fixed and
varying only the pool a number is checked against: tree-wide accepts most
invented three-decimal values, one artifact accepts a large minority, one
entry's own values accepts almost none. Every mechanism below follows from
scoping the pool to a single unit of work.

Second measurement: across three project trees, every fact that drifted is
a count, an inventory, or a status. No judgement drifted. So counts are
generated and prose is authored, with no file holding both.

Third: of the errors this session actually produced, roughly half are
qualitative or right-number-wrong-row. No digit check touches those. The
program's job there is to make adversarial review cheap.

## The shape

The **program** is the outer thing: the loop of question, run, unit, check,
index. The **container** sits inside it — the directory tree of sealed
units the program deposits into and reads from. The tree stays readable
and correct with the program deleted; the program makes the work fast and
refuses the moves that break the container.

## The unit

One directory per notebook entry. Immutable once sealed.

```text
units/0305-fixed-window-Lc/
  unit.md          authored prose + YAML front matter
  question.md      the transcript bracket the question was posed in
  run/             the code, its results, its logs — as produced
  values.tsv       GENERATED: key<TAB>value, one line per leaf
  UNIT.sha256      GENERATED: hash per file, plus a unit digest
```

Front matter in `unit.md`:

```text
---
id: 0305
date: 2026-09-03
type: run
title: <one line>
refs: [0302, 0304]
supersedes: []
sealed: false
---
```

Four properties fall out of the shape rather than from a checker:

- A wrong line reference is unwritable, because nothing cites lines.
- Overwriting a result is unwritable, because a sealed unit is immutable
  and a re-run is a new unit that `supersedes:` the old one.
- The question survives, because `question.md` is part of the unit.
- The value pool is the unit, which is what makes the check discriminate.

`run/` is copied in as produced. The unit digest covers every file, so a
re-run that reproduces gets a matching digest on everything except the
declared volatile keys (timings, absolute paths, timestamps), which
`values.tsv` marks with a `meta.` prefix and the digest excludes.

## The invariant

**Every number in a unit's prose appears in that unit's `values.tsv`.**

One sentence. It covers the entry body and its fenced tables alike, since
the check reads the file rather than a stripped copy of it. Numbers that
are not measurements — dates, entry ids, line counts of the unit itself —
are exempt by pattern and the exemption list lives in the program.

## Citations

`unit 0305 § <bold lead-in>`. No line numbers anywhere, in any file. The
substrate already exists: the notebook's entries carry bold lead-ins that
are near-unique within their entry.

## Counts

One generated `INDEX.md` at the project root owns every count, inventory
and status: units by type, artifacts, Lean modules and theorems, open
threads, the leaf ledger. Authored files lose their count slots and point
at `INDEX.md` instead. This is the largest measured defect class and it is
fixed by deleting sections rather than by adding a checker.

## Segments and the chain

Units group into bounded **segments** — an index file per N units. Each
segment declares two states:

```text
inherits: <digest of the previous segment's handoff>
handoff:  <digest computed from this segment's units>
```

Segment B follows A when B's `inherits` equals A's `handoff`. A missing
segment is visible with its shape intact, because its neighbours bracket
the gap. A segment declaring an inheritance nothing handed on is a
**branch**, rooted at whatever it did inherit; it grows on its own chain
and rejoins by declaring two inheritances. The cap keeps any single loss
small and keeps the walk cheap at ten years of entries.

## The CLI

```text
lab new <slug>        scaffold a unit directory, id from INDEX
lab run <unit>        execute run/, capture outputs into the unit
lab values <unit>     regenerate values.tsv from run/
lab check <unit>      the invariant, plus front matter and refs
lab seal <unit>       write UNIT.sha256, flip sealed: true
lab index             regenerate INDEX.md and the segment headers
lab chain             walk inherits/handoff, report gaps and branches
lab cite <unit> <key> print the value, for a program to paste
```

Python, standard library only for the program itself. One `pyproject.toml`,
`pip install -e .` once, `lab` on the path.

## Enforcement, and where it lives

| failure | caught by |
| --- | --- |
| number in prose with no evidence | format + `lab check` at the commit gate |
| stale line citation | format — nothing cites lines |
| overwritten result | format — sealed units are immutable |
| authored count drifts | format — no authored file has a count slot |
| broken chain, missing segment | `lab chain` at the commit gate |
| edit to a sealed unit or a protected file | one PreToolUse hook |
| right-number-wrong-row, qualitative claim | adversarial review, made cheap |

One commit gate, one hook, no CI, no config. A commit gate is patchable
from inside a session where a hook is not, which is why the gate carries
the load.

## The agent interface

A brief carries keys and unit ids. A report carries a generated block. No
digit crosses either boundary as a keystroke. `lab cite` is how a value
reaches prose; a model asking for a number gets it from the program.

## Phases

Each phase is one subagent, one green committable state, reviewed before
the next starts.

| # | phase | buys |
| --- | --- | --- |
| 0 | `lab` skeleton: entrypoint, `pyproject.toml`, `lab check` on one hand-made unit, pytest | the program exists and runs |
| 1 | unit layout, `lab new`, `lab values`, `lab seal`, the digest with volatile-key exclusion | the container exists; scaffolded units load and check; immutability |
| 2 | commit gate calls `lab check`; retire the checkers it replaces | one gate; drift caught before a commit |
| 3 | `lab index`; strip count slots from authored files | the largest measured defect class, deleted |
| 4 | segments, `lab chain`, branch detection | durability and the inheritance check |
| 5 | `lab cite`, brief and report blocks | no digit crosses an agent boundary |
| 6 | harvest from `the_container` — its benched results fitted to this shape | reuse what was already proved |
| 7 | retire the hook fleet down to one write-protect hook | machinery whose customer was machinery |

Migration needs no rewriting. `notes/lab_notebook_2.md` freezes exactly as
volume 1 froze at entry 44; unit 0305 onward are directories. Old entries
keep their line citations and are left alone.

## What this does not fix

Right-number-wrong-row and qualitative claims — the larger half of what
went wrong this session. A wrong measurement correctly recorded. A defect
in a slice that never enters a file. Reproduction, which needs a re-run.
Hand-entered constants from the literature.
