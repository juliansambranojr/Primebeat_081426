# Joint 10 on one ladder, the case not attained — generalized stencils

Read first after any compaction. Blocks S1 to S3. 2026-11-23. A paper
derivation made in one sitting; block S1 is the part checked step by step
below. Blocks S2, S3 are not yet checked by anyone else.

## The idea

Unit 0431: on the one ladder a square-root bound makes a summable sum of
modes small, and when the real parts of the zeros climb to a value `Θ` that
no zero reaches, no circle of modes dominates, so averaging has nothing to
normalise by.

The ladder's values can be combined before they are read. Any polynomial
`q(u) = Σ q_j·u^j` acts on a sequence by `(q(S)a)_n = Σ_j q_j·a_{n−j}`. The
table's own depth is `q(u) = 1 − u`. On a mode `z^n` it acts as
multiplication by `q(1/z)`. So a filter `q^m` reweights the mode of a zero by
`q(u_ρ)^m`, `u_ρ = 2^(−ρ)`, and with `m = λ·n` the rate of the mode along the
ray becomes `|z_ρ|·|q(u_ρ)|^λ`. A filter that is small where the modes
accumulate moves the largest rate to a place where it is attained.

## S1 The filtered ladder — PROVED (unit 0466: `FilterLadder.filtered_modes_small_sq`, `filter_mode`, `Wn_pow_le`; factor `n²`, constant `Afl C = C + Kf + 39000·Mlow`, `1/2 ≤ σ` suffices)

`a_k = ψ(2^k) − 2^k`. `‖q‖_W = Σ_j |q_j|·2^(−j/2)`; it is submultiplicative,
`‖q^m‖_W ≤ ‖q‖_W^m`, and `|q(u)| ≤ ‖q‖_W` for `|u| ≤ 2^(−1/2)`.

Hypothesis `H`: `|a_k| ≤ C·k²·√2^k` for `k ≥ 1`.

Take `m·deg q < n`, so every `a_{n−j}` read has `n − j ≥ 1`.

- From `H`: `|Σ_j (q^m)_j·a_{n−j}| ≤ C·n²·2^(n/2)·‖q‖_W^m`.
- `ExplicitTwo.explicit_formula_all_two` at `x = 2^k`, `T = 2^n ≥ x`:
  `a_k = −Σ_{|γ|<2^n} w_ρ·z_ρ^k + O(n²)`, `w_ρ = m(ρ)/ρ`, the same finite set
  of zeros for every `k ≤ n`. This is where the formula above `x²` and from
  `x = 2` is used: the height `2^n` is far above `(2^k)²` for small `k`.
- So `Σ_j (q^m)_j·a_{n−j} = −Σ_{|γ|<2^n} w_ρ·q(u_ρ)^m·z_ρ^n + O(n²·‖q^m‖_1)`,
  and `‖q^m‖_1 ≤ 2^(m·deg q/2)·‖q^m‖_W ≤ 2^(n/2)·‖q‖_W^m`.
- Zeros with `Re ρ < σ`: for `β < 1/2`,
  `Σ_j |(q^m)_j|·2^((n−j)β) ≤ 2^(nβ)·2^(m·deg q·(1/2−β))·‖q‖_W^m ≤ 2^(n/2)·‖q‖_W^m`;
  for `1/2 ≤ β < σ` it is `≤ 2^(nσ)·‖q‖_W^m`. Their weights below height
  `2^n` sum to `zinv(2^n) = O(n²)`.

Result, for `1/2 < σ`:

    ‖Σ_{Re ρ ≥ σ, |γ| < 2^n} w_ρ·q(u_ρ)^m·z_ρ^n‖ ≤ A·n⁴·2^(nσ)·‖q‖_W^m,
    whenever m·deg q < n.

`A` does not depend on `q`.

## S2 An attained rate under some filter closes the case — PROVED in the corrected form below (unit 0467: `FilterAttained.filter_attained_false`, `attained_psi`; `σ ≤ 1` is not needed)

Fix `q`, integers `a ≥ 0`, `b ≥ 1` with `a·deg q < b`, and `σ > 1/2`. Read
S1 along `n = b·k`, `m = a·k`. The rate of a zero is
`V(ρ) = |z_ρ|^b·|q(u_ρ)|^a`; the threshold is `2^(σb)·‖q‖_W^a`.

If `sup V` over the zeros with `Re ρ ≥ σ` is attained, on finitely many alias
classes, and exceeds the threshold, then dividing S1 by `sup V^k`:

- the zeros above height `2^n` carry weight `≤ C·2^(−n·5δ²)` by
  `ZeroDensity.zero_density`, times at most `sup V^k`: they vanish;
- the zeros with `V < sup V − gap` vanish (summable weights,
  `ZeroSummable.summable_order_div`);
- what stays is a finite sum of distinct unit rotations with the alias-class
  weights, which have positive real part (`AliasClass.alias_weight_ne_zero`),
  and S1 says it tends to zero. `LadderFading.not_tendsto_powerSum` forbids.

`q = 1` is unit 0456, the largest real part attained.

## S3 Finitely many accumulation points — PROVED in the corrected form below (unit 0468: `FilterAccum.finite_accumulation_false`, `rh_of_finite_accumulation`; `a = 1`, `b` large; the points of `P` are taken nonzero, which Lean needs since `0⁻¹ = 0`)

If for some `σ` the modes `{2^ρ : Re ρ ≥ σ}` are non-empty and accumulate at
finitely many points `p_1, …, p_s` only, take `q(u) = Π (u − 1/p_i)` and
`a/b` small. `log V = b·β·log 2 + a·log|q(u_ρ)|` tends to `−∞` at each
accumulation point, so the supremum is over finitely many zeros and is
attained; for `a/b` small it exceeds the threshold at any zero with
`β > σ`. So S2 applies. This covers arrangements in which the real parts
climb to `Θ` without reaching it.

## Not in this plan

The modes accumulating on a set that screens every mode. In the terms of the
derivation: the excess `(β − 1/2)·log 2 + λ·log(|q(u)|/‖q‖_W)` can be made
largest at an attained point exactly when some mode `u_1` has harmonic
measure of the accumulation set, seen from `u_1` inside the disc
`|u| < 2^(−1/2)`, below `(β_1 − 1/2)/(Θ − 1/2)`. An accumulation set that
contains a closed curve around the origin fails this for every mode outside
it. That is the arrangement of Wolff and Denjoy, and nothing here excludes it.

The count `π` in place of `ψ`: a filter acts on `z^n/n` with a factor that
does not tend to one. S1 to S3 are for the ladder of `ψ`.

## After the independent check (2026-11-23)

An Opus reviewer was asked to break S1 to S3. What it found, in its words
condensed; its own additions are paper work that nobody else has checked.

**S1 holds.** The factor comes out as `n²`; `n⁴` is slack. `A` is free of
`q`, `m`, `n`, `σ`. By Cauchy's estimate `‖P‖_W ≤ (deg P + 1)·max_{|u|=2^(−1/2)}|P|`,
so the threshold can be stated with `μ_q = max_{|u|=2^(−1/2)}|q(u)|` in
place of `‖q‖_W`.

**S2 corrected.** There need be no gap below an attained supremum, and none
is needed: every term with `V < M` has `|w_ρ|·(V/M)^k → 0`, dominated by the
summable `|w_ρ|`. The tail needs only summability. The survivors are the
zeros with `|ξ_ρ| = M`, `ξ_ρ = 2^(bρ)·q(2^(−ρ))^a`, possibly infinitely many,
and distinct zeros can share one `ξ`. Each fibre's weight has positive real
part, since every `m/ρ` has. The tool is `LadderMean.mean_extract` (unit
rotations, summable weights, sum tending to zero ⊢ every fibre's weight is
zero). `LadderFading.not_tendsto_powerSum` and
`LadderMean.line_not_fading_summable` do not fit when `q ≠ 1`.

    S2. q, a ≥ 0, b ≥ 1 with a·deg q < b, σ ∈ (1/2, 1], M = sup_{β≥σ}|ξ_ρ|.
        If some zero with β ≥ σ attains M and M > 2^(σb)·‖q‖_W^a, then H fails.

**S3 corrected.** "Finitely many zeros" should read "finitely many mode
points"; one point can carry an infinite alias class. The statement needs a
zero with `β > σ` whose mode is not an accumulation point, automatic when
`Θ > σ` is not attained.

    S3. K_σ = {2^ρ : β ≥ σ} with finite derived set A', and a zero with
        β > σ and 2^ρ ∉ A'. Then H fails (q = Π(u − 1/p_i), a = 1, b large).

A hypothetical arrangement it covers: `ρ_n = Θ − (Θ−σ)/n + i·(γ* + 2πn²/log 2)`.

**A residue route covers more than S3, with no filter.** Take
`Θ − 5δ² < σ < Θ`. S1 at `q = 1` plus the density rate for the tail give
`P_k = Σ'_{β≥σ} w_ρ·z_ρ^k = O(k⁴·2^(kσ))`, so `G(u) = Σ_k P_k·u^k` is analytic
in `|u| < 2^(−σ)`. On `|u| < 2^(−Θ)`, `G(u) = Σ' w_ρ·u/(u_ρ − u)`, analytic
off `K = closure{u_ρ}`. If some `u_1`, `β_1 > σ`, is isolated in `K` and on
the boundary of the component of `ℂ∖K` containing `0`, `G` has a pole there
with residue `−u_1·Σ_fibre w_ρ ≠ 0`. Contradiction. This covers every
countable `A'` and every `A'` that does not separate the modes from `0`.
The filters still add the cases where the maximiser is not isolated, of
which the attained `Θ` is the main one.

**The potential-theory paragraph.** The harmonic-measure condition is
necessary for a filter to exist. Sufficiency is not established: the
constraint `a·deg q < b` caps the mass of the potential below one.

**Where both routes stop.** An accumulation set that separates the modes
from `0`.

## S4 The residue route — `Stage3/ResidueRoute.lean`

Julian, 2026-11-24: assemble the ladder route; step (A1). From "After the
independent check" above: with `Θ − 5δ² < σ < Θ`, S1 at `q = 1` and the
density rate for the tail give `P_k = Σ'_{β≥σ} w_ρ z_ρ^k = O(k⁴ 2^(kσ))`, so
`G(u) = Σ_k P_k u^k` is analytic in `|u| < 2^(−σ)`. On `|u| < 2^(−Θ)`,
`G(u) = Σ' w_ρ u/(u_ρ − u)`, analytic off `K = closure{u_ρ}`. A mode `u_1`,
`β_1 > σ`, isolated in `K` and on the boundary of the component of `ℂ∖K`
holding `0`, is a pole with residue `−u_1·Σ_fibre w_ρ ≠ 0` (`AliasClass`).

- `isolated_boundary_mode_false`.

**Not here.** An accumulation set separating the modes from `0`.
