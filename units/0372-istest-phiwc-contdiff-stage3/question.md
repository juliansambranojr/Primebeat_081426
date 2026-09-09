> Source: session transcript, 2026-09-09, after unit 0371

> Go

From `lean_stage3/Stage3/WeilPowerAssembly.lean`, the new helper and the now-clean pin:

```
theorem phiW_contDiff_one {h γ : ℝ} (hh : 0 < h) {m : ℕ} (hm : 1 ≤ m) :
    ContDiff ℝ 1 (WeilPowerBackground.phiW h γ m)
```

```
theorem isTest_phiWC {h : ℝ} (hh : 0 < h) (γ : ℝ) {m : ℕ} (hm : 1 ≤ m) :
    IsTest (2 * h) (WeilPowerBackground.phiWC h γ m)
```
