---
id: 0325
date: 2026-09-06
type: decision
title: Rung 5 route: the isolated case is the easy way; the target is the finite window family (Bombieri Theorem 8)
refs: [lean_stage3/Stage3/WeilOnLine.lean::tsum_onLine_le, lean_stage3/Stage3/WeilBackground.lean::online_term_le_far]
supersedes: []
follows: 0308
sealed: false
---

**Question.** Rung `rung_done` 4b closed in unit 0324. Unit 0320 split
rung `rung_next` 5 into 5a, the isolated off-line zero, and 5b, the general
case. Julian asked whether recommending 5a first is the best way or the easy
way. Which is it, and what does the best way cost?

**What ran.** Nothing. This unit records a route decision and its reasons;
`run/` is empty. The refs are the two theorems the decision rests on.

**What it shows.** 5a is the easy way, on three counts.

What 5a proves. A theorem with the hypothesis that the box holds exactly
`isolated_pairs` 1 off-line zero pair at height `γ`. That hypothesis cannot
be checked from outside. The result is a lemma about a situation whose
occurrence is unknowable, and it does not close the arrow from detection
to an empty box (`StmtDetect`, unit 0316).

Why 5a is structurally a dead end. Unit 0320 recorded the cancellation:
two off-line zeros at nearly the same height contribute terms of opposite
sign inside one window. The general case is a different mechanism. Several
windows at once, the form restricted to that family read as a finite
Hermitian matrix, and the off-line pair exposed as an indefinite block by a
combination chosen to pick it out. That is Bombieri (2000) Theorem 8. The
isolated case is the same argument with a matrix of size
`isolated_matrix` 1, and it brings the interpolation step, which is the
whole difficulty, no closer.

What 5b needs, in rungs. Linear combinations of the windows at several
heights, and the form on that family as a matrix. The matrix as a sum: a
positive semidefinite on-line part, bounded by rung 4b's `tsum_onLine_le`,
plus one rank-`block_rank` 2 indefinite block per off-line pair. An
interpolation lemma: the family can be steered to prescribed values at
finitely many zeros, so one pair is picked out and the others suppressed.
Lobe and decay control for the combination, as in rungs 3 and 4
(`online_term_le_far` and its lobe counterpart).

Price. 5a: `price_5a_days` 1 to 2 days on top of what exists. 5b: a new
ladder of comparable length to units 0316 to 0324, several days at least;
the interpolation lemma is the rung most likely to resist in Lean.

What carries over either way. Rung 4b's on-line background bound is used in
full by 5b. The window, transform, lobe and background rungs are reused
as they stand.

Recommendation. Skip 5a. The next rung is the matrix form on a finite
window family. 5a as a warm-up buys a green build sooner and nothing else.

Decision. Julian's: this unit is the log; the discussion follows it.
