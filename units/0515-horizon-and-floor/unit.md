---
id: 0515
date: 2026-11-24
type: decision
title: "The horizon and the floor: the zeros as sign changes of Hardy's function against the phase of the factor at infinity, and the mollifier as the composites that raise the floor"
refs: [lean_stage3/Stage3/MollifiedMean.lean::f_eq, lean_stage3/Stage3/ZeroDensity.lean::zero_density, lean_stage3/Stage3/BandJoin.lean::spiralLink_iff_middle]
supersedes: []
follows: 0514
context: after the merge of the ladder route, Julian asked whether the work is number theory or a theory of how systems scale from a unit to a collective, and described the zeros as a horizon line and a steep wall, the primes coupled with their composites as raising the floor, and a new basin once a threshold is reached, 2026-11-24
sealed: false
---

**Question.** Which objects of analytic number theory are the horizon, the floor, the threshold and the basins of Julian's picture, and which of them does the tree already hold?

**What ran.** Nothing was computed. This is a reading on paper, made here and unchecked by anyone else, with a search of the tree, of its dependency and of Mathlib for the objects named. EXPLORATORY: no prereg, no verdict.

**Unit and collective.** The Euler product is a law from unit to collective: each prime gives a local factor that sees its own multiples, and the product over all primes is zeta. The explicit formula reads it both ways, primes to zeros and zeros to primes. Coupling bases on the ladder adds local factors; coupling every base is the whole product, which is why every lens ends at the face `NoRunaway`.

**The horizon.** The completed function has one more local factor, the gamma factor at the infinite place, which Mathlib holds as `Gammaℝ` with `completedRiemannZeta` and its functional equation. On the critical line it gives a smooth phase that every height shares and no prime perturbs.

**The threshold and the basins.** On the line zeta is that phase times a real function, Hardy's function. Each sign change of Hardy's function is a zero exactly on the line. The zero count is the phase over pi, plus one, plus the argument of zeta over pi. The phase's share is the threshold count: each rise of the phase by pi calls for a new basin. The argument's share is the primes' local fluctuation. The hypothesis says every threshold is met by a sign change. An off-line pair of zeros is two missed sign changes, where the primes held the function on one side past a threshold.

**The floor.** The method of Levinson and Conrey multiplies zeta by a mollifier, a Dirichlet polynomial over the integers up to a length, the primes with their composites. It evens out the size of zeta so that its dips stop hiding sign changes. A longer mollifier gives a larger proportion of zeros on the line. No known length gives all of them; that gap is the hypothesis again. The tree builds a mollified zeta in `MollifiedMean` and uses it for `zero_density`, and never to count sign changes.

**What is not in the tree or its dependencies.** Hardy's function, the phase of the gamma factor on the line, a count of sign changes, and the mean values of the mollified function on the line that Levinson's method needs.

**The decision.** None taken. The design block S10 of `lean_stage3/design/stencil.md` states the open items in this frame.
