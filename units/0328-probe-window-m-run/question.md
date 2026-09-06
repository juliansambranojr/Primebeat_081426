> Source: session transcript, 2026-09-06 (this session), after unit 0327 was reported

> Log it and can we run the probe and if the probe dies what we think what should we try next? What if every path that prior third is a truncation and if we map the truncation it reveals the zero side through contrast —composites and primes are the noise that makes zeros  visible — funny enough kind of like how you make an image blurry and sharp through Gaussian blur

> That prior paths*

CONTEXT.md: § Current state of the world (the Lean tree as of entry 170; this run postdates it).

NOTEPAD: no line yet.

From `O8_weil_inner_product.py`, the rule the pin follows:

```
  STEP 1  Reproduce the published CvS numbers at c=13 (six primes: 2,3,5,7,11,13)
          before comparing anything.  If we cannot reproduce, we do not have
          the right object and nothing downstream means anything.
```

From `analysis/2026-09-06/probe_window_m.py`, the formula as coded:

```
    sum_gamma' Ahat(gamma') = Ahat(i/2) + Ahat(-i/2) - A(0) log pi
                              + (1/2pi) int Ahat(r) Re psi(1/4 + i r/2) dr
                              - 2 sum_n Lambda(n) n^{-1/2} A(log n),
```

From `lean_stage3/Stage3/WeilOffLine.lean`, the identity that names the zero side:

```
theorem term_eq_neg_sq {h : ℝ} (hh : 0 < h) (γ : ℝ) (ρ : ℂ) :
    laplace (phiC h γ) (-ρ) * laplace (phiC h γ) (-(1 - ρ)) = -(ghat h γ (ρ - 1 / 2)) ^ 2 := by
```
