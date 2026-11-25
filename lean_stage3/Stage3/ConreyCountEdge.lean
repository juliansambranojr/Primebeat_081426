/-
ConreyCountEdge — block S13 of `lean_stage3/design/stencil.md`, B4 step 1, the edges for `V`.
2026-11-25.

The three error terms of `LevinsonTurn.G_turn_eq` for `V = W/Gammaℝ` in place of `ζ + cζ′`.

**Sizes, checked before proving** (scratchpad `conrey_sz/vsize.py`, mpmath, 30 digits). Write
`g = Gammaℝ′/Gammaℝ`. Then `Gammaℝ·D(Λ/Gammaℝ) = (D − g)Λ`, so `V = Q(1/2 − (D + g)/L) ζ`. On
`Re s = 3`, `ζ^{(j)} = O_j(1)` and `g(3 + it) = ½ log(t/2π) + iπ/4 + O(1/t)`, so with `L = log T`
and `t ∈ [T/4, 2T]`, `g/L = 1/2 + O(1/L)` and `V = ζ·Q(O(1/L)) + O_Q(1/L) = ζ + O_Q(1/L)`, near
`ζ(3 + it)`, whose real part is at least `2 − ζ(3) > 0.79`. Computed: for Levinson's `Q = 1 − x`
and for `OperatorQ.Qcubic`, at `T = 10², 10³, 10⁴, 10⁶` and `t/T = 1/4, 1/2, 1, 3/2, 2`,
`Re V(3 + it)` lies in `[0.62, 1.26]` and `|V(3 + it)|` in `[0.65, 1.26]`. So `V` stays near a
nonzero constant on the right edge: no factor growing with `T` is lost there. On the discs of
radius `21/8` about `3 + iT` (the horizontal edges, `LevinsonEdge.edge_le_of_bound`), `V` is a
combination of `ζ^{(j)}`, `j ≤ deg Q`, each `O(T)` by Cauchy's estimate, with coefficients
polynomial in `g/L = O(1)` and in `g^{(i)} = O(1/t)`; so `‖V‖ ≤ A_Q·T`, and the edge costs
`O(log T)`. No factor is lost there either. On a lower window `t ≈ T/2^j` the shift is
`g/L ≈ 1/2 − j·log 2/(2L)`, and `V ≈ Q(j·log 2/(2L))`: near `1` only for `j = o(L)`. This is why
the window below is asked inside `[T/4, 2T]`.

**What is proved here.** The edge bounds with the size of `V` as a hypothesis:
* the right edge: where `Re V > 0` on `Re s = 3`, `|Re ∫_a^b logDeriv V (3 + t i) dt| ≤ π`
  (`right_edge_le_of_re_pos`, the proof of `LevinsonSize.right_edge_le` for any `G`);
* a horizontal edge: where `Re V(3 + iT) ≥ 1/3` and `‖V‖ ≤ M` on the disc,
  `|Im ∫_{1/2}^3 logDeriv V (x + iT) dx| ≤ π(21 log(3M) + 1)` (`edge_le_of_bound_upper`, the
  proof of `LevinsonEdge.edge_le_of_bound` with the analyticity asked on `Im w > 1/2` only, since
  `V` has the poles of `Λ` at `0`, `1` and is not given off the upper half-plane).

**What is open: the size of `V`, as named statements.**
* `StmtVRight Q L a b`: `1/3 ≤ Re V(3 + t i)` for `t ∈ [a, b]`.
* `StmtVDisc Q L T M`: `‖V w‖ ≤ M` on `‖w − (3 + T i)‖ ≤ 21/8`.
* `StmtVEdges Q T A`: both, for every height `t ∈ [T/4, 2T]`, with `L = log T` and `M = A·t`.
  Citation shape: Stirling for `ψ` and its derivatives at `Re z = 3/2` (Gammaℝ's
  `g = −(log π)/2 + ψ(s/2)/2`), the Dirichlet series of `ζ^{(j)}` on `Re s = 3`
  (`LevinsonSize.deriv_zeta_eq_LSeries` for `j = 1`), Cauchy's estimate on discs
  (`LevinsonEdge.deriv_zeta_disc_le`). Budget: true for `T ≥ T₀(Q)` with `A = A(Q)`, for every
  real `Q` with `Q(0) = 1` (from `V = ζ + O_Q(1/L)` above); crude constants. Route: expand
  `Λ^{(k)}/Gammaℝ = Σ_j C(k,j) (Gammaℝ^{(k−j)}/Gammaℝ) ζ^{(j)}`, bound
  `Gammaℝ^{(i)}/Gammaℝ − g^i` by the derivatives of `g`, then `|Q(1/2 − g/L) − 1| ≤ C_Q/L`.
  Not in the tree: a bound for `ψ(z) − log z` or for `ψ′` at complex `z` off `Re z = 1/4`
  (`Stage3/Stirling.lean` has `Re z = 1/4` only).

  | name                        | statement                                                   | status |
  |-----------------------------|-------------------------------------------------------------|--------|
  | `analyticAt_V_upper`        | `1/2 < Im w` ⊢ `AnalyticAt ℂ (V Q L) w`                      | PROVED |
  | `right_edge_le_of_re_pos`   | `G` analytic, `0 < Re G` on `3 + [a, b] i` ⊢ `|Re ∫ logDeriv G (3 + t i)| ≤ π` | PROVED |
  | `edge_le_of_bound_upper`    | `4 ≤ T`, `G` analytic on `Im > 1/2`, `1/3 ≤ Re G(3 + iT)`, `‖G‖ ≤ M` on the disc, `G ≠ 0` on the segment ⊢ `|Im ∫_{1/2}^3 logDeriv G (x + iT)| ≤ π(21 log(3M) + 1)` | PROVED |
  | `V_right_edge_le`           | `4 ≤ a ≤ b`, `StmtVRight Q L a b` ⊢ `|Re ∫_a^b logDeriv V (3 + t i)| ≤ π` | PROVED |
  | `V_horizontal_edge_le`      | `4 ≤ T`, `1/3 ≤ Re V(3 + iT)`, `StmtVDisc Q L T M`, `V ≠ 0` on the segment ⊢ the edge bound | PROVED |
  | `StmtVRight`, `StmtVDisc`, `StmtVEdges` | the size of `V` on the right edge and the discs | OPEN (def) |

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.ConreyCountLine
import Stage3.LevinsonEdge

noncomputable section

namespace ConreyCount

open Complex Polynomial

/-- **Open: the right edge.** `Re V ≥ 1/3` on `3 + [a, b] i`. -/
def StmtVRight (Q : ℝ[X]) (L a b : ℝ) : Prop :=
  ∀ t ∈ Set.Icc a b, 1/3 ≤ (V Q L (3 + t * I)).re

/-- **Open: the growth on a disc.** `‖V‖ ≤ M` on `‖w − (3 + T i)‖ ≤ 21/8`. -/
def StmtVDisc (Q : ℝ[X]) (L T M : ℝ) : Prop :=
  ∀ w : ℂ, ‖w - (3 + T * I)‖ ≤ 21/8 → ‖V Q L w‖ ≤ M

/-- **Open: the size of `V` near height `T`.** With `L = log T`, for every height `t ∈ [T/4, 2T]`:
`Re V(3 + t i) ≥ 1/3`, and `‖V‖ ≤ A·t` on the disc of radius `21/8` about `3 + t i`. -/
def StmtVEdges (Q : ℝ[X]) (T A : ℝ) : Prop :=
  ∀ t ∈ Set.Icc (T/4) (2 * T), 1/3 ≤ (V Q (Real.log T) (3 + t * I)).re ∧
    StmtVDisc Q (Real.log T) t (A * t)

/-- `V` is analytic above `Im = 1/2`. -/
theorem analyticAt_V_upper (Q : ℝ[X]) (L : ℝ) {w : ℂ} (hw : 1/2 < w.im) :
    AnalyticAt ℂ (V Q L) w := by
  have h0 : w ≠ 0 := by
    intro h; rw [h, Complex.zero_im] at hw; linarith
  have h1 : w ≠ 1 := by
    intro h; rw [h, Complex.one_im] at hw; linarith
  exact analyticAt_V Q L h0 h1 (Gammaℝ_ne_of_im (by linarith))

/-- **The right edge, for any `G` in the right half-plane there.** -/
theorem right_edge_le_of_re_pos {G : ℂ → ℂ} {a b : ℝ} (hab : a ≤ b)
    (hGa : ∀ t ∈ Set.Icc a b, AnalyticAt ℂ G (3 + t * I))
    (hpos : ∀ t ∈ Set.Icc a b, 0 < (G (3 + t * I)).re) :
    |(∫ t in a..b, logDeriv G (3 + t * I)).re| ≤ Real.pi := by
  have hne : ∀ t ∈ Set.Icc a b, G (3 + t * I) ≠ 0 := by
    intro t ht h
    have := hpos t ht
    rw [h, Complex.zero_re] at this
    exact lt_irrefl _ this
  have hFc : ContinuousOn (fun t : ℝ => G (3 + t * I)) (Set.Icc a b) := fun t ht =>
    (ContinuousAt.comp (g := G) (f := fun t : ℝ => (3 + t * I : ℂ))
      (hGa t ht).continuousAt LevinsonSize.continuous_three.continuousAt).continuousWithinAt
  have hF'c : ContinuousOn (fun t : ℝ => deriv G (3 + t * I) * I) (Set.Icc a b) := by
    intro t ht
    exact ((ContinuousAt.comp (g := deriv G) (f := fun t : ℝ => (3 + t * I : ℂ))
      (hGa t ht).deriv.continuousAt LevinsonSize.continuous_three.continuousAt).mul
        continuousAt_const).continuousWithinAt
  have hslit : ∀ t ∈ Set.Icc a b, G (3 + t * I) ∈ Complex.slitPlane := fun t ht =>
    Complex.mem_slitPlane_iff.mpr (Or.inl (hpos t ht))
  have hφc : ContinuousOn (fun t : ℝ => Complex.arg (G (3 + t * I))) (Set.Icc a b) := by
    intro t ht
    exact ContinuousAt.comp_continuousWithinAt (g := Complex.arg)
      (Complex.continuousAt_arg (hslit t ht)) (hFc t ht)
  have hφ : ∀ t ∈ Set.Icc a b, G (3 + t * I) =
      ‖G (3 + t * I)‖ * Complex.exp ((Complex.arg (G (3 + t * I)) : ℂ) * Complex.I) :=
    fun t _ => (Complex.norm_mul_exp_arg_mul_I _).symm
  have h := LevinsonTurn.lift_turn_eq_integral (F := fun t : ℝ => G (3 + t * I))
    (F' := fun t : ℝ => deriv G (3 + t * I) * I)
    (φ := fun t : ℝ => Complex.arg (G (3 + t * I))) hab hFc
    (fun t ht => LevinsonSize.hasDerivAt_three_comp
      (hGa t (Set.Ioo_subset_Icc_self ht)).differentiableAt) hF'c hne hφc hφ
  have heq : (∫ t in a..b, deriv G (3 + t * I) * I / G (3 + t * I)) =
      ∫ t in a..b, logDeriv G (3 + t * I) * I := by
    refine intervalIntegral.integral_congr (fun t _ => ?_)
    simp only [logDeriv_apply]
    ring
  rw [heq, intervalIntegral.integral_mul_const, Complex.mul_I_im] at h
  rw [← h]
  have hb := Complex.abs_arg_lt_pi_div_two_iff.mpr (Or.inl (hpos b ⟨hab, le_rfl⟩))
  have ha := Complex.abs_arg_lt_pi_div_two_iff.mpr (Or.inl (hpos a ⟨le_rfl, hab⟩))
  rw [abs_lt] at ha hb
  rw [abs_le]
  constructor <;> linarith [ha.1, ha.2, hb.1, hb.2]

/-- **A horizontal edge, with analyticity above `Im = 1/2` only.** The proof of
`LevinsonEdge.edge_le_of_bound` (which asks `G` analytic off `1`); it uses `G` only at points
with `Im > 1/2`. -/
theorem edge_le_of_bound_upper {G : ℂ → ℂ} {T M : ℝ} (hT : 4 ≤ T)
    (hGa : ∀ w : ℂ, 1/2 < w.im → AnalyticAt ℂ G w)
    (h0 : 1 / 3 ≤ (G (3 + (T : ℂ) * I)).re)
    (hM : ∀ w : ℂ, ‖w - (3 + (T : ℂ) * I)‖ ≤ 21 / 8 → ‖G w‖ ≤ M)
    (hne : ∀ x ∈ Set.Icc (1/2:ℝ) 3, G (↑x + ↑T * I) ≠ 0) :
    |(∫ x in (1/2:ℝ)..3, logDeriv G (↑x + ↑T * I)).im|
      ≤ Real.pi * (21 * Real.log (3 * M) + 1) := by
  -- the count, on the disc of radius `3` about `3 + iT`
  have hd : DifferentiableOn ℂ (fun z : ℂ => G (3 + (T : ℂ) * I + 3 * z))
      (Metric.ball (0 : ℂ) (11 / 10)) := by
    intro z hz
    rw [Metric.mem_ball, dist_zero_right] at hz
    have hw : 1/2 < (3 + (T : ℂ) * I + 3 * z).im := by
      have him : (3 + (T : ℂ) * I + 3 * z).im = T + 3 * z.im := by simp
      rw [him]
      have hzi := abs_le.mp (le_trans (Complex.abs_im_le_norm z) hz.le)
      linarith [hzi.1]
    have hf : DifferentiableAt ℂ (fun z : ℂ => 3 + (T : ℂ) * I + 3 * z) z := by fun_prop
    exact (DifferentiableAt.comp (g := G) (f := fun z : ℂ => 3 + (T : ℂ) * I + 3 * z) z
      (hGa _ hw).differentiableAt hf).differentiableWithinAt
  have hg0 : 1 / 3 ≤ ((fun z : ℂ => G (3 + (T : ℂ) * I + 3 * z)) 0).re := by
    show 1 / 3 ≤ (G (3 + (T : ℂ) * I + 3 * 0)).re
    rw [mul_zero, add_zero]
    exact h0
  have hgM : ∀ z : ℂ, ‖z‖ ≤ 7 / 8 → ‖(fun z : ℂ => G (3 + (T : ℂ) * I + 3 * z)) z‖ ≤ M := by
    intro z hz
    refine hM _ ?_
    rw [show 3 + (T : ℂ) * I + 3 * z - (3 + (T : ℂ) * I) = 3 * z by ring, norm_mul]
    simp only [Complex.norm_ofNat]
    linarith
  obtain ⟨Z', hZ'mem, hZ'card⟩ := LevinsonEdge.real_zero_count hd (by norm_num) hg0 hgM
  have hdiv : M / (1 / 3 : ℝ) = 3 * M := by ring
  rw [hdiv] at hZ'card
  -- the zeros of `Re G(x + iT)` on `(1/2, 3)`
  have hZ : ∀ x ∈ Set.Ioo (1/2:ℝ) 3, ((fun y : ℝ => G (↑y + ↑T * I)) x).re = 0 →
      x ∈ Z'.image (fun y : ℝ => 3 * y + 3) := by
    intro x hx hx0
    refine Finset.mem_image.mpr ⟨(x - 3) / 3, hZ'mem _ ?_ ?_, by ring⟩
    · rw [abs_le]; constructor <;> linarith [hx.1, hx.2]
    · show (G (3 + (T : ℂ) * I + 3 * (((x - 3) / 3 : ℝ) : ℂ))).re = 0
      rw [show (3 : ℂ) + (T : ℂ) * I + 3 * (((x - 3) / 3 : ℝ) : ℂ) = (x : ℂ) + (T : ℂ) * I by
        push_cast; ring]
      exact hx0
  have hcard : ((Z'.image (fun y : ℝ => 3 * y + 3)).card : ℝ) ≤ (Z'.card : ℝ) := by
    exact_mod_cast Finset.card_image_le
  -- Backlund's step, the tree's generic `ArgLegs.segment_im_integral_le`
  have hne1 : ∀ x : ℝ, 1/2 < ((x : ℂ) + (T : ℂ) * I).im := by
    intro x
    simp
    linarith
  have hder : ∀ x ∈ Set.Icc (1/2:ℝ) 3,
      HasDerivAt (fun y : ℝ => G ((y : ℂ) + (T : ℂ) * I))
        (deriv G ((x : ℂ) + (T : ℂ) * I)) x := by
    intro x _
    have hz : HasDerivAt (fun w : ℂ => w + (T : ℂ) * I) 1 ((x : ℝ) : ℂ) := by
      simpa using (hasDerivAt_id ((x : ℝ) : ℂ)).add_const ((T : ℂ) * I)
    have hcomp :=
      ((((hGa _ (hne1 x)).differentiableAt).hasDerivAt).comp ((x : ℝ) : ℂ) hz).comp_ofReal
    simpa [Function.comp] using hcomp
  have hcg : ContinuousOn (fun x : ℝ => G ((x : ℂ) + (T : ℂ) * I)) (Set.Icc (1/2:ℝ) 3) :=
    fun x hx => ((hder x hx).continuousAt).continuousWithinAt
  have hc : ContinuousOn (fun x : ℝ => deriv G ((x : ℂ) + (T : ℂ) * I)
      / G ((x : ℂ) + (T : ℂ) * I)) (Set.Icc (1/2:ℝ) 3) := by
    intro x hx
    have hf : ContinuousAt (fun y : ℝ => (y : ℂ) + (T : ℂ) * I) x := by fun_prop
    have h1 := ContinuousAt.comp (g := deriv G) (f := fun y : ℝ => (y : ℂ) + (T : ℂ) * I)
      (hGa _ (hne1 x)).deriv.continuousAt hf
    have h2 := ContinuousAt.comp (g := G) (f := fun y : ℝ => (y : ℂ) + (T : ℂ) * I)
      (hGa _ (hne1 x)).continuousAt hf
    exact (h1.div h2 (hne x hx)).continuousWithinAt
  have key := ArgLegs.segment_im_integral_le
    (g := fun x : ℝ => G ((x : ℂ) + (T : ℂ) * I))
    (g' := fun x : ℝ => deriv G ((x : ℂ) + (T : ℂ) * I))
    (by norm_num : (1/2:ℝ) ≤ 3) hder hne hc hcg _ hZ
  have hgoal : (∫ x in (1/2:ℝ)..3, logDeriv G (↑x + ↑T * I))
      = ∫ x in (1/2:ℝ)..3, deriv G ((x : ℂ) + (T : ℂ) * I) / G ((x : ℂ) + (T : ℂ) * I) := by
    simp only [logDeriv_apply]
  rw [hgoal]
  refine le_trans key (mul_le_mul_of_nonneg_left ?_ Real.pi_pos.le)
  linarith

/-- **The right edge for `V`.** -/
theorem V_right_edge_le {Q : ℝ[X]} {L a b : ℝ} (ha : 4 ≤ a) (hab : a ≤ b)
    (hR : StmtVRight Q L a b) :
    |(∫ t in a..b, logDeriv (V Q L) (3 + t * I)).re| ≤ Real.pi :=
  right_edge_le_of_re_pos hab
    (fun t ht => analyticAt_V_upper Q L (by simp; linarith [ht.1]))
    (fun t ht => by linarith [hR t ht])

/-- **A horizontal edge for `V`.** -/
theorem V_horizontal_edge_le {Q : ℝ[X]} {L T M : ℝ} (hT : 4 ≤ T)
    (h0 : 1/3 ≤ (V Q L (3 + T * I)).re) (hM : StmtVDisc Q L T M)
    (hne : ∀ x ∈ Set.Icc (1/2:ℝ) 3, V Q L (↑x + ↑T * I) ≠ 0) :
    |(∫ x in (1/2:ℝ)..3, logDeriv (V Q L) (↑x + ↑T * I)).im|
      ≤ Real.pi * (21 * Real.log (3 * M) + 1) :=
  edge_le_of_bound_upper hT (fun _ hw => analyticAt_V_upper Q L hw) h0 hM hne

/-- info: 'ConreyCount.analyticAt_V_upper' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms analyticAt_V_upper

/-- info: 'ConreyCount.right_edge_le_of_re_pos' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms right_edge_le_of_re_pos

/-- info: 'ConreyCount.edge_le_of_bound_upper' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms edge_le_of_bound_upper

/-- info: 'ConreyCount.V_right_edge_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms V_right_edge_le

/-- info: 'ConreyCount.V_horizontal_edge_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms V_horizontal_edge_le

end ConreyCount

end
