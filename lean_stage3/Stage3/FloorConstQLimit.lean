/-
# FloorConstQLimit — block S13 of `lean_stage3/design/stencil.md`, B4 step 4, the closed form for a general Q: the identity and the limit. 2026-11-25.

With `α = a/L`, `β = b/L`, `L = log T`, `ℓ = log M`, `θ' = ℓ/L`, Young's `c(α,β)` is
`F(a,b) = f(a,b) + e^(−(a+b)) f(−b,−a)`, `f(a,b) = (A + (a+b)θ'B + abθ'²C)/((a+b)θ')`, and on paper
`F = B(1 + E) + (A/θ') φ(a+b) + θ'C·ab φ(a+b)`, `E = e^(−(a+b))`, `φ(u) = (1 − e^(−u))/u` (`FF`).
Each `(−1/L)∂α` is `−∂a` (`pkl_scale`), so `MeanQ.DopQ Q L c` at `α = β = −R/L` is exactly
`Q(−∂a)Q(−∂b) F` at `a = b = −R`:

  `KflQ Q A B C θ R = Σ_{k,l ≤ deg Q} q_k q_l (−1)^(k+l) XF k l`,

`XF k l = B gB(l+k) + (A/θ) ph(l+k) + θC[R² ph(l+k) − Rk ph(l+(k−1)) − Rl ph(l−1+k)
+ lk ph(l−1+(k−1))]`, with `ph n = φ^(n)(−2R)` (`FloorConstQDeriv.ph`) and
`gB n = [n = 0] + (−1)^n e^(2R)`.

Checked against Young's (1.3) before Lean (`lean_stage3/checks/fcq/check.py`, 60-point Gauss–Legendre):
at `P = X`, `Q = 1 − X`, `θ = 1/2`, `R = 13/10` the three of Young's integral, the sympy derivative
of `F` and this closed form agree to 13 digits (`2.35006777611844`), and likewise at a cubic `P`
and cubic `Q` (`12.4170175579319`). At `Q = 1 − X` it is `FloorConst.Kfl`, proved (`KflQ_one_sub`).

| name | content | status |
|---|---|---|
| `g1`, `g2`, `FF` | `B(1 + e^(−u)) + Aθ⁻¹φ(u)`, `θCφ(u)`, `F(a,b) = g₁(a+b) + ab g₂(a+b)` | defined |
| `gB`, `XF`, `KflQ` | the closed form | defined |
| `cY_eq_FF` | `c(x,y) = F(Lx, Ly)` at `θ' = ℓ/L`, off `x + y = 0` | proved |
| `pkl_FF` | `∂b^l ∂a^k F(−R,−R) = XF k l` | proved |
| `dopQ_cY_eq` | `DopQ Q L c (−R/L, −R/L) = KflQ Q A B C (log M / log T) R`, exactly | proved |
| `KflQ_lin` | `KflQ = B·SB + (A/θ)·SA + θC·SC`, the `S` free of `θ` | proved |
| `re_dopQ_tendsto` | `Re DopQ c (T) → KflQ Q A B C θ R` as `T → ∞`, `θ > 0`, `R ≠ 0` | proved |
| `KflQ_one_sub` | at `Q = 1 − X`, `KflQ = FloorConst.Kfl` | proved |

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Stage3.FloorConstQDeriv
import Stage3.FloorConstLimit

namespace FloorConstQ

open Complex Filter Topology TwistedMoment Operator Polynomial

noncomputable section

/-- `g₁(u) = B(1 + e^(−u)) + A θ⁻¹ φ(u)`. -/
def g1 (A B θ : ℂ) (u : ℂ) : ℂ := B * (1 + cexp (-u)) + A * θ⁻¹ * phi u

/-- `g₂(u) = θ C φ(u)`. -/
def g2 (C θ : ℂ) (u : ℂ) : ℂ := θ * C * phi u

/-- `F(a,b) = g₁(a+b) + a b g₂(a+b)`, Young's `c` in the variables `a = Lα`, `b = Lβ`. -/
def FF (A B C θ : ℂ) (a b : ℂ) : ℂ := g1 A B θ (a + b) + a * b * g2 C θ (a + b)

/-- `gB n = [n = 0] + (−1)^n e^(2R)`, the partials of `1 + E` at `(−R, −R)`. -/
def gB (R : ℝ) (n : ℕ) : ℝ := (if n = 0 then 1 else 0) + (-1) ^ n * Real.exp (2 * R)

/-- `∂b^l ∂a^k F` at `(−R, −R)`. -/
def XF (A B C θ R : ℝ) (k l : ℕ) : ℝ :=
  (B * gB R (l + k) + A / θ * FloorConstQ.ph R (l + k)) +
    ((-R) * ((-R) * (θ * C * ph R (l + k)) + k * (θ * C * ph R (l + (k - 1)))) +
      l * ((-R) * (θ * C * ph R (l - 1 + k)) + k * (θ * C * ph R (l - 1 + (k - 1)))))

/-- **Levinson–Conrey's constant for a general `Q`**: `Q(−∂a)Q(−∂b)F` at `a = b = −R`,
`Σ_{k,l ≤ deg Q} q_k q_l (−1)^(k+l) ∂b^l ∂a^k F(−R,−R)`. -/
def KflQ (Q : ℝ[X]) (A B C θ R : ℝ) : ℝ :=
  ∑ k ∈ Finset.range (Q.natDegree + 1), ∑ l ∈ Finset.range (Q.natDegree + 1),
    Q.coeff k * Q.coeff l * (-1) ^ (k + l) * XF A B C θ R k l

/-- The `θ`-free parts: `SB`, `SA`, `SC`. -/
def SB (Q : ℝ[X]) (R : ℝ) : ℝ :=
  ∑ k ∈ Finset.range (Q.natDegree + 1), ∑ l ∈ Finset.range (Q.natDegree + 1),
    Q.coeff k * Q.coeff l * (-1) ^ (k + l) * gB R (l + k)

def SA (Q : ℝ[X]) (R : ℝ) : ℝ :=
  ∑ k ∈ Finset.range (Q.natDegree + 1), ∑ l ∈ Finset.range (Q.natDegree + 1),
    Q.coeff k * Q.coeff l * (-1) ^ (k + l) * ph R (l + k)

def SC (Q : ℝ[X]) (R : ℝ) : ℝ :=
  ∑ k ∈ Finset.range (Q.natDegree + 1), ∑ l ∈ Finset.range (Q.natDegree + 1),
    Q.coeff k * Q.coeff l * (-1) ^ (k + l) *
      ((-R) * ((-R) * ph R (l + k) + k * ph R (l + (k - 1))) +
        l * ((-R) * ph R (l - 1 + k) + k * ph R (l - 1 + (k - 1))))

end

/-- **`c` in the variables `a = Lx`, `b = Ly`**, off `x + y = 0`. -/
theorem cY_eq_FF (P : Polynomial ℝ) (M : ℕ) {T : ℝ} (hT : 1 < T) (hℓ : Real.log M ≠ 0)
    {x y : ℂ} (h : x + y ≠ 0) :
    cY P M T x y = FF (Aq P) (Bq P) (Cq P) ((Real.log M / Real.log T : ℝ) : ℂ)
      ((Real.log T : ℝ) * x) ((Real.log T : ℝ) * y) := by
  have hT0 : T ≠ 0 := by positivity
  have hL : Real.log T ≠ 0 := (Real.log_pos hT).ne'
  have hLc : ((Real.log T : ℝ) : ℂ) ≠ 0 := by exact_mod_cast hL
  have hℓc : ((Real.log M : ℝ) : ℂ) ≠ 0 := by exact_mod_cast hℓ
  have hLxy : ((Real.log T : ℝ) : ℂ) * x + ((Real.log T : ℝ) : ℂ) * y ≠ 0 := by
    rw [← mul_add]
    exact mul_ne_zero hLc h
  rw [FloorConst.cY_eq_HF P M hT0 hℓ h, ← Complex.ofReal_log (by linarith : (0 : ℝ) ≤ T)]
  have hE : cexp (-(((Real.log T : ℝ) : ℂ) * x + ((Real.log T : ℝ) : ℂ) * y)) =
      FloorConst.EF ((Real.log T : ℝ) : ℂ) x y := by
    unfold FloorConst.EF
    ring_nf
  unfold FF g1 g2 phi
  rw [hE]
  unfold FloorConst.HF FloorConst.gF
  push_cast
  field_simp
  ring

theorem g1_analyticAt (A B θ : ℂ) {u : ℂ} (hu : u ≠ 0) : AnalyticAt ℂ (g1 A B θ) u := by
  have h := phi_analyticAt hu
  unfold g1
  fun_prop

theorem g2_analyticAt (C θ : ℂ) {u : ℂ} (hu : u ≠ 0) : AnalyticAt ℂ (g2 C θ) u := by
  have h := phi_analyticAt hu
  unfold g2
  fun_prop

theorem g1_iter (A B θ : ℝ) {R : ℝ} (hR : R ≠ 0) (n : ℕ) :
    iteratedDeriv n (g1 A B θ) ((-(2 * R) : ℝ) : ℂ) =
      ((B * gB R n + A / θ * ph R n : ℝ) : ℂ) := by
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
  have a1 : AnalyticAt ℂ (fun u => (B : ℂ) * (1 + cexp (-u))) ((-(2 * R) : ℝ) : ℂ) := by
    fun_prop
  have a2 : AnalyticAt ℂ (fun u => (A : ℂ) * (θ : ℂ)⁻¹ * phi u) ((-(2 * R) : ℝ) : ℂ) := by
    have h := phi_analyticAt hu
    fun_prop
  have e : g1 A B θ = fun u => (B : ℂ) * (1 + cexp (-u)) + (A : ℂ) * (θ : ℂ)⁻¹ * phi u := rfl
  rw [e, iteratedDeriv_fun_add a1.contDiffAt a2.contDiffAt]
  simp only [iteratedDeriv_const_mul_field]
  rw [iteratedDeriv_one_add_exp, phi_iter_real hR, hE]
  unfold gB
  split_ifs <;> push_cast <;> ring

theorem g2_iter (C θ : ℝ) {R : ℝ} (hR : R ≠ 0) (n : ℕ) :
    iteratedDeriv n (g2 C θ) ((-(2 * R) : ℝ) : ℂ) = ((θ * C * ph R n : ℝ) : ℂ) := by
  have e : g2 C θ = fun u => (θ : ℂ) * (C : ℂ) * phi u := rfl
  rw [e]
  simp only [iteratedDeriv_const_mul_field]
  rw [phi_iter_real hR]
  push_cast
  ring

/-- **The partials of `F` at `(−R, −R)`.** -/
theorem pkl_FF (A B C θ : ℝ) {R : ℝ} (hR : R ≠ 0) (k l : ℕ) :
    MeanQ.pkl (FF A B C θ) k l ((-R : ℝ) : ℂ) ((-R : ℝ) : ℂ) = ((XF A B C θ R k l : ℝ) : ℂ) := by
  have hu : ((-R : ℝ) : ℂ) + ((-R : ℝ) : ℂ) = ((-(2 * R) : ℝ) : ℂ) := by
    push_cast
    ring
  have hu0 : ((-(2 * R) : ℝ) : ℂ) ≠ 0 := by
    have : -(2 * R) ≠ 0 := by
      intro e
      apply hR
      linarith
    exact_mod_cast this
  have e : FF A B C θ = fun x y => g1 A B θ (x + y) + x * y * g2 C θ (x + y) := rfl
  rw [e, pkl_sum (by rw [hu]; exact g1_analyticAt _ _ _ hu0)
    (by rw [hu]; exact g2_analyticAt _ _ hu0), hu]
  simp only [g1_iter A B θ hR, g2_iter C θ hR]
  unfold XF
  push_cast
  ring

theorem neg_inv_pow_mul {L : ℝ} (hL : L ≠ 0) (k : ℕ) : (-1 / L) ^ k * L ^ k = (-1) ^ k := by
  rw [← mul_pow]
  congr 1
  field_simp

/-- **`DopQ(c)` in closed form**: `DopQ Q L c (−R/L, −R/L) = KflQ Q A B C θ' R`,
`θ' = log M / log T`, exactly, for `T > 1`, `log M ≠ 0`, `R ≠ 0`. -/
theorem dopQ_cY_eq (Q : ℝ[X]) (P : Polynomial ℝ) {M : ℕ} {T R : ℝ} (hT : 1 < T)
    (hℓ : Real.log M ≠ 0) (hR : R ≠ 0) :
    MeanQ.DopQ Q (Real.log T) (cY P M T) ((-(R / Real.log T) : ℝ) : ℂ)
        ((-(R / Real.log T) : ℝ) : ℂ) =
      ((KflQ Q (FloorConst.Ar P) (FloorConst.Br P) (FloorConst.Cr P)
        (Real.log M / Real.log T) R : ℝ) : ℂ) := by
  have hL : Real.log T ≠ 0 := (Real.log_pos hT).ne'
  set α0 : ℂ := ((-(R / Real.log T) : ℝ) : ℂ) with hα0
  have hx : α0 + α0 ≠ 0 := by
    rw [hα0, ← Complex.ofReal_add]
    have : -(R / Real.log T) + -(R / Real.log T) ≠ 0 := by
      have : R / Real.log T ≠ 0 := div_ne_zero hR hL
      intro e
      apply this
      linarith
    exact_mod_cast this
  have hS : ∀ᶠ p in 𝓝 (α0, α0), p.2 + p.1 ≠ 0 :=
    (isOpen_ne_fun (continuous_snd.add continuous_fst) continuous_const).mem_nhds hx
  rw [nhds_prod_eq] at hS
  have hev : ∀ᶠ y in 𝓝 α0, ∀ᶠ x in 𝓝 α0, cY P M T x y =
      FF (Aq P) (Bq P) (Cq P) ((Real.log M / Real.log T : ℝ) : ℂ)
        ((Real.log T : ℝ) * x) ((Real.log T : ℝ) * y) := by
    filter_upwards [hS.curry] with y hy
    filter_upwards [hy] with x hx
    exact cY_eq_FF P M hT hℓ hx
  have hLc : ((Real.log T : ℝ) : ℂ) ≠ 0 := by exact_mod_cast hL
  have hpt : ((Real.log T : ℝ) : ℂ) * α0 = ((-R : ℝ) : ℂ) := by
    rw [hα0]
    push_cast
    field_simp
  unfold MeanQ.DopQ KflQ
  push_cast
  refine Finset.sum_congr rfl fun k _ => Finset.sum_congr rfl fun l _ => ?_
  rw [pkl_scale hev k l, hpt, FloorConst.Aq_eq, FloorConst.Bq_eq, FloorConst.Cq_eq, pkl_FF _ _ _ _ hR]
  have key : (Q.coeff k * (-1 / Real.log T) ^ k) * (Q.coeff l * (-1 / Real.log T) ^ l) *
      (Real.log T ^ k * Real.log T ^ l *
        XF (FloorConst.Ar P) (FloorConst.Br P) (FloorConst.Cr P) (Real.log M / Real.log T) R k l) =
      Q.coeff k * Q.coeff l * (-1) ^ (k + l) *
        XF (FloorConst.Ar P) (FloorConst.Br P) (FloorConst.Cr P) (Real.log M / Real.log T) R k l := by
    have h1 := neg_inv_pow_mul hL k
    have h2 := neg_inv_pow_mul hL l
    rw [pow_add]
    linear_combination (Q.coeff k * Q.coeff l *
      XF (FloorConst.Ar P) (FloorConst.Br P) (FloorConst.Cr P) (Real.log M / Real.log T) R k l) *
        ((-1 / Real.log T) ^ l * Real.log T ^ l * h1 + (-1) ^ k * h2)
  unfold MeanQ.qc
  have hc := congrArg (fun r : ℝ => (r : ℂ)) key
  push_cast at hc ⊢
  rw [← hc]

/-- **`KflQ` is affine in `B`, `A/θ`, `θC`**, with `θ`-free coefficients. -/
theorem KflQ_lin (Q : ℝ[X]) (A B C θ R : ℝ) :
    KflQ Q A B C θ R = B * SB Q R + A / θ * SA Q R + θ * C * SC Q R := by
  unfold KflQ SB SA SC
  simp only [Finset.mul_sum, ← Finset.sum_add_distrib]
  refine Finset.sum_congr rfl fun k _ => Finset.sum_congr rfl fun l _ => ?_
  unfold XF
  ring

/-- `KflQ` is continuous in `θ ≠ 0`. -/
theorem tendsto_KflQ (Q : ℝ[X]) (A B C R : ℝ) {θ : ℝ} (hθ : θ ≠ 0) {f : ℝ → ℝ} {l : Filter ℝ}
    (h : Tendsto f l (𝓝 θ)) :
    Tendsto (fun t => KflQ Q A B C (f t) R) l (𝓝 (KflQ Q A B C θ R)) := by
  simp only [KflQ_lin]
  exact ((tendsto_const_nhds).add ((tendsto_const_nhds.div h hθ).mul tendsto_const_nhds)).add
    ((h.mul tendsto_const_nhds).mul tendsto_const_nhds)

/-- **The limit for a general `Q`**: `Re DopQ c (−R/L, −R/L) → KflQ Q A B C θ R` as `T → ∞`,
`M = ⌊T^θ⌋`, for `θ > 0`, `R ≠ 0`. -/
theorem re_dopQ_tendsto (Q : ℝ[X]) (P : Polynomial ℝ) {θ R : ℝ} (hθ : 0 < θ) (hR : R ≠ 0) :
    Tendsto (fun T => (MeanQ.DopQ Q (Real.log T) (cY P (Mof T θ) T)
      ((-(R / Real.log T) : ℝ) : ℂ) ((-(R / Real.log T) : ℝ) : ℂ)).re) atTop
      (𝓝 (KflQ Q (FloorConst.Ar P) (FloorConst.Br P) (FloorConst.Cr P) θ R)) := by
  refine (tendsto_KflQ Q (FloorConst.Ar P) (FloorConst.Br P) (FloorConst.Cr P) R hθ.ne'
    (FloorConst.theta_tendsto hθ)).congr' ?_
  filter_upwards [eventually_ge_atTop (max 2 (Real.exp (4 * Real.log 2 / θ)))] with T hT
  simp only [max_le_iff] at hT
  obtain ⟨hT2, hTe⟩ := hT
  have hT1 : 1 < T := by linarith
  have hT0 : 0 < T := by linarith
  have hLθ : 4 * Real.log 2 / θ ≤ Real.log T := (Real.le_log_iff_exp_le hT0).mpr hTe
  have hℓlo := DiagMain.logM_ge hT1 hθ hLθ
  have hℓ0 : 0 < Real.log (Mof T θ) :=
    lt_of_lt_of_le (by have := Real.log_pos hT1; positivity) hℓlo
  rw [dopQ_cY_eq Q P hT1 hℓ0.ne' hR, Complex.ofReal_re]

/-- **The check at Levinson's `Q = 1 − X`**: `KflQ = FloorConst.Kfl`. -/
theorem KflQ_one_sub (A B C θ R : ℝ) (hθ : θ ≠ 0) (hR : R ≠ 0) :
    KflQ (1 - X) A B C θ R = FloorConst.Kfl A B C θ R := by
  have hdeg : (1 - X : ℝ[X]).natDegree = 1 := by
    rw [sub_eq_add_neg, ← C_1, add_comm, natDegree_add_C, natDegree_neg, natDegree_X]
  have c0 : (1 - X : ℝ[X]).coeff 0 = 1 := by simp
  have c1 : (1 - X : ℝ[X]).coeff 1 = -1 := by
    rw [coeff_sub, coeff_one, coeff_X_one]
    norm_num
  unfold KflQ
  rw [hdeg]
  simp only [Finset.sum_range_succ, Finset.sum_range_zero, zero_add, c0, c1]
  unfold XF gB
  simp only [ph, show ph R 0 = (1 - Real.exp (2 * R)) / (-(2 * R)) from rfl]
  unfold FloorConst.Kfl
  norm_num
  field_simp
  ring

/-- info: 'FloorConstQ.dopQ_cY_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms dopQ_cY_eq

/-- info: 'FloorConstQ.re_dopQ_tendsto' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms re_dopQ_tendsto

/-- info: 'FloorConstQ.KflQ_one_sub' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms KflQ_one_sub

end FloorConstQ
