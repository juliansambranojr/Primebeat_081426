/-
SignDataZeta — block S14 of `lean_stage3/design/stencil.md`, Turing's sign data: ζ on the line
by Euler–Maclaurin of order 4. 2026-11-25.

`ZetaEM.zeta_eq_em` at `k = 4` on the line `s = 1/2 + it`, with the boundary terms written out
(`B₂ = 1/6`, `B₃ = 0`, `B₄ = −1/30`) and `bernBound 4 ≤ 1/30` proved (`B₄(x) = (x(1−x))² − 1/30`):

  ζ(s) = Σ_{m ≤ N} m^{−s} + N^{−s}·emB t N + R,
  emB t N = N/(s−1) − 1/2 + s/(12N) − s(s+1)(s+2)/(720N³),
  ‖R‖ ≤ (∏_{i<4} ‖s+i‖)/24 · (1/30) · N^{−7/2}/(7/2).

`m^{−s} = (√m)⁻¹ · e^{−it log m}` (`natCast_cpow_line`), and `emB t N = cx (Bre t N) (Bim t N)` in
closed form (`emB_eq`, computed with sympy), so every piece is a ball of `SignDataBall`.

| name | content | status |
|---|---|---|
| `lineS`, `emB`, `Bre`, `Bim` | the line, the boundary bracket and its parts | def |
| `bernoulliFun_four`, `bernBound_four_le` | `B₄(x) = x⁴ − 2x³ + x² − 1/30`; `sup_{[0,1]} |B₄| ≤ 1/30` | proved |
| `emBoundary_four` | `emBoundary 4 N s = N^{−s}(s/(12N) − s(s+1)(s+2)/(720N³))` | proved |
| `zeta_em4` | the formula above with the remainder bound | proved |
| `emB_eq` | `emB t N = cx (Bre t N) (Bim t N)` | proved |
| `natCast_cpow_line` | `m^{−(1/2+it)} = (√m)⁻¹ e^{i(−t log m)}` | proved |
| `rem_le` | `‖s + i‖ ≤ qᵢ`, `lo² ≤ N` ⊢ the remainder bound `≤ ∏qᵢ/(24·30·(7/2)·N³·lo)` | proved |

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Stage3.ZetaEM
import Stage3.SignDataBall

namespace SignData

open Complex ZetaEM

noncomputable section

/-- The point `1/2 + it` of the critical line. -/
def lineS (t : ℝ) : ℂ := 1 / 2 + (t : ℂ) * I

/-- The boundary bracket of the order-4 formula. -/
def emB (t : ℝ) (N : ℕ) : ℂ :=
  (N : ℂ) / (lineS t - 1) - 1 / 2 + lineS t / (12 * N)
    - lineS t * (lineS t + 1) * (lineS t + 2) / (720 * (N : ℂ) ^ 3)

/-- The real part of `emB t N`. -/
def Bre (t N : ℝ) : ℝ :=
  (-3840 * N ^ 4 - 960 * N ^ 3 * (4 * t ^ 2 + 1) + 80 * N ^ 2 * (4 * t ^ 2 + 1)
    + (4 * t ^ 2 + 1) * (12 * t ^ 2 - 5)) / (1920 * N ^ 3 * (4 * t ^ 2 + 1))

/-- The imaginary part of `emB t N`. -/
def Bim (t N : ℝ) : ℝ :=
  t * (-11520 * N ^ 4 + N ^ 2 * (960 * t ^ 2 + 240) + (4 * t ^ 2 - 23) * (4 * t ^ 2 + 1))
    / (2880 * N ^ 3 * (4 * t ^ 2 + 1))

theorem lineS_re (t : ℝ) : (lineS t).re = 1 / 2 := by simp [lineS]

theorem lineS_ne_zero (t : ℝ) : lineS t ≠ 0 := by
  intro h
  have := congrArg Complex.re h
  rw [lineS_re] at this
  simp at this

theorem lineS_ne_one (t : ℝ) : lineS t ≠ 1 := by
  intro h
  have := congrArg Complex.re h
  rw [lineS_re] at this
  norm_num at this

theorem bernoulliFun_four (x : ℝ) : bernoulliFun 4 x = x ^ 4 - 2 * x ^ 3 + x ^ 2 - 1 / 30 := by
  simp [bernoulliFun, Polynomial.bernoulli_def, Finset.sum_range_succ,
    bernoulli_eq_bernoulli'_of_ne_one, bernoulli'_three, bernoulli'_four, Nat.choose]
  ring

theorem bernBound_four_le : bernBound 4 ≤ 1 / 30 := by
  unfold bernBound
  apply csSup_le
  · exact ⟨_, ⟨0, ⟨le_refl _, zero_le_one⟩, rfl⟩⟩
  · rintro y ⟨x, ⟨hx0, hx1⟩, rfl⟩
    show |bernoulliFun 4 x| ≤ 1 / 30
    rw [bernoulliFun_four]
    have e : x ^ 4 - 2 * x ^ 3 + x ^ 2 - 1 / 30 = (x * (1 - x)) ^ 2 - 1 / 30 := by ring
    rw [e]
    have h1 : 0 ≤ x * (1 - x) := mul_nonneg hx0 (by linarith)
    have h2 : x * (1 - x) ≤ 1 / 4 := by nlinarith [sq_nonneg (x - 1 / 2)]
    have h3 : (x * (1 - x)) ^ 2 ≤ 1 / 16 := by nlinarith
    rw [abs_le]; constructor <;> nlinarith

theorem bernoulliFun_three_zero : bernoulliFun 3 0 = 0 := by
  rw [bernoulliFun_eval_zero, bernoulli_eq_bernoulli'_of_ne_one (by norm_num), bernoulli'_three]
  simp

theorem bernoulliFun_four_zero : bernoulliFun 4 0 = -1 / 30 := by
  rw [bernoulliFun_four]; norm_num

theorem cpow_neg_add_nat {N : ℕ} (hN : 0 < N) (s : ℂ) (j : ℕ) :
    (N : ℂ) ^ (-(s + j)) = (N : ℂ) ^ (-s) / (N : ℂ) ^ j := by
  have hN0 : (N : ℂ) ≠ 0 := by exact_mod_cast hN.ne'
  rw [show -(s + (j : ℂ)) = -s + (-(j : ℂ)) by ring, Complex.cpow_add _ _ hN0,
    Complex.cpow_neg (N : ℂ) (j : ℂ), Complex.cpow_natCast, div_eq_mul_inv]

theorem emBoundary_four {N : ℕ} (hN : 0 < N) (s : ℂ) :
    emBoundary 4 N s = (N : ℂ) ^ (-s) * (s / (12 * N) - s * (s + 1) * (s + 2) / (720 * (N : ℂ) ^ 3)) := by
  have hN0 : (N : ℂ) ≠ 0 := by exact_mod_cast hN.ne'
  have hI : Finset.Ico 1 4 = {1, 2, 3} := by decide
  unfold emBoundary
  rw [hI, Finset.sum_insert (by decide), Finset.sum_insert (by decide), Finset.sum_singleton]
  unfold emTerm
  rw [cpow_neg_add_nat hN, cpow_neg_add_nat hN, cpow_neg_add_nat hN, bernoulliFun_three_zero,
    bernoulliFun_four_zero, bernoulliFun_two]
  simp only [Finset.prod_range_succ, Finset.prod_range_zero, Nat.factorial]
  push_cast
  field_simp
  ring

/-- **ζ on the line by Euler–Maclaurin of order 4.** -/
theorem zeta_em4 (t : ℝ) {N : ℕ} (hN : 0 < N) :
    ‖riemannZeta (lineS t) - (∑ m ∈ Finset.Icc 1 N, (m : ℂ) ^ (-lineS t)
        + (N : ℂ) ^ (-lineS t) * emB t N)‖
      ≤ (∏ i ∈ Finset.range 4, ‖lineS t + i‖) / 24
        * ((1 / 30) * ((N : ℝ) ^ (-(7 / 2) : ℝ) / (7 / 2))) := by
  set s := lineS t with hs
  have hσ : 0 < s.re := by rw [hs, lineS_re]; norm_num
  have hs1 : s ≠ 1 := lineS_ne_one t
  have hN0 : (N : ℂ) ≠ 0 := by exact_mod_cast hN.ne'
  have hz := zeta_eq_em (k := 4) (by norm_num) hN hσ hs1
  have h1s : (1 : ℂ) - s ≠ 0 := sub_ne_zero.mpr (Ne.symm hs1)
  have hs1' : s - 1 ≠ 0 := sub_ne_zero.mpr hs1
  have hcp : (N : ℂ) ^ (1 - s) = (N : ℂ) * (N : ℂ) ^ (-s) := by
    rw [show (1 : ℂ) - s = 1 + (-s) by ring, Complex.cpow_add _ _ hN0, Complex.cpow_one]
  have heq : riemannZeta s - (∑ m ∈ Finset.Icc 1 N, (m : ℂ) ^ (-s) + (N : ℂ) ^ (-s) * emB t N)
      = emRem 4 N s := by
    rw [hz, emBoundary_four hN, hcp]
    unfold emB
    rw [← hs]
    field_simp
    ring
  rw [heq]
  have hk : 1 < s.re + ((4 : ℕ) : ℝ) := by rw [hs, lineS_re]; norm_num
  have hr := norm_remainder_le 4 hN hk
  have hre : s.re = 1 / 2 := by rw [hs, lineS_re]
  rw [hre] at hr
  have e1 : (1 : ℝ) - 1 / 2 - ((4 : ℕ) : ℝ) = -(7 / 2) := by norm_num
  have e2 : (1 / 2 : ℝ) + ((4 : ℕ) : ℝ) - 1 = 7 / 2 := by norm_num
  rw [e1, e2] at hr
  have hf : ((Nat.factorial 4 : ℕ) : ℝ) = 24 := by norm_num [Nat.factorial]
  rw [hf] at hr
  refine hr.trans ?_
  apply mul_le_mul_of_nonneg_left _ (by positivity)
  apply mul_le_mul_of_nonneg_right bernBound_four_le (by positivity)

theorem emB_eq (t : ℝ) {N : ℕ} (hN : 0 < N) : emB t N = cx (Bre t N) (Bim t N) := by
  have hN0 : (N : ℝ) ≠ 0 := by positivity
  have h1 : lineS t - 1 = ((-1 / 2 : ℝ) : ℂ) + (t : ℂ) * I := by simp [lineS]; ring
  have hNC : (N : ℂ) = ((N : ℝ) : ℂ) := by simp
  have hd : (4 * t ^ 2 + 1) ≠ 0 := by positivity
  unfold emB
  rw [h1, hNC]
  unfold lineS
  apply Complex.ext
  · simp [Complex.div_re, Complex.normSq, Bre, pow_succ, cx]
    field_simp
    ring
  · simp [Complex.div_im, Complex.normSq, Bim, pow_succ, cx]
    field_simp
    ring

/-- `m^{−(1/2 + it)} = (√m)⁻¹ · e^{i(−t log m)}`. -/
theorem natCast_cpow_line {m : ℕ} (hm : 0 < m) (t : ℝ) :
    (m : ℂ) ^ (-lineS t) = (((Real.sqrt m)⁻¹ : ℝ) : ℂ) * cexp (((-(t * Real.log m)) : ℝ) * I) := by
  have hm0 : (m : ℂ) ≠ 0 := by exact_mod_cast hm.ne'
  have hmR : (0 : ℝ) < m := by exact_mod_cast hm
  rw [Complex.cpow_def_of_ne_zero hm0, ← Complex.natCast_log]
  have hsq : (Real.sqrt m)⁻¹ = Real.exp (-(Real.log m / 2)) := by
    rw [Real.exp_neg]
    congr 1
    rw [Real.sqrt_eq_iff_mul_self_eq hmR.le (Real.exp_pos _).le, ← Real.exp_add, add_halves,
      Real.exp_log hmR]
  rw [hsq, Complex.ofReal_exp, ← Complex.exp_add]
  congr 1
  unfold lineS
  push_cast
  ring

theorem norm_le_of_sq {a b q : ℝ} (hq : 0 ≤ q) (h : a ^ 2 + b ^ 2 ≤ q ^ 2) : ‖cx a b‖ ≤ q := by
  rw [Complex.norm_def, Complex.normSq_apply]
  simp only [cx_re, cx_im]
  rw [Real.sqrt_le_left hq]
  nlinarith

theorem lineS_add_nat (t : ℝ) (i : ℕ) : lineS t + i = cx (1 / 2 + i) t := by
  apply Complex.ext <;> simp [lineS, cx]

theorem rpow_neg_seven_half {N : ℝ} (hN : 0 < N) :
    N ^ (-(7 / 2) : ℝ) = 1 / (N ^ 3 * Real.sqrt N) := by
  rw [Real.rpow_neg hN.le, Real.sqrt_eq_rpow, show (7 / 2 : ℝ) = (3 : ℕ) + 1 / 2 by norm_num,
    Real.rpow_add hN, Real.rpow_natCast, one_div, one_div]

/-- The remainder bound with rational data. -/
theorem rem_le (t : ℝ) {N : ℕ} (hN : 0 < N) {q0 q1 q2 q3 lo Q : ℝ}
    (h0 : (1 / 2 + 0 : ℝ) ^ 2 + t ^ 2 ≤ q0 ^ 2) (h1 : (1 / 2 + 1 : ℝ) ^ 2 + t ^ 2 ≤ q1 ^ 2)
    (h2 : (1 / 2 + 2 : ℝ) ^ 2 + t ^ 2 ≤ q2 ^ 2) (h3 : (1 / 2 + 3 : ℝ) ^ 2 + t ^ 2 ≤ q3 ^ 2)
    (hq0 : 0 ≤ q0) (hq1 : 0 ≤ q1) (hq2 : 0 ≤ q2) (hq3 : 0 ≤ q3)
    (hlo : 0 < lo) (hlo2 : lo ^ 2 ≤ N)
    (hQ : q0 * q1 * q2 * q3 / 24 * ((1 / 30) * (1 / ((N : ℝ) ^ 3 * lo) / (7 / 2))) ≤ Q) :
    (∏ i ∈ Finset.range 4, ‖lineS t + i‖) / 24
        * ((1 / 30) * ((N : ℝ) ^ (-(7 / 2) : ℝ) / (7 / 2))) ≤ Q := by
  have hNR : (0 : ℝ) < N := by exact_mod_cast hN
  simp only [Finset.prod_range_succ, Finset.prod_range_zero, one_mul]
  have n0 : ‖lineS t + ((0 : ℕ) : ℂ)‖ ≤ q0 := by
    rw [lineS_add_nat]; exact norm_le_of_sq hq0 (by simpa using h0)
  have n1 : ‖lineS t + ((1 : ℕ) : ℂ)‖ ≤ q1 := by
    rw [lineS_add_nat]; exact norm_le_of_sq hq1 (by simpa using h1)
  have n2 : ‖lineS t + ((2 : ℕ) : ℂ)‖ ≤ q2 := by
    rw [lineS_add_nat]; exact norm_le_of_sq hq2 (by simpa using h2)
  have n3 : ‖lineS t + ((3 : ℕ) : ℂ)‖ ≤ q3 := by
    rw [lineS_add_nat]; exact norm_le_of_sq hq3 (by simpa using h3)
  have hp : ‖lineS t + ((0 : ℕ) : ℂ)‖ * ‖lineS t + ((1 : ℕ) : ℂ)‖ * ‖lineS t + ((2 : ℕ) : ℂ)‖
      * ‖lineS t + ((3 : ℕ) : ℂ)‖ ≤ q0 * q1 * q2 * q3 := by
    apply mul_le_mul (mul_le_mul (mul_le_mul n0 n1 (norm_nonneg _) hq0) n2 (norm_nonneg _)
      (by positivity)) n3 (norm_nonneg _) (by positivity)
  have hsq : lo ≤ Real.sqrt N := Real.le_sqrt_of_sq_le hlo2
  have hr : (N : ℝ) ^ (-(7 / 2) : ℝ) ≤ 1 / ((N : ℝ) ^ 3 * lo) := by
    rw [rpow_neg_seven_half hNR]
    apply one_div_le_one_div_of_le (by positivity)
    exact mul_le_mul_of_nonneg_left hsq (by positivity)
  refine le_trans ?_ hQ
  simp only [Nat.cast_ofNat, Nat.cast_zero, Nat.cast_one] at hp
  push_cast at hp ⊢
  apply mul_le_mul (div_le_div_of_nonneg_right hp (by norm_num))
  · apply mul_le_mul_of_nonneg_left _ (by norm_num)
    exact div_le_div_of_nonneg_right hr (by norm_num)
  · positivity
  · positivity

theorem emB_ball (t : ℝ) {N : ℕ} (hN : 0 < N) : ‖emB t N - cx (Bre t N) (Bim t N)‖ ≤ 0 := by
  rw [emB_eq t hN, sub_self, norm_zero]

/-- A ball for `ζ(1/2 + it)` from a ball for the Euler–Maclaurin main part and the remainder. -/
theorem zeta_ball (t : ℝ) {N : ℕ} (hN : 0 < N) {a b r Q R : ℝ}
    (hY : ‖(∑ m ∈ Finset.Icc 1 N, (m : ℂ) ^ (-lineS t) + (N : ℂ) ^ (-lineS t) * emB t N)
      - cx a b‖ ≤ r)
    (hQ : (∏ i ∈ Finset.range 4, ‖lineS t + i‖) / 24
        * ((1 / 30) * ((N : ℝ) ^ (-(7 / 2) : ℝ) / (7 / 2))) ≤ Q)
    (hR : r + Q ≤ R) : ‖riemannZeta (lineS t) - cx a b‖ ≤ R := by
  have h1 := zeta_em4 t hN
  have h2 := norm_sub_le_norm_sub_add_norm_sub (riemannZeta (lineS t))
    (∑ m ∈ Finset.Icc 1 N, (m : ℂ) ^ (-lineS t) + (N : ℂ) ^ (-lineS t) * emB t N) (cx a b)
  linarith

theorem one_term_ball (t : ℝ) : ‖((1 : ℕ) : ℂ) ^ (-lineS t) - cx 1 0‖ ≤ 0 := by
  have : cx 1 0 = 1 := by apply Complex.ext <;> simp [cx]
  rw [this, Nat.cast_one, Complex.one_cpow, sub_self, norm_zero]

theorem sum_one_ball (t : ℝ) : ‖∑ m ∈ Finset.Icc 1 1, ((m : ℕ) : ℂ) ^ (-lineS t) - cx 1 0‖ ≤ 0 := by
  rw [Finset.Icc_self, Finset.sum_singleton]
  exact one_term_ball t

end

/-- info: 'SignData.zeta_em4' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms zeta_em4

/-- info: 'SignData.emB_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms emB_eq

/-- info: 'SignData.natCast_cpow_line' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms natCast_cpow_line

end SignData
