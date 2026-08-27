# Prereg — do the aliased arms, jointly, attribute the mode to γ₁ against their own alias sets? (v1)

STATUS: **DRAFT**

## Background

`lean/Nyquist.lean` proves no single base in the aliased sub-family
resolves γ₁: `nyquist_no_go` applies to every `b_j = exp(πj/(4γ₁))`
with `j > 4` at `γ = γ₁`, and `base_bound_of_resolvable` caps a
resolving base at `exp(π/γ₁) = 1.2489`, which is family member `j = 4`
exactly (entry 199). The theorems quantify over the infinite rung set;
finite data is strictly weaker, so the per-arm floor holds a fortiori.

Entry 211's CRT computation: arm `j` confuses `ν = γ/γ₁ ≡ ±1
(mod 8/j)`, the residues differ per arm, and any coprime pair of
aliased arms collapses the joint alias set to `ν ≡ ±1 (mod 8)` —
nearest confusable `7γ₁ = 98.94`, outside the scan band. Non-coprime
{6,8} keeps `3γ₁` in-band and {7,9} carries a near-alias inside the
finite resolution; both are excluded by construction.

The question with content is therefore ATTRIBUTION: does the joint
periodogram place the mode at γ₁ and above every frequency that some
single arm cannot distinguish from γ₁ — while each arm alone, on the
same π values, shows its alias comb as the theorem requires?

The earned claim is an instrument/sampling result about one field
under many foldings — never a new arithmetic detection of γ₁, whose
presence at these scales O17/O50 already measured (entry 211's
shared-field pricing, which is load-bearing for any citation of this
result).

## Primary hypothesis

**H0.** The joint union of aliased arms carries no attribution power
beyond its members: the joint periodogram either fails the detection
gate or its peak does not dominate the per-arm fold images of γ₁.

**H1.** The joint periodogram detects at γ₁ and dominates every
in-band per-arm fold image. **Predicted direction:** detection at
`≥ 5×` median with argmax within one halfwidth of γ₁, and `P(γ₁)`
exceeding `P` at every alias-candidate frequency, in the primary
subset — while every single-arm control shows its comb.

## Locked parameters

| parameter | value |
|---|---|
| script | `O95_multibase_synthesis.py --mode real --confirm-real` |
| pipeline | O17/O18 verbatim: blocks `(x_i, x_{i+1}]`, `e = c − ΔR` (R at floor points, dps 50), `ê = e/√x`, Hann, NUFFT grid `[2, 45]` step 0.01, halfwidth `max(0.6, 2π/span)` |
| master lattice | `x_i = ⌊exp(i·π/(4γ₁))⌋`, cache `results/pi_master_lattice_cache.json` (278 sites, ceiling 2^40, backend primecountpy) |
| primary subset | arms {5,6,7,8,9}, x0 = 1000 — 199 union rungs, resolution 0.304 |
| secondary subset | arms {8,9} (sub-average-Nyquist, mean gap 0.247 > π/γ₁) — 84 rungs, labelled column |
| sensitivity columns | arm j = 4 (the boundary member); x0 = 2 |
| detection gate | `P(γ₁)/median ≥ 5` on the primary subset |
| attribution | grid argmax within one halfwidth of γ₁ AND `P(γ₁) > P(γ')` at every alias candidate, exact-frequency evaluation |
| alias candidates | in-band per-arm fold images of γ₁: 2.019 (arm 7), 4.712 (arm 6), 8.481 (arm 5), plus every higher in-band image each arm's comb places in [2,45] as enumerated by the script; 1.571 (arm 9) sits below the band and is reported, not scored; 7γ₁ = 98.94 is outside the band by design |
| single-arm controls | each of arms 5–9 alone through the identical pipeline on the same π values; comb criterion X = 0.10 (an arm is "resolving" iff its argmax is within one halfwidth of γ₁ AND its tallest in-band fold image < 0.90·P(γ₁)); justification: measured comb ratios on synthetics are identically 1.0000 because the noise aliases with the signal, so X = 0.10 carries ~4 orders of margin |
| secondary readout | dominance (threshold-free: γ₁'s off-grid P beats every candidate), reported as a labelled column, not part of the rule |
| surrogate ensemble | 200 random-phase draws through the identical pipeline, seed 2026, reported as calibration, not part of the rule |
| {8,9} shared-class note | under {8,9}, 1.571 and γ₁ share arm 9's entire alias class; argmax landings on shared-class frequencies are tallied `g1_image`, per the shakedown |

## Power

Measured before this draft, on synthetics only — the union residual
vector is unread. Shakedown (`results/multibase_shakedown.json`,
entry 212): at 199 rungs and σ = 0.042 (O18's measured rms, the
placeholder this rule inherits), detection-gated attribution runs
0.010 / 0.925 / 1.000 at `A/σ = 0.5 / 1 / 2`; threshold-free
dominance 0.935 / 1.000 / 1.000. In-band alias plants attribute to
themselves at ≥ 0.96 and are never stolen by γ₁. The must-confuse
check at 7γ₁ confuses, as the CRT requires. O18's empirical bracket:
detection at 237 rungs, failure at 108; 199 sits between, nearer the
success point with better resolution (0.30 vs ~0.53).

The marginal regime is `A/σ ≈ 0.5`, where the gate goes silent; that
is what the `inconclusive` branch is for, and the ceiling ramp is
priced: ≈227 union rungs at 2^44, ≈255 at 2^48.

## Decision rule

Evaluate in precedence order. Labels verbatim.

1. `compromised` — any single-arm control fires the X = 0.10 comb
   criterion (the theorem says it cannot; the pipeline would be
   manufacturing the distinction), or the cache fails its spot audit,
   or the union rung count differs from 199, or any recomputed
   geometry gate fails.
2. `joint_attributes` — the primary subset passes the detection gate
   AND the attribution condition. H1 supported.
3. `misattributed` — the detection gate passes but the argmax sits at
   an alias candidate, or `P(γ₁)` fails to dominate some candidate.
   H0 supported, informatively: the joint mechanism failed while the
   signal was present.
4. `inconclusive` — the detection gate fails. Not a verdict on H1;
   the recorded next step is the ceiling ramp.

The mechanical output may be reported by an agent. **The verdict line
is Julian's to write.**

## Vacuousness check

All three non-compromised outcomes are reachable. `joint_attributes`
needs what synthetics deliver at `A/σ ≥ 1` (0.925). `misattributed`
is exactly what every single-arm comb produces — images at ratio
1.0000 — so if the joint mechanism adds nothing, the alias candidates
stand at comparable height and the dominance condition fails.
`inconclusive` fires in the measured marginal regime. The rule can
fire in both directions on the measured power surface.

## Provenance

- The master-lattice π cache was built and spot-audited in the
  shakedown (entry 212). π values are public arithmetic; the cache
  has been on disk since 2026-08-27.
- **The blind arm is the union residual vector and every statistic on
  it.** No residual, periodogram, or attribution number has been
  computed on the real field: the shakedown dropped the π rows before
  any statistic, and `--mode real` refuses without `--confirm-real`
  (exit 2, verified).
- γ₁'s presence at these x-scales is prior knowledge (O17, O50, O57)
  and is why the preregistered question is attribution.
- The design agent (entry 211) and shakedown agent (entry 212)
  worked from geometry and synthetics only.

## Run record

(fill at run)

```text
run_start_at:
run_end_at:
mechanical_output:
post_compute_sha256:
sidecar_match:
verdict:
```
