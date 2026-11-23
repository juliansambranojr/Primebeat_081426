/-
ClosedLoopChain — block J3 of `lean_stage3/design/closedloop.md`. 2026-11-23.

The rest of Julian's closed loop
(`lean_primebeat/PrimeBeat/primebeat_closed_loop.lean`, Parts I, III, IV, V,
VI) restated word for word in Stage 3 and joined, link by link, to the table
and its mirror. Unit 0476 joined Parts VII, VIII, XI.

  Part I    the Holy Family: J + M = 1, M = 2·J ⊢ J = 1/3, M = 2/3, midpoint 1/2
            JOIN  holyFamily_is_mirror_pair   M is the mirror of J: M = 1 − J
                  holyFamily_pair_area        b^J · b^M = b, the mirror's area
                  holyFamily_force            the force is the same at J and M
  Part III  Midpoint (n+1) = 2·Midpoint n + 1/2 ⊢ Midpoint n = 2^n − 1/2
            JOIN  row_at_midpoint             2 ≤ n ⊢ the count of primes up to
                                              Midpoint n is the table's row π(2^n)
  Part IV   boundary_is_two, midpoint_base_is_unique: the base is 2
  Part V    sextic_lattice: a prime above 3 is 1 or 5 mod 6
  Part VI   the Prime Beat
            JOIN  primeBeatTerm_eq_im         each term is minus the imaginary
                                              part of the prime's step p^(−(1/2+it))
                  generalized_weight          its weight at σ is the handshake's
                                              weight `ClosedLoopJoin.primeWeight`

The two packages are separate, so nothing is imported from the closed loop.

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.SpiralLink

namespace ClosedLoopChain

open ClosedLoopJoin

/-! ### Part I — the Holy Family -/

/-- Support and condition: two parts of one whole, the second twice the first.
Restated from the closed loop, Part I. -/
structure HolyFamily where
  J : ℝ
  M : ℝ
  unity : J + M = 1
  womb_ratio : M = 2 * J

/-- The support is one third. -/
theorem derive_joseph (hf : HolyFamily) : hf.J = 1 / 3 := by
  have h := hf.unity
  rw [hf.womb_ratio] at h
  linarith

/-- The condition is two thirds. -/
theorem derive_mary (hf : HolyFamily) : hf.M = 2 / 3 := by
  rw [hf.womb_ratio, derive_joseph hf]
  norm_num

/-- The critical line is the midpoint of the two. -/
theorem derive_critical_line (hf : HolyFamily) : (hf.J + hf.M) / 2 = 1 / 2 := by
  rw [hf.unity]

/-- **JOIN.** The two members of the Holy Family are a point and its mirror:
the condition is one less the support. -/
theorem holyFamily_is_mirror_pair (hf : HolyFamily) : hf.M = 1 - hf.J := by
  linarith [hf.unity]

/-- **JOIN.** At any base the sizes at the support and at the condition multiply
to the base: the area of the tree's mirror (`MirrorArea.mirror_area`). -/
theorem holyFamily_pair_area (hf : HolyFamily) {b : ℝ} (hb : 0 < b) :
    b ^ hf.J * b ^ hf.M = b := by
  rw [← Real.rpow_add hb, hf.unity, Real.rpow_one]

/-- **JOIN.** The restoring force is the same at the support and at the
condition: both are one sixth from one half. -/
theorem holyFamily_force (hf : HolyFamily) :
    restoringForce hf.J = 5 / 6 ∧ restoringForce hf.M = 5 / 6 := by
  rw [force_eq, force_eq, derive_joseph hf, derive_mary hf]
  constructor <;> norm_num [abs_of_neg, abs_of_pos]

/-! ### Part III — the doubling and its half -/

/-- The midpoint of each doubling. Restated from the closed loop, Part III. -/
def Midpoint : ℕ → ℚ
  | 0 => 1 / 2
  | (n + 1) => 2 * Midpoint n + 1 / 2

/-- The midpoint of the `n`-th doubling is `2^n − 1/2`. -/
theorem structural_ignition (n : ℕ) : Midpoint n = (2 ^ n : ℚ) - 1 / 2 := by
  induction n with
  | zero => norm_num [Midpoint]
  | succ k ih =>
    rw [Midpoint, ih]
    ring

/-- The offset from the integer below is one half at every doubling. -/
theorem ignition_energy_is_half (n : ℕ) : Midpoint n - ((2 ^ n : ℚ) - 1) = 1 / 2 := by
  rw [structural_ignition n]
  ring

/-- The integer part of the midpoint of the `n`-th doubling is `2^n − 1`. -/
theorem floor_midpoint (n : ℕ) : ⌊((Midpoint n : ℚ) : ℝ)⌋₊ = 2 ^ n - 1 := by
  rw [structural_ignition n]
  have h1 : (1 : ℕ) ≤ 2 ^ n := Nat.one_le_two_pow
  rw [Nat.floor_eq_iff (by
    push_cast
    have : (1 : ℝ) ≤ (2 : ℝ) ^ n := one_le_pow₀ (by norm_num)
    linarith)]
  push_cast [Nat.cast_sub h1]
  constructor <;> linarith

/-- **JOIN.** From the second doubling on, the count of primes up to the
midpoint is the table's row: the count of primes up to `2^n`. -/
theorem row_at_midpoint {n : ℕ} (hn : 2 ≤ n) :
    Nat.primeCounting ⌊((Midpoint n : ℚ) : ℝ)⌋₊ = Nat.primeCounting (2 ^ n) := by
  classical
  rw [floor_midpoint n]
  have h1 : (1 : ℕ) ≤ 2 ^ n := Nat.one_le_two_pow
  have hnp : ¬ Nat.Prime (2 ^ n) := Nat.Prime.not_prime_pow hn
  simp only [Nat.primeCounting, Nat.primeCounting']
  have hc : Nat.count Nat.Prime (2 ^ n + 1)
      = Nat.count Nat.Prime (2 ^ n) + (if Nat.Prime (2 ^ n) then 1 else 0) := Nat.count_succ _ _
  rw [hc, if_neg hnp, add_zero, Nat.sub_add_cancel h1]

/-! ### Part IV — the base is two -/

/-- The boundary constant is two. -/
theorem boundary_is_two (A B C : ℝ) (hA : A ≠ 0) (h_base : A = B - C)
    (h_extended : A = (B - C) * (B - 1)) : B = 2 := by
  rw [← h_base] at h_extended
  have h : A * 1 = A * (B - 1) := by rw [mul_one]; exact h_extended
  have hB : (1 : ℝ) = B - 1 := mul_left_cancel₀ hA h
  linarith

/-- The base of the midpoint recurrence is two. -/
theorem midpoint_base_is_unique (B : ℚ) (h : B * (1 / 2 : ℚ) + 1 / 2 = B - 1 / 2) : B = 2 := by
  linarith

/-! ### Part V — the sextic lattice -/

/-- A prime above three is one or five modulo six. -/
theorem sextic_lattice (p : ℕ) (hp : Nat.Prime p) (hp_gt_3 : p > 3) :
    p % 6 = 1 ∨ p % 6 = 5 := by
  have h2 : ¬ 2 ∣ p := by
    intro h
    have := hp.eq_one_or_self_of_dvd 2 h
    omega
  have h3 : ¬ 3 ∣ p := by
    intro h
    have := hp.eq_one_or_self_of_dvd 3 h
    omega
  have mod2 : p % 2 ≠ 0 := mt Nat.dvd_of_mod_eq_zero h2
  have mod3 : p % 3 ≠ 0 := mt Nat.dvd_of_mod_eq_zero h3
  omega

/-! ### Part VI — the Prime Beat -/

/-- One prime's term of the Prime Beat. Restated from Part VI. -/
noncomputable def primeBeatTerm (t : ℝ) (p : ℕ) : ℝ :=
  (p : ℝ) ^ (-(1 / 2 : ℝ)) * Real.sin (t * Real.log (p : ℝ))

/-- The Prime Beat over the lattice primes up to `N`. Restated from Part VI. -/
noncomputable def primeBeat (N : ℕ) (t : ℝ) : ℝ :=
  |∑ p ∈ (Finset.range (N + 1)).filter (fun p => Nat.Prime p ∧ p > 3), primeBeatTerm t p|

/-- The Prime Beat at a general weight. Restated from Part VI. -/
noncomputable def generalizedPrimeBeat (N : ℕ) (σ : ℝ) (t : ℝ) : ℝ :=
  let latticePrimes := (Finset.range (N + 1)).filter (fun p => Nat.Prime p ∧ p > 3)
  |∑ p ∈ latticePrimes, (p : ℝ) ^ (-σ) * Real.sin (t * Real.log (p : ℝ))|

/-- **JOIN.** A prime's term of the Prime Beat is minus the imaginary part of
the prime's step `p^(−(1/2 + it))`: the Beat is the imaginary part of the walk. -/
theorem primeBeatTerm_eq_im (t : ℝ) {p : ℕ} (hp : 0 < p) :
    primeBeatTerm t p
      = -(((p : ℝ) : ℂ) ^ (-((1 / 2 : ℂ) + (t : ℂ) * Complex.I))).im := by
  have hp0 : (0 : ℝ) < (p : ℝ) := by exact_mod_cast hp
  have hne : ((p : ℝ) : ℂ) ≠ 0 := by exact_mod_cast hp0.ne'
  obtain ⟨L, hL⟩ : ∃ L : ℝ, L = Real.log (p : ℝ) := ⟨_, rfl⟩
  have hre : ((L : ℂ) * -((1 / 2 : ℂ) + (t : ℂ) * Complex.I)).re = L * -(1 / 2 : ℝ) := by
    simp [Complex.mul_re]
  have him : ((L : ℂ) * -((1 / 2 : ℂ) + (t : ℂ) * Complex.I)).im = -(t * L) := by
    simp [Complex.mul_im]
    try ring
  unfold primeBeatTerm
  rw [Complex.cpow_def_of_ne_zero hne, ← Complex.ofReal_log hp0.le, ← hL, Complex.exp_im,
    hre, him, Real.sin_neg, Real.rpow_def_of_pos hp0, ← hL]
  ring

/-- **JOIN.** The weight of a prime in the general Beat is the handshake's
weight. -/
theorem generalized_weight (p : ℕ) (σ : ℝ) : (p : ℝ) ^ (-σ) = primeWeight p σ := rfl

/-- The general Beat at one half is the Prime Beat. -/
theorem generalized_at_half (N : ℕ) (t : ℝ) : generalizedPrimeBeat N (1 / 2) t = primeBeat N t := rfl

/-- info: 'ClosedLoopChain.holyFamily_is_mirror_pair' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms holyFamily_is_mirror_pair

/-- info: 'ClosedLoopChain.holyFamily_pair_area' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms holyFamily_pair_area

/-- info: 'ClosedLoopChain.holyFamily_force' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms holyFamily_force

/-- info: 'ClosedLoopChain.row_at_midpoint' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms row_at_midpoint

/-- info: 'ClosedLoopChain.primeBeatTerm_eq_im' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms primeBeatTerm_eq_im

end ClosedLoopChain
