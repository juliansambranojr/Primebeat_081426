/-
# Stage3.Arith — S12 (`design/stencil.md` § S12), `SdiagLead.StmtArith` proved, and `StmtDiagMainO`. 2026-11-25.

The six arithmetic facts of `SdiagLead.StmtArith`, each pinned, and the corollary
`stmtDiagMainO_holds'`: `ζ(1+α+β) S(α,β,0) = c₁(α,β) + o(1)` (`DiagMainStmt.StmtDiagMainO`) for
`P(0) = 0`, `0 < θ < 1/2`, `0 < κ`, with no open hypothesis.

Routes (the tools are in `ArithBase`, the tails in `ArithTail`):

* `StmtSdmLe` (`ArithBase.sdmLe`): `Σ_{m ∈ ⟨d⟩} 1/m = Π_{p|d}(1 − 1/p)⁻¹ = σ(d)` (Mathlib's
  geometric Euler product over `factoredNumbers`), and a partial sum is below the sum.
* `StmtMeanSig3` (`meanSig3`): `μ²σ³ ≤ G`, `Σ_{d ≤ M} G(d)/d ≤ 2 CM (1 + log M)`.
* `StmtTailFixed`, `StmtTailAvg` (`ArithTail`): swap `d` and `m`; `Σ_m σ(m)²(1+log m)/(m rad m) < ∞`.
* `StmtGmuLog` (`gmuLog`): `μ²(k)/φ(k) = (μ²(k)/k)(S_k(M/k) + T_k(M/k))`. The first part sums to
  `Σ_{n ≤ M} 1/n` exactly, by `n ↦ (rad n, n/rad n)` (`sum_sdm_eq`); the second is in
  `[0, CM·KV]` (`StmtTailAvg` at `Y = 1`, `σ ≥ 1`). Then `log(M+1) ≤ Σ_{n≤M} 1/n ≤ 1 + log M`.
* `StmtDivLog` (`divLog`): `log a/a ≤ 2/√a`, `Σ_{a|d} 1/√a = Π_{p|d}(1 + 1/√p)`, so
  `μ²σ²(d) Σ_{a|d} log a/a ≤ 2 G(d)`.

Size check (the rule "a lost factor is a design failure"): every constant is a number
(`CM = exp(29 zs)`, `KV`), the only growing factors are the allowed `1 + log M`, `1 + log Y`,
and `η` enters only through `Z`. No factor growing with `M` is lost.

| name | content | status |
|---|---|---|
| `sdmLe` (`ArithBase`) | `StmtSdmLe` | proved |
| `meanSig3` | `StmtMeanSig3` | proved |
| `tailFixed` (`ArithTail`) | `StmtTailFixed` | proved |
| `tailAvg` (`ArithTail`) | `StmtTailAvg` | proved |
| `gmuLog` | `StmtGmuLog` | proved |
| `divLog` | `StmtDivLog` | proved |
| `sum_sdm_eq` | `Σ_{k ≤ M} (μ²(k)/k) S_k(M/k) = Σ_{n ≤ M} 1/n` | proved |
| `stmtArith_holds` | `StmtArith` | proved |
| `stmtDiagMainO_holds'` | `StmtDiagMainO P θ R κ`, unconditional | proved |

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Stage3.ArithTail
import Stage3.SdiagLead

namespace Arith

open Finset SdiagLead DiagMainStmt
open scoped ArithmeticFunction.Moebius

noncomputable section

/-! ## `StmtMeanSig3` -/

theorem sig3_le_G (b : ℕ) : ((μ b : ℤ) : ℝ) ^ 2 * sig b ^ 3 ≤ G b := by
  by_cases hb : Squarefree b
  · rw [musq_of_sq hb, one_mul, sig_eq_prod hb.ne_zero, ← prod_pow]
    exact prod_le_G hb fun p hp => ⟨pow_nonneg (sp_nonneg hp) 3, spk_le hp le_rfl⟩
  · rw [musq_of_not hb, zero_mul]; exact G_nonneg b

/-- **`StmtMeanSig3`**: `Σ_{d ≤ M} μ²σ³/d ≤ 2 CM (1 + log M)`. -/
theorem meanSig3 : StmtMeanSig3 := by
  refine ⟨2 * CM, by have := CM_pos; positivity, fun M => ?_⟩
  calc ∑ d ∈ Icc 1 M, ((μ d : ℤ) : ℝ) ^ 2 * sig d ^ 3 / d ≤ ∑ d ∈ Icc 1 M, G d / d :=
        sum_le_sum fun d _ => div_le_div_of_nonneg_right (sig3_le_G d) (Nat.cast_nonneg d)
    _ ≤ 2 * CM * (1 + Real.log M) := mean_G_all M

/-! ## `StmtDivLog` -/

/-- `a ↦ 1/√a`, multiplicative. -/
def rsAF : ArithmeticFunction ℝ := ⟨fun a => 1 / √(a : ℝ), by simp⟩

theorem rsAF_apply (a : ℕ) : rsAF a = 1 / √(a : ℝ) := rfl

theorem rs_mult : rsAF.IsMultiplicative := by
  refine ⟨by simp [rsAF_apply], fun {m n} _ => ?_⟩
  rw [rsAF_apply, rsAF_apply, rsAF_apply]
  push_cast
  rw [Real.sqrt_mul (Nat.cast_nonneg _), one_div_mul_one_div]

theorem log_div_le (a : ℕ) : Real.log a / a ≤ 2 * (1 / √(a : ℝ)) := by
  rcases Nat.eq_zero_or_pos a with h | h
  · subst h; simp
  have ha : (0 : ℝ) < a := by exact_mod_cast h
  have h1 := one_add_log_le ha
  rw [div_le_iff₀ ha]
  calc Real.log a ≤ 2 * √(a : ℝ) := by linarith
    _ = 2 * (1 / √(a : ℝ)) * a := by rw [mul_assoc, one_div_mul_eq_div, Real.div_sqrt]

theorem divlog_term_le (d : ℕ) :
    ((μ d : ℤ) : ℝ) ^ 2 * sig d ^ 2 / d * (∑ a ∈ d.divisors, Real.log a / a) ≤ 2 * (G d / d) := by
  by_cases hd : Squarefree d
  · rw [musq_of_sq hd, one_mul]
    have h1 : ∑ a ∈ d.divisors, Real.log a / a ≤ 2 * ∏ p ∈ d.primeFactors, (1 + qp p) := by
      calc _ ≤ ∑ a ∈ d.divisors, 2 * (1 / √(a : ℝ)) := sum_le_sum fun a _ => log_div_le a
        _ = 2 * ∑ a ∈ d.divisors, rsAF a := by rw [mul_sum]; rfl
        _ = 2 * ∏ p ∈ d.primeFactors, (1 + qp p) := by
          rw [← rs_mult.prodPrimeFactors_one_add_of_squarefree hd]; rfl
    have h2 : sig d ^ 2 * ∏ p ∈ d.primeFactors, (1 + qp p) ≤ G d := by
      rw [sig_eq_prod hd.ne_zero, ← prod_pow, ← prod_mul_distrib]
      refine prod_le_G hd fun p hp => ?_
      obtain ⟨hs1, -, -⟩ := sp_bounds hp.two_le
      obtain ⟨hq0, -, -⟩ := qp_bounds hp.two_le
      have h23 : sp p ^ 2 ≤ sp p ^ 3 := pow_le_pow_right₀ hs1 (by norm_num)
      have hm := mul_le_mul_of_nonneg_right h23 (show (0 : ℝ) ≤ 1 + qp p by linarith)
      refine ⟨mul_nonneg (pow_nonneg (by linarith) 2) (by linarith), ?_⟩
      unfold xg; linarith
    have hsd : 0 ≤ sig d ^ 2 / d := div_nonneg (sq_nonneg _) (Nat.cast_nonneg d)
    calc sig d ^ 2 / d * ∑ a ∈ d.divisors, Real.log a / a
        ≤ sig d ^ 2 / d * (2 * ∏ p ∈ d.primeFactors, (1 + qp p)) :=
          mul_le_mul_of_nonneg_left h1 hsd
      _ = 2 * ((sig d ^ 2 * ∏ p ∈ d.primeFactors, (1 + qp p)) / d) := by ring
      _ ≤ 2 * (G d / d) := mul_le_mul_of_nonneg_left
          (div_le_div_of_nonneg_right h2 (Nat.cast_nonneg d)) (by norm_num)
  · rw [musq_of_not hd, zero_mul, zero_div, zero_mul]
    exact mul_nonneg (by norm_num) (div_nonneg (G_nonneg d) (Nat.cast_nonneg d))

/-- **`StmtDivLog`**: `Σ_{d ≤ M} μ²σ²/d · Σ_{a|d} log a/a ≤ 4 CM (1 + log M)`. -/
theorem divLog : StmtDivLog := by
  refine ⟨4 * CM, by have := CM_pos; positivity, fun M => ?_⟩
  calc _ ≤ ∑ d ∈ Icc 1 M, 2 * (G d / d) := sum_le_sum fun d _ => divlog_term_le d
    _ = 2 * ∑ d ∈ Icc 1 M, G d / d := by rw [mul_sum]
    _ ≤ 2 * (2 * CM * (1 + Real.log M)) := mul_le_mul_of_nonneg_left (mean_G_all M) (by norm_num)
    _ = 4 * CM * (1 + Real.log M) := by ring

/-! ## `StmtGmuLog` -/

theorem f_ne {k m : ℕ} (h : ((μ k : ℤ) : ℝ) ^ 2 / k * (((chiAF k m : ℤ) : ℝ) / m) ≠ 0) :
    Squarefree k ∧ m ≠ 0 ∧ m.primeFactors ⊆ k.primeFactors := by
  by_cases hk : Squarefree k
  · rw [chiAF_apply] at h
    by_cases hc : m ≠ 0 ∧ m.primeFactors ⊆ k.primeFactors
    · exact ⟨hk, hc⟩
    · rw [if_neg hc] at h; simp at h
  · rw [musq_of_not hk] at h; simp at h

theorem f_val {k m : ℕ} (hk : Squarefree k) (hm : m ≠ 0) (hc : m.primeFactors ⊆ k.primeFactors) :
    ((μ k : ℤ) : ℝ) ^ 2 / k * (((chiAF k m : ℤ) : ℝ) / m) = 1 / ((k * m : ℕ) : ℝ) := by
  rw [musq_of_sq hk, chiAF_apply, if_pos ⟨hm, hc⟩]; push_cast; ring

theorem rad_mul_of {k m : ℕ} (hk : Squarefree k) (hm : m ≠ 0)
    (hc : m.primeFactors ⊆ k.primeFactors) : rad' (k * m) = k := by
  unfold rad'
  rw [Nat.primeFactors_mul hk.ne_zero hm, Finset.union_eq_left.mpr hc,
    Nat.prod_primeFactors_of_squarefree hk]

/-- **The bijection** `n ↦ (rad n, n/rad n)`: `Σ_{k ≤ M} (μ²(k)/k) S_k(M/k) = Σ_{n ≤ M} 1/n`. -/
theorem sum_sdm_eq (M : ℕ) :
    ∑ k ∈ Icc 1 M, ((μ k : ℤ) : ℝ) ^ 2 / k * Sdm k (M / k) = ∑ n ∈ Icc 1 M, (1 : ℝ) / n := by
  unfold Sdm
  simp_rw [mul_sum]
  rw [sum_sigma']
  refine sum_bij_ne_zero (fun x _ _ => x.1 * x.2) ?_ ?_ ?_ ?_
  · rintro ⟨k, m⟩ hx -
    simp only [mem_sigma, mem_Icc, mem_Ioc] at hx ⊢
    obtain ⟨⟨hk1, -⟩, hm0, hmk⟩ := hx
    have := (Nat.le_div_iff_mul_le (by omega)).mp hmk
    exact ⟨Nat.mul_pos (by omega) hm0, by rw [mul_comm]; exact this⟩
  · rintro ⟨k1, m1⟩ - h1 ⟨k2, m2⟩ - h2 heq
    obtain ⟨hk1, hm1, hc1⟩ := f_ne (k := k1) (m := m1) h1
    obtain ⟨hk2, hm2, hc2⟩ := f_ne (k := k2) (m := m2) h2
    simp only at heq
    have hk : k1 = k2 := by
      rw [← rad_mul_of hk1 hm1 hc1, ← rad_mul_of hk2 hm2 hc2, heq]
    subst hk
    have hm : m1 = m2 := Nat.eq_of_mul_eq_mul_left (Nat.pos_of_ne_zero hk1.ne_zero) heq
    subst hm
    rfl
  · intro n hn _
    simp only [mem_Icc] at hn
    have hn0 : n ≠ 0 := by omega
    have hr := rad_pos n
    have hdvd := rad_dvd n
    have hrn : rad' n ≤ n := Nat.le_of_dvd (by omega) hdvd
    have hq0 : n / rad' n ≠ 0 := (Nat.div_pos hrn hr).ne'
    have hpf : (n / rad' n).primeFactors ⊆ (rad' n).primeFactors := by
      rw [rad_pf]; exact Nat.primeFactors_mono (Nat.div_dvd_of_dvd hdvd) hn0
    have hval := f_val (rad_squarefree n) hq0 hpf
    rw [Nat.mul_div_cancel' hdvd] at hval
    refine ⟨⟨rad' n, n / rad' n⟩, ?_, ?_, ?_⟩
    · simp only [mem_sigma, mem_Icc, mem_Ioc]
      exact ⟨⟨hr, le_trans hrn hn.2⟩, Nat.pos_of_ne_zero hq0, Nat.div_le_div_right hn.2⟩
    · simp only
      rw [hval]
      have : (0 : ℝ) < n := by exact_mod_cast (show 0 < n by omega)
      positivity
    · exact Nat.mul_div_cancel' hdvd
  · rintro ⟨k, m⟩ - h
    obtain ⟨hk, hm, hc⟩ := f_ne (k := k) (m := m) h
    exact f_val hk hm hc

theorem gmu_eq {k : ℕ} (hk : k ≠ 0) (X : ℕ) :
    gmu k = ((μ k : ℤ) : ℝ) ^ 2 / k * Sdm k X + ((μ k : ℤ) : ℝ) ^ 2 / k * Tl k X := by
  rw [← mul_add, show Sdm k X + Tl k X = sig k by unfold Tl; ring]
  unfold gmu sig
  have hk' : (k : ℝ) ≠ 0 := by exact_mod_cast hk
  have hφ : (Nat.totient k : ℝ) ≠ 0 := by exact_mod_cast (Nat.totient_pos.mpr (Nat.pos_of_ne_zero hk)).ne'
  field_simp

/-- **`StmtGmuLog`**: `|Σ_{k ≤ t} μ²(k)/φ(k) − log t| ≤ 1 + CM·KV`. -/
theorem gmuLog : StmtGmuLog := by
  obtain ⟨Ca, hCa0, hCa⟩ := tailAvg
  refine ⟨1 + Ca, by linarith, fun t ht => ?_⟩
  obtain ⟨M, hM⟩ : ∃ M, M = ⌊t⌋₊ := ⟨_, rfl⟩
  rw [← hM]
  have hM1 : 1 ≤ M := by rw [hM]; exact Nat.le_floor (by exact_mod_cast ht)
  have hMt : (M : ℝ) ≤ t := by rw [hM]; exact Nat.floor_le (by linarith)
  have htM : t < (M : ℝ) + 1 := by rw [hM]; exact Nat.lt_floor_add_one t
  have e0 : ∑ k ∈ Icc 0 M, gmu k = ∑ k ∈ Icc 1 M, gmu k := by
    refine (sum_subset (fun k hk => by simp only [mem_Icc] at hk ⊢; omega) fun k hk hk' => ?_).symm
    have : k = 0 := by simp only [mem_Icc] at hk hk'; omega
    subst this; simp [gmu]
  have e1 : ∑ k ∈ Icc 1 M, gmu k = ∑ n ∈ Icc 1 M, (1 : ℝ) / n +
      ∑ k ∈ Icc 1 M, ((μ k : ℤ) : ℝ) ^ 2 / k * Tl k (M / k) := by
    rw [← sum_sdm_eq, ← sum_add_distrib]
    exact sum_congr rfl fun k hk => gmu_eq (by simp only [mem_Icc] at hk; omega) _
  have hT0 : 0 ≤ ∑ k ∈ Icc 1 M, ((μ k : ℤ) : ℝ) ^ 2 / k * Tl k (M / k) :=
    sum_nonneg fun k hk => mul_nonneg (div_nonneg (musq_nonneg k) (Nat.cast_nonneg k))
      (Tl_nonneg sdmLe (by simp only [mem_Icc] at hk; omega) _)
  have hT1 : ∑ k ∈ Icc 1 M, ((μ k : ℤ) : ℝ) ^ 2 / k * Tl k (M / k) ≤ Ca := by
    have h := hCa M 1 le_rfl
    simp only [Nat.div_one, Nat.cast_one, Real.log_one, add_zero, mul_one] at h
    refine le_trans (sum_le_sum fun k hk => ?_) h
    have hk : k ≠ 0 := by simp only [mem_Icc] at hk; omega
    have hs := sig_ge_one hk
    have hTk := Tl_nonneg sdmLe (Nat.pos_of_ne_zero hk) (M / k)
    have hmk : 0 ≤ ((μ k : ℤ) : ℝ) ^ 2 / k := div_nonneg (musq_nonneg k) (Nat.cast_nonneg k)
    have e : ((μ k : ℤ) : ℝ) ^ 2 * sig k ^ 2 * Tl k (M / k) / k
        = ((μ k : ℤ) : ℝ) ^ 2 / k * Tl k (M / k) * sig k ^ 2 := by ring
    rw [e]
    have hs2 : 1 ≤ sig k ^ 2 := one_le_pow₀ hs
    nlinarith [mul_nonneg hmk hTk]
  have hH1 := sum_inv_Icc_le M
  have hH2 := log_le_sum_inv_Icc M
  have ht0 : 0 < t := by linarith
  have hl1 : Real.log M ≤ Real.log t :=
    Real.log_le_log (by exact_mod_cast hM1) hMt
  have hl2 : Real.log t ≤ Real.log ((M : ℝ) + 1) := Real.log_le_log ht0 htM.le
  rw [e0, e1, abs_le]
  constructor <;> linarith

/-! ## `StmtArith` and the main term -/

/-- **`StmtArith`**, the six arithmetic facts. -/
theorem stmtArith_holds : StmtArith :=
  ⟨sdmLe, meanSig3, tailFixed, tailAvg, gmuLog, divLog⟩

/-- **The main term, little-o, unconditional**: `ζ(1+α+β) S(α,β,0) = c₁(α,β) + o(1)`. -/
theorem stmtDiagMainO_holds' (P : Polynomial ℝ) (hP0 : P.eval 0 = 0) {θ : ℝ} (hθ0 : 0 < θ)
    (hθ : θ < 1 / 2) (R : ℝ) {κ : ℝ} (hκ : 0 < κ) : StmtDiagMainO P θ R κ :=
  stmtDiagMainO_holds P hP0 hθ0 hθ R hκ stmtArith_holds

end

/-- info: 'Arith.meanSig3' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms meanSig3

/-- info: 'Arith.divLog' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms divLog

/-- info: 'Arith.gmuLog' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms gmuLog

/-- info: 'Arith.sum_sdm_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms sum_sdm_eq

/-- info: 'Arith.stmtArith_holds' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms stmtArith_holds

/-- info: 'Arith.stmtDiagMainO_holds'' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms stmtDiagMainO_holds'

end Arith
