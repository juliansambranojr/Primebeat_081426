/-
ResidueRoute — block S4 of `lean_stage3/design/stencil.md`. 2026-11-24.

The residue route, from the section "After the independent check". Under the
ladder bound `H`, `|ψ(2^k) − 2^k| ≤ C·k²·√2^k` for `k ≥ 1`, fix `1/2 < σ₀ < Θ ≤ 1`
with `Θ` an upper bound for the real parts of the zeros. The tail-rate exponent
`θ' < 1` of `CountReduction.tail_rate` at `σ₀` gives `E = max σ₀ (Θ − (1 − θ')) < Θ`.
For every `σ ≥ E` (the design's `σ ∈ (Θ − 5δ², Θ)`):

- block S1 at `q = 1` (`FilterAttained.finite_part_le`, `a = 0`, `b = 1`) and the
  tail rate give `P_k = Σ'_{β≥σ} w_ρ·z_ρ^k = O(k²·2^(kσ))`, `w_ρ = m(ρ)/ρ`,
  `z_ρ = 2^ρ`;
- so `G(u) = Σ_k P_k·u^k` is analytic in `|u| < 2^(−σ)`;
- `F(u) = Σ' w_ρ/(1 − z_ρ·u)` is analytic off `K = closure{u_ρ}`, `u_ρ = 2^(−ρ)`,
  since `1 − z_ρ·u = z_ρ·(u_ρ − u)` and `|z_ρ| ≥ 1`;
- on `|u| < 1/4`, `G = F` (Fubini and the geometric series);
- by the identity theorem `G = F` on the component `W` of `{|u| < 2^(−σ)} ∖ K`
  holding `0`;
- at a mode `u₁ = 2^(−ρ₁)`, `β₁ > σ`, isolated in `K` and in the closure of `W`,
  `(u₁ − u)·F(u) → u₁·Σ_fibre w_ρ` while `(u₁ − u)·G(u) → 0`; the fibre's weight
  has positive real part (`AliasClass.re_order_div_pos`). Contradiction.

The component is taken in the disc `|u| < 2^(−σ)`, where `G` is known to be
analytic, and not in all of `ℂ ∖ K`: a path from `0` to `u₁` in `ℂ ∖ K` that leaves
the disc carries no continuation of `G`. The residue `w/(1 − z u)` reads
`w·u₁/(u₁ − u)` at the fibre, the design's `w·u/(u_ρ − u)` up to the constant term
`k = 0` of the series.

  um, K, P, G, F              the mode in `u`, its closure, the ladder sums, the two
                                generating functions
  um_eq, norm_um, one_sub_eq   `u_ρ = 1/z_ρ`, `|u_ρ| = 2^(−β)`, `1 − z u = z (u_ρ − u)`
  K_subset                     `K ⊆ {|u| ≥ 1/2}`
  differentiableAt_F           `F` is differentiable off `K`
  P_bound                      `‖P_k‖ ≤ (|Afl C| + Ct)·k²·2^(kσ)` for `k ≥ 2`
  differentiableAt_G           `G` is differentiable in `|u| < 1/X`
  G_eq_F                       `G = F` on `|u| < 1/4`
  isolated_boundary_mode_false the isolated mode on the boundary ⊢ False

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.FilterAccum
import Stage3.CountReduction
import Stage3.AliasClass

namespace ResidueRoute

open Finset Filter Topology Kadiri FiniteOffLine

noncomputable section

/-- The mode of a zero in the variable `u`: `u_ρ = 2^(−ρ)`. -/
noncomputable
def um (ρ : NontrivialZeros) : ℂ := (2:ℂ) ^ (-(ρ : ℂ))

/-- `K = closure {2^(−ρ) : Re ρ ≥ σ}`. -/
noncomputable
def K (σ : ℝ) : Set ℂ :=
  closure {u : ℂ | ∃ ρ : NontrivialZeros, σ ≤ (ρ : ℂ).re ∧ (2:ℂ) ^ (-(ρ : ℂ)) = u}

/-- The ladder sum over the zeros right of `σ`: `P_k = Σ' m(ρ)/ρ·(2^ρ)^k`. -/
noncomputable
def P (σ : ℝ) (k : ℕ) : ℂ :=
  ∑' ρ : FilterAttained.S σ, LadderMean.coef ρ.1 * ((2:ℂ) ^ (ρ.1 : ℂ)) ^ k

/-- The generating function of the ladder sums: `G(u) = Σ_k P_k·u^k`. -/
noncomputable
def G (σ : ℝ) (u : ℂ) : ℂ := ∑' k : ℕ, P σ k * u ^ k

/-- The sum of the poles: `F(u) = Σ' m(ρ)/ρ·1/(1 − 2^ρ·u)`. -/
noncomputable
def F (σ : ℝ) (u : ℂ) : ℂ :=
  ∑' ρ : FilterAttained.S σ, LadderMean.coef ρ.1 / (1 - (2:ℂ) ^ (ρ.1 : ℂ) * u)

/-- `K` is closed. -/
theorem isClosed_K (σ : ℝ) : IsClosed (K σ) := isClosed_closure

/-- The mode of a zero right of `σ` lies in `K`. -/
theorem um_mem_K {σ : ℝ} (ρ : NontrivialZeros) (h : σ ≤ (ρ : ℂ).re) : um ρ ∈ K σ :=
  subset_closure ⟨ρ, h, rfl⟩

/-- `u_ρ = 1/z_ρ`. -/
theorem um_eq (ρ : NontrivialZeros) : um ρ = ((2:ℂ) ^ (ρ : ℂ))⁻¹ := Complex.cpow_neg _ _

/-- `|u_ρ| = 2^(−β)`. -/
theorem norm_um (ρ : NontrivialZeros) : ‖um ρ‖ = (2:ℝ) ^ (-(ρ : ℂ).re) := by
  rw [um, norm_two_cpow, Complex.neg_re]

/-- The mode `2^ρ` is not zero. -/
theorem mode_ne_zero (ρ : NontrivialZeros) : (2:ℂ) ^ (ρ : ℂ) ≠ 0 :=
  norm_pos_iff.mp (lt_of_lt_of_le one_pos (FilterAccum.one_le_norm_mode ρ))

/-- `1 − z_ρ·u = z_ρ·(u_ρ − u)`. -/
theorem one_sub_eq (ρ : NontrivialZeros) (u : ℂ) :
    1 - (2:ℂ) ^ (ρ : ℂ) * u = (2:ℂ) ^ (ρ : ℂ) * (um ρ - u) := by
  rw [um_eq, mul_sub, mul_inv_cancel₀ (mode_ne_zero ρ)]

/-- `|u_ρ − u| ≤ |1 − z_ρ·u|`, since `|z_ρ| ≥ 1`. -/
theorem norm_sub_le (ρ : NontrivialZeros) (u : ℂ) :
    ‖um ρ - u‖ ≤ ‖1 - (2:ℂ) ^ (ρ : ℂ) * u‖ := by
  rw [one_sub_eq, norm_mul]
  exact le_mul_of_one_le_left (norm_nonneg _) (FilterAccum.one_le_norm_mode ρ)

/-- Every point of `K` has size at least `1/2`. -/
theorem K_subset (σ : ℝ) : K σ ⊆ {u : ℂ | 1 / 2 ≤ ‖u‖} := by
  apply closure_minimal
  · rintro u ⟨ρ, -, rfl⟩
    show 1 / 2 ≤ ‖(2:ℂ) ^ (-(ρ : ℂ))‖
    rw [norm_two_cpow, Complex.neg_re]
    have e : (2:ℝ) ^ (-1:ℝ) = 1 / 2 := by
      rw [Real.rpow_neg_one]
      norm_num
    rw [← e]
    exact Real.rpow_le_rpow_of_exponent_le (by norm_num) (by linarith [ρ.2.1.2])
  · exact isClosed_le continuous_const continuous_norm

/-- The weights `|m(ρ)/ρ|` right of `σ > 1/2` are summable. -/
theorem summable_coef {σ : ℝ} (hσ : 1 / 2 < σ) :
    Summable fun ρ : FilterAttained.S σ => ‖LadderMean.coef ρ.1‖ :=
  ZeroSummable.summable_norm_coef (FilterAttained.S σ) hσ fun _ h => h

/-- **`F` is differentiable off `K`.** Near a point `v ∉ K`, at distance `ε` from `K`,
every term is bounded by `(2/ε)·|m(ρ)/ρ|`. -/
theorem differentiableAt_F {σ : ℝ} (hσ : 1 / 2 < σ) {v : ℂ} (hv : v ∉ K σ) :
    DifferentiableAt ℂ (F σ) v := by
  obtain ⟨ε, hε, hball⟩ := Metric.isOpen_iff.mp (isClosed_K σ).isOpen_compl v hv
  have hfar : ∀ ρ : FilterAttained.S σ, ∀ u ∈ Metric.ball v (ε / 2),
      ε / 2 ≤ ‖1 - (2:ℂ) ^ (ρ.1 : ℂ) * u‖ := by
    intro ρ u hu
    have hK : um ρ.1 ∈ K σ := um_mem_K ρ.1 ρ.2
    have h1 : ε ≤ dist (um ρ.1) v := by
      by_contra h
      exact hball (Metric.mem_ball.mpr (lt_of_not_ge h)) hK
    have h2 := dist_triangle (um ρ.1) u v
    rw [dist_eq_norm (um ρ.1) u] at h2
    have h3 := Metric.mem_ball.mp hu
    have h4 := norm_sub_le ρ.1 u
    linarith
  have hd : DifferentiableOn ℂ (F σ) (Metric.ball v (ε / 2)) := by
    show DifferentiableOn ℂ (fun u => ∑' ρ : FilterAttained.S σ,
      LadderMean.coef ρ.1 / (1 - (2:ℂ) ^ (ρ.1 : ℂ) * u)) _
    refine Complex.differentiableOn_tsum_of_summable_norm
      (F := fun (ρ : FilterAttained.S σ) (u : ℂ) =>
        LadderMean.coef ρ.1 / (1 - (2:ℂ) ^ (ρ.1 : ℂ) * u))
      ((summable_coef hσ).mul_left (2 / ε)) (fun ρ => ?_) Metric.isOpen_ball
      (fun ρ u hu => ?_)
    · intro u hu
      have hne : 1 - (2:ℂ) ^ (ρ.1 : ℂ) * u ≠ 0 := by
        intro h0
        have := hfar ρ u hu
        rw [h0, norm_zero] at this
        linarith
      have hd : DifferentiableAt ℂ (fun u : ℂ => LadderMean.coef ρ.1 / (1 - (2:ℂ) ^ (ρ.1 : ℂ) * u)) u :=
        DifferentiableAt.div (by fun_prop) (by fun_prop) hne
      exact hd.differentiableWithinAt
    · have h := hfar ρ u hu
      rw [norm_div]
      calc ‖LadderMean.coef ρ.1‖ / ‖1 - (2:ℂ) ^ (ρ.1 : ℂ) * u‖
          ≤ ‖LadderMean.coef ρ.1‖ / (ε / 2) :=
            div_le_div_of_nonneg_left (norm_nonneg _) (by positivity) h
        _ = 2 / ε * ‖LadderMean.coef ρ.1‖ := by
            field_simp
            try ring
  exact hd.differentiableAt (Metric.ball_mem_nhds v (by positivity))

/-- **The ladder sums right of `σ`.** Under `H`, for `1/2 < σ₀ ≤ 1` and `Θ` an upper
bound for the real parts, there are `θ' < 1` and `Ct ≥ 0` such that for every
`σ ≥ σ₀` with `Θ ≤ σ + (1 − θ')` and every `k ≥ 2`,
`‖Σ'_{β≥σ} m(ρ)/ρ·(2^ρ)^k‖ ≤ (|Afl C| + Ct)·k²·(2^σ)^k`. The zeros below height `2^k`
by block S1 at `q = 1`; those above by the tail rate. -/
theorem P_bound {C : ℝ}
    (hH : ∀ k : ℕ, 1 ≤ k → ‖(Chebyshev.psi ((2:ℝ)^k) : ℂ) - (((2:ℝ)^k : ℝ) : ℂ)‖
      ≤ C * (k:ℝ)^2 * Real.sqrt 2 ^ k)
    {σ₀ Θ : ℝ} (hσ₀ : 1 / 2 < σ₀) (hσ₀1 : σ₀ ≤ 1)
    (hΘ : ∀ ρ : NontrivialZeros, (ρ : ℂ).re ≤ Θ) :
    ∃ θ' Ct : ℝ, θ' < 1 ∧ 0 ≤ Ct ∧ ∀ σ : ℝ, σ₀ ≤ σ → Θ ≤ σ + (1 - θ') →
      ∀ k : ℕ, 2 ≤ k → ‖P σ k‖ ≤ (|FilterLadder.Afl C| + Ct) * (k:ℝ) ^ 2 * ((2:ℝ) ^ σ) ^ k := by
  classical
  obtain ⟨θ', Ct, -, hθ'1, hCt, hrate⟩ := CountReduction.tail_rate hσ₀ hσ₀1
  refine ⟨θ', Ct, hθ'1, hCt, fun σ hσ₀σ hΘσ k hk => ?_⟩
  have hσ : 1 / 2 < σ := by linarith
  have hrat : ∀ ρ : NontrivialZeros,
      FilterAttained.ratio 1 0 1 2 ρ = (2:ℂ) ^ (ρ : ℂ) / 2 := by
    intro ρ
    simp [FilterAttained.ratio, FilterAttained.xi]
  have hnr : ∀ ρ : NontrivialZeros,
      ‖FilterAttained.ratio 1 0 1 2 ρ‖ = (2:ℝ) ^ (ρ : ℂ).re / 2 := by
    intro ρ
    rw [hrat, norm_div, norm_two_cpow]
    simp
  have hle : ∀ ρ ∈ FilterAttained.S σ, ‖FilterAttained.ratio 1 0 1 2 ρ‖ ≤ 1 := by
    intro ρ _
    rw [hnr, div_le_one (by norm_num)]
    have := FilterAccum.norm_mode_le_two ρ
    rw [norm_two_cpow] at this
    exact this
  have hP : P σ k = (2:ℂ) ^ k * ∑' ρ, (FilterAttained.S σ).indicator
      (fun ρ => LadderMean.coef ρ * FilterAttained.ratio 1 0 1 2 ρ ^ k) ρ := by
    rw [← tsum_mul_left, P,
      tsum_subtype (FilterAttained.S σ) (fun ρ => LadderMean.coef ρ * ((2:ℂ) ^ (ρ : ℂ)) ^ k)]
    refine tsum_congr fun ρ => ?_
    by_cases h : ρ ∈ FilterAttained.S σ
    · rw [Set.indicator_of_mem h, Set.indicator_of_mem h, hrat, div_pow]
      field_simp
      try ring
    · rw [Set.indicator_of_notMem h, Set.indicator_of_notMem h, mul_zero]
  have hfin := FilterAttained.finite_part_le hH (1 : Polynomial ℂ) (a := 0) (b := 1) le_rfl
    (by simp) hσ.le (M := 2) (by norm_num) hk
  simp only [Nat.cast_one, one_pow, mul_one, pow_zero] at hfin
  have htail : ‖∑' ρ, FilterAttained.tailT 1 0 1 σ 2 k ρ‖
      ≤ ((2:ℝ) ^ Θ / 2) ^ k * (Ct * k * (2:ℝ) ^ (-(k:ℝ) * (1 - θ'))) := by
    set g : NontrivialZeros → ℝ := fun ρ =>
      if σ ≤ (ρ : ℂ).re ∧ ρ ∉ ZF ((2:ℝ) ^ (1 * k)) then ((2:ℝ) ^ Θ / 2) ^ k * ZeroSummable.w ρ
      else 0 with hg
    have hpt : ∀ ρ, ‖FilterAttained.tailT 1 0 1 σ 2 k ρ‖ ≤ g ρ := by
      intro ρ
      simp only [hg]
      unfold FilterAttained.tailT
      by_cases hZ : ρ ∈ ZF ((2:ℝ) ^ (1 * k))
      · rw [if_pos hZ, norm_zero, if_neg (fun h => h.2 hZ)]
      · rw [if_neg hZ]
        by_cases hS : ρ ∈ FilterAttained.S σ
        · rw [Set.indicator_of_mem hS, if_pos ⟨hS, hZ⟩, norm_mul, norm_pow, hnr,
            ZeroSummable.norm_coef, mul_comm]
          refine mul_le_mul_of_nonneg_right (pow_le_pow_left₀ (by positivity) ?_ k)
            (ZeroSummable.w_nonneg ρ)
          exact div_le_div_of_nonneg_right
            (Real.rpow_le_rpow_of_exponent_le (by norm_num) (hΘ ρ)) (by norm_num)
        · rw [Set.indicator_of_notMem hS, norm_zero, if_neg (fun h => hS h.1)]
    have hs : Summable fun ρ => ‖FilterAttained.tailT 1 0 1 σ 2 k ρ‖ :=
      Summable.of_nonneg_of_le (fun _ => norm_nonneg _)
        (fun ρ => FilterAttained.norm_tailT_le 1 0 1 hle k ρ) (FilterAttained.summable_S hσ)
    refine (norm_tsum_le_tsum_norm hs).trans
      (Real.tsum_le_of_sum_le (fun _ => norm_nonneg _) fun u => ?_)
    refine (Finset.sum_le_sum fun ρ _ => hpt ρ).trans ?_
    simp only [hg]
    rw [← Finset.sum_filter, ← Finset.mul_sum]
    refine mul_le_mul_of_nonneg_left ?_ (by positivity)
    exact hrate k (by omega) _ (fun ρ hρ => by
      rw [Finset.mem_filter] at hρ
      refine ⟨hσ₀σ.trans hρ.2.1, ?_⟩
      have h := hρ.2.2
      rw [mem_ZF, one_mul, not_lt] at h
      exact h)
  have hneg : (2:ℝ) ^ (-(k:ℝ) * (1 - θ')) = (((2:ℝ) ^ (1 - θ')) ^ k)⁻¹ := by
    rw [neg_mul, Real.rpow_neg (by norm_num), mul_comm, Real.rpow_mul_natCast (by norm_num)]
  have hY : (2:ℝ) ^ Θ / (2:ℝ) ^ (1 - θ') ≤ (2:ℝ) ^ σ := by
    rw [← Real.rpow_sub (by norm_num)]
    exact Real.rpow_le_rpow_of_exponent_le (by norm_num) (by linarith)
  have hY0 : 0 ≤ (2:ℝ) ^ Θ / (2:ℝ) ^ (1 - θ') := by positivity
  have e1 : (2:ℝ) ^ k * (FilterLadder.Afl C * (k:ℝ) ^ 2 * ((2:ℝ) ^ σ / 2) ^ k)
      = FilterLadder.Afl C * (k:ℝ) ^ 2 * ((2:ℝ) ^ σ) ^ k := by
    rw [div_pow]
    field_simp
    try ring
  have e2 : (2:ℝ) ^ k * (((2:ℝ) ^ Θ / 2) ^ k * (Ct * k * (2:ℝ) ^ (-(k:ℝ) * (1 - θ'))))
      = Ct * k * ((2:ℝ) ^ Θ / (2:ℝ) ^ (1 - θ')) ^ k := by
    rw [hneg, div_pow, div_pow]
    field_simp
    try ring
  have hk1 : (k:ℝ) ≤ (k:ℝ) ^ 2 := by
    have : (1:ℝ) ≤ k := by exact_mod_cast (by omega : 1 ≤ k)
    nlinarith
  have h1 : FilterLadder.Afl C * (k:ℝ) ^ 2 * ((2:ℝ) ^ σ) ^ k
      ≤ |FilterLadder.Afl C| * (k:ℝ) ^ 2 * ((2:ℝ) ^ σ) ^ k :=
    mul_le_mul_of_nonneg_right (mul_le_mul_of_nonneg_right (le_abs_self _) (by positivity))
      (by positivity)
  have h2 : Ct * k * ((2:ℝ) ^ Θ / (2:ℝ) ^ (1 - θ')) ^ k ≤ Ct * (k:ℝ) ^ 2 * ((2:ℝ) ^ σ) ^ k :=
    mul_le_mul (mul_le_mul_of_nonneg_left hk1 hCt) (pow_le_pow_left₀ hY0 hY k)
      (by positivity) (by positivity)
  have e3 : (|FilterLadder.Afl C| + Ct) * (k:ℝ) ^ 2 * ((2:ℝ) ^ σ) ^ k
      = |FilterLadder.Afl C| * (k:ℝ) ^ 2 * ((2:ℝ) ^ σ) ^ k + Ct * (k:ℝ) ^ 2 * ((2:ℝ) ^ σ) ^ k := by
    ring
  rw [hP, FilterAttained.tsum_split 1 0 1 hσ hle k, norm_mul, norm_pow]
  have hn2 : ‖(2:ℂ)‖ = 2 := by simp
  rw [hn2]
  have hmain := mul_le_mul_of_nonneg_left ((norm_add_le _ _).trans (add_le_add hfin htail))
    (by positivity : (0:ℝ) ≤ 2 ^ k)
  rw [mul_add, e1, e2] at hmain
  linarith

/-- **`G` is differentiable in `|u| < 1/X`** when `‖P_k‖ ≤ A·k²·X^k` for `k ≥ 2`. -/
theorem differentiableAt_G {σ A X : ℝ} (hX : 0 < X)
    (hA : ∀ k : ℕ, 2 ≤ k → ‖P σ k‖ ≤ A * (k:ℝ) ^ 2 * X ^ k) {v : ℂ} (hv : ‖v‖ < X⁻¹) :
    DifferentiableAt ℂ (G σ) v := by
  set r := (‖v‖ + X⁻¹) / 2 with hr
  have hvr : ‖v‖ < r := by rw [hr]; linarith
  have hrX : r < X⁻¹ := by rw [hr]; linarith
  have hr0 : 0 < r := lt_of_le_of_lt (norm_nonneg v) hvr
  have hXr0 : 0 ≤ X * r := by positivity
  have hXr1 : X * r < 1 := by
    calc X * r < X * X⁻¹ := mul_lt_mul_of_pos_left hrX hX
      _ = 1 := mul_inv_cancel₀ hX.ne'
  have hgeo : Summable fun n : ℕ => |A| * ((n:ℝ) ^ 2 * (X * r) ^ n) :=
    (summable_pow_mul_geometric_of_norm_lt_one 2 (r := X * r)
      (by rw [Real.norm_of_nonneg hXr0]; exact hXr1)).mul_left |A|
  have hsum : Summable fun k : ℕ => ‖P σ k‖ * r ^ k := by
    refine (summable_nat_add_iff 2).mp ?_
    refine Summable.of_nonneg_of_le (fun k => by positivity) (fun k => ?_)
      ((summable_nat_add_iff 2).mpr hgeo)
    have h := hA (k + 2) (by omega)
    calc ‖P σ (k + 2)‖ * r ^ (k + 2) ≤ A * ((k + 2 : ℕ) : ℝ) ^ 2 * X ^ (k + 2) * r ^ (k + 2) :=
          mul_le_mul_of_nonneg_right h (by positivity)
      _ ≤ |A| * ((k + 2 : ℕ) : ℝ) ^ 2 * X ^ (k + 2) * r ^ (k + 2) :=
          mul_le_mul_of_nonneg_right (mul_le_mul_of_nonneg_right
            (mul_le_mul_of_nonneg_right (le_abs_self A) (by positivity)) (by positivity))
            (by positivity)
      _ = |A| * (((k + 2 : ℕ) : ℝ) ^ 2 * (X * r) ^ (k + 2)) := by
          rw [mul_pow]
          ring
  have hd : DifferentiableOn ℂ (G σ) (Metric.ball 0 r) := by
    show DifferentiableOn ℂ (fun u => ∑' k : ℕ, P σ k * u ^ k) _
    refine Complex.differentiableOn_tsum_of_summable_norm (F := fun (k : ℕ) (u : ℂ) => P σ k * u ^ k)
      hsum (fun k => ?_) Metric.isOpen_ball (fun k u hu => ?_)
    · exact ((differentiable_const _).mul (differentiable_pow k)).differentiableOn
    · rw [norm_mul, norm_pow]
      exact mul_le_mul_of_nonneg_left
        (pow_le_pow_left₀ (norm_nonneg _) (mem_ball_zero_iff.mp hu).le k) (norm_nonneg _)
  exact hd.differentiableAt (Metric.isOpen_ball.mem_nhds (mem_ball_zero_iff.mpr hvr))

/-- **`G = F` near the origin.** For `|u| < 1/4`, `|2^ρ·u| ≤ 1/2`, and the double sum
`Σ_k Σ'_ρ m(ρ)/ρ·(2^ρ u)^k` may be summed in either order. -/
theorem G_eq_F {σ : ℝ} (hσ : 1 / 2 < σ) {u : ℂ} (hu : ‖u‖ < 1 / 4) : G σ u = F σ u := by
  have hW := summable_coef hσ
  have hz : ∀ ρ : FilterAttained.S σ, ‖(2:ℂ) ^ (ρ.1 : ℂ) * u‖ ≤ 1 / 2 := fun ρ => by
    rw [norm_mul]
    calc ‖(2:ℂ) ^ (ρ.1 : ℂ)‖ * ‖u‖ ≤ 2 * (1 / 4) :=
          mul_le_mul (FilterAccum.norm_mode_le_two ρ.1) hu.le (norm_nonneg _) (by norm_num)
      _ = 1 / 2 := by norm_num
  obtain ⟨f, hf⟩ : ∃ f : ℕ → FilterAttained.S σ → ℂ, f = fun k ρ =>
    LadderMean.coef ρ.1 * ((2:ℂ) ^ (ρ.1 : ℂ) * u) ^ k := ⟨_, rfl⟩
  have hb : Summable fun x : ℕ × FilterAttained.S σ =>
      (1 / 2 : ℝ) ^ x.1 * ‖LadderMean.coef x.2.1‖ :=
    Summable.mul_of_nonneg (f := fun n : ℕ => (1 / 2 : ℝ) ^ n)
      (g := fun ρ : FilterAttained.S σ => ‖LadderMean.coef ρ.1‖)
      (summable_geometric_of_lt_one (by norm_num) (by norm_num)) hW
      (fun n => pow_nonneg (by norm_num) n) (fun ρ => norm_nonneg _)
  have hfs : Summable (Function.uncurry f) := by
    refine Summable.of_norm_bounded hb (fun x => ?_)
    show ‖f x.1 x.2‖ ≤ _
    rw [hf]
    dsimp only
    rw [norm_mul, norm_pow, mul_comm]
    exact mul_le_mul_of_nonneg_right (pow_le_pow_left₀ (norm_nonneg _) (hz x.2) x.1)
      (norm_nonneg _)
  have hG : G σ u = ∑' k, ∑' ρ, f k ρ := by
    unfold G P
    refine tsum_congr fun k => ?_
    rw [← tsum_mul_right]
    refine tsum_congr fun ρ => ?_
    rw [hf]
    dsimp only
    rw [mul_pow]
    ring
  rw [hG, ← hfs.tsum_comm]
  unfold F
  refine tsum_congr fun ρ => ?_
  have hlt : ‖(2:ℂ) ^ (ρ.1 : ℂ) * u‖ < 1 := lt_of_le_of_lt (hz ρ) (by norm_num)
  rw [hf]
  dsimp only
  rw [tsum_mul_left, tsum_geometric_of_norm_lt_one hlt, div_eq_mul_inv]

/-- An identity for the fibre term: `a·(c/(z·a)) = c·z⁻¹`. -/
theorem fibre_term {a c z : ℂ} (ha : a ≠ 0) (hz : z ≠ 0) : a * (c / (z * a)) = c * z⁻¹ := by
  field_simp

/-- **An isolated mode on the boundary of the origin's component.** Let
`|ψ(2^k) − 2^k| ≤ C·k²·√2^k` for `k ≥ 1`, let `1/2 < σ₀ < Θ ≤ 1` and let every zero have
real part at most `Θ`. Then there is `E` with `σ₀ ≤ E < Θ` such that for every `σ ≥ E`
no zero `ρ₁` with real part above `σ` has its mode `u₁ = 2^(−ρ₁)` isolated in
`K = closure {2^(−ρ) : Re ρ ≥ σ}` and on the frontier of the connected component of
`{|u| < 2^(−σ)} ∖ K` that holds `0`. -/
theorem isolated_boundary_mode_false {C : ℝ}
    (hH : ∀ k : ℕ, 1 ≤ k → ‖(Chebyshev.psi ((2:ℝ)^k) : ℂ) - (((2:ℝ)^k : ℝ) : ℂ)‖
      ≤ C * (k:ℝ)^2 * Real.sqrt 2 ^ k)
    {σ₀ Θ : ℝ} (hσ₀ : 1 / 2 < σ₀) (hσ₀Θ : σ₀ < Θ) (hΘ1 : Θ ≤ 1)
    (hΘ : ∀ ρ : Kadiri.NontrivialZeros, (ρ : ℂ).re ≤ Θ) :
    ∃ E : ℝ, σ₀ ≤ E ∧ E < Θ ∧ ∀ σ : ℝ, E ≤ σ →
      ∀ ρ₁ : Kadiri.NontrivialZeros, σ < (ρ₁ : ℂ).re →
      (∃ ε : ℝ, 0 < ε ∧ ∀ u ∈ K σ, ‖u - (2:ℂ) ^ (-(ρ₁ : ℂ))‖ < ε → u = (2:ℂ) ^ (-(ρ₁ : ℂ))) →
      (2:ℂ) ^ (-(ρ₁ : ℂ)) ∈
        frontier (connectedComponentIn (Metric.ball (0:ℂ) ((2:ℝ) ^ (-σ)) \ K σ) 0) →
      False := by
  classical
  obtain ⟨θ', Ct, hθ'1, hCt, hPb⟩ := P_bound hH hσ₀ (hσ₀Θ.le.trans hΘ1) hΘ
  refine ⟨max σ₀ (Θ - (1 - θ')), le_max_left _ _, max_lt hσ₀Θ (by linarith), ?_⟩
  intro σ hσE ρ₁ hρ₁ hiso hfr
  obtain ⟨ε, hε, hiso⟩ := hiso
  have hσ₀σ : σ₀ ≤ σ := (le_max_left _ _).trans hσE
  have hΘσ : Θ ≤ σ + (1 - θ') := by
    have := (le_max_right σ₀ (Θ - (1 - θ'))).trans hσE
    linarith
  have hσ : 1 / 2 < σ := by linarith
  have hσ1 : σ < 1 := hρ₁.trans ρ₁.2.1.2
  -- the radius of G
  set X := (2:ℝ) ^ σ with hXdef
  have hX : 0 < X := by positivity
  have hA := hPb σ hσ₀σ hΘσ
  have hRX : (2:ℝ) ^ (-σ) = X⁻¹ := Real.rpow_neg (by norm_num) σ
  rw [hRX] at hfr
  have hX2 : X⁻¹ > 1 / 4 := by
    have h1 : X < 2 := by
      rw [hXdef]
      calc (2:ℝ) ^ σ < (2:ℝ) ^ (1:ℝ) := Real.rpow_lt_rpow_of_exponent_lt (by norm_num) hσ1
        _ = 2 := Real.rpow_one 2
    have h2 : (1:ℝ) / 2 < X⁻¹ := by
      rw [one_div]
      exact inv_strictAnti₀ hX h1
    linarith
  -- the mode u₁
  obtain ⟨u₁, hu₁⟩ : ∃ u : ℂ, u = (2:ℂ) ^ (-(ρ₁ : ℂ)) := ⟨_, rfl⟩
  rw [← hu₁] at hiso hfr
  have hu₁um : um ρ₁ = u₁ := hu₁.symm
  have hu₁K : u₁ ∈ K σ := hu₁um ▸ um_mem_K ρ₁ hρ₁.le
  have hu₁R : ‖u₁‖ < X⁻¹ := by
    rw [← hu₁um, norm_um, ← hRX]
    exact Real.rpow_lt_rpow_of_exponent_lt (by norm_num) (by linarith)
  have hu₁1 : ‖u₁‖ ≤ 1 := by
    rw [← hu₁um, norm_um]
    exact Real.rpow_le_one_of_one_le_of_nonpos (by norm_num) (by linarith [ρ₁.2.1.1])
  have hu₁0 : u₁ ≠ 0 := by
    intro h
    have := K_subset σ hu₁K
    rw [h] at this
    norm_num at this
  -- the component W
  set W := connectedComponentIn (Metric.ball (0:ℂ) X⁻¹ \ K σ) 0 with hWdef
  have hWopen : IsOpen W := (Metric.isOpen_ball.sdiff (isClosed_K σ)).connectedComponentIn
  have hWsub : W ⊆ Metric.ball (0:ℂ) X⁻¹ \ K σ := connectedComponentIn_subset _ _
  have h0 : (0:ℂ) ∈ Metric.ball (0:ℂ) X⁻¹ \ K σ := by
    refine ⟨Metric.mem_ball_self (by positivity), fun h => ?_⟩
    have := K_subset σ h
    norm_num at this
  have hGan : AnalyticOnNhd ℂ (G σ) W := by
    refine DifferentiableOn.analyticOnNhd (fun v hv => ?_) hWopen
    exact (differentiableAt_G hX hA (mem_ball_zero_iff.mp (hWsub hv).1)).differentiableWithinAt
  have hFan : AnalyticOnNhd ℂ (F σ) W := by
    refine DifferentiableOn.analyticOnNhd (fun v hv => ?_) hWopen
    exact (differentiableAt_F hσ (hWsub hv).2).differentiableWithinAt
  have hev : G σ =ᶠ[𝓝 0] F σ := by
    filter_upwards [Metric.ball_mem_nhds (0:ℂ) (by norm_num : (0:ℝ) < 1 / 4)] with u hu
    exact G_eq_F hσ (mem_ball_zero_iff.mp hu)
  have hEq : Set.EqOn (G σ) (F σ) W :=
    hGan.eqOn_of_preconnected_of_eventuallyEq hFan isPreconnected_connectedComponentIn
      (mem_connectedComponentIn h0) hev
  haveI : (𝓝[W] u₁).NeBot := mem_closure_iff_nhdsWithin_neBot.mp (frontier_subset_closure hfr)
  -- (u₁ − u)·G(u) → 0
  have hGc : ContinuousAt (G σ) u₁ := (differentiableAt_G hX hA hu₁R).continuousAt
  have hlimG : Tendsto (fun u => (u₁ - u) * G σ u) (𝓝[W] u₁) (𝓝 0) := by
    have h : ContinuousAt (fun u => (u₁ - u) * G σ u) u₁ :=
      ContinuousAt.mul (by fun_prop) hGc
    have h' : Tendsto (fun u => (u₁ - u) * G σ u) (𝓝 u₁) (𝓝 ((u₁ - u₁) * G σ u₁)) := h
    rw [sub_self, zero_mul] at h'
    exact h'.mono_left nhdsWithin_le_nhds
  -- (u₁ − u)·F(u) → u₁·Σ_fibre m(ρ)/ρ
  have hfar : ∀ ρ : FilterAttained.S σ, um ρ.1 ≠ u₁ → ε ≤ ‖um ρ.1 - u₁‖ := fun ρ hne =>
    not_lt.mp fun h => hne (hiso _ (um_mem_K ρ.1 ρ.2) h)
  have hnear : ∀ᶠ u in 𝓝[W] u₁, u ∈ W ∧ ‖u - u₁‖ < ε / 2 := by
    have h1 : ∀ᶠ u in 𝓝[W] u₁, u ∈ W := self_mem_nhdsWithin
    have h2 : ∀ᶠ u in 𝓝[W] u₁, ‖u - u₁‖ < ε / 2 := by
      have := Metric.ball_mem_nhds u₁ (by positivity : (0:ℝ) < ε / 2)
      filter_upwards [nhdsWithin_le_nhds this] with u hu
      rw [Metric.mem_ball, dist_eq_norm] at hu
      exact hu
    exact h1.and h2
  set g : FilterAttained.S σ → ℂ := fun ρ =>
    (if um ρ.1 = u₁ then LadderMean.coef ρ.1 else 0) * u₁ with hg
  have hlimF : Tendsto (fun u => ∑' ρ : FilterAttained.S σ,
      (u₁ - u) * (LadderMean.coef ρ.1 / (1 - (2:ℂ) ^ (ρ.1 : ℂ) * u))) (𝓝[W] u₁)
      (𝓝 (∑' ρ, g ρ)) := by
    refine tendsto_tsum_of_dominated_convergence (summable_coef hσ) (fun ρ => ?_) ?_
    · by_cases hfib : um ρ.1 = u₁
      · have hgρ : g ρ = LadderMean.coef ρ.1 * u₁ := by simp only [hg, if_pos hfib]
        rw [hgρ]
        refine tendsto_const_nhds.congr' ?_
        filter_upwards [hnear] with u hu
        have hne : u₁ - u ≠ 0 := fun h => ((hWsub hu.1).2) (by
          rw [← sub_eq_zero.mp h]
          exact hu₁K)
        rw [one_sub_eq, hfib, fibre_term hne (mode_ne_zero ρ.1), ← um_eq, hfib]
      · have hgρ : g ρ = 0 := by simp only [hg, if_neg hfib, zero_mul]
        rw [hgρ]
        have hd : 1 - (2:ℂ) ^ (ρ.1 : ℂ) * u₁ ≠ 0 := by
          intro h0
          have := (hfar ρ hfib).trans (norm_sub_le ρ.1 u₁)
          rw [h0, norm_zero] at this
          linarith
        have hc : ContinuousAt (fun u => (u₁ - u) *
            (LadderMean.coef ρ.1 / (1 - (2:ℂ) ^ (ρ.1 : ℂ) * u))) u₁ :=
          ContinuousAt.mul (by fun_prop) (ContinuousAt.div (by fun_prop) (by fun_prop) hd)
        have h' : Tendsto (fun u => (u₁ - u) *
            (LadderMean.coef ρ.1 / (1 - (2:ℂ) ^ (ρ.1 : ℂ) * u))) (𝓝 u₁)
            (𝓝 ((u₁ - u₁) * (LadderMean.coef ρ.1 / (1 - (2:ℂ) ^ (ρ.1 : ℂ) * u₁)))) := hc
        rw [sub_self, zero_mul] at h'
        exact h'.mono_left nhdsWithin_le_nhds
    · filter_upwards [hnear] with u hu
      intro ρ
      have hne : u₁ - u ≠ 0 := fun h => ((hWsub hu.1).2) (by
        rw [← sub_eq_zero.mp h]
        exact hu₁K)
      by_cases hfib : um ρ.1 = u₁
      · rw [one_sub_eq, hfib, fibre_term hne (mode_ne_zero ρ.1), ← um_eq, hfib, norm_mul]
        exact mul_le_of_le_one_right (norm_nonneg _) hu₁1
      · have h1 := hfar ρ hfib
        have h2 : ε / 2 ≤ ‖um ρ.1 - u‖ := by
          have := norm_sub_le_norm_sub_add_norm_sub (um ρ.1) u u₁
          have h3 : ‖u - u₁‖ < ε / 2 := hu.2
          linarith
        have h4 := h2.trans (norm_sub_le ρ.1 u)
        have h5 : ‖u₁ - u‖ ≤ ε / 2 := by
          rw [norm_sub_rev]
          exact hu.2.le
        rw [norm_mul, norm_div]
        calc ‖u₁ - u‖ * (‖LadderMean.coef ρ.1‖ / ‖1 - (2:ℂ) ^ (ρ.1 : ℂ) * u‖)
            ≤ (ε / 2) * (‖LadderMean.coef ρ.1‖ / (ε / 2)) :=
              mul_le_mul h5 (div_le_div_of_nonneg_left (norm_nonneg _) (by positivity) h4)
                (by positivity) (by positivity)
          _ = ‖LadderMean.coef ρ.1‖ := by
              field_simp
  have hFG : ∀ᶠ u in 𝓝[W] u₁, (u₁ - u) * G σ u = ∑' ρ : FilterAttained.S σ,
      (u₁ - u) * (LadderMean.coef ρ.1 / (1 - (2:ℂ) ^ (ρ.1 : ℂ) * u)) := by
    filter_upwards [self_mem_nhdsWithin] with u hu
    rw [hEq hu, F, tsum_mul_left]
  have hzero : ∑' ρ, g ρ = 0 := tendsto_nhds_unique hlimF (hlimG.congr' hFG)
  -- the fibre's weight is zero, against positive real parts
  set h : FilterAttained.S σ → ℂ := fun ρ =>
    if um ρ.1 = u₁ then LadderMean.coef ρ.1 else 0 with hhdef
  have hs : Summable h := Summable.of_norm_bounded (summable_coef hσ) (fun ρ => by
    simp only [hhdef]
    split_ifs
    · exact le_rfl
    · rw [norm_zero]
      exact norm_nonneg _)
  have hgh : ∑' ρ, g ρ = (∑' ρ, h ρ) * u₁ := by
    rw [← tsum_mul_right]
  have hh0 : ∑' ρ, h ρ = 0 := by
    rw [hgh] at hzero
    exact (mul_eq_zero.mp hzero).resolve_right hu₁0
  have hre := Complex.re_tsum hs
  rw [hh0, Complex.zero_re] at hre
  have hnn : ∀ ρ, 0 ≤ (h ρ).re := fun ρ => by
    simp only [hhdef]
    split_ifs
    · exact (AliasClass.re_order_div_pos ρ.1).le
    · rw [Complex.zero_re]
  have hpos : 0 < ∑' ρ, (h ρ).re := by
    refine Summable.tsum_pos (Complex.hasSum_re hs.hasSum).summable hnn ⟨ρ₁, hρ₁.le⟩ ?_
    simp only [hhdef]
    rw [if_pos hu₁um]
    exact AliasClass.re_order_div_pos ρ₁
  linarith

/-- info: 'ResidueRoute.isolated_boundary_mode_false' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms isolated_boundary_mode_false

end

end ResidueRoute
