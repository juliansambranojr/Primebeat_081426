---
id: 0554
date: 2026-11-25
type: run
title: "Gram's law fails at the 126th Gram point; Rosser's rule holds on every block to height 1420: no fixed local rule on Gram intervals is a face for stage C"
refs: [lean_stage3/Stage3/Defect.lean::rh_iff_defect_zero]
supersedes: []
follows: 0553
context: block S14 of `lean_stage3/design/stencil.md`, its round on Gram's law and Turing's method, tries two local rules for the defect
sealed: false
---

**Question.** Does a sign change of Hardy's function in every interval where the horizon turns by pi, Gram's law, or a full count of sign changes in every Gram block, Rosser's rule, hold on the first thousand Gram points?

**What ran.** `run/gram.py`, mpmath at fifteen digits: the Gram points from index minus one on, a thousand and one of them, by `grampoint`, Hardy's function at each by `siegelz`, a point good when its sign alternates with the index, and the blocks between consecutive good points searched for sign changes on a grid of sixty steps per interval. EXPLORATORY: no prereg, no verdict, nothing proved. A grid can miss two close sign changes, so a Rosser count here is a lower count.

**What it gave.** Of the `results.gram_points_checked` 1001 points, `results.gram_bad_count` 42 are bad, the first at index `results.gram_first_bad` 126, a share of `results.gram_bad_fraction` 0.04195804195804196, up to height `results.height_last` 1420.0973460749165. The bad points make `results.gram_blocks` 42 blocks, and the grid found `results.rosser_failures` 0 blocks with fewer sign changes than intervals.

**What it says for the goal.** Gram's law is false already here, so it is not a face. Rosser's rule held on every block here; from memory and not checked this session, it fails at a much larger height, as does every fixed rule of this kind. The design round in S14 records the other route, Turing's method, as a verification of each finite range.
