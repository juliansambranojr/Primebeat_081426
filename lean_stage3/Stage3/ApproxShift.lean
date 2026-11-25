/-
# ApproxShift — block S12 of `lean_stage3/design/stencil.md`, the contour shift. 2026-11-25.

Discharges `ApproxFE.StmtShift`, and with it Young's Lemma 4 (arXiv 1002.4403, §4) exactly,
remainder `−resY`. Notation as in `ApproxFE`: `u = uA α t`, `v = vB β t`.

The route. `FL α β t s = G(s)/s · Λ(u+s) Λ(v+s) / (Gammaℝ u Gammaℝ v)` equals `FY` off the
two heights `Im s = −Im u, −Im v` (`FY_eq_FL`), so the vertical integrals agree
(`vertInt_FY_eq_FL`). `FL` is holomorphic off the five poles `0, 1−u, −u, 1−v, −v`
(`FL_differentiableAt`), each simple with an explicit residue (`local_zero`, `local_pole_one`,
`local_pole_neg`, from `Λ = Λ₀ − 1/s − 1/(1−s)`). `ContourShift.residue_rectangle_of_local`
on `[−c, c] × [−T, T]` gives the rectangle integral as the residue sum for every `T` past the
poles. As `T → ∞` the horizontal edges vanish (`FL_horiz_tendsto`, from target 1) and the
vertical edges tend to the two line integrals (`rect_tendsto`, integrability from
`FL_line_integrable`).

Target 1. `‖Λ w‖ ≤ M (6 + 4‖w‖)` on `|Re w| ≤ R`, `|Im w| ≥ 1` (`Lambda_bound`): for `Re w ≥ 1/2`,
`‖Gammaℝ w‖ ≤ π^(−Re w/2) Γ(Re w/2)` (bounded by compactness) and
`‖ζ w‖ ≤ 2 + 4‖w‖` (`LevinsonEdge.zeta_norm_le`, with `ζ(conj w) = conj ζ(w)` for `Im w < 0`);
for `Re w < 1/2`, `Λ w = Λ(1−w)`. With `‖G(s)‖ ≤ e^(c² − y²) Q (1 + y²)` this gives
`‖FL s‖ ≤ C e^(−y²/2)` for `|Re s| ≤ c`, `|Im s| = |y| ≥ Y₀` (`FL_bound`), and the same for
`FY` (`FY_horiz_bound`).

| statement | content | status |
|---|---|---|
| `zeta_norm_le_abs` | `‖ζ w‖ ≤ 2 + 4‖w‖`, `Re w ≥ 1/4`, `|Im w| ≥ 1` | proved |
| `gammaR_bound` | `‖Gammaℝ w‖ ≤ M` on `1/2 ≤ Re w ≤ R` | proved |
| `Lambda_bound` | `‖Λ w‖ ≤ M (6 + 4‖w‖)` on `|Re w| ≤ R`, `|Im w| ≥ 1` | proved |
| `GY_norm_le`, `poly_gauss` | `‖G s‖ ≤ e^(c²−y²) Q (1+y²)`; `(1+y²)³ e^(−y²) ≤ 216 e^(−y²/2)` | proved |
| `FL_bound` | target 1 for `FL`: `‖FL s‖ ≤ C e^(−y²/2)`, `|Re s| ≤ c`, `|Im s| ≥ Y₀` | proved |
| `FY_horiz_bound` | target 1 for `FY`, same shape | proved |
| `FL_horiz_tendsto` | `∫_{−c}^{c} FL(x+iy) dx → 0` as `y → ±∞` | proved |
| `FL_line_integrable`, `vertInt_FY_eq_FL` | `FL` integrable on `Re s = ±c`; `∫_(σ) FY = ∫_(σ) FL` | proved |
| `local_zero`, `local_pole_one`, `local_pole_neg` | the five simple poles and their residues | proved |
| `rect_tendsto` | rectangle integral `→ ∫_(c) − ∫_(−c)` (PNT+ `PerronFormula`'s, re-proved) | proved |
| `stmtShift_holds` | target 2: `StmtShift α β t c` | proved |
| `approxFE` | target 3: Lemma 4's identity with no shift hypothesis | proved |
| (4.3), and `resY ≪_A (1+|t|)^(−A)` | the bounds | OPEN, not stated |

Hypotheses of `stmtShift_holds`: `−1/2 < Re α, Re β < 1/2` (giving `Gammaℝ u, Gammaℝ v ≠ 0`),
`c > 1/2 + |Re α|, 1/2 + |Re β|`, `α + β ≠ 0` (`G(0) = 1`), and `u ≠ v`, which under the
other bounds is exactly the distinctness of the five poles.

Axioms: [propext, Classical.choice, Quot.sound], pinned below on each main theorem.
-/
import Stage3.ApproxFE
import Stage3.ContourShift
import Stage3.LevinsonEdge

namespace ApproxShift

open Complex MeasureTheory Filter Topology ApproxFE

/-! ## Growth on vertical strips -/

/-- `‖ζ w‖ ≤ 2 + 4‖w‖` for `Re w ≥ 1/4`, `|Im w| ≥ 1` (`LevinsonEdge.zeta_norm_le` and
`ζ(conj w) = conj ζ(w)`). -/
theorem zeta_norm_le_abs {w : ℂ} (hre : 1 / 4 ≤ w.re) (him : 1 ≤ |w.im|) :
    ‖riemannZeta w‖ ≤ 2 + 4 * ‖w‖ := by
  rcases le_or_gt 0 w.im with h | h
  · rw [abs_of_nonneg h] at him
    exact LevinsonEdge.zeta_norm_le hre him
  · rw [abs_of_neg h] at him
    have h1 := LevinsonEdge.zeta_norm_le (u := (starRingEnd ℂ) w) (by simpa using hre)
      (by simp; linarith)
    rw [riemannZeta_conj] at h1
    simpa using h1

/-- `‖Gammaℝ w‖` is bounded on `1/2 ≤ Re w ≤ R`. -/
theorem gammaR_bound (R : ℝ) :
    ∃ M : ℝ, 0 ≤ M ∧ ∀ w : ℂ, 1 / 2 ≤ w.re → w.re ≤ R → ‖Gammaℝ w‖ ≤ M := by
  have hc : ContinuousOn (fun x : ℝ => Real.pi ^ (-x / 2) * Real.Gamma (x / 2))
      (Set.Icc (1 / 2) R) := by
    intro x hx
    apply ContinuousAt.continuousWithinAt
    have hx0 : 0 < x / 2 := by linarith [hx.1]
    apply ContinuousAt.mul
    · exact (Real.continuousAt_const_rpow Real.pi_pos.ne').comp (by fun_prop)
    · have hG : ∀ m : ℕ, x / 2 ≠ -(m : ℝ) := fun m h => by
        have := m.cast_nonneg (α := ℝ)
        linarith
      exact ContinuousAt.comp (g := Real.Gamma) (f := fun x : ℝ => x / 2)
        (Real.differentiableAt_Gamma hG).continuousAt (by fun_prop)
  obtain ⟨C, hC⟩ := isCompact_Icc.exists_bound_of_continuousOn hc
  refine ⟨max C 0, le_max_right _ _, fun w h1 h2 => ?_⟩
  have h3 := hC w.re ⟨h1, h2⟩
  calc ‖Gammaℝ w‖ ≤ Real.pi ^ (-w.re / 2) * Real.Gamma (w.re / 2) := norm_Gammaℝ_le (by linarith)
    _ ≤ ‖Real.pi ^ (-w.re / 2) * Real.Gamma (w.re / 2)‖ := Real.le_norm_self _
    _ ≤ C := h3
    _ ≤ max C 0 := le_max_left _ _

/-- `‖Λ w‖ ≤ M (6 + 4‖w‖)` on `|Re w| ≤ R`, `|Im w| ≥ 1`: the `Gammaℝ` bound and the `ζ`
bound right of `1/2`, the functional equation `Λ w = Λ (1 − w)` left of it. -/
theorem Lambda_bound (R : ℝ) :
    ∃ M : ℝ, 0 ≤ M ∧ ∀ w : ℂ, |w.re| ≤ R → 1 ≤ |w.im| →
      ‖completedRiemannZeta w‖ ≤ M * (6 + 4 * ‖w‖) := by
  obtain ⟨M, hM0, hM⟩ := gammaR_bound (R + 1)
  refine ⟨M, hM0, fun w hre him => ?_⟩
  have key : ∀ z : ℂ, 1 / 2 ≤ z.re → z.re ≤ R + 1 → 1 ≤ |z.im| →
      ‖completedRiemannZeta z‖ ≤ M * (2 + 4 * ‖z‖) := by
    intro z h1 h2 h3
    have hG : Gammaℝ z ≠ 0 := Gammaℝ_ne_zero_of_re_pos (by linarith)
    rw [← gamma_mul_zeta hG, norm_mul]
    exact mul_le_mul (hM z h1 h2) (zeta_norm_le_abs (by linarith) h3) (norm_nonneg _) hM0
  have habs := abs_le.mp hre
  rcases le_or_gt (1 / 2) w.re with h | h
  · calc ‖completedRiemannZeta w‖ ≤ M * (2 + 4 * ‖w‖) := key w h (by linarith) him
      _ ≤ M * (6 + 4 * ‖w‖) := mul_le_mul_of_nonneg_left (by linarith) hM0
  · rw [← completedRiemannZeta_one_sub]
    have hn : ‖1 - w‖ ≤ 1 + ‖w‖ := by simpa using norm_sub_le (1 : ℂ) w
    calc ‖completedRiemannZeta (1 - w)‖ ≤ M * (2 + 4 * ‖1 - w‖) :=
          key (1 - w) (by simp; linarith) (by simp; linarith) (by simpa using him)
      _ ≤ M * (6 + 4 * ‖w‖) := mul_le_mul_of_nonneg_left (by linarith) hM0

/-- `‖G(s)‖ ≤ e^(c² − (Im s)²) · Q · (1 + (Im s)²)` on `|Re s| ≤ c`. -/
theorem GY_norm_le {α β : ℂ} {c : ℝ} {s : ℂ} (hs : |s.re| ≤ c) :
    ‖GY α β s‖ ≤ Real.exp (c ^ 2 - s.im ^ 2) *
      ((‖α + β‖ ^ 2 + 4 * c ^ 2 + 4) / ‖α + β‖ ^ 2 * (1 + s.im ^ 2)) := by
  have hx2 : s.re ^ 2 ≤ c ^ 2 := by
    rw [← sq_abs s.re]
    exact pow_le_pow_left₀ (abs_nonneg _) hs 2
  have hsn : ‖s‖ ^ 2 = s.re ^ 2 + s.im ^ 2 := by
    rw [Complex.sq_norm, Complex.normSq_apply]
    ring
  have hE : ‖cexp (s ^ 2)‖ ≤ Real.exp (c ^ 2 - s.im ^ 2) := by
    rw [norm_exp]
    apply Real.exp_le_exp.mpr
    rw [sq, Complex.mul_re]
    nlinarith
  have hA0 : 0 ≤ ‖α + β‖ ^ 2 := by positivity
  have hp : ‖((α + β) ^ 2 - (2 * s) ^ 2) / (α + β) ^ 2‖ ≤
      (‖α + β‖ ^ 2 + 4 * c ^ 2 + 4) / ‖α + β‖ ^ 2 * (1 + s.im ^ 2) := by
    rw [norm_div, norm_pow]
    have hnum : ‖(α + β) ^ 2 - (2 * s) ^ 2‖ ≤ ‖α + β‖ ^ 2 + 4 * (s.re ^ 2 + s.im ^ 2) := by
      calc ‖(α + β) ^ 2 - (2 * s) ^ 2‖ ≤ ‖(α + β) ^ 2‖ + ‖(2 * s) ^ 2‖ := norm_sub_le _ _
        _ = ‖α + β‖ ^ 2 + 4 * (s.re ^ 2 + s.im ^ 2) := by
          rw [norm_pow, norm_pow, norm_mul, mul_pow, hsn]
          norm_num
    have hnum2 : ‖α + β‖ ^ 2 + 4 * (s.re ^ 2 + s.im ^ 2) ≤
        (‖α + β‖ ^ 2 + 4 * c ^ 2 + 4) * (1 + s.im ^ 2) := by
      nlinarith [sq_nonneg s.im, sq_nonneg c, mul_nonneg hA0 (sq_nonneg s.im),
        mul_nonneg (sq_nonneg c) (sq_nonneg s.im)]
    calc ‖(α + β) ^ 2 - (2 * s) ^ 2‖ / ‖α + β‖ ^ 2
        ≤ (‖α + β‖ ^ 2 + 4 * c ^ 2 + 4) * (1 + s.im ^ 2) / ‖α + β‖ ^ 2 :=
          div_le_div_of_nonneg_right (hnum.trans hnum2) hA0
      _ = (‖α + β‖ ^ 2 + 4 * c ^ 2 + 4) / ‖α + β‖ ^ 2 * (1 + s.im ^ 2) := by ring
  rw [GY, norm_mul]
  exact mul_le_mul hE hp (norm_nonneg _) (Real.exp_pos _).le

/-- `(1 + y²)³ e^(−y²) ≤ 216 e^(−y²/2)`. -/
theorem poly_gauss (y : ℝ) :
    (1 + y ^ 2) ^ 3 * Real.exp (-y ^ 2) ≤ 216 * Real.exp (-(1 / 2) * y ^ 2) := by
  have h1 := Real.add_one_le_exp (y ^ 2 / 6)
  have h2 : 1 + y ^ 2 ≤ 6 * Real.exp (y ^ 2 / 6) := by nlinarith [sq_nonneg y]
  have h3 : (1 + y ^ 2) ^ 3 ≤ (6 * Real.exp (y ^ 2 / 6)) ^ 3 :=
    pow_le_pow_left₀ (by positivity) h2 3
  have h4 : (6 * Real.exp (y ^ 2 / 6)) ^ 3 * Real.exp (-y ^ 2) =
      216 * Real.exp (-(1 / 2) * y ^ 2) := by
    rw [mul_pow, ← Real.exp_nat_mul, mul_assoc, ← Real.exp_add]
    norm_num
    ring
  calc (1 + y ^ 2) ^ 3 * Real.exp (-y ^ 2) ≤ (6 * Real.exp (y ^ 2 / 6)) ^ 3 * Real.exp (-y ^ 2) :=
        mul_le_mul_of_nonneg_right h3 (Real.exp_pos _).le
    _ = 216 * Real.exp (-(1 / 2) * y ^ 2) := h4

/-! ## The integrand through `Λ` -/

/-- The integrand through `Λ`: `G(s)/s · Λ(u+s) Λ(v+s) / (Gammaℝ u Gammaℝ v)`. It equals `FY`
off the trivial zeros (`FY_eq_FL`) and is meromorphic with the five poles. -/
noncomputable
def FL (α β : ℂ) (t : ℝ) (s : ℂ) : ℂ :=
  GY α β s / s * (completedRiemannZeta (uA α t + s) * completedRiemannZeta (vB β t + s)) /
    (Gammaℝ (uA α t) * Gammaℝ (vB β t))

theorem FY_eq_FL {α β : ℂ} {t : ℝ} {s : ℂ} (h1 : Gammaℝ (uA α t + s) ≠ 0)
    (h2 : Gammaℝ (vB β t + s) ≠ 0) : FY α β t s = FL α β t s := by
  rw [FL, ← gamma_mul_zeta h1, ← gamma_mul_zeta h2]
  simp only [FY, KY, gY]
  ring

/-- `Gammaℝ w ≠ 0` off the real axis. -/
theorem Gammaℝ_ne_of_im {w : ℂ} (h : w.im ≠ 0) : Gammaℝ w ≠ 0 := by
  intro hw
  obtain ⟨n, hn⟩ := Gammaℝ_eq_zero_iff.mp hw
  apply h
  rw [hn]
  simp

/-- `|y| ≤ |a + y| + |a|`. -/
theorem abs_le_add_abs (a y : ℝ) : |y| ≤ |a + y| + |a| := by
  have h := abs_sub_abs_le_abs_sub y (-a)
  rw [abs_neg, sub_neg_eq_add, add_comm] at h
  linarith

/-- Target 1 for `FL`: on `|Re s| ≤ c`, `|Im s| ≥ Y₀`, `‖FL s‖ ≤ C e^(−(Im s)²/2)`. -/
theorem FL_bound (α β : ℂ) (t : ℝ) {c : ℝ} (hc : 0 ≤ c) :
    ∃ C Y₀ : ℝ, 0 ≤ C ∧ 1 ≤ Y₀ ∧ ∀ s : ℂ, |s.re| ≤ c → Y₀ ≤ |s.im| →
      ‖FL α β t s‖ ≤ C * Real.exp (-(1 / 2) * s.im ^ 2) := by
  obtain ⟨M, hM0, hM⟩ := Lambda_bound (1 / 2 + |α.re| + |β.re| + c)
  have hQ0 : 0 ≤ (‖α + β‖ ^ 2 + 4 * c ^ 2 + 4) / ‖α + β‖ ^ 2 := by positivity
  set Q : ℝ := (‖α + β‖ ^ 2 + 4 * c ^ 2 + 4) / ‖α + β‖ ^ 2 with hQ
  have hLu0 : 0 ≤ 10 + 4 * ‖uA α t‖ + 4 * c := by positivity
  have hLv0 : 0 ≤ 10 + 4 * ‖vB β t‖ + 4 * c := by positivity
  set Lu : ℝ := 10 + 4 * ‖uA α t‖ + 4 * c with hLu
  set Lv : ℝ := 10 + 4 * ‖vB β t‖ + 4 * c with hLv
  set D : ℝ := ‖Gammaℝ (uA α t) * Gammaℝ (vB β t)‖ with hD
  have hD0 : 0 ≤ D := norm_nonneg _
  have hK0 : 0 ≤ Real.exp (c ^ 2) * Q * (M * Lu) * (M * Lv) / D := by
    have := Real.exp_pos (c ^ 2)
    have := mul_nonneg hM0 hLu0
    have := mul_nonneg hM0 hLv0
    positivity
  refine ⟨216 * (Real.exp (c ^ 2) * Q * (M * Lu) * (M * Lv) / D),
    1 + |(uA α t).im| + |(vB β t).im|, by positivity, by
      linarith [abs_nonneg (uA α t).im, abs_nonneg (vB β t).im], fun s hx hy => ?_⟩
  set y := s.im with hyd
  have hy1 : 1 ≤ |y| := by linarith [abs_nonneg (uA α t).im, abs_nonneg (vB β t).im]
  have hsn : 1 ≤ ‖s‖ := hy1.trans (Complex.abs_im_le_norm s)
  have hyy : |y| ≤ 1 + y ^ 2 := by nlinarith [sq_abs y, abs_nonneg y]
  have hy2 : 0 ≤ y ^ 2 := sq_nonneg y
  have hsn2 : ‖s‖ ≤ c + |y| := (Complex.norm_le_abs_re_add_abs_im s).trans (by linarith)
  have ha := abs_le.mp (le_refl |α.re|)
  have hxa := abs_le.mp hx
  have ha1 := le_abs_self α.re
  have ha2 := neg_abs_le α.re
  have hb1 := le_abs_self β.re
  have hb2 := neg_abs_le β.re
  -- the two `Λ` factors
  have hΛ : ∀ w : ℂ, (w + s).re = 1 / 2 + w.re - 1 / 2 + s.re → |w.re - 1 / 2| ≤ |α.re| + |β.re| →
      1 + |w.im| ≤ |y| →
      ‖completedRiemannZeta (w + s)‖ ≤ M * ((10 + 4 * ‖w‖ + 4 * c) * (1 + y ^ 2)) := by
    intro w _ hw him
    have hre : |(w + s).re| ≤ 1 / 2 + |α.re| + |β.re| + c := by
      rw [Complex.add_re]
      have := abs_le.mp hw
      rw [abs_le]
      constructor <;> linarith
    have hi : 1 ≤ |(w + s).im| := by
      rw [Complex.add_im]
      have := abs_le_add_abs w.im y
      linarith
    have h1 := hM (w + s) hre hi
    have hws : ‖w + s‖ ≤ ‖w‖ + (c + |y|) := (norm_add_le w s).trans (by linarith)
    refine h1.trans (mul_le_mul_of_nonneg_left ?_ hM0)
    nlinarith [mul_nonneg (by positivity : (0 : ℝ) ≤ 6 + 4 * ‖w‖ + 4 * c) hy2]
  have hΛu := hΛ (uA α t) (by simp) (by rw [uA_re]; ring_nf; rw [abs_le]; constructor <;> linarith)
    (by linarith [abs_nonneg (vB β t).im])
  have hΛv := hΛ (vB β t) (by simp) (by rw [vB_re]; ring_nf; rw [abs_le]; constructor <;> linarith)
    (by linarith [abs_nonneg (uA α t).im])
  have hG := GY_norm_le (α := α) (β := β) hx
  rw [← hyd, ← hQ] at hG
  have e1 : ‖GY α β s‖ / ‖s‖ ≤ Real.exp (c ^ 2 - y ^ 2) * (Q * (1 + y ^ 2)) :=
    (div_le_self (norm_nonneg _) hsn).trans hG
  have e2 : ‖completedRiemannZeta (uA α t + s)‖ * ‖completedRiemannZeta (vB β t + s)‖ ≤
      (M * (Lu * (1 + y ^ 2))) * (M * (Lv * (1 + y ^ 2))) :=
    mul_le_mul hΛu hΛv (norm_nonneg _) (by positivity)
  have e3 : ‖GY α β s‖ / ‖s‖ *
      (‖completedRiemannZeta (uA α t + s)‖ * ‖completedRiemannZeta (vB β t + s)‖) ≤
      Real.exp (c ^ 2 - y ^ 2) * (Q * (1 + y ^ 2)) *
        ((M * (Lu * (1 + y ^ 2))) * (M * (Lv * (1 + y ^ 2)))) :=
    mul_le_mul e1 e2 (by positivity) (by positivity)
  have e4 : ‖FL α β t s‖ ≤ Real.exp (c ^ 2 - y ^ 2) * (Q * (1 + y ^ 2)) *
        ((M * (Lu * (1 + y ^ 2))) * (M * (Lv * (1 + y ^ 2)))) / D := by
    rw [FL, norm_div, norm_mul, norm_div, norm_mul]
    exact div_le_div_of_nonneg_right e3 hD0
  have e5 : Real.exp (c ^ 2 - y ^ 2) * (Q * (1 + y ^ 2)) *
        ((M * (Lu * (1 + y ^ 2))) * (M * (Lv * (1 + y ^ 2)))) / D =
      (Real.exp (c ^ 2) * Q * (M * Lu) * (M * Lv) / D) * ((1 + y ^ 2) ^ 3 * Real.exp (-y ^ 2)) := by
    rw [Real.exp_sub, Real.exp_neg]
    ring
  rw [e5] at e4
  calc ‖FL α β t s‖ ≤ (Real.exp (c ^ 2) * Q * (M * Lu) * (M * Lv) / D) *
        ((1 + y ^ 2) ^ 3 * Real.exp (-y ^ 2)) := e4
    _ ≤ (Real.exp (c ^ 2) * Q * (M * Lu) * (M * Lv) / D) *
        (216 * Real.exp (-(1 / 2) * y ^ 2)) := mul_le_mul_of_nonneg_left (poly_gauss y) hK0
    _ = 216 * (Real.exp (c ^ 2) * Q * (M * Lu) * (M * Lv) / D) *
        Real.exp (-(1 / 2) * y ^ 2) := by ring

/-- Target 1, for `FY`: on `|Re s| ≤ c`, `|Im s| ≥ Y₀`, `‖FY s‖ ≤ C e^(−(Im s)²/2)`. -/
theorem FY_horiz_bound (α β : ℂ) (t : ℝ) {c : ℝ} (hc : 0 ≤ c) :
    ∃ C Y₀ : ℝ, 0 ≤ C ∧ 1 ≤ Y₀ ∧ ∀ s : ℂ, |s.re| ≤ c → Y₀ ≤ |s.im| →
      ‖FY α β t s‖ ≤ C * Real.exp (-(1 / 2) * s.im ^ 2) := by
  obtain ⟨C, Y₀, hC0, hY₀, hC⟩ := FL_bound α β t hc
  refine ⟨C, Y₀ + 1 + |(uA α t).im| + |(vB β t).im|, hC0, by
    linarith [abs_nonneg (uA α t).im, abs_nonneg (vB β t).im], fun s hx hy => ?_⟩
  have h1 : Gammaℝ (uA α t + s) ≠ 0 := by
    apply Gammaℝ_ne_of_im
    rw [Complex.add_im]
    intro h0
    have := abs_le_add_abs (uA α t).im s.im
    rw [h0, abs_zero] at this
    linarith [abs_nonneg (vB β t).im]
  have h2 : Gammaℝ (vB β t + s) ≠ 0 := by
    apply Gammaℝ_ne_of_im
    rw [Complex.add_im]
    intro h0
    have := abs_le_add_abs (vB β t).im s.im
    rw [h0, abs_zero] at this
    linarith [abs_nonneg (uA α t).im]
  rw [FY_eq_FL h1 h2]
  exact hC s hx (by linarith [abs_nonneg (uA α t).im, abs_nonneg (vB β t).im])

/-- `e^(−y²/2) → 0` as `y → +∞`. -/
theorem gauss_atTop : Tendsto (fun y : ℝ => Real.exp (-(1 / 2) * y ^ 2)) atTop (𝓝 0) :=
  Real.tendsto_exp_atBot.comp
    ((tendsto_pow_atTop two_ne_zero).const_mul_atTop_of_neg (by norm_num))

/-- `e^(−y²/2) → 0` as `y → −∞`. -/
theorem gauss_atBot : Tendsto (fun y : ℝ => Real.exp (-(1 / 2) * y ^ 2)) atBot (𝓝 0) :=
  (gauss_atTop.comp tendsto_neg_atBot_atTop).congr fun y => by simp

/-- The horizontal edges: `∫_{−c}^{c} FL(x + iy) dx → 0` as `y → ±∞`. -/
theorem FL_horiz_tendsto (α β : ℂ) (t : ℝ) {c : ℝ} (hc : 0 ≤ c) :
    Tendsto (fun y : ℝ => ∫ x : ℝ in (-c)..c, FL α β t (x + y * I)) atTop (𝓝 0) ∧
      Tendsto (fun y : ℝ => ∫ x : ℝ in (-c)..c, FL α β t (x + y * I)) atBot (𝓝 0) := by
  obtain ⟨C, Y₀, hC0, hY₀, hC⟩ := FL_bound α β t hc
  have hbd : ∀ y : ℝ, Y₀ ≤ |y| →
      ‖∫ x : ℝ in (-c)..c, FL α β t (x + y * I)‖ ≤
        C * Real.exp (-(1 / 2) * y ^ 2) * |c - -c| := by
    intro y hy
    apply intervalIntegral.norm_integral_le_of_norm_le_const
    intro x hx
    rw [Set.uIoc_of_le (by linarith)] at hx
    have h := hC (x + y * I) (by simp; rw [abs_le]; constructor <;> linarith [hx.1, hx.2])
      (by simpa using hy)
    simpa using h
  have hlim : ∀ l : Filter ℝ, Tendsto (fun y : ℝ => Real.exp (-(1 / 2) * y ^ 2)) l (𝓝 0) →
      Tendsto (fun y : ℝ => C * Real.exp (-(1 / 2) * y ^ 2) * |c - -c|) l (𝓝 0) := by
    intro l hl
    simpa using (hl.const_mul C).mul_const |c - -c|
  constructor
  · refine squeeze_zero_norm' ?_ (hlim _ gauss_atTop)
    filter_upwards [eventually_ge_atTop Y₀] with y hy
    exact hbd y (by rw [abs_of_nonneg (by linarith)]; exact hy)
  · refine squeeze_zero_norm' ?_ (hlim _ gauss_atBot)
    filter_upwards [eventually_le_atBot (-Y₀)] with y hy
    exact hbd y (by rw [abs_of_neg (by linarith)]; linarith)

/-- On a vertical line where `FL` is differentiable, `FL` is integrable: continuous, and
`≤ C e^(−y²/2)` past `Y₀`. -/
theorem FL_line_integrable (α β : ℂ) (t : ℝ) {c σ : ℝ} (hc : 0 ≤ c) (hσ : |σ| ≤ c)
    (hd : ∀ y : ℝ, DifferentiableAt ℂ (FL α β t) (σ + y * I)) :
    Integrable fun y : ℝ => FL α β t (σ + y * I) := by
  have hcont : Continuous fun y : ℝ => FL α β t (σ + y * I) :=
    continuous_iff_continuousAt.mpr fun y => ContinuousAt.comp (g := FL α β t)
      (f := fun y : ℝ => (σ : ℂ) + y * I) (hd y).continuousAt (by fun_prop)
  obtain ⟨C, Y₀, hC0, hY₀, hC⟩ := FL_bound α β t hc
  obtain ⟨B, hB⟩ := (isCompact_Icc (a := -Y₀) (b := Y₀)).exists_bound_of_continuousOn
    hcont.continuousOn
  have hbd : ∀ y : ℝ, ‖FL α β t (σ + y * I)‖ ≤
      max C (max B 0 * Real.exp (1 / 2 * Y₀ ^ 2)) * Real.exp (-(1 / 2) * y ^ 2) := by
    intro y
    rcases le_or_gt Y₀ |y| with h | h
    · have h1 := hC (σ + y * I) (by simpa using hσ) (by simpa using h)
      simp only [Complex.add_im, Complex.ofReal_im, Complex.mul_im, Complex.ofReal_re,
        Complex.I_im, Complex.I_re, mul_one, mul_zero, zero_add, add_zero] at h1
      exact h1.trans (mul_le_mul_of_nonneg_right (le_max_left _ _) (Real.exp_pos _).le)
    · have hy : y ∈ Set.Icc (-Y₀) Y₀ :=
        ⟨by linarith [neg_abs_le y], by linarith [le_abs_self y]⟩
      have h1 := hB y hy
      have h2 : 1 ≤ Real.exp (1 / 2 * Y₀ ^ 2) * Real.exp (-(1 / 2) * y ^ 2) := by
        rw [← Real.exp_add]
        apply Real.one_le_exp
        nlinarith [sq_abs y, abs_nonneg y]
      calc ‖FL α β t (σ + y * I)‖ ≤ max B 0 := h1.trans (le_max_left _ _)
        _ ≤ max B 0 * (Real.exp (1 / 2 * Y₀ ^ 2) * Real.exp (-(1 / 2) * y ^ 2)) :=
          le_mul_of_one_le_right (le_max_right _ _) h2
        _ = (max B 0 * Real.exp (1 / 2 * Y₀ ^ 2)) * Real.exp (-(1 / 2) * y ^ 2) := by ring
        _ ≤ max C (max B 0 * Real.exp (1 / 2 * Y₀ ^ 2)) * Real.exp (-(1 / 2) * y ^ 2) :=
          mul_le_mul_of_nonneg_right (le_max_right _ _) (Real.exp_pos _).le
  exact Integrable.mono' ((integrable_exp_neg_mul_sq (by norm_num : (0 : ℝ) < 1 / 2)).const_mul _)
    hcont.aestronglyMeasurable (ae_of_all _ hbd)

/-- `FY = FL` almost everywhere on every vertical line, so their vertical integrals agree. -/
theorem vertInt_FY_eq_FL (α β : ℂ) (t σ : ℝ) :
    VerticalIntegral' (FY α β t) σ = VerticalIntegral' (FL α β t) σ := by
  simp only [VerticalIntegral', VerticalIntegral]
  have hae : (fun y : ℝ => FY α β t (σ + y * I)) =ᵐ[volume]
      fun y : ℝ => FL α β t (σ + y * I) := by
    have e1 : ∀ᵐ y : ℝ ∂volume, y ∉ ({-(uA α t).im} : Set ℝ) :=
      measure_eq_zero_iff_ae_notMem.mp (measure_singleton _)
    have e2 : ∀ᵐ y : ℝ ∂volume, y ∉ ({-(vB β t).im} : Set ℝ) :=
      measure_eq_zero_iff_ae_notMem.mp (measure_singleton _)
    filter_upwards [e1, e2] with y hy1 hy2
    apply FY_eq_FL
    · apply Gammaℝ_ne_of_im
      simp only [Set.mem_singleton_iff] at hy1
      simp
      intro h
      exact hy1 (by linarith)
    · apply Gammaℝ_ne_of_im
      simp only [Set.mem_singleton_iff] at hy2
      simp
      intro h
      exact hy2 (by linarith)
  rw [integral_congr_ae hae]

/-! ## The poles -/

theorem Lam_differentiableAt {w s : ℂ} (h0 : w + s ≠ 0) (h1 : w + s ≠ 1) :
    DifferentiableAt ℂ (fun s => completedRiemannZeta (w + s)) s :=
  (differentiableAt_completedZeta h0 h1).comp s (by fun_prop)

theorem Lam_analyticAt {w p : ℂ} (h0 : w + p ≠ 0) (h1 : w + p ≠ 1) :
    AnalyticAt ℂ (fun s => completedRiemannZeta (w + s)) p := by
  rw [Complex.analyticAt_iff_eventually_differentiableAt]
  have hc : Continuous fun s : ℂ => w + s := by fun_prop
  filter_upwards [hc.continuousAt.eventually_ne h0, hc.continuousAt.eventually_ne h1]
    with s hs0 hs1
  exact Lam_differentiableAt hs0 hs1

theorem Lam0_analyticAt (w p : ℂ) :
    AnalyticAt ℂ (fun s => completedRiemannZeta₀ (w + s)) p := by
  have h : Differentiable ℂ fun s => completedRiemannZeta₀ (w + s) := fun s =>
    (differentiable_completedZeta₀ _).comp s (by fun_prop)
  exact h.analyticAt p

theorem GY_analyticAt (α β p : ℂ) : AnalyticAt ℂ (GY α β) p := by
  have h : Differentiable ℂ (GY α β) := by
    unfold GY
    fun_prop
  exact h.analyticAt p

theorem FL_differentiableAt {α β : ℂ} {t : ℝ} {s : ℂ} (h0 : s ≠ 0)
    (hu0 : uA α t + s ≠ 0) (hu1 : uA α t + s ≠ 1) (hv0 : vB β t + s ≠ 0)
    (hv1 : vB β t + s ≠ 1) : DifferentiableAt ℂ (FL α β t) s := by
  have hG : DifferentiableAt ℂ (GY α β) s := (GY_analyticAt α β s).differentiableAt
  unfold FL
  exact ((hG.div differentiableAt_id h0).mul
    ((Lam_differentiableAt hu0 hu1).mul (Lam_differentiableAt hv0 hv1))).div_const _

/-- A simple pole from local data: `K (φ + a/(s − p)) = h + (a K p)/(s − p)` near `p`. -/
theorem local_simple {K φ f : ℂ → ℂ} {p a A : ℂ} (hK : AnalyticAt ℂ K p)
    (hφ : AnalyticAt ℂ φ p) (hA : a * K p = A) (hf : ∀ s, f s = K s * (φ s + a / (s - p))) :
    ∃ h : ℂ → ℂ, AnalyticAt ℂ h p ∧ ∀ᶠ s in 𝓝[≠] p, f s = h s + A / (s - p) := by
  have h3 := ContourShift.analyticAt_dslope hK
  refine ⟨fun s => K s * φ s + a * dslope K p s, by fun_prop, ?_⟩
  filter_upwards [self_mem_nhdsWithin] with s hs
  have hs' : s ≠ p := hs
  rw [hf, ← hA, mul_add, show K s * (a / (s - p)) = a * (K s / (s - p)) by ring,
    ContourShift.div_sub_eq_dslope hs']
  ring

/-- The pole at `s = 0`: residue `ζ(u) ζ(v)`. -/
theorem local_zero {α β : ℂ} {t : ℝ} (hαβ : α + β ≠ 0) (hu0 : uA α t ≠ 0) (hu1 : uA α t ≠ 1)
    (hv0 : vB β t ≠ 0) (hv1 : vB β t ≠ 1) (hGu : Gammaℝ (uA α t) ≠ 0)
    (hGv : Gammaℝ (vB β t) ≠ 0) :
    ∃ h : ℂ → ℂ, AnalyticAt ℂ h 0 ∧ ∀ᶠ s in 𝓝[≠] 0, FL α β t s =
      h s + riemannZeta (uA α t) * riemannZeta (vB β t) / (s - 0) := by
  refine local_simple (K := fun s => GY α β s * (completedRiemannZeta (uA α t + s) *
      completedRiemannZeta (vB β t + s)) / (Gammaℝ (uA α t) * Gammaℝ (vB β t)))
    (φ := fun _ => 0) (a := 1) ?_ analyticAt_const ?_ ?_
  · exact ((GY_analyticAt α β 0).mul ((Lam_analyticAt (by simpa using hu0) (by simpa using hu1)).mul
      (Lam_analyticAt (by simpa using hv0) (by simpa using hv1)))).div_const
  · simp only [add_zero, GY_zero hαβ, ← gamma_mul_zeta hGu, ← gamma_mul_zeta hGv]
    field_simp
    try ring
  · intro s
    simp only [FL, sub_zero]
    ring

/-- The pole at `s = 1 − w₁` of `g(s)/s · Λ(w₁+s) Λ(w₂+s) / D`: residue
`g(1−w₁)/(1−w₁) · Λ(w₂+1−w₁) / D`. -/
theorem local_pole_one {g F : ℂ → ℂ} {w₁ w₂ D : ℂ} (hg : ∀ p, AnalyticAt ℂ g p)
    (hF : ∀ s, F s = g s / s * (completedRiemannZeta (w₁ + s) * completedRiemannZeta (w₂ + s)) / D)
    (hp0 : 1 - w₁ ≠ 0) (h0 : w₂ + (1 - w₁) ≠ 0) (h1 : w₂ + (1 - w₁) ≠ 1) :
    ∃ h : ℂ → ℂ, AnalyticAt ℂ h (1 - w₁) ∧ ∀ᶠ s in 𝓝[≠] (1 - w₁), F s =
      h s + g (1 - w₁) / (1 - w₁) * completedRiemannZeta (w₂ + 1 - w₁) / D / (s - (1 - w₁)) := by
  refine local_simple (K := fun s => g s / s * completedRiemannZeta (w₂ + s) / D)
    (φ := fun s => completedRiemannZeta₀ (w₁ + s) - 1 / (w₁ + s)) (a := 1) ?_ ?_ ?_ ?_
  · exact (((hg _).div analyticAt_id hp0).mul (Lam_analyticAt h0 h1)).div_const
  · have hw : w₁ + (1 - w₁) ≠ 0 := by simp
    exact (Lam0_analyticAt w₁ _).sub (analyticAt_const.div (by fun_prop) hw)
  · rw [show w₂ + (1 - w₁) = w₂ + 1 - w₁ by ring]
    ring
  · intro s
    rw [hF, completedRiemannZeta_eq (w₁ + s),
      show s - (1 - w₁) = -(1 - (w₁ + s)) by ring, div_neg]
    ring

/-- The pole at `s = −w₁` of `g(s)/s · Λ(w₁+s) Λ(w₂+s) / D`: residue
`g(−w₁)/w₁ · Λ(w₂−w₁) / D`. -/
theorem local_pole_neg {g F : ℂ → ℂ} {w₁ w₂ D : ℂ} (hg : ∀ p, AnalyticAt ℂ g p)
    (hF : ∀ s, F s = g s / s * (completedRiemannZeta (w₁ + s) * completedRiemannZeta (w₂ + s)) / D)
    (hp0 : -w₁ ≠ 0) (h0 : w₂ + -w₁ ≠ 0) (h1 : w₂ + -w₁ ≠ 1) :
    ∃ h : ℂ → ℂ, AnalyticAt ℂ h (-w₁) ∧ ∀ᶠ s in 𝓝[≠] (-w₁), F s =
      h s + g (-w₁) / w₁ * completedRiemannZeta (w₂ - w₁) / D / (s - -w₁) := by
  refine local_simple (K := fun s => g s / s * completedRiemannZeta (w₂ + s) / D)
    (φ := fun s => completedRiemannZeta₀ (w₁ + s) - 1 / (1 - (w₁ + s))) (a := -1) ?_ ?_ ?_ ?_
  · exact (((hg _).div analyticAt_id hp0).mul (Lam_analyticAt h0 h1)).div_const
  · have hw : 1 - (w₁ + -w₁) ≠ 0 := by simp
    exact (Lam0_analyticAt w₁ _).sub (analyticAt_const.div (by fun_prop) hw)
  · rw [← sub_eq_add_neg, div_neg]
    ring
  · intro s
    rw [hF, completedRiemannZeta_eq (w₁ + s), show s - -w₁ = w₁ + s by ring]
    ring

/-! ## The rectangle and the limit -/

/-- `z ≠ w` from their real parts. -/
theorem ne_of_re_ne {z w : ℂ} (h : z.re < w.re ∨ w.re < z.re) : z ≠ w := by
  rintro rfl
  rcases h with h | h <;> exact lt_irrefl _ h

/-- The rectangle `[−c, c] × [−T, T]` is a neighbourhood of every interior point. -/
theorem rect_mem_nhds {c T : ℝ} {p : ℂ} (h1 : |p.re| < c) (h2 : |p.im| < T) :
    Rectangle (↑(-c) - I * ↑T) (↑c + I * ↑T) ∈ 𝓝 p := by
  have a1 := abs_lt.mp h1
  have a2 := abs_lt.mp h2
  rw [rectangle_mem_nhds_iff, Complex.mem_reProdIm]
  simp only [Complex.sub_re, Complex.add_re, Complex.ofReal_re, Complex.mul_re, Complex.I_re,
    Complex.I_im, Complex.ofReal_im, Complex.sub_im, Complex.add_im, Complex.mul_im,
    zero_mul, one_mul, mul_zero, sub_zero, add_zero, zero_add, zero_sub]
  rw [Set.uIoo_of_le (by linarith), Set.uIoo_of_le (by linarith)]
  exact ⟨⟨a1.1, a1.2⟩, ⟨a2.1, a2.2⟩⟩

/-- PNT+'s `RectangleIntegral_tendsTo_VerticalIntegral` (in `PerronFormula`, not built at the
pin), re-proved here for `[−c, c]`. -/
theorem rect_tendsto {f : ℂ → ℂ} {c : ℝ}
    (hbot : Tendsto (fun y : ℝ => ∫ x : ℝ in (-c)..c, f (x + y * I)) atBot (𝓝 0))
    (htop : Tendsto (fun y : ℝ => ∫ x : ℝ in (-c)..c, f (x + y * I)) atTop (𝓝 0))
    (hleft : Integrable (fun y : ℝ => f (↑(-c) + y * I)))
    (hright : Integrable (fun y : ℝ => f (↑c + y * I))) :
    Tendsto (fun T : ℝ => RectangleIntegral f (↑(-c) - I * T) (↑c + I * T)) atTop
      (𝓝 (VerticalIntegral f c - VerticalIntegral f (-c))) := by
  simp only [RectangleIntegral, sub_re, ofReal_re, mul_re, I_re, zero_mul, I_im, ofReal_im,
    mul_zero, sub_self, sub_zero, add_re, add_zero, sub_im, mul_im, one_mul, zero_add, zero_sub,
    add_im]
  apply Tendsto.sub
  · rewrite [← zero_add (VerticalIntegral _ _), ← zero_sub_zero]
    apply Tendsto.add <| Tendsto.sub (hbot.comp tendsto_neg_atTop_atBot) htop
    exact (intervalIntegral_tendsto_integral hright tendsto_neg_atTop_atBot tendsto_id).const_smul I
  · exact (intervalIntegral_tendsto_integral hleft tendsto_neg_atTop_atBot tendsto_id).const_smul I

/-! ## The shift -/

/-- The five poles. -/
noncomputable
def poles (α β : ℂ) (t : ℝ) : Finset ℂ := by
  classical
  exact {0, 1 - uA α t, -uA α t, 1 - vB β t, -vB β t}

/-- The residues at the five poles: `ζ(u)ζ(v)` at `0`, and the four terms of `resY`. -/
noncomputable
def resA (α β : ℂ) (t : ℝ) (p : ℂ) : ℂ := by
  classical
  exact if p = 0 then riemannZeta (uA α t) * riemannZeta (vB β t)
    else if p = 1 - uA α t then GY α β (1 - uA α t) / (1 - uA α t) *
      completedRiemannZeta (vB β t + 1 - uA α t) / (Gammaℝ (uA α t) * Gammaℝ (vB β t))
    else if p = -uA α t then GY α β (-uA α t) / uA α t *
      completedRiemannZeta (vB β t - uA α t) / (Gammaℝ (uA α t) * Gammaℝ (vB β t))
    else if p = 1 - vB β t then GY α β (1 - vB β t) / (1 - vB β t) *
      completedRiemannZeta (uA α t + 1 - vB β t) / (Gammaℝ (uA α t) * Gammaℝ (vB β t))
    else GY α β (-vB β t) / vB β t *
      completedRiemannZeta (uA α t - vB β t) / (Gammaℝ (uA α t) * Gammaℝ (vB β t))

/-- `z ≠ w` by real parts, the bounds on `Re α`, `Re β` in context. -/
macro "re_ne" : tactic =>
  `(tactic| (apply ne_of_re_ne; simp only [Complex.sub_re, Complex.add_re, Complex.neg_re,
    Complex.one_re, Complex.zero_re, uA_re, vB_re]; first | (left; linarith) | (right; linarith)))

/-- Target 2, the contour shift. For `−1/2 < Re α, Re β < 1/2`, `c > 1/2 + |Re α|, 1/2 + |Re β|`,
`α + β ≠ 0` and `u ≠ v` (the five poles distinct):
`(1/2πi)∫_(c) FY − (1/2πi)∫_(−c) FY = ζ(u)ζ(v) + resY`. -/
theorem stmtShift_holds {α β : ℂ} {t c : ℝ} (hα : α.re < 1 / 2) (hβ : β.re < 1 / 2)
    (hα' : -(1 / 2) < α.re) (hβ' : -(1 / 2) < β.re)
    (hcα : 1 / 2 + |α.re| < c) (hcβ : 1 / 2 + |β.re| < c)
    (hαβ : α + β ≠ 0) (huv : uA α t ≠ vB β t) : StmtShift α β t c := by
  classical
  have ha1 := le_abs_self α.re
  have ha2 := neg_abs_le α.re
  have hb1 := le_abs_self β.re
  have hb2 := neg_abs_le β.re
  have hc0 : 0 ≤ c := by linarith [abs_nonneg α.re]
  have hGu := Gammaℝ_uA_ne t hα'
  have hGv := Gammaℝ_vB_ne t hβ'
  -- the five poles are distinct, and each sits off the other factor's poles
  have hu0 : uA α t ≠ 0 := by re_ne
  have hu1 : uA α t ≠ 1 := by re_ne
  have hv0 : vB β t ≠ 0 := by re_ne
  have hv1 : vB β t ≠ 1 := by re_ne
  have d1 : 1 - uA α t ≠ 0 := by re_ne
  have d2 : -uA α t ≠ 0 := by re_ne
  have d3 : -uA α t ≠ 1 - uA α t := by re_ne
  have d4 : 1 - vB β t ≠ 0 := by re_ne
  have d5 : 1 - vB β t ≠ 1 - uA α t := fun h => huv (by linear_combination h)
  have d6 : 1 - vB β t ≠ -uA α t := by re_ne
  have d7 : -vB β t ≠ 0 := by re_ne
  have d8 : -vB β t ≠ 1 - uA α t := by re_ne
  have d9 : -vB β t ≠ -uA α t := fun h => huv (by linear_combination h)
  have d10 : -vB β t ≠ 1 - vB β t := by re_ne
  have l1 : vB β t + (1 - uA α t) ≠ 0 := by re_ne
  have l2 : vB β t + (1 - uA α t) ≠ 1 := fun h => huv (by linear_combination -h)
  have l3 : vB β t + -uA α t ≠ 0 := fun h => huv (by linear_combination -h)
  have l4 : vB β t + -uA α t ≠ 1 := by re_ne
  have l5 : uA α t + (1 - vB β t) ≠ 0 := by re_ne
  have l6 : uA α t + (1 - vB β t) ≠ 1 := fun h => huv (by linear_combination h)
  have l7 : uA α t + -vB β t ≠ 0 := fun h => huv (by linear_combination h)
  have l8 : uA α t + -vB β t ≠ 1 := by re_ne
  -- the residues
  have r0 : resA α β t 0 = riemannZeta (uA α t) * riemannZeta (vB β t) := by
    unfold resA
    rw [if_pos rfl]
  have r1 : resA α β t (1 - uA α t) = GY α β (1 - uA α t) / (1 - uA α t) *
      completedRiemannZeta (vB β t + 1 - uA α t) / (Gammaℝ (uA α t) * Gammaℝ (vB β t)) := by
    unfold resA
    rw [if_neg d1, if_pos rfl]
  have r2 : resA α β t (-uA α t) = GY α β (-uA α t) / uA α t *
      completedRiemannZeta (vB β t - uA α t) / (Gammaℝ (uA α t) * Gammaℝ (vB β t)) := by
    unfold resA
    rw [if_neg d2, if_neg d3, if_pos rfl]
  have r3 : resA α β t (1 - vB β t) = GY α β (1 - vB β t) / (1 - vB β t) *
      completedRiemannZeta (uA α t + 1 - vB β t) / (Gammaℝ (uA α t) * Gammaℝ (vB β t)) := by
    unfold resA
    rw [if_neg d4, if_neg d5, if_neg d6, if_pos rfl]
  have r4 : resA α β t (-vB β t) = GY α β (-vB β t) / vB β t *
      completedRiemannZeta (uA α t - vB β t) / (Gammaℝ (uA α t) * Gammaℝ (vB β t)) := by
    unfold resA
    rw [if_neg d7, if_neg d8, if_neg d9, if_neg d10]
  have hsum : ∑ p ∈ poles α β t, resA α β t p =
      riemannZeta (uA α t) * riemannZeta (vB β t) + resY α β t := by
    have m1 : (0 : ℂ) ∉ ({1 - uA α t, -uA α t, 1 - vB β t, -vB β t} : Finset ℂ) := by
      simp only [Finset.mem_insert, Finset.mem_singleton, not_or]
      exact ⟨d1.symm, d2.symm, d4.symm, d7.symm⟩
    have m2 : (1 - uA α t) ∉ ({-uA α t, 1 - vB β t, -vB β t} : Finset ℂ) := by
      simp only [Finset.mem_insert, Finset.mem_singleton, not_or]
      exact ⟨d3.symm, d5.symm, d8.symm⟩
    have m3 : (-uA α t) ∉ ({1 - vB β t, -vB β t} : Finset ℂ) := by
      simp only [Finset.mem_insert, Finset.mem_singleton, not_or]
      exact ⟨d6.symm, d9.symm⟩
    have m4 : (1 - vB β t) ∉ ({-vB β t} : Finset ℂ) := by
      simp only [Finset.mem_singleton]
      exact d10.symm
    rw [poles, Finset.sum_insert m1, Finset.sum_insert m2, Finset.sum_insert m3,
      Finset.sum_insert m4, Finset.sum_singleton, r0, r1, r2, r3, r4]
    unfold resY
    ring
  -- the residue theorem on `[−c, c] × [−T, T]`
  have hrect : ∀ T : ℝ, 1 + |(uA α t).im| + |(vB β t).im| ≤ T →
      RectangleIntegral' (FL α β t) (↑(-c) - I * ↑T) (↑c + I * ↑T) =
        ∑ p ∈ poles α β t, resA α β t p := by
    intro T hT
    have hui := abs_nonneg (uA α t).im
    have hvi := abs_nonneg (vB β t).im
    have hcpos : 0 < c := by linarith [abs_nonneg α.re]
    apply ContourShift.residue_rectangle_of_local
    · simp
      linarith
    · simp
      linarith
    · intro p hp
      simp only [poles, Finset.mem_insert, Finset.mem_singleton] at hp
      rcases hp with rfl | rfl | rfl | rfl | rfl
      · apply rect_mem_nhds <;> simp <;> linarith
      · apply rect_mem_nhds
        · rw [Complex.sub_re, Complex.one_re, uA_re, abs_lt]
          constructor <;> linarith
        · rw [Complex.sub_im, Complex.one_im, zero_sub, abs_neg]
          linarith
      · apply rect_mem_nhds
        · rw [Complex.neg_re, uA_re, abs_lt]
          constructor <;> linarith
        · rw [Complex.neg_im, abs_neg]
          linarith
      · apply rect_mem_nhds
        · rw [Complex.sub_re, Complex.one_re, vB_re, abs_lt]
          constructor <;> linarith
        · rw [Complex.sub_im, Complex.one_im, zero_sub, abs_neg]
          linarith
      · apply rect_mem_nhds
        · rw [Complex.neg_re, vB_re, abs_lt]
          constructor <;> linarith
        · rw [Complex.neg_im, abs_neg]
          linarith
    · intro s hs
      have hs2 := hs.2
      simp only [poles, Finset.coe_insert, Finset.coe_singleton, Set.mem_insert_iff,
        Set.mem_singleton_iff, not_or] at hs2
      obtain ⟨n0, n1, n2, n3, n4⟩ := hs2
      exact (FL_differentiableAt n0 (fun h => n2 (by linear_combination h))
        (fun h => n1 (by linear_combination h)) (fun h => n4 (by linear_combination h))
        (fun h => n3 (by linear_combination h))).differentiableWithinAt
    · intro p hp
      simp only [poles, Finset.mem_insert, Finset.mem_singleton] at hp
      rcases hp with rfl | rfl | rfl | rfl | rfl
      · obtain ⟨h, hh, hev⟩ := local_zero hαβ hu0 hu1 hv0 hv1 hGu hGv
        refine ⟨h, hh, ?_⟩
        rw [r0]
        exact hev
      · obtain ⟨h, hh, hev⟩ := local_pole_one (g := GY α β) (w₁ := uA α t) (w₂ := vB β t)
          (D := Gammaℝ (uA α t) * Gammaℝ (vB β t)) (F := FL α β t) (GY_analyticAt α β)
          (fun s => rfl) d1 l1 l2
        refine ⟨h, hh, ?_⟩
        rw [r1]
        exact hev
      · obtain ⟨h, hh, hev⟩ := local_pole_neg (g := GY α β) (w₁ := uA α t) (w₂ := vB β t)
          (D := Gammaℝ (uA α t) * Gammaℝ (vB β t)) (F := FL α β t) (GY_analyticAt α β)
          (fun s => rfl) d2 l3 l4
        refine ⟨h, hh, ?_⟩
        rw [r2]
        exact hev
      · obtain ⟨h, hh, hev⟩ := local_pole_one (g := GY α β) (w₁ := vB β t) (w₂ := uA α t)
          (D := Gammaℝ (uA α t) * Gammaℝ (vB β t)) (F := FL α β t) (GY_analyticAt α β)
          (fun s => by simp only [FL]; ring) d4 l5 l6
        refine ⟨h, hh, ?_⟩
        rw [r3]
        exact hev
      · obtain ⟨h, hh, hev⟩ := local_pole_neg (g := GY α β) (w₁ := vB β t) (w₂ := uA α t)
          (D := Gammaℝ (uA α t) * Gammaℝ (vB β t)) (F := FL α β t) (GY_analyticAt α β)
          (fun s => by simp only [FL]; ring) d7 l7 l8
        refine ⟨h, hh, ?_⟩
        rw [r4]
        exact hev
  -- the vertical lines
  have hd : ∀ σ : ℝ, (σ = c ∨ σ = -c) → ∀ y : ℝ,
      DifferentiableAt ℂ (FL α β t) (σ + y * I) := by
    intro σ hσ y
    have hre : ((σ : ℂ) + y * I).re = σ := by simp
    have hσc : c ≤ |σ| := by
      rcases hσ with h | h <;> rw [h] <;> simp [abs_of_nonneg hc0]
    have key : ∀ w : ℂ, |w.re - 1 / 2| ≤ |α.re| + |β.re| → |w.re - 1 / 2| < |σ| - 1 / 2 →
        w + (σ + y * I) ≠ 0 ∧ w + (σ + y * I) ≠ 1 := by
      intro w _ hw2
      constructor
      · intro h
        have := congrArg Complex.re h
        rw [Complex.add_re, hre, Complex.zero_re] at this
        rcases le_or_gt 0 σ with h' | h'
        · rw [abs_of_nonneg h'] at hw2
          have := (abs_lt.mp hw2).1
          linarith
        · rw [abs_of_neg h'] at hw2
          have := (abs_lt.mp hw2).2
          linarith
      · intro h
        have := congrArg Complex.re h
        rw [Complex.add_re, hre, Complex.one_re] at this
        rcases le_or_gt 0 σ with h' | h'
        · rw [abs_of_nonneg h'] at hw2
          have := (abs_lt.mp hw2).1
          linarith
        · rw [abs_of_neg h'] at hw2
          have := (abs_lt.mp hw2).2
          linarith
    have ku := key (uA α t) (by rw [uA_re]; ring_nf; rw [abs_le]; constructor <;> linarith)
      (by rw [uA_re]; ring_nf; rw [abs_lt]; constructor <;> linarith)
    have kv := key (vB β t) (by rw [vB_re]; ring_nf; rw [abs_le]; constructor <;> linarith)
      (by rw [vB_re]; ring_nf; rw [abs_lt]; constructor <;> linarith)
    apply FL_differentiableAt _ ku.1 ku.2 kv.1 kv.2
    intro h
    have := congrArg Complex.re h
    rw [hre, Complex.zero_re] at this
    rw [this, abs_zero] at hσc
    linarith
  have hright := FL_line_integrable α β t hc0 (by rw [abs_of_nonneg hc0]) (hd c (Or.inl rfl))
  have hleft := FL_line_integrable α β t hc0 (σ := -c) (by rw [abs_neg, abs_of_nonneg hc0])
    (hd (-c) (Or.inr rfl))
  obtain ⟨htop, hbot⟩ := FL_horiz_tendsto α β t hc0
  have hlim := (rect_tendsto hbot htop hleft hright).const_smul (1 / (2 * (Real.pi : ℂ) * I))
  have hconst : Tendsto (fun T : ℝ => RectangleIntegral' (FL α β t) (↑(-c) - I * ↑T)
      (↑c + I * ↑T)) atTop (𝓝 (∑ p ∈ poles α β t, resA α β t p)) := by
    refine tendsto_const_nhds.congr' ?_
    filter_upwards [eventually_ge_atTop (1 + |(uA α t).im| + |(vB β t).im|)] with T hT
    exact (hrect T hT).symm
  have heq := tendsto_nhds_unique hlim hconst
  unfold StmtShift
  rw [vertInt_FY_eq_FL, vertInt_FY_eq_FL, ← hsum, ← heq]
  simp only [VerticalIntegral', smul_sub]

/-- Target 3. Young's Lemma 4, exact, with the shift discharged: for `−1/2 < Re α, Re β < 1/2`,
`c > 1/2 + |Re α|, 1/2 + |Re β|`, `α + β ≠ 0` and `u ≠ v`,
`ζ(u) ζ(v) = Σ_{m,n} m^(−u) n^(−v) V_{α,β}(mn,t)
  + X_{α,β,t} Σ_{m,n} m^(−1/2+β−it) n^(−1/2+α+it) V_{−β,−α}(mn,t) − resY`. -/
theorem approxFE {α β : ℂ} {t c : ℝ} (hα : α.re < 1 / 2) (hβ : β.re < 1 / 2)
    (hα' : -(1 / 2) < α.re) (hβ' : -(1 / 2) < β.re)
    (hcα : 1 / 2 + |α.re| < c) (hcβ : 1 / 2 + |β.re| < c)
    (hαβ : α + β ≠ 0) (huv : uA α t ≠ vB β t) :
    riemannZeta (uA α t) * riemannZeta (vB β t) =
      (∑' p : ℕ × ℕ, ((p.1 : ℂ) + 1) ^ (-uA α t) * ((p.2 : ℂ) + 1) ^ (-vB β t) *
        VY α β c (((p.1 : ℝ) + 1) * ((p.2 : ℝ) + 1)) t) +
      XY α β t * (∑' p : ℕ × ℕ, ((p.1 : ℂ) + 1) ^ (-uA (-β) t) *
        ((p.2 : ℂ) + 1) ^ (-vB (-α) t) *
        VY (-β) (-α) c (((p.1 : ℝ) + 1) * ((p.2 : ℝ) + 1)) t) - resY α β t :=
  approxFE_of_shift hα hβ hα' hβ' hcα hcβ (stmtShift_holds hα hβ hα' hβ' hcα hcβ hαβ huv)

/-! ## Axiom pins -/

/-- info: 'ApproxShift.FL_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms FL_bound

/-- info: 'ApproxShift.FY_horiz_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms FY_horiz_bound

/-- info: 'ApproxShift.Lambda_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Lambda_bound

/-- info: 'ApproxShift.FL_horiz_tendsto' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms FL_horiz_tendsto

/-- info: 'ApproxShift.stmtShift_holds' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms stmtShift_holds

/-- info: 'ApproxShift.approxFE' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms approxFE

end ApproxShift
