> Source: session transcript, 2026-11-25

> start the next step



From `lean_stage3/Stage3/ApproxFE.lean`, the pinned statements:

```
theorem zeta_prod_fe {α β : ℂ} {t : ℝ} (hα : α.re < 1 / 2) (hβ : β.re < 1 / 2)
    (hu : Gammaℝ (uA α t) ≠ 0) (hv : Gammaℝ (vB β t) ≠ 0) :
    riemannZeta (uA α t) * riemannZeta (vB β t) =
      XY α β t * (riemannZeta (1 / 2 - α - t * I) * riemannZeta (1 / 2 - β + t * I)) :=
```

```
theorem XY_eq_young (α β : ℂ) (t : ℝ) :
    XY α β t = (Real.pi : ℂ) ^ (α + β) *
      (Gamma ((1 / 2 - α - t * I) / 2) * Gamma ((1 / 2 - β + t * I) / 2)) /
      (Gamma ((1 / 2 + α + t * I) / 2) * Gamma ((1 / 2 + β - t * I) / 2)) :=
```

```
theorem gY_eq_young (α β : ℂ) (t : ℝ) (s : ℂ) :
    gY α β t s = (Real.pi : ℂ) ^ (-s) *
      (Gamma ((1 / 2 + α + s + t * I) / 2) * Gamma ((1 / 2 + β + s - t * I) / 2)) /
      (Gamma ((1 / 2 + α + t * I) / 2) * Gamma ((1 / 2 + β - t * I) / 2)) :=
```

```
theorem coef_eq_young (α β : ℂ) (t : ℝ) {x y : ℝ} (hx : 0 < x) (hy : 0 < y) :
    (x : ℂ) ^ (-uA α t) * (y : ℂ) ^ (-vB β t) =
      (x : ℂ) ^ (-(1 / 2 + α)) * (y : ℂ) ^ (-(1 / 2 + β)) * ((x / y : ℝ) : ℂ) ^ (-(t * I)) :=
```

```
theorem mellin_double_sum {α β : ℂ} {t c : ℝ} (hc : 0 < c) (hu : 1 / 2 < c + α.re)
    (hv : 1 / 2 < c + β.re) :
    ∑' p : ℕ × ℕ, ((p.1 : ℂ) + 1) ^ (-uA α t) * ((p.2 : ℂ) + 1) ^ (-vB β t) *
        VY α β c (((p.1 : ℝ) + 1) * ((p.2 : ℝ) + 1)) t =
      VerticalIntegral' (FY α β t) c :=
```

```
theorem FY_reflect {α β : ℂ} {t : ℝ} {s : ℂ} (hα : α.re < 1 / 2) (hβ : β.re < 1 / 2)
    (hu : Gammaℝ (uA α t) ≠ 0) (hv : Gammaℝ (vB β t) ≠ 0) (hs0 : s ≠ 0)
    (h1 : 0 < (1 - uA α t + s).re) (h2 : 0 < (1 - vB β t + s).re)
    (hg1 : Gammaℝ (uA α t + -s) ≠ 0) (hg2 : Gammaℝ (vB β t + -s) ≠ 0) :
    FY α β t (-s) = -(XY α β t * FY (-β) (-α) t s) :=
```

```
theorem vertInt_reflect {α β : ℂ} {t c : ℝ} (hc : 0 < c) (hα : α.re < 1 / 2)
    (hβ : β.re < 1 / 2) (hu : Gammaℝ (uA α t) ≠ 0) (hv : Gammaℝ (vB β t) ≠ 0) :
    VerticalIntegral' (FY α β t) (-c) =
      -(XY α β t * VerticalIntegral' (FY (-β) (-α) t) c) :=
```

```
theorem residue_zero {α β : ℂ} {t : ℝ} (hαβ : α + β ≠ 0) (hα : α.re < 1 / 2)
    (hβ : β.re < 1 / 2) (hu : Gammaℝ (uA α t) ≠ 0) (hv : Gammaℝ (vB β t) ≠ 0) :
    Tendsto (fun s => s * FY α β t s) (𝓝[≠] 0)
      (𝓝 (riemannZeta (uA α t) * riemannZeta (vB β t))) :=
```

```
theorem approxFE_of_shift {α β : ℂ} {t c : ℝ} (hα : α.re < 1 / 2) (hβ : β.re < 1 / 2)
    (hα' : -(1 / 2) < α.re) (hβ' : -(1 / 2) < β.re)
    (hcα : 1 / 2 + |α.re| < c) (hcβ : 1 / 2 + |β.re| < c) (hshift : StmtShift α β t c) :
    riemannZeta (uA α t) * riemannZeta (vB β t) =
      (∑' p : ℕ × ℕ, ((p.1 : ℂ) + 1) ^ (-uA α t) * ((p.2 : ℂ) + 1) ^ (-vB β t) *
        VY α β c (((p.1 : ℝ) + 1) * ((p.2 : ℝ) + 1)) t) +
      XY α β t * (∑' p : ℕ × ℕ, ((p.1 : ℂ) + 1) ^ (-uA (-β) t) *
        ((p.2 : ℂ) + 1) ^ (-vB (-α) t) *
        VY (-β) (-α) c (((p.1 : ℝ) + 1) * ((p.2 : ℝ) + 1)) t) - resY α β t :=
```

