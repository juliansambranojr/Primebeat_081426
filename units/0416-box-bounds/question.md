> Source: session transcript, 2026-11-22, after unit 0415

> E7

From the assistant's message before it: "**Build E7**, starting with E7a and E7b (short), then E7c and E7d."

From `lean_stage3/Stage3/BoxBounds.lean`, the pinned statements:

```
theorem sq_zeta_box {s : ℂ} (h1 : -1 / 2 ≤ s.re) (h2 : s.re ≤ 4) (ht : |s.im| ≤ 2) :
    ‖(s - 1) ^ 2 * riemannZeta s‖ ≤ 135 := by
```

```
theorem sq_zeta_band_explicit {s : ℂ} (hσ1 : -1 / 2 ≤ s.re) (hσ2 : s.re ≤ 4) :
    ‖(s - 1) ^ 2 * riemannZeta s‖ ≤ 135 * (2 + |s.im|) ^ 4 := by
```

```
theorem zeta_ratio_ge : 2 / 7 ≤ ‖riemannZeta 3 / riemannZeta (3 / 2)‖ := by
```

