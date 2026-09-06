/-
WeilTransform — the transform of the tuned window in closed form. Rung 3 of
the detection ladder (units 0316, 0317). 2026-09-06.

Entry 302 §3 reads the transform of `G(u) = N·(u/h)·P(u/h)·cos(γu)` twice:
on the real line as `(iNh/2)[Ψ(h(t−γ)) + Ψ(h(t+γ))]` with
`Ψ(s) = ∫₋₁¹ x·P(x)·sin(sx) dx`, and at the off-line point as
`(Nh/2)[±Σ(εh) + i·(the 2γ lobe)]`. Both are one identity read at one
argument. With the odd envelope extended to complex argument,

    Σc(w) = ∫₋₁¹ x·P(x)·sinh(w x) dx,

and `ghat h γ z = ∫₋ₕʰ G(u)·e^{zu} du` (no normalisation `N`; it is a
scalar and rides along), the identity is

    ghat h γ z = (h/2) · [ Σc((z + iγ)h) + Σc((z − iγ)h) ].          (★)

Three steps, each its own lemma: the change of variables `u = hx`
(`integral_comp_mul_left`); the carrier `cos(γhx)·e^{zhx}` split into two
exponentials; and the ODD-PART LEMMA, that for an odd `q` on `[−1, 1]`,
`∫ q(x)·e^{wx} dx = ∫ q(x)·sinh(wx) dx`, because `q·cosh(w·)` is odd and
integrates to zero. `x·P(x)` is odd since `P` is even.

Read at `z = it`: `Σc(i s) = i·Ψ(s)` (`sinh(iθ) = i·sin θ`), giving entry
302's real-line formula. Read at `z = ε + iγ`: `Σc(εh) + Σc((ε + 2iγ)h)`,
the main term `Σ(εh)` of unit 0317 plus the `2γ` lobe, giving entry 302's
off-line formula. Both readings are corollaries below.

  P_even, xP_odd            the envelope's parity
  SigmaC_ofReal             Σc(s) = Σ(s) for real s
  SigmaC_I_mul              Σc(i s) = i·Ψ(s)
  odd_integral_exp          the odd-part lemma
  ghat_eq                   (★)
  ghat_ofReal_I             (★) at z = it, entry 302's real-line formula
  ghat_offline              (★) at z = ε + iγ, the main term plus the lobe

Axioms: every theorem pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.WeilWindow

namespace WeilTransform

noncomputable section

open Complex WeilWindow intervalIntegral

/-- The odd envelope at complex argument, `∫₋₁¹ x·P(x)·sinh(w x) dx`. -/
def SigmaC (w : ℂ) : ℂ :=
  ∫ x in (-1 : ℝ)..1, ((x * P x : ℝ) : ℂ) * Complex.sinh (w * (x : ℂ))

/-- `Ψ(s) = ∫₋₁¹ x·P(x)·sin(s x) dx`, entry 302's transform of the envelope. -/
def Psi (s : ℝ) : ℝ := ∫ x in (-1 : ℝ)..1, x * P x * Real.sin (s * x)

/-- The tuned window: `(u/h)·P(u/h)·cos(γu)`, read on `[−h, h]`. -/
def G (h γ : ℝ) (u : ℝ) : ℝ := (u / h) * P (u / h) * Real.cos (γ * u)

/-- Its transform, `∫₋ₕʰ G(u)·e^{zu} du`. -/
def ghat (h γ : ℝ) (z : ℂ) : ℂ :=
  ∫ u in (-h)..h, ((G h γ u : ℝ) : ℂ) * Complex.exp (z * (u : ℂ))

theorem P_even (x : ℝ) : P (-x) = P x := by
  unfold P
  rw [show Real.pi * (-x) / 2 = -(Real.pi * x / 2) by ring, Real.cos_neg]

theorem xP_odd (x : ℝ) : (-x) * P (-x) = -(x * P x) := by
  rw [P_even]; ring

theorem continuous_xP : Continuous fun x : ℝ => x * P x :=
  continuous_id.mul continuous_P

/-- `Σc` at a real argument is `Σ`. -/
theorem SigmaC_ofReal (s : ℝ) : SigmaC (s : ℂ) = (WeilWindow.Sigma s : ℂ) := by
  unfold SigmaC WeilWindow.Sigma
  rw [← intervalIntegral.integral_ofReal]
  congr 1
  funext x
  simp [Complex.ofReal_sinh]

/-- `Σc(i s) = i·Ψ(s)`: `sinh(iθ) = i·sin θ`. -/
theorem SigmaC_I_mul (s : ℝ) : SigmaC (Complex.I * (s : ℂ)) = Complex.I * (Psi s : ℂ) := by
  unfold SigmaC Psi
  rw [← intervalIntegral.integral_ofReal, ← intervalIntegral.integral_const_mul]
  congr 1
  funext x
  have h1 : Complex.I * (s : ℂ) * (x : ℂ) = ((s * x : ℝ) : ℂ) * Complex.I := by
    push_cast; ring
  rw [h1, Complex.sinh_mul_I]
  push_cast
  ring

/-- **The odd-part lemma.** For odd continuous `q` on `[−1, 1]`,
`∫ q·e^{w·} = ∫ q·sinh(w·)`: the `cosh` part of `e^{w·}` pairs with `q` into
an odd function, whose integral over the symmetric interval vanishes. -/
theorem odd_integral_exp (q : ℝ → ℝ) (hq : ∀ x, q (-x) = -q x) (hc : Continuous q)
    (w : ℂ) :
    (∫ x in (-1 : ℝ)..1, ((q x : ℝ) : ℂ) * Complex.exp (w * (x : ℂ)))
      = ∫ x in (-1 : ℝ)..1, ((q x : ℝ) : ℂ) * Complex.sinh (w * (x : ℂ)) := by
  -- e^{wx} = cosh(wx) + sinh(wx)
  have hsplit : ∀ x : ℝ, ((q x : ℝ) : ℂ) * Complex.exp (w * (x : ℂ))
      = ((q x : ℝ) : ℂ) * Complex.cosh (w * (x : ℂ))
        + ((q x : ℝ) : ℂ) * Complex.sinh (w * (x : ℂ)) := by
    intro x
    rw [← mul_add, Complex.cosh_add_sinh]
  have hcont_cosh : Continuous fun x : ℝ => ((q x : ℝ) : ℂ) * Complex.cosh (w * (x : ℂ)) := by
    fun_prop
  have hcont_sinh : Continuous fun x : ℝ => ((q x : ℝ) : ℂ) * Complex.sinh (w * (x : ℂ)) := by
    fun_prop
  -- the cosh part is odd, hence integrates to 0 on [−1, 1]
  have hodd : ∀ x : ℝ, ((q (-x) : ℝ) : ℂ) * Complex.cosh (w * ((-x : ℝ) : ℂ))
      = -(((q x : ℝ) : ℂ) * Complex.cosh (w * (x : ℂ))) := by
    intro x
    rw [hq x]
    push_cast
    rw [show w * -(x : ℂ) = -(w * (x : ℂ)) by ring, Complex.cosh_neg]
    ring
  have hzero : (∫ x in (-1 : ℝ)..1, ((q x : ℝ) : ℂ) * Complex.cosh (w * (x : ℂ))) = 0 := by
    rw [← intervalIntegral.integral_add_adjacent_intervals
          (hcont_cosh.intervalIntegrable (-1 : ℝ) 0) (hcont_cosh.intervalIntegrable 0 1)]
    have hleft : (∫ x in (-1 : ℝ)..0, ((q x : ℝ) : ℂ) * Complex.cosh (w * (x : ℂ)))
        = -(∫ x in (0 : ℝ)..1, ((q x : ℝ) : ℂ) * Complex.cosh (w * (x : ℂ))) := by
      have h := intervalIntegral.integral_comp_neg
        (fun x : ℝ => ((q x : ℝ) : ℂ) * Complex.cosh (w * (x : ℂ))) (a := (0 : ℝ)) (b := 1)
      -- h : ∫ x in 0..1, f (-x) = ∫ x in -1..-0, f x
      simp only [neg_zero] at h
      rw [← h]
      rw [← intervalIntegral.integral_neg]
      congr 1
      funext x
      exact hodd x
    rw [hleft]
    ring
  calc (∫ x in (-1 : ℝ)..1, ((q x : ℝ) : ℂ) * Complex.exp (w * (x : ℂ)))
      = ∫ x in (-1 : ℝ)..1, (((q x : ℝ) : ℂ) * Complex.cosh (w * (x : ℂ))
          + ((q x : ℝ) : ℂ) * Complex.sinh (w * (x : ℂ))) := by
        congr 1; funext x; exact hsplit x
    _ = (∫ x in (-1 : ℝ)..1, ((q x : ℝ) : ℂ) * Complex.cosh (w * (x : ℂ)))
          + ∫ x in (-1 : ℝ)..1, ((q x : ℝ) : ℂ) * Complex.sinh (w * (x : ℂ)) :=
        intervalIntegral.integral_add (hcont_cosh.intervalIntegrable _ _)
          (hcont_sinh.intervalIntegrable _ _)
    _ = ∫ x in (-1 : ℝ)..1, ((q x : ℝ) : ℂ) * Complex.sinh (w * (x : ℂ)) := by
        rw [hzero, zero_add]

/-- **(★) The transform in closed form.** -/
theorem ghat_eq {h : ℝ} (hh : 0 < h) (γ : ℝ) (z : ℂ) :
    ghat h γ z = ((h : ℂ) / 2) *
      (SigmaC ((z + Complex.I * (γ : ℂ)) * (h : ℂ))
        + SigmaC ((z - Complex.I * (γ : ℂ)) * (h : ℂ))) := by
  unfold ghat
  -- change of variables u = h x
  have hcv : (∫ u in (-h)..h, ((G h γ u : ℝ) : ℂ) * Complex.exp (z * (u : ℂ)))
      = (h : ℂ) * ∫ x in (-1 : ℝ)..1, ((G h γ (h * x) : ℝ) : ℂ) * Complex.exp (z * ((h * x : ℝ) : ℂ)) := by
    have := intervalIntegral.integral_comp_mul_left
      (fun u : ℝ => ((G h γ u : ℝ) : ℂ) * Complex.exp (z * (u : ℂ))) (a := (-1 : ℝ)) (b := 1)
      (ne_of_gt hh)
    simp only [mul_neg, mul_one] at this
    rw [this, Complex.real_smul, ← mul_assoc]
    rw [show (h : ℂ) * ((h⁻¹ : ℝ) : ℂ) = 1 by
          push_cast; exact mul_inv_cancel₀ (by exact_mod_cast (ne_of_gt hh)), one_mul]
  rw [hcv]
  -- the integrand at h x: x·P(x)·cos(γhx)·e^{zhx}
  have hG : ∀ x : ℝ, G h γ (h * x) = x * P x * Real.cos (γ * (h * x)) := by
    intro x
    unfold G
    rw [show h * x / h = x by field_simp]
  -- cos(θ)·e^{a} = (e^{a + iθ} + e^{a − iθ})/2
  have key : ∀ θ a : ℂ, Complex.cos θ * Complex.exp a
      = (Complex.exp (a + θ * Complex.I) + Complex.exp (a - θ * Complex.I)) / 2 := by
    intro θ a
    simp only [Complex.cos, Complex.exp_add, sub_eq_add_neg, neg_mul, Complex.exp_neg]
    ring
  have hcarrier : ∀ x : ℝ, ((G h γ (h * x) : ℝ) : ℂ) * Complex.exp (z * ((h * x : ℝ) : ℂ))
      = (1 / 2 : ℂ) * (((x * P x : ℝ) : ℂ) * Complex.exp ((z + Complex.I * (γ : ℂ)) * (h : ℂ) * (x : ℂ))
          + ((x * P x : ℝ) : ℂ) * Complex.exp ((z - Complex.I * (γ : ℂ)) * (h : ℂ) * (x : ℂ))) := by
    intro x
    rw [hG x]
    push_cast
    have e1 : (z + Complex.I * (γ : ℂ)) * (h : ℂ) * (x : ℂ)
        = z * ((h : ℂ) * (x : ℂ)) + ((γ : ℂ) * ((h : ℂ) * (x : ℂ))) * Complex.I := by ring
    have e2 : (z - Complex.I * (γ : ℂ)) * (h : ℂ) * (x : ℂ)
        = z * ((h : ℂ) * (x : ℂ)) - ((γ : ℂ) * ((h : ℂ) * (x : ℂ))) * Complex.I := by ring
    rw [e1, e2, mul_assoc, key]
    ring
  simp_rw [hcarrier]
  rw [intervalIntegral.integral_const_mul, intervalIntegral.integral_add
        ((by fun_prop : Continuous fun x : ℝ => ((x * P x : ℝ) : ℂ) *
            Complex.exp ((z + Complex.I * (γ : ℂ)) * (h : ℂ) * (x : ℂ))).intervalIntegrable _ _)
        ((by fun_prop : Continuous fun x : ℝ => ((x * P x : ℝ) : ℂ) *
            Complex.exp ((z - Complex.I * (γ : ℂ)) * (h : ℂ) * (x : ℂ))).intervalIntegrable _ _)]
  unfold SigmaC
  rw [odd_integral_exp (fun x => x * P x) xP_odd continuous_xP,
      odd_integral_exp (fun x => x * P x) xP_odd continuous_xP]
  ring

/-- (★) on the real line: entry 302's `(ih/2)[Ψ(h(t+γ)) + Ψ(h(t−γ))]`. -/
theorem ghat_ofReal_I {h : ℝ} (hh : 0 < h) (γ t : ℝ) :
    ghat h γ (Complex.I * (t : ℂ)) =
      Complex.I * ((h : ℂ) / 2) * ((Psi (h * (t + γ)) : ℂ) + (Psi (h * (t - γ)) : ℂ)) := by
  rw [ghat_eq hh]
  have e1 : (Complex.I * (t : ℂ) + Complex.I * (γ : ℂ)) * (h : ℂ)
      = Complex.I * ((h * (t + γ) : ℝ) : ℂ) := by push_cast; ring
  have e2 : (Complex.I * (t : ℂ) - Complex.I * (γ : ℂ)) * (h : ℂ)
      = Complex.I * ((h * (t - γ) : ℝ) : ℂ) := by push_cast; ring
  rw [e1, e2, SigmaC_I_mul, SigmaC_I_mul]
  ring

/-- (★) at the off-line point `z = ε + iγ`: the main term `Σ(εh)` of unit 0317
plus the `2γ` lobe `Σc((ε + 2iγ)h)`. -/
theorem ghat_offline {h : ℝ} (hh : 0 < h) (γ ε : ℝ) :
    ghat h γ ((ε : ℂ) + Complex.I * (γ : ℂ)) =
      ((h : ℂ) / 2) * (SigmaC (((ε : ℂ) + 2 * Complex.I * (γ : ℂ)) * (h : ℂ))
        + (WeilWindow.Sigma (ε * h) : ℂ)) := by
  rw [ghat_eq hh]
  have e1 : ((ε : ℂ) + Complex.I * (γ : ℂ) + Complex.I * (γ : ℂ)) * (h : ℂ)
      = ((ε : ℂ) + 2 * Complex.I * (γ : ℂ)) * (h : ℂ) := by ring
  have e2 : ((ε : ℂ) + Complex.I * (γ : ℂ) - Complex.I * (γ : ℂ)) * (h : ℂ)
      = ((ε * h : ℝ) : ℂ) := by push_cast; ring
  rw [e1, e2, SigmaC_ofReal]

end

/-- info: 'WeilTransform.odd_integral_exp' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms odd_integral_exp

/-- info: 'WeilTransform.ghat_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms ghat_eq

/-- info: 'WeilTransform.ghat_ofReal_I' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms ghat_ofReal_I

/-- info: 'WeilTransform.ghat_offline' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms ghat_offline

end WeilTransform
