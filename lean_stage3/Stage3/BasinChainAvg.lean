/-
BasinChainAvg — block S15 of `lean_stage3/design/stencil.md`, the chain from no right zeros,
steps 3 and 4: the sizes of `J` and Turing's averaging of the increment. 2026-11-25.

Pins: `PINS.md` § Current, "the chain to the goal from no right zeros".

**Step 3, the sizes of `J(t) = ∫_{1/2}^{3} log‖V(x + it)‖ dx`.** Upper (`logJ_le`): where
`‖V‖ ≤ M` on the disc of radius `21/8` about `3 + it` (`ConreyCount.StmtVDisc`, which
`DigammaBound.stmtVEdges_holds` gives with `M = A·t`), `J(t) ≤ (5/2) log M`, since the
segment `[1/2, 3] + it` lies in the disc. Lower: open, `StmtVHorizLower Q a₂ b₂ T₀`:
`J(t) ≥ −(a₂ log t + b₂)` for `t ∈ [T/4, 2T]`, `T ≥ T₀`, `L = log T`. Citation shape: the
horizontal lower bound of Littlewood's lemma (Titchmarsh 9.9), as
`LittlewoodSharpHoriz.horizLower_sharp` for `ζ`. Budget: `a₂, b₂ = O_Q(1)`, true for
`T ≥ T₀(Q)`. Route: Jensen with the zeros removed and Borel–Carathéodory on a disc about
`3 + it` of radius `10/3` (so that `[1/2, 3] + it` sits at `3/4` of the radius), with
`|V(3 + it)| ≥ 1/3` (`DigammaBound.right_edge_ge`) at the centre and `‖V‖ ≤ A_Q t` on the disc;
the disc bound needs `DigammaBound.gamma_ratio` on `Re z ∈ [−1/3, 7]` (the tree has
`[1/4, 7]`). Non-vacuous: it bounds `J` below at every height of the window, and `log‖V‖` is
`−∞` at the zeros of `V` left of `Re 1/2` only on a null set.

**Step 4, the averaging** (`avg_double`, `increment_avg`, `defect_step`). The increment of
`BasinChainCount.increment_window` holds at every pair of heights `a ∈ [T/2, 3T/4]`,
`b ∈ [T, 5T/4]` off the finitely many heights of zeros. `D` is monotone, so
`X = D T − D(3T/4) ≤ D b − D a` for all of them. Averaging `b` and then `a` over the windows,
`h = T/4` (`avg_double`), with `∫ S` by `LittlewoodSharp.littlewood_sharp` (`a = 119/(4π)`,
`b = (130 + (3/2) log 9)/π`) and `∫ hEdge = J t₁ − J t₂` (`BasinChainSplit.split_V`):

  `X ≤ 4 (α log(2T) + β)/T + c₀`,  `c₀ = 1 + 2 arcsin(π²/6 − 1 + 1/100)/π ≈ 1.455`,

`α = 2a + (5 + 2a₂)/π`, `β = 2b + (5 log(A + 1) + 2b₂)/π`. The error falls like `log T/T`
(`checks/basinchain/sizes.out` § 3), so `X < 2` for large `T`; `X` is even and `≥ 0`, so
`X = 0`: `D T = D(3T/4)` (`defect_step`). No factor is lost.

**What the averaging does not give: `D(T) = 0`.** `V = V Q (log T)` is controlled only on
`[T/4, 2T]` (`ConreyCount` header: the shift inside `Q` is `≈ j log 2/(2L)` at `t ≈ T/2^j`), so
the count is a difference count: it bounds `D b − D a`, never `D b` alone. The averaging closes
the increments; the value of `D` from which they start is not seen. So the chain gives `D`
constant from some height on (`defect_eventually_const`, in `BasinChain`): finitely many zeros
off the line. RH needs, in addition, that this constant is `0`.

  | name | statement | status |
  |---|---|---|
  | `StmtVHorizLower` | `J(t) ≥ −(a₂ log t + b₂)` on the window | OPEN (def) |
  | `logJ_le` | `StmtVDisc Q L t M`, `1 ≤ M` ⊢ `J(t) ≤ (5/2) log M` | PROVED |
  | `avg_double` | the pointwise bound off a countable set ⊢ the averaged bound | PROVED |
  | `err_eventually` | `4 (α log(2T) + β)/T < m` eventually, `m > 0` | PROVED |
  | `c0_lt_two` | `1 + 2 arcsin(π²/6 − 1 + 1/100)/π < 2` | PROVED |
  | `increment_avg` | `X ≤ 4 (α log(2T) + β)/T + c₀` for `T ≥ T₁` | PROVED |
  | `defect_step` | `StmtNoRightZeros`, `StmtVHorizLower` ⊢ `∃ T₂, ∀ T ≥ T₂, D T = D(3T/4)` | PROVED |

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.BasinChainSplit
import Stage3.LittlewoodSharp

noncomputable section

namespace BasinChain

open Complex MeasureTheory Set Filter Polynomial ConreyCount LineCount Kadiri
open scoped Interval Topology

/-- **Open: the lower side of `J`.** For `T ≥ T₀`, `L = log T` and every `t ∈ [T/4, 2T]`:
`∫_{1/2}^{3} log‖V(x + it)‖ dx ≥ −(a₂ log t + b₂)`. -/
def StmtVHorizLower (Q : ℝ[X]) (a₂ b₂ T₀ : ℝ) : Prop :=
  ∀ T : ℝ, T₀ ≤ T → ∀ t ∈ Icc (T / 4) (2 * T), -(a₂ * Real.log t + b₂) ≤ logJ Q (Real.log T) t

/-- **The upper side of `J`.** -/
theorem logJ_le (Q : ℝ[X]) {L t M : ℝ} (ht : 1/2 < t) (hM : 1 ≤ M) (hD : StmtVDisc Q L t M) :
    logJ Q L t ≤ (5 / 2) * Real.log M := by
  have hlogM : 0 ≤ Real.log M := Real.log_nonneg hM
  have hpt : ∀ x ∈ Icc (1/2 : ℝ) 3, Real.log ‖V Q L ((x : ℂ) + (t : ℂ) * I)‖ ≤ Real.log M := by
    intro x hx
    have hd : ‖((x : ℂ) + (t : ℂ) * I) - (3 + t * I)‖ ≤ 21 / 8 := by
      have e : ((x : ℂ) + (t : ℂ) * I) - (3 + t * I) = ((x - 3 : ℝ) : ℂ) := by push_cast; ring
      rw [e, Complex.norm_real, Real.norm_eq_abs, abs_of_nonpos (by linarith [hx.2])]
      linarith [hx.1]
    have hV := hD _ hd
    rcases eq_or_lt_of_le (norm_nonneg (V Q L ((x : ℂ) + (t : ℂ) * I))) with h0 | hpos
    · rw [← h0, Real.log_zero]; exact hlogM
    · exact Real.log_le_log hpos hV
  have h := intervalIntegral.integral_mono_on (by norm_num : (1/2 : ℝ) ≤ 3)
    (intervalIntegrable_log_V Q L ht _ _) intervalIntegrable_const hpt
  unfold logJ
  rw [intervalIntegral.integral_const, smul_eq_mul] at h
  linarith

/-- **The double average.** If `X ≤ f b − g a + c` for `a ∈ [A, A + h]`, `b ∈ [B, B + h]` off a
countable set, then `X ≤ (∫ f − ∫ g)/h + c`. -/
theorem avg_double {X c A B h : ℝ} {f g : ℝ → ℝ} (hh : 0 < h) {E : Set ℝ} (hE : E.Countable)
    (hf : IntervalIntegrable f volume B (B + h)) (hg : IntervalIntegrable g volume A (A + h))
    (hpt : ∀ a ∈ Icc A (A + h), a ∉ E → ∀ b ∈ Icc B (B + h), b ∉ E → X ≤ f b - g a + c) :
    X ≤ ((∫ b in B..B + h, f b) - ∫ a in A..A + h, g a) / h + c := by
  have hAh : A ≤ A + h := by linarith
  have hBh : B ≤ B + h := by linarith
  have hae : ∀ U : ℝ, ∀ᵐ x ∂(volume.restrict (Icc U (U + h))), x ∈ Icc U (U + h) ∧ x ∉ E := by
    intro U
    filter_upwards [ae_restrict_mem measurableSet_Icc, ae_restrict_of_ae (hE.ae_notMem volume)]
      with x h1 h2
    exact ⟨h1, h2⟩
  -- the average over `b`, at a good `a`
  have hstep : ∀ a ∈ Icc A (A + h), a ∉ E →
      g a ≤ (∫ b in B..B + h, f b) / h - X + c := by
    intro a ha haE
    have hint := intervalIntegral.integral_mono_ae_restrict hBh
      (intervalIntegrable_const (c := X + g a - c)) hf (by
        filter_upwards [hae B] with b hb
        have := hpt a ha haE b hb.1 hb.2
        linarith)
    rw [intervalIntegral.integral_const, smul_eq_mul, show B + h - B = h by ring] at hint
    have h2 : g a + X - c ≤ (∫ b in B..B + h, f b) / h := by
      rw [le_div_iff₀ hh]
      have e : (g a + X - c) * h = h * (X + g a - c) := by ring
      rw [e]; exact hint
    linarith
  -- the average over `a`
  have hint := intervalIntegral.integral_mono_ae_restrict hAh hg
    (intervalIntegrable_const (c := (∫ b in B..B + h, f b) / h - X + c)) (by
      filter_upwards [hae A] with a ha
      exact hstep a ha.1 ha.2)
  rw [intervalIntegral.integral_const, smul_eq_mul] at hint
  have e : (A + h - A) * ((∫ b in B..B + h, f b) / h - X + c)
      = (∫ b in B..B + h, f b) - h * X + h * c := by
    field_simp
    ring
  rw [e] at hint
  rw [div_add' _ _ _ hh.ne', le_div_iff₀ hh]
  nlinarith [hint]

/-- The error of the average falls below any `m > 0`. -/
theorem err_eventually (α β : ℝ) {m : ℝ} (hm : 0 < m) :
    ∃ T₃ : ℝ, ∀ T : ℝ, T₃ ≤ T → 4 * α * (Real.log T ^ 1 / (1 * T + 0))
      + 4 * (α * Real.log 2 + β) / T < m := by
  have h1 := (Real.tendsto_pow_log_div_mul_add_atTop 1 0 1 one_ne_zero).const_mul (4 * α)
  have h2 : Tendsto (fun T : ℝ => 4 * (α * Real.log 2 + β) / T) atTop (𝓝 0) :=
    tendsto_const_nhds.div_atTop tendsto_id
  have h := h1.add h2
  rw [mul_zero, add_zero] at h
  exact eventually_atTop.mp (h.eventually (gt_mem_nhds hm))

/-- `c₀ < 2`. -/
theorem c0_lt_two : 1 + 2 * Real.arcsin (Real.pi ^ 2 / 6 - 1 + 1 / 100) / Real.pi < 2 := by
  have h := Real.arcsin_lt_pi_div_two.mpr r0_lt_one
  have hπ := Real.pi_pos
  rw [← sub_pos]
  have : 2 - (1 + 2 * Real.arcsin (Real.pi ^ 2 / 6 - 1 + 1 / 100) / Real.pi)
      = (Real.pi - 2 * Real.arcsin (Real.pi ^ 2 / 6 - 1 + 1 / 100)) / Real.pi := by
    field_simp; ring
  rw [this]
  apply div_pos _ hπ
  linarith

/-- A good height: off the heights of the zeros up to `2T`, no zero sits at it. -/
theorem good_of_notMem {T a : ℝ} (ha0 : 0 < a) (haT : a ≤ 2 * T)
    (h : a ∉ (((zerosUpTo (2 * T)).image (fun ρ : NontrivialZeros => (ρ : ℂ).im) : Finset ℝ) :
      Set ℝ)) :
    ∀ ρ : NontrivialZeros, (ρ : ℂ).im ≠ a := by
  intro ρ hρ
  apply h
  rw [Finset.mem_coe, Finset.mem_image]
  exact ⟨ρ, mem_zerosUpTo.mpr ⟨by rw [hρ]; exact ha0, by rw [hρ]; exact haT⟩, hρ⟩

set_option maxHeartbeats 1600000 in
/-- **The averaged increment.** For `Q′` symmetric, `Q(1/2) ≠ 0`, `Q(0) = 1`, the hypothesis and
the lower side: there are `A > 0` and `T₁` with, for `T ≥ T₁`,
`D T − D(3T/4) ≤ 4 (α log(2T) + β)/T + c₀`. -/
theorem increment_avg {Q : ℝ[X]}
    (hQ : ∀ x : ℝ, Q.derivative.eval x = Q.derivative.eval (1 - x))
    (hQh : Q.eval (1/2) ≠ 0) (hQ0 : Q.eval 0 = 1) {T₀ a₂ b₂ T₀' : ℝ}
    (hNR : StmtNoRightZeros Q T₀) (hLow : StmtVHorizLower Q a₂ b₂ T₀') (ha₂ : 0 ≤ a₂) :
    ∃ A T₁ : ℝ, 0 < A ∧ 200 ≤ T₁ ∧ ∀ T : ℝ, T₁ ≤ T →
      ((Defect.defect T : ℝ) - (Defect.defect (3 * T / 4) : ℝ)) ≤
        4 * ((2 * ((3 / 2 + 113 / 4) / Real.pi) + (5 + 2 * a₂) / Real.pi) * Real.log (2 * T)
          + (2 * ((2 + (3 / 2) * Real.log 9 + 128) / Real.pi)
            + (5 * Real.log (A + 1) + 2 * b₂) / Real.pi)) / T
        + (1 + 2 * Real.arcsin (Real.pi ^ 2 / 6 - 1 + 1 / 100) / Real.pi) := by
  obtain ⟨T₁, hT₁, hinc⟩ := increment_window hQ hQh hQ0
  obtain ⟨A, T₀e, hA, hEdges⟩ := DigammaBound.stmtVEdges_holds Q hQ0
  refine ⟨A, max T₁ (max T₀ (max T₀' T₀e)), hA, le_trans hT₁ (le_max_left _ _), ?_⟩
  intro T hT
  have hT1 : T₁ ≤ T := le_trans (le_max_left _ _) hT
  have hT0 : T₀ ≤ T := le_trans (le_trans (le_max_left _ _) (le_max_right _ _)) hT
  have hT0' : T₀' ≤ T :=
    le_trans (le_trans (le_trans (le_max_left _ _) (le_max_right _ _)) (le_max_right _ _)) hT
  have hT0e : T₀e ≤ T :=
    le_trans (le_trans (le_trans (le_max_right _ _) (le_max_right _ _)) (le_max_right _ _)) hT
  have hT200 : 200 ≤ T := le_trans hT₁ hT1
  have hTpos : 0 < T := by linarith
  have hπ := Real.pi_pos
  set aL : ℝ := (3 / 2 + 113 / 4) / Real.pi with haL
  set bL : ℝ := (2 + (3 / 2) * Real.log 9 + 128) / Real.pi with hbL
  set c₀ : ℝ := 1 + 2 * Real.arcsin (Real.pi ^ 2 / 6 - 1 + 1 / 100) / Real.pi with hc₀
  set L := Real.log T with hLdef
  have haL0 : 0 ≤ aL := by rw [haL]; positivity
  -- the window functions
  set f : ℝ → ℝ := fun b => Turing.S b + hEdge Q L b / Real.pi with hf
  set g : ℝ → ℝ := fun a => Turing.S a + hEdge Q L a / Real.pi with hg
  set E : Set ℝ := (((zerosUpTo (2 * T)).image (fun ρ : NontrivialZeros => (ρ : ℂ).im) :
    Finset ℝ) : Set ℝ) with hE
  have hEc : E.Countable := Finset.countable_toSet _
  -- the edges of `V` on `Re 3`
  have hne3 : ∀ t ∈ Icc (T / 4) (2 * T), V Q L (3 + t * I) ≠ 0 := by
    intro t ht h0
    have := (hEdges T hT0e t ht).1
    rw [h0, Complex.zero_re] at this
    norm_num at this
  have hsplitB := split_V Q L (t₁ := T) (t₂ := T + T / 4) (by linarith) (by linarith)
    (hne3 T ⟨by linarith, by linarith⟩)
  have hsplitA := split_V Q L (t₁ := T / 2) (t₂ := T / 2 + T / 4) (by linarith) (by linarith)
    (hne3 (T / 2) ⟨by linarith, by linarith⟩)
  have hfi : IntervalIntegrable f volume T (T + T / 4) :=
    (Turing.intervalIntegrable_S _ _).add (hsplitB.1.div_const _)
  have hgi : IntervalIntegrable g volume (T / 2) (T / 2 + T / 4) :=
    (Turing.intervalIntegrable_S _ _).add (hsplitA.1.div_const _)
  -- the pointwise bound
  have hpt : ∀ a ∈ Icc (T / 2) (T / 2 + T / 4), a ∉ E → ∀ b ∈ Icc T (T + T / 4), b ∉ E →
      ((Defect.defect T : ℝ) - (Defect.defect (3 * T / 4) : ℝ)) ≤ f b - g a + c₀ := by
    intro a ha haE b hb hbE
    have hmono1 : (Defect.defect T : ℝ) ≤ Defect.defect b := by
      exact_mod_cast Turing.defect_mono hb.1
    have hmono2 : (Defect.defect a : ℝ) ≤ Defect.defect (3 * T / 4) := by
      exact_mod_cast Turing.defect_mono (by linarith [ha.2])
    have hfree : ∀ s : ℂ, 1/2 < s.re → s.re ≤ 3 → a ≤ s.im → s.im ≤ b →
        V Q (Real.log T) s ≠ 0 := fun s h1 h2 h3 h4 =>
      hNR T hT0 s h1 h2 (by linarith [ha.1]) (by linarith [hb.2])
    have hi := hinc hT1 (by linarith [ha.1]) (by linarith [ha.2, hb.1]) (by linarith [hb.2])
      hfree (good_of_notMem (by linarith [ha.1]) (by linarith [ha.2]) haE)
      (good_of_notMem (by linarith [hb.1]) (by linarith [hb.2]) hbE)
    simp only [hf, hg]
    linarith
  have havg := avg_double (by linarith : (0 : ℝ) < T / 4) hEc hfi hgi hpt
  -- the integrals
  have hIf : (∫ b in T..T + T / 4, f b) = (Turing.S₁ (T + T / 4) - Turing.S₁ T)
      + (logJ Q L T - logJ Q L (T + T / 4)) / Real.pi := by
    simp only [hf]
    rw [intervalIntegral.integral_add (Turing.intervalIntegrable_S _ _) (hsplitB.1.div_const _),
      intervalIntegral.integral_div, hsplitB.2, Turing.S₁_sub]
  have hIg : (∫ a in T / 2..T / 2 + T / 4, g a) = (Turing.S₁ (T / 2 + T / 4) - Turing.S₁ (T / 2))
      + (logJ Q L (T / 2) - logJ Q L (T / 2 + T / 4)) / Real.pi := by
    simp only [hg]
    rw [intervalIntegral.integral_add (Turing.intervalIntegrable_S _ _) (hsplitA.1.div_const _),
      intervalIntegral.integral_div, hsplitA.2, Turing.S₁_sub]
  rw [hIf, hIg] at havg
  -- the sizes
  have hLW := LittlewoodSharp.littlewood_sharp
  have hS1 := abs_le.mp (hLW T (T + T / 4) (by linarith) (by linarith))
  have hS2 := abs_le.mp (hLW (T / 2) (T / 2 + T / 4) (by linarith) (by linarith))
  set Lg := Real.log (2 * T) with hLg
  have hlog : ∀ t, T / 4 ≤ t → t ≤ 2 * T → Real.log t ≤ Lg := fun t h1 h2 =>
    Real.log_le_log (by linarith) h2
  have hLg0 : 0 ≤ Lg := Real.log_nonneg (by linarith)
  have hlS1 := hlog (T + T / 4) (by linarith) (by linarith)
  have hlS2 := hlog (T / 2 + T / 4) (by linarith) (by linarith)
  have hU : ∀ t ∈ Icc (T / 4) (2 * T), logJ Q L t ≤ (5 / 2) * (Real.log (A + 1) + Lg) := by
    intro t ht
    have hD : StmtVDisc Q L t ((A + 1) * t) :=
      (hEdges T hT0e t ht).2.mono (by nlinarith [ht.1])
    have h1 : 1 ≤ (A + 1) * t := by nlinarith [ht.1]
    have hJ := logJ_le Q (by linarith [ht.1]) h1 hD
    rw [Real.log_mul (by linarith) (by linarith [ht.1])] at hJ
    have := hlog t ht.1 ht.2
    nlinarith
  have hLo : ∀ t ∈ Icc (T / 4) (2 * T), -(a₂ * Lg + b₂) ≤ logJ Q L t := by
    intro t ht
    have h := hLow T hT0' t ht
    have := hlog t ht.1 ht.2
    nlinarith
  have hU1 := hU T ⟨by linarith, by linarith⟩
  have hU2 := hU (T / 2 + T / 4) ⟨by linarith, by linarith⟩
  have hL1 := hLo (T + T / 4) ⟨by linarith, by linarith⟩
  have hL2 := hLo (T / 2) ⟨by linarith, by linarith⟩
  have hJsum : (logJ Q L T - logJ Q L (T + T / 4)) / Real.pi
      - (logJ Q L (T / 2) - logJ Q L (T / 2 + T / 4)) / Real.pi
      ≤ (5 * (Real.log (A + 1) + Lg) + 2 * (a₂ * Lg + b₂)) / Real.pi := by
    rw [← sub_div]
    exact div_le_div_of_nonneg_right (by linarith) hπ.le
  have hSsum : (Turing.S₁ (T + T / 4) - Turing.S₁ T) - (Turing.S₁ (T / 2 + T / 4) - Turing.S₁ (T / 2))
      ≤ 2 * (aL * Lg + bL) := by
    nlinarith [hS1.2, hS2.1, mul_le_mul_of_nonneg_left hlS1 haL0,
      mul_le_mul_of_nonneg_left hlS2 haL0]
  have hnum : (Turing.S₁ (T + T / 4) - Turing.S₁ T + (logJ Q L T - logJ Q L (T + T / 4)) / Real.pi)
      - (Turing.S₁ (T / 2 + T / 4) - Turing.S₁ (T / 2)
        + (logJ Q L (T / 2) - logJ Q L (T / 2 + T / 4)) / Real.pi)
      ≤ (2 * aL + (5 + 2 * a₂) / Real.pi) * Lg
        + (2 * bL + (5 * Real.log (A + 1) + 2 * b₂) / Real.pi) := by
    have e : (5 * (Real.log (A + 1) + Lg) + 2 * (a₂ * Lg + b₂)) / Real.pi
        = (5 + 2 * a₂) / Real.pi * Lg + (5 * Real.log (A + 1) + 2 * b₂) / Real.pi := by ring
    linarith
  have hdiv := div_le_div_of_nonneg_right hnum (by linarith : (0 : ℝ) ≤ T / 4)
  have e2 : ((2 * aL + (5 + 2 * a₂) / Real.pi) * Lg
        + (2 * bL + (5 * Real.log (A + 1) + 2 * b₂) / Real.pi)) / (T / 4)
      = 4 * ((2 * aL + (5 + 2 * a₂) / Real.pi) * Lg
        + (2 * bL + (5 * Real.log (A + 1) + 2 * b₂) / Real.pi)) / T := by
    field_simp
  linarith

/-- **The step.** Under the hypothesis and the lower side, `D T = D(3T/4)` for all large `T`. -/
theorem defect_step {Q : ℝ[X]}
    (hQ : ∀ x : ℝ, Q.derivative.eval x = Q.derivative.eval (1 - x))
    (hQh : Q.eval (1/2) ≠ 0) (hQ0 : Q.eval 0 = 1) {T₀ a₂ b₂ T₀' : ℝ}
    (hNR : StmtNoRightZeros Q T₀) (hLow : StmtVHorizLower Q a₂ b₂ T₀') (ha₂ : 0 ≤ a₂) :
    ∃ T₂ : ℝ, 0 < T₂ ∧ ∀ T : ℝ, T₂ ≤ T → Defect.defect T = Defect.defect (3 * T / 4) := by
  obtain ⟨A, T₁, hA, hT₁, havg⟩ := increment_avg hQ hQh hQ0 hNR hLow ha₂
  set α : ℝ := 2 * ((3 / 2 + 113 / 4) / Real.pi) + (5 + 2 * a₂) / Real.pi with hα
  set β : ℝ := 2 * ((2 + (3 / 2) * Real.log 9 + 128) / Real.pi)
    + (5 * Real.log (A + 1) + 2 * b₂) / Real.pi with hβ
  set c₀ : ℝ := 1 + 2 * Real.arcsin (Real.pi ^ 2 / 6 - 1 + 1 / 100) / Real.pi with hc₀
  have hm : 0 < 2 - c₀ := by linarith [c0_lt_two]
  obtain ⟨T₃, hT₃⟩ := err_eventually α β hm
  refine ⟨max T₁ T₃, by linarith [le_max_left T₁ T₃], ?_⟩
  intro T hT
  have hT1 : T₁ ≤ T := le_trans (le_max_left _ _) hT
  have hT3 : T₃ ≤ T := le_trans (le_max_right _ _) hT
  have hTpos : 0 < T := by linarith
  have h1 := havg T hT1
  have h2 := hT₃ T hT3
  have e : 4 * (α * Real.log (2 * T) + β) / T
      = 4 * α * (Real.log T ^ 1 / (1 * T + 0)) + 4 * (α * Real.log 2 + β) / T := by
    rw [Real.log_mul (by norm_num) hTpos.ne']
    field_simp
    ring
  have hlt : ((Defect.defect T : ℝ) - (Defect.defect (3 * T / 4) : ℝ)) < 2 := by
    rw [e] at h1
    linarith
  have hmono : Defect.defect (3 * T / 4) ≤ Defect.defect T := Turing.defect_mono (by linarith)
  have hlt' : Defect.defect T - Defect.defect (3 * T / 4) < 2 := by exact_mod_cast hlt
  obtain ⟨k, hk⟩ := Defect.defect_even T
  obtain ⟨j, hj⟩ := Defect.defect_even (3 * T / 4)
  omega

/-- info: 'BasinChain.logJ_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms logJ_le

/-- info: 'BasinChain.avg_double' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms avg_double

/-- info: 'BasinChain.err_eventually' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms err_eventually

/-- info: 'BasinChain.c0_lt_two' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms c0_lt_two

/-- info: 'BasinChain.increment_avg' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms increment_avg

/-- info: 'BasinChain.defect_step' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms defect_step

end BasinChain

end
