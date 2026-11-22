> Source: session transcript, 2026-11-22, after unit 0393

> 3b

From `lean_stage3/Stage3/LandauPoleSub.lean`, the pinned statements:

```
theorem iteratedDeriv_inv_sub (k : ℕ) (q c : ℂ) :
    iteratedDeriv k (fun s : ℂ => (s - q)⁻¹) c
      = (-1) ^ k * (k.factorial : ℂ) * (c - q) ^ (-1 - (k : ℤ)) := by
```

```
theorem exists_differentiableOn_sub_poles {U : Set ℂ} {P : Finset ℂ}
    {f A : ℂ → ℂ} (hf : ∀ s ∈ U, s ∉ P → DifferentiableAt ℂ f s)
    (hloc : ∀ p ∈ P, ∃ h : ℂ → ℂ, AnalyticAt ℂ h p ∧
      ∀ᶠ s in 𝓝[≠] p, f s = h s + A p / (s - p)) :
    ∃ g : ℂ → ℂ, DifferentiableOn ℂ g U ∧
      ∀ s, s ∉ P → g s = f s - ∑ q ∈ P, A q / (s - q) := by
```

```
theorem taylor_coeff_sub_poles {c : ℂ} {R : ℝ} (hR : 0 < R) {U : Set ℂ} (hU : IsOpen U)
    (hball : closedBall c R ⊆ U) {P : Finset ℂ} {f A g : ℂ → ℂ} (hcP : c ∉ P)
    (hg : DifferentiableOn ℂ g U)
    (hgf : ∀ s, s ∉ P → g s = f s - ∑ q ∈ P, A q / (s - q)) :
    ∃ C : ℝ, ∀ k : ℕ, ‖iteratedDeriv k f c
      - ∑ q ∈ P, A q * ((-1) ^ k * (k.factorial : ℂ) * (c - q) ^ (-1 - (k : ℤ)))‖
        ≤ k.factorial * C / R ^ k := by
```
