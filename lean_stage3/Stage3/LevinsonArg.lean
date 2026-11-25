/-
LevinsonArg — block S11 of `lean_stage3/design/stencil.md`, step 1b. 2026-11-24.

The count on the line through a continuous argument. A continuous nonvanishing
`F` on `[a, b]` lifts through the covering `exp : ℂ → {z ≠ 0}`
(`Complex.isCoveringMap_exp`, `IsCoveringMap.exists_path_lifts`, after
reparametrizing `[a, b]` to `unitInterval`) to a continuous log `L`; its imaginary
part is a continuous argument `φ`, and `F = ‖F‖ · exp(iφ)`. If `φ` moves by at
least `kπ`, the intermediate value theorem hits `k` distinct levels
`(2j + 1)π/2`, so `cos φ` vanishes at `k` distinct points, sorted increasingly.
With `F = Gammaℝ · (ζ + c ζ')` on the line, `cos φ = 0` is `Re F = 0`, which is
`ζ = 0` where the real factor of `LevinsonLine.re_gammaR_G_line` is nonzero
(`LevinsonLine.zeta_line_zero_iff`); `k` distinct heights in `(0, T]` are `k`
distinct nontrivial zeros on the line, each of order at least one.

  lineF c t                 Gammaℝ s * (ζ s + c * ζ' s),  s = 1/2 + t i
  exists_log_lift           a ≤ b, F continuous and nonzero on [a, b]
                            ⊢ ∃ L continuous on [a, b], exp (L t) = F t there
  exists_arg_lift           a ≤ b, F continuous and nonzero on [a, b]
                            ⊢ ∃ φ continuous on [a, b], F t = ‖F t‖ * exp (φ t * I) there
  crossings_of_arg          a ≤ b, φ continuous on [a, b], k * π ≤ |φ b - φ a|
                            ⊢ ∃ t : Fin k → ℝ strictly increasing in [a, b],
                              cos (φ (t i)) = 0
  continuous_lineF          Continuous (lineF c)
  distinct_line_zeros_le_lineCount
                            γ : Fin k → ℝ injective, 0 < γ i ≤ T, ζ (1/2 + γ i * I) = 0
                            ⊢ (k : ℤ) ≤ lineCount T
  lineCount_ge_arg          0 < a ≤ b ≤ T, 1 - c * Re(Gammaℝ'/Gammaℝ) ≠ 0 on [a, b],
                            φ continuous on [a, b], lineF c t = ‖lineF c t‖ * exp (φ t * I)
                            there, k * π ≤ |φ b - φ a|  ⊢ (k : ℤ) ≤ lineCount T

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Mathlib.Analysis.Complex.CoveringMap
import Mathlib.Topology.Homotopy.Lifting
import Stage3.LevinsonLine
import Stage3.LineCount

namespace LevinsonArg

open Complex Kadiri LineCount

noncomputable section

/-- Levinson's function on the line: `Gammaℝ s · (ζ s + c ζ' s)` at `s = 1/2 + t i`. -/
noncomputable
def lineF (c : ℝ) (t : ℝ) : ℂ :=
  Gammaℝ (1/2 + t * I) * (riemannZeta (1/2 + t * I) + c * deriv riemannZeta (1/2 + t * I))

end

/-- A continuous nonvanishing `F` on `[a, b]` has a continuous logarithm there. -/
theorem exists_log_lift {F : ℝ → ℂ} {a b : ℝ} (hab : a ≤ b)
    (hc : ContinuousOn F (Set.Icc a b)) (hne : ∀ t ∈ Set.Icc a b, F t ≠ 0) :
    ∃ L : ℝ → ℂ, ContinuousOn L (Set.Icc a b) ∧
      ∀ t ∈ Set.Icc a b, Complex.exp (L t) = F t := by
  have ha : a ∈ Set.Icc a b := ⟨le_rfl, hab⟩
  rcases eq_or_lt_of_le hab with hab_eq | hab_lt
  · refine ⟨fun _ => Complex.log (F a), continuousOn_const, ?_⟩
    intro t ht
    have hta : t = a := by linarith [ht.1, ht.2]
    rw [hta, Complex.exp_log (hne a ha)]
  · have hba : 0 < b - a := by linarith
    -- the reparametrization `unitInterval → [a, b]`
    set r : unitInterval → ℝ := fun u => a + (u : ℝ) * (b - a) with hr_def
    have hr_cont : Continuous r := by
      simp only [hr_def]
      fun_prop
    have hr_mem : ∀ u, r u ∈ Set.Icc a b := by
      intro u
      have h0 : (0 : ℝ) ≤ u := u.2.1
      have h1 : (u : ℝ) ≤ 1 := u.2.2
      simp only [hr_def, Set.mem_Icc]
      constructor
      · nlinarith
      · nlinarith
    let γ : C(unitInterval, {z : ℂ // z ≠ 0}) :=
      ⟨fun u => ⟨F (r u), hne _ (hr_mem u)⟩,
        (hc.comp_continuous hr_cont hr_mem).subtype_mk _⟩
    have hγ0 : γ 0 = ⟨Complex.exp (Complex.log (F a)), Complex.exp_ne_zero _⟩ := by
      apply Subtype.ext
      simp [γ, hr_def, Complex.exp_log (hne a ha)]
    obtain ⟨Γ, hΓ, -⟩ := Complex.isCoveringMap_exp.exists_path_lifts γ
      (Complex.log (F a)) hγ0
    have hΓu : ∀ u, Complex.exp (Γ u) = F (r u) := by
      intro u
      have h := congrArg Subtype.val (congrFun hΓ u)
      simpa [γ] using h
    -- the inverse reparametrization `ℝ → unitInterval`
    set s : ℝ → unitInterval := fun t =>
      Set.projIcc (0 : ℝ) 1 zero_le_one ((t - a) / (b - a)) with hs_def
    have hs_cont : Continuous s := by
      simp only [hs_def]
      exact continuous_projIcc.comp (by fun_prop)
    have hrs : ∀ t ∈ Set.Icc a b, r (s t) = t := by
      intro t ht
      have hmem : (t - a) / (b - a) ∈ Set.Icc (0 : ℝ) 1 := by
        constructor
        · exact div_nonneg (by linarith [ht.1]) hba.le
        · rw [div_le_one hba]
          linarith [ht.2]
      have hst : ((s t : unitInterval) : ℝ) = (t - a) / (b - a) := by
        simp only [hs_def, Set.projIcc_of_mem _ hmem]
      simp only [hr_def, hst]
      field_simp
      try ring
    refine ⟨fun t => Γ (s t), (Γ.continuous.comp hs_cont).continuousOn, ?_⟩
    intro t ht
    simp only
    rw [hΓu, hrs t ht]

/-- **Target 1.** A continuous nonvanishing `F` on `[a, b]` has a continuous argument
there: `F t = ‖F t‖ · exp(i φ t)`. -/
theorem exists_arg_lift {F : ℝ → ℂ} {a b : ℝ} (hab : a ≤ b)
    (hc : ContinuousOn F (Set.Icc a b)) (hne : ∀ t ∈ Set.Icc a b, F t ≠ 0) :
    ∃ φ : ℝ → ℝ, ContinuousOn φ (Set.Icc a b) ∧
      ∀ t ∈ Set.Icc a b, F t = ‖F t‖ * Complex.exp (φ t * Complex.I) := by
  obtain ⟨L, hLc, hLe⟩ := exists_log_lift hab hc hne
  refine ⟨fun t => (L t).im, Complex.continuous_im.comp_continuousOn hLc, ?_⟩
  intro t ht
  rw [← hLe t ht, Complex.norm_exp]
  conv_lhs => rw [← Complex.re_add_im (L t)]
  rw [Complex.exp_add, Complex.ofReal_exp]

/-- The increasing case of `crossings_of_arg`. -/
theorem crossings_of_le {φ : ℝ → ℝ} {a b : ℝ} (hab : a ≤ b)
    (hc : ContinuousOn φ (Set.Icc a b)) (k : ℕ)
    (hk : (k : ℝ) * Real.pi ≤ φ b - φ a) :
    ∃ t : Fin k → ℝ, StrictMono t ∧ (∀ i, t i ∈ Set.Icc a b) ∧
      ∀ i, Real.cos (φ (t i)) = 0 := by
  have hπ := Real.pi_pos
  set m : ℤ := ⌈(φ a - Real.pi / 2) / Real.pi⌉ with hm_def
  have hm1 : (φ a - Real.pi / 2) / Real.pi ≤ (m : ℝ) := Int.le_ceil _
  have hm2 : (m : ℝ) < (φ a - Real.pi / 2) / Real.pi + 1 := Int.ceil_lt_add_one _
  have hm1' : φ a - Real.pi / 2 ≤ (m : ℝ) * Real.pi := (div_le_iff₀ hπ).mp hm1
  have hm2' : (m : ℝ) * Real.pi < φ a - Real.pi / 2 + Real.pi := by
    have h := (lt_div_iff₀ hπ).mp (show (m : ℝ) - 1 < (φ a - Real.pi / 2) / Real.pi by
      linarith)
    have e : ((m : ℝ) - 1) * Real.pi = (m : ℝ) * Real.pi - Real.pi := by ring
    linarith
  -- the levels `(2 (m + j) + 1) π / 2`
  set ℓ : Fin k → ℝ := fun j => (2 * ((m : ℝ) + (j : ℕ)) + 1) * Real.pi / 2 with hℓ_def
  have hℓmem : ∀ j : Fin k, ℓ j ∈ Set.Icc (φ a) (φ b) := by
    intro j
    have hj : ((j : ℕ) : ℝ) + 1 ≤ k := by exact_mod_cast j.2
    have hjπ : (((j : ℕ) : ℝ) + 1) * Real.pi ≤ (k : ℝ) * Real.pi :=
      mul_le_mul_of_nonneg_right hj hπ.le
    have hjnn : (0 : ℝ) ≤ ((j : ℕ) : ℝ) := Nat.cast_nonneg _
    have e : ℓ j = (m : ℝ) * Real.pi + ((j : ℕ) : ℝ) * Real.pi + Real.pi / 2 := by
      simp only [hℓ_def]
      ring
    rw [e]
    constructor
    · nlinarith
    · nlinarith
  have hex : ∀ j : Fin k, ∃ x ∈ Set.Icc a b, φ x = ℓ j := fun j =>
    intermediate_value_Icc hab hc (hℓmem j)
  choose x hxmem hxφ using hex
  have hxinj : Function.Injective x := by
    intro i j hij
    have h := hxφ i
    rw [hij, hxφ j] at h
    simp only [hℓ_def] at h
    have hcast : ((j : ℕ) : ℝ) = ((i : ℕ) : ℝ) :=
      mul_right_cancel₀ hπ.ne' (by linear_combination h)
    exact (Fin.ext (by exact_mod_cast hcast)).symm
  set S : Finset ℝ := Finset.univ.image x with hS_def
  have hcard : S.card = k := by
    rw [hS_def, Finset.card_image_of_injective _ hxinj, Finset.card_univ, Fintype.card_fin]
  have hSx : ∀ y ∈ S, ∃ j, x j = y := by
    intro y hy
    rw [hS_def, Finset.mem_image] at hy
    obtain ⟨j, -, hj⟩ := hy
    exact ⟨j, hj⟩
  refine ⟨fun i => S.orderEmbOfFin hcard i, (S.orderEmbOfFin hcard).strictMono, ?_, ?_⟩
  · intro i
    obtain ⟨j, hj⟩ := hSx _ (S.orderEmbOfFin_mem hcard i)
    simp only
    rw [← hj]
    exact hxmem j
  · intro i
    obtain ⟨j, hj⟩ := hSx _ (S.orderEmbOfFin_mem hcard i)
    simp only
    rw [← hj, hxφ j]
    apply Real.cos_eq_zero_iff.mpr
    refine ⟨m + (j : ℕ), ?_⟩
    simp only [hℓ_def]
    push_cast
    ring

/-- **Target 2.** If a continuous `φ` moves by at least `kπ` across `[a, b]`, then
`cos φ` vanishes at `k` strictly increasing points of `[a, b]`. -/
theorem crossings_of_arg {φ : ℝ → ℝ} {a b : ℝ} (hab : a ≤ b)
    (hc : ContinuousOn φ (Set.Icc a b)) (k : ℕ)
    (hk : (k : ℝ) * Real.pi ≤ |φ b - φ a|) :
    ∃ t : Fin k → ℝ, StrictMono t ∧ (∀ i, t i ∈ Set.Icc a b) ∧
      ∀ i, Real.cos (φ (t i)) = 0 := by
  rcases le_total (φ a) (φ b) with hle | hle
  · rw [abs_of_nonneg (by linarith)] at hk
    exact crossings_of_le hab hc k hk
  · rw [abs_of_nonpos (by linarith)] at hk
    obtain ⟨t, hmono, hmem, hcos⟩ := crossings_of_le (φ := fun x => -φ x) hab hc.neg k
      (by linarith)
    refine ⟨t, hmono, hmem, fun i => ?_⟩
    have h := hcos i
    simp only [Real.cos_neg] at h
    exact h

/-- Levinson's function is continuous on the line. -/
theorem continuous_lineF (c : ℝ) : Continuous (lineF c) := by
  rw [continuous_iff_continuousAt]
  intro t
  obtain ⟨_, h1, hre⟩ := LevinsonLine.line_facts t
  set g : ℂ → ℂ := fun s =>
    Gammaℝ s * (riemannZeta s + c * deriv riemannZeta s) with hg_def
  have hdz : DifferentiableOn ℂ riemannZeta {1}ᶜ := fun z hz =>
    (differentiableAt_riemannZeta hz).differentiableWithinAt
  have hdz' : DifferentiableOn ℂ (deriv riemannZeta) {1}ᶜ :=
    hdz.deriv isOpen_compl_singleton
  have hG : ContinuousAt Gammaℝ ((1/2 : ℂ) + t * I) :=
    (LevinsonLine.differentiableAt_Gammaℝ hre).continuousAt
  have hζ : ContinuousAt riemannZeta ((1/2 : ℂ) + t * I) :=
    (differentiableAt_riemannZeta h1).continuousAt
  have hζ' : ContinuousAt (deriv riemannZeta) ((1/2 : ℂ) + t * I) :=
    (hdz'.differentiableAt (isOpen_compl_singleton.mem_nhds h1)).continuousAt
  have hg : ContinuousAt g ((1/2 : ℂ) + t * I) :=
    hG.mul (hζ.add (continuousAt_const.mul hζ'))
  have hl : Continuous (fun t : ℝ => (1/2 + t * I : ℂ)) := by fun_prop
  exact ContinuousAt.comp (g := g) (f := fun t : ℝ => (1/2 + t * I : ℂ)) hg hl.continuousAt

/-- `k` distinct heights in `(0, T]` carrying zeros of `ζ` on the line give at least
`k` zeros on the line up to height `T`, with multiplicity (the counting step of
`LineCount.signChanges_le_line_count`, re-proved for an injective family). -/
theorem distinct_line_zeros_le_lineCount {k : ℕ} {T : ℝ} (γ : Fin k → ℝ)
    (hinj : Function.Injective γ) (hpos : ∀ i, 0 < γ i) (hT : ∀ i, γ i ≤ T)
    (hζ : ∀ i, riemannZeta (1/2 + γ i * I) = 0) :
    (k : ℤ) ≤ lineCount T := by
  have hre : ∀ i : Fin k, ((1/2 : ℂ) + (γ i : ℂ) * I).re = 1 / 2 := fun i =>
    HardyZ.re_line (γ i)
  have him : ∀ i : Fin k, ((1/2 : ℂ) + (γ i : ℂ) * I).im = γ i := fun i => by simp
  have hmemZ : ∀ i : Fin k, ((1/2 : ℂ) + (γ i : ℂ) * I) ∈ NontrivialZeros := fun i => by
    refine ⟨?_, Set.mem_univ _, hζ i⟩
    rw [hre i]
    norm_num
  let ρ : Fin k → NontrivialZeros := fun i => ⟨(1/2 : ℂ) + (γ i : ℂ) * I, hmemZ i⟩
  have hρinj : Function.Injective ρ := by
    intro i j hij
    have := congrArg (fun z : NontrivialZeros => (z : ℂ).im) hij
    simp only [ρ, him] at this
    exact hinj this
  have hsub : Finset.univ.image ρ ⊆
      (zerosUpTo T).filter (fun ρ : NontrivialZeros => (ρ : ℂ).re = 1 / 2) := by
    intro z hz
    rw [Finset.mem_image] at hz
    obtain ⟨i, _, rfl⟩ := hz
    rw [Finset.mem_filter, mem_zerosUpTo]
    simp only [ρ, him, hre]
    exact ⟨⟨hpos i, hT i⟩, trivial⟩
  have hcard : ((Finset.univ.image ρ).card : ℤ) = k := by
    rw [Finset.card_image_of_injective _ hρinj, Finset.card_univ, Fintype.card_fin]
  calc (k : ℤ) = ∑ _z ∈ Finset.univ.image ρ, (1 : ℤ) := by
        rw [Finset.sum_const, nsmul_eq_mul, mul_one, hcard]
    _ ≤ ∑ z ∈ Finset.univ.image ρ, riemannZeta.order (z : ℂ) :=
        Finset.sum_le_sum (fun z _ => riemannZeta_one_le_order_nontrivialZero z)
    _ ≤ lineCount T := by
        unfold lineCount
        exact Finset.sum_le_sum_of_subset_of_nonneg hsub
          (fun z _ _ => (riemannZeta_order_pos_nontrivialZero z).le)

/-- **Target 3.** If a continuous argument `φ` of `Gammaℝ · (ζ + c ζ')` along
`[1/2 + a i, 1/2 + b i]` moves by at least `kπ`, and the real factor
`1 − c · Re(Gammaℝ'/Gammaℝ)` does not vanish there, then at least `k` zeros of `ζ`
lie on the line up to height `T ≥ b`, with multiplicity. -/
theorem lineCount_ge_arg {c a b T : ℝ} {φ : ℝ → ℝ} {k : ℕ}
    (ha : 0 < a) (hab : a ≤ b) (hbT : b ≤ T)
    (hfac : ∀ t ∈ Set.Icc a b,
      1 - c * (deriv Gammaℝ (1/2 + t * I) / Gammaℝ (1/2 + t * I)).re ≠ 0)
    (hφc : ContinuousOn φ (Set.Icc a b))
    (hφ : ∀ t ∈ Set.Icc a b, lineF c t = ‖lineF c t‖ * Complex.exp (φ t * Complex.I))
    (hk : (k : ℝ) * Real.pi ≤ |φ b - φ a|) :
    (k : ℤ) ≤ lineCount T := by
  obtain ⟨t, hmono, hmem, hcos⟩ := crossings_of_arg hab hφc k hk
  have hζ : ∀ i, riemannZeta (1/2 + t i * I) = 0 := by
    intro i
    have hre : (lineF c (t i)).re = 0 := by
      rw [hφ _ (hmem i), Complex.re_ofReal_mul, Complex.exp_ofReal_mul_I_re, hcos i,
        mul_zero]
    exact (LevinsonLine.zeta_line_zero_iff c (t i) (hfac _ (hmem i))).mpr hre
  exact distinct_line_zeros_le_lineCount t hmono.injective
    (fun i => lt_of_lt_of_le ha (hmem i).1) (fun i => le_trans (hmem i).2 hbT) hζ

/-- info: 'LevinsonArg.exists_arg_lift' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms exists_arg_lift

/-- info: 'LevinsonArg.crossings_of_arg' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms crossings_of_arg

/-- info: 'LevinsonArg.continuous_lineF' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms continuous_lineF

/-- info: 'LevinsonArg.lineCount_ge_arg' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms lineCount_ge_arg

end LevinsonArg
