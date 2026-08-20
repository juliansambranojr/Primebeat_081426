# The Zero Surface

Four exact zeros at base 2 become 125 across eleven bases. Whether those 125 are a
connected object in base-space or an interval that merely happens to be occupied has
never been measured. This is the attempt, the coordinate it needs, and the reason the
existing scan cannot answer it.

Source lines cite scripts and results in `~/GitHub/Primebeat_081426/`. Nothing here is
preregistered.

---

## A · The question

**A1.** O45 found **121 resolved zeros across ten sub-integer bases**, plus base 2's
four, for 125 pooled. O46 refuted `density ≈ 1/S` as their mechanism. O47 ranked them
by stencil mass.
`results/sub_integer_base_scan.json · results/mass_density_check.json · results/high_mass_zeros.json`

**A2.** None of those asks where the zeros sit **relative to each other across bases**.
The counts are per base and the mass ranking is a total order; neither carries
geometry.
`A1`

**A3.** Made specific, the question is adjacency. **Surface**: a zero at one base has a
zero at a neighbouring base sitting nearby in a shared coordinate. **Scatter**:
cross-base neighbours are no closer than the resolved support already puts them.
`A2`

---

## B · The coordinate, which is not a choice

**B1.** `r` and `d` are not comparable across bases. Base 1.1175 runs to `r = 199` and
base 2 to `r = 32`; cell `(20,6)` names a different object in each.
`results/sub_integer_base_scan.json → summary.per_base.r_max`

**B2.** What is comparable is the stretch of the number line a cell reads. Cell `(r,d)`
at base `b` reads the values in `( b^(r−d−1), b^r ]`.
`definition of the table`

**B3.** In log₂ that is an interval with

```text
lo = (r − d − 1)·log₂ b     hi = r·log₂ b     w = hi − lo = (d + 1)·log₂ b
```

`B2`

**B4.** This is not a correspondence anyone selected. It is what the cell looks at, and
it is the column O47 already prints for its mass ranking.
`B3 · results/high_mass_zeros.json`

**B5.** That distinction is the one `Connes-Measured.md` § E4 draws. The `λ = 2^((d+1)/2)`
bridge of § E1 was withdrawn because matching by ratio is a choice and three defensible
matchings exist; § E3 survived because no coordinate matching was required. B4 is the
E3 kind.
`Connes-Measured.md § E1, E2, E4`

---

## C · What the test returned

**C1.** Cross-base nearest-neighbour distance in the `(lo, hi)` plane, against a null
drawn from each base's own resolved support and stratified so the base composition
matches the data exactly:

```text
observed        0.3745
null mean       1.0524   sd 0.0611
z              -11.10
p (low tail)    0.0005     2000 stratified draws, seed 2026
```

`t22_zero_surface.py`

**C2.** The same statistic **within** a base, as a control, moves as well.

```text
observed        1.2550
null mean       3.4454   sd 0.2250
z               -9.73
```

`t22`

**C3.** Therefore the compression is not about crossing bases. It is present at every
base separately.
`C1 + C2`

**C4.** The reason is visible in the ranges. Zeros occupy window widths `[0.32, 7.00]`
against the support's `[0.32, 32.00]`, and bottoms `[0.00, 18.00]` against `[0.00,
31.58]`. They are confined to one corner, so any two of them are close.
`t22`

**C5.** Width is `(d+1)·log₂ b`, so C4 is the shallow-depth selection O46 identified as
stencil mass, seen as geometry rather than as a number.
`B3 · results/mass_density_check.json`

**C6.** Matching the null on window width, per base, within ±0.25 in log₂ — candidate
pools of 26 to 498 cells, median 85:

```text
observed        0.3745     unchanged, same zeros
matched null    0.5308   sd 0.0294
z               -5.32
p (low tail)    0.0005
```

`t22`

**C7.** Halved, not collapsed. For contrast, the `r−d` result under its own matched
control went from `z = −9.17` to `z = +1.36` — a complete collapse. C6 is not that.
`t14_s_matched_control.py · results/t14_s_matched_control.txt`

---

## D · Why none of it counts

**D1.** The sorted window list carries exact repeats of `lo` across different bases.
`lo = 4.810` appears at 1.248897, at 1.395693 and at 1.320256, to every printed digit.
`t22`

**D2.** Exact coincidence across different bases is not an accident, so the base set
itself is the thing to check. Against the unit `π/(4γ₁)`, in log₂ **0.080163571**:

```text
             base      log₂ b     /unit   exact
 exp(pi*1/(2*g1))    0.160327    2.0000    YES
 exp(pi*3/(4*g1))    0.240491    3.0000    YES
 exp(pi*2/(2*g1))    0.320654    4.0000    YES
 exp(pi*5/(4*g1))    0.400818    5.0000    YES
 exp(pi*3/(2*g1))    0.480981    6.0000    YES
 exp(pi*7/(4*g1))    0.561145    7.0000    YES
 exp(pi*4/(2*g1))    0.641309    8.0000    YES
 exp(pi*9/(4*g1))    0.721472    9.0000    YES
```

`t22`

**D3.** Eight of the eleven bases have `log₂ b` an exact integer multiple, 2 through 9,
of one unit. Their ladders land on a single shared lattice, so window edges **must**
coincide across them.
`D2`

**D4.** Those eight carry **107 of the 125 zeros**.
`t22`

**D5.** The remaining three are base 2, `2^(1/2)` and `2^(1/3)` — log₂ of 1, ½ and ⅓,
mutually commensurate in their own right.
`D2`

**D6.** So every base in the scan is commensurate with the others in its arm, and there
is **no incommensurate pair anywhere in it**.
`D3 + D5`

**D7.** Therefore cross-base window alignment is forced by the base selection. C1, C2
and C6 measure the prereg's choice of bases, not the arrangement of the zeros.
`D6`

---

## E · Where the commensurability came from

**E1.** The family arm is `exp(π·k/(2γ₁))` for `k = 1…4` and the antiphase arm is
`exp(π(2k+1)/(4γ₁))`. Both are the optimal-base family of the chain's D4, chosen so
that `γ₁ log b` lands at a stated winding angle.
`Euler-Factor-Chain.md § D4 · preregs/sub_integer_base_scan_v1_20260818.md`

**E2.** Any set of the form `exp(π·m/(4γ₁))` over integer `m` is commensurate in log by
construction. The scan's eight are `m = 2,3,4,5,6,7,8,9`.
`E1 + D2`

**E3.** The commensurability is therefore a side effect of selecting for winding angle.
Nothing in the prereg required it, nothing in the prereg records it, and no test before
this one depended on it.
`E2 · preregs/sub_integer_base_scan_v1_20260818.md`

**E4.** The property is not new to the bench, only its sign is. `t6_multirate.py` used
the **incommensurability** of bases 2 and 3 deliberately, as the mechanism that breaks
the alias degeneracy — base 2 alone returns five peaks at identical variance explained,
0.486 each, at 8.898, 17.965, 27.358, 36.425, 45.156, and pooling incommensurate rates
separates them. § H3 gives the spacing as `2π/log b`, which is 9.0647 at `b = 2`; the
observed gaps are 9.067, 9.393, 9.067, 8.731, so the comb is approximate in the data
and exact only in the statement.
`t6_multirate.py · results/t6_multirate.txt · Euler-Factor-Chain.md § H3 · 2π/ln 2 is arithmetic`

**E5.** So the same property is wanted in both places for opposite reasons: present, to
break degeneracy in frequency; absent, to make cross-base adjacency mean something in
position.
`E4 + D7`

---

## F · What would answer it

**F1.** A scan over bases that are pairwise incommensurate in log — no two with
`log b₁ / log b₂` rational.
`D6`

**F2.** The zeros must still be resolvable, so the bases must stay in the range where
zeros occur at all: roughly `1.11 ≤ b ≤ 2`, with density rising toward 2 and cutting to
zero for every integer above it.
`results/sub_integer_base_scan.json · results/mass_density_check.json`

**F3.** F1 and F2 conflict less than they appear. The interval is continuous and the
commensurate points in it are countable, so almost every choice satisfies F1.
`F1 + F2`

**F4.** The statistic and its null carry over unchanged — the coordinate of § B is a
property of the cell, not of the base set.
`B4`

---

## G · Not established

**G1.** Whether the zeros form a surface. The question is **unmeasured**, not refuted.
Nothing here says they do not.
`D7`

**G2.** The `z = −5.32` surviving the width-matched control cannot be read. It is
consistent with a genuine cross-base structure and equally consistent with the forced
lattice alignment of D3, and this scan cannot separate them.
`C6 + D7`

**G3.** Whether the corner the zeros occupy — widths ≤ 7.00 against a support reaching
32.00 — is anything beyond the mass selection O46 already established. C5 asserts they
are the same fact in different coordinates; that is an identification, not a
measurement.
`C4 + C5`

**G4.** O47's mass ranking is untouched by any of the above and stands on its own: the
two heaviest cancellations in the pool are at `2^(1/2)`, cell (34,11) at
`S = 1,371,038` and cell (42,5) at `S = 651,298`, against base 2's (20,6) at
`S = 492,384` in third, then a factor-5.6 cliff. Base 2 is the density maximum and is
not the mass maximum.
`results/high_mass_zeros.json`

**G5.** No prereg. All of the above is exploratory, and § C's numbers are a measurement
of the instrument rather than of the object.
`CLAUDE.md § Prereg discipline`
