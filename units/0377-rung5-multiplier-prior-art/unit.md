---
id: 0377
date: 2026-11-22
type: result-triage
title: "Rung 5 section 16, item (d): the annihilating device is in the literature (Zhu, arXiv 2608.24827); a uniform explicit support for detection was not found; the positivity half is priced by the same paper"
refs: [lean_stage3/Stage3/WeilDetect.lean::StmtDetect]
supersedes: []
follows: 0376
context: unit 0375 priced an annihilating multiplier for the rung's detection statement and left prior art unsearched; entry 296 of the notebook had already read Bombieri, Yoshida, Burnol, Suzuki, Connes and Consani and the Li side for the statement's shape as of 2026-09-01; Julian asked for the search on 2026-11-22
sealed: false
---

**Question.** Section `record.sixteen` 16 of `lean_stage3/design/rung5.md` makes `record.claims` 2 claims a reader could take as new. (1) The statement: an off-line zero in a box forces Weil's form negative at a support `L(ε, T)` explicit in `ε` and `T` alone. (2) The device: a polynomial factor of the transform vanishing at unwanted zeros, which on the test function is a differential operator and leaves the support alone. Is either already in the literature?

**What was searched.** `record.web_searches` 6 web searches and `record.arxiv_opened` 7 arXiv papers fetched as text, of which `record.arxiv_read_in_part` 4 were read in the sections named below and `record.arxiv_grep_only` 3 were only searched for the terms. arxiv.org is the one host this environment allows, so anything elsewhere is known here only through a search summary and is marked so. The search starts from entry `record.entry_prior` 296 and does not redo it. "Not found" means not found in this.

**Verdict on (2), the device: KNOWN.** Zhu, "Weil positivity in compact windows: a finite reduction, certified two-sided bounds, and a Landau–Widom decay law", `arXiv:2608.24827v2`, section `record.zhu_section` 13.2, builds a test function whose transform is a window times an even polynomial `B` that vanishes at every zero up to a height, and says of the result that those zeros are annihilated by `B`; Paley–Wiener keeps the support in `[−L, L]`. That is the multiplier of section 16. The use differs: Zhu assumes the Riemann hypothesis, annihilates on-line zeros, and wants the form small, to bound the least eigenvalue from above. Section 16 annihilates off-line cluster members around a target and wants the form negative. Entry 296 had also recorded that Connes and Consani impose finitely many vanishing conditions on the transform inside Weil's criterion. A GitHub repository surfaced by search describes a test function vanishing at every zero of `ζ`; it was not opened.

So the block's sentence that the multiplier "is in neither that paper nor this worksheet before today" is true of the two documents it names and should not be read as a claim about the literature.

**Verdict on (1), the statement: NOT FOUND, with one near neighbour.** Danesh, "A quantitative two-interval criterion for the Riemann hypothesis", `arXiv:2611.10726v1`, dated `record.danesh_date` 2026-11-07, proves that a zero to the right of the line forces a normalized Weil cross term, for a pair of test functions on narrow and widely separated supports, above an exponential in the separation, with any exponent below the zero's horizontal displacement. It is a detection theorem for Weil's form with a rate. It holds at arbitrarily large separations, which is a statement about a limit: no separation is named in terms of the zero, and the zero's height does not enter. Kim and others, `arXiv:2607.24830v3`, report numerically that an injected off-line zero at offset `δ` makes a residual grow like `e^{2aδ}`; their status line calls the detection numerically verified. Entry 296's sources stand as it left them: Bombieri's negative eigenvalues for a truncation that is big enough, with no formula for how big, and the Li-side theorems with an explicit index range. The two follow-ups to Alpöge and Furman that were fetched, `arXiv:2609.02882` and `arXiv:2609.15329`, do not treat detection at an explicit support in the terms searched.

What section 16 would add, if its open items hold, is the uniformity: one support for every configuration in the box.

**What the same paper says about the other half.** Zhu's Theorem `1.3`: under the Riemann hypothesis the least normalized value of the form on the window `[−L, L]` is at most `exp(−L·e^L)` for large `L`, and his abstract says a certificate of his type must resolve frequencies up to a threshold that grows doubly exponentially in `L`. Unit `record.unit_price` 0375's supports start at `record.h0_min_unit_0375` 4845375. So the hypothesis of the criterion section 16 aims at, positivity on that support, is beyond any computation of this kind, and its margin, if the hypothesis is true, is smaller than `exp(−L·e^L)`. This does not touch the detection statement. It prices what the detection statement would be used with.

**Decision.** Open item (d) of section 16 is rewritten to these verdicts. Nothing here is a claim of priority in either direction; a referee who knows this literature has not looked.
