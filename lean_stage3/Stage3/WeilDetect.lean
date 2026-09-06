/-
WeilDetect — the zero side of Weil's form on bounded support, and the
bounded-height detection statement. 2026-09-06, the first attempt at entry
297's rung-to-strip arrow, in the shape entry 303 §(d) drafted and did not
add.

WHAT IS DEFINED. For G : ℝ → ℂ, `laplace G z = ∫ G(u) e^{−zu} du` is the
two-sided Laplace transform (Kadiri's Φ; entry 303 §(c) takes its sign from
`kadiri_thm_3_1_q1`), and

    zeroForm G = Σ_ρ  Ĝ(−ρ)·Ĝ(−(1−ρ))·ord(ρ)

over `riemannZeta.zeroes_rect (.Ioo 0 1) .univ` with multiplicity, which is
upstream's `riemannZeta.zeroes_sum` and the ρ-sum of the Weil-type explicit
formula. `IsTest L G` is the test-function class: real-valued, C², compactly
supported in [−L/2, L/2]. `StmtWeilPositive L` says the zero side is
nonnegative on that class; `StmtDetect ε T L` says an off-line zero in the
box {Re ρ ≥ 1/2 + ε, |Im ρ| ≤ T} forces a negative value at some G of
support L.

WHAT IS PROVED. Three things, none of them the hard one.

  laplace_conj            real G: Ĝ(conj z) = conj Ĝ(z)
  zeroForm_nonneg_of_RH   RH → StmtWeilPositive L for every L. Under RH every
                          ρ has re 1/2, so −(1−ρ) = conj(−ρ), each term is
                          |Ĝ(−ρ)|²·ord(ρ) with ord ≥ 1 (upstream
                          `Kadiri.riemannZeta_order_pos_nontrivialZero`), and a sum
                          of nonnegative terms is nonnegative; if the sum is
                          not summable the tsum is 0. This is the easy half
                          of Weil's criterion, on the zero side, kernel-checked.
  box_empty_of_positive_of_detect
                          StmtDetect ε T L → StmtWeilPositive L →
                          the off-line box is empty. Pure logic: the arrow
                          the ladder wants, with the detection lemma as its
                          hypothesis.

WHAT IS NOT PROVED. `StmtDetect ε T L` for any explicit L(ε, T). That is the
bounded-height rectangle theorem: Bombieri's Theorem 8 / Theorem 10 (finite
multiset of off-line zeros ⇒ negative eigenvalues, no formula for the
support) made explicit by entry 302's raised-cosine window, with the zeros
above T bounded by a crude count (`JensenCount.zeta_local_zero_count`,
15·log T + 73). It is stated here so that it can be a named leaf with that
route; it enters the ledger on Julian's call, with its budget.

Nothing here touches the arithmetic side. The explicit formula for compactly
supported G (`StmtWeilExplicit`, entry 303 §(c)) is what would connect
`zeroForm` to the primes the instrument sums; it is upstream with two
sorries and is not restated here.

Axioms: every theorem pins to [propext, Classical.choice, Quot.sound].
-/
import Mathlib.NumberTheory.LSeries.RiemannZeta
import Mathlib.Analysis.Calculus.ContDiff.Basic
import Mathlib.MeasureTheory.Integral.Bochner.Basic
import PrimeNumberTheoremAnd.IEANTN.ZetaDefinitions
import PrimeNumberTheoremAnd.IEANTN.KadiriZeroCounting

open Complex Set MeasureTheory

namespace WeilDetect

/-- The two-sided Laplace transform, `∫ G(u) e^{−zu} du`. -/
noncomputable def laplace (G : ℝ → ℂ) (z : ℂ) : ℂ :=
  ∫ u : ℝ, G u * Complex.exp (-(z * (u : ℂ)))

/-- The zero side of Weil's form at `G`: `Σ_ρ Ĝ(−ρ)·Ĝ(−(1−ρ))·ord(ρ)` over the
nontrivial zeros, with multiplicity (`riemannZeta.zeroes_sum`). -/
noncomputable def zeroForm (G : ℝ → ℂ) : ℂ :=
  riemannZeta.zeroes_sum (Set.Ioo 0 1) (Set.univ : Set ℝ)
    (fun ρ ↦ laplace G (-ρ) * laplace G (-(1 - ρ)))

/-- The test-function class at support `L`: real-valued, `C²`, compactly
supported inside `[−L/2, L/2]`. -/
def IsTest (L : ℝ) (G : ℝ → ℂ) : Prop :=
  (∀ u, (G u).im = 0) ∧ ContDiff ℝ 2 G ∧ HasCompactSupport G ∧
    tsupport G ⊆ Set.Icc (-L / 2) (L / 2)

/-- Weil positivity on support `L`, zero side. -/
def StmtWeilPositive (L : ℝ) : Prop :=
  ∀ G : ℝ → ℂ, IsTest L G → 0 ≤ (zeroForm G).re

/-- The off-line box: zeros with `Re ρ ≥ 1/2 + ε` and `|Im ρ| ≤ T`. -/
def OffLineBox (ε T : ℝ) : Set ℂ :=
  riemannZeta.zeroes_rect (Set.Icc (1 / 2 + ε) 1) (Set.Icc (-T) T)

/-- The bounded-height detection statement: a zero in the box forces the
zero side negative at some test function of support `L`. The theorem to be
earned is `∀ ε > 0, ∀ T, StmtDetect ε T (L ε T)` with `L` explicit. -/
def StmtDetect (ε T L : ℝ) : Prop :=
  (OffLineBox ε T).Nonempty → ∃ G : ℝ → ℂ, IsTest L G ∧ (zeroForm G).re < 0

/-- **The arrow.** Detection plus positivity on the same support empties
the box. -/
theorem box_empty_of_positive_of_detect {ε T L : ℝ}
    (hD : StmtDetect ε T L) (hP : StmtWeilPositive L) :
    OffLineBox ε T = ∅ := by
  by_contra h
  obtain ⟨G, hG, hneg⟩ := hD (Set.nonempty_iff_ne_empty.mpr h)
  exact absurd (hP G hG) (not_le.mpr hneg)

/-- For real-valued `G`, the transform commutes with conjugation. -/
theorem laplace_conj (G : ℝ → ℂ) (hG : ∀ u, (G u).im = 0) (z : ℂ) :
    laplace G ((starRingEnd ℂ) z) = (starRingEnd ℂ) (laplace G z) := by
  unfold laplace
  rw [← integral_conj]
  congr 1
  funext u
  rw [map_mul, ← Complex.exp_conj]
  congr 1
  · exact (Complex.conj_eq_iff_im.mpr (hG u)).symm
  · simp [map_neg, map_mul, Complex.conj_ofReal]

/-- Under RH a nontrivial zero has real part `1/2`. -/
theorem re_eq_half_of_RH (hRH : RiemannHypothesis)
    (ρ : riemannZeta.zeroes_rect (Set.Ioo 0 1) (Set.univ : Set ℝ)) :
    (ρ : ℂ).re = 1 / 2 := by
  obtain ⟨hre, -, hz⟩ := ρ.property
  refine hRH ρ hz ?_ ?_
  · rintro ⟨n, hn⟩
    have : (ρ : ℂ).re = -2 * ((n : ℝ) + 1) := by
      rw [hn]; simp
    linarith [hre.1, this, (Nat.cast_nonneg n : (0 : ℝ) ≤ n)]
  · intro h1
    rw [h1] at hre
    simp at hre

/-- **RH ⇒ positivity on every support** (the easy half of Weil's criterion,
zero side). Each term is `|Ĝ(−ρ)|²·ord ρ` with `ord ρ ≥ 1`. -/
theorem zeroForm_nonneg_of_RH (hRH : RiemannHypothesis) {G : ℝ → ℂ}
    (hG : ∀ u, (G u).im = 0) : 0 ≤ (zeroForm G).re := by
  unfold zeroForm riemannZeta.zeroes_sum
  by_cases hs : Summable (fun ρ : riemannZeta.zeroes_rect (Set.Ioo 0 1) (Set.univ : Set ℝ) =>
      laplace G (-(ρ : ℂ)) * laplace G (-(1 - (ρ : ℂ))) * ((riemannZeta.order ρ : ℤ) : ℂ))
  · rw [Complex.re_tsum hs]
    apply tsum_nonneg
    intro ρ
    have hre := re_eq_half_of_RH hRH ρ
    have hconj : -(1 - (ρ : ℂ)) = (starRingEnd ℂ) (-(ρ : ℂ)) := by
      apply Complex.ext
      · simp [hre]; norm_num
      · simp
    rw [hconj, laplace_conj G hG, Complex.mul_conj]
    have hord : (0 : ℝ) ≤ ((riemannZeta.order ρ : ℤ) : ℝ) := by
      exact_mod_cast (Kadiri.riemannZeta_order_pos_nontrivialZero ρ).le
    rw [← Complex.ofReal_intCast, ← Complex.ofReal_mul, Complex.ofReal_re]
    exact mul_nonneg (Complex.normSq_nonneg _) hord
  · rw [tsum_eq_zero_of_not_summable hs]
    simp

theorem weilPositive_of_RH (hRH : RiemannHypothesis) (L : ℝ) : StmtWeilPositive L :=
  fun _ hG => zeroForm_nonneg_of_RH hRH hG.1

/-- info: 'WeilDetect.box_empty_of_positive_of_detect' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms box_empty_of_positive_of_detect

/-- info: 'WeilDetect.laplace_conj' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms laplace_conj

/-- info: 'WeilDetect.zeroForm_nonneg_of_RH' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms zeroForm_nonneg_of_RH

/-- info: 'WeilDetect.weilPositive_of_RH' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms weilPositive_of_RH

end WeilDetect
