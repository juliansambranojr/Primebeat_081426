# `lean/Isogeny.lean`

**What it does** (its own header): Isogeny — what the isogeny does to the row. `Transform.tau_ratio_of_meet` proves that two ladders which meet have rationally related modular parameters: `bⁿ = cᵐ → τ(b)/τ(c) = n/m`. That is a statement about the tori `ℂ*/b^ℤ`, and the torus knows only `b`. No prime enters it.

**Imports:** [`Zeros`](../lean/Zeros.md).
**Imported by:** nothing.

```mermaid
flowchart LR
  n0["rowN<br/>(def)"]:::dfn
  n1["rowOf<br/>(def)"]:::dfn
  n2["rowOf_eq_rowN<br/>⊢ rowOf P b r = rowN (fun n =＞ P (b ^ n)) 1 r"]:::end_
  n3["telescope<br/>⊢ ∑ j ∈ range k, (g (m + j + 1) - g (m + j)) = g (m + k) - g m"]:::thm
  n4["rowN_eq_blockSum<br/>⊢ rowN Q k r = ∑ j ∈ range k, rowN Q 1 (k * r + j)"]:::end_
  n5["row_two_eq_pair<br/>⊢ rowN Q 2 r = rowN Q 1 (2 * r) + rowN Q 1 (2 * r + 1)"]:::end_
  n6["row_three_eq_triple<br/>⊢ rowN Q 3 r = rowN Q 1 (3 * r) + rowN Q 1 (3 * r + 1) + rowN Q 1 (3 * r…"]:::end_
  n7["rowN_comp<br/>⊢ rowN Q (k * l) r = rowN (fun n =＞ Q (k * n)) l r"]:::end_
  n8["dyadicRow_eq_rowN<br/>⊢ Zeros.dyadicRow ((r : ℤ) + 1) = rowN Zeros.pi2 1 r"]:::end_
  n9["measured_row_four<br/>⊢ (List.range 10).map (rowN Zeros.pi2 2) = [2, 4, 12, 36, 118, 392, 1336…"]:::end_
  n10["measured_row_eight<br/>⊢ (List.range 6).map (rowN Zeros.pi2 3) = [4, 14, 79, 467, 2948, 19488]"]:::end_
  x0(["Zeros · dyadicRow"]):::ext
  x1(["Zeros · pi2"]):::ext
  n0 --> n10
  n0 --> n2
  n0 --> n4
  n0 --> n5
  n0 --> n6
  n0 --> n7
  n0 --> n8
  n0 --> n9
  n1 --> n2
  n3 --> n4
  x0 --> n8
  x1 --> n10
  x1 --> n8
  x1 --> n9
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
| `Isogeny.rowN`<br/>def, line 44 | ℤ | Q : ℕ → ℤ; k : ℕ; r : ℕ | The row of an exponent-indexed count `Q` at decimation `k`: the count on the block from exponent `k*r` to exponent `k*(r+1)`. `k = 1` is the base row. | — | `Isogeny.dyadicRow_eq_rowN`, `Isogeny.measured_row_eight`, `Isogeny.measured_row_four`, `Isogeny.rowN_comp`, `Isogeny.rowN_eq_blockSum`, `Isogeny.rowOf_eq_rowN`, `Isogeny.row_three_eq_triple`, `Isogeny.row_two_eq_pair` |
| `Isogeny.rowOf`<br/>def, line 48 | ℤ | P : ℕ → ℤ; b : ℕ; r : ℕ | The "count up to `x`" reading, for a `P` that eats values rather than exponents. | — | `Isogeny.rowOf_eq_rowN` |
| `Isogeny.rowOf_eq_rowN`<br/>theorem, line 51 | rowOf P b r = rowN (fun n =&gt; P (b ^ n)) 1 r | P : ℕ → ℤ; b r : ℕ | The bridge: composing `P` with `b^·` turns one into the other. | `Isogeny.rowN`, `Isogeny.rowOf` | — |
| `Isogeny.telescope`<br/>theorem, line 58 | ∑ j ∈ range k, (g (m + j + 1) - g (m + j)) = g (m + k) - g m | g : ℕ → ℤ; m k : ℕ | Telescoping over `Finset.range`. Stated for an arbitrary `g : ℕ → ℤ` because that is all the identity below needs. | — | `Isogeny.rowN_eq_blockSum` |
| `Isogeny.rowN_eq_blockSum`<br/>theorem, line 68 | rowN Q k r = ∑ j ∈ range k, rowN Q 1 (k * r + j) | Q : ℕ → ℤ; k r : ℕ | The isogeny on the row. Passing from a ladder to its `k`-th power sums the row in blocks of `k`. Holds for any `Q`; no arithmetic input is used. | `Isogeny.rowN`, `Isogeny.telescope` | — |
| `Isogeny.row_two_eq_pair`<br/>theorem, line 78 | rowN Q 2 r = rowN Q 1 (2 * r) + rowN Q 1 (2 * r + 1) | Q : ℕ → ℤ; r : ℕ | Base 4's row is base 2's row summed in pairs. | `Isogeny.rowN` | — |
| `Isogeny.row_three_eq_triple`<br/>theorem, line 85 | rowN Q 3 r = rowN Q 1 (3 * r) + rowN Q 1 (3 * r + 1) + rowN Q 1 (3 * r + 2) | Q : ℕ → ℤ; r : ℕ | Base 8's row is base 2's row summed in triples. | `Isogeny.rowN` | — |
| `Isogeny.rowN_comp`<br/>theorem, line 94 | rowN Q (k * l) r = rowN (fun n =&gt; Q (k * n)) l r | Q : ℕ → ℤ; k l r : ℕ | Decimation composes. Reading a ladder at `k` and then at `l` is reading it at `k*l` — so `{2,4,8}` is a chain and not three separate relations. | `Isogeny.rowN` | — |
| `Isogeny.dyadicRow_eq_rowN`<br/>theorem, line 102 | Zeros.dyadicRow ((r : ℤ) + 1) = rowN Zeros.pi2 1 r | r : ℕ; h : r ≤ 19 | The weld to the measured row. `Zeros.dyadicRow` indexes from the top over `ℤ` and is windowed to `1 ≤ r ≤ 20`; inside that window it is `rowN Zeros.pi2 1` shifted by one. | `Isogeny.rowN`, `Zeros.dyadicRow`, `Zeros.pi2` | — |
| `Isogeny.measured_row_four`<br/>theorem, line 115 | (List.range 10).map (rowN Zeros.pi2 2) = [2, 4, 12, 36, 118, 392, 1336, 4642, 16458, 59025] | — | The measured base-4 row, from the 21 pinned values and nothing else. These are the numbers `row_two_eq_pair` says are base 2's row summed in pairs. | `Isogeny.rowN`, `Zeros.pi2` | — |
| `Isogeny.measured_row_eight`<br/>theorem, line 121 | (List.range 6).map (rowN Zeros.pi2 3) = [4, 14, 79, 467, 2948, 19488] | — | The measured base-8 row, same 21 values read at decimation 3. | `Isogeny.rowN`, `Zeros.pi2` | — |
