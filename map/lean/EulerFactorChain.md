# `lean/EulerFactorChain.lean`

**What it does** (its own header): Euler Factor Chain — the algebraic core, formalised. Companion to papers/Euler-Factor-Chain.md (statements A1, A2, A3, B1, B2, B4, C1).

**Imports:** nothing in this tree.
**Imported by:** [`Chain`](../lean/Chain.md), [`Transform`](../lean/Transform.md).

```mermaid
flowchart LR
  n0["sym<br/>(def)"]:::dfn
  n1["symbol_of_backward_difference<br/>⊢ (b : ℂ) ^ (r * ρ) - (b : ℂ) ^ ((r - 1) * ρ) = sym b ρ * (b : ℂ) ^ (r *…"]:::thm
  n2["diagonal_gain<br/>⊢ (b : ℂ) ^ ρ * sym b ρ = (b : ℂ) ^ ρ - 1"]:::thm
  n3["diagonal_cell<br/>⊢ (b : ℂ) ^ (((d : ℂ) + c) * ρ) * (sym b ρ) ^ d = (b : ℂ) ^ ((c : ℂ) * ρ…"]:::end_
  n4["diagonal_over_column<br/>⊢ ((b : ℂ) ^ ρ - 1) / sym b ρ = (b : ℂ) ^ ρ"]:::end_
  n5["diagonal_over_column_at_half<br/>⊢ (b : ℂ) ^ ((1 : ℂ) / 2) = (Real.sqrt b : ℂ)"]:::lone
  n6["symbol_at_one<br/>⊢ (b : ℂ) ^ (r * 1) - (b : ℂ) ^ ((r - 1) * 1) = sym b 1 * (b : ℂ) ^ (r *…"]:::end_
  n7["euler_product_riemannZeta<br/>⊢ ∏' p : Nat.Primes, (1 - (p : ℂ) ^ (-s))⁻¹ = riemannZeta s"]:::thm
  n8["solely<br/>⊢ "]:::end_
  n9["sym_natCast<br/>⊢ sym (n : ℝ) s = 1 - (n : ℂ) ^ (-s)"]:::thm
  n10["euler_product_sym<br/>⊢ ∏' p : Nat.Primes, (sym ((p : ℕ) : ℝ) s)⁻¹ = riemannZeta s"]:::thm
  n11["h<br/>(def)"]:::dfn
  n12["h_functional_equation<br/>⊢ h b N (1 - s) = h b N s"]:::thm
  n13["h_zero<br/>⊢ h b N 0 = 0"]:::thm
  n14["h_one<br/>⊢ h b N 1 = 0"]:::end_
  n15["conj_factor_on_critical_line<br/>⊢ (starRingEnd ℂ) (1 - (b : ℂ) ^ (-((1 : ℂ)/2 + t * I))) = 1 - (b : ℂ) ^…"]:::thm
  n16["h_eq_gain_pow_on_critical_line<br/>⊢ h b N ((1 : ℂ)/2 + t * I) = ((‖1 - (b : ℂ) ^ (-((1 : ℂ)/2 + t * I))‖ :…"]:::thm
  n17["cpow_rect_on_critical_line<br/>⊢ (b : ℂ) ^ (-((1 : ℂ)/2 + γ * I)) = ((b ^ (-(1:ℝ)/2) * Real.cos (γ * Re…"]:::thm
  n18["gain_sq_on_critical_line<br/>⊢ ‖1 - (b : ℂ) ^ (-((1 : ℂ)/2 + γ * I))‖ ^ 2 = 1 - 2 * b ^ (-(1:ℝ)/2) * …"]:::thm
  x0(["Chain · A1"]):::ext
  x1(["Chain · A2"]):::ext
  x2(["Chain · A3"]):::ext
  x3(["Chain · B4"]):::ext
  x4(["Chain · C1"]):::ext
  x5(["Chain · gain_sq_at_ceiling"]):::ext
  x6(["Chain · gain_sq_at_floor"]):::ext
  n0 --> n1
  n0 --> n10
  n0 --> n2
  n0 --> n3
  n0 --> n4
  n0 --> n6
  n0 --> n7
  n0 --> n9
  n1 --> n6
  n1 --> x0
  n10 --> n8
  n10 --> x2
  n11 --> n12
  n11 --> n13
  n11 --> n14
  n11 --> n16
  n12 --> n14
  n13 --> n14
  n15 --> n16
  n16 --> x3
  n17 --> n18
  n18 --> x4
  n18 --> x5
  n18 --> x6
  n2 --> n3
  n2 --> n4
  n7 --> n10
  n7 --> x1
  n9 --> n10
  n9 --> x2
  classDef thm fill:#eef4ff,stroke:#335,color:#111
  classDef dfn fill:#f2f2f2,stroke:#777,color:#111
  classDef end_ fill:#e7f7e7,stroke:#2a7,color:#111,stroke-width:2px
  classDef lone fill:#fff,stroke:#999,color:#111,stroke-dasharray:4 3
  classDef bad fill:#ffe5e5,stroke:#c22,color:#111,stroke-width:2px
  classDef ext fill:#fff8e1,stroke:#b80,color:#111,stroke-dasharray:2 2
```

Blue: theorem. Green: a theorem nothing else uses (an end). Dashed white: connects to nothing. Grey: definition. Red: contains `sorry`. Yellow: in another file. An arrow A → B reads "A is used by B".

## Every declaration

| declaration | proves (output) | needs (input) | why (its own docstring) | uses | used by |
|---|---|---|---|---|---|
| `EulerFactorChain.sym`<br/>def, line 40 | ℂ | b : ℝ; s : ℂ | The reciprocal Euler factor at `b`, as a function of `s`. | — | `EulerFactorChain.diagonal_cell`, `EulerFactorChain.diagonal_gain`, `EulerFactorChain.diagonal_over_column`, `EulerFactorChain.euler_product_riemannZeta`, `EulerFactorChain.euler_product_sym`, `EulerFactorChain.sym_natCast`, `EulerFactorChain.symbol_at_one`, `EulerFactorChain.symbol_of_backward_difference` |
| `EulerFactorChain.symbol_of_backward_difference`<br/>theorem, line 45 | (b : ℂ) ^ (r * ρ) - (b : ℂ) ^ ((r - 1) * ρ) = sym b ρ * (b : ℂ) ^ (r * ρ) | b : ℝ; hb : b ≠ 0; ρ r : ℂ | A1. Backward differencing the mode `r ↦ b^(r*ρ)` on the ladder multiplies it by `1 - b^(-ρ)`. The symbol of `Δ` is the reciprocal Euler factor. | `EulerFactorChain.sym` | `Chain.A1`, `EulerFactorChain.symbol_at_one` |
| `EulerFactorChain.diagonal_gain`<br/>theorem, line 69 | (b : ℂ) ^ ρ * sym b ρ = (b : ℂ) ^ ρ - 1 | b : ℝ; hb : b ≠ 0; ρ : ℂ | The diagonal gain. `b^ρ · sym b ρ = b^ρ − 1`. | `EulerFactorChain.sym` | `EulerFactorChain.diagonal_cell`, `EulerFactorChain.diagonal_over_column` |
| `EulerFactorChain.diagonal_cell`<br/>theorem, line 78 | (b : ℂ) ^ (((d : ℂ) + c) * ρ) * (sym b ρ) ^ d = (b : ℂ) ^ ((c : ℂ) * ρ) * ((b : ℂ) ^ ρ - 1) ^ d | b : ℝ; hb : b ≠ 0; ρ : ℂ; c d : ℕ | The cell value along a diagonal in closed form: with `r = d + c`, the mode's `b^(rρ)·(sym b ρ)^d` collapses to `b^(cρ)·(b^ρ − 1)^d`. | `EulerFactorChain.diagonal_gain`, `EulerFactorChain.sym` | — |
| `EulerFactorChain.diagonal_over_column`<br/>theorem, line 87 | ((b : ℂ) ^ ρ - 1) / sym b ρ = (b : ℂ) ^ ρ | b : ℝ; hb : b ≠ 0; ρ : ℂ; hs : sym b ρ ≠ 0 | dia/col = `b^ρ`. The ratio of the diagonal gain to the column gain. | `EulerFactorChain.diagonal_gain`, `EulerFactorChain.sym` | — |
| `EulerFactorChain.diagonal_over_column_at_half`<br/>theorem, line 94 | (b : ℂ) ^ ((1 : ℂ) / 2) = (Real.sqrt b : ℂ) | hb : 0 ≤ b | At `ρ = 1/2` that ratio is `√b`. The critical line, read as the table's own geometry: moving along a diagonal outruns moving down a column by exactly `√b`, which at `b = 2` is 1.414214. | — | — |
| `EulerFactorChain.symbol_at_one`<br/>theorem, line 104 | (b : ℂ) ^ (r * 1) - (b : ℂ) ^ ((r - 1) * 1) = sym b 1 * (b : ℂ) ^ (r * 1) | b : ℝ; hb : b ≠ 0; r : ℂ | A1 at `ρ = 1`. Moved here from `PairIdentity` when that module went Mathlib-free; it is the only ℂ-valued statement that file had. A1 at `ρ = 1`. `symbol_of_backward_difference` says backward differencing the mode `b^(rρ)` multiplies it by `1 − b^(−ρ)`. At `ρ = 1` the multiplier is `1 − b⁻¹`. Stated here only to name the instance the rest of this file uses; … | `EulerFactorChain.sym`, `EulerFactorChain.symbol_of_backward_difference` | — |
| `EulerFactorChain.euler_product_riemannZeta`<br/>theorem, line 115 | ∏' p : Nat.Primes, (1 - (p : ℂ) ^ (-s))⁻¹ = riemannZeta s | hs : 1 &lt; s.re | A2. Euler's product, 1737, in the form Mathlib proves it: over *all* primes at once, and only in the half-plane where the product converges. The hypothesis `1 &lt; s.re` is not decoration — it is the honest content of the statement, and it excludes the whole `sym b s = 0` lattice on which the old `(sym s)⁻¹ * sym s = 1` reading of A2 was false. Cited from `riem… | `EulerFactorChain.sym` | `Chain.A2`, `EulerFactorChain.euler_product_sym` |
| `EulerFactorChain.solely`<br/>theorem, line 122 | — | — | — | `EulerFactorChain.euler_product_sym` | — |
| `EulerFactorChain.sym_natCast`<br/>theorem, line 124 | sym (n : ℝ) s = 1 - (n : ℂ) ^ (-s) | n : ℕ; s : ℂ | The chain's `sym` at a natural-number base, written the way the Euler product writes its factors. This is definitional: `sym` unfolds to `1 - b^(-s)` and the only work is the `ℕ → ℝ → ℂ` cast. It is stated as a lemma solely so that `euler_product_sym` below can be written in the chain's own vocabulary. | `EulerFactorChain.sym` | `Chain.A3`, `EulerFactorChain.euler_product_sym` |
| `EulerFactorChain.euler_product_sym`<br/>theorem, line 136 | ∏' p : Nat.Primes, (sym ((p : ℕ) : ℝ) s)⁻¹ = riemannZeta s | hs : 1 &lt; s.re | A3, the single-base reading with the `b` index retained. For a prime `p`, `sym ↑p` is exactly the factor A2 inverts: substituting the chain's symbol into Euler's product leaves the product unchanged and still equal to `ζ s`. | `EulerFactorChain.euler_product_riemannZeta`, `EulerFactorChain.sym`, `EulerFactorChain.sym_natCast` | `Chain.A3`, `EulerFactorChain.solely` |
| `EulerFactorChain.h`<br/>def, line 142 | ℂ | b : ℝ; N : ℕ; s : ℂ | The Weil test function built from an order-`N` stencil. | — | `EulerFactorChain.h_eq_gain_pow_on_critical_line`, `EulerFactorChain.h_functional_equation`, `EulerFactorChain.h_one`, `EulerFactorChain.h_zero` |
| `EulerFactorChain.h_functional_equation`<br/>theorem, line 146 | h b N (1 - s) = h b N s | b : ℝ; N : ℕ; s : ℂ | B2a. `h` is symmetric under `s ↦ 1 - s`: the functional equation. | `EulerFactorChain.h` | `EulerFactorChain.h_one` |
| `EulerFactorChain.h_zero`<br/>theorem, line 154 | h b N 0 = 0 | b : ℝ; hb : b ≠ 0; hN : N ≠ 0 | B2b. `h` vanishes at `s = 0`: the stencil annihilates constants. | `EulerFactorChain.h` | `EulerFactorChain.h_one` |
| `EulerFactorChain.h_one`<br/>theorem, line 161 | h b N 1 = 0 | b : ℝ; hb : b ≠ 0; hN : N ≠ 0 | B2b. `h` vanishes at `s = 1`, so there is no pole contribution. | `EulerFactorChain.h`, `EulerFactorChain.h_functional_equation`, `EulerFactorChain.h_zero` | — |
| `EulerFactorChain.conj_factor_on_critical_line`<br/>theorem, line 168 | (starRingEnd ℂ) (1 - (b : ℂ) ^ (-((1 : ℂ)/2 + t * I))) = 1 - (b : ℂ) ^ (((1 : ℂ)/2 + t * I) - 1) | hb : 0 &lt; b; t : ℝ | On the critical line the second factor is the conjugate of the first. | — | `EulerFactorChain.h_eq_gain_pow_on_critical_line` |
| `EulerFactorChain.h_eq_gain_pow_on_critical_line`<br/>theorem, line 188 | h b N ((1 : ℂ)/2 + t * I) = ((‖1 - (b : ℂ) ^ (-((1 : ℂ)/2 + t * I))‖ : ℝ) ^ (2 * N) : ℝ) | hb : 0 &lt; b; N : ℕ; t : ℝ | B4. On the critical line, `h = ‖1 - b^(-s)‖^(2N)` — real, non-negative, and equal to the depth-transfer gain raised to the `2N`. | `EulerFactorChain.conj_factor_on_critical_line`, `EulerFactorChain.h` | `Chain.B4` |
| `EulerFactorChain.cpow_rect_on_critical_line`<br/>theorem, line 201 | (b : ℂ) ^ (-((1 : ℂ)/2 + γ * I)) = ((b ^ (-(1:ℝ)/2) * Real.cos (γ * Real.log b) : ℝ) : ℂ) + ((-(b ^ (-(1:ℝ)/2) * Real.sin (γ * Real.log b)) : ℝ) : ℂ) * I | hb : 0 &lt; b; γ : ℝ | Rectangular form of the Euler factor's reciprocal on the critical line. Writing `θ = γ · log b`, `b^(-(1/2 + γi)) = b^(-1/2)·(cos θ - i sin θ)`. | — | `EulerFactorChain.gain_sq_on_critical_line` |
| `EulerFactorChain.gain_sq_on_critical_line`<br/>theorem, line 225 | ‖1 - (b : ℂ) ^ (-((1 : ℂ)/2 + γ * I))‖ ^ 2 = 1 - 2 * b ^ (-(1:ℝ)/2) * Real.cos (γ * Real.log b) + b ^ (-(1:ℝ)) | hb : 0 &lt; b; γ : ℝ | C1. On the critical line `s = 1/2 + γi`, the squared modulus of the reciprocal Euler factor expands as the law of cosines with sides `1` and `b^(-1/2)` and included angle `θ = γ · log b`: | `EulerFactorChain.cpow_rect_on_critical_line` | `Chain.C1`, `Chain.gain_sq_at_ceiling`, `Chain.gain_sq_at_floor` |
