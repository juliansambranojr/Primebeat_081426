---
id: 0581
date: 2026-11-26
type: motivation
title: "Mirrors on the floor facing the sky: Julian's picture of the zeros mapped onto the annulus, the critical circle and the Nyquist pair"
refs: [lean/Transform.lean::zeros_in_fundamental_annulus, lean/Transform.lean::critical_circle_is_lattice_inversion_mean, lean/Nyquist.lean::nyquist_no_go]
supersedes: []
follows: 0580
context: after reading the multibase prereg, Julian described the zeros as the sky and each base, or basin, as a mirror that shows part of it
sealed: false
---

**Question.** What in the tree does Julian's picture of mirrors facing the sky match, and what does it leave open?

**What ran.** No run. A reading of the picture against the bench tree and the multibase prereg. EXPLORATORY: no prereg, no verdict.

**The picture.** Zero is the sky, all of it, a circle. Each base, or basin, is a mirror on the floor that shows only part of the sky. As more mirrors are placed, more of the sky shows through the composites and the primes, so it always resolves, because it is a cutout of what is already there. Quoted whole in `question.md`.

**What it matches.** The sky as a circle: `zeros_in_fundamental_annulus` maps each nontrivial zero to the power of the base at minus the zero and proves it lands in the ring between the base's inverse and one; `critical_circle_is_lattice_inversion_mean` makes the critical line the one circle at the base to the minus one half. One mirror shows part: `nyquist_no_go`, no single base of the aliased family resolves the first zero. More mirrors show more: the multibase prereg records that a coprime pair collapses the alias sets to one. The cutout: the explicit formula, by which the primes and the zeros fix each other.

**What it leaves open.** The mirrors show an off-line star as faithfully as an on-line one; unit 0580 saw Davenport-Heilbronn's off-line zeros show as a defect. So the picture says the sky is fixed and resolvable. Where the stars sit, on the one circle or off it inside the ring, is what the Riemann hypothesis asks, and the mirrors report it rather than decide it. The multibase test itself, `preregs/multibase_synthesis_v1_20260827.md`, ended inconclusive at its locked ceiling and below its gate on the ramp.

What remains. A statement that makes the mirrors decide, through the primes' own structure, the Euler product, which is proved to keep the stars near the circle in bulk.
