/-
CellZeros — block T1 of `lean_stage3/design/joints.md`. 2026-11-22.

The cell as a sum over the zeros. For the row `ψ(2^n)` of the log-weighted
prime count along the doublings, the `d`-fold backward difference at `r` is
the main term `2^r·(1 − 1/2)^d` minus a sum over the zeros of ζ below a
height, each zero a mode `(2^ρ)^r` multiplied by the symbol `(1 − 2^(−ρ))`
once per depth, within a stated error. No RH.

  stencil                  Σ_{j ≤ d} (−1)^j·C(d,j)·a(r − j), on rows ℤ → ℂ
  stencil_mode             w ≠ 0 ⊢ stencil d (n ↦ w^n) r = w^r·(1 − w⁻¹)^d
  cpow_two_zpow            ((2:ℝ)^n : ℂ)^ρ = ((2:ℂ)^ρ)^n
  stencil_zeroPartialSum   the stencil passes through the sum over zeros
  norm_stencil_le          ‖stencil‖ ≤ Σ C(d,j)·(bound on the j-th row)
  cell_eq_zero_sum         16 ≤ 2^(r−d), 2 ≤ T ≤ (2^(r−d))²
                             ⊢ ‖stencil d (n ↦ ψ(2^n)) r − 2^r·(1 − 2⁻¹)^d
                                  + Σ' m(ρ)·((2^ρ)^r·(1 − (2^ρ)⁻¹)^d/ρ)‖
                               ≤ Σ_{j ≤ d} C(d,j)·E(2^(r−j), T)

`E` is the right side of `Glue.explicit_formula_split_num`.

What the next slice needs: the same statement with the table tree's
`Chain.Sym`, `Chain.mode` and `Superposition.modeSum` (the port), then T2, T3,
T4 of `SECTIONS.md`.

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.GlueNum

namespace CellZeros

open Finset

noncomputable section

/-- The `d`-fold backward difference of a row, read at `r`. -/
def stencil (d : ℕ) (a : ℤ → ℂ) (r : ℤ) : ℂ :=
  ∑ j ∈ range (d + 1), (-1 : ℂ) ^ j * (d.choose j : ℂ) * a (r - j)

/-- The stencil of a sum of two rows is the sum of their stencils. -/
theorem stencil_add (d : ℕ) (a b : ℤ → ℂ) (r : ℤ) :
    stencil d (fun n => a n + b n) r = stencil d a r + stencil d b r := by
  unfold stencil
  rw [← Finset.sum_add_distrib]
  exact Finset.sum_congr rfl (fun j _ => by ring)

/-- The stencil of a difference of two rows is the difference of their stencils. -/
theorem stencil_sub (d : ℕ) (a b : ℤ → ℂ) (r : ℤ) :
    stencil d (fun n => a n - b n) r = stencil d a r - stencil d b r := by
  unfold stencil
  rw [← Finset.sum_sub_distrib]
  exact Finset.sum_congr rfl (fun j _ => by ring)

/-- The stencil of a row multiplied by a constant `c` is `c` times the stencil of the row. -/
theorem stencil_const_mul (d : ℕ) (c : ℂ) (a : ℤ → ℂ) (r : ℤ) :
    stencil d (fun n => c * a n) r = c * stencil d a r := by
  unfold stencil
  rw [Finset.mul_sum]
  exact Finset.sum_congr rfl (fun j _ => by ring)

/-- The stencil of a finite sum of rows is the sum of the stencils of the rows. -/
theorem stencil_sum {ι : Type*} (d : ℕ) (s : Finset ι) (f : ι → ℤ → ℂ) (r : ℤ) :
    stencil d (fun n => ∑ i ∈ s, f i n) r = ∑ i ∈ s, stencil d (f i) r := by
  unfold stencil
  simp_rw [Finset.mul_sum]
  rw [Finset.sum_comm]

/-- **On a mode the stencil is the symbol to the `d`.** -/
theorem stencil_mode {w : ℂ} (hw : w ≠ 0) (d : ℕ) (r : ℤ) :
    stencil d (fun n : ℤ => w ^ n) r = w ^ r * (1 - w⁻¹) ^ d := by
  unfold stencil
  have h : ∀ j ∈ range (d + 1), (-1 : ℂ) ^ j * (d.choose j : ℂ) * w ^ (r - (j : ℤ))
      = w ^ r * ((-w⁻¹) ^ j * 1 ^ (d - j) * (d.choose j : ℂ)) := by
    intro j _
    have hinv : (-w⁻¹) ^ j = (-1 : ℂ) ^ j * (w ^ j)⁻¹ := by rw [neg_pow, inv_pow]
    rw [zpow_sub₀ hw, zpow_natCast, hinv, one_pow, div_eq_mul_inv]
    ring
  rw [Finset.sum_congr rfl h, ← Finset.mul_sum, ← add_pow]
  congr 1
  ring

/-- If the row entry at `r - j` has norm at most `B j` for each `j ≤ d`, then the norm of the
stencil at `r` is at most `Σ_{j ≤ d} C(d,j)·B j`. -/
theorem norm_stencil_le (d : ℕ) (a : ℤ → ℂ) (r : ℤ) (B : ℕ → ℝ)
    (h : ∀ j ∈ range (d + 1), ‖a (r - j)‖ ≤ B j) :
    ‖stencil d a r‖ ≤ ∑ j ∈ range (d + 1), (d.choose j : ℝ) * B j := by
  unfold stencil
  refine le_trans (norm_sum_le _ _) (Finset.sum_le_sum fun j hj => ?_)
  rw [norm_mul, norm_mul, norm_pow, norm_neg, norm_one, one_pow, one_mul,
    Complex.norm_natCast]
  exact mul_le_mul_of_nonneg_left (h j hj) (Nat.cast_nonneg _)

/-- For an integer `n` and complex `ρ`, the real number `2^n` raised to `ρ` equals `(2^ρ)^n`. -/
theorem cpow_two_zpow (n : ℤ) (ρ : ℂ) :
    (((2:ℝ) ^ n : ℝ) : ℂ) ^ ρ = ((2:ℂ) ^ ρ) ^ n := by
  have hpos : (0:ℝ) < (2:ℝ) ^ n := zpow_pos (by norm_num) n
  have hne : (((2:ℝ) ^ n : ℝ) : ℂ) ≠ 0 := by exact_mod_cast hpos.ne'
  have h2 : Complex.log 2 = ((Real.log 2 : ℝ) : ℂ) := by
    rw [Complex.ofReal_log (by norm_num)]
    norm_num
  rw [Complex.cpow_def_of_ne_zero hne, Complex.cpow_def_of_ne_zero (by norm_num : (2:ℂ) ≠ 0),
    ← Complex.exp_int_mul, ← Complex.ofReal_log hpos.le, Real.log_zpow, h2]
  congr 1
  push_cast
  ring

/-- Helper: the complex power `2^ρ` is nonzero for every complex `ρ`. -/
theorem two_cpow_ne_zero (ρ : ℂ) : (2:ℂ) ^ ρ ≠ 0 := by
  rw [Complex.cpow_def_of_ne_zero (by norm_num : (2:ℂ) ≠ 0)]
  exact Complex.exp_ne_zero _

/-- **The stencil passes through the sum over the zeros.** -/
theorem stencil_zeroPartialSum (d : ℕ) (r : ℤ) (T : ℝ) :
    stencil d (fun n : ℤ => Stage3.zeroPartialSum ((2:ℝ) ^ n) T) r
      = ∑' ρ : {ρ : Kadiri.NontrivialZeros // |(ρ : ℂ).im| < T},
          ((riemannZeta.order ((ρ : Kadiri.NontrivialZeros) : ℂ) : ℤ) : ℂ)
            * (((2:ℂ) ^ ((ρ : Kadiri.NontrivialZeros) : ℂ)) ^ r
                * (1 - ((2:ℂ) ^ ((ρ : Kadiri.NontrivialZeros) : ℂ))⁻¹) ^ d
                / ((ρ : Kadiri.NontrivialZeros) : ℂ)) := by
  classical
  haveI : Fintype {ρ : Kadiri.NontrivialZeros // |(ρ : ℂ).im| < T} :=
    (Kadiri.nontrivialZeros_abs_im_lt_finite T).fintype
  unfold Stage3.zeroPartialSum
  simp_rw [tsum_fintype, cpow_two_zpow]
  rw [stencil_sum]
  refine Finset.sum_congr rfl fun ρ _ => ?_
  have hf : (fun n : ℤ => ((riemannZeta.order ((ρ : Kadiri.NontrivialZeros) : ℂ) : ℤ) : ℂ)
        * (((2:ℂ) ^ ((ρ : Kadiri.NontrivialZeros) : ℂ)) ^ n / ((ρ : Kadiri.NontrivialZeros) : ℂ)))
      = fun n : ℤ => (((riemannZeta.order ((ρ : Kadiri.NontrivialZeros) : ℂ) : ℤ) : ℂ)
          / ((ρ : Kadiri.NontrivialZeros) : ℂ)) * ((2:ℂ) ^ ((ρ : Kadiri.NontrivialZeros) : ℂ)) ^ n := by
    funext n
    ring
  rw [hf, stencil_const_mul, stencil_mode (two_cpow_ne_zero _)]
  ring

/-- **The cell as a sum over the zeros.** -/
theorem cell_eq_zero_sum (d : ℕ) (r : ℤ) {T : ℝ} (h16 : 16 ≤ (2:ℝ) ^ (r - (d : ℤ)))
    (hT : 2 ≤ T) (hTx : T ≤ ((2:ℝ) ^ (r - (d : ℤ))) ^ 2) :
    ‖stencil d (fun n : ℤ => (Chebyshev.psi ((2:ℝ) ^ n) : ℂ)) r
        - (2:ℂ) ^ r * (1 - (2:ℂ)⁻¹) ^ d
        + ∑' ρ : {ρ : Kadiri.NontrivialZeros // |(ρ : ℂ).im| < T},
            ((riemannZeta.order ((ρ : Kadiri.NontrivialZeros) : ℂ) : ℤ) : ℂ)
              * (((2:ℂ) ^ ((ρ : Kadiri.NontrivialZeros) : ℂ)) ^ r
                  * (1 - ((2:ℂ) ^ ((ρ : Kadiri.NontrivialZeros) : ℂ))⁻¹) ^ d
                  / ((ρ : Kadiri.NontrivialZeros) : ℂ))‖
      ≤ ∑ j ∈ range (d + 1), (d.choose j : ℝ)
          * (Glue.c1n * (2:ℝ) ^ (r - (j : ℤ)) * Real.log ((2:ℝ) ^ (r - (j : ℤ)) * T) ^ 2 / T
              + Glue.c3n * Real.log ((2:ℝ) ^ (r - (j : ℤ)))
              + Glue.c4n * ((Real.log ((2:ℝ) ^ (r - (j : ℤ)))) ^ 2
                  * ((2:ℝ) ^ (r - (j : ℤ))) ^ (-(1:ℝ) / 4))) := by
  have hmain : stencil d (fun n : ℤ => (((2:ℝ) ^ n : ℝ) : ℂ)) r
      = (2:ℂ) ^ r * (1 - (2:ℂ)⁻¹) ^ d := by
    have hfun : (fun n : ℤ => (((2:ℝ) ^ n : ℝ) : ℂ)) = fun n : ℤ => (2:ℂ) ^ n := by
      funext n
      push_cast
      rfl
    rw [hfun, stencil_mode (by norm_num)]
  have hkey : stencil d (fun n : ℤ => (Chebyshev.psi ((2:ℝ) ^ n) : ℂ)) r
        - (2:ℂ) ^ r * (1 - (2:ℂ)⁻¹) ^ d
        + ∑' ρ : {ρ : Kadiri.NontrivialZeros // |(ρ : ℂ).im| < T},
            ((riemannZeta.order ((ρ : Kadiri.NontrivialZeros) : ℂ) : ℤ) : ℂ)
              * (((2:ℂ) ^ ((ρ : Kadiri.NontrivialZeros) : ℂ)) ^ r
                  * (1 - ((2:ℂ) ^ ((ρ : Kadiri.NontrivialZeros) : ℂ))⁻¹) ^ d
                  / ((ρ : Kadiri.NontrivialZeros) : ℂ))
      = stencil d (fun n : ℤ => ((Chebyshev.psi ((2:ℝ) ^ n) : ℂ) - (((2:ℝ) ^ n : ℝ) : ℂ))
          + Stage3.zeroPartialSum ((2:ℝ) ^ n) T) r := by
    rw [stencil_add, stencil_sub, hmain, stencil_zeroPartialSum]
  rw [hkey]
  refine norm_stencil_le d _ r _ (fun j hj => ?_)
  have hjd : (j : ℤ) ≤ (d : ℤ) := by
    exact_mod_cast Nat.lt_succ_iff.mp (Finset.mem_range.mp hj)
  have hmono : (2:ℝ) ^ (r - (d : ℤ)) ≤ (2:ℝ) ^ (r - (j : ℤ)) :=
    zpow_le_zpow_right₀ (by norm_num) (by linarith)
  have hx16 : (16:ℝ) ≤ (2:ℝ) ^ (r - (j : ℤ)) := le_trans h16 hmono
  have hTj : T ≤ ((2:ℝ) ^ (r - (j : ℤ))) ^ 2 := by
    refine le_trans hTx ?_
    exact pow_le_pow_left₀ (by positivity) hmono 2
  exact Glue.explicit_formula_split_num _ T hx16 hT hTj

end

/-- info: 'CellZeros.stencil_mode' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms stencil_mode

/-- info: 'CellZeros.stencil_zeroPartialSum' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms stencil_zeroPartialSum

/-- info: 'CellZeros.cell_eq_zero_sum' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms cell_eq_zero_sum

end CellZeros
