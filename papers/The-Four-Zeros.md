# The Four Zeros

What the exact zeros of the dyadic prime difference table are, where they sit, and what
they are made of. Source lines cite scripts in `~/GitHub/Primebeat_081426/` or named
results. Nothing here is preregistered.

Table: `cell(r,d) = Δ^(d+1)π` evaluated at `2^r`, built from block counts
`N(r) = π(2^r) − π(2^(r−1))` differenced backward down the depth axis.

---

## A · The set

**A1.** Over `r ≤ 62`, `d ≤ 61` the dyadic table has exactly four exact zeros:
**(2,1), (4,1), (8,3), (20,6)**. No others.
`O16_centered_difference_table.py`

**A2.** Reproduced from an independently written construction over `r ≤ 41`, and again
over `r ≤ 45` and 1035 cells.
`O27_joint_dyadic_triadic_table.py · O35_nearmiss_residuals.py`

**A3.** The dyadic table itself was validated against the frozen bundle: 247 cells
compared, 0 mismatches.
`O16 GATE A · results/O16_run2.log against files (2)/unit_weighted_dyadic_table.csv.
NOT O27 — O27 runs no such comparison.`

**A4.** The **centered** (skew-adjoint) difference table has no exact zeros anywhere,
`r ≤ 62`, `d ≤ 30`.
`O16`

**A5.** The **triadic** table has one, (2,1), and it is trivial: `(1,3]` holds {2,3} and
`(3,9]` holds {5,7}, both count 2.
`O27`

---

## B · What a zero is

**B1.** `cell(r,d) = cell(r,d−1) − cell(r−1,d−1)`, so a zero at `(r,d)` states exactly that
the two cells feeding it are equal.
`definition`

**B2.** Verified at both deep zeros:

```text
(20,6) = 0   ⟺   d5 at r=19 and r=20 are both 623
 (8,3) = 0   ⟺   d2 at r=7  and r=8  are both 4
```

`O27 · Zeros.zero_at_20_6_of_repeat · Zeros.zero_at_8_3_of_repeat`

**B3.** Minimal form of the deep zero: `Δ⁷π(2ⁿ) = 0` at `n = 20` — eight values of `π`
spanning `2^13` to `2^20`.
`B1 · OEIS A007053`

**B4.** The stencil weights are `(−1)^k C(7,k)` = `+1, −7, +21, −35, +35, −21, +7, −1`.
Positive arm sums to 64; negative arm sums to 64.
`Newton`

**B5.** `Δ⁷` annihilates every polynomial of degree ≤ 6, so all moments of the stencil up
to the sixth vanish — not merely the total.
`B4`

**B6.** Therefore a zero states that `π` is symmetric to seventh order about the stencil's
midpoint, which lies at `2^16.5` — between samples, never on one.
`B4 + B5`

**B7.** **The zeros are forced.** Fix the depth-0 row and every cell of the table is
determined — the recurrence has no parameter, the weights are Pascal's rather than a
design choice, and the row is itself fixed by `π`. So a zero is not a placement but a
consequence: nobody put it there and nobody could have put it elsewhere.
`Construction.unique_of_isTableOf · Construction.eq_of_same_row`

**B8.** That is proved with **no axioms at all** — not `propext`, not `Classical.choice`.
It is the tightest result in the tree, and it is tight precisely because it says nothing
about `π`: it is a statement about the construction, which is pure computation.
`Construction.lean § Axiom check · Formalization.md § B4`

**B9.** Forced is not located, and not meaningful. Determinism is a property of the
construction; whether `π`'s particular values vanish at these four cells *for a reason*
is a property of `π`, and nothing here reaches it. `Zeros.lean` states that hole and
leaves it open.
`B7 + Zeros.measured_zeros_all_vanish` — a theorem computing all four
from `pi2` with no axioms, not the transcribed list

**B10.** Stated once, plainly: the economical reading of the four zeros is a
shallow-row accident. Cells grow like `2^r` while exact hits require exact
cancellation, so vanishing is cheap in the shallow rows and improbable ever
after — which is what O43's `magnitude_floor` verdict says, and why K_new = 0
over 2295 further cells surprised no decision rule. Nothing measured or proved
in this tree argues against that reading; B9's hole is where an argument for
more would have to live, and it is empty.
`B9 · O43 verdict magnitude_floor · preregs/extended_zero_census_v1_locked_20260818.md`

---

## C · Windows

**C1.** Depth `d` spans a value window of ratio `b^(d+1)`. So (8,3) spans `2^4 = 16` and
(20,6) spans `2^7 = 128`.
`definition`

**C2.** `7` is prime, so `2^7` is not a power of any smaller integer base. No integer base
below 128 reaches that window at integer depth.
`C1`

**C3.** `4 = 2²`, so base 4 at depth 1 spans exactly the window of base 2 at depth 3.
`C1`

**C4.** Therefore the two deep zeros are different kinds of object: (20,6) is reachable
only from base 2; (8,3)'s window is shared.
`C2 + C3`

**C5.** Matching by window ratio, base 3 would need depth `log128/log3 = 4.42` for (20,6)
and `2.52` for (8,3). Neither is an integer.
`C1`

---

## D · Position, not count

**D1.** Zeroing the counts of 2, 3, 5 leaves both deep zeros exactly 0. The Pascal reach of
a perturbation at block `r₀` is `r₀ ≤ r ≤ r₀+d`; the stencils read blocks 5–8 and 14–20.
`O30_silence_scaffold_primes.py`

**D2.** Deleting those same three integers from the line, so it closes up, destroys both.
`(20,6)` reads **70**.
`O31_excise_scaffold_primes.py`

**D3.** Three integers removed from four million move a cell from 0 to 70 because by depth
6 the smooth part is gone and the cells sit at ~10² against d0's ~10⁵.
`O31 · d0 at r=22 unchanged at 140336`

**D4.** Therefore a zero is a statement about **where** primes sit, not how many lie below.
`D1 + D2`

**D5.** The detected frequencies survive both operations.
`O32_excised_gamma_check.py`

---

## E · The complementary side

**E1.** `prime(r,d) + composite(r,d) = (b−1)^(d+1)·b^(r−1−d)`, exact at every cell.
`O16 · identity_a_backward, 1953 cells checked, 0 mismatches, for b = 2.
O27 computes no composite side; the general-b form is derivation, verified only at b = 2.`

**E2.** At the four zeros the composite arm therefore carries the whole term:
`1, 4, 16, 8192`.
`E1`

**E3.** The ratio `composite/prime` has a pole at exactly those four cells.
`E2`

**E4.** Centered differences give `composite_C(r,d) = 3^d·2^(r−1−d) − prime_C(r,d)`.
`O16`

---

## F · Where they sit

**F1.** All four zeros lie at `r ≤ 20`, where cells are single- to triple-digit. Beyond
that the cells run to 10⁵ and 10⁹.
`O35`

**F2.** Nearest approaches at `r ≥ 15`, by relative collapse `|cell(r,d)|/|cell(r,d−1)|`:
(39,14) at 1.6e−2, (43,39) at 9.2e−2, (17,5) at 1.0e−1.
`O35`

**F3.** Smallest absolute values at `r ≥ 15`: (17,5) = 24, (15,4) = 25, (15,5) = −48.
`O35`

**F4.** F2 and F3 rank differently. There is no canonical normalizer for "near miss".
`F2 + F3`

---

## G · Background: the lattice they sit in

**G1.** The `6k±1` lattice is generated by 2 and 3; everything in it is coprime to 6.
`sieve of Eratosthenes`

**G2.** Each prime `p ≥ 5` first contributes a composite to that lattice at `p²`:
25, 49, 121, 169.
`G1`

**G3.** Between `p_k²` and `p_{k+1}²` every composite in the lattice factors entirely into
the primes already in play.
`G2`

**G4.** `35 = 5 × 7` is the first cross-term — two distinct primes above the scaffold
reaching into it together, arriving long before 11 can at 121.
`G2 + G3`

**G5.** In arithmetic topology a prime is a knot in `Spec(Z)`, a composite `pq` is a
two-component link, and the Legendre symbol is the linking number mod 2.
`Mazur · Kapranov–Reznikov · Morishita — external literature, not cited in this project's
REFERENCES.md and not verified against it`

**G6.** `(5/7) = (7/5) = −1`, so the 5-knot and the 7-knot are linked — G4 restated.
`G5 · quadratic reciprocity`

**G7.** G5 indexes by primes; the difference table indexes by cutoffs `b^r`. No map is
known between them.
`open`

---

## H · Not established

**H1.** Whether four is the complete set beyond `r ≤ 62` is unknown
unconditionally. Under RH it is settled at every depth `d ≤ 15` — § I.
`A1`

**H2.** Whether (20,6) is the last vanishing is unknown unconditionally.
Under RH it is the last at every depth `d ≤ 15`, for all `r` — § I.
`open`

**H3.** C5's non-integer matched depths predict a smear rather than a strike in base 3.
Never measured.
`open`

**H4.** The zeros are made of the zeta zeros only in the sense of B6 plus the residual
account — the model reproduces 80% of the residual at (20,6), which is not a vanishing.
`O34_zeta_residual_model.py`

---

## I · Under RH, (20,6) is the last — at every depth up to 15

**I1.** Under RH, `cell(r,d) ≠ 0` for every `r ≥ R(d)`, with `R(d)` explicit and
roughly `5d + 11`: `R(1) = 16`, `R(6) = 45`, `R(15) = 91`.
`O67_conditional_last_zero.py · results/conditional_last_zero.json`

**I2.** The proof is five steps, each elementary. The cell is the alternating
binomial stencil on `π(2^(r−k))` (B4, `Zeros.tableFrom_eq_stencil`). Split
`π = li + (π − li)`. The li part is a `(d+1)`-fold difference of `li(2^x)` at
unit step, hence by the iterated mean value theorem the `(d+1)`-th derivative at
some `ξ ∈ (r−d−1, r)`. That derivative is `2^ξ` times an alternating series in
`1/ξ` whose term ratio stays below `0.4905` in the wedge `d ≤ 0.34(r−d−1)`,
giving `M ≥ 0.5·2^(r−d−1)(log 2)^d / r`. Schoenfeld's explicit RH bound
`|π(x) − li(x)| ≤ √x log x / 8π` (for `x ≥ 2657`, i.e. `r − d − 1 ≥ 12`) caps
the error at `(log 2 / 8π)·r·2^(r/2)·(1 + 2^(−1/2))^(d+1)`. Main beats error
from `R(d)` on.
`I1 · the alternating-series and MVT steps verified numerically at nine points
in the artifact`

**I3.** Combined with the census: O43 verified no exact zeros beyond the four
for all `r ≤ 92` on published `π(2ⁿ)`, and `R(d) ≤ 91` for every `d ≤ 15`. So
**under RH the four zeros are the complete set at every depth `d ≤ 15`, for all
`r`** — the theorem covers `r ≥ R(d)` and the census covers `r ≤ 92`, with
overlap.
`I1 · CONTEXT.md § Current state of the world, O43`

**I4.** What remains open, stated exactly. The result is conditional on RH. At
depths `d ≥ 16` a finite strip is unchecked, starting at three cells
`r ∈ {93, 94, 95}` at `d = 16`; published values of `π(2ⁿ)` above 92 would close
successive strips. And the deep region `d > 0.34(r−d−1)` is untouched — there
Schoenfeld does not reach the window bottom and the derivative series is
uncontrolled, so a different argument is needed. B10's accident reading is
sharpened, not replaced: under RH, nothing more arrives in the shallow table,
and the deep table remains the open side.
`I1 · B10`

**I5.** The arrow is in Lean; the analytic leaves are not. `lean/Nonvanishing.lean`
proves the implication in the house pattern — Schoenfeld-on-the-window and the
main-term floor enter as named hypotheses, and the kernel checks that the
"therefore" is real: `Nonvanishing.error_bound` (the binomial-weighted Schoenfeld
sum), `Nonvanishing.nonvanishing_of` (the arrow), and
`Nonvanishing.tableFrom_ne_zero_of` (the conclusion on the integer table). What
remains unformalised is exactly the leaves: the MVT/alternating-series bound
(stage 2, feasible) and Schoenfeld itself, which is in no proof assistant.
`Nonvanishing.error_bound · Nonvanishing.nonvanishing_of ·
Nonvanishing.tableFrom_ne_zero_of`
