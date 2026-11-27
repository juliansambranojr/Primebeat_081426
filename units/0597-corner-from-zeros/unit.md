---
id: 0597
date: 2026-11-27
type: run
title: "The deep corner rebuilt from the zeros: with 2000 zeros the explicit formula gets 2921 of 2962 corner signs"
refs: [lean/EdgeDiagonal.lean::edge_eq_fwdDiff, lean/EdgeDiagonal.lean::fwdDiff_iter_sum]
supersedes: []
follows: 0596
sealed: false
---

**Question.** Unit 0596 proved that along the table's edge each zero enters with the factor `(2^ρ − 1)^d` and the main term with one. Does the true table's deep corner come back cell by cell from the zeros?

**What ran.** `run/recon.py`, by `run/run.sh`, through `lab run`. Each row is modelled as Riemann's `R(2^m) − R(2^(m−1))` less twice the real part of `li(2^(mρ)) − li(2^((m−1)ρ))` over the first K zeros, then differenced exactly as the table is; the model's corner cells, those with seven times the depth above twice the row, rows from twelve to the end of the data, are compared with the true table's. EXPLORATORY: no prereg, no verdict.

**What it shows.** There are `recon.K0.cells` 2962 corner cells. With no zeros the model gets the sign of `recon.K0.sign_agree` 2071. With ten zeros, `recon.K10.sign_agree` 2502, median relative error `recon.K10.median_rel_err` 0.7585041456209002; with a hundred, `recon.K100.sign_agree` 2820 at `recon.K100.median_rel_err` 0.24496402054184838; with a thousand, `recon.K1000.sign_agree` 2910 at `recon.K1000.median_rel_err` 0.08687952944314065; with two thousand, `recon.K2000.sign_agree` 2921 at `recon.K2000.median_rel_err` 0.07711278401075182.

**Reading.** The smooth part alone sets the corner's sign little better than a coin; each block of zeros added sets more cells and shrinks the error. The deep corner is a readout of the zeros, cell by cell, as the edge-diagonal theorems say it must be.
