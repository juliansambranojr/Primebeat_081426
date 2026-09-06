> Source: session transcript, 2026-09-06 (this session), the bracket in which rung 3 was asked for

> Go

> Rung 3, next: the transform of the tuned window in closed form, entry 302's Ψ and Σ identities. This is the first rung with a genuine Fourier computation in Lean: a compactly supported product against an exponential, product-to-sum on the cosine carrier, and a change of variables.

CONTEXT.md: § Current state of the world (the Lean tree as of entry 170; this module postdates it).

NOTEPAD: no line yet.

Lab notebook:

> ## 2026-09-02 — Entry 302 — weil_Lc_theory.py: L_c(ε, γ_k) in closed form for a fixed raised-cosine window, tested against entry 301's 24 rows — the fixed window's L_c is set by the near lobe and

From `analysis/2026-09-01/weil_Lc_theory.md`, section 3, transform and the off-line term:

```
Ghat(t)  = (i N h / 2) [Psi(h (t - gamma)) + Psi(h (t + gamma))]
Ghat(gamma -+ i eps) = (N h / 2) [ +- Sigma(eps h) + i Psi(2 gamma h -+ i eps h) ]
```

From `lean_stage3/Stage3/WeilTransform.lean`, the statements as built:

```
theorem ghat_eq {h : ℝ} (hh : 0 < h) (γ : ℝ) (z : ℂ) :
    ghat h γ z = ((h : ℂ) / 2) *
      (SigmaC ((z + Complex.I * (γ : ℂ)) * (h : ℂ))
        + SigmaC ((z - Complex.I * (γ : ℂ)) * (h : ℂ))) := by
```
