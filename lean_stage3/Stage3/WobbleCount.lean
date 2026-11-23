/-
WobbleCount — block W1 of `lean_stage3/design/joints.md`. 2026-11-22.

Why the number line has zeros, as a statement about counting. Each integer is
built from primes in one way; summed over the integers up to `N` that says the
prime content read at `N`, `N/2`, `N/3`, … adds to the logarithms of the
integers, which are as smooth as the integers are evenly spaced
(`count_identity`). A wobble `x^ρ` in the prime content therefore enters that
sum as `wobbleSum ρ N`: the wobble read at `N/1, …, N/N` and added. After its
smooth term `N/(1−ρ)` that sum stays bounded as `N` grows exactly when
`ζ(ρ) = 0` (`invisible_iff`). The zeros are the wobbles the prime count can
carry while the integers stay evenly spaced; ζ is the name of the bracket
`1 + 2^(−ρ) + 3^(−ρ) + …`.

  count_identity        Σ_{n ∈ Ioc 0 N} log n = Σ_{d ∈ Ioc 0 N} Σ_{m ∈ Ioc 0 (N/d)} Λ m
  wobbleSum             wobbleSum ρ N = Σ_{n < N} N^ρ / (n+1)^ρ
  wobbleSum_expansion   0 < N, 0 < ρ.re, ρ ≠ 1
                          ⊢ ∃ E, ‖E‖ ≤ ‖ρ‖·‖ρ+1‖/4 ∧
                              wobbleSum ρ N = ζ ρ·N^ρ + N/(1−ρ) + 1/2 + E
  norm_natCast_cpow     0 < N ⊢ ‖N^ρ‖ = N^(ρ.re)
  invisible_iff         0 < ρ.re, ρ ≠ 1
                          ⊢ (∃ C, ∀ N, 0 < N → ‖wobbleSum ρ N − N/(1−ρ)‖ ≤ C) ↔ ζ ρ = 0

What the next slice needs: nothing here says which real parts the zeros have.
The identity is exact for every `N` whatever the zeros do.

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.ZetaGrowth

namespace WobbleCount

open Complex Set MeasureTheory Finset

noncomputable section

open ArithmeticFunction in
/-- **The integers, counted through their primes.** The logarithms of the
integers up to `N` add to the prime content read at `N`, `N/2`, `N/3`, … -/
theorem count_identity (N : ℕ) :
    ∑ n ∈ Finset.Ioc 0 N, Real.log n
      = ∑ d ∈ Finset.Ioc 0 N, ∑ m ∈ Finset.Ioc 0 (N / d), Λ m := by
  have h := sum_Ioc_mul_eq_sum_sum (R := ℝ) ((zeta : ArithmeticFunction ℕ) : ArithmeticFunction ℝ) Λ N
  rw [mul_comm ((zeta : ArithmeticFunction ℕ) : ArithmeticFunction ℝ) Λ, vonMangoldt_mul_zeta] at h
  simp only [log_apply] at h
  rw [h]
  refine Finset.sum_congr rfl fun d hd => ?_
  have hd0 : d ≠ 0 := by
    have := (Finset.mem_Ioc.mp hd).1
    omega
  simp [natCoe_apply, zeta_apply_ne hd0]

/-- A wobble `x^ρ` read at `N/1, N/2, …, N/N` and added. -/
def wobbleSum (ρ : ℂ) (N : ℕ) : ℂ :=
  ∑ n ∈ Finset.range N, (N : ℂ) ^ ρ / ((n : ℂ) + 1) ^ ρ

/-- The size of a power of a positive integer is the power of its real part. -/
theorem norm_natCast_cpow {N : ℕ} (hN : 0 < N) (ρ : ℂ) : ‖(N : ℂ) ^ ρ‖ = (N : ℝ) ^ ρ.re := by
  have hNpos : (0 : ℝ) < N := by exact_mod_cast hN
  rw [← Complex.ofReal_natCast, Complex.norm_cpow_eq_rpow_re_of_pos hNpos]

/-- **The wobble sum, expanded.** It is `ζ(ρ)·N^ρ`, plus a smooth term, plus
one half, plus a term that stays bounded as `N` grows. -/
theorem wobbleSum_expansion {N : ℕ} (hN : 0 < N) {ρ : ℂ} (hρ : 0 < ρ.re) (hρ1 : ρ ≠ 1) :
    ∃ E : ℂ, ‖E‖ ≤ ‖ρ‖ * ‖ρ + 1‖ / 4 ∧
      wobbleSum ρ N = riemannZeta ρ * (N : ℂ) ^ ρ + (N : ℂ) / (1 - ρ) + 1 / 2 + E := by
  obtain ⟨I, hI⟩ : ∃ I : ℂ,
      I = ∫ x in Ioi (N : ℝ), (ZetaGrowth.emA x : ℂ) * (x : ℂ) ^ (-(ρ + 2)) := ⟨_, rfl⟩
  have hz := ZetaGrowth.zeta1_eq_zeta hN hρ hρ1
  unfold ZetaGrowth.zeta1 at hz
  rw [← hI] at hz
  have hIn : ‖I‖ ≤ (1 / 4) * (N : ℝ) ^ (-ρ.re - 1) := by
    rw [hI]
    exact ZetaGrowth.tail_norm_le hN (by linarith)
  have hN0 : (N : ℂ) ≠ 0 := by exact_mod_cast hN.ne'
  have hNpos : (0 : ℝ) < N := by exact_mod_cast hN
  have h1 : (N : ℂ) ^ (1 - ρ) * (N : ℂ) ^ ρ = N := by
    rw [← Complex.cpow_add _ _ hN0]
    simp
  have h2 : (N : ℂ) ^ (-ρ) * (N : ℂ) ^ ρ = 1 := by
    rw [← Complex.cpow_add _ _ hN0]
    simp
  have hsum : wobbleSum ρ N
      = (∑ n ∈ Finset.range N, 1 / ((n : ℂ) + 1) ^ ρ) * (N : ℂ) ^ ρ := by
    unfold wobbleSum
    rw [Finset.sum_mul]
    exact Finset.sum_congr rfl fun n _ => by ring
  have hS : (∑ n ∈ Finset.range N, 1 / ((n : ℂ) + 1) ^ ρ)
      = riemannZeta ρ + (N : ℂ) ^ (1 - ρ) / (1 - ρ) + (N : ℂ) ^ (-ρ) / 2
        - ρ * ((ρ + 1) * I) := by
    linear_combination hz
  refine ⟨-(ρ * ((ρ + 1) * I)) * (N : ℂ) ^ ρ, ?_, ?_⟩
  · rw [norm_mul, norm_neg, norm_mul, norm_mul, norm_natCast_cpow hN]
    have hprod : (N : ℝ) ^ (-ρ.re - 1) * (N : ℝ) ^ ρ.re ≤ 1 := by
      rw [← Real.rpow_add hNpos, show -ρ.re - 1 + ρ.re = -1 by ring, Real.rpow_neg_one]
      exact inv_le_one_of_one_le₀ (by exact_mod_cast hN)
    have hb : ‖I‖ * (N : ℝ) ^ ρ.re ≤ 1 / 4 := by
      calc ‖I‖ * (N : ℝ) ^ ρ.re
          ≤ ((1 / 4) * (N : ℝ) ^ (-ρ.re - 1)) * (N : ℝ) ^ ρ.re :=
            mul_le_mul_of_nonneg_right hIn (Real.rpow_nonneg hNpos.le _)
        _ = (1 / 4) * ((N : ℝ) ^ (-ρ.re - 1) * (N : ℝ) ^ ρ.re) := by ring
        _ ≤ (1 / 4) * 1 := mul_le_mul_of_nonneg_left hprod (by norm_num)
        _ = 1 / 4 := by ring
    have hnn : 0 ≤ ‖ρ‖ * ‖ρ + 1‖ := mul_nonneg (norm_nonneg _) (norm_nonneg _)
    have := mul_le_mul_of_nonneg_left hb hnn
    calc ‖ρ‖ * (‖ρ + 1‖ * ‖I‖) * (N : ℝ) ^ ρ.re
        = ‖ρ‖ * ‖ρ + 1‖ * (‖I‖ * (N : ℝ) ^ ρ.re) := by ring
      _ ≤ ‖ρ‖ * ‖ρ + 1‖ * (1 / 4) := this
      _ = ‖ρ‖ * ‖ρ + 1‖ / 4 := by ring
  · rw [hsum, hS]
    linear_combination (1 / (1 - ρ)) * h1 + (1 / 2 : ℂ) * h2

/-- **A wobble is invisible to the integer count exactly at a zero.** Read at
`N/1, …, N/N` and added, with its smooth term taken off, a wobble `x^ρ` stays
bounded as `N` grows if and only if `ζ(ρ) = 0`. -/
theorem invisible_iff {ρ : ℂ} (hρ : 0 < ρ.re) (hρ1 : ρ ≠ 1) :
    (∃ C : ℝ, ∀ N : ℕ, 0 < N → ‖wobbleSum ρ N - (N : ℂ) / (1 - ρ)‖ ≤ C)
      ↔ riemannZeta ρ = 0 := by
  constructor
  · rintro ⟨C, hC⟩
    by_contra hz
    have hzpos : 0 < ‖riemannZeta ρ‖ := norm_pos_iff.mpr hz
    -- every N: ‖ζ ρ‖·N^(re ρ) ≤ C + 1/2 + K
    have hall : ∀ N : ℕ, 0 < N →
        ‖riemannZeta ρ‖ * (N : ℝ) ^ ρ.re ≤ C + 1 / 2 + ‖ρ‖ * ‖ρ + 1‖ / 4 := by
      intro N hN
      obtain ⟨E, hE, hW⟩ := wobbleSum_expansion hN hρ hρ1
      have e : riemannZeta ρ * (N : ℂ) ^ ρ
          = (wobbleSum ρ N - (N : ℂ) / (1 - ρ)) - (1 / 2 + E) := by
        rw [hW]
        ring
      have h12 : ‖(1 / 2 : ℂ) + E‖ ≤ 1 / 2 + ‖ρ‖ * ‖ρ + 1‖ / 4 := by
        refine le_trans (norm_add_le _ _) ?_
        have : ‖(1 / 2 : ℂ)‖ = 1 / 2 := by norm_num
        rw [this]
        linarith
      calc ‖riemannZeta ρ‖ * (N : ℝ) ^ ρ.re
          = ‖riemannZeta ρ * (N : ℂ) ^ ρ‖ := by rw [norm_mul, norm_natCast_cpow hN]
        _ = ‖(wobbleSum ρ N - (N : ℂ) / (1 - ρ)) - (1 / 2 + E)‖ := by rw [e]
        _ ≤ ‖wobbleSum ρ N - (N : ℂ) / (1 - ρ)‖ + ‖(1 / 2 : ℂ) + E‖ := norm_sub_le _ _
        _ ≤ C + (1 / 2 + ‖ρ‖ * ‖ρ + 1‖ / 4) := add_le_add (hC N hN) h12
        _ = C + 1 / 2 + ‖ρ‖ * ‖ρ + 1‖ / 4 := by ring
    -- a row far enough out breaks it
    obtain ⟨M, hM⟩ : ∃ M : ℝ, M = max ((C + 1 / 2 + ‖ρ‖ * ‖ρ + 1‖ / 4) / ‖riemannZeta ρ‖) 1 :=
      ⟨_, rfl⟩
    have hM1 : 1 ≤ M := by rw [hM]; exact le_max_right _ _
    have hM0 : 0 ≤ M := by linarith
    obtain ⟨N, hNgt⟩ := exists_nat_gt (M ^ (1 / ρ.re))
    have hroot0 : 0 ≤ M ^ (1 / ρ.re) := Real.rpow_nonneg hM0 _
    have hNpos : (0 : ℝ) < N := lt_of_le_of_lt hroot0 hNgt
    have hN : 0 < N := by exact_mod_cast hNpos
    have hbig : M < (N : ℝ) ^ ρ.re := by
      have h := Real.rpow_lt_rpow hroot0 hNgt hρ
      rwa [← Real.rpow_mul hM0, one_div_mul_cancel hρ.ne', Real.rpow_one] at h
    have hle : (C + 1 / 2 + ‖ρ‖ * ‖ρ + 1‖ / 4) / ‖riemannZeta ρ‖ ≤ M := by
      rw [hM]; exact le_max_left _ _
    have h1 := hall N hN
    have h2 : (C + 1 / 2 + ‖ρ‖ * ‖ρ + 1‖ / 4) < ‖riemannZeta ρ‖ * (N : ℝ) ^ ρ.re := by
      have h3 : (C + 1 / 2 + ‖ρ‖ * ‖ρ + 1‖ / 4) / ‖riemannZeta ρ‖ < (N : ℝ) ^ ρ.re :=
        lt_of_le_of_lt hle hbig
      rw [div_lt_iff₀ hzpos] at h3
      linarith [mul_comm ((N : ℝ) ^ ρ.re) ‖riemannZeta ρ‖]
    linarith
  · intro hz
    refine ⟨1 / 2 + ‖ρ‖ * ‖ρ + 1‖ / 4, fun N hN => ?_⟩
    obtain ⟨E, hE, hW⟩ := wobbleSum_expansion hN hρ hρ1
    have e : wobbleSum ρ N - (N : ℂ) / (1 - ρ) = 1 / 2 + E := by
      rw [hW, hz]
      ring
    rw [e]
    refine le_trans (norm_add_le _ _) ?_
    have : ‖(1 / 2 : ℂ)‖ = 1 / 2 := by norm_num
    rw [this]
    linarith

/-- info: 'WobbleCount.count_identity' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms count_identity

/-- info: 'WobbleCount.wobbleSum_expansion' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms wobbleSum_expansion

/-- info: 'WobbleCount.invisible_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms invisible_iff

end

end WobbleCount
