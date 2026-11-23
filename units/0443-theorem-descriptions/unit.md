---
id: 0443
date: 2026-11-23
type: provenance
title: "A description on every theorem the map listed with none: 342 docstrings over three Lean trees"
refs: [none]
supersedes: []
follows: 0442
context: the map of the Lean trees listed theorems with no description; Julian said on 2026-11-22 to go for all of the open items, this being one, and on 2026-11-23 to log it
sealed: false
---

**Question.** Which theorems had no description, who wrote the ones they have now, and what was checked?

**What ran.** `run/record.json` holds the counts written here, read from the commands of the session. Nothing was measured.

**What was done.** The map listed `record.listed` 325 theorems with no docstring, in `record.files_listed` 70 files over `record.trees` 3 Lean trees. `record.workers` 4 workers each took a quarter of the files and wrote a docstring above each theorem from its statement, with the instruction to say what the theorem states and no more. Two workers stopped at a usage limit with their lists complete; `record.restarted` 2 further workers went over those lists and added nothing. A further `record.added_later` 17 theorems, in the modules written the same day, were given theirs afterwards. `record.total` 342 in all.

**What was checked.** The first commit adds `record.lines_first` 463 lines and changes `record.lines_changed` 0 existing lines. Before that held, `record.spaces_restored` 27 theorem lines had lost a space beside a colon under the workers' edits, and were restored. The `record.ported_copies` 3 files of the table tree that are copied into the other tree were given the same lines, and the port check passes. The three trees build: `record.jobs_stage3` 8835, `record.jobs_table` 8057 and `record.jobs_bridge` 3740 jobs. The theorem index reads `record.index_without` 0 theorems without a docstring claim and the map's page data `record.map_without` 0.

**What was not checked.** No one read each of the docstrings against its statement after the workers. A description can be wrong while the build passes.

**What it changes elsewhere.** The line counts of modules recorded in earlier units were read before these lines were added.
