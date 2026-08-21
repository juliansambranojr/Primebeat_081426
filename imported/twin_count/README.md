# imported/twin_count — import manifest

Seven files copied byte-for-byte (`cp -p`) on 2026-08-21 from
`~/GitHub/twin_count/`, every one SHA-256 verified source-vs-destination at
copy time. Same discipline as `imported/lattice_mapper/`; see CONTEXT.md.

**Why it is here.** `twincount.c` streams primes to `10^11` in 16.8 s with
primesieve, which is what showed O17's ceiling was a sieve limit rather than a
mathematical one — the observation that produced O50. And
`twins_1e11_analysis.json` carries a self-deprecation of its own α estimator
for a linear-sampling defect of the same class as O48's fixed depth window.
See notes entries 79 and 80.

**Source state at copy time:** not a git repository, no commitment files.
This import is the only versioned copy that exists.

| file | bytes | mtime | sha256 |
| --- | --- | --- | --- |
| `analyze_twins.py` | 19903 | 2026-08-16T23:01:39Z | `e9caeb6363e7a29ea1a30c299f9416ba581130a8b01208f79e9a47b753c76f4a` |
| `twincount.c` | 2560 | 2026-08-16T21:37:31Z | `2c084e4c9aab996ab2febd83acbc6a6c945aac61a0f203fc0f659eea0d255cbe` |
| `twincount_run.log` | 40 | 2026-08-16T21:48:48Z | `b82afba03075038986a27cdf8be2a7cd4cc24c526807e1cfdf8c3910883c65a6` |
| `twins_1e11.csv` | 214409 | 2026-08-16T21:48:48Z | `56927cc2ef046496eb8145a58c5a9bc1c4d204d3486c90d9182507d2bb7d2e1b` |
| `twins_1e11_analysis.json` | 8281 | 2026-08-16T23:01:48Z | `db6435441417b3c1d90f3149fbd8266785df151c646f509de025bea492a7197e` |
| `zeros1.txt` | 1800000 | 2026-08-16T21:54:46Z | `3436c916a7878261ac183fd7b9448c9a4736b8bbccf1356874a6ce1788541632` |
| `twin_residual.png` | 140301 | 2026-08-16T23:01:48Z | `ab040d5c014314c8e1004c32c0c0369dd8e96d6b6bafbcd14ccb63544ac36608` |

## Deliberately not imported

`twincount` — the compiled binary, 33976 bytes. Machine-specific
(`-march=native`) and rebuildable from `twincount.c` with
`gcc -O3 -march=native twincount.c -o twincount -lprimesieve`. Same judgment
as `lattice_mapper/archive_unsilenced/`: binaries do not belong in an
evidence import.

## What each file is

- `twincount.c` — counts twin primes to N, writing `pi_2(x)` at dense
  checkpoints; primesieve iterator, flat memory. Run of record:
  `pi_2(10^11) = 224376048` in 16.8 s.
- `twins_1e11.csv` — 10,000 checkpoints, `x,pi2`, linear step `10^7`.
- `analyze_twins.py` — excursion analysis of `R(x) = pi_2(x) − 2·C2·Li_2(x)`,
  a phase-randomised surrogate on crossing clustering, and a
  power-at-zeta-zeros test.
- `twins_1e11_analysis.json` — its output. `zeta_power_ratio = 0.347` where
  1.0 is no signal, `surrogate_p = 0.973`, 164 crossings, 108 excursions,
  `alpha_decade_rms_ratio = 0.462`. **Carries its own retraction**:
  `alpha_peak` is marked `deprecated: True` at `r² = 0.015`.
- `zeros1.txt` — 100,000 imaginary parts of the zeta zeros, a superset of
  this bench's `zeros600.json`; first three agree to 9 dp.
- `twin_residual.png`, `twincount_run.log` — figure and console record.

**Convention note.** `twins_1e11.csv` is sampled on a LINEAR ladder (step
`10^7`), not a geometric one. Every in-repo artifact uses geometric rungs.
The two do not compare without naming which is in force, and that difference
is exactly what `alpha_note` deprecates itself for.
