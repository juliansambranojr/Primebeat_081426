/-
JointSymbol — joint 9a of `SECTIONS.md`: the table of `G` along the doublings
and the symbol, on the transform side.
Block 9a of `lean_stage3/design/joints.md`. 2026-11-22.

`dd f y = f y − f (y/2)` is one difference along the doublings; `dd^[d]` is
depth `d`, and at `y = 2^r` its rule is the table's rule (`dd_iter_rule`).
`cutG` is `G` on `y > 1` and `0` below: the row starts at the first regime.

  dd, cutG               the two definitions
  mellin_shift           f = 0 on y ≤ 1, f·y^(−s−1) integrable on (1, ∞) :
                           the same for f(·/2), and
                           ∫₁^∞ f(y/2)·y^(−s−1) = 2^(−s) · ∫₁^∞ f(y)·y^(−s−1)
  mellin_dd_iter         (hs : 1 < s.re) (d) :
                           ∫₁^∞ (dd^[d] cutG)(y)·y^(−s−1) dy = (1 − 2^(−s))^d · Phi s
  dd_iter_rule           (dd^[d+1] f) y = (dd^[d] f) y − (dd^[d] f) (y/2)
  symPhi_principal_part  (h0 : ρ ≠ 0) (h1 : ρ ≠ 1) (hz : ζ ρ = 0) (d) :
                           near ρ and off it, (1 − 2^(−s))^d · Phi s
                             = h s + (1 − 2^(−ρ))^d · A/(s − ρ),  A = m/(ρ(1−ρ))

`1 − 2^(−s)` is the symbol `Chain.Sym 2 s` of the table's tree (`lean/Chain.lean`,
on the other toolchain; written out here). In that tree one difference
multiplies a single mode by the symbol (`A1`, `A4`), and a finite sum of
modes is reweighted mode by mode (`Superposition.depth_reweights_each_mode`).
Here the same holds for the whole row of `G` at once, on its transform: each
zero's pole is reweighted by the symbol to the power of the depth.

Not here: the cell as a pointwise sum over the zeros, which needs the
explicit formula for `G` as a theorem.

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.LandauPoleLocal

namespace JointSymbol

noncomputable section

open Complex MeasureTheory Set Filter Topology

/-- One difference along the doublings. -/
def dd (f : ℝ → ℂ) : ℝ → ℂ := fun y => f y - f (y / 2)

/-- `G` on `y > 1`, zero below: the row starts at the first regime. -/
def cutG (y : ℝ) : ℂ := if 1 < y then (LandauWindow.G y : ℂ) else 0

/-- If `f` vanishes on `y ≤ 1` and `f(y)·y^(−s−1)` is integrable on `(1, ∞)`, then
`f(y/2)·y^(−s−1)` is integrable there and its integral is `2^(−s)` times that of
`f(y)·y^(−s−1)`. -/
theorem mellin_shift {s : ℂ} {f : ℝ → ℂ} (hf0 : ∀ y : ℝ, y ≤ 1 → f y = 0)
    (hint : IntegrableOn (fun y : ℝ => f y * (y : ℂ) ^ (-s - 1)) (Ioi 1)) :
    IntegrableOn (fun y : ℝ => f (y / 2) * (y : ℂ) ^ (-s - 1)) (Ioi 1) ∧
      ∫ y in Ioi (1 : ℝ), f (y / 2) * (y : ℂ) ^ (-s - 1)
        = (2 : ℂ) ^ (-s) * ∫ y in Ioi (1 : ℝ), f y * (y : ℂ) ^ (-s - 1) := by
  obtain ⟨F, hF⟩ : ∃ F : ℝ → ℂ, F = fun y : ℝ => f (y / 2) * (y : ℂ) ^ (-s - 1) := ⟨_, rfl⟩
  -- F at 2x
  have hF2 : ∀ x ∈ Ioi (1 : ℝ),
      (2 : ℂ) ^ (-s - 1) * (f x * (x : ℂ) ^ (-s - 1)) = F (2 * x) := by
    intro x hx
    have hx0 : (0 : ℝ) ≤ x := by linarith [mem_Ioi.mp hx]
    have e1 : 2 * x / 2 = x := by ring
    have e2 : ((2 * x : ℝ) : ℂ) ^ (-s - 1) = (2 : ℂ) ^ (-s - 1) * (x : ℂ) ^ (-s - 1) := by
      have := Complex.mul_cpow_ofReal_nonneg (by norm_num : (0 : ℝ) ≤ 2) hx0 (-s - 1)
      push_cast at this ⊢
      exact this
    rw [hF]
    simp only []
    rw [e1, e2]
    ring
  have hFint2 : IntegrableOn F (Ioi 2) := by
    have h1 : IntegrableOn (fun x : ℝ => F (2 * x)) (Ioi 1) :=
      IntegrableOn.congr_fun (hint.const_mul ((2 : ℂ) ^ (-s - 1))) hF2 measurableSet_Ioi
    have := (integrableOn_Ioi_comp_mul_left_iff F 1 (by norm_num : (0 : ℝ) < 2)).mp h1
    simpa using this
  -- F vanishes on y ≤ 2
  have hFind : F = (Ioi (2 : ℝ)).indicator F := by
    funext y
    by_cases hy : 2 < y
    · rw [Set.indicator_of_mem (mem_Ioi.mpr hy)]
    · rw [Set.indicator_of_notMem (by simpa using hy), hF]
      simp only []
      rw [hf0 (y / 2) (by linarith [not_lt.mp hy]), zero_mul]
  have hFint : Integrable F := by
    rw [hFind]
    exact hFint2.integrable_indicator measurableSet_Ioi
  refine ⟨by rw [← hF]; exact hFint.integrableOn, ?_⟩
  have hsub : Ioi (1 : ℝ) ∩ Ioi 2 = Ioi 2 :=
    inter_eq_right.mpr (Ioi_subset_Ioi (by norm_num))
  have h1 : ∫ y in Ioi (1 : ℝ), F y = ∫ y in Ioi (2 : ℝ), F y := by
    conv_lhs => rw [hFind]
    rw [setIntegral_indicator measurableSet_Ioi, hsub]
  have h2 := integral_comp_mul_left_Ioi F 1 (by norm_num : (0 : ℝ) < 2)
  rw [mul_one] at h2
  have h3 : ∫ x in Ioi (1 : ℝ), F (2 * x)
      = (2 : ℂ) ^ (-s - 1) * ∫ y in Ioi (1 : ℝ), f y * (y : ℂ) ^ (-s - 1) := by
    rw [← integral_const_mul]
    exact (setIntegral_congr_fun measurableSet_Ioi hF2).symm
  have h4 : ∫ y in Ioi (2 : ℝ), F y = 2 * ∫ x in Ioi (1 : ℝ), F (2 * x) := by
    rw [h2, Complex.real_smul]
    push_cast
    field_simp
  have hpow : (2 : ℂ) * (2 : ℂ) ^ (-s - 1) = (2 : ℂ) ^ (-s) := by
    rw [Complex.cpow_sub _ _ (two_ne_zero), Complex.cpow_one]
    field_simp
  rw [← hF, h1, h4, h3, ← mul_assoc, hpow]

/-- `dd` keeps the two hypotheses and multiplies the transform by the symbol. -/
private lemma mellin_dd {s : ℂ} {f : ℝ → ℂ} (hf0 : ∀ y : ℝ, y ≤ 1 → f y = 0)
    (hint : IntegrableOn (fun y : ℝ => f y * (y : ℂ) ^ (-s - 1)) (Ioi 1)) :
    (∀ y : ℝ, y ≤ 1 → dd f y = 0) ∧
    IntegrableOn (fun y : ℝ => dd f y * (y : ℂ) ^ (-s - 1)) (Ioi 1) ∧
      ∫ y in Ioi (1 : ℝ), dd f y * (y : ℂ) ^ (-s - 1)
        = (1 - (2 : ℂ) ^ (-s)) * ∫ y in Ioi (1 : ℝ), f y * (y : ℂ) ^ (-s - 1) := by
  obtain ⟨hSint, hS⟩ := mellin_shift hf0 hint
  have heq : (fun y : ℝ => dd f y * (y : ℂ) ^ (-s - 1))
      = fun y : ℝ => f y * (y : ℂ) ^ (-s - 1) - f (y / 2) * (y : ℂ) ^ (-s - 1) := by
    funext y; rw [dd]; ring
  refine ⟨fun y hy => ?_, ?_, ?_⟩
  · rw [dd, hf0 y hy, hf0 (y / 2) (by linarith), sub_zero]
  · rw [heq]; exact hint.sub hSint
  · rw [heq, integral_sub hint hSint, hS]; ring

/-- If `f` vanishes on `y ≤ 1` and `f(y)·y^(−s−1)` is integrable on `(1, ∞)`, then the
depth-`d` difference `dd^[d] f` has both properties and its transform over `(1, ∞)` is
`(1 − 2^(−s))^d` times the transform of `f`. -/
private lemma mellin_dd_iter_aux {s : ℂ} {f : ℝ → ℂ} (hf0 : ∀ y : ℝ, y ≤ 1 → f y = 0)
    (hint : IntegrableOn (fun y : ℝ => f y * (y : ℂ) ^ (-s - 1)) (Ioi 1)) (d : ℕ) :
    (∀ y : ℝ, y ≤ 1 → (dd^[d] f) y = 0) ∧
    IntegrableOn (fun y : ℝ => (dd^[d] f) y * (y : ℂ) ^ (-s - 1)) (Ioi 1) ∧
      ∫ y in Ioi (1 : ℝ), (dd^[d] f) y * (y : ℂ) ^ (-s - 1)
        = (1 - (2 : ℂ) ^ (-s)) ^ d * ∫ y in Ioi (1 : ℝ), f y * (y : ℂ) ^ (-s - 1) := by
  induction d with
  | zero => exact ⟨hf0, hint, by simp⟩
  | succ d ih =>
    obtain ⟨h0, hi, he⟩ := ih
    obtain ⟨h0', hi', he'⟩ := mellin_dd h0 hi
    rw [Function.iterate_succ_apply']
    refine ⟨h0', hi', ?_⟩
    rw [he', he, pow_succ]
    ring

/-- For `Re s > 1` and depth `d`, the transform of the depth-`d` difference of the cut row:
`∫₁^∞ (dd^[d] cutG)(y)·y^(−s−1) dy = (1 − 2^(−s))^d · Phi s`. -/
theorem mellin_dd_iter {s : ℂ} (hs : 1 < s.re) (d : ℕ) :
    ∫ y in Ioi (1 : ℝ), (dd^[d] cutG) y * (y : ℂ) ^ (-s - 1)
      = (1 - (2 : ℂ) ^ (-s)) ^ d * LandauMellinG.Phi s := by
  have hcut0 : ∀ y : ℝ, y ≤ 1 → cutG y = 0 := by
    intro y hy
    rw [cutG, if_neg (not_lt.mpr hy)]
  have hcutG : ∀ y ∈ Ioi (1 : ℝ),
      (LandauWindow.G y : ℂ) * (y : ℂ) ^ (-s - 1) = cutG y * (y : ℂ) ^ (-s - 1) := by
    intro y hy
    rw [cutG, if_pos (mem_Ioi.mp hy)]
  have hint : IntegrableOn (fun y : ℝ => cutG y * (y : ℂ) ^ (-s - 1)) (Ioi 1) :=
    (LandauMellinG.G_mellin_integrable hs).congr_fun hcutG measurableSet_Ioi
  have hM : ∫ y in Ioi (1 : ℝ), cutG y * (y : ℂ) ^ (-s - 1) = LandauMellinG.Phi s := by
    rw [← LandauMellinG.mellin_G hs]
    exact (setIntegral_congr_fun measurableSet_Ioi hcutG).symm
  rw [(mellin_dd_iter_aux hcut0 hint d).2.2, hM]

/-- The table's rule: the depth-`d+1` difference at `y` is the depth-`d` difference at `y`
minus the depth-`d` difference at `y/2`. -/
theorem dd_iter_rule (f : ℝ → ℂ) (d : ℕ) (y : ℝ) :
    (dd^[d + 1] f) y = (dd^[d] f) y - (dd^[d] f) (y / 2) := by
  rw [Function.iterate_succ_apply']
  rfl

/-- For a zero `ρ` of `riemannZeta` with `ρ ≠ 0` and `ρ ≠ 1`, and any depth `d`: near `ρ`
and off it, `(1 − 2^(−s))^d · Phi s` is a function analytic at `ρ` plus
`(1 − 2^(−ρ))^d · A/(s − ρ)`, where `A = m/(ρ(1−ρ))` and `m` is the order of the zero. -/
theorem symPhi_principal_part {ρ : ℂ} (h0 : ρ ≠ 0) (h1 : ρ ≠ 1)
    (hz : riemannZeta ρ = 0) (d : ℕ) :
    ∃ h : ℂ → ℂ, AnalyticAt ℂ h ρ ∧ ∀ᶠ s in 𝓝[≠] ρ,
      (1 - (2 : ℂ) ^ (-s)) ^ d * LandauMellinG.Phi s
        = h s + (1 - (2 : ℂ) ^ (-ρ)) ^ d
            * ((analyticOrderNatAt riemannZeta ρ : ℂ) / (ρ * (1 - ρ))) / (s - ρ) := by
  obtain ⟨h₀, hh₀, he⟩ := LandauPoleLocal.Phi_principal_part h0 h1 hz
  obtain ⟨f, hf⟩ : ∃ f : ℂ → ℂ, f = fun s : ℂ => (1 - (2 : ℂ) ^ (-s)) ^ d := ⟨_, rfl⟩
  have hfd : Differentiable ℂ f := by
    rw [hf]
    intro s
    have h2 : DifferentiableAt ℂ (fun s : ℂ => (2 : ℂ) ^ (-s)) s :=
      (differentiableAt_id.neg).const_cpow (Or.inl two_ne_zero)
    exact ((differentiableAt_const (1 : ℂ)).sub h2).pow d
  have hfa : AnalyticAt ℂ f ρ := hfd.analyticAt ρ
  have hds : AnalyticAt ℂ (dslope f ρ) ρ :=
    ((Complex.differentiableOn_dslope (s := Set.univ) Filter.univ_mem).mpr
      hfd.differentiableOn).analyticAt Filter.univ_mem
  refine ⟨fun s => f s * h₀ s
      + (analyticOrderNatAt riemannZeta ρ : ℂ) / (ρ * (1 - ρ)) * dslope f ρ s,
    (hfa.mul hh₀).add (analyticAt_const.mul hds), ?_⟩
  filter_upwards [he, self_mem_nhdsWithin] with s hs hsρ
  have hsρ' : s ≠ ρ := hsρ
  have hne : s - ρ ≠ 0 := sub_ne_zero.mpr hsρ'
  have hfs : (1 - (2 : ℂ) ^ (-s)) ^ d = f s := by rw [hf]
  have hfρ : (1 - (2 : ℂ) ^ (-ρ)) ^ d = f ρ := by rw [hf]
  rw [hs, hfs, hfρ, dslope_of_ne _ hsρ', slope_def_field]
  field_simp
  try ring

/-- info: 'JointSymbol.mellin_dd_iter' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms mellin_dd_iter

/-- info: 'JointSymbol.dd_iter_rule' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms dd_iter_rule

/-- info: 'JointSymbol.symPhi_principal_part' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms symPhi_principal_part

end

end JointSymbol
