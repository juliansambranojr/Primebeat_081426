/-
ConreyCount — block S13 of `lean_stage3/design/stencil.md`, B4 step 1: Conrey's identity and
Levinson's count for a general `Q`. 2026-11-25.

Pins: `PINS.md` § Current, "B4 step 1". Conrey, J. Number Theory 16 (1983), §4.

For a real polynomial `Q` with `Q′(x) = Q′(1 − x)` (Conrey's `Q(x) + Q(1 − x) = K`) and
`Q(1/2) ≠ 0`, `W = OperatorQ.W Q L` and `V = W/Gammaℝ`:

1. **Conrey's identity** (`ConreyCountIdentity.conrey_identity`): `W(s) + W(1 − s) = 2Q(1/2)Λ(s)`
   for every `s`, from `Λ^{(k)}(1 − s) = (−1)^k Λ^{(k)}(s)`.
2. **The count** (`conrey_count_sub`, here): the analogue of
   `LevinsonWindowNear.levinson_count_sub` with `V` in place of `ζ + cζ′`. A continuous
   argument of `W/P·i^K` along the line (`P` the zeros of `V` on the line, divided out as in
   `LevinsonMultiple`) turns by the `Gammaℝ` part (`LevinsonSize.gamma_part_count_le_gt_two`)
   plus the argument principle for `H = V/P` on `[1/2, 3] × [a, b]` (`LevinsonTurn.G_turn_eq`),
   whose edges are those of `V` less `πK` (`LevinsonMultiple.polyP_edges`). Every crossing is a
   zero of `ζ` (`OperatorQ.zeta_line_zero_iff_W`), and every zero of `V` on the line is counted
   by `lineCount` with weight `≥ n ρ`, `≥ n ρ + 1` at a crossing
   (`ConreyCountOrder.zeta_order_ge_line`), so `K` cancels.
   The edges of `V` (`ConreyCountEdge`) take the size of `V` as hypotheses: `Re V ≥ 1/3` on the
   right edge (`StmtVRight`) and `‖V‖ ≤ M` on the discs about the two corners (`StmtVDisc`).
   Constant: `30 log b` from `Gammaℝ`, `2·(21 log(3M) + 1)` from the horizontal edges, `1` from
   the right edge, `150` and the floor's `1`: `30 log b + 42 log(3M) + 154`.
3. **The window** (`conrey_count_window`): for `[a, b] ⊆ [T/4, 2T]`, `L = log T`, and the open
   size statement `ConreyCountEdge.StmtVEdges Q T A` (`M = A·t`):
   `lineCount b − lineCount a ≥ (N b − N a) − 2·countRight V − (72 log b + 42 log(3A) + 154)`.

**Sizes.** No factor growing with `T` is lost: `V = ζ + O_Q(1/L)` on `Re s = 3` for
`t ∈ [T/4, 2T]` (computed, `ConreyCountEdge` header), and `‖V‖ = O_Q(T)` on the discs, so each
edge is `O(log T)`. The one place `T` enters through `Q` is the shift `(g − L/2)/L = O(1/L)`
inside `Q`; on a window `t ≈ T/2^j` it is `≈ j·log 2/(2L)` and is not small for `j ≍ L`, which
is why the window is asked inside `[T/4, 2T]`.

  | name                    | statement                                                    | status |
  |-------------------------|--------------------------------------------------------------|--------|
  | `conrey_identity`       | `W(s) + W(1 − s) = 2·Q(1/2)·Λ(s)`  (`ConreyCountIdentity`)    | PROVED |
  | `lineCount_ge_argW`, `lineW_turn_eq` | the crossings and the turning of `W` (`ConreyCountLine`) | PROVED |
  | `zeta_order_ge_line`    | the order of `ζ` at a zero of `V` on the line (`ConreyCountOrder`) | PROVED |
  | `V_right_edge_le`, `V_horizontal_edge_le` | the edges from the size of `V` (`ConreyCountEdge`) | PROVED |
  | `conrey_count_sub`      | the count, the size of `V` as hypotheses                      | PROVED |
  | `conrey_count_window`   | the count on `[a, b] ⊆ [T/4, 2T]` from `StmtVEdges Q T A`     | PROVED |
  | `StmtVRight`, `StmtVDisc`, `StmtVEdges` | the size of `V` (`ConreyCountEdge`)        | OPEN   |

Avoidance hypotheses stay hypotheses, as in `levinson_count_sub`: `V ≠ 0` on the bottom and top
edges and `ζ(1/2 + a i) ≠ 0`. The left edge needs none; the right edge none beyond `StmtVRight`.

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.ConreyCountOrder
import Stage3.ConreyCountEdge

noncomputable section

namespace ConreyCount

open Complex Polynomial MeasureTheory Set Filter Topology Littlewood LineCount Kadiri
  LevinsonWindow LevinsonMultiple
open scoped Interval

set_option maxHeartbeats 800000 in
/-- **Levinson's count for `V = W/Gammaℝ`, difference form.** For `Q′(x) = Q′(1 − x)`,
`Q(1/2) ≠ 0`, `4 ≤ a < b`, `V` nonzero on the bottom and top edges of `[1/2, 3] × [a, b]`,
`ζ(1/2 + a i) ≠ 0`, `Re V ≥ 1/3` on the right edge and `‖V‖ ≤ M` on the discs about `3 + a i`
and `3 + b i`: the zeros of `ζ` on the line with height in `(a, b]`, with order, number at least
`(N b − N a) − 2·(zeros of V in the rectangle right of the line) − (30 log b + 42 log(3M) + 154)`. -/
theorem conrey_count_sub {Q : ℝ[X]}
    (hQ : ∀ x : ℝ, Q.derivative.eval x = Q.derivative.eval (1 - x))
    (hQh : Q.eval (1/2) ≠ 0) {L a b M : ℝ} (ha : 4 ≤ a) (hab : a < b)
    (hBot : ∀ x ∈ Icc (1/2 : ℝ) 3, V Q L (↑x + ↑a * I) ≠ 0)
    (hTop : ∀ x ∈ Icc (1/2 : ℝ) 3, V Q L (↑x + ↑b * I) ≠ 0)
    (hζa : riemannZeta (1/2 + a * I) ≠ 0)
    (hR : StmtVRight Q L a b) (hMa : StmtVDisc Q L a M) (hMb : StmtVDisc Q L b M) :
    (riemannZeta.N b - riemannZeta.N a)
      - 2 * Littlewood.countRight (V Q L) ((1/2 : ℂ) + a * I) ((3 : ℂ) + b * I) (1/2)
      - (30 * Real.log b + 42 * Real.log (3 * M) + 154)
        ≤ (lineCount b : ℝ) - (lineCount a : ℝ) := by
  classical
  set G : ℂ → ℂ := V Q L with hG_def
  have hπ : 0 < Real.pi := Real.pi_pos
  -- the rectangle
  have hzre : ((1/2 : ℂ) + a * I).re = 1/2 := by simp
  have hzim : ((1/2 : ℂ) + a * I).im = a := by simp
  have hwre : ((3 : ℂ) + b * I).re = 3 := by simp
  have hwim : ((3 : ℂ) + b * I).im = b := by simp
  have hmemR : ∀ p, p ∈ Rectangle ((1/2 : ℂ) + a * I) ((3 : ℂ) + b * I) ↔
      1/2 ≤ p.re ∧ p.re ≤ 3 ∧ a ≤ p.im ∧ p.im ≤ b := by
    intro p
    rw [mem_Rect (by rw [hzre, hwre]; norm_num) (by rw [hzim, hwim]; exact hab.le), hzre, hzim,
      hwre, hwim]
  have hGa : AnalyticOnNhd ℂ G (Rectangle ((1/2 : ℂ) + a * I) ((3 : ℂ) + b * I)) := by
    intro p hp
    have h := (hmemR p).mp hp
    exact analyticAt_V_upper Q L (by linarith [h.2.2.1])
  have hlineR : ∀ t ∈ Icc a b, ((1/2 : ℂ) + t * I) ∈ Rectangle ((1/2 : ℂ) + a * I) ((3 : ℂ) + b * I) :=
    fun t ht => (hmemR _).mpr ⟨by rw [HardyZ.re_line], by rw [HardyZ.re_line]; norm_num,
      by simpa using ht.1, by simpa using ht.2⟩
  have hGz : G ((1/2 : ℂ) + a * I) ≠ 0 := by
    have h := hBot (1/2) ⟨le_rfl, by norm_num⟩
    push_cast at h
    exact h
  have hfinM := Littlewood.order_ne_top hGa hGz
  have hfin : ∀ p ∈ Rectangle ((1/2 : ℂ) + a * I) ((3 : ℂ) + b * I),
      analyticOrderAt G p ≠ ⊤ := by
    intro p hp htop
    apply hfinM p hp
    rw [(hGa p hp).meromorphicOrderAt_eq, htop]
    rfl
  -- the zeros of `V` on the left edge
  set D : Finset ℂ := (divisor_support_rectangle_finite G ((1/2 : ℂ) + a * I)
    ((3 : ℂ) + b * I)).toFinset.filter (fun p => p.re = 1/2) with hD_def
  have hmemD : ∀ p, p ∈ D ↔
      p ∈ Rectangle ((1/2 : ℂ) + a * I) ((3 : ℂ) + b * I) ∧ G p = 0 ∧ p.re = 1/2 := by
    intro p
    rw [hD_def, Finset.mem_filter, Set.Finite.mem_toFinset,
      Littlewood.mem_support_divisor subset_rfl hGa hfinM, and_assoc]
  have hDprop : ∀ ρ ∈ D, ρ.re = 1/2 ∧ a < ρ.im ∧ ρ.im < b := by
    intro ρ hρ
    obtain ⟨hR', h0, hre⟩ := (hmemD ρ).mp hρ
    obtain ⟨-, -, h3, h4⟩ := (hmemR ρ).mp hR'
    have hρeq : ρ = ↑ρ.re + ↑ρ.im * I := (Complex.re_add_im ρ).symm
    refine ⟨hre, lt_of_le_of_ne h3 ?_, lt_of_le_of_ne h4 ?_⟩
    · intro he
      apply hBot ρ.re ⟨by linarith, by linarith⟩
      rw [he, ← hρeq]
      exact h0
    · intro he
      apply hTop ρ.re ⟨by linarith, by linarith⟩
      rw [← he, ← hρeq]
      exact h0
  have hρeq : ∀ ρ ∈ D, ρ = (1/2 : ℂ) + ↑ρ.im * I := by
    intro ρ hρ
    apply Complex.ext <;> simp [(hDprop ρ hρ).1]
  have hζD : ∀ ρ ∈ D, riemannZeta ρ = 0 := by
    intro ρ hρ
    obtain ⟨-, h0, -⟩ := (hmemD ρ).mp hρ
    have hG0 : Gammaℝ ((1/2 : ℂ) + ↑ρ.im * I) ≠ 0 :=
      Gammaℝ_ne_zero_of_re_pos (LevinsonLine.line_facts ρ.im).2.2
    have h := (OperatorQ.zeta_line_zero_iff_W Q hQ hQh L ρ.im).mpr (by
        rw [W_eq_gammaR_mul_V Q L hG0, ← hρeq ρ hρ]
        show (Gammaℝ ρ * G ρ).re = 0
        rw [h0, mul_zero, Complex.zero_re])
    rwa [← hρeq ρ hρ] at h
  -- divide them out
  set n : ℂ → ℕ := fun p => (analyticOrderAt G p).toNat with hn_def
  have hn : ∀ ρ ∈ D, (n ρ : ℕ∞) = analyticOrderAt G ρ := fun ρ hρ =>
    ENat.coe_toNat (hfin ρ ((hmemD ρ).mp hρ).1)
  obtain ⟨H, hHa, hGPH⟩ := exists_prod_mul (S := Rectangle ((1/2 : ℂ) + a * I) ((3 : ℂ) + b * I))
    n D G (fun ρ hρ => ((hmemD ρ).mp hρ).1) (fun p hp => hGa p hp) (fun ρ hρ => (hn ρ hρ).le)
  have hHne_of_G : ∀ p, G p ≠ 0 → H p ≠ 0 := fun p hp h => hp (by rw [hGPH p, h, mul_zero])
  have hHneD : ∀ ρ ∈ D, H ρ ≠ 0 := by
    intro ρ hρ
    have hR' := ((hmemD ρ).mp hρ).1
    have e : G = polyP D n * H := funext fun s => hGPH s
    have hord : analyticOrderAt G ρ = n ρ + analyticOrderAt H ρ := by
      rw [e, analyticOrderAt_mul (polyP_analyticAt D n ρ) (hHa ρ hR'), polyP_order n hρ]
    rw [← hn ρ hρ] at hord
    have h0 : analyticOrderAt H ρ = 0 := by
      cases h : analyticOrderAt H ρ with
      | top => rw [h] at hord; simp at hord
      | coe m =>
        rw [h] at hord
        have h1 : n ρ = n ρ + m := by exact_mod_cast hord
        have hm : m = 0 := by omega
        rw [hm]
        rfl
    exact (hHa ρ hR').analyticOrderAt_eq_zero.mp h0
  have hHline : ∀ t ∈ Icc a b, H (1/2 + t * I) ≠ 0 := by
    intro t ht
    by_cases hG0 : G (1/2 + t * I) = 0
    · apply hHneD
      rw [hmemD]
      exact ⟨hlineR t ht, hG0, HardyZ.re_line t⟩
    · exact hHne_of_G _ hG0
  have hGright : ∀ t ∈ Icc a b, G (3 + t * I) ≠ 0 := by
    intro t ht h
    have := hR t ht
    have h' : V Q L (3 + t * I) = 0 := h
    rw [h', Complex.zero_re] at this
    linarith
  have hHB : ∀ p ∈ RectangleBorder ((1/2 : ℂ) + a * I) ((3 : ℂ) + b * I), H p ≠ 0 := by
    intro p hp
    have hcases := LevinsonWindow.border_cases (by rw [hzre, hwre]; norm_num)
      (by rw [hzim, hwim]; exact hab.le) hp
    rw [hzre, hzim, hwre, hwim] at hcases
    have hp' : p = ↑p.re + ↑p.im * I := (Complex.re_add_im p).symm
    rcases hcases with ⟨him, hre⟩ | ⟨hre, him⟩ | ⟨him, hre⟩ | ⟨hre, him⟩
    · apply hHne_of_G
      rw [hp', him]
      exact hBot p.re hre
    · rw [hp', hre]
      push_cast
      exact hHline p.im him
    · apply hHne_of_G
      rw [hp', him]
      exact hTop p.re hre
    · apply hHne_of_G
      rw [hp', hre]
      push_cast
      exact hGright p.im him
  -- the argument principle for `H`
  have hcast : ((3 : ℝ) : ℂ) = (3 : ℂ) := by norm_num
  have hHa3 : AnalyticOnNhd ℂ H (Rectangle ((1/2 : ℂ) + a * I) (((3 : ℝ) : ℂ) + b * I)) := by
    rw [hcast]; exact hHa
  have hHB3 : ∀ p ∈ RectangleBorder ((1/2 : ℂ) + a * I) (((3 : ℝ) : ℂ) + b * I), H p ≠ 0 := by
    rw [hcast]; exact hHB
  have hHturn := LevinsonTurn.G_turn_eq (G := H) (X := 3) (by norm_num) hab hHa3 hHB3
  rw [hcast] at hHturn
  have hHz : H ((1/2 : ℂ) + a * I) ≠ 0 := hHne_of_G _ hGz
  have hC : Littlewood.countRight G ((1/2 : ℂ) + a * I) ((3 : ℂ) + b * I) (1/2)
      = Littlewood.countRight H ((1/2 : ℂ) + a * I) ((3 : ℂ) + b * I) (1/2) :=
    countRight_eq_of_mul hGa hHa (fun p => polyP_analyticAt D n p)
      (fun p _ hσ => polyP_ne_zero n (fun hpD => by
        have := (hDprop p hpD).1
        linarith))
      (funext fun s => hGPH s) hGz hHz
  -- the edges: `V = P · H`
  have e : G = fun s => polyP D n s * H s := funext hGPH
  have hbotS : (∫ x in (1/2:ℝ)..3, logDeriv G (↑x + ↑a * I))
      = (∫ x in (1/2:ℝ)..3, logDeriv (polyP D n) (↑x + ↑a * I))
        + ∫ x in (1/2:ℝ)..3, logDeriv H (↑x + ↑a * I) := by
    rw [e]
    exact integral_logDeriv_mul (by norm_num) (by fun_prop)
      (fun x _ => polyP_analyticAt D n _)
      (fun x hx => hHa _ ((hmemR _).mpr ⟨by simpa using hx.1, by simpa using hx.2, by simp,
        by simpa using hab.le⟩))
      (fun x _ => polyP_ne_zero n (fun hD => by have := (hDprop _ hD).2.1; simp at this))
      (fun x hx => hHne_of_G _ (hBot x hx))
  have htopS : (∫ x in (1/2:ℝ)..3, logDeriv G (↑x + ↑b * I))
      = (∫ x in (1/2:ℝ)..3, logDeriv (polyP D n) (↑x + ↑b * I))
        + ∫ x in (1/2:ℝ)..3, logDeriv H (↑x + ↑b * I) := by
    rw [e]
    exact integral_logDeriv_mul (by norm_num) (by fun_prop)
      (fun x _ => polyP_analyticAt D n _)
      (fun x hx => hHa _ ((hmemR _).mpr ⟨by simpa using hx.1, by simpa using hx.2,
        by simpa using hab.le, by simp⟩))
      (fun x _ => polyP_ne_zero n (fun hD => by have := (hDprop _ hD).2.2; simp at this))
      (fun x hx => hHne_of_G _ (hTop x hx))
  have hrtS : (∫ t in a..b, logDeriv G (3 + ↑t * I))
      = (∫ t in a..b, logDeriv (polyP D n) (3 + ↑t * I))
        + ∫ t in a..b, logDeriv H (3 + ↑t * I) := by
    rw [e]
    exact integral_logDeriv_mul hab.le (by fun_prop)
      (fun t _ => polyP_analyticAt D n _)
      (fun t ht => hHa _ ((hmemR _).mpr ⟨by simp; norm_num, by simp, by simpa using ht.1,
        by simpa using ht.2⟩))
      (fun t _ => polyP_ne_zero n (fun hD => by
        have := (hDprop _ hD).1
        simp at this
        norm_num at this))
      (fun t ht => hHne_of_G _ (hGright t ht))
  have hbot' := congrArg Complex.im hbotS
  have htop' := congrArg Complex.im htopS
  have hrt' := congrArg Complex.re hrtS
  rw [Complex.add_im] at hbot' htop'
  rw [Complex.add_re] at hrt'
  have hPE := polyP_edges hab.le n hDprop
  -- the line
  have hFa : ∀ t ∈ Icc a b, AnalyticAt ℂ
      (fun s => I ^ (∑ ρ ∈ D, n ρ) * (Gammaℝ s * H s)) (1/2 + t * I) := fun t ht =>
    analyticAt_const.mul ((LevinsonTurn.analyticAt_Gammaℝ (LevinsonLine.line_facts t).2.2).mul
      (hHa _ (hlineR t ht)))
  have hFne : ∀ t ∈ Icc a b,
      (fun s => I ^ (∑ ρ ∈ D, n ρ) * (Gammaℝ s * H s)) (1/2 + t * I) ≠ 0 := fun t ht =>
    mul_ne_zero (pow_ne_zero _ Complex.I_ne_zero)
      (mul_ne_zero (Gammaℝ_ne_zero_of_re_pos (LevinsonLine.line_facts t).2.2) (hHline t ht))
  have hFc : ContinuousOn (fun t : ℝ => I ^ (∑ ρ ∈ D, n ρ) *
      (Gammaℝ (1/2 + t * I) * H (1/2 + t * I))) (Icc a b) := fun t ht =>
    (ContinuousAt.comp (g := fun s => I ^ (∑ ρ ∈ D, n ρ) * (Gammaℝ s * H s))
      (f := fun t : ℝ => (1/2 + t * I : ℂ)) (hFa t ht).continuousAt
      LevinsonTurn.continuous_line.continuousAt).continuousWithinAt
  obtain ⟨φ, hφc, hφ⟩ := LevinsonArg.exists_arg_lift hab.le hFc hFne
  have hturn1 := LevinsonTurn.line_turn_eq_integral
    (f := fun s => I ^ (∑ ρ ∈ D, n ρ) * (Gammaℝ s * H s)) hab.le hFa hFne hφc hφ
  have hld : (∫ t in a..b, logDeriv (fun s => I ^ (∑ ρ ∈ D, n ρ) * (Gammaℝ s * H s))
      (1/2 + t * I)) = ∫ t in a..b, logDeriv (fun s => Gammaℝ s * H s) (1/2 + t * I) :=
    intervalIntegral.integral_congr fun t _ =>
      logDeriv_const_mul _ _ (pow_ne_zero _ Complex.I_ne_zero)
  have hsplit := LevinsonTurn.turn_split (G := H) hab.le (fun t ht => hHa _ (hlineR t ht)) hHline
  rw [hld, hsplit] at hturn1
  -- the sizes
  have hRe := abs_le.mp (V_right_edge_le ha hab.le hR)
  have hHa' := abs_le.mp (V_horizontal_edge_le ha (hR a ⟨le_rfl, hab.le⟩) hMa hBot)
  have hHb' := abs_le.mp (V_horizontal_edge_le (by linarith) (hR b ⟨hab.le, le_rfl⟩) hMb hTop)
  have hΓ := abs_le.mp (LevinsonSize.gamma_part_count_le_gt_two (by linarith) hab.le)
  -- the turning is at least `π (Qc − K)`
  set C := Littlewood.countRight G ((1/2 : ℂ) + a * I) ((3 : ℂ) + b * I) (1/2) with hC_def
  set Kr : ℝ := ∑ ρ ∈ D, (n ρ : ℝ) with hKr
  set Qc := (riemannZeta.N b - riemannZeta.N a) - 2 * C
    - (30 * Real.log b + 42 * Real.log (3 * M) + 153) with hQc
  have hdiff : Real.pi * (Qc - Kr) ≤ φ b - φ a := by
    have e1 : Real.pi * (Qc - Kr) = Real.pi * (riemannZeta.N b - riemannZeta.N a)
        - 2 * Real.pi * C - (Real.pi * (30 * Real.log b + 150))
        - 2 * (Real.pi * (21 * Real.log (3 * M) + 1)) - Real.pi - Real.pi * Kr := by
      rw [hQc]; ring
    rw [e1]
    rw [← hC] at hHturn
    linarith [hRe.1, hHa'.2, hHb'.1, hΓ.1, hturn1, hHturn, hbot', htop', hrt', hPE]
  -- the floor
  set k : ℕ := ⌊max 0 (Qc - Kr)⌋₊ with hk_def
  have hkle : (k : ℝ) ≤ max 0 (Qc - Kr) := Nat.floor_le (le_max_left _ _)
  have hklt : max 0 (Qc - Kr) < (k : ℝ) + 1 := Nat.lt_floor_add_one _
  have hmax : max 0 (Qc - Kr) * Real.pi ≤ |φ b - φ a| := by
    rcases le_total (Qc - Kr) 0 with h | h
    · rw [max_eq_left h, zero_mul]; exact abs_nonneg _
    · rw [max_eq_right h]
      linarith [le_abs_self (φ b - φ a)]
  have hk : (k : ℝ) * Real.pi ≤ |φ b - φ a| :=
    le_trans (mul_le_mul_of_nonneg_right hkle hπ.le) hmax
  obtain ⟨t, hmono, hmem, hcos⟩ := LevinsonArg.crossings_of_arg hab.le hφc k hk
  -- the real part of the line function vanishes at every crossing
  have hreFt : ∀ i, (I ^ (∑ ρ ∈ D, n ρ) * (Gammaℝ (1/2 + t i * I) * H (1/2 + t i * I))).re = 0 := by
    intro i
    rw [hφ _ (hmem i), Complex.re_ofReal_mul, Complex.exp_ofReal_mul_I_re, hcos i, mul_zero]
  -- every crossing is a zero of `ζ`
  have hζt : ∀ i, riemannZeta (1/2 + t i * I) = 0 := by
    intro i
    apply (OperatorQ.zeta_line_zero_iff_W Q hQ hQh L (t i)).mpr
    have hid := line_identity hQ (fun ρ hρ => (hDprop ρ hρ).1) hGPH (L := L) (t i)
    rw [hreFt i, mul_zero, Complex.ofReal_zero] at hid
    rw [OperatorQ.re_W_line Q hQ L]
    have hz : completedRiemannZeta (1/2 + ↑(t i) * I) = 0 := by
      have hh : ((Q.eval (1/2 : ℝ) : ℝ) : ℂ) ≠ 0 := by
        rw [Ne, Complex.ofReal_eq_zero]; exact hQh
      exact (mul_eq_zero.mp hid).resolve_left hh
    rw [hz, Complex.zero_re, mul_zero]
  -- the count: crossings once, the zeros of `D` with weight `n ρ`, one more at a crossing
  set Γs : Finset ℝ := D.image (fun ρ => ρ.im) with hΓs
  set Cr : Finset ℝ := Finset.univ.image t with hCr
  set E : Finset ℝ := Cr ∪ Γs with hE
  have hmemCr : ∀ γ ∈ Cr, ∃ i, t i = γ := by
    intro γ hγ
    rw [hCr, Finset.mem_image] at hγ
    obtain ⟨i, -, hi⟩ := hγ
    exact ⟨i, hi⟩
  have hmemΓ : ∀ γ ∈ Γs, ∃ ρ ∈ D, ρ.im = γ := by
    intro γ hγ
    rw [hΓs, Finset.mem_image] at hγ
    exact hγ
  have hmemE : ∀ γ ∈ E, γ ∈ Cr ∨ γ ∈ Γs := fun γ hγ => Finset.mem_union.mp hγ
  have hEζ : ∀ γ ∈ E, riemannZeta (1/2 + γ * I) = 0 := by
    intro γ hγ
    rcases hmemE γ hγ with hc | hd
    · obtain ⟨i, rfl⟩ := hmemCr γ hc
      exact hζt i
    · obtain ⟨ρ, hρ, rfl⟩ := hmemΓ γ hd
      rw [← hρeq ρ hρ]; exact hζD ρ hρ
  have hEgt : ∀ γ ∈ E, a < γ := by
    intro γ hγ
    rcases hmemE γ hγ with hc | hd
    · obtain ⟨i, rfl⟩ := hmemCr γ hc
      refine lt_of_le_of_ne (hmem i).1 fun he => hζa ?_
      rw [he]
      exact hζt i
    · obtain ⟨ρ, hρ, rfl⟩ := hmemΓ γ hd
      exact (hDprop ρ hρ).2.1
  have hET : ∀ γ ∈ E, γ ≤ b := by
    intro γ hγ
    rcases hmemE γ hγ with hc | hd
    · obtain ⟨i, rfl⟩ := hmemCr γ hc
      exact (hmem i).2
    · obtain ⟨ρ, hρ, rfl⟩ := hmemΓ γ hd
      exact (hDprop ρ hρ).2.2.le
  have hsum := LevinsonWindowNear.sum_order_le_lineCount_sub (by linarith) hab.le E hEgt hET hEζ
  have hord : ∀ γ ∈ E, (if γ ∈ Cr then (1 : ℤ) else 0)
      + (if γ ∈ Γs then (n (1/2 + γ * I) : ℤ) else 0)
      ≤ riemannZeta.order (1/2 + γ * I) := by
    intro γ hγ
    have hmemZ : ((1/2 : ℂ) + (γ : ℂ) * I) ∈ NontrivialZeros := by
      refine ⟨?_, Set.mem_univ _, hEζ γ hγ⟩
      rw [HardyZ.re_line]
      norm_num
    have hone : (1 : ℤ) ≤ riemannZeta.order (1/2 + γ * I) := by
      have := riemannZeta_one_le_order_nontrivialZero ⟨_, hmemZ⟩
      simpa using this
    by_cases hγΓ : γ ∈ Γs
    · obtain ⟨ρ, hρ, rfl⟩ := hmemΓ _ hγΓ
      have hR' := ((hmemD ρ).mp hρ).1
      have hge := zeta_order_ge_line hQ hQh (fun ρ' hρ' => (hDprop ρ' hρ').1) hGPH hρ (hHa ρ hR')
      rw [if_pos hγΓ, ← hρeq ρ hρ]
      by_cases hγC : ρ.im ∈ Cr
      · rw [if_pos hγC]
        obtain ⟨i, hi⟩ := hmemCr _ hγC
        have hF0 : (I ^ (∑ ρ' ∈ D, n ρ') * (Gammaℝ ρ * H ρ)).re = 0 := by
          have h := hreFt i
          rw [hi, ← hρeq ρ hρ] at h
          exact h
        linarith [hge.2 hF0]
      · rw [if_neg hγC]
        linarith [hge.1]
    · rw [if_neg hγΓ, add_zero]
      split_ifs
      · exact hone
      · linarith
  have hsumge : ((Cr.card : ℤ) + ∑ ρ ∈ D, (n ρ : ℤ))
      ≤ ∑ γ ∈ E, riemannZeta.order (1/2 + γ * I) := by
    have h1 := Finset.sum_le_sum hord
    rw [Finset.sum_add_distrib, Finset.sum_ite_mem, Finset.sum_ite_mem,
      Finset.inter_eq_right.mpr Finset.subset_union_left,
      Finset.inter_eq_right.mpr Finset.subset_union_right, Finset.sum_const, nsmul_eq_mul,
      mul_one] at h1
    have h2 : ∑ γ ∈ Γs, (n (1/2 + γ * I) : ℤ) = ∑ ρ ∈ D, (n ρ : ℤ) := by
      rw [hΓs, Finset.sum_image]
      · exact Finset.sum_congr rfl fun ρ hρ => by rw [← hρeq ρ hρ]
      · intro ρ₁ h₁ ρ₂ h₂ he
        rw [hρeq ρ₁ h₁, hρeq ρ₂ h₂]
        simp only at he
        rw [he]
    rw [h2] at h1
    exact h1
  have hcardCr : Cr.card = k := by
    rw [hCr, Finset.card_image_of_injective _ hmono.injective, Finset.card_univ,
      Fintype.card_fin]
  have hfinal : ((k : ℤ) + ∑ ρ ∈ D, (n ρ : ℤ)) ≤ lineCount b - lineCount a := by
    rw [← hcardCr]
    linarith
  have hfinalR : (k : ℝ) + Kr ≤ (lineCount b : ℝ) - (lineCount a : ℝ) := by
    rw [hKr]
    exact_mod_cast hfinal
  have hQmax : Qc - Kr ≤ max 0 (Qc - Kr) := le_max_right _ _
  have e2 : (riemannZeta.N b - riemannZeta.N a) - 2 * C
      - (30 * Real.log b + 42 * Real.log (3 * M) + 154) = Qc - 1 := by
    rw [hQc]; ring
  rw [e2]
  linarith

/-- A disc bound with a larger constant. -/
theorem StmtVDisc.mono {Q : ℝ[X]} {L T M M' : ℝ} (h : StmtVDisc Q L T M) (hM : M ≤ M') :
    StmtVDisc Q L T M' := fun w hw => le_trans (h w hw) hM

/-- **The count on a window inside `[T/4, 2T]`.** With `L = log T`, `T/4 ≤ a`, `4 ≤ a < b ≤ 2T`,
`0 < A`, the open size statement `StmtVEdges Q T A`, and the avoidance hypotheses:
`lineCount b − lineCount a ≥ (N b − N a) − 2·countRight V − (72 log b + 42 log(3A) + 154)`. -/
theorem conrey_count_window {Q : ℝ[X]}
    (hQ : ∀ x : ℝ, Q.derivative.eval x = Q.derivative.eval (1 - x))
    (hQh : Q.eval (1/2) ≠ 0) {T A a b : ℝ} (hA : 0 < A)
    (hTa : T / 4 ≤ a) (ha : 4 ≤ a) (hab : a < b) (hbT : b ≤ 2 * T)
    (hE : StmtVEdges Q T A)
    (hBot : ∀ x ∈ Icc (1/2 : ℝ) 3, V Q (Real.log T) (↑x + ↑a * I) ≠ 0)
    (hTop : ∀ x ∈ Icc (1/2 : ℝ) 3, V Q (Real.log T) (↑x + ↑b * I) ≠ 0)
    (hζa : riemannZeta (1/2 + a * I) ≠ 0) :
    (riemannZeta.N b - riemannZeta.N a)
      - 2 * Littlewood.countRight (V Q (Real.log T)) ((1/2 : ℂ) + a * I) ((3 : ℂ) + b * I) (1/2)
      - (72 * Real.log b + 42 * Real.log (3 * A) + 154)
        ≤ (lineCount b : ℝ) - (lineCount a : ℝ) := by
  have hmemT : ∀ s ∈ Icc a b, s ∈ Icc (T / 4) (2 * T) := fun s hs =>
    ⟨le_trans hTa hs.1, le_trans hs.2 hbT⟩
  have hR : StmtVRight Q (Real.log T) a b := fun s hs => (hE s (hmemT s hs)).1
  have hMa : StmtVDisc Q (Real.log T) a (A * b) :=
    (hE a (hmemT a ⟨le_rfl, hab.le⟩)).2.mono (mul_le_mul_of_nonneg_left hab.le hA.le)
  have hMb : StmtVDisc Q (Real.log T) b (A * b) := (hE b (hmemT b ⟨hab.le, le_rfl⟩)).2
  have h := conrey_count_sub hQ hQh ha hab hBot hTop hζa hR hMa hMb
  have hb0 : 0 < b := by linarith
  have hlog : Real.log (3 * (A * b)) = Real.log (3 * A) + Real.log b := by
    rw [← mul_assoc, Real.log_mul (by positivity) hb0.ne']
  rw [hlog] at h
  linarith

/-- info: 'ConreyCount.conrey_count_sub' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms conrey_count_sub

/-- info: 'ConreyCount.conrey_count_window' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms conrey_count_window

end ConreyCount

end
