---
id: 0475
date: 2026-11-23
type: run
title: Row r from the rows up to r/2: the sieve's sum by Pascal level, and how its small roundings cancel; EXPLORATORY
refs: [lean_stage3/Stage3/CellZeros.lean::stencil_mode, lean_stage3/Stage3/MirrorArea.lean::restoringForce_eq_log_ratio]
supersedes: []
follows: 0474
context: Julian holds that the table is Pascal all the way down and that the half is what conditions it; on 2026-11-23 he asked what happens when a tiny error scales in something precise, and what the restoring force is; the sieve writes the count at a row from the primes up to half the row
sealed: false
---

**Question.** Is the count at row r carried by the rows up to half of r, and what becomes of the small roundings in that sum as the row grows?

**What ran.** `run/half.py`, through `run/run.sh`, on the repo's cache of the count at the doublings. EXPLORATORY: no prereg, no decision rule, no verdict. For each row from `half.row_lo` 10 to `half.row_hi` 24 the count at the doubling was built by the sieve from the primes up to the square root of the doubling alone: an alternating sum, over the squarefree numbers made of those primes, of how many times each goes into the doubling. The sum was taken by level, the level being how many primes the number is made of; the sign alternates with the level, as along a row of Pascal. Each term is an exact fraction less a rounding below the unit.

**The half carries the row, exactly.** In all `half.rows_checked` 15 rows the sum gave the table's count with no remainder. At row `half.rows[14].r` 24 it used the `half.rows[14].primes_used` 564 primes up to `half.rows[14].primes_used_up_to` 4096, in `half.rows[14].terms` 2664092 terms over `half.rows[14].levels` 9 levels, and returned `half.rows[14].pi_by_sieve` 1077871, the table's `half.rows[14].pi_in_table` 1077871.

**The roundings.** At that row the roundings, each below the unit, add in size to `half.rows[14].rounding_mass` 1168689.842. That is more than the count itself. With their signs they add to `half.rows[14].net_rounding` -31749.165, a share `half.rows[14].net_over_mass` 0.027166 of their mass. The count's distance from its smooth part there is `half.rows[14].residual_pi_minus_li` -350.7, a share `half.rows[14].residual_over_mass` 0.00030008 of that mass, and `half.rows[14].residual_over_sqrt` -0.0856 times the square root of the doubling.

Both shares fall as the row grows. The net over the mass: `half.rows[0].net_over_mass` 0.065962 at row `half.rows[0].r` 10, `half.rows[6].net_over_mass` 0.059159 at row `half.rows[6].r` 16, `half.rows[10].net_over_mass` 0.038805 at row `half.rows[10].r` 20, `half.rows[14].net_over_mass` 0.027166 at the last. The residual over the mass: `half.rows[0].residual_over_mass` 0.1393179, `half.rows[6].residual_over_mass` 0.00978351, `half.rows[10].residual_over_mass` 0.00158038, `half.rows[14].residual_over_mass` 0.00030008.

By level at the last row, the number of terms runs `half.rows[14].level_terms[1]` 564, `half.rows[14].level_terms[2]` 158766, `half.rows[14].level_terms[3]` 928670, `half.rows[14].level_terms[4]` 1073086, `half.rows[14].level_terms[5]` 437277, `half.rows[14].level_terms[6]` 63222, `half.rows[14].level_terms[7]` 2500, `half.rows[14].level_terms[8]` 6, rising to the middle and falling, and the roundings' mass by level follows it: `half.rows[14].level_mass[3]` 415696.849 and `half.rows[14].level_mass[4]` 464178.748 at the two middle levels, with opposite signs.

**What it is.** The count at a row is made, with nothing left over, from the primes up to half the row, by a sum with the shape of Pascal. Inside that sum the small roundings do scale: taken in size they outgrow the count. They do not show in the count, because neighbouring levels carry opposite signs and comparable mass, and what is left after they meet shrinks, as a share, row by row. The count comes out a whole number every time.

**What it is not.** The run shows that the roundings cancel on these rows and how far. It does not show why they must cancel to the size of the square root at every row; a proof of that from the sum itself would be a proof of the Riemann hypothesis, and the sieve's sum is known to resist it. The net rounding is not an error in the count: together with the exact fractions it is the count. Rows to `half.row_hi` 24 only.
