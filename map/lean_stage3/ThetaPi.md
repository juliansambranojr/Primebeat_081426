# `lean_stage3/Stage3/ThetaPi.lean`

**What it does** (its own header): ThetaPi — the ψ → π transfer at a general abscissa θ. `PsiToPi.schoenfeldWeak_of_psiWeak` is hardwired to exponent `1/2`: `StmtPsiWeak` carries a literal `Real.sqrt t`, and the envelope integral `integral_A_rpow_le` integrates `t^(−1/2)` to `2A·√x`. This file is the same proof with `x^θ` in place of `√x`, for `θ ∈ [1/2, 1)`:

**Imports:** [`PsiToPi`](../lean_stage3/PsiToPi.md), [`ThetaPsi`](../lean_stage3/ThetaPsi.md).
**Imported by:** [`Stage3`](../lean_stage3/Stage3.md), [`JointWindowDial`](../lean_stage3/JointWindowDial.md), [`ThetaConverse`](../lean_stage3/ThetaConverse.md).

```mermaid
flowchart LR
  n0["StmtPsiWeakTheta<br/>(def)"]:::dfn
  n1["StmtSchoenfeldWeakTheta<br/>(def)"]:::dfn
  n2["stmtPsiWeak_iff_theta_half<br/>⊢ StmtPsiWeak C k x₀ ↔ StmtPsiWeakTheta (1/2) C k x₀"]:::end_
  n3["stmtSchoenfeldWeak_iff_theta_half<br/>⊢ StmtSchoenfeldWeak C k x₀ pi li ↔ StmtSchoenfeldWeakTheta (1/2) C k x₀…"]:::end_
  n4["sqrt_le_rpow_theta<br/>⊢ Real.sqrt x ≤ x ^ θ"]:::thm
  n5["integral_A_rpow_theta_le<br/>⊢ (∫ t in a..x, A * t ^ (θ - 1)) ≤ 2 * A * x ^ θ"]:::thm
  n6["theta_err_of_psi_theta<br/>⊢ |ϑ x - x| ≤ E + 2 * x ^ θ * Real.log x"]:::thm
  n7["rpow_theta_sub_one_mul<br/>⊢ t ^ (θ - 1) * (t * Real.log t ^ 2) = t ^ θ * Real.log t ^ 2"]:::thm
  n8["schoenfeldWeakTheta_of_psiWeakTheta<br/>⊢ StmtSchoenfeldWeakTheta θ (3 * C + 13) (k - 1) (max (x₀ ^ 2) 9) (fun x…"]:::thm
  n9["schoenfeldWeak_of_psiWeak_half<br/>⊢ StmtSchoenfeldWeak (3 * C + 13) (k - 1) (max (x₀ ^ 2) 9) (fun x =＞ (Na…"]:::end_
  n10["schoenfeldWeakTheta_of_zeroFree<br/>⊢ ∃ C ＞ 0, ∃ x₀ : ℝ, StmtSchoenfeldWeakTheta θ C 2 x₀ (fun x =＞ (Nat.pri…"]:::thm
  n11["schoenfeldWeak_of_RH_half<br/>⊢ ∃ C ＞ 0, ∃ x₀ : ℝ, StmtSchoenfeldWeak C 2 x₀ (fun x =＞ (Nat.primeCount…"]:::end_
  x0(["Abscissa · StmtZeroFreeRight"]):::ext
  x1(["Abscissa · zeroFreeRight_of_RH"]):::ext
  x2(["JointDialGate · relErrWindow_of_theta"]):::ext
  x3(["JointDialGate · thetaWindow_of_global"]):::ext
  x4(["JointWindowDial · schoenfeldWeakTheta_of_window"]):::ext
  x5(["PsiToPi · Li"]):::ext
  x6(["PsiToPi · StmtPsiWeak"]):::ext
  x7(["PsiToPi · abs_theta_sub_le_linear"]):::ext
  x8(["PsiToPi · integrable_err_term"]):::ext
  x9(["PsiToPi · one_add_log_four_le"]):::ext
  x10(["PsiToPi · pi_sub_Li_eq"]):::ext
  x11(["PsiToPi · theta_err_of_psi"]):::ext
  x12(["Statement · StmtSchoenfeldWeak"]):::ext
  x13(["ThetaConverse · F_analyticOnNhd_theta"]):::ext
  x14(["ThetaConverse · F_differentiableAt_theta"]):::ext
  x15(["ThetaConverse · F_mul_zeta_add_deriv_eqOn_zero_theta"]):::ext
  x16(["ThetaConverse · RH_of_psiWeakTheta_half"]):::ext
  x17(["ThetaConverse · no_zero_right_of_theta"]):::ext
  x18(["ThetaConverse · zeroFreeRight_iff_psiWeakTheta"]):::ext
  x19(["ThetaConverse · zeroFreeRight_of_psiWeakTheta"]):::ext
  x20(["ThetaPsi · psi_weak_of_theta"]):::ext
  n0 --> n10
  n0 --> n2
  n0 --> n8
  n0 --> x13
  n0 --> x14
  n0 --> x15
  n0 --> x16
  n0 --> x17
  n0 --> x18
  n0 --> x19
  n1 --> n10
  n1 --> n3
  n1 --> n8
  n1 --> x2
  n1 --> x3
  n1 --> x4
  n10 --> n11
  n10 --> x4
  n4 --> n6
  n4 --> n8
  n5 --> n8
  n6 --> n8
  n7 --> n8
  n8 --> n10
  n8 --> n9
  x0 --> n10
  x1 --> n11
  x10 --> n8
  x11 --> n6
  x12 --> n11
  x12 --> n3
  x12 --> n9
  x20 --> n10
  x5 --> n10
  x5 --> n11
  x5 --> n8
  x5 --> n9
  x6 --> n2
  x6 --> n9
  x7 --> n8
  x8 --> n8
  x9 --> n8
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
| `Stage3.StmtPsiWeakTheta`<br/>def, line 43 | Prop | θ C : ℝ; k : ℕ; x₀ : ℝ | The ψ-side weak bound at exponent `θ`. `StmtPsiWeak` is the `θ = 1/2` member, `√t` written as `t^(1/2)`. | — | `Stage3.F_analyticOnNhd_theta`, `Stage3.F_differentiableAt_theta`, `Stage3.F_mul_zeta_add_deriv_eqOn_zero_theta`, `Stage3.RH_of_psiWeakTheta_half`, `Stage3.no_zero_right_of_theta`, `Stage3.zeroFreeRight_iff_psiWeakTheta`, `Stage3.zeroFreeRight_of_psiWeakTheta`, `Stage3.schoenfeldWeakTheta_of_psiWeakTheta`, `Stage3.schoenfeldWeakTheta_of_zeroFree`, `Stage3.stmtPsiWeak_iff_theta_half` |
| `Stage3.StmtSchoenfeldWeakTheta`<br/>def, line 47 | Prop | θ C : ℝ; k : ℕ; x₀ : ℝ; pi li : ℝ → ℝ | The π-side weak bound at exponent `θ`. | — | `JointDialGate.relErrWindow_of_theta`, `JointDialGate.thetaWindow_of_global`, `JointWindowDial.schoenfeldWeakTheta_of_window`, `Stage3.schoenfeldWeakTheta_of_psiWeakTheta`, `Stage3.schoenfeldWeakTheta_of_zeroFree`, `Stage3.stmtSchoenfeldWeak_iff_theta_half` |
| `Stage3.stmtPsiWeak_iff_theta_half`<br/>theorem, line 50 | StmtPsiWeak C k x₀ ↔ StmtPsiWeakTheta (1/2) C k x₀ | — | — | `Stage3.StmtPsiWeak`, `Stage3.StmtPsiWeakTheta` | — |
| `Stage3.stmtSchoenfeldWeak_iff_theta_half`<br/>theorem, line 56 | StmtSchoenfeldWeak C k x₀ pi li ↔ StmtSchoenfeldWeakTheta (1/2) C k x₀ pi li | — | — | `Stage3.StmtSchoenfeldWeak`, `Stage3.StmtSchoenfeldWeakTheta` | — |
| `Stage3.sqrt_le_rpow_theta`<br/>theorem, line 64 | Real.sqrt x ≤ x ^ θ | hx : 1 ≤ x; hθlo : 1/2 ≤ θ | `√x ≤ x^θ` for `x ≥ 1`, `θ ≥ 1/2`. This is where `1/2 ≤ θ` enters the transfer: Mathlib's `\|ψ − ϑ\| ≤ 2√x·log x` folds under the `x^θ` envelope. | — | `Stage3.schoenfeldWeakTheta_of_psiWeakTheta`, `Stage3.theta_err_of_psi_theta` |
| `Stage3.integral_A_rpow_theta_le`<br/>theorem, line 71 | (∫ t in a..x, A * t ^ (θ - 1)) ≤ 2 * A * x ^ θ | ha : 0 &lt; a; hx : a ≤ x; hA : 0 ≤ A; hθlo : 1/2 ≤ θ | The envelope integral at `θ`: `∫ₐˣ A·t^(θ−1) dt ≤ 2A·x^θ`. The exact value is `A·(x^θ − a^θ)/θ`; `1/θ ≤ 2` keeps PsiToPi's constant. | — | `Stage3.schoenfeldWeakTheta_of_psiWeakTheta` |
| `Stage3.theta_err_of_psi_theta`<br/>theorem, line 88 | \|ϑ x - x\| ≤ E + 2 * x ^ θ * Real.log x | hx : 1 ≤ x; hθlo : 1/2 ≤ θ; hψ : \|ψ x - x\| ≤ E | `ϑ`-error from `ψ`-error at `θ`, by Mathlib's `\|ψ − ϑ\| ≤ 2√x·log x` and `√x ≤ x^θ`. | `Stage3.theta_err_of_psi`, `Stage3.sqrt_le_rpow_theta` | `Stage3.schoenfeldWeakTheta_of_psiWeakTheta` |
| `Stage3.rpow_theta_sub_one_mul`<br/>theorem, line 101 | t ^ (θ - 1) * (t * Real.log t ^ 2) = t ^ θ * Real.log t ^ 2 | ht : 0 &lt; t | `t^(θ−1)` times the denominator is the `t^θ` envelope: `t^(θ−1)·(t·log²t) = t^θ·log²t` on `t &gt; 0`. | — | `Stage3.schoenfeldWeakTheta_of_psiWeakTheta` |
| `Stage3.schoenfeldWeakTheta_of_psiWeakTheta`<br/>theorem, line 111 | StmtSchoenfeldWeakTheta θ (3 * C + 13) (k - 1) (max (x₀ ^ 2) 9) (fun x =&gt; (Nat.primeCounting ⌊x⌋₊ : ℝ)) Li | hθlo : 1/2 ≤ θ; hk : 2 ≤ k; hx₀ : 2 ≤ x₀; hC : 0 ≤ C; h : StmtPsiWeakTheta θ C k x₀ | The transfer at `θ`. A ψ-side weak bound `(C, k, x₀)` at exponent `θ ≥ 1/2` with `k ≥ 2, x₀ ≥ 2` delivers the π-side weak bound at the same exponent with `C′ = 3C + 13`, exponent `k − 1`, floor `max(x₀², 9)`. The proof is `PsiToPi.schoenfeldWeak_of_psiWeak` with `x^θ` for `√x`. | `Stage3.Li`, `Stage3.abs_theta_sub_le_linear`, `Stage3.integrable_err_term`, `Stage3.one_add_log_four_le`, `Stage3.pi_sub_Li_eq`, `Stage3.StmtPsiWeakTheta`, `Stage3.StmtSchoenfeldWeakTheta`, `Stage3.integral_A_rpow_theta_le`, `Stage3.rpow_theta_sub_one_mul`, `Stage3.sqrt_le_rpow_theta`, `Stage3.theta_err_of_psi_theta` | `Stage3.schoenfeldWeakTheta_of_zeroFree`, `Stage3.schoenfeldWeak_of_psiWeak_half` |
| `Stage3.schoenfeldWeak_of_psiWeak_half`<br/>theorem, line 266 | StmtSchoenfeldWeak (3 * C + 13) (k - 1) (max (x₀ ^ 2) 9) (fun x =&gt; (Nat.primeCounting ⌊x⌋₊ : ℝ)) Li | hk : 2 ≤ k; hx₀ : 2 ≤ x₀; hC : 0 ≤ C; h : StmtPsiWeak C k x₀ | `PsiToPi.schoenfeldWeak_of_psiWeak` recovered through the dial. | `Stage3.Li`, `Stage3.StmtPsiWeak`, `Stage3.StmtSchoenfeldWeak`, `Stage3.schoenfeldWeakTheta_of_psiWeakTheta` | — |
| `Stage3.schoenfeldWeakTheta_of_zeroFree`<br/>theorem, line 280 | ∃ C &gt; 0, ∃ x₀ : ℝ, StmtSchoenfeldWeakTheta θ C 2 x₀ (fun x =&gt; (Nat.primeCounting ⌊x⌋₊ : ℝ)) Li | hθ : StmtZeroFreeRight θ; hθlo : 1/2 ≤ θ; hθhi : θ &lt; 1 | From a zero-free half-plane to the π-side bound. `StmtZeroFreeRight θ` for `θ ∈ [1/2, 1)` gives `\|π(⌊x⌋) − Li x\| ≤ C·x^θ·(log x)²` beyond some `x₀`. Constant `3C_ψ + 13` with `C_ψ` from `psi_weak_of_theta`. | `Stage3.StmtZeroFreeRight`, `Stage3.Li`, `Stage3.StmtPsiWeakTheta`, `Stage3.StmtSchoenfeldWeakTheta`, `Stage3.schoenfeldWeakTheta_of_psiWeakTheta`, `Stage3.psi_weak_of_theta` | `JointWindowDial.schoenfeldWeakTheta_of_window`, `Stage3.schoenfeldWeak_of_RH_half` |
| `Stage3.schoenfeldWeak_of_RH_half`<br/>theorem, line 293 | ∃ C &gt; 0, ∃ x₀ : ℝ, StmtSchoenfeldWeak C 2 x₀ (fun x =&gt; (Nat.primeCounting ⌊x⌋₊ : ℝ)) Li | hRH : RiemannHypothesis | The same under RH at `θ = 1/2`: `\|π − Li\| ≤ C·√x·(log x)²`. | `Stage3.zeroFreeRight_of_RH`, `Stage3.Li`, `Stage3.StmtSchoenfeldWeak`, `Stage3.schoenfeldWeakTheta_of_zeroFree` | — |
