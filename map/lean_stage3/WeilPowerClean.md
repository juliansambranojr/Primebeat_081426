# `lean_stage3/Stage3/WeilPowerClean.lean`

**What it does** (its own header): WeilPowerClean — the clean shell. Rung 5, eighteenth slice; worksheet § 13 block 13h. 2026-09-07.

**Imports:** [`Statement`](../lean_stage3/Statement.md).
**Imported by:** [`Stage3`](../lean_stage3/Stage3.md), [`WeilPowerCount`](../lean_stage3/WeilPowerCount.md).

```mermaid
flowchart LR
  n0["blocked_card_le<br/>⊢ B.card ≤ W + 1"]:::thm
  n1["exists_unblocked<br/>⊢ ∃ k, k ＜ K ∧ ∀ j ∈ S, k ∉ B j"]:::thm
  n2["exists_clean_shell<br/>⊢ ∃ k, k ＜ K ∧ ∀ j ∈ S, k ∉ B j"]:::thm
  n3["exists_clean_shell_of_count<br/>⊢ ∃ k, k ＜ K ∧ ∀ j ∈ S, k ∉ B j"]:::thm
  x0(["WeilPowerCount · exists_clean_shell_of_leaf"]):::ext
  n0 --> n2
  n1 --> n2
  n2 --> n3
  n3 --> x0
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
| `WeilPowerClean.blocked_card_le`<br/>theorem, line 62 | B.card ≤ W + 1 | B : Finset ℕ; hρ : 1 ≤ ρ; hlo : 0 &lt; lo; hW : hi &lt; lo * ρ ^ (W + 1); hB : ∀ k ∈ B, lo ≤ d * (a * ρ ^ k) ∧ d * (a * ρ ^ k) ≤ hi | One member's blocked shells sit inside `W + 1` consecutive shells: the shell scale `a * ρ ^ k` climbs by the factor `ρ`, while the window `[lo, hi]` does not move. | — | `WeilPowerClean.exists_clean_shell` |
| `WeilPowerClean.exists_unblocked`<br/>theorem, line 95 | ∃ k, k &lt; K ∧ ∀ j ∈ S, k ∉ B j | S : Finset ι; B : ι → Finset ℕ; hB : ∀ j ∈ S, (B j).card ≤ W; hK : S.card * W &lt; K | More shells than the members can block leaves one shell in no member's blocking set. | — | `WeilPowerClean.exists_clean_shell` |
| `WeilPowerClean.exists_clean_shell`<br/>theorem, line 114 | ∃ k, k &lt; K ∧ ∀ j ∈ S, k ∉ B j | S : Finset ι; B : ι → Finset ℕ; d : ι → ℝ; hρ : 1 ≤ ρ; hlo : 0 &lt; lo; hW : hi &lt; lo * ρ ^ (W + 1); hB : ∀ j ∈ S, ∀ k ∈ B j, lo ≤ d j * (a * ρ ^ k) ∧ d j * (a * ρ ^ k) ≤ hi; hK : S.card * (W + 1) &lt; K | The clean shell: `blocked_card_le` at each member, then `exists_unblocked` at `W + 1`. | `WeilPowerClean.blocked_card_le`, `WeilPowerClean.exists_unblocked` | `WeilPowerClean.exists_clean_shell_of_count` |
| `WeilPowerClean.exists_clean_shell_of_count`<br/>theorem, line 124 | ∃ k, k &lt; K ∧ ∀ j ∈ S, k ∉ B j | S : Finset ι; B : ι → Finset ℕ; d : ι → ℝ; hρ : 1 ≤ ρ; hlo : 0 &lt; lo; hW : hi &lt; lo * ρ ^ (W + 1); hB : ∀ j ∈ S, ∀ k ∈ B j, lo ≤ d j * (a * ρ ^ k) ∧ d j * (a * ρ ^ k) ≤ hi; hN : S.card ≤ N; hK : N * (W + 1) &lt; K | The same with the member count given by a bound `N`. | `WeilPowerClean.exists_clean_shell` | `WeilPowerCount.exists_clean_shell_of_leaf` |
