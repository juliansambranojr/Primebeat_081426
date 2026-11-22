> Source: session transcript, 2026-11-22, after unit 0424

> And then start on this "The theorem that says what you have been saying already exists in your table tree, with one hypothesis left open."

From `lean_stage3/Stage3/CellModes.lean`, the pinned statement:

```
theorem cell_eq_modeSum (d : ℕ) (r : ℤ) {T : ℝ}
    [Fintype {ρ : Kadiri.NontrivialZeros // |(ρ : ℂ).im| < T}]
    (h16 : 16 ≤ (2:ℝ) ^ (r - (d : ℤ)))
    (hT : 2 ≤ T) (hTx : T ≤ ((2:ℝ) ^ (r - (d : ℤ))) ^ 2) :
    ‖CellZeros.stencil d (fun n : ℤ => (Chebyshev.psi ((2:ℝ) ^ n) : ℂ)) r
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
