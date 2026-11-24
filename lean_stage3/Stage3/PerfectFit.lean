/-
PerfectFit — block R14 of `lean_stage3/design/runs.md`. 2026-11-24.

Julian, 2026-11-24: the harmonic of the integers absorbs the primes' signs as a
perfect fit. For the counts it is exact: at every `N`, the counts `⌊N/k⌋` of
the integers with nothing missing, signed by `μ(k)`, add up to exactly one.

  perfect_fit   1 ≤ N ⊢ Σ_{k≤N} μ(k)·⌊N/k⌋ = 1

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.NoHoles

namespace PerfectFit

open Finset ArithmeticFunction

/-- **The perfect fit.** The counts of the integers at every scale, signed by
the Möbius function, add up to exactly one. -/
theorem perfect_fit {N : ℕ} (hN : 1 ≤ N) :
    ∑ k ∈ Icc 1 N, ((moebius k : ℤ) : ℝ) * ((N / k : ℕ) : ℝ) = 1 := by
  have h := NoHoles.moebius_floor_inversion (fun M => if M = 0 then (0 : ℝ) else 1) hN
  have hN0 : N ≠ 0 := by omega
  simp only [hN0, if_false] at h
  rw [← h]
  refine Finset.sum_congr rfl (fun k hk => ?_)
  congr 1
  rw [Finset.sum_congr rfl (g := fun _ => (1 : ℝ))]
  · simp
  · intro j hj
    rw [mem_Icc] at hj
    have : 1 ≤ N / k / j := (Nat.one_le_div_iff (by omega)).mpr hj.2
    simp [show N / k / j ≠ 0 by omega]

/-- info: 'PerfectFit.perfect_fit' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms perfect_fit

end PerfectFit
