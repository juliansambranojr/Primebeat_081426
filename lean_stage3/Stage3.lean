/-
Stage3 — scaffold and weld check. Entry 118's step 1.

THE WELD, STATED LOUDLY. This package lives on toolchain v4.32.2 with
PrimeNumberTheoremAnd (pinned rev 47fa486) and its Mathlib v4.32.2; the
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

Every module in Stage3/ is imported below, so `import Stage3` elaborates
the whole package independently of the lakefile glob (23 modules as of
2026-09-01; the root had named 9 of 21 that morning). The θ-dial:
Abscissa, ThetaLine, ThetaPull, ThetaPsi, ThetaPi, ThetaConverse (notes
entries 285–293). `psi_weak_of_theta` gives |ψ(X)−X| ≤ C·X^θ·log³X from a
zero-free half-plane re > θ, θ ∈ [1/2, 1), and
`schoenfeldWeakTheta_of_zeroFree` carries it to |π−Li| ≤ C·x^θ·log²x,
the census gate's shape (entry 277). `zeroFreeRight_of_psiWeakTheta` is
the converse for every θ: a ψ-bound at exponent θ forces ζ ≠ 0 on
re s > θ, so `zeroFreeRight_iff_psiWeakTheta` makes the two abscissae one
number on [1/2, 1).
-/
import Mathlib.NumberTheory.LSeries.RiemannZeta
import PrimeNumberTheoremAnd.Backlund.ZeroCountCrude
import PrimeNumberTheoremAnd.IEANTN.ZetaDefinitions
import Stage3.Statement
import Stage3.PsiToPi
import Stage3.ZeroSum
import Stage3.Assembly
import Stage3.RvMCrude
import Stage3.Stirling
import Stage3.ArgCrude
import Stage3.LineBound
import Stage3.JensenCount
import Stage3.Abscissa
import Stage3.ExplicitBump
import Stage3.ArgIdentity
import Stage3.ThetaLine
import Stage3.ThetaPull
import Stage3.ThetaPsi
import Stage3.ThetaPi
import Stage3.ThetaConverse
import Stage3.EdgeBound
import Stage3.Glue
import Stage3.PerronKernel
import Stage3.VonKochScaffold
import Stage3.ZetaGrowth
import Stage3.ContourShift

namespace Stage3

#check (RiemannHypothesis : Prop)
#check @riemannZeta.Riemann_vonMangoldt_bound
#check @Backlund.zetaCounting_crude_majorant

end Stage3
