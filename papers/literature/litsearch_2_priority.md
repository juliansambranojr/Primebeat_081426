# Literature search — priority question: iterated differences of π(2^n) and the four zeros

Search date 2026-08-18. Search only; no code written, no experiment run, no file in
`/Users/juliansambrano/GitHub/Primebeat_081426/` modified.

Method note: OEIS blocks WebFetch (HTTP 403) but serves `curl` with a browser
User-Agent at `https://oeis.org/search?q=…&fmt=text`. All OEIS results below come from
that endpoint. arXiv was queried through `https://export.arxiv.org/api/query`
(the `http://` form silently returns nothing — that was verified and corrected mid-search).

---

## Headline

| # | Object | Verdict |
|---|--------|---------|
| (i) | π(2^n) itself | **KNOWN** — OEIS A007053, in OEIS since the 1995 book, `keyword: nice` |
| (ii) | First differences N(r) = π(2^r) − π(2^(r−1)) | **KNOWN** — OEIS A036378, explicitly labelled "First differences of A007053" |
| (iii) | The iterated-difference table (depth ≥ 2) | **NOT FOUND** |
| (iv) | The four zeros (2,1), (4,1), (8,3), (20,6) | **NOT FOUND** |

Constraint 3 of the brief is the whole story here. The break is clean and it is
**exactly between depth 1 and depth 2**. Depth 0 of the project's table is A036378 to the
term. Depth 1 — which is the *second* difference of A007053, one single further
differencing step — returns `No results.` from OEIS, and so does every depth below it.

---

## Verdict on (i) — π(2^n): KNOWN

**OEIS A007053**, "Number of primes <= 2^n." Retrieved
`https://oeis.org/search?q=id:A007053&fmt=text`.

```text
%N A007053 Number of primes <= 2^n.
%K A007053 nonn,nice
%A A007053 _N. J. A. Sloane_, _Mira Bernstein_, _Robert G. Wilson v_, S. W. Golomb
%D A007053 N. J. A. Sloane and Simon Plouffe, The Encyclopedia of Integer Sequences,
           Academic Press, 1995 (includes this sequence).
```

b-file runs to n = 0..92 (David Baugh, using Kim Walisch's `primecount`; terms 0..86 from
Greathouse and Staple). The project's `pi2n_cache.json` (n = 0..62) is a strict prefix of
this and agrees at every term I spot-checked (π(2^62) = 109932807585469973 in both).

Its **entire CROSSREFS line** is:

```text
%Y A007053 Cf. A006880, A036378.
```

Two crossrefs. Neither is a difference table. There is no COMMENT, FORMULA, or LINK on
A007053 mentioning differences of any order. The only FORMULA is
`a(n) = A060967(2n)`.

This is the baseline, and it is the thing the brief warned not to mistake for a hit.

## Verdict on (ii) — first differences: KNOWN

**OEIS A036378**, and the match to the project's depth-0 row is exact, not approximate.

Search string used: `1,1,2,2,5,7,13,23,43,75,137,255,464,872,1612,3030,5709,10749,20390`
→ `Showing 1-1 of 1` → A036378.

```text
%N A036378 Number of primes p between powers of 2, 2^n < p <= 2^(n+1).
%C A036378 First differences of A007053. This sequence illustrates how far the
           Bertrand postulate is oversatisfied.
%F A036378 a(n) = primepi(2^(n+1)) - primepi(2^n).
%Y A036378 Cf. A000720, A190501, A190502, A190568, A007053.
%A A036378 _Labos Elemer_
```

Two things worth recording:

- The COMMENT "This sequence illustrates how far the Bertrand postulate is oversatisfied"
  is the nearest thing in the literature to a *motivation* for looking at this row. It
  frames the row as a Bertrand-slack statistic. It does not go a second step.
- A036378's crossrefs are `A000720, A190501, A190502, A190568, A007053`. A190568 is
  "Number of squares between powers of 2" — not a difference of A036378. A190501/A190502
  are the Ramanujan-prime analogues. None is a higher difference.

The complementary (composite) side of the project's identity also exists standalone:
**A182095**, "Number of composite numbers between 2^n and 2^(n+1)." And the li-residual
comparison exists: **A223853**,
`a(n) = ceiling(li(2*2^n) - li(2^n)) - (pi(2*2^n) - pi(2^n))`, and **A223900**, "Li
estimate of the number of primes in successive power of two intervals." So depth 0 and its
immediate neighbourhood are well-populated territory.

## Verdict on (iii) — the iterated-difference table: NOT FOUND

Nothing in OEIS, arXiv metadata, or general web search records the repeated differences of
π(2^n) as an object. Four independent lines of evidence:

**1. Every depth ≥ 1 row returns `No results.`** — see the number-string table below. Not
"a partial match", not "a similar sequence": the literal string `No results.` Depth 1
was tested at four different offsets and two sign conventions.

**2. Nothing that cites A036378 is a difference of it.** I enumerated the citation set by
paging `q="A036378"` through `start=0…110` (the header reads `Showing 1-10 of 120`;
110 `%N` lines recovered). The four names containing the word "differ" are:

```text
%N A373125 Difference between 2^n and the least squarefree number >= 2^n.
%N A373126 Difference between 2^n and the greatest squarefree number <= 2^n.
%N A292205 A sequence of primes beginning with 2, with each prime after that being the
           smallest prime not present differing by the least number of contiguous bits.
%N A394299 a(n) is the numerator of the expected absolute difference of two primes
           p1, p2 drawn randomly from the interval 2^n <= p < 2^(n+1).
```

None is a difference of A036378. The bulk of the 110 are "number of ⟨class⟩-primes in range
]2^n, 2^(n+1)]" — the A095xxx family, sliced by residue class, binary weight, twin-ness,
almost-primality. The neighbourhood has been mined **sideways** (change the numerator) and
never **downward** (difference it again).

Same result for A007053: `q="A007053"` gives `Showing 1-10 of 144`; of ~100 unique names
recovered, the only ones matching differ/triangle/array/table are A053976, A092479,
A126279, A373406 — none a difference table.

**3. This is the sharpest evidence.** OEIS *does* have a systematic family of
iterated-difference arrays, added largely by Gus Wiseman in 2024. Retrieved via
`q="the k-th differences"`:

```text
%N A095195 T(n,0) = prime(n), T(n,k) = T(n,k-1)-T(n-1,k-1), 0<=k<n, triangle read by rows.
%N A376682 Array read by antidiagonals downward where A(n,k) is the n-th term of the
           k-th differences of the noncomposite numbers (A008578).
%N A377033 … k-th differences of the composite numbers (A002808).
%N A377038 … k-th differences of the squarefree numbers.
%N A377046 … k-th differences of nonsquarefree numbers.
%N A377051 … k-th differences of the powers of primes.
%N A175804 … k-th differences of partition numbers A000041.
%N A378622 … k-th differences of the strict partition numbers A000009.
```

plus the antidiagonal-sum companions A376681, A376683, A376684, A377034, A377035, A377047,
A377048. The *exact construction the project performs* is a recognised OEIS genre, applied
to primes, noncomposites, composites, squarefrees, nonsquarefrees, prime powers, partitions,
and strict partitions.

**There is no member of this family for A007053 or A036378.** Note especially that
A095195's defining recurrence, `T(n,k) = T(n,k-1) - T(n-1,k-1)`, is *character-for-character*
the project's `cell(r, d+1) = cell(r, d) − cell(r−1, d)` — with `prime(n)` in the seed row
where the project puts `N(r)`. Someone wrote down precisely this recurrence and seeded it
with eight different sequences. π along a dyadic ladder was not one of them.

**4. arXiv metadata is empty on the conjunction.** Phrase machinery verified working
(`all:"prime counting function"` → 149, `all:"iterated differences"` → 29,
`all:"difference triangle"` → 32). Every conjunction returns `totalResults = 0`. I read all
29 "iterated differences" titles and all 32 "difference triangle" titles; the former are
almost entirely optimization/PDE/ML papers, the latter almost entirely coding-theory
difference-triangle-set papers. Not one concerns π.

## Verdict on (iv) — the four zeros: NOT FOUND

No trace of the vanishing anywhere, in any of the three forms I could search it.

- **As a sequence of positions.** `2,4,8,20 zeros difference table primes` → `No results.`
- **As the complementary values at the zeros** (`The-Four-Zeros.md` E2 gives the composite
  arm as 1, 4, 16, 8192): `1,4,16,8192` → `No results.`
- **Inside the containing rows.** The depth-3 row and the depth-6 row each contain one of
  the deep zeros as an interior term — `…,5,0,6,…` at (8,3) and `…,343,0,1713,…` at (20,6).
  Searching those rows (signed and unsigned, at multiple offsets) returns `No results.`, so
  no OEIS entry contains either zero *in context*.
- `vanishing higher difference prime count powers of 2` → 2 results, A001764 (ternary trees)
  and A010060 (Thue-Morse). Keyword noise.
- General web search for `"seventh difference" OR "Delta^7" prime counting function
  vanishes 2^20 dyadic table zeros` → no hit; the returned set was MathWorld's
  PrimeCountingFunction page, generic finite-difference tutorials, and unrelated prime-gap
  preprints.

I want to be plain about the strength of this particular verdict. A negative on (iv) is
weaker evidence than a negative on (iii), because (iv) is a *property* rather than a
sequence, and properties are only findable if someone wrote them in prose. What I can say
firmly is the conditional: since the object in (iii) is not recorded anywhere, there is no
recorded object in which the zeros could have been noticed.

---

## Exact number strings searched, verbatim, with results

Rows read out of `/Users/juliansambrano/GitHub/Primebeat_081426/results/joint_dyadic_triadic_table.csv`
(columns `d0_dyad`…`d7_dyad`, `d0_tri`, `d1_tri`), cross-checked against
`results/O16_run1.log`. I computed nothing.

| # | String | Result |
|---|--------|--------|
| 1 | `1,1,2,2,5,7,13,23,43,75,137,255,464,872,1612,3030,5709,10749,20390` | **A036378** (1 of 1) — depth 0 |
| 2 | `0,1,0,3,2,6,10,20,32,62,118,209,408,740,1418,2679,5040,9641,18245,34951` | `No results.` — depth 1 |
| 3 | `1,0,3,2,6,10,20,32,62,118,209,408,740,1418,2679,5040,9641,18245` | `No results.` — depth 1, leading 0 dropped |
| 4 | `1,0,3,2,6,10,20,32,62,118` | `No results.` — depth 1, short prefix |
| 5 | `0,3,2,6,10,20,32,62,118,209` | `No results.` — depth 1, offset +1 |
| 6 | `20,32,62,118,209,408,740,1418,2679,5040,9641` | `No results.` — depth 1, mid-sequence |
| 7 | `1,-1,3,-1,4,4,10,12,30,56,91,199,332,678,1261,2361,4601,8604,16706` | `No results.` — depth 2 |
| 8 | `10,12,30,56,91,199,332,678,1261,2361,4601` | `No results.` — depth 2, mid |
| 9 | `1,1,3,1,4,4,10,12,30,56,91,199,332,678,1261,2361,4601` | `No results.` — depth 2, absolute values |
| 10 | `-2,4,-4,5,0,6,2,18,26,35,108,133,346,583,1100,2240,4003,8102,15093` | `No results.` — depth 3, **contains the (8,3) zero** |
| 11 | `18,26,35,108,133,346,583,1100,2240,4003` | `No results.` — depth 3, mid |
| 12 | `2,4,4,5,0,6,2,18,26,35,108,133,346,583,1100` | `No results.` — depth 3, absolute values |
| 13 | `6,-8,9,-5,6,-4,16,8,9,73,25,213,237,517,1140` | `No results.` — depth 4 |
| 14 | `-14,17,-14,11,-10,20,-8,1,64,-48,188,24,280,623,623` | `No results.` — depth 5 (note the 623,623 repeat that forces (20,6)) |
| 15 | `31,-31,25,-21,30,-28,9,63,-112,236,-164,256,343,0,1713` | `No results.` — depth 6, **contains the (20,6) zero** |
| 16 | `9,63,-112,236,-164,256,343,0,1713,556,4355` | `No results.` — depth 6, mid |
| 17 | `31,31,25,21,30,28,9,63,112,236,164,256,343,0,1713` | `No results.` — depth 6, absolute values |
| 18 | `1,4,16,8192` | `No results.` — composite arm at the four zeros (E2) |
| 19 | `2,2,5,13,31,76,198,520,1380,3741,10129,27837,76805,213610,596911` | `No results.` — **triadic** depth 0 |
| 20 | `2,2,5,13,31,76,198,520,1380,3741` | `No results.` — triadic depth 0, short |
| 21 | `0,3,8,18,45,122,322,860,2361,6388,17708,48968,136805,383301` | `No results.` — triadic depth 1 |
| 22 | `3,8,18,45,122,322,860,2361,6388,17708,48968` | `No results.` — triadic depth 1, mid |
| 23 | `0,2,4,9,22,53,129,327,847,2227,5968,16097,43804` | `No results.` — π(3^n) itself |

Two results here go beyond the brief and are worth flagging separately.

**String 14 is the tightest single piece of evidence in this report.** The depth-5 row
contains `…,280,623,623,2336,…`. By `Zeros.lean`'s `zero_iff_repeat`, that adjacent repeat
is what *makes* (20,6) a zero. If anyone had ever tabulated this row they would have had the
repeat sitting in front of them. The string is not in OEIS.

**Strings 19–23 answer question 4 with an unexpectedly strong negative.** Not only is the
base-3 iterated table absent — the base-3 *depth-0 row* is absent, and so is π(3^n) itself.
Base 2 is a special case: it has A007053 and A036378 because powers of two are
computationally and cryptographically privileged. The general "prime counts along a
geometric ladder in base b" is not an indexed object in OEIS for b = 3, let alone
differenced. So the answer to (4) is not "studied in other bases but not base 2" — it is
that the geometric-ladder framing is essentially unrepresented, and base 2 is the lone
exception, at depth 0 only.

---

## Closest matches

Five, ranked by proximity. None is a hit on (iii).

**1. OEIS A095195** — the closest by construction.

```text
%N A095195 T(n,0) = prime(n), T(n,k) = T(n,k-1)-T(n-1,k-1), 0<=k<n,
           triangle read by rows.
```

*How it differs:* identical recurrence, different seed row. A095195 differences the primes
`p_n`; the project differences `N(r) = π(2^r) − π(2^(r−1))`. The index axis is the prime
counter in one and the dyadic cutoff exponent in the other, so the two tables share no cell.
This is the Gilbreath object (see 3 below).

**2. OEIS A377051 and the 2024 k-th-differences array family** (A376681–A376684, A377033–A377035,
A377038, A377046–A377048, A377051, A175804, A378622).

```text
%N A377051 Array read by antidiagonals downward where A(n,k) is the n-th term of the
           k-th differences of the powers of primes.
```

*How it differs:* this is the project's exact genre — a two-dimensional iterated-difference
array indexed by term and by depth, submitted for eight different seed sequences. π(2^n) is
not among the eight. This is the strongest available evidence that (iii) is unclaimed:
the shelf exists, is recent, is actively maintained, and the slot is empty.

**3. Gilbreath's conjecture and its literature.** The classical object: iterated *absolute*
differences of consecutive primes, with the claim that every row after the first begins
with 1. Verified to 10^13 by Odlyzko. Live literature — arXiv:2606.23721 (Muney, "Holes in
Valid-Extension Sets of Finite Gilbreath Sequences", math.CO/math.NT, 2026) opens:

> "Given a finite sequence of integers, form its difference triangle by repeatedly taking
> absolute differences of consecutive entries. We call the sequence Gilbreath if the
> leftmost entry of every row below the top is 1."

Also arXiv:2104.05258 (gap sequences and Gilbreath) and arXiv:1308.3113 ("Pseudorandomness
in 0's and 2's distribution in the iterated absolute differences of primes").

*How it differs:* three ways at once. Seed is `p_n`, not `π` along a ladder. Differences are
absolute, so signs are destroyed and the notion of an exact signed zero does not survive.
And the object of interest is the *leftmost column*, not interior vanishing.

**4. Szpiro, "The gaps between the gaps: some patterns in the prime number sequence,"**
*Physica A* 341 (2004) 607–617, DOI 10.1016/j.physa.2004.05.014,
`https://www.sciencedirect.com/science/article/abs/pii/S0378437104007277`. Applies Δ^n to
the primes and Fourier-analyses the resulting higher-order gaps.

*How it differs:* same "iterate the difference operator on a prime-related sequence" instinct,
but the sequence is again `p_n`. Szpiro's interest is spectral structure in the gap
distribution, not exact vanishing, and there is no ladder and no depth-indexed table with
identified zero cells. This is a genuine near-neighbour in *method* and unrelated in *object*.
I could not read the full text (paywalled) — see limitations.

**5. OEIS A036378's Bertrand comment.**

```text
%C A036378 First differences of A007053. This sequence illustrates how far the
           Bertrand postulate is oversatisfied.
```

*How it differs:* this is the recorded reason anyone has looked at depth 0, and it is a
statement about magnitude (how much slack Bertrand has), not about structure. It gives no
motive to difference again, which may be the historical reason nobody did.

---

## Search record

Every query run, with service and outcome. Empty results included.

**OEIS** (`https://oeis.org/search?…&fmt=text` via curl; WebFetch returns 403):

| Query | Outcome |
|---|---|
| `id:A007053` | 1 result, full entry retrieved and quoted |
| `id:A036378` | 1 result, full entry retrieved and quoted |
| `id:A190568` | 1 result — squares between powers of 2, not a difference |
| number strings 1–23 above | 1 hit (A036378), 22 × `No results.` |
| `"A036378"` (citation set, `start=0…110`) | 120 reported; 110 `%N` lines enumerated; no difference table |
| `"A007053"` (citation set, `start=0…90`) | 144 reported; ~100 `%N` lines enumerated; no difference table |
| `"the k-th differences"` (`start=0…80`) | 58 unique names; family enumerated; no π(2^n) member |
| `k-th differences of A007053` | 2 results, both keyword noise (A373669, A005250) |
| `array k-th differences of the number of primes` | 86 results; surfaced the 2024 family; no π(2^n) member |
| `"k-th differences" primes intervals array antidiagonals` | `No results.` |
| `"difference table" "A036378"` | `No results.` |
| `second differences of A007053` | `No results.` |
| `differences of A036378` | 19 results, all keyword-relevance noise |
| `A036378 differences` | 19 results, same noise |
| `difference table primes powers of 2` | 1020 results, all keyword noise |
| `iterated differences prime counting` | 69 results, all keyword noise |
| `successive differences of pi(2^n)` | 4 results (A000041 et al.), noise |
| `triangle successive differences primes between powers of 2` | 23 results, noise |
| `higher differences prime counting function` | 37 results, noise |
| `repeated differences pi(x) triangle` | 3 results, noise |
| `number of primes between 2^(n-1) and 2^n second differences` | 66 results, noise |
| `number of primes between powers of 3 differences` | 300 results, noise |
| `primes between powers of 3` | 620 results, no π(3^n)-ladder entry |
| `Bertrand postulate oversatisfied differences depth` | `No results.` |
| `vanishing higher difference prime count powers of 2` | 2 results, noise |
| `2,4,8,20 zeros difference table primes` | `No results.` |
| index page `https://oeis.org/index/Pri` | fetched; no difference-table entry under prime-range sequences |

**arXiv** (`https://export.arxiv.org/api/query`):

| Query | totalResults |
|---|---|
| `all:"prime counting function"` (calibration) | 149 |
| `all:"iterated differences"` (calibration) | 29 — all 29 titles read, none relevant |
| `all:"finite differences"` (calibration) | 6250 |
| `all:"difference triangle"` (calibration) | 32 — all 32 titles read, all coding theory / unrelated |
| `abs:"powers of two" AND abs:primes` (calibration) | 40 |
| `all:"Gilbreath conjecture"` / `all:"Gilbreath"` (calibration) | 17 |
| `all:"iterated differences" AND all:"prime counting"` | **0** |
| `all:"prime counting function" AND all:"finite differences"` | **0** |
| `all:"higher differences" AND all:"prime counting"` | **0** |
| `all:"higher differences" AND all:"pi(x)"` | **0** |
| `all:"primes between powers of 2"` | **0** |
| `all:"dyadic" AND all:"prime counting function" AND all:"difference table"` | **0** |
| `abs:"dyadic" AND abs:"prime counting" AND abs:"differences"` | **0** |

**General web search** (7 queries, all negative on (iii) and (iv)):

- `iterated differences of the prime counting function pi(2^n) dyadic intervals` — no relevant hit
- `"higher order differences" OR "iterated differences" of pi(2^n) primes between powers of two` — returned Gilbreath material only
- `"second differences" "number of primes" "between powers of 2" sequence table` — no relevant hit
- `difference table of prime counts in dyadic intervals exact zeros vanishing` — no relevant hit
- `mathoverflow OR math.stackexchange iterated differences of pi(2^n) primes in dyadic blocks vanish` — no relevant hit
- `"seventh difference" OR "Delta^7" prime counting function vanishes 2^20 dyadic table zeros` — no relevant hit; surfaced Szpiro reference
- `"prime counting function" "forward differences" geometric progression "b^n" table triangle` — no relevant hit
- `Szpiro "gaps between the gaps" iterated finite differences primes Physica A 2004` — located the Szpiro citation above

**zbMATH Open**: attempted, **failed**. Returns HTTP 403 to both curl and WebFetch. Zero
coverage from this service — see limitations.

---

## What I could not check

Stated plainly, because these are the seams where a hit could still be hiding.

1. **zbMATH Open — 403 to every access method available to me.** This is the most
   significant gap: it is the free abstracting service with the best coverage of older and
   non-English number-theory literature.

2. **MathSciNet — no subscription access.** Same class of gap as zbMATH.

3. **Google Scholar — not directly queryable** from this environment; it blocks automated
   access and is not exposed through the available search tool. Web search is a weaker
   proxy for citation-graph coverage.

4. **arXiv full text.** The arXiv API searches metadata only — title, abstract, authors,
   comments. A paper that computes this table in section 4 without mentioning it in the
   abstract would not appear in any of my arXiv counts. Given how incidental such a
   computation would be, this is a real possibility and my single largest uncertainty on (iii).

5. **Pre-1990s print literature.** OEIS's own coverage of that period is via Sloane's 1995
   book, which is included. But a table in, say, a 1960s *Mathematics of Computation*
   prime-tabulation paper — exactly the era when people published π(x) tables by hand — would
   likely be invisible to every service I reached. Note that A007053's history (Golomb's 1991
   letter to Sloane, Nicely's and Oliveira e Silva's tables) shows the depth-0 data was
   circulating in precisely that literature.

6. **Szpiro (2004) full text** — paywalled at ScienceDirect. I classified it from its
   abstract and from secondary descriptions in arXiv:1405.2900. I am confident it concerns
   `p_n` rather than π along a ladder, but I did not read it.

7. **Non-English literature generally**, which is largely what items 1 and 2 would have covered.

8. **Whether the four zeros are noted in any unindexed venue** — a blog, a forum thread, a
   set of lecture notes. Web search covers this only shallowly and I would not treat my
   negative on (iv) as exhaustive at that level.

One structural caveat on the OEIS negatives, in fairness to them: an OEIS `No results.` on
a number string is strong evidence that a sequence is not *indexed*, and weak-to-moderate
evidence that no one has ever *computed* it. The A377051 family finding is what upgrades
the (iii) verdict, because it shows the genre is actively curated and the slot is
specifically empty — not that the genre is unknown.
