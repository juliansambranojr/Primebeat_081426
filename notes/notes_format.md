# Notes format — WIP, not canonical

Covers `notes/lab_notebook.md`, `notes/lab_notebook_2.md`, `notes/NOTEPAD.md`.

Division of labor: agents append entries and `[open]` lines. **Status
transitions and outcome markings are Julian's** — never flip `[open]` to
`[closed]`/`[paused]`/`[blocked]`, never stamp a verdict.

## Lab notebook

Volume 1 is closed at entries 1–44. New entries go in volume 2, entry 45
onward. Newest at top. Numbering is continuous, so `entry N` is a unique
address project-wide and needs no path.

```text
## YYYY-MM-DD — Entry N — <title>
type: <one-of-seven>
refs: <entry numbers, comma-separated, or empty>

<body>
```

Exactly one type per entry:

| type | what it records |
|---|---|
| `motivation` | why a test exists, what claim it argues with, scope shifts |
| `prereg` | writing or locking a protocol before a run — hypothesis, decision rule, locked parameters, pre-compute SHA |
| `run` | one execution — script, full flags, dps/N/pmax, headline numbers, output path, completed-or-errored |
| `instrument-fix` | a change affecting what a script measures or whether it completes; always paired with a re-run and whether prior results stay comparable |
| `result-triage` | close reading of an existing result — what the number means, whether the readability precondition was met, what would sharpen it |
| `provenance` | where a file came from, script lineage and renames, which cited document is missing, cache coverage |
| `formalization` | a statement encoded in Lean — what was proved, the hypotheses actually needed, `#print axioms`, and whether it confirmed or refuted an account already in the notebook |

Does not fit a type? Flag it and stop. Do not invent one.

## NOTEPAD

Format is system-wide: `~/GitHub/NOTEPAD_TEMPLATE.md`. Not restated here.

One line per thread, newest at top, `entry N:` pointing into the notebook.

## Rule

An entry cites artifacts by path and entries by number. Before writing either,
open it — see `CLAUDE.md` § Rule — load, don't recall.

A number is cited by its `.numbers` key in backticks, followed by the value:

```text
`ladder.k=10|eps=0.01|M=16|w=1/2.L_c` 3.07
```

The `.numbers` file sits beside its results JSON and is made by
`utilities/flatten_results.py`; `python3 utilities/check_entry_numbers.py
--entry N` verifies every key in entry N against it, rounding-aware. Briefs to
loggers carry keys and file paths, never pasted numbers.
