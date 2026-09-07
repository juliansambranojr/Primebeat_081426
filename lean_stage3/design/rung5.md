# Rung 5 worksheet

The derivations behind units 0326–0335, written down on 2026-09-06 while
they were still in the session's window, so that no module has to re-derive
them and no compaction loses them. Every section is either PROVED (names a
Lean theorem) or SKETCH (not yet in Lean; the numbers are the plan). A
module's unit names the section it was built from in its `values.tsv` row
`design`.

Notation. `h` support, the window lives on `[−h, h]`. `γ` the tuning
height. `m` the smoothing order, `λ = (m+1)/h`. A zero `ρ = 1/2 + ε' + iγ'`
is read by the window at `w = (ε' + i(γ' − γ))h`, so `Re w = ε'h`,
`Im w = Δh` with `Δ = γ' − γ`. The target is the zero the window is tuned
to: `Δ = 0`, real part `1/2 + ε`, read at `w = s = εh` real.

## 1. Sign structure — PROVED

`WeilOffLine.term_eq_neg_sq` (old window), `WeilPowerBackground.term_eq_neg_sq`
(switched window). For an odd real envelope the transform is odd, and every
term of the zero form is

    term(ρ) = −what(ρ − 1/2)²,    Re term = (Im g)² − (Re g)²,  g = what(ρ − 1/2).

On the line `g` is purely imaginary, so the term is `+(Im g)² ≥ 0`. Off the
line the term is negative exactly when `g` is more real than imaginary. The
whole zero form at the window is `−Σ_ρ what(ρ − 1/2)²·ord ρ`. The even
envelope gives `+what²`, positive at the target: that is why the envelope
must be odd.

## 2. The finding: far zeros with larger real part — SKETCH, decided (unit 0327)

Old window `P = cos²(πx/2)` with odd factor `x`. Its transform decays in
height like `1/|w|³` (three integrations by parts; the second-derivative
boundary term survives) and grows in the real part like `cosh(Re w)`. A
zero at `(ε', Δ)` has term size about `cosh(ε'h)²/(hΔ)^{2k}` for a
polynomial `k`. The target's main term must beat the on-line background,
which is `~h²·poly(γ)` (unit 0324), and the main term is `(h/2)²Σ(εh)²`
with `Σ(s) ≥ s/24` only linear: so `εh` must be large, where `Σ(εh)` is
exponential. Then any zero with `ε' > ε`, at any height, beats the target
for large `h`: exponential in the real part against polynomial in the
height. No explicit `L(ε, T)` by this window. Bombieri's support has no
formula for the same reason.

Cluster: zeros with the same real part and `Δ ≲ ε` have terms of either
sign, phase `2Δh`. Smaller obstruction.

Fix: smoothness growing with the support, envelope `P^m`, `m ~ λh`. A
truncated Gaussian.

## 3. The switched window — PROVED

Odd factor changed from `x` to `sin(πx)` (unit 0330): `q m x = sin(πx)P(x)^m
= −(2/((m+1)π))·(c^{2m+2})'`, `c = cos(πx/2)`, so one integration by parts
gives the transform through the even one, no derivative:

    S m w = 2w·K (m+1) w / ((m+1)π)                 (WeilOddPower.S_eq)
    K m w = ∫₋₁¹ P^m e^{wx} dx,
    K m w · w·∏_{j=1}^{m}(w² + π²j²) = 2π^{2m}(2m)!/4^m · sinh w     (WeilPower.K_mul_Q)
    S m w · ∏_{j=1}^{m+1}(w² + π²j²) = cS m · sinh w,  cS m = 2π^{2m+1}(2m+1)!/4^m
                                                          (WeilOddPower.S_mul_QS)
    what h γ m z = (h/2)[S m ((z+iγ)h) + S m ((z−iγ)h)]  (WeilOddPower.what_eq)

`K` by a recurrence: `(c^n)'' = n(n−1)θ²c^{n−2} − n²θ²c^n`, `θ = π/2`, two
integrations by parts, boundary terms zero; `K (m+1)·(w² + π²(m+1)²) =
(m+1)(2m+1)π²/2·K m` (WeilPower.K_succ). Checked at `m = 1`:
`π²·sinh w/(w(w² + π²))`, unit 0328's hand check.

Test function `φ = 𝟙_{[−h,h]}·W·e^{−u/2}`, `laplace φ z = what(−z − 1/2)`
(WeilPowerBackground.laplace_phiW). On the line `S m (it) = i·PsiW m t`,
`PsiW m t = ∫ q sin(tx)`, `|PsiW| ≤ 2`, on-line term ≤ `4h²`
(online_term_le_near); far: `|PsiW m t| ≤ cS m (2/t²)^{m+1}` for
`t² ≥ 2π²(m+1)²` (PsiW_le_far).

## 4. Crude bounds off the axis — PROVED (unit 0331)

Each factor `w² + a² = (w − ia)(w + ia)` has norm `≥ (Re w)²`, so off the
imaginary axis the product is nonzero and

    ‖S m w‖ ≤ cS m · cosh(Re w) / ‖QS m w‖            (norm_S_le)
    ‖S m w‖ ≤ cS m · cosh(Re w) · (2/(Im w)²)^{m+1}   when 2((Re w)² + π²(m+1)²) ≤ (Im w)²
                                                       (norm_S_le_far)
    Re S m s ≥ cS m e^s / (4(s² + π²(m+1)²)^{m+1})     for s ≥ 1  (S_real_ge)

THE LOSS. `S_real_ge` compares `Ps m s = ∏(s² + π²j²)` with its largest
factor to the `m+1`: `Ps ≈ π^{2m+2}((m+1)!)²·e^{s²/(π²m)}` against
`(π²(m+1)²)^{m+1}`, a loss of `((m+1)!/(m+1)^{m+1})² ≈ e^{−2m}`. With
`m ~ h` that is `e^{−2h}` against a main term whose rate is `ε²/(π²λ)`:
the crude lower bound is useless for the assembly. Fine for far zeros
(§6), useless for the target.

## 5. The Gaussian regime — PROVED (unit 0333); constants sharpened (unit 0346)

Two factors were lost between the upper bound at a zero and the lower
bound at the target (found in unit 0345): the constant `cS m / D m` was
bracketed by `4/(π(m+1)(2m+3))` below and `4/(π(m+1))` above, a factor
`2m+3`; the tail sum `Σ_{j≥m+2} 1/j²` was bracketed by `(m+2)/(2m+3)²` below
and `1/(m+1)` above, a factor near `4` in the rate, so the target's proven
growth was a quarter of a competitor's. `WeilPowerSharp` (unit 0346) keeps
the constant exact on both sides and uses the telescoping sum
`1/(j+1)² ≥ 1/((j+1)(j+2))`: `S_real_ge_sharp` has rate `s²/(π²(m+2))`, and
`compare_sharp` reads `‖S m w‖ ≤ (‖w‖/s)·exp((Re w² − s²)/(π²(m+1)) +
s²/(π²(m+1)(m+2)) + quartics)·Re S m s`, prefactor `‖w‖/s`. The `neg` case
(`Re w² ≤ 0`) still carries the old exponent.


Euler: `sinh w = w·∏_{j≥1}(1 + w²/(π²j²))` (euler_sinh, from
`Complex.tendsto_euler_sin_prod` at `iw/π`). The closed form's head product
cancels the head of Euler's product:

    S m w = (cS m / D m)·w·∏_{j≥m+2}(1 + w²/(π²j²)),   D m = π^{2m+2}((m+1)!)²,
    cS m / D m = centralBinom(m+1)/(π(m+1)4^m) ∈ [4/(π(m+1)(2m+3)), 4/(π(m+1))].

Tail control, factor by factor, valid when every tail argument
`x_j = w²/(π²(j+1)²)` has `‖x_j‖ ≤ 1/2`, i.e. `‖w‖² ≤ π²(m+2)²/2`:

    ‖1 + x‖ ≤ exp(Re x + ‖x‖²),      exp(x − x²) ≤ 1 + x  (real x ∈ [0, 1/2]),

both from `Complex.norm_log_one_add_sub_self_le`. Tail sums:
`Σ_{j≥m+2} 1/j² ≤ 1/(m+1)`; `Σ_{j=m+2}^{2m+3} 1/j² ≥ (m+2)/(2m+3)²`;
`Σ 1/j⁴ ≤ 1/(m+1)³`. Hence

    ‖S m w‖ ≤ 4/(π(m+1)) · ‖w‖ · exp( Re(w²)/(π²(m+1)) + ‖w‖⁴/(π⁴(m+1)³) )        Re(w²) ≥ 0
    ‖S m w‖ ≤ 4/(π(m+1)) · ‖w‖ · exp( Re(w²)(m+2)/(π²(2m+3)²) + ‖w‖⁴/(π⁴(m+1)³) )  Re(w²) ≤ 0
    Re S m s ≥ 4/(π(m+1)(2m+3)) · s · exp( s²(m+2)/(π²(2m+3)²) − s⁴/(π⁴(m+1)³) )    s > 0

In the assembly's variables, `m+1 = λh`, `w = (ε' + iΔ)h`:

    exponent ≈ (ε'² − Δ²)·h/(π²λ)   (positive case; a factor ≈ 1/4 weaker in the negative case)
    quartic error ≈ (ε'² + Δ²)²·h/(π⁴λ³)
    regime condition: (ε'² + Δ²) ≤ π²λ²/2

Signal against error: `3π²λ²(ε'² − Δ²)/(ε'² + Δ²)²`, large for `λ ≳ ε'`.
Prefactor loss between upper and lower bound: one factor `2m+3`.

The main term at the target: `(h/2)²·(Re S m (εh))²`, rate `2ε²/(π²λ)·(1/4)`
from the negative-case tail sum, i.e. `≈ ε²h/(2π²λ)`: slow, but exponential
in `h`. The on-line background (§6) is polynomial in `h, m, γ`. That is the
gap the assembly uses.

## 6. The on-line background of the switched window — PROVED (units 0334–0335)

Near bound `4h²` per on-line zero is enough: the main term is exponential.
Far bound needs `h|Δ| ≥ √2π(m+1)`; in band steps (`9/5` per band, gap
`≥ (9/10)|k − k₀|`) that is `|k − k₀| > r = max 1 (5(m+1)/h)`. Far term:

    (h/2)²(a + b)² ≤ h²·cS²·(2/(hΔ)²)^{2m+2},   and with hΔ ≥ (9/10)h|k−k₀| > 4.5(m+1):
    ≤ cFarM m /(h²|k−k₀|⁴),   cFarM m = cS m²·(200/81)²·(10(m+1)²)^{−2m} ≤ 1000(m+1)²

(`cFarM_le`: `(2m+1)! ≤ (2m+1)^{2m+1} ≤ 2·4^m(m+1)^{2m+1}` so
`cS ≤ 4π^{2m+1}(m+1)^{2m+1}`, and `π⁴ < 100`). The power `2m` is what
absorbs the factorials. Then unit 0323's series with `K + 3 → K + r + 2`:

    on-line background ≤ 2·88·(γ + r + 2)⁴·(4h² + cFarM m/h²)·π²/6 + 4h²·lowCount
                                                       (WeilPowerOnLine.onLineBound_le)

## 7. The comparison at another off-line zero — PROVED (unit 0341)

In Lean: `WeilPowerCompare.compare_le`, `exponent_eq`, `rate_neg_of_le`,
`rate_neg_of_ge`, `compare_suppressed` (`lean_stage3/Stage3/WeilPowerCompare.lean`).
The `poly(h, m)` below is the single factor `2m+3` times `‖w‖/s`; the
second paragraph is `WeilPowerBounds.norm_S_le_far`, cited. Marked here by
the orchestrator after the probe: the agent left the mark at SKETCH.

Zero at `(ε', Δ)`, target at `(ε, 0)`, both read by the same window
(`m+1 = λh`, regime condition holding for both). From §5:

    |term_other| / term_target ≲ poly(h, m) · exp( [ (ε'² − Δ²) − ε² ] · h/(π²λ) · c )

with `c` between `1/4` and `1` from the two tail-sum constants. So the
other zero is suppressed when `Δ² > ε'² − ε²`, at every real part, once
`h` is large enough that the exponential beats the polynomial. A zero with
`ε' ≤ ε` and `Δ > 0` is always suppressed. A zero with `ε' > ε` is
suppressed only when `Δ > √(ε'² − ε²) ≤ 1/2`: those closer than that form
the cluster.

The crude far bound (§4) covers the heights outside the regime condition:
`Δ ≥ πλ/√2`, decay `(2(ε'² + π²λ²)/Δ²)^{m+1}` against the target, small
when `Δ > √2·√(ε'² + π²λ²) ≈ 4.4λ`. The gap between the two regimes, from
about `1.5λ` to `4.4λ`, is where neither bound is sharp; there the near
bound `4h²`-type crude bound on `|S| ≤ ∫|q| ≤ 2` still applies to the
term, and those zeros are counted by the band count. Their total is
polynomial; fine.

## 8. Selection of the target — PROVED (unit 0344)

In Lean: `WeilPowerSelect.farDelta_le`, `exists_step_le`, `exists_target_step`,
`target_bound`, `target_height_le`, `target_ge_box`
(`lean_stage3/Stage3/WeilPowerSelect.lean`). The "maximum over a finite set"
half of the Lean shape below stays open: `E : ℕ → ℝ` ("the largest
real-part offset among zeros in box `k`") is a parameter, the same
parameterize-downstream choice unit 0341 made for `ε', Δ, ε, h`; wiring it
to an actual finite zero set (`WeilOnLine.lowSet_finite`'s argument
widened, or a band count) is left to whichever later module needs it.
Monotonicity of `E` turns out not to be needed for the step bound at all
— only for the closing sentence below (`target_ge_box`) — since
boundedness of `ε(t_k)²` at every step already stops the climb; the
module proves the pigeonhole lemma (`exists_step_le`) with no
monotonicity hypothesis. The target's explicit height is
`T + h/(8K'π²λ)` (`target_height_le`), not `T + h/(8K'π²λ) + 1`: once the
step count is `⌊h/(4K'π²λ)⌋₊ + 1` rather than a crude round number, the
sketch's `+1` slack (from rounding `(k+1)/2` rather than `k/2`) is not
needed.

Need: a target with `ε'² − Δ² ≤ ε² + K'π²λ/h` for every other zero, so the
cluster contributes at most a bounded factor. Zeros with `|Δ| ≥ 1/2` satisfy
`ε'² − Δ² ≤ 0 < ε²` automatically (`ε' ≤ 1/2`). So only `|Δ| < 1/2` matters.
Choose `t_k` = a zero of largest real part among zeros with `|Im| ≤ T + k/2`
(nonempty: the box zero). The sequence `ε(t_k)` is nondecreasing and
bounded by `1/2`. If `ε(t_{k+1})² ≤ ε(t_k)² + K'π²λ/h`, take `t_k`: its
`1/2`-neighbours lie within `T + (k+1)/2` and have `ε'² ≤ ε(t_k)² + K'π²λ/h`.
Otherwise the square rises by more than `K'π²λ/h` at each step, so within
`k ≤ h/(4K'π²λ)` steps it must stop. The target's height is at most
`T + h/(8K'π²λ) + 1`: explicit. Its own `ε` is at least the box's.

Lean shape: a maximum over a finite set (zeros in a bounded region are
finite: `WeilOnLine.lowSet_finite`'s argument, or the band count), an
induction on `k` with the bounded-increase argument.

## 9. The cluster — SKETCH, dies on size (unit 0345)

Priced before building, 2026-09-06 (unit 0345). Dirichlet over `N`
frequencies needs a range of length at least `Q^N` in `h`, with `Q ≥ 8` for
every phase within `2π/Q` of `0` to leave `cos` bounded away from `0`. `N`
is the band count at the target's height, `N ≥ 15 log T' + 73`, and the
target's height after § 8's walk is `T' = T + H/(8K'π²λ)` where `H` is the
top of the `h`-range. So `H ≥ h₀ + Q^N ≥ (T + H/(8K'π²λ))^{15 log 8}`, an
exponent above `31`: the range grows faster than the height it must stay
inside, at every `T`. Bounding `N` by the shell alone does not help, since
the shell can hold every zero of the band. The alignment route is closed.
What replaces it is § 13. The paragraphs below are kept as the record of
the sketch.


Cluster = other off-line zeros with `|Δ| < 1/2` and `ε'² > ε² − K'π²λ/h`
(with the target selected as in §8, `ε'² ≤ ε² + K'π²λ/h`). Their count is
at most the band count of one band, `15 log(T') + 73`. Each contributes
`−(h/2)²Re(g²)`, `g ≈` (target-sized) `× e^{iφ}`, phase
`φ ≈ 2ε'Δh²/(π²(m+1)) + 2·arctan(Δ/ε')` (from `S ≈ c·w·e^{w²/(π²(m+1))}`).
Members with `|Δ| < ε'` have `cos(2arctan(Δ/ε')) = (ε'² − Δ²)/(ε'² + Δ²) > 0`;
members with `|Δ| > ε'` are suppressed by `e^{−(Δ² − ε'² + ε²)h/(π²λ)}`.
Align the remaining phases `ω_i h`, `ω_i = 2ε'Δ_i·h/(π²(m+1)) = 2ε'Δ_i/(π²λ)`,
by simultaneous Dirichlet over `h` in an explicit range: `N` frequencies,
`Q`, some `h` in `[h₀, h₀ + Q^N·(period)]` with every `ω_i h` within `2π/Q`
of `0 mod 2π`. At alignment every cluster term is negative. Mathlib: check
for a simultaneous Dirichlet lemma; the one-dimensional
`Real.exists_int_int_abs_mul_sub_le` exists, the simultaneous one may need
a pigeonhole proof (~100 lines).

Caveat found and not yet resolved: the cluster is defined through `h`, and
Dirichlet picks `h`. Fix in the sketch: define the cluster by an
`h`-independent superset (all off-line zeros within `1/2` in height of the
widened box) and align all of them; `N` is then the band count of the
widened region.

## 10. The assembly — SKETCH

Choose `λ` of order one (`λ = 1`), `m = ⌊h⌋`. Choose `h` from Dirichlet's
range above a threshold `h₀(ε, T)` where the target's main term
`(h/2)²(Re S m (εh))²` exceeds the on-line background (§6) plus the
suppressed off-line sum (§7) plus a bound on the cluster's cancellation
(§9, none at alignment). Then the zero form at `φ` is negative, `φ` is a
test function of support `2h` (IsTest, C¹: the envelope vanishes to order
`2m + 1 ≥ 3` at the cut), and `StmtDetect ε T (2h)` holds with `h`
explicit in `ε` and `T`. The arrow of unit 0316 then empties the box.

Also needed before the assembly: the split of the zero form's complex
tsum into on-line and off-line parts (summability of the off-line part:
band count of off-line zeros via the reflection symmetry `s ↦ 1 − s` of
the order, and the far bound), and the count of off-line zeros with
`Re < 1/4` through that symmetry, since the count's window covers only
`Re ≥ 1/4`.

## 11. The probe — RUN (unit 0328, exploratory)

Prime side against zero side of the quadratic form at the `m`-th power
window, primes to `e^{2h}`, Riemann–Weil with the archimedean term:
residual `≤ 3.5e-7` absolute at 27 points, Gaussian self-test `2e-10`.
Transform-squared decay slope `−(4m+2)` exactly for `m = 1..4`. Contrast
(hump over floor) peaks at `m = 1, 2, 4` for `h = 6, 12, 24`: `m* ∝ h`,
consistent with the balance sidelobe-vs-skirt at `m ~ h/(2π√log)`.
The detection window `m ~ h` sits past the contrast optimum by a constant:
the theorem trades sharpness for suppression.

## 12. Open questions, with the numbers that decide them

- `λ`: the regime condition needs `(ε'² + Δ²) ≤ π²λ²/2` for the cluster
  (`Δ < 1/2`, `ε' ≤ 1/2`): `λ ≥ 1/π·√1 ≈ 0.32` suffices; `λ = 1` is safe.
- Rate at the target `ε²/(2π²λ) ≈ 0.05ε²` per unit `h` at `λ = 1`: for
  `ε = 0.1` that is `e^{h/2000}`. Explicit `h₀(ε, T)` will be enormous.
  Crude-explicit is the spec; the size is the price.
- The `2m+3` prefactor loss and the `poly(h, m, γ)` background set `h₀`:
  `h₀ ≈ (2π²λ/ε²)·log(poly)`, polynomial in `log T`, `1/ε²`.
- Whether the tsum split needs the off-line part summable at all: yes, to
  write the form as a sum of three parts; the far bound gives it.

## 13. The averaging route — SKETCH (unit 0345)

Replace alignment by averaging. Take `h` over the integers of `[h₀, H]`
with `m + 1 = λh`, weights `w_h = 1/(target lower bound at h)` so the
target's weighted term is at least `1` at every `h`, and consider
`Σ_h w_h · zeroForm(φ_h)`. If the weighted sum is negative, some `h` has a
negative form, which is all `StmtDetect` needs. Each other zero's term is
`−|g_i|² cos 2φ_i(h)` with `2φ_i(h) = ω_i h + 2 arctan(Δ_i/ε') + (phase of
the tail product)`, `ω_i = 4ε'Δ_i/(π²λ)` (from § 5's exponent
`w²/(π²(m+1))`, imaginary part `2ε'Δh²/(π²λh)`). Members split by
`Δ_i h₀`: below `7` the phase is under `0.2·7 = 1.4` radians at `λ = 1` and
the term is negative; above, the phase turns and Abel summation bounds
`|Σ_h w_h|g_i|² cos 2φ_i|` by `(max + total variation of w_h|g_i|²)·π/ω_i`,
while the target contributes at least `H − h₀`. With `N` members, each of
relative size at most `e^{K'}` (§ 8's selection at `η = K'/H`), the range
`H − h₀ = C·N·e^{K'}·h₀/ε` suffices, and `N ≥ 15 log(T + H) + 73` closes
since `H` enters only through a logarithm.

What it needs, in order. (a) The constants of § 5 sharp, so the relative
size of a member is `e^{(ε'² − Δ² − ε²)h/(π²λ)}` times a constant with no
power of `m` and no factor in the rate: unit 0346. (b) The phase of the
tail product: `‖T m w n − 1‖ ≤ 2‖w‖⁴/(3π⁴(m+1)³)`, from
`|e^z − 1| ≤ |z|e^{|z|}` on `z = Σ(log(1+x_j) − x_j)`; then
`Re S² ≥ |P|² cos(2 arg P) − |P|²(2δ + δ²)` with `P` the explicit principal
part. (b), in detail — PROVED (unit 0347: `WeilPowerPhase.T_eq_mul`, `norm_S_sub_le`,
`re_A_sq`, `re_S_sq_ge`; `sigma_ge`, `sigma_le` for `σ`). With `x_j = w²/(π²(j+1)²)` and `‖x_j‖ ≤ 1/2` in
the regime, `T m w n = exp(Σ log(1+x_j)) = exp(w² σ_n)·exp(δ_n)` where
`σ_n = Σ_{j=m+1}^{n−1} 1/(π²(j+1)²)` and `δ_n = Σ(log(1+x_j) − x_j)`,
`‖δ_n‖ ≤ Σ‖x_j‖² ≤ q := ‖w‖⁴/(π⁴(m+1)³)` (Mathlib's
`norm_log_one_add_sub_self_le` at `‖x‖ ≤ 1/2`). For `q ≤ 1`,
`‖exp δ_n − 1‖ ≤ 2q` (`norm_exp_sub_one_le`). Let `σ = lim σ_n`
(`1/(π²(m+2)) ≤ σ ≤ 1/(π²(m+1))`) and `P = exp(w²σ)`. In the limit
`S m w = c·w·P·(1 + E)` with `c = cS m/D m` and `‖E‖ ≤ 2q`, so
`‖S − c w P‖ ≤ 2q·c‖w‖‖P‖` and

    Re (S m w)² ≥ c²e^{2Re(w²)σ}·[Re(w²) cos(2 Im(w²) σ) − Im(w²) sin(2 Im(w²) σ)]
                  − c²‖w‖²e^{2Re(w²)σ}·(4q + 4q²).

At `w = (ε' + iΔ)h`, `σ ≈ 1/(π²λh)`: the phase `2 Im(w²) σ = 4ε'Δh/(π²λ)`
is the `ω_i h` above, and the bracket is `h²[(ε'² − Δ²) cos − 2ε'Δ sin]`,
positive when the phase is under `π/2` and `Δ < ε'`.

### 13c The tail sum to order 1/h — PROVED (unit 0348: `WeilPowerSigma.sigma_le_half`,
`sigma_ge_amgm`, `r_pos`, `r_le`, `u_mono`; the two telescoping identities are
`sum_telescope_half` and `sum_telescope_amgm`, the block's "via" clauses as their own
theorems)
Objects.   `σ(m) = Σ_{j≥m+2} 1/(π²j²)` (WeilPowerPhase.sigma). With `λ = 1`,
           `h = m + 1`, the exponent of a member's principal part is
           `2ζ²h²σ(m)`, `ζ = ε' + iΔ`; define `u(m) = (m+1)²·σ(m)`. The
           averaging in (c) needs `u` linear in `m` to order `1/m`: the
           member's normalized term is `(ζ²/ε²)·exp(z·u)` with
           `z = 2(ζ² − ε²)`, and `exp(z·u) = exp(z(m+½)/π²)·exp(z·r)` with
           `r = u − (m+½)/π²`; the first factor is geometric in `m`, the
           second is `1 + O(|z| r)`.
Sizes.     Unit 0347 has `1/(π²(m+2)) ≤ σ ≤ 1/(π²(m+1))`, which gives
           `|u − m/π²| ≤ 1/π²`: an `O(1)` error, and `exp(z·r)` is then a
           bounded factor, not a small one; summed over the `h`-range that
           costs a constant times the range, the same size as the target.
           The sharp brackets give `0 < r ≤ 1/(π²(4m+6))`, so the
           correction summed over `m ∈ [a, b]` is `O(|z| log(b/a))` against
           the target's `b − a`. Lost factor: none once `r = O(1/m)`.
Regime.    none (m : ℕ).
Theorems.  sum_upper_half — `m + 1 ≤ n` — `Σ_{j∈Ico(m+1)n} 1/(j+1)² ≤ 2/(2m+3)`
             (via `1/(j+1)² ≤ 1/(j+½) − 1/(j+3/2)`, telescoping).
           sum_lower_amgm — `m + 1 ≤ n` — `1/(m+2) + 1/(2(m+2)²) − 1/(n+1) − 1/(2(n+1)²)
             ≤ Σ_{j∈Ico(m+1)n} 1/(j+1)²`
             (via `1/(j+1)² ≥ [1/(j+1) − 1/(j+2)] + [1/(2(j+1)²) − 1/(2(j+2)²)]`,
             which is `1/(2(j+1)²) + 1/(2(j+2)²) ≥ 1/((j+1)(j+2))`, AM–GM).
           sigma_le_half — none — `σ(m) ≤ 2/(π²(2m+3))`   (limit of sum_upper_half).
           sigma_ge_amgm — none — `1/(π²(m+2)) + 1/(2π²(m+2)²) ≤ σ(m)`   (limit).
           u_def — `u m = ((m:ℝ)+1)² · σ(m)`.
           r_pos — none — `1/(2π²(m+2)²) ≤ u m − (m + 1/2)/π²`.
           r_le — none — `u m − (m + 1/2)/π² ≤ 1/(π²(4m+6))`.
           u_mono — none — `u m ≤ u (m+1)`   (from r_pos, r_le: the step is
             at least `(1 + 1/(2(m+3)²) − 1/(4m+6))/π² > 0`).
Composes.  WeilPowerPhase.sigma, WeilPowerPhase.sigmaN_tendsto,
           WeilPowerPhase.sigmaN_eq, WeilPowerSharp.sum_telescope (shape),
           le_of_tendsto, le_of_tendsto_of_tendsto,
           tendsto_one_div_add_atTop_nhds_zero_nat (as in unit 0346).
Module.    Stage3/WeilPowerSigma.lean, namespace WeilPowerSigma; pins:
           sigma_le_half, sigma_ge_amgm, r_le, u_mono.
Open.      none; the next block (13d) is the geometric sum
           `|Σ_{m∈Ico a b} exp(z(m+½)/π²)| ≤ (|r|^a + |r|^b)/(e^{Re z/π²}|sin(Im z/π²)|)`
           and the harmonic bound on `Σ r(m)`.

### 13d The geometric sum and the harmonic correction — PROVED (unit 0349:
`WeilPowerGeom.norm_one_sub_exp_ge`, `norm_geom_le`, `log_telescope`,
`norm_sum_exp_u_le`; `sin_im_ge`, `rho_ne_one`, `exp_shift`, `geom_Ico`,
`exp_lin_le_Mab`, `log_step`, `harmonic_quarter`, `norm_corr_le` beside them,
and `Mab`, `geomBound` as the two defs)
Objects.   `z ∈ ℂ` (in use `z = 2(ζ² − ε²)`, `ζ = ε' + iΔ`, so `Im z = 4ε'Δ`
           and `|Re z| ≤ η`, both small); `ρ = exp(z/π²)`; a sequence
           `u : ℕ → ℝ` within `[0, 1/(π²(4m+6))]` above `(m+½)/π²` (13c's
           `u`); the two sums over `m ∈ Ico a b`:
           `G = Σ exp(z(m+½)/π²) = exp(z/(2π²))·Σ ρ^m` and `U = Σ exp(z·u m)`.
Sizes.     `‖G‖ ≤ (e^{Re z(a+½)/π²} + e^{Re z(b+½)/π²}) / ‖1 − ρ‖` and
           `‖1 − ρ‖ ≥ |Im ρ| = e^{Re z/π²} sin(Im z/π²) ≥ e^{Re z/π²}·2 Im z/π³`
           (Jordan, `Im z/π² ≤ π/2`): independent of `b − a`, size
           `π³/(2·4ε'Δ)`, the averaging gain against the target's `b − a`.
           `U − G = Σ exp(z(m+½)/π²)(exp(z r_m) − 1)`, `‖exp(z r_m) − 1‖ ≤ 2‖z‖ r_m`
           when `‖z‖ r_m ≤ 1`, and `Σ_{Ico a b} r_m ≤ Σ 1/(π²(4m+6))
           ≤ (log b − log a)/(4π²)`: logarithmic in the range. Lost factor:
           none; the log is the price of `r = O(1/m)`.
Regime.    R1 `0 < z.im`;  R2 `z.im ≤ π³/2` (so `z.im/π² ≤ π/2`);
           R3 `1 ≤ a`;  R4 `a ≤ b`;  R5 `‖z‖ ≤ π²(4a+6)`;
           (unit 0349 drops R4 from `exp_lin_le_Mab`, which has `a ≤ m ≤ b`,
           and R3 from `norm_corr_le`, which gets `‖z‖·r ≤ 1` from R5 at `a`
           and `a ≤ m`: an unused binder is a warning, TRAPS row 20.)
           R6 `∀ m, 0 ≤ u m − (m+½)/π² ∧ u m − (m+½)/π² ≤ 1/(π²(4m+6))`.
Defs.      `Mab z a b = max (exp(z.re(a+½)/π²)) (exp(z.re(b+½)/π²))`;
           `geomBound z a b = (exp(z.re(a+½)/π²) + exp(z.re(b+½)/π²)) · π³ / (2·exp(z.re/π²)·z.im)`.
Theorems.  norm_one_sub_exp_ge — none — `exp(ζ.re)·|sin ζ.im| ≤ ‖1 − exp ζ‖`
             (via `|Im(1 − exp ζ)| ≤ ‖1 − exp ζ‖`, `Complex.exp_im`).
           sin_im_ge — R1, R2 — `2·z.im/π³ ≤ sin(z.im/π²)`  (`Real.mul_le_sin`).
           rho_ne_one — R1, R2 — `exp(z/π²) ≠ 1`  (from the two above: `‖1 − ρ‖ > 0`).
           exp_shift — none — `exp(z(m+½)/π²) = exp(z/(2π²)) · exp(z/π²)^m`
             (`Complex.exp_nat_mul`, `Complex.exp_add`).
           geom_Ico — `ρ ≠ 1`, R4 — `Σ_{Ico a b} ρ^m = (ρ^b − ρ^a)/(ρ − 1)`
             (`geom_sum_eq` on `range b` and `range a`, `Finset.sum_Ico_eq_sub`).
           norm_geom_le — R1, R2, R4 — `‖G‖ ≤ geomBound z a b`.
           exp_lin_le_Mab — R4, `a ≤ m`, `m ≤ b` — `exp(z.re(m+½)/π²) ≤ Mab z a b`
             (linear in `m`, so at an endpoint; case on the sign of `z.re`).
           log_step — `1 ≤ m` — `1/((m:ℝ)+1) ≤ log(m+1) − log m`
             (`Real.log_le_sub_one_of_pos` at `m/(m+1)`, `Real.log_div`).
           log_telescope — R3, R4 — `Σ_{Ico a b} 1/((m:ℝ)+1) ≤ log b − log a`
             (induction on `b` with `Finset.sum_Ico_succ_top`).
           harmonic_quarter — R3, R4 — `Σ_{Ico a b} 1/(π²(4m+6)) ≤ (log b − log a)/(4π²)`.
           norm_corr_le — R3, R5, R6, `a ≤ m` — `‖exp(z·u m) − exp(z(m+½)/π²)‖
             ≤ exp(z.re(m+½)/π²) · 2‖z‖ · (u m − (m+½)/π²)`
             (`exp(z u) = exp(z(m+½)/π²)·exp(z r)`, `Complex.norm_exp_sub_one_le`).
           norm_sum_exp_u_le — R1–R6 — `‖U‖ ≤ geomBound z a b
             + 2‖z‖ · Mab z a b · (log b − log a)/(4π²)`.
Composes.  Complex.exp_im, Complex.abs_im_le_norm, Complex.norm_exp,
           Complex.exp_nat_mul, Complex.exp_add, Real.mul_le_sin,
           geom_sum_eq, Finset.sum_Ico_eq_sub, Finset.sum_Ico_succ_top,
           Real.log_le_sub_one_of_pos, Real.log_div, Real.log_inv,
           Complex.norm_exp_sub_one_le, norm_sum_le, Finset.sum_le_sum,
           Nat.le_induction. (`geom_sum_Ico` IS on this Mathlib, in
           `Algebra/Field/GeomSum.lean`, stated as a `lemma` in exactly this
           block's shape, so a `theorem`-only grep misses it; unit 0349's
           `geom_Ico` is that lemma.)
Module.    Stage3/WeilPowerGeom.lean, namespace WeilPowerGeom; pins:
           norm_one_sub_exp_ge, norm_geom_le, log_telescope, norm_sum_exp_u_le.
Open.      none; the next block (13e) reads `z`, `Mab` and the regime at
           the shell: `Im z = 4ε'Δ`, `|Re z| ≤ η`, `Mab ≤ e^{K'}`, and
           traces `q ≤ 1/(N e^{K'})` to `h` and `λ`.

(c) The total variation of `w_h|g_i|²` over the range: log-linear in
`h` up to the quartic terms, so at most a constant times its maximum.
(d) § 8's selection at threshold `η = K'/H`, height growth `H/(8K'π²λ)`.
(e) The on-line background (§ 6) and the suppressed zeros (§ 7) summed with
the same weights, both polynomial against the target's `H − h₀`.

Open, with the number that decides it: the quartic phase error
`‖w‖⁴/(3π⁴(m+1)³) = ε⁴h/(3π⁴λ³)` grows with `h`; it is under `0.3` radians
only for `h ≤ 88λ³/ε⁴`. Over a range of length `C N e^{K'} h₀/ε` with
`h₀ ~ 2π²λ log(poly)/ε²` that forces `λ³ ≳ ε⁴ H/88`, so `λ` grows with the
range, the rate `ε²/(2π²λ)` falls, and `h₀` rises. A fixed point exists
(everything is polynomial in `log`) and its size is the price of the
route. The other choice is a phase bound that does not go through the
Gaussian approximation: the exact argument of the tail product.
