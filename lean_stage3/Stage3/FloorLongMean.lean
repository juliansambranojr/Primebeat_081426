/-
# FloorLongMean — block S13 of `lean_stage3/design/stencil.md`, B1, the floor for every length: Lemma 3 to the sharp mean. 2026-11-25.

From Lemma 3 at `o(T)` (`DiagonalO.StmtLemma3resO`, given at length `θ` by
`FloorLongErr.lemma3_of_long`) to the sharp one-sided mean, for every `θ > 0`. The proofs are
copies of `Operator.stmtMollMeanO_holds`, `Unsmooth.unsmooth_near`,
`Unsmooth.unsmooth_near_levinson` with the Lemma-3 call replaced by the hypothesis; two
helpers of theirs used `θ < 1/2` as `θ ≤ 1` and are re-proved for every `θ`:
* `Operator.Ires_o` bounded `M ≤ T`; here `M ≤ T^n`, `n = ⌈θ⌉₊`, and the remainder
  `≪ T^(2n+3) e^(−T²/32)` is still `o(T)` (`pow_le_exp_long`, `x^k/k! ≤ eˣ` at `k = n + 2`);
* `Unsmooth.dop_cY_bdd` bounded `log M ≤ log T`; here `‖D[c]‖ = |Kfl(A,B,C,θ′,R)|` exactly
  (`FloorConst.dop_cY_eq`, `θ′ = log M/log T`) and `θ′ → θ` (`theta_tendsto`), so
  `‖D[c]‖ ≤ |Kfl(A,B,C,θ,R)| + 1` eventually.

The sizes, checked before the proof: the Cauchy radius `R/(2L)` and the unsmoothing excess
`K(3T/L + 2)` do not involve `θ`; only `M`'s size enters, in `I_res` (above), where
`e^(−T²/32)` beats any power of `T`. No factor is lost.

| name | content | status |
|---|---|---|
| `pow_le_exp_long` | `T^(2k) ≤ 32^k k! e^(T²/32)` | proved |
| `Ires_o_long` | `‖I_res‖ ≤ ε T` on `Regime κ T` eventually, every `θ` | proved |
| `mollMean_long` | `StmtLemma3resO P θ R (2R + 1 + 1/R) → StmtMollMeanO P θ R` | proved |
| `dop_bdd_long` | `‖D[c](−R/L, −R/L)‖ ≤ K` eventually, every `θ > 0` | proved |
| `unsmooth_near_long` | `StmtMollMeanO → ` the sharp one-sided mean | proved |
| `unsmooth_near_levinson_long` | the same in `levinson_window'`'s integrand | proved |

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Stage3.FloorLongErr
import Stage3.Unsmooth
import Stage3.FloorConstLimit

namespace FloorLong

open Complex Metric MeasureTheory Filter Topology ApproxFE TwistedMoment DiagMainStmt DiagonalO
  OffDiagClose Operator Unsmooth

/-- `T^(2k) ≤ 32^k k! e^(T²/32)`, from `x^k/k! ≤ eˣ`. -/
theorem pow_le_exp_long (T : ℝ) (k : ℕ) :
    T ^ (2 * k) ≤ 32 ^ k * (Nat.factorial k : ℝ) * Real.exp (T ^ 2 / 32) := by
  have h := Real.pow_div_factorial_le_exp (T ^ 2 / 32) (by positivity) k
  have e : (T ^ 2 / 32) ^ k / (Nat.factorial k : ℝ) =
      T ^ (2 * k) / (32 ^ k * (Nat.factorial k : ℝ)) := by
    rw [div_pow, ← pow_mul, div_div]
  rw [e, div_le_iff₀ (by positivity)] at h
  linarith

/-- **The remainder is `o(T)` for every length**: `Operator.Ires_o` with `M ≤ T^⌈θ⌉₊`. -/
theorem Ires_o_long (P : Polynomial ℝ) {θ : ℝ} (R : ℝ) {κ : ℝ} (hκ : 0 < κ) :
    ∀ ε : ℝ, 0 < ε → ∃ T₀ : ℝ, ∀ T : ℝ, T₀ ≤ T → ∀ W : Weight T (Real.log T), ∀ α β : ℂ,
      Regime κ T α β → ‖Ires W (Mof T θ) (aY P T θ R) (sig0 T R) α β‖ ≤ ε * T := by
  intro ε hε
  obtain ⟨C, hC0, hC⟩ := Ires_small
  obtain ⟨B, hB0, hB⟩ := aY_bound P
  obtain ⟨n, hndef⟩ : ∃ n : ℕ, n = ⌈θ⌉₊ := ⟨_, rfl⟩
  have hθn : θ ≤ (n : ℝ) := by rw [hndef]; exact Nat.le_ceil θ
  obtain ⟨c, hcdef⟩ : ∃ c : ℝ, c = 32 ^ (n + 2) * (Nat.factorial (n + 2) : ℝ) := ⟨_, rfl⟩
  have hc0 : 0 ≤ c := by rw [hcdef]; positivity
  obtain ⟨K', hK'⟩ : ∃ K' : ℝ, K' = C * (1 + κ ^ 2) * B ^ 2 := ⟨_, rfl⟩
  have hK'0 : 0 ≤ K' := by rw [hK']; positivity
  refine ⟨max (max 4 (Real.exp (10 * κ))) (K' * c / ε + 1),
    fun T hT W α β hreg => ?_⟩
  simp only [max_le_iff] at hT
  obtain ⟨⟨hT4, hTe⟩, hTK⟩ := hT
  obtain ⟨hα, hβ, hne, hL0⟩ := Regime.small hκ hTe hreg
  have hT0 : 0 < T := by linarith
  have hT1 : 1 ≤ T := by linarith
  have h := hC T (Real.log T) W hT4 (Mof T θ) (aY P T θ R) (sig0 T R) α β hα hβ
  have hLT : Real.log T ≤ T := by linarith [Real.log_le_sub_one_of_pos hT0]
  have hN : 1 + 1 / ‖α + β‖ ^ 2 ≤ (1 + κ ^ 2) * T ^ 2 := by
    have hpos : 0 < ‖α + β‖ := norm_pos_iff.mpr hne
    have h3 := hreg.2.2
    have h4 : 1 / ‖α + β‖ ≤ κ * Real.log T :=
      (one_div_le hpos (by positivity)).mpr h3
    have h5 : 1 / ‖α + β‖ ^ 2 ≤ (κ * T) ^ 2 := by
      rw [← one_div_pow]
      exact pow_le_pow_left₀ (by positivity)
        (h4.trans (mul_le_mul_of_nonneg_left hLT hκ.le)) 2
    have h6 : 1 ≤ T ^ 2 := one_le_pow₀ hT1
    nlinarith
  set Sψ : ℝ := ∑ h ∈ Finset.Icc 1 (Mof T θ), ‖aY P T θ R h‖ * (h : ℝ) ^ (-sig0 T R) with hSψ
  have hSψ0 : 0 ≤ Sψ := Finset.sum_nonneg fun h _ => by positivity
  have hM : (Mof T θ : ℝ) ≤ T ^ n := by
    have h1 : (Mof T θ : ℝ) ≤ T ^ θ := Nat.floor_le (by positivity)
    have h2 : T ^ θ ≤ T ^ (n : ℝ) := Real.rpow_le_rpow_of_exponent_le hT1 hθn
    rw [Real.rpow_natCast] at h2
    linarith
  have hSψb : Sψ ≤ B * T ^ n := by
    have h1 : Sψ ≤ (Finset.Icc 1 (Mof T θ)).card • B :=
      Finset.sum_le_card_nsmul _ _ _ fun h hh =>
        hB T θ R h (Finset.mem_Icc.mp hh).1 (Finset.mem_Icc.mp hh).2
    rw [Nat.card_Icc, nsmul_eq_mul, Nat.add_sub_cancel] at h1
    calc Sψ ≤ (Mof T θ : ℝ) * B := h1
      _ ≤ T ^ n * B := mul_le_mul_of_nonneg_right hM hB0
      _ = B * T ^ n := by ring
  set E : ℝ := Real.exp (-(T ^ 2 / 32)) with hE
  have hE0 : 0 ≤ E := (Real.exp_pos _).le
  have hEc : T ^ (2 * (n + 2)) * E ≤ c := by
    have h1 := pow_le_exp_long T (n + 2)
    rw [← hcdef] at h1
    have h2 : E * Real.exp (T ^ 2 / 32) = 1 := by
      rw [hE, ← Real.exp_add]
      simp
    nlinarith [Real.exp_pos (T ^ 2 / 32)]
  have hbig : ‖Ires W (Mof T θ) (aY P T θ R) (sig0 T R) α β‖ ≤ K' * T ^ (2 * n + 3) * E := by
    refine h.trans ?_
    have hsq : Sψ ^ 2 ≤ (B * T ^ n) ^ 2 := pow_le_pow_left₀ hSψ0 hSψb 2
    calc C * (1 + 1 / ‖α + β‖ ^ 2) * Sψ ^ 2 * T * E
        ≤ C * ((1 + κ ^ 2) * T ^ 2) * (B * T ^ n) ^ 2 * T * E := by
          have a1 : C * (1 + 1 / ‖α + β‖ ^ 2) ≤ C * ((1 + κ ^ 2) * T ^ 2) :=
            mul_le_mul_of_nonneg_left hN hC0
          have a2 : C * (1 + 1 / ‖α + β‖ ^ 2) * Sψ ^ 2 ≤
              C * ((1 + κ ^ 2) * T ^ 2) * (B * T ^ n) ^ 2 :=
            mul_le_mul a1 hsq (by positivity) (by positivity)
          have a3 := mul_le_mul_of_nonneg_right a2 hT0.le
          exact mul_le_mul_of_nonneg_right a3 hE0
      _ = K' * T ^ (2 * n + 3) * E := by rw [hK']; ring
  have hKT : K' * c ≤ ε * T := by
    have : K' * c / ε ≤ T := by linarith
    rwa [div_le_iff₀ hε, mul_comm T] at this
  have hfin : K' * T ^ (2 * n + 3) * E * T ≤ ε * T * T := by
    calc K' * T ^ (2 * n + 3) * E * T = K' * (T ^ (2 * (n + 2)) * E) := by ring
      _ ≤ K' * c := mul_le_mul_of_nonneg_left hEc hK'0
      _ ≤ ε * T := hKT
      _ ≤ ε * T * T := le_mul_of_one_le_right (by positivity) hT1
  exact hbig.trans (le_of_mul_le_mul_right hfin hT0)

/-- **The mollified mean from Lemma 3**, every length: `Operator.stmtMollMeanO_holds` with
`Lemma3.lemma3_resO_holds` replaced by the hypothesis at `κ = 2R + 1 + 1/R`. -/
theorem mollMean_long (P : Polynomial ℝ) {θ : ℝ} {R : ℝ} (hR : 0 < R)
    (hL3 : StmtLemma3resO P θ R (2 * R + 1 + 1 / R)) : StmtMollMeanO P θ R := by
  intro Cs ε hε
  set κ : ℝ := 2 * R + 1 + 1 / R with hκdef
  have hκ : 0 < κ := by positivity
  have hκR : 1 ≤ κ * R := by
    rw [hκdef]
    have : (2 * R + 1 + 1 / R) * R = 2 * R ^ 2 + R + 1 := by field_simp
    rw [this]
    nlinarith
  set r : ℝ := R / 2 with hrdef
  have hr : 0 < r := by positivity
  set K0 : ℝ := 1 + 2 / r + 1 / r ^ 2 with hK0def
  have hK0 : 0 < K0 := by positivity
  set ε₁ : ℝ := ε / (2 * K0) with hε₁def
  have hε₁ : 0 < ε₁ := by positivity
  obtain ⟨T1, hT1⟩ := hL3 Cs ε₁ hε₁
  obtain ⟨T2, hT2⟩ := Ires_o_long P R hκ ε₁ hε₁
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
  have hnα₀ : ‖α₀‖ = R / Real.log T := by
    rw [hα₀def, Complex.norm_real, Real.norm_eq_abs, abs_neg, abs_of_pos (by positivity)]
  have hRL : 0 < R / Real.log T := by positivity
  have hsmall : 3 * R / (2 * Real.log T) < 1 / 2 := by
    rw [div_lt_iff₀ (by positivity)]
    linarith
  have hρ : r / Real.log T = R / (2 * Real.log T) := by rw [hrdef]; field_simp
  -- the polydisc
  have hnorm : ∀ x ∈ closedBall α₀ (r / Real.log T), ‖x‖ ≤ 3 * R / (2 * Real.log T) := by
    intro x hx
    have h := norm_le_of_ball hx
    rw [hnα₀, hρ] at h
    have e : R / Real.log T + R / (2 * Real.log T) = 3 * R / (2 * Real.log T) := by
      field_simp
      try ring
    linarith
  have hlt : ∀ x ∈ closedBall α₀ (r / Real.log T), ‖x‖ < 1 / 2 := fun x hx =>
    (hnorm x hx).trans_lt hsmall
  have hsum : ∀ x ∈ closedBall α₀ (r / Real.log T), ∀ y ∈ closedBall α₀ (r / Real.log T),
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
  have hne : ∀ x ∈ closedBall α₀ (r / Real.log T), ∀ y ∈ closedBall α₀ (r / Real.log T),
      x + y ≠ 0 := by
    intro x hx y hy h0
    have := hsum x hx y hy
    rw [h0, norm_zero] at this
    linarith
  have hreg : ∀ x ∈ closedBall α₀ (r / Real.log T), ∀ y ∈ closedBall α₀ (r / Real.log T),
      Regime κ T x y := by
    intro x hx y hy
    have hk : 3 * R / (2 * Real.log T) ≤ κ / Real.log T := by
      rw [div_le_div_iff₀ (by positivity) hL0]
      have : 3 * R ≤ 2 * κ := by rw [hκdef]; have := one_div_pos.mpr hR; linarith
      nlinarith
    have hk2 : 1 / (κ * Real.log T) ≤ R / Real.log T := by
      rw [div_le_div_iff₀ (by positivity) hL0]
      nlinarith
    exact ⟨(hnorm x hx).trans hk, (hnorm y hy).trans hk, hk2.trans (hsum x hx y hy)⟩
  have hcen : α₀ ∈ closedBall α₀ (r / Real.log T) := mem_closedBall_self (by positivity)
  -- the function
  set ŵ : ℂ := (what0 W.toWeight : ℂ) with hŵ
  have herr := T_le_errO W.toWeight hT0.le
  have hS : ∀ x ∈ closedBall α₀ (r / Real.log T), ∀ y ∈ closedBall α₀ (r / Real.log T),
      ‖(fun x y => Imom W.toWeight (Mof T θ) (aY P T θ R) (sig0 T R) x y -
          cY P (Mof T θ) T x y * ŵ) x y‖ ≤ 2 * ε₁ * errO W.toWeight := by
    intro x hx y hy
    have h1 := hT1 T hTa W hW x y (hreg x hx y hy)
    have h2 := hT2 T hTb W.toWeight x y (hreg x hx y hy)
    have h3 : ε₁ * T ≤ ε₁ * errO W.toWeight := mul_le_mul_of_nonneg_left herr hε₁.le
    show ‖Imom W.toWeight (Mof T θ) (aY P T θ R) (sig0 T R) x y -
          cY P (Mof T θ) T x y * (what0 W.toWeight : ℂ)‖ ≤ _
    linarith
  have hTne : T ≠ 0 := hT0.ne'
  have hIm := fun x y (hx : ‖x‖ < 1 / 2) (hy : ‖y‖ < 1 / 2) =>
    Imom_partials W.toWeight (Mof T θ) (aY P T θ R) (sig0 T R) hT4 hx hy
  have hcY := fun x y (hxy : x + y ≠ 0) => cY_partials P (Mof T θ) hTne hxy
  have hpaF : ∀ y, ‖y‖ < 1 / 2 → α₀ + y ≠ 0 →
      pa (fun x y => Imom W.toWeight (Mof T θ) (aY P T θ R) (sig0 T R) x y -
          cY P (Mof T θ) T x y * ŵ) α₀ y =
        pa (Imom W.toWeight (Mof T θ) (aY P T θ R) (sig0 T R)) α₀ y -
          pa (cY P (Mof T θ) T) α₀ y * ŵ := by
    intro y hy hne'
    unfold pa
    rw [deriv_fun_sub (hIm α₀ y (hlt α₀ hcen) hy).1 ((hcY α₀ y hne').1.mul_const ŵ),
      deriv_mul_const (hcY α₀ y hne').1]
  have hO : IsOpen {y : ℂ | ‖y‖ < 1 / 2 ∧ α₀ + y ≠ 0} :=
    (isOpen_lt continuous_norm continuous_const).inter
      (isOpen_ne_fun (by fun_prop) continuous_const)
  have hFa : ∀ y ∈ closedBall α₀ (r / Real.log T), ∀ x ∈ closedBall α₀ (r / Real.log T),
      DifferentiableAt ℂ (fun x => (fun x y => Imom W.toWeight (Mof T θ) (aY P T θ R) (sig0 T R) x y -
          cY P (Mof T θ) T x y * ŵ) x y) x := fun y hy x hx =>
    (hIm x y (hlt x hx) (hlt y hy)).1.sub ((hcY x y (hne x hx y hy)).1.mul_const ŵ)
  have hFb : ∀ y ∈ closedBall α₀ (r / Real.log T),
      DifferentiableAt ℂ (fun y => (fun x y => Imom W.toWeight (Mof T θ) (aY P T θ R) (sig0 T R) x y -
          cY P (Mof T θ) T x y * ŵ) α₀ y) y := fun y hy =>
    (hIm α₀ y (hlt α₀ hcen) (hlt y hy)).2.1.sub
      ((hcY α₀ y (hne α₀ hcen y hy)).2.1.mul_const ŵ)
  have hg : ∀ y ∈ closedBall α₀ (r / Real.log T),
      DifferentiableAt ℂ (fun y => pa (fun x y => Imom W.toWeight (Mof T θ) (aY P T θ R) (sig0 T R) x y -
          cY P (Mof T θ) T x y * ŵ) α₀ y) y := by
    intro y hy
    have hev : (fun y => pa (fun x y => Imom W.toWeight (Mof T θ) (aY P T θ R) (sig0 T R) x y -
          cY P (Mof T θ) T x y * ŵ) α₀ y) =ᶠ[𝓝 y]
        fun y => pa (Imom W.toWeight (Mof T θ) (aY P T θ R) (sig0 T R)) α₀ y -
          pa (cY P (Mof T θ) T) α₀ y * ŵ := by
      filter_upwards [hO.mem_nhds ⟨hlt y hy, hne α₀ hcen y hy⟩] with y' hy'
      exact hpaF y' hy'.1 hy'.2
    exact (((hIm α₀ y (hlt α₀ hcen) (hlt y hy)).2.2.2.2.1).sub
      ((hcY α₀ y (hne α₀ hcen y hy)).2.2.mul_const ŵ)).congr_of_eventuallyEq hev
  have hbound := Dop_norm_le hL0 hr hFa hFb hg hS
  -- linearity at the centre
  have hcen2 : ‖α₀‖ < 1 / 2 := hlt α₀ hcen
  have hcen3 : α₀ + α₀ ≠ 0 := hne α₀ hcen α₀ hcen
  have hAa : ∀ᶠ y in 𝓝 α₀, DifferentiableAt ℂ
      (fun x => Imom W.toWeight (Mof T θ) (aY P T θ R) (sig0 T R) x y) α₀ := by
    filter_upwards [hO.mem_nhds ⟨hcen2, hcen3⟩] with y hy
    exact (hIm α₀ y hcen2 hy.1).1
  have hBa : ∀ᶠ y in 𝓝 α₀, DifferentiableAt ℂ (fun x => cY P (Mof T θ) T x y) α₀ := by
    filter_upwards [hO.mem_nhds ⟨hcen2, hcen3⟩] with y hy
    exact (hcY α₀ y hy.2).1
  have hlin := Dop_sub_mul (c := ŵ) (Real.log T) hAa hBa (hIm α₀ α₀ hcen2 hcen2).2.1
    (hcY α₀ α₀ hcen3).2.1 (hIm α₀ α₀ hcen2 hcen2).2.2.2.2.1 (hcY α₀ α₀ hcen3).2.2
  have hmean : Dop (Real.log T) (Imom W.toWeight (Mof T θ) (aY P T θ R) (sig0 T R)) α₀ α₀ =
      mollMean W.toWeight (Mof T θ) (aY P T θ R) (sig0 T R) (Real.log T) := by
    rw [hα₀σ]
    exact Dop_Imom W.toWeight (Mof T θ) (aY P T θ R) (sig0 T R) (Real.log T) hT4
      (by rw [← hα₀σ]; exact hcen2)
  rw [← hmean, ← hlin]
  calc _ ≤ 2 * ε₁ * errO W.toWeight * K0 := hbound
    _ = ε * errO W.toWeight := by
        rw [hε₁def]
        field_simp

/-- **`D[c]` is bounded for every length**: `‖D[c]‖ = |Kfl(A,B,C,θ′,R)|`, `θ′ → θ`. -/
theorem dop_bdd_long (P : Polynomial ℝ) {θ : ℝ} (hθ0 : 0 < θ) {R : ℝ} (hR : 0 < R) :
    ∃ K : ℝ, 0 ≤ K ∧ ∃ T₀ : ℝ, ∀ T : ℝ, T₀ ≤ T →
      ‖Dop (Real.log T) (cY P (Mof T θ) T) ((-(R / Real.log T) : ℝ) : ℂ)
          ((-(R / Real.log T) : ℝ) : ℂ)‖ ≤ K := by
  have ht := FloorConst.tendsto_Kfl (FloorConst.Ar P) (FloorConst.Br P) (FloorConst.Cr P) R
    hθ0.ne' (FloorConst.theta_tendsto hθ0)
  have hev := ht.eventually (Metric.ball_mem_nhds _ one_pos)
  obtain ⟨T₀, hT₀⟩ := eventually_atTop.mp
    (hev.and (eventually_ge_atTop (max 2 (Real.exp (4 * Real.log 2 / θ)))))
  refine ⟨|FloorConst.Kfl (FloorConst.Ar P) (FloorConst.Br P) (FloorConst.Cr P) θ R| + 1,
    by positivity, T₀, fun T hT => ?_⟩
  obtain ⟨hd, hT⟩ := hT₀ T hT
  simp only [max_le_iff] at hT
  obtain ⟨hT2, hTe⟩ := hT
  have hT1 : 1 < T := by linarith
  have hT0 : 0 < T := by linarith
  have hLθ : 4 * Real.log 2 / θ ≤ Real.log T := (Real.le_log_iff_exp_le hT0).mpr hTe
  have hℓlo := DiagMain.logM_ge hT1 hθ0 hLθ
  have hℓ0 : 0 < Real.log (Mof T θ) :=
    lt_of_lt_of_le (by have := Real.log_pos hT1; positivity) hℓlo
  rw [FloorConst.dop_cY_eq P hT1 hℓ0.ne' hR.ne', Complex.norm_real, Real.norm_eq_abs]
  rw [Real.dist_eq] at hd
  have := abs_sub_abs_le_abs_sub
    (FloorConst.Kfl (FloorConst.Ar P) (FloorConst.Br P) (FloorConst.Cr P)
      (Real.log (Mof T θ) / Real.log T) R)
    (FloorConst.Kfl (FloorConst.Ar P) (FloorConst.Br P) (FloorConst.Cr P) θ R)
  linarith

/-- **The sharp one-sided mean from the mollified mean**, every length: `Unsmooth.unsmooth_near`
with `stmtMollMeanO_holds` replaced by the hypothesis and `dop_cY_bdd` by `dop_bdd_long`. -/
theorem unsmooth_near_long (P : Polynomial ℝ) {θ : ℝ} (hθ0 : 0 < θ) {R : ℝ} (hR : 0 < R)
    (hMM : StmtMollMeanO P θ R) :
    ∀ ε : ℝ, 0 < ε → ∃ T₀ : ℝ, ∀ T : ℝ, T₀ ≤ T → ∀ a' b' : ℝ,
      T / 2 ≤ a' → a' ≤ T / 2 + 1 → T - 1 ≤ b' → b' ≤ T →
      (1 / (b' - a')) * ∫ t in a'..b',
          ‖Gl (Real.log T) ((sig0 T R : ℂ) + t * I) *
            psi (Mof T θ) (aY P T θ R) ((sig0 T R : ℂ) + t * I)‖ ^ 2 ≤
        (Dop (Real.log T) (cY P (Mof T θ) T) ((-(R / Real.log T) : ℝ) : ℂ)
          ((-(R / Real.log T) : ℝ) : ℂ)).re + ε := by
  intro ε hε
  obtain ⟨K, hK0, TK, hK⟩ := dop_bdd_long P hθ0 hR
  set C : ℝ := 1 + winC 1 + winC 2 with hCdef
  have hC : 0 < C := by
    have := winC_nonneg 1
    have := winC_nonneg 2
    positivity
  set ε₁ : ℝ := ε / (8 * C) with hε₁def
  have hε₁ : 0 < ε₁ := by positivity
  have hε₁C : ε₁ * C = ε / 8 := by rw [hε₁def]; field_simp
  obtain ⟨T1, hT1⟩ := hMM winC ε₁ hε₁
  refine ⟨max (max T1 TK) (max (max 16 (32 * K / ε)) (Real.exp (max 8 (48 * K / ε)))),
    fun T hT a' b' ha1 ha2 hb1 hb2 => ?_⟩
  simp only [max_le_iff] at hT
  obtain ⟨⟨hTa, hTb⟩, ⟨hT16, hTK⟩, hTe⟩ := hT
  have hT0 : 0 < T := by linarith
  have hLge : max 8 (48 * K / ε) ≤ Real.log T := (Real.le_log_iff_exp_le hT0).mpr hTe
  have hL8 : 8 ≤ Real.log T := le_trans (le_max_left _ _) hLge
  have hLK : 48 * K / ε ≤ Real.log T := le_trans (le_max_right _ _) hLge
  have hL0 : 0 < Real.log T := by linarith
  have hΔ : 0 < T / Real.log T := div_pos hT0 hL0
  have hΔ1 : T / Real.log T ≤ T / 8 := div_le_div_of_nonneg_left hT0.le (by norm_num) hL8
  set W : WeightAll T (Real.log T) := winNear T (Real.log T) hT0 hL8 with hWdef
  have hW := hT1 T hTa W (fun j => le_rfl)
  set D : ℂ := Dop (Real.log T) (cY P (Mof T θ) T) ((-(R / Real.log T) : ℝ) : ℂ)
      ((-(R / Real.log T) : ℝ) : ℂ) with hDdef
  have hDK : |D.re| ≤ K := (Complex.abs_re_le_norm D).trans (hK T hTb)
  set mm := mollMean W.toWeight (Mof T θ) (aY P T θ R) (sig0 T R) (Real.log T) with hmm
  set ŵ := what0 W.toWeight with hŵ
  have herr : errO W.toWeight = C * T := rfl
  -- the real part of the smoothed mean
  have hre : mm.re ≤ D.re * ŵ + ε₁ * (C * T) := by
    have h1 := Complex.re_le_norm (mm - D * (ŵ : ℂ))
    rw [Complex.sub_re, Complex.mul_re, Complex.ofReal_re, Complex.ofReal_im, mul_zero,
      sub_zero] at h1
    rw [← herr]
    linarith
  -- the window on `[a', b']`
  have hab : a' ≤ b' := by linarith
  have hone : ∀ t ∈ Set.Icc a' b', W.w t = 1 := by
    intro t ht
    show winNY T (Real.log T) t = 1
    exact winNY_one hΔ (by linarith [ht.1]) (by linarith [ht.2])
  set f : ℝ → ℝ := fun t => ‖Gl (Real.log T) ((sig0 T R : ℂ) + t * I)‖ ^ 2 *
      msq (Mof T θ) (aY P T θ R) (sig0 T R) t with hfdef
  have hσ1 : sig0 T R ≠ 1 := by
    unfold sig0
    have : 0 < R / Real.log T := by positivity
    intro h
    linarith
  have hfc : Continuous f := continuous_Gpsi (Mof T θ) (aY P T θ R) hσ1 (Real.log T)
  have hf0 : ∀ t, 0 ≤ f t := fun t => mul_nonneg (by positivity) (msq_nonneg _ _ _ _)
  have hint : ∫ t in a'..b', ‖Gl (Real.log T) ((sig0 T R : ℂ) + t * I) *
      psi (Mof T θ) (aY P T θ R) ((sig0 T R : ℂ) + t * I)‖ ^ 2 = ∫ t in a'..b', f t := by
    congr 1
    funext t
    exact norm_Gpsi_sq _ _ _ _ _
  have hsharp : ∫ t in a'..b', f t ≤ mm.re := by
    rw [hmm, mollMean_re]
    exact integral_le_of_one W.toWeight hfc hf0 hab hone
  -- `d ≤ ŵ(0) ≤ d + 3T/L + 2`
  set d := b' - a' with hd
  have hdT : T / 4 ≤ d := by linarith
  have hd0 : 0 < d := by linarith
  have hŵlo : d ≤ ŵ := by
    have h := integral_le_of_one W.toWeight (f := fun _ => (1 : ℝ)) continuous_const
      (fun _ => zero_le_one) hab hone
    rw [intervalIntegral.integral_const, smul_eq_mul, mul_one] at h
    simp only [mul_one] at h
    exact h
  have hŵhi : ŵ ≤ d + (3 * (T / Real.log T) + 2) := by
    have hlh : nearLo T (Real.log T) ≤ nearHi T (Real.log T) := by
      unfold nearLo nearHi; linarith
    have h := what0_le_of_zero W.toWeight hlh (fun t ht => by
      show winNY T (Real.log T) t = 0
      exact winNY_zero hΔ fun h' => ht ⟨h'.1.le, h'.2.le⟩)
    unfold nearLo nearHi at h
    linarith
  -- the excess
  have hexc : D.re * ŵ ≤ D.re * d + K * (3 * (T / Real.log T) + 2) := by
    have h1 : D.re * (ŵ - d) ≤ K * (ŵ - d) :=
      mul_le_mul_of_nonneg_right ((le_abs_self _).trans hDK) (by linarith)
    have h2 : K * (ŵ - d) ≤ K * (3 * (T / Real.log T) + 2) :=
      mul_le_mul_of_nonneg_left (by linarith) hK0
    have e : D.re * ŵ = D.re * d + D.re * (ŵ - d) := by ring
    linarith
  -- the sizes
  have hs1 : K * (3 * (T / Real.log T)) ≤ ε * T / 16 := by
    have h48 : 48 * K ≤ ε * Real.log T := by
      rw [div_le_iff₀ hε] at hLK
      linarith
    have e : K * (3 * (T / Real.log T)) = (48 * K) * T / (16 * Real.log T) := by
      field_simp
      try ring
    rw [e, div_le_iff₀ (by positivity)]
    have e2 : ε * T / 16 * (16 * Real.log T) = (ε * Real.log T) * T := by ring
    rw [e2]
    exact mul_le_mul_of_nonneg_right h48 hT0.le
  have hs2 : K * 2 ≤ ε * T / 16 := by
    rw [div_le_iff₀ hε] at hTK
    linarith
  have hs3 : ε₁ * (C * T) = ε * T / 8 := by
    rw [← mul_assoc, hε₁C]
    ring
  have hfin : ∫ t in a'..b', f t ≤ D.re * d + ε * d := by
    have h1 : ε * T / 4 ≤ ε * d := by
      have := mul_le_mul_of_nonneg_left hdT hε.le
      linarith
    nlinarith
  rw [hint, one_div_mul_eq_div, div_le_iff₀ hd0]
  linarith


/-- **The sharp one-sided mean in `levinson_window'`'s integrand**, every length. -/
theorem unsmooth_near_levinson_long (P : Polynomial ℝ) {θ : ℝ} (hθ0 : 0 < θ) {R : ℝ}
    (hR : 0 < R) (hMM : StmtMollMeanO P θ R) :
    ∀ ε : ℝ, 0 < ε → ∃ T₀ : ℝ, ∀ T : ℝ, T₀ ≤ T → ∀ c : ℝ, c = 1 / Real.log T →
      ∀ a' b' : ℝ, T / 2 ≤ a' → a' ≤ T / 2 + 1 → T - 1 ≤ b' → b' ≤ T →
      (1 / (b' - a')) * ∫ t in a'..b',
          ‖(riemannZeta (↑(sig0 T R) + ↑t * I) + c * deriv riemannZeta (↑(sig0 T R) + ↑t * I))
            * LevinsonMollEdge.molli (Mof T θ) (aY P T θ R) (↑(sig0 T R) + ↑t * I)‖ ^ 2 ≤
        (Dop (Real.log T) (cY P (Mof T θ) T) ((-(R / Real.log T) : ℝ) : ℂ)
          ((-(R / Real.log T) : ℝ) : ℂ)).re + ε := by
  intro ε hε
  obtain ⟨T₀, hT₀⟩ := unsmooth_near_long P hθ0 hR hMM ε hε
  refine ⟨T₀, fun T hT c hc a' b' ha1 ha2 hb1 hb2 => ?_⟩
  have e : ∀ s : ℂ, (riemannZeta s + c * deriv riemannZeta s) *
      LevinsonMollEdge.molli (Mof T θ) (aY P T θ R) s =
      Gl (Real.log T) s * psi (Mof T θ) (aY P T θ R) s := by
    intro s
    unfold Gl
    rw [hc]
    push_cast
    unfold LevinsonMollEdge.molli psi
    ring
  simp_rw [e]
  exact hT₀ T hT a' b' ha1 ha2 hb1 hb2

/-- info: 'FloorLong.pow_le_exp_long' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms pow_le_exp_long

/-- info: 'FloorLong.Ires_o_long' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Ires_o_long

/-- info: 'FloorLong.mollMean_long' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms mollMean_long

/-- info: 'FloorLong.dop_bdd_long' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms dop_bdd_long

/-- info: 'FloorLong.unsmooth_near_long' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms unsmooth_near_long

/-- info: 'FloorLong.unsmooth_near_levinson_long' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms unsmooth_near_levinson_long

end FloorLong
