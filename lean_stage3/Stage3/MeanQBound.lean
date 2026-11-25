/-
MeanQBound — block S13 of `lean_stage3/design/stencil.md`, B4 step 3, the mean value with a
general Q: the sizes the V-version and unsmoothing use. 2026-11-25.

On the polydisc of radius `R/(2L)` about `(−R/L, −R/L)` (`MeanQMean.polydisc`, inside
`Regime κ T`, `κ = 2R + 1 + 1/R`):
* `c(α,β)` is bounded for every `θ > 0` (`cY_sup_bound`): `Unsmooth.dop_cY_bdd`'s estimate with
  `log M ≤ θ L` (`DiagMain.logM_le`) in place of `log M ≤ L`, so no `θ < 1/2`;
* `DopQ[c]` at the centre is bounded (`dopQ_cY_bdd`), by Cauchy;
* the moment is `O(errO)` (`Imom_sup`), from Lemma 3 and `FloorLong.Ires_o_long`;
* the mean square of `ζ^{(j)}ψ/L^j` is `O(errO)` with constant `(j!(2/R)^j)²`
  (`meanJ_bound`): it is `mollMeanQ` for `Q = X^j` (`VQ_X_pow`), hence `DopQ (X^j) Imom`.

**Sizes.** The last is the input the V-version needs: `ζ^{(j)}/L^j` has mean square `O(T)`,
the factor `L^{2j}` of `j` derivatives cancelled by `(1/L)^{2j}` exactly as in `DopQ_norm_le`.

  | name           | statement                                                           | status |
  |----------------|---------------------------------------------------------------------|--------|
  | `cY_sup_bound` | `‖c‖ ≤ K` on the polydisc, every `θ > 0`                             | PROVED |
  | `dopQ_cY_bdd`  | `‖DopQ[c](−R/L, −R/L)‖ ≤ K`                                          | PROVED |
  | `Imom_sup`     | Lemma 3 ⊢ `‖Imom‖ ≤ K·errO` on the polydisc                          | PROVED |
  | `VQ_X_pow`     | `VQ (X^j) = (−1/L)^j ζ^{(j)}`                                        | PROVED |
  | `meanJ_bound`  | Lemma 3 ⊢ `‖mollMeanQ (X^j)‖ ≤ K (j!/r^j)² errO`, `r = R/2`           | PROVED |

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.MeanQMean
import Stage3.UnsmoothCY

noncomputable section

namespace MeanQ

open Complex Polynomial MeasureTheory Metric Filter Topology ApproxFE TwistedMoment Operator
  DiagMainStmt DiagonalO OffDiagClose

/-- **`c(α,β)` is bounded on the polydisc**, uniformly in `T`, for every `θ > 0`. -/
theorem cY_sup_bound (P : ℝ[X]) {θ R : ℝ} (hθ0 : 0 < θ) (hR : 0 < R) :
    ∃ K : ℝ, 0 ≤ K ∧ ∃ T₀ : ℝ, ∀ T : ℝ, T₀ ≤ T →
      ∀ x ∈ closedBall (((-(R / Real.log T) : ℝ) : ℂ)) (R / 2 / Real.log T),
      ∀ y ∈ closedBall (((-(R / Real.log T) : ℝ) : ℂ)) (R / 2 / Real.log T),
        ‖cY P (Mof T θ) T x y‖ ≤ K := by
  set κ : ℝ := 2 * R + 1 + 1 / R with hκdef
  have hκ : 0 < κ := by positivity
  set K1 : ℝ := ‖Aq P‖ * (2 / (R * θ)) + ‖Bq P‖ + κ ^ 2 * θ / R * ‖Cq P‖ with hK1def
  have hK1 : 0 ≤ K1 := by positivity
  refine ⟨K1 + Real.exp (2 * κ) * K1, by positivity,
    max (max 4 (Real.exp (4 * Real.log 2 / θ))) (Real.exp (3 * R + 1)), fun T hT => ?_⟩
  simp only [max_le_iff] at hT
  obtain ⟨⟨hT4, hTe⟩, hTe2⟩ := hT
  have hT0 : 0 < T := by linarith
  have hT1 : 1 < T := by linarith
  have hL0 : 0 < Real.log T := Real.log_pos hT1
  have hLθ : 4 * Real.log 2 / θ ≤ Real.log T := (Real.le_log_iff_exp_le hT0).mpr hTe
  have hL3 : 3 * R + 1 ≤ Real.log T := (Real.le_log_iff_exp_le hT0).mpr hTe2
  have hℓlo := DiagMain.logM_ge hT1 hθ0 hLθ
  have hℓhi := DiagMain.logM_le hT1.le hθ0.le
  have hℓ0 : 0 < Real.log (Mof T θ) := lt_of_lt_of_le (by positivity) hℓlo
  obtain ⟨-, hsum, hreg⟩ := polydisc hR hL3
  set L := Real.log T with hLdef
  -- the bound on `c₁` on the range
  have hc1 : ∀ x y : ℂ, x + y ≠ 0 → ‖x‖ ≤ κ / L → ‖y‖ ≤ κ / L →
      R / L ≤ ‖x + y‖ → ‖c1Y P (Mof T θ) x y‖ ≤ K1 := by
    intro x y hxy hx hy hs
    rw [c1Y_eq]
    refine (Unsmooth.c1form_norm_le P (Mof T θ) hxy hℓ0).trans ?_
    have hspos : 0 < ‖x + y‖ := norm_pos_iff.mpr hxy
    have t1 : ‖Aq P‖ / (‖x + y‖ * Real.log (Mof T θ)) ≤ ‖Aq P‖ * (2 / (R * θ)) := by
      have hlow : R * θ / 2 ≤ ‖x + y‖ * Real.log (Mof T θ) := by
        have e : R * θ / 2 = R / L * (θ * L / 2) := by field_simp
        rw [e]
        exact mul_le_mul hs hℓlo (by positivity) hspos.le
      rw [div_eq_mul_one_div]
      refine mul_le_mul_of_nonneg_left ?_ (norm_nonneg _)
      rw [show 2 / (R * θ) = 1 / (R * θ / 2) by field_simp]
      exact one_div_le_one_div_of_le (by positivity) hlow
    have t3 : ‖x‖ * ‖y‖ * Real.log (Mof T θ) * ‖Cq P‖ / ‖x + y‖ ≤ κ ^ 2 * θ / R * ‖Cq P‖ := by
      have hxy2 : ‖x‖ * ‖y‖ ≤ (κ / L) * (κ / L) :=
        mul_le_mul hx hy (norm_nonneg _) (by positivity)
      have hnum : ‖x‖ * ‖y‖ * Real.log (Mof T θ) * ‖Cq P‖ ≤
          (κ / L) * (κ / L) * (θ * L) * ‖Cq P‖ := by
        refine mul_le_mul_of_nonneg_right ?_ (norm_nonneg _)
        exact mul_le_mul hxy2 hℓhi hℓ0.le (by positivity)
      calc ‖x‖ * ‖y‖ * Real.log (Mof T θ) * ‖Cq P‖ / ‖x + y‖ ≤
          (κ / L) * (κ / L) * (θ * L) * ‖Cq P‖ / (R / L) :=
            div_le_div₀ (by positivity) hnum (by positivity) hs
        _ = κ ^ 2 * θ / R * ‖Cq P‖ := by field_simp
    rw [hK1def]
    linarith
  intro x hx y hy
  obtain ⟨hxr, hyr, -⟩ := hreg x hx y hy
  have hs := hsum x hx y hy
  have hxy : x + y ≠ 0 := by
    intro h0
    rw [h0, norm_zero] at hs
    have : 0 < R / L := by positivity
    linarith
  have hyx : -y + -x ≠ 0 := by
    intro e
    apply hxy
    linear_combination -e
  have hsyx : ‖-y + -x‖ = ‖x + y‖ := by
    rw [show -y + -x = -(x + y) by ring, norm_neg]
  have h1 := hc1 x y hxy hxr hyr hs
  have h2 := hc1 (-y) (-x) hyx (by rw [norm_neg]; exact hyr) (by rw [norm_neg]; exact hxr)
    (by rw [hsyx]; exact hs)
  have hsumhi : ‖x + y‖ ≤ 3 * (2 * κ / 3) / L := by
    have e : 3 * (2 * κ / 3) / L = κ / L + κ / L := by field_simp; ring
    rw [e]
    exact (norm_add_le x y).trans (add_le_add hxr hyr)
  have h3 := Unsmooth.Tpow_norm_le (R := 2 * κ / 3) hT1 hsumhi
  have e3 : 3 * (2 * κ / 3) = 2 * κ := by ring
  rw [e3] at h3
  unfold cY
  calc ‖c1Y P (Mof T θ) x y + (T : ℂ) ^ (-(x + y)) * c1Y P (Mof T θ) (-y) (-x)‖ ≤
      ‖c1Y P (Mof T θ) x y‖ + ‖(T : ℂ) ^ (-(x + y))‖ * ‖c1Y P (Mof T θ) (-y) (-x)‖ := by
        rw [← norm_mul]; exact norm_add_le _ _
    _ ≤ K1 + Real.exp (2 * κ) * K1 :=
        add_le_add h1 (mul_le_mul h3 h2 (norm_nonneg _) (Real.exp_pos _).le)

/-- The slices of `cY` on the polydisc, in the form `DopQ_norm_le` asks. -/
theorem cY_cauchy_hyps (P : ℝ[X]) (M : ℕ) {R T : ℝ} (hR : 0 < R) (hT1 : 1 < T)
    (hL3 : 3 * R + 1 ≤ Real.log T) :
    (∀ y ∈ closedBall (((-(R / Real.log T) : ℝ) : ℂ)) (R / 2 / Real.log T),
      ∀ x ∈ closedBall (((-(R / Real.log T) : ℝ) : ℂ)) (R / 2 / Real.log T),
        DifferentiableAt ℂ (fun x => cY P M T x y) x) ∧
    (∀ k, ∀ y ∈ closedBall (((-(R / Real.log T) : ℝ) : ℂ)) (R / 2 / Real.log T),
      DifferentiableAt ℂ (fun y => iteratedDeriv k (fun x => cY P M T x y)
        (((-(R / Real.log T) : ℝ) : ℂ))) y) := by
  have hL0 : 0 < Real.log T := Real.log_pos hT1
  have hTne : T ≠ 0 := by linarith
  obtain ⟨-, hsum, -⟩ := polydisc hR hL3
  have hne : ∀ x ∈ closedBall (((-(R / Real.log T) : ℝ) : ℂ)) (R / 2 / Real.log T),
      ∀ y ∈ closedBall (((-(R / Real.log T) : ℝ) : ℂ)) (R / 2 / Real.log T), x + y ≠ 0 := by
    intro x hx y hy h0
    have := hsum x hx y hy
    rw [h0, norm_zero] at this
    have : 0 < R / Real.log T := by positivity
    linarith
  have hcen : (((-(R / Real.log T) : ℝ) : ℂ)) ∈
      closedBall (((-(R / Real.log T) : ℝ) : ℂ)) (R / 2 / Real.log T) :=
    mem_closedBall_self (by positivity)
  exact ⟨fun y hy x hx => (cY_slices P M hTne (hne x hx y hy)).1.self_of_nhds.differentiableAt,
    fun k y hy => ((cY_slices P M hTne (hne _ hcen y hy)).2 k).differentiableAt⟩

/-- **`DopQ[c]` at the centre is bounded**, uniformly in `T`, every `θ > 0`. -/
theorem dopQ_cY_bdd (Q P : ℝ[X]) {θ R : ℝ} (hθ0 : 0 < θ) (hR : 0 < R) :
    ∃ K : ℝ, 0 ≤ K ∧ ∃ T₀ : ℝ, ∀ T : ℝ, T₀ ≤ T →
      ‖DopQ Q (Real.log T) (cY P (Mof T θ) T) ((-(R / Real.log T) : ℝ) : ℂ)
          ((-(R / Real.log T) : ℝ) : ℂ)‖ ≤ K := by
  obtain ⟨Kc, hKc0, T1, hT1⟩ := cY_sup_bound P hθ0 hR
  refine ⟨Kc * Kq Q (R / 2) ^ 2, by positivity, max T1 (max 4 (Real.exp (3 * R + 1))),
    fun T hT => ?_⟩
  simp only [max_le_iff] at hT
  obtain ⟨hTa, hT4, hTe⟩ := hT
  have hT0 : 0 < T := by linarith
  have hL3 : 3 * R + 1 ≤ Real.log T := (Real.le_log_iff_exp_le hT0).mpr hTe
  have hL0 : 0 < Real.log T := by linarith
  obtain ⟨hFa, hFb⟩ := cY_cauchy_hyps P (Mof T θ) hR (by linarith) hL3
  exact DopQ_norm_le Q hL0 (by positivity : (0 : ℝ) < R / 2) hFa hFb (hT1 T hTa)

/-- **The moment is `O(errO)` on the polydisc**, from Lemma 3 at `κ = 2R + 1 + 1/R`. -/
theorem Imom_sup (P : ℝ[X]) {θ R : ℝ} (hθ0 : 0 < θ) (hR : 0 < R)
    (hL3 : StmtLemma3resO P θ R (2 * R + 1 + 1 / R)) (Cs : ℕ → ℝ) :
    ∃ K : ℝ, 0 ≤ K ∧ ∃ T₀ : ℝ, ∀ T : ℝ, T₀ ≤ T →
      ∀ W : WeightAll T (Real.log T), (∀ j, W.Cj j ≤ Cs j) →
      ∀ x ∈ closedBall (((-(R / Real.log T) : ℝ) : ℂ)) (R / 2 / Real.log T),
      ∀ y ∈ closedBall (((-(R / Real.log T) : ℝ) : ℂ)) (R / 2 / Real.log T),
        ‖Imom W.toWeight (Mof T θ) (aY P T θ R) (sig0 T R) x y‖ ≤ K * errO W.toWeight := by
  obtain ⟨Kc, hKc0, T1, hT1⟩ := cY_sup_bound P hθ0 hR
  have hκ : 0 < 2 * R + 1 + 1 / R := by positivity
  obtain ⟨T2, hT2⟩ := hL3 Cs 1 one_pos
  obtain ⟨T3, hT3⟩ := FloorLong.Ires_o_long (θ := θ) P R hκ 1 one_pos
  refine ⟨2 * Kc + 2, by positivity, max (max T1 T2) (max T3 (max 4 (Real.exp (3 * R + 1)))),
    fun T hT W hW x hx y hy => ?_⟩
  simp only [max_le_iff] at hT
  obtain ⟨⟨hTa, hTb⟩, hTc, hT4, hTe⟩ := hT
  have hT0 : 0 < T := by linarith
  have hL3' : 3 * R + 1 ≤ Real.log T := (Real.le_log_iff_exp_le hT0).mpr hTe
  obtain ⟨-, -, hreg⟩ := polydisc hR hL3'
  have h1 := hT2 T hTb W hW x y (hreg x hx y hy)
  have h2 := hT3 T hTc W.toWeight x y (hreg x hx y hy)
  have hc := hT1 T hTa x hx y hy
  have hw := what0_le W.toWeight hT0
  have herr := T_le_errO W.toWeight hT0.le
  set I0 := Imom W.toWeight (Mof T θ) (aY P T θ R) (sig0 T R) x y
  set c := cY P (Mof T θ) T x y
  have hsplit : I0 = (I0 - c * (what0 W.toWeight : ℂ)) + c * (what0 W.toWeight : ℂ) := by ring
  rw [hsplit]
  have hcw : ‖c * (what0 W.toWeight : ℂ)‖ ≤ Kc * (2 * T) := by
    rw [norm_mul]
    exact mul_le_mul hc hw (norm_nonneg _) hKc0
  calc ‖(I0 - c * (what0 W.toWeight : ℂ)) + c * (what0 W.toWeight : ℂ)‖
      ≤ ‖I0 - c * (what0 W.toWeight : ℂ)‖ + ‖c * (what0 W.toWeight : ℂ)‖ := norm_add_le _ _
    _ ≤ (1 * errO W.toWeight + 1 * T) + Kc * (2 * T) := add_le_add (by linarith) hcw
    _ ≤ (2 * Kc + 2) * errO W.toWeight := by nlinarith

/-- **`Q = X^j`**: `VQ (X^j) L = (−1/L)^j ζ^{(j)}`. -/
theorem VQ_X_pow (j : ℕ) (L : ℝ) (s : ℂ) :
    VQ (X ^ j) L s = (((-1 / L) ^ j : ℝ) : ℂ) * iteratedDeriv j riemannZeta s := by
  unfold VQ
  rw [natDegree_X_pow]
  simp only [coeff_X_pow]
  rw [Finset.sum_eq_single j]
  · simp
  · intro k _ hk
    simp [hk]
  · intro h
    exact absurd (Finset.self_mem_range_succ j) h

theorem Kq_X_pow (j : ℕ) (r : ℝ) : Kq (X ^ j) r = j.factorial / r ^ j := by
  unfold Kq
  rw [natDegree_X_pow]
  simp only [coeff_X_pow]
  rw [Finset.sum_eq_single j]
  · simp
  · intro k _ hk
    simp [hk]
  · intro h
    exact absurd (Finset.self_mem_range_succ j) h

/-- **The mean square of `ζ^{(j)}ψ/L^j` is `O(errO)`**, from Lemma 3, with constant
`(j!/r^j)²`, `r = R/2`: `mollMeanQ (X^j) = DopQ (X^j) Imom` and Cauchy. -/
theorem meanJ_bound (P : ℝ[X]) {θ R : ℝ} (hθ0 : 0 < θ) (hR : 0 < R)
    (hL3 : StmtLemma3resO P θ R (2 * R + 1 + 1 / R)) (Cs : ℕ → ℝ) :
    ∃ K : ℝ, 0 ≤ K ∧ ∃ T₀ : ℝ, ∀ T : ℝ, T₀ ≤ T →
      ∀ W : WeightAll T (Real.log T), (∀ j, W.Cj j ≤ Cs j) → ∀ j : ℕ,
        ‖mollMeanQ W.toWeight (Mof T θ) (aY P T θ R) (sig0 T R) (X ^ j) (Real.log T)‖ ≤
          K * (j.factorial / (R / 2) ^ j) ^ 2 * errO W.toWeight := by
  obtain ⟨K, hK0, T1, hT1⟩ := Imom_sup P hθ0 hR hL3 Cs
  refine ⟨K, hK0, max T1 (max 4 (Real.exp (3 * R + 1))), fun T hT W hW j => ?_⟩
  simp only [max_le_iff] at hT
  obtain ⟨hTa, hT4, hTe⟩ := hT
  have hT0 : 0 < T := by linarith
  have hL3' : 3 * R + 1 ≤ Real.log T := (Real.le_log_iff_exp_le hT0).mpr hTe
  have hL0 : 0 < Real.log T := by linarith
  obtain ⟨hlt, -, -⟩ := polydisc hR hL3'
  set α₀ : ℂ := ((-(R / Real.log T) : ℝ) : ℂ) with hα₀def
  have hα₀σ : α₀ = ((sig0 T R - 1 / 2 : ℝ) : ℂ) := by
    rw [hα₀def]
    unfold sig0
    congr 1
    ring
  have hcen : α₀ ∈ closedBall α₀ (R / 2 / Real.log T) := mem_closedBall_self (by positivity)
  have hAs := fun x y (hx : ‖x‖ < 1 / 2) (hy : ‖y‖ < 1 / 2) =>
    Imom_slices W.toWeight (Mof T θ) (aY P T θ R) (sig0 T R) hT4 hx hy
  have hFa : ∀ y ∈ closedBall α₀ (R / 2 / Real.log T), ∀ x ∈ closedBall α₀ (R / 2 / Real.log T),
      DifferentiableAt ℂ (fun x => Imom W.toWeight (Mof T θ) (aY P T θ R) (sig0 T R) x y) x :=
    fun y hy x hx => (hAs x y (hlt x hx) (hlt y hy)).1.differentiableAt
  have hFb : ∀ k, ∀ y ∈ closedBall α₀ (R / 2 / Real.log T),
      DifferentiableAt ℂ (fun y => iteratedDeriv k
        (fun x => Imom W.toWeight (Mof T θ) (aY P T θ R) (sig0 T R) x y) α₀) y :=
    fun k y hy => ((hAs α₀ y (hlt α₀ hcen) (hlt y hy)).2 k).differentiableAt
  have hb := DopQ_norm_le (X ^ j) hL0 (by positivity : (0 : ℝ) < R / 2) hFa hFb
    (fun x hx y hy => hT1 T hTa W hW x hx y hy)
  have hmean : DopQ (X ^ j) (Real.log T) (Imom W.toWeight (Mof T θ) (aY P T θ R) (sig0 T R))
      α₀ α₀ = mollMeanQ W.toWeight (Mof T θ) (aY P T θ R) (sig0 T R) (X ^ j) (Real.log T) := by
    rw [hα₀σ]
    exact DopQ_Imom W.toWeight (Mof T θ) (aY P T θ R) (sig0 T R) (X ^ j) (Real.log T) hT4
      (by rw [← hα₀σ]; exact hlt α₀ hcen)
  rw [← hmean]
  rw [Kq_X_pow] at hb
  calc _ ≤ K * errO W.toWeight * ((j.factorial : ℝ) / (R / 2) ^ j) ^ 2 := hb
    _ = K * ((j.factorial : ℝ) / (R / 2) ^ j) ^ 2 * errO W.toWeight := by ring

/-- info: 'MeanQ.cY_sup_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms cY_sup_bound

/-- info: 'MeanQ.dopQ_cY_bdd' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms dopQ_cY_bdd

/-- info: 'MeanQ.Imom_sup' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Imom_sup

/-- info: 'MeanQ.meanJ_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms meanJ_bound

end MeanQ

end
