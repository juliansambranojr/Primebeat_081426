# The Twin Lattice

A twin pair is not two primes that happen to sit two apart. It is a site on the
`2·3` lattice with primes on both shoulders, and that lattice was already
load-bearing in this repository twice before anyone looked at twins.

This paper records the lattice fact as proved, the four-way occupancy census as
measured, and three things the census refuses.

Everything measured here is **EXPLORATORY**. There is no prereg and no verdict.

---

## A · The site

**A1.** Every twin pair above 3 has its lower member at `6k − 1`, so the single
integer between the pair is `6k`. Proved, not observed.
`TwinLattice.twin_lower_mod_six`

**A2.** Therefore the integer between a twin pair is always a multiple of 6.
That integer is the site; the pair is what is attached to it.
`TwinLattice.twin_pocket`

**A3.** `(3,5)` is the sole exception and it is the first pair, so the lattice
reading begins at `(5,7)`. It is exhibited rather than assumed.
`TwinLattice.three_five_exceptional`

**A4.** The two lattice theorems carry no `Classical.choice` — they are ℕ-valued
and close through `omega`. The exception theorem does, and the cost is entirely
Mathlib's: even `Nat.prime_three` depends on it.
`TwinLattice.twin_lower_mod_six · lean/BUILD.md § Mathlib-free core`

**A5.** The `2·3` lattice was already the stated reason for the deep zero
`(8,3)`: it lands at Connes' `λ = 4`, whose window holds exactly `{2,3}`.
`CONTEXT.md § Current state of the world, O19 / O20`

**A6.** And it is the convention the imported b-adic tables are built on —
"2 and 3 excluded as lattice rather than counted as primes". So the twin object,
the deep zero's explanation, and the import convention are one lattice
approached from three directions, none of which cited the others.
`CONTEXT.md § `imported/lattice_mapper/``

---

## B · The census

**B1.** Each site `6k` is one of four things: **twin** (both `6k ± 1` prime),
**lo** (only `6k − 1`), **hi** (only `6k + 1`), or **bare** (neither). Counted
per dyadic block `(2^(r−1), 2^r]` to `r = 30`.
`O51_twin_lattice_census.py`

**B2.** The four-way split partitions the sites exactly at every rung. This is
the run's self-check, and a failure would be a bug rather than a finding.
`results/twin_lattice_census.json`

**B3.** At `r = 30` the block holds 89478485 sites: 1689477 twin, 11414236 lo,
11414088 hi, 64960684 bare.
`results/twin_lattice_census.json`

**B4.** Twin sites are a falling fraction of the lattice — 7 of 21 at `r = 8`,
3785 of 87381 at `r = 20`.
`results/twin_lattice_census.json`

---

## C · The total is not geometric, so the pair identity does not transfer

**C1.** `PairIdentity.pair_identity` holds for any two arms partitioning a
**geometric** row. B2 gives a partition; C2 removes the geometric total.
`PairIdentity.pair_identity`

**C2.** The site count per block is **not** exactly `2^(r−1)/6`. It alternates
`±1/3` about that value, at every rung measured, without settling.
`results/twin_lattice_census.json · summary.site_count_exactly_geometric is false`

**C3.** The cause is the lattice itself: `2^(r−1) mod 6` alternates between 2 and
4, so the floor alternates with it. The deviation is structure, not noise, and
it is the `2·3` lattice appearing in the count of its own sites.
`C2 · derived, not printed in the artifact`

**C4.** So the identity fails here for a structural reason. This is the second
refusal: partitioning twins against the whole block instead gives a geometric
total but a complement that is 99.9% of it, which satisfies the hypothesis and
carries nothing.
`C1 + C2 · The-Composite-Arm.md § A2`

---

## D · Four exact zeros, one shared, none deep

**D1.** The twin arm's difference table — the same recurrence as the prime
table's — has exactly four exact zeros at `d ≥ 1` over 377 cells examined to
`r = 30`: `(4,1)`, `(6,1)`, `(9,1)`, `(8,4)`.
`results/twin_lattice_census.json`

**D2.** The prime table has four as well, and `(4,1)` is in both lists.
`D1 · The-Four-Zeros.md § A1`

**D3.** Three of the four are adjacent repeats on single-digit counts —
`twin(3) = twin(4) = 1`, `twin(5) = twin(6) = 2`, `twin(8) = twin(9) = 7`. A
repeat is cheap at those magnitudes, and `Zeros.zero_iff_repeat` says a
depth-1 zero **is** a repeat.
`Zeros.zero_iff_repeat · results/twin_lattice_census.json`

**D4.** `(8,4)` is the one that is not. The row `2, 2, 3, 7, 7` differences to
`1, 0, 1, 4`, then `−1, 1, 3`, then `2, 2`, then `0` — a depth-4 cancellation.
`D1 · derived from results/twin_lattice_census.json, not printed there`

**D5.** **No twin zero is deep.** All four sit at `r ≤ 9`, where counts are in
single or double digits. The prime table's `(20,6)` sits at a count of 38635.
The census examined depths to 28 across `r = 3…30`, so the deep region was
looked at and is empty.
`D1 · Zeros.pi2`

**D6.** That is a genuine asymmetry between two arithmetics on an identical
construction, and it is the paper's only comparative claim.
`D5`

---

## E · The occupancy bias is weak and sign-changing

**E1.** `lo − hi` — sites flanked only below against only above — is small and
changes sign across rungs. Normalised by `√sites` it stays inside `±0.25`.
`derived from results/twin_lattice_census.json: lo and hi per row; the ratio is
not printed there`

**E2.** That is **not** the Chebyshev bias. Counting primes by residue class mod
6 gives a consistent one-directional excess for `6k − 1`; counting sites flanked
on exactly one side does not. The two were conflated in conversation before the
census was run, and the census separates them.
`E1`

**E3.** No measurement of the residue-class prime race exists in this tree. The
figures quoted in conversation came from an inline script and are in no
artifact, so they are not repeated here.
`open`

---

## F · Not established

**F1.** Nothing here says where twins are or how many there are. A1 is a
constraint the lattice imposes, not a prediction.
`stated`

**F2.** `(4,1)` appearing in both tables is one coincidence at a small count. It
is recorded because it is checkable, not because it is evidence.
`D2`

**F3.** The census stops at `r = 30`, over 377 cells at `d ≥ 1`.
`results/twin_lattice_census.json`

**F3′.** O43 took the prime table far further — to `r = 92` over 4186 cells. The
two extents do not compare, and the absence of a deep twin zero is an absence
over the smaller one.
`F3 · CONTEXT.md § Current state of the world, O43`

**F4.** The character reading of the two arms is unformalised and unmeasured.
`6k ± 1` are the two Dirichlet characters mod 6 and `papers/convergence.md`
notes that only degree-1 L-functions give a plain difference table, but nothing
in this tree connects them.
`open`

**F5.** No prereg. The four-way split and the zero census were chosen after the
Lean theorem compiled, and the comparison to the prime table's four zeros was
made after seeing both.
`open`
