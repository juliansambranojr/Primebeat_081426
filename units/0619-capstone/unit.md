---
id: 0619
date: 2026-11-27
type: formalization
title: One statement: every zero outside the open corner is one of the four
refs: [lean/Capstone.lean::OpenCorner, lean/Capstone.lean::only_four_zeros_outside_corner, lean/Capstone.lean::only_four_zeros_outside_corner24, lean/WeakDepths.lean::only_four_zeros_rh_line37, lean_stage3/Stage3/RouteTight.lean::weakWindow13_of_RH]
supersedes: []
follows: 0618
sealed: false
---

**Question.** Can everything proved about the table so far be put into one theorem, so that what is left is a single named statement?

**What ran.** `lean/Capstone.lean`, built by `lake build Capstone` with exit 0 (3109f91, a3b787c). `run/corner.py`, by `run/run.sh`, through `lab run`, counts the cells the theorem leaves open; `run/pins.py` reads the pins and runs the weld check.

**What is proved.** `Capstone.OpenCorner r d`: depth at least seventeen, row at least ninety-three, and below both lines of `WeakDepths`. `only_four_zeros_outside_corner24`: with the π list on rows twenty-four to ninety-two (`Census23.StmtPiData24`) and the two-floor route (`WeakDepths.StmtRoute13`, the conclusion of `RouteSharp.weakWindow13_of_RH`, which takes only RH), every zero of the true table outside the open corner is one of the four. It assembles the census through row ninety-two, `Census23`, and `only_four_zeros_rh_line37`. Its pin reads `pins.pins.only_four_zeros_outside_corner24.axioms` "propext, Classical.choice, Quot.sound"; the weld check passed with `pins.welds_ok` 20 welds and `pins.welds_broken` 0 broken.

**What the open corner holds.** All `corner.cells_to_92` 4186 cells to row ninety-two are covered. Past it, to row one hundred, the theorem covers `corner.to100.covered` 131 of `corner.to100.cells_past_92` 764 cells and leaves `corner.to100.open` 633 open; to row one hundred and sixty, `corner.to160.covered` 1616 of `corner.to160.cells_past_92` 8534, `corner.to160.open` 6918 open; to row four hundred, `corner.to400.covered` 17164 of `corner.to400.cells_past_92` 75614, `corner.to400.open` 58450 open.

**What is left.** The theorem the loop stops on is this one with two inputs discharged and one region emptied: the π list on rows twenty-four to ninety-two proved, and `OpenCorner` shown to hold no zero. The corner units, from corner-harmonics to exact-certificates, measured its structure: a comb of zeros near the odd harmonics of π over log two, whose leaders, cancellation and beats are known.
