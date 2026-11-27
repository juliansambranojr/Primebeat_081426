> Source: session transcript, 2026-11-25

> Start the sign data and the diagonal please



From `lean_stage3/Stage3/SignData.lean`, the pinned statements:

```
theorem first_zero_signs : Turing.StmtSignData 1 ![14, 29 / 2] :=
```

```
theorem run_signs :
    Turing.StmtSignData 9 ![14, 18, 23, 55 / 2, 63 / 2, 71 / 2, 39, 42, 91 / 2, 49] :=
```

```
theorem nine_zeros_on_line : (9 : ℤ) ≤ LineCount.lineCount 49 :=
```

```
theorem defect_zero_of_closing {T₁ h : ℝ} (hd : StmtClosingData T₁ h) (h2 : 2 ≤ T₁)
    (hh : 0 < h) : ∀ T ≤ T₁, Defect.defect T = 0 :=
```

