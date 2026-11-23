/-
SelfBound — block R7 of `lean_stage3/design/runs.md`. 2026-11-23.

The number line bounded by itself. Every integer's logarithm is the sum of the
steps at its divisors, so the staircase of the steps, read at `N`, `N/2`,
`N/3`, …, adds up to the logarithms of the integers up to `N`, exactly, at
every `N`. An excess of the staircase at one of these scales is paid back at
the others.

  log_sum_eq        Σ_{n≤N} log n = Σ_{d≤N} Λ(d)·⌊N/d⌋
  psi_scale         1 ≤ k ⊢ ψ(N/k) = Σ_{d≤N} [d·k ≤ N]·Λ(d)
  self_bound        Σ_{k≤N} ψ(N/k) = Σ_{n≤N} log n
  self_bound_resid  Σ_{k≤N} (ψ(N/k) − N/k) = Σ_{n≤N} log n − N·Σ_{k≤N} 1/k

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.HalfSieve

namespace SelfBound

open Finset ArithmeticFunction

/-- **Every logarithm is the steps at its divisors.** Summed up to `N`, each
step `Λ(d)` is counted once for every multiple of `d` up to `N`. -/
theorem log_sum_eq (N : ℕ) :
    ∑ n ∈ Icc 1 N, Real.log (n : ℝ) = ∑ d ∈ Icc 1 N, vonMangoldt d * ((N / d : ℕ) : ℝ) := by
  have h1 : ∀ n ∈ Icc 1 N,
      Real.log (n : ℝ) = ∑ d ∈ Icc 1 N, if d ∣ n then vonMangoldt d else 0 := by
    intro n hn
    rw [mem_Icc] at hn
    rw [← vonMangoldt_sum, ← Finset.sum_filter]
    refine Finset.sum_congr ?_ (fun _ _ => rfl)
    ext d
    simp only [Nat.mem_divisors, mem_filter, mem_Icc]
    constructor
    · rintro ⟨hd, _⟩
      exact ⟨⟨Nat.pos_of_dvd_of_pos hd (by omega),
        (Nat.le_of_dvd (by omega) hd).trans hn.2⟩, hd⟩
    · rintro ⟨_, hd⟩
      exact ⟨hd, by omega⟩
  rw [Finset.sum_congr rfl h1, Finset.sum_comm]
  refine Finset.sum_congr rfl fun d _ => ?_
  rw [← Finset.sum_filter, Finset.sum_const, nsmul_eq_mul, SieveExact.card_multiples, mul_comm]

/-- The staircase at the scale `N/k`, as a sum over the steps up to `N`. -/
theorem psi_scale (N : ℕ) {k : ℕ} (hk : 1 ≤ k) :
    Chebyshev.psi ((N : ℝ) / (k : ℝ)) = ∑ d ∈ Icc 1 N, if d * k ≤ N then vonMangoldt d else 0 := by
  rw [Chebyshev.psi, Nat.floor_div_eq_div, ← Finset.sum_filter]
  refine Finset.sum_congr ?_ (fun _ _ => rfl)
  ext d
  simp only [mem_Ioc, mem_filter, mem_Icc]
  rw [Nat.le_div_iff_mul_le (by omega)]
  constructor
  · rintro ⟨h0, h⟩
    refine ⟨⟨h0, ?_⟩, h⟩
    calc d = d * 1 := (mul_one d).symm
      _ ≤ d * k := Nat.mul_le_mul_left d hk
      _ ≤ N := h
  · rintro ⟨⟨h0, _⟩, h⟩
    exact ⟨h0, h⟩

/-- The number of `k` from `1` to `N` with `d·k ≤ N` is `⌊N/d⌋`. -/
theorem card_scales (N : ℕ) {d : ℕ} (hd : 1 ≤ d) :
    ((Icc 1 N).filter fun k => d * k ≤ N).card = N / d := by
  have : (Icc 1 N).filter (fun k => d * k ≤ N) = Icc 1 (N / d) := by
    ext k
    simp only [mem_filter, mem_Icc]
    rw [Nat.le_div_iff_mul_le (by omega), mul_comm k d]
    constructor
    · rintro ⟨⟨h1, _⟩, h⟩
      exact ⟨h1, h⟩
    · rintro ⟨h1, h⟩
      refine ⟨⟨h1, ?_⟩, h⟩
      calc k = 1 * k := (one_mul k).symm
        _ ≤ d * k := Nat.mul_le_mul_right k hd
        _ ≤ N := h
  rw [this, Nat.card_Icc]
  exact Nat.add_sub_cancel _ _

/-- **The number line bounded by itself.** The staircase of the steps read at
`N`, `N/2`, …, `N/N` adds up to the logarithms of the integers up to `N`. -/
theorem self_bound (N : ℕ) :
    ∑ k ∈ Icc 1 N, Chebyshev.psi ((N : ℝ) / (k : ℝ)) = ∑ n ∈ Icc 1 N, Real.log (n : ℝ) := by
  rw [log_sum_eq]
  have h1 : ∀ k ∈ Icc 1 N, Chebyshev.psi ((N : ℝ) / (k : ℝ))
      = ∑ d ∈ Icc 1 N, if d * k ≤ N then vonMangoldt d else 0 := by
    intro k hk
    exact psi_scale N (mem_Icc.mp hk).1
  rw [Finset.sum_congr rfl h1, Finset.sum_comm]
  refine Finset.sum_congr rfl fun d hd => ?_
  rw [← Finset.sum_filter, Finset.sum_const, nsmul_eq_mul, card_scales N (mem_Icc.mp hd).1,
    mul_comm]

/-- **The residuals across the scales.** The residuals of the staircase at
`N`, `N/2`, …, `N/N` add up to the logarithms of the integers up to `N` less
`N` times the harmonic sum: a quantity with no prime in it. -/
theorem self_bound_resid (N : ℕ) :
    ∑ k ∈ Icc 1 N, (Chebyshev.psi ((N : ℝ) / (k : ℝ)) - (N : ℝ) / (k : ℝ))
      = ∑ n ∈ Icc 1 N, Real.log (n : ℝ) - (N : ℝ) * ∑ k ∈ Icc 1 N, 1 / (k : ℝ) := by
  rw [Finset.sum_sub_distrib, self_bound, Finset.mul_sum]
  congr 1
  refine Finset.sum_congr rfl fun k _ => ?_
  ring

/-- info: 'SelfBound.log_sum_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms log_sum_eq

/-- info: 'SelfBound.self_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms self_bound

/-- info: 'SelfBound.self_bound_resid' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms self_bound_resid

end SelfBound
