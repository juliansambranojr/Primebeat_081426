---
id: 0314
date: 2026-09-03
type: instrument-fix
title: lab Phase 8 — quote gate
refs: [0305, 0306, 0307, 0308, 0309, 0310, 0311, 0312, 0313]
supersedes: []
follows: 0313
agents:
  - id: phase-8-build
    role: build
    block: transcript/b01.md
sealed: false
---

**Exploratory.** No prereg, no decision rule, no verdict. This unit records
what Phase 8 built: a Stop hook at `utilities/hooks/check_quote_gate.py`
that enforces the relay rule from `lab_design.md` section "Transcript is king."

**What changed.** The hook is 218 lines. It reads the session transcript
JSONL, builds a corpus from all text before the last assistant message,
extracts blockquote paragraphs and fenced code block contents from that
message, and checks each quote as an exact substring of the corpus
(whitespace compared as written, no normalization). Ellipsis (`...` or
`...`) splits into segments; each segment is checked independently.
Empty quotes and blocks are skipped. `PB_NOQUOTE=1` bypasses everything.
A `stop_hook_active` loop guard lets second failures through. All parse
errors fail open.

2 files created: `utilities/hooks/check_quote_gate.py` and
`tests/test_phase8.py`. 2 files modified: `.claude/settings.json`
(added the hook as the second Stop entry) and `tests/test_phase7.py`
(relaxed exact-hook-count assertion to accommodate 3 hook blocks).

**Gates.** 15 tests in `tests/test_phase8.py`. 2 Stop hook entries
wired, 3 total hook blocks in settings.json. 382 tests passed.
`python3 utilities/check_refs.py` returned 0.
