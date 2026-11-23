# What `Bridge.stmtWeilBridge_holds` rests on

[`Bridge.stmtWeilBridge_holds`](../lean_bridge/WeilBridge.md#Bridge-stmtWeilBridge_holds) in `lean_bridge/Bridge/WeilBridge.lean`, line 250.

**Why.** The bridge holds.

**Proves**

```lean
StmtWeilBridge
```

Behind it: 15 theorems and 9 definitions in 1 file. Every one is listed below; Lean recorded each step.

## The files it passes through

```mermaid
flowchart LR
  f0["<b>WeilBridge</b><br/>stmtWeilBridge_holds"]:::end_
  classDef cnt fill:#dff5ec,stroke:#17694a,color:#111
  classDef shp fill:#f1ecfb,stroke:#5b3fa0,color:#111
  classDef rh fill:#ffe5e5,stroke:#c22,color:#111,stroke-width:2px
  classDef thm fill:#eef4ff,stroke:#335,color:#111
  classDef end_ fill:#e7f7e7,stroke:#2a7,color:#111,stroke-width:2px
  classDef lone fill:#fff,stroke:#999,color:#111,stroke-dasharray:4 3
  classDef bad fill:#ffe5e5,stroke:#c22,color:#111,stroke-width:2px
  classDef ext fill:#fff8e1,stroke:#b80,color:#111
```

An arrow A → B reads "B uses something proved or defined in A"; indirect arrows are left out. Green: the theorem itself. Yellow: a file in the other tree. The number is how many of that file's declarations are on the way.

## Every declaration on the way

Files in dependency order. ★ marks what the theorem's own proof uses directly.

### [`WeilBridge`](../lean_bridge/WeilBridge.md) — 24

- ★ [`Bridge.laplace`](../lean_bridge/WeilBridge.md#Bridge-laplace) — *def*
- ★ [`Bridge.IsTest`](../lean_bridge/WeilBridge.md#Bridge-IsTest) — *def*
- [`Bridge.tiltF`](../lean_bridge/WeilBridge.md#Bridge-tiltF) — *def*
- ★ [`Bridge.kOf`](../lean_bridge/WeilBridge.md#Bridge-kOf) — *def*
- ★ [`Bridge.primeSide`](../lean_bridge/WeilBridge.md#Bridge-primeSide) — *def*
- [`Bridge.primeSide_eq`](../lean_bridge/WeilBridge.md#Bridge-primeSide_eq) — `` primeSide k = literatureRHS k ``
- [`Bridge.tiltF_im`](../lean_bridge/WeilBridge.md#Bridge-tiltF_im) — `` (tiltF G u).im = 0 ``
- [`Bridge.contDiff_tiltF`](../lean_bridge/WeilBridge.md#Bridge-contDiff_tiltF) — `` ContDiff ℝ 1 (tiltF G) ``
- [`Bridge.hasCompactSupport_tiltF`](../lean_bridge/WeilBridge.md#Bridge-hasCompactSupport_tiltF) — `` HasCompactSupport (tiltF G) ``
- [`Bridge.laplace_neg_eq`](../lean_bridge/WeilBridge.md#Bridge-laplace_neg_eq) — `` laplace G (-ρ) = paperFT (tiltF G) (gammaOf ρ) ``
- [`Bridge.laplace_reflect_eq`](../lean_bridge/WeilBridge.md#Bridge-laplace_reflect_eq) — `` laplace G (-(1 - ρ)) = paperFT (tiltF G) (-gammaOf ρ) ``
- [`Bridge.conj_paperFT_conj`](../lean_bridge/WeilBridge.md#Bridge-conj_paperFT_conj) — `` conj (paperFT F (conj z)) = paperFT F (-z) ``
- [`Bridge.contDiff_two_convolution`](../lean_bridge/WeilBridge.md#Bridge-contDiff_two_convolution) — `` ContDiff ℝ 2 (f ⋆[ContinuousLinearMap.mul ℝ ℂ, volume] h) ``
- [`Bridge.contDiff_tilde`](../lean_bridge/WeilBridge.md#Bridge-contDiff_tilde) — `` ContDiff ℝ 1 (tilde g) ``
- [`Bridge.contDiff_kOf`](../lean_bridge/WeilBridge.md#Bridge-contDiff_kOf) — `` ContDiff ℝ 2 (kOf G) ``
- [`Bridge.hasCompactSupport_kOf`](../lean_bridge/WeilBridge.md#Bridge-hasCompactSupport_kOf) — `` HasCompactSupport (kOf G) ``
- [`Bridge.paperFT_kOf`](../lean_bridge/WeilBridge.md#Bridge-paperFT_kOf) — `` paperFT (kOf G) (gammaOf ρ) = laplace G (-ρ) * laplace G (-(1 - ρ)) ``
- ★ [`Bridge.weil_bridge`](../lean_bridge/WeilBridge.md#Bridge-weil_bridge) — `` Summable (fun ρ : {ρ : ℂ | riemannZeta ρ = 0 ∧ 0 < ρ.re ∧ ρ.re < 1} => (((analyticOrderAt riemannZeta (ρ : ℂ)).toNat : ℕ) : ℂ) * (laplace G (-(ρ : ℂ)) * laplace… ``
- [`Bridge.ft`](../lean_bridge/WeilBridge.md#Bridge-ft) — *def*
- ★ [`Bridge.kOfM`](../lean_bridge/WeilBridge.md#Bridge-kOfM) — *def*
- ★ [`Bridge.primeSideM`](../lean_bridge/WeilBridge.md#Bridge-primeSideM) — *def*
- ★ [`Bridge.StmtWeilBridge`](../lean_bridge/WeilBridge.md#Bridge-StmtWeilBridge) — *def*
- ★ [`Bridge.kOfM_eq`](../lean_bridge/WeilBridge.md#Bridge-kOfM_eq) — `` kOfM G = kOf G ``
- ★ [`Bridge.primeSideM_eq`](../lean_bridge/WeilBridge.md#Bridge-primeSideM_eq) — `` primeSideM k = primeSide k ``

