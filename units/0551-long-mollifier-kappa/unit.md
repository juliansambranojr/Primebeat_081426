---
id: 0551
date: 2026-11-25
type: run
title: "Levinson's floor for long mollifiers, computed: the proportion climbs toward one as the length grows, with the polynomials re-optimized"
refs: [lean_stage3/Stage3/FloorConstLimit.lean::re_dop_tendsto]
supersedes: []
follows: 0550
context: block S13 of `lean_stage3/design/stencil.md`, step B2, computes the main term of the floor for long mollifiers, assuming the mean value holds at that length
sealed: false
---

**Question.** If the twisted moment's error terms held at mollifier length the height to the power theta for every theta, the named input of block S13, what floor would the main term give, with the polynomials optimized at each length?

**What ran.** `run/kappa.py`, Python with numpy and scipy: Young's formula for the constant (his display for c), Gauss–Legendre quadrature in both variables, and Nelder–Mead over the shift and the coefficients, from eight starts. The polynomial P has P(0) = 0 and P(1) = 1. The polynomial Q has Q(0) = 1 and Feng's condition Q′(x) = Q′(1 − x) (Feng's Lemma 1, read this session), written as a constant plus odd powers of one minus twice x. EXPLORATORY: no prereg, no verdict, and nothing here is proved.

**The check.** At Levinson's choice, P(x) = x, Q(x) = 1 − x, theta one half and shift `results.levinson_shift` 1.3, the script gives `results.levinson_check` 0.3427352508802448, the value of `FloorConst.Kfl`'s closed form to its printed digits. At theta four sevenths with cubic P and Q it gives `results.theta_0.5714_cubicP_Qcubic` 0.4086, close to the figure recorded for Conrey's length in the literature, recalled and not checked here.

**What it gave.** With cubic P and cubic Q, re-optimized at each length:
- theta one half: `results.theta_0.5000_cubicP_Qcubic` 0.3651;
- theta one: `results.theta_1.0000_cubicP_Qcubic` 0.5884;
- theta two: `results.theta_2.0000_cubicP_Qcubic` 0.7702;
- theta four: `results.theta_4.0000_cubicP_Qcubic` 0.8872;
- theta eight: `results.theta_8.0000_cubicP_Qcubic` 0.9497;
- theta sixteen: `results.theta_16.0000_cubicP_Qcubic` 0.9777.
With P(x) = x and Q(x) = 1 − x held fixed, the floor peaks at theta one, `results.theta_1.0000_linear_Qlin` 0.5195, and falls below zero by theta four, `results.theta_4.0000_linear_Qlin` -0.0004. So the polynomials have to change with the length, which is Farmer's picture of the theta equal to infinity conjecture (cited in Feng's paper; Farmer's paper not read).

**A slip, recorded.** A first run let Q be any polynomial with Q(0) = 1 and gave a floor near one at theta one half. That Q breaks Levinson's lemma; the run above imposes Feng's condition. The first run's script is kept, and rerun, at `lean_stage3/checks/b2_unconstrained/b2.py`.

**What it says for the goal.** Stage B's main term goes toward one with the length. What stands between is the named input of block S13, the error terms at length beyond one half, and a general Q in the Lean operator.
