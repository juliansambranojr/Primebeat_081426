/-
StirlingSeries — block S14 of `lean_stage3/design/stencil.md`, Turing at scale: Stirling's series
for `log Γ` with an explicit remainder, and the gamma phase of the sign data in `O(K)` balls per
point. 2026-11-25. Pin "Turing at scale", goal (a), `PINS.md`.

**The lost factor.** `SignDataGamma.re_lambda_eq` reads the phase of `Γ(1/4 + it/2)` from
`GammaSeq z n`; its tail `tail_le` is `(2‖z‖ + ‖z‖²)/n`, so `n ≈ t²/6` factor balls per point
(512 at `t = 49`, 2048 at `t = 100`), and the factor `‖z‖²` grows with the height. The steps were
fine; the size of what they add up to was the design failure. Stirling's series replaces the tail:
its remainder after `K` terms is `O(‖z‖^{2−2K}/|Im z|)`, uniform in everything else.

**The route.** Euler–Maclaurin on `[0, 1]` for `log(w + x)` (`StirlingSeriesEM`): with
`J_m(w) = ∫₀¹ B_m(x)(w+x)^{−m}` one integration by parts gives
`(m+1)J_m = B_{m+1}((w+1)^{−m} − w^{−m}) + mJ_{m+1}`, `J₁ = 1 − (w + ½)(log(w+1) − log w)`, and so
`S_{K+1}(w+1) − S_{K+1}(w) − log w = −J_{2K}(w)/(2K)`, where
`S_K(w) = (w − ½) log w − w + Σ_{1≤k<K} B_{2k}/(2k(2k−1) w^{2k−1})`. Summed over `w = z + n` against
PNT+'s `logGammaSeq` (the Gauss form `SignDataGamma` uses) and Mathlib's Stirling formula for
`n!` (`StirlingSeriesLim`), the limit is `Stirling.logG z = S_{K+1}(z) + ½ log 2π + R`,
`‖R‖ ≤ bernBound(2K)/(2K)·(6/|Im z|)/‖z‖^{2K−2}`. The Fourier series of `B_k` bounds
`bernBound k ≤ 4·k!/6^k` (`StirlingSeriesBern`).

**The phase** (`StirlingSeriesPhase`). `Λ(1/2+it) = κ e^δ e^{iφ_K(t)} ζ(1/2+it)` with `κ > 0`,
`φ_K(t) = Im S_K(1/4 + it/2) − (t/2) log π`, `δ` the remainder; `Λ` is real, so `‖δ‖ ≤ 3/2` makes
`sign Re Λ = sign Re(e^{iφ_K} ζ)` (`re_lambda_eq_stir`, the re-proof of `re_lambda_eq`). `φ₃(t)` is
a closed form in `log(t/2)`, `π`, `log π` and a 5-term series of `log(1 − i/(2t))`.

**Cost per point** (Gamma side; the zeta side is `gen_signdata.py`'s, unchanged).

| point | old route (`SignDataGamma`) | new route (`StirlingSeriesPhase`) |
|---|---|---|
| `t = 49` | `n = 512`: 515 balls; `SignDataPt49` elaborates in 64 s | 3 balls; `StirlingSeriesPt49` elaborates in 9 s |
| `t = 100` | `n = 2048`: 2051 balls, closes only with 80-digit centres (30 digits: radius `5.3e69` against centre `1.3e35`); 92 s | 3 balls; `StirlingSeriesPt100` elaborates in 10 s |

| module | content | status |
|---|---|---|
| `StirlingSeriesEM` | `emJ_step`, `emJ_one`, `emJ_one_unroll`, `stirMain_step`, `norm_emJ_le` | proved |
| `StirlingSeriesLim` | `sum_log_eq`, `tendsto_A`, `norm_P_le`, `stirling_series`, `stirling_series'` | proved |
| `StirlingSeriesBern` | `hasSum_inv_sq_int`, `abs_bernoulliFun_le`, `bernBound_le`, `stirling_series_explicit` | proved |
| `StirlingSeriesPhase` | `re_of_real_factor`, `re_lambda_eq_stir`, `delta3_le`, `im_logG_ball`, `re_lambda_pos_stir3`, `re_lambda_neg_stir3`, `log_zz_eq`, `log_one_sub_ball`, `stirPhase3_ball` | proved |
| `StirlingSeriesK5` | `B₆`, `B₈`, `stirSum5_im`, `delta5_le` (`≤ 10/|t|⁷`), `im_stirMain_ball` (any `K`), `gamma_phase_ball5` | proved |
| `StirlingSeriesLog` | `log m`, `(√m)⁻¹` for `20 ≤ m ≤ 29` (generated) | proved |
| `StirlingSeriesPt49`, `StirlingSeriesPt100` | `sign_49 : 0 < Re Λ(1/2 + 49i)`, `sign_100 : 0 < Re Λ(1/2 + 100i)` through Stirling (generated) | proved |
| `StirlingSeriesGammaPhase` | `gamma_phase_49`, `gamma_phase_100`: `Im logG(1/4 + it/2)` to `1.84e-8`, `3.75e-8` (generated) | proved |
| the classical `sec^{2K}(arg z/2)` remainder for all `Re z > 0` | the bound here needs `|Im z| ≥ ½` and is `O(‖z‖^{1−2K})` only in the sector `|Im z| ≳ ‖z‖` | open |
| the sign points of `SignData.run_signs` re-certified through Stirling | only `t = 49` (and the new `t = 100`) are | open |

Generators: `lean_stage3/checks/stirlingseries/gen_stirlingseries.py` (output
`gen_stirlingseries.out`), reusing `lean_stage3/checks/signdata/gen_signdata.py`.

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Stage3.StirlingSeriesEM
import Stage3.StirlingSeriesLim
import Stage3.StirlingSeriesBern
import Stage3.StirlingSeriesPhase
import Stage3.StirlingSeriesK5
import Stage3.StirlingSeriesLog
import Stage3.StirlingSeriesPt49
import Stage3.StirlingSeriesPt100
import Stage3.StirlingSeriesGammaPhase

namespace StirlingSeries

/-- info: 'StirlingSeries.stirling_series' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms stirling_series

/-- info: 'StirlingSeries.stirling_series_explicit' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms stirling_series_explicit

/-- info: 'StirlingSeries.re_lambda_eq_stir' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms re_lambda_eq_stir

/-- info: 'StirlingSeries.sign_49' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms sign_49

/-- info: 'StirlingSeries.sign_100' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms sign_100

/-- info: 'StirlingSeries.gamma_phase_100' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms gamma_phase_100

end StirlingSeries
