# The scaffold, from an empty directory

Design only. Nothing built, nothing migrated, nothing committed. Standalone.
Written 2026-09-02 in answer to: *is there an easier way, if we had to build the
scaffold from the ground up knowing what we know?*

**The honest answer is yes, and the thing is much smaller.** Most of what I
designed over the previous two passes is machinery that exists to reconcile
files that should not have been separate, and to search a pool that should
never have been tree-wide. Three primitives and one rule cover the failures
that actually happened. The rest I would not build.

---

## 1 · The measurement that collapses the design

Everything below follows from one number. The failing gate in the current tree
asks *does this number exist in some value store*. I varied only the **scope**
of that pool, holding the matching rule fixed, and measured what fraction of
randomly invented values each pool accepts:

```text
pool                                  size   accepts random 3dp [0,1)   3dp [0,10)   4dp [0,1)
whole tree (today's Stop hook)      59,700                 95.8%        29.4%        33.8%
one artifact store                   4,285                 42.6%        14.3%         7.0%
one entry's cited values               134                  3.3%         0.5%         0.5%
```

**Discrimination is a property of scope, not of mechanism.** A value check
scoped to one entry rejects 96.7% of invented numbers where the same check
scoped to the tree rejects 4.2%. No cleverness produced that; narrowing the
question did.

Everything expensive in my previous design existed to make a tree-wide pool
safe: qualified `artifact#key` syntax to stop cross-file collisions, a separate
receipt file to pin which artifact a key came from, an escaped-dot store format
so keys could be re-parsed, a meta-stripped digest so re-runs would not false-
block, a config file so three gates would agree on where stores live. **Scope
the values to the entry and every one of those problems stops existing.**

The second measurement says the same primitive also covers the case I had
built separate machinery for. Entry 302's fenced tables — 509 numeric tokens
that no checker inspects today, for which I had designed cog-style block
markers with checksums and a table projector:

```text
entry 302 fenced tables      :  509 tokens,  497 covered by its own runs' values (97%)
entry 302 prose outside fences:  793 tokens,  739 covered by its own runs' values (93%)
uncovered, fenced: a year, and 11 values of one display-only column the .txt
                   prints and the JSON does not store
uncovered, prose : years, entry numbers, sha prefixes, and one ratio the entry
                   computed in prose from two stored values
```

One check covers prose and tables alike. The block markers, the slice
generator, the projector and the checksums are all unnecessary.

---

## 2 · The design

### 2.1 The unit: an entry is a file

```text
project/
  CONTRACT.md                        authored — what this is, the rules, the format
  REFERENCES.md                      authored — external citations
  INDEX.md                           GENERATED — every count, status and list
  notes/entries/0302-weil-lc-theory.md   authored — one entry, one file
  notes/threads.md                   authored — one line per live thread
  runs/2026-09-02T11-12-27_weil_lc_theory/
      script.py  out.json  out.txt  run.json     immutable
  values/constants.tsv               authored — hand values and literature constants
  tools/                             three programs
```

Five kinds of file. Today's tree has fifteen coordination markdown files in the
project and five more at the root.

**One entry, one file** is the single highest-yield decision and it is free.
Today's notebook is one 18,267-line file, newest-first, so every append shifts
every prior line: entry 303's citation to line 1233 needs 2022 today, a drift
of 789, across a rot surface of 47 cross-file line citations and 73 more inside
the notebook. As files, entry 296 is `notes/entries/0296-*.md` and there is
nothing to rot. Median entry is 66 lines, max 382 — comfortable files. `grep -r`
still searches them all. And append-only stops being a rule an agent must
remember and becomes what the filesystem and git already do: writing a new
entry creates a file, and editing an old one shows as a modification to a named
file in the diff.

### 2.2 The entry format

````text
---
entry: 302
date: 2026-09-02
type: run
refs: [298, 299, 300, 301]
runs: [2026-09-02T11-12-27_weil_lc_theory]
supersedes: []
---

# L_c in closed form for a fixed raised-cosine window

## Reading

The far-tail slope reproduces the measured slope: 1.7543 against 1.7686 at
eps = 0.001, a ratio of 0.9919. The intercepts do not match.

## Values

```tsv
fits.0.001.far_only_exact.b	1.7543...
fits.0.001.measured.b	1.7686...
fits.0.001.far_only_exact.slope_over_measured	0.9919...
```
````

**The whole invariant, in one sentence: every number in an entry's prose
appears in that entry's own Values block.** Exceptions, by category rather than
by allow-list: a four-digit year, an `entry N` reference, and a hex run of
eight or more characters.

The Values block is generated from the runs named in the front matter. It is
committed text in the same file as the claim, so a reader with no tooling has
the sentence and its source side by side, and `git diff` on the entry shows a
changed value as a changed line. There is no separate store to keep in sync, no
receipt file to exist or not exist, no digest to compute, no key to qualify, no
collision to resolve, and no config to say where any of it lives.

**Front matter is the only structure.** It is plain YAML at the top of a plain
markdown file — the most widely-read convention there is, parseable by three
lines of regex if no library is present. `supersedes:` is what makes a
withdrawn claim visible: today, entry 299's reading was "corrected" by entry
300 and restored by entry 301, and entry 300 stands uncorrected because
append-only requires it, so a reader arriving at entry 300 alone inherits two
withdrawn claims. With `supersedes: [300]` on entry 301, the generated index
carries a superseded list and the reader is warned. The substrate is already
there — seven entry titles in the current notebook use the "corrects"
construction; nothing reads them.

### 2.3 Where a number comes from

`lab cite <key>` prints the digits into the prose; the author never types them.
That is the mechanism. The Values block is the verification, and it is only
needed because the author *can* still type them.

**Should prose contain no digits at all?** I considered it seriously and it is
wrong. A reader with no tooling opening an entry that says "the ratio is
`{ratio}`" learns nothing, and the whole system's portability requirement is
that a plain-markdown tree is readable by any LLM with no tooling. But the
usual objection to digits-in-prose — that the digit and its source drift apart
— is answered by putting them **in the same file**. That is strictly better
than either extreme: the reader gets the sentence and the evidence together,
with no tool, and the checker gets a 134-value pool instead of a 59,700-value
one.

### 2.4 Runs are immutable directories

`runs/<utc>_<script>/` holding the script, its outputs, and a `run.json` with
argv, interpreter, script hash, environment and git HEAD. A re-run makes a new
directory. **Overwriting a prior result becomes unrepresentable** rather than
guarded: the current tree has a clone-and-archive runner, a clobber-guard
library, a checker for whether new scripts use it, and a hook that forces
scripts through the runner — four mechanisms, one of which is defeated by
`tee`, all replaced by naming the output directory after the run.

### 2.5 Generated versus authored

Only counts, inventories and statuses drift. Across three project trees I found
no drifted judgement and could not construct one — every stale fact was a
number about the tree. So:

**Generated: `INDEX.md`, and nothing else.** It carries every count (entries,
threads by status, runs, theorems, scripts), every inventory (the chronological
entry list, the run list, the superseded map), and every derived status. It has
no authored section — a generated file with an authored section is exactly
where the sibling `the_container` repo's stale battery count lives, inside a
block labelled "Authored, not measured", in a file whose header says it is
never hand-edited.

**Authored: everything else**, and the rule that makes staleness
unrepresentable is not a checker — **no authored file has a slot for a count.**
Today's drift happened because `CONTEXT.md` has a section called "Current state
of the world" and someone had to fill it, so it says 165 entries where there
are 303, fourteen papers where there are fifteen, six preregs where there are
twelve, and a leaf ledger retired four days earlier by a notebook entry. The
same section invited five files to state the Lean module count with four
different answers. Greenfield, that section does not exist in any authored file,
and the question it answered is `INDEX.md` or a one-line command.

### 2.6 Enforcement — where each failure class actually dies

Prefer the format making the error unrepresentable; then a commit gate; then a
hook; CI last.

| failure class | measured size | where it dies |
|---|---|---|
| wrong line reference into the record | 10 of 41 brief errors, plus 47 + 73 rotting citations | **format** — entries are files, no line numbers exist to be wrong |
| authored count of a generated thing | every stale fact in three trees | **format** — no authored file has a count slot; `INDEX.md` is generated |
| overwriting a run artifact | 3 scripts lost run 1 historically | **format** — a run is a new directory |
| wrong digit / count / duration in prose | 11 of 41 | **commit gate** — one checker, per-entry pool, 96.7% discrimination |
| digits inside pasted tables | 509 tokens per entry, ungated today | **same commit gate**, same primitive, 97% covered |
| editing an old entry or the contract | irreversible before commit | **one hook** — the only thing a hook is good for |
| right number, wrong row · qualitative claim | 19 of 41, the largest class | **nothing** — human review (§ 4) |

**One hook, one commit gate, one generator, no CI, no config.** The hook exists
only where damage precedes the commit. Everything else runs at commit, where it
is inspectable and — decisively — **patchable from inside a session**, which a
hook is not, because the running version polices its own edit.

### 2.7 The three tools

```text
lab cite <key>        prints `key` value from the run named in front matter
lab values <entry>    regenerates the entry's Values block from its runs
lab check             the commit gate: values, front matter, refs resolve
lab index             regenerates INDEX.md
```

Four verbs, one program. `lab check` is the whole gate and is a few hundred
lines: for each entry, parse front matter, build the pool from its runs, scan
prose numbers, exclude years and entry numbers and hashes, report. No config,
because the layout is fixed and there is one place stores live.

---

## 3 · What I would drop from the previous design, and why

| dropped | why |
|---|---|
| the separate committed value store with qualified `artifact#key` keys | the Values block in the entry is the store, scoped to where it is used; qualification exists only to disambiguate a tree-wide pool that no longer exists |
| the receipt file per entry | it was the Values block, in a different file, for no reason |
| the escaped-dot store format change | keys never need re-parsing once nothing projects tables out of them |
| the meta-stripped digest, and the whole re-run false-block problem | the Values block is committed text; a re-run that changes a value shows as a git diff, which is the reviewable event the digest was engineered to produce |
| cog block markers, the slice generator, the table projector, the checksums | measured unnecessary — the per-entry check covers 97% of fenced-table tokens with no markers at all |
| the config file / config block | one gate and one fixed layout need no config; the config existed to reconcile three gates that had each hardcoded the same globs |
| CI | a second copy of the commit gate, and a second copy of its scope, for one person on one machine |
| most of the hook fleet | hooks catch your own edits seconds later, not false claims; the sibling repo measured eight gates producing none of nine outside reviews' ~83 findings |
| `STATE.md` as a new file alongside the old ones | it survives as `INDEX.md`, but greenfield it is not an addition — it is the only generated file, and the authored files lose their count slots rather than transcluding from it |

| kept | why |
|---|---|
| `lab cite` | the single highest-value item — it removes the typing, and every check is verification of typing that should not have happened |
| digits in prose, evidence beside them | portability requires the first; scope requires the second |
| the generated brief block for spawned agents | reduced: paths and values only. Its measured buy is 21 of 41, and entries-as-files already kills the line-reference half, so what remains is small and cheap |
| one write-protection hook | the only irreversible-before-commit case |

---

## 4 · What this cannot catch

1. **Right number, wrong row — 8 of 41 measured.** An entry reads a real value
   of a real key and attaches it to the wrong claim. The Values block prints
   the key beside the value, which makes it *visible* to a reviewer; nothing
   makes it *catchable*.
2. **Qualitative claims — 11 of 41, the largest single class.** "all eight
   identical", "four to six orders", "the band starts at X = 9". No
   digit-matching mechanism touches these and I have none to propose.
3. **A wrong measurement, correctly recorded.** An entry's headline was an
   artefact of one basis family and was correct as a transcription at every
   hop. Every gate here passes it.
4. **Slice-then-aggregate.** A maximum taken from six of seventeen rows,
   wrong by a factor over two, standing for four entries — the defect never
   entered a file.
5. **Reproduction.** Nothing here re-runs anything from a clean checkout.
6. **Values with no producer.** `values/constants.tsv` is attributable, not
   verifiable.

**What a person has to do by hand.** Items 1 and 2 are 19 of 41 — the majority
of what actually went wrong — and the only thing measured to catch them is
adversarial review: nine outside reviews produced roughly 83 findings where
eight gates produced none of them. So the scaffold's job is not to automate
review; it is to **make review cheap enough to run often**. Small entry files,
a Values block that shows what each claim rests on, and a `supersedes:` field
so a reviewer can see what has been withdrawn. The review itself is a person's
work, and budgeting for it is a design decision, not a gap.

---

## 5 · The LLM-swap requirement

It demands exactly one thing: **the whole contract and the whole record must be
reconstructible by reading plain files in a flat tree.** Judged against that:

*Survives, because it is text.* The entry files, front matter, the Values
block, `CONTRACT.md`, `REFERENCES.md`, `threads.md`, `INDEX.md`,
`constants.tsv`, the run directories. Every one is readable with `cat`.

*Survives, because it is a convention rather than a program.* Entries as
files. `entry N` as an address. Runs as immutable directories. No authored
counts. These need no tool at all — they are how the directory is shaped, and a
different model in a different harness inherits them by looking.

*Does not survive, and must not be load-bearing.* The hook — it is
harness-specific, and the current tree's sibling project has four hooks
pointing at a deleted directory that exit non-zero and one settings file that
never loads. **The hook may only enforce things the commit gate also enforces.**
A hook is a convenience that fails closed into the gate.

*Survives in reduced form.* `lab` is a Python program, and a swap keeps it as
long as it is stdlib-only and its output format is text a person could produce
by hand. That is the test I would hold it to: **if `lab values` disappeared,
could someone paste the block by hand and would the entry still be valid?** Yes
— which is what makes it a convenience and not a dependency.

---

## 6 · The bridge from today's tree

The greenfield design is **not** close to my previous one, so the exercise
moved me. But the path from here is short, because the one structural change
needs no rewriting.

**The notebook splits rather than converts.** `lab_notebook_2.md` freezes
exactly as volume 1 already froze at entry 44 — untouched, still grepped, still
cited by `entry N`. Entry 305 onward are files in `notes/entries/`. Nothing is
rewritten, retitled or renumbered, which is what the append-only rule requires,
and the project has already used this exact move once.

Shortest path, in order:

1. **Freeze the notebook; new entries become files.** Half a day. Kills the
   line-citation rot for everything written from here. The 47 existing
   citations stay as they are and are already stale; a report lists them, and
   nothing edits them.
2. **The Values block, and `lab check` over new entries only.** A day. This is
   the whole numeric gate — one checker, per-entry pool. It supersedes the
   store, the receipt, the digest and the block markers before any of them is
   built.
3. **`lab cite`.** Half a day, already prototyped. Stops the typing.
4. **Rewrite the live Stop hook to a per-turn scope, or remove it.** Half a
   day. As written it accepts most invented values, and it is the only gate
   standing between an agent's report and the record. Per-turn scope is the
   same narrowing that § 1 measures; if that is not built, removing it is
   honest, because a gate that passes 95% of invented numbers reads as
   protection and is not.
5. **`lab index`, and strip the count slots.** A day, plus Julian's approval on
   the three commitment files. This is the largest measured defect class in
   three trees and the fix is deleting sections, not adding checkers.
6. **Runs as directories, for new runs only.** Half a day. Retires the
   clobber-guard machinery going forward without touching a single existing
   artifact.

**How much of the previous migration survives:** the notebook addressing work
(as entries-as-files, which is the stronger form of the same fix), the cite
tool, the Stop-hook rewrite, and the generated index. Four of seventeen steps.
The store format change, the receipt tooling, the digest, the block markers and
projector, the config, the CI job, the hook extensions and the emitter set —
thirteen steps — are things I would not build, and most of them were machinery
whose only customer was other machinery.

**What did not move.** Two conclusions survive the exercise unchanged, and they
are the two that were measured rather than designed: a number should reach
prose through a program rather than a keystroke, and the digits belong in the
file next to their evidence rather than behind a rendering step. Everything
else I built around those two was scope I had not measured the need for.
