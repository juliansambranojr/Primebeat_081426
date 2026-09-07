/-
WeilPowerGeomGen — the geometric bound with a free slope, and `u` at
general `λ`. Rung 5, fifteenth slice; worksheet § 13 block 13e. 2026-09-06.

Blocks 13c–13d were stated at `λ = 1`: `m + 1 = h`, slope `1/π²`,
intercept `½/π²`, correction scale `1/(4π²)`. The shell needs `λ` free.
Unit 0347's quartic phase error is `q = ‖w‖⁴/(π⁴(m+1)³) = |ζ|⁴h/(π⁴λ³)` at
`m + 1 = λh`, and the assembly needs `4q·Σ_i (|ζ_i|²/ε²)·e^{K'} < ½` at the
top of the range, so `λ³ ≥ 4N e^{K'} |ζ|⁴H/(π⁴ε²)`: `λ` grows with the
range and is polynomial in `N`, `e^{K'}` and `1/ε`. With `m + 1 = λh` the
exponent is `z·h²σ(λh−1) = z·uLam λ h` and

  `uLam λ h = u(λh−1)/λ² = h/(λπ²) − 1/(2λ²π²) + r'`,

so the sum over `h` is geometric with ratio `exp(z/(λπ²))`. This module is
13d with the slope `α`, the intercept `β₀` and the correction scale `c`
free (LOOP.md § 3, parameterize downstream), plus the bracket for `uLam`.

At `α = 1/(λπ²)` the geometric bound is 13d's times `λ`: the phase advances
`λ` times slower per step, and that factor is the price of the slower
phase, polynomial in the range. No factor is lost.

Defs.
  MabGen z α β₀ a b        max (exp(z.re(αa+β₀))) (exp(z.re(αb+β₀)))
  geomBoundGen z α β₀ a b  (exp(z.re(αa+β₀)) + exp(z.re(αb+β₀)))·π
                             / (2·exp(z.re·α)·z.im·α)
  uLam λ h                 (h:ℝ)²·WeilPowerPhase.sigma (λh − 1)

Theorems, with the regime the block names:
  G1 `0 < α`;  G2 `0 < z.im`;  G3 `z.im·α ≤ π/2`;  G4 `1 ≤ a`;  G5 `a ≤ b`;
  G6 `‖z‖·c ≤ (a:ℝ)+1`;  G7 `∀ h, 0 ≤ u h − (αh+β₀) ≤ c/((h:ℝ)+1)`;
  L1 `1 ≤ λ`;  L2 `1 ≤ h`.

  exp_shift_gen        none          exp(z(αh+β₀)) = exp(zβ₀)·exp(zα)^h
  sin_im_ge_gen        G1, G2, G3    2(z.im·α)/π ≤ sin(z.im·α)
  rho_ne_one_gen       G1, G2, G3    exp(z·α) ≠ 1
  norm_geom_le_gen     G1, G2, G3,   ‖Σ_{Ico a b} exp(z(αh+β₀))‖
                       G5              ≤ geomBoundGen z α β₀ a b
  exp_lin_le_MabGen    G1, a ≤ h,    exp(z.re(αh+β₀)) ≤ MabGen z α β₀ a b
                       h ≤ b
  norm_corr_le_gen     G6, G7,       ‖exp(z·u h) − exp(z(αh+β₀))‖
                       a ≤ h           ≤ exp(z.re(αh+β₀))·2‖z‖·c/((h:ℝ)+1)
  norm_sum_exp_u_le_gen  G1–G7       ‖Σ_{Ico a b} exp(z·u h)‖
                                       ≤ geomBoundGen z α β₀ a b
                                         + 2‖z‖·c·MabGen z α β₀ a b·(log b − log a)
  uLam_eq              L1, L2        uLam λ h = WeilPowerSigma.u (λh−1)/(λ:ℝ)²
  uLam_bracket         L1, L2        0 ≤ uLam λ h − (h/(λπ²) − 1/(2λ²π²))
                                       ≤ (1/(2λ³π²))/((h:ℝ)+1)

The block lists `sin_im_ge_gen` under G2 and G3 alone; the proof also needs
G1, since `0 ≤ z.im·α` is Jordan's left endpoint and `z.im > 0` does not
give it without `α > 0`. G1 is in the block's regime, so the statement
takes it there and nothing outside the block is assumed.

`c ≥ 0` is not a hypothesis: G7 at `h = 0` reads `0 ≤ c/1`. That is what
makes the correction sum's coefficient `2‖z‖·c·MabGen` nonnegative, which
`Finset.sum_le_sum` needs.

`u` enters as an abstract sequence with G7 as its hypothesis, exactly as in
unit 0349; `uLam_bracket` is G7 at `α = 1/(λπ²)`, `β₀ = −1/(2λ²π²)`,
`c = 1/(2λ³π²)`, and its last step is `λ²π²(4λh+2) ≥ 2λ³π²(h+1)`, i.e.
`λh + 1 ≥ λ`, which L2 gives.

What the next slice needs: block 13f, which reads `z = 2(ζ² − ε²)`,
`α = 1/(λπ²)`, `c = 1/(2λ³π²)`, `u = uLam λ` at one shell member and bounds
`|Σ_h Re((ζ²/ε²)·exp(z·uLam λ h))|` by explicit constants in
`ε, ε', Δ, η, K', λ, a, b`.

Axioms: every theorem pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.WeilPowerGeom
import Stage3.WeilPowerSigma

namespace WeilPowerGeomGen

noncomputable section

open Real Filter Topology

/-- The larger endpoint value of the geometric factor at a free slope. -/
def MabGen (z : ℂ) (α β₀ : ℝ) (a b : ℕ) : ℝ :=
  max (Real.exp (z.re * (α * (a : ℝ) + β₀))) (Real.exp (z.re * (α * (b : ℝ) + β₀)))

/-- The geometric sum's bound at a free slope: the two endpoint values over the
separation of `ρ = exp(zα)` from `1`, which Jordan's inequality makes
`2 z.im α/π` times `exp(z.re α)`. It does not grow with `b − a`, and it grows
like `1/α` as the slope falls. -/
def geomBoundGen (z : ℂ) (α β₀ : ℝ) (a b : ℕ) : ℝ :=
  (Real.exp (z.re * (α * (a : ℝ) + β₀)) + Real.exp (z.re * (α * (b : ℝ) + β₀))) * Real.pi
    / (2 * Real.exp (z.re * α) * z.im * α)

/-- The normalized tail sum at general `λ`: `uLam λ h = h²·σ(λh − 1)`, which is
`u(λh − 1)/λ²` whenever `1 ≤ λh`. -/
def uLam (lam h : ℕ) : ℝ := ((h : ℝ)) ^ 2 * WeilPowerPhase.sigma (lam * h - 1)

/-- **The geometric factorization** of the affine exponential. -/
theorem exp_shift_gen (z : ℂ) (α β₀ : ℝ) (h : ℕ) :
    Complex.exp (z * ((α * (h : ℝ) + β₀ : ℝ) : ℂ))
      = Complex.exp (z * ((β₀ : ℝ) : ℂ)) * Complex.exp (z * ((α : ℝ) : ℂ)) ^ h := by
  rw [← Complex.exp_nat_mul, ← Complex.exp_add]
  congr 1
  push_cast
  ring

/-- **Jordan's inequality at the phase** `z.im·α`, linear in `z.im·α`. -/
theorem sin_im_ge_gen {z : ℂ} {α : ℝ} (hα : 0 < α) (hz1 : 0 < z.im)
    (hz3 : z.im * α ≤ Real.pi / 2) :
    2 * (z.im * α) / Real.pi ≤ Real.sin (z.im * α) := by
  have hpi : (0 : ℝ) < Real.pi := Real.pi_pos
  have hx0 : (0 : ℝ) ≤ z.im * α := by positivity
  have hs := Real.mul_le_sin hx0 hz3
  have e : 2 / Real.pi * (z.im * α) = 2 * (z.im * α) / Real.pi := by
    field_simp
  linarith [e ▸ hs]

/-- The ratio `ρ = exp(zα)` is not `1`: its distance to `1` is at least
`exp(z.re α)·2 z.im α/π > 0`. -/
theorem rho_ne_one_gen {z : ℂ} {α : ℝ} (hα : 0 < α) (hz1 : 0 < z.im)
    (hz3 : z.im * α ≤ Real.pi / 2) :
    Complex.exp (z * ((α : ℝ) : ℂ)) ≠ 1 := by
  have hpi : (0 : ℝ) < Real.pi := Real.pi_pos
  have hre : (z * ((α : ℝ) : ℂ)).re = z.re * α := by simp [Complex.mul_re]
  have him : (z * ((α : ℝ) : ℂ)).im = z.im * α := by simp [Complex.mul_im]
  have h1 := WeilPowerGeom.norm_one_sub_exp_ge (z * ((α : ℝ) : ℂ))
  rw [hre, him] at h1
  have h2 : 2 * (z.im * α) / Real.pi ≤ |Real.sin (z.im * α)| :=
    le_trans (sin_im_ge_gen hα hz1 hz3) (le_abs_self _)
  have h3 : (0 : ℝ) < Real.exp (z.re * α) * (2 * (z.im * α) / Real.pi) :=
    mul_pos (Real.exp_pos _) (by positivity)
  have h4 : (0 : ℝ) < ‖1 - Complex.exp (z * ((α : ℝ) : ℂ))‖ := by
    refine lt_of_lt_of_le h3 (le_trans ?_ h1)
    exact mul_le_mul_of_nonneg_left h2 (Real.exp_pos _).le
  intro hcon
  rw [hcon, sub_self, norm_zero] at h4
  exact lt_irrefl 0 h4

/-- **The geometric sum at a free slope is bounded independently of the range
length.** -/
theorem norm_geom_le_gen {z : ℂ} {α β₀ : ℝ} (hα : 0 < α) (hz1 : 0 < z.im)
    (hz3 : z.im * α ≤ Real.pi / 2) {a b : ℕ} (hab : a ≤ b) :
    ‖∑ h ∈ Finset.Ico a b, Complex.exp (z * ((α * (h : ℝ) + β₀ : ℝ) : ℂ))‖
      ≤ geomBoundGen z α β₀ a b := by
  have hpi : (0 : ℝ) < Real.pi := Real.pi_pos
  have hre : (z * ((α : ℝ) : ℂ)).re = z.re * α := by simp [Complex.mul_re]
  have him : (z * ((α : ℝ) : ℂ)).im = z.im * α := by simp [Complex.mul_im]
  have hre2 : (z * ((β₀ : ℝ) : ℂ)).re = z.re * β₀ := by simp [Complex.mul_re]
  have hlow : Real.exp (z.re * α) * (2 * (z.im * α) / Real.pi)
      ≤ ‖1 - Complex.exp (z * ((α : ℝ) : ℂ))‖ := by
    have h1 := WeilPowerGeom.norm_one_sub_exp_ge (z * ((α : ℝ) : ℂ))
    rw [hre, him] at h1
    have h2 : 2 * (z.im * α) / Real.pi ≤ |Real.sin (z.im * α)| :=
      le_trans (sin_im_ge_gen hα hz1 hz3) (le_abs_self _)
    exact le_trans (mul_le_mul_of_nonneg_left h2 (Real.exp_pos _).le) h1
  have hlow0 : (0 : ℝ) < Real.exp (z.re * α) * (2 * (z.im * α) / Real.pi) :=
    mul_pos (Real.exp_pos _) (by positivity)
  have hD : (0 : ℝ) < ‖Complex.exp (z * ((α : ℝ) : ℂ)) - 1‖ := by
    rw [norm_sub_rev]
    exact lt_of_lt_of_le hlow0 hlow
  have hsum : ∑ h ∈ Finset.Ico a b, Complex.exp (z * ((α * (h : ℝ) + β₀ : ℝ) : ℂ))
      = Complex.exp (z * ((β₀ : ℝ) : ℂ))
        * ((Complex.exp (z * ((α : ℝ) : ℂ)) ^ b - Complex.exp (z * ((α : ℝ) : ℂ)) ^ a)
            / (Complex.exp (z * ((α : ℝ) : ℂ)) - 1)) := by
    rw [← WeilPowerGeom.geom_Ico (rho_ne_one_gen hα hz1 hz3) hab, Finset.mul_sum]
    exact Finset.sum_congr rfl fun h _ => exp_shift_gen z α β₀ h
  rw [hsum, norm_mul, norm_div, Complex.norm_exp, hre2, ← mul_div_assoc, div_le_iff₀ hD]
  have hE : ∀ n : ℕ, Real.exp (z.re * β₀) * Real.exp (z.re * α) ^ n
      = Real.exp (z.re * (α * (n : ℝ) + β₀)) := by
    intro n
    rw [← Real.exp_nat_mul, ← Real.exp_add]
    congr 1
    ring
  have hnormrho : ‖Complex.exp (z * ((α : ℝ) : ℂ))‖ = Real.exp (z.re * α) := by
    rw [Complex.norm_exp, hre]
  have hnum : Real.exp (z.re * β₀)
        * ‖Complex.exp (z * ((α : ℝ) : ℂ)) ^ b - Complex.exp (z * ((α : ℝ) : ℂ)) ^ a‖
      ≤ Real.exp (z.re * (α * (a : ℝ) + β₀)) + Real.exp (z.re * (α * (b : ℝ) + β₀)) := by
    have h1 : ‖Complex.exp (z * ((α : ℝ) : ℂ)) ^ b - Complex.exp (z * ((α : ℝ) : ℂ)) ^ a‖
        ≤ Real.exp (z.re * α) ^ b + Real.exp (z.re * α) ^ a := by
      calc ‖Complex.exp (z * ((α : ℝ) : ℂ)) ^ b - Complex.exp (z * ((α : ℝ) : ℂ)) ^ a‖
          ≤ ‖Complex.exp (z * ((α : ℝ) : ℂ)) ^ b‖
            + ‖Complex.exp (z * ((α : ℝ) : ℂ)) ^ a‖ := norm_sub_le _ _
        _ = Real.exp (z.re * α) ^ b + Real.exp (z.re * α) ^ a := by
            rw [norm_pow, norm_pow, hnormrho]
    calc Real.exp (z.re * β₀)
          * ‖Complex.exp (z * ((α : ℝ) : ℂ)) ^ b - Complex.exp (z * ((α : ℝ) : ℂ)) ^ a‖
        ≤ Real.exp (z.re * β₀) * (Real.exp (z.re * α) ^ b + Real.exp (z.re * α) ^ a) :=
          mul_le_mul_of_nonneg_left h1 (Real.exp_pos _).le
      _ = Real.exp (z.re * (α * (a : ℝ) + β₀)) + Real.exp (z.re * (α * (b : ℝ) + β₀)) := by
          rw [mul_add, hE b, hE a]
          ring
  have hgb0 : 0 ≤ geomBoundGen z α β₀ a b := by
    unfold geomBoundGen
    refine div_nonneg (by positivity) ?_
    exact mul_nonneg (mul_nonneg (mul_nonneg (by norm_num) (Real.exp_pos _).le) hz1.le) hα.le
  have hprod : geomBoundGen z α β₀ a b * (Real.exp (z.re * α) * (2 * (z.im * α) / Real.pi))
      = Real.exp (z.re * (α * (a : ℝ) + β₀)) + Real.exp (z.re * (α * (b : ℝ) + β₀)) := by
    unfold geomBoundGen
    have he : Real.exp (z.re * α) ≠ 0 := (Real.exp_pos _).ne'
    have hi : z.im ≠ 0 := ne_of_gt hz1
    have ha' : α ≠ 0 := ne_of_gt hα
    have hp : Real.pi ≠ 0 := Real.pi_ne_zero
    field_simp
    try ring
  calc Real.exp (z.re * β₀)
        * ‖Complex.exp (z * ((α : ℝ) : ℂ)) ^ b - Complex.exp (z * ((α : ℝ) : ℂ)) ^ a‖
      ≤ Real.exp (z.re * (α * (a : ℝ) + β₀)) + Real.exp (z.re * (α * (b : ℝ) + β₀)) := hnum
    _ = geomBoundGen z α β₀ a b * (Real.exp (z.re * α) * (2 * (z.im * α) / Real.pi)) := hprod.symm
    _ ≤ geomBoundGen z α β₀ a b * ‖Complex.exp (z * ((α : ℝ) : ℂ)) - 1‖ := by
        refine mul_le_mul_of_nonneg_left ?_ hgb0
        rw [norm_sub_rev]
        exact hlow

/-- The geometric factor at an interior `h` is at most its value at an endpoint:
the exponent is affine and increasing in `h`, so the sign of `z.re` picks the
end. -/
theorem exp_lin_le_MabGen {z : ℂ} {α β₀ : ℝ} (hα : 0 < α) {a b h : ℕ}
    (hah : a ≤ h) (hhb : h ≤ b) :
    Real.exp (z.re * (α * (h : ℝ) + β₀)) ≤ MabGen z α β₀ a b := by
  have hha : ((a : ℝ)) ≤ (h : ℝ) := by exact_mod_cast hah
  have hhb' : ((h : ℝ)) ≤ (b : ℝ) := by exact_mod_cast hhb
  unfold MabGen
  rcases le_or_gt 0 z.re with hz | hz
  · refine le_trans (Real.exp_le_exp.mpr ?_) (le_max_right _ _)
    nlinarith [mul_nonneg (mul_nonneg hz hα.le) (sub_nonneg.mpr hhb')]
  · refine le_trans (Real.exp_le_exp.mpr ?_) (le_max_left _ _)
    nlinarith [mul_nonneg (mul_nonneg (neg_nonneg.mpr hz.le) hα.le) (sub_nonneg.mpr hha)]

/-- **One term's correction** at a free scale, `2‖z‖·c/(h+1)` times the
geometric factor. -/
theorem norm_corr_le_gen {z : ℂ} {α β₀ c : ℝ} {u : ℕ → ℝ} {a h : ℕ}
    (hzc : ‖z‖ * c ≤ (a : ℝ) + 1)
    (hu : ∀ k : ℕ, 0 ≤ u k - (α * (k : ℝ) + β₀)
      ∧ u k - (α * (k : ℝ) + β₀) ≤ c / ((k : ℝ) + 1))
    (hah : a ≤ h) :
    ‖Complex.exp (z * (u h : ℂ)) - Complex.exp (z * ((α * (h : ℝ) + β₀ : ℝ) : ℂ))‖
      ≤ Real.exp (z.re * (α * (h : ℝ) + β₀)) * (2 * ‖z‖) * (c / ((h : ℝ) + 1)) := by
  have hr0 := (hu h).1
  have hr1 := (hu h).2
  have hha : ((a : ℝ)) ≤ (h : ℝ) := by exact_mod_cast hah
  have hh1 : (0 : ℝ) < (h : ℝ) + 1 := by positivity
  have hreM : (z * ((α * (h : ℝ) + β₀ : ℝ) : ℂ)).re = z.re * (α * (h : ℝ) + β₀) := by
    simp [Complex.mul_re]
  have hzr : ‖z * ((u h - (α * (h : ℝ) + β₀) : ℝ) : ℂ)‖ = ‖z‖ * (u h - (α * (h : ℝ) + β₀)) := by
    rw [norm_mul, Complex.norm_real, Real.norm_eq_abs, abs_of_nonneg hr0]
  have hle1 : ‖z * ((u h - (α * (h : ℝ) + β₀) : ℝ) : ℂ)‖ ≤ 1 := by
    rw [hzr]
    have h1 : ‖z‖ * (u h - (α * (h : ℝ) + β₀)) ≤ ‖z‖ * (c / ((h : ℝ) + 1)) :=
      mul_le_mul_of_nonneg_left hr1 (norm_nonneg z)
    have h2 : ‖z‖ * (c / ((h : ℝ) + 1)) = (‖z‖ * c) / ((h : ℝ) + 1) := by ring
    have h3 : (‖z‖ * c) / ((h : ℝ) + 1) ≤ 1 := by
      rw [div_le_one hh1]
      linarith
    linarith [h2 ▸ h1]
  have hcast : ((u h : ℝ) : ℂ) = ((α * (h : ℝ) + β₀ : ℝ) : ℂ)
      + ((u h - (α * (h : ℝ) + β₀) : ℝ) : ℂ) := by
    push_cast
    ring
  have hsplit : Complex.exp (z * (u h : ℂ)) - Complex.exp (z * ((α * (h : ℝ) + β₀ : ℝ) : ℂ))
      = Complex.exp (z * ((α * (h : ℝ) + β₀ : ℝ) : ℂ))
        * (Complex.exp (z * ((u h - (α * (h : ℝ) + β₀) : ℝ) : ℂ)) - 1) := by
    rw [hcast, mul_add, Complex.exp_add]
    ring
  rw [hsplit, norm_mul, Complex.norm_exp, hreM]
  have hb := Complex.norm_exp_sub_one_le hle1
  rw [hzr] at hb
  calc Real.exp (z.re * (α * (h : ℝ) + β₀))
        * ‖Complex.exp (z * ((u h - (α * (h : ℝ) + β₀) : ℝ) : ℂ)) - 1‖
      ≤ Real.exp (z.re * (α * (h : ℝ) + β₀)) * (2 * (‖z‖ * (u h - (α * (h : ℝ) + β₀)))) :=
        mul_le_mul_of_nonneg_left hb (Real.exp_pos _).le
    _ ≤ Real.exp (z.re * (α * (h : ℝ) + β₀)) * (2 * (‖z‖ * (c / ((h : ℝ) + 1)))) := by
        refine mul_le_mul_of_nonneg_left ?_ (Real.exp_pos _).le
        have := mul_le_mul_of_nonneg_left hr1 (norm_nonneg z)
        linarith
    _ = Real.exp (z.re * (α * (h : ℝ) + β₀)) * (2 * ‖z‖) * (c / ((h : ℝ) + 1)) := by ring

/-- **The averaged sum at a free slope**: bounded by the range-free geometric
bound plus a logarithm of the range. -/
theorem norm_sum_exp_u_le_gen {z : ℂ} {α β₀ c : ℝ} {u : ℕ → ℝ} {a b : ℕ}
    (hα : 0 < α) (hz1 : 0 < z.im) (hz3 : z.im * α ≤ Real.pi / 2)
    (ha : 1 ≤ a) (hab : a ≤ b) (hzc : ‖z‖ * c ≤ (a : ℝ) + 1)
    (hu : ∀ k : ℕ, 0 ≤ u k - (α * (k : ℝ) + β₀)
      ∧ u k - (α * (k : ℝ) + β₀) ≤ c / ((k : ℝ) + 1)) :
    ‖∑ h ∈ Finset.Ico a b, Complex.exp (z * (u h : ℂ))‖
      ≤ geomBoundGen z α β₀ a b
        + 2 * ‖z‖ * c * MabGen z α β₀ a b * (Real.log b - Real.log a) := by
  have hc0 : (0 : ℝ) ≤ c := by
    have h0 := le_trans (hu 0).1 (hu 0).2
    simpa using h0
  have hMab0 : (0 : ℝ) < MabGen z α β₀ a b := by
    unfold MabGen
    exact lt_of_lt_of_le (Real.exp_pos _) (le_max_left _ _)
  have hM0 : (0 : ℝ) ≤ 2 * ‖z‖ * c * MabGen z α β₀ a b :=
    mul_nonneg (mul_nonneg (mul_nonneg (by norm_num) (norm_nonneg z)) hc0) hMab0.le
  have hsplit : ∑ h ∈ Finset.Ico a b, Complex.exp (z * (u h : ℂ))
      = (∑ h ∈ Finset.Ico a b, Complex.exp (z * ((α * (h : ℝ) + β₀ : ℝ) : ℂ)))
        + ∑ h ∈ Finset.Ico a b, (Complex.exp (z * (u h : ℂ))
            - Complex.exp (z * ((α * (h : ℝ) + β₀ : ℝ) : ℂ))) := by
    rw [← Finset.sum_add_distrib]
    exact Finset.sum_congr rfl fun h _ => by ring
  rw [hsplit]
  refine le_trans (norm_add_le _ _) ?_
  have h2 : ‖∑ h ∈ Finset.Ico a b, (Complex.exp (z * (u h : ℂ))
        - Complex.exp (z * ((α * (h : ℝ) + β₀ : ℝ) : ℂ)))‖
      ≤ 2 * ‖z‖ * c * MabGen z α β₀ a b * (Real.log b - Real.log a) := by
    refine le_trans (norm_sum_le _ _) ?_
    have hterm : ∀ h ∈ Finset.Ico a b, ‖Complex.exp (z * (u h : ℂ))
          - Complex.exp (z * ((α * (h : ℝ) + β₀ : ℝ) : ℂ))‖
        ≤ 2 * ‖z‖ * c * MabGen z α β₀ a b * (1 / ((h : ℝ) + 1)) := by
      intro h hh
      rw [Finset.mem_Ico] at hh
      refine le_trans (norm_corr_le_gen hzc hu hh.1) ?_
      have hMax := exp_lin_le_MabGen (z := z) (β₀ := β₀) (a := a) (b := b) hα hh.1
        (le_of_lt hh.2)
      have hcn : (0 : ℝ) ≤ c / ((h : ℝ) + 1) := by positivity
      calc Real.exp (z.re * (α * (h : ℝ) + β₀)) * (2 * ‖z‖) * (c / ((h : ℝ) + 1))
          ≤ MabGen z α β₀ a b * (2 * ‖z‖) * (c / ((h : ℝ) + 1)) := by
            refine mul_le_mul_of_nonneg_right ?_ hcn
            exact mul_le_mul_of_nonneg_right hMax (by positivity)
        _ = 2 * ‖z‖ * c * MabGen z α β₀ a b * (1 / ((h : ℝ) + 1)) := by ring
    calc ∑ h ∈ Finset.Ico a b, ‖Complex.exp (z * (u h : ℂ))
            - Complex.exp (z * ((α * (h : ℝ) + β₀ : ℝ) : ℂ))‖
        ≤ ∑ h ∈ Finset.Ico a b,
            2 * ‖z‖ * c * MabGen z α β₀ a b * (1 / ((h : ℝ) + 1)) :=
          Finset.sum_le_sum hterm
      _ = 2 * ‖z‖ * c * MabGen z α β₀ a b
            * ∑ h ∈ Finset.Ico a b, 1 / ((h : ℝ) + 1) := by
          rw [Finset.mul_sum]
      _ ≤ 2 * ‖z‖ * c * MabGen z α β₀ a b * (Real.log b - Real.log a) :=
          mul_le_mul_of_nonneg_left (WeilPowerGeom.log_telescope ha b hab) hM0
  linarith [norm_geom_le_gen (z := z) (α := α) (β₀ := β₀) (a := a) (b := b) hα hz1 hz3 hab]

/-- **`uLam` is `u` rescaled**: `uLam λ h = u(λh − 1)/λ²`, the cast
`((λh − 1 : ℕ) : ℝ) + 1 = λh` being the whole content. -/
theorem uLam_eq {lam h : ℕ} (hl : 1 ≤ lam) (hh : 1 ≤ h) :
    uLam lam h = WeilPowerSigma.u (lam * h - 1) / (lam : ℝ) ^ 2 := by
  have hlh : 0 < lam * h := Nat.mul_pos hl hh
  have hL : (0 : ℝ) < (lam : ℝ) := by exact_mod_cast Nat.lt_of_lt_of_le Nat.zero_lt_one hl
  have hcast : ((lam * h - 1 : ℕ) : ℝ) + 1 = (lam : ℝ) * (h : ℝ) := by
    rw [Nat.cast_pred hlh]
    push_cast
    ring
  rw [WeilPowerSigma.u_def, hcast, uLam]
  field_simp
  try ring

/-- **The bracket for `uLam` at general `λ`**: slope `1/(λπ²)`, intercept
`−1/(2λ²π²)`, correction scale `1/(2λ³π²)`. -/
theorem uLam_bracket {lam h : ℕ} (hl : 1 ≤ lam) (hh : 1 ≤ h) :
    0 ≤ uLam lam h - ((h : ℝ) / ((lam : ℝ) * Real.pi ^ 2)
        - 1 / (2 * (lam : ℝ) ^ 2 * Real.pi ^ 2))
      ∧ uLam lam h - ((h : ℝ) / ((lam : ℝ) * Real.pi ^ 2)
          - 1 / (2 * (lam : ℝ) ^ 2 * Real.pi ^ 2))
        ≤ 1 / (2 * (lam : ℝ) ^ 3 * Real.pi ^ 2) / ((h : ℝ) + 1) := by
  have hpi : (0 : ℝ) < Real.pi := Real.pi_pos
  have hpine : Real.pi ≠ 0 := Real.pi_ne_zero
  have hlh : 0 < lam * h := Nat.mul_pos hl hh
  have hL1 : (1 : ℝ) ≤ (lam : ℝ) := by exact_mod_cast hl
  have hH1 : (1 : ℝ) ≤ (h : ℝ) := by exact_mod_cast hh
  have hL : (0 : ℝ) < (lam : ℝ) := by linarith
  have hLne : (lam : ℝ) ≠ 0 := ne_of_gt hL
  have hm : ((lam * h - 1 : ℕ) : ℝ) = (lam : ℝ) * (h : ℝ) - 1 := by
    rw [Nat.cast_pred hlh]
    push_cast
    ring
  have hp := WeilPowerSigma.r_pos (lam * h - 1)
  have hq := WeilPowerSigma.r_le (lam * h - 1)
  rw [hm] at hp hq
  have hue := uLam_eq hl hh
  -- the shifted target, written on the numerator
  have hkey : uLam lam h - ((h : ℝ) / ((lam : ℝ) * Real.pi ^ 2)
        - 1 / (2 * (lam : ℝ) ^ 2 * Real.pi ^ 2))
      = (WeilPowerSigma.u (lam * h - 1)
          - ((lam : ℝ) * (h : ℝ) - 1 + 1 / 2) / Real.pi ^ 2) / (lam : ℝ) ^ 2 := by
    rw [hue]
    field_simp
    ring
  rw [hkey]
  constructor
  · have h0 : (0 : ℝ) ≤ 1 / (2 * Real.pi ^ 2 * ((lam : ℝ) * (h : ℝ) - 1 + 2) ^ 2) := by
      have : (0 : ℝ) < (lam : ℝ) * (h : ℝ) - 1 + 2 := by nlinarith
      positivity
    have hnum : (0 : ℝ) ≤ WeilPowerSigma.u (lam * h - 1)
        - ((lam : ℝ) * (h : ℝ) - 1 + 1 / 2) / Real.pi ^ 2 := le_trans h0 hp
    positivity
  · -- the numerator's upper bound, divided by λ²
    have hden : (0 : ℝ) < Real.pi ^ 2 * (4 * ((lam : ℝ) * (h : ℝ) - 1) + 6) := by nlinarith
    have hstep : (WeilPowerSigma.u (lam * h - 1)
          - ((lam : ℝ) * (h : ℝ) - 1 + 1 / 2) / Real.pi ^ 2) / (lam : ℝ) ^ 2
        ≤ (1 / (Real.pi ^ 2 * (4 * ((lam : ℝ) * (h : ℝ) - 1) + 6))) / (lam : ℝ) ^ 2 := by
      apply div_le_div_of_nonneg_right hq (by positivity)
    refine le_trans hstep ?_
    -- both sides are reciprocals; compare the denominators
    have hD1 : (1 / (Real.pi ^ 2 * (4 * ((lam : ℝ) * (h : ℝ) - 1) + 6))) / (lam : ℝ) ^ 2
        = 1 / (Real.pi ^ 2 * (4 * ((lam : ℝ) * (h : ℝ) - 1) + 6) * (lam : ℝ) ^ 2) := by
      rw [div_div]
    have hD2 : 1 / (2 * (lam : ℝ) ^ 3 * Real.pi ^ 2) / ((h : ℝ) + 1)
        = 1 / (2 * (lam : ℝ) ^ 3 * Real.pi ^ 2 * ((h : ℝ) + 1)) := by
      rw [div_div]
    rw [hD1, hD2]
    have hgap : (0 : ℝ) ≤ (lam : ℝ) * (h : ℝ) + 1 - (lam : ℝ) := by nlinarith
    have hid : Real.pi ^ 2 * (4 * ((lam : ℝ) * (h : ℝ) - 1) + 6) * (lam : ℝ) ^ 2
        - 2 * (lam : ℝ) ^ 3 * Real.pi ^ 2 * ((h : ℝ) + 1)
        = 2 * Real.pi ^ 2 * (lam : ℝ) ^ 2 * ((lam : ℝ) * (h : ℝ) + 1 - (lam : ℝ)) := by
      ring
    have hpos2 : (0 : ℝ) < 2 * (lam : ℝ) ^ 3 * Real.pi ^ 2 * ((h : ℝ) + 1) := by positivity
    have hle : 2 * (lam : ℝ) ^ 3 * Real.pi ^ 2 * ((h : ℝ) + 1)
        ≤ Real.pi ^ 2 * (4 * ((lam : ℝ) * (h : ℝ) - 1) + 6) * (lam : ℝ) ^ 2 := by
      nlinarith [mul_nonneg (mul_nonneg (mul_nonneg (by norm_num : (0:ℝ) ≤ 2)
        (sq_nonneg Real.pi)) (sq_nonneg ((lam : ℝ)))) hgap]
    exact one_div_le_one_div_of_le hpos2 hle

end

/-- info: 'WeilPowerGeomGen.norm_geom_le_gen' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms norm_geom_le_gen

/-- info: 'WeilPowerGeomGen.norm_corr_le_gen' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms norm_corr_le_gen

/-- info: 'WeilPowerGeomGen.norm_sum_exp_u_le_gen' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms norm_sum_exp_u_le_gen

/-- info: 'WeilPowerGeomGen.uLam_bracket' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms uLam_bracket

end WeilPowerGeomGen
