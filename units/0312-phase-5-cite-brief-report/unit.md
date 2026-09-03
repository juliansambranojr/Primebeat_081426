---
id: 0312
date: 2026-09-03
type: instrument-fix
title: lab Phase 5 — cite, brief, report
refs: [0305, 0306, 0307, 0308, 0309, 0310, 0311]
supersedes: []
follows: 0308
agents:
  - id: phase-5-build
    role: build
    block: transcript/b01.md
sealed: false
---

**Exploratory.** No prereg, no decision rule, no verdict. This unit records
what Phase 5 built: 3 subcommands (`lab cite`, `lab brief`, `lab report`)
that give agents structured access to unit data without retyping digits.

**What Phase 5 built.** 3 new CLI subcommands and the modules behind them.

1. `lab cite <unit> <key>` — prints the raw value from values.tsv, one line,
   no decoration. Exit 0 on success, exit 1 if the key does not exist (lists
   available keys on stderr), or exits at code two if the unit cannot be loaded.
   Implementation in `lab/cite.py` (63 lines).

2. `lab brief <unit>` — generates a fenced brief block carrying keys and unit
   ids for an agent prompt. Lists key names only; no raw numeric values cross
   the boundary. Implementation in `lab/brief.py` (177 lines).

3. `lab report <unit>` — generates a report block tagged with the unit id for
   grep. Contains unit identity, gate results, values summary, agents, refs.
   Implementation in `lab/report.py` (152 lines).

**New source files.** `lab/cite.py`, `lab/brief.py`, `lab/report.py`, and
`tests/test_phase5.py` (43 tests covering cite/brief/report at module and CLI
level, plus real-unit tests against 0308/0309/0310). 4 files created.

**Modified files.** `lab/cli.py` (3 subcommands registered), `lab/__init__.py`
(docstring updated), `analysis/2026-09-02/lab_design.md` (Phase 5 row filled).
3 files modified.

**Gates.** 353 tests passed. `lab check` over all units: same results as
before. `python3 utilities/check_refs.py` returned 0 broken references.
