# Literature search — the hinge identity of `Euler-Factor-Chain.md`

Scope: priority check on (a) the symbol identity `Δ x^ρ = (1 − b^(−ρ)) x^ρ` read as the
reciprocal Euler factor; (b) the Weil explicit-formula weight `|ĝ(ρ)|²`; (c) the
identification of (a) with (b). No code written, no project file modified.

---

## Verdict on (a) the symbol identity: **KNOWN**

The identity is in the literature, in exactly the operator form the chain uses, and it is
*named* as the Euler factor. The primary hit is Herichi–Lapidus.

**Herichi & Lapidus, "Truncated Infinitesimal Shifts, Spectral Operators and Quantized
Universality of the Riemann Zeta Function", Ann. Fac. Sci. Toulouse Math. (6) 23 (2014),
no. 3, 621–664; arXiv:1305.3933.** §3.2, Eq. (3.2.8), quoted verbatim from the ar5iv
rendering:

> For all primes `p`, the operator-valued prime factors are given by
> `𝔞_p(f)(t) = Σ_{m=0}^∞ f(t − m log p) = Σ_{m=0}^∞ e^{−m(log p)∂}(f)(t) = Σ_{m=0}^∞ (p^{−∂})^m (f)(t)`
> `= (1/(1 − p^{−∂}))(f)(t) = (1 − p^{−∂})^{−1}(f)(t) = ζ_{𝔥_p}(∂)(t),`   (3.2.8)
>
> and hence, the operator-valued Euler product of the spectral operator `𝔞` is given by
> `𝔞 = Π_{p∈𝒫}(1 − p^{−∂})^{−1}(f)(t).`   (3.2.9)

with, immediately above, Eq. (3.2.6):

> `f(t + h) = e^{h d/dt}(f)(t) = e^{h∂}(f)(t)`,  where `∂ = d/dt` is the infinitesimal
> shift of the real line

and §3.2, Eq. (3.2.4):

> For each prime `p ∈ 𝒫`, the operator-valued Euler factors `𝔞_p` are given by
> `f(t) ↦ 𝔞_p(f)(t) = Σ_{m=0}^∞ f(t − m log p)`.

The variable is `t = log x` (their own change of variable, §3.2: "Using the change of
variable `x = e^t`"). So `p^{−∂} = e^{−(log p)∂}` is precisely translation by `log p`,
i.e. the multiplicative shift `x ↦ x/p` — the shift along the `p`-ladder. Therefore
`1 − p^{−∂}` **is** the backward difference operator on the `p`-adic ladder, and Herichi
and Lapidus call it, in so many words, the (reciprocal of the) operator-valued Euler
factor at `p`.

The symbol claim is also made rigorous there, not just formally. Same paper, §4:

> The spectrum, `σ(∂)`, of the differentiation operator (or infinitesimal shift)
> `∂ = ∂_c` is equal to the closed vertical line of the complex plane passing through
> `c ≥ 0`; … `σ(∂) = σ_e(∂) = {λ ∈ ℂ : Re(λ) = c}`

so by the functional calculus `1 − p^{−∂}` has symbol `1 − p^{−s}` on the line
`Re(s) = c`. That is chain nodes **A1 + A3** verbatim.

Corroborating statement of the same equation in the earlier, journal-published paper:
**Herichi & Lapidus, "Riemann zeroes and phase transitions via the spectral operator on
fractal strings", J. Phys. A: Math. Theor. 45 (2012) 374005, doi:10.1088/1751-8113/45/37/374005;
arXiv:1203.4828**, Remark 3.14 / Eq. (3.8):

> `𝔞 = ζ(∂) = Π_{p∈𝒫}(1 − p^{−∂})^{−1}`,   (3.8)

and Eq. (3.10), which is the *product over all primes* of the difference operators:

> `𝔞^{−1} = (1/ζ)(∂) = Σ_{n=1}^∞ μ(n) n^{−∂}`   (3.10)

i.e. `Π_p (1 − p^{−∂}) = Σ_n μ(n) n^{−∂}` has symbol `1/ζ(s)`. The chain's A3 is one
factor of this.

Lineage: both papers attribute the spectral operator to **Lapidus & van Frankenhuijsen,
*Fractal Geometry, Complex Dimensions and Zeta Functions: Geometry and Spectra of Fractal
Strings*, Springer Monographs in Mathematics, §6.3.2** (2nd ed. 2013, Zbl 1261.28011),
where the Euler product for `ζ(∂)` inside the critical strip is stated as a conjecture.

**How it differs from the chain, if at all.** Two small gaps, neither of which rescues
novelty for A1/A3:

1. Herichi–Lapidus state it for *prime* `p`. The chain uses an arbitrary integer base
   `b ≥ 2`. For composite `b` (the chain's `b = 4, 6, 8, 9` in D7/D8) `1 − b^{−s}` is not
   an Euler factor of `ζ` — the algebra of A1 survives, the Euler reading does not.
2. They write the *geometric sum* (the Euler factor) and give the difference operator as
   its inverse; the chain writes the difference operator and calls it the reciprocal
   Euler factor. Same identity, opposite direction of exposition.

**A4** (`d`-fold differencing has symbol `(1 − b^{−s})^{d+1}`) is an immediate power of
the same functional calculus and needs no separate citation.

Independently, the *general* form of the symbol statement — without the Euler reading —
is textbook Mellin asymptotics. **Flajolet, Gourdon & Dumas, "Mellin transforms and
asymptotics: Harmonic sums", Theoret. Comput. Sci. 144 (1995) 3–58**, §1, Eq. (6), quoted
from the PDF at `specfun.inria.fr/dumas/Publications/FlGoDu95.pdf`:

> a direct change of variables, the Mellin transform of `g(μx)` is `μ^{−s}` times the
> transform `g*(s)` of `g(x)`. Thus, by linearity, the Mellin transform of a general
> harmonic sum is (conditionally) `G*(s) = Λ(s)·g*(s)`,  (6)  where `Λ(s) = Σ λ_k μ_k^{−s}` …
> It therefore factors as the product of the transform of the base function and of a
> generalized Dirichlet series: Mellin transforms applied to harmonic sums "separate" the
> amplitude–frequency pair from the base function.

Take `λ = (1, −1)`, `μ = (1, b)`: `Λ(s) = 1 − b^{−s}`. This is A1 in full generality, 1995,
in a source with no number-theoretic ambition at all. Its being called a *generalized
Dirichlet series* rather than an Euler factor is the whole distance between it and A3.

---

## Verdict on (b) the Weil-weight identification: **KNOWN — it is Weil's criterion itself**

The claim that the explicit formula assigns weight `h(ρ) = ĝ(ρ)·ĝ(1−ρ) = |ĝ(ρ)|²` (on
`Re ρ = 1/2`) to each zero, for a test function of the autocorrelation form `g * g*`, is
not adjacent to Weil's positivity criterion — it *is* Weil's positivity criterion. Chain
nodes B1–B4 are the standard construction of that functional.

Primary source: **A. Weil, "Sur les 'formules explicites' de la théorie des nombres
premiers", Comm. Sém. Math. Univ. Lund (1952), 252–265** (cited by every source below;
I could not obtain the original text online — see "What I could not check").

Modern statement, quoted verbatim from **Connes, "The Riemann Hypothesis: Past, Present
and a Letter Through Time", arXiv:2602.04022, §4.1** (already in the project's
`REFERENCES.md`):

> The key result of André Weil is the equivalence
> `RH ⟺ Σ_v W_v(g * g^*) ≤ 0,  ∀g,  ĝ(±i/2) = 0`
> where `g ∈ C_c^∞(ℝ_+^*)` is smooth with compact support and `g^*(x) := ḡ(x^{−1})`.

with the explicit formula stated just above it in the same section as

> `f̂(i/2) − Σ_{1/2+is ∈ Z} f̂(s) + f̂(−i/2) = Σ_v W_v(f)`,   `f̂(s) := ∫_0^∞ f(x) x^{−is} d*x`

so the spectral side is literally `Σ_ρ f̂` evaluated at the zeros — the "weight on the
zero" is by construction the value of the transform there.

The `|ĝ|²` step is stated in **Connes & Consani, "Weil positivity and trace formula, the
archimedean place", Selecta Math. 27 (2021), art. 77; arXiv:2006.13771**, §5 (in the
lemma establishing when `f` factors as `g * g^*`):

> One has `f̂(t) = |ĝ(t)|²`, and since `f ∈ C_c^∞(ℝ)`, one gets `f̂(t) = O(|t|^{−N})` for
> any `N`.

and the quadratic form itself is defined there at Eq. (2) as `QW(g) := W_∞(g * g^*)`.

Third confirmation, with the "quadratic form in infinitely many variables" reading that
is closest to what the chain does with a finite stencil: **E. Bombieri, "Remarks on Weil's
quadratic functional in the theory of prime numbers, I", Atti Accad. Naz. Lincei Cl. Sci.
Fis. Mat. Natur. Rend. Lincei (9) Mat. Appl. 11 (2000), no. 3, 183–233** (Zbl 1008.11034;
EuDML record https://eudml.org/doc/252338). From the EuDML abstract:

> This work examines Weil's Explicit Formula in prime number theory and its associated
> quadratic functional, which demonstrates positive semidefiniteness precisely when the
> Riemann Hypothesis holds. … Fourier transformation of the functional generates a
> quadratic form in infinitely many variables; the study proceeds to analyze its finite
> truncations and corresponding eigenvalues.

**How it differs from the chain.** B2 (`h(s) = h(1−s)`, `h ≥ 0` on the critical line) is
the functional-equation symmetry every `g * g^*` has; B3 is Weil 1952; B4 is
`ĝ(1−ρ) = conj(ĝ(ρ))` on `Re ρ = 1/2`, one line of algebra. Nothing in B1–B4 departs from
the 1952 construction. One point where the chain's normalisation is *weaker* than the
standard one and worth flagging: Weil's criterion carries the side condition
`ĝ(±i/2) = 0`, i.e. `ĝ` must kill *both* pole terms; the chain's `ĝ(s) = (1 − b^{−s})^N`
vanishes at `s = 0` but not at `s = 1` (there it is `(1 − 1/b)^N ≠ 0`). The chain's B2
records `h(0) = h(1) = 0` for the symmetrised `h(s) = ĝ(s)ĝ(1−s)`, which is true, but that
is not the same as satisfying Weil's condition on `g`.

Also standard, and equal to the chain's **B7**: Connes, arXiv:2602.04022 §4.1, immediately
after the criterion —

> The key point of this equivalence is that the sum on the right-hand side, when evaluated
> on a test function `g` with compact support, involves only finitely many primes (since
> `W_p` vanishes on functions with support in `(p^{−1}, p)`).

The chain's observation that a stencil supported on `{b^n}` sees only `p = b` is the same
statement about the support of `W_p` (which is carried on `{p^{±m}}`, per Connes' Eq. (10):
`W_p(f) := (log p) Σ_{m≥1} p^{−m/2}[f(p^m) + f(p^{−m})]`). The inadmissibility of a purely
atomic stencil, and hence the need for the mollifier, follows from the same equation and
from Weil's class being `C_c^∞`.

---

## Verdict on the identification of (a) with (b) — chain node **B5**: **NOT FOUND**

I found no source that composes the two: no paper, preprint, book chapter or survey in
which a Weil-class test function is taken with Mellin transform `(1 − b^{−s})^N` — i.e.
supported on the geometric ladder `{1, b, …, b^N}` with binomial weights — and the
resulting per-zero weight `|1 − b^{−ρ}|^{2N}` is identified with the gain of iterated
differencing along that ladder.

This is a **negative from search, not a proof of novelty.** Both halves are standard and
the composition is roughly two lines. The chain's own J3 ("Each is one line from standard
facts, which is the profile of folklore") remains the right description of the risk. What
the search establishes is narrower and worth stating exactly: *the composed statement does
not appear in the sources reachable by the searches recorded below.*

Two specific structural reasons the composition seems not to have been made:

1. The two literatures are disjoint. Herichi–Lapidus contain (a) in exactly the right
   form; the word "Weil" occurs **once** in arXiv:1305.3933, and only in a
   bibliography entry for a paper in preparation ("Quantized Weil conjectures, spectral
   operator and Polya–Hilbert operators (tentative title)"). The Weil-positivity
   literature (Weil, Yoshida, Bombieri, Connes, Connes–Consani, Suzuki) does not use the
   `p^{−∂}` shift-operator formalism at all.
2. The Weil-positivity literature parametrises test functions by the **length of their
   support** `L = 2 log λ`, not by a lattice inside the support. Connes' §6.4, the
   Connes–van Suijlekom truncation, and every follow-on (arXiv:2605.20224, 2606.09096,
   2607.02828) index by the cutoff `λ`/`c` and a frequency band `N`. A lattice-supported
   comb is not a natural object in that parametrisation.

---

## Closest matches found

### 1. Connes & Consani, ζ-cycles — closest to the chain's **D-block**, not to B5

**A. Connes & C. Consani, "Spectral triples and ζ-cycles", Enseign. Math. (2) 69 (2023),
no. 1–2, 93–148; arXiv:2106.01715.** Theorem 6.4(ii), quoted from ar5iv:

> (ii) Let `s > 0` be such that `ζ(1/2 + is) = 0`, then any real circle `C` of length an
> integral multiple of `2π/s` is a zeta cycle and its spectrum, for the action of `ℝ_+^*`
> on `Σ_μ ℰ(𝒮_0^ev) ⊂ L²(C)`, contains `is`.

and, from §1:

> the special values of the length (`L`) of the circle for which the coinciding
> `λ_n(D(λ,k))` occur, form a part of the arithmetic progression of multiples of
> `2π/ζ_n`, where `ζ_n` is the imaginary part of the `n`-th zero of the zeta function.

**How it differs.** The condition `sL ∈ 2πZ` with `L = log μ` is exactly the chain's **D1
floor** condition `γ log b ≡ 0 (mod 2π)`, and the ladder bases satisfying it are
`b = exp(2πk/γ)`. The chain's **D4** picks the complementary family
`b = exp(π(2k+1)/γ)` — the *anti*-cycles, where `b^{−ρ}` is real negative and the
difference gain is maximal. So Connes–Consani have already singled out the same
one-parameter family of scales, from the spectral side; the chain approaches the same
lattice from the difference-gain side and takes the half-period-shifted members. If D4 is
to be claimed as new, this is the paper to reckon with. (Note also §5.2 there: "The
special values of `μ` at which the graphs meet appear to form a geometric progression …
the ratio of consecutive terms is `∼ exp(2π/ζ_1)`.")

### 2. Connes & Consani, the Weil form on a multiplicative-circle character basis

Same paper, §2. They expand `QW_λ` on the basis generated by `U(u) := u^{iπ/log λ}`:

> Let `λ > 1`, and `U ∈ L²([λ^{−1}, λ], d*u)` be the function `U(u) := u^{iπ/log λ}`.
> Then the space of Laurent polynomials `ℂ[U, U^{−1}]` is a core for the quadratic form
> `QW_λ`.

with `Û^n(s) = 2 log λ (−1)^n sin(s log λ)(πn − s log λ)^{−1}`, and
`σ(n,m) = QW(η_n, η_m)` "expressed as a finite sum involving the archimedean contribution
`−W_ℝ`, as well as the contribution `−W_p` from primes `p` less than `μ = λ²`."

**How it differs.** This is the Weil form written in a basis adapted to a *lattice* — but
the lattice is the frequency lattice `πn/log λ` dual to the support interval, and the
basis functions are spread over `[λ^{−1}, λ]`. The chain's stencil is a lattice in the
*support* variable: atoms at `b^k`. The resulting weight is `|sin|`-shaped in
Connes–Consani and `|1 − b^{−ρ}|^{2N}`-shaped in the chain. Different objects.

### 3. Flajolet, Gourdon & Dumas — the symbol identity with no Euler reading

Cited above. `Λ(s) = Σ λ_k μ_k^{−s}` for the geometric frequency family `μ_k = b^k` is
`1/(1 − b^{−s})`. Differs from A3 only in never calling it an Euler factor. The companion
paper **Flajolet, Grabner, Kirschenhofer, Prodinger & Tichy, "Mellin transforms and
asymptotics: digital sums", Theoret. Comput. Sci. 123 (1994) 291–314** carries `(1 − 2^{−s})`
factors throughout and the `2πik/log 2` pole lattice, again with no Euler-factor reading —
I grepped the Inria PDF and "Euler" appears there only as "Euler transformation of series"
and "Euler–Maclaurin", never as "Euler factor".

### 4. Flajolet & Sedgewick, Nörlund–Rice — **not** the same operator

**Flajolet & Sedgewick, "Mellin transforms and asymptotics: finite differences and Rice's
integrals", Theoret. Comput. Sci. 144 (1995) 101–124 (Zbl 0869.68056).** I downloaded and
grepped the full text (`algo.inria.fr/flajolet/Publications/FlSe95.pdf`). "Euler" occurs
only as "the Euler transformation" of series (an involution on alternating sums) — a
different Euler object. The Rice/Nörlund machinery differences along an **arithmetic**
ladder in the index (`Σ_k (−1)^k C(n,k) f(k)`), not a geometric ladder in the argument. The
brief flagged this as a candidate; it is **not** a match, and the distinction is worth
recording: Rice's integral converts arithmetic-index differences into Mellin integrals with
Beta-function kernels, whereas the chain's `Δ` on `b^r` produces the multiplier
`1 − b^{−s}` directly by the harmonic-sum separation rule.

### 5. Muñoz & Pérez-Marco, Poisson–Newton — same elementary building block, different use

**V. Muñoz & R. Pérez-Marco, "Unified treatment of explicit and trace formulas via
Poisson–Newton formula", arXiv:1309.1449.** From §1:

> This distributional formula is related to the simplest finite Dirichlet series
> `f(s) = 1 − e^{−λs}`.

With `λ = log b` this is the chain's symbol. Their use of it is the classical Poisson
summation formula on the lattice `λZ`, not a difference operator and not an Euler factor;
the word "Euler factor" does not occur in the paper (only the Euler product itself, once,
at Theorem 7.1). This bears on the chain's **H-block** (aliasing, spacing `2π/log b`)
rather than on A3 or B5.

### 6. Deninger — the "primes as closed orbits" dictionary

**C. Deninger, "On the nature of the 'explicit formulas' in analytic number theory — a
simple example", arXiv:math/0204194.** Sets up `ζ̂_F(s) = Π_w (1 − Nw^{−s})^{−1}` with the
pole lattice `2πiν/log q` and interprets the explicit formula as a transversal index
theorem. Relevant as background for the "local factor ↔ closed orbit of length `log Nw`"
reading that makes A3 unsurprising; it does not state the difference-operator symbol.

---

## Search record

Services used: arXiv API (`export.arxiv.org/api/query`, metadata: title/abstract/comments),
zbMATH Open (`zbmath.org`, full bibliographic + review text), Crossref API, a
Google/Bing-backed general web search, ar5iv HTML renderings of specific arXiv papers, and
direct PDF download + `pdftotext` grep for Flajolet-school papers.

**arXiv API — queries and counts**

| query | total |
|---|---|
| `all:"Euler factor" AND all:"difference operator"` | **0** |
| `all:"Euler factor" AND all:"shift operator"` | **0** |
| `all:"operator-valued Euler product"` | **0** (metadata only; the phrase is in the bodies of 1203.4828 / 1305.3933) |
| `abs:"explicit formula" AND abs:"test function" AND abs:"lattice"` | **0** |
| `all:"difference operator" AND all:"Riemann zeta"` | 4 — none relevant (Goss zeta, Wallis, resolvent, probabilistic renormalization) |
| `abs:"Weil explicit formula"` | 22 — full list reviewed; none lattice-supported |
| `all:"Weil positivity"` | 11 — full list reviewed (2006.13771, 2607.24830, 2607.02828, 2206.03682, math/0101068, 1501.00704, math/9809119, 1910.14368, 2112.05500, 2112.08820, 2408.15135) |
| `all:"truncated Weil quadratic form"` | 2 (2607.02828, 2605.20224) — abstracts read, both index by cutoff `c` and band `N`, no lattice support |
| `all:"infinitesimal shift" AND all:"spectral operator"` | 2 (1305.3933, 1501.05362) — the (a) hits |
| `all:"quantized number theory"` | 3 |
| `all:Deninger AND all:"explicit formulas"` | 7 |

**zbMATH Open — queries and outcomes**

| query | outcome |
|---|---|
| `"Euler factor" & "finite difference"` | **No documents found** |
| `"Euler factor" & "shift operator"` | **No documents found** |
| `"Euler factor" & "translation operator"` | **No documents found** |
| `ti:"Euler factor" & "operator"` | **No documents found** |
| `"symbol" & "Euler factor" & "operator" & zeta` | **No documents found** |
| `"multiplicative shift" & "Euler product"` | **No documents found** |
| `"difference operator" & "Euler product"` | 1 hit — Bohr–Mollerup tutorial, irrelevant |
| `"explicit formula" & "difference operator" & prime` | **No documents found** |
| `"explicit formula" & "geometric progression" & zeta` | **No documents found** |
| `"Weil" & "explicit formula" & "lattice" & "test function"` | **No documents found** |
| `"explicit formula" & "test function" & "prime powers of a single"` | **No documents found** |
| `"Weil" & "quadratic form" & "Dirichlet polynomial"` | **No documents found** |
| `"Mellin" & "difference operator" & "Dirichlet series"` | **No documents found** |
| `"Weil quadratic form"` | 13 hits, all reviewed — Connes/Connes–Consani circle and 2026 preprints only |
| `"Weil functional" & prime` | 2 hits — Bombieri 2000; a Barner–Weil variation paper |
| `"Weil distribution"` | ~9 hits — Suzuki, Connes, Lapidus-ed. volume; none lattice-supported |
| `"Guinand-Weil" & "test function"` | 1 hit (2607.02828) |
| `"zeta cycle" \| "zeta-cycles"` | 4 hits — the Connes–Consani circle |
| `"backward difference" & zeta` | 5 hits, all numerical-analysis / sequence-space, irrelevant |
| `"Rice" & "finite differences" & "Mellin"` | 2 hits — Flajolet–Sedgewick 1995 and a Flajolet obituary survey |
| `"self-similar" & "explicit formula" & "complex dimensions"` | 4 hits — the Lapidus–van Frankenhuijsen circle |

**Full-text greps performed**

- `FlSe95.pdf` (Rice's integrals): "Euler" → only "Euler transformation"/"Euler–Maclaurin". No Euler-factor reading. **Negative.**
- `FlGrKiPrTi94.pdf` (digital sums): `(1 − 2^{−s})` factors present; "Euler" → not as a factor. **Negative.**
- `ar5iv 1305.3933` and `ar5iv 1203.4828`: `grep -i weil` → 1 occurrence total, in a
  bibliography entry for an unpublished tentative title. **Negative on the composition.**
- `ar5iv 1309.1449` (Poisson–Newton): "Euler factor" → 0 occurrences; "Euler product" → 1.
- `ar5iv 2006.13771`, `2602.04022`, `2106.01715`: read for the (b) quotes above; grepped
  for lattice-supported / atomic test functions → nothing.

**Web searches that came back empty on the composition** (all returned only generic
explicit-formula material): "finite difference operator Euler factor zeta geometric
progression"; "Mellin transform dilation operator symbol 1−p^{−s} Euler product Möbius
sieve"; "Weil quadratic functional test function supported on powers of a single prime";
"explicit formula quadratic form Dirichlet polynomial sum over zeros |D(ρ)|²";
"Weil explicit formula Dirac comb test function geometric lattice powers of 2";
"ψ(x) − ψ(x/2) explicit formula factor 1 − 2^{−ρ}"; "iterated differences of prime counting
function along powers of 2 amplify zeta zeros"; "explicit formula test function Mellin
transform (1 − b^{−s}) polynomial in b^{−s} zeros weight Weil form".

---

## What I could not check

- **MathSciNet.** Paywalled; not reachable from this environment. zbMATH Open was used as
  the substitute and covers essentially the same corpus, but the review texts differ.
- **Google Scholar.** Not reachable through the available tools. Citation-following in
  both directions was therefore done by hand off arXiv/zbMATH reference lists, not
  systematically.
- **arXiv full-text search.** The arXiv API indexes metadata only (title/abstract/comments).
  A statement buried in the body of a paper whose abstract does not mention it would not
  surface. I partially compensated by downloading and grepping the bodies of the ten most
  likely candidates, but this is the main residual risk on the (c) negative — and it is a
  real one, precisely because the composition, if anyone made it, would most likely appear
  as a passing remark rather than a titled result.
- **Bombieri 2000, full text.** I obtained only the EuDML bibliographic record and abstract;
  `bdim.eu` and EuDML both failed to serve a PDF. The paper's §on "a quadratic form in
  infinitely many variables" is the single most likely place in the classical literature
  for a lattice specialisation to appear, and I could not read it. **This is the largest
  single gap in the (c) negative.**
- **Weil 1952 original** (Comm. Sém. Math. Univ. Lund) — not available online; taken on the
  authority of the modern sources that restate it.
- **Books.** Lapidus & van Frankenhuijsen, *Fractal Geometry, Complex Dimensions and Zeta
  Functions* (§6.3.2 and Ch. 5, the explicit formulas for generalized fractal strings), and
  Herichi & Lapidus, *Quantized Number Theory, Fractal Strings and the Riemann Hypothesis*
  (World Scientific 2018) — neither is accessible. §6.3.2 is where the spectral operator and
  its Euler product originate, and Ch. 5 is where the same authors state a generalized
  Riemann–Weil explicit formula. **If the composition (c) exists anywhere, that book is the
  most likely single volume**, because it is the one place where both halves already sit
  between the same covers. I could not read it.
- **Yoshida 1992** ("A remark on the Weil quadratic functional", or the paper Connes cites
  as [111] proving `W_∞(f) ≥ 0` for `supp f ⊂ (1/2, 2)`) — not retrieved.
- **Terminology I suspect exists but could not name.** If the composition has been made,
  plausible unretrieved vocabularies are: "Weil positivity for Beurling systems with a
  single generator"; "explicit formula for lattice self-similar strings"; anything phrasing
  a `b`-adic comb as a "Dirac comb / crystalline measure" test function in the explicit
  formula. My searches on the first two returned nothing; I did not find a working query
  for the third.
