> Source: session transcript, 2026-11-25

> Yes to all please



From `lean_stage3/Stage3/FloorLong.lean`, the pinned statements:

```
theorem logmax_long {K x ε₁ : ℝ} (hε₁ : 0 < ε₁) (hx : x ≤ K + 2 * ε₁) :
    Real.log (max 1 x) ≤ Real.log (max 1 K) + 2 * ε₁ :=
```

```
theorem floor_of_long (P : Polynomial ℝ) (hP0 : P.eval 0 = 0) (hP1 : P.eval 1 = 1) {θ : ℝ}
    (hθ0 : 0 < θ) {R : ℝ} (hR : 0 < R) (hL : StmtLongErr P θ R) :
    ∀ ε : ℝ, 0 < ε → ∃ T₀ : ℝ, ∀ T : ℝ, T₀ ≤ T →
      (1 - Real.log (max 1 (Kfl (Ar P) (Br P) (Cr P) θ R)) / R - ε) * riemannZeta.N T ≤
        (LineCount.lineCount T : ℝ) :=
```

```
theorem floor_lt_half (P : Polynomial ℝ) (hP0 : P.eval 0 = 0) (hP1 : P.eval 1 = 1) {θ : ℝ}
    (hθ0 : 0 < θ) (hθ : θ < 1 / 2) {R : ℝ} (hR : 0 < R) :
    ∀ ε : ℝ, 0 < ε → ∃ T₀ : ℝ, ∀ T : ℝ, T₀ ≤ T →
      (1 - Real.log (max 1 (Kfl (Ar P) (Br P) (Cr P) θ R)) / R - ε) * riemannZeta.N T ≤
        (LineCount.lineCount T : ℝ) :=
```

```
theorem levinson_floor_of_long : ∀ ε : ℝ, 0 < ε → ∃ T₀ : ℝ, ∀ T : ℝ, T₀ ≤ T →
    (1 / 3 - ε) * riemannZeta.N T ≤ (LineCount.lineCount T : ℝ) :=
```

