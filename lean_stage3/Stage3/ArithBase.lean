/-
# Stage3.ArithBase — S12 (`design/stencil.md` § S12), the arithmetic tools for `StmtArith`. 2026-11-25.

The tools the six arithmetic facts of `SdiagLead.StmtArith` rest on. Everything is about
`σ(d) = d/φ(d)` (`SdiagLead.sig`), `μ²` and `⟨d⟩ = {m : primes of m ⊆ primes of d}`.

* `sig_eq_prod`: `σ(d) = Π_{p | d} (1 − 1/p)⁻¹` (Mathlib's `Nat.totient_eq_mul_prod_factors`).
* `hasSum_chi`: `Σ_{m ∈ ⟨d⟩} 1/m = σ(d)` (Mathlib's geometric Euler product over
  `factoredNumbers`); `sdmLe` is `StmtSdmLe`.
* `euler_le`: for a nonnegative `f`, multiplicative on coprime arguments, with
  `Σ_k f(p^k) = 1 + e_p`, `Σ_{m < N} f(m) ≤ exp(Σ_{p < N} e_p)` (Mathlib's Euler product over
  `smoothNumbers`). With `e_p ≤ c/(p√p)` the bound is `exp(c · zs)`, `zs = Σ_n 1/(n√n)`.
* `sum_inv_interval_le`: `Σ_{n/K < b ≤ n} 1/b ≤ 1 + log K` (Mathlib's harmonic bounds).
* `sum_div_swap`: `Σ_{N/K < b ≤ N} (Σ_{a | b} h(a))/b ≤ (1 + log K) Σ_{a ≤ N} h(a)/a`.
* `mean_G`: with `G(b) = μ²(b) Π_{p | b} σ(p)³(1 + 1/√p)` (which dominates `μ²σ²`, `μ²σ³` and
  `μ²σ² Π_{p|b}(1 + 1/√p)`), `Σ_{N/K < b ≤ N} G(b)/b ≤ CM (1 + log K)`, `CM = exp(29 zs)`.
  Here `G = 1 * hA`, `hA(p) = σ(p)³(1 + 1/√p) − 1 ≤ 29/√p`, so `Σ hA(a)/a ≤ exp(29 zs)`.

Size check (the rule "a lost factor is a design failure"). Every constant here is a number:
`zs`, `CM`. The only growing factor is `1 + log K`, the length of the `b`-range in the log
scale, which is what each fact allows. No factor growing with `N` or `K` is lost.

| name | content | status |
|---|---|---|
| `sp`, `qp`, `xg`, `hA`, `G`, `zs`, `CM` | `(1−1/p)⁻¹`, `1/√p`, `σ(p)³(1+1/√p)−1`, `μ²Π xg`, `μ²Π(1+xg)`, `Σ1/(n√n)`, `exp(29 zs)` | def |
| `sig_eq_prod`, `sig_mul`, `sig_ge_one` | the Euler product of `σ`, multiplicativity, `σ ≥ 1` | proved |
| `hasSum_chi`, `sdmLe` | `Σ_{m∈⟨d⟩} 1/m = σ(d)`; `StmtSdmLe` | proved |
| `euler_le`, `sum_primes_le_zs` | the Euler bound | proved |
| `sum_inv_interval_le`, `sum_div_swap` | harmonic on `(n/K, n]`; the divisor swap | proved |
| `G_eq_sum`, `prod_le_G`, `mean_G` | `G = Σ_{a|b} hA(a)`; domination; the mean of `G` | proved |

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Stage3.SdiagLeadDsum

namespace Arith

open Finset SdiagLead
open scoped ArithmeticFunction.Moebius

noncomputable section

/-! ## `σ` as an Euler product -/

/-- `s(p) = (1 − 1/p)⁻¹`. -/
def sp (p : ℕ) : ℝ := (1 - (p : ℝ)⁻¹)⁻¹

theorem sig_eq_prod {d : ℕ} (hd : d ≠ 0) : sig d = ∏ p ∈ d.primeFactors, sp p := by
  have h := congrArg (Rat.cast : ℚ → ℝ) (Nat.totient_eq_mul_prod_factors d)
  push_cast at h
  unfold sig sp
  rw [h, Finset.prod_inv_distrib, div_mul_cancel_left₀ (by exact_mod_cast hd)]

theorem sig_mul {m n : ℕ} (h : m.Coprime n) : sig (m * n) = sig m * sig n := by
  unfold sig
  rw [Nat.totient_mul h, Nat.cast_mul, Nat.cast_mul, div_mul_div_comm]

theorem sp_eq {p : ℕ} (hp : 2 ≤ p) : sp p = (p : ℝ) / ((p : ℝ) - 1) := by
  have h2 : (2 : ℝ) ≤ p := by exact_mod_cast hp
  unfold sp
  rw [show 1 - (p : ℝ)⁻¹ = ((p : ℝ) - 1) / p by field_simp, inv_div]

theorem sp_bounds {p : ℕ} (hp : 2 ≤ p) : 1 ≤ sp p ∧ sp p ≤ 2 ∧ sp p - 1 ≤ 2 / p := by
  have h2 : (2 : ℝ) ≤ p := by exact_mod_cast hp
  have h1 : (0 : ℝ) < (p : ℝ) - 1 := by linarith
  rw [sp_eq hp]
  refine ⟨?_, ?_, ?_⟩
  · rw [le_div_iff₀ h1]; linarith
  · rw [div_le_iff₀ h1]; linarith
  · rw [div_sub_one h1.ne', div_le_div_iff₀ h1 (by linarith)]; linarith

theorem sig_ge_one {d : ℕ} (hd : d ≠ 0) : 1 ≤ sig d := by
  rw [sig_eq_prod hd]
  calc (1 : ℝ) = ∏ _p ∈ d.primeFactors, (1 : ℝ) := by simp
    _ ≤ _ := prod_le_prod (fun _ _ => zero_le_one)
        fun p hp => (sp_bounds (Nat.prime_of_mem_primeFactors hp).two_le).1

theorem sig_nonneg (d : ℕ) : 0 ≤ sig d := by unfold sig; positivity

theorem sig_pf {m n : ℕ} (hm : m ≠ 0) (hn : n ≠ 0) (h : m.primeFactors = n.primeFactors) :
    sig m = sig n := by
  rw [sig_eq_prod hm, sig_eq_prod hn, h]

/-! ## `μ²` -/

theorem musq_of_sq {a : ℕ} (h : Squarefree a) : ((μ a : ℤ) : ℝ) ^ 2 = 1 := by
  rw [ArithmeticFunction.moebius_apply_of_squarefree h]
  push_cast
  rw [← pow_mul, mul_comm, pow_mul]; norm_num

theorem musq_of_not {a : ℕ} (h : ¬ Squarefree a) : ((μ a : ℤ) : ℝ) ^ 2 = 0 := by
  rw [ArithmeticFunction.moebius_eq_zero_of_not_squarefree h]; simp

theorem musq_mul {m n : ℕ} (h : m.Coprime n) :
    ((μ (m * n) : ℤ) : ℝ) ^ 2 = ((μ m : ℤ) : ℝ) ^ 2 * ((μ n : ℤ) : ℝ) ^ 2 := by
  rw [ArithmeticFunction.isMultiplicative_moebius.map_mul_of_coprime h]; push_cast; ring

theorem musq_nonneg (a : ℕ) : 0 ≤ ((μ a : ℤ) : ℝ) ^ 2 := sq_nonneg _

theorem prod_pf_mul {x : ℕ → ℝ} {m n : ℕ} (h : m.Coprime n) :
    ∏ p ∈ (m * n).primeFactors, x p = (∏ p ∈ m.primeFactors, x p) * ∏ p ∈ n.primeFactors, x p := by
  rw [h.primeFactors_mul, prod_union h.disjoint_primeFactors]

/-! ## The Euler product over `⟨d⟩`: `StmtSdmLe` -/

/-- `m ↦ 1/m` as a monoid hom. -/
def invHom : ℕ →* ℝ where
  toFun m := (m : ℝ)⁻¹
  map_one' := by simp
  map_mul' m n := by push_cast; rw [mul_inv]

/-- `Σ_{m ∈ ⟨d⟩} 1/m = σ(d)`. -/
theorem hasSum_chi {d : ℕ} (hd : d ≠ 0) :
    HasSum (fun m => ((chiAF d m : ℤ) : ℝ) / m) (sig d) := by
  obtain ⟨-, h⟩ := EulerProduct.summable_and_hasSum_factoredNumbers_prod_filter_prime_geometric
    (f := invHom) (fun {p} hp => by
      show ‖(p : ℝ)⁻¹‖ < 1
      rw [norm_inv, Real.norm_natCast]
      exact inv_lt_one_of_one_lt₀ (by exact_mod_cast hp.one_lt)) d.primeFactors
  rw [Finset.filter_true_of_mem (fun p hp => Nat.prime_of_mem_primeFactors hp)] at h
  have hval : ∏ p ∈ d.primeFactors, (1 - invHom p)⁻¹ = sig d := by rw [sig_eq_prod hd]; rfl
  rw [hval] at h
  have hI := hasSum_subtype_iff_indicator.mp h
  have hfun : (fun m : ℕ => ((chiAF d m : ℤ) : ℝ) / m)
      = (Nat.factoredNumbers d.primeFactors).indicator invHom := by
    funext m
    rw [chiAF_apply]
    by_cases hm : m ≠ 0 ∧ m.primeFactors ⊆ d.primeFactors
    · rw [if_pos hm, Set.indicator_of_mem (Nat.mem_factoredNumbers_iff_primeFactors_subset.mpr hm)]
      simp [invHom]
    · rw [if_neg hm, Set.indicator_of_notMem
        (fun h' => hm (Nat.mem_factoredNumbers_iff_primeFactors_subset.mp h'))]
      simp
  rw [hfun]; exact hI

/-- **`StmtSdmLe`**: `S_d(X) ≤ σ(d)`. -/
theorem sdmLe : StmtSdmLe := by
  intro d X hd
  unfold Sdm
  exact sum_le_hasSum (Ioc 0 X) (fun m _ => chi_term_nonneg d m) (hasSum_chi (by omega))

/-! ## The Euler bound -/

theorem euler_le {f : ℕ → ℝ} (h0 : ∀ n, 0 ≤ f n) (hf0 : f 0 = 0) (h1 : f 1 = 1)
    (hmul : ∀ {m n : ℕ}, m.Coprime n → f (m * n) = f m * f n) {e : ℕ → ℝ}
    (he : ∀ p : ℕ, p.Prime → 0 ≤ e p ∧ HasSum (fun k => f (p ^ k)) (1 + e p)) (N : ℕ) :
    ∑ m ∈ range N, f m ≤ Real.exp (∑ p ∈ N.primesBelow, e p) := by
  have hsum : ∀ {p : ℕ}, p.Prime → Summable (fun n : ℕ ↦ ‖f (p ^ n)‖) := by
    intro p hp
    simpa [Real.norm_eq_abs, abs_of_nonneg (h0 _)] using (he p hp).2.summable
  obtain ⟨-, hS⟩ :=
    EulerProduct.summable_and_hasSum_smoothNumbers_prod_primesBelow_tsum h1 hmul hsum N
  have hP : ∏ p ∈ N.primesBelow, ∑' n : ℕ, f (p ^ n) = ∏ p ∈ N.primesBelow, (1 + e p) :=
    prod_congr rfl fun p hp => (he p (Nat.prime_of_mem_primesBelow hp)).2.tsum_eq
  rw [hP] at hS
  have hI := (hasSum_subtype_iff_indicator (f := f)).mp hS
  have hle := sum_le_hasSum (range N) (fun i _ => Set.indicator_nonneg (fun j _ => h0 j) i) hI
  have heq : ∑ m ∈ range N, (N.smoothNumbers).indicator f m = ∑ m ∈ range N, f m := by
    refine sum_congr rfl fun m hm => ?_
    rcases Nat.eq_zero_or_pos m with h | h
    · subst h; simp [hf0]
    · exact Set.indicator_of_mem (Nat.mem_smoothNumbers_of_lt h (mem_range.mp hm)) f
  rw [heq] at hle
  refine hle.trans ?_
  rw [Real.exp_sum]
  exact prod_le_prod (fun p hp => by linarith [(he p (Nat.prime_of_mem_primesBelow hp)).1])
    fun p _ => by linarith [Real.add_one_le_exp (e p)]

/-- `zs = Σ_n 1/(n√n)`. -/
def zs : ℝ := ∑' n : ℕ, 1 / ((n : ℝ) * √(n : ℝ))

theorem summable_zs : Summable (fun n : ℕ => 1 / ((n : ℝ) * √(n : ℝ))) := by
  have h := Real.summable_one_div_nat_rpow.mpr (show (1 : ℝ) < 3 / 2 by norm_num)
  refine h.congr fun n => ?_
  rcases Nat.eq_zero_or_pos n with hn | hn
  · subst hn; simp
  · have hn' : (0 : ℝ) < n := by exact_mod_cast hn
    rw [Real.sqrt_eq_rpow, show (3 / 2 : ℝ) = 1 + 1 / 2 by norm_num, Real.rpow_add hn',
      Real.rpow_one]

theorem zs_nonneg : 0 ≤ zs := tsum_nonneg fun n => by positivity

theorem sum_primes_le_zs {e : ℕ → ℝ} {c : ℝ} (hc : 0 ≤ c)
    (he : ∀ p, p.Prime → e p ≤ c / ((p : ℝ) * √(p : ℝ))) (N : ℕ) :
    ∑ p ∈ N.primesBelow, e p ≤ c * zs := by
  calc ∑ p ∈ N.primesBelow, e p ≤ ∑ p ∈ N.primesBelow, c * (1 / ((p : ℝ) * √(p : ℝ))) :=
        sum_le_sum fun p hp => by rw [mul_one_div]; exact he p (Nat.prime_of_mem_primesBelow hp)
    _ = c * ∑ p ∈ N.primesBelow, 1 / ((p : ℝ) * √(p : ℝ)) := by rw [mul_sum]
    _ ≤ c * zs := mul_le_mul_of_nonneg_left
        (summable_zs.sum_le_tsum _ fun n _ => by positivity) hc

/-! ## Harmonic sums -/

theorem sum_inv_Icc_le (n : ℕ) : ∑ b ∈ Icc 1 n, (1 : ℝ) / b ≤ 1 + Real.log n := by
  have h := harmonic_le_one_add_log n
  rw [harmonic_eq_sum_Icc] at h; push_cast at h; simpa [one_div] using h

theorem log_le_sum_inv_Icc (n : ℕ) : Real.log ((n : ℝ) + 1) ≤ ∑ b ∈ Icc 1 n, (1 : ℝ) / b := by
  have h := log_add_one_le_harmonic n
  rw [harmonic_eq_sum_Icc] at h; push_cast at h; simpa [one_div] using h

theorem log_nat_nonneg (n : ℕ) : 0 ≤ Real.log n := Real.log_natCast_nonneg n

/-- `Σ_{n/K < b ≤ n} 1/b ≤ 1 + log K`. -/
theorem sum_inv_interval_le (n K : ℕ) (hK : 1 ≤ K) :
    ∑ b ∈ (Icc 1 n).filter (fun b => n < b * K), (1 : ℝ) / b ≤ 1 + Real.log K := by
  have key : ∀ b, n < b * K ↔ n / K < b := fun b => (Nat.div_lt_iff_lt_mul (by omega)).symm
  have hjn : n / K ≤ n := Nat.div_le_self n K
  have hsplit := sum_filter_add_sum_filter_not (Icc 1 n) (fun b => n < b * K)
    (fun b => (1 : ℝ) / b)
  have hnot : (Icc 1 n).filter (fun b => ¬ n < b * K) = Icc 1 (n / K) := by
    ext b; simp only [mem_filter, mem_Icc, key]; omega
  rw [hnot] at hsplit
  have hlK := log_nat_nonneg K
  rcases Nat.eq_zero_or_pos n with hn | hn
  · subst hn
    rw [Finset.Icc_eq_empty (by norm_num), filter_empty, sum_empty]; linarith
  have h1 := sum_inv_Icc_le n
  have h2 := log_le_sum_inv_Icc (n / K)
  have hlt : n < K * (n / K + 1) := Nat.lt_mul_div_succ n (by omega)
  have hlog : Real.log n ≤ Real.log ((n / K : ℕ) + 1) + Real.log K := by
    rw [← Real.log_mul (by positivity) (by have : (1 : ℝ) ≤ K := by exact_mod_cast hK
                                           positivity)]
    refine Real.log_le_log (by exact_mod_cast hn) ?_
    have : (n : ℝ) ≤ (K : ℝ) * ((n / K : ℕ) + 1) := by exact_mod_cast hlt.le
    linarith
  linarith

/-- **The divisor swap**: `Σ_{N/K < b ≤ N} (Σ_{a|b} h(a))/b ≤ (1 + log K) Σ_{a ≤ N} h(a)/a`. -/
theorem sum_div_swap {h : ℕ → ℝ} (hh : ∀ a, 0 ≤ h a) (N K : ℕ) (hK : 1 ≤ K) :
    ∑ b ∈ (Icc 1 N).filter (fun b => N < b * K), (∑ a ∈ b.divisors, h a) / b
      ≤ (1 + Real.log K) * ∑ a ∈ Icc 1 N, h a / a := by
  have e1 : ∑ b ∈ (Icc 1 N).filter (fun b => N < b * K), (∑ a ∈ b.divisors, h a) / b
      = ∑ a ∈ Icc 1 N, ∑ b ∈ ((Icc 1 N).filter (fun b => N < b * K)).filter (a ∣ ·),
          h a / b := by
    simp_rw [sum_div]
    refine sum_comm' fun b a => ?_
    simp only [mem_filter, mem_Icc, Nat.mem_divisors]
    constructor
    · rintro ⟨⟨⟨hb1, hbN⟩, hbK⟩, hab, -⟩
      have := Nat.le_of_dvd (by omega) hab
      have := Nat.pos_of_dvd_of_pos hab (by omega)
      exact ⟨⟨⟨⟨hb1, hbN⟩, hbK⟩, hab⟩, by omega, by omega⟩
    · rintro ⟨⟨⟨⟨hb1, hbN⟩, hbK⟩, hab⟩, -, -⟩
      exact ⟨⟨⟨hb1, hbN⟩, hbK⟩, hab, by omega⟩
  rw [e1, mul_sum]
  refine sum_le_sum fun a ha => ?_
  have ha0 : 0 < a := by simp only [mem_Icc] at ha; omega
  have hsub : ((Icc 1 N).filter (fun b => N < b * K)).filter (a ∣ ·) ⊆
      ((Icc 1 (N / a)).filter (fun c => N / a < c * K)).image (a * ·) := by
    intro b hb
    simp only [mem_filter, mem_Icc, mem_image] at hb ⊢
    obtain ⟨⟨⟨hb1, hbN⟩, hbK⟩, c, rfl⟩ := hb
    refine ⟨c, ⟨⟨?_, ?_⟩, ?_⟩, rfl⟩
    · rcases Nat.eq_zero_or_pos c with hc | hc
      · subst hc; simp at hb1
      · exact hc
    · exact (Nat.le_div_iff_mul_le ha0).mpr (by rw [mul_comm]; exact hbN)
    · exact (Nat.div_lt_iff_lt_mul ha0).mpr (by
        calc N < a * c * K := hbK
          _ = c * K * a := by ring)
  have hha : 0 ≤ h a / a := div_nonneg (hh a) (Nat.cast_nonneg a)
  calc ∑ b ∈ ((Icc 1 N).filter (fun b => N < b * K)).filter (a ∣ ·), h a / b
      ≤ ∑ b ∈ ((Icc 1 (N / a)).filter (fun c => N / a < c * K)).image (a * ·), h a / b :=
        sum_le_sum_of_subset_of_nonneg hsub fun b _ _ => div_nonneg (hh a) (Nat.cast_nonneg b)
    _ = ∑ c ∈ (Icc 1 (N / a)).filter (fun c => N / a < c * K), h a / ((a * c : ℕ) : ℝ) :=
        sum_image fun x _ y _ hxy => Nat.eq_of_mul_eq_mul_left ha0 hxy
    _ = h a / a * ∑ c ∈ (Icc 1 (N / a)).filter (fun c => N / a < c * K), (1 : ℝ) / c := by
        rw [mul_sum]
        refine sum_congr rfl fun c _ => ?_
        push_cast
        rw [div_mul_div_comm, mul_one]
    _ ≤ h a / a * (1 + Real.log K) :=
        mul_le_mul_of_nonneg_left (sum_inv_interval_le (N / a) K hK) hha
    _ = (1 + Real.log K) * (h a / a) := by ring

/-! ## The weight `G` and its mean -/

/-- `q(p) = 1/√p`. -/
def qp (p : ℕ) : ℝ := 1 / √(p : ℝ)

/-- `x(p) = σ(p)³(1 + 1/√p) − 1`. -/
def xg (p : ℕ) : ℝ := sp p ^ 3 * (1 + qp p) - 1

/-- `hA(a) = μ²(a) Π_{p|a} x(p)`. -/
def hA (a : ℕ) : ℝ := ((μ a : ℤ) : ℝ) ^ 2 * ∏ p ∈ a.primeFactors, xg p

/-- `G(b) = μ²(b) Π_{p|b} (1 + x(p))`. -/
def G (b : ℕ) : ℝ := ((μ b : ℤ) : ℝ) ^ 2 * ∏ p ∈ b.primeFactors, (1 + xg p)

/-- `CM = exp(29 zs)`. -/
def CM : ℝ := Real.exp (29 * zs)

theorem CM_pos : 0 < CM := Real.exp_pos _

theorem qp_bounds {p : ℕ} (hp : 2 ≤ p) :
    0 < qp p ∧ qp p ≤ 3 / 4 ∧ 1 / (p : ℝ) ≤ qp p := by
  have h2 : (2 : ℝ) ≤ p := by exact_mod_cast hp
  have hs := Real.sq_sqrt (show (0 : ℝ) ≤ p by linarith)
  have hs0 := Real.sqrt_nonneg (p : ℝ)
  have hs1 : 4 / 3 ≤ √(p : ℝ) := by nlinarith
  have hsp : √(p : ℝ) ≤ p := by nlinarith
  unfold qp
  refine ⟨by positivity, ?_, ?_⟩
  · rw [div_le_iff₀ (by linarith)]; linarith
  · exact one_div_le_one_div_of_le (by linarith) hsp

theorem xg_bounds {p : ℕ} (hp : 2 ≤ p) : 0 ≤ xg p ∧ xg p ≤ 29 * qp p := by
  obtain ⟨hs1, hs2, hs3⟩ := sp_bounds hp
  obtain ⟨hq0, hq1, hq2⟩ := qp_bounds hp
  have hu : sp p - 1 ≤ 2 * qp p := by
    have : 2 / (p : ℝ) = 2 * (1 / p) := by ring
    linarith
  unfold xg
  set s := sp p
  set q := qp p
  have hs3' : 1 ≤ s ^ 3 := one_le_pow₀ hs1
  refine ⟨by nlinarith, ?_⟩
  have hu0 : 0 ≤ s - 1 := by linarith
  have hu1 : 0 ≤ 1 - (s - 1) := by linarith
  have hcube : s ^ 3 ≤ 1 + 7 * (s - 1) := by
    nlinarith [mul_nonneg (mul_nonneg hu0 (by linarith : (0:ℝ) ≤ s - 1 + 4)) hu1]
  have hq : 0 ≤ 1 + q := by linarith
  have h1 : s ^ 3 * (1 + q) ≤ (1 + 7 * (s - 1)) * (1 + q) := mul_le_mul_of_nonneg_right hcube hq
  have h2 : (s - 1) * q ≤ (s - 1) := by nlinarith
  nlinarith

theorem xg_div_le {p : ℕ} (hp : p.Prime) : xg p / p ≤ 29 / ((p : ℝ) * √(p : ℝ)) := by
  have h := (xg_bounds hp.two_le).2
  have hp0 : (0 : ℝ) < p := by exact_mod_cast hp.pos
  have hs : 0 < √(p : ℝ) := Real.sqrt_pos.mpr hp0
  unfold qp at h
  rw [div_le_iff₀ hp0]
  calc xg p ≤ 29 * (1 / √(p : ℝ)) := h
    _ = 29 / ((p : ℝ) * √(p : ℝ)) * p := by field_simp

theorem hA_nonneg (a : ℕ) : 0 ≤ hA a :=
  mul_nonneg (musq_nonneg a)
    (prod_nonneg fun _ hp => (xg_bounds (Nat.prime_of_mem_primeFactors hp).two_le).1)

theorem G_nonneg (b : ℕ) : 0 ≤ G b :=
  mul_nonneg (musq_nonneg b)
    (prod_nonneg fun _ hp => by
      linarith [(xg_bounds (Nat.prime_of_mem_primeFactors hp).two_le).1])

theorem G_eq_sum {b : ℕ} (hb : Squarefree b) : G b = ∑ a ∈ b.divisors, hA a := by
  have h := (ArithmeticFunction.IsMultiplicative.prodPrimeFactors xg).prodPrimeFactors_one_add_of_squarefree hb
  unfold G hA
  rw [musq_of_sq hb, one_mul]
  have e1 : ∏ p ∈ b.primeFactors, (1 + xg p)
      = ∏ p ∈ b.primeFactors, (1 + ArithmeticFunction.prodPrimeFactors xg p) :=
    prod_congr rfl fun p hp => by
      rw [ArithmeticFunction.prodPrimeFactors_apply (Nat.prime_of_mem_primeFactors hp).ne_zero,
        (Nat.prime_of_mem_primeFactors hp).primeFactors, prod_singleton]
  rw [e1, h]
  refine sum_congr rfl fun a ha => ?_
  have ha0 : a ≠ 0 := Nat.ne_of_gt (Nat.pos_of_mem_divisors ha)
  rw [ArithmeticFunction.prodPrimeFactors_apply ha0,
    musq_of_sq (Squarefree.squarefree_of_dvd (Nat.dvd_of_mem_divisors ha) hb), one_mul]

/-- A product over the primes of a squarefree `b` with factors `≤ 1 + x(p)` is `≤ G(b)`. -/
theorem prod_le_G {b : ℕ} (hb : Squarefree b) {y : ℕ → ℝ}
    (hy : ∀ p, p.Prime → 0 ≤ y p ∧ y p ≤ 1 + xg p) : ∏ p ∈ b.primeFactors, y p ≤ G b := by
  unfold G
  rw [musq_of_sq hb, one_mul]
  exact prod_le_prod (fun p hp => (hy p (Nat.prime_of_mem_primeFactors hp)).1)
    fun p hp => (hy p (Nat.prime_of_mem_primeFactors hp)).2

theorem hA_hasSum {p : ℕ} (hp : p.Prime) :
    HasSum (fun k => hA (p ^ k) / ((p ^ k : ℕ) : ℝ)) (1 + xg p / p) := by
  have h0 : ∀ k ∉ range 2, hA (p ^ k) / ((p ^ k : ℕ) : ℝ) = 0 := by
    intro k hk
    have hk2 : 2 ≤ k := by simp only [mem_range] at hk; omega
    unfold hA
    rw [ArithmeticFunction.moebius_apply_prime_pow hp (by omega), if_neg (by omega)]; simp
  have e : ∑ k ∈ range 2, hA (p ^ k) / ((p ^ k : ℕ) : ℝ) = 1 + xg p / p := by
    rw [Finset.sum_range_succ, Finset.sum_range_succ, Finset.sum_range_zero, pow_zero, pow_one, zero_add]
    unfold hA
    simp [ArithmeticFunction.moebius_apply_prime hp, hp.primeFactors]
  rw [← e]
  exact hasSum_sum_of_ne_finset_zero h0

theorem sum_hA_le (N : ℕ) : ∑ a ∈ Icc 1 N, hA a / a ≤ CM := by
  have hmul : ∀ {m n : ℕ}, m.Coprime n → hA (m * n) / ((m * n : ℕ) : ℝ)
      = hA m / m * (hA n / n) := by
    intro m n h
    unfold hA
    rw [musq_mul h, prod_pf_mul h]; push_cast; rw [div_mul_div_comm]; ring
  calc ∑ a ∈ Icc 1 N, hA a / a ≤ ∑ a ∈ range (N + 1), hA a / a :=
        sum_le_sum_of_subset_of_nonneg (fun a ha => by simp only [mem_Icc, mem_range] at ha ⊢; omega)
          fun a _ _ => div_nonneg (hA_nonneg a) (Nat.cast_nonneg a)
    _ ≤ Real.exp (∑ p ∈ (N + 1).primesBelow, xg p / p) :=
        euler_le (f := fun a => hA a / a) (fun a => div_nonneg (hA_nonneg a) (Nat.cast_nonneg a))
          (by simp) (by simp [hA]) hmul
          (fun p hp => ⟨div_nonneg (xg_bounds hp.two_le).1 (Nat.cast_nonneg p), hA_hasSum hp⟩) _
    _ ≤ CM := Real.exp_le_exp.mpr (sum_primes_le_zs (by norm_num) (fun p hp => xg_div_le hp) _)

/-- **The mean of `G`**: `Σ_{N/K < b ≤ N} G(b)/b ≤ CM (1 + log K)`. -/
theorem mean_G (N K : ℕ) (hK : 1 ≤ K) :
    ∑ b ∈ (Icc 1 N).filter (fun b => N < b * K), G b / b ≤ CM * (1 + Real.log K) := by
  have hle : ∀ b, G b ≤ ∑ a ∈ b.divisors, hA a := by
    intro b
    by_cases hb : Squarefree b
    · exact (G_eq_sum hb).le
    · unfold G; rw [musq_of_not hb, zero_mul]; exact sum_nonneg fun a _ => hA_nonneg a
  have hlK := log_nat_nonneg K
  calc _ ≤ ∑ b ∈ (Icc 1 N).filter (fun b => N < b * K), (∑ a ∈ b.divisors, hA a) / b :=
        sum_le_sum fun b _ => div_le_div_of_nonneg_right (hle b) (Nat.cast_nonneg b)
    _ ≤ (1 + Real.log K) * ∑ a ∈ Icc 1 N, hA a / a := sum_div_swap hA_nonneg N K hK
    _ ≤ (1 + Real.log K) * CM := mul_le_mul_of_nonneg_left (sum_hA_le N) (by linarith)
    _ = _ := by ring

/-- `1 + log(M + 1) ≤ 2(1 + log M)`. -/
theorem log_succ_le (M : ℕ) : 1 + Real.log ((M : ℝ) + 1) ≤ 2 * (1 + Real.log M) := by
  rcases Nat.eq_zero_or_pos M with h | h
  · subst h; simp
  · have hM : (1 : ℝ) ≤ M := by exact_mod_cast h
    have h1 : Real.log ((M : ℝ) + 1) ≤ Real.log (2 * M) :=
      Real.log_le_log (by positivity) (by linarith)
    rw [Real.log_mul (by norm_num) (by positivity)] at h1
    have h2 := Real.log_two_lt_d9
    have h3 := Real.log_nonneg hM
    linarith

theorem filter_all (M : ℕ) : (Icc 1 M).filter (fun b => M < b * (M + 1)) = Icc 1 M :=
  filter_true_of_mem fun b hb => by
    simp only [mem_Icc] at hb
    calc M < 1 * (M + 1) := by omega
      _ ≤ b * (M + 1) := Nat.mul_le_mul_right _ hb.1

/-- The plain mean: `Σ_{b ≤ M} G(b)/b ≤ 2 CM (1 + log M)`. -/
theorem mean_G_all (M : ℕ) : ∑ b ∈ Icc 1 M, G b / b ≤ 2 * CM * (1 + Real.log M) := by
  have h := mean_G M (M + 1) (by omega)
  rw [filter_all] at h
  push_cast at h
  calc _ ≤ CM * (1 + Real.log ((M : ℝ) + 1)) := h
    _ ≤ CM * (2 * (1 + Real.log M)) := mul_le_mul_of_nonneg_left (log_succ_le M) CM_pos.le
    _ = _ := by ring

end

/-- info: 'Arith.sdmLe' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms sdmLe

/-- info: 'Arith.mean_G' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms mean_G

end Arith
