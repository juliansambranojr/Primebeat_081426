---
id: 0607
date: 2026-11-27
type: measurement
title: The steeper line, and what the error bounds leave: about four in five cells past row 92 are in the deep corner
refs: [lean/WeakDepths.lean::two_rpow_185, lean/WeakDepths.lean::line_base37, lean/WeakDepths.lean::weak13_lt_floor_far37, lean/WeakDepths.lean::only_four_zeros_rh_line37]
supersedes: []
follows: 0606
sealed: false
---

**Question.** How much of the table past the first uncomputed row do the proved theorems cover, once the line is pulled as far toward its limit as the constant-thirteen route allows?

**What ran.** `lean/WeakDepths.lean`, compiled by `lake env lean` with exit 0 (43448f2). `run/count.py`, by `run/run.sh`, through `lab run`, counts the cells past row ninety-two that the theorem's conditions leave out; `run/pins.py` reads the pins and runs the weld check.

**The steeper line.** `only_four_zeros_rh_line37`: a zero at depth up to sixteen, in a row at least four times the depth plus thirty, or at depth thirty or more in a row at least three point seven times the depth plus thirty-nine, is one of the four, given the π list (`PiNarrow.StmtPiData23`) and the two-floor route. `line_base37` carries the line's arithmetic to every depth from thirty by induction, with `two_rpow_185` bounding the per-depth growth of the right side. At depth one hundred the line moves from row `count.line_at_d100.old` 430 to `count.line_at_d100.steep` 409. Its pin reads `pins.pins.only_four_zeros_rh_line37.axioms` "propext, Classical.choice, Quot.sound"; the weld check passed with `pins.welds_ok` 20 welds and `pins.welds_broken` 0 broken.

**What is left.** Up to row one hundred, `count.to100.open` 633 of the `count.to100.cells` 764 cells past row ninety-two are outside every proved condition, a share of `count.to100.open_share` 0.829; up to row two hundred, `count.to200.open` 12588 of `count.to200.cells` 15714 (`count.to200.open_share` 0.801); up to row four hundred, `count.to400.open` 58450 of `count.to400.cells` 75614 (`count.to400.open_share` 0.773). The error bounds reach the depths below about a quarter of the row, and the share they leave falls only slowly toward the limit their slope allows.

**What it means.** The deep corner holds most of the table. Each of its cells is a sum over the zeros of zeta, and the theorem the loop stops on needs every one of them held off zero.
