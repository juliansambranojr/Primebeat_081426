---
id: 0320
date: 2026-09-06
type: formalization
title: WeilBackground.lean: the window as an explicit-formula test function, Psi's decay, and the on-line terms as squared moduli
refs: [lean_stage3/Stage3/WeilBackground.lean::laplace_phi, lean_stage3/Stage3/WeilBackground.lean::Psi_bound, lean_stage3/Stage3/WeilBackground.lean::online_term_eq, lean_stage3/Stage3/WeilBackground.lean::online_term_le_far]
supersedes: []
follows: 0308
sealed: false
---

**Question.** Rung 4b, first half, of the detection ladder (`units/0316` to
`units/0319`). The rungs so far bound the off-line contribution of the tuned
window. The zero side also carries every on-line zero, each with a
nonnegative term, and detection needs their sum bounded above. Two things
first: how the window enters WeilDetect's sum at all, and what one on-line
term is.

**What ran.** `lean_stage3/Stage3/WeilBackground.lean`, new, `module_lines` 216
lines, imported from `Stage3.lean`; and one edit to `WeilDetect.lean`: the
test class `IsTest` asks `C¹` where it asked `C²`, because the cut-off window
is `C¹` at its ends and never `C²` (the envelope's second derivative does not
vanish there) and Kadiri's explicit formula asks `C¹`. Three build cycles:
`errors_first` 3 errors on the first (a root-level `Psi` in the dependencies
shadowing the window's, one cast step the normaliser had done, one tactic
tail), `errors_second` 2 on the second (an ambiguous indicator lemma, two
tails), then clean. Full package built, `jobs_package` 8741 jobs. `run/build.log`
is the record.

**What it shows.** `theorems_proved` 7 theorems over `defs` 2 definitions
(`phi`, `phiC`), each pinned by `#guard_msgs` to `axioms` 3 axioms, `sorries` 0
sorries.

The window enters the explicit formula as `φ(u) = 𝟙_{[−h,h]}(u)·G(u)·e^{−u/2}`,
and `laplace_phi` says `laplace φ z = ghat h γ (−z − 1/2)`: the `e^{−u/2}` is
the instrument's `n^{−1/2}` and `ρ − 1/2` is where the transform is read. So
WeilDetect's term at `−ρ` is unit 0318's transform at `ρ − 1/2`.

On the line (`online_term_eq`): for `Re ρ = 1/2` the term is
`(h/2)²·[Ψ(h(γ_ρ + γ)) + Ψ(h(γ_ρ − γ))]²`, a squared modulus, via
`WeilDetect.laplace_conj` and `WeilTransform.ghat_ofReal_I`.

The decay of `Ψ` costs nothing new: `Psi_bound` is unit 0319's lobe bound
read at the purely imaginary argument, `|Ψ(s)| ≤ (2π + π²)/s²`, and
`Psi_le_two` is the trivial `|Ψ(s)| ≤ 2`. So an on-line term is at most
`near_bound` 4·h² near the carrier (`online_term_le_near`) and at most
`(h/2)²·[C/(h(γ_ρ−γ))² + C/(h(γ_ρ+γ))²]²` once `|γ_ρ − γ| ≥ 1` and
`γ_ρ + γ ≥ 1` (`online_term_le_far`), with `C = 2π + π²`.

A structural fact recorded here for rung 5. One tuned window detects an
ISOLATED off-line zero. A second off-line zero at nearly the same height
contributes a term of the opposite sign and can cancel the first. Bombieri
(2000) Theorem 8 handles that with a finite Hermitian matrix over all the
off-line zeros in the box and a count of its negative eigenvalues, with a
linear combination of tuned functions rather than one. So rung 5 splits:
5a, the isolated case, which these rungs support; 5b, the general case,
which needs Theorem 8 in Lean and is a separate ladder.

Next, the second half of this rung: the sum of the on-line terms over the
zeros by height band, using `JensenCount.zeta_local_zero_count`, whose
window at height `T` is the disk of radius `window_radius` 7/4 about
`2 + iT` and so covers the on-line zeros within about `band_half` 0.9 of
`T`.
