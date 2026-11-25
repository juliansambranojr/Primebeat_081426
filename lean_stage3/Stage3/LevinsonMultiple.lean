/-
LevinsonMultiple — block S11 of `lean_stage3/design/stencil.md`, removing `hsimple` by counting.
2026-11-25.

`LevinsonCount.levinson_count` asked `G = ζ + c ζ'` to be nonzero on the whole border of
`[1/2, 3] × [a, b]`. Its left edge is the critical line, and a zero of `G` there is a multiple
zero of `ζ` (`LevinsonWindow.G_line_ne`), which `LevinsonWindow.levinson_window` excluded by
`hsimple`. Here the zeros of `G` on the left edge are divided out and counted.

* `D` is the set of zeros of `G` on the left edge, the support of `G`'s divisor on the rectangle
  with `Re = 1/2`; it is finite, and lies strictly between the corners (`G ≠ 0` on the bottom
  and the top). `n ρ` is `G`'s order at `ρ`.
* `P = Π_{ρ ∈ D} (s − ρ)^{n ρ}` (`polyP`), and `G = P · H` with `H` analytic on the rectangle,
  built by `dslope` one factor at a time (`exists_pow_mul`, `exists_prod_mul`); `H ρ ≠ 0` on `D`
  by additivity of the order, so `H` is nonzero on the whole border.
* `ζ` has order `n ρ + 1` at `ρ ∈ D`, since `c ≠ 0` (`G_order_add_one`,
  Mathlib's `analyticOrderAt_deriv_of_pos`).
* On the line `P(1/2 + t i) = i^K · p(t)`, `K = Σ n ρ`, `p` real (`polyP_line`). With
  `F = i^K · Gammaℝ · H`, `Gammaℝ · G = p · F`, so `Re F = 0` forces `Re(Gammaℝ · G) = 0`,
  hence `ζ = 0` (`LevinsonLine.zeta_line_zero_iff`). `F` has no zero on the segment.
* The turning of `F` is the `Gammaℝ` part plus the turning of `H` (`LevinsonTurn.turn_split`),
  and the argument principle for `H` (`LevinsonTurn.G_turn_eq`) counts the zeros of `G` right of
  the line (`countRight_eq_of_mul`). The edge terms of `H` are those of `G` less those of `P`
  (`integral_logDeriv_mul`), and the edge terms of `P` add up to exactly `π K`
  (`polyP_edges`): each factor `s − ρ` turns by `π` around the bottom, right side and top
  (`factor_turn`, through `arg` on the slit plane, `arg_turn_segment`).
* So the crossings number at least `Q − K − 1`, `Q` the bound of `levinson_count` before its
  floor. `lineCount` counts the crossings once each and every `ρ ∈ D` with order `n ρ + 1`
  (`sum_order_le_lineCount`), at least `#crossings + K`. The `K` cancels, and the constant
  stays `418`.

  analyticAt_dslope       f analytic at a and at z  ⊢ AnalyticAt ℂ (dslope f a) z
  exists_pow_mul          ρ ∈ S, f analytic on S, k ≤ ord_ρ f
                            ⊢ ∃ g analytic on S, ∀ z, f z = (z − ρ)^k · g z
  polyP D n z             Π_{ρ ∈ D} (z − ρ)^{n ρ}
  polyP_order             ρ ∈ D  ⊢ ord_ρ (polyP D n) = n ρ
  logDeriv_polyP          z ∉ D  ⊢ logDeriv (polyP D n) z = Σ_{ρ ∈ D} n ρ · 1/(z − ρ)
  polyP_line              Re ρ = 1/2 on D  ⊢ polyP D n (1/2 + t i) = i^{Σ n ρ} · Π (t − Im ρ)^{n ρ}
  arg_turn_segment        u₁ ≤ u₂, z₀ + u v ∈ slitPlane on [u₁, u₂]
                            ⊢ Im ∫_{u₁}^{u₂} v/(z₀ + u v) = arg (z₀ + u₂ v) − arg (z₀ + u₁ v)
  exists_prod_mul         D ⊆ S, f analytic on S, n ρ ≤ ord_ρ f on D
                            ⊢ ∃ g analytic on S, ∀ z, f z = polyP D n z · g z
  G_order_add_one         c ≠ 0, ρ ≠ 1, ζ ρ = 0, ord_ρ (ζ + c ζ') ≠ ⊤
                            ⊢ ord_ρ (ζ + c ζ') + 1 = ord_ρ ζ
  zeta_order_ge           same  ⊢ (ord_ρ (ζ + c ζ')).toNat + 1 ≤ riemannZeta.order ρ
  sum_order_le_lineCount  E ⊆ (0, T] finite, ζ(1/2 + γ i) = 0 on E
                            ⊢ Σ_{γ ∈ E} riemannZeta.order (1/2 + γ i) ≤ lineCount T
  countRight_eq_of_mul    G = P · H, P ≠ 0 right of σ in R, G z ≠ 0, H z ≠ 0
                            ⊢ countRight G z w σ = countRight H z w σ
  integral_logDeriv_mul   P, H analytic and nonzero along q
                            ⊢ ∫ logDeriv (P · H) ∘ q = ∫ logDeriv P ∘ q + ∫ logDeriv H ∘ q
  factor_turn             Re ρ = 1/2, a < Im ρ < b
                            ⊢ Im ∫_{1/2}^3 1/(x + a i − ρ) − Im ∫_{1/2}^3 1/(x + b i − ρ)
                                + Re ∫_a^b 1/(3 + t i − ρ) = π
  polyP_edges             a ≤ b, Re ρ = 1/2 and a < Im ρ < b on D
                            ⊢ Im ∫_{1/2}^3 logDeriv P (x + a i) − Im ∫_{1/2}^3 logDeriv P (x + b i)
                                + Re ∫_a^b logDeriv P (3 + t i) = π · Σ_{ρ ∈ D} n ρ
  levinson_count'         0 < c ≤ 1, 4 ≤ a < b,
                            ζ + c ζ' ≠ 0 on [1/2, 3] + a i and on [1/2, 3] + b i,
                            1 − c · Re(Gammaℝ'/Gammaℝ)(1/2 + t i) ≠ 0 for t ∈ [a, b]
                            ⊢ (N b − N a)
                                − 2 · countRight (ζ + c ζ') (1/2 + a i) (3 + b i) (1/2)
                                − (72 log b + 418) ≤ lineCount b
  levinson_window'        the hypotheses of `LevinsonWindow.levinson_window` less `hsimple`
                            ⊢ (N b − N a)
                                − (1/(π(1/2 − σ₀))) · ((b − a)/2 · log K + windowE M B X T a b)
                                − (134 log T + 2918) ≤ lineCount b

Differences from `levinson_count`: `c > 0` (at `c = 0` a zero of `G` on the line is a zero of
`ζ` of the same order, and the count by `n ρ + 1` fails); no hypothesis on the left edge; the
right edge needs none (`LevinsonSize.re_G_pos`); the constant is unchanged.

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.LevinsonWindow

namespace LevinsonMultiple

open Complex MeasureTheory Set Filter Topology Littlewood LineCount Kadiri LevinsonWindow
open scoped Interval

/-- `dslope f a` is analytic wherever `f` is, given `f` analytic at `a`. -/
theorem analyticAt_dslope {f : ℂ → ℂ} {a z : ℂ} (ha : AnalyticAt ℂ f a)
    (hz : AnalyticAt ℂ f z) : AnalyticAt ℂ (dslope f a) z := by
  by_cases h : z = a
  · subst h
    obtain ⟨V, hVU, hVo, hzV⟩ := mem_nhds_iff.mp ha.eventually_analyticAt
    have hd : DifferentiableOn ℂ f V := fun w hw =>
      (hVU hw : AnalyticAt ℂ f w).differentiableAt.differentiableWithinAt
    have hd' := (Complex.differentiableOn_dslope (hVo.mem_nhds hzV)).mpr hd
    exact hd'.analyticAt (hVo.mem_nhds hzV)
  · have hev : (fun w => (w - a)⁻¹ • (f w - f a)) =ᶠ[𝓝 z] dslope f a := by
      filter_upwards [dslope_eventuallyEq_slope_of_ne f h] with w hw
      rw [hw, slope_def_module]
    refine AnalyticAt.congr ?_ hev
    exact ((analyticAt_id.sub analyticAt_const).inv (sub_ne_zero.mpr h)).smul
      (hz.sub analyticAt_const)

/-- `s − ρ` has order one at `ρ`. -/
theorem analyticOrderAt_sub_self (ρ : ℂ) : analyticOrderAt (fun z : ℂ => z - ρ) ρ = 1 := by
  have h : AnalyticAt ℂ (fun z : ℂ => z - ρ) ρ := analyticAt_id.sub analyticAt_const
  rw [← ENat.coe_one, h.analyticOrderAt_eq_natCast]
  exact ⟨fun _ => 1, analyticAt_const, one_ne_zero, Eventually.of_forall (fun z => by simp)⟩

/-- **One factor.** Order at least `k` at `ρ ∈ S` divides out `(s − ρ)^k`, by `dslope`. -/
theorem exists_pow_mul {S : Set ℂ} {ρ : ℂ} (hρ : ρ ∈ S) (k : ℕ) :
    ∀ f : ℂ → ℂ, (∀ z ∈ S, AnalyticAt ℂ f z) → (k : ℕ∞) ≤ analyticOrderAt f ρ →
    ∃ g : ℂ → ℂ, (∀ z ∈ S, AnalyticAt ℂ g z) ∧ ∀ z, f z = (z - ρ) ^ k * g z := by
  induction k with
  | zero => exact fun f hf _ => ⟨f, hf, fun z => by simp⟩
  | succ k ih =>
    intro f hf hk
    have hfρ : f ρ = 0 := by
      apply apply_eq_zero_of_analyticOrderAt_ne_zero
      intro h0
      rw [h0] at hk
      simp at hk
    set f₁ := dslope f ρ with hf₁
    have hf₁a : ∀ z ∈ S, AnalyticAt ℂ f₁ z := fun z hz => analyticAt_dslope (hf ρ hρ) (hf z hz)
    have hfeq : f = (fun z : ℂ => z - ρ) * f₁ := by
      funext z
      have := sub_smul_dslope_of_zero hfρ z
      simp only [smul_eq_mul] at this
      simp only [Pi.mul_apply, hf₁, this]
    have hord : analyticOrderAt f ρ = 1 + analyticOrderAt f₁ ρ := by
      conv_lhs => rw [hfeq]
      have hlin : AnalyticAt ℂ (fun z : ℂ => z - ρ) ρ := by fun_prop
      rw [analyticOrderAt_mul hlin (hf₁a ρ hρ), analyticOrderAt_sub_self]
    have hk1 : (k : ℕ∞) ≤ analyticOrderAt f₁ ρ := by
      rw [hord] at hk
      cases h : analyticOrderAt f₁ ρ with
      | top => exact le_top
      | coe m =>
        rw [h] at hk
        have : k + 1 ≤ 1 + m := by exact_mod_cast hk
        exact_mod_cast (by omega : k ≤ m)
    obtain ⟨g, hga, hg⟩ := ih f₁ hf₁a hk1
    refine ⟨g, hga, fun z => ?_⟩
    rw [congrFun hfeq z, Pi.mul_apply, hg z]
    ring


noncomputable section

/-- `P = Π_{ρ ∈ D} (s − ρ)^{n ρ}`. -/
noncomputable
def polyP (D : Finset ℂ) (n : ℂ → ℕ) (z : ℂ) : ℂ := ∏ ρ ∈ D, (z - ρ) ^ n ρ

end

/-- `P` is analytic everywhere. -/
theorem polyP_analyticAt (D : Finset ℂ) (n : ℂ → ℕ) (z : ℂ) : AnalyticAt ℂ (polyP D n) z := by
  unfold polyP
  fun_prop

/-- `P` is nonzero off `D`. -/
theorem polyP_ne_zero {D : Finset ℂ} (n : ℂ → ℕ) {z : ℂ} (hz : z ∉ D) : polyP D n z ≠ 0 :=
  Finset.prod_ne_zero_iff.mpr fun _ hρ =>
    pow_ne_zero _ (sub_ne_zero.mpr (fun h => hz (h ▸ hρ)))

/-- `P` has order `n ρ` at `ρ ∈ D`. -/
theorem polyP_order {D : Finset ℂ} (n : ℂ → ℕ) {ρ : ℂ} (hρ : ρ ∈ D) :
    analyticOrderAt (polyP D n) ρ = n ρ := by
  rw [(polyP_analyticAt D n ρ).analyticOrderAt_eq_natCast]
  refine ⟨fun z => ∏ ρ' ∈ D.erase ρ, (z - ρ') ^ n ρ', by fun_prop, ?_,
    Eventually.of_forall fun z => ?_⟩
  · exact Finset.prod_ne_zero_iff.mpr fun ρ' hρ' =>
      pow_ne_zero _ (sub_ne_zero.mpr (Finset.ne_of_mem_erase hρ').symm)
  · simp only [polyP, smul_eq_mul]
    rw [← Finset.mul_prod_erase D (fun ρ' => (z - ρ') ^ n ρ') hρ]

/-- The logarithmic derivative of `P` off `D`. -/
theorem logDeriv_polyP {D : Finset ℂ} (n : ℂ → ℕ) {z : ℂ} (hz : z ∉ D) :
    logDeriv (polyP D n) z = ∑ ρ ∈ D, (n ρ : ℂ) * (1 / (z - ρ)) := by
  have h : polyP D n = fun w => ∏ ρ ∈ D, (fun w => (w - ρ) ^ n ρ) w := rfl
  rw [h, logDeriv_prod]
  · refine Finset.sum_congr rfl fun ρ hρ => ?_
    rw [logDeriv_fun_pow (by fun_prop)]
    simp [logDeriv_apply]
  · intro ρ hρ
    exact pow_ne_zero _ (sub_ne_zero.mpr (fun h => hz (h ▸ hρ)))
  · intro ρ _
    fun_prop

/-- On the line, with `D` on the line, `P = i^K × real`. -/
theorem polyP_line {D : Finset ℂ} (n : ℂ → ℕ) (hD : ∀ ρ ∈ D, ρ.re = 1/2) (t : ℝ) :
    polyP D n (1/2 + t * I) =
      I ^ (∑ ρ ∈ D, n ρ) * ((∏ ρ ∈ D, (t - ρ.im) ^ n ρ : ℝ) : ℂ) := by
  unfold polyP
  rw [← Finset.prod_pow_eq_pow_sum, Complex.ofReal_prod, ← Finset.prod_mul_distrib]
  refine Finset.prod_congr rfl fun ρ hρ => ?_
  have e : (1/2 + t * I - ρ) = I * ((t - ρ.im : ℝ) : ℂ) := by
    apply Complex.ext <;> simp [hD ρ hρ]
  rw [e, mul_pow, Complex.ofReal_pow]

/-- **A segment in the slit plane.** `Im ∫ v/(z₀ + u v)` is the change of `arg`. -/
theorem arg_turn_segment {z₀ v : ℂ} {u₁ u₂ : ℝ} (hu : u₁ ≤ u₂)
    (hS : ∀ u ∈ Icc u₁ u₂, z₀ + u * v ∈ slitPlane) :
    (∫ u in u₁..u₂, v / (z₀ + u * v)).im = arg (z₀ + u₂ * v) - arg (z₀ + u₁ * v) := by
  have hc : Continuous (fun u : ℝ => z₀ + u * v) := by fun_prop
  have hφc : ContinuousOn (fun u : ℝ => arg (z₀ + u * v)) (Icc u₁ u₂) := by
    intro u hu'
    have h1 : ContinuousAt arg (z₀ + u * v) := continuousAt_arg (hS u hu')
    have h2 : ContinuousAt (fun u : ℝ => z₀ + u * v) u := hc.continuousAt
    exact (h1.comp (f := fun u : ℝ => z₀ + u * v) h2).continuousWithinAt
  have hd : ∀ u ∈ Ioo u₁ u₂, HasDerivAt (fun u : ℝ => z₀ + u * v) v u := by
    intro u _
    have := ((hasDerivAt_id u).ofReal_comp.mul_const v).const_add z₀
    simpa using this
  have hrep : ∀ u ∈ Icc u₁ u₂, z₀ + u * v = ‖z₀ + u * v‖ * exp (arg (z₀ + u * v) * I) :=
    fun u _ => (Complex.norm_mul_exp_arg_mul_I _).symm
  have h := LevinsonTurn.lift_turn_eq_integral (F := fun u : ℝ => z₀ + u * v)
    (F' := fun _ => v) (φ := fun u => arg (z₀ + u * v)) hu hc.continuousOn hd
    continuousOn_const (fun u hu => slitPlane_ne_zero (hS u hu)) hφc hrep
  exact h.symm

/-- `arg (r i) = −π/2` for `r < 0`. -/
theorem arg_mul_I_neg {r : ℝ} (hr : r < 0) : arg (r * I) = -(Real.pi / 2) := by
  have e : (r : ℂ) * I = ((-r : ℝ) : ℂ) * (-I) := by push_cast; ring
  rw [e, Complex.arg_real_mul _ (by linarith), Complex.arg_neg_I]

/-- `arg (r i) = π/2` for `r > 0`. -/
theorem arg_mul_I_pos {r : ℝ} (hr : 0 < r) : arg (r * I) = Real.pi / 2 := by
  rw [Complex.arg_real_mul _ hr, Complex.arg_I]


/-- **All factors.** Orders at least `n ρ` on a finite `D ⊆ S` divide out `polyP D n`. -/
theorem exists_prod_mul {S : Set ℂ} (n : ℂ → ℕ) (D : Finset ℂ) :
    ∀ f : ℂ → ℂ, (∀ ρ ∈ D, ρ ∈ S) → (∀ z ∈ S, AnalyticAt ℂ f z) →
    (∀ ρ ∈ D, (n ρ : ℕ∞) ≤ analyticOrderAt f ρ) →
    ∃ g : ℂ → ℂ, (∀ z ∈ S, AnalyticAt ℂ g z) ∧ ∀ z, f z = polyP D n z * g z := by
  classical
  induction D using Finset.induction_on with
  | empty => exact fun f _ hf _ => ⟨f, hf, fun z => by simp [polyP]⟩
  | @insert ρ D hρD ih =>
    intro f hDS hf hn
    obtain ⟨g₁, hg₁a, hg₁⟩ := exists_pow_mul (hDS ρ (Finset.mem_insert_self _ _)) (n ρ) f hf
      (hn ρ (Finset.mem_insert_self _ _))
    have hn' : ∀ ρ' ∈ D, (n ρ' : ℕ∞) ≤ analyticOrderAt g₁ ρ' := by
      intro ρ' hρ'
      have hne : ρ' ≠ ρ := fun h => hρD (h ▸ hρ')
      have hS' : ρ' ∈ S := hDS ρ' (Finset.mem_insert_of_mem hρ')
      have hfeq : f = (fun z : ℂ => (z - ρ) ^ n ρ) * g₁ := funext fun z => hg₁ z
      have hpa : AnalyticAt ℂ (fun z : ℂ => (z - ρ) ^ n ρ) ρ' := by fun_prop
      have h0 : analyticOrderAt (fun z : ℂ => (z - ρ) ^ n ρ) ρ' = 0 := by
        rw [hpa.analyticOrderAt_eq_zero]
        exact pow_ne_zero _ (sub_ne_zero.mpr hne)
      have := hn ρ' (Finset.mem_insert_of_mem hρ')
      rw [hfeq, analyticOrderAt_mul hpa (hg₁a ρ' hS'), h0, zero_add] at this
      exact this
    obtain ⟨g, hga, hg⟩ := ih g₁ (fun ρ' h => hDS ρ' (Finset.mem_insert_of_mem h)) hg₁a hn'
    refine ⟨g, hga, fun z => ?_⟩
    rw [hg₁ z, hg z, polyP, polyP, Finset.prod_insert hρD]
    ring

/-- `ζ + c ζ'` has order one less than `ζ` at a zero of `ζ`, for `c ≠ 0`. -/
theorem G_order_add_one {c : ℝ} (hc : c ≠ 0) {ρ : ℂ} (hρ1 : ρ ≠ 1)
    (hz : riemannZeta ρ = 0)
    (hfin : analyticOrderAt (fun s => riemannZeta s + c * deriv riemannZeta s) ρ ≠ ⊤) :
    analyticOrderAt (fun s => riemannZeta s + c * deriv riemannZeta s) ρ + 1
      = analyticOrderAt riemannZeta ρ := by
  have hdz : DifferentiableOn ℂ riemannZeta {1}ᶜ := fun z hz =>
    (differentiableAt_riemannZeta hz).differentiableWithinAt
  have hζ : AnalyticAt ℂ riemannZeta ρ := hdz.analyticAt (isOpen_compl_singleton.mem_nhds hρ1)
  have hζfin : analyticOrderAt riemannZeta ρ ≠ ⊤ := by
    intro htop
    apply hfin
    rw [analyticOrderAt_eq_top] at htop ⊢
    have hev : riemannZeta =ᶠ[𝓝 ρ] fun _ => 0 := htop
    have hd := hev.deriv
    filter_upwards [hev, hd] with s h1 h2
    rw [h1, h2]
    simp
  have h0 : analyticOrderAt riemannZeta ρ ≠ 0 := hζ.analyticOrderAt_ne_zero.mpr hz
  obtain ⟨m, hm⟩ := ENat.ne_top_iff_exists.mp hζfin
  obtain ⟨j, rfl⟩ : ∃ j, m = j + 1 := ⟨m - 1, by
    have : m ≠ 0 := by rintro rfl; exact h0 hm.symm
    omega⟩
  have hd := analyticOrderAt_deriv_of_pos hζ (n := j) (by rw [← hm]; push_cast; rfl)
  have hca : AnalyticAt ℂ (fun _ : ℂ => (c : ℂ)) ρ := analyticAt_const
  have hcd : analyticOrderAt (fun s => (c : ℂ) * deriv riemannZeta s) ρ = j := by
    have e : (fun s => (c : ℂ) * deriv riemannZeta s) = (fun _ : ℂ => (c : ℂ)) * deriv riemannZeta :=
      rfl
    rw [e, analyticOrderAt_mul hca hζ.deriv, hd,
      hca.analyticOrderAt_eq_zero.mpr (by exact_mod_cast hc), zero_add]
  have e2 : (fun s => riemannZeta s + c * deriv riemannZeta s)
      = riemannZeta + fun s => (c : ℂ) * deriv riemannZeta s := rfl
  rw [e2, analyticOrderAt_add_eq_right_of_lt (by rw [hcd, ← hm]; exact_mod_cast (by omega : j < j + 1)),
    hcd, ← hm]
  push_cast
  rfl

/-- The order of `ζ` at a zero of `ζ + c ζ'` on the line. -/
theorem zeta_order_ge {c : ℝ} (hc : c ≠ 0) {ρ : ℂ} (hρ1 : ρ ≠ 1) (hz : riemannZeta ρ = 0)
    (hfin : analyticOrderAt (fun s => riemannZeta s + c * deriv riemannZeta s) ρ ≠ ⊤) :
    ((analyticOrderAt (fun s => riemannZeta s + c * deriv riemannZeta s) ρ).toNat : ℤ) + 1
      ≤ riemannZeta.order ρ := by
  have hdz : DifferentiableOn ℂ riemannZeta {1}ᶜ := fun z hz =>
    (differentiableAt_riemannZeta hz).differentiableWithinAt
  have hζ : AnalyticAt ℂ riemannZeta ρ := hdz.analyticAt (isOpen_compl_singleton.mem_nhds hρ1)
  have h := G_order_add_one hc hρ1 hz hfin
  obtain ⟨k, hk⟩ := ENat.ne_top_iff_exists.mp hfin
  rw [← hk] at h ⊢
  unfold riemannZeta.order
  rw [hζ.meromorphicOrderAt_eq, ← h,
    show ((k : ℕ∞) + 1) = ((k + 1 : ℕ) : ℕ∞) by norm_cast, ENat.map_coe, WithTop.untopD_coe]
  simp only [ENat.toNat_coe]
  push_cast
  omega


/-- Distinct heights in `(0, T]` carrying zeros of `ζ` on the line, weighted by order. -/
theorem sum_order_le_lineCount {T : ℝ} (E : Finset ℝ) (hpos : ∀ γ ∈ E, 0 < γ)
    (hT : ∀ γ ∈ E, γ ≤ T) (hζ : ∀ γ ∈ E, riemannZeta (1/2 + γ * I) = 0) :
    ∑ γ ∈ E, riemannZeta.order (1/2 + γ * I) ≤ lineCount T := by
  classical
  have hmemZ : ∀ γ ∈ E, ((1/2 : ℂ) + (γ : ℂ) * I) ∈ NontrivialZeros := fun γ hγ => by
    refine ⟨?_, Set.mem_univ _, hζ γ hγ⟩
    rw [HardyZ.re_line]
    norm_num
  set S := (zerosUpTo T).filter
    (fun ρ : NontrivialZeros => (ρ : ℂ).re = 1 / 2 ∧ (ρ : ℂ).im ∈ E) with hS
  have key : ∑ ρ ∈ S, riemannZeta.order (ρ : ℂ) = ∑ γ ∈ E, riemannZeta.order (1/2 + γ * I) := by
    apply Finset.sum_bij (fun (ρ : NontrivialZeros) _ => (ρ : ℂ).im)
    · intro ρ hρ
      exact (Finset.mem_filter.mp hρ).2.2
    · intro ρ₁ h₁ ρ₂ h₂ he
      apply Subtype.ext
      apply Complex.ext
      · rw [(Finset.mem_filter.mp h₁).2.1, (Finset.mem_filter.mp h₂).2.1]
      · exact he
    · intro γ hγ
      refine ⟨⟨(1/2 : ℂ) + (γ : ℂ) * I, hmemZ γ hγ⟩, ?_, by simp⟩
      rw [Finset.mem_filter, mem_zerosUpTo]
      simp only [Complex.add_im, Complex.mul_im, Complex.ofReal_re, Complex.ofReal_im,
        Complex.I_re, Complex.I_im]
      refine ⟨⟨by simp; exact hpos γ hγ, by simp; exact hT γ hγ⟩, HardyZ.re_line γ, by simpa using hγ⟩
    · intro ρ hρ
      congr 1
      apply Complex.ext
      · simp [(Finset.mem_filter.mp hρ).2.1]
      · simp
  rw [← key]
  unfold lineCount
  refine Finset.sum_le_sum_of_subset_of_nonneg ?_
    (fun z _ _ => (riemannZeta_order_pos_nontrivialZero z).le)
  intro ρ hρ
  rw [Finset.mem_filter] at hρ ⊢
  exact ⟨hρ.1, hρ.2.1⟩

/-- Dividing by a factor nonzero at `p` leaves the divisor at `p` unchanged. -/
theorem divisor_eq_of_mul {G P H : ℂ → ℂ} {U : Set ℂ} {p : ℂ}
    (hGU : ∀ z ∈ U, AnalyticAt ℂ G z) (hHU : ∀ z ∈ U, AnalyticAt ℂ H z)
    (hP : AnalyticAt ℂ P p) (hPp : P p ≠ 0) (heq : G = P * H) (hp : p ∈ U) :
    MeromorphicOn.divisor G U p = MeromorphicOn.divisor H U p := by
  rw [MeromorphicOn.divisor_apply (fun s hs => (hGU s hs).meromorphicAt) hp,
    MeromorphicOn.divisor_apply (fun s hs => (hHU s hs).meromorphicAt) hp,
    (hGU p hp).meromorphicOrderAt_eq, (hHU p hp).meromorphicOrderAt_eq, heq,
    analyticOrderAt_mul hP (hHU p hp), hP.analyticOrderAt_eq_zero.mpr hPp, zero_add]

/-- The count right of `σ` is unchanged by a factor with no zero right of `σ`. -/
theorem countRight_eq_of_mul {G P H : ℂ → ℂ} {z w : ℂ} {σ : ℝ}
    (hG : AnalyticOnNhd ℂ G (Rectangle z w)) (hH : AnalyticOnNhd ℂ H (Rectangle z w))
    (hP : ∀ p, AnalyticAt ℂ P p) (hPne : ∀ p ∈ Rectangle z w, σ < p.re → P p ≠ 0)
    (heq : G = P * H) (hGz : G z ≠ 0) (hHz : H z ≠ 0) :
    Littlewood.countRight G z w σ = Littlewood.countRight H z w σ := by
  classical
  have hfinG := Littlewood.order_ne_top hG hGz
  have hfinH := Littlewood.order_ne_top hH hHz
  unfold Littlewood.countRight
  rw [← Finset.sum_filter, ← Finset.sum_filter]
  have hset : (divisor_support_rectangle_finite G z w).toFinset.filter (fun p => σ < p.re)
      = (divisor_support_rectangle_finite H z w).toFinset.filter (fun p => σ < p.re) := by
    ext p
    simp only [Finset.mem_filter, Set.Finite.mem_toFinset]
    rw [Littlewood.mem_support_divisor subset_rfl hG hfinG,
      Littlewood.mem_support_divisor subset_rfl hH hfinH]
    constructor
    · rintro ⟨⟨hpR, hp0⟩, hσ⟩
      refine ⟨⟨hpR, ?_⟩, hσ⟩
      have := congrFun heq p
      rw [hp0, Pi.mul_apply] at this
      exact (mul_eq_zero.mp this.symm).resolve_left (hPne p hpR hσ)
    · rintro ⟨⟨hpR, hp0⟩, hσ⟩
      refine ⟨⟨hpR, ?_⟩, hσ⟩
      rw [congrFun heq p, Pi.mul_apply, hp0, mul_zero]
  rw [hset]
  refine Finset.sum_congr rfl fun p hp => ?_
  rw [Finset.mem_filter, Set.Finite.mem_toFinset,
    Littlewood.mem_support_divisor subset_rfl hH hfinH] at hp
  rw [divisor_eq_of_mul (U := Rectangle z w) hG hH (hP p) (hPne p hp.1.1 hp.2) heq hp.1.1]

/-- The split of `∫ logDeriv (P · H)` along a path where both are analytic and nonzero. -/
theorem integral_logDeriv_mul {P H : ℂ → ℂ} {q : ℝ → ℂ} {u₁ u₂ : ℝ} (hu : u₁ ≤ u₂)
    (hq : Continuous q)
    (hP : ∀ u ∈ Icc u₁ u₂, AnalyticAt ℂ P (q u)) (hH : ∀ u ∈ Icc u₁ u₂, AnalyticAt ℂ H (q u))
    (hP0 : ∀ u ∈ Icc u₁ u₂, P (q u) ≠ 0) (hH0 : ∀ u ∈ Icc u₁ u₂, H (q u) ≠ 0) :
    (∫ u in u₁..u₂, logDeriv (fun s => P s * H s) (q u)) =
      (∫ u in u₁..u₂, logDeriv P (q u)) + ∫ u in u₁..u₂, logDeriv H (q u) := by
  have hcont : ∀ {f : ℂ → ℂ}, (∀ u ∈ Icc u₁ u₂, AnalyticAt ℂ f (q u)) →
      (∀ u ∈ Icc u₁ u₂, f (q u) ≠ 0) →
      IntervalIntegrable (fun u => logDeriv f (q u)) volume u₁ u₂ := by
    intro f hf hf0
    apply ContinuousOn.intervalIntegrable
    rw [uIcc_of_le hu]
    intro u hu'
    exact (ContinuousAt.comp (g := logDeriv f) (f := q)
      (Littlewood.continuousAt_logDeriv (hf u hu') (hf u hu').deriv (hf0 u hu'))
      hq.continuousAt).continuousWithinAt
  rw [← intervalIntegral.integral_add (hcont hP hP0) (hcont hH hH0)]
  refine intervalIntegral.integral_congr fun u hu' => ?_
  rw [uIcc_of_le hu] at hu'
  exact logDeriv_mul (q u) (hP0 u hu') (hH0 u hu') (hP u hu').differentiableAt
    (hH u hu').differentiableAt


/-- The turning of `s − ρ` around the bottom, the right side and the top of the rectangle
`[1/2, 3] × [a, b]`, for `ρ` on the left edge strictly between `a` and `b`, is `π`. -/
theorem factor_turn {a b : ℝ} {ρ : ℂ} (hre : ρ.re = 1/2) (ha : a < ρ.im) (hb : ρ.im < b) :
    (∫ x in (1/2:ℝ)..3, 1 / ((x:ℂ) + a * I - ρ)).im
      - (∫ x in (1/2:ℝ)..3, 1 / ((x:ℂ) + b * I - ρ)).im
      + (∫ t in a..b, 1 / ((3:ℂ) + t * I - ρ)).re = Real.pi := by
  have hhor : ∀ y : ℝ, y ≠ ρ.im → (∫ x in (1/2:ℝ)..3, 1 / ((x:ℂ) + y * I - ρ)).im
      = arg ((3 - ρ) + y * I) - arg (((y - ρ.im : ℝ) : ℂ) * I) := by
    intro y hy
    have h := arg_turn_segment (z₀ := y * I - ρ) (v := 1) (u₁ := 1/2) (u₂ := 3) (by norm_num)
      (fun x _ => by
        rw [mem_slitPlane_iff]
        right
        have e : ((y:ℂ) * I - ρ + (x:ℂ) * 1).im = y - ρ.im := by simp
        rw [e]
        exact sub_ne_zero.mpr hy)
    have e1 : (∫ x in (1/2:ℝ)..3, 1 / ((x:ℂ) + y * I - ρ))
        = ∫ x in (1/2:ℝ)..3, (1:ℂ) / ((y:ℂ) * I - ρ + (x:ℂ) * 1) := by
      refine intervalIntegral.integral_congr fun x _ => ?_
      congr 1
      ring
    have e2 : (y:ℂ) * I - ρ + ((3:ℝ):ℂ) * 1 = (3 - ρ) + y * I := by push_cast; ring
    have e3 : (y:ℂ) * I - ρ + (((1/2:ℝ)):ℂ) * 1 = ((y - ρ.im : ℝ) : ℂ) * I := by
      apply Complex.ext <;> simp [hre]
    rw [e1, h, e2, e3]
  have hright : (∫ t in a..b, 1 / ((3:ℂ) + t * I - ρ)).re
      = arg ((3 - ρ) + b * I) - arg ((3 - ρ) + a * I) := by
    have h := arg_turn_segment (z₀ := 3 - ρ) (v := I) (u₁ := a) (u₂ := b) (by linarith)
      (fun t _ => by
        rw [mem_slitPlane_iff]
        left
        have e : ((3:ℂ) - ρ + (t:ℂ) * I).re = 3 - ρ.re := by simp
        rw [e, hre]
        norm_num)
    have e1 : (∫ t in a..b, I / ((3:ℂ) - ρ + t * I))
        = (∫ t in a..b, 1 / ((3:ℂ) + t * I - ρ)) * I := by
      rw [← intervalIntegral.integral_mul_const]
      refine intervalIntegral.integral_congr fun t _ => ?_
      have hne : (3:ℂ) + t * I - ρ ≠ 0 := by
        intro h0
        have := congrArg Complex.re h0
        simp [hre] at this
        norm_num at this
      have hne' : (3:ℂ) - ρ + t * I ≠ 0 := by
        rw [show (3:ℂ) - ρ + t * I = (3:ℂ) + t * I - ρ by ring]; exact hne
      field_simp
      try ring
    rw [e1, Complex.mul_I_im] at h
    exact h
  rw [hhor a (ne_of_lt ha), hhor b (ne_of_gt hb), hright, arg_mul_I_neg (by linarith),
    arg_mul_I_pos (by linarith)]
  ring

/-- Along a path missing `D`, `∫ logDeriv P` is the weighted sum of `∫ 1/(q − ρ)`. -/
theorem integral_logDeriv_polyP {D : Finset ℂ} (n : ℂ → ℕ) {q : ℝ → ℂ} {u₁ u₂ : ℝ}
    (hu : u₁ ≤ u₂) (hq : Continuous q) (hD : ∀ u ∈ Icc u₁ u₂, q u ∉ D) :
    (∫ u in u₁..u₂, logDeriv (polyP D n) (q u))
      = ∑ ρ ∈ D, (n ρ : ℂ) * ∫ u in u₁..u₂, 1 / (q u - ρ) := by
  have e : (∫ u in u₁..u₂, logDeriv (polyP D n) (q u))
      = ∫ u in u₁..u₂, ∑ ρ ∈ D, (n ρ : ℂ) * (1 / (q u - ρ)) := by
    refine intervalIntegral.integral_congr fun u hu' => ?_
    rw [uIcc_of_le hu] at hu'
    exact logDeriv_polyP n (hD u hu')
  rw [e, intervalIntegral.integral_finsetSum]
  · exact Finset.sum_congr rfl fun ρ _ => intervalIntegral.integral_const_mul _ _
  · intro ρ hρ
    apply ContinuousOn.intervalIntegrable
    rw [uIcc_of_le hu]
    apply continuousOn_const.mul
    apply continuousOn_const.div (hq.sub continuous_const).continuousOn
    intro u hu'
    exact sub_ne_zero.mpr (fun h => hD u hu' (h ▸ hρ))

/-- `Im (m w) = m Im w`. -/
theorem natCast_mul_im' (m : ℕ) (w : ℂ) : ((m : ℂ) * w).im = m * w.im := by simp
/-- `Re (m w) = m Re w`. -/
theorem natCast_mul_re' (m : ℕ) (w : ℂ) : ((m : ℂ) * w).re = m * w.re := by simp

/-- **The turning of `P` around the three edges.** For `D` on the open left edge, the bottom,
right and top terms of `∫ logDeriv P` add up to `π K`, `K = Σ n ρ`. -/
theorem polyP_edges {a b : ℝ} (hab : a ≤ b) {D : Finset ℂ} (n : ℂ → ℕ)
    (hD : ∀ ρ ∈ D, ρ.re = 1/2 ∧ a < ρ.im ∧ ρ.im < b) :
    (∫ x in (1/2:ℝ)..3, logDeriv (polyP D n) (↑x + ↑a * I)).im
      - (∫ x in (1/2:ℝ)..3, logDeriv (polyP D n) (↑x + ↑b * I)).im
      + (∫ t in a..b, logDeriv (polyP D n) (3 + ↑t * I)).re
      = Real.pi * ∑ ρ ∈ D, (n ρ : ℝ) := by
  have hbot := integral_logDeriv_polyP n (q := fun x : ℝ => (x : ℂ) + a * I)
    (by norm_num : (1/2 : ℝ) ≤ 3) (by fun_prop)
    (fun x _ hxD => by have := (hD _ hxD).2.1; simp at this)
  have htop := integral_logDeriv_polyP n (q := fun x : ℝ => (x : ℂ) + b * I)
    (by norm_num : (1/2 : ℝ) ≤ 3) (by fun_prop)
    (fun x _ hxD => by have := (hD _ hxD).2.2; simp at this)
  have hrt := integral_logDeriv_polyP n (q := fun t : ℝ => (3 : ℂ) + t * I) hab (by fun_prop)
    (fun t _ hxD => by have := (hD _ hxD).1; simp at this; norm_num at this)
  rw [hbot, htop, hrt, Complex.im_sum, Complex.im_sum, Complex.re_sum, ← Finset.sum_sub_distrib,
    ← Finset.sum_add_distrib, Finset.mul_sum]
  refine Finset.sum_congr rfl fun ρ hρ => ?_
  rw [natCast_mul_im', natCast_mul_im', natCast_mul_re']
  have h := factor_turn (hD ρ hρ).1 (hD ρ hρ).2.1 (hD ρ hρ).2.2
  have e : (n ρ : ℝ) * (∫ x in (1/2:ℝ)..3, 1 / ((x:ℂ) + a * I - ρ)).im
      - (n ρ : ℝ) * (∫ x in (1/2:ℝ)..3, 1 / ((x:ℂ) + b * I - ρ)).im
      + (n ρ : ℝ) * (∫ t in a..b, 1 / ((3:ℂ) + t * I - ρ)).re
      = (n ρ : ℝ) * ((∫ x in (1/2:ℝ)..3, 1 / ((x:ℂ) + a * I - ρ)).im
      - (∫ x in (1/2:ℝ)..3, 1 / ((x:ℂ) + b * I - ρ)).im
      + (∫ t in a..b, 1 / ((3:ℂ) + t * I - ρ)).re) := by ring
  rw [e, h]
  ring


/-- **S11, removing `hsimple`: Levinson's count.** For `0 < c ≤ 1`, `4 ≤ a < b`, `G = ζ + c ζ'`
nonzero on the bottom `[1/2, 3] + a i` and the top `[1/2, 3] + b i`, and the real factor
`1 − c · Re(Gammaℝ'/Gammaℝ)` nonzero along `[1/2 + a i, 1/2 + b i]`: with no hypothesis on the
left edge, the zeros of `ζ` on the line up to height `b`, with order, number at least
`(N b − N a) − 2 · (zeros of G right of the line in the rectangle, with order)
− (72 log b + 418)`. -/
theorem levinson_count' {c a b : ℝ} (hc0 : 0 < c) (hc1 : c ≤ 1) (ha : 4 ≤ a) (hab : a < b)
    (hBot : ∀ x ∈ Icc (1/2 : ℝ) 3,
      riemannZeta (↑x + ↑a * I) + c * deriv riemannZeta (↑x + ↑a * I) ≠ 0)
    (hTop : ∀ x ∈ Icc (1/2 : ℝ) 3,
      riemannZeta (↑x + ↑b * I) + c * deriv riemannZeta (↑x + ↑b * I) ≠ 0)
    (hfac : ∀ t ∈ Icc a b,
      1 - c * (deriv Gammaℝ (1/2 + t * I) / Gammaℝ (1/2 + t * I)).re ≠ 0) :
    (riemannZeta.N b - riemannZeta.N a)
      - 2 * Littlewood.countRight (fun s => riemannZeta s + c * deriv riemannZeta s)
          ((1/2 : ℂ) + a * I) ((3 : ℂ) + b * I) (1/2)
      - (72 * Real.log b + 418) ≤ (lineCount b : ℝ) := by
  classical
  set G : ℂ → ℂ := fun s => riemannZeta s + c * deriv riemannZeta s with hG_def
  have hπ : 0 < Real.pi := Real.pi_pos
  have hcne : c ≠ 0 := hc0.ne'
  -- the rectangle
  have hGa : AnalyticOnNhd ℂ G (Rectangle ((1/2 : ℂ) + a * I) ((3 : ℂ) + b * I)) :=
    LevinsonCount.G_analyticOnNhd_rect c ha hab.le
  have hzre : ((1/2 : ℂ) + a * I).re = 1/2 := by simp
  have hzim : ((1/2 : ℂ) + a * I).im = a := by simp
  have hwre : ((3 : ℂ) + b * I).re = 3 := by simp
  have hwim : ((3 : ℂ) + b * I).im = b := by simp
  have hmemR : ∀ p, p ∈ Rectangle ((1/2 : ℂ) + a * I) ((3 : ℂ) + b * I) ↔
      1/2 ≤ p.re ∧ p.re ≤ 3 ∧ a ≤ p.im ∧ p.im ≤ b := by
    intro p
    rw [mem_Rect (by rw [hzre, hwre]; norm_num) (by rw [hzim, hwim]; exact hab.le), hzre, hzim,
      hwre, hwim]
  have hlineR : ∀ t ∈ Icc a b, ((1/2 : ℂ) + t * I) ∈ Rectangle ((1/2 : ℂ) + a * I) ((3 : ℂ) + b * I) :=
    fun t ht => (hmemR _).mpr ⟨by rw [HardyZ.re_line], by rw [HardyZ.re_line]; norm_num,
      by simpa using ht.1, by simpa using ht.2⟩
  have hGz : G ((1/2 : ℂ) + a * I) ≠ 0 := by
    have h := hBot (1/2) ⟨le_rfl, by norm_num⟩
    push_cast at h
    exact h
  have hfinM := Littlewood.order_ne_top hGa hGz
  have hfin : ∀ p ∈ Rectangle ((1/2 : ℂ) + a * I) ((3 : ℂ) + b * I),
      analyticOrderAt G p ≠ ⊤ := by
    intro p hp htop
    apply hfinM p hp
    rw [(hGa p hp).meromorphicOrderAt_eq, htop]
    rfl
  -- the zeros of `G` on the left edge
  set D : Finset ℂ := (divisor_support_rectangle_finite G ((1/2 : ℂ) + a * I)
    ((3 : ℂ) + b * I)).toFinset.filter (fun p => p.re = 1/2) with hD_def
  have hmemD : ∀ p, p ∈ D ↔
      p ∈ Rectangle ((1/2 : ℂ) + a * I) ((3 : ℂ) + b * I) ∧ G p = 0 ∧ p.re = 1/2 := by
    intro p
    rw [hD_def, Finset.mem_filter, Set.Finite.mem_toFinset,
      Littlewood.mem_support_divisor subset_rfl hGa hfinM, and_assoc]
  have hDprop : ∀ ρ ∈ D, ρ.re = 1/2 ∧ a < ρ.im ∧ ρ.im < b := by
    intro ρ hρ
    obtain ⟨hR, h0, hre⟩ := (hmemD ρ).mp hρ
    obtain ⟨-, -, h3, h4⟩ := (hmemR ρ).mp hR
    have hρeq : ρ = ↑ρ.re + ↑ρ.im * I := (Complex.re_add_im ρ).symm
    refine ⟨hre, lt_of_le_of_ne h3 ?_, lt_of_le_of_ne h4 ?_⟩
    · intro he
      apply hBot ρ.re ⟨by linarith, by linarith⟩
      rw [he, ← hρeq]
      exact h0
    · intro he
      apply hTop ρ.re ⟨by linarith, by linarith⟩
      rw [← he, ← hρeq]
      exact h0
  have hρeq : ∀ ρ ∈ D, ρ = (1/2 : ℂ) + ↑ρ.im * I := by
    intro ρ hρ
    apply Complex.ext <;> simp [(hDprop ρ hρ).1]
  have hζD : ∀ ρ ∈ D, riemannZeta ρ = 0 := by
    intro ρ hρ
    obtain ⟨hR, h0, -⟩ := (hmemD ρ).mp hρ
    have hIm := hDprop ρ hρ
    have h := (LevinsonLine.zeta_line_zero_iff c ρ.im
      (hfac ρ.im ⟨hIm.2.1.le, hIm.2.2.le⟩)).mpr (by
        rw [← hρeq ρ hρ]
        show (Gammaℝ ρ * G ρ).re = 0
        rw [h0, mul_zero, Complex.zero_re])
    rwa [← hρeq ρ hρ] at h
  -- divide them out
  set n : ℂ → ℕ := fun p => (analyticOrderAt G p).toNat with hn_def
  have hn : ∀ ρ ∈ D, (n ρ : ℕ∞) = analyticOrderAt G ρ := fun ρ hρ =>
    ENat.coe_toNat (hfin ρ ((hmemD ρ).mp hρ).1)
  obtain ⟨H, hHa, hGPH⟩ := exists_prod_mul (S := Rectangle ((1/2 : ℂ) + a * I) ((3 : ℂ) + b * I))
    n D G (fun ρ hρ => ((hmemD ρ).mp hρ).1) (fun p hp => hGa p hp) (fun ρ hρ => (hn ρ hρ).le)
  have hHne_of_G : ∀ p, G p ≠ 0 → H p ≠ 0 := fun p hp h => hp (by rw [hGPH p, h, mul_zero])
  have hHneD : ∀ ρ ∈ D, H ρ ≠ 0 := by
    intro ρ hρ
    have hR := ((hmemD ρ).mp hρ).1
    have e : G = polyP D n * H := funext fun s => hGPH s
    have hord : analyticOrderAt G ρ = n ρ + analyticOrderAt H ρ := by
      rw [e, analyticOrderAt_mul (polyP_analyticAt D n ρ) (hHa ρ hR), polyP_order n hρ]
    rw [← hn ρ hρ] at hord
    have h0 : analyticOrderAt H ρ = 0 := by
      cases h : analyticOrderAt H ρ with
      | top => rw [h] at hord; simp at hord
      | coe m =>
        rw [h] at hord
        have h1 : n ρ = n ρ + m := by exact_mod_cast hord
        have hm : m = 0 := by omega
        rw [hm]
        rfl
    exact (hHa ρ hR).analyticOrderAt_eq_zero.mp h0
  have hHline : ∀ t ∈ Icc a b, H (1/2 + t * I) ≠ 0 := by
    intro t ht
    by_cases hG0 : G (1/2 + t * I) = 0
    · apply hHneD
      rw [hmemD]
      exact ⟨hlineR t ht, hG0, HardyZ.re_line t⟩
    · exact hHne_of_G _ hG0
  have hGright : ∀ t : ℝ, G (3 + t * I) ≠ 0 := by
    intro t h
    have := LevinsonSize.re_G_pos hc0.le hc1 t
    have h' : riemannZeta (3 + t * I) + c * deriv riemannZeta (3 + t * I) = 0 := h
    rw [h', Complex.zero_re] at this
    exact lt_irrefl _ this
  have hHB : ∀ p ∈ RectangleBorder ((1/2 : ℂ) + a * I) ((3 : ℂ) + b * I), H p ≠ 0 := by
    intro p hp
    have hcases := LevinsonWindow.border_cases (by rw [hzre, hwre]; norm_num)
      (by rw [hzim, hwim]; exact hab.le) hp
    rw [hzre, hzim, hwre, hwim] at hcases
    have hp' : p = ↑p.re + ↑p.im * I := (Complex.re_add_im p).symm
    rcases hcases with ⟨him, hre⟩ | ⟨hre, him⟩ | ⟨him, hre⟩ | ⟨hre, him⟩
    · apply hHne_of_G
      rw [hp', him]
      exact hBot p.re hre
    · rw [hp', hre]
      push_cast
      exact hHline p.im him
    · apply hHne_of_G
      rw [hp', him]
      exact hTop p.re hre
    · apply hHne_of_G
      rw [hp', hre]
      push_cast
      exact hGright p.im
  -- the argument principle for `H`
  have hcast : ((3 : ℝ) : ℂ) = (3 : ℂ) := by norm_num
  have hHa3 : AnalyticOnNhd ℂ H (Rectangle ((1/2 : ℂ) + a * I) (((3 : ℝ) : ℂ) + b * I)) := by
    rw [hcast]; exact hHa
  have hHB3 : ∀ p ∈ RectangleBorder ((1/2 : ℂ) + a * I) (((3 : ℝ) : ℂ) + b * I), H p ≠ 0 := by
    rw [hcast]; exact hHB
  have hHturn := LevinsonTurn.G_turn_eq (G := H) (X := 3) (by norm_num) hab hHa3 hHB3
  rw [hcast] at hHturn
  have hHz : H ((1/2 : ℂ) + a * I) ≠ 0 := hHne_of_G _ hGz
  have hC : Littlewood.countRight G ((1/2 : ℂ) + a * I) ((3 : ℂ) + b * I) (1/2)
      = Littlewood.countRight H ((1/2 : ℂ) + a * I) ((3 : ℂ) + b * I) (1/2) :=
    countRight_eq_of_mul hGa hHa (fun p => polyP_analyticAt D n p)
      (fun p _ hσ => polyP_ne_zero n (fun hpD => by
        have := (hDprop p hpD).1
        linarith))
      (funext fun s => hGPH s) hGz hHz
  -- the edges: `G = P · H`
  have e : G = fun s => polyP D n s * H s := funext hGPH
  have hbotS : (∫ x in (1/2:ℝ)..3, logDeriv G (↑x + ↑a * I))
      = (∫ x in (1/2:ℝ)..3, logDeriv (polyP D n) (↑x + ↑a * I))
        + ∫ x in (1/2:ℝ)..3, logDeriv H (↑x + ↑a * I) := by
    rw [e]
    exact integral_logDeriv_mul (by norm_num) (by fun_prop)
      (fun x _ => polyP_analyticAt D n _)
      (fun x hx => hHa _ ((hmemR _).mpr ⟨by simpa using hx.1, by simpa using hx.2, by simp,
        by simpa using hab.le⟩))
      (fun x _ => polyP_ne_zero n (fun hD => by have := (hDprop _ hD).2.1; simp at this))
      (fun x hx => hHne_of_G _ (hBot x hx))
  have htopS : (∫ x in (1/2:ℝ)..3, logDeriv G (↑x + ↑b * I))
      = (∫ x in (1/2:ℝ)..3, logDeriv (polyP D n) (↑x + ↑b * I))
        + ∫ x in (1/2:ℝ)..3, logDeriv H (↑x + ↑b * I) := by
    rw [e]
    exact integral_logDeriv_mul (by norm_num) (by fun_prop)
      (fun x _ => polyP_analyticAt D n _)
      (fun x hx => hHa _ ((hmemR _).mpr ⟨by simpa using hx.1, by simpa using hx.2,
        by simpa using hab.le, by simp⟩))
      (fun x _ => polyP_ne_zero n (fun hD => by have := (hDprop _ hD).2.2; simp at this))
      (fun x hx => hHne_of_G _ (hTop x hx))
  have hrtS : (∫ t in a..b, logDeriv G (3 + ↑t * I))
      = (∫ t in a..b, logDeriv (polyP D n) (3 + ↑t * I))
        + ∫ t in a..b, logDeriv H (3 + ↑t * I) := by
    rw [e]
    exact integral_logDeriv_mul hab.le (by fun_prop)
      (fun t _ => polyP_analyticAt D n _)
      (fun t ht => hHa _ ((hmemR _).mpr ⟨by simp; norm_num, by simp, by simpa using ht.1,
        by simpa using ht.2⟩))
      (fun t _ => polyP_ne_zero n (fun hD => by
        have := (hDprop _ hD).1
        simp at this
        norm_num at this))
      (fun t _ => hHne_of_G _ (hGright t))
  have hbot' := congrArg Complex.im hbotS
  have htop' := congrArg Complex.im htopS
  have hrt' := congrArg Complex.re hrtS
  rw [Complex.add_im] at hbot' htop'
  rw [Complex.add_re] at hrt'
  have hPE := polyP_edges hab.le n hDprop
  -- the line
  have hFa : ∀ t ∈ Icc a b, AnalyticAt ℂ
      (fun s => I ^ (∑ ρ ∈ D, n ρ) * (Gammaℝ s * H s)) (1/2 + t * I) := fun t ht =>
    analyticAt_const.mul ((LevinsonTurn.analyticAt_Gammaℝ (LevinsonLine.line_facts t).2.2).mul
      (hHa _ (hlineR t ht)))
  have hFne : ∀ t ∈ Icc a b,
      (fun s => I ^ (∑ ρ ∈ D, n ρ) * (Gammaℝ s * H s)) (1/2 + t * I) ≠ 0 := fun t ht =>
    mul_ne_zero (pow_ne_zero _ Complex.I_ne_zero)
      (mul_ne_zero (Gammaℝ_ne_zero_of_re_pos (LevinsonLine.line_facts t).2.2) (hHline t ht))
  have hFc : ContinuousOn (fun t : ℝ => I ^ (∑ ρ ∈ D, n ρ) *
      (Gammaℝ (1/2 + t * I) * H (1/2 + t * I))) (Icc a b) := fun t ht =>
    (ContinuousAt.comp (g := fun s => I ^ (∑ ρ ∈ D, n ρ) * (Gammaℝ s * H s))
      (f := fun t : ℝ => (1/2 + t * I : ℂ)) (hFa t ht).continuousAt
      LevinsonTurn.continuous_line.continuousAt).continuousWithinAt
  obtain ⟨φ, hφc, hφ⟩ := LevinsonArg.exists_arg_lift hab.le hFc hFne
  have hturn1 := LevinsonTurn.line_turn_eq_integral
    (f := fun s => I ^ (∑ ρ ∈ D, n ρ) * (Gammaℝ s * H s)) hab.le hFa hFne hφc hφ
  have hld : (∫ t in a..b, logDeriv (fun s => I ^ (∑ ρ ∈ D, n ρ) * (Gammaℝ s * H s))
      (1/2 + t * I)) = ∫ t in a..b, logDeriv (fun s => Gammaℝ s * H s) (1/2 + t * I) :=
    intervalIntegral.integral_congr fun t _ =>
      logDeriv_const_mul _ _ (pow_ne_zero _ Complex.I_ne_zero)
  have hsplit := LevinsonTurn.turn_split (G := H) hab.le (fun t ht => hHa _ (hlineR t ht)) hHline
  rw [hld, hsplit] at hturn1
  -- the sizes
  have hR := abs_le.mp (LevinsonSize.right_edge_le hc0.le hc1 hab.le)
  have hHa' := abs_le.mp (LevinsonEdge.horizontal_edge_le hc0.le hc1 ha hBot)
  have hHb' := abs_le.mp (LevinsonEdge.horizontal_edge_le hc0.le hc1 (by linarith) hTop)
  have hΓ := abs_le.mp (LevinsonSize.gamma_part_count_le_gt_two (by linarith) hab.le)
  have hlog : Real.log a ≤ Real.log b := Real.log_le_log (by linarith) hab.le
  have hlogπ : 21 * Real.pi * Real.log a ≤ 21 * Real.pi * Real.log b :=
    mul_le_mul_of_nonneg_left hlog (by positivity)
  -- the turning is at least `π (Q − K)`
  set C := Littlewood.countRight G ((1/2 : ℂ) + a * I) ((3 : ℂ) + b * I) (1/2) with hC_def
  set Kr : ℝ := ∑ ρ ∈ D, (n ρ : ℝ) with hKr
  set Q := (riemannZeta.N b - riemannZeta.N a) - 2 * C - (72 * Real.log b + 417) with hQ
  have hdiff : Real.pi * (Q - Kr) ≤ φ b - φ a := by
    have e1 : Real.pi * (Q - Kr) = Real.pi * (riemannZeta.N b - riemannZeta.N a)
        - 2 * Real.pi * C - (72 * Real.pi * Real.log b + 417 * Real.pi) - Real.pi * Kr := by
      rw [hQ]; ring
    rw [e1]
    rw [← hC] at hHturn
    linarith [hR.1, hHa'.2, hHb'.1, hΓ.1, hlogπ, hturn1, hHturn, hbot', htop', hrt', hPE]
  -- the floor
  set k : ℕ := ⌊max 0 (Q - Kr)⌋₊ with hk_def
  have hkle : (k : ℝ) ≤ max 0 (Q - Kr) := Nat.floor_le (le_max_left _ _)
  have hklt : max 0 (Q - Kr) < (k : ℝ) + 1 := Nat.lt_floor_add_one _
  have hmax : max 0 (Q - Kr) * Real.pi ≤ |φ b - φ a| := by
    rcases le_total (Q - Kr) 0 with h | h
    · rw [max_eq_left h, zero_mul]; exact abs_nonneg _
    · rw [max_eq_right h]
      linarith [le_abs_self (φ b - φ a)]
  have hk : (k : ℝ) * Real.pi ≤ |φ b - φ a| :=
    le_trans (mul_le_mul_of_nonneg_right hkle hπ.le) hmax
  obtain ⟨t, hmono, hmem, hcos⟩ := LevinsonArg.crossings_of_arg hab.le hφc k hk
  -- every crossing is a zero of `ζ`
  have hζt : ∀ i, riemannZeta (1/2 + t i * I) = 0 := by
    intro i
    have hti := hmem i
    have hreF : (I ^ (∑ ρ ∈ D, n ρ) * (Gammaℝ (1/2 + t i * I) * H (1/2 + t i * I))).re = 0 := by
      rw [hφ _ hti, Complex.re_ofReal_mul, Complex.exp_ofReal_mul_I_re, hcos i, mul_zero]
    apply (LevinsonLine.zeta_line_zero_iff c (t i) (hfac _ hti)).mpr
    have e1 : riemannZeta (1/2 + ↑(t i) * I) + ↑c * deriv riemannZeta (1/2 + ↑(t i) * I)
        = polyP D n (1/2 + ↑(t i) * I) * H (1/2 + ↑(t i) * I) := hGPH _
    rw [e1, polyP_line n (fun ρ hρ => (hDprop ρ hρ).1)]
    have e2 : Gammaℝ (1/2 + ↑(t i) * I) * (I ^ (∑ ρ ∈ D, n ρ)
        * ((∏ ρ ∈ D, (t i - ρ.im) ^ n ρ : ℝ) : ℂ) * H (1/2 + ↑(t i) * I))
        = ((∏ ρ ∈ D, (t i - ρ.im) ^ n ρ : ℝ) : ℂ)
          * (I ^ (∑ ρ ∈ D, n ρ) * (Gammaℝ (1/2 + t i * I) * H (1/2 + t i * I))) := by ring
    rw [e2, Complex.re_ofReal_mul, hreF, mul_zero]
  -- the count: crossings once, the zeros of `D` with their order
  set Γs : Finset ℝ := D.image (fun ρ => ρ.im) with hΓs
  set E : Finset ℝ := Finset.univ.image t ∪ Γs with hE
  have hmemE : ∀ γ ∈ E, (∃ i, t i = γ) ∨ ∃ ρ ∈ D, ρ.im = γ := by
    intro γ hγ
    rw [hE, Finset.mem_union, Finset.mem_image, hΓs, Finset.mem_image] at hγ
    rcases hγ with ⟨i, -, hi⟩ | ⟨ρ, hρ, hργ⟩
    · exact Or.inl ⟨i, hi⟩
    · exact Or.inr ⟨ρ, hρ, hργ⟩
  have hEζ : ∀ γ ∈ E, riemannZeta (1/2 + γ * I) = 0 := by
    intro γ hγ
    rcases hmemE γ hγ with ⟨i, rfl⟩ | ⟨ρ, hρ, rfl⟩
    · exact hζt i
    · rw [← hρeq ρ hρ]; exact hζD ρ hρ
  have hEpos : ∀ γ ∈ E, 0 < γ := by
    intro γ hγ
    rcases hmemE γ hγ with ⟨i, rfl⟩ | ⟨ρ, hρ, rfl⟩
    · linarith [(hmem i).1]
    · linarith [(hDprop ρ hρ).2.1]
  have hET : ∀ γ ∈ E, γ ≤ b := by
    intro γ hγ
    rcases hmemE γ hγ with ⟨i, rfl⟩ | ⟨ρ, hρ, rfl⟩
    · exact (hmem i).2
    · exact (hDprop ρ hρ).2.2.le
  have hsum := sum_order_le_lineCount E hEpos hET hEζ
  have hord : ∀ γ ∈ E, (1 : ℤ) + (if γ ∈ Γs then (n (1/2 + γ * I) : ℤ) else 0)
      ≤ riemannZeta.order (1/2 + γ * I) := by
    intro γ hγ
    split_ifs with hγΓ
    · rw [hΓs, Finset.mem_image] at hγΓ
      obtain ⟨ρ, hρ, rfl⟩ := hγΓ
      rw [← hρeq ρ hρ]
      have hR := ((hmemD ρ).mp hρ).1
      have hρ1 : ρ ≠ 1 := by
        intro h1
        have := (hDprop ρ hρ).1
        rw [h1, Complex.one_re] at this
        norm_num at this
      have h := zeta_order_ge hcne hρ1 (hζD ρ hρ) (hfin ρ hR)
      have hnρ : ((n ρ : ℕ) : ℤ) = ((analyticOrderAt G ρ).toNat : ℤ) := rfl
      linarith
    · have hmemZ : ((1/2 : ℂ) + (γ : ℂ) * I) ∈ NontrivialZeros := by
        refine ⟨?_, Set.mem_univ _, hEζ γ hγ⟩
        rw [HardyZ.re_line]
        norm_num
      have := riemannZeta_one_le_order_nontrivialZero ⟨_, hmemZ⟩
      simpa using this
  have hsumge : ((E.card : ℤ) + ∑ ρ ∈ D, (n ρ : ℤ)) ≤ ∑ γ ∈ E, riemannZeta.order (1/2 + γ * I) := by
    have h1 := Finset.sum_le_sum hord
    rw [Finset.sum_add_distrib, Finset.sum_const, nsmul_eq_mul, mul_one, Finset.sum_ite_mem,
      Finset.inter_eq_right.mpr Finset.subset_union_right] at h1
    have h2 : ∑ γ ∈ Γs, (n (1/2 + γ * I) : ℤ) = ∑ ρ ∈ D, (n ρ : ℤ) := by
      rw [hΓs, Finset.sum_image]
      · exact Finset.sum_congr rfl fun ρ hρ => by rw [← hρeq ρ hρ]
      · intro ρ₁ h₁ ρ₂ h₂ he
        rw [hρeq ρ₁ h₁, hρeq ρ₂ h₂]
        simp only at he
        rw [he]
    rw [h2] at h1
    exact h1
  have hcardE : k ≤ E.card := by
    have h1 : (Finset.univ.image t).card = k := by
      rw [Finset.card_image_of_injective _ hmono.injective, Finset.card_univ, Fintype.card_fin]
    rw [← h1]
    exact Finset.card_le_card Finset.subset_union_left
  have hfinal : ((k : ℤ) + ∑ ρ ∈ D, (n ρ : ℤ)) ≤ lineCount b := by
    have : (k : ℤ) ≤ E.card := by exact_mod_cast hcardE
    linarith
  have hfinalR : (k : ℝ) + Kr ≤ (lineCount b : ℝ) := by
    rw [hKr]
    exact_mod_cast hfinal
  have hQmax : Q - Kr ≤ max 0 (Q - Kr) := le_max_right _ _
  have hKr0 : 0 ≤ Kr := Finset.sum_nonneg fun _ _ => Nat.cast_nonneg _
  have e2 : (riemannZeta.N b - riemannZeta.N a) - 2 * C - (72 * Real.log b + 418) = Q - 1 := by
    rw [hQ]; ring
  rw [e2]
  linarith

set_option maxHeartbeats 400000 in
/-- **S11, the window theorem with no `hsimple`.** `LevinsonWindow.levinson_window` with the
hypothesis that every zero of `ζ` on `1/2 + [a, b] i` is simple removed: its step 4 is
`levinson_count'`, which divides the zeros of `G` on the line out and counts them. -/
theorem levinson_window' {T c σ₀ δ X a b K B : ℝ} {M : ℕ} {β : ℕ → ℂ}
    (hT : Real.exp 26 ≤ T) (hc : c = 1 / Real.log T)
    (hM : 1 ≤ M) (hβ1 : β 1 = 1) (hβ : ∀ h, ‖β h‖ ≤ B)
    (hσ₀ : σ₀ < 1 / 2) (hδ : 0 < δ) (hσδ : 1 / 4 ≤ σ₀ - δ)
    (hX : 3 ≤ X) (hXMB : 32 * M * B ≤ (2 : ℝ) ^ X) (hXa : 2 * X ≤ a)
    (hab : a + 3 ≤ b) (hbT : b ≤ T) (hK1 : 1 ≤ K)
    (hK : ∀ a' b' : ℝ, a ≤ a' → a' < b' → b' ≤ b → ∀ σ ∈ Icc (σ₀ - δ) σ₀,
      (1 / (b' - a')) * ∫ t in a'..b',
        ‖(riemannZeta (↑σ + ↑t * I) + c * deriv riemannZeta (↑σ + ↑t * I))
          * LevinsonMollEdge.molli M β (↑σ + ↑t * I)‖ ^ 2 ≤ K) :
    (riemannZeta.N b - riemannZeta.N a)
      - (1 / (Real.pi * (1 / 2 - σ₀))) * ((b - a) / 2 * Real.log K + windowE M B X T a b)
      - (134 * Real.log T + 2918) ≤ (lineCount b : ℝ) := by
  -- the constants
  have hL26 : (26 : ℝ) ≤ Real.log T := by
    have h := Real.log_le_log (Real.exp_pos 26) hT
    rwa [Real.log_exp] at h
  have hLpos : 0 < Real.log T := by linarith
  have hc0 : 0 ≤ c := by rw [hc]; positivity
  have hc1 : c ≤ 1 := by rw [hc, div_le_one hLpos]; linarith
  have hcpos : 0 < c := by rw [hc]; exact one_div_pos.mpr hLpos
  have hB1 : 1 ≤ B := by
    have := hβ 1
    rw [hβ1, norm_one] at this
    exact this
  have hT1 : 1 ≤ T := by linarith
  have ha4 : 4 ≤ a := by linarith
  have hδh := LevinsonMollEdge.tailDelta_le_half hM hB1 hXMB
  -- `G ψ` on `Re = X`
  have hreX : ∀ t : ℝ, 0 < ((riemannZeta (↑X + ↑t * I) + c * deriv riemannZeta (↑X + ↑t * I))
      * LevinsonMollEdge.molli M β (↑X + ↑t * I)).re := by
    intro t
    have h1 := LevinsonMollEdge.f_sub_one_le hc0 hc1 hM hβ1 hβ hX (s := ↑X + ↑t * I) (by simp)
    have h2 := Complex.abs_re_le_norm
      ((riemannZeta (↑X + ↑t * I) + c * deriv riemannZeta (↑X + ↑t * I))
        * LevinsonMollEdge.molli M β (↑X + ↑t * I) - 1)
    rw [Complex.sub_re, Complex.one_re, abs_le] at h2
    linarith [h2.1]
  have hneX : ∀ t : ℝ, (riemannZeta (↑X + ↑t * I) + c * deriv riemannZeta (↑X + ↑t * I))
      * LevinsonMollEdge.molli M β (↑X + ↑t * I) ≠ 0 := by
    intro t h
    have := hreX t
    rw [h, Complex.zero_re] at this
    exact lt_irrefl _ this
  have hFa : ∀ w : ℂ, w ≠ 1 → AnalyticAt ℂ
      (fun s => (riemannZeta s + c * deriv riemannZeta s) * LevinsonMollEdge.molli M β s) w :=
    fun w hw => LevinsonMollEdge.f_analyticAt c M β hw
  have hGa : ∀ w : ℂ, w ≠ 1 → AnalyticAt ℂ (fun s => riemannZeta s + c * deriv riemannZeta s) w :=
    fun w hw => LevinsonEdge.G_analyticAt c hw
  -- step 1: good heights
  obtain ⟨a', ha', hgA⟩ := LevinsonAvoid.exists_good_height
    (f := fun s => (riemannZeta s + c * deriv riemannZeta s) * LevinsonMollEdge.molli M β s)
    (σ₀ := σ₀ - δ) (X := X) (t₀ := a)
    (analyticOnNhd_rect_of_im hFa (by simp; linarith) (by simp; linarith))
    ⟨(X : ℂ) + (a : ℝ) * I, LevinsonAvoid.mem_rect_of
      (by simp) (by simp), hneX a⟩
  obtain ⟨b', hb', hgB⟩ := LevinsonAvoid.exists_good_height
    (f := fun s => (riemannZeta s + c * deriv riemannZeta s) * LevinsonMollEdge.molli M β s)
    (σ₀ := σ₀ - δ) (X := X) (t₀ := b - 1)
    (analyticOnNhd_rect_of_im hFa (by simp; linarith) (by simp; linarith))
    ⟨(X : ℂ) + ((b - 1 : ℝ) : ℂ) * I, LevinsonAvoid.mem_rect_of
      (by simp)
      (by simp), hneX (b - 1)⟩
  have hb'1 : b - 1 ≤ b' := hb'.1
  have hb'2 : b' ≤ b := by linarith [hb'.2]
  have ha'1 : a ≤ a' := ha'.1
  have ha'2 : a' ≤ a + 1 := ha'.2
  have ha'b' : a' < b' := by linarith
  -- step 2: a good abscissa
  obtain ⟨σ', hσ', hgL⟩ := LevinsonAvoid.exists_good_abscissa
    (f := fun s => (riemannZeta s + c * deriv riemannZeta s) * LevinsonMollEdge.molli M β s)
    (σ₀ := σ₀) (δ := δ) (X := X) (a := a') (b := b') hδ (by linarith)
    (analyticOnNhd_rect_of_im hFa (by simp; linarith) (by simp; linarith))
    ⟨(X : ℂ) + (a' : ℝ) * I, LevinsonAvoid.mem_rect_of
      (by simp)
      (by simp), hneX a'⟩
  have hσ'1 : σ₀ - δ ≤ σ' := hσ'.1
  have hσ'2 : σ' ≤ σ₀ := hσ'.2
  -- step 3: `G ψ ≠ 0` on the border of `[σ', X] × [a', b']`
  have hBR : ∀ p ∈ RectangleBorder ((σ' : ℂ) + a' * I) ((X : ℂ) + b' * I),
      (riemannZeta p + c * deriv riemannZeta p) * LevinsonMollEdge.molli M β p ≠ 0 := by
    intro p hp
    have e1 : ((σ' : ℂ) + a' * I).re = σ' := by simp
    have e2 : ((σ' : ℂ) + a' * I).im = a' := by simp
    have e3 : ((X : ℂ) + b' * I).re = X := by simp
    have e4 : ((X : ℂ) + b' * I).im = b' := by simp
    have hcases := border_cases (by rw [e1, e3]; linarith) (by rw [e2, e4]; linarith) hp
    rw [e1, e2, e3, e4] at hcases
    have hp' : p = ↑p.re + ↑p.im * I := (Complex.re_add_im p).symm
    rcases hcases with ⟨him, hre⟩ | ⟨hre, him⟩ | ⟨him, hre⟩ | ⟨hre, him⟩
    · rw [hp', him]; exact hgA p.re ⟨by linarith [hre.1], hre.2⟩
    · rw [hp', hre]; exact hgL p.im him
    · rw [hp', him]; exact hgB p.re ⟨by linarith [hre.1], hre.2⟩
    · rw [hp', hre]; exact hneX p.im
  have hGR : AnalyticOnNhd ℂ (fun s => riemannZeta s + c * deriv riemannZeta s)
      (Rectangle ((σ' : ℂ) + a' * I) ((X : ℂ) + b' * I)) :=
    analyticOnNhd_rect_of_im hGa (by simp; linarith) (by simp; linarith)
  have hψR : AnalyticOnNhd ℂ (LevinsonMollEdge.molli M β)
      (Rectangle ((σ' : ℂ) + a' * I) ((X : ℂ) + b' * I)) :=
    fun p _ => (LevinsonMollEdge.molli_differentiable M β).analyticAt p
  have hLR := LevinsonRight.levinson_right (G := fun s => riemannZeta s + c * deriv riemannZeta s)
    (M := LevinsonMollEdge.molli M β) (σ₀ := σ') (X := X) (a := a') (b := b')
    (by linarith) (by linarith) ha'b' hGR hψR hBR
  -- the edge terms
  have hRT := LevinsonMollEdge.right_terms_le hc0 hc1 hM hβ1 hβ (σ₀ := σ') (a := a') (b := b')
    hX hXMB (by linarith) ha'b'.le
  have hHa := abs_le.mp (LevinsonMollEdge.horizontal_terms_le hc0 hc1 hM hβ1 hβ (σ₀ := σ')
    (T := a') hX hXMB (by linarith) (by linarith) (by linarith)
    (fun x hx => hgA x ⟨by linarith [hx.1], hx.2⟩))
  have hHb := abs_le.mp (LevinsonMollEdge.horizontal_terms_le hc0 hc1 hM hβ1 hβ (σ₀ := σ')
    (T := b') hX hXMB (by linarith) (by linarith) (by linarith)
    (fun x hx => hgB x ⟨by linarith [hx.1], hx.2⟩))
  have hmean := half_log_mean_le ha'b'.le hK1 (hK a' b' ha'1 ha'b' hb'2 σ' hσ')
  -- the size comparisons
  have hπ := Real.pi_pos
  have hM1 : (1 : ℝ) ≤ M := by exact_mod_cast hM
  have hlM : 0 ≤ Real.log (M : ℝ) := Real.log_nonneg hM1
  have hlB : 0 ≤ Real.log B := Real.log_nonneg hB1
  have hlK : 0 ≤ Real.log K := Real.log_nonneg hK1
  have hla' : Real.log a' ≤ Real.log T := Real.log_le_log (by linarith) (by linarith)
  have hlb' : Real.log b' ≤ Real.log T := Real.log_le_log (by linarith) (by linarith)
  have hla'0 : 0 ≤ Real.log a' := Real.log_nonneg (by linarith)
  have hlb'0 : 0 ≤ Real.log b' := Real.log_nonneg (by linarith)
  have htd := tailDelta_nonneg (M := M) (X := X) (by linarith : (0 : ℝ) ≤ B)
  have hP : ∀ y : ℝ, 0 ≤ Real.log y → Real.log y ≤ Real.log T →
      (X - σ') * (Real.pi * ((8 * X - 1) * (Real.log y + Real.log M + Real.log B + 8) + 1))
        ≤ X * (Real.pi * ((8 * X - 1) * (Real.log T + Real.log M + Real.log B + 8) + 1)) := by
    intro y hy0 hyT
    have hin : (8 * X - 1) * (Real.log y + Real.log M + Real.log B + 8)
        ≤ (8 * X - 1) * (Real.log T + Real.log M + Real.log B + 8) :=
      mul_le_mul_of_nonneg_left (by linarith) (by linarith)
    have hin0 : 0 ≤ (8 * X - 1) * (Real.log y + Real.log M + Real.log B + 8) :=
      mul_nonneg (by linarith) (by linarith)
    exact mul_le_mul (by linarith) (mul_le_mul_of_nonneg_left (by linarith) hπ.le)
      (mul_nonneg hπ.le (by linarith)) (by linarith)
  have hPa := hP a' hla'0 hla'
  have hPb := hP b' hlb'0 hlb'
  have hlen : (b' - a') / 2 * Real.log K ≤ (b - a) / 2 * Real.log K :=
    mul_le_mul_of_nonneg_right (by linarith) hlK
  have hlen2 : (b' - a') * (2 * LevinsonMollEdge.tailDelta M B X)
      ≤ (b - a) * (2 * LevinsonMollEdge.tailDelta M B X) :=
    mul_le_mul_of_nonneg_right (by linarith) (by linarith)
  have hσπ : 0 ≤ σ' * Real.pi := mul_nonneg (by linarith) hπ.le
  set U := (b - a) / 2 * Real.log K + windowE M B X T a b with hU
  have hU0 : 0 ≤ U := by
    have := windowE_nonneg (T := T) (a := a) (b := b) hM hB1 hX hT1 (by linarith)
    have h2 : 0 ≤ (b - a) / 2 * Real.log K := mul_nonneg (by linarith) hlK
    rw [hU]; linarith
  -- steps 3–4 assembled: the count right of the line with right side `X`
  have hf'pos : 0 < 1 / (2 * Real.pi * (1 / 2 - σ')) := by
    have : 0 < 1 / 2 - σ' := by linarith
    positivity
  have hCX : countRight (fun s => riemannZeta s + c * deriv riemannZeta s)
      ((1 / 2 : ℂ) + a' * I) ((X : ℂ) + b' * I) (1 / 2)
        ≤ 1 / (2 * Real.pi * (1 / 2 - σ')) * U := by
    refine le_trans hLR (mul_le_mul_of_nonneg_left ?_ hf'pos.le)
    rw [hU]
    unfold windowE
    linarith [hRT, hHa.1, hHa.2, hHb.1, hHb.2, hmean, hPa, hPb, hlen, hlen2, hσπ]
  have hff : 1 / (2 * Real.pi * (1 / 2 - σ')) ≤ 1 / (2 * Real.pi * (1 / 2 - σ₀)) := by
    have h0 : 0 < 2 * Real.pi * (1 / 2 - σ₀) := by
      have : 0 < 1 / 2 - σ₀ := by linarith
      positivity
    exact one_div_le_one_div_of_le h0
      (mul_le_mul_of_nonneg_left (by linarith) (by positivity))
  have hCX' : countRight (fun s => riemannZeta s + c * deriv riemannZeta s)
      ((1 / 2 : ℂ) + a' * I) ((X : ℂ) + b' * I) (1 / 2)
        ≤ 1 / (2 * Real.pi * (1 / 2 - σ₀)) * U :=
    le_trans hCX (mul_le_mul_of_nonneg_right hff hU0)
  -- step 5: from the right side `3` to `X`
  have hsub : Rectangle ((1 / 2 : ℂ) + a' * I) ((3 : ℂ) + b' * I)
      ⊆ Rectangle ((1 / 2 : ℂ) + a' * I) ((X : ℂ) + b' * I) := by
    intro p hp
    rw [Rectangle] at hp ⊢
    obtain ⟨h1, h2⟩ := mem_reProdIm.mp hp
    refine mem_reProdIm.mpr ⟨?_, by simpa using h2⟩
    have e1 : ((1 / 2 : ℂ) + a' * I).re = 1 / 2 := by simp
    have e3 : ((3 : ℂ) + b' * I).re = 3 := by simp
    have eX : ((X : ℂ) + b' * I).re = X := by simp
    rw [e1, e3, uIcc_of_le (by norm_num)] at h1
    rw [e1, eX, uIcc_of_le (by linarith)]
    exact ⟨h1.1, le_trans h1.2 hX⟩
  have hGX : AnalyticOnNhd ℂ (fun s => riemannZeta s + c * deriv riemannZeta s)
      (Rectangle ((1 / 2 : ℂ) + a' * I) ((X : ℂ) + b' * I)) :=
    analyticOnNhd_rect_of_im hGa (by simp; linarith) (by simp; linarith)
  have hGz : riemannZeta ((1 / 2 : ℂ) + a' * I) + c * deriv riemannZeta ((1 / 2 : ℂ) + a' * I)
      ≠ 0 := by
    have h := hgA (1 / 2) ⟨by linarith, by linarith⟩
    push_cast at h
    exact left_ne_zero_of_mul h
  have h3X := countRight_right_le (σ := 1 / 2) hsub hGX hGz
  -- step 4: `levinson_count'` on `[1/2, 3] × [a', b']`, no hypothesis on the line
  have hfac : ∀ t ∈ Icc a' b',
      1 - c * (deriv Gammaℝ (1/2 + t * I) / Gammaℝ (1/2 + t * I)).re ≠ 0 := by
    intro t ht
    rw [hc]
    exact (LevinsonAvoid.factor_pos hT ⟨by linarith [ht.1], by linarith [ht.2]⟩).ne'
  have hLC := levinson_count' hcpos hc1 (by linarith : (4 : ℝ) ≤ a') ha'b'
    (fun x hx => left_ne_zero_of_mul (hgA x ⟨by linarith [hx.1], by linarith [hx.2]⟩))
    (fun x hx => left_ne_zero_of_mul (hgB x ⟨by linarith [hx.1], by linarith [hx.2]⟩))
    hfac
  -- step 5: the line count and `N` at the shifted heights
  have hLb : (lineCount b' : ℝ) ≤ (lineCount b : ℝ) := by
    exact_mod_cast lineCount_mono hb'2
  have hNb := N_step_le (t := b - 1) (u := b) (by linarith) (by linarith) (by linarith)
  have hNa := N_step_le (t := a) (u := a + 1) (by linarith) (by linarith) (by linarith)
  have hNb' := ArgCount.N_mono hb'1
  have hNa' := ArgCount.N_mono ha'2
  have hlb : Real.log b ≤ Real.log T := Real.log_le_log (by linarith) hbT
  have hla1 : Real.log (a + 1) ≤ Real.log T := Real.log_le_log (by linarith) (by linarith)
  -- step 6: the factor
  have e2 : 1 / (Real.pi * (1 / 2 - σ₀)) * U = 2 * (1 / (2 * Real.pi * (1 / 2 - σ₀)) * U) := by
    have h1 : (1 / 2 - σ₀) ≠ 0 := by linarith
    have h2 : Real.pi ≠ 0 := hπ.ne'
    field_simp
    try ring
  rw [e2]
  linarith [hLC, hLb, hNb, hNa, hNb', hNa', hlb, hla1, hlb', h3X, hCX']

/-- info: 'LevinsonMultiple.exists_prod_mul' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms exists_prod_mul

/-- info: 'LevinsonMultiple.G_order_add_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms G_order_add_one

/-- info: 'LevinsonMultiple.zeta_order_ge' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms zeta_order_ge

/-- info: 'LevinsonMultiple.sum_order_le_lineCount' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms sum_order_le_lineCount

/-- info: 'LevinsonMultiple.countRight_eq_of_mul' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms countRight_eq_of_mul

/-- info: 'LevinsonMultiple.factor_turn' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms factor_turn

/-- info: 'LevinsonMultiple.polyP_edges' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms polyP_edges

/-- info: 'LevinsonMultiple.levinson_count'' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms levinson_count'

/-- info: 'LevinsonMultiple.levinson_window'' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms levinson_window'

end LevinsonMultiple
