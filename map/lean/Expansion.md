# `lean/Expansion.lean`

**What it does** (its own header): Expansion — stage 2b: the derivative of 2^x/x, explicitly, and its floor. `MainTerm.lean` reduced O67's main-term hypothesis to `hD`: a floor on the `(d+1)`-th derivative of the li-interpolant on the window — equivalently, on the `d`-th derivative of `2^x/x`. This module supplies both halves:

**Imports:** [`MainTerm`](../lean/MainTerm.md).
**Imported by:** [`RelativeLi`](../lean/RelativeLi.md), [`Schoenfeld`](../lean/Schoenfeld.md).

```mermaid
flowchart LR
  n0["c<br/>(def)"]:::dfn
  n1["S<br/>(def)"]:::dfn
  n2["F<br/>(def)"]:::dfn
  n3["f2x<br/>(def)"]:::dfn
  n4["exp_eq_rpow<br/>⊢ Real.exp (Real.log 2 * x) = (2 : ℝ) ^ x"]:::thm
  n5["F_zero<br/>⊢ F 0 x = f2x x"]:::thm
  n6["c_rec<br/>⊢ c (d + 1) j = Real.log 2 * c d j + (-(j : ℝ)) * c d (j - 1)"]:::thm
  n7["hasDerivAt_S<br/>⊢ HasDerivAt (S d) (∑ j ∈ range (d + 1), c d j * (-(j : ℝ) - 1) * x ^ (-…"]:::thm
  n8["hasDerivAt_F<br/>⊢ HasDerivAt (F d) (F (d + 1) x) x"]:::thm
  n9["iteratedDeriv_f2x<br/>⊢ ∀ x ∈ Ioi (0 : ℝ), iteratedDeriv d f2x x = F d x"]:::thm
  n10["t<br/>(def)"]:::dfn
  n11["t_nonneg<br/>⊢ 0 ≤ t d j x"]:::thm
  n12["S_eq_alt<br/>⊢ S d x = ∑ j ∈ range (d + 1), (-1 : ℝ) ^ j * t d j x"]:::thm
  n13["choose_factorial_step<br/>⊢ d.choose (j + 1) * (j + 1).factorial = d.choose j * j.factorial * (d -…"]:::thm
  n14["t_halves<br/>⊢ t d (j + 1) x ≤ t d j x / 2"]:::thm
  n15["B<br/>(def)"]:::dfn
  n16["B_peel<br/>⊢ B d x k = t d k x - B d x (k + 1)"]:::thm
  n17["B_bounds<br/>⊢ ∀ m k, k + m = d → 0 ≤ B d x k ∧ B d x k ≤ t d k x"]:::thm
  n18["t_zero<br/>⊢ t d 0 x = Real.log 2 ^ d * x⁻¹"]:::thm
  n19["S_floor<br/>⊢ Real.log 2 ^ d / (2 * x) ≤ S d x"]:::thm
  n20["F_floor<br/>⊢ (2 : ℝ) ^ x * (Real.log 2 ^ d / (2 * x)) ≤ F d x"]:::thm
  n21["hD_of_window<br/>⊢ ∀ y ∈ Icc ((r : ℝ) - (d + 1)) r, Nonvanishing.Mlow r d ≤ iteratedDeriv…"]:::thm
  n22["tableFrom_ne_zero_of_li<br/>⊢ Construction.tableFrom N r d ≠ 0"]:::thm
  x0(["Construction · tableFrom"]):::ext
  x1(["Interpolant · F"]):::ext
  x2(["Interpolant · F_hasDerivAt"]):::ext
  x3(["Interpolant · f2x_contDiffOn"]):::ext
  x4(["Interpolant · f2x_continuousOn"]):::ext
  x5(["Interpolant · liRow_eq"]):::ext
  x6(["Interpolant · liRow_hasDerivAt"]):::ext
  x7(["MainTerm · tableFrom_ne_zero_of_deriv"]):::ext
  x8(["Nonvanishing · Ehigh"]):::ext
  x9(["Nonvanishing · Mlow"]):::ext
  x10(["Nonvanishing · StmtSchoenfeldWindow"]):::ext
  x11(["Nonvanishing · bdiffZ"]):::ext
  x12(["RelativeLi · tableFrom_ne_zero_of_powerSaving"]):::ext
  x13(["RelativeLi · tableFrom_ne_zero_of_relErr_li"]):::ext
  x14(["RelativeLi · tableFrom_ne_zero_of_relErr_li'"]):::ext
  x15(["Schoenfeld · tableFrom_ne_zero_of_schoenfeld"]):::ext
  n0 --> n1
  n0 --> n12
  n0 --> n5
  n0 --> n6
  n0 --> n7
  n0 --> n8
  n1 --> n12
  n1 --> n19
  n1 --> n2
  n1 --> n5
  n1 --> n7
  n1 --> n8
  n10 --> n11
  n10 --> n12
  n10 --> n14
  n10 --> n15
  n10 --> n16
  n10 --> n17
  n10 --> n18
  n10 --> n19
  n11 --> n17
  n11 --> n19
  n12 --> n19
  n13 --> n14
  n14 --> n17
  n14 --> n19
  n15 --> n16
  n15 --> n17
  n15 --> n19
  n16 --> n17
  n16 --> n19
  n17 --> n19
  n18 --> n19
  n19 --> n20
  n2 --> n20
  n2 --> n5
  n2 --> n8
  n2 --> n9
  n20 --> n21
  n21 --> n22
  n21 --> x13
  n22 --> x15
  n3 --> n21
  n3 --> n22
  n3 --> n5
  n3 --> n8
  n3 --> n9
  n3 --> x1
  n3 --> x12
  n3 --> x13
  n3 --> x14
  n3 --> x15
  n3 --> x2
  n3 --> x3
  n3 --> x4
  n3 --> x5
  n3 --> x6
  n4 --> n20
  n5 --> n9
  n6 --> n8
  n7 --> n8
  n8 --> n9
  n9 --> n21
  x0 --> n22
  x10 --> n22
  x11 --> n22
  x7 --> n22
  x8 --> n22
  x9 --> n21
  x9 --> n22
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
| `Expansion.c`<br/>def, line 43 | ℝ | d j : ℕ | The expansion coefficients: `C(d,j)·(log 2)^(d−j)·(−1)^j·j!`. `Nat.choose` vanishes past the diagonal, so no `ite` is needed. | — | `Expansion.F_zero`, `Expansion.S`, `Expansion.S_eq_alt`, `Expansion.c_rec`, `Expansion.hasDerivAt_F`, `Expansion.hasDerivAt_S` |
| `Expansion.S`<br/>def, line 47 | ℝ | d : ℕ; x : ℝ | The rational part of the `d`-th derivative of `2^x/x`. | `Expansion.c` | `Expansion.F`, `Expansion.F_zero`, `Expansion.S_eq_alt`, `Expansion.S_floor`, `Expansion.hasDerivAt_F`, `Expansion.hasDerivAt_S` |
| `Expansion.F`<br/>def, line 51 | ℝ | d : ℕ; x : ℝ | The `d`-th derivative of `2^x/x`, in closed form. | `Expansion.S` | `Expansion.F_floor`, `Expansion.F_zero`, `Expansion.hasDerivAt_F`, `Expansion.iteratedDeriv_f2x` |
| `Expansion.f2x`<br/>def, line 54 | ℝ | x : ℝ | The function itself, in the exp form the calculus uses. | — | `Expansion.F_zero`, `Expansion.hD_of_window`, `Expansion.hasDerivAt_F`, `Expansion.iteratedDeriv_f2x`, `Expansion.tableFrom_ne_zero_of_li`, `Interpolant.F`, `Interpolant.F_hasDerivAt`, `Interpolant.f2x_contDiffOn`, `Interpolant.f2x_continuousOn`, `Interpolant.liRow_eq`, `Interpolant.liRow_hasDerivAt`, `RelativeLi.tableFrom_ne_zero_of_powerSaving`, `RelativeLi.tableFrom_ne_zero_of_relErr_li`, `RelativeLi.tableFrom_ne_zero_of_relErr_li'`, `Schoenfeld.tableFrom_ne_zero_of_schoenfeld` |
| `Expansion.exp_eq_rpow`<br/>theorem, line 57 | Real.exp (Real.log 2 * x) = (2 : ℝ) ^ x | x : ℝ | `e^((log 2)·x) = 2^x`. | — | `Expansion.F_floor` |
| `Expansion.F_zero`<br/>theorem, line 61 | F 0 x = f2x x | x : ℝ | `F 0` is the function itself. | `Expansion.F`, `Expansion.S`, `Expansion.c`, `Expansion.f2x` | `Expansion.iteratedDeriv_f2x` |
| `Expansion.c_rec`<br/>theorem, line 67 | c (d + 1) j = Real.log 2 * c d j + (-(j : ℝ)) * c d (j - 1) | d j : ℕ | The coefficient recurrence — Pascal with the factorial absorbed; the `j = 0` edge dies against the `−j` factor. | `Expansion.c` | `Expansion.hasDerivAt_F` |
| `Expansion.hasDerivAt_S`<br/>theorem, line 107 | HasDerivAt (S d) (∑ j ∈ range (d + 1), c d j * (-(j : ℝ) - 1) * x ^ (-(j + 2 : ℤ))) x | d : ℕ; hx : x ≠ 0 | `S` differentiates term-by-term into the pre-recombination sum. | `Expansion.S`, `Expansion.c` | `Expansion.hasDerivAt_F` |
| `Expansion.hasDerivAt_F`<br/>theorem, line 128 | HasDerivAt (F d) (F (d + 1) x) x | d : ℕ; hx : x ≠ 0 | The expansion advances: `F d` has derivative `F (d+1)` at `x ≠ 0`. Product rule, the coefficient recurrence, and one `sum_range_succ'` reindex. | `Expansion.F`, `Expansion.S`, `Expansion.c`, `Expansion.c_rec`, `Expansion.f2x`, `Expansion.hasDerivAt_S` | `Expansion.iteratedDeriv_f2x` |
| `Expansion.iteratedDeriv_f2x`<br/>theorem, line 183 | ∀ x ∈ Ioi (0 : ℝ), iteratedDeriv d f2x x = F d x | d : ℕ | `iteratedDeriv d` of `2^x/x` IS `F d`, on `(0,∞)`. Induction; the step replaces `iteratedDeriv d f2x` by `F d` through `EventuallyEq.deriv_eq` on the open half-line, then advances by `hasDerivAt_F`. | `Expansion.F`, `Expansion.F_zero`, `Expansion.f2x`, `Expansion.hasDerivAt_F` | `Expansion.hD_of_window` |
| `Expansion.t`<br/>def, line 200 | ℝ | d j : ℕ; x : ℝ | The unsigned term of `S`. | — | `Expansion.B`, `Expansion.B_bounds`, `Expansion.B_peel`, `Expansion.S_eq_alt`, `Expansion.S_floor`, `Expansion.t_halves`, `Expansion.t_nonneg`, `Expansion.t_zero` |
| `Expansion.t_nonneg`<br/>theorem, line 204 | 0 ≤ t d j x | hx : 0 &lt; x | Every unsigned term is nonnegative on `x &gt; 0`. | `Expansion.t` | `Expansion.B_bounds`, `Expansion.S_floor` |
| `Expansion.S_eq_alt`<br/>theorem, line 212 | S d x = ∑ j ∈ range (d + 1), (-1 : ℝ) ^ j * t d j x | d : ℕ; x : ℝ | `S` is the alternating sum of the unsigned terms. | `Expansion.S`, `Expansion.c`, `Expansion.t` | `Expansion.S_floor` |
| `Expansion.choose_factorial_step`<br/>theorem, line 219 | d.choose (j + 1) * (j + 1).factorial = d.choose j * j.factorial * (d - j) | d j : ℕ | The choose-ratio identity, in ℕ where it is clean: `C(d,j+1)·(j+1)! = C(d,j)·j!·(d−j)`. | — | `Expansion.t_halves` |
| `Expansion.t_halves`<br/>theorem, line 226 | t d (j + 1) x ≤ t d j x / 2 | hx : 0 &lt; x; hw : 2 * (d : ℝ) ≤ Real.log 2 * x; j : ℕ | The terms halve in the wedge `2d ≤ (log 2)·x`: `t (j+1) ≤ t j / 2`. | `Expansion.choose_factorial_step`, `Expansion.t` | `Expansion.B_bounds`, `Expansion.S_floor` |
| `Expansion.B`<br/>def, line 281 | ℝ | d : ℕ; x : ℝ; k : ℕ | The downward tail `B k = Σ_{j&lt;d+1−k} (−1)^j t(k+j)`. | `Expansion.t` | `Expansion.B_bounds`, `Expansion.B_peel`, `Expansion.S_floor` |
| `Expansion.B_peel`<br/>theorem, line 285 | B d x k = t d k x - B d x (k + 1) | hk : k ≤ d | Peeling the head of the tail: `B k = t k − B (k+1)` for `k ≤ d`. | `Expansion.B`, `Expansion.t` | `Expansion.B_bounds`, `Expansion.S_floor` |
| `Expansion.B_bounds`<br/>theorem, line 304 | ∀ m k, k + m = d → 0 ≤ B d x k ∧ B d x k ≤ t d k x | hx : 0 &lt; x; hw : 2 * (d : ℝ) ≤ Real.log 2 * x | The tail bound `0 ≤ B k ≤ t k`, by downward induction on the tail length, using only that the terms halve. | `Expansion.B`, `Expansion.B_peel`, `Expansion.t`, `Expansion.t_halves`, `Expansion.t_nonneg` | `Expansion.S_floor` |
| `Expansion.t_zero`<br/>theorem, line 334 | t d 0 x = Real.log 2 ^ d * x⁻¹ | d : ℕ; x : ℝ | The leading term: `t 0 = (log 2)^d / x`. | `Expansion.t` | `Expansion.S_floor` |
| `Expansion.S_floor`<br/>theorem, line 339 | Real.log 2 ^ d / (2 * x) ≤ S d x | hx : 0 &lt; x; hw : 2 * (d : ℝ) ≤ Real.log 2 * x | The floor on `S`: in the wedge, `S d x ≥ t₀/2 = (log 2)^d/(2x)`. | `Expansion.B`, `Expansion.B_bounds`, `Expansion.B_peel`, `Expansion.S`, `Expansion.S_eq_alt`, `Expansion.t`, `Expansion.t_halves`, `Expansion.t_nonneg`, `Expansion.t_zero` | `Expansion.F_floor` |
| `Expansion.F_floor`<br/>theorem, line 365 | (2 : ℝ) ^ x * (Real.log 2 ^ d / (2 * x)) ≤ F d x | hx : 0 &lt; x; hw : 2 * (d : ℝ) ≤ Real.log 2 * x | The full floor on the closed form: `F d x ≥ (1/2)·2^x·(log 2)^d/x`. | `Expansion.F`, `Expansion.S_floor`, `Expansion.exp_eq_rpow` | `Expansion.hD_of_window` |
| `Expansion.hD_of_window`<br/>theorem, line 376 | ∀ y ∈ Icc ((r : ℝ) - (d + 1)) r, Nonvanishing.Mlow r d ≤ iteratedDeriv (d + 1) G y | hG' : ∀ x ∈ Ioi ((1 : ℝ) / 2), HasDerivAt G (f2x x) x; hbot : (1 : ℝ) ≤ (r : ℝ) - (d + 1); hw : 2 * (d : ℝ) ≤ Real.log 2 * ((r : ℝ) - (d + 1)) | `hD` discharged. On the window `[r−(d+1), r]` with the window bottom positive and the wedge holding there, the `(d+1)`-th derivative of any smooth interpolant whose derivative is `2^x/x` on `(0,∞)` clears `Mlow`. The chain: `iteratedDeriv (d+1) G = iteratedDeriv d (2^x/x) = F d ≥ floor ≥ Mlow`. | `Expansion.F_floor`, `Expansion.f2x`, `Expansion.iteratedDeriv_f2x`, `Nonvanishing.Mlow` | `Expansion.tableFrom_ne_zero_of_li`, `RelativeLi.tableFrom_ne_zero_of_relErr_li` |
| `Expansion.tableFrom_ne_zero_of_li`<br/>theorem, line 438 | Construction.tableFrom N r d ≠ 0 | hG : ContDiff ℝ (⊤ : ℕ∞) G; hG' : ∀ x ∈ Ioi ((1 : ℝ) / 2), HasDerivAt G (f2x x) x; hrow : ∀ k ∈ range (d + 2), ((N (r - k) : ℤ) : ℝ) = Nonvanishing.bdiffZ f (r - k); hr : ((d + 1 : ℕ) : ℤ) ≤ r; hS : Nonvanishing.StmtSchoenfeldWindow f (fun k : ℤ =&gt; G k) r (d + 1); hbot : (1 : ℝ) ≤ (r : ℝ) - (d + 1); hw : 2 * (d : ℝ) ≤ Real.log 2 * ((r : ℝ) - (d + 1)); hgap : Nonvanishing.Ehigh r (d + 1) &lt; Nonvanishing.Mlow r d | O67's conditional theorem, with the analysis discharged. The hypotheses are now exactly: the interpolant and its derivative structure (what "li" means here), Schoenfeld on the window (stage 3), the row agreement, the gap arithmetic, and the wedge/positivity arithmetic. The MVT, the alternating series, the expansion of `2^x/x` — all under the kernel. | `Construction.tableFrom`, `Expansion.f2x`, `Expansion.hD_of_window`, `MainTerm.tableFrom_ne_zero_of_deriv`, `Nonvanishing.Ehigh`, `Nonvanishing.Mlow`, `Nonvanishing.StmtSchoenfeldWindow`, `Nonvanishing.bdiffZ` | `Schoenfeld.tableFrom_ne_zero_of_schoenfeld` |
