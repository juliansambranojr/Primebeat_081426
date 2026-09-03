---
id: 0003
date: 2026-09-02
type: run
title: Fixture that lab run executes
refs: []
supersedes: []
sealed: false
---

**Question.** Does `lab run` leave a unit that answers the invariant on its
own — a log, a provenance record and a regenerated `values.tsv` — with no
number having existed anywhere else first?

**What ran.** `lab run units/0003-run-smoke`, which invokes `/bin/sh -e
run.sh` with the working directory set to `run/`. The runnable is
arithmetic-only and writes `ladder.json`, so its bytes are the same on any
machine; everything that is not — the clock, the paths, the platform — is in
`lab_run.001.json`, where the `meta.` prefix keeps it out of the digest.

**What it shows.** The run wrote a ratio of 3.0703 with a residual of
0.018401 over a census of 422 rows, and every one of those has a line in
`values.tsv` that `lab run` generated rather than a person typing it.

**What the string-value widening buys, in this fixture.** `ladder.json`
states its reach condition as text — the constant 4.92 exists in this unit
only inside a string value, exactly as entry 304's `consumers[0].t_req_expr`
does. Phase 2 read the pool as numbers only, so this sentence would have been
a finding against a file that holds its evidence. `lab check` reads inside
string values as of Phase 2b, and its summary line names how many values
came out of free text, so the widening is visible rather than silent.

**What the provenance record does not do.** It contributes exactly two
numbers to the pool, the exit code and the wall time, and both are facts
about the run. Every other field is written in a shape the exemption list
treats as an address, so a prose number can never take its evidence from the
metadata of its own run.
