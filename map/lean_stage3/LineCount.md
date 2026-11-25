# `lean_stage3/Stage3/LineCount.lean`

> **Read from the source text.** This file changed after the last `python3 utilities/lean_map.py --dump`, so the arrows on this page are names occurring in each proof and have not been confirmed by Lean.

LineCount — block S10 of `lean_stage3/design/stencil.md`, step 3. 2026-11-24. The count up to height `T` is a finite sum of `riemannZeta.order` over the nontrivial zeros with `0 < Im ρ ≤ T` (the set is finite by `Kadiri.nontrivialZeros_abs_im_lt_finite`); the line count is the same sum over the zeros with `Re ρ = 1/2`. No continuous phase `θ` and no `S(T)` are defined.

6 theorems, 3 definitions, 224 lines. 

**Imports:** [`ClosedLoopJoin`](../lean_stage3/ClosedLoopJoin.md), [`CountModes`](../lean_stage3/CountModes.md), [`HardyZ`](../lean_stage3/HardyZ.md)  
**Imported by:** [`Stage3`](../lean_stage3/Stage3.md), [`Defect`](../lean_stage3/Defect.md), [`LevinsonArg`](../lean_stage3/LevinsonArg.md)

## The picture

```mermaid
flowchart LR
  n0["<b>mem_zerosUpTo</b><br/>ρ ∈ zerosUpTo T ↔ 0 ＜ (ρ : ℂ).im ∧ (ρ : ℂ).im ≤ T"]:::cnt
  n1["<b>strictSignChange_zero_on_line</b><br/>∃ γ ∈ Set.Ioo t₁ t₂, riemannZeta (1/2 + γ * I) = 0"]:::thm
  n2["<b>conj_mem</b><br/>conj (ρ : ℂ) ∈ NontrivialZeros"]:::thm
  n3["<b>lineCount_le_allCount</b><br/>lineCount T ≤ allCount T"]:::thm
  n4["<b>rh_iff_line_count</b><br/>RiemannHypothesis ↔ ∀ T : ℝ, lineCount T = allCount T"]:::thm
  n5["<b>signChanges_le_line_count</b><br/>(k : ℤ) ≤ lineCount T"]:::thm
  x0(["<b>Defect</b><br/>7 theorems"]):::ext
  x1(["<b>LevinsonArg</b><br/>distinct_line_zeros_le_lineCount"]):::ext
  x2(["<b>LevinsonMultiple</b><br/>sum_order_le_lineCount"]):::ext
  x3(["<b>LevinsonWindowNear</b><br/>sum_order_le_lineCount_sub"]):::ext
  x4(["<b>TuringCert</b><br/>4 theorems"]):::ext
  x5(["<b>HardyZ</b><br/>continuous_xi_line<br/>re_line<br/>xi_line_real"]):::ext
  x6(["<b>ClosedLoopJoin</b><br/>rh_iff_re_half"]):::ext
  x7(["<b>CountModes</b><br/>im_ne_zero"]):::ext
  x8(["<b>SignData</b><br/>nine_zeros_on_line<br/>one_zero_on_line"]):::ext
  x9(["<b>TuringSlope</b><br/>defect_zero_of_signs'"]):::ext
  n0 --> n4
  n0 --> n5
  n1 --> n5
  n2 --> n4
  n0 -.-> x0
  n0 -.-> x1
  n0 -.-> x2
  n0 -.-> x3
  n0 -.-> x4
  n1 -.-> x4
  n3 -.-> x0
  n4 -.-> x0
  n5 -.-> x4
  n5 -.-> x8
  n5 -.-> x9
  x5 -.-> n1
  x5 -.-> n5
  x6 -.-> n4
  x7 -.-> n4
  classDef cnt fill:#dff5ec,stroke:#17694a,color:#111
  classDef shp fill:#f1ecfb,stroke:#5b3fa0,color:#111
  classDef rh fill:#ffe5e5,stroke:#c22,color:#111,stroke-width:2px
  classDef thm fill:#eef4ff,stroke:#335,color:#111
  classDef end_ fill:#e7f7e7,stroke:#2a7,color:#111,stroke-width:2px
  classDef lone fill:#fff,stroke:#999,color:#111,stroke-dasharray:4 3
  classDef bad fill:#ffe5e5,stroke:#c22,color:#111,stroke-width:2px
  classDef ext fill:#fff8e1,stroke:#b80,color:#111
```

An arrow A → B reads "A is used in the proof of B". Green: counting, integers only. Violet: shape, analysis with no ζ. Blue: reads ζ. A name ending in ■ is an end: nothing else uses it. Red: contains `sorry`. Yellow: theorems in another file, counted; a dotted arrow crosses files. Definitions are not drawn; they are listed below the diagram.

## Definitions

<a name="LineCount-zerosUpTo"></a>
### `LineCount.zerosUpTo`

def · line 50

- **Is:** `` zerosUpTo (T : ℝ) : Finset NontrivialZeros := (nontrivialZeros_abs_im_lt_finite (T + 1)).toFinset.filter (fun ρ => 0 < (ρ : ℂ).im ∧ (ρ : ℂ).im ≤ T) noncomputable ``
- **Used by 16:** [`Defect.N_eq_sum_lt`](../lean_stage3/Defect.md#Defect-N_eq_sum_lt), [`Defect.allCount_cast`](../lean_stage3/Defect.md#Defect-allCount_cast), [`Defect.defect_eq_offCount`](../lean_stage3/Defect.md#Defect-defect_eq_offCount), [`Defect.offCount`](../lean_stage3/Defect.md#Defect-offCount), [`Defect.offCount_eq_two_mul`](../lean_stage3/Defect.md#Defect-offCount_eq_two_mul), [`Defect.offLine_pair`](../lean_stage3/Defect.md#Defect-offLine_pair), [`Defect.zerosUpTo_eq_right`](../lean_stage3/Defect.md#Defect-zerosUpTo_eq_right), [`LevinsonArg.distinct_line_zeros_le_lineCount`](../lean_stage3/LevinsonArg.md#LevinsonArg-distinct_line_zeros_le_lineCount), [`LevinsonMultiple.sum_order_le_lineCount`](../lean_stage3/LevinsonMultiple.md#LevinsonMultiple-sum_order_le_lineCount), [`LevinsonWindowNear.sum_order_le_lineCount_sub`](../lean_stage3/LevinsonWindowNear.md#LevinsonWindowNear-sum_order_le_lineCount_sub), [`LineCount.allCount`](#LineCount-allCount), [`LineCount.lineCount`](#LineCount-lineCount), [`LineCount.mem_zerosUpTo`](#LineCount-mem_zerosUpTo), [`LineCount.rh_iff_line_count`](#LineCount-rh_iff_line_count), [`LineCount.signChanges_le_line_count`](#LineCount-signChanges_le_line_count), [`Turing.allCount_add_card_le_N`](../lean_stage3/TuringCert.md#Turing-allCount_add_card_le_N)

<a name="LineCount-allCount"></a>
### `LineCount.allCount`

def · line 56

- **Is:** `` allCount (T : ℝ) : ℤ := ∑ ρ ∈ zerosUpTo T, riemannZeta.order (ρ : ℂ) noncomputable ``
- **Built from:** [`LineCount.zerosUpTo`](#LineCount-zerosUpTo)
- **Used by 15:** [`Defect.N_eq_allCount_of_no_zero_at`](../lean_stage3/Defect.md#Defect-N_eq_allCount_of_no_zero_at), [`Defect.N_eq_allCount_right`](../lean_stage3/Defect.md#Defect-N_eq_allCount_right), [`Defect.N_le_allCount`](../lean_stage3/Defect.md#Defect-N_le_allCount), [`Defect.allCount_cast`](../lean_stage3/Defect.md#Defect-allCount_cast), [`Defect.defect`](../lean_stage3/Defect.md#Defect-defect), [`Defect.defectN_eq`](../lean_stage3/Defect.md#Defect-defectN_eq), [`Defect.defect_eq_offCount`](../lean_stage3/Defect.md#Defect-defect_eq_offCount), [`Defect.defect_le`](../lean_stage3/Defect.md#Defect-defect_le), [`Defect.defect_le_of_floor`](../lean_stage3/Defect.md#Defect-defect_le_of_floor), [`LineCount.lineCount_le_allCount`](#LineCount-lineCount_le_allCount), [`LineCount.rh_iff_line_count`](#LineCount-rh_iff_line_count), [`Turing.allCount_add_card_le_N`](../lean_stage3/TuringCert.md#Turing-allCount_add_card_le_N), [`Turing.count_le_N_sub`](../lean_stage3/TuringCert.md#Turing-count_le_N_sub), [`Turing.defect_zero_of_signs`](../lean_stage3/TuringCert.md#Turing-defect_zero_of_signs), [`TuringSlope.defect_zero_of_signs'`](../lean_stage3/TuringSlope.md#TuringSlope-defect_zero_of_signs-)

<a name="LineCount-lineCount"></a>
### `LineCount.lineCount`

def · line 61

- **Is:** `` lineCount (T : ℝ) : ℤ := ∑ ρ ∈ (zerosUpTo T).filter (fun ρ : NontrivialZeros => (ρ : ℂ).re = 1 / 2), riemannZeta.order (ρ : ℂ) ``
- **Built from:** [`LineCount.zerosUpTo`](#LineCount-zerosUpTo)
- **Used by 40:** [`ConreyCount.conrey_count_sub`](../lean_stage3/ConreyCount.md#ConreyCount-conrey_count_sub), [`ConreyCount.conrey_count_window`](../lean_stage3/ConreyCount.md#ConreyCount-conrey_count_window), [`ConreyCount.lineCount_ge_argW`](../lean_stage3/ConreyCountLine.md#ConreyCount-lineCount_ge_argW), [`Defect.N_eq_allCount_right`](../lean_stage3/Defect.md#Defect-N_eq_allCount_right), [`Defect.defect`](../lean_stage3/Defect.md#Defect-defect), [`Defect.defectN`](../lean_stage3/Defect.md#Defect-defectN), [`Defect.defect_eq_offCount`](../lean_stage3/Defect.md#Defect-defect_eq_offCount), [`Defect.defect_le_of_floor`](../lean_stage3/Defect.md#Defect-defect_le_of_floor), [`DigammaBound.conrey_count_window'`](../lean_stage3/DigammaBound.md#DigammaBound-conrey_count_window-), [`FloorLong.floor_lt_half`](../lean_stage3/FloorLong.md#FloorLong-floor_lt_half), [`FloorLong.floor_of_long`](../lean_stage3/FloorLong.md#FloorLong-floor_of_long), [`FloorLong.levinson_floor_of_long`](../lean_stage3/FloorLong.md#FloorLong-levinson_floor_of_long), [`FloorLong.floor_step_long`](../lean_stage3/FloorLongStep.md#FloorLong-floor_step_long), [`FloorQ.levinson_floorQ`](../lean_stage3/FloorQ.md#FloorQ-levinson_floorQ), [`FloorQ.stepQ`](../lean_stage3/FloorQ.md#FloorQ-stepQ), [`FloorQ.floor_stepQ`](../lean_stage3/FloorQStep.md#FloorQ-floor_stepQ), [`FloorQ.conrey_window_diff`](../lean_stage3/FloorQWindow.md#FloorQ-conrey_window_diff), [`FloorStep.floor_step`](../lean_stage3/FloorStep.md#FloorStep-floor_step), [`FloorSum.levinson_floor`](../lean_stage3/FloorSum.md#FloorSum-levinson_floor), [`FloorSum.step_X`](../lean_stage3/FloorSum.md#FloorSum-step_X), [`LevinsonArg.distinct_line_zeros_le_lineCount`](../lean_stage3/LevinsonArg.md#LevinsonArg-distinct_line_zeros_le_lineCount), [`LevinsonArg.lineCount_ge_arg`](../lean_stage3/LevinsonArg.md#LevinsonArg-lineCount_ge_arg), [`LevinsonCount.levinson_count`](../lean_stage3/LevinsonCount.md#LevinsonCount-levinson_count), [`LevinsonMultiple.levinson_count'`](../lean_stage3/LevinsonMultiple.md#LevinsonMultiple-levinson_count-), [`LevinsonMultiple.levinson_window'`](../lean_stage3/LevinsonMultiple.md#LevinsonMultiple-levinson_window-), [`LevinsonMultiple.sum_order_le_lineCount`](../lean_stage3/LevinsonMultiple.md#LevinsonMultiple-sum_order_le_lineCount), [`LevinsonWindow.levinson_window`](../lean_stage3/LevinsonWindow.md#LevinsonWindow-levinson_window), [`LevinsonWindow.lineCount_mono`](../lean_stage3/LevinsonWindow.md#LevinsonWindow-lineCount_mono), [`LevinsonWindowNear.levinson_count_sub`](../lean_stage3/LevinsonWindowNear.md#LevinsonWindowNear-levinson_count_sub), [`LevinsonWindowNear.levinson_window_diff`](../lean_stage3/LevinsonWindowNear.md#LevinsonWindowNear-levinson_window_diff), [`LevinsonWindowNear.levinson_window_near`](../lean_stage3/LevinsonWindowNear.md#LevinsonWindowNear-levinson_window_near), [`LevinsonWindowNear.lineCount_nonneg`](../lean_stage3/LevinsonWindowNear.md#LevinsonWindowNear-lineCount_nonneg), [`LevinsonWindowNear.sum_order_le_lineCount_sub`](../lean_stage3/LevinsonWindowNear.md#LevinsonWindowNear-sum_order_le_lineCount_sub), [`LineCount.lineCount_le_allCount`](#LineCount-lineCount_le_allCount), [`LineCount.rh_iff_line_count`](#LineCount-rh_iff_line_count), [`LineCount.signChanges_le_line_count`](#LineCount-signChanges_le_line_count), [`SignData.nine_zeros_on_line`](../lean_stage3/SignData.md#SignData-nine_zeros_on_line), [`SignData.one_zero_on_line`](../lean_stage3/SignData.md#SignData-one_zero_on_line), [`Turing.defect_zero_of_signs`](../lean_stage3/TuringCert.md#Turing-defect_zero_of_signs), [`TuringSlope.defect_zero_of_signs'`](../lean_stage3/TuringSlope.md#TuringSlope-defect_zero_of_signs-)

## Theorems

<a name="LineCount-mem_zerosUpTo"></a>
### `LineCount.mem_zerosUpTo`

line 67 · arrows read from text

**Counting.** Integers only: nothing in its statement or proof, or in anything it rests on, uses analysis or ζ.

**Proves**

```lean
ρ ∈ zerosUpTo T ↔ 0 < (ρ : ℂ).im ∧ (ρ : ℂ).im ≤ T
```

**Fed by:** no theorem of this repo; it stands on Mathlib and the definitions below.

**Definitions its proof touches:** [`LineCount.zerosUpTo`](#LineCount-zerosUpTo)

**Feeds** (12 that use it)

  - [`Defect.N_eq_allCount_of_no_zero_at`](../lean_stage3/Defect.md#Defect-N_eq_allCount_of_no_zero_at) (Defect) — `` riemannZeta.N T = (allCount T : ℝ) ``
  - [`Defect.N_eq_allCount_right`](../lean_stage3/Defect.md#Defect-N_eq_allCount_right) (Defect) — `` riemannZeta.N T' = (allCount T : ℝ) ∧ lineCount T' = lineCount T ``
  - [`Defect.N_eq_sum_lt`](../lean_stage3/Defect.md#Defect-N_eq_sum_lt) (Defect) — `` riemannZeta.N T = ∑ ρ ∈ (zerosUpTo T).filter (fun ρ : NontrivialZeros => (ρ : ℂ).im < T), ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) ``
  - [`Defect.offLine_pair`](../lean_stage3/Defect.md#Defect-offLine_pair) (Defect) — `` SpiralLink.mirrorZ ρ ∈ (zerosUpTo T).filter (fun ρ : NontrivialZeros => ¬ (ρ : ℂ).re = 1 / 2) ∧ SpiralLink.mirrorZ ρ ≠ ρ ∧ ((SpiralLink.mirrorZ ρ : No… ``
  - [`Defect.zerosUpTo_eq_right`](../lean_stage3/Defect.md#Defect-zerosUpTo_eq_right) (Defect) — `` zerosUpTo T' = zerosUpTo T ``
  - [`LevinsonArg.distinct_line_zeros_le_lineCount`](../lean_stage3/LevinsonArg.md#LevinsonArg-distinct_line_zeros_le_lineCount) (LevinsonArg) — `` (k : ℤ) ≤ lineCount T ``
  - [`LevinsonMultiple.sum_order_le_lineCount`](../lean_stage3/LevinsonMultiple.md#LevinsonMultiple-sum_order_le_lineCount) (LevinsonMultiple) — `` ∑ γ ∈ E, riemannZeta.order (1/2 + γ * I) ≤ lineCount T ``
  - [`LevinsonWindowNear.sum_order_le_lineCount_sub`](../lean_stage3/LevinsonWindowNear.md#LevinsonWindowNear-sum_order_le_lineCount_sub) (LevinsonWindowNear) — `` ∑ γ ∈ E, riemannZeta.order (1/2 + γ * I) ≤ lineCount b - lineCount a ``
  - [`LineCount.rh_iff_line_count`](#LineCount-rh_iff_line_count) — `` RiemannHypothesis ↔ ∀ T : ℝ, lineCount T = allCount T ``
  - [`LineCount.signChanges_le_line_count`](#LineCount-signChanges_le_line_count) — `` (k : ℤ) ≤ lineCount T ``
  - [`Turing.allCount_add_card_le_N`](../lean_stage3/TuringCert.md#Turing-allCount_add_card_le_N) (TuringCert) — `` (allCount T₁ : ℝ) + Z.card ≤ riemannZeta.N u ``
  - [`Turing.defect_mono`](../lean_stage3/TuringCert.md#Turing-defect_mono) (TuringCert) — `` defect T ≤ defect T' ``

<a name="LineCount-strictSignChange_zero_on_line"></a>
### `LineCount.strictSignChange_zero_on_line`

line 80 · arrows read from text

**Reads ζ.** It, or something it rests on, uses the zeta function, its zeros or the Riemann hypothesis.

**Why.** A strict sign change of `t ↦ Λ(1/2 + t i)` on `[t₁, t₂]` gives a zero of `ζ` on the line at height in the open interval `(t₁, t₂)`.

**Proves**

```lean
∃ γ ∈ Set.Ioo t₁ t₂, riemannZeta (1/2 + γ * I) = 0
```

**Needs** (its hypotheses)

  - `` h : t₁ < t₂ ``
  - `` hs : (completedRiemannZeta (1/2 + t₁ * I)).re * (completedRiemannZeta (1/2 + t₂ * I)).re < 0 ``

**Fed by** (3 theorems its proof uses)

  - [`HardyZ.continuous_xi_line`](../lean_stage3/HardyZ.md#HardyZ-continuous_xi_line) (HardyZ) — `` Continuous (fun t : ℝ => completedRiemannZeta (1/2 + t * Complex.I)) ``
  - [`HardyZ.re_line`](../lean_stage3/HardyZ.md#HardyZ-re_line) (HardyZ) — `` ((1 / 2 : ℂ) + t * I).re = 1 / 2 ``
  - [`HardyZ.xi_line_real`](../lean_stage3/HardyZ.md#HardyZ-xi_line_real) (HardyZ) — `` (completedRiemannZeta (1/2 + t * Complex.I)).im = 0 ``

**Feeds** (2 that use it)

  - [`LineCount.signChanges_le_line_count`](#LineCount-signChanges_le_line_count) — `` (k : ℤ) ≤ lineCount T ``
  - [`Turing.count_le_N_sub`](../lean_stage3/TuringCert.md#Turing-count_le_N_sub) (TuringCert) — `` (∑ j : Fin m, if s j.succ < u then (1 : ℝ) else 0) ≤ riemannZeta.N u - (allCount T₁ : ℝ) ``

<a name="LineCount-conj_mem"></a>
### `LineCount.conj_mem`

line 103 · arrows read from text

**Reads ζ.** It, or something it rests on, uses the zeta function, its zeros or the Riemann hypothesis.

**Why.** The conjugate of a nontrivial zero is a nontrivial zero.

**Proves**

```lean
conj (ρ : ℂ) ∈ NontrivialZeros
```

**Needs** (its hypotheses)

  - `` ρ : NontrivialZeros ``

**Fed by:** no theorem of this repo; it stands on Mathlib.

**Feeds** (1 that use it)

  - [`LineCount.rh_iff_line_count`](#LineCount-rh_iff_line_count) — `` RiemannHypothesis ↔ ∀ T : ℝ, lineCount T = allCount T ``

<a name="LineCount-lineCount_le_allCount"></a>
### `LineCount.lineCount_le_allCount`

line 110 · arrows read from text

**Reads ζ.** It, or something it rests on, uses the zeta function, its zeros or the Riemann hypothesis.

**Why.** Line count below the count.

**Proves**

```lean
lineCount T ≤ allCount T
```

**Needs** (its hypotheses)

  - `` T : ℝ ``

**Fed by:** no theorem of this repo; it stands on Mathlib and the definitions below.

**Definitions its proof touches:** [`LineCount.allCount`](#LineCount-allCount), [`LineCount.lineCount`](#LineCount-lineCount)

**Feeds** (1 that use it)

  - [`Defect.defect_nonneg`](../lean_stage3/Defect.md#Defect-defect_nonneg) (Defect) — `` 0 ≤ defect T ``

<a name="LineCount-rh_iff_line_count"></a>
### `LineCount.rh_iff_line_count`

line 117 · arrows read from text

**Reads ζ.** It, or something it rests on, uses the zeta function, its zeros or the Riemann hypothesis.

**Why.** RH is the line count. RH holds exactly when, at every height, the zeros on the line with multiplicity number all the nontrivial zeros.

**Proves**

```lean
RiemannHypothesis ↔ ∀ T : ℝ, lineCount T = allCount T
```

**Fed by** (4 theorems its proof uses)

  - [`ClosedLoopJoin.rh_iff_re_half`](../lean_stage3/ClosedLoopJoin.md#ClosedLoopJoin-rh_iff_re_half) (ClosedLoopJoin) — `` RiemannHypothesis ↔ ∀ ρ : NontrivialZeros, (ρ : ℂ).re = 1 / 2 ``
  - [`CountModes.im_ne_zero`](../lean_stage3/CountModes.md#CountModes-im_ne_zero) (CountModes) — `` (ρ : ℂ).im ≠ 0 ``
  - [`LineCount.conj_mem`](#LineCount-conj_mem) — `` conj (ρ : ℂ) ∈ NontrivialZeros ``
  - [`LineCount.mem_zerosUpTo`](#LineCount-mem_zerosUpTo) — `` ρ ∈ zerosUpTo T ↔ 0 < (ρ : ℂ).im ∧ (ρ : ℂ).im ≤ T ``

**Definitions its proof touches:** [`LineCount.allCount`](#LineCount-allCount), [`LineCount.lineCount`](#LineCount-lineCount), [`LineCount.zerosUpTo`](#LineCount-zerosUpTo)

**Feeds** (1 that use it)

  - [`Defect.rh_iff_defect_zero`](../lean_stage3/Defect.md#Defect-rh_iff_defect_zero) (Defect) — `` RiemannHypothesis ↔ ∀ T : ℝ, defect T = 0 ``

<a name="LineCount-signChanges_le_line_count"></a>
### `LineCount.signChanges_le_line_count`

line 155 · arrows read from text

**Reads ζ.** It, or something it rests on, uses the zeta function, its zeros or the Riemann hypothesis.

**Why.** Sign changes give zeros on the line. `k` strict sign changes of `t ↦ Λ(1/2 + t i)` on consecutive intervals of a strictly increasing sequence in `(0, T]` give at least `k` zeros on the line up to height `T`, with multiplicity.

**Proves**

```lean
(k : ℤ) ≤ lineCount T
```

**Needs** (its hypotheses)

  - `` t : Fin (k + 1) → ℝ ``
  - `` hmono : StrictMono t ``
  - `` h0 : 0 < t 0 ``
  - `` hT : t (Fin.last k) ≤ T ``
  - `` hs : ∀ i : Fin k, (completedRiemannZeta (1/2 + t i.castSucc * I)).re * (completedRiemannZeta (1/2 + t i.succ * I)).re < 0 ``

**Fed by** (3 theorems its proof uses)

  - [`HardyZ.re_line`](../lean_stage3/HardyZ.md#HardyZ-re_line) (HardyZ) — `` ((1 / 2 : ℂ) + t * I).re = 1 / 2 ``
  - [`LineCount.mem_zerosUpTo`](#LineCount-mem_zerosUpTo) — `` ρ ∈ zerosUpTo T ↔ 0 < (ρ : ℂ).im ∧ (ρ : ℂ).im ≤ T ``
  - [`LineCount.strictSignChange_zero_on_line`](#LineCount-strictSignChange_zero_on_line) — `` ∃ γ ∈ Set.Ioo t₁ t₂, riemannZeta (1/2 + γ * I) = 0 ``

**Definitions its proof touches:** [`LineCount.lineCount`](#LineCount-lineCount), [`LineCount.zerosUpTo`](#LineCount-zerosUpTo)

**Feeds** (4 that use it)

  - [`SignData.nine_zeros_on_line`](../lean_stage3/SignData.md#SignData-nine_zeros_on_line) (SignData) — `` (9 : ℤ) ≤ LineCount.lineCount 49 ``
  - [`SignData.one_zero_on_line`](../lean_stage3/SignData.md#SignData-one_zero_on_line) (SignData) — `` (1 : ℤ) ≤ LineCount.lineCount (29 / 2) ``
  - [`Turing.defect_zero_of_signs`](../lean_stage3/TuringCert.md#Turing-defect_zero_of_signs) (TuringCert) — `` ∀ T ≤ T₁, defect T = 0 ``
  - [`TuringSlope.defect_zero_of_signs'`](../lean_stage3/TuringSlope.md#TuringSlope-defect_zero_of_signs-) (TuringSlope) — `` ∀ T ≤ T₁, defect T = 0 ``

