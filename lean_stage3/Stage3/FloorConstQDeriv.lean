/-
# FloorConstQDeriv — block S13 of `lean_stage3/design/stencil.md`, B4 step 4, the closed form for a general Q: the iterated partials. 2026-11-25.

The general-`Q` operator `MeanQ.DopQ` takes `∂β^l ∂α^k` of Young's `c(α,β)` for every `k, l ≤ deg Q`.
After the substitution `a = Lα`, `b = Lβ`, `c` is `g₁(a+b) + a b g₂(a+b)` with `g₁, g₂` analytic
functions of one variable `u = a + b` near `u₀ = −2R` (`FloorConstQLimit.FF`), and every partial is
explicit:

* `pkl_scale`: `pkl f k l α₀ β₀ = c^k c^l pkl g k l (cα₀) (cβ₀)` when `f(x,y) = g(cx, cy)` near the
  point; no smoothness is needed (`deriv_comp_mul_left`);
* `pkl_sum`: `∂y^l ∂x^k [g₁(x+y) + x y g₂(x+y)]` at `(x₀, y₀)` is
  `g₁^(l+k) + y₀(x₀ g₂^(l+k) + k g₂^(l+(k−1))) + l(x₀ g₂^(l−1+k) + k g₂^(l−1+(k−1)))` at `x₀ + y₀`
  (Leibniz for `x·ψ(x)`, `iteratedDeriv_id_mul`);
* `phi_iter`: `φ(u) = (1 − e^(−u))/u` has `u₀ φ^(n)(u₀) + n φ^(n−1)(u₀) = [n = 0] − (−1)^n e^(−u₀)`,
  so at `u₀ = −2R` the derivatives are the real recursion `ph R n` (`phi_iter_real`).

| name | content | status |
|---|---|---|
| `iteratedDeriv_comp_mul` | `(f(c·))^(n) = cⁿ f^(n)(c·)`, no hypotheses | proved |
| `iteratedDeriv_iteratedDeriv'` | `(f^(k))^(l) = f^(l+k)` | proved |
| `iteratedDeriv_id_mul` | `(x ψ)^(n) = x ψ^(n) + n ψ^(n−1)`, `ψ` `Cⁿ` at the point | proved |
| `inner_sum`, `pkl_sum` | the partials of `g₁(x+y) + x y g₂(x+y)` | proved |
| `pkl_scale` | the scaling of `pkl` | proved |
| `phi`, `ph` | `(1 − e^(−u))/u`; the real recursion at `−2R` | defined |
| `phi_analyticAt`, `phi_rec` | analytic off `0`; the recursion | proved |
| `phi_iter_real` | `φ^(n)(−2R) = ph R n`, `R ≠ 0` | proved |
| `iteratedDeriv_one_add_exp` | `(1 + e^(−u))^(n) = [n = 0] + (−1)^n e^(−u)` | proved |

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Stage3.MeanQCauchy

namespace FloorConstQ

open Complex Filter Topology

noncomputable section

/-- `φ(u) = (1 − e^(−u))/u`. -/
def phi (u : ℂ) : ℂ := (1 - cexp (-u)) / u

/-- `φ^(n)(−2R)` as a real recursion: `ph 0 = (1 − e^(2R))/(−2R)`,
`ph (n+1) = (−(−1)^(n+1) e^(2R) − (n+1) ph n)/(−2R)`. -/
def ph (R : ℝ) : ℕ → ℝ
  | 0 => (1 - Real.exp (2 * R)) / (-(2 * R))
  | n + 1 => (-(-1) ^ (n + 1) * Real.exp (2 * R) - ((n : ℝ) + 1) * ph R n) / (-(2 * R))

end

/-- **Scaling**, with no smoothness hypothesis. -/
theorem iteratedDeriv_comp_mul (f : ℂ → ℂ) (c : ℂ) (n : ℕ) :
    iteratedDeriv n (fun x => f (c * x)) = fun x => c ^ n * iteratedDeriv n f (c * x) := by
  induction n with
  | zero => funext x; simp
  | succ n ih =>
    rw [iteratedDeriv_succ, ih, deriv_const_mul_field']
    funext x
    have h := deriv_comp_mul_left (f := iteratedDeriv n f) (c := c) (x := x)
    rw [h, iteratedDeriv_succ, smul_eq_mul, pow_succ]
    ring

theorem iteratedDeriv_iteratedDeriv' (f : ℂ → ℂ) (k l : ℕ) :
    iteratedDeriv l (iteratedDeriv k f) = iteratedDeriv (l + k) f := by
  simp only [iteratedDeriv_eq_iterate]
  funext x
  rw [Function.iterate_add_apply]

/-- **Leibniz for `x·ψ(x)`.** -/
theorem iteratedDeriv_id_mul {ψ : ℂ → ℂ} {x : ℂ} (n : ℕ) (h : ContDiffAt ℂ n ψ x) :
    iteratedDeriv n (fun z => z * ψ z) x =
      x * iteratedDeriv n ψ x + n * iteratedDeriv (n - 1) ψ x := by
  rw [iteratedDeriv_fun_mul (f := fun z : ℂ => z) (g := ψ) contDiffAt_id h]
  rcases n with _ | m
  · simp
  · rw [Finset.sum_range_succ', Finset.sum_range_succ']
    simp [iteratedDeriv_fun_id]
    ring

theorem inner_sum {g1 g2 : ℂ → ℂ} {x0 y : ℂ} (h1 : AnalyticAt ℂ g1 (x0 + y))
    (h2 : AnalyticAt ℂ g2 (x0 + y)) (k : ℕ) :
    iteratedDeriv k (fun x => g1 (x + y) + x * y * g2 (x + y)) x0 =
      iteratedDeriv k g1 (x0 + y) +
        y * (x0 * iteratedDeriv k g2 (x0 + y) + k * iteratedDeriv (k - 1) g2 (x0 + y)) := by
  have hs : AnalyticAt ℂ (fun x : ℂ => x + y) x0 := by fun_prop
  have a1 : AnalyticAt ℂ (fun x => g1 (x + y)) x0 :=
    AnalyticAt.comp_of_eq (g := g1) (f := fun x : ℂ => x + y) h1 hs rfl
  have b2 : AnalyticAt ℂ (fun x => g2 (x + y)) x0 :=
    AnalyticAt.comp_of_eq (g := g2) (f := fun x : ℂ => x + y) h2 hs rfl
  have a2 : AnalyticAt ℂ (fun x => y * g2 (x + y)) x0 := analyticAt_const.mul b2
  have a3 : AnalyticAt ℂ (fun x => x * (y * g2 (x + y))) x0 := analyticAt_id.mul a2
  have e : (fun x => g1 (x + y) + x * y * g2 (x + y)) =
      fun x => g1 (x + y) + x * (y * g2 (x + y)) := by
    funext x
    ring
  rw [e, iteratedDeriv_fun_add a1.contDiffAt a3.contDiffAt,
    congrFun (iteratedDeriv_comp_add_const k g1 y) x0, iteratedDeriv_id_mul k a2.contDiffAt]
  simp only [iteratedDeriv_const_mul_field]
  rw [congrFun (iteratedDeriv_comp_add_const k g2 y) x0,
    congrFun (iteratedDeriv_comp_add_const (k - 1) g2 y) x0]
  ring

theorem analyticAt_iteratedDeriv {g : ℂ → ℂ} {u : ℂ} (h : AnalyticAt ℂ g u) (k : ℕ) :
    AnalyticAt ℂ (iteratedDeriv k g) u := by
  rw [iteratedDeriv_eq_iterate]
  exact h.iterated_deriv k

theorem outer_lin {g2 : ℂ → ℂ} {x0 y0 : ℂ} (h2 : AnalyticAt ℂ g2 (x0 + y0)) (k j : ℕ) :
    iteratedDeriv j (fun y => x0 * iteratedDeriv k g2 (x0 + y) +
        (k : ℂ) * iteratedDeriv (k - 1) g2 (x0 + y)) y0 =
      x0 * iteratedDeriv (j + k) g2 (x0 + y0) +
        k * iteratedDeriv (j + (k - 1)) g2 (x0 + y0) := by
  have hs : AnalyticAt ℂ (fun y : ℂ => x0 + y) y0 := by fun_prop
  have c1 : AnalyticAt ℂ (fun y => iteratedDeriv k g2 (x0 + y)) y0 :=
    AnalyticAt.comp_of_eq (g := iteratedDeriv k g2) (f := fun y : ℂ => x0 + y)
      (analyticAt_iteratedDeriv h2 k) hs rfl
  have c2 : AnalyticAt ℂ (fun y => iteratedDeriv (k - 1) g2 (x0 + y)) y0 :=
    AnalyticAt.comp_of_eq (g := iteratedDeriv (k - 1) g2) (f := fun y : ℂ => x0 + y)
      (analyticAt_iteratedDeriv h2 (k - 1)) hs rfl
  have d1 : AnalyticAt ℂ (fun y => x0 * iteratedDeriv k g2 (x0 + y)) y0 := analyticAt_const.mul c1
  have d2 : AnalyticAt ℂ (fun y => (k : ℂ) * iteratedDeriv (k - 1) g2 (x0 + y)) y0 :=
    analyticAt_const.mul c2
  rw [iteratedDeriv_fun_add d1.contDiffAt d2.contDiffAt]
  simp only [iteratedDeriv_const_mul_field]
  rw [congrFun (iteratedDeriv_comp_const_add j (iteratedDeriv k g2) x0) y0,
    congrFun (iteratedDeriv_comp_const_add j (iteratedDeriv (k - 1) g2) x0) y0,
    iteratedDeriv_iteratedDeriv', iteratedDeriv_iteratedDeriv']

/-- **The partials of `g₁(x+y) + x y g₂(x+y)`**, `g₁, g₂` analytic at `x₀ + y₀`. -/
theorem pkl_sum {g1 g2 : ℂ → ℂ} {x0 y0 : ℂ} (h1 : AnalyticAt ℂ g1 (x0 + y0))
    (h2 : AnalyticAt ℂ g2 (x0 + y0)) (k l : ℕ) :
    MeanQ.pkl (fun x y => g1 (x + y) + x * y * g2 (x + y)) k l x0 y0 =
      iteratedDeriv (l + k) g1 (x0 + y0) +
        (y0 * (x0 * iteratedDeriv (l + k) g2 (x0 + y0) +
            k * iteratedDeriv (l + (k - 1)) g2 (x0 + y0)) +
          l * (x0 * iteratedDeriv (l - 1 + k) g2 (x0 + y0) +
            k * iteratedDeriv (l - 1 + (k - 1)) g2 (x0 + y0))) := by
  have ht : Tendsto (fun y : ℂ => x0 + y) (𝓝 y0) (𝓝 (x0 + y0)) :=
    tendsto_const_nhds.add tendsto_id
  have ev : ∀ᶠ y in 𝓝 y0, AnalyticAt ℂ g1 (x0 + y) ∧ AnalyticAt ℂ g2 (x0 + y) :=
    ht.eventually (h1.eventually_analyticAt.and h2.eventually_analyticAt)
  have hev : (fun y => iteratedDeriv k (fun x => g1 (x + y) + x * y * g2 (x + y)) x0) =ᶠ[𝓝 y0]
      fun y => iteratedDeriv k g1 (x0 + y) +
        y * (x0 * iteratedDeriv k g2 (x0 + y) + k * iteratedDeriv (k - 1) g2 (x0 + y)) := by
    filter_upwards [ev] with y hy
    exact inner_sum hy.1 hy.2 k
  unfold MeanQ.pkl
  rw [hev.iteratedDeriv_eq]
  have hs : AnalyticAt ℂ (fun y : ℂ => x0 + y) y0 := by fun_prop
  have b1 : AnalyticAt ℂ (fun y => iteratedDeriv k g1 (x0 + y)) y0 :=
    AnalyticAt.comp_of_eq (g := iteratedDeriv k g1) (f := fun y : ℂ => x0 + y)
      (analyticAt_iteratedDeriv h1 k) hs rfl
  have c1 : AnalyticAt ℂ (fun y => iteratedDeriv k g2 (x0 + y)) y0 :=
    AnalyticAt.comp_of_eq (g := iteratedDeriv k g2) (f := fun y : ℂ => x0 + y)
      (analyticAt_iteratedDeriv h2 k) hs rfl
  have c2 : AnalyticAt ℂ (fun y => iteratedDeriv (k - 1) g2 (x0 + y)) y0 :=
    AnalyticAt.comp_of_eq (g := iteratedDeriv (k - 1) g2) (f := fun y : ℂ => x0 + y)
      (analyticAt_iteratedDeriv h2 (k - 1)) hs rfl
  have b2 : AnalyticAt ℂ (fun y => x0 * iteratedDeriv k g2 (x0 + y) +
      (k : ℂ) * iteratedDeriv (k - 1) g2 (x0 + y)) y0 :=
    (analyticAt_const.mul c1).add (analyticAt_const.mul c2)
  have b3 : AnalyticAt ℂ (fun y => y * (x0 * iteratedDeriv k g2 (x0 + y) +
      (k : ℂ) * iteratedDeriv (k - 1) g2 (x0 + y))) y0 := analyticAt_id.mul b2
  rw [iteratedDeriv_fun_add b1.contDiffAt b3.contDiffAt, iteratedDeriv_id_mul l b2.contDiffAt,
    congrFun (iteratedDeriv_comp_const_add l (iteratedDeriv k g1) x0) y0,
    iteratedDeriv_iteratedDeriv', outer_lin h2 k l, outer_lin h2 k (l - 1)]

/-- **Scaling of `pkl`**: if `f(x,y) = g(cx, cy)` near `(α₀, β₀)`, the partials scale by `c^(k+l)`. -/
theorem pkl_scale {f g : ℂ → ℂ → ℂ} {c α0 β0 : ℂ}
    (h : ∀ᶠ y in 𝓝 β0, ∀ᶠ x in 𝓝 α0, f x y = g (c * x) (c * y)) (k l : ℕ) :
    MeanQ.pkl f k l α0 β0 = c ^ k * c ^ l * MeanQ.pkl g k l (c * α0) (c * β0) := by
  have hev : (fun y => iteratedDeriv k (fun x => f x y) α0) =ᶠ[𝓝 β0]
      fun y => c ^ k * (fun b => iteratedDeriv k (fun a => g a b) (c * α0)) (c * y) := by
    filter_upwards [h] with y hy
    have hy' : (fun x => f x y) =ᶠ[𝓝 α0] fun x => (fun a => g a (c * y)) (c * x) := hy
    rw [hy'.iteratedDeriv_eq]
    exact congrFun (iteratedDeriv_comp_mul (fun a => g a (c * y)) c k) α0
  unfold MeanQ.pkl
  rw [hev.iteratedDeriv_eq]
  simp only [iteratedDeriv_const_mul_field]
  have e2 := congrFun (iteratedDeriv_comp_mul
    (fun b => iteratedDeriv k (fun a => g a b) (c * α0)) c l) β0
  beta_reduce at e2
  rw [e2]
  ring

/-! ### The one-variable function `φ(u) = (1 − e^(−u))/u` -/

theorem phi_analyticAt {u : ℂ} (hu : u ≠ 0) : AnalyticAt ℂ phi u := by
  unfold phi
  fun_prop (disch := assumption)

theorem iteratedDeriv_exp_neg (n : ℕ) (u : ℂ) :
    iteratedDeriv n (fun z => cexp (-z)) u = (-1) ^ n * cexp (-u) := by
  have e : (fun z : ℂ => cexp (-z)) = fun z => cexp ((-1) * z) := by
    funext z
    ring_nf
  rw [e, iteratedDeriv_cexp_const_mul]
  ring_nf

/-- `(1 − e^(−u))^(n) = [n = 0] − (−1)^n e^(−u)`. -/
theorem iteratedDeriv_one_sub_exp (n : ℕ) (u : ℂ) :
    iteratedDeriv n (fun z => 1 - cexp (-z)) u =
      (if n = 0 then 1 else 0) - (-1) ^ n * cexp (-u) := by
  rcases Nat.eq_zero_or_pos n with hn | hn
  · subst hn
    simp
  · rw [iteratedDeriv_const_sub hn, iteratedDeriv_neg, iteratedDeriv_exp_neg, if_neg hn.ne']
    ring

/-- `(1 + e^(−u))^(n) = [n = 0] + (−1)^n e^(−u)`. -/
theorem iteratedDeriv_one_add_exp (n : ℕ) (u : ℂ) :
    iteratedDeriv n (fun z => 1 + cexp (-z)) u =
      (if n = 0 then 1 else 0) + (-1) ^ n * cexp (-u) := by
  rcases Nat.eq_zero_or_pos n with hn | hn
  · subst hn
    simp
  · rw [iteratedDeriv_const_add hn, iteratedDeriv_exp_neg, if_neg hn.ne']
    ring

/-- **The recursion**: `u φ^(n)(u) + n φ^(n−1)(u) = [n = 0] − (−1)^n e^(−u)`, `u ≠ 0`. -/
theorem phi_rec {u : ℂ} (hu : u ≠ 0) (n : ℕ) :
    u * iteratedDeriv n phi u + n * iteratedDeriv (n - 1) phi u =
      (if n = 0 then 1 else 0) - (-1) ^ n * cexp (-u) := by
  have hev : (fun z => z * phi z) =ᶠ[𝓝 u] fun z => 1 - cexp (-z) := by
    filter_upwards [isOpen_ne.mem_nhds hu] with z hz
    unfold phi
    field_simp
  rw [← iteratedDeriv_one_sub_exp, ← hev.iteratedDeriv_eq,
    iteratedDeriv_id_mul n (phi_analyticAt hu).contDiffAt]

/-- **`φ^(n)(−2R) = ph R n`**, `R ≠ 0`. -/
theorem phi_iter_real {R : ℝ} (hR : R ≠ 0) (n : ℕ) :
    iteratedDeriv n phi ((-(2 * R) : ℝ) : ℂ) = ((ph R n : ℝ) : ℂ) := by
  have hu : ((-(2 * R) : ℝ) : ℂ) ≠ 0 := by
    have : -(2 * R) ≠ 0 := by
      intro e
      apply hR
      linarith
    exact_mod_cast this
  have hE : cexp (-((-(2 * R) : ℝ) : ℂ)) = ((Real.exp (2 * R) : ℝ) : ℂ) := by
    rw [Complex.ofReal_exp]
    push_cast
    ring_nf
  induction n with
  | zero =>
    have h := phi_rec hu 0
    rw [hE] at h
    simp only [iteratedDeriv_zero, Nat.cast_zero, zero_mul, add_zero, if_pos, pow_zero,
      one_mul] at h
    rw [iteratedDeriv_zero, ph]
    push_cast at h hu ⊢
    rw [eq_div_iff hu]
    linear_combination h
  | succ n ih =>
    have h := phi_rec hu (n + 1)
    rw [hE, Nat.add_sub_cancel, ih, if_neg (Nat.succ_ne_zero n)] at h
    rw [ph]
    push_cast at h hu ⊢
    rw [eq_div_iff hu]
    linear_combination h

/-- info: 'FloorConstQ.pkl_sum' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms pkl_sum

/-- info: 'FloorConstQ.pkl_scale' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms pkl_scale

/-- info: 'FloorConstQ.phi_iter_real' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms phi_iter_real

end FloorConstQ
