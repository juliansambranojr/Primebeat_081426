/-
WeilPowerGeom — the geometric sum and the harmonic correction: the two
sums the averaging route needs over a range of `h`, one bounded
independently of the range length, the other by a logarithm of it. Rung 5,
fourteenth slice; worksheet § 13 block 13d. 2026-09-06.

Unit 0348 writes a member's normalized term at `m` as
`exp(z·u m) = exp(z(m+½)/π²)·exp(z·r m)` with `r m = u m − (m+½)/π²` in
`[0, 1/(π²(4m+6))]`. Summed over `m ∈ Ico a b`, the first factor is a
geometric series in `ρ = exp(z/π²)` and the second is a correction. This
module bounds both:

  `Σ_{Ico a b} exp(z(m+½)/π²)` by `geomBound z a b`, which does not grow
  with `b − a` at all: the phase `Im z/π²` alone separates `ρ` from `1`,
  and Jordan's inequality turns that separation into the explicit
  `π³/(2 z.im)`;

  `Σ_{Ico a b} (exp(z·u m) − exp(z(m+½)/π²))` by
  `2‖z‖·Mab z a b·(log b − log a)/(4π²)`, logarithmic in the range: the
  price of `r = O(1/m)` and no more.

Against the target's linear `b − a` both are gains, so the averaging of
worksheet § 13 closes at this slice with no lost factor.

Defs.
  Mab z a b        max (exp(z.re(a+½)/π²)) (exp(z.re(b+½)/π²))
  geomBound z a b  (exp(z.re(a+½)/π²) + exp(z.re(b+½)/π²))·π³
                     / (2·exp(z.re/π²)·z.im)

Theorems, with the regime the block names:
  R1 `0 < z.im`;  R2 `z.im ≤ π³/2`;  R3 `1 ≤ a`;  R4 `a ≤ b`;
  R5 `‖z‖ ≤ π²(4a+6)`;  R6 `∀ m, 0 ≤ u m − (m+½)/π² ≤ 1/(π²(4m+6))`.

  norm_one_sub_exp_ge   none        exp(w.re)·|sin w.im| ≤ ‖1 − exp w‖
  sin_im_ge             R1, R2      2 z.im/π³ ≤ sin(z.im/π²)
  rho_ne_one            R1, R2      exp(z/π²) ≠ 1
  exp_shift             none        exp(z(m+½)/π²) = exp(z/(2π²))·exp(z/π²)^m
  geom_Ico              x ≠ 1, R4   Σ_{Ico a b} x^m = (x^b − x^a)/(x − 1)
  norm_geom_le          R1, R2, R4  ‖Σ exp(z(m+½)/π²)‖ ≤ geomBound z a b
  exp_lin_le_Mab        a ≤ m ≤ b   exp(z.re(m+½)/π²) ≤ Mab z a b
  log_step              1 ≤ m       1/(m+1) ≤ log(m+1) − log m
  log_telescope         R3, R4      Σ_{Ico a b} 1/(m+1) ≤ log b − log a
  harmonic_quarter      R3, R4      Σ 1/(π²(4m+6)) ≤ (log b − log a)/(4π²)
  norm_corr_le          R5, R6,     ‖exp(z·u m) − exp(z(m+½)/π²)‖
                        a ≤ m         ≤ exp(z.re(m+½)/π²)·2‖z‖·(u m − (m+½)/π²)
  norm_sum_exp_u_le     R1–R6       ‖Σ exp(z·u m)‖ ≤ geomBound z a b
                                      + 2‖z‖·Mab z a b·(log b − log a)/(4π²)

Two of the block's hypotheses are dropped where the proof does not use
them, which the statement's unused binder would otherwise warn on
(`TRAPS.md` row 20): `exp_lin_le_Mab` takes `a ≤ m` and `m ≤ b` and needs
no separate R4, and `norm_corr_le` needs no R3, since R5 at `a` plus
`a ≤ m` already gives `‖z‖·r m ≤ 1`. The block's remark that this Mathlib
has no `geom_sum_Ico` is wrong: `Algebra/Field/GeomSum.lean` states it as
a `lemma`, in exactly the block's shape, and `geom_Ico` is that lemma.

`u` enters as an abstract sequence with R6 as its hypothesis, so nothing
here imports `WeilPowerSigma`; unit 0348's `r_pos` and `r_le` are R6 at
the shell (LOOP.md § 3, parameterize downstream).

What the next slice needs: block 13e, which reads `z`, `Mab` and the
regime at the shell — `Im z = 4ε'Δ`, `|Re z| ≤ η`, `Mab ≤ e^{K'}` — and
traces the quartic phase error `q ≤ 1/(N e^{K'})` back to `h` and `λ`.

Axioms: every theorem pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.Statement

namespace WeilPowerGeom

noncomputable section

open Real Filter Topology

/-- The larger endpoint value of the geometric factor: `exp(z.re(m+½)/π²)` is
monotone in `m`, so on `[a, b]` it is at most this. -/
def Mab (z : ℂ) (a b : ℕ) : ℝ :=
  max (Real.exp (z.re * ((a : ℝ) + 1 / 2) / Real.pi ^ 2))
    (Real.exp (z.re * ((b : ℝ) + 1 / 2) / Real.pi ^ 2))

/-- The geometric sum's bound: the two endpoint values over the separation of
`ρ = exp(z/π²)` from `1`, which Jordan's inequality makes `2 z.im/π³` times
`exp(z.re/π²)`. It does not grow with `b − a`. -/
def geomBound (z : ℂ) (a b : ℕ) : ℝ :=
  (Real.exp (z.re * ((a : ℝ) + 1 / 2) / Real.pi ^ 2)
      + Real.exp (z.re * ((b : ℝ) + 1 / 2) / Real.pi ^ 2)) * Real.pi ^ 3
    / (2 * Real.exp (z.re / Real.pi ^ 2) * z.im)

/-- **The separation of `exp w` from `1`**, from the imaginary part alone. -/
theorem norm_one_sub_exp_ge (w : ℂ) :
    Real.exp w.re * |Real.sin w.im| ≤ ‖1 - Complex.exp w‖ := by
  have h := Complex.abs_im_le_norm (1 - Complex.exp w)
  have him : (1 - Complex.exp w).im = -(Real.exp w.re * Real.sin w.im) := by
    simp [Complex.sub_im, Complex.exp_im]
  rw [him, abs_neg, abs_mul, abs_of_pos (Real.exp_pos w.re)] at h
  exact h

/-- **Jordan's inequality at the phase** `z.im/π²`, linear in `z.im`. -/
theorem sin_im_ge {z : ℂ} (hz1 : 0 < z.im) (hz2 : z.im ≤ Real.pi ^ 3 / 2) :
    2 * z.im / Real.pi ^ 3 ≤ Real.sin (z.im / Real.pi ^ 2) := by
  have hpi : (0 : ℝ) < Real.pi := Real.pi_pos
  have hx0 : (0 : ℝ) ≤ z.im / Real.pi ^ 2 := by positivity
  have hx1 : z.im / Real.pi ^ 2 ≤ Real.pi / 2 := by
    rw [div_le_div_iff₀ (by positivity) (by norm_num)]
    nlinarith [Real.pi_pos]
  have hs := Real.mul_le_sin hx0 hx1
  have e : 2 / Real.pi * (z.im / Real.pi ^ 2) = 2 * z.im / Real.pi ^ 3 := by
    field_simp
    try ring
  linarith [e ▸ hs]

/-- The ratio `ρ = exp(z/π²)` is not `1`: its distance to `1` is at least
`exp(z.re/π²)·2 z.im/π³ > 0`. -/
theorem rho_ne_one {z : ℂ} (hz1 : 0 < z.im) (hz2 : z.im ≤ Real.pi ^ 3 / 2) :
    Complex.exp (z / (Real.pi : ℂ) ^ 2) ≠ 1 := by
  have hpi : (0 : ℝ) < Real.pi := Real.pi_pos
  have hre : (z / (Real.pi : ℂ) ^ 2).re = z.re / Real.pi ^ 2 := by
    rw [← Complex.ofReal_pow, Complex.div_ofReal_re]
  have him : (z / (Real.pi : ℂ) ^ 2).im = z.im / Real.pi ^ 2 := by
    rw [← Complex.ofReal_pow, Complex.div_ofReal_im]
  have h1 := norm_one_sub_exp_ge (z / (Real.pi : ℂ) ^ 2)
  rw [hre, him] at h1
  have h2 : 2 * z.im / Real.pi ^ 3 ≤ |Real.sin (z.im / Real.pi ^ 2)| :=
    le_trans (sin_im_ge hz1 hz2) (le_abs_self _)
  have h3 : (0 : ℝ) < Real.exp (z.re / Real.pi ^ 2) * (2 * z.im / Real.pi ^ 3) :=
    mul_pos (Real.exp_pos _) (div_pos (by linarith) (by positivity))
  have h4 : (0 : ℝ) < ‖1 - Complex.exp (z / (Real.pi : ℂ) ^ 2)‖ := by
    refine lt_of_lt_of_le h3 (le_trans ?_ h1)
    exact mul_le_mul_of_nonneg_left h2 (Real.exp_pos _).le
  intro hcon
  rw [hcon, sub_self, norm_zero] at h4
  exact lt_irrefl 0 h4

/-- **The geometric factorization** of the shifted exponential. -/
theorem exp_shift (z : ℂ) (m : ℕ) :
    Complex.exp (z * ((m : ℂ) + 1 / 2) / (Real.pi : ℂ) ^ 2)
      = Complex.exp (z / (2 * (Real.pi : ℂ) ^ 2))
        * Complex.exp (z / (Real.pi : ℂ) ^ 2) ^ m := by
  rw [← Complex.exp_nat_mul, ← Complex.exp_add]
  congr 1
  have hpi : (Real.pi : ℂ) ≠ 0 := by exact_mod_cast Real.pi_ne_zero
  field_simp
  ring

/-- The geometric series over `Ico a b`; Mathlib's `geom_sum_Ico`, which this
Mathlib does state (as a `lemma`, so a `theorem`-only grep misses it). -/
theorem geom_Ico {x : ℂ} (hx : x ≠ 1) {a b : ℕ} (hab : a ≤ b) :
    ∑ m ∈ Finset.Ico a b, x ^ m = (x ^ b - x ^ a) / (x - 1) :=
  geom_sum_Ico hx hab

/-- **The geometric sum is bounded independently of the range length.** -/
theorem norm_geom_le {z : ℂ} (hz1 : 0 < z.im) (hz2 : z.im ≤ Real.pi ^ 3 / 2)
    {a b : ℕ} (hab : a ≤ b) :
    ‖∑ m ∈ Finset.Ico a b, Complex.exp (z * ((m : ℂ) + 1 / 2) / (Real.pi : ℂ) ^ 2)‖
      ≤ geomBound z a b := by
  have hpi : (0 : ℝ) < Real.pi := Real.pi_pos
  have hpine : Real.pi ≠ 0 := Real.pi_ne_zero
  have hre : (z / (Real.pi : ℂ) ^ 2).re = z.re / Real.pi ^ 2 := by
    rw [← Complex.ofReal_pow, Complex.div_ofReal_re]
  have him : (z / (Real.pi : ℂ) ^ 2).im = z.im / Real.pi ^ 2 := by
    rw [← Complex.ofReal_pow, Complex.div_ofReal_im]
  have hre2 : (z / (2 * (Real.pi : ℂ) ^ 2)).re = z.re / (2 * Real.pi ^ 2) := by
    have h : (2 : ℂ) * (Real.pi : ℂ) ^ 2 = ((2 * Real.pi ^ 2 : ℝ) : ℂ) := by
      push_cast
      ring
    rw [h, Complex.div_ofReal_re]
  have hlow : Real.exp (z.re / Real.pi ^ 2) * (2 * z.im / Real.pi ^ 3)
      ≤ ‖1 - Complex.exp (z / (Real.pi : ℂ) ^ 2)‖ := by
    have h1 := norm_one_sub_exp_ge (z / (Real.pi : ℂ) ^ 2)
    rw [hre, him] at h1
    have h2 : 2 * z.im / Real.pi ^ 3 ≤ |Real.sin (z.im / Real.pi ^ 2)| :=
      le_trans (sin_im_ge hz1 hz2) (le_abs_self _)
    exact le_trans (mul_le_mul_of_nonneg_left h2 (Real.exp_pos _).le) h1
  have hlow0 : (0 : ℝ) < Real.exp (z.re / Real.pi ^ 2) * (2 * z.im / Real.pi ^ 3) :=
    mul_pos (Real.exp_pos _) (div_pos (by linarith) (by positivity))
  have hD : (0 : ℝ) < ‖Complex.exp (z / (Real.pi : ℂ) ^ 2) - 1‖ := by
    rw [norm_sub_rev]
    exact lt_of_lt_of_le hlow0 hlow
  have hsum : ∑ m ∈ Finset.Ico a b, Complex.exp (z * ((m : ℂ) + 1 / 2) / (Real.pi : ℂ) ^ 2)
      = Complex.exp (z / (2 * (Real.pi : ℂ) ^ 2))
        * ((Complex.exp (z / (Real.pi : ℂ) ^ 2) ^ b
              - Complex.exp (z / (Real.pi : ℂ) ^ 2) ^ a)
            / (Complex.exp (z / (Real.pi : ℂ) ^ 2) - 1)) := by
    rw [← geom_Ico (rho_ne_one hz1 hz2) hab, Finset.mul_sum]
    exact Finset.sum_congr rfl fun m _ => exp_shift z m
  rw [hsum, norm_mul, norm_div, Complex.norm_exp, hre2, ← mul_div_assoc, div_le_iff₀ hD]
  have hE : ∀ n : ℕ, Real.exp (z.re / (2 * Real.pi ^ 2)) * Real.exp (z.re / Real.pi ^ 2) ^ n
      = Real.exp (z.re * ((n : ℝ) + 1 / 2) / Real.pi ^ 2) := by
    intro n
    rw [← Real.exp_nat_mul, ← Real.exp_add]
    congr 1
    field_simp
    ring
  have hnormrho : ‖Complex.exp (z / (Real.pi : ℂ) ^ 2)‖ = Real.exp (z.re / Real.pi ^ 2) := by
    rw [Complex.norm_exp, hre]
  have hnum : Real.exp (z.re / (2 * Real.pi ^ 2))
        * ‖Complex.exp (z / (Real.pi : ℂ) ^ 2) ^ b - Complex.exp (z / (Real.pi : ℂ) ^ 2) ^ a‖
      ≤ Real.exp (z.re * ((a : ℝ) + 1 / 2) / Real.pi ^ 2)
        + Real.exp (z.re * ((b : ℝ) + 1 / 2) / Real.pi ^ 2) := by
    have h1 : ‖Complex.exp (z / (Real.pi : ℂ) ^ 2) ^ b - Complex.exp (z / (Real.pi : ℂ) ^ 2) ^ a‖
        ≤ Real.exp (z.re / Real.pi ^ 2) ^ b + Real.exp (z.re / Real.pi ^ 2) ^ a := by
      calc ‖Complex.exp (z / (Real.pi : ℂ) ^ 2) ^ b - Complex.exp (z / (Real.pi : ℂ) ^ 2) ^ a‖
          ≤ ‖Complex.exp (z / (Real.pi : ℂ) ^ 2) ^ b‖
            + ‖Complex.exp (z / (Real.pi : ℂ) ^ 2) ^ a‖ := norm_sub_le _ _
        _ = Real.exp (z.re / Real.pi ^ 2) ^ b + Real.exp (z.re / Real.pi ^ 2) ^ a := by
            rw [norm_pow, norm_pow, hnormrho]
    calc Real.exp (z.re / (2 * Real.pi ^ 2))
          * ‖Complex.exp (z / (Real.pi : ℂ) ^ 2) ^ b - Complex.exp (z / (Real.pi : ℂ) ^ 2) ^ a‖
        ≤ Real.exp (z.re / (2 * Real.pi ^ 2))
            * (Real.exp (z.re / Real.pi ^ 2) ^ b + Real.exp (z.re / Real.pi ^ 2) ^ a) :=
          mul_le_mul_of_nonneg_left h1 (Real.exp_pos _).le
      _ = Real.exp (z.re * ((a : ℝ) + 1 / 2) / Real.pi ^ 2)
            + Real.exp (z.re * ((b : ℝ) + 1 / 2) / Real.pi ^ 2) := by
          rw [mul_add, hE b, hE a]
          ring
  have hgb0 : 0 ≤ geomBound z a b := by
    unfold geomBound
    refine div_nonneg (by positivity) ?_
    exact mul_nonneg (mul_nonneg (by norm_num) (Real.exp_pos _).le) hz1.le
  have hprod : geomBound z a b * (Real.exp (z.re / Real.pi ^ 2) * (2 * z.im / Real.pi ^ 3))
      = Real.exp (z.re * ((a : ℝ) + 1 / 2) / Real.pi ^ 2)
        + Real.exp (z.re * ((b : ℝ) + 1 / 2) / Real.pi ^ 2) := by
    unfold geomBound
    have he : Real.exp (z.re / Real.pi ^ 2) ≠ 0 := (Real.exp_pos _).ne'
    have hi : z.im ≠ 0 := ne_of_gt hz1
    field_simp
    try ring
  calc Real.exp (z.re / (2 * Real.pi ^ 2))
        * ‖Complex.exp (z / (Real.pi : ℂ) ^ 2) ^ b - Complex.exp (z / (Real.pi : ℂ) ^ 2) ^ a‖
      ≤ Real.exp (z.re * ((a : ℝ) + 1 / 2) / Real.pi ^ 2)
        + Real.exp (z.re * ((b : ℝ) + 1 / 2) / Real.pi ^ 2) := hnum
    _ = geomBound z a b * (Real.exp (z.re / Real.pi ^ 2) * (2 * z.im / Real.pi ^ 3)) := hprod.symm
    _ ≤ geomBound z a b * ‖Complex.exp (z / (Real.pi : ℂ) ^ 2) - 1‖ := by
        refine mul_le_mul_of_nonneg_left ?_ hgb0
        rw [norm_sub_rev]
        exact hlow

/-- The geometric factor at an interior `m` is at most its value at an endpoint:
the exponent is linear in `m`, so the sign of `z.re` picks the end. -/
theorem exp_lin_le_Mab {z : ℂ} {a b m : ℕ} (ham : a ≤ m) (hmb : m ≤ b) :
    Real.exp (z.re * ((m : ℝ) + 1 / 2) / Real.pi ^ 2) ≤ Mab z a b := by
  have hpi : (0 : ℝ) < Real.pi := Real.pi_pos
  have hma : ((a : ℝ)) ≤ (m : ℝ) := by exact_mod_cast ham
  have hmb' : ((m : ℝ)) ≤ (b : ℝ) := by exact_mod_cast hmb
  unfold Mab
  rcases le_or_gt 0 z.re with h | h
  · refine le_trans (Real.exp_le_exp.mpr ?_) (le_max_right _ _)
    rw [div_le_div_iff₀ (by positivity) (by positivity)]
    nlinarith [mul_nonneg (mul_nonneg h (sub_nonneg.mpr hmb')) (le_of_lt (pow_pos hpi 2))]
  · refine le_trans (Real.exp_le_exp.mpr ?_) (le_max_left _ _)
    rw [div_le_div_iff₀ (by positivity) (by positivity)]
    nlinarith [mul_nonneg (mul_nonneg (neg_nonneg.mpr h.le) (sub_nonneg.mpr hma))
      (le_of_lt (pow_pos hpi 2))]

/-- **One harmonic step against the logarithm**, `1/(m+1) ≤ log(m+1) − log m`. -/
theorem log_step {m : ℕ} (hm : 1 ≤ m) :
    1 / ((m : ℝ) + 1) ≤ Real.log ((m : ℝ) + 1) - Real.log m := by
  have hm0 : (0 : ℝ) < m := by exact_mod_cast hm
  have hm1 : (0 : ℝ) < (m : ℝ) + 1 := by linarith
  have hlog := Real.log_le_sub_one_of_pos (x := (m : ℝ) / ((m : ℝ) + 1)) (by positivity)
  rw [Real.log_div (ne_of_gt hm0) (ne_of_gt hm1)] at hlog
  have e : (m : ℝ) / ((m : ℝ) + 1) - 1 = -(1 / ((m : ℝ) + 1)) := by
    field_simp
    try ring
  rw [e] at hlog
  linarith

/-- **The harmonic sum over `Ico a b` is at most `log b − log a`.** -/
theorem log_telescope {a : ℕ} (ha : 1 ≤ a) : ∀ b : ℕ, a ≤ b →
    ∑ m ∈ Finset.Ico a b, 1 / ((m : ℝ) + 1) ≤ Real.log b - Real.log a := by
  intro b hb
  induction b, hb using Nat.le_induction with
  | base => simp
  | succ b hb ih =>
    rw [Finset.sum_Ico_succ_top hb]
    have h1 : 1 ≤ b := le_trans ha hb
    have hs := log_step h1
    push_cast
    linarith

/-- **The correction sum's majorant**, `(log b − log a)/(4π²)`. -/
theorem harmonic_quarter {a : ℕ} (ha : 1 ≤ a) {b : ℕ} (hab : a ≤ b) :
    ∑ m ∈ Finset.Ico a b, 1 / (Real.pi ^ 2 * (4 * (m : ℝ) + 6))
      ≤ (Real.log b - Real.log a) / (4 * Real.pi ^ 2) := by
  have hpi : (0 : ℝ) < Real.pi := Real.pi_pos
  have hterm : ∀ m ∈ Finset.Ico a b, 1 / (Real.pi ^ 2 * (4 * (m : ℝ) + 6))
      ≤ 1 / (4 * Real.pi ^ 2) * (1 / ((m : ℝ) + 1)) := by
    intro m _
    rw [div_mul_div_comm, one_mul, div_le_div_iff₀ (by positivity) (by positivity)]
    nlinarith [sq_nonneg Real.pi, Nat.cast_nonneg (α := ℝ) m]
  calc ∑ m ∈ Finset.Ico a b, 1 / (Real.pi ^ 2 * (4 * (m : ℝ) + 6))
      ≤ ∑ m ∈ Finset.Ico a b, 1 / (4 * Real.pi ^ 2) * (1 / ((m : ℝ) + 1)) :=
        Finset.sum_le_sum hterm
    _ = 1 / (4 * Real.pi ^ 2) * ∑ m ∈ Finset.Ico a b, 1 / ((m : ℝ) + 1) := by
        rw [Finset.mul_sum]
    _ ≤ 1 / (4 * Real.pi ^ 2) * (Real.log b - Real.log a) :=
        mul_le_mul_of_nonneg_left (log_telescope ha b hab) (by positivity)
    _ = (Real.log b - Real.log a) / (4 * Real.pi ^ 2) := by ring

/-- **One term's correction**, `2‖z‖·r m` times the geometric factor. -/
theorem norm_corr_le {z : ℂ} {u : ℕ → ℝ} {a m : ℕ}
    (hz : ‖z‖ ≤ Real.pi ^ 2 * (4 * (a : ℝ) + 6))
    (hu : ∀ k : ℕ, 0 ≤ u k - ((k : ℝ) + 1 / 2) / Real.pi ^ 2
      ∧ u k - ((k : ℝ) + 1 / 2) / Real.pi ^ 2 ≤ 1 / (Real.pi ^ 2 * (4 * (k : ℝ) + 6)))
    (ham : a ≤ m) :
    ‖Complex.exp (z * (u m : ℂ)) - Complex.exp (z * ((m : ℂ) + 1 / 2) / (Real.pi : ℂ) ^ 2)‖
      ≤ Real.exp (z.re * ((m : ℝ) + 1 / 2) / Real.pi ^ 2) * (2 * ‖z‖)
        * (u m - ((m : ℝ) + 1 / 2) / Real.pi ^ 2) := by
  have hpi : (0 : ℝ) < Real.pi := Real.pi_pos
  have hr0 := (hu m).1
  have hr1 := (hu m).2
  have hma : ((a : ℝ)) ≤ (m : ℝ) := by exact_mod_cast ham
  have hreM : (z * ((m : ℂ) + 1 / 2) / (Real.pi : ℂ) ^ 2).re
      = z.re * ((m : ℝ) + 1 / 2) / Real.pi ^ 2 := by
    rw [← Complex.ofReal_pow, Complex.div_ofReal_re]
    simp [Complex.mul_re]
  have hzr : ‖z * ((u m - ((m : ℝ) + 1 / 2) / Real.pi ^ 2 : ℝ) : ℂ)‖
      = ‖z‖ * (u m - ((m : ℝ) + 1 / 2) / Real.pi ^ 2) := by
    rw [norm_mul, Complex.norm_real, Real.norm_eq_abs, abs_of_nonneg hr0]
  have hle1 : ‖z * ((u m - ((m : ℝ) + 1 / 2) / Real.pi ^ 2 : ℝ) : ℂ)‖ ≤ 1 := by
    rw [hzr]
    have h1 : ‖z‖ * (u m - ((m : ℝ) + 1 / 2) / Real.pi ^ 2)
        ≤ (Real.pi ^ 2 * (4 * (a : ℝ) + 6)) * (1 / (Real.pi ^ 2 * (4 * (m : ℝ) + 6))) :=
      mul_le_mul hz hr1 hr0 (by positivity)
    have h2 : (Real.pi ^ 2 * (4 * (a : ℝ) + 6)) * (1 / (Real.pi ^ 2 * (4 * (m : ℝ) + 6))) ≤ 1 := by
      rw [mul_one_div, div_le_one (by positivity)]
      exact mul_le_mul_of_nonneg_left (by linarith) (le_of_lt (pow_pos hpi 2))
    linarith
  have hcast : ((u m : ℝ) : ℂ) = ((m : ℂ) + 1 / 2) / (Real.pi : ℂ) ^ 2
      + ((u m - ((m : ℝ) + 1 / 2) / Real.pi ^ 2 : ℝ) : ℂ) := by
    push_cast
    ring
  have hsplit : Complex.exp (z * (u m : ℂ))
        - Complex.exp (z * ((m : ℂ) + 1 / 2) / (Real.pi : ℂ) ^ 2)
      = Complex.exp (z * ((m : ℂ) + 1 / 2) / (Real.pi : ℂ) ^ 2)
        * (Complex.exp (z * ((u m - ((m : ℝ) + 1 / 2) / Real.pi ^ 2 : ℝ) : ℂ)) - 1) := by
    rw [hcast, mul_add, Complex.exp_add]
    ring_nf
  rw [hsplit, norm_mul, Complex.norm_exp, hreM]
  have hb := Complex.norm_exp_sub_one_le hle1
  rw [hzr] at hb
  calc Real.exp (z.re * ((m : ℝ) + 1 / 2) / Real.pi ^ 2)
        * ‖Complex.exp (z * ((u m - ((m : ℝ) + 1 / 2) / Real.pi ^ 2 : ℝ) : ℂ)) - 1‖
      ≤ Real.exp (z.re * ((m : ℝ) + 1 / 2) / Real.pi ^ 2)
        * (2 * (‖z‖ * (u m - ((m : ℝ) + 1 / 2) / Real.pi ^ 2))) :=
        mul_le_mul_of_nonneg_left hb (Real.exp_pos _).le
    _ = Real.exp (z.re * ((m : ℝ) + 1 / 2) / Real.pi ^ 2) * (2 * ‖z‖)
        * (u m - ((m : ℝ) + 1 / 2) / Real.pi ^ 2) := by ring

/-- **The averaged sum**: bounded by the range-free geometric bound plus a
logarithm of the range. -/
theorem norm_sum_exp_u_le {z : ℂ} {u : ℕ → ℝ} {a b : ℕ}
    (hz1 : 0 < z.im) (hz2 : z.im ≤ Real.pi ^ 3 / 2) (ha : 1 ≤ a) (hab : a ≤ b)
    (hz : ‖z‖ ≤ Real.pi ^ 2 * (4 * (a : ℝ) + 6))
    (hu : ∀ k : ℕ, 0 ≤ u k - ((k : ℝ) + 1 / 2) / Real.pi ^ 2
      ∧ u k - ((k : ℝ) + 1 / 2) / Real.pi ^ 2 ≤ 1 / (Real.pi ^ 2 * (4 * (k : ℝ) + 6))) :
    ‖∑ m ∈ Finset.Ico a b, Complex.exp (z * (u m : ℂ))‖
      ≤ geomBound z a b
        + 2 * ‖z‖ * Mab z a b * ((Real.log b - Real.log a) / (4 * Real.pi ^ 2)) := by
  have hpi : (0 : ℝ) < Real.pi := Real.pi_pos
  have hMab0 : (0 : ℝ) < Mab z a b := by
    unfold Mab
    exact lt_of_lt_of_le (Real.exp_pos _) (le_max_left _ _)
  have hM0 : (0 : ℝ) ≤ 2 * ‖z‖ * Mab z a b :=
    mul_nonneg (mul_nonneg (by norm_num) (norm_nonneg z)) hMab0.le
  have hsplit : ∑ m ∈ Finset.Ico a b, Complex.exp (z * (u m : ℂ))
      = (∑ m ∈ Finset.Ico a b, Complex.exp (z * ((m : ℂ) + 1 / 2) / (Real.pi : ℂ) ^ 2))
        + ∑ m ∈ Finset.Ico a b, (Complex.exp (z * (u m : ℂ))
            - Complex.exp (z * ((m : ℂ) + 1 / 2) / (Real.pi : ℂ) ^ 2)) := by
    rw [← Finset.sum_add_distrib]
    exact Finset.sum_congr rfl fun m _ => by ring
  rw [hsplit]
  refine le_trans (norm_add_le _ _) ?_
  have h2 : ‖∑ m ∈ Finset.Ico a b, (Complex.exp (z * (u m : ℂ))
        - Complex.exp (z * ((m : ℂ) + 1 / 2) / (Real.pi : ℂ) ^ 2))‖
      ≤ 2 * ‖z‖ * Mab z a b * ((Real.log b - Real.log a) / (4 * Real.pi ^ 2)) := by
    refine le_trans (norm_sum_le _ _) ?_
    have hterm : ∀ m ∈ Finset.Ico a b, ‖Complex.exp (z * (u m : ℂ))
          - Complex.exp (z * ((m : ℂ) + 1 / 2) / (Real.pi : ℂ) ^ 2)‖
        ≤ 2 * ‖z‖ * Mab z a b * (1 / (Real.pi ^ 2 * (4 * (m : ℝ) + 6))) := by
      intro m hm
      rw [Finset.mem_Ico] at hm
      refine le_trans (norm_corr_le hz hu hm.1) ?_
      have hMax := exp_lin_le_Mab (z := z) (a := a) (b := b) hm.1 (le_of_lt hm.2)
      calc Real.exp (z.re * ((m : ℝ) + 1 / 2) / Real.pi ^ 2) * (2 * ‖z‖)
            * (u m - ((m : ℝ) + 1 / 2) / Real.pi ^ 2)
          ≤ Mab z a b * (2 * ‖z‖) * (1 / (Real.pi ^ 2 * (4 * (m : ℝ) + 6))) := by
            refine mul_le_mul ?_ (hu m).2 (hu m).1 (by positivity)
            exact mul_le_mul_of_nonneg_right hMax (by positivity)
        _ = 2 * ‖z‖ * Mab z a b * (1 / (Real.pi ^ 2 * (4 * (m : ℝ) + 6))) := by ring
    calc ∑ m ∈ Finset.Ico a b, ‖Complex.exp (z * (u m : ℂ))
            - Complex.exp (z * ((m : ℂ) + 1 / 2) / (Real.pi : ℂ) ^ 2)‖
        ≤ ∑ m ∈ Finset.Ico a b,
            2 * ‖z‖ * Mab z a b * (1 / (Real.pi ^ 2 * (4 * (m : ℝ) + 6))) :=
          Finset.sum_le_sum hterm
      _ = 2 * ‖z‖ * Mab z a b
            * ∑ m ∈ Finset.Ico a b, 1 / (Real.pi ^ 2 * (4 * (m : ℝ) + 6)) := by
          rw [Finset.mul_sum]
      _ ≤ 2 * ‖z‖ * Mab z a b * ((Real.log b - Real.log a) / (4 * Real.pi ^ 2)) :=
          mul_le_mul_of_nonneg_left (harmonic_quarter ha hab) hM0
  linarith [norm_geom_le hz1 hz2 (z := z) (a := a) (b := b) hab]

end

/-- info: 'WeilPowerGeom.norm_one_sub_exp_ge' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms norm_one_sub_exp_ge

/-- info: 'WeilPowerGeom.norm_geom_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms norm_geom_le

/-- info: 'WeilPowerGeom.log_telescope' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms log_telescope

/-- info: 'WeilPowerGeom.norm_sum_exp_u_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms norm_sum_exp_u_le

end WeilPowerGeom
