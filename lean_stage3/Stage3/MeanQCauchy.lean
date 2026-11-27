/-
MeanQCauchy — block S13 of `lean_stage3/design/stencil.md`, B4 step 3, the mean value with a
general Q: the operator `Q(−∂α/L) Q(−∂β/L)` and Cauchy's estimate for it. 2026-11-25.

`OperatorCauchy`'s `Dop` is the degree-1 case. Here `pkl f k l = ∂β^l ∂α^k f`, the `α`-derivatives
taken first, and `DopQ Q L f = Σ_{k,l ≤ d} q_k q_l (−1/L)^{k+l} pkl f k l`. For `Q = 1 − x` this is
`Dop` term by term.

**Sizes.** Cauchy's estimate one variable at a time on circles of radius `ρ = r/L`
(`Complex.norm_iteratedDeriv_le_of_forall_mem_sphere_norm_le`):
`‖pkl f k l‖ ≤ l!·k!·S/ρ^{k+l}`, and `(1/L)^{k+l}/ρ^{k+l} = 1/r^{k+l}` is a constant, so
`‖DopQ f‖ ≤ S·(Σ_k |q_k| k!/r^k)²`: no power of `L` is lost at any degree.

  | name                  | statement                                                     | status |
  |-----------------------|---------------------------------------------------------------|--------|
  | `pkl`, `qc`, `DopQ`   | `∂β^l ∂α^k f`; `q_k (−1/L)^k`; the operator                    | defined |
  | `pkl_norm_le`         | `‖f‖ ≤ S` on the polydisc ⊢ `‖pkl f k l‖ ≤ l!(k! S/ρ^k)/ρ^l`    | PROVED |
  | `DopQ_norm_le`        | at `ρ = r/L`: `‖DopQ f‖ ≤ S (Σ_k |q_k| k!/r^k)²`               | PROVED |
  | `DopQ_sub_mul`        | `DopQ (A − B·c) = DopQ A − DopQ B · c` (analytic partials)     | PROVED |
  | `analytic_iterPartial`| `F` analytic on open `U ⊆ ℂ²` ⊢ `∂α^k F` analytic on `U`        | PROVED |
  | `DopQ_one_sub`        | `Q = 1 − X` ⊢ `DopQ = Operator.Dop` (with `∂β∂α` = `pab`)       | PROVED |

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.OperatorCauchy

noncomputable section

namespace MeanQ

open Complex Polynomial Metric Filter Topology

/-- `∂β^l ∂α^k f (α, β)`: `k` derivatives in the first variable at `α`, then `l` in the second. -/
def pkl (f : ℂ → ℂ → ℂ) (k l : ℕ) (α β : ℂ) : ℂ :=
  iteratedDeriv l (fun y => iteratedDeriv k (fun x => f x y) α) β

/-- `q_k (−1/L)^k`, `q_k = Q.coeff k`. -/
def qc (Q : ℝ[X]) (L : ℝ) (k : ℕ) : ℂ := ((Q.coeff k * (-1 / L) ^ k : ℝ) : ℂ)

/-- **The operator** `Q(−∂α/L) Q(−∂β/L)`: `Σ_{k,l ≤ d} q_k q_l (−1/L)^{k+l} ∂β^l ∂α^k f`. -/
def DopQ (Q : ℝ[X]) (L : ℝ) (f : ℂ → ℂ → ℂ) (α β : ℂ) : ℂ :=
  ∑ k ∈ Finset.range (Q.natDegree + 1), ∑ l ∈ Finset.range (Q.natDegree + 1),
    qc Q L k * qc Q L l * pkl f k l α β

/-- Cauchy's estimate on a closed disc, from differentiability on it. -/
theorem cauchy_disc {f : ℂ → ℂ} {c : ℂ} {ρ S : ℝ} (hρ : 0 < ρ) (n : ℕ)
    (hf : ∀ z ∈ closedBall c ρ, DifferentiableAt ℂ f z)
    (hS : ∀ z ∈ closedBall c ρ, ‖f z‖ ≤ S) :
    ‖iteratedDeriv n f c‖ ≤ n.factorial * S / ρ ^ n := by
  apply Complex.norm_iteratedDeriv_le_of_forall_mem_sphere_norm_le n hρ
  · apply DifferentiableOn.diffContOnCl
    rw [closure_ball c hρ.ne']
    exact fun z hz => (hf z hz).differentiableWithinAt
  · exact fun z hz => hS z (sphere_subset_closedBall hz)

/-- **Cauchy's estimate for `pkl`**, one variable at a time, on the closed polydisc of radius `ρ`. -/
theorem pkl_norm_le {F : ℂ → ℂ → ℂ} {α₀ β₀ : ℂ} {ρ S : ℝ} (hρ : 0 < ρ) (k l : ℕ)
    (hFa : ∀ y ∈ closedBall β₀ ρ, ∀ x ∈ closedBall α₀ ρ, DifferentiableAt ℂ (fun x => F x y) x)
    (hFb : ∀ y ∈ closedBall β₀ ρ,
      DifferentiableAt ℂ (fun y => iteratedDeriv k (fun x => F x y) α₀) y)
    (hS : ∀ x ∈ closedBall α₀ ρ, ∀ y ∈ closedBall β₀ ρ, ‖F x y‖ ≤ S) :
    ‖pkl F k l α₀ β₀‖ ≤ l.factorial * (k.factorial * S / ρ ^ k) / ρ ^ l := by
  have h1 : ∀ y ∈ closedBall β₀ ρ,
      ‖iteratedDeriv k (fun x => F x y) α₀‖ ≤ k.factorial * S / ρ ^ k :=
    fun y hy => cauchy_disc hρ k (fun x hx => hFa y hy x hx) (fun x hx => hS x hx y hy)
  exact cauchy_disc hρ l hFb h1

theorem norm_qc (Q : ℝ[X]) {L : ℝ} (hL : 0 < L) (k : ℕ) :
    ‖qc Q L k‖ = |Q.coeff k| / L ^ k := by
  rw [qc, Complex.norm_real, Real.norm_eq_abs, abs_mul, abs_pow, abs_div, abs_neg, abs_one,
    abs_of_pos hL, one_div_pow, mul_one_div]

/-- The constant of `DopQ`'s bound: `Σ_k |q_k| k!/r^k`. -/
def Kq (Q : ℝ[X]) (r : ℝ) : ℝ :=
  ∑ k ∈ Finset.range (Q.natDegree + 1), |Q.coeff k| * k.factorial / r ^ k

theorem Kq_nonneg (Q : ℝ[X]) {r : ℝ} (hr : 0 < r) : 0 ≤ Kq Q r :=
  Finset.sum_nonneg fun _ _ => by positivity

/-- **The size of `DopQ f`** at the radius `ρ = r/L`: `‖DopQ f‖ ≤ S (Σ_k |q_k| k!/r^k)²`. -/
theorem DopQ_norm_le (Q : ℝ[X]) {F : ℂ → ℂ → ℂ} {α₀ β₀ : ℂ} {L r S : ℝ} (hL : 0 < L)
    (hr : 0 < r)
    (hFa : ∀ y ∈ closedBall β₀ (r / L), ∀ x ∈ closedBall α₀ (r / L),
      DifferentiableAt ℂ (fun x => F x y) x)
    (hFb : ∀ k, ∀ y ∈ closedBall β₀ (r / L),
      DifferentiableAt ℂ (fun y => iteratedDeriv k (fun x => F x y) α₀) y)
    (hS : ∀ x ∈ closedBall α₀ (r / L), ∀ y ∈ closedBall β₀ (r / L), ‖F x y‖ ≤ S) :
    ‖DopQ Q L F α₀ β₀‖ ≤ S * Kq Q r ^ 2 := by
  have hρ : 0 < r / L := div_pos hr hL
  have hS0 : 0 ≤ S := le_trans (norm_nonneg _)
    (hS α₀ (mem_closedBall_self hρ.le) β₀ (mem_closedBall_self hρ.le))
  unfold DopQ
  rw [sq, Kq, Finset.sum_mul_sum, Finset.mul_sum]
  refine (norm_sum_le _ _).trans (Finset.sum_le_sum fun k _ => ?_)
  rw [Finset.mul_sum]
  refine (norm_sum_le _ _).trans (Finset.sum_le_sum fun l _ => ?_)
  have hp := pkl_norm_le hρ k l hFa (hFb k) hS
  rw [norm_mul, norm_mul, norm_qc Q hL, norm_qc Q hL]
  have e : (l.factorial : ℝ) * (k.factorial * S / (r / L) ^ k) / (r / L) ^ l =
      S * k.factorial * l.factorial * L ^ k * L ^ l / (r ^ k * r ^ l) := by
    rw [div_pow, div_pow]
    field_simp
  rw [e] at hp
  have hLk : 0 < L ^ k := pow_pos hL k
  have hLl : 0 < L ^ l := pow_pos hL l
  calc |Q.coeff k| / L ^ k * (|Q.coeff l| / L ^ l) * ‖pkl F k l α₀ β₀‖
      ≤ |Q.coeff k| / L ^ k * (|Q.coeff l| / L ^ l) *
          (S * k.factorial * l.factorial * L ^ k * L ^ l / (r ^ k * r ^ l)) :=
        mul_le_mul_of_nonneg_left hp (by positivity)
    _ = S * (|Q.coeff k| * k.factorial / r ^ k * (|Q.coeff l| * l.factorial / r ^ l)) := by
        field_simp

/-! ### Linearity -/

/-- `∂α^k (A − B·c) = ∂α^k A − ∂α^k B · c` at a point where both are analytic. -/
theorem iteratedDeriv_sub_mul {A B : ℂ → ℂ} {c x : ℂ} (k : ℕ) (hA : AnalyticAt ℂ A x)
    (hB : AnalyticAt ℂ B x) :
    iteratedDeriv k (fun z => A z - B z * c) x = iteratedDeriv k A x - iteratedDeriv k B x * c := by
  have hB' : ContDiffAt ℂ k (fun z => B z * c) x := (hB.mul analyticAt_const).contDiffAt
  rw [iteratedDeriv_fun_sub (f := A) (g := fun z => B z * c) hA.contDiffAt hB',
    iteratedDeriv_mul_const_field]

/-- **`pkl` is linear** under analyticity of the slices and of the `α`-derivatives in `β`. -/
theorem pkl_sub_mul {A B : ℂ → ℂ → ℂ} {c α₀ β₀ : ℂ} (k l : ℕ)
    (hAa : ∀ᶠ y in 𝓝 β₀, AnalyticAt ℂ (fun x => A x y) α₀)
    (hBa : ∀ᶠ y in 𝓝 β₀, AnalyticAt ℂ (fun x => B x y) α₀)
    (hAb : AnalyticAt ℂ (fun y => iteratedDeriv k (fun x => A x y) α₀) β₀)
    (hBb : AnalyticAt ℂ (fun y => iteratedDeriv k (fun x => B x y) α₀) β₀) :
    pkl (fun x y => A x y - B x y * c) k l α₀ β₀ = pkl A k l α₀ β₀ - pkl B k l α₀ β₀ * c := by
  have hev : (fun y => iteratedDeriv k (fun x => A x y - B x y * c) α₀) =ᶠ[𝓝 β₀]
      fun y => iteratedDeriv k (fun x => A x y) α₀ - iteratedDeriv k (fun x => B x y) α₀ * c := by
    filter_upwards [hAa, hBa] with y ha hb
    exact iteratedDeriv_sub_mul k ha hb
  unfold pkl
  rw [hev.iteratedDeriv_eq l]
  exact iteratedDeriv_sub_mul l hAb hBb

/-- **`DopQ` is linear**: `DopQ (A − B·c) = DopQ A − DopQ B · c`. -/
theorem DopQ_sub_mul (Q : ℝ[X]) (L : ℝ) {A B : ℂ → ℂ → ℂ} {c α₀ β₀ : ℂ}
    (hAa : ∀ᶠ y in 𝓝 β₀, AnalyticAt ℂ (fun x => A x y) α₀)
    (hBa : ∀ᶠ y in 𝓝 β₀, AnalyticAt ℂ (fun x => B x y) α₀)
    (hAb : ∀ k, AnalyticAt ℂ (fun y => iteratedDeriv k (fun x => A x y) α₀) β₀)
    (hBb : ∀ k, AnalyticAt ℂ (fun y => iteratedDeriv k (fun x => B x y) α₀) β₀) :
    DopQ Q L (fun x y => A x y - B x y * c) α₀ β₀ = DopQ Q L A α₀ β₀ - DopQ Q L B α₀ β₀ * c := by
  unfold DopQ
  rw [Finset.sum_mul, ← Finset.sum_sub_distrib]
  refine Finset.sum_congr rfl fun k _ => ?_
  rw [Finset.sum_mul, ← Finset.sum_sub_distrib]
  refine Finset.sum_congr rfl fun l _ => ?_
  rw [pkl_sub_mul k l hAa hBa (hAb k) (hBb k)]
  ring

/-! ### Analytic functions of two variables -/

/-- The `k`-th partial in the first variable of a function on `ℂ × ℂ`. -/
def iterPartial (F : ℂ × ℂ → ℂ) (k : ℕ) (p : ℂ × ℂ) : ℂ :=
  iteratedDeriv k (fun x => F (x, p.2)) p.1

theorem iterPartial_succ (F : ℂ × ℂ → ℂ) (k : ℕ) (p : ℂ × ℂ) :
    iterPartial F (k + 1) p = deriv (fun x => iterPartial F k (x, p.2)) p.1 := by
  unfold iterPartial
  rw [iteratedDeriv_succ]

/-- **`∂α^k F` is analytic** where `F` is, on an open `U ⊆ ℂ × ℂ`. -/
theorem analytic_iterPartial {F : ℂ × ℂ → ℂ} {U : Set (ℂ × ℂ)} (hU : IsOpen U)
    (hF : AnalyticOnNhd ℂ F U) (k : ℕ) : AnalyticOnNhd ℂ (iterPartial F k) U := by
  induction k with
  | zero =>
    have e : iterPartial F 0 = F := by
      funext p
      simp [iterPartial]
    rw [e]
    exact hF
  | succ k ih =>
    have hx : ∀ (a b : ℂ), HasDerivAt (fun x : ℂ => (x, b)) ((1 : ℂ), (0 : ℂ)) a :=
      fun a b => (hasDerivAt_id a).prodMk (hasDerivAt_const a b)
    have hG : AnalyticOnNhd ℂ (fun p => fderiv ℂ (iterPartial F k) p ((1 : ℂ), (0 : ℂ))) U :=
      fun p hp => ((ContinuousLinearMap.apply ℂ ℂ ((1 : ℂ), (0 : ℂ))).analyticAt _).comp
        (ih.fderiv p hp)
    refine hG.congr hU fun p hp => ?_
    rw [iterPartial_succ]
    have h := ((ih p hp).differentiableAt.hasFDerivAt).comp_hasDerivAt p.1 (hx p.1 p.2)
    exact h.deriv.symm

/-- **The slices of a two-variable analytic function**: for `(α₀, β₀) ∈ U` open, the
`α`-slices are analytic at `α₀` for `β` near `β₀`, and every `∂α^k` is analytic in `β` at `β₀`. -/
theorem slices_of_analytic {F : ℂ × ℂ → ℂ} {U : Set (ℂ × ℂ)} (hU : IsOpen U)
    (hF : AnalyticOnNhd ℂ F U) {α₀ β₀ : ℂ} (h0 : (α₀, β₀) ∈ U) :
    (∀ᶠ y in 𝓝 β₀, AnalyticAt ℂ (fun x => F (x, y)) α₀) ∧
      ∀ k, AnalyticAt ℂ (fun y => iteratedDeriv k (fun x => F (x, y)) α₀) β₀ := by
  have hc : Continuous fun y : ℂ => (α₀, y) := by fun_prop
  have hmem : ∀ᶠ y in 𝓝 β₀, (α₀, y) ∈ U :=
    hc.continuousAt.preimage_mem_nhds (hU.mem_nhds h0)
  refine ⟨?_, fun k => ?_⟩
  · filter_upwards [hmem] with y hy
    have hp : AnalyticAt ℂ (fun x : ℂ => (x, y)) α₀ := analyticAt_id.prod analyticAt_const
    exact AnalyticAt.comp_of_eq (g := F) (f := fun x : ℂ => (x, y)) (hF _ hy) hp rfl
  · have hp : AnalyticAt ℂ (fun y : ℂ => (α₀, y)) β₀ := analyticAt_const.prod analyticAt_id
    exact (analytic_iterPartial hU hF k (α₀, β₀) h0).comp hp

/-! ### Degree one -/

/-- **`DopQ` at `Q = 1 − X` is `Dop`.** -/
theorem DopQ_one_sub (L : ℝ) (f : ℂ → ℂ → ℂ) (α β : ℂ) :
    DopQ (1 - X) L f α β = Operator.Dop L f α β := by
  have hdeg : (1 - X : ℝ[X]).natDegree = 1 := by
    rw [sub_eq_add_neg, ← C_1, add_comm, natDegree_add_C, natDegree_neg, natDegree_X]
  have c0 : (1 - X : ℝ[X]).coeff 0 = 1 := by simp
  have c1 : (1 - X : ℝ[X]).coeff 1 = -1 := by
    rw [coeff_sub, coeff_one, coeff_X_one]
    norm_num
  unfold DopQ
  rw [hdeg]
  simp only [Finset.sum_range_succ, Finset.sum_range_zero, zero_add]
  simp only [qc, c0, c1, pkl, iteratedDeriv_zero, iteratedDeriv_one, pow_zero, pow_one]
  unfold Operator.Dop Operator.pa Operator.pb Operator.pab Operator.pa
  push_cast
  ring

/-- info: 'MeanQ.pkl_norm_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms pkl_norm_le

/-- info: 'MeanQ.DopQ_norm_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms DopQ_norm_le

/-- info: 'MeanQ.DopQ_sub_mul' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms DopQ_sub_mul

/-- info: 'MeanQ.analytic_iterPartial' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms analytic_iterPartial

/-- info: 'MeanQ.DopQ_one_sub' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms DopQ_one_sub

end MeanQ

end
