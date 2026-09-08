> Source: session transcript, 2026-09-08, the count-to-argument step, block H2

> the count-to-argument step

> done, resume at § 5.

From `lean_stage3/Stage3/ReZetaCount.lean`, the four pinned statements:

```
theorem re_zeta_two_line_pos (t : ℝ) : 0 < (riemannZeta (2 + (t : ℂ) * Complex.I)).re
```

```
theorem F_count_le {T : ℝ} (hT : 2 ≤ T) :
    ∑ ρ ∈ (finiteSetOfZeros_mono (by norm_num : (7:ℝ)/8 < 1) (F_zeros_finite hT)).toFinset,
        (analyticOrderNatAt (F T) ρ : ℝ)
      ≤ 15 * Real.log T + 73
```

```
theorem mem_reZeros {T : ℝ} (hT : 2 ≤ T) {x : ℝ} :
    x ∈ reZeros hT ↔
      x ∈ Set.Ioo (1/2 : ℝ) 2 ∧ (riemannZeta ((x : ℂ) + T * Complex.I)).re = 0
```

```
theorem card_reZeros_le {T : ℝ} (hT : 2 ≤ T) :
    ((reZeros hT).card : ℝ) ≤ 15 * Real.log T + 73
```
