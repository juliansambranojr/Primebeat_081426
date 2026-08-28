# Prereg — the floor is deterministic: skirts + density edge on a fresh range

STATUS: LOCKED

Written 2026-08-28. Script: `O97_floor_reconstruction.py`,
sha256 `dabe041210b6b91b4913fdc8b2c5d7891affb8a539f7f5c268151e4166aa5eff`.

## Background and claim

Exploratory record (entries 247–252, all on x ∈ [2, 512]): the quiet floor
of `S(x) = Σ_{0<γ≤T} e^{iγ log x}` is reproduced by two zero-parameter
pieces — prime-power skirts `−(1/2π)·Λ(n)/√n` under the sharp-truncation
kernel, plus the density edge `log(T/2π)/(2π)·e^{iuT}/(iu)` — at
r ≈ 0.997 with residual 0.14% of the floor, the residual traveling with
the truncation boundary. Every number so far is exploratory. This prereg
tests the claim where no one has looked.

## Hypotheses

- **H0**: the reconstruction is specific to the explored range — an
  artifact of its tooth geometry, detrending, or selection — and does not
  reproduce the floor on an untouched range.
- **H1**: the floor is deterministic — the same two zero-parameter pieces
  reproduce it on the fresh range. **Predicted direction under H1: the
  test passes** (thresholds below).

## Locked parameters

| parameter | value |
|---|---|
| zeros file | `imported/twin_count/zeros1.txt` |
| zeros sha256 | `3436c916a7878261ac183fd7b9448c9a4736b8bbccf1356874a6ce1788541632` |
| T (zero cut) | 74920.0 (N = 99,998 zeros) |
| model edge T_edge | 74919.667477 (midpoint of the bracketing zero gap, entry 249's rule) |
| fresh range | x ∈ [512, 2048), u log-uniform |
| grid | M = 4096, half-step offset, `endpoint=False` |
| teeth | all prime powers n ≤ Nmax, weight −(1/2π)Λ(n)/√n |
| kernels | K(u−log n) + K(u+log n), K(w) = (e^{iT_edge·w}−1)/(iw) |
| density edge | log(T_edge/2π)/(2π)·e^{iu·T_edge}/(iu) |
| Nmax ladder | 10^6, 10^7 (final metrics at 10^7) |
| detrend | quartic (deg 4) on both sides, per component |
| quiet selection | per octave {[512,1024), [1024,2048)}: bottom half by cubic-detrended amplitude of the measured side |
| metrics | Pearson r_Re, r_Im on quiet points; median residual / median floor |
| output | `results/floor_reconstruction_fresh.json` |

No other flags exist; the script takes no arguments.

## Decision rule (verbatim labels, precedence order)

Evaluated in this order; the first branch that fires is the output.

1. `compromised` — if any of: zeros sha256 mismatch; quiet-point count
   ≠ 2048; ladder non-convergence (resid/floor at 10^7 exceeds that at
   10^6 by more than 0.005).
2. `floor_deterministic` — r_Re ≥ 0.98 AND r_Im ≥ 0.98 AND
   resid/floor ≤ 0.02, at Nmax = 10^7.
3. `floor_not_deterministic` — r_Re < 0.90 OR r_Im < 0.90 OR
   resid/floor ≥ 0.05.
4. `inconclusive` — anything between.

The mechanical output is printed by the script. **The verdict line is
Julian's to write.**

## Vacuousness check

Both directions are realistic. Pass: the explored range hit r = 0.997 and
0.14%, far inside the thresholds, so if the account generalizes the test
passes with margin. Fail: the fresh range has ~4× the tooth density per
octave of the top explored octave (prime gaps ~log x against a fixed
grid), so the quiet-half selection and the detrend both face geometry
they were never tuned on — if the exploratory success leaned on the
sparse-teeth regime, r drops and the rule fires `floor_not_deterministic`.
The gap between pass (0.98 / 0.02) and fail (0.90 / 0.05) thresholds
leaves `inconclusive` a real region, not a technicality.

## Provenance

- x ∈ [2, 512] on these zeros: fully explored (entries 243–252; scripts
  `landau_deviation.py`, `beat_floor.py`, `floor_reconstruction.py`,
  `floor_residual_limit.py`, `residual_expectation.py`, `edge_shadow.py`).
  Julian and the assistant have both seen all of it.
- x ∈ [512, 2048): **never computed** by any script in this repository.
  This is the blind arm. The zeros file itself is not blind (read many
  times); the blindness is in the x-range.
- Thresholds were chosen before any computation on the fresh range.

## Run record

(fill at run)
