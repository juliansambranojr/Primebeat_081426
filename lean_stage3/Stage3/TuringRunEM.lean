/-
TuringRunEM — block S14 of `lean_stage3/design/stencil.md`, Turing's point run: ζ on the line by
Euler–Maclaurin of any order `K`, and the shared lemmas of the point modules. 2026-11-25.

`ZetaEM.zeta_eq_em` at order `K` on `s = 1/2 + it`, the boundary terms collected as
`N^{−s}·emW K t N`, `emW K t N = Σ_{1 ≤ j < K} P_j(s)·B_{j+1}/(j+1)!·N^{−j}`, `P_j = ∏_{i<j}(s+i)`:

  ζ(s) = Σ_{m ≤ N} m^{−s} + N^{−s}·(N/(s−1) − 1/2 + emW K t N) + R,
  ‖R‖ ≤ (∏_{i<K}‖s+i‖)/K! · bernBound K · N^{1/2−K}/(K − 1/2)      (`zeta_emK`),

and with `StirlingSeries.bernBound_le` (`bernBound K ≤ 4·K!/6^K`) and one `q ≥ ‖s + K − 1‖`,
`‖R‖ ≤ 4 q^K/(6^K N^{K−1} √N (K − 1/2))` (`rem_leK`). At `t = 500` order `4` needs `N ≈ 440` for
`‖R‖ ≤ 0.03`, order `20` needs `N ≈ 104` (`checks/turingrun/gen_turingrun.py`). The Bernoulli
numbers to `B₂₀` are computed from `bernoulli'_def` (`bern'_n`, `bernC_j`).

Also here: `log y` near an integer `n` from `log n` (`log_near_ball`, for `log(t/2)` at rational
`t`), and the sign chain: a list of heights with strict sign changes of `Re Λ` between neighbours
is `Turing.StmtSignData` (`signData_of_chain`), with the sum of `Turing.turingErr'` over it
(`sum_succ_eq`).

| name | content | status |
|---|---|---|
| `bern'_n`, `bernC_j` | `B'_n` for `5 ≤ n ≤ 20`; `B_{j+1}/(j+1)!` for `1 ≤ j ≤ 19` | proved |
| `emBoundary_eq'` | `emBoundary K N s = N^{−s} · emW K t N` | proved |
| `zeta_emK` | Euler–Maclaurin of order `K` with the remainder bound | proved |
| `rem_leK` | the remainder bound with rational data | proved |
| `prodS_succ`, `emW_succ`, `emA_ball`, `ball_rmul`, `zeta_ballK` | the ball steps | proved |
| `log_near_ball` | `|log n − a| ≤ e`, `u = 1 − y/n`, `|u| < 1` ⊢ a ball for `log y` | proved |
| `chainOK`, `signData_of_chain` | the sign chain and its `StmtSignData` | def, proved |

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Stage3.SignDataZeta
import Stage3.StirlingSeriesBern
import Stage3.TuringCert

namespace TuringRun

open Complex SignData ZetaEM

noncomputable section

/-! ## Bernoulli numbers -/

theorem bern'_5 : bernoulli' 5 = 0 := bernoulli'_eq_zero_of_odd ⟨2, rfl⟩ (by norm_num)
theorem bern'_6 : bernoulli' 6 = 1 / 42 := by
  rw [bernoulli'_def]
  simp only [Finset.sum_range_succ, Finset.sum_range_zero, bernoulli'_zero, bernoulli'_one, bernoulli'_two, bernoulli'_three, bernoulli'_four, bern'_5]
  norm_num [Nat.choose_eq_factorial_div_factorial, Nat.factorial]
theorem bern'_7 : bernoulli' 7 = 0 := bernoulli'_eq_zero_of_odd ⟨3, rfl⟩ (by norm_num)
theorem bern'_8 : bernoulli' 8 = -1 / 30 := by
  rw [bernoulli'_def]
  simp only [Finset.sum_range_succ, Finset.sum_range_zero, bernoulli'_zero, bernoulli'_one, bernoulli'_two, bernoulli'_three, bernoulli'_four, bern'_5, bern'_6, bern'_7]
  norm_num [Nat.choose_eq_factorial_div_factorial, Nat.factorial]
theorem bern'_9 : bernoulli' 9 = 0 := bernoulli'_eq_zero_of_odd ⟨4, rfl⟩ (by norm_num)
theorem bern'_10 : bernoulli' 10 = 5 / 66 := by
  rw [bernoulli'_def]
  simp only [Finset.sum_range_succ, Finset.sum_range_zero, bernoulli'_zero, bernoulli'_one, bernoulli'_two, bernoulli'_three, bernoulli'_four, bern'_5, bern'_6, bern'_7, bern'_8, bern'_9]
  norm_num [Nat.choose_eq_factorial_div_factorial, Nat.factorial]
theorem bern'_11 : bernoulli' 11 = 0 := bernoulli'_eq_zero_of_odd ⟨5, rfl⟩ (by norm_num)
theorem bern'_12 : bernoulli' 12 = -691 / 2730 := by
  rw [bernoulli'_def]
  simp only [Finset.sum_range_succ, Finset.sum_range_zero, bernoulli'_zero, bernoulli'_one, bernoulli'_two, bernoulli'_three, bernoulli'_four, bern'_5, bern'_6, bern'_7, bern'_8, bern'_9, bern'_10, bern'_11]
  norm_num [Nat.choose_eq_factorial_div_factorial, Nat.factorial]
theorem bern'_13 : bernoulli' 13 = 0 := bernoulli'_eq_zero_of_odd ⟨6, rfl⟩ (by norm_num)
theorem bern'_14 : bernoulli' 14 = 7 / 6 := by
  rw [bernoulli'_def]
  simp only [Finset.sum_range_succ, Finset.sum_range_zero, bernoulli'_zero, bernoulli'_one, bernoulli'_two, bernoulli'_three, bernoulli'_four, bern'_5, bern'_6, bern'_7, bern'_8, bern'_9, bern'_10, bern'_11, bern'_12, bern'_13]
  norm_num [Nat.choose_eq_factorial_div_factorial, Nat.factorial]
theorem bern'_15 : bernoulli' 15 = 0 := bernoulli'_eq_zero_of_odd ⟨7, rfl⟩ (by norm_num)
theorem bern'_16 : bernoulli' 16 = -3617 / 510 := by
  rw [bernoulli'_def]
  simp only [Finset.sum_range_succ, Finset.sum_range_zero, bernoulli'_zero, bernoulli'_one, bernoulli'_two, bernoulli'_three, bernoulli'_four, bern'_5, bern'_6, bern'_7, bern'_8, bern'_9, bern'_10, bern'_11, bern'_12, bern'_13, bern'_14, bern'_15]
  norm_num [Nat.choose_eq_factorial_div_factorial, Nat.factorial]
theorem bern'_17 : bernoulli' 17 = 0 := bernoulli'_eq_zero_of_odd ⟨8, rfl⟩ (by norm_num)
theorem bern'_18 : bernoulli' 18 = 43867 / 798 := by
  rw [bernoulli'_def]
  simp only [Finset.sum_range_succ, Finset.sum_range_zero, bernoulli'_zero, bernoulli'_one, bernoulli'_two, bernoulli'_three, bernoulli'_four, bern'_5, bern'_6, bern'_7, bern'_8, bern'_9, bern'_10, bern'_11, bern'_12, bern'_13, bern'_14, bern'_15, bern'_16, bern'_17]
  norm_num [Nat.choose_eq_factorial_div_factorial, Nat.factorial]
theorem bern'_19 : bernoulli' 19 = 0 := bernoulli'_eq_zero_of_odd ⟨9, rfl⟩ (by norm_num)
theorem bern'_20 : bernoulli' 20 = -174611 / 330 := by
  rw [bernoulli'_def]
  simp only [Finset.sum_range_succ, Finset.sum_range_zero, bernoulli'_zero, bernoulli'_one, bernoulli'_two, bernoulli'_three, bernoulli'_four, bern'_5, bern'_6, bern'_7, bern'_8, bern'_9, bern'_10, bern'_11, bern'_12, bern'_13, bern'_14, bern'_15, bern'_16, bern'_17, bern'_18, bern'_19]
  norm_num [Nat.choose_eq_factorial_div_factorial, Nat.factorial]

/-- `B_{j+1}/(j+1)!`, the coefficient of the `j`-th boundary term. -/
def bernC (j : ℕ) : ℝ := (bernoulli (j + 1) : ℝ) / ((j + 1).factorial : ℝ)

theorem bernC_1 : bernC 1 = 1 / 12 := by
  unfold bernC
  rw [bernoulli_eq_bernoulli'_of_ne_one (by norm_num), bernoulli'_two]
  norm_num [Nat.factorial]

theorem bernC_2 : bernC 2 = 0 := by
  unfold bernC
  rw [bernoulli_eq_bernoulli'_of_ne_one (by norm_num), bernoulli'_three]
  norm_num [Nat.factorial]

theorem bernC_3 : bernC 3 = -1 / 720 := by
  unfold bernC
  rw [bernoulli_eq_bernoulli'_of_ne_one (by norm_num), bernoulli'_four]
  norm_num [Nat.factorial]

theorem bernC_4 : bernC 4 = 0 := by
  unfold bernC
  rw [bernoulli_eq_bernoulli'_of_ne_one (by norm_num), bern'_5]
  norm_num [Nat.factorial]

theorem bernC_5 : bernC 5 = 1 / 30240 := by
  unfold bernC
  rw [bernoulli_eq_bernoulli'_of_ne_one (by norm_num), bern'_6]
  norm_num [Nat.factorial]

theorem bernC_6 : bernC 6 = 0 := by
  unfold bernC
  rw [bernoulli_eq_bernoulli'_of_ne_one (by norm_num), bern'_7]
  norm_num [Nat.factorial]

theorem bernC_7 : bernC 7 = -1 / 1209600 := by
  unfold bernC
  rw [bernoulli_eq_bernoulli'_of_ne_one (by norm_num), bern'_8]
  norm_num [Nat.factorial]

theorem bernC_8 : bernC 8 = 0 := by
  unfold bernC
  rw [bernoulli_eq_bernoulli'_of_ne_one (by norm_num), bern'_9]
  norm_num [Nat.factorial]

theorem bernC_9 : bernC 9 = 1 / 47900160 := by
  unfold bernC
  rw [bernoulli_eq_bernoulli'_of_ne_one (by norm_num), bern'_10]
  norm_num [Nat.factorial]

theorem bernC_10 : bernC 10 = 0 := by
  unfold bernC
  rw [bernoulli_eq_bernoulli'_of_ne_one (by norm_num), bern'_11]
  norm_num [Nat.factorial]

theorem bernC_11 : bernC 11 = -691 / 1307674368000 := by
  unfold bernC
  rw [bernoulli_eq_bernoulli'_of_ne_one (by norm_num), bern'_12]
  norm_num [Nat.factorial]

theorem bernC_12 : bernC 12 = 0 := by
  unfold bernC
  rw [bernoulli_eq_bernoulli'_of_ne_one (by norm_num), bern'_13]
  norm_num [Nat.factorial]

theorem bernC_13 : bernC 13 = 1 / 74724249600 := by
  unfold bernC
  rw [bernoulli_eq_bernoulli'_of_ne_one (by norm_num), bern'_14]
  norm_num [Nat.factorial]

theorem bernC_14 : bernC 14 = 0 := by
  unfold bernC
  rw [bernoulli_eq_bernoulli'_of_ne_one (by norm_num), bern'_15]
  norm_num [Nat.factorial]

theorem bernC_15 : bernC 15 = -3617 / 10670622842880000 := by
  unfold bernC
  rw [bernoulli_eq_bernoulli'_of_ne_one (by norm_num), bern'_16]
  norm_num [Nat.factorial]

theorem bernC_16 : bernC 16 = 0 := by
  unfold bernC
  rw [bernoulli_eq_bernoulli'_of_ne_one (by norm_num), bern'_17]
  norm_num [Nat.factorial]

theorem bernC_17 : bernC 17 = 43867 / 5109094217170944000 := by
  unfold bernC
  rw [bernoulli_eq_bernoulli'_of_ne_one (by norm_num), bern'_18]
  norm_num [Nat.factorial]

theorem bernC_18 : bernC 18 = 0 := by
  unfold bernC
  rw [bernoulli_eq_bernoulli'_of_ne_one (by norm_num), bern'_19]
  norm_num [Nat.factorial]

theorem bernC_19 : bernC 19 = -174611 / 802857662698291200000 := by
  unfold bernC
  rw [bernoulli_eq_bernoulli'_of_ne_one (by norm_num), bern'_20]
  norm_num [Nat.factorial]

/-! ## Euler–Maclaurin of order `K` -/

/-- `P_j(s) = ∏_{i<j} (s + i)` at `s = 1/2 + it`. -/
def prodS (t : ℝ) (j : ℕ) : ℂ := ∏ i ∈ Finset.range j, (lineS t + i)

/-- The boundary sum `Σ_{1 ≤ j < K} P_j(s)·B_{j+1}/(j+1)!·N^{−j}`. -/
def emW (K : ℕ) (t : ℝ) (N : ℕ) : ℂ :=
  ∑ j ∈ Finset.Ico 1 K, prodS t j * ((bernC j / (N : ℝ) ^ j : ℝ) : ℂ)

/-- The first two boundary terms, `N/(s − 1) − 1/2`. -/
def emA (t : ℝ) (N : ℕ) : ℂ := (N : ℂ) / (lineS t - 1) - 1 / 2

theorem emTerm_eq {N : ℕ} (hN : 0 < N) (j : ℕ) (t : ℝ) :
    emTerm j N (lineS t) = (N : ℂ) ^ (-lineS t) * (prodS t j * ((bernC j / (N : ℝ) ^ j : ℝ) : ℂ)) := by
  have hN0 : (N : ℂ) ≠ 0 := by exact_mod_cast hN.ne'
  unfold emTerm prodS bernC
  rw [cpow_neg_add_nat hN, bernoulliFun_eval_zero]
  push_cast
  field_simp

theorem emBoundary_eq' {N : ℕ} (hN : 0 < N) (K : ℕ) (t : ℝ) :
    emBoundary K N (lineS t) = (N : ℂ) ^ (-lineS t) * emW K t N := by
  unfold emBoundary emW
  rw [Finset.mul_sum]
  exact Finset.sum_congr rfl (fun j _ => emTerm_eq hN j t)

/-- **ζ on the line by Euler–Maclaurin of order `K`.** -/
theorem zeta_emK (t : ℝ) {K : ℕ} (hK : 1 ≤ K) {N : ℕ} (hN : 0 < N) :
    ‖riemannZeta (lineS t) - (∑ m ∈ Finset.Icc 1 N, (m : ℂ) ^ (-lineS t)
        + (N : ℂ) ^ (-lineS t) * (emA t N + emW K t N))‖
      ≤ (∏ i ∈ Finset.range K, ‖lineS t + i‖) / K.factorial
        * (bernBound K * ((N : ℝ) ^ (1 - 1 / 2 - (K : ℝ)) / (1 / 2 + (K : ℝ) - 1))) := by
  set s := lineS t with hs
  have hσ : 0 < s.re := by rw [hs, lineS_re]; norm_num
  have hs1 : s ≠ 1 := lineS_ne_one t
  have hN0 : (N : ℂ) ≠ 0 := by exact_mod_cast hN.ne'
  have hz := zeta_eq_em hK hN hσ hs1
  have h1s : (1 : ℂ) - s ≠ 0 := sub_ne_zero.mpr (Ne.symm hs1)
  have hs1' : s - 1 ≠ 0 := sub_ne_zero.mpr hs1
  have hcp : (N : ℂ) ^ (1 - s) = (N : ℂ) * (N : ℂ) ^ (-s) := by
    rw [show (1 : ℂ) - s = 1 + (-s) by ring, Complex.cpow_add _ _ hN0, Complex.cpow_one]
  have heq : riemannZeta s - (∑ m ∈ Finset.Icc 1 N, (m : ℂ) ^ (-s)
      + (N : ℂ) ^ (-s) * (emA t N + emW K t N)) = emRem K N s := by
    rw [hz, emBoundary_eq' hN, hcp]
    unfold emA
    rw [← hs]
    field_simp
    ring
  rw [heq]
  have hk : 1 < s.re + ((K : ℕ) : ℝ) := by
    rw [hs, lineS_re]
    have : (1 : ℝ) ≤ K := by exact_mod_cast hK
    linarith
  have hr := norm_remainder_le K hN hk
  have hre : s.re = 1 / 2 := by rw [hs, lineS_re]
  rw [hre] at hr
  exact hr

theorem rpow_half_sub {N : ℝ} (hN : 0 < N) {K : ℕ} (hK : 1 ≤ K) :
    N ^ (1 - 1 / 2 - (K : ℝ)) = 1 / (N ^ (K - 1) * Real.sqrt N) := by
  have e : (1 - 1 / 2 - (K : ℝ)) = -(((K - 1 : ℕ) : ℝ) + 1 / 2) := by
    rw [Nat.cast_sub hK]; push_cast; ring
  rw [e, Real.rpow_neg hN.le, Real.rpow_add hN, Real.rpow_natCast, Real.sqrt_eq_rpow, one_div, one_div]

/-- **The order-`K` remainder with rational data**: `q ≥ ‖s + K − 1‖`, `lo ≤ √N`. -/
theorem rem_leK (t : ℝ) {K : ℕ} (hK : 2 ≤ K) {N : ℕ} (hN : 0 < N) {q lo Q : ℝ}
    (hq : (1 / 2 + ((K : ℝ) - 1)) ^ 2 + t ^ 2 ≤ q ^ 2) (hq0 : 0 ≤ q) (hlo : 0 < lo)
    (hlo2 : lo ^ 2 ≤ N)
    (hQ : 4 * q ^ K / (6 ^ K * ((N : ℝ) ^ (K - 1) * lo) * ((K : ℝ) - 1 / 2)) ≤ Q) :
    (∏ i ∈ Finset.range K, ‖lineS t + i‖) / K.factorial
        * (bernBound K * ((N : ℝ) ^ (1 - 1 / 2 - (K : ℝ)) / (1 / 2 + (K : ℝ) - 1))) ≤ Q := by
  have hNR : (0 : ℝ) < N := by exact_mod_cast hN
  have hK1 : (2 : ℝ) ≤ K := by exact_mod_cast hK
  have hp : ∏ i ∈ Finset.range K, ‖lineS t + i‖ ≤ q ^ K := by
    calc ∏ i ∈ Finset.range K, ‖lineS t + i‖ ≤ ∏ _i ∈ Finset.range K, q := by
          apply Finset.prod_le_prod (fun i _ => norm_nonneg _)
          intro i hi
          rw [Finset.mem_range] at hi
          rw [lineS_add_nat]
          apply norm_le_of_sq hq0
          have hi1 : (i : ℝ) ≤ (K : ℝ) - 1 := by
            have : (i : ℝ) + 1 ≤ K := by exact_mod_cast hi
            linarith
          have hi0 : (0 : ℝ) ≤ i := Nat.cast_nonneg i
          nlinarith
      _ = q ^ K := by rw [Finset.prod_const, Finset.card_range]
  have hb := StirlingSeries.bernBound_le hK
  have hsq : lo ≤ Real.sqrt N := Real.le_sqrt_of_sq_le hlo2
  have hr : (N : ℝ) ^ (1 - 1 / 2 - (K : ℝ)) ≤ 1 / ((N : ℝ) ^ (K - 1) * lo) := by
    rw [rpow_half_sub hNR (by omega)]
    apply one_div_le_one_div_of_le (by positivity)
    exact mul_le_mul_of_nonneg_left hsq (by positivity)
  have hfac : (0 : ℝ) < K.factorial := by exact_mod_cast Nat.factorial_pos K
  have hden : (0 : ℝ) < 1 / 2 + (K : ℝ) - 1 := by linarith
  have hB0 := bernBound_nonneg K
  have hr0 : 0 ≤ (N : ℝ) ^ (1 - 1 / 2 - (K : ℝ)) := Real.rpow_nonneg hNR.le _
  refine le_trans ?_ hQ
  calc (∏ i ∈ Finset.range K, ‖lineS t + i‖) / K.factorial
        * (bernBound K * ((N : ℝ) ^ (1 - 1 / 2 - (K : ℝ)) / (1 / 2 + (K : ℝ) - 1)))
      ≤ q ^ K / K.factorial * (4 * K.factorial / 6 ^ K
          * (1 / ((N : ℝ) ^ (K - 1) * lo) / (1 / 2 + (K : ℝ) - 1))) := by
        apply mul_le_mul (div_le_div_of_nonneg_right hp hfac.le) _ (by positivity) (by positivity)
        apply mul_le_mul hb _ (by positivity) (by positivity)
        exact div_le_div_of_nonneg_right hr hden.le
    _ = 4 * q ^ K / (6 ^ K * ((N : ℝ) ^ (K - 1) * lo) * ((K : ℝ) - 1 / 2)) := by
        have h6 : (0 : ℝ) < 6 ^ K := by positivity
        have hNl : (0 : ℝ) < (N : ℝ) ^ (K - 1) * lo := by positivity
        have hK2 : (K : ℝ) - 1 / 2 ≠ 0 := by linarith
        rw [show (1 / 2 + (K : ℝ) - 1) = (K : ℝ) - 1 / 2 by ring]
        field_simp

/-! ## The ball steps -/

theorem prodS_zero_ball (t : ℝ) : ‖prodS t 0 - cx 1 0‖ ≤ 0 := by
  have : prodS t 0 = cx 1 0 := by
    unfold prodS; rw [Finset.prod_range_zero]; apply Complex.ext <;> simp [cx]
  rw [this, sub_self, norm_zero]

theorem prodS_succ (t : ℝ) (j : ℕ) : prodS t (j + 1) = prodS t j * cx (1 / 2 + (j : ℝ)) t := by
  unfold prodS
  rw [Finset.prod_range_succ, lineS_add_nat]

theorem emW_one (t : ℝ) (N : ℕ) : ‖emW 1 t N - cx 0 0‖ ≤ 0 := by
  have : emW 1 t N = cx 0 0 := by
    unfold emW; rw [Finset.Ico_self, Finset.sum_empty]; apply Complex.ext <;> simp [cx]
  rw [this, sub_self, norm_zero]

theorem emW_succ {K : ℕ} (hK : 1 ≤ K) (t : ℝ) (N : ℕ) :
    emW (K + 1) t N = emW K t N + prodS t K * ((bernC K / (N : ℝ) ^ K : ℝ) : ℂ) := by
  unfold emW
  rw [Finset.sum_Ico_succ_top hK]

/-- A ball times an exact real `x = c`, rounded to `(e, f)`. -/
theorem ball_rmul {z : ℂ} {a b r x c e f R : ℝ} (hz : ‖z - cx a b‖ ≤ r) (hx : x = c)
    (hR : |a * c - e| + |b * c - f| + |c| * r ≤ R) : ‖z * (x : ℂ) - cx e f‖ ≤ R := by
  subst hx
  have h : z * (x : ℂ) - cx e f = (z - cx a b) * (x : ℂ) + cx (a * x - e) (b * x - f) := by
    apply Complex.ext <;> simp [cx] <;> ring
  rw [h]
  have h1 := norm_add_le ((z - cx a b) * (x : ℂ)) (cx (a * x - e) (b * x - f))
  have h2 : ‖(z - cx a b) * (x : ℂ)‖ ≤ |x| * r := by
    rw [norm_mul, Complex.norm_real, Real.norm_eq_abs, mul_comm]
    exact mul_le_mul_of_nonneg_left hz (abs_nonneg _)
  have h3 := norm_cx_le (a * x - e) (b * x - f)
  linarith

theorem emA_ball (t : ℝ) (N : ℕ) {a b : ℝ} (ha : -((N : ℝ) / 2) / (1 / 4 + t ^ 2) - 1 / 2 = a)
    (hb : -((N : ℝ) * t) / (1 / 4 + t ^ 2) = b) : ‖emA t N - cx a b‖ ≤ 0 := by
  have hd : (1 / 4 + t ^ 2) ≠ 0 := by positivity
  have h1 : lineS t - 1 = ((-1 / 2 : ℝ) : ℂ) + (t : ℂ) * I := by simp [lineS]; ring
  have hNC : (N : ℂ) = ((N : ℝ) : ℂ) := by simp
  have : emA t N = cx a b := by
    rw [← ha, ← hb]
    unfold emA
    rw [h1, hNC]
    apply Complex.ext
    · simp [Complex.div_re, Complex.normSq, cx]
      field_simp
      ring
    · simp [Complex.div_im, Complex.normSq, cx]
      field_simp
      ring
  rw [this, sub_self, norm_zero]

/-- A ball for `ζ(1/2 + it)` from the order-`K` main part and the remainder. -/
theorem zeta_ballK (t : ℝ) {K : ℕ} (hK : 1 ≤ K) {N : ℕ} (hN : 0 < N) {a b r Q R : ℝ}
    (hY : ‖(∑ m ∈ Finset.Icc 1 N, (m : ℂ) ^ (-lineS t)
        + (N : ℂ) ^ (-lineS t) * (emA t N + emW K t N)) - cx a b‖ ≤ r)
    (hQ : (∏ i ∈ Finset.range K, ‖lineS t + i‖) / K.factorial
        * (bernBound K * ((N : ℝ) ^ (1 - 1 / 2 - (K : ℝ)) / (1 / 2 + (K : ℝ) - 1))) ≤ Q)
    (hR : r + Q ≤ R) : ‖riemannZeta (lineS t) - cx a b‖ ≤ R := by
  have h1 := zeta_emK t hK hN
  have h2 := norm_sub_le_norm_sub_add_norm_sub (riemannZeta (lineS t))
    (∑ m ∈ Finset.Icc 1 N, (m : ℂ) ^ (-lineS t) + (N : ℂ) ^ (-lineS t) * (emA t N + emW K t N))
    (cx a b)
  linarith

/-! ## Logarithms near an integer -/

/-- `log y` from `log n` and the series of `log(1 − u)`, `u = 1 − y/n`. -/
theorem log_near_ball {y n a e c R u : ℝ} (hn : 0 < n) (hu : u = 1 - y / n) (hu1 : |u| < 1)
    (h : |Real.log n - a| ≤ e) (K : ℕ)
    (hR : e + |a - ∑ i ∈ Finset.range K, u ^ (i + 1) / ((i : ℝ) + 1) - c|
      + |u| ^ (K + 1) / (1 - |u|) ≤ R) :
    |Real.log y - c| ≤ R := by
  have hs := Real.abs_log_sub_add_sum_range_le hu1 K
  have hyn : y / n = 1 - u := by rw [hu]; ring
  have hpos : 0 < 1 - u := by
    have := (abs_lt.mp hu1).2
    linarith
  have hy : 0 < y := by
    have : 0 < y / n := by rw [hyn]; exact hpos
    exact (div_pos_iff_of_pos_right hn).mp this
  have hl : Real.log y = Real.log n + Real.log (1 - u) := by
    rw [← hyn, Real.log_div hy.ne' hn.ne']
    ring
  set S := ∑ i ∈ Finset.range K, u ^ (i + 1) / ((i : ℝ) + 1) with hS
  rw [hl]
  have e1 : Real.log n + Real.log (1 - u) - c
      = (Real.log n - a) + (a - S - c) + (S + Real.log (1 - u)) := by ring
  rw [e1]
  have t1 := abs_add_le ((Real.log n - a) + (a - S - c)) (S + Real.log (1 - u))
  have t2 := abs_add_le (Real.log n - a) (a - S - c)
  linarith

/-! ## The sign chain -/

/-- `Re Λ(1/2 + ix)`. -/
def reL (x : ℝ) : ℝ := (completedRiemannZeta (1 / 2 + x * I)).re

/-- Strictly increasing, with a strict sign change of `Re Λ` between neighbours. -/
def chainOK : List ℝ → Prop
  | a :: b :: l => a < b ∧ reL a * reL b < 0 ∧ chainOK (b :: l)
  | _ => True

theorem chainOK_cons {a b : ℝ} {l : List ℝ} (h1 : a < b) (h2 : reL a * reL b < 0)
    (h3 : chainOK (b :: l)) : chainOK (a :: b :: l) := ⟨h1, h2, h3⟩

theorem chainOK_single (a : ℝ) : chainOK [a] := trivial

theorem chainOK_get : ∀ (l : List ℝ), chainOK l → ∀ (i : ℕ) (h : i + 1 < l.length),
    l[i] < l[i + 1] ∧ reL l[i] * reL l[i + 1] < 0
  | [], _, i, h => by simp at h
  | [_], _, i, h => by simp at h
  | a :: b :: l, hc, 0, _ => ⟨hc.1, hc.2.1⟩
  | a :: b :: l, hc, i + 1, h => by
      have := chainOK_get (b :: l) hc.2.2 i (by simp at h ⊢; omega)
      simpa using this

/-- The chain as a function on `Fin`. -/
def chainFun (L : List ℝ) (a : ℝ) : Fin (L.length + 1) → ℝ :=
  fun i => (a :: L)[i.val]'(by simp; omega)

/-- **A sign chain is sign data.** -/
theorem signData_of_chain (L : List ℝ) (a : ℝ) (h0 : 0 < a) (hc : chainOK (a :: L)) :
    Turing.StmtSignData L.length (chainFun L a) := by
  refine ⟨?_, h0, ?_⟩
  · rw [Fin.strictMono_iff_lt_succ]
    intro i
    exact (chainOK_get (a :: L) hc i.val (by simp)).1
  · intro i
    exact (chainOK_get (a :: L) hc i.val (by simp)).2

theorem chainFun_zero (L : List ℝ) (a : ℝ) : chainFun L a 0 = a := rfl

/-- The sum over the points after the first. -/
theorem sum_succ_eq (L : List ℝ) (a : ℝ) (f : ℝ → ℝ) :
    ∑ j : Fin L.length, f (chainFun L a j.succ) = (L.map f).sum := by
  unfold chainFun
  simp only [Fin.val_succ, List.getElem_cons_succ]
  rw [← List.sum_ofFn]
  congr 1
  apply List.ext_getElem <;> simp

end

/-- info: 'TuringRun.zeta_emK' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms zeta_emK

/-- info: 'TuringRun.rem_leK' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms rem_leK

/-- info: 'TuringRun.log_near_ball' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms log_near_ball

/-- info: 'TuringRun.signData_of_chain' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms signData_of_chain

end TuringRun
