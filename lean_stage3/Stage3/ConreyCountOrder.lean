/-
ConreyCountOrder — block S13 of `lean_stage3/design/stencil.md`, B4 step 1, the zeros of `V` on
the line. 2026-11-25.

S11 "removing `hsimple`" divided the zeros of `G = ζ + cζ′` on the line out of the count and
paid for them with the order of `ζ`, `ord ζ = ord G + 1` (`LevinsonMultiple.G_order_add_one`,
which needs `c ≠ 0`). For `V = W/Gammaℝ` and a general `Q` that relation fails: at a zero of
`Λ` of order `m`, `W^{(j)}(ρ) = Σ_{k ≥ m−j} b_k (−1/L)^k Λ^{(j+k)}(ρ)`, and nothing forces
`ord W ≤ m − 1`. What holds instead, and is what the count needs, is Conrey's remark after his
(1) ("such a point is a zero of `ξ^{(m)}` of multiplicity at least `n`"), with one more unit at a
crossing:

* write `V = P·H` with `P = Π_{ρ∈D}(s − ρ)^{n ρ}` and `F = i^K·Gammaℝ·H`, `K = Σ n ρ`. On the
  line `P = i^K·p(t)` with `p` real (`LevinsonMultiple.polyP_line`), so `W = p·F` there, and
  `Re W = Q(1/2)·Λ` (`OperatorQ.re_W_line`) gives the real identity
  `Q(1/2)·Λ(1/2 + t i) = p(t)·Re F(t)` for every `t` (`line_identity`);
* at `ρ = 1/2 + γ i ∈ D` write `ζ = (s − ρ)^m A`, `A(ρ) ≠ 0`, and `p = (t − γ)^{n ρ}·p₀`.
  Then `(t − γ)^m·f(t) = (t − γ)^{n ρ}·g(t)` near `γ`, with `f = Q(1/2)·Gammaℝ·i^m·A ≠ 0` at `γ`
  and `g = p₀·Re F`, both continuous. Dividing and letting `t → γ` (`order_cmp`):
  `n ρ ≤ m`, and `n ρ + 1 ≤ m` when `Re F(γ) = 0` (`zeta_order_ge_line`).

So each `ρ ∈ D` is counted by `lineCount` with weight at least `n ρ`, and at least `n ρ + 1`
when it is also a crossing of `F`; the `K` of the edge terms cancels as in `LevinsonMultiple`,
with no condition like `c ≠ 0`.

  | name                    | statement                                                         | status |
  |-------------------------|-------------------------------------------------------------------|--------|
  | `order_cmp`             | `f, g` continuous at `γ`, `f γ ≠ 0`, `(t−γ)^m f = (t−γ)^n g` near `γ` ⊢ `n ≤ m ∧ (g γ = 0 → n + 1 ≤ m)` | PROVED |
  | `zeta_order_eq`         | `ρ ≠ 1` ⊢ `riemannZeta.order ρ = (analyticOrderAt ζ ρ).toNat`      | PROVED |
  | `line_identity`         | `V = P·H`, `D` on the line ⊢ `Q(1/2)·Λ(1/2+ti) = p(t)·Re F(t)`     | PROVED |
  | `zeta_order_ge_line`    | the same, `ρ ∈ D` ⊢ `n ρ ≤ ord ζ ρ`, and `n ρ + 1 ≤ ord ζ ρ` if `Re F(γ) = 0` | PROVED |

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.ConreyCountLine
import Stage3.LevinsonWindowNear
import Stage3.ContourShift

noncomputable section

namespace ConreyCount

open Complex Polynomial Filter Topology LevinsonMultiple

/-- **Comparing orders along a real variable.** If `(t − γ)^m f t = (t − γ)^n g t` near `γ`,
with `f`, `g` continuous at `γ` and `f γ ≠ 0`, then `n ≤ m`, and `n + 1 ≤ m` if `g γ = 0`. -/
theorem order_cmp {γ : ℝ} {m n : ℕ} {f g : ℝ → ℂ} (hf : ContinuousAt f γ)
    (hg : ContinuousAt g γ) (hf0 : f γ ≠ 0)
    (heq : ∀ᶠ t in 𝓝 γ, (((t - γ : ℝ) : ℂ)) ^ m * f t = (((t - γ : ℝ) : ℂ)) ^ n * g t) :
    n ≤ m ∧ (g γ = 0 → n + 1 ≤ m) := by
  by_contra hcon
  have hmn : m ≤ n ∧ (m < n ∨ g γ = 0) := by
    rcases Nat.lt_or_ge m n with h | h
    · exact ⟨h.le, Or.inl h⟩
    · refine ⟨?_, Or.inr ?_⟩
      · by_contra h'
        exact hcon ⟨h, fun hg0 => by omega⟩
      · by_contra hg0
        exact hcon ⟨h, fun h' => absurd h' hg0⟩
  obtain ⟨hle, hor⟩ := hmn
  -- on the punctured neighbourhood, `f = (t − γ)^(n − m) · g`
  have hev : ∀ᶠ t in 𝓝[≠] γ, f t = (((t - γ : ℝ) : ℂ)) ^ (n - m) * g t := by
    filter_upwards [nhdsWithin_le_nhds heq, self_mem_nhdsWithin] with t ht htne
    have hne : (((t - γ : ℝ) : ℂ)) ^ m ≠ 0 :=
      pow_ne_zero _ (by
        rw [Ne, Complex.ofReal_eq_zero, sub_eq_zero]
        exact htne)
    have e : (((t - γ : ℝ) : ℂ)) ^ n = (((t - γ : ℝ) : ℂ)) ^ m * (((t - γ : ℝ) : ℂ)) ^ (n - m) := by
      rw [← pow_add, Nat.add_sub_cancel' hle]
    rw [e, mul_assoc] at ht
    exact mul_left_cancel₀ hne ht
  have hc : ContinuousAt (fun t : ℝ => (((t - γ : ℝ) : ℂ)) ^ (n - m) * g t) γ := by
    have h1 : ContinuousAt (fun t : ℝ => (((t - γ : ℝ) : ℂ)) ^ (n - m)) γ := by fun_prop
    exact h1.mul hg
  have hlim1 : Tendsto f (𝓝[≠] γ) (𝓝 (f γ)) := hf.tendsto.mono_left nhdsWithin_le_nhds
  have hlim2 : Tendsto f (𝓝[≠] γ)
      (𝓝 ((((γ - γ : ℝ) : ℂ)) ^ (n - m) * g γ)) :=
    (hc.tendsto.mono_left nhdsWithin_le_nhds).congr' (hev.mono fun t ht => ht.symm)
  have hval := tendsto_nhds_unique hlim1 hlim2
  rw [sub_self, Complex.ofReal_zero] at hval
  apply hf0
  rw [hval]
  rcases hor with h | h
  · rw [zero_pow (by omega), zero_mul]
  · rw [h, mul_zero]

/-- The tree's order of `ζ` is its analytic order off the pole. -/
theorem zeta_order_eq {ρ : ℂ} (hρ1 : ρ ≠ 1) :
    riemannZeta.order ρ = ((analyticOrderAt riemannZeta ρ).toNat : ℤ) := by
  have hdz : DifferentiableOn ℂ riemannZeta {1}ᶜ := fun z hz =>
    (differentiableAt_riemannZeta hz).differentiableWithinAt
  have hζ : AnalyticAt ℂ riemannZeta ρ := hdz.analyticAt (isOpen_compl_singleton.mem_nhds hρ1)
  obtain ⟨m, hm⟩ := ENat.ne_top_iff_exists.mp (ContourShift.zeta_order_ne_top hρ1)
  unfold riemannZeta.order
  rw [hζ.meromorphicOrderAt_eq, ← hm, ENat.map_coe, WithTop.untopD_coe]
  simp

/-- **The real identity on the line.** For `V = P·H` with `D` on the line and
`F = i^K·Gammaℝ·H`: `Q(1/2)·Λ(1/2 + t i) = p(t)·Re F(t)`, `p(t) = Π_{ρ∈D}(t − Im ρ)^{n ρ}`. -/
theorem line_identity {Q : ℝ[X]}
    (hQ : ∀ x : ℝ, Q.derivative.eval x = Q.derivative.eval (1 - x)) {L : ℝ}
    {D : Finset ℂ} {n : ℂ → ℕ} {H : ℂ → ℂ} (hD : ∀ ρ ∈ D, ρ.re = 1/2)
    (hVPH : ∀ s, V Q L s = polyP D n s * H s) (t : ℝ) :
    ((Q.eval (1/2 : ℝ) : ℝ) : ℂ) * completedRiemannZeta (1/2 + t * I) =
      (((∏ ρ ∈ D, (t - ρ.im) ^ n ρ) *
        (I ^ (∑ ρ ∈ D, n ρ) * (Gammaℝ (1/2 + t * I) * H (1/2 + t * I))).re : ℝ) : ℂ) := by
  have hG : Gammaℝ ((1/2 : ℂ) + t * I) ≠ 0 :=
    Gammaℝ_ne_zero_of_re_pos (LevinsonLine.line_facts t).2.2
  have hW : OperatorQ.W Q L (1/2 + t * I) =
      ((∏ ρ ∈ D, (t - ρ.im) ^ n ρ : ℝ) : ℂ) *
        (I ^ (∑ ρ ∈ D, n ρ) * (Gammaℝ (1/2 + t * I) * H (1/2 + t * I))) := by
    rw [W_eq_gammaR_mul_V Q L hG, hVPH, polyP_line n hD]
    ring
  have hre := OperatorQ.re_W_line Q hQ L t
  rw [hW, Complex.re_ofReal_mul] at hre
  have hΛ : completedRiemannZeta ((1/2 : ℂ) + t * I) =
      ((completedRiemannZeta ((1/2 : ℂ) + t * I)).re : ℂ) :=
    Complex.ext (by rw [Complex.ofReal_re]) (by rw [Complex.ofReal_im]; exact HardyZ.xi_line_real t)
  rw [hΛ, ← Complex.ofReal_mul, ← hre]

/-- **The order of `ζ` at a zero of `V` on the line.** For `V = P·H` with `D` on the line,
`H` analytic at `ρ ∈ D` and `Q(1/2) ≠ 0`: `n ρ ≤ ord ζ ρ`, and `n ρ + 1 ≤ ord ζ ρ` where
`Re F(Im ρ) = 0`. -/
theorem zeta_order_ge_line {Q : ℝ[X]}
    (hQ : ∀ x : ℝ, Q.derivative.eval x = Q.derivative.eval (1 - x))
    (hQh : Q.eval (1/2) ≠ 0) {L : ℝ}
    {D : Finset ℂ} {n : ℂ → ℕ} {H : ℂ → ℂ} (hD : ∀ ρ ∈ D, ρ.re = 1/2)
    (hVPH : ∀ s, V Q L s = polyP D n s * H s) {ρ : ℂ} (hρ : ρ ∈ D)
    (hHa : AnalyticAt ℂ H ρ) :
    (n ρ : ℤ) ≤ riemannZeta.order ρ ∧
      ((I ^ (∑ ρ' ∈ D, n ρ') * (Gammaℝ ρ * H ρ)).re = 0 → (n ρ : ℤ) + 1 ≤ riemannZeta.order ρ) := by
  classical
  set γ := ρ.im with hγ
  have hρeq : ρ = (1/2 : ℂ) + γ * I := by
    apply Complex.ext <;> simp [hD ρ hρ, hγ]
  obtain ⟨h0, h1, hre⟩ := LevinsonLine.line_facts γ
  rw [← hρeq] at h0 h1 hre
  -- the order of `ζ` at `ρ`
  have hdz : DifferentiableOn ℂ riemannZeta {1}ᶜ := fun z hz =>
    (differentiableAt_riemannZeta hz).differentiableWithinAt
  have hζ : AnalyticAt ℂ riemannZeta ρ := hdz.analyticAt (isOpen_compl_singleton.mem_nhds h1)
  obtain ⟨m, hm⟩ := ENat.ne_top_iff_exists.mp (ContourShift.zeta_order_ne_top h1)
  obtain ⟨A, hAa, hA0, hAev⟩ := (hζ.analyticOrderAt_eq_natCast (n := m)).mp hm.symm
  have hord : riemannZeta.order ρ = m := by
    rw [zeta_order_eq h1, ← hm]
    simp
  -- the line near `γ`
  set ln : ℝ → ℂ := fun t => (1/2 : ℂ) + t * I with hln
  have hlnc : Continuous ln := LevinsonTurn.continuous_line
  have hlnγ : ln γ = ρ := hρeq.symm
  have hsub : ∀ t : ℝ, ln t - ρ = I * (((t - γ : ℝ) : ℂ)) := by
    intro t
    rw [hρeq]
    simp only [hln]
    push_cast
    ring
  have hAev' : ∀ᶠ t in 𝓝 γ,
      riemannZeta (ln t) = (ln t - ρ) ^ m • A (ln t) := by
    have ht : Tendsto ln (𝓝 γ) (𝓝 ρ) := by
      rw [← hlnγ]; exact hlnc.continuousAt.tendsto
    exact ht.eventually hAev
  -- the two sides
  set h : ℂ := ((Q.eval (1/2 : ℝ) : ℝ) : ℂ) with hh
  set f : ℝ → ℂ := fun t => h * Gammaℝ (ln t) * I ^ m * A (ln t) with hf
  set p₀ : ℝ → ℝ := fun t => ∏ ρ' ∈ D.erase ρ, (t - ρ'.im) ^ n ρ' with hp₀
  set K : ℕ := ∑ ρ' ∈ D, n ρ' with hK
  set g : ℝ → ℂ := fun t =>
    ((p₀ t * (I ^ K * (Gammaℝ (ln t) * H (ln t))).re : ℝ) : ℂ) with hg
  have hGc : ContinuousAt (fun t : ℝ => Gammaℝ (ln t)) γ :=
    ContinuousAt.comp (g := Gammaℝ) (f := ln)
      (by rw [hlnγ]; exact (analyticAt_Gammaℝ' (Gammaℝ_ne_zero_of_re_pos hre)).continuousAt)
      hlnc.continuousAt
  have hAc : ContinuousAt (fun t : ℝ => A (ln t)) γ :=
    ContinuousAt.comp (g := A) (f := ln) (by rw [hlnγ]; exact hAa.continuousAt)
      hlnc.continuousAt
  have hHc : ContinuousAt (fun t : ℝ => H (ln t)) γ :=
    ContinuousAt.comp (g := H) (f := ln) (by rw [hlnγ]; exact hHa.continuousAt)
      hlnc.continuousAt
  have hfc : ContinuousAt f γ := by
    simp only [hf]
    exact ((continuousAt_const.mul hGc).mul continuousAt_const).mul hAc
  have hgc : ContinuousAt g γ := by
    simp only [hg]
    apply Complex.continuous_ofReal.continuousAt.comp
    have hp : ContinuousAt p₀ γ := by
      simp only [hp₀]
      fun_prop
    exact hp.mul (Complex.continuous_re.continuousAt.comp
      (continuousAt_const.mul (hGc.mul hHc)))
  have hf0 : f γ ≠ 0 := by
    simp only [hf]
    rw [hlnγ]
    refine mul_ne_zero (mul_ne_zero (mul_ne_zero ?_ (Gammaℝ_ne_zero_of_re_pos hre))
      (pow_ne_zero _ Complex.I_ne_zero)) hA0
    rw [hh, Ne, Complex.ofReal_eq_zero]
    exact hQh
  have heq : ∀ᶠ t in 𝓝 γ, (((t - γ : ℝ) : ℂ)) ^ m * f t = (((t - γ : ℝ) : ℂ)) ^ (n ρ) * g t := by
    filter_upwards [hAev'] with t ht
    have hid := line_identity hQ hD hVPH (L := L) t
    have hGt : Gammaℝ (ln t) ≠ 0 := Gammaℝ_ne_zero_of_re_pos (LevinsonLine.line_facts t).2.2
    have hΛ : completedRiemannZeta (ln t) = Gammaℝ (ln t) * riemannZeta (ln t) := by
      rw [riemannZeta_def_of_ne_zero (LevinsonLine.line_facts t).1, mul_div_cancel₀ _ hGt]
    have hprod : (∏ ρ' ∈ D, (t - ρ'.im) ^ n ρ') = (t - γ) ^ n ρ * p₀ t := by
      rw [← Finset.mul_prod_erase D (fun ρ' => (t - ρ'.im) ^ n ρ') hρ]
    rw [hprod] at hid
    have e1 : (((t - γ : ℝ) : ℂ)) ^ m * f t = h * completedRiemannZeta (ln t) := by
      rw [hΛ, ht, hsub, smul_eq_mul]
      simp only [hf]
      ring
    rw [e1]
    simp only [hg]
    have e2 : (h * completedRiemannZeta (ln t)) =
        ((((t - γ) ^ n ρ * p₀ t) * (I ^ K * (Gammaℝ (ln t) * H (ln t))).re : ℝ) : ℂ) := hid
    rw [e2]
    push_cast
    ring
  obtain ⟨hle, hlt⟩ := order_cmp hfc hgc hf0 heq
  rw [hord]
  refine ⟨by exact_mod_cast hle, fun hF => ?_⟩
  have hg0 : g γ = 0 := by
    simp only [hg]
    rw [hlnγ, hF, mul_zero, Complex.ofReal_zero]
  exact_mod_cast hlt hg0

/-- info: 'ConreyCount.order_cmp' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms order_cmp

/-- info: 'ConreyCount.zeta_order_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms zeta_order_eq

/-- info: 'ConreyCount.line_identity' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms line_identity

/-- info: 'ConreyCount.zeta_order_ge_line' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms zeta_order_ge_line

end ConreyCount

end
