# The Deep Ladder

O17 was the bench's first detection: the zeta zeros read directly out of the
prime counting residual, on a geometric ladder, at depth zero. It found three of
them and stopped. This paper records that it stopped for a reason that was never
mathematical, and what it does when the reason is removed.

Everything here is **EXPLORATORY**. There is no prereg and no verdict.

---

## A · What stopped O17

**A1.** O17 tiles value space with disjoint geometric blocks
`x_j = x_0 · ratio^j`, counts primes exactly in each, subtracts the smooth
`li` prediction, and projects the normalised residual onto `exp(−iγ log x)`.
Nothing is fitted anywhere.
`O17_disjoint_block_residual.py`

**A2.** Its run of record used `x0 = 1000`, `ratio = 1.1`, `xmax = 150000000`,
giving **125 blocks** over **8407584** primes, and recovered γ₁, γ₂, γ₃ inside
one frequency-resolution element while the dyadic control on the same primes and
the same code returned NULL.
`results/O17_disjoint_block_residual_li_run2.json`

**A3.** The limit was recorded as arithmetic: over 8.4M primes there are only
about sixteen disjoint blocks however the ladder is sampled.
`CONTEXT.md § Current state of the world, O14 / O15`

**A4.** It is not arithmetic. O17 builds its primes with a numpy boolean sieve,
which is what fixes `xmax`. `primecount` returns `π(x)` directly and evaluates
`π(10^11) = 4118054813` in about 4 ms. The ceiling was an implementation.
`A1 · O50_deep_ladder_spectrum.py`

---

## B · The same statistic, 490 times the primes

**B1.** O50 changes two things and nothing else: `xmax` becomes `10^11`, and
`π(x)` comes from `primecount` instead of a sieve. The statistic, the
normalisation and the window are O17's.
`O50_deep_ladder_spectrum.py`

**B2.** Three arms: the replicate at the old ratio and the new ceiling, the
fine ladder the sieve could not reach, and the dyadic control. Nyquist and Δγ
are `π/log(ratio)` and `2π/log(xmax/x0)`, derived rather than printed.

```text
arm              ratio      x0   blocks        primes   Nyquist γ      Δγ
replicate_1.1      1.1    1000      193    4017381387        33.0   0.341
fine_1.002       1.002  100000     6914    4112835107      1572.4   0.455
dyadic_control     2.0       2       35    2874398514         4.5   0.255
```

`results/deep_ladder_spectrum.json`

**B3.** The primary statistic is not a peak list. It is a fixed comparison:
amplitude at the zeta zeros against amplitude at the exact midpoints between
consecutive zeros. A ranked peak list is selection; a fixed grid is not.
`B1`

---

## C · Thirty-eight zeros separated below γ = 120, and the floor rising after

**C1.** On `fine_1.002`, over the 38 zeros in the run's first band and the 37
midpoints between them — the band edge is a parameter of the run, and run 2
lifted it:

```text
amplitude AT the zeros      median 6.905     min 6.478
amplitude BETWEEN them      median 0.189     max 2.341
```

`results/deep_ladder_spectrum.json`

**C2.** **No overlap.** Every one of the 38 zeros sits above the largest of the
37 midpoints; the median ratio is 36.5. O17 found three.
`C1`

**C3.** O17's own ladder improves too. `replicate_1.1` separates six zeros
completely, against three at the old ceiling — the gain from primes alone,
before any change of ratio.
`B2 · C1`

**C4.** The dyadic control still fails: three of its six zeros fall below the
largest midpoint. Its Nyquist in γ is 4.5, so γ₁ at 14.13 is aliased and cannot
be resolved at any prime count. This is O17's finding reproduced at 340 times
the primes.
`B2`

---

## D · The flat amplitude, which is the point rather than a defect

**D1.** The amplitude at the zeros does not fall with γ. It is 6.84 at γ₁ and
6.93 at γ₃₇, flat across the whole range.
`C1`

**D2.** That was read, on first inspection, as fatal — the explicit formula's
`x^ρ/ρ` suggests a `1/γ` falloff, so power should have dropped by a factor
around 68 from γ₁ to γ₃₇.
`D1`

**D3.** The reading was wrong. Over a narrow block `(x, x·r]` a mode contributes
`x^ρ(r^ρ − 1)/ρ`, and `(r^ρ − 1)/ρ → log r` as `|ρ log r| → 0`. The `1/γ`
cancels against the block factor. **Flat amplitude in γ is what a fine geometric
ladder must produce**, and its presence is evidence for the reading rather than
against it.
`D2 · derivation, not from an artifact`

**D4.** The same fact explains an apparent absence. Ranked by peak height on a
flat spectrum, the ten largest peaks are ten zeros chosen arbitrarily among
thirty-eight — which is why the first pass appeared to *miss* γ₁ while finding
γ₃₇. It missed nothing.
`D3 · B3`

---

## E · Why this ladder and not depth

**E1.** The depth operator saturates. Measured across twelve bases, the
per-depth gain reaches the C2 ceiling `1 + b^(−1/2)` at 97.68% ± 2.91%, entered
by depth 1 or 2.
`derived from results/gain_vs_depth.json: median of gain_by_depth at d>=4,
divided by 1+b^(-1/2), meaned over the twelve bases; the ratio is not printed
in the artifact`

**E2.** So differencing is a power iteration that selects whichever mode sits at
the ceiling, and **no depth window exists in which a sub-ceiling mode is
visible**. Any statistic on cells at `d ≥ 1` measures the ceiling, not a
particular γ.
`E1 · Chain.ceiling_dominates_floor`

**E3.** Every detection this bench has made was at depth 0 with the ladder
varied: O17, O18's joint orbits, and O34/O35's 94% at `d = 0` decaying to 80% at
`d = 6`.
`CONTEXT.md § Current state of the world`

**E4.** This paper is that method with the instrument the sieve was withholding.
It is not a new idea; it is an old one at resolution.
`A4 + E3`

---

## F · Not established

**F1.** This is a measurement, not mathematics. The explicit formula already
says the prime residual is built from the zeta zeros. What is shown is that it
is visible at this resolution, and that the earlier ceiling was an artifact.
`stated`

**F2.** No prereg. The separation statistic was chosen after the peak list
proved to be selection, which is exactly the sequence a prereg exists to
prevent. A preregistered version would fix the grid, the arms and the
separation criterion before the run.
`open`

**F3.** Nothing here touches the four exact zeros. Their location remains
underived, and this method is at depth 0 where no exact zero exists.
`The-Four-Zeros.md § A1`

**F4.** Nothing here crosses to the global object. The Euler product converges
only for `1 < Re s`, every statement in blocks B, C and D of the chain lives on
the critical line, and no continuation exists anywhere in this tree.
`Euler-Factor-Chain.md § J5`

**F5.** Run 2 lifted the bound to the whole zero list and banded the result. The
**amplitude at the zeros stays flat across every band** — medians 6.9052, 6.9232,
6.6466, 6.7469, 6.4834 — while the floor between them rises 0.1890 to 3.0449.
Every zero in the list is detected; separation stops after the first band.
`results/deep_ladder_spectrum_run2.json`

**F6.** The floor rises with the midpoints moving closer to their neighbours in
units of resolution — 3.11 elements down to 1.42 across the same bands. That is
leakage from adjacent zeros, and it makes `γ = 120` a property of `Δγ = 0.455`
rather than of the primes.
`F5 · derived from results/deep_ladder_spectrum_run2.json: mean zero spacing per
band over 2·Δγ; not printed there`

**F7.** `Δγ = 2π/log(xmax/x0)`, so the cheapest lever is `x0`. Dropping it from
`10^5` to `10^2` takes the log range from 13.8 to 20.7 and `Δγ` from 0.455 to
0.303, at no extra compute. Halving it needs squaring the range.
`F6 · derived; not printed`

**F8.** Above `γ = 939` nothing has been looked at. The arm's Nyquist is 1572 and
`zeros600.json` ends at 939.0243, so the remaining range is bounded by the zero
file rather than by the instrument.
`B2 · untested`

**F6.** The idea came from outside this bench. `imported/twin_count/twincount.c`
streams to `10^11` in 16.8 s, which is what made the sieve limit visible as a
limit. Its own twin-side result is a clean null — `zeta_power_ratio = 0.347`
against 1.0 for no signal — and π₂ has no proven explicit formula, so nothing
predicted otherwise.
`imported/twin_count/README.md`
