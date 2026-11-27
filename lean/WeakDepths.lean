/-
WeakDepths — depths 1 … 14, every row, under RH, with each row's error charged at its own size.

`StmtWeakWindow` is, character for character, `lean_stage3/Stage3/Statement.lean`'s. `StmtRoute127`
is the conclusion of `lean_stage3/Stage3/RouteSharp.weakWindow127_of_RH`, read for every window with
`r − n ≥ 76`; that theorem takes only `RiemannHypothesis` (welded, `utilities/check_weld.py`).

The relative route charges every row of the window the bottom row's relative error. Here each row
`r − j` is charged `127·(log 2·(r − j))·2^((r−j)/2)`, and the binomial sum gives
`127·(log 2·r)·2^(r/2)·(1 + 2^(−1/2))^n` (`error_boundC`). Against the exact floor this clears every
depth up to 14 from row 93 (`weak_lt_floor`).
-/
import Mathlib
import RHDepths

namespace WeakDepths
open Finset Nonvanishing ExactGate ExactBand ExactFloor SmoothRow

/-- The weak bound translated to the dyadic window: at `x = 2^(r−j)` the
bound reads `C·(log 2·(r−j))^k·2^((r−j)/2)`. -/
def StmtWeakWindow (C : ℝ) (k : ℕ) (f L : ℤ → ℝ) (r : ℤ) (n : ℕ) : Prop :=
  ∀ j ∈ range (n + 1),
    |f (r - j) - L (r - j)|
      ≤ C * (Real.log 2 * ((r : ℝ) - j)) ^ k * (2 : ℝ) ^ (((r : ℝ) - j) / 2)

/-- The route's per-row window at the floor `2^38`, for every `r`, `n` with `r − n ≥ 76`. -/
def StmtRoute127 : Prop :=
  ∀ (r : ℤ) (n : ℕ), (76 : ℝ) ≤ (r : ℝ) - n →
    StmtWeakWindow 127 1
        (fun m : ℤ => (Nat.primeCounting ⌊(2 : ℝ) ^ (m : ℝ)⌋₊ : ℝ))
        (fun m : ℤ => 2 / Real.log 2
          + ∫ t in (1 : ℝ)..(m : ℝ), Real.exp (Real.log 2 * t) / t) r n

/-- The accumulated ceiling `C·(log 2·r)·2^(r/2)·(1 + 2^(−1/2))^n`. -/
noncomputable def EhighC (C : ℝ) (r : ℤ) (n : ℕ) : ℝ :=
  C * (Real.log 2 * r) * (2 : ℝ) ^ ((r : ℝ) / 2) * (1 + (2 : ℝ) ^ (-(1 : ℝ) / 2)) ^ n

theorem weak_term_le {C : ℝ} (hC : 0 ≤ C) {r : ℤ} {n : ℕ} (hr : (n : ℤ) ≤ r) (k : ℕ)
    (hk : k ∈ range (n + 1)) :
    C * (Real.log 2 * ((r : ℝ) - k)) ^ 1 * (2 : ℝ) ^ (((r : ℝ) - k) / 2)
      ≤ C * (Real.log 2 * r) * (2 : ℝ) ^ ((r : ℝ) / 2) * ((2 : ℝ) ^ (-(1 : ℝ) / 2)) ^ k := by
  have hkn : (k : ℤ) ≤ n := by exact_mod_cast Nat.lt_succ_iff.mp (Finset.mem_range.mp hk)
  have hkr : (k : ℝ) ≤ (r : ℝ) := by exact_mod_cast le_trans hkn hr
  have h2 : (0 : ℝ) < 2 := by norm_num
  have hlog : (0 : ℝ) ≤ Real.log 2 := Real.log_nonneg (by norm_num)
  have hsplit : (2 : ℝ) ^ (((r : ℝ) - k) / 2)
      = (2 : ℝ) ^ ((r : ℝ) / 2) * ((2 : ℝ) ^ (-(1 : ℝ) / 2)) ^ k := by
    rw [← Real.rpow_natCast ((2 : ℝ) ^ (-(1 : ℝ) / 2)) k, ← Real.rpow_mul h2.le,
        ← Real.rpow_add h2]
    congr 1
    ring
  rw [hsplit, pow_one]
  have hpow : (0 : ℝ) ≤ (2 : ℝ) ^ ((r : ℝ) / 2) * ((2 : ℝ) ^ (-(1 : ℝ) / 2)) ^ k := by
    positivity
  have hlin : C * (Real.log 2 * ((r : ℝ) - k)) ≤ C * (Real.log 2 * r) := by
    apply mul_le_mul_of_nonneg_left _ hC
    nlinarith [Nat.cast_nonneg (α := ℝ) k]
  calc C * (Real.log 2 * ((r : ℝ) - k)) * ((2 : ℝ) ^ ((r : ℝ) / 2) * ((2 : ℝ) ^ (-(1 : ℝ) / 2)) ^ k)
      ≤ C * (Real.log 2 * r) * ((2 : ℝ) ^ ((r : ℝ) / 2) * ((2 : ℝ) ^ (-(1 : ℝ) / 2)) ^ k) :=
        mul_le_mul_of_nonneg_right hlin hpow
    _ = _ := by ring

/-- **The error bound, each row at its own size.** -/
theorem error_boundC {C : ℝ} (hC : 0 ≤ C) {f L : ℤ → ℝ} {r : ℤ} {n : ℕ} (hr : (n : ℤ) ≤ r)
    (hS : StmtWeakWindow C 1 f L r n) :
    |stencilR n (fun x => f x - L x) r| ≤ EhighC C r n := by
  unfold stencilR EhighC
  calc |∑ k ∈ range (n + 1), (-1 : ℝ) ^ k * (n.choose k) * (f (r - k) - L (r - k))|
      ≤ ∑ k ∈ range (n + 1), |(-1 : ℝ) ^ k * (n.choose k) * (f (r - k) - L (r - k))| :=
        Finset.abs_sum_le_sum_abs _ _
    _ ≤ ∑ k ∈ range (n + 1), (n.choose k : ℝ)
          * (C * (Real.log 2 * r) * (2 : ℝ) ^ ((r : ℝ) / 2)
             * ((2 : ℝ) ^ (-(1 : ℝ) / 2)) ^ k) := by
        refine Finset.sum_le_sum fun k hk => ?_
        rw [abs_mul, abs_mul, abs_pow, abs_neg, abs_one, one_pow, one_mul,
            Nat.abs_cast]
        exact mul_le_mul_of_nonneg_left
          ((hS k hk).trans (weak_term_le hC hr k hk)) (Nat.cast_nonneg _)
    _ = C * (Real.log 2 * r) * (2 : ℝ) ^ ((r : ℝ) / 2)
          * ∑ k ∈ range (n + 1), (n.choose k : ℝ) * ((2 : ℝ) ^ (-(1 : ℝ) / 2)) ^ k := by
        rw [Finset.mul_sum]
        exact Finset.sum_congr rfl fun k _ => by ring
    _ = _ := by
        congr 1
        rw [add_comm (1 : ℝ), add_pow]
        exact Finset.sum_congr rfl fun k hk => by
          rw [one_pow, mul_one, mul_comm]

/-- **The gate: the per-row window against the exact floor.** -/
theorem tableFrom_ne_zero_weak {N : ℤ → ℤ} {f : ℤ → ℝ} {r : ℤ} {d : ℕ} {C : ℝ} (hC : 0 ≤ C)
    (hrow : ∀ k ∈ range (d + 2), ((N (r - k) : ℤ) : ℝ) = bdiffZ f (r - k))
    (hS : StmtWeakWindow C 1 f (fun k : ℤ => Interpolant.liRow k) r (d + 1))
    (hband : 3 * (d : ℝ) + 1 < r)
    (hgap : EhighC C r (d + 1) < floorX r d) :
    Construction.tableFrom N r d ≠ 0 := by
  intro hzero
  have hM := floorX_le d r hband
  have hdr : ((d + 1 : ℕ) : ℤ) ≤ r := by
    have : 3 * (d : ℤ) + 1 < r := by exact_mod_cast hband
    push_cast; omega
  have hnz : stencilR (d + 1) f r ≠ 0 := by
    intro h0
    have herr := error_boundC hC hdr hS
    rw [stencilR_sub, h0, zero_sub, abs_neg] at herr
    linarith
  apply hnz
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

theorem sqrt_two_ge : (1.41421 : ℝ) ≤ (2 : ℝ) ^ ((1 : ℝ) / 2) := by
  rw [← Real.sqrt_eq_rpow]
  exact Real.le_sqrt_of_sq_le (by norm_num)

/-- **Depths up to fourteen, from row 93: the per-row ceiling under the exact floor.** -/
theorem weak_lt_floor {r : ℤ} {d : ℕ} (hd : d ≤ 14) (hr : (93 : ℝ) ≤ r) :
    EhighC 127 r (d + 1) < floorX r d := by
  have hLu := Real.log_two_lt_d9
  have hL0 : (0 : ℝ) < Real.log 2 := Real.log_pos (by norm_num)
  have hdR : (d : ℝ) ≤ 14 := by exact_mod_cast hd
  have hd0 : (0 : ℝ) ≤ d := Nat.cast_nonneg d
  have hr0 : (0 : ℝ) < r := by linarith
  have hr1 : (1 : ℝ) < r := by linarith
  have hH := H_w2_ge hr1
  unfold floorX EhighC; simp only
  have hden : 0 < (r : ℝ) - 1 - d := by linarith
  set q := (d : ℝ) / ((r : ℝ) - 1 - d) with hq
  have hq0 : 0 ≤ q := div_nonneg hd0 hden.le
  have hq1 : q ≤ 14 / 78 := by rw [hq, div_le_iff₀ hden]; nlinarith
  set c := 1 - q / (1 - q) with hcdef
  have hc : (0.78125 : ℝ) ≤ c := by
    have h1q : 0 < 1 - q := by linarith
    have : q / (1 - q) ≤ 0.21875 := by rw [div_le_iff₀ h1q]; nlinarith
    rw [hcdef]; linarith
  -- the powers of two
  set P : ℝ := (2 : ℝ) ^ ((r : ℝ) / 2) with hPdef
  have hP0 : 0 < P := Real.rpow_pos_of_pos (by norm_num) _
  have hz : (2 : ℝ) ^ (r - (d : ℤ)) = P * P / 2 ^ d := by
    rw [zpow_sub₀ (by norm_num), zpow_natCast, ← Real.rpow_intCast, hPdef,
      ← Real.rpow_add (by norm_num)]
    congr 2; ring
  set E : ℝ := (2:ℝ) ^ (((r:ℝ) - 93) / 2) with hE
  have hE0 : 0 < E := Real.rpow_pos_of_pos (by norm_num) _
  have hsq : (r : ℝ) ^ 2 ≤ 8649 * E := RHDepths.sq_le_two_rpow93 hr
  have hPE : P = E * ((2:ℝ) ^ (46:ℕ) * (2 : ℝ) ^ ((1 : ℝ) / 2)) := by
    rw [hPdef, hE, ← Real.rpow_natCast, ← Real.rpow_add (by norm_num),
      ← Real.rpow_add (by norm_num)]
    congr 1; push_cast; ring
  have hK : (2:ℝ) ^ (46:ℕ) * 1.41421 ≤ (2:ℝ) ^ (46:ℕ) * (2 : ℝ) ^ ((1 : ℝ) / 2) :=
    mul_le_mul_of_nonneg_left sqrt_two_ge (by positivity)
  -- the binomial base
  set s : ℝ := 1 + (2 : ℝ) ^ (-(1 : ℝ) / 2) with hs
  have hs1 : 1 ≤ s := by
    have := Real.rpow_pos_of_pos (show (0:ℝ) < 2 by norm_num) (-(1 : ℝ) / 2); rw [hs]; linarith
  have hs2 : s ≤ 1.70711 := by
    have hh : (2 : ℝ) ^ (-(1 : ℝ) / 2) * (2 : ℝ) ^ ((1 : ℝ) / 2) = 1 := by
      rw [← Real.rpow_add (by norm_num)]; norm_num
    have hpos := Real.rpow_pos_of_pos (show (0:ℝ) < 2 by norm_num) (-(1 : ℝ) / 2)
    have := sqrt_two_ge
    rw [hs]; nlinarith
  have hsd : s ^ (d + 1) * (2:ℝ) ^ d ≤ (1.70711:ℝ) ^ 15 * (2:ℝ) ^ (14:ℕ) := by
    have h1 : s ^ (d + 1) ≤ s ^ 15 := pow_le_pow_right₀ hs1 (by omega)
    have h2 : s ^ 15 ≤ (1.70711:ℝ) ^ 15 := pow_le_pow_left₀ (by linarith) hs2 15
    have h3 : (2:ℝ) ^ d ≤ (2:ℝ) ^ (14:ℕ) := pow_le_pow_right₀ (by norm_num) hd
    exact mul_le_mul (h1.trans h2) h3 (by positivity) (by positivity)
  -- the core: 254·log 2·r²·s^(d+1)·2^d < c·P
  have hcore : 254 * Real.log 2 * (r:ℝ) ^ 2 * (s ^ (d + 1) * (2:ℝ) ^ d) < c * P := by
    have hA : 254 * Real.log 2 * (r:ℝ) ^ 2 * (s ^ (d + 1) * (2:ℝ) ^ d)
        ≤ 254 * 0.6932 * (8649 * E) * ((1.70711:ℝ) ^ 15 * (2:ℝ) ^ (14:ℕ)) := by
      have h0 : (0:ℝ) ≤ s ^ (d + 1) * (2:ℝ) ^ d := by positivity
      have hr2 : (0:ℝ) ≤ (r:ℝ) ^ 2 := by positivity
      calc 254 * Real.log 2 * (r:ℝ) ^ 2 * (s ^ (d + 1) * (2:ℝ) ^ d)
          ≤ 254 * 0.6932 * (r:ℝ) ^ 2 * (s ^ (d + 1) * (2:ℝ) ^ d) := by
            have : 254 * Real.log 2 ≤ 254 * 0.6932 := by linarith
            have := mul_le_mul_of_nonneg_right this hr2
            exact mul_le_mul_of_nonneg_right this h0
        _ ≤ 254 * 0.6932 * (8649 * E) * (s ^ (d + 1) * (2:ℝ) ^ d) := by gcongr
        _ ≤ _ := mul_le_mul_of_nonneg_left hsd (by positivity)
    have hB : 254 * 0.6932 * (8649 * E) * ((1.70711:ℝ) ^ 15 * (2:ℝ) ^ (14:ℕ))
        < 0.78125 * (E * ((2:ℝ) ^ (46:ℕ) * 1.41421)) := by
      norm_num; nlinarith
    have hC : 0.78125 * (E * ((2:ℝ) ^ (46:ℕ) * 1.41421)) ≤ c * P := by
      rw [hPE]
      apply mul_le_mul hc (mul_le_mul_of_nonneg_left hK hE0.le) (by positivity) (by linarith)
    linarith
  rw [hz]
  have h2d : (0:ℝ) < 2 ^ d := by positivity
  have hRHS : P * P / 2 ^ d * (1 / (2 * (r:ℝ))) * c ≤ P * P / 2 ^ d * H w2 r * c := by
    have : 0 ≤ P * P / 2 ^ d := by positivity
    have := mul_le_mul_of_nonneg_left hH this
    exact mul_le_mul_of_nonneg_right this (by linarith)
  refine lt_of_lt_of_le ?_ hRHS
  have hgoal : 127 * (Real.log 2 * r) * P * s ^ (d + 1) * (2 ^ d * (2 * (r:ℝ)))
      < P * P / 2 ^ d * (1 / (2 * (r:ℝ))) * c * (2 ^ d * (2 * (r:ℝ))) := by
    have e1 : 127 * (Real.log 2 * r) * P * s ^ (d + 1) * (2 ^ d * (2 * (r:ℝ)))
        = P * (254 * Real.log 2 * (r:ℝ) ^ 2 * (s ^ (d + 1) * (2:ℝ) ^ d)) := by ring
    have e2 : P * P / 2 ^ d * (1 / (2 * (r:ℝ))) * c * (2 ^ d * (2 * (r:ℝ))) = P * (c * P) := by
      field_simp
    rw [e1, e2]
    exact mul_lt_mul_of_pos_left hcore hP0
  exact lt_of_mul_lt_mul_right hgoal (by positivity)

/-- **Depths 1 … 14, every row.** With the π list on rows 23 … 92 and the per-row route
(`StmtRoute127`, which `RouteSharp.weakWindow127_of_RH` proves from RH), every zero of the true
table at depths 1 … 14 is one of the four. -/
theorem only_four_zeros_rh_le14 (hpi : PiNarrow.StmtPiData23) (hW : StmtRoute127)
    {r : ℤ} {d : ℕ} (hd : 1 ≤ d) (hd14 : d ≤ 14) (hlo : (d : ℤ) < r)
    (hz : Construction.tableFrom ToInfinity.trueRow r d = 0) :
    (r, d) = (2, 1) ∨ (r, d) = (4, 1) ∨ (r, d) = (8, 3) ∨ (r, d) = (20, 6) := by
  by_cases h92 : r ≤ 92
  · exact ToInfinity.census_zero hd hlo h92
      (by rw [ToInfinity.cell_eq_true (PiNarrow.piData_of_23 hpi) r d hlo h92]; exact hz)
  · exfalso
    have hr93 : (93 : ℤ) ≤ r := by omega
    have hrR : (93 : ℝ) ≤ r := by exact_mod_cast hr93
    have hdR : (d : ℝ) ≤ 14 := by exact_mod_cast hd14
    set F : ℤ → ℝ := fun m => (Nat.primeCounting ⌊(2 : ℝ) ^ (m : ℝ)⌋₊ : ℝ) with hF
    have hwin := hW r (d + 1) (by push_cast; linarith)
    have hS : StmtWeakWindow 127 1 F (fun k : ℤ => Interpolant.liRow k) r (d + 1) := by
      intro k hk
      have hkn : (k : ℝ) ≤ d + 1 := by
        have := Nat.lt_succ_iff.mp (Finset.mem_range.mp hk); exact_mod_cast this
      have hm : (1 : ℝ) / 2 ≤ ((r - k : ℤ) : ℝ) := by push_cast; linarith
      have h := hwin k hk
      simp only at h ⊢
      rw [Interpolant.liRow_eq hm]
      exact h
    have hband : 3 * (d : ℝ) + 1 < r := by linarith
    refine tableFrom_ne_zero_weak (f := F) (by norm_num) ?_ hS hband
      (weak_lt_floor hd14 hrR) hz
    intro k hk
    have := Finset.mem_range.mp hk
    have h1 : (1 : ℤ) ≤ r - k := by omega
    rw [ToInfinity.trueRow_eq_bdiff h1]
    unfold Nonvanishing.bdiffZ
    rw [hF]; simp only
    rw [RHDepths.floor_two_rpow (by omega), RHDepths.floor_two_rpow (by omega)]

/-- The route's per-row window at the floor `2^38` through the sharp ψ-to-π transfer, for every
`r`, `n` with `r − n ≥ 76`: the conclusion of `RouteSharp.weakWindow40_of_RH`. -/
def StmtRoute40 : Prop :=
  ∀ (r : ℤ) (n : ℕ), (76 : ℝ) ≤ (r : ℝ) - n →
    StmtWeakWindow 40 1
        (fun m : ℤ => (Nat.primeCounting ⌊(2 : ℝ) ^ (m : ℝ)⌋₊ : ℝ))
        (fun m : ℤ => 2 / Real.log 2
          + ∫ t in (1 : ℝ)..(m : ℝ), Real.exp (Real.log 2 * t) / t) r n

/-- `∫₀¹ 2^(−u) du = 1/(2 log 2)`. -/
theorem integral_w2 : ∫ u in (0:ℝ)..1, w2 u = 1 / (2 * Real.log 2) := by
  have hL : Real.log 2 ≠ 0 := (Real.log_pos (by norm_num)).ne'
  have hderiv : ∀ x ∈ Set.uIcc (0:ℝ) 1,
      HasDerivAt (fun u => -Real.exp (-(Real.log 2 * u)) / Real.log 2) (w2 x) x := by
    intro x _
    have := (((hasDerivAt_id x).const_mul (Real.log 2)).neg.exp.neg).div_const (Real.log 2)
    convert this using 1
    unfold w2; simp only [id, mul_one]; field_simp; rfl
  rw [intervalIntegral.integral_eq_sub_of_hasDerivAt hderiv (w2_cont.intervalIntegrable)]
  simp only [mul_one, mul_zero, neg_zero, Real.exp_zero]
  rw [Real.exp_neg, Real.exp_log (by norm_num)]
  field_simp; ring

/-- **The floor's integral, sharper:** `H(r) ≥ 1/(2·log 2·r)`. -/
theorem H_w2_ge2 {r : ℤ} (hr : (1 : ℝ) < r) : 1 / (2 * Real.log 2 * (r : ℝ)) ≤ H w2 r := by
  have hr0 : (0 : ℝ) < r := by linarith
  have hL : (0:ℝ) < Real.log 2 := Real.log_pos (by norm_num)
  have h1 : ∫ u in (0:ℝ)..1, w2 u * (1 / (r : ℝ)) = 1 / (2 * Real.log 2 * (r : ℝ)) := by
    rw [intervalIntegral.integral_mul_const, integral_w2]; field_simp
  rw [← h1, H]
  refine intervalIntegral.integral_mono_on zero_le_one
    ((w2_cont.mul continuousOn_const).intervalIntegrable)
    ((w2_cont.mul (cont_recip hr)).intervalIntegrable) fun u hu => ?_
  have hru : 0 < (r : ℝ) - u := by linarith [hu.2]
  have hrec : 1 / (r : ℝ) ≤ 1 / ((r : ℝ) - u) := one_div_le_one_div_of_le hru (by linarith [hu.1])
  exact mul_le_mul_of_nonneg_left hrec (Real.exp_pos _).le

/-- **Depths up to fifteen, from row 93: the constant-40 ceiling under the exact floor.** -/
theorem weak40_lt_floor {r : ℤ} {d : ℕ} (hd : d ≤ 15) (hr : (93 : ℝ) ≤ r) :
    EhighC 40 r (d + 1) < floorX r d := by
  have hLu := Real.log_two_lt_d9
  have hL0 : (0 : ℝ) < Real.log 2 := Real.log_pos (by norm_num)
  have hdR : (d : ℝ) ≤ 15 := by exact_mod_cast hd
  have hd0 : (0 : ℝ) ≤ d := Nat.cast_nonneg d
  have hr0 : (0 : ℝ) < r := by linarith
  have hr1 : (1 : ℝ) < r := by linarith
  have hH := H_w2_ge2 hr1
  unfold floorX EhighC; simp only
  have hden : 0 < (r : ℝ) - 1 - d := by linarith
  set q := (d : ℝ) / ((r : ℝ) - 1 - d) with hq
  have hq0 : 0 ≤ q := div_nonneg hd0 hden.le
  have hq1 : q ≤ 15 / 77 := by rw [hq, div_le_iff₀ hden]; nlinarith
  set c := 1 - q / (1 - q) with hcdef
  have hc : (0.758 : ℝ) ≤ c := by
    have h1q : 0 < 1 - q := by linarith
    have : q / (1 - q) ≤ 0.242 := by rw [div_le_iff₀ h1q]; nlinarith
    rw [hcdef]; linarith
  set P : ℝ := (2 : ℝ) ^ ((r : ℝ) / 2) with hPdef
  have hP0 : 0 < P := Real.rpow_pos_of_pos (by norm_num) _
  have hz : (2 : ℝ) ^ (r - (d : ℤ)) = P * P / 2 ^ d := by
    rw [zpow_sub₀ (by norm_num), zpow_natCast, ← Real.rpow_intCast, hPdef,
      ← Real.rpow_add (by norm_num)]
    congr 2; ring
  set E : ℝ := (2:ℝ) ^ (((r:ℝ) - 93) / 2) with hE
  have hE0 : 0 < E := Real.rpow_pos_of_pos (by norm_num) _
  have hsq : (r : ℝ) ^ 2 ≤ 8649 * E := RHDepths.sq_le_two_rpow93 hr
  have hPE : P = E * ((2:ℝ) ^ (46:ℕ) * (2 : ℝ) ^ ((1 : ℝ) / 2)) := by
    rw [hPdef, hE, ← Real.rpow_natCast, ← Real.rpow_add (by norm_num),
      ← Real.rpow_add (by norm_num)]
    congr 1; push_cast; ring
  have hK : (2:ℝ) ^ (46:ℕ) * 1.41421 ≤ (2:ℝ) ^ (46:ℕ) * (2 : ℝ) ^ ((1 : ℝ) / 2) :=
    mul_le_mul_of_nonneg_left sqrt_two_ge (by positivity)
  set s : ℝ := 1 + (2 : ℝ) ^ (-(1 : ℝ) / 2) with hs
  have hs1 : 1 ≤ s := by
    have := Real.rpow_pos_of_pos (show (0:ℝ) < 2 by norm_num) (-(1 : ℝ) / 2); rw [hs]; linarith
  have hs2 : s ≤ 1.70711 := by
    have hh : (2 : ℝ) ^ (-(1 : ℝ) / 2) * (2 : ℝ) ^ ((1 : ℝ) / 2) = 1 := by
      rw [← Real.rpow_add (by norm_num)]; norm_num
    have hpos := Real.rpow_pos_of_pos (show (0:ℝ) < 2 by norm_num) (-(1 : ℝ) / 2)
    have := sqrt_two_ge
    rw [hs]; nlinarith
  have hsd : s ^ (d + 1) * (2:ℝ) ^ d ≤ (1.70711:ℝ) ^ 16 * (2:ℝ) ^ (15:ℕ) := by
    have h1 : s ^ (d + 1) ≤ s ^ 16 := pow_le_pow_right₀ hs1 (by omega)
    have h2 : s ^ 16 ≤ (1.70711:ℝ) ^ 16 := pow_le_pow_left₀ (by linarith) hs2 16
    have h3 : (2:ℝ) ^ d ≤ (2:ℝ) ^ (15:ℕ) := pow_le_pow_right₀ (by norm_num) hd
    exact mul_le_mul (h1.trans h2) h3 (by positivity) (by positivity)
  have hcore : 80 * Real.log 2 ^ 2 * (r:ℝ) ^ 2 * (s ^ (d + 1) * (2:ℝ) ^ d) < c * P := by
    have hl2 : Real.log 2 ^ 2 ≤ 0.6932 ^ 2 := pow_le_pow_left₀ hL0.le (by linarith) 2
    have h0 : (0:ℝ) ≤ s ^ (d + 1) * (2:ℝ) ^ d := by positivity
    have hr2 : (0:ℝ) ≤ (r:ℝ) ^ 2 := by positivity
    have hA : 80 * Real.log 2 ^ 2 * (r:ℝ) ^ 2 * (s ^ (d + 1) * (2:ℝ) ^ d)
        ≤ 80 * 0.6932 ^ 2 * (8649 * E) * ((1.70711:ℝ) ^ 16 * (2:ℝ) ^ (15:ℕ)) := by
      calc 80 * Real.log 2 ^ 2 * (r:ℝ) ^ 2 * (s ^ (d + 1) * (2:ℝ) ^ d)
          ≤ 80 * 0.6932 ^ 2 * (r:ℝ) ^ 2 * (s ^ (d + 1) * (2:ℝ) ^ d) := by
            have : 80 * Real.log 2 ^ 2 ≤ 80 * 0.6932 ^ 2 := by linarith
            have := mul_le_mul_of_nonneg_right this hr2
            exact mul_le_mul_of_nonneg_right this h0
        _ ≤ 80 * 0.6932 ^ 2 * (8649 * E) * (s ^ (d + 1) * (2:ℝ) ^ d) := by gcongr
        _ ≤ _ := mul_le_mul_of_nonneg_left hsd (by positivity)
    have hB : 80 * 0.6932 ^ 2 * (8649 * E) * ((1.70711:ℝ) ^ 16 * (2:ℝ) ^ (15:ℕ))
        < 0.758 * (E * ((2:ℝ) ^ (46:ℕ) * 1.41421)) := by
      norm_num; nlinarith
    have hC : 0.758 * (E * ((2:ℝ) ^ (46:ℕ) * 1.41421)) ≤ c * P := by
      rw [hPE]
      apply mul_le_mul hc (mul_le_mul_of_nonneg_left hK hE0.le) (by positivity) (by linarith)
    linarith
  rw [hz]
  have hRHS : P * P / 2 ^ d * (1 / (2 * Real.log 2 * (r:ℝ))) * c ≤ P * P / 2 ^ d * H w2 r * c := by
    have : 0 ≤ P * P / 2 ^ d := by positivity
    have := mul_le_mul_of_nonneg_left hH this
    exact mul_le_mul_of_nonneg_right this (by linarith)
  refine lt_of_lt_of_le ?_ hRHS
  have hgoal : 40 * (Real.log 2 * r) * P * s ^ (d + 1) * (2 ^ d * (2 * Real.log 2 * (r:ℝ)))
      < P * P / 2 ^ d * (1 / (2 * Real.log 2 * (r:ℝ))) * c * (2 ^ d * (2 * Real.log 2 * (r:ℝ))) := by
    have e1 : 40 * (Real.log 2 * r) * P * s ^ (d + 1) * (2 ^ d * (2 * Real.log 2 * (r:ℝ)))
        = P * (80 * Real.log 2 ^ 2 * (r:ℝ) ^ 2 * (s ^ (d + 1) * (2:ℝ) ^ d)) := by ring
    have e2 : P * P / 2 ^ d * (1 / (2 * Real.log 2 * (r:ℝ))) * c
        * (2 ^ d * (2 * Real.log 2 * (r:ℝ))) = P * (c * P) := by
      field_simp
    rw [e1, e2]
    exact mul_lt_mul_of_pos_left hcore hP0
  exact lt_of_mul_lt_mul_right hgoal (by positivity)

/-- **Depths 1 … 15, every row.** With the π list on rows 23 … 92 and the sharp per-row route
(`StmtRoute40`, which `RouteSharp.weakWindow40_of_RH` proves from RH), every zero of the true
table at depths 1 … 15 is one of the four. -/
theorem only_four_zeros_rh_le15 (hpi : PiNarrow.StmtPiData23) (hW : StmtRoute40)
    {r : ℤ} {d : ℕ} (hd : 1 ≤ d) (hd15 : d ≤ 15) (hlo : (d : ℤ) < r)
    (hz : Construction.tableFrom ToInfinity.trueRow r d = 0) :
    (r, d) = (2, 1) ∨ (r, d) = (4, 1) ∨ (r, d) = (8, 3) ∨ (r, d) = (20, 6) := by
  by_cases h92 : r ≤ 92
  · exact ToInfinity.census_zero hd hlo h92
      (by rw [ToInfinity.cell_eq_true (PiNarrow.piData_of_23 hpi) r d hlo h92]; exact hz)
  · exfalso
    have hr93 : (93 : ℤ) ≤ r := by omega
    have hrR : (93 : ℝ) ≤ r := by exact_mod_cast hr93
    have hdR : (d : ℝ) ≤ 15 := by exact_mod_cast hd15
    set F : ℤ → ℝ := fun m => (Nat.primeCounting ⌊(2 : ℝ) ^ (m : ℝ)⌋₊ : ℝ) with hF
    have hwin := hW r (d + 1) (by push_cast; linarith)
    have hS : StmtWeakWindow 40 1 F (fun k : ℤ => Interpolant.liRow k) r (d + 1) := by
      intro k hk
      have hkn : (k : ℝ) ≤ d + 1 := by
        have := Nat.lt_succ_iff.mp (Finset.mem_range.mp hk); exact_mod_cast this
      have hm : (1 : ℝ) / 2 ≤ ((r - k : ℤ) : ℝ) := by push_cast; linarith
      have h := hwin k hk
      simp only at h ⊢
      rw [Interpolant.liRow_eq hm]
      exact h
    have hband : 3 * (d : ℝ) + 1 < r := by linarith
    refine tableFrom_ne_zero_weak (f := F) (by norm_num) ?_ hS hband
      (weak40_lt_floor hd15 hrR) hz
    intro k hk
    have := Finset.mem_range.mp hk
    have h1 : (1 : ℤ) ≤ r - k := by omega
    rw [ToInfinity.trueRow_eq_bdiff h1]
    unfold Nonvanishing.bdiffZ
    rw [hF]; simp only
    rw [RHDepths.floor_two_rpow (by omega), RHDepths.floor_two_rpow (by omega)]

end WeakDepths

/-- info: 'WeakDepths.weak_lt_floor' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeakDepths.weak_lt_floor

/-- info: 'WeakDepths.only_four_zeros_rh_le14' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeakDepths.only_four_zeros_rh_le14

/-- info: 'WeakDepths.only_four_zeros_rh_le15' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeakDepths.only_four_zeros_rh_le15
