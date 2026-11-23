# Joint 10 on the count's own ladder — modes with a tail

Read first after any compaction. Blocks N1 to N3. 2026-11-23. A paper
derivation of one sitting, not yet checked by anyone else.

## What the count's ladder is made of

`p_k = π(2^k) − Li(2^k)`. `PiZeros.pi_eq_zero_sum` writes it with
`piMode ρ x = x^ρ/(ρ·log x) + (1/ρ)·∫₂ˣ t^(ρ−1)/log²t dt`. Its derivative in
`x` is `x^(ρ−1)/log x`. With `w = ρ·log 2`, `z = 2^ρ = e^w`, `t = 2^v`:

    piMode ρ (2^k) = piMode ρ 2 + ∫₁ᵏ e^(vw)/v dv.

For `Im w ≠ 0` put `J_k(w) = ∫₀^∞ e^(k(w−s))/(w − s) ds`, `k ≥ 1`. Its
derivative in `k` is `e^(kw)/k`, so `J_k(w) − J_1(w) = ∫₁ᵏ e^(vw)/v dv`:

    piMode ρ (2^k) = J_k(w_ρ) + c_ρ,    c_ρ = piMode ρ 2 − J_1(w_ρ),

    J_k(w) = ∫₀^∞ (z·e^(−s))^k · ds/(w − s).

So on the count's ladder one zero is a whole radial segment of pure modes
`z·e^(−s)`, `s ≥ 0`, from `z_ρ` in to the origin, with density `1/(w − s)`.
On the ladder of `ψ` it is the single mode `z_ρ`. `|J_k(w)| ≤ 2^(kβ)/(k·|γ|·log 2)`.

## Why the filters of `design/stencil.md` do not carry over

A filter `q` multiplies the mode `ζ` by `q(1/ζ)`. The filter of block S3
vanishes at an accumulation point `p`. For a zero whose mode is near `p`, the
filtered tail is `∫ ζ_s^n·q(1/ζ_s)^m ds/(w − s)` and its size is governed by
`V(ζ) = |ζ|^b·|ζ − p|^a`, which has one saddle, at `ζ = b·p/(a + b)`, on the
ray of `p`, of height `|p|^b·b^b·a^a/(a+b)^(a+b)` up to the normalisation.
Every path from a mode near `p` to the origin crosses that pass. With `a = 1`
and `b` large the pass is `≈ |p|^b/(e·b)`: the pile at `p`, which the filter
removes on the ladder of `ψ`, comes back through the tails at almost its full
rate. A filter with a zero at a point cannot remove a segment.

## The route: the generating function, with slits

In `u = 1/ζ` the tail of `ρ` is the radial slit `{t·u_ρ : t ≥ 1}`,
`u_ρ = 2^(−ρ)`. Put

    E_ρ(u) = Σ_{k≥1} J_k(w_ρ)·u^k = ∫₀^∞ (z_ρ e^(−s) u)/(1 − z_ρ e^(−s) u) · ds/(w_ρ − s),

analytic off the slit; near `u_ρ` it is `−(1/w_ρ)·log(1 − z_ρ u)` plus a
bounded term: a logarithm where `ψ` has a pole.

- **N1.** `piMode ρ (2^k) = J_k(w_ρ) + c_ρ`; `|J_k| ≤ 2^(kβ)/(k·|γ|·log 2)`;
  `|c_ρ| ≤ C/|γ|`.
- **N2, the reduction with a power saving.** Under
  `H_π : |p_k| ≤ C·k²·√2^k`, for `σ > 1/2`, with `θ < 1` the exponent of
  `ZeroDensity.zero_density` at `σ` and `Θ` an upper bound for the real
  parts: `p_k + Σ'_{β≥σ} m(ρ)·(J_k(w_ρ) + c_ρ) = O(k^c·2^(kE))`,
  `E = max(σ, Θ − (1 − θ)) < Θ`. The zeros left of `σ` below height `2^k` by
  `zinv`; the zeros right of `σ` above height `2^k` by the density bound:
  their weights `m/|γ|` sum to `O(2^(−k(1−θ)))`.
- **N3, an exposed mode.** `M(u) = Σ_k u^k·Σ'_{β≥σ} m(ρ)·J_k(w_ρ)` converges
  for `|u| < 2^(−Θ)` and, by N2 and `H_π`, its power series has radius
  `≥ 2^(−E)`. On `|u| < 2^(−Θ)`, `M = Σ' m(ρ)·E_ρ` (Fubini). Call a zero
  `ρ_1`, `β_1 > E`, *exposed* if for some `ε > 0` no other mode value of a
  zero right of `σ` lies in `{ζ : |arg(ζ/z_1)| < ε, |ζ| > |z_1| − ε}`. Then on
  the sector `Ω = {|arg(u/u_1)| < ε, |u| < |u_1| + ε'}` less the slit of
  `u_1` every other slit is at distance `≥ c > 0`, `Σ' m·E_ρ` converges
  locally uniformly, `Ω ∪ {|u| < 2^(−Θ)}` is connected, and the identity
  theorem gives `M = Σ' m·E_ρ` on `Ω`. Along `u = t·u_1`, `t ↑ 1`, the class
  of `ρ_1` contributes `−(Σ_class m/w)·log(1 − t) → ∞` (the class weight has
  positive real part), every other term stays bounded, and `M` is analytic at
  `u_1`. Contradiction.

Statement: under `H_π`, for every `σ > 1/2` there is `E < Θ` such that no
zero with `β > E` is exposed.

## What it covers and what it does not

Covers: the largest real part attained at a mode isolated in angle; modes
right of `E` that are locally outermost in their own direction, which
includes arrangements where the real parts climb to `Θ` without reaching it
along different directions.

Does not cover: every mode right of `E` having other modes further out in
every thin sector around it. The single-ray arrangement
`ρ_n = Θ − c/n + i(γ* + 2πn²/log 2)` is of that kind; there the slits of the
outer modes run through each inner mode. The function is still singular at
each mode when approached from the side, so a sharper form of N3 should
reach it; it is not derived here.
