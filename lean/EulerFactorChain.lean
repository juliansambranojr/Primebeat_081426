/-
Euler Factor Chain — the algebraic core, formalised.

Companion to papers/Euler-Factor-Chain.md (statements A1, A2, A3, B1, B2, B4, C1).

WHAT IS PROVED HERE
  A1  the ladder symbol: backward differencing a mode b^(r*rho) multiplies it
      by (1 - b^(-rho)), so the difference operator's symbol is the reciprocal
      Euler factor at b.
  A2  Euler's product, over ALL primes at once and only where it converges:
      for 1 < re s, prod over p of (1 - p^(-s))^(-1) = zeta s. Cited from
      Mathlib, not reproved.
  A3  the single-base reading, b index retained: at a prime base p the chain's
      own `sym` IS the factor A2 inverts, so the two are one product and not
      two adjacent facts. The pointwise half is definitional; see below.
  B2a the functional equation h s = h (1 - s).
  B2b h 0 = 0 and h 1 = 0  (the stencil annihilates constants; no pole term).
  B4  on the critical line, h = |1 - b^(-s)|^(2N), real and non-negative —
      the depth-transfer gain raised to 2N.
  C1  on the critical line, |1 - b^(-s)|^2 = 1 - 2*b^(-1/2)*cos(gamma*log b)
      + b^(-1) — the law of cosines with sides 1 and b^(-1/2), included
      angle gamma*log b.

WHAT IS NOT PROVED HERE, AND CANNOT BE
  Anything citing a numerical zero (gamma_1 = 14.1347...) is an observation,
  not a theorem. The gain bound of C2, Jentzsch's theorem, and the radius
  results of G are outside this file. See papers/Euler-Factor-Chain.md § J.

STATUS: the seven statements below are proved with no `sorry`.
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

/-- **A2.** Euler's product, 1737, in the form Mathlib proves it: over *all*
primes at once, and only in the half-plane where the product converges. The
hypothesis `1 < s.re` is not decoration — it is the honest content of the
statement, and it excludes the whole `sym b s = 0` lattice on which the old
`(sym s)⁻¹ * sym s = 1` reading of A2 was false. Cited from
`riemannZeta_eulerProduct_tprod`, not reproved. -/
theorem euler_product_riemannZeta {s : ℂ} (hs : 1 < s.re) :
    ∏' p : Nat.Primes, (1 - (p : ℂ) ^ (-s))⁻¹ = riemannZeta s :=
  riemannZeta_eulerProduct_tprod hs

/-- The chain's `sym` at a natural-number base, written the way the Euler
product writes its factors. **This is definitional**: `sym` unfolds to
`1 - b^(-s)` and the only work is the `ℕ → ℝ → ℂ` cast. It is stated as a
lemma solely so that `euler_product_sym` below can be written in the chain's
own vocabulary. -/
theorem sym_natCast (n : ℕ) (s : ℂ) : sym (n : ℝ) s = 1 - (n : ℂ) ^ (-s) := by
  simp [sym]

/-- **A3**, the single-base reading with the `b` index retained. For a prime
`p`, `sym ↑p` is exactly the factor A2 inverts: substituting the chain's symbol
into Euler's product leaves the product unchanged and still equal to `ζ s`.

This is what connects A2 to A3 rather than leaving them adjacent. The
connection itself is definitional — `sym_natCast` is a cast lemma with no
content of its own — and saying so is the point: the paper's "therefore" at A3
is a *renaming*, not an inference. What is not definitional, and is carried
here from A2, is that the renamed factors multiply to `ζ`. -/
theorem euler_product_sym {s : ℂ} (hs : 1 < s.re) :
    ∏' p : Nat.Primes, (sym ((p : ℕ) : ℝ) s)⁻¹ = riemannZeta s := by
  rw [← euler_product_riemannZeta hs]
  exact tprod_congr fun p => by rw [sym_natCast]

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

/-- Rectangular form of the Euler factor's reciprocal on the critical line.
Writing `θ = γ · log b`, `b^(-(1/2 + γi)) = b^(-1/2)·(cos θ - i sin θ)`. -/
theorem cpow_rect_on_critical_line (hb : 0 < b) (γ : ℝ) :
    (b : ℂ) ^ (-((1 : ℂ)/2 + γ * I))
      = ((b ^ (-(1:ℝ)/2) * Real.cos (γ * Real.log b) : ℝ) : ℂ)
        + ((-(b ^ (-(1:ℝ)/2) * Real.sin (γ * Real.log b)) : ℝ) : ℂ) * I := by
  have hb0 : (b : ℂ) ≠ 0 := by exact_mod_cast hb.ne'
  rw [Complex.cpow_def_of_ne_zero hb0, ← Complex.ofReal_log hb.le]
  have harg : ((Real.log b : ℝ) : ℂ) * (-((1 : ℂ)/2 + γ * I))
      = ((-(Real.log b / 2) : ℝ) : ℂ) + ((-(γ * Real.log b) : ℝ) : ℂ) * I := by
    push_cast; ring
  have hexp : Real.exp (-(Real.log b / 2)) = b ^ (-(1:ℝ)/2) := by
    rw [Real.rpow_def_of_pos hb]; ring_nf
  rw [harg, Complex.exp_add, ← Complex.ofReal_exp, Complex.exp_mul_I,
    ← Complex.ofReal_cos, ← Complex.ofReal_sin, hexp, Real.cos_neg, Real.sin_neg]
  push_cast
  ring_nf

/-- **C1.** On the critical line `s = 1/2 + γi`, the squared modulus of the
reciprocal Euler factor expands as the law of cosines with sides `1` and
`b^(-1/2)` and included angle `θ = γ · log b`:

  `‖1 - b^(-s)‖² = 1 - 2·b^(-1/2)·cos θ + b^(-1)`.

The two `b^(-1)` terms collapse into one by `cos²θ + sin²θ = 1`. Only
`0 < b` is needed. -/
theorem gain_sq_on_critical_line (hb : 0 < b) (γ : ℝ) :
    ‖1 - (b : ℂ) ^ (-((1 : ℂ)/2 + γ * I))‖ ^ 2
      = 1 - 2 * b ^ (-(1:ℝ)/2) * Real.cos (γ * Real.log b) + b ^ (-(1:ℝ)) := by
  have hkey : 1 - (b : ℂ) ^ (-((1 : ℂ)/2 + γ * I))
      = ((1 - b ^ (-(1:ℝ)/2) * Real.cos (γ * Real.log b) : ℝ) : ℂ)
        + ((b ^ (-(1:ℝ)/2) * Real.sin (γ * Real.log b) : ℝ) : ℂ) * I := by
    rw [cpow_rect_on_critical_line hb γ]; push_cast; ring
  have hsq : (b ^ (-(1:ℝ)/2)) ^ 2 = b ^ (-(1:ℝ)) := by
    rw [← Real.rpow_natCast (b ^ (-(1:ℝ)/2)) 2, ← Real.rpow_mul hb.le]
    norm_num
  rw [hkey, Complex.sq_norm, Complex.normSq_add_mul_I]
  linear_combination
    (b ^ (-(1:ℝ)/2)) ^ 2 * Real.sin_sq_add_cos_sq (γ * Real.log b) + hsq

/-! ## Axiom check

An axiom claim is only a claim unless the build checks it. Each `#guard_msgs`
block below pins the exact axiom list of one result: if a proof ever starts
depending on anything not listed, the docstring stops matching the compiler and
**`lake build` fails**. This is a check, not a printout.
-/

/-- info: 'EulerFactorChain.symbol_of_backward_difference' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms EulerFactorChain.symbol_of_backward_difference

/-- info: 'EulerFactorChain.euler_product_riemannZeta' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms EulerFactorChain.euler_product_riemannZeta

/-- info: 'EulerFactorChain.sym_natCast' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms EulerFactorChain.sym_natCast

/-- info: 'EulerFactorChain.euler_product_sym' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms EulerFactorChain.euler_product_sym

/-- info: 'EulerFactorChain.h_functional_equation' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms EulerFactorChain.h_functional_equation

/-- info: 'EulerFactorChain.h_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms EulerFactorChain.h_zero

/-- info: 'EulerFactorChain.h_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms EulerFactorChain.h_one

/-- info: 'EulerFactorChain.conj_factor_on_critical_line' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms EulerFactorChain.conj_factor_on_critical_line

/-- info: 'EulerFactorChain.h_eq_gain_pow_on_critical_line' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms EulerFactorChain.h_eq_gain_pow_on_critical_line

/-- info: 'EulerFactorChain.cpow_rect_on_critical_line' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms EulerFactorChain.cpow_rect_on_critical_line

/-- info: 'EulerFactorChain.gain_sq_on_critical_line' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms EulerFactorChain.gain_sq_on_critical_line

end EulerFactorChain
