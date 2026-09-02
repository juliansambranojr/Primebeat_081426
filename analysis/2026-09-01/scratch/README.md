# Session scratch — 2026-08-31 / 2026-09-01 / 2026-09-02

These files are session scratch from 2026-08-31, 2026-09-01 and
2026-09-02. They are exploratory. They are unlogged unless a
lab_notebook entry cites them. They were copied verbatim (`cp -p`,
mtimes preserved) from the session scratchpad at Julian's request on
2026-09-02. Nothing here carries a prereg, a decision rule, or a
verdict.

The counterfactual runs — `gamma1_to_14.py`, `line_0_100.py`,
`line_0_100_v2.py`, `line_0_100_v3.py`, `line_sigma.py` — are the ones
entry 294 in `notes/lab_notebook_2.md` refers to as "the
counterfactual runs of this session (γ₁ → 14; re ρ₁ → 0.7 and 2.5;
exploratory, unlogged at Julian's call)". Entry 297 in the same file
cites `line_0_100_v2.py` and `line_sigma.py` by their scratchpad paths
and notes them as "absent from the tree"; this directory is where they
now live.

`final.py` and `sens.py` `sys.path.insert` the old scratchpad path to
import `rebuild_census_price`; run them from this directory (or fix the
path) if re-running.

## Files

Times are the preserved mtimes, local (`-0700`).

| file | mtime | description |
|---|---|---|
| `price_check.py` | 2026-09-01 02:03:47 | "EXPLORATORY price check: does the census arrow survive the UNCONDITIONAL error shape (MediumPNT: \|psi(x)-x\| <= A*x*exp(-c*(log x)^(1/10))) instead of the RH shape (C*sqrt(x)*(log x)^k) that O68's whole grid assumed?" |
| `price_check2.py` | 2026-09-01 02:04:08 | no header; same gate as `price_check.py` with the exponent alpha as a parameter — tabulates the crossover height r for the PNT+ MediumPNT (0.10), de la Vallée Poussin (0.50) and Vinogradov–Korobov (0.60) shapes at c in {1, 0.3, 0.1, 0.03}, d in {1, 3, 6, 10} |
| `rebuild_census_price.py` | 2026-09-01 02:14:25 | "INDEPENDENT rebuild of the census price. Written from lean/Nonvanishing.lean (Ehigh/Mlow/nonvanishing_of) and O68_weak_bound_tolerance.py (R_of, wedge, window floor, O43_EXTENT). Nothing reused from the proposal's scripts." |
| `sens.py` | 2026-09-01 02:15:39 | no header; imports `rebuild_census_price` and sweeps depth_covered over c, A and log2 x0 at the dlVP shape alpha = 0.5, then bisects the maximum A tolerated for depth 6 and depth 15 |
| `final.py` | 2026-09-01 02:17:38 | no header; imports `rebuild_census_price` and translates the classical zero-free region constant R (MT, MTY, BTY values) into c = 1/sqrt(R) and depth_covered, then prints how much stronger a region than the record depth 6 and depth 15 would need |
| `adv_census.py` | 2026-09-01 02:42:05 | "Independent re-derivation of the census price. Nothing reused from the prior agent's scratch. Adversarial check of the analysis under test." |
| `adv_region.py` | 2026-09-01 02:45:24 | "Part 2: the c = 1/sqrt(R) translation, the ratio claims, and the census arm." |
| `adv_theta.py` | 2026-09-01 02:47:41 | "Part 3: what the census gate ACTUALLY requires, stated without assuming a functional form. The analysis under test never does this." |
| `open_august.txt` | 2026-09-01 10:19:06 | no header; `grep -n` capture of the `[open]` lines of `notes/NOTEPAD.md` dated August 2026 (181 lines, NOTEPAD line numbers prefixed), as they stood on 2026-09-01 |
| `batch1.txt` | 2026-09-01 10:19:06 | no header; lines 1–46 of `open_august.txt` (the four batch files concatenate exactly to `open_august.txt`) |
| `batch2.txt` | 2026-09-01 10:19:06 | no header; lines 47–92 of `open_august.txt` |
| `batch3.txt` | 2026-09-01 10:19:06 | no header; lines 93–138 of `open_august.txt` |
| `batch4.txt` | 2026-09-01 10:19:06 | no header; lines 139–181 of `open_august.txt` |
| `chk.lean` | 2026-09-01 16:42:41 | no header; `#check` probe of `Stage3.ThetaPull` names (`RHPull.I37_sqrt_log3`, `Stage3.I37_sqrt_log3_half`, `Stage3.I37_power_log3_theta`) |
| `chk2.lean` | 2026-09-01 16:55:08 | no header; `#check` probe of `Stage3.ThetaPsi` names (`RHPull.psi_weak_of_RH`, `Stage3.psi_weak_of_RH_half`, `RHPull.stmtPsiWeak_of_RH`, `Stage3.stmtPsiWeak_of_RH_half`, `Stage3.psi_weak_of_theta`) |
| `chk3.lean` | 2026-09-01 18:43:46 | no header; `#check` probe of `Stage3.ThetaPi` names (`Stage3.schoenfeldWeak_of_psiWeak`, `Stage3.schoenfeldWeak_of_psiWeak_half`, `Stage3.schoenfeldWeakTheta_of_zeroFree`) |
| `gamma1_to_14.py` | 2026-09-01 19:42:25 | "Exploratory. Move gamma_1 to 14 in the explicit formula; everything else cancels, so the change on the prime side is D(x) = 2 Re( x^rho1/rho1 - x^rho1'/rho1' )." |
| `line_0_100.py` | 2026-09-01 19:47:22 | "Exploratory. gamma_1 -> 14, all else fixed. Per unit cell (n-1, n]: the prime-mass the modified formula assigns, Lam'(n) = Lam(n) - (D(n) - D(n-1)), where D(x) = 2 Re(x^rho1/rho1 - x^rho1'/rho1') is the whole change on the prime side." (v2's header records that this file has the sign of the fluid term wrong) |
| `line_0_100_v2.py` | 2026-09-01 19:54:47 | "Exploratory. gamma_1 -> 14, every other zero fixed. What the number line is, 0..100." Prime side and integer side (zeta_new = zeta * R, continuous number-density between whole numbers); corrects the sign in `line_0_100.py`. Cited by entry 297. |
| `line_0_100_v3.py` | 2026-09-01 19:58:04 | same header and computation as `line_0_100_v2.py`; only the printed table differs — three columns (new number, primeness, prime index) per old integer |
| `line_sigma.py` | 2026-09-01 20:09:59 | "Exploratory. gamma_1 held at its true value; the zero's real part moved 1/2 -> sigma. Every other zero fixed; no mirror zero added (the functional-equation partner 1-sigma+i*gamma is NOT introduced), so this is one zero sliding sideways and nothing else." Runs sigma = 0.7 and 2.5 side by side over 0..100. Cited by entry 297. |
| `smoke.json` | 2026-09-02 02:59:50 | no header; JSON output of `analysis/2026-09-01/weil_Lc_eps.py` (self-declared `status: "EXPLORATORY - no prereg, no decision rule, no verdict."`), smoke run with eps = [0.02], Ms = [16, 32] — L_c table, ladder, unit tests, eps = 0 sanity check against `weil_rung_min` |
| `smoke_height.json` | 2026-09-02 03:13:28 | no header; JSON output of `analysis/2026-09-01/weil_Lc_height.py` (self-declared exploratory), smoke run with ks = [1, 100], eps = [0.01], Ms = [32, 64], Mraise = 96 — per-zero L_c summary, M-convergence, k = 1 sanity check against `weil_Lc_eps` |
| `smoke_height2.json` | 2026-09-02 03:14:51 | no header; JSON output of `analysis/2026-09-01/weil_Lc_height.py` (self-declared exploratory), smaller smoke run with ks = [1], eps = [0.01], Ms = [32], Mraise = 0 |
