# The Composite Arm

> **PROVISIONAL — written before its script exists. Not canonical.**
>
> Every figure below was computed inline during conversation on 2026-08-20 and
> exists in no results file. That is the failure `What-Didnt-Work.md` § D1
> records — writing the record from something other than an artifact — and this
> document is knowingly in that state because the alternative was losing the
> numbers to a compaction.
>
> **Before this becomes canonical, all of:**
>
> 1. Write `t25_composite_arm.py`, tee'd, computing every figure below from
>    `primecountpy` rather than transcribed from here.
> 2. Re-verify each number against `results/t25_composite_arm.txt`. Any that
>    does not reproduce is wrong here, not there.
> 3. Decide placement. `The-Four-Zeros.md` § E is already "The complementary
>    side" — E1 the pair identity, E2 the composite arm at the four zeros, E3
>    the pole. This may belong there as an extension rather than as a twelfth
>    paper. That is Julian's call and it is open.
> 4. If it stays standalone, add it to whatever index the repository settles
>    on, and remove this header.
>
> Until then: **a lead, not a record.**

The prime arm has been the subject of every measurement on this bench. Its
complement was used as a counterweight — the thing that makes the total
prime-free — and never examined as an object with behaviour of its own. This is
what is there, and why looking was reasonable to postpone.

---

## A · The arm carries no independent information

**A1.** `prime(r,d) + composite(r,d) = (b−1)^(d+1)·b^(r−1−d)`, exact at every
cell in every base. Verified at all 492 nonzero dyadic cells with `d ≥ 1`.
`PairIdentity.pair_identity · Euler-Factor-Chain.md § I1 · PENDING t25`

**A2.** The right-hand side contains no primes, so
`composite = (closed-form surface) − prime`. Anything the composite arm knows,
the prime arm already knows, and the surface is computable without either.
`A1`

**A3.** Sharper still, the residuals are exact negatives:
`prime_residual + composite_residual = 0` at every cell, because the geometric
term appears with the same coefficient in the value and in the smooth model and
cancels on subtraction.
`Euler-Factor-Chain.md § I2, I3`

**A4.** So there was a correct reason not to look, and it is A2 rather than
neglect. What A2 does not say is that the two arms behave alike — `composite`
is a different **function** of `(r,d)` even though it is not different data.
`A2`

---

## B · The census nobody ran

**B1.** Over `r ≤ 32`, `d ≥ 1`, the prime arm has four exact zeros —
`(2,1), (4,1), (8,3), (20,6)`. The composite arm has **one**, at `(3,2)`.
`PENDING t25 · The-Four-Zeros.md § A1 for the prime side`

**B2.** A composite zero is the reciprocal pole. Where it vanishes, the **prime**
arm carries the entire geometric total by itself — the mirror of
`Euler-Factor-Chain.md` § I5, which records the pole where the prime arm
vanishes. The reciprocal question was never asked.
`B1 · Euler-Factor-Chain.md § I5`

**B3.** But `(3,2)` has `r − d = 1`, which is the least protected coordinate in
the table. `SeedPerturbation.cell_eq_of_seed_perturbation` protects only cells
with `r − d > R_e`, and any convention change with `R_e ≥ 1` reaches this one.
`B1 · lean/SeedPerturbation.lean`

**B4.** So the composite arm's single zero is convention-dependent, exactly as
the prime arm's `(2,1)` is. The count "one" is a count under one seed
convention, and both deep prime zeros at `r − d = 5` and `14` have no
counterpart on the composite side at any protected coordinate.
`B3 · SeedPerturbation.md protections at R_e = 2 and R_e = 3`

---

## C · The arms cross, and never in the other order

**C1.** Both arms eventually go negative with depth. On every diagonal checked,
`r − d = 4` through `18`, the **prime arm goes negative first and the composite
arm follows**:

```text
   diag   prime first < 0   composite first < 0   lag
      4          2                  5              3
      5          5                  6              1
      6          4                  7              3
      7          5                  9              4
      8          7                  8              1
      9          6                  7              1
     10          5                  8              3
     11          6                 10              4
     12          8                  9              1
     13          7                 10              3
     14          8                 11              3
     15          7                 12              5
     16          8                 13              5
     17          9                 12              3
     18         10                 13              3
```

`PENDING t25`

**C2.** The **sign is invariant, the size is not.** The composite arm follows on
all fifteen diagonals without exception; the lag ranges 1 to 5 and is not
monotone in the diagonal.
`C1`

**C3.** This corrects a claim already in the record. `The-Fold.md` § C8 reports
the crossing as two cells — `(23,10)` reading `−8656` composite against `+12752`
prime, and `(25,11)` reading `−22493` against `+30685`. Those are two entries of
C1's table, at diagonals 13 and 14. The phenomenon is systematic across every
diagonal, not two cells.
`C1 · The-Fold.md § C8`

**C4.** It also corrects something said in conversation and not yet written
anywhere: the lag was described as "three to five depths." It is not. Five of
the fifteen diagonals have a lag of exactly 1.
`C1`

---

## D · What it is not

**D1.** It is not the missing bridge. `The-Four-Zeros.md` § G7 records that the
arithmetic-topology picture indexes by primes while the table indexes by cutoffs
`b^r`, with no known map between them. The composite arm indexes by `b^r`
exactly as the prime arm does, so it does not cross that gap.
`The-Four-Zeros.md § G5, G7`

**D2.** It is not new data. A2 stands: every composite cell is the surface minus
the prime cell, and the surface is prime-free.
`A2`

**D3.** And B1's asymmetry — four against one — is not yet a fact about the
primes, because B3 makes the one convention-dependent and the four are not all
protected either. `(2,1)` moves; `(4,1)`, `(8,3)`, `(20,6)` do not.
`B3 · SeedPerturbation.lean`

---

## E · Not established

**E1.** Whether the sign invariance of C2 has a mechanism. The prime arm running
`b^(r/2)` against the total's `b^r` would predict the prime arm reaching zero
first, but nothing here derives the ordering and nothing bounds the lag.
`C2`

**E2.** Whether `(3,2)` survives any convention. B3 says the theorem does not
protect it; whether it in fact moves has not been measured against the imported
tables, which `lab_notebook` entries 46 and 47 record as carrying composite
zero-counts of 1, 4, 1, 3 and 2 under five different silencing conventions.
`B3 · imported/lattice_mapper/`

**E3.** Whether a composite zero at a **protected** coordinate exists anywhere.
The search was `r ≤ 32`, and nothing looked deeper or at another base.
`B1`

**E4.** No prereg, and no script. See the header.
`CLAUDE.md § Prereg discipline`
