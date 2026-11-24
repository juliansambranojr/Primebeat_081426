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

## S5 The case split and the assembly — `Stage3/LadderAssembly.lean`

Julian, 2026-11-24: assemble the ladder route; step (D) and the assembled
theorem. S4 compiled (5178791) with its boundary condition on the component
of `0` in `ball 0 (2^(−σ)) \ K σ`: `G` is known analytic only on that disc.

(D) If `Re ρ₁ = Θ` bounds every real part, every `u ∈ K σ` has
`|u| ≥ 2^(−Θ)`, so the open disc `|u| < 2^(−Θ)` misses `K σ`, is connected,
holds `0`, and sits in the component. `|u₁| = 2^(−Θ)` puts `u₁` in the
closure of that disc, and `u₁ ∈ K σ` keeps it out of the component: `u₁` is
on its frontier, for every `σ ≤ Θ`. Isolation among the modes with
`Re ρ ≥ σ₀` passes to `K σ` for `σ ≥ σ₀` with `ε/2`.

Assembly. Off the line, a tame top is `ρ₁` with `1/2 < Re ρ₁`, every real
part `≤ Re ρ₁`, and some `σ₀ ∈ (1/2, Re ρ₁)` and `ε > 0` with every mode of
`Re ρ ≥ σ₀` other than `u₁` at distance `≥ ε` from it. S4 at `Θ = Re ρ₁`
and `σ = max E σ₀`, below `Θ`, gives `False`.

- `top_mode_on_frontier`, `rh_of_ladder_tame`.

**Not here.** A top real part that is not attained; an attained top mode
that other modes accumulate on.

## S6 Reached modes — `Stage3/ReachRoute.lean`

Julian, 2026-11-24, case 2 on the ψ ladder: a mode reached from `0` that
other modes crowd. Unit 0510 left two arrangements on the ψ route: a limit
set that walls the modes off from `0`, and a mode on the edge that is a limit
of other modes. S4 needs isolation only for one limit, and that limit
survives along any approach that stays non-tangential to the other modes.

Setting of S4: `σ ≥ E`, `Ω` the component of `0` in `ball 0 (2^(−σ)) \ K σ`,
`G = F` on `Ω`, `F(u) = Σ' w_ρ·u/(u_ρ − u)`, `u_ρ = 2^(−ρ)`.

Reach. A zero `ρ₁` with `σ < β₁` is *reached* when there are `u_j ∈ Ω`,
`u_j → u₁ = u_{ρ₁}`, `u_j ≠ u₁`, and `M` with
`‖u_j − u₁‖ ≤ M·‖u_ρ − u_j‖` for every `ρ` with `β ≥ σ` and `u_ρ ≠ u₁`.

Proof. `(u₁ − u_j)·F(u_j) = Σ' w_ρ·u_j·(u₁ − u_j)/(u_ρ − u_j)`. The fibre of
`u₁` gives `u_j·Σ_fibre w_ρ` exactly. Every other term is at most
`‖w_ρ‖·‖u_j‖·M`, summable, and tends to `0` since `u_ρ ≠ u₁`. Dominated
convergence (`tendsto_tsum_of_dominated_convergence`) gives the limit
`u₁·Σ_fibre w_ρ`. `G` is analytic at `u₁` (`‖u₁‖ < 2^(−σ)`), so
`(u₁ − u_j)·G(u_j) → 0`, and `G(u_j) = F(u_j)`. The fibre weight is `0`,
against `AliasClass`.

Isolation and the frontier give a reach: the punctured ball at `u₁` misses
`K σ`, is connected and meets `Ω`, so it lies in `Ω`, and `u_j = u₁ + r_j`
with `r_j → 0` has `M = 1` once the ball is free. So S6 holds S4. A cone at
`u₁` free of other modes and meeting `Ω` gives a reach along its axis, with
`M = 1/sin` of its half angle.

- `reached_mode_false`, `reach_of_isolated`.

**Not here.** A mode that every approach from `Ω` meets tangentially to the
other modes. A limit set that separates the modes from `0`. H.

## S7 The wall — on paper, no Lean target yet

Julian, 2026-11-24: "Let's do the wall and loop". The arrangement: the limit
set of the modes right of `σ` cuts `0` off from every mode. Example: no zero
reaches `Θ`, and the angles `γ·log 2 (mod 2π)` of the zeros near `Θ` are
dense, so `K σ` holds the circle `|u| = R`, `R = 2^(−Θ)`, and `Ω` is the
disc `|u| < R`.

**The reduction (proved pieces).** `G` and `F` have the same power series at
`0`. Its coefficients are the power sums `P_k = Σ'_{β≥σ} w_ρ·z_ρ^k`,
`z_ρ = 2^ρ` (`ResidueRoute.G_eq_F`, `P_bound`). Under H, `|P_k| ≤ A·k²·2^(kσ)`.
So the wall case is the moment problem: a summable family `w_ρ` on the
points `z_ρ` (`|z_ρ| < 2^Θ`, sup not reached), whose power sums grow like
`2^(kσ)` with `σ < Θ`. Nothing beyond this is used by S4 to S6, and on the
wall nothing beyond it is available to them: `Ω` is the inner disc, where
`F = G` already says only this.

**Summability and the sign of the weights do not close it.** The uniform
measure on a circle `|z| = s` has `∫ z^k = 0` for every `k ≥ 1`. It is
positive, and its power sums are as small as can be. Wolff's series give
atomic families with complex weights whose power sums all vanish. Whether an
atomic family with weights of positive real part can have power sums
`O(k²·2^(kσ))` with an atom outside `|z| = 2^σ` is not settled here. Either
way, the wall needs a property of the zeros of ζ beyond their count, the
summability of `m/ρ` and the sign of `Re(m/ρ)`. Unit 0431 says the same.

**What the zeros have that a measure on a circle does not.**
- The conjugate pairs: `w_ρ̄ = conj w_ρ`, `z_ρ̄ = conj z_ρ`, so every `P_k` is
  real.
- The weights `m(ρ)/ρ`: tied to the height, `|w_ρ| ≈ m/|γ|`. A wall needs
  the angles `γ·log 2` spread, and the weights fall as `γ` grows.
- The density bound `ZeroDensity.zero_density`: few zeros near `Θ`.
- The monotone ψ under the ladder: `ψ(2^(k+1)) − ψ(2^k) ≥ 0`.

None of these has been turned into a bound against the wall. The first
candidate to try is the weights' fall with height: the atoms at angle near
`φ` with `|z| > 2^(σ+δ)` would have to cancel in every power sum, against
weights fixed by their heights.

**Not a block yet.** No statement here is ready for Lean. The next step is
one derivation on paper: either a bound that uses one of the four facts
above, or an atomic example showing that the four together still allow the
wall.

### S7, derivation round 1 (2026-11-24, Julian: "Start")

On paper, here, unchecked by anyone else.

**The wall in `s = −log₂ u`.** For `Re s > Θ`, `F` is the folded sum
`Σ'_{β≥σ} w_ρ/(1 − 2^(ρ−s))`. Each term is meromorphic on the plane, and
under H their sum `G` is analytic for `Re s > σ`. The wall is the folded sum
failing to converge for `Re s < Θ`. In every period strip, the aliases
`ρ − 2πi m/log 2` of the zeros near `Θ` come close enough to every point to
blow the sum up. So the wall is a statement about how the heights `γ mod
2π/log 2` of the zeros near the top fall.

**Free weights with positive real part do not give a wall cheaply.** An
atom `w·δ_z` with `|z| > 2^σ` adds `w·z^k`, and that outgrows `k²·2^(kσ)`.
Finitely many atoms cannot cancel it for every large `k`: that is
`LadderFading`'s Vandermonde step. Atoms spread evenly on a circle cancel
except at the multiples of their number, and there they outgrow the bound
as well. So a wall needs exact cancellation among infinitely many atoms, as
in Wolff's series, at every large `k`. Unit 0431 records that such series
exist with complex weights. This round has not settled whether they exist
with weights of positive real part.

**What the zeros fix that Wolff's series leave free.** The weight and the
point are tied: `w = m(ρ)/ρ` and `z = 2^ρ`, both from `ρ`. Aliases share `z`
and differ in `w`, and `AliasClass` sums a fibre. A Wolff series picks its
weights to make the cancellation work. The zeros cannot. So the target is a
rigidity statement: no family `{(m(ρ)/ρ, 2^ρ)}`, summable, closed under
conjugation, with `Re(m/ρ) > 0`, has power sums `O(k²·2^(kσ))` while some
`β > σ`.

**What this round did not reach.** It has no proof of that rigidity and no
example against it. Every construction tried here broke on the same point:
whatever does not cancel exactly at modulus above `2^σ` eventually
dominates. That point is also the only lever found. A proof would show that
the tied weights cannot cancel exactly on infinitely many levels.

**Next round.** Look for the rigidity in the literature first: uniqueness
for Dirichlet-type series `Σ a_n λ_n^k` with coefficients tied to their
exponents (Pólya, Carlson, Mandelbrojt). Then derive.

### S7, round 2 (2026-11-24, Julian: "Run a shorter loop and start round 2")

**Literature.** Five searches found no theorem that a bound on `ψ` at the
doublings alone gives RH, nor any uniqueness theorem for pole sums with
weights of positive real part accumulating on a curve. The tool the
literature uses for discrete power sums of zeros is Turán's power sum
method; one 2026 paper on Landau–Siegel zeros applies it.

**Turán on the wall, on paper.** Take `β* > σ`, a height `T`, and `S(T)` the
zeros with `β ≥ β*`, `|γ| ≤ T`: finite, `N = N(T)` of them, and its largest
modulus `2^(β_max(T))` is attained inside `S(T)` even when `Θ` is not. Turán's
second theorem bounds `max_{m<k≤m+N} |Σ_{S(T)} w_ρ (z_ρ/2^(β_max))^k|` below by
`(N/(8e(m+N)))^N` times a partial sum of the weights, which is nonzero
(positive real part). With `m = cN`, the errors are:
- H: `k²·2^(−k(β_max−σ))`, beaten once `c(β_max − σ)·log 2 > log(8e(1+c))`;
- the zeros left of `β*`: the same with `β_max − β*`, beaten the same way;
- the zeros above `T`, the tail: weight `O(T^(−(1−θ)))` by `ZeroDensity`, but
  their real parts can exceed `β_max(T)` (that is the creeping), so they cost
  `T^(−(1−θ))·2^(k(Θ−β_max(T)))`.
The tail must lie below `(8e(1+c))^(−N(T))`. So it needs
`N(T) ≪ log T`, and the density bound gives only a power of `T`.

**The lost factor.** `(8e(1+c))^(N(T))`: Turán's loss, one fixed factor per
zero in the finite set, against the polynomial saving `T^(1−θ)` of the
density bound. It grows with the parameter. By the repo's rule, the steps
are right and the design is wrong. The cause is the aliasing: no filter of
the dyadic samples can damp a zero by its height, because every filter acts
on the mode `2^ρ`, and the high zeros carry the same modes as the low ones.
The smoothing that makes Turán's method work on `ψ(x)` for all `x` is not
available on the doublings.

**What would rescue it.** Either a Turán-type bound whose loss is
subexponential in `N`, or zeros near the top so sparse that `N(T) = O(log T)`.
Neither is in the tree or in what was found.

### S7, round 3: a rescue of Turán's loss (2026-11-24, Julian: "Out the Turán rescue")

On paper, here, unchecked by anyone else.

**Turán's loss is the price of an arbitrary arrangement.** Its bound holds for
any `N` points. The roots of unity show that some loss is forced: their power
sums vanish for `k = 1, …, N − 1`. But for separated points the loss is
polynomial. On a window of length `K`, the Montgomery–Vaughan mean value
theorem gives `Σ_{k=m+1}^{m+K} |Σ_j c_j e^(ikφ_j)|² = Σ_j |c_j|²·(K + θ_j·3π/δ_j)`,
with `|θ_j| ≤ 1` and `δ_j` the distance from `φ_j` to the nearest other angle.
Once `K > 6π/δ`, this is at least `(K/2)·Σ|c_j|²`. The loss is `1/δ`, with no
power of `N`.

**On the wall.** Normalize `S(T)`'s modes by `2^(β_max(T))`, merge exact alias
fibres (`AliasClass`: each merged weight ≠ 0), and let `δ(T)` be the least
angular separation of the merged modes. The radial factors `|ζ_j|^k ≤ 1`
weaken only the zeros below the top, and the top one keeps its full share.
With `K ≈ 6π/δ(T)` and the shift `m` fixed by H's constant, the errors are:
- H: `k²·2^(−k(β_max−σ))`, small for `k ≥ m`;
- the zeros left of `β*`: small the same way;
- the zeros above `T`: `T^(−(1−θ))·2^(K(Θ − β_max(T)))`.
So the wall falls on every `T` with `(Θ − β_max(T)) ≤ c·δ(T)·log T`.

**What is left.** A creep that is fast against the separation. The real parts
near the top approach `Θ` more slowly than the angles `γ·log 2 (mod 2π)` of
the top zeros spread apart. Turán's `exp(N)` against the density saving has
become `1/δ(T)` against the creep rate, a contest between two properties of
the zeros near the top. Neither is bounded in the tree. Lower bounds for
`δ(T)` are bounds on near-coincidences `(γ − γ')·log 2 ≈ 2πn`, that is,
on how close the zeros come to the alias lattice. Bounds of that kind are
the territory of pair-correlation and simplicity results, which are open.

**The direction of the weights helps the clusters.** For `γ > 0`, every
weight is `m/ρ ≈ −i·m/γ`. Modes close in angle therefore add without
cancelling at every `k` with `k·(angle spread) < π/2`. A cluster of near
aliases acts as one heavy mode at those `k`, and the weights do not cancel
inside it. The exception is the clusters near the real axis, where a zero
meets its conjugate. This is not yet turned into a bound that replaces
`δ(T)`.

**Next.** (a) Turn the alignment of the weights into a mean value bound with
clusters in place of separated points. If that works, only the conjugate
clusters near the real axis keep a separation condition. (b) Check the
Montgomery–Vaughan step against the radial factors exactly. It is used here
for points on the circle.

### S7, round 3 (b): Montgomery–Vaughan with the radial factors (2026-11-24, Julian: "B")

On paper, here, unchecked by anyone else. Round 3 used the mean value theorem
as if every normalized mode sat on the circle. They sit inside it:
`ζ_j = r_j·e^(iφ_j)` with `r_j = 2^(β_j − β_max) ≤ 1`.

**Band the modes.** Fix `η' > 0`. The band is the modes with `β_j ≥ β_max − η'`;
the rest lie below it. On the window `k ∈ (m, m+K]`:
- in the band, `r_j^k = r_j^(m+1)·r_j^(k−m−1)`, and
  `|r_j^(k−m−1) − 1| ≤ K·η'·log 2`. So the band's sum is the circle sum with
  coefficients `c'_j = c_j·r_j^(m+1)`, plus an error at most
  `K·η'·log 2·‖c‖₁` at each `k`;
- below the band, every term is at most `|c_j|·2^(−m·η')`.

**The bound.** The circle part has `ℓ²` norm over the window at least
`√(K/2)·‖c'‖₂` once `K > 6π/δ_band` (round 3), with `δ_band` the least
separation of the band's merged angles. The two errors have `ℓ²` norm at
most `√K` times their sizes above. Both fall below half the main term when
- `η' ≤ ‖c‖₂ / (6·K·‖c‖₁)`, which `η' ≈ 1/(6K·√N_band)` meets, and
- `m ≥ (1/η')·log₂(8·Σ|w| / |c_top|)`, where `c_top` is the weight of the
  attained top of `S(T)`, with `r = 1`, so `‖c'‖₂ ≥ |c_top|`.

**So (b) holds, at a polynomial cost.** The window ends at
`m + K ≈ 6K·√N_band·log(Σ|w|/|c_top|) + K`, with `K ≈ 6π/δ_band`. The
corrected condition for the wall to fall at `T` is
`(Θ − β_max(T)) · δ_band(T)⁻¹ · N_band(T)^(1/2) · log(1/|c_top|) ≤ c·(1−θ)·log T`.
Every factor is a power of the parameters or a logarithm. Nothing in it is
exponential in `N`, unlike Turán's loss.

**What it costs against round 3.** The count enters again, through
`√N_band` and only for the zeros in the thin top band. The weight of the top
zero enters through a logarithm, with `|c_top| ≈ 1/|γ_top|`.

**What remains open.** The condition is about the zeros. It holds on
every `T` where the creep `Θ − β_max(T)` is small against
`δ_band·log T/√N_band`. A wall needs the creep to stay large against that
quantity at every height. Nothing in the tree bounds either side.
