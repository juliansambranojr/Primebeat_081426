/-
# FloorConstDeriv — block S12 of `lean_stage3/design/stencil.md`, piece 5a, the closed form: the partials of `c(α,β)`. 2026-11-25.

Off `α + β = 0`, with `ℓ = log M ≠ 0` and `λ = log T`, Young's
`c(α,β) = c₁(α,β) + T^(−α−β) c₁(−β,−α)` is `g (1 − E) + 2B E`, where
`g = c₁ = Aℓ⁻¹u⁻¹ + B + ℓC xy u⁻¹`, `u = x + y`, `E = e^(−λu)`: the identity
`c₁(−β,−α) = 2B − c₁(α,β)` holds off the line. The partials are then explicit:

* `∂x g = (ℓCy² − Aℓ⁻¹)/u²`, `∂y g = (ℓCx² − Aℓ⁻¹)/u²`,
  `∂y∂x g = 2ℓCy/u² − 2(ℓCy² − Aℓ⁻¹)/u³`;
* `∂x c = ∂x g (1 − E) + λE(g − 2B)`, and the same in `y`;
* `∂y∂x c = ∂y∂x g (1 − E) + λE(∂x g + ∂y g) − λ²E(g − 2B)`.

| name | content | status |
|---|---|---|
| `gF`, `EF`, `HF`, `gx`, `gy`, `gxy`, `Hx`, `Hy`, `Hxy` | the closed forms above | defined |
| `hasDerivAt_gx`, `hasDerivAt_gy`, `hasDerivAt_gxy` | the partials of `g` | proved |
| `hasDerivAt_EFx`, `hasDerivAt_EFy` | `∂E = −λE` in each variable | proved |
| `hasDerivAt_Hx`, `hasDerivAt_Hy`, `hasDerivAt_Hxy` | the partials of `g(1−E) + 2BE` | proved |
| `cY_eq_HF` | `c(x,y) = HF(x,y)` for `x + y ≠ 0`, `log M ≠ 0`, `T ≠ 0` | proved |
| `nhds_ne_x`, `nhds_ne_y` | `x + y ≠ 0` holds near the point, in each variable | proved |
| `pa_cY`, `pb_cY`, `pab_cY` | `∂α c = Hx`, `∂β c = Hy`, `∂β∂α c = Hxy` off the line | proved |

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Stage3.OperatorCY

namespace FloorConst

open Complex Filter Topology TwistedMoment Operator

noncomputable section

/-- `g = c₁ = A ℓ⁻¹ u⁻¹ + B + ℓ C x y u⁻¹`, `u = x + y`. -/
def gF (A B C ℓ : ℂ) (x y : ℂ) : ℂ :=
  A * ℓ⁻¹ * (x + y)⁻¹ + B + ℓ * C * x * y * (x + y)⁻¹

/-- `E = exp(λ · (−(x + y)))`, `T^(−α−β)` with `λ = log T`. -/
def EF (lam : ℂ) (x y : ℂ) : ℂ := cexp (lam * (-(x + y)))

/-- `c = g (1 − E) + 2 B E`. -/
def HF (A B C ℓ lam : ℂ) (x y : ℂ) : ℂ :=
  gF A B C ℓ x y * (1 - EF lam x y) + 2 * B * EF lam x y

/-- `∂x g`. -/
def gx (A C ℓ : ℂ) (x y : ℂ) : ℂ := (ℓ * C * y ^ 2 - A * ℓ⁻¹) * ((x + y) ^ 2)⁻¹

/-- `∂y g`. -/
def gy (A C ℓ : ℂ) (x y : ℂ) : ℂ := (ℓ * C * x ^ 2 - A * ℓ⁻¹) * ((x + y) ^ 2)⁻¹

/-- `∂y ∂x g`. -/
def gxy (A C ℓ : ℂ) (x y : ℂ) : ℂ :=
  2 * ℓ * C * y * ((x + y) ^ 2)⁻¹ - 2 * (ℓ * C * y ^ 2 - A * ℓ⁻¹) * ((x + y) ^ 3)⁻¹

/-- `∂x c`. -/
def Hx (A B C ℓ lam : ℂ) (x y : ℂ) : ℂ :=
  gx A C ℓ x y * (1 - EF lam x y) + lam * EF lam x y * (gF A B C ℓ x y - 2 * B)

/-- `∂y c`. -/
def Hy (A B C ℓ lam : ℂ) (x y : ℂ) : ℂ :=
  gy A C ℓ x y * (1 - EF lam x y) + lam * EF lam x y * (gF A B C ℓ x y - 2 * B)

/-- `∂y ∂x c`. -/
def Hxy (A B C ℓ lam : ℂ) (x y : ℂ) : ℂ :=
  gxy A C ℓ x y * (1 - EF lam x y) + lam * EF lam x y * (gx A C ℓ x y + gy A C ℓ x y) -
    lam ^ 2 * EF lam x y * (gF A B C ℓ x y - 2 * B)

end

variable (A B C ℓ lam : ℂ)

theorem hasDerivAt_gx {x y : ℂ} (h : x + y ≠ 0) :
    HasDerivAt (fun x => gF A B C ℓ x y) (gx A C ℓ x y) x := by
  have hu : HasDerivAt (fun x : ℂ => x + y) 1 x := (hasDerivAt_id' x).add_const y
  have hinv := hu.inv h
  have h1 := ((hinv.const_mul (A * ℓ⁻¹)).add_const B).add
    ((((hasDerivAt_id' x).const_mul (ℓ * C)).mul_const y).mul hinv)
  refine h1.congr_deriv ?_
  simp only [Pi.inv_apply]
  unfold gx
  field_simp
  ring

theorem hasDerivAt_gy {x y : ℂ} (h : x + y ≠ 0) :
    HasDerivAt (fun y => gF A B C ℓ x y) (gy A C ℓ x y) y := by
  have hu : HasDerivAt (fun y : ℂ => x + y) 1 y := (hasDerivAt_id' y).const_add x
  have hinv := hu.inv h
  have h1 := ((hinv.const_mul (A * ℓ⁻¹)).add_const B).add
    ((((hasDerivAt_id' y).const_mul (ℓ * C * x))).mul hinv)
  refine h1.congr_deriv ?_
  simp only [Pi.inv_apply]
  unfold gy
  field_simp
  ring

theorem hasDerivAt_gxy {x y : ℂ} (h : x + y ≠ 0) :
    HasDerivAt (fun y => gx A C ℓ x y) (gxy A C ℓ x y) y := by
  have hu : HasDerivAt (fun y : ℂ => (x + y) ^ 2) (2 * (x + y) ^ 1 * 1) y :=
    ((hasDerivAt_id' y).const_add x).pow 2
  have hinv := hu.inv (pow_ne_zero 2 h)
  have hp : HasDerivAt (fun y : ℂ => ℓ * C * y ^ 2 - A * ℓ⁻¹) (ℓ * C * (2 * y ^ 1 * 1)) y :=
    (((hasDerivAt_id' y).pow 2).const_mul (ℓ * C)).sub_const _
  have h1 := hp.mul hinv
  refine h1.congr_deriv ?_
  simp only [Pi.inv_apply]
  unfold gxy
  field_simp
  ring

theorem hasDerivAt_EFx (x y : ℂ) :
    HasDerivAt (fun x => EF lam x y) (-lam * EF lam x y) x := by
  have hu : HasDerivAt (fun x : ℂ => lam * (-(x + y))) (lam * (-1)) x :=
    ((hasDerivAt_id' x).add_const y).neg.const_mul lam
  refine hu.cexp.congr_deriv ?_
  unfold EF
  ring

theorem hasDerivAt_EFy (x y : ℂ) :
    HasDerivAt (fun y => EF lam x y) (-lam * EF lam x y) y := by
  have hu : HasDerivAt (fun y : ℂ => lam * (-(x + y))) (lam * (-1)) y :=
    ((hasDerivAt_id' y).const_add x).neg.const_mul lam
  refine hu.cexp.congr_deriv ?_
  unfold EF
  ring

theorem hasDerivAt_Hx {x y : ℂ} (h : x + y ≠ 0) :
    HasDerivAt (fun x => HF A B C ℓ lam x y) (Hx A B C ℓ lam x y) x := by
  have hg := hasDerivAt_gx A B C ℓ h
  have hE := hasDerivAt_EFx lam x y
  have h1 := (hg.mul (hE.const_sub 1)).add (hE.const_mul (2 * B))
  refine h1.congr_deriv ?_
  unfold Hx
  ring

theorem hasDerivAt_Hy {x y : ℂ} (h : x + y ≠ 0) :
    HasDerivAt (fun y => HF A B C ℓ lam x y) (Hy A B C ℓ lam x y) y := by
  have hg := hasDerivAt_gy A B C ℓ h
  have hE := hasDerivAt_EFy lam x y
  have h1 := (hg.mul (hE.const_sub 1)).add (hE.const_mul (2 * B))
  refine h1.congr_deriv ?_
  unfold Hy
  ring

theorem hasDerivAt_Hxy {x y : ℂ} (h : x + y ≠ 0) :
    HasDerivAt (fun y => Hx A B C ℓ lam x y) (Hxy A B C ℓ lam x y) y := by
  have hgx := hasDerivAt_gxy A C ℓ h
  have hg := hasDerivAt_gy A B C ℓ h
  have hE := hasDerivAt_EFy lam x y
  have h1 := (hgx.mul (hE.const_sub 1)).add ((hE.const_mul lam).mul (hg.sub_const (2 * B)))
  refine h1.congr_deriv ?_
  unfold Hxy
  ring

/-- **`c` off the line**, `c(x,y) = g(1 − E) + 2BE`. -/
theorem cY_eq_HF (P : Polynomial ℝ) (M : ℕ) {T : ℝ} (hT : T ≠ 0) (hℓ : Real.log M ≠ 0)
    {x y : ℂ} (h : x + y ≠ 0) :
    cY P M T x y = HF (Aq P) (Bq P) (Cq P) ((Real.log M : ℝ) : ℂ) (Complex.log (T : ℂ)) x y := by
  have hℓc : ((Real.log M : ℝ) : ℂ) ≠ 0 := by exact_mod_cast hℓ
  have h' : -y + -x ≠ 0 := by
    intro e
    apply h
    linear_combination -e
  rw [cY_eq P M hT]
  unfold cYform c1form HF gF EF
  field_simp
  ring

theorem nhds_ne_x {x y : ℂ} (h : x + y ≠ 0) : ∀ᶠ x' in 𝓝 x, x' + y ≠ 0 :=
  (isOpen_ne_fun (continuous_id.add continuous_const) continuous_const).mem_nhds h

theorem nhds_ne_y {x y : ℂ} (h : x + y ≠ 0) : ∀ᶠ y' in 𝓝 y, x + y' ≠ 0 :=
  (isOpen_ne_fun (continuous_const.add continuous_id) continuous_const).mem_nhds h

/-- `∂α c = Hx` off the line. -/
theorem pa_cY (P : Polynomial ℝ) (M : ℕ) {T : ℝ} (hT : T ≠ 0) (hℓ : Real.log M ≠ 0)
    {x y : ℂ} (h : x + y ≠ 0) :
    pa (cY P M T) x y =
      Hx (Aq P) (Bq P) (Cq P) ((Real.log M : ℝ) : ℂ) (Complex.log (T : ℂ)) x y := by
  unfold pa
  have he : (fun x' => cY P M T x' y) =ᶠ[𝓝 x]
      (fun x' => HF (Aq P) (Bq P) (Cq P) ((Real.log M : ℝ) : ℂ) (Complex.log (T : ℂ)) x' y) := by
    filter_upwards [nhds_ne_x h] with x' hx'
    exact cY_eq_HF P M hT hℓ hx'
  rw [he.deriv_eq]
  exact (hasDerivAt_Hx _ _ _ _ _ h).deriv

/-- `∂β c = Hy` off the line. -/
theorem pb_cY (P : Polynomial ℝ) (M : ℕ) {T : ℝ} (hT : T ≠ 0) (hℓ : Real.log M ≠ 0)
    {x y : ℂ} (h : x + y ≠ 0) :
    pb (cY P M T) x y =
      Hy (Aq P) (Bq P) (Cq P) ((Real.log M : ℝ) : ℂ) (Complex.log (T : ℂ)) x y := by
  unfold pb
  have he : (fun y' => cY P M T x y') =ᶠ[𝓝 y]
      (fun y' => HF (Aq P) (Bq P) (Cq P) ((Real.log M : ℝ) : ℂ) (Complex.log (T : ℂ)) x y') := by
    filter_upwards [nhds_ne_y h] with y' hy'
    exact cY_eq_HF P M hT hℓ hy'
  rw [he.deriv_eq]
  exact (hasDerivAt_Hy _ _ _ _ _ h).deriv

/-- `∂β ∂α c = Hxy` off the line. -/
theorem pab_cY (P : Polynomial ℝ) (M : ℕ) {T : ℝ} (hT : T ≠ 0) (hℓ : Real.log M ≠ 0)
    {x y : ℂ} (h : x + y ≠ 0) :
    pab (cY P M T) x y =
      Hxy (Aq P) (Bq P) (Cq P) ((Real.log M : ℝ) : ℂ) (Complex.log (T : ℂ)) x y := by
  unfold pab
  have he : (fun y' => pa (cY P M T) x y') =ᶠ[𝓝 y]
      (fun y' => Hx (Aq P) (Bq P) (Cq P) ((Real.log M : ℝ) : ℂ) (Complex.log (T : ℂ)) x y') := by
    filter_upwards [nhds_ne_y h] with y' hy'
    exact pa_cY P M hT hℓ hy'
  rw [he.deriv_eq]
  exact (hasDerivAt_Hxy _ _ _ _ _ h).deriv

/-- info: 'FloorConst.cY_eq_HF' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms cY_eq_HF

/-- info: 'FloorConst.pab_cY' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms pab_cY

end FloorConst
