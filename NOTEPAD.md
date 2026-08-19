# NOTEPAD — Primebeat_081426

One-line index of threads. Newest at top. Append-only by agents; status
transitions ([open] → [paused] / [closed] / [blocked]) are Julian's call.

Format (strict, for grep):

```text
- [STATUS] YYYY-MM-DD  entry N: terse one-line description
```

STATUS is one of: [open], [paused], [closed], [blocked]

Common greps:

```text
grep '\[open\]'                  # active threads only
grep '\[open\]\|\[paused\]'      # everything not closed
grep '2026-08'                   # everything from August 2026
grep 'entry 1'                   # all lines pointing at notebook entry 1
```

## Threads

- [open]   2026-08-19  entry 52: O46/O47 — the `density ~ 1/S` mechanism is REFUTED (parameter-free product spreads 1.4e38, sharper form 5.6 but clusters at 2-3 not 1) and its premise is false, median |cell|/S ~1e-3 across all eleven bases; what replaced it — zeros sit in the extreme thin tail, median S at a zero 8-516 against stratum medians 2.4e7-3.6e18 (5.4 to 17.1 orders); base 2's four carry S = 2/4/88/492384 at pooled ranks 115/102/37/3 of 125, and the biggest gap in the pooled list is the 5.649 break right after rank 3; THE SHARP ONE — at 2^(1/2) the exact factor-2 image of (20,6), cell (40,12), same window (16384,1048576] and the same 80125 primes, reads -6884 not 0, so (20,6) is robust to seed changes (lean/SeedPerturbation.lean, entry 47) and fragile to resolution changes and those were never the same invariance; density DOES rise with b (base 2 max, 3.90x the finest) but NOT monotonically — 4 of 10 adjacent steps fall, Spearman 0.655
- [open]   2026-08-19  entry 51: O45 run — sidecar 7985c940… matches post_compute_sha256, pi audit 33/33 with pi(2^32)=203280221, geometry matches the locked table at all eleven bases, base 2 rebuilds its four through the new code path; Z = 121 resolved sub-2 zeros (240 on the full support), Z* = 35 clearing S >= 88 split family 13 / antiphase 18 / refinement 4, E[Z] = 299.82, conditional-binomial p = 8.394656e-02 exact, Poisson p = 6.367e-32 secondary; mechanical branch is `fineness` and THAT IS NOT A VERDICT — summary.verdict is null and the prereg's Run record verdict line is EMPTY, Julian's to write; eliminates intrinsic_base_two, family_only, refinement_only and thin_rung_forced; WRINKLE — the prereg's lines 5-8 say it is not locked, that is now false, and those lines sit inside the region the sidecar hashes (first 680 lines), so it cannot be fixed without breaking the match — a defect in entry 44's naming convention, not in this protocol, undecided
- [open]   2026-08-19  entry 50: the O45 prereg locked — fineness (sub-2 is finer, so should do at least as well) against intrinsic (sub-2 stays empty), eleven bases at value ceiling 2^32, C_2 = 496 vs C_sub = 37178, E[Z] = 299.82; four complications resolved in the locked text (pair identity only approximate at non-integer b so total_true replaces total_geo, which drifts to 9601 of 19701 cells being <= 0; match by value ceiling not r; (b-1)^(d+1) < 1 below 2 is NOT a reverse magnitude floor since floor jaggedness is O(1) per rung against L1 weight 2^d; antiphase and refinement control arms) — and the section is headed "three" while listing four; THE DISCOVERY THAT SHAPED IT — at the finest base floor(b^r) = 1 for r = 0..6 so cell(2,1) = 0 exactly before any run, making "sub-2 stays empty" already false for reasons unrelated to the hypothesis, hence the resolved-stratum primary statistic; first prereg under entry 44's no-status-in-filename rule; mass_floor 88 and the resolved criterion calibrated on already-inspected base-2 data and disclosed NON-BLIND
- [open]   2026-08-18  entry 49: O44 — base 2 is the only INTEGER base with exact zeros, 4 in 496 resolved cells against base 3's 0 in the identical 496; bases 4-9 all put their minimum nu on the corner cell (max r, max d) so they read the table edge not a floor, and only 5-9 are extent-censored in r_max (base 4 has the full 496 and is simply empty); CORRECTION to entry 17 — its "base 3 reaches 1, twice" is (3,2) and (5,4) where the totals are 8 and 32, so normalised 0.125 and 0.031, NEITHER in base 3's ten smallest; base 3's real closest approach is 2/2048 = 9.766e-4 at (11,10), EIGHT TIMES closer proportionally than base 2's smallest nonzero 1/128 at (13,5) — entry 17's conclusion survives by a route entry 17 did not take; pair identity holds on imported February data, 1289 cells 0 mismatches; UNCHASED — dyadic_diff_full_silenced_32.csv is exactly C_fs - P_fs but satisfies the identity against nothing on disk, best partner 59 mismatches of 410
- [open]   2026-08-18  entry 48: O33 was still reading the EXTERNAL /Users/juliansambrano/GitHub/lattice_mapper/difference_tables/32bit/ after entry 46 vendored those eight base tables in-repo — DEFAULT_DATA_DIR repointed to os.path.join(_HERE, "imported", "lattice_mapper", "32bit"), the house _HERE anchoring O16 uses for `files (2)`, so the repo is portable and lattice_mapper/ moving can no longer break the instrument; three sites, all path, none logic (docstring source paragraph 15-19 -> 15-28, docstring EXAMPLE 194-196 -> 202-205 with its explicit --data-dir dropped, DEFAULT_DATA_DIR 220-221 -> 230-233), script sha256 ffa3d5b7... -> 55e1593b... where the before hash IS run 1's params.code_version; NON-SEMANTIC — run 2 differs from run 1 in 15 metadata leaves of 6429 (3 timestamps, code_version, data_dir, out, out_csv, 8 source_files paths) plus 4 extra params.argv elements, constants/summary/rows blocks BYTE-IDENTICAL across all 210 rows and the run-2 CSV byte-identical to run 1's at sha f71f74b5...; the comparison also AUDITS the import — source_files sha256/bytes/mtime_utc/regimes/n_columns/headers identical at all eight bases, so the vendored copies ARE what the run of record read, proved by the instrument and agreeing a third time with the manifest table in imported/lattice_mapper/README.md (8 of 8, 0 mismatches); run 1 remains the RUN OF RECORD, results/base_ladder_crossing.json untouched at 215,439 B sha a0a07062... and CONTEXT.md's O33 bullet still correctly says its input lived outside this repo at run time — deliberately not edited; new artifacts results/base_ladder_crossing_run2.json, results/base_ladder_crossing_run2.csv and the instrument's FIRST log results/O33_base_ladder_crossing_run2.log; constants.source_project left naming lattice_mapper on purpose (origin, not read path); still EXPLORATORY, no prereg, no verdict
- [open]   2026-08-18  entry 47: is the dyadic (2,1) a cancellation or a seeding artifact? — cell(2,1) is CONVENTION-MOBILE: plain count pi(b^2)-2pi(b) reads 0,0,2,3,5,7,10,14 over b=2..9, the imported excluded-lattice tables read 0,2,4,5,7,9,12,16 (+2 for every b >= 3, 0 at b=2 because 2 and 3 straddle the r=1/r=2 boundary only at base 2), the archive one-prime forward convention reads 1,1,3,4,6,8,11,15 — so NO convention makes it vanish at every base, which is what a pure seeding artifact would do; but silencing manufactures it on demand — triadic 2 -> 1 -> 0 under silence235/silence2357, one decrement per silenced prime landing in (b,b^2], and triadic silence235 grows a fresh exact zero at (10,9); ALL FOUR dyadic zeros survive the convention change — imported/lattice_mapper/32bit/dyadic_difference_table_32.csv returns exactly {(2,1),(4,1),(8,3),(20,6)} in 496 cells and 64bit/dyadic_difference_table_64.csv the same four in 2016 cells to r<=64,d<=63 with 0 overlap mismatches, its A_count matching OEIS A007053 at all 64 regimes and reaching two past pi2n_cache's n=62, a second confirmation beside O43's r=92 census (K_new 0) from other code in another repo though NOT independent in the arithmetic; dyadic_prime_full_silenced_32.csv is value-identical to the plain table on all 380 overlapping cells so it is a duplicate, not a third confirmation; the COMPOSITE side confirms lean/PairIdentity.lean on February data — (8,3)=16 and (20,6)=8192 in all six composite variants, never moving, exactly 2^(r-1-d) at 2^4 and 2^13, while (4,1) reads 4/5/6 across them because the six differ ONLY in A_count at r=1,2,3 and (4,1) reads rows 3-4 while (8,3) reads 5-8 and (20,6) reads 14-20; THE FINDING — the measurable cut is DEEP vs SHALLOW (window position relative to the seed), not four-versus-three, echoing lean/Zeros.lean's window_exclusive_of_prime_exponent ((20,6) base-2 exclusive since 7 is prime) vs window_shared_of_composite_exponent (2^4 = 4^2 leaves (8,3) reachable by base 4) from an independent direction; entry 17's "reaches 1, twice" and "no exact zero in any delta column" VERIFIED TRUE of the file it cites but convention-dependent — under O27's joint table the triadic minimum is 0 at (2,1) and not one of its 820 cells takes the value +-1; DISCLOSED PREDICTION — before the check the assistant predicted 0,0,2,3,5,7,10,14, reproducing the plain-count computation exactly and contradicting every file on disk except base 2; four-versus-three NOT decided, no outcome marked
- [open]   2026-08-18  entry 46: lattice_mapper difference tables IMPORTED — 27 files into imported/lattice_mapper/ (22 from 32bit/ = the complete directory, 4 from 64bit/, source README as source_README.md), cp -p byte-for-byte, all 26 CSVs plus source_README.md RE-VERIFIED against source today, 0 mismatches; closes the provenance gap entry 17 opened — its triadic_difference_table_32.csv lived at /Users/juliansambrano/GitHub/lattice_mapper/difference_tables/32bit/, outside this repo with no pointer in CONTEXT.md or REFERENCES.md, and entry 36 read the same directory for O33 without promoting one; the imported convention is power-regime BACKWARD differences A(n) = pi(b^n) - pi(b^(n-1)) with 2 AND 3 excluded as lattice (difference_table.py:75, silenced_primepi), and it is NOT the convention any in-repo artifact uses (O27 counts them, N_2(1)=1 and N_3(1)=2 per entry 29) so low-r numbers are not comparable across the boundary without stating which is in force; archive_unsilenced/ DELIBERATELY EXCLUDED — three generations, three conventions, two difference directions: forward differences with only 2 dropped (archive_unsilenced/gen_difference_table.py:22-29) plus a third pi_n integer-regime schema in its *_64bit_* files, direction checked from the data not the docstrings; measured at 33 files / 59,069,876 B of which 9 .bin/.hex binaries are 25,339,552 B, so the manifest's "~58 MB of binaries" is the directory total; it stays readable in place at /Users/juliansambrano/GitHub/lattice_mapper/difference_tables/archive_unsilenced/; source_README.md is STALE and flagged not corrected — calls 64bit/ an integer-regime pi(n) table when both imported 64bit/ files are power-regime A_count identical to 32bit/ on all 496 overlapping cells, names 128bit//1000//2pow20/ folders that exist only inside archive_unsilenced/, and states the one-prime convention that belongs to the archive; two same-named silenced_primepi generators, one removing two primes and one removing one, is how it came to describe the wrong set; dyadic_composite_extended_emptied_32_silence46.csv and dyadic_composite_full_silenced_32.csv are BYTE-IDENTICAL in the source (sha a0030692...) and preserved under both names, so six composite variants are five distinct files; lattice_mapper/ verified UNMODIFIED — nothing anywhere under it newer than 2026-08-01, newest under difference_tables/ is 2026-02-11; CONTEXT.md and REFERENCES.md still carry NO pointer to imported/lattice_mapper/, candidate lines reported to Julian, neither file edited
- [open]   2026-08-18  entry 45: pair identity PROVED in Lean — entry 45 lives in ~/GitHub/Primebeat_081426/lab_notebook_2.md (vol 2 opens here; numbering continuous); lean/PairIdentity.lean sha256 0383a9e2…, pair_identity carries NO hypothesis on b and none on P/C beyond the partition, so it is general integer b and the proof never knows P counts primes; corollary (b−1)^(d+1)=1 ↔ b=2 is about the FORM OF THE TOTAL and locates no zero, so entry 17's base-2 discrepancy and entry 26's last-vanishing question BOTH STAND; the four measured composite values 1/4/16/8192 match by decide; #print axioms re-verified, 9 of 12 results Classical.choice-free; lake build 8027 → 8036 jobs (+9), lakefile.toml globs 9 → 10 modules; closes the pair identity in papers/Formalization.md § D5 (the SECOND of its three items, not the first) — the winding and the transform results remain unencoded; file comment lines 80–82 states the global-geometric-row vacuousness WITHOUT the |b| ≥ 2 it needs (false at b=1 and b=−1), recorded not edited since lean/ was out of scope
- [open]   2026-08-18  entry 44: prereg filenames now carry NO status (CLAUDE.md § Prereg discipline, Julian-approved) — sidecar preregs/<basename>.sha256 is the authority, the three existing preregs keep their names; O43 cited the DRAFT path at script lines 6/13/181 and it propagated into run 1's log line 4 and results/extended_zero_census.json params.prereg — fixed to preregs/extended_zero_census_v1_locked_20260818.md, script sha256 2c7f9d8c… → 9f66c9df…, NON-SEMANTIC (run 2 differs from run 1 in 6 metadata leaves of 440, b-file sha256 6f4f5aac… re-fetched byte-identical, every statistic bit-identical); O42 was already clean and its run 3 differs from run 1 in 5 metadata leaves of 1738; runs 1 stand as both preregs' runs of record, sidecar matches undisturbed, O43's verdict line still blank; five lowercase "draft"/"drafting" PROSE occurrences remain in O43 (lines 19/104/175/504/828), none a path, deliberately left
- [open]   2026-08-18  entry 43: O42 cited the DRAFT prereg path at script lines 5/10/417/737, and that path propagated into run 1's log line 4 and results/zero_winding_phase.json params.prereg — fixed to preregs/zero_winding_phase_v1_locked_20260818.md, script sha256 d57e8067… → abd581a5…, NON-SEMANTIC (run 2 differs from run 1 in 5 metadata leaves of 1738, every statistic bit-identical); run 1 stands as the prereg's run of record and its artifacts still print the dead path
- [open]   2026-08-17  O24 pi_at float-key defect fixed — search key floored to an exact Python int, killing a whole-array float64 upcast per call; PERFORMANCE ONLY, prior O24 results remain FULLY COMPARABLE (verified cell-by-cell on two settings, only timestamp/path/sha differ); needs an instrument-fix lab_notebook entry
- [open]   2026-08-17  O24 script sha256 moved 6e2ddd01… → f3525a7f… with that fix — every O24 results JSON on disk records code_version 6e2ddd01…, now a stale pointer even though behaviour is unchanged; decide whether to note or re-stamp
- [open]   2026-08-17  entry 35: results/O24_gen_xmax3e8_run.log is NOT a run — an aborted timing probe killed at the 2-minute mark, which is why it stops mid-G6, copied into results/ from a scratch dir in error; needs relabelling in results/ and entry 35's "G1 through G5 are reported" framing corrected (Julian's call)
- [open]   2026-08-17  entry 34: G4/G5 ratio across the three REAL O24 settings reads 1.35 (1.5e8), 1.53 (1e9), 1.42 (3e9) — it widened then NARROWED, and G5 gained more than G4 between 1e9 and 3e9 (+31.8% vs +22.1%), so the block-size account of the G4 peak is NOT ruled out
- [open]   2026-08-17  entry 34: the claim made in conversation that the G4/G5 ratio widened monotonically across three points was WRONG — it rested on counting the 3e8 timing probe as a data point; there are three real settings, not four
- [open]   2026-08-17  entry 35: O24 at xmax=3e9 COMPLETED 2026-08-17 23:02 (PID 63229, ~2h) — G8 P_max/median 12.039652 (argmax 30.4500, DETECT, gate A PASSED), "SCALING BAND: FALLS", peak stays at G4 38.299307; results/O24_gen_xmax3e9_results.json written, 71341222 B, 203334 rows, gates A/B/C all PASSED
- [open]   2026-08-17  PROVENANCE CONTAMINATION: results/O24_gen_xmax3e9_results.json records code_version f3525a7f… (post-fix) although the process actually executed 6e2ddd01… — _code_version() hashes __file__ at WRITE time and the pi_at fix landed mid-run; numbers unaffected (fix is behaviour-identical) but the stamp names code that did not produce them
- [open]   2026-08-17  entry 36: O33's crossing-slope law ln b/(2 ln ratio) was derived AFTER seeing the data — fits b=2 to 6%, b=3 to 15%, needs an out-of-sample test
- [open]   2026-08-17  entry 40: does the Weil-form balance survive varying the mollifier W and k? nothing is parameter-independent yet
- [open]   2026-08-17  entry 40: recompute the per-prime breakdown of the Weil form on the CORRECTED implementation — the only breakdown on record comes from the buggy file
- [open]   2026-08-17  entry 38: deep cells cannot be tested against the zeros by a truncated explicit formula — a different instrument is needed for d >= 12
- [open]   2026-08-17  entry 35: O34-O38 have hardcoded parameters instead of CLI flags — same defect as entry 28's O30/O31/O32 thread
- [open]   2026-08-17  entry 35: the O24 run at larger xmax launched 2026-08-17 had not reported when these entries were written
- [open]   2026-08-17  entry 32: does the base-3 handover smear near the window where base 2 strikes exactly? 2^7 needs triadic depth 4.42, 2^4 needs 2.52 — neither integer
- [open]   2026-08-17  entry 30: the 7 anchor-dependent cells on the leading diagonal r = d+1 rest on an arbitrary M(1) := 0 — decorative until a better anchor is argued
- [open]   2026-08-17  entry 28: O30/O31/O32 have hardcoded parameters instead of CLI flags — deviates from house convention, wants an instrument-fix pass
- [open]   2026-08-17  entry 29: extend the joint table past r=41 — dyadic data already exists to r=62; the limit is wall clock on pi(3^r), not exactness
- [open]   2026-08-17  entry 31: machine-verify the hand-computed interleaved row sums r=1..6 and extend to r=41 — the intended run was killed before output
- [open]   2026-08-17  entry 31: measure base 3's crossing depth at r=20 against the predicted d ~ 8.5 — falsifiable test of the transfer function
- [open]   2026-08-17  entry 27: entry 26's verdicts were an artifact of its own definitions — redone under Julian's, six items land
- [open]   2026-08-17  entry 27: THE re-seeing — the difference table as a sampling instrument, not as arithmetic
- [open]   2026-08-17  entry 27: OPEN QUESTION — integers force b >= 2 but the threshold is 1.2489; can the number line sample its own residual?
- [open]   2026-08-17  entry 27: OPEN QUESTION — what characterises the residual independent of any grid? (four grids, one spectrum)
- [open]   2026-08-17  entry 27: OPEN QUESTION — which zeros does depth d select for? (comb filter, response (1-b^-rho)^d)
- [open]   2026-08-17  entry 27: OPEN QUESTION — is 28 decimals per unit depth a law or a range artifact? (later question than Connes')
- [open]   2026-08-17  entry 27: new = old things seen a new way; generative = poses new questions. Bibliographic novelty is the wrong test
- [open]   2026-08-17  entry 27: method note — this instance oscillated inflate/deflate all session; both avoid a clean judgment
- [open]   2026-08-17  entry 26: THEOREM AVAILABLE — under RH, Delta^d pi(2^n) != 0 for r > R with R explicit; would settle (20,6) as last
- [open]   2026-08-17  entry 26: THEOREM-SHAPED — Nyquist no-go, b < exp(pi/gamma_1) = 1.2489; base 2 fails by 3x
- [open]   2026-08-17  entry 26: THIRD DIRECTION — prove Connes' §6.6 simplicity for a range of lambda; our gap ratio says it is true and not marginal
- [open]   2026-08-17  entry 26: the lemma for any rigorous treatment — depth d multiplies each zero's contribution by (1 - 2^(-rho))^d, exact
- [open]   2026-08-17  entry 26: the table is a construction, not a discovery — elementary operator on OEIS A007053
- [open]   2026-08-17  entry 26: entries 17 and 19 presented as fresh three things already in primebeat/primebeat_lean since Feb-Jul
- [open]   2026-08-17  entry 25: compression has no answer until accuracy is named — 1 zero for 10%, 5000 for +-1 at x=10^4
- [open]   2026-08-17  entry 25: absolute-accuracy crossover at x = 1030; relative targets get CHEAPER with x because psi(x) ~ x
- [open]   2026-08-17  entry 25: psi jumps at prime powers and the explicit formula gives the MIDPOINT — evaluate off-integer or every prime power fails
- [open]   2026-08-17  entry 25: error is non-monotone in K — K_first fires by luck; K_stay is better and still noisy
- [open]   2026-08-17  entry 24: {2,3,5,7} pulls all six zeros out together within 6% at ~26x median — the spectrum, not a peak
- [open]   2026-08-17  entry 24: ceiling is block size — 2604 primes/block at G4, 215 at G8; peak should MOVE with xmax, unverified
- [open]   2026-08-17  entry 24: {11,13,17,19} detects too (5.75 vs 6.95 at matched 238 vs 237 rungs) — the grid is nearly free
- [open]   2026-08-17  entry 24: architect-prime question NOT testable by generator choice — grid is not the signal; silencing is the instrument
- [open]   2026-08-17  entry 24: xmax=1e9 sweep interrupted at G5; G1-G4 all improved, G4 26.73 -> 31.37 — rerun to locate the new peak
- [open]   2026-08-17  entry 23: bridge coordinate WITHDRAWN — three defensible matchings give d = 2.70, 6.40, or a regime
- [open]   2026-08-17  entry 23: each matching yields its own pleasing (8,3) reading — the coincidence was the frame, not the data
- [open]   2026-08-17  entry 23: connes_cvs `c` names the prime set directly (primes <= c, L = log c) — settled from source
- [open]   2026-08-17  entry 23: O19's figure has an arbitrary x-axis; retained as record, not citable as correspondence
- [open]   2026-08-17  entry 23: O20/O21/O22 do not use the bridge and stand as measured
- [open]   2026-08-17  entry 23: what would settle it is a quantity BOTH objects compute — O22 killed the only candidate
- [open]   2026-08-17  entry 22: December alignment CSV reproduces bit-for-bit; 5 of 6 published cells do not
- [open]   2026-08-17  entry 22: Z moves up to 5.68 sigma on seed alone — honest form is Z ~= -18 +/- 1.5, not -17.61
- [open]   2026-08-17  entry 22: more scrambles cannot fix it — Z's denominator is an estimated sd, 7.1% relative error at n=100
- [open]   2026-08-17  entry 22: the "25,000 primes" row used 2,762 primes — build_primes_up_to sieves to a VALUE not a count
- [open]   2026-08-17  entry 21: Beat vs Connes at the identical window {2,3,5,7,11,13} is a factor of 10^53
- [open]   2026-08-17  entry 21: restoring the log p weight moves the Beat 1.4x — the accuracy is variational, not in the weighting
- [open]   2026-08-17  entry 21: O22's Gate A failed — |B| has 101 local minima in t=[10,50], canyons are envelope not minima
- [open]   2026-08-17  entry 20: T has a validity window with TWO failure modes — form not yet positive below, precision above
- [open]   2026-08-17  entry 20: doubling dps buys exactly one more doubling of T; the window slides, it does not widen
- [open]   2026-08-17  entry 20: lambda_1 is NOT converged — 9.1% then 8.3% per doubling; earlier extrapolation withdrawn
- [open]   2026-08-17  entry 20: the fallback "largest T that completed" ran two c-sweeps at a dead parameter — design fault
- [open]   2026-08-17  entry 19: bridge coordinate lambda = 2^((d+1)/2) — matching by window ratio, a choice not a theorem
- [open]   2026-08-17  entry 19: (8,3) lands at lambda=4 whose window is exactly {2,3} — the mod-6 lattice, unforced agreement
- [open]   2026-08-17  entry 19: (20,6) sits ONE PRIME short of the window Connes computes in
- [open]   2026-08-17  entry 19: Connes' open question measured — 2.19e-55 at c=13 to 5.49e-120 at c=29, ~28 decimals per depth
- [open]   2026-08-17  entry 19: his §6.6 unproved hypothesis (simple + even minimum) holds — gap ratio never below 3.96e7
- [open]   2026-08-17  entry 19: the gap uses a REPLICATED V_even projector, not a public API — connes_cvs exposes no lambda_2
- [open]   2026-08-17  entry 19: matplotlib 3.11.1 + 9 transitive deps installed today, unpinned — third addition, still no lockfile
- [open]   2026-08-17  entry 19: Groskin / arXiv:2605.20224 appear nowhere in Connes' reference list — connes-cvs provenance gap
- [open]   2026-08-16  entry 17: depth transfer function is |1 - b^(-rho)| — trend 0.5, gamma_1 1.676, ratio 3.35/depth in base 2
- [open]   2026-08-16  entry 17: (b-1)/b is minimised at b=2 over all integer bases — base 2 suppresses trend fastest
- [open]   2026-08-16  entry 17: BUT triadic reaches 1 twice ((3,2) and (5,4)) and never lands — the magnitude argument does not separate the bases
- [open]   2026-08-16  entry 17: minimal form of the deep zero is Delta^7 pi(2^n) = 0 at n=20 — eight values of pi, no table needed
- [open]   2026-08-16  entry 17: search prior art against OEIS A007053 higher differences, not against "dyadic difference table"
- [open]   2026-08-16  entry 17: the composite balance is the identity restated, not a second finding — all content is in the vanishing
- [open]   2026-08-16  entry 16: H-JOINT holds at x0=2 — L2 NULL, L3 NULL, L23 DETECT at gamma_2 (0.052), L235 DETECT at gamma_4
- [open]   2026-08-16  entry 16: L2 shows EIGHT peaks at identical height spaced 2pi/log2 — the alias comb, measured directly
- [open]   2026-08-16  entry 16: dyadic ladder is not blind, it is AMBIGUOUS — 100th percentile against surrogates, signal smeared across the comb
- [open]   2026-08-16  entry 16: headline flips with x0 (H-NONE at 1000, H-JOINT at 2) — rung count, not structure
- [open]   2026-08-16  entry 16: band rule and surrogate test disagree — surrogate is the better instrument, should have been pre-registered
- [open]   2026-08-16  entry 16: L_irr control has a block with ZERO primes — not a clean separation of irregular-vs-multiplicative
- [open]   2026-08-16  entry 15: prime-power correction closes to 5 decimals — mean(ehat) -0.004378 + mean(D/sqrt x) 0.004600 = +0.000222
- [open]   2026-08-16  entry 15: R lowered the BACKGROUND, did not raise the signal — P_max unchanged to 7 figures, median fell
- [open]   2026-08-16  entry 15: theta stayed at 0.413 where the addendum series' alpha went to 0.4951 — the two instruments disagree
- [open]   2026-08-16  entry 15: trimming the low end kills the detection — span buys detection, so extend the top not cut the bottom
- [open]   2026-08-16  entry 14: FIRST DETECTION — gamma_1, gamma_2, gamma_3 at 14.08, 20.97, 24.98, all inside one resolution element
- [open]   2026-08-16  entry 14: dyadic control NULL on the same primes and same code — aliasing measured, not argued
- [open]   2026-08-16  entry 14: indexing by prime index fixes the count by construction — the fluctuation lives in the VALUES
- [open]   2026-08-16  entry 13: r=2 and r=3 are the ONLY regimes where primes equal composites — 1/1 and 2/2, then composites dominate forever
- [open]   2026-08-16  entry 13: composite zero (3,2) is caused by prime zero (2,1) — the tables agree until (2,1) splits them
- [open]   2026-08-16  entry 13: each table's zeros are the OTHER table hitting 2^(r-d-1) — the two zero sets are dual under one identity
- [open]   2026-08-16  entry 13: (3,2) is a third species of trivial — trivial by smallness of the target, 2^0 = 1
- [open]   2026-08-16  entry 12: centered (skew-adjoint) table has NO exact zeros anywhere — the Hermitian repair costs the zeros
- [open]   2026-08-16  entry 12: backward zero = adjacent repeat; centered zero = gap-2 repeat, and there are zero gap-2 repeats at any depth
- [open]   2026-08-16  entry 12: four backward zeros verified as the ONLY ones to r<=62, d<=61 — past the xlsx's r<=50 spreadsheet ceiling
- [open]   2026-08-16  entry 12: centered identity composite = 3^d * 2^(r-1-d) - prime holds at all 992 cells — 3^d where backward has 1
- [open]   2026-08-16  entry 11: dyadic ladder Nyquist is 4.53 but gamma_1 is 14.13 — the zeros were aliased in every dyadic instrument
- [open]   2026-08-16  entry 11: fine ladder cleared Nyquist (32.96) and still DETECT 0 of 54 — blocks overlap 90%, so no new information
- [open]   2026-08-16  entry 11: the binding limit is ~16 DISJOINT blocks over 8.4M primes, unchanged since O12 whatever the ladder
- [open]   2026-08-16  entry 11: disjoint-block instrument (N -> rN matching the step) is the one design where more rungs means more data — not built
- [open]   2026-08-16  entry 11: theta_rms climbs monotonically to depth 8 and never settles — differencing a log drift, not a power law
- [open]   2026-08-15  entry 10: O9_audit_20260815.html archived in the tree — body verbatim, dated superseded notice inserted
- [open]   2026-08-15  entry 10: the archived page's section 04 analyticity claim is wrong in its strong form — corrected by entry 6's placebo sweep
- [open]   2026-08-15  entry 10: scratchpad is now empty — every artifact from this session's work lives in the tree
- [open]   2026-08-15  entry 10: the page was written for the other instance and cites DT-A11/A12 section numbers not present in this tree
- [open]   2026-08-15  entry 9: O12 and O13 now in the tree — entry 8's "scratchpad only, nothing in results/" caveat is superseded
- [open]   2026-08-15  entry 9: both scripts run twice, generated_utc stripped, byte-identical payload hashes — deterministic
- [open]   2026-08-15  entry 9: params.code_version = script's own sha256, on O12/O13 only — extending it to older scripts still pending Julian
- [open]   2026-08-15  entry 9: O13's gate reads expected values from the O9 fine JSON rather than hardcoding — breaks if that file changes
- [open]   2026-08-15  entry 9: entry 8's "15–16 sig figs" on the block-sum gate is really 14.79–16; gate requires 10, passes either way
- [open]   2026-08-15  entry 9: observed log-log deficit is ~85% of predicted at both σ (−0.034 vs −0.040, −0.070 vs −0.080), not equal
- [open]   2026-08-15  entry 9: o9_audit.html is still scratchpad-only and session-scoped — the only local copy, needs a home or it is lost
- [open]   2026-08-15  entry 9: reproducible-from-script is not versioned — still no VCS, nothing committed
- [open]   2026-08-15  entry 8: fit-free dyadic ratio test gives a = 1 − σ — the block sum is additive, no cancellation at any tested t
- [open]   2026-08-15  entry 8: σ=0 is the discriminating row and reads a = 1.007 — additive, not square-root
- [open]   2026-08-15  entry 8: the SQRT band was mis-designed — at σ=0.5 additive also predicts a=1/2, so the two hypotheses coincide there
- [open]   2026-08-15  entry 8: σ=1/2 not distinguished — a = 1 − σ is a straight line through it, measured with no fit/window/threshold
- [open]   2026-08-15  entry 8: a = 1 − σ is a reflection with fixed point 1/2, but its origin is count-times-size, not the functional equation
- [open]   2026-08-15  entry 8: log-log correction measured at −0.07σ against predicted −σ/log N ≈ −0.083σ — entry 3's mechanism confirmed
- [open]   2026-08-15  entry 8: t = 50, 160, 320 still TRANS at N=256,000 — every large-t exponent in this project is a transient reading
- [open]   2026-08-15  entry 8: smoothness null is a spike not a tail — 58 of 91 centres inside (2.50, 2.60], no T makes the test graded
- [open]   2026-08-15  entry 8: no threshold isolates 0.5 — calling it STRUCTURE requires T<2.5521, which fires 0.51–0.56 and the four edge centres too
- [open]   2026-08-15  entry 8: all four one-outlier exclusions landed on rung N=64000, three at t=40 — not random interference, unexplained
- [open]   2026-08-15  entry 8: both measurements are scratchpad-only under /private/tmp — nothing in results/, no script in tree computes them
- [open]   2026-08-15  entry 8: the fit-free ratio instrument has no home in the tree — wants promoting to an O-script if it is going to be cited
- [open]   2026-08-15  entry 7: O11 fixed and staged UNRUN — launch is ./.venv/bin/python O11_extend_counts.py --rmax 76
- [open]   2026-08-15  entry 7: new system dependency — brew primecount 8.6 at /opt/homebrew/bin/primecount, not in any lockfile
- [open]   2026-08-15  entry 7: r=76 now projects 2.7-4.9h threaded (was 27-46h) — 128-bit penalty never paid, same code path
- [open]   2026-08-15  entry 7: parallel efficiency fell 1532% at n=58 to ~775% at n=63/64 — may degrade further up the ladder
- [open]   2026-08-15  entry 7: primecount memory footprint at 2^76 unmeasured — the one unbudgeted risk in the 3h estimate
- [open]   2026-08-15  entry 7: backend resolved once pre-loop and printed — a mid-run failure stops rather than downgrading to 1 core
- [open]   2026-08-15  entry 7: O11 docstring REQUIREMENTS still says only "pip install primecountpy numpy" — omits brew primecount
- [open]   2026-08-15  entry 7: --estimate returns before backend resolution, so it cannot report which backend a real run would pick
- [open]   2026-08-15  entry 5: O9_run.log ≡ O9_run_default.log is a deliberate preservation copy, not an accidental duplicate
- [open]   2026-08-15  entry 1: O8_run.log ≡ O8_run_dps300.log is likewise deliberate — copied before the dps=150 re-run
- [open]   2026-08-15  entry 5: results filename is fixed with no timestamp or tag — every rerun clobbers unless --out is passed
- [open]   2026-08-15  entry 6: part 3's max_z ceiling is 2.604 across 91 window centres — the 3-sd threshold cannot fire on this data
- [open]   2026-08-15  entry 6: "smooth through 1/2" retracted as evidence — true of the curve, uninformative about the hypothesis
- [open]   2026-08-15  entry 6: σ=0.500 ranks 11/91 (87.9th pct) and is not even a local max — 0.51/0.52/0.53 all read higher
- [open]   2026-08-15  entry 6: t=50 column returns 2.4958–2.5345 at every one of 91 centres — that column is fit geometry, not data
- [open]   2026-08-15  entry 6: max_z dips at centres 0.34, 0.74, 1.15 are the only response to anything — unexplained, not chased
- [open]   2026-08-15  entry 6: log p_N rescue falsified — reparametrization is a constant ×0.866 rescaling and cannot move a zero
- [open]   2026-08-15  entry 6: crossing = intercept÷coefficient, invariant under it: 0.9441/1.0752 = 0.8177/0.9313 = 0.878
- [open]   2026-08-15  entry 6: corrected variable still gives coefficient −0.931 where theory says −1.000 — remainder unaccounted
- [open]   2026-08-15  entry 6: control is misshapen not displaced — per-t crossings 1.177/1.126/0.792/0.491, spread 0.685
- [open]   2026-08-15  entry 6: two well-fitted t columns cross ABOVE 1.0 — no proposed mechanism predicts that
- [open]   2026-08-15  entry 6: r² at σ=0.5 is 0.980/0.964/0.496/0.0004 — t=80 explains 0.04% of its variance, weighted equally in the mean
- [open]   2026-08-15  entry 6: fix the aggregation — weight or drop t columns by fit quality before any further O9 reading
- [open]   2026-08-15  entry 6: ladder is the binding constraint (6 rungs, cap N=4000), not --pmax — above ~68000 pmax buys nothing
- [open]   2026-08-15  entry 5: pre-fix max_z recomputed exactly at 1.997 — the two fixes cancel, verdict never flipped
- [open]   2026-08-15  entry 5: V3 (window fix without ddof fix) reads STRUCTURE at 3.194 — combination never existed in running code
- [open]   2026-08-15  entry 5: part 3 max_z not comparable across the fix, and nothing in the envelope distinguishes pre from post
- [open]   2026-08-15  entry 5: no code_version or git sha in the results envelope — schema change, proposed, pending Julian
- [open]   2026-08-15  entry 5: declared ±0.02 smoothness window behaved as ±0.01 in IEEE double — now ±0.02 as written
- [open]   2026-08-15  entry 5: dg/dr print could have discarded a completed run after parts 1–3 — guarded, never fired in practice
- [open]   2026-08-15  entry 4: O11 call site uses int64 prime_pi — hard stop at n=63; prime_pi_128 is present and is the fix
- [open]   2026-08-15  entry 4: the overflow fails QUIETLY — --rmax 76 exits clean in 3 min looking like a normal run
- [open]   2026-08-15  entry 4: primecountpy 0.2.1 wheel is single-threaded, no set_num_threads, OMP ignored — ~8-10x unclaimed
- [open]   2026-08-15  entry 4: decide target before committing days — r=72 is 3.3h/SE 0.68, r=76 is 27h+/SE 0.61
- [open]   2026-08-15  entry 4: measured cost ratio 1.52/regime vs the script's hard-coded 1.587 — worth updating the default
- [open]   2026-08-15  entry 4: pi(2^58) timing measured outside the script, not in the timing file — reproject after next run
- [open]   2026-08-15  entry 4: O11 is undocumented in all four commitment files, and there is no O10 anywhere in the tree
- [open]   2026-08-15  entry 4: O11 cites DT-A7, DT-A9 §1.4, DT-A10 §2.1, dyadic-table-v2 §7.2/§7.3/§7.4 — none on this machine
- [open]   2026-08-15  entry 4: cache now r=62; O4/O5/O7 have not been re-run against the extended cache
- [open]   2026-08-15  entry 3: re-run O9 part 2 regressing on log p_N not log N — settles the loglog rescue prospectively
- [open]   2026-08-15  entry 3: write the short prereg for that re-run before running it
- [open]   2026-08-15  entry 3: O9 part 2 control failed on its own stated criterion — crossing at 0.881, not 1.0
- [open]   2026-08-15  entry 3: loglog correction predicts slope −1.21..−1.12 over the ladder; observed −1.07 undershoots it
- [open]   2026-08-15  entry 3: intercept 0.943 unexplained by loglog (should be exactly 1.000) — phase cancellation is a second effect
- [open]   2026-08-15  entry 3: "smooth through 1/2" has no stated minimum detectable kink — absence-of-evidence, per O7 prereg's own rule
- [open]   2026-08-15  entry 3: conclusion overreaches — nothing in O9 tests Mellin normalization or the reflection axis
- [open]   2026-08-15  entry 2: repo folded into the research program; backfill against the git scaffold once it lands
- [open]   2026-08-15  entry 2: CONTEXT.md still says "uncommitted scratch bench" — correction proposed, pending Julian
- [open]   2026-08-15  entry 2: six of nine tests unpreregistered — now load-bearing, not bookkeeping
- [open]   2026-08-15  entry 1: folder is not a git repo — no VCS, two .bak files standing in
- [open]   2026-08-15  entry 1: no requirements.txt or lockfile for the 3.14.3 venv (connes-cvs 0.3.1 is the fragile pin)
- [open]   2026-08-15  entry 1: six cited docs missing everywhere — dyadic-table-v2, DT-A/A2/A3/A4, O3c
- [open]   2026-08-15  entry 1: "Prime Beat papers (Sambrano, Jan 2026)" not confirmed as the primebeat_lean notebook paper
- [open]   2026-08-15  entry 1: prereg pre_compute_sha256 still PENDING while Run record asserts it matches post
- [open]   2026-08-15  entry 1: O7 determinism unverified — locked prereg claims byte-identical reproduction, never re-run
- [open]   2026-08-15  entry 1: O9 reports "smooth through 1/2" though its own abscissa lands near 0.85, not 1.0
- [open]   2026-08-15  entry 1: O8 has no results JSON — three logs are its entire record
- [open]   2026-08-15  entry 1: duplicate artifacts — O9_run.log ≡ O9_run_default.log, O8_run.log ≡ O8_run_dps300.log
- [open]   2026-08-15  entry 1: O1/O2/O3b live only in files (2)/ — never promoted, no result JSON
- [open]   2026-08-15  entry 1: O3/O4/05/06/O8/O9 unpreregistered — exploratory, not verdicts
