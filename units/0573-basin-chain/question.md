> Source: session transcript, 2026-11-25

> Yes to all please

It answered the proposal to build steps 3 to 5 of the chain in Lean, with step 2, no right zeros of V, as their one hypothesis.

From `lean_stage3/Stage3/BasinChain*.lean`, the pinned statements:

```
theorem rh_of_noRightZeros {Q : ℝ[X]}
    (hQ : ∀ x : ℝ, Q.derivative.eval x = Q.derivative.eval (1 - x))
    (hQh : Q.eval (1/2) ≠ 0) (hQ0 : Q.eval 0 = 1) {T₀ a₂ b₂ T₀' : ℝ}
    (hNR : StmtNoRightZeros Q T₀) (hLow : StmtVHorizLower Q a₂ b₂ T₀') (ha₂ : 0 ≤ a₂)
    (hbase : StmtNoFiniteDefect) :
    RiemannHypothesis :=
```

```
theorem defect_eventually_const {Q : ℝ[X]}
    (hQ : ∀ x : ℝ, Q.derivative.eval x = Q.derivative.eval (1 - x))
    (hQh : Q.eval (1/2) ≠ 0) (hQ0 : Q.eval 0 = 1) {T₀ a₂ b₂ T₀' : ℝ}
    (hNR : StmtNoRightZeros Q T₀) (hLow : StmtVHorizLower Q a₂ b₂ T₀') (ha₂ : 0 ≤ a₂) :
    ∃ T₂ : ℝ, ∀ T : ℝ, T₂ ≤ T → Defect.defect T = Defect.defect T₂ :=
```

```
theorem noRightZeros_one_of_rh (hRH : RiemannHypothesis) (T₀ : ℝ) (hT₀ : 0 < T₀) :
    StmtNoRightZeros 1 T₀ :=
```

```
theorem count_exact {Q : ℝ[X]}
    (hQ : ∀ x : ℝ, Q.derivative.eval x = Q.derivative.eval (1 - x))
    (hQh : Q.eval (1/2) ≠ 0) {L a b : ℝ} (ha : 4 ≤ a) (hab : a < b)
    (hBot : ∀ x ∈ Icc (1/2 : ℝ) 3, V Q L (↑x + ↑a * I) ≠ 0)
    (hTop : ∀ x ∈ Icc (1/2 : ℝ) 3, V Q L (↑x + ↑b * I) ≠ 0)
    (hζa : riemannZeta (1/2 + a * I) ≠ 0)
    (hRne : ∀ t ∈ Icc a b, V Q L (3 + t * I) ≠ 0) :
    ((Stage3.phaseTheta b - Stage3.phaseTheta a)
        + ((∫ x in (1/2:ℝ)..3, logDeriv (V Q L) (↑x + ↑a * I)).im
          - (∫ x in (1/2:ℝ)..3, logDeriv (V Q L) (↑x + ↑b * I)).im
          + (∫ t in a..b, logDeriv (V Q L) (3 + ↑t * I)).re)) / Real.pi
      - 2 * Littlewood.countRight (V Q L) ((1/2 : ℂ) + a * I) ((3 : ℂ) + b * I) (1/2) - 1
        < (lineCount b : ℝ) - (lineCount a : ℝ) :=
```

```
theorem right_edge_le_arcsin {G : ℂ → ℂ} {a b r : ℝ} (hab : a ≤ b)
    (hGa : ∀ t ∈ Set.Icc a b, AnalyticAt ℂ G (3 + t * I)) (hr : r < 1)
    (hnear : ∀ t ∈ Set.Icc a b, ‖G (3 + t * I) - 1‖ ≤ r) :
    |(∫ t in a..b, logDeriv G (3 + t * I)).re| ≤ 2 * Real.arcsin r :=
```

```
theorem split_V (Q : ℝ[X]) (L : ℝ) {t₁ t₂ : ℝ} (h1 : 1/2 < t₁) (h12 : t₁ ≤ t₂)
    (hne : V Q L (3 + t₁ * I) ≠ 0) :
    IntervalIntegrable (fun t => hEdge Q L t) volume t₁ t₂ ∧
    ∫ t in t₁..t₂, hEdge Q L t = logJ Q L t₁ - logJ Q L t₂ :=
```

```
theorem increment_avg {Q : ℝ[X]}
    (hQ : ∀ x : ℝ, Q.derivative.eval x = Q.derivative.eval (1 - x))
    (hQh : Q.eval (1/2) ≠ 0) (hQ0 : Q.eval 0 = 1) {T₀ a₂ b₂ T₀' : ℝ}
    (hNR : StmtNoRightZeros Q T₀) (hLow : StmtVHorizLower Q a₂ b₂ T₀') (ha₂ : 0 ≤ a₂) :
    ∃ A T₁ : ℝ, 0 < A ∧ 200 ≤ T₁ ∧ ∀ T : ℝ, T₁ ≤ T →
      ((Defect.defect T : ℝ) - (Defect.defect (3 * T / 4) : ℝ)) ≤
        4 * ((2 * ((3 / 2 + 113 / 4) / Real.pi) + (5 + 2 * a₂) / Real.pi) * Real.log (2 * T)
          + (2 * ((2 + (3 / 2) * Real.log 9 + 128) / Real.pi)
            + (5 * Real.log (A + 1) + 2 * b₂) / Real.pi)) / T
        + (1 + 2 * Real.arcsin (Real.pi ^ 2 / 6 - 1 + 1 / 100) / Real.pi) :=
```

```
theorem c0_lt_two : 1 + 2 * Real.arcsin (Real.pi ^ 2 / 6 - 1 + 1 / 100) / Real.pi < 2 :=
```

