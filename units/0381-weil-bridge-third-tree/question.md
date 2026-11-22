> Source: session transcript, 2026-11-22, after unit 0380

> Third tree it is

That chose the second of unit 0379's three options, as the assistant's table put it: "A small Lake project on `zeta23`'s toolchain that depends on it".

From `lean_bridge/Bridge/WeilBridge.lean`, the pinned statement:

```
theorem weil_bridge {L : ℝ} {G : ℝ → ℂ} (hG : IsTest L G) :
    Summable (fun ρ : {ρ : ℂ | riemannZeta ρ = 0 ∧ 0 < ρ.re ∧ ρ.re < 1} =>
        (((analyticOrderAt riemannZeta (ρ : ℂ)).toNat : ℕ) : ℂ)
          * (laplace G (-(ρ : ℂ)) * laplace G (-(1 - (ρ : ℂ))))) ∧
      ∑' ρ : {ρ : ℂ | riemannZeta ρ = 0 ∧ 0 < ρ.re ∧ ρ.re < 1},
        (((analyticOrderAt riemannZeta (ρ : ℂ)).toNat : ℕ) : ℂ)
          * (laplace G (-(ρ : ℂ)) * laplace G (-(1 - (ρ : ℂ))))
        = primeSide (kOf G) := by
```
