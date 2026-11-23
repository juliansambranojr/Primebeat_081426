> Source: session transcript, 2026-11-23

> The explicit formula below x = 16 is still not in the tree



From `lean_stage3/Stage3/PerronTwo.lean`, the pinned statements:

```
theorem far_terms_sum_two {x T : ℝ} (hx : 2 ≤ x) (hT : 2 ≤ T) :
    (∑' n : ℕ, if 1/2 ≤ |Real.log (x / n)| then
        ArithmeticFunction.vonMangoldt n * (x / n) ^ (1 + 1/Real.log x)
          / (T * |Real.log (x / n)|)
      else 0)
      ≤ 300 * x * Real.log (x * T) ^ 2 / T :=
```

```
theorem near_diagonal_sum_two {x T : ℝ} (hx : 2 ≤ x) (hT : 1 ≤ T) :
    (∑' n : ℕ, if 0 < |Real.log (x / n)| ∧ |Real.log (x / n)| < 1/2 then
        ArithmeticFunction.vonMangoldt n * min 1 (1/(T * |Real.log (x / n)|))
      else 0)
      ≤ 100 * x * Real.log (x * T) ^ 2 / T + 4 * Real.log x :=
```

```
theorem kernel_sum_bound_two {x T : ℝ} (hx : 2 ≤ x) (hT : 2 ≤ T) :
    ‖(∑' n : ℕ, (ArithmeticFunction.vonMangoldt n : ℂ)
          * (perronI (x/n) (1 + 1/Real.log x) T - perronδ (x/n)))‖
      ≤ 700 * x * Real.log (x * T) ^ 2 / T + 17 * Real.log x :=
```

```
theorem explicit_formula_perron_two {x T : ℝ} (hx : 2 ≤ x) (hT : 2 ≤ T) :
    ‖(Chebyshev.psi x : ℂ)
        - (2 * (Real.pi:ℂ) * Complex.I)⁻¹
          * ∫ t in (-T)..T,
              (- deriv riemannZeta (((1 + 1/Real.log x : ℝ):ℂ) + Complex.I * t)
                / riemannZeta (((1 + 1/Real.log x : ℝ):ℂ) + Complex.I * t))
              * ((x:ℝ):ℂ) ^ (((1 + 1/Real.log x : ℝ):ℂ) + Complex.I * t)
              / (((1 + 1/Real.log x : ℝ):ℂ) + Complex.I * t) * Complex.I‖
      ≤ 700 * x * Real.log (x * T) ^ 2 / T + 18 * Real.log x :=
```

