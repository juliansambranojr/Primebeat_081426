---
id: 0616
date: 2026-11-27
type: decision
title: How far Kronecker-Weyl reaches in the deep corner: rarity of zeros under RH and LI, never their absence
refs: [lean/Capstone.lean::only_four_zeros_outside_corner24]
supersedes: []
follows: 0615
sealed: false
---

**Question.** A deep-corner cell is a leader plus a sum of near-harmonic terms whose phases drift linearly with the row (unit 0615, harmonic-alignment): an almost-periodic function of the row. How far does the theory of such functions, Kronecker–Weyl and its form for the prime count, reach toward keeping every corner cell off zero?

**What ran.** An assessment from the standard theory, cited from memory and not looked up this session: Kronecker–Weyl equidistribution, Besicovitch almost-periodic functions, and Rubinstein and Sarnak's limiting distributions for the prime count (`Rubinstein-Sarnak:1994`). One computation, `run/reach.py`, by `run/run.sh`, through `lab run`: whether a single zero takes over the corner in the root-square sense as the depth grows.

**What it gives.** Under RH and the linear independence of the zeros' heights over the rationals (LI), extended here to their offsets from the harmonics, the row-by-row phases of the near-harmonic family equidistribute. The family's squared sizes have a finite sum (unit 0612, rest-cancellation), so the cells along a fixed depth are values of a Besicovitch almost-periodic function with a continuous limiting distribution. A cell's normalised value falls within ε of zero at a rate about ε, and since a cell's size grows exponentially, the expected number of exact zeros past the computed rows is a convergent sum. That is the heuristic of unit 0599 (offline-threshold), with its mechanism.

**Where it stops.** Three places. A continuous distribution makes a zero rare; it does not forbid one at a single integer row, and forbidding it at every cell needs a lower bound on the sum row by row, of the kind Baker's theory gives for finitely many logarithms and nothing gives for infinitely many terms with frequencies not proved independent. LI is itself unproved. And the theory works at a fixed depth as the row goes to infinity, where the corner has only finitely many cells; the corner is infinite along the diagonal where depth grows with the row.

**No single zero takes over along the diagonal.** The root of the others' squared weights over the leader's, over a hundred thousand zeros: `reach.K100000.d10.rest_rms_over_leader` 0.9583 at depth ten (leader `reach.K100000.d10.leader` 14.135), `reach.K100000.d100.rest_rms_over_leader` 1.445 at a hundred (`reach.K100000.d100.leader` 40.919), `reach.K100000.d1000.rest_rms_over_leader` 1.064 at a thousand (`reach.K100000.d1000.leader` 49.774), `reach.K100000.d10000.rest_rms_over_leader` 1.1723 at ten thousand (`reach.K100000.d10000.leader` 276.452) and `reach.K100000.d100000.rest_rms_over_leader` 2.3116 at a hundred thousand (`reach.K100000.d100000.leader` 1473.02). Over two thousand zeros the same depths give `reach.K2000.d10.rest_rms_over_leader` 0.9463, `reach.K2000.d100.rest_rms_over_leader` 1.4266, `reach.K2000.d1000.rest_rms_over_leader` 1.0416, `reach.K2000.d10000.rest_rms_over_leader` 1.0181 and `reach.K2000.d100000.rest_rms_over_leader` 1.92. The rest stays at least the leader's size and grows past it.

**Decision.** Kronecker–Weyl explains, under RH and LI, why zeros in the deep corner should be vanishingly rare, in agreement with the data. It does not prove there are none. What would is a lower bound for these almost-periodic sums at every cell along a diagonal whose leaders keep changing, which is beyond current methods. That is the precise form of the open problem in `Capstone.OpenCorner`.
