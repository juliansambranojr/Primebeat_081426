/-
NoHoles — block R13 of `lean_stage3/design/runs.md`. 2026-11-24.

The staircase at `N` read back from the logarithms of the integers alone.
Möbius inversion over the scales `N/k` undoes the self-bound of
`Stage3.SelfBound`, so `ψ(N)` is a signed sum of the log-sums up to `N/k`.
Each log-sum is `M log M − M` up to an error of size `log M + 1`, which
splits `ψ(N)` into a smooth part and an error part.

  moebius_floor_inversion  Σ_{k≤N} μ(k)·Σ_{j≤N/k} f(N/k/j) = f(N), for 1 ≤ N
  psi_floor                ψ(N/k) = ψ(⌊N/k⌋)
  psi_by_integers          ψ(N) = Σ_{k≤N} μ(k)·Σ_{n≤N/k} log n, for 1 ≤ N
  log_factorial_close      |Σ_{n≤M} log n − (M log M − M)| ≤ log M + 1, for 1 ≤ M
  holes_resid              ψ(N) = Σ_{k≤N} μ(k)·S(N/k) + Σ_{k≤N} μ(k)·e(N/k), for 1 ≤ N
  holes_err_trivial        |Σ_{k≤N} μ(k)·e(N/k)| ≤ Σ_{k≤N} |e(N/k)|

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.SelfBound

namespace NoHoles

open Finset ArithmeticFunction

/-- The Möbius function sums to `[m = 1]` over the divisors of `m`. -/
theorem sum_divisors_moebius (m : ℕ) :
    ∑ i ∈ m.divisors, ((moebius i : ℤ) : ℝ) = if m = 1 then 1 else 0 := by
  have h := congrArg (fun F : ArithmeticFunction ℝ => F m) (coe_moebius_mul_coe_zeta (R := ℝ))
  simp only [coe_mul_zeta_apply, intCoe_apply, one_apply] at h
  exact h

/-- The multiples of `k` up to `N`, as the image of `j ↦ k·j` on `1..N/k`. -/
theorem multiples_eq_image (N : ℕ) {k : ℕ} (hk : 1 ≤ k) :
    (Icc 1 N).filter (fun m => k ∣ m) = (Icc 1 (N / k)).image (fun j => k * j) := by
  ext m
  simp only [mem_filter, mem_Icc, mem_image]
  constructor
  · rintro ⟨⟨h1, h2⟩, ⟨c, rfl⟩⟩
    refine ⟨c, ⟨?_, ?_⟩, rfl⟩
    · rcases Nat.eq_zero_or_pos c with hc | hc
      · subst hc; simp at h1
      · exact hc
    · rw [Nat.le_div_iff_mul_le (by omega), mul_comm]
      exact h2
  · rintro ⟨j, ⟨hj1, hj2⟩, rfl⟩
    refine ⟨⟨?_, ?_⟩, ⟨j, rfl⟩⟩
    · exact Nat.mul_pos (by omega) (by omega)
    · rw [Nat.le_div_iff_mul_le (by omega)] at hj2
      rw [mul_comm]
      exact hj2

/-- **Möbius inversion over the floors.** -/
theorem moebius_floor_inversion (f : ℕ → ℝ) {N : ℕ} (hN : 1 ≤ N) :
    ∑ k ∈ Icc 1 N, ((moebius k : ℤ) : ℝ) * ∑ j ∈ Icc 1 (N / k), f (N / k / j) = f N := by
  have hA : ∀ k ∈ Icc 1 N, ∑ j ∈ Icc 1 (N / k), f (N / k / j)
      = ∑ m ∈ Icc 1 N, if k ∣ m then f (N / m) else 0 := by
    intro k hk
    have hk1 : 1 ≤ k := (mem_Icc.mp hk).1
    rw [← Finset.sum_filter, multiples_eq_image N hk1, Finset.sum_image]
    · refine Finset.sum_congr rfl fun j _ => ?_
      rw [Nat.div_div_eq_div_mul]
    · intro a _ b _ hab
      exact Nat.eq_of_mul_eq_mul_left (by omega) hab
  rw [Finset.sum_congr rfl fun k hk => by rw [hA k hk]]
  simp only [Finset.mul_sum, mul_ite, mul_zero]
  rw [Finset.sum_comm]
  have hB : ∀ m ∈ Icc 1 N, (∑ k ∈ Icc 1 N, if k ∣ m then ((moebius k : ℤ) : ℝ) * f (N / m) else 0)
      = (if m = 1 then 1 else 0) * f (N / m) := by
    intro m hm
    rw [mem_Icc] at hm
    rw [← Finset.sum_filter, ← sum_divisors_moebius, Finset.sum_mul]
    refine Finset.sum_congr ?_ (fun _ _ => rfl)
    ext d
    simp only [Nat.mem_divisors, mem_filter, mem_Icc]
    constructor
    · rintro ⟨_, hd⟩
      exact ⟨hd, by omega⟩
    · rintro ⟨hd, _⟩
      exact ⟨⟨Nat.pos_of_dvd_of_pos hd (by omega),
        (Nat.le_of_dvd (by omega) hd).trans hm.2⟩, hd⟩
  rw [Finset.sum_congr rfl hB]
  simp only [ite_mul, one_mul, zero_mul]
  rw [Finset.sum_ite_eq']
  simp [mem_Icc, hN]

/-- The staircase depends on the floor of its argument. -/
theorem psi_floor (N k : ℕ) :
    Chebyshev.psi ((N : ℝ) / (k : ℝ)) = Chebyshev.psi ((N / k : ℕ) : ℝ) := by
  rw [Chebyshev.psi_eq_psi_coe_floor, Nat.floor_div_eq_div]

/-- **The staircase from the integers.** -/
theorem psi_by_integers (N : ℕ) (hN : 1 ≤ N) :
    Chebyshev.psi (N : ℝ)
      = ∑ k ∈ Icc 1 N, ((moebius k : ℤ) : ℝ) * ∑ n ∈ Icc 1 (N / k), Real.log (n : ℝ) := by
  rw [← moebius_floor_inversion (fun M => Chebyshev.psi (M : ℝ)) hN]
  refine Finset.sum_congr rfl fun k _ => ?_
  congr 1
  rw [← SelfBound.self_bound]
  exact Finset.sum_congr rfl fun j _ => (psi_floor (N / k) j).symm

/-- The log-sum is the logarithm of the factorial. -/
theorem sum_log_eq (M : ℕ) :
    ∑ n ∈ Icc 1 M, Real.log (n : ℝ) = Real.log ((M.factorial : ℕ) : ℝ) := by
  induction M with
  | zero => simp
  | succ n ih =>
    rw [Finset.sum_Icc_succ_top (by omega), ih, Nat.factorial_succ, Nat.cast_mul,
      Real.log_mul (by positivity) (Nat.cast_ne_zero.mpr (Nat.factorial_ne_zero n))]
    ring

/-- **The log-sum is `M log M − M` up to `log M + 1`.** -/
theorem log_factorial_close {M : ℕ} (hM : 1 ≤ M) :
    |∑ n ∈ Icc 1 M, Real.log (n : ℝ) - ((M : ℝ) * Real.log (M : ℝ) - (M : ℝ))|
      ≤ Real.log (M : ℝ) + 1 := by
  rw [sum_log_eq]
  have hM0 : M ≠ 0 := by omega
  have hlogM : 0 ≤ Real.log (M : ℝ) := Real.log_nonneg (by exact_mod_cast hM)
  have hlow := Stirling.le_log_factorial_stirling hM0
  have h2pi : 0 ≤ Real.log (2 * Real.pi) :=
    Real.log_nonneg (by linarith [Real.pi_gt_three])
  obtain ⟨m, rfl⟩ : ∃ m, M = m + 1 := ⟨M - 1, by omega⟩
  have hanti : Stirling.stirlingSeq (m + 1) ≤ Stirling.stirlingSeq 1 :=
    Stirling.stirlingSeq'_antitone (Nat.zero_le m)
  have hpos := Stirling.stirlingSeq'_pos m
  have hlogS : Real.log (Stirling.stirlingSeq (m + 1)) ≤ 1 - Real.log 2 / 2 := by
    have h := Real.log_le_log hpos hanti
    rw [Stirling.stirlingSeq_one, Real.log_div (Real.exp_pos 1).ne' (by positivity),
      Real.log_exp, Real.log_sqrt (by norm_num)] at h
    exact h
  have hform := Stirling.log_stirlingSeq_formula (m + 1)
  have hl2 : Real.log (2 * ((m + 1 : ℕ) : ℝ)) = Real.log 2 + Real.log ((m + 1 : ℕ) : ℝ) :=
    Real.log_mul (by norm_num) (by positivity)
  have hle : ((m + 1 : ℕ) : ℝ) * Real.log (((m + 1 : ℕ) : ℝ) / Real.exp 1)
      = ((m + 1 : ℕ) : ℝ) * Real.log ((m + 1 : ℕ) : ℝ) - ((m + 1 : ℕ) : ℝ) := by
    rw [Real.log_div (by positivity) (Real.exp_pos 1).ne', Real.log_exp]
    ring
  rw [hl2, hle] at hform
  rw [abs_le]
  constructor <;> linarith

/-- The smooth part of the log-sum. -/
noncomputable
def S (M : ℕ) : ℝ := (M : ℝ) * Real.log (M : ℝ) - (M : ℝ)

/-- The error of the log-sum against its smooth part. -/
noncomputable
def e (M : ℕ) : ℝ := ∑ n ∈ Icc 1 M, Real.log (n : ℝ) - S M

/-- The error at every scale is bounded by `log M + 1`. -/
theorem e_bound {M : ℕ} (hM : 1 ≤ M) : |e M| ≤ Real.log (M : ℝ) + 1 := by
  simp only [e, S]
  exact log_factorial_close hM

/-- **The staircase split into its smooth part and its error part.** -/
theorem holes_resid (N : ℕ) (hN : 1 ≤ N) :
    Chebyshev.psi (N : ℝ)
      = ∑ k ∈ Icc 1 N, ((moebius k : ℤ) : ℝ) * S (N / k)
        + ∑ k ∈ Icc 1 N, ((moebius k : ℤ) : ℝ) * e (N / k) := by
  rw [psi_by_integers N hN, ← Finset.sum_add_distrib]
  refine Finset.sum_congr rfl fun k _ => ?_
  simp only [e]
  ring

/-- The error part, bounded with `|μ| ≤ 1` alone. -/
theorem holes_err_trivial (N : ℕ) :
    |∑ k ∈ Icc 1 N, ((moebius k : ℤ) : ℝ) * e (N / k)| ≤ ∑ k ∈ Icc 1 N, |e (N / k)| := by
  refine (abs_sum_le_sum_abs _ _).trans (Finset.sum_le_sum fun k _ => ?_)
  rw [abs_mul]
  have hmu : |((moebius k : ℤ) : ℝ)| ≤ 1 := by
    rw [← Int.cast_abs]
    exact_mod_cast abs_moebius_le_one
  exact mul_le_of_le_one_left (abs_nonneg _) hmu

/-- info: 'NoHoles.moebius_floor_inversion' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms moebius_floor_inversion

/-- info: 'NoHoles.psi_floor' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms psi_floor

/-- info: 'NoHoles.psi_by_integers' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms psi_by_integers

/-- info: 'NoHoles.log_factorial_close' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms log_factorial_close

/-- info: 'NoHoles.holes_resid' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms holes_resid

/-- info: 'NoHoles.holes_err_trivial' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms holes_err_trivial

end NoHoles
