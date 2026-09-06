/-
WeilTiles — the heights tiled by bands. Rung 4b, second half, slice B1 of
the detection ladder (units 0316–0321). 2026-09-06.

Unit 0321 bounds the weighted on-line sum over one band of half-width `9/10`
about a height `T ≥ 2` by `M·(15·log T + 73)`. This slice tiles the heights
`t ≥ 11/10` by bands with centres `centre k = 2 + (9/5)·k`, `k : ℕ`, so that
consecutive bands abut, and passes from finite sums to the full sum:

  idx_spec
      every `t ≥ 11/10` lies within `9/10` of `centre (idx t)`,
      `idx t = ⌊(t − 11/10)/(9/5)⌋₊`.
  sum_by_bands
      a finite set of on-line zeros of height `≥ 11/10`, split by band
      index, has weighted sum at most `Σ_k M k·(15·log (centre k) + 73)`
      over the indices that occur, whenever each term is at most `M` at
      its own index.
  tsum_upper_le
      hence the full weighted sum over all on-line zeros of height
      `≥ 11/10` is at most `Σ'_k M k·(15·log (centre k) + 73)`, for any
      nonnegative summable band series `M` dominating the terms. The pass
      to the tsum is `Real.tsum_le_of_sum_le`: nonnegative terms and a
      uniform bound on every finite partial sum, no summability of the
      zero side needed.

Left for the next slices: an explicit summable `M` from unit 0320's near
and far bounds (B2); the heights below `11/10` and the negative heights
(B3).

Axioms: every theorem pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.WeilBands

namespace WeilTiles

noncomputable section

open Complex WeilDetect WeilBackground WeilBands Real

/-- Band centres `2 + (9/5)·k`. -/
def centre (k : ℕ) : ℝ := 2 + 9 / 5 * k

/-- Band index of a height `t`; meaningful for `t ≥ 11/10`. -/
def idx (t : ℝ) : ℕ := ⌊(t - 11 / 10) / (9 / 5)⌋₊

theorem two_le_centre (k : ℕ) : 2 ≤ centre k := by
  unfold centre
  have : (0 : ℝ) ≤ k := Nat.cast_nonneg k
  linarith

/-- Every height `t ≥ 11/10` lies within `9/10` of its band centre. -/
theorem idx_spec {t : ℝ} (ht : 11 / 10 ≤ t) : |t - centre (idx t)| ≤ 9 / 10 := by
  unfold centre idx
  set a := (t - 11 / 10) / (9 / 5) with ha
  have ha0 : 0 ≤ a := by
    rw [ha]
    apply div_nonneg <;> linarith
  have h1 : (⌊a⌋₊ : ℝ) ≤ a := Nat.floor_le ha0
  have h2 : a < ⌊a⌋₊ + 1 := Nat.lt_floor_add_one a
  have hu : t - 11 / 10 = 9 / 5 * a := by
    rw [ha]
    field_simp
  rw [abs_le]
  constructor <;> linarith [h1, h2, hu]

/-- The on-line term is a real square, hence nonnegative. -/
theorem online_term_nonneg {h : ℝ} (hh : 0 < h) (γ : ℝ) {ρ : ℂ} (hρ : ρ.re = 1 / 2) :
    0 ≤ (laplace (phiC h γ) (-ρ) * laplace (phiC h γ) (-(1 - ρ))).re := by
  rw [online_term_eq hh γ hρ, Complex.ofReal_re]
  positivity

theorem weightedTerm_nonneg {h : ℝ} (hh : 0 < h) (γ : ℝ) (ρ : Kadiri.NontrivialZeros)
    (hρ : (ρ : ℂ).re = 1 / 2) : 0 ≤ weightedTerm h γ ρ := by
  unfold weightedTerm
  apply mul_nonneg (online_term_nonneg hh γ hρ)
  exact_mod_cast (Kadiri.riemannZeta_order_pos_nontrivialZero ρ).le

/-- **Sum by bands.** A finite set of on-line zeros of height `≥ 11/10`,
split by band index, has weighted sum at most the band series over the
indices that occur. -/
theorem sum_by_bands {h γ : ℝ} (S : Finset Kadiri.NontrivialZeros)
    (hS : ∀ ρ ∈ S, (ρ : ℂ).re = 1 / 2 ∧ 11 / 10 ≤ (ρ : ℂ).im)
    (M : ℕ → ℝ) (hM0 : ∀ k, 0 ≤ M k)
    (hM : ∀ ρ ∈ S, (laplace (phiC h γ) (-(ρ : ℂ)) * laplace (phiC h γ) (-(1 - (ρ : ℂ)))).re
      ≤ M (idx (ρ : ℂ).im)) :
    ∑ ρ ∈ S, weightedTerm h γ ρ
      ≤ ∑ k ∈ S.image (fun ρ : Kadiri.NontrivialZeros => idx (ρ : ℂ).im),
          M k * (15 * Real.log (centre k) + 73) := by
  rw [← Finset.sum_fiberwise_of_maps_to
    (t := S.image (fun ρ : Kadiri.NontrivialZeros => idx (ρ : ℂ).im))
    (g := fun ρ : Kadiri.NontrivialZeros => idx (ρ : ℂ).im)
    (fun ρ hρ => Finset.mem_image_of_mem _ hρ)]
  apply Finset.sum_le_sum
  intro k _
  apply band_sum_le (two_le_centre k)
  · intro ρ hρ
    rw [Finset.mem_filter] at hρ
    obtain ⟨hρS, hρk⟩ := hρ
    subst hρk
    exact ⟨(hS ρ hρS).1, idx_spec (hS ρ hρS).2⟩
  · exact hM0 k
  · intro ρ hρ
    rw [Finset.mem_filter] at hρ
    obtain ⟨hρS, hρk⟩ := hρ
    subst hρk
    exact hM ρ hρS

theorem bandSeries_nonneg (M : ℕ → ℝ) (hM0 : ∀ k, 0 ≤ M k) (k : ℕ) :
    0 ≤ M k * (15 * Real.log (centre k) + 73) := by
  apply mul_nonneg (hM0 k)
  have : 0 ≤ Real.log (centre k) := Real.log_nonneg (by linarith [two_le_centre k])
  linarith

/-- A finite on-line sum of height `≥ 11/10` is at most the full band series. -/
theorem sum_le_bandSeries {h γ : ℝ} (S : Finset Kadiri.NontrivialZeros)
    (hS : ∀ ρ ∈ S, (ρ : ℂ).re = 1 / 2 ∧ 11 / 10 ≤ (ρ : ℂ).im)
    (M : ℕ → ℝ) (hM0 : ∀ k, 0 ≤ M k)
    (hM : ∀ ρ ∈ S, (laplace (phiC h γ) (-(ρ : ℂ)) * laplace (phiC h γ) (-(1 - (ρ : ℂ)))).re
      ≤ M (idx (ρ : ℂ).im))
    (hsum : Summable (fun k : ℕ => M k * (15 * Real.log (centre k) + 73))) :
    ∑ ρ ∈ S, weightedTerm h γ ρ ≤ ∑' k : ℕ, M k * (15 * Real.log (centre k) + 73) := by
  refine (sum_by_bands S hS M hM0 hM).trans ?_
  exact hsum.sum_le_tsum _ (fun k _ => bandSeries_nonneg M hM0 k)

/-- On-line zeros of height at least `11/10`. -/
abbrev Upper : Type :=
  {ρ : Kadiri.NontrivialZeros // (ρ : ℂ).re = 1 / 2 ∧ 11 / 10 ≤ (ρ : ℂ).im}

/-- **Upper on-line sum.** The full weighted sum over on-line zeros of height
`≥ 11/10` is at most the band series, for any nonnegative summable `M`
dominating the terms at their band indices. -/
theorem tsum_upper_le {h γ : ℝ} (hh : 0 < h) (M : ℕ → ℝ) (hM0 : ∀ k, 0 ≤ M k)
    (hM : ∀ ρ : Kadiri.NontrivialZeros, (ρ : ℂ).re = 1 / 2 → 11 / 10 ≤ (ρ : ℂ).im →
      (laplace (phiC h γ) (-(ρ : ℂ)) * laplace (phiC h γ) (-(1 - (ρ : ℂ)))).re
        ≤ M (idx (ρ : ℂ).im))
    (hsum : Summable (fun k : ℕ => M k * (15 * Real.log (centre k) + 73))) :
    ∑' ρ : Upper, weightedTerm h γ ρ.1 ≤ ∑' k : ℕ, M k * (15 * Real.log (centre k) + 73) := by
  apply Real.tsum_le_of_sum_le
  · intro ρ
    exact weightedTerm_nonneg hh γ ρ.1 ρ.2.1
  · intro s
    have hinj : ∀ a ∈ s, ∀ b ∈ s, (a : Kadiri.NontrivialZeros) = b → a = b :=
      fun a _ b _ hab => Subtype.ext hab
    rw [← Finset.sum_image (f := weightedTerm h γ) hinj]
    apply sum_le_bandSeries (s.image Subtype.val) _ M hM0 _ hsum
    · intro ρ hρ
      rw [Finset.mem_image] at hρ
      obtain ⟨σ, _, rfl⟩ := hρ
      exact σ.2
    · intro ρ hρ
      rw [Finset.mem_image] at hρ
      obtain ⟨σ, _, rfl⟩ := hρ
      exact hM σ.1 σ.2.1 σ.2.2

end

/-- info: 'WeilTiles.idx_spec' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms idx_spec

/-- info: 'WeilTiles.sum_by_bands' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms sum_by_bands

/-- info: 'WeilTiles.tsum_upper_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms tsum_upper_le

end WeilTiles
