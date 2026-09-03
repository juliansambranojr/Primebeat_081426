---
id: 0001
date: 2026-09-02
type: run
title: Smoke fixture that lab check must pass
refs: [0000]
supersedes: []
sealed: false
---

**Permanent test fixture.** This unit exists so that `lab check` has something
to pass on, and it is committed on purpose. Do not seal it and do not delete
it. Its failing twin is `units/0000-smoke`, which states two numbers its
`values.tsv` does not hold and one more inside a fenced block.

**What it claims.** The ladder ratio came out at 3.07, the residual at 0.0184,
and the census counted 422 rows. Every one of those has a line in
`values.tsv`, so the check prints no finding and exits clean.

**Fenced blocks are read here too.** The same three numbers restated as a
table, which the check reads rather than skipping.

```text
ratio       3.07
residual    0.0184
rows        422
```

**Exempt by pattern.** The date 2026-09-02 is a date. This unit's own id is
exempt, and so is unit 0000, which it names in `refs`.
