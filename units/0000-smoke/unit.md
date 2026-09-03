---
id: 0000
date: 2026-09-02
type: run
title: Smoke fixture that lab check must fail
refs: [0001]
supersedes: []
sealed: false
---

**Permanent test fixture.** This unit exists so that `lab check` has something
to fail on, and it is committed on purpose. Do not seal it, do not delete it,
and do not repair the numbers below — the failure IS the fixture. Its clean
twin is `units/0001-smoke-clean`, which passes.

**What it claims with evidence.** The ladder ratio came out at 3.07 and the
residual at 0.0184; the census counted 422 rows. Each of those three has a
line in `values.tsv`. The residual is stated to fewer places than the file
holds, which is what the rounding-aware comparison is for.

**What it claims without evidence.** A second reading of the same ladder gave
9.99, and the sweep ran to a width of 61. Neither has a line in `values.tsv`.
Both are findings.

**Fenced blocks are read too.** The design settles this: the check reads the
file rather than a stripped copy of it, so a number in a table is a claim like
any other.

```text
rows        422
half-width  7.5
```

The row count in that block has evidence. The half-width does not, so a fenced
block contributes a finding exactly as a paragraph does.

**Exempt by pattern.** The date 2026-09-02 is exempt because it is a date.
This unit's own id is exempt, and so is unit 0001, which it names in `refs`,
because an id is an identity rather than a measurement.
