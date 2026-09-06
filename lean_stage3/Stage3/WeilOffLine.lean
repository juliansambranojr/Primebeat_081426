/-
WeilOffLine — every term of the zero form is minus a square, and the sign
of an off-line zero's own term. Rung 5, first slice of the detection
ladder (units 0316–0325). 2026-09-06.

WeilDetect's zero form sums `laplace φ(−ρ)·laplace φ(−(1−ρ))·ord ρ`. For the
window `φ` of WeilBackground, `laplace φ z = ghat h γ (−z − 1/2)`, and
`ghat h γ` is odd (`Σc` is odd, so both halves of `ghat_eq` flip sign).
Reading the two factors at `−ρ` and at `−(1−ρ)` therefore gives `ghat` at
`ρ − 1/2` and at `−(ρ − 1/2)`:

  term_eq_neg_sq      laplace φ(−ρ)·laplace φ(−(1−ρ)) = −ghat h γ (ρ − 1/2)²
  term_re_eq          its real part is  (Im g)² − (Re g)²,  g = ghat h γ (ρ − 1/2).

This is the sign structure of the whole zero side in one line. On the line
`ρ − 1/2 = iγ_ρ` and `g` is purely imaginary (`ghat_ofReal_I`), so the term
is `(Im g)² ≥ 0`: unit 0320's `online_term_eq` again. Off the line the term
is negative exactly when `g` is more real than imaginary.

At the off-line point read by the tuned window, `ρ − 1/2 = ε + iγ` with the
window's own `γ`, `ghat_offline` gives `g = (h/2)·[Σc((ε + 2iγ)h) + Σ(εh)]`:
a real main term `Σ(εh)` and the `2γ` lobe. When the lobe is at most the
main term in norm,

  offline_term_le     term.re ≤ −(h/2)²·Σ(εh)·(Σ(εh) − 2‖lobe‖)
  offline_term_le_explicit
                      the same with the lobe replaced by unit 0319's bound
                      (2π + π²)·cosh(εh)/(2γh)².

So the off-line zero's own term is negative as soon as the main term beats
twice the lobe, and its size is the square of the main term, to first order.

Axioms: every theorem pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.WeilBackground

namespace WeilOffLine

noncomputable section

open Complex WeilWindow WeilTransform WeilLobe WeilDetect WeilBackground Real

/-- `Σc` is odd: `sinh` is odd. -/
theorem SigmaC_neg (w : ℂ) : SigmaC (-w) = -SigmaC w := by
  unfold SigmaC
  rw [← intervalIntegral.integral_neg]
  congr 1
  funext x
  rw [neg_mul, Complex.sinh_neg]
  ring

/-- The window's transform is odd. -/
theorem ghat_neg {h : ℝ} (hh : 0 < h) (γ : ℝ) (z : ℂ) : ghat h γ (-z) = -ghat h γ z := by
  rw [ghat_eq hh, ghat_eq hh]
  have e1 : (-z + Complex.I * (γ : ℂ)) * (h : ℂ) = -((z - Complex.I * (γ : ℂ)) * (h : ℂ)) := by
    ring
  have e2 : (-z - Complex.I * (γ : ℂ)) * (h : ℂ) = -((z + Complex.I * (γ : ℂ)) * (h : ℂ)) := by
    ring
  rw [e1, e2, SigmaC_neg, SigmaC_neg]
  ring

/-- **Every term is minus a square.** For any `ρ`,
`laplace φ(−ρ)·laplace φ(−(1−ρ)) = −ghat h γ (ρ − 1/2)²`. -/
theorem term_eq_neg_sq {h : ℝ} (hh : 0 < h) (γ : ℝ) (ρ : ℂ) :
    laplace (phiC h γ) (-ρ) * laplace (phiC h γ) (-(1 - ρ)) = -(ghat h γ (ρ - 1 / 2)) ^ 2 := by
  rw [laplace_phi hh, laplace_phi hh]
  have e1 : -(-ρ) - 1 / 2 = ρ - 1 / 2 := by ring
  have e2 : -(-(1 - ρ)) - 1 / 2 = -(ρ - 1 / 2) := by ring
  rw [e1, e2, ghat_neg hh]
  ring

/-- The real part of a term is `(Im g)² − (Re g)²` at `g = ghat h γ (ρ − 1/2)`. -/
theorem term_re_eq {h : ℝ} (hh : 0 < h) (γ : ℝ) (ρ : ℂ) :
    (laplace (phiC h γ) (-ρ) * laplace (phiC h γ) (-(1 - ρ))).re
      = (ghat h γ (ρ - 1 / 2)).im ^ 2 - (ghat h γ (ρ - 1 / 2)).re ^ 2 := by
  rw [term_eq_neg_sq hh, Complex.neg_re, sq, Complex.mul_re]
  ring

/-- The off-line point the tuned window reads: `ρ = 1/2 + ε + iγ`. -/
def offPt (ε γ : ℝ) : ℂ := 1 / 2 + (ε : ℂ) + Complex.I * (γ : ℂ)

theorem offPt_sub_half (ε γ : ℝ) : offPt ε γ - 1 / 2 = (ε : ℂ) + Complex.I * (γ : ℂ) := by
  unfold offPt; ring

/-- **The off-line term is negative.** With `g = (h/2)[lobe + Σ(εh)]` and the
lobe at most the main term in norm,
`term.re ≤ −(h/2)²·Σ(εh)·(Σ(εh) − 2‖lobe‖)`. -/
theorem offline_term_le {h γ ε : ℝ} (hh : 0 < h)
    (hs : ‖SigmaC (((ε : ℂ) + 2 * Complex.I * (γ : ℂ)) * (h : ℂ))‖ ≤ WeilWindow.Sigma (ε * h)) :
    (laplace (phiC h γ) (-offPt ε γ) * laplace (phiC h γ) (-(1 - offPt ε γ))).re
      ≤ -((h / 2) ^ 2 * (WeilWindow.Sigma (ε * h)
          * (WeilWindow.Sigma (ε * h)
              - 2 * ‖SigmaC (((ε : ℂ) + 2 * Complex.I * (γ : ℂ)) * (h : ℂ))‖))) := by
  rw [term_re_eq hh, offPt_sub_half, ghat_offline hh]
  set L := SigmaC (((ε : ℂ) + 2 * Complex.I * (γ : ℂ)) * (h : ℂ)) with hL
  set s := WeilWindow.Sigma (ε * h) with hsdef
  have hc : (h : ℂ) / 2 = ((h / 2 : ℝ) : ℂ) := by push_cast; ring
  rw [hc, Complex.re_ofReal_mul, Complex.im_ofReal_mul, Complex.add_re, Complex.add_im,
    Complex.ofReal_re, Complex.ofReal_im, add_zero]
  have hre : |L.re| ≤ ‖L‖ := Complex.abs_re_le_norm L
  have him : |L.im| ≤ ‖L‖ := Complex.abs_im_le_norm L
  have h1 : L.im ^ 2 ≤ ‖L‖ ^ 2 := by
    rw [← sq_abs]
    exact pow_le_pow_left₀ (abs_nonneg _) him 2
  have h2 : (s - ‖L‖) ^ 2 ≤ (L.re + s) ^ 2 := by
    apply pow_le_pow_left₀ (by linarith)
    linarith [neg_abs_le L.re]
  have e : (h / 2 * L.im) ^ 2 - (h / 2 * (L.re + s)) ^ 2
      = (h / 2) ^ 2 * (L.im ^ 2 - (L.re + s) ^ 2) := by ring
  rw [e]
  calc (h / 2) ^ 2 * (L.im ^ 2 - (L.re + s) ^ 2)
      ≤ (h / 2) ^ 2 * (‖L‖ ^ 2 - (s - ‖L‖) ^ 2) :=
        mul_le_mul_of_nonneg_left (by linarith) (sq_nonneg _)
    _ = -((h / 2) ^ 2 * (s * (s - 2 * ‖L‖))) := by ring

/-- The same with unit 0319's lobe bound in place of the lobe: for `γ > 0`,
if `(2π + π²)·cosh(εh)/(2γh)² ≤ Σ(εh)` then
`term.re ≤ −(h/2)²·Σ(εh)·(Σ(εh) − 2(2π + π²)·cosh(εh)/(2γh)²)`. -/
theorem offline_term_le_explicit {h γ ε : ℝ} (hh : 0 < h) (hγ : 0 < γ)
    (hs : (2 * Real.pi + Real.pi ^ 2) * Real.cosh (ε * h) / (2 * γ * h) ^ 2
      ≤ WeilWindow.Sigma (ε * h)) :
    (laplace (phiC h γ) (-offPt ε γ) * laplace (phiC h γ) (-(1 - offPt ε γ))).re
      ≤ -((h / 2) ^ 2 * (WeilWindow.Sigma (ε * h)
          * (WeilWindow.Sigma (ε * h)
              - 2 * ((2 * Real.pi + Real.pi ^ 2) * Real.cosh (ε * h) / (2 * γ * h) ^ 2)))) := by
  have hlobe := lobe_bound hh hγ ε
  have hs' : ‖SigmaC (((ε : ℂ) + 2 * Complex.I * (γ : ℂ)) * (h : ℂ))‖
      ≤ WeilWindow.Sigma (ε * h) := hlobe.trans hs
  refine (offline_term_le hh hs').trans ?_
  have hS : 0 ≤ WeilWindow.Sigma (ε * h) := (norm_nonneg _).trans hs'
  have hh2 : 0 ≤ (h / 2) ^ 2 := sq_nonneg _
  rw [neg_le_neg_iff]
  apply mul_le_mul_of_nonneg_left _ hh2
  apply mul_le_mul_of_nonneg_left _ hS
  linarith

end

/-- info: 'WeilOffLine.ghat_neg' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms ghat_neg

/-- info: 'WeilOffLine.term_eq_neg_sq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms term_eq_neg_sq

/-- info: 'WeilOffLine.offline_term_le_explicit' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms offline_term_le_explicit

end WeilOffLine
