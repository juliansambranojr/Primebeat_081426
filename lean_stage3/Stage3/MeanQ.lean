/-
MeanQ — block S13 of `lean_stage3/design/stencil.md`, B4 step 3, the mean value with a general Q.
2026-11-25.

Pins: `PINS.md` § Current, "B4 step 3, the mean value with a general Q".

The general-Q counterpart of `FloorLong.mollMean_long` and `Operator.stmtMollMeanO_holds`, for
Conrey's `V = W/Gammaℝ` (`ConreyCount.V`, `OperatorQ.W`), and its unsmoothing in the form of
`FloorLong.unsmooth_near_long`. With `L = log T`, `σ₀ = 1/2 − R/L`, `M = ⌊T^θ⌋`, Young's
mollifier `ψ`, `c = cY P M T`, `α₀ = −R/L`:

1. **The reduction** (`MeanQRed`): `V = Q(−D/L)ζ + E`, exactly
   `V = Σ_j A_j (−1/L)^j ζ^{(j)}` (Leibniz for `Λ = Gammaℝ·ζ`), and the Taylor shift
   `q_j = Σ_k b_k C(k,j)(−1/2)^{k−j}`; `|E| ≤ (K/L) Σ_j |ζ^{(j)}|/L^j` from `StmtGrRatio`.
2. **The operator** (`MeanQCauchy`): `DopQ = Q(−∂α/L) Q(−∂β/L)`, Cauchy one variable at a time
   to every order, `‖DopQ f‖ ≤ sup|f| · (Σ_k |q_k| k!/r^k)²` at radius `r/L`.
3. **The moment** (`MeanQInt`): `∂β^l ∂α^k Imom = J_{ζ^{(k)}, ζ^{(l)}}`, and
   `DopQ Imom (α₀, α₀) = ∫ w |Q(−D/L)ζ|² |ψ|²`.
4. **The mean of `Q(−D/L)ζ·ψ`** (`MeanQMean.mollMeanQ_long`): from Lemma 3,
   `= DopQ[c](α₀, α₀)·ŵ(0) + o(T)`, every `θ`, unconditional for `θ < 1/2`.
5. **The sizes** (`MeanQBound`): `c` bounded on the polydisc for every `θ > 0`, `DopQ[c]` bounded,
   `∫ w |ζ^{(j)}ψ|²/L^{2j} = O(T)`.
6. **The mean of `Vψ`** (`MeanQV.mollMeanV_long`): `= Re DopQ[c]·ŵ(0) + o(T)`, the `E` terms
   `O(T/L)` at `δ = 1/L`.
7. **The window** (here): for `a′ ∈ [T/2, T/2 + 1]`, `b′ ∈ [T − 1, T]`,
   `(1/(b′−a′)) ∫_{a′}^{b′} |V(σ₀+it) ψ(σ₀+it)|² dt ≤ Re DopQ[c](α₀, α₀) + ε`.

**The lost-factor check.** Cauchy's `1/ρ^k` at `ρ = r/L` against the operator's `(1/L)^k`:
`1/r^k`, constant, at every degree (step 2). The `E` terms: `(1 + 1/δ)·O(T/L²)` and `δ·O(T)`,
both `O(T/L)` at `δ = 1/L` (step 6). The unsmoothing excess `K(3T/L + 2)` (step 7), as in
`unsmooth_near_long`. No factor growing with `T` or with `deg Q` is lost.

  | name                    | statement                                                    | status |
  |-------------------------|--------------------------------------------------------------|--------|
  | `MeanQRed.E_bound`      | `StmtGrRatio d` ⊢ `‖V − VQ‖ ≤ (K/L) Σ_j ‖ζ^{(j)}‖/L^j`         | PROVED |
  | `MeanQCauchy.DopQ_norm_le` | `‖DopQ f‖ ≤ S·(Σ_k |q_k| k!/r^k)²`                         | PROVED |
  | `MeanQInt.DopQ_Imom`    | `DopQ Imom (α₀, α₀) = mollMeanQ`                              | PROVED |
  | `MeanQMean.mollMeanQ_long` | Lemma 3 ⊢ `StmtMollMeanQ Q P θ R`                           | PROVED |
  | `MeanQMean.mollMeanQ_lt_half` | `StmtMollMeanQ Q P θ R`, `0 < θ < 1/2`                  | PROVED |
  | `MeanQV.mollMeanV_long` | Lemma 3, `StmtGrRatio d` ⊢ `StmtMollMeanV Q P θ R`            | PROVED |
  | `unsmooth_V`            | `StmtMollMeanV` ⊢ the window bound                            | PROVED |
  | `window_V_long`         | Lemma 3, `StmtGrRatio d` ⊢ the window bound                   | PROVED |
  | `window_V_lt_half`      | `P(0) = 0`, `0 < θ < 1/2`, `StmtGrRatio d` ⊢ the window bound | PROVED |
  | `MeanQRed.StmtGrRatio`  | `(−1/L)^i Gammaℝ^{(i)}/Gammaℝ = (−1/2)^i + O(1/L)` on the window | OPEN (digamma worker) |

What stays open: `StmtGrRatio` (the digamma bounds, `Stage3/DigammaBound*.lean`); for
`θ ≥ 1/2`, Lemma 3 itself (`FloorLong.StmtLongErr`); the closed form of `Re DopQ[c]` for
general `Q` (Young's (1.3)), step 4 of the B4 round.

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.MeanQV

noncomputable section

namespace MeanQ

open Complex Polynomial MeasureTheory Metric Filter Topology ApproxFE TwistedMoment Operator
  DiagMainStmt DiagonalO OffDiagClose Unsmooth

/-- `|V ψ|² = |V|² |ψ|²`. -/
theorem norm_Vpsi_sq (Q : ℝ[X]) (L' : ℝ) (M : ℕ) (a : ℕ → ℂ) (σ₀ t : ℝ) :
    ‖ConreyCount.V Q L' ((σ₀ : ℂ) + t * I) * psi M a ((σ₀ : ℂ) + t * I)‖ ^ 2 =
      ‖ConreyCount.V Q L' ((σ₀ : ℂ) + t * I)‖ ^ 2 * msq M a σ₀ t := by
  unfold msq
  rw [norm_mul, mul_pow]

/-- **The sharp one-sided mean of `Vψ` from the mollified mean**, every length:
`FloorLong.unsmooth_near_long` with `G` replaced by `V` and `Dop` by `DopQ`. -/
theorem unsmooth_V (Q P : ℝ[X]) {θ R : ℝ} (hθ0 : 0 < θ) (hR : 0 < R)
    (hMV : StmtMollMeanV Q P θ R) :
    ∀ ε : ℝ, 0 < ε → ∃ T₀ : ℝ, ∀ T : ℝ, T₀ ≤ T → ∀ a' b' : ℝ,
      T / 2 ≤ a' → a' ≤ T / 2 + 1 → T - 1 ≤ b' → b' ≤ T →
      (1 / (b' - a')) * ∫ t in a'..b',
          ‖ConreyCount.V Q (Real.log T) ((sig0 T R : ℂ) + t * I) *
            psi (Mof T θ) (aY P T θ R) ((sig0 T R : ℂ) + t * I)‖ ^ 2 ≤
        (DopQ Q (Real.log T) (cY P (Mof T θ) T) ((-(R / Real.log T) : ℝ) : ℂ)
          ((-(R / Real.log T) : ℝ) : ℂ)).re + ε := by
  intro ε hε
  obtain ⟨K, hK0, TK, hK⟩ := dopQ_cY_bdd Q P hθ0 hR
  set C : ℝ := 1 + winC 1 + winC 2 with hCdef
  have hC : 0 < C := by
    have := winC_nonneg 1
    have := winC_nonneg 2
    positivity
  set ε₁ : ℝ := ε / (8 * C) with hε₁def
  have hε₁ : 0 < ε₁ := by positivity
  have hε₁C : ε₁ * C = ε / 8 := by rw [hε₁def]; field_simp
  obtain ⟨T1, hT1⟩ := hMV winC ε₁ hε₁
  refine ⟨max (max T1 TK) (max (max 16 (32 * K / ε))
    (Real.exp (max (max 8 (48 * K / ε)) (4 * R)))),
    fun T hT a' b' ha1 ha2 hb1 hb2 => ?_⟩
  simp only [max_le_iff] at hT
  obtain ⟨⟨hTa, hTb⟩, ⟨hT16, hTK⟩, hTe⟩ := hT
  have hT0 : 0 < T := by linarith
  have hLge : max (max 8 (48 * K / ε)) (4 * R) ≤ Real.log T :=
    (Real.le_log_iff_exp_le hT0).mpr hTe
  have hL8 : 8 ≤ Real.log T := le_trans (le_trans (le_max_left _ _) (le_max_left _ _)) hLge
  have hLK : 48 * K / ε ≤ Real.log T :=
    le_trans (le_trans (le_max_right _ _) (le_max_left _ _)) hLge
  have hL4R : 4 * R ≤ Real.log T := le_trans (le_max_right _ _) hLge
  have hL0 : 0 < Real.log T := by linarith
  have hΔ : 0 < T / Real.log T := div_pos hT0 hL0
  set W : WeightAll T (Real.log T) := winNear T (Real.log T) hT0 hL8 with hWdef
  have hW := hT1 T hTa W (fun j => le_rfl)
  set D : ℂ := DopQ Q (Real.log T) (cY P (Mof T θ) T) ((-(R / Real.log T) : ℝ) : ℂ)
      ((-(R / Real.log T) : ℝ) : ℂ) with hDdef
  have hDK : |D.re| ≤ K := (Complex.abs_re_le_norm D).trans (hK T hTb)
  set mm := mollMeanV W.toWeight (Mof T θ) (aY P T θ R) (sig0 T R) Q (Real.log T) with hmm
  set ŵ := what0 W.toWeight with hŵ
  have herr : errO W.toWeight = C * T := rfl
  have hre : mm ≤ D.re * ŵ + ε₁ * (C * T) := by
    have h1 := (le_abs_self _).trans hW
    rw [← herr]
    linarith
  -- the window on `[a', b']`
  have hab : a' ≤ b' := by linarith
  have hone : ∀ t ∈ Set.Icc a' b', W.w t = 1 := by
    intro t ht
    show winNY T (Real.log T) t = 1
    exact winNY_one hΔ (by linarith [ht.1]) (by linarith [ht.2])
  set f : ℝ → ℝ := fun t => ‖ConreyCount.V Q (Real.log T) ((sig0 T R : ℂ) + t * I)‖ ^ 2 *
      msq (Mof T θ) (aY P T θ R) (sig0 T R) t with hfdef
  have hσ0 : 0 < sig0 T R := by
    unfold sig0
    have : R / Real.log T ≤ 1 / 4 := by rw [div_le_iff₀ hL0]; linarith
    linarith
  have hσ1 : sig0 T R < 1 := by
    unfold sig0
    have : 0 < R / Real.log T := by positivity
    linarith
  have hfc : Continuous f :=
    ((continuous_V_line Q (Real.log T) hσ0 hσ1).norm.pow 2).mul (continuous_msq _ _ _)
  have hf0 : ∀ t, 0 ≤ f t := fun t => mul_nonneg (by positivity) (msq_nonneg _ _ _ _)
  have hint : ∫ t in a'..b', ‖ConreyCount.V Q (Real.log T) ((sig0 T R : ℂ) + t * I) *
      psi (Mof T θ) (aY P T θ R) ((sig0 T R : ℂ) + t * I)‖ ^ 2 = ∫ t in a'..b', f t := by
    congr 1
    funext t
    exact norm_Vpsi_sq _ _ _ _ _ _
  have hsharp : ∫ t in a'..b', f t ≤ mm := by
    rw [hmm]
    exact integral_le_of_one W.toWeight hfc hf0 hab hone
  -- `d ≤ ŵ(0) ≤ d + 3T/L + 2`
  set d := b' - a' with hd
  have hdT : T / 4 ≤ d := by linarith
  have hd0 : 0 < d := by linarith
  have hŵlo : d ≤ ŵ := by
    have h := integral_le_of_one W.toWeight (f := fun _ => (1 : ℝ)) continuous_const
      (fun _ => zero_le_one) hab hone
    rw [intervalIntegral.integral_const, smul_eq_mul, mul_one] at h
    simp only [mul_one] at h
    exact h
  have hŵhi : ŵ ≤ d + (3 * (T / Real.log T) + 2) := by
    have hlh : nearLo T (Real.log T) ≤ nearHi T (Real.log T) := by
      unfold nearLo nearHi; linarith
    have h := what0_le_of_zero W.toWeight hlh (fun t ht => by
      show winNY T (Real.log T) t = 0
      exact winNY_zero hΔ fun h' => ht ⟨h'.1.le, h'.2.le⟩)
    unfold nearLo nearHi at h
    linarith
  -- the excess
  have hexc : D.re * ŵ ≤ D.re * d + K * (3 * (T / Real.log T) + 2) := by
    have h1 : D.re * (ŵ - d) ≤ K * (ŵ - d) :=
      mul_le_mul_of_nonneg_right ((le_abs_self _).trans hDK) (by linarith)
    have h2 : K * (ŵ - d) ≤ K * (3 * (T / Real.log T) + 2) :=
      mul_le_mul_of_nonneg_left (by linarith) hK0
    have e : D.re * ŵ = D.re * d + D.re * (ŵ - d) := by ring
    linarith
  -- the sizes
  have hs1 : K * (3 * (T / Real.log T)) ≤ ε * T / 16 := by
    have h48 : 48 * K ≤ ε * Real.log T := by
      rw [div_le_iff₀ hε] at hLK
      linarith
    have e : K * (3 * (T / Real.log T)) = (48 * K) * T / (16 * Real.log T) := by
      field_simp
      try ring
    rw [e, div_le_iff₀ (by positivity)]
    have e2 : ε * T / 16 * (16 * Real.log T) = (ε * Real.log T) * T := by ring
    rw [e2]
    exact mul_le_mul_of_nonneg_right h48 hT0.le
  have hs2 : K * 2 ≤ ε * T / 16 := by
    rw [div_le_iff₀ hε] at hTK
    linarith
  have hs3 : ε₁ * (C * T) = ε * T / 8 := by
    rw [← mul_assoc, hε₁C]
    ring
  have hfin : ∫ t in a'..b', f t ≤ D.re * d + ε * d := by
    have h1 : ε * T / 4 ≤ ε * d := by
      have := mul_le_mul_of_nonneg_left hdT hε.le
      linarith
    linarith
  rw [hint, one_div_mul_eq_div, div_le_iff₀ hd0]
  linarith

/-- **The window bound for Conrey's `V`, every length**, from Lemma 3 at `κ = 2R + 1 + 1/R` and
the `Gammaℝ` ratio. -/
theorem window_V_long (Q P : ℝ[X]) {θ R : ℝ} (hθ0 : 0 < θ) (hR : 0 < R)
    (hL3 : StmtLemma3resO P θ R (2 * R + 1 + 1 / R)) (hG : StmtGrRatio Q.natDegree) :
    ∀ ε : ℝ, 0 < ε → ∃ T₀ : ℝ, ∀ T : ℝ, T₀ ≤ T → ∀ a' b' : ℝ,
      T / 2 ≤ a' → a' ≤ T / 2 + 1 → T - 1 ≤ b' → b' ≤ T →
      (1 / (b' - a')) * ∫ t in a'..b',
          ‖ConreyCount.V Q (Real.log T) ((sig0 T R : ℂ) + t * I) *
            psi (Mof T θ) (aY P T θ R) ((sig0 T R : ℂ) + t * I)‖ ^ 2 ≤
        (DopQ Q (Real.log T) (cY P (Mof T θ) T) ((-(R / Real.log T) : ℝ) : ℂ)
          ((-(R / Real.log T) : ℝ) : ℂ)).re + ε :=
  unsmooth_V Q P hθ0 hR (mollMeanV_long Q P hθ0 hR hL3 hG)

/-- **The window bound for Conrey's `V`, `θ < 1/2`**: unconditional but for the `Gammaℝ` ratio. -/
theorem window_V_lt_half (Q P : ℝ[X]) (hP0 : P.eval 0 = 0) {θ R : ℝ} (hθ0 : 0 < θ)
    (hθ : θ < 1 / 2) (hR : 0 < R) (hG : StmtGrRatio Q.natDegree) :
    ∀ ε : ℝ, 0 < ε → ∃ T₀ : ℝ, ∀ T : ℝ, T₀ ≤ T → ∀ a' b' : ℝ,
      T / 2 ≤ a' → a' ≤ T / 2 + 1 → T - 1 ≤ b' → b' ≤ T →
      (1 / (b' - a')) * ∫ t in a'..b',
          ‖ConreyCount.V Q (Real.log T) ((sig0 T R : ℂ) + t * I) *
            psi (Mof T θ) (aY P T θ R) ((sig0 T R : ℂ) + t * I)‖ ^ 2 ≤
        (DopQ Q (Real.log T) (cY P (Mof T θ) T) ((-(R / Real.log T) : ℝ) : ℂ)
          ((-(R / Real.log T) : ℝ) : ℂ)).re + ε :=
  window_V_long Q P hθ0 hR (Lemma3.lemma3_resO_holds P hP0 hθ0 hθ R (by positivity)) hG

/-- info: 'MeanQ.unsmooth_V' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms unsmooth_V

/-- info: 'MeanQ.window_V_long' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms window_V_long

/-- info: 'MeanQ.window_V_lt_half' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms window_V_lt_half

end MeanQ

end
