> Source: session transcript, 2026-11-24

> Yes



From `lean_stage3/Stage3/LevinsonSize.lean`, the pinned statements:

```
theorem norm_G_sub_one_le {c : ℝ} (hc0 : 0 ≤ c) (hc1 : c ≤ 1) {s : ℂ} (hs : s.re = 3) :
    ‖riemannZeta s + c * deriv riemannZeta s - 1‖ ≤ Real.pi ^ 2 / 6 - 1 :=
```

```
theorem re_G_pos {c : ℝ} (hc0 : 0 ≤ c) (hc1 : c ≤ 1) (t : ℝ) :
    0 < (riemannZeta (3 + t * I) + c * deriv riemannZeta (3 + t * I)).re :=
```

```
theorem right_edge_le {c a b : ℝ} (hc0 : 0 ≤ c) (hc1 : c ≤ 1) (hab : a ≤ b) :
    |(∫ t in a..b, logDeriv (fun s => riemannZeta s + c * deriv riemannZeta s)
      (3 + t * I)).re| ≤ Real.pi :=
```

```
theorem gamma_part_eq (a b : ℝ) :
    (∫ t in a..b, logDeriv Gammaℝ (1/2 + t * I)).re =
      Stage3.phaseTheta b - Stage3.phaseTheta a :=
```

```
theorem gamma_part_eq_count (a b : ℝ) :
    (∫ t in a..b, logDeriv Gammaℝ (1/2 + t * I)).re =
      Real.pi * (riemannZeta.N b - riemannZeta.N a)
        - Real.pi * (Stage3.argS b - Stage3.argS a) :=
```

```
theorem gamma_part_count_le {a b : ℝ} (ha : 2 ≤ a) (hab : a ≤ b) :
    |(∫ t in a..b, logDeriv Gammaℝ (1/2 + t * I)).re
      - Real.pi * (riemannZeta.N b - riemannZeta.N a)|
      ≤ Real.pi * (30 * Real.log b + 1200) :=
```

```
theorem gamma_part_count_le_gt_two {a b : ℝ} (ha : 2 < a) (hab : a ≤ b) :
    |(∫ t in a..b, logDeriv Gammaℝ (1/2 + t * I)).re
      - Real.pi * (riemannZeta.N b - riemannZeta.N a)|
      ≤ Real.pi * (30 * Real.log b + 150) :=
```

