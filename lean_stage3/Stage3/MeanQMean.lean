/-
MeanQMean — block S13 of `lean_stage3/design/stencil.md`, B4 step 3, the mean value with a
general Q: the mean of `|Q(−D/L)ζ·ψ|²` from Lemma 3. 2026-11-25.

`FloorLong.mollMean_long` with `Dop` replaced by `DopQ` and `G = ζ + ζ′/L` by
`VQ = Q(−D/L)ζ`: from `StmtLemma3resO P θ R (2R + 1 + 1/R)` (any `θ`; `θ < 1/2` by
`Lemma3.lemma3_resO_holds`, every `θ` from `FloorLong.lemma3_of_long`),
`∫ w |VQ(σ₀+it)|² |ψ(σ₀+it)|² = DopQ[c](−R/L, −R/L)·ŵ(0) + o(T)`, uniformly over
`WeightAll T L` with `C_j ≤ Cs j`.

**Sizes.** Cauchy on the polydisc of radius `ρ = R/(2L)` about `(−R/L, −R/L)`
(`MeanQCauchy.DopQ_norm_le`): `‖DopQ f‖ ≤ (Σ_k |q_k| k! (2/R)^k)² · sup |f|`, a constant times
the Lemma-3 error. No factor of `L` is lost at any degree of `Q`.

  | name               | statement                                                     | status |
  |--------------------|---------------------------------------------------------------|--------|
  | `polydisc`         | the polydisc lies in `‖·‖ < 1/2`, off `α + β = 0`, in `Regime κ T` | PROVED |
  | `StmtMollMeanQ`    | the mean is `DopQ[c]·ŵ(0) + ε·errO` from some height on        | defined |
  | `mollMeanQ_long`   | `StmtLemma3resO P θ R (2R + 1 + 1/R) → StmtMollMeanQ Q P θ R`  | PROVED |
  | `mollMeanQ_lt_half`| `StmtMollMeanQ Q P θ R` for `P(0) = 0`, `0 < θ < 1/2`, `R > 0` | PROVED |

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.MeanQInt
import Stage3.FloorLongMean

noncomputable section

namespace MeanQ

open Complex Polynomial MeasureTheory Metric Filter Topology ApproxFE TwistedMoment Operator
  DiagMainStmt DiagonalO OffDiagClose

/-- **The polydisc**: radius `R/(2L)` about `−R/L`, for `3R + 1 ≤ L = log T`. -/
theorem polydisc {R T : ℝ} (hR : 0 < R) (hL : 3 * R + 1 ≤ Real.log T) :
    (∀ x ∈ closedBall (((-(R / Real.log T) : ℝ) : ℂ)) (R / 2 / Real.log T), ‖x‖ < 1 / 2) ∧
    (∀ x ∈ closedBall (((-(R / Real.log T) : ℝ) : ℂ)) (R / 2 / Real.log T),
      ∀ y ∈ closedBall (((-(R / Real.log T) : ℝ) : ℂ)) (R / 2 / Real.log T),
        R / Real.log T ≤ ‖x + y‖) ∧
    (∀ x ∈ closedBall (((-(R / Real.log T) : ℝ) : ℂ)) (R / 2 / Real.log T),
      ∀ y ∈ closedBall (((-(R / Real.log T) : ℝ) : ℂ)) (R / 2 / Real.log T),
        Regime (2 * R + 1 + 1 / R) T x y) := by
  have hL0 : 0 < Real.log T := by linarith
  set α₀ : ℂ := ((-(R / Real.log T) : ℝ) : ℂ) with hα₀def
  set κ : ℝ := 2 * R + 1 + 1 / R with hκdef
  have hκ : 0 < κ := by positivity
  have hκR : 1 ≤ κ * R := by
    rw [hκdef]
    have : (2 * R + 1 + 1 / R) * R = 2 * R ^ 2 + R + 1 := by field_simp
    rw [this]
    nlinarith
  have hnα₀ : ‖α₀‖ = R / Real.log T := by
    rw [hα₀def, Complex.norm_real, Real.norm_eq_abs, abs_neg, abs_of_pos (by positivity)]
  have hsmall : 3 * R / (2 * Real.log T) < 1 / 2 := by
    rw [div_lt_iff₀ (by positivity)]
    linarith
  have hρ : R / 2 / Real.log T = R / (2 * Real.log T) := by field_simp
  have hnorm : ∀ x ∈ closedBall α₀ (R / 2 / Real.log T), ‖x‖ ≤ 3 * R / (2 * Real.log T) := by
    intro x hx
    have h := norm_le_of_ball hx
    rw [hnα₀, hρ] at h
    have e : R / Real.log T + R / (2 * Real.log T) = 3 * R / (2 * Real.log T) := by
      field_simp
      try ring
    linarith
  have hsum : ∀ x ∈ closedBall α₀ (R / 2 / Real.log T), ∀ y ∈ closedBall α₀ (R / 2 / Real.log T),
      R / Real.log T ≤ ‖x + y‖ := by
    intro x hx y hy
    have h1 := mem_closedBall_iff_norm.mp hx
    have h2 := mem_closedBall_iff_norm.mp hy
    rw [hρ] at h1 h2
    have h3 : ‖(2 : ℂ) * α₀‖ = 2 * (R / Real.log T) := by
      rw [norm_mul, hnα₀]
      norm_num
    have h4 : ‖(2 : ℂ) * α₀‖ ≤ ‖x + y‖ + ‖x - α₀‖ + ‖y - α₀‖ := by
      calc ‖(2 : ℂ) * α₀‖ = ‖(x + y) - ((x - α₀) + (y - α₀))‖ := by ring_nf
        _ ≤ ‖x + y‖ + ‖(x - α₀) + (y - α₀)‖ := norm_sub_le _ _
        _ ≤ ‖x + y‖ + (‖x - α₀‖ + ‖y - α₀‖) := by gcongr; exact norm_add_le _ _
        _ = _ := by ring
    have e : 2 * (R / Real.log T) - R / (2 * Real.log T) - R / (2 * Real.log T) =
        R / Real.log T := by
      field_simp
      try ring
    linarith
  refine ⟨fun x hx => (hnorm x hx).trans_lt hsmall, hsum, fun x hx y hy => ?_⟩
  have hk : 3 * R / (2 * Real.log T) ≤ κ / Real.log T := by
    rw [div_le_div_iff₀ (by positivity) hL0]
    have : 3 * R ≤ 2 * κ := by rw [hκdef]; have := one_div_pos.mpr hR; linarith
    nlinarith
  have hk2 : 1 / (κ * Real.log T) ≤ R / Real.log T := by
    rw [div_le_div_iff₀ (by positivity) hL0]
    nlinarith
  exact ⟨(hnorm x hx).trans hk, (hnorm y hy).trans hk, hk2.trans (hsum x hx y hy)⟩

/-- **The mollified mean of `Q(−D/L)ζ` at `o(T)`**: for every family `Cs` and `ε > 0`, from some
height on, uniformly over `WeightAll T (log T)` with `C_j ≤ Cs j`,
`‖∫ w |VQ(σ₀+it)|² |ψ(σ₀+it)|² − DopQ[c](−R/L, −R/L) ŵ(0)‖ ≤ ε·errO W`. -/
def StmtMollMeanQ (Q P : ℝ[X]) (θ R : ℝ) : Prop :=
  ∀ Cs : ℕ → ℝ, ∀ ε : ℝ, 0 < ε → ∃ T₀ : ℝ, ∀ T : ℝ, T₀ ≤ T →
    ∀ W : WeightAll T (Real.log T), (∀ j, W.Cj j ≤ Cs j) →
      ‖mollMeanQ W.toWeight (Mof T θ) (aY P T θ R) (sig0 T R) Q (Real.log T) -
          DopQ Q (Real.log T) (cY P (Mof T θ) T) ((-(R / Real.log T) : ℝ) : ℂ)
              ((-(R / Real.log T) : ℝ) : ℂ) * (what0 W.toWeight : ℂ)‖ ≤
        ε * errO W.toWeight

/-- **The general-Q mean from Lemma 3**, every length: `FloorLong.mollMean_long` with `Dop`
replaced by `DopQ` and Cauchy's estimate taken to order `deg Q` in each variable. -/
theorem mollMeanQ_long (Q P : ℝ[X]) {θ R : ℝ} (hR : 0 < R)
    (hL3 : StmtLemma3resO P θ R (2 * R + 1 + 1 / R)) : StmtMollMeanQ Q P θ R := by
  intro Cs ε hε
  set κ : ℝ := 2 * R + 1 + 1 / R with hκdef
  have hκ : 0 < κ := by positivity
  set r : ℝ := R / 2 with hrdef
  have hr : 0 < r := by positivity
  set K0 : ℝ := Kq Q r ^ 2 + 1 with hK0def
  have hK0 : 0 < K0 := by positivity
  set ε₁ : ℝ := ε / (2 * K0) with hε₁def
  have hε₁ : 0 < ε₁ := by positivity
  obtain ⟨T1, hT1⟩ := hL3 Cs ε₁ hε₁
  obtain ⟨T2, hT2⟩ := FloorLong.Ires_o_long (θ := θ) P R hκ ε₁ hε₁
  refine ⟨max (max T1 T2) (max 4 (Real.exp (3 * R + 1))), fun T hT W hW => ?_⟩
  simp only [max_le_iff] at hT
  obtain ⟨⟨hTa, hTb⟩, hT4, hTe⟩ := hT
  have hT0 : 0 < T := by linarith
  have hL : 3 * R + 1 ≤ Real.log T := (Real.le_log_iff_exp_le hT0).mpr hTe
  have hL0 : 0 < Real.log T := by linarith
  set α₀ : ℂ := ((-(R / Real.log T) : ℝ) : ℂ) with hα₀def
  have hα₀σ : α₀ = ((sig0 T R - 1 / 2 : ℝ) : ℂ) := by
    rw [hα₀def]
    unfold sig0
    congr 1
    ring
  obtain ⟨hlt, hsum, hreg⟩ := polydisc hR hL
  have hρ0 : 0 ≤ R / 2 / Real.log T := by positivity
  have hcen : α₀ ∈ closedBall α₀ (R / 2 / Real.log T) := mem_closedBall_self hρ0
  have hne : ∀ x ∈ closedBall α₀ (R / 2 / Real.log T), ∀ y ∈ closedBall α₀ (R / 2 / Real.log T),
      x + y ≠ 0 := by
    intro x hx y hy h0
    have := hsum x hx y hy
    rw [h0, norm_zero] at this
    have : 0 < R / Real.log T := by positivity
    linarith
  set ŵ : ℂ := (what0 W.toWeight : ℂ) with hŵ
  set A : ℂ → ℂ → ℂ := Imom W.toWeight (Mof T θ) (aY P T θ R) (sig0 T R) with hA
  set B : ℂ → ℂ → ℂ := cY P (Mof T θ) T with hB
  have herr := T_le_errO W.toWeight hT0.le
  have hS : ∀ x ∈ closedBall α₀ (r / Real.log T), ∀ y ∈ closedBall α₀ (r / Real.log T),
      ‖(fun x y => A x y - B x y * ŵ) x y‖ ≤ 2 * ε₁ * errO W.toWeight := by
    intro x hx y hy
    have h1 := hT1 T hTa W hW x y (hreg x hx y hy)
    have h2 := hT2 T hTb W.toWeight x y (hreg x hx y hy)
    have h3 : ε₁ * T ≤ ε₁ * errO W.toWeight := mul_le_mul_of_nonneg_left herr hε₁.le
    show ‖A x y - B x y * ŵ‖ ≤ _
    linarith
  have hTne : T ≠ 0 := hT0.ne'
  have hAs := fun x y (hx : ‖x‖ < 1 / 2) (hy : ‖y‖ < 1 / 2) =>
    Imom_slices W.toWeight (Mof T θ) (aY P T θ R) (sig0 T R) hT4 hx hy
  have hBs := fun x y (hxy : x + y ≠ 0) => cY_slices P (Mof T θ) hTne hxy
  -- the slices near the centre
  have hO : IsOpen {y : ℂ | ‖y‖ < 1 / 2} := isOpen_lt continuous_norm continuous_const
  have hFa : ∀ y ∈ closedBall α₀ (r / Real.log T), ∀ x ∈ closedBall α₀ (r / Real.log T),
      DifferentiableAt ℂ (fun x => (fun x y => A x y - B x y * ŵ) x y) x := fun y hy x hx =>
    (hAs x y (hlt x hx) (hlt y hy)).1.differentiableAt.sub
      ((hBs x y (hne x hx y hy)).1.self_of_nhds.differentiableAt.mul_const ŵ)
  have hev : ∀ k, ∀ y ∈ closedBall α₀ (r / Real.log T),
      (fun y => iteratedDeriv k (fun x => (fun x y => A x y - B x y * ŵ) x y) α₀) =ᶠ[𝓝 y]
        fun y => iteratedDeriv k (fun x => A x y) α₀ -
          iteratedDeriv k (fun x => B x y) α₀ * ŵ := by
    intro k y hy
    filter_upwards [hO.mem_nhds (hlt y hy), (hBs α₀ y (hne α₀ hcen y hy)).1] with y' hy' hb
    exact iteratedDeriv_sub_mul k (hAs α₀ y' (hlt α₀ hcen) hy').1 hb
  have hFb : ∀ k, ∀ y ∈ closedBall α₀ (r / Real.log T),
      DifferentiableAt ℂ (fun y => iteratedDeriv k
        (fun x => (fun x y => A x y - B x y * ŵ) x y) α₀) y := by
    intro k y hy
    refine DifferentiableAt.congr_of_eventuallyEq ?_ (hev k y hy)
    exact ((hAs α₀ y (hlt α₀ hcen) (hlt y hy)).2 k).differentiableAt.sub
      (((hBs α₀ y (hne α₀ hcen y hy)).2 k).differentiableAt.mul_const ŵ)
  have hbound := DopQ_norm_le Q hL0 hr hFa hFb hS
  -- linearity at the centre
  have hcen2 : ‖α₀‖ < 1 / 2 := hlt α₀ hcen
  have hcen3 : α₀ + α₀ ≠ 0 := hne α₀ hcen α₀ hcen
  have hAa : ∀ᶠ y in 𝓝 α₀, AnalyticAt ℂ (fun x => A x y) α₀ := by
    filter_upwards [hO.mem_nhds hcen2] with y hy
    exact (hAs α₀ y hcen2 hy).1
  have hlin := DopQ_sub_mul Q (Real.log T) (c := ŵ) hAa (hBs α₀ α₀ hcen3).1
    (hAs α₀ α₀ hcen2 hcen2).2 (hBs α₀ α₀ hcen3).2
  have hmean : DopQ Q (Real.log T) A α₀ α₀ =
      mollMeanQ W.toWeight (Mof T θ) (aY P T θ R) (sig0 T R) Q (Real.log T) := by
    rw [hα₀σ]
    exact DopQ_Imom W.toWeight (Mof T θ) (aY P T θ R) (sig0 T R) Q (Real.log T) hT4
      (by rw [← hα₀σ]; exact hcen2)
  rw [← hmean, ← hlin]
  have hKq : Kq Q r ^ 2 ≤ K0 := by rw [hK0def]; linarith
  have herr0 : 0 ≤ errO W.toWeight := le_trans hT0.le herr
  calc _ ≤ 2 * ε₁ * errO W.toWeight * Kq Q r ^ 2 := hbound
    _ ≤ 2 * ε₁ * errO W.toWeight * K0 := mul_le_mul_of_nonneg_left hKq (by positivity)
    _ = ε * errO W.toWeight := by
        rw [hε₁def]
        field_simp

/-- **The general-Q mean, unconditional for `θ < 1/2`.** -/
theorem mollMeanQ_lt_half (Q P : ℝ[X]) (hP0 : P.eval 0 = 0) {θ R : ℝ} (hθ0 : 0 < θ)
    (hθ : θ < 1 / 2) (hR : 0 < R) : StmtMollMeanQ Q P θ R :=
  mollMeanQ_long Q P hR (Lemma3.lemma3_resO_holds P hP0 hθ0 hθ R (by positivity))

/-- info: 'MeanQ.polydisc' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms polydisc

/-- info: 'MeanQ.mollMeanQ_long' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms mollMeanQ_long

/-- info: 'MeanQ.mollMeanQ_lt_half' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms mollMeanQ_lt_half

end MeanQ

end
