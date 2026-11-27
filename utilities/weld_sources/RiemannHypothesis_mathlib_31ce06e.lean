-- Mathlib at 31ce06eaadf4a200c0e1407c5f10953cf606b8f8, Mathlib/NumberTheory/LSeries/RiemannZeta.lean lines 185-186,
-- the pin of leanprover-community/riemann-hypothesis (whose src/Main.lean proves riemannHypothesis :
-- RiemannHypothesis). Fetched 2026-11-27 from raw.githubusercontent.com; a copy, never compiled.
def RiemannHypothesis : Prop :=
  ∀ (s : ℂ) (_ : riemannZeta s = 0) (_ : ¬∃ n : ℕ, s = -2 * (n + 1)) (_ : s ≠ 1), s.re = 1 / 2
