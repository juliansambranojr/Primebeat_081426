---
id: 0624
date: 2026-11-27
type: measurement
title: A check on the Mac of corner-cloud's units 0640 and 0641; they reproduce, with three weak spots
refs: [none]
supersedes: []
follows: 0623
sealed: false
---

**Question.** Do corner-cloud's units `0640` (corner-lower-bounds) and `0641` (corner-residues) reproduce on the Mac, and does what they say they show hold up?

**What ran.** `run/check.py`, by `run/run.sh`, through `lab run`. It takes both units from commit `check.commit` 73252ce8cf674bd64f774ac28715bb8706b4678c of `claude/corner-cloud` with `git archive`, reruns each unit's own `run/run.sh` in a temporary tree beside `imported/`, and compares the fresh results with the committed ones value by value. It compares the units' π list with `b007053.txt`, and it sizes unit 0640's near-harmonic family. The `2` units are on `claude/corner-cloud` and not in this tree.

**They reproduce.** The π list both units use is the same file in each (`check.pi_list.same_in_both_units` true), and its `check.pi_list.rows` 93 rows differ from OEIS b007053 in `check.pi_list.rows_differ_from_b007053` 0. Unit 0640's rerun exited `check.u0640.exit` 0 after `meta.check.u0640.seconds` 236.9 seconds, and of its `check.u0640.values` 289 values `check.u0640.values_differ` 0 differ. Unit 0641's rerun exited `check.u0641.exit` 0, and of its `check.u0641.values` 93 values `check.u0641.values_differ` 15 differ, every one of them a timing.

**Weak spot one: no dominant leader was certain before the run.** Unit 0640 finds that no cell has a leader outweighing the absolute sum of the other zero terms, and that the sum keeps growing as zeros are added. The sum of one over the height of each zero diverges, so the absolute sum grows without limit at any cell. The result holds everywhere and tells nothing particular about the corner.

**Weak spot two: the near-harmonic family is most of the weight.** Unit 0640 finds that the leader and the near-harmonic family give every sign the model gives. The family, the zeros with cos(γ log 2) below zero, is `check.family.size` 53258 of the `check.family.of` 100000 zeros. Weighted by unit 0640's own factor for each zero, raised to the depth and divided by the height, it holds `check.family.share_of_squares.d17` 0.9999978 of the sum of squares at depth `17`, and `check.family.share_of_squares.d67` 1.0 to seven places at depth `67` (`check.family.share_of_squares.d120` 1.0 at `120`, `check.family.share_of_squares.d354` 1.0 at `354`). So its sign agreement is close to automatic.

**Weak spot three: the time for row 93 does not hold still.** Unit 0641 extrapolates its parity identity's time to row `93` from a fit to its timings. The committed fit has slope `meta.check.u0641.log2_time_slope_per_row.committed` 0.484 per row and gives ten to the `meta.check.u0641.extrapolated_log10_seconds_row93.committed` 6.6 seconds. This rerun has slope `meta.check.u0641.log2_time_slope_per_row.mac` 0.424 and gives ten to the `meta.check.u0641.extrapolated_log10_seconds_row93.mac` 5.1. The row `46` time was `check.u0641.46.committed` 0.544 seconds there and `check.u0641.46.mac` 0.121 here. The fits sit on timings of a fraction of a second, below the method's own slope of one half. An earlier rerun this session gave other timings again, and its figures went to corner-cloud in `notes/corner-questions.md` (`cd7bdb48`). At slope one half from this rerun's row `46` time, row `93` takes about `check.u0641.days_row93_at_slope_half_from_mac` 16.6 days.

**What it shows.** Corner-cloud's `2` units are reproducible: same inputs, same numbers. Two of unit `0640`'s headline readings follow from facts known before its run. Unit `0641`'s extrapolated time moves by more than an order of magnitude between runs. Corner-cloud's own C version, in question 6 of `notes/corner-questions.md`, also puts row `93` at about sixteen days. Exploratory; no outcome marked.
