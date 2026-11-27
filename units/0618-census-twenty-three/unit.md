---
id: 0618
date: 2026-11-27
type: formalization
title: The four zeros in rows 1 to 23, every depth, from the primes; the pi input narrowed to rows 24 to 92
refs: [lean/PiRow23.lean::pi23, lean/PiRow23.lean::piData_le23, lean/Census23.lean::only_four_zeros_le23, lean/Census23.lean::piData23_of_24, lean/PiW23.lean::W23]
supersedes: []
follows: 0617
sealed: false
---

**Question.** Can the census with nothing assumed reach the twenty-third row, and narrow the named π input to rows twenty-four to ninety-two?

**What ran.** `lean/PiW23.lean`, the `lean/PiL23_*.lean` blocks, `lean/PiRow23.lean` and `lean/Census23.lean`, each built by `lake build` with exit 0 (a3b787c). `run/table.py`, by `run/run.sh`, through `lab run`, sieves to the twenty-third row and lists every zero of the table there; `run/pins.py` reads the pins and runs the weld check.

**What is proved.** `PiRow23.pi23`: the prime count at two to the twenty-third is `table.pi23` 564163, by Legendre's formula, its terms in `table.row23_block_files` 70 block files so the kernel holds one at a time. The assembly's seventy-way case split needed a raised recursion limit. `Census23.only_four_zeros_le23`: in rows one to twenty-three, at every depth, the only zeros are the four, with no named input; pin `pins.pins.only_four_zeros_le23.axioms` "propext, Classical.choice, Quot.sound". `piData23_of_24` narrows the named π input to rows twenty-four to ninety-two.

**The check outside Lean.** The sieve gives `table.pi22` 295947 at the twenty-second row and `table.pi23` 564163 at the twenty-third, and the `table.cells` 253 cells below the diagonal hold `table.n_zeros` 4 zeros: (`table.zeros[0][0]` 2, `table.zeros[0][1]` 1), (`table.zeros[1][0]` 4, `table.zeros[1][1]` 1), (`table.zeros[2][0]` 8, `table.zeros[2][1]` 3), (`table.zeros[3][0]` 20, `table.zeros[3][1]` 6). The weld check passed with `pins.welds_ok` 20 welds and `pins.welds_broken` 0 broken.

**A correction.** The commit a3b787c named the wrong number in its message: it gave the sum of the Legendre terms in place of the prime count. The theorem states the prime count above, and the sieve agrees with it.

**What is left.** Rows twenty-four and twenty-five are generated; their blocks exceeded one process's memory and were split to one term per file; their kernel build is running.
