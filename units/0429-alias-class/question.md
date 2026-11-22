> Source: session transcript, 2026-11-22, after units 0427 and 0428

> Go

From `lean_stage3/Stage3/AliasClass.lean`, the pinned statements:

```
theorem sum_order_div_ne_zero (S : Finset Kadiri.NontrivialZeros) (hS : S.Nonempty) :
    ∑ ρ ∈ S, (((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ)) / (ρ : ℂ) ≠ 0 := by
```

```
theorem alias_weight (S : Finset Kadiri.NontrivialZeros) {z : ℂ}
    (hz : ∀ ρ ∈ S, (2 : ℂ) ^ (ρ : ℂ) = z) (d : ℕ) (r : ℤ) :
    ∑ ρ ∈ S, (((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ)) / (ρ : ℂ)
        * Chain.Sym 2 (ρ : ℂ) ^ d * Chain.mode 2 (ρ : ℂ) (r : ℂ)
      = (∑ ρ ∈ S, (((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ)) / (ρ : ℂ))
        * (1 - z⁻¹) ^ d * z ^ r := by
```

```
theorem alias_weight_ne_zero (S : Finset Kadiri.NontrivialZeros) (hS : S.Nonempty) {z : ℂ}
    (hz : ∀ ρ ∈ S, (2 : ℂ) ^ (ρ : ℂ) = z) (d : ℕ) (r : ℤ) :
    ∑ ρ ∈ S, (((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ)) / (ρ : ℂ)
        * Chain.Sym 2 (ρ : ℂ) ^ d * Chain.mode 2 (ρ : ℂ) (r : ℂ) ≠ 0 := by
```
