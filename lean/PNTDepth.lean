/-
PNTDepth — under the prime number theorem, each depth has only finitely many zeros.

`StmtPNT`: `|π(2^m) − liRow m| ≤ ε·2^m/m` for every `ε > 0` past some row. This is the
prime number theorem `π(x) ~ li(x)` read at `x = 2^m` (error `o(x/log x)`); PNT+ proves
`pi_asymp` with axioms `propext, Classical.choice, Quot.sound` (checked in `lean_stage3`).
The two trees meet by statement; the weld is not in this file.

`eventually_ne_zero`: for each depth `d ≥ 1` there is a row past which no cell of depth `d`
vanishes. With the census to row 92 this leaves, at each depth, finitely many rows unchecked.
-/
import Mathlib
import ExactBand

namespace PNTDepth
open RelativeGate ExactGate ExactBand

/-- The prime number theorem at the doublings, as a statement. -/
def StmtPNT : Prop :=
  ∀ ε : ℝ, 0 < ε → ∃ M : ℤ, ∀ m : ℤ, M ≤ m →
    |ToInfinity.piRow m - Interpolant.liRow m| ≤ ε * (2 : ℝ) ^ (m : ℝ) / m

/-- **Each depth has finitely many zeros, under PNT.** -/
theorem eventually_ne_zero (hP : StmtPNT) (d : ℕ) :
    ∃ R : ℤ, ∀ r : ℤ, R ≤ r → Construction.tableFrom ToInfinity.trueRow r d ≠ 0 := by
  set ε : ℝ := 1 / 3 ^ (d + 3) with hε
  have hε0 : 0 < ε := by positivity
  obtain ⟨M, hM⟩ := hP ε hε0
  refine ⟨max (M + d + 1) (5 * d + 2), fun r hr => ?_⟩
  have hr1 : M + d + 1 ≤ r := le_trans (le_max_left _ _) hr
  have hr2 : 5 * (d : ℤ) + 2 ≤ r := le_trans (le_max_right _ _) hr
  have hd0 : (0 : ℝ) ≤ d := Nat.cast_nonneg d
  have hr2R : 5 * (d : ℝ) + 2 ≤ r := by exact_mod_cast hr2
  have hband : 3 * (d : ℝ) + 1 < r := by linarith
  have hbot : (0 : ℝ) < (r : ℝ) - d - 1 := by linarith
  -- the window bound with ρ = ε/(r − d − 1)
  set ρ : ℝ := ε / ((r : ℝ) - d - 1) with hρdef
  have hS : StmtRelErrWindow ToInfinity.piRow (fun k : ℤ => Interpolant.liRow k) r (d + 1) ρ := by
    intro k hk
    have hk' : (k : ℤ) ≤ d + 1 := by exact_mod_cast Nat.lt_succ_iff.mp (Finset.mem_range.mp hk)
    have hkR : (k : ℝ) ≤ d + 1 := by exact_mod_cast hk'
    have hm := hM (r - k) (by omega)
    have hmpos : (0 : ℝ) < ((r - k : ℤ) : ℝ) := by push_cast; linarith
    have hge : (r : ℝ) - d - 1 ≤ ((r - k : ℤ) : ℝ) := by push_cast; linarith
    have hp : (0 : ℝ) ≤ (2 : ℝ) ^ (((r - k : ℤ) : ℤ) : ℝ) := by positivity
    calc |ToInfinity.piRow (r - k) - Interpolant.liRow ((r - k : ℤ) : ℝ)|
        ≤ ε * (2 : ℝ) ^ (((r - k : ℤ)) : ℝ) / ((r - k : ℤ) : ℝ) := hm
      _ ≤ ε * (2 : ℝ) ^ (((r - k : ℤ)) : ℝ) / ((r : ℝ) - d - 1) :=
          div_le_div_of_nonneg_left (by positivity) hbot hge
      _ = ρ * (2 : ℝ) ^ ((r : ℝ) - k) := by
          rw [hρdef]; push_cast; ring
  refine tableFrom_ne_zero_exact (f := ToInfinity.piRow) ?_ hS hband (gap_of_price hband ?_)
  · intro k hk
    have := Finset.mem_range.mp hk
    exact ToInfinity.trueRow_eq_bdiff (by omega)
  · -- ρ < priceX r d
    unfold priceX
    simp only
    have hden : 0 < (r : ℝ) - 1 - d := by linarith
    set q := (d : ℝ) / ((r : ℝ) - 1 - d) with hq
    have hq4 : q ≤ 1 / 4 := by rw [hq, div_le_iff₀ hden]; linarith
    have hq0 : 0 ≤ q := div_nonneg hd0 hden.le
    have hc : (1 : ℝ) / 3 ≤ 1 - q / (1 - q) := by
      have h1q : 0 < 1 - q := by linarith
      have : q / (1 - q) ≤ 1 / 3 := by rw [div_le_iff₀ h1q]; linarith
      linarith
    have h3 : (0 : ℝ) < 3 ^ (d + 1) := by positivity
    have hrpos : (0 : ℝ) < r := by linarith
    -- ρ ≤ 2ε/r since r ≤ 2(r − d − 1)
    have hρle : ρ ≤ 2 * ε / r := by
      rw [hρdef, div_le_div_iff₀ hbot hrpos]; nlinarith
    have hεeq : 2 * ε / r < (1 / 3) / ((r : ℝ) * 3 ^ (d + 1)) := by
      rw [hε, div_lt_div_iff₀ hrpos (by positivity)]
      have : (3 : ℝ) ^ (d + 3) = 3 ^ (d + 1) * 9 := by rw [show d + 3 = (d + 1) + 2 by ring, pow_add]; norm_num
      rw [this]; field_simp; nlinarith
    calc ρ ≤ 2 * ε / r := hρle
      _ < (1 / 3) / ((r : ℝ) * 3 ^ (d + 1)) := hεeq
      _ ≤ (1 - q / (1 - q)) / ((r : ℝ) * 3 ^ (d + 1)) :=
          div_le_div_of_nonneg_right hc (by positivity)

end PNTDepth

/-- info: 'PNTDepth.eventually_ne_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms PNTDepth.eventually_ne_zero

namespace PNTDepth

/-- The prime number theorem at the doublings, written out: `|π(2^m) − liRow m| ≤ ε·2^m/m` past
some row, with `liRow m = 2/log 2 + ∫₁^m 2^t/t dt`. Welded by statement identity to
`lean_stage3/Stage3/PNTWeld.lean`, where `stmtPNTx` proves it from PNT+ (`utilities/check_weld.py`). -/
def StmtPNTx : Prop :=
  ∀ ε : ℝ, 0 < ε → ∃ M : ℤ, ∀ m : ℤ, M ≤ m →
    |((Nat.primeCounting (2 ^ m.toNat) : ℕ) : ℝ)
        - (2 / Real.log 2 + ∫ t in (1 : ℝ)..(m : ℝ), Real.exp (Real.log 2 * t) / t)|
      ≤ ε * (2 : ℝ) ^ (m : ℝ) / m

theorem stmtPNT_of_x (h : StmtPNTx) : StmtPNT := by
  intro ε hε
  obtain ⟨M, hM⟩ := h ε hε
  refine ⟨max M 1, fun m hm => ?_⟩
  have hm1 : (1 : ℤ) ≤ m := le_trans (le_max_right _ _) hm
  have hx : (1 / 2 : ℝ) ≤ (m : ℝ) := by
    have : (1 : ℝ) ≤ m := by exact_mod_cast hm1
    linarith
  have := hM m (le_trans (le_max_left _ _) hm)
  rw [Interpolant.liRow_eq hx]
  exact this

/-- **Each depth has finitely many zeros, given `StmtPNTx`.** The input is the statement that
stage 3 proves from PNT+ with no `sorry` and no RH. -/
theorem eventually_ne_zero_x (h : StmtPNTx) (d : ℕ) :
    ∃ R : ℤ, ∀ r : ℤ, R ≤ r → Construction.tableFrom ToInfinity.trueRow r d ≠ 0 :=
  eventually_ne_zero (stmtPNT_of_x h) d

end PNTDepth

/-- info: 'PNTDepth.eventually_ne_zero_x' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms PNTDepth.eventually_ne_zero_x
