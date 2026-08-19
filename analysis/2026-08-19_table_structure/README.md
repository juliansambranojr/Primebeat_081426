# 2026-08-19 — table structure (exploratory)

Exploratory analysis from 2026-08-19, copied out of a session scratchpad. **No prereg, no decision rule, no verdict** — nothing here may be cited as a verdict, and none of it is part of the O-series; the `t1`–`t14` names are the session's own, not O-numbers, and `t15` was named later by the reconstruction agent, not during the session.

Run with `.venv/bin/python`; requires `primecountpy`, `mpmath`, `numpy`, `matplotlib`. Output paths inside the figure-writing scripts still point at the original scratchpad directory and need editing before a re-run; `t9`–`t14` are console-only and have no such path.

Ceilings differ and **results are not comparable across ceilings** — the explicit formula is asymptotic, so a taller ceiling improves agreement for reasons unrelated to the structure being measured. `t1`–`t4`, `shape32`, `t13`, `t14` use 2³²; `t9` uses 2⁴⁴; `t4_each48`, `t5`, `t6`, `t10`, `t11`, `t12` and `pages/t4_ceilings.html` use 2⁴⁸.

**`t9`–`t15` are reconstructions, not originals.** Those seven analyses were run inline as heredoc commands during the 2026-08-19 session and no script was saved. They were rewritten as scripts afterwards and re-run; the scripts therefore postdate the results they reproduce. See the NOTEPAD lines dated 2026-08-19 for the chronology and for what did and did not reproduce — the line covering the reconstructions documents the original six, `t9`–`t14`; `t15` is recorded separately in its own line.

## Scripts (`scripts/`)

- `spectra.py` — row spectra of the dyadic and triadic tables against the aliased zeta zeros and a density-matched null; nothing fitted.
- `t1_permute.py` — permutation null on the table itself: within-row and whole-table shuffles with the reference lines held fixed at the aliased zeros; z-score plus exact p. Loads `spectra.py` by file path.
- `t2_crossover.py` — per-depth split of row spectral power into DC vs oscillation; the crossover is the first depth where oscillation carries more than half. Bases 2, 3, the sub-integer family exp(πk/2γ₁), and two non-family controls.
- `t3_family.py` — the same crossover measure for bases 2–9 plus four sub-integer bases on one common ceiling; rung count reported per base.
- `t4_residual.py` — measured residual `R(r) = N(r) − [li(bʳ) − li(bʳ⁻¹)]` against a zeta-zero sum `Z(r)` built from `Ei` over 40 zeros, both differenced through the table and correlated depth by depth.
- `t4_family.py` — the same R-vs-Z construction across bases in one summary figure; depths with fewer than ten points dropped.
- `t4_each.py` — the same, one two-panel figure per base 2–9, at ceiling 2³².
- `t4_each48.py` — `t4_each.py` re-run at ceiling 2⁴⁸.
- `t5_2d.py` — 2D FFT over the (r,d) rectangle, since each zero's phase is linear in both axes; marks the predicted (ω_r, ω_d) per zero. Its figure is `spectrum2d.png`.
- `shape32.py` — console-only shape description of the eight base curves at 2³²: where each sags, how deep, and on which side of its own run.
- `t6_multirate.py` — bases 2–9 bound to one number line in the coordinate `u = ln x`, where a zero's frequency is γ with no ln b in it; least-squares periodogram over the combined non-uniform sample set, with each base's own Nyquist ceiling π/ln b marked.
- `t7_phase.py` — lattice phase `φ_b(r,d) = frac((r−d−1)·ln2/ln b)`, the offset of each dyadic cell's lower edge from the nearest b-rung, for bases 3–9 with the four exact zeros circled. Picture only, no null.
- `t8_subzeros.py` — O42's winding-angle question asked of the 121 resolved sub-integer zeros in `results/sub_integer_base_scan.json`, against a base-stratified null drawn from the resolved support; also reports the scale coordinate r−d.
- `t9_subthreshold_ladder.py` — **reconstruction.** Seven bases stepped down through the aliasing thresholds exp(π/γ_k) at ceiling 2⁴⁴; least-squares periodogram in `u = ln x` asking whether each base recovers exactly the zeros beneath its own Nyquist.
- `t10_blocksum_lowpass.py` — **reconstruction.** Checks that base 4's and base 8's rung counts are the dyadic ones summed in pairs and triples, evaluates the boxcar's Dirichlet gain at γ₁'s dyadic alias ω = 2.7689, and counts exact zeros in the dyadic table block-summed at merge k = 1…6.
- `t11_decimation_alias.py` — **reconstruction.** Checks `fold(k · alias(parent)) = alias(parent^k)` for 4, 8, 16, 9, 27, and reports how many full cycles of each alias the ladder actually holds at 2⁴⁸.
- `t12_chain_vs_orphan.py` — **reconstruction.** Oscillatory power fraction at depth 0 for bases 2–9 at 2⁴⁸, grouped as roots (2, 3), chain members with a parent in the set (4, 8, 9) and orphans (5, 6, 7).
- `t13_signflip_crossover.py` — **reconstruction.** The crossover measured without any spectral machinery: fraction of adjacent nonzero pairs whose signs differ, per depth per base at 2³², reported alongside `t2`'s spectral d*.
- `t14_s_matched_control.py` — **reconstruction.** Control for `t8`'s r−d result: the same 121 zeros against a null matched on `ln S`, the L1 stencil mass, within ±0.35 and still stratified per base.
- `t15_cell_coverage.py` — **reconstruction.** How many b-rungs fall inside each dyadic cell's window, bases 3–9 over the (r,d) triangle at r ≤ 32, four exact zeros circled; also the distinct-value count per depth, which shows the measure takes at most two values at any fixed depth and so cannot discriminate.

## Pages (`pages/`) — four, not three

- `orbits.html` — Difference Table Orbits — https://claude.ai/code/artifact/36d3c5d3-155d-4408-bb03-910cd10560c4
- `tests.html` — Four Tests on the Table — https://claude.ai/code/artifact/c352b74e-4b4f-4968-a1cd-1cd1fa3e1f20
- `t4_by_base.html` — Test 04 by Base — https://claude.ai/code/artifact/5974e9b7-1241-4a3f-8d1a-91b4993706f8
- `t4_ceilings.html` — Same Test, Two Ceilings — https://claude.ai/code/artifact/049be425-9f29-49a3-8d9b-01ba3cdd305c

Matched by `<title>` against the artifact listing; the pages carry no URL of their own. `figures/` holds the twenty-four PNGs the scripts wrote — including `coverage.png`, whose analysis was also inline and whose script did not survive; it is reconstructed here as `t15_cell_coverage.py`.
