# Depth as Time

The difference table read as a linear stability problem. Depth is the iteration index,
the operator has a growth factor per mode, and the base is a control parameter with a
critical value. Same objects as the Euler Factor Chain, reorganized.

Source lines cite scripts in `~/GitHub/Primebeat_081426/` or named results.
Nothing here is preregistered.

---

## A · The evolution

**A1.** Depth `d` is the iteration index. One step is `Δ` on the ladder `x = b^r`.
`definition`

**A2.** Each mode `x^ρ` is multiplied by `(1 − b^(−ρ))` per step.
`Euler Factor Chain A1 · measured O29_depth_residuals.py`

**A3.** Therefore the operator has a growth factor per mode, and depth is repeated
application of a fixed linear map.
`A1 + A2`

**A4.** Throughput: each row `r` ingests a fresh block of primes, `(b−1)·b^(r−1)` integers
of which `N(r)` are prime.
`O27_joint_dyadic_triadic_table.py`

---

## B · The spectrum of growth factors

**B1.** On `Re(ρ) = 1/2` the growth factor is `√(1 − 2b^(−1/2)cos(γ log b) + b^(−1))`,
bounded in `[1 − b^(−1/2), 1 + b^(−1/2)]`.
`Euler Factor Chain C2`

**B2.** The base state — the smooth trend, `ρ` real, `γ = 0` — sits at the **minimum** of
that spectrum.
`li−R gap decays at 3.53 per depth (b=2) against 3.414 predicted; 2.44 (b=3) against 2.366.
The underlying ratios are in results/O29_depth_residuals_run1.log (1.47565e7 → 4.14896e6 →
1.16868e6, ÷3.55 each); the rounded figures appear only in CONTEXT.md.`

**B3.** `γ₁` has growth factor 1.6784 in base 2, 98.3% of the ceiling 1.7071; and 1.5715 in
base 3, 99.6% of 1.5774.
`Euler Factor Chain D6`

**B4.** Therefore **the first Riemann zero is the fastest-growing mode of the difference
operator**, in both bases measured.
`B2 + B3`

**B5.** It does not generalize to the other zeros. Base 2 percentages of ceiling:
γ₂ 84.8, γ₃ 69.8, γ₄ 90.3, γ₅ 91.6, γ₆ 47.0 — γ₆ sits below the neutral point.
`computed from B1`

---

## C · The control parameter

**C1.** The relevant ratio is amplification over dissipation:
`|1 − b^(−1/2−iγ₁)| ÷ ((b−1)/b)`.
`B1 · the trend decays by (b−1)/b per step`

**C2.** Measured across eight bases:

```text
  b     trend      γ₁ gain     ratio
  2     0.5000     1.6784     3.3569
  3     0.6667     1.5715     2.3572
  4     0.7500     0.7177     0.9570
  5     0.8000     1.3600     1.7000
  6     0.8333     0.6045     0.7254
  7     0.8571     1.2984     1.5148
  8     0.8750     1.1976     1.3687
  9     0.8889     0.6978     0.7850
```

`trend gain (b−1)/b confirmed for all eight by O33_base_ladder_crossing.py`

**C3.** The critical value is **1**. Above it the oscillation eventually overtakes the base
state; below it, never.
`C1`

**C4.** Therefore `b = 4, 6, 9` are **subcritical** — no instability at any depth, at any `r`.
`C2 · ratios 0.957, 0.725, 0.785`

**C5.** Observed: crossing in `{2, 3}`, absent in `{4, 5, 6, 7, 8, 9}` across eight tables.
`O33`

**C6.** The absence at 5, 7, 8 is not evidence against C3 — their required depth exceeds
`r − 1` for every row, so a triangular support cannot reach it.
`O33 · required-depth slopes 1.52, 2.34, 3.31, all ≥ 1`

**C7.** C6 is a post-hoc account. The prediction actually made before the tables were read
was a `{4,6,9}` split with fixed crossing depths per base, and it **failed** — bases 5 and 7
are marked testable in the same artifact and never cross.
`O33 · results/base_ladder_crossing.json marks bases 5 and 7 both "testable" and
"reachable_on_triangular_support": false · see What-Didn't-Work A1–A4`

---

## D · Onset

**D1.** The crossing depth is where the amplified mode overtakes the base state — the
onset of instability.
`C1`

**D2.** It is not fixed per base. It grows linearly in `r`, because the base state runs as
`b^r` and the mode as `b^(r/2)`, so the gap to close grows.
`O33: turnaround at d=3 (r=8), d=6 (r=20), d=12 (r=32) for b=2`

**D3.** Measured slopes 0.3031 (b=2) and 0.7353 (b=3).
`O33`

---

## E · Saturation

**E1.** The operator is linear, but the observable — radius of convergence
`limsup |a_r|^(−1/r)` — is a nonlinear functional of the cells.
`Cauchy–Hadamard`

**E2.** Therefore the system can saturate despite linear dynamics.
`E1`

**E3.** It does. The table's radius migrates `0.5406 → 0.7537` with depth and arrives at
the residual's radius `b^(−1/2)`, which is itself flat across depth (0.7625 → 0.7577).
`O39_transform_radius.py`

**E4.** Therefore depth is **power iteration** on the mode spectrum: the dominant mode
wins exponentially and the radius converges to its value.
`E3 · same mechanism as power iteration converging to the top eigenvector`

**E5.** The attractor is the residual. The trend is the transient.
`E4`

**E6.** Arrival is at `d ≈ 13–14`. Whether the measured breakdown at `d = 13` is arrival
or coefficient exhaustion has not been separated.
`O39: breakdown onset d=13 (prime), d=10 (residual), never for the smooth control`

---

## F · Where the analogy fails

**F1.** There is no nonlinear feedback. Differencing is linear at every order, so nothing
arrests a growing mode except the gain ceiling `1 + b^(−1/2)`.
`B1`

**F2.** In a dissipative structure the fastest mode grows until nonlinearity caps it, and
that saturation selects the pattern. Here the saturation of E3 is in the *observable*,
not in the dynamics.
`E1 + F1`

**F3.** Therefore the mode selection of B4 is kinematic, not the outcome of a competition.
`F2`

---

## G · Not established

**G1.** The dissipative-structure reading is a reframing. It reorganizes measured
quantities; it has not predicted anything not already measured, except C4 restated.
`open`

**G2.** D3's slope law was derived after seeing the data — 6% and 15% agreement, no
out-of-sample test.
`O33`

**G3.** E6's ambiguity is unresolved.
`O39`

**G4.** Whether an analogue of nonlinear saturation exists in this object is unasked.
`open`
