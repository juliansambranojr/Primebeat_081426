# NEXT — the Lean work order

Three of the original four unpaired measurements are closed; § 2 is still
live, and § 5 is the queue that came out of the 2026-08-27 session.

Handoff file. Hand this back verbatim after a compaction; it is written to be
executed without the session that produced it.

## Resume in 30 seconds

```bash
cd ~/GitHub/Primebeat_081426/lean && lake build     # expect 8050 jobs, success
```

Toolchain trap: elan defaults to 4.33, Mathlib here is **v4.28.0**. Run from
`lean/` so the `lean-toolchain` pin applies, or you get `incompatible header`.

Already built, all `sorry`-free, axioms `propext / Classical.choice / Quot.sound` only:

```text
24 modules, 282 theorems, 282 #guard_msgs-pinned axiom checks.
Six modules are Mathlib-free. See BUILD.md for the module map and
lean/THEOREMS.md for the generated index.
```

**Method, non-negotiable.** Do not aim a proof at a measured number. Write the
*mechanism* as a derivation; the measurement is the falsifier, not the target.
Lean rules on the logic, the artifacts rule on the world, neither of us
adjudicates. Every literal must be read out of `results/*.json` or a `.log` at
the time of writing — reading from prose is what produced this session's errors.

---

## 1 · G4 peak — **CLOSED** by `GeneratorPeak.lean`

The mechanism below was written as a derivation and **refuted**:
`no_interior_peak` proves the power-law tradeoff has none, while
`measured_has_interior_peak` pins the measurement that it does. The
account is dead and the kernel says so. Kept for the record.

`P_max/median` peaks at G4 = {2,3,5,7} across all three settings: 26.733822
(xmax 1.5e8), 31.371849 (1e9), 38.299307 (3e9).

**Mechanism.** A tradeoff in the generator count `k`, two terms pulling opposite ways:

```text
resolution     k generators under X give ~(log X)^k / (k! ∏ log pᵢ) rungs
               more rungs → finer orbit → better frequency resolution
signal/block   same prime range split over more blocks
               primes per block ~ π(X)/rungs → per-block signal falls
```

`P_max/median` is a product of the two. A peak exists where the derivatives balance.

**What it predicts, and why that is the point.** The optimum `k*(X)` is a function
of X — more data buys more primes per block and shifts the balance toward more
generators. So the derivation says **the peak moves**. Three measured settings say
it does not. Writing this honestly sets up a falsification of the mechanism.

If `k*(X)` is provably non-constant, then either the tradeoff model is wrong or
something pins the peak to four that the model does not contain. Either answer is
worth more than agreement.

**Lean shape.** Define `resolution (k X : ℝ)` and `signalPerBlock (k X : ℝ)`, their
product `score`, and prove `∃ k*, ∀ k, score k X ≤ score k* X` — then prove or
refute `k*` constant in X. Do not import the measured values into the proof.

**Artifacts.** `results/O24_gen_to19_run.log`, `O24_gen_xmax1e9_run.log`,
`O24_gen_xmax3e9_run.log` (chains, scaling band). `O24_prime_generator_orbit.py`
lines defining the rung construction and `P_max/median`. Entry 24 for the
original prediction, entries 34 and 42 for its falsification.

**Tractability: medium.** The optimum is a discrete argmax of an explicit
function; Mathlib has what is needed. The risk is stating `resolution` faithfully.

---

## 2 · Breakdown depths — 13 / 10 / never

`results/transform_radius.json` → `summary.breakdown_depth`: prime onset 13,
resid onset 10, smooth control `null` (never breaks down to d = 43).

**Mechanism.** Breakdown is defined in `O39_transform_radius.py` as relative spread
of root moduli exceeding `--breakdown-tol` (0.05) for `--breakdown-run` (3)
consecutive depths. Coefficient count at depth d is `R - d`, so the truncated
z-transform loses resolution as `1/(R-d)`. The threshold crossing should be
derivable from the coefficient count alone.

**What it predicts.** Onset depth as a function of `R` and the tolerance. That is
testable immediately by re-running O39 at a different `--rmax` — if onset scales
with R as derived, the mechanism holds; if it is pinned, it does not.

**Why it matters.** This session could not separate "the migration converged" from
"the coefficients ran out" at d ≈ 13. A derivation settles which.

**Lean shape.** Bound the relative spread of the roots of a degree-`n` truncation
below by a function of `n`; show it crosses `tol` at the stated depth.

**Tractability: medium-hard.** Needs a real bound on root spread for truncated
power series. Jentzsch is not in Mathlib and would have to be stated as a
hypothesis rather than proved.

---

## 3 · The 25 contributing primes — **CLOSED** by `Covering.lean`

Contribution proved to be a Diophantine-approximation condition rather
than a size condition, which is why the set skips 13 and 23. Kept for
the record.

`results/O37_weil_form_on_stencil_run1.log`: 36 primes lie inside the mollified
support, 25 contribute non-zero, and the surviving set is **not** an initial
segment — 2, 3, 5, 7, 11, skip 13, 17, 19, skip 23, … through 151.

**Mechanism.** A prime contributes iff some `m·log p` lands inside the support of
the mollified kernel — a B-spline of half-width `4W` centred on lattice points
`n·log b`. So contribution is a covering condition: `∃ m n, |m log p − n log b| < 4W`.
The skips are primes whose powers all miss every lattice point.

**What it predicts.** The exact contributing set, from `b`, `N`, `W`, `k` alone —
no run needed. Deterministic and fully checkable against the log.

**Why it matters.** It is the cleanest of the four: a decidable predicate with a
known answer sitting in an artifact. Good calibration for the method.

**Lean shape.** `def contributes (b W : ℝ) (N : ℕ) (p : ℕ) : Prop := ∃ m n, …`,
then `decide`-style verification against the 36 candidates.

**Tractability: easiest.** Do this one if the G4 mechanism stalls — it will confirm
the approach works before spending effort on a harder target.

---

## 4 · The four exact zeros — **ANSWERED NEGATIVELY, as predicted**

No mechanism was found and none is expected; the honest deliverable was
built instead. `Zeros.measured_zeros_all_vanish` derives the vanishing
from `π(2ⁿ)` at zero axioms (entry 78), and `ZeroCells.lean` welds the
three further transcriptions to that computed list (entry 187). Kept
for the record.

`(2,1), (4,1), (8,3), (20,6)`, over `r ≤ 62, d ≤ 61`, from `results/O16_run2.log`.

**There is probably no mechanism.** "Δ⁷π vanishes at 2²⁰" is a fact about π, not a
consequence of a structure. This session established that the cell is blind to how
many primes lie below it and sensitive to where they sit (O30 vs O31), and that
excising three integers destroys both deep zeros. That is a *sensitivity* result,
not a prediction of location.

**What could be derived instead.** Not the locations — the *constraint*. A zero at
`(r,d)` is exactly `cell(r,d−1) = cell(r−1,d−1)` (verified: 623 = 623 at (20,6),
4 = 4 at (8,3)). And the window ratio is `b^(d+1)`, so `2⁷ = 128` with 7 prime means
no integer base below 128 reaches that window at integer depth. Both are provable
and neither predicts where the zeros are.

**Honest recommendation.** State the constraint, prove it, and leave the locations
in `Unpaired` permanently with a docstring saying why. A hole that cannot close is
still worth marking as such — the record is better for saying so than for a
contrived derivation.

---

## 5 · The queue from 2026-08-27, in order

Ranked after an adversary compiled each candidate and broke three of
four (entry 225). The ordering follows this file's own method rule: a
theorem stating the *mechanism* of a live argument outranks one
certifying a retired instrument.

**5.1 · The stationary maximum — BUILT, `lean/NyquistPeak.lean`,
20 theorems.** Marking the outcome is Julian's; the build is done and
green. What shipped is stronger than the item asked for: the gain is
*derived* from `Chain.Sym` rather than restated, the maximum is
**global** rather than local, and `nyquist_boundaryBase` welds `b*` to
`Nyquist.nyquist` so it is exactly the cap
`base_bound_of_resolvable` produces. Original text follows.

**5.1 (as written).** The γ₁ gain of the
difference filter is `(2 sin(θ/2))^d` with `θ = γ₁ log b`, and its
θ-derivative **vanishes at θ = π**. So `b* = exp(π/γ₁)` is a smooth
stationary maximum, not a discontinuity. ~26 lines, axioms are the
house baseline for this module. **What it discharges:** entry 224's
mechanism claim, which is the argument behind the `no_step` mechanical
output of a *locked* prereg (`dense_boundary_scan_v1_20260827`). This
is the only candidate that backs a live preregistered result.

**5.2 · The base-change telescoping.** On the half-octave lattice
`F[j] = ⌊2^(j/2)⌋`, `F[2r] = 2^r` **exactly**, so
`N₂(r) = n_{2r−1} + n_{2r}` telescopes for **all** `r` — upgrading
entry 208's 32-case check to a theorem. The polynomial identity
`(1−z²)⁷ = (1−z)⁷(1+z)⁷` is `by ring` and certifies nothing on its own;
the base change is the load-bearing statement.

**5.3 · Bezout, restated base-free.** For coprime aliased arms the
joint alias set collapses: `(1/j₁)ℤ ∩ (1/j₂)ℤ = ℤ`. Entry 211 called
this CRT and stated it as `ν ≡ ±1 (mod 8)`; it is the *dual* of CRT,
and the 8 is `2π/s`, so that form pins the units. State it base-free,
with `s ≠ 0` load-bearing (the vacuity trap `Chain.period_vacuous_at_one`
documents), and note the `±` needs `P(−γ) = P(γ)` for real weights —
it is **not** expressible in `Nyquist.Aliases` alone. **What it
discharges:** the escape half of the no-go. `lean/` currently proves
only that every single ladder fails.

**5.4 · Deferred, with reasons.** The periodogram-periodicity statement
is already in the tree as `Chain.gain_sq_periodic` and is *false* of
the pipeline, which samples `log⌊b^r⌋` rather than `j·h + c`; only an
approximate form with an explicit `ε_j ≤ 1/x_j` bound would be new, and
that one would give entry 213's `X = 0.10` criterion its margin as a
theorem. The vacuity family (entries 194, 197, 205, 217) and the
plateau-width law `hw = b*π²/(γ₁²·ln V)` are true and cheap but certify
retired instruments — they rank below 5.1–5.3 by this file's method
rule, not by difficulty.

---

## Two defects in `Chain.lean` — both CLOSED

1. ~~`StmtC1` is a hypothesis proved nowhere.~~ Discharged by `Chain.C1`, from
   `EulerFactorChain.gain_sq_on_critical_line`. `C2` and `C3` are now
   unconditional.
2. ~~`StmtA2` is stated wrong.~~ Restated as Euler's product over `Nat.Primes`
   with the `1 < s.re` convergence hypothesis, and discharged by `Chain.A2` from
   Mathlib's `riemannZeta_eulerProduct_tprod`. `A3` followed.

`A1` and `B4` were also discharged, so every arrow in `Chain.lean` is now
applied rather than assumed.

## Also outstanding, outside `lean/`

- **Checked against artifacts 2026-08-21 — one of these was not an error.**
  ~~The G4 six-zero spread is 8.56%, recorded as 8.4%.~~ Both are correct and
  measure different things: 8.4481% is `P/median` **at** each γₙ (log line
  156), 8.56% is the height of the local peak **near** each γₙ (log lines
  205–210). CONTEXT.md and entry 42 report the first,
  `papers/The-Four-Prime-Peak.md` § E2 the second, each citing its own table.
  Neither should be edited to match the other. Entry 58.
  The 247-cell attribution **is** real — O16's GATE A, not O27 — and is now
  corrected in place at `CONTEXT.md:305` with the original left visible.
- ~~O40, O41, `papers/convergence.md`, `lean/` and their results are not
  committed.~~ All committed; the tree is pushed.
- No literature search has been done. Nothing in the chain is established as new.
