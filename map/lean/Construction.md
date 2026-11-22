# `lean/Construction.lean`

**What it does** (its own header): Construction — the table has no free parameter, so the zeros were not placed. `Zeros.lean` records that nothing predicts WHERE the four exact zeros are. That is true and stays true. This file proves the complementary thing, which is what makes them structural rather than arbitrary:

**Imports:** nothing in this tree.
**Imported by:** [`Chain`](../lean/Chain.md), [`PairIdentity`](../lean/PairIdentity.md), [`Propagation`](../lean/Propagation.md), [`SeedPerturbation`](../lean/SeedPerturbation.md), [`Zeros`](../lean/Zeros.md), [`ZerosStencil`](../lean/ZerosStencil.md).

```mermaid
flowchart LR
  n0["tableFrom<br/>(def)"]:::dfn
  n1["IsTableOf<br/>(def)"]:::dfn
  n2["tableFrom_isTableOf<br/>⊢ IsTableOf N (tableFrom N)"]:::thm
  n3["unique_of_isTableOf<br/>⊢ ∀ r d, f r d = tableFrom N r d"]:::thm
  n4["eq_of_same_row<br/>⊢ ∀ r d, f r d = g r d"]:::end_
  n5["zero_determined_by_row<br/>⊢ tableFrom N r d = tableFrom M r d"]:::thm
  n6["tableFrom_add<br/>⊢ tableFrom (fun x =＞ N x + M x) r d = tableFrom N r d + tableFrom M r d"]:::thm
  n7["tableFrom_smul<br/>⊢ tableFrom (fun x =＞ c * N x) r d = c * tableFrom N r d"]:::thm
  n8["measured_zeros<br/>(def)"]:::dfn
  x0(["Chain · 3 declarations"]):::ext
  x1(["Expansion · 1 declarations"]):::ext
  x2(["Interpolant · 1 declarations"]):::ext
  x3(["MainTerm · 1 declarations"]):::ext
  x4(["Nonvanishing · 1 declarations"]):::ext
  x5(["PairIdentity · 5 declarations"]):::ext
  x6(["Propagation · 4 declarations"]):::ext
  x7(["RelativeGate · 1 declarations"]):::ext
  x8(["RelativeLi · 3 declarations"]):::ext
  x9(["RouteCell · 1 declarations"]):::ext
  x10(["Schoenfeld · 1 declarations"]):::ext
  x11(["SeedPerturbation · 14 declarations"]):::ext
  x12(["Superposition · 1 declarations"]):::ext
  x13(["ZeroCells · 4 declarations"]):::ext
  x14(["Zeros · 11 declarations"]):::ext
  x15(["ZerosStencil · 4 declarations"]):::ext
  x16(["TableDepths · 9 declarations"]):::ext
  x17(["TableRoute · 1 declarations"]):::ext
  n0 --> n2
  n0 --> n3
  n0 --> n5
  n0 --> n6
  n0 --> n7
  n0 --> x0
  n0 --> x1
  n0 --> x10
  n0 --> x11
  n0 --> x12
  n0 --> x13
  n0 --> x14
  n0 --> x15
  n0 --> x16
  n0 --> x17
  n0 --> x2
  n0 --> x3
  n0 --> x4
  n0 --> x5
  n0 --> x6
  n0 --> x7
  n0 --> x8
  n0 --> x9
  n1 --> n2
  n1 --> n3
  n1 --> n4
  n2 --> x14
  n3 --> n4
  n5 --> x11
  n5 --> x5
  n5 --> x6
  n6 --> x11
  n6 --> x5
  n7 --> x11
  n8 --> x13
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
| `Construction.tableFrom`<br/>def, line 49 | ℤ → ℕ → ℤ | N : ℤ → ℤ | The table built from a depth-0 row by repeated backward differencing. | — | `Chain.tableFrom_eq_bdiff_iter`, `Chain.tableFrom_mode`, `Chain.tableFrom_norm_on_critical_line`, `Construction.tableFrom_add`, `Construction.tableFrom_isTableOf`, `Construction.tableFrom_smul`, `Construction.unique_of_isTableOf`, `Construction.zero_determined_by_row`, `Expansion.tableFrom_ne_zero_of_li`, `Interpolant.tableFrom_ne_zero_of_relErr_liRow`, `MainTerm.tableFrom_ne_zero_of_deriv`, `Nonvanishing.tableFrom_ne_zero_of`, `PairIdentity.composite_at_zero_20_6`, `PairIdentity.composite_of_prime_zero`, `PairIdentity.pair_identity`, `PairIdentity.tableFrom_add_window`, `PairIdentity.tableFrom_of_geometric`, `Propagation.cone_filled`, `Propagation.flux_form`, `Propagation.outside_cone_zero`, `Propagation.propagator`, `RelativeGate.tableFrom_ne_zero_of_relErr`, `RelativeLi.tableFrom_ne_zero_of_powerSaving`, `RelativeLi.tableFrom_ne_zero_of_relErr_li`, `RelativeLi.tableFrom_ne_zero_of_relErr_li'`, `RouteCell.cell_ne_zero_of_route`, `Schoenfeld.tableFrom_ne_zero_of_schoenfeld`, `SeedPerturbation.boundary_can_move`, `SeedPerturbation.cell_eq_of_seed_perturbation`, `SeedPerturbation.cell_ne_at_boundary` … |
| `Construction.IsTableOf`<br/>def, line 54 | Prop | N : ℤ → ℤ; f : ℤ → ℕ → ℤ | The defining recurrence, as a property a function may or may not have. | — | `Construction.eq_of_same_row`, `Construction.tableFrom_isTableOf`, `Construction.unique_of_isTableOf` |
| `Construction.tableFrom_isTableOf`<br/>theorem, line 58 | IsTableOf N (tableFrom N) | N : ℤ → ℤ | `tableFrom` satisfies its own recurrence. | `Construction.IsTableOf`, `Construction.tableFrom` | `Zeros.tableFrom_isTable` |
| `Construction.unique_of_isTableOf`<br/>theorem, line 68 | ∀ r d, f r d = tableFrom N r d | hf : IsTableOf N f | Uniqueness. Any function satisfying the recurrence with the same depth-0 row IS the table. There is no choice at any cell — fix the row and the entire table, to every depth, is determined. | `Construction.IsTableOf`, `Construction.tableFrom` | `Construction.eq_of_same_row` |
| `Construction.eq_of_same_row`<br/>theorem, line 76 | ∀ r d, f r d = g r d | hf : IsTableOf N f; hg : IsTableOf N g | Two tables over the same row agree everywhere. | `Construction.IsTableOf`, `Construction.unique_of_isTableOf` | — |
| `Construction.zero_determined_by_row`<br/>theorem, line 84 | tableFrom N r d = tableFrom M r d | r : ℤ; d : ℕ; h : ∀ k : ℕ, k ≤ d → N (r - k) = M (r - k) | A zero is determined by the row. If two counting functions agree on the window a cell reads, that cell is the same for both — in particular one vanishes exactly when the other does. Nothing outside the window can move it, and nothing inside the construction can either. | `Construction.tableFrom` | `PairIdentity.tableFrom_add_window`, `Propagation.outside_cone_zero`, `SeedPerturbation.tableFrom_eq_zero_of_vanishing_above` |
| `Construction.tableFrom_add`<br/>theorem, line 112 | tableFrom (fun x =&gt; N x + M x) r d = tableFrom N r d + tableFrom M r d | N M : ℤ → ℤ; r : ℤ; d : ℕ | Differencing is linear, at every depth. The operator carries no parameter to tune — this is what forces Pascal's weights rather than selecting them. | `Construction.tableFrom` | `PairIdentity.tableFrom_add_window`, `SeedPerturbation.tableFrom_sub` |
| `Construction.tableFrom_smul`<br/>theorem, line 125 | tableFrom (fun x =&gt; c * N x) r d = c * tableFrom N r d | c : ℤ; N : ℤ → ℤ; r : ℤ; d : ℕ | Scalars pass through the table: the table of `c·N` is `c` times the table of `N`. The other half of linearity, beside `tableFrom_add`. | `Construction.tableFrom` | `SeedPerturbation.tableFrom_sub` |
| `Construction.measured_zeros`<br/>def, line 149 | List (ℕ × ℕ) | — | The four exact zeros. Determined by pi through a parameter-free construction; located by nothing. `results/O16_run2.log`. | — | `ZeroCells.construction_all_vanish`, `ZeroCells.construction_eq` |
