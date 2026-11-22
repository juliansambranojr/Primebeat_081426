/-
JointFloorGate — block E3 of `lean_stage3/design/joints.md`. 2026-11-22.

The explicit-formula route (unit 0409, `schoenfeldWeak_floor_split_of_RH`)
carried to the statement the table's gate takes, `StmtRelErrWindow`
(`JointDialGate`, a character copy of `lean/RelativeGate.lean`, welded).

  weakWindow_relErr          0 ≤ C, 0 ≤ r − n, StmtWeakWindow C k f L r n
                               ⊢ StmtRelErrWindow f L r n (C·(log 2·r)^k·2^(−(r−n)/2))
  relErrWindow_floor_of_RH   RH ⊢ ∃ c₁ c₃ c₄ ≥ 0, ∀ x₀ ≥ 16, ∀ r n,
                               x₀² ≤ 2^(r−n) → 0 ≤ r − n →
                               StmtRelErrWindow (rows of π) (rows of Li) r n
                                 ((3·floorConstSplit … x₀ + 13)·(log 2·r)^1·2^(−(r−n)/2))

What the next slice needs: nothing on this side. The gate's theorem is in the
table's tree on another toolchain; the join is by statement text (joint 5).

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.GlueFloor
import Stage3.JointDialGate

namespace JointFloorGate

open Finset

noncomputable section

/-- A weak window is the gate's relative-error window. -/
theorem weakWindow_relErr {C : ℝ} {k : ℕ} {f L : ℤ → ℝ} {r : ℤ} {n : ℕ}
    (hC : 0 ≤ C) (hpos : 0 ≤ (r : ℝ) - n)
    (h : Stage3.StmtWeakWindow C k f L r n) :
    JointDialGate.StmtRelErrWindow f L r n
      (C * (Real.log 2 * r) ^ k * (2 : ℝ) ^ (-(((r : ℝ) - n) / 2))) := by
  intro j hj
  refine (h j hj).trans ?_
  have hjn : (j : ℝ) ≤ n := by
    exact_mod_cast Nat.lt_succ_iff.mp (Finset.mem_range.mp hj)
  have hj0 : (0 : ℝ) ≤ j := Nat.cast_nonneg j
  have hn0 : (0 : ℝ) ≤ n := Nat.cast_nonneg n
  have h0 : (0 : ℝ) ≤ (r : ℝ) - j := by linarith
  have hlog : 0 ≤ Real.log 2 := (Real.log_pos one_lt_two).le
  have hp : (Real.log 2 * ((r : ℝ) - j)) ^ k ≤ (Real.log 2 * r) ^ k :=
    pow_le_pow_left₀ (mul_nonneg hlog h0)
      (mul_le_mul_of_nonneg_left (by linarith) hlog) k
  have hs : (2 : ℝ) ^ (((r : ℝ) - j) / 2)
      ≤ (2 : ℝ) ^ (-(((r : ℝ) - n) / 2)) * (2 : ℝ) ^ ((r : ℝ) - j) := by
    rw [← Real.rpow_add (by norm_num)]
    exact Real.rpow_le_rpow_of_exponent_le (by norm_num) (by linarith)
  have hr0 : (0 : ℝ) ≤ Real.log 2 * r := mul_nonneg hlog (by linarith)
  calc C * (Real.log 2 * ((r : ℝ) - j)) ^ k * (2 : ℝ) ^ (((r : ℝ) - j) / 2)
      ≤ C * (Real.log 2 * r) ^ k
          * ((2 : ℝ) ^ (-(((r : ℝ) - n) / 2)) * (2 : ℝ) ^ ((r : ℝ) - j)) :=
        mul_le_mul (mul_le_mul_of_nonneg_left hp hC) hs
          (Real.rpow_nonneg (by norm_num) _) (mul_nonneg hC (pow_nonneg hr0 k))
    _ = C * (Real.log 2 * r) ^ k * (2 : ℝ) ^ (-(((r : ℝ) - n) / 2))
          * (2 : ℝ) ^ ((r : ℝ) - j) := by ring

/-- **The explicit-formula route at the gate.** Under RH, on any window of
rows above the floor squared, the relative error of `π` against `Li` is at
most `(3·floorConstSplit + 13)·(log 2·r)·2^(−(r−n)/2)`. -/
theorem relErrWindow_floor_of_RH (hRH : RiemannHypothesis) :
    ∃ c₁ c₃ c₄ : ℝ, 0 ≤ c₁ ∧ 0 ≤ c₃ ∧ 0 ≤ c₄ ∧ ∀ x₀ : ℝ, 16 ≤ x₀ →
      ∀ (r : ℤ) (n : ℕ), x₀ ^ 2 ≤ (2 : ℝ) ^ ((r : ℝ) - n) → 0 ≤ (r : ℝ) - n →
      JointDialGate.StmtRelErrWindow
        (fun m : ℤ => (Nat.primeCounting ⌊(2 : ℝ) ^ (m : ℝ)⌋₊ : ℝ))
        (fun m : ℤ => Stage3.Li ((2 : ℝ) ^ (m : ℝ))) r n
        ((3 * Stage3.floorConstSplit c₁ c₃ c₄ 112 0 698
              Kadiri.weightedZeroHeightBucket x₀ + 13)
          * (Real.log 2 * r) ^ 1 * (2 : ℝ) ^ (-(((r : ℝ) - n) / 2))) := by
  obtain ⟨c₁, c₃, c₄, hc₁, hc₃, hc₄, hpi⟩ := Stage3.schoenfeldWeak_floor_split_of_RH hRH
  refine ⟨c₁, c₃, c₄, hc₁, hc₃, hc₄, fun x₀ hx₀ r n hbot hpos => ?_⟩
  have hF := Stage3.floorConstSplit_nonneg (b₁ := 112) (b₂ := 0) (b₃ := 698)
    hc₁ hc₃ hc₄ (by norm_num) le_rfl (by norm_num)
    Kadiri.weightedZeroHeightBucket_nonneg hx₀
  have h9 : (9 : ℝ) ≤ x₀ ^ 2 := by nlinarith
  have hbot' : max (x₀ ^ 2) 9 ≤ (2 : ℝ) ^ ((r : ℝ) - n) :=
    max_le hbot (le_trans h9 hbot)
  exact weakWindow_relErr (by linarith) hpos
    (Stage3.weakWindow_of_global (hpi x₀ hx₀) (fun _ => rfl) (fun _ => rfl) hbot')

end

/-- info: 'JointFloorGate.weakWindow_relErr' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms weakWindow_relErr

/-- info: 'JointFloorGate.relErrWindow_floor_of_RH' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms relErrWindow_floor_of_RH

end JointFloorGate
