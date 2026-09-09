/-
IndicatorContDiff — the C¹ indicator lemma (follow-up to block 15 of rung5.md,
to unit 0369; the second of the two lemmas unit 0368 named as blocking
`WeilPowerAssembly`'s `isTest_phiWC`).

Statement: if `f : ℝ → ℝ` is C¹, with `f a = f b = 0` and
`deriv f a = deriv f b = 0`, then `Set.indicator (Set.Icc a b) f` is C¹.

Assembly (LOOP.md v21 § 4b, one try per step):
  1. Show `Set.indicator (Icc a b) f` is differentiable at every `x`, with
     derivative `Set.indicator (Icc a b) (deriv f) x`. Case-split on `x` vs
     the endpoints.
  2. Deduce `deriv (Set.indicator (Icc a b) f) = Set.indicator (Icc a b) (deriv f)`.
  3. Show `Continuous (Set.indicator (Icc a b) (deriv f))`.
  4. Conclude via `contDiff_one_iff_deriv`.
-/
import Mathlib.Analysis.Calculus.ContDiff.Deriv

namespace Stage3

noncomputable section

open Set Filter Topology

/-- **C¹ indicator on a closed interval with vanishing boundary data.**
If `f : ℝ → ℝ` is `C¹`, and both `f` and its derivative vanish at the
endpoints `a` and `b` of `Icc a b`, then the set-indicator of `f` on
`Icc a b` is `C¹` on all of `ℝ`. -/
theorem contDiff_one_indicator_Icc {a b : ℝ} (hab : a ≤ b) {f : ℝ → ℝ}
    (hf : ContDiff ℝ 1 f) (ha : f a = 0) (hb : f b = 0)
    (hda : deriv f a = 0) (hdb : deriv f b = 0) :
    ContDiff ℝ 1 (Set.indicator (Set.Icc a b) f) := by
  rcases eq_or_lt_of_le hab with rfl | hlt
  · -- a = b: the indicator is identically zero because f a = 0.
    have hzero : Set.indicator (Set.Icc a a) f = fun _ => (0 : ℝ) := by
      funext x
      by_cases hx : x ∈ Set.Icc a a
      · rw [Set.indicator_of_mem hx]
        have : x = a := by
          have h1 : a ≤ x := hx.1
          have h2 : x ≤ a := hx.2
          linarith
        rw [this]; exact ha
      · exact Set.indicator_of_notMem hx _
    rw [hzero]; exact contDiff_const
  · -- a < b
    have hf_diff : Differentiable ℝ f := (contDiff_one_iff_deriv.mp hf).1
    have hf_cont_deriv : Continuous (deriv f) := (contDiff_one_iff_deriv.mp hf).2
    have ha_mem : a ∈ Set.Icc a b := Set.left_mem_Icc.mpr hab
    have hb_mem : b ∈ Set.Icc a b := Set.right_mem_Icc.mpr hab
    -- Step 1a: exterior x < a.
    have h1a : ∀ x : ℝ, x < a → HasDerivAt (Set.indicator (Set.Icc a b) f) 0 x := by
      intro x hxa
      refine (hasDerivAt_const x (0 : ℝ)).congr_of_eventuallyEq ?_
      filter_upwards [Iio_mem_nhds hxa] with y hy
      have hy_notin : y ∉ Set.Icc a b := fun h => not_lt.mpr h.1 hy
      exact Set.indicator_of_notMem hy_notin f
    -- Step 1e: exterior x > b.
    have h1e : ∀ x : ℝ, b < x → HasDerivAt (Set.indicator (Set.Icc a b) f) 0 x := by
      intro x hxb
      refine (hasDerivAt_const x (0 : ℝ)).congr_of_eventuallyEq ?_
      filter_upwards [Ioi_mem_nhds hxb] with y hy
      have hy_notin : y ∉ Set.Icc a b := fun h => not_lt.mpr h.2 hy
      exact Set.indicator_of_notMem hy_notin f
    -- Step 1b: interior a < x < b.
    have h1b : ∀ x : ℝ, a < x → x < b →
        HasDerivAt (Set.indicator (Set.Icc a b) f) (deriv f x) x := by
      intro x hxa hxb
      refine ((hf_diff x).hasDerivAt).congr_of_eventuallyEq ?_
      filter_upwards [Ioo_mem_nhds hxa hxb] with y hy
      have hy_icc : y ∈ Set.Icc a b := Set.Ioo_subset_Icc_self hy
      exact Set.indicator_of_mem hy_icc f
    -- Step 1c: boundary x = a. Use HasDerivWithinAt.union on Iic a and Ici a.
    have h1c : HasDerivAt (Set.indicator (Set.Icc a b) f) 0 a := by
      -- Left branch: on Iic a, indicator is 0.
      have hleft : HasDerivWithinAt (Set.indicator (Set.Icc a b) f) 0 (Set.Iic a) a := by
        refine (hasDerivWithinAt_const (c := (0 : ℝ)) (s := Set.Iic a) (x := a)).congr
          (fun y hy => ?_) ?_
        · -- goal: Set.indicator (Icc a b) f y = 0 for y ∈ Iic a
          have hy_le : y ≤ a := hy
          rcases lt_or_eq_of_le hy_le with hlt' | heq
          · exact Set.indicator_of_notMem (fun h => not_lt.mpr h.1 hlt') _
          · rw [heq, Set.indicator_of_mem ha_mem]; exact ha
        · -- goal at x = a: Set.indicator (Icc a b) f a = 0
          rw [Set.indicator_of_mem ha_mem]; exact ha
      -- Right branch: on Ici a, indicator agrees with f on 𝓝[Ici a] a and both are 0 at a.
      have hright : HasDerivWithinAt (Set.indicator (Set.Icc a b) f) 0 (Set.Ici a) a := by
        have hf_a : HasDerivAt f 0 a := hda ▸ (hf_diff a).hasDerivAt
        refine (hf_a.hasDerivWithinAt (s := Set.Ici a)).congr_of_eventuallyEq_of_mem
          ?_ Set.self_mem_Ici
        filter_upwards [self_mem_nhdsWithin (a := a) (s := Set.Ici a),
                        mem_nhdsWithin_of_mem_nhds (Iio_mem_nhds hlt)] with y hy_in hy_lt
        have hy_icc : y ∈ Set.Icc a b := ⟨hy_in, le_of_lt hy_lt⟩
        exact Set.indicator_of_mem hy_icc f
      -- Union and lift.
      have hunion : HasDerivWithinAt (Set.indicator (Set.Icc a b) f) 0
          (Set.Iic a ∪ Set.Ici a) a := hleft.union hright
      have huniv : Set.Iic a ∪ Set.Ici a = (Set.univ : Set ℝ) := Set.Iic_union_Ici
      rw [huniv] at hunion
      exact hunion.hasDerivAt univ_mem
    -- Step 1d: boundary x = b. Mirror of 1c.
    have h1d : HasDerivAt (Set.indicator (Set.Icc a b) f) 0 b := by
      have hleft : HasDerivWithinAt (Set.indicator (Set.Icc a b) f) 0 (Set.Iic b) b := by
        have hf_b : HasDerivAt f 0 b := hdb ▸ (hf_diff b).hasDerivAt
        refine (hf_b.hasDerivWithinAt (s := Set.Iic b)).congr_of_eventuallyEq_of_mem
          ?_ Set.self_mem_Iic
        filter_upwards [self_mem_nhdsWithin (a := b) (s := Set.Iic b),
                        mem_nhdsWithin_of_mem_nhds (Ioi_mem_nhds hlt)] with y hy_in hy_gt
        have hy_icc : y ∈ Set.Icc a b := ⟨le_of_lt hy_gt, hy_in⟩
        exact Set.indicator_of_mem hy_icc f
      have hright : HasDerivWithinAt (Set.indicator (Set.Icc a b) f) 0 (Set.Ici b) b := by
        refine (hasDerivWithinAt_const (c := (0 : ℝ)) (s := Set.Ici b) (x := b)).congr
          (fun y hy => ?_) ?_
        · have hy_ge : b ≤ y := hy
          rcases lt_or_eq_of_le hy_ge with hlt' | heq
          · exact Set.indicator_of_notMem (fun h => not_lt.mpr h.2 hlt') _
          · rw [← heq, Set.indicator_of_mem hb_mem]; exact hb
        · rw [Set.indicator_of_mem hb_mem]; exact hb
      have hunion : HasDerivWithinAt (Set.indicator (Set.Icc a b) f) 0
          (Set.Iic b ∪ Set.Ici b) b := hleft.union hright
      have huniv : Set.Iic b ∪ Set.Ici b = (Set.univ : Set ℝ) := Set.Iic_union_Ici
      rw [huniv] at hunion
      exact hunion.hasDerivAt univ_mem
    -- Step 1 unified: at every x, HasDerivAt with the derivative given by indicator (deriv f).
    have hderiv : ∀ x : ℝ, HasDerivAt (Set.indicator (Set.Icc a b) f)
        (Set.indicator (Set.Icc a b) (deriv f) x) x := by
      intro x
      rcases lt_trichotomy x a with hxa | rfl | hxa
      · -- x < a
        have hx_notin : x ∉ Set.Icc a b := fun h => not_lt.mpr h.1 hxa
        rw [Set.indicator_of_notMem hx_notin (deriv f)]
        exact h1a x hxa
      · -- x = a
        rw [Set.indicator_of_mem ha_mem (deriv f), hda]
        exact h1c
      · -- a < x
        rcases lt_trichotomy x b with hxb | rfl | hxb
        · -- a < x < b
          have hx_in : x ∈ Set.Icc a b := ⟨le_of_lt hxa, le_of_lt hxb⟩
          rw [Set.indicator_of_mem hx_in (deriv f)]
          exact h1b x hxa hxb
        · -- x = b
          rw [Set.indicator_of_mem hb_mem (deriv f), hdb]
          exact h1d
        · -- x > b
          have hx_notin : x ∉ Set.Icc a b := fun h => not_lt.mpr h.2 hxb
          rw [Set.indicator_of_notMem hx_notin (deriv f)]
          exact h1e x hxb
    -- Step 2: deriv of the indicator equals indicator of the derivative.
    have hderiv_eq : deriv (Set.indicator (Set.Icc a b) f)
        = Set.indicator (Set.Icc a b) (deriv f) := by
      funext x; exact (hderiv x).deriv
    -- Step 3: continuity of Set.indicator (Icc a b) (deriv f).
    -- Sub-cases parallel to step 1.
    have hcont : Continuous (Set.indicator (Set.Icc a b) (deriv f)) := by
      rw [continuous_iff_continuousAt]
      intro x
      rcases lt_trichotomy x a with hxa | hxa_eq | hxa
      · -- x < a
        have hx_notin : x ∉ Set.Icc a b := fun h => not_lt.mpr h.1 hxa
        have hval : Set.indicator (Set.Icc a b) (deriv f) x = 0 :=
          Set.indicator_of_notMem hx_notin _
        rw [ContinuousAt, hval]
        refine Tendsto.congr' ?_ tendsto_const_nhds
        filter_upwards [Iio_mem_nhds hxa] with y hy
        have hy_notin : y ∉ Set.Icc a b := fun h => not_lt.mpr h.1 hy
        exact (Set.indicator_of_notMem hy_notin _).symm
      · -- x = a
        rw [hxa_eq]
        have hval : Set.indicator (Set.Icc a b) (deriv f) a = 0 := by
          rw [Set.indicator_of_mem ha_mem]; exact hda
        -- Want ContinuousAt at a. Combine left branch (const 0) with right branch (deriv f).
        rw [ContinuousAt, hval]
        -- Show tendsto to 0. Split into Iio a and Ici a via nhdsWithin.
        -- Left: on Iio a, indicator = 0, tendsto to 0.
        have hleft : Tendsto (Set.indicator (Set.Icc a b) (deriv f)) (𝓝[≤] a) (𝓝 (0 : ℝ)) := by
          refine Tendsto.congr' ?_ tendsto_const_nhds
          filter_upwards [self_mem_nhdsWithin (a := a) (s := Set.Iic a)] with y hy_le
          rcases lt_or_eq_of_le (Set.mem_Iic.mp hy_le) with hlt' | heq
          · exact (Set.indicator_of_notMem (fun h => not_lt.mpr h.1 hlt') _).symm
          · rw [heq, Set.indicator_of_mem ha_mem]; exact hda.symm
        have hright : Tendsto (Set.indicator (Set.Icc a b) (deriv f)) (𝓝[≥] a) (𝓝 (0 : ℝ)) := by
          -- On 𝓝[Ici a] a, eventually indicator = deriv f; tendsto deriv f to deriv f a = 0.
          have hct : Tendsto (deriv f) (𝓝 a) (𝓝 (deriv f a)) := hf_cont_deriv.continuousAt
          have hct' : Tendsto (deriv f) (𝓝[≥] a) (𝓝 (0 : ℝ)) := by
            rw [← hda]; exact hct.mono_left nhdsWithin_le_nhds
          refine hct'.congr' ?_
          filter_upwards [self_mem_nhdsWithin (a := a) (s := Set.Ici a),
                          mem_nhdsWithin_of_mem_nhds (Iio_mem_nhds hlt)] with y hy_in hy_lt
          have hy_icc : y ∈ Set.Icc a b := ⟨hy_in, le_of_lt hy_lt⟩
          exact (Set.indicator_of_mem hy_icc _).symm
        have hsup : Tendsto (Set.indicator (Set.Icc a b) (deriv f))
            (𝓝[≤] a ⊔ 𝓝[≥] a) (𝓝 (0 : ℝ)) := hleft.sup hright
        rw [nhdsLE_sup_nhdsGE] at hsup
        exact hsup
      · -- x > a: sub-split on b.
        rcases lt_trichotomy x b with hxb | hxb_eq | hxb
        · -- a < x < b
          have hx_in : x ∈ Set.Icc a b := ⟨le_of_lt hxa, le_of_lt hxb⟩
          have hval : Set.indicator (Set.Icc a b) (deriv f) x = deriv f x :=
            Set.indicator_of_mem hx_in _
          rw [ContinuousAt, hval]
          refine (hf_cont_deriv.continuousAt).congr' ?_
          filter_upwards [Ioo_mem_nhds hxa hxb] with y hy
          exact (Set.indicator_of_mem (Set.Ioo_subset_Icc_self hy) _).symm
        · -- x = b: mirror of x = a
          rw [hxb_eq]
          have hval : Set.indicator (Set.Icc a b) (deriv f) b = 0 := by
            rw [Set.indicator_of_mem hb_mem]; exact hdb
          rw [ContinuousAt, hval]
          have hleft : Tendsto (Set.indicator (Set.Icc a b) (deriv f)) (𝓝[≤] b) (𝓝 (0 : ℝ)) := by
            have hct : Tendsto (deriv f) (𝓝 b) (𝓝 (deriv f b)) := hf_cont_deriv.continuousAt
            have hct' : Tendsto (deriv f) (𝓝[≤] b) (𝓝 (0 : ℝ)) := by
              rw [← hdb]; exact hct.mono_left nhdsWithin_le_nhds
            refine hct'.congr' ?_
            filter_upwards [self_mem_nhdsWithin (a := b) (s := Set.Iic b),
                            mem_nhdsWithin_of_mem_nhds (Ioi_mem_nhds hlt)] with y hy_in hy_gt
            have hy_icc : y ∈ Set.Icc a b := ⟨le_of_lt hy_gt, hy_in⟩
            exact (Set.indicator_of_mem hy_icc _).symm
          have hright : Tendsto (Set.indicator (Set.Icc a b) (deriv f)) (𝓝[≥] b) (𝓝 (0 : ℝ)) := by
            refine Tendsto.congr' ?_ tendsto_const_nhds
            filter_upwards [self_mem_nhdsWithin (a := b) (s := Set.Ici b)] with y hy_ge
            rcases lt_or_eq_of_le (Set.mem_Ici.mp hy_ge) with hlt' | heq
            · exact (Set.indicator_of_notMem (fun h => not_lt.mpr h.2 hlt') _).symm
            · rw [← heq, Set.indicator_of_mem hb_mem]; exact hdb.symm
          have hsup : Tendsto (Set.indicator (Set.Icc a b) (deriv f))
              (𝓝[≤] b ⊔ 𝓝[≥] b) (𝓝 (0 : ℝ)) := hleft.sup hright
          rw [nhdsLE_sup_nhdsGE] at hsup
          exact hsup
        · -- x > b
          have hx_notin : x ∉ Set.Icc a b := fun h => not_lt.mpr h.2 hxb
          have hval : Set.indicator (Set.Icc a b) (deriv f) x = 0 :=
            Set.indicator_of_notMem hx_notin _
          rw [ContinuousAt, hval]
          refine Tendsto.congr' ?_ tendsto_const_nhds
          filter_upwards [Ioi_mem_nhds hxb] with y hy
          have hy_notin : y ∉ Set.Icc a b := fun h => not_lt.mpr h.2 hy
          exact (Set.indicator_of_notMem hy_notin _).symm
    -- Step 4: conclude via contDiff_one_iff_deriv.
    refine contDiff_one_iff_deriv.mpr ⟨fun x => (hderiv x).differentiableAt, ?_⟩
    rw [hderiv_eq]; exact hcont

/-- info: 'Stage3.contDiff_one_indicator_Icc' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms contDiff_one_indicator_Icc

end

end Stage3
