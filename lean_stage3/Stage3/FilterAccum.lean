/-
FilterAccum — block S3 of `lean_stage3/design/stencil.md`, in its corrected
form (the section "After the independent check"). 2026-11-23.

Finitely many accumulation points. Fix `σ > 1/2`. Suppose the modes `2^ρ` of
the zeros with real part at least `σ` accumulate only at the points of a
finite set `P` of nonzero complex numbers: for every `ε > 0`, the mode values
at distance at least `ε` from every point of `P` form a finite set (one value
may be carried by infinitely many zeros). Suppose some zero `ρ₁` with real part
above `σ` has its mode outside `P`. Then the ladder bound fails. The filter is
`q(u) = Π_{p ∈ P} (u − 1/p)`, with `a = 1` and `b` large. At `ρ₁` the rate
`|ξ| = 2^(β₁b)·|q(2^(−ρ₁))|` beats the threshold `2^(σb)·‖q‖_W` once `b` is
large, since `2^(β₁ − σ) > 1`. A mode within `ε` of a point of `P` has rate at
most `2^b·ε·L`, below the rate at `ρ₁` for `ε` small; the other modes form a
finite set of values, on which the rate has a largest value, carried by some
zero `ρ₀`. That `ρ₀` attains the largest rate right of `σ`, above the
threshold, and `FilterAttained.filter_attained_false` forbids it.

  qP, eval_qP              the filter Π (X − 1/p), and its value Π (w − 1/p)
  L                        the bound Π (1 + |1/p|) on the factors
  xiz, xi_eq_xiz           the rate as a function of the mode, a = 1
  one_le_norm_mode, norm_mode_le_two    1 ≤ |2^ρ| ≤ 2 on the zeros
  norm_xiz_near_le         a mode within ε of a point of P: |ξ| ≤ 2^b·(ε·L)
  eval_qP_ne_zero          a mode outside P: q(1/z) ≠ 0
  exists_b                 b with deg q < b and the threshold beaten at ρ₁
  finite_accumulation_false   finitely many accumulation points ⊢ False
  rh_of_finite_accumulation   the same on every line right of 1/2 ⊢ RiemannHypothesis

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.FilterAttained

namespace FilterAccum

open Finset Polynomial Kadiri FiniteOffLine

noncomputable section

/-- The filter that vanishes at the inverses of the points of `P`:
`q(u) = Π_{p ∈ P} (u − 1/p)`. -/
def qP (P : Finset ℂ) : Polynomial ℂ := ∏ p ∈ P, (X - C p⁻¹)

/-- The filter's value at `w` is the product of `w − 1/p` over the points of `P`. -/
theorem eval_qP (P : Finset ℂ) (w : ℂ) : (qP P).eval w = ∏ p ∈ P, (w - p⁻¹) := by
  unfold qP
  rw [eval_prod]
  simp

/-- The bound `Π_{p ∈ P} (1 + |1/p|)` on the product of the factors of the filter. -/
def L (P : Finset ℂ) : ℝ := ∏ p ∈ P, (1 + ‖p⁻¹‖)

/-- The bound `L` is positive. -/
theorem L_pos (P : Finset ℂ) : 0 < L P :=
  Finset.prod_pos fun p _ => by positivity

/-- The rate with `a = 1`, as a function of the mode `z`: `z^b·q(1/z)`. -/
def xiz (q : Polynomial ℂ) (b : ℕ) (z : ℂ) : ℂ := z ^ b * q.eval z⁻¹

/-- With `a = 1` the rate of a zero depends on the zero only through its mode. -/
theorem xi_eq_xiz (q : Polynomial ℂ) (b : ℕ) (ρ : NontrivialZeros) :
    FilterAttained.xi q 1 b ρ = xiz q b ((2:ℂ) ^ (ρ : ℂ)) := by
  unfold FilterAttained.xi xiz
  rw [pow_one]

/-- The mode of a zero has size at least one. -/
theorem one_le_norm_mode (ρ : NontrivialZeros) : 1 ≤ ‖(2:ℂ) ^ (ρ : ℂ)‖ := by
  rw [norm_two_cpow]
  exact Real.one_le_rpow (by norm_num) ρ.2.1.1.le

/-- The mode of a zero has size at most two. -/
theorem norm_mode_le_two (ρ : NontrivialZeros) : ‖(2:ℂ) ^ (ρ : ℂ)‖ ≤ 2 := by
  rw [norm_two_cpow]
  calc (2:ℝ) ^ (ρ : ℂ).re ≤ (2:ℝ) ^ (1:ℝ) :=
        Real.rpow_le_rpow_of_exponent_le (by norm_num) ρ.2.1.2.le
    _ = 2 := Real.rpow_one 2

/-- **A mode near a point of `P` has a small rate.** For a mode `z` with
`1 ≤ |z| ≤ 2` and a point `p₀` of `P` with `|z − p₀| ≤ ε`, the rate under the
filter of `P` is at most `2^b·(ε·L)`. -/
theorem norm_xiz_near_le {P : Finset ℂ} (hP0 : ∀ p ∈ P, p ≠ 0) (b : ℕ) {z : ℂ}
    (hz1 : 1 ≤ ‖z‖) (hz2 : ‖z‖ ≤ 2) {p₀ : ℂ} (hp₀ : p₀ ∈ P) {ε : ℝ}
    (hε : ‖z - p₀‖ ≤ ε) : ‖xiz (qP P) b z‖ ≤ 2 ^ b * (ε * L P) := by
  unfold xiz
  rw [norm_mul, norm_pow, eval_qP, norm_prod]
  have hz0 : z ≠ 0 := by
    intro h
    rw [h, norm_zero] at hz1
    linarith
  have hp0 : p₀ ≠ 0 := hP0 p₀ hp₀
  have hε0 : 0 ≤ ε := (norm_nonneg _).trans hε
  have hzi : ‖z⁻¹‖ ≤ 1 := by
    rw [norm_inv]
    exact inv_le_one_of_one_le₀ hz1
  have hfac : ∀ p ∈ P.erase p₀, ‖z⁻¹ - p⁻¹‖ ≤ 1 + ‖p⁻¹‖ := fun p _ =>
    (norm_sub_le _ _).trans (by linarith)
  have hnear : ‖z⁻¹ - p₀⁻¹‖ ≤ ε * (1 + ‖p₀⁻¹‖) := by
    have e : z⁻¹ - p₀⁻¹ = z⁻¹ * (p₀ - z) * p₀⁻¹ := by
      field_simp
      try ring
    rw [e, norm_mul, norm_mul, norm_sub_rev]
    calc ‖z⁻¹‖ * ‖z - p₀‖ * ‖p₀⁻¹‖ ≤ 1 * ε * ‖p₀⁻¹‖ := by gcongr
      _ ≤ ε * (1 + ‖p₀⁻¹‖) := by
        rw [one_mul]
        exact mul_le_mul_of_nonneg_left (by linarith) hε0
  have hprod : ∏ p ∈ P, ‖z⁻¹ - p⁻¹‖ ≤ ε * L P := by
    rw [L, ← Finset.mul_prod_erase P _ hp₀, ← Finset.mul_prod_erase P _ hp₀, ← mul_assoc]
    exact mul_le_mul hnear (Finset.prod_le_prod (fun _ _ => norm_nonneg _) hfac)
      (Finset.prod_nonneg fun _ _ => norm_nonneg _) (by positivity)
  exact mul_le_mul (pow_le_pow_left₀ (norm_nonneg _) hz2 b) hprod
    (Finset.prod_nonneg fun _ _ => norm_nonneg _) (by positivity)

/-- **A mode outside `P` is not a zero of the filter.** For `z` outside `P`,
`q(1/z) ≠ 0`. -/
theorem eval_qP_ne_zero {P : Finset ℂ} {z : ℂ} (hzP : z ∉ P) :
    (qP P).eval z⁻¹ ≠ 0 := by
  rw [eval_qP, Finset.prod_ne_zero_iff]
  intro p hp h
  rw [sub_eq_zero, inv_inj] at h
  exact hzP (h ▸ hp)

/-- **A large enough `b`.** For `c > 0` and `r > 1` there is `b` above the degree
of `q` with `W < c·r^b`. -/
theorem exists_b (q : Polynomial ℂ) (W : ℝ) {c r : ℝ} (hc : 0 < c) (hr : 1 < r) :
    ∃ b : ℕ, q.natDegree < b ∧ W < c * r ^ b := by
  obtain ⟨n, hn⟩ := pow_unbounded_of_one_lt (W / c) hr
  refine ⟨max n (q.natDegree + 1), by omega, ?_⟩
  have h1 : r ^ n ≤ r ^ (max n (q.natDegree + 1)) := pow_le_pow_right₀ hr.le (le_max_left _ _)
  rw [div_lt_iff₀ hc] at hn
  nlinarith

/-- **Finitely many accumulation points, and a zero right of `σ` off them: the
ladder bound fails.** Let `|ψ(2^k) − 2^k| ≤ C·k²·√2^k` for `k ≥ 1` and `σ > 1/2`.
Let `P` be a finite set of nonzero points such that, for every `ε > 0`, the mode
values `2^ρ` of the zeros with real part at least `σ` that lie at distance at least
`ε` from every point of `P` form a finite set. Then no zero with real part above `σ`
has its mode outside `P`. -/
theorem finite_accumulation_false {C : ℝ}
    (hH : ∀ k : ℕ, 1 ≤ k → ‖(Chebyshev.psi ((2:ℝ)^k) : ℂ) - (((2:ℝ)^k : ℝ) : ℂ)‖
      ≤ C * (k:ℝ)^2 * Real.sqrt 2 ^ k)
    {σ : ℝ} (hσ : 1/2 < σ) (P : Finset ℂ) (hP0 : ∀ p ∈ P, p ≠ 0)
    (hacc : ∀ ε : ℝ, 0 < ε →
      {z : ℂ | ∃ ρ : Kadiri.NontrivialZeros, σ ≤ (ρ : ℂ).re ∧ (2:ℂ) ^ (ρ : ℂ) = z ∧
        ∀ p ∈ P, ε ≤ ‖z - p‖}.Finite)
    (ρ₁ : Kadiri.NontrivialZeros) (hρ₁ : σ < (ρ₁ : ℂ).re) (hρ₁P : (2:ℂ) ^ (ρ₁ : ℂ) ∉ P) :
    False := by
  classical
  -- the threshold beaten at ρ₁
  set c₁ := ‖(qP P).eval ((2:ℂ) ^ (ρ₁ : ℂ))⁻¹‖ with hc₁def
  have hc₁ : 0 < c₁ := norm_pos_iff.mpr (eval_qP_ne_zero hρ₁P)
  set r := (2:ℝ) ^ ((ρ₁ : ℂ).re - σ) with hrdef
  have hr : 1 < r := Real.one_lt_rpow (by norm_num) (by linarith)
  obtain ⟨b, hbd, hbW⟩ := exists_b (qP P) (FilterLadder.Wn (qP P)) hc₁ hr
  have hb : 1 ≤ b := by omega
  have hab : 1 * (qP P).natDegree < b := by omega
  set v₁ := ‖xiz (qP P) b ((2:ℂ) ^ (ρ₁ : ℂ))‖ with hv₁def
  have hv₁ : v₁ = ((2:ℝ) ^ σ) ^ b * (c₁ * r ^ b) := by
    have e : (2:ℝ) ^ (ρ₁ : ℂ).re = (2:ℝ) ^ σ * (2:ℝ) ^ ((ρ₁ : ℂ).re - σ) := by
      rw [← Real.rpow_add (by norm_num)]
      ring_nf
    rw [hv₁def, xiz, norm_mul, norm_pow, norm_two_cpow, ← hc₁def, hrdef, e, mul_pow]
    ring
  have hthr1 : (2:ℝ) ^ (σ * b) * FilterLadder.Wn (qP P) ^ 1 < v₁ := by
    rw [pow_one, Real.rpow_mul_natCast (by norm_num), hv₁]
    exact mul_lt_mul_of_pos_left hbW (by positivity)
  have hv₁0 : 0 < v₁ := lt_of_le_of_lt (by
    have := FilterLadder.Wn_nonneg (qP P)
    positivity) hthr1
  -- the modes near P have small rate
  set ε := v₁ / (2 * (2 ^ b * L P)) with hεdef
  have hL := L_pos P
  have hε : 0 < ε := by positivity
  have hεv : (2:ℝ) ^ b * (ε * L P) = v₁ / 2 := by
    rw [hεdef]
    field_simp
    try ring
  have hnear : ∀ ρ : NontrivialZeros, ∀ p ∈ P, ‖(2:ℂ) ^ (ρ : ℂ) - p‖ < ε →
      ‖xiz (qP P) b ((2:ℂ) ^ (ρ : ℂ))‖ < v₁ := fun ρ p hp hlt => by
    have h := norm_xiz_near_le hP0 b (one_le_norm_mode ρ) (norm_mode_le_two ρ) hp hlt.le
    rw [hεv] at h
    linarith
  -- the other modes: a finite set of values, with a largest rate
  set F := {z : ℂ | ∃ ρ : Kadiri.NontrivialZeros, σ ≤ (ρ : ℂ).re ∧ (2:ℂ) ^ (ρ : ℂ) = z ∧
        ∀ p ∈ P, ε ≤ ‖z - p‖} with hFdef
  have hF : F.Finite := hacc ε hε
  have hz₁F : (2:ℂ) ^ (ρ₁ : ℂ) ∈ F := ⟨ρ₁, hρ₁.le, rfl, fun p hp => by
    by_contra h
    rw [not_le] at h
    exact lt_irrefl _ (hnear ρ₁ p hp h)⟩
  obtain ⟨z₀, hz₀F, hz₀max⟩ :=
    Set.exists_max_image F (fun z => ‖xiz (qP P) b z‖) hF ⟨_, hz₁F⟩
  have hv₀ : v₁ ≤ ‖xiz (qP P) b z₀‖ := hz₀max _ hz₁F
  obtain ⟨ρ₀, hρ₀, hm₀, -⟩ := hz₀F
  refine FilterAttained.filter_attained_false hH (qP P) hb hab hσ ρ₀ hρ₀ (fun ρ hρ => ?_) ?_
  · rw [xi_eq_xiz, xi_eq_xiz, hm₀]
    by_cases h : ∀ p ∈ P, ε ≤ ‖(2:ℂ) ^ (ρ : ℂ) - p‖
    · exact hz₀max _ ⟨ρ, hρ, rfl, h⟩
    · obtain ⟨p, hp, hlt⟩ : ∃ p ∈ P, ‖(2:ℂ) ^ (ρ : ℂ) - p‖ < ε := by
        by_contra hc
        apply h
        intro p hp
        by_contra h'
        exact hc ⟨p, hp, lt_of_not_ge h'⟩
      exact ((hnear ρ p hp hlt).trans_le hv₀).le
  · rw [xi_eq_xiz, hm₀]
    exact hthr1.trans_le hv₀

/-- info: 'FilterAccum.finite_accumulation_false' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms finite_accumulation_false

/-- **Finitely many accumulation points on every line right of `1/2`, and the ladder
of `ψ` of square-root size: then the Riemann hypothesis holds.** Let
`|ψ(2^k) − 2^k| ≤ C·k²·√2^k` for every `k ≥ 1`. Suppose that for every `σ > 1/2`
the modes `2^ρ` of the zeros with real part at least `σ` accumulate only at the
points of a finite set `P` of nonzero points (for every `ε > 0` the mode values at
distance at least `ε` from all of `P` are finitely many), none of which is the mode
of a zero with real part above `σ`. Then the Riemann hypothesis holds. -/
theorem rh_of_finite_accumulation {C : ℝ}
    (hH : ∀ k : ℕ, 1 ≤ k → ‖(Chebyshev.psi ((2:ℝ)^k) : ℂ) - (((2:ℝ)^k : ℝ) : ℂ)‖
      ≤ C * (k:ℝ)^2 * Real.sqrt 2 ^ k)
    (hfin : ∀ σ : ℝ, 1/2 < σ → ∃ P : Finset ℂ, (∀ p ∈ P, p ≠ 0) ∧
      (∀ ε : ℝ, 0 < ε → {z : ℂ | ∃ ρ : Kadiri.NontrivialZeros, σ ≤ (ρ : ℂ).re ∧
        (2:ℂ) ^ (ρ : ℂ) = z ∧ ∀ p ∈ P, ε ≤ ‖z - p‖}.Finite) ∧
      (∀ ρ : Kadiri.NontrivialZeros, σ < (ρ : ℂ).re → (2:ℂ) ^ (ρ : ℂ) ∉ P)) :
    RiemannHypothesis := by
  apply LandauWindow.rh_of_zeroFree_half
  intro s hs hz
  have hs1 : s.re < 1 := by
    by_contra h
    exact riemannZeta_ne_zero_of_one_le_re (not_lt.mp h) hz
  let ρ : NontrivialZeros := ⟨s, ⟨⟨by linarith, hs1⟩, Set.mem_univ _, hz⟩⟩
  have hσ : 1 / 2 < (1 / 2 + s.re) / 2 := by linarith
  obtain ⟨P, hP0, hacc, hnot⟩ := hfin _ hσ
  have hρ : (1 / 2 + s.re) / 2 < (ρ : ℂ).re := by
    show (1 / 2 + s.re) / 2 < s.re
    linarith
  exact finite_accumulation_false hH hσ P hP0 hacc ρ hρ (hnot ρ hρ)

/-- info: 'FilterAccum.rh_of_finite_accumulation' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms rh_of_finite_accumulation

end

end FilterAccum
