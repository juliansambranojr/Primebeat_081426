/-
DigammaBound — block S13 of `lean_stage3/design/stencil.md`, B4 step 2, the size of `V` and the
count with no size hypothesis. 2026-11-25.

Pins: `PINS.md` § Current, "B4 step 2, the digamma bound and V's edges".

`ConreyCount.StmtVEdges Q T A` (the size of `V = W/Gammaℝ` near height `T`: `Re V ≥ 1/3` on
`Re s = 3` and `‖V‖ ≤ A t` on the discs of radius `21/8` about `3 + t i`, `t ∈ [T/4, 2T]`,
`L = log T`) holds for `T ≥ T₀(Q)` with `A = A(Q)`, for every real `Q` with `Q(0) = 1`
(`stmtVEdges_holds`). The symmetry `Q′(x) = Q′(1 − x)` is not used for the size; it enters only
through the count. Then `conrey_count_window'` is `ConreyCount.conrey_count_window` with the
size hypothesis `hE` discharged.

**The route, and why no digamma.** The citation shape of `StmtVEdges` named Stirling for `ψ`
and its derivatives. The route taken is shorter: the shift `g ≈ L/2` is taken out of `V`
exactly, `V(w) = Σ_j Q_j (−1/L)^j H_w^{(j)}(w)` with `H_w(z) = ζ(z) Gammaℝ(z)/Gammaℝ(w)
e^{−(L/2)(z − w)}` (`DigammaBoundIdentity.V_eq_sum_H`, from Leibniz and
`Q(1/2 − (D + L/2)/L) = Q(−D/L)`), and each `H_w^{(j)}(w)` is bounded by Cauchy's estimate from
`‖H_w‖` on a circle of fixed radius, which needs only the size of `‖Gammaℝ‖`
(`ApproxBounds.log_norm_Gammaℝ_approx`), never `ψ` or `ψ′` (`DigammaBoundSize`).

**Sizes, checked before proving.** On the circles used (radius `1` about `3 + t i`, radius
`1/8` about the disc points), `‖Gammaℝ z/Gammaℝ w‖ T^{−(Re z − Re w)/2} ≤ 6.0` at
`T = 10², 10⁴, 10⁸` (`lean_stage3/checks/digamma/hsize.py`, mpmath), uniformly in `T`: no factor
growing with `T` is lost; the proof's constant `B = e^{2|C| + 160}` is crude. The `j ≥ 1`
terms carry `L^{−j}` against `R^{−j}`: with `R = 1` they are `O(1/L)` (the right edge), with
`R = 1/8` and `L ≥ 8` they are `O(1)` (the discs). On the discs `‖ζ‖ ≤ 2 + 4‖z‖ ≤ 5t`
(`LevinsonEdge.zeta_norm_le`), so `‖V‖ ≤ 5 K_Q B t`, the `A t` of the statement.

  | name                    | statement                                                    | status |
  |-------------------------|--------------------------------------------------------------|--------|
  | `V_eq_sum_H`            | `V = Σ_j Q_j (−1/L)^j H_w^{(j)}(w)` (`DigammaBoundIdentity`) | PROVED |
  | `gamma_ratio`, `V_norm_le`, `V_sub_le` | the sizes (`DigammaBoundSize`)                | PROVED |
  | `right_edge_ge`         | `Q(0) = 1`, `L ≥ 8 + 400 K_Q B`, `t ∈ [T/4, 2T]` ⊢ `1/3 ≤ Re V(3 + t i)` | PROVED |
  | `disc_le`               | the same ⊢ `‖V w‖ ≤ 5 K_Q B t` on the disc of radius `21/8`   | PROVED |
  | `stmtVEdges_holds`      | `Q(0) = 1` ⊢ `∃ A T₀, 0 < A ∧ ∀ T ≥ T₀, StmtVEdges Q T A`     | PROVED |
  | `conrey_count_window'`  | `conrey_count_window` without `hE`, for `T ≥ T₀(Q)`          | PROVED |

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.DigammaBoundSize

noncomputable section

namespace DigammaBound

open Complex Polynomial Metric Set LineCount

/-- Points of a closed disc about `w`: real and imaginary parts within the radius. -/
theorem re_im_close {z w : ℂ} {r : ℝ} (h : ‖z - w‖ ≤ r) :
    |z.re - w.re| ≤ r ∧ |z.im - w.im| ≤ r := by
  constructor
  · have := Complex.abs_re_le_norm (z - w)
    rw [Complex.sub_re] at this
    linarith
  · have := Complex.abs_im_le_norm (z - w)
    rw [Complex.sub_im] at this
    linarith

/-- **The right edge.** -/
theorem right_edge_ge (Q : ℝ[X]) (hQ0 : Q.eval 0 = 1) {B T t : ℝ} (hB : 0 < B)
    (hBr : ∀ T : ℝ, 16 ≤ T → ∀ z w : ℂ,
      1 / 4 ≤ z.re → z.re ≤ 7 → 1 / 4 ≤ w.re → w.re ≤ 7 →
      T / 8 ≤ z.im → z.im ≤ 3 * T → T / 8 ≤ w.im → w.im ≤ 3 * T → |z.im - w.im| ≤ 1 →
      ‖Gammaℝ z‖ / ‖Gammaℝ w‖ * Real.exp (-(Real.log T / 2) * (z.re - w.re)) ≤ B)
    (hT : 200 ≤ T) (hL : 8 + 400 * KQ Q * B ≤ Real.log T) (ht : t ∈ Icc (T / 4) (2 * T)) :
    1 / 3 ≤ (ConreyCount.V Q (Real.log T) (3 + t * I)).re := by
  have hK := KQ_nonneg Q
  have hL8 : 8 ≤ Real.log T := by nlinarith [mul_nonneg hK hB.le]
  have hLpos : 0 < Real.log T := by linarith
  set w : ℂ := 3 + t * I with hwdef
  have hwre : w.re = 3 := by simp [hwdef]
  have hwim : w.im = t := by simp [hwdef]
  have hw0 : 0 < w.re := by rw [hwre]; norm_num
  have hw1 : w ≠ 1 := by
    intro h; have := congrArg Complex.re h; rw [hwre, Complex.one_re] at this; norm_num at this
  have hpi2 : Real.pi ^ 2 / 6 ≤ 2 := by nlinarith [Real.pi_lt_d2, Real.pi_pos]
  have hd : DifferentiableOn ℂ (H (Real.log T) w) (closedBall w 1) := by
    intro z hz
    rw [mem_closedBall, dist_eq_norm] at hz
    obtain ⟨hc1, hc2⟩ := abs_le.mp (re_im_close hz).1
    rw [hwre] at hc1 hc2
    have hz1 : z ≠ 1 := by
      intro h; rw [h, Complex.one_re] at hc1; linarith
    exact (differentiableAt_H _ w (by linarith) hz1).differentiableWithinAt
  have hM : ∀ z ∈ sphere w 1, ‖H (Real.log T) w z‖ ≤ Real.pi ^ 2 / 6 * B := by
    intro z hz
    rw [mem_sphere, dist_eq_norm] at hz
    have hc := re_im_close hz.le
    obtain ⟨hre1, hre2⟩ := abs_le.mp hc.1
    obtain ⟨him1, him2⟩ := abs_le.mp hc.2
    rw [hwre] at hre1 hre2
    rw [hwim] at him1 him2
    rw [norm_H]
    have hr := hBr T (by linarith) z w (by linarith) (by linarith) (by rw [hwre]; norm_num)
      (by rw [hwre]; norm_num) (by linarith [ht.1]) (by linarith [ht.2])
      (by rw [hwim]; linarith [ht.1]) (by rw [hwim]; linarith [ht.2]) hc.2
    exact mul_le_mul (zeta_norm_le_two (by linarith)) hr (by positivity) (by positivity)
  have hsub := V_sub_le Q hLpos one_pos (by linarith) (by positivity) hw0 hw1 hd hM
  rw [Polynomial.coeff_zero_eq_eval_zero, hQ0, Complex.ofReal_one, one_mul, mul_one] at hsub
  have hsmall : KQ Q * (Real.pi ^ 2 / 6 * B) / Real.log T ≤ 1 / 100 := by
    rw [div_le_iff₀ hLpos]
    have : KQ Q * (Real.pi ^ 2 / 6 * B) ≤ KQ Q * (2 * B) :=
      mul_le_mul_of_nonneg_left (mul_le_mul_of_nonneg_right hpi2 hB.le) hK
    nlinarith [mul_nonneg hK hB.le]
  have h1 : -‖ConreyCount.V Q (Real.log T) w - riemannZeta w‖ ≤
      (ConreyCount.V Q (Real.log T) w - riemannZeta w).re :=
    neg_le_of_abs_le (Complex.abs_re_le_norm _)
  rw [Complex.sub_re] at h1
  have hz := re_zeta_three_ge t
  have hpi : Real.pi ^ 2 / 6 ≤ 1.65375 := by nlinarith [Real.pi_lt_d2, Real.pi_pos]
  linarith

/-- **The discs.** -/
theorem disc_le (Q : ℝ[X]) {B T t : ℝ} (hB : 0 < B)
    (hBr : ∀ T : ℝ, 16 ≤ T → ∀ z w : ℂ,
      1 / 4 ≤ z.re → z.re ≤ 7 → 1 / 4 ≤ w.re → w.re ≤ 7 →
      T / 8 ≤ z.im → z.im ≤ 3 * T → T / 8 ≤ w.im → w.im ≤ 3 * T → |z.im - w.im| ≤ 1 →
      ‖Gammaℝ z‖ / ‖Gammaℝ w‖ * Real.exp (-(Real.log T / 2) * (z.re - w.re)) ≤ B)
    (hT : 200 ≤ T) (hL : 8 ≤ Real.log T) (ht : t ∈ Icc (T / 4) (2 * T)) :
    ConreyCount.StmtVDisc Q (Real.log T) t (5 * KQ Q * B * t) := by
  intro w hw
  have hLpos : 0 < Real.log T := by linarith
  have hw' := re_im_close hw
  obtain ⟨hwre1, hwre2⟩ := abs_le.mp hw'.1
  obtain ⟨hwim1, hwim2⟩ := abs_le.mp hw'.2
  simp only [Complex.add_re, Complex.add_im, Complex.mul_re, Complex.mul_im, Complex.ofReal_re,
    Complex.ofReal_im, Complex.I_re, Complex.I_im] at hwre1 hwre2 hwim1 hwim2
  norm_num at hwre1 hwre2 hwim1 hwim2
  have hw0 : 0 < w.re := by linarith
  have hw1 : w ≠ 1 := by
    intro h; rw [h, Complex.one_im] at hwim1; linarith [ht.1]
  have hd : DifferentiableOn ℂ (H (Real.log T) w) (closedBall w (1 / 8)) := by
    intro z hz
    rw [mem_closedBall, dist_eq_norm] at hz
    have hc := re_im_close hz
    obtain ⟨hre1, hre2⟩ := abs_le.mp hc.1
    obtain ⟨him1, him2⟩ := abs_le.mp hc.2
    have hz1 : z ≠ 1 := by
      intro h; rw [h, Complex.one_im] at him1; linarith [ht.1]
    exact (differentiableAt_H _ w (by linarith) hz1).differentiableWithinAt
  have hM : ∀ z ∈ sphere w (1 / 8), ‖H (Real.log T) w z‖ ≤ 5 * t * B := by
    intro z hz
    rw [mem_sphere, dist_eq_norm] at hz
    have hc := re_im_close hz.le
    obtain ⟨hre1, hre2⟩ := abs_le.mp hc.1
    obtain ⟨him1, him2⟩ := abs_le.mp hc.2
    rw [norm_H]
    have hr := hBr T (by linarith) z w (by linarith) (by linarith) (by linarith)
      (by linarith) (by linarith [ht.1]) (by linarith [ht.2])
      (by linarith [ht.1]) (by linarith [ht.2]) (by linarith)
    have hζ := LevinsonEdge.zeta_norm_le (u := z) (by linarith) (by linarith [ht.1])
    have hn := Complex.norm_le_abs_re_add_abs_im z
    have hre' : |z.re| ≤ 6 := by rw [abs_le]; constructor <;> linarith
    have him' : |z.im| ≤ t + 3 := by rw [abs_le]; constructor <;> linarith [ht.1]
    have h5 : ‖riemannZeta z‖ ≤ 5 * t := by nlinarith [ht.1]
    exact mul_le_mul h5 hr (by positivity) (by nlinarith [ht.1])
  have hV := V_norm_le Q hLpos (by norm_num) (by linarith) (by nlinarith [ht.1]) hw0 hw1 hd hM
  calc ‖ConreyCount.V Q (Real.log T) w‖ ≤ KQ Q * (5 * t * B) := hV
    _ = 5 * KQ Q * B * t := by ring

/-- **`StmtVEdges` holds.** For every real `Q` with `Q(0) = 1` there are `A > 0` and `T₀` with
`StmtVEdges Q T A` for every `T ≥ T₀`. -/
theorem stmtVEdges_holds (Q : ℝ[X]) (hQ0 : Q.eval 0 = 1) :
    ∃ A T₀ : ℝ, 0 < A ∧ ∀ T ≥ T₀, ConreyCount.StmtVEdges Q T A := by
  obtain ⟨B, hB, hBr⟩ := gamma_ratio
  have hK := KQ_nonneg Q
  refine ⟨5 * KQ Q * B + 1, 200 + Real.exp (8 + 400 * KQ Q * B), by positivity, ?_⟩
  intro T hT t ht
  have hE := Real.exp_pos (8 + 400 * KQ Q * B)
  have hT200 : 200 ≤ T := by linarith
  have hL : 8 + 400 * KQ Q * B ≤ Real.log T := by
    have h := Real.log_le_log hE (show Real.exp (8 + 400 * KQ Q * B) ≤ T by linarith)
    rwa [Real.log_exp] at h
  have hL8 : 8 ≤ Real.log T := by nlinarith [mul_nonneg hK hB.le]
  refine ⟨right_edge_ge Q hQ0 hB hBr hT200 hL ht, ?_⟩
  have ht0 : 0 ≤ t := by linarith [ht.1]
  exact (disc_le Q hB hBr hT200 hL8 ht).mono (by nlinarith)

/-- **The count on a window inside `[T/4, 2T]`, with no size hypothesis.** For a real `Q` with
`Q′(x) = Q′(1 − x)`, `Q(1/2) ≠ 0` and `Q(0) = 1` there are `A > 0` and `T₀` such that for every
`T ≥ T₀`, `T/4 ≤ a`, `4 ≤ a < b ≤ 2T`, and the avoidance hypotheses:
`lineCount b − lineCount a ≥ (N b − N a) − 2·countRight V − (72 log b + 42 log(3A) + 154)`. -/
theorem conrey_count_window' {Q : ℝ[X]}
    (hQ : ∀ x : ℝ, Q.derivative.eval x = Q.derivative.eval (1 - x))
    (hQh : Q.eval (1/2) ≠ 0) (hQ0 : Q.eval 0 = 1) :
    ∃ A T₀ : ℝ, 0 < A ∧ ∀ {T a b : ℝ}, T₀ ≤ T →
      T / 4 ≤ a → 4 ≤ a → a < b → b ≤ 2 * T →
      (∀ x ∈ Icc (1/2 : ℝ) 3, ConreyCount.V Q (Real.log T) (↑x + ↑a * I) ≠ 0) →
      (∀ x ∈ Icc (1/2 : ℝ) 3, ConreyCount.V Q (Real.log T) (↑x + ↑b * I) ≠ 0) →
      riemannZeta (1/2 + a * I) ≠ 0 →
      (riemannZeta.N b - riemannZeta.N a)
        - 2 * Littlewood.countRight (ConreyCount.V Q (Real.log T)) ((1/2 : ℂ) + a * I)
            ((3 : ℂ) + b * I) (1/2)
        - (72 * Real.log b + 42 * Real.log (3 * A) + 154)
          ≤ (lineCount b : ℝ) - (lineCount a : ℝ) := by
  obtain ⟨A, T₀, hA, h⟩ := stmtVEdges_holds Q hQ0
  exact ⟨A, T₀, hA, fun hT hTa ha hab hbT hBot hTop hζa =>
    ConreyCount.conrey_count_window hQ hQh hA hTa ha hab hbT (h _ hT) hBot hTop hζa⟩

/-- info: 'DigammaBound.right_edge_ge' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms right_edge_ge

/-- info: 'DigammaBound.disc_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms disc_le

/-- info: 'DigammaBound.stmtVEdges_holds' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms stmtVEdges_holds

/-- info: 'DigammaBound.conrey_count_window'' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms conrey_count_window'

end DigammaBound

end
