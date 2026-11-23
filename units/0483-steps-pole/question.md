> Source: session transcript, 2026-11-23

> The runs should be theorems.



From `lean_stage3/Stage3/StepsPole.lean`, the pinned statements:

```
theorem steps_pole (ρ : NontrivialZeros) :
    Tendsto (fun s : ℂ => (s - (ρ : ℂ)) * (- deriv riemannZeta s / riemannZeta s / s))
      (𝓝[≠] (ρ : ℂ))
      (𝓝 (-(analyticOrderNatAt riemannZeta (ρ : ℂ) : ℂ) / (ρ : ℂ))) :=
```

```
theorem steps_pole_ne_zero (ρ : NontrivialZeros) :
    -(analyticOrderNatAt riemannZeta (ρ : ℂ) : ℂ) / (ρ : ℂ) ≠ 0 :=
```

```
theorem steps_regular {s : ℂ} (hs1 : s ≠ 1) (hz : riemannZeta s ≠ 0) :
    AnalyticAt ℂ (fun t : ℂ => deriv riemannZeta t / riemannZeta t) s :=
```

