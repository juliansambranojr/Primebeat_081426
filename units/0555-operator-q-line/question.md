> Source: session transcript, 2026-11-25

> Yes to all please



From `lean_stage3/Stage3/OperatorQ.lean`, the pinned statements:

```
theorem im_I_pow_iteratedDeriv (k : ℕ) (t : ℝ) :
    (I ^ k * iteratedDeriv k completedRiemannZeta ((1/2 : ℂ) + t * I)).im = 0 :=
```

```
theorem re_iteratedDeriv_odd {k : ℕ} (hk : Odd k) (t : ℝ) :
    (iteratedDeriv k completedRiemannZeta ((1/2 : ℂ) + t * I)).re = 0 :=
```

```
theorem re_sum_line (a : ℕ → ℝ) (n : ℕ) (ha : ∀ k, Even k → k ≠ 0 → a k = 0) (t : ℝ) :
    (∑ k ∈ Finset.range (n + 1),
        (a k : ℂ) * iteratedDeriv k completedRiemannZeta ((1/2 : ℂ) + t * I)).re =
      a 0 * (completedRiemannZeta ((1/2 : ℂ) + t * I)).re :=
```

```
theorem coeff_comp_neg_X (p : ℝ[X]) (n : ℕ) :
    (p.comp (-X)).coeff n = (-1) ^ n * p.coeff n :=
```

```
theorem taylor_coeff_even_eq_zero (Q : ℝ[X])
    (hQ : ∀ x : ℝ, Q.derivative.eval x = Q.derivative.eval (1 - x))
    {k : ℕ} (hk : Even k) (hk0 : k ≠ 0) : (taylor (1/2 : ℝ) Q).coeff k = 0 :=
```

```
theorem re_W_line (Q : ℝ[X])
    (hQ : ∀ x : ℝ, Q.derivative.eval x = Q.derivative.eval (1 - x)) (L t : ℝ) :
    (W Q L ((1/2 : ℂ) + t * I)).re =
      Q.eval (1/2) * (completedRiemannZeta ((1/2 : ℂ) + t * I)).re :=
```

```
theorem zeta_line_zero_iff_W (Q : ℝ[X])
    (hQ : ∀ x : ℝ, Q.derivative.eval x = Q.derivative.eval (1 - x))
    (hQh : Q.eval (1/2) ≠ 0) (L t : ℝ) :
    riemannZeta ((1/2 : ℂ) + t * I) = 0 ↔ (W Q L ((1/2 : ℂ) + t * I)).re = 0 :=
```

```
theorem cubic_sym :
    Qcubic.eval 0 = 1 ∧
      (∀ x : ℝ, Qcubic.derivative.eval x = Qcubic.derivative.eval (1 - x)) ∧
      Qcubic.eval (1/2) = 3/4 :=
```

```
theorem cubic_re_W_line (L t : ℝ) :
    (W Qcubic L ((1/2 : ℂ) + t * I)).re =
      3/4 * (completedRiemannZeta ((1/2 : ℂ) + t * I)).re :=
```

