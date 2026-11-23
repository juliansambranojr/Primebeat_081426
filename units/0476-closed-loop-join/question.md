> Source: session transcript, 2026-11-23

> I'm pretty sure the restarting force and a contradiction proof is in there



From `lean_stage3/Stage3/ClosedLoopJoin.lean`, the pinned statements:

```
theorem force_join {b : ℝ} (hb : 1 < b) (ρ : ℂ) :
    StencilWeil.restoringForce b ρ = 2 * Real.log b / 5 * restoringForce ρ.re :=
```

```
theorem handshake_iff_sides (ρ : ℂ) :
    isHermitianHandshake ρ.re ↔
      ∀ p : ℕ, Nat.Prime p → p > 3 → ‖((p : ℝ) : ℂ) ^ ρ‖ = ‖((p : ℝ) : ℂ) ^ (1 - ρ)‖ :=
```

```
theorem structural_contradiction (σ : ℝ) (hσ : σ ≠ 1 / 2) :
    restoringForce σ ≠ 0 ∧ ¬ isHermitianHandshake σ :=
```

```
theorem off_line_zero (ρ : NontrivialZeros) (h : (ρ : ℂ).re ≠ 1 / 2) :
    restoringForce (ρ : ℂ).re ≠ 0 ∧ ¬ isHermitianHandshake (ρ : ℂ).re ∧
      ∀ b : ℝ, 1 < b → StencilWeil.restoringForce b (ρ : ℂ) ≠ 0 ∧
        Real.sqrt b < max ‖(b : ℂ) ^ (ρ : ℂ)‖ ‖(b : ℂ) ^ (1 - (ρ : ℂ))‖ :=
```

```
theorem rh_iff_force_zero :
    RiemannHypothesis ↔ ∀ ρ : NontrivialZeros, restoringForce (ρ : ℂ).re = 0 :=
```

```
theorem rh_iff_handshake :
    RiemannHypothesis ↔ ∀ ρ : NontrivialZeros, isHermitianHandshake (ρ : ℂ).re :=
```

