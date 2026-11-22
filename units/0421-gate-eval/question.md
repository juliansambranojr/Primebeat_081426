> Source: session transcript, 2026-11-22, after unit 0420

> E9

From the assistant's message before it: "Shall I build E9 as drafted?"

From `lean_stage3/Stage3/GateEval.lean`, the pinned statements:

```
theorem routeConst_le : Stage3.routeConst ((2:ℝ) ^ (36:ℕ)) ≤ 414 := by
```

```
theorem gate_ineq {r : ℝ} (hr : 80 ≤ r) :
    414 * (Real.log 2 * r) ^ 1 * (2:ℝ) ^ (-((r - 7) / 2))
      < Real.log 2 ^ 6 / (2 * r * 3 ^ 7) := by
```

```
theorem gate_hyp_of_RH (hRH : RiemannHypothesis) {r : ℤ} (hr : 80 ≤ r) :
    ∃ ρ : ℝ, JointDialGate.StmtRelErrWindow
        (fun m : ℤ => (Nat.primeCounting ⌊(2 : ℝ) ^ (m : ℝ)⌋₊ : ℝ))
        (fun m : ℤ => 2 / Real.log 2
          + ∫ t in (1 : ℝ)..(m : ℝ), Real.exp (Real.log 2 * t) / t) r (6 + 1) ρ
      ∧ ρ < Real.log 2 ^ 6 / (2 * r * 3 ^ (6 + 1)) := by
```

