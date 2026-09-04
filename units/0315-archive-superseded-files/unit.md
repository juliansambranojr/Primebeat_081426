---
id: 0315
date: 2026-09-03
type: provenance
title: archive superseded files
refs: [0313, 0314]
supersedes: []
follows: 0314
sealed: false
---

**Question.** Which files in the tree are now superseded by `lab` and can be
retired from their working locations?

**What ran.** An agent audit of imports, settings.json references, and `lab`
subcommand coverage for every file in `utilities/`, `utilities/hooks/`, and
the project root. No script executed.

**What it shows.** 7 files moved to `archive/`:

- `utilities/gate.py` — PostToolUse advisory hook, unwired in phase 7; `lab check` covers it
- `utilities/hooks/check_direct_run.py` — PreToolUse direct-run blocker, unwired in phase 7; `lab run` covers it
- `utilities/hooks/check_bash_guard.py` — PreToolUse bash guard, unwired in phase 7; commit gate + `check_protected_write.py` cover it
- `utilities/run.py` — pre-`lab` runner; `lab run` covers it; `files_with_docstring_refs` 8 O-series scripts still mention it in docstrings
- `claude_writer.md` — paper-writing agent brief; `lab brief` covers it
- `claude_notes.md` — notebook agent brief; `lab brief` covers it
- `analysis/2026-09-03/claude_md_trim_proposal.md` — scratch file from the CLAUDE.md trim

3 files still load-bearing, left in place:

- `utilities/resultsguard.py` — `scripts_importing_resultsguard` 16 O-series scripts import `guarded_write()`
- `utilities/check_results_guard.py` — called by `utilities/hooks/pre-commit`
- `utilities/check_entry_numbers.py` — covers notebook entries 1-304 (pre-unit)

`POINTERS.md`, `utilities/refs_allowlist.txt`, and `tests/test_phase7.py` updated.
`tests_passed` 382, `broken_refs` 0.
