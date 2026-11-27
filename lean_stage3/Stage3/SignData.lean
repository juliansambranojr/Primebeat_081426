/-
SignData — block S14 of `lean_stage3/design/stencil.md`, Turing's sign data. 2026-11-25.

Certified signs of `Re Λ(1/2 + it)` (`Λ = completedRiemannZeta`, real on the line by
`HardyZ.xi_line_real`) at rational heights, in Lean with no `native_decide`, feeding
`Turing.StmtSignData` (`Stage3/TuringCert.lean`).

**The route.** `Λ(s) = Gammaℝ(s)·ζ(s)`.
1. ζ by Euler–Maclaurin of order 4 (`SignDataZeta.zeta_em4`, from `ZetaEM.zeta_eq_em` with
   `bernBound 4 ≤ 1/30` proved): `ζ = Σ_{m≤N} m^{−s} + N^{−s}·emB + R`, `R` explicit.
2. `m^{−s} = (√m)⁻¹ e^{−it log m}` with `log m` from Mathlib's `log 2` and the series of
   `log(1 − 1/m)` (`log_succ_ball`), `e^{iy}` by Taylor of degree 20 (`Complex.exp_bound`)
   after reduction by `jπ/2 + 2πk` with `π` to 20 digits (`exp_ball0`–`3`), `(√m)⁻¹` from two
   rational squares (`inv_sqrt_ball`): `SignDataBall`, `SignDataLog`.
3. The Gamma factor only to within `π/2` in phase (`SignDataGamma.re_lambda_eq`): with
   `z = 1/4 + it/2`, `Γ(z) = GammaSeq z n · e^δ`, `‖δ‖ ≤ (2‖z‖ + ‖z‖²)/n ≤ 3/2` (`tail_le`), and
   because `Λ` is real, `Re Λ = c · Re(gammaDir t n · ζ)` with `c > 0`. `gammaDir` is a product of
   `n` Gaussian rationals and one exponential.
4. Ball arithmetic with rational centres (`ball_add`, `ball_mul`), every rational computed in
   Python with exact fractions first (`lean_stage3/checks/signdata/gen_signdata.py`), every
   numeric goal closed by `norm_num`.

**Points certified.** `t = 14` (`Re Λ < 0`), `29/2` (`> 0`): one sign change, the first zero
`≈ 14.1347` (`first_zero_signs`). Then the run `14, 18, 23, 55/2, 63/2, 71/2, 39, 42, 91/2, 49`
with alternating signs (`run_signs`): nine sign changes, so at least nine zeros on the line up
to height `49` (`nine_zeros_on_line`).

**Cost per point** (Python plan, Lean build of the point's module):

| t | EM `N` | Gamma `n` | Lean theorems | margin `|Re X|/r` |
|---|---|---|---|---|
| 14 | 8 | 64 | 93 | 7.6 |
| 14.5 | 6 | 64 | 87 | 7.7 |
| 18 | 5 | 128 | 148 | 14.9 |
| 23 | 7 | 128 | 154 | 9.9 |
| 27.5 | 7 | 256 | 282 | 9.6 |
| 31.5 | 11 | 256 | 294 | 8.3 |
| 35.5 | 9 | 256 | 288 | 9.7 |
| 39 | 11 | 512 | 550 | 8.3 |
| 42 | 14 | 512 | 559 | 7.0 |
| 45.5 | 11 | 512 | 550 | 8.4 |
| 49 | 19 | 512 | 574 | 7.4 |

The Gamma factor dominates: `n ≥ (2‖z‖ + ‖z‖²)/(3/2) ≈ t²/6`, rounded up to a power of two; the
EM part grows like `N ≈ t/2`. So a point at height `t` costs `≈ t²/6 + t` balls.

**The closing height** (`checks/signdata/closing_height.py`, output `closing_height.out`). With
`TuringLW.littlewood_holds`, `a = (3/2 + 102)/π ≈ 32.95`, `b = (2 + (3/2) log 9 + 500)/π ≈ 160.84`,
the condition `hnum` of `Turing.defect_zero_of_signs` fails at every height below about
`1.4·10⁴` even with ideal data: the Littlewood term `(a log T + b)/h` needs `h` of several
hundred, and the slope `K` taken at the window's top with `97/T₁` costs `h·97/(4πT₁)`.
Ideal data (every zero found, each `s_{j+1}` just right of a zero): crossing at `T₁ ≈ 14063`,
`h ≈ 377`, `≈ 15026` sign points below and `≈ 464` above. Gram data (`T₁ = g_n`, `s_j = g_{n+j}`):
crossing at `n ≈ 42284`, `T₁ ≈ 34860`, `h ≈ 529`, `≈ 42285 + 727` points. At `≈ t²/6` Gamma
factors per point (`n ≈ 3·10⁷` at `t = 1.4·10⁴`) this is far beyond a Lean build: the crude
tail bound `‖δ‖ ≤ (2‖z‖ + ‖z‖²)/n` loses a factor growing like `t²`, and a pipeline at that height
needs Stirling's series for `log Γ` with an explicit remainder in place of `tail_le`. The
certificate is therefore stated here as the open `StmtClosingData` and composed
(`defect_zero_of_closing`); it is not discharged.

| name | content | status |
|---|---|---|
| `sign_14`, `sign_29_2`, … , `sign_49` | the sign of `Re Λ(1/2 + it)` at each point (`SignDataPt*`) | proved |
| `first_zero_signs` | `Turing.StmtSignData 1 ![14, 29/2]` | proved |
| `run_signs` | `Turing.StmtSignData 9 ![14, 18, 23, 55/2, 63/2, 71/2, 39, 42, 91/2, 49]` | proved |
| `one_zero_on_line`, `nine_zeros_on_line` | `1 ≤ lineCount (29/2)`; `9 ≤ lineCount 49` | proved |
| `StmtClosingData T₁ h` | sign data below and above `T₁` meeting `hnum` with Littlewood's constants | def (open: `≈ 1.5·10⁴`–`4.3·10⁴` points) |
| `defect_zero_of_closing` | `StmtClosingData T₁ h`, `2 ≤ T₁`, `0 < h` ⊢ `∀ T ≤ T₁, defect T = 0` | proved |

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Stage3.TuringCert
import Stage3.TuringLW
import Stage3.SignDataPt14
import Stage3.SignDataPt29_2
import Stage3.SignDataPt18
import Stage3.SignDataPt23
import Stage3.SignDataPt55_2
import Stage3.SignDataPt63_2
import Stage3.SignDataPt71_2
import Stage3.SignDataPt39
import Stage3.SignDataPt42
import Stage3.SignDataPt91_2
import Stage3.SignDataPt49

namespace SignData

open Complex

/-- **The first zero**: `Re Λ` changes sign between `t = 14` and `t = 29/2`. -/
theorem first_zero_signs : Turing.StmtSignData 1 ![14, 29 / 2] := by
  refine ⟨?_, by norm_num, ?_⟩
  · rw [Fin.strictMono_iff_lt_succ]
    intro i
    fin_cases i
    norm_num
  · intro i
    fin_cases i
    exact mul_neg_of_neg_of_pos sign_14 sign_29_2

/-- **Nine sign changes up to height 49.** -/
theorem run_signs :
    Turing.StmtSignData 9 ![14, 18, 23, 55 / 2, 63 / 2, 71 / 2, 39, 42, 91 / 2, 49] := by
  refine ⟨?_, by norm_num, ?_⟩
  · rw [Fin.strictMono_iff_lt_succ]
    intro i
    fin_cases i <;> simp <;> norm_num
  · intro i
    fin_cases i
    · exact mul_neg_of_neg_of_pos sign_14 sign_18
    · exact mul_neg_of_pos_of_neg sign_18 sign_23
    · exact mul_neg_of_neg_of_pos sign_23 sign_55_2
    · exact mul_neg_of_pos_of_neg sign_55_2 sign_63_2
    · exact mul_neg_of_neg_of_pos sign_63_2 sign_71_2
    · exact mul_neg_of_pos_of_neg sign_71_2 sign_39
    · exact mul_neg_of_neg_of_pos sign_39 sign_42
    · exact mul_neg_of_pos_of_neg sign_42 sign_91_2
    · exact mul_neg_of_neg_of_pos sign_91_2 sign_49

/-- At least one zero on the line up to height `29/2`. -/
theorem one_zero_on_line : (1 : ℤ) ≤ LineCount.lineCount (29 / 2) :=
  LineCount.signChanges_le_line_count _ first_zero_signs.1 first_zero_signs.2.1
    (le_refl (29 / 2 : ℝ)) first_zero_signs.2.2

/-- At least nine zeros on the line up to height `49`. -/
theorem nine_zeros_on_line : (9 : ℤ) ≤ LineCount.lineCount 49 :=
  LineCount.signChanges_le_line_count _ run_signs.1 run_signs.2.1
    (le_refl (49 : ℝ)) run_signs.2.2

/-- **The open certificate**: sign data below and above `T₁` that meet Turing's numeric
condition with the constants of `TuringLW.littlewood_holds`. A finite computation, open: by
`checks/signdata/closing_height.py` it needs `T₁ ≳ 1.4·10⁴` and `≈ 1.5·10⁴`–`4.3·10⁴` certified signs. -/
def StmtClosingData (T₁ h : ℝ) : Prop :=
  ∃ (k m : ℕ) (t : Fin (k + 1) → ℝ) (s : Fin (m + 1) → ℝ),
    Turing.StmtSignData k t ∧ t (Fin.last k) ≤ T₁ ∧
    Turing.StmtSignData m s ∧ T₁ < s 0 ∧ s (Fin.last m) ≤ T₁ + h ∧
    Stage3.phaseTheta T₁ / Real.pi + 1
      + Turing.turingErr ((3 / 2 + 102) / Real.pi) ((2 + (3 / 2) * Real.log 9 + 500) / Real.pi)
          h T₁ s < k + 2

/-- **Turing's method with Littlewood's constants**: the closing data give the defect `0`. -/
theorem defect_zero_of_closing {T₁ h : ℝ} (hd : StmtClosingData T₁ h) (h2 : 2 ≤ T₁)
    (hh : 0 < h) : ∀ T ≤ T₁, Defect.defect T = 0 := by
  obtain ⟨k, m, t, s, hb, ht, ha, hs0, hsh, hnum⟩ := hd
  exact Turing.defect_zero_of_signs hb ht ha hs0 hsh TuringLW.littlewood_holds
    (by positivity) h2 (by linarith) hh hnum

/-- info: 'SignData.first_zero_signs' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms first_zero_signs

/-- info: 'SignData.run_signs' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms run_signs

/-- info: 'SignData.nine_zeros_on_line' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms nine_zeros_on_line

/-- info: 'SignData.defect_zero_of_closing' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms defect_zero_of_closing

end SignData
