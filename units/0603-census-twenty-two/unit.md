---
id: 0603
date: 2026-11-27
type: formalization
title: The four zeros in rows 1 to 22, every depth, from the primes
refs: [lean/Census22.lean::only_four_zeros_le22, lean/PiRow22.lean::pi22, lean/PiRow22.lean::piData_le22, lean/PiW22.lean::W22, lean/Legendre.lean::primeCounting_eq_phi]
supersedes: []
follows: 0601
sealed: false
---

**Question.** Can the census with nothing assumed reach the twenty-second row, the first past the rows Legendre's formula had been run to?

**What ran.** `lean/PiW22.lean`, the `lean/PiL22_*.lean` blocks, `lean/PiRow22.lean` and `lean/Census22.lean`, each built by `lake build` with exit 0 (471f836). `run/table.py`, by `run/run.sh`, through `lab run`, sieves to the twenty-second row and lists every zero of the table there; `run/pins.py` reads each theorem's `#guard_msgs` pin from the tree and runs `utilities/check_weld.py`.

**What is proved.** `PiRow22.pi22`: the prime count at two to the twenty-second is `table.pi22` 295947, by Legendre's formula, with the sieve's terms split into blocks of eight so that the kernel holds one block at a time. `piData_le22` extends the verified π list through the row. `Census22.only_four_zeros_le22`: in rows one to twenty-two, at every depth, the only zeros are the four, with no named input. Its pin reads `pins.pins.only_four_zeros_le22.axioms` "propext, Classical.choice, Quot.sound".

**The check outside Lean.** The sieve agrees: the count at the twenty-first row is `table.pi21` 155611, at the twenty-second `table.pi22` 295947, and the `table.cells` 231 cells below the diagonal hold `table.n_zeros` 4 zeros, at (`table.zeros[0][0]` 2, `table.zeros[0][1]` 1), (`table.zeros[1][0]` 4, `table.zeros[1][1]` 1), (`table.zeros[2][0]` 8, `table.zeros[2][1]` 3) and (`table.zeros[3][0]` 20, `table.zeros[3][1]` 6). The weld check passed with `pins.welds_ok` 19 welds and `pins.welds_broken` 0 broken.

**What is left.** The π list past the twenty-second row is a named input (`PiNarrow.StmtPiData23`). Legendre's cost grows by about the square root per row; Meissel–Lehmer (unit 0601, meissel-lehmer) is proved but not yet run in the kernel.
