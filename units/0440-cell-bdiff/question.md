> Source: session transcript, 2026-11-22, after unit 0439

> go for all of it, i feel like we are aligned

The third of the items offered in the assistant's message before it: "restating `CellZeros` on `Elephant`'s operators". The operator the NOTEPAD line names is `bdiff^[d]`, in `Chain`.

From `lean_stage3/Stage3/CellBdiff.lean`, the pinned statements:

```
theorem stencil_eq_bdiff_iter {a : ℤ → ℂ} {g : ℂ → ℂ} (hag : ∀ n : ℤ, g (n : ℂ) = a n)
    (d : ℕ) (r : ℤ) : CellZeros.stencil d a r = (Chain.bdiff^[d]) g (r : ℂ) := by
```

```
theorem cell_eq_modeSum_bdiff (d : ℕ) (r : ℤ) {T : ℝ}
    [Fintype {ρ : Kadiri.NontrivialZeros // |(ρ : ℂ).im| < T}]
    (h16 : 16 ≤ (2:ℝ) ^ (r - (d : ℤ)))
    (hT : 2 ≤ T) (hTx : T ≤ ((2:ℝ) ^ (r - (d : ℤ))) ^ 2) :
    ‖(Chain.bdiff^[d]) psiRow (r : ℂ)
        - Chain.Sym 2 1 ^ d * Chain.mode 2 1 (r : ℂ)
        + Superposition.modeSum 2
            (fun ρ : {ρ : Kadiri.NontrivialZeros // |(ρ : ℂ).im| < T} =>
              ((ρ : Kadiri.NontrivialZeros) : ℂ))
            (fun ρ => ((riemannZeta.order ((ρ : Kadiri.NontrivialZeros) : ℂ) : ℤ) : ℂ)
              / ((ρ : Kadiri.NontrivialZeros) : ℂ)
              * Chain.Sym 2 ((ρ : Kadiri.NontrivialZeros) : ℂ) ^ d)
            Finset.univ (r : ℂ)‖
      ≤ ∑ j ∈ range (d + 1), (d.choose j : ℝ)
          * (Glue.c1n * (2:ℝ) ^ (r - (j : ℤ)) * Real.log ((2:ℝ) ^ (r - (j : ℤ)) * T) ^ 2 / T
              + Glue.c3n * Real.log ((2:ℝ) ^ (r - (j : ℤ)))
              + Glue.c4n * ((Real.log ((2:ℝ) ^ (r - (j : ℤ)))) ^ 2
                  * ((2:ℝ) ^ (r - (j : ℤ))) ^ (-(1:ℝ) / 4))) := by
```

