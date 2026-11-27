/-
TuringCert — block S14 of `lean_stage3/design/stencil.md`, Turing's method, step 3: the
certificate, signs of `Z` at finitely many points ⊢ the defect is `0` up to a height. 2026-11-25.

**On paper.** Hardy's function is taken as in `HardyZ`: `t ↦ Λ(1/2 + it)`, real, with the signs
of `Z`. The data are two runs of points with strict sign changes between neighbours
(`StmtSignData`): `t₀ < … < t_k ≤ T₁` below the height and `T₁ < s₀ < … < s_m ≤ T₁ + h` above it.

1. Below: `k` sign changes give `k ≤ lineCount T₁` (`LineCount.signChanges_le_line_count`).
2. The step to just above `T₁`: there is `T' ∈ (T₁, s₀)` as close to `T₁` as wanted with no zero
   at heights in `(T₁, T']`, so `N T' = allCount T₁` (`Defect.exists_right`,
   `Defect.N_eq_allCount_right`), and `θ T'` is as close to `θ T₁` as wanted (`θ` continuous).
3. Above: the sign change on `(s_j, s_{j+1})` gives a zero `γ_j` on the line there; for
   `u > s_{j+1}` it lies in `(T₁, u)`, and distinct `j` give distinct zeros. So
   `c(u) = #{j : s_{j+1} < u} ≤ N u − allCount T₁ = N u − N T'` (`count_le_N_sub`), and
   `∫_{T'}^{T'+h} c = Σ_j (T' + h − s_{j+1}) ≥ Σ_j (T₁ + h − s_{j+1})` (`integral_step`).
4. Turing's lemma (`TuringAvg.S_le_of_count`) at `T'` with this `c`, the slope
   `K = (log((T₁ + 1 + h)/2) − log π + 97/T₁)/2` (`theta_sub_le`) and Littlewood's bound
   `StmtLittlewood a b t₀` gives `S T' ≤ E`, with

     `E = (a log(T₁ + 1 + h) + b − Σ_j (T₁ + h − s_{j+1}))/h + h K/(2π)`   (`turingErr`).

5. So `allCount T₁ = N T' = S T' + θ T'/π + 1 < θ T₁/π + 1 + E + η`, and the hypothesis
   `θ T₁/π + 1 + E < k + 2` makes `allCount T₁ ≤ k + 1`. The defect `allCount T₁ − lineCount T₁`
   is then at most `1`; it is even (`Defect.defect_even`) and nonnegative, so it is `0`; and it
   is monotone in the height (`defect_mono`), so it is `0` at every `T ≤ T₁`.

The parity is what makes a bound of size `< 2` enough: an off-line zero comes with its mirror.

**What is open.** `StmtSignData` for given points is a finite computation: a rigorous evaluation
of `Λ(1/2 + it)` (interval arithmetic on Riemann–Siegel or Euler–Maclaurin, with error bounds)
at each point. That evaluation is out of scope here; the Prop is stated and nothing proves it.
`StmtLittlewood` is step 1's goal, open (`TuringS`). With both, `defect_zero_of_signs` is a
theorem.

**Sizes.** With Gram points for the `s_j` (`θ(s_j) = (n + 1 + j)π` above `T₁ = g_n`), the bracket
`h K/(2π) − (1/h) Σ_j (T₁ + h − s_{j+1})` is about `3/2` for every `h` (the horizon's growth
against the zeros counted), and the Littlewood term is `B/h`, so `E < 2` once `h` is a few times
`B`; on paper, not computed here.

| name | content | status |
|---|---|---|
| `StmtSignData k t` | `t` strictly increasing, `0 < t 0`, strict sign changes of `Λ(1/2 + it)` | def (a computation; open) |
| `turingK`, `turingErr` | the slope and the error `E` | def |
| `defect_mono` | `T ≤ T' ⊢ defect T ≤ defect T'` | proved |
| `defect_eq_zero_of_lt_two` | `defect T < 2 ⊢ defect T = 0` | proved |
| `defect_zero_below` | `defect T₁ = 0 ⊢ ∀ T ≤ T₁, defect T = 0` | proved |
| `allCount_add_card_le_N` | zeros in `(T₁, u)` ⊢ `allCount T₁ + #Z ≤ N u` | proved |
| `count_le_N_sub` | sign data above `T₁` ⊢ `c u ≤ N u − allCount T₁` | proved |
| `integral_step` | `a ≤ s ≤ b ⊢ ∫_a^b [s < u] du = b − s` | proved |
| `defect_zero_of_signs` | sign data below and above, `StmtLittlewood`, `θ T₁/π + 1 + E < k + 2` ⊢ `∀ T ≤ T₁, defect T = 0` | proved |

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Stage3.TuringAvg

namespace Turing

open Complex MeasureTheory Kadiri LineCount Defect
open scoped Classical

noncomputable section

/-- **The certificate's data**: strict sign changes of `t ↦ Λ(1/2 + it)` (Hardy's `Z` up to a
positive factor, `HardyZ`) between consecutive points of a strictly increasing run in `(0, ∞)`.
A finite computation; its rigorous evaluation is not in this tree. -/
def StmtSignData (k : ℕ) (t : Fin (k + 1) → ℝ) : Prop :=
  StrictMono t ∧ 0 < t 0 ∧ ∀ i : Fin k,
    (completedRiemannZeta (1/2 + t i.castSucc * I)).re *
      (completedRiemannZeta (1/2 + t i.succ * I)).re < 0

/-- The slope of the horizon on `[T₁, T₁ + 1 + h]`. -/
def turingK (T₁ h : ℝ) : ℝ := (Real.log ((T₁ + 1 + h) / 2) - Real.log Real.pi + 97 / T₁) / 2

/-- Turing's error at `T₁`, window `h`, Littlewood constants `a, b`, sign points `s` above. -/
def turingErr (a b h T₁ : ℝ) {m : ℕ} (s : Fin (m + 1) → ℝ) : ℝ :=
  (a * Real.log (T₁ + 1 + h) + b - ∑ j : Fin m, (T₁ + h - s j.succ)) / h
    + h * turingK T₁ h / (2 * Real.pi)

end

theorem defect_mono {T T' : ℝ} (h : T ≤ T') : defect T ≤ defect T' := by
  rw [defect_eq_offCount, defect_eq_offCount]
  unfold offCount
  apply Finset.sum_le_sum_of_subset_of_nonneg
  · intro ρ hρ
    rw [Finset.mem_filter, mem_zerosUpTo] at hρ ⊢
    exact ⟨⟨hρ.1.1, hρ.1.2.trans h⟩, hρ.2⟩
  · intro ρ _ _
    exact (riemannZeta_order_pos_nontrivialZero ρ).le

theorem defect_eq_zero_of_lt_two {T : ℝ} (h : defect T < 2) : defect T = 0 := by
  obtain ⟨r, hr⟩ := defect_even T
  have := defect_nonneg T
  omega

theorem defect_zero_below {T₁ : ℝ} (h : defect T₁ = 0) : ∀ T ≤ T₁, defect T = 0 := by
  intro T hT
  have h1 := defect_mono hT
  have h2 := defect_nonneg T
  omega

/-- Zeros strictly between `T₁` and `u` add to the closed count at `T₁`, below `N u`. -/
theorem allCount_add_card_le_N {T₁ u : ℝ} (hT₁ : 0 ≤ T₁) (hu : T₁ < u)
    (Z : Finset NontrivialZeros) (hZ : ∀ ρ ∈ Z, T₁ < (ρ : ℂ).im ∧ (ρ : ℂ).im < u) :
    (allCount T₁ : ℝ) + Z.card ≤ riemannZeta.N u := by
  rw [N_eq_sum_lt, allCount_cast]
  have hdisj : Disjoint (zerosUpTo T₁) Z := by
    rw [Finset.disjoint_left]
    intro ρ h1 h2
    have := (mem_zerosUpTo.mp h1).2
    linarith [(hZ ρ h2).1]
  have hsub : zerosUpTo T₁ ∪ Z ⊆
      (zerosUpTo u).filter (fun ρ : NontrivialZeros => (ρ : ℂ).im < u) := by
    intro ρ hρ
    rw [Finset.mem_filter, mem_zerosUpTo]
    rcases Finset.mem_union.mp hρ with h | h
    · have := mem_zerosUpTo.mp h
      exact ⟨⟨this.1, by linarith [this.2]⟩, by linarith [this.2]⟩
    · have := hZ ρ h
      exact ⟨⟨by linarith [this.1], this.2.le⟩, this.2⟩
  have hnn : ∀ ρ : NontrivialZeros, (0 : ℝ) ≤ ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) :=
    fun ρ => by exact_mod_cast (riemannZeta_order_pos_nontrivialZero ρ).le
  have h1 := Finset.sum_le_sum_of_subset_of_nonneg hsub (fun ρ _ _ => hnn ρ)
  rw [Finset.sum_union hdisj] at h1
  have h2 : (Z.card : ℝ) ≤ ∑ ρ ∈ Z, ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) := by
    have : (Z.card : ℝ) = ∑ _ρ ∈ Z, (1 : ℝ) := by simp
    rw [this]
    exact Finset.sum_le_sum (fun ρ _ => by exact_mod_cast riemannZeta_one_le_order_nontrivialZero ρ)
  linarith

/-- **The count above `T₁`.** Sign changes on `(s_j, s_{j+1})` above `T₁` give
`#{j : s_{j+1} < u} ≤ N u − allCount T₁`. -/
theorem count_le_N_sub {m : ℕ} {s : Fin (m + 1) → ℝ} {T₁ u : ℝ} (hT₁ : 0 ≤ T₁)
    (hs : StmtSignData m s) (hsT : T₁ < s 0) (hu : T₁ < u) :
    (∑ j : Fin m, if s j.succ < u then (1 : ℝ) else 0)
      ≤ riemannZeta.N u - (allCount T₁ : ℝ) := by
  obtain ⟨hmono, _, hsg⟩ := hs
  have hex : ∀ i : Fin m, ∃ γ ∈ Set.Ioo (s i.castSucc) (s i.succ),
      riemannZeta (1/2 + γ * I) = 0 := fun i =>
    strictSignChange_zero_on_line (hmono (Fin.castSucc_lt_succ (i := i))) (hsg i)
  choose γ hγ hζ using hex
  have hre : ∀ i : Fin m, ((1/2 : ℂ) + (γ i : ℂ) * I).re = 1 / 2 := fun i =>
    HardyZ.re_line (γ i)
  have him : ∀ i : Fin m, ((1/2 : ℂ) + (γ i : ℂ) * I).im = γ i := fun i => by simp
  have hmemZ : ∀ i : Fin m, ((1/2 : ℂ) + (γ i : ℂ) * I) ∈ NontrivialZeros := fun i => by
    refine ⟨?_, Set.mem_univ _, hζ i⟩
    rw [hre i]
    norm_num
  let ρ : Fin m → NontrivialZeros := fun i => ⟨(1/2 : ℂ) + (γ i : ℂ) * I, hmemZ i⟩
  have hγmono : StrictMono γ := by
    intro i j hij
    have hle : i.succ ≤ j.castSucc := by
      rw [Fin.le_iff_val_le_val]
      simp only [Fin.val_succ, Fin.val_castSucc]
      exact hij
    calc γ i < s i.succ := (hγ i).2
      _ ≤ s j.castSucc := hmono.monotone hle
      _ < γ j := (hγ j).1
  have hinj : Function.Injective ρ := by
    intro i j hij
    have := congrArg (fun z : NontrivialZeros => (z : ℂ).im) hij
    simp only [ρ, him] at this
    exact hγmono.injective this
  set A := Finset.univ.filter (fun j : Fin m => s j.succ < u) with hA
  have hZ : ∀ z ∈ A.image ρ, T₁ < (z : ℂ).im ∧ (z : ℂ).im < u := by
    intro z hz
    rw [Finset.mem_image] at hz
    obtain ⟨i, hi, rfl⟩ := hz
    rw [hA, Finset.mem_filter] at hi
    simp only [ρ, him]
    refine ⟨?_, ?_⟩
    · calc T₁ < s 0 := hsT
        _ ≤ s i.castSucc := hmono.monotone (Fin.zero_le _)
        _ < γ i := (hγ i).1
    · exact (hγ i).2.trans hi.2
  have hc := allCount_add_card_le_N hT₁ hu (A.image ρ) hZ
  rw [Finset.card_image_of_injective _ hinj] at hc
  rw [Finset.sum_boole]
  linarith

/-- The step function `[s < u]` integrates to `b − s` over `[a, b] ∋ s`. -/
theorem integral_step {a b s : ℝ} (has : a ≤ s) (hsb : s ≤ b) :
    (∫ u in a..b, if s < u then (1 : ℝ) else 0) = b - s := by
  have hmono : Monotone (fun u : ℝ => if s < u then (1 : ℝ) else 0) := by
    intro x y hxy
    dsimp only
    split_ifs with h1 h2 h2
    · exact le_refl _
    · exact absurd (lt_of_lt_of_le h1 hxy) h2
    · norm_num
    · exact le_refl _
  rw [← intervalIntegral.integral_add_adjacent_intervals
    (hmono.intervalIntegrable (μ := volume) (a := a) (b := s))
    (hmono.intervalIntegrable (μ := volume) (a := s) (b := b))]
  have h1 : (∫ u in a..s, if s < u then (1 : ℝ) else 0) = 0 := by
    rw [intervalIntegral.integral_congr (g := fun _ => (0 : ℝ)) ?_]
    · simp
    · intro x hx
      rw [Set.uIcc_of_le has] at hx
      simp [not_lt.mpr hx.2]
  have h2 : (∫ u in s..b, if s < u then (1 : ℝ) else 0) = b - s := by
    rw [intervalIntegral.integral_congr_ae (g := fun _ => (1 : ℝ)) ?_]
    · simp
    · refine Filter.Eventually.of_forall (fun x hx => ?_)
      rw [Set.uIoc_of_le hsb] at hx
      simp [hx.1]
  rw [h1, h2]
  ring

/-- **Turing's method, the analytic half.** Strict sign changes of `Z` at `k + 1` points up to
`T₁` and at `m + 1` points in `(T₁, T₁ + h]`, with Littlewood's bound on `S₁`, give the defect
`0` at every height up to `T₁`, once `θ T₁/π + 1 + E < k + 2`. -/
theorem defect_zero_of_signs {k m : ℕ} {t : Fin (k + 1) → ℝ} {s : Fin (m + 1) → ℝ}
    {T₁ a b t₀ h : ℝ}
    (hbelow : StmtSignData k t) (htT : t (Fin.last k) ≤ T₁)
    (habove : StmtSignData m s) (hsT : T₁ < s 0) (hsh : s (Fin.last m) ≤ T₁ + h)
    (hL : StmtLittlewood a b t₀) (ha : 0 ≤ a) (ht₀ : t₀ ≤ T₁) (h1 : 1 ≤ T₁) (hh : 0 < h)
    (hnum : Stage3.phaseTheta T₁ / Real.pi + 1 + turingErr a b h T₁ s < k + 2) :
    ∀ T ≤ T₁, defect T = 0 := by
  have hπ : 0 < Real.pi := Real.pi_pos
  have hk : (k : ℤ) ≤ lineCount T₁ :=
    signChanges_le_line_count t hbelow.1 hbelow.2.1 htT hbelow.2.2
  set E := turingErr a b h T₁ s with hE
  set η := (k : ℝ) + 2 - (Stage3.phaseTheta T₁ / Real.pi + 1 + E) with hη
  have hη0 : 0 < η := by rw [hη]; linarith
  obtain ⟨T'', hT'', hno⟩ := exists_right T₁
  obtain ⟨δ, hδ, hδθ⟩ := Metric.continuous_iff.mp continuous_phaseTheta T₁ (Real.pi * η)
    (mul_pos hπ hη0)
  obtain ⟨d, hd0, hdδ, hdT, hds, hd1⟩ : ∃ d : ℝ, 0 < d ∧ d < δ ∧ T₁ + d < T'' ∧
      T₁ + d < s 0 ∧ d < 1 := by
    set D := min (min δ (T'' - T₁)) (min (s 0 - T₁) 1) with hD
    have hD0 : 0 < D := lt_min (lt_min hδ (by linarith)) (lt_min (by linarith) one_pos)
    have e1 : D ≤ δ := (min_le_left _ _).trans (min_le_left _ _)
    have e2 : D ≤ T'' - T₁ := (min_le_left _ _).trans (min_le_right _ _)
    have e3 : D ≤ s 0 - T₁ := (min_le_right _ _).trans (min_le_left _ _)
    have e4 : D ≤ 1 := (min_le_right _ _).trans (min_le_right _ _)
    exact ⟨D / 2, by linarith, by linarith, by linarith, by linarith, by linarith⟩
  set T' := T₁ + d with hT'
  have hT1T' : T₁ < T' := by linarith
  have hno' : ∀ z : ℂ, riemannZeta z = 0 → 0 < z.im → T₁ < z.im → T' < z.im :=
    fun z h0 hp hT => lt_trans hdT (hno z h0 hp hT)
  have hNT' := (N_eq_allCount_right hT1T' hno').1
  have hθT' : Stage3.phaseTheta T' < Stage3.phaseTheta T₁ + Real.pi * η := by
    have hdist : dist T' T₁ < δ := by
      rw [Real.dist_eq, abs_of_pos (by linarith)]; linarith
    have := hδθ T' hdist
    rw [Real.dist_eq] at this
    linarith [le_abs_self (Stage3.phaseTheta T' - Stage3.phaseTheta T₁)]
  -- Turing's lemma at `T'`
  set K := turingK T₁ h with hK_def
  set c : ℝ → ℝ := fun u => ∑ j : Fin m, if s j.succ < u then (1 : ℝ) else 0 with hc_def
  have hK : ∀ u ∈ Set.Icc T' (T' + h),
      Stage3.phaseTheta u - Stage3.phaseTheta T' ≤ (u - T') * K := by
    intro u hu
    have h1' := theta_sub_le (by linarith : (1 : ℝ) ≤ T') hu.1
    have hl : Real.log (u / 2) ≤ Real.log ((T₁ + 1 + h) / 2) :=
      Real.log_le_log (by linarith [hu.1]) (by linarith [hu.2])
    have hd97 : 97 / T' ≤ 97 / T₁ := div_le_div_of_nonneg_left (by norm_num) (by linarith) hT1T'.le
    have hut : 0 ≤ u - T' := by linarith [hu.1]
    have : (u - T') * ((Real.log (u / 2) - Real.log Real.pi + 97 / T') / 2) ≤ (u - T') * K :=
      mul_le_mul_of_nonneg_left (by rw [hK_def, turingK]; linarith) hut
    linarith
  have hcmono : Monotone c := by
    intro x y hxy
    refine Finset.sum_le_sum (fun j _ => ?_)
    split_ifs with h1' h2'
    · exact le_refl _
    · exact absurd (lt_of_lt_of_le h1' hxy) h2'
    · norm_num
    · exact le_refl _
  have hci : IntervalIntegrable c volume T' (T' + h) := hcmono.intervalIntegrable
  have hcN : ∀ u ∈ Set.Icc T' (T' + h), c u ≤ riemannZeta.N u - riemannZeta.N T' := by
    intro u hu
    rw [hNT']
    exact count_le_N_sub (by linarith) habove hsT (by linarith [hu.1])
  have hS := S_le_of_count hh hK hci hcN
  -- the integral of the count
  have hsj : ∀ j : Fin m, T' ≤ s j.succ ∧ s j.succ ≤ T' + h := by
    intro j
    refine ⟨?_, ?_⟩
    · have := habove.1.monotone (Fin.zero_le j.succ)
      linarith
    · have := habove.1.monotone (Fin.le_last j.succ)
      linarith
  have hint : (∫ u in T'..T' + h, c u) = ∑ j : Fin m, (T' + h - s j.succ) := by
    rw [hc_def, intervalIntegral.integral_finsetSum]
    · exact Finset.sum_congr rfl (fun j _ => integral_step (hsj j).1 (hsj j).2)
    · intro j _
      apply Monotone.intervalIntegrable
      intro x y hxy
      dsimp only
      split_ifs with h1' h2'
      · exact le_refl _
      · exact absurd (lt_of_lt_of_le h1' hxy) h2'
      · norm_num
      · exact le_refl _
  have hsum : ∑ j : Fin m, (T₁ + h - s j.succ) ≤ ∑ j : Fin m, (T' + h - s j.succ) :=
    Finset.sum_le_sum (fun j _ => by linarith)
  have hL' := (abs_le.mp (hL T' (T' + h) (by linarith) (by linarith))).2
  have hlog : Real.log (T' + h) ≤ Real.log (T₁ + 1 + h) :=
    Real.log_le_log (by linarith) (by linarith)
  have hlogA : a * Real.log (T' + h) ≤ a * Real.log (T₁ + 1 + h) :=
    mul_le_mul_of_nonneg_left hlog ha
  have hSE : S T' ≤ E := by
    rw [hint] at hS
    have h2 : (S₁ (T' + h) - S₁ T' - ∑ j : Fin m, (T' + h - s j.succ)
        + K * h ^ 2 / (2 * Real.pi)) / h
        ≤ (a * Real.log (T₁ + 1 + h) + b - ∑ j : Fin m, (T₁ + h - s j.succ)
          + K * h ^ 2 / (2 * Real.pi)) / h :=
      div_le_div_of_nonneg_right (by linarith) hh.le
    have h3 : (a * Real.log (T₁ + 1 + h) + b - ∑ j : Fin m, (T₁ + h - s j.succ)
          + K * h ^ 2 / (2 * Real.pi)) / h = E := by
      rw [hE, turingErr, ← hK_def]
      field_simp
    linarith
  -- the count at `T₁`
  have hall : (allCount T₁ : ℝ) < (k : ℝ) + 2 := by
    have e1 : (allCount T₁ : ℝ) = S T' + Stage3.phaseTheta T' / Real.pi + 1 := by
      rw [← hNT']; unfold S; ring
    have e2 : Stage3.phaseTheta T' / Real.pi < Stage3.phaseTheta T₁ / Real.pi + η := by
      rw [div_lt_iff₀ hπ]
      have : (Stage3.phaseTheta T₁ / Real.pi + η) * Real.pi
          = Stage3.phaseTheta T₁ + Real.pi * η := by field_simp
      rw [this]; exact hθT'
    rw [hη] at e2
    linarith
  have hallZ : allCount T₁ < (k : ℤ) + 2 := by exact_mod_cast hall
  have hd : defect T₁ < 2 := by unfold defect; omega
  exact defect_zero_below (defect_eq_zero_of_lt_two hd)

/-- info: 'Turing.defect_mono' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms defect_mono

/-- info: 'Turing.count_le_N_sub' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms count_le_N_sub

/-- info: 'Turing.defect_zero_of_signs' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms defect_zero_of_signs

end Turing
