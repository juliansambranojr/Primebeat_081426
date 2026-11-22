> Source: session transcript, 2026-11-22, after unit 0381

> The zero-set lemma isn Stage 3 to finish C

From `lean_stage3/Stage3/WeilBridgeLeaf.lean`, the pinned statements:

```
theorem zeroForm_eq_strip (G : ℝ → ℂ) :
    zeroForm G = ∑' ρ : {ρ : ℂ | riemannZeta ρ = 0 ∧ 0 < ρ.re ∧ ρ.re < 1},
      (((analyticOrderAt riemannZeta (ρ : ℂ)).toNat : ℕ) : ℂ)
        * (laplace G (-(ρ : ℂ)) * laplace G (-(1 - (ρ : ℂ)))) := by
```

```
theorem zeroForm_eq_primeSide (h : StmtWeilBridge) {L : ℝ} {G : ℝ → ℂ} (hG : IsTest L G) :
    zeroForm G = primeSideM (kOfM G) := by
```
