---
id: 0326
date: 2026-09-06
type: formalization
title: "WeilOffLine.lean: every term of the zero form is minus a square, and the off-line zero's own term is negative"
refs: [lean_stage3/Stage3/WeilOffLine.lean::term_eq_neg_sq, lean_stage3/Stage3/WeilOffLine.lean::offline_term_le_explicit]
supersedes: []
follows: 0325
sealed: false
---

**Question.** Rung `rung` 5, first slice. Unit 0325 set the route: the
off-line zero's own term first, then the family. What is the shape of one
term of the zero form at the tuned window, on the line or off it, and what
is the sign of the term at the off-line point the window is tuned to?

**What ran.** `lean_stage3/Stage3/WeilOffLine.lean`, new, `module_lines` 151
lines, imported from `Stage3.lean`. `errors_first` 0 errors on the first
build. Full package built, `jobs_package` 8746 jobs. `run/build.log` is the
record.

**What it shows.** `theorems_proved` 7 theorems and `defs` 1 definition
(`offPt`), each pinned theorem by `#guard_msgs` to `axioms` 3 axioms,
`sorries` 0 sorries.

The identity. `SigmaC_neg`: the odd envelope's transform is odd, because
`sinh` is. `ghat_neg`: the window's transform is odd, both halves of unit
0318's closed form flipping sign. `term_eq_neg_sq`: for every `ρ`, the two
factors of a term are the transform read at `ρ − 1/2` and at its negative,
so the term is `−ghat h γ (ρ − 1/2)²`. `term_re_eq`: its real part is
`(Im g)² − (Re g)²` at `g = ghat h γ (ρ − 1/2)`. On the line `g` is purely
imaginary and the term is a square, unit 0320's `online_term_eq` again. Off
the line the term is negative exactly when `g` is more real than imaginary.
The half is `half` 1/2, the shift from the zero to where the transform is
read.

The off-line term. `offPt ε γ` is the point `1/2 + ε + iγ` the window tuned
at `γ` reads. There unit 0318's `ghat_offline` gives `g` as `h/2` times the
sum of the real main term `Σ(εh)` and the `2γ` lobe. `offline_term_le`: when
the lobe is at most the main term in norm, the term's real part is at most
`−(h/2)²·Σ(εh)·(Σ(εh) − 2‖lobe‖)`, so it is negative as soon as the main
term beats `lobe_mult` 2 times the lobe, and its size is the square of the
main term to first order. `offline_term_le_explicit`: the same with the
lobe replaced by unit 0319's bound `(2π + π²)·cosh(εh)/(2γh)²`.

What this closes. The sign structure of the whole zero side in one line:
the form at the tuned window is minus the sum of `ghat(ρ − 1/2)²·ord ρ` over
the zeros, and the sign of each term is read off the phase of one complex
number. The off-line zero's own term is the negative of the square of the
main term, less a lobe correction.

What it opens. The identity holds for every zero, so the terms of the other
off-line zeros have the same shape, with `g` read at their own points. Their
size grows like `cosh` of their own distance from the line times `h`, while
their decay in height is polynomial. That is the constraint the next slice
has to meet, and it is recorded in the transcript bracket of this unit.
