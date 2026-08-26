# Prereg — does the DH-weighted prime residual track `L(s,χ)`'s zeros in aggregate? (v2 of the question, v1 of this design)

STATUS: **LOCKED**

## Background

`preregs/dh_coalition_spectrum_v1_20260825.md` asked this question with a
per-target hit criterion on a single geometric ladder, returned `null`,
and was stamped `null` with the design retired (lab_notebook_2 entry
171). Two things have happened since, and this prereg exists because of
both.

**The aliasing is understood and removed.** `lean/Nyquist.lean` (entry
172) proves that a `b`-adic ladder cannot IDENTIFY a frequency past
`π/log b` — there is always a strictly-smaller-modulus alias. O81
sampled `2^(j/4)`, Nyquist frequency `18.129`, against targets running
to 40: half the grid was unidentifiable in principle. This design uses
the pooled incommensurate orbit `{2^m 3^n}`, which is unevenly spaced
and has no such wall. That is O18's escape, and O18 is why it is known
to work.

**The power is measured, not assumed.** Entry 171 recorded the format
defect O81 exposed: the vacuousness check asks whether a rule can fire
in both directions and never whether the instrument can make it fire.
O83 (entry 173) then sized single-zero detection on this orbit and
found it deaf — `1.46×`, `3.72×`, `6.11×` the amplitude the explicit
formula gives a zero. O84 sized the aggregate statistic below and found
it powered. **This prereg quotes that measurement; see § Power.**

Entry 163's factoring is the hypothesis under test:
`psi_DH(x) = c·psi(x,χ) + conj(c)·psi(x,conj χ)` with `c = (1 − iτ)/2`,
so the residual should carry the zeros of `L(s,χ)` and not DH's own.
The two lists are disjoint: no pair within `0.01`.

## Primary hypothesis

**H0.** The residual does not track list A more than list B:
`D ≤ 0` in expectation, where `D` is defined below.

**H1.** It tracks list A and not list B. **Predicted direction:**
`D > 0`, exceeding the permutation null's 95th percentile.

Refutation is live and is a distinct branch: if the residual carried
DH's own zeros, `D` would fall below the null's 5th percentile, and
entry 163's factoring would be wrong.

## The statistic

For a residual `v` on the orbit, with Hann weights `w`:

```text
P(γ)      = |Σ_j w_j v_j exp(−i γ log x_j)|
med       = median of P over γ ∈ [0.5, 40], 1600 points
score(L)  = mean over γ ∈ L of P(γ) / med
D         = score(list A) − score(list B)
```

## Locked parameters

| parameter | value |
|---|---|
| script | `O85_dh_aggregate.py` |
| orbit | `{2^m 3^n ≤ 2^30}`, sorted, exact integers |
| counting | `ψ_DH(x) = Σ_{p^k ≤ x} log p · a(p^k mod 5)`, exact segmented sieve |
| weights `a` | `a(1)=1, a(2)=τ, a(3)=−τ, a(4)=−1, a(0)=0` |
| τ | `(√(10−2√5) − 2)/(√5 − 1)`, gated against `τ²+(1+√5)τ−1 = 0` at `< 1e-20` |
| residual | `e_j = ψ_DH(x_{j+1}) − ψ_DH(x_j)`, no smooth term (`L(s,χ)` has no pole) |
| normalisation | `ê_j = e_j / √(x_j)` |
| window | Hann |
| median grid | `γ ∈ [0.5, 40]`, 1600 points |
| list A | zeros of `L(s,χ)` on the line, `0 < t < 40` — 15 values, frozen in the script and recomputed at run time |
| list B | DH's own on-line zeros, `0 < t < 25` — 8 values (entry 162) |
| null | 400 permutations of `ê` across `j` |
| seed | 2026 |

## Power

Measured before this prereg was written, and this is the number the
design stands on. `O84_aggregate_power.py`,
`results/aggregate_power.json`: inject a mode at every list-A frequency
with amplitude `1/|ρ|` — the amplitude the explicit formula gives a
single zero — and a random phase, into a permuted residual, then ask
how often `D` clears the null's p95.

```text
injected amplitude          power
1.0× (the formula's own)    0.720
1.5×                        0.950
2.0×                        1.000
```

Null under permutation: mean `+0.0056`, sd `0.2095`, p95 `+0.3473`,
over 400 draws, on 307 blocks with residual rms `0.3327`.

**So a `null` outcome from this design is informative in a way O81's
was not.** At the true amplitude the design fires 72% of the time when
H1 holds; failing to fire is therefore evidence, though not
conclusive — roughly a 28% miss rate must be carried in any reading.

## Decision rule

Evaluate in this precedence order. Verdict labels are verbatim.

1. `compromised` — the τ gate fails, or the recomputed list A disagrees
   with the frozen values by more than `1e-4`, or `med ≤ 0`, or fewer
   than 300 blocks are built.
2. `tracks_L` — `D` exceeds the permutation null's 95th percentile.
   H1 supported.
3. `tracks_DH` — `D` falls below the null's 5th percentile. H1
   refuted; entry 163's factoring is wrong and must be corrected.
4. `null` — anything else. Given § Power, this is a weak negative
   rather than a non-measurement.

The mechanical output may be reported by an agent. **The verdict line
is Julian's to write.**

## Vacuousness check

Both directions are reachable on this instrument and the power section
says how often. `tracks_L` fires at 72% under a true signal of the
predicted size. `tracks_DH` requires `D` below p5, which the null
reaches by construction 5% of the time and which a genuine DH-carrying
residual would drive further. `null` is the residual branch and, unlike
O81's, has a quantified miss rate attached.

The lists being disjoint (no pair within `0.01`) is what makes `D` a
comparison of two different things rather than of a set with itself.

## Provenance

- The orbit, the residual construction, and the two target lists all
  predate this prereg: entries 161–164, `results/dh_zeros.json`.
- The power measurement predates it: `results/aggregate_power.json`,
  entry 173's successor.
- **`D` on the real residual has never been computed by anyone.** O83
  and O84 both state in their docstrings that the unblinded statistic
  is deliberately not evaluated, and neither computes it.
- Blind arm: the entire measurement.

## Run record

- `run_start_at`: `2026-08-26T03:59:41.575594+00:00`
- `run_end_at`: `2026-08-26T03:59:48.764292+00:00`
- gates: τ residual `-1.694e-21` (pass); list A recomputed inside the
  run, 15 zeros, matching the frozen values (pass); 307 blocks against
  a floor of 300 (pass); `med > 0` (pass).
- residual rms `0.3327` on 307 blocks of the `{2^m 3^n}` orbit to `2^30`.
- **`D` (observed): `+0.7942`**
- null over 400 permutations: mean `+0.0056`, sd `0.2095`,
  p5 `-0.3408`, p95 `+0.3473`.
- `D` sits at percentile **100.0** of the null — above every one of the
  400 draws, and `(D − mean)/sd = +3.76`.
- mechanical decision-rule output: **`tracks_L`** (branch 2, `D` exceeds
  the null's 95th percentile). H1 supported.
- power at the true amplitude, measured before this prereg was written:
  **0.720** (`results/aggregate_power.json`). The design could fire, was
  known to be able to fire, and fired.
- results artifact: `results/dh_aggregate.json`
- `post_compute_sha256` of that artifact:
  `122ec04ad8325cc04760065b8d01d751b5581d3179ba6b20d3eed50ef90a7cfa`
- sidecar match: `preregs/dh_aggregate_spectrum_v1_20260825.sha256` pins
  this file **as of locking, before this Run record was filled**, at
  `1179f867d80d562b2bc7a3a2994f78a6edad87dc625c2619215fe863e603335e`.
  Per `preregs/FORMAT.md` a locked prereg is immutable except for its
  Run record, and this block is that record; the file's hash now
  necessarily differs from the sidecar, and that difference is this
  block.
- **CORRECTION, 2026-08-25, after the adversarial check.** The
  permutation null above is the WRONG null and the strength figures it
  produced are overstated. Permuting `ê` across `j` makes the spectrum
  flat by construction (`E|Σ c_j ε_j|²` is γ-independent), so the null
  cannot see a γ-trend — and list A's frequencies are systematically
  higher than list B's. The Run record's reasoning that "null mean
  +0.0056 suggests the trend is controlled" is circular. Measured:
  15 random frequencies drawn in list A's own span, scored against the
  real list B, give mean `+0.2344` (sd 0.1742, 20 000 draws), so about
  29% of `D` is trend. Under a range-matched control `D = +0.7942`
  sits at **percentile 99.10, one-sided p = 0.0090, z = 2.34** — not
  percentile 100.0 at `+3.76` sd. The defensible figures are
  **p ≈ 0.007 at 2^30**, and **p = 0.0006** on the `{2,3,5}` orbit.
  The `tracks_L` branch still fires; its margin is smaller than this
  record first stated.
- **A SECOND CORRECTION: the script does not implement the locked
  counting rule.** `psi_dh` never accumulates prime-power mass — the
  `extra` pointer advances while `part` is rebuilt per rung, giving
  `P(x_j) + [E(x_j) − E(x_{j−1})]` instead of `P(x_j) + E(x_j)`.
  Measured against brute force at `2^14`: max error `9.604` for the
  script, `6.4e-14` for a cumulative fix. The defect is identical in
  O83 and O84, which copied it. Numerically the verdict does not move
  (`D` `+0.7942 → +0.8233`, p `0.0090 → 0.0069`), but the locked
  parameter table says `ψ_DH(x) = Σ_{p^k ≤ x} log p · a(p^k mod 5)`
  and the script computes something else. Recorded as a conformance
  defect, not a numerical one.
- **`verdict`: `tracks_L`** — written by Julian 2026-08-25. Branch 2
  fired unambiguously: `D = +0.7942` against a null p95 of `+0.3473`,
  at percentile 100.0 of 400 permutations and `+3.76` sd above the null
  mean, with every gate passed and the power section measured before
  the lock.
- **Scope of the verdict.** It records what the decision rule returned
  and nothing further. Whether this confirms entry 163's factoring —
  the interpretive claim in entry 175 — is held provisional pending an
  adversarial check, commissioned the same date. Four targets named for
  that check: whether a γ-trend in `P` survives the permutation null
  (list A's frequencies are systematically higher than list B's, means
  ~22.4 against ~15.3); whether a RANDOM 15-frequency list would also
  beat list B, which is the control this prereg does not contain;
  whether `D` is distributed across list A or driven by two or three
  targets; and whether `D` reproduces at another ceiling or generator
  pair.
