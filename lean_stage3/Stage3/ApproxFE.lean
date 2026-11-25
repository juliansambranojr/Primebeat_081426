/-
# ApproxFE — block S12 of `lean_stage3/design/stencil.md`, piece 1. 2026-11-25.

Young's Lemma 4 (arXiv 1002.4403, §4): the approximate functional equation for
`ζ(1/2+α+it)·ζ(1/2+β−it)` with the smoothing `G(s) = e^(s²)·p(s)`,
`p(s) = ((α+β)² − (2s)²)/(α+β)²`.

Notation. `u = uA α t = 1/2 + α + it`, `v = vB β t = 1/2 + β − it`.
`gY α β t s = Gammaℝ(u+s)·Gammaℝ(v+s)/(Gammaℝ u·Gammaℝ v)` is Young's `g_{α,β}(s,t)`
(`gY_eq_young`), `XY α β t = Gammaℝ(1−u)·Gammaℝ(1−v)/(Gammaℝ u·Gammaℝ v)` is Young's
`X_{α,β,t}` (`XY_eq_young`). `VY α β c x t = (1/2πi)∫_(c) G(s)/s·g(s,t)·x^(−s) ds` is
Young's `V_{α,β}(x,t)` read on the line `Re s = c` (Young: `c = 1`).
`FY α β t s = G(s)/s·g(s,t)·ζ(u+s)·ζ(v+s)` is the integrand of the shift.

| statement | content | status |
|---|---|---|
| `zeta_fe` | `ζ s = Gammaℝ(1−s)/Gammaℝ s · ζ(1−s)`, `Gammaℝ s ≠ 0`, `Re(1−s) > 0` | proved |
| `zeta_prod_fe` | piece 1: `ζ(u)ζ(v) = X_{α,β,t}·ζ(1/2−α−it)ζ(1/2−β+it)`, `Re α, Re β < 1/2` | proved |
| `XY_eq_young`, `gY_eq_young` | the two Gamma ratios in Young's `π`, `Γ` form | proved |
| `coef_eq_young` | `m^(−u) n^(−v) = m^(−1/2−α) n^(−1/2−β) (m/n)^(−it)` | proved |
| `mellin_double_sum` | piece 2: `Σ m^(−u) n^(−v) V_c(mn,t) = (1/2πi)∫_(c) FY`, `c + Re α, c + Re β > 1/2` | proved |
| `GY_neg`, `GY_swap`, `uA_neg`, `vB_neg` | `G` even and symmetric; `(−β,−α)` swaps `u ↔ 1−v` | proved |
| `FY_reflect` | piece 3, the left line: `FY(−s) = −X·FY_{−β,−α}(s)` (functional equation) | proved |
| `vertInt_reflect` | `(1/2πi)∫_(−c) FY = −X·(1/2πi)∫_(c) FY_{−β,−α}` | proved |
| `GY_zero`, `gY_zero`, `residue_zero` | piece 3, the residue at `s = 0` is `ζ(u)ζ(v)` (`G(0) = 1`) | proved |
| `StmtShift` | piece 3, the shift itself: `∫_(c) − ∫_(−c) = ζ(u)ζ(v) + resY` | OPEN (a named Prop) |
| `approxFE_of_shift` | Lemma 4's identity, exact, with remainder `−resY`, given `StmtShift` | proved |
| (4.3), and `resY ≪_A (1+|t|)^(−A)` | the bounds | OPEN, not stated |

The poles. `FY` equals `G(s)/s·Λ(u+s)Λ(v+s)/(Gammaℝ u Gammaℝ v)` away from the
trivial zeros, so its poles in the strip are `s = 0`, `1−u`, `−u`, `1−v`, `−v`
(those of `Λ` at `0` and `1`). The zeros of `p` at `s = ±(α+β)/2` cancel none of
them. The four poles other than `0` sit at height `∓t`, where
`|G(s)| = e^(Re s² − Im s²)·|p(s)| ≈ e^(−t²)`, and their residues are the
`O_A((1+|t|)^(−A))` (`resY`). Young uses the zero of `p` at `−(α+β)/2` later, in §6,
against the pole of `ζ(1+α+β+2s)`.

Axioms: [propext, Classical.choice, Quot.sound], pinned below on each main theorem.
-/
import Mathlib
import PrimeNumberTheoremAnd.ResidueCalcOnRectangles

namespace ApproxFE

open Complex MeasureTheory Filter Topology

/-! ## Notation -/

/-- `u = 1/2 + α + it`. -/
noncomputable
def uA (α : ℂ) (t : ℝ) : ℂ := 1 / 2 + α + t * I

/-- `v = 1/2 + β − it`. -/
noncomputable
def vB (β : ℂ) (t : ℝ) : ℂ := 1 / 2 + β - t * I

/-- Young's `X_{α,β,t}`, through `Gammaℝ`. -/
noncomputable
def XY (α β : ℂ) (t : ℝ) : ℂ :=
  Gammaℝ (1 - uA α t) * Gammaℝ (1 - vB β t) / (Gammaℝ (uA α t) * Gammaℝ (vB β t))

/-- Young's `G(s) = e^(s²)·p(s)`, `p(s) = ((α+β)² − (2s)²)/(α+β)²`. -/
noncomputable
def GY (α β s : ℂ) : ℂ := cexp (s ^ 2) * (((α + β) ^ 2 - (2 * s) ^ 2) / (α + β) ^ 2)

/-- Young's `g_{α,β}(s,t)`, through `Gammaℝ`. -/
noncomputable
def gY (α β : ℂ) (t : ℝ) (s : ℂ) : ℂ :=
  Gammaℝ (uA α t + s) * Gammaℝ (vB β t + s) / (Gammaℝ (uA α t) * Gammaℝ (vB β t))

/-- The kernel `G(s)/s · g(s,t)`. -/
noncomputable
def KY (α β : ℂ) (t : ℝ) (s : ℂ) : ℂ := GY α β s / s * gY α β t s

/-- Young's `V_{α,β}(x,t)`, on the line `Re s = c`. -/
noncomputable
def VY (α β : ℂ) (c x t : ℝ) : ℂ :=
  VerticalIntegral' (fun s => KY α β t s * (x : ℂ) ^ (-s)) c

/-- The integrand of the shift, `G(s)/s · g(s,t) · ζ(u+s) ζ(v+s)`. -/
noncomputable
def FY (α β : ℂ) (t : ℝ) (s : ℂ) : ℂ :=
  KY α β t s * (riemannZeta (uA α t + s) * riemannZeta (vB β t + s))

theorem uA_re (α : ℂ) (t : ℝ) : (uA α t).re = 1 / 2 + α.re := by
  simp [uA]

theorem vB_re (β : ℂ) (t : ℝ) : (vB β t).re = 1 / 2 + β.re := by
  simp [vB]

theorem uA_im (α : ℂ) (t : ℝ) : (uA α t).im = α.im + t := by
  simp [uA]

theorem vB_im (β : ℂ) (t : ℝ) : (vB β t).im = β.im - t := by
  simp [vB]

/-! ## Piece 1: the functional equation for the product -/

/-- The functional equation in Young's shape: `ζ s = Gammaℝ(1−s)/Gammaℝ s · ζ(1−s)`. -/
theorem zeta_fe {s : ℂ} (hs : Gammaℝ s ≠ 0) (h1 : 0 < (1 - s).re) :
    riemannZeta s = Gammaℝ (1 - s) / Gammaℝ s * riemannZeta (1 - s) := by
  have hs0 : s ≠ 0 := by
    rintro rfl
    exact hs (Gammaℝ_eq_zero_iff.mpr ⟨0, by simp⟩)
  have h10 : (1 - s) ≠ 0 := by
    intro h
    rw [h] at h1
    simp at h1
  have hG1 : Gammaℝ (1 - s) ≠ 0 := Gammaℝ_ne_zero_of_re_pos h1
  rw [riemannZeta_def_of_ne_zero hs0, riemannZeta_def_of_ne_zero h10,
    completedRiemannZeta_one_sub]
  field_simp
  try ring

/-- Piece 1. For `Re α, Re β < 1/2`,
`ζ(1/2+α+it) ζ(1/2+β−it) = X_{α,β,t} · ζ(1/2−α−it) ζ(1/2−β+it)`. -/
theorem zeta_prod_fe {α β : ℂ} {t : ℝ} (hα : α.re < 1 / 2) (hβ : β.re < 1 / 2)
    (hu : Gammaℝ (uA α t) ≠ 0) (hv : Gammaℝ (vB β t) ≠ 0) :
    riemannZeta (uA α t) * riemannZeta (vB β t) =
      XY α β t * (riemannZeta (1 / 2 - α - t * I) * riemannZeta (1 / 2 - β + t * I)) := by
  have e1 : 1 - uA α t = 1 / 2 - α - t * I := by
    unfold uA
    ring
  have e2 : 1 - vB β t = 1 / 2 - β + t * I := by
    unfold vB
    ring
  have h1 : 0 < (1 - uA α t).re := by
    rw [Complex.sub_re, uA_re]
    simp
    linarith
  have h2 : 0 < (1 - vB β t).re := by
    rw [Complex.sub_re, vB_re]
    simp
    linarith
  rw [zeta_fe hu h1, zeta_fe hv h2]
  simp only [XY]
  rw [e1, e2]
  ring

/-- `Gammaℝ (uA α t) ≠ 0` once `Re α > −1/2`. -/
theorem Gammaℝ_uA_ne {α : ℂ} (t : ℝ) (hα : -(1 / 2) < α.re) : Gammaℝ (uA α t) ≠ 0 :=
  Gammaℝ_ne_zero_of_re_pos (by rw [uA_re]; linarith)

/-- `Gammaℝ (vB β t) ≠ 0` once `Re β > −1/2`. -/
theorem Gammaℝ_vB_ne {β : ℂ} (t : ℝ) (hβ : -(1 / 2) < β.re) : Gammaℝ (vB β t) ≠ 0 :=
  Gammaℝ_ne_zero_of_re_pos (by rw [vB_re]; linarith)

/-- A ratio of four `π`-powers times Gamma values. -/
theorem ratio_aux (P A B C D a b c d k : ℂ) (hP : P ≠ 0) (hk : a + b = k + (c + d)) :
    P ^ a * A * (P ^ b * B) / (P ^ c * C * (P ^ d * D)) = P ^ k * (A * B) / (C * D) := by
  have hpow : ∀ z : ℂ, P ^ z ≠ 0 := fun z => by
    rw [cpow_def_of_ne_zero hP]
    exact exp_ne_zero _
  have hcd : P ^ c * P ^ d ≠ 0 := mul_ne_zero (hpow c) (hpow d)
  have key : P ^ a * P ^ b = P ^ k * (P ^ c * P ^ d) := by
    rw [← cpow_add _ _ hP, ← cpow_add _ _ hP, ← cpow_add _ _ hP, hk]
  calc P ^ a * A * (P ^ b * B) / (P ^ c * C * (P ^ d * D))
      = (P ^ a * P ^ b) * (P ^ c * P ^ d)⁻¹ * (A * B / (C * D)) := by ring
    _ = P ^ k * (A * B / (C * D)) := by
        rw [key, mul_assoc (P ^ k), mul_inv_cancel₀ hcd, mul_one]
    _ = P ^ k * (A * B) / (C * D) := by ring

/-- Young's form of `X_{α,β,t}`:
`π^(α+β) Γ((1/2−α−it)/2) Γ((1/2−β+it)/2) / (Γ((1/2+α+it)/2) Γ((1/2+β−it)/2))`. -/
theorem XY_eq_young (α β : ℂ) (t : ℝ) :
    XY α β t = (Real.pi : ℂ) ^ (α + β) *
      (Gamma ((1 / 2 - α - t * I) / 2) * Gamma ((1 / 2 - β + t * I) / 2)) /
      (Gamma ((1 / 2 + α + t * I) / 2) * Gamma ((1 / 2 + β - t * I) / 2)) := by
  have e1 : 1 - uA α t = 1 / 2 - α - t * I := by
    unfold uA
    ring
  have e2 : 1 - vB β t = 1 / 2 - β + t * I := by
    unfold vB
    ring
  have hP : (Real.pi : ℂ) ≠ 0 := ofReal_ne_zero.mpr Real.pi_ne_zero
  simp only [XY, Gammaℝ_def]
  rw [e1, e2]
  simp only [uA, vB]
  exact ratio_aux _ _ _ _ _ _ _ _ _ _ hP (by ring)

/-- Young's form of `g_{α,β}(s,t)`:
`π^(−s) Γ((u+s)/2) Γ((v+s)/2) / (Γ(u/2) Γ(v/2))`. -/
theorem gY_eq_young (α β : ℂ) (t : ℝ) (s : ℂ) :
    gY α β t s = (Real.pi : ℂ) ^ (-s) *
      (Gamma ((1 / 2 + α + s + t * I) / 2) * Gamma ((1 / 2 + β + s - t * I) / 2)) /
      (Gamma ((1 / 2 + α + t * I) / 2) * Gamma ((1 / 2 + β - t * I) / 2)) := by
  have e1 : uA α t + s = 1 / 2 + α + s + t * I := by
    unfold uA
    ring
  have e2 : vB β t + s = 1 / 2 + β + s - t * I := by
    unfold vB
    ring
  have hP : (Real.pi : ℂ) ≠ 0 := ofReal_ne_zero.mpr Real.pi_ne_zero
  simp only [gY, Gammaℝ_def]
  rw [e1, e2]
  simp only [uA, vB]
  exact ratio_aux _ _ _ _ _ _ _ _ _ _ hP (by ring)

/-- The coefficients in Young's form: for `x, y > 0`,
`x^(−u) y^(−v) = x^(−1/2−α) y^(−1/2−β) (x/y)^(−it)`. -/
theorem coef_eq_young (α β : ℂ) (t : ℝ) {x y : ℝ} (hx : 0 < x) (hy : 0 < y) :
    (x : ℂ) ^ (-uA α t) * (y : ℂ) ^ (-vB β t) =
      (x : ℂ) ^ (-(1 / 2 + α)) * (y : ℂ) ^ (-(1 / 2 + β)) * ((x / y : ℝ) : ℂ) ^ (-(t * I)) := by
  have hx0 : (x : ℂ) ≠ 0 := ofReal_ne_zero.mpr hx.ne'
  have hy0 : (y : ℂ) ≠ 0 := ofReal_ne_zero.mpr hy.ne'
  have hxy0 : ((x / y : ℝ) : ℂ) ≠ 0 := ofReal_ne_zero.mpr (div_pos hx hy).ne'
  rw [cpow_def_of_ne_zero hx0, cpow_def_of_ne_zero hy0, cpow_def_of_ne_zero hx0,
    cpow_def_of_ne_zero hy0, cpow_def_of_ne_zero hxy0, ← ofReal_log (div_pos hx hy).le,
    Real.log_div hx.ne' hy.ne', ← ofReal_log hx.le, ← ofReal_log hy.le,
    ← exp_add, ← exp_add, ← exp_add]
  congr 1
  push_cast
  unfold uA vB
  ring

/-! ## Piece 2: the Mellin representation -/

/-- `‖Γ z‖ ≤ Γ(Re z)` right of zero (the Euler integral; PNT+ `norm_le_Gamma_re`). -/
theorem norm_Gamma_le {z : ℂ} (hz : 0 < z.re) : ‖Gamma z‖ ≤ Real.Gamma z.re := by
  rw [Gamma_eq_integral hz, Real.Gamma_eq_integral hz]
  have h_norm_eq : ∀ x ∈ Set.Ioi (0 : ℝ),
      ‖((-x).exp : ℂ) * (x : ℂ) ^ (z - 1)‖ = Real.exp (-x) * x ^ (z.re - 1) := by
    intro x hx
    have hcpow : ‖(x : ℂ) ^ (z - 1)‖ = x ^ (z.re - 1) := by
      simpa using norm_cpow_eq_rpow_re_of_pos hx (z - 1)
    simp [norm_exp, hcpow]
  calc ‖GammaIntegral z‖
      ≤ ∫ x in Set.Ioi (0 : ℝ), ‖((-x).exp : ℂ) * (x : ℂ) ^ (z - 1)‖ := by
        unfold GammaIntegral
        exact norm_integral_le_integral_norm _
    _ = ∫ x in Set.Ioi (0 : ℝ), Real.exp (-x) * x ^ (z.re - 1) :=
        setIntegral_congr_fun measurableSet_Ioi h_norm_eq

/-- `‖Gammaℝ w‖ ≤ π^(−Re w/2) Γ(Re w/2)` right of zero. -/
theorem norm_Gammaℝ_le {w : ℂ} (hw : 0 < w.re) :
    ‖Gammaℝ w‖ ≤ Real.pi ^ (-w.re / 2) * Real.Gamma (w.re / 2) := by
  rw [Gammaℝ_def, norm_mul, norm_cpow_eq_rpow_re_of_pos Real.pi_pos]
  have h2 : (w / 2).re = w.re / 2 := by simp
  have h3 : (-w / 2).re = -w.re / 2 := by simp
  rw [h3]
  have hG := norm_Gamma_le (z := w / 2) (by rw [h2]; linarith)
  rw [h2] at hG
  exact mul_le_mul_of_nonneg_left hG (Real.rpow_nonneg Real.pi_pos.le _)

/-- `Gammaℝ` is differentiable wherever it does not vanish. -/
theorem differentiableAt_Gammaℝ {s : ℂ} (hs : Gammaℝ s ≠ 0) : DifferentiableAt ℂ Gammaℝ s := by
  have h := (differentiable_Gammaℝ_inv s).inv (inv_ne_zero hs)
  have he : (fun z : ℂ => (Gammaℝ z)⁻¹)⁻¹ = Gammaℝ := by
    funext z
    simp
  rwa [he] at h

/-- The norm of a shifted natural power. -/
theorem norm_succ_cpow (m : ℕ) (z : ℂ) : ‖((m : ℂ) + 1) ^ z‖ = ((m : ℝ) + 1) ^ z.re := by
  have h := norm_natCast_cpow_of_pos (Nat.succ_pos m) z
  push_cast at h
  exact h

/-- `Σ (m+1)^r` converges for `r < −1`. -/
theorem summable_succ_rpow {r : ℝ} (hr : r < -1) :
    Summable fun m : ℕ => ((m : ℝ) + 1) ^ r := by
  have h := (summable_nat_add_iff 1).mpr (Real.summable_nat_rpow.mpr hr)
  refine h.congr fun m => ?_
  push_cast
  rfl

/-- The Dirichlet series of `ζ` converges absolutely for `Re w > 1`. -/
theorem summable_zeta_norm {w : ℂ} (hw : 1 < w.re) :
    Summable fun n : ℕ => ‖1 / ((n : ℂ) + 1) ^ w‖ := by
  refine (summable_succ_rpow (r := -w.re) (by linarith)).congr fun n => ?_
  rw [norm_div, norm_one, norm_succ_cpow, Real.rpow_neg (by positivity), one_div]

/-- On `Re s = c > 0` with `Re(u+s), Re(v+s) > 0`, the kernel `G(s)/s·g(s,t)` is at most
a constant times `e^(−y²/2)`. -/
theorem KY_bound {α β : ℂ} {t c : ℝ} (hc : 0 < c) (hu : 0 < 1 / 2 + α.re + c)
    (hv : 0 < 1 / 2 + β.re + c) :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ y : ℝ, ‖KY α β t (c + y * I)‖ ≤ C * Real.exp (-(1 / 2) * y ^ 2) := by
  set A : ℝ := ‖α + β‖ ^ 2 with hA
  set Q : ℝ := (A + 4 * c ^ 2 + 4) / A with hQ
  set B1 : ℝ := Real.pi ^ (-(1 / 2 + α.re + c) / 2) * Real.Gamma ((1 / 2 + α.re + c) / 2)
  set B2 : ℝ := Real.pi ^ (-(1 / 2 + β.re + c) / 2) * Real.Gamma ((1 / 2 + β.re + c) / 2)
  set D : ℝ := ‖Gammaℝ (uA α t) * Gammaℝ (vB β t)‖
  set M : ℝ := B1 * B2 / D
  have hA0 : 0 ≤ A := by positivity
  have hQ0 : 0 ≤ Q := by positivity
  have hB10 : 0 ≤ B1 := by
    have := Real.Gamma_pos_of_pos (by linarith : (0 : ℝ) < (1 / 2 + α.re + c) / 2)
    positivity
  have hB20 : 0 ≤ B2 := by
    have := Real.Gamma_pos_of_pos (by linarith : (0 : ℝ) < (1 / 2 + β.re + c) / 2)
    positivity
  have hM0 : 0 ≤ M := by positivity
  refine ⟨2 * Real.exp (c ^ 2) * (Q * (1 / c) * M), by positivity, fun y => ?_⟩
  set s : ℂ := c + y * I with hs
  have hsre : s.re = c := by simp [hs]
  have hsim : s.im = y := by simp [hs]
  have hsn : ‖s‖ ^ 2 = c ^ 2 + y ^ 2 := by
    rw [Complex.sq_norm, Complex.normSq_apply, hsre, hsim]
    ring
  have hsc : c ≤ ‖s‖ := hsre ▸ Complex.re_le_norm s
  have hs0 : 0 < ‖s‖ := lt_of_lt_of_le hc hsc
  -- the Gaussian factor
  have hE : ‖cexp (s ^ 2)‖ = Real.exp (c ^ 2 - y ^ 2) := by
    rw [norm_exp]
    congr 1
    rw [sq, Complex.mul_re, hsre, hsim]
    ring
  -- the polynomial factor
  have hp : ‖((α + β) ^ 2 - (2 * s) ^ 2) / (α + β) ^ 2‖ ≤ Q * (1 + y ^ 2) := by
    rw [norm_div, norm_pow]
    have hnum : ‖(α + β) ^ 2 - (2 * s) ^ 2‖ ≤ A + 4 * (c ^ 2 + y ^ 2) := by
      calc ‖(α + β) ^ 2 - (2 * s) ^ 2‖ ≤ ‖(α + β) ^ 2‖ + ‖(2 * s) ^ 2‖ := norm_sub_le _ _
        _ = A + 4 * (c ^ 2 + y ^ 2) := by
          rw [norm_pow, norm_pow, norm_mul, mul_pow, hsn, hA]
          norm_num
    have hnum2 : A + 4 * (c ^ 2 + y ^ 2) ≤ (A + 4 * c ^ 2 + 4) * (1 + y ^ 2) := by
      nlinarith [sq_nonneg y, sq_nonneg c, mul_nonneg hA0 (sq_nonneg y),
        mul_nonneg (sq_nonneg c) (sq_nonneg y)]
    calc ‖(α + β) ^ 2 - (2 * s) ^ 2‖ / ‖α + β‖ ^ 2
        ≤ (A + 4 * c ^ 2 + 4) * (1 + y ^ 2) / A :=
          div_le_div_of_nonneg_right (hnum.trans hnum2) hA0
      _ = Q * (1 + y ^ 2) := by rw [hQ]; ring
  -- the Gamma factor
  have hg : ‖gY α β t s‖ ≤ M := by
    rw [gY, norm_div, norm_mul]
    have h1 : 0 < (uA α t + s).re := by rw [Complex.add_re, uA_re, hsre]; linarith
    have h2 : 0 < (vB β t + s).re := by rw [Complex.add_re, vB_re, hsre]; linarith
    have g1 := norm_Gammaℝ_le h1
    have g2 := norm_Gammaℝ_le h2
    rw [Complex.add_re, uA_re, hsre] at g1
    rw [Complex.add_re, vB_re, hsre] at g2
    exact div_le_div_of_nonneg_right
      (mul_le_mul g1 g2 (norm_nonneg _) hB10) (norm_nonneg _)
  -- the factor `1/s`
  have hinv : 1 / ‖s‖ ≤ 1 / c := one_div_le_one_div_of_le hc hsc
  -- the exponential absorbs `1 + y²`
  have hexp : Real.exp (c ^ 2 - y ^ 2) * (1 + y ^ 2) ≤
      2 * Real.exp (c ^ 2) * Real.exp (-(1 / 2) * y ^ 2) := by
    have h1 := Real.add_one_le_exp (y ^ 2 / 2)
    have h2 : 1 + y ^ 2 ≤ 2 * Real.exp (y ^ 2 / 2) := by nlinarith [sq_nonneg y]
    have h3 : Real.exp (c ^ 2 - y ^ 2) * Real.exp (y ^ 2 / 2) =
        Real.exp (c ^ 2) * Real.exp (-(1 / 2) * y ^ 2) := by
      rw [← Real.exp_add, ← Real.exp_add]
      congr 1
      ring
    calc Real.exp (c ^ 2 - y ^ 2) * (1 + y ^ 2)
        ≤ Real.exp (c ^ 2 - y ^ 2) * (2 * Real.exp (y ^ 2 / 2)) :=
          mul_le_mul_of_nonneg_left h2 (Real.exp_pos _).le
      _ = 2 * Real.exp (c ^ 2) * Real.exp (-(1 / 2) * y ^ 2) := by rw [← mul_assoc,
          mul_comm (Real.exp (c ^ 2 - y ^ 2)) 2, mul_assoc, h3, ← mul_assoc]
  have hK : ‖KY α β t s‖ ≤ (Real.exp (c ^ 2 - y ^ 2) * (1 + y ^ 2)) * (Q * (1 / c) * M) := by
    rw [KY, GY, norm_mul, norm_div, norm_mul, hE]
    calc Real.exp (c ^ 2 - y ^ 2) * ‖((α + β) ^ 2 - (2 * s) ^ 2) / (α + β) ^ 2‖ / ‖s‖ *
          ‖gY α β t s‖
        = Real.exp (c ^ 2 - y ^ 2) * ‖((α + β) ^ 2 - (2 * s) ^ 2) / (α + β) ^ 2‖ *
          (1 / ‖s‖) * ‖gY α β t s‖ := by ring
      _ ≤ Real.exp (c ^ 2 - y ^ 2) * (Q * (1 + y ^ 2)) * (1 / c) * M := by
          gcongr
      _ = (Real.exp (c ^ 2 - y ^ 2) * (1 + y ^ 2)) * (Q * (1 / c) * M) := by ring
  calc ‖KY α β t s‖ ≤ (Real.exp (c ^ 2 - y ^ 2) * (1 + y ^ 2)) * (Q * (1 / c) * M) := hK
    _ ≤ (2 * Real.exp (c ^ 2) * Real.exp (-(1 / 2) * y ^ 2)) * (Q * (1 / c) * M) :=
        mul_le_mul_of_nonneg_right hexp (by positivity)
    _ = 2 * Real.exp (c ^ 2) * (Q * (1 / c) * M) * Real.exp (-(1 / 2) * y ^ 2) := by ring

/-- The kernel is differentiable at `s ≠ 0` where `Gammaℝ(u+s), Gammaℝ(v+s) ≠ 0`. -/
theorem KY_differentiableAt {α β : ℂ} {t : ℝ} {s : ℂ} (hs : s ≠ 0)
    (h1 : Gammaℝ (uA α t + s) ≠ 0) (h2 : Gammaℝ (vB β t + s) ≠ 0) :
    DifferentiableAt ℂ (KY α β t) s := by
  have hG : DifferentiableAt ℂ (GY α β) s := by
    unfold GY
    fun_prop
  have hg1 : DifferentiableAt ℂ (fun s => Gammaℝ (uA α t + s)) s :=
    (differentiableAt_Gammaℝ h1).comp s (by fun_prop)
  have hg2 : DifferentiableAt ℂ (fun s => Gammaℝ (vB β t + s)) s :=
    (differentiableAt_Gammaℝ h2).comp s (by fun_prop)
  have hg : DifferentiableAt ℂ (gY α β t) s := by
    unfold gY
    exact (hg1.mul hg2).div_const _
  unfold KY
  exact (hG.div differentiableAt_id hs).mul hg

/-- On `Re s = c > 0` with `Re(u+s), Re(v+s) > 0`, the kernel is continuous in `y`. -/
theorem KY_continuous_line {α β : ℂ} {t c : ℝ} (hc : 0 < c) (hu : 0 < 1 / 2 + α.re + c)
    (hv : 0 < 1 / 2 + β.re + c) :
    Continuous fun y : ℝ => KY α β t (c + y * I) := by
  rw [continuous_iff_continuousAt]
  intro y
  have hre : ((c : ℂ) + y * I).re = c := by simp
  have hs0 : ((c : ℂ) + y * I) ≠ 0 := by
    intro h
    rw [h] at hre
    simp at hre
    linarith
  have h1 : Gammaℝ (uA α t + (c + y * I)) ≠ 0 :=
    Gammaℝ_ne_zero_of_re_pos (by rw [Complex.add_re, uA_re, hre]; linarith)
  have h2 : Gammaℝ (vB β t + (c + y * I)) ≠ 0 :=
    Gammaℝ_ne_zero_of_re_pos (by rw [Complex.add_re, vB_re, hre]; linarith)
  exact ContinuousAt.comp (f := fun y : ℝ => (c : ℂ) + ↑y * I)
    (KY_differentiableAt hs0 h1 h2).continuousAt (by fun_prop)

/-- The pointwise sum: `Σ m^(−u) n^(−v) K(s) (mn)^(−s) = K(s) ζ(u+s) ζ(v+s)`. -/
theorem tsum_pointwise {u v s K : ℂ} (h1 : 1 < (u + s).re) (h2 : 1 < (v + s).re) :
    ∑' p : ℕ × ℕ, ((p.1 : ℂ) + 1) ^ (-u) * ((p.2 : ℂ) + 1) ^ (-v) *
        (K * ((((p.1 : ℝ) + 1) * ((p.2 : ℝ) + 1) : ℝ) : ℂ) ^ (-s)) =
      K * (riemannZeta (u + s) * riemannZeta (v + s)) := by
  rw [zeta_eq_tsum_one_div_nat_add_one_cpow h1, zeta_eq_tsum_one_div_nat_add_one_cpow h2,
    tsum_mul_tsum_of_summable_norm (summable_zeta_norm h1) (summable_zeta_norm h2),
    ← tsum_mul_left]
  congr 1
  funext p
  obtain ⟨m, n⟩ := p
  have hm : (m : ℂ) + 1 = ((m + 1 : ℕ) : ℂ) := by push_cast; ring
  have hn : (n : ℂ) + 1 = ((n + 1 : ℕ) : ℂ) := by push_cast; ring
  have hx : ((((m : ℝ) + 1) * ((n : ℝ) + 1) : ℝ) : ℂ) = ((m + 1 : ℕ) : ℂ) * ((n + 1 : ℕ) : ℂ) := by
    push_cast
    ring
  have ha : ((m + 1 : ℕ) : ℂ) ≠ 0 := Nat.cast_ne_zero.mpr (Nat.succ_ne_zero m)
  have hb : ((n + 1 : ℕ) : ℂ) ≠ 0 := Nat.cast_ne_zero.mpr (Nat.succ_ne_zero n)
  simp only
  rw [hx, natCast_mul_natCast_cpow, hm, hn, one_div, one_div, ← cpow_neg, ← cpow_neg,
    neg_add, neg_add, cpow_add _ _ ha, cpow_add _ _ hb]
  ring

/-- Piece 2. For `c > 0` with `c + Re α > 1/2` and `c + Re β > 1/2`,
`Σ_{m,n} m^(−1/2−α−it) n^(−1/2−β+it) V_c(mn,t) = (1/2πi) ∫_(c) G(s)/s g(s,t) ζ(u+s) ζ(v+s) ds`. -/
theorem mellin_double_sum {α β : ℂ} {t c : ℝ} (hc : 0 < c) (hu : 1 / 2 < c + α.re)
    (hv : 1 / 2 < c + β.re) :
    ∑' p : ℕ × ℕ, ((p.1 : ℂ) + 1) ^ (-uA α t) * ((p.2 : ℂ) + 1) ^ (-vB β t) *
        VY α β c (((p.1 : ℝ) + 1) * ((p.2 : ℝ) + 1)) t =
      VerticalIntegral' (FY α β t) c := by
  obtain ⟨C, hC0, hC⟩ := KY_bound (α := α) (β := β) (t := t) hc (by linarith) (by linarith)
  have hcont := KY_continuous_line (α := α) (β := β) (t := t) hc (by linarith) (by linarith)
  set L : ℝ → ℂ := fun y => (c : ℂ) + y * I with hL
  set xp : ℕ × ℕ → ℝ := fun p => ((p.1 : ℝ) + 1) * ((p.2 : ℝ) + 1) with hxp
  set cf : ℕ × ℕ → ℂ := fun p => ((p.1 : ℂ) + 1) ^ (-uA α t) * ((p.2 : ℂ) + 1) ^ (-vB β t)
    with hcf
  set F : ℕ × ℕ → ℝ → ℂ := fun p y => cf p * (KY α β t (L y) * ((xp p : ℝ) : ℂ) ^ (-L y))
    with hF
  have hxp0 : ∀ p, 0 < xp p := fun p => by simp only [hxp]; positivity
  have hLre : ∀ y, (L y).re = c := fun y => by simp [hL]
  -- the norm of the power of `xp`
  have hxpow : ∀ p y, ‖((xp p : ℝ) : ℂ) ^ (-L y)‖ = xp p ^ (-c) := fun p y => by
    rw [norm_cpow_eq_rpow_re_of_pos (hxp0 p), Complex.neg_re, hLre]
  -- the norm of `F p y`
  have hFn : ∀ p y, ‖F p y‖ = (‖cf p‖ * xp p ^ (-c)) * ‖KY α β t (L y)‖ := fun p y => by
    simp only [hF, norm_mul, hxpow]
    ring
  have hGint : Integrable (fun y : ℝ => C * Real.exp (-(1 / 2) * y ^ 2)) :=
    (integrable_exp_neg_mul_sq (by norm_num : (0 : ℝ) < 1 / 2)).const_mul C
  have hKint : Integrable (fun y : ℝ => KY α β t (L y)) :=
    Integrable.mono' hGint hcont.aestronglyMeasurable (ae_of_all _ hC)
  have hFint : ∀ p, Integrable (F p) := fun p => by
    have hc2 : Continuous fun y : ℝ => ((xp p : ℝ) : ℂ) ^ (-L y) :=
      Continuous.const_cpow (by fun_prop) (Or.inl (ofReal_ne_zero.mpr (hxp0 p).ne'))
    refine Integrable.mono' (hKint.norm.const_mul (‖cf p‖ * xp p ^ (-c)))
      ((hcont.mul hc2).const_mul (cf p)).aestronglyMeasurable (ae_of_all _ fun y => ?_)
    rw [hFn]
  -- the summability of the integrals of the norms
  set I0 : ℝ := ∫ y, ‖KY α β t (L y)‖
  set a : ℕ → ℝ := fun m => ((m : ℝ) + 1) ^ ((-uA α t).re + -c)
  set b : ℕ → ℝ := fun n => ((n : ℝ) + 1) ^ ((-vB β t).re + -c)
  have hab : ∀ p : ℕ × ℕ, ‖cf p‖ * xp p ^ (-c) = a p.1 * b p.2 := fun p => by
    simp only [hcf, hxp, a, b]
    rw [norm_mul, norm_succ_cpow, norm_succ_cpow, Real.mul_rpow (by positivity) (by positivity),
      Real.rpow_add (by positivity), Real.rpow_add (by positivity)]
    ring
  have hsum : Summable fun p : ℕ × ℕ => ∫ y, ‖F p y‖ := by
    have ha : Summable a := summable_succ_rpow (by rw [Complex.neg_re, uA_re]; linarith)
    have hb : Summable b := summable_succ_rpow (by rw [Complex.neg_re, vB_re]; linarith)
    have hprod := (Summable.mul_of_nonneg ha hb (fun m => by positivity)
      (fun n => by positivity)).mul_right I0
    refine hprod.congr fun p => ?_
    simp only [hFn]
    rw [integral_const_mul, hab]
  -- the pointwise sum
  have hpt : ∀ y, ∑' p, F p y = FY α β t (L y) := fun y => by
    simp only [hF, hcf, hxp]
    rw [FY]
    exact tsum_pointwise (by rw [Complex.add_re, uA_re, hLre]; linarith)
      (by rw [Complex.add_re, vB_re, hLre]; linarith)
  -- assembly
  simp only [VY, VerticalIntegral', VerticalIntegral, smul_eq_mul]
  calc ∑' p : ℕ × ℕ, ((p.1 : ℂ) + 1) ^ (-uA α t) * ((p.2 : ℂ) + 1) ^ (-vB β t) *
        (1 / (2 * ↑Real.pi * I) * (I * ∫ y : ℝ, KY α β t (↑c + ↑y * I) *
          (↑(((p.1 : ℝ) + 1) * ((p.2 : ℝ) + 1)) : ℂ) ^ (-(↑c + ↑y * I))))
      = ∑' p : ℕ × ℕ, 1 / (2 * ↑Real.pi * I) * (I * ∫ y : ℝ, F p y) := by
        refine tsum_congr fun p => ?_
        simp only [hF, hcf, hxp, hL]
        rw [integral_const_mul]
        ring
    _ = 1 / (2 * ↑Real.pi * I) * (I * ∫ y : ℝ, ∑' p, F p y) := by
        rw [tsum_mul_left, tsum_mul_left, integral_tsum_of_summable_integral_norm hFint hsum]
    _ = 1 / (2 * ↑Real.pi * I) * (I * ∫ y : ℝ, FY α β t (↑c + ↑y * I)) := by
        simp only [hpt, hL]

/-! ## Piece 3: the left line, through the functional equation -/

/-- `G` is even. -/
theorem GY_neg (α β s : ℂ) : GY α β (-s) = GY α β s := by
  unfold GY
  ring_nf

/-- `G` for `(−β,−α)` is `G` for `(α,β)`. -/
theorem GY_swap (α β s : ℂ) : GY (-β) (-α) s = GY α β s := by
  unfold GY
  ring_nf

/-- The swap `(α,β) ↦ (−β,−α)` sends `u` to `1 − v`. -/
theorem uA_neg (β : ℂ) (t : ℝ) : uA (-β) t = 1 - vB β t := by
  unfold uA vB
  ring

/-- The swap `(α,β) ↦ (−β,−α)` sends `v` to `1 − u`. -/
theorem vB_neg (α : ℂ) (t : ℝ) : vB (-α) t = 1 - uA α t := by
  unfold uA vB
  ring

/-- `Gammaℝ w · ζ w = Λ w` where `Gammaℝ w ≠ 0`. -/
theorem gamma_mul_zeta {w : ℂ} (hw : Gammaℝ w ≠ 0) :
    Gammaℝ w * riemannZeta w = completedRiemannZeta w := by
  have hw0 : w ≠ 0 := by
    rintro rfl
    exact hw (Gammaℝ_eq_zero_iff.mpr ⟨0, by simp⟩)
  rw [riemannZeta_def_of_ne_zero hw0]
  field_simp
  try ring

/-- The left line in terms of the right: `FY(−s) = −X_{α,β,t} · FY_{−β,−α}(s)`. -/
theorem FY_reflect {α β : ℂ} {t : ℝ} {s : ℂ} (hα : α.re < 1 / 2) (hβ : β.re < 1 / 2)
    (hu : Gammaℝ (uA α t) ≠ 0) (hv : Gammaℝ (vB β t) ≠ 0) (hs0 : s ≠ 0)
    (h1 : 0 < (1 - uA α t + s).re) (h2 : 0 < (1 - vB β t + s).re)
    (hg1 : Gammaℝ (uA α t + -s) ≠ 0) (hg2 : Gammaℝ (vB β t + -s) ≠ 0) :
    FY α β t (-s) = -(XY α β t * FY (-β) (-α) t s) := by
  have hu1 : Gammaℝ (1 - uA α t) ≠ 0 :=
    Gammaℝ_ne_zero_of_re_pos (by rw [Complex.sub_re, uA_re]; simp; linarith)
  have hv1 : Gammaℝ (1 - vB β t) ≠ 0 :=
    Gammaℝ_ne_zero_of_re_pos (by rw [Complex.sub_re, vB_re]; simp; linarith)
  have z1 : Gammaℝ (uA α t + -s) * riemannZeta (uA α t + -s) =
      completedRiemannZeta (1 - uA α t + s) := by
    rw [gamma_mul_zeta hg1, ← completedRiemannZeta_one_sub]
    congr 1
    ring
  have z2 : Gammaℝ (vB β t + -s) * riemannZeta (vB β t + -s) =
      completedRiemannZeta (1 - vB β t + s) := by
    rw [gamma_mul_zeta hg2, ← completedRiemannZeta_one_sub]
    congr 1
    ring
  have z3 := gamma_mul_zeta (Gammaℝ_ne_zero_of_re_pos h1)
  have z4 := gamma_mul_zeta (Gammaℝ_ne_zero_of_re_pos h2)
  have L1 : FY α β t (-s) = GY α β (-s) / (-s) / (Gammaℝ (uA α t) * Gammaℝ (vB β t)) *
      ((Gammaℝ (uA α t + -s) * riemannZeta (uA α t + -s)) *
        (Gammaℝ (vB β t + -s) * riemannZeta (vB β t + -s))) := by
    simp only [FY, KY, gY]
    ring
  have R1 : FY (-β) (-α) t s = GY (-β) (-α) s / s /
      (Gammaℝ (1 - vB β t) * Gammaℝ (1 - uA α t)) *
      ((Gammaℝ (1 - vB β t + s) * riemannZeta (1 - vB β t + s)) *
        (Gammaℝ (1 - uA α t + s) * riemannZeta (1 - uA α t + s))) := by
    simp only [FY, KY, gY, uA_neg, vB_neg]
    ring
  rw [L1, R1, z1, z2, z3, z4, GY_neg, GY_swap]
  unfold XY
  field_simp
  try ring

/-- Off the two heights `y = Im u` and `y = Im v`, the reflection's hypotheses hold on
`Re s = c`. -/
theorem gamma_ne_off {w : ℂ} {c y : ℝ} (hy : y ≠ w.im) :
    Gammaℝ (w + -((c : ℂ) + y * I)) ≠ 0 := by
  intro h
  obtain ⟨n, hn⟩ := Gammaℝ_eq_zero_iff.mp h
  have him := congrArg Complex.im hn
  simp at him
  exact hy (by linarith)

/-- The left line: `(1/2πi)∫_(−c) FY = −X_{α,β,t} · (1/2πi)∫_(c) FY_{−β,−α}`. -/
theorem vertInt_reflect {α β : ℂ} {t c : ℝ} (hc : 0 < c) (hα : α.re < 1 / 2)
    (hβ : β.re < 1 / 2) (hu : Gammaℝ (uA α t) ≠ 0) (hv : Gammaℝ (vB β t) ≠ 0) :
    VerticalIntegral' (FY α β t) (-c) =
      -(XY α β t * VerticalIntegral' (FY (-β) (-α) t) c) := by
  simp only [VerticalIntegral', VerticalIntegral, smul_eq_mul]
  have hneg : (∫ y : ℝ, FY α β t (↑(-c) + ↑y * I)) =
      ∫ y : ℝ, FY α β t (-((c : ℂ) + y * I)) := by
    rw [← integral_neg_eq_self (fun y : ℝ => FY α β t (-((c : ℂ) + y * I))) volume]
    congr 1
    funext y
    congr 1
    push_cast
    ring
  have hae : (fun y : ℝ => FY α β t (-((c : ℂ) + y * I))) =ᵐ[volume]
      fun y : ℝ => -(XY α β t * FY (-β) (-α) t ((c : ℂ) + y * I)) := by
    have e1 : ∀ᵐ y : ℝ ∂volume, y ∉ ({(uA α t).im} : Set ℝ) :=
      measure_eq_zero_iff_ae_notMem.mp (measure_singleton _)
    have e2 : ∀ᵐ y : ℝ ∂volume, y ∉ ({(vB β t).im} : Set ℝ) :=
      measure_eq_zero_iff_ae_notMem.mp (measure_singleton _)
    filter_upwards [e1, e2] with y hy1 hy2
    have hre : ((c : ℂ) + y * I).re = c := by simp
    have hs0 : ((c : ℂ) + y * I) ≠ 0 := by
      intro h
      rw [h] at hre
      simp at hre
      linarith
    exact FY_reflect hα hβ hu hv hs0
      (by rw [Complex.add_re, Complex.sub_re, uA_re, hre]; simp; linarith)
      (by rw [Complex.add_re, Complex.sub_re, vB_re, hre]; simp; linarith)
      (gamma_ne_off hy1) (gamma_ne_off hy2)
  rw [hneg, integral_congr_ae hae, integral_neg, integral_const_mul]
  ring

/-! ## Piece 3: the residue at `s = 0` -/

/-- `G(0) = 1` once `α + β ≠ 0`. -/
theorem GY_zero {α β : ℂ} (h : α + β ≠ 0) : GY α β 0 = 1 := by
  have h2 : (α + β) ^ 2 ≠ 0 := pow_ne_zero 2 h
  unfold GY
  simp [h2]

/-- `g(0,t) = 1` once `Gammaℝ u, Gammaℝ v ≠ 0`. -/
theorem gY_zero {α β : ℂ} {t : ℝ} (hu : Gammaℝ (uA α t) ≠ 0) (hv : Gammaℝ (vB β t) ≠ 0) :
    gY α β t 0 = 1 := by
  unfold gY
  simp only [add_zero]
  field_simp
  try ring

/-- The residue at `s = 0`: `s · FY(s) → ζ(u) ζ(v)`. -/
theorem residue_zero {α β : ℂ} {t : ℝ} (hαβ : α + β ≠ 0) (hα : α.re < 1 / 2)
    (hβ : β.re < 1 / 2) (hu : Gammaℝ (uA α t) ≠ 0) (hv : Gammaℝ (vB β t) ≠ 0) :
    Tendsto (fun s => s * FY α β t s) (𝓝[≠] 0)
      (𝓝 (riemannZeta (uA α t) * riemannZeta (vB β t))) := by
  have hu1 : uA α t ≠ 1 := by
    intro h
    have := congrArg Complex.re h
    rw [uA_re] at this
    simp at this
    linarith
  have hv1 : vB β t ≠ 1 := by
    intro h
    have := congrArg Complex.re h
    rw [vB_re] at this
    simp at this
    linarith
  set H : ℂ → ℂ := fun s => GY α β s * gY α β t s *
    (riemannZeta (uA α t + s) * riemannZeta (vB β t + s)) with hH
  have hcont : ContinuousAt H 0 := by
    have hG : ContinuousAt (GY α β) 0 := by
      unfold GY
      fun_prop
    have hg1 : ContinuousAt (fun s => Gammaℝ (uA α t + s)) 0 :=
      (differentiableAt_Gammaℝ (by simpa using hu)).continuousAt.comp (by fun_prop)
    have hg2 : ContinuousAt (fun s => Gammaℝ (vB β t + s)) 0 :=
      (differentiableAt_Gammaℝ (by simpa using hv)).continuousAt.comp (by fun_prop)
    have hz1 : ContinuousAt (fun s => riemannZeta (uA α t + s)) 0 :=
      (differentiableAt_riemannZeta (by simpa using hu1)).continuousAt.comp (by fun_prop)
    have hz2 : ContinuousAt (fun s => riemannZeta (vB β t + s)) 0 :=
      (differentiableAt_riemannZeta (by simpa using hv1)).continuousAt.comp (by fun_prop)
    have hg : ContinuousAt (gY α β t) 0 := by
      unfold gY
      exact (hg1.mul hg2).div_const _
    exact (hG.mul hg).mul (hz1.mul hz2)
  have hH0 : H 0 = riemannZeta (uA α t) * riemannZeta (vB β t) := by
    simp only [hH, GY_zero hαβ, gY_zero hu hv, add_zero, one_mul]
  have hlim : Tendsto H (𝓝[≠] 0) (𝓝 (riemannZeta (uA α t) * riemannZeta (vB β t))) := by
    rw [← hH0]
    exact hcont.tendsto.mono_left nhdsWithin_le_nhds
  refine hlim.congr' ?_
  filter_upwards [self_mem_nhdsWithin] with s hs
  have hs' : s ≠ 0 := hs
  simp only [hH, FY, KY]
  field_simp
  try ring

/-! ## Piece 3: the shift, open, and Lemma 4 given the shift -/

/-- The sum of the residues of `FY` at its four poles other than `0`: at `s = 1 − u`,
`−u`, `1 − v`, `−v` (the poles of `Λ(u+s)` and `Λ(v+s)`). `Λ` has residue `1` at `1`
and `−1` at `0`. Young's `O_A((1+|t|)^(−A))`. -/
noncomputable
def resY (α β : ℂ) (t : ℝ) : ℂ :=
  (GY α β (1 - uA α t) / (1 - uA α t) * completedRiemannZeta (vB β t + 1 - uA α t) +
    GY α β (-uA α t) / uA α t * completedRiemannZeta (vB β t - uA α t) +
    GY α β (1 - vB β t) / (1 - vB β t) * completedRiemannZeta (uA α t + 1 - vB β t) +
    GY α β (-vB β t) / vB β t * completedRiemannZeta (uA α t - vB β t)) /
  (Gammaℝ (uA α t) * Gammaℝ (vB β t))

/-- OPEN. The contour shift from `Re s = c` to `Re s = −c`:
`(1/2πi)∫_(c) FY − (1/2πi)∫_(−c) FY = ζ(u)ζ(v) + resY`, the residues at `0`
(`residue_zero`) and at the four poles of `resY`, all inside the strip for
`c > 1/2 + |Re α|, 1/2 + |Re β|`, when the five poles are distinct.
Citation shape: [IK] Theorem 5.3's proof. Route: `ContourShift.residue_rectangle_multi`
on `[−c, c] × [−T, T]`, `FY = G(s)/s·Λ(u+s)Λ(v+s)/(Gammaℝ u Gammaℝ v)` off the trivial
zeros, and the horizontal edges `→ 0` by `|G| ≤ e^(c²−T²)·poly` against a bound for
`Λ₀` on the strip (`|mellin f (σ+iy)| ≤ mellin |f| σ`). -/
noncomputable
def StmtShift (α β : ℂ) (t c : ℝ) : Prop :=
  VerticalIntegral' (FY α β t) c - VerticalIntegral' (FY α β t) (-c) =
    riemannZeta (uA α t) * riemannZeta (vB β t) + resY α β t

/-- Young's Lemma 4, exact, given the shift. For `|Re α|, |Re β| < 1/2`, `c` with
`c > 1/2 + |Re α|, 1/2 + |Re β|`:
`ζ(1/2+α+it) ζ(1/2+β−it) = Σ_{m,n} m^(−1/2−α−it) n^(−1/2−β+it) V_{α,β}(mn,t)
  + X_{α,β,t} Σ_{m,n} m^(−1/2+β−it) n^(−1/2+α+it) V_{−β,−α}(mn,t) − resY`,
both `V` read on the line `Re s = c`. -/
theorem approxFE_of_shift {α β : ℂ} {t c : ℝ} (hα : α.re < 1 / 2) (hβ : β.re < 1 / 2)
    (hα' : -(1 / 2) < α.re) (hβ' : -(1 / 2) < β.re)
    (hcα : 1 / 2 + |α.re| < c) (hcβ : 1 / 2 + |β.re| < c) (hshift : StmtShift α β t c) :
    riemannZeta (uA α t) * riemannZeta (vB β t) =
      (∑' p : ℕ × ℕ, ((p.1 : ℂ) + 1) ^ (-uA α t) * ((p.2 : ℂ) + 1) ^ (-vB β t) *
        VY α β c (((p.1 : ℝ) + 1) * ((p.2 : ℝ) + 1)) t) +
      XY α β t * (∑' p : ℕ × ℕ, ((p.1 : ℂ) + 1) ^ (-uA (-β) t) *
        ((p.2 : ℂ) + 1) ^ (-vB (-α) t) *
        VY (-β) (-α) c (((p.1 : ℝ) + 1) * ((p.2 : ℝ) + 1)) t) - resY α β t := by
  have ha1 := le_abs_self α.re
  have ha2 := neg_abs_le α.re
  have hb1 := le_abs_self β.re
  have hb2 := neg_abs_le β.re
  have hc : 0 < c := by linarith [abs_nonneg α.re]
  have hu := Gammaℝ_uA_ne t hα'
  have hv := Gammaℝ_vB_ne t hβ'
  rw [mellin_double_sum hc (by linarith) (by linarith),
    mellin_double_sum (α := -β) (β := -α) hc (by rw [Complex.neg_re]; linarith)
      (by rw [Complex.neg_re]; linarith)]
  unfold StmtShift at hshift
  rw [vertInt_reflect hc hα hβ hu hv] at hshift
  linear_combination -hshift

/-! ## Axiom pins -/

/-- info: 'ApproxFE.zeta_prod_fe' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms zeta_prod_fe

/-- info: 'ApproxFE.XY_eq_young' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms XY_eq_young

/-- info: 'ApproxFE.gY_eq_young' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms gY_eq_young

/-- info: 'ApproxFE.coef_eq_young' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms coef_eq_young

/-- info: 'ApproxFE.mellin_double_sum' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms mellin_double_sum

/-- info: 'ApproxFE.FY_reflect' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms FY_reflect

/-- info: 'ApproxFE.vertInt_reflect' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms vertInt_reflect

/-- info: 'ApproxFE.residue_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms residue_zero

/-- info: 'ApproxFE.approxFE_of_shift' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms approxFE_of_shift

end ApproxFE
