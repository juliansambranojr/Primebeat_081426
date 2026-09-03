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

## Counts are written in digits

`lab check` scans digits, so a count spelled in words passes unchecked.
Unit 0308 found it: "four runs" is invisible where `4 runs` resolves to a
key. Rule: **any number that counts something in the record is written in
digits.** Runs, units, files, findings, keys, tests, lines, entries.

Boundary, and this is the orchestrator's reading rather than Julian's
words — a number-word used as ordinary English keeps its word form ("one
execution", "the second half", "a third of the tokens"). The rule binds
when the number is a count of things the archive holds, because those are
the ones with a key. If that boundary turns out to be unusable in
practice, the fallback is stricter: digits everywhere a number appears.

Enforced by `lab check`: a number-word adjacent to a countable noun is a
finding, with the digit form named in the message.

## The parser matches the spec

`lab/unit.py` rejects every indented line, so the `agents:` shape § The
fingerprint draws does not parse, and unit 0308 had to flatten it to
colon-joined triples. Reconcile them: the parser gains nested sequences of
flat mappings, which is what `agents:` needs and nothing more. The spec is
the target and the parser moves to meet it.

General rule, from the same finding: **a spec section never lands without
a phase row and a test that fails until it is built.** Three of unit
0308's seven findings were spec and code written apart and never
reconciled — `agents:` nesting, `follows:` having no implementation, and
`check_refs` never scanning `units/`. All three were true the moment they
were written.

## A run record exists before the run

Unit 0308: a unit cannot count its own runs, because the fourth record
does not exist while the fourth run is producing it. The fix removes the
counting rather than fixing it.

`lab run` allocates the index and writes the record FIRST, as a template
carrying the index, the invocation and `status: started`. The run then
executes and the record is completed with the exit code, the wall time
and the interpreter version. A run that never completes leaves a record
saying `status: started` with no exit code, which is a durable statement
that it was attempted and did not finish.

So a unit's run count is a directory listing at any moment, including
during a run, and a run that was never executed says so in its own file
instead of being an absence.

## A changed count supersedes rather than mutates

When a generated count changes, the new file carries the correct count
and its connections, and the old one is retired with a pointer to its
successor as provenance. The same `supersedes:` discipline the units use,
applied to the generated layer, so a reader who followed the old number
can find where it went.

## A correction reads its predecessor

Unit 0308 states the gap: "A correction has no evidence of its own. The
invariant asks that every number in the prose have a line in this unit's
`values.tsv`, and a superseded figure — the 1.5% and 3.4% above — was produced
by code that no longer exists ... A unit correcting a number that was never
written down anywhere would have no such route."

This is a practice, not a mechanism, and the reason is the measurement the
whole program rests on. The pool is scoped to one unit, and that scoping is
what makes the check discriminate; a checker that resolved a superseded figure
against some other artifact would be the tree-wide pool § The one measurement
refused. So nothing is added to `lab check`. What is added is a rule about
which file a correcting unit reads.

**The rule.** A unit that corrects a figure names the artifact that stated the
wrong one, and its own `run/` READS the figure out of that artifact. The
superseded number then enters `values.tsv` as a measurement of a document
rather than as a number somebody remembered, and the correction satisfies the
invariant the same way every other number does. Unit 0308 is the worked
example: `run/figures.py` reads the old rates out of entry 307's prose and out
of `lab/exempt.py`'s docstring, which is a real read of two real files.

**Where there is no artifact.** A number that was never written down anywhere
has no route, and inventing one is the defect the invariant exists to stop. The
correcting unit then states only the number that is right, and describes what it
replaces without quoting a figure — "the rate this file reported before it was
computed exactly" rather than a digit with nothing behind it. What is lost is
the size of the error, and that loss is the cost of the number never having been
recorded, which is the argument for § No scratchpad rather than an argument for
a new mechanism.

**What this does not fix.** A wrong number that WAS written down, in a file
that has since been deleted or rewritten, is reachable only through git.
Reading it out of history is a real read of a real artifact and satisfies the
rule; nothing here automates it.

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
| 2c | unit 0308's seven findings: digits for counts in `lab check` (`lab/counts.py`, a closed noun list); nested `agents:` in the parser; `lab new` id allocation past the notebook, the floor read out of the frozen notebook; the run record written before the run, `status: started`; `follows:` written by `lab new` and validated by `lab check`; `check_refs` scans `units/*/unit.md` and its state line names the next UNIT; a correction's evidence, as § A correction reads its predecessor. 0308 is sealed, so it is baselined in `utilities/lab_check_baseline.txt` with its reason rather than repaired | the design matches the code, and the first real unit's findings are closed before a second lands |
| 3 | `lab index` generates INDEX.md (units by type, artifact counts, sealed/unsealed status) and INDEX-values.tsv (the reverse map: key to citing units) at the project root; `lab/index.py` reuses `lab check`'s matching logic to build the reverse map; 2 pre-existing test failures in `test_phase2c.py` updated for the current tree (0309 exists, next id is 0310); 18 new tests in `tests/test_phase3.py`; `lab index` registered as a CLI subcommand with `--cwd` | the largest measured defect class, deleted; the archive inverts; every count is generated and owned by INDEX.md |
| 4 | `lab chain` walks every unit's `follows:` field, groups units into bounded segments (default 25), assigns deterministic labels (spreadsheet order for the main line, dotted labels for branches), computes inherits/handoff digests (sha256 over sorted unit ids), detects forks and gaps, and generates CHAIN.tsv at the project root; disagreement detection compares computed segments against on-disk CHAIN.tsv (label, new, missing); `lab/chain.py` with `spreadsheet_label`, `handoff_digest`, `build_forest`, `compute_segments`, `render_chain`, `parse_chain`; `lab chain` registered as a CLI subcommand with `--cwd` and `--segment-size`; 2 pre-existing test failures in `test_phase2c.py` updated for the current tree (0310 exists, next id is 0311); 50 new tests in `tests/test_phase4.py` | durability and the inheritance check; the chain is walked, forks and gaps are visible, every unit is in a labelled segment, and the labels are deterministic |
| 5 | `lab cite <unit> <key>` prints a value from values.tsv for a program to paste; `lab brief <unit>` generates a fenced brief block carrying keys and unit ids for an agent prompt (no raw numeric values cross the boundary); `lab report <unit>` generates a report block tagged with the unit id, carrying gate results from lab_run JSONs, values summary, agents, and refs; `lab/cite.py`, `lab/brief.py`, `lab/report.py`; 3 CLI subcommands registered; 43 new tests in `tests/test_phase5.py` (355 total); the quote gate described in § Transcript is king is deferred to a later phase -- the 3 commands are the tools that make the gate's job possible | no digit crosses an agent boundary; a brief carries keys, a report carries a generated block, `lab cite` is how a value reaches prose |
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
