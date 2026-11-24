---
id: 0514
date: 2026-11-24
type: decision
title: "Coupled bases against the wall: a creep falling like a power of the height is beaten by finitely many bases, given a simultaneous approximation bound; slower creep escapes every finite set"
refs: [lean_stage3/Stage3/BandJoin.lean::spiralLink_iff_middle, lean_stage3/Stage3/Saddle.lean::spiralLink_iff_noRunaway, lean_stage3/Stage3/ZeroDensity.lean::zero_density]
supersedes: []
follows: 0513
context: unit 0512 left the wall needing a separation of the top zeros from the alias lattice; Julian proposed coupling the bases of the tables, dyadic to enneadic, and naming for each rate of creep the number of bases that scale the wall, 2026-11-24; blocks S8 and S9 of `lean_stage3/design/stencil.md`
sealed: false
---

**Question.** If the ladder samples the prime count at the products of several prime bases, and not at the powers of one base, how many bases does it take to stop the wall, for a given rate of creep?

**What ran.** Nothing was computed. Derivations on paper in blocks S8 and S9 of `lean_stage3/design/stencil.md`, made here and unchecked by anyone else. EXPLORATORY: no prereg, no verdict.

**One base at a time.** The tables for the bases from two to nine carry new information only at the primes two, three, five and seven, since the other bases are their powers. On its own ladder each base has its own alias lattice and its own wall. Different pairs of top zeros can serve different bases, so the best single base gains only constants.

**Coupled.** Sampled at the products of two and three, a zero's mode is its pair of powers, and two zeros share it only at equal heights, because the ratio of the two logarithms is irrational. Every alias class is one zero. A pair of zeros near the lattice in both coordinates needs a linear form in the two logarithms to be tiny. Linear forms in logarithms bound that below by a power of the height, with no assumption on the zeros. The bound is not in Mathlib.

**Bases per rate.** With the first few primes as coupled bases, the input is the square-root bound for the prime count at their products, together with a simultaneous approximation bound: no height difference up to the height comes within a power of it of the lattice of every base at once. When the exponent of that power, plus half the density exponent of the top band, is below the exponent of the creep, the wall does not form. Dirichlet's theorem forces the approximation exponent to be at least the reciprocal of one less than the number of bases. That the logarithms of the primes reach it is not proved; linear forms in logarithms give a larger finite exponent.

**The circles.** In the mode, each vertical line is a circle, and the critical line is the circle of `spiralLink_iff_middle`. The zeros right of the line fill the ring outside it toward the line of one. Under H the generating function is analytic exactly inside the critical circle. So the bound sees the ring only from inside, and the critical circle is H's horizon.

**The decision.** A creep falling like a power of the height is beaten by finitely many coupled bases, given the approximation bound. A creep slower than every power escapes every finite set of bases. Covering it needs every prime as a base, which is the square-root bound at every number, `spiralLink_iff_noRunaway`, a face of the hypothesis. The input grows with the number of bases and is not proved for any of them.

**What it is not.** No Lean, no run, no independent check. It does not test the Riemann hypothesis.
