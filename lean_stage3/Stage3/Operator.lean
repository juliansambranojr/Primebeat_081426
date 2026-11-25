/-
# Operator — block S12 of `lean_stage3/design/stencil.md`, piece 3, the operator: the mollified mean of Levinson's `G`. 2026-11-25.

Young (arXiv 1002.4403) §3, the step from Lemma 3 to the mollified mean, with Levinson's
`Q(x) = 1 − x`. With `L = log T`, `σ₀ = 1/2 − R/L` (`sig0`), `M = ⌊T^θ⌋` (`Mof`), Young's
mollifier `a = aY P T θ R` and `G(s) = ζ(s) + ζ′(s)/L` (`Gl`):
`∫ w(t) |G(σ₀+it)|² |ψ(σ₀+it)|² dt = D[c](−R/L, −R/L) ŵ(0) + o(T)`,
`D f = f + (1/L)(∂α f + ∂β f) + (1/L²) ∂α∂β f` (`Dop`), `c = cY P M T`, uniformly over
`WeightAll T L` with `C_j ≤ Cs j`, the class `Lemma3.lemma3_resO_holds` is over.

| name | content | status |
|---|---|---|
| `StmtMollMeanO` | the mean is `D[c]·ŵ(0) + o(T)`: `‖mean − D[c]·ŵ(0)‖ ≤ ε·errO W` from some height on | defined |
| `Ires_o` | `‖I_res‖ ≤ ε T` on `Regime κ T` from some height on (`Ires_small`, `aY_bound`) | proved |
| `stmtMollMeanO_holds` | `StmtMollMeanO P θ R` for `P(0) = 0`, `0 < θ < 1/2`, `R > 0` | proved |

The route. (1) At `α = β = −R/L`, `ζ(1/2+α+it) = ζ(σ₀+it)` and `ζ(1/2+β−it) = conj ζ(σ₀+it)`,
so the mean is `D` applied to `Imom` (`OperatorInt.Dop_Imom`, differentiating under the
integral). (2) `D` is linear (`Dop_sub_mul`), so `mean − D[c] ŵ(0) = D[Imom − c ŵ(0)]`; `c` is
analytic off `α + β = 0` (`OperatorCY.cY_partials`). (3) Cauchy's estimate on the polydisc of
radius `ρ = r/L`, `r = R/2`, one variable at a time (`Dop_norm_le`), gives
`‖D f‖ ≤ (1 + 2/r + 1/r²) sup |f|`; the polydisc lies in `Regime κ T` with
`κ = 2R + 1 + 1/R` (`|α| ≤ 3R/(2L)`, `|α + β| ≥ R/L`), where Lemma 3 gives
`sup |f| ≤ ε·errO + sup ‖I_res‖ ≤ 2ε·errO`.

The size, checked before the proof: `(1/L)·(1/ρ) = 1/r` and `(1/L²)·(1/ρ²) = 1/r²` are
constants, so no factor of `L` is lost and the `o(T)` of Lemma 3 survives. `I_res` is
`≪ (1 + κ²T²)(BT)² T e^(−T²/32)`, far below `εT`.

Differences from Young. (i) `D[c]` is kept as the derivative expression; the closed form
`c(P,Q,R,θ)` (Young's (1.3)) is not derived here. (ii) The mean is `∫ w |G|² |ψ|²` with `ψ` at
`σ₀` (`msq`), Young's `|Vψ|²` with `V = G`; it is written in `ℂ` as `Imom` is.

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Stage3.Lemma3
import Stage3.OperatorCY
import Stage3.OperatorInt

namespace Operator

open Complex Metric Filter Topology ApproxFE TwistedMoment DiagMainStmt DiagonalO OffDiagClose

/-- **The mollified mean at `o(T)`**: for every family `Cs` and `ε > 0`, from some height on,
uniformly over `WeightAll T (log T)` with `C_j ≤ Cs j`,
`‖∫ w |G(σ₀+it)|² |ψ(σ₀+it)|² − D[c](−R/L, −R/L) ŵ(0)‖ ≤ ε·errO W`. -/
noncomputable
def StmtMollMeanO (P : Polynomial ℝ) (θ R : ℝ) : Prop :=
  ∀ Cs : ℕ → ℝ, ∀ ε : ℝ, 0 < ε → ∃ T₀ : ℝ, ∀ T : ℝ, T₀ ≤ T →
    ∀ W : WeightAll T (Real.log T), (∀ j, W.Cj j ≤ Cs j) →
      ‖mollMean W.toWeight (Mof T θ) (aY P T θ R) (sig0 T R) (Real.log T) -
          Dop (Real.log T) (cY P (Mof T θ) T) ((-(R / Real.log T) : ℝ) : ℂ)
              ((-(R / Real.log T) : ℝ) : ℂ) * (what0 W.toWeight : ℂ)‖ ≤
        ε * errO W.toWeight

/-- `T⁶ ≤ 196608 e^(T²/32)`, from `x³/3! ≤ eˣ`. -/
theorem pow_six_le_exp (T : ℝ) : T ^ 6 ≤ 196608 * Real.exp (T ^ 2 / 32) := by
  have h := Real.pow_div_factorial_le_exp (T ^ 2 / 32) (by positivity) 3
  have e : (T ^ 2 / 32) ^ 3 / (Nat.factorial 3 : ℝ) = T ^ 6 / 196608 := by
    norm_num [Nat.factorial]
    ring
  rw [e] at h
  linarith

/-- **The remainder is `o(T)`**, uniformly on `Regime κ T`. -/
theorem Ires_o (P : Polynomial ℝ) {θ : ℝ} (hθ1 : θ ≤ 1) (R : ℝ) {κ : ℝ} (hκ : 0 < κ) :
    ∀ ε : ℝ, 0 < ε → ∃ T₀ : ℝ, ∀ T : ℝ, T₀ ≤ T → ∀ W : Weight T (Real.log T), ∀ α β : ℂ,
      Regime κ T α β → ‖Ires W (Mof T θ) (aY P T θ R) (sig0 T R) α β‖ ≤ ε * T := by
  intro ε hε
  obtain ⟨C, hC0, hC⟩ := Ires_small
  obtain ⟨B, hB0, hB⟩ := aY_bound P
  set K' : ℝ := C * (1 + κ ^ 2) * B ^ 2 with hK'
  have hK'0 : 0 ≤ K' := by positivity
  refine ⟨max (max 4 (Real.exp (10 * κ))) (K' * 196608 / ε + 1),
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
  have hM : (Mof T θ : ℝ) ≤ T := by
    have h1 : (Mof T θ : ℝ) ≤ T ^ θ := Nat.floor_le (by positivity)
    have h2 : T ^ θ ≤ T ^ (1 : ℝ) := Real.rpow_le_rpow_of_exponent_le hT1 hθ1
    rw [Real.rpow_one] at h2
    linarith
  have hSψb : Sψ ≤ B * T := by
    have h1 : Sψ ≤ (Finset.Icc 1 (Mof T θ)).card • B :=
      Finset.sum_le_card_nsmul _ _ _ fun h hh =>
        hB T θ R h (Finset.mem_Icc.mp hh).1 (Finset.mem_Icc.mp hh).2
    rw [Nat.card_Icc, nsmul_eq_mul, Nat.add_sub_cancel] at h1
    calc Sψ ≤ (Mof T θ : ℝ) * B := h1
      _ ≤ T * B := mul_le_mul_of_nonneg_right hM hB0
      _ = B * T := by ring
  set E : ℝ := Real.exp (-(T ^ 2 / 32)) with hE
  have hE0 : 0 ≤ E := (Real.exp_pos _).le
  have hE6 : T ^ 6 * E ≤ 196608 := by
    have h1 := pow_six_le_exp T
    have h2 : E * Real.exp (T ^ 2 / 32) = 1 := by
      rw [hE, ← Real.exp_add]
      simp
    nlinarith [Real.exp_pos (T ^ 2 / 32)]
  have hbig : ‖Ires W (Mof T θ) (aY P T θ R) (sig0 T R) α β‖ ≤ K' * T ^ 5 * E := by
    refine h.trans ?_
    have hN0 : 0 ≤ 1 + 1 / ‖α + β‖ ^ 2 := by positivity
    have hsq : Sψ ^ 2 ≤ (B * T) ^ 2 := pow_le_pow_left₀ hSψ0 hSψb 2
    calc C * (1 + 1 / ‖α + β‖ ^ 2) * Sψ ^ 2 * T * E
        ≤ C * ((1 + κ ^ 2) * T ^ 2) * (B * T) ^ 2 * T * E := by
          have a1 : C * (1 + 1 / ‖α + β‖ ^ 2) ≤ C * ((1 + κ ^ 2) * T ^ 2) :=
            mul_le_mul_of_nonneg_left hN hC0
          have a2 : C * (1 + 1 / ‖α + β‖ ^ 2) * Sψ ^ 2 ≤
              C * ((1 + κ ^ 2) * T ^ 2) * (B * T) ^ 2 :=
            mul_le_mul a1 hsq (by positivity) (by positivity)
          have a3 := mul_le_mul_of_nonneg_right a2 hT0.le
          exact mul_le_mul_of_nonneg_right a3 hE0
      _ = K' * T ^ 5 * E := by rw [hK']; ring
  have hKT : K' * 196608 ≤ ε * T := by
    have : K' * 196608 / ε ≤ T := by linarith
    rwa [div_le_iff₀ hε, mul_comm T] at this
  have hfin : K' * T ^ 5 * E * T ≤ ε * T * T := by
    calc K' * T ^ 5 * E * T = K' * (T ^ 6 * E) := by ring
      _ ≤ K' * 196608 := mul_le_mul_of_nonneg_left hE6 hK'0
      _ ≤ ε * T := hKT
      _ ≤ ε * T * T := le_mul_of_one_le_right (by positivity) hT1
  exact hbig.trans (le_of_mul_le_mul_right hfin hT0)

/-- **The mollified mean of Levinson's `G`, `o(T)`, unconditional**: Lemma 3 at `o(T)` and
Cauchy's estimate on circles of radius `R/(2L)`. -/
theorem stmtMollMeanO_holds (P : Polynomial ℝ) (hP0 : P.eval 0 = 0) {θ : ℝ} (hθ0 : 0 < θ)
    (hθ : θ < 1 / 2) {R : ℝ} (hR : 0 < R) : StmtMollMeanO P θ R := by
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
  obtain ⟨T1, hT1⟩ := Lemma3.lemma3_resO_holds P hP0 hθ0 hθ R hκ Cs ε₁ hε₁
  obtain ⟨T2, hT2⟩ := Ires_o P (by linarith : θ ≤ 1) R hκ ε₁ hε₁
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

/-- info: 'Operator.Ires_o' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Ires_o

/-- info: 'Operator.stmtMollMeanO_holds' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms stmtMollMeanO_holds

end Operator
