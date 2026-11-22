> Source: session transcript, 2026-11-22, after unit 0402

> Do both

From the assistant's message before it: "checking joint 6's side conditions for `Li`, and making `A` and `x₀` explicit."

From `lean/RelativeLi.lean`, the pinned statements:

```
theorem tableFrom_ne_zero_of_relErr_li {N : ℤ → ℤ} {f : ℤ → ℝ} {G : ℝ → ℝ}
    {r : ℤ} {d : ℕ} {ρ : ℝ}
    (hG : ContDiff ℝ (⊤ : ℕ∞) G)
    (hG' : ∀ x ∈ Ioi ((1 : ℝ) / 2), HasDerivAt G (Expansion.f2x x) x)
    (hrow : ∀ k ∈ range (d + 2), ((N (r - k) : ℤ) : ℝ) = Nonvanishing.bdiffZ f (r - k))
    (hS : RelativeGate.StmtRelErrWindow f (fun k : ℤ => G k) r (d + 1) ρ)
    (hbot : (1 : ℝ) ≤ (r : ℝ) - (d + 1))
    (hw : 2 * (d : ℝ) ≤ Real.log 2 * ((r : ℝ) - (d + 1)))
    (hgap : RelativeGate.EhighRel r (d + 1) ρ < Nonvanishing.Mlow r d) :
    Construction.tableFrom N r d ≠ 0 :=
```
