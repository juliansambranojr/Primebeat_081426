> Source: session transcript, 2026-09-06 (this session), the bracket in which rung 4a was asked for

> Go on

> Rung 4a, the lobe. The bound comes from integrating by parts twice: the envelope vanishes with its first derivative at both ends, so the lobe is the second derivative's integral divided by w², which decays like one over (γh)².

CONTEXT.md: § Current state of the world (the Lean tree as of entry 170; this module postdates it).

NOTEPAD: no line yet.

Lab notebook:

> ## 2026-09-02 — Entry 302 — weil_Lc_theory.py: L_c(ε, γ_k) in closed form for a fixed raised-cosine window, tested against entry 301's 24 rows — the fixed window's L_c is set by the near lobe and

From `analysis/2026-09-01/weil_Lc_theory.md`, section 2:

```
Then Ghat(gamma_k +- i eps) = (1/2) Ehat(+- i eps) + (1/2) Ehat(2 gamma_k +- i eps),
and the second (2 gamma) lobe is O((h gamma)^-3) for a smooth E.
```

From `lean_stage3/Stage3/WeilLobe.lean`, the statements as built:

```
theorem SigmaC_eq_ibp (w : ℂ) (hw : w ≠ 0) :
    SigmaC w = (1 / w ^ 2) * ∫ x in (-1 : ℝ)..1, ((q2 x : ℝ) : ℂ) * Complex.sinh (w * (x : ℂ)) := by
theorem SigmaC_bound (w : ℂ) (hw : w ≠ 0) :
    ‖SigmaC w‖ ≤ (2 * Real.pi + Real.pi ^ 2) * Real.cosh w.re / ‖w‖ ^ 2 := by
```
