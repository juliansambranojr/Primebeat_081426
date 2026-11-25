/-
# OperatorInt — block S12 of `lean_stage3/design/stencil.md`, piece 3, the operator: the mean as `D` of the moment. 2026-11-25.

The twisted moment `Imom(α,β) = ∫ w ζ(1/2+α+it) ζ(1/2+β−it) |ψ|²` is differentiated under the
integral in each variable (the integrand is holomorphic in `α` and in `β`, `w` lives on
`[T/4, 2T]`, and the derivative is bounded on a disc by compactness), and at `α = β = σ₀ − 1/2`
the mollified mean of Levinson's `G = ζ + ζ′/L` is `D` applied to `Imom`.

| name | content | status |
|---|---|---|
| `hasDerivAt_setInt` | `d/dx ∫_{[a,b]} f(x + c(t)) k(t) dt = ∫_{[a,b]} f′(x + c(t)) k(t) dt`, `f` holomorphic on an open `U` | proved |
| `Jfg` | `∫ w f(1/2+α+it) g(1/2+β−it) |ψ|²`; `Imom = Jfg ζ ζ` | defined |
| `Jfg_hasDerivAt_left`, `Jfg_hasDerivAt_right` | `∂α Jfg f g = Jfg f′ g`, `∂β Jfg f g = Jfg f g′` | proved |
| `Gl`, `mollMean` | `G(s) = ζ(s) + ζ′(s)/L`; `∫ w |G(σ₀+it)|² |ψ(σ₀+it)|²` | defined |
| `mollMean_eq` | `mean = Jζζ + (1/L)(Jζ′ζ + Jζζ′) + (1/L²) Jζ′ζ′` at `α = β = σ₀ − 1/2` | proved |
| `Imom_partials` | the partials of `Imom` that `D` and Cauchy's estimate use, on `‖α‖, ‖β‖ < 1/2` | proved |
| `Dop_Imom` | `D Imom (σ₀−1/2, σ₀−1/2) = mean` | proved |

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Stage3.TwistedMoment
import Stage3.OperatorCauchy

namespace Operator

open Complex MeasureTheory Metric Filter Topology ApproxFE TwistedMoment

/-- **Differentiation under a compact integral.** -/
theorem hasDerivAt_setInt {f : ℂ → ℂ} {U : Set ℂ} (hU : IsOpen U) (hf : DifferentiableOn ℂ f U)
    {c k : ℝ → ℂ} (hc : Continuous c) {a b : ℝ} (hk : ContinuousOn k (Set.Icc a b)) {x₀ : ℂ}
    {δ : ℝ} (hδ : 0 < δ) (hmaps : ∀ x ∈ closedBall x₀ δ, ∀ t ∈ Set.Icc a b, x + c t ∈ U) :
    HasDerivAt (fun x => ∫ t in Set.Icc a b, f (x + c t) * k t)
      (∫ t in Set.Icc a b, deriv f (x₀ + c t) * k t) x₀ := by
  have hf' : DifferentiableOn ℂ (deriv f) U := hf.deriv hU
  have hcont : ∀ (g : ℂ → ℂ), ContinuousOn g U → ∀ x ∈ closedBall x₀ δ,
      ContinuousOn (fun t => g (x + c t) * k t) (Set.Icc a b) := by
    intro g hg x hx
    refine ContinuousOn.mul ?_ hk
    exact hg.comp (by fun_prop : Continuous fun t => x + c t).continuousOn
      (fun t ht => hmaps x hx t ht)
  have hK : IsCompact (closedBall x₀ δ ×ˢ Set.Icc a b) :=
    (isCompact_closedBall x₀ δ).prod isCompact_Icc
  have hcK : ContinuousOn (fun p : ℂ × ℝ => deriv f (p.1 + c p.2) * k p.2)
      (closedBall x₀ δ ×ˢ Set.Icc a b) := by
    refine ContinuousOn.mul ?_ ?_
    · exact hf'.continuousOn.comp (by fun_prop : Continuous fun p : ℂ × ℝ => p.1 + c p.2).continuousOn
        (fun p hp => hmaps p.1 hp.1 p.2 hp.2)
    · exact hk.comp continuous_snd.continuousOn (fun p hp => hp.2)
  obtain ⟨B, hB⟩ := hK.exists_bound_of_continuousOn hcK
  have hx₀ : x₀ ∈ closedBall x₀ δ := mem_closedBall_self hδ.le
  haveI : IsFiniteMeasure (volume.restrict (Set.Icc a b)) :=
    isFiniteMeasure_restrict.mpr measure_Icc_lt_top.ne
  have key := hasDerivAt_integral_of_dominated_loc_of_deriv_le
    (μ := volume.restrict (Set.Icc a b))
    (F := fun x t => f (x + c t) * k t) (F' := fun x t => deriv f (x + c t) * k t)
    (bound := fun _ => B) (x₀ := x₀) (ball_mem_nhds x₀ hδ) ?_ ?_ ?_ ?_ ?_ ?_
  · exact key.2
  · filter_upwards [ball_mem_nhds x₀ hδ] with x hx
    exact (hcont f hf.continuousOn x (ball_subset_closedBall hx)).aestronglyMeasurable
      measurableSet_Icc
  · exact (hcont f hf.continuousOn x₀ hx₀).integrableOn_Icc
  · exact (hcont _ hf'.continuousOn x₀ hx₀).aestronglyMeasurable measurableSet_Icc
  · rw [ae_restrict_iff' measurableSet_Icc]
    exact Eventually.of_forall fun t ht x hx => hB (x, t) ⟨ball_subset_closedBall hx, ht⟩
  · exact integrable_const B
  · rw [ae_restrict_iff' measurableSet_Icc]
    refine Eventually.of_forall fun t ht x hx => ?_
    have hm := hmaps x (ball_subset_closedBall hx) t ht
    exact ((hf.differentiableAt (hU.mem_nhds hm)).hasDerivAt.comp_add_const x (c t)).mul_const (k t)

noncomputable section

/-- `J_{f,g}(α,β) = ∫ w(t) f(1/2+α+it) g(1/2+β−it) |ψ(σ₀+it)|² dt`. -/
def Jfg (f g : ℂ → ℂ) {T L : ℝ} (W : Weight T L) (M : ℕ) (a : ℕ → ℂ) (σ₀ : ℝ) (α β : ℂ) : ℂ :=
  ∫ t, (W.w t : ℂ) * (f (uA α t) * g (vB β t)) * (msq M a σ₀ t : ℂ)

/-- Levinson's `G(s) = ζ(s) + ζ′(s)/L`, i.e. `Q(−(1/L) d/ds)` with `Q(x) = 1 − x`. -/
def Gl (L : ℝ) (s : ℂ) : ℂ := riemannZeta s + deriv riemannZeta s / (L : ℂ)

/-- The mollified mean `∫ w(t) |G(σ₀+it)|² |ψ(σ₀+it)|² dt`. -/
def mollMean {T L : ℝ} (W : Weight T L) (M : ℕ) (a : ℕ → ℂ) (σ₀ L' : ℝ) : ℂ :=
  ∫ t, (W.w t : ℂ) * ((‖Gl L' ((σ₀ : ℂ) + t * I)‖ ^ 2 : ℝ) : ℂ) * (msq M a σ₀ t : ℂ)

end

section J

variable {T L : ℝ} (W : Weight T L) (M : ℕ) (a : ℕ → ℂ) (σ₀ : ℝ)

theorem Imom_eq_Jfg (α β : ℂ) :
    Imom W M a σ₀ α β = Jfg riemannZeta riemannZeta W M a σ₀ α β := rfl

theorem Jfg_set (f g : ℂ → ℂ) (α β : ℂ) :
    Jfg f g W M a σ₀ α β = ∫ t in Set.Icc (T / 4) (2 * T),
      (W.w t : ℂ) * (f (uA α t) * g (vB β t)) * (msq M a σ₀ t : ℂ) :=
  (setIntegral_eq_integral_of_forall_compl_eq_zero fun _ ht => w_zero_mul W ht _ _).symm

theorem uA_ne_one {x : ℂ} (hx : ‖x‖ < 1) {t : ℝ} (ht : 1 ≤ t) : uA x t ≠ 1 := by
  intro h
  have := congrArg Complex.im h
  simp [uA] at this
  linarith [Complex.abs_im_le_norm x, neg_abs_le x.im]

theorem vB_ne_one {y : ℂ} (hy : ‖y‖ < 1) {t : ℝ} (ht : 1 ≤ t) : vB y t ≠ 1 := by
  intro h
  have := congrArg Complex.im h
  simp [vB] at this
  linarith [Complex.abs_im_le_norm y, le_abs_self y.im]

theorem contOn_uA {f : ℂ → ℂ} (hf : ContinuousOn f {1}ᶜ) {x : ℂ} (hx : ‖x‖ < 1) (hT : 4 ≤ T) :
    ContinuousOn (fun t => f (uA x t)) (Set.Icc (T / 4) (2 * T)) :=
  hf.comp (continuous_uA x).continuousOn fun t ht =>
    Set.mem_compl_singleton_iff.mpr (uA_ne_one hx (by linarith [ht.1]))

theorem contOn_vB {f : ℂ → ℂ} (hf : ContinuousOn f {1}ᶜ) {y : ℂ} (hy : ‖y‖ < 1) (hT : 4 ≤ T) :
    ContinuousOn (fun t => f (vB y t)) (Set.Icc (T / 4) (2 * T)) :=
  hf.comp (continuous_vB y).continuousOn fun t ht =>
    Set.mem_compl_singleton_iff.mpr (vB_ne_one hy (by linarith [ht.1]))

theorem Jfg_intOn {f g : ℂ → ℂ} (hf : ContinuousOn f {1}ᶜ) (hg : ContinuousOn g {1}ᶜ) {α β : ℂ}
    (hα : ‖α‖ < 1) (hβ : ‖β‖ < 1) (hT : 4 ≤ T) :
    IntegrableOn (fun t => (W.w t : ℂ) * (f (uA α t) * g (vB β t)) * (msq M a σ₀ t : ℂ))
      (Set.Icc (T / 4) (2 * T)) := by
  refine ContinuousOn.integrableOn_Icc ?_
  refine ContinuousOn.mul (ContinuousOn.mul ?_ ?_) ?_
  · exact (Complex.continuous_ofReal.comp W.cont).continuousOn
  · exact (contOn_uA hf hα hT).mul (contOn_vB hg hβ hT)
  · exact (Complex.continuous_ofReal.comp (continuous_msq M a σ₀)).continuousOn

theorem norm_le_of_ball {x x₀ : ℂ} {δ : ℝ} (hx : x ∈ closedBall x₀ δ) : ‖x‖ ≤ ‖x₀‖ + δ := by
  have h := mem_closedBall_iff_norm.mp hx
  calc ‖x‖ = ‖(x - x₀) + x₀‖ := by rw [sub_add_cancel]
    _ ≤ ‖x - x₀‖ + ‖x₀‖ := norm_add_le _ _
    _ ≤ ‖x₀‖ + δ := by linarith

/-- **`∂α J_{f,g} = J_{f′,g}`.** -/
theorem Jfg_hasDerivAt_left {f g : ℂ → ℂ} (hf : DifferentiableOn ℂ f {1}ᶜ)
    (hg : ContinuousOn g {1}ᶜ) {x₀ β : ℂ} (hx₀ : ‖x₀‖ ≤ 1 / 2) (hβ : ‖β‖ < 1) (hT : 4 ≤ T) :
    HasDerivAt (fun x => Jfg f g W M a σ₀ x β) (Jfg (deriv f) g W M a σ₀ x₀ β) x₀ := by
  set k : ℝ → ℂ := fun t => (W.w t : ℂ) * g (vB β t) * (msq M a σ₀ t : ℂ) with hkdef
  have e : ∀ (h : ℂ → ℂ) (x : ℂ), Jfg h g W M a σ₀ x β =
      ∫ t in Set.Icc (T / 4) (2 * T), h (x + (1 / 2 + (t : ℂ) * I)) * k t := by
    intro h x
    rw [Jfg_set]
    congr 1
    funext t
    simp only [hkdef, uA]
    ring_nf
  have hk : ContinuousOn k (Set.Icc (T / 4) (2 * T)) := by
    refine ContinuousOn.mul (ContinuousOn.mul ?_ (contOn_vB hg hβ hT)) ?_
    · exact (Complex.continuous_ofReal.comp W.cont).continuousOn
    · exact (Complex.continuous_ofReal.comp (continuous_msq M a σ₀)).continuousOn
  rw [show (fun x => Jfg f g W M a σ₀ x β) = fun x =>
      ∫ t in Set.Icc (T / 4) (2 * T), f (x + (1 / 2 + (t : ℂ) * I)) * k t from funext (e f),
    e (deriv f)]
  refine hasDerivAt_setInt isOpen_compl_singleton hf (by fun_prop) hk
    (by norm_num : (0 : ℝ) < 1 / 4) fun x hx t ht => ?_
  have hxn : ‖x‖ < 1 := by linarith [norm_le_of_ball hx]
  have h := uA_ne_one hxn (t := t) (by linarith [ht.1])
  refine Set.mem_compl_singleton_iff.mpr ?_
  rw [show x + (1 / 2 + (t : ℂ) * I) = uA x t by simp only [uA]; ring]
  exact h

/-- **`∂β J_{f,g} = J_{f,g′}`.** -/
theorem Jfg_hasDerivAt_right {f g : ℂ → ℂ} (hf : ContinuousOn f {1}ᶜ)
    (hg : DifferentiableOn ℂ g {1}ᶜ) {α y₀ : ℂ} (hα : ‖α‖ < 1) (hy₀ : ‖y₀‖ ≤ 1 / 2) (hT : 4 ≤ T) :
    HasDerivAt (fun y => Jfg f g W M a σ₀ α y) (Jfg f (deriv g) W M a σ₀ α y₀) y₀ := by
  set k : ℝ → ℂ := fun t => (W.w t : ℂ) * f (uA α t) * (msq M a σ₀ t : ℂ) with hkdef
  have e : ∀ (h : ℂ → ℂ) (y : ℂ), Jfg f h W M a σ₀ α y =
      ∫ t in Set.Icc (T / 4) (2 * T), h (y + (1 / 2 - (t : ℂ) * I)) * k t := by
    intro h y
    rw [Jfg_set]
    congr 1
    funext t
    simp only [hkdef, vB]
    ring_nf
  have hk : ContinuousOn k (Set.Icc (T / 4) (2 * T)) := by
    refine ContinuousOn.mul (ContinuousOn.mul ?_ (contOn_uA hf hα hT)) ?_
    · exact (Complex.continuous_ofReal.comp W.cont).continuousOn
    · exact (Complex.continuous_ofReal.comp (continuous_msq M a σ₀)).continuousOn
  rw [show (fun y => Jfg f g W M a σ₀ α y) = fun y =>
      ∫ t in Set.Icc (T / 4) (2 * T), g (y + (1 / 2 - (t : ℂ) * I)) * k t from funext (e g),
    e (deriv g)]
  refine hasDerivAt_setInt isOpen_compl_singleton hg (by fun_prop) hk
    (by norm_num : (0 : ℝ) < 1 / 4) fun y hy t ht => ?_
  have hyn : ‖y‖ < 1 := by linarith [norm_le_of_ball hy]
  have h := vB_ne_one hyn (t := t) (by linarith [ht.1])
  refine Set.mem_compl_singleton_iff.mpr ?_
  rw [show y + (1 / 2 - (t : ℂ) * I) = vB y t by simp only [vB]; ring]
  exact h

end J

theorem zeta_diffOn : DifferentiableOn ℂ riemannZeta {1}ᶜ := fun _ hz =>
  (differentiableAt_riemannZeta (Set.mem_compl_singleton_iff.mp hz)).differentiableWithinAt

theorem dzeta_diffOn : DifferentiableOn ℂ (deriv riemannZeta) {1}ᶜ :=
  zeta_diffOn.deriv isOpen_compl_singleton

/-- `ζ′(s̄) = conj ζ′(s)`. -/
theorem deriv_zeta_conj (s : ℂ) :
    deriv riemannZeta ((starRingEnd ℂ) s) = (starRingEnd ℂ) (deriv riemannZeta s) := by
  have h1 : ((starRingEnd ℂ) ∘ riemannZeta ∘ (starRingEnd ℂ)) = riemannZeta := by
    funext z
    simp [riemannZeta_conj]
  have h2 := deriv_conj_conj (f := riemannZeta)
  rw [h1] at h2
  have := congrFun h2 ((starRingEnd ℂ) s)
  simpa using this

section Mean

variable {T L : ℝ} (W : Weight T L) (M : ℕ) (a : ℕ → ℂ) (σ₀ : ℝ)

/-- **The mean, expanded**: at `α = β = σ₀ − 1/2`,
`∫ w |G|² |ψ|² = Jζζ + (1/L)(Jζ′ζ + Jζζ′) + (1/L²) Jζ′ζ′`. -/
theorem mollMean_eq (L' : ℝ) (hT : 4 ≤ T) (hσ : ‖(((σ₀ - 1 / 2 : ℝ)) : ℂ)‖ < 1) :
    mollMean W M a σ₀ L' =
      Jfg riemannZeta riemannZeta W M a σ₀ ((σ₀ - 1 / 2 : ℝ) : ℂ) ((σ₀ - 1 / 2 : ℝ) : ℂ) +
        1 / (L' : ℂ) * (Jfg (deriv riemannZeta) riemannZeta W M a σ₀ ((σ₀ - 1 / 2 : ℝ) : ℂ)
            ((σ₀ - 1 / 2 : ℝ) : ℂ) +
          Jfg riemannZeta (deriv riemannZeta) W M a σ₀ ((σ₀ - 1 / 2 : ℝ) : ℂ)
            ((σ₀ - 1 / 2 : ℝ) : ℂ)) +
        1 / (L' : ℂ) ^ 2 * Jfg (deriv riemannZeta) (deriv riemannZeta) W M a σ₀
          ((σ₀ - 1 / 2 : ℝ) : ℂ) ((σ₀ - 1 / 2 : ℝ) : ℂ) := by
  set α₀ : ℂ := ((σ₀ - 1 / 2 : ℝ) : ℂ) with hα₀
  set Z := riemannZeta
  set Z' := deriv riemannZeta
  set m : ℝ → ℂ := fun t => (msq M a σ₀ t : ℂ) with hm
  set ww : ℝ → ℂ := fun t => (W.w t : ℂ) with hww
  have hu : ∀ t : ℝ, (σ₀ : ℂ) + t * I = uA α₀ t := by
    intro t
    simp only [uA, hα₀]
    push_cast
    ring
  have hv : ∀ t : ℝ, (starRingEnd ℂ) (uA α₀ t) = vB α₀ t := by
    intro t
    simp only [uA, vB, hα₀, map_add, map_mul, map_div₀, map_one, map_ofNat, Complex.conj_ofReal,
      Complex.conj_I]
    ring
  have hpt : ∀ t : ℝ, ww t * ((‖Gl L' ((σ₀ : ℂ) + t * I)‖ ^ 2 : ℝ) : ℂ) * m t =
      ww t * (Z (uA α₀ t) * Z (vB α₀ t)) * m t +
        1 / (L' : ℂ) * (ww t * (Z' (uA α₀ t) * Z (vB α₀ t)) * m t) +
        1 / (L' : ℂ) * (ww t * (Z (uA α₀ t) * Z' (vB α₀ t)) * m t) +
        1 / (L' : ℂ) ^ 2 * (ww t * (Z' (uA α₀ t) * Z' (vB α₀ t)) * m t) := by
    intro t
    have hG : ((‖Gl L' ((σ₀ : ℂ) + t * I)‖ ^ 2 : ℝ) : ℂ) =
        Gl L' (uA α₀ t) * (starRingEnd ℂ) (Gl L' (uA α₀ t)) := by
      rw [Complex.mul_conj, Complex.normSq_eq_norm_sq, hu]
    have hc : (starRingEnd ℂ) (Gl L' (uA α₀ t)) = Z (vB α₀ t) + Z' (vB α₀ t) / (L' : ℂ) := by
      simp only [Gl, map_add, map_div₀, Complex.conj_ofReal]
      rw [← riemannZeta_conj, ← deriv_zeta_conj, hv]
    rw [hG, hc]
    simp only [Gl]
    ring
  have hα1 : ‖α₀‖ < 1 := hσ
  have i1 := Jfg_intOn W M a σ₀ zeta_diffOn.continuousOn zeta_diffOn.continuousOn hα1 hα1 hT
  have i2 := Jfg_intOn W M a σ₀ dzeta_diffOn.continuousOn zeta_diffOn.continuousOn hα1 hα1 hT
  have i3 := Jfg_intOn W M a σ₀ zeta_diffOn.continuousOn dzeta_diffOn.continuousOn hα1 hα1 hT
  have i4 := Jfg_intOn W M a σ₀ dzeta_diffOn.continuousOn dzeta_diffOn.continuousOn hα1 hα1 hT
  have j1 : Integrable (fun t => ww t * (Z (uA α₀ t) * Z (vB α₀ t)) * m t)
      (volume.restrict (Set.Icc (T / 4) (2 * T))) := i1
  have j2 : Integrable (fun t => ww t * (Z' (uA α₀ t) * Z (vB α₀ t)) * m t)
      (volume.restrict (Set.Icc (T / 4) (2 * T))) := i2
  have j3 : Integrable (fun t => ww t * (Z (uA α₀ t) * Z' (vB α₀ t)) * m t)
      (volume.restrict (Set.Icc (T / 4) (2 * T))) := i3
  have j4 : Integrable (fun t => ww t * (Z' (uA α₀ t) * Z' (vB α₀ t)) * m t)
      (volume.restrict (Set.Icc (T / 4) (2 * T))) := i4
  have hset : mollMean W M a σ₀ L' = ∫ t in Set.Icc (T / 4) (2 * T),
      (ww t * (Z (uA α₀ t) * Z (vB α₀ t)) * m t +
        1 / (L' : ℂ) * (ww t * (Z' (uA α₀ t) * Z (vB α₀ t)) * m t) +
        1 / (L' : ℂ) * (ww t * (Z (uA α₀ t) * Z' (vB α₀ t)) * m t) +
        1 / (L' : ℂ) ^ 2 * (ww t * (Z' (uA α₀ t) * Z' (vB α₀ t)) * m t)) := by
    unfold mollMean
    rw [← setIntegral_eq_integral_of_forall_compl_eq_zero (s := Set.Icc (T / 4) (2 * T))
      (fun t ht => w_zero_mul W ht _ _)]
    congr 1
    funext t
    exact hpt t
  rw [hset, integral_add, integral_add, integral_add,
    integral_const_mul, integral_const_mul, integral_const_mul,
    Jfg_set, Jfg_set, Jfg_set, Jfg_set]
  · ring
  all_goals first
    | exact j1 | exact j2.const_mul _ | exact j3.const_mul _ | exact j4.const_mul _
    | exact j1.add (j2.const_mul _) | exact (j1.add (j2.const_mul _)).add (j3.const_mul _)

/-- **The partials of `Imom`** on `‖α‖, ‖β‖ < 1/2`. -/
theorem Imom_partials (hT : 4 ≤ T) {x y : ℂ} (hx : ‖x‖ < 1 / 2) (hy : ‖y‖ < 1 / 2) :
    DifferentiableAt ℂ (fun x => Imom W M a σ₀ x y) x ∧
      DifferentiableAt ℂ (fun y => Imom W M a σ₀ x y) y ∧
      pa (Imom W M a σ₀) x y = Jfg (deriv riemannZeta) riemannZeta W M a σ₀ x y ∧
      pb (Imom W M a σ₀) x y = Jfg riemannZeta (deriv riemannZeta) W M a σ₀ x y ∧
      DifferentiableAt ℂ (fun y => pa (Imom W M a σ₀) x y) y ∧
      pab (Imom W M a σ₀) x y = Jfg (deriv riemannZeta) (deriv riemannZeta) W M a σ₀ x y := by
  have hx1 : ‖x‖ ≤ 1 / 2 := hx.le
  have hy1 : ‖y‖ ≤ 1 / 2 := hy.le
  have hxl : ‖x‖ < 1 := by linarith
  have hyl : ‖y‖ < 1 := by linarith
  have hA := Jfg_hasDerivAt_left W M a σ₀ zeta_diffOn zeta_diffOn.continuousOn hx1 hyl hT
  have hB := Jfg_hasDerivAt_right W M a σ₀ zeta_diffOn.continuousOn zeta_diffOn hxl hy1 hT
  have hev : (fun y' => pa (Imom W M a σ₀) x y') =ᶠ[𝓝 y]
      fun y' => Jfg (deriv riemannZeta) riemannZeta W M a σ₀ x y' := by
    have hball : ball (0 : ℂ) (1 / 2) ∈ 𝓝 y := isOpen_ball.mem_nhds (by simpa using hy)
    filter_upwards [hball] with y' hy'
    have hy'1 : ‖y'‖ < 1 := by
      have := mem_ball_zero_iff.mp hy'
      linarith
    exact (Jfg_hasDerivAt_left W M a σ₀ zeta_diffOn zeta_diffOn.continuousOn hx1 hy'1 hT).deriv
  have hC := Jfg_hasDerivAt_right W M a σ₀ dzeta_diffOn.continuousOn zeta_diffOn hxl hy1 hT
  refine ⟨hA.differentiableAt, hB.differentiableAt, hA.deriv, hB.deriv,
    hC.differentiableAt.congr_of_eventuallyEq hev, ?_⟩
  show deriv (fun y' => pa (Imom W M a σ₀) x y') y = _
  rw [hev.deriv_eq]
  exact hC.deriv

/-- **`D` of the moment is the mean**: at `α₀ = σ₀ − 1/2`, `‖α₀‖ < 1/2`,
`D Imom (α₀, α₀) = ∫ w |G(σ₀+it)|² |ψ(σ₀+it)|²`. -/
theorem Dop_Imom (L' : ℝ) (hT : 4 ≤ T) (hσ : ‖(((σ₀ - 1 / 2 : ℝ)) : ℂ)‖ < 1 / 2) :
    Dop L' (Imom W M a σ₀) ((σ₀ - 1 / 2 : ℝ) : ℂ) ((σ₀ - 1 / 2 : ℝ) : ℂ) =
      mollMean W M a σ₀ L' := by
  obtain ⟨-, -, h1, h2, -, h3⟩ := Imom_partials W M a σ₀ hT hσ hσ
  rw [mollMean_eq W M a σ₀ L' hT (by linarith), Dop, h1, h2, h3]
  rfl

end Mean

/-- info: 'Operator.hasDerivAt_setInt' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms hasDerivAt_setInt

/-- info: 'Operator.mollMean_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms mollMean_eq

/-- info: 'Operator.Imom_partials' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Imom_partials

/-- info: 'Operator.Dop_Imom' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Dop_Imom

end Operator
