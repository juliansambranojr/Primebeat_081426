---
id: 0649
date: 2026-11-28
type: measurement
title: The zero cells of the b-adic tables, bases 2 to 10, and the base-4 table as a binomial sum of base-2 cells
refs: [lean/Capstone.lean::OpenCorner]
supersedes: []
follows: 0648
sealed: false
---

**Question.** Julian: the b-adic tables are all connected, reading the same primes; base 3 will not have the four zeros, because its sampling crosses the dyadic regimes while base 2 is still in it, and the same for bases 4, 5 and on: the balance relies on the base that came before. How many zeros each base's table has, and where.

**What ran.** `run/census.py`, by `run/run.sh`, through `lab run`. Row r of base b counts the primes in the block from b to the r−1 to b to the r; a cell is the d-th backward difference, as in base 2. The prime counts are exact: base two from the π list, bases four and eight read off it, base three from `pi3n_cache.json` (O27), and bases five, six, seven, nine and ten by Lucy's method for every power up to ten to the thirteen. The method gives `census.checks.pi_1e6` 78498 primes to a million and agrees with the π list at two to the twenty (`census.checks.pi_2pow20_matches_list` true) and with the base-three cache at three to the twenty (`census.checks.pi_3pow20_matches_cache` true).

**The zeros by base.** Base two, rows to `census.bases.2.rows` 92: `census.bases.2.zeros` 4 zeros, at rows `census.bases.2.zero_cells[0][0]` 2, `census.bases.2.zero_cells[1][0]` 4, `census.bases.2.zero_cells[2][0]` 8 and `census.bases.2.zero_cells[3][0]` 20. Base three, rows to `census.bases.3.rows` 41: `census.bases.3.zeros` 1, at row `census.bases.3.zero_cells[0][0]` 2, depth `census.bases.3.zero_cells[0][1]` 1, over the numbers up to nine. Base four, rows to `census.bases.4.rows` 46: `census.bases.4.zeros` 0. Base five, rows to `census.bases.5.rows` 18: `census.bases.5.zeros` 0. Base six to `census.bases.6.rows` 16, seven to `census.bases.7.rows` 15, eight to `census.bases.8.rows` 30, nine to `census.bases.9.rows` 13 and ten to `census.bases.10.rows` 13: none.

**The base-three zero is the scaffold against the first lattice block.** Its first two rows are `census.bases.3.first_rows[0]` 2 and `census.bases.3.first_rows[1]` 2: the primes two and three up to three, and five and seven up to nine. It covers the stretch of the first two base-two zeros; after it, base three never balances in its known rows.

**Base four is base two summed.** Every base-four cell is the sum over j of the binomial C(d+1, j) times the base-two cell at row 2k − j and the same depth: `census.base4_as_base2_sum.hold` 1080 of `census.base4_as_base2_sum.cells` 1080 cells, from 1 − S² = (1 − S)(1 + S) with S the shift by one row. So a base-four cell is a positive sum of base-two cells, and each base-two zero sits inside a base-four cell that is not zero: the coarser table averages the balances away. Base eight is the same with three factors.

**What it shows.** In the rows known exactly, the balances belong to the smallest bases: base two carries the four, base three only the start where 2 and 3 meet the next primes, and bases four to ten none. The deep zero is a base-two balance alone. A zero-free base does not remove a base-two zero, since a positive sum can hold a zero term; and base three, like base two, still has rows past its known range where the zeros' part can outweigh the smooth part. Exploratory; no outcome marked.
