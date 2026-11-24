---
id: 0513
date: 2026-11-24
type: decision
title: "The facts about zeta proved without RH, ranked by how far each pushes a zero back toward the line"
refs: [lean_stage3/Stage3/ZeroDensity.lean::zero_density, lean_stage3/Stage3/ContourShift.lean::partner_zero, lean_stage3/Stage3/AliasClass.lean::re_order_div_pos, lean_stage3/Stage3/Abscissa.lean::zeroFreeRight_one]
supersedes: []
follows: 0512
context: unit 0512 named the wall's lost factor; Julian asked which input makes the most sense without ignoring zeta, whether the routes converge or return, and for the facts about zeta ranked by the room they leave off the line, 2026-11-24
sealed: false
---

**Question.** Which facts about the zeta function in the tree are proved without the Riemann hypothesis, and how much room off the line does each leave the zeros?

**What ran.** One read-only agent read the Stage3 files and the PrimeNumberTheoremAnd files they use. It listed about `facts` 240 unconditional statements in nine groups, `faces` 20 faces equivalent to the hypothesis, and about `pnt_results` 45 results of the dependency. Of those, `pnt_sorry` 1 carries a sorry: the Weil explicit formula in `IEANTN/Kadiri.lean`, which Stage3 names only in a comment. Nothing was computed. EXPLORATORY: no prereg, no verdict.

**The ranking, by the room left off the line.**
- Into the strip: no zeros right of one (`zeroFreeRight_one`), every nontrivial zero strictly inside the strip, none on the real segment. The room is the open strip.
- Paired: every zero has a partner at its height with real part at least one half (`partner_zero`), and the conjugates (`riemannZeta_order_conj`). The room is the right half of the strip.
- Off the line of one: the medium prime number theorem of the dependency, with no sorry, forces a thin zero-free region beside the line of one. The tree does not state it as a fact about zeros. The room is the right half less a sliver that narrows with height.
- Counted: the Riemann–von Mangoldt count and the partial-fraction bound for the logarithmic derivative bound how much room there is, and not where.
- Made rare: `zero_density`, built from growth through the mollified mean and the squares of the zeros, makes the zeros right of any line past one half a power of the height below one in number. Against the full count, almost all zeros lie within any distance of the line. This is the strongest return in the tree.
- Never cancelled exactly: every weight has positive real part (`re_order_div_pos`), which closes the attained and isolated cases.

**Against the wall.** The wall of unit `unit_wall` 512 needs a lower bound on how near the top zeros come to the alias lattice, or a rate for the creep. No fact in the list gives either. Density gives few, summability gives a small total weight, positivity gives no exact cancellation. The step from few to none is what H, the separation and every face supply.

**Missing from the tree, known in the literature.** A zero-free region stated for zeros; the positivity of three plus four cosines plus a cosine; the positive proportion of zeros on the line; convexity and growth bounds of Lindelöf type. None reaches all the zeros.

**The decision.** None taken. The routes converge: every face is equivalent to the hypothesis, and equivalence supplies no proof. A return needs a fact from this list, or one added to it, that leaves no room off the line.
