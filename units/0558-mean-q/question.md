> Source: session transcript, 2026-11-25

> Yes to all please



From `lean_stage3/Stage3/MeanQ.lean`, the pinned statements:

```
theorem unsmooth_V (Q P : ℝ[X]) {θ R : ℝ} (hθ0 : 0 < θ) (hR : 0 < R)
    (hMV : StmtMollMeanV Q P θ R) :
    ∀ ε : ℝ, 0 < ε → ∃ T₀ : ℝ, ∀ T : ℝ, T₀ ≤ T → ∀ a' b' : ℝ,
      T / 2 ≤ a' → a' ≤ T / 2 + 1 → T - 1 ≤ b' → b' ≤ T →
      (1 / (b' - a')) * ∫ t in a'..b',
          ‖ConreyCount.V Q (Real.log T) ((sig0 T R : ℂ) + t * I) *
            psi (Mof T θ) (aY P T θ R) ((sig0 T R : ℂ) + t * I)‖ ^ 2 ≤
        (DopQ Q (Real.log T) (cY P (Mof T θ) T) ((-(R / Real.log T) : ℝ) : ℂ)
          ((-(R / Real.log T) : ℝ) : ℂ)).re + ε :=
```

```
theorem window_V_long (Q P : ℝ[X]) {θ R : ℝ} (hθ0 : 0 < θ) (hR : 0 < R)
    (hL3 : StmtLemma3resO P θ R (2 * R + 1 + 1 / R)) (hG : StmtGrRatio Q.natDegree) :
    ∀ ε : ℝ, 0 < ε → ∃ T₀ : ℝ, ∀ T : ℝ, T₀ ≤ T → ∀ a' b' : ℝ,
      T / 2 ≤ a' → a' ≤ T / 2 + 1 → T - 1 ≤ b' → b' ≤ T →
      (1 / (b' - a')) * ∫ t in a'..b',
          ‖ConreyCount.V Q (Real.log T) ((sig0 T R : ℂ) + t * I) *
            psi (Mof T θ) (aY P T θ R) ((sig0 T R : ℂ) + t * I)‖ ^ 2 ≤
        (DopQ Q (Real.log T) (cY P (Mof T θ) T) ((-(R / Real.log T) : ℝ) : ℂ)
          ((-(R / Real.log T) : ℝ) : ℂ)).re + ε :=
```

```
theorem window_V_lt_half (Q P : ℝ[X]) (hP0 : P.eval 0 = 0) {θ R : ℝ} (hθ0 : 0 < θ)
    (hθ : θ < 1 / 2) (hR : 0 < R) (hG : StmtGrRatio Q.natDegree) :
    ∀ ε : ℝ, 0 < ε → ∃ T₀ : ℝ, ∀ T : ℝ, T₀ ≤ T → ∀ a' b' : ℝ,
      T / 2 ≤ a' → a' ≤ T / 2 + 1 → T - 1 ≤ b' → b' ≤ T →
      (1 / (b' - a')) * ∫ t in a'..b',
          ‖ConreyCount.V Q (Real.log T) ((sig0 T R : ℂ) + t * I) *
            psi (Mof T θ) (aY P T θ R) ((sig0 T R : ℂ) + t * I)‖ ^ 2 ≤
        (DopQ Q (Real.log T) (cY P (Mof T θ) T) ((-(R / Real.log T) : ℝ) : ℂ)
          ((-(R / Real.log T) : ℝ) : ℂ)).re + ε :=
```

