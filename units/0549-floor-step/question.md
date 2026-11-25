> Source: session transcript, 2026-11-25

> Yes to all please



From `lean_stage3/Stage3/FloorStep.lean`, the pinned statements:

```
theorem combine {ND LC L T lK Kb R ε td Wp τ Cw : ℝ}
    (hL1 : 1 ≤ L) (hT0 : 0 < T) (hR : 0 < R) (hε : 0 < ε)
    (hwin : ND - (1 / (Real.pi * (R / L))) * ((T - T / 2) / 2 * lK + ((T - T / 2) * (2 * td) + Wp))
      - (134 * L + 2918) ≤ LC)
    (htd : td ≤ τ) (hτ : τ ≤ ε * Real.pi * R / 4)
    (hWp : Wp ≤ Real.pi * Cw * L ^ 3) (hCw : 4 * Cw / (R * ε) * L ^ 3 ≤ T)
    (hN : T * L / (4 * Real.pi) - ND ≤ T + 224 * L + 1396)
    (hlK0 : 0 ≤ lK) (hlK : lK ≤ Kb) (hT224 : 224 * L + 1396 ≤ T)
    (hKbL : 8 * Kb / (R * ε) ≤ L) (h134 : 4 * 3052 / ε ≤ T) :
    ND - lK / R * ND - ε * T * L ≤ LC :=
```

```
theorem floor_step (P : Polynomial ℝ) (hP0 : P.eval 0 = 0) (hP1 : P.eval 1 = 1) {θ : ℝ}
    (hθ0 : 0 < θ) (hθ : θ < 1 / 2) {R : ℝ} (hR : 0 < R) :
    ∀ ε : ℝ, 0 < ε → ∃ T₀ : ℝ, ∀ T : ℝ, T₀ ≤ T →
      (riemannZeta.N T - riemannZeta.N (T / 2))
        - Real.log (max 1 ((Operator.Dop (Real.log T) (cY P (Mof T θ) T)
            ((-(R / Real.log T) : ℝ) : ℂ) ((-(R / Real.log T) : ℝ) : ℂ)).re + ε)) / R
          * (riemannZeta.N T - riemannZeta.N (T / 2))
        - ε * T * Real.log T
        ≤ (LineCount.lineCount T : ℝ) - (LineCount.lineCount (T / 2) : ℝ) :=
```

