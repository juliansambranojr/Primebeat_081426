# What Didn't Work

Failed predictions, broken instruments, and method errors from this bench. Kept because
the corrections cost more to rediscover than to record, and because a result list without
this one is not a record of what happened.

Source lines cite scripts, logs and notebook entries in `~/GitHub/Primebeat_081426/`.

---

## A · Predictions that failed

**A1.** **Eight-base crossing depths.** Pre-stated before any table was read: bases 2, 3, 5,
7, 8 cross at depths 6, 8.5, 13.7, 17.5, 23.2, and bases 4, 6, 9 never — a clean
`{4,6,9}` split.
`O33_base_ladder_crossing.py`

**A2.** Observed split was `{2,3}` cross, `{4,5,6,7,8,9}` do not. Bases 5 and 7 were fully
testable (ceilings 26 and 21 against predictions 13.7 and 17.5) and never cross.
`O33`

**A3.** Cause: the prediction assumed a fixed crossing depth per base. It grows linearly in
`r`, because the trend runs as `b^r` and the mode as `b^(r/2)`. One row's answer was
treated as the base's answer.
`O33 · b=2 turnaround at d=3 (r=8), d=6 (r=20), d=12 (r=32)`

**A4.** The corrected slope law `ln b / (2 ln ratio)` fits b=2 to 6% and b=3 to 15% — and
was derived after seeing the data. No out-of-sample test exists.
`O33`

**A5.** **The generator peak.** Predicted to move from G4 to G5 or G6 with more data. It has
not moved at 1.5e8, 1e9 or 3e9.
`lab_notebook entries 24, 34, 42`

**A6.** A second claim in the same entry — that all six zeros come up together within 6% at
G4 — is contradicted at 3e9, where G4's spread is 8.56% and G6's is ~1.1%.
`O24_gen_xmax3e9_run.log · lab_notebook entry 42 and CONTEXT.md carry 8.4%, which is wrong`

**A7.** **The bridge coordinate.** `λ = 2^((d+1)/2)`, from equating a cell's window ratio
`2^(d+1)` to Connes' `λ²`. Withdrawn: matching by ratio is a choice and three defensible
matchings exist.
`O19_bridge_figure.py · lab_notebook entry 23`

---

## B · Instruments that broke

> **Provenance note for B3–B9, superseded 2026-08-25.** These figures were
> transcript-derived when this section was written: `O30, O31, O32, O34, O35, O36` and
> `O38` wrote no results file and their console output was never captured, so every
> figure in B3, B4, B5, B7, B8 and B9 traced to `lab_notebook.md` entries 38 and 39 and
> to nothing else in the tree. The instrument-fix pass of `lab_notebook_2.md` entry 148
> gave all nine scripts the house flag set and a results JSON, and re-ran each at
> defaults with zero drift against those entries — so the numbers below are now
> artifact-verified. See `results/weil_calibration.json`,
> `results/weil_form_balance.json`, `results/weil_form_on_stencil.json`,
> `results/weil_bug_diagnosis.json`, `results/zeta_residual_model.json`,
> `results/nearmiss_residuals.json`, `results/silence_scaffold_primes.json`,
> `results/excise_scaffold_primes.json`, `results/excised_gamma_check.json`. The four
> defects remain documented qualitatively in `O38_weil_form_BUGGY.py:38-47`, which is
> frozen evidence and whose numbers are not citable.

**B1.** **Gram series divergence.** Building `π(x)` from the zeros via
`R(z) = 1 + Σ_k (ln z)^k / (k·k!·ζ(k+1))` returned `1.29e+182` for `π(2^20)` against a true
82025. With 120 zero pairs `|ρ·log(2^20)|` reaches ~2772, and the series needs on the order
of that many terms before it converges, against a truncation at 90.
`O34_zeta_residual_model_FAILED.py`

**B2.** Fixed by abandoning the series: `li(x^ρ) = Ei(ρ log x)`, which mpmath evaluates
directly for complex arguments.
`O34_zeta_residual_model.py`

**B3.** **The Weil form, four defects at once.** Arithmetic side 452.83 against a spectral
side of 2643.50 — ratio 5.8378, stable to four digits across zero counts. A stable ratio
means a systematic normalisation error, not a convergence problem.
`O38_weil_form_BUGGY.py`

**B4.** The four: **(a)** mollifier centred at `s = 0` instead of `s = 1/2`, breaking
`H(s) = H(1−s)` — H(0.3)/H(0.7) = 0.99933, and H on the critical line carried a 2.4%
imaginary part that the `re()` calls silently hid; **(b)** real-space weights missing a
factor `b^(m/2)`, so `f` was not even — f(log 2) = −2340.07 against f(−log 2) = −4680.15,
exactly the factor `b`; **(c)** real-space kernel a triangle, transform `sinc²`, against a
`sinc⁴` symbol — inconsistent by one whole factor; **(d)** archimedean term entering with
the wrong sign, and its integral truncated at `|t| < 120` where `|t| < 3000` is needed,
worth 3.87 on its own.
`O38_weil_bug_diagnosis.py`

**B5.** All four were found only after an independent implementation was **calibrated on a
known case first** — modulated Gaussians, including one where prime (0.4620476309) and
archimedean (0.4620476476) cancel to eight digits and the residue still matches the zero
sum.
`results/weil_calibration.json`

**B5′.** The "agreeing to 1e−18" figure this section carried applies to two of the three
settings, not all three: the zero-versus-arithmetic differences at 600 pairs are
`−5.09918e−18`, `−2.69945e−22` and `−3.75333e−15`. The third has always sat at the
`e−15` scale, on the original code and on the 2026-08-25 re-run alike, against an
arithmetic side of order `1e−8`. Recorded because the sharper number was the one
quoted.
`results/weil_calibration.json · lab_notebook_2.md entry 148`

**B6.** Calibrating before diagnosing was the skipped step. The original work went straight
to the hard case and then tuned conventions against a number it could not check.
`B3 + B5`

**B7.** A direct test that would have caught three of the four — comparing the Fourier
transform of the real-space `f` by quadrature against `H(1/2+it)` — was never run. It fails
outright on the original objects: 1326.80 − 623.47i against 1003.79 + 24.48i at γ₁. After
the fixes it agrees to 1e−22.
`O38_weil_bug_diagnosis.py`

**B8.** **The truncated explicit formula fails at depth.** Past `d ≈ 12` it does not
converge — at (25,21) it reads −296433 with 200 zero pairs and +27793 with 600. Sign flip,
not slow convergence.
`O35_nearmiss_residuals.py`

**B9.** Cause: the depth operator spreads zero gains over `(d+1) × 0.765` decades — 11.5 at
`d = 14`. The sum is dominated by whichever alias-comb-peak zeros fall inside the cutoff,
and adding zeros keeps changing which those are. Truncation error is amplified by depth
rather than averaged out.
`B8 · gain bound [1−b^(−1/2), 1+b^(−1/2)]`

**B10.** **`pi_at` performance defect.** `np.searchsorted` called with a Python float key
against an int64 array, forcing a full recast per call — 12.1 ms at 50M primes against
0.0013 ms with an integer key. Latent through every O24 run; cost the 3e9 sweep two hours.
`O24_prime_generator_orbit.py, fixed 2026-08-17, performance-only, prior results comparable`

---

## C · A defect in the record-keeping itself

**C1.** `_code_version()` reads the script's sha256 at **write** time, not at import time.
Any edit landing mid-run therefore mislabels the result.
`lab_notebook entry 42`

**C2.** This happened. `O24_gen_xmax3e9_results.json` records the post-fix hash while the
process executed pre-fix bytes. The numbers are unaffected — the fix is behaviour-identical
— but the field does not identify the code that produced them.
`C1`

**C3.** CONTEXT.md previously stated that `code_version` means "a result identifies the code
that produced it". That guarantee does not survive a mid-run edit. Reading the hash at
import would close it.
`CONTEXT.md, corrected 2026-08-17`

**C4.** Every earlier O24 results JSON records a hash that no longer resolves to any file.
`C2`

---

## D · Method errors

**D1.** **Writing the record from summaries instead of artifacts.** Every provenance error
on 2026-08-17 traces to this: describing files from agents' reports rather than opening
them. `results/O24_gen_xmax3e8_run.log` was recorded as a previously unrecorded artifact
found in a scratch directory; it was forty minutes old and belonged to a running agent. The
3e9 log was recorded as truncated; it was a run still executing.
`lab_notebook entries 35, 42`

**D2.** The patch made it worse. Amending entry 35 introduced both misreadings more firmly
rather than correcting them, because the amendment was written from the same source.
`lab_notebook entry 42`

**D3.** Routing a write through an agent satisfies the rule about who edits a file and does
nothing about where the content came from. Verification has to be an instruction in the
brief, not an assumption from the routing.
`D1 · briefs that included a verification step caught errors; briefs that didn't, didn't`

**D4.** **Converting observations into searches.** Told twice that a structural observation
was not a hunt, and twice designed a search anyway — the row-sum extension to r=41, and a
base-4/base-8 zero search after being told there is only one deep zero.
`lab_notebook entry 33`

**D5.** **Calling a relation in the table a coincidence.** The table is Pascal and `π` and
is fully determined; chance is not available as an objection to anything in it. The correct
and much narrower objection is that base 10 appears nowhere in the construction, so a
relation visible only in decimal spelling is determined by the notation rather than by the
table.
`lab_notebook entry 33`

**D6.** **Editing a script while a run was in flight**, on the reasoning that Python had
already loaded the source. True of behaviour, false of provenance — see C2. The correct
action was to wait for the run to terminate.
`lab_notebook entry 42`

---

## E · Things that turned out to be free

**E1.** The circle of roots in `O39_transform_radius.py` is generic — Jentzsch's theorem
puts the roots of any power series' partial sums on its circle of convergence. Only the
radius carries information, and only against a control.
`Jentzsch 1914 · O39`

**E2.** The 6.7% offset between measured and true radii is truncation, identified as such
because the smooth control shows the same offset — +6.609% against +6.671%.
`O39`

**E3.** `RH ⟺ the annulus has maximal modulus` is an equivalent restatement of the
abscissa-of-convergence criterion. Same difficulty, new coordinates, not a route.
`O39`

**E4.** The Weil balance is a normalisation check, not a test. Summing over known zeros
presupposes they lie on the line.
`O37_weil_form_balance.py`
