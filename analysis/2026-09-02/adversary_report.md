# Adversary report — two documents, attacked

EXPLORATORY. No prereg, no decision rule, no verdict. This is an adversarial
read commissioned against two documents that survived their own authors'
review, per `/Users/juliansambrano/GitHub/CLAUDE.md:249-255` (the closing
paragraph of § Scope-pricing discipline: agreement with yourself is the
weakest evidence there is).

Written 2026-09-02. Every number below names the file it came from. Every
`file:line` was opened in this session.

## A frame note that governs both parts

`notes/lab_notebook_2.md` changed **during this audit**. At 16:24 and 16:37,
when the two target documents were written, entry 303's header sat at line 19.
At 18:00 entry 304 was appended (`git status`: `M notes/lab_notebook_2.md`,
staged; `python3 utilities/check_refs.py` reports "303 entries, newest 304"),
adding **172 lines above every prior entry**. Entry 296's header moved from
1673 to 1845; entry 295's from 1879 to 2051.

I verified every notebook citation in both targets at the +172 offset. **All
of them resolve.** Neither document has a wrong notebook line reference as
written. Both documents now have citations that a reader following them today
will land in the wrong entry. I attack that in Part Two, Finding B3, because it
is a design question rather than an authoring error.

Where I quote a notebook line number below I give the **current** frame. Entry
304 was committed at `379c97d` (2026-09-02 18:01:35 −0700) while I was writing;
the frame did not move again (entry 304 at 19, 303 at 191, 302 at 426, 301 at
808), so every line number below is against `379c97d`.

---

## PART ONE — `analysis/2026-09-02/arrow_tolerance.md`

## What I did

I wrote an independent re-derivation
(scratchpad `recheck.py`, outside the tree) that reads
`analysis/2026-09-01/results/weil_Lc_theory.numbers` and
`analysis/2026-09-01/results/weil_Lc_eps.numbers` by key and recomputes every
law, surface, table and cost in the census without importing or reading
`arrow_price.py`'s output. I re-fit the height law from the 24 raw rows rather
than trusting `fits.*`. I ran the upstream probe myself. I grepped both Lean
trees and the PNT+ package at the pin and at `origin/main`.

**The arithmetic reproduces.** Sections B, D, E, F, G, H, I, K, L, M, N of my
re-derivation agree with the census to every printed digit: the three measured
`(a, b, R²)` triples, the bilinear surface (`rms 0.2050`, `max |resid| 0.4678`
— identical to `surface_validation.rms_resid` 0.2050049317462969 and
`.max_abs_resid` 0.46777521512321885), the nine consumer `L`/`X` pairs, the
twelve vacuity thresholds, the three `T_reach` values at `L = log 2`, the three
`k=1` measured rows, the six-row ε-law extension, the three `Rmax` rows and the
`1.1025` cube-root bound, the six-row ε budget and its support table, and the
four loosest-consumer rows. I re-fit `L = a + b log γ` from the 24 rows myself
and got `a = -3.5132, b = 1.7686, R² = 0.9934` at ε = 10⁻³, matching
`fits.0.001.measured.*` exactly.

Findings below are ranked by severity.

---

### A1 · The census's headline price for its own load-bearing piece contradicts the key cited beside it

**Claim attacked.** `arrow_tolerance.md:145-147`: "Its prices are 2.1–5.2× the
measured (`theory.k=1|eps=0.001.ratio_meas_over_theory` 0.1930 to
`theory.k=30|eps=0.1.ratio_meas_over_theory` 0.6232)". Repeated at `:373-374`:
"costs 2.1–5.2× more support".

**What I did.** Read all 15 `theory.k=*|eps=*.ratio_meas_over_theory` keys from
`analysis/2026-09-01/results/weil_Lc_theory.numbers` and inverted each.

**What I found.** The two cited values are correct. The range they imply is
**1.6047× to 5.1818×**, from
`theory.k=30|eps=0.1.ratio_meas_over_theory` 0.6231587189140244 (1/0.6232 =
1.6047) and `theory.k=1|eps=0.001.ratio_meas_over_theory` 0.1929821578337733
(1/0.1930 = 5.1818). The full sorted table:

```text
  k=   1 eps=0.001  ratio=0.192982  cost=5.1818x
  k=   2 eps=0.001  ratio=0.215549  cost=4.6393x
  k=   2 eps=0.01   ratio=0.250639  cost=3.9898x
  k=   5 eps=0.01   ratio=0.254974  cost=3.9220x
  k=  10 eps=0.01   ratio=0.271463  cost=3.6837x
  k=   2 eps=0.1    ratio=0.336837  cost=2.9688x
  k=   5 eps=0.1    ratio=0.337183  cost=2.9657x
  k=  10 eps=0.1    ratio=0.364880  cost=2.7406x
  k=   1 eps=0.01   ratio=0.371803  cost=2.6896x
  k= 100 eps=0.01   ratio=0.443545  cost=2.2546x
  k= 100 eps=0.1    ratio=0.448895  cost=2.2277x
  k=   1 eps=0.1    ratio=0.468367  cost=2.1351x
  k=  30 eps=0.01   ratio=0.468653  cost=2.1338x
  k= 300 eps=0.1    ratio=0.528564  cost=1.8919x
  k=  30 eps=0.1    ratio=0.623159  cost=1.6047x
```

The number **2.1** is the cost at `theory.k=1|eps=0.1` (2.1351×) or
`theory.k=30|eps=0.01` (2.1338×). Neither is the key the census names. Entry
302's own header (`notes/lab_notebook_2.md:426`) says "2–5×", which is correct
if the ε = 0.1 rows are excluded; the census extended the range to ε = 0.1 and
kept the old low endpoint.

This is the exact failure mode the sibling document (`systems_architecture.md`
§8.2) says no checker catches: a correct value beside a key, with a derived
quantity in the prose that the key does not support. `check_entry_numbers.py`
would pass this sentence, because 0.6232 is the true value of the cited key.

**Verdict: BREAKS.** The stated price of P3 — the census's own "genuinely open
piece" — is 31% wrong at its low end and the error is visible from the citation
in the same sentence.

---

### A2 · The bottom line calls P6 dischargeable; §5.3 says the mechanism that would discharge it does not exist

**Claim attacked.** `:388`: "one (P6) is dischargeable by the consumer's own
tolerance". Also `:207-208`: "Consumer tolerance removes even that limit".

**What I did.** Read the definition of the conclusion at the pin, and read the
census's own weakness 3.

**What I found.** `riemannZeta.RH_up_to T` is
`IsEmpty (riemannZeta.zeroes_rect (Set.Ioo 0.5 1) (Set.Icc 0 T))`
(`lean_stage3/.lake/packages/PrimeNumberTheoremAnd/PrimeNumberTheoremAnd/IEANTN/ZetaDefinitions.lean:117`).
It quantifies over every `Re ρ ∈ (0.5, 1)`. The census states the consequence
correctly at `:188-189`: "the arrow must detect at every `ε > 0`, and no finite
`L` does."

Its own §5.3 (`:412-420`) then says the tolerance "is my arithmetic, not a
theorem in this tree… no consumer in the pinned package is stated with a
notched rectangle… Cashing the tolerance means writing a new Stmt and
re-proving a consumer that has never been proved."

Those two paragraphs disagree. The tolerance changes the **consumer's**
statement; it leaves `StmtWeilPositive L → RH_up_to (T L)` — the arrow entry
303 §(d) actually wrote (`notes/lab_notebook_2.md:365-371`) — unprovable at
every finite `L`, because the antecedent is a hypothesis and the consequent
quantifies over ε → 0. §4 is the paragraph a reader carries away, and it does
not carry §5.3's concession.

**Verdict: WEAKENS.** The measurement is right and the framing overstates it.
The honest sentence is: the ε quantifier costs 0.073 in `L` per e-fold in 1/ε
at γ₁, and removing the limit requires a Stmt nobody has written and a consumer
re-proof nobody has done.

---

### A3 · The "32 orders of magnitude" span mixes an intercept from one fit with a slope from another

**Claim attacked.** `:228-233`: "Across all twelve (variant, ε) cells `b` ranges
over `b_range.min` 0.6072608975189738 to `b_range.max` 3.192722125209896, which
at `T` = 3e12 is `X` between `b_range.X_at_3e12_min` 1124849.07 and
`b_range.X_at_3e12_max` 2.043e38."

**What I did.** Reproduced `b_range` and then recomputed `X` at `T = 3e12`
using each extreme cell's **own** `(a, b)` pair.

**What I found.** `b_range.min` 0.6073 comes from `fits.0.1.far_only_exact`
(`a = -0.8146`); `b_range.max` 3.1927 comes from `fits.0.001.far_only_bound`
(`a = -4.4611`). `arrow_price.py:533-537` holds `law["a"]` fixed at
`fits.0.001.measured.a` = -3.5132 and varies only `b`:

```text
DOC (a from measured/1e-3 + b from elsewhere): min 1.12485e+06  max 2.04271e+38
HONEST per-cell (far_only_exact, 0.1):  a=-0.8146 b=0.6073 -> X@3e12 = 1.67152e+07
HONEST per-cell (far_only_bound, 0.001): a=-4.4611 b=3.1927 -> X@3e12 = 7.91691e+37
```

In a log-linear fit `a` and `b` are strongly anti-correlated; varying `b` with
`a` pinned is not a band any of these fits predicts. The stated span is 32.26
orders; the per-cell span is 30.68. The direction survives; the numbers as
printed are predictions of no fit in the file.

**Verdict: WEAKENS.** The claim "the exponent is the load-bearing constant"
holds. The interval quoted around it does not come from the file.

---

### A4 · The b-range maximum rests on a five-point fit, and the census's own weakness list does not name it

**Claim attacked.** `:394-403`, §5 weakness 1, which names only the eight-point
measured fit.

**What I did.** Read `fits.<eps>.<variant>.n` for all twelve cells and the
`ks[*]` list for the fit supplying `b_range.max`.

**What I found.**

```text
measured        eps 0.001/0.01/0.1 -> n = 8, 8, 8
far_only_bound  eps 0.001/0.01/0.1 -> n = 5, 8, 8
far_only_exact  eps 0.001/0.01/0.1 -> n = 8, 8, 8
full            eps 0.001/0.01/0.1 -> n = 2, 6, 7
```

`fits.0.001.far_only_bound.n` is **5**, over `ks = [1, 2, 5, 10, 30]`, i.e.
`log γ ∈ [2.649, 4.618]` — two-thirds of the measured fit's span. That fit's
`b = 3.1927` is `b_range.max`, and it is what produces `2.043e38` at `T = 3e12`
(`log T = 28.73`, **6.2× that fit's own upper limit in `log γ`**). The same fit
supplies the census's vacuity-threshold row `far_only_bound eps=0.001 3.9953`
(`:243`).

Weakness 1 names the 8-point measured fit; weakness 2 names the `full` fits.
Neither names the 5-point fit that carries the section-3 headline.

**Verdict: WEAKENS.**

---

### A5 · Weakness 2 misidentifies where P3's price stands, and the real weakness is not stated

**Claim attacked.** `:405-410`: "P3's price is the most load-bearing claim in
this census and it stands on the worst fits in the file."

**What I did.** Traced P3's price to its source keys.

**What I found.** P3's price (the ratio range of A1) is 15 **direct row
measurements** of `ratio_meas_over_theory`. It does not pass through
`fits.<eps>.full.*` at all. Only `eps_budget_support_full` uses those fits, and
the census already disclaims that table (`:332`). So weakness 2 flags a
dependency P3's price does not have.

The dependency P3's price **does** have is survivorship. The fixed window has a
root at 15 of 24 (variant, ε) cells:

```text
     k    eps=0.001     eps=0.01      eps=0.1
     1        6.651        3.063        2.049
     2        6.946        5.209        3.439
     5         null        8.126        5.268
    10         null       11.310        7.214
    30         null        8.467        5.554
   100         null       11.563        9.795
   300         null         null       10.040
  1000         null         null         null
```

(from `theory.k=*|eps=*.variants.full.L_c` in
`analysis/2026-09-01/results/weil_Lc_theory.numbers`). The nine nulls are
exactly the small-ε, large-γ corner — where the arrow's consumers live. On
those nine cells the fixed window's price is unbounded. Quoting "1.60–5.18×"
without that conditioning makes the explicitly-written `G` look 37.5% cheaper
than the grid shows. The census does report the k = 1000 failure at `:146-147`
and `:373-374`; it does not report that the range itself is conditioned on
detection.

**Verdict: WEAKENS.** P3's conclusion ("a construction that does not exist")
survives and is if anything stronger. The census's self-criticism points at the
wrong dependency.

---

### A6 · "Connes–Consani Conjecture 4.1 is exactly this statement" — it is adjacent

**Claim attacked.** `:181-184`: "Price: an unproved hypothesis in the form the
ladder needs it — Connes–Consani Conjecture 4.1
(`notes/lab_notebook_2.md:1813-1816`) is exactly this statement, and it is a
conjecture."

**What I did.** Opened the cited lines (now `notes/lab_notebook_2.md:1985-1988`)
and entry 296's consequence paragraph (now `:2041-2049`).

**What I found.** Conjecture 4.1, verbatim: "The semi-local operator theoretic
framework with S := {∞} ∪ {p | p < q} suffices to prove the Weil inequality for
all test functions with support in the interval (q^{−1/2}, q^{1/2})."

The census's "this statement" is entry 296's: "a proof of rung 3 cannot bound
the prime term crudely against an archimedean margin (Bombieri Thm 12's
method); it must use log 2 to that precision."

Conjecture 4.1 asserts that a proof **strategy** (finitely many primes, semi-local
framework) suffices at support `log q`. It says nothing about the precision to
which `log 2` must be known. The two are related — Conjecture 4.1 is the named
open statement that would deliver the rungs — and "exactly this statement" is
false.

**Verdict: WEAKENS.** P5's conclusion (open, published as a conjecture, the
crude-explicit spec buys nothing) holds. The identification is loose.

---

### A7 · "The reason is arithmetic" is asserted, not derived, and the rung list is hand-typed

**Claim attacked.** `:255-257`: "Every proved rung is vacuous, and the reason is
arithmetic: `X = 2` is exactly where the first prime enters at weight zero."
Also `:381-383`: "the remaining distance… is exactly the step of admitting the
prime 2 at nonzero weight".

**What I did.** Checked the units convention against entry 295
(`notes/lab_notebook_2.md:2070-2072`), entry 296's Answer (b) (`:2022-2028`),
`REFERENCES.md:145-147`, and read `arrow_price.py`'s `RUNGS` list.

**What I found, in three parts.**

*The arithmetic is right.* Entry 295: "Test function F = G⋆G̃ with G supported
on [−L/2, L/2], L = log X, so F is supported on [−L, L] and exactly the prime
powers n ≤ X enter the prime sum". At `X = 2`, `log 2` is the endpoint of F's
support, so `F(log 2) = 0`. `REFERENCES.md:145-147` gives Connes' §6.4
convention as support `[λ⁻¹, λ]` with `L = 2 log λ`, so `X = e^L = λ²`; the
census's `λ² ~ 11 → X = 11 → L = log 11` and `[2^{-1/2}, 2^{1/2}] → X = 2` are
both consistent. I looked hard for a factor-2 convention break between
Bombieri's `|I| < log 2` and Yoshida's `a ≤ log 2/2` (entry 296:2026) and found
none: `|I| = 2a = L`, and the census's `L = log 2` is the right reading of both.

*The reason is not derived.* Vacuity is computed from the fitted law:
`T_reach(log 2) = exp((log 2 − a)/b)` gives 10.7879 / 11.7045 / 13.1150 at the
three ε, all below `γ₁ = 14.134725141734695`. Nothing in the census connects
that inequality to the prime-2 boundary. What is true is a fact about the
**literature**: Yoshida, Bombieri Thm 12, Burnol, Connes–Consani Thm 1 and
Suzuki Thm 1.4 all stop at `L = log 2` precisely because no prime enters below
it, and the arrow needs more support than that. That is a real structural
statement about where the proofs stop. It is not a derivation of vacuity, and
the "because" in the sentence is doing work the file does not support.

*The rung list is a hand-typed literal.* `arrow_price.py:168-184` is five
dictionary entries, two of them proved and both set to `math.log(2.0)`, with
`cite` fields pointing at notebook entries rather than at the papers. There is
no grid and no sweep. "Every proved rung is vacuous" is a statement about two
hand-entered rows. It happens to be true, and it is not a survey.

*It has now propagated into a title.* Entry 304's header
(`notes/lab_notebook_2.md:19`, committed at `379c97d`) reads "every proved rung
is vacuous **because** X = 2 is where the first prime enters at weight zero".
Titles are never retitled (`AGENT_CARD.md:9-11`), so the un-derived causal
clause is now durable in the record.

**Verdict: WEAKENS.** The arithmetic holds; the causal claim is asserted.

---

### A8 · `consumers_proved_at_pin = 0` is typed into the registry rather than measured — and it is true

**Claim attacked.** `:84-88`: "All fifteen consumers are `sorry` at the pin.
`consumers_proved_at_pin` is 0."

**What I did.** `arrow_price.py:107-156` hardcodes `proved=False` on every
consumer; `:407` counts `proved is True`. Nothing in the script opens a `.lean`
file. So I checked all fifteen myself.

**What I found.**

```text
grep -rn 'RH_up_to' --include='*.lean' PrimeNumberTheoremAnd/  (build artefacts dropped)
  -> 16 lines: 1 definition (ZetaDefinitions.lean:117) + 15 consumers
```

Thirteen are theorems and all thirteen close with `sorry`
(`TMEEMT.lean:157,170,183,196,1303`; `ZetaSummary.lean:103,113,123`;
`BKLNW/BKLNW_app.lean:1135` closing at `:1158`; `CH2/CH2.lean:4319,4333`;
`FioriKadiriSwidinsky/FioriKadiriSwidinsky.lean:408,418`). Two are structure
fields (`BKLNW_app.lean:24`, `FioriKadiriSwidinsky.lean:26`). Every location,
`x`-floor and `T`-literal in the census's table is correct against source.

**Verdict: HOLDS.** The claim is true. The method that produced it does not
measure it, so the next pin bump can silently falsify it.

---

### A9 · The upstream probe reproduces, and I extend it further than the census went

**Claim attacked.** §3b, `:334-356`.

**What I did.** Ran `git fetch origin` in the package directory
(`lean_stage3/.lake/packages/PrimeNumberTheoremAnd`) and reran every command.

**What I found — exact reproduction.** Five commits `47fa486..origin/main`
(`a515467` back to `c6c7361`), three files touched
(`.github/workflows/build.yml`, `IEANTN/Dusart.lean`, `IEANTN/TMEEMT.lean`),
the case-insensitive `weil|explicit|positiv|criterion|fourier` grep over those
commit messages and bodies exits 1 with no output. `a515467`'s date renders as
`2026-08-31 02:15:29 +0530`, which is the same instant as the census's
`2026-08-30 13:45:29 −0700`. The pin at `lean_stage3/lake-manifest.json:8` is
`47fa48680663df41146704d02a5b092d792bd5b9`.

**What the census did not check.** Three of the five commits are `feat(TMEEMT):
fill …` — they discharge sorries in the file holding five of the fifteen
consumers. The census's §3b greps only for the Weil direction and concludes a
pin bump helps only P2. I checked whether a bump moves the consumer census:

```text
TMEEMT.lean sorry tokens   pin 81   origin/main 77
RH_up_to sites at origin/main: BKLNW_app 2, CH2 2, FKS 3, TMEEMT 5, ZetaDefinitions 1, ZetaSummary 3  = 16
Kadiri.lean sorry tokens   pin 14   origin/main 14
backlund_bound at origin/main: Kadiri.lean:2618, still `sorry`
```

Sixteen at both, so the consumer set is unchanged; the four filled sorries are
in the `Buthe`/`RS_prime`/`Dusart1999` namespaces, a different `theorem_2a`
from `Buthe2.theorem_2a` at `:157`. **A pin bump to `origin/main` today
discharges nothing in this census, including P2.**

**Verdict: HOLDS, and strengthened.** The census's conclusion survives a check
it did not run.

---

### A10 · P1, P2 and P4 verified against source and store

- **P1.** `kadiri_thm_3_1_q1` at `Kadiri.lean:1362`; `identity_16_complex` at
  `:3224` with its `sorry` at `:3243`; the annotation at `:1416` reads
  "`sorry` for now (dominated convergence + summability across the $T \to
  \infty$ limit)" with sorries at `:1424` and `:1444`; horizontal-arc sorries
  at `:454`, `:486`; `grep -c sorry Kadiri.lean` = 14. All exact.
- **P2.** `riemannZeta.Riemann_vonMangoldt_bound` is defined at
  `ZetaDefinitions.lean:161-163` (the census cites `:149-162`, which starts at
  the blueprint attribute and stops one line short of the body — the statement
  is covered). `backlund_bound : Riemann_vonMangoldt_bound 0.137 0.443 6.1` at
  `Kadiri.lean:2618`, `sorry` at `:2619`. `params.Rmax_form` in the theory
  store reads `"0.137 log T + 0.443 log log T + 4.35 (assumed)"`. The three
  ratio rows (1.3402 / 1.2812 / 1.2515) and the 1.1025 cube-root bound
  reproduce exactly, as does
  `fits.0.01.far_only_bound.rms_resid` 0.17239329228390704.
  **One thing the census misses:** the bench's own entry 130
  (`notes/lab_notebook_2.md:12054`) already records "Rosser's
  (0.137,0.443,6.1)". The 4.35 was a regression against this tree's own
  record, not only against upstream. That strengthens P2's finding.
- **P4.** `params.window.m2` 0.13069096604865776 (= 1/3 − 2/π² to 15 digits),
  `params.window.m22` 0.06002278067061667 (= (2 − 15/π²)/8), and
  `first_over_exact` over all 24 `section0_minimisers[*]` runs
  0.9623614147718252 to 1.0006695368217324. Exact.

**Verdict: HOLDS.**

---

### A11 · The extrapolation claim understates itself, and conflates span with maximum

**Claim attacked.** `:396-399`: "`Platt_theorem`'s `L` = 39.188 rests on
extrapolating `log T` to 24.15 — more than three times the fitted span."

**What I did.** Computed `log T` for every finite consumer against the fitted
`log γ` range.

**What I found.** The fitted range is `log γ ∈ [2.6486, 7.2580]`; the span is
4.609 and the maximum is 7.258. `24.1446 / 7.258 = 3.33`, so "three times" is
three times the **maximum**. Measured against the span it is 3.67 spans past
the top. Either reading exceeds three, so the claim survives its own phrasing.

Platt is not the worst case in the census's own table: `PT_theorem_1` at
`T = 3e12` has `log T = 28.7296`, **3.96×** the fitted maximum, and the ε-budget
table's `x = 1e19` row evaluates the surface at `T = 2.35223e9` (2.97×) **and**
at ε = 0.5, five times the largest measured ε — two extrapolations
simultaneously, in the cell the census then uses to compute
`L(K=70) = 25.346` (`:307`).

**Verdict: WEAKENS.** Weakness 1 is honest and picks a milder example than the
one beside it.

---

### A12 · The hardest question — is this the arrow the ladder needs?

**Claim attacked.** The census's premise that
`StmtWeilPositive L → riemannZeta.RH_up_to (T L)` is worth pricing.

**What I did.** Read entry 303 §(c) and §(d)
(`notes/lab_notebook_2.md:334-340`, `:365-393`), entry 296's Answer and
Consequence (`:2022-2039`, `:2041-2049`), `REFERENCES.md:115-150`, and grepped
both local Lean trees.

**What I found — the census's §1 is right, and §4 does not carry it.**

`grep -rn 'RH_up_to' lean_stage3/Stage3/ lean_stage3/Stage3.lean lean/` returns
zero lines. Stage 3's open leaf is `StmtZeroFreeRight θ` at
`lean_stage3/Stage3/Abscissa.lean:112-113`, `∀ s : ℂ, θ < s.re → s ≠ 1 → ζ s ≠ 0`
— a half-plane at every height. No finite-`T` rectangle satisfies it at any
`L`. The census says exactly this at `:36-49`: "The arrow does not feed the
dial."

Three things follow that §4 does not say.

1. **Entry 303 declined this leaf, on the project's own rule.**
   `notes/lab_notebook_2.md:381-384`: "Candidates from this entry, NOT ADDED:
   `StmtWeilExplicit` … and `StmtWeilPositive L → RH_up_to` (no route; sketch
   only). Adding either is Julian's call, and the rule is a leaf enters with
   its budget and its route or does not enter." Pricing a candidate is exactly
   what `CLAUDE.md:229-240` asks for. Presenting the price as "the arrow at the
   loosest useful precision needs six pieces" (`:385`) reads as a build plan
   for a leaf the ledger does not contain.

2. **Entry 303 names a different direction as the one the ladder runs.**
   `:382-387` (current frame `notes/lab_notebook_2.md:386-393`): "'Q(G) < 0 for
   this G at this h' ⇒ 'a zero is off the line by at least ε(h, k)' is a
   computable implication for ONE G — **the direction the ladder runs**". That
   is the contrapositive of the easy half of Weil's criterion, it needs one
   explicit `G` rather than a quantifier over all of them, and P3 and P6 do not
   arise in it at all. The census prices the hard half.

3. **The measured `L_c` bounds the contrapositive, and the census treats it as
   bounding the implication.** Every `L_c` in entries 299–302 answers: at what
   support does a numerical minimiser over a finite basis find a `G` whose `Q`
   goes negative in the presence of a zero at `(ε, γ)`? That is an upper bound
   on the true `L_c` (a richer basis can only find a witness sooner), which is
   the favourable direction. It is still a measurement of *detection*, and the
   arrow needs *implication*. They coincide only when the minimisation is over
   the whole support class; the instrument's is over `M = 32` Legendre or
   modulated basis functions. Entry 301 (`notes/lab_notebook_2.md:646-651` in
   the old frame, current `:818-823`) records the last time a basis limit was
   read as a physical result and had to be corrected two entries later.

**Verdict: the census prices a statement adjacent to the one the ladder needs.**
The adjacency is stated in §1 and dropped by §4. This is the most consequential
finding in Part One, and it is a framing finding rather than an arithmetic one.

---

### A13 · Errors the census did not name — a residual list

- The 15-row ratio range is conditioned on detection (A5).
- `bklnw_thm_16` requires `RH_up_to (c/ε)` with `3 ≤ c` and `0 < ε < 1e-3`
  (`BKLNW_app.lean:1129-1135`), so `T > 3000` **strictly** and unbounded above.
  The census pins `T = 3000` (`:63`), the infimum, and does not say it is not
  attained. Same class as Bombieri's strict `|I| < log 2`, which the census's
  `L = log 2` rung also treats as attained (entry 296:2026).
- `arrow_price.py:624` re-writes `OUT_TXT` after printing the two "wrote …"
  lines, so `arrow_price.txt` is written twice per run. Harmless; it means the
  `.txt` is not a byte-for-byte record of one write.
- `surfaces.full.B1` −0.3009 is a fit over **three** ε points
  (`b = 0.7418, 2.6641, 2.1275` at `u = 6.908, 4.605, 2.303`), with
  `b_R2 = 0.4879`. The census calls it "on a two-point fit at ε = 0.001"
  (`:331`), which describes one of its three inputs.
- `python3 utilities/check_refs.py` exits 0 over the tree with the census in
  place.

---

## Part One — count and bottom line

**BREAKS 1 · WEAKENS 7 · HOLDS 4.**

BREAKS: A1.
WEAKENS: A2, A3, A4, A5, A6, A7, A11.
HOLDS: A8, A9, A10, and the whole re-derived arithmetic.

**Does the bottom line stand?** The bottom line has two halves and they part
company.

The **census half stands**. Every price I could recompute reproduced to the
digit. The six-piece decomposition survives; P4 is elementary and checked, P2 is
an upstream statement with a 1.10× optimism inside its own fit noise, P1 is a
known-size build, P5 and P3 are open, and P6 is small on the axis the census
measured. The upstream probe reproduces and survives an extension the census
did not run. The single arithmetic break (A1) makes P3's price look better than
it is, so correcting it strengthens the conclusion that P3 is the open piece.

The **scope half does not stand as written**. §4 presents a build plan for an
arrow that (i) entry 303 explicitly declined to add to the ledger for want of a
route, (ii) nothing in either local Lean tree consumes, (iii) cannot be proved
at any finite `L` as stated, and (iv) is not the direction entry 303 says the
ladder runs. §1 establishes all of that and §4 drops it. The document's own §1
is the correct bottom line; §4 is not.

**What would still break the census half.** A re-run of entries 299–302's
minimisation at a materially richer basis (`M` well past `γ_k h/π`) that moved
any measured `L_c` by more than the 0.2050 surface rms would falsify the height
law the whole of sections 2–4 rests on. Entry 301 (`notes/lab_notebook_2.md:818-823`)
already records one basis-limit artefact that survived two entries. The census
inherits that risk untested and does not name it.

---

## PART TWO — `analysis/2026-09-02/systems_architecture.md`

## What I did, Part Two

Re-ran every measurement in §1.3 with my own script (scratchpad `count.py`,
`count2.py`), using `check_entry_numbers.py`'s own `NUM` regex and its own
fence-stripping so the comparison is like-for-like. Opened all 17 cited
`file:line` locations plus the four `container_audit_report.md` ranges.
Reproduced the transclusion prototype. Fetched both arXiv citations. Commissioned
an independent read-only inventory of the drift corpus in entries 298–303 and
the 2026-09-01/02 git log, and hand-classified it against the document's own
classes.

The verification result up front: **every `file:line` citation in this document
that I opened is exact.** That is 21 for 21. The prose is anchored.

---

### B1 · The 24-error corpus is a subsample, and the class mix inverts on the full one

**Claim attacked.** `:119-129`: "in-entry corrections of the brief: 25 | by
entry: 303:3 302:2 301:7 300:4 299:3 298:5 (+ one in entry 229) … Their kinds:
twelve wrong line references, five wrong values or wrong rows, three wrong
counts, three wrong durations, and four range or 'identical' claims in words."
And `:443`: "Budget: 24 measured errors, of which 12 line refs + 5 values + 3
counts + 3 durations = **20 of 24** are things a generated block cannot get
wrong." And `:750`, step 7: "20 of the 24 measured brief errors become
impossible."

**What I did.** Two passes. First a regex over entries 298–304 for the
`brief (said|cited|had|asked|carried|…)` construction. Second, an independent
read-only agent hand-classified every recorded correction with a verbatim quote
and a line number.

**What I found.** Both passes give roughly twice the document's count.

```text
regex 'the brief said/cited/had/asked/...' per entry
  303: 8   302: 2   301: 12   300: 4   299: 3   298: 10      total 39
hand-classified strict "brief said X, file says Y"
  303: 5   302: 2   301: 11   300: 5   299: 6   298: 12      total 41
  plus 4 soft (brief omission / brief-reported-but-unfiled)  total 45
```

The document's per-entry numbers (3, 2, 7, 4, 3, 5) are below both passes at
every entry except 302, where all three agree at 2.

The class distribution on the 41 hand-classified:

```text
(a) wrong line/path reference     10
(b) wrong digit                    4
(c) wrong count                    4
(d) wrong duration                 3
(e) wrong qualitative/range claim  11
(f) right number, wrong row/column/endpoint, generalised   8
(h) other                          1
```

**(e) + (f) = 19 of 41 = 46%.** The document's §8.4 puts the unfixable
qualitative class at "four of the twenty-four" = 17%, and its §8.2 names (f)
separately without counting it into the budget.

Recomputing step 7's buy on the fuller corpus: a generated `## Inputs` block
fixes (a) + (b) + (c) + (d) = 21 of 41 = **51%**, against the claimed 83%. And
the (f) examples are the ones that matter — entry 301's
`notes/lab_notebook_2.md:905-907` (current frame): "k = 100, ε = 0.01 reads
5.0415 (brief 4.9561, which is that row's `w = 1` value); k = 300, ε = 0.1 reads
5.2170 (brief 5.1285, likewise the `w = 1` value)". A `## Inputs` block that
resolves `weil_Lc_mod#…w=1.L_c` and prints its true value would have carried
those two wrong-column numbers through untouched, because they are true values
of the wrong key.

**Verdict: BREAKS.** The single quantitative justification for the
highest-value migration step is computed on roughly half the measured
population, and on the full population the fixable fraction falls from 83% to
51%. Step 7 remains worth doing; its priced buy is wrong by a factor near 1.6
on the fraction, and the residue is concentrated in the class the design says
it cannot touch.

---

### B2 · The receipt's artifact-sha invariant fires on every re-run of an identical script

**Claim attacked.** `:336-340`: "**What makes a value authoritative:** the
artifact's sha256, recorded in the receipt, matching the artifact on disk." And
`:561`: "a receipt's artifact sha matches disk | CI | **block**".

**What I did.** Read `utilities/flatten_results.py:1-30` and the `meta.*`
convention, then traced what happens on a re-run.

**What I found.** The receipt binds an entry to `sha256(artifact bytes)`. Every
results JSON in this tree carries `meta.timestamp` and `meta.elapsed_s` (for
`arrow_price.json`, written by `arrow_price.py:613-618`). A bit-identical
re-run at a different second produces different bytes, therefore a different
sha256, therefore a CI **block** on a receipt whose every value is unchanged.

The tree already knows the fix and the design does not adopt it.
`flatten_results.py:22-30`:

```text
A leaf whose key path carries a timing or provenance token ... is written with
the prefix `meta.` so that

    diff <(grep -v '^meta\.' a.numbers) <(grep -v '^meta\.' b.numbers)

is the reproduction test between two runs.
```

`values.toml` (`:637-639`) exempts `meta.timestamp` and `meta.hostname` from
**key** comparison, and leaves the artifact **identity** as a whole-file hash.
Those two decisions contradict each other.

The consequence the question asks about — artifact regenerated, hash changed,
entry still correct — therefore has no defined resolution in the design. The
entry is append-only. The receipt is the permanent binding. Editing the receipt
to the new sha silently re-points a committed record at bytes nobody compared.
The document's `metrics diff` borrowing from DVC (`:214-215`, "a changed number
is a reviewable event") is the right instinct, and no gate in §5 implements it.

**Verdict: BREAKS.** As specified, the receipt gate produces a guaranteed false
block on the most ordinary event in this tree, and the design's own primitive
for that case is documented ten lines from the format it cites.

---

### B3 · The corpus's most mechanical failure is notebook self-citation, and the design has no invariant for it

**Claim attacked.** `:679`: "The twelve line-reference errors and the five value
errors of §1.3d become **impossible** rather than discouraged." And `:443`,
hop 3: "every line range verified against the file".

**What I did.** Traced the two uncorrected line references in entry 303 and the
citations in the document I audited in Part One.

**What I found — a live, uncorrected instance and a fresh one created today.**

Entry 303 cites `notes/lab_notebook_2.md:1233` for entry 296's Answer paragraph
and `notes/lab_notebook_2.md:2912-2913` for entry 271's absorbed `ζ′/ζ(0)`
sentence. Both were correct against the file as it stood at commit `33df8ca`.
Commit `37d4605` prepended 617 lines (entries 302 and 303). Both citations are
now off by exactly 617 and land in the wrong entries. This is verifiable from
git: `git show 33df8ca:notes/lab_notebook_2.md` has the Answer paragraph at
1233 and the `ζ′/ζ(0)` sentence at 2913.

Today, entry 304 added 172 more lines. **Every notebook citation in
`arrow_tolerance.md` — nine of them — went stale between 16:37 and 18:00 while
this audit was running.** They were correct when written and they are wrong now.

A `## Inputs` block generated by `brief.py` at emit time has exactly this
property: it verifies the line range against the file at emit time, and the
next append invalidates it. For the newest-first, append-only notebook the
invalidation is not a risk, it is a certainty on every entry.

The design knows the shape of the problem. `values.toml` (`:621-624`) records
`newest_first = true` and `append_only = true`. §5's "New — invariants with no
gate today" table (`:548-561`) has ten rows and none is "a citation into the
notebook resolves to the entry it names".

The fix is cheap and the design does not propose it: cite the notebook by
`entry N § <name>` rather than by line, which is what `AGENT_CARD.md:39-41` and
`~/GitHub/CLAUDE.md`'s NOTEPAD rule already ask for elsewhere, and gate on
"a `lab_notebook*.md:<line>` reference in committed prose resolves inside the
entry it claims".

**Verdict: BREAKS.** Ten of the 41 measured brief errors are class (a), the
design's biggest single claimed win, and the sub-class with the highest base
rate in this tree is the one the design does not address at all.

---

### B4 · Step 3's cost is understated and its benefit is priced against a plan nobody proposed

**Claim attacked.** `:746`, step 3: "`.numbers` becomes derived: gitignore it,
commit the exemptions `values.toml` declares, add a CI regeneration check |
cost: one `.gitignore` edit, one CI step | buys: **~272 MB never enters the
repo**".

**What I did.** Checked what is currently tracked and measured the real ratio.

**What I found, three problems.**

*The `.numbers` files are already tracked.* Four of the five are committed
(`analysis/2026-09-01/results/weil_Lc_{eps,height,mod,theory}.numbers`,
9,311,017 bytes total; `arrow_price.numbers` is staged as `A`). A `.gitignore`
line has no effect on a tracked path. Making the store derived requires
`git rm --cached` on those files — removing 9.3 MB of committed content, a
destructive index operation that step 3 does not mention and does not price.

*The benefit is a counterfactual.* "272 MB never enters the repo" is the cost of
"just flatten everything" (§1.3h), which the design already rejects. Nobody
proposed flattening 203 JSONs. The saving actually realised by step 3 today is
**9.3 MB**, and the 272 MB belongs in §1.3h's argument for not doing something
else, where it already appears.

*The ratio is wrong.* `:180-182`: "measured .numbers/.json size ratio 1.46
(8-file random sample)". The tree's own five committed pairs give:

```text
weil_Lc_theory   178,122 ->    358,863   2.0147
weil_Lc_eps      596,874 ->  1,134,753   1.9012
weil_Lc_height 2,403,163 ->  4,803,979   1.9990
weil_Lc_mod    1,547,190 ->  3,013,422   1.9477
arrow_price       28,359 ->     36,419   1.2842
aggregate      4,753,708 ->  9,347,436   1.9663
```

At 1.9663 the projection on 185.6 MB of results JSONs is **365 MB**, not 272 MB.
The direction favours the document's conclusion; the number quoted is 34% low
against the only pairs in the tree.

**Verdict: WEAKENS.** The judgement (make the store derived) survives and gets
stronger. The row's cost, benefit and input measurement are each wrong.

---

### B5 · A derived, gitignored store fails the portability standard the document opens with

**Claim attacked.** `:504-507`: "The one judgement call: **`.numbers` becomes
gitignored.** It is regenerable from a committed artifact by a committed tool,
the receipt carries what must survive". Against the document's own principle,
`:17-19`: "The prose stays plain markdown in a flat tree, **readable by any LLM
with no tooling**, because that is the load-bearing substrate
(`/Users/juliansambrano/GitHub/CLAUDE.md:275-277`)".

**What I did.** Asked what a fresh reader with the repo and no execution can
resolve.

**What I found.** `analysis/2026-09-01/results/weil_Lc_theory.numbers` has
**5,581** leaves. The receipt prototype for entry 302 carries **147** values
across three artifacts (`:325-327`). So under the design, an entry's cited
values stay readable and everything else in that store — well over 97% of it —
becomes unreadable without running `flatten.py` against a 178 KB JSON.

That is precisely the class of reader the portability rule protects. It is also
the class of reader that finds an *uncited* value: the Part One audit above
depended on reading `theory.k=30|eps=0.01.ratio_meas_over_theory`, a key no
entry cites, straight out of the flat file with `grep`. Under the design that
grep returns nothing on a fresh clone.

The document rejects MyST, Hugo and dbt on exactly this ground (`:244-246`: "an
LLM opening the raw file reads `{{ L_c }}` and learns nothing, which violates
`CLAUDE.md:275-277`") and then applies a weaker standard to the store, where
the values live. §8's honest-limits list has eight items and this is not one of
them.

**Verdict: WEAKENS.** The judgement is defensible on size grounds and the
document does not apply its own stated test to it.

---

### B6 · "Roughly one digit in nine" divides a key count by a token count that includes key digits

**Claim attacked.** `:96-98`: "Entry 302 holds 1301 numeric tokens. 142 are
verified. **Roughly one digit in nine.**"

**What I did.** Reproduced the token counts, then measured how many of them sit
inside backticked key-shaped tokens.

**What I found.** The token counts reproduce **exactly**:

```text
             outside fences   inside fences   (doc)
entry 300         727              344        727 | 344
entry 301         600              301        600 | 301
entry 302         792              509        792 | 509
entry 303         297               19        297 |  19
```

`check_entry_numbers.py --entry 302` returns `142 OK, 0 MISMATCH, 7 UNRESOLVED`
and `--entry 303` returns `0 OK, 0 MISMATCH, 14 UNRESOLVED`. Both exact.

The ratio is the problem. Of entry 302's 792 outside-fence tokens, **232 (29.3%)
are digits inside backticked key-shaped tokens** — the `10` and `0.01` in
`` `theory.k=10|eps=0.01.L_c_meas` ``. Those are not assertions a checker could
verify; they are the address. Removing them gives 1301 − 232 = 1069 assertable
tokens and 142/1069 = one in **7.5**.

Separately, 142 is a count of resolved **keys**, and the denominator is
**tokens**. The two are the same unit only if each key verifies exactly one
token, which the checker's "nearest number in the same sentence" rule makes
true per key and false in aggregate wherever a sentence carries a range or a
pair.

The "key-shaped tokens" column (300:46, 301:28, 302:166, 303:45) is the one
measurement in §1.3 whose method is not stated and which I could not reproduce;
my stricter definition gives 20, 19, 147, 13, and neither matches
`check_entry_numbers.py`'s own candidate counts (302: 142 + 7 = 149; 303: 14).

**Verdict: WEAKENS.** The conclusion — coverage is around 10% and most of the
digits are ungated — survives comfortably. The stated ratio is off by 20% and
one column is unreproducible.

---

### B7 · The `CONTEXT.md` and `papers/` counts are scoped in ways that understate the backlog

**Claim attacked.** `:445`: "`CONTEXT.md:255-709` carries **1061** numeric
tokens outside fences and **no gate touches one of them**." `:446`:
"`papers/*.md` carry **3335** numeric tokens outside fences across 15 files."

**What I did.** Counted both, at the stated scope and at the file/directory
scope.

**What I found.**

```text
CONTEXT.md:255-709 slice   outside fences 1061   (exact match)
CONTEXT.md whole file      outside fences 1436   inside 4
papers/*.md (15 files)     outside fences 3326   inside 511   (doc: 3335)
papers/ recursive          19 .md files (papers/literature/ holds 4 more)
```

The `CONTEXT.md` slice figure is exact and the file carries 375 more (26%)
outside it. Step 10 gates "`CONTEXT.md`", so the ratchet baseline will be set
from 1436 rather than 1061 and the row understates what it takes on.

`papers/` is 9 tokens off (3326 against 3335) — a method difference I could not
pin down, both in the same place. The scope matters more: `values.toml`'s
`prose = [... "papers/*.md"]` (`:601`) leaves the four files under
`papers/literature/` outside every gate the design adds, and the document does
not say so.

**Verdict: WEAKENS.** Both measurements are close and both are scoped narrower
than the gate they justify.

---

### B8 · `emit_table` is the one emitter with no contract, and it carries the coverage claim

**Claim attacked.** `:303-306`: "`emit_table` for a fixed-width `.txt` table,
keyed `<table>.<row>.<column>` — this is where 509 of entry 302's numbers live
and where none are checkable today". `:749`, step 6: "the 509 ungated numbers
per entry become gated; ~11% coverage rises past 90%".

**What I did.** Opened `analysis/2026-09-01/weil_Lc_theory.txt` and looked at
what a keyed projection would have to parse.

**What I found.** Lines 134-141 read:

```text
   k=1     theory p  -0.2557 (R2 0.9675)   measured p  -0.0631 (R2 0.9897)
   k=2     theory p  -0.1526 (R2 0.9891)   measured p  -0.0557 (R2 0.9985)
   ...
   k=300   theory p      nan (R2 nan)   measured p  -0.0743 (R2 0.9967)
```

There is no table name, no column header, and the columns are `theory p`,
`(R2 …)`, `measured p`, `(R2 …)` inline in prose. The bytes come from
`print()` calls inside `weil_Lc_theory.py`; nothing binds a parser to those
calls, and any change to a format string silently re-keys the table. The
document's own §1.2 notes the underlying hazard: three independent
re-formattings of the same number into `.json`, `.txt` and `.numbers`, and
"nothing checks those three against each other".

The document's better answer is already in the design and it does not choose
it: the `slice` generator (`:399-400`, "byte equality against those lines — the
cheapest form, no generator needed") needs no parse at all. The `table`
projector exists to solve the narrowing case entry 302 hit twice, and step 6's
"~11% to past 90%" is priced on the projector working across every `.txt` in
the tree.

**Verdict: WEAKENS.** The `slice` half of step 6 is sound and cheap and its
prototype output reproduces exactly (B10). The `table` half is priced as if it
were the same difficulty class.

---

### B9 · Migration ordering — one hidden dependency, one wrongly-labelled precondition

**Claim attacked.** `:735-740`: "Each row is a state that is green on its own
and committable on its own. Nothing requires rewriting an entry."

**What I did.** Walked the fourteen rows against what each needs and what each
blocks.

**What I found.**

*Nothing requires rewriting an entry.* True, and I checked it: step 2 keeps old
citations resolving via the backslash-stripping resolver, steps 5/10/11 are
baseline-ratcheted, step 4 generates receipts for 298–303 without touching
them. Confirmed.

*Step 5 hides a dependency on step 9.* Step 5 blocks at pre-commit "on entries
added in the staged diff". Baseline ratcheting protects the backlog and by
construction cannot protect a new entry. Step 9 backfills stores for the four
JSONs that have none (`weil_Lc_height_eps0.json`, `weil_QX.json`,
`weil_rung_min.json`, `zetazeros_2000.json` —
`container_audit_report.md:613-616`, verified). Between step 5 and step 9, a new
entry citing any of those four has no store, no receipt and a blocking gate.
Step 9 sits four rows later.

*Step 1 is not "the precondition for every step below".* `values.toml` replaces
three hardcoded globs (`check_numbers_in_response.py:77-86`, `pre-commit:85-87`,
`audit.yml:30-32` — all three verified present and in agreement today). Steps
2 through 12 each work against the current hardcoded values. Step 1 is
worthwhile and it is not load-bearing for anything below it.

*The step that makes the rest worthless if skipped is 4, not 1.* Without
`receipt.py` there is nothing for step 5, 10 or the whole of §3 to resolve
against; without `cite.py` a model still types the digits, which is the failure
the design exists to remove. Step 3 could be skipped entirely and every other
step still works.

*Step 2 is a precondition for step 4 as well as step 6.* The receipt format at
`:322` uses the escaped form
`weil_Lc_theory#theory.k=10|eps=0\.01.L_c_meas`. The document annotates step 2
as unblocking step 6 only.

**Verdict: WEAKENS.** The additive/no-rewrite property holds. One ordering
dependency is hidden and the precondition labelling points at the wrong row.

---

### B10 · What reproduces exactly

Reported so the reader can see what survived.

- **Key collision.** `theory` against `mod`: **47 shared keys, 33 differing**,
  with `params.L_grid[0]` at `mod: 0.3` / `theory: 0.02229612249207783` and
  `meta.timestamp` at `10:33:53` / `11:12:27`. Exact, including the direction
  of the `hits[0]` accident at `check_entry_numbers.py:184-188`.
- **The transclusion prototype.** Entry 302 has four fenced blocks (one of them
  a single line; three data tables, as stated). Converting the document's
  entry-relative offsets to file lines: `entry302:160`, `:243` and `:312` are
  the three tables, and only `:312` is a byte-exact contiguous slice of
  `analysis/2026-09-01/weil_Lc_theory.txt`, at lines **134-141**, 8 lines,
  `sha256[:12] = 35d5bd43d893`. Every digit of that line reproduces.
- **The store measurement.** `weil_Lc_theory.numbers` has **5,581** leaves,
  exact. My non-structural-dot count is 4,732 against the document's 4,113 —
  a method difference (the document's criterion is not stated), same direction,
  larger.
- **Run manifests.** 36 in `results/runs/`, newest `20260828T044059Z`. Exact.
- **`.numbers` and JSON counts.** 4 `.numbers` and 203 results JSONs at 16:24
  when the document was written; 5 and 204 now, because `arrow_price` landed at
  16:31–16:35. The document's numbers were right at write time.
- **`container_audit_report.md`.** All four cited ranges (`:583-586`,
  `:613-616`, `:618-619`, `:633-636`) say exactly what the document says they
  say.
- **All 17 `file:line` citations into `utilities/`, `notes/`, `.claude/` and
  `.github/`** verified: `flatten_results.py:8-19` and `:75-77`,
  `check_entry_numbers.py:79` and `:184-188`,
  `check_numbers_in_response.py:50`, `:56`, `:77-86`,
  `check_agent_brief.py:31` and `:70`, `check_read_range.py:29` (`LIMIT = 120`),
  `check_bash_guard.py:25-27`, `check_protected_write.py:90-91`,
  `gate.py:29`, `check_values.py:26-31` and `:44-52`,
  `notes_format.md:48-52`, `.claude/settings.json:17-27`, `pre-commit:85-87`
  and `:129-143`, `audit.yml:23-26` and `:28-37`. Exact.
- **Both arXiv citations are real and one is exact.** arXiv 2602.20683 is
  Grid-Mind (Shamseldein), and its abstract advertises "safeguards against
  numerical errors and a self-correction mechanism" — the document's gloss
  ("gate them on whether a grounding tool was actually called in that turn") is
  more specific than the abstract supports. arXiv 2606.00898 is "Citation
  Grounding Measures the Oracle" (Ovcharov), and its abstract states "all 54
  citations flagged by the sparse oracle name real articles, a 100%
  false-positive rate" — the document's caution ("an incomplete authority store
  manufactures false violations at a high rate") is exact. Both are cited by
  bare ID with no fetched URL, unlike every other item in §2, which marks them
  as the least-verified entries in that section; both held.

**Verdict: HOLDS**, across the board.

---

### B11 · The three flagged calls — opposite side argued, then my landing

The document flags three places where it makes a call rather than a
measurement. I take the other side of each as well as I can.

**(i) `.numbers` becomes derived and gitignored (`:504-509`).**

*Against.* A store that is not committed is not a record. The stated saving is
9.3 MB today (B4), which is 0.05% of the 186 MB of results JSONs the tree
already commits without complaint — the size argument is priced against a
counterfactual. Committing the store makes every value greppable on a fresh
clone, which is the property the portability rule protects (B5) and the
property my own Part One audit needed. Deriving it introduces a class of
failure the committed store cannot have: a regeneration that differs because
the tool changed, which the CI check catches only for artifacts still on disk,
and `.gitignore:10-12` already shows the tree pruning artifacts. It also
requires `git rm --cached` on tracked content, in a project whose CLAUDE.md
CANNOT list is built around not deleting run artifacts.

*I land on: derived, with one change.* The committed record should be the
receipt **plus** a committed, meta-stripped store digest per artifact, so a
fresh reader can tell that a regenerated store is the same store without
running anything. The size argument is weak; the "the store stops pretending to
be the record" argument (`:746`) is the real one and it stands on its own.

**(ii) `check_read_range.py` is "Wrong" — make it advisory or raise `LIMIT`
(`:538-544`).**

*Against.* `LIMIT = 120` (verified at `:29`) is a context-budget rule and
context budget is a correctness input, not a comfort. Every drift instance in
B1 was produced by an agent that had read too much and recalled instead of
opening; `Primebeat_081426/CLAUDE.md:65-68` names post-compaction recall as the
failure mode, and compaction is what unbounded reads cause. The document's
evidence is a single incident in which the hook denied a brief's explicit "read
in full" instruction, and it reports the cost (two ranged reads and a stitch)
without reporting a resulting error. A hook that forces an agent to say which
120 lines it needs is doing the same work `AGENT_CARD.md` does by pointing at
line ranges.

*I land on: honour an explicit brief instruction, keep the limit otherwise.*
The document's own remedy list already contains this option and buries it
behind "make it advisory". A brief-scoped override is narrower, keeps the
budget for unbriefed reads, and removes the one measured harm.

**(iii) `check_response_prefix.py` is a compliance probe, out of scope
(`:545-546`).**

*Against.* The Stop hook is the only mechanism in the inventory that acts on
the **report** hop, and §7 assigns the report half of the two-block contract to
exactly that hook (`:695-696`: "The Stop hook enforces the report half"). A
document that assigns work to a hook in §7 and calls that hook out of scope in
§5 has not decided. Hop 1 (JSON → agent report) is one of the two hops the
document says carries the measured drift, and it is the hop with the fewest
mechanisms proposed.

*I land on: it is in scope, and the document is right that it is not a data
gate.* The resolution is to say which hook enforces the `## Values` block. If
it is `check_response_prefix.py`, §5's "Wrong" row is wrong. If it is a new
hook, §5's "New" table should carry it. Today neither is true.

---

### B12 · The hardest question — does this design fix the failure that actually happened?

**What I did.** Took every recorded drift instance in entries 298–304 and the
2026-09-01/02 git log, classified each, and asked which mechanism in the design
catches it.

**The corpus, classified, with the design's mechanism.**

*Caught by a generated `## Inputs` / `## Values` block (21 of 41 brief errors):*

- (a) wrong line/path, 10 instances — e.g. entry 301 `notes/lab_notebook_2.md:836`
  "`eig_pencil`, lines 388-410; the brief cited 361", entry 298 `:1604` "the
  brief had it beside the script". **Caught, for citations into stable files
  only.** Not caught for citations into the notebook (B3).
- (b) wrong digit, 4 — entry 301 `:904` "3.7697 (brief 3.7699)"; entry 299
  `:1357` "831 lines — the brief said 813"; entry 298 `:1543` "6.5 at X = 10 —
  the arithmetic gives 10.4". **Caught**, by `cite.py`.
- (c) wrong count, 4 — entry 301 `:915` "the brief said 48 × 28"; entry 303
  "five blocking sorries" against four. **Caught** where the count is a key;
  the sorry count is not a key today and step 9's `emit_lean` would make it one.
- (d) wrong duration, 3 — entry 301 `:867` "52.3 s (`log:49`; the brief said
  52.7)"; entry 299 `:1370` "1 min 19 s (the brief said 1 min 20 s)". **Caught**,
  `meta.timings.*` is already a key.

*Not caught (19 of 41):*

- (f) right number, wrong row/column/endpoint, 8 — entry 301 `:905-907` (two
  `w = 1` values quoted for `w = 1/2` rows); entry 300 `:1289` "the brief said
  1e-21, which is the k = 10 ε = 0.01 value"; entry 299 `:1278` "the brief's
  1.8e-43 is the second-largest four-point diff"; entry 298 `:1507` "the brief's
  '≈ −1.56·L + 0.02' is the X = 100 ratio and does not fit the ladder".
  **Not caught.** Every one of these is a true value of a real key attached to
  the wrong noun. §8.2 admits it. It is the second-largest class.
- (e) qualitative claim in words, 11 — entry 300 `:1160` "the brief said all
  eight identical"; `:1219` "the brief said identical throughout"; `:1287` "the
  brief said four to six" orders; entry 298 `:1513` "the brief said the
  1.54–1.62 band starts at X = 9"; entry 299 `:1489` "identical for every
  ε ≥ 0.02". **Not caught.** §8.4 admits it and puts it at four instances; it
  is eleven.

*Drift with no brief involved:*

- **Entry 300's "linear in γ_k" and its 1e-25 price**, corrected by entry 301
  (`notes/lab_notebook_2.md:1027-1038` in the current frame). A correct number
  from a run whose Legendre basis could not represent a modulation at γ_k ≥ 101.
  Every gate in the design passes it. §8.1 names this. **Not caught, admitted.**
- **The 299 → 300 → 301 reversal.** Entry 299 read the height cost as
  `c·log γ_k`; entry 300 "corrected" it to linear; entry 301 restored 299 and
  identified 300's correction as a basis artefact. Entry 300's title and
  correction paragraph both stand uncorrected in place, which the append-only
  rule requires. **No mechanism in the design, and none named in §8.** A reader
  arriving at entry 300 alone — or at its NOTEPAD line — inherits two withdrawn
  claims. This is a real gap the document does not list among its eight.
- **The M96 supplement.** `weil_Lc_height_M96.log` was committed at 0 bytes by
  `c5adbb1`; a `tee` truncated it and the crash traceback survives only in the
  agent's report quoted into entry 300. **Partly addressed** by step 11 (run
  manifests + environment capture): the manifest would record the invocation
  and the empty output. The truncation itself is not prevented.
- **`xcheck_k1` in the scratchpad, in no tree file** (entry 301). §8.3 names
  this class. Resolved out of band by `f9ca7c1`/`628d393`, which filed the
  scratch scripts. **Not caught by design; caught by Julian's instruction.**
- **Entry 303's stale self-citations.** **Not caught, and not named.** B3.
- **The 20-minute run mispriced as its 52-second unit-test time**
  (`container_audit_report.md:618-619`). **Caught** — it is `meta.timings.*`
  against `meta.timings.*`.

**The answer.** The design fixes the failure that happened at roughly half the
rate it claims. It fixes the mechanical half — line refs into stable files,
digits, counts, durations — completely and cheaply, and that half is real: 21
of 41. The half it does not fix is not a residue. It is (e) + (f) = 19 of 41,
and every one of those is a **model reading a real number off the wrong row of
a real file and generalising it into a sentence**. The design's own diagnosis
names this at `:451-452` — "prose asserts relations, blocks carry values" — and
the measured corpus says the drift lives in the relations, not the values.

Two failures in the corpus are neither: the entry 300 basis artefact (a wrong
measurement, correctly recorded) and the 299 → 300 → 301 reversal (a correction
that was itself wrong). The design says the first is out of reach and is silent
on the second.

**Verdict: WEAKENS.** The design solves a real, measured, mechanical problem.
It is priced as if that problem were 83% of the drift, and it is 51%.

---

## Part Two — count and bottom line

**BREAKS 3 · WEAKENS 7 · HOLDS 2.**

BREAKS: B1, B2, B3.
WEAKENS: B4, B5, B6, B7, B8, B9, B12.
HOLDS: B10 (every `file:line`, the key-collision measurement, the transclusion
prototype including its sha, the four entry token counts, the two checker
outputs, the manifest count, the leaf count, both arXiv citations), and B11's
finding that the additive/no-entry-rewrite property of the migration is real.

**Does the bottom line stand?** Partly, and the parts separate cleanly.

**The architecture stands.** Check-in-place over render-in-place is right and
the document's reason is right: a placeholder in a raw file violates
`CLAUDE.md:275-277`. cog's three markers plus a checksum is the correct
borrowing, and the `slice` form is byte-exact, needs no parser, and its
prototype reproduced to the sha in my hands. The flat `key<TAB>value` shape is
right and the three named defects (unqualified keys, JSON-only, committed at
full size) are real; the key collision is live and measured at 47/33. Making
the receipt the committed binding is the right unit — it survives artifact
pruning, it kills the collision, and it is small. `cite.py` is the single
highest-value item in the design and it is barely argued for; it removes the
typing, which is the mechanism, and everything else is verification of typing
that should not happen.

**Three things must change before the migration is run.**

1. The receipt must bind to a **meta-stripped** artifact digest, not
   `sha256(bytes)`, or the CI gate blocks on every re-run (B2). The tree's own
   flattener documents the primitive.
2. The design must carry an invariant for notebook self-citation, or a
   convention that forbids it (B3). It is the highest-base-rate mechanical
   failure in this tree, it is live and uncorrected in entry 303, it recurred
   in the sibling document during this audit, and `values.toml` already records
   the property that causes it.
3. Step 7's budget must be recomputed on the full corpus (B1). It buys 51%,
   not 83%, and the residue is concentrated where §8 says no mechanism exists.
   Step 7 still earns its day.

**What would still break the architecture.** A measurement showing that (e) and
(f) drift — a real value from the wrong row, generalised into words — falls
when a `## Inputs` block is present. I predict it rises, because a block that
prints thirty resolved values makes picking the wrong one easier, and entry
301's two `w = 1` substitutions are exactly that error made against a source
that was open. That measurement is cheap: run step 7 on one spawn, and count
the in-entry corrections in the resulting entry against the six-entry baseline
of 41.

---

*Prepared as an adversarial read. Nothing in this tree was modified. No commit
was made. Scratch scripts live outside `~/GitHub/`.*
