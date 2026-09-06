/-
WeilPowerCompare — the comparison at another off-line zero. Rung 5, ninth
slice, worksheet section 7. 2026-09-06.

Unit 0333 gives the switched window's transform in the Gaussian regime: an
upper bound at every point of the strip and a lower bound on the real axis,
with the same constant on both sides up to one factor `2m+3`. This module
puts the two together at two points at once — the target `(ε, 0)`, read on
the real axis at `s = εh`, and another off-line zero `(ε', Δ)`, read at
`w = (ε' + iΔ)h` — and reads off when the second is suppressed.

The two upper bounds of unit 0333 (`Re(w²) ≥ 0` and `Re(w²) ≤ 0`) are one
bound here. Writing

    cP m = 1/(π²(m+1)),  cE m = (m+2)/(π²(2m+3)²),  cQ m = 1/(π⁴(m+1)³),
    Eup m w = cE m·Re(w²) + (cP m − cE m)·max (Re(w²)) 0 + cQ m·‖w‖⁴,
    Elow m s = cE m·s² − cQ m·s⁴,

`max _ 0` selects the strong coefficient `cP` where `Re(w²) ≥ 0` and the
weak one `cE` where `Re(w²) ≤ 0`, which is what the two tail sums of unit
0333 give; `cE_le_cP` is `(m+1)(m+2) ≤ (2m+3)²`. Then

  norm_S_le_gauss   ‖S m w‖ ≤ 4/(π(m+1))·‖w‖·exp(Eup m w)         both signs
  S_real_ge_low     4/(π(m+1)(2m+3))·s·exp(Elow m s) ≤ Re (S m s)   0 < s
  compare_le        ‖S m w‖ ≤ (2m+3)·(‖w‖/s)·exp(Eup m w − Elow m s)·Re (S m s)

all under `‖w‖² ≤ π²(m+2)²/2` and `s² ≤ π²(m+2)²/2`, the regime of unit
0333. The prefactor loss is the single factor `2m+3`; that is the
worksheet's `poly(h, m)`.

In the worksheet's variables `w = wOf ε' Δ h = (ε' + iΔ)h`, `s = εh`, the
exponent difference splits into a quadratic rate and a quartic error with
no sign hypothesis at all:

  exponent_eq       Eup m (wOf ε' Δ h) − Elow m (εh)
                      = rate m ε' Δ ε · h² + qerr m ε' Δ ε · h⁴,
    rate m ε' Δ ε = cE m·(ε'² − Δ²) + (cP m − cE m)·max (ε'² − Δ²) 0 − cE m·ε²,
    qerr m ε' Δ ε = cQ m·((ε'² + Δ²)² + ε⁴).

  rate_eq_of_le     Δ² ≥ ε'²:  rate = −cE m·(Δ² + ε² − ε'²)
  rate_neg_of_le    Δ² ≥ ε'² and 0 < ε:  rate < 0, no condition on ε'
  rate_neg_of_ge    Δ² ≤ ε'²:  rate < 0 iff cP m·(ε'² − Δ²) < cE m·ε²
  compare_suppressed  qerr·h² ≤ −rate/2:
                      ‖S m w‖ ≤ (2m+3)·(‖w‖/s)·exp(rate·h²/2)·Re (S m s)

The range condition on `h` carries the sign of the rate with it: `qerr` is
positive at any target with `0 < ε` (`qerr_pos`), so `qerr·h² ≤ −rate/2`
already forces `rate < 0` (`rate_neg_of_qerr`), and `compare_suppressed`
does not repeat it as a hypothesis.

So the other zero is suppressed once the rate is negative and `h` is small
enough for the quartic error to be half the rate — the worksheet's "once
`h` is large enough that the exponential beats the polynomial" is the
`h²` in the exponent against the `2m+3` in front, and the regime condition
is the upper end. `rate_neg_of_le` is the worksheet's "a zero with `Δ² >
ε'²` is suppressed at every real part"; `rate_neg_of_ge` is the same
statement at `Δ² ≤ ε'²` with the constant `cE/cP = (m+1)(m+2)/(2m+3)²`
between `2/9` and `1/4`, the worksheet's `c between 1/4 and 1`.

The heights outside the regime condition are not restated here: they are
`WeilPowerBounds.norm_S_le_far` of unit 0331, whose decay
`(2/(Im w)²)^{m+1}` covers `‖w‖² > π²(m+2)²/2` and needs no Gaussian.

What the next slice needs: the selection of the target (worksheet § 8), a
zero of largest real part in a widened box, so that every other zero has
`ε'² − Δ²` below `ε² + K'π²λ/h` and `rate_neg_of_ge` applies to the whole
cluster at once.

Axioms: every theorem pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.WeilPowerGauss

namespace WeilPowerCompare

noncomputable section

open Complex WeilOddPower WeilPowerBounds WeilPowerGauss Real

/-- The strong Gaussian coefficient `1/(π²(m+1))`: the exponent's rate where
`Re(w²) ≥ 0`. -/
def cP (m : ℕ) : ℝ := 1 / (Real.pi ^ 2 * ((m : ℝ) + 1))

/-- The weak Gaussian coefficient `(m+2)/(π²(2m+3)²)`: the rate where
`Re(w²) ≤ 0`, and the one the target's lower bound carries. -/
def cE (m : ℕ) : ℝ := ((m : ℝ) + 2) / (Real.pi ^ 2 * (2 * (m : ℝ) + 3) ^ 2)

/-- The quartic error coefficient `1/(π⁴(m+1)³)`. -/
def cQ (m : ℕ) : ℝ := 1 / (Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3)

theorem cP_pos (m : ℕ) : 0 < cP m := by
  unfold cP
  have : (0 : ℝ) < (m : ℝ) + 1 := by positivity
  positivity

theorem cE_pos (m : ℕ) : 0 < cE m := by
  unfold cE
  have h1 : (0 : ℝ) < (m : ℝ) + 2 := by positivity
  have h2 : (0 : ℝ) < 2 * (m : ℝ) + 3 := by positivity
  positivity

theorem cQ_pos (m : ℕ) : 0 < cQ m := by
  unfold cQ
  have : (0 : ℝ) < (m : ℝ) + 1 := by positivity
  positivity

/-- `(m+1)(m+2) ≤ (2m+3)²`, so the weak coefficient is at most the strong one. -/
theorem cE_le_cP (m : ℕ) : cE m ≤ cP m := by
  unfold cE cP
  have hm : (0 : ℝ) ≤ (m : ℝ) := Nat.cast_nonneg m
  have hpi : (0 : ℝ) < Real.pi ^ 2 := by positivity
  rw [div_le_div_iff₀ (by positivity) (by positivity)]
  nlinarith [hpi, hm, sq_nonneg ((m : ℝ) + 1)]

/-- The upper exponent, both signs of `Re(w²)` in one expression: `max _ 0`
picks the strong coefficient where `Re(w²) ≥ 0` and the weak one elsewhere. -/
def Eup (m : ℕ) (w : ℂ) : ℝ :=
  cE m * (w ^ 2).re + (cP m - cE m) * max ((w ^ 2).re) 0 + cQ m * ‖w‖ ^ 4

/-- The lower exponent at the target, on the real axis. -/
def Elow (m : ℕ) (s : ℝ) : ℝ := cE m * s ^ 2 - cQ m * s ^ 4

/-- **The Gaussian upper bound, both signs in one exponent.** -/
theorem norm_S_le_gauss {m : ℕ} {w : ℂ} (hne : QS m w ≠ 0)
    (hsmall : ‖w‖ ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2) :
    ‖S m w‖ ≤ 4 / (Real.pi * ((m : ℝ) + 1)) * ‖w‖ * Real.exp (Eup m w) := by
  have hpi : (0 : ℝ) < Real.pi := Real.pi_pos
  have hm1 : (0 : ℝ) < (m : ℝ) + 1 := by positivity
  have hm3 : (0 : ℝ) < 2 * (m : ℝ) + 3 := by positivity
  rcases le_total 0 ((w ^ 2).re) with hre | hre
  · have hmax : max ((w ^ 2).re) 0 = (w ^ 2).re := max_eq_left hre
    have hE : Eup m w = (w ^ 2).re / (Real.pi ^ 2 * ((m : ℝ) + 1))
        + ‖w‖ ^ 4 / (Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3) := by
      unfold Eup cP cE cQ
      rw [hmax]
      field_simp
      ring
    rw [hE]
    exact norm_S_le_gauss_pos hne hsmall hre
  · have hmax : max ((w ^ 2).re) 0 = 0 := max_eq_right hre
    have hE : Eup m w = (w ^ 2).re * ((m : ℝ) + 2) / (Real.pi ^ 2 * (2 * (m : ℝ) + 3) ^ 2)
        + ‖w‖ ^ 4 / (Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3) := by
      unfold Eup cP cE cQ
      rw [hmax]
      field_simp
      ring
    rw [hE]
    exact norm_S_le_gauss_neg hne hsmall hre

/-- **The Gaussian lower bound at the target**, in the `Elow` form. -/
theorem S_real_ge_low {m : ℕ} {s : ℝ} (hs : 0 < s)
    (hsmall : s ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2) :
    4 / (Real.pi * ((m : ℝ) + 1) * (2 * (m : ℝ) + 3)) * s * Real.exp (Elow m s)
      ≤ (S m (s : ℂ)).re := by
  have hpi : (0 : ℝ) < Real.pi := Real.pi_pos
  have hm1 : (0 : ℝ) < (m : ℝ) + 1 := by positivity
  have hm3 : (0 : ℝ) < 2 * (m : ℝ) + 3 := by positivity
  have hE : Elow m s = s ^ 2 * ((m : ℝ) + 2) / (Real.pi ^ 2 * (2 * (m : ℝ) + 3) ^ 2)
      - s ^ 4 / (Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3) := by
    unfold Elow cE cQ
    field_simp
    try ring
  rw [hE]
  exact S_real_ge_gauss hs hsmall

/-- The target's transform is positive on the real axis inside the regime. -/
theorem S_real_pos {m : ℕ} {s : ℝ} (hs : 0 < s)
    (hsmall : s ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2) : 0 < (S m (s : ℂ)).re := by
  have hpi : (0 : ℝ) < Real.pi := Real.pi_pos
  have hm1 : (0 : ℝ) < (m : ℝ) + 1 := by positivity
  have hm3 : (0 : ℝ) < 2 * (m : ℝ) + 3 := by positivity
  have h := S_real_ge_low hs hsmall
  have hpos : 0 < 4 / (Real.pi * ((m : ℝ) + 1) * (2 * (m : ℝ) + 3)) * s
      * Real.exp (Elow m s) := by positivity
  linarith

/-- **The comparison at another off-line zero.** The transform at any point of
the regime is at most `2m+3` times `‖w‖/s` times the exponential of the
exponent difference, times the target's transform. -/
theorem compare_le {m : ℕ} {w : ℂ} {s : ℝ} (hne : QS m w ≠ 0)
    (hw : ‖w‖ ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2) (hs : 0 < s)
    (hs2 : s ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2) :
    ‖S m w‖ ≤ (2 * (m : ℝ) + 3) * (‖w‖ / s) * Real.exp (Eup m w - Elow m s)
      * (S m (s : ℂ)).re := by
  have hpi : (0 : ℝ) < Real.pi := Real.pi_pos
  have hm1 : (0 : ℝ) < (m : ℝ) + 1 := by positivity
  have hm3 : (0 : ℝ) < 2 * (m : ℝ) + 3 := by positivity
  have hexp : Real.exp (Eup m w - Elow m s) * Real.exp (Elow m s) = Real.exp (Eup m w) := by
    rw [← Real.exp_add]
    congr 1
    ring
  have hpre : 0 ≤ (2 * (m : ℝ) + 3) * (‖w‖ / s) * Real.exp (Eup m w - Elow m s) := by
    have : 0 ≤ ‖w‖ / s := div_nonneg (norm_nonneg _) hs.le
    positivity
  calc ‖S m w‖ ≤ 4 / (Real.pi * ((m : ℝ) + 1)) * ‖w‖ * Real.exp (Eup m w) :=
        norm_S_le_gauss hne hw
    _ = (2 * (m : ℝ) + 3) * (‖w‖ / s) * Real.exp (Eup m w - Elow m s)
        * (4 / (Real.pi * ((m : ℝ) + 1) * (2 * (m : ℝ) + 3)) * s * Real.exp (Elow m s)) := by
        rw [← hexp]
        field_simp
        try ring
    _ ≤ (2 * (m : ℝ) + 3) * (‖w‖ / s) * Real.exp (Eup m w - Elow m s) * (S m (s : ℂ)).re :=
        mul_le_mul_of_nonneg_left (S_real_ge_low hs hs2) hpre

/-- The point the window reads at a zero of real-part offset `ε` and height
offset `Δ`: `w = (ε + iΔ)h`. -/
def wOf (ε Δ h : ℝ) : ℂ := ((ε : ℂ) + Complex.I * (Δ : ℂ)) * (h : ℂ)

theorem wOf_re (ε Δ h : ℝ) : (wOf ε Δ h).re = ε * h := by
  simp [wOf]

theorem wOf_im (ε Δ h : ℝ) : (wOf ε Δ h).im = Δ * h := by
  simp [wOf]

theorem wOf_sq_re (ε Δ h : ℝ) : ((wOf ε Δ h) ^ 2).re = (ε ^ 2 - Δ ^ 2) * h ^ 2 := by
  rw [pow_two, Complex.mul_re, wOf_re, wOf_im]
  ring

theorem norm_wOf_sq (ε Δ h : ℝ) : ‖wOf ε Δ h‖ ^ 2 = (ε ^ 2 + Δ ^ 2) * h ^ 2 := by
  rw [Complex.sq_norm, Complex.normSq_apply, wOf_re, wOf_im]
  ring

theorem norm_wOf_pow4 (ε Δ h : ℝ) : ‖wOf ε Δ h‖ ^ 4 = ((ε ^ 2 + Δ ^ 2) * h ^ 2) ^ 2 := by
  rw [show (4 : ℕ) = 2 * 2 from rfl, pow_mul, norm_wOf_sq]

theorem QS_ne_zero_wOf {m : ℕ} {ε Δ h : ℝ} (hε : ε ≠ 0) (hh : h ≠ 0) :
    QS m (wOf ε Δ h) ≠ 0 := by
  apply QS_ne_zero
  rw [wOf_re]
  exact mul_ne_zero hε hh

/-- The quadratic rate of the exponent difference, per unit `h²`. -/
def rate (m : ℕ) (ε' Δ ε : ℝ) : ℝ :=
  cE m * (ε' ^ 2 - Δ ^ 2) + (cP m - cE m) * max (ε' ^ 2 - Δ ^ 2) 0 - cE m * ε ^ 2

/-- The quartic error of the exponent difference, per unit `h⁴`. -/
def qerr (m : ℕ) (ε' Δ ε : ℝ) : ℝ := cQ m * ((ε' ^ 2 + Δ ^ 2) ^ 2 + ε ^ 4)

/-- **The exponent difference in the worksheet's variables**, with no sign
hypothesis: a quadratic rate against a quartic error. -/
theorem exponent_eq (m : ℕ) (ε' Δ ε h : ℝ) :
    Eup m (wOf ε' Δ h) - Elow m (ε * h)
      = rate m ε' Δ ε * h ^ 2 + qerr m ε' Δ ε * h ^ 4 := by
  have hh2 : (0 : ℝ) ≤ h ^ 2 := sq_nonneg h
  unfold Eup Elow rate qerr
  rw [wOf_sq_re, norm_wOf_pow4]
  rcases le_total 0 (ε' ^ 2 - Δ ^ 2) with hsign | hsign
  · rw [max_eq_left hsign, max_eq_left (mul_nonneg hsign hh2)]
    ring
  · rw [max_eq_right hsign, max_eq_right (mul_nonpos_of_nonpos_of_nonneg hsign hh2)]
    ring

/-- At `Δ² ≥ ε'²` the rate is `−cE·(Δ² + ε² − ε'²)`. -/
theorem rate_eq_of_le (m : ℕ) {ε' Δ ε : ℝ} (hsq : ε' ^ 2 ≤ Δ ^ 2) :
    rate m ε' Δ ε = -(cE m * (Δ ^ 2 + ε ^ 2 - ε' ^ 2)) := by
  unfold rate
  rw [max_eq_right (by linarith)]
  ring

/-- **A zero above the target in height is suppressed at every real part.**
`Δ² ≥ ε'²` and `0 < ε` make the rate negative with no condition on `ε'`. -/
theorem rate_neg_of_le (m : ℕ) {ε' Δ ε : ℝ} (hε : 0 < ε) (hsq : ε' ^ 2 ≤ Δ ^ 2) :
    rate m ε' Δ ε < 0 := by
  rw [rate_eq_of_le m hsq]
  have h1 : 0 < cE m := cE_pos m
  have hb : 0 < Δ ^ 2 + ε ^ 2 - ε' ^ 2 := by nlinarith [pow_pos hε 2]
  nlinarith [mul_pos h1 hb]

/-- **A zero inside the target's height is suppressed when its real part does
not exceed the target's by the constant `cE/cP`.** -/
theorem rate_neg_of_ge (m : ℕ) {ε' Δ ε : ℝ} (hsq : Δ ^ 2 ≤ ε' ^ 2)
    (hlt : cP m * (ε' ^ 2 - Δ ^ 2) < cE m * ε ^ 2) : rate m ε' Δ ε < 0 := by
  unfold rate
  rw [max_eq_left (by linarith)]
  nlinarith [hlt]

/-- The quartic error is positive at any target with `0 < ε`. -/
theorem qerr_pos (m : ℕ) {ε' Δ ε : ℝ} (hε : 0 < ε) : 0 < qerr m ε' Δ ε := by
  unfold qerr
  have h1 : 0 < cQ m := cQ_pos m
  have h2 : (0 : ℝ) < ε ^ 4 := by positivity
  nlinarith [sq_nonneg (ε' ^ 2 + Δ ^ 2)]

/-- The range condition on `h` already forces the rate negative. -/
theorem rate_neg_of_qerr {m : ℕ} {ε' Δ ε h : ℝ} (hε : 0 < ε) (hh : 0 < h)
    (hq : qerr m ε' Δ ε * h ^ 2 ≤ -rate m ε' Δ ε / 2) : rate m ε' Δ ε < 0 := by
  have h1 : 0 < qerr m ε' Δ ε := qerr_pos m hε
  have h2 : (0 : ℝ) < h ^ 2 := by positivity
  nlinarith [mul_pos h1 h2]

/-- **Suppression at another off-line zero.** For `h` in the range where the
quartic error is at most half the rate — which by `rate_neg_of_qerr` already
makes the rate negative — the transform at the other zero is an exponentially
small multiple of the target's. -/
theorem compare_suppressed {m : ℕ} {ε' Δ ε h : ℝ} (hε : 0 < ε) (hh : 0 < h) (hε' : ε' ≠ 0)
    (hq : qerr m ε' Δ ε * h ^ 2 ≤ -rate m ε' Δ ε / 2)
    (hw : (ε' ^ 2 + Δ ^ 2) * h ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2)
    (hs : (ε * h) ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2) :
    ‖S m (wOf ε' Δ h)‖
      ≤ (2 * (m : ℝ) + 3) * (‖wOf ε' Δ h‖ / (ε * h))
        * Real.exp (rate m ε' Δ ε * h ^ 2 / 2) * (S m ((ε * h : ℝ) : ℂ)).re := by
  have hsp : 0 < ε * h := mul_pos hε hh
  have hne : QS m (wOf ε' Δ h) ≠ 0 := QS_ne_zero_wOf hε' hh.ne'
  have hwn : ‖wOf ε' Δ h‖ ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2 := by
    rw [norm_wOf_sq]
    exact hw
  have hR : 0 ≤ (S m ((ε * h : ℝ) : ℂ)).re := (S_real_pos hsp hs).le
  have hpre : 0 ≤ (2 * (m : ℝ) + 3) * (‖wOf ε' Δ h‖ / (ε * h)) := by
    have : 0 ≤ ‖wOf ε' Δ h‖ / (ε * h) := div_nonneg (norm_nonneg _) hsp.le
    positivity
  have hexp : Eup m (wOf ε' Δ h) - Elow m (ε * h) ≤ rate m ε' Δ ε * h ^ 2 / 2 := by
    rw [exponent_eq]
    have hh2 : (0 : ℝ) < h ^ 2 := by positivity
    nlinarith [hq, hh2]
  calc ‖S m (wOf ε' Δ h)‖
      ≤ (2 * (m : ℝ) + 3) * (‖wOf ε' Δ h‖ / (ε * h))
        * Real.exp (Eup m (wOf ε' Δ h) - Elow m (ε * h)) * (S m ((ε * h : ℝ) : ℂ)).re :=
        compare_le hne hwn hsp hs
    _ ≤ _ := by
        apply mul_le_mul_of_nonneg_right _ hR
        exact mul_le_mul_of_nonneg_left (Real.exp_le_exp.mpr hexp) hpre

end

/-- info: 'WeilPowerCompare.norm_S_le_gauss' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms norm_S_le_gauss

/-- info: 'WeilPowerCompare.compare_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms compare_le

/-- info: 'WeilPowerCompare.exponent_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms exponent_eq

/-- info: 'WeilPowerCompare.compare_suppressed' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms compare_suppressed

end WeilPowerCompare
