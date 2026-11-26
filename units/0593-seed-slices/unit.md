---
id: 0593
date: 2026-11-26
type: run
title: "Julian's seed across slices: the deep balance is not a resting point of the heat flow, balance crossings run continuously through the bases with an exact one at base two, and the primes' binary blocks do not balance there"
refs: [lean/DeepZeroBand.lean::deep_zero_share, lean/Zeros.lean::zero_20_6]
supersedes: []
follows: 0578
context: Julian posited the deep balance as a seed, each b-adic table a slice of time in steps with the flow moving toward the zero beneath it, the balance perhaps in a shrinking quarter table, and primes living in the fractions as blocks
sealed: false
---

**Question.** Is the deep balance at the deep cell, row twenty at depth six, a settled state of the de Bruijn-Newman flow, does it persist as the base of the table moves, and do the primes' binary blocks balance where the primes do?

**What ran.** `run/flow.py`, `run/bases.py` and `run/blocks.py`, by `run/run.sh`, through `lab run`. The zeros' part of the cells rebuilt from unit 0578's flowed zeros; the depth-six cell with its top fixed as the base moves; the primes' binary repeat lengths row by row. EXPLORATORY: no prereg, no verdict.

**Under the flow.** With the zeros of unit 0578 the zeros' part of the deep cell is `flow.c20_6.zeros_part_t0` -403.8434988132986, truncated, and it moves through time zero without pausing: by `flow.c20_6.change_t-0.02` -22.084268237847084 a fiftieth back and `flow.c20_6.change_t0.02` 26.315369872433678 a fiftieth forward, and by `flow.c20_6.change_t0.2` 374.39042247216435 a fifth forward, which cancels most of it. Its neighbours move the same way, row twenty-one at depth six by `flow.c21_6.change_t0.2` -700.823110195491. Forward the flow flattens the cells toward their smooth part; the deep balance holds only at time zero, the actual primes.

**Across the bases.** The depth-six cell with top two to the twentieth is `bases.base2_cell_20_6` 0 at base two, and as the base runs from nineteen tenths to twenty-one tenths it changes sign or vanishes at `bases.crossings_b_1_9_to_2_1` 116 points: balance crossings run continuously through the slices, and base two is where one lands exactly on zero. The shrinking quarter table on the counting numbers is the base-four table read upward; to four to the thirteenth it has `bases.base4_zero_cells` 0 zero cells either way.

**The binary blocks.** The share of primes whose binary block has full length, two a primitive root, is `blocks.share_row20` 0.37341788533712955 at row twenty and `blocks.share_row22` 0.374558203169536 at row twenty-two, Artin's constant (Hooley, under the generalized hypothesis). At the deep cell the primes' cell is `blocks.c20_6.primes` 0 and the full-block primes' cell `blocks.c20_6.full_block` -773; at row nineteen `blocks.c19_6.primes` 343 and `blocks.c19_6.full_block` 571; at row twenty-one `blocks.c21_6.primes` 1713 and `blocks.c21_6.full_block` 1704. The blocks do not balance where the primes do.

**What it says.** The deep balance is a fact of the present slice: exact at time zero, at base two, in where the primes sit. The flow, the other bases and the binary blocks each carry the balance past or around it, and none rests on it.

What remains. What makes the crossing land exactly on zero at base two, row twenty, depth six.
