---
id: 0395
date: 2026-11-22
type: formalization
title: "LandauPoleDisc.lean: the derivatives of Phi at a regular point are the zeros' contributions up to a Cauchy remainder; block 3b2 of the Landau worksheet, which closes block 3"
refs: [lean_stage3/Stage3/LandauPoleDisc.lean::Phi_taylor_on_disc]
supersedes: []
follows: 0394
context: units 0393 and 0394 gave the local form of Phi at a zero and the general pole subtraction; this unit joins them for ζ, which is the reading of the Taylor coefficients from the zeros that the Landau worksheet's plan sets against the reading from the primes
sealed: false
---

**Question.** Block `3b2` of the Landau worksheet (`landau.md#3b2`). At a point `c` where `ζ` does not vanish, are the derivatives of `Phi` given by the zeros of `ζ` in a disc around `c`, up to a remainder of the disc's rate?

**What was proved.** `module_lines` 113 lines, `theorems_proved` 1 theorem, `defs` 0 definitions, `pins` 1 axiom pin at `axioms` 3 axioms, `sorries` 0 sorries.

`Phi_taylor_on_disc`: let `c ≠ 1` with `ζ(c) ≠ 0`, and `0 < R < R₂` with the closed disc of radius `R₂` about `c` inside `Re s > 0`. Then there are a finite set `P` and a number `C` such that `P` is exactly the set of zeros of `ζ` in the open disc of radius `R₂` other than the point one, and for every `k` the `k`-th derivative of `Phi` at `c` differs from the sum over `ρ` in `P` of `m_ρ/(ρ(1−ρ))·(−1)^k·k!·(c − ρ)^(−1−k)` by at most `k!·C/R^k`. Here `m_ρ` is the order of the zero.

The zeros in the closed disc are finitely many by upstream's lemma; unit `unit_local` 0393 gives the simple pole at each and the regularity at one; unit `unit_sub` 0394 subtracts them and bounds what is left.

**What is and is not here.** This is the reading from the zeros. Unit `unit_primes` 0390 is the reading from the primes: the same derivative, for `Re c > 1`, is an integral of `G` against a power of the logarithm. Both now stand as theorems about the one function `Phi` at the one point.

`C` is not explicit: it is a bound for the pole-free part on a circle, obtained by compactness. It does not depend on `k`, which is all the plan's comparison of exponential rates uses. A real zero in the unit interval is allowed and enters the sum like any other.

Nothing here compares the two readings. That comparison, with the window bound on `G` and the choice of `c`, `R`, `R₂` and `k`, is the assembly.

**The build.** `errors_first` 0 error lines on the first build, `builds` 1 build, `traps_added` 0 rows, `assumed_pins` 0. Module at `jobs_module` 8725 jobs, package at `jobs_package` 8786. `steps_skipped` 2 steps of the loop, the orient hook and the scratch pass. Loop version `loop_version` 22.

What remains. The assembly of the criterion from the proved blocks: the centre and radii chosen from a hypothetical zero to the right of `θ`, the nearest zeros as the set `P`, their sum made real and fed to the lemma on exponential sums, the window bound and the two tails bounding the reading from the primes, and the two tail rates that are so far a hand computation in the worksheet.
