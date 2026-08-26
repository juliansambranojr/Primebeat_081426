/-
Nonvanishing — the arrow of O67's conditional theorem, in the house pattern.

`papers/The-Four-Zeros.md` § I states: under RH, `cell(r,d) ≠ 0` for every
`r ≥ R(d)`, which with O43's census makes the four zeros complete at every
depth `d ≤ 15`. The proof has two analytic inputs and one arithmetic gap
condition; everything joining them is algebra. Following `Chain.lean`'s
design — take the antecedents as HYPOTHESES, prove the arrows, let the kernel
check that the "therefore" is real — this module proves the joins:

  PROVED HERE
    iter_bdiffZ_eq_stencilR   d differences of a real function are the
                              alternating stencil — `Zeros.tableFrom_eq_stencil`
                              transplanted to ℝ via Mathlib's fwdDiff
    stencilR_row              a depth-d stencil on the ROW is the depth-(d+1)
                              stencil on the counting function itself
    stencilR_sub              linearity, splitting π = li + (π − li)
    weighted_binomial_bound   Σ C(n,k)·t^k = (1+t)^n applied at t = 2^(−1/2):
                              Schoenfeld-on-the-window forces
                              |stencil of (π − li)| ≤ Ehigh
    nonvanishing_of           main ≥ Mlow, error ≤ Ehigh, Ehigh < Mlow
                              ⟹ the stencil of π does not vanish
    tableFrom_ne_zero_of      the same conclusion carried onto the integer
                              table through the cast bridge

  HYPOTHESES, not proved here — the honest boundary
    hS   : Schoenfeld's bound on the window. RH-equivalent territory;
           Schoenfeld exists in no proof assistant. Stage 3.
    hM   : the main-term lower bound |stencil of li| ≥ Mlow — O67's
           iterated-MVT plus alternating-series step, verified numerically at
           nine points. Stage 2's target, via an integral representation of
           iterated differences.
    hgap : Ehigh < Mlow — per-(r,d) real arithmetic. O67 tabulates where it
           holds: r ≥ R(d) ≈ 5d + 11.

So this module is to § I what `Chain.C3_of_A4_C2` is to the chain paper: the
implication, machine-checked, with the leaves named. Discharging hM is stage 2;
hS stays a hypothesis exactly as `StmtA2`'s `1 < Re s` stays Euler's content.

Companion to papers/The-Four-Zeros.md § I and notes entry 113.
-/
import Mathlib
import Zeros
import ZerosStencil

namespace Nonvanishing

open Finset

/-- Backward differencing on ℤ-indexed real sequences — `Chain.bdiff`'s twin
one level down (ℤ index, ℝ values). -/
noncomputable def bdiffZ (g : ℤ → ℝ) : ℤ → ℝ := fun x => g x - g (x - 1)

/-- The real alternating binomial stencil of order `n` on `g`, read at `r`
downward. The ℝ twin of `Zeros.stencil`. -/
noncomputable def stencilR (n : ℕ) (g : ℤ → ℝ) (r : ℤ) : ℝ :=
  ∑ k ∈ range (n + 1), (-1 : ℝ) ^ k * (n.choose k) * g (r - k)

/-- Backward differencing is `(−1)·fwdDiff` at step `−1` — the ℝ copy of
`Zeros.tableFrom_eq_fwdDiff`'s bridge. -/
theorem iter_bdiffZ_eq_fwdDiff (g : ℤ → ℝ) (r : ℤ) (n : ℕ) :
    (bdiffZ^[n]) g r = (-1 : ℝ) ^ n * (fwdDiff (-1 : ℤ))^[n] g r := by
  induction n generalizing r with
  | zero => simp
  | succ m ih =>
      rw [Function.iterate_succ_apply' bdiffZ m g]
      show (bdiffZ^[m]) g r - (bdiffZ^[m]) g (r - 1) = _
      rw [ih r, ih (r - 1), Function.iterate_succ_apply' (fwdDiff (-1 : ℤ)) m g]
      show _ = (-1 : ℝ) ^ (m + 1) *
        ((fwdDiff (-1 : ℤ))^[m] g (r + (-1)) - (fwdDiff (-1 : ℤ))^[m] g r)
      rw [show r + (-1 : ℤ) = r - 1 by ring, pow_succ]
      ring

/-- **`n` differences are the stencil.** `Zeros.tableFrom_eq_stencil`
transplanted to ℝ: Mathlib's `fwdDiff_iter_eq_sum_shift` does the binomial
bookkeeping. -/
theorem iter_bdiffZ_eq_stencilR (g : ℤ → ℝ) (r : ℤ) (n : ℕ) :
    (bdiffZ^[n]) g r = stencilR n g r := by
  rw [iter_bdiffZ_eq_fwdDiff, fwdDiff_iter_eq_sum_shift, stencilR, Finset.mul_sum]
  refine Finset.sum_congr rfl fun k hk => ?_
  have hkd : k ≤ n := Nat.lt_succ_iff.mp (Finset.mem_range.mp hk)
  have hsign : (-1 : ℝ) ^ n * (-1 : ℝ) ^ (n - k) = (-1 : ℝ) ^ k := by
    rw [← pow_add, show n + (n - k) = 2 * (n - k) + k by omega, pow_add, pow_mul]
    norm_num
  have hshift : r + k • (-1 : ℤ) = r - (k : ℤ) := by
    simp [sub_eq_add_neg]
  rw [hshift]
  simp only [zsmul_eq_mul]
  push_cast
  linear_combination ((n.choose k : ℝ)) * g (r - (k : ℤ)) * hsign

/-- **The Pascal step.** The depth-`d` stencil on the row `x ↦ g(x) − g(x−1)`
is the depth-`(d+1)` stencil on `g`. One more iterate, nothing else. -/
theorem stencilR_row (d : ℕ) (g : ℤ → ℝ) (r : ℤ) :
    stencilR d (bdiffZ g) r = stencilR (d + 1) g r := by
  rw [← iter_bdiffZ_eq_stencilR, ← iter_bdiffZ_eq_stencilR,
      ← Function.iterate_succ_apply]

/-- **Linearity.** Splitting `π = li + (π − li)` under the stencil. -/
theorem stencilR_sub (n : ℕ) (f L : ℤ → ℝ) (r : ℤ) :
    stencilR n (fun x => f x - L x) r = stencilR n f r - stencilR n L r := by
  unfold stencilR
  rw [← Finset.sum_sub_distrib]
  exact Finset.sum_congr rfl fun k _ => by ring

/-! ## The two sides of the inequality -/

/-- The error ceiling: `(log 2 · r / 8π) · 2^(r/2) · (1 + 2^(−1/2))^(n)`. -/
noncomputable def Ehigh (r : ℤ) (n : ℕ) : ℝ :=
  (Real.log 2 * r / (8 * Real.pi)) * (2 : ℝ) ^ ((r : ℝ) / 2)
    * (1 + (2 : ℝ) ^ (-(1 : ℝ) / 2)) ^ n

/-- **Schoenfeld on the window**, as a statement: each of the `n+1` values the
stencil reads obeys the RH bound at `x = 2^(r−k)`, where `√x = 2^((r−k)/2)` and
`log x = (r−k)·log 2`. This is the hypothesis Schoenfeld's theorem would
discharge; it is not discharged here. -/
def StmtSchoenfeldWindow (f L : ℤ → ℝ) (r : ℤ) (n : ℕ) : Prop :=
  ∀ k ∈ range (n + 1),
    |f (r - k) - L (r - k)|
      ≤ (Real.log 2 * ((r : ℝ) - k) / (8 * Real.pi)) * (2 : ℝ) ^ (((r : ℝ) - k) / 2)

/-- Each windowed Schoenfeld bound is at most the top-of-window bound times
`2^(−k/2)`: `(r−k) ≤ r` handles the linear factor and `rpow_add` splits the
power. Needs `0 ≤ r − k` inside the window, supplied by `hr`. -/
theorem window_term_le {r : ℤ} {n : ℕ} (hr : (n : ℤ) ≤ r) (k : ℕ)
    (hk : k ∈ range (n + 1)) :
    (Real.log 2 * ((r : ℝ) - k) / (8 * Real.pi)) * (2 : ℝ) ^ (((r : ℝ) - k) / 2)
      ≤ (Real.log 2 * r / (8 * Real.pi)) * (2 : ℝ) ^ ((r : ℝ) / 2)
        * ((2 : ℝ) ^ (-(1 : ℝ) / 2)) ^ k := by
  have hkn : (k : ℤ) ≤ n := by exact_mod_cast Nat.lt_succ_iff.mp (Finset.mem_range.mp hk)
  have hkr : (k : ℝ) ≤ (r : ℝ) := by exact_mod_cast le_trans hkn hr
  have h2 : (0 : ℝ) < 2 := by norm_num
  have hlog : (0 : ℝ) ≤ Real.log 2 := Real.log_nonneg (by norm_num)
  have hpi : (0 : ℝ) < 8 * Real.pi := by positivity
  have hsplit : (2 : ℝ) ^ (((r : ℝ) - k) / 2)
      = (2 : ℝ) ^ ((r : ℝ) / 2) * ((2 : ℝ) ^ (-(1 : ℝ) / 2)) ^ k := by
    rw [← Real.rpow_natCast ((2 : ℝ) ^ (-(1 : ℝ) / 2)) k, ← Real.rpow_mul h2.le,
        ← Real.rpow_add h2]
    congr 1
    ring
  rw [hsplit, mul_assoc]
  have hpow : (0 : ℝ) ≤ (2 : ℝ) ^ ((r : ℝ) / 2) * ((2 : ℝ) ^ (-(1 : ℝ) / 2)) ^ k := by
    positivity
  have hlin : Real.log 2 * ((r : ℝ) - k) / (8 * Real.pi)
      ≤ Real.log 2 * r / (8 * Real.pi) := by
    gcongr
    · linarith
  exact mul_le_mul_of_nonneg_right hlin hpow

/-- **The error bound.** Triangle inequality, the per-term comparison, and the
binomial theorem `Σ C(n,k) t^k = (1+t)^n` at `t = 2^(−1/2)`. -/
theorem error_bound {f L : ℤ → ℝ} {r : ℤ} {n : ℕ} (hr : (n : ℤ) ≤ r)
    (hS : StmtSchoenfeldWindow f L r n) :
    |stencilR n (fun x => f x - L x) r| ≤ Ehigh r n := by
  unfold stencilR Ehigh
  calc |∑ k ∈ range (n + 1), (-1 : ℝ) ^ k * (n.choose k) * (f (r - k) - L (r - k))|
      ≤ ∑ k ∈ range (n + 1), |(-1 : ℝ) ^ k * (n.choose k) * (f (r - k) - L (r - k))| :=
        Finset.abs_sum_le_sum_abs _ _
    _ ≤ ∑ k ∈ range (n + 1), (n.choose k : ℝ)
          * ((Real.log 2 * r / (8 * Real.pi)) * (2 : ℝ) ^ ((r : ℝ) / 2)
             * ((2 : ℝ) ^ (-(1 : ℝ) / 2)) ^ k) := by
        refine Finset.sum_le_sum fun k hk => ?_
        rw [abs_mul, abs_mul, abs_pow, abs_neg, abs_one, one_pow, one_mul,
            Nat.abs_cast]
        exact mul_le_mul_of_nonneg_left
          ((hS k hk).trans (window_term_le hr k hk)) (Nat.cast_nonneg _)
    _ = (Real.log 2 * r / (8 * Real.pi)) * (2 : ℝ) ^ ((r : ℝ) / 2)
          * ∑ k ∈ range (n + 1), (n.choose k : ℝ) * ((2 : ℝ) ^ (-(1 : ℝ) / 2)) ^ k := by
        rw [Finset.mul_sum]
        exact Finset.sum_congr rfl fun k _ => by ring
    _ = _ := by
        congr 1
        rw [add_comm (1 : ℝ), add_pow]
        exact Finset.sum_congr rfl fun k hk => by
          rw [one_pow, mul_one, mul_comm]

/-- The main-term floor `0.5 · 2^(r−d−1) · (log 2)^d / r`. O67's step 3. -/
noncomputable def Mlow (r : ℤ) (d : ℕ) : ℝ :=
  (1 / 2) * (2 : ℝ) ^ ((r : ℝ) - d - 1) * Real.log 2 ^ d / r

/-- **The arrow.** If Schoenfeld holds on the window (`hS`), the smooth main
term clears its floor (`hM` — stage 2's target), and the floor beats the error
ceiling (`hgap` — O67's `r ≥ R(d)` table), then the depth-`(d+1)` stencil of
the counting function does not vanish. -/
theorem nonvanishing_of {f L : ℤ → ℝ} {r : ℤ} {d : ℕ}
    (hr : ((d + 1 : ℕ) : ℤ) ≤ r)
    (hS : StmtSchoenfeldWindow f L r (d + 1))
    (hM : Mlow r d ≤ |stencilR (d + 1) L r|)
    (hgap : Ehigh r (d + 1) < Mlow r d) :
    stencilR (d + 1) f r ≠ 0 := by
  intro hzero
  have herr := error_bound hr hS
  rw [stencilR_sub, hzero, zero_sub, abs_neg] at herr
  linarith

/-- **Onto the integer table.** If the integer row is the backward difference of
a counting function `f` across the window a cell reads (cast to ℝ), then the
cell's vanishing is the depth-`(d+1)` stencil of `f` vanishing — so the arrow
above forbids it. The cast bridge is `Zeros.tableFrom_eq_stencil` plus
`push_cast`. -/
theorem tableFrom_ne_zero_of {N : ℤ → ℤ} {f L : ℤ → ℝ} {r : ℤ} {d : ℕ}
    (hrow : ∀ k ∈ range (d + 2), ((N (r - k) : ℤ) : ℝ) = bdiffZ f (r - k))
    (hr : ((d + 1 : ℕ) : ℤ) ≤ r)
    (hS : StmtSchoenfeldWindow f L r (d + 1))
    (hM : Mlow r d ≤ |stencilR (d + 1) L r|)
    (hgap : Ehigh r (d + 1) < Mlow r d) :
    Construction.tableFrom N r d ≠ 0 := by
  intro hzero
  apply nonvanishing_of hr hS hM hgap
  rw [← stencilR_row]
  have hcast : ((Construction.tableFrom N r d : ℤ) : ℝ)
      = stencilR d (fun x => ((N x : ℤ) : ℝ)) r := by
    rw [Zeros.tableFrom_eq_stencil, Zeros.stencil, stencilR]
    push_cast
    rfl
  have hwin : stencilR d (fun x => ((N x : ℤ) : ℝ)) r = stencilR d (bdiffZ f) r := by
    unfold stencilR
    refine Finset.sum_congr rfl fun k hk => ?_
    have hk2 : k ∈ range (d + 2) := by
      have := Finset.mem_range.mp hk
      exact Finset.mem_range.mpr (by omega)
    show (-1 : ℝ) ^ k * (d.choose k) * ((N (r - k) : ℤ) : ℝ) = _
    rw [hrow k hk2]
  rw [← hwin, ← hcast, hzero]
  norm_num

/-! ## Axiom check

An axiom claim is only a claim unless the build checks it. Each `#guard_msgs`
block below pins the exact axiom list of one result: if a proof ever starts
depending on anything not listed, the docstring stops matching the compiler and
**`lake build` fails**. This is a check, not a printout.
-/

/-- info: 'Nonvanishing.iter_bdiffZ_eq_fwdDiff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Nonvanishing.iter_bdiffZ_eq_fwdDiff

/-- info: 'Nonvanishing.iter_bdiffZ_eq_stencilR' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Nonvanishing.iter_bdiffZ_eq_stencilR

/-- info: 'Nonvanishing.stencilR_row' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Nonvanishing.stencilR_row

/-- info: 'Nonvanishing.stencilR_sub' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Nonvanishing.stencilR_sub

/-- info: 'Nonvanishing.window_term_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Nonvanishing.window_term_le

/-- info: 'Nonvanishing.error_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Nonvanishing.error_bound

/-- info: 'Nonvanishing.nonvanishing_of' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Nonvanishing.nonvanishing_of

/-- info: 'Nonvanishing.tableFrom_ne_zero_of' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Nonvanishing.tableFrom_ne_zero_of

end Nonvanishing
