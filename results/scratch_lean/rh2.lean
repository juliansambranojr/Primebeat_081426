import PrimeNumberTheoremAnd.MediumPNT

open Set Complex

/-- Under RH, ζ has no zero with `1/2 < re s ≤ 2`. -/
theorem zeta_ne_zero_of_RH (hRH : RiemannHypothesis) {s : ℂ}
    (hs : 1/2 < s.re) (hs1 : s ≠ 1) : riemannZeta s ≠ 0 := by
  intro hz
  rcases le_or_gt 1 s.re with h | h
  · exact riemannZeta_ne_zero_of_one_le_re h hz
  · have htriv : ¬ ∃ n : ℕ, s = -2 * (n + 1) := by
      rintro ⟨n, rfl⟩
      simp at hs
      nlinarith [Nat.cast_nonneg (α := ℝ) n]
    have := hRH s hz htriv hs1
    rw [this] at hs
    linarith

/-- **The RH discharge of PNT+'s contour hypothesis at the critical line.** -/
theorem holo_logDerivZeta_of_RH (hRH : RiemannHypothesis) {σ₁ T : ℝ}
    (hσ : 1/2 < σ₁) :
    HolomorphicOn (deriv riemannZeta / riemannZeta)
      (Set.Icc σ₁ 2 ×ℂ Set.Icc (-T) T \ {1}) := by
  intro s hs
  have hs1 : s ≠ 1 := by simpa using hs.2
  have hre : σ₁ ≤ s.re := (Complex.mem_reProdIm.mp hs.1).1.1
  have hzne : riemannZeta s ≠ 0 :=
    zeta_ne_zero_of_RH hRH (lt_of_lt_of_le hσ hre) hs1
  refine DifferentiableAt.differentiableWithinAt ?_
  exact (differentiableAt_deriv_riemannZeta hs1).div
    (differentiableAt_riemannZeta hs1) hzne

#print axioms holo_logDerivZeta_of_RH
