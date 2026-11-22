---
id: 0383
date: 2026-11-22
type: run
title: "G(y), the smoothed von Mangoldt sum of the Landau window criterion, measured exactly to 1e8; the bench's zeros reproduce it; EXPLORATORY"
refs: [none]
supersedes: []
follows: 0382
context: Alpöge's note of 2026-11-20 names an archive of Lean files claiming the Riemann hypothesis; its last analytic step is a criterion that turns a one-sided bound on one function of the primes, G, on long windows, into a zero-free half-plane; Julian asked on 2026-11-22 for G to be measured on the bench alongside formalizing that criterion
sealed: false
---

**Question.** What does `G(y) = Σ_{n≤y} Λ(n)(y/n − 1) − y log y + (1+γ)y` look like on the bench's range, do the bench's zeros reproduce it, and what constants would the criterion's windows need here?

**What this is not.** EXPLORATORY. No prereg governs it and nothing below is a verdict. The criterion speaks about arbitrarily large `Y`; a computation to a finite height can neither establish nor refute its hypothesis, and the Riemann hypothesis is verified elsewhere far past this range. This unit measures an object and checks the instrument.

**What ran.** `run/gmeasure.py`, through `lab run`. A sieve to `gmeasure.N` 100000000 gives `Λ(n)` at `gmeasure.prime_powers` 5762859 prime powers, of which `gmeasure.primes` 5761455 are primes. `G(n)` is then exact at every integer, in extended precision. It is compared with the identity `G(y) = Σ_ρ y^ρ/(ρ(1−ρ)) + log 2π − T(y)`, where `T` is the trivial zeros' term, evaluated over the bench's `gmeasure.zeros` 600 zeros at `gmeasure.samples` 3882 log-spaced integers.

**What it shows.**

The size. With every zero on the line the identity bounds `|G(y) − log 2π + T(y)|` by `K√y`, `K = 2 + γ − log 4π = ` `gmeasure.K` 0.0461914. Over every integer from `2` to `10⁸` the bound is violated `gmeasure.bound_violations` 0 times. The least value of `G(n)/√n` is `gmeasure.ratio_min` -0.019429, at `n = ` `gmeasure.ratio_min_at` 319439; the largest is at `n = 2`, where `log 2π` dominates. Past `10⁴` the ratio stays inside about half of `±K`.

The zeros reproduce it. The table's zeros carry `gmeasure.mass_table` 0.0441558 of `K`; the remainder, `gmeasure.tail_mass` 0.0020356, is the most the zeros above the table can add. The largest difference between `G` and the prediction is `gmeasure.residual_max` 0.000164 in units of `√n`, beyond that tail in `gmeasure.residual_over_tail` 0 samples, and the correlation is `gmeasure.correlation` 0.999994. So the bench's pipeline and this identity agree, sign and constant.

The windows. At `δ = ` `record.delta` 1 the criterion's windows are `[Y, Y²]`. On `[10⁴, 10⁸]` the least `C` with `G(y) ≤ C·y^θ` is `gmeasure.C50_Y10000` 0.03405 at `θ = 1/2`, `gmeasure.C45_Y10000` 0.05954 at `θ = 0.45` and `gmeasure.C40_Y10000` 0.14173 at `θ = 0.40`. At `θ = 1/2` the constant falls from window to window and settles under `K`, as it must if the zeros are on the line. At `θ = 0.40` it rises from the third window to the fourth, from `gmeasure.C40_Y1000` 0.13071 to `gmeasure.C40_Y10000` 0.14173: below one half no constant can hold for ever, and the range is just long enough to see the turn.

**One error on the way.** The first run's gate failed at one integer, `n = 2` (`gmeasure.bound_violations_without_T` 1 violation). The bound as first written left out `T(y)`, which is under `0.05` there and negligible afterwards. The term is in the identity and now in the bound; the script's docstring says so.

**What it is for.** `G` is the first object on this road that the bench was built to measure: an integer-and-logarithm sum over prime powers. The criterion it belongs to is being formalized in Stage 3 from scratch (`lean_stage3/design/landau.md`). Unit `record.unit_bridge` 0382 gave the Weil form a prime side; this is a second, smaller arithmetic statement of the same kind, one function and one inequality.
