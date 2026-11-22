# Bridge worksheet — the prime side of Weil's form

The statement this worksheet targets, in Stage 3's terms: for a test function
of `WeilDetect.IsTest`, `WeilDetect.zeroForm G` equals a prime side. Unit 0379
fixed the statement and checked it numerically; unit 0381 proved it in the
third tree, `lean_bridge/`, against zeta23's explicit formula. Objects are
read at the trees, never defined here (`DESIGN.md` § 0).

### 1 The zero-set lemma and the bridge leaf — PROVED (unit 0382: `WeilBridgeLeaf.order_eq_toNat`,
`zeroes_rect_strip`, `zeroForm_eq_strip`, `zeroForm_eq_primeSide`)

Objects.   `WeilDetect.zeroForm G = riemannZeta.zeroes_sum (Ioo 0 1) univ
           (fun ρ ↦ laplace G (−ρ) · laplace G (−(1−ρ)))`, upstream's sum over
           `riemannZeta.zeroes_rect (Ioo 0 1) univ` weighted by
           `riemannZeta.order ρ = (meromorphicOrderAt riemannZeta ρ).untopD 0`.
           The third tree's `Bridge.StmtWeilBridge` sums over
           `{ρ | riemannZeta ρ = 0 ∧ 0 < ρ.re ∧ ρ.re < 1}` weighted by
           `(analyticOrderAt riemannZeta ρ).toNat`. No size: this block is an
           identity.
Sizes.     none. Lost factor: none; nothing is bounded.
Regime.    Z1 `ρ ≠ 1` at every point of the strip (`ρ.re < 1`), so `riemannZeta`
              is analytic there.
Defs.      Five, each a character copy of the third tree's and gated by
           `utilities/check_weld.py`: `tiltF`, `ft`, `kOfM`, `primeSideM`,
           `StmtWeilBridge`. Written with fully qualified names so the text is
           the same under either tree's `open` lines.
Theorems.  `theorem order_eq_toNat {ρ : ℂ} (hρ : ρ ≠ 1) :
               riemannZeta.order ρ = (((analyticOrderAt riemannZeta ρ).toNat : ℕ) : ℤ)`
             (analytic at `ρ`, so `AnalyticAt.meromorphicOrderAt_eq`; then the
             two cases of the order. At order `⊤` both sides are `0`, so no
             non-vanishing is needed.)
           `theorem zeroes_rect_strip :
               riemannZeta.zeroes_rect (Set.Ioo 0 1) Set.univ
                 = {ρ : ℂ | riemannZeta ρ = 0 ∧ 0 < ρ.re ∧ ρ.re < 1}`
           `theorem zeroForm_eq_strip (G : ℝ → ℂ) :
               zeroForm G = ∑' ρ : {ρ : ℂ | riemannZeta ρ = 0 ∧ 0 < ρ.re ∧ ρ.re < 1},
                 (((analyticOrderAt riemannZeta (ρ : ℂ)).toNat : ℕ) : ℂ)
                   * (laplace G (-(ρ : ℂ)) * laplace G (-(1 - (ρ : ℂ))))`
             (`tsum_congr_set_coe` over `zeroes_rect_strip`, then termwise
             `order_eq_toNat` with Z1.)
           `theorem zeroForm_eq_primeSide (h : StmtWeilBridge) {L : ℝ} {G : ℝ → ℂ}
               (hG : IsTest L G) : zeroForm G = primeSideM (kOfM G)`
Composes.  `WeilDetect.zeroForm`, `laplace`, `IsTest`; upstream
           `riemannZeta.zeroes_sum`, `zeroes_rect`, `zeroes`, `order`
           (`PrimeNumberTheoremAnd/IEANTN/ZetaDefinitions.lean`). Mathlib,
           grepped at the pin: `differentiableAt_riemannZeta`,
           `DifferentiableOn.analyticAt`, `AnalyticAt.meromorphicOrderAt_eq`,
           `tsum_congr_set_coe`, `ENat.toNat_coe`, `ENat.toNat_top`.
Module.    `Stage3/WeilBridgeLeaf.lean`, namespace `WeilBridgeLeaf`, importing
           `Stage3.WeilDetect`. Pins: `order_eq_toNat`, `zeroes_rect_strip`,
           `zeroForm_eq_strip`, `zeroForm_eq_primeSide`.
Open.      none. The leaf `StmtWeilBridge` is discharged in the third tree by
           `Bridge.stmtWeilBridge_holds`; the join is by statement identity.
