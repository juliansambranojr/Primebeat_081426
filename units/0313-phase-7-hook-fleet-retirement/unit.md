---
id: 0313
date: 2026-09-03
type: instrument-fix
title: lab Phase 7 — hook fleet retirement
refs: [0305, 0306, 0307, 0308, 0309, 0310, 0311, 0312]
supersedes: []
follows: 0308
agents:
  - id: phase-7-build
    role: build
    block: transcript/b01.md
sealed: false
---

**Exploratory.** No prereg, no decision rule, no verdict. This unit records
what Phase 7 built: the hook fleet in `.claude/settings.json` retired down
to 2 hook blocks.

**What changed.** The PreToolUse/Bash matcher block (containing
`check_direct_run.py` and `check_bash_guard.py`) and the PostToolUse block
(containing `gate.py`) were removed from settings.json. 3 deregistered hook
files were deleted from disk: `check_numbers_in_response.py`,
`check_agent_brief.py`, `check_read_range.py`. 2 surviving hooks remain
wired: `check_response_prefix.py` (Stop) and `check_protected_write.py`
(PreToolUse/Edit|Write|MultiEdit).

**Gates.** 12 new tests in `tests/test_phase7.py`. 367 tests passed.
`python3 utilities/check_refs.py` returned 0.
