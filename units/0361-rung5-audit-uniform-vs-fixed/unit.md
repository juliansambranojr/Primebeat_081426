---
id: 0361
date: 2026-09-08
type: decision
title: "Audit of rung 5 after the split: 0359 priced a fixed configuration and called it uniform; 0360 priced one sideband; uniform L dead by the menu pigeonhole, gap-dependent L open"
refs: [none]
supersedes: []
follows: 0360
context: Julian switched models and asked for an audit of everything on rung 5 after the sibling repo was created, and whether the loop was doing its job; this unit is the audit, read from the tree, and it corrects two of the four decision units written that day
sealed: false
---

**Question.** After the sibling repo landed, four things happened on rung `rung` 5: blocks 13h and 13i were built (units `unit_clean` 0357 and `unit_count` 0358), the assembly was priced and declared dead (unit `unit_assembly` 0359), and the window question was priced and declared dead (unit `unit_window` 0360). Are the designs right, and are the two deaths right for what the rung states, which is `StmtDetect ε T L` with `L` explicit in `ε` and `T` alone?

**What ran.** `run/uniform_vs_fixed.py`, output in `run/uniform_vs_fixed.log`, and the scratch bridge of 2026-09-07 that rewrites the zero form's term at an actual `Kadiri.NontrivialZeros` into `S` by two existing lemmas, `term_re_eq` and `what_eq`, which compiled and is now block `13j`. No claim below is from memory; each is from a file or a compiled example.

**What it shows.**

Blocks 13h and 13i are correct Lean and correct abstractions. They were built after unit `unit_shell` 0351 had shown the route needed a sharp count leaf and before anyone had priced the assembly on the term, so their order was wrong: the counting tools came before the check of what they count.

Unit `unit_assembly` 0359's argument does not establish its conclusion. Its headline ratio, `ratio_0359` 0.154 over `N log P`, puts every member at `Δ = lo/b`, and `Δ` cannot depend on `b`, since the zeros are fixed before the range is chosen. For any fixed configuration the route closes: a member's total cost is at most `λπ²/(2Δ²)` whatever the range, so the range `h₀` plus the sum of those wins. The script's first table has it at `b_fixed_one` 1020 for one member at half a unit and `b_fixed_three` 1672 for three. What dies is uniformity. `L` explicit in `ε, T` means `b` is drawn from a finite explicit menu before the zeros are seen, a member blocks a `b`-interval, and members placed greedily square the blocked top at every step: with `N` members the menu must reach `b` about `h₀` to the power `2^N`. In log base ten of `b`, from `h₀` a thousand, the last blocked top is `top1_N1` 3.81 at one member, `topN_N3` 12 at three, `topN_N5` 49.9 at five, and `topN_N15` 65162 at fifteen, against a band count of `band_a` 15 times the log of the height plus `band_b` 73. That is beyond any polynomial in the height and it is the death of the rung as stated. 0359 did not write it; it wrote a fixed-`b` worst case and called it parameter-free.

Unit `unit_window` 0360 is right about one sideband and unverified about the term. The bridge shows the term at a zero is minus `(h/2)²` times `Re(S₋²) + 2Re(S₊S₋) + Re(S₊²)`, with `w± = (ρ − 1/2 ± iγ)h`. Every module of the session, `modules_session` 11 of them, bounds one `S` at one `w`: `zeta_refs` 0 of them name a zero of zeta. The far sideband has imaginary part near `2γh` and section `four` 4's `norm_S_le_far` bounds it super-exponentially in `h`, so the single-sideband pricing is expected to stand and has not been checked. Block `13j` states the term with both sidebands at an actual zero and is being built.

What the audit adds that neither death saw: a gap-dependent theorem, `L(ε, T, δ)` with `δ` the height distance from the target to the nearest other off-line zero, closes with the existing modules plus block `13j`. It is not the rung, and whether the arrow to the strip can absorb `δ` by treating a tight cluster as one zero is open and unpriced.

**The loop.** Julian asked whether it was working, since the orchestration read as hedging. From the record: the builder's loop worked as designed. Its last four relay runs had first-build error counts of `errors_13f` 3, `errors_13g` 5, `errors_13h` 0 and `errors_13i` 0, every module built, pinned and checked, and every checker passed on every unit. The hedging lived in the orchestrator's prose, which the loop does not gate. Of the `deaths_priced` 3 deaths priced that day, `self_caught` 2 were wrong on their first pass and caught by the same orchestrator afterwards, and none of the three was computed on the tree's own object. `DESIGN.md` at version ten now requires the Objects line to name the lemma that connects the block's quantity to the rung's theorem, and lets a section's mark move only in a commit whose unit computes on that object and names which quantifier a death kills. Those are the two gates the orchestrator's side lacked.

**Decision.** Section `thirteen` 13 is re-marked from DEAD to uniform `L` dead and gap-dependent `L` open, with the escalation argument in its head. Section `fourteen` 14 is re-marked from DEAD to no for one sideband and unverified for the term. Unit 0359's headline is superseded by this unit. Block `13j` is the next module and it is the connection to actual zeros the ladder never made; after it, the size is priced once more on the whole term, and that pricing names its quantifier.
