> Source: session transcript, 2026-11-27

> Ok, so where are we at with evrything? Whats new in mathlib, PNT+ as a contribution, what's a contribution to mathematics?

> I'm confused can you just tell me if any of our work is not in those repos?

> Yes check and what limits are you taking about ?

Asked whether to log the check as a unit:

> Yes

From `run/overlap.py`, the docstring:

```
Which of this repo's topics Mathlib, PNT+ and IEANTN already hold.

Usage: python3 -I overlap.py <repo root>

Three readings, written to overlap.json, with the file paths each search
returned in overlap_paths.txt:

1. GitHub code search, one query per topic per project, restricted to Lean
   files. GitHub allows 10 code searches a minute, so one every 7 seconds.
2. The same words grepped in the local copies of Mathlib and PNT+ that
   lean_stage3/ builds against (PNT+ pin 47fa486). Code search is known to miss
   files, and this is the cross-check.
3. Pull requests and issues by juliansambranojr in Mathlib and PNT+.
```
