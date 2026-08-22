# Euler Factor Chain

Statement → therefore → statement. Every link carries its source: a script run in
`~/GitHub/Primebeat_081426/`, or a named theorem. Blocks are independent and can be
reordered. Nothing here is a verdict; nothing here was preregistered.

Notation: ladder `x = b^r`, backward difference `Δ`, depth `d`, stencil order `N = d+1`,
zeta zero `ρ = σ + iγ`, first zero `γ₁ = 14.134725141734693`.

---

## A · The symbol

**A1.** On the ladder `x = b^r`, the backward difference applied to the mode `x^ρ` returns
`(1 − b^(−ρ))·x^ρ`.
`derivation, one line · measured O29_depth_residuals.py`

**A2.** The Euler product is `ζ(s) = Π_p (1 − p^(−s))^(−1)`.
`Euler, 1737`

**A3.** Therefore `1 − b^(−s)` is the reciprocal Euler factor at `b`, and `Δ` on the
`b`-ladder is multiplication by it.
`A1 + A2`

**A4.** Therefore `d`-fold differencing has symbol `(1 − b^(−s))^(d+1)`.
`A3 · measured O33_base_ladder_crossing.py, trend gain (b−1)/b confirmed for b = 2…9`

---

## B · The Weil weight

**B1.** Let `ĝ(s) = (1 − b^(−s))^N`. Then `h(s) = ĝ(s)·ĝ(1−s) = (1 − b^(−s))^N (1 − b^(s−1))^N`.
`O37_weil_form_on_stencil.py`

**B2.** `h(s) = h(1−s)`; `h(0) = h(1) = 0`; `h ≥ 0` on `Re(s) = 1/2`.
`O37 verified: H(0.3) = H(0.7) = 1.020359521e−8; H(1/2 + 14.1347i) real and positive`

**B3.** Therefore `h` is an admissible Weil test function.
`Weil 1952, positivity criterion · Connes arXiv:2602.04022 §4.1`

**B4.** On `Re(ρ) = 1/2`, `|h(ρ)| = |1 − b^(−ρ)|^(2N)`.
`O37 verified to 8 digits at three zeros: 15931.825 = 15931.825 (γ₁), 2003.5695 (γ₂), 130.93684 (γ₃)`

**B5.** Therefore the depth-transfer gain of A1 and the Weil weight on each zero are the
same quantity.
`A1 + B4`

**B6.** Weil's explicit formula balances on it: arithmetic `2644.2756560191`, spectral
`2644.2741566957`, relative `5.67e−7`.
`O37_weil_form_balance.py · normalization calibrated on Gaussians to 1e−18 by O36_weil_calibration.py`

**B7.** The unmollified stencil is supported on `{b^n}`, so its prime sum collapses to
`p = b` alone; mollified, 25 of 36 primes in the window contribute.
`O37 · mollifier must be centered at s = 1/2 or B2 fails`

---

## C · The bound

**C1.** On `Re(ρ) = 1/2`, `|1 − b^(−ρ)|² = 1 − 2b^(−1/2)·cos(γ log b) + b^(−1)`.
`algebra`

**C2.** Therefore the gain depends on `γ` only through `cos(γ log b)`, is periodic with
period `2π/log b`, and is bounded in `[1 − b^(−1/2), 1 + b^(−1/2)]`.
`C1 · b=2 → [0.2929, 1.7071]; b=3 → [0.4226, 1.5774] · Chain.gain_sq_periodic ·
Chain.C2_floor_attained · Chain.C2_ceiling_attained — both ends attained, not
merely bounded`

**C3.** Therefore no mode grows or decays without bound under depth.
`C2`

---

## D · The winding

**D1.** The floor of C2 is at `γ log b ≡ 0 (mod 2π)`; the ceiling at `γ log b ≡ π (mod 2π)`.
At the ceiling `b^(−ρ)` is real negative and the gain is real.
`C1 · Chain.gain_sq_at_floor · Chain.gain_sq_at_ceiling`

**D2.** The smooth term has `ρ` real, so `γ = 0`, so it sits exactly at the floor.
`O29: li−R gap decays 3.53 per depth (b=2) against (1−b^(−1/2))^(−1) = 3.414 predicted;
2.44 (b=3) against 2.366 · Chain.C2_floor_attained`

**D3.** Therefore differencing dissipates the smooth part maximally while amplifying
modes near the ceiling.
`D1 + D2 · Chain.ceiling_dominates_floor · measured O49: the residual table's own
gain sits at 97.68% ± 2.91% of the ceiling across twelve bases, entered by depth
1 or 2 — lab_notebook_2 entry 75`

**D4.** The bases placing `γ` exactly at the ceiling are `b = exp(π(2k+1)/γ)`.
For `γ₁`: `1.2489, 1.948, 3.039, 4.741, 7.395 …`
`D1 · Chain.ceiling_base`

**D5.** `b = 2` lies 2.7% from 1.948 (201.3°, 1.559 turns per rung);
`b = 3` lies 1.3% from 3.039 (169.7°, 2.471 turns per rung).
`D4`

**D6.** Therefore base 2 reaches 98.3% of its ceiling for `γ₁` and base 3 reaches 99.6%.
`D5 · gains 1.6784 of 1.7071, and 1.5715 of 1.5774`

**D7.** `b = 4, 6, 9` land at 42.6°, 11.0°, 339.4° — near the floor.
`D1`

**D8.** Therefore bases 2 and 3 cross from trend-dominated to oscillation-dominated,
and 4, 6, 9 never do.
`O33: crossing observed in {2,3}, absent in {4,5,6,7,8,9} across eight tables`

---

## E · Position, not count

**E1.** `Δ^(d+1)` annihilates every polynomial of degree ≤ `d`; the stencil weights
`(−1)^k C(d+1,k)` balance at every moment up to the `d`-th.
`Newton · for N = 7 the positive and negative weights each sum to 64`

**E2.** Therefore a uniform change to `π` below the stencil leaves the cell unchanged.
`O30_silence_scaffold_primes.py: zeroing the counts of 2, 3, 5 leaves (8,3) and (20,6)
exactly 0`

**E3.** Excising integers from the line shifts every block boundary, changing the eight
`π` values non-uniformly.
`O31_excise_scaffold_primes.py: both deep zeros destroyed; (20,6) reads 70 (three integers
removed from 4×10⁶)`

**E4.** Therefore a difference cell is blind to how many primes lie below it and sensitive
to where they sit.
`E2 + E3`

**E5.** The detected frequencies survive both operations unchanged.
`O32_excised_gamma_check.py: γ₁,γ₂,γ₃ identical to baseline under excise-A, within one
frequency bin under excise-B`

**E6.** Therefore the exact zeros are positional facts and the frequencies are not.
`E4 + E5`

---

## F · The residual

**F1.** `π(x) = R(x) − Σ_ρ R(x^ρ) + …`
`Riemann 1859 · von Mangoldt 1895`

**F2.** Differenced on the ladder, the residual is reproduced from the zeros alone at
94% / 92% / 80% for `d = 0 / 3 / 6` at `r = 20`, nothing fitted.
`O34_zeta_residual_model.py, 200 zero pairs, via li(x^ρ) = Ei(ρ log x)`

**F3.** Convergence is non-monotone: 90% at 50 pairs, 80% at 200, 86% at 500.
`O34`

**F4.** Past `d ≈ 12` the truncated sum does not converge at all — it changes sign with
zero count.
`O35_nearmiss_residuals.py: (25,21) reads −296433 at 200 pairs and +27793 at 600`

**F5.** Because the depth gain spreads over `((1+b^(−1/2))/(1−b^(−1/2)))^(d+1) = 5.827^(d+1)`,
i.e. `(d+1)×0.765` decades for `b = 2` — 11.5 decades at `d = 14`.
`C2`

**F6.** Therefore the truncated explicit formula is not an instrument for deep cells.
`F4 + F5`

---

## G · The transform

**G1.** `G_d(z) = Σ_r cell(r,d)·z^r` has radius `b^(−σ)` for coefficients growing as `b^(σr)`.
`Cauchy–Hadamard`

**G2.** The smooth part grows as `x¹` → radius `b^(−1)`. The residual as `x^(1/2)` →
radius `b^(−1/2)`.
`O39_transform_radius.py: smooth control 0.5330 → 0.5095 across depth 0–43;
residual flat, 0.7625 → 0.7577`

**G3.** The roots of the partial sums of any power series accumulate on its circle of
convergence.
`Jentzsch 1914`

**G4.** Therefore the circle is generic and carries no information; only the radius does,
and the smooth model is the control that separates them.
`G3 · O39: smooth control never breaks down to d = 43`

**G5.** The prime table's own radius migrates `0.5406 → 0.7537` with depth, arriving at
the residual's.
`O39, b = 2, r ≤ 45`

**G6.** Therefore depth is power iteration on the mode spectrum, and the residual is its
fixed point.
`G5 · the observable is nonlinear in the cells though the operator is linear`

**G7.** Between the two radii lies an annulus `b^(−1) < |z| < b^(−1/2)`, conformal modulus
`(log b)/4π = 0.05515890` at `b = 2`.
`O39 · Transform.annulus_modulus`

**G7′.** That annulus has ratio `√b`, so it is **half a fundamental domain** of the
torus `ℂ* / b^ℤ`, whose modulus is `(log b)/2π`. The lattice has two generators:
`s ↦ s + 2πi/log b`, which fixes `z` and is why the strip becomes an annulus, and
`s ↦ s + 1`, which sends `z ↦ z/b` and is what closes it. At `b = 2` the second
identifies `|z| = 0.5 ~ 1 ~ 2 ~ 4 …`.
`G7 · Transform.zmap_period · Transform.zmap_shift`

**G7″.** And `s ↦ 1 − s` becomes `z ↦ b^(−1)/z`, inversion in the circle
`|z| = b^(−1/2)` — the critical line is that inversion's fixed circle. Same fact as
B2a, read in `z`.
`Transform.zmap_functional_equation · Transform.norm_zmap_critical`

**G8.** `RH ⟺ residual = O(x^(1/2+ε)) ∀ε > 0 ⟺` outer radius `= b^(−1/2) ⟺` the annulus has
maximal modulus.
`equivalent restatement of the abscissa-of-convergence criterion; of identical difficulty`

**G9.** Infinitely many zeros lie on `Re(s) = 1/2`, so `σ ≥ 1/2` and the modulus is bounded
above.
`Hardy 1914`

**G10.** `M(x) = O(x^(1/2))` is false, so the `ε` cannot be removed and `1/2` is a supremum,
not a maximum.
`Odlyzko & te Riele 1985`

---

## H · Discrete to continuous

**H1.** Sampling `log x` at step `log b` gives Nyquist frequency `π/log b`.
`Nyquist–Shannon`

**H2.** `π/log 2 = 4.532 < γ₁ = 14.1347`.
`H1`

**H3.** Therefore the dyadic ladder aliases `γ₁` rather than resolving it.
`O18_joint_multiplicative_ladder.py: eight peaks of identical height at spacing 2π/log 2`

**H4.** Resolving `γ₁` requires `b < exp(π/γ₁) = 1.2489` — which is D4 at `k = 0`.
`H1 + D4`

**H5.** The smallest integer base is 2.

**H6.** Therefore no integer ladder resolves `γ₁` directly.
`H4 + H5`

**H7.** As `b → 1`: `(log b)/4π → 0`, `2π/log b → ∞`, and `(1 − b^(−ρ)) → ρ·log b`.
`limits`

**H8.** Therefore the continuum limit is `b = 1`, differencing becomes differentiation
there, and `(log b)/4π` measures the distance from it.
`H7 + G7 · b=2 → 0.05516, b=3 → 0.08742, threshold b=1.2489 → 0.01769`

---

## I · The complementary pair

**I1.** `prime(r,d) + composite(r,d) = (b−1)^(d+1)·b^(r−1−d)`, exact at every cell in every
base.
`O27_joint_dyadic_triadic_table.py · block holds (b−1)·b^(r−1) slots, each prime or not`

**I2.** The geometric term appears with the same coefficient in the actual value and in the
smooth model, so it cancels on subtraction.
`I1`

**I3.** Therefore `prime_residual + composite_residual = 0` at every cell, exactly.
`I2 · row 20, b=2: −24.886 / −133.761 / −453.424 against +24.886 / +133.761 / +453.424`

**I4.** Therefore neither arm is the signal; all structure lies in how a fixed total divides.
`I3`

**I5.** Where the prime arm vanishes, the ratio `composite/prime` has a pole.
`I1 · (2,1) → 1, (4,1) → 4, (8,3) → 16, (20,6) → 8192`

---

## J · Not established

**J1.** The crossing-depth slope `ln b / (2 ln ratio)` was derived after seeing the data.
Fits `b = 2` to 6%, `b = 3` to 15%. No out-of-sample test.
`O33`

**J2.** The non-integer bases of D4 — 1.2489, 1.948, 3.039 — are constructible and have
never been built. D6 predicts their gains before any table exists.
`untested`

**J3.** Whether A3, B5 and D4 are new is not established. No literature search has been
performed. Each is one line from standard facts, which is the profile of folklore.
`open`

**J4.** The mollifier of B7 is not canonical; `W` and `k` are free and the numbers of B6
move with them. No parameter-independent statement has been made.
`O37`

**J5.** Nothing above tests RH. G8 is an equivalent restatement; B6 presupposes the zeros
lie on the line.
`stated`
