/-
# Stage3.ArithTail — S12 (`design/stencil.md` § S12), the two tails `StmtTailFixed`, `StmtTailAvg`. 2026-11-25.

`T_d(X) = σ(d) − S_d(X) = Σ_{m ∈ ⟨d⟩, m > X} 1/m` (`hasSum_tail`, from `ArithBase.hasSum_chi`).
Route: swap the `d`-sum and the `m`-sum. For fixed `m ≥ 1`, with `r = rad m = Π_{p|m} p`, a
squarefree `d` with `m ∈ ⟨d⟩` is `d = r b`, `(r, b) = 1`, `σ(d) = σ(m) σ(b)`, so
`Σ_{d ≤ M, m ∈ ⟨d⟩, M < dK} μ²σ²(d)/d ≤ (σ(m)²/r) Σ_{N/K < b ≤ N} G(b)/b ≤ (σ(m)²/r) CM (1 + log K)`
with `N = M/r` (`inner_le`, from `ArithBase.mean_G`). Then

* `StmtTailAvg`, `X_d = M/d/Y`: `m > X_d` is `M < d (mY)`, so `K = mY` and the `m`-sum is
  `CM (1 + log Y) Σ_m σ(m)²(1 + log m)/(m rad m) = CM (1 + log Y) KV`;
* `StmtTailFixed`, `X_d = Z`: `K = M + 1` and `1_{m > Z} ≤ (1 + log m)/(1 + log Z)`, so the sum is
  `≤ 2 CM KV (1 + log M)/(1 + log Z) ≤ η (1 + log M)` once `log Z ≥ 2 CM KV/η`.

`KV = Σ_m V(m)`, `V(m) = σ(m)²(1 + log m)/(m rad m) ≤ 2 fV(m)`, `fV(m) = σ(m)² √m/(m rad m)`,
multiplicative with `Σ_k fV(p^k) = 1 + (σ(p)²/p)·q/(1 − q)`, `q = 1/√p`, `≤ 1 + 16/(p√p)`
(`ArithBase.euler_le`): `KV ≤ 2 exp(16 zs)`.

Size check. The constants `CM`, `KV` are numbers. TailAvg pays `1 + log(mY) ≤ (1 + log m)(1 + log Y)`:
the `log m` is absorbed by `Σ_m V(m) < ∞` and the `log Y` is the allowed factor. TailFixed pays
`1 + log(M + 1) ≤ 2(1 + log M)`, the allowed factor. No factor growing with `M` or `Y` is lost.

| name | content | status |
|---|---|---|
| `rad'`, `fV`, `V`, `KV`, `tailF` | `Π_{p|m} p`, `σ²√m/(m rad m)`, `σ²(1+log m)/(m rad m)`, `Σ V`, the tail summand | def |
| `summable_fV`, `summable_V` | `Σ fV, Σ V < ∞` | proved |
| `hasSum_tail` | `Σ_m tailF d X m = T_d(X)` | proved |
| `inner_le` | the inner `d`-sum at fixed `m` | proved |
| `tailAvg` | `StmtTailAvg` | proved |
| `tailFixed` | `StmtTailFixed` | proved |

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Stage3.ArithBase

namespace Arith

open Finset SdiagLead
open scoped ArithmeticFunction.Moebius

noncomputable section

/-! ## The radical -/

/-- `rad m = Π_{p | m} p`. -/
def rad' (m : ℕ) : ℕ := ∏ p ∈ m.primeFactors, p

theorem rad_pos (m : ℕ) : 0 < rad' m :=
  prod_pos fun _ hp => (Nat.prime_of_mem_primeFactors hp).pos

theorem rad_pf (m : ℕ) : (rad' m).primeFactors = m.primeFactors :=
  Nat.primeFactors_prod_primeFactors m

theorem rad_mul {m n : ℕ} (h : m.Coprime n) : rad' (m * n) = rad' m * rad' n := by
  unfold rad'; rw [h.primeFactors_mul, prod_union h.disjoint_primeFactors]

theorem rad_prime_pow {p k : ℕ} (hp : p.Prime) (hk : k ≠ 0) : rad' (p ^ k) = p := by
  unfold rad'; rw [Nat.primeFactors_prime_pow hk hp, prod_singleton]

theorem rad_dvd (m : ℕ) : rad' m ∣ m := Nat.prod_primeFactors_dvd m

theorem rad_squarefree (n : ℕ) : Squarefree (rad' n) := by
  unfold rad'
  refine Finset.squarefree_prod_of_pairwise_isCoprime (fun p hp q hq hpq => ?_)
    fun p hp => (Nat.prime_of_mem_primeFactors hp).squarefree
  simp only [← Nat.coprime_iff_isRelPrime]
  exact (Nat.coprime_primes (Nat.prime_of_mem_primeFactors hp)
    (Nat.prime_of_mem_primeFactors hq)).mpr hpq

theorem sig_prime_pow {p k : ℕ} (hp : p.Prime) (hk : k ≠ 0) : sig (p ^ k) = sp p := by
  rw [sig_eq_prod (pow_ne_zero _ hp.ne_zero), Nat.primeFactors_prime_pow hk hp, prod_singleton]

theorem spk_le {p : ℕ} (hp : p.Prime) {k : ℕ} (hk : k ≤ 3) : sp p ^ k ≤ 1 + xg p := by
  obtain ⟨hs1, -, -⟩ := sp_bounds hp.two_le
  obtain ⟨hq0, -, -⟩ := qp_bounds hp.two_le
  unfold xg
  have h1 : sp p ^ k ≤ sp p ^ 3 := pow_le_pow_right₀ hs1 hk
  have h3 : 0 ≤ sp p ^ 3 := pow_nonneg (by linarith) 3
  nlinarith

theorem sp_nonneg {p : ℕ} (hp : p.Prime) : 0 ≤ sp p := by
  linarith [(sp_bounds hp.two_le).1]

/-- `μ²(b) σ(b)² ≤ G(b)`. -/
theorem sig2_le_G (b : ℕ) : ((μ b : ℤ) : ℝ) ^ 2 * sig b ^ 2 ≤ G b := by
  by_cases hb : Squarefree b
  · rw [musq_of_sq hb, one_mul, sig_eq_prod hb.ne_zero, ← prod_pow]
    exact prod_le_G hb fun p hp => ⟨pow_nonneg (sp_nonneg hp) 2, spk_le hp (by norm_num)⟩
  · rw [musq_of_not hb, zero_mul]; exact G_nonneg b

/-! ## `Σ_m σ(m)²(1 + log m)/(m rad m) < ∞` -/

/-- `fV(m) = σ(m)² √m/(m rad m)`. -/
def fV (m : ℕ) : ℝ := sig m ^ 2 * √(m : ℝ) / ((m : ℝ) * rad' m)

/-- `V(m) = σ(m)² (1 + log m)/(m rad m)`. -/
def V (m : ℕ) : ℝ := sig m ^ 2 * (1 + Real.log m) / ((m : ℝ) * rad' m)

/-- `KV = Σ_m V(m)`. -/
def KV : ℝ := ∑' m : ℕ, V m

/-- `CV = exp(16 zs)`. -/
def CV : ℝ := Real.exp (16 * zs)

theorem fV_nonneg (m : ℕ) : 0 ≤ fV m := by
  unfold fV; have := sig_nonneg m; positivity

theorem fV_mul {m n : ℕ} (h : m.Coprime n) : fV (m * n) = fV m * fV n := by
  unfold fV
  rw [sig_mul h, rad_mul h]
  push_cast
  rw [Real.sqrt_mul (Nat.cast_nonneg _)]
  ring

theorem fV_one : fV 1 = 1 := by simp [fV, sig, rad']

theorem fV_prime_pow {p k : ℕ} (hp : p.Prime) (hk : k ≠ 0) :
    fV (p ^ k) = sp p ^ 2 / p * qp p ^ k := by
  have hp0 : (0 : ℝ) < p := by exact_mod_cast hp.pos
  have ht : 0 < √(p : ℝ) := Real.sqrt_pos.mpr hp0
  have hpt : (p : ℝ) = √(p : ℝ) ^ 2 := (Real.sq_sqrt hp0.le).symm
  unfold fV qp
  rw [sig_prime_pow hp hk, rad_prime_pow hp hk]
  push_cast
  have hsq : √((p : ℝ) ^ k) = √(p : ℝ) ^ k := by
    rw [show (p : ℝ) ^ k = (√(p : ℝ) ^ k) ^ 2 by rw [← pow_mul, mul_comm, pow_mul, ← hpt]]
    exact Real.sqrt_sq (pow_nonneg ht.le k)
  rw [hsq, show (p : ℝ) ^ k = (√(p : ℝ) ^ k) ^ 2 by rw [← pow_mul, mul_comm, pow_mul, ← hpt]]
  have htk : 0 < √(p : ℝ) ^ k := pow_pos ht k
  field_simp
  rw [mul_assoc, ← mul_pow, mul_one_div_cancel ht.ne', one_pow, mul_one]

theorem fV_hasSum {p : ℕ} (hp : p.Prime) :
    HasSum (fun k => fV (p ^ k)) (1 + sp p ^ 2 / p * (qp p / (1 - qp p))) := by
  obtain ⟨hq0, hq1, -⟩ := qp_bounds hp.two_le
  have hne : 1 - qp p ≠ 0 := by linarith
  have hg := (hasSum_geometric_of_lt_one hq0.le (by linarith)).mul_left (sp p ^ 2 / p)
  have hi := hasSum_ite_eq (0 : ℕ) (1 - sp p ^ 2 / p)
  have hsum := hi.add hg
  have hval : (1 - sp p ^ 2 / p) + sp p ^ 2 / p * (1 - qp p)⁻¹
      = 1 + sp p ^ 2 / p * (qp p / (1 - qp p)) := by field_simp; ring
  rw [hval] at hsum
  have hfun : (fun k => fV (p ^ k))
      = fun k => (if k = 0 then 1 - sp p ^ 2 / p else 0) + sp p ^ 2 / p * qp p ^ k := by
    funext k
    rcases Nat.eq_zero_or_pos k with h | h
    · subst h; rw [pow_zero, fV_one, if_pos rfl, pow_zero]; ring
    · rw [fV_prime_pow hp (by omega), if_neg (by omega), zero_add]
  rw [hfun]; exact hsum

theorem fV_e_le {p : ℕ} (hp : p.Prime) :
    sp p ^ 2 / p * (qp p / (1 - qp p)) ≤ 16 / ((p : ℝ) * √(p : ℝ)) := by
  obtain ⟨hs1, hs2, -⟩ := sp_bounds hp.two_le
  obtain ⟨hq0, hq1, -⟩ := qp_bounds hp.two_le
  have hp0 : (0 : ℝ) < p := by exact_mod_cast hp.pos
  have ht : 0 < √(p : ℝ) := Real.sqrt_pos.mpr hp0
  have hA4 : sp p ^ 2 / p ≤ 4 / p := div_le_div_of_nonneg_right (by nlinarith) hp0.le
  have hqq : qp p / (1 - qp p) ≤ 4 * qp p := by
    rw [div_le_iff₀ (by linarith)]; nlinarith
  calc sp p ^ 2 / p * (qp p / (1 - qp p)) ≤ 4 / p * (4 * qp p) :=
        mul_le_mul hA4 hqq (div_nonneg hq0.le (by linarith)) (by positivity)
    _ = 16 / ((p : ℝ) * √(p : ℝ)) := by unfold qp; field_simp; ring

theorem fV_e_nonneg {p : ℕ} (hp : p.Prime) : 0 ≤ sp p ^ 2 / p * (qp p / (1 - qp p)) := by
  obtain ⟨hq0, hq1, -⟩ := qp_bounds hp.two_le
  exact mul_nonneg (div_nonneg (sq_nonneg _) (Nat.cast_nonneg p)) (div_nonneg hq0.le (by linarith))

theorem sum_fV_le (N : ℕ) : ∑ m ∈ range N, fV m ≤ CV :=
  (euler_le fV_nonneg (by simp [fV]) fV_one fV_mul
    (fun p hp => ⟨fV_e_nonneg hp, fV_hasSum hp⟩) N).trans
    (Real.exp_le_exp.mpr (sum_primes_le_zs (by norm_num) (fun p hp => fV_e_le hp) N))

theorem summable_fV : Summable fV := summable_of_sum_range_le fV_nonneg sum_fV_le

theorem one_add_log_le {x : ℝ} (hx : 0 < x) : 1 + Real.log x ≤ 2 * √x := by
  have hs : 0 < √x := Real.sqrt_pos.mpr hx
  have h1 := Real.log_le_sub_one_of_pos hs
  rw [Real.log_sqrt hx.le] at h1
  linarith

theorem V_nonneg (m : ℕ) : 0 ≤ V m := by
  unfold V
  have := log_nat_nonneg m
  exact div_nonneg (mul_nonneg (sq_nonneg _) (by linarith)) (by positivity)

theorem V_le (m : ℕ) : V m ≤ 2 * fV m := by
  rcases Nat.eq_zero_or_pos m with h | h
  · subst h; simp [V, fV]
  · have hm : (0 : ℝ) < m := by exact_mod_cast h
    have e1 : V m = sig m ^ 2 / ((m : ℝ) * rad' m) * (1 + Real.log m) := by unfold V; ring
    have e2 : 2 * fV m = sig m ^ 2 / ((m : ℝ) * rad' m) * (2 * √(m : ℝ)) := by unfold fV; ring
    rw [e1, e2]
    exact mul_le_mul_of_nonneg_left (one_add_log_le hm) (by positivity)

theorem summable_V : Summable V :=
  Summable.of_nonneg_of_le V_nonneg V_le (summable_fV.mul_left 2)

theorem KV_nonneg : 0 ≤ KV := tsum_nonneg V_nonneg

/-! ## The tail as a sum -/

/-- `1_{m > X} 1_{⟨d⟩}(m)/m`. -/
def tailF (d X m : ℕ) : ℝ := if m ≤ X then 0 else ((chiAF d m : ℤ) : ℝ) / m

theorem hasSum_tail {d : ℕ} (hd : d ≠ 0) (X : ℕ) : HasSum (tailF d X) (Tl d X) := by
  have h1 := hasSum_chi hd
  have h0 : ∀ m ∉ Ioc 0 X, (if m ≤ X then ((chiAF d m : ℤ) : ℝ) / m else 0) = 0 := by
    intro m hm
    simp only [mem_Ioc, not_and_or, not_lt, not_le] at hm
    rcases hm with hm | hm
    · have : m = 0 := by omega
      subst this; simp
    · rw [if_neg (by omega)]
  have h2 : HasSum (fun m => if m ≤ X then ((chiAF d m : ℤ) : ℝ) / m else 0)
      (∑ m ∈ Ioc 0 X, (if m ≤ X then ((chiAF d m : ℤ) : ℝ) / m else 0)) :=
    hasSum_sum_of_ne_finset_zero h0
  have e2 : ∑ m ∈ Ioc 0 X, (if m ≤ X then ((chiAF d m : ℤ) : ℝ) / m else 0) = Sdm d X := by
    unfold Sdm
    exact sum_congr rfl fun m hm => if_pos (mem_Ioc.mp hm).2
  rw [e2] at h2
  have h3 := h1.sub h2
  have hfun : (fun m => ((chiAF d m : ℤ) : ℝ) / m
      - (if m ≤ X then ((chiAF d m : ℤ) : ℝ) / m else 0)) = tailF d X := by
    funext m
    unfold tailF
    by_cases hm : m ≤ X
    · rw [if_pos hm, if_pos hm, sub_self]
    · rw [if_neg hm, if_neg hm, sub_zero]
  rw [hfun] at h3
  exact h3

theorem tailF_le {d X m : ℕ} (hm : m ≠ 0) (P : Prop) [Decidable P] (hP : X < m → P) :
    tailF d X m ≤ (if P ∧ m.primeFactors ⊆ d.primeFactors then (1 : ℝ) else 0) / m := by
  unfold tailF
  by_cases hX : m ≤ X
  · rw [if_pos hX]
    apply div_nonneg _ (Nat.cast_nonneg _)
    split_ifs <;> norm_num
  · rw [if_neg hX, chiAF_apply]
    by_cases hc : m.primeFactors ⊆ d.primeFactors
    · rw [if_pos ⟨hm, hc⟩, if_pos ⟨hP (by omega), hc⟩]; simp
    · rw [if_neg (fun h => hc h.2), if_neg (fun h => hc h.2)]; simp

theorem tailF_zero (d X : ℕ) : tailF d X 0 = 0 := by simp [tailF]

/-! ## The inner sum at fixed `m` -/

/-- The bound at `b`: `(σ(m)²/rad m) G(b)/b`. -/
def phiB (m b : ℕ) : ℝ := sig m ^ 2 / rad' m * (G b / b)

theorem phiB_nonneg (m b : ℕ) : 0 ≤ phiB m b :=
  mul_nonneg (div_nonneg (sq_nonneg _) (Nat.cast_nonneg _))
    (div_nonneg (G_nonneg b) (Nat.cast_nonneg b))

/-- **The inner sum**: `Σ_{d ≤ M, M < dK, m ∈ ⟨d⟩} μ²σ²(d)/d ≤ (σ(m)²/rad m) CM (1 + log K)`. -/
theorem inner_le {m : ℕ} (hm : m ≠ 0) (M K : ℕ) (hK : 1 ≤ K) :
    ∑ d ∈ Icc 1 M, ((μ d : ℤ) : ℝ) ^ 2 * sig d ^ 2 / d *
        (if M < d * K ∧ m.primeFactors ⊆ d.primeFactors then (1 : ℝ) else 0)
      ≤ sig m ^ 2 / rad' m * (CM * (1 + Real.log K)) := by
  have hr0 : 0 < rad' m := rad_pos m
  have step1 : ∀ d ∈ Icc 1 M, ((μ d : ℤ) : ℝ) ^ 2 * sig d ^ 2 / d *
      (if M < d * K ∧ m.primeFactors ⊆ d.primeFactors then (1 : ℝ) else 0)
      ≤ if (Squarefree d ∧ M < d * K ∧ m.primeFactors ⊆ d.primeFactors)
          then phiB m (d / rad' m) else 0 := by
    intro d hd
    have hd0 : d ≠ 0 := by simp only [mem_Icc] at hd; omega
    by_cases hsq : Squarefree d
    · by_cases hc : M < d * K ∧ m.primeFactors ⊆ d.primeFactors
      · rw [if_pos hc, if_pos ⟨hsq, hc⟩, musq_of_sq hsq, one_mul, mul_one]
        have hdvd : rad' m ∣ d := (Nat.prod_primeFactors_dvd_iff hd0).mpr hc.2
        obtain ⟨b, hb⟩ := hdvd
        have hdb : d / rad' m = b := by rw [hb]; exact Nat.mul_div_cancel_left b hr0
        rw [hdb]
        have hsq' : Squarefree (rad' m * b) := by rw [← hb]; exact hsq
        have hcop : (rad' m).Coprime b := Nat.coprime_of_squarefree_mul hsq'
        have hsig : sig d = sig m * sig b := by
          rw [hb, sig_mul hcop, sig_pf hr0.ne' hm (rad_pf m)]
        have hGb : sig b ^ 2 ≤ G b := by
          have := sig2_le_G b
          rwa [musq_of_sq hsq'.of_mul_right, one_mul] at this
        unfold phiB
        rw [hsig, hb]
        push_cast
        calc (sig m * sig b) ^ 2 / ((rad' m : ℝ) * b) = sig m ^ 2 / rad' m * (sig b ^ 2 / b) := by
              ring
          _ ≤ _ := mul_le_mul_of_nonneg_left (div_le_div_of_nonneg_right hGb (Nat.cast_nonneg b))
              (div_nonneg (sq_nonneg _) (Nat.cast_nonneg _))
      · rw [if_neg hc, mul_zero, if_neg (fun h => hc h.2)]
    · rw [musq_of_not hsq]; simp [hsq]
  have hinj : ∀ x ∈ (Icc 1 M).filter
        (fun d => Squarefree d ∧ M < d * K ∧ m.primeFactors ⊆ d.primeFactors),
      ∀ y ∈ (Icc 1 M).filter
        (fun d => Squarefree d ∧ M < d * K ∧ m.primeFactors ⊆ d.primeFactors),
      x / rad' m = y / rad' m → x = y := by
    intro x hx y hy hxy
    simp only [mem_filter, mem_Icc] at hx hy
    have hxd : rad' m ∣ x := (Nat.prod_primeFactors_dvd_iff (by omega)).mpr hx.2.2.2
    have hyd : rad' m ∣ y := (Nat.prod_primeFactors_dvd_iff (by omega)).mpr hy.2.2.2
    rw [← Nat.mul_div_cancel' hxd, ← Nat.mul_div_cancel' hyd, hxy]
  have hsub : ((Icc 1 M).filter
        (fun d => Squarefree d ∧ M < d * K ∧ m.primeFactors ⊆ d.primeFactors)).image
        (· / rad' m) ⊆ (Icc 1 (M / rad' m)).filter (fun b => M / rad' m < b * K) := by
    intro b hb
    simp only [mem_image, mem_filter, mem_Icc] at hb ⊢
    obtain ⟨d, ⟨⟨hd1, hdM⟩, -, hdK, hpf⟩, rfl⟩ := hb
    have hdvd : rad' m ∣ d := (Nat.prod_primeFactors_dvd_iff (by omega)).mpr hpf
    refine ⟨⟨Nat.div_pos (Nat.le_of_dvd (by omega) hdvd) hr0, Nat.div_le_div_right hdM⟩, ?_⟩
    refine (Nat.div_lt_iff_lt_mul hr0).mpr ?_
    calc M < d * K := hdK
      _ = d / rad' m * rad' m * K := by rw [Nat.div_mul_cancel hdvd]
      _ = d / rad' m * K * rad' m := by ring
  calc _ ≤ ∑ d ∈ Icc 1 M, (if (Squarefree d ∧ M < d * K ∧ m.primeFactors ⊆ d.primeFactors)
          then phiB m (d / rad' m) else 0) := sum_le_sum step1
    _ = ∑ d ∈ (Icc 1 M).filter
          (fun d => Squarefree d ∧ M < d * K ∧ m.primeFactors ⊆ d.primeFactors),
          phiB m (d / rad' m) := (sum_filter _ _).symm
    _ = ∑ b ∈ ((Icc 1 M).filter
          (fun d => Squarefree d ∧ M < d * K ∧ m.primeFactors ⊆ d.primeFactors)).image
          (· / rad' m), phiB m b := (sum_image hinj).symm
    _ ≤ ∑ b ∈ (Icc 1 (M / rad' m)).filter (fun b => M / rad' m < b * K), phiB m b :=
        sum_le_sum_of_subset_of_nonneg hsub fun b _ _ => phiB_nonneg m b
    _ = sig m ^ 2 / rad' m *
          ∑ b ∈ (Icc 1 (M / rad' m)).filter (fun b => M / rad' m < b * K), G b / b := by
        unfold phiB; rw [mul_sum]
    _ ≤ _ := mul_le_mul_of_nonneg_left (mean_G _ K hK)
        (div_nonneg (sq_nonneg _) (Nat.cast_nonneg _))

/-- The weight `μ²σ²/d` is nonnegative. -/
theorem w_nonneg (d : ℕ) : 0 ≤ ((μ d : ℤ) : ℝ) ^ 2 * sig d ^ 2 / d :=
  div_nonneg (mul_nonneg (musq_nonneg d) (sq_nonneg _)) (Nat.cast_nonneg d)

/-- The `d`-sum of the tails as a sum over `m`. -/
theorem hasSum_tails (M : ℕ) (X : ℕ → ℕ) :
    HasSum (fun m => ∑ d ∈ Icc 1 M, ((μ d : ℤ) : ℝ) ^ 2 * sig d ^ 2 / d * tailF d (X d) m)
      (∑ d ∈ Icc 1 M, ((μ d : ℤ) : ℝ) ^ 2 * sig d ^ 2 * Tl d (X d) / d) := by
  refine hasSum_sum fun d hd => ?_
  have hd0 : d ≠ 0 := by simp only [mem_Icc] at hd; omega
  have e : ((μ d : ℤ) : ℝ) ^ 2 * sig d ^ 2 * Tl d (X d) / d
      = ((μ d : ℤ) : ℝ) ^ 2 * sig d ^ 2 / d * Tl d (X d) := by ring
  rw [e]
  exact (hasSum_tail hd0 _).mul_left _

/-! ## The two tails -/

/-- **`StmtTailAvg`**: `Σ_{d ≤ M} μ²σ² T_d(M/(dY))/d ≤ CM KV (1 + log Y)`. -/
theorem tailAvg : StmtTailAvg := by
  refine ⟨CM * KV, mul_nonneg CM_pos.le KV_nonneg, fun M Y hY => ?_⟩
  have hS := hasSum_tails M (fun d => M / d / Y)
  have hB : HasSum (fun m => CM * (1 + Real.log Y) * V m) (CM * (1 + Real.log Y) * KV) :=
    summable_V.hasSum.mul_left _
  have hlY := log_nat_nonneg Y
  refine le_trans (hasSum_le (fun m => ?_) hS hB) (le_of_eq (by ring))
  rcases Nat.eq_zero_or_pos m with h0 | hm0
  · subst h0; simp only [tailF_zero, mul_zero, sum_const_zero]
    exact mul_nonneg (mul_nonneg CM_pos.le (by linarith)) (V_nonneg 0)
  have hm : m ≠ 0 := by omega
  have hmY : 1 ≤ m * Y := Nat.mul_pos hm0 hY
  have hmR : (0 : ℝ) < m := by exact_mod_cast hm0
  have hYR : (0 : ℝ) < Y := by exact_mod_cast hY
  calc ∑ d ∈ Icc 1 M, ((μ d : ℤ) : ℝ) ^ 2 * sig d ^ 2 / d * tailF d (M / d / Y) m
      ≤ ∑ d ∈ Icc 1 M, ((μ d : ℤ) : ℝ) ^ 2 * sig d ^ 2 / d *
          ((if M < d * (m * Y) ∧ m.primeFactors ⊆ d.primeFactors then (1 : ℝ) else 0) / m) := by
        refine sum_le_sum fun d hd => mul_le_mul_of_nonneg_left
          (tailF_le hm (M < d * (m * Y)) fun h => ?_) (w_nonneg d)
        have hd0 : 0 < d := by simp only [mem_Icc] at hd; omega
        have h1 : M / d < m * Y := (Nat.div_lt_iff_lt_mul hY).mp h
        have h2 : M < m * Y * d := (Nat.div_lt_iff_lt_mul hd0).mp h1
        rw [mul_comm]; exact h2
    _ = 1 / m * ∑ d ∈ Icc 1 M, ((μ d : ℤ) : ℝ) ^ 2 * sig d ^ 2 / d *
          (if M < d * (m * Y) ∧ m.primeFactors ⊆ d.primeFactors then (1 : ℝ) else 0) := by
        rw [mul_sum]; exact sum_congr rfl fun d _ => by ring
    _ ≤ 1 / m * (sig m ^ 2 / rad' m * (CM * (1 + Real.log ((m * Y : ℕ) : ℝ)))) :=
        mul_le_mul_of_nonneg_left (inner_le hm M (m * Y) hmY) (by positivity)
    _ ≤ CM * (1 + Real.log Y) * V m := by
        have hl : Real.log ((m * Y : ℕ) : ℝ) = Real.log m + Real.log Y := by
          push_cast; exact Real.log_mul hmR.ne' hYR.ne'
        rw [hl]
        have hlm := log_nat_nonneg m
        have hr : (0 : ℝ) < rad' m := by exact_mod_cast rad_pos m
        have hc0 : 0 ≤ sig m ^ 2 * CM / ((m : ℝ) * rad' m) := by
          have := CM_pos; positivity
        have e1 : 1 / (m : ℝ) * (sig m ^ 2 / rad' m * (CM * (1 + (Real.log m + Real.log Y))))
            = sig m ^ 2 * CM / ((m : ℝ) * rad' m) * (1 + Real.log m + Real.log Y) := by
          field_simp; ring
        have e2 : CM * (1 + Real.log Y) * V m
            = sig m ^ 2 * CM / ((m : ℝ) * rad' m) * ((1 + Real.log Y) * (1 + Real.log m)) := by
          unfold V; field_simp
        rw [e1, e2]
        exact mul_le_mul_of_nonneg_left (by nlinarith [mul_nonneg hlm hlY]) hc0

/-- **`StmtTailFixed`**: for `log Z ≥ 2 CM KV/η`, `Σ_{d ≤ M} μ²σ² T_d(Z)/d ≤ η (1 + log M)`. -/
theorem tailFixed : StmtTailFixed := by
  intro η hη
  obtain ⟨Z, hZ1, hZlog⟩ : ∃ Z : ℕ, 1 ≤ Z ∧ 2 * CM * KV / η ≤ Real.log Z := by
    refine ⟨⌈Real.exp (2 * CM * KV / η)⌉₊, Nat.ceil_pos.mpr (Real.exp_pos _), ?_⟩
    calc 2 * CM * KV / η = Real.log (Real.exp (2 * CM * KV / η)) := (Real.log_exp _).symm
      _ ≤ _ := Real.log_le_log (Real.exp_pos _) (Nat.le_ceil _)
  refine ⟨Z, fun M => ?_⟩
  have hlZ := log_nat_nonneg Z
  have hL : 0 < 1 + Real.log Z := by linarith
  have hS := hasSum_tails M (fun _ => Z)
  have hB : HasSum (fun m => CM * (1 + Real.log ((M : ℝ) + 1)) / (1 + Real.log Z) * V m)
      (CM * (1 + Real.log ((M : ℝ) + 1)) / (1 + Real.log Z) * KV) :=
    summable_V.hasSum.mul_left _
  have hlM1 : 0 ≤ Real.log ((M : ℝ) + 1) := Real.log_nonneg (by have := Nat.cast_nonneg (α := ℝ) M; linarith)
  have hcoef : 0 ≤ CM * (1 + Real.log ((M : ℝ) + 1)) / (1 + Real.log Z) := by
    have := CM_pos; positivity
  refine le_trans (hasSum_le (fun m => ?_) hS hB) ?_
  · rcases Nat.eq_zero_or_pos m with h0 | hm0
    · subst h0; simp only [tailF_zero, mul_zero, sum_const_zero]
      exact mul_nonneg hcoef (V_nonneg 0)
    have hm : m ≠ 0 := by omega
    by_cases hZm : Z < m
    · have hmR : (0 : ℝ) < m := by exact_mod_cast hm0
      calc ∑ d ∈ Icc 1 M, ((μ d : ℤ) : ℝ) ^ 2 * sig d ^ 2 / d * tailF d Z m
          ≤ ∑ d ∈ Icc 1 M, ((μ d : ℤ) : ℝ) ^ 2 * sig d ^ 2 / d *
              ((if M < d * (M + 1) ∧ m.primeFactors ⊆ d.primeFactors then (1 : ℝ) else 0) / m) := by
            refine sum_le_sum fun d hd => mul_le_mul_of_nonneg_left
              (tailF_le hm (M < d * (M + 1)) fun _ => ?_) (w_nonneg d)
            simp only [mem_Icc] at hd
            calc M < 1 * (M + 1) := by omega
              _ ≤ d * (M + 1) := Nat.mul_le_mul_right _ hd.1
        _ = 1 / m * ∑ d ∈ Icc 1 M, ((μ d : ℤ) : ℝ) ^ 2 * sig d ^ 2 / d *
              (if M < d * (M + 1) ∧ m.primeFactors ⊆ d.primeFactors then (1 : ℝ) else 0) := by
            rw [mul_sum]; exact sum_congr rfl fun d _ => by ring
        _ ≤ 1 / m * (sig m ^ 2 / rad' m * (CM * (1 + Real.log ((M + 1 : ℕ) : ℝ)))) :=
            mul_le_mul_of_nonneg_left (inner_le hm M (M + 1) (by omega)) (by positivity)
        _ ≤ CM * (1 + Real.log ((M : ℝ) + 1)) / (1 + Real.log Z) * V m := by
            push_cast
            have hlm : Real.log Z ≤ Real.log m :=
              Real.log_le_log (by exact_mod_cast hZ1) (by exact_mod_cast hZm.le)
            have hr : (0 : ℝ) < rad' m := by exact_mod_cast rad_pos m
            have hc0 : 0 ≤ sig m ^ 2 * CM * (1 + Real.log ((M : ℝ) + 1)) / ((m : ℝ) * rad' m) := by
              have := CM_pos; positivity
            have e1 : 1 / (m : ℝ) * (sig m ^ 2 / rad' m * (CM * (1 + Real.log ((M : ℝ) + 1))))
                = sig m ^ 2 * CM * (1 + Real.log ((M : ℝ) + 1)) / ((m : ℝ) * rad' m) * 1 := by
              field_simp
            have e2 : CM * (1 + Real.log ((M : ℝ) + 1)) / (1 + Real.log Z) * V m
                = sig m ^ 2 * CM * (1 + Real.log ((M : ℝ) + 1)) / ((m : ℝ) * rad' m) *
                  ((1 + Real.log m) / (1 + Real.log Z)) := by
              unfold V; field_simp
            rw [e1, e2]
            exact mul_le_mul_of_nonneg_left ((one_le_div hL).mpr (by linarith)) hc0
    · have hz : ∀ d ∈ Icc 1 M, ((μ d : ℤ) : ℝ) ^ 2 * sig d ^ 2 / d * tailF d Z m = 0 :=
        fun d _ => by unfold tailF; rw [if_pos (by omega), mul_zero]
      rw [sum_eq_zero hz]
      exact mul_nonneg hcoef (V_nonneg m)
  · have h2 := log_succ_le M
    have hK := KV_nonneg
    have hCK : 2 * CM * KV ≤ η * (1 + Real.log Z) := by
      have := (div_le_iff₀ hη).mp hZlog; nlinarith
    have hlM := log_nat_nonneg M
    calc CM * (1 + Real.log ((M : ℝ) + 1)) / (1 + Real.log Z) * KV
        = CM * KV / (1 + Real.log Z) * (1 + Real.log ((M : ℝ) + 1)) := by ring
      _ ≤ CM * KV / (1 + Real.log Z) * (2 * (1 + Real.log M)) :=
          mul_le_mul_of_nonneg_left h2 (by have := CM_pos; positivity)
      _ = 2 * CM * KV / (1 + Real.log Z) * (1 + Real.log M) := by ring
      _ ≤ η * (1 + Real.log M) :=
          mul_le_mul_of_nonneg_right ((div_le_iff₀ hL).mpr hCK) (by linarith)

end

/-- info: 'Arith.tailAvg' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms tailAvg

/-- info: 'Arith.tailFixed' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms tailFixed

end Arith
