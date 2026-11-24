> Source: session transcript, 2026-11-24

> Yes



From `lean_stage3/Stage3/LevinsonEdge.lean`, the pinned statements:

```
theorem horizontal_edge_le {c T : ℝ} (hc0 : 0 ≤ c) (hc1 : c ≤ 1) (hT : 4 ≤ T)
    (hne : ∀ x ∈ Set.Icc (1/2:ℝ) 3,
      riemannZeta (↑x + ↑T * I) + c * deriv riemannZeta (↑x + ↑T * I) ≠ 0) :
    |(∫ x in (1/2:ℝ)..3,
        logDeriv (fun s => riemannZeta s + c * deriv riemannZeta s) (↑x + ↑T * I)).im|
      ≤ 21 * Real.pi * Real.log T + 133 * Real.pi :=
```

```
theorem edge_le_of_bound {G : ℂ → ℂ} {T M : ℝ} (hT : 4 ≤ T)
    (hGa : ∀ w : ℂ, w ≠ 1 → AnalyticAt ℂ G w)
    (h0 : 1 / 3 ≤ (G (3 + (T : ℂ) * I)).re)
    (hM : ∀ w : ℂ, ‖w - (3 + (T : ℂ) * I)‖ ≤ 21 / 8 → ‖G w‖ ≤ M)
    (hne : ∀ x ∈ Set.Icc (1/2:ℝ) 3, G (↑x + ↑T * I) ≠ 0) :
    |(∫ x in (1/2:ℝ)..3, logDeriv G (↑x + ↑T * I)).im|
      ≤ Real.pi * (21 * Real.log (3 * M) + 1) :=
```

```
theorem real_zero_count {g : ℂ → ℂ} {m M : ℝ}
    (hd : DifferentiableOn ℂ g (Metric.ball (0 : ℂ) (11 / 10))) (hm : 0 < m)
    (h0 : m ≤ (g 0).re) (hM : ∀ z : ℂ, ‖z‖ ≤ 7 / 8 → ‖g z‖ ≤ M) :
    ∃ Z : Finset ℝ, (∀ x : ℝ, |x| ≤ 5 / 6 → (g x).re = 0 → x ∈ Z) ∧
      (Z.card : ℝ) ≤ 21 * Real.log (M / m) :=
```

```
theorem G_disc_le {c : ℝ} (hc0 : 0 ≤ c) (hc1 : c ≤ 1) {T : ℝ} (hT : 4 ≤ T) {w : ℂ}
    (hw : ‖w - (3 + (T : ℂ) * I)‖ ≤ 21 / 8) :
    ‖riemannZeta w + c * deriv riemannZeta w‖ ≤ 36 * T + 225 :=
```

```
theorem deriv_zeta_disc_le {T : ℝ} (hT : 4 ≤ T) {w : ℂ}
    (hw : ‖w - (3 + (T : ℂ) * I)‖ ≤ 21 / 8) : ‖deriv riemannZeta w‖ ≤ 32 * T + 200 :=
```

```
theorem zeta_norm_le {u : ℂ} (hre : 1 / 4 ≤ u.re) (him : 1 ≤ u.im) :
    ‖riemannZeta u‖ ≤ 2 + 4 * ‖u‖ :=
```

