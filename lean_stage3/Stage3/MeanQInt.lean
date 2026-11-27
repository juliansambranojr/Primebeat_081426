/-
MeanQInt — block S13 of `lean_stage3/design/stencil.md`, B4 step 3, the mean value with a
general Q: the mean of `|Q(−D/L)ζ·ψ|²` as `DopQ` of the twisted moment. 2026-11-25.

`OperatorInt` differentiates `Imom` once in each variable. Here every order:
`∂β^l ∂α^k Imom = J_{ζ^{(k)}, ζ^{(l)}}` on `‖α‖, ‖β‖ < 1/2` (`pkl_Imom`), by induction on
`OperatorInt.Jfg_hasDerivAt_left`/`_right` with `ζ^{(k)}` holomorphic on `ℂ ∖ {1}`. With
`ζ^{(l)}(s̄) = conj ζ^{(l)}(s)` (`iteratedDeriv_zeta_conj`) the mean of `|VQ ψ|²` at
`σ₀ = 1/2 + α₀` is `Σ_{k,l} q_k q_l (−1/L)^{k+l} J_{ζ^{(k)}, ζ^{(l)}}(α₀, α₀)` (`mollMeanQ_eq`),
which is `DopQ Imom (α₀, α₀)` (`DopQ_Imom`). The slices of `Imom` and of `cY` are analytic
(`Imom_slices`, `cY_slices`), which is what `MeanQCauchy.DopQ_sub_mul` asks.

  | name                     | statement                                                  | status |
  |--------------------------|------------------------------------------------------------|--------|
  | `iteratedDeriv_zeta_conj`| `ζ^{(k)}(s̄) = conj ζ^{(k)}(s)`                              | PROVED |
  | `Jfg_iter_left/right`    | `∂α^k J_{f,g} = J_{f^{(k)},g}`, `∂β^l J_{f,g} = J_{f,g^{(l)}}` | PROVED |
  | `pkl_Imom`               | `pkl Imom k l = J_{ζ^{(k)}, ζ^{(l)}}`, `‖α‖, ‖β‖ < 1/2`     | PROVED |
  | `Imom_slices`            | the slices of `Imom` and their `∂α^k` are analytic          | PROVED |
  | `cY_slices`              | the same for `cY` at `α + β ≠ 0`                            | PROVED |
  | `mollMeanQ`, `mollMeanQ_eq` | `∫ w |VQ|² |ψ|²` and its expansion                       | PROVED |
  | `DopQ_Imom`              | `DopQ Imom (α₀, α₀) = mollMeanQ`                            | PROVED |

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.MeanQRed
import Stage3.MeanQCauchy
import Stage3.OperatorInt
import Stage3.OperatorCY

noncomputable section

namespace MeanQ

open Complex Polynomial MeasureTheory Metric Filter Topology ApproxFE TwistedMoment Operator

/-! ### `ζ^{(k)}` -/

theorem zetaK_analyticOnNhd (k : ℕ) : AnalyticOnNhd ℂ (iteratedDeriv k riemannZeta) {1}ᶜ := by
  rw [iteratedDeriv_eq_iterate]
  exact (zeta_diffOn.analyticOnNhd isOpen_compl_singleton).iterated_deriv k

theorem zetaK_diffOn (k : ℕ) : DifferentiableOn ℂ (iteratedDeriv k riemannZeta) {1}ᶜ :=
  fun z hz => ((zetaK_analyticOnNhd k) z hz).differentiableAt.differentiableWithinAt

/-- `ζ^{(k)}(s̄) = conj ζ^{(k)}(s)`, as functions. -/
theorem zetaK_conj_fun (k : ℕ) :
    (starRingEnd ℂ) ∘ iteratedDeriv k riemannZeta ∘ (starRingEnd ℂ) =
      iteratedDeriv k riemannZeta := by
  induction k with
  | zero =>
    funext z
    simp [riemannZeta_conj]
  | succ k ih =>
    rw [iteratedDeriv_succ]
    have h := deriv_conj_conj (f := iteratedDeriv k riemannZeta)
    rw [ih] at h
    funext z
    have := congrFun h ((starRingEnd ℂ) z)
    simp only [Function.comp_apply, Complex.conj_conj] at this
    simp only [Function.comp_apply]
    rw [this, Complex.conj_conj]

/-- **`ζ^{(k)}(s̄) = conj ζ^{(k)}(s)`.** -/
theorem iteratedDeriv_zeta_conj (k : ℕ) (s : ℂ) :
    iteratedDeriv k riemannZeta ((starRingEnd ℂ) s) =
      (starRingEnd ℂ) (iteratedDeriv k riemannZeta s) := by
  have h := congrFun (zetaK_conj_fun k) s
  simp only [Function.comp_apply] at h
  rw [← h, Complex.conj_conj]

/-! ### The partials of `J_{f,g}` of every order -/

section J

variable {T L : ℝ} (W : Weight T L) (M : ℕ) (a : ℕ → ℂ) (σ₀ : ℝ)

/-- **`∂α^k J_{f,g} = J_{f^{(k)},g}`** on `‖x‖ < 1/2`, `‖y‖ < 1`. -/
theorem Jfg_iter_left {f g : ℂ → ℂ} (hf : AnalyticOnNhd ℂ f {1}ᶜ) (hg : ContinuousOn g {1}ᶜ)
    (hT : 4 ≤ T) {y : ℂ} (hy : ‖y‖ < 1) (k : ℕ) :
    ∀ x : ℂ, ‖x‖ < 1 / 2 →
      iteratedDeriv k (fun x => Jfg f g W M a σ₀ x y) x =
        Jfg (iteratedDeriv k f) g W M a σ₀ x y := by
  induction k with
  | zero => intro x _; simp
  | succ k ih =>
    intro x hx
    have hfk : DifferentiableOn ℂ (iteratedDeriv k f) {1}ᶜ := by
      rw [iteratedDeriv_eq_iterate]
      exact fun z hz => ((hf.iterated_deriv k) z hz).differentiableAt.differentiableWithinAt
    have hev : iteratedDeriv k (fun x => Jfg f g W M a σ₀ x y) =ᶠ[𝓝 x]
        fun x => Jfg (iteratedDeriv k f) g W M a σ₀ x y := by
      have hball : ball (0 : ℂ) (1 / 2) ∈ 𝓝 x := isOpen_ball.mem_nhds (by simpa using hx)
      filter_upwards [hball] with x' hx'
      exact ih x' (by simpa using hx')
    rw [iteratedDeriv_succ, hev.deriv_eq,
      (Jfg_hasDerivAt_left W M a σ₀ hfk hg hx.le hy hT).deriv, iteratedDeriv_succ]

/-- **`∂β^l J_{f,g} = J_{f,g^{(l)}}`** on `‖x‖ < 1`, `‖y‖ < 1/2`. -/
theorem Jfg_iter_right {f g : ℂ → ℂ} (hf : ContinuousOn f {1}ᶜ) (hg : AnalyticOnNhd ℂ g {1}ᶜ)
    (hT : 4 ≤ T) {x : ℂ} (hx : ‖x‖ < 1) (l : ℕ) :
    ∀ y : ℂ, ‖y‖ < 1 / 2 →
      iteratedDeriv l (fun y => Jfg f g W M a σ₀ x y) y =
        Jfg f (iteratedDeriv l g) W M a σ₀ x y := by
  induction l with
  | zero => intro y _; simp
  | succ l ih =>
    intro y hy
    have hgl : DifferentiableOn ℂ (iteratedDeriv l g) {1}ᶜ := by
      rw [iteratedDeriv_eq_iterate]
      exact fun z hz => ((hg.iterated_deriv l) z hz).differentiableAt.differentiableWithinAt
    have hev : iteratedDeriv l (fun y => Jfg f g W M a σ₀ x y) =ᶠ[𝓝 y]
        fun y => Jfg f (iteratedDeriv l g) W M a σ₀ x y := by
      have hball : ball (0 : ℂ) (1 / 2) ∈ 𝓝 y := isOpen_ball.mem_nhds (by simpa using hy)
      filter_upwards [hball] with y' hy'
      exact ih y' (by simpa using hy')
    rw [iteratedDeriv_succ, hev.deriv_eq,
      (Jfg_hasDerivAt_right W M a σ₀ hf hgl hx hy.le hT).deriv, iteratedDeriv_succ]

/-- `x ↦ J_{f,g}(x, y)` is analytic on `‖x‖ < 1/2`. -/
theorem Jfg_analytic_left {f g : ℂ → ℂ} (hf : AnalyticOnNhd ℂ f {1}ᶜ)
    (hg : ContinuousOn g {1}ᶜ) (hT : 4 ≤ T) {x y : ℂ} (hx : ‖x‖ < 1 / 2) (hy : ‖y‖ < 1) :
    AnalyticAt ℂ (fun x => Jfg f g W M a σ₀ x y) x := by
  have hfd : DifferentiableOn ℂ f {1}ᶜ :=
    fun z hz => (hf z hz).differentiableAt.differentiableWithinAt
  have hd : DifferentiableOn ℂ (fun x => Jfg f g W M a σ₀ x y) (ball 0 (1 / 2)) := by
    intro x' hx'
    have hx'' : ‖x'‖ < 1 / 2 := by simpa using hx'
    exact (Jfg_hasDerivAt_left W M a σ₀ hfd hg hx''.le hy hT).differentiableAt.differentiableWithinAt
  exact hd.analyticAt (isOpen_ball.mem_nhds (by simpa using hx))

/-- `y ↦ J_{f,g}(x, y)` is analytic on `‖y‖ < 1/2`. -/
theorem Jfg_analytic_right {f g : ℂ → ℂ} (hf : ContinuousOn f {1}ᶜ)
    (hg : AnalyticOnNhd ℂ g {1}ᶜ) (hT : 4 ≤ T) {x y : ℂ} (hx : ‖x‖ < 1) (hy : ‖y‖ < 1 / 2) :
    AnalyticAt ℂ (fun y => Jfg f g W M a σ₀ x y) y := by
  have hgd : DifferentiableOn ℂ g {1}ᶜ :=
    fun z hz => (hg z hz).differentiableAt.differentiableWithinAt
  have hd : DifferentiableOn ℂ (fun y => Jfg f g W M a σ₀ x y) (ball 0 (1 / 2)) := by
    intro y' hy'
    have hy'' : ‖y'‖ < 1 / 2 := by simpa using hy'
    exact (Jfg_hasDerivAt_right W M a σ₀ hf hgd hx hy''.le hT).differentiableAt.differentiableWithinAt
  exact hd.analyticAt (isOpen_ball.mem_nhds (by simpa using hy))

/-- `∂α^k Imom(x, ·) = J_{ζ^{(k)}, ζ}(x, ·)` near `y`. -/
theorem Imom_iter_left_ev (hT : 4 ≤ T) (k : ℕ) {x y : ℂ} (hx : ‖x‖ < 1 / 2) (hy : ‖y‖ < 1 / 2) :
    (fun y => iteratedDeriv k (fun x => Imom W M a σ₀ x y) x) =ᶠ[𝓝 y]
      fun y => Jfg (iteratedDeriv k riemannZeta) riemannZeta W M a σ₀ x y := by
  have hball : ball (0 : ℂ) (1 / 2) ∈ 𝓝 y := isOpen_ball.mem_nhds (by simpa using hy)
  filter_upwards [hball] with y' hy'
  have hy'1 : ‖y'‖ < 1 := by
    have := mem_ball_zero_iff.mp hy'
    linarith
  exact Jfg_iter_left W M a σ₀ (zetaK_analyticOnNhd 0 |>.congr isOpen_compl_singleton
    (fun z _ => by simp)) zeta_diffOn.continuousOn hT hy'1 k x hx

/-- **The partials of the moment, every order**: `pkl Imom k l = J_{ζ^{(k)}, ζ^{(l)}}`. -/
theorem pkl_Imom (hT : 4 ≤ T) (k l : ℕ) {x y : ℂ} (hx : ‖x‖ < 1 / 2) (hy : ‖y‖ < 1 / 2) :
    pkl (Imom W M a σ₀) k l x y =
      Jfg (iteratedDeriv k riemannZeta) (iteratedDeriv l riemannZeta) W M a σ₀ x y := by
  unfold pkl
  rw [(Imom_iter_left_ev W M a σ₀ hT k hx hy).iteratedDeriv_eq l]
  have hx1 : ‖x‖ < 1 := by linarith
  have hz : AnalyticOnNhd ℂ riemannZeta {1}ᶜ := zeta_diffOn.analyticOnNhd isOpen_compl_singleton
  exact Jfg_iter_right W M a σ₀ (zetaK_diffOn k).continuousOn hz hT hx1 l y hy

/-- **The slices of the moment are analytic**, on `‖x‖, ‖y‖ < 1/2`. -/
theorem Imom_slices (hT : 4 ≤ T) {x y : ℂ} (hx : ‖x‖ < 1 / 2) (hy : ‖y‖ < 1 / 2) :
    AnalyticAt ℂ (fun x => Imom W M a σ₀ x y) x ∧
      ∀ k, AnalyticAt ℂ (fun y => iteratedDeriv k (fun x => Imom W M a σ₀ x y) x) y := by
  have hz : AnalyticOnNhd ℂ riemannZeta {1}ᶜ := zeta_diffOn.analyticOnNhd isOpen_compl_singleton
  have hy1 : ‖y‖ < 1 := by linarith
  have hx1 : ‖x‖ < 1 := by linarith
  refine ⟨Jfg_analytic_left W M a σ₀ hz zeta_diffOn.continuousOn hT hx hy1, fun k => ?_⟩
  exact (Jfg_analytic_right W M a σ₀ (zetaK_diffOn k).continuousOn hz hT hx1 hy).congr
    (Imom_iter_left_ev W M a σ₀ hT k hx hy).symm

end J

/-- **The slices of `c(α,β)` are analytic**, at `α + β ≠ 0`. -/
theorem cY_slices (P : ℝ[X]) (M : ℕ) {T : ℝ} (hT : T ≠ 0) {x y : ℂ} (hxy : x + y ≠ 0) :
    (∀ᶠ y' in 𝓝 y, AnalyticAt ℂ (fun x => cY P M T x y') x) ∧
      ∀ k, AnalyticAt ℂ (fun y => iteratedDeriv k (fun x => cY P M T x y) x) y := by
  have hfun : cY P M T = fun x y => cYform P M T (x, y) := by
    funext x y
    exact cY_eq P M hT x y
  have hU : IsOpen {q : ℂ × ℂ | q.1 + q.2 ≠ 0} :=
    isOpen_ne_fun (by fun_prop) continuous_const
  rw [hfun]
  exact slices_of_analytic hU (cYform_analytic P M T) (α₀ := x) (β₀ := y) hxy

/-! ### The mean of `|VQ ψ|²` -/

/-- The mollified mean `∫ w(t) |Q(−D/L)ζ(σ₀+it)|² |ψ(σ₀+it)|² dt`. -/
def mollMeanQ {T L : ℝ} (W : Weight T L) (M : ℕ) (a : ℕ → ℂ) (σ₀ : ℝ) (Q : ℝ[X]) (L' : ℝ) : ℂ :=
  ∫ t, (W.w t : ℂ) * ((‖VQ Q L' ((σ₀ : ℂ) + t * I)‖ ^ 2 : ℝ) : ℂ) * (msq M a σ₀ t : ℂ)

section Mean

variable {T L : ℝ} (W : Weight T L) (M : ℕ) (a : ℕ → ℂ) (σ₀ : ℝ)

/-- **The mean, expanded**: at `α₀ = σ₀ − 1/2`,
`∫ w |VQ|² |ψ|² = Σ_{k,l} q_k q_l (−1/L)^{k+l} J_{ζ^{(k)}, ζ^{(l)}}(α₀, α₀)`. -/
theorem mollMeanQ_eq (Q : ℝ[X]) (L' : ℝ) (hT : 4 ≤ T) (hσ : ‖(((σ₀ - 1 / 2 : ℝ)) : ℂ)‖ < 1) :
    mollMeanQ W M a σ₀ Q L' = ∑ k ∈ Finset.range (Q.natDegree + 1),
      ∑ l ∈ Finset.range (Q.natDegree + 1), qc Q L' k * qc Q L' l *
        Jfg (iteratedDeriv k riemannZeta) (iteratedDeriv l riemannZeta) W M a σ₀
          ((σ₀ - 1 / 2 : ℝ) : ℂ) ((σ₀ - 1 / 2 : ℝ) : ℂ) := by
  set α₀ : ℂ := ((σ₀ - 1 / 2 : ℝ) : ℂ) with hα₀
  set d := Q.natDegree with hd
  set m : ℝ → ℂ := fun t => (msq M a σ₀ t : ℂ) with hm
  set ww : ℝ → ℂ := fun t => (W.w t : ℂ) with hww
  set Z : ℕ → ℂ → ℂ := fun k => iteratedDeriv k riemannZeta with hZ
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
  have hqc : ∀ k, (starRingEnd ℂ) (qc Q L' k) = qc Q L' k := fun k => by
    unfold qc
    exact Complex.conj_ofReal _
  have hpt : ∀ t : ℝ, ww t * ((‖VQ Q L' ((σ₀ : ℂ) + t * I)‖ ^ 2 : ℝ) : ℂ) * m t =
      ∑ k ∈ Finset.range (d + 1), ∑ l ∈ Finset.range (d + 1),
        qc Q L' k * qc Q L' l * (ww t * (Z k (uA α₀ t) * Z l (vB α₀ t)) * m t) := by
    intro t
    have hG : ((‖VQ Q L' ((σ₀ : ℂ) + t * I)‖ ^ 2 : ℝ) : ℂ) =
        VQ Q L' (uA α₀ t) * (starRingEnd ℂ) (VQ Q L' (uA α₀ t)) := by
      rw [Complex.mul_conj, Complex.normSq_eq_norm_sq, hu]
    have hc : (starRingEnd ℂ) (VQ Q L' (uA α₀ t)) =
        ∑ l ∈ Finset.range (d + 1), qc Q L' l * Z l (vB α₀ t) := by
      unfold VQ
      rw [map_sum]
      refine Finset.sum_congr rfl fun l _ => ?_
      rw [map_mul, ← iteratedDeriv_zeta_conj, hv, Complex.conj_ofReal]
      rfl
    have hV : VQ Q L' (uA α₀ t) = ∑ k ∈ Finset.range (d + 1), qc Q L' k * Z k (uA α₀ t) := rfl
    rw [hG, hc, hV, Finset.sum_mul_sum, Finset.mul_sum, Finset.sum_mul]
    refine Finset.sum_congr rfl fun k _ => ?_
    rw [Finset.mul_sum, Finset.sum_mul]
    refine Finset.sum_congr rfl fun l _ => ?_
    ring
  have hα1 : ‖α₀‖ < 1 := hσ
  have hint : ∀ k l, Integrable (fun t => ww t * (Z k (uA α₀ t) * Z l (vB α₀ t)) * m t)
      (volume.restrict (Set.Icc (T / 4) (2 * T))) := fun k l =>
    Jfg_intOn W M a σ₀ (zetaK_diffOn k).continuousOn (zetaK_diffOn l).continuousOn hα1 hα1 hT
  have hset : mollMeanQ W M a σ₀ Q L' = ∫ t in Set.Icc (T / 4) (2 * T),
      ∑ k ∈ Finset.range (d + 1), ∑ l ∈ Finset.range (d + 1),
        qc Q L' k * qc Q L' l * (ww t * (Z k (uA α₀ t) * Z l (vB α₀ t)) * m t) := by
    unfold mollMeanQ
    rw [← setIntegral_eq_integral_of_forall_compl_eq_zero (s := Set.Icc (T / 4) (2 * T))
      (fun t ht => w_zero_mul W ht _ _)]
    congr 1
    funext t
    exact hpt t
  rw [hset, integral_finsetSum _ (fun k _ => integrable_finsetSum _
    (fun l _ => (hint k l).const_mul _))]
  refine Finset.sum_congr rfl fun k _ => ?_
  rw [integral_finsetSum _ (fun l _ => (hint k l).const_mul _)]
  refine Finset.sum_congr rfl fun l _ => ?_
  rw [integral_const_mul, Jfg_set]

/-- **`DopQ` of the moment is the mean**: at `α₀ = σ₀ − 1/2`, `‖α₀‖ < 1/2`,
`DopQ Imom (α₀, α₀) = ∫ w |Q(−D/L)ζ(σ₀+it)|² |ψ(σ₀+it)|²`. -/
theorem DopQ_Imom (Q : ℝ[X]) (L' : ℝ) (hT : 4 ≤ T)
    (hσ : ‖(((σ₀ - 1 / 2 : ℝ)) : ℂ)‖ < 1 / 2) :
    DopQ Q L' (Imom W M a σ₀) ((σ₀ - 1 / 2 : ℝ) : ℂ) ((σ₀ - 1 / 2 : ℝ) : ℂ) =
      mollMeanQ W M a σ₀ Q L' := by
  rw [mollMeanQ_eq W M a σ₀ Q L' hT (by linarith), DopQ]
  refine Finset.sum_congr rfl fun k _ => Finset.sum_congr rfl fun l _ => ?_
  rw [pkl_Imom W M a σ₀ hT k l hσ hσ]

end Mean

/-- info: 'MeanQ.iteratedDeriv_zeta_conj' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms iteratedDeriv_zeta_conj

/-- info: 'MeanQ.pkl_Imom' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms pkl_Imom

/-- info: 'MeanQ.Imom_slices' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Imom_slices

/-- info: 'MeanQ.cY_slices' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms cY_slices

/-- info: 'MeanQ.mollMeanQ_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms mollMeanQ_eq

/-- info: 'MeanQ.DopQ_Imom' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms DopQ_Imom

end MeanQ

end
