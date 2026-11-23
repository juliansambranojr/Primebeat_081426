> Source: session transcript, 2026-11-23

> The explicit formula below x = 16 is still not in the tree



From `lean_stage3/Stage3/ExplicitTwo.lean`, the pinned statements:

```
theorem residue_identity_two {x T T' : ℝ} (hx : 1 < x) (hT : 2 ≤ T)
    (hT' : T' ∈ Set.Icc T (T+1))
    (hgood : ∀ ρ : ℂ, riemannZeta ρ = 0 → 0 < ρ.re → zeroGap T ≤ |ρ.im - T'|) :
    RectangleIntegral'
        (fun s : ℂ ↦ (- deriv riemannZeta s / riemannZeta s)
          * ((x:ℝ):ℂ) ^ s / s)
        (((-1/4 : ℝ):ℂ) - Complex.I * T') (((1 + 1/Real.log x : ℝ):ℂ) + Complex.I * T')
      = (x : ℂ) - deriv riemannZeta 0 / riemannZeta 0
        - Stage3.zeroPartialSum x T' :=
```

```
theorem edge_horizontal_bound_two :
    ∀ x T T' : ℝ, 2 ≤ x → 2 ≤ T → T' ∈ Set.Icc T (T+1) →
      (∀ ρ : ℂ, riemannZeta ρ = 0 → 0 < ρ.re →
        ContourShift.zeroGap T ≤ |ρ.im - T'|) →
      ∀ y : ℝ, |y| = T' →
      ‖HIntegral (Glue.Gf x) (-1/4) (1 + 1/Real.log x) y‖
        ≤ Cht * x * Real.log T ^ 2 / T :=
```

```
theorem explicit_formula_left_two {x T : ℝ} (hx : 2 ≤ x) (hT : 2 ≤ T) :
    ∃ T' : ℝ, T ≤ T' ∧ T' ≤ T + 1 ∧
      ‖(Chebyshev.psi x : ℂ) - (x:ℂ) + Stage3.zeroPartialSum x T‖
        ≤ c1t * x * Real.log (x*T)^2 / T + c3t * Real.log x
          + ‖VIntegral (Glue.Gf x) (-1/4) (-T') T'‖ :=
```

```
theorem left_edge_bound_two {x T : ℝ} (hx : 2 ≤ x) (hT : 2 ≤ T) :
    ‖VIntegral (Glue.Gf x) (-1/4) (-T) T‖ ≤ Bleft2 * x ^ (-(1:ℝ)/4) :=
```

```
theorem explicit_formula_all_two {x T : ℝ} (hx : 2 ≤ x) (hT : 2 ≤ T) :
    ‖(Chebyshev.psi x : ℂ) - (x:ℂ) + Stage3.zeroPartialSum x T‖
      ≤ c1t * x * Real.log (x*T)^2 / T + c3t * Real.log x
        + Bleft2 * x ^ (-(1:ℝ)/4) :=
```

