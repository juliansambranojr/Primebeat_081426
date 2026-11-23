/-
FilterLadder — block S1 of `lean_stage3/design/stencil.md`. 2026-11-23.

The filtered ladder. Put `a_k = ψ(2^k) − 2^k`. A polynomial `q` acts on the
ladder by `Σ_j q_j·a_{n−j}`, and on a mode `z^n` as multiplication by
`q(1/z)`. With the weighted norm `‖q‖_W = Σ_j |q_j|·2^(−j/2)`, which is
submultiplicative, the filter `q^m` with `m·deg q < n` reads only rows `≥ 1`.
If the ladder is of square-root size, `|a_k| ≤ C·k²·√2^k`, then the explicit
formula at `x = 2^k` and the one height `2^n` for every `k ≤ n` writes the
filtered ladder as minus the filtered sum over the zeros below `2^n`, up to
`O(n²·2^(n/2)·‖q‖_W^m)`. The zeros with real part below `σ` give at most
`zinv(2^n)·2^(σn)·‖q‖_W^m`. So the zeros with real part at least `σ`, each
weighted by `q(2^(−ρ))^m`, sum to at most `A·n²·2^(σn)·‖q‖_W^m`, with `A`
depending on `C` alone.

  Wb, Wn, Wn_eq_Wb        the weighted norm at weight `t`, and at `2^(−1/2)`
  Wb_eq_range             the same sum over any longer range
  posPoly, coeff_posPoly  the polynomial of the sizes of the coefficients
  Wb_mul_le, Wb_pow_le    Wb t (p·q) ≤ Wb t p · Wb t q, and the power
  Wn_pow_le               ‖q^m‖_W ≤ ‖q‖_W^m
  norm_eval_le_Wb, Wb_mono, norm_eval_le_Wn   |q(u)| ≤ Wb |u| q, and ≤ ‖q‖_W for |u| ≤ 2^(−1/2)
  filter_mode             Σ_{j≤N} (q^m)_j·z^(n−j) = z^n·q(1/z)^m
  ladder, Kf, formula_row the ladder, and the explicit formula on row k ≤ n at height 2^n
  Afl                     the constant C + Kf + 39000·Mlow
  filtered_modes_small_sq the filtered sum over Re ρ ≥ σ is ≤ Afl C·n²·2^(σn)·‖q‖_W^m
  filtered_modes_small    the same with ∃ A and n⁴, the shape of the design

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.FiniteOffLinePi
import Stage3.FixedRowTwo

namespace FilterLadder

open Finset Polynomial Kadiri FiniteOffLine PiZeros PiRemainder

noncomputable section

/-- The weighted size of a polynomial at weight `t`: the sum of the sizes of its
coefficients, the `j`-th times `t^j`. -/
def Wb (t : ℝ) (q : Polynomial ℂ) : ℝ :=
  ∑ j ∈ range (q.natDegree + 1), ‖q.coeff j‖ * t ^ j

/-- The weighted norm of the design: the `j`-th coefficient's size times `2^(−j/2)`. -/
def Wn (q : Polynomial ℂ) : ℝ :=
  ∑ j ∈ range (q.natDegree + 1), ‖q.coeff j‖ * (2:ℝ) ^ (-(j:ℝ) / 2)

/-- The weight `2^(−j/2)` is the `j`-th power of `1/√2`. -/
theorem rpow_half_eq (j : ℕ) : (2:ℝ) ^ (-(j:ℝ) / 2) = (Real.sqrt 2)⁻¹ ^ j := by
  rw [Real.sqrt_eq_rpow, ← Real.rpow_neg (by norm_num), ← Real.rpow_natCast,
    ← Real.rpow_mul (by norm_num)]
  congr 1
  ring

/-- The weighted norm of the design is the weighted size at weight `1/√2`. -/
theorem Wn_eq_Wb (q : Polynomial ℂ) : Wn q = Wb (Real.sqrt 2)⁻¹ q := by
  unfold Wn Wb
  refine Finset.sum_congr rfl fun j _ => ?_
  rw [rpow_half_eq]

/-- The weighted size is the same sum over any range longer than the degree. -/
theorem Wb_eq_range (t : ℝ) (q : Polynomial ℂ) {N : ℕ} (hN : q.natDegree < N) :
    Wb t q = ∑ j ∈ range N, ‖q.coeff j‖ * t ^ j := by
  unfold Wb
  apply Finset.sum_subset
  · intro j hj
    rw [Finset.mem_range] at hj ⊢
    omega
  · intro j _ hj
    rw [Finset.mem_range, not_lt] at hj
    rw [Polynomial.coeff_eq_zero_of_natDegree_lt (by omega), norm_zero, zero_mul]

/-- The weighted size is nonnegative at a nonnegative weight. -/
theorem Wb_nonneg {t : ℝ} (ht : 0 ≤ t) (q : Polynomial ℂ) : 0 ≤ Wb t q :=
  Finset.sum_nonneg fun j _ => mul_nonneg (norm_nonneg _) (pow_nonneg ht j)

/-- The weighted norm of the design is nonnegative. -/
theorem Wn_nonneg (q : Polynomial ℂ) : 0 ≤ Wn q := by
  rw [Wn_eq_Wb]
  exact Wb_nonneg (by positivity) q

/-- The real polynomial whose coefficients are the sizes of the coefficients of `q`. -/
def posPoly (q : Polynomial ℂ) : Polynomial ℝ :=
  ∑ j ∈ range (q.natDegree + 1), Polynomial.monomial j ‖q.coeff j‖

/-- Each coefficient of `posPoly q` is the size of the same coefficient of `q`. -/
theorem coeff_posPoly (q : Polynomial ℂ) (i : ℕ) : (posPoly q).coeff i = ‖q.coeff i‖ := by
  unfold posPoly
  rw [Polynomial.finsetSum_coeff]
  simp only [Polynomial.coeff_monomial]
  rw [Finset.sum_ite_eq']
  split_ifs with h
  · rfl
  · rw [Finset.mem_range, not_lt] at h
    rw [Polynomial.coeff_eq_zero_of_natDegree_lt (by omega), norm_zero]

/-- The weighted size is the value of `posPoly q` at the weight. -/
theorem Wb_eq_eval (t : ℝ) (q : Polynomial ℂ) : Wb t q = (posPoly q).eval t := by
  unfold Wb posPoly
  rw [Polynomial.eval_finsetSum]
  simp only [Polynomial.eval_monomial]

/-- The degree of `posPoly q` is at most that of `q`. -/
theorem natDegree_posPoly_le (q : Polynomial ℂ) : (posPoly q).natDegree ≤ q.natDegree := by
  rw [Polynomial.natDegree_le_iff_coeff_eq_zero]
  intro N hN
  rw [coeff_posPoly, Polynomial.coeff_eq_zero_of_natDegree_lt hN, norm_zero]

/-- **The weighted size is submultiplicative.** At a nonnegative weight,
`Wb t (p·q) ≤ Wb t p · Wb t q`: each coefficient of the product is at most the
same coefficient of `posPoly p · posPoly q`, whose value at `t` is the product. -/
theorem Wb_mul_le {t : ℝ} (ht : 0 ≤ t) (p q : Polynomial ℂ) :
    Wb t (p * q) ≤ Wb t p * Wb t q := by
  set N := p.natDegree + q.natDegree + 1 with hN
  have h1 : (p * q).natDegree < N := by
    have := Polynomial.natDegree_mul_le (p := p) (q := q)
    omega
  have h2 : (posPoly p * posPoly q).natDegree < N := by
    have := Polynomial.natDegree_mul_le (p := posPoly p) (q := posPoly q)
    have := natDegree_posPoly_le p
    have := natDegree_posPoly_le q
    omega
  rw [Wb_eq_range t _ h1, Wb_eq_eval t p, Wb_eq_eval t q, ← Polynomial.eval_mul,
    Polynomial.eval_eq_sum_range' h2]
  refine Finset.sum_le_sum fun j _ => ?_
  apply mul_le_mul_of_nonneg_right _ (pow_nonneg ht j)
  rw [Polynomial.coeff_mul, Polynomial.coeff_mul]
  refine (norm_sum_le _ _).trans (le_of_eq ?_)
  refine Finset.sum_congr rfl fun x _ => ?_
  rw [norm_mul, coeff_posPoly, coeff_posPoly]

/-- The weighted size of the constant `1` is `1`. -/
theorem Wb_one (t : ℝ) : Wb t (1 : Polynomial ℂ) = 1 := by
  unfold Wb
  simp

/-- **The weighted size of a power** is at most the power of the weighted size. -/
theorem Wb_pow_le {t : ℝ} (ht : 0 ≤ t) (q : Polynomial ℂ) (m : ℕ) :
    Wb t (q ^ m) ≤ Wb t q ^ m := by
  induction m with
  | zero => rw [pow_zero, pow_zero, Wb_one]
  | succ m ih =>
    rw [pow_succ, pow_succ]
    exact (Wb_mul_le ht _ _).trans
      (mul_le_mul_of_nonneg_right ih (Wb_nonneg ht q))

/-- **Fact (i) of block S1.** The weighted norm of a power is at most the power of
the weighted norm: `‖q^m‖_W ≤ ‖q‖_W^m`. -/
theorem Wn_pow_le (q : Polynomial ℂ) (m : ℕ) : Wn (q ^ m) ≤ Wn q ^ m := by
  rw [Wn_eq_Wb, Wn_eq_Wb]
  exact Wb_pow_le (by positivity) q m

/-- info: 'FilterLadder.Wn_pow_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Wn_pow_le

/-- The value of a polynomial at `u` has size at most its weighted size at `|u|`. -/
theorem norm_eval_le_Wb (q : Polynomial ℂ) (u : ℂ) : ‖q.eval u‖ ≤ Wb ‖u‖ q := by
  rw [Polynomial.eval_eq_sum_range]
  refine (norm_sum_le _ _).trans (le_of_eq ?_)
  unfold Wb
  refine Finset.sum_congr rfl fun j _ => ?_
  rw [norm_mul, norm_pow]

/-- The weighted size grows with the weight. -/
theorem Wb_mono {t t' : ℝ} (ht : 0 ≤ t) (htt : t ≤ t') (q : Polynomial ℂ) :
    Wb t q ≤ Wb t' q :=
  Finset.sum_le_sum fun j _ =>
    mul_le_mul_of_nonneg_left (pow_le_pow_left₀ ht htt j) (norm_nonneg _)

/-- **Fact (ii) of block S1.** For `|u| ≤ 2^(−1/2)` the value `q(u)` has size at most
`‖q‖_W`. For `|u| ≤ 2^(−β)` in general, `norm_eval_le_Wb` and `Wb_mono` give
`|q(u)| ≤ Wb (2^(−β)) q = Σ_j |q_j|·2^(−jβ)`. -/
theorem norm_eval_le_Wn (q : Polynomial ℂ) {u : ℂ} (hu : ‖u‖ ≤ (Real.sqrt 2)⁻¹) :
    ‖q.eval u‖ ≤ Wn q := by
  rw [Wn_eq_Wb]
  exact (norm_eval_le_Wb q u).trans (Wb_mono (norm_nonneg u) hu q)

/-- **Fact (iii) of block S1: the filter on a mode.** If `(q^m)` has degree at most
`N ≤ n` and `z ≠ 0`, then `Σ_{j≤N} (q^m)_j·z^(n−j) = z^n·q(1/z)^m`. -/
theorem filter_mode (q : Polynomial ℂ) {m N n : ℕ} (hN : (q ^ m).natDegree ≤ N)
    (hNn : N ≤ n) {z : ℂ} (hz : z ≠ 0) :
    ∑ j ∈ range (N + 1), (q ^ m).coeff j * z ^ (n - j) = z ^ n * (q.eval z⁻¹) ^ m := by
  rw [← Polynomial.eval_pow, Polynomial.eval_eq_sum_range' (n := N + 1) (by omega), Finset.mul_sum]
  refine Finset.sum_congr rfl fun j hj => ?_
  rw [Finset.mem_range] at hj
  rw [pow_sub₀ z hz (by omega), inv_pow]
  ring

/-- info: 'FilterLadder.filter_mode' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms filter_mode

/-- The ladder: `a_k = ψ(2^k) − 2^k`, as a complex number. -/
def ladder (k : ℕ) : ℂ := (Chebyshev.psi ((2:ℝ) ^ k) : ℂ) - (((2:ℝ) ^ k : ℝ) : ℂ)

/-- The constant of the explicit formula on the rows `k ≤ n` at height `2^n`:
`4·c1t + c3t + Bleft2`. -/
def Kf : ℝ := 4 * ExplicitTwo.c1t + ExplicitTwo.c3t + ExplicitTwo.Bleft2

/-- The constant `Kf` is nonnegative. -/
theorem Kf_nonneg : 0 ≤ Kf := by
  have h1 := FixedRowTwo.c1t_nonneg
  have h2 := FixedRowTwo.c3t_nonneg
  have h3 := FixedRowTwo.Bleft2_nonneg
  unfold Kf
  linarith

/-- The weight of a zero in the explicit formula: its order over the zero. -/
def wz (ρ : NontrivialZeros) : ℂ := ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) / (ρ : ℂ)

/-- **The explicit formula on one row, at the one height `2^n`.** For `1 ≤ k ≤ n`,
the ladder at row `k` plus the sum over the zeros below `2^n` of `m(ρ)/ρ·(2^ρ)^k`
has size at most `Kf·n²`. The set of zeros is the same for every `k`. -/
theorem formula_row {n k : ℕ} (hk : 1 ≤ k) (hkn : k ≤ n) :
    ‖ladder k + ∑ ρ ∈ ZF ((2:ℝ) ^ n), wz ρ * ((2:ℂ) ^ (ρ : ℂ)) ^ k‖ ≤ Kf * (n:ℝ) ^ 2 := by
  have hx : (2:ℝ) ≤ (2:ℝ) ^ k := by
    calc (2:ℝ) = 2 ^ 1 := by norm_num
      _ ≤ 2 ^ k := pow_le_pow_right₀ (by norm_num) hk
  have hT : (2:ℝ) ≤ (2:ℝ) ^ n := hx.trans (pow_le_pow_right₀ (by norm_num) hkn)
  have hF := ExplicitTwo.explicit_formula_all_two hx hT
  rw [zeroPartialSum_eq_sum] at hF
  have hsum : ∑ ρ ∈ ZF ((2:ℝ) ^ n), ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ)
        * ((((2:ℝ) ^ k : ℝ) : ℂ) ^ (ρ : ℂ) / (ρ : ℂ))
      = ∑ ρ ∈ ZF ((2:ℝ) ^ n), wz ρ * ((2:ℂ) ^ (ρ : ℂ)) ^ k := by
    refine Finset.sum_congr rfl fun ρ _ => ?_
    rw [FiniteOffLinePi.cpow_doubling, wz]
    ring
  rw [hsum] at hF
  have hl2 : Real.log 2 < 1 := by linarith [Real.log_two_lt_d9]
  have hl0 : 0 < Real.log 2 := Real.log_pos (by norm_num)
  have hk1 : (1:ℝ) ≤ (k:ℝ) := by exact_mod_cast hk
  have hkn' : (k:ℝ) ≤ (n:ℝ) := by exact_mod_cast hkn
  have hn1 : (1:ℝ) ≤ (n:ℝ) := hk1.trans hkn'
  have hc1 := FixedRowTwo.c1t_nonneg
  have hc3 := FixedRowTwo.c3t_nonneg
  have hB := FixedRowTwo.Bleft2_nonneg
  -- the first term
  have e1 : Real.log ((2:ℝ) ^ k * (2:ℝ) ^ n) = ((k:ℝ) + n) * Real.log 2 := by
    rw [← pow_add, Real.log_pow]
    push_cast
    ring
  have hL0 : 0 ≤ ((k:ℝ) + n) * Real.log 2 := by positivity
  have hL : ((k:ℝ) + n) * Real.log 2 ≤ 2 * n := by nlinarith
  have hxT : (2:ℝ) ^ k / (2:ℝ) ^ n ≤ 1 :=
    div_le_one_of_le₀ (pow_le_pow_right₀ (by norm_num) hkn) (by positivity)
  have t1 : ExplicitTwo.c1t * (2:ℝ) ^ k * Real.log ((2:ℝ) ^ k * (2:ℝ) ^ n) ^ 2 / (2:ℝ) ^ n
      ≤ 4 * ExplicitTwo.c1t * (n:ℝ) ^ 2 := by
    rw [e1]
    have e : ExplicitTwo.c1t * (2:ℝ) ^ k * (((k:ℝ) + n) * Real.log 2) ^ 2 / (2:ℝ) ^ n
        = ExplicitTwo.c1t * ((2:ℝ) ^ k / (2:ℝ) ^ n) * (((k:ℝ) + n) * Real.log 2) ^ 2 := by
      ring
    rw [e]
    have hsq : (((k:ℝ) + n) * Real.log 2) ^ 2 ≤ (2 * (n:ℝ)) ^ 2 := pow_le_pow_left₀ hL0 hL 2
    calc ExplicitTwo.c1t * ((2:ℝ) ^ k / (2:ℝ) ^ n) * (((k:ℝ) + n) * Real.log 2) ^ 2
        ≤ ExplicitTwo.c1t * 1 * (2 * (n:ℝ)) ^ 2 :=
          mul_le_mul (mul_le_mul_of_nonneg_left hxT hc1) hsq (by positivity) (by linarith)
      _ = 4 * ExplicitTwo.c1t * (n:ℝ) ^ 2 := by ring
  -- the second term
  have t2 : ExplicitTwo.c3t * Real.log ((2:ℝ) ^ k) ≤ ExplicitTwo.c3t * (n:ℝ) ^ 2 := by
    rw [Real.log_pow]
    apply mul_le_mul_of_nonneg_left _ hc3
    nlinarith
  -- the third term
  have t3 : ExplicitTwo.Bleft2 * ((2:ℝ) ^ k) ^ (-(1:ℝ) / 4) ≤ ExplicitTwo.Bleft2 * (n:ℝ) ^ 2 := by
    have h1 : ((2:ℝ) ^ k) ^ (-(1:ℝ) / 4) ≤ 1 :=
      Real.rpow_le_one_of_one_le_of_nonpos (by linarith) (by norm_num)
    have h2 : (1:ℝ) ≤ (n:ℝ) ^ 2 := by nlinarith
    apply mul_le_mul_of_nonneg_left (h1.trans h2) hB
  unfold ladder Kf
  have e : (4 * ExplicitTwo.c1t + ExplicitTwo.c3t + ExplicitTwo.Bleft2) * (n:ℝ) ^ 2
      = 4 * ExplicitTwo.c1t * (n:ℝ) ^ 2 + ExplicitTwo.c3t * (n:ℝ) ^ 2
        + ExplicitTwo.Bleft2 * (n:ℝ) ^ 2 := by ring
  rw [e]
  linarith

/-- The constant of the filtered sum: `C + Kf + 39000·Mlow`. It depends on the
constant `C` of the hypothesis and on nothing else. -/
def Afl (C : ℝ) : ℝ := C + Kf + Mlow * 39000

/-- `√2^n · (1/√2)^j = √2^(n−j)` for `j ≤ n`. -/
theorem sqrt_split {j n : ℕ} (hj : j ≤ n) :
    Real.sqrt 2 ^ n * (Real.sqrt 2)⁻¹ ^ j = Real.sqrt 2 ^ (n - j) := by
  have hs : Real.sqrt 2 ≠ 0 := by positivity
  have e : Real.sqrt 2 ^ n = Real.sqrt 2 ^ (n - j) * Real.sqrt 2 ^ j := by
    rw [← pow_add, Nat.sub_add_cancel hj]
  rw [e, mul_assoc, ← mul_pow, mul_inv_cancel₀ hs, one_pow, mul_one]

/-- **The filtered modes of the zeros with real part at least `σ`, sharp form.**
Let the ladder be of square-root size, `|ψ(2^k) − 2^k| ≤ C·k²·√2^k` for `k ≥ 1`,
and let `σ ≥ 1/2`. For every polynomial `q` and every `n ≥ 2`, `m` with
`m·deg q < n`, the sum over the zeros below `2^n` with real part at least `σ` of
`m(ρ)/ρ·q(2^(−ρ))^m·(2^ρ)^n` has size at most `Afl C·n²·2^(σn)·‖q‖_W^m`. -/
theorem filtered_modes_small_sq {C : ℝ}
    (hH : ∀ k : ℕ, 1 ≤ k → ‖(Chebyshev.psi ((2:ℝ)^k) : ℂ) - (((2:ℝ)^k : ℝ) : ℂ)‖
      ≤ C * (k:ℝ)^2 * Real.sqrt 2 ^ k)
    {σ : ℝ} (hσ : 1/2 ≤ σ) (q : Polynomial ℂ) {n m : ℕ} (hn : 2 ≤ n)
    (hmn : m * q.natDegree < n) :
    ‖∑ ρ ∈ (FiniteOffLine.ZF ((2:ℝ)^n)).filter (fun ρ : NontrivialZeros => σ ≤ (ρ : ℂ).re),
          ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) / (ρ : ℂ)
            * (q.eval (((2:ℂ) ^ (ρ : ℂ))⁻¹)) ^ m * ((2:ℂ) ^ (ρ : ℂ)) ^ n‖
        ≤ Afl C * (n:ℝ)^2 * (2:ℝ)^(σ * n) * Wn q ^ m := by
  classical
  set N := m * q.natDegree with hNdef
  set F := ZF ((2:ℝ) ^ n) with hFdef
  set s : ℝ := (Real.sqrt 2)⁻¹ with hsdef
  set c : ℕ → ℂ := fun j => (q ^ m).coeff j with hcdef
  set W := Wb s (q ^ m) with hWdef
  set P : ℝ := (2:ℝ) ^ (σ * n) with hPdef
  set R : ℝ := Real.sqrt 2 ^ n with hRdef
  set g : NontrivialZeros → ℂ := fun ρ => ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) / (ρ : ℂ)
      * (q.eval (((2:ℂ) ^ (ρ : ℂ))⁻¹)) ^ m * ((2:ℂ) ^ (ρ : ℂ)) ^ n with hgdef
  show ‖∑ ρ ∈ F.filter (fun ρ : NontrivialZeros => σ ≤ (ρ : ℂ).re), g ρ‖ ≤ Afl C * (n:ℝ)^2 * P * Wn q ^ m
  have hdeg : (q ^ m).natDegree ≤ N := Polynomial.natDegree_pow_le
  have hNn : N < n := hmn
  have hn1 : (1:ℝ) ≤ (n:ℝ) := by exact_mod_cast (by omega : 1 ≤ n)
  have hn2 : (0:ℝ) ≤ (n:ℝ) ^ 2 := by positivity
  have hsqpos : 0 < Real.sqrt 2 := by positivity
  have hsq1 : (1:ℝ) ≤ Real.sqrt 2 := by
    rw [show (1:ℝ) = Real.sqrt 1 by rw [Real.sqrt_one]]
    exact Real.sqrt_le_sqrt (by norm_num)
  have hs0 : 0 ≤ s := by positivity
  have hW0 : 0 ≤ W := Wb_nonneg hs0 _
  have hWq : W ≤ Wn q ^ m := by
    rw [hWdef, hsdef, ← Wn_eq_Wb]
    exact Wn_pow_le q m
  have hWr : W = ∑ j ∈ range (N + 1), ‖c j‖ * s ^ j := Wb_eq_range s _ (by omega)
  have hC : 0 ≤ C := by
    have h := (norm_nonneg _).trans (hH 1 le_rfl)
    have h' : 0 ≤ C * Real.sqrt 2 := by simpa using h
    nlinarith
  have h2σ : Real.sqrt 2 ≤ (2:ℝ) ^ σ := by
    rw [Real.sqrt_eq_rpow]
    exact Real.rpow_le_rpow_of_exponent_le (by norm_num) hσ
  have hP' : P = ((2:ℝ) ^ σ) ^ n := by
    rw [hPdef, Real.rpow_mul (by norm_num), Real.rpow_natCast]
  have hRP : R ≤ P := by
    rw [hP', hRdef]
    exact pow_le_pow_left₀ hsqpos.le h2σ n
  have hR0 : 0 ≤ R := by positivity
  have hRs : ∀ j ∈ range (N + 1), 1 ≤ R * s ^ j := by
    intro j hj
    rw [Finset.mem_range] at hj
    rw [hRdef, hsdef, sqrt_split (by omega)]
    exact one_le_pow₀ hsq1
  -- the rows of the ladder through the explicit formula
  set Z : ℕ → ℂ := fun k => ∑ ρ ∈ F, wz ρ * ((2:ℂ) ^ (ρ : ℂ)) ^ k with hZdef
  have he : ∀ j ∈ range (N + 1), ‖c j * (ladder (n - j) + Z (n - j))‖
      ≤ Kf * (n:ℝ) ^ 2 * R * (‖c j‖ * s ^ j) := by
    intro j hj
    have hj' := Finset.mem_range.mp hj
    have hrow := formula_row (n := n) (k := n - j) (by omega) (by omega)
    rw [norm_mul]
    have hK : 0 ≤ Kf * (n:ℝ) ^ 2 := mul_nonneg Kf_nonneg hn2
    calc ‖c j‖ * ‖ladder (n - j) + Z (n - j)‖ ≤ ‖c j‖ * (Kf * (n:ℝ) ^ 2) :=
          mul_le_mul_of_nonneg_left hrow (norm_nonneg _)
      _ ≤ ‖c j‖ * (Kf * (n:ℝ) ^ 2) * (R * s ^ j) :=
          le_mul_of_one_le_right (mul_nonneg (norm_nonneg _) hK) (hRs j hj)
      _ = Kf * (n:ℝ) ^ 2 * R * (‖c j‖ * s ^ j) := by ring
  -- the filtered ladder through the hypothesis
  have hT : ∀ j ∈ range (N + 1), ‖c j * ladder (n - j)‖
      ≤ C * (n:ℝ) ^ 2 * R * (‖c j‖ * s ^ j) := by
    intro j hj
    have hj' := Finset.mem_range.mp hj
    have h := hH (n - j) (by omega)
    have hnj : ((n - j : ℕ) : ℝ) ≤ (n:ℝ) := by exact_mod_cast Nat.sub_le n j
    have hnj2 : ((n - j : ℕ) : ℝ) ^ 2 ≤ (n:ℝ) ^ 2 := pow_le_pow_left₀ (by positivity) hnj 2
    rw [norm_mul]
    have hsp : Real.sqrt 2 ^ (n - j) = R * s ^ j := by
      rw [hRdef, hsdef, sqrt_split (by omega)]
    calc ‖c j‖ * ‖ladder (n - j)‖
        ≤ ‖c j‖ * (C * ((n - j : ℕ) : ℝ) ^ 2 * Real.sqrt 2 ^ (n - j)) :=
          mul_le_mul_of_nonneg_left h (norm_nonneg _)
      _ ≤ ‖c j‖ * (C * (n:ℝ) ^ 2 * Real.sqrt 2 ^ (n - j)) := by
          apply mul_le_mul_of_nonneg_left _ (norm_nonneg _)
          exact mul_le_mul_of_nonneg_right (mul_le_mul_of_nonneg_left hnj2 hC) (by positivity)
      _ = C * (n:ℝ) ^ 2 * R * (‖c j‖ * s ^ j) := by rw [hsp]; ring
  -- the full sum over the zeros below 2^n
  have hfull : ∑ ρ ∈ F, g ρ = ∑ j ∈ range (N + 1), c j * (ladder (n - j) + Z (n - j))
      - ∑ j ∈ range (N + 1), c j * ladder (n - j) := by
    rw [← Finset.sum_sub_distrib]
    simp_rw [mul_add, add_sub_cancel_left]
    simp only [hZdef, Finset.mul_sum]
    rw [Finset.sum_comm]
    refine Finset.sum_congr rfl fun ρ _ => ?_
    have hz0 : (2:ℂ) ^ (ρ : ℂ) ≠ 0 := by
      rw [Ne, ← norm_eq_zero, norm_two_cpow]
      positivity
    have hm := filter_mode q hdeg hNn.le hz0
    calc g ρ = wz ρ * (((2:ℂ) ^ (ρ : ℂ)) ^ n * (q.eval (((2:ℂ) ^ (ρ : ℂ))⁻¹)) ^ m) := by
          simp only [hgdef, wz]
          ring
      _ = wz ρ * ∑ j ∈ range (N + 1), (q ^ m).coeff j * ((2:ℂ) ^ (ρ : ℂ)) ^ (n - j) := by
          rw [hm]
      _ = _ := by
          rw [Finset.mul_sum]
          refine Finset.sum_congr rfl fun j _ => ?_
          simp only [hcdef]
          ring
  have hEb : ‖∑ j ∈ range (N + 1), c j * (ladder (n - j) + Z (n - j))‖
      ≤ Kf * (n:ℝ) ^ 2 * R * W := by
    rw [hWr, Finset.mul_sum]
    exact (norm_sum_le _ _).trans (Finset.sum_le_sum he)
  have hTb : ‖∑ j ∈ range (N + 1), c j * ladder (n - j)‖ ≤ C * (n:ℝ) ^ 2 * R * W := by
    rw [hWr, Finset.mul_sum]
    exact (norm_sum_le _ _).trans (Finset.sum_le_sum hT)
  -- the zeros with real part below σ
  have hlow : ∀ ρ ∈ F.filter (fun ρ : NontrivialZeros => ¬ σ ≤ (ρ : ℂ).re),
      ‖g ρ‖ ≤ (FiniteOffLinePi.ordR ρ * ‖(ρ : ℂ)‖⁻¹) * (P * W) := by
    intro ρ hρ
    have hre : (ρ : ℂ).re < σ := not_le.mp (Finset.mem_filter.mp hρ).2
    have hz0 : (2:ℂ) ^ (ρ : ℂ) ≠ 0 := by
      rw [Ne, ← norm_eq_zero, norm_two_cpow]
      positivity
    have hzn := norm_two_cpow (ρ : ℂ)
    set M := max ‖(2:ℂ) ^ (ρ : ℂ)‖ (Real.sqrt 2) with hMdef
    have hMσ : M ≤ (2:ℝ) ^ σ := max_le
      (by rw [hzn]; exact Real.rpow_le_rpow_of_exponent_le (by norm_num) hre.le) h2σ
    have hM0 : 0 < M := lt_of_lt_of_le hsqpos (le_max_right _ _)
    have hMs : M⁻¹ ≤ s := inv_anti₀ hsqpos (le_max_right _ _)
    have key : ∀ j ∈ range (N + 1), ‖(2:ℂ) ^ (ρ : ℂ)‖ ^ (n - j) ≤ P * s ^ j := by
      intro j hj
      have hj' := Finset.mem_range.mp hj
      calc ‖(2:ℂ) ^ (ρ : ℂ)‖ ^ (n - j) ≤ M ^ (n - j) :=
            pow_le_pow_left₀ (norm_nonneg _) (le_max_left _ _) _
        _ = M ^ n * (M⁻¹) ^ j := by
            rw [pow_sub₀ M hM0.ne' (by omega), inv_pow]
        _ ≤ P * s ^ j := by
            rw [hP']
            exact mul_le_mul (pow_le_pow_left₀ hM0.le hMσ n)
              (pow_le_pow_left₀ (by positivity) hMs j) (by positivity) (by positivity)
    have hid : g ρ = wz ρ * ∑ j ∈ range (N + 1), c j * ((2:ℂ) ^ (ρ : ℂ)) ^ (n - j) := by
      rw [filter_mode q hdeg hNn.le hz0]
      simp only [hgdef, wz]
      ring
    have hw : ‖wz ρ‖ = FiniteOffLinePi.ordR ρ * ‖(ρ : ℂ)‖⁻¹ := by
      unfold wz FiniteOffLinePi.ordR
      rw [norm_div, Complex.norm_intCast, abs_of_nonneg (order_nonneg ρ), div_eq_mul_inv]
    rw [hid, norm_mul, hw]
    apply mul_le_mul_of_nonneg_left _
      (mul_nonneg (FiniteOffLinePi.ordR_nonneg ρ) (by positivity))
    calc ‖∑ j ∈ range (N + 1), c j * ((2:ℂ) ^ (ρ : ℂ)) ^ (n - j)‖
        ≤ ∑ j ∈ range (N + 1), ‖c j‖ * ‖(2:ℂ) ^ (ρ : ℂ)‖ ^ (n - j) :=
          (norm_sum_le _ _).trans (le_of_eq (Finset.sum_congr rfl fun j _ => by
            rw [norm_mul, norm_pow]))
      _ ≤ ∑ j ∈ range (N + 1), ‖c j‖ * (P * s ^ j) :=
          Finset.sum_le_sum fun j hj => mul_le_mul_of_nonneg_left (key j hj) (norm_nonneg _)
      _ = P * W := by
          rw [hWr, Finset.mul_sum]
          refine Finset.sum_congr rfl fun j _ => ?_
          ring
  have hzinv : zinv ((2:ℝ) ^ n) ≤ Mlow * 39000 * (n:ℝ) ^ 2 := by
    have h4 : (4:ℝ) ≤ (2:ℝ) ^ n := by
      calc (4:ℝ) = 2 ^ 2 := by norm_num
        _ ≤ 2 ^ n := pow_le_pow_right₀ (by norm_num) hn
    have h := zinv_le_log h4
    rw [Real.log_pow] at h
    have hl2 : Real.log 2 < 1 := by linarith [Real.log_two_lt_d9]
    have hl0 : 0 < Real.log 2 := Real.log_pos (by norm_num)
    have hsq : ((n:ℝ) * Real.log 2) ^ 2 ≤ (n:ℝ) ^ 2 :=
      pow_le_pow_left₀ (by positivity) (by nlinarith) 2
    have hM := two_le_Mlow
    calc zinv ((2:ℝ) ^ n) ≤ Mlow * 39000 * ((n:ℝ) * Real.log 2) ^ 2 := by exact_mod_cast h
      _ ≤ Mlow * 39000 * (n:ℝ) ^ 2 := mul_le_mul_of_nonneg_left hsq (by positivity)
  have hLb : ‖∑ ρ ∈ F.filter (fun ρ : NontrivialZeros => ¬ σ ≤ (ρ : ℂ).re), g ρ‖
      ≤ Mlow * 39000 * (n:ℝ) ^ 2 * (P * W) := by
    have hsub : ∑ ρ ∈ F.filter (fun ρ : NontrivialZeros => ¬ σ ≤ (ρ : ℂ).re),
        FiniteOffLinePi.ordR ρ * ‖(ρ : ℂ)‖⁻¹ ≤ zinv ((2:ℝ) ^ n) :=
      Finset.sum_le_sum_of_subset_of_nonneg (Finset.filter_subset _ _)
        (fun ρ _ _ => mul_nonneg (FiniteOffLinePi.ordR_nonneg ρ) (by positivity))
    have hPW : 0 ≤ P * W := mul_nonneg (by positivity) hW0
    calc _ ≤ ∑ ρ ∈ F.filter (fun ρ : NontrivialZeros => ¬ σ ≤ (ρ : ℂ).re), ‖g ρ‖ := norm_sum_le _ _
      _ ≤ ∑ ρ ∈ F.filter (fun ρ : NontrivialZeros => ¬ σ ≤ (ρ : ℂ).re),
            (FiniteOffLinePi.ordR ρ * ‖(ρ : ℂ)‖⁻¹) * (P * W) := Finset.sum_le_sum hlow
      _ = (∑ ρ ∈ F.filter (fun ρ : NontrivialZeros => ¬ σ ≤ (ρ : ℂ).re),
            FiniteOffLinePi.ordR ρ * ‖(ρ : ℂ)‖⁻¹) * (P * W) := by rw [Finset.sum_mul]
      _ ≤ zinv ((2:ℝ) ^ n) * (P * W) := mul_le_mul_of_nonneg_right hsub hPW
      _ ≤ Mlow * 39000 * (n:ℝ) ^ 2 * (P * W) := mul_le_mul_of_nonneg_right hzinv hPW
  -- adding up
  have hsplit := Finset.sum_filter_add_sum_filter_not F (fun ρ : NontrivialZeros => σ ≤ (ρ : ℂ).re) g
  have eF : ∑ ρ ∈ F.filter (fun ρ : NontrivialZeros => σ ≤ (ρ : ℂ).re), g ρ
      = (∑ j ∈ range (N + 1), c j * (ladder (n - j) + Z (n - j))
        - ∑ j ∈ range (N + 1), c j * ladder (n - j))
        - ∑ ρ ∈ F.filter (fun ρ : NontrivialZeros => ¬ σ ≤ (ρ : ℂ).re), g ρ := by
    rw [← hfull, ← hsplit]
    ring
  rw [eF]
  have n1 := norm_sub_le (∑ j ∈ range (N + 1), c j * (ladder (n - j) + Z (n - j))
        - ∑ j ∈ range (N + 1), c j * ladder (n - j))
      (∑ ρ ∈ F.filter (fun ρ : NontrivialZeros => ¬ σ ≤ (ρ : ℂ).re), g ρ)
  have n2 := norm_sub_le (∑ j ∈ range (N + 1), c j * (ladder (n - j) + Z (n - j)))
      (∑ j ∈ range (N + 1), c j * ladder (n - j))
  have hK := Kf_nonneg
  have hRPW : (Kf + C) * (n:ℝ) ^ 2 * W * R ≤ (Kf + C) * (n:ℝ) ^ 2 * W * P :=
    mul_le_mul_of_nonneg_left hRP (by positivity)
  have hA : 0 ≤ Afl C * (n:ℝ) ^ 2 * P := by
    have hM := two_le_Mlow
    unfold Afl
    have : 0 ≤ C + Kf + Mlow * 39000 := by linarith
    positivity
  have hfin : Afl C * (n:ℝ) ^ 2 * P * W ≤ Afl C * (n:ℝ) ^ 2 * P * Wn q ^ m :=
    mul_le_mul_of_nonneg_left hWq hA
  have e1 : Afl C * (n:ℝ) ^ 2 * P * W
      = (Kf + C) * (n:ℝ) ^ 2 * W * P + Mlow * 39000 * (n:ℝ) ^ 2 * (P * W) := by
    unfold Afl
    ring
  have e2 : Kf * (n:ℝ) ^ 2 * R * W + C * (n:ℝ) ^ 2 * R * W = (Kf + C) * (n:ℝ) ^ 2 * W * R := by
    ring
  linarith

/-- **Block S1: the filtered modes of the zeros with real part at least `σ`.**
Let the ladder be of square-root size, `|ψ(2^k) − 2^k| ≤ C·k²·√2^k` for `k ≥ 1`,
and let `σ > 1/2`. There is one constant `A` (it is `Afl C`, and depends on `C`
alone) such that for every polynomial `q` and every `n ≥ 2`, `m` with
`m·deg q < n`, the sum over the zeros below `2^n` with real part at least `σ` of
`m(ρ)/ρ·q(2^(−ρ))^m·(2^ρ)^n` has size at most `A·n⁴·2^(σn)·‖q‖_W^m`. The sharp
form with `n²` is `filtered_modes_small_sq`. -/
theorem filtered_modes_small {C : ℝ}
    (hH : ∀ k : ℕ, 1 ≤ k → ‖(Chebyshev.psi ((2:ℝ)^k) : ℂ) - (((2:ℝ)^k : ℝ) : ℂ)‖
      ≤ C * (k:ℝ)^2 * Real.sqrt 2 ^ k)
    {σ : ℝ} (hσ : 1/2 < σ) :
    ∃ A : ℝ, ∀ (q : Polynomial ℂ) (n m : ℕ), 2 ≤ n → m * q.natDegree < n →
      ‖∑ ρ ∈ (FiniteOffLine.ZF ((2:ℝ)^n)).filter (fun ρ : NontrivialZeros => σ ≤ (ρ : ℂ).re),
          ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) / (ρ : ℂ)
            * (q.eval (((2:ℂ) ^ (ρ : ℂ))⁻¹)) ^ m * ((2:ℂ) ^ (ρ : ℂ)) ^ n‖
        ≤ A * (n:ℝ)^4 * (2:ℝ)^(σ * n) * Wn q ^ m := by
  refine ⟨Afl C, fun q n m hn hmn => ?_⟩
  have h := filtered_modes_small_sq hH hσ.le q hn hmn
  have hC : 0 ≤ C := by
    have h1 := (norm_nonneg _).trans (hH 1 le_rfl)
    have h' : 0 ≤ C * Real.sqrt 2 := by simpa using h1
    have : 0 < Real.sqrt 2 := by positivity
    nlinarith
  have hM := two_le_Mlow
  have hK := Kf_nonneg
  have hA : 0 ≤ Afl C := by unfold Afl; linarith
  have hn1 : (1:ℝ) ≤ (n:ℝ) := by exact_mod_cast (by omega : 1 ≤ n)
  have h24 : (n:ℝ) ^ 2 ≤ (n:ℝ) ^ 4 := pow_le_pow_right₀ hn1 (by norm_num)
  have hR : 0 ≤ Afl C * (2:ℝ) ^ (σ * n) * Wn q ^ m := by
    have := Wn_nonneg q
    positivity
  have e1 : Afl C * (n:ℝ) ^ 2 * (2:ℝ) ^ (σ * n) * Wn q ^ m
      = (Afl C * (2:ℝ) ^ (σ * n) * Wn q ^ m) * (n:ℝ) ^ 2 := by ring
  have e2 : Afl C * (n:ℝ) ^ 4 * (2:ℝ) ^ (σ * n) * Wn q ^ m
      = (Afl C * (2:ℝ) ^ (σ * n) * Wn q ^ m) * (n:ℝ) ^ 4 := by ring
  rw [e2]
  rw [e1] at h
  exact h.trans (mul_le_mul_of_nonneg_left h24 hR)

/-- info: 'FilterLadder.filtered_modes_small_sq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms filtered_modes_small_sq

/-- info: 'FilterLadder.filtered_modes_small' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms filtered_modes_small

end

end FilterLadder
