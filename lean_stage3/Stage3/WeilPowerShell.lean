/-
WeilPowerShell — one shell member's weighted sum, explicit. Rung 5,
sixteenth slice; worksheet § 13 block 13f. 2026-09-06.

The member sits at `ζ = ε' + iΔ`, the target at `ε`, the window at
`m + 1 = λh`. Unit 0347's `re_S_sq_ge`, divided by the target's
`c²ε²h²e^{2ε²h²σ}`, leaves the weighted principal term
`coef · exp(z · uLam λ h)` with `coef = ζ²/ε²` and `z = 2(ζ² − ε²)`,
since `h²σ(λh − 1) = uLam λ h` (unit 0350). Block 13e's bound applies at
`α = 1/(λπ²)`, `β₀ = −1/(2λ²π²)`, `c = 1/(2λ³π²)`, `u = uLam λ`, except
that its G7 quantifies over every `k`, including `0`, where
`uLam λ 0 = 0` and the bracket fails for `λ ≥ 2`. The sum runs over
`h ≥ a ≥ 1`, so `u` is patched at `0` to the affine value (`uSh`) and the
two sums agree termwise.

Sizes. With `ε', Δ, ε ≤ 1/2`: `‖z‖ ≤ 3/2`, the endpoint factor is at most
`M := e^{2ηb/(λπ²)}`, the geometric part at most
`M·λπ³·e^{2‖z‖α}/(4ε'Δ)` and the correction at most
`2(ε'²+Δ²+ε²)·M·(log b − log a)/(λ³π²)`, both times `(ε'²+Δ²)/ε²`.
No factor is lost in `h` or in `b`; the `1/Δ` is the geometric price, and
the shell below `Δ ≈ λ/(εX)`, where this bound is useless, is unit 0351's
finding and is handled there by the tight count.

Regime, as the block names it:
  R1 `0 < ε'`;  R2 `ε' ≤ 1/2`;  R3 `0 < Δ`;  R4 `Δ ≤ 1/2`;  R5 `0 < ε`;
  R6 `ε ≤ 1/2`;  R7 `ε'² − Δ² − ε² ≤ η`;  R8 `0 ≤ η`;  L1 `1 ≤ λ` (ℕ);
  G4 `1 ≤ a` (ℕ);  G5 `a ≤ b` (ℕ).

Defs.
  zOf ε' Δ ε        2((ε' + iΔ)² − ε²)
  coef ε' Δ ε       (ε' + iΔ)²/ε²
  uSh λ k           −1/(2λ²π²) at k = 0, else uLam λ k
  shellSum ε' Δ ε λ a b   Σ_{h ∈ Ico a b} Re(coef · exp(zOf · uLam λ h))

Theorems, with the hypotheses the block lists:
  zOf_re          none                  (zOf).re = 2(ε'² − Δ² − ε²)
  zOf_im          none                  (zOf).im = 4ε'Δ
  norm_zOf_le     none                  ‖zOf‖ ≤ 2(ε'² + Δ² + ε²)
  norm_coef       none                  ‖coef‖ = (ε'² + Δ²)/ε²
  uSh_bracket     L1                    the G7 bracket for uSh at every k
  sum_uSh_eq      G4                    the two sums agree termwise
  im_alpha_le     R1–R4, L1             (zOf).im·α ≤ π/2
  norm_zOf_c_le   R1–R6, L1             ‖zOf‖·c ≤ a + 1
  exp_end_le      R7, R8, L1, G4,       exp(z.re(αk + β₀)) ≤ M
                  a ≤ k, k ≤ b
  MabGen_le       R7, R8, L1, G4, G5    MabGen ≤ M
  inv_exp_le      none                  1/exp(z.re·α) ≤ exp(2(ε'²+Δ²+ε²)α)
  geomBound_le    R1, R3, R7, R8, L1,   geomBoundGen ≤ M·λπ³·e^{2‖z‖α}/(4ε'Δ)
                  G4, G5
  shellSum_le     R1–R8, L1, G4, G5     the explicit bound
  shellSum_neg    none                  shellSum is even in Δ
  shellSum_le_abs R1, R2, Δ ≠ 0,        the bound with |Δ| for Δ
                  |Δ| ≤ 1/2, R5–R8,
                  L1, G4, G5

No hypothesis outside the block's lists is needed: every proof here closes
on the regime the block names for it. Three readings of the block's shapes
are ASSUMED pins in PINS.md § Current:
  `uSh_bracket` keeps the block's `∀ k` inside the statement, so that it is
  `norm_sum_exp_u_le_gen`'s `hu` after one `ring` step on the affine form;
  `norm_zOf_c_le` takes the block's `∀ a : ℕ` as an explicit argument;
  `shellSum_le_abs` reads "the bound with `|Δ|` in place of `Δ`" as the
  substitution at every occurrence, `|Δ|²` included, which is the same real
  number as substituting only in `4ε'Δ` since `|Δ|² = Δ²`.

What the next slice needs: the sum over the shell's members, which adds
`shellSum_le_abs` over the members at a fixed `Δ`-scale and needs unit
0351's tight count for the members below `Δ ≈ λ/(εX)`.

Axioms: every pinned theorem pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.WeilPowerGeomGen

namespace WeilPowerShell

noncomputable section

open Real

/-- The exponent's coefficient at the shell member `ζ = ε' + iΔ` against the
target at `ε`: `z = 2(ζ² − ε²)`. -/
def zOf (e' D e : ℝ) : ℂ := 2 * (((e' : ℂ) + Complex.I * (D : ℂ)) ^ 2 - (e : ℂ) ^ 2)

/-- The member's weight relative to the target: `ζ²/ε²`. -/
def coef (e' D e : ℝ) : ℂ := ((e' : ℂ) + Complex.I * (D : ℂ)) ^ 2 / (e : ℂ) ^ 2

/-- `uLam` patched at `0` to the affine value, so that the bracket G7 of
block 13e holds at every `k` and not only at `k ≥ 1`. -/
def uSh (lam k : ℕ) : ℝ :=
  if k = 0 then -1 / (2 * (lam : ℝ) ^ 2 * Real.pi ^ 2) else WeilPowerGeomGen.uLam lam k

/-- One shell member's weighted sum over the range `[a, b)`. -/
def shellSum (e' D e : ℝ) (lam a b : ℕ) : ℝ :=
  ∑ h ∈ Finset.Ico a b,
    (coef e' D e * Complex.exp (zOf e' D e * ((WeilPowerGeomGen.uLam lam h : ℝ) : ℂ))).re

/-- The real part of the exponent's coefficient. -/
theorem zOf_re (e' D e : ℝ) : (zOf e' D e).re = 2 * (e' ^ 2 - D ^ 2 - e ^ 2) := by
  simp [zOf, Complex.mul_re, Complex.mul_im, pow_two]

/-- The imaginary part of the exponent's coefficient: the phase's rate. -/
theorem zOf_im (e' D e : ℝ) : (zOf e' D e).im = 4 * e' * D := by
  simp [zOf, Complex.mul_re, Complex.mul_im, pow_two]
  ring

/-- The size of the exponent's coefficient. -/
theorem norm_zOf_le (e' D e : ℝ) : ‖zOf e' D e‖ ≤ 2 * (e' ^ 2 + D ^ 2 + e ^ 2) := by
  have hw : ‖((e' : ℂ) + Complex.I * (D : ℂ)) ^ 2‖ = e' ^ 2 + D ^ 2 := by
    rw [Complex.norm_pow, Complex.sq_norm, Complex.normSq_apply]
    simp [Complex.mul_re, Complex.mul_im]
    ring
  have he : ‖((e : ℂ)) ^ 2‖ = e ^ 2 := by
    rw [Complex.norm_pow, Complex.norm_real, Real.norm_eq_abs, sq_abs]
  have h2 : ‖(2 : ℂ)‖ = 2 := by norm_num
  rw [zOf, norm_mul, h2]
  have hs := norm_sub_le (((e' : ℂ) + Complex.I * (D : ℂ)) ^ 2) (((e : ℂ)) ^ 2)
  rw [hw, he] at hs
  linarith

/-- The member's weight, in size. -/
theorem norm_coef (e' D e : ℝ) : ‖coef e' D e‖ = (e' ^ 2 + D ^ 2) / e ^ 2 := by
  rw [coef, Complex.norm_div, Complex.norm_pow, Complex.norm_pow, Complex.norm_real,
    Real.norm_eq_abs, sq_abs, Complex.sq_norm, Complex.normSq_apply]
  simp [Complex.mul_re, Complex.mul_im]
  ring

/-- **The bracket G7 for the patched sequence**, at every `k` including `0`. -/
theorem uSh_bracket {lam : ℕ} (hl : 1 ≤ lam) :
    ∀ k : ℕ, 0 ≤ uSh lam k - ((k : ℝ) / ((lam : ℝ) * Real.pi ^ 2)
        - 1 / (2 * (lam : ℝ) ^ 2 * Real.pi ^ 2))
      ∧ uSh lam k - ((k : ℝ) / ((lam : ℝ) * Real.pi ^ 2)
          - 1 / (2 * (lam : ℝ) ^ 2 * Real.pi ^ 2))
        ≤ 1 / (2 * (lam : ℝ) ^ 3 * Real.pi ^ 2) / ((k : ℝ) + 1) := by
  intro k
  by_cases hk : k = 0
  · subst hk
    have hzero : uSh lam 0 = -1 / (2 * (lam : ℝ) ^ 2 * Real.pi ^ 2) := by
      rw [uSh, if_pos rfl]
    have hd : -1 / (2 * (lam : ℝ) ^ 2 * Real.pi ^ 2)
        - (((0 : ℕ) : ℝ) / ((lam : ℝ) * Real.pi ^ 2)
            - 1 / (2 * (lam : ℝ) ^ 2 * Real.pi ^ 2)) = 0 := by
      push_cast
      ring
    rw [hzero, hd]
    exact ⟨le_refl 0, by positivity⟩
  · have hk1 : 1 ≤ k := Nat.one_le_iff_ne_zero.mpr hk
    rw [uSh, if_neg hk]
    exact WeilPowerGeomGen.uLam_bracket hl hk1

/-- The patch does not change the sum: over `Ico a b` with `1 ≤ a` no index
is `0`. -/
theorem sum_uSh_eq (e' D e : ℝ) (lam : ℕ) {a b : ℕ} (ha : 1 ≤ a) :
    ∑ h ∈ Finset.Ico a b, coef e' D e
        * Complex.exp (zOf e' D e * ((WeilPowerGeomGen.uLam lam h : ℝ) : ℂ))
      = ∑ h ∈ Finset.Ico a b, coef e' D e
        * Complex.exp (zOf e' D e * ((uSh lam h : ℝ) : ℂ)) := by
  refine Finset.sum_congr rfl fun h hh => ?_
  rw [Finset.mem_Ico] at hh
  have hk : h ≠ 0 := by omega
  rw [uSh, if_neg hk]

/-- **Jordan's hypothesis G3 holds at the shell's phase**: `4ε'Δ ≤ 1` and
`1/(λπ²) ≤ 1/9 < π/2`. -/
theorem im_alpha_le {e' D e : ℝ} {lam : ℕ} (h1 : 0 < e') (h2 : e' ≤ 1 / 2)
    (h3 : 0 < D) (h4 : D ≤ 1 / 2) (hl : 1 ≤ lam) :
    (zOf e' D e).im * (1 / ((lam : ℝ) * Real.pi ^ 2)) ≤ Real.pi / 2 := by
  rw [zOf_im]
  have hpi := Real.pi_gt_three
  have hL1 : (1 : ℝ) ≤ (lam : ℝ) := by exact_mod_cast hl
  have hnum : 4 * e' * D ≤ 1 := by nlinarith
  have hden : 1 / ((lam : ℝ) * Real.pi ^ 2) ≤ 1 / 9 := by
    rw [div_le_div_iff₀ (by nlinarith) (by norm_num)]
    nlinarith
  nlinarith [mul_pos (mul_pos (by norm_num : (0 : ℝ) < 4) h1) h3]

/-- **The hypothesis G6 holds**: `‖z‖ ≤ 3/2` and `c ≤ 1/18`, so the product is
under `1 ≤ a + 1`. -/
theorem norm_zOf_c_le {e' D e : ℝ} {lam : ℕ} (h1 : 0 < e') (h2 : e' ≤ 1 / 2)
    (h3 : 0 < D) (h4 : D ≤ 1 / 2) (h5 : 0 < e) (h6 : e ≤ 1 / 2) (hl : 1 ≤ lam) (a : ℕ) :
    ‖zOf e' D e‖ * (1 / (2 * (lam : ℝ) ^ 3 * Real.pi ^ 2)) ≤ (a : ℝ) + 1 := by
  have hpi0 : (0 : ℝ) < Real.pi := Real.pi_pos
  have hpi := Real.pi_gt_three
  have hL1 : (1 : ℝ) ≤ (lam : ℝ) := by exact_mod_cast hl
  have hL : (0 : ℝ) < (lam : ℝ) := by linarith
  have hden : (0 : ℝ) < 2 * (lam : ℝ) ^ 3 * Real.pi ^ 2 :=
    mul_pos (mul_pos (by norm_num) (pow_pos hL 3)) (pow_pos hpi0 2)
  have hcube : (1 : ℝ) ≤ (lam : ℝ) ^ 3 := one_le_pow₀ hL1
  have hp2 : (9 : ℝ) < Real.pi ^ 2 := by nlinarith
  have hc : 1 / (2 * (lam : ℝ) ^ 3 * Real.pi ^ 2) ≤ 1 / 18 := by
    rw [div_le_div_iff₀ hden (by norm_num)]
    nlinarith [mul_le_mul_of_nonneg_right hcube (pow_pos hpi0 2).le]
  have hnz := norm_zOf_le e' D e
  have hsmall : 2 * (e' ^ 2 + D ^ 2 + e ^ 2) ≤ 3 / 2 := by nlinarith
  have hn0 : (0 : ℝ) ≤ ‖zOf e' D e‖ := norm_nonneg _
  have hc0 : (0 : ℝ) < 1 / (2 * (lam : ℝ) ^ 3 * Real.pi ^ 2) := by positivity
  have ha0 : (0 : ℝ) ≤ (a : ℝ) := Nat.cast_nonneg a
  nlinarith

/-- The geometric factor at an interior index is at most `M = e^{2ηb/(λπ²)}`:
the exponent is nonnegative and at most `αb`, and `z.re ≤ 2η`. -/
theorem exp_end_le {e' D e eta : ℝ} {lam a b k : ℕ} (h7 : e' ^ 2 - D ^ 2 - e ^ 2 ≤ eta)
    (h8 : 0 ≤ eta) (hl : 1 ≤ lam) (ha : 1 ≤ a) (hak : a ≤ k) (hkb : k ≤ b) :
    Real.exp ((zOf e' D e).re * (1 / ((lam : ℝ) * Real.pi ^ 2) * (k : ℝ)
        + -1 / (2 * (lam : ℝ) ^ 2 * Real.pi ^ 2)))
      ≤ Real.exp (2 * eta * (b : ℝ) / ((lam : ℝ) * Real.pi ^ 2)) := by
  have hpi0 : (0 : ℝ) < Real.pi := Real.pi_pos
  have hL1 : (1 : ℝ) ≤ (lam : ℝ) := by exact_mod_cast hl
  have hL : (0 : ℝ) < (lam : ℝ) := by linarith
  have hLne : (lam : ℝ) ≠ 0 := ne_of_gt hL
  have hpine : Real.pi ≠ 0 := Real.pi_ne_zero
  have halpha : (0 : ℝ) < 1 / ((lam : ℝ) * Real.pi ^ 2) := by positivity
  have hk1 : (1 : ℝ) ≤ (k : ℝ) := by exact_mod_cast le_trans ha hak
  have hkb' : ((k : ℝ)) ≤ (b : ℝ) := by exact_mod_cast hkb
  have haffeq : 1 / ((lam : ℝ) * Real.pi ^ 2) * (k : ℝ) + -1 / (2 * (lam : ℝ) ^ 2 * Real.pi ^ 2)
      = (2 * (lam : ℝ) * (k : ℝ) - 1) / (2 * (lam : ℝ) ^ 2 * Real.pi ^ 2) := by
    field_simp
    try ring
  have haff : (0 : ℝ) ≤ 1 / ((lam : ℝ) * Real.pi ^ 2) * (k : ℝ)
      + -1 / (2 * (lam : ℝ) ^ 2 * Real.pi ^ 2) := by
    rw [haffeq]
    apply div_nonneg
    · nlinarith
    · positivity
  have hbeta : -1 / (2 * (lam : ℝ) ^ 2 * Real.pi ^ 2) ≤ 0 := by
    apply div_nonpos_of_nonpos_of_nonneg
    · norm_num
    · positivity
  have hhb : 1 / ((lam : ℝ) * Real.pi ^ 2) * (k : ℝ) + -1 / (2 * (lam : ℝ) ^ 2 * Real.pi ^ 2)
      ≤ 1 / ((lam : ℝ) * Real.pi ^ 2) * (b : ℝ) := by
    nlinarith
  have hrhs : 2 * eta * (b : ℝ) / ((lam : ℝ) * Real.pi ^ 2)
      = 2 * eta * (1 / ((lam : ℝ) * Real.pi ^ 2) * (b : ℝ)) := by
    field_simp
    try ring
  rw [Real.exp_le_exp, zOf_re, hrhs]
  have hzre : 2 * (e' ^ 2 - D ^ 2 - e ^ 2) ≤ 2 * eta := by linarith
  rcases le_or_gt 0 (2 * (e' ^ 2 - D ^ 2 - e ^ 2)) with hz | hz
  · nlinarith
  · nlinarith [mul_nonneg (mul_nonneg h8 halpha.le) (Nat.cast_nonneg (α := ℝ) b)]

/-- **The endpoint factor is at most `M`.** -/
theorem MabGen_le {e' D e eta : ℝ} {lam a b : ℕ} (h7 : e' ^ 2 - D ^ 2 - e ^ 2 ≤ eta)
    (h8 : 0 ≤ eta) (hl : 1 ≤ lam) (ha : 1 ≤ a) (hab : a ≤ b) :
    WeilPowerGeomGen.MabGen (zOf e' D e) (1 / ((lam : ℝ) * Real.pi ^ 2))
        (-1 / (2 * (lam : ℝ) ^ 2 * Real.pi ^ 2)) a b
      ≤ Real.exp (2 * eta * (b : ℝ) / ((lam : ℝ) * Real.pi ^ 2)) := by
  unfold WeilPowerGeomGen.MabGen
  exact max_le (exp_end_le h7 h8 hl ha le_rfl hab) (exp_end_le h7 h8 hl ha hab le_rfl)

/-- The reciprocal of the ratio's modulus, bounded by the size of `z`. -/
theorem inv_exp_le (e' D e : ℝ) (lam : ℕ) :
    1 / Real.exp ((zOf e' D e).re * (1 / ((lam : ℝ) * Real.pi ^ 2)))
      ≤ Real.exp (2 * (e' ^ 2 + D ^ 2 + e ^ 2) * (1 / ((lam : ℝ) * Real.pi ^ 2))) := by
  have hc : (0 : ℝ) ≤ 1 / ((lam : ℝ) * Real.pi ^ 2) := by positivity
  rw [one_div, ← Real.exp_neg, Real.exp_le_exp]
  have h1 : -‖zOf e' D e‖ ≤ (zOf e' D e).re :=
    neg_le_of_abs_le (Complex.abs_re_le_norm (zOf e' D e))
  have h2 := norm_zOf_le e' D e
  nlinarith

/-- **The geometric part of the shell member's bound**, explicit in
`ε', Δ, ε, η, λ, b`. -/
theorem geomBound_le {e' D e eta : ℝ} {lam a b : ℕ} (h1 : 0 < e') (h3 : 0 < D)
    (h7 : e' ^ 2 - D ^ 2 - e ^ 2 ≤ eta) (h8 : 0 ≤ eta) (hl : 1 ≤ lam) (ha : 1 ≤ a)
    (hab : a ≤ b) :
    WeilPowerGeomGen.geomBoundGen (zOf e' D e) (1 / ((lam : ℝ) * Real.pi ^ 2))
        (-1 / (2 * (lam : ℝ) ^ 2 * Real.pi ^ 2)) a b
      ≤ Real.exp (2 * eta * (b : ℝ) / ((lam : ℝ) * Real.pi ^ 2)) * (lam : ℝ) * Real.pi ^ 3
        * Real.exp (2 * (e' ^ 2 + D ^ 2 + e ^ 2) * (1 / ((lam : ℝ) * Real.pi ^ 2)))
        / (4 * e' * D) := by
  have hpi0 : (0 : ℝ) < Real.pi := Real.pi_pos
  have hpine : Real.pi ≠ 0 := Real.pi_ne_zero
  have hL1 : (1 : ℝ) ≤ (lam : ℝ) := by exact_mod_cast hl
  have hL : (0 : ℝ) < (lam : ℝ) := by linarith
  have hLne : (lam : ℝ) ≠ 0 := ne_of_gt hL
  have hEr : (0 : ℝ) < Real.exp ((zOf e' D e).re * (1 / ((lam : ℝ) * Real.pi ^ 2))) :=
    Real.exp_pos _
  have hErne : Real.exp ((zOf e' D e).re * (1 / ((lam : ℝ) * Real.pi ^ 2))) ≠ 0 := ne_of_gt hEr
  have he'ne : e' ≠ 0 := ne_of_gt h1
  have hDne : D ≠ 0 := ne_of_gt h3
  have hEa := exp_end_le (e' := e') (D := D) (e := e) (eta := eta) (lam := lam)
    (a := a) (b := b) (k := a) h7 h8 hl ha le_rfl hab
  have hEb := exp_end_le (e' := e') (D := D) (e := e) (eta := eta) (lam := lam)
    (a := a) (b := b) (k := b) h7 h8 hl ha hab le_rfl
  have hden : (0 : ℝ) < 2 * Real.exp ((zOf e' D e).re * (1 / ((lam : ℝ) * Real.pi ^ 2)))
      * (4 * e' * D) * (1 / ((lam : ℝ) * Real.pi ^ 2)) := by positivity
  unfold WeilPowerGeomGen.geomBoundGen
  rw [zOf_im]
  have hnum : (Real.exp ((zOf e' D e).re * (1 / ((lam : ℝ) * Real.pi ^ 2) * (a : ℝ)
        + -1 / (2 * (lam : ℝ) ^ 2 * Real.pi ^ 2)))
      + Real.exp ((zOf e' D e).re * (1 / ((lam : ℝ) * Real.pi ^ 2) * (b : ℝ)
        + -1 / (2 * (lam : ℝ) ^ 2 * Real.pi ^ 2)))) * Real.pi
      ≤ 2 * Real.exp (2 * eta * (b : ℝ) / ((lam : ℝ) * Real.pi ^ 2)) * Real.pi := by
    nlinarith
  have hstep1 := div_le_div_of_nonneg_right hnum hden.le
  have hid : 2 * Real.exp (2 * eta * (b : ℝ) / ((lam : ℝ) * Real.pi ^ 2)) * Real.pi
      / (2 * Real.exp ((zOf e' D e).re * (1 / ((lam : ℝ) * Real.pi ^ 2)))
          * (4 * e' * D) * (1 / ((lam : ℝ) * Real.pi ^ 2)))
      = Real.exp (2 * eta * (b : ℝ) / ((lam : ℝ) * Real.pi ^ 2)) * (lam : ℝ) * Real.pi ^ 3
        * (1 / Real.exp ((zOf e' D e).re * (1 / ((lam : ℝ) * Real.pi ^ 2)))) / (4 * e' * D) := by
    field_simp
    try ring
  have hpos : (0 : ℝ) ≤ Real.exp (2 * eta * (b : ℝ) / ((lam : ℝ) * Real.pi ^ 2))
      * (lam : ℝ) * Real.pi ^ 3 := by positivity
  have hlast : Real.exp (2 * eta * (b : ℝ) / ((lam : ℝ) * Real.pi ^ 2)) * (lam : ℝ) * Real.pi ^ 3
        * (1 / Real.exp ((zOf e' D e).re * (1 / ((lam : ℝ) * Real.pi ^ 2)))) / (4 * e' * D)
      ≤ Real.exp (2 * eta * (b : ℝ) / ((lam : ℝ) * Real.pi ^ 2)) * (lam : ℝ) * Real.pi ^ 3
        * Real.exp (2 * (e' ^ 2 + D ^ 2 + e ^ 2) * (1 / ((lam : ℝ) * Real.pi ^ 2)))
        / (4 * e' * D) :=
    div_le_div_of_nonneg_right (mul_le_mul_of_nonneg_left (inv_exp_le e' D e lam) hpos)
      (by positivity)
  linarith

/-- **One shell member's weighted sum, explicit.** The geometric part does not
grow with the range; the correction grows like its logarithm. -/
theorem shellSum_le {e' D e eta : ℝ} {lam a b : ℕ} (h1 : 0 < e') (h2 : e' ≤ 1 / 2)
    (h3 : 0 < D) (h4 : D ≤ 1 / 2) (h5 : 0 < e) (h6 : e ≤ 1 / 2)
    (h7 : e' ^ 2 - D ^ 2 - e ^ 2 ≤ eta) (h8 : 0 ≤ eta) (hl : 1 ≤ lam) (ha : 1 ≤ a)
    (hab : a ≤ b) :
    |shellSum e' D e lam a b|
      ≤ (e' ^ 2 + D ^ 2) / e ^ 2 * Real.exp (2 * eta * (b : ℝ) / ((lam : ℝ) * Real.pi ^ 2))
        * ((lam : ℝ) * Real.pi ^ 3
              * Real.exp (2 * (e' ^ 2 + D ^ 2 + e ^ 2) * (1 / ((lam : ℝ) * Real.pi ^ 2)))
              / (4 * e' * D)
            + 2 * (e' ^ 2 + D ^ 2 + e ^ 2) * (Real.log b - Real.log a)
              / ((lam : ℝ) ^ 3 * Real.pi ^ 2)) := by
  have hpi0 : (0 : ℝ) < Real.pi := Real.pi_pos
  have hpine : Real.pi ≠ 0 := Real.pi_ne_zero
  have hL1 : (1 : ℝ) ≤ (lam : ℝ) := by exact_mod_cast hl
  have hL : (0 : ℝ) < (lam : ℝ) := by linarith
  have hLne : (lam : ℝ) ≠ 0 := ne_of_gt hL
  have hA : (0 : ℝ) < 1 / ((lam : ℝ) * Real.pi ^ 2) := by positivity
  have hz1 : 0 < (zOf e' D e).im := by
    rw [zOf_im]
    positivity
  have hz3 := im_alpha_le (e := e) h1 h2 h3 h4 hl
  have hzc := norm_zOf_c_le h1 h2 h3 h4 h5 h6 hl a
  have hform : ∀ k : ℕ, 1 / ((lam : ℝ) * Real.pi ^ 2) * (k : ℝ)
      + -1 / (2 * (lam : ℝ) ^ 2 * Real.pi ^ 2)
      = (k : ℝ) / ((lam : ℝ) * Real.pi ^ 2) - 1 / (2 * (lam : ℝ) ^ 2 * Real.pi ^ 2) :=
    fun k => by ring
  have hu' : ∀ k : ℕ, 0 ≤ uSh lam k - (1 / ((lam : ℝ) * Real.pi ^ 2) * (k : ℝ)
        + -1 / (2 * (lam : ℝ) ^ 2 * Real.pi ^ 2))
      ∧ uSh lam k - (1 / ((lam : ℝ) * Real.pi ^ 2) * (k : ℝ)
        + -1 / (2 * (lam : ℝ) ^ 2 * Real.pi ^ 2))
        ≤ 1 / (2 * (lam : ℝ) ^ 3 * Real.pi ^ 2) / ((k : ℝ) + 1) := by
    intro k
    rw [hform k]
    exact uSh_bracket hl k
  have hbound := WeilPowerGeomGen.norm_sum_exp_u_le_gen (z := zOf e' D e)
    (α := 1 / ((lam : ℝ) * Real.pi ^ 2)) (β₀ := -1 / (2 * (lam : ℝ) ^ 2 * Real.pi ^ 2))
    (c := 1 / (2 * (lam : ℝ) ^ 3 * Real.pi ^ 2)) (u := uSh lam) (a := a) (b := b)
    hA hz1 hz3 ha hab hzc hu'
  have hgb2 : WeilPowerGeomGen.geomBoundGen (zOf e' D e) (1 / ((lam : ℝ) * Real.pi ^ 2))
        (-1 / (2 * (lam : ℝ) ^ 2 * Real.pi ^ 2)) a b
      ≤ Real.exp (2 * eta * (b : ℝ) / ((lam : ℝ) * Real.pi ^ 2))
        * ((lam : ℝ) * Real.pi ^ 3
            * Real.exp (2 * (e' ^ 2 + D ^ 2 + e ^ 2) * (1 / ((lam : ℝ) * Real.pi ^ 2)))
            / (4 * e' * D)) :=
    le_trans (geomBound_le h1 h3 h7 h8 hl ha hab) (le_of_eq (by ring))
  have hMabpos : (0 : ℝ) < WeilPowerGeomGen.MabGen (zOf e' D e)
      (1 / ((lam : ℝ) * Real.pi ^ 2)) (-1 / (2 * (lam : ℝ) ^ 2 * Real.pi ^ 2)) a b := by
    unfold WeilPowerGeomGen.MabGen
    exact lt_of_lt_of_le (Real.exp_pos _) (le_max_left _ _)
  have hMab := MabGen_le h7 h8 hl ha hab
  have hnz := norm_zOf_le e' D e
  have hA0 : (0 : ℝ) < (a : ℝ) := by exact_mod_cast Nat.lt_of_lt_of_le Nat.zero_lt_one ha
  have hAB : ((a : ℝ)) ≤ (b : ℝ) := by exact_mod_cast hab
  have hlog : (0 : ℝ) ≤ Real.log b - Real.log a := by
    have := Real.log_le_log hA0 hAB
    linarith
  have hden3 : (0 : ℝ) < (lam : ℝ) ^ 3 * Real.pi ^ 2 := mul_pos (pow_pos hL 3) (pow_pos hpi0 2)
  have hstep : ‖zOf e' D e‖ * WeilPowerGeomGen.MabGen (zOf e' D e)
        (1 / ((lam : ℝ) * Real.pi ^ 2)) (-1 / (2 * (lam : ℝ) ^ 2 * Real.pi ^ 2)) a b
        * (Real.log b - Real.log a)
      ≤ 2 * (e' ^ 2 + D ^ 2 + e ^ 2)
        * Real.exp (2 * eta * (b : ℝ) / ((lam : ℝ) * Real.pi ^ 2))
        * (Real.log b - Real.log a) := by
    -- goal `‖zOf e' D e‖ * MabGen (zOf e' D e) (1/(λπ²)) (-1/(2λ²π²)) a b * (log b - log a)
    -- ≤ 2(e'² + D² + e²) * rexp(2ηb/(λπ²)) * (log b - log a)`, with `hnz : ‖zOf e' D e‖ ≤
    -- 2(e'² + D² + e²)`, `hMab : MabGen ≤ rexp(2ηb/(λπ²))`, `hMabpos : 0 < MabGen`,
    -- `hlog : 0 ≤ log b - log a`, `0 ≤ ‖zOf e' D e‖`: a product of three nonnegative
    -- factors bounded factorwise; `nlinarith` with those four hints did not close it.
    exact mul_le_mul_of_nonneg_right
      (mul_le_mul hnz hMab hMabpos.le (by positivity)) hlog
  have hcorr : 2 * ‖zOf e' D e‖ * (1 / (2 * (lam : ℝ) ^ 3 * Real.pi ^ 2))
        * WeilPowerGeomGen.MabGen (zOf e' D e) (1 / ((lam : ℝ) * Real.pi ^ 2))
            (-1 / (2 * (lam : ℝ) ^ 2 * Real.pi ^ 2)) a b
        * (Real.log b - Real.log a)
      ≤ Real.exp (2 * eta * (b : ℝ) / ((lam : ℝ) * Real.pi ^ 2))
        * (2 * (e' ^ 2 + D ^ 2 + e ^ 2) * (Real.log b - Real.log a)
            / ((lam : ℝ) ^ 3 * Real.pi ^ 2)) := by
    have heq1 : 2 * ‖zOf e' D e‖ * (1 / (2 * (lam : ℝ) ^ 3 * Real.pi ^ 2))
          * WeilPowerGeomGen.MabGen (zOf e' D e) (1 / ((lam : ℝ) * Real.pi ^ 2))
              (-1 / (2 * (lam : ℝ) ^ 2 * Real.pi ^ 2)) a b
          * (Real.log b - Real.log a)
        = ‖zOf e' D e‖ * WeilPowerGeomGen.MabGen (zOf e' D e)
            (1 / ((lam : ℝ) * Real.pi ^ 2)) (-1 / (2 * (lam : ℝ) ^ 2 * Real.pi ^ 2)) a b
            * (Real.log b - Real.log a) / ((lam : ℝ) ^ 3 * Real.pi ^ 2) := by
      field_simp
      try ring
    have heq2 : Real.exp (2 * eta * (b : ℝ) / ((lam : ℝ) * Real.pi ^ 2))
          * (2 * (e' ^ 2 + D ^ 2 + e ^ 2) * (Real.log b - Real.log a)
              / ((lam : ℝ) ^ 3 * Real.pi ^ 2))
        = 2 * (e' ^ 2 + D ^ 2 + e ^ 2)
            * Real.exp (2 * eta * (b : ℝ) / ((lam : ℝ) * Real.pi ^ 2))
            * (Real.log b - Real.log a) / ((lam : ℝ) ^ 3 * Real.pi ^ 2) := by
      ring
    rw [heq1, heq2]
    exact div_le_div_of_nonneg_right hstep hden3.le
  have hinner : ‖∑ h ∈ Finset.Ico a b,
        Complex.exp (zOf e' D e * ((uSh lam h : ℝ) : ℂ))‖
      ≤ Real.exp (2 * eta * (b : ℝ) / ((lam : ℝ) * Real.pi ^ 2))
        * ((lam : ℝ) * Real.pi ^ 3
              * Real.exp (2 * (e' ^ 2 + D ^ 2 + e ^ 2) * (1 / ((lam : ℝ) * Real.pi ^ 2)))
              / (4 * e' * D)
            + 2 * (e' ^ 2 + D ^ 2 + e ^ 2) * (Real.log b - Real.log a)
              / ((lam : ℝ) ^ 3 * Real.pi ^ 2)) := by
    have hdist : Real.exp (2 * eta * (b : ℝ) / ((lam : ℝ) * Real.pi ^ 2))
          * ((lam : ℝ) * Real.pi ^ 3
                * Real.exp (2 * (e' ^ 2 + D ^ 2 + e ^ 2) * (1 / ((lam : ℝ) * Real.pi ^ 2)))
                / (4 * e' * D)
              + 2 * (e' ^ 2 + D ^ 2 + e ^ 2) * (Real.log b - Real.log a)
                / ((lam : ℝ) ^ 3 * Real.pi ^ 2))
        = Real.exp (2 * eta * (b : ℝ) / ((lam : ℝ) * Real.pi ^ 2))
            * ((lam : ℝ) * Real.pi ^ 3
                * Real.exp (2 * (e' ^ 2 + D ^ 2 + e ^ 2) * (1 / ((lam : ℝ) * Real.pi ^ 2)))
                / (4 * e' * D))
          + Real.exp (2 * eta * (b : ℝ) / ((lam : ℝ) * Real.pi ^ 2))
            * (2 * (e' ^ 2 + D ^ 2 + e ^ 2) * (Real.log b - Real.log a)
                / ((lam : ℝ) ^ 3 * Real.pi ^ 2)) := by
      ring
    rw [hdist]
    linarith
  have hre : shellSum e' D e lam a b
      = (∑ h ∈ Finset.Ico a b, coef e' D e
          * Complex.exp (zOf e' D e * ((WeilPowerGeomGen.uLam lam h : ℝ) : ℂ))).re := by
    unfold shellSum
    rw [Complex.re_sum]
  have hsum : ∑ h ∈ Finset.Ico a b, coef e' D e
        * Complex.exp (zOf e' D e * ((WeilPowerGeomGen.uLam lam h : ℝ) : ℂ))
      = coef e' D e * ∑ h ∈ Finset.Ico a b,
          Complex.exp (zOf e' D e * ((uSh lam h : ℝ) : ℂ)) := by
    rw [Finset.mul_sum]
    exact sum_uSh_eq e' D e lam ha
  have hcoef0 : (0 : ℝ) ≤ (e' ^ 2 + D ^ 2) / e ^ 2 := by positivity
  rw [hre, hsum]
  refine le_trans (Complex.abs_re_le_norm _) ?_
  rw [norm_mul, norm_coef]
  exact le_trans (mul_le_mul_of_nonneg_left hinner hcoef0) (le_of_eq (by ring))

/-- **The sum is even in `Δ`**: the member at `ε' − iΔ` is the conjugate of the
member at `ε' + iΔ`, and the real part does not see the conjugation. -/
theorem shellSum_neg (e' D e : ℝ) (lam a b : ℕ) :
    shellSum e' (-D) e lam a b = shellSum e' D e lam a b := by
  unfold shellSum
  refine Finset.sum_congr rfl fun h _ => ?_
  have hz : zOf e' (-D) e = (starRingEnd ℂ) (zOf e' D e) := by
    simp only [zOf, Complex.ofReal_neg, map_mul, map_sub, map_pow, map_add, map_ofNat,
      Complex.conj_ofReal, Complex.conj_I]
    ring
  have hc : coef e' (-D) e = (starRingEnd ℂ) (coef e' D e) := by
    simp [coef]
  have he : Complex.exp ((starRingEnd ℂ) (zOf e' D e)
        * ((WeilPowerGeomGen.uLam lam h : ℝ) : ℂ))
      = (starRingEnd ℂ) (Complex.exp (zOf e' D e
          * ((WeilPowerGeomGen.uLam lam h : ℝ) : ℂ))) := by
    rw [← Complex.exp_conj]
    congr 1
    simp [Complex.conj_ofReal]
  rw [hz, hc, he, ← map_mul, Complex.conj_re]

/-- **The bound at a signed `Δ`**, through the evenness. -/
theorem shellSum_le_abs {e' D e eta : ℝ} {lam a b : ℕ} (h1 : 0 < e') (h2 : e' ≤ 1 / 2)
    (hD0 : D ≠ 0) (h4 : |D| ≤ 1 / 2) (h5 : 0 < e) (h6 : e ≤ 1 / 2)
    (h7 : e' ^ 2 - D ^ 2 - e ^ 2 ≤ eta) (h8 : 0 ≤ eta) (hl : 1 ≤ lam) (ha : 1 ≤ a)
    (hab : a ≤ b) :
    |shellSum e' D e lam a b|
      ≤ (e' ^ 2 + |D| ^ 2) / e ^ 2 * Real.exp (2 * eta * (b : ℝ) / ((lam : ℝ) * Real.pi ^ 2))
        * ((lam : ℝ) * Real.pi ^ 3
              * Real.exp (2 * (e' ^ 2 + |D| ^ 2 + e ^ 2) * (1 / ((lam : ℝ) * Real.pi ^ 2)))
              / (4 * e' * |D|)
            + 2 * (e' ^ 2 + |D| ^ 2 + e ^ 2) * (Real.log b - Real.log a)
              / ((lam : ℝ) ^ 3 * Real.pi ^ 2)) := by
  have hpos : 0 < |D| := abs_pos.mpr hD0
  have hsq : |D| ^ 2 = D ^ 2 := sq_abs D
  have h7' : e' ^ 2 - |D| ^ 2 - e ^ 2 ≤ eta := by rw [hsq]; exact h7
  have hkey := shellSum_le (D := |D|) h1 h2 hpos h4 h5 h6 h7' h8 hl ha hab
  have heq : shellSum e' |D| e lam a b = shellSum e' D e lam a b := by
    rcases le_or_gt 0 D with hd | hd
    · rw [abs_of_nonneg hd]
    · rw [abs_of_neg hd]
      exact shellSum_neg e' D e lam a b
  rw [← heq]
  exact hkey

end

/-- info: 'WeilPowerShell.uSh_bracket' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms uSh_bracket

/-- info: 'WeilPowerShell.geomBound_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms geomBound_le

/-- info: 'WeilPowerShell.shellSum_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms shellSum_le

/-- info: 'WeilPowerShell.shellSum_le_abs' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms shellSum_le_abs

end WeilPowerShell
