/-
LineCount — block S10 of `lean_stage3/design/stencil.md`, step 3. 2026-11-24.

The count up to height `T` is a finite sum of `riemannZeta.order` over the
nontrivial zeros with `0 < Im ρ ≤ T` (the set is finite by
`Kadiri.nontrivialZeros_abs_im_lt_finite`); the line count is the same sum over
the zeros with `Re ρ = 1/2`. No continuous phase `θ` and no `S(T)` are defined.

RH makes the two sums the same sum. A zero off the line has a conjugate zero
off the line at positive height (`CountModes.im_ne_zero`, `riemannZeta_conj`,
`Kadiri.riemannZeta_order_conj`), and its order, at least one, is the gap at
that height. A strict sign change of `t ↦ Λ(1/2 + it)` on `(t i, t (i+1))`
gives a zero on the line in the open interval; the open intervals are
disjoint, so `k` strict sign changes give `k` distinct zeros, each of order at
least one.

  zerosUpTo                  the nontrivial zeros with 0 < Im ρ ≤ T, a Finset
  allCount T                 Σ_{ρ ∈ zerosUpTo T} order ρ                (in ℤ)
  lineCount T                Σ_{ρ ∈ zerosUpTo T, Re ρ = 1/2} order ρ    (in ℤ)
  mem_zerosUpTo              ρ ∈ zerosUpTo T ↔ 0 < Im ρ ∧ Im ρ ≤ T
  conj_mem                   ρ nontrivial zero ⊢ conj ρ nontrivial zero
  strictSignChange_zero_on_line
                             t₁ < t₂, (Λ(1/2 + t₁ i)).re · (Λ(1/2 + t₂ i)).re < 0
                             ⊢ ∃ γ ∈ (t₁, t₂), ζ (1/2 + γ i) = 0
  lineCount_le_allCount      lineCount T ≤ allCount T
  rh_iff_line_count          RiemannHypothesis ↔ ∀ T, lineCount T = allCount T
  signChanges_le_line_count  t : Fin (k+1) → ℝ strictly increasing, 0 < t 0,
                             t (last k) ≤ T, and for each i : Fin k
                             (Λ(1/2 + t i i)).re · (Λ(1/2 + t (i+1) i)).re < 0
                             ⊢ (k : ℤ) ≤ lineCount T

The sign-change hypothesis is strict (`< 0`): with `≤ 0` adjacent intervals
could share their zero at a common endpoint.

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.HardyZ
import Stage3.ClosedLoopJoin
import Stage3.CountModes

namespace LineCount

open Complex Kadiri
open scoped ComplexConjugate Classical

noncomputable section

/-- The nontrivial zeros with `0 < Im ρ ≤ T`. -/
noncomputable
def zerosUpTo (T : ℝ) : Finset NontrivialZeros :=
  (nontrivialZeros_abs_im_lt_finite (T + 1)).toFinset.filter
    (fun ρ => 0 < (ρ : ℂ).im ∧ (ρ : ℂ).im ≤ T)

/-- All nontrivial zeros up to height `T`, with multiplicity. -/
noncomputable
def allCount (T : ℝ) : ℤ :=
  ∑ ρ ∈ zerosUpTo T, riemannZeta.order (ρ : ℂ)

/-- The nontrivial zeros on the line up to height `T`, with multiplicity. -/
noncomputable
def lineCount (T : ℝ) : ℤ :=
  ∑ ρ ∈ (zerosUpTo T).filter (fun ρ : NontrivialZeros => (ρ : ℂ).re = 1 / 2),
    riemannZeta.order (ρ : ℂ)

end

theorem mem_zerosUpTo {T : ℝ} {ρ : NontrivialZeros} :
    ρ ∈ zerosUpTo T ↔ 0 < (ρ : ℂ).im ∧ (ρ : ℂ).im ≤ T := by
  unfold zerosUpTo
  rw [Finset.mem_filter, Set.Finite.mem_toFinset, Set.mem_setOf_eq]
  constructor
  · exact fun h => h.2
  · intro h
    refine ⟨?_, h⟩
    rw [abs_of_pos h.1]
    linarith [h.2]

/-- A strict sign change of `t ↦ Λ(1/2 + t i)` on `[t₁, t₂]` gives a zero of
`ζ` on the line at height in the open interval `(t₁, t₂)`. -/
theorem strictSignChange_zero_on_line {t₁ t₂ : ℝ} (h : t₁ < t₂)
    (hs : (completedRiemannZeta (1/2 + t₁ * I)).re *
      (completedRiemannZeta (1/2 + t₂ * I)).re < 0) :
    ∃ γ ∈ Set.Ioo t₁ t₂, riemannZeta (1/2 + γ * I) = 0 := by
  set f : ℝ → ℝ := fun t => (completedRiemannZeta (1/2 + t * I)).re with hf_def
  have hf : ContinuousOn f (Set.Icc t₁ t₂) :=
    (Complex.continuous_re.comp HardyZ.continuous_xi_line).continuousOn
  have hz : (0 : ℝ) ∈ f '' Set.Ioo t₁ t₂ := by
    rcases mul_neg_iff.mp hs with ⟨ha, hb⟩ | ⟨ha, hb⟩
    · exact intermediate_value_Ioo' h.le hf ⟨hb, ha⟩
    · exact intermediate_value_Ioo h.le hf ⟨ha, hb⟩
  obtain ⟨γ, hγ, hfγ⟩ := hz
  refine ⟨γ, hγ, ?_⟩
  have hΛ : completedRiemannZeta (1/2 + γ * I) = 0 :=
    Complex.ext hfγ (HardyZ.xi_line_real γ)
  have h0 : ((1/2 : ℂ) + γ * I) ≠ 0 := by
    intro h0
    have := congrArg Complex.re h0
    rw [HardyZ.re_line] at this
    norm_num at this
  rw [riemannZeta_def_of_ne_zero h0, hΛ, zero_div]

/-- The conjugate of a nontrivial zero is a nontrivial zero. -/
theorem conj_mem (ρ : NontrivialZeros) : conj (ρ : ℂ) ∈ NontrivialZeros := by
  refine ⟨?_, Set.mem_univ _, ?_⟩
  · simpa using ρ.2.1
  · show riemannZeta (conj (ρ : ℂ)) = 0
    rw [riemannZeta_conj, ρ.2.2.2, map_zero]

/-- **Line count below the count.** -/
theorem lineCount_le_allCount (T : ℝ) : lineCount T ≤ allCount T := by
  unfold lineCount allCount
  exact Finset.sum_le_sum_of_subset_of_nonneg (Finset.filter_subset _ _)
    (fun ρ _ _ => (riemannZeta_order_pos_nontrivialZero ρ).le)

/-- **RH is the line count.** RH holds exactly when, at every height, the zeros
on the line with multiplicity number all the nontrivial zeros. -/
theorem rh_iff_line_count :
    RiemannHypothesis ↔ ∀ T : ℝ, lineCount T = allCount T := by
  rw [ClosedLoopJoin.rh_iff_re_half]
  constructor
  · intro hRH T
    unfold lineCount allCount
    rw [Finset.filter_true_of_mem (fun ρ _ => hRH ρ)]
  · intro hc
    by_contra hne
    push Not at hne
    obtain ⟨ρ, hρ⟩ := hne
    -- a zero off the line at positive height
    obtain ⟨ρ', hpos, hre'⟩ : ∃ ρ' : NontrivialZeros, 0 < (ρ' : ℂ).im ∧ (ρ' : ℂ).re ≠ 1 / 2 := by
      rcases lt_or_gt_of_ne (CountModes.im_ne_zero ρ) with hneg | hpos
      · refine ⟨⟨conj (ρ : ℂ), conj_mem ρ⟩, ?_, ?_⟩
        · simp only [Complex.conj_im]; linarith
        · simpa using hρ
      · exact ⟨ρ, hpos, hρ⟩
    have hT := hc (ρ' : ℂ).im
    unfold lineCount allCount at hT
    have hsplit := Finset.sum_filter_add_sum_filter_not (zerosUpTo (ρ' : ℂ).im)
      (fun ρ : NontrivialZeros => (ρ : ℂ).re = 1 / 2) (fun ρ => riemannZeta.order (ρ : ℂ))
    have hmem : ρ' ∈ (zerosUpTo (ρ' : ℂ).im).filter
        (fun ρ : NontrivialZeros => ¬ (ρ : ℂ).re = 1 / 2) := by
      rw [Finset.mem_filter, mem_zerosUpTo]
      exact ⟨⟨hpos, le_rfl⟩, hre'⟩
    have hge : riemannZeta.order (ρ' : ℂ) ≤
        ∑ ρ ∈ (zerosUpTo (ρ' : ℂ).im).filter
          (fun ρ : NontrivialZeros => ¬ (ρ : ℂ).re = 1 / 2), riemannZeta.order (ρ : ℂ) :=
      Finset.single_le_sum (f := fun ρ : NontrivialZeros => riemannZeta.order (ρ : ℂ))
        (fun ρ _ => (riemannZeta_order_pos_nontrivialZero ρ).le) hmem
    have hpos' := riemannZeta_order_pos_nontrivialZero ρ'
    linarith

/-- **Sign changes give zeros on the line.** `k` strict sign changes of
`t ↦ Λ(1/2 + t i)` on consecutive intervals of a strictly increasing sequence
in `(0, T]` give at least `k` zeros on the line up to height `T`, with
multiplicity. -/
theorem signChanges_le_line_count {k : ℕ} {T : ℝ} (t : Fin (k + 1) → ℝ)
    (hmono : StrictMono t) (h0 : 0 < t 0) (hT : t (Fin.last k) ≤ T)
    (hs : ∀ i : Fin k, (completedRiemannZeta (1/2 + t i.castSucc * I)).re *
      (completedRiemannZeta (1/2 + t i.succ * I)).re < 0) :
    (k : ℤ) ≤ lineCount T := by
  have hex : ∀ i : Fin k, ∃ γ ∈ Set.Ioo (t i.castSucc) (t i.succ),
      riemannZeta (1/2 + γ * I) = 0 := fun i =>
    strictSignChange_zero_on_line (hmono (Fin.castSucc_lt_succ (i := i))) (hs i)
  choose γ hγ hζ using hex
  have hre : ∀ i : Fin k, ((1/2 : ℂ) + (γ i : ℂ) * I).re = 1 / 2 := fun i =>
    HardyZ.re_line (γ i)
  have him : ∀ i : Fin k, ((1/2 : ℂ) + (γ i : ℂ) * I).im = γ i := fun i => by simp
  have hmemZ : ∀ i : Fin k, ((1/2 : ℂ) + (γ i : ℂ) * I) ∈ NontrivialZeros := fun i => by
    refine ⟨?_, Set.mem_univ _, hζ i⟩
    rw [hre i]
    norm_num
  let ρ : Fin k → NontrivialZeros := fun i => ⟨(1/2 : ℂ) + (γ i : ℂ) * I, hmemZ i⟩
  have hγmono : StrictMono γ := by
    intro i j hij
    have hle : i.succ ≤ j.castSucc := by
      rw [Fin.le_iff_val_le_val]
      simp only [Fin.val_succ, Fin.val_castSucc]
      exact hij
    calc γ i < t i.succ := (hγ i).2
      _ ≤ t j.castSucc := hmono.monotone hle
      _ < γ j := (hγ j).1
  have hinj : Function.Injective ρ := by
    intro i j hij
    have := congrArg (fun z : NontrivialZeros => (z : ℂ).im) hij
    simp only [ρ, him] at this
    exact hγmono.injective this
  have hsub : Finset.univ.image ρ ⊆
      (zerosUpTo T).filter (fun ρ : NontrivialZeros => (ρ : ℂ).re = 1 / 2) := by
    intro z hz
    rw [Finset.mem_image] at hz
    obtain ⟨i, _, rfl⟩ := hz
    rw [Finset.mem_filter, mem_zerosUpTo]
    simp only [ρ, him, hre]
    refine ⟨⟨?_, ?_⟩, trivial⟩
    · calc (0 : ℝ) < t 0 := h0
        _ ≤ t i.castSucc := hmono.monotone (Fin.zero_le _)
        _ < γ i := (hγ i).1
    · calc γ i ≤ t i.succ := (hγ i).2.le
        _ ≤ t (Fin.last k) := hmono.monotone (Fin.le_last _)
        _ ≤ T := hT
  have hcard : ((Finset.univ.image ρ).card : ℤ) = k := by
    rw [Finset.card_image_of_injective _ hinj, Finset.card_univ, Fintype.card_fin]
  calc (k : ℤ) = ∑ _z ∈ Finset.univ.image ρ, (1 : ℤ) := by
        rw [Finset.sum_const, nsmul_eq_mul, mul_one, hcard]
    _ ≤ ∑ z ∈ Finset.univ.image ρ, riemannZeta.order (z : ℂ) :=
        Finset.sum_le_sum (fun z _ => riemannZeta_one_le_order_nontrivialZero z)
    _ ≤ lineCount T := by
        unfold lineCount
        exact Finset.sum_le_sum_of_subset_of_nonneg hsub
          (fun z _ _ => (riemannZeta_order_pos_nontrivialZero z).le)

/-- info: 'LineCount.lineCount_le_allCount' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms lineCount_le_allCount

/-- info: 'LineCount.rh_iff_line_count' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms rh_iff_line_count

/-- info: 'LineCount.signChanges_le_line_count' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms signChanges_le_line_count

end LineCount
