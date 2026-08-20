# The Fold

The deep zeros written as a balance rather than as a vanishing. The stencil is
antisymmetric about the midpoint of its own window, so a cell is a sum over pairs
straddling that point, and a zero is the statement that two weighted halves of π weigh
the same. What that reframing reaches, and where it stops.

Source lines cite scripts and results in `~/GitHub/Primebeat_081426/`. Nothing here is
preregistered.

---

## A · The stencil folds

**A1.** `cell(20,6)` is `Δ⁷π` at `2²⁰`, eight values of π spanning `2¹³` to `2²⁰`,
with weights `(−1)^k C(7,k)` = `+1, −7, +21, −35, +35, −21, +7, −1`.
`The-Four-Zeros.md § B3, B4`

**A2.** Those weights are **antisymmetric** about the window's midpoint: `w[7−k] =
−w[k]`, checked termwise. The midpoint is `log₂ x = 16.5`, between samples.
`t23_fold.py · The-Four-Zeros.md § B6`

**A3.** Therefore the cell is a sum over four pairs straddling the midpoint, with no
leftover term:

```text
   j  weight  hi=2^  lo=2^   pi(hi)-pi(lo)          term
   0       1     20     13           80997         80997
   1      -7     19     14           41490       -290430
   2      21     18     15           19488        409248
   3     -35     17     16            5709       -199815
                                       sum             0
```

`t23_fold.py`

**A4.** The pairing is an **identity, not a test**. For odd stencil order every cell
equals its folded sum whether or not it vanishes — `(21,6)` folds to 1713, which is
`(21,6)`.
`t23_fold.py`

**A5.** What the fold supplies is the content of the vanishing: at a zero, the four
weighted differences of π across the midpoint cancel. § B6 states this as "π is
symmetric to seventh order about `2^16.5`"; A3 is the same fact with the pairs written
out and computable.
`A3 + The-Four-Zeros.md § B6`

---

## B · Two wings

**B1.** Split the stencil by sign. Each arm carries total weight 64, and the arms
occupy **alternating** positions along the axis:

```text
wing +   2^20 x1    2^18 x21   2^16 x35   2^14 x7     weights sum 64
wing -   2^19 x7    2^17 x35   2^15 x21   2^13 x1     weights sum 64
```

`t23_fold.py · The-Four-Zeros.md § B4`

**B2.** The two weight lists are each other reversed: `1, 21, 35, 7` against `7, 35,
21, 1`, read outward from the midpoint in opposite directions.
`B1`

**B3.** At `(20,6)` the two wings weigh **807295 each**, on eight values of π sharing
no term. The zero is their equality.
`t23_fold.py`

**B4.** Control: at `(21,6)` the same split gives 1520170 against 1518457, differing by
exactly 1713, which is the cell. The wings always exist; the zero is where they
balance.
`t23_fold.py`

**B5.** The wing form reaches `(8,3)` as well, where the pair form does not. Weights
`1, −4, 6, −4, 1`, arms summing 8 and 8, totals **168 and 168**.
`t23_fold.py`

**B6.** The difference is parity. Odd `d+1` gives antisymmetric weights and a clean
pairing; even `d+1` gives symmetric weights and an unpaired middle term, which the wing
split simply assigns to one arm. `(20,6)` is the only one of the four zeros at even
depth, so it is the only one that folds into pairs — but both deep zeros fold into
wings.
`A2 + B5`

**B7.** `wing+ − wing− = cell` identically, so "the wings balance" and "the cell
vanishes" are one statement. The wings are a decomposition, not an independent test,
and cannot be used as evidence for anything the cell value does not already say.
`B1`

---

## C · What the two deep zeros have in common

**C1.** Both are **exact cell repeats**. `(20,6) = 0` because `d5` at `r = 19` and
`r = 20` are both 623; `(8,3) = 0` because `d2` at `r = 7` and `r = 8` are both 4.
`Zeros.zero_iff_repeat · The-Four-Zeros.md § B2 · t23_fold.py`

**C2.** A zero at `(r,d)` forces `cell(r,d+1) = −cell(r−1,d)`, and those two cells share
the diagonal `r − d − 1`. So every zero places a `±v` pair as neighbours on the
diagonal one in.
`Construction.tableFrom · t23_fold.py`

**C3.** At `(20,6)` that pair is `+343` at `(19,6)` and `−343` at `(20,7)`, both on
diagonal 13, total `2¹² = 4096`. At `(8,3)` it is `+5` and `−5`, both on diagonal 4.
`C2 · t23_fold.py`

**C4.** `343 = 7³`. Perfect powers are rare in the table — 21 of 492 nonzero cells at
`d ≥ 1`, 4.27% — and the 9×7 box around `(20,6)` holds three of them: 256, 343, 400.
`t23_fold.py`

**C5.** The seven is **not** enriched near the zero. 12 of 62 cells in that box divide
by 7, 19.4% against a chance 14.3%, which on 62 cells is nothing. And `623 = 7·89`
occurring twice is one number counted twice, since the repeat is what makes the zero.
`t23_fold.py`

**C6.** So the sevens reduce to two facts, not four: `343 = 7³` beside the zero, and
`d+1 = 7` being the stencil order — which `Zeros.window_exclusive_of_prime_exponent`
already proves matters, since 7 prime forces `b^k = 2^7` to have `b = 2, k = 7`.
`C4 + C5 + Zeros.lean`

**C7.** The composite arm does not mirror the prime arm across the `±343` pair. On
diagonal 13 the prime arm reads `+343, −343` while the composite reads `3753, 4439` —
`4096 ∓ 343`, forced by the pair identity. Same total, asymmetric split.
`PairIdentity.pair_identity · t23_fold.py`

**C8.** Further out, the composite arm goes **negative** — on diagonal 13, `(23,10)`
reads `−8656` composite against `+12752` prime; on diagonal 14, `(25,11)` reads
`−22493` against `+30685`. The arms cross on both. Not recorded anywhere before this.
`t23_fold.py`

---

## D · A rule that partitions the four zeros

**D1.** `d+1` divides the repeated value at three of the four zeros:

```text
zero    d+1   r-d   repeat   (d+1)|repeat   left    (d+1)|left
(2,1)    2     1       1        False        -         -
(4,1)    2     3       2        True         1       False
(8,3)    4     5       4        True         5       False
(20,6)   7    14     623        True       343        True
```

`t23_fold.py`

**D2.** The one failure is `(2,1)`, which is the one cell `SeedPerturbation` does not
protect — `r − d = 1`, reachable by any convention change, reading 0 in one convention
and 1 in another.
`D1 · SeedPerturbation.lean · lab_notebook entries 46, 47`

**D3.** `(20,6)` is the only zero where `d+1` also divides the left neighbour, `7 |
343`, which is why it looks richer than the others.
`D1`

**D4.** No mechanism. Three cases, one of which is `2 | 2` and could be anything. It is
recorded because it partitions the four along the same line the seed-perturbation
theorem already draws, not because it is explained.
`D1 + D2`

---

## E · What the fold does not reach

**E1.** The 45° directions in `(r,d)` do not fold. Summing `v(+k) + v(−k)` along
`r − d = 14` through the zero gives 2336, −2353, 8409, −14592, 31425; along `r + d = 26`
it gives 2423, 7811, 28060, 118610, 472224. Neither closes.
`t23_fold.py`

**E2.** Base 3's closest approach is `(11,10)`, and it is **not** a cell repeat — fed by
11 and 7 plain, 11 and 9 under the lattice convention. The deep dyadic zeros cancel
between cells; base 3's best effort does not.
`t23_fold.py · results/cross_base_zero_scan.json`

**E3.** That cell is also not convention-independent. `(11,10)` has `r − d = 1`, and
excluding 2 and 3 as lattice gives `R_e = 1`, so it sits exactly on the protection
boundary. `SeedPerturbation.tableFrom_at_boundary` predicts a shift of `(−1)^d · e(R) =
(−1)¹⁰ · 2 = 2`; the observed shift between conventions is 2.
`E2 · SeedPerturbation.lean`

**E4.** So base 3's near-miss sits at the least protected coordinate in its table, while
`(20,6)` at `r − d = 14` cannot be reached by any convention. They are not comparable
objects.
`E2 + E3`

**E5.** Base 3's `(11,10)` window is `(1, 177147]` holding **16097** primes and spanning
17.43 in log₂. Base 2's `(20,6)` window is `(8192, 1048576]` holding **80997** primes
and spanning 7.00. The coarser base's cell here is wider and holds fewer primes, not the
reverse.
`t23_fold.py`

---

## F · Not established

**F1.** Why `343 = 7³`. C4 says perfect powers are rare and one sits beside the zero;
nothing derives it. The `±343` pair's existence is forced by C2, its **value** is not.
`C2 + C4`

**F2.** `(d+1) | repeat`. Three cases and no mechanism.
`D4`

**F3.** Whether the composite-arm sign crossing of C8 is a feature of the diagonal or an
artifact of where the ladder ends. The crossing depth has not been located on any other
diagonal.
`C8`

**F4.** Whether any cross-base coupling exists at all. E2 through E5 rule out base 3's
`(11,10)` as the place to look for one; they say nothing about whether one exists
elsewhere.
`E4`

**F5.** No prereg. All of the above is exploratory, and B7 in particular records a
decomposition that was briefly and wrongly offered as a test.
`CLAUDE.md § Prereg discipline`
