/-
Readings — block J10 of `lean_stage3/design/closedloop.md`. 2026-11-23.

The runs and readings of the day, each in its exact form.

  half_rung_ratio        (2^(k/2) − 2^((k−1)/2)) / 2^(k/2) = 1 − 1/√2   (unit 0497)
  half_regime_shares     the halves of a doubling hold √2 − 1 and 2 − √2 (unit 0497)
  net_is_sum_of_steps    the net rounding is the sum of the primes' steps (unit 0499)
  five_sixths_midpoint   (2/3 + 1)/2 = 5/6
  five_sixths_step       5/6 − 2/3 = 1/6 = 1 − 5/6
  force_at_family        the closed loop's force at 1/3 and at 2/3 is 5/6
  paper_lemma_zero       |2.5 − (6ε + 0.5)| = 0 ↔ ε = 1/3
  lattice_opens          5 and 7: the first primes ≡ 5 and ≡ 1 mod 6
  paper_mid_rec          paperMid (k+1) = 2·paperMid k + 1/2
  paper_first_mid        2·(1/2) + 1/2 ≠ paperMid 1
  offset_fixed           the offset is 1/2 at every doubling (no zero in it)
  iv_exact               a zero off the line ⊢ the staircase runs away
  wire_holds_iff         SpiralLink ↔ the balance holds at every N

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.ClosedLoopChain
import Stage3.Saddle

namespace Readings

open Kadiri SpiralLink ClosedLoopChain ClosedLoopJoin

/-! ### Unit 0497 — regimes of one half -/

/-- **A half rung.** The length of a rung between two half powers, over its
top, is one less the reciprocal of the square root of two, at every index. -/
theorem half_rung_ratio (k : ℝ) :
    ((2 : ℝ) ^ (k / 2) - 2 ^ ((k - 1) / 2)) / 2 ^ (k / 2) = 1 - 1 / Real.sqrt 2 := by
  have h2 : (0 : ℝ) < 2 := by norm_num
  have hpos : (0 : ℝ) < 2 ^ (k / 2) := Real.rpow_pos_of_pos h2 _
  have hsplit : (2 : ℝ) ^ ((k - 1) / 2) = 2 ^ (k / 2) / Real.sqrt 2 := by
    rw [Real.sqrt_eq_rpow, ← Real.rpow_sub h2]
    congr 1
    ring
  rw [hsplit]
  field_simp
  try ring

/-- **The two halves of a doubling.** Cut at the half power, the lower half of
`[2^n, 2^(n+1)]` holds `√2 − 1` of its length and the upper half `2 − √2`. -/
theorem half_regime_shares (n : ℕ) :
    (Real.sqrt 2 * 2 ^ n - 2 ^ n) / 2 ^ n = Real.sqrt 2 - 1 ∧
      (2 ^ (n + 1) - Real.sqrt 2 * 2 ^ n) / (2 : ℝ) ^ n = 2 - Real.sqrt 2 := by
  have hpos : (0 : ℝ) < 2 ^ n := by positivity
  constructor
  · field_simp
    try ring
  · rw [pow_succ]
    field_simp
    try ring

/-! ### Unit 0499 — the steps of the primes -/

/-- **The net is the sum of the steps.** Assign every term of the sieve to a
prime (its largest prime factor, in unit 0499); the net rounding is the sum over
the primes of each prime's step. -/
theorem net_is_sum_of_steps {D P : Finset ℕ} (g : ℕ → ℕ) (hg : ∀ d ∈ D, g d ∈ P)
    (f : ℕ → ℝ) :
    ∑ d ∈ D, f d = ∑ p ∈ P, ∑ d ∈ D.filter (fun d => g d = p), f d :=
  (Finset.sum_fiberwise_of_maps_to hg f).symm

/-! ### Five sixths -/

/-- Five sixths is the midpoint of two thirds and the whole. -/
theorem five_sixths_midpoint : ((2 : ℝ) / 3 + 1) / 2 = 5 / 6 := by norm_num

/-- From two thirds to five sixths is one sixth, the mirror of five sixths. -/
theorem five_sixths_step : (5 : ℝ) / 6 - 2 / 3 = 1 / 6 ∧ 1 - (5 : ℝ) / 6 = 1 / 6 := by
  constructor <;> norm_num

/-- **The force at the Holy Family.** The closed loop's restoring force at the
support and at the condition is five sixths. -/
theorem force_at_family (hf : HolyFamily) :
    restoringForce hf.J = 5 / 6 ∧ restoringForce hf.M = 5 / 6 :=
  holyFamily_force hf

/-- **The printed Lemma 5.4.** The mismatch `|2.5 − (6ε + 0.5)|` is zero
exactly at `ε = 1/3`, which is `σ = 5/6`. -/
theorem paper_lemma_zero (ε : ℝ) : |(2.5 : ℝ) - (6 * ε + 0.5)| = 0 ↔ ε = 1 / 3 := by
  rw [abs_eq_zero]
  constructor <;> intro h <;> [linarith; (rw [h]; norm_num)]

/-- **The lattice opens.** Five and seven are prime, the first of the two
classes modulo six past the scaffold of two and three. -/
theorem lattice_opens :
    Nat.Prime 5 ∧ 5 % 6 = 5 ∧ Nat.Prime 7 ∧ 7 % 6 = 1 := by
  refine ⟨by norm_num, by norm_num, by norm_num, by norm_num⟩

/-- The paper's midpoint of the regime `[2^k, 2^(k+1) − 1]`. -/
def paperMid (k : ℕ) : ℚ := (3 * 2 ^ k - 1) / 2

/-- **The paper's recurrence.** From the regime `[2, 3]` on, each midpoint is
twice the one before plus one half: `2.5, 5.5, 11.5, 23.5, …`. -/
theorem paper_mid_rec (k : ℕ) : paperMid (k + 1) = 2 * paperMid k + 1 / 2 := by
  unfold paperMid
  rw [pow_succ]
  ring

/-- The regime `[2, 3]` has midpoint five halves, and `[4, 7]` eleven halves. -/
theorem paper_mid_values : paperMid 1 = 5 / 2 ∧ paperMid 2 = 11 / 2 := by
  unfold paperMid
  constructor <;> norm_num

/-- **The first regime.** The paper's `[0, 1]` with midpoint one half does not
obey the recurrence into `[2, 3]`: twice one half plus one half is not five
halves. -/
theorem paper_first_mid : 2 * (1 / 2 : ℚ) + 1 / 2 ≠ paperMid 1 := by
  rw [paper_mid_values.1]
  norm_num

/-! ### The paper's §5.3 (iv) -/

/-- **The offset is fixed.** At every doubling the midpoint stands one half
above the integer below; the statement has no zero in it. -/
theorem offset_fixed (n : ℕ) : Midpoint n - ((2 ^ n : ℚ) - 1) = 1 / 2 :=
  ignition_energy_is_half n

/-- **(iv), exact.** A zero off the line makes the staircase run away from the
square-root frame. -/
theorem iv_exact (ρ : NontrivialZeros) (h : (ρ : ℂ).re ≠ 1 / 2) : ¬ Saddle.NoRunaway := by
  intro hn
  have hall := (rh_iff_re_half.mp
    (rh_iff_spiralLink.mpr (Saddle.spiralLink_iff_noRunaway.mpr hn))) ρ
  exact h hall

/-! ### Current and wire -/

/-- **The wire holds.** The link holds exactly when the current never
outruns the wire: the staircase stays in the square-root frame at every
`N` from some point on. -/
theorem wire_holds_iff : SpiralLink.SpiralLink ↔ Saddle.NoRunaway :=
  Saddle.spiralLink_iff_noRunaway

/-- info: 'Readings.half_rung_ratio' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms half_rung_ratio

/-- info: 'Readings.half_regime_shares' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms half_regime_shares

/-- info: 'Readings.net_is_sum_of_steps' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms net_is_sum_of_steps

/-- info: 'Readings.paper_lemma_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms paper_lemma_zero

/-- info: 'Readings.paper_mid_rec' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms paper_mid_rec

/-- info: 'Readings.iv_exact' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms iv_exact

/-- info: 'Readings.wire_holds_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms wire_holds_iff

end Readings
