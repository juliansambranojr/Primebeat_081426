/-
# Stage3.SdiagLeadCop — the coprimality step, exact. 2026-11-25.

Step 3 of the route in `Stage3/DiagMain.lean`'s docstring, the exact part:
`μ(dn) = μ(d) μ(n) 1_{(n,d)=1}` (`mu_mul_eq`), `μ·1_{(·,d)=1} = 1_{⟨d⟩} * μ` with
`⟨d⟩ = {m : primes of m ⊆ primes of d}` (`copAF_eq`), and the weighted hyperbola swap
(`sum_conv_weight`) give

`A_d(γ) = μ(d) Σ_{m ≤ M/d, m ∈ ⟨d⟩} m^{−(1+γ)} Smu(M/(dm), γ)` (`Ad_eq`),

with `Smu(x, γ) = Σ_{k ≤ x} μ(k) P(log(x/k)/log M) k^{−(1+γ)}` the sum of `SdiagLeadSmooth`.

| name | content | status |
|---|---|---|
| `chiAF`, `copAF` | `1_{⟨d⟩}`; `μ·1_{(·,d)=1}` | def |
| `chiAF_mult`, `copAF_mult` | both multiplicative | proved |
| `mu_mul_eq` | `μ(dn) = μ(d)·copAF_d(n)` | proved |
| `copAF_eq` | `copAF_d = chiAF_d * μ` | proved |
| `sum_conv_weight` | `Σ_{n ≤ N} (f*g)(n) w(n) = Σ_{m ≤ N} f(m) Σ_{k ≤ N/m} g(k) w(mk)` | proved |
| `Ad_eq` | `A_d(γ) = μ(d) Σ_{m ∈ ⟨d⟩, m ≤ M/d} m^{−(1+γ)} Smu(M/(dm), γ)` | proved |

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Stage3.SdiagLeadSmooth

namespace SdiagLead

open Complex Finset
open scoped ArithmeticFunction.Moebius

noncomputable section

/-- `1_{⟨d⟩}(m)`: `m ≠ 0` and every prime of `m` divides `d`. -/
def chiAF (d : ℕ) : ArithmeticFunction ℤ :=
  ⟨fun m => if m ≠ 0 ∧ m.primeFactors ⊆ d.primeFactors then 1 else 0, by simp⟩

/-- `μ(n) 1_{(n,d)=1}`. -/
def copAF (d : ℕ) : ArithmeticFunction ℤ :=
  ⟨fun n => if n.Coprime d then μ n else 0, by simp⟩

theorem chiAF_apply (d m : ℕ) :
    chiAF d m = if m ≠ 0 ∧ m.primeFactors ⊆ d.primeFactors then 1 else 0 := rfl

theorem copAF_apply (d n : ℕ) : copAF d n = if n.Coprime d then μ n else 0 := rfl

theorem chiAF_mult (d : ℕ) : (chiAF d).IsMultiplicative := by
  rw [ArithmeticFunction.IsMultiplicative.iff_ne_zero]
  refine ⟨by simp [chiAF_apply], fun {m n} hm hn _ => ?_⟩
  simp only [chiAF_apply, mul_ne_zero_iff, Nat.primeFactors_mul hm hn, Finset.union_subset_iff]
  by_cases h1 : m.primeFactors ⊆ d.primeFactors <;> by_cases h2 : n.primeFactors ⊆ d.primeFactors <;>
    simp [h1, h2, hm, hn]

theorem copAF_mult (d : ℕ) : (copAF d).IsMultiplicative := by
  rw [ArithmeticFunction.IsMultiplicative.iff_ne_zero]
  refine ⟨by simp [copAF_apply], fun {m n} _ _ hmn => ?_⟩
  simp only [copAF_apply, Nat.coprime_mul_iff_left,
    ArithmeticFunction.isMultiplicative_moebius.map_mul_of_coprime hmn]
  rw [ite_zero_mul_ite_zero]

/-- `μ(dn) = μ(d) μ(n) 1_{(n,d)=1}`. -/
theorem mu_mul_eq (d n : ℕ) : μ (d * n) = μ d * copAF d n := by
  rw [copAF_apply]
  by_cases h : n.Coprime d
  · rw [if_pos h, ArithmeticFunction.isMultiplicative_moebius.map_mul_of_coprime h.symm]
  · rw [if_neg h, mul_zero]
    apply ArithmeticFunction.moebius_eq_zero_of_not_squarefree
    intro hsq
    exact h (Nat.coprime_of_squarefree_mul hsq).symm

theorem chiAF_prime_pow {d p : ℕ} (hd : d ≠ 0) (hp : p.Prime) {i : ℕ} (hi : i ≠ 0) :
    chiAF d (p ^ i) = if p ∣ d then 1 else 0 := by
  rw [chiAF_apply, Nat.primeFactors_prime_pow hi hp]
  have hne : p ^ i ≠ 0 := pow_ne_zero _ hp.ne_zero
  by_cases h : p ∣ d
  · rw [if_pos ⟨hne, by simp [Nat.mem_primeFactors, hp, h, hd]⟩, if_pos h]
  · rw [if_neg, if_neg h]
    rintro ⟨-, hs⟩
    exact h (Nat.dvd_of_mem_primeFactors (hs (Finset.mem_singleton_self p)))

/-- `(f * g)(p^i) = Σ_{j ≤ i} f(p^j) g(p^{i−j})`. -/
theorem mul_prime_pow (f g : ArithmeticFunction ℤ) {p : ℕ} (hp : p.Prime) (i : ℕ) :
    (f * g) (p ^ i) = ∑ j ∈ range (i + 1), f (p ^ j) * g (p ^ (i - j)) := by
  rw [ArithmeticFunction.mul_apply, Nat.sum_divisorsAntidiagonal (fun a b => f a * g b),
    Nat.divisors_prime_pow hp, Finset.sum_map]
  refine Finset.sum_congr rfl fun j hj => ?_
  have hj' : j ≤ i := Nat.lt_succ_iff.mp (Finset.mem_range.mp hj)
  simp only [Function.Embedding.coeFn_mk]
  rw [Nat.pow_div hj' hp.pos]

/-- **`μ·1_{(·,d)=1} = 1_{⟨d⟩} * μ`**. -/
theorem copAF_eq {d : ℕ} (hd : d ≠ 0) : copAF d = chiAF d * μ := by
  refine (ArithmeticFunction.IsMultiplicative.eq_iff_eq_on_prime_powers _ (copAF_mult d) _
    ((chiAF_mult d).mul ArithmeticFunction.isMultiplicative_moebius)).mpr fun p i hp => ?_
  rw [mul_prime_pow _ _ hp]
  rcases Nat.lt_or_ge i 2 with hi | hi
  · interval_cases i
    · simp only [zero_add, Finset.sum_range_one, pow_zero, Nat.sub_self]
      rw [copAF_apply, chiAF_apply, if_pos (Nat.coprime_one_left d), if_pos ⟨one_ne_zero, by simp⟩,
        one_mul]
    · simp only [pow_one, Finset.sum_range_succ, Finset.range_one, Finset.sum_singleton,
        pow_zero, Nat.sub_zero, Nat.sub_self, copAF_apply]
      have hc := chiAF_prime_pow hd hp one_ne_zero
      rw [pow_one] at hc
      rw [hc, ArithmeticFunction.moebius_apply_prime hp, ArithmeticFunction.moebius_apply_one]
      have h1 : chiAF d 1 = 1 := by rw [chiAF_apply, if_pos ⟨one_ne_zero, by simp⟩]
      rw [h1]
      by_cases h : p ∣ d
      · rw [if_neg ((Nat.Prime.coprime_iff_not_dvd hp).not.mpr (not_not.mpr h)), if_pos h]; ring
      · rw [if_pos ((Nat.Prime.coprime_iff_not_dvd hp).mpr h), if_neg h]; ring
  · obtain ⟨k, rfl⟩ : ∃ k, i = k + 2 := ⟨i - 2, by omega⟩
    have hl : copAF d (p ^ (k + 2)) = 0 := by
      rw [copAF_apply, ArithmeticFunction.moebius_apply_prime_pow hp (by omega)]
      simp
    rw [hl, Finset.sum_range_succ, Finset.sum_range_succ]
    have hz : ∑ j ∈ range (k + 1), chiAF d (p ^ j) * μ (p ^ (k + 2 - j)) = 0 := by
      refine Finset.sum_eq_zero fun j hj => ?_
      have hj' := Finset.mem_range.mp hj
      rw [ArithmeticFunction.moebius_apply_prime_pow hp (by omega), if_neg (by omega), mul_zero]
    rw [hz, show k + 2 - (k + 1) = 1 by omega, Nat.sub_self,
      pow_one, ArithmeticFunction.moebius_apply_prime hp, pow_zero,
      ArithmeticFunction.moebius_apply_one, chiAF_prime_pow hd hp (by omega : k + 1 ≠ 0),
      chiAF_prime_pow hd hp (by omega : k + 2 ≠ 0)]
    ring

/-- **The weighted hyperbola swap**: `Σ_{n ≤ N} (f*g)(n) w(n) = Σ_{m ≤ N} f(m) Σ_{k ≤ N/m} g(k) w(mk)`. -/
theorem sum_conv_weight (f g : ArithmeticFunction ℤ) (N : ℕ) (w : ℕ → ℂ) :
    ∑ n ∈ Ioc 0 N, (((f * g) n : ℤ) : ℂ) * w n =
      ∑ m ∈ Ioc 0 N, ((f m : ℤ) : ℂ) * ∑ k ∈ Ioc 0 (N / m), ((g k : ℤ) : ℂ) * w (m * k) := by
  have h1 : ∀ n ∈ Ioc 0 N, (((f * g) n : ℤ) : ℂ) * w n =
      ∑ m ∈ n.divisors, ((f m : ℤ) : ℂ) * (((g (n / m)) : ℤ) : ℂ) * w n := by
    intro n _
    rw [ArithmeticFunction.mul_apply, Nat.sum_divisorsAntidiagonal (fun a b => f a * g b)]
    push_cast
    rw [Finset.sum_mul]
  rw [Finset.sum_congr rfl h1]
  rw [Finset.sum_comm' (t' := Ioc 0 N) (s' := fun m => (Ioc 0 N).filter (m ∣ ·))]
  · refine Finset.sum_congr rfl fun m hm => ?_
    have hm1 : 1 ≤ m := (Finset.mem_Ioc.mp hm).1
    rw [Finset.mul_sum]
    have e : ∀ N : ℕ, Ioc 0 N = Icc 1 N := fun N => by ext; simp [Nat.lt_iff_add_one_le]
    rw [e, e, sum_dvd_reindex N hm1 (fun n => ((f m : ℤ) : ℂ) * ((g (n / m) : ℤ) : ℂ) * w n)]
    refine Finset.sum_congr rfl fun k _ => ?_
    rw [Nat.mul_div_cancel_left k hm1]; ring
  · intro n m
    simp only [Finset.mem_Ioc, Nat.mem_divisors, Finset.mem_filter]
    constructor
    · rintro ⟨⟨hn0, hnN⟩, hmn, -⟩
      exact ⟨⟨⟨hn0, hnN⟩, hmn⟩, Nat.pos_of_dvd_of_pos hmn hn0, le_trans (Nat.le_of_dvd hn0 hmn) hnN⟩
    · rintro ⟨⟨⟨hn0, hnN⟩, hmn⟩, -⟩
      exact ⟨⟨hn0, hnN⟩, hmn, hn0.ne'⟩

/-- **`A_d(γ) = μ(d) Σ_{m ∈ ⟨d⟩, m ≤ M/d} m^{−(1+γ)} Smu(M/(dm), γ)`**. -/
theorem Ad_eq (P : Polynomial ℝ) (M : ℕ) {d : ℕ} (hd : 1 ≤ d) (γ : ℂ) :
    Ad P M d γ = ((μ d : ℤ) : ℂ) * ∑ m ∈ Ioc 0 (M / d), ((chiAF d m : ℤ) : ℂ) *
      ((m : ℂ) ^ (-(1 + γ)) * Smu P (Real.log M) ((M : ℝ) / d / m) γ) := by
  have hd0 : (0 : ℝ) < d := by exact_mod_cast hd
  set x : ℝ := (M : ℝ) / d with hx
  set w : ℕ → ℂ := fun n => ((P.eval (Real.log (x / n) / Real.log M) : ℝ) : ℂ) *
    (n : ℂ) ^ (-(1 + γ)) with hw
  have e : ∀ N : ℕ, Icc 1 N = Ioc 0 N := fun N => by ext; simp [Nat.lt_iff_add_one_le]
  have h1 : Ad P M d γ = ((μ d : ℤ) : ℂ) * ∑ n ∈ Ioc 0 (M / d), ((copAF d n : ℤ) : ℂ) * w n := by
    unfold Ad
    rw [e, Finset.mul_sum]
    refine Finset.sum_congr rfl fun n _ => ?_
    rw [mu_mul_eq]
    have hP : Pw P M (d * n) = P.eval (Real.log (x / n) / Real.log M) := by
      unfold Pw; rw [hx]; push_cast; rw [div_div]
    rw [hP, hw]; push_cast; ring
  rw [h1, copAF_eq (by omega), sum_conv_weight]
  congr 1
  refine Finset.sum_congr rfl fun m hm => ?_
  have hm1 : 1 ≤ m := (Finset.mem_Ioc.mp hm).1
  have hm0 : (m : ℂ) ≠ 0 := by exact_mod_cast (by omega : m ≠ 0)
  have hm0' : (0 : ℝ) < m := by exact_mod_cast hm1
  unfold Smu
  have hfl : ⌊x / m⌋₊ = M / d / m := by
    rw [hx, Nat.floor_div_natCast, Nat.floor_div_eq_div]
  rw [hfl]
  congr 1
  rw [Finset.mul_sum]
  refine Finset.sum_congr rfl fun k _ => ?_
  simp only [hw]
  rw [Diagonal.ncpow_mul, show x / ((m * k : ℕ) : ℝ) = x / m / k by rw [hx]; push_cast; field_simp]
  ring

end

/-- info: 'SdiagLead.Ad_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Ad_eq

/-- info: 'SdiagLead.copAF_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms copAF_eq

end SdiagLead
