# The Four-Prime Peak

A generator orbit built from the first `k` primes detects the Riemann zeros, and the
detection peaks at `k = 4` — {2,3,5,7} — at every scale measured. What holds, what was
predicted and failed, and what the peak's second property turned out not to be.

Source lines cite scripts and logs in `~/GitHub/Primebeat_081426/`. Nothing here is
preregistered.

---

## A · The instrument

**A1.** `O24_prime_generator_orbit.py` sweeps eight generator sets:
G1 = {2}, G2 = {2,3}, G3 = {2,3,5}, G4 = {2,3,5,7}, up to G8 = {2,3,5,7,11,13,17,19}.
`O24_prime_generator_orbit.py`

**A2.** Statistic: `P_max/median` of the periodogram over the orbit `{Π pᵃ}`, against a
surrogate null. Verdicts WEAK / DETECT.
`O24`

**A3.** The orbit `{2^m 3^n …}` is dense in log-space for two or more incommensurable
generators, so a joint ladder is not a single-rate sampler.
`Furstenberg ×2 ×3`

**A4.** This matters because a single integer ladder aliases: base 2's Nyquist is
`π/log 2 = 4.532`, well below `γ₁ = 14.1347`.
`O18_joint_multiplicative_ladder.py — eight peaks of identical height at spacing 2π/log 2`

---

## B · The peak

**B1.** Three settings run to completion with identical parameters but `xmax`:

```text
xmax      G4       G5     G4/G5
1.5e8   26.73    19.81    1.349
1e9     31.37    20.53    1.528
3e9     38.30    27.06    1.415
```

`O24_gen_to19_run.log · O24_gen_xmax1e9_run.log · O24_gen_xmax3e9_run.log`

**B2.** The peak is at **G4 = {2,3,5,7} at all three**. The scaling band reads FALLS at
all three, with the first decrease at G4→G5.
`B1`

**B3.** Full chain at `xmax = 3e9`: 5.501266, 8.192902, 23.628706, **38.299307**,
27.061132, 18.321235, 14.885732, 12.039652. Gates A, B, C all PASSED; G1 WEAK, G2–G8 DETECT.
`O24_gen_xmax3e9_run.log · results JSON 71,341,222 B, 203,334 rows, n_primes 144,449,537`

**B4.** `results/O24_gen_xmax3e8_run.log` is **not** a fourth setting — it is an aborted
timing probe, killed at two minutes, which is why it stops mid-G6.
`lab_notebook entry 42`

---

## C · What was predicted and failed

**C1.** Prediction on record: the peak moves up to G5 or G6 as `xmax` grows, because the
constraint is block size — same prime range, more generators, so more and smaller blocks
(2604 primes per block at G4, 215 at G8), and past four generators discreteness noise wins.
`lab_notebook entry 24`

**C2.** The peak has not moved at any of the three settings.
`B2`

**C3.** A second claim, that improvement fails at G6, G7 and G8, is contradicted at 3e9 —
those three are the largest gainers.
`lab_notebook entry 34, scoped to the 1.5e8 → 1e9 comparison`

---

## D · What supports the block-size account anyway

**D1.** Per-set gain from `1e9` to `3e9`, monotone increasing in generator count:

```text
G1 −0.7%   G2 +1.4%   G3  +8.4%   G4 +22.1%
G5 +31.8%  G6 +42.0%  G7 +56.6%   G8 +63.3%
```

`O24_gen_xmax3e9_run.log against O24_gen_xmax1e9_run.log`

**D2.** The deeper the set, the more it gains from more data — which is exactly what a
resource-starvation account predicts.
`D1`

**D3.** Therefore C1's mechanism is supported even though C1's prediction failed. The
peak's location and the mechanism are separate claims.
`C2 + D2`

**D4.** Naive two-point extrapolation of D1 puts G5 overtaking G4 near `xmax ≈ 4e11` —
crude, and far beyond what this instrument reaches.
`D1`

---

## E · The second hallmark moved

**E1.** G4's stated distinguishing property was that all six zeros come up together within
6%.
`lab_notebook entry 24`

**E2.** At `xmax = 3e9`, `P_max/median` at γ₁…γ₆:

```text
G4   37.26  36.93  38.30  36.84  35.28  36.76    spread 8.56%
G5   26.17  26.20  27.05  26.23  26.22  26.21    spread ~3.3%
G6   18.12  18.12  18.27  18.22  18.32  18.31    spread ~1.1%
```

`O24_gen_xmax3e9_run.log, "TEN LARGEST LOCAL PEAKS" per set. G4 exact:
37.258633, 36.932107, 38.299307, 36.837708, 35.279641, 36.760192; spread (max−min)/min.
G5 and G6 rows are 2 dp truncations of the log.`

**E3.** G4 still holds the height. "Carries the whole spectrum rather than one peak" is now
**G6's** property.
`E2`

**E4.** G4's own argmax has drifted off γ₁ across the three settings: 14.15, 25.00, 24.99.
`B1 sources`

---

## F · Cost

**F1.** The binding cost was `pi_at` calling `np.searchsorted` with a Python float key
against an int64 array, so numpy recast the whole prime array on every call — 12.1 ms per
call at 50M primes against 0.0013 ms with an integer key.
`diagnosed during the 3e9 run`

**F2.** Fixed 2026-08-17 by flooring the key before the search. Provably identical: no
integer lies in `(floor(k), k]`, so a `side="right"` count cannot move.
`O24_prime_generator_orbit.py, performance-only fix; prior results remain comparable`

**F3.** The fix's docstring records the verification as running the pre-fix and post-fix
scripts on identical flags and comparing the result JSONs cell by cell — byte-identical
apart from timestamps and the recorded `code_version` sha.
`O24_prime_generator_orbit.py:335-336 · the 12.1 ms / 0.0013 ms figures are the docstring's;
the 7.06× end-to-end speedup was timed in a session scratch directory and is not in the tree`

**F4.** The fix landed mid-run. `_code_version()` reads the script's sha at **write** time,
so `O24_gen_xmax3e9_results.json` records the post-fix hash while the process executed
pre-fix bytes. The numbers are unaffected; the stamp is wrong.
`lab_notebook entry 42 · systemic, not specific to this run`

---

## G · Not established

**G1.** Whether the peak ever moves is open. D4's extrapolation is two points.
`D4`

**G2.** Why four generators and not three or five has no account beyond D2, and D2 does not
predict a *peak* — it predicts monotone improvement with data, which is not the same thing.
`open`

**G3.** E3 has not been checked at 1.5e8 or 1e9, so whether the spectrum property was ever
G4's or has always been deeper is unknown.
`open`

**G4.** No prereg. All of the above is exploratory.
`CLAUDE.md § Prereg discipline`
