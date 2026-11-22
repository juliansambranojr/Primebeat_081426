> Source: session transcript, 2026-11-22, after unit 0408

> Yes

From the assistant's message before it: "Shall I build it?"

From `lean_stage3/Stage3/GlueFloor.lean`, the definitions and the pinned statements:

```
def StmtExplicitFormulaSplit (c₁ c₃ c₄ x₁ : ℝ) : Prop :=
  ∀ x T : ℝ, x₁ ≤ x → 2 ≤ T → T ≤ x^2 →
    ‖((ψ x : ℝ) : ℂ) - (x : ℂ) + zeroPartialSum x T‖
      ≤ c₁ * x * Real.log (x * T) ^ 2 / T + c₃ * Real.log x
        + c₄ * ((Real.log x)^2 * x ^ (-(1:ℝ)/4))
```

```
def floorConstSplit (c₁ c₃ c₄ b₁ b₂ b₃ W x₀ : ℝ) : ℝ :=
  floorConst c₁ c₃ b₁ b₂ b₃ W x₀ + c₄ * x₀ ^ (-(1:ℝ)/4) / Real.sqrt x₀
```

```
theorem edge_left_sharp :
    ∃ D : ℝ, 0 < D ∧ ∀ x T' : ℝ, 16 ≤ x → 2 ≤ T' → T' ≤ 2*x^2 →
      ‖VIntegral (Gf x) (-1/4) (-T') T'‖
        ≤ 72 * D * ((Real.log x)^2 * x ^ (-(1:ℝ)/4)) := by
```

```
theorem explicit_formula_split :
    ∃ c₁ c₃ c₄ : ℝ, 0 ≤ c₁ ∧ 0 ≤ c₃ ∧ 0 ≤ c₄ ∧
      ∀ x T : ℝ, 16 ≤ x → 2 ≤ T → T ≤ x^2 →
      ‖(Chebyshev.psi x : ℂ) - (x:ℂ) + Stage3.zeroPartialSum x T‖
        ≤ c₁ * x * Real.log (x*T)^2 / T + c₃ * Real.log x
          + c₄ * ((Real.log x)^2 * x ^ (-(1:ℝ)/4)) := by
```

```
theorem psiWeak_floor_split (hRH : RiemannHypothesis)
    {c₁ c₃ c₄ x₁ b₁ b₂ b₃ W x₀ : ℝ} (hc₁ : 0 ≤ c₁) (hc₃ : 0 ≤ c₃) (hc₄ : 0 ≤ c₄)
    (hb₁ : 0 ≤ b₁) (hb₂ : 0 ≤ b₂) (hb₃ : 0 ≤ b₃)
    (hWeq : W = weightedZeroHeightBucket)
    (hRvM2 : 0 ≤ riemannZeta.RvM b₁ b₂ b₃ 2)
    (hEF : StmtExplicitFormulaSplit c₁ c₃ c₄ x₁)
    (hNT : riemannZeta.Riemann_vonMangoldt_bound b₁ b₂ b₃)
    (hx₀ : 16 ≤ x₀) (hx₁ : x₁ ≤ x₀) :
    StmtPsiWeak (floorConstSplit c₁ c₃ c₄ b₁ b₂ b₃ W x₀) 2 x₀ := by
```

```
theorem schoenfeldWeak_floor_split_of_RH (hRH : RiemannHypothesis) :
    ∃ c₁ c₃ c₄ : ℝ, 0 ≤ c₁ ∧ 0 ≤ c₃ ∧ 0 ≤ c₄ ∧ ∀ x₀ : ℝ, 16 ≤ x₀ →
      StmtSchoenfeldWeak
        (3 * floorConstSplit c₁ c₃ c₄ 112 0 698 weightedZeroHeightBucket x₀ + 13) 1
        (max (x₀ ^ 2) 9) (fun x => (Nat.primeCounting ⌊x⌋₊ : ℝ)) Li := by
```

