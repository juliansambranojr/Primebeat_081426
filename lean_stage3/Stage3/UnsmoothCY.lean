/-
# UnsmoothCY — block S12 of `lean_stage3/design/stencil.md`, piece 4, unsmoothing: `D[c]` is bounded. 2026-11-25.

The unsmoothing step divides `D[c](−R/L, −R/L)·ŵ(0)` by `b′ − a′`, and `ŵ(0) − (b′ − a′)` is
`O(T/L)`; the excess is `o(1)` only if `D[c]` is `o(L)`. It is `O(1)`: on the polydisc of
radius `R/(2L)` about `(−R/L, −R/L)`, `‖α‖, ‖β‖ ≤ 3R/(2L)` and `‖α + β‖ ≥ R/L`, and with
`ℓ = log M ∈ [θL/2, L]` the closed form `c₁ = A/((α+β)ℓ) + B + αβℓC/(α+β)` (`OperatorCY.c1Y_eq`)
gives `‖c₁‖ ≤ 2‖A‖/(Rθ) + ‖B‖ + (9R/4)‖C‖`; `‖T^(−α−β)‖ ≤ e^(3R)`. Cauchy's estimate
(`OperatorCauchy.Dop_norm_le`, radius `r/L`, `r = R/2`) costs `1 + 2/r + 1/r²`, no power of `L`.

| name | content | status |
|---|---|---|
| `c1form_norm_le` | `‖c₁(x,y)‖ ≤ ‖A‖/(‖x+y‖ℓ) + ‖B‖ + ‖x‖‖y‖ℓ‖C‖/‖x+y‖` | proved |
| `Tpow_norm_le` | `‖T^(−(x+y))‖ ≤ e^(3R)` for `‖x+y‖ ≤ 3R/log T` | proved |
| `dop_cY_bdd` | `‖D[c](−R/L, −R/L)‖ ≤ K` from some height on, `K` independent of `T` | proved |

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Stage3.Operator
import Stage3.DiagMain

namespace Unsmooth

open Complex Metric Filter Topology TwistedMoment Operator

/-- `‖c₁(x,y)‖ ≤ ‖A‖/(‖x+y‖ℓ) + ‖B‖ + ‖x‖‖y‖ℓ‖C‖/‖x+y‖`, `ℓ = log M > 0`, `x + y ≠ 0`. -/
theorem c1form_norm_le (P : Polynomial ℝ) (M : ℕ) {x y : ℂ} (hxy : x + y ≠ 0)
    (hℓ : 0 < Real.log M) :
    ‖c1form P M x y‖ ≤ ‖Aq P‖ / (‖x + y‖ * Real.log M) + ‖Bq P‖ +
      ‖x‖ * ‖y‖ * Real.log M * ‖Cq P‖ / ‖x + y‖ := by
  set ℓ : ℂ := ((Real.log M : ℝ) : ℂ) with hℓdef
  have hℓ0 : ℓ ≠ 0 := by rw [hℓdef]; exact_mod_cast hℓ.ne'
  have hnℓ : ‖ℓ‖ = Real.log M := by
    rw [hℓdef, Complex.norm_real, Real.norm_eq_abs, abs_of_pos hℓ]
  have e : c1form P M x y = Aq P / ((x + y) * ℓ) + Bq P + x * y * ℓ * Cq P / (x + y) := by
    unfold c1form
    rw [← hℓdef]
    field_simp
    try ring
  rw [e]
  refine (norm_add_le _ _).trans (add_le_add ((norm_add_le _ _).trans le_rfl) le_rfl) |>.trans ?_
  rw [norm_div, norm_div, norm_mul, norm_mul, norm_mul, norm_mul, hnℓ]

/-- `‖T^(−(x+y))‖ ≤ e^(3R)` for `‖x+y‖ ≤ 3R/log T`, `T > 1`. -/
theorem Tpow_norm_le {T R : ℝ} (hT : 1 < T) {x y : ℂ} (h : ‖x + y‖ ≤ 3 * R / Real.log T) :
    ‖(T : ℂ) ^ (-(x + y))‖ ≤ Real.exp (3 * R) := by
  have hT0 : 0 < T := by linarith
  have hL : 0 < Real.log T := Real.log_pos hT
  rw [Complex.norm_cpow_eq_rpow_re_of_pos hT0]
  have hre : (-(x + y)).re ≤ 3 * R / Real.log T := by
    have h1 := Complex.abs_re_le_norm (-(x + y))
    rw [norm_neg] at h1
    exact (le_abs_self _).trans (h1.trans h)
  calc T ^ (-(x + y)).re ≤ T ^ (3 * R / Real.log T) :=
        Real.rpow_le_rpow_of_exponent_le hT.le hre
    _ = Real.exp (3 * R) := by
        rw [Real.rpow_def_of_pos hT0]
        congr 1
        field_simp

/-- **`D[c]` at `(−R/L, −R/L)` is bounded**, uniformly in `T`, for `0 < θ < 1/2`, `R > 0`. -/
theorem dop_cY_bdd (P : Polynomial ℝ) {θ : ℝ} (hθ0 : 0 < θ) (hθ : θ < 1 / 2) {R : ℝ}
    (hR : 0 < R) : ∃ K : ℝ, 0 ≤ K ∧ ∃ T₀ : ℝ, ∀ T : ℝ, T₀ ≤ T →
      ‖Dop (Real.log T) (cY P (Mof T θ) T) ((-(R / Real.log T) : ℝ) : ℂ)
          ((-(R / Real.log T) : ℝ) : ℂ)‖ ≤ K := by
  set r : ℝ := R / 2 with hrdef
  have hr : 0 < r := by positivity
  set K1 : ℝ := ‖Aq P‖ * (2 / (R * θ)) + ‖Bq P‖ + 9 * R / 4 * ‖Cq P‖ with hK1def
  have hK1 : 0 ≤ K1 := by positivity
  set S : ℝ := K1 + Real.exp (3 * R) * K1 with hSdef
  have hS0 : 0 ≤ S := by positivity
  refine ⟨S * (1 + 2 / r + 1 / r ^ 2), by positivity,
    max 4 (Real.exp (4 * Real.log 2 / θ)), fun T hT => ?_⟩
  simp only [max_le_iff] at hT
  obtain ⟨hT4, hTe⟩ := hT
  have hT0 : 0 < T := by linarith
  have hT1 : 1 < T := by linarith
  have hL0 : 0 < Real.log T := Real.log_pos hT1
  have hLθ : 4 * Real.log 2 / θ ≤ Real.log T := (Real.le_log_iff_exp_le hT0).mpr hTe
  have hℓlo := DiagMain.logM_ge hT1 hθ0 hLθ
  have hℓhi := DiagMain.logM_le hT1.le hθ0.le
  have hℓ0 : 0 < Real.log (Mof T θ) := lt_of_lt_of_le (by positivity) hℓlo
  have hℓL : Real.log (Mof T θ) ≤ Real.log T := by nlinarith
  set L := Real.log T with hLdef
  set α₀ : ℂ := ((-(R / L) : ℝ) : ℂ) with hα₀def
  have hnα₀ : ‖α₀‖ = R / L := by
    rw [hα₀def, Complex.norm_real, Real.norm_eq_abs, abs_neg, abs_of_pos (by positivity)]
  have hρ : r / L = R / (2 * L) := by rw [hrdef]; field_simp
  -- the polydisc
  have hnorm : ∀ x ∈ closedBall α₀ (r / L), ‖x‖ ≤ 3 * R / (2 * L) := by
    intro x hx
    have h := norm_le_of_ball hx
    rw [hnα₀, hρ] at h
    have e : R / L + R / (2 * L) = 3 * R / (2 * L) := by
      field_simp
      try ring
    linarith
  have hsum : ∀ x ∈ closedBall α₀ (r / L), ∀ y ∈ closedBall α₀ (r / L), R / L ≤ ‖x + y‖ := by
    intro x hx y hy
    have h1 := mem_closedBall_iff_norm.mp hx
    have h2 := mem_closedBall_iff_norm.mp hy
    rw [hρ] at h1 h2
    have h3 : ‖(2 : ℂ) * α₀‖ = 2 * (R / L) := by
      rw [norm_mul, hnα₀]
      norm_num
    have h4 : ‖(2 : ℂ) * α₀‖ ≤ ‖x + y‖ + ‖x - α₀‖ + ‖y - α₀‖ := by
      calc ‖(2 : ℂ) * α₀‖ = ‖(x + y) - ((x - α₀) + (y - α₀))‖ := by ring_nf
        _ ≤ ‖x + y‖ + ‖(x - α₀) + (y - α₀)‖ := norm_sub_le _ _
        _ ≤ ‖x + y‖ + (‖x - α₀‖ + ‖y - α₀‖) := by gcongr; exact norm_add_le _ _
        _ = _ := by ring
    have e : 2 * (R / L) - R / (2 * L) - R / (2 * L) = R / L := by
      field_simp
      try ring
    linarith
  have hsumhi : ∀ x ∈ closedBall α₀ (r / L), ∀ y ∈ closedBall α₀ (r / L),
      ‖x + y‖ ≤ 3 * R / L := by
    intro x hx y hy
    have e : 3 * R / (2 * L) + 3 * R / (2 * L) = 3 * R / L := by
      field_simp
      try ring
    linarith [norm_add_le x y, hnorm x hx, hnorm y hy]
  have hne : ∀ x ∈ closedBall α₀ (r / L), ∀ y ∈ closedBall α₀ (r / L), x + y ≠ 0 := by
    intro x hx y hy h0
    have := hsum x hx y hy
    rw [h0, norm_zero] at this
    have : 0 < R / L := by positivity
    linarith
  have hcen : α₀ ∈ closedBall α₀ (r / L) := mem_closedBall_self (by positivity)
  -- the bound on `c₁`
  have hc1 : ∀ x y : ℂ, x + y ≠ 0 → ‖x‖ ≤ 3 * R / (2 * L) → ‖y‖ ≤ 3 * R / (2 * L) →
      R / L ≤ ‖x + y‖ → ‖c1Y P (Mof T θ) x y‖ ≤ K1 := by
    intro x y hxy hx hy hs
    rw [c1Y_eq]
    refine (c1form_norm_le P (Mof T θ) hxy hℓ0).trans ?_
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
    have t3 : ‖x‖ * ‖y‖ * Real.log (Mof T θ) * ‖Cq P‖ / ‖x + y‖ ≤ 9 * R / 4 * ‖Cq P‖ := by
      have hxy2 : ‖x‖ * ‖y‖ ≤ (3 * R / (2 * L)) * (3 * R / (2 * L)) :=
        mul_le_mul hx hy (norm_nonneg _) (by positivity)
      have hnum : ‖x‖ * ‖y‖ * Real.log (Mof T θ) * ‖Cq P‖ ≤
          (3 * R / (2 * L)) * (3 * R / (2 * L)) * L * ‖Cq P‖ := by
        refine mul_le_mul_of_nonneg_right ?_ (norm_nonneg _)
        exact mul_le_mul hxy2 hℓL hℓ0.le (by positivity)
      calc ‖x‖ * ‖y‖ * Real.log (Mof T θ) * ‖Cq P‖ / ‖x + y‖ ≤
          (3 * R / (2 * L)) * (3 * R / (2 * L)) * L * ‖Cq P‖ / (R / L) :=
            div_le_div₀ (by positivity) hnum (by positivity) hs
        _ = 9 * R / 4 * ‖Cq P‖ := by field_simp; ring
    rw [hK1def]
    linarith
  have hS : ∀ x ∈ closedBall α₀ (r / L), ∀ y ∈ closedBall α₀ (r / L),
      ‖cY P (Mof T θ) T x y‖ ≤ S := by
    intro x hx y hy
    have hxy := hne x hx y hy
    have hyx : -y + -x ≠ 0 := by
      intro e
      apply hxy
      linear_combination -e
    have hsyx : ‖-y + -x‖ = ‖x + y‖ := by
      rw [show -y + -x = -(x + y) by ring, norm_neg]
    have h1 := hc1 x y hxy (hnorm x hx) (hnorm y hy) (hsum x hx y hy)
    have h2 := hc1 (-y) (-x) hyx (by rw [norm_neg]; exact hnorm y hy)
      (by rw [norm_neg]; exact hnorm x hx) (by rw [hsyx]; exact hsum x hx y hy)
    have h3 := Tpow_norm_le (R := R) hT1 (hsumhi x hx y hy)
    unfold cY
    calc ‖c1Y P (Mof T θ) x y + (T : ℂ) ^ (-(x + y)) * c1Y P (Mof T θ) (-y) (-x)‖ ≤
        ‖c1Y P (Mof T θ) x y‖ + ‖(T : ℂ) ^ (-(x + y))‖ * ‖c1Y P (Mof T θ) (-y) (-x)‖ := by
          rw [← norm_mul]; exact norm_add_le _ _
      _ ≤ K1 + Real.exp (3 * R) * K1 :=
          add_le_add h1 (mul_le_mul h3 h2 (norm_nonneg _) (Real.exp_pos _).le)
  have hTne : T ≠ 0 := hT0.ne'
  have hcY := fun x y (hxy : x + y ≠ 0) => cY_partials P (Mof T θ) hTne hxy
  have hFa : ∀ y ∈ closedBall α₀ (r / L), ∀ x ∈ closedBall α₀ (r / L),
      DifferentiableAt ℂ (fun x => cY P (Mof T θ) T x y) x := fun y hy x hx =>
    (hcY x y (hne x hx y hy)).1
  have hFb : ∀ y ∈ closedBall α₀ (r / L), DifferentiableAt ℂ (fun y => cY P (Mof T θ) T α₀ y) y :=
    fun y hy => (hcY α₀ y (hne α₀ hcen y hy)).2.1
  have hg : ∀ y ∈ closedBall α₀ (r / L),
      DifferentiableAt ℂ (fun y => pa (cY P (Mof T θ) T) α₀ y) y :=
    fun y hy => (hcY α₀ y (hne α₀ hcen y hy)).2.2
  exact Dop_norm_le hL0 hr hFa hFb hg hS

/-- info: 'Unsmooth.c1form_norm_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms c1form_norm_le

/-- info: 'Unsmooth.dop_cY_bdd' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms dop_cY_bdd

end Unsmooth
