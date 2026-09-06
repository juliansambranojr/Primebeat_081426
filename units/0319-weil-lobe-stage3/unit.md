---
id: 0319
date: 2026-09-06
type: formalization
title: WeilLobe.lean: the 2-gamma lobe bounded by integration by parts twice, decaying like (gamma h)^-2
refs: [lean_stage3/Stage3/WeilLobe.lean::SigmaC_eq_ibp, lean_stage3/Stage3/WeilLobe.lean::SigmaC_bound, lean_stage3/Stage3/WeilLobe.lean::lobe_bound]
supersedes: []
follows: 0308
sealed: false
---

**Question.** Rung 4a of the detection ladder (`units/0316` to `units/0318`).
Unit 0318 wrote the transform at the off-line point as the main term
`Σ(εh)`, bounded below in unit 0317, plus a lobe `Σc((ε + 2iγ)h)` at twice
the height. Detection needs the lobe small against the main term. Entry 302
has it decaying like `(hγ)⁻³` for a smooth envelope. Can a decay be proved
in Stage 3 with crude constants?

**What ran.** `lean_stage3/Stage3/WeilLobe.lean`, new, `module_lines` 255 lines,
imported from `Stage3.lean`. Three build cycles: `errors_first` 9 errors on
the first (derivative proofs in composed rather than lambda form, two
continuity facts unregistered, tactic tails overshooting, a sign fact for
one inequality, the imaginary part's absolute value), `errors_second` 4 on
the second, `errors_third` 2 on the third, then clean. Full package built,
`jobs_package` 8740 jobs. `run/build.log` is the record.

**What it shows.** `theorems_proved` 17 theorems over `defs` 3 definitions
(`q`, `q1`, `q2`, the envelope `x·P(x)` and its two derivatives in half-angle
form), each pinned by `#guard_msgs` to `axioms` 3 axioms, `sorries` 0 sorries.

The envelope vanishes to first order at both ends: `q(±1) = 0` and
`q'(±1) = 0`, from `cos π = −1` and `sin π = 0`. So integrating by parts
twice (`SigmaC_eq_ibp`, with `intervalIntegral.integral_mul_deriv_eq_deriv_mul`
applied to complex-valued lifts of real functions),

    Σc(w) = (1/w²)·∫₋₁¹ q''(x)·sinh(wx) dx,

with no boundary terms. With `|q''(x)| ≤ π + π²/2` on `[−1, 1]` (`q2_bound`)
and `‖sinh z‖ ≤ cosh(Re z)` (`norm_sinh_le`), the general bound
(`SigmaC_bound`) is

    ‖Σc(w)‖ ≤ (2π + π²)·cosh(Re w)/‖w‖².

At the off-line argument `w = (ε + 2iγ)h` (`lobe_bound`): `Re w = εh`,
`‖w‖ ≥ |Im w| = 2γh`, so

    ‖lobe‖ ≤ (2π + π²)·cosh(εh)/(2γh)²,

decaying like `(γh)⁻²`. Two orders of decay where entry 302 has
`decay_order_true` 3; two are enough and crude is the spec.

What this buys the detection lemma: at the off-line point the transform is
`(h/2)·[Σ(εh) + lobe]` with `Σ(εh) ≥ εh/24` and `‖lobe‖ ≤ (2π + π²)·cosh(εh)/(2γh)²`,
so the main term wins once `γh` is large against `1/ε`. Next rung, 4b: the
on-line background bounded above through the same decay and
`JensenCount.zeta_local_zero_count`, the first rung where a sum over zeros
meets the counting theorem.
