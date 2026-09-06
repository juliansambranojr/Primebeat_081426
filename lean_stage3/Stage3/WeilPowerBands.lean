/-
WeilPowerBands — the on-line background of the switched window over the
upper heights: bands, tiles and the explicit band series. Rung 5, seventh
slice. 2026-09-06.

Units 0321–0323 did this for the raised-cosine window, and their statements
name that window's test function, so they cannot be reused as they stand.
This module repeats them for the switched window `W h γ m` of unit 0330,
with two changes and one new fact.

The term. `termW h γ m ρ` is the real part of the zero form's term at the
window, `weightedTermW` that times the multiplicity. On the line it is
nonnegative (unit 0332), so the whole machinery of unit 0321's band count
applies: `band_sum_le`, `sum_by_bands`, `sum_le_bandSeries`, `tsum_upper_le`
are unit 0321's and 0322's proofs word for word.

The near band is wider. Unit 0332's far bound needs `h|γ_ρ − γ|` at least
`√2·π(m+1)`; read off the band gap that is `|k − k₀|` above
`r = max 1 (5(m+1)/h)`. So `M` takes the near bound `4h²` on bands within
`r` of the band of `γ` and the far bound beyond.

The far bound keeps its power. Beyond `r` the far term is at most
`h²·cS²·(2/(h|γ_ρ−γ|)²)^{2m+2}`, and with `h|γ_ρ−γ| ≥ (9/10)h|k−k₀|`
and `h|k−k₀| > 5(m+1)` this is at most `cFarM m / (h²|k−k₀|⁴)` with

    cFarM m = cS m² · (200/81)² · (10(m+1)²)^{−2m},

the power `2m` absorbing the factorials in `cS`: `cFarM_le` shows
`cFarM m ≤ 1000(m+1)²`, using `(2m+1)! ≤ (2m+1)^{2m+1}` and `π⁴ < 100`.
That is the fact unit 0331's crude series could not give: the far
constant is polynomial in `m`, so the whole background is polynomial in
`h`, `m` and the height, against a main term exponential in `h`.

The rest is unit 0323 with `K + 3` replaced by `K + r + 2`:
`A h γ m = 88·(idx γ + r + 2)⁴·(4h² + cFarM m/h²)`, each band term at most
`A/(k+1)³`, the series summable and at most `A·π²/6`, and the upper
on-line sum at most `88·(γ + r + 2)⁴·(4h² + cFarM m/h²)·π²/6`.

Axioms: every theorem pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.WeilPowerBackground
import Stage3.WeilSeries
import Mathlib.Analysis.Real.Pi.Bounds

namespace WeilPowerBands

noncomputable section

open Complex WeilDetect WeilBands WeilTiles WeilSeries WeilOddPower WeilPowerBounds
  WeilPowerBackground Real

/-- The term of the zero form at the switched window, real part. -/
def termW (h γ : ℝ) (m : ℕ) (ρ : ℂ) : ℝ :=
  (laplace (phiWC h γ m) (-ρ) * laplace (phiWC h γ m) (-(1 - ρ))).re

/-- The term with its multiplicity. -/
def weightedTermW (h γ : ℝ) (m : ℕ) (ρ : Kadiri.NontrivialZeros) : ℝ :=
  termW h γ m ρ * ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ)

theorem termW_nonneg {h : ℝ} (hh : 0 < h) (γ : ℝ) (m : ℕ) {ρ : ℂ} (hρ : ρ.re = 1 / 2) :
    0 ≤ termW h γ m ρ :=
  online_term_nonneg hh γ m hρ

theorem weightedTermW_nonneg {h : ℝ} (hh : 0 < h) (γ : ℝ) (m : ℕ) (ρ : Kadiri.NontrivialZeros)
    (hρ : (ρ : ℂ).re = 1 / 2) : 0 ≤ weightedTermW h γ m ρ := by
  unfold weightedTermW
  apply mul_nonneg (termW_nonneg hh γ m hρ)
  exact_mod_cast (Kadiri.riemannZeta_order_pos_nontrivialZero ρ).le

/-- **Band sum.** Unit 0321's, for the switched window. -/
theorem band_sum_le {h γ T : ℝ} (m : ℕ) (hT : 2 ≤ T) (S : Finset Kadiri.NontrivialZeros)
    (hS : ∀ ρ ∈ S, (ρ : ℂ).re = 1 / 2 ∧ |(ρ : ℂ).im - T| ≤ 9 / 10)
    {M : ℝ} (hM0 : 0 ≤ M) (hM : ∀ ρ ∈ S, termW h γ m ρ ≤ M) :
    ∑ ρ ∈ S, weightedTermW h γ m ρ ≤ M * (15 * Real.log T + 73) := by
  have hord : ∀ ρ : Kadiri.NontrivialZeros, (0 : ℝ) ≤ ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) :=
    fun ρ => by exact_mod_cast (Kadiri.riemannZeta_order_pos_nontrivialZero ρ).le
  have h1 : ∑ ρ ∈ S, weightedTermW h γ m ρ
      ≤ ∑ ρ ∈ S, M * ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) := by
    apply Finset.sum_le_sum
    intro ρ hρ
    unfold weightedTermW
    exact mul_le_mul_of_nonneg_right (hM ρ hρ) (hord ρ)
  have h2 : ∑ ρ ∈ S, M * ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ)
      = M * ∑ ρ ∈ S, (analyticOrderNatAt riemannZeta (ρ : ℂ) : ℝ) := by
    rw [← Finset.mul_sum]
    congr 1
    apply Finset.sum_congr rfl
    intro ρ _
    exact order_eq_analyticOrderNatAt ρ
  have h3 : ∑ ρ ∈ S, (analyticOrderNatAt riemannZeta (ρ : ℂ) : ℝ)
      = ∑ z ∈ S.image (fun ρ : Kadiri.NontrivialZeros => (ρ : ℂ)),
          (analyticOrderNatAt riemannZeta z : ℝ) := by
    rw [Finset.sum_image]
    intro a _ b _ hab
    exact Subtype.ext hab
  have h4 : ∑ z ∈ S.image (fun ρ : Kadiri.NontrivialZeros => (ρ : ℂ)),
      (analyticOrderNatAt riemannZeta z : ℝ) ≤ 15 * Real.log T + 73 := by
    apply band_count hT
    intro z hz
    rw [Finset.mem_image] at hz
    obtain ⟨ρ, hρ, rfl⟩ := hz
    exact ⟨Kadiri.riemannZeta_nontrivialZero_zero ρ, (hS ρ hρ).1, (hS ρ hρ).2⟩
  calc ∑ ρ ∈ S, weightedTermW h γ m ρ
      ≤ ∑ ρ ∈ S, M * ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) := h1
    _ = M * ∑ ρ ∈ S, (analyticOrderNatAt riemannZeta (ρ : ℂ) : ℝ) := h2
    _ = M * ∑ z ∈ S.image (fun ρ : Kadiri.NontrivialZeros => (ρ : ℂ)),
          (analyticOrderNatAt riemannZeta z : ℝ) := by rw [h3]
    _ ≤ M * (15 * Real.log T + 73) := mul_le_mul_of_nonneg_left h4 hM0

/-- **Sum by bands.** Unit 0322's. -/
theorem sum_by_bands {h γ : ℝ} (m : ℕ) (S : Finset Kadiri.NontrivialZeros)
    (hS : ∀ ρ ∈ S, (ρ : ℂ).re = 1 / 2 ∧ 11 / 10 ≤ (ρ : ℂ).im)
    (M : ℕ → ℝ) (hM0 : ∀ k, 0 ≤ M k)
    (hM : ∀ ρ ∈ S, termW h γ m ρ ≤ M (idx (ρ : ℂ).im)) :
    ∑ ρ ∈ S, weightedTermW h γ m ρ
      ≤ ∑ k ∈ S.image (fun ρ : Kadiri.NontrivialZeros => idx (ρ : ℂ).im),
          M k * (15 * Real.log (centre k) + 73) := by
  rw [← Finset.sum_fiberwise_of_maps_to
    (t := S.image (fun ρ : Kadiri.NontrivialZeros => idx (ρ : ℂ).im))
    (g := fun ρ : Kadiri.NontrivialZeros => idx (ρ : ℂ).im)
    (fun ρ hρ => Finset.mem_image_of_mem _ hρ)]
  apply Finset.sum_le_sum
  intro k _
  apply band_sum_le m (two_le_centre k)
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

theorem sum_le_bandSeries {h γ : ℝ} (m : ℕ) (S : Finset Kadiri.NontrivialZeros)
    (hS : ∀ ρ ∈ S, (ρ : ℂ).re = 1 / 2 ∧ 11 / 10 ≤ (ρ : ℂ).im)
    (M : ℕ → ℝ) (hM0 : ∀ k, 0 ≤ M k)
    (hM : ∀ ρ ∈ S, termW h γ m ρ ≤ M (idx (ρ : ℂ).im))
    (hsum : Summable (fun k : ℕ => M k * (15 * Real.log (centre k) + 73))) :
    ∑ ρ ∈ S, weightedTermW h γ m ρ ≤ ∑' k : ℕ, M k * (15 * Real.log (centre k) + 73) := by
  refine (sum_by_bands m S hS M hM0 hM).trans ?_
  exact hsum.sum_le_tsum _ (fun k _ => bandSeries_nonneg M hM0 k)

/-- **Upper on-line sum.** Unit 0322's. -/
theorem tsum_upper_le {h γ : ℝ} (hh : 0 < h) (m : ℕ) (M : ℕ → ℝ) (hM0 : ∀ k, 0 ≤ M k)
    (hM : ∀ ρ : Kadiri.NontrivialZeros, (ρ : ℂ).re = 1 / 2 → 11 / 10 ≤ (ρ : ℂ).im →
      termW h γ m ρ ≤ M (idx (ρ : ℂ).im))
    (hsum : Summable (fun k : ℕ => M k * (15 * Real.log (centre k) + 73))) :
    ∑' ρ : Upper, weightedTermW h γ m ρ.1 ≤ ∑' k : ℕ, M k * (15 * Real.log (centre k) + 73) := by
  apply Real.tsum_le_of_sum_le
  · intro ρ
    exact weightedTermW_nonneg hh γ m ρ.1 ρ.2.1
  · intro s
    have hinj : ∀ a ∈ s, ∀ b ∈ s, (a : Kadiri.NontrivialZeros) = b → a = b :=
      fun a _ b _ hab => Subtype.ext hab
    rw [← Finset.sum_image (f := weightedTermW h γ m) hinj]
    apply sum_le_bandSeries m (s.image Subtype.val) _ M hM0 _ hsum
    · intro ρ hρ
      rw [Finset.mem_image] at hρ
      obtain ⟨σ, _, rfl⟩ := hρ
      exact σ.2
    · intro ρ hρ
      rw [Finset.mem_image] at hρ
      obtain ⟨σ, _, rfl⟩ := hρ
      exact hM σ.1 σ.2.1 σ.2.2

/-- The near-band radius, in band steps: `max 1 (5(m+1)/h)`. -/
def r (h : ℝ) (m : ℕ) : ℝ := max 1 (5 * ((m : ℝ) + 1) / h)

theorem one_le_r (h : ℝ) (m : ℕ) : 1 ≤ r h m := le_max_left _ _

/-- The far constant: `cS m² · (200/81)² · (10(m+1)²)^{−2m}`. -/
def cFarM (m : ℕ) : ℝ := cS m ^ 2 * (200 / 81) ^ 2 * (1 / (10 * ((m : ℝ) + 1) ^ 2)) ^ (2 * m)

theorem cFarM_nonneg (m : ℕ) : 0 ≤ cFarM m := by
  unfold cFarM
  positivity

/-- `(2m+1)! ≤ 2·4^m·(m+1)^{2m+1}`. -/
theorem factorial_odd_le (m : ℕ) :
    (((2 * m + 1).factorial : ℕ) : ℝ) ≤ 2 * 4 ^ m * ((m : ℝ) + 1) ^ (2 * m + 1) := by
  have h1 : (((2 * m + 1).factorial : ℕ) : ℝ) ≤ ((2 * m + 1 : ℕ) : ℝ) ^ (2 * m + 1) := by
    exact_mod_cast Nat.factorial_le_pow (2 * m + 1)
  have h2 : ((2 * m + 1 : ℕ) : ℝ) ^ (2 * m + 1) ≤ (2 * ((m : ℝ) + 1)) ^ (2 * m + 1) := by
    apply pow_le_pow_left₀ (by positivity)
    push_cast; linarith
  have h2' : (2 : ℝ) ^ (2 * m + 1) = 2 * 4 ^ m := by
    rw [pow_succ, pow_mul]
    norm_num
    ring
  have h3 : (2 * ((m : ℝ) + 1)) ^ (2 * m + 1) = 2 * 4 ^ m * ((m : ℝ) + 1) ^ (2 * m + 1) := by
    rw [mul_pow, h2']
  linarith

/-- `cS m ≤ 4·π^{2m+1}·(m+1)^{2m+1}`. -/
theorem cS_le (m : ℕ) : cS m ≤ 4 * Real.pi ^ (2 * m + 1) * ((m : ℝ) + 1) ^ (2 * m + 1) := by
  unfold cS
  have hf := factorial_odd_le m
  have h4 : (0 : ℝ) < 4 ^ m := by positivity
  have hpi : 0 < Real.pi ^ (2 * m + 1) := by positivity
  rw [div_le_iff₀ h4]
  calc 2 * Real.pi ^ (2 * m + 1) * (((2 * m + 1).factorial : ℕ) : ℝ)
      ≤ 2 * Real.pi ^ (2 * m + 1) * (2 * 4 ^ m * ((m : ℝ) + 1) ^ (2 * m + 1)) := by gcongr
    _ = 4 * Real.pi ^ (2 * m + 1) * ((m : ℝ) + 1) ^ (2 * m + 1) * 4 ^ m := by ring

/-- **The far constant is polynomial in `m`:** `cFarM m ≤ 1000·(m+1)²`. -/
theorem cFarM_le (m : ℕ) : cFarM m ≤ 1000 * ((m : ℝ) + 1) ^ 2 := by
  unfold cFarM
  have hc := cS_le m
  have hc0 := (cS_pos m).le
  have hm : (0 : ℝ) < (m : ℝ) + 1 := by positivity
  have hpi := Real.pi_pos
  have hpi2 : Real.pi ^ 2 < 10 := by
    have := Real.pi_lt_d2
    nlinarith [Real.pi_gt_three]
  have hsq : cS m ^ 2 ≤ (4 * Real.pi ^ (2 * m + 1) * ((m : ℝ) + 1) ^ (2 * m + 1)) ^ 2 :=
    pow_le_pow_left₀ hc0 hc 2
  have hpow : (1 / (10 * ((m : ℝ) + 1) ^ 2)) ^ (2 * m) = 1 / (100 ^ m * ((m : ℝ) + 1) ^ (4 * m)) := by
    rw [one_div_pow, mul_pow, ← pow_mul, show (10 : ℝ) ^ (2 * m) = 100 ^ m by
      rw [pow_mul]; norm_num]
    ring_nf
  rw [hpow]
  have hpi4 : Real.pi ^ 4 ≤ 100 := by nlinarith [hpi2, sq_nonneg (Real.pi ^ 2)]
  have hkey : (4 * Real.pi ^ (2 * m + 1) * ((m : ℝ) + 1) ^ (2 * m + 1)) ^ 2
      * (1 / (100 ^ m * ((m : ℝ) + 1) ^ (4 * m)))
      = 16 * Real.pi ^ 2 * ((m : ℝ) + 1) ^ 2 * (Real.pi ^ 4 / 100) ^ m := by
    rw [div_pow, mul_pow, mul_pow, ← pow_mul, ← pow_mul]
    field_simp
    ring
  have hratio : (Real.pi ^ 4 / 100) ^ m ≤ 1 := by
    apply pow_le_one₀ (by positivity)
    rw [div_le_one (by norm_num)]
    exact hpi4
  calc cS m ^ 2 * (200 / 81) ^ 2 * (1 / (100 ^ m * ((m : ℝ) + 1) ^ (4 * m)))
      ≤ (4 * Real.pi ^ (2 * m + 1) * ((m : ℝ) + 1) ^ (2 * m + 1)) ^ 2 * (200 / 81) ^ 2
          * (1 / (100 ^ m * ((m : ℝ) + 1) ^ (4 * m))) := by gcongr
    _ = (200 / 81) ^ 2 * (16 * Real.pi ^ 2 * ((m : ℝ) + 1) ^ 2 * (Real.pi ^ 4 / 100) ^ m) := by
        rw [← hkey]; ring
    _ ≤ (200 / 81) ^ 2 * (16 * Real.pi ^ 2 * ((m : ℝ) + 1) ^ 2 * 1) := by gcongr
    _ ≤ 1000 * ((m : ℝ) + 1) ^ 2 := by nlinarith [hpi2, sq_nonneg ((m : ℝ) + 1)]

/-- The dominating band series for the switched window. -/
def M (h γ : ℝ) (m : ℕ) (k : ℕ) : ℝ :=
  if |(k : ℝ) - (idx γ : ℝ)| ≤ r h m then 4 * h ^ 2
  else cFarM m / (h ^ 2 * |(k : ℝ) - (idx γ : ℝ)| ^ 4)

theorem M_nonneg (h γ : ℝ) (m k : ℕ) : 0 ≤ M h γ m k := by
  unfold M
  split_ifs
  · positivity
  · exact div_nonneg (cFarM_nonneg m) (by positivity)

/-- **Domination.** Every on-line term of height `≥ 11/10` is at most `M` at
its band index. -/
theorem term_le_M {h γ : ℝ} (hh : 0 < h) (hγ : 11 / 10 ≤ γ) (m : ℕ) (ρ : Kadiri.NontrivialZeros)
    (hre : (ρ : ℂ).re = 1 / 2) (him : 11 / 10 ≤ (ρ : ℂ).im) :
    termW h γ m ρ ≤ M h γ m (idx (ρ : ℂ).im) := by
  unfold M
  split_ifs with hnear
  · exact online_term_le_near hh γ m hre
  · push Not at hnear
    have hr := one_le_r h m
    have h1 : 1 < |(idx (ρ : ℂ).im : ℝ) - (idx γ : ℝ)| := lt_of_le_of_lt hr hnear
    have h2 := two_le_of_one_lt h1
    have h5 : 5 * ((m : ℝ) + 1) / h < |(idx (ρ : ℂ).im : ℝ) - (idx γ : ℝ)| :=
      lt_of_le_of_lt (le_max_right _ _) hnear
    set d := |(idx (ρ : ℂ).im : ℝ) - (idx γ : ℝ)| with hd
    set t := (ρ : ℂ).im with ht
    have hdist := dist_ge him hγ
    have hD : 9 / 10 * d ≤ |t - γ| := by linarith
    have hd0 : 0 < d := by linarith
    have hhd : 5 * ((m : ℝ) + 1) < h * d := by
      rw [div_lt_iff₀ hh] at h5; linarith
    have hm1 : (0 : ℝ) < (m : ℝ) + 1 := by positivity
    have hpi2 : Real.pi ^ 2 < 10 := by
      have := Real.pi_lt_d2
      nlinarith [Real.pi_gt_three]
    -- the far hypotheses
    have hsq1 : (9 / 10 * (h * d)) ^ 2 ≤ (h * (t - γ)) ^ 2 := by
      have : 9 / 10 * (h * d) ≤ h * |t - γ| := by nlinarith
      have h' : (h * |t - γ|) ^ 2 = (h * (t - γ)) ^ 2 := by
        rw [mul_pow, mul_pow, sq_abs]
      rw [← h']
      exact pow_le_pow_left₀ (by positivity) this 2
    have hfar1 : 2 * (Real.pi ^ 2 * ((m : ℝ) + 1) ^ 2) ≤ (h * (t - γ)) ^ 2 := by
      have : (4.5 * ((m : ℝ) + 1)) ^ 2 ≤ (9 / 10 * (h * d)) ^ 2 := by
        apply pow_le_pow_left₀ (by positivity)
        linarith
      nlinarith [sq_nonneg ((m : ℝ) + 1)]
    have hA : (t - γ) ^ 2 ≤ (t + γ) ^ 2 := by nlinarith [him, hγ]
    have hfar2 : 2 * (Real.pi ^ 2 * ((m : ℝ) + 1) ^ 2) ≤ (h * (t + γ)) ^ 2 := by
      have : (h * (t - γ)) ^ 2 ≤ (h * (t + γ)) ^ 2 := by
        rw [mul_pow, mul_pow]
        exact mul_le_mul_of_nonneg_left hA (by positivity)
      linarith
    refine (online_term_le_far hh γ m hre hfar1 hfar2).trans ?_
    -- the far term against its band gap
    have hne : (t - γ) ≠ 0 := by
      intro h0
      rw [h0, abs_zero] at hD
      linarith
    have hpos1 : 0 < (h * (t - γ)) ^ 2 := by positivity
    have hpos2 : 0 < (h * (t + γ)) ^ 2 := by positivity
    set a := cS m * (2 / (h * (t - γ)) ^ 2) ^ (m + 1) with ha
    set b := cS m * (2 / (h * (t + γ)) ^ 2) ^ (m + 1) with hb
    have hc0 := (cS_pos m).le
    have hba : b ≤ a := by
      rw [hb, ha]
      apply mul_le_mul_of_nonneg_left _ hc0
      apply pow_le_pow_left₀ (by positivity)
      apply div_le_div_of_nonneg_left (by norm_num) hpos1
      rw [mul_pow, mul_pow]
      exact mul_le_mul_of_nonneg_left hA (by positivity)
    have ha0 : 0 ≤ a := by rw [ha]; positivity
    have hab : (a + b) ^ 2 ≤ (2 * a) ^ 2 := by
      apply pow_le_pow_left₀ (by rw [hb]; positivity)
      linarith
    have hx : 2 / (h * (t - γ)) ^ 2 ≤ 200 / (81 * (h * d) ^ 2) := by
      rw [div_le_div_iff₀ hpos1 (by positivity)]
      nlinarith [hsq1]
    have hy : 200 / (81 * (h * d) ^ 2) ≤ 1 / (10 * ((m : ℝ) + 1) ^ 2) := by
      rw [div_le_div_iff₀ (by positivity) (by positivity)]
      have : (5 * ((m : ℝ) + 1)) ^ 2 ≤ (h * d) ^ 2 := pow_le_pow_left₀ (by positivity) hhd.le 2
      nlinarith
    have hx0 : 0 ≤ 2 / (h * (t - γ)) ^ 2 := by positivity
    have hpowx : (2 / (h * (t - γ)) ^ 2) ^ (2 * m + 2)
        ≤ (200 / (81 * (h * d) ^ 2)) ^ 2 * (1 / (10 * ((m : ℝ) + 1) ^ 2)) ^ (2 * m) := by
      calc (2 / (h * (t - γ)) ^ 2) ^ (2 * m + 2)
          ≤ (200 / (81 * (h * d) ^ 2)) ^ (2 * m + 2) := pow_le_pow_left₀ hx0 hx _
        _ = (200 / (81 * (h * d) ^ 2)) ^ 2 * (200 / (81 * (h * d) ^ 2)) ^ (2 * m) := by
            rw [show 2 * m + 2 = 2 + 2 * m by ring, pow_add]
        _ ≤ (200 / (81 * (h * d) ^ 2)) ^ 2 * (1 / (10 * ((m : ℝ) + 1) ^ 2)) ^ (2 * m) := by
            apply mul_le_mul_of_nonneg_left _ (by positivity)
            exact pow_le_pow_left₀ (by positivity) hy _
    calc (h / 2) ^ 2 * (a + b) ^ 2
        ≤ (h / 2) ^ 2 * (2 * a) ^ 2 := mul_le_mul_of_nonneg_left hab (by positivity)
      _ = h ^ 2 * cS m ^ 2 * (2 / (h * (t - γ)) ^ 2) ^ (2 * m + 2) := by
          rw [ha, mul_pow, mul_pow, ← pow_mul]
          ring_nf
      _ ≤ h ^ 2 * cS m ^ 2 * ((200 / (81 * (h * d) ^ 2)) ^ 2 * (1 / (10 * ((m : ℝ) + 1) ^ 2)) ^ (2 * m)) := by
          apply mul_le_mul_of_nonneg_left hpowx (by positivity)
      _ = cFarM m / (h ^ 2 * d ^ 4) := by
          unfold cFarM
          field_simp
          try ring

/-- The crude constant, with the wider near band. -/
def A (h γ : ℝ) (m : ℕ) : ℝ :=
  88 * ((idx γ : ℝ) + r h m + 2) ^ 4 * (4 * h ^ 2 + cFarM m / h ^ 2)

theorem four_h_add_nonneg (h : ℝ) (m : ℕ) : 0 ≤ 4 * h ^ 2 + cFarM m / h ^ 2 := by
  have h1 : 0 ≤ cFarM m / h ^ 2 := div_nonneg (cFarM_nonneg m) (sq_nonneg h)
  have h2 : 0 ≤ 4 * h ^ 2 := by positivity
  linarith

theorem A_nonneg (h γ : ℝ) (m : ℕ) : 0 ≤ A h γ m := by
  unfold A
  have := one_le_r h m
  exact mul_nonneg (mul_nonneg (by norm_num) (by positivity)) (four_h_add_nonneg h m)

/-- **Comparison.** Each band term is at most `A/(k+1)³`. -/
theorem bandTerm_le_A {h γ : ℝ} (hh : 0 < h) (m k : ℕ) :
    M h γ m k * (15 * Real.log (centre k) + 73) ≤ A h γ m / ((k : ℝ) + 1) ^ 3 := by
  set K := (idx γ : ℝ) with hK
  set R := r h m with hR
  have hR1 : 1 ≤ R := one_le_r h m
  have hK0 : 0 ≤ K := Nat.cast_nonneg _
  have hk0 : (0 : ℝ) ≤ k := Nat.cast_nonneg _
  have hw := weight_le k
  have hw0 := weight_nonneg k
  have hh' : h ≠ 0 := hh.ne'
  have hc4 := four_h_add_nonneg h m
  have hcF := cFarM_nonneg m
  unfold M A
  split_ifs with hnear
  · have hkK : (k : ℝ) ≤ K + R := by
      have := (abs_le.mp hnear).2
      linarith
    rw [le_div_iff₀ (by positivity)]
    have hk1 : (k : ℝ) + 1 ≤ K + R + 2 := by linarith
    have hp3 : ((k : ℝ) + 1) ^ 3 ≤ (K + R + 2) ^ 3 := pow_le_pow_left₀ (by positivity) hk1 3
    have hw' : 15 * Real.log (centre k) + 73 ≤ 88 * (K + R + 2) := by linarith
    calc 4 * h ^ 2 * (15 * Real.log (centre k) + 73) * ((k : ℝ) + 1) ^ 3
        ≤ 4 * h ^ 2 * (88 * (K + R + 2)) * (K + R + 2) ^ 3 := by
          apply mul_le_mul (mul_le_mul_of_nonneg_left hw' (by positivity)) hp3
            (by positivity) (by positivity)
      _ = 88 * (K + R + 2) ^ 4 * (4 * h ^ 2) := by ring
      _ ≤ 88 * (K + R + 2) ^ 4 * (4 * h ^ 2 + cFarM m / h ^ 2) := by
          apply mul_le_mul_of_nonneg_left _ (by positivity)
          have := div_nonneg hcF (sq_nonneg h)
          linarith
  · push Not at hnear
    have h1 : 1 < |(k : ℝ) - K| := lt_of_le_of_lt hR1 hnear
    have h2 := two_le_of_one_lt h1
    set d := |(k : ℝ) - K| with hd
    have hkd : (k : ℝ) - K ≤ d := le_abs_self _
    have hk1 : (k : ℝ) + 1 ≤ d * (K + R + 2) := by nlinarith
    have hp : ((k : ℝ) + 1) ^ 4 ≤ d ^ 4 * (K + R + 2) ^ 4 := by
      rw [← mul_pow]
      exact pow_le_pow_left₀ (by positivity) hk1 4
    have hd0 : 0 < d := by linarith
    rw [div_mul_eq_mul_div, div_le_div_iff₀ (by positivity) (by positivity)]
    have hw' : cFarM m * (15 * Real.log (centre k) + 73) ≤ cFarM m * (88 * ((k : ℝ) + 1)) :=
      mul_le_mul_of_nonneg_left hw hcF
    have e : 88 * (K + R + 2) ^ 4 * (4 * h ^ 2 + cFarM m / h ^ 2) * (h ^ 2 * d ^ 4)
        = 88 * (K + R + 2) ^ 4 * d ^ 4 * cFarM m + 88 * (K + R + 2) ^ 4 * d ^ 4 * (4 * h ^ 4) := by
      field_simp
      ring
    rw [e]
    have hpos : 0 ≤ 88 * (K + R + 2) ^ 4 * d ^ 4 * (4 * h ^ 4) := by positivity
    have h88 : 0 ≤ 88 * cFarM m := mul_nonneg (by norm_num) hcF
    calc cFarM m * (15 * Real.log (centre k) + 73) * ((k : ℝ) + 1) ^ 3
        ≤ cFarM m * (88 * ((k : ℝ) + 1)) * ((k : ℝ) + 1) ^ 3 :=
          mul_le_mul_of_nonneg_right hw' (by positivity)
      _ = 88 * cFarM m * ((k : ℝ) + 1) ^ 4 := by ring
      _ ≤ 88 * cFarM m * (d ^ 4 * (K + R + 2) ^ 4) := mul_le_mul_of_nonneg_left hp h88
      _ = 88 * (K + R + 2) ^ 4 * d ^ 4 * cFarM m := by ring
      _ ≤ 88 * (K + R + 2) ^ 4 * d ^ 4 * cFarM m + 88 * (K + R + 2) ^ 4 * d ^ 4 * (4 * h ^ 4) := by
          linarith

/-- **Summability** of the band series. -/
theorem bandSeries_summable {h γ : ℝ} (hh : 0 < h) (m : ℕ) :
    Summable (fun k : ℕ => M h γ m k * (15 * Real.log (centre k) + 73)) := by
  apply Summable.of_nonneg_of_le (fun k => bandSeries_nonneg (M h γ m) (M_nonneg h γ m) k)
    (fun k => bandTerm_le_A hh m k)
  refine (summable_shift3.mul_left (A h γ m)).congr ?_
  intro k
  ring

/-- **The band series in closed form:** at most `A·π²/6`. -/
theorem bandSeries_le {h γ : ℝ} (hh : 0 < h) (m : ℕ) :
    ∑' k : ℕ, M h γ m k * (15 * Real.log (centre k) + 73) ≤ A h γ m * (Real.pi ^ 2 / 6) := by
  have hA := A_nonneg h γ m
  calc ∑' k : ℕ, M h γ m k * (15 * Real.log (centre k) + 73)
      ≤ ∑' k : ℕ, A h γ m * (1 / ((k : ℝ) + 1) ^ 2) := by
        apply (bandSeries_summable hh m).tsum_le_tsum _ (summable_shift2.mul_left _)
        intro k
        refine (bandTerm_le_A hh m k).trans ?_
        rw [mul_one_div]
        apply div_le_div_of_nonneg_left hA (by positivity)
        exact pow_le_pow_right₀ (by linarith [Nat.cast_nonneg (α := ℝ) k]) (by norm_num)
    _ = A h γ m * ∑' k : ℕ, 1 / ((k : ℝ) + 1) ^ 2 := tsum_mul_left
    _ = A h γ m * (Real.pi ^ 2 / 6) := by rw [tsum_shift2]

/-- **Upper on-line background.** -/
theorem tsum_upper_le_explicit {h γ : ℝ} (hh : 0 < h) (hγ : 11 / 10 ≤ γ) (m : ℕ) :
    ∑' ρ : Upper, weightedTermW h γ m ρ.1 ≤ A h γ m * (Real.pi ^ 2 / 6) := by
  refine (tsum_upper_le hh m (M h γ m) (M_nonneg h γ m) ?_ (bandSeries_summable hh m)).trans
    (bandSeries_le hh m)
  intro ρ hre him
  exact term_le_M hh hγ m ρ hre him

theorem A_le {h γ : ℝ} (hγ : 11 / 10 ≤ γ) (m : ℕ) :
    A h γ m ≤ 88 * (γ + r h m + 2) ^ 4 * (4 * h ^ 2 + cFarM m / h ^ 2) := by
  unfold A
  have hi := idx_le hγ
  have hK0 : (0 : ℝ) ≤ idx γ := Nat.cast_nonneg _
  have hR := one_le_r h m
  have hp : ((idx γ : ℝ) + r h m + 2) ^ 4 ≤ (γ + r h m + 2) ^ 4 :=
    pow_le_pow_left₀ (by positivity) (by linarith) 4
  apply mul_le_mul_of_nonneg_right _ (four_h_add_nonneg h m)
  exact mul_le_mul_of_nonneg_left hp (by norm_num)

/-- **Upper on-line background, in `γ`, `h` and `m` alone:**
`≤ 88·(γ + r + 2)⁴·(4h² + cFarM m/h²)·π²/6`. -/
theorem tsum_upper_le_explicit' {h γ : ℝ} (hh : 0 < h) (hγ : 11 / 10 ≤ γ) (m : ℕ) :
    ∑' ρ : Upper, weightedTermW h γ m ρ.1
      ≤ 88 * (γ + r h m + 2) ^ 4 * (4 * h ^ 2 + cFarM m / h ^ 2) * (Real.pi ^ 2 / 6) := by
  refine (tsum_upper_le_explicit hh hγ m).trans ?_
  exact mul_le_mul_of_nonneg_right (A_le hγ m) (by positivity)

end

/-- info: 'WeilPowerBands.term_le_M' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms term_le_M

/-- info: 'WeilPowerBands.cFarM_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms cFarM_le

/-- info: 'WeilPowerBands.tsum_upper_le_explicit' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms tsum_upper_le_explicit

end WeilPowerBands
