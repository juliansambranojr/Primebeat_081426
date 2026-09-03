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

### The archive walks both ways

A faithful structure inverts. The unit gives one direction: from an entry
you reach its values, its run, its transcript blocks and its agents,
sealed and hashed, so the walk is exact.

`lab index` generates the other direction as `INDEX-values.tsv` — one line
per key, listing every unit whose prose cites it:

```text
weil_Lc_theory.fits.0.001.far_only_exact.b    0302  0304
arrow_price.eps_law_gamma1.b                  0304  0307
```

It costs nothing extra to build: `lab check` already resolves every number
in every unit to a key, so the reverse map is the same pass written out.

What it buys: when a measurement turns out wrong — a bad instrument, a
corrected constant, a re-run that disagrees — what rests on it is
computable. Today that is a grep and a hope. With the reverse map, break
one value and the affected units are a lookup, which is what makes
`supersedes:` usable at scale rather than a field somebody remembers to
fill in.

Both directions are generated, so neither can drift from the units.

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

### What a unit declares

One field, in the unit's front matter:

```text
follows: 0355
```

`lab new` fills it with the newest sealed unit, so the ordinary case needs
no thought and deviating is an explicit edit. Everything else is computed
from it. Walk the units by `follows`: two units naming one predecessor is
a fork; a unit naming a predecessor that is not there is a gap. Segments
are bounded windows over that walk.

### Segment names

Julian tracks letters. Main line, spreadsheet order: A, B, C … Z, AA, AB
… ZZ, AAA. A main-line label never contains a dot. Branches use a dot —
the first branch off C is `C.A`, the twenty-seventh `C.AA`, a branch off
that `C.A.A`. Dot count is depth, so `CA` (the seventy-ninth main
segment) and `C.A` (the first branch off C) can never be confused.

### The naming is deterministic

The label is a pure function of the tree, recomputable from nothing on
any machine. The ordering key is the unit id, which is immutable and only
increases:

- the root segment holds the lowest unit id and is `A`;
- at any fork the line continues through the child with the lower first
  unit id, and the others become branches;
- segments along a line take the next label in spreadsheet order;
- branches off a segment are ordered by their own first unit id and take
  the dotted labels in that order.

No timestamps, no file order, no directory-listing order. Stability falls
out rather than being bolted on: a new branch always has a higher first
unit id than the continuation that exists, so it sorts last and nothing
already assigned moves. The label written in a segment file is therefore
a **cache**; `lab chain` recomputes and compares, and a disagreement is a
finding. The handoff digest stays underneath as the content address, for
the case where two segments legitimately claim one label after a bad
merge — a name identifies, a digest proves.

## Enforcement is over artifacts, never over process

No mechanism can make an agent call a verb, and explicit instructions do
not hold — several were ignored during the session that produced this
design. So the gate never asks whether `lab new` was run. It asks whether
the thing on disk has the properties `lab new` produces: front matter
that parses, a values file that exists, every number in the prose present
in it, a label that matches the recomputed one. A hand-written unit that
satisfies them passes; one that does not is refused, with nobody having
checked what anyone remembered.

Process compliance is unverifiable and artifact properties are computable
from the files. The verbs are then the cheap path rather than an
obligation, and taking the cheap path is the one agent behaviour that can
be relied on.

## No scratchpad

Every run creates a unit first. `lab run` refuses to execute anything
outside a unit, so the record exists before the first number does.

This overrides the usual "exploration needs somewhere cheap" argument,
which the session that produced this design falsified twice: Julian asked
whether the scripts were saved and twenty-four files were sitting in a
session scratchpad, and a later audit found five more the first sweep had
missed, including the cross-check entry 301 describes as living in no
tree file. The cheap place is where work goes to be lost, and the cost
lands on Julian's attention.

The unit is the scratchpad. `lab new` takes a second, a failed
exploration is a unit whose run did not work and whose prose says so, and
`type:` lets the index fold exploration so volume costs nothing. A
temporary directory is for machinery with no content — a throwaway git
index used to test a gate, a diff of two files. Nothing that produces a
number goes there.

What still leaks: a run outside the repo entirely, and work done and left
unrecorded. Neither can corrupt anything downstream, because a citation
must resolve to a unit's values file, so an unrecorded number can never
enter prose. What is lost is the record of having tried.

## One home for a result

A result written from here on lives inside a unit. `results/` and
`analysis/**/results/` freeze exactly as the notebook does: everything they
hold stays, cited as it always was, and nothing new is added to them.

The gate is over the artifact, per § Enforcement is over artifacts, never over
process. A staged file under either path that HEAD does not already track at
that path is refused, and the refusal names `lab new` and `lab run` as where
it goes instead. It asks nothing about which tool wrote the file or whether a
unit exists for it — a hand-copied file, an old script's output and a run from
outside the repo are refused identically, for where they are. A staged change
to a file already tracked there passes, which is what keeps the frozen trees
readable rather than merely present.

This is the container half of § No scratchpad. That section closes the door on
running outside a unit; this one closes the door on a number ARRIVING outside
one, whatever produced it.

## Transcript is king

An agent's report reaches Julian through one generation step with no
witness, and the compression is invisible because what survives is true
as far as it goes. Measured, on 2026-09-02: the architect's report listed
fourteen migration steps with costs and three were relayed; the greenfield
report listed what it dropped and why, and a phrase was relayed; the
adversary reported seven WEAKENS against the census and three were
relayed. Whole arguments were lost, and any one of them could have been
the answer Julian was looking for.

So the chat is the one chance for an agent's finding to become durable,
and quoting into it has to be impossible to get wrong.

**Relay rule.** An agent's finding appears in chat only as a quote. If the
agent gave twelve items, all twelve appear, verbatim. The orchestrator's
reading follows, under its own heading, so the boundary between their text
and the assistant's is visible on the page.

**The quote gate.** A Stop hook treats every blockquote line and every
fenced block in the assistant's message as a claimed quote, and requires
each to appear as an exact substring of the current session transcript.
Truncation is allowed with an ellipsis; every surviving segment still
matches exactly. A miss blocks the message and names the failing line.

This works where `check_numbers_in_response.py` failed, and the reason is
scope again: that hook asked whether a value appears somewhere in a pool
of 59,700, which accepts almost anything. This asks whether an exact
string appears in one small document. A corrupted quote cannot pass.
Whitespace inside a copied table is compared as written rather than
normalised, or every table quote fails.

What it does not catch: paraphrase that is never marked as a quote. That
is what the relay rule covers, and it is a discipline rather than a gate.

## The fingerprint

The unit id is the spine. Every other identifier is recorded in the unit,
so nothing is reconstructed from a guess:

```text
---
id: 0305
agents:
  - id: a0a8bf60ac645202f
    role: build
    block: transcript/b01-phase2b-report.md
  - id: acafdbdc4f5818254
    role: build-stopped
    block: transcript/b02-partial.md
---
```

Each block file repeats its agent id in its own header. Every commit that
touches the unit names the unit id. Values keys already carry their source
file's stem, so a key traces back into `run/`. A chat quote is tagged
`[0305 · a0a8bf6]` in front, so the message is greppable too.

One grep of the unit id returns the unit, its blocks, its commits and its
chat lines. One grep of an agent id returns that agent's transcript file,
its block, and the unit that consumed it.

A unit names as many agents as worked on it. Two adversaries attacking the
same result from different angles are both relevant and both stay. An
agent that was stopped keeps its entry, because what it produced before it
stopped and what a successor discarded is part of the record — `2b` is the
worked example.

An adversary's block living inside the unit is what makes review visible
instead of a separate process: a later reader sees the attack and the
survival together, and an attack that breaks a unit produces a successor
that `supersedes:` it.

Agent transcripts themselves live at
`~/.claude/projects/<project>/<session>/subagents/agent-<id>.jsonl`,
outside the repo, unversioned, and gone on a machine change. That is why
the blocks that matter are copied into the unit. Comparing a unit against
the full agent transcript after the fact is possible and cheap; anything
of value was cited in chat, and the chat is what the unit preserves.

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
| 2b | audit the exemption list; admit numbers held inside string values; `lab run`; the one-home rule at the gate | no false exemption in the corpus; a constant that lives only in a formula string is citable; every run leaves a log, a provenance record and a regenerated values.tsv inside a unit; a result cannot land outside one |
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
