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

## 14. The window question — ANSWERED NO (unit 0360): boost and phase are one

Sections 9 and 13 died of one cause, twice. An off-line zero contributes
`2 Re(S(w)²)` and the sign of that turns on a phase we do not control, so the
other off-line candidates can cancel the target. Section 9 tried to align the
phases and needed a range `Q^N`; section 13 tried to average them away and
needed a range shorter than its own threshold.

The question this section asks instead: is there a window for which the sign
never turns — `Re(S(w)²) ≤ 0` at every `w` in the box — so that every off-line
zero helps and none can cancel? The machinery to price a candidate is the one
sections 5–13 built. Unit 0347 factors the transform as `S = c·w·exp(w²σ)(1+E)`
with `‖E‖ ≤ 2q`, and the factorization comes from the window's product shape,
so it holds for any window of that shape with its own `σ`. Units 0348 and 0350
give `σ` to order `1/h` at any slope; 0349 and 0350 give the sums.

Priced 2026-09-07, unit 0360. The answer is no, and the reason closes the
method. The phase is `2 arg S = 2 arctan(Δ/ε') + 4ε'Δh²σ`. At `Δ → 0` it goes
to `0` for every `σ` and every `h`, so a zero at the target's own height always
hurts: no window makes the sign fixed. The bad set's first stripe does shrink
like `1/(σh²)`, but the phase keeps turning past it, so the bad set is a union
of stripes whose measure tends to half the box — finer stripes, not fewer.

Why: `exp(w²σ)` carries both effects. Its modulus `exp((ε'²−Δ²)h²σ)` is the
boost that lifts an off-line zero above the on-line background; its argument
`2ε'Δh²σ` is the phase whose turning equidistributes the other zeros' signs.
One `σ`, at the same rate in `h²σ`. Setting `σ = 0` removes the sweep and the
boost together. That is why sections 9 and 13 both died fighting the sweep
with the support: the sweep is what the support buys. Written up for
`papers/What-Didnt-Work.md`, with unit 0360's numbers.

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

## 13. The averaging route — DEAD (unit 0359); the shell priced (unit 0351,
corrected by 0357) and closed (units 0357-0358)

Marked dead 2026-09-07, after unit 0359 and Julian's question about what
relies on it staying open. Nothing does: `StmtDetect` appears in one theorem
of `WeilDetect.lean` as a hypothesis and nothing proves it, and the nine
modules cite this section as provenance rather than depending on it. Unlike
unit 0351, which closed under a literature theorem (Trudgian's bound on the
argument), the factor that fails here is `N`, the count of off-line
candidates near the target with comparable real part. A bound on that is a
statement of the same strength as the rung's own conclusion, so it is not a
leaf. Sections 9 and 13 are now both dead of one cause: about `log T`
off-line candidates whose phase is uncontrolled, each able to cancel the
target. What replaces them is section 14, the window question.

Priced before writing the assembly's block, 2026-09-07 (unit 0359). Section 8
picks the target as a zero of largest real part, so every member decays like
`exp(-2*Delta^2*u)` and its total over `h` is at most `lam*pi^2/(2*Delta^2)`.
Block 13g frees the members with `Delta*b <= lo`, `lo = lam*pi^3/(8*eps')`.
The worst case puts all `N` members just past that boundary, at
`Delta = lo/b`, costing `N*lam*pi^2*b^2/(2*lo^2)` against the target's `b`:
the range must satisfy `b < lam*pi^4/(32*N*eps'^2)`. It must also start above
`h0 ~ 2*pi^2*lam*log(P)/eps^2` (section 12). Their ratio is
`pi^2*eps^2/(64*N*eps'^2*log P)`, which is `0.154/(N log P)` at `eps' = eps`:
`lam` cancels, `eps` cancels, and the ratio is under 1 at every setting. The
range the members allow is shorter than the range the background demands.
The gap is at the one point the two proved bounds meet: a member at
`Delta = lo/b` is just past 13g's sign condition, its decay over the range is
near 1, and 13f's geometric bound at that `Delta` is the range itself. Both
bounds are tight; the member costs what the target earns. What replaces this
is undecided and is the next decision unit. The blocks below stay: every one
is a statement about the switched window, not about this route.


Priced before building block 13f, 2026-09-06 (unit 0351). The split below
by `Δ_i h₀ < 7` holds at `h` near `h₀` only: over the range to `H` the phase
`4ε'Δh/(π²λ)` of those members turns. A member with the target's real part
and `Δ` below about `λ/(εX)` has relative amplitude at most `1` and no decay
over `[X, 2X]`; at phase `π` it cancels the target. Zeros at heights in
geometric progression of ratio `1.5` put two members in the hurting lobe at
every `h`, so every range fails; the adversary needs one shell per factor
`1.5` of range, and `JensenCount.zeta_local_zero_count` allows
`15 log T' + 73` of them: `H/a ≤ T'^{15 ln 1.5}`, exponent above `6`, with
`T' = T + H/(8K'π²λ)`. Section 9's circularity again. It closes under
`ArgCrude.StmtSCrude S B₁ B₃` with `B₁ < 1/(2 ln 1.5) ≈ 1.23` (Backlund
`0.137`, Trudgian `0.112`; the tree's crude chain gives about `7`): the
shell is then a pigeonhole over the ratio-`1.5` shells with exponent
`2B₁ ln 1.5 < 1`. The route continues as a conditional theorem with that
leaf named; blocks 13f onward are on hold at Julian's word. The sketch
below is kept as the record.


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

### 13e The geometric bound with a free slope, and `u` at general `λ` — PROVED
(unit 0350: `WeilPowerGeomGen.norm_geom_le_gen`, `norm_corr_le_gen`,
`norm_sum_exp_u_le_gen`, `uLam_bracket`)
Objects.   Blocks 13c–13d were stated at `λ = 1` (`h = m + 1`, slope `1/π²`,
           intercept `½/π²`). The shell needs `λ` free: the error term of
           unit 0347 is `q = ‖w‖⁴/(π⁴(m+1)³) = |ζ|⁴h/(π⁴λ³)` at `m+1 = λh`,
           and the assembly needs `4q·Σ_i (|ζ_i|²/ε²)·e^{K'} < ½` at the top
           of the range, i.e. `q ≤ ε²/(4N e^{K'})`, so `λ³ ≥ 4N e^{K'} |ζ|⁴ H/(π⁴ε²)`:
           `λ` grows with the range and is polynomial in `N, e^{K'}, 1/ε`.
           With `m + 1 = λh` the exponent is `z·h²σ(λh−1) = z·uLam λ h` and
           `uLam λ h = u(λh−1)/λ² = h/(λπ²) − 1/(2λ²π²) + r'`, so the sum
           over `h` is geometric with ratio `exp(z/(λπ²))`. This block is
           13d with slope `α`, intercept `β₀` and correction scale `c` free
           (LOOP § 3: parameterize downstream), plus the bracket for `uLam`.
Sizes.     At `α = 1/(λπ²)` the geometric bound is `13d's × λ` (the phase
           advances `λ` times slower per step); the correction sum is
           `2‖z‖·c·Mab·(log b − log a)` with `c = 1/(2λ³π²)`. Lost factor:
           none; `λ` is the price of the slower phase and is polynomial.
Regime.    G1 `0 < α`;  G2 `0 < z.im`;  G3 `z.im · α ≤ π/2`;  G4 `1 ≤ a`;
           G5 `a ≤ b`;  G6 `‖z‖ · c ≤ (a:ℝ) + 1`;
           G7 `∀ h, 0 ≤ u h − (α h + β₀) ∧ u h − (α h + β₀) ≤ c/((h:ℝ)+1)`;
           L1 `1 ≤ λ` (ℕ);  L2 `1 ≤ h` (ℕ).
Defs.      `MabGen z α β₀ a b = max (exp(z.re(αa+β₀))) (exp(z.re(αb+β₀)))`;
           `geomBoundGen z α β₀ a b = (exp(z.re(αa+β₀)) + exp(z.re(αb+β₀))) · π / (2·exp(z.re·α)·z.im·α)`;
           `uLam (λ h : ℕ) : ℝ = (h:ℝ)² · WeilPowerPhase.sigma (λ*h − 1)`.
Theorems.  exp_shift_gen — none — `exp(z(αh+β₀)) = exp(z β₀) · exp(z α)^h`
             (`Complex.exp_add`, `Complex.exp_nat_mul`; `(αh+β₀ : ℝ)` cast).
           sin_im_ge_gen — G2, G3 — `2·z.im·α/π ≤ sin(z.im·α)`  (`Real.mul_le_sin`).
           rho_ne_one_gen — G1, G2, G3 — `exp(z·α) ≠ 1`
             (`WeilPowerGeom.norm_one_sub_exp_ge` at `w = z·α`, the sine positive).
           norm_geom_le_gen — G1, G2, G3, G5 — `‖Σ_{Ico a b} exp(z(αh+β₀))‖ ≤ geomBoundGen z α β₀ a b`
             (`geom_sum_Ico`, then `norm_one_sub_exp_ge` and `sin_im_ge_gen`).
           exp_lin_le_MabGen — G1, `a ≤ h`, `h ≤ b` — `exp(z.re(αh+β₀)) ≤ MabGen z α β₀ a b`.
           norm_corr_le_gen — G6, G7, `a ≤ h` — `‖exp(z·u h) − exp(z(αh+β₀))‖
             ≤ exp(z.re(αh+β₀)) · 2‖z‖ · c/((h:ℝ)+1)`  (`Complex.norm_exp_sub_one_le`).
           norm_sum_exp_u_le_gen — G1–G7 — `‖Σ_{Ico a b} exp(z·u h)‖
             ≤ geomBoundGen z α β₀ a b + 2‖z‖ · c · MabGen z α β₀ a b · (log b − log a)`
             (`WeilPowerGeom.log_telescope` for `Σ 1/(h+1)`).
           uLam_eq — L1, L2 — `uLam λ h = WeilPowerSigma.u (λ*h − 1) / (λ:ℝ)²`
             (`((λ*h − 1 : ℕ) : ℝ) + 1 = λ h`, needs `1 ≤ λ*h`).
           uLam_bracket — L1, L2 — `0 ≤ uLam λ h − ((h:ℝ)/(λπ²) − 1/(2λ²π²))
             ∧ uLam λ h − (…) ≤ 1/(2λ³π²) / ((h:ℝ)+1)`
             (from `WeilPowerSigma.r_pos`, `r_le` at `m = λh − 1`, divided by `λ²`;
             the last step is `λ²π²(4λh+2) ≥ 2λ³π²(h+1)`, i.e. `λh + 1 ≥ λ`).
Composes.  WeilPowerGeom.norm_one_sub_exp_ge, WeilPowerGeom.log_telescope,
           WeilPowerGeom.exp_lin_le_Mab (shape), WeilPowerGeom.norm_geom_le (shape),
           WeilPowerSigma.u, WeilPowerSigma.r_pos, WeilPowerSigma.r_le,
           WeilPowerPhase.sigma, geom_sum_Ico (a `lemma`), Complex.exp_nat_mul,
           Complex.exp_add, Complex.norm_exp, Real.mul_le_sin,
           Complex.norm_exp_sub_one_le, norm_sum_le, Finset.sum_le_sum.
Module.    Stage3/WeilPowerGeomGen.lean, namespace WeilPowerGeomGen, importing
           WeilPowerGeom and WeilPowerSigma; pins: norm_geom_le_gen,
           norm_sum_exp_u_le_gen, uLam_bracket, norm_corr_le_gen.
Open.      none; 13f reads `z = 2(ζ² − ε²)`, `α = 1/(λπ²)`, `c = 1/(2λ³π²)`,
           `u = uLam λ` at one shell member and bounds
           `|Σ_h Re((ζ²/ε²) exp(z·uLam λ h))|` by explicit constants in
           `ε, ε', Δ, η, K', λ, a, b`.

### 13f One shell member's weighted sum, explicit — PROVED (unit 0352:
`WeilPowerShell.shellSum_le`, `shellSum_le_abs`, `geomBound_le`, `uSh_bracket`)
Objects.   The member at `ζ = ε' + iΔ`, the target at `ε`, the window
           `m + 1 = λh`. Its weighted principal term at `h` is
           `coef · exp(z · uLam λ h)` with `coef = ζ²/ε²`, `z = 2(ζ² − ε²)`
           (unit 0347's `re_S_sq_ge` divided by the target's
           `c²ε²h²e^{2ε²h²σ}`; `h²σ(λh−1) = uLam λ h`, unit 0350).
           `z.re = 2(ε'² − Δ² − ε²)`, `z.im = 4ε'Δ`, `‖z‖ ≤ 2(ε'² + Δ² + ε²)`,
           `‖coef‖ = (ε'² + Δ²)/ε²`. Block 13e's bound applies with
           `α = 1/(λπ²)`, `β₀ = −1/(2λ²π²)`, `c = 1/(2λ³π²)`, `u = uLam λ`,
           except that its G7 quantifies over every `k` including `0`,
           where `uLam λ 0 = 0` and the bracket fails for `λ ≥ 2`; the sum
           runs over `h ≥ a ≥ 1`, so `u` is patched at `0` to the affine
           value (`uSh`) and the two sums agree termwise.
Sizes.     With `ε', Δ, ε ≤ 1/2`: `‖z‖ ≤ 3/2`, `e^{‖z‖α} ≤ e^{3/(2π²)} < 1.17`,
           the endpoint factor `MabGen ≤ M := e^{2ηb/(λπ²)}` (with
           `ε'² − Δ² − ε² ≤ η`, and `≤ 1` when `z.re < 0`), so the geometric
           part is at most `1.17·λπ³/(4ε'Δ)·M ≈ 9λM/(ε'Δ)` and the correction
           at most `(3/2)·M·log(b/a)/(λ³π²)`, both times `(ε'²+Δ²)/ε²`.
           Lost factor: none in `h` or `b`; the `1/Δ` is the geometric price,
           and the shell below `Δ ≈ λ/(εX)` where this bound is useless is
           unit 0351's finding, handled there by the tight count, never here.
Regime.    R1 `0 < ε'`;  R2 `ε' ≤ 1/2`;  R3 `0 < Δ`;  R4 `Δ ≤ 1/2`;  R5 `0 < ε`;
           R6 `ε ≤ 1/2`;  R7 `ε'² − Δ² − ε² ≤ η`;  R8 `0 ≤ η`;  L1 `1 ≤ λ` (ℕ);
           G4 `1 ≤ a` (ℕ);  G5 `a ≤ b` (ℕ).
Defs.      `zOf ε' Δ ε : ℂ = 2 * (((ε':ℂ) + I * Δ)^2 − (ε:ℂ)^2)`;
           `coef ε' Δ ε : ℂ = ((ε':ℂ) + I * Δ)^2 / (ε:ℂ)^2`;
           `uSh (λ k : ℕ) : ℝ = if k = 0 then −1/(2λ²π²) else WeilPowerGeomGen.uLam λ k`;
           `shellSum ε' Δ ε λ a b : ℝ = Σ_{h ∈ Ico a b} (coef * exp(zOf * (uLam λ h : ℂ))).re`.
Theorems.  zOf_re — none — `(zOf ε' Δ ε).re = 2(ε'² − Δ² − ε²)`  (`Complex.mul_re`, simp).
           zOf_im — none — `(zOf ε' Δ ε).im = 4ε'Δ`.
           norm_zOf_le — none — `‖zOf ε' Δ ε‖ ≤ 2(ε'² + Δ² + ε²)`
             (`norm_mul`, `norm_sub_le`, `Complex.norm_pow`, `Complex.sq_norm` with
             `Complex.normSq_apply` for `‖ε' + IΔ‖² = ε'² + Δ²`).
           norm_coef — none — `‖coef ε' Δ ε‖ = (ε'² + Δ²)/ε²`  (`Complex.norm_div`, same square).
           uSh_bracket — L1 — `∀ k, 0 ≤ uSh λ k − ((k:ℝ)/(λπ²) − 1/(2λ²π²))
             ∧ uSh λ k − (…) ≤ 1/(2λ³π²)/((k:ℝ)+1)`
             (`k = 0`: both sides by `simp`, positivity; `k ≥ 1`: `uLam_bracket`).
           sum_uSh_eq — G4 — `Σ_{Ico a b} coef * exp(zOf * (uLam λ h:ℂ))
             = Σ_{Ico a b} coef * exp(zOf * (uSh λ h:ℂ))`
             (`Finset.sum_congr rfl`, `Finset.mem_Ico`, `h ≠ 0` from `1 ≤ a ≤ h`, `if_neg`).
           im_alpha_le — R1, R2, R3, R4, L1 — `(zOf ε' Δ ε).im * (1/(λπ²)) ≤ π/2`
             (`4ε'Δ ≤ 1`; `1/(λπ²) ≤ 1/π²`; `1/π² ≤ π/2` from `Real.pi_gt_three`).
           norm_zOf_c_le — R1–R6, L1 — `∀ a : ℕ, ‖zOf ε' Δ ε‖ * (1/(2λ³π²)) ≤ (a:ℝ) + 1`
             (`‖z‖ ≤ 3/2`, `1/(2λ³π²) ≤ 1/18`, product under `1`).
           exp_end_le — R7, R8, L1, G4, `a ≤ h`, `h ≤ b` —
             `exp((zOf).re * ((1/(λπ²)) * h + (−1/(2λ²π²)))) ≤ exp(2ηb/(λπ²))`
             (cases on the sign of `z.re`: `z.re ≥ 0` uses `z.re ≤ 2η` from R7 and
             `0 ≤ αh + β₀ ≤ αb` from `2λh ≥ 1` and `h ≤ b`; `z.re < 0` uses
             `αh + β₀ ≥ 0` so the exponent is `≤ 0 ≤ 2ηb/(λπ²)`; `Real.exp_le_exp`).
           MabGen_le — R7, R8, L1, G4, G5 —
             `MabGen (zOf) (1/(λπ²)) (−1/(2λ²π²)) a b ≤ exp(2ηb/(λπ²))`  (`max_le`, exp_end_le twice).
           inv_exp_le — none — `1 / exp((zOf).re * (1/(λπ²))) ≤ exp(2(ε'²+Δ²+ε²) * (1/(λπ²)))`
             (`Real.exp_neg`, `Complex.abs_re_le_norm`, norm_zOf_le, `Real.exp_le_exp`;
             `0 ≤ 1/(λπ²)` for any `λ : ℕ`).
           geomBound_le — R1, R3, R7, R8, L1, G4, G5 —
             `geomBoundGen (zOf) (1/(λπ²)) (−1/(2λ²π²)) a b
              ≤ exp(2ηb/(λπ²)) * λ * π³ * exp(2(ε'²+Δ²+ε²) * (1/(λπ²))) / (4ε'Δ)`
             (unfold; `zOf_im`; numerator `≤ 2Mπ` by exp_end_le at `a` and `b` with
             `div_le_div_of_nonneg_right`, denominator `2e^{z.re α}·4ε'Δ/(λπ²) > 0` from
             R1, R3, L1; then `2Mπ/(8ε'Δe^{z.re α}/(λπ²)) = Mλπ³·(1/e^{z.re α})/(4ε'Δ)` by
             `field_simp`/`ring`, and inv_exp_le with `mul_le_mul_of_nonneg_left`).
           shellSum_le — R1–R8, L1, G4, G5 —
             `|shellSum ε' Δ ε λ a b| ≤ ((ε'²+Δ²)/ε²) * exp(2ηb/(λπ²))
              * (λ * π³ * exp(2(ε'²+Δ²+ε²) * (1/(λπ²))) / (4ε'Δ)
                 + 2(ε'²+Δ²+ε²) * (log b − log a) / (λ³π²))`
             (`Complex.re_sum` backwards, `Complex.abs_re_le_norm`, `Finset.mul_sum`
             backwards and `norm_mul`, norm_coef, sum_uSh_eq, then
             `WeilPowerGeomGen.norm_sum_exp_u_le_gen` at `u = uSh λ` with `hα` from L1,
             `hz1` from zOf_im with R1 R3, `hz3` = im_alpha_le, `hzc` = norm_zOf_c_le,
             `hu` = uSh_bracket; then geomBound_le, MabGen_le, norm_zOf_le, and
             `0 ≤ log b − log a` from `Real.log_le_log` with `0 < a ≤ b`).
           shellSum_neg — none — `shellSum ε' (−Δ) ε λ a b = shellSum ε' Δ ε λ a b`
             (termwise: `coef ε' (−Δ) ε = conj (coef ε' Δ ε)` and the same for `zOf`, by
             `map_div₀`, `map_pow`, `map_sub`, `map_mul`, `Complex.conj_ofReal`,
             `Complex.conj_I`; `Complex.exp_conj`; `Complex.conj_re`).
           shellSum_le_abs — R1, R2, `Δ ≠ 0`, `|Δ| ≤ 1/2`, R5–R8, L1, G4, G5 — the bound of
             shellSum_le with `|Δ|` in place of `Δ` (cases on the sign of `Δ`; the
             negative case through shellSum_neg; the `abs` lemmas are the executor's
             under LOOP.md § 2; R7 is even in `Δ`).
Composes.  WeilPowerGeomGen.norm_sum_exp_u_le_gen, WeilPowerGeomGen.uLam_bracket,
           WeilPowerGeomGen.uLam, WeilPowerGeomGen.MabGen, WeilPowerGeomGen.geomBoundGen,
           Complex.re_sum, Complex.abs_re_le_norm, Complex.sq_norm, Complex.normSq_apply,
           Complex.norm_div, Complex.norm_pow, Complex.norm_exp, Complex.exp_conj,
           Complex.conj_re, Complex.conj_ofReal, Complex.conj_I, Finset.mul_sum (a `lemma`),
           Finset.prod_congr (`sum_congr` by `to_additive`), Finset.mem_Ico,
           Real.exp_le_exp, Real.exp_neg, Real.exp_pos, Real.log_le_log (a `lemma`),
           Real.pi_gt_three, norm_sum_le, div_le_div_of_nonneg_right (a `lemma`).
Module.    Stage3/WeilPowerShell.lean, namespace WeilPowerShell, importing
           WeilPowerGeomGen; pins: shellSum_le, shellSum_le_abs, geomBound_le,
           uSh_bracket. Built under the relay (LOOP.md § 4b), the first module so built.
Open.      none in this block; the assembly's use of it needs the tight count
           (unit 0351) for the members below `Δ ≈ λ/(εX)`.
Arithmetic checked here: `geomBoundGen = (E_a + E_b)π/(2e^{z.re α}·z.im·α)` with
`z.im·α = 4ε'Δ/(λπ²)`; `(2Mπ)·(λπ²)/(8ε'Δe^{z.re α}) = Mλπ³/(4ε'Δe^{z.re α})`;
`2‖z‖·c·M·(log b − log a) ≤ 2·2(ε'²+Δ²+ε²)·M·(log b − log a)/(2λ³π²)
= 2(ε'²+Δ²+ε²)M(log b − log a)/(λ³π²)`; `4ε'Δ ≤ 1` at `ε', Δ ≤ 1/2`;
`(3/2)/(2π²) < 1/12 < 1`; `1/π² < 1/9 < 3/2 < π/2`.

### 13g The near members' sign — PROVED (unit 0354: `WeilPowerNear.term_nonneg`,
`shellSum_nonneg`, `shellSum_nonneg_abs`, `bracket_nonneg`)
Objects.   A member at `ζ = ε' + iΔ` with `0 < Δ < ε'`, phase over the range
           under `π/2`. From unit 0352's objects, the weighted term's real part
           is `e^{z.re·u}/ε² · ((ε'² − Δ²) cos θ − 2ε'Δ sin θ)` with `θ = 4ε'Δ·u`
           and `u = uLam λ h` (the bracket of unit 0347's `re_A_sq`, at the
           shell). It is nonnegative when `tan θ ≤ (ε'² − Δ²)/(2ε'Δ)`; the crude
           sufficient condition, from `sin θ ≤ θ` and `cos θ ≥ 1 − 2θ/π` on
           `[0, π/2]`, is `θ·(2ε'Δ + 2(ε'² − Δ²)/π) ≤ ε'² − Δ²`. The phase at `h`
           is at most its value at `b`, since `uLam λ h ≤ h/(λπ²)` (the upper
           half of `uLam_bracket`, the correction `1/(2λ³π²(h+1))` being under
           the intercept `1/(2λ²π²)`). So every term is nonnegative and the
           shell sum is: these members help the target at every `h`.
Sizes.     For `Δ ≪ ε'` the condition reads `4ε'Δb/(λπ²) ≲ π/2`, i.e.
           `Δ ≲ λπ³/(8ε'b)`: exactly unit 0351's near boundary. Between it and
           the far bound of 13f (`Δ ≳ λ/(εX)` for a bound under the range) sits
           the shell 0351 prices. Lost factor: none; this block has no constant
           to lose, its output is a sign.
Regime.    R1 `0 < ε'`;  R3 `0 < Δ`;  N1 `Δ < ε'`;  R5 `0 < ε`;  L1 `1 ≤ λ` (ℕ);
           G4 `1 ≤ a` (ℕ);
           N2 `4ε'Δ·(b/(λπ²)) · (2ε'Δ + 2(ε'² − Δ²)/π) ≤ ε'² − Δ²`.
Defs.      none.
Theorems.  Written as the Lean statements the module carries; the builder
           copies them.
           uLam_nonneg — none —
             `theorem uLam_nonneg (lam h : ℕ) : 0 ≤ WeilPowerGeomGen.uLam lam h`
             (unfold; `mul_nonneg (sq_nonneg _)` and `WeilPowerPhase.sigma_ge` with
             `1/(π²(m+2)) ≥ 0`).
           uLam_le — L1, `1 ≤ h` —
             `theorem uLam_le {lam h : ℕ} (hl : 1 ≤ lam) (hh : 1 ≤ h) :
                WeilPowerGeomGen.uLam lam h ≤ (h : ℝ) / ((lam : ℝ) * Real.pi ^ 2)`
             (`uLam_bracket`'s right half; then `1/(2λ³π²)/(h+1) ≤ 1/(2λ²π²)`
             from `λ(h+1) ≥ 1`).
           cos_ge_lin — `0 ≤ θ`, `θ ≤ π/2` —
             `theorem cos_ge_lin {θ : ℝ} (h0 : 0 ≤ θ) (h1 : θ ≤ Real.pi / 2) :
                1 - 2 * θ / Real.pi ≤ Real.cos θ`
             (`Real.sin_pi_div_two_sub` backwards, `Real.mul_le_sin` at `π/2 − θ`).
           bracket_nonneg — R1, R3, N1, `0 ≤ θ`, `θ·(2ε'Δ + 2(ε'²−Δ²)/π) ≤ ε'² − Δ²` —
             `theorem bracket_nonneg {e' D θ : ℝ} (h1 : 0 < e') (h3 : 0 < D) (hD : D < e')
                (h0 : 0 ≤ θ) (hθ : θ * (2 * e' * D + 2 * (e' ^ 2 - D ^ 2) / Real.pi) ≤ e' ^ 2 - D ^ 2) :
                0 ≤ (e' ^ 2 - D ^ 2) * Real.cos θ - 2 * e' * D * Real.sin θ`
             (`θ ≤ π/2` from `hθ`, since the coefficient is at least `2(ε'²−Δ²)/π`
             and `ε'² − Δ² > 0`; then cos_ge_lin, `Real.sin_le h0`, and
             `nlinarith [mul_nonneg …]` on `(ε'²−Δ²)(1 − 2θ/π) − 2ε'Δθ ≥ 0`, which is
             `hθ` rearranged: a product of two bounded factors, pairs only).
           re_term_eq — R5 as `e ≠ 0` —
             `theorem re_term_eq (e' D e u : ℝ) (he : e ≠ 0) :
                (WeilPowerShell.coef e' D e * Complex.exp (WeilPowerShell.zOf e' D e * (u : ℂ))).re
                  = Real.exp (2 * (e' ^ 2 - D ^ 2 - e ^ 2) * u) / e ^ 2
                    * ((e' ^ 2 - D ^ 2) * Real.cos (4 * e' * D * u) - 2 * e' * D * Real.sin (4 * e' * D * u))`
             (`Complex.mul_re`, `Complex.exp_re`, `Complex.exp_im`; `coef.re = (ε'²−Δ²)/ε²`,
             `coef.im = 2ε'Δ/ε²` by `Complex.ext_iff` on
             `coef = ((ε'²−Δ²)/ε² : ℝ) + I·(2ε'Δ/ε² : ℝ)`, proved by `simp [coef]` then
             `field_simp`, `try ring`; `(zOf·u).re = 2(ε'²−Δ²−ε²)u`, `(zOf·u).im = 4ε'Δu`
             from `WeilPowerShell.zOf_re`, `zOf_im` and `Complex.mul_re`/`mul_im` with
             `Complex.ofReal_re`, `ofReal_im`; then `field_simp`, `try ring`).
           phase_le — R1, R3, L1, `1 ≤ h`, `h ≤ b` —
             `theorem phase_le {e' D : ℝ} {lam h b : ℕ} (h1 : 0 < e') (h3 : 0 < D)
                (hl : 1 ≤ lam) (hh : 1 ≤ h) (hhb : h ≤ b) :
                4 * e' * D * WeilPowerGeomGen.uLam lam h
                  ≤ 4 * e' * D * ((b : ℝ) / ((lam : ℝ) * Real.pi ^ 2))`
             (uLam_le, `h ≤ b` cast, `div_le_div_of_nonneg_right`, `mul_le_mul_of_nonneg_left`).
           term_nonneg — R1, R3, N1, R5, L1, `1 ≤ h`, `h ≤ b`, N2 —
             `theorem term_nonneg {e' D e : ℝ} {lam h b : ℕ} (h1 : 0 < e') (h3 : 0 < D)
                (hD : D < e') (h5 : 0 < e) (hl : 1 ≤ lam) (hh : 1 ≤ h) (hhb : h ≤ b)
                (hN : 4 * e' * D * ((b : ℝ) / ((lam : ℝ) * Real.pi ^ 2))
                        * (2 * e' * D + 2 * (e' ^ 2 - D ^ 2) / Real.pi) ≤ e' ^ 2 - D ^ 2) :
                0 ≤ (WeilPowerShell.coef e' D e
                      * Complex.exp (WeilPowerShell.zOf e' D e * ((WeilPowerGeomGen.uLam lam h : ℝ) : ℂ))).re`
             (re_term_eq; `mul_nonneg` of `exp/ε² ≥ 0` and bracket_nonneg at
             `θ = 4ε'Δ·uLam λ h`, whose `hθ` is N2 through phase_le and
             `mul_le_mul_of_nonneg_right` with the coefficient nonnegative; `0 ≤ θ`
             from uLam_nonneg).
           shellSum_nonneg — R1, R3, N1, R5, L1, G4, N2 —
             `theorem shellSum_nonneg {e' D e : ℝ} {lam a b : ℕ} (h1 : 0 < e') (h3 : 0 < D)
                (hD : D < e') (h5 : 0 < e) (hl : 1 ≤ lam) (ha : 1 ≤ a)
                (hN : 4 * e' * D * ((b : ℝ) / ((lam : ℝ) * Real.pi ^ 2))
                        * (2 * e' * D + 2 * (e' ^ 2 - D ^ 2) / Real.pi) ≤ e' ^ 2 - D ^ 2) :
                0 ≤ WeilPowerShell.shellSum e' D e lam a b`
             (unfold `shellSum`; `Finset.sum_nonneg`; `Finset.mem_Ico` gives
             `a ≤ h < b`, so `1 ≤ h` and `h ≤ b`; term_nonneg).
           shellSum_nonneg_abs — R1, `Δ ≠ 0`, `|Δ| < ε'`, R5, L1, G4, N2 with `|Δ|` —
             `theorem shellSum_nonneg_abs {e' D e : ℝ} {lam a b : ℕ} (h1 : 0 < e') (hD0 : D ≠ 0)
                (hD : |D| < e') (h5 : 0 < e) (hl : 1 ≤ lam) (ha : 1 ≤ a)
                (hN : 4 * e' * |D| * ((b : ℝ) / ((lam : ℝ) * Real.pi ^ 2))
                        * (2 * e' * |D| + 2 * (e' ^ 2 - |D| ^ 2) / Real.pi) ≤ e' ^ 2 - |D| ^ 2) :
                0 ≤ WeilPowerShell.shellSum e' D e lam a b`
             (cases on the sign of `D`, `abs_of_pos`/`abs_of_neg`; the negative
             case through `WeilPowerShell.shellSum_neg` at `-D`).
Composes.  Exact statements the module uses, so the builder opens no other module:
             `WeilPowerShell.shellSum_neg (e' D e : ℝ) (lam a b : ℕ) :
                shellSum e' (-D) e lam a b = shellSum e' D e lam a b`
             `WeilPowerShell.zOf_re (e' D e : ℝ) : (zOf e' D e).re = 2 * (e' ^ 2 - D ^ 2 - e ^ 2)`
             `WeilPowerShell.zOf_im (e' D e : ℝ) : (zOf e' D e).im = 4 * e' * D`
             `def WeilPowerShell.zOf (e' D e : ℝ) : ℂ := 2 * (((e' : ℂ) + Complex.I * (D : ℂ)) ^ 2 - (e : ℂ) ^ 2)`
             `def WeilPowerShell.coef (e' D e : ℝ) : ℂ := ((e' : ℂ) + Complex.I * (D : ℂ)) ^ 2 / (e : ℂ) ^ 2`
             `def WeilPowerShell.shellSum (e' D e : ℝ) (lam a b : ℕ) : ℝ :=
                ∑ h ∈ Finset.Ico a b,
                  (coef e' D e * Complex.exp (zOf e' D e * ((WeilPowerGeomGen.uLam lam h : ℝ) : ℂ))).re`
             `def WeilPowerGeomGen.uLam (lam h : ℕ) : ℝ := ((h : ℝ)) ^ 2 * WeilPowerPhase.sigma (lam * h - 1)`
             `WeilPowerGeomGen.uLam_bracket {lam h : ℕ} (hl : 1 ≤ lam) (hh : 1 ≤ h) :
                0 ≤ uLam lam h - ((h : ℝ) / ((lam : ℝ) * Real.pi ^ 2) - 1 / (2 * (lam : ℝ) ^ 2 * Real.pi ^ 2))
                ∧ uLam lam h - ((h : ℝ) / ((lam : ℝ) * Real.pi ^ 2) - 1 / (2 * (lam : ℝ) ^ 2 * Real.pi ^ 2))
                    ≤ 1 / (2 * (lam : ℝ) ^ 3 * Real.pi ^ 2) / ((h : ℝ) + 1)`
             `WeilPowerPhase.sigma_ge (m : ℕ) : 1 / (Real.pi ^ 2 * ((m : ℝ) + 2)) ≤ sigma m`
             (the `zOf_re`/`zOf_im` argument lists are as the 13f module declares
             them; if they differ, the builder reads the two lines, nothing more).
           Mathlib: Real.sin_pi_div_two_sub, Real.mul_le_sin, Real.sin_le (a `lemma`),
           Complex.exp_re, Complex.exp_im, Complex.mul_re, Complex.mul_im,
           Complex.ofReal_re, Complex.ofReal_im, Finset.mem_Ico,
           div_le_div_of_nonneg_right (a `lemma`), mul_le_mul_of_nonneg_left,
           mul_le_mul_of_nonneg_right, mul_nonneg, sq_nonneg, abs_of_pos,
           abs_of_neg, Finset.sum_nonneg (`to_additive` of `one_le_prod'`, Algebra/Order/BigOperators/Group/Finset.lean).
Module.    Stage3/WeilPowerNear.lean, namespace WeilPowerNear, importing
           WeilPowerShell; pins: term_nonneg, shellSum_nonneg, shellSum_nonneg_abs,
           bracket_nonneg. Built under the relay (LOOP.md § 4b), loop version 16.
Open.      none in this block; with 13f and 13g the members split into helping
           (this block), bounded (13f) and the shell between (unit 0351).
Arithmetic checked here: with `θ ≤ π/2`, `cos θ ≥ 1 − 2θ/π` and `sin θ ≤ θ`
give `(ε'²−Δ²)cos θ − 2ε'Δ sin θ ≥ (ε'²−Δ²) − θ(2(ε'²−Δ²)/π + 2ε'Δ) ≥ 0` by N2;
`θ ≤ π/2` from N2 because `θ · 2(ε'²−Δ²)/π ≤ θ · (coefficient) ≤ ε'² − Δ²`;
`uLam ≤ h/(λπ²)` because `1/(2λ³π²(h+1)) ≤ 1/(2λ²π²)` iff `λ(h+1) ≥ 1`;
`coef = (ε'² − Δ² + 2iε'Δ)/ε²`.

### 13h The clean shell: a sub-range no member blocks — PROVED (unit 0357:
`WeilPowerClean.blocked_card_le`, `exists_unblocked`, `exists_clean_shell`,
`exists_clean_shell_of_count`)
Objects.   The range `[a, b]` in `h` is cut into shells `[aρ^k, aρ^{k+1})`,
           `k = 0 .. K-1`, at a ratio `ρ > 1`. A member at `ζ = ε' + iΔ` is
           *blocked on shell k* when neither 13f nor 13g settles it there:
           13g's sign needs `Δ · X_k` below `lo`, 13f's bound is smaller than
           the shell's own length only when `Δ · X_k` is above `hi`, with
           `X_k = aρ^k` the shell's left end. So the blocking set of one
           member is `{k : lo ≤ Δ X_k ≤ hi}`, and because `X_k` climbs by the
           fixed factor `ρ` while the window `[lo, hi]` does not move, that set
           sits inside `W + 1` consecutive shells for any `W` with
           `hi < lo · ρ^{W+1}`. With `N` members, `N(W+1)` shells can be
           blocked; a `K` above that leaves one shell clean, and on a clean
           shell every member is settled by 13f or 13g.
Sizes.     `lo ≈ λπ³/(8ε')` from 13g's N2 at `Δ ≪ ε'`, and `hi ≈ Cλε'/ε²`
           from 13f's geometric part falling under the shell length. Their
           ratio `hi/lo ≈ 8Cε'²/(π³ε²)` carries no `λ`, no `h` and no `T`:
           with the target selected so that `ε' ≈ ε` (§ 8) it is an absolute
           constant, so `W` is one too. Range: `b/a = ρ^K` with `K > N(W+1)`,
           so `log(b/a) > N(W+1) log ρ`, and with `N ≤ c₁ log T' + c₂` the
           range is `T'` raised to `c₁(W+1) log ρ`. Letting `ρ → 1` with `W`
           following it, `(W+1) log ρ → log(hi/lo)`, so the route needs
           `c₁ · log(hi/lo) < 1`, and block 13i closes the circularity under
           exactly that condition (unit 0358: `exists_range_log`). That
           **corrects unit 0351's number**: its
           `1/(2 ln 1.5) ≈ 1.23` priced one blocked shell per member, and the
           window is wider than one shell. At a window ratio of `8` the
           requirement is `c₁ < 0.481`; Trudgian's `0.112` still clears it and
           the tree's crude chain at about `7` still does not, so the leaf
           the route hangs on is unchanged, only its constant.
           Lost factor: none. `W` is absolute, and the only quantity that
           grows is `K`, which is what the range buys.
Regime.    P1 `1 ≤ ρ`;  P2 `0 < lo`;  P3 `hi < lo · ρ^(W+1)`;
           P4 `S.card * (W + 1) < K`.  Nothing here needs `a > 0`, `Δ > 0` or
           an upper bound on `ρ`: the window hypothesis carries the work.
Defs.      none. The shell scale is written out as `a * ρ ^ k` so that the
           module states no definition and the checker counts `^def` as 0.
Theorems.  Written as the Lean statements the module carries; the builder
           copies them.
           blocked_card_le — P1, P2, P3 —
             `theorem blocked_card_le {a ρ lo hi d : ℝ} {W : ℕ} (B : Finset ℕ)
                (hρ : 1 ≤ ρ) (hlo : 0 < lo) (hW : hi < lo * ρ ^ (W + 1))
                (hB : ∀ k ∈ B, lo ≤ d * (a * ρ ^ k) ∧ d * (a * ρ ^ k) ≤ hi) :
                B.card ≤ W + 1`
             (`B` empty: `Nat.zero_le`. Otherwise `k₀ = B.min' hne`,
             `k₁ = B.max' hne`; `B ⊆ Finset.Icc k₀ k₁` from `Finset.min'_le`
             and `Finset.le_max'`, so `B.card ≤ k₁ + 1 - k₀` by
             `Finset.card_le_card` and `Nat.card_Icc`. Then `k₁ ≤ k₀ + W`:
             suppose `k₀ + W + 1 ≤ k₁`; write `ρ ^ k₁ = ρ ^ k₀ * ρ ^ (k₁ - k₀)`
             by `pow_add` and `Nat.sub_add_cancel`, use `lo ≤ d * (a * ρ ^ k₀)`
             from `hB` at `k₀` and `ρ ^ (W + 1) ≤ ρ ^ (k₁ - k₀)` from
             `pow_le_pow_right₀ hρ`, giving
             `lo * ρ ^ (W + 1) ≤ d * (a * ρ ^ k₁) ≤ hi`, against `hW`;
             `nlinarith` is the wrong tool here: one `mul_le_mul` on the two
             factor bounds does it. Finish with `omega`.)
           exists_unblocked — P4 —
             `theorem exists_unblocked {ι : Type*} [DecidableEq ι] (S : Finset ι)
                (B : ι → Finset ℕ) {K W : ℕ}
                (hB : ∀ j ∈ S, (B j).card ≤ W) (hK : S.card * W < K) :
                ∃ k, k < K ∧ ∀ j ∈ S, k ∉ B j`
             (`(S.biUnion B).card ≤ ∑ j ∈ S, (B j).card` by `Finset.card_biUnion_le`,
             `≤ ∑ j ∈ S, W` by `Finset.sum_le_sum`, `= S.card * W` by
             `Finset.sum_const` and `smul_eq_mul`. So that card is under
             `(Finset.range K).card`, hence `¬ (Finset.range K ⊆ S.biUnion B)`
             by contraposing `Finset.card_le_card` with `Finset.card_range`
             and `omega`; `Finset.not_subset` and `Finset.mem_biUnion` finish.)
           exists_clean_shell — P1, P2, P3, P4 —
             `theorem exists_clean_shell {ι : Type*} [DecidableEq ι] (S : Finset ι)
                (B : ι → Finset ℕ) (d : ι → ℝ) {a ρ lo hi : ℝ} {W K : ℕ}
                (hρ : 1 ≤ ρ) (hlo : 0 < lo) (hW : hi < lo * ρ ^ (W + 1))
                (hB : ∀ j ∈ S, ∀ k ∈ B j,
                   lo ≤ d j * (a * ρ ^ k) ∧ d j * (a * ρ ^ k) ≤ hi)
                (hK : S.card * (W + 1) < K) :
                ∃ k, k < K ∧ ∀ j ∈ S, k ∉ B j`
             (blocked_card_le at each `j`, then exists_unblocked at `W + 1`.)
           exists_clean_shell_of_count — P1, P2, P3 and the count —
             `theorem exists_clean_shell_of_count {ι : Type*} [DecidableEq ι]
                (S : Finset ι) (B : ι → Finset ℕ) (d : ι → ℝ)
                {a ρ lo hi : ℝ} {W K N : ℕ}
                (hρ : 1 ≤ ρ) (hlo : 0 < lo) (hW : hi < lo * ρ ^ (W + 1))
                (hB : ∀ j ∈ S, ∀ k ∈ B j,
                   lo ≤ d j * (a * ρ ^ k) ∧ d j * (a * ρ ^ k) ≤ hi)
                (hN : S.card ≤ N) (hK : N * (W + 1) < K) :
                ∃ k, k < K ∧ ∀ j ∈ S, k ∉ B j`
             (`Nat.mul_le_mul_right` on `hN`, then exists_clean_shell.)
Composes.  Exact statements, so the builder opens no other module:
             `Finset.card_le_card : s ⊆ t → #s ≤ #t`
             `Finset.card_range (n : ℕ) : #(range n) = n`
             `Finset.mem_range : m ∈ range n ↔ m < n`
             `Finset.not_subset : ¬s ⊆ t ↔ ∃ x ∈ s, x ∉ t`
             `Finset.card_biUnion_le [DecidableEq M] {s : Finset ι} {t : ι → Finset M} :
                #(s.biUnion t) ≤ ∑ a ∈ s, #(t a)`
             `Finset.mem_biUnion {b : β} : b ∈ s.biUnion t ↔ ∃ a ∈ s, b ∈ t a` (a `lemma`)
             `Finset.min'_mem : s.min' H ∈ s`
             `Finset.min'_le (x) (H2 : x ∈ s) : s.min' ⟨x, H2⟩ ≤ x`
             `Finset.max'_mem : s.max' H ∈ s`
             `Finset.le_max' (x) (H2 : x ∈ s) : x ≤ s.max' ⟨x, H2⟩`
             `Finset.mem_Icc : x ∈ Icc a b ↔ a ≤ x ∧ x ≤ b`
             `Nat.card_Icc : #(Icc a b) = b + 1 - a` (a `lemma`, `@[simp]`)
             `Finset.eq_empty_or_nonempty (s : Finset α) : s = ∅ ∨ s.Nonempty`
             `pow_le_pow_right₀ (ha : 1 ≤ a) (hmn : m ≤ n) : a ^ m ≤ a ^ n` (a `lemma`)
             `Finset.prod_const (b : M) : ∏ _x ∈ s, b = b ^ #s`, whose `to_additive`
                is `Finset.sum_const`
             `smul_eq_mul {α : Type*} [Mul α] (a b : α) : a • b = a * b` (a `lemma`)
           Also: Finset.sum_le_sum, pow_add, pow_nonneg, mul_le_mul,
           Nat.sub_add_cancel, Nat.mul_le_mul_right, mul_le_mul_of_nonneg_left,
           Nat.zero_le, le_trans, omega.
Module.    Stage3/WeilPowerClean.lean, namespace WeilPowerClean, importing
           Stage3.Statement only (this block touches no rung module); pins:
           blocked_card_le, exists_unblocked, exists_clean_shell,
           exists_clean_shell_of_count. Built under the relay (LOOP.md § 4b),
           at whatever `version:` line LOOP.md carries when the run starts.
Open.      the leaf. 13i names `StmtShortCount` with its constant `c₁` and
           derives it from `ArgCrude.StmtSCrude`, then instantiates `B j` from
           13f and 13g so that `hB` is discharged rather than assumed.
Arithmetic checked here: `hi/lo ≈ (Cλε'/ε²)(8ε'/(λπ³)) = 8Cε'²/(π³ε²)`, no `λ`;
`8/π³ = 0.258`; at ratio `8`, `1/ln 8 = 0.481`; unit 0351's `1/(2 ln 1.5) = 1.233`;
`ρ^k₁ = ρ^k₀ · ρ^(k₁-k₀)` needs `k₀ ≤ k₁`, which `Finset.min'_le`/`le_max'` give.

### 13i The short-interval count leaf, and the range that closes — PROVED
(unit 0358: `WeilPowerCount.card_le_of_leaf`, `exists_range_log`,
`count_lt_shells`, `exists_clean_shell_of_leaf`)
Objects.   Unit 0351 killed the route on a circularity: the range `[a, b]`
           has to hold more shells than there are members, the member count
           grows with the target's height `T'`, and `T'` grows with `b`
           through § 8's walk, `T' = T + μb` with `μ = 1/(8K'π²λ)`. At the
           tree's count `15 log T' + 73` the range had to exceed `T'` to a
           power above `6`. This block names the count as a leaf and proves
           the closure: when the leaf's leading constant is small enough the
           two demands meet at an explicit `b`, and the circularity is gone.
           Write `L = log b`, `D = log(T + μ)`, so `log T' ≤ D + L` for
           `b ≥ 1`; `lρ = log ρ`; `E` the constant shell overhead
           (`log a + lρ`). The shells fit when
           `(c₁ log T' + c₂)(W+1)lρ + E ≤ L`, and with `α = c₁(W+1)lρ < 1`
           that is a linear inequality in `L`, solved at
           `L = (c₂(W+1)lρ + E + αD)/(1 − α)`.
Sizes.     `α < 1` is the whole condition, and `(W+1)lρ → log(hi/lo)` as the
           shell ratio falls (13h), so the route needs `c₁ log(hi/lo) < 1`.
           `L` is linear in `D = log(T + μ)`, so `b` is polynomial in `T`
           with exponent `α/(1 − α)`: at `α = 1/2` the range is `T` squared,
           at `α = 1/4` it is `T` to the one third. Everything else in `L` is
           an additive constant. Lost factor: none; `1/(1 − α)` is the price
           of the leaf's constant and is bounded once `α` is.
Regime.    C1 `0 < lρ`;  C2 `0 ≤ c₁`;  C3 `0 ≤ c₂`;  C4 `0 ≤ D`;  C5 `0 ≤ E`;
           C6 `c₁·(W+1)·lρ < 1`, the closure condition;  and 13h's P1, P2, P3.
Defs.      the leaf, body and all, since a block that names one states it:
             `def StmtShortCount (cnt : ℝ → ℝ) (c₁ c₂ : ℝ) : Prop :=
                ∀ T : ℝ, 2 ≤ T → cnt T ≤ c₁ * Real.log T + c₂`
           Budget: `c₁ ≤ 0.48` at a window ratio of `8`, from 13h's
           `c₁ log(hi/lo) < 1`; `c₂` unconstrained. Route: Backlund's
           decomposition of `N(T+1) − N(T)` into the phase increment over `π`
           and `S(T+1) − S(T)`, the increment `≈ (1/2) log T` from Stirling
           and `|S| ≤ B₁ log T + B₃` from `ArgCrude.StmtSCrude`, giving
           `c₁ = 1/(2π) + 2B₁ ≈ 0.159 + 2B₁`. Trudgian 2014 has `B₁ = 0.112`,
           so `c₁ ≈ 0.383`, inside the budget; the tree's own crude chain has
           `B₁ ≈ 7` and is not. The floor `1/(2π) ≈ 0.159` is there even at
           `B₁ = 0`, so the budget is not vacuous. Citation shape: T. Trudgian,
           "An improved upper bound for the argument of the Riemann
           zeta-function on the critical line II", J. Number Theory 134 (2014).
Theorems.  Written as the Lean statements the module carries; the builder
           copies them.
           card_le_of_leaf — the leaf, `2 ≤ T` —
             `theorem card_le_of_leaf {ι : Type*} (S : Finset ι) {cnt : ℝ → ℝ}
                {c₁ c₂ T : ℝ} (hleaf : StmtShortCount cnt c₁ c₂) (hT : 2 ≤ T)
                (hS : (S.card : ℝ) ≤ cnt T) :
                (S.card : ℝ) ≤ c₁ * Real.log T + c₂`
             (unfold `StmtShortCount`; `le_trans hS (hleaf T hT)`.)
           exists_range_log — C1 to C6 —
             `theorem exists_range_log {c₁ c₂ lρ D E : ℝ} {W : ℕ}
                (hlρ : 0 < lρ) (hc₁ : 0 ≤ c₁) (hc₂ : 0 ≤ c₂) (hD : 0 ≤ D) (hE : 0 ≤ E)
                (hα : c₁ * ((W : ℝ) + 1) * lρ < 1) :
                ∃ L : ℝ, 0 ≤ L ∧ ∀ M : ℝ, 0 ≤ M → M ≤ D + L →
                  (c₁ * M + c₂) * ((W : ℝ) + 1) * lρ + E ≤ L`
             (set `α = c₁ * ((W:ℝ)+1) * lρ`, `G = c₂ * ((W:ℝ)+1) * lρ + E + α * D`,
             witness `L = G / (1 - α)`. `0 ≤ α` by
             `mul_nonneg (mul_nonneg hc₁ hW1) hlρ.le`, never `positivity`,
             which cannot read `hc₁` and `hlρ` from the context,
             `0 < 1 - α` by `linarith`, so `0 ≤ L`. For the bound, `(1 - α) * L = G`
             by `field_simp` alone with `(1 - α) ≠ 0` in context, no `ring` after, then
             `(c₁ M + c₂)(W+1)lρ + E ≤ α*(D + L) + c₂(W+1)lρ + E = G + α*L = L`
             by naming the product `c₁ * M * ((W:ℝ)+1) * lρ ≤ α * (D + L)` as a
             `have` from `mul_le_mul_of_nonneg_left`, then `linarith` on it;
             `nlinarith` is not needed.)
           count_lt_shells — C1 —
             `theorem count_lt_shells {N K W : ℕ} {lρ : ℝ} (hlρ : 0 < lρ)
                (h : ((N : ℝ) * ((W : ℝ) + 1) + 1) * lρ ≤ (K : ℝ) * lρ) :
                N * (W + 1) < K`
             (`le_of_mul_le_mul_right` at `hlρ` gives `(N:ℝ)*((W:ℝ)+1) + 1 ≤ (K:ℝ)`;
             `push_cast` and `Nat.cast_le` bring it to `ℕ`; `omega`.)
           exists_clean_shell_of_leaf — the leaf, C1 to C6, 13h's P1 P2 P3 —
             `theorem exists_clean_shell_of_leaf {ι : Type*} [DecidableEq ι]
                (S : Finset ι) (B : ι → Finset ℕ) (d : ι → ℝ)
                {cnt : ℝ → ℝ} {c₁ c₂ T a ρ lo hi : ℝ} {W K N : ℕ}
                (hleaf : StmtShortCount cnt c₁ c₂) (hT : 2 ≤ T)
                (hS : (S.card : ℝ) ≤ cnt T) (hN : c₁ * Real.log T + c₂ ≤ (N : ℝ))
                (hρ : 1 ≤ ρ) (hlo : 0 < lo) (hW : hi < lo * ρ ^ (W + 1))
                (hB : ∀ j ∈ S, ∀ k ∈ B j,
                   lo ≤ d j * (a * ρ ^ k) ∧ d j * (a * ρ ^ k) ≤ hi)
                (hK : N * (W + 1) < K) :
                ∃ k, k < K ∧ ∀ j ∈ S, k ∉ B j`
             (card_le_of_leaf then `hN` gives `(S.card : ℝ) ≤ (N : ℝ)`, so
             `S.card ≤ N` by `Nat.cast_le`; then
             `WeilPowerClean.exists_clean_shell_of_count`.)
Composes.  Exact statements, so the builder opens no other module:
             `WeilPowerClean.exists_clean_shell_of_count {ι : Type*} [DecidableEq ι]
                (S : Finset ι) (B : ι → Finset ℕ) (d : ι → ℝ)
                {a ρ lo hi : ℝ} {W K N : ℕ}
                (hρ : 1 ≤ ρ) (hlo : 0 < lo) (hW : hi < lo * ρ ^ (W + 1))
                (hB : ∀ j ∈ S, ∀ k ∈ B j,
                   lo ≤ d j * (a * ρ ^ k) ∧ d j * (a * ρ ^ k) ≤ hi)
                (hN : S.card ≤ N) (hK : N * (W + 1) < K) :
                ∃ k, k < K ∧ ∀ j ∈ S, k ∉ B j`
             `Nat.cast_le : (m : α) ≤ n ↔ m ≤ n`
             `div_mul_cancel₀` (used inside `field_simp`; see
                Algebra/Order/Field/Basic.lean, where it clears `x / c * c`)
           Also: le_trans, mul_le_mul_of_nonneg_right, le_of_mul_le_mul_right,
           sub_ne_zero, field_simp then `try ring`, push_cast, linarith, omega.
Module.    Stage3/WeilPowerCount.lean, namespace WeilPowerCount, importing
           Stage3.WeilPowerClean; pins: card_le_of_leaf, exists_range_log,
           count_lt_shells, exists_clean_shell_of_leaf. Built under the relay
           (LOOP.md § 4b), at whatever `version:` line LOOP.md carries when
           the run starts.
             The `0 ≤ M` hypothesis is unused by the proof and is kept, since
             the assembly reads `M = log T'` and will have it to hand.
Open.      the leaf itself, and the instantiation of `B` from 13f and 13g so
           that `hB` is discharged rather than assumed. Both are the assembly's,
           § 10.
Arithmetic checked here: with `α = c₁(W+1)lρ` and `L = G/(1−α)`,
`(1−α)L = G` so `G + αL = L`; `(c₁M + c₂)(W+1)lρ + E ≤ (c₁(D+L) + c₂)(W+1)lρ + E
= αD + αL + c₂(W+1)lρ + E = G + αL = L`. `1/(2π) = 0.159`; `0.159 + 2(0.112) = 0.383`;
`0.383 < 0.48`; `0.159 + 2(7) = 14.2`, outside. `b = e^L` is `T` to the `α/(1−α)`
times a constant, since `L = αD/(1−α) + const` and `D = log(T + μ)`.

### 13j The term at an actual zero: two sidebands, the far one bounded — SKETCH
Objects.   Every module of blocks 13a–13i is about `S m w` for a free
           complex `w`. The term of the zero form at a zero `ρ` is, from
           `WeilPowerBackground.term_re_eq` and `WeilOddPower.what_eq`,
           `termW h γ m ρ = −(h/2)² · Re((S m w₊ + S m w₋)²)` with
           `w± = (ρ − 1/2 ± iγ)·h`: the window is a cosine at height `γ`
           times an envelope, so a zero is read at two sidebands. Expanding,
           `−(h/2)²[Re(S₋²) + 2Re(S₊S₋) + Re(S₊²)]`. Block 13b bounds `Re(S₋²)`
           below (`re_S_sq_ge`); nothing bounds the other two. The far sideband
           has `Im w₊ = (Im ρ + γ)h`, about `2γh`, and § 4's far bound
           `WeilPowerBounds.norm_S_le_far` gives `‖S m w₊‖ ≤ cS m · cosh(Re w₊) ·
           (2/Im w₊²)^{m+1}` once `2(Re w₊² + π²(m+1)²) ≤ Im w₊²`. This block
           is the connection the ladder never made: it states the term at
           `ρ : Kadiri.NontrivialZeros`, an actual nontrivial zero.
Sizes.     `‖S m w₊‖ ≤ cS m · cosh(ε'h) · (2/((Im ρ + γ)h)²)^{m+1}`; with
           `(Im ρ + γ)h ≥ 2γh − h/2` and `m + 1 = λh` this is
           `cS m · e^{ε'h} · (1/(2γ²h²))^{λh}`, super-exponentially small in
           `h` for `γ ≥ 2`, against `Re(S₋²) ~ c²ε'²h²e^{2ε'²h/(π²λ)}`. The cross
           term is `2‖S₊‖‖S₋‖`, the same order times `‖S₋‖`. Lost factor: none;
           the far sideband is the § 4 decay and it is the only new thing.
Regime.    F1 `0 < h`;  F2 `2 · ((Re ρ − 1/2)² h² + π²(m+1)²) ≤ ((Im ρ + γ) h)²`,
           the far condition at `w₊`, which is `(Im ρ + γ)² ≥ 2((Re ρ − 1/2)² + π²λ²)`;
           and for the last theorem block 13b's regime at `w₋`:
           F3 `QS m w₋ ≠ 0`;  F4 `‖w₋‖² ≤ π²(m+2)²/2`;  F5 `q m w₋ ≤ 1`.
Defs.      `def wp (h γ : ℝ) (ρ : ℂ) : ℂ := (ρ - 1 / 2 + Complex.I * (γ : ℂ)) * (h : ℂ)`
           `def wm (h γ : ℝ) (ρ : ℂ) : ℂ := (ρ - 1 / 2 - Complex.I * (γ : ℂ)) * (h : ℂ)`
Theorems.  Written as the Lean statements the module carries; the builder
           copies them.
           im_sq_sub_re_sq — none —
             `theorem im_sq_sub_re_sq (z : ℂ) : z.im ^ 2 - z.re ^ 2 = -(z ^ 2).re`
             (`simp [pow_two, Complex.mul_re]` closes it; compiled in Scratch.lean
             on 2026-09-07.)
           term_eq_sidebands — F1 —
             `theorem term_eq_sidebands {h : ℝ} (hh : 0 < h) (γ : ℝ) (m : ℕ) (ρ : ℂ) :
                WeilPowerBands.termW h γ m ρ
                  = -((h / 2) ^ 2 * (((S m (wm h γ ρ)) ^ 2).re
                      + 2 * (S m (wp h γ ρ) * S m (wm h γ ρ)).re
                      + ((S m (wp h γ ρ)) ^ 2).re))`
             (unfold `termW`; `rw [term_re_eq hh, what_eq hh, im_sq_sub_re_sq]`;
             then `((h:ℂ)/2)^2 = (((h/2)^2 : ℝ) : ℂ)` by `push_cast; ring`,
             `Complex.re_ofReal_mul`, `Complex.add_re`, `Complex.mul_re`, `ring`.
             Both halves compiled in Scratch.lean; `wp`/`wm` are the two arguments
             of `what_eq` with `z = ρ − 1/2`, which `ring` identifies.)
           term_le_sidebands — F1 —
             `theorem term_le_sidebands {h : ℝ} (hh : 0 < h) (γ : ℝ) (m : ℕ) (ρ : ℂ) :
                WeilPowerBands.termW h γ m ρ
                  ≤ -((h / 2) ^ 2 * (((S m (wm h γ ρ)) ^ 2).re
                      - 2 * ‖S m (wp h γ ρ)‖ * ‖S m (wm h γ ρ)‖
                      - ‖S m (wp h γ ρ)‖ ^ 2))`
             (term_eq_sidebands, then `Complex.re_le_norm` on the cross and far
             products with `norm_mul` and `Complex.norm_pow`, and
             `neg_le_neg`, `mul_le_mul_of_nonneg_left` with `0 ≤ (h/2)^2`;
             the direction: a larger bracket makes the term more negative,
             and `Re(S₊S₋) ≥ −‖S₊‖‖S₋‖`, `Re(S₊²) ≥ −‖S₊‖²`.)
           wp_re, wp_im — none —
             `theorem wp_re (h γ : ℝ) (ρ : ℂ) : (wp h γ ρ).re = (ρ.re - 1 / 2) * h`
             `theorem wp_im (h γ : ℝ) (ρ : ℂ) : (wp h γ ρ).im = (ρ.im + γ) * h`
             (`simp [wp, Complex.mul_re, Complex.mul_im]`; `ring` if left over.)
           far_sideband_le — F2 —
             `theorem far_sideband_le {h γ : ℝ} {m : ℕ} {ρ : ℂ}
                (hfar : 2 * (((ρ.re - 1 / 2) * h) ^ 2 + Real.pi ^ 2 * ((m : ℝ) + 1) ^ 2)
                          ≤ ((ρ.im + γ) * h) ^ 2) :
                ‖S m (wp h γ ρ)‖
                  ≤ cS m * Real.cosh ((ρ.re - 1 / 2) * h) * (2 / ((ρ.im + γ) * h) ^ 2) ^ (m + 1)`
             (`WeilPowerBounds.norm_S_le_far` at `w = wp h γ ρ`, with `wp_re`, `wp_im`
             rewritten into its hypothesis and conclusion.)
           term_le_at_zero — F1, F2, F3, F4, F5 —
             `theorem term_le_at_zero {h γ : ℝ} {m : ℕ} (hh : 0 < h) (ρ : Kadiri.NontrivialZeros)
                (hfar : 2 * ((((ρ : ℂ).re - 1 / 2) * h) ^ 2 + Real.pi ^ 2 * ((m : ℝ) + 1) ^ 2)
                          ≤ (((ρ : ℂ).im + γ) * h) ^ 2)
                (hne : QS m (wm h γ (ρ : ℂ)) ≠ 0)
                (hsmall : ‖wm h γ (ρ : ℂ)‖ ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2)
                (hq : q m (wm h γ (ρ : ℂ)) ≤ 1) :
                WeilPowerBands.termW h γ m (ρ : ℂ)
                  ≤ -((h / 2) ^ 2 *
                      ((cS m / D m) ^ 2 * Real.exp (2 * ((wm h γ (ρ : ℂ)) ^ 2).re * sigma m)
                          * (((wm h γ (ρ : ℂ)) ^ 2).re
                              * Real.cos (2 * ((wm h γ (ρ : ℂ)) ^ 2).im * sigma m)
                            - ((wm h γ (ρ : ℂ)) ^ 2).im
                              * Real.sin (2 * ((wm h γ (ρ : ℂ)) ^ 2).im * sigma m))
                        - (cS m / D m) ^ 2 * ‖wm h γ (ρ : ℂ)‖ ^ 2
                          * Real.exp (2 * ((wm h γ (ρ : ℂ)) ^ 2).re * sigma m)
                          * (4 * q m (wm h γ (ρ : ℂ)) + 4 * q m (wm h γ (ρ : ℂ)) ^ 2)
                      - 2 * (cS m * Real.cosh (((ρ : ℂ).re - 1 / 2) * h)
                              * (2 / (((ρ : ℂ).im + γ) * h) ^ 2) ^ (m + 1)) * ‖S m (wm h γ (ρ : ℂ))‖
                      - (cS m * Real.cosh (((ρ : ℂ).re - 1 / 2) * h)
                              * (2 / (((ρ : ℂ).im + γ) * h) ^ 2) ^ (m + 1)) ^ 2))`
             (term_le_sidebands at `(ρ : ℂ)`; then `WeilPowerPhase.re_S_sq_ge hne hsmall hq`
             for the first piece and far_sideband_le for `‖S m w₊‖` in the other two,
             through `mul_le_mul` with the norms nonnegative and `pow_le_pow_left₀`;
             chain with `neg_le_neg` and `mul_le_mul_of_nonneg_left`. The
             statement is long because it is explicit; that is the point.)
Composes.  Exact statements, so the builder opens no other module:
             `WeilPowerBands.termW (h γ : ℝ) (m : ℕ) (ρ : ℂ) : ℝ :=
                (laplace (phiWC h γ m) (-ρ) * laplace (phiWC h γ m) (-(1 - ρ))).re`
             `WeilPowerBackground.term_re_eq {h : ℝ} (hh : 0 < h) (γ : ℝ) (m : ℕ) (ρ : ℂ) :
                (laplace (phiWC h γ m) (-ρ) * laplace (phiWC h γ m) (-(1 - ρ))).re
                  = (what h γ m (ρ - 1 / 2)).im ^ 2 - (what h γ m (ρ - 1 / 2)).re ^ 2`
             `WeilOddPower.what_eq {h : ℝ} (hh : 0 < h) (γ : ℝ) (m : ℕ) (z : ℂ) :
                what h γ m z = ((h : ℂ) / 2) *
                  (S m ((z + Complex.I * (γ : ℂ)) * (h : ℂ)) + S m ((z - Complex.I * (γ : ℂ)) * (h : ℂ)))`
             `WeilPowerBounds.norm_S_le_far {m : ℕ} {w : ℂ}
                (hfar : 2 * (w.re ^ 2 + Real.pi ^ 2 * ((m : ℝ) + 1) ^ 2) ≤ w.im ^ 2) :
                ‖S m w‖ ≤ cS m * Real.cosh w.re * (2 / w.im ^ 2) ^ (m + 1)`
             `WeilPowerPhase.re_S_sq_ge {m : ℕ} {w : ℂ} (hne : QS m w ≠ 0)
                (hsmall : ‖w‖ ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2) (hq : q m w ≤ 1) :
                (cS m / D m) ^ 2 * Real.exp (2 * (w ^ 2).re * sigma m)
                    * ((w ^ 2).re * Real.cos (2 * (w ^ 2).im * sigma m)
                      - (w ^ 2).im * Real.sin (2 * (w ^ 2).im * sigma m))
                  - (cS m / D m) ^ 2 * ‖w‖ ^ 2 * Real.exp (2 * (w ^ 2).re * sigma m)
                    * (4 * q m w + 4 * q m w ^ 2)
                  ≤ ((S m w) ^ 2).re`
             `Kadiri.NontrivialZeros` (a subtype of `ℂ`; `(ρ : ℂ)` is its coercion,
             used exactly as `WeilPowerOnLine.weightedTermW_conjZ` uses it).
           Mathlib: Complex.re_le_norm, Complex.abs_re_le_norm, norm_mul,
           Complex.norm_pow, Complex.mul_re, Complex.mul_im, Complex.add_re,
           Complex.re_ofReal_mul, neg_le_neg, mul_le_mul, mul_le_mul_of_nonneg_left,
           pow_le_pow_left₀, norm_nonneg, sq_nonneg.
Module.    Stage3/WeilPowerBridge.lean, namespace WeilPowerBridge, importing
           Stage3.WeilPowerPhase, Stage3.WeilPowerBands and Stage3.WeilPowerBounds
           (`WeilPowerBands` for `termW`, which imports `WeilPowerBackground`);
           `open WeilOddPower WeilPowerBackground WeilPowerPhase WeilPowerBounds`
           as those modules do; pins: term_eq_sidebands, term_le_sidebands,
           far_sideband_le, term_le_at_zero. Built under the relay (LOOP.md § 4b).
Open.      with this block every module of the ladder is attached to an actual
           zero. The size question for the whole term, sidebands included, is
           priced next on this statement rather than on `S` alone.
Arithmetic checked here: `Im(X)² − Re(X)² = −Re(X²)`; `X = (h/2)(S₊ + S₋)` so
`X² = (h/2)²(S₋² + 2S₊S₋ + S₊²)` and the real part distributes; `Re(z) ≥ −‖z‖`
gives `Re(S₊S₋) ≥ −‖S₊‖‖S₋‖` and `Re(S₊²) ≥ −‖S₊‖²`; `(Im ρ + γ)h` at
`Im ρ ≈ γ` is `2γh`; `(2/(2γh)²)^{λh} = (1/(2γ²h²))^{λh}`.

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


Resolved in block 13e (2026-09-06): `λ` is a free integer parameter with
`λ³ ≥ 4N e^{K'} |ζ|⁴ H/(π⁴ε²)`, polynomial in `N`, `e^{K'}`, `1/ε` and the
range; blocks 13c–13d were stated at `λ = 1` and 13e restates the
geometric bound with the slope free.