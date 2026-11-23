> Source: session transcript, 2026-11-22, after units 0431 and 0432

> Also you want more search my repos for sextic guardrail and restoring force.

> Yes

From `lean_stage3/Stage3/StencilWeil.lean`, the definitions and the pinned statements:

```
def stencilTest (d : ℕ) (φ : ℝ → ℂ) : ℝ → ℂ := fun u =>
  ∑ k ∈ range (d + 1), ((((-1 : ℝ) ^ k * (d.choose k : ℝ) : ℝ)) : ℂ) * φ (u + k * Real.log 2)
```

```
def restoringForce (b : ℝ) (ρ : ℂ) : ℝ :=
  |Real.log ‖(b : ℂ) ^ ρ‖ - Real.log ‖(b : ℂ) ^ (1 - ρ)‖|
```

```
theorem laplace_stencilTest {L : ℝ} {φ : ℝ → ℂ} (hφ : IsTest L φ) (d : ℕ) (z : ℂ) :
    laplace (stencilTest d φ) z = (1 - (2 : ℂ) ^ z) ^ d * laplace φ z := by
```

```
theorem isTest_stencilTest {L : ℝ} {φ : ℝ → ℂ} (hφ : IsTest L φ) (d : ℕ) :
    IsTest (L + 2 * (d * Real.log 2)) (stencilTest d φ) := by
```

```
theorem zeroForm_stencilTest {L : ℝ} {φ : ℝ → ℂ} (hφ : IsTest L φ) (d : ℕ) :
    zeroForm (stencilTest d φ)
      = riemannZeta.zeroes_sum (Set.Ioo 0 1) (Set.univ : Set ℝ)
          (fun ρ => ((1 - (2 : ℂ) ^ (-ρ)) * (1 - (2 : ℂ) ^ (-(1 - ρ)))) ^ d
            * (laplace φ (-ρ) * laplace φ (-(1 - ρ)))) := by
```

```
theorem mirror_symbol_on_line {ρ : ℂ} (h : ρ.re = 1 / 2) :
    (1 - (2 : ℂ) ^ (-ρ)) * (1 - (2 : ℂ) ^ (-(1 - ρ)))
      = ((‖1 - (2 : ℂ) ^ (-ρ)‖ ^ 2 : ℝ) : ℂ) := by
```

```
theorem restoringForce_eq {b : ℝ} (hb : 1 < b) (ρ : ℂ) :
    restoringForce b ρ = 2 * |ρ.re - 1 / 2| * Real.log b := by
```

```
theorem handshake_iff {b : ℝ} (hb : 1 < b) (ρ : ℂ) :
    ‖(b : ℂ) ^ ρ‖ = ‖(b : ℂ) ^ (1 - ρ)‖ ↔ ρ.re = 1 / 2 := by
```

```
theorem zeroForm_stencilTest_eq_primeSide (h : WeilBridgeLeaf.StmtWeilBridge) {L : ℝ}
    {φ : ℝ → ℂ} (hφ : IsTest L φ) (d : ℕ) :
    zeroForm (stencilTest d φ)
      = WeilBridgeLeaf.primeSideM (WeilBridgeLeaf.kOfM (stencilTest d φ)) :=
```
