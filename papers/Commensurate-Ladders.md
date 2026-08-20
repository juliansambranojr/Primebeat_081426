# Commensurate Ladders

Whether `log b₁ / log b₂` is rational has decided at least five results on this bench.
Each time it appeared under a different name — a mechanism, a kill, an obstruction, a
censoring note — and it has never been written down as one fact. This collects it.

Nothing here is new arithmetic. It is one line of number theory applied five times, and
the point is that it was applied five times without being named.

Source lines cite scripts and results in `~/GitHub/Primebeat_081426/`. Nothing here is
preregistered.

---

## A · The quantity

**A1.** A base-`b` ladder samples `log x` at steps of `log b`. Its rungs sit at
`{n·log b : n ∈ ℤ}`.
`definition of the table`

**A2.** Two ladders share a rung above `x = 1` **iff** `log b₁ / log b₂` is rational. If
it is `p/q` in lowest terms, every `q`-th rung of `b₁` coincides with every `p`-th rung
of `b₂`. If it is irrational, the only common point is the origin.
`A1`

**A3.** So the question "do two bases meet" has one answer, and every appearance below is
that answer wearing different clothes.
`A2`

---

## B · Where it is the mechanism

**B1.** A single ladder at base `b` cannot resolve any zero above `π / log b`, and
returns instead a **comb** of aliased peaks at spacing `2π / log b`, all of equal height.
`Euler-Factor-Chain.md § H1, H3`

**B2.** Measured. Base 2 alone returns five peaks — 8.898, 17.965, 27.358, 36.425,
45.156 — every one at variance explained **0.486**. The stated spacing is
`2π/ln 2 = 9.0647`; the observed gaps are 9.067, 9.393, 9.067, 8.731, so the comb is
exact in the statement and approximate in the data.
`t6_multirate.py · results/t6_multirate.txt`

**B3.** Pooling base 2 with base 3 breaks the tie, and the reason is A2: `ln 3 / ln 2` is
irrational, so the two combs share no tooth but the first. Incommensurability is the
working part of the instrument, not an inconvenience.
`t6_multirate.py · The-Four-Prime-Peak.md § A3, citing Furstenberg ×2 ×3`

**B4.** The construction did what it was built to do and still returned negative on the
target — the pooled peaks land at 36.408, 18.267, 27.056, 22.727, 45.442, none within
1.18 of a zeta zero.
`results/t6_multirate.txt · CHAIN.md § 12`

---

## C · Where it is the kill

**C1.** Among integer bases 2…9, exactly six ordered pairs are commensurate, and they are
precisely the power chains:

```text
        2       3       4       5       6       7       8       9
2       -       .     1/2       .       .       .     1/3       .
3       .       -       .       .       .       .       .     1/2
4       2       .       -       .       .       .     2/3       .
5       .       .       .       -       .       .       .       .
6       .       .       .       .       -       .       .       .
7       .       .       .       .       .       -       .       .
8       3       .     3/2       .       .       .       -       .
9       .       2       .       .       .       .       .       -
```

`t24_commensurability.py`

**C2.** So base 4 and base 8 inherit from base 2, base 9 from base 3, and **bases 5, 6, 7
inherit from nothing at all** — `log 5 / log 2 = 2.321928095`, `log 6 / log 2 =
2.584962501`, `log 7 / log 2 = 2.807354922`, none rational.
`C1 · t24_commensurability.py`

**C3.** That is what killed the settling-pond account. If smoothness were inherited from
a parent base, the orphans should carry visibly more oscillation. They do not — every
base starts at the same oscillatory fraction, 0.52 to 0.53, orphans and chain members
alike, and the spread inside each group exceeds the gap between them.
`CHAIN.md § 10 · t12_chain_vs_orphan.py · results/t12_chain_vs_orphan.txt`

**C4.** The kill and the mechanism of § B are the same fact. Irrational log-ratio means
two ladders never meet, which is why pooling separates their combs (B3) and why nothing
can be handed down between them (C3).
`B3 + C3`

---

## D · Where it is the obstruction

**D1.** The sub-integer scan's family arm is `exp(π·k/(2γ₁))` and its antiphase arm is
`exp(π(2k+1)/(4γ₁))`. Both are `exp(π·m/(4γ₁))` for integer `m`, so all eight are
integer multiples of one unit in log:

```text
                base        ln b    /unit  exact
    exp(pi*1/(2*g1))    0.111130   2.0000    YES
    exp(pi*3/(4*g1))    0.166695   3.0000    YES
    exp(pi*2/(2*g1))    0.222261   4.0000    YES
    exp(pi*5/(4*g1))    0.277826   5.0000    YES
    exp(pi*3/(2*g1))    0.333391   6.0000    YES
    exp(pi*7/(4*g1))    0.388956   7.0000    YES
    exp(pi*4/(2*g1))    0.444521   8.0000    YES
    exp(pi*9/(4*g1))    0.500086   9.0000    YES

    unit = pi/(4*gamma_1) = 0.055565153
```

`t24_commensurability.py · t22_zero_surface.py`

**D2.** Those eight carry **107 of the 125 zeros**. The remaining three — 2, `2^(1/2)`,
`2^(1/3)` — are `ln` of `1, 1/2, 1/3` times `ln 2`, mutually commensurate in their own
right. **There is no incommensurate pair anywhere in the scan.**
`D1 · t22_zero_surface.py`

**D3.** Therefore cross-base window alignment is forced, and the zero-surface test
measures the prereg's base choice rather than the zeros.
`The-Zero-Surface.md § D7`

**D4.** The commensurability was a side effect. The family was selected so that
`γ₁ log b` lands at a stated winding angle — `Euler-Factor-Chain.md § D4` — and nothing
in the prereg required, recorded, or noticed that the resulting set shares a lattice.
`D1 · preregs/sub_integer_base_scan_v1_20260818.md`

---

## E · Where it is the censoring note

**E1.** A base-2 cell at depth `d` spans a window of ratio `2^(d+1)`. Another base `b`
reaches that window at depth `log(2^(d+1)) / log b − 1`, which is an integer only when
the ratio is right.
`The-Four-Zeros.md § C1, C5`

**E2.** For `(20,6)`, window ratio `2⁷ = 128`:

```text
   base 3: depth   3.417   base 6: depth   1.708
   base 4: depth   2.500   base 7: depth   1.493
   base 5: depth   2.015   base 9: depth   1.208
```

Not one is an integer.
`t24_commensurability.py`

**E3.** For `(8,3)`, window ratio `2⁴ = 16`, **base 4 reaches it at depth exactly 1**,
because `log 2 / log 4 = 1/2`.
`t24_commensurability.py`

**E4.** So the difference between the two deep zeros is a commensurability fact.
`(8,3)`'s window is shared with base 4; `(20,6)`'s is shared with nothing, because 7 is
prime and `2⁷` is not a power of any smaller integer.
`E2 + E3 · The-Four-Zeros.md § C4`

---

## F · Where it is already a theorem

**F1.** `Zeros.window_exclusive_of_prime_exponent (b k : ℕ) (hb : 2 ≤ b) (hk : 2 ≤ k)
(h : b^k = 2^7) : b = 2 ∧ k = 7`. Proved, axiom list `[propext, Classical.choice,
Quot.sound]`.
`lean/Zeros.lean`

**F2.** That is the commensurability question for **one window**, settled — and it turns
on 7 being *prime*, which is the integer-exponent form of A2 rather than the
irrational-ratio form.
`F1 + A2`

**F3.** The general statement — which pairs of ladders share rungs, and where — is **not
in the tree**. Nothing in `lean/` mentions `log b₁ / log b₂`, and the eleven modules
carry no statement about two bases at once.
`lean/ · F1`

---

## G · What this buys

**G1.** Five results become one. B3, C3, D3, E4 and F2 are the same arithmetic fact
applied at five sites, and three of the five were discovered independently, months
apart, without anyone noticing the repetition.
`B + C + D + E + F`

**G2.** It supplies a design rule the bench did not have: **a base set must be chosen for
its commensurability class, not only for its winding angle.** D4 records the one time
that was missed and what it cost.
`D4`

**G3.** And it names the sign convention. Incommensurability is wanted when the question
is *frequency* — it separates combs. Commensurability is wanted when the question is
*position* — without shared rungs there is nothing for two ladders to cancel against.
The zero-surface scan wanted the first and had the second.
`B3 + The-Zero-Surface.md § E5`

---

## H · Not established

**H1.** Whether any cross-base cancellation exists. G3 says a commensurate set is where
one *could* live; it does not say one does. The 107 zeros on a shared lattice have never
been examined for it.
`G3`

**H2.** Whether the power chains 2→4→8 and 3→9 do anything beyond block-summing.
`Euler-Factor-Chain.md § H` records the sampling consequence; nothing tests whether
commensurate bases behave differently from orphans in any respect other than C3's
oscillatory fraction, which found no difference.
`C3`

**H3.** F3's gap. The general ladder-intersection statement is elementary and unencoded,
and it is the one piece of arithmetic here that every result above leans on.
`F3`

**H4.** No prereg. Everything above is a re-reading of measurements already taken, and A2
is standard number theory, not a finding.
`CLAUDE.md § Prereg discipline`
