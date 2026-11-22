/-
LandauCriterion — the Landau window criterion, proved.
Block 7d of `lean_stage3/design/landau.md`. 2026-11-22.

  contradiction      the two bounds on the primes' integral cannot both hold
  stmtLandauWindow   LandauWindow.StmtLandauWindow: if for arbitrarily large Y
                       one has G(y) ≤ C·y^θ on all of [Y, Y^(1+δ)], then ζ has
                       no zero with real part above θ
  rh_of_windows      a window bound at every θ in (1/2, 1) → RiemannHypothesis

`contradiction` takes: a real `σ₀ > 1`; numbers `r, R, τ, C₁, N₀` with
`σ₀ − 1 < r ≤ (σ₀ − 1)(1 + δ²/240)`, `r < σ₀ − θ`, `r < R`, `τ > 0`; the lower bound
`τ/r^(k+1) − C₁/R^k ≤ Ik σ₀ k / k!` for some `k` in every `N₀` consecutive (the
zeros' side, `LandauZeroSide.zero_side`); and windows at arbitrarily large `Y`
on which `G ≤ C·y^θ`. The upper bound `LandauPrimeSide.Ik_le`, with the shifts
`b = (σ₀−1)δ/3` and `b' = (σ₀−1)δ/12`, has four terms after multiplying by
`r^(k+1)`: two decay in `k`, two are `8·exp(−μ·log Y)` on a range of `k` that
`LandauRates.key_ineq` shows nonempty and long. For `Y` large their sum is
below `τ`.

THE HYPOTHESIS OF `rh_of_windows` IS NOT PROVED HERE OR ANYWHERE IN THIS
REPOSITORY. It is a one-sided bound on a function of the primes on long
windows, for every exponent above one half. This module proves that such a
bound would imply the Riemann hypothesis.

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.LandauZeroSide
import Stage3.LandauRates

namespace LandauCriterion

noncomputable section

open Set

theorem contradiction {σ₀ θ δ C r R τ C₁ : ℝ} {N₀ : ℕ} (hσ : 1 < σ₀) (hδ0 : 0 < δ)
    (hδ1 : δ ≤ 1) (hC : 0 ≤ C) (hra : σ₀ - 1 < r)
    (hr3 : r ≤ (σ₀ - 1) * (1 + δ ^ 2 / 240)) (hrθ : r < σ₀ - θ) (hrR : r < R)
    (hτ : 0 < τ)
    (hzero : ∀ a N : ℕ, N₀ ≤ N → ∃ k ∈ Finset.Ico a (a + N),
      τ / r ^ (k + 1) - C₁ / R ^ k ≤ LandauPrimeSide.Ik σ₀ k / k.factorial)
    (hwin : ∀ U₀ : ℝ, ∃ Y : ℝ, 1 ≤ Y ∧ U₀ ≤ Real.log Y ∧
      ∀ y ∈ Icc Y (Y ^ (1 + δ)), LandauWindow.G y ≤ C * y ^ θ) : False := by
  have ha : 0 < σ₀ - 1 := by linarith
  have hr0 : 0 < r := by linarith
  have hR0 : 0 < R := by linarith
  have hσθ : 0 < σ₀ - θ := by linarith
  -- λ
  obtain ⟨lam, hlam⟩ : ∃ lam : ℝ, lam = Real.log (r / (σ₀ - 1)) := ⟨_, rfl⟩
  have hra1 : 1 ≤ r / (σ₀ - 1) := by rw [le_div_iff₀ ha]; linarith
  have hl0 : 0 ≤ lam := by rw [hlam]; exact Real.log_nonneg hra1
  have hl : lam ≤ δ ^ 2 / 240 := by
    have h1 := Real.log_le_sub_one_of_pos (by positivity : 0 < r / (σ₀ - 1))
    have h2 : r / (σ₀ - 1) ≤ 1 + δ ^ 2 / 240 := by rw [div_le_iff₀ ha]; linarith
    rw [hlam]; linarith
  obtain ⟨hK, hL3pos, hL4pos⟩ := LandauRates.key_ineq hδ0 hδ1 hl0 hl
  obtain ⟨L3, hL3⟩ : ∃ L3 : ℝ, L3 = Real.log (1 + δ / 3) - lam := ⟨_, rfl⟩
  obtain ⟨L4, hL4⟩ : ∃ L4 : ℝ, L4 = lam - Real.log (1 - δ / 12) := ⟨_, rfl⟩
  rw [← hL3, ← hL4] at hK
  rw [← hL3] at hL3pos
  rw [← hL4] at hL4pos
  obtain ⟨b, hb⟩ : ∃ b : ℝ, b = (σ₀ - 1) * (δ / 3) := ⟨_, rfl⟩
  obtain ⟨b', hb'⟩ : ∃ b' : ℝ, b' = (σ₀ - 1) * (δ / 12) := ⟨_, rfl⟩
  have hb0 : 0 < b := by rw [hb]; positivity
  have hb'0 : 0 < b' := by rw [hb']; positivity
  have hb'a : b' < σ₀ - 1 := by rw [hb']; nlinarith
  have hx : 0 < 1 - δ / 12 := by linarith
  have hy : 0 < 1 + δ / 3 := by linarith
  have hE3 : Real.exp (-L3) = r / (σ₀ - 1 + b) := by
    rw [hL3, hlam, neg_sub, Real.exp_sub, Real.exp_log (by positivity), Real.exp_log hy, hb]
    field_simp
  have hE4 : Real.exp L4 = r / (σ₀ - 1 - b') := by
    rw [hL4, hlam, Real.exp_sub, Real.exp_log (by positivity), Real.exp_log hx, hb']
    field_simp
  -- the margin
  obtain ⟨D, hD⟩ : ∃ D : ℝ, D = b' * (1 + δ) * L3 - b * L4 := ⟨_, rfl⟩
  have hD0 : 0 < D := by
    have e : D = (σ₀ - 1) * (δ / 12) * ((1 + δ) * L3 - 4 * L4) := by rw [hD, hb, hb']; ring
    rw [e]
    exact mul_pos (by positivity) (by linarith)
  have hLL : 0 < L3 + L4 := by linarith
  obtain ⟨μ, hμ⟩ : ∃ μ : ℝ, μ = D / (2 * (L3 + L4)) := ⟨_, rfl⟩
  have hμ0 : 0 < μ := by rw [hμ]; positivity
  have hμD : μ * (L3 + L4) = D / 2 := by rw [hμ]; field_simp
  obtain ⟨κ₁, hκ₁⟩ : ∃ κ₁ : ℝ, κ₁ = (b + μ) / L3 := ⟨_, rfl⟩
  obtain ⟨κ₂, hκ₂⟩ : ∃ κ₂ : ℝ, κ₂ = (b' * (1 + δ) - μ) / L4 := ⟨_, rfl⟩
  have hκ₁0 : 0 < κ₁ := by rw [hκ₁]; positivity
  have hκ : κ₁ < κ₂ := by
    rw [hκ₁, hκ₂, div_lt_div_iff₀ hL3pos hL4pos]
    have e : (b' * (1 + δ) - μ) * L3 - (b + μ) * L4 = D - μ * (L3 + L4) := by rw [hD]; ring
    linarith
  -- thresholds
  obtain ⟨K1, hK1⟩ := LandauRates.exists_pow_small (q := r / R) (c := C₁ * r) (ε := τ / 4)
    (by positivity) (by rw [div_lt_one hR0]; exact hrR) (by positivity)
  obtain ⟨K2, hK2⟩ := LandauRates.exists_pow_small (q := r / (σ₀ - θ)) (c := C) (ε := τ / 4)
    (by positivity) (by rw [div_lt_one hσθ]; exact hrθ) (by positivity)
  obtain ⟨Y, hY1, hU, hwinY⟩ := hwin (max (max (((N₀ : ℝ) + 2) / (κ₂ - κ₁))
    (((max K1 K2 : ℕ) + 1 : ℝ) / κ₁)) (Real.log (32 / τ) / μ + 1))
  obtain ⟨U, hUd⟩ : ∃ U : ℝ, U = Real.log Y := ⟨_, rfl⟩
  rw [← hUd] at hU
  have hY0 : 0 < Y := by linarith
  have hκκ : 0 < κ₂ - κ₁ := by linarith
  have hU1 : (N₀ : ℝ) + 2 ≤ (κ₂ - κ₁) * U := by
    have := le_trans (le_trans (le_max_left _ _) (le_max_left _ _)) hU
    rwa [div_le_iff₀ hκκ, mul_comm] at this
  have hU2 : ((max K1 K2 : ℕ) : ℝ) + 1 ≤ κ₁ * U := by
    have := le_trans (le_trans (le_max_right _ _) (le_max_left _ _)) hU
    rwa [div_le_iff₀ hκ₁0, mul_comm] at this
  have hU3 : Real.log (32 / τ) < μ * U := by
    have := le_trans (le_max_right _ _) hU
    have h2 : Real.log (32 / τ) / μ < U := by linarith
    rwa [div_lt_iff₀ hμ0, mul_comm] at h2
  have hκU0 : 0 ≤ κ₁ * U := by
    have : (0 : ℝ) ≤ ((max K1 K2 : ℕ) : ℝ) := Nat.cast_nonneg _
    linarith
  -- the block
  obtain ⟨k, hk, hlow⟩ := hzero ⌈κ₁ * U⌉₊ N₀ le_rfl
  rw [Finset.mem_Ico] at hk
  have hceil1 : κ₁ * U ≤ (⌈κ₁ * U⌉₊ : ℝ) := Nat.le_ceil _
  have hceil2 : (⌈κ₁ * U⌉₊ : ℝ) < κ₁ * U + 1 := Nat.ceil_lt_add_one hκU0
  have hk1 : (⌈κ₁ * U⌉₊ : ℝ) ≤ k := by exact_mod_cast hk.1
  have hk2 : (k : ℝ) + 1 ≤ (⌈κ₁ * U⌉₊ : ℝ) + N₀ := by exact_mod_cast hk.2
  have hmlo : κ₁ * U ≤ ((k + 1 : ℕ) : ℝ) := by push_cast; linarith
  have hmhi : ((k + 1 : ℕ) : ℝ) ≤ κ₂ * U := by
    have e : (κ₂ - κ₁) * U = κ₂ * U - κ₁ * U := by ring
    push_cast
    linarith
  have hkK1 : K1 ≤ k := by
    have : ((max K1 K2 : ℕ) : ℝ) ≤ k := by linarith
    exact le_trans (le_max_left _ _) (by exact_mod_cast this)
  have hkK2 : K2 ≤ k + 1 := by
    have : ((max K1 K2 : ℕ) : ℝ) ≤ k := by linarith
    exact le_trans (le_trans (le_max_right _ _) (by exact_mod_cast this)) (Nat.le_succ k)
  -- the exponents
  have hexp3 : b * U - ((k + 1 : ℕ) : ℝ) * L3 ≤ -(μ * U) := by
    have h : (b + μ) * U ≤ ((k + 1 : ℕ) : ℝ) * L3 := by
      rw [hκ₁, div_mul_eq_mul_div, div_le_iff₀ hL3pos] at hmlo
      exact hmlo
    linarith
  have hexp4 : -(b' * (1 + δ) * U) + ((k + 1 : ℕ) : ℝ) * L4 ≤ -(μ * U) := by
    have h : ((k + 1 : ℕ) : ℝ) * L4 ≤ (b' * (1 + δ) - μ) * U := by
      rw [hκ₂, div_mul_eq_mul_div, le_div_iff₀ hL4pos] at hmhi
      exact hmhi
    linarith
  have hsmall : Real.exp (-(μ * U)) < τ / 32 := by
    have h1 : -(μ * U) < Real.log (τ / 32) := by
      have : Real.log (τ / 32) = -Real.log (32 / τ) := by
        rw [← Real.log_inv]; congr 1; field_simp
      rw [this]; linarith
    calc Real.exp (-(μ * U)) < Real.exp (Real.log (τ / 32)) := Real.exp_lt_exp.mpr h1
      _ = τ / 32 := Real.exp_log (by positivity)
  have hT3 : Y ^ b * (r / (σ₀ - 1 + b)) ^ (k + 1) < τ / 32 := by
    rw [← hE3, ← Real.exp_nat_mul, Real.rpow_def_of_pos hY0, ← hUd, ← Real.exp_add]
    refine lt_of_le_of_lt (Real.exp_le_exp.mpr ?_) hsmall
    linarith
  have hT4 : (Y ^ (1 + δ)) ^ (-b') * (r / (σ₀ - 1 - b')) ^ (k + 1) < τ / 32 := by
    rw [← hE4, ← Real.exp_nat_mul, ← Real.rpow_mul hY0.le, Real.rpow_def_of_pos hY0, ← hUd,
      ← Real.exp_add]
    refine lt_of_le_of_lt (Real.exp_le_exp.mpr ?_) hsmall
    linarith
  have hT1 : C₁ * r * (r / R) ^ k < τ / 4 := hK1 k hkK1
  have hT2 : C * (r / (σ₀ - θ)) ^ (k + 1) < τ / 4 := hK2 (k + 1) hkK2
  -- the upper bound
  have hup := LandauPrimeSide.Ik_le hσ (by linarith : θ < σ₀) hC hY1 hδ0.le hwinY hb0 hb'0 hb'a k
  have hF : (0 : ℝ) < k.factorial := by positivity
  have hrm : 0 < r ^ (k + 1) := by positivity
  have hab : 0 < σ₀ - 1 + b := by linarith
  have hab' : 0 < σ₀ - 1 - b' := by linarith
  have hdiv : LandauPrimeSide.Ik σ₀ k / k.factorial
      ≤ C / (σ₀ - θ) ^ (k + 1) + 8 * (Y ^ b / (σ₀ - 1 + b) ^ (k + 1))
        + 8 * ((Y ^ (1 + δ)) ^ (-b') / (σ₀ - 1 - b') ^ (k + 1)) := by
    rw [div_le_iff₀ hF]
    refine le_trans hup (le_of_eq ?_)
    field_simp
  have h1 : τ / r ^ (k + 1) ≤ C₁ / R ^ k + (C / (σ₀ - θ) ^ (k + 1)
      + 8 * (Y ^ b / (σ₀ - 1 + b) ^ (k + 1))
      + 8 * ((Y ^ (1 + δ)) ^ (-b') / (σ₀ - 1 - b') ^ (k + 1))) := by linarith
  have h2 := mul_le_mul_of_nonneg_left h1 hrm.le
  have e0 : r ^ (k + 1) * (τ / r ^ (k + 1)) = τ := by field_simp
  have e1 : r ^ (k + 1) * (C₁ / R ^ k) = C₁ * r * (r / R) ^ k := by
    rw [div_pow, pow_succ]; field_simp
  have e2 : r ^ (k + 1) * (C / (σ₀ - θ) ^ (k + 1)) = C * (r / (σ₀ - θ)) ^ (k + 1) := by
    rw [div_pow]; field_simp
  have e3 : r ^ (k + 1) * (8 * (Y ^ b / (σ₀ - 1 + b) ^ (k + 1)))
      = 8 * (Y ^ b * (r / (σ₀ - 1 + b)) ^ (k + 1)) := by
    rw [div_pow]; field_simp
  have e4 : r ^ (k + 1) * (8 * ((Y ^ (1 + δ)) ^ (-b') / (σ₀ - 1 - b') ^ (k + 1)))
      = 8 * ((Y ^ (1 + δ)) ^ (-b') * (r / (σ₀ - 1 - b')) ^ (k + 1)) := by
    rw [div_pow]; field_simp
  rw [e0, mul_add, mul_add, mul_add, e1, e2, e3, e4] at h2
  linarith

theorem stmtLandauWindow : LandauWindow.StmtLandauWindow := by
  intro θ δ C hθ0 _ hδ hW s hs hzero
  have hs1 : s.re < 1 := by
    by_contra h
    exact riemannZeta_ne_zero_of_one_le_re (not_lt.mp h) hzero
  have hδ' : 0 < min δ 1 := lt_min hδ one_pos
  obtain ⟨σ₀, hσ, hS1, hS3⟩ := LandauRates.exists_centre (ρ₀ := s) hθ0.le hs hs1 hδ'
  have hS2 : ‖(σ₀ : ℂ) - s‖ < σ₀ := by linarith
  obtain ⟨r, R, τ, C₁, N₀, hra, hr_le, hrR, hτ, hC₁, hblock⟩ :=
    LandauZeroSide.zero_side hzero hσ hS2
  refine contradiction (δ := min δ 1) (C := max C 0) (θ := θ) hσ hδ' (min_le_right _ _)
    (le_max_right _ _) hra (hr_le.trans hS3) (lt_of_le_of_lt hr_le hS1) hrR hτ hblock ?_
  intro U₀
  obtain ⟨Y, hYge, hYwin⟩ := hW (max (Real.exp U₀) 1)
  have hY1 : 1 ≤ Y := le_trans (le_max_right _ _) hYge
  have hY0 : 0 < Y := by linarith
  refine ⟨Y, hY1, ?_, fun y hy => ?_⟩
  · rw [Real.le_log_iff_exp_le hY0]
    exact le_trans (le_max_left _ _) hYge
  · have hy0 : 0 < y := lt_of_lt_of_le hY0 hy.1
    have hsub : Y ^ (1 + min δ 1) ≤ Y ^ (1 + δ) :=
      Real.rpow_le_rpow_of_exponent_le hY1 (by linarith [min_le_left δ 1])
    have h := hYwin y ⟨hy.1, le_trans hy.2 hsub⟩
    exact le_trans h (mul_le_mul_of_nonneg_right (le_max_left _ _) (Real.rpow_nonneg hy0.le _))

theorem rh_of_windows
    (hW : ∀ θ : ℝ, 1 / 2 < θ → θ < 1 → ∃ δ C : ℝ, 0 < δ ∧ LandauWindow.WindowBound θ δ C) :
    RiemannHypothesis :=
  LandauWindow.rh_of_window stmtLandauWindow hW

/-- info: 'LandauCriterion.contradiction' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms contradiction

/-- info: 'LandauCriterion.stmtLandauWindow' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms stmtLandauWindow

/-- info: 'LandauCriterion.rh_of_windows' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms rh_of_windows

end

end LandauCriterion
