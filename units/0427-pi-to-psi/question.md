> Source: session transcript, 2026-11-22, after the reading of `The-Four-Zeros.md`, `The-Fold.md` and `Elephant.lean`

> This please "The statement I can now write is: RH holds if and only if the residual in every cell stays at square-root size as the table continues. One direction is provable with today's theorems. The other is joint 10"

From `lean_stage3/Stage3/PiToPsi.lean`, the pinned statements:

```
theorem Li_mul_log_sub_integral {x : ℝ} (hx : 2 ≤ x) :
    Stage3.Li x * Real.log x - ∫ t in (2 : ℝ)..x, Stage3.Li t / t = x := by
```

```
theorem theta_sub_id_eq {x : ℝ} (hx : 2 ≤ x) :
    θ x - x = ((Nat.primeCounting ⌊x⌋₊ : ℝ) - Stage3.Li x) * Real.log x
      - ∫ t in (2 : ℝ)..x, relRes t := by
```

```
theorem psiWeak_of_schoenfeldWeak {C x₀ : ℝ} (hC : 0 ≤ C) (hx₀ : 2 ≤ x₀)
    (h : StmtSchoenfeldWeak C 1 x₀ (fun x => (Nat.primeCounting ⌊x⌋₊ : ℝ)) Stage3.Li) :
    ∃ C' > 0, ∃ x₁ : ℝ, StmtPsiWeak C' 3 x₁ := by
```

```
theorem RH_of_schoenfeldWeak {C x₀ : ℝ}
    (h : StmtSchoenfeldWeak C 1 x₀ (fun x => (Nat.primeCounting ⌊x⌋₊ : ℝ)) Stage3.Li) :
    RiemannHypothesis := by
```

```
theorem RH_iff_schoenfeldWeak :
    RiemannHypothesis ↔ ∃ C x₀ : ℝ,
      StmtSchoenfeldWeak C 1 x₀ (fun x => (Nat.primeCounting ⌊x⌋₊ : ℝ)) Stage3.Li := by
```
