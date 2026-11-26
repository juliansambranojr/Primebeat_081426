# Prereg — the sediment settles in its own band, out of sample (v1)

STATUS: DRAFT — not locked. Locks on Julian's word; then the text is committed,
then `O99_sediment_bands.py` runs.

## Background

Julian, 2026-11-26: the basins settle as the sediment of primes and composites
arrives. Unit 0583 built `Λ_N(s) = π^{−s/2}Γ(s/2)·Σ_{n≤N} n^{−s} + (same at 1 − s)`,
the completed sum over the first N integers with ζ's reflection, and counted its
zeros right of the line up to height 200. Read by the Riemann–Siegel band
`[2πN², 2π(N+1)²]`, where N terms are the number that belongs at that height, it
found no zero off the line inside the band for N = 1..5, and every off-line zero
outside it. The band split was chosen after seeing those data.

## Primary hypothesis

- H1: for every N = 6..12, `Λ_N` has no zero with `Re s ∈ (1/2, 3]` and `t` in its
  band `[2πN², 2π(N+1)²]`.
- H0: for some N = 6..12, it has at least one.

## Provenance disclosure (required reading)

- The bands for N = 1..5 (heights below about 226) were computed in unit 0583 and
  shaped this hypothesis. They are not reused here.
- **The blind arm is every band for N = 6..12**, heights from 226.2 to 1061.9. No
  value of `Λ_N` at those heights has been computed by anyone in this repository.
- The control strips (the 50 units below each band) are also uncomputed.
- From memory, not checked: this family of truncations has been studied in the
  literature. No source was opened before this lock.

## Locked parameters

| parameter | value |
|---|---|
| N | 6, 7, …, 12 |
| band | `[2πN², 2π(N+1)²]` |
| region | `Re s ∈ (1/2 + 10⁻⁶, 3]` |
| count | winding around strips of height ≤ 5 tiling the band; edges started at spacing 0.05, subdivided to change of argument < 0.3 per segment |
| control | the same count on `[2πN² − 50, 2πN²]` |
| precision | `mpmath`, `dps = 20` |
| script | `O99_sediment_bands.py`, no flags |

## Decision rule (locked before data)

- `compromised` — some strip's winding is more than `10⁻³` from an integer, or a
  band count is negative. The count is broken; no verdict.
- `does_not_settle` — at least one of the seven bands holds a zero off the line.
- `settles` — all seven bands hold none.

Precedence: `compromised` > `does_not_settle` > `settles`.

## Vacuousness check

A census with no null; no power is needed (`preregs/FORMAT.md` item 4). The count
can find off-line zeros: unit 0583 found 1 to 19 of them below the bands with the
same instrument, and the control strips report the count just below each band. Both
outcomes are reachable: a single in-band zero in any of seven bands fires
`does_not_settle`.

## Falsification

`does_not_settle` says the out-of-band pattern of unit 0583 does not hold at
N = 6..12, so the sediment does not settle its own band in this form. `settles`
says it holds for these seven bands; it does not test larger N or say anything
about ζ itself.

## Compute

Minutes to an hour: about 170 strips for the bands and 70 for the controls.

## Reproducibility

Deterministic, no flags. Output `results/O99_sediment_bands.json`.

## Lock chain

- `lock_written_at`: (fill at lock)
- `pre_compute_sha256`: (fill at lock)
- `locked_by`: (fill at lock)
