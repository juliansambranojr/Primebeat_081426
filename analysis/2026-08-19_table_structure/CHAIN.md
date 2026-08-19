# The chain, from the whip to the sub-integer zeros

2026-08-19. A record of how the current state was reached, in order, with
the pushbacks in both directions. Written to be a regression check: the
claims marked **standing** are what a later run should reproduce, and the
ones marked **killed** should stay killed.

Nothing here is preregistered. No verdict is claimed anywhere.

---

## 1 · The whip

**Observation (Julian).** Reading eight per-base panels of test 04 by eye:
dyadic even, triadic pulls down taut like yanking a bedsheet, tetradic
smooths, pentadic pulls down again, hexadic pulls from the left, heptadic
smooths, octadic aggressive on the left, enneadic evens out with the pull
on the left. *"It's like a tug of war for balance on both sides. It's like
a whip."*

**First test — wrong.** I re-ran everything at a taller ceiling to see if
the pattern was stable, and reported that it wasn't.

**Pushback (Julian), twice, both correct.** *"You keep changing the shape
by adding more, which changes the finding — it's not the same shape.
You're making me chase."* And: *"if you're adding more then you're just
doing the explicit formula and smoothing it out as you add more primes."*

Both hold. Raising the ceiling from 2³² to 2⁴⁸ takes base 8 from ten rungs
to sixteen — a different window, not more confidence in the same one. And
the explicit formula is asymptotic, so the taller ceiling samples where li
approximates π better and agreement improves for reasons unrelated to any
structure. **The ceiling comparison was biased toward the result it
produced and should not have been run.**

**Retest at the ceiling he actually looked at.** Characterised each curve
where it stood: median level, depth of the dip, position along its own run.

**Standing.** His reading matched the measurement on all eight — level,
severity, and which side. Drop sequence `0.27 0.57 0.08 1.44 0.55 0.12
0.84 0.16`, low-high alternating, dip at the left for hexadic onward,
triadic's uniquely mid-run, pentadic's uniquely at the right.

---

## 2 · Sign flips

**Observation (Julian).** The alternation matches the dyadic sign flips
by delta.

**Test.** Laid the dyadic leading-sign sequence against the drop sequence.

**Standing, partially.** Mapping `+ → low drop`, `− or 0 → high`, the
first four bases match and the last four are *exactly inverted*. Not
"perfect" and not scattered — a clean break at the midpoint. Eight binary
calls is a small thing to read a break in, and it is recorded as observed
rather than claimed.

**Question (Julian).** What happens when signs converge — `++`, `+−+`,
`−−−`?

**This turned out to be the mechanism.** `cell(r,d+1) = cell(r,d) −
cell(r−1,d)`, so adjacent same-sign cells subtract toward each other and
cancel; opposite-sign cells subtract apart and reinforce. A run of one
sign is the smooth mode, which is why it dies at ×0.5. Alternation is
oscillation, which is why it grows at ×1.68.

**Standing.** The crossover is countable in signs with no transform at
all. Sign-flip density first passes 0.5 at depth **7** in the dyadic
table, matching the spectral crossover of **7** exactly — two measurements
sharing no method. Triadic gives 12 against a spectral 10. Bases 4–9 read
**0.00 at every depth**: not one sign change anywhere.

---

## 3 · Ground state

**Observation (Julian).** Zero flips at the higher bases does not mean
nothing is there — the flips collapsed through the coarser steps and what
remains is a residual. *"Like a ground state."*

**Standing, exactly.** Base 4's rungs span two consecutive dyadic rungs,
base 8's span three — verified cell for cell. `N₄(r) = N₂(2r−1) + N₂(2r)`.
The coarse table **is** the dyadic one summed in blocks.

Summing is a low-pass. Against γ₁'s dyadic alias ω = 2.7689 the Dirichlet
kernel leaves **18.5%** at k=2, **28.8%** at k=3, **17.3%** at k=4, while
the smooth mode — frequency zero — survives at **100% for every k**.

And the flat rows reproduce from dyadic data alone: block-summing the
dyadic rungs by hand gives 0.00 flip density at merge 2 and merge 3,
identical to bases 4 and 8, with no base-4 or base-8 data involved.

---

## 4 · Does absorbing make a zero?

**Question (Julian).** Do the residuals absorb into one and collapse into
a zero as you sample?

**Killed.** Coarsening *destroys* zeros. Block-summing the dyadic table
gives 4 zeros at merge 1 — `(2,1) (4,1) (8,3) (20,6)` — and **zero** at
every merge from 2 through 6.

The reason is in the seed rows. `1, 1, 2, 2, 5, 7` at k=1 crawls; `4, 14,
79, 467, 2948` at k=3 grows sevenfold a step. Differences of a
fast-growing positive sequence have nothing to cancel against.
Cancellation needs the ladder to nearly stall, which base 2 does at the
start and no coarser base does anywhere.

---

## 5 · Sediment and the pond

**Model (Julian).** Each base inherits an already-settled state from
below, so the visible transient shrinks with b. *"Like a pond getting more
still over time, but from above — underneath the water is still moving.
We're looking at it from above but reading it from underneath."*

**Correction.** Base 3 inherits nothing from base 2 — `log 3 / log 2` is
irrational, the rungs never coincide. The chains are `2 → 4 → 8 → 16` and
`3 → 9`; bases **5, 6 and 7 have no parent at all**.

**Killed.** Every base carries the same oscillatory fraction at depth 0 —
0.520 to 0.535, all eight. Orphan mean 0.5242, chain mean 0.5321; the
spread inside each group exceeds the gap between them. **Settling is not
inherited.** Every base starts identical and settles at a rate set by
`ln b`.

**Standing, and it is the pond.** Base 9 carries 53% of its power in
oscillation and has **zero sign changes anywhere**. The surface is glass
and the motion is undiminished. Invisible to anything that reads signs.

**Reframe (mine).** Under depth it is the *trend* that settles out — the
smooth mode halves each step while the oscillation grows. So the sediment
is the part you already knew, and depth leaves the oscillation suspended
in clearer water. Two distinct processes: **depth separates** and loses
nothing; **coarsening blurs**.

---

## 6 · The film frame

**Pushback (Julian).** *"The information isn't gone."* It is moving slower
relative to the sampling, and at some filter it becomes visible again —
like seeing a ball move through enough frames.

**Correct, and I had overstated it.** Block-summing does two things and I
counted one. It attenuates (the kernel) **and** it decimates, and
decimation aliases: `ω → kω mod 2π`. The mode moves to a new frequency
rather than vanishing. Wagon wheel.

**Standing.** `fold(k × parent's alias)` equals `fold(γ₁ · ln b)` computed
fresh, for bases 4, 8, 16, 9 and 27, to machine precision. Aliases at
0.7453, 2.0236, 1.4907, 0.3588, 2.6035 — wandering, not decreasing.

**New observation.** Base 9's alias lands at 0.3588 rad per rung and
fifteen rungs gives **0.86 of a cycle**. Under one full oscillation across
the whole ladder. Base 9 is not quiet like 4–7; it is *slow*. Different
failure, same flat picture.

---

## 7 · Orthogonal, and the pyramid

**Observation (Julian).** If sequence, depth and sampling all matter, the
spectrum lives in the relationships among all three, not as a property of
any one.

**Correct.** A mode's phase is `r·γ ln b + d·arg(1 − b^(−ρ))` — linear in
both, so each zero is a *plane* over the (r,d) rectangle with a
two-component frequency. Every spectrum before this projected one axis
away.

**Built it. Killed.** Closest pair of modes: **0.0645** rad along ω_r
alone, **0.0694** in the full plane. The depth axis buys nothing — the
modes are packed tighter in ω_d than in ω_r, and it is the worse-resolved
axis besides (0.393 against 0.190). Power at the predicted points is low:
γ₁ at 0.271, γ₃/γ₆/γ₈ at 0.002–0.005.

**Model (Julian).** Not 2D but 3D — build it as a pyramid, everything
inside is the spectra, *"bounding it to itself to see itself,"* like
solving infinite sums by bounding them in a circle.

**This was the productive one.** Put every sample at its true position
`u = ln x = r·ln b` and a zero's frequency is simply `γ` — no `ln b` in
it. Every base carries the same frequency; only the spacing differs. Eight
incommensurate samplings of one function.

**Standing.** Each base alone shows its alias comb exactly: base 2 gives
five peaks at *identical* 0.486 spaced 9.065 apart, which is `2π/ln 2`;
base 3 at `2π/ln 3`. Combining bases **breaks the degeneracy** — the equal
peaks become unequal — exactly as the construction predicts.

**But killed on the target.** No γ is recovered from the combined set. Top
peak 36.408 against a nearest zero of 37.586, off by 1.18 with resolution
0.2. And 36.4 persists across every combination, which an alias would not.
Unexplained.

---

## 8 · The floor

**Question (Julian).** What do we have that will let it see itself?

**Answer.** Not resolution — the window in `u` is 32 wide and the zeros
are 5 apart. **Sample density.** And depth cannot help: the dyadic table
is determined by its 48 seed values, so differencing adds no information
whatsoever.

Samples sit every `ln b` in `u`, so to get γ₁ under Nyquist:

`π / ln b > γ₁`  →  **b < exp(π/γ₁) = 1.2489**

which is Julian's own optimal base, derived months earlier for an
unrelated reason. The k=2 member of that family is exactly the threshold
where the first zeta zero stops aliasing.

**Standing, and the strongest positive result of the session.** At
b = 1.1175 the top peak of the periodogram is **14.158** against
γ₁ = 14.1347 — within a tenth of a resolution element. Fourth peak 25.044
against γ₃ = 25.011.

**Observation (Julian).** The ones drifting from the peak might belong to
a different base.

**Standing, seven for seven.** Each zero has its own threshold
`exp(π/γ_k)`. Stepping the base down, each base finds exactly the zeros
beneath its own Nyquist and not one more:

```text
base      Nyquist   under Nyq   found
1.2000     17.23        1       γ1
1.1500     22.48        2       γ1 γ2
1.1175     28.28        3       γ1 γ2 γ3
1.1100     30.10        3       γ1 γ2 γ3
1.0950     34.62        5       γ1 … γ5
1.0850     38.51        6       γ1 … γ6
1.0750     43.44        8       γ1 … γ7
```

Recovered: 14.141, 21.022, 25.016, 30.449, 32.924, 37.645, 40.933 against
true 14.1347, 21.0220, 25.0109, 30.4249, 32.9351, 37.5862, 40.9187.

**And the consequence for the object this project is about.** Base 2's
Nyquist is **4.53**, below every threshold on that list. The dyadic table
cannot see any zeta zero directly — not at any depth, not at any ceiling.
Structural, not a resolution problem.

*Framing (Julian): converging to the explicit formula is the floor, not
the finding. It would be worse if we hadn't.*

---

## 9 · Attractors

**Model (Julian).** The suppressed flips are still coupled inside each
sediment layer and act as attractors on the dyadic table — aligning
vertically, spacing horizontally.

The coupling half is proven rather than conjectured: base 4 *is* the
dyadic pairs.

**Killed, twice, both times by the instrument.**

*Divisibility.* Base 2^k visits dyadic rungs at multiples of k. Those
columns look identical to the ones it skips — p from 0.23 to 0.77 across
k = 2…6. The zeros' divisor counts are 2, 3, 4, 6 against a mean of 3.72.

*Coverage.* How many b-rungs fall inside each dyadic cell's window takes
**at most two values at any fixed depth**, because a fixed-width log
window always holds the same number of rungs up to a floor wobble.
Coverage is depth wearing another name, and the z ≈ −1.0 at every base was
the zeros being shallow.

*Phase.* `frac((r−d−1)·ln2/ln b)` does vary cell to cell and bands along
`r−d` as predicted. But `(2,1)` sits at phase 0 for every base trivially
(`r−d−1 = 0`), and bases 4 and 8 are degenerate because `ln2/ln4 = 1/2`
and `ln2/ln8 = 1/3` are rational. Three informative zeros left. Nothing
can be concluded at n = 3.

---

## 10 · The sample that could carry it

Four constructions in a row hit the same wall: four zeros cannot support a
claim about where zeros sit. The sub-integer scan has **121 resolved
zeros** across ten bases, and none of the tests had been pointed at it.

**O42's question, re-asked with power.** Winding phase
`Φ = γ₁·r·ln b + d·arg(1 − b^(−ρ))`, null drawn from the resolved support
itself and stratified per base so the composition matches.

**Standing — the null holds.** R = 0.1142 against 0.0924 ± 0.0480,
z = +0.46, **p = 0.30**. O42's `no_constant_angle` was not a sample-size
problem. There is no constant angle.

**Scale coordinate `r−d`.** Raw z = **−9.17**, p < 1/20001. Zeros at
median r−d 22 against the support's 47.

**Killed by its own control.** Matching support cells on `ln S` within
±0.35 collapses it: observed 26.744, matched null 25.731 ± 0.747,
**z = +1.36, p = 0.909**. The correlation between `r−d` and `ln S` is only
−0.199 — but zeros are drawn from the extreme thin tail of S, and
selecting that hard on one variable shifts anything weakly correlated with
it. A z of −9 out of a correlation of −0.2 is what tail selection does.

---

## 11 · The third decimal

**Observation (Julian).** The ladder recovers 14.158 where the zero is
14.1347 and the excuse was "inside the resolution element." What if that
disagreement is structural rather than a bug — zeta is an infinite sum,
and we are taking something local and asking it to measure the whole.

**Test.** Sweep the ceiling. Same base 1.1175405, same construction, the
window in `u` extended from 2²⁸ to 2⁴⁸ — each sample set a prefix of the
next, never resampled. If the displacement is resolution, doubling the
span must halve it.

**Standing.** It does not converge. Span 14.67 → 28.56, resolution 0.4283
→ 0.2200, and the error for γ₁ goes `+0.0160 +0.0249 +0.0334 +0.0138
+0.0228 +0.0221` — wandering, no trend. Measured in resolution elements
it therefore **grows, 0.037 to 0.101**. γ₃ does the same: `+0.0469
+0.0379 +0.0238 +0.0302` over 2³⁶…2⁴⁸. Whatever moves the peak is not the
shortness of the window.

**A correction.** I had called the bias systematically positive. That was
read off γ₁ and γ₃ only. γ₂'s error is **−0.0051** — negative, and the
smallest of the three. There is no consistent sign.

**Observation (Julian).** Decompose it the way zeta composes, see what
survives, and divide that over zeta.

**Killed, as the explanation.** The candidate was mutual leakage: each
zero sitting on the skirts of the others, so fitting one at a time
measures a blend. It is testable because leakage among zeros we can see
is leakage we can subtract. Base 1.1175405 has Nyquist `π/ln b = 28.27`,
so of twelve zeros the visible set is three — 14.135, 21.022, 25.011.
Re-estimating each on a residual with the other two already removed,
iterated to a fixed point, moves the errors from `+0.0221 −0.0051
+0.0302` to `+0.0218 −0.0028 +0.0266`. Mean |error| 0.0191 → 0.0170, a
ratio of **0.89**. Removing every zero the base can see removes about a
tenth of the bias. Nine tenths is untouched, so leakage among the visible
zeros is not what displaces the peaks.

**Standing, and it is the answer.** The three visible zeros held at their
true frequencies explain **0.1291** of the variance. The residual carries
**0.8671** — eighty-seven per cent of the signal is content above 28.27,
folded down by aliasing onto frequencies beneath it. The strongest
survivors are 23.602, 1.298, 26.114, 1.541, 3.572, and **not one of them
is within 0.4 of any zeta zero**, which is exactly what folded content
looks like: real structure at frequencies that are nobody's γ. It is in
every sample and it cannot be subtracted, because subtracting it would
require knowing where it landed and aliasing is the operation that
destroys that.

**And it explains section 8's ceiling.** A longer ladder does not help
because more rungs at the same base extend the window without lowering
`π / ln b`. The 13/87 split is fixed by the base, not by how far up you
count. The only lever is a smaller base — which is the same lever
section 8 already found, now with the cost of *not* pulling it measured.

---

## 12 · The prediction that followed, and did not hold

**Prediction (mine, not Julian's).** If the bias is the aliased majority
pushing the peak around, then a finer base — which sees more zeros and so
carries a larger visible fraction — must show a smaller bias. Monotone,
and testable in one sweep.

**Test.** Ten bases from 1.2000 down to 1.0200 at ceiling 2⁴⁴, sixty zeros
considered, same construction throughout. Per base: Nyquist, how many zeros
sit beneath it, the variance those visible zeros jointly explain at their
true frequencies, and the solo error on γ₁. Visible fraction climbs 0.0530
→ 0.2498 as the visible set goes from one zero to fifty-seven. Correlation
against |error|: **r = −0.642, t = −2.37** on ten points. Right sign, and
at a glance it is the prediction landing.

**Killed by the jackknife.** Drop the single coarsest base, 1.2000, and
the correlation goes to **r = −0.259, t = −0.71**. Every other single drop
leaves r between −0.62 and −0.76. One point of ten carries the whole
thing: 1.2000 sees exactly one zero and its error, +0.0438, is three times
the next largest, so it sits alone in the corner and drags the line through
itself. The other nine errors span a factor of **7.7** with no relation to
visible fraction at all. Retracted, not reported.

**Standing, and I did not predict it.** The visible fraction **saturates
near 0.25**. One zero to two gains 0.0363 of it; forty-one to fifty-seven
gains 0.0168. At base 1.0200 — Nyquist **158.65**, fifty-seven zeros
beneath it, **1308** samples — the fraction is still only 0.2498, so three
quarters of the signal remains irreducibly aliased. Each zero contributes
about `1/γ²`, so the series over zeros converges: the reachable fraction
has a limit and refining the base cannot buy past it. Section 8's lever is
real and it is bounded, and this is where it stops.

**And a third wrong sign.** Base 1.0500's error is **−0.0069**. With γ₂'s
−0.0051 from the ceiling sweep that is the third negative error on the
record. "Systematically positive" is closed out for good.

---

## Where it stands

**Standing:** the block-sum identity and its low-pass; decimation
aliasing to machine precision; sign flips reproducing the crossover;
every base starting at the same oscillatory fraction; the per-zero
visibility threshold `exp(π/γ_k)` confirmed in order across seven bases;
base 2 lying above all of them; the recovered γ not converging as the
window doubles, `err/res` growing 0.037 → 0.101; the 13/87 split —
three visible zeros explaining 0.1291 of the variance against 0.8671 of
above-Nyquist content folded down, fixed by the base and not by the
ceiling; and the saturation of the visible fraction near 0.25 across ten
bases, so that even at Nyquist 158.65 with fifty-seven zeros beneath it
three quarters of the signal is still aliased.

**Killed:** inheritance between bases; coarsening producing zeros;
coverage and divisibility as attractors; the 2D transform as a way past
aliasing; a constant winding angle, now on 121 zeros rather than 4; `r−d`
as an independent coordinate for where zeros sit; mutual leakage
among the visible zeros as the explanation of the recovery bias —
backfitting all three removes about a tenth of it; and my own prediction
that the bias tracks the visible fraction — r = −0.642 on ten bases
collapses to −0.259 when the single coarsest one is dropped. Also killed,
and it was mine as well: that the bias is systematically positive. γ₂ is
−0.0051 and base 1.0500 is −0.0069.

**Unexplained:** the 36.4 peak that survives every recombination. The
bias in the recovered γ is no longer on this list — it is above-Nyquist
content folded down, and the surviving frequencies that carry it match no
zero.

**Standing above all of it:** zeros live where there is almost nothing to
cancel. That one fact now accounts for the apparent `r−d` structure too,
which means it is doing more work than credited and the other coordinates
are doing none.
