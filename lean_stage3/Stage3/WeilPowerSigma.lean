/-
WeilPowerSigma — the tail sum to order `1/m`: `σ(m) = Σ_{j≥m+2} 1/(π²j²)`
bracketed sharply enough that `u m = (m+1)²σ(m)` is `(m+½)/π²` plus a
correction of size `1/m`. Rung 5, thirteenth slice; worksheet § 13 block
13c. 2026-09-06.

Unit 0347 bracketed `σ` between `1/(π²(m+2))` and `1/(π²(m+1))`, which
pins `u m = (m+1)²σ(m)` only to within an `O(1)` error of `(m+½)/π²`. The
averaging route of worksheet § 13 writes a member's normalized term as
`(ζ²/ε²)·exp(z·u m)` with `z = 2(ζ² − ε²)` and splits
`exp(z·u m) = exp(z(m+½)/π²)·exp(z·r m)`, `r m = u m − (m+½)/π²`: the
first factor is geometric in `m` and sums by the geometric-series bound,
the second is `1 + O(|z|·r m)` and sums against the target only when
`r m = O(1/m)`. An `O(1)` error there costs a constant times the whole
`h`-range, the same size as the target: a lost factor. This module removes
it by bracketing `σ` to order `1/m²`.

Both brackets come from telescoping comparisons on `Σ 1/(j+1)²`:

  sum_upper_half        m+1 ≤ n:  Σ_{j∈Ico(m+1)n} 1/(j+1)² ≤ 2/(2m+3)
                          via 1/(j+1)² ≤ 1/(j+½) − 1/(j+3/2)
  sum_lower_amgm        m+1 ≤ n:  1/(m+2) + 1/(2(m+2)²) − 1/(n+1) − 1/(2(n+1)²)
                            ≤ Σ_{j∈Ico(m+1)n} 1/(j+1)²
                          via 1/(2(j+1)²) + 1/(2(j+2)²) ≥ 1/((j+1)(j+2)), AM–GM
  sigma_le_half         σ(m) ≤ 2/(π²(2m+3))
  sigma_ge_amgm         1/(π²(m+2)) + 1/(2π²(m+2)²) ≤ σ(m)
  u_def                 u m = (m+1)²·σ(m)
  r_pos                 1/(2π²(m+2)²) ≤ u m − (m+½)/π²
  r_le                  u m − (m+½)/π² ≤ 1/(π²(4m+6))
  u_mono                u m ≤ u (m+1)

The two `r` bounds are the brackets' exact algebraic consequences: with
`t = m+2`, `(t−1)²/t + (t−1)²/(2t²) − (t−3/2) = 1/(2t²)` and
`2(m+1)²/(2m+3) − (m+½) = 1/(2(2m+3))`, both equalities, so `r_pos` and
`r_le` lose nothing beyond `sigma_ge_amgm` and `sigma_le_half`
themselves. `u_mono` is then `1/(π²(4m+6)) ≤ 1/π²`, the step `1/π²`
dominating the correction's whole range. Both limits are taken with
`le_of_tendsto` / `le_of_tendsto_of_tendsto` against `sigmaN_tendsto`, the
`n`-dependent tail of the lower bound majorized by `(3/2)·1/(n+1)` so one
`tendsto_one_div_add_atTop_nhds_zero_nat` carries it.

What the next slice needs: block 13d, the geometric sum
`|Σ_{m∈Ico a b} exp(z(m+½)/π²)| ≤ (|ρ|^a + |ρ|^b)/(e^{Re z/π²}|sin(Im z/π²)|)`
and the harmonic bound on `Σ_{m∈Ico a b} r m`, which `r_le` makes
`O(log(b/a))`.

Axioms: every theorem pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.WeilPowerPhase

namespace WeilPowerSigma

noncomputable section

open WeilPowerPhase Real Filter Topology

/-- Telescoping the half-shifted differences. -/
theorem sum_telescope_half (m : ℕ) : ∀ n : ℕ, m + 1 ≤ n →
    ∑ j ∈ Finset.Ico (m + 1) n, (1 / ((j : ℝ) + 1 / 2) - 1 / ((j : ℝ) + 3 / 2))
      = 1 / ((m : ℝ) + 3 / 2) - 1 / ((n : ℝ) + 1 / 2) := by
  intro n hn
  induction n, hn using Nat.le_induction with
  | base =>
    simp only [Finset.Ico_self, Finset.sum_empty]
    push_cast
    ring
  | succ n hn ih =>
    rw [Finset.sum_Ico_succ_top hn, ih]
    push_cast
    ring

/-- **The sharp upper bound for the tail sum**, `2/(2m+3)`. -/
theorem sum_upper_half (m : ℕ) {n : ℕ} (hn : m + 1 ≤ n) :
    ∑ j ∈ Finset.Ico (m + 1) n, 1 / ((j : ℝ) + 1) ^ 2 ≤ 2 / (2 * (m : ℝ) + 3) := by
  have hm1 : ((m : ℝ) + 3 / 2) ≠ 0 := by positivity
  have hm2 : (2 * (m : ℝ) + 3) ≠ 0 := by positivity
  have hne : (0 : ℝ) ≤ 1 / ((n : ℝ) + 1 / 2) := by positivity
  have e2 : 1 / ((m : ℝ) + 3 / 2) = 2 / (2 * (m : ℝ) + 3) := by
    field_simp
    try ring
  have hstep : ∑ j ∈ Finset.Ico (m + 1) n, 1 / ((j : ℝ) + 1) ^ 2
      ≤ ∑ j ∈ Finset.Ico (m + 1) n, (1 / ((j : ℝ) + 1 / 2) - 1 / ((j : ℝ) + 3 / 2)) := by
    apply Finset.sum_le_sum
    intro j _
    have hj1 : (0 : ℝ) < (j : ℝ) + 1 / 2 := by positivity
    have hj2 : (0 : ℝ) < (j : ℝ) + 3 / 2 := by positivity
    have e : 1 / ((j : ℝ) + 1 / 2) - 1 / ((j : ℝ) + 3 / 2)
        = 1 / (((j : ℝ) + 1 / 2) * ((j : ℝ) + 3 / 2)) := by
      field_simp
      ring
    rw [e, div_le_div_iff₀ (by positivity) (by positivity)]
    nlinarith
  rw [sum_telescope_half m n hn] at hstep
  rw [e2] at hstep
  linarith

/-- Telescoping the AM–GM differences. -/
theorem sum_telescope_amgm (m : ℕ) : ∀ n : ℕ, m + 1 ≤ n →
    ∑ j ∈ Finset.Ico (m + 1) n,
        ((1 / ((j : ℝ) + 1) - 1 / ((j : ℝ) + 2))
          + (1 / (2 * ((j : ℝ) + 1) ^ 2) - 1 / (2 * ((j : ℝ) + 2) ^ 2)))
      = (1 / ((m : ℝ) + 2) - 1 / ((n : ℝ) + 1))
        + (1 / (2 * ((m : ℝ) + 2) ^ 2) - 1 / (2 * ((n : ℝ) + 1) ^ 2)) := by
  intro n hn
  induction n, hn using Nat.le_induction with
  | base =>
    simp only [Finset.Ico_self, Finset.sum_empty]
    push_cast
    ring
  | succ n hn ih =>
    rw [Finset.sum_Ico_succ_top hn, ih]
    push_cast
    ring

/-- **The sharp lower bound for the tail sum**, to order `1/n²` on both ends. -/
theorem sum_lower_amgm (m : ℕ) {n : ℕ} (hn : m + 1 ≤ n) :
    1 / ((m : ℝ) + 2) + 1 / (2 * ((m : ℝ) + 2) ^ 2)
        - 1 / ((n : ℝ) + 1) - 1 / (2 * ((n : ℝ) + 1) ^ 2)
      ≤ ∑ j ∈ Finset.Ico (m + 1) n, 1 / ((j : ℝ) + 1) ^ 2 := by
  have hstep : ∑ j ∈ Finset.Ico (m + 1) n,
      ((1 / ((j : ℝ) + 1) - 1 / ((j : ℝ) + 2))
        + (1 / (2 * ((j : ℝ) + 1) ^ 2) - 1 / (2 * ((j : ℝ) + 2) ^ 2)))
      ≤ ∑ j ∈ Finset.Ico (m + 1) n, 1 / ((j : ℝ) + 1) ^ 2 := by
    apply Finset.sum_le_sum
    intro j _
    have hj1 : ((j : ℝ) + 1) ≠ 0 := by positivity
    have hj2 : ((j : ℝ) + 2) ≠ 0 := by positivity
    have e : 1 / ((j : ℝ) + 1) ^ 2
        - ((1 / ((j : ℝ) + 1) - 1 / ((j : ℝ) + 2))
          + (1 / (2 * ((j : ℝ) + 1) ^ 2) - 1 / (2 * ((j : ℝ) + 2) ^ 2)))
        = 1 / (2 * ((j : ℝ) + 1) ^ 2 * ((j : ℝ) + 2) ^ 2) := by
      field_simp
      ring
    have hp : (0 : ℝ) ≤ 1 / (2 * ((j : ℝ) + 1) ^ 2 * ((j : ℝ) + 2) ^ 2) := by positivity
    linarith
  rw [sum_telescope_amgm m n hn] at hstep
  linarith

/-- **`σ` from above**, `2/(π²(2m+3))`: sharper than unit 0347's `1/(π²(m+1))`. -/
theorem sigma_le_half (m : ℕ) : sigma m ≤ 2 / (Real.pi ^ 2 * (2 * (m : ℝ) + 3)) := by
  have hpi : Real.pi ≠ 0 := Real.pi_ne_zero
  have hm2 : (2 * (m : ℝ) + 3) ≠ 0 := by positivity
  apply le_of_tendsto (sigmaN_tendsto m)
  filter_upwards [eventually_ge_atTop (m + 1)] with n hn
  rw [sigmaN_eq]
  calc 1 / Real.pi ^ 2 * ∑ j ∈ Finset.Ico (m + 1) n, 1 / ((j : ℝ) + 1) ^ 2
      ≤ 1 / Real.pi ^ 2 * (2 / (2 * (m : ℝ) + 3)) :=
        mul_le_mul_of_nonneg_left (sum_upper_half m hn) (by positivity)
    _ = 2 / (Real.pi ^ 2 * (2 * (m : ℝ) + 3)) := by
        field_simp
        try ring

/-- **`σ` from below**, with the `1/m²` term: sharper than unit 0347's `1/(π²(m+2))`. -/
theorem sigma_ge_amgm (m : ℕ) :
    1 / (Real.pi ^ 2 * ((m : ℝ) + 2)) + 1 / (2 * Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2) ≤ sigma m := by
  have hpi : Real.pi ≠ 0 := Real.pi_ne_zero
  have hm2 : ((m : ℝ) + 2) ≠ 0 := by positivity
  have h0 : Tendsto (fun n : ℕ => 1 / ((n : ℝ) + 1)) atTop (𝓝 0) :=
    tendsto_one_div_add_atTop_nhds_zero_nat
  have h1 : Tendsto (fun n : ℕ => 1 / Real.pi ^ 2 * (1 / ((m : ℝ) + 2)
      + 1 / (2 * ((m : ℝ) + 2) ^ 2) - 3 / 2 * (1 / ((n : ℝ) + 1)))) atTop
      (𝓝 (1 / Real.pi ^ 2 * (1 / ((m : ℝ) + 2) + 1 / (2 * ((m : ℝ) + 2) ^ 2) - 3 / 2 * 0))) :=
    ((tendsto_const_nhds.sub (h0.const_mul _)).const_mul _)
  have e : 1 / Real.pi ^ 2 * (1 / ((m : ℝ) + 2) + 1 / (2 * ((m : ℝ) + 2) ^ 2) - 3 / 2 * 0)
      = 1 / (Real.pi ^ 2 * ((m : ℝ) + 2)) + 1 / (2 * Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2) := by
    rw [mul_zero, sub_zero]
    field_simp
  rw [e] at h1
  apply le_of_tendsto_of_tendsto h1 (sigmaN_tendsto m)
  filter_upwards [eventually_ge_atTop (m + 1)] with n hn
  rw [sigmaN_eq]
  have hn1 : ((n : ℝ) + 1) ≠ 0 := by positivity
  have hb : 1 / (2 * ((n : ℝ) + 1) ^ 2) ≤ 1 / 2 * (1 / ((n : ℝ) + 1)) := by
    have e2 : 1 / 2 * (1 / ((n : ℝ) + 1)) - 1 / (2 * ((n : ℝ) + 1) ^ 2)
        = (n : ℝ) / (2 * ((n : ℝ) + 1) ^ 2) := by
      field_simp
      ring
    have hp : (0 : ℝ) ≤ (n : ℝ) / (2 * ((n : ℝ) + 1) ^ 2) := by positivity
    linarith
  have hlow : 1 / ((m : ℝ) + 2) + 1 / (2 * ((m : ℝ) + 2) ^ 2) - 3 / 2 * (1 / ((n : ℝ) + 1))
      ≤ ∑ j ∈ Finset.Ico (m + 1) n, 1 / ((j : ℝ) + 1) ^ 2 := by
    have := sum_lower_amgm m hn
    linarith
  exact mul_le_mul_of_nonneg_left hlow (by positivity)

/-- The normalized tail sum `u m = (m+1)²σ(m)`, the exponent's shape at `λ = 1`. -/
def u (m : ℕ) : ℝ := ((m : ℝ) + 1) ^ 2 * sigma m

theorem u_def (m : ℕ) : u m = ((m : ℝ) + 1) ^ 2 * sigma m := rfl

/-- **The correction is positive**, at least `1/(2π²(m+2)²)`. -/
theorem r_pos (m : ℕ) :
    1 / (2 * Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2) ≤ u m - ((m : ℝ) + 1 / 2) / Real.pi ^ 2 := by
  have hpi : Real.pi ≠ 0 := Real.pi_ne_zero
  have hm2 : ((m : ℝ) + 2) ≠ 0 := by positivity
  have h2 : ((m : ℝ) + 1) ^ 2
      * (1 / (Real.pi ^ 2 * ((m : ℝ) + 2)) + 1 / (2 * Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2)) ≤ u m := by
    rw [u_def]
    exact mul_le_mul_of_nonneg_left (sigma_ge_amgm m) (by positivity)
  have e : ((m : ℝ) + 1) ^ 2
      * (1 / (Real.pi ^ 2 * ((m : ℝ) + 2)) + 1 / (2 * Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2))
      - ((m : ℝ) + 1 / 2) / Real.pi ^ 2 = 1 / (2 * Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2) := by
    field_simp
    ring
  linarith

/-- **The correction is `O(1/m)`**, at most `1/(π²(4m+6))`. -/
theorem r_le (m : ℕ) :
    u m - ((m : ℝ) + 1 / 2) / Real.pi ^ 2 ≤ 1 / (Real.pi ^ 2 * (4 * (m : ℝ) + 6)) := by
  have hpi : Real.pi ≠ 0 := Real.pi_ne_zero
  have hm2 : (2 * (m : ℝ) + 3) ≠ 0 := by positivity
  have hm3 : (4 * (m : ℝ) + 6) ≠ 0 := by positivity
  have h2 : u m ≤ ((m : ℝ) + 1) ^ 2 * (2 / (Real.pi ^ 2 * (2 * (m : ℝ) + 3))) := by
    rw [u_def]
    exact mul_le_mul_of_nonneg_left (sigma_le_half m) (by positivity)
  have e : ((m : ℝ) + 1) ^ 2 * (2 / (Real.pi ^ 2 * (2 * (m : ℝ) + 3)))
      - ((m : ℝ) + 1 / 2) / Real.pi ^ 2 = 1 / (Real.pi ^ 2 * (4 * (m : ℝ) + 6)) := by
    field_simp
    ring
  linarith

/-- **`u` is increasing**: the step `1/π²` beats the correction's whole range. -/
theorem u_mono (m : ℕ) : u m ≤ u (m + 1) := by
  have hpi : Real.pi ≠ 0 := Real.pi_ne_zero
  have hm3 : (4 * (m : ℝ) + 6) ≠ 0 := by positivity
  have h1 := r_le m
  have h2 := r_pos (m + 1)
  rw [Nat.cast_add_one] at h2
  have h3 : (0 : ℝ) ≤ 1 / (2 * Real.pi ^ 2 * ((m : ℝ) + 1 + 2) ^ 2) := by positivity
  have hstep : ((m : ℝ) + 1 + 1 / 2) / Real.pi ^ 2 - ((m : ℝ) + 1 / 2) / Real.pi ^ 2
      - 1 / (Real.pi ^ 2 * (4 * (m : ℝ) + 6)) = (4 * (m : ℝ) + 5) / (Real.pi ^ 2 * (4 * (m : ℝ) + 6)) := by
    field_simp
    ring
  have hp : (0 : ℝ) ≤ (4 * (m : ℝ) + 5) / (Real.pi ^ 2 * (4 * (m : ℝ) + 6)) := by positivity
  linarith

end

/-- info: 'WeilPowerSigma.sigma_le_half' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms sigma_le_half

/-- info: 'WeilPowerSigma.sigma_ge_amgm' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms sigma_ge_amgm

/-- info: 'WeilPowerSigma.r_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms r_le

/-- info: 'WeilPowerSigma.u_mono' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms u_mono

end WeilPowerSigma
