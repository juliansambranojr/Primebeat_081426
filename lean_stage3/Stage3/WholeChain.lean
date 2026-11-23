/-
WholeChain — block J8 of `lean_stage3/design/closedloop.md`. 2026-11-23.

The closing theorem. `OneChain.one_chain` was written before the later blocks
of the day. This file names them, so that every branch of the tree ends in one
place.

  whole_chain   the spiral link and each of its faces: the Riemann hypothesis,
                one zero at each height, the cells at square-root size, the
                sieve's wobble, the middle circle of the band, the pair meeting,
                every zero a centre, the staircase not running away
  table_side    what is proved of the table with no zero in it: the sieve's
                sum, the composites without signs, the compression, the tie
                across the scales, the fold of a mode
  steps_side    what a zero does to the staircase and to the turned steps

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.Saddle
import Stage3.Compression
import Stage3.SelfBound
import Stage3.StepsBelow
import Stage3.RunTheorems

namespace WholeChain

open Kadiri SpiralLink
open scoped Classical

/-- **The whole chain.** The spiral link, and every face of it compiled in the
tree, are one statement. -/
theorem whole_chain :
    (RiemannHypothesis ↔ SpiralLink.SpiralLink) ∧
    (SpiralLink.SpiralLink ↔ OneAtEachHeight) ∧
    (SpiralLink.SpiralLink ↔ ∃ (C : ℝ) (r₀ : ℤ), CellResidual.CellsSqrt C r₀) ∧
    (SpiralLink.SpiralLink ↔ HalfSieve.WobbleSqrt) ∧
    (SpiralLink.SpiralLink ↔
      ∀ ρ : NontrivialZeros, ‖(2 : ℂ) ^ (-(ρ : ℂ))‖ = BandJoin.bandR (1 / 2)) ∧
    (SpiralLink.SpiralLink ↔ ∀ ρ : NontrivialZeros,
      ‖((2 : ℝ) : ℂ) ^ (ρ : ℂ)‖ = ‖((2 : ℝ) : ℂ) ^ ((mirrorZ ρ : NontrivialZeros) : ℂ)‖) ∧
    (SpiralLink.SpiralLink ↔ ∀ ρ : NontrivialZeros, Saddle.stretch ρ = 1) ∧
    (SpiralLink.SpiralLink ↔ Saddle.NoRunaway) := by
  have h := OneChain.one_chain
  exact ⟨h.1, h.2.1, h.2.2.2,
    HalfSieve.spiralLink_iff_wobble, BandJoin.spiralLink_iff_middle,
    ShareLink.spiralLink_iff_meet, Saddle.spiralLink_iff_centres,
    Saddle.spiralLink_iff_noRunaway⟩

/-- **The table's side.** What is proved of the table at every `N`, with no
zero in the statement. -/
theorem table_side :
    (∀ N : ℕ, 2 ≤ N →
      (Nat.primeCounting N : ℤ) = (Nat.primeCounting (Nat.sqrt N) : ℤ) - 1 +
        ∑ T ∈ (SieveExact.smallPrimes N).powerset,
          (-1 : ℤ) ^ T.card * ((N / ∏ p ∈ T, p : ℕ) : ℤ)) ∧
    (∀ N : ℕ, ((Finset.Icc 2 N).filter (fun n => ¬ n.Prime)).card
        + (SieveExact.smallPrimes N).card
      = ∑ p ∈ SieveExact.smallPrimes N, CompositeSplit.rough N p) ∧
    (∀ N : ℕ, N = Compression.smooth N + ∑ p ∈ Compression.newPrimes N, N / p) ∧
    (∀ N : ℕ, ∑ k ∈ Finset.Icc 1 N, Chebyshev.psi ((N : ℝ) / (k : ℝ))
      = ∑ n ∈ Finset.Icc 1 N, Real.log (n : ℝ)) ∧
    (∀ (ρ : ℂ) (k : ℤ),
      (2 : ℂ) ^ (ρ + 2 * Real.pi * Complex.I * (k : ℂ) / (Real.log 2 : ℂ)) = (2 : ℂ) ^ ρ) :=
  ⟨SieveExact.pi_by_sieve, CompositeSplit.composites_no_signs, Compression.compression,
    SelfBound.self_bound, RunTheorems.mode_fold⟩

/-- **The steps' side.** What a zero does: it carries weight that is not zero,
it makes the staircase leave every bound below its rate, and it makes the
turned steps to a cutoff do the same. -/
theorem steps_side :
    (∀ ρ : NontrivialZeros,
      -(analyticOrderNatAt riemannZeta (ρ : ℂ) : ℂ) / (ρ : ℂ) ≠ 0) ∧
    (∀ (ρ₀ : NontrivialZeros) (θ : ℝ), θ < (ρ₀ : ℂ).re → ∀ (C : ℝ) (k : ℕ) (x₀ : ℝ),
      ∃ x : ℝ, x₀ ≤ x ∧ C * x ^ θ * Real.log x ^ k < |Chebyshev.psi x - x|) ∧
    (∀ (ρ₀ : NontrivialZeros) (s : ℂ), 0 < s.re → (ρ₀ : ℂ) ≠ s → ∀ δ : ℝ, 0 ≤ δ →
      δ < (ρ₀ : ℂ).re - s.re → ∀ (C : ℝ) (N₀ : ℕ),
      ∃ N : ℕ, N₀ ≤ N ∧ 2 ≤ N ∧ C * (N : ℝ) ^ δ < ‖StepsPeak.S N s - StepsPeak.K N s 1‖) :=
  ⟨StepsPole.steps_pole_ne_zero,
    fun ρ₀ _ h C k x₀ => RateBelow.rain_psi ρ₀ h C k x₀,
    fun ρ₀ _ hs hne _ h0 h C N₀ => StepsBelow.rain_steps ρ₀ hs hne h0 h C N₀⟩

/-- info: 'WholeChain.whole_chain' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms whole_chain

/-- info: 'WholeChain.table_side' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms table_side

/-- info: 'WholeChain.steps_side' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms steps_side

end WholeChain
