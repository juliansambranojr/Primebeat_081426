---
id: 0328
date: 2026-09-06
type: run
title: "Probe: the Weil form at the m-th power window read on both sides of the explicit formula; convention pinned, decay exponents matched, contrast turnover at m proportional to h"
refs: [lean_stage3/Stage3/WeilOffLine.lean::term_eq_neg_sq]
supersedes: []
follows: 0327
sealed: false
---

**Question.** Unit 0327 found that the window's smoothness at the cut sets
both the zero side's decay in height and the prime side's blindness to a
prime entering at the edge, and proposed the m-th power window. Julian
asked for a probe: map the truncation, and see whether the zeros come out
of the primes by contrast, the way a Gaussian blur trades sharpness for
noise. This unit is that probe. It is exploratory: no prereg, no decision
rule, no verdict.

**What ran.** `analysis/2026-09-06/probe_window_m.py`, three invocations,
`run/run.sh` has the flags. The object is the quadratic Weil form at the
window `G(u) = (u/h)·P(u/h)^m·cos(γu)` on `[−h, h]`, `P(x) = cos²(πx/2)`,
whose zero side is `−Σ ghat(ρ − 1/2)²·ord ρ` by `term_eq_neg_sq`, and under
RH `Σ |Ĝ(γ')|²`. The same number is the Riemann–Weil formula at the even
test function `A = G ⋆ G`, whose prime side runs over `n ≤ e^{2h}`. Zeros
from `mpmath.zetazero`, `zeros` 600 of them, up to height `zero_max` 939.
Wall clock `seconds_pin` 191, `seconds_h12` 150 and `seconds_h24` 119
seconds. Outputs and logs in `run/`; the script stays under
`analysis/2026-09-06/`.

**What it shows.**

The convention pin. Before any window was read, the Riemann–Weil formula
as coded was checked at a Gaussian test function of width `gauss_sigma` 1,
where every term is textbook: residual `gauss_residual` 2.2e-10, in the
session transcript. Then the window, at `combos` 27 points: support `h` in
`h_lo` 4, `h_mid` 6, `h_hi` 8; order `m` in `m_lo` 1, `m_mid` 4, `m_hi`
16; tuning at the first zero, between the first two, and at the second.
Primes to `nmax` 8886110, at most `prime_powers_max` 595877 prime powers.
The absolute residual between the prime side and the zero side lies
between `residual_min` 1.3e-10 and `residual_max` 3.5e-7 at every point.
Where the form is above `rel_threshold` 1e-5, `rel_n` 9 points, the
relative residual is at most `rel_max` 3.4e-3. Where the form is smaller
the residual is the numerical floor of the archimedean integral and the
interpolation at the prime powers, and the relative number means nothing.
The object is the right one: the primes reproduce the zero side of the
form, archimedean term included.

The node. The odd window's transform vanishes at exact tuning, so its image
of a zero is two humps with a dip at the zero. The even envelope `P^m`
alone gives a peak. Both images were swept.

The decay exponent. The transform squared falls on its envelope maxima
with slope `slope_m1` -6.00, `slope_m2` -10.01, `slope_m3` -14.02,
`slope_m4` -18.13 for `m` from 1 to 4, against the boundary reading's
prediction of minus `four` 4 times `m` plus `two` 2. For `m` at least
`m_floor` 6 the envelope falls under the quadrature floor before the fit
range and the slope is meaningless (`slope_m6` -2.95).

The contrast turnover. Contrast is hump over floor, the floor being the
mean of the image on the stretch between neighbouring zeros. At support
`h_mid` 6 the contrast at the first zero is `c_h6_m1` 307.86 at `m` equal
1 and falls monotonically to `c_h6_m16` 1.24 at `m` equal 16. At support
`h_12` 12 the peak moves to `m` equal `peak_h12` 2. At support `h_24` 24
it moves to `m` equal `peak_h24` 4. The optimum order grows in proportion
to the support: doubling `h` doubles the `m` of peak contrast. The crude
balance that predicts it: the neighbours' sidelobes fall like the support
times the gap to the power minus four m plus two, the main lobe's skirt
falls like the exponential of minus the support squared over `m`, and the
two cross at `m` proportional to `h` over the root of a log.

What this says about the finding. The detection theorem's window has `m`
of the order of `h`, past the contrast optimum by a constant factor. The
theorem trades image sharpness for suppression of the zeros above the
box. That is the Gaussian blur exactly: a larger radius hides the edge
and the ringing and costs resolution. The map of the truncation has three
points on it, and the ridge runs along `m` proportional to `h`.

What the probe did and did not test. The pin tests the code and the
convention against a theorem. The decay and the turnover are properties of
the window, measured on the zero side, which the prime side reproduces to
the pin's accuracy. Nothing here bears on RH. It bears on which window to
build, and on the reading that the primes' sum is the image of the zeros
at a resolution the truncation sets.
