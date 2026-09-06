> Source: session transcript, 2026-09-06 (this session), the task that opened this module

> Your task: build one Lean module under this repo's module loop, for section 8 of lean_stage3/design/rung5.md (selection of the target), and commit it through the pre-commit gate together with its unit.

From `lean_stage3/design/rung5.md`, the section the module is built from:

> ## 8. Selection of the target — SKETCH

> Need: a target with `ε'² − Δ² ≤ ε² + K'π²λ/h` for every other zero, so the

> Choose `t_k` = a zero of largest real part among zeros with `|Im| ≤ T + k/2`

> The sequence `ε(t_k)` is nondecreasing and bounded by `1/2`. If

> Lean shape: a maximum over a finite set (zeros in a bounded region are

> induction on `k` with the bounded-increase argument.

From `lean_stage3/Stage3/WeilPowerSelect.lean`, the statements as built:

```
theorem farDelta_le {ε' Δ : ℝ} (hε'0 : 0 ≤ ε') (hε'half : ε' ≤ 1 / 2)
    (hΔ : 1 / 2 ≤ |Δ|) : ε' ^ 2 - Δ ^ 2 ≤ 0 := by
```

```
theorem exists_step_le {f : ℕ → ℝ} {B δ : ℝ}
    (hbound : ∀ k, f k ≤ B) (hnonneg : 0 ≤ f 0) {N : ℕ} (hN : B < (N : ℝ) * δ) :
    ∃ k < N, f (k + 1) ≤ f k + δ := by
```

```
theorem exists_target_step {E : ℕ → ℝ}
    (hbound : ∀ k, 0 ≤ E k ∧ E k ≤ 1 / 2) {K' lam h : ℝ}
    (hK' : 0 < K') (hlam : 0 < lam) (hh : 0 < h) :
    ∃ k : ℕ, (k : ℝ) ≤ h / (4 * K' * Real.pi ^ 2 * lam) ∧
      (E (k + 1)) ^ 2 ≤ (E k) ^ 2 + δSel K' lam h := by
```

```
theorem target_bound {E : ℕ → ℝ}
    (hbound : ∀ k, 0 ≤ E k ∧ E k ≤ 1 / 2) {K' lam h : ℝ}
    (hK' : 0 < K') (hlam : 0 < lam) (hh : 0 < h) :
    ∃ k : ℕ, (k : ℝ) ≤ h / (4 * K' * Real.pi ^ 2 * lam) ∧
      ∀ ε', 0 ≤ ε' → ε' ≤ E (k + 1) → ε' ^ 2 ≤ (E k) ^ 2 + δSel K' lam h := by
```

```
theorem target_height_le {k : ℕ} {K' lam h T : ℝ}
    (hk : (k : ℝ) ≤ h / (4 * K' * Real.pi ^ 2 * lam)) :
    T + (k : ℝ) / 2 ≤ T + h / (8 * K' * Real.pi ^ 2 * lam) := by
```

```
theorem target_ge_box {E : ℕ → ℝ} (hmono : Monotone E) (k : ℕ) : E 0 ≤ E k :=
```
