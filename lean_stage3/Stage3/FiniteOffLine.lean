/-
FiniteOffLine — block J10d of `lean_stage3/design/joints.md`. 2026-11-22.

The one-ladder converse, in the case of finitely many zeros off the line.
Let a finite set hold every zero of ζ off the line. If at one depth the cells
of the log-weighted prime count on the table's own ladder stay within
`C·r²·√2^r` of their main term, then no zero is off the line.

The proof. `CellZeros.cell_eq_zero_sum` writes the cell as its main term minus
a sum over the zeros below a height, with a stated error. Take the height
`2^(r−d)`. The error is at most a constant times `r²`. The zeros on the line
contribute at most `2^d·√2^r·Σ m/|ρ|`, and that sum is at most a constant times
`r²` by the count of zeros (`sum_order_onLineInv_le`, `dyadic_count_le`). The
finitely many zeros off the line with real part below the largest one `β`
contribute `o(2^(rβ))`. So the zeros with real part `β` contribute `o(2^(rβ))`,
which `LadderFading.line_not_fading` forbids.

  ZF, mem_ZF, tsum_sub_eq_sum    the zeros below a height as a finite set
  onLineInv                      1/|ρ| on the line, 0 off it
  onLineInv_le_dyadic            a zero on the line under the dyadic weights
  sum_order_onLineInv_le         Σ m·onLineInv below 2^(K+1) ≤ the dyadic count
  dyadic_count_le                the dyadic count ≤ 3000·(K+2)²
  term, norm_term_le             one zero's term in the cell, and its size
  cell_zero_sum_finset           `cell_eq_zero_sum` over the finite set
  err_le                         the error at height 2^(K+1) ≤ const·r²
  finite_off_line                F finite ⊇ the zeros off the line, the cells at
                                   depth d within C·r²·√2^r ⊢ RiemannHypothesis

What the next slice needs: the same with infinitely many zeros off the line.
Unit 0431 holds where that stops.

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.LadderMean
import Stage3.CellModes
import Stage3.AssemblyFloor
import Stage3.RealSegment
import Stage3.LandauWindow

namespace FiniteOffLine

open Finset Filter Topology Kadiri

noncomputable section

/-- The zeros below a height, as a finite set. -/
def ZF (T : ℝ) : Finset NontrivialZeros := (nontrivialZeros_abs_im_lt_finite T).toFinset

theorem mem_ZF {T : ℝ} {ρ : NontrivialZeros} : ρ ∈ ZF T ↔ |(ρ : ℂ).im| < T := by
  simp [ZF]

/-- A sum over the zeros below a height, read over the finite set. -/
theorem tsum_sub_eq_sum {E : Type*} [AddCommMonoid E] [TopologicalSpace E] (T : ℝ)
    (f : NontrivialZeros → E) :
    ∑' σ : {ρ : NontrivialZeros // |(ρ : ℂ).im| < T}, f σ.1 = ∑ ρ ∈ ZF T, f ρ := by
  classical
  haveI : Fintype {ρ : NontrivialZeros // |(ρ : ℂ).im| < T} :=
    (nontrivialZeros_abs_im_lt_finite T).fintype
  rw [tsum_fintype]
  exact (Finset.sum_subtype (ZF T) (fun x => mem_ZF) f).symm

theorem order_nonneg (ρ : NontrivialZeros) : (0 : ℝ) ≤ ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) := by
  exact_mod_cast riemannZeta_order_nonneg (nontrivialZero_ne_one ρ)

/-- The reciprocal size of a zero on the line; zero off the line. -/
def onLineInv (ρ : NontrivialZeros) : ℝ := if (ρ : ℂ).re = 1 / 2 then ‖(ρ : ℂ)‖⁻¹ else 0

theorem onLineInv_nonneg (ρ : NontrivialZeros) : 0 ≤ onLineInv ρ := by
  unfold onLineInv
  split_ifs
  · positivity
  · exact le_rfl

/-- A zero on the line, below `2^(K+1)`, is dominated by the dyadic weights. -/
theorem onLineInv_le_dyadic (ρ : NontrivialZeros) (K : ℕ) (him : |(ρ : ℂ).im| < 2 ^ (K + 1)) :
    onLineInv ρ ≤ 2 * ∑ j ∈ range (K + 1),
      ((2 : ℝ) ^ j)⁻¹ * (if |(ρ : ℂ).im| < 2 ^ (j + 1) then 1 else 0) := by
  have hSnn : (0 : ℝ) ≤ ∑ j ∈ range (K + 1),
      ((2 : ℝ) ^ j)⁻¹ * (if |(ρ : ℂ).im| < 2 ^ (j + 1) then 1 else 0) := by
    apply Finset.sum_nonneg
    intro j _
    have : (0 : ℝ) ≤ (if |(ρ : ℂ).im| < 2 ^ (j + 1) then (1 : ℝ) else 0) := by
      split <;> norm_num
    positivity
  unfold onLineInv
  split_ifs with hre
  · have hhalf : (1 : ℝ) / 2 ≤ ‖(ρ : ℂ)‖ := by
      calc (1 : ℝ) / 2 = |(ρ : ℂ).re| := by rw [hre]; norm_num
        _ ≤ ‖(ρ : ℂ)‖ := Complex.abs_re_le_norm _
    have hρpos : 0 < ‖(ρ : ℂ)‖ := by linarith
    by_cases hγ : 1 ≤ |(ρ : ℂ).im|
    · have hd := Stage3.inv_le_dyadic_sum K _ hγ him
      have hinv : ‖(ρ : ℂ)‖⁻¹ ≤ |(ρ : ℂ).im|⁻¹ :=
        inv_anti₀ (by linarith) (Complex.abs_im_le_norm _)
      linarith
    · rw [not_le] at hγ
      have hS1 : (1 : ℝ) ≤ ∑ j ∈ range (K + 1),
          ((2 : ℝ) ^ j)⁻¹ * (if |(ρ : ℂ).im| < 2 ^ (j + 1) then 1 else 0) := by
        have h0mem : (0 : ℕ) ∈ range (K + 1) := by simp
        have h0term : ((2 : ℝ) ^ (0 : ℕ))⁻¹
            * (if |(ρ : ℂ).im| < 2 ^ (0 + 1) then (1 : ℝ) else 0) = 1 := by
          rw [if_pos (by norm_num; linarith), pow_zero, inv_one, mul_one]
        calc (1 : ℝ) = ((2 : ℝ) ^ (0 : ℕ))⁻¹
              * (if |(ρ : ℂ).im| < 2 ^ (0 + 1) then (1 : ℝ) else 0) := h0term.symm
          _ ≤ _ := by
              apply Finset.single_le_sum (f := fun j => ((2 : ℝ) ^ j)⁻¹
                * (if |(ρ : ℂ).im| < 2 ^ (j + 1) then (1 : ℝ) else 0)) _ h0mem
              intro j _
              have : (0 : ℝ) ≤ (if |(ρ : ℂ).im| < 2 ^ (j + 1) then (1 : ℝ) else 0) := by
                split <;> norm_num
              positivity
      have h2 : ‖(ρ : ℂ)‖⁻¹ ≤ 2 := by
        rw [inv_le_comm₀ hρpos (by norm_num)]
        linarith
      linarith
  · linarith

/-- **The zeros on the line, weighted by reciprocal size, below a height.** -/
theorem sum_order_onLineInv_le (K : ℕ) :
    ∑ ρ ∈ ZF ((2 : ℝ) ^ (K + 1)), ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) * onLineInv ρ
      ≤ 2 * ∑ j ∈ range (K + 1), ((2 : ℝ) ^ j)⁻¹
          * (2 * |riemannZeta.N ((2 : ℝ) ^ (j + 1))| + weightedZeroHeightBucket) := by
  classical
  have hterm : ∀ ρ ∈ ZF ((2 : ℝ) ^ (K + 1)),
      ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) * onLineInv ρ
        ≤ ∑ j ∈ range (K + 1), 2 * (((2 : ℝ) ^ j)⁻¹
            * (((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ)
              * (if |(ρ : ℂ).im| < 2 ^ (j + 1) then 1 else 0))) := by
    intro ρ hρ
    have h := onLineInv_le_dyadic ρ K (mem_ZF.mp hρ)
    calc ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) * onLineInv ρ
        ≤ ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) * (2 * ∑ j ∈ range (K + 1),
            ((2 : ℝ) ^ j)⁻¹ * (if |(ρ : ℂ).im| < 2 ^ (j + 1) then 1 else 0)) :=
          mul_le_mul_of_nonneg_left h (order_nonneg ρ)
      _ = _ := by
          rw [Finset.mul_sum, Finset.mul_sum]
          exact Finset.sum_congr rfl fun j _ => by ring
  refine le_trans (Finset.sum_le_sum hterm) ?_
  rw [Finset.sum_comm, Finset.mul_sum]
  refine Finset.sum_le_sum fun j hj => ?_
  have hjK : j ≤ K := Nat.lt_succ_iff.mp (Finset.mem_range.mp hj)
  have hle : (2 : ℝ) ^ (j + 1) ≤ (2 : ℝ) ^ (K + 1) :=
    pow_le_pow_right₀ (by norm_num) (by omega)
  have hinner : (∑ ρ ∈ ZF ((2 : ℝ) ^ (K + 1)), ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ)
        * (if |(ρ : ℂ).im| < 2 ^ (j + 1) then 1 else 0))
      = ∑ ρ ∈ ZF ((2 : ℝ) ^ (j + 1)), ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) := by
    simp only [mul_ite, mul_one, mul_zero]
    rw [← Finset.sum_filter]
    congr 1
    ext ρ
    simp only [Finset.mem_filter, mem_ZF]
    exact ⟨fun h => h.2, fun h => ⟨lt_of_lt_of_le h hle, h⟩⟩
  have hc : ∑ ρ ∈ ZF ((2 : ℝ) ^ (j + 1)), ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ)
      ≤ 2 * |riemannZeta.N ((2 : ℝ) ^ (j + 1))| + weightedZeroHeightBucket :=
    (tsum_sub_eq_sum ((2 : ℝ) ^ (j + 1))
      (fun ρ : NontrivialZeros => ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ))).symm.le.trans
      (weighted_cumulative_count_le (k := j))
  calc (∑ ρ ∈ ZF ((2 : ℝ) ^ (K + 1)), 2 * (((2 : ℝ) ^ j)⁻¹
          * (((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ)
            * (if |(ρ : ℂ).im| < 2 ^ (j + 1) then 1 else 0))))
      = 2 * (((2 : ℝ) ^ j)⁻¹ * ∑ ρ ∈ ZF ((2 : ℝ) ^ (K + 1)),
          ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ)
            * (if |(ρ : ℂ).im| < 2 ^ (j + 1) then 1 else 0)) := by
        rw [Finset.mul_sum, Finset.mul_sum]
    _ = 2 * (((2 : ℝ) ^ j)⁻¹
          * ∑ ρ ∈ ZF ((2 : ℝ) ^ (j + 1)), ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ)) := by
        rw [hinner]
    _ ≤ 2 * (((2 : ℝ) ^ j)⁻¹
          * (2 * |riemannZeta.N ((2 : ℝ) ^ (j + 1))| + weightedZeroHeightBucket)) :=
        mul_le_mul_of_nonneg_left
          (mul_le_mul_of_nonneg_left hc (by positivity)) (by norm_num)

/-- The dyadic count, as a square of the number of levels. -/
theorem dyadic_count_le (K : ℕ) :
    ∑ j ∈ range (K + 1), ((2 : ℝ) ^ j)⁻¹
        * (2 * |riemannZeta.N ((2 : ℝ) ^ (j + 1))| + weightedZeroHeightBucket)
      ≤ 3000 * ((K : ℝ) + 2) ^ 2 := by
  rw [Stage3.weightedZeroHeightBucket_eq_zero]
  have hRvM2 : 0 ≤ riemannZeta.RvM 112 0 698 2 := by
    unfold riemannZeta.RvM
    have := Real.log_nonneg (show (1 : ℝ) ≤ 2 by norm_num)
    linarith
  have hD := Stage3.dyadic_abs_N_sum_le (by norm_num) le_rfl hRvM2 ArgCount.rvM_crude K
  have hsum : (∑ j ∈ range (K + 1), ((2 : ℝ) ^ j)⁻¹
        * (2 * |riemannZeta.N ((2 : ℝ) ^ (j + 1))| + 0))
      = 2 * ∑ j ∈ range (K + 1), ((2 : ℝ) ^ j)⁻¹ * |riemannZeta.N ((2 : ℝ) ^ (j + 1))| := by
    rw [Finset.mul_sum]
    exact Finset.sum_congr rfl fun j _ => by ring
  rw [hsum]
  have hK : (0 : ℝ) ≤ K := Nat.cast_nonneg K
  have hl2 : Real.log 2 ≤ 1 := by
    have := Real.log_two_lt_d9
    linarith
  have hl0 : 0 ≤ Real.log 2 := Real.log_nonneg (by norm_num)
  have hπ : (3 : ℝ) < Real.pi := Real.pi_gt_three
  have hR : riemannZeta.RvM 112 0 698 ((2 : ℝ) ^ (K + 1)) ≤ 112 * ((K : ℝ) + 1) + 698 := by
    unfold riemannZeta.RvM
    have hl : Real.log ((2 : ℝ) ^ (K + 1)) = ((K : ℝ) + 1) * Real.log 2 := by
      rw [Real.log_pow]
      push_cast
      ring
    rw [hl]
    nlinarith [mul_nonneg (by linarith : (0 : ℝ) ≤ (K : ℝ) + 1) (sub_nonneg.mpr hl2)]
  have ha : Real.log 2 / (2 * Real.pi) ≤ 1 := by
    rw [div_le_one (by positivity)]
    linarith
  have ha0 : 0 ≤ Real.log 2 / (2 * Real.pi) := by positivity
  have h1 : Real.log 2 / (2 * Real.pi) * (K + 1) * (K + 2) ≤ ((K : ℝ) + 1) * (K + 2) := by
    have : Real.log 2 / (2 * Real.pi) * ((K + 1) * (K + 2)) ≤ 1 * (((K : ℝ) + 1) * (K + 2)) :=
      mul_le_mul_of_nonneg_right ha (by positivity)
    linarith
  have h2 : 3 * ((K : ℝ) + 1) / Real.pi ≤ (K : ℝ) + 1 := by
    rw [div_le_iff₀ (by positivity)]
    nlinarith
  nlinarith

/-- One zero's term in the cell `(r, d)` of the log-weighted count. -/
def term (d : ℕ) (r : ℤ) (ρ : NontrivialZeros) : ℂ :=
  ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ)
    * (((2:ℂ) ^ (ρ : ℂ)) ^ r * (1 - ((2:ℂ) ^ (ρ : ℂ))⁻¹) ^ d / (ρ : ℂ))

theorem norm_two_cpow (ρ : ℂ) : ‖(2:ℂ) ^ ρ‖ = (2:ℝ) ^ ρ.re := by
  have h2 : ((2 : ℂ)) = ((2 : ℝ) : ℂ) := by norm_num
  rw [h2, Complex.norm_cpow_eq_rpow_re_of_pos (by norm_num)]

/-- The size of one zero's term: its order over its size, times the mode's size. -/
theorem norm_term_le (d : ℕ) (r : ℕ) (ρ : NontrivialZeros) :
    ‖term d (r : ℤ) ρ‖ ≤ ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ)
      * (2 ^ d * ((2:ℝ) ^ (ρ : ℂ).re) ^ r * ‖(ρ : ℂ)‖⁻¹) := by
  unfold term
  have hre : 0 < (ρ : ℂ).re := ρ.2.1.1
  have hw : ‖(2:ℂ) ^ (ρ : ℂ)‖ = (2:ℝ) ^ (ρ : ℂ).re := norm_two_cpow _
  have hw1 : (1:ℝ) ≤ (2:ℝ) ^ (ρ : ℂ).re := Real.one_le_rpow (by norm_num) hre.le
  have hs : ‖1 - ((2:ℂ) ^ (ρ : ℂ))⁻¹‖ ≤ 2 := by
    have h1 : ‖1 - ((2:ℂ) ^ (ρ : ℂ))⁻¹‖ ≤ ‖(1:ℂ)‖ + ‖((2:ℂ) ^ (ρ : ℂ))⁻¹‖ := norm_sub_le _ _
    rw [norm_one, norm_inv, hw] at h1
    linarith [inv_le_one_of_one_le₀ hw1]
  rw [norm_mul, norm_div, norm_mul, norm_zpow, norm_pow, hw, zpow_natCast, Complex.norm_intCast,
    abs_of_nonneg (order_nonneg ρ)]
  apply mul_le_mul_of_nonneg_left _ (order_nonneg ρ)
  rw [div_eq_mul_inv]
  have hpd : ‖1 - ((2:ℂ) ^ (ρ : ℂ))⁻¹‖ ^ d ≤ 2 ^ d := pow_le_pow_left₀ (norm_nonneg _) hs d
  have hq : 0 ≤ ((2:ℝ) ^ (ρ : ℂ).re) ^ r := by positivity
  have h3 : ((2:ℝ) ^ (ρ : ℂ).re) ^ r * ‖1 - ((2:ℂ) ^ (ρ : ℂ))⁻¹‖ ^ d
      ≤ 2 ^ d * ((2:ℝ) ^ (ρ : ℂ).re) ^ r := by
    rw [mul_comm]
    exact mul_le_mul_of_nonneg_right hpd hq
  exact mul_le_mul_of_nonneg_right h3 (by positivity)

/-- The cell as a sum over the zeros below a height, read over the finite set. -/
theorem cell_zero_sum_finset (d : ℕ) (r : ℤ) {T : ℝ} (h16 : 16 ≤ (2:ℝ) ^ (r - (d : ℤ)))
    (hT : 2 ≤ T) (hTx : T ≤ ((2:ℝ) ^ (r - (d : ℤ))) ^ 2) :
    ‖CellZeros.stencil d (fun n : ℤ => (Chebyshev.psi ((2:ℝ) ^ n) : ℂ)) r
        - (2:ℂ) ^ r * (1 - (2:ℂ)⁻¹) ^ d + ∑ ρ ∈ ZF T, term d r ρ‖
      ≤ ∑ j ∈ range (d + 1), (d.choose j : ℝ)
          * (Glue.c1n * (2:ℝ) ^ (r - (j : ℤ)) * Real.log ((2:ℝ) ^ (r - (j : ℤ)) * T) ^ 2 / T
              + Glue.c3n * Real.log ((2:ℝ) ^ (r - (j : ℤ)))
              + Glue.c4n * ((Real.log ((2:ℝ) ^ (r - (j : ℤ)))) ^ 2
                  * ((2:ℝ) ^ (r - (j : ℤ))) ^ (-(1:ℝ) / 4))) := by
  rw [← tsum_sub_eq_sum T (term d r)]
  exact CellZeros.cell_eq_zero_sum d r h16 hT hTx

/-- The error of the cell's zero sum at height `2^(K+1)`, `r = d + K + 1`: at
most a constant times `r²`. -/
theorem err_le (d K r : ℕ) (hr : r = d + K + 1) :
    ∑ j ∈ range (d + 1), (d.choose j : ℝ)
        * (Glue.c1n * (2:ℝ) ^ ((r : ℤ) - (j : ℤ))
              * Real.log ((2:ℝ) ^ ((r : ℤ) - (j : ℤ)) * (2:ℝ) ^ (K + 1)) ^ 2 / (2:ℝ) ^ (K + 1)
            + Glue.c3n * Real.log ((2:ℝ) ^ ((r : ℤ) - (j : ℤ)))
            + Glue.c4n * ((Real.log ((2:ℝ) ^ ((r : ℤ) - (j : ℤ)))) ^ 2
                * ((2:ℝ) ^ ((r : ℤ) - (j : ℤ))) ^ (-(1:ℝ) / 4)))
      ≤ 2 ^ d * ((4 * 2 ^ d * Glue.c1n + Glue.c3n + Glue.c4n) * (r : ℝ) ^ 2) := by
  have hc1 := Glue.c1n_nonneg
  have hc3 := Glue.c3n_nonneg
  have hc4 := Glue.c4n_nonneg
  have hl2 : Real.log 2 ≤ 1 := by
    have := Real.log_two_lt_d9
    linarith
  have hl0 : 0 ≤ Real.log 2 := Real.log_nonneg (by norm_num)
  have hr1 : (1 : ℝ) ≤ (r : ℝ) := by exact_mod_cast (by omega : 1 ≤ r)
  have hrr : (r : ℝ) ≤ (r : ℝ) ^ 2 := by nlinarith
  have hTpos : (0 : ℝ) < (2:ℝ) ^ (K + 1) := by positivity
  have hT1 : (1 : ℝ) ≤ (2:ℝ) ^ (K + 1) := one_le_pow₀ (by norm_num)
  have each : ∀ j ∈ range (d + 1),
      Glue.c1n * (2:ℝ) ^ ((r : ℤ) - (j : ℤ))
            * Real.log ((2:ℝ) ^ ((r : ℤ) - (j : ℤ)) * (2:ℝ) ^ (K + 1)) ^ 2 / (2:ℝ) ^ (K + 1)
          + Glue.c3n * Real.log ((2:ℝ) ^ ((r : ℤ) - (j : ℤ)))
          + Glue.c4n * ((Real.log ((2:ℝ) ^ ((r : ℤ) - (j : ℤ)))) ^ 2
              * ((2:ℝ) ^ ((r : ℤ) - (j : ℤ))) ^ (-(1:ℝ) / 4))
        ≤ (4 * 2 ^ d * Glue.c1n + Glue.c3n + Glue.c4n) * (r : ℝ) ^ 2 := by
    intro j hj
    have hjd : j ≤ d := Nat.lt_succ_iff.mp (Finset.mem_range.mp hj)
    have e : ((r : ℤ) - (j : ℤ)) = ((r - j : ℕ) : ℤ) := by omega
    rw [e, zpow_natCast]
    set x : ℝ := (2:ℝ) ^ (r - j) with hx
    have hx1 : (1 : ℝ) ≤ x := one_le_pow₀ (by norm_num)
    have hx0 : (0 : ℝ) < x := by linarith
    have hxr : x ≤ (2:ℝ) ^ r := pow_le_pow_right₀ (by norm_num) (Nat.sub_le r j)
    have hTx : (2:ℝ) ^ (K + 1) ≤ x := pow_le_pow_right₀ (by norm_num) (by omega)
    have h2dT : (2:ℝ) ^ d * (2:ℝ) ^ (K + 1) = (2:ℝ) ^ r := by
      rw [← pow_add]
      congr 1
      omega
    have hlogx0 : 0 ≤ Real.log x := Real.log_nonneg hx1
    have hlogxr : Real.log x ≤ (r : ℝ) := by
      have h1 : Real.log x ≤ Real.log ((2:ℝ) ^ r) := Real.log_le_log hx0 hxr
      have h2 : Real.log ((2:ℝ) ^ r) = (r : ℝ) * Real.log 2 := by rw [Real.log_pow]
      nlinarith
    have hlogT0 : 0 ≤ Real.log ((2:ℝ) ^ (K + 1)) := Real.log_nonneg hT1
    have hlogTx : Real.log ((2:ℝ) ^ (K + 1)) ≤ Real.log x := Real.log_le_log hTpos hTx
    have hL : Real.log (x * (2:ℝ) ^ (K + 1)) = Real.log x + Real.log ((2:ℝ) ^ (K + 1)) :=
      Real.log_mul hx0.ne' hTpos.ne'
    have hL0 : 0 ≤ Real.log (x * (2:ℝ) ^ (K + 1)) := by rw [hL]; linarith
    have hL2 : Real.log (x * (2:ℝ) ^ (K + 1)) ^ 2 ≤ 4 * (r : ℝ) ^ 2 := by
      have h1 : Real.log (x * (2:ℝ) ^ (K + 1)) ≤ 2 * (r : ℝ) := by rw [hL]; linarith
      nlinarith
    have t1 : Glue.c1n * x * Real.log (x * (2:ℝ) ^ (K + 1)) ^ 2 / (2:ℝ) ^ (K + 1)
        ≤ 4 * 2 ^ d * Glue.c1n * (r : ℝ) ^ 2 := by
      rw [div_le_iff₀ hTpos]
      have hx2 : x ≤ (2:ℝ) ^ d * (2:ℝ) ^ (K + 1) := by rw [h2dT]; exact hxr
      have h1 : Glue.c1n * x ≤ Glue.c1n * ((2:ℝ) ^ d * (2:ℝ) ^ (K + 1)) :=
        mul_le_mul_of_nonneg_left hx2 hc1
      have h2 := mul_le_mul h1 hL2 (sq_nonneg _) (by positivity)
      calc Glue.c1n * x * Real.log (x * (2:ℝ) ^ (K + 1)) ^ 2
          ≤ Glue.c1n * ((2:ℝ) ^ d * (2:ℝ) ^ (K + 1)) * (4 * (r : ℝ) ^ 2) := h2
        _ = 4 * 2 ^ d * Glue.c1n * (r : ℝ) ^ 2 * (2:ℝ) ^ (K + 1) := by ring
    have t2 : Glue.c3n * Real.log x ≤ Glue.c3n * (r : ℝ) ^ 2 :=
      mul_le_mul_of_nonneg_left (by linarith) hc3
    have hx4 : x ^ (-(1:ℝ) / 4) ≤ 1 := Real.rpow_le_one_of_one_le_of_nonpos hx1 (by norm_num)
    have hx40 : 0 ≤ x ^ (-(1:ℝ) / 4) := Real.rpow_nonneg hx0.le _
    have hlx2 : Real.log x ^ 2 ≤ (r : ℝ) ^ 2 := by nlinarith
    have t3 : Glue.c4n * (Real.log x ^ 2 * x ^ (-(1:ℝ) / 4)) ≤ Glue.c4n * (r : ℝ) ^ 2 := by
      apply mul_le_mul_of_nonneg_left _ hc4
      calc Real.log x ^ 2 * x ^ (-(1:ℝ) / 4) ≤ (r : ℝ) ^ 2 * 1 :=
            mul_le_mul hlx2 hx4 hx40 (sq_nonneg _)
        _ = (r : ℝ) ^ 2 := by ring
    calc _ ≤ 4 * 2 ^ d * Glue.c1n * (r : ℝ) ^ 2 + Glue.c3n * (r : ℝ) ^ 2
            + Glue.c4n * (r : ℝ) ^ 2 := by linarith
      _ = _ := by ring
  have hch : (∑ j ∈ range (d + 1), (d.choose j : ℝ)) = 2 ^ d := by
    exact_mod_cast Nat.sum_range_choose d
  calc _ ≤ ∑ j ∈ range (d + 1), (d.choose j : ℝ)
          * ((4 * 2 ^ d * Glue.c1n + Glue.c3n + Glue.c4n) * (r : ℝ) ^ 2) :=
        Finset.sum_le_sum fun j hj => mul_le_mul_of_nonneg_left (each j hj) (Nat.cast_nonneg _)
    _ = _ := by rw [← Finset.sum_mul, hch]

/-- **Finitely many zeros off the line, and cells of square-root size on the one
ladder: then no zero is off the line.** Let a finite set hold every zero of ζ
off the line. If at one depth the cells of the log-weighted prime count on the
table's own ladder stay within `C·r²·√2^r` of their main term, the Riemann
hypothesis holds. -/
theorem finite_off_line (F : Finset NontrivialZeros)
    (hF : ∀ ρ : NontrivialZeros, (ρ : ℂ).re ≠ 1 / 2 → ρ ∈ F) (d : ℕ) (C : ℝ)
    (hcells : ∀ᶠ r : ℕ in atTop,
      ‖CellZeros.stencil d (fun n : ℤ => (Chebyshev.psi ((2:ℝ) ^ n) : ℂ)) (r : ℤ)
          - (2:ℂ) ^ (r : ℤ) * (1 - (2:ℂ)⁻¹) ^ d‖ ≤ C * (r : ℝ) ^ 2 * Real.sqrt 2 ^ r) :
    RiemannHypothesis := by
  classical
  apply LandauWindow.rh_of_zeroFree_half
  intro s hs hz
  have hs1 : s.re < 1 := by
    by_contra h
    exact riemannZeta_ne_zero_of_one_le_re (not_lt.mp h) hz
  let ρ₀ : NontrivialZeros := ⟨s, ⟨⟨by linarith, hs1⟩, Set.mem_univ _, hz⟩⟩
  have hρ₀F : ρ₀ ∈ F := hF ρ₀ (ne_of_gt hs)
  set F₁ := F.filter (fun ρ : NontrivialZeros => 1 / 2 < (ρ : ℂ).re) with hF₁
  have hF₁ne : F₁.Nonempty := ⟨ρ₀, Finset.mem_filter.mpr ⟨hρ₀F, hs⟩⟩
  obtain ⟨ρm, hρm, hmax⟩ :=
    Finset.exists_max_image F₁ (fun ρ : NontrivialZeros => (ρ : ℂ).re) hF₁ne
  set β := (ρm : ℂ).re with hβdef
  have hβ : 1 / 2 < β := (Finset.mem_filter.mp hρm).2
  have hle : ∀ ρ ∈ F, (ρ : ℂ).re ≤ β := by
    intro ρ hρ
    by_cases h : 1 / 2 < (ρ : ℂ).re
    · exact hmax ρ (Finset.mem_filter.mpr ⟨hρ, h⟩)
    · linarith
  set S := F.filter (fun ρ : NontrivialZeros => (ρ : ℂ).re = β) with hSdef
  have hSne : S.Nonempty :=
    ⟨ρm, Finset.mem_filter.mpr ⟨(Finset.mem_filter.mp hρm).1, rfl⟩⟩
  have hSF : S ⊆ F := Finset.filter_subset _ _
  have hSβ : ∀ ρ ∈ S, (ρ : ℂ).re = β := fun ρ hρ => (Finset.mem_filter.mp hρ).2
  set q : ℝ := (2:ℝ) ^ β with hq
  have hqpos : 0 < q := Real.rpow_pos_of_pos (by norm_num) β
  have hsq : Real.sqrt 2 < q := by
    rw [Real.sqrt_eq_rpow]
    exact Real.rpow_lt_rpow_of_exponent_lt (by norm_num) hβ
  have hq1 : 1 < q :=
    lt_of_le_of_lt (by rw [Real.one_le_sqrt]; norm_num : (1:ℝ) ≤ Real.sqrt 2) hsq
  set AE : ℝ := 2 ^ d * (4 * 2 ^ d * Glue.c1n + Glue.c3n + Glue.c4n) with hAE
  set AZ : ℝ := 2 ^ d * (2 * 3000) * 4 with hAZ
  -- the bound, as a function of the row
  have hG : (fun r : ℕ => C * ((r : ℝ) ^ 2 * Real.sqrt 2 ^ r) + AE * ((r : ℝ) ^ 2 * (1:ℝ) ^ r)
        + ∑ ρ ∈ F \ S, (((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) * (2 ^ d * ‖(ρ : ℂ)‖⁻¹))
            * ((2:ℝ) ^ (ρ : ℂ).re) ^ r
        + AZ * ((r : ℝ) ^ 2 * Real.sqrt 2 ^ r)) =o[atTop] fun r : ℕ => q ^ r := by
    have h1 : (fun r : ℕ => (r : ℝ) ^ 2 * Real.sqrt 2 ^ r) =o[atTop] fun r : ℕ => q ^ r :=
      isLittleO_pow_const_mul_const_pow_const_pow_of_norm_lt 2
        (by rw [Real.norm_of_nonneg (Real.sqrt_nonneg 2)]; exact hsq)
    have h0 : (fun r : ℕ => (r : ℝ) ^ 2 * (1:ℝ) ^ r) =o[atTop] fun r : ℕ => q ^ r :=
      isLittleO_pow_const_mul_const_pow_const_pow_of_norm_lt 2 (by rw [norm_one]; exact hq1)
    have hρ : ∀ ρ ∈ F \ S, (fun r : ℕ =>
        (((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) * (2 ^ d * ‖(ρ : ℂ)‖⁻¹))
          * ((2:ℝ) ^ (ρ : ℂ).re) ^ r) =o[atTop] fun r : ℕ => q ^ r := by
      intro ρ hρ
      have hρF := (Finset.mem_sdiff.mp hρ).1
      have hlt : (ρ : ℂ).re < β := lt_of_le_of_ne (hle ρ hρF)
        (fun h => (Finset.mem_sdiff.mp hρ).2 (Finset.mem_filter.mpr ⟨hρF, h⟩))
      exact (isLittleO_pow_pow_of_lt_left (by positivity)
        (Real.rpow_lt_rpow_of_exponent_lt (by norm_num) hlt)).const_mul_left _
    exact (((h1.const_mul_left C).add (h0.const_mul_left AE)).add
      (Asymptotics.IsLittleO.sum hρ)).add (h1.const_mul_left AZ)
  -- the bound holds from some row on
  have hbound : ∀ᶠ r : ℕ in atTop, ‖∑ ρ ∈ S, term d (r : ℤ) ρ‖
      ≤ C * ((r : ℝ) ^ 2 * Real.sqrt 2 ^ r) + AE * ((r : ℝ) ^ 2 * (1:ℝ) ^ r)
        + ∑ ρ ∈ F \ S, (((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) * (2 ^ d * ‖(ρ : ℂ)‖⁻¹))
            * ((2:ℝ) ^ (ρ : ℂ).re) ^ r
        + AZ * ((r : ℝ) ^ 2 * Real.sqrt 2 ^ r) := by
    filter_upwards [hcells,
      eventually_ge_atTop (d + 5 + ⌈∑ ρ ∈ F, |(ρ : ℂ).im|⌉₊)] with r hcell hr
    obtain ⟨K, hK⟩ : ∃ K : ℕ, r = d + K + 1 := ⟨r - d - 1, by omega⟩
    have hKM : ⌈∑ ρ ∈ F, |(ρ : ℂ).im|⌉₊ ≤ K := by omega
    have e : ((r : ℤ) - (d : ℤ)) = ((K + 1 : ℕ) : ℤ) := by omega
    have hpow : (2:ℝ) ^ ((r : ℤ) - (d : ℤ)) = (2:ℝ) ^ (K + 1) := by rw [e, zpow_natCast]
    have hT16 : (16:ℝ) ≤ (2:ℝ) ^ (K + 1) := by
      calc (16:ℝ) = 2 ^ 4 := by norm_num
        _ ≤ 2 ^ (K + 1) := pow_le_pow_right₀ (by norm_num) (by omega)
    have h' := cell_zero_sum_finset d (r : ℤ) (T := (2:ℝ) ^ (K + 1))
      (by rw [hpow]; exact hT16) (by linarith) (by rw [hpow]; nlinarith)
    have herr := err_le d K r hK
    have hFT : F ⊆ ZF ((2:ℝ) ^ (K + 1)) := by
      intro ρ hρ
      rw [mem_ZF]
      have h1 : |(ρ : ℂ).im| ≤ ∑ ρ ∈ F, |(ρ : ℂ).im| :=
        Finset.single_le_sum (f := fun ρ : NontrivialZeros => |(ρ : ℂ).im|)
          (fun _ _ => abs_nonneg _) hρ
      have h2 : ∑ ρ ∈ F, |(ρ : ℂ).im| ≤ (K : ℝ) :=
        (Nat.le_ceil _).trans (by exact_mod_cast hKM)
      have h3 : ((K + 1 : ℕ) : ℝ) < (2:ℝ) ^ (K + 1) := by
        exact_mod_cast (Nat.lt_two_pow_self : K + 1 < 2 ^ (K + 1))
      push_cast at h3
      linarith
    have hsplit : ∑ ρ ∈ ZF ((2:ℝ) ^ (K + 1)), term d (r : ℤ) ρ
        = ∑ ρ ∈ ZF ((2:ℝ) ^ (K + 1)) \ F, term d (r : ℤ) ρ
          + (∑ ρ ∈ F \ S, term d (r : ℤ) ρ + ∑ ρ ∈ S, term d (r : ℤ) ρ) := by
      rw [Finset.sum_sdiff hSF, Finset.sum_sdiff hFT]
    have hr1 : (1 : ℝ) ≤ (r : ℝ) := by exact_mod_cast (by omega : 1 ≤ r)
    have hrK : (K : ℝ) + 2 ≤ 2 * (r : ℝ) := by
      have : (r : ℝ) = (d : ℝ) + K + 1 := by exact_mod_cast hK
      have hd0 : (0 : ℝ) ≤ (d : ℝ) := Nat.cast_nonneg d
      linarith
    have hs2 : (0 : ℝ) ≤ Real.sqrt 2 ^ r := by positivity
    have hon : ‖∑ ρ ∈ ZF ((2:ℝ) ^ (K + 1)) \ F, term d (r : ℤ) ρ‖
        ≤ AZ * ((r : ℝ) ^ 2 * Real.sqrt 2 ^ r) := by
      have hterm : ∀ ρ ∈ ZF ((2:ℝ) ^ (K + 1)) \ F, ‖term d (r : ℤ) ρ‖
          ≤ 2 ^ d * Real.sqrt 2 ^ r
            * (((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) * onLineInv ρ) := by
        intro ρ hρ
        have hre : (ρ : ℂ).re = 1 / 2 := by
          by_contra h
          exact (Finset.mem_sdiff.mp hρ).2 (hF ρ h)
        have h1 := norm_term_le d r ρ
        rw [hre, ← Real.sqrt_eq_rpow] at h1
        have h2 : onLineInv ρ = ‖(ρ : ℂ)‖⁻¹ := by unfold onLineInv; rw [if_pos hre]
        rw [h2]
        linarith
      have hsum : ∑ ρ ∈ ZF ((2:ℝ) ^ (K + 1)) \ F,
            ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) * onLineInv ρ
          ≤ 2 * (3000 * ((K : ℝ) + 2) ^ 2) :=
        calc _ ≤ ∑ ρ ∈ ZF ((2:ℝ) ^ (K + 1)),
              ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) * onLineInv ρ :=
            Finset.sum_le_sum_of_subset_of_nonneg Finset.sdiff_subset
              (fun ρ _ _ => mul_nonneg (order_nonneg ρ) (onLineInv_nonneg ρ))
          _ ≤ _ := (sum_order_onLineInv_le K).trans
              (mul_le_mul_of_nonneg_left (dyadic_count_le K) (by norm_num))
      have hK2 : ((K : ℝ) + 2) ^ 2 ≤ 4 * (r : ℝ) ^ 2 := by
        have hK0 : (0 : ℝ) ≤ (K : ℝ) := Nat.cast_nonneg K
        nlinarith
      calc ‖∑ ρ ∈ ZF ((2:ℝ) ^ (K + 1)) \ F, term d (r : ℤ) ρ‖
          ≤ ∑ ρ ∈ ZF ((2:ℝ) ^ (K + 1)) \ F, ‖term d (r : ℤ) ρ‖ := norm_sum_le _ _
        _ ≤ ∑ ρ ∈ ZF ((2:ℝ) ^ (K + 1)) \ F, 2 ^ d * Real.sqrt 2 ^ r
              * (((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) * onLineInv ρ) :=
            Finset.sum_le_sum hterm
        _ = 2 ^ d * Real.sqrt 2 ^ r * ∑ ρ ∈ ZF ((2:ℝ) ^ (K + 1)) \ F,
              ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) * onLineInv ρ := by
            rw [Finset.mul_sum]
        _ ≤ 2 ^ d * Real.sqrt 2 ^ r * (2 * (3000 * (4 * (r : ℝ) ^ 2))) := by
            apply mul_le_mul_of_nonneg_left _ (by positivity)
            linarith
        _ = AZ * ((r : ℝ) ^ 2 * Real.sqrt 2 ^ r) := by rw [hAZ]; ring
    have hoff : ‖∑ ρ ∈ F \ S, term d (r : ℤ) ρ‖
        ≤ ∑ ρ ∈ F \ S, (((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) * (2 ^ d * ‖(ρ : ℂ)‖⁻¹))
            * ((2:ℝ) ^ (ρ : ℂ).re) ^ r :=
      (norm_sum_le _ _).trans
        (Finset.sum_le_sum fun ρ _ => (norm_term_le d r ρ).trans_eq (by ring))
    have herr' : (∑ j ∈ range (d + 1), (d.choose j : ℝ)
        * (Glue.c1n * (2:ℝ) ^ ((r : ℤ) - (j : ℤ))
              * Real.log ((2:ℝ) ^ ((r : ℤ) - (j : ℤ)) * (2:ℝ) ^ (K + 1)) ^ 2 / (2:ℝ) ^ (K + 1)
            + Glue.c3n * Real.log ((2:ℝ) ^ ((r : ℤ) - (j : ℤ)))
            + Glue.c4n * ((Real.log ((2:ℝ) ^ ((r : ℤ) - (j : ℤ)))) ^ 2
                * ((2:ℝ) ^ ((r : ℤ) - (j : ℤ))) ^ (-(1:ℝ) / 4))))
        ≤ AE * ((r : ℝ) ^ 2 * (1:ℝ) ^ r) := by
      rw [one_pow, mul_one, hAE]
      exact herr.trans_eq (by ring)
    have key : ∑ ρ ∈ S, term d (r : ℤ) ρ
        = (CellZeros.stencil d (fun n : ℤ => (Chebyshev.psi ((2:ℝ) ^ n) : ℂ)) (r : ℤ)
              - (2:ℂ) ^ (r : ℤ) * (1 - (2:ℂ)⁻¹) ^ d
              + ∑ ρ ∈ ZF ((2:ℝ) ^ (K + 1)), term d (r : ℤ) ρ)
          - (CellZeros.stencil d (fun n : ℤ => (Chebyshev.psi ((2:ℝ) ^ n) : ℂ)) (r : ℤ)
              - (2:ℂ) ^ (r : ℤ) * (1 - (2:ℂ)⁻¹) ^ d)
          - ∑ ρ ∈ F \ S, term d (r : ℤ) ρ
          - ∑ ρ ∈ ZF ((2:ℝ) ^ (K + 1)) \ F, term d (r : ℤ) ρ := by
      rw [hsplit]
      ring
    rw [key]
    have t1 := norm_sub_le
      ((CellZeros.stencil d (fun n : ℤ => (Chebyshev.psi ((2:ℝ) ^ n) : ℂ)) (r : ℤ)
              - (2:ℂ) ^ (r : ℤ) * (1 - (2:ℂ)⁻¹) ^ d
              + ∑ ρ ∈ ZF ((2:ℝ) ^ (K + 1)), term d (r : ℤ) ρ)
          - (CellZeros.stencil d (fun n : ℤ => (Chebyshev.psi ((2:ℝ) ^ n) : ℂ)) (r : ℤ)
              - (2:ℂ) ^ (r : ℤ) * (1 - (2:ℂ)⁻¹) ^ d)
          - ∑ ρ ∈ F \ S, term d (r : ℤ) ρ)
      (∑ ρ ∈ ZF ((2:ℝ) ^ (K + 1)) \ F, term d (r : ℤ) ρ)
    have t2 := norm_sub_le
      ((CellZeros.stencil d (fun n : ℤ => (Chebyshev.psi ((2:ℝ) ^ n) : ℂ)) (r : ℤ)
              - (2:ℂ) ^ (r : ℤ) * (1 - (2:ℂ)⁻¹) ^ d
              + ∑ ρ ∈ ZF ((2:ℝ) ^ (K + 1)), term d (r : ℤ) ρ)
          - (CellZeros.stencil d (fun n : ℤ => (Chebyshev.psi ((2:ℝ) ^ n) : ℂ)) (r : ℤ)
              - (2:ℂ) ^ (r : ℤ) * (1 - (2:ℂ)⁻¹) ^ d))
      (∑ ρ ∈ F \ S, term d (r : ℤ) ρ)
    have t3 := norm_sub_le
      (CellZeros.stencil d (fun n : ℤ => (Chebyshev.psi ((2:ℝ) ^ n) : ℂ)) (r : ℤ)
              - (2:ℂ) ^ (r : ℤ) * (1 - (2:ℂ)⁻¹) ^ d
              + ∑ ρ ∈ ZF ((2:ℝ) ^ (K + 1)), term d (r : ℤ) ρ)
      (CellZeros.stencil d (fun n : ℤ => (Chebyshev.psi ((2:ℝ) ^ n) : ℂ)) (r : ℤ)
              - (2:ℂ) ^ (r : ℤ) * (1 - (2:ℂ)⁻¹) ^ d)
    linarith [h'.trans herr']
  -- so the top line fades, which it cannot
  have hO : (fun r : ℕ => ∑ ρ ∈ S, term d (r : ℤ) ρ) =o[atTop]
      fun r : ℕ => ((q : ℝ) : ℂ) ^ r := by
    have hb := (Asymptotics.IsBigO.of_bound' (by
      filter_upwards [hbound] with r hr
      exact hr.trans ((le_abs_self _).trans_eq (Real.norm_eq_abs _).symm))).trans_isLittleO hG
    refine Asymptotics.isLittleO_norm_right.mp ?_
    convert hb using 2 with r
    rw [norm_pow, Complex.norm_real, Real.norm_of_nonneg hqpos.le]
  have hlim := hO.tendsto_div_nhds_zero
  refine LadderFading.line_not_fading S hSne hSβ d (hlim.congr fun r => ?_)
  congr 1
  refine Finset.sum_congr rfl fun ρ _ => ?_
  rw [CellModes.mode_two_int, CellModes.sym_two]
  unfold term
  ring

/-- info: 'FiniteOffLine.sum_order_onLineInv_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms sum_order_onLineInv_le

/-- info: 'FiniteOffLine.err_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms err_le

/-- info: 'FiniteOffLine.finite_off_line' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms finite_off_line

end

end FiniteOffLine
