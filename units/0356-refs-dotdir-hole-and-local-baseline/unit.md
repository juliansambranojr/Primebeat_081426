---
id: 0356
date: 2026-09-07
type: instrument-fix
title: "check_refs.py resolved a missing script against a venv's site-packages; the fixed-notice now subtracts the local-only baseline"
refs: [none]
supersedes: []
follows: 0355
context: the pre-commit had been printing "fixed, trim the baseline" after every commit and the orchestrator twice told Julian the trim was his to do; asked directly what needed approving, the check found that none of the ten entries was repaired and that two classes of false resolution were hiding behind one message
sealed: false
---

**Question.** After every commit the pre-commit printed its advisory notice naming all `summary.baseline_lines` 10 entries of `utilities/refs_baseline.txt` as no longer broken. Is the baseline stale, and is the trim safe?

**What ran.** `check_refs.py` against the baseline, then the same after excluding dot-directories from its file set, then the pre-commit itself on a real commit. No test scripts; the checker is the instrument under test.

**What it shows.** No entry was repaired, and two different false resolutions were producing one message.

The first is a name collision. `check_refs.py` built its set of the repo's files as every bare filename under the root, `ROOT.rglob("*")`, which walks `summary.files_under_dot_dirs` files inside the two virtual environments out of `summary.files_in_tree` in the tree. `summary.operator_py_in_venvs` of those are named `operator.py`, in `connes_cvs` under the `.venv` of 2026-08-14 and in `torch` under the `.venv-torch` created on 2026-09-07 for unit 0355. The repo itself holds `summary.operator_py_in_repo` files by that name. So the three prose citations to `operator.py` in the two notebook volumes resolved against third-party packages, and a script that is genuinely absent read as present. Excluding any path with a dot-directory component restores them: `check_refs.py` reported `summary.broken_before` breaks before the fix and `summary.broken_after` after, with `summary.new_breakage_introduced` references newly broken, so nothing else in the tree depended on the collision.

The second is local-only data. The remaining `summary.local_only_lines` entries point at the three O24 result JSONs, each over `summary.o24_size_floor_mb` 25 MB, excluded from the repository by filename and recorded in `results/LOCAL-ONLY.md` with their sizes, hashes and the committed run logs that carry the headline numbers. They sit in Julian's working tree, so they resolve here and break on every other clone. They are correct baseline entries and always will be.

The trim was therefore never safe. Trimming would have made the pre-commit refuse commits on any clone but this one, and would have deleted a deliberate record. The orchestrator recommended it twice, in the report on unit 0354 and again after unit 0355, in both cases from the notice rather than from the file; that is the failure `CLAUDE.md` § Rule — load, don't recall names, arriving through a checker instead of a docstring.

**The fix.** `summary.files_changed` 2 files, neither of which changes what any past run measured. `check_refs.py` skips dot-directories when it collects filenames, with the reason in a comment. `utilities/refs_baseline_local.txt` holds the seven local-only entries with the note not to trim them, and the pre-commit's closing notice subtracts that list, so what it prints from now on is a reference genuinely worth trimming. The notice printed `summary.notice_printed_after_fix` lines on the commit that landed the change. The baseline itself is untouched: every one of its entries is still expected to break on a clean clone.

Prior results stay comparable. The checker's verdict on the tree is unchanged for every reference except the three `operator.py` lines, which move from silently passing to correctly failing and were already recorded as expected failures in the baseline.

What remains. The same bare-name collision can hide any citation to a common module name, and only dot-directories are excluded; `lean/` and `lean_stage3/` together hold most of the tree's files and could mask a citation to a Lean-adjacent script. Narrowing the set to files git tracks would close that, and is a larger change than this one.
