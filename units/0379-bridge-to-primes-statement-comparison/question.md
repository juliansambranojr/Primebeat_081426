> Source: session transcript, 2026-11-22, after unit 0378

> Go ahead with the cache fetch and start Cgo ahead

C, from the assistant's earlier message: "Port or weld the sorry-free explicit formula from `zeta23`, so `zeroForm` has a prime side in your tree."

From `lean_stage3/Stage3/WeilDetect.lean`, the tree's zero side:

```
noncomputable def zeroForm (G : ℝ → ℂ) : ℂ :=
  riemannZeta.zeroes_sum (Set.Ioo 0 1) (Set.univ : Set ℝ)
    (fun ρ ↦ laplace G (-ρ) * laplace G (-(1 - ρ)))
```

From `anthropics/formal-math`, `zeta23/Zeta23/ExplicitFormula.lean`, the statement to compose with:

```
def EF_lit (Z : ZeroConfig) : Prop :=
  ∀ k : ℝ → ℂ, ContDiff ℝ 2 k → HasCompactSupport k →
    Summable (fun ρ : Z.carrier => (Z.mult ρ : ℂ) * paperFT k (gammaOf ρ)) ∧
    ∑' ρ : Z.carrier, (Z.mult ρ : ℂ) * paperFT k (gammaOf ρ) = literatureRHS k
```
