---
id: 0327
date: 2026-09-06
type: decision
title: "Rung 5 finding: the cos-squared window cannot give an explicit support; the fix is the m-th power window"
refs: [lean_stage3/Stage3/WeilOffLine.lean::term_eq_neg_sq, lean_stage3/Stage3/WeilOffLine.lean::offline_term_le_explicit, lean_stage3/Stage3/WeilLobe.lean::SigmaC_bound]
supersedes: []
follows: 0326
sealed: false
---

**Question.** Unit 0326 proved that every term of the zero form at the
tuned window is minus a square, and bounded the off-line zero's own term.
The same identity gives the size of every other off-line zero's term. Does
the route of unit 0325, one window family built from the raised-cosine
window, reach the bounded-height theorem with an explicit support?

**What ran.** Nothing. This unit records a finding, its reason, and the
proposed fix; `run/` is empty. The refs are the theorems the finding rests
on.

**What it shows.** With the raised-cosine window it does not. The reason
has two parts, and both are read off unit 0326's identity.

The main term must be exponential. Rung 4b's on-line background grows like
`h` to the power `bg_power` 2 times a polynomial in the height. The
off-line zero's own term is the square of the main term `Σ(εh)`, and
`Σ(s)` is at least `s` over `sigma_denom` 24 by unit 0317, so the main term
beats the background only when `εh` is large, where `Σ(εh)` grows like the
exponential of `εh`. So the support has to make `εh` large.

Every other off-line zero grows the same way. By `term_eq_neg_sq` the term
of a zero at real part one half plus `ε'` is minus the square of the
transform read at its own point, and by `SigmaC_bound` that transform is at
most `cosh(ε'h)` over a power of its distance. Its size is exponential in
its own real part times `h` and polynomial in its height gap from the
window. A zero with a larger real part than the target, at any height,
therefore beats the target once `h` is large, and no polynomial decay in
height can cancel an exponential in the real part. The window cannot
detect a box zero without knowing every zero above the box. That is why
Bombieri's support has no formula: his window class has the same
polynomial decay in height.

The cluster. Zeros with the same real part as the target and height gap
below `ε` contribute terms of either sign, with a phase that turns with
`h`. Unit 0320 recorded this as cancellation. It is the smaller of the two
obstructions.

The fix. The window's smoothness has to grow with its support. Replace the
envelope `P` by its `m`-th power with `m` of the order of `h`. That is a
truncated Gaussian. Its transform has a closed form: a constant times
`sinh(w)` over `w` times the product over `j` up to `m` of `w² + π²j²`. At
`m` equal to `m_check` 1 this is `π²·sinh(w)/(w(w² + π²))`, checked by hand
against unit 0318's transform. The proof is the partial-fraction identity
for a binomial sum over `j` of `(−1)^j·C(n, j)/(x + j)`, by induction on
`n`, each step subtracting the shifted sum. In the regime the assembly
uses, the amplitude at a zero is the exponential of its real part squared
minus its height gap squared, times `h/π²`. Zeros farther in height than
their distance off the line are suppressed by the window itself, at every
real part.

What remains after the fix. The target is the zero of largest real part in
a slightly widened box; that choice stabilises in an explicit number of
widening steps because each step that changes it raises the real part by
a fixed amount. The cluster is aligned in phase by choosing `h` from an
explicit range, the simultaneous Dirichlet lemma with the band count as
the number of frequencies. Every aligned cluster term is negative. Cluster
members farther in height than their own distance off the line are
suppressed.

What carries over. The band and tile modules of units 0321 and 0322 take
the dominating series as a parameter and survive as they stand. The
window, transform, lobe, series and on-line modules gain the parameter
`m`. Unit 0326's identity holds for every odd window and survives.

Price. `modules_min` 10 to `modules_max` 12 modules. Units 0321 to 0324
went in at `rung_min_minutes` 6 to `rung_max_minutes` 25 minutes of clock
each. A session and a half.

Recommendation. Switch the window to the `m`-th power. The alternative is
the isolated case under a hypothesis on the other zeros, which is
measurable only if the hypothesis is accepted.

Decision. Julian's: this unit is the log.
