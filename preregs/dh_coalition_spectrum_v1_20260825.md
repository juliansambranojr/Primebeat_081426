# Prereg — does the DH-weighted prime residual carry L(s,χ)'s zeros or DH's own? (v1)

STATUS: **LOCKED**

## Background

`notes/lab_notebook_2.md` entry 163 records the reasoning, dated before
this prereg was written, and this test exists to fire against it.

Entry 161 established that the Davenport–Heilbronn function is
assembled from this bench's own primes: with `χ` the order-4 character
mod 5 — `χ = (1, i, −i, −1)` on classes 1..4, taking 2 as the
primitive root — the DH coefficient sequence `(1, τ, −τ, −1)` is
exactly `c·χ + c̄·χ̄` with `c = (1 − iτ)/2`, and
`τ = (√(10−2√5) − 2)/(√5 − 1) = 0.28407904384…`, the positive root of
`τ² + (1+√5)τ − 1 = 0`.

Entry 163's consequence, stated there before any run:

```text
psi_DH(x) = sum_n Lambda(n) a(n mod 5)
          = c * psi(x, chi) + conj(c) * psi(x, conj chi)
```

Each term is governed by the zeros of `L(s,χ)` through its own
explicit formula. DH's own zeros are the locus where the combination
`c·L + c̄·L̄` vanishes — a statement about relative phase, not about a
counting function — and so should be **absent** from prime data.

Entry 162 located DH's zeros (`O80_dh_zeros.py`,
`results/dh_zeros.json`): on the critical line up to `t = 60` by
winding count, with the lowest at `5.0941598`, and off-line at
`(σ, t) = (0.808517182457, 85.6993484854)` and
`(0.650830080610, 114.163342731)`.

The two target lists are **disjoint**, which is what makes this test
decisive rather than ambiguous. Computed for this prereg and locked in
§ Locked parameters: no zero of `L(s,χ)` with `|t| < 40` lies within
`0.01` of any DH on-line zero in the same range.

## Primary hypothesis

**H0.** The DH-weighted prime residual's projection spectrum shows no
preference between the two target lists: peak mass at DH's zeros is
not below peak mass at `L(s,χ)`'s zeros.

**H1.** The residual carries `L(s,χ)`'s zeros and not DH's.
**Predicted direction:** the projection `P(γ)` attains local peaks
above the surrogate band at `L(s,χ)`'s zero heights, and does **not**
at DH's own zero heights.

This is not a foregone conclusion being dressed as a test. If the
factoring in entry 163 is wrong — if the DH sequence is not
`c·χ + c̄·χ̄`, or if the explicit formula for `ψ(x,χ)` does not carry
into this ladder's residual — the spectrum will show peaks at
`5.0941598` and its companions, and H1 is refuted. That outcome is
live and is the reason the disjointness above was checked first.

## Locked parameters

| parameter | value |
|---|---|
| script | `O81_dh_coalition_spectrum.py` |
| ladder | `x_j = 2^(j/4)`, `j` such that `2^(j/4) ≤ 2^30` |
| counting | `ψ_DH(x) = Σ_{p^k ≤ x} log p · a(p^k mod 5)`, exact over a segmented sieve |
| weights `a` | `a(1)=1, a(2)=τ, a(3)=−τ, a(4)=−1, a(0)=0` |
| τ | `(√(10−2√5) − 2)/(√5 − 1)`, gated against `τ²+(1+√5)τ−1 = 0` at `< 1e-20` |
| residual | `e_j = ψ_DH(x_{j+1}) − ψ_DH(x_j)`; no smooth term is subtracted, because `L(s,χ)` has no pole and the main term is zero |
| normalisation | `ê_j = e_j / sqrt(x_j)` |
| window | Hann |
| projection | `P(γ) = |Σ_j w_j ê_j exp(−i γ log x_j)|` |
| γ grid | `0` to `40`, step `0.01` |
| surrogates | 200, amplitude-preserving permutation of `ê` across `j` |
| seed | 2026 |
| target list A | zeros of `L(s,χ)` on the line, `0 < t < 40`: 6.183578, 8.457229, 12.674946, 14.825026, 17.337802, 18.998588, 22.487585, 24.365280, 25.531187, 27.982757, 30.463641, 32.195160, 34.457229, 35.490893, 37.271951 |
| target list B | DH's own on-line zeros, `0 < t < 25`: 5.0941598, 8.9399144, 12.133545, 14.404003, 17.130239, 19.308800, 22.159708, 23.345370 |
| band half-width | `max(0.6, 2π/span)`, the O18/O24 house rule |
| hit criterion | a local maximum of `P` within the band half-width of a target, with `P/median(P) > 5` |

Both target lists were computed before this prereg was locked and are
frozen here; the script recomputes them and must reproduce these
values to `1e-4` or exit.

## Decision rule

Evaluate in this precedence order. Verdict labels are verbatim.

1. `compromised` — if the τ gate fails, or the script's recomputed
   target lists disagree with the locked ones by more than `1e-4`, or
   fewer than 8 of list A's entries lie inside the γ grid, or the
   surrogate band is degenerate (`median(P) = 0`).
2. `coalition_silent` — hits on ≥ 5 of list A's entries **and** hits
   on ≤ 1 of list B's. H1 supported.
3. `coalition_heard` — hits on ≥ 3 of list B's entries. H1 refuted;
   the entry-163 factoring is wrong and must be corrected in the
   notebook.
4. `both` — hits on ≥ 5 of A and ≥ 3 of B. The ladder cannot separate
   the lists; no claim either way.
5. `null` — anything else, including no hits at all.

The mechanical output of this rule may be reported by an agent. **The
verdict line is Julian's to write.**

## Vacuousness check

The criterion can fire in both directions on this instrument, and the
bench has precedent for each.

- `coalition_silent` requires 5 of 15 A-targets to clear
  `P/median > 5`. O18 cleared that threshold at `P/median = 6.95` on a
  two-generator orbit and 16.37 on three; O24 reached 37–69 at
  comparable ladder lengths. The threshold is attainable.
- `coalition_heard` requires only 3 of 8 B-targets. Nothing prevents
  it: DH's zeros are real numbers in the same range as A's, the grid
  covers them, and the band rule treats both lists identically. If the
  residual contained DH's spectrum, this fires.
- `null` is live: the ladder is `2^(j/4)` to `2^30`, giving 120 blocks,
  and a non-detection at this length would not be surprising — O18's
  single-base ladders returned NULL at comparable lengths.

The disjointness of the two lists (no pair within `0.01`, against a
band half-width of at least `0.6`) is what prevents a hit on one from
being scored as a hit on the other. Bands of half-width 0.6 around
adjacent A and B targets can overlap; where a local maximum falls
inside both, it is scored for **neither**, and the count of such
ambiguous peaks is reported.

## Provenance

- The DH zero locations (list B) were computed and inspected before
  this prereg, in entry 162 and `results/dh_zeros.json`.
- The `L(s,χ)` zero locations (list A) were computed while drafting
  this prereg and are recorded above. No projection spectrum of the
  DH-weighted residual has been computed by anyone at any point.
- The residual itself has never been built. `ψ_DH` appears nowhere in
  the tree before this prereg; O79 computed class **counts**, not the
  von Mangoldt-weighted sum, and did not project anything.
- Blind arm: the entire measurement. Julian has seen the reasoning
  (entry 163) and the two target lists, and no spectrum.

## Run record

- `run_start_at`: `2026-08-26T01:23:25.572010+00:00`
- `run_end_at`: `2026-08-26T01:23:33.934505+00:00`
- gates: τ residual `-1.694e-21` (pass); list A recomputed, 15 zeros,
  matches the locked values (pass); list B as locked, 8 zeros.
- ladder: 119 blocks, log-x span `20.448`, band half-width `0.6000`,
  `median(P) = 1.5523`.
- surrogate `P_max/median`: median `2.593`, p95 `3.468`, max `4.352`.
- **hits on list A** (`L(s,χ)` zeros), `P/median > 5`: **0 of 15**,
  ambiguous 5.
- **hits on list B** (DH's own zeros), `P/median > 5`: **0 of 8**,
  ambiguous 3.
- mechanical decision-rule output: **`null`** — the fifth branch,
  "anything else, including no hits at all."
- The instrument did not separate the hypotheses at this ladder
  length. Neither H1 nor its refutation is supported; § Vacuousness
  check anticipated exactly this ("`null` is live … a non-detection at
  this length would not be surprising").
- results artifact: `results/dh_coalition_spectrum.json`
- `post_compute_sha256` of that artifact:
  `eec3c729a1e6a154660c787804ac5e8cabd250a90272b78cdc56b1b670599820`
- sidecar match: `preregs/dh_coalition_spectrum_v1_20260825.sha256`
  pins this file **as of locking, before this Run record was filled**,
  at `9f500ecd2eb81ce7b9615a62c2db94e4e5d2ad51775548e87af8d9d6c1f044d7`.
  Per `preregs/FORMAT.md` a locked prereg is immutable except for its
  Run record, and this block is that record; the file's hash now
  necessarily differs from the sidecar, and that difference is this
  block. To verify, restore the `(fill at run)` placeholders and
  re-hash.
- **`verdict`:** *(Julian's to write)*
