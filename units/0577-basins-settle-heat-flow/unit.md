---
id: 0577
date: 2026-11-26
type: motivation
title: "The basins settle: Julian's picture mapped onto the tree and onto the de Bruijn-Newman flow, where the zeros move and settle onto the line"
refs: [lean_stage3/Stage3/TuringRun.lean::rh_up_to, lean_stage3/Stage3/LittlewoodSharp.lean::littlewood_sharp]
supersedes: []
follows: 0576
context: after the adversary reviews withdrew the basin floor as a route, Julian restated the coupling as basins that settle; the design is `lean_stage3/design/heatflow.md`
sealed: false
---

**Question.** What in the tree does Julian's picture of settling basins match, and where is the process in it?

**What ran.** No run. A reading of the picture against the tree, and a web search for the de Bruijn-Newman constant. EXPLORATORY: no prereg, no verdict.

**The picture.** Coupled basins move no net weight between them, earlier basins calcify, the surface stays at one level, and every zero settles into the half by moving through each basin. Quoted whole in `question.md` and in `lean_stage3/design/heatflow.md`.

**What it matches.** The surface at one half is the functional equation, whose fixed line is the critical line. No net transfer is Littlewood's bound on the integral of S, `littlewood_sharp`, and the local anti-correlation of unit 0565. Calcified basins are the point run, `rh_up_to`. The moving sediment is the Riemann-Siegel sum, which gains a term at each new square.

**The step that changes.** The zeros of zeta do not move with the height, so settling needs a clock. The de Bruijn-Newman flow is one: a heat-equation deformation of Xi with a time parameter, whose zeros are all real from a constant Lambda on. In the picture Lambda is the time every basin has settled, and the Riemann hypothesis is that they had settled at time zero. The search found de Bruijn's upper bound of one half, the Polymath and Platt-Trudgian upper bounds, and Rodgers and Tao's lower bound of zero, so the hypothesis is that Lambda is zero.

What remains. The design blocks: the measurement of the zeros as they move, de Bruijn's theorem in Lean, and an adversary on both before any Lean is built.
