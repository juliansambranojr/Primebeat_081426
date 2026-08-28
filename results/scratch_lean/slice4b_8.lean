/-
Slice 4b — the uniform vertical-line bound, slices 3 and 4 welded, both signs
of `t`.  And slice 8 — PsiToPi at `k = 3`.
Scratch only.
-/
import Stage3.JensenCount
import Stage3.Assembly
import PrimeNumberTheoremAnd.ZetaConj

open Complex Set

namespace Slice4b

noncomputable section

local notation "ζ" => riemannZeta

/-! Slice 3 and slice 4, restated locally (proved in `slice3.lean` / `slice4.lean`). -/

variable (compact_bound : ∀ (hRH : RiemannHypothesis) {t σ₁ : ℝ}, |t| ≤ 2 →
    1/2 < σ₁ → σ₁ ≤ 3/4 →
    ‖deriv ζ ((σ₁ : ℂ) + I * (t : ℂ)) / ζ ((σ₁ : ℂ) + I * (t : ℂ))‖
      ≤ 25200 + 115 / (σ₁ - 1/2))

variable (tail_bound : ∀ (hRH : RiemannHypothesis) {t X : ℝ}, 2 ≤ t →
    1 ≤ Real.log X → Real.log t ≤ Real.log X →
    ‖deriv ζ (((1/2 + 1/Real.log X : ℝ)) + I * (t : ℂ))
        / ζ (((1/2 + 1/Real.log X : ℝ)) + I * (t : ℂ))‖
      ≤ 20000 * (Real.log X) ^ 2)

/-- Reflection: the log-derivative's norm is even in `t`. -/
theorem logDerivZeta_norm_neg (σ t : ℝ) :
    ‖deriv ζ ((σ : ℂ) + I * ((-t : ℝ) : ℂ)) / ζ ((σ : ℂ) + I * ((-t : ℝ) : ℂ))‖
      = ‖deriv ζ ((σ : ℂ) + I * (t : ℂ)) / ζ ((σ : ℂ) + I * (t : ℂ))‖ := by
  have hconj : (starRingEnd ℂ) ((σ : ℂ) + I * (t : ℂ)) = (σ : ℂ) + I * ((-t : ℝ) : ℂ) := by
    simp [Complex.ext_iff]
  have h := PrimeNumberTheoremAnd.logDerivZeta_conj ((σ : ℂ) + I * (t : ℂ))
  simp only [Pi.div_apply, hconj] at h
  rw [h, RCLike.norm_conj]

/-- **Slice 4b — the vertical line, uniform in `t`.**  Under RH, on
`σ₁ = 1/2 + 1/log X` with `log X ≥ 4` and `|t| ≤ X`:
`‖ζ'/ζ‖ ≤ 20000 (log X)²`. -/
theorem logDerivZeta_line (hRH : RiemannHypothesis) {X t : ℝ}
    (hLX : 4 ≤ Real.log X) (htX : |t| ≤ X) :
    ‖deriv ζ (((1/2 + 1/Real.log X : ℝ)) + I * (t : ℂ))
        / ζ (((1/2 + 1/Real.log X : ℝ)) + I * (t : ℂ))‖
      ≤ 20000 * (Real.log X) ^ 2 := by
  set L : ℝ := Real.log X with hL
  have hLpos : (0:ℝ) < L := by linarith
  have hσlo : (1:ℝ)/2 < 1/2 + 1/L := by have : (0:ℝ) < 1/L := by positivity
                                        linarith
  have hσhi : (1:ℝ)/2 + 1/L ≤ 3/4 := by
    have : 1/L ≤ 1/4 := by rw [div_le_div_iff₀ hLpos (by norm_num)]; linarith
    linarith
  have hX1 : (1:ℝ) < X := by
    by_contra h
    push_neg at h
    have : Real.log X ≤ 0 := Real.log_nonpos (by linarith [abs_nonneg t, htX]) h
    linarith
  -- the three regimes
  rcases le_or_gt |t| 2 with hsmall | hbig
  · have h4 := compact_bound hRH hsmall hσlo hσhi
    refine le_trans h4 ?_
    have hd : (1/2 + 1/L) - 1/2 = 1/L := by ring
    rw [hd]
    have hdd : (115:ℝ) / (1 / L) = 115 * L := by field_simp
    rw [hdd]
    nlinarith [hLpos, sq_nonneg L]
  · have htabs : (2:ℝ) ≤ |t| := le_of_lt hbig
    have hlogabs : Real.log |t| ≤ L := Real.log_le_log (by linarith) (by
      calc |t| ≤ X := htX
        _ = X := rfl)
    have hmain := tail_bound hRH (t := |t|) (X := X) htabs (by linarith) hlogabs
    rcases abs_cases t with ⟨heq, _⟩ | ⟨heq, _⟩
    · rw [heq] at hmain; exact hmain
    · rw [heq] at hmain
      rw [← logDerivZeta_norm_neg (1/2 + 1/L) t] at *
      have : ((-t : ℝ) : ℂ) = ((-t : ℝ) : ℂ) := rfl
      exact hmain

end

end Slice4b

namespace Slice8

/-- **Slice 8 — PsiToPi at `k = 3`.**  A ψ-side weak bound at exponent `3`
delivers `StmtSchoenfeldWeak (3C+13) 2` — the shape entry 231's census
gate is stated against. -/
theorem schoenfeldWeak_of_psiWeak_three {C x₀ : ℝ} (hx₀ : 2 ≤ x₀) (hC : 0 ≤ C)
    (h : Stage3.StmtPsiWeak C 3 x₀) :
    Stage3.StmtSchoenfeldWeak (3 * C + 13) 2 (max (x₀ ^ 2) 9)
      (fun x => (Nat.primeCounting ⌊x⌋₊ : ℝ)) Stage3.Li := by
  have := Stage3.schoenfeldWeak_of_psiWeak (k := 3) (by norm_num) hx₀ hC h
  simpa using this

end Slice8

#check @Slice4b.logDerivZeta_line
#check @Slice8.schoenfeldWeak_of_psiWeak_three
#print axioms Slice4b.logDerivZeta_norm_neg
#print axioms Slice4b.logDerivZeta_line
#print axioms Slice8.schoenfeldWeak_of_psiWeak_three
