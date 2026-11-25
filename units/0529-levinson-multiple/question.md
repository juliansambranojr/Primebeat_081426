> Source: session transcript, 2026-11-25

> Log it and count



From `lean_stage3/Stage3/LevinsonMultiple.lean`, the pinned statements:

```
theorem exists_prod_mul {S : Set ℂ} (n : ℂ → ℕ) (D : Finset ℂ) :
    ∀ f : ℂ → ℂ, (∀ ρ ∈ D, ρ ∈ S) → (∀ z ∈ S, AnalyticAt ℂ f z) →
    (∀ ρ ∈ D, (n ρ : ℕ∞) ≤ analyticOrderAt f ρ) →
    ∃ g : ℂ → ℂ, (∀ z ∈ S, AnalyticAt ℂ g z) ∧ ∀ z, f z = polyP D n z * g z :=
```

```
theorem G_order_add_one {c : ℝ} (hc : c ≠ 0) {ρ : ℂ} (hρ1 : ρ ≠ 1)
    (hz : riemannZeta ρ = 0)
    (hfin : analyticOrderAt (fun s => riemannZeta s + c * deriv riemannZeta s) ρ ≠ ⊤) :
    analyticOrderAt (fun s => riemannZeta s + c * deriv riemannZeta s) ρ + 1
      = analyticOrderAt riemannZeta ρ :=
```

```
theorem zeta_order_ge {c : ℝ} (hc : c ≠ 0) {ρ : ℂ} (hρ1 : ρ ≠ 1) (hz : riemannZeta ρ = 0)
    (hfin : analyticOrderAt (fun s => riemannZeta s + c * deriv riemannZeta s) ρ ≠ ⊤) :
    ((analyticOrderAt (fun s => riemannZeta s + c * deriv riemannZeta s) ρ).toNat : ℤ) + 1
      ≤ riemannZeta.order ρ :=
```

```
theorem sum_order_le_lineCount {T : ℝ} (E : Finset ℝ) (hpos : ∀ γ ∈ E, 0 < γ)
    (hT : ∀ γ ∈ E, γ ≤ T) (hζ : ∀ γ ∈ E, riemannZeta (1/2 + γ * I) = 0) :
    ∑ γ ∈ E, riemannZeta.order (1/2 + γ * I) ≤ lineCount T :=
```

```
theorem countRight_eq_of_mul {G P H : ℂ → ℂ} {z w : ℂ} {σ : ℝ}
    (hG : AnalyticOnNhd ℂ G (Rectangle z w)) (hH : AnalyticOnNhd ℂ H (Rectangle z w))
    (hP : ∀ p, AnalyticAt ℂ P p) (hPne : ∀ p ∈ Rectangle z w, σ < p.re → P p ≠ 0)
    (heq : G = P * H) (hGz : G z ≠ 0) (hHz : H z ≠ 0) :
    Littlewood.countRight G z w σ = Littlewood.countRight H z w σ :=
```

```
theorem factor_turn {a b : ℝ} {ρ : ℂ} (hre : ρ.re = 1/2) (ha : a < ρ.im) (hb : ρ.im < b) :
    (∫ x in (1/2:ℝ)..3, 1 / ((x:ℂ) + a * I - ρ)).im
      - (∫ x in (1/2:ℝ)..3, 1 / ((x:ℂ) + b * I - ρ)).im
      + (∫ t in a..b, 1 / ((3:ℂ) + t * I - ρ)).re = Real.pi :=
```

```
theorem polyP_edges {a b : ℝ} (hab : a ≤ b) {D : Finset ℂ} (n : ℂ → ℕ)
    (hD : ∀ ρ ∈ D, ρ.re = 1/2 ∧ a < ρ.im ∧ ρ.im < b) :
    (∫ x in (1/2:ℝ)..3, logDeriv (polyP D n) (↑x + ↑a * I)).im
      - (∫ x in (1/2:ℝ)..3, logDeriv (polyP D n) (↑x + ↑b * I)).im
      + (∫ t in a..b, logDeriv (polyP D n) (3 + ↑t * I)).re
      = Real.pi * ∑ ρ ∈ D, (n ρ : ℝ) :=
```

