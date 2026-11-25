/-
Defect — block S14 of `lean_stage3/design/stencil.md`, C1, the defect: the zeros off the line. 2026-11-25.

The defect at height `T` is the count of the nontrivial zeros with `0 < Im ρ ≤ T` and
`Re ρ ≠ 1/2`, with multiplicity:

  `defect T = allCount T − lineCount T`   (in ℤ, `LineCount.allCount`, `LineCount.lineCount`).

`riemannZeta.N T` (PNT+) counts the zeros with `0 < Im ρ < T`, open at `T`; `allCount T`
counts `0 < Im ρ ≤ T`, closed at `T`. They differ exactly by the zeros at the height `T`:
`N T ≤ allCount T` (`N_le_allCount`), equality when no zero sits at height `T`
(`N_eq_allCount_of_no_zero_at`), and `N T' = allCount T` for every `T' > T` close enough
(`exists_right`, `N_eq_allCount_right`). So the second defect

  `defectN T = N T − lineCount T`   (in ℝ)

is `defect T − (allCount T − N T) ≤ defect T` (`defectN_eq`); it is negative at a height that
carries a zero on the line, so `∀ T, defectN T = 0` is false and only `defect` carries the
RH face. `defect T` is the one whose vanishing is RH.

The pairing. `SpiralLink.mirrorZ ρ = 1 − conj ρ` is a zero at the same height with real part
`1 − Re ρ`; off the line it differs from `ρ`, and it has the same order
(`ContourShift.zeta_order_reflect` through `ContourShift.order_bridge`). It sends the off-line
zeros with `Re ρ < 1/2` bijectively to those with `Re ρ > 1/2`, so the off-line count with
multiplicity is twice the count left of the line.

The bound. `FloorSum.levinson_floor` gives `(1/3 − ε) N T ≤ lineCount T` eventually. At
`T' > T` close to `T`, `N T' = allCount T` and `lineCount T' = lineCount T`, so the floor holds
with `allCount T` in place of `N T`, and `defect T ≤ (2/3 + ε) allCount T`. The N-form
`defectN T ≤ (2/3 + ε) N T` is immediate. The form for B's input is `defect_le_of_floor` at
`c = 1`: a floor `(1 − ε) N T ≤ lineCount T` gives `defect T ≤ ε · allCount T`.

| name | content | status |
|---|---|---|
| `defect` | `allCount T − lineCount T` (ℤ) | def |
| `defectN` | `N T − lineCount T` (ℝ) | def |
| `offCount` | `Σ_{ρ ∈ zerosUpTo T, Re ρ ≠ 1/2} order ρ` (ℤ) | def |
| `defect_eq_offCount` | `defect T = offCount T` | proved |
| `defect_nonneg` | `0 ≤ defect T` | proved |
| `rh_iff_defect_zero` | `RiemannHypothesis ↔ ∀ T, defect T = 0` | proved |
| `N_eq_sum_lt` | `N T = Σ_{ρ ∈ zerosUpTo T, Im ρ < T} order ρ` | proved |
| `N_le_allCount` | `N T ≤ allCount T` | proved |
| `N_eq_allCount_of_no_zero_at` | no zero at height `T` ⊢ `N T = allCount T` | proved |
| `exists_right` | `∃ T' > T`, no zero with `T < Im ρ ≤ T'` | proved |
| `N_eq_allCount_right` | at such `T'`: `N T' = allCount T`, `lineCount T' = lineCount T` | proved |
| `defectN_eq` | `defectN T = defect T − (allCount T − N T)` | proved |
| `defectN_le_defect` | `defectN T ≤ defect T` | proved |
| `mirrorZ_order` | `order (1 − conj ρ) = order ρ` | proved |
| `offLine_pair` | off-line `ρ` up to `T` ⊢ `mirrorZ ρ` off-line up to `T`, `≠ ρ`, same height, same order | proved |
| `offCount_eq_two_mul` | `offCount T = 2 · Σ_{off-line, Re ρ < 1/2} order ρ` | proved |
| `defect_even` | `Even (defect T)` | proved |
| `defect_le_of_floor` | floor `(c − ε) N T ≤ lineCount T` eventually ⊢ `defect T ≤ (1 − c + ε) allCount T` eventually | proved |
| `defect_le` | `defect T ≤ (2/3 + ε) allCount T` eventually | proved |
| `defectN_le` | `defectN T ≤ (2/3 + ε) N T` eventually | proved |

Open: none in this module. The bound against `N T` itself for `defect` (closed at `T`) needs
the count of zeros at one height, `allCount T − N T`, against `ε N T`; it is not stated here.

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Stage3.FloorSum
import Stage3.LineCount
import Stage3.SpiralLink
import Stage3.ContourShift
import Stage3.ArgCount

namespace Defect

open Complex Filter Topology Kadiri LineCount
open scoped ComplexConjugate Classical

noncomputable section

/-- The defect: the nontrivial zeros up to height `T` (closed) off the line, with
multiplicity. -/
def defect (T : ℝ) : ℤ := allCount T - lineCount T

/-- The defect against upstream's `N` (open at `T`). -/
def defectN (T : ℝ) : ℝ := riemannZeta.N T - (lineCount T : ℝ)

/-- The off-line count up to height `T`, with multiplicity. -/
def offCount (T : ℝ) : ℤ :=
  ∑ ρ ∈ (zerosUpTo T).filter (fun ρ : NontrivialZeros => ¬ (ρ : ℂ).re = 1 / 2),
    riemannZeta.order (ρ : ℂ)

end

theorem defect_eq_offCount (T : ℝ) : defect T = offCount T := by
  unfold defect offCount allCount lineCount
  have h := Finset.sum_filter_add_sum_filter_not (zerosUpTo T)
    (fun ρ : NontrivialZeros => (ρ : ℂ).re = 1 / 2) (fun ρ => riemannZeta.order (ρ : ℂ))
  linarith

/-- **The defect is nonnegative.** -/
theorem defect_nonneg (T : ℝ) : 0 ≤ defect T := by
  unfold defect
  linarith [lineCount_le_allCount T]

/-- **RH is the vanishing of the defect.** -/
theorem rh_iff_defect_zero : RiemannHypothesis ↔ ∀ T : ℝ, defect T = 0 := by
  rw [rh_iff_line_count]
  constructor
  · intro h T
    unfold defect
    rw [h T, sub_self]
  · intro h T
    have := h T
    unfold defect at this
    linarith

/-- `N T` as the sum over the zeros up to `T` strictly below `T`. -/
theorem N_eq_sum_lt (T : ℝ) : riemannZeta.N T =
    ∑ ρ ∈ (zerosUpTo T).filter (fun ρ : NontrivialZeros => (ρ : ℂ).im < T),
      ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) := by
  have hfin := Kadiri.zeroes_rect_univ_positive_height_finite T
  rw [ArgCount.N_eq_sum T]
  symm
  refine Finset.sum_bij (fun ρ _ => (ρ : ℂ)) ?_ ?_ ?_ ?_
  · intro ρ hρ
    rw [Finset.mem_filter, mem_zerosUpTo] at hρ
    refine hfin.mem_toFinset.mpr ?_
    exact ⟨Set.mem_univ _, ⟨hρ.1.1, hρ.2⟩, ρ.2.2.2⟩
  · intro a _ b _ hab
    exact Subtype.ext hab
  · intro z hz
    have hz' := hfin.mem_toFinset.mp hz
    have hre := Kadiri.positiveHeightZero_re_mem_Ioo ⟨z, hz'⟩
    refine ⟨⟨z, ⟨hre, Set.mem_univ _, hz'.2.2⟩⟩, ?_, rfl⟩
    rw [Finset.mem_filter, mem_zerosUpTo]
    exact ⟨⟨hz'.2.1.1, hz'.2.1.2.le⟩, hz'.2.1.2⟩
  · intro ρ _
    simp

theorem allCount_cast (T : ℝ) : (allCount T : ℝ) =
    ∑ ρ ∈ zerosUpTo T, ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) := by
  unfold allCount
  push_cast
  rfl

/-- **`N` below the closed count.** -/
theorem N_le_allCount (T : ℝ) : riemannZeta.N T ≤ (allCount T : ℝ) := by
  rw [N_eq_sum_lt, allCount_cast]
  refine Finset.sum_le_sum_of_subset_of_nonneg (Finset.filter_subset _ _) ?_
  intro ρ _ _
  exact_mod_cast (riemannZeta_order_pos_nontrivialZero ρ).le

/-- **`N` is the closed count at a height carrying no zero.** -/
theorem N_eq_allCount_of_no_zero_at {T : ℝ}
    (h : ∀ ρ : NontrivialZeros, (ρ : ℂ).im ≠ T) : riemannZeta.N T = (allCount T : ℝ) := by
  rw [N_eq_sum_lt, allCount_cast, Finset.filter_true_of_mem]
  intro ρ hρ
  rw [mem_zerosUpTo] at hρ
  exact lt_of_le_of_ne hρ.2 (h ρ)

/-- **A height just above with no zero between.** -/
theorem exists_right (T : ℝ) : ∃ T' : ℝ, T < T' ∧
    ∀ z : ℂ, riemannZeta z = 0 → 0 < z.im → T < z.im → T' < z.im := by
  have hfin := Kadiri.zeroes_rect_univ_positive_height_finite (T + 1)
  set S := hfin.toFinset with hS
  have h1 : ∀ᶠ T' in 𝓝[>] T, ∀ z ∈ S, T < z.im → T' < z.im := by
    rw [Filter.eventually_all_finset]
    intro z _
    by_cases h : T < z.im
    · filter_upwards [Ioo_mem_nhdsGT h] with T' hT' _
      exact hT'.2
    · exact Filter.Eventually.of_forall (fun _ h' => absurd h' h)
  have h2 : ∀ᶠ T' in 𝓝[>] T, T' ∈ Set.Ioo T (T + 1) := Ioo_mem_nhdsGT (by linarith)
  obtain ⟨T', hT'S, hT'I⟩ := (h1.and h2).exists
  refine ⟨T', hT'I.1, fun z hz hpos hT => ?_⟩
  by_contra hc
  have hc' : z.im ≤ T' := le_of_not_gt hc
  have hzS : z ∈ S := hfin.mem_toFinset.mpr
    ⟨Set.mem_univ _, ⟨hpos, by linarith [hT'I.2]⟩, hz⟩
  exact hc (hT'S z hzS hT)

theorem zerosUpTo_eq_right {T T' : ℝ} (hTT' : T ≤ T')
    (hno : ∀ z : ℂ, riemannZeta z = 0 → 0 < z.im → T < z.im → T' < z.im) :
    zerosUpTo T' = zerosUpTo T := by
  ext ρ
  rw [mem_zerosUpTo, mem_zerosUpTo]
  constructor
  · rintro ⟨h0, h1⟩
    refine ⟨h0, ?_⟩
    by_contra hc
    have := hno (ρ : ℂ) ρ.2.2.2 h0 (lt_of_not_ge hc)
    linarith
  · rintro ⟨h0, h1⟩
    exact ⟨h0, h1.trans hTT'⟩

/-- **At a height just above, `N` is the closed count and the line count is unchanged.** -/
theorem N_eq_allCount_right {T T' : ℝ} (hTT' : T < T')
    (hno : ∀ z : ℂ, riemannZeta z = 0 → 0 < z.im → T < z.im → T' < z.im) :
    riemannZeta.N T' = (allCount T : ℝ) ∧ lineCount T' = lineCount T := by
  have hZ := zerosUpTo_eq_right hTT'.le hno
  refine ⟨?_, ?_⟩
  · rw [N_eq_sum_lt, allCount_cast, hZ, Finset.filter_true_of_mem]
    intro ρ hρ
    rw [mem_zerosUpTo] at hρ
    linarith [hρ.2]
  · unfold lineCount
    rw [hZ]

theorem defectN_eq (T : ℝ) :
    defectN T = (defect T : ℝ) - ((allCount T : ℝ) - riemannZeta.N T) := by
  unfold defectN defect
  push_cast
  ring

theorem defectN_le_defect (T : ℝ) : defectN T ≤ (defect T : ℝ) := by
  rw [defectN_eq]
  linarith [N_le_allCount T]

/-- **The mirror has the same order** (functional equation and conjugation). -/
theorem mirrorZ_order (ρ : NontrivialZeros) :
    riemannZeta.order ((SpiralLink.mirrorZ ρ : NontrivialZeros) : ℂ)
      = riemannZeta.order (ρ : ℂ) := by
  have h := ContourShift.zeta_order_reflect ρ.2.1.1 ρ.2.1.2
  have b1 := ContourShift.order_bridge (Kadiri.nontrivialZero_ne_one (SpiralLink.mirrorZ ρ))
  have b2 := ContourShift.order_bridge (Kadiri.nontrivialZero_ne_one ρ)
  have hC : ((riemannZeta.order ((SpiralLink.mirrorZ ρ : NontrivialZeros) : ℂ) : ℤ) : ℂ)
      = ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) := by
    rw [b1, b2]
    show ((analyticOrderNatAt riemannZeta (1 - (starRingEnd ℂ) (ρ : ℂ)) : ℕ) : ℂ) = _
    rw [h]
  exact_mod_cast hC

theorem mirrorZ_mirrorZ (ρ : NontrivialZeros) :
    SpiralLink.mirrorZ (SpiralLink.mirrorZ ρ) = ρ := by
  apply Subtype.ext
  show 1 - (starRingEnd ℂ) (1 - (starRingEnd ℂ) (ρ : ℂ)) = (ρ : ℂ)
  simp [map_sub, map_one]

/-- **The pairing.** An off-line zero up to height `T` has its mirror off the line, up to
height `T`, distinct from it, at the same height and with the same order. -/
theorem offLine_pair {T : ℝ} {ρ : NontrivialZeros}
    (hρ : ρ ∈ (zerosUpTo T).filter (fun ρ : NontrivialZeros => ¬ (ρ : ℂ).re = 1 / 2)) :
    SpiralLink.mirrorZ ρ ∈
        (zerosUpTo T).filter (fun ρ : NontrivialZeros => ¬ (ρ : ℂ).re = 1 / 2) ∧
      SpiralLink.mirrorZ ρ ≠ ρ ∧
      ((SpiralLink.mirrorZ ρ : NontrivialZeros) : ℂ).im = (ρ : ℂ).im ∧
      riemannZeta.order ((SpiralLink.mirrorZ ρ : NontrivialZeros) : ℂ)
        = riemannZeta.order (ρ : ℂ) := by
  rw [Finset.mem_filter, mem_zerosUpTo] at hρ
  refine ⟨?_, ?_, SpiralLink.mirrorZ_im ρ, mirrorZ_order ρ⟩
  · rw [Finset.mem_filter, mem_zerosUpTo, SpiralLink.mirrorZ_im, SpiralLink.mirrorZ_re]
    refine ⟨hρ.1, ?_⟩
    intro h
    exact hρ.2 (by linarith)
  · intro h
    exact hρ.2 ((SpiralLink.mirrorZ_eq_iff ρ).mp h)

/-- **The off-line count is twice the count left of the line.** -/
theorem offCount_eq_two_mul (T : ℝ) :
    offCount T = 2 * ∑ ρ ∈ ((zerosUpTo T).filter
        (fun ρ : NontrivialZeros => ¬ (ρ : ℂ).re = 1 / 2)).filter
        (fun ρ : NontrivialZeros => (ρ : ℂ).re < 1 / 2), riemannZeta.order (ρ : ℂ) := by
  set A := (zerosUpTo T).filter (fun ρ : NontrivialZeros => ¬ (ρ : ℂ).re = 1 / 2) with hA
  have hsplit := Finset.sum_filter_add_sum_filter_not A
    (fun ρ : NontrivialZeros => (ρ : ℂ).re < 1 / 2) (fun ρ => riemannZeta.order (ρ : ℂ))
  have heq : ∑ ρ ∈ A.filter (fun ρ : NontrivialZeros => (ρ : ℂ).re < 1 / 2),
        riemannZeta.order (ρ : ℂ)
      = ∑ ρ ∈ A.filter (fun ρ : NontrivialZeros => ¬ (ρ : ℂ).re < 1 / 2),
        riemannZeta.order (ρ : ℂ) := by
    refine Finset.sum_bij' (fun ρ _ => SpiralLink.mirrorZ ρ) (fun ρ _ => SpiralLink.mirrorZ ρ)
      ?_ ?_ ?_ ?_ ?_
    · intro ρ hρ
      rw [Finset.mem_filter] at hρ ⊢
      refine ⟨(offLine_pair hρ.1).1, ?_⟩
      rw [SpiralLink.mirrorZ_re]
      linarith [hρ.2]
    · intro ρ hρ
      rw [Finset.mem_filter] at hρ ⊢
      refine ⟨(offLine_pair hρ.1).1, ?_⟩
      rw [SpiralLink.mirrorZ_re]
      have h1 := hρ.1
      rw [hA, Finset.mem_filter] at h1
      have h2 : 1 / 2 < (ρ : ℂ).re :=
        lt_of_le_of_ne (le_of_not_gt hρ.2) (fun h => h1.2 h.symm)
      linarith
    · intro ρ _
      exact mirrorZ_mirrorZ ρ
    · intro ρ _
      exact mirrorZ_mirrorZ ρ
    · intro ρ _
      exact (mirrorZ_order ρ).symm
  unfold offCount
  rw [← hA, ← hsplit, ← heq]
  ring

/-- **The defect is even.** -/
theorem defect_even (T : ℝ) : Even (defect T) := by
  rw [defect_eq_offCount, offCount_eq_two_mul]
  exact even_two_mul _

/-- **A line floor bounds the defect.** A floor `(c − ε) N T ≤ lineCount T` from some height
on, for every `ε > 0`, gives `defect T ≤ (1 − c + ε) allCount T` from some height on. -/
theorem defect_le_of_floor {c : ℝ}
    (h : ∀ ε : ℝ, 0 < ε → ∃ T₀ : ℝ, ∀ T : ℝ, T₀ ≤ T →
      (c - ε) * riemannZeta.N T ≤ (lineCount T : ℝ)) :
    ∀ ε : ℝ, 0 < ε → ∃ T₀ : ℝ, ∀ T : ℝ, T₀ ≤ T →
      (defect T : ℝ) ≤ (1 - c + ε) * (allCount T : ℝ) := by
  intro ε hε
  obtain ⟨T₀, hT₀⟩ := h ε hε
  refine ⟨T₀, fun T hT => ?_⟩
  obtain ⟨T', hTT', hno⟩ := exists_right T
  obtain ⟨hN, hL⟩ := N_eq_allCount_right hTT' hno
  have hf := hT₀ T' (hT.trans hTT'.le)
  rw [hN, hL] at hf
  unfold defect
  push_cast
  linarith

/-- **The defect at most `(2/3 + ε)` of the count**, from Levinson's floor. -/
theorem defect_le : ∀ ε : ℝ, 0 < ε → ∃ T₀ : ℝ, ∀ T : ℝ, T₀ ≤ T →
    (defect T : ℝ) ≤ (2 / 3 + ε) * (allCount T : ℝ) := by
  intro ε hε
  obtain ⟨T₀, hT₀⟩ := defect_le_of_floor FloorSum.levinson_floor ε hε
  refine ⟨T₀, fun T hT => ?_⟩
  have e : (1 - 1 / 3 + ε : ℝ) = 2 / 3 + ε := by ring
  rw [← e]
  exact hT₀ T hT

/-- **The N-defect at most `(2/3 + ε) N T`**, from Levinson's floor. -/
theorem defectN_le : ∀ ε : ℝ, 0 < ε → ∃ T₀ : ℝ, ∀ T : ℝ, T₀ ≤ T →
    defectN T ≤ (2 / 3 + ε) * riemannZeta.N T := by
  intro ε hε
  obtain ⟨T₀, hT₀⟩ := FloorSum.levinson_floor ε hε
  refine ⟨T₀, fun T hT => ?_⟩
  have := hT₀ T hT
  unfold defectN
  linarith

/-- info: 'Defect.defect_nonneg' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms defect_nonneg

/-- info: 'Defect.rh_iff_defect_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms rh_iff_defect_zero

/-- info: 'Defect.N_le_allCount' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms N_le_allCount

/-- info: 'Defect.N_eq_allCount_right' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms N_eq_allCount_right

/-- info: 'Defect.offLine_pair' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms offLine_pair

/-- info: 'Defect.defect_even' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms defect_even

/-- info: 'Defect.defect_le_of_floor' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms defect_le_of_floor

/-- info: 'Defect.defect_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms defect_le

/-- info: 'Defect.defectN_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms defectN_le

end Defect
