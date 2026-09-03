---
id: 0308
date: 2026-09-03
type: run
title: lab Phase 2b — run capture, the exemption audit, and one home for a result
refs: [0305, 0306, 0307]
supersedes: []
follows: 0307
agents: [a0a8bf60ac645202f:build:transcript/b01-phase2b-report.md, acafdbdc4f5818254:build-stopped:transcript/b02-stopped.md]
sealed: true
---

**Exploratory.** No prereg, no decision rule, no verdict. This unit records one
build and one verification run over it. It is the first unit in `units/` that
is not a fixture, and the point at which `notes/lab_notebook_2.md` stops being
the record: that volume closes at entry 307 and the record continues here.

**What Phase 2b built.** The commit is `ccd44f0`, and `git show --stat` gives
it 24 files changed, 1537 insertions and 88 deletions. Two files are new —
`lab/run.py` at 368 added lines and `tests/test_phase2b.py` at 235 — and the
rest are the exemption audit, the widened pool, the one-home rule at the gate,
and the two fixture units `units/0003-run-smoke` and `units/0004-run-fails`.
`git rev-list --count 408de2a..1193e0f` returns 3: the build, and the two
design commits that added the sections it was built against. Every figure in
this unit was recomputed by `run/figures.py` from git, from the notebook, from
the two `.numbers` files and from the suite; none was copied out of a report.

**The false exemption, closed.** `lab/exempt.py`'s `unit-path` class matched a
bare four-or-more-digit id, a hyphen and a slug, with nothing required around
it. Over entry 302's prose that shape caught `8000-node` and `24000-point`,
which are grid sizes, so the checker never compared them to anything. The class
now requires a path position. Entry 302 holds 1301 number tokens; 416 were
exempt at 32.0% leaving 885 scanned, and 414 are exempt at 31.8% leaving 887.
Entry 304 is unmoved at 331 tokens, 248 exempt, 74.9%, 83 scanned. The whole
list is 12 classes and the other eleven were audited the same way, by
recomputing the spans with each class removed; block b01 carries that table.

**A false exemption is worse than a false accept**, which is why two tokens are
worth a class rewrite. A false accept leaves the number in the scanned column,
where a reader can question it. A false exemption removes it from the scan, so
it is never compared and never counted.

**Numbers held inside string values.** `analysis/2026-09-02/results/arrow_price.numbers`
holds 769 keys. Phase 2's pool took only values that parse as a number whole,
which is 612 of those lines and 431 distinct values; 99 lines are strings and
81 of those hold digits. Entry 304's `consumers[0].t_req_expr` is one of them,
and the constant 4.92 lives in that file nowhere else — so a migrated entry 304
would have reported it as a number with no evidence while its evidence sat on a
line the checker refused to read. The pool now reads inside string values, with
the exemption list applied inside the string so that a timestamp there
contributes nothing.

**What the widening costs, measured over every grid value.** `lab/exempt.py`'s
`exact_rate` computes the fraction of invented values in [0, 1000) a pool
accepts at each precision, with no draw at all:

```text
pool                                    values   bare int      1 dp      3 dp
arrow_price, numbers only                  431     6.000%    1.400%    0.030%
  + numbers inside string values           442     6.100%    1.430%    0.031%
weil_Lc_theory, numbers only              4285     7.700%    2.640%    0.166%
  + numbers inside string values          4333     7.700%    2.650%    0.167%
```

11 values enter one pool and 48 the other, for at most a tenth of a percentage
point of extra false accept, and none at all on the larger pool's integer
column.

**The four corrections the build made.** Each replaced something already
written down, and each is stated here as a correction rather than as a fresh
claim.

The first is the rates table itself. Phase 2's version came from an unseeded
draw and did not reproduce; the exact computation gives 1.400% and
2.640% where it stated 1.5% and 3.4%, and 0.030% and 0.166% where it stated
0.1% and 0.4%. The integer column never moved, because it was never a draw.

The second is a claim rather than a figure. Phase 2 wrote that an integer check
is 15x to 60x weaker than a three-decimal one, reading a ratio off that
noisy column. The exact ratios are 46x on the 4285-value pool and 197x on the
431-value one. What survives is the half that decided the design: an integer
check still refuses between 92% and 94% of invented values, so dropping it is
not free, and every fact this project has watched drift is a count.

The third is `utilities/check_units.py`'s own account of itself. Phase 2 left
its docstring saying the four-line call into the commit gate was unapplied and
that the rules were therefore unenforced. Julian applied it; the docstring now
records that `utilities/hooks/pre-commit` carries the section and calls the
script, so a rule added to that file is armed without touching the guarded
gate.

The fourth is the one entry 307 carries. `lab/check.py` said, and entry 307
repeats, that 157 of those keys are strings. 157 is the count of lines that do
NOT parse as a number: 99 strings, 42 `false`, 11 `true` and 5 `null`. Entry
307 is frozen and is Julian's, so the correction is recorded here and nothing
there is touched. Nothing else moves with it — 81 strings hold digits either
way, and 4.92 is the same constant.

**`lab run`, and the record it leaves.** A unit declares what to run by holding
`run/run.sh`, invoked as `/bin/sh -e run.sh` with the working directory set to
`run/`. There is no fallback and no flag for a loose script. Beside the log
goes `run/lab_run.<NNN>.json`: the exact invocation, the exit code, the wall
time, the runnable's hash, the interpreter, the OS and the git head. That
record is a result file like any other, so `lab values` folds it into the pool
and a claim about the run has something to point at — and every field but the
exit code and the wall time is written in a shape the exemption list reads as
an address, so a prose number can never take its evidence from the metadata of
its own run. The `-e` was found by the verification: without it a crashed
`python3` left `sh` returning the last `echo`'s status, and `lab run` reported
success and regenerated the pool from a failed run.

**The fixtures, as committed.** `units/0003-run-smoke` runs, and its
`values.tsv` holds 24 keys of which 5 are numeric and 1 more comes out of a
string value — that last one is the 4.92 shape, demonstrated in a unit rather
than in a scratch table. `units/0004-run-fails` fails on purpose: its log holds
the traceback, its record holds the non-zero exit, and its `values.tsv` holds 0
keys, because values are regenerated on success only.

**One home for a result.** `utilities/check_units.py` gained a third rule: a
staged file under `results/` or `analysis/**/results/` that HEAD does not
already track at that path is refused, and the refusal names `lab new` and
`lab run` as where it goes instead. The test is `git cat-file -e HEAD:<path>`
and nothing else, so a hand-copied file, an old script's output and a run from
outside the repository are refused identically, for where they are. It runs
before the `lab` probe, so it holds in a checkout with the program not
installed.

**What the suite says.** `python3 -m pytest -q` reports 202 passed, 20 of them
in `tests/test_phase2b.py`.

**What this unit's own `run/` records.** Four runs, `lab_run.001` through
`lab_run.004`, because `lab run` takes the lowest index for which neither the
log nor the record exists and so never overwrites one. `lab_run.003` exited
non-zero — a regex in `run/figures.py` stopped matching once `lab/exempt.py`
was quoted across a line break — and its exit is in the pool at
`lab_run.003.exit_code` as 1, beside its log and its record. `values.tsv` was
left exactly as `lab_run.002` wrote it, which is what `lab/run.py` records:
regenerating after a crash would fold a half-written result into the evidence
pool. That accumulation is the behaviour the design asks for and it is also
the honest record of building this unit.

**Where the design did not survive contact with this unit.** Five places, each
found by building 0308 rather than by reading the spec.

`lab new` cannot scaffold this unit. It allocates the next id by scanning
`units/` and taking the highest plus one, so it produced `0005-` while the
container's ids continue the notebook's numbering and this one has to be 0308.
The directory was renamed and the front matter's `id` corrected by hand.
Nothing in the program knows the notebook's last number.

`agents:` cannot be written as the design draws it. `lab/unit.py` parses a flat
subset of YAML and rejects every indented line by construction, so the nested
list of `id`/`role`/`block` mappings in § The fingerprint does not load. It is
written here as a flow list of colon-joined triples, which keeps one `agents:`
key holding all three fields per agent and round-trips through `lab seal`.

`follows:` has no implementation. The parser accepts it because it accepts any
flat key, and `lab new` does not write it, so it is present here by hand and
nothing reads it. That is Phase 4's work.

A correction has no evidence of its own. The invariant asks that every number
in the prose have a line in this unit's `values.tsv`, and a superseded figure —
the 1.5% and 3.4% above — was produced by code that no longer exists. Here they
are read out of entry 307's prose and out of `lab/exempt.py`'s own docstring by
`run/figures.py`, which is a real read of two real files; they are the only
figures in this unit whose source is a sentence rather than a computation. A
unit correcting a number that was never written down anywhere would have no
such route.

A unit cannot count its own runs. The paragraph above says four, and it says it
in words, because the fourth run's record does not exist while the fourth run
is producing `figures.json`. Anything a unit states about its own run history
is one behind, or it is prose.

**What is not done.** `lab index`, `lab chain` and `lab cite` remain unbuilt
and deliberately unstubbed, so there is no INDEX.md, no reverse map, no segment
and no chain walk — this unit's `follows:` is a declaration nothing checks.
`utilities/hooks/check_direct_run.py` does not cover in-repo execution: its
pattern fires only on an interpreter invoked on a bare root-level filename, so
a script under a directory still runs outside a unit and nothing notices. And
no notebook entry is migrated; volume 2 keeps its line citations and its old
surface, and only the record from here on is a unit.
