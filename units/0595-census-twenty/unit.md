---
id: 0595
date: 2026-11-27
type: formalization
title: "The four zeros in rows 1 to 20, every depth, proved from the primes with nothing assumed"
refs: [lean/Census20.lean::only_four_zeros_le20, lean/Census20.lean::zero_20_6_true, lean/PiRow20.lean::piData_le20, lean/PiSieve.lean::isPrimeB2_iff, lean/PiChunks.lean::count_total]
supersedes: []
follows: 0594
sealed: false
---

**Question.** Can the census of the true dyadic table be proved in Lean with no named input at all, no list of prime counts taken on trust and no bound on the error, for the rows the kernel can count itself?

**What ran.** The proofs are Lean files, each built by `lake build` with exit 0 and pinned by `#guard_msgs` at `propext, Classical.choice, Quot.sound`. `run/census.py`, by `run/run.sh`, through `lab run`, checks outside Lean the numbers the files state.

**The prime counts.** `PiSieve` counts primes by trial division over two and the odd numbers, with its test proved equal to `Nat.Prime` (`isPrimeB2_iff`) and its count to `Nat.count` (`cnt2_eq`); the kernel evaluates it with `decide +kernel`, no `native_decide`. From the fifteenth row on, the count runs in blocks, each block in its own file stating one step `count (a + l) = count a + v`, joined by `omega`, so no single check holds a whole row. The last rows are `census.pi_2_19` 43390 and `census.pi_2_20` 82025 (`PiRow20.pi20`).

**The census.** Every cell in rows 1 to 20 reads the prime count only at rows up to 20. `Census20.only_four_zeros_le20` states that at every depth the only zeros of `ToInfinity.trueRow`'s table in those rows are (2,1), (4,1), (8,3) and (20,6). Across the `census.cells_checked` 190 cells the script finds the same `census.n_zeros` 4. `zero_20_6_true` states that (20,6) is a zero of the true table: the two cells one depth above it are `census.cell_20_5` 623 and `census.cell_19_5` 623.

**What it settles.** The bottom of the table, through its deepest known zero, holds as a theorem about the primes themselves, with no RH, no FKS2 table and no data list. The rows above twenty still rest on the named input `PiNarrow.StmtPiData21`.

**Correction recorded.** Commit c1dbe37 claimed the sixteenth row before its compile had finished; the compile was killed for memory and a pipe hid the exit code. Commit 013744e said so, and every module since is checked by its exit code.
