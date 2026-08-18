# Formalization

Eight Lean 4 modules in `~/GitHub/Primebeat_081426/lean/`, built against Mathlib
v4.28.0. `lake build` → 8035 jobs, zero `sorryAx` anywhere.

The point of formalizing was not to re-prove known mathematics. It was to check the
**arrows** — whether each "therefore" in `Euler-Factor-Chain.md` actually follows —
and then to write the *mechanisms* behind the bench's unexplained numbers and let
those numbers falsify them.

Three of the four mechanisms came back as refutations of accounts already in the
notebook. That is the headline.

---

## A · The files

**`EulerFactorChain.lean`** — four nodes proved against Mathlib. A1 (the ladder
symbol), B2a (`h s = h (1−s)`), B2b (`h 0 = h 1 = 0`), B4 (`h = ‖1−b^(−s)‖^(2N)`
on the critical line). Verified via `#print axioms`: only `propext`,
`Classical.choice`, `Quot.sound`.

**`Chain.lean`** — the arrows. `A1 → A4`, `A4 ∧ B4 → B5`, `C1 → C2`, `A4 ∧ C2 → C3`.
Statements are `def Stmt…` propositions taken as hypotheses, so Lean checks the
implications rather than collapsing each onto Mathlib. If a link were a leap it
would not compile.

**`Superposition.lean`** — a licence nobody had noticed was missing. `A4` gives the
depth gain for a *single* mode; O34 and O35 apply it to a *sum* over zeta zeros.
Nothing permitted that. Now proved: `N` differences act on a finite superposition by
acting on each mode separately.

**`GeneratorPeak.lean`** — the G4 peak.

**`Crossover.lean`** — the "breakdown depth".

**`Covering.lean`** — the 25 contributing primes.

**`Zeros.lean` + `Construction.lean`** — the four exact zeros, as a matched pair.

**`Measured.lean`** — 17 literals, each with a docstring naming the `results/`
artifact it came from, and 6 `agreement_*` theorems bounding
`|predicted − measured|` at a stated tolerance.

---

## B · What changed in the reading

### B1 · The G4 debate was mis-aimed

**Before.** Entry 24 explained the peak at {2,3,5,7} as a tradeoff: more generators
give a denser orbit and better resolution, but split the same primes over more
blocks. The argument all day was empirical — does the G4/G5 gap widen or narrow,
does the peak move with `xmax`. I argued both sides within a few hours, first that
the widening gap killed the account, then that the monotone per-set gains supported it.

**After.** `score = R^α · n^β` with `n = P/R` collapses:

```text
score = R^α · (P/R)^β = P^β · R^(α−β)
```

`R` is strictly increasing in the generator count. So the score is strictly monotone
when `α ≠ β` and constant when `α = β`. `no_interior_peak` proves those three cases
exhaust the possibilities, and none admits a strict interior maximum.

**The change.** No power-law tradeoff of this form can peak anywhere, for any
exponents. The measurement has an interior peak. So the mechanism is refuted
structurally, not statistically — and both of my empirical readings were arguing
about which way the numbers leaned inside a model that could not produce the shape
at all.

### B2 · "Breakdown" was a crossover, and it completes

**Before.** `O39_transform_radius.py` reports a breakdown onset at d = 13 for the
prime table, d = 10 for the residual, and never for the smooth control. The word
implies the truncated transform runs out of coefficients. I repeated it, and used it
to dismiss the d = 20 radius of 0.8677 as "truncation, not migration."

**After.** The artifact's own spread data:

```text
  d    n = R−d    prime      smooth
  0       45      0.0079     0.0024515
 13       32      0.0592     0.0001498
 20       25      0.3026     0.0000503
 30       15      0.0219     0.0000103
 40        5      0.0737     0.00000069
```

The smooth control has **five coefficients** at d = 40 and a spread of 6.9×10⁻⁷.
Coefficient count drives nothing — `count_does_not_determine_spread` states the
100,000× ratio at identical `n`. And the prime spread is **non-monotone**: it peaks
near d = 20 and returns to 0.022 by d = 30, with prime and residual identical from
d = 16 on.

`Crossover.lean` supplies the mechanism: the dominance ratio between two geometric
families is strictly increasing, so there is **at most one** crossover. A single
family has none — which is exactly the smooth control.

**The change.** d = 13 is the *onset of the migration*, not an exhaustion. The
transition completes and the roots settle again. My "truncation, not migration" call
was backwards: d = 20 is mid-crossover, which is migration.

### B3 · The 25 primes are a Diophantine condition, and the count is a parameter

**Before.** An odd list — 2, 3, 5, 7, 11, skip 13, 17, 19, skip 23, … through 151.
Not an initial segment, with no account of why.

**After.** A prime contributes iff some power of it lands within the kernel, which
sits on the lattice `n·log b`:

```text
contributes p  ⟺  ∃ m n, |m·log p − n·log b| < ε,   ε = 2K·W
```

Checked against the artifact before any Lean was written: reproduces all 25, no false
positives, no false negatives, out of 36 in support. `covering_not_monotone` proves a
set defined this way need not be an initial segment — which is the whole reason the
list looked strange.

**The change, and it is the only genuine forward prediction of the four.** The lattice
has spacing `L`, so every point lies within `L/2` of it (`exists_near_lattice`). Once
`ε ≥ L/2` the condition is **vacuous** — every prime contributes and the form stops
selecting. Selectivity is governed by `ε/L` alone, never by the size of `p`.

```text
    W       ε        in support   contributing
  0.0500  0.2000         36            25
  0.0700  0.2800         39            35
  0.0866  0.3464         41            41    ← ε reaches L/2 = 0.34657
  0.1200  0.4800         46            46
```

Derived first, confirmed after. And it sharpens a caveat already in
`Connes-Measured.md`: "25 primes contribute" is a statement about a mollifier
parameter, not about the ladder. Past `W = 0.0866` the form selects nothing at all.

### B4 · The four zeros: neither placed nor predicted

**Before.** Recorded as an unexplained hole, with an implicit worry that unexplained
meant arbitrary.

**After.** Two files saying different things, and the pair is better than either.

`Construction.lean` proves **uniqueness**: any function satisfying the table
recurrence over a given depth-0 row *is* the table. `unique_of_isTableOf` and
`eq_of_same_row` **depend on no axioms at all** — pure computation. There is no free
parameter anywhere: fix π and every cell to every depth is forced. `zero_determined_by_row`
adds locality — a cell depends only on the `d+1` row entries in its window.

`Zeros.lean` proves what *can* be said and states plainly what cannot.
`zero_iff_repeat` (needing only `propext`) says a zero is exactly a repeat one depth
up — verified in the table: d5 at r = 19 and r = 20 are both 623; d2 at r = 7 and
r = 8 are both 4. `window_exclusive_of_prime_exponent` proves `b^k = 2^7` with
`k ≥ 2` forces `b = 2, k = 7` — because **7 is prime**, no integer base below 128
reaches the (20,6) window at integer depth. But `2^4 = 4^2`, so base 4 reaches the
(8,3) window at depth 1. The two deep zeros are different kinds of object.

**The change.** "Unexplained" was doing two jobs and hiding a distinction. The zeros
are **not placed** — no freedom exists in the construction, provably, without axioms.
They are **not predicted** — nothing locates them. Those are compatible, and together
they are a sharper statement than the hole they replaced.

### B5 · A gap nobody had noticed

`Superposition.lean` exists because writing the chain down exposed that `A4` covered
a single mode while every use of it on the bench applied it to a sum over zeros. That
step was assumed for the entire O34/O35 line of work. It is now derived, and it
proves no number: the 94% / 92% / 80% fractions appear nowhere in the file. What
changed is their *status*. Before, a disagreement could have meant a wrong model or
bad algebra. Now the algebra is settled and those fractions test the model alone.

---

## C · What formalizing changed about method

**Aim at the mechanism, not the number.** The first framing was "prove a theorem whose
conclusion is 0.94." That is working toward a predetermined answer — the thing prereg
discipline exists to prevent — and for most of these holes it is not even possible.
`Δ⁷π` vanishing at 2²⁰ is not a theorem. The correct move is to state the mechanism
and let the measurement falsify it. Every file above keeps its measured values out of
every proof; they appear once, at the bottom, as falsifiers.

**Lean removes the adjudication from both parties.** Much of this bench's history is
someone judging whether a result is significant. Lean does not care what anyone
thinks follows. It compiles or it refuses — which is why three refutations came out of
it and only one confirmation.

**Exact values expose carried rounding.** The check pass — verifying each literal
against its artifact after writing — caught two wrong numbers that had been quoted in
prose all session:

```text
measured_radius_resid   written 0.7543112   artifact 0.7542802496369435
spread_smooth d=40      written 0.000001    artifact 6.892378652639774e-07
```

Both were mine, both from remembering a rounded figure rather than reading the file.
Sixteen of seventeen literals were right; the one that was not is the one I did not read.

---

## D · Not established

**D1.** `StmtC1` in `Chain.lean` is a hypothesis proved nowhere, so `C2` and `C3`
rest on an assumption. The expansion is provable and was not proved.

**D2.** `StmtA2` is stated as `(Sym s)⁻¹ · Sym s = 1`, which is **false** exactly where
`Sym s = 0` — the alias lattice. Nothing uses it; it should be restated as the Euler
product or deleted.

**D3.** Lean verified the arrows between the formalizations *as written*. Whether each
`def Stmt…` faithfully says what the corresponding statement in the paper says is a
human judgment, not a machine-checked one. The seven `def Stmt…` lines are the whole
interface and are short enough to read against the document.

**D4.** No literature search has been done. Nothing here is established as new. The
Euler-factor identity, the covering lemma and the crossover argument are each one line
from standard facts, which is the profile of folklore.

**D5.** Blocks D through I of the chain remain unencoded — the winding, the pair
identity, the transform results.
