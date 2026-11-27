/-
SignDataBall — block S14 of `lean_stage3/design/stencil.md`, Turing's sign data: ball arithmetic.
2026-11-25.

Rigorous enclosures with rational centres, every numeric goal closed by `norm_num`.
A complex ball is `‖z - cx a b‖ ≤ r` with `a b r` rationals computed in Python
(`lean_stage3/checks/signdata/gen_signdata.py`, exact `fractions`); a real ball is
`|x - c| ≤ e`. Each combining lemma takes the new, rounded centre and radius as data and
asks one rational inequality, so the centres stay short.

| name | content | status |
|---|---|---|
| `cx` | the complex number `⟨a, b⟩` | def |
| `ball_add`, `ball_mul`, `ball_conj`, `ball_ofReal` | ball arithmetic with rounding | proved |
| `re_pos_of_ball`, `re_neg_of_ball` | the sign of `Re z` from a ball | proved |
| `cosP`, `sinP`, `taylor_eq` | the Taylor polynomials of `cos`, `sin`; `Σ_{m<2K} (iy)^m/m! = cosP + i sinP` | def, proved |
| `exp_ball_core` | `|y − y₀| ≤ ε`, `|y₀| ≤ 1` ⊢ `e^{iy}` in a ball of radius `ε + |y₀|^{2K}(2K+1)/((2K)!·2K)` | proved |
| `exp_reduce` | `e^{ix} = e^{i(x − jπ/2 − 2πk)}·I^j` | proved |
| `exp_ball0` … `exp_ball3` | range reduction by `jπ/2 + 2πk` with `π` to 20 digits, then `exp_ball_core` | proved |
| `log_succ_ball`, `log_pow_ball`, `log_pi_ball` | `log(p+1)` from `log p` by the series of `log(1 − 1/(p+1))`; `log bᵐ`; `log π` | proved |
| `inv_sqrt_ball` | `lo² m ≤ 1 ≤ hi² m` ⊢ `(√m)⁻¹ ∈ [lo, hi]` | proved |

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Mathlib

namespace SignData

open Complex

noncomputable section

/-- The complex number with real part `a` and imaginary part `b`. -/
def cx (a b : ℝ) : ℂ := ⟨a, b⟩

@[simp] theorem cx_re (a b : ℝ) : (cx a b).re = a := rfl
@[simp] theorem cx_im (a b : ℝ) : (cx a b).im = b := rfl

theorem norm_cx_le (a b : ℝ) : ‖cx a b‖ ≤ |a| + |b| := by
  simpa using Complex.norm_le_abs_re_add_abs_im (cx a b)

theorem cx_mul (a b c d : ℝ) : cx a b * cx c d = cx (a * c - b * d) (a * d + b * c) := by
  apply Complex.ext <;> simp [cx]

theorem ball_exact (a b : ℝ) : ‖cx a b - cx a b‖ ≤ 0 := by simp

/-- **Sum of balls**, rounded to the centre `(e, f)`. -/
theorem ball_add {z w : ℂ} {a b c d r q e f R : ℝ} (hz : ‖z - cx a b‖ ≤ r)
    (hw : ‖w - cx c d‖ ≤ q) (hR : |a + c - e| + |b + d - f| + r + q ≤ R) :
    ‖z + w - cx e f‖ ≤ R := by
  have h : z + w - cx e f = (z - cx a b) + (w - cx c d) + cx (a + c - e) (b + d - f) := by
    apply Complex.ext <;> simp [cx] <;> ring
  rw [h]
  have h1 := norm_add_le ((z - cx a b) + (w - cx c d)) (cx (a + c - e) (b + d - f))
  have h2 := norm_add_le (z - cx a b) (w - cx c d)
  have h3 := norm_cx_le (a + c - e) (b + d - f)
  linarith

/-- **Product of balls**, rounded to the centre `(e, f)`. -/
theorem ball_mul {z w : ℂ} {a b c d r q e f R : ℝ} (hz : ‖z - cx a b‖ ≤ r)
    (hw : ‖w - cx c d‖ ≤ q)
    (hR : (|a| + |b|) * q + (|c| + |d|) * r + r * q + |a * c - b * d - e|
      + |a * d + b * c - f| ≤ R) :
    ‖z * w - cx e f‖ ≤ R := by
  have h : z * w - cx e f = (z - cx a b) * (w - cx c d) + cx a b * (w - cx c d)
      + cx c d * (z - cx a b) + cx (a * c - b * d - e) (a * d + b * c - f) := by
    apply Complex.ext <;> simp [cx] <;> ring
  rw [h]
  have hr : 0 ≤ r := (norm_nonneg _).trans hz
  have hq : 0 ≤ q := (norm_nonneg _).trans hw
  have n1 : ‖(z - cx a b) * (w - cx c d)‖ ≤ r * q := by
    rw [norm_mul]; exact mul_le_mul hz hw (norm_nonneg _) hr
  have n2 : ‖cx a b * (w - cx c d)‖ ≤ (|a| + |b|) * q := by
    rw [norm_mul]; exact mul_le_mul (norm_cx_le a b) hw (norm_nonneg _) (by positivity)
  have n3 : ‖cx c d * (z - cx a b)‖ ≤ (|c| + |d|) * r := by
    rw [norm_mul]; exact mul_le_mul (norm_cx_le c d) hz (norm_nonneg _) (by positivity)
  have n4 := norm_cx_le (a * c - b * d - e) (a * d + b * c - f)
  have t1 := norm_add_le ((z - cx a b) * (w - cx c d) + cx a b * (w - cx c d)
      + cx c d * (z - cx a b)) (cx (a * c - b * d - e) (a * d + b * c - f))
  have t2 := norm_add_le ((z - cx a b) * (w - cx c d) + cx a b * (w - cx c d))
      (cx c d * (z - cx a b))
  have t3 := norm_add_le ((z - cx a b) * (w - cx c d)) (cx a b * (w - cx c d))
  linarith

/-- The conjugate of a ball. -/
theorem ball_conj {z : ℂ} {a b r : ℝ} (hz : ‖z - cx a b‖ ≤ r) :
    ‖(starRingEnd ℂ) z - cx a (-b)‖ ≤ r := by
  have h : (starRingEnd ℂ) z - cx a (-b) = (starRingEnd ℂ) (z - cx a b) := by
    apply Complex.ext <;> simp [cx]
  rw [h, Complex.norm_conj]
  exact hz

/-- A real ball as a complex ball. -/
theorem ball_ofReal {x c e : ℝ} (h : |x - c| ≤ e) : ‖(x : ℂ) - cx c 0‖ ≤ e := by
  have : (x : ℂ) - cx c 0 = ((x - c : ℝ) : ℂ) := by apply Complex.ext <;> simp [cx]
  rw [this, Complex.norm_real, Real.norm_eq_abs]
  exact h

/-- Enlarging a ball. -/
theorem ball_mono {z : ℂ} {a b r R : ℝ} (hz : ‖z - cx a b‖ ≤ r) (h : r ≤ R) :
    ‖z - cx a b‖ ≤ R := hz.trans h

theorem re_pos_of_ball {z : ℂ} {a b r : ℝ} (hz : ‖z - cx a b‖ ≤ r) (ha : r < a) :
    0 < z.re := by
  have h := Complex.abs_re_le_norm (z - cx a b)
  have h2 : (z - cx a b).re = z.re - a := by simp
  rw [h2] at h
  have := (abs_le.mp (h.trans hz)).1
  linarith

theorem re_neg_of_ball {z : ℂ} {a b r : ℝ} (hz : ‖z - cx a b‖ ≤ r) (ha : a < -r) :
    z.re < 0 := by
  have h := Complex.abs_re_le_norm (z - cx a b)
  have h2 : (z - cx a b).re = z.re - a := by simp
  rw [h2] at h
  have := (abs_le.mp (h.trans hz)).2
  linarith

/-! ## Real balls -/

theorem real_round {x a e c R : ℝ} (h : |x - a| ≤ e) (hR : |a - c| + e ≤ R) : |x - c| ≤ R := by
  have : |x - c| ≤ |x - a| + |a - c| := abs_sub_le x a c
  linarith

theorem real_mul_ball {x a e : ℝ} (h : |x - a| ≤ e) (u : ℝ) : |u * x - u * a| ≤ |u| * e := by
  rw [← mul_sub, abs_mul]
  exact mul_le_mul_of_nonneg_left h (abs_nonneg u)

theorem neg_mul_ball {x a e : ℝ} (h : |x - a| ≤ e) (t : ℝ) :
    |-(t * x) - -(t * a)| ≤ |t| * e := by
  rw [show -(t * x) - -(t * a) = t * (a - x) by ring, abs_mul, abs_sub_comm]
  exact mul_le_mul_of_nonneg_left h (abs_nonneg t)

theorem phase_ball {x a e₁ y b e₂ : ℝ} (h1 : |x - a| ≤ e₁) (h2 : |y - b| ≤ e₂) (t : ℝ) :
    |(t / 2) * (x - y) - (t / 2) * (a - b)| ≤ |t / 2| * (e₁ + e₂) := by
  rw [show (t / 2) * (x - y) - (t / 2) * (a - b) = (t / 2) * ((x - a) - (y - b)) by ring, abs_mul]
  apply mul_le_mul_of_nonneg_left _ (abs_nonneg _)
  exact (abs_sub _ _).trans (add_le_add h1 h2)

/-! ## The exponential on the line -/

/-- The Taylor polynomial of `cos` of degree `< 2K`. -/
def cosP (K : ℕ) (y : ℝ) : ℝ := ∑ i ∈ Finset.range K, (-1) ^ i * y ^ (2 * i) / ((2 * i).factorial : ℝ)

/-- The Taylor polynomial of `sin` of degree `< 2K`. -/
def sinP (K : ℕ) (y : ℝ) : ℝ :=
  ∑ i ∈ Finset.range K, (-1) ^ i * y ^ (2 * i + 1) / ((2 * i + 1).factorial : ℝ)

theorem taylor_eq (K : ℕ) (y : ℝ) :
    ∑ m ∈ Finset.range (2 * K), ((y : ℂ) * I) ^ m / (m.factorial : ℂ) = cx (cosP K y) (sinP K y) := by
  induction K with
  | zero => simp [cosP, sinP, cx]; rfl
  | succ K ih =>
    have e : 2 * (K + 1) = 2 * K + 1 + 1 := by ring
    rw [e, Finset.sum_range_succ, Finset.sum_range_succ, ih]
    have p1 : ((y : ℂ) * I) ^ (2 * K) = (((-1) ^ K * y ^ (2 * K) : ℝ) : ℂ) := by
      rw [pow_mul, mul_pow, I_sq]
      push_cast
      rw [mul_pow, ← pow_mul]
      ring
    have p2 : ((y : ℂ) * I) ^ (2 * K + 1) = (((-1) ^ K * y ^ (2 * K + 1) : ℝ) : ℂ) * I := by
      rw [pow_succ, p1]
      push_cast
      ring
    rw [p1, p2]
    have c1 : cosP (K + 1) y = cosP K y + (-1) ^ K * y ^ (2 * K) / ((2 * K).factorial : ℝ) := by
      simp only [cosP, Finset.sum_range_succ]
    have c2 : sinP (K + 1) y
        = sinP K y + (-1) ^ K * y ^ (2 * K + 1) / ((2 * K + 1).factorial : ℝ) := by
      simp only [sinP, Finset.sum_range_succ]
    rw [c1, c2]
    generalize ((-1) ^ K * y ^ (2 * K) : ℝ) = A
    generalize ((-1) ^ K * y ^ (2 * K + 1) : ℝ) = B
    generalize (2 * K).factorial = n
    generalize (2 * K + 1).factorial = m
    apply Complex.ext <;> simp [cx, Complex.div_natCast_re, Complex.div_natCast_im]

theorem norm_exp_sub_exp_le (y y₀ : ℝ) :
    ‖cexp ((y : ℂ) * I) - cexp ((y₀ : ℂ) * I)‖ ≤ |y - y₀| := by
  have h : cexp ((y : ℂ) * I) - cexp ((y₀ : ℂ) * I)
      = cexp ((y₀ : ℂ) * I) * (cexp (I * ((y - y₀ : ℝ) : ℂ)) - 1) := by
    rw [mul_sub, mul_one, ← Complex.exp_add]
    congr 2
    push_cast
    ring
  rw [h, norm_mul, Complex.norm_exp_ofReal_mul_I, one_mul]
  have := Real.norm_exp_I_mul_ofReal_sub_one_le (x := y - y₀)
  rwa [Real.norm_eq_abs] at this

/-- **The core enclosure of `e^{iy}`.** -/
theorem exp_ball_core {y y₀ ε : ℝ} (hy : |y - y₀| ≤ ε) (hy₀ : |y₀| ≤ 1) {K : ℕ} (hK : 0 < K) :
    ‖cexp ((y : ℂ) * I) - cx (cosP K y₀) (sinP K y₀)‖
      ≤ ε + |y₀| ^ (2 * K) * ((2 * K + 1 : ℝ) / (((2 * K).factorial : ℝ) * (2 * K))) := by
  have hx : ‖(y₀ : ℂ) * I‖ ≤ 1 := by
    rw [norm_mul, Complex.norm_I, mul_one, Complex.norm_real, Real.norm_eq_abs]; exact hy₀
  have hb := Complex.exp_bound hx (n := 2 * K) (by omega)
  rw [taylor_eq] at hb
  have hn : ‖(y₀ : ℂ) * I‖ = |y₀| := by
    rw [norm_mul, Complex.norm_I, mul_one, Complex.norm_real, Real.norm_eq_abs]
  rw [hn] at hb
  have e1 : ((2 * K).succ : ℝ) * (((2 * K).factorial : ℝ) * ((2 * K : ℕ) : ℝ))⁻¹
      = (2 * K + 1 : ℝ) / (((2 * K).factorial : ℝ) * (2 * K)) := by
    push_cast; ring
  rw [e1] at hb
  have h1 := norm_exp_sub_exp_le y y₀
  have h2 := norm_sub_le_norm_sub_add_norm_sub (cexp ((y : ℂ) * I)) (cexp ((y₀ : ℂ) * I))
    (cx (cosP K y₀) (sinP K y₀))
  linarith

/-- Range reduction: `e^{ix} = e^{i(x − jπ/2 − 2πk)} · I^j`. -/
theorem exp_reduce (x : ℝ) (j : ℕ) (k : ℤ) :
    cexp ((x : ℂ) * I)
      = cexp (((x - (j * (Real.pi / 2) + k * (2 * Real.pi)) : ℝ) : ℂ) * I) * I ^ j := by
  have h1 : (x : ℂ) * I = (((x - (j * (Real.pi / 2) + k * (2 * Real.pi)) : ℝ) : ℂ) * I)
      + (j : ℂ) * ((Real.pi : ℂ) / 2 * I) + (k : ℂ) * (2 * Real.pi * I) := by
    push_cast; ring
  rw [h1, Complex.exp_add, Complex.exp_add, Complex.exp_int_mul_two_pi_mul_I, mul_one,
    Complex.exp_nat_mul, Complex.exp_pi_div_two_mul_I]

/-- `π` to twenty digits as a ball. -/
theorem pi_ball : |Real.pi - 3.14159265358979323846| ≤ 1 / 10 ^ 20 := by
  have h1 := Real.pi_gt_d20
  have h2 := Real.pi_lt_d20
  rw [abs_le]; constructor <;> norm_num <;> linarith

theorem red_ball {x x₀ ε y₀ ε' : ℝ} (hx : |x - x₀| ≤ ε) (j : ℕ) (k : ℤ)
    (hε : |x₀ - ((j : ℝ) / 2 + 2 * k) * 3.14159265358979323846 - y₀|
      + |(j : ℝ) / 2 + 2 * k| * (1 / 10 ^ 20) + ε ≤ ε') :
    |(x - (j * (Real.pi / 2) + k * (2 * Real.pi))) - y₀| ≤ ε' := by
  set c : ℝ := (j : ℝ) / 2 + 2 * k with hc
  have e : (x - (j * (Real.pi / 2) + k * (2 * Real.pi))) - y₀
      = (x - x₀) - c * (Real.pi - 3.14159265358979323846)
        + (x₀ - c * 3.14159265358979323846 - y₀) := by rw [hc]; ring
  rw [e]
  have h1 := abs_add_le ((x - x₀) - c * (Real.pi - 3.14159265358979323846))
    (x₀ - c * 3.14159265358979323846 - y₀)
  have h2 := abs_sub (x - x₀) (c * (Real.pi - 3.14159265358979323846))
  have h3 : |c * (Real.pi - 3.14159265358979323846)| ≤ |c| * (1 / 10 ^ 20) := by
    rw [abs_mul]; exact mul_le_mul_of_nonneg_left pi_ball (abs_nonneg c)
  linarith

theorem exp_ball_red {x x₀ ε y₀ ε' e f R : ℝ} (hx : |x - x₀| ≤ ε) (j : ℕ) (k : ℤ)
    (hε : |x₀ - ((j : ℝ) / 2 + 2 * k) * 3.14159265358979323846 - y₀|
      + |(j : ℝ) / 2 + 2 * k| * (1 / 10 ^ 20) + ε ≤ ε')
    (hy₀ : |y₀| ≤ 1) (K : ℕ) (hK : 0 < K)
    (hR : ε' + |y₀| ^ (2 * K) * ((2 * K + 1 : ℝ) / (((2 * K).factorial : ℝ) * (2 * K)))
      + |cosP K y₀ - e| + |sinP K y₀ - f| ≤ R) :
    ‖cexp (((x - (j * (Real.pi / 2) + k * (2 * Real.pi)) : ℝ) : ℂ) * I) - cx e f‖ ≤ R := by
  have h1 := exp_ball_core (red_ball hx j k hε) hy₀ hK
  have h2 : cx (cosP K y₀) (sinP K y₀) - cx e f = cx (cosP K y₀ - e) (sinP K y₀ - f) := by
    apply Complex.ext <;> simp [cx]
  have h3 := norm_sub_le_norm_sub_add_norm_sub
    (cexp (((x - (j * (Real.pi / 2) + k * (2 * Real.pi)) : ℝ) : ℂ) * I))
    (cx (cosP K y₀) (sinP K y₀)) (cx e f)
  rw [h2] at h3
  have h4 := norm_cx_le (cosP K y₀ - e) (sinP K y₀ - f)
  linarith

/-- Reduction by `2πk` and `j = 0`. -/
theorem exp_ball0 {x x₀ ε y₀ ε' e f R : ℝ} (hx : |x - x₀| ≤ ε) (k : ℤ)
    (hε : |x₀ - ((0 : ℕ) / 2 + 2 * k) * 3.14159265358979323846 - y₀|
      + |((0 : ℕ) : ℝ) / 2 + 2 * k| * (1 / 10 ^ 20) + ε ≤ ε')
    (hy₀ : |y₀| ≤ 1) (K : ℕ) (hK : 0 < K)
    (hR : ε' + |y₀| ^ (2 * K) * ((2 * K + 1 : ℝ) / (((2 * K).factorial : ℝ) * (2 * K)))
      + |cosP K y₀ - e| + |sinP K y₀ - f| ≤ R) :
    ‖cexp ((x : ℂ) * I) - cx e f‖ ≤ R := by
  rw [exp_reduce x 0 k, pow_zero, mul_one]
  exact exp_ball_red hx 0 k hε hy₀ K hK hR

/-- Reduction by `π/2 + 2πk`. -/
theorem exp_ball1 {x x₀ ε y₀ ε' e f R : ℝ} (hx : |x - x₀| ≤ ε) (k : ℤ)
    (hε : |x₀ - ((1 : ℕ) / 2 + 2 * k) * 3.14159265358979323846 - y₀|
      + |((1 : ℕ) : ℝ) / 2 + 2 * k| * (1 / 10 ^ 20) + ε ≤ ε')
    (hy₀ : |y₀| ≤ 1) (K : ℕ) (hK : 0 < K)
    (hR : ε' + |y₀| ^ (2 * K) * ((2 * K + 1 : ℝ) / (((2 * K).factorial : ℝ) * (2 * K)))
      + |cosP K y₀ - e| + |sinP K y₀ - f| ≤ R) :
    ‖cexp ((x : ℂ) * I) - cx (-f) e‖ ≤ R := by
  rw [exp_reduce x 1 k, pow_one]
  have h := exp_ball_red hx 1 k hε hy₀ K hK hR
  have e1 : cexp (((x - ((1 : ℕ) * (Real.pi / 2) + k * (2 * Real.pi)) : ℝ) : ℂ) * I) * I
      - cx (-f) e = (cexp (((x - ((1 : ℕ) * (Real.pi / 2) + k * (2 * Real.pi)) : ℝ) : ℂ) * I)
        - cx e f) * I := by
    apply Complex.ext <;> simp [cx] <;> ring
  rw [e1, norm_mul, Complex.norm_I, mul_one]
  exact h

/-- Reduction by `π + 2πk`. -/
theorem exp_ball2 {x x₀ ε y₀ ε' e f R : ℝ} (hx : |x - x₀| ≤ ε) (k : ℤ)
    (hε : |x₀ - ((2 : ℕ) / 2 + 2 * k) * 3.14159265358979323846 - y₀|
      + |((2 : ℕ) : ℝ) / 2 + 2 * k| * (1 / 10 ^ 20) + ε ≤ ε')
    (hy₀ : |y₀| ≤ 1) (K : ℕ) (hK : 0 < K)
    (hR : ε' + |y₀| ^ (2 * K) * ((2 * K + 1 : ℝ) / (((2 * K).factorial : ℝ) * (2 * K)))
      + |cosP K y₀ - e| + |sinP K y₀ - f| ≤ R) :
    ‖cexp ((x : ℂ) * I) - cx (-e) (-f)‖ ≤ R := by
  rw [exp_reduce x 2 k]
  have h := exp_ball_red hx 2 k hε hy₀ K hK hR
  have e1 : cexp (((x - ((2 : ℕ) * (Real.pi / 2) + k * (2 * Real.pi)) : ℝ) : ℂ) * I) * I ^ 2
      - cx (-e) (-f) = -(cexp (((x - ((2 : ℕ) * (Real.pi / 2) + k * (2 * Real.pi)) : ℝ) : ℂ) * I)
        - cx e f) := by
    rw [I_sq]
    apply Complex.ext <;> simp [cx] <;> ring
  rw [e1, norm_neg]
  exact h

/-- Reduction by `3π/2 + 2πk`. -/
theorem exp_ball3 {x x₀ ε y₀ ε' e f R : ℝ} (hx : |x - x₀| ≤ ε) (k : ℤ)
    (hε : |x₀ - ((3 : ℕ) / 2 + 2 * k) * 3.14159265358979323846 - y₀|
      + |((3 : ℕ) : ℝ) / 2 + 2 * k| * (1 / 10 ^ 20) + ε ≤ ε')
    (hy₀ : |y₀| ≤ 1) (K : ℕ) (hK : 0 < K)
    (hR : ε' + |y₀| ^ (2 * K) * ((2 * K + 1 : ℝ) / (((2 * K).factorial : ℝ) * (2 * K)))
      + |cosP K y₀ - e| + |sinP K y₀ - f| ≤ R) :
    ‖cexp ((x : ℂ) * I) - cx f (-e)‖ ≤ R := by
  rw [exp_reduce x 3 k]
  have h := exp_ball_red hx 3 k hε hy₀ K hK hR
  have e1 : cexp (((x - ((3 : ℕ) * (Real.pi / 2) + k * (2 * Real.pi)) : ℝ) : ℂ) * I) * I ^ 3
      - cx f (-e) = -(cexp (((x - ((3 : ℕ) * (Real.pi / 2) + k * (2 * Real.pi)) : ℝ) : ℂ) * I)
        - cx e f) * I := by
    rw [pow_succ, I_sq]
    apply Complex.ext <;> simp [cx] <;> ring
  rw [e1, norm_mul, norm_neg, Complex.norm_I, mul_one]
  exact h

/-! ## Logarithms -/

theorem log_one_ball : |Real.log 1 - 0| ≤ 0 := by simp

/-- `log(p + 1)` from `log p` by the series of `log(1 − 1/q)`, `q = p + 1`. -/
theorem log_succ_ball {p q a e c R : ℝ} (hp : 0 < p) (hq : q = p + 1)
    (h : |Real.log p - a| ≤ e) (K : ℕ)
    (hR : e + |a + ∑ i ∈ Finset.range K, (1 / q) ^ (i + 1) / ((i : ℝ) + 1) - c|
      + (1 / q) ^ (K + 1) / (1 - 1 / q) ≤ R) :
    |Real.log q - c| ≤ R := by
  have hq1 : 1 < q := by linarith
  have hq0 : 0 < q := by linarith
  have hx : |1 / q| < 1 := by
    rw [abs_of_pos (by positivity)]; exact (div_lt_one hq0).mpr hq1
  have hs := Real.abs_log_sub_add_sum_range_le hx K
  have hl : Real.log (1 - 1 / q) = Real.log p - Real.log q := by
    have : 1 - 1 / q = p / q := by field_simp; linarith
    rw [this, Real.log_div hp.ne' hq0.ne']
  rw [hl, abs_of_pos (by positivity : (0:ℝ) < 1 / q)] at hs
  set S := ∑ i ∈ Finset.range K, (1 / q) ^ (i + 1) / ((i : ℝ) + 1) with hS
  have e1 : Real.log q - c = (Real.log p - a) + (a + S - c) - (S + (Real.log p - Real.log q)) := by
    ring
  rw [e1]
  have t1 := abs_sub ((Real.log p - a) + (a + S - c)) (S + (Real.log p - Real.log q))
  have t2 := abs_add_le (Real.log p - a) (a + S - c)
  linarith

theorem log_pow_ball {b a e : ℝ} (h : |Real.log b - a| ≤ e) (m : ℕ) :
    |Real.log (b ^ m) - m * a| ≤ m * e := by
  rw [Real.log_pow]
  have := real_mul_ball h (m : ℝ)
  rwa [Nat.abs_cast] at this

/-- `log π` from `log 3` and the series at `x₀ = 1 − π₀/3`, `π₀` the 20-digit value. -/
theorem log_pi_ball {a e c R : ℝ} (h3 : |Real.log 3 - a| ≤ e) (K : ℕ)
    (hR : e + |a - ∑ i ∈ Finset.range K,
        (1 - 3.14159265358979323846 / 3 : ℝ) ^ (i + 1) / ((i : ℝ) + 1) - c|
      + |(1 - 3.14159265358979323846 / 3 : ℝ)| ^ (K + 1)
        / (1 - |(1 - 3.14159265358979323846 / 3 : ℝ)|) + 1 / 10 ^ 20 ≤ R) :
    |Real.log Real.pi - c| ≤ R := by
  set x₀ : ℝ := 1 - 3.14159265358979323846 / 3 with hx₀
  have hx : |x₀| < 1 := by rw [hx₀]; norm_num [abs_lt]
  have hs := Real.abs_log_sub_add_sum_range_le hx K
  set S := ∑ i ∈ Finset.range K, x₀ ^ (i + 1) / ((i : ℝ) + 1) with hS
  have hp0 : (0 : ℝ) < 3.14159265358979323846 := by norm_num
  have hl : Real.log (1 - x₀) = Real.log 3.14159265358979323846 - Real.log 3 := by
    have : 1 - x₀ = 3.14159265358979323846 / 3 := by rw [hx₀]; ring
    rw [this, Real.log_div hp0.ne' (by norm_num)]
  rw [hl] at hs
  -- `0 ≤ log π − log π₀ ≤ (π − π₀)/π₀ ≤ 10⁻²⁰`
  have hpi1 := Real.pi_gt_d20
  have hpi2 := Real.pi_lt_d20
  have hd : |Real.log Real.pi - Real.log 3.14159265358979323846| ≤ 1 / 10 ^ 20 := by
    have hpos : 0 < Real.pi / 3.14159265358979323846 := by positivity
    have e2 : Real.log Real.pi - Real.log 3.14159265358979323846
        = Real.log (Real.pi / 3.14159265358979323846) := by
      rw [Real.log_div Real.pi_ne_zero hp0.ne']
    rw [e2]
    have u1 := Real.log_le_sub_one_of_pos hpos
    have u2 : 0 ≤ Real.log (Real.pi / 3.14159265358979323846) :=
      Real.log_nonneg (by rw [le_div_iff₀ hp0]; linarith)
    rw [abs_of_nonneg u2]
    have u3 : Real.pi / 3.14159265358979323846 - 1 ≤ 1 / 10 ^ 20 := by
      rw [div_sub_one hp0.ne', div_le_iff₀ hp0]
      nlinarith
    linarith
  have e1 : Real.log Real.pi - c = (Real.log Real.pi - Real.log 3.14159265358979323846)
      + (Real.log 3 - a) + (a - S - c)
      + (S + (Real.log 3.14159265358979323846 - Real.log 3)) := by ring
  rw [e1]
  have t1 := abs_add_le ((Real.log Real.pi - Real.log 3.14159265358979323846)
      + (Real.log 3 - a) + (a - S - c)) (S + (Real.log 3.14159265358979323846 - Real.log 3))
  have t2 := abs_add_le ((Real.log Real.pi - Real.log 3.14159265358979323846)
      + (Real.log 3 - a)) (a - S - c)
  have t3 := abs_add_le (Real.log Real.pi - Real.log 3.14159265358979323846) (Real.log 3 - a)
  linarith

/-! ## Square roots -/

theorem inv_sqrt_ball {m lo hi c R : ℝ} (hm : 0 < m) (hhi : 0 < hi)
    (h1 : lo ^ 2 * m ≤ 1) (h2 : 1 ≤ hi ^ 2 * m) (hR1 : hi - c ≤ R) (hR2 : c - lo ≤ R) :
    |(Real.sqrt m)⁻¹ - c| ≤ R := by
  have hs : 0 < Real.sqrt m := Real.sqrt_pos.mpr hm
  have hsq : Real.sqrt m ^ 2 = m := Real.sq_sqrt hm.le
  have k1 : lo ≤ (Real.sqrt m)⁻¹ := by
    rw [← one_div, le_div_iff₀ hs]
    have : (lo * Real.sqrt m) ^ 2 ≤ 1 := by rw [mul_pow, hsq]; exact h1
    nlinarith
  have k2 : (Real.sqrt m)⁻¹ ≤ hi := by
    rw [← one_div, div_le_iff₀ hs]
    have : 1 ≤ (hi * Real.sqrt m) ^ 2 := by rw [mul_pow, hsq]; exact h2
    nlinarith [mul_pos hhi hs]
  rw [abs_le]; constructor <;> linarith

end

/-- info: 'SignData.ball_mul' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms ball_mul

/-- info: 'SignData.exp_ball_core' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms exp_ball_core

/-- info: 'SignData.log_succ_ball' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms log_succ_ball

/-- info: 'SignData.log_pi_ball' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms log_pi_ball

end SignData
