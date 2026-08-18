# Literature search — transform radius, Jentzsch, annulus modulus

Scope: citation hunt for the three claims underlying `O39_transform_radius.py`,
`results/transform_radius.json`, and `lean/Crossover.lean`. Literature only. No
code written, no experiment run, no project file modified.

Working hypothesis given in the brief (Julian's own): "very likely already
known — the classical abscissa-of-convergence criterion restated in
conformal/geometric language." **That hypothesis is confirmed for Pieces 1 and
2 and is not confirmed for Piece 3.**

---

## Piece 1 — the RH ⟺ maximal-modulus equivalence

**Verdict: KNOWN, and known in two separable layers. The specific packaging
(dyadic difference table → z-transform → root radius) is NOT FOUND verbatim,
but it is a mechanical composition of two textbook facts, not a new
equivalence.**

### Layer 1a — the geometric correspondence itself (KNOWN, canonical, exact)

The map `z = b^(−s)` is not an analogy in this setting; it is an identity. A
series supported on powers of `b` is a *general Dirichlet series* with
`λ_r = r·log b`, and general Dirichlet series with `λ_n = n` **are** power
series under `z = e^(−s)`.

Canonical reference:

> Hardy, G. H. and Riesz, M.: *The General Theory of Dirichlet's Series.*
> Cambridge Tracts in Mathematics 18, Cambridge University Press, 1915.

Bornemann's Table 1 (below) states the correspondence in exactly the form O39
uses — half-plane abscissa on one side, circle radius on the other:

> | Type of series | φ_n(z) | Growth expnt. λ_n | Height ω(z) | ρ^(−1) |
> |---|---|---|---|---|
> | General Dirichlet* | exp(−λ_n z) | λ_n | exp(−Re z) | e^(σ_c) |
> | Power series | z^n | n | \|z\| | lim_n \|a_n\|^(1/n) |
>
> \* With abscissae σ_c of convergence and σ_a < ∞ of absolute convergence
>
> — Bornemann, *Comput. Methods Funct. Theory* **23** (2023), 723–739,
> Table 1, p. 8 of the article PDF.

Read the two rows together: `ρ^(−1) = e^(σ_c)` for the Dirichlet form,
`ρ^(−1) = lim |a_n|^(1/n)` for the power-series form. "Radius of convergence
`b^(−σ)` for coefficients growing like `b^(σr)`" — the `radius_rule` string
hardcoded in `results/transform_radius.json` `constants` — is that identity
with `λ_r = r log b`.

The underlying coefficient formula is Cahen's:

> Cahen, E.: *Sur la fonction ζ(s) de Riemann et sur des fonctions analogues.*
> Ann. Sci. École Norm. Sup. (3) **11** (1894), 75–164.

quoted by Bornemann as: the quantity `lim_n λ_n^(−1) log |Σ_{k≤n} a_k|`
"by a classical result of Cahen from 1894, equals max(0, σ_c), regardless of
whether the series converges or not, unless Σ a_n = 0" (Bornemann, §1).

### Layer 1b — the RH input (KNOWN, canonical)

That the relevant abscissa is `1/2` is the classical error-term equivalence,
not a new observation. Three standard forms, each citable:

1. **von Koch (1901).** RH ⟺ `π(x) = li(x) + O(√x · log x)`.
   > von Koch, H.: *Sur la distribution des nombres premiers.*
   > Acta Math. **24** (1901), 159–182. DOI 10.1007/BF02403071.

2. **Ingham (1932), the Θ formulation** — this is the one that gives the
   *equivalence* rather than one implication, because it supplies the Ω-side.
   With `Θ = sup{Re ρ : ζ(ρ) = 0, 0 < Re ρ < 1}`: `ψ(x) − x = O(x^Θ log²x)`
   and `ψ(x) − x = Ω_±(x^(Θ−ε))`; `1/2 ≤ Θ ≤ 1`, and `Θ = 1/2` iff RH.
   > Ingham, A. E.: *The Distribution of Prime Numbers.* Cambridge Tracts in
   > Mathematics and Mathematical Physics 30, Cambridge University Press,
   > 1932. (Reissued Cambridge Mathematical Library, 1990.)

   This is what makes the O39 statement two-directional: without the Ω-result
   a measured radius `> b^(−1/2)` would carry no information.

3. **Titchmarsh Theorem 14.25 (Littlewood's theorem)**, the version stated
   directly as an abscissa of convergence:
   > "Theorem 14.25 (A): the Riemann Hypothesis implies that
   > `Σ_{n≥1} μ(n) n^(−s)` converges to `1/ζ(s)` for every `σ > 1/2`."
   > — Titchmarsh, E. C.: *The Theory of the Riemann Zeta-Function*, 2nd ed.
   > rev. D. R. Heath-Brown, Oxford University Press, 1986, §14.25.

   With the converse (`M(x) ≪ x^(1/2+ε)` ⟹ convergence for `σ > 1/2` ⟹ RH by
   partial summation), this is literally "RH ⟺ this Dirichlet series has
   abscissa of convergence 1/2."

### Layer 1c — the specific packaging

Searched for: the equivalence stated as a *root radius* of the truncated
transform of a *prime-counting difference table*. **NOT FOUND.** No source
found stating "RH ⟺ the roots of the truncated z-transform of the dyadic
prime-block sequence accumulate on `|z| = b^(−1/2)`."

What *is* standard, and is the closest structural precedent, is the identical
geometry in the function-field case, where it is a theorem rather than a
conjecture. For a smooth projective curve over `F_q`, `Z(T)` has poles at
`T = 1` and `T = q^(−1)` and its numerator's zeros satisfy `|T| = q^(−1/2)`;
RH for curves is exactly the statement that the zeros sit on that circle
(Hasse 1933 for elliptic curves; Weil 1948 in general). The pair of radii
`b^(−1)` and `b^(−1/2)` in O39 is the archimedean-place mimic of that
picture. The project's own `papers/convergence.md` §B2–B5 already records
this, correctly, as a theorem being reproduced rather than discovered.

**Bottom line for Piece 1: the criterion is the classical abscissa criterion
in `z = b^(−s)` coordinates. Cite Hardy–Riesz (1915) + Cahen (1894) for the
coordinate change, and Ingham (1932) / Titchmarsh §14.25 / von Koch (1901) for
the 1/2. Do not present it as a new equivalence.**

---

## Piece 2 — Jentzsch

### 2a — the theorem itself (canonical citation, confirmed)

**Original:**

> Jentzsch, R.: *Untersuchungen zur Theorie der Folgen analytischer
> Funktionen.* Acta Mathematica **41** (1916), 219–251.
> DOI 10.1007/BF02422945.

Verified against Project Euclid's Acta Mathematica volume 41 table of
contents: volume 41 is dated 1916, Jentzsch's paper is pp. 219–251. The work
is Jentzsch's 1914 Berlin dissertation; Bornemann refers to it as "his 1914
thesis [5]" while citing the 1916 Acta paper. **Some secondary sources give
1918 for this volume — the primary record says 1916.** Cite as
`Acta Math. 41 (1916), 219–251` and, if the thesis matters, note "1914
dissertation, published 1916."

**Szegő's refinement:**

> Szegő, G.: *Über die Nullstellen von Polynomen, die in einem Kreis
> gleichmässig konvergieren.* Sitzungsber. Berliner Math. Ges. **21** (1922),
> 59–64.

**Modern textbook-grade statement**, and the one worth quoting because it is
sharper than the popular version:

> **Theorem 2.1.**
> i) For any `f ∈ F`, there is a subsequence `(n_k)_{k≥1}` such that `ρ_{n_k}`
> converges to `δ_1`.
> ii) Given `f ∈ F`, if for a subsequence `(n_k)` the probability measures
> `ρ_{n_k}` converge to `δ_1`, then `μ_{n_k}` converges to `Λ`, and conversely.
>
> "Part i) of Theorem 2.1 is due to Jentzsch, [13]; it claims that there is a
> subsequence `μ_{n_k}` of the `μ_n` asymptotically concentrated on `∂D`. …
> The second part, ii), … due to Szegő, [23], says that just simple radial
> concentration of the mass of `μ_n` towards the unit circle `∂D` is
> equivalent to the (much more precise) statement that the `μ_n` converge to
> the uniform probability `Λ` on `∂D`."
>
> — Fernández, J. L.: *Zeros of sections of power series: deterministic and
> random*, arXiv:1507.02843v2 (2016), §2, p. 2. (`μ_n` = zero-counting measure
> of the n-th section; `ρ_n` = its radial push-forward; `Λ` = uniform measure
> on the circle; radius normalised to 1.)

> **Theorem 2.2 (Szegő).** If `lim_{n→∞} ⁿ√|a_n| = 1`, then `f ∈ S″`
> [the Szegő class: the *complete* sequence `μ_n` converges to `Λ`].
> — same source, §2, p. 3.

Note for the bench: O39's coefficients satisfy Szegő's condition (2.1) after
normalising by the radius — `a_r ≈ C·b^(σr)/r` gives `|a_r b^(−σr)|^(1/r) → 1`
— so the *whole* sequence of sections equidistributes, not merely a
subsequence. That is a citation in the instrument's favour and should be
recorded as such, since the O39 docstring's phrasing ("the roots of the
partial sums of ANY power series accumulate on its circle of convergence")
overstates the raw Jentzsch statement and understates what Szegő gives here.

**The exact form for Dirichlet series** — the piece that makes O39's use of
Jentzsch legitimate at all, since O39's object is a Dirichlet series in
disguise:

> **Theorem 3.** For the four types of series at hand, Table 1 lists the
> admissible growth exponents `λ_n`, the proper height functions `ω(z)` and the
> convergence levels `ρ` such that, if we assume `0 < ρ < ∞`: … all points of
> the set `∂D_ρ` are cluster points of zeros of the `f_n` and `D_ρ` is the
> maximal open set in which `f_n` converges pointwise.
>
> — Bornemann, F.: *A Jentzsch-Theorem for Kapteyn, Neumann and General
> Dirichlet Series.* Comput. Methods Funct. Theory **23** (2023), no. 4,
> 723–739. DOI 10.1007/s40315-022-00468-y. arXiv:2107.07207. Theorem 3, §3.

and the historical note, which is the single most on-point sentence found in
this whole search:

> "Interestingly, it was already noted by Jentzsch [5, p. 236], and attributed
> by him to Knopp, that his theorem extends to sections of ordinary Dirichlet
> series, that is, to the particular choice `λ_n = log n`."
> — Bornemann, §1.

So: Jentzsch-for-Dirichlet-series, with the boundary being the abscissa of
convergence, has been known since Jentzsch's own 1916 paper, p. 236,
attributed to Knopp. Bornemann (2023) is the modern general treatment.

### 2b — Jentzsch as a *numerical instrument* for locating an abscissa

**Verdict: PARTIAL, tending to NOT FOUND as an established protocol.**

What exists:

- **Bornemann (2023) uses it in exactly this spirit, but qualitatively.** The
  paper's origin is visual: phase plots of truncated Kepler-equation series
  showed zeros clustering on a boundary, and that observation drove the
  theorem. "Strikingly, and more densely so for increasingly larger indices of
  truncation, zeros of the sections appear to cluster at the boundary of the
  domain of convergence in both cases" (§1). The boundary was *known* and
  plotted as a check (Figs. 1–4); it was not *estimated from* the zeros.
- **The established numerical methods for locating a radius of convergence use
  coefficients, not section zeros**: Domb–Sykes ratio plots, Padé/Hermite–Padé
  pole location, Hunter–Guerrieri iteration, differential approximants. See
  Hunter, C. and Guerrieri, B.: *Deducing the properties of singularities of
  functions from their Taylor series coefficients*, SIAM J. Appl. Math. **39**
  (1980), 248–263, DOI 10.1137/0139022; and Guttmann, A. J.: *Analysis of
  series expansions for non-algebraic singularities*, arXiv:1405.5327.
- **The nearest thing to a physics analogue** — Giordano, M. and Pásztor, A.:
  *Reliable estimation of the radius of convergence in finite density QCD*,
  Phys. Rev. D **99** (2019), 114510, arXiv:1904.01974 — estimates a radius as
  the distance to the nearest **Lee–Yang zero of the function itself**, not of
  a truncation. Checked directly: it is not a Jentzsch-type method.

**No paper was found that proposes, validates, or benchmarks "compute the
roots of truncations, take their mean modulus, call that the radius of
convergence" as a numerical estimator.** If Julian wants that as a method, the
literature offers the theorem but not the protocol, and not an error analysis.

---

## Piece 3 — the annulus modulus (log b)/(4π)

**Verdict: NOT FOUND.**

The formula itself is textbook and needs no defence: the conformal modulus of
`{r < |z| < R}` is `(1/2π)·log(R/r)`, a complete conformal invariant of
annuli; two annuli are conformally equivalent iff their moduli agree. For
`r = b^(−1)`, `R = b^(−1/2)` this gives `(1/2π)·(1/2)log b = log b/(4π)`,
which for `b = 2` is 0.05515890 — the number in
`results/transform_radius.json`, and the script is right that the session's
recorded 0.055132 was slightly off. Standard reference: Ahlfors, *Conformal
Invariants*, or Beliaev, *Conformal Maps and Geometry*, ch. 4 ("Extremal
Length and Other Conformal Invariants").

What was **not** found, after direct search of arXiv metadata, Google/Bing web
search, and the RH-adjacent literature reached through them:

- No paper pairing a conformal modulus of an annulus with the Riemann
  hypothesis. arXiv API metadata query
  `all:"conformal modulus" AND all:"Riemann hypothesis"` → **0 results.**
- No occurrence of the annulus `b^(−1) < |z| < b^(−1/2)` as a named or used
  object in RH-adjacent work.
- No occurrence of `log b/(4π)`, or `(log 2)/(4π) = 0.05515890`, as a constant
  attached to anything zeta- or prime-related.

The two ingredients are each completely standard and the combination appears
to be original to this project — but "original" here means "nobody has written
it down," not "nobody could." The modulus is a *reparametrisation* of the pair
of radii: it carries exactly the information `(R_outer/R_inner)` already
carries, and `R_outer/R_inner = b^(1/2)` is fixed by the two exponents 1 and
1/2 by construction. **The modulus is therefore a restatement of `σ_smooth = 1`
and `σ_resid = 1/2`, not an independent measurement.** No source was needed to
establish that; it follows from the definition, and it is why nothing in the
literature attaches significance to it.

---

## Known failure modes of this kind of numerical radius estimate

Each is documented; each is directly live for O39.

**F1. Jentzsch alone gives a subsequence, not every truncation.**
Theorem 2.1(i) above: only "there is a subsequence." The full-sequence
statement needs Szegő's condition (Theorem 2.2) or Carlson's characterisation
— a power series with finite positive radius has no Ostrowski gaps **iff** the
zeros of its n-th sections are asymptotically equidistributed on the boundary
circle (F. Carlson; G. Bourion; also Erdős and Fried — see Fernández §2, and
Erdős, P. and Fried, H.: *On the connection between gaps in power series and
the roots of their partial sums*, Trans. Amer. Math. Soc. **62** (1947),
53–61). Concrete counterexample from the same source: for the lacunary series
`f(z) = Σ_k z^(2^k)`, `μ_{2^k} → Λ` but `ρ_{2^k − 1} → (δ_1 + δ_∞)/2`; "the
whole sequence of zero counting measures of `f` does not converge."
*Live here:* O39 reads a single truncation per depth (`n = R − d`
coefficients) and reports its mean `|z|`. That is a point sample from a
sequence the theorem only constrains along a subsequence — unless Szegő's
condition is invoked, which it is not, in the script or the JSON.

**F2. Weak convergence of measures says nothing quantitative at finite n.**
Jentzsch/Szegő are limit statements about zero-counting *measures*. Neither
supplies a rate, and neither predicts the mean modulus of the roots of any
particular section. The `+6.609% / +6.671%` truncation offsets O39 reports are
therefore uncalibrated: no theorem in this literature says they should be
equal, and their equality is evidence but not proof of a shared artifact.
There is no known closed form for the offset at fixed n.

**F3. Competing singularities defeat all series-analysis radius estimators —
including this one.** Guttmann, arXiv:1405.5327, §2, verbatim:

> "One problem with the ratio method is that if the singularity closest to the
> origin is not the singularity of interest (the so-called physical
> singularity), then the ratio method will not give information about the
> physical singularity. Worse still, if the closest singularity to the origin
> is a conjugate pair of singularities, the ratios will vary dramatically in
> both sign and magnitude."

*Live here, and sharply.* Backward differencing is multiplication of the
generating function by `(1 − z)`: `Σ_r (a_r − a_{r−1}) z^r = (1 − z)·A(z)`
(elementary; Wilf, *generatingfunctionology*, 2nd ed., ch. 1–2; equivalently
the Euler/binomial transform). Iterating, `G_d(z) = (1 − z)^d · G_0(z)`.
`(1 − z)^d` is entire, so **the radius of convergence of `G_d` is the same for
every depth `d`** — it is `b^(−1) = 0.5` for the prime triangle at every
depth, set by the smooth part, which the difference operator damps by
`(1 − b^(−1))^d` but never annihilates. The measured migration
`0.5406 → 0.7537` is thus, under the standard theory, definitionally *not* a
migration of the radius of convergence. It is the crossover `Crossover.lean`
already proves: within a window of `R − d` coefficients the residual family
outgrows the smooth family by `≈3.41^d` (the `(1 − b^(−1/2))`-vs-comb-gain
ratio measured in O29), so the section's roots track the *dominant* family,
not the *nearest* singularity. This is exactly Guttmann's failure mode, and it
means the `d = 14` reading of 0.7537 is a statement about the residual's decay
exponent within the window, not about `Θ`. Recording it here as literature
grounding for the account `Crossover.lean` already gives — not as a proposal.

**F4. Turán's criterion is the canonical cautionary tale in precisely this
area, and it is false.** Turán proved a sufficient condition for RH from the
zeros of truncated Dirichlet series; Montgomery disproved its hypothesis.

> "Turán [16] showed that the Riemann hypothesis would follow if for all `N`
> sufficiently large `ζ_N(s)` had no zero in `σ > 1`. Let `ψ_N` be the
> supremum over all values of `σ` for which `ζ_N(s) = 0`. Montgomery [9]
> showed that for all `N` sufficiently large,
> `ψ_N = 1 + (4/π − 1 − o(1))·(log log N)/(log N)`, where the constant
> `4/π − 1` is best possible. Therefore for `N` sufficiently large, `ζ_N(s)`
> has zeroes in `σ > 1`."
> — Platt, D. J. and Trudgian, T. S.: *Zeroes of partial sums of the
> zeta-function*, LMS J. Comput. Math. **19** (2016), 37–41,
> arXiv:1507.01340v2, §1.

References:
Turán, P.: *On some approximative Dirichlet-polynomials in the theory of the
zeta-function of Riemann*, Danske Vid. Selsk. Mat.-Fys. Medd. **24** (1948),
no. 17, 36 pp.
Montgomery, H. L.: *Zeros of approximations to the zeta function*, in
P. Erdős (ed.), *Studies in Pure Mathematics: To the Memory of Paul Turán*,
Birkhäuser, Basel, 1983, 497–506.
Monach, W. R.: *Numerical Investigation of Several Problems in Number Theory*,
PhD thesis, University of Michigan, 1980 (Lem. 3.14, Thm. 3.8 — explicit: for
all `N > 30` there are zeros in `σ > 1`).
Spira, R.: *Zeros of sections of the zeta function I, II*, Math. Comp. **20**
(1966), 542–550 and **22** (1968), 168–173 (the numerical tables).
Borwein, P., Fee, G., Ferguson, R., van der Waall, A.: *Zeros of partial sums
of the Riemann zeta function*, Experiment. Math. **16** (2007), 21–39.
Gonek, S. M. and Ledoan, A. H.: *Zeros of partial sums of the Riemann
zeta-function*, Int. Math. Res. Not. IMRN (2010), no. 10, 1775–1791.

*Live here as precedent, not as a defect:* the whole numerical sub-field of
"zeros of truncated zeta" exists, has ~75 years of results, and its founding
conjecture was wrong by an amount that only shows up at large `N`
(`log log N / log N` → the threshold moves out slowly). Any claim of this shape
computed at `n ≤ 44` coefficients is inside the regime where Turán's criterion
also looked true.

**F5. Root-finding from coefficients is ill-conditioned independent of
everything above.** `numpy.roots` builds a companion matrix from the
coefficient vector; the map coefficients → roots is the standard example of an
ill-conditioned problem even for well-separated roots.
Wilkinson, J. H.: *Rounding Errors in Algebraic Processes*, Prentice-Hall,
1963; and Wilkinson, J. H.: *The perfidious polynomial*, in G. H. Golub (ed.),
*Studies in Numerical Analysis*, MAA Studies in Mathematics 24, 1984, 1–28
(where he calls it "the most traumatic experience in my career as a numerical
analyst"). O39 computes exact integers at depth 0 but `mpmath` differences at
`--dps 60` for the smooth and residual triangles, then hands float64
coefficients spanning many orders of magnitude to a degree-44 companion
matrix. The reported relative spreads (7.9e−3 for prime `d=0`, 6.9e−7 for
smooth `d=40`) are near or below where this matters.

**F6. Ω-side required.** Piece 1's equivalence is two-directional only because
`ψ(x) − x = Ω_±(x^(Θ−ε))` (Ingham, above). A measurement that finds a radius
*above* `b^(−1/2)` is not evidence against RH unless it can exclude the
truncation offset, which F2 says has no theory. A measurement that finds the
radius *at* `b^(−1/2)` is consistent with RH and with every `Θ` close to 1/2.

---

## Closest matches

**1. Bornemann, F.: A Jentzsch-Theorem for Kapteyn, Neumann and General
Dirichlet Series.** Comput. Methods Funct. Theory **23** (2023), no. 4,
723–739. DOI 10.1007/s40315-022-00468-y; arXiv:2107.07207.
Quoted: Table 1 (`ρ^(−1) = e^(σ_c)` for general Dirichlet series vs
`ρ^(−1) = lim|a_n|^(1/n)` for power series); Theorem 3; and §1's note that
Jentzsch himself, crediting Knopp, extended the theorem to ordinary Dirichlet
series (Jentzsch 1916, p. 236).
*How it differs:* it is the general theorem, stated for abstract coefficient
sequences. It contains no arithmetic, no prime-counting sequence, and no
claim about which abscissa a particular arithmetic series has. It gives O39
its licence, not its content. **This is the single citation the project most
needs and currently lacks.**

**2. Fernández, J. L.: Zeros of sections of power series: deterministic and
random.** arXiv:1507.02843v2 (2016).
Quoted: Theorem 2.1 (Jentzsch = subsequence; Szegő = equidistribution),
Theorem 2.2 (Szegő's `ⁿ√|a_n| → 1` condition), and the lacunary
counterexample `Σ z^(2^k)`.
*How it differs:* purely complex-analytic; no application to convergence-radius
estimation and no error analysis at finite `n`. It is the source for the
precise form of the theorem and for F1.

**3. Platt, D. J. and Trudgian, T. S.: Zeroes of partial sums of the
zeta-function.** LMS J. Comput. Math. **19** (2016), 37–41; arXiv:1507.01340.
Quoted above (Turán/Montgomery).
*How it differs:* the object is `ζ_N(s) = Σ_{n≤N} n^(−s)` — an *ordinary*
Dirichlet series truncated in `n`, and the question is a half-plane
(`σ > 1`), not a radius. O39's object is a *dyadically blocked* series
truncated in `r`, and the question is `σ = 1/2`. Same technique, different
series, different abscissa. Not a priority collision; a methodological
precedent and a cautionary one.

**4. Hardy, G. H. and Riesz, M.: The General Theory of Dirichlet's Series.**
Cambridge Tract 18, 1915. (Cited by Bornemann as `[4, Ch. II]` and `[4, Thm. 9]`
for the abscissa theory and `σ_a ≤ σ_c + lim(log n)/λ_n`.)
*How it differs:* it is the substrate. The half-plane/disc correspondence is
its opening move, not a result anyone would cite as novel.

**5. von Koch (1901) / Ingham (1932) / Titchmarsh §14.25.** Cited above.
*How they differ:* they state the equivalence in `x`-space (error term) and in
`s`-space (abscissa), never in `z`-space (radius). The `z`-space rendering is
a coordinate change away and appears to be unwritten, but it is a change of
coordinates, not a theorem.

**6. Weil-conjecture geometry for curves over `F_q`** (Hasse 1933; Weil 1948).
*How it differs:* the two radii `q^(−1)` and `q^(−1/2)` and the "zeros on the
inner circle" picture are exactly O39's geometry, but there it is proved and
the object is a rational function of `T` with finitely many zeros. `papers/
convergence.md` §B5 already records the distinction correctly.

---

## Search record

Every query run, with service and outcome. `WebSearch` = general web search;
`arXiv API` = `export.arxiv.org/api/query` (metadata only — title/abstract/
authors, **not** full text); `WebFetch` = direct page/PDF retrieval.

| # | Service | Query | Outcome |
|---|---|---|---|
| 1 | WebSearch | Jentzsch theorem zeros of partial sums accumulate circle of convergence 1914 | HIT — led to Fernández, Cook, Springer CMFT |
| 2 | WebSearch | abscissa of convergence Dirichlet series relation radius of convergence power series Cahen formula | HIT — Cahen formula, Bornemann |
| 3 | WebFetch | arxiv.org/abs/1507.02843 | Abstract only; no theorem text |
| 4 | WebFetch | link.springer.com/article/10.1007/s40315-022-00468-y | 303 redirect to IdP; blocked |
| 5 | WebFetch | arxiv.org/pdf/1507.02843 | PDF binary, unreadable by fetcher; retrieved locally instead |
| 6 | WebSearch | "Jentzsch" theorem general Dirichlet series zeros partial sums abscissa of convergence arXiv | HIT — arXiv:2107.07207 |
| 7 | WebFetch | arxiv.org/abs/2107.07207 | Abstract + full bibliographic data |
| 8 | WebFetch | ar5iv.labs.arxiv.org/html/2107.07207 (×2) | Paraphrase only; superseded by local PDF extraction |
| 9 | WebSearch | Riemann hypothesis equivalent abscissa of convergence 1/2 Dirichlet series Mobius Littlewood | HIT — Riesz/Hardy–Littlewood criteria, Titchmarsh 14.25 |
| 10 | WebFetch | arxiv.org/pdf/2107.07207v3 | 404 |
| 11 | WebFetch | d-nb.info/1274619513/34 | PDF retrieved (1.9 MB); extracted locally with `pdftotext` — **primary source for all Bornemann quotes** |
| 12 | WebSearch | Jentzsch theorem numerical method estimating radius of convergence from zeros of Taylor partial sums | PARTIAL — Jentzsch–Szegő/balayage, Note on sharpness, QCD paper |
| 13 | WebFetch | arxiv.org/abs/1904.01974 (QCD radius of convergence) | NEGATIVE — Lee–Yang zeros of the function, not section zeros |
| 14 | WebSearch | Hardy Riesz General Theory of Dirichlet's Series λ_n = n reduces to power series z = e^(−s) | HIT — correspondence confirmed |
| 15 | WebSearch | conformal modulus annulus Riemann hypothesis critical strip conformal map | **EMPTY** for the combination |
| 16 | WebSearch | Montgomery "Zeros of approximations to the zeta function" Turán disproved partial sums half-plane | HIT — Platt–Trudgian, Monach, Spira |
| 17 | WebFetch | arxiv.org/pdf/1507.01340 | PDF retrieved; extracted locally — source for Turán/Montgomery quote |
| 18 | WebSearch | Titchmarsh Theory of the Riemann Zeta-function ψ(x)−x = O(x^(1/2+ε)) abscissa Θ | HIT — Titchmarsh, Ingham Θ |
| 19 | WebSearch | von Koch 1901 Sur la distribution des nombres premiers citation Acta Mathematica | HIT — Acta Math. 24 (1901), 159–182 |
| 20 | WebSearch | Ingham Distribution of Prime Numbers Θ = sup Re ρ, Ω-result | HIT |
| 21 | WebSearch | Titchmarsh Theorem 14.25 RH ⟺ M(x) = O(x^(1/2+ε)) ⟺ Σμ(n)n^(−s) converges σ > 1/2 | HIT — Theorem 14.25(A) confirmed |
| 22 | WebSearch | "Riemann hypothesis" "radius of convergence" power series generating function equivalent formulation prime counting | **EMPTY** for the specific packaging |
| 23 | WebSearch | "modulus of the annulus" OR "conformal modulus" annulus "Riemann hypothesis" zeta radii log 2/4π | **EMPTY** |
| 24 | WebSearch | zeros of partial sums used numerically to locate singularity — Domb–Sykes / Padé comparison | HIT — Domb–Sykes and Padé are the actual methods; section zeros are not |
| 25 | WebSearch | Szegő 1922 Über die Nullstellen von Polynomen… Jentzsch–Szegő subsequence equidistribution | HIT — Sitzungsber. Berliner Math. Ges. 21 (1922), 59–64 |
| 26 | WebFetch | arxiv.org/pdf/2209.12022 ("Zeros and coefficients") | PDF unreadable by fetcher; retrieved locally, not needed |
| 27 | WebSearch | zeros of sections modulus rate "log n / n" Rosenbloom Van Vleck | PARTIAL — Rosenbloom/Szegő-curve literature; no clean rate for this case |
| 28 | WebSearch | generating function primes in dyadic intervals, z = 2^(−s), radius of convergence, annulus of analyticity | **EMPTY** |
| 29 | WebSearch | zeta of curve over finite field, Z(T), zeros \|T\| = q^(−1/2), annulus | HIT — the function-field analogue |
| 30 | WebSearch | Carlson theorem Ostrowski gaps sections equidistributed necessary and sufficient | HIT — Carlson characterisation |
| 31 | WebSearch | "conformal modulus" annulus invariant analytic number theory L-function Euler product | **EMPTY** for the combination |
| 32 | WebSearch | Wilkinson ill-conditioned polynomial roots companion matrix | HIT — Wilkinson 1963/1984 |
| 33 | arXiv API | `all:"conformal modulus" AND all:"Riemann hypothesis"` | **0 results** |
| 34 | arXiv API | `all:"Jentzsch" AND all:"Riemann hypothesis"` | **0 results** |
| 35 | WebFetch | zbmath.org search "Jentzsch abscissa of convergence" | **HTTP 403 — not accessible** |
| 36 | WebSearch | "extremal length"/"conformal invariant" annulus + zeta/PNT + log b/4π | **EMPTY** for the combination |
| 37 | WebSearch | "z-transform" region of convergence prime counting Riemann hypothesis truncated transform | **EMPTY** |
| 38 | WebSearch | finite difference table of prime counting function, generating function zeros, radius 2^(−1/2) | **EMPTY** |
| 39 | WebSearch | Borwein–Fee–Ferguson–van der Waall, Zeros of partial sums of the Riemann zeta function, Exp. Math. 2007 | HIT — citation confirmed |
| 40 | WebFetch | projecteuclid.org Acta Mathematica vol. 41 TOC | HIT — **volume 41 is 1916**, Jentzsch pp. 219–251, DOI 10.1007/BF02422945 |
| 41 | WebSearch | Cahen 1894 Sur la fonction ζ(s)… Annales ENS citation | HIT — Ann. Sci. ENS (3) 11 (1894), 75–164 |
| 42 | arXiv API | `abs:"annulus" AND abs:"zeta" AND abs:"modulus"` | 1 result, irrelevant (SLE loop measures) |
| 43 | WebFetch | arxiv.org/abs/0807.0019 (Gonek–Ledoan) | Abstract; counts zeros, does not locate an accumulation abscissa |
| 44 | WebSearch | repeated finite differencing → radius of convergence / binomial transform | HIT — the `(1−x)` identity, Euler transform |
| 45 | WebSearch | "competing singularities" Domb–Sykes fails, preasymptotic, misleading radius | HIT — Guttmann arXiv:1405.5327 |
| 46 | WebSearch | Wilf generatingfunctionology backward difference × (1−x) | HIT |
| 47 | WebFetch | epubs.siam.org/doi/10.1137/0139022 | **HTTP 403** — citation obtained by search instead |
| 48 | WebFetch | arxiv.org/html/1405.5327 (Guttmann) | HIT — competing-singularities quote |
| 49 | WebSearch | Hunter & Guerrieri SIAM J. Appl. Math. 1980 citation | HIT — 39 (1980), 248–263 |
| 50 | WebSearch | "Riemann hypothesis" "circle of convergence" zeros of partial sums, power series in 2^(−s) | **EMPTY** for the specific packaging |

Empty results are listed above in bold and are load-bearing for the Piece 3
verdict.

---

## What I could not check

1. **MathSciNet** — subscription-gated, no access from this environment. A
   MathSciNet reverse-citation sweep on Jentzsch (MR-number for
   Acta Math. 41, 219–251) is the single most likely place to find a
   number-theoretic application I missed. Recommend a human check there.
2. **zbMATH Open** — returned HTTP 403 to WebFetch. The public zbMATH search
   UI would likely answer the same reverse-citation question.
3. **arXiv full text.** The arXiv API searches metadata only (title, abstract,
   authors). Queries 33, 34, 42 therefore prove only that these phrases do not
   co-occur in *abstracts*. A full-text arXiv search (via Google
   `site:arxiv.org` was attempted through WebSearch, but that is
   index-coverage-limited, not exhaustive) could still turn up a body-text
   mention.
4. **Primary text of Jentzsch (1916), p. 236** — the Knopp attribution is
   quoted here at second hand from Bornemann. The Acta Mathematica scan is on
   Project Euclid; the page was not retrieved, and it is in German. If the
   Knopp attribution is going to be cited, someone should read p. 236.
5. **Turán (1948), Danske Vid. Selsk. Mat.-Fys. Medd. 24** — not retrieved.
   The characterisation of his criterion is quoted from Platt–Trudgian, which
   is reliable but secondary. Turán's *On a New Method of Analysis and Its
   Applications* (Wiley, 1984) is the book-length treatment and was not
   consulted.
6. **Titchmarsh §14.25 primary text** — the theorem number and content are
   quoted from secondary sources that cite it (multiple, agreeing). A copy is
   at `sites.math.rutgers.edu/~zeilberg/EM18/TitchmarshZeta.pdf`; the page was
   not extracted (large scan). Verify the (A)/(B)/(C) sub-labels before
   citing.
7. **Hardy–Riesz Tract 18 primary text** — Theorem 9 and Ch. II are cited via
   Bornemann's reference to them, not read. A scan is on archive.org
   (`generaltheoryofd029816mbp`).
8. **Non-English / pre-1950 literature generally.** If the O39 packaging was
   written down, the most likely places are German-language function-theory
   papers of the 1920s–30s (Ostrowski, Bourion, Knopp, Dienes' *The Taylor
   Series*, 1931) that are poorly indexed by the search services available
   here. Piece 3's NOT FOUND should be read with that caveat.
