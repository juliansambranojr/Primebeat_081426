---
id: 0600
date: 2026-11-27
type: formalization
title: "At a prime-power depth a cell is two rows mod p: 1463 of the 1850 such cells to row 92 are kept off zero by that alone"
refs: [lean/ParityCell.lean::two_dvd_cell_two_pow, lean/ParityCell.lean::ne_zero_of_parity, lean/ParityCell.lean::prime_dvd_cell_prime_pow, lean/ParityCell.lean::ne_zero_of_prime_pow]
supersedes: []
follows: 0599
sealed: false
---

**Question.** No size bound reaches the deep corner. Does the table's integer structure keep cells off zero there?

**What ran.** `lean/ParityCell.lean`, built by `lake build` with exit 0 and pinned by `#guard_msgs` at `propext, Classical.choice, Quot.sound`. `run/ppcells.py`, by `run/run.sh`, through `lab run`, checks the congruence and counts what it settles on the data.

**What is proved.** For a prime `p` the binomials `C(p^k, i)` with `0 < i < p^k` are divisible by `p`, so the depth-`p^k` stencil keeps only its two end terms mod `p`: the cell is `N r + (−1)^(p^k)·N (r − p^k)` mod `p` (`prime_dvd_cell_prime_pow`; for two, `two_dvd_cell_two_pow`). When that combination of two rows is not divisible by `p` the cell is not zero (`ne_zero_of_prime_pow`, `ne_zero_of_parity`). The statement holds at every row and every prime-power depth, with nothing about the cell's size.

**On the data.** The congruence holds in `ppcells.congruence_holds` 1850 of the `ppcells.cells` 1850 cells at the `ppcells.depths` 34 prime-power depths, and keeps `ppcells.settled` 1463 of them off zero from two rows alone. At depth two it settles `ppcells.by_depth.2.settled` 34 of `ppcells.by_depth.2.cells` 90, at seven `ppcells.by_depth.7.settled` 77 of `ppcells.by_depth.7.cells` 85, at eleven `ppcells.by_depth.11.settled` 77 of `ppcells.by_depth.11.cells` 81, at twenty-five `ppcells.by_depth.25.settled` 54 of `ppcells.by_depth.25.cells` 67, at forty-nine `ppcells.by_depth.49.settled` 36 of `ppcells.by_depth.49.cells` 43 and at sixty-four `ppcells.by_depth.64.settled` 14 of `ppcells.by_depth.64.cells` 28: a pair fails the test about one time in `p`.

**What it does not do.** The test reads the rows `a(r)` themselves, mod `p`. For rows past the computed range those values are not known, so the congruence settles cells only where the prime counts are; it does not carry the census to infinity. Lucas's theorem extends it to every depth with a sum over the rows whose base-`p` digits sit under those of `d`, with the same limit.
