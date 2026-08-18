/-
Euler Factor Chain — the algebraic core, formalised.

Companion to papers/Euler-Factor-Chain.md (statements A1, B1, B2, B4).

WHAT IS PROVED HERE
  A1  the ladder symbol: backward differencing a mode b^(r*rho) multiplies it
      by (1 - b^(-rho)), so the difference operator's symbol is the reciprocal
      Euler factor at b.
  B2a the functional equation h s = h (1 - s).
  B2b h 0 = 0 and h 1 = 0  (the stencil annihilates constants; no pole term).
  B4  on the critical line, h = |1 - b^(-s)|^(2N), real and non-negative —
      the depth-transfer gain raised to 2N.

WHAT IS NOT PROVED HERE, AND CANNOT BE
  Anything citing a numerical zero (gamma_1 = 14.1347...) is an observation,
  not a theorem. The gain bound of C2, Jentzsch's theorem, and the radius
  results of G are outside this file. See papers/Euler-Factor-Chain.md § J.

STATUS: the four statements below are proved with no `sorry`.
-/
import Mathlib

namespace EulerFactorChain

open Complex

variable {b : ℝ} (hb : 0 < b)

/-- The reciprocal Euler factor at `b`, as a function of `s`. -/
noncomputable def sym (b : ℝ) (s : ℂ) : ℂ := 1 - (b : ℂ) ^ (-s)

/-- **A1.** Backward differencing the mode `r ↦ b^(r*ρ)` on the ladder
multiplies it by `1 - b^(-ρ)`. The symbol of `Δ` is the reciprocal Euler
factor. -/
theorem symbol_of_backward_difference (b : ℝ) (hb : b ≠ 0) (ρ r : ℂ) :
    (b : ℂ) ^ (r * ρ) - (b : ℂ) ^ ((r - 1) * ρ)
      = sym b ρ * (b : ℂ) ^ (r * ρ) := by
  have hb' : (b : ℂ) ≠ 0 := by exact_mod_cast hb
  unfold sym
  have key : (b : ℂ) ^ ((r - 1) * ρ) = (b : ℂ) ^ (r * ρ) * (b : ℂ) ^ (-ρ) := by
    rw [← Complex.cpow_add _ _ hb']
    ring_nf
  rw [key]
  ring

/-- The Weil test function built from an order-`N` stencil. -/
noncomputable def h (b : ℝ) (N : ℕ) (s : ℂ) : ℂ :=
  (1 - (b : ℂ) ^ (-s)) ^ N * (1 - (b : ℂ) ^ (s - 1)) ^ N

/-- **B2a.** `h` is symmetric under `s ↦ 1 - s`: the functional equation. -/
theorem h_functional_equation (b : ℝ) (N : ℕ) (s : ℂ) :
    h b N (1 - s) = h b N s := by
  unfold h
  have h1 : -(1 - s) = s - 1 := by ring
  have h2 : (1 - s) - 1 = -s := by ring
  rw [h1, h2, mul_comm]

/-- **B2b.** `h` vanishes at `s = 0`: the stencil annihilates constants. -/
theorem h_zero (b : ℝ) (hb : b ≠ 0) {N : ℕ} (hN : N ≠ 0) : h b N 0 = 0 := by
  unfold h
  have hb' : (b : ℂ) ≠ 0 := by exact_mod_cast hb
  have : (b : ℂ) ^ (-(0 : ℂ)) = 1 := by simp
  rw [this, sub_self, zero_pow hN, zero_mul]

/-- **B2b.** `h` vanishes at `s = 1`, so there is no pole contribution. -/
theorem h_one (b : ℝ) (hb : b ≠ 0) {N : ℕ} (hN : N ≠ 0) : h b N 1 = 0 := by
  have := h_functional_equation b N 1
  rw [show (1 : ℂ) - 1 = 0 by ring] at this
  rw [← this]
  exact h_zero b hb hN

/-- On the critical line the second factor is the conjugate of the first. -/
theorem conj_factor_on_critical_line (hb : 0 < b) (t : ℝ) :
    (starRingEnd ℂ) (1 - (b : ℂ) ^ (-((1 : ℂ)/2 + t * I)))
      = 1 - (b : ℂ) ^ (((1 : ℂ)/2 + t * I) - 1) := by
  have hb0 : (b : ℂ) ≠ 0 := by exact_mod_cast hb.ne'
  rw [map_sub, map_one]
  congr 1
  have hlog : (starRingEnd ℂ) (Complex.log (b : ℂ)) = Complex.log (b : ℂ) := by
    rw [Complex.conj_eq_iff_im, Complex.log_im,
        Complex.arg_ofReal_of_nonneg hb.le]
  rw [Complex.cpow_def_of_ne_zero hb0, Complex.cpow_def_of_ne_zero hb0,
      ← Complex.exp_conj, map_mul, hlog]
  congr 1
  simp only [Complex.ext_iff, Complex.add_re, Complex.add_im, Complex.sub_re,
    Complex.sub_im, Complex.mul_re, Complex.mul_im, Complex.ofReal_re,
    Complex.ofReal_im, Complex.I_re, Complex.I_im, Complex.one_re,
    Complex.one_im, Complex.div_re, Complex.div_im]
  norm_num

/-- **B4.** On the critical line, `h = ‖1 - b^(-s)‖^(2N)` — real, non-negative,
and equal to the depth-transfer gain raised to the `2N`. -/
theorem h_eq_gain_pow_on_critical_line (hb : 0 < b) (N : ℕ) (t : ℝ) :
    h b N ((1 : ℂ)/2 + t * I)
      = ((‖1 - (b : ℂ) ^ (-((1 : ℂ)/2 + t * I))‖ : ℝ) ^ (2 * N) : ℝ) := by
  unfold h
  rw [← conj_factor_on_critical_line hb t]
  set z := 1 - (b : ℂ) ^ (-((1 : ℂ)/2 + t * I)) with hz
  have : z ^ N * ((starRingEnd ℂ) z) ^ N = (z * (starRingEnd ℂ) z) ^ N := by
    rw [mul_pow]
  rw [this, Complex.mul_conj', pow_mul]
  norm_cast

end EulerFactorChain
