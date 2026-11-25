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

### S7, round 3 (a): the aligned weights in clusters (2026-11-24, Julian: "Yes")

On paper, here, unchecked by anyone else.

**What alignment gives.** For `γ > 0` the weight `c'_j = w_j·(positive)` has
argument within `β_j/γ_j` of `−π/2`. A cluster `C` of band modes whose
angular diameter is `d` has `|Σ_C c'_j e^(ikφ_j)| ≥ cos(k·d + max β/γ)·Σ_C |c'_j|`.
So the cluster acts as one point of weight at least `½·Σ_C|c'|` at every `k`
with `k·d ≤ 1`.

**Where it breaks.** The bound reads `k·d`, measured from `k = 0` and not
from the window's start. The window is `(m, m+K]`, and round 3 (b) needs
`m ≈ 6K·√N_band·log(…)`, so the clusters need `d ≤ 1/(m+K)`. Between
clusters the mean value step needs separation `≥ 6π/K`. That is two scales
with a ratio of at least `6π(m+K)/K`, about `36π·√N_band·log(…)`.
- Grouping at one threshold `t` gives clusters of diameter up to `N_C·t` with
  gaps `≥ t`, and fails once a cluster holds a few points.
- Choosing a threshold that falls in a gap of the pairwise separations needs
  up to `N²` candidate scales. The ratio of the outermost to the innermost is
  exponential in `N²`, so `K` is too.

**Dirichlet gives the same.** Simultaneous approximation finds `k ≤ Q^N` with
every `kφ_j` within `2π/Q` of `0 (mod 2π)`. There every weight is aligned
and nothing cancels, except that each zero meets its conjugate: `−i/γ`
against `+i/γ`. What survives is `Σ 2β/γ²`, positive and exact, but `k` is
exponential in `N`.

**Result of (a).** Alignment does not remove the separation condition in
general. It removes it when the near-alias clusters have a two-scale gap:
diameter `≤ 1/(m+K)` and gaps `≥ 6π/K`. Every general route tried (Turán,
single grouping, the choice of scale, Dirichlet) meets a loss exponential in
the number of zeros near the top. Only the mean value theorem on separated
points, round 3, loses polynomially, and it pays in `δ_band`.

**The lost factor, named.** Without a lower bound on how near the top zeros
come to the alias lattice, `(γ − γ')·log 2 ≈ 2πn`, every route loses
`exp(c·N(T))` against the density saving `T^(1−θ)`. With such a bound,
`δ_band(T) ≥ T^(−a)`, round 3 (b) closes the wall at every `T` whose creep is
below `T^(−a)·log T/√N_band(T)`. The design question for the wall is now that
separation, a property of the zeros of ζ (unit 0431).

## S8 The lens ladder — on paper, no Lean target yet

Julian, 2026-11-24: couple the bases, because the tables run from dyadic to
enneadic. On paper, here, unchecked by anyone else.

**One base at a time.** Only 2, 3, 5 and 7 carry new information. 4, 8 and 9
are powers of 2 and 3, so their ladders are sub-samples of those. On its own
ladder each base has its own alias lattice `2π/log b` and its own wall. The
wall survives as long as some pair of top zeros sits near each base's
lattice, and different pairs can serve different bases.

**Coupled.** Sample `ψ` on `2^a·3^b`. A zero's mode is `(2^ρ, 3^ρ)`. Two zeros
share it only if `γ − γ'` lies in `(2π/log 2)ℤ ∩ (2π/log 3)ℤ = {0}`, so every
alias class is a single zero. A pair near the lattice in both coordinates
needs `|n·log 3 − n'·log 2|` tiny with `n, n'` of the order of `T`. Linear
forms in logarithms, through the finite irrationality measure of
`log 3/log 2`, bound it below by `c·T^(−A)`. That is the separation unit 0512
asked for, with no assumption on the zeros. It is not in Mathlib. The
elementary bound `|log(3^n/2^m)| ≥ 1/max(3^n, 2^m)` is exponentially small
and gives the exponential loss back.

**The creep.** `Θ − β_max(T)` belongs to the zeros and is the same through
every lens. Its cost is `x^(creep)` over the range of `x` the argument must
read, and that range falls as bases are added. Worst case, at any fixed
finite set of bases, the separation is Baker's `T^(−A)` and a slow creep
escapes.

**The end of the ladder.** Add every prime and the grid is every integer.
The hypothesis is then the square-root bound for `ψ(x)` at every `x`, the
staircase in the square-root frame, which the tree has as RH-equivalent:
`Readings.wire_holds_iff` (`SpiralLink ↔ Saddle.NoRunaway`). There Landau's
argument reads `x` continuously and the creep costs nothing.

**What it shows.** Every route closes through a face equivalent to RH: the
lens ladder, the thirteen doors of `map/ROAD.md`, the faces
`spiralLink_iff_*`. Equivalence connects the faces, and it does not supply a
proof. A proof needs one face derived from facts about ζ proved
independently of RH. Those already in the tree include the zero density
bound (`ZeroDensity`) and the zero counting (`Backlund`), and the next step
is to list them all. The design question for the ladder route is now which
of those facts, put in place of H, reaches a face.

## S9 Bases per creep rate — on paper, no Lean target yet

Julian, 2026-11-24: name, for each rate of creep, the number of coupled bases
that scale the wall. On paper, here, unchecked by anyone else.

**The circles.** In the mode `u = 2^(−s)`, the line `Re s = σ` is the circle
`|u| = 2^(−σ)`. `BandJoin` has the band: every zero lies between
`|u| = 1/2` (`Re s = 1`) and `|u| = 1` (`Re s = 0`), and the critical line is
the circle `bandR (1/2) = 2^(−1/2)` (`spiralLink_iff_middle`). The zeros right
of one half are the ring between the circles `1/2` and `2^(−1/2)`. Under H the
generating function is analytic inside `|u| < 2^(−1/2)`. So H's own horizon is
the circle of the critical line: the bound sees the ring only from inside.

**The statement.** For a creep `Θ − β_max(T) ≤ T^(−b)`, `b > 0`, and the first
`r` primes as coupled bases:
- input `H_r`: `|ψ(x) − x| ≤ C·log²x·√x` at every `x = p₁^(a₁)⋯p_r^(a_r)`;
- arithmetic input `D_r(κ)`: every `Δ` with `1 ≤ |Δ| ≤ T` has
  `max_i dist(Δ·log p_i, 2πℤ) ≥ c·T^(−κ)` (simultaneous approximation);
- conclusion: if `κ + θ_band/2 < b`, the wall does not form.
  Here `θ_band` is the density exponent of the band count, `N_band(T) ≤ T^(θ_band)`.

**What is known about `D_r(κ)`.** Dirichlet's theorem gives an upper limit:
some `Δ ≤ T` reaches `T^(−1/(r−1))`, so `κ ≥ 1/(r−1)` always. That
`κ = 1/(r−1) + ε` holds for the logarithms of the primes is not proved.
Linear forms in logarithms give some finite `κ_r`, much larger. With the true
`κ_r`, the count of bases needed is the least `r` with `κ_r + θ_band/2 < b`.

**What it does not cover.** A creep slower than every power, and a band
whose density exponent alone exceeds `b`. Both escape every finite `r`. The
input `H_r` grows with `r` and reaches `NoRunaway` as `r` grows without
bound (S8).

## S10 The horizon and the floor — design, no Lean target yet

Julian, 2026-11-24: write up the frame of unit 0515 as a design block for the
open items. On paper, here, unchecked by anyone else.

**The objects.**
- The horizon: `θ(t) = arg(Gammaℝ(1/2 + it))` taken continuously, with
  `θ(0) = 0`. Mathlib has `Gammaℝ`, `completedRiemannZeta` and
  `completedRiemannZeta_one_sub`. `θ` is not in the tree.
- Hardy's function: `Z(t) = e^(iθ(t))·ζ(1/2 + it)`. It is real for real `t`
  by the functional equation and conjugation (`logDerivZeta_conj`, the
  `ZetaConj` file). `Z` is not in the tree.
- The threshold count: `N(T) = θ(T)/π + 1 + S(T)`, `S(T) = (1/π)·arg ζ(1/2 + iT)`.
  The tree has `N(T)` and its main term through `Kadiri` (`zetaCountingMainTerm`),
  without the split into `θ` and `S`.
- The floor: `MollifiedMean.M X s` and `f X s = ζ(s)·M(X, s) − 1`, with
  `f_eq` in the tree.

**Targets, in order.**
1. `Z_real`: `Z(t)` is real. It follows from `completedRiemannZeta_one_sub` and
   conjugation. This is the first Lean step, and it is unconditional.
2. `signChange_is_zero_on_line`: a sign change of `Z` on `[t₁, t₂]` gives a zero
   `1/2 + iγ` with `γ ∈ [t₁, t₂]`, by the intermediate value theorem on a real
   continuous function.
3. `rh_iff_signChanges`: RH holds exactly when, for every `T`, the zeros on the
   line up to `T`, counted with multiplicity by the sign changes and the
   orders of `Z`, number `N(T)`. One direction is the definitions; the other
   is the count.
4. The floor, on paper first: Levinson's inequality bounds the number of zeros
   off the line by an integral of `log|ψ·ζ|` on a line left of one half, with
   `ψ` a mollifier. The mean value `∫|ψ·ζ|²` that it needs is the missing
   piece. The tree's `MollifiedMean` bounds `|f|²` right of one half, so it
   would have to be moved to the line and the mollifier fitted.

**What it does not do.** No known mollifier gives every zero. Step 4 at full
strength is the open problem. Steps 1 to 3 are unconditional and
build the frame in which H, the wall and the floor can each be read as a count
of missed sign changes.

### S10 step 4: the floor, on paper (2026-11-24, Julian: "Yes to log and step 4 please")

On paper, here, unchecked by anyone else. Steps 1 to 3 are in Lean (units
0516 and 0517). Step 4 has to produce sign changes, or zeros on the line, in
proportion to the full count.

**4a, Littlewood's lemma.** For `f` analytic on the rectangle `[σ₀, 3] × [T, 2T]`
and nonzero on its edges, `2π·Σ_{zeros, β>σ₀} (β − σ₀) = ∫_T^{2T} log|f(σ₀+it)| dt
− ∫_T^{2T} log|f(3+it)| dt + (horizontal sides)`. It is the argument principle
integrated across. The tree has the pieces: `JensenCount`, `ArgCount`, and the
dependency's `RectangleArgumentPrinciple`. It does not have the lemma. It is
unconditional.

**4b, concavity.** `∫ log|f| ≤ (T/2)·log((1/T)∫|f|²)`. With `f = ζ·M`, every zero of
`ζ` right of `σ₀` is a zero of `f`. If the mean square of `ζ·M` on `Re s = σ₀` is
`T·(1 + o(1))`, the right side is `o(T)`, and so is the weighted count of zeros
right of `σ₀`.

**4c, what the tree's floor reaches.** `MollifiedMean` bounds `∫|ζ·M − 1|²` on
`Re s = u > 1/2`, with the mollifier `M_X = Σ_{d<X} μ(d)·d^(−s)`. Taking that to
`∫|ζ·M|² = T·(1 + o(1))` and feeding it to 4a and 4b gives Bohr–Landau: zeros right
of any `u > 1/2` are `o(T)`, against `N(T) ~ (T/2π)·log T`. This is the strongest
step the tree can build from what it has. It puts the zeros near the line,
and not on it.

**4d, the step onto the line (Levinson).** Take `σ₀ = 1/2 − R/log T`, left of the
line, and apply 4a and 4b to `V·M`. Here `V = ζ + ζ'/log T` (in Levinson's
combination) and `M` is a mollifier with smooth weights `μ(n)·P(log(y/n)/log y)`,
`y = T^θ`. Levinson's lemma turns zeros of `V` right of `σ₀` into a bound on the
zeros of `ζ` off the line, through the functional equation. The proportion on
the line is at least `1 − (1/R)·log((1/T)∫|V·M|²)`. The input is the mean value
of `|V·M|²` just left of the line. Conrey's evaluation, for lengths `θ < 4/7`,
gives over 40%, and later work gives a little more. None of this is in the tree.

**Where the floor stops.** The proportion grows with the mollifier's length
`θ`. No known mean value reaches a length that gives 100%. From memory, not
checked this session: Farmer observed that the mean value for arbitrarily long
mollifiers, if it held as conjectured, would give 100%. That would be a
statement about the zeros as a whole, which is the gap of S7 to S9 in another
form.

**Build order, if pursued.** 4a (Littlewood) in Lean, unconditional. Then 4b.
Then 4c, Bohr–Landau, from `MollifiedMean`. 4d needs a mean value left of the
line, which is a large analytic project.

## S11 Levinson's lemma — on paper, no Lean target yet

Julian, 2026-11-24: "Yes" (design Levinson's lemma after Littlewood, unit
0518). On paper, here, unchecked by anyone else. The formulas in Levinson's
and Conrey's forms are recalled from memory and were not checked against a
source this session. Check them before any Lean is pinned.

**The shape of the method.** Write `L = log(T/2π)`. Take `V(s) = Q(−(1/L)·d/ds) ζ(s)`
with `Q` a real polynomial, `Q(0) = 1`; Levinson's choice is `V = ζ + ζ'/L` up to the
normalizing constant. Take a mollifier `M(s) = Σ_{n≤y} μ(n)·n^(−s)·P(log(y/n)/log y)`,
`y = T^θ`, `P(0) = 0`, `P(1) = 1`. Take `σ₀ = 1/2 − R/L`.
1. **Levinson's lemma.** On the critical line, a zero of `ζ` is forced at every
   point where the argument of `V` passes a multiple of `π`, through the functional
   equation `ζ(s) = χ(s)·ζ(1−s)`. Counting the argument along `[1/2, 1/2 + iT]` by the
   argument principle on the rectangle to its right gives
   `N₀(T) ≥ N(T) − 2·N_V(T) − O(L)`. Here `N₀` counts the zeros of `ζ` on the line,
   which is `LineCount.lineCount`, and `N_V` the zeros of `V` with `σ > 1/2` and
   `0 < t ≤ T`.
2. **Littlewood on the left.** `littlewood_rect` for `V·M` on `[σ₀, 3] × [T, 2T]` gives
   `2π·Σ (β − σ₀) = ∫ log|V·M(σ₀+it)| − ∫ log|V·M(3+it)| + (edge terms)`. The zeros
   of `V` with `β > 1/2` are at distance at least `R/L` from `σ₀`. So
   `N_V(2T) − N_V(T) ≤ (L/(2πR))·(right side)`.
3. **The edge terms.** `∫ log|V·M(3+it)| = o(T)`, since `V·M → 1` far right. The
   horizontal terms are `O(L·(3 − σ₀))`, by the local zero count (`JensenCount`).
4. **Concavity.** `∫ log|V·M| ≤ (T/2)·log((1/T)∫|V·M|²)`.
5. **The mean value, the floor.** `(1/T)∫_T^{2T} |V·M(σ₀+it)|² dt → c(P, Q, R, θ)`, an
   explicit constant, for `θ < 1/2`, or `θ < 4/7` in Conrey's work.
6. **Assembly.** `κ = liminf N₀/N ≥ 1 − (1/R)·log c(P, Q, R, θ)`. With the best
   `P`, `Q`, `R` this is positive: about 34% for Levinson and over 40% for Conrey.

**What is in the tree for each step.**
- Step 1: `HardyZ`, `LineCount`, the conjugate symmetry and the functional
  equation (Mathlib). The argument count on the line is not in the tree.
- Step 2: `Littlewood.littlewood_rect`.
- Step 3: `JensenCount`, `ArgCount`, and the far-right size of ζ (`ZetaBounds`).
- Step 4: Jensen's inequality for the logarithm. Mathlib has the concavity of the
  logarithm.
- Step 5: none. `MollifiedMean` has a mean square right of `1/2` for `M_X` without
  `P`, `Q` or the shift left of the line. This is the large step.

**Order of building.** 1, then 2 to 4 as the zero-count bound in terms of a mean
square, which is unconditional and holds for any `V` and `M`. Then 5, which is
the analytic core. The theorem after 1 to 4, `κ ≥ 1 − (1/R)·log(mean square)`, can
be stated with the mean square as a hypothesis. That makes the floor exactly
one named input, in the same way H is for the ladder.

### S11, checked against sources (2026-11-24, Julian: "Go")

Read this session: Young, "A short proof of Levinson's theorem" (arXiv
1002.4403), and Feng, "Zeros of the Riemann zeta function on the critical line"
(arXiv 1003.0059). The text is in the session scratchpad.

**Corrections to S11.**
- `L = log T` (Young §1), not `log(T/2π)`.
- `V(s) = Q(−(1/L)·d/ds)ζ(s)`, a real polynomial `Q` with `Q(0) = 1`. Feng's Lemma 1
  adds `Q'(x) = Q'(1−x)`. Levinson's `Q(x) = 1 − x` gives `V = ζ + ζ'/L`.
- The mollifier (Young §1) is `ψ(s) = Σ_{h≤M} μ(h)·h^(−(s + 1/2 − σ₀))·P(log(M/h)/log M)`,
  `M = T^θ`, `0 < θ < 1/2`, `P(0) = 0`, `P(1) = 1`.
- The bound (Young (1.1); Feng (2.6) for Conrey's longer `B`):
  `κ ≥ 1 − (1/R)·log((1/T)∫_1^T |Vψ(σ₀+it)|² dt) + o(1)`.
- The mean value (Young (1.2) and (1.3)):
  `(1/T)∫_1^T |Vψ(σ₀+it)|² dt = c(P,Q,R,θ) + o(1)`, with
  `c = 1 + (1/θ)∫_0^1∫_0^1 e^(2Rv)·[ (d/dx)(e^(Rθx)·P(x+u)·Q(v+θx)) at x = 0 ]² du dv`.
  With `P(x) = x`, `Q(x) = 1 − x`, `R = 1.3`, `θ = 0.5`: `c = 2.35…` and `κ ≥ 0.34…`.

**Step 1, derived here.** Neither source states the counting lemma. They cite
Conrey's §3 and Levinson and Montgomery for it. Derivation, with `Λ = Gammaℝ·ζ`,
`g = Gammaℝ'/Gammaℝ`, a real constant `λ`, and `G = ζ + λ·ζ'`:
- `Gammaℝ·ζ' = Λ' − g·Λ`. On the line `Λ` is real (`HardyZ.xi_line_real`), so `Λ'` is
  purely imaginary, since `d/dt Λ(1/2+it) = i·Λ'(1/2+it)` is real.
- Hence, on the line, `Re(Gammaℝ·G) = Λ·(1 − λ·Re g)`.
- Where `1 − λ·Re g ≠ 0`, the zeros of `ζ` on the line are exactly the points where
  `Re(Gammaℝ·G) = 0`, the points where `arg(Gammaℝ·G)` passes `π/2 mod π`. They number
  at least `(1/π)·|Δ arg(Gammaℝ·G)| − 1` along `[1/2, 1/2+iT]`.
- `Δ arg Gammaℝ = θ(T)`, the horizon of unit 0515. The argument principle for `G` on
  the rectangle right of the line gives `Δ arg G = −2π·N_G⁺(T) + O(L)`.
- So `N₀(T) ≥ N(T) − 2·N_G⁺(T) − O(L)`, which is the form in S11, with `λ = 1/L`.

**Lean, step 1a (unconditional).** `re_gammaR_G_line`: for real `λ` and real `t`,
`Re(Gammaℝ(s)·(ζ(s) + λ·ζ'(s))) = Λ(s)·(1 − λ·Re(Gammaℝ'(s)/Gammaℝ(s)))` at `s = 1/2 + it`.
Step 1b, the count through a continuous argument along the line, follows it.

### S11, removing `hsimple` by counting (2026-11-25, Julian: "Log it and count")

On paper, here, unchecked by anyone else.

**The zeros of G on the line.** By `G_line_ne`, a zero of `G = ζ + cζ'` at
`ρ = 1/2 + iγ` is a common zero of `ζ` and `ζ'`. If `ζ` has order `m ≥ 2` at `ρ`, then
`ζ'` has order `m − 1`, and so does `G`, since `ζ'` dominates. Call the finite set of
these points in the window `D`, and put `k_ρ = m_ρ − 1`, `K = Σ_D k_ρ`.

**Divide them out.** `P(s) = Π_{ρ∈D} (s − ρ)^{k_ρ}`, `H = G/P`, which is analytic and
nonzero on the line segment. On the line, `s − ρ = i(t − γ)`, so `P = i^K × real`.
Take `F = i^(−K)·Gammaℝ·H`, so that `Re F = (real)·Λ·(1 − c·Re g)`. Every
crossing of the imaginary axis by `F` is then a zero of `ζ` on the line, by
`zeta_line_zero_iff` away from `D`. On `D`, ζ vanishes anyway.

**The two counts cancel `K`.**
- Turning of `F` = Gammaℝ part + turning of `H`. The argument principle for `H` on
  the rectangle: `H` has the zeros of `G` inside, and none on the border.
- The edge terms for `H` are those of `G`, less the turning of `P` around the
  bottom, the right side and the top. Each factor `s − ρ`, with `ρ` on the left
  edge, turns by exactly `π` there, so the extra term is `−π·K`.
- So the crossings number at least `(N(b) − N(a)) − 2·N_G − K − E/π − 1`.
- `lineCount` counts the crossings off `D` once each and every `ρ ∈ D` with
  multiplicity `m_ρ = k_ρ + 1`. So `lineCount ≥ #crossings − #D + Σ m_ρ
  = #crossings + K`.
- Hence `lineCount ≥ (N(b) − N(a)) − 2·N_G − E/π − 1`, with no `hsimple`.

## S12 The mean value, the floor — design (2026-11-25, Julian: "start the next step")

On paper, here, unchecked by anyone else. The target is Young's Theorem 1, his
(1.2) and (1.3) (arXiv 1002.4403, text in the session scratchpad): the
mean square of `Vψ` on `σ₀ = 1/2 − R/L` is `c(P,Q,R,θ)·T + o(T)` for `θ < 1/2`.
Together with `LevinsonMultiple.levinson_window'`, it gives the first
proportion of zeros on the line in Lean.

**Why the tree's Euler–Maclaurin is not enough.** `ZetaEM` writes
`ζ = Σ_{n≤N} n^(−s) + …` with an error that is small only for `N` well past `T`
near the line. A Dirichlet polynomial of length `N` has mean value
`Σ|a_n|²(T + O(n))` (`DirichletMean.dirichlet_mean_value`), so a length beyond
`T` makes the error larger than the main term. The approximate functional
equation fixes this. It writes ζ near the line as two sums of length about
`√T`, joined by the functional equation's factor.

**The pieces, in Young's order.**
1. **The approximate functional equation**, Young's Lemma 4. It covers
   `ζ(1/2+α+it)·ζ(1/2+β−it)` as two smoothed double sums `Σ m^(−1/2−α) n^(−1/2−β) (m/n)^(−it) V(mn, t)`
   plus `X_{α,β,t}` times the swapped sum, for `Re α, Re β < 1/2`, with error
   `O((1+|t|)^(−A))`. The proof shifts a Mellin integral of `G(s)/s` past `s = 0`
   and uses the functional equation (Mathlib's `completedRiemannZeta_one_sub`).
2. **The twisted second moment** `I(α,β)`, Young's Lemma 3:
   `∫ w(t) ζ(1/2+α+it) ζ(1/2+β−it) |ψ(σ₀+it)|² dt = c(α,β)·ŵ(0) + O(T/L)`.
   The diagonal `hm = kn` gives the main term, and the off-diagonal is small for
   `θ < 1/2`. The tree's `DirichletMean`, `DirichletMeanW` and `SquareMean` hold
   the mean value theorems for Dirichlet polynomials that this step uses.
3. **The operator**: apply `Q(−(1/L) d/dα)·Q(−(1/L) d/dβ)` at `α = β = −R/L`. This
   gives `c(P,Q,R,θ)`, through Cauchy's formula on circles of radius about `1/L`.
4. **Unsmoothing**: from `w` to the sharp interval `[T/2, T]`, then dyadic sums
   (Young §2).

**Order.** 1, then 2, then 3 and 4. Piece 1 is unconditional and
self-contained, so it goes first.

## S13 Stage B, the proportion toward one — design (2026-11-25, Julian: "Yes to all please")

On paper, here, unchecked by anyone else, except where a check is named.

**Where the length enters stage A.** `FloorSum.levinson_floor` holds at
`θ = 49/100`. The length exponent `θ < 1/2` enters the chain at three size
statements only, each an error term:
- `Diagonal.final_size_diag`: the shifted diagonal integral, `O(L⁵·T^(3/4+θ/2))`;
- `OffDiagClose.final_size`: the off-diagonal after `r` integrations by parts;
- `SwapX.size_X`: the Stirling remainder of the swapped term.
The main term is general in `θ`: `FloorConst.Kfl A B C θ R`, `re_dop_tendsto`
for any `θ > 0`, and `Arith`, `SdiagLead`, `Operator`, `Unsmooth`, `FloorStep`
take `θ` as a parameter.

**B1, Lean, buildable now.** `floor_of_long`: the floor for every `θ > 0`, with
the three error statements as one named hypothesis `StmtLongErr P θ R`. Then
stage B is exactly one named input, as S11 made the mean value one input for
the floor. Its conclusion: `lineCount T ≥ (1 − log(Kfl …)/R − ε)·N T`.

**B2, the main term for long mollifiers.** Computed here, not proved: with
`P(x) = x` and Levinson's `Q`, the best `κ(θ)` over `R` is 0.3428 at `θ = 1/2`,
0.3902 at `4/7`, 0.5195 at `1`, and then falls (0.3798 at `2`, below zero by
`4`). So `P` has to change with `θ`. Feng (arXiv 1003.0059, read this
session) cites Farmer's "θ = ∞ conjecture" and his proof that it implies
100%. Farmer's paper was not read. Steps:
- B2a: optimize `P` of degree `d` (and `Q` of degree `d'`, which needs the
  operator with a general `Q`) for `θ = 1, 2, 4, 8` in Python, and record the
  best `κ(θ)`.
- B2b: derive, on paper, Farmer's limit `sup_{P,Q,R} κ(θ) → 1` from the closed
  form, then state it in Lean as a statement about `Kfl` (with general `Q`).

**B3, the core: the error terms for `θ ≥ 1/2`.** Conrey reaches `θ < 4/7`
through Kloosterman sums (Deshouillers–Iwaniec); none of that is in the tree.
The off-diagonal is the pairs `(h, k)` of mollifier terms coupled through
`hm ≠ kn`: for each shift `r = hm − kn`, a shifted convolution sum of the
coefficients `μ(h)P(…)` against the divisor-type sum over `(m, n)`. This is
the coupling of the composites in Julian's picture: the mollifier's terms are
the composites, and `StmtLongErr` asks that their couplings across every
shift cancel to `o(T)`. The design question for B3 is which cancellation in
`Σ_{hm−kn=r} μ(h)μ(k)·…` that is, and what size it must have at length `T^θ`.

**What B gives C.** `lineCount T ≥ (1 − ε)·N T`: the defect
`N T − lineCount T` is `o(N T)`.

## S14 Stage C, from the defect to zero — design (2026-11-25, Julian: "Yes to all please")

On paper, here, unchecked by anyone else.

**What is already settled (S7 to S9).** The ladder route through S1–S6 takes
H, the bound on `ψ` at the doublings. The wall (S7) closes under H only with a
separation bound on the top zeros near the alias lattice and a bound on the
creep. S8 records that every route reaches a face equivalent to RH, and that a
proof needs one face derived from facts about ζ proved independently of RH.
`rh_iff_line_count` is such a face: `RiemannHypothesis ↔ ∀ T, lineCount T = N T`.

**The independent facts now in the tree.** `ZeroDensity` (few zeros right of
any `σ > 1/2`), `Backlund` and `ArgCount.rvM_crude` (the count `N T`),
`Littlewood.littlewood_rect`, the Levinson chain, and `FloorSum.levinson_floor`
(the defect at most `(2/3 + ε)·N T`).

**The defect.** `D(T) = N T − lineCount T` counts the zeros off the line, with
multiplicity. B makes it `o(N T)`; C needs `D(T) = 0`. Every bound in the
Levinson chain is an average over a window, and an average bounds `D` from
above without excluding one zero: a single off-line quadruple changes `D` by 2
and the means by `O(1/T)`. So C needs an input that sees one zero.

**C1, Lean, buildable now.**
- `defect_even`: `D(T)` is even, from the pairing `ρ ↔ 1 − ρ̄` of the off-line
  zeros (functional equation and conjugation, already in the tree).
- `defect_le`: `D(T) ≤ (2/3 + ε)·N T` from `levinson_floor`, and the form taking
  B's input, `D(T) ≤ ε·N T`.

**C2, the local face.** One off-line zero `ρ₁ = β₁ + iγ₁` must be excluded by
something local at `γ₁`. In Julian's picture this is the basin: between two
consecutive zeros of `Z` on the line, the horizon `θ(t)` turns by about `π`,
and `S(T) = N T − θ(T)/π − 1` measures the excess. An off-line pair at height
`γ₁` takes two from the zeros on the line near `γ₁`: there the turning of the
horizon is not matched by sign changes of `Z`. The candidate statement is a
local Levinson count: on a window `[γ₁ − H, γ₁ + H]` with `H` small against
`T`, the zeros on the line at least the window's share of `N`, less an error
below 2. Levinson's error terms are `O(log T)` per window (`levinson_window_diff`,
`134 log T + 2918`), so the local count needs windows where that error is below
the step of 2.

**C3, the design question.** Which local quantity of the horizon and the
basins, read on a window of length `H`, has an error below 2 at every height,
so that an off-line pair cannot hide in it. The next round is that
derivation on paper: the error of `levinson_window_diff` as a function of the
window length `H` (its terms `(b − a)·tailDelta`, `X²·log T`, `134 log T`), and
the length at which each term drops below the step.

### S14, C3: the local count's error, by its terms (2026-11-25, Julian: "Yes to all please")

On paper, here, unchecked by anyone else. Read from `LevinsonCount.lean`'s header
and `LevinsonWindowNear.levinson_window_diff` this session.

**The terms.** On a window `[a, b]`, Levinson's count is
`lineCount b − lineCount a ≥ (N b − N a) − 2·countG − E`, with `countG` the zeros of
`G = ζ + ζ′/L` right of the line and `E` the rest:
- the horizontal edges, `|horiz T| ≤ 21π log T + 133π` at each end
  (`LevinsonEdge.horizontal_edge_le`): the turning of `G` along a horizontal segment;
- the gamma part against the count, `30 log b + 150`
  (`LevinsonSize.gamma_part_count_le_gt_two`): the turning of the horizon against
  `N`, the term `S(b) − S(a)`;
- the window's own terms, `(b − a)·tailDelta`, `X²·log T`, constant over `R/L`.

**Against the step of 2.** Two sizes fail, and neither shrinks with the window.
- `E ≥ 134 log T` in the window form: the edge terms are bounds on argument
  changes at single heights. They are of the size of `S(t)`, which is unbounded
  (from memory, not checked this session: Selberg's lower bounds for `S(t)`).
  The shorter windows of a sum over windows do not remove them; each window
  pays them at its ends.
- `2·countG` is the window's share of the zeros of `G` right of the line. Feng
  (arXiv 1003.0059, read this session, his remark (a)) records that `G` has a
  positive proportion of its zeros near the line. In a short window around
  one height that share is of the order of the window's zeros, and it is the
  floor's own loss.
So the local Levinson count cannot see one zero. This is the size of what the
steps add up to, and by the repo's rule the C2 design is wrong.

**What the window frame says exactly.** With `Z` Hardy's function and the
horizon `θ`, `N b − N a = (θ(b) − θ(a))/π + S(b) − S(a)` (up to the `O(1/t)` of the
count's main term), and `lineCount b − lineCount a` is the number of zeros of
`Z` in `(a, b]` with order. So the window's defect is, exactly,
`(θ(b) − θ(a))/π + S(b) − S(a) − (zeros of Z in (a, b])`. A face with no error term
is this identity in every window: the zeros of `Z` keep pace with the turning
of the horizon plus `S`. That is Julian's picture stated as an equality: every
basin holds its zero.

**The design question now.** Which property of the basins forces that pace in
every window. Candidates, each a statement about `Z` on one window:
- a sign change of `Z` in each interval where the horizon turns by `π`
  (Gram's law; it fails at some Gram intervals, from memory);
- a bound on `S(b) − S(a)` together with a lower count of sign changes of `Z`
  from the turning of the horizon alone.
Each is a statement about individual windows, of the kind C needs. Which one
to derive first is Julian's choice.

### S14, C3 (a) and (b) tried (2026-11-25, Julian: "Try both please")

Computed with mpmath, `siegelz` and `grampoint`, script in the session
scratchpad (`c4/gram.py`): the Gram points `g_n`, `θ(g_n) = nπ`, for
`n = −1, …, 999`, up to height 1420. Not proved; the facts marked from memory
were not checked this session.

**(a) Gram's law.** `(−1)^n Z(g_n) > 0` fails at 42 of the 1001 points, the first
at `n = 126`. So "a sign change of `Z` in each Gram interval" is false already at
height about 280. Rosser's rule, the next local rule (a Gram block, the run
between two good Gram points, of `k` intervals holds `k` sign changes), held on
all 42 blocks here. From memory: Rosser's rule fails first near Gram index
13,999,825, and every such rule fails somewhere; the share of bad Gram points
grows slowly with the height. A fixed local rule on Gram intervals is not a
face.

**(b) S and the sign changes.** What holds in every window is integrated:
`∫ S(t) dt` over `[t₁, t₂]` is `O(log t₂)` (Littlewood; explicit constants are
Turing's and Trudgian's, from memory). Turing's method uses exactly that: on a
range where the sign changes of `Z` found by computation reach `θ/π + 1` at a
Gram point, the integral bound on `S` shows no zero was missed. So (b) is a
certificate for each finite range, built from a computation of `Z` on that
range. It gives the defect zero up to every height that has been computed, and
says nothing beyond it.

**What both say for C.** Every statement about individual windows found so far
is either false at some height ((a), Rosser) or a computation of that window
((b), Turing). C needs a reason, valid at every height, for `Z` to change sign
in step with the horizon. In Julian's picture: a mechanism that fills every
basin. The design question stays C3's, now with these two routes closed as
general statements and (b) open as a finite verification in Lean (Turing's
method on a range), which the tree does not have.

### S13, B4: the operator with a general Q, after Conrey 1983 (2026-11-25, Julian: "Yes to all please")

Read this session: Conrey, "Zeros of derivatives of Riemann's ξ-function on the
critical line", J. Number Theory 16 (1983), 49–74, §4 (PDF from Julian; text in
the session scratchpad, `papers/conrey/main.txt`). His Bulletin announcement of
two fifths (Bull. AMS 20 (1989)) was read too; it has no proofs.

**What failed.** Levinson's line identity for `V = Q(−(1/L) d/ds) ζ` holds only for
linear `Q` (`OperatorQ`'s docstring and the worker's numeric check: for a cubic
`Q`, `Re(Gammaℝ·V)` is not zero at the zeros of ζ on the line).

**Conrey's route.** For a real `φ` with `φ(0) = 1` and `φ(z) + φ(1 − z) = K ≠ 0`
(equivalent to `φ′(x) = φ′(1 − x)`), the Riemann–Siegel integral gives
`K·ξ(s) = Q(s) + Q(1 − s)`, `Q = H·V`, his (1) at `m = 0`. On the line the two
terms are conjugate, so `ξ(1/2 + it) = 0` exactly where `arg Q ≡ π/2 (mod π)`, and
`N₀ ≥ N − (1/π)·Δ arg V − O(log T)`, his (2). His `V` is
`C(s) + χ(s) D(s) + (small)`, `C(s) = Σ c(n)(F(s) − log n)^m n^(−s)`, `F = H′/H`,
`c(z) = φ(L⁻¹ log z)`: the coefficients carry `F(s) − log n`, the shift by
`F ≈ ½ log(t/2π)` that `OperatorQ` found as `(g − L/2)/L`.

**The tree's form.** `OperatorQ.W = Q(1/2 − (1/L) d/ds) Λ` already has
`Re W = Q(1/2)·Λ` on the line. With `Λ(1 − s) = Λ(s)`, the odd derivatives change
sign under `s ↦ 1 − s` and the even ones above order 0 have zero coefficient, so
`W(s) + W(1 − s) = 2·Q(1/2)·Λ(s)`: Conrey's identity with `K = 2Q(1/2)`, with no
Riemann–Siegel integral. `V = W/Gammaℝ = Q(−(D + g − L/2)/L) ζ`.

**Steps.**
1. `conrey_identity` and the count through `arg W` (`ConreyCount`, building).
2. The edges for `V`: its size far right is a polynomial in `(g − L/2)/L`, near
   a constant on `[T/4, 2T]`; on lower windows the shift is about `j/L`.
3. The mean value of `ψV`: a sum over `k, l` of `(−1/L)^(k+l)` times twisted
   moments of `ζ^(k)` and `ζ^(l)` with polynomial weights in `(g − L/2)/L`; the
   operator of piece 3 with a general `Q` and a weight.
4. The closed form, Young's (1.3) with general `Q`; Conrey's Corollary gives
   `κ ≥ 0.3658` at `θ = 1/2`, the figure unit 0551 computed.

### S13, B3: the error terms at lengths of one half and more (2026-11-25, Julian: "Yes to all please")

On paper, here, unchecked by anyone else. Facts marked "from memory" were not
checked against a source this session.

**Where the tree stands.** `FloorQ.levinson_floorQ` proves `224/625` at
`θ = 49/100`. `FloorLong.floor_of_long` and `GrRatio.mollMeanV_long'` carry the
whole chain to any `θ > 0` from `FloorLong.StmtLongErr P θ R`: the diagonal's
shifted line, the off-diagonal and the swapped term at length `T^θ`. Unit 0551
computed the floor that input would give: 0.41 at `4/7`, 0.89 at `4`, 0.978 at
`16`, with cubic `P` and `Q` re-optimized.

**The three error terms at `θ ≥ 1/2`, by size.**
- The swapped term (`SwapX.size_X`): its remainder meets `T^θ`, the mollifier's
  length, against `t^(1/2)` from the shifted sums; it closes for `θ < 1/2` with
  the tree's pointwise bounds. Past one half it needs the same cancellation as
  the off-diagonal.
- The diagonal's shifted line (`Diagonal.final_size_diag`): `O(L⁵·T^(3/4+θ/2))`,
  below `T` exactly when `θ < 1/2`. Moving the line further left needs the
  growth of ζ further left, a convexity-type loss; Young moves `u, v` as well and
  gets `T^(1−ε)` (from his §6, read this session). This one is a matter of
  bookkeeping, not of new arithmetic.
- The off-diagonal (`OffDiagClose.final_size`): the sums over `hm ≠ kn` of the
  mollifier coefficients times a smooth weight in `mn` and the height. Grouped
  by the shift `r = hm − kn`, each group is a shifted convolution of the
  divisor-type sum over `(m, n)` against `μ(h)μ(k)·P·P`. Integration by parts in
  the height bounds each term trivially; that bound is what stops at one half.

**What Conrey does past one half** (from his Bulletin announcement, read this
session, and from memory for the details): the off-diagonal with `θ < 4/7` is
written through Kloosterman sums, and the bounds of Deshouillers and Iwaniec
for averages of Kloosterman sums, from the Kuznetsov trace formula, give the
cancellation. None of this is in the tree or in Mathlib. As a Lean project it
is the spectral theory of `SL₂(ℤ)` at the level of Maass forms, which is
very large.

**What every length needs.** Farmer's θ = ∞ conjecture (cited by Feng, read
this session; Farmer's paper not read) is the statement that the twisted moment
keeps its main term at every length. In the tree's terms it is
`StmtLongErr P θ R` for every `θ`. Its content is the off-diagonal: that the
couplings of the mollifier's terms across every shift `r` cancel to `o(T)` at any
length. In Julian's picture, the composites coupled across every shift add to
nothing beyond the diagonal.

**Steps, in order of size.**
1. The diagonal's shifted line at any `θ`: move `u, v` as Young does. Bookkeeping
   on the tree's `Diagonal` files.
2. The off-diagonal grouped by the shift `r`, with the shifted convolution sums
   named: `StmtShiftedConv θ`, the bound that `StmtLongErr` needs, stated in
   the form a spectral or arithmetic argument would prove it.
3. The design question for Julian: which property of the Möbius coefficients
   across shifts gives that cancellation, and at what length. Up to `4/7` the
   literature answers it with Kloosterman sums; beyond, nothing is known.
