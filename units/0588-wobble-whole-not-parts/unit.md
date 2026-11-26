---
id: 0588
date: 2026-11-26
type: decision
title: "Julian's half splits the wobble exactly, and every split loses a factor: the parts grow past the square root and only the whole stays at it"
refs: [lean_stage3/Stage3/HalfSplit.lean::wobble_balance, lean_stage3/Stage3/HalfSplit.lean::harmonic_recursion, lean_stage3/Stage3/HalfSplit.lean::harmonic_by_parts, lean_stage3/Stage3/HalfSplit.lean::wobbleSqrt_of_parts]
supersedes: []
follows: 0587
context: Julian's half (HalfSieve.ignition_is_zeta_zero, the offset one half, minus zeta at zero) measures each rounding of the sieve as a sawtooth; Stage3/HalfSplit.lean (ad2107f to 0c09fb7) proves the split of the wobble along it; this unit records where bounding the parts loses a factor, as the design rule asks
sealed: false
---

**Question.** Measured from Julian's half, the wobble of `HalfSieve` splits exactly into parts (`Stage3/HalfSplit.lean`). Does any split give parts that each stay at the square root, so that `WobbleSqrt` follows from bounding them one at a time?

**What ran.** `run/parts.py`, by `run/run.sh`, through `lab run`. The sieve's products up to N, exact; the split of `wobble_balance` at five sizes of N; the recursion of `harmonic_recursion` and the signed count of `harmonic_by_parts` at two. EXPLORATORY: no prereg, no verdict.

**The whole.** The wobble over the square root is `parts.balance.100000.wobble_over_sqrt` 0.10019056877495071 at N a hundred thousand, `parts.balance.1000000.wobble_over_sqrt` 0.11993950147191298 at a million and `parts.balance.10000000.wobble_over_sqrt` 0.10197671757762683 at ten million. It holds at the square root across the range.

**Split one, the balance and the roundings (`wobble_balance`).** The balance over the square root goes from `parts.balance.100000.balance_over_sqrt` -0.061967902552821676 to `parts.balance.10000000.balance_over_sqrt` -0.9248677929337216, and the centered roundings from `parts.balance.100000.centered_over_sqrt` 0.1621584713277724 to `parts.balance.10000000.centered_over_sqrt` 1.0268445105113484. Each grows faster than the logarithm over the range; their sum is the wobble.

**Split two, the recursion (`harmonic_recursion`).** At a million the first harmonic is `parts.recursion.1000000.harmonic` -178.22561897096762. Each prime's piece sits at the square root of its own scale, the median at `parts.recursion.1000000.median_piece_over_scale` 0.32042012850594914 of it and the largest at `parts.recursion.1000000.max_piece_over_scale` 1.3221260923731848, but the pieces' sizes sum to `parts.recursion.1000000.sum_abs_pieces` 3244.305988415208, and the scales' square roots to `parts.recursion.1000000.sum_sqrt_scales_over_sqrt` 12.653571832637793 square roots, against `parts.recursion.100000.sum_sqrt_scales_over_sqrt` 8.457458743967877 at a hundred thousand.

**Split three, summation by parts (`harmonic_by_parts`).** The sieve's signed count reaches `parts.by_parts.100000.max_abs_mertens_over_sqrt` 2.9187822803354138 square roots at a hundred thousand and `parts.by_parts.1000000.max_abs_mertens_over_sqrt` 6.366 at a million. Its size times the cosine's variation is far above the harmonic.

**The decision.** The step is fine in each split; the size of what the parts add up to fails. Each split loses a factor that grows with N, so `wobbleSqrt_of_parts`, and any bound that takes the parts one at a time, cannot reach the open line. The square root lives in the cancellation between the parts. A route to `WobbleSqrt` has to bound the wobble as one object. Unit 0587 found the same at the cube root, the steps together cancelling against the smooth correction; this unit finds it at three more splits along Julian's half. The theorems stand and their docstrings carry the note (0c09fb7).

What remains. A bound that keeps the parts together.
