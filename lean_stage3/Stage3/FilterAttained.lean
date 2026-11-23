/-
FilterAttained — block S2 of `lean_stage3/design/stencil.md`, in its corrected
form (the section "After the independent check"). 2026-11-23.

An attained rate under some filter closes the case. Fix a polynomial `q`,
naturals `a`, `b` with `b ≥ 1` and `a·deg q < b`, and `σ > 1/2`. The rate of a
zero under the filter is `ξ(ρ) = (2^ρ)^b·q(2^(−ρ))^a`. Let the ladder of `ψ` be
of square-root size. If some zero with real part at least `σ` attains the
largest `|ξ|` over those zeros, call it `M`, and `M > 2^(σb)·‖q‖_W^a`, then
contradiction. Read block S1 along `n = b·k`, `m = a·k` and divide by `M^k`:
the zeros below height `2^(bk)` give at most `Afl C·(bk)²·(2^(σb)·‖q‖_W^a/M)^k`,
which tends to zero; the zeros above it are the tail of a summable family. So
`Σ' m(ρ)/ρ·(ξ(ρ)/M)^k → 0`. The zeros with `|ξ| < M` fade one by one under a
summable bound, so the zeros with `|ξ| = M` alone tend to zero, a sum of unit
rotations with summable weights. `LadderMean.mean_extract` makes the weight of
the class of the maximiser zero, and every weight `m(ρ)/ρ` has positive real
part. With `q = 1`, `a = 0`, `b = 1` this is the largest real part attained.

  S, xi, ratio             the zeros right of σ, the rate, the rate over M
  xi_pow                   ξ^k = q(2^(−ρ))^(ak)·(2^ρ)^(bk)
  finite_part_le           the zeros below 2^(bk): ≤ Afl C·b²·k²·(threshold/M)^k
  tailT, norm_tailT_le, tendsto_tailT     the zeros above 2^(bk), and they fade
  tsum_split               the full sum is the finite part plus the tail
  tendsto_full             Σ' over S of m(ρ)/ρ·(ξ/M)^k → 0
  filter_attained_false    the attained rate above threshold ⊢ False
  attained_psi             the largest real part attained, ψ at the doublings
                             within C·k²·√2^k ⊢ RiemannHypothesis

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.FilterLadder
import Stage3.ZeroSummable
import Stage3.LadderMean

namespace FilterAttained

open Finset Filter Topology Kadiri FiniteOffLine

noncomputable section

/-- the rate of a zero under the filter -/
def xi (q : Polynomial ℂ) (a b : ℕ) (ρ : Kadiri.NontrivialZeros) : ℂ :=
  ((2:ℂ) ^ (ρ : ℂ)) ^ b * (q.eval (((2:ℂ) ^ (ρ : ℂ))⁻¹)) ^ a

/-- The zeros with real part at least `σ`. -/
def S (σ : ℝ) : Set NontrivialZeros := {ρ | σ ≤ (ρ : ℂ).re}

/-- The rate of a zero divided by a fixed size `M`. -/
def ratio (q : Polynomial ℂ) (a b : ℕ) (M : ℝ) (ρ : NontrivialZeros) : ℂ :=
  xi q a b ρ / (M : ℂ)

/-- The `k`-th power of the rate is the filter `q^(ak)` read on the mode `(2^ρ)^(bk)`. -/
theorem xi_pow (q : Polynomial ℂ) (a b k : ℕ) (ρ : NontrivialZeros) :
    xi q a b ρ ^ k = (q.eval (((2:ℂ) ^ (ρ : ℂ))⁻¹)) ^ (a * k) * ((2:ℂ) ^ (ρ : ℂ)) ^ (b * k) := by
  unfold xi
  rw [mul_pow, ← pow_mul, ← pow_mul, mul_comm]

/-- For `σ > 1/2` the weights `|m(ρ)/ρ|` of the zeros right of `σ`, as a function on
all zeros, are summable. -/
theorem summable_S {σ : ℝ} (hσ : 1 / 2 < σ) :
    Summable ((S σ).indicator fun ρ => ‖LadderMean.coef ρ‖) :=
  summable_subtype_iff_indicator.mp
    (ZeroSummable.summable_norm_coef (S σ) hσ fun _ h => h)

/-- **The zeros below height `2^(bk)`.** Under the hypothesis on the ladder, for
`k ≥ 2` and `M > 0`, the sum over the zeros below `2^(bk)` with real part at least
`σ ≥ 1/2` of `m(ρ)/ρ·(ξ(ρ)/M)^k` is at most `Afl C·b²·k²·(2^(σb)·‖q‖_W^a/M)^k`. -/
theorem finite_part_le {C : ℝ}
    (hH : ∀ k : ℕ, 1 ≤ k → ‖(Chebyshev.psi ((2:ℝ)^k) : ℂ) - (((2:ℝ)^k : ℝ) : ℂ)‖
      ≤ C * (k:ℝ)^2 * Real.sqrt 2 ^ k)
    (q : Polynomial ℂ) {a b : ℕ} (hb : 1 ≤ b) (hab : a * q.natDegree < b)
    {σ : ℝ} (hσ : 1 / 2 ≤ σ) {M : ℝ} (hM : 0 < M) {k : ℕ} (hk : 2 ≤ k) :
    ‖∑ ρ ∈ (ZF ((2:ℝ) ^ (b * k))).filter (fun ρ : NontrivialZeros => σ ≤ (ρ : ℂ).re),
        LadderMean.coef ρ * ratio q a b M ρ ^ k‖
      ≤ FilterLadder.Afl C * (b:ℝ) ^ 2 * (k:ℝ) ^ 2
        * ((2:ℝ) ^ (σ * b) * FilterLadder.Wn q ^ a / M) ^ k := by
  have hn : 2 ≤ b * k := le_trans hk (Nat.le_mul_of_pos_left k hb)
  have hmn : a * k * q.natDegree < b * k := by
    have e : a * k * q.natDegree = a * q.natDegree * k := by ring
    rw [e]
    exact Nat.mul_lt_mul_of_pos_right hab (by omega)
  have h := FilterLadder.filtered_modes_small_sq hH hσ q hn hmn
  have hMk : ((M : ℂ)) ^ k ≠ 0 := pow_ne_zero _ (by exact_mod_cast hM.ne')
  have e : ∑ ρ ∈ (ZF ((2:ℝ) ^ (b * k))).filter (fun ρ : NontrivialZeros => σ ≤ (ρ : ℂ).re),
        LadderMean.coef ρ * ratio q a b M ρ ^ k
      = (∑ ρ ∈ (ZF ((2:ℝ) ^ (b * k))).filter (fun ρ : NontrivialZeros => σ ≤ (ρ : ℂ).re),
          ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) / (ρ : ℂ)
            * (q.eval (((2:ℂ) ^ (ρ : ℂ))⁻¹)) ^ (a * k) * ((2:ℂ) ^ (ρ : ℂ)) ^ (b * k))
        / (M : ℂ) ^ k := by
    rw [Finset.sum_div]
    refine Finset.sum_congr rfl fun ρ _ => ?_
    unfold ratio
    rw [div_pow, xi_pow, LadderMean.coef]
    ring
  rw [e, norm_div, norm_pow, Complex.norm_real, Real.norm_of_nonneg hM.le]
  have hMk' : (0:ℝ) < M ^ k := pow_pos hM k
  rw [div_le_iff₀ hMk']
  refine h.trans (le_of_eq ?_)
  have e2 : (2:ℝ) ^ (σ * ((b * k : ℕ) : ℝ)) = ((2:ℝ) ^ (σ * b)) ^ k := by
    rw [← Real.rpow_mul_natCast (by norm_num)]
    push_cast
    ring_nf
  rw [e2, pow_mul, div_pow, mul_pow]
  push_cast
  field_simp
  try ring

/-- One zero's term at row `k`, kept only when it is right of `σ` and above height `2^(bk)`. -/
def tailT (q : Polynomial ℂ) (a b : ℕ) (σ M : ℝ) (k : ℕ) (ρ : NontrivialZeros) : ℂ :=
  if ρ ∈ ZF ((2:ℝ) ^ (b * k)) then 0
  else (S σ).indicator (fun ρ => LadderMean.coef ρ * ratio q a b M ρ ^ k) ρ

/-- If the rate over `M` has size at most one right of `σ`, the part of a term above
height `2^(bk)` is at most the weight `|m(ρ)/ρ|` of the zero, kept right of `σ`. -/
theorem norm_tailT_le (q : Polynomial ℂ) (a b : ℕ) {σ M : ℝ}
    (hle : ∀ ρ ∈ S σ, ‖ratio q a b M ρ‖ ≤ 1) (k : ℕ) (ρ : NontrivialZeros) :
    ‖tailT q a b σ M k ρ‖ ≤ (S σ).indicator (fun ρ => ‖LadderMean.coef ρ‖) ρ := by
  unfold tailT
  split_ifs with h
  · rw [norm_zero]
    exact Set.indicator_nonneg (fun _ _ => norm_nonneg _) _
  · by_cases hρ : ρ ∈ S σ
    · rw [Set.indicator_of_mem hρ, Set.indicator_of_mem hρ, norm_mul, norm_pow]
      exact mul_le_of_le_one_right (norm_nonneg _) (pow_le_one₀ (norm_nonneg _) (hle ρ hρ))
    · rw [Set.indicator_of_notMem hρ, Set.indicator_of_notMem hρ, norm_zero]

/-- **The parts above height `2^(bk)` fade.** For `b ≥ 1`, `σ > 1/2` and the rate over
`M` of size at most one right of `σ`, the sum of the parts above `2^(bk)` tends to zero. -/
theorem tendsto_tailT (q : Polynomial ℂ) (a : ℕ) {b : ℕ} (hb : 1 ≤ b) {σ M : ℝ}
    (hσ : 1 / 2 < σ) (hle : ∀ ρ ∈ S σ, ‖ratio q a b M ρ‖ ≤ 1) :
    Tendsto (fun k : ℕ => ∑' ρ, tailT q a b σ M k ρ) atTop (𝓝 0) := by
  have h := tendsto_tsum_of_dominated_convergence (𝓕 := atTop)
    (f := fun k ρ => tailT q a b σ M k ρ)
    (g := fun _ => (0:ℂ)) (summable_S hσ) (fun ρ => ?_)
    (Eventually.of_forall fun k ρ => norm_tailT_le q a b hle k ρ)
  · rw [tsum_zero] at h
    exact h
  have hev : ∀ᶠ k : ℕ in atTop, ρ ∈ ZF ((2:ℝ) ^ (b * k)) := by
    have := (tendsto_pow_atTop_atTop_of_one_lt (by norm_num : (1:ℝ) < 2)).eventually_gt_atTop
      |(ρ : ℂ).im|
    filter_upwards [this] with k hk
    rw [mem_ZF]
    exact lt_of_lt_of_le hk (pow_le_pow_right₀ (by norm_num) (Nat.le_mul_of_pos_left k hb))
  refine tendsto_const_nhds.congr' ?_
  filter_upwards [hev] with k hk
  unfold tailT
  rw [if_pos hk]

/-- **The sum right of `σ` splits at height `2^(bk)`**: it is the finite sum over the
zeros below `2^(bk)` plus the sum of the parts above. -/
theorem tsum_split (q : Polynomial ℂ) (a b : ℕ) {σ M : ℝ} (hσ : 1 / 2 < σ)
    (hle : ∀ ρ ∈ S σ, ‖ratio q a b M ρ‖ ≤ 1) (k : ℕ) :
    ∑' ρ, (S σ).indicator (fun ρ => LadderMean.coef ρ * ratio q a b M ρ ^ k) ρ
      = ∑ ρ ∈ (ZF ((2:ℝ) ^ (b * k))).filter (fun ρ : NontrivialZeros => σ ≤ (ρ : ℂ).re),
          LadderMean.coef ρ * ratio q a b M ρ ^ k
        + ∑' ρ, tailT q a b σ M k ρ := by
  classical
  set f := fun ρ => LadderMean.coef ρ * ratio q a b M ρ ^ k with hf
  have hbs : Summable (tailT q a b σ M k) :=
    Summable.of_norm_bounded (summable_S hσ) (norm_tailT_le q a b hle k)
  have ha : Summable fun ρ =>
      if ρ ∈ ZF ((2:ℝ) ^ (b * k)) then (S σ).indicator f ρ else 0 :=
    summable_of_ne_finset_zero (s := ZF ((2:ℝ) ^ (b * k))) fun ρ hρ => if_neg hρ
  have e1 : ∑' ρ, (S σ).indicator f ρ
      = ∑' ρ, ((if ρ ∈ ZF ((2:ℝ) ^ (b * k)) then (S σ).indicator f ρ else 0)
        + tailT q a b σ M k ρ) := by
    refine tsum_congr fun ρ => ?_
    unfold tailT
    split_ifs <;> simp [hf]
  have hfin : ∑ ρ ∈ ZF ((2:ℝ) ^ (b * k)),
      (if ρ ∈ ZF ((2:ℝ) ^ (b * k)) then (S σ).indicator f ρ else 0)
      = ∑ ρ ∈ (ZF ((2:ℝ) ^ (b * k))).filter (fun ρ : NontrivialZeros => σ ≤ (ρ : ℂ).re),
          f ρ := by
    rw [Finset.sum_filter]
    refine Finset.sum_congr rfl fun ρ hρ => ?_
    rw [if_pos hρ]
    by_cases h : σ ≤ (ρ : ℂ).re
    · rw [Set.indicator_of_mem (show ρ ∈ S σ from h), if_pos h]
    · rw [Set.indicator_of_notMem (show ρ ∉ S σ from h), if_neg h]
  rw [e1, ha.tsum_add hbs,
    tsum_eq_sum (s := ZF ((2:ℝ) ^ (b * k))) (fun ρ hρ => if_neg hρ), hfin]

/-- **The normalized sum right of `σ` tends to zero.** Under the hypothesis on the
ladder, with `b ≥ 1`, `a·deg q < b`, `σ > 1/2`, the rate over `M` of size at most one
right of `σ`, and `M` above the threshold `2^(σb)·‖q‖_W^a`, the sum over the zeros
right of `σ` of `m(ρ)/ρ·(ξ(ρ)/M)^k` tends to zero. -/
theorem tendsto_full {C : ℝ}
    (hH : ∀ k : ℕ, 1 ≤ k → ‖(Chebyshev.psi ((2:ℝ)^k) : ℂ) - (((2:ℝ)^k : ℝ) : ℂ)‖
      ≤ C * (k:ℝ)^2 * Real.sqrt 2 ^ k)
    (q : Polynomial ℂ) {a b : ℕ} (hb : 1 ≤ b) (hab : a * q.natDegree < b)
    {σ : ℝ} (hσ : 1 / 2 < σ) {M : ℝ}
    (hle : ∀ ρ ∈ S σ, ‖ratio q a b M ρ‖ ≤ 1)
    (hthr : (2:ℝ) ^ (σ * b) * FilterLadder.Wn q ^ a < M) :
    Tendsto (fun k : ℕ =>
      ∑' ρ, (S σ).indicator (fun ρ => LadderMean.coef ρ * ratio q a b M ρ ^ k) ρ)
      atTop (𝓝 0) := by
  have hT0 : 0 ≤ (2:ℝ) ^ (σ * b) * FilterLadder.Wn q ^ a := by
    have := FilterLadder.Wn_nonneg q
    positivity
  have hM : 0 < M := lt_of_le_of_lt hT0 hthr
  set t := (2:ℝ) ^ (σ * b) * FilterLadder.Wn q ^ a / M with ht
  have ht0 : 0 ≤ t := div_nonneg hT0 hM.le
  have ht1 : |t| < 1 := by
    rw [abs_of_nonneg ht0, ht, div_lt_one hM]
    exact hthr
  have hbound : Tendsto (fun k : ℕ => FilterLadder.Afl C * (b:ℝ) ^ 2 * (k:ℝ) ^ 2 * t ^ k)
      atTop (𝓝 0) := by
    have h := (tendsto_pow_const_mul_const_pow_of_abs_lt_one 2 ht1).const_mul
      (FilterLadder.Afl C * (b:ℝ) ^ 2)
    rw [mul_zero] at h
    refine h.congr fun k => ?_
    ring
  have hfin : Tendsto (fun k : ℕ =>
      ∑ ρ ∈ (ZF ((2:ℝ) ^ (b * k))).filter (fun ρ : NontrivialZeros => σ ≤ (ρ : ℂ).re),
          LadderMean.coef ρ * ratio q a b M ρ ^ k) atTop (𝓝 0) := by
    refine squeeze_zero_norm' ?_ hbound
    filter_upwards [eventually_ge_atTop 2] with k hk
    exact finite_part_le hH q hb hab hσ.le hM hk
  have h := hfin.add (tendsto_tailT q a hb hσ hle)
  rw [add_zero] at h
  exact h.congr fun k => (tsum_split q a b hσ hle k).symm

/-- **An attained rate above the threshold under some filter is impossible.** Let the
ladder of `ψ` be of square-root size, `|ψ(2^k) − 2^k| ≤ C·k²·√2^k` for `k ≥ 1`. Fix a
polynomial `q`, naturals `a`, `b` with `b ≥ 1` and `a·deg q < b`, and `σ > 1/2`. No zero
`ρ₀` with real part at least `σ` can have the largest rate `|ξ|` among the zeros with real
part at least `σ` while that rate exceeds `2^(σb)·‖q‖_W^a`. -/
theorem filter_attained_false {C : ℝ}
    (hH : ∀ k : ℕ, 1 ≤ k → ‖(Chebyshev.psi ((2:ℝ)^k) : ℂ) - (((2:ℝ)^k : ℝ) : ℂ)‖
      ≤ C * (k:ℝ)^2 * Real.sqrt 2 ^ k)
    (q : Polynomial ℂ) {a b : ℕ} (hb : 1 ≤ b) (hab : a * q.natDegree < b)
    {σ : ℝ} (hσ : 1/2 < σ) (ρ₀ : Kadiri.NontrivialZeros) (hρ₀ : σ ≤ (ρ₀ : ℂ).re)
    (hmax : ∀ ρ : Kadiri.NontrivialZeros, σ ≤ (ρ : ℂ).re → ‖xi q a b ρ‖ ≤ ‖xi q a b ρ₀‖)
    (hthr : (2:ℝ) ^ (σ * b) * FilterLadder.Wn q ^ a < ‖xi q a b ρ₀‖) : False := by
  classical
  set M := ‖xi q a b ρ₀‖ with hMdef
  have hT0 : 0 ≤ (2:ℝ) ^ (σ * b) * FilterLadder.Wn q ^ a := by
    have := FilterLadder.Wn_nonneg q
    positivity
  have hM : 0 < M := lt_of_le_of_lt hT0 hthr
  have hnr : ∀ ρ, ‖ratio q a b M ρ‖ = ‖xi q a b ρ‖ / M := fun ρ => by
    unfold ratio
    rw [norm_div, Complex.norm_real, Real.norm_of_nonneg hM.le]
  have hle : ∀ ρ ∈ S σ, ‖ratio q a b M ρ‖ ≤ 1 := fun ρ hρ => by
    rw [hnr, div_le_one hM]
    exact hmax ρ hρ
  have hF := tendsto_full hH q hb hab hσ hle hthr
  -- the class of the largest rate and the rest
  set Cw : NontrivialZeros → ℂ := fun ρ =>
    if ρ ∈ S σ ∧ ‖xi q a b ρ‖ = M then LadderMean.coef ρ else 0 with hCw
  set w : NontrivialZeros → ℂ := fun ρ =>
    if ‖xi q a b ρ‖ = M then ratio q a b M ρ else 1 with hwdef
  set L : ℕ → NontrivialZeros → ℂ := fun k ρ =>
    if ρ ∈ S σ ∧ ‖xi q a b ρ‖ < M then LadderMean.coef ρ * ratio q a b M ρ ^ k else 0
    with hLdef
  have hw : ∀ ρ, ‖w ρ‖ = 1 := fun ρ => by
    simp only [hwdef]
    split_ifs with hE
    · rw [hnr, hE, div_self hM.ne']
    · exact norm_one
  have hsplit : ∀ k ρ, (S σ).indicator (fun ρ => LadderMean.coef ρ * ratio q a b M ρ ^ k) ρ
      = Cw ρ * w ρ ^ k + L k ρ := fun k ρ => by
    simp only [hCw, hwdef, hLdef]
    by_cases hS : ρ ∈ S σ
    · rw [Set.indicator_of_mem hS]
      by_cases hE : ‖xi q a b ρ‖ = M
      · rw [if_pos (show ρ ∈ S σ ∧ ‖xi q a b ρ‖ = M from ⟨hS, hE⟩), if_pos hE,
          if_neg (show ¬ (ρ ∈ S σ ∧ ‖xi q a b ρ‖ < M) from fun h => ne_of_lt h.2 hE), add_zero]
      · have hlt : ‖xi q a b ρ‖ < M := lt_of_le_of_ne (hmax ρ hS) hE
        rw [if_neg (show ¬ (ρ ∈ S σ ∧ ‖xi q a b ρ‖ = M) from fun h => hE h.2),
          if_pos (show ρ ∈ S σ ∧ ‖xi q a b ρ‖ < M from ⟨hS, hlt⟩), zero_mul, zero_add]
    · rw [Set.indicator_of_notMem hS,
        if_neg (show ¬ (ρ ∈ S σ ∧ ‖xi q a b ρ‖ = M) from fun h => hS h.1),
        if_neg (show ¬ (ρ ∈ S σ ∧ ‖xi q a b ρ‖ < M) from fun h => hS h.1), zero_mul, zero_add]
  have hCb : ∀ ρ, ‖Cw ρ‖ ≤ (S σ).indicator (fun ρ => ‖LadderMean.coef ρ‖) ρ := fun ρ => by
    simp only [hCw]
    split_ifs with h
    · rw [Set.indicator_of_mem h.1]
    · rw [norm_zero]
      exact Set.indicator_nonneg (fun _ _ => norm_nonneg _) _
  have hLb : ∀ k ρ, ‖L k ρ‖ ≤ (S σ).indicator (fun ρ => ‖LadderMean.coef ρ‖) ρ := fun k ρ => by
    simp only [hLdef]
    split_ifs with h
    · rw [Set.indicator_of_mem h.1, norm_mul, norm_pow]
      exact mul_le_of_le_one_right (norm_nonneg _) (pow_le_one₀ (norm_nonneg _) (hle ρ h.1))
    · rw [norm_zero]
      exact Set.indicator_nonneg (fun _ _ => norm_nonneg _) _
  have hCs : Summable fun ρ => ‖Cw ρ‖ :=
    Summable.of_nonneg_of_le (fun ρ => norm_nonneg _) hCb (summable_S hσ)
  have hCws : ∀ k, Summable fun ρ => Cw ρ * w ρ ^ k := fun k =>
    Summable.of_norm_bounded hCs (fun ρ => by rw [norm_mul, norm_pow, hw ρ, one_pow, mul_one])
  have hLs : ∀ k, Summable (L k) := fun k =>
    Summable.of_norm_bounded (summable_S hσ) (hLb k)
  -- the zeros with a smaller rate fade
  have hLt : Tendsto (fun k : ℕ => ∑' ρ, L k ρ) atTop (𝓝 0) := by
    have h := tendsto_tsum_of_dominated_convergence (𝓕 := atTop)
      (f := fun k ρ => L k ρ) (g := fun _ => (0:ℂ)) (summable_S hσ) (fun ρ => ?_)
      (Eventually.of_forall fun k ρ => hLb k ρ)
    · rw [tsum_zero] at h
      exact h
    simp only [hLdef]
    by_cases h : ρ ∈ S σ ∧ ‖xi q a b ρ‖ < M
    · simp only [if_pos h]
      have hr : ‖ratio q a b M ρ‖ < 1 := by
        rw [hnr, div_lt_one hM]
        exact h.2
      have h0 := (tendsto_pow_atTop_nhds_zero_of_norm_lt_one hr).const_mul (LadderMean.coef ρ)
      rw [mul_zero] at h0
      exact h0
    · simp only [if_neg h]
      exact tendsto_const_nhds
  have hG : Tendsto (fun k : ℕ => ∑' ρ, Cw ρ * w ρ ^ k) atTop (𝓝 0) := by
    have h := hF.sub hLt
    rw [sub_zero] at h
    refine h.congr fun k => ?_
    rw [tsum_congr (hsplit k), (hCws k).tsum_add (hLs k), add_sub_cancel_right]
  -- the class of ρ₀ has weight zero, against positive real parts
  have hext := LadderMean.mean_extract w Cw hw hCs ρ₀ hG
  have hs : Summable fun ρ => (if w ρ = w ρ₀ then Cw ρ else 0) :=
    Summable.of_norm_bounded hCs (fun ρ => by
      split_ifs
      · exact le_rfl
      · rw [norm_zero]
        exact norm_nonneg _)
  have hre := Complex.re_tsum hs
  rw [hext, Complex.zero_re] at hre
  have hnn : ∀ ρ, 0 ≤ ((if w ρ = w ρ₀ then Cw ρ else 0) : ℂ).re := fun ρ => by
    simp only [hCw]
    split_ifs
    · exact (AliasClass.re_order_div_pos ρ).le
    · rw [Complex.zero_re]
    · rw [Complex.zero_re]
  have hpos : 0 < ∑' ρ, ((if w ρ = w ρ₀ then Cw ρ else 0) : ℂ).re := by
    refine Summable.tsum_pos (Complex.hasSum_re hs.hasSum).summable hnn ρ₀ ?_
    rw [if_pos rfl]
    simp only [hCw]
    rw [if_pos ⟨hρ₀, rfl⟩]
    exact AliasClass.re_order_div_pos ρ₀
  linarith

/-- info: 'FilterAttained.filter_attained_false' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms filter_attained_false

/-- **The largest real part attained, and the ladder of `ψ` of square-root size: then
the Riemann hypothesis holds.** Let `ρ₀` have the largest real part among the zeros of
ζ. If `|ψ(2^k) − 2^k| ≤ C·k²·√2^k` for every `k ≥ 1`, the Riemann hypothesis holds. It
is `filter_attained_false` with no filter: `q = 1`, `a = 0`, `b = 1`. -/
theorem attained_psi {C : ℝ}
    (hH : ∀ k : ℕ, 1 ≤ k → ‖(Chebyshev.psi ((2:ℝ)^k) : ℂ) - (((2:ℝ)^k : ℝ) : ℂ)‖
      ≤ C * (k:ℝ)^2 * Real.sqrt 2 ^ k)
    (ρ₀ : Kadiri.NontrivialZeros)
    (hmax : ∀ ρ : Kadiri.NontrivialZeros, (ρ : ℂ).re ≤ (ρ₀ : ℂ).re) : RiemannHypothesis := by
  by_cases hhalf : (ρ₀ : ℂ).re ≤ 1 / 2
  · apply LandauWindow.rh_of_zeroFree_half
    intro s hs hz
    have hs1 : s.re < 1 := by
      by_contra h
      exact riemannZeta_ne_zero_of_one_le_re (not_lt.mp h) hz
    let ρ : NontrivialZeros := ⟨s, ⟨⟨by linarith, hs1⟩, Set.mem_univ _, hz⟩⟩
    have h : s.re ≤ (ρ₀ : ℂ).re := hmax ρ
    linarith
  exfalso
  have hΘ : 1 / 2 < (ρ₀ : ℂ).re := lt_of_not_ge hhalf
  have hσ : 1 / 2 < (1 / 2 + (ρ₀ : ℂ).re) / 2 := by linarith
  have hxi : ∀ ρ : NontrivialZeros, ‖xi 1 0 1 ρ‖ = (2:ℝ) ^ (ρ : ℂ).re := fun ρ => by
    unfold xi
    rw [pow_one, pow_zero, mul_one, norm_two_cpow]
  have hW : FilterLadder.Wn (1 : Polynomial ℂ) ^ 0 = 1 := pow_zero _
  refine filter_attained_false hH (1 : Polynomial ℂ) (a := 0) (b := 1) le_rfl
    (by simp) hσ ρ₀ (by linarith) (fun ρ _ => ?_) ?_
  · rw [hxi, hxi]
    exact Real.rpow_le_rpow_of_exponent_le (by norm_num) (hmax ρ)
  · rw [hxi, hW, mul_one, Nat.cast_one, mul_one]
    exact Real.rpow_lt_rpow_of_exponent_lt (by norm_num) (by linarith)

/-- info: 'FilterAttained.attained_psi' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms attained_psi

end

end FilterAttained
