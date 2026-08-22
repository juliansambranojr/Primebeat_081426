# Lab notebook, volume 2 — Primebeat_081426

Volume 2. Volume 1 is `lab_notebook.md`; it is closed and holds entries
1–44. This volume opens at entry 45.

Numbering is continuous across volumes: `entry N` is a unique address
project-wide, and a `NOTEPAD.md` line citing a bare entry number resolves
to whichever volume holds it — 1–44 in `lab_notebook.md`, 45 onward here.

Newest at top, same as volume 1.

Entry format and type vocabulary: `notes/notes_format.md`.

Agents append entries. Outcome markings and status transitions are
Julian's call.

---

## 2026-08-21 — Entry 83 — the pocket read as a BASE: the pair identity's coefficient is the lower twin arm, and the extent arithmetic that bounds it
type: motivation
refs: 81, 82

**Julian's reframe, and it is not what entry 82 built.** O51 treated the lattice
as a *set of sites* and counted occupancy. His reading is that each pocket is a
**base**, in the same sense as dyadic and triadic: `(11,13)` gives base 12, and
you build the b-adic table there. Tabled without pursuing, recorded so it is not
rediscovered.

**The structural consequence, which is the reason to record this at all.**
`PairIdentity.pair_identity` gives the cell total as `(b−1)^(d+1) · b^e`. At a
pocket base, **`b−1` is the lower twin arm** — a prime. At a generic base it is
composite. So the pocket bases are exactly those whose identity coefficient is
prime, and reading that coefficient across pockets enumerates the lower twins:

```text
base b     4    6   12   18   30   42   60   72
b − 1      3    5   11   17   29   41   59   71     <- the lower twin arms
b + 1      5    7   13   19   31   43   61   73
```

The arms are not beside the lattice. **One of them is the identity's
coefficient at that base.**

**A correction Julian caught in conversation.** I said bases 4 and 6 were "two
pockets already measured, both empty". Wrong on two counts. They are **pockets,
not twins** — the twins are 3, 5 and 5, 7. And `4 % 6 = 4`, so base 4 is **off
the lattice**, which is exactly what `TwinLattice.three_five_exceptional`
proves: `(3,5)` is the one pair whose pocket is not a multiple of 6. My own
theorem excludes it and I counted it anyway.

Corrected: of the eight bases O44 measured, **exactly one is an on-lattice
pocket — base 6**, the pocket of `(5,7)`, and it has no exact zeros. Bases 12,
18, 30, 42 have never been built.

**And base 2 is not a pocket at all** (`b − 1 = 1`, not prime). The one base with
exact zeros is the one base in range that is not a pocket.

**Base 4 is a control, not a data point.** It is the only base with twin arms
that sits off the lattice. If the lattice does work, 4 and 6 should behave
differently; O44 lumped both in with 2–9.

**The extent arithmetic, which bounds the whole idea.** `rungs =
log(ceiling)/log(b)`, so high bases are starved regardless of compute.
primecount is not the constraint — `π(10^15)` returns in 0.58 s.

```text
base    arms      rungs at 2^32   1e11   1e15
   4    (3,5)          16          18     24
   6    (5,7)          12          14     19
  12   (11,13)          8          10     13
  18   (17,19)          7           8     11
  30   (29,31)          6           7     10
  42   (41,43)          5           6      9
```

Base 30 would need a ceiling near `30^20 ≈ 3.5e29` to hold the twenty rungs base
2 has at `2^20`. This is arithmetic, not a sieve limit — going deeper in `x`
buys rungs only logarithmically. O44 already named it: *"bases 5–9 stop at
regime ceilings 27, 24, 22, 21, 20 and are extent-censored."*

**So the per-pocket table question is extent-limited before it is asked** —
base 12 gets 13 rungs at `10^15`, not enough to look for anything like `(20,6)`.
The cross-pocket question, whether the pockets connect to each other, is not
obviously bounded the same way and was not examined.

Nothing run. Nothing claimed. This entry is the observation and its limit.

---

## 2026-08-21 — Entry 82 — O51: the twin lattice census, and three things it refuses
type: run
refs: 78, 81

**Run.** `O51_twin_lattice_census.py`, no flags, **EXPLORATORY — no prereg, no
verdict**. Numpy odd sieve to `2^30`, four-way occupancy of the `6k` lattice per
dyadic block, `r = 3…30`. Completed, did not error.
`results/twin_lattice_census.json` + `results/O51_twin_lattice_census_run1.log`.
Paper written on it: `papers/The-Twin-Lattice.md`.

**Self-check passes.** The four-way split — twin / lo / hi / bare — partitions
the sites exactly at every rung. A failure would have been a bug.

### Three refusals, and the refusals are the content

**1. The total is not geometric, so `pair_identity` does not transfer.** The site
count per block alternates `±1/3` about `2^(r−1)/6`, at every rung, without
settling — because `2^(r−1) mod 6` alternates between 2 and 4 and the floor
follows. So the hypothesis fails for a **structural** reason, and the deviation
is the `2·3` lattice showing up in the count of its own sites.

This is the second refusal for this object. Partitioning twins against the whole
block instead gives a geometric total, but the complement is 99.9% of it and
carries nothing (`The-Composite-Arm.md` § A2's argument, worse).

**2. The occupancy bias is weak and sign-changing, and is NOT the Chebyshev
bias.** `lo − hi` normalised by `√sites` stays inside `±0.25` and flips sign
across rungs. Counting **primes** by residue class mod 6 gives a consistent
one-directional excess for `6k − 1`; counting **sites flanked on exactly one
side** does not. I conflated the two in conversation before the census ran. The
census separates them, and the residue-class race is measured nowhere in this
tree — the figures I quoted came from an inline script and are in no artifact,
so they are in no paper.

**3. No twin zero is deep.** The twin arm's difference table has exactly four
exact zeros at `d ≥ 1` over 377 cells to `r = 30`: `(4,1)`, `(6,1)`, `(9,1)`,
`(8,4)`. **All four sit at `r ≤ 9`**, where counts are single or double digits.
The prime table's `(20,6)` sits at a count of 38635. Depths to 28 were examined
across `r = 3…30`, so the deep region was looked at and is empty.

### The parts worth arguing about

`(4,1)` is in **both** lists — the prime table's `(2,1) (4,1) (8,3) (20,6)` and
the twin table's. One coincidence at a small count, recorded because it is
checkable, not because it is evidence.

Three of the four twin zeros are adjacent repeats on tiny counts —
`twin(3) = twin(4) = 1`, `twin(5) = twin(6) = 2`, `twin(8) = twin(9) = 7` — and
`Zeros.zero_iff_repeat` says a depth-1 zero **is** a repeat, so those are cheap
at those magnitudes. **`(8,4)` is not**: the row `2, 2, 3, 7, 7` differences to
`1, 0, 1, 4`, then `−1, 1, 3`, then `2, 2`, then `0`. A depth-4 cancellation,
walked by hand to confirm.

**Extent caveat, stated rather than buried.** 377 cells to `r = 30` against
O43's 4186 cells to `r = 92`. The absence of a deep twin zero is an absence over
the smaller range.

### Ordering

Lean first (entry 81), then the census, then the paper citing both. The reverse
of `The-Composite-Arm.md`, which went out ahead of its script and is still
PROVISIONAL. `check_values` caught two numbers on the first pass — O43's `92`
and `4186` cited against the twin artifact, which does not contain them — and
they were split into their own statement with their own source. Now **113
confirmed, 0 not found**.

---

## 2026-08-21 — Entry 81 — TwinLattice: a twin pair is a lattice site, proved, and the mod-6 lattice was already load-bearing here twice
type: formalization
refs: 78, 80

**Julian's theory, in his terms.** Twin primes share a pocket between them, one
integer apart, and he treats the lattice as navigation: the pair is where a
trajectory has both arms available.

**The check.** Every twin pair above 3 is `(6k − 1, 6k + 1)`, so the single
integer between is `6k`. Verified numerically below 2000 — one exception,
`(3,5)`, and it is the first pair. **So a twin pair is not two primes that happen
to sit two apart. It is a site on the `2·3` lattice with primes on both
shoulders**, and counting twins is counting doubly-flanked sites.

**And that lattice is already load-bearing in this tree, in two places nothing
connected.**

* `CONTEXT.md` § Current state of the world, O19/O20 — `(8,3)` lands at Connes'
  `λ = 4`, whose window holds exactly `{2,3}`, *"the mod-6 lattice, which is the
  workbook's own reason for that zero"*.
* `CONTEXT.md` § `imported/lattice_mapper/` — those tables are built with *"2 and
  3 excluded as lattice rather than counted as primes"*. **That convention is the
  mod-6 lattice.**

The twin object, the deep zero's stated explanation, and the imported tables'
convention are the same lattice, approached from three directions and never
named once.

**New module `lean/TwinLattice.lean`**, the twelfth, named by Julian. Added to
`lakefile.toml` globs — that list is explicit, not a wildcard, so a new module
does not build until it is named there.

```text
twin_lower_mod_six      p, p+2 prime and 3 < p  →  p % 6 = 5   [propext, Quot.sound]
twin_pocket             the integer between is ≡ 0 (mod 6)     [propext, Quot.sound]
three_five_exceptional  (3,5) exhibited, not assumed           full three
```

**The two lattice theorems carry no `Classical.choice`** despite importing
Mathlib — they are ℕ-valued and close through `omega`, which costs `Quot.sound`
and nothing more. The exception theorem does carry it, and the cost is entirely
Mathlib's: **even `Nat.prime_three` depends on `Classical.choice`**, and `decide`
on `Nat.Prime` routes through a classical decidability instance. Checked
directly rather than assumed. Pinned as it is rather than worked around, since
the honest list says where the cost comes from.

**Placement, and why not `Chain.lean`.** Chain's own header, line 4: *"Companion
to papers/Euler-Factor-Chain.md."* Its job is checking that paper's arrows, and
the mod-6 material discharges no statement in it. Putting it there would make
the file's header false. This tree's modules are named for objects and have held
their scope; a new object gets a new module.

**Mathlib has nothing on twin primes.** Grepped. Nothing here is reproved.

**What is NOT proved, and was not attempted.** That the lattice explains where
twins are or how many there are. The three-way occupancy split — sites flanked
on both sides, one side, neither — is not here. Neither is the character reading
of the two arms, though it is the standard machinery: the classes `6k ± 1` are
the two Dirichlet characters mod 6, their difference is the Chebyshev bias
(measured at 0.46–0.96 in units of `√x/log x` over four decades), and
`papers/convergence.md:26` already notes that *"only degree-1 L-functions give a
plain difference table"* — which Dirichlet L-functions are. Each is a separate
step that can fail on its own.

**Ordering.** Julian's rule for this: prove it in Lean first, and only then add
it to the paper. That is the reverse of `papers/The-Composite-Arm.md`, which was
written before its script existed and is still PROVISIONAL with four conditions
in its header. No paper is written here.

Build clean, 8038 jobs, 149 theorems, 149 pins, parity in all 12 modules. Gate
unchanged at 2, `check_values` 99 confirmed / 0 not found.

---

## 2026-08-21 — Entry 80 — twin_count imported, CONTEXT brought current to O50, and The-Deep-Ladder written
type: provenance
refs: 46, 73, 75, 79

**Import.** Seven files copied byte-for-byte (`cp -p`) from
`~/GitHub/twin_count/` into `imported/twin_count/`, every one SHA-256 verified
source-vs-destination at copy time, manifest at
`imported/twin_count/README.md` which self-verifies against the files it lists.
Same discipline as entry 46's lattice_mapper import.

**The source is not a git repository and has no commitment files.** This import
is the only versioned copy of that work that exists — 10,000 checkpoints to
`10^11`, an analysis, and 100,000 zeta zeros, previously one disk failure from
gone.

**Not imported:** `twincount` the compiled binary, 33976 bytes, machine-specific
(`-march=native`) and rebuildable from `twincount.c`. Same judgment as
`archive_unsilenced/` in entry 46 — binaries do not belong in an evidence
import.

**Convention warning recorded in the manifest.** `twins_1e11.csv` is sampled on
a **linear** ladder, step `10^7`; every in-repo artifact uses **geometric**
rungs. That difference is not cosmetic — it is exactly what
`twins_1e11_analysis.json` deprecates its own α estimator for, and it is the
same class of defect as O48's fixed depth window.

**CONTEXT.md brought current**, Julian approving. It stopped at O47 and its
test table stops at O39, so the file a new instance reads first to orient did
not know the last three runs had happened. Added: a note that the table stops
at O39; entries for **O48** (preregistered, `compromised`, control could not
survive the depth window), **O49** (the C2 ceiling attained at 97.68% ± 2.91%,
depth saturates by `d = 1` or `2`), and **O50** (38 zeros separated completely,
O17's ceiling was a sieve limit); and an `imported/twin_count/` section on the
lattice_mapper pattern.

**Paper written.** `papers/The-Deep-Ladder.md`, six sections on the house
format. Its § D records the false start in full — that flat amplitude in γ was
read as fatal and is in fact what a fine ladder must produce, since
`(r^ρ − 1)/ρ → log r`. Its § F carries five limits, including that there is no
prereg and that the separation statistic was chosen *after* the peak list proved
to be selection, which is the sequence a prereg exists to prevent.

**`check_values` caught six numbers on the first pass** and all six were mine:
three prime counts written in scientific shorthand against full integers in the
JSON, a range bound that is a run parameter rather than a measurement, the
string `O17` parsed as the number 17 inside a statement checked against an
artifact, and one genuinely derived ratio that needed declaring as derived per
`papers/FORMAT.md`. Now **99 confirmed, 0 not found**, up from 83.

---

## 2026-08-21 — Entry 79 — O50: 38 zeta zeros recovered with complete separation, and the dyadic control still fails
type: run
refs: 17, 75, 76, 78

**Run.** `O50_deep_ladder_spectrum.py`, no flags, **EXPLORATORY — no prereg, no
verdict**. `results/deep_ladder_spectrum.json` +
`results/O50_deep_ladder_spectrum_run1.log`. Completed, did not error.

**Why.** Entries 75/76 established that depth is the wrong axis — the gain
saturates at the C2 ceiling by `d = 1` or `2`, so differencing destroys mode
identity immediately. Every success on this bench probed at **depth 0** and
varied the ladder: O17, O18, O34/O35's 94%. And `CONTEXT.md:250` names the limit
that stopped O17 — *"over 8.4M primes there are only ~16 disjoint blocks however
the ladder is sampled."* **That is a sieve limit, not a mathematical one.** O17
sieves with numpy; primecount evaluates `π(10^11)` in 4 ms.

The statistic is unchanged from O17. Only `xmax` and the `π` backend differ.

**Result.**

```text
arm              ratio      x0   blocks       primes   zeros  separation  ratio
replicate_1.1      1.1    1000      193  4.02e9           6   COMPLETE     4.8x
fine_1.002       1.002     1e5     6914  4.11e9          38   COMPLETE    36.5x
dyadic_control     2.0       2       35  2.87e9           6   FAILS        5.3x
```

**The fine arm separates 38 zeta zeros completely:**

```text
amplitude AT the 38 zeros    median 6.905   min 6.478
amplitude BETWEEN them       median 0.189   max 2.341
                             0 of 38 zeros below the largest midpoint
```

Every zero is above every midpoint. O17 found **three** (γ₁, γ₂, γ₃) on 125
blocks over 8.41e6 primes; this finds **38** on 6914 blocks over 4.11e9, and
`replicate_1.1` — O17's own ladder at the new ceiling — goes from 3 to 6.

**The dyadic control still fails**, 3 of 6 zeros below the max midpoint, which is
O17's finding reproduced at 340× the primes. Its Nyquist is 4.5, so γ₁ at 14.13
is aliased and cannot be resolved however many primes are thrown at it.

**A false start worth recording, because I nearly threw the result away.** The
top-ten peak table looked suspicious for two reasons: every peak had nearly the
same height, and the fine arm appeared to *miss* γ₁, γ₂, γ₃ while finding γ₃₇.
I read the flat amplitude as fatal, on the grounds that the explicit formula's
`x^ρ/ρ` predicts a `1/γ` falloff.

**That was wrong.** For a narrow block the mode contributes `x^ρ(r^ρ − 1)/ρ`,
and `(r^ρ − 1)/ρ → log r` as `|ρ log r| → 0`. The `1/γ` cancels. **Flat amplitude
in γ is exactly what a fine geometric ladder must give**, and its presence is
evidence for the reading rather than against it. The apparent "missing" low
zeros were an artifact of ranking by peak height when the spectrum is flat: the
top ten were ten zeros among thirty-eight, chosen arbitrarily.

The separation test replaced the peak table as the primary statistic for that
reason — a top-ten list is selection, a fixed comparison of zeros against exact
midpoints is not.

**What this is.** A measurement, at 490× O17's prime count, confirming that the
prime residual on a fine geometric ladder carries the zeta zeros. **It is not new
mathematics** — the explicit formula says so. What is new here is the resolution,
and that the working method was resolution-starved rather than exhausted.

**What it does not touch.** The four exact zeros, and the global bridge — the
Euler product still lives at `Re s > 1` and everything else on the critical line
(`Euler-Factor-Chain.md` § J5).

**Provenance of the idea.** From `~/GitHub/twin_count`, whose `twincount.c`
streams to `10^11` in 16.8 s and whose analysis deprecates its own α estimator
for a linear-sampling defect that is the same class as O48's fixed depth window.
That folder has no commitment files and is not a git repository.

---

## 2026-08-21 — Entry 78 — the four zeros computed rather than transcribed, and the def-citation hazard closed at its most-cited instance
type: formalization
refs: 60, 70, 77

`Zeros.measured_zeros` was four hand-typed pairs whose own docstring said *"no
theorem above predicts these"* — and `papers/The-Four-Zeros.md` § B9 cited it,
in a source line, as though citing a proof. The handoff plan named this hazard:
`utilities/check_refs.py:31` resolves a `def` and a `theorem` identically, so a
citation to a transcription is indistinguishable from a citation to a result.
That citation was mine.

**Seven theorems, all with no axioms at all.**

```text
pi2                  π(2^n), n = 0…20, from pi2n_cache.json — 21 integers,
                     and the ONLY measured input to any of this
dyadicRow            N(r) = π(2^r) − π(2^(r−1))

zero_2_1  zero_4_1  zero_8_3  zero_20_6
measured_zeros_all_vanish     the list's own claim, as a theorem
nonzero_7_3  nonzero_19_6     so the check fires in both directions
```

Entry 60's `tableFrom_eq_stencil` is what makes this one line each rather than a
table walk:

```text
(2,1)    1·1 − 1·1                                                 = 0
(4,1)    1·2 − 1·2                                                 = 0
(8,3)    1·23 − 3·13 + 3·7 − 1·5                                   = 0
(20,6)   1·38635 − 6·20390 + 15·10749 − 20·5709 + 15·3030
           − 6·1612 + 1·872                                        = 0
```

`nonzero_19_6 = 343` is the `+343` of `papers/The-Fold.md` § C3, whose partner
`−343` sits at `(20,7)` because a zero at `(20,6)` forces it there.

**What changed and what did not.** The zeros' *vanishing* is now derived from π
by the kernel, at zero axioms. Their *location* is not, and the docstring still
says so. Nothing here predicts why 8 and 20 and no other cell below `r = 92`.

**The citation is repointed.** `The-Four-Zeros.md` § B9 now cites
`Zeros.measured_zeros_all_vanish` — a theorem — rather than the list, and says
so in the source line. `measured_zeros` stays, because three other modules carry
the same list and `SeedPerturbation`/`PairIdentity` cite it; its docstring now
directs any citation to the theorem.

**Still open.** The hazard itself is not fixed — `check_refs.py` still cannot
tell a `def` from a `theorem`. What closed here is the one instance that was
actually being exploited. Three transcribed copies remain:
`Construction.measured_zeros`, `SeedPerturbation.zero_cells`,
`PairIdentity.zero_cells`.

Build clean, 8037 jobs, 146 theorems, 146 pins, parity in all 11 modules.
Axiom-free count rises 15 → 22.

---

## 2026-08-21 — Entry 77 — block D formalised, wired to the paper, and the attainment C2 never had
type: formalization
refs: 69, 75, 76

Entry 76 found `papers/Euler-Factor-Chain.md` § D stating the floor, the
ceiling, the smooth term's position and the ceiling bases **in prose**, while
`lean/BUILD.md` listed the whole block as not formalised. Six theorems close it.

```text
gain_sq_at_floor          cos(γ log b) = 1  →  gain² = (1 − b^(−1/2))²     D1
gain_sq_at_ceiling        cos(γ log b) = −1 →  gain² = (1 + b^(−1/2))²     D1
C2_floor_attained         γ = 0 sits exactly on the floor                  D2
C2_ceiling_attained       ∃ γ reaching the ceiling; witness π/log b
ceiling_dominates_floor   floor² < ceiling², needs only 0 < b              D3
ceiling_base              exp(π(2k+1)/γ) puts γ at the ceiling             D4
```

All six fall out of `EulerFactorChain.gain_sq_on_critical_line`, which was
already proved, by evaluating `cos` at `±1`. Nothing hard happened; the pieces
were on both sides of a gap nobody had crossed.

**The attainment is the part `StmtC2` did not have.** C2 proves the gain is
*contained* in `[1 − b^(−1/2), 1 + b^(−1/2)]` and never exhibits a `γ` at
either end — the handoff plan flagged exactly this, that Lean proves
containment and never attainment. `C2_floor_attained` and `C2_ceiling_attained`
supply both ends. And entry 75 measures the residual table's own gain at
**97.68% ± 2.91% of that ceiling across twelve bases**, so the bound is not
merely attainable but attained in the data.

**Correction to entry 76.** It says `Chain.sym_eq_zero_iff` "is D1's floor
condition, proved." That is imprecise and I am not amending 76. `sym_eq_zero_iff`
is where `Sym` vanishes **outright**, on `s = 2πik/log b`, which has
`Re s = 0`. D1's floor is on the **critical line** `Re s = 1/2`, where the gain
is `1 − b^(−1/2)` and is not zero. Same phase condition, different line. The
honest statement — now in `Chain.lean`'s section docstring — is that **the C2
floor is where the critical line passes closest to the zero lattice**, and
`1 − b^(−1/2)` measures that approach.

**Wired to the paper.** Five source lines in `Euler-Factor-Chain.md` now carry
Lean citations: C2 gains `gain_sq_periodic`, `C2_floor_attained`,
`C2_ceiling_attained` with the note that both ends are attained rather than
merely bounded; D1 gains both halves; D2 gains the floor witness; D3 gains the
inequality and O49's measured 97.68%; D4 gains `ceiling_base`. `check_refs.py`
resolves every one — the gate is unchanged at 2.

These are all **theorems**, so the `def`-versus-`theorem` hazard the handoff
plan names does not apply here. That hazard remains open for
`Zeros.measured_zeros`.

**`lean/BUILD.md` corrected.** It said 119 theorems; the tree has 139. Its
"not formalised" line dropped block D and now names only block G and the
numeric values. D5 and D6 stay observations — they are measurements of how far
base 2 and base 3 sit from a ceiling base, not statements to prove.

Build clean, 8037 jobs, 139 theorems, 139 pins, parity in all 11 modules.

---

## 2026-08-21 — Entry 76 — the record already had it: `Euler-Factor-Chain.md` § D states the floor, the ceiling and the power iteration in prose
type: result-triage
refs: 72, 74, 75

Checked entry 75's finding against the written record before logging it, at
Julian's instruction. Most of the structure is already there, and three things
I asserted are wrong.

### What block D already says

`papers/Euler-Factor-Chain.md` § D · The winding:

```text
D1. The floor of C2 is at γ log b ≡ 0 (mod 2π); the ceiling at γ log b ≡ π (mod 2π).
D2. The smooth term has ρ real, so γ = 0, so it sits exactly at the floor.
D3. Therefore differencing dissipates the smooth part maximally while
    amplifying modes near the ceiling.
D4. The bases placing γ exactly at the ceiling are b = exp(π(2k+1)/γ).
    For γ₁: 1.2489, 1.948, 3.039, 4.741, 7.395 …
D6. Therefore base 2 reaches 98.3% of its ceiling for γ₁, base 3 99.6%.
```

**D3 is the power iteration.** Entry 75 presents it as a mechanism found in the
data; it has been in the paper. **D1's floor is the null** this program has been
calling a discovery since entry 72.

### Three corrections

**(1) `Depth-as-Time.md` § B4 does not overclaim, and I said it did.** B4 reads
"the first Riemann zero is the fastest-growing mode of the difference operator,
**in both bases measured**" — correctly scoped — and B5 immediately says *"It
does not generalize to the other zeros"* with base-2 percentages of ceiling
listed per zero: γ₂ 84.8, γ₃ 69.8, γ₄ 90.3, γ₅ 91.6, γ₆ 47.0. My claim that B4
was a base-2 coincidence the paper had missed is withdrawn.

**(2) Entry 72 overstates the novelty of the null base.** It says nobody looked
at 1.5597 as a null. D4 lists the **ceiling** bases for γ₁ beginning at
**1.2489** — the O45 family's k=2 — and the floor bases are its one-line
complement. The family is `log b_k = k·π/(2γ₁)`, so k=2 puts γ₁ at the ceiling
and k=4 at the floor. It was built on this axis and half of it was written down.

**(3) Entry 74 sets `d*` beside a quantity it does not measure.**
`analysis/2026-08-19_table_structure/scripts/t2_crossover.py:11-12` defines `d*`
as "the first depth where oscillation carries more than half the power," an FFT
DC-versus-rest split. Entry 75's plateau entry is a gain-ratio threshold. Entry
74's point about the fixed window stands; the two statistics do not compare and
should not have been tabled together.

### What survives as new

**The attainment is measured on the table, not predicted for a mode.** D6 gives
γ₁'s *predicted* growth factor as a percentage of ceiling in two bases. Entry 75
measures the **residual table's own per-depth gain** and finds it at
**97.68% ± 2.91% of `1 + b^(−1/2)` across twelve bases**, nine of which appear
in no prior result in this tree.

**Convergence is immediate.** D3 says differencing amplifies ceiling modes; it
does not say how fast. One or two differences is fast enough that **no depth
window exists in which a sub-ceiling mode is visible** — which is the real
reason O48 could not see γ₁'s null, and is stronger than entry 73's account.

**The O48 failure quantified.** At `b = 1.5597432`, γ₁ sits at 0.0% of the band
and γ₂ at 99.9%. D1 and B5 together predict this; the base had never been run.

**And block D is prose.** `lean/BUILD.md:105` lists "the winding (block D)" as
not formalised, while `Chain.sym_eq_zero_iff` — landed in entry 69 — **is D1's
floor condition, proved**. Neither side of the tree records that the other did
it. That is the gap worth closing.

---

## 2026-08-21 — Entry 75 — O49: the residual table's depth gain attains the C2 ceiling in every base, by depth 1 or 2
type: run
refs: 72, 73, 74

**Run.** `O49_gain_vs_depth.py`, no flags, **EXPLORATORY — no prereg, no
verdict, nothing here is stamped**. Thirteen bases, value window `[10^4, 2^32]`,
depths 1–12, `primecountpy.prime_pi`, `mp.dps 50`. Completed, did not error.
`results/gain_vs_depth.json` + `results/O49_gain_vs_depth_run1.log`.

**Question.** Entry 74 found O48's gain constant at 1.771 and blamed a fixed
depth window sitting above `d*`. This asks per base: at what depth does the gain
leave the symbol, and does the symbol hold below it?

**Answer: it never holds.** The plateau is entered at `d = 1` or `d = 2` in
every base. There is no shallow regime in which a single mode governs.

**And the plateau is not noise — it is the C2 ceiling, attained:**

```text
base      plateau (median d≥4)   1 + b^(−1/2)   ratio
1.1500                 1.8859         1.9325   0.9759
1.2293859              1.8890         1.9019   0.9932
1.2560                 1.8481         1.8923   0.9767
1.2855907              1.8502         1.8820   0.9831
1.3160                 1.7347         1.8717   0.9268
1.3483554              1.8172         1.8612   0.9763
1.4200                 1.7126         1.8392   0.9312
1.5000                 1.7238         1.8165   0.9490
1.5597432              1.8203         1.8007   1.0109
1.6200                 1.7743         1.7857   0.9936
1.7500                 1.7976         1.7559   1.0237
2.0000                 1.6753         1.7071   0.9814
                                mean 0.9768, sd 0.0291
```

`StmtC2` bounds the gain in `[1 − b^(−1/2), 1 + b^(−1/2)]`. The handoff plan
flagged that Lean proves **containment, never attainment**. This is attainment,
measured, at every base to 2.3%.

**Why.** Each difference multiplies mode `ρ` by `|Sym b ρ|`, so depth is a power
iteration and selects the largest gain in the band. That is
`Euler-Factor-Chain.md` § D3 — see entry 76, which checks this against the
record and finds the mechanism already written.

**At the γ₁ null base, what the other modes are doing:**

```text
b = 1.5597432,  band [0.1993, 1.8007]
        γ·log b     /π    |Sym|   position in band
γ₁       6.2832   2.000   0.1993      0.0%   nulled exactly
γ₂       9.3447   2.975   1.7993     99.9%   at the ceiling
γ₃      11.1179   3.539   1.2024     62.6%
γ₅      14.6403   4.660   1.5535     84.6%
```

**So the γ₁ null is real and unobservable.** Nulls sit at `γ log b = 2πk` and
maxima at `γ log b = π (mod 2π)`; the zeta zeros are spaced closely enough that
a base nulling one puts another near the ceiling. Here γ₂ lands within `0.026π`
of a maximum. This is structural, not misfortune — and it is the mechanism the
locked prereg named in advance as its largest doubt.

**Standing.** Exploratory. Entry 76 checks it against the record.

---

## 2026-08-21 — Entry 74 — O48 run 1 re-read: the gain is constant at 1.771, the depth window sat above `d*`, and entry 73's small-angle agreement was a crossing
type: result-triage
refs: 52, 53, 72, 73

Entry 73 stands as written. This entry carries the correction, same as 68/70.

### Retraction

Entry 73 reports, as exploratory, that inside the small-angle radius the
transform tracks to within 3% — ratios 1.137, 0.969, 0.968, 1.023, 0.987. **That
is a coincidence and I over-read it.** Strip the `1/log b` normalisation and look
at the raw per-depth gain `G_b = Ĝ_b · log b`:

```text
base    measured G   γ₁ model   smooth model
1.1500      1.8351     1.6137        0.0675
1.2294      1.8323     1.8902        0.0981
1.2560      1.8307     1.8908        0.1077
1.2856      1.8846     1.8428        0.1180
1.3160      1.7235     1.7457        0.1283
1.3484      1.8454     1.5965        0.1388
1.4200      1.7177     1.1396        0.1608
1.5000      1.7074     0.5256        0.1835
1.5597      1.7441     0.1993        0.1993
1.6200      1.7279     0.5159        0.2143
1.7500      1.7826     1.2869        0.2441
2.0000      1.6200     1.6784        0.2929
```

**The measured gain is constant: 1.7710 ± 0.0766, CV 4.3%, over all twelve
bases.** The entire 5.6× spread in `Ĝ` reported in entry 73 is the `1/log b`
divisor, not structure. There was no curve.

The apparent agreement below `u/2π = 0.62` is the γ₁ model **crossing** that
constant, because for small `h`, `|1 − e^(−ρh)| → |ρ|h = 14.14h`, which passes
through 1.8 precisely in that range. From `b = 1.42` the model dives and the
measurement does not move.

### What the run actually measured

Noise amplification at gain ≈ 1.77, base-independent. That accounts for every
feature at once: no null (noise has none), a smooth `Ĝ` curve (it is
`const/log b`), and the control's apparent failure — **the control was not broken
relative to the data; it was measuring the same thing**, rounding noise at
`G ≈ 1.6–1.76` for small `b`.

So the `compromised` verdict is right, and for a deeper reason than the one
entry 73 gives: the pipeline and its control were both in the noise regime.

### The design error, and it is upstream of the control

`analysis/2026-08-19_table_structure/CHAIN.md` § `t2_crossover` already records
`d*`, the depth where oscillation overtakes trend, per base:

```text
k=1 1.1175 -> d* = 2      √2  1.4142 -> d* = 4
k=2 1.2489 -> d* = 3      k=4 1.5597 -> d* = 5
k=3 1.3957 -> d* = 4      2.0000     -> d* = 7      3.0000 -> d* = 10
```

`d*` runs 2 to 10 across the set. **The locked window `d ∈ [3,8]` is above `d*`
for k=1 and k=2, straddles it for k=3, k=4 and √2, and lies below it only for
bases 2 and 3.** A fixed depth window measures a different regime in every base,
which is exactly what a base-independent constant looks like when you find one.

Corroborating, from the other direction: O34/O35 report 94% at `d=0`, 92% at
`d=3`, **80% at `d=6`** — degrading — and entry 52 records the model flipping
sign at `(25,21)`. The window sat in the decay zone and this was recorded before
the prereg was written.

### What this points at

Julian's proposal — take the crossover per base and difference across bases —
is the right instrument, because `d*` is the depth at which the character
changes and it is already measured to scale with the base. Entry 53: `d*` is not
a per-base constant, but its slope in `r` is, `corr(ln b, slope) = +0.9735`.

The next run is exploratory and asks the question the fixed window could not:
**per base, at what depth does the gain leave the symbol and join the 1.77
plateau, and does the symbol hold below it?** No prereg. Labelled exploratory.

---

## 2026-08-21 — Entry 73 — O48 run 1: the transform holds inside the small-angle radius, the null does not appear, and the control was the defect
type: run
refs: 69, 72

**Run.** `O48_small_angle_cross_base.py`, no flags, under
`preregs/small_angle_cross_base_v1_20260821.md` **LOCKED**, sidecar
`14c86dc224de23d62d6c0486106a5a071645ac01ee328e512d3da8c52daa6fbd` verified
against the file before the Run record was filled. Started
2026-08-21T19:13:54Z, ended 19:14:36Z. `primecountpy.prime_pi`, `mp.dps 50`,
twelve bases, value window `[10^4, 2^32]`, depth window `d ∈ [3,8]`. Completed,
did not error. `results/small_angle_cross_base.json` +
`results/O48_small_angle_cross_base_run1.log`.

**Mechanical decision-rule output: `compromised`**, precedence branch 1, because
the control floor came out `0.754867` against the locked threshold `0.80`. The
verdict line is Julian's and is unfilled.

### The control is the defect, and it is mine

`round(b**(r/2))` does not survive the depth window. At `b = 1.15` the exact
per-depth gain is `0.0675`, so the mode decays to `4.3e−10` of itself by depth
8, while `round()` injects `±0.5` amplifying by up to `2` per difference —
`2^8 = 256`. So the control measured **noise doubling**, `≈ 2/log b`:

```text
b        2/log b   measured Ghat_ctrl   exact gain it should have read
1.1500    14.310         12.606                0.4829
1.3160     7.283          6.181                0.4672
2.0000     2.885          0.470                0.4226
```

That definition was written into the prereg in the edit **immediately before
locking**, replacing the looser "fitted the same way" phrasing, on the grounds
that it was too vague to implement. Sharpening it made it wrong. A v2 needs a
control that survives depth.

### What the run showed, EXPLORATORY — the verdict is compromised, so none of
### this earns one

**Inside the small-angle radius the transform tracks, from a prediction with
nothing fitted:**

```text
base      u/2π   measured   pred H1   ratio
1.1500   0.314    13.1303   11.5458   1.137
1.2293859 0.465    8.8724    9.1527   0.969
1.2560   0.513     8.0319    8.2953   0.968
1.2855907 0.565    7.5018    7.3356   1.023
1.3160   0.618     6.2766    6.3575   0.987
```

Four of five within 3%. That is entry 72's claim, holding where entry 72 said it
would hold.

**The null does not appear.** `D` at `1.5597432` is `1.0070` against a predicted
`0.3790`. The measured curve falls straight through the predicted null with no
feature: measured `3.9237` where the symbol gives `0.4483`, a factor `8.75`.
Beyond `u/2π = 0.62` the measured/predicted ratio runs 1.156, 1.507, 3.249,
**8.752**, 3.349, 1.385, 0.965 — the divergence is centred exactly on the
predicted null and closes again past it.

`argmin D` is `1.2293859`, γ₄'s candidate, at `0.8385` — but the control's own
`D_ctrl` at that same base is `0.8013`, so it is not a dip below the floor even
before the `compromised` branch fires.

Shape residual `RMS log(measured/predicted H1) = 0.8099`, dominated by the null
region.

### Two readings this run cannot separate

Either sub-leading modes fill the null — the prereg names this as the largest
doubt in advance, and γ₂'s null at `1.3483554` sits inside the same base set —
or the residual at depths 3–8 is not single-mode enough for any null to survive.
The clean tracking below `u/2π = 0.62` and the clean failure above it are
consistent with both.

Nothing is stamped. The prereg's Run record carries the same numbers and the
same unfilled verdict line.

---

## 2026-08-21 — Entry 72 — small angles make the curve: the cross-base transform, its Euler–Maclaurin cost, and why its radius is the pole lattice
type: motivation
refs: 69, 70, 71

**Julian's account, in his terms.** The b-adic tables are not separate objects.
Small angles are what create a curve, and that is what the explicit formula
does. So rather than build a table to infinite depth in every base, ask for the
**rate of change per cell across the b-adic tables** — or equivalently the
transform between them — and run that. That would give a formula for **when
local becomes global**, i.e. when the discrete table reaches the analytic
object, without ever taking a table to infinity.

He named the cost before I checked it: *"by summing averages we lose steps that
gets abstracted by the averaging, or turning the actual work of looking, where
something like our zero in a table makes the averaging work."* And the standing
goal: observe whether small shifts create big curves well enough to infer the
local data and construct a reliable approximation — here, of the zeta zeros.

**My check. The transform exists and is elementary.** All b-adic tables are one
object sampled at rate `h = log b`. Normalise a cell by `h^d`:

```text
cell_b(r,d) / (log b)^d   has symbol   ((1 − e^(−ρh)) / h)^d  →  ρ^d   as h → 0
```

base-independent in the limit. Between two bases the transform is exact with no
limit at all — just the ratio of symbols,
`((1 − b₁^(−ρ)) / (1 − b₂^(−ρ)))^d`, computable per cell.

**The cost is Euler–Maclaurin, literally.** The correction factor is
`(1 − e^(−u))/u` with `u = ρ log b`, whose expansion is the Bernoulli generating
function `u/(e^u − 1) = Σ Bₙuⁿ/n!`. Euler–Maclaurin's correction terms **are**
the steps lost when a sum is replaced by an integral. Julian named the cost from
the phenomenon; it has a name and a closed form.

**And the radius of convergence is `2π`, because the nearest singularity of
`u/(e^u − 1)` sits at `u = 2πi` — the pole lattice.** The same lattice
`Chain.sym_eq_zero_iff` proves (entry 69). So "small angles" is not a feeling.
It is `|γ log b| < 2π`.

```text
b        |γ₁ log b|    /2π
1.1175      1.5703     0.250    inside
√2          4.8987     0.780    inside
1.5597      6.2832     1.000    ON the line
2           9.7974     1.559    OUTSIDE
3          15.5286     2.471    outside
```

**Verified against the bench's own recorded numbers.** `γ₁·log 2 = 9.797445`,
and `9.797445 − 2π = 3.514260` — which is `ω₁` in `CONTEXT.md` § Core quantities
to six digits, folding to `2π − 3.514260 = 2.768926`, the recorded 2.7689. So
the small-angle boundary, the pole lattice, and Nyquist are **the same number**,
and O15's "raised the sampling Nyquist … clearing γ₁/γ₂/γ₃" and O45's *resolved*
stratum have been measuring it all along under a different name.

Consequence, derived rather than observed: inside one lattice cell the map
`ρ ↦ symbol` is injective and a single base can invert it; base 2 sits 1.56
cells out, so base 2 alone cannot recover γ₁. That is O18's "integer bases are
blind singly but not jointly," obtained from the radius rather than from a
periodogram.

**The base set is already built on this axis, which neither of us noticed.** The
O45 family is `log b_k = k · π/(2γ₁) = k · 0.111133`, so

```text
k = 4  ->  log b = 4 · 0.111133 = 0.444528 = 2π/γ₁  ->  b = 1.5597
```

and 1.5597 is the recorded family k=4 base. **k=4 is exactly the aliasing
threshold for γ₁**, with k=1,2,3 inside it and base 2 well outside. The locked
base set straddles the boundary this entry identifies, so the instrument for
testing it already exists and was locked on 2026-08-18 for a different reason.

**What is not established, and is the reason for a prereg rather than a claim.**
The transform above is exact for a single mode. A real cell is a smooth term
plus a sum over modes, and the transform acts mode-by-mode — so composite
transport is only as good as the decomposition. Whether the normalised cell
actually agrees across bases inside the radius and breaks outside it is a
measurement, not a corollary, and it is what
`preregs/small_angle_cross_base_v1_20260821.md` tests.

Nothing here is a result. This entry records the reasoning and the arithmetic
check that motivated a preregistered test.

---

## 2026-08-21 — Entry 71 — the two audit defects fixed, and the composition the chain was missing
type: formalization
refs: 68, 70

Fixes for the two findings entry 70 records as surviving. Entry 68 stands as
written; entry 70 carries the correction; this entry carries the repair.

**F1 — `Chain.tableFrom_mode` localised to the window.** The hypothesis was
`∀ n : ℤ`, which admits exactly `N ≡ 1` and `N n = (−1)^n`. It is now

```text
hag : ∀ k : ℕ, k ≤ d → ((N (r − k) : ℤ) : ℂ) = mode b ρ ((r : ℂ) − k)
```

the `d+1` entries a cell at `(r,d)` actually reads — the same form, and for the
same stated reason, as `PairIdentity.tableFrom_of_geometric`. The proof is now a
direct induction using `A1` at each step rather than routing through
`tableFrom_eq_bdiff_iter`, since that route needs global agreement.
`tableFrom_norm_on_critical_line` takes the same hypothesis.

**Verified non-vacuous by witness, because the build cannot see this.** The
geometric row `2^n` at `b = 2`, `ρ = 1` satisfies the localised hypothesis on the
window `(5,3)` reads — `32, 16, 8, 4` — and the theorem then gives
`cell = (Sym 2 1)^3 · 2^5 = (1/2)^3 · 32 = 4`, with
`tableFrom geoRow 5 3 = 4` confirmed independently by `decide`. Compiles. The
old hypothesis had no such instance at any base.

**F2 — `joint_gain_periodic_of_commensurate` gained `0 < m` and `0 < n`**, with
the docstring stating why: without them `m = n = 0` satisfies `hcomm` as `0 = 0`
for every pair of bases and the conclusion degrades to `Periodic f 0`, which
`period_vacuous_at_one` thirteen lines below proves is empty.

**And the composition the audit found missing —
`Superposition.tableFrom_eq_modeSum_reweighted`.**

```text
row agrees with modeSum at every integer
  →  (tableFrom N r d : ℂ) = modeSum b ρ (fun i => c i * (Sym b ρᵢ)^d) s r
```

Two lines: `Chain.tableFrom_eq_bdiff_iter` carries the integer table onto
`bdiff^[d]`, `depth_reweights_each_mode` carries that onto the reweighted sum.
Both existed; nothing composed them, and entry 70's grep confirmed `modeSum` and
`tableFrom` occupied disjoint sets of modules.

**Here the global hypothesis is correct and non-vacuous, and that distinction is
the whole content of the fix.** A single mode forces `w = ±1` on an integer row.
A sum does not: only the total need be integer-valued, and no individual
`cᵢ·wᵢ^n` is constrained. Conjugate pairs — `ρ₂ = −ρ₁` with `c₁ = c₂ = 1/2`,
giving `Re(wⁿ)` — are integer at every `n` with neither mode `±1`, which is how
Riemann–von Mangoldt makes a real integer row out of non-real modes. **This is
the theorem O34/O35 were measuring against** when they reported 94% / 92% / 80%
of the row-20 residual at depths 0, 3 and 6.

So entry 68's chain diagram is now true of a theorem that exists, and it runs
through `Superposition`, not through `tableFrom_mode`.

**What verified this, and what could not.** No axiom pin moved — every theorem
touched is ℂ-valued and was already at `[propext, Classical.choice, Quot.sound]`.
The build could not see either defect and cannot see either fix. What checks F1
is the witness above; what checks F2 is reading the hypothesis. `Chain.lean`
says this about itself in `gain_sq_periodic`'s docstring, and entry 70 is the
first time that gap was exercised rather than noted.

**Sequencing defect in this entry's own commit.** The Lean fixes landed at
`0f64663`, whose message announces "Entry 71" — this entry — while the entry
itself was not in the working tree, lost to a wrong-directory write. The commit
is therefore accurate about the code and premature about the record, and this
entry is committed separately after it. Recorded rather than amended: the same
reason entry 68 was left standing.

Build clean, 8037 jobs, 133 theorems, 133 pins, parity in all 11 modules. Gate
unchanged at 2, `check_values` 83 confirmed / 0 mismatches.

---

## 2026-08-21 — Entry 70 — blind adversarial audit of Chain.lean, three rounds: two real defects, both in entry 68's material, and four findings the audit itself retracted
type: result-triage
refs: 68, 69

**Method.** A subagent with no memory of the session that wrote `lean/Chain.lean`
audited it against `papers/Euler-Factor-Chain.md`. Three rounds: it reported,
then I attacked its findings, then I required it to reverse stance and argue the
file is better than it said. Read-only throughout, no fixes proposed — findings
only. Blindness is the point: it has no investment in having been helpful.

**Entry 68 is left as written.** This entry carries the correction. Rewriting a
dated entry to hide what it got wrong would defeat what the notebook is for.

---

### What survived, and it is mine

**F1 — `Chain.tableFrom_mode` does not reach the dyadic table.** Staked on by
the auditor over everything else.

`tableFrom_mode` (`Chain.lean:320`) takes
`hag : ∀ n : ℤ, ((N n : ℤ) : ℂ) = mode b ρ (n : ℂ)`. Since
`mode b ρ n = w^n` with `w = (b:ℂ)^ρ`, the hypothesis at `n = 1` puts `w` in ℤ
and at `n = −1` puts `w⁻¹` in ℤ; an integer whose inverse is an integer is `±1`.
**The hypothesis class is exactly two rows: `N ≡ 1` and `N n = (−1)^n`.** On the
critical line with `b > 0`, `|w| = b^(1/2) = 1` forces `b = 1`, where `Sym` is
identically zero.

I challenged this on branch cuts — `(b^ρ)^n` for complex `cpow` is not free. The
challenge failed and the finding got **stronger**: the outer exponent is an
integer, so it is `zpow`, and `Complex.cpow_int_mul`
(`Mathlib/Analysis/SpecialFunctions/Pow/Complex.lean:100`) has **no hypotheses at
all**, not even on `arg`. So F1 covers exactly the `b ≠ 0` the theorem states.

**And this tree already states the criterion and satisfies it elsewhere.**
`PairIdentity.lean:76-80`:

> The hypothesis is deliberately local. **No total function `ℤ → ℤ` satisfies
> `G r = b · G(r−1)` at every `r` except `G = 0`, so a global geometric
> hypothesis would be vacuous.** What a cell at `(r,d)` actually reads is the
> window `r, r−1, …, r−d`.

`tableFrom_of_geometric` takes the window-local form and is non-vacuous.
`tableFrom_mode` takes the global form. Met in one module, walked into in the
next — the auditor's words: *"I am not importing an outside standard; I am
reporting that one written in this tree was met in one module and not in the
next."*

**Consequently entry 68 is false where it is most load-bearing.** Its line
*"The hypothesis is not hypothetical for the dyadic row"* is true of a
superposition and false of `tableFrom_mode`, which is the theorem the chain
diagram there runs through. My second challenge did establish that the
**sum-level route is open** — per-summand integrality does not bite when only
the sum must be integer-valued, witness `ρ₂ = −ρ₁`, `c₁ = c₂ = 1/2`, giving
`(iⁿ + (−i)ⁿ)/2 = Re(iⁿ) ∈ {1,0,−1,0}`, which is how Riemann–von Mangoldt makes
a real integer row out of non-real modes. But that route is **unwritten**:
verified by exhaustive grep, of 11 modules, `modeSum` occurs in
`Superposition.lean` only and `tableFrom` in five others, and the two sets are
**disjoint**. `Superposition.lean:12` is `import Chain`, so the dependency runs
the wrong way. Entry 68 cites a legitimate route no theorem takes.

**F2 — `joint_gain_periodic_of_commensurate` has no `0 < m`.** At `m = n = 0`
the hypothesis `hcomm` reads `0 = 0`, satisfied by **every** pair of bases
including incommensurate ones, and the conclusion is `Periodic f 0`. I tried
four ways to break this and could not; `Function.Periodic.nat_mul`
(`Mathlib/Algebra/Ring/Periodic.lean:131`) has no `n ≠ 0`. The theorem is true
and has real instances; the defect is that **`hcomm` is not a commensurability
condition**, so the theorem does not carry the content its docstring and
`second_ladder_winds_densely`'s back-reference attribute to it. This is the trap
`period_vacuous_at_one` proves, thirteen lines below, un-closed.

**F8 — the inert `hA4` also silences the linter**, settled from the linter's
source rather than by analogy: `linter.unusedVariables.funArgs` defaults **true**
so signature binders are flagged, `analyzeTactics` defaults **false** so a dead
`have` is invisible. Effect confirmed; the auditor withdrew any imputation of
intent, the docstring disclosing the inertness in plain words.

**Minor and disclosed:** `StmtC2` encodes one of paper C2's three conjuncts
without saying so (the periodicity conjunct is now `gain_sq_periodic`, 300 lines
away); the file header's "every theorem here takes the antecedent statements as
HYPOTHESES" describes about 6 of 25; `Chain.h` duplicates `EulerFactorChain.h`
byte-for-byte with nothing enforcing it.

---

### What the audit retracted, and why it matters

**F4 demoted by its own steelman — and this bears on handoff item 1c.** Round 1
found `StmtB5` and `StmtB4` provably equivalent modulo `norm_pow` and called it
"drops the depth side." Required to argue the other case, it conceded:
`(Sym b ρ)^N` **is** the depth side, named rather than unfolded — it is
precisely the multiplier `StmtA4` says `bdiff^[N]` applies. Writing
`bdiff^[N] (mode …)` in would drag `‖mode‖` onto both sides and turn an identity
about a **weight** into one about a **ratio**. What survives is narrow: the
docstring says `hA4` mirrors "the paper's stated dependency," and paper B5 cites
`A1 + B4` (`Euler-Factor-Chain.md:46`), not A4 + B4. **So the handoff plan's
"most serious defect" is milder than recorded there.**

**F3 retracted, and it exonerates the paper's structure.** `StmtA3`'s first
conjunct is definitional — `EulerFactorChain.sym_natCast` is `by simp [sym]` —
so `A4_of_A1` is the honest arrow and the paper's `A3 ·` citation is the loose
one. The auditor also withdrew, as outright false, its claim that nothing
carries the Euler-factor reading onto the critical line: `Chain.lean:70` is
`∀ s : ℂ`, unrestricted. It had quoted the disproving line in round 1.

**F6 retracted, and it exonerates the paper's arithmetic.** The exponents differ
by exactly one because **the depth-0 row is itself already one difference of π**.
`CONTEXT.md:91-96`: the block holds `(b−1)b^(r−1)` slots and each difference
multiplies by `(b−1)/b`, giving `(b−1)^(d+1)b^(r−1−d)` — the `d+1` is `1` for the
row plus `d` for the depth. The paper counts relative to π; Lean counts relative
to the row; both internally correct. What remains is that Chain.lean never says
which frame it is in and names its binder `N`, the paper's symbol for the other
frame.

---

### The bias check

Round 3 required the auditor to argue against itself. It named four places its
adversarial framing manufactured a defect, the sharpest being F3: it **quoted
the docstring that disproved its own finding** and argued past it, and asserted
the critical-line claim with `∀ s : ℂ` on screen. *"An adversary who has found a
'disconnected component' narrative stops checking, and I did."* On F6: the frame
was in a file it had read in full, *"because 'off-by-one between paper and Lean'
is a satisfying find."* On two others: prose notes promoted to findings because
an empty rubric slot reads as a failed audit.

**This is the reason for three rounds rather than one.** A single pass returns
ten findings and no way to tell which four are artifacts of being paid to find
some.

### What the file does well, from a reviewer with no reason to be kind

`period_vacuous_at_one` exists solely to prove a neighbouring hypothesis is
load-bearing, and correctly names the axis `#guard_msgs` cannot protect.
`C3lower_of_A4_C2` drops `0 < b` because the proof does not consume it, with the
rationale written down. `StmtC3lower` uses `|·|` because the unbarred form,
though true, is contentless for `0 < b < 1`. `StmtA3` volunteers its own negative
scope unprompted. And **`StmtA2` is more honest than the paper it formalises** —
paper A2 states the Euler product with no convergence condition, which is false
as written; the Lean carries `1 < s.re`.

### Standing

Two real defects, both in entry 68's material, both introduced 2026-08-20, and
**both invisible to the build** — `Chain.lean:396-397` says why: `#guard_msgs`
pins an axiom list and a near-vacuous theorem has an ordinary one. Both are
pinned and both pins pass.

Lean fixes follow in a separate entry. Nothing above is a fix; this entry is the
record of what the audit found.

---

## 2026-08-21 — Entry 69 — the circle comes from the pole lattice, and the fold is now an identity on cells
type: formalization
refs: 33, 55, 60, 68

Entry 68 built the torus and never said where it came from. Both ends of the
chain were loose: the circle had no origin, and the fold existed in Lean only as
facts about the stencil's *weights*, never about a cell. Six theorems close both.

**The pole lattice — `Chain.sym_eq_zero_iff`.**

```text
Sym b s = 0  ↔  ∃ k : ℤ, s = k · (2πi / log b)
```

These are the poles of `1/Sym`, the reciprocal Euler factor. It is the
`2πik/log 2` lattice of Flajolet, Grabner, Kirschenhofer, Prodinger and Tichy
(`papers/literature/litsearch_1_hinge.md` § 3), and it is the lattice
`EulerFactorChain.lean:112` already excludes in prose — *"it excludes the whole
`sym b s = 0` lattice"* — without ever stating it.

**`Chain.sym_periodic`** — `Sym b (s + 2πi/log b) = Sym b s`, because
`b^(−2πi/log b) = exp(−2πi) = 1`. The symbol returns to itself after one lattice
step. **That is the origin of the circle**: `γ` is an angle because the symbol's
own zero set is a lattice of that spacing.

**`gain_sq_periodic` rewritten to derive from it.** Entry 68 proved the same
period from `Real.cos_add_two_pi` — true, and the symptom. The cause is the
lattice. Same period, correct derivation, and the torus now has a reason inside
the chain rather than beside it in the record.

**The fold, on cells — four theorems in `Zeros`.**

```text
wingPlus  / wingMinus            the even- and odd-index arms, unsigned
stencil_eq_wings                 stencil N g = wing⁺ − wing⁻      an IDENTITY
stencil_eq_zero_iff_wings        stencil N g = 0 ↔ wing⁺ = wing⁻
tableFrom_eq_zero_iff_wings      cell = 0 ↔ the window's wings balance
repeat_iff_wings                 the repeat reading = the fold reading
```

`stencil_weights_antisymm`, `stencil_arms_eq` and `stencil_arm_doubled` were
already there but are about the **weights**. Nothing split an actual cell by
parity. `papers/The-Fold.md` § B calls the arms the wings — 807295 each at
`(20,6)`, 168 each at `(8,3)` — and entry 55 records that the fold is an
identity, `wing⁺ − wing⁻ = cell`, true everywhere. It is now that in Lean.

**`repeat_iff_wings` is the bridge that did not exist.** `zero_iff_repeat` says
a cell vanishes iff the row repeats one depth below. The fold says it vanishes
iff the wings balance. Both were in the tree; nothing connected them. They are
one statement, and the connection runs through entry 60's stencil equation.

So the two readings of a zero — `(20,6) = 0` because `d5` reads 623 at both
`r = 19` and `r = 20` (`The-Fold.md` § C1), and `(20,6) = 0` because the wings
weigh 807295 each — are now provably the same fact.

Build clean, 8037 jobs, 132 theorems, 132 pins, parity in all 11 modules. Gate
unchanged at 2, `check_values` 83 confirmed / 0 mismatches.

**Still outside Lean, named so it is not searched for again.** The zeros-as-poles
reading of entry 33 and `The-Four-Zeros.md` § E3 — the ratio `composite/prime`
singular at exactly the four cells — is prose only; `pole` and `ratio` occur
nowhere in `lean/` in that sense. And `lean/BUILD.md` still records block D (the
winding) and block G (the transform radius, the annulus of modulus `(log b)/4π`)
as observations. Block G is the z-plane route to the same circle, so one of the
object's two coordinates remains unformalised.

---

## 2026-08-20 — Entry 68 — the seam welded: tableFrom IS bdiff, and the chain runs from the integer table to the torus
type: formalization
refs: 59, 60, 61, 66

**The defect.** `lean/Chain.lean` proved things about `bdiff` on `ℂ → ℂ`.
`lean/Construction.lean` proved things about `tableFrom` on `ℤ → ℤ`. They are
the same backward difference on two domains, and **no theorem in the tree joined
them.** So the formalisation read as two stacks with prose between, not one
chain. Nothing was wrong; nothing was connected.

**Seven theorems, all landed in `Chain.lean`, which now also imports
`Construction`.**

*The weld.*

```text
tableFrom_eq_bdiff_iter   g agrees with N at every integer
                          -> (tableFrom N r d : ℂ) = (bdiff^[d]) g r
tableFrom_mode            + A4  ->  cell = (Sym b ρ)^d * mode b ρ r
tableFrom_norm_on_critical_line   the modulus form C2/C3 bound
```

`tableFrom_mode` is `StmtA4` read on the integer table. After it, every arrow
below the seam applies above it: an integer cell of the dyadic table is an
object the analytic half of the file has theorems about.

*The circle — this closes handoff item 1b.*

```text
gain_sq_periodic       Periodic (fun γ => ‖Sym b (1/2 + γi)‖²) (2π / log b)
period_vacuous_at_one  at b = 1 the same statement holds for EVERY f
```

`EulerFactorChain.gain_sq_on_critical_line` already had the content — the gain
depends on `γ` only through `cos(γ log b)` — so `γ` is an angle, not a line, and
the gain closes after `2π / log b`.

**`b ≠ 1` is load-bearing and the second theorem proves it.** At `b = 1` the
period is `2π/0 = 0`, and `Function.Periodic f 0` is true for any `f` at all —
so the unguarded statement is true and empty exactly at the degenerate base.
`period_vacuous_at_one` is that fact, compiled. **`#guard_msgs` cannot catch
this**: a vacuous theorem has an ordinary axiom list. The handoff flagged the
risk; it is now a theorem rather than a warning.

*Two ladders.*

```text
joint_gain_periodic_of_commensurate   m·P₁ = n·P₂  ->  joint gain periodic
                                      in ONE variable: the circles collapse
second_ladder_winds_densely           steps dense on the b₁-circle
                                      <-> log b₁ / log b₂ irrational
```

The second is Kronecker, via `AddCircle.denseRange_zsmul_coe_iff`. Together they
are the dichotomy: **commensurate ladders close into one circle, incommensurate
ones fill a torus**, and the whole content is whether the ratio of logs is
rational. The first is entry 54 and 56's trap stated as a theorem — a base set
commensurate by construction forces cross-base alignment rather than finding it.

*The inversion was already there*: `EulerFactorChain.h_functional_equation`,
`h b N (1 − s) = h b N s`, whose fixed set is the critical line.

**So the chain is now unbroken and is one object:**

```text
the table                 Construction         ℤ, no axioms
cell = Pascal             entry 60             tableFrom = stencil
tableFrom = bdiff^[d]     HERE                 the seam
cell = Sym^d · mode       HERE                 via A4
dia/col = √b              entry 61
period 2π/log b           HERE                 the circle
commensurate | torus      HERE                 Kronecker
s ↦ 1 − s                 h_functional_equation
```

All seven at `[propext, Classical.choice, Quot.sound]`. That is the floor and it
is correct: every statement mentions ℝ or ℂ. Entry 66's boundary reads exactly
right here — the table above the seam is axiom-free, everything below it is not,
and the seam is where the arithmetic becomes analytic.

**Gotcha worth recording.** `Chain.Sym` collides with Mathlib's `Sym`, the
symmetric-power type. Unqualified inside a file that opens Mathlib it silently
resolves to Mathlib's and the errors are about universe levels, not about `Sym`.

**On the hypothesis form.** `tableFrom_mode` takes "the row agrees with a mode"
as a hypothesis. That is this file's method, not a gap in it — see its header,
lines 9–12: every theorem here takes the antecedent statements as hypotheses and
derives the consequent, so that Lean can refuse a leap. A hypothesis is a
quantifier, not an assumption: the theorem is a complete, kernel-checked proof
about every row of that kind. The `A4` it calls is itself unconditional
(`Chain.lean:263`), as C1 became when it was discharged.

**What the chain shows.** The hypothesis is not hypothetical for the dyadic row.
`Superposition.lean` exists precisely to license A4 on a **sum** over zeta zeros
— its header: *"Every use of it on the bench applies it to a SUM over zeta zeros
(O34, O35). Nothing so far permits that step. This file supplies it."* And the
decomposition is measured: `CONTEXT.md` § O34/O35 — **94% of the row-20 residual
at depth 0, 92% at depth 3, 80% at depth 6, from the explicit formula alone,
nothing fitted.**

So with the weld in place the chain reads end to end on the actual table:

```text
cell(r,d)                      integer, computed from π
  = (bdiff^[d]) on the row     tableFrom_eq_bdiff_iter, here
  the row is a superposition of modes b^(rρ)      explicit formula
  ρ = 1/2 + iγ, the zeta zeros                    O34/O35, 94/92/80%
  each mode reweighted by (Sym b ρ)^d             Superposition
  ‖Sym‖ inside [1−b^(−1/2), 1+b^(−1/2)]           C2, C3, C3lower
  phase periodic in γ with period 2π/log b        gain_sq_periodic, here
  two ladders: one circle, or a torus             Kronecker, here
  s ↦ 1 − s fixes the critical line               h_functional_equation
```

**Every cell of the dyadic table is a sum over the zeta zeros, each reweighted
by its own factor at depth `d`.** That is the mechanism, it is measured at
80–94% across depths 0 to 6, and every algebraic step in it is now a
kernel-checked theorem rather than a "therefore" in prose.

**What is underived, stated narrowly.** The chain gives the weight each zeta
zero carries into a cell. It does not say when that weighted sum — main term
included — lands on integer `0` exactly. Four cells do. Why those four is not
derived by anything here.

**And one measured limit, which is a result and not a caveat.** O34/O35 do not
extend to deep cells: at `(25,21)` the model flips sign between 200 and 600
zeros, because the depth operator spreads each zero's gain over `(d+1)×0.765`
decades. So the 80–94% agreement is established at depths 0–6 and the method
runs out below that — measured, in `CONTEXT.md` § O34/O35, not assumed.

Build clean, 8037 jobs, 126 theorems, 126 pins, parity in all 11 modules.

---

## 2026-08-20 — Entry 67 — the 12 oversized NOTEPAD lines truncated, and the gate baseline re-cut to 2
type: instrument-fix
refs: 63, 64, 65

Julian approved. `check_refs.py` had flagged 12 NOTEPAD lines over the 400-char
limit, 479 to 2944 chars against a median of 132. Ten cited an entry holding the
same text verbatim and could be shortened outright. **Two cited nothing**, so
truncating them would have destroyed the only copy — those were backfilled first
as entries 64 and 65, then shortened to point at them.

All 12 now carry `entry N:`. Longest thread line is 357 chars, under the limit.
No status transitions: every one is still `[open]`.

**The gate went from 14 broken references to 2**, and
`utilities/refs_baseline.txt` was re-cut to match. What remains is the two
declared-PENDING references in `papers/The-Composite-Arm.md` — its own header
lists them as conditions of becoming canonical, and they close when the t25
composite-arm script is written. (Naming that file here would itself be a
broken reference — the checker caught exactly that on the first draft of this
entry.)

Prior results comparable: no reference resolved differently, `check_values.py`
unchanged at 83 confirmed / 0 mismatches, `lake build` clean at 8037 jobs.

---

## 2026-08-20 — Entry 66 — SeedPerturbation and PairIdentity off Mathlib; the floor is 60, not 0
type: formalization
refs: 59, 60, 61

Continuation of entry 59, which did `Construction`. Same method, two more
modules, plus the measurement that bounds how far this can go.

**Result.** `Classical.choice` fell 84 → 71 across the tree.

```text
                    before   after
SeedPerturbation      10        0     20 theorems, no Mathlib surface at all
PairIdentity           4        0     symbol_at_one moved out; see below
```

`SeedPerturbation.tableFrom_eq_zero_of_vanishing_above` — the gating theorem for
the seed protections — is now `[propext]`, from all three. Entry 59 predicted
this file would port cleanly and it did. It also builds in **340 ms** instead of
~10 s, because there is no Mathlib to load.

**`symbol_at_one` moved to `EulerFactorChain`.** It was `PairIdentity`'s only
ℂ-valued statement and is a restatement of
`EulerFactorChain.symbol_of_backward_difference` at `ρ = 1`, so it belongs where
`sym` lives. Checked first that no paper cites it — only entry 45 does, by bare
name, which still resolves.

**`grind` is not a shortcut, and this is the load-bearing measurement.** Lean
core ships `grind`, and it discharges the `ring`-shaped ℤ goals that `ring`
was doing. Measured in a Mathlib-free file: **`grind` costs
`[propext, Classical.choice, Quot.sound]`** — all three, with no Mathlib
present. So it defeats the entire purpose, and every `ring` had to be replaced
by a hand chain of core `Int.` lemmas.

Also Mathlib-only, and each needing a core rewrite: `by_contra` (replaced by a
`match` on `(by omega : 1 < b - 1 ∨ b = 2)`), `rcases` (`match`), `ring_nf`,
`linarith`, `nlinarith` (replaced by `Int.mul_lt_mul_of_pos_left` plus
`Int.mul_one`), `norm_num`, `push_cast`, `pow_pos`, `mul_right_cancel₀`,
`mul_eq_zero`. `omega` stays — measured at `[propext, Quot.sound]`, no
`Classical.choice`.

**The floor is 60 of 119, and it is not a defect.** Of the 71 remaining, 60
mention ℝ or ℂ, and Mathlib constructs ℝ with `Classical.choice`, so no proof
style removes it:

```text
Chain 16 · EulerFactorChain 16 · Measured 7 · Covering 6 · Crossover 6
GeneratorPeak 6 · Superposition 3            = 60, permanent
Zeros 11                                     = the only portable remainder
```

**`Zeros` is mixed and was not attempted.** Of its 11: six are the `stencil`
theorems, which need `Finset.range` replaced by a fold; four
(`factorization_proportional`, `primeFactors_eq_of_meets`, `base_of_meets_two`,
`window_exclusive_of_prime_exponent`) rest on Mathlib's prime-factorization
theory and are not portable at any reasonable cost; and one is entry 60's
`tableFrom_eq_stencil`, which took the `fwdDiff` bridge precisely because the
direct induction was harder. So the realistic floor is **64**, not 60, unless
`Zeros` is split. That is an architectural call and is Julian's.

Build clean at 8037 jobs, 119 theorems, 119 pins, parity in all 11 modules.

---

## 2026-08-19 — Entry 65 — figures/coverage.png had no script either; t15 reconstructs it, and finds one transcription slip
type: provenance
refs: 64

Backfilled 2026-08-20 from the NOTEPAD line that held this record, so the line
could be shortened without losing its only copy. Same situation as entry 64 and
recorded separately because `coverage.png` is **not** among that entry's six.

`figures/coverage.png` was committed at `3da2ee8` with **no script** — its
analysis was inline too. Reconstructed as
`analysis/2026-08-19_table_structure/scripts/t15_cell_coverage.py`, which
**postdates the result it reproduces**, exactly as t9–t14 do.

**Reproduced.** Every per-base mean, zero-mean and z, to printed precision.

**One disagreement, and it is a transcription slip rather than a computational
difference.** Base 6's per-zero counts are `[0, 1, 2, 2]`, not the reported
`[0, 1, 1, 3]` — and `[0, 1, 1, 3]` is **base 7's** list. Both sum to 5, so the
mean 1.25 and the z −1.04 were unaffected, which is why it went unnoticed.

**The kill reproduces.** Maximum distinct coverage values at any fixed depth is
2, across all 224 depth-base pairs, because the window's width in b-rungs is
`(d+1)·ln2/ln b` — a function of `d` ALONE.

**Corroboration.** The zeros' mean depth has z = −0.99, the same ≈ −1.0 that the
coverage z gives at every base. So coverage's z **is** the depth z.

---

## 2026-08-19 — Entry 64 — six analyses ran inline with no script saved; t9–t14 reconstruct them, and two do not fully reproduce
type: provenance
refs:

Backfilled 2026-08-20 from the NOTEPAD line that held this record, so the line
could be shortened without losing its only copy. Nothing here is new work; it is
the same text, given an entry to live in.

Six analyses reported on 2026-08-19 were run **inline as heredoc commands with
no script saved**, so the results predate any reproducible instrument.
Reconstructed as `analysis/2026-08-19_table_structure/scripts/`
`t9_subthreshold_ladder.py`, `t10_blocksum_lowpass.py`,
`t11_decimation_alias.py`, `t12_chain_vs_orphan.py`, `t13_signflip_crossover.py`,
`t14_s_matched_control.py`, and re-run.

**The scripts postdate the results they reproduce** — mtimes 12:23–12:25 against
a session that ended at 12:09. They are reconstructions from the reported
numbers, not the code that produced them.

**Ordering evidence**, from file mtimes: 11:01 `shape32.py`, 11:35
`t5_2d.py`/`spectrum2d.png`, 11:41 `t6_multirate.py`/`multirate.png`, 12:03
`coverage.png` (its analysis was inline too, no script survived, and it is NOT
among the six — see entry 65), 12:06 `t7_phase.py`/`phase.png`, 12:09
`t8_subzeros.py`. The six inline analyses fell between those marks and their
exact times are **not recoverable**; the interleaving above is the only
chronology there is.

**What reproduced.**

* **t10** exact — base 4 = dyadic in pairs True, base 8 in triples True,
  Dirichlet 0.1853 / 0.2876 / 0.1725 at ω 2.7689, four zeros at exactly
  `(2,1) (4,1) (8,3) (20,6)` for merge k=1 and 0 for k=2..6 at 2^48.
* **t11** exact — `fold(k·parent alias) = direct alias` to ≤ 1.8e−15 for bases
  4/8/16/9/27 at 0.7453 / 2.0236 / 1.4907 / 0.3588 / 2.6035; base 9 at 0.86
  cycles.
* **t12** exact — 0.5197–0.5346 across bases 2–9 at 2^48, orphan mean 0.5242,
  chain mean 0.5321, where "chain" is the three bases WITH a parent (4, 8, 9),
  not the five in any chain; 2 and 3 are roots at 0.5253.
* **t13** exact — dyadic flip crossover d=7 matching t2's spectral 7, triadic 12
  against spectral 10, bases 4–9 flat 0.00 at every depth, invariant for
  MIN_ROW 3..8.
* **t14** within Monte Carlo error — observed 26.744 exact, matched null
  25.724±0.744 against a reported 25.731±0.747, i.e. 1.3 MC standard errors;
  z +1.37 vs +1.36, p 0.915 vs 0.909. Its S recomputation by the Pascal
  recurrence matched `results/sub_integer_base_scan.json` at all 121 zeros, 0
  mismatches.

**What did not.** t9's *structure* reproduced exactly — rung counts
142/186/233/248/286/317/358, Nyquist 17.23/22.48/28.28/30.10/34.62/38.51/43.44,
and every base recovering exactly the zeros beneath its own ceiling — **but 6 of
the 7 recovered γ values differ in the third decimal**: 21.021 vs 21.022, 25.018
vs 25.016, 30.448 vs 30.449, 32.927 vs 32.924, 37.644 vs 37.645, 40.934 vs
40.933; only 14.141 identical. Differences reach 0.003 against a periodogram
resolution element of 0.243 rad, so agreement is well inside resolution — but
the exact digits are **not** reproduced, and the inline original must have
differed in some detail. The grid was tested at four spacings and all give the
same peaks to 0.003, so it is not the grid.

**Also unrecovered.** t9 finds γ₈ = 43.3271 beneath base 1.0750's Nyquist 43.44,
with its peak at 43.565 — ABOVE the ceiling — which the reported table did not
list. Nothing was tuned to close any gap.

---

## 2026-08-20 — Entry 63 — six NOTEPAD lines were inside the header's own format example; the trap removed and the checker taught to see it
type: instrument-fix
refs: 53, 54, 55, 56, 57, 58

**What was wrong.** `notes/NOTEPAD.md` opened with a `Format (strict, for grep):`
block whose fenced example contained
`- [STATUS] YYYY-MM-DD  entry N: terse one-line description` — a line shaped
exactly like a real thread. Six lines, citing entries 53 through 58, had been
prepended "to the top of the file" and landed **inside that fence**, above the
template line, instead of under `## Threads`.

**Why nothing caught it.** `check_refs.py` reads NOTEPAD.md raw rather than
fence-stripped, so the six were length-checked and format-checked and passed
both — they are well-formed lines in the wrong place. **The checker had no
notion of place.** `CLAUDE.md` § Rule — load, don't recall already names this
file as one that "contains examples of itself", and the rule did not prevent it,
because a rule you have to remember at write time is not a check.

**Root cause is duplication, not carelessness.** `notes/notes_format.md:39`
says the NOTEPAD format is system-wide, lives at `~/GitHub/NOTEPAD_TEMPLATE.md`,
and is "Not restated here." NOTEPAD.md restated it anyway — a third copy of a
spec that already existed twice, and the copy is what people fall into.

**Three changes, Julian approving each.**

1. The `Format (strict, for grep):` fence and its `STATUS is one of:` line
   deleted from `notes/NOTEPAD.md`, replaced by a pointer to
   `~/GitHub/NOTEPAD_TEMPLATE.md`. The `Common greps` fence stays — nothing has
   ever been prepended into it, because it does not look like entries.
2. The six lines moved into `## Threads`, immediately below entry 59's, in their
   existing order. **Content byte-identical; no status transitions.** Relocation
   only — every one of them is still `[open]`.
3. `utilities/check_refs.py` now tracks whether it has passed the `## Threads`
   heading, and reports any `- [status]` line above it as BROKEN.

**Tested in both directions.** A line planted above `## Threads` is caught —
`BROKEN NOTEPAD.md -> line 9 is above "## Threads"`. On the repaired file the
check is silent.

**Prior results comparable.** The baseline diff is empty: 14 broken references
before and after, the same 2 declared-PENDING plus 12 oversized lines. The six
moved lines were under 400 chars and already passing every other check, so no
count moved. `check_values.py` unaffected — it reads `papers/` only.

**Still open, not fixed here.** The 12 oversized NOTEPAD lines, and the fact
that entries 53, 55, 56, 57 and 58 carry the date 2026-08-21 against commits
timestamped 2026-08-20. Both are Julian's to decide; the dates in particular
cannot be corrected by an agent without changing the dated record.

---

## 2026-08-20 — Entry 62 — the joint cross-base test has never been run on the exact zeros, only on the gammas
type: motivation
refs: 49, 52, 54, 56

**Scope observation, from Julian.** Entry 52's `(40,12)` result was cited in
conversation as evidence that the four exact zeros are not a feature of any
cross-base structure. That citation is too broad, and the entry's own text says
why: the test was at `b = 2^(1/2)`, where `(40,12)` is "the exact image of base
2's `(20,6)` under factor-2 refinement: `r` doubles, `d` doubles."

`(√2)^(2r) = 2^r`. Base 2 is every other rung of the √2 ladder. So entry 52
tested **resolution**, not **coupling** — whether the zero survives sampling the
same ladder finer. It does not, and that stands. It is not a test of whether
structure runs between ladders that are independent of each other.

**The gap.** Two designs exist in the tree and have never been combined:

* O18 coupled incommensurate ladders and it worked. Base 2 alone NULL, base 3
  alone NULL, the joint orbit `{2^m 3^n}` detecting γ₂ at P/median 6.95, three
  generators reaching γ₄. `CONTEXT.md` § O18. **Object: the γ's.**
* O44 scanned the exact zeros across bases 2–9, 1289 pair-identity cells, and
  found only base 2 has any (entry 49). **Method: one table at a time.**

O18's whole lesson was that "blind singly" and "blind jointly" are different
questions. For the exact zeros only the first has been asked.

**Why it is not a straightforward test.** A γ-detection is a spectral statistic
computable on any orbit; an exact zero is an integer cell in one table. "Joint"
needs a construction producing one number from two ladders. O44's pair-identity
scale coordinate is one candidate already in the tree.

**The trap this design walks into.** Entry 56 and entry 54: eight of O45's
eleven bases are exact multiples of `π/(4γ₁)` in log, commensurate *by
construction*, carrying 107 of 125 zeros — so cross-base alignment was forced by
the base choice rather than found, and entry 54 records the surface question as
unanswerable with that base set. Any joint design must fix its base set against
commensurability first or it measures its own arithmetic.

**Not evidence it would find anything.** O44's base-by-base answer was a clean
no. This entry records that a question is unasked, which is not a prediction
about its answer. No test proposed, no prereg, nothing run.

---

## 2026-08-20 — Entry 61 — the diagonal gain is `√b`, derived rather than measured
type: formalization
refs: 45

`analysis/2026-08-19_table_structure/CHAIN.md` lines 1360-1370 record
`dia/col = 1.414214` against `sqrt(b) = 1.414214`, 615 cells, 0 failures, with a
prose derivation: along a diagonal `r − d = c` a mode picks up
`b^(cρ)·[b^ρ − 1]^d`, so the per-step factor is `b^ρ − 1` rather than the
column's `1 − b^(−ρ)`, and the two differ by exactly `b^ρ`.

**`sqrt` and `b^(1/2)` occur nowhere in `lean/`.** Checked across all eleven
modules. `PairIdentity.exponent_const_on_diagonal` and
`PairIdentity.total_const_on_diagonal` prove the diagonal is the trend's level
set and that this is unique to `b = 2`; neither says anything about the gain
ratio. The measured fact had no formal counterpart.

**Four theorems, drafted and compiling.** Against `EulerFactorChain.sym b ρ =
1 − b^(−ρ)`:

```text
diagonal_gain               b^ρ * sym b ρ = b^ρ − 1
diagonal_cell               b^((d+c)ρ) * (sym b ρ)^d = b^(cρ) * (b^ρ − 1)^d
diagonal_over_column        (b^ρ − 1) / sym b ρ = b^ρ          (sym b ρ ≠ 0)
diagonal_over_column_at_half  b^(1/2) = √b                     (0 ≤ b)
```

All four at `[propext, Classical.choice, Quot.sound]`. That is the floor, not a
defect: the statements are ℂ-valued, and ℝ is constructed with `Classical.choice`
in Mathlib, so no proof style removes it. Compare entry 59 — the split is real.

`diagonal_gain` needs only `b ≠ 0`; the `√b` specialization needs `0 ≤ b`.
Route: `Complex.cpow_add`, `Complex.cpow_nat_mul`
(`Mathlib/Analysis/SpecialFunctions/Pow/Complex.lean:109`), `Real.sqrt_eq_rpow`
and `Complex.ofReal_cpow` (`.../Pow/Real.lean:984` and `:278`).

**Not in the tree.** Draft at the session scratchpad as `diagonal_gain.lean`;
landing it means editing `lean/EulerFactorChain.lean` and adding four
`#guard_msgs` pins, which was not done. What is recorded here is that it
compiles, not that it is committed.

---

## 2026-08-20 — Entry 60 — the operator IS Pascal: `tableFrom = stencil`, and the zeros as one line each
type: formalization
refs: 45, 52, 59

`lean/Zeros.lean:88` defines `stencil N g = ∑ k ∈ range (N+1), (−1)^k C(N,k) g k`
and proves it linear, antisymmetric, and constant-annihilating. **No theorem
connected it to `Construction.tableFrom`.** The two objects sat in the same
tree, one the recurrence and one the closed form, with nothing asserting they
agree.

**Now proved, drafted and compiling:**

```text
tableFrom_eq_fwdDiff    tableFrom N r d = (−1)^d * (fwdDiff (−1))^[d] N r
                        [propext, Quot.sound]
tableFrom_eq_stencil    tableFrom N r d = stencil d (fun k => N (r − k))
                        [propext, Classical.choice, Quot.sound]
```

Route is Mathlib's `fwdDiff_iter_eq_sum_shift`
(`Mathlib/Algebra/Group/ForwardDiff.lean:143`), which carries the binomial
theorem. Our backward difference is `(−1)^d` times its forward one at step
`−1`; the sign folds because `d + (d − k) = 2(d − k) + k` for `k ≤ d`, so
`(−1)^(d+(d−k)) = (−1)^k`. A direct induction with `Finset.sum_range_succ'` and
Pascal was attempted first and abandoned — the index-shift bookkeeping is worse
than the bridge.

**What it buys.** A cell stops being a table walk and becomes one linear
equation on `d+1` values of the row. Checked against real counts, from the
depth-0 row `N(r) = π(2^r) − π(2^(r−1))` for `r = 1..8` = `1,1,2,2,5,7,13,23`:

```text
(8,3) zero      23 − 3·13 + 3·7 − 5 = 0      by decide, no axioms
(7,3) non-zero  13 − 3·7  + 3·5 − 2 = 5      by decide, no axioms
```

The non-zero is deliberate: without it the check only fires in one direction.

This does **not** predict a location and is not evidence toward one. It moves
the four zeros from four transcribed pairs in `Construction.measured_zeros` to
four explicit Pascal-weighted conditions on π. The arithmetic input remains
π(2^r) and always will.

**Not in the tree.** Draft at the session scratchpad as `stencil_equation.lean`;
landing it means editing `lean/Zeros.lean` and adding two pins.

---

## 2026-08-20 — Entry 59 — Construction.lean off Mathlib: two of the three axioms were the library's, not the mathematics'
type: formalization
refs: 45, 47

**Claim under test.** That the integer half of the tree was at
`[propext, Classical.choice, Quot.sound]` because of what it proves. It was not.
It was because every module opens with `import Mathlib`, and Mathlib's generic
ring and order instances are classical.

**Measured, in a Mathlib-free file against Lean core only:**

```text
                                  with Mathlib                      core only
tableFrom_add          [propext, Quot.sound]                        [propext]
tableFrom_smul         [propext, Quot.sound]                        [propext]
zero_determined_by_row [propext, Quot.sound]                        [propext]
tableFrom_zero         [propext]                                    none
vanishing_above        [propext, Classical.choice, Quot.sound]      [propext]
```

`vanishing_above` is `SeedPerturbation.tableFrom_eq_zero_of_vanishing_above`,
the gating theorem for the seed protections of entry 47. It had been read as
capped by inheritance from `Construction.zero_determined_by_row`; the cap was
Mathlib's floor, not the theorem's.

**Cost table for core tactics**, measured, no Mathlib:

```text
rfl / decide / induction / Nat→Int cast     no axioms
simp, named core Int lemma                  [propext]
omega                                       [propext, Quot.sound]
```

So `Classical.choice` came from Mathlib's instances and `Quot.sound` came from
`omega` — and `omega` was only ever reached for casts that are definitional.
`r − ((k+1 : ℕ) : ℤ) = r − 1 − (k : ℤ)` closes by `rfl`;
`Mathlib/Init/Grind/Norm.lean:82` proves the Nat→Int cast by `rfl`.

**A named lemma can be worse than a tactic.** Replacing `ring` with Mathlib's
`mul_sub` in `tableFrom_smul` *raised* the count to include `Classical.choice`,
because `mul_sub` is stated over a general ring. Core's `Int.mul_sub` does not.
Reverted before this work began; recorded because it is counterintuitive.

**Landed.** `lean/Construction.lean` no longer imports Mathlib. `lake build`
succeeds at 8037 jobs. Two changes beyond the proofs were forced:

1. Core has no `ℕ`/`ℤ` notation. Declaring it unqualified breaks every
   downstream import — `environment already contains 'termℤ' from
   Mathlib.Data.Int.Notation`. `local notation` fixes it.
2. `PairIdentity.tableFrom_add_window` dropped `Quot.sound` **by inheritance**
   and its pin had to be updated. The `#guard_msgs` check caught it, which is
   the check working in the improving direction.

Tree tally moved 15 → 11 at `[propext, Quot.sound]` and 8 → 12 at `[propext]`.
`Classical.choice` is unchanged at 79 of 113: `Construction` never carried any.
Moving that number requires `SeedPerturbation` (10 theorems, and it uses no
Mathlib surface at all) and the ℤ half of `PairIdentity` (3).

**The boundary this exposes.** 55 of the 79 `Classical.choice` theorems mention
ℝ or ℂ. Those can never drop it — ℝ is built with choice in Mathlib. So the
axiom line, once the integer modules move, *is* the arithmetic/analytic
boundary, printed by the compiler rather than argued in prose.

Verified separately: axiom lists are fixed in the proof term at elaboration, so
a downstream `import Mathlib` cannot raise them. `Zeros`, `PairIdentity` and
`SeedPerturbation` still import Mathlib and read `Construction`'s theorems at
their reduced counts.

---

## 2026-08-21 — Entry 58 — one of NEXT.md's two "written record errors" is not an error
type: result-triage
refs: 57

`lean/NEXT.md` has carried two corrections as outstanding since it was written.
Both were checked against artifacts today. One is real. The other is two
different quantities being compared as if they were one.

**Not an error — the G4 six-zero spread.** NEXT.md says the spread "is 8.56%,
recorded as 8.4%". Both numbers are correct and they measure different things.

`results/O24_gen_xmax3e9_run.log` carries two G4 tables.

Line 156, "P/median AT THE SIX gamma_n" — the value of the statistic *exactly
at* each γₙ:

```text
37.25863  36.93211  38.25230  36.83018  35.27244  36.70965
(max−min)/min = 8.4481%   ->  8.4%
```

Lines 205–210, "TEN LARGEST LOCAL PEAKS — G4" — the height of the local peak
*nearest* each γₙ, all six in band:

```text
38.299307  37.258633  36.932107  36.837708  36.760192  35.279641
(max−min)/min = 8.56%
```

`CONTEXT.md:299` and `lab_notebook.md` entry 42 report the first.
`papers/The-Four-Prime-Peak.md` § E2 reports the second, and its source line
names the table it used. Neither is wrong and neither should be edited to
match the other. **Recorded so that a later reader does not "fix" one of them.**

The distinction is not cosmetic: a peak *near* γₙ and the value *at* γₙ differ
by however far the peak sits off the zero, and G4's offsets run 0.0020 to
0.0209. Which one is the right statistic depends on the question, and the two
documents are asking different ones.

**Real — the 247-cell attribution.** `CONTEXT.md:305` credits the reproduction
of `files (2)/unit_weighted_dyadic_table.csv` across 247 cells to **O27**. It
is **O16's GATE A**: `results/O16_run2.log` lines 229–244 read "cells compared
: 247, mismatches : 0" for that file and for `composite_unit_dyadic_table.csv`,
then "GATE A: PASSED". No O27 log mentions 247 or that CSV. O27's own
contribution — the joint dyadic/triadic table to r = 41 — is separate and
stands.

**Method note.** NEXT.md is prose, and its claims were propagated into a commit
message before being checked. The artifacts settled both in under a minute.
Third time in this session that a recorded defect inverted on inspection: the
`§ B4` citations were valid, O42's Run record was already filled, and now this.

## 2026-08-21 — Entry 57 — two scripts quoted a rule that changed, and one artifact now disagrees with its script
type: provenance
refs: 53, 54, 55, 56

**What changed.** `O23_alignment_replication.py` line 1250 and
`O44_cross_base_zero_scan.py` line 10 both carried this verbatim in their
STATUS text: *"Currently only 07/O7 is preregistered."* That sentence was
copied out of `CLAUDE.md` § Prereg discipline when each script was written.

It is now wrong twice over. There are four locked preregs —
`alpha_depth_trend`, `zero_winding_phase`, `extended_zero_census`,
`sub_integer_base_scan` — and as of 2026-08-20 all four carry verdicts:
`depth_dependent`, `no_constant_angle`, `magnitude_floor`, `fineness`.
The CLAUDE.md line the scripts quoted no longer exists.

**Fix.** Both now cite `CONTEXT.md` § "Current state of the world" instead of
enumerating, and both say why: an enumeration goes stale, and this one did.
The same move that took the lab-notebook type vocabulary from four copies to
one and the prereg mechanics out of CLAUDE.md.

**Not an instrument-fix.** Nothing about what either script measures changed.
No re-run was performed and none is needed; prior results remain comparable.

**A divergence, recorded rather than repaired.** O23's sentence sits inside a
JSON output field, `exploratory_note`. So
`results/O23_alignment_replication_results.json` and
`results/O23_alignment_replication_results_run2.json` still contain the old
text. They are frozen records of what the script said when it ran and are
correct as they stand. The script and those two artifacts now differ by that
string, deliberately. A re-run would close the gap and is not worth the churn.

**The general shape.** A quoted rule is a copy, and copies go stale silently
because nothing checks prose against its source. `utilities/check_refs.py`
catches a citation that does not *resolve*; it cannot catch one that resolves
to text saying something different from what the quoter claims. That gap is
open and nothing in the tree closes it.

## 2026-08-21 — Entry 56 — t24: one fact that had been found five times
type: run
refs: 54, 55

EXPLORATORY. No prereg, no decision rule, nothing here is a verdict.

**Script.** `analysis/2026-08-19_table_structure/scripts/t24_commensurability.py`,
no flags, run 19:09:54. Output
`analysis/2026-08-19_table_structure/results/t24_commensurability.txt`.

**Question.** Whether `log b₁ / log b₂` is rational had decided at least five
results on this bench, each time under a different name. This computes the one
quantity behind all five.

**Headline.** Among integer bases 2…9 the commensurate pairs are exactly the
power chains 2-4-8 and 3-9; bases 5, 6, 7 meet nothing. The sub-integer scan's
family and antiphase arms are all `exp(π·m/(4γ₁))`, so all eight are integer
multiples `m = 2…9` of one unit, `π/(4γ₁) = 0.055565153` in natural log — the
scan is commensurate by construction. For `(20,6)`'s window ratio `2⁷ = 128`
no integer base but 2 reaches it at integer depth; for `(8,3)`'s `2⁴ = 16`,
base 4 reaches it at depth exactly 1.

**What it collects.** The same arithmetic appears as the mechanism in
`t6_multirate` (incommensurability breaks the alias comb), the kill in
CHAIN.md §10 (no inheritance between bases), the obstruction in t22 (the scan
cannot answer its own question), the censoring note in `The-Four-Zeros` § C5,
and a theorem — `Zeros.window_exclusive_of_prime_exponent`, which settles it
for one window and turns on 7 being prime.

**Written up as** `papers/Commensurate-Ladders.md`. Its § F3 records that the
general ladder-intersection statement is the one piece of arithmetic every
result above leans on and was not in the Lean tree; `Zeros.base_of_meets_two`,
`factorization_proportional` and `primeFactors_eq_of_meets` have since closed
the dyadic case and the proportionality, and the ancestor construction remains.

## 2026-08-21 — Entry 55 — t23: the deep zeros as two weighed halves, and one correction to the record
type: run
refs: 54

EXPLORATORY. No prereg, no decision rule, nothing here is a verdict.

**Script.** `analysis/2026-08-19_table_structure/scripts/t23_fold.py`, no
flags, run 06:02:02. Output
`analysis/2026-08-19_table_structure/results/t23_fold.txt`.

**Question.** Can the deep zeros be read as a balance rather than a vanishing?

**Headline.** The stencil weights `(−1)^k C(7,k)` are antisymmetric about the
window midpoint at `log₂ x = 16.5`, so `(20,6)` is a sum over four straddling
pairs with no leftover term. Split by sign, each arm carries total weight 64
and the two arms weigh **807295 each** on eight values of π sharing no term.
The same wing split reaches `(8,3)`: weights `1,−4,6,−4,1`, arms 8 and 8,
totals **168 and 168**.

**Control.** `(21,6)` folds to 1713, which is `cell(21,6)`. The fold is an
identity for odd stencil order, not a test — every cell equals its folded sum
whether or not it vanishes. `wing+ − wing− = cell` identically, so the wings
cannot be evidence for anything the cell value does not already say. Both are
recorded in the paper as § A4 and § B7 rather than presented as findings.

**Correction to the record.** `(25,11)` was placed on diagonal 13 in
conversation; it is on 14. Caught because the number did not resolve to the
result file. Script and paper both fixed in the same pass.

**Written up as** `papers/The-Fold.md`.

## 2026-08-20 — Entry 54 — t22: the zero surface is unanswerable with this scan, and the base set is why
type: run
refs: 50, 51, 52

EXPLORATORY. No prereg, no decision rule, nothing here is a verdict.

**Script.** `analysis/2026-08-19_table_structure/scripts/t22_zero_surface.py`,
no flags, run 05:05:24. Output
`analysis/2026-08-19_table_structure/results/t22_zero_surface.txt`.

**Question.** Do O45's 125 pooled zeros form a connected object across bases,
or an interval that merely happens to be occupied? Measured as cross-base
nearest-neighbour distance in the `(lo, hi)` window plane, against a null drawn
from each base's own resolved support, stratified so base composition matches.

**Headline.** Cross-base: observed 0.3745, null mean 1.0524 sd 0.0611,
z = −11.10. Within-base control: observed 1.2550, null mean 3.4454 sd 0.2250,
z = −9.73. The control moves too, so the compression is not about crossing
bases — it is present at every base separately. Width-matched null halves it
to z = −5.32 rather than collapsing it.

**Why it does not count.** The sorted window list carries exact `lo` repeats
across different bases, which is not an accident. Eight of the eleven bases
have `log₂ b` an exact integer multiple of `π/(4γ₁)`, and those eight carry
107 of the 125 zeros. There is no incommensurate pair anywhere in the scan, so
cross-base window alignment is forced by the base selection. The statistic
measures the prereg's choice of bases, not the arrangement of the zeros.

**Written up as** `papers/The-Zero-Surface.md`. The commensurability finding
is also the scope note now attached to O45's `fineness` verdict.

## 2026-08-21 — Entry 53 — t26: `d*` is not a per-base constant, its slope is — and a subcritical base crosses
type: run
refs: 41, 52

EXPLORATORY. No prereg, no decision rule, nothing here is a verdict.

Written to settle the two CONTESTED banners placed on
`analysis/2026-08-19_table_structure/CHAIN.md` §3 and §4 on 2026-08-20.

**Script.** `analysis/2026-08-19_table_structure/scripts/t26_crossover_by_r.py`,
new, no flags. Output `analysis/2026-08-19_table_structure/results/t26_crossover_by_r.txt`. `t2_crossover.py` is unchanged and its result stands — t26 is a
different measurement, not a re-run, so prior numbers remain comparable.

**Method.** t2 computes `d*` once per base over the whole depth-0 row: the
first depth at which oscillation carries more than half the spectral power.
t26 computes the identical statistic on the row truncated to its first `r`
rungs, sweeping `r`. That makes `d*` a function of `r` rather than a scalar.
Same window, same DC/oscillation split, same `min_n = 10` floor.

**Result 1 — `d*` is not a per-base constant.** Every one of the eight bases
shows `d*` rising with `r`. Dyadic runs `d* = 3` at `r = 13` to `d* = 7` at
`r = 32`. So CHAIN.md §4's fit `d* ≈ 1.1 + 8.1·ln b` correlates eight numbers
that are not constants. `papers/Depth-as-Time.md` § D2 is upheld against it.

**Result 2 — the per-base quantity is the slope.** `d*(r)` is close to
proportional, `d* ≈ c(b)·r`:

```text
base          b        ln b     slope    slope/ln b
family k=1    1.1175   0.1111   0.0125   0.1125
family k=2    1.2489   0.2223   0.0324   0.1458
2^(1/3)       1.2599   0.2310   0.0339   0.1467
family k=3    1.3957   0.3334   0.0635   0.1905
2^(1/2)       1.4142   0.3466   0.0611   0.1763
family k=4    1.5597   0.4445   0.0814   0.1831
dyadic        2.0000   0.6931   0.2023   0.2919
```

`corr(ln b, slope) = +0.9735`, fit `slope ≈ 0.3246·ln b − 0.0409`. So §4 found
a real relationship and attached it to the wrong variable. The correlation
survives the correction; the quantity it correlates does not.

**Result 3 — a subcritical base crosses.** `papers/Depth-as-Time.md` § C4 says
bases with gain ratio below 1 have "no instability at any depth, at any `r`".
Family k=4 has ratio 0.5553 and crosses at `d* = 1` by `r = 11`, rising to 5.
CHAIN.md §3's observation was correct and the contradiction is real.

**Reading, and it is harsher than either section.** All eight bases cross,
including the subcritical one, each at a fixed fraction of `r`. A statistic
that fires on every table at `d* ≈ c(b)·r` is not measuring the § C3
instability — it is measuring something that happens to any table with depth,
plausibly the shrinking row length. So the resolution is not "§ C3 is wrong":
t2's `d*` and § C3's crossover are different quantities that were being
compared as if they were one.

**Against O33.** `Depth-as-Time` § D3 reports slope 0.3031 for b=2 from O33's
turnaround series. t26 gives 0.2023 on this statistic. Different quantity,
different turnaround; neither refutes the other, and they are not
interchangeable.

**Open.** What `d*` actually tracks. If it is row length, `d*` should scale
with the number of surviving points rather than with `b`, and the
`slope/ln b` column — which drifts 0.11 → 0.29 rather than staying flat — is
the place to look. Nothing here tests that.

## 2026-08-19 — Entry 52 — O46/O47: `density ≈ 1/S` refuted, the zeros live in the thin tail, and (20,6) does not survive refinement
type: result-triage
refs: 47, 50, 51

Two EXPLORATORY reads of entry 51's run of record — no prereg, no
p-value, nothing stamped. `O46_mass_density_check.py` →
`results/mass_density_check.json` (24,756 B) +
`results/mass_density_check_run1.log` (126 lines), 2026-08-19T07:43:07Z;
`O47_high_mass_zeros.py` → `results/high_mass_zeros.json` (180,549 B) +
`results/O47_high_mass_zeros_run1.log` (278 lines), 08:09:13Z. Both open
O45's script and JSON read-only and both re-derive its stratum:
geometry matches the locked table at all eleven bases, zero sets match
O45 exactly, and O46's mass recurrence agrees with O45's
`stencil_mass()` over 2297 cells, **0 mismatches**. No cell violates
`|cell| ≤ S` and no resolved cell has `S = 0`, so not one zero in the
run is arithmetically forced.

**The mechanism proposed, and its refutation.** `mass_bound` is exact:
a cell is a signed integer in `[−S, S]`, `S(r,d) = Σ_k C(d,k)·N(r−k)`.
If cell values were spread over that range, landing on 0 would go like
`1/S` — a parameter-free prediction with no free constant, testable in
two forms. Both fail:

```text
  density x mean(S)    min 3.07433e+09   max 4.25686e+47   spread 1.38465e+38
  density / mean(1/S)  min 0.617483      max 3.43727       spread 5.56658
```

A spread of 1 would be exactly constant. The parameter-free product
spreads by 38 orders of magnitude. The sharper form is far better
behaved — a factor of 5.6 — but it does not cluster at 1 either: eight
of the eleven bases sit between 2.30 and 3.44, base 2 at 1.72, and two
bases fall below 1 (`2^(1/3)` at 0.617, antiphase `k = 4` at 0.799).
Clustering at 2–3 is a real regularity and is not the prediction.

**And the premise itself is false.** `|cell|/S` over the resolved
stratum has median between **3.52e−4** (`2^(1/2)`) and **2.20e−3**
(`2^(1/3)`), so roughly `1e−3` at every base. Cells sit three orders of
magnitude inside their own bound. They are not spread over `[−S, S]`,
so the chance of hitting 0 was never `1/S`, and the two spread factors
above are measuring a model that was wrong at its first line.

**What replaced it: the zeros live in the extreme thin tail of the mass
distribution.** Per base, median `S` at a resolved zero against median
`S` over the whole resolved stratum:

```text
  median S at a zero        8  to  516     across the eleven bases
  median S over the stratum 2.40e+07 (base 2) to 3.55e+18 (finest base)
```

Base by base the ratio of the two runs from **5.4 orders** of magnitude
(antiphase `k = 4`) to **17.1** (the finest family base); base 2's own
is 5.7. The typical zero is a cell with almost nothing to cancel. Which
makes the high-`S` end the interesting end, and it is what O47 ranks.

**Checked and only half true: zero density does rise with `b`.** The
claim carried into this entry was that density rises roughly
monotonically across the eleven bases with base 2 the maximum at about
4× the finest. Recomputed from `zeros_per_resolved_cell` in
`results/sub_integer_base_scan.json`, identical to `density` in
`results/mass_density_check.json` at all eleven bases: base 2 **is** the
maximum at 8.065e−3, and the finest base is 2.067e−3, a ratio of
**3.90**, so "about 4×" holds. "Roughly monotonically" does not, as
written. Four of the ten adjacent steps in `b` decrease, and two bases
sit far off any trend — `2^(1/3)` at 8.40e−4, a quarter of its
neighbours, and antiphase `k = 4` at 2.32e−3. The rank trend is real but
moderate: Spearman ρ = 0.655, Kendall τ = 0.564 (43 concordant pairs
against 12 of 55), permutation p ≈ 0.017 one-sided. Direction yes;
monotone no.

**The pooled ranking, 125 resolved zeros across all eleven bases.**
Base 2's four carry `S = 2, 4, 88, 492384` and land at pooled ranks
**115, 102, 37 and 3** — three of the four in the bottom quarter, and
`(20,6)` third from the top. Above it sit two cells of `2^(1/2)`:

```text
   1  2^(1/2)  (34,11)  S = 1371038   log2 window [11.5, 17.0]
   2  2^(1/2)  (42, 5)  S =  651298   log2 window [18.5, 21.0]
   3  base 2   (20, 6)  S =  492384   log2 window [14.0, 20.0]
   4  antiphase k=2 (47,4)  S = 87160
```

and the largest ratio gap anywhere in the pooled list is exactly the one
after rank 3: **5.649** = 492384/87160 = 61548/10895 exactly. So the
high-mass end is a four-cell club — two at `2^(1/2)`, `(20,6)`, and one
antiphase cell — and then it falls off a cliff. `(20,6)` is no longer
the most massive cancellation on record.

**The (40,12) result, and it is the sharp one.** At `b = 2^(1/2)`, the
cell `(40,12)` is the exact image of base 2's `(20,6)` under factor-2
refinement: `r` doubles, `d` doubles, and the window bottom `b^(r−d)`
lands on `2^14` as `b^r` lands on `2^20`. O47 checks the identity
directly rather than assuming it — `identical integer bounds: True`,
window `(16384, 1048576]` on both sides, `80125` primes in the window
on both sides. The **same primes, the same value interval, the same
question asked at twice the resolution.** The cell reads

```text
  base 2      (20, 6)   cell =     0     S =   492384
  base 2^(1/2)(40,12)   cell = -6884     S = 15723924    |cell|/S = 4.378e-04
```

`(20,6)` **does not survive refinement.** And `4.378e−04` is not a near
miss on the scale of anything — it sits essentially at that base's
median `|cell|/S`, which is 3.52e−4.

**Set that against `SeedPerturbation`.** `lean/SeedPerturbation.lean`
proves that a change of seed convention replaces the depth-0 row `N` by
`N − e` and, by linearity plus locality, cannot touch a cell whose
window bottom clears the last rung `e` moves: `R < r − d` gives
`cell_eq_of_seed_perturbation`, and `boundary_can_move` shows the strict
inequality is sharp. Entry 47 measured the same thing from the data —
`(8,3)` and `(20,6)` are unmoved by three seed conventions, six
composite variants and two repos, while `(2,1)` and `(4,1)` sit close
enough to the seed to be reached. So `(20,6)` is **robust to seed
changes and fragile to resolution changes**, and those were never the
same invariance: one is about what the bottom of the window reads, the
other about how finely the window is sampled between its endpoints.
Nothing in `SeedPerturbation.lean` claimed the second, and nothing in
it is contradicted. (It is not yet recorded anywhere in this notebook;
`lean/lakefile.toml` now globs eleven modules against the ten entry 45
counted.)

Both scripts EXPLORATORY, `summary.verdict` null in both files. Nothing
above is a verdict and nothing here bears on O45's empty verdict line.

No outcome marked.

---

## 2026-08-19 — Entry 51 — O45 run: 121 resolved sub-2 zeros, 35 clearing the mass floor, p = 0.0839 — the verdict line is empty and is Julian's
type: run
refs: 44, 49, 50

`O45_sub_integer_base_scan.py`, one run at the locked flags,
**PREREGISTERED** against entry 50's protocol. Lock written
2026-08-19T07:16:07Z; `run_start_utc` = `run_end_utc` =
2026-08-19T07:16:38Z — thirty-one seconds after lock, and the run
completes inside one second. Python 3.14.3, `code_version`
`f06f6f3c…`. Artifacts `results/sub_integer_base_scan.json` (177,989 B)
and `results/O45_sub_integer_base_scan_run1.log` (50,589 B, 746 lines).
`pi2n_cache.json` read, not written; nothing under `imported/`,
`lean/` or `preregs/` opened for writing.

**Sidecar.** `preregs/sub_integer_base_scan_v1_20260818.sha256` reads
`7985c94015bab8d8f2e606b69aaeac79150ccec1d4ec9d04bca7db177c02aaf5`, and
the Run record's `post_compute_sha256` is the same string — so no
parameter, hypothesis or decision-rule text drifted between lock and
compute.

**Check 1, π backend.** `primecountpy.prime_pi` 0.2.1, **33 of 33**
audit comparisons equal against `pi2n_cache.json`, including
`π(2^32) = 203280221` backend and cache. PASS.

**Check 2, geometry.** All eleven bases recompute `r_max`,
`cells_at_d_ge_1`, `r_thick` and `resolved_cells` equal to the locked
table — `geometry_matches_locked` true for every base. Minimum relative
distance of any `b^r` to an integer over the whole support is
**1.665e−12** at antiphase `k = 1` and `k = 2`, the same number the
prereg pre-computed, forty-eight orders above the dps-60 floor and far
above the 1e−30 determinacy threshold. `root_selfcheck_failures` 0 at
both refinement bases. `summary.compromised_conditions` is `[]`.

**Check 3, base-2 reproduction.** Through the identical code path at the
same value ceiling, base 2 rebuilds `[[2,1],[4,1],[8,3],[20,6]]` over
496 cells — the known set, no more and no fewer. A reproduction check,
not evidence; the prereg says so and so does the log.

**Check 4/5, the scan and the rate test.** The primary statistic:

```text
  resolved cells   base 2   496     sub-2  37178
                                    family 20661  antiphase 11236  refinement 5281
  Z_2  (base 2, resolved)         : 4
  Z    (sub-2, resolved)          : 121
  Z*   (of those, S >= 88)        : 35     family 13  antiphase 18  refinement 4
  E[Z] under H0                   : 299.822580645161  (locked value, reproduced)
  conditional-binomial p (PRIMARY): 8.394656e-02   [exact]
  Poisson p (SECONDARY)           : 6.367145e-32
  alpha_level                     : 0.05, one-sided
```

Zeros on the **full** support total 240 across the ten sub-2 bases
against 121 resolved — the resolved criterion discards a little over
half of them, which is what entry 50 designed it to do. Per base,
resolved zeros: family 29 / 14 / 9 / 7, antiphase 21 / 15 / 10 / 2,
refinement 11 (`2^(1/2)`) and 3 (`2^(1/3)`). Every one of the eleven
bases has at least two resolved zeros.

**The mechanical output of the decision rule is `fineness`**, by
`Z* ≥ 1`, not `family_only`, not `refinement_only`, and
`p = 0.0839 > 0.05`. That is the rule's arithmetic and nothing more.
`summary.verdict` is `null` by design and `verdict_note` reads "the
verdict line is Julian's to write in the prereg's Run record"; the Run
record's `- verdict:` line is **empty**. This entry does not fill it and
does not read the branch as a result.

**What the run eliminates, stated in the prereg's own terms.**
`intrinsic_base_two` required `Z = 0`; `Z = 121`. So "sub-2 bases stay
empty" is off the table on the resolved stratum as well as on the full
one — and not marginally: mass-clearing zeros appear in **all three**
arms, family, antiphase and refinement alike, which is what closes
`family_only` (`Z*_antiphase = 18 ≠ 0`) and `refinement_only`
(`Z*_family = 13 ≠ 0`) as well. `thin_rung_forced` needed `Z* = 0` and
`Z* = 35`, so the surplus is not confined to the thin end of the
stratum. The one thing the run does **not** eliminate is a rate below
base 2's: `p = 0.0839` sits above alpha, but 121 against an H0
expectation of 299.8 is well under half, and the prereg's own stated
weakness 1 — resolved cells at neighbouring `r` share most of their
stencil, so the independence assumption makes `p` anti-conservative
*against* H0 — cuts in exactly that direction.

**A wrinkle in the new convention, undecided.** Lines 5–8 of the prereg,
immediately under `STATUS: **LOCKED**`, read: "There is no sidecar
`sub_integer_base_scan_v1_20260818.sha256` yet; the sidecar is the
authority on lock, and its absence means this prereg is not locked."
That text is now false — the sidecar exists — and it sits **inside the
hashed region**, which measurement confirms: the sidecar hash is the
SHA-256 of the file's first 680 lines, and lines 5–8 are among them. So
the sidecar pins a paragraph asserting the file is unlocked, three
lines below a STATUS block asserting it is. The file cannot be edited
to fix it without breaking the sidecar match that the Run record
depends on. This is a wrinkle in the naming convention entry 44
introduced — the drafting boilerplate assumes the pre-lock state and
nothing strips it at lock time — not a defect in this prereg's
protocol, every parameter of which reproduced. Julian's call.

No outcome marked.

---

## 2026-08-19 — Entry 50 — the O45 prereg: fineness against intrinsic, and the empty-rung discovery that forced the resolved stratum
type: prereg
refs: 44, 45, 49

`preregs/sub_integer_base_scan_v1_20260818.md`, 695 lines as it now
stands. It asks one question of entry 49's 4-in-496 / 0-in-496 result:

```text
  fineness   base 2 is the finest INTEGER sampling of the scaling flow,
             so bases BELOW 2 - finer still - should produce zeros at
             at least base 2's per-resolved-cell rate.       [H0]
  intrinsic  base 2 is special in itself, so sub-2 bases stay empty
             and the point prediction is Z = 0.              [H1]
```

The fork is licensed by entry 45's finding that `pair_identity` takes
**no hypothesis on `b`**, and by `lean/Chain.lean`'s `C1` needing only
`0 < b`: `π(b^r) − π(b^(r−1))` is well defined for real `b > 1` and the
cells stay integers. `E[Z] = Z_2·C_sub/C_2 = 4 × 37178 / 496 =
299.822580645161`, stated as a number before the run.

**Four drafting complications, all resolved inside the locked text.**
The section is headed "The three complications" and then lists four,
`(a)` through `(d)` — a wording slip inside the hashed region, recorded
not corrected.

*(a) The pair identity is only approximate at non-integer `b`.*
`tableFrom_add_window` (linearity plus locality) is exact for any seed
rows and any `b`; `tableFrom_of_geometric` needs the rung
`(b^(r−1), b^r]` to hold exactly `(b−1)·b^(r−1)` integers, and at real
`b` it holds `⌊b^r⌋ − ⌊b^(r−1)⌋`. So O44's `nu` denominator is not
reused as such. Two totals are locked and both reported:

```text
  total_geo (b,r,d) = (b-1)^(d+1) * b^(r-1-d)        O44's denominator
  total_true(b,r,d) = sum_k (-1)^k C(d,k) W(r-k),  W(r)=|b^r|-|b^(r-1)|
```

The drift is not small: at `b = exp(π/(2γ₁))`, `(199,20)` has
`total_geo = 1.16e−11` against `total_true = −86804`, and 9601 of that
base's 19701 cells have `total_true ≤ 0`, which a positive geometric
quantity cannot do. `nu_pair = |cell|/|total_true|` is primary.

*(b) Fair comparison is by value range, not by `r`.* Bases are matched
on a **value ceiling** `V = 2^32` — base 2's extent in entry 49 — with
`r_max(b)` the largest `r` with `b^r ≤ V`, locked per base rather than
recomputed. `b = 1.11754` needs `r = 199` to reach where base 2 needs
32, and carries 19701 cells against 496; that asymmetry *is* the
fineness prediction, so every count is reported with its denominator.
Second consequence, load-bearing: `ln(b^r) ≤ ln V` at every base and
rung, so the prime density `1/ln x` entering any cell is bounded
identically across the list — density-matched by construction, not by
correction.

*(c) `(b−1)^(d+1) < 1` below 2, and the naive reading of it is wrong.*
`PairIdentity.coeff_eq_one_iff_base_two` covers integer `b ≥ 2` only.
For `1 < b < 2` the coefficient **shrinks** with depth: `total_geo` at
the ceiling drops below 1 from `d = 9, 13, 17, 21` at the four family
bases, against supports running to `d = 198, 98, 65, 48`. Read naively
that is O43's magnitude floor in reverse, forcing zeros over nearly the
whole sub-2 support. It is wrong for exactly the reason in (a):
`total_geo` is not the size of anything at a non-integer base. Floor
jaggedness is `O(1)` per rung and the stencil's L1 weight is `2^d`, so
deep sub-integer cells are **large**. The prereg's own sentence: "The
reverse magnitude floor, in the form O43 met it, does not apply."

*(d) A third outcome exists.* Zeros might appear only at the optimal-base
family `exp(πk/(2γ₁))`, which is neither account. Hence **non-family
controls in the same range**: four antiphase bases `exp(π(2k+1)/(4γ₁))`,
interleaved between consecutive family members and exactly half a
quarter-turn off the family in its own coordinate; and two refinement
controls `2^(1/2)`, `2^(1/3)`, of which base 2 is a literal
sub-sampling — the sharpest available test of fineness. Eleven bases,
`C_2 = 496` against `C_sub = 37178`, split 20661 family / 16517
non-family, so `family_only` cannot be an artefact of the controls
having had no chance. Labels `family_only` and `refinement_only` exist
for it.

**The discovery that shaped the design, and it fired before the run.**
At the finest base `b = exp(π/(2γ₁)) = 1.11754…`, `⌊b^r⌋ = 1` for
`r = 0…6` — the first six rungs hold no integers at all. Under this
project's convention (`π(1) = 0`) that gives `N(r) = 0` there and
`cell(2,1) = N(2) − N(1) = 0` **exactly**, a zero about an empty rung
and nothing else. Every sub-2 base has such a region. So `Z_full ≥ 1`
was guaranteed before a single prime was counted and "sub-integer bases
stay empty" was already false on the full support — for reasons
unrelated to the hypothesis. That is why the primary statistic is the
**resolved** count: a cell counts only if every rung its stencil reads
is expected to hold at least one prime, `W(r')/ln(b^(r')) ≥ 1` for all
`r' ∈ [r−d, r]`, equivalently `r − d ≥ r_thick(b)`. Pure geometry, no
prime counted to evaluate it, so `r_thick` and `resolved_cells` are
locked per base. At `b = 2` the criterion holds over the entire support
(`r_thick = 1`, all 496 cells, all four zeros kept) — one more sense in
which base 2 is the boundary case.

**Decision rule and vacuousness.** Eight labels, precedence
`compromised > thin_rung_forced > family_only > refinement_only >
fineness > rate_below_base_two > intrinsic_base_two > ambiguous`, keyed
on `Z`, on `Z*` (resolved zeros with `S ≥ mass_floor`) and on an exact
conditional-binomial `p`. The pre-computed p-table gives the smallest
`Z` with `p > 0.05` as **101** — a third of H0's own point prediction —
so `fineness` needs 101 mass-clearing zeros in 37178 resolved cells and
`intrinsic_base_two` needs none. Both directions reachable.

**Provenance, and the non-blind half.** `mass_floor = 88` is
`S(8,3)` at base 2, chosen with base 2's four masses `S = 2, 4, 88,
492384` already in view; the resolved criterion was fixed after the same
base-2 rebuild. Both are **calibrated on already-inspected data** and
only their application to the sub-2 bases is blind. Entry 49's results
were read in full while drafting. The genuinely blind arm is that no
sub-integer base had ever been computed here by anyone — the drafting
agent evaluated π at no sub-integer argument, and every locked geometric
quantity came from `⌊b^r⌋` alone.

**First prereg locked under the no-status-in-filename convention** that
entry 44 recorded into `CLAUDE.md`. Named
`sub_integer_base_scan_v1_20260818.md` at creation, no `_locked_`
infix, with the sidecar as the authority on lock. `lock_written_at`
2026-08-19T07:16:07Z, `locked_by` julian, `pre_compute_sha256` PENDING.
Measured for this entry, the sidecar
`7985c94015bab8d8f2e606b69aaeac79150ccec1d4ec9d04bca7db177c02aaf5`
is the SHA-256 of the file's **first 680 lines** — everything through
`- locked_by: julian` — so the locked region is the whole protocol and
the `## Run record` section was appended afterward.

No outcome marked.

---

## 2026-08-18 — Entry 49 — O44: base 2 is the only integer base with exact zeros, and entry 17's conclusion survives by a route entry 17 did not take
type: run
refs: 17, 45, 46, 47

`O44_cross_base_zero_scan.py`, one execution, **EXPLORATORY** — no
prereg, no hypothesis, no decision rule, nothing here is a verdict.
Invocation read back from `params.argv`:

```text
python3 O44_cross_base_zero_scan.py --data-dir imported/lattice_mapper/32bit \
    --bases 2,3,4,5,6,7,8,9 --d-min 1 --top-k 10 --pair-check --variant-scan \
    --out results/cross_base_zero_scan.json
```

`run_start_utc` = `run_end_utc` = 2026-08-19T06:30:13Z, completed;
Python 3.14.3; `code_version` `3ae5a3f1…`. Sixteen of the twenty-two
imported CSVs read, all read-only. Artifacts
`results/cross_base_zero_scan.json` (99,469 B) and
`results/O44_cross_base_zero_scan_run1.log` (25,995 B). The convention
in force is the **imported** one — 2 and 3 excluded as lattice (entry
46) — stated in `constants.convention` and `constants.convention_adjusted_for
= false`, so low-`r` numbers here do not compare with anything in
`results/`.

**The coordinate.** Raw `|cell|` compares across neither bases nor
depths, so O44 divides the pair identity's total out:
`nu(b,r,d) = |cell| / [(b−1)^(d+1)·b^(r−1−d)]`, every ranking on an
exact `Fraction`. That denominator is `pair_identity` of
`lean/PairIdentity.lean`, which entry 45 recorded as carrying **no
hypothesis on `b`** — which is what licenses using it at eight bases
at once.

**Extent and exact zeros at `d ≥ 1`** (`summary.per_base`):

```text
   b  file                              maxr maxd  cells  d>=1  zeros
   2  dyadic_difference_table_32.csv      32   31    528   496      4
   3  triadic_difference_table_32.csv     32   31    528   496      0
   4  tetradic_difference_table_32.csv    32   31    528   496      0
   5  pentadic_difference_table_27.csv    27   26    378   351      0
   6  hexadic_difference_table_24.csv     24   23    300   276      0
   7  heptadic_difference_table_22.csv    22   21    253   231      0
   8  octadic_difference_table_21.csv     21   20    231   210      0
   9  enneadic_difference_table_20.csv    20   19    210   190      0
```

Base 2's four are `(2,1) (4,1) (8,3) (20,6)` — the same set entry 47
read out of this same file. Base 3 is empty over the **identical** 496
cells, same ceiling and same support, so 4-in-496 against 0-in-496 is
the one uncensored comparison the table contains.

**Bases 4–9 are uninformative, and the reason is visible in where their
minima sit.** Every one of them takes its minimum `nu` on the **corner
cell** `(max r, max d)`: `(32,31)`, `(27,26)`, `(24,23)`, `(22,21)`,
`(21,20)`, `(20,19)`, at `nu` 0.0134, 0.0186, 0.0196, 0.0203, 0.0203,
0.0205. A minimum on the boundary of the support is a statement about
where the table stops, not about a floor. Bases 5–9 are additionally
extent-censored in `r_max` (27, 24, 22, 21, 20); base 4 is **not** — it
reaches `r = 32` with the same 496 cells as bases 2 and 3, and is simply
empty. Recorded because the two facts are distinct and only base 4
carries both a full extent and a corner minimum.

**The correction to entry 17, and it does not damage entry 17's
conclusion.** Entry 17 records of `triadic_difference_table_32.csv`
that "Base 3 reaches **1**, twice". Both of those cells are here and
both read `|cell| = 1` exactly — `(3,2)` and `(5,4)`, re-read from the
imported copy for this entry. But their totals are `2^3·3^0 = 8` and
`2^5·3^0 = 32`, so normalised they are `0.125` and `0.03125`, and
**neither is in base 3's ten smallest `nu`** (`summary.per_base[1].smallest_nu`,
which runs 9.77e−4 to 7.87e−3). Base 3's actual closest approach is

```text
  base 3   (11,10)   cell 2   total 2048   nu = 2/2048 = 9.765625e-04
  base 2   (13, 5)   cell 1   total  128   nu = 1/128   = 7.8125e-03
```

so base 3 comes **eight times closer proportionally** than base 2's
smallest nonzero cell does — exactly `8`, both being dyadic rationals.
Entry 17 argued base-2 extremality from magnitude and then recorded
that the magnitude argument fails to separate the bases. It fails
harder than entry 17 said: on the normalised reading base 3 is the
*closer* of the two and still never lands. Entry 17's conclusion — base
2 is where the zeros are — survives, but by the route "base 3 gets
closer and still misses", not "base 2 gets closest".

**The pair identity holds on data this project did not generate.**
Three matched pairs, `summary.pair_identity_checks`:

```text
  plain prime + plain composite                  528 cells   0 mismatches
  prime_full_silenced + plain composite          410 cells   0 mismatches
  plain prime + (composite − prime)              351 cells   0 mismatches
                                       total    1289 cells   0 mismatches
```

The third runs in mode `diff_plus_2p`. The five unmatched variants in
§ 4b mismatch at 90, 91, 40, 59, 59 cells and are flagged
`expected_to_mismatch = true` in the JSON — entry 47's arithmetic, put
on the record rather than assumed.

**One anomaly, surfaced and not chased.**
`imported/lattice_mapper/32bit/dyadic_diff_full_silenced_32.csv` is one
of the six 32bit CSVs O44 did **not** read. Measured for this entry: it
is exactly `composite_full_silenced − prime_full_silenced`, 410 of 410
cells, so it is a `C − P` table like `composite_minus_prime_32.csv`.
But it satisfies the identity against **nothing on disk**. In mode
`sum` it mismatches all twenty of the directory's other regime-keyed
CSVs (the wide `prime_composite_sidebyside_32.csv` excluded); in mode
`diff_plus_2p` its best partner is either dyadic prime arm at **59**
mismatches of 410 — and 59 is precisely the number of cells at which
its own parent pair fails, `C_fs + P_fs ≠ 2^(r−1−d)` at 59 of 410. Entry
47 cites this file as agreeing at `(4,1) = 6`, `(8,3) = 16`,
`(20,6) = 8192`, which it does; what it does not do is belong to a pair.
Not chased here.

Still EXPLORATORY. Nothing above is a verdict and nothing is decided.

No outcome marked.

---

## 2026-08-18 — Entry 48 — O33 was still reading the external lattice_mapper directory; repointed at the vendored copy, re-run, non-semantic
type: instrument-fix
refs: 36, 46

Entry 46 imported the eight base-series difference tables into
`imported/lattice_mapper/32bit/`, byte-for-byte and SHA-256 verified, so
that the evidence would sit with the work that cites it.
`O33_base_ladder_crossing.py` was not repointed. Its `DEFAULT_DATA_DIR`
still named
`/Users/juliansambrano/GitHub/lattice_mapper/difference_tables/32bit`, a
path outside this repo, and `results/base_ladder_crossing.json` →
`params.data_dir` records exactly that string. The vendored copy did not
protect the instrument: had `lattice_mapper/` been moved, renamed or
regenerated, O33 would have failed or silently read something else, with
27 verified files sitting unused two directories away. The import closed
the provenance gap for the *reader*; it did not close it for the *script*.

**Sites changed.** Three, all path, none logic. Line numbers before → after:

```text
  15-19  →  15-28   docstring, "THE SOURCE TABLES" preamble — the source
                    directory paragraph now names imported/lattice_mapper/32bit/,
                    records the byte-for-byte copy and points at the import
                    manifest and entry 46, and states that the run of record
                    predates the repoint
 194-196 →  202-205  docstring EXAMPLE — the explicit
                    --data-dir /Users/.../difference_tables/32bit line dropped,
                    since the default is now correct; a note added that an
                    explicit --data-dir is used verbatim and should be absolute
 220-221 →  230-233  DEFAULT_DATA_DIR, the default constant
```

The new default is

```python
DEFAULT_DATA_DIR = os.path.join(_HERE, "imported", "lattice_mapper", "32bit")
```

anchored to `_HERE = os.path.dirname(os.path.abspath(__file__))`, which
the file already defined at what is now line 227 for `DEFAULT_RESULTS_DIR`.
That is the house pattern, not a new one: `O16_centered_difference_table.py`
lines 169-171 anchor `files (2)` the same way, and `05`, `06`, `07`, `O11`
through `O23`, `O42` and `O43` all anchor their caches and outputs to `_HERE`.
An absolute path was rejected in favour of it so the repo stays portable.
The `--data-dir` flag's help string interpolates `DEFAULT_DATA_DIR`, so it
followed with no separate edit. `grep -n difference_tables
O33_base_ladder_crossing.py` now returns one line, 23, inside the docstring
sentence that records where the vendored files came from.

**Left alone, deliberately.** `constants.source_project` at line 1012 still
reads `/Users/juliansambrano/GitHub/lattice_mapper (READ ONLY; nothing
written there)`. That field records where the data *originated*, not where
this script *reads*, and it remains true — the vendored copy came from
there and the source tree is still untouched. Changing it would have moved
a leaf in the `constants` block, and the whole point of the comparison
below is that `constants` did not move. Same reasoning for the docstring's
scaffold-silencing section (lines 104-109) and
`constants.source_silencing`, which cite
`lattice_mapper/difference_table.py:75` as the generator: that is a
statement about provenance of the convention, and the generator is not
vendored here.

**Script SHA-256, before and after** (`shasum -a 256
O33_base_ladder_crossing.py`, run either side of the edit):

```text
  before  ffa3d5b746fd7c66cc0c6161d6532dd0d76d77ee4f0a882bec3b22eb2bf227ac
  after   55e1593b0bd950679c37684ada7ab614c346ea89c003b6cf40e37f0a1d329a01
```

The before hash is the same string carried in
`results/base_ladder_crossing.json` → `params.code_version`, so run 1
executed the pre-fix bytes and stamped them, and nothing had touched the
file between that run and this edit. 1038 lines before, 1050 after;
`python3 -m py_compile` clean.

**Re-run, to new paths.** Run 1's own invocation, read from
`results/base_ladder_crossing.json` → `params.argv`, which is
`['O33_base_ladder_crossing.py', '--min-row', '8']`, with `--out` and
`--out-csv` redirected so that neither run-1 artifact could be touched.
`--min-row 8` is also the flag's default; every other parameter ran at
default in both runs.

```text
python3 O33_base_ladder_crossing.py --min-row 8 \
    --out    /Users/juliansambrano/GitHub/Primebeat_081426/results/base_ladder_crossing_run2.json \
    --out-csv /Users/juliansambrano/GitHub/Primebeat_081426/results/base_ladder_crossing_run2.csv \
    2>&1 | tee /Users/juliansambrano/GitHub/Primebeat_081426/results/O33_base_ladder_crossing_run2.log
```

`run_start_utc` and `run_end_utc` both 2026-08-19T05:49:55Z, read from
`results/base_ladder_crossing_run2.json` → `params`; the run completes
inside one second. Python 3.14.3, mpmath 1.3.0, the same interpreter
string run 1 recorded. There was no run-1 log — `results/` held only
`base_ladder_crossing.json` and `base_ladder_crossing.csv` for O33 — so
`results/O33_base_ladder_crossing_run2.log` is the first log this
instrument has, named to the house `<script>_run2.log` pattern rather than
back-dated to a run-1 name that never existed.

Artifacts: `results/base_ladder_crossing_run2.json` (215,742 B),
`results/base_ladder_crossing_run2.csv` (14,600 B),
`results/O33_base_ladder_crossing_run2.log` (19,014 B, 236 lines).

**The change is non-semantic, and here is the evidence.** Both payloads
flattened to leaves and compared key by key. Run 1 has 6432 leaves, run 2
has 6436; the four extra are the four extra `params.argv` elements
(`--out`, its path, `--out-csv`, its path — 3 elements against 7). Of the
6429 leaves that are not `params.argv`, **fifteen** differ, every one of
them metadata:

```text
  /generated_utc              2026-08-18T03:25:29Z  ->  2026-08-19T05:49:55Z
  /params/run_start_utc       2026-08-18T03:25:29Z  ->  2026-08-19T05:49:55Z
  /params/run_end_utc         2026-08-18T03:25:29Z  ->  2026-08-19T05:49:55Z
  /params/code_version        ffa3d5b7...           ->  55e1593b...
  /params/data_dir            .../lattice_mapper/difference_tables/32bit
                                                    ->  .../Primebeat_081426/imported/lattice_mapper/32bit
  /params/out                 base_ladder_crossing.json  ->  ..._run2.json
  /params/out_csv             base_ladder_crossing.csv   ->  ..._run2.csv
  /params/source_files[0..7]/path   eight file paths, external -> vendored
```

`data_dir` and the eight `source_files` paths are the fix itself.
`code_version` moving is expected: `_code_version()` hashes `__file__` at
write time, so a changed file changes the stamp even when behaviour does
not.

Nothing else moved. The `constants`, `summary` and `rows` blocks are
**byte-identical** under a sorted-key JSON dump — all 210 rows, all eight
per-base summaries, all eight schema verifications, all eight unsilence
checks. So are `schema_version`, `script` and `script_path`. And the
`results/base_ladder_crossing_run2.csv` is byte-identical to
`results/base_ladder_crossing.csv`, same SHA-256
`f71f74b52cf923aca01e0fff8a4e4a4dfbd795302f4e1c47fba38b937d70ba94` —
the CSV carries no timestamp, so it is the cleanest single statement of
the result: the fix altered nothing this instrument measures.

**The comparison also checks the import, and the import passes.** Within
`params.source_files`, only `path` moved. `sha256`, `bytes`, `mtime_utc`,
`regimes`, `n_columns`, `header_first_4`, `header_last`,
`filename_trailing_number` and
`filename_trailing_number_equals_regimes` are identical across the two
runs at all eight bases. That is the load-bearing check: run 1 hashed the
files it read at
`/Users/juliansambrano/GitHub/lattice_mapper/difference_tables/32bit/` and
run 2 hashed the files it read at `imported/lattice_mapper/32bit/`, and
the hashes agree — the vendored copies *are* what the run of record read,
demonstrated by the instrument itself rather than by the copy that made
them. Those same eight SHA-256s agree a third time with the manifest table
in `imported/lattice_mapper/README.md`, checked line by line for this
entry: 8 of 8, 0 mismatches. `cp -p` preserved the mtimes, so even the
mtime field survives the move.

**Run 1 remains the run of record.** `results/base_ladder_crossing.json`
was not opened for writing, and still reads 215,439 B at mtime
2026-08-17 20:25 with SHA-256
`a0a070622873f424f23cdf1ce33437c0fbc21a1027828ea501b1e820fd5a1927`;
`results/base_ladder_crossing.csv` likewise. Entry 36 stands unamended.
`CONTEXT.md`'s O33 bullet still says the input "lived outside this repo at
run time … (the path `params.data_dir` records)" and that remains exactly
true of the run it describes — the repoint changes what a *future* run
reads, not what the recorded one did, and the bullet was deliberately not
edited. `CONTEXT.md` and `REFERENCES.md` were not touched by this pass.

Still EXPLORATORY. O33 has no prereg and fires no decision rule; run 2
reproduces run 1's numbers and reproduces its failed pre-stated
prediction with them — `summary.qualitative_split_matches_prestated`
reads `false` in both files, `bases_observed_crossing` `[2, 3]` in both.
Nothing here is a verdict.

No outcome marked.

---

## 2026-08-18 — Entry 47 — Is `(2,1)` a cancellation or a seeding artifact? The check splits the four zeros deep-versus-shallow
type: result-triage
refs: 12, 17, 29, 33, 36, 45, 46

The question came out of entry 17. That entry dismisses the triadic
table's `(2,1)` — "The single 0 is A_count at r = 1, which is the
construction … not a cancellation" — while the dyadic `(2,1)` is counted
among the four zeros without the same scrutiny. Entry 29 sharpened it:
under O27's convention the triadic table's one exact zero *is* `(2,1)`,
"and it is trivial: (1,3] holds {2,3} and (3,9] holds {5,7}, both count
2." So the cell nearest the seed is the cell whose reading moves with the
seed. The import recorded in entry 46 makes it testable, because it puts
a **third convention** on disk beside the two already here.

Everything below is read from artifacts named at each number. Nothing is
preregistered; no verdict is claimed and nothing is decided.

**`(2,1)` is convention-mobile — it moves with the seed and never with
the arithmetic.** Three conventions, one cell, `cell(2,1) = A(2) − A(1)`:

```text
  b                        2    3    4    5    6    7    8    9
  plain count              0    0    2    3    5    7   10   14
    = pi(b^2) - 2 pi(b)
  imported (2,3 as         0    2    4    5    7    9   12   16
    lattice, backward)
  archive (only 2          1    1    3    4    6    8   11   15
    dropped, forward)
```

Row 1 is `primecountpy.prime_pi`, computed for this entry. Row 2 is
`delta_1` at `regime 2` read out of the eight base-series tables in
`imported/lattice_mapper/32bit/` — `dyadic_difference_table_32.csv`,
`triadic_difference_table_32.csv`,
`tetradic_difference_table_32.csv`, `pentadic_difference_table_27.csv`,
`hexadic_difference_table_24.csv`, `heptadic_difference_table_22.csv`,
`octadic_difference_table_21.csv`, `enneadic_difference_table_20.csv`.
Row 3 is `delta_1` at `regime 1` read out of the eight archive tables at
`/Users/juliansambrano/GitHub/lattice_mapper/difference_tables/archive_unsilenced/32bit/`,
and it reproduces exactly when recomputed from `prime_pi` under that
convention.

Row 2 minus row 1 is **+2 at every base from 3 to 9 and 0 at base 2**.
The reason is geometric: the two excluded lattice primes are both in
`(b, b²]` for `b ≥ 3`, so they both leave `A(2)`; at `b = 2` they
straddle the boundary — 2 is in `(1,2]` and 3 is in `(2,4]` — so one
leaves `A(1)` and one leaves `A(2)` and the difference is untouched.
That is the whole of the base-2 exception, and it is a statement about
where 2 and 3 sit, not about cancellation.

**No convention makes `(2,1)` vanish at every base**, which is what a
pure seeding artifact would do. Plain count vanishes at `b = 2` and
`b = 3` and nowhere else. The imported convention vanishes at `b = 2`
only. The archive convention vanishes at no base at all. The cell is
mobile, but it is not free.

**Silencing can manufacture it, and the arithmetic of that is exact.**
Each additionally silenced prime landing in `(b, b²]` decrements
`cell(2,1)` by exactly one. Measured, `delta_1 @ regime 2`:

```text
  32bit/triadic_difference_table_32.csv             2
  32bit/triadic_difference_table_32_silence235.csv  1     (5 silenced)
  32bit/triadic_difference_table_32_silence2357.csv 0     (5 and 7)

  32bit/tetradic_difference_table_32.csv            4
  32bit/tetradic_..._silence2357.csv                2     (5, 7)
  32bit/tetradic_..._silence235711.csv              1     (5, 7, 11)
```

`(3,9]` holds `{5,7}`; `(4,16]` holds `{5,7,11,13}` and only three of
those are named. The 64bit triadic pair reproduces it — 2, 1, 0 across
`triadic_difference_table_40.csv`, `_silence235.csv`, `_silence2357.csv`.
So a `(2,1)` zero is available on demand in base 3 by naming two more
primes, and that is the strongest statement against reading the dyadic
`(2,1)` as the same kind of object as the deep two. Note also that
`triadic_difference_table_32_silence235.csv` carries a zero at
`(10,9)` — one exact zero, at depth 9, produced purely by silencing.
That cell is unexamined and is not chased here.

**All four dyadic zeros survive the convention change.**
`imported/lattice_mapper/32bit/dyadic_difference_table_32.csv` holds 496
populated cells over `r ≤ 32, d ≤ 31` and returns exactly

```text
  {(2,1), (4,1), (8,3), (20,6)}    and no other zero
```

`imported/lattice_mapper/64bit/dyadic_difference_table_64.csv` extends
the same construction to `r ≤ 64, d ≤ 63`, **2016 cells**, and returns
the same four and no fifth. The two files agree on all 496 overlapping
cells, 0 mismatches. This is a February generator in another repo, on
the excluded-lattice convention, and it lands on the same set that
entry 12 verified to `r ≤ 62, d ≤ 61` and that O27 rebuilt independently
(entry 29).

The 64bit file's own arithmetic was checked rather than assumed: its
`A_count` column matches backward differences of OEIS A007053 read from
`b007053.txt` at **all 64 regimes**, 0 mismatches, once the two lattice
primes are removed at `r = 1` and `r = 2`. It reaches `A(64) =
209366672181778359`, two regimes past this repo's own `pi2n_cache.json`
ceiling of `n = 62`.

That makes this a second confirmation of the census alongside O43
(`results/extended_zero_census.json`: `rmax_ext 92`, `cells_ext 4186`,
`cells_new 2295`, `K_new 0`, `n_reproduced 4`) — from different code in a
different repo written months earlier, and under a different convention.
It is *not* independent in the arithmetic: π(2ⁿ) is π(2ⁿ), and O43 reads
further, to `r = 92` against this file's 64. What is independent is the
construction and the seed convention, which is exactly the axis under
test here.

**`dyadic_prime_full_silenced_32.csv` is not a third confirmation.** It
is value-identical to `dyadic_difference_table_32.csv` on all **380**
overlapping cells, `A_count` column included, 0 mismatches, and returns
the same four zeros. It is a duplicate under another name, and counting
it would double-count.

**The composite side confirms the pair identity on data this project did
not generate.** Six composite variants, five distinct SHA-256 (two share
one — see entry 46):

```text
  file                                        (2,1) (4,1) (8,3) (20,6)  cells
  dyadic_composite_difference_table_32          1     4     16   8192    496
  dyadic_composite_difference_table_32_s46      0     5     16   8192    496
  dyadic_composite_difference_table_32_s468     0     6     16   8192    496
  dyadic_composite_extended_emptied_32          0     4     16   8192    380
  dyadic_composite_extended_emptied_32_s46      0     6     16   8192    380
  dyadic_composite_full_silenced_32             0     6     16   8192    380
```

`(8,3)` reads **16** and `(20,6)` reads **8192** in every one of the six,
and never moves. Those are `2^(r−1−d)` at `2⁴` and `2¹³` — exactly the
values `lean/PairIdentity.lean` proves the composite arm must carry where
the prime arm vanishes, and exactly the values entry 45 recorded as
`measured_composite_at_zeros = [1, 4, 16, 8192]` checked `by decide`
against `papers/The-Four-Zeros.md` § E2. Entry 45's check ran against
this project's own numbers. This one runs against tables generated in
**February 2026 by other code in another repo**, under a convention that
disagrees with ours at the seed, and the identity still holds at the two
deep cells. `dyadic_diff_full_silenced_32.csv` agrees independently:
`(4,1) = 6`, `(8,3) = 16`, `(20,6) = 8192`, which is forced, since its
prime arm is 0 at all four.

**`(4,1)` moves on the composite side, and the reason is visible in the
seed rows.** The six variants differ **only** in `A_count` at
`r = 1, 2, 3`:

```text
  A_count, r = 1..8
  composite (plain)                 1  2  2  6  11  25  51  105
  composite silence46               1  1  1  6  11  25  51  105
  composite silence468              1  1  0  6  11  25  51  105
  composite extended_emptied        0  0  2  6  11  25  51  105
  composite extended_empt_s46       0  0  0  6  11  25  51  105
  composite full_silenced           0  0  0  6  11  25  51  105
```

From `r = 4` onward every variant is byte-for-byte the same sequence.
`(4,1)` reads rows 3 and 4, so it lands inside the perturbed region and
takes the values 4 / 5 / 6 above. `(8,3)` reads rows 5–8 and `(20,6)`
reads rows 14–20; both windows sit entirely outside it, which is why they
cannot move whatever is silenced at the seed. The dyadic prime `(2,1)`
reads rows 1 and 2 — the two most perturbed rows in the whole file.

**The finding worth recording: the useful cut is not four-versus-three,
it is deep versus shallow.** `(8,3)` and `(20,6)` are unmoved by every
convention, every silencing set and every generator tried here — three
seed conventions, six composite variants, two independent repos, and
O43's census to `r = 92`. `(2,1)` and `(4,1)` both sit close enough to
the seed that low-`r` choices reach them: `(2,1)` reads the two rows the
lattice convention edits, `(4,1)` reads the last row the silencing sets
edit. That is a property of window position, not of arithmetic depth,
and it is measurable — which four-versus-three is not, until someone
fixes a convention.

This echoes `lean/Zeros.lean` from an independent direction. Its
`window_exclusive_of_prime_exponent` proves that depth 6 spans a ratio of
`2^7`, 7 is prime, so `b^k = 2^7` with `b ≥ 2, k ≥ 2` forces
`b = 2, k = 7` — **(20,6) is base-2 exclusive**. Its
`window_shared_of_composite_exponent` is the one line `(4:ℕ)^2 = 2^4`:
depth 3 spans `2^4 = 4^2`, so base 4 reaches `(8,3)`'s window at depth 1,
and the file's own comment says "the two deep zeros are different kinds
of object". That splits the deep pair by *base reachability*. The
composite data above splits all four by *seed reachability*. The two cuts
are not the same cut, and they do not have to agree — but both say the
four zeros are not one homogeneous set, arrived at from proof and from
February data respectively.

**Entry 17's claim, re-examined and verified as written.** Entry 17 says
of `triadic_difference_table_32.csv`: "**Confirmed: no exact zero in any
delta column.** The single 0 is A_count at r = 1", with near-misses
`(3,2) = 1`, `(5,4) = 1`, `(11,10) = 2`, `(8,7) = 9`, `(10,9) = 9`. Every
one of those reads back exactly from the imported copy of that file — 496
cells, **zero** exact zeros in any delta column, `A_count` zero only at
`r = 1`. The claim is true of the file it cites.

It is also **convention-dependent, and that convention is not the one any
in-repo artifact uses.** The same file reads `cell(2,1) = 2`, tying
`(11,10)` for third-smallest and unlisted in entry 17's near-miss table.
Under O27's convention — `pi(1) = 0`, block `r` is `(b^(r−1), b^r]`, 2 and
3 counted as primes, so `N_3(1) = 2` (entry 29) — the same triadic table
reads differently: `results/joint_dyadic_triadic_table.json` over its 820
triadic cells at depth ≥ 1 has minimum `|cell| = 0` at `(2,1)`, next
smallest `2` at `(4,3)`, then `3` at `(3,1)`, `(3,2)`, `(5,4)`, and
**not one cell anywhere in the triangle takes the value ±1**. So "base 3
reaches 1, twice" and "no exact zero" are both true of entry 17's file and
both false of O27's. Entry 17's open discrepancy — that the magnitude
argument does not separate the bases — was argued from the reading where
base 3 gets closest without landing. On the in-repo reading base 3 lands
at `(2,1)` and never gets close anywhere else. The discrepancy is not
resolved here; it is relocated, and which reading it should be argued from
is not this entry's call.

**Disclosed prediction, and where it failed.** Before opening any file,
this assistant predicted `cell(2,1)` would vanish at `b = 2` and `b = 3`
and read 2, 3, 5, 7, 10, 14 at `b = 4…9`. That prediction reproduced the
plain-count computation **exactly** — row 1 of the table above is
identical to it, digit for digit. It also **contradicted every base-series
file on disk except base 2**, because the imported tables run on the
excluded-lattice convention and read 2, 4, 5, 7, 9, 12, 16 where the
prediction said 0, 2, 3, 5, 7, 10, 14. Both halves are recorded because
the failure is the informative one: a correct computation of the wrong
convention is exactly the error the import in entry 46 exists to prevent,
and it was made anyway, by the same pass that made the import.

Nothing here decides whether the count is four zeros or three. No outcome
marked.

---

## 2026-08-18 — Entry 46 — The lattice_mapper difference tables imported: 27 files, one convention, and the two generations left behind
type: provenance
refs: 17, 36

Entry 17's central piece of adversarial evidence was a file this repo did
not contain. That entry reads: "Julian supplied `triadic_difference_table_32.csv`
(r = 1…32, d = 1…31, built with 2 and 3 excluded as lattice rather than
counted as primes)", and everything it concludes about base 3 — "no exact
zero in any delta column", "Base 3 reaches **1**, twice" — is a reading of
that file. The file lived at
`/Users/juliansambrano/GitHub/lattice_mapper/difference_tables/32bit/`,
outside this repo, with **no pointer to it in `CONTEXT.md` or
`REFERENCES.md`**. Entry 36 later read the same source directory for O33
and recorded the convention and a stale README there, and that pointer was
never promoted into the commitment files either. This import closes that
gap: the evidence now sits with the work that cites it.

**What was imported.** `imported/lattice_mapper/`, copied 2026-08-18
byte-for-byte with `cp -p`, every file SHA-256 verified source-vs-
destination at copy time. **27 files**: 22 from `32bit/` — the complete
directory, 12 base-series tables for bases 2 through 9 plus 10 dyadic
prime/composite split files — 4 from `64bit/`, and the source README
under the name `source_README.md`. The `32bit/` and `64bit/` split is
preserved. `imported/lattice_mapper/README.md` is the import manifest,
written for this repo, and carries the full SHA-256 and source-mtime table.

Re-verified for this entry, not taken on the manifest's word: all 26 CSVs
plus `source_README.md` hash identically to their source counterparts
today, **0 mismatches**. Source mtimes are all 2026-02-11 except the
README's 2026-02-09, and `cp -p` preserved them.

**The convention these tables use.** Power-regime, **backward**
differences: `A(n) = π(bⁿ) − π(bⁿ⁻¹)`, with `delta_d` at regime `r` the
`d`-th backward difference ending at `r`. And — the part that matters —
**the primes 2 and 3 are excluded as lattice, not counted as primes.**
`A(1) = π(b) − 2` for `b ≥ 3`; at `b = 2` the two lattice primes straddle
the regime boundary, 2 in `(1,2]` and 3 in `(2,4]`, so one is dropped from
each of `A(1)` and `A(2)`. The generator is
`/Users/juliansambrano/GitHub/lattice_mapper/difference_table.py:75`,
`silenced_primepi(x)`, whose docstring reads "pi(x) with 2 and 3
silenced. … 2 and 3 are not primes in this framework — they are the
scaffold that generates the 6k±1 lattice." Entry 36 recorded this line
already, from the same source directory.

**This is not the convention any in-repo artifact uses.** O27's
first-block convention is `pi(1) = 0`, block `r` is `(b^(r−1), b^r]`, with
2 and 3 counted — `N_2(1) = 1`, `N_3(1) = 2` (entry 29). The dyadic
tables O16 and O43 build carry the same. So a number lifted from
`imported/` and a number lifted from `results/` are not comparable at low
`r` without stating which convention is in force. That is the reason the
import lives in its own directory with its own manifest rather than being
merged anywhere.

**Three generations, three conventions, two difference directions.** The
source directory holds more than was taken. `archive_unsilenced/` was
**deliberately excluded**, and it differs on every axis:

```text
  imported here     backward differences, 2 and 3 excluded as lattice
                    (difference_table.py:75)
  archive, power    FORWARD differences, ONLY 2 dropped
    regime          (archive_unsilenced/gen_difference_table.py:22-29 —
                    silenced_primepi subtracts 1)
  archive,          a THIRD schema: header column `pi_n`, integer regime
    *_64bit_*.csv   (triadic_difference_table_64bit_64.csv et al.)
```

The direction was checked from the data, not from docstrings — entry 36
warns that the generator's docstring and its output disagree. In the
archive dyadic table `A = 0, 1, 2, 2` and `delta_1 @ r3 = 0 = A(4) − A(3)`,
which is forward. In the imported dyadic table `A = 0, 0, 2, 2` and
`delta_1 @ r3 = 2 = A(3) − A(2)`, which is backward.

Mixing those in one imported directory is the confusion this import
exists to end. The archive remains readable in place and is not deleted,
moved or touched:

```text
  /Users/juliansambrano/GitHub/lattice_mapper/difference_tables/archive_unsilenced/
```

Its size, measured for this entry: **33 files, 59,069,876 bytes**, of
which 9 `.bin`/`.hex` binaries account for 25,339,552 bytes. The
manifest's "~58 MB of binaries" describes the directory total (56.3 MiB),
not the binary files alone; recorded, not corrected.

**`source_README.md` is stale on `64bit/`, and is flagged rather than
fixed.** It describes `64bit/` as an "Integer-regime table: pi(n) for
n = 1..64" — but both imported `64bit/` files are power-regime `A_count`
tables on the same convention as `32bit/`, verified identical to `32bit/`
on all 496 overlapping cells. The description fits the
`archive_unsilenced/*_64bit_*` files instead. The staleness runs further
than the manifest notes: the README's folder list names `128bit/`,
`1000/` and `2pow20/`, and those directories exist only *inside*
`archive_unsilenced/`, not at `difference_tables/` top level; and it
states the convention as "regime 2 is silent (pi(2) = 0). The prime 2 is
not counted" — the one-prime convention, which is the archive's, not the
imported files'. It was imported verbatim as the record of what the
source directory said about itself, and every claim in it that this pass
checked is noted here rather than edited.

Note the two same-named generators: `difference_table.py:75` defines
`silenced_primepi` removing **two** primes, and
`archive_unsilenced/gen_difference_table.py:22-29` defines
`silenced_primepi` removing **one**. Same function name, different
convention, different file. That is how the README came to describe the
wrong one.

**One byte-identical pair, preserved under both names.**
`32bit/dyadic_composite_extended_emptied_32_silence46.csv` and
`32bit/dyadic_composite_full_silenced_32.csv` share SHA-256
`a0030692739c7ddaada77f7b2cb81e8364ab3f9753970e1e8f6e63d058d53b6a` — they
are byte-identical in the source, under two names and two source mtimes
(12:13:27 and 12:20:04). Both were imported as-is rather than
deduplicated, because the pair is itself the provenance fact. Anyone
counting "six composite variants" is counting five distinct files.

**`lattice_mapper/` was verified unmodified.** No file anywhere under
`/Users/juliansambrano/GitHub/lattice_mapper/` carries an mtime later
than 2026-08-01; the newest under `difference_tables/` is 2026-02-11.
Every imported file's source counterpart hashes identically today. The
source tree was read-only throughout and remains so. Nothing in this repo
regenerates these files, and nothing should: they are imported evidence,
not outputs of this bench.

`CONTEXT.md` and `REFERENCES.md` still have no pointer to
`imported/lattice_mapper/`. The candidate lines are reported to Julian
separately; neither file was edited.

No outcome marked.

---

## 2026-08-18 — Entry 45 — the pair identity proved in Lean, and the row hypothesis that had to be window-local
type: formalization
refs: 12, 17, 26, 33

`papers/Formalization.md` § D5 reads, in full: "Blocks D through I of the
chain remain unencoded — the winding, the pair identity, the transform
results." The pair identity is now encoded and proved.
`lean/PairIdentity.lean` (15610 B, sha256
`0383a9e23ac642cf2a5135ad484cb43af7ff12180c7d7c070e90234c5552877f`,
12 theorems and 2 defs) carries statement **I1** of
`papers/Euler-Factor-Chain.md` § I outright, with no numerical input.
The winding and the transform results were not touched and D5 still
stands for them.

One wording note, recorded rather than fixed: the pair identity is the
**second** of the three items D5 names, not the first. Nothing in
`papers/` was edited in this pass.

**What the notebook already had, and at what strength.** Entry 33 wrote
the identity down — `prime(r,d) + composite(r,d) = (b-1)^(d+1) *
b^(r-1-d)` — and read the four exact zeros as its poles, with the
composite values 1, 4, 16, 8192 the identity forces. Entry 17 recorded
the geometric fact underneath it, that differencing a geometrically
growing sequence "rescales by (b−1)^d and returns nothing", and entry 26
filed the composite identity as rediscovery from Julian's own repos
(OBS-011, February). None of that was a derivation; it was a check.
Read again for this entry,
`results/O16_centered_difference_table_run2.json` →
`summary.identity_a_backward` carries `statement`
`composite_B(r,d) == 2^(r-d-1) - prime_B(r,d)`, `cells_checked` **1953**,
`mismatches` **0**, `passed` true — the same 1953 cells entries 17, 26
and 33 all cite back to entry 12.

**The theorem, verbatim from `lean/PairIdentity.lean:138`.**

```text
theorem pair_identity (b : ℤ) (P C : ℤ → ℤ) (r : ℤ) (d e : ℕ)
    (hr : r = (d : ℤ) + 1 + e)
    (hpair : ∀ k : ℕ, k ≤ d → P (r - k) + C (r - k) = (b - 1) * b ^ (e + (d - k))) :
    tableFrom P r d + tableFrom C r d = (b - 1) ^ (d + 1) * b ^ e
```

**The hypotheses it actually needed — two, and neither is about primes.**
`hr` pins the exponent. `hpair` says the two rows partition each rung of
the window the cell reads. There is **no hypothesis on `b` at all** — not
`2 ≤ b`, not `b ≠ 0` — so this is general integer `b`, not base 2
special-cased. And there is no hypothesis on `P` or `C` beyond the
partition: the seed rows are arbitrary functions `ℤ → ℤ`, and the proof
never knows that `P` counts primes. The file states the consequence in
its own words at line 133: "Nothing in the proof knows that `P` counts
primes — the identity is forced by the partition alone, and the whole
content of the prime/composite split is that it is a partition of a
geometric row." That is the sharpest form of what entry 33 called the
sum being fixed and known in advance while only the split is free.

**The index convention it settled on** (file lines 43–48).
`Construction.tableFrom` puts depth `d` at `d` backward differences of
the depth-0 row, and the depth-0 row is the per-rung count, itself
already one difference of the cumulative count. So `d` in Lean is the
paper's `d`, and the exponent `r−1−d` is carried as a **natural number
`e` with `r = d + 1 + e`**. That keeps every exponent in ℕ and every
rung inside the table's support, which is why `hr` appears as a
hypothesis rather than the exponent being written `r - 1 - d` and
truncating.

**The supporting arrows.** `symbol_at_one` names
`EulerFactorChain.symbol_of_backward_difference` (A1) at `ρ = 1`;
`backward_difference_pow` moves that step into ℤ where the table lives;
`tableFrom_of_geometric` iterates it to the collapse
`tableFrom G r d = (b - 1) ^ d * G (r - d)`; `tableFrom_add_window`
supplies linearity localised to the window, out of
`Construction.tableFrom_add` and `Construction.zero_determined_by_row`.
`composite_of_prime_zero` is I5, the pole: where the prime arm vanishes
the composite arm carries the whole total. `composite_at_zero_20_6`
instantiates it at (20,6) and returns 8192.

**THE FINDING WORTH RECORDING — a globally-stated row hypothesis would
have been vacuous.** The natural way to write "the row is geometric" is
`∀ r, G r = b * G (r-1)` over all of ℤ. For `|b| ≥ 2` that hypothesis
has exactly one solution, `G = 0`: iterating gives `G r = b^n * G (r-n)`
for every `n`, so `b^n` divides `G r` for every `n`, and only 0 is
divisible by arbitrarily high powers of `b`. A theorem assuming it would
be true and empty. The hypothesis had to be **window-local** — in
`tableFrom_of_geometric` it is `∀ k : ℕ, k < d → G (r - k) = b * G (r - k - 1)`,
asking only for the `d` steps inside the window `r, r−1, …, r−d` that
the cell at `(r,d)` actually reads. That is the same locality
`Construction.zero_determined_by_row` already carries (`∀ k : ℕ, k ≤ d →
N (r - k) = M (r - k)`), so the pattern was in the tree before this file
needed it.

**A discrepancy in the file's own comment on that point, not adjusted.**
`lean/PairIdentity.lean:80–82` states the vacuousness as "No total
function `ℤ → ℤ` satisfies `G r = b * G (r−1)` at every `r` except
`G = 0`", with no condition on `b`. As written that is false: at `b = 1`
every constant function satisfies it, and at `b = −1` every
sign-alternating function does. The claim needs `|b| ≥ 2`. The comment
is prose in a docstring, carries no proof obligation and does not enter
any theorem — nothing in the file is wrong — but the sentence is
overstated and is recorded here rather than edited, since `lean/` was
out of scope for this pass.

**The corollary, and its exact reach.**

```text
coeff_eq_one_iff_base_two {b : ℤ} (hb : 2 ≤ b) (d : ℕ) :
    (b - 1) ^ (d + 1) = 1 ↔ b = 2

total_eq_pow_iff_base_two {b : ℤ} (hb : 2 ≤ b) (d e : ℕ) :
    (b - 1) ^ (d + 1) * b ^ e = b ^ e ↔ b = 2
```

Here the hypothesis `2 ≤ b` does appear — the corollary needs it, the
identity does not. `base_three_carries_factor` and
`base_four_carries_factor` are the witnesses: base 3 carries
`2^(d+1)·3^e`, base 4 carries `3^(d+1)·4^e`, never a bare power.

What it **does** say: base two is the only integer base ≥ 2 whose cell
total is a bare power of the base, so it is the only grid on which a
vanished prime arm leaves the composite arm sitting exactly on a power
of the grid. What it **does not** say, in the file's own words at lines
35–38: "It is a statement about the FORM OF THE TOTAL, not about zeros.
Nothing here predicts, or could predict, where either arm vanishes." So
it does **not** close entry 17's open discrepancy. Entry 17 offered
`(b−1)/b` minimised at `b = 2` as the reason the zeros are there, then
recorded that the triadic table reaches 1 twice without ever hitting 0,
so the magnitude argument does not separate the bases. This corollary is
a different statement about a different quantity, and entry 17's
discrepancy stands exactly where it stood.

**The measured check, and it matched.** The file records the four zero
cells as `zero_cells = [(2,1), (4,1), (8,3), (20,6)]` — the same list as
`Zeros.measured_zeros` and `Construction.measured_zeros` — and the
composite arm at them as `measured_composite_at_zeros = [1, 4, 16, 8192]`,
read from `papers/The-Four-Zeros.md` § E2 ("At the four zeros the
composite arm therefore carries the whole term: `1, 4, 16, 8192`",
line 121–122). `measured_composite_matches_pair_identity` evaluates
`(b−1)^(d+1)·b^(r−1−d)` at `b = 2` and those four cells and proves the
result equals the measured list, `by decide`. It compiles, so they agree:

```text
  (2,1)   2^0  =     1   matched
  (4,1)   2^2  =     4   matched
  (8,3)   2^4  =    16   matched
  (20,6)  2^13 =  8192   matched
```

These are the same four numbers entry 33 tabulated. They are inputs to a
check, not to a proof — the formula is derived from the partition alone
above them — and had any of the four disagreed the file would not build.

**`#print axioms`, verified rather than quoted.** The file pins each
result with a `#guard_msgs` block, so a drift would fail `lake build`.
Independently re-run for this entry via `lake env lean` on a scratch
file importing `PairIdentity`; the twelve lines below are that output
verbatim, and they match the twelve docstrings in the file exactly.

```text
  symbol_at_one                          [propext, Classical.choice, Quot.sound]
  backward_difference_pow                [propext, Quot.sound]
  tableFrom_of_geometric                 [propext, Quot.sound]
  tableFrom_add_window                   [propext, Quot.sound]
  pair_identity                          [propext, Quot.sound]
  composite_of_prime_zero                [propext, Quot.sound]
  coeff_eq_one_iff_base_two              [propext, Classical.choice, Quot.sound]
  total_eq_pow_iff_base_two              [propext, Classical.choice, Quot.sound]
  base_three_carries_factor              [propext]
  base_four_carries_factor               [propext]
  measured_composite_matches_pair_identity  [propext]
  composite_at_zero_20_6                 [propext, Quot.sound]
```

**Nine of the twelve are `Classical.choice`-free**, including
`pair_identity` and `composite_of_prime_zero` — the identity and the
pole are constructive. The three that are not are `symbol_at_one`, which
inherits it from the ℂ-valued A1 statement it names, and the two
`iff_base_two` corollaries, which get it through the `omega` / `nlinarith`
route. Three results depend on `propext` alone.

**Build.** `lean/lakefile.toml` changed by one line: `PairIdentity`
appended to the `[[lean_lib]]` `globs` list, taking the library from nine
modules to ten. New sha256
`b144eb9926b3a3e12f976c5f9eaee15cf63a01abe46725ac39db25e1e1508d36`,
462 B. Job count either side:

```text
  before   8027 jobs   lean/build.log line 71, the 09:41 build of the
                       nine-module library
  after    8036 jobs   lake build, run for this entry, exit clean
  delta      +9
```

`Build completed successfully (8036 jobs).` The only warnings are the
pre-existing unused-variable and unused-simp-argument linter notes in
`Crossover.lean` and `EulerFactorChain.lean`; `PairIdentity.lean` emits
none.

**What this confirms, and what it leaves alone.** It confirms the
account in entries 12, 17, 26 and 33: the identity is exact, it is not
about primes, and the four composite values are forced by the grid. It
refutes nothing in the notebook. It does not locate a zero — the file
says so twice, at lines 274–278 — so entry 26's last-vanishing question
and entry 17's base-2 discrepancy are both untouched, and `Zeros.lean`'s
hole stays open.

No outcome marked.

---
