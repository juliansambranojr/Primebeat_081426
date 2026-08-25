/-
Stage3 — scaffold and weld check. Entry 118's step 1.

THE WELD, STATED LOUDLY. This package lives on toolchain v4.32.2 with
PrimeNumberTheoremAnd (pinned rev 751a8c2) and its Mathlib v4.32.2; the
bench's lean/ lives on v4.28.0. Results here compose with the bench's
arrow (Expansion.tableFrom_ne_zero_of_li, Schoenfeld.window_of_global) BY
STATEMENT IDENTITY ONLY: `StmtSchoenfeldWindow` below is a character-level
copy of lean/Nonvanishing.lean's definition, and utilities/check_weld.py
diffs the two texts so drift breaks a gate. The kernel does not check the
weld until the toolchains converge. Every claim published from this
package carries that caveat.

What this file forces the build to elaborate, as existence checks:
  - Mathlib's `RiemannHypothesis` (the hRH leaf)
  - `riemannZeta.Riemann_vonMangoldt_bound` (the hNT leaf, explicit
    constants — Rosser Th. 19 shape; its proof is IEANTN's open sorry)
  - `Backlund.zetaCounting_crude_majorant` (sorry-free, unconditional,
    exponent 3/2 — recorded as insufficient for the census by O68's
    x^(2/3) check; kept as machinery evidence)
-/
import Mathlib.NumberTheory.LSeries.RiemannZeta
import PrimeNumberTheoremAnd.Backlund.ZeroCountCrude
import PrimeNumberTheoremAnd.IEANTN.ZetaDefinitions

namespace Stage3

open Finset

/-- Character-level copy of `Nonvanishing.StmtSchoenfeldWindow` from the
bench tree (lean/Nonvanishing.lean). The weld: utilities/check_weld.py
verifies the two definition bodies are textually identical. -/
def StmtSchoenfeldWindow (f L : ℤ → ℝ) (r : ℤ) (n : ℕ) : Prop :=
  ∀ k ∈ range (n + 1),
    |f (r - k) - L (r - k)|
      ≤ (Real.log 2 * ((r : ℝ) - k) / (8 * Real.pi)) * (2 : ℝ) ^ (((r : ℝ) - k) / 2)

#check (RiemannHypothesis : Prop)
#check @riemannZeta.Riemann_vonMangoldt_bound
#check @Backlund.zetaCounting_crude_majorant

end Stage3
