/-
# OffDiagClose — block S12 of `lean_stage3/design/stencil.md`, the window and the off-diagonal. 2026-11-25.

Young's Lemma 5, its `hm ≠ kn` part (arXiv 1002.4403, §2 (2.1)–(2.3), §4 Lemma 5's proof, §5),
closed for every `θ < 1/2` with a number of integrations by parts chosen from `θ`; the decision
is unit 0535. Notation as in `TwistedMoment`, `ApproxDerivAll`: `Δ = T/L`, `N = 1 + ‖α+β‖^(−2)`,
`V = VY α β c x t`, `e_λ(t) = eL λ t = e^(−iλt)`, `offSum`, `Jint`, `coefY`, Young's `aY`, `Mof`,
`sig0`, `Regime`, `errY W = (1 + C₁ + C₂) T/L`.

The route. (1) `WeightAll` is `Weight` with (2.3) for every `j`. The window
`w(t) = φ((t − T/4)/Δ) φ((2T − t)/Δ)`, `φ = Real.smoothTransition`, has `|φ^(i)| ≤ B_i` (`φ'` has
compact support, so every `φ^(i)`, `i ≥ 1`, is continuous with compact support), and Leibniz with
the chain rule for `t ↦ φ(c(t − a))`, `t ↦ φ(c(b − t))` gives `|w^(j)| ≤ C_j Δ^(−j)`,
`C_j = Σ_{i≤j} C(j,i) B_i B_{j−i}`, independent of `T`, `L`. (2) For `F = wV`, Leibniz
(`iteratedDeriv_fun_mul`), (2.3) and Young's (4.3) for every order (`VY_iter_bound`, with
`t^(−1) ≤ 4Δ^(−1)` on the support) give `‖F^(j)‖ ≪ (1 + Σ_{i≤j} C_i) N Δ^(−j) (1 + x/(2T))^(−A)`;
`F` vanishes to every order off `[T/4, 2T]`, so `ibp_iter` on `[T/8, 4T]` gives
`‖∫ w V e_λ‖ ≪ (…) N T (Δ|λ|)^(−j) (1 + x/(2T))^(−A)`. With `j = 2r` and the gap
`λ^(−2) ≤ 4hm·kn` (`inv_log_sq_le`) `r` times, each term of `offSum` is
`≪ (…) N T Δ^(−2r) B² 4^r M^(2r) (mn)^(r−2/5) (1 + mn/(2T))^(−(r+4/5))`, for `‖a_h‖ h^(−σ₀) ≤ B`.
(3) `(1 + y)^(−a) ≤ y^(−a)` with `a = r + 4/5` trades the decay for `(2T)^(r+4/5) (mn)^(−6/5)`,
summable; the `h, k ≤ M` sum gives `M^(2r+2)`. For Young's `ψ`, `B = sup_{[0,1]} |P|`
(`h^(σ₀−1/2) h^(−σ₀) = h^(−1/2)`), `M ≤ T^θ`, `N ≤ 1 + κ²L²` on the range, and the power of `T`
is `9/5 + 2θ − r(1 − 2θ) ≤ 4/5` for `r = ⌈2/(1−2θ)⌉₊`; `(log T)^p ≪ T^(1/5)` absorbs the logs.

| statement | content | status |
|---|---|---|
| `WeightAll` | `Weight` with `|w^(j)| ≤ C_j Δ^(−j)` for every `j` | defined |
| `phi_iter_bdd`, `phiB` | `|φ^(i)| ≤ B_i` on `ℝ`, `φ = Real.smoothTransition` | proved |
| `winY`, `winC`, `winW` | the window `φ((t−T/4)/Δ) φ((2T−t)/Δ)`; `C_j = Σ C(j,i) B_i B_{j−i}`; as a `WeightAll` | defined |
| `winY_iter_le` | `|w^(j)(t)| ≤ C_j Δ^(−j)`, every `j`, `t`, `Δ > 0` | proved |
| `weightAll_exists` | target 1: `∃ C_j ≥ 0`, for all `T ≥ 8`, `L ≥ 1`, a `WeightAll T L` with these constants | proved |
| `wsum` | `1 + Σ_{i≤j} C_i` | defined |
| `VY_iter_bound0`, `VY_iter_on_supp` | (4.3) for every `j ≥ 0`; `‖∂ʳV‖ ≤ C N (4/Δ)^r (1+x/(2T))^(−A)` on the support | proved |
| `Fw_iter_zero_out`, `Fw_iter_leibniz` | `F^(k) = 0` off `[T/4, 2T]`; Leibniz for `F = wV` | proved |
| `Fw_iter_bound` | `‖F^(j)‖ ≤ K (1+Σ_{i≤j} C_i) N Δ^(−j) (1 + x/(2T))^(−A)` | proved |
| `offdiag_term_iter` | target 2: `‖∫ w V e_λ‖ ≤ K (1+Σ_{i≤j} C_i) N T Δ^(−j) |λ|^(−j) (1 + x/(2T))^(−A)` | proved |
| `offdiag_term_iter_young` | the same, `j = 2r`, in Young's variables: `(…) (4hm·kn)^r (1+mn/(2T))^(−A)` | proved |
| `decay_trade`, `summable_major6` | `y^r y^(−2/5) (1+y/(2T))^(−(r+4/5)) ≤ (2T)^(r+4/5) y^(−6/5)`; `Σ (mn)^(−6/5) < ∞` | proved |
| `off_term_iter_le`, `offSum_bound_iter` | `‖offSum‖ ≤ K (1+Σ_{i≤2r} C_i) N T Δ^(−2r) B² M^(2r+2) (2T)^(r+4/5)` | proved |
| `aY_bound` | `‖a_h‖ h^(−σ₀) ≤ B` for Young's `a_h`, `1 ≤ h ≤ M` | proved |
| `logpow_le`, `Tpow_le`, `final_size` | `(1+κ²L²) T Δ^(−2r) M^(2r+2) (2T)^(r+4/5) ≤ C T/L` for `r(1−2θ) ≥ 2` | proved |
| `r_choice`, `N_le` | `r = ⌈2/(1−2θ)⌉₊`; `N ≤ 1 + κ²L²` on `Regime` | proved |
| `StmtOffDiagAll` | `StmtOffDiag` over `WeightAll`, constants bounded by a family `Cs` fixed before `T` | defined |
| `stmtOffDiag_holds` | target 3: `StmtOffDiagAll P θ R κ` for every `θ < 1/2`, `κ > 0` | proved |

Differences from the targets. (i) `StmtOffDiag` quantifies over `Weight`, which carries (2.3) for
`j ≤ 2` only, so `j > 2` integrations have no constants to use and the bound `C · errY W` cannot
be uniform in such weights; `StmtOffDiagAll` quantifies over `WeightAll T (log T)` whose constants
satisfy `C_j ≤ Cs j` for a family `Cs` given first (Young's `C_j` are fixed, independent of `T`),
and the constant `C` depends on `Cs`. Its right side is the same `C · errY W.toWeight`; the proof
gives `C · T/L`, which is `≤ C · errY`. `weightAll_exists` gives such a family with windows for
every `T ≥ 8`, `L ≥ 1`. (ii) `stmtOffDiag_holds` assumes `κ > 0` (`Regime.small` needs it; for
`κ ≤ 0` the range forces `α = β = 0`). (iii) `j = 2r` is even, so that `|λ|^(−2r) = (λ^(−2))^r`
uses `inv_log_sq_le` without square roots; `r = ⌈2/(1−2θ)⌉₊`, i.e. `j ≈ 4/(1−2θ)`, more than the
`(1+2θ)/(1−2θ)` of unit 0535, because the bounds are crude: `‖a_h‖ h^(−σ₀) ≤ B` drops `h^(−1/2)`,
`h k ≤ M²` replaces `√(hk)`, `m^(−1/2−Re α) ≤ m^(−2/5)` uses `‖α‖ ≤ 1/10`, and the decay is traded
at `(mn)^(−6/5)`. (iv) The window's constants enter as `1 + Σ_{i≤j} C_i` (`wsum`), the shape of
`1 + C₁ + C₂` extended; the `L`-powers (`Δ^(−2r) = L^(2r) T^(−2r)`, `N ≤ (1+κ²) L²`) are absorbed
by `T^(1/5)`. (v) The window's derivative constants are existential, `B_i` from compactness
(`Classical.choose`), not explicit.

Axioms: [propext, Classical.choice, Quot.sound], pinned below on each main theorem.
-/
import Stage3.ApproxDerivAll

namespace OffDiagClose

open Complex MeasureTheory Filter Topology ApproxFE ApproxBounds ApproxDeriv TwistedMoment
  ApproxDerivAll
open scoped ContDiff

/-! ## Part 1: the window, with its derivatives to every order -/

/-- Young's admissible weight (2.1)–(2.3) with (2.3) for every `j`:
`|w^(j)(t)| ≤ C_j (T/L)^(−j)`. -/
structure WeightAll (T L : ℝ) extends Weight T L where
  /-- the constants of (2.3), every `j` -/
  Cj : ℕ → ℝ
  Cj_nonneg : ∀ j, 0 ≤ Cj j
  dj : ∀ j t, |iteratedDeriv j w t| ≤ Cj j * ((T / L) ^ j)⁻¹

/-- The smooth step `φ = Real.smoothTransition`: `0` on `(−∞, 0]`, `1` on `[1, ∞)`. -/
theorem phi_contDiff : ContDiff ℝ ∞ Real.smoothTransition :=
  Real.smoothTransition.contDiff (n := ⊤)

/-- `φ'` vanishes off `[0, 1]`. -/
theorem phi_deriv_compact : HasCompactSupport (deriv Real.smoothTransition) := by
  refine HasCompactSupport.intro (isCompact_Icc (a := (0 : ℝ)) (b := 1)) fun x hx => ?_
  rcases lt_or_ge x 0 with h | h
  · have hev : Real.smoothTransition =ᶠ[𝓝 x] fun _ => (0 : ℝ) := by
      filter_upwards [Iio_mem_nhds h] with y hy
      exact Real.smoothTransition.zero_of_nonpos (le_of_lt hy)
    rw [hev.deriv_eq, deriv_const]
  · have h1 : 1 < x := by
      by_contra h'
      exact hx ⟨h, not_lt.mp h'⟩
    have hev : Real.smoothTransition =ᶠ[𝓝 x] fun _ => (1 : ℝ) := by
      filter_upwards [Ioi_mem_nhds h1] with y hy
      exact Real.smoothTransition.one_of_one_le (le_of_lt hy)
    rw [hev.deriv_eq, deriv_const]

theorem phi_iter_compact (k : ℕ) :
    HasCompactSupport (iteratedDeriv k (deriv Real.smoothTransition)) := by
  induction k with
  | zero => simpa using phi_deriv_compact
  | succ k ih =>
    rw [iteratedDeriv_succ]
    exact ih.deriv

/-- Every derivative of `φ` is bounded on `ℝ`. -/
theorem phi_iter_bdd (i : ℕ) : ∃ B : ℝ, 0 ≤ B ∧ ∀ s, |iteratedDeriv i Real.smoothTransition s| ≤ B := by
  rcases i with _ | k
  · refine ⟨1, zero_le_one, fun s => ?_⟩
    rw [iteratedDeriv_zero, abs_of_nonneg (Real.smoothTransition.nonneg s)]
    exact Real.smoothTransition.le_one s
  · have hc : Continuous (iteratedDeriv (k + 1) Real.smoothTransition) :=
      (contDiff_infty.mp phi_contDiff (k + 1)).continuous_iteratedDeriv (k + 1) le_rfl
    have hs : HasCompactSupport (iteratedDeriv (k + 1) Real.smoothTransition) := by
      rw [iteratedDeriv_succ']
      exact phi_iter_compact k
    obtain ⟨C, hC⟩ := hc.bounded_above_of_compact_support hs
    refine ⟨max C 0, le_max_right _ _, fun s => ?_⟩
    have := hC s
    rw [Real.norm_eq_abs] at this
    exact this.trans (le_max_left _ _)

/-- The bound `B_i` on `|φ^(i)|`. -/
noncomputable
def phiB (i : ℕ) : ℝ := Classical.choose (phi_iter_bdd i)

theorem phiB_nonneg (i : ℕ) : 0 ≤ phiB i := (Classical.choose_spec (phi_iter_bdd i)).1

theorem phiB_bound (i : ℕ) (s : ℝ) : |iteratedDeriv i Real.smoothTransition s| ≤ phiB i :=
  (Classical.choose_spec (phi_iter_bdd i)).2 s

/-- The window's constants: `C_j = Σ_{i ≤ j} C(j,i) B_i B_{j−i}`. -/
noncomputable
def winC (j : ℕ) : ℝ := ∑ i ∈ Finset.range (j + 1), (j.choose i : ℝ) * phiB i * phiB (j - i)

theorem winC_nonneg (j : ℕ) : 0 ≤ winC j := by
  unfold winC
  exact Finset.sum_nonneg fun i _ => by
    have := phiB_nonneg i
    have := phiB_nonneg (j - i)
    positivity

/-- The rising edge `t ↦ φ(c (t − a))`. -/
noncomputable
def edgeUp (c a t : ℝ) : ℝ := Real.smoothTransition (c * (t - a))

/-- The falling edge `t ↦ φ(c (b − t))`. -/
noncomputable
def edgeDn (c b t : ℝ) : ℝ := Real.smoothTransition (c * (b - t))

/-- **The window** `w(t) = φ((t − T/4)/Δ) φ((2T − t)/Δ)`, `Δ = T/L`. -/
noncomputable
def winY (T L t : ℝ) : ℝ := edgeUp (T / L)⁻¹ (T / 4) t * edgeDn (T / L)⁻¹ (2 * T) t

theorem edgeUp_contDiff (c a : ℝ) : ContDiff ℝ ∞ (edgeUp c a) :=
  phi_contDiff.comp (contDiff_const.mul (contDiff_id.sub contDiff_const))

theorem edgeDn_contDiff (c b : ℝ) : ContDiff ℝ ∞ (edgeDn c b) :=
  phi_contDiff.comp (contDiff_const.mul (contDiff_const.sub contDiff_id))

theorem phi_scale_iter (c : ℝ) (i : ℕ) :
    iteratedDeriv i (fun z => Real.smoothTransition (c * z)) =
      fun z => c ^ i * iteratedDeriv i Real.smoothTransition (c * z) :=
  iteratedDeriv_comp_const_mul (contDiff_infty.mp phi_contDiff i) c

theorem edgeUp_iter (c a : ℝ) (i : ℕ) (t : ℝ) :
    iteratedDeriv i (edgeUp c a) t = c ^ i * iteratedDeriv i Real.smoothTransition (c * (t - a)) := by
  have h := congrFun (iteratedDeriv_comp_sub_const i (fun z => Real.smoothTransition (c * z)) a) t
  rw [phi_scale_iter] at h
  exact h

theorem edgeDn_iter (c b : ℝ) (i : ℕ) (t : ℝ) :
    iteratedDeriv i (edgeDn c b) t =
      (-1) ^ i * (c ^ i * iteratedDeriv i Real.smoothTransition (c * (b - t))) := by
  have h := congrFun (iteratedDeriv_comp_const_sub i (fun z => Real.smoothTransition (c * z)) b) t
  rw [phi_scale_iter, smul_eq_mul] at h
  exact h

theorem edgeUp_iter_le {c : ℝ} (hc : 0 ≤ c) (a : ℝ) (i : ℕ) (t : ℝ) :
    |iteratedDeriv i (edgeUp c a) t| ≤ phiB i * c ^ i := by
  rw [edgeUp_iter, abs_mul, abs_of_nonneg (pow_nonneg hc i), mul_comm]
  exact mul_le_mul_of_nonneg_right (phiB_bound i _) (pow_nonneg hc i)

theorem edgeDn_iter_le {c : ℝ} (hc : 0 ≤ c) (b : ℝ) (i : ℕ) (t : ℝ) :
    |iteratedDeriv i (edgeDn c b) t| ≤ phiB i * c ^ i := by
  rw [edgeDn_iter, abs_mul, abs_pow, abs_neg, abs_one, one_pow, one_mul, abs_mul,
    abs_of_nonneg (pow_nonneg hc i), mul_comm]
  exact mul_le_mul_of_nonneg_right (phiB_bound i _) (pow_nonneg hc i)

theorem winY_contDiff (T L : ℝ) : ContDiff ℝ ∞ (winY T L) :=
  (edgeUp_contDiff _ _).mul (edgeDn_contDiff _ _)

/-- (2.3) for the window, every `j`: `|w^(j)| ≤ C_j Δ^(−j)`, for `Δ = T/L > 0`. -/
theorem winY_iter_le {T L : ℝ} (hΔ : 0 < T / L) (j : ℕ) (t : ℝ) :
    |iteratedDeriv j (winY T L) t| ≤ winC j * ((T / L) ^ j)⁻¹ := by
  set c : ℝ := (T / L)⁻¹ with hcdef
  have hc : 0 ≤ c := (inv_pos.mpr hΔ).le
  have e : winY T L = fun t => edgeUp c (T / 4) t * edgeDn c (2 * T) t := rfl
  have hf : ContDiffAt ℝ j (edgeUp c (T / 4)) t :=
    (contDiff_infty.mp (edgeUp_contDiff c _) j).contDiffAt
  have hg : ContDiffAt ℝ j (edgeDn c (2 * T)) t :=
    (contDiff_infty.mp (edgeDn_contDiff c _) j).contDiffAt
  rw [e, iteratedDeriv_fun_mul hf hg]
  have hcj : ((T / L) ^ j)⁻¹ = c ^ j := by rw [hcdef, inv_pow]
  rw [hcj]
  unfold winC
  rw [Finset.sum_mul]
  refine (Finset.abs_sum_le_sum_abs _ _).trans (Finset.sum_le_sum fun i hi => ?_)
  have hij : i ≤ j := Nat.lt_succ_iff.mp (Finset.mem_range.mp hi)
  have hpow : c ^ i * c ^ (j - i) = c ^ j := by rw [← pow_add, Nat.add_sub_cancel' hij]
  rw [abs_mul, abs_mul, abs_of_nonneg (by positivity : (0 : ℝ) ≤ (j.choose i : ℝ))]
  have h1 := edgeUp_iter_le hc (T / 4) i t
  have h2 := edgeDn_iter_le hc (2 * T) (j - i) t
  have hB1 := phiB_nonneg i
  have hB2 := phiB_nonneg (j - i)
  calc (j.choose i : ℝ) * |iteratedDeriv i (edgeUp c (T / 4)) t| *
        |iteratedDeriv (j - i) (edgeDn c (2 * T)) t| ≤
      (j.choose i : ℝ) * (phiB i * c ^ i) * (phiB (j - i) * c ^ (j - i)) := by
        apply mul_le_mul _ h2 (abs_nonneg _) (by positivity)
        exact mul_le_mul_of_nonneg_left h1 (by positivity)
    _ = (j.choose i : ℝ) * phiB i * phiB (j - i) * (c ^ i * c ^ (j - i)) := by ring
    _ = (j.choose i : ℝ) * phiB i * phiB (j - i) * c ^ j := by rw [hpow]

theorem phi_pos_of_ne {x : ℝ} (h : Real.smoothTransition x ≠ 0) : 0 < x := by
  by_contra h'
  exact h (Real.smoothTransition.zero_of_nonpos (not_lt.mp h'))

theorem winY_supp {T L : ℝ} (hΔ : 0 < T / L) (t : ℝ) (h : winY T L t ≠ 0) :
    T / 4 ≤ t ∧ t ≤ 2 * T := by
  have hc : 0 < (T / L)⁻¹ := inv_pos.mpr hΔ
  unfold winY edgeUp edgeDn at h
  have h1 := phi_pos_of_ne (left_ne_zero_of_mul h)
  have h2 := phi_pos_of_ne (right_ne_zero_of_mul h)
  have a1 : 0 < t - T / 4 := pos_of_mul_pos_right h1 hc.le
  have a2 : 0 < 2 * T - t := pos_of_mul_pos_right h2 hc.le
  constructor <;> linarith

theorem winY_nonneg (T L t : ℝ) : 0 ≤ winY T L t :=
  mul_nonneg (Real.smoothTransition.nonneg _) (Real.smoothTransition.nonneg _)

theorem winY_le_one (T L t : ℝ) : winY T L t ≤ 1 :=
  mul_le_one₀ (Real.smoothTransition.le_one _) (Real.smoothTransition.nonneg _)
    (Real.smoothTransition.le_one _)

/-- The window as a `WeightAll`, for `Δ = T/L > 0`. -/
noncomputable
def winW (T L : ℝ) (hΔ : 0 < T / L) : WeightAll T L where
  w := winY T L
  smooth := winY_contDiff T L
  supp := winY_supp hΔ
  nonneg := winY_nonneg T L
  le_one := winY_le_one T L
  C1 := winC 1
  C2 := winC 2
  C1_nonneg := winC_nonneg 1
  C2_nonneg := winC_nonneg 2
  d1 t := by
    have h := winY_iter_le hΔ 1 t
    rwa [iteratedDeriv_one, pow_one] at h
  d2 t := by
    have h := winY_iter_le hΔ 2 t
    rwa [iteratedDeriv_succ, iteratedDeriv_one] at h
  Cj := winC
  Cj_nonneg := winC_nonneg
  dj := winY_iter_le hΔ

/-- **Existence of the window.** There are constants `C_j ≥ 0`, independent of `T` and `L`, such
that for every `T ≥ 8`, `L ≥ 1` there is a `WeightAll T L` with these constants (and `C₁ = C_1`,
`C₂ = C_2`), namely `w(t) = φ((t − T/4)/Δ) φ((2T − t)/Δ)`, `Δ = T/L`, `φ = smoothTransition`. -/
theorem weightAll_exists : ∃ Cs : ℕ → ℝ, (∀ j, 0 ≤ Cs j) ∧ ∀ T L : ℝ, 8 ≤ T → 1 ≤ L →
    ∃ W : WeightAll T L, W.Cj = Cs ∧ W.C1 = Cs 1 ∧ W.C2 = Cs 2 ∧
      ∀ t, W.w t = Real.smoothTransition ((t - T / 4) / (T / L)) *
        Real.smoothTransition ((2 * T - t) / (T / L)) := by
  refine ⟨winC, winC_nonneg, fun T L hT hL => ?_⟩
  have hΔ : 0 < T / L := div_pos (by linarith) (by linarith)
  refine ⟨winW T L hΔ, rfl, rfl, rfl, fun t => ?_⟩
  show winY T L t = _
  unfold winY edgeUp edgeDn
  rw [div_eq_inv_mul (t - T / 4) (T / L), div_eq_inv_mul (2 * T - t) (T / L)]

/-! ## Part 2: the off-diagonal term with `j` integrations by parts -/

/-- `1 + Σ_{i ≤ j} C_i`, the weight's constants as they enter after `j` integrations. -/
noncomputable
def wsum {T L : ℝ} (W : WeightAll T L) (j : ℕ) : ℝ := 1 + ∑ i ∈ Finset.range (j + 1), W.Cj i

theorem wsum_nonneg {T L : ℝ} (W : WeightAll T L) (j : ℕ) : 0 ≤ wsum W j := by
  unfold wsum
  have := Finset.sum_nonneg fun i (_ : i ∈ Finset.range (j + 1)) => W.Cj_nonneg i
  linarith

theorem Cj_le_wsum {T L : ℝ} (W : WeightAll T L) {i j : ℕ} (hij : i ≤ j) : W.Cj i ≤ wsum W j := by
  unfold wsum
  have := Finset.single_le_sum (fun k (_ : k ∈ Finset.range (j + 1)) => W.Cj_nonneg k)
    (Finset.mem_range.mpr (Nat.lt_succ_of_le hij))
  linarith

/-- `∂ᵏ (t ↦ (f t : ℂ)) = (∂ᵏ f : ℂ)` for smooth real `f`. -/
theorem iteratedDeriv_ofReal_comp {f : ℝ → ℝ} (hf : ContDiff ℝ ∞ f) (k : ℕ) :
    iteratedDeriv k (fun t => (f t : ℂ)) = fun t => ((iteratedDeriv k f t : ℝ) : ℂ) := by
  induction k with
  | zero => simp
  | succ k ih =>
    rw [iteratedDeriv_succ, ih, iteratedDeriv_succ]
    funext t
    have hd : Differentiable ℝ (iteratedDeriv k f) :=
      (contDiff_infty.mp hf (k + 1)).differentiable_iteratedDeriv k (by exact_mod_cast Nat.lt_succ_self k)
    exact ((hd t).hasDerivAt.ofReal_comp).deriv

/-- Young's (4.3) for every `j ≥ 0` (`j = 0` is `VY_decay_young`). -/
theorem VY_iter_bound0 (r : ℕ) {A : ℝ} (hA : 0 < A) :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → α + β ≠ 0 →
      ∀ t : ℝ, 1 ≤ t → ∀ x : ℝ, 0 < x → ∀ c : ℝ, 0 < c →
        ‖(t : ℂ) ^ r * iteratedDeriv r (fun t => VY α β c x t) t‖ ≤
          C * (1 + 1 / ‖α + β‖ ^ 2) * (1 + x / t) ^ (-A) := by
  rcases Nat.eq_zero_or_pos r with h0 | h0
  · subst h0
    obtain ⟨C, hC0, hC⟩ := VY_decay_young hA
    refine ⟨C, hC0, fun α β hα hβ hαβ t ht x hx c hc => ?_⟩
    rw [pow_zero, one_mul, iteratedDeriv_zero]
    exact hC α β hα hβ hαβ t ht x hx c hc
  · exact VY_iter_bound h0 hA

/-- On the support: `‖∂ʳ V(t)‖ ≤ C N (4/Δ)^r (1 + x/(2T))^(−A)`, `T/4 ≤ t ≤ 2T`, `T ≥ 4`. -/
theorem VY_iter_on_supp {r : ℕ} {A C : ℝ} (hA : 0 < A) (hC0 : 0 ≤ C)
    (hC : ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → α + β ≠ 0 →
      ∀ t : ℝ, 1 ≤ t → ∀ x : ℝ, 0 < x → ∀ c : ℝ, 0 < c →
        ‖(t : ℂ) ^ r * iteratedDeriv r (fun t => VY α β c x t) t‖ ≤
          C * (1 + 1 / ‖α + β‖ ^ 2) * (1 + x / t) ^ (-A))
    {T L : ℝ} (hT : 4 ≤ T) (hL : 1 ≤ L) {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10)
    (hαβ : α + β ≠ 0) {x : ℝ} (hx : 0 < x) {c : ℝ} (hc : 0 < c) {t : ℝ}
    (ht : t ∈ Set.Icc (T / 4) (2 * T)) :
    ‖iteratedDeriv r (fun t => VY α β c x t) t‖ ≤
      C * (1 + 1 / ‖α + β‖ ^ 2) * (4 * (T / L)⁻¹) ^ r * (1 + x / (2 * T)) ^ (-A) := by
  have hT0 : 0 < T := by linarith
  have ht1 : 1 ≤ t := by linarith [ht.1]
  have ht0 : 0 < t := by linarith
  have hD := decay_le hA hx ht0 ht.2
  have hti : t⁻¹ ≤ 4 * (T / L)⁻¹ := inv_t_le hT0 hL ht.1
  have h := hC α β hα hβ hαβ t ht1 x hx c hc
  rw [norm_mul, norm_pow, Complex.norm_real, Real.norm_eq_abs, abs_of_pos ht0] at h
  have hN : 0 ≤ 1 + 1 / ‖α + β‖ ^ 2 := by positivity
  have h' : t ^ r * ‖iteratedDeriv r (fun t => VY α β c x t) t‖ ≤
      C * (1 + 1 / ‖α + β‖ ^ 2) * (1 + x / (2 * T)) ^ (-A) :=
    h.trans (mul_le_mul_of_nonneg_left hD (by positivity))
  have e : ‖iteratedDeriv r (fun t => VY α β c x t) t‖ =
      (t⁻¹) ^ r * (t ^ r * ‖iteratedDeriv r (fun t => VY α β c x t) t‖) := by
    rw [← mul_assoc, ← mul_pow, inv_mul_cancel₀ ht0.ne', one_pow, one_mul]
  have hp : (t⁻¹) ^ r ≤ (4 * (T / L)⁻¹) ^ r := pow_le_pow_left₀ (by positivity) hti r
  rw [e]
  calc (t⁻¹) ^ r * (t ^ r * ‖iteratedDeriv r (fun t => VY α β c x t) t‖) ≤
        (4 * (T / L)⁻¹) ^ r * (C * (1 + 1 / ‖α + β‖ ^ 2) * (1 + x / (2 * T)) ^ (-A)) :=
        mul_le_mul hp h' (by positivity) (by positivity)
    _ = _ := by ring

section Iter

variable {T L : ℝ} (W : WeightAll T L) {α β : ℂ} {c x : ℝ}

theorem Fw_contDiff (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) (hx : 0 < x) (hc : 0 < c) :
    ContDiff ℝ ∞ (Fw W.toWeight α β c x) :=
  (Complex.ofRealCLM.contDiff.comp W.smooth).mul (VY_contDiff hα hβ hx hc)

/-- Off the support every derivative of `F = wV` vanishes. -/
theorem Fw_iter_zero_out (k : ℕ) {t : ℝ} (ht : t ∉ Set.Icc (T / 4) (2 * T)) :
    iteratedDeriv k (Fw W.toWeight α β c x) t = 0 := by
  have hU : IsOpen (Set.Icc (T / 4) (2 * T))ᶜ := isClosed_Icc.isOpen_compl
  have hEq : Set.EqOn (Fw W.toWeight α β c x) (fun _ => (0 : ℂ)) (Set.Icc (T / 4) (2 * T))ᶜ :=
    fun s hs => (Fw_zero_out (W := W.toWeight) (α := α) (β := β) (c := c) (x := x) hs).1
  rw [Set.EqOn.iteratedDeriv_of_isOpen hEq hU k ht]
  exact iteratedDeriv_fun_const_zero

/-- Leibniz for `F = wV`. -/
theorem Fw_iter_leibniz (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) (hx : 0 < x) (hc : 0 < c)
    (j : ℕ) (t : ℝ) :
    iteratedDeriv j (Fw W.toWeight α β c x) t = ∑ i ∈ Finset.range (j + 1),
      (j.choose i : ℂ) * ((iteratedDeriv i W.w t : ℝ) : ℂ) *
        iteratedDeriv (j - i) (fun t => VY α β c x t) t := by
  have hf : ContDiffAt ℝ j (fun t => (W.w t : ℂ)) t :=
    (contDiff_infty.mp (Complex.ofRealCLM.contDiff.comp W.smooth) j).contDiffAt
  have hg : ContDiffAt ℝ j (fun t => VY α β c x t) t :=
    (contDiff_infty.mp (VY_contDiff hα hβ hx hc) j).contDiffAt
  have e : Fw W.toWeight α β c x = fun t => (W.w t : ℂ) * VY α β c x t := rfl
  rw [e, iteratedDeriv_fun_mul hf hg]
  refine Finset.sum_congr rfl fun i _ => ?_
  congr 2
  exact congrFun (iteratedDeriv_ofReal_comp W.smooth i) t

end Iter

/-- The pointwise bound on `F^(j)`, `F = wV`:
`‖(wV)^(j)(t)‖ ≤ K (1 + Σ_{i ≤ j} C_i) N Δ^(−j) (1 + x/(2T))^(−A)`, every `t`, `T ≥ 4`, `L ≥ 1`. -/
theorem Fw_iter_bound (j : ℕ) {A : ℝ} (hA : 0 < A) :
    ∃ K : ℝ, 0 ≤ K ∧ ∀ (T L : ℝ) (W : WeightAll T L), 4 ≤ T → 1 ≤ L →
      ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → α + β ≠ 0 →
      ∀ x : ℝ, 0 < x → ∀ c : ℝ, 0 < c → ∀ t : ℝ,
        ‖iteratedDeriv j (Fw W.toWeight α β c x) t‖ ≤ K * wsum W j * (1 + 1 / ‖α + β‖ ^ 2) *
          ((T / L) ^ j)⁻¹ * (1 + x / (2 * T)) ^ (-A) := by
  choose CV hCV0 hCV using fun r : ℕ => VY_iter_bound0 r hA
  refine ⟨∑ i ∈ Finset.range (j + 1), (j.choose i : ℝ) * CV (j - i) * 4 ^ (j - i),
    Finset.sum_nonneg fun i _ => by have := hCV0 (j - i); positivity,
    fun T L W hT hL α β hα hβ hαβ x hx c hc t => ?_⟩
  have hT0 : 0 < T := by linarith
  have hΔ : 0 < T / L := div_pos hT0 (by linarith)
  set e : ℝ := (T / L)⁻¹ with he
  have he0 : 0 < e := inv_pos.mpr hΔ
  set N : ℝ := 1 + 1 / ‖α + β‖ ^ 2 with hN
  set D : ℝ := (1 + x / (2 * T)) ^ (-A) with hD
  have hN0 : 0 ≤ N := by positivity
  have hD0 : 0 ≤ D := by positivity
  have hW0 := wsum_nonneg W j
  have hej : ((T / L) ^ j)⁻¹ = e ^ j := by rw [he, inv_pow]
  rw [hej]
  by_cases hs : t ∈ Set.Icc (T / 4) (2 * T)
  swap
  · rw [Fw_iter_zero_out W j hs, norm_zero]
    have : 0 ≤ ∑ i ∈ Finset.range (j + 1), (j.choose i : ℝ) * CV (j - i) * 4 ^ (j - i) :=
      Finset.sum_nonneg fun i _ => by have := hCV0 (j - i); positivity
    positivity
  rw [Fw_iter_leibniz W hα hβ hx hc]
  refine (norm_sum_le _ _).trans ?_
  rw [Finset.sum_mul, Finset.sum_mul, Finset.sum_mul, Finset.sum_mul]
  refine Finset.sum_le_sum fun i hi => ?_
  have hij : i ≤ j := Nat.lt_succ_iff.mp (Finset.mem_range.mp hi)
  have hV := VY_iter_on_supp (r := j - i) hA (hCV0 (j - i)) (hCV (j - i)) hT hL hα hβ hαβ hx hc hs
  rw [← hN, ← hD, ← he] at hV
  have hw : ‖((iteratedDeriv i W.w t : ℝ) : ℂ)‖ ≤ W.Cj i * e ^ i := by
    rw [Complex.norm_real, Real.norm_eq_abs, he, inv_pow]
    exact W.dj i t
  have hCi := Cj_le_wsum W hij
  have hCV0' := hCV0 (j - i)
  have hpow : e ^ i * (4 * e) ^ (j - i) = 4 ^ (j - i) * e ^ j := by
    rw [mul_pow, ← mul_assoc, mul_comm (e ^ i), mul_assoc, ← pow_add, Nat.add_sub_cancel' hij]
  rw [norm_mul, norm_mul, Complex.norm_natCast]
  calc (j.choose i : ℝ) * ‖((iteratedDeriv i W.w t : ℝ) : ℂ)‖ *
        ‖iteratedDeriv (j - i) (fun t => VY α β c x t) t‖ ≤
      (j.choose i : ℝ) * (W.Cj i * e ^ i) * (CV (j - i) * N * (4 * e) ^ (j - i) * D) := by
        apply mul_le_mul _ hV (norm_nonneg _) (by have := W.Cj_nonneg i; positivity)
        exact mul_le_mul_of_nonneg_left hw (by positivity)
    _ = (j.choose i : ℝ) * CV (j - i) * W.Cj i * N * (e ^ i * (4 * e) ^ (j - i)) * D := by ring
    _ = (j.choose i : ℝ) * CV (j - i) * 4 ^ (j - i) * W.Cj i * N * e ^ j * D := by
        rw [hpow]; ring
    _ ≤ (j.choose i : ℝ) * CV (j - i) * 4 ^ (j - i) * wsum W j * N * e ^ j * D := by
        apply mul_le_mul_of_nonneg_right _ hD0
        apply mul_le_mul_of_nonneg_right _ (by positivity)
        apply mul_le_mul_of_nonneg_right _ hN0
        exact mul_le_mul_of_nonneg_left hCi (by positivity)

/-- **The off-diagonal integral, `j` integrations by parts.** For every `j` and `A > 0` there is
`K` with `‖∫ w(t) V_{α,β}(x,t) e^(−iλt) dt‖ ≤ K (1 + Σ_{i≤j} C_i) N T (Δ|λ|)^(−j) (1 + x/(2T))^(−A)`,
`Δ = T/L`, uniformly in the weight, `‖α‖, ‖β‖ ≤ 1/10`, `α + β ≠ 0`, `x > 0`, `λ ≠ 0`, `c > 0`,
`T ≥ 8`, `L ≥ 1`. Young §4, Lemma 5's proof. -/
theorem offdiag_term_iter (j : ℕ) {A : ℝ} (hA : 0 < A) :
    ∃ K : ℝ, 0 ≤ K ∧ ∀ (T L : ℝ) (W : WeightAll T L), 8 ≤ T → 1 ≤ L →
      ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → α + β ≠ 0 →
      ∀ x : ℝ, 0 < x → ∀ c : ℝ, 0 < c → ∀ l : ℝ, l ≠ 0 →
        ‖∫ t, (W.w t : ℂ) * VY α β c x t * eL l t‖ ≤
          K * wsum W j * (1 + 1 / ‖α + β‖ ^ 2) * T * ((T / L) ^ j)⁻¹ * (|l| ^ j)⁻¹ *
            (1 + x / (2 * T)) ^ (-A) := by
  obtain ⟨K, hK0, hK⟩ := Fw_iter_bound j hA
  refine ⟨4 * K, by positivity, fun T L W hT hL α β hα hβ hαβ x hx c hc l hl => ?_⟩
  have hT0 : 0 < T := by linarith
  have hab : T / 8 ≤ 4 * T := by linarith
  set B : ℝ := K * wsum W j * (1 + 1 / ‖α + β‖ ^ 2) * ((T / L) ^ j)⁻¹ *
    (1 + x / (2 * T)) ^ (-A) with hB
  have hB0 : 0 ≤ B := by
    have := wsum_nonneg W j
    have : 0 < T / L := div_pos hT0 (by linarith)
    positivity
  have hout : ∀ t, t ∉ Set.Ioc (T / 8) (4 * T) → t ∉ Set.Icc (T / 4) (2 * T) := by
    intro t ht h
    apply ht
    constructor <;> linarith [h.1, h.2]
  have hR : ∫ t, (W.w t : ℂ) * VY α β c x t * eL l t =
      ∫ t in (T / 8)..(4 * T), Fw W.toWeight α β c x t * eL l t := by
    rw [intervalIntegral.integral_of_le hab]
    refine (setIntegral_eq_integral_of_forall_compl_eq_zero fun t ht => ?_).symm
    rw [show (W.w t : ℂ) * VY α β c x t = Fw W.toWeight α β c x t from rfl,
      (Fw_zero_out (hout t ht)).1, zero_mul]
  have e8 : T / 8 ∉ Set.Icc (T / 4) (2 * T) := fun h => by linarith [h.1]
  have e4 : 4 * T ∉ Set.Icc (T / 4) (2 * T) := fun h => by linarith [h.2]
  have hF := Fw_contDiff W hα hβ hx hc
  have hibp := ibp_iter hl j (contDiff_infty.mp hF j)
    (fun k _ => Fw_iter_zero_out W k e8) (fun k _ => Fw_iter_zero_out W k e4)
  rw [hR, hibp, norm_mul]
  have hn : ‖(1 / ((l : ℂ) * I)) ^ j‖ = (|l| ^ j)⁻¹ := by
    rw [norm_pow, norm_div, norm_one, norm_mul, Complex.norm_real, Complex.norm_I, mul_one,
      Real.norm_eq_abs, one_div, inv_pow]
  have hI : ‖∫ t in (T / 8)..(4 * T), iteratedDeriv j (Fw W.toWeight α β c x) t * eL l t‖ ≤
      B * |4 * T - T / 8| := by
    refine intervalIntegral.norm_integral_le_of_norm_le_const fun t _ => ?_
    rw [norm_mul, norm_eL, mul_one]
    exact hK T L W (by linarith) hL α β hα hβ hαβ x hx c hc t
  have h48 : |4 * T - T / 8| = 4 * T - T / 8 := abs_of_nonneg (by linarith)
  rw [h48] at hI
  rw [hn]
  have hl0 : 0 ≤ (|l| ^ j)⁻¹ := by positivity
  calc (|l| ^ j)⁻¹ * ‖∫ t in (T / 8)..(4 * T), iteratedDeriv j (Fw W.toWeight α β c x) t * eL l t‖
        ≤ (|l| ^ j)⁻¹ * (B * (4 * T)) := by
        apply mul_le_mul_of_nonneg_left (hI.trans _) hl0
        exact mul_le_mul_of_nonneg_left (by linarith) hB0
    _ = _ := by rw [hB]; ring

/-- **The off-diagonal term in Young's form, `2r` integrations.** For every `r` and `A > 0` there
is `K` with, for integers `h, k, m, n ≥ 1`, `hm ≠ kn`,
`‖Jint‖ ≤ K (1 + Σ_{i≤2r} C_i) N T Δ^(−2r) (4hm·kn)^r (1 + mn/(2T))^(−A)`; the gap
`|log(hm/kn)|^(−2) ≤ 4hm·kn` (`inv_log_sq_le`) is used `r` times. -/
theorem offdiag_term_iter_young (r : ℕ) {A : ℝ} (hA : 0 < A) :
    ∃ K : ℝ, 0 ≤ K ∧ ∀ (T L : ℝ) (W : WeightAll T L), 8 ≤ T → 1 ≤ L →
      ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → α + β ≠ 0 → ∀ c : ℝ, 0 < c →
      ∀ h k m n : ℕ, 1 ≤ h → 1 ≤ k → 1 ≤ m → 1 ≤ n → h * m ≠ k * n →
        ‖Jint W.toWeight α β c h k m n‖ ≤
          K * wsum W (2 * r) * (1 + 1 / ‖α + β‖ ^ 2) * T * ((T / L) ^ (2 * r))⁻¹ *
            (4 * ((h : ℝ) * m) * ((k : ℝ) * n)) ^ r * (1 + (m : ℝ) * n / (2 * T)) ^ (-A) := by
  obtain ⟨K, hK0, hK⟩ := offdiag_term_iter (2 * r) hA
  refine ⟨K, hK0, fun T L W hT hL α β hα hβ hαβ c hc h k m n hh hk hm hn hne => ?_⟩
  have hp : (0 : ℝ) < (h : ℝ) * m := by
    have : (0 : ℝ) < h := by exact_mod_cast hh
    have : (0 : ℝ) < m := by exact_mod_cast hm
    positivity
  have hq : (0 : ℝ) < (k : ℝ) * n := by
    have : (0 : ℝ) < k := by exact_mod_cast hk
    have : (0 : ℝ) < n := by exact_mod_cast hn
    positivity
  have hx : (0 : ℝ) < (m : ℝ) * n := by
    have : (0 : ℝ) < m := by exact_mod_cast hm
    have : (0 : ℝ) < n := by exact_mod_cast hn
    positivity
  have e : ((h : ℂ) * m / ((k : ℂ) * n)) = ((((h : ℝ) * m : ℝ) : ℂ) / (((k : ℝ) * n : ℝ) : ℂ)) := by
    push_cast
    ring
  set l : ℝ := Real.log ((h : ℝ) * m / ((k : ℝ) * n)) with hl
  have hcast : ((h * m : ℕ) : ℝ) / ((k * n : ℕ) : ℝ) = (h : ℝ) * m / ((k : ℝ) * n) := by
    push_cast
    ring
  have hne' : (h : ℝ) * m / ((k : ℝ) * n) ≠ 1 := by
    intro h1
    rw [div_eq_one_iff_eq hq.ne'] at h1
    exact hne (by exact_mod_cast h1)
  have hl0 : l ≠ 0 := Real.log_ne_zero_of_pos_of_ne_one (div_pos hp hq) hne'
  have hgap : (l ^ 2)⁻¹ ≤ 4 * ((h : ℝ) * m) * ((k : ℝ) * n) := by
    have := inv_log_sq_le (P := h * m) (Q := k * n) (Nat.one_le_iff_ne_zero.mpr
      (Nat.mul_ne_zero (by omega) (by omega))) (Nat.one_le_iff_ne_zero.mpr
      (Nat.mul_ne_zero (by omega) (by omega))) hne
    rw [hcast] at this
    push_cast at this
    rw [hl]
    linarith
  have hgapr : (|l| ^ (2 * r))⁻¹ ≤ (4 * ((h : ℝ) * m) * ((k : ℝ) * n)) ^ r := by
    rw [pow_mul, sq_abs, ← inv_pow]
    exact pow_le_pow_left₀ (by positivity) hgap r
  unfold Jint
  simp only [e, ratio_cpow_eq hp hq]
  rw [← hl]
  have hb := hK T L W hT hL α β hα hβ hαβ ((m : ℝ) * n) hx c hc l hl0
  have hpre : 0 ≤ K * wsum W (2 * r) * (1 + 1 / ‖α + β‖ ^ 2) * T * ((T / L) ^ (2 * r))⁻¹ := by
    have := wsum_nonneg W (2 * r)
    have : (0 : ℝ) < T := by linarith
    have : 0 < T / L := div_pos this (by linarith)
    positivity
  have hD : 0 ≤ (1 + (m : ℝ) * n / (2 * T)) ^ (-A) := by
    have : (0 : ℝ) < T := by linarith
    positivity
  calc _ ≤ _ := hb
    _ ≤ K * wsum W (2 * r) * (1 + 1 / ‖α + β‖ ^ 2) * T * ((T / L) ^ (2 * r))⁻¹ *
          (4 * ((h : ℝ) * m) * ((k : ℝ) * n)) ^ r * (1 + (m : ℝ) * n / (2 * T)) ^ (-A) :=
        mul_le_mul_of_nonneg_right (mul_le_mul_of_nonneg_left hgapr hpre) hD

/-! ## Part 3: the off-diagonal summed, `2r` integrations -/

/-- The majorant `(m n)^(−6/5)`, `m = p.1 + 1`, `n = p.2 + 1`. -/
noncomputable
def major6 (p : ℕ × ℕ) : ℝ := ((p.1 : ℝ) + 1) ^ (-(6 / 5) : ℝ) * ((p.2 : ℝ) + 1) ^ (-(6 / 5) : ℝ)

theorem major6_nonneg (p : ℕ × ℕ) : 0 ≤ major6 p := by
  unfold major6
  positivity

theorem summable_major6 : Summable major6 := by
  have h : Summable fun m : ℕ => ‖((m : ℝ) + 1) ^ (-(6 / 5) : ℝ)‖ := by
    have := (summable_succ_rpow (r := -(6 / 5)) (by norm_num)).abs
    simpa [Real.norm_eq_abs] using this
  exact summable_mul_of_summable_norm h h

/-- The decay traded for convergence: `y^r y^(−2/5) (1 + y/(2T))^(−(r+4/5)) ≤ (2T)^(r+4/5) y^(−6/5)`. -/
theorem decay_trade {y T : ℝ} (hy : 0 < y) (hT : 0 < T) (r : ℕ) :
    y ^ r * y ^ (-(2 / 5) : ℝ) * (1 + y / (2 * T)) ^ (-((r : ℝ) + 4 / 5)) ≤
      (2 * T) ^ ((r : ℝ) + 4 / 5) * y ^ (-(6 / 5) : ℝ) := by
  have h2T : 0 < 2 * T := by linarith
  have hr0 : (0 : ℝ) ≤ r := r.cast_nonneg
  have h1 : (1 + y / (2 * T)) ^ (-((r : ℝ) + 4 / 5)) ≤ (y / (2 * T)) ^ (-((r : ℝ) + 4 / 5)) :=
    Real.rpow_le_rpow_of_nonpos (by positivity) (by linarith) (by linarith)
  have h2 : (y / (2 * T)) ^ (-((r : ℝ) + 4 / 5)) =
      (2 * T) ^ ((r : ℝ) + 4 / 5) * y ^ (-((r : ℝ) + 4 / 5)) := by
    rw [Real.div_rpow hy.le h2T.le, Real.rpow_neg h2T.le, div_inv_eq_mul, mul_comm]
  have h3 : y ^ r * y ^ (-(2 / 5) : ℝ) * y ^ (-((r : ℝ) + 4 / 5)) = y ^ (-(6 / 5) : ℝ) := by
    rw [← Real.rpow_natCast, ← Real.rpow_add hy, ← Real.rpow_add hy]
    congr 1
    ring
  calc y ^ r * y ^ (-(2 / 5) : ℝ) * (1 + y / (2 * T)) ^ (-((r : ℝ) + 4 / 5)) ≤
        y ^ r * y ^ (-(2 / 5) : ℝ) * (y / (2 * T)) ^ (-((r : ℝ) + 4 / 5)) :=
        mul_le_mul_of_nonneg_left h1 (by positivity)
    _ = (2 * T) ^ ((r : ℝ) + 4 / 5) * (y ^ r * y ^ (-(2 / 5) : ℝ) * y ^ (-((r : ℝ) + 4 / 5))) := by
        rw [h2]; ring
    _ = _ := by rw [h3]

/-- One off-diagonal term with `2r` integrations: `‖coefY · Jint‖ ≤ P B² 4^r M^(2r) (2T)^(r+4/5)
(mn)^(−6/5)`, for `‖a_h‖ h^(−σ₀) ≤ B` on `1 ≤ h ≤ M`; `P` is the prefactor of
`offdiag_term_iter_young` at `A = r + 4/5`. -/
theorem off_term_iter_le (r : ℕ) {K : ℝ}
    (hK : ∀ (T L : ℝ) (W : WeightAll T L), 8 ≤ T → 1 ≤ L →
      ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → α + β ≠ 0 → ∀ c : ℝ, 0 < c →
      ∀ h k m n : ℕ, 1 ≤ h → 1 ≤ k → 1 ≤ m → 1 ≤ n → h * m ≠ k * n →
        ‖Jint W.toWeight α β c h k m n‖ ≤
          K * wsum W (2 * r) * (1 + 1 / ‖α + β‖ ^ 2) * T * ((T / L) ^ (2 * r))⁻¹ *
            (4 * ((h : ℝ) * m) * ((k : ℝ) * n)) ^ r *
            (1 + (m : ℝ) * n / (2 * T)) ^ (-((r : ℝ) + 4 / 5)))
    (hK0 : 0 ≤ K) {T L : ℝ} (W : WeightAll T L) (hT : 8 ≤ T) (hL : 1 ≤ L) (M : ℕ) (a : ℕ → ℂ)
    (σ₀ B : ℝ) (hB0 : 0 ≤ B) (hB : ∀ h : ℕ, 1 ≤ h → h ≤ M → ‖a h‖ * (h : ℝ) ^ (-σ₀) ≤ B)
    {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) (hαβ : α + β ≠ 0) {c : ℝ} (hc : 0 < c)
    {h k : ℕ} (hh : 1 ≤ h) (hhM : h ≤ M) (hk : 1 ≤ k) (hkM : k ≤ M) (p : ℕ × ℕ)
    (hd : h * (p.1 + 1) ≠ k * (p.2 + 1)) :
    ‖coefY a σ₀ α β h k (p.1 + 1) (p.2 + 1) * Jint W.toWeight α β c h k (p.1 + 1) (p.2 + 1)‖ ≤
      (K * wsum W (2 * r) * (1 + 1 / ‖α + β‖ ^ 2) * T * ((T / L) ^ (2 * r))⁻¹) * B ^ 2 * 4 ^ r *
        (M : ℝ) ^ (2 * r) * ((2 * T) ^ ((r : ℝ) + 4 / 5) * major6 p) := by
  obtain ⟨a1, a2⟩ := re_small hα
  obtain ⟨b1, b2⟩ := re_small hβ
  have hJ := hK T L W hT hL α β hα hβ hαβ c hc h k (p.1 + 1) (p.2 + 1) hh hk (by omega)
    (by omega) hd
  push_cast at hJ
  set m : ℝ := (p.1 : ℝ) + 1 with hm
  set n : ℝ := (p.2 : ℝ) + 1 with hn
  have hm0 : 0 < m := by positivity
  have hn0 : 0 < n := by positivity
  have hm1 : 1 ≤ m := by rw [hm]; linarith [(p.1.cast_nonneg : (0 : ℝ) ≤ p.1)]
  have hn1 : 1 ≤ n := by rw [hn]; linarith [(p.2.cast_nonneg : (0 : ℝ) ≤ p.2)]
  have hh0 : (0 : ℝ) < h := by exact_mod_cast hh
  have hk0 : (0 : ℝ) < k := by exact_mod_cast hk
  have hT0 : (0 : ℝ) < T := by linarith
  set P : ℝ := K * wsum W (2 * r) * (1 + 1 / ‖α + β‖ ^ 2) * T * ((T / L) ^ (2 * r))⁻¹ with hP
  have hP0 : 0 ≤ P := by
    have := wsum_nonneg W (2 * r)
    have : 0 < T / L := div_pos hT0 (by linarith)
    positivity
  set D : ℝ := (1 + m * n / (2 * T)) ^ (-((r : ℝ) + 4 / 5)) with hD
  have hD0 : 0 ≤ D := by positivity
  have hcoef : ‖coefY a σ₀ α β h k (p.1 + 1) (p.2 + 1)‖ = ‖a h‖ * ‖a k‖ *
      ((h : ℝ) ^ (-σ₀) * (k : ℝ) ^ (-σ₀) * m ^ (-(1 / 2 + α.re)) * n ^ (-(1 / 2 + β.re))) := by
    unfold coefY
    have e1 : (((p.1 + 1 : ℕ) : ℂ)) = ((m : ℝ) : ℂ) := by rw [hm]; push_cast; ring
    have e2 : (((p.2 + 1 : ℕ) : ℂ)) = ((n : ℝ) : ℂ) := by rw [hn]; push_cast; ring
    rw [e1, e2]
    simp only [norm_mul, Complex.norm_conj, Complex.norm_natCast_cpow_of_pos (by omega : 0 < h),
      Complex.norm_natCast_cpow_of_pos (by omega : 0 < k), norm_cpow_eq_rpow_re_of_pos hm0,
      norm_cpow_eq_rpow_re_of_pos hn0]
    simp
  set X : ℝ := ‖a h‖ * (h : ℝ) ^ (-σ₀) with hX
  set Y : ℝ := ‖a k‖ * (k : ℝ) ^ (-σ₀) with hY
  have hX0 : 0 ≤ X := by positivity
  have hY0 : 0 ≤ Y := by positivity
  have hXY : X * Y ≤ B ^ 2 := by
    rw [sq]
    exact mul_le_mul (hB h hh hhM) (hB k hk hkM) hY0 hB0
  have hHK : ((h : ℝ) * k) ^ r ≤ (M : ℝ) ^ (2 * r) := by
    have hhM' : (h : ℝ) ≤ M := by exact_mod_cast hhM
    have hkM' : (k : ℝ) ≤ M := by exact_mod_cast hkM
    rw [pow_mul, sq]
    exact pow_le_pow_left₀ (by positivity) (mul_le_mul hhM' hkM' hk0.le (by linarith)) r
  have em : m ^ (-(1 / 2 + α.re)) ≤ m ^ (-(2 / 5) : ℝ) :=
    Real.rpow_le_rpow_of_exponent_le hm1 (by linarith)
  have en : n ^ (-(1 / 2 + β.re)) ≤ n ^ (-(2 / 5) : ℝ) :=
    Real.rpow_le_rpow_of_exponent_le hn1 (by linarith)
  set Q : ℝ := (m * n) ^ r * m ^ (-(1 / 2 + α.re)) * n ^ (-(1 / 2 + β.re)) * D with hQ
  have hQ0 : 0 ≤ Q := by positivity
  have hQle : Q ≤ (2 * T) ^ ((r : ℝ) + 4 / 5) * major6 p := by
    have hmn : 0 < m * n := by positivity
    have h1 : Q ≤ (m * n) ^ r * m ^ (-(2 / 5) : ℝ) * n ^ (-(2 / 5) : ℝ) * D := by
      rw [hQ]
      apply mul_le_mul_of_nonneg_right _ hD0
      rw [mul_assoc, mul_assoc]
      apply mul_le_mul_of_nonneg_left _ (by positivity)
      exact mul_le_mul em en (by positivity) (by positivity)
    have h2 : (m * n) ^ r * m ^ (-(2 / 5) : ℝ) * n ^ (-(2 / 5) : ℝ) * D =
        (m * n) ^ r * (m * n) ^ (-(2 / 5) : ℝ) * (1 + m * n / (2 * T)) ^ (-((r : ℝ) + 4 / 5)) := by
      rw [Real.mul_rpow hm0.le hn0.le, hD]
      ring
    have h3 := decay_trade hmn hT0 r
    have h4 : (m * n) ^ (-(6 / 5) : ℝ) = major6 p := by
      unfold major6
      rw [← hm, ← hn, Real.mul_rpow hm0.le hn0.le]
    rw [h2] at h1
    rw [← h4]
    exact h1.trans h3
  have hJ' : ‖Jint W.toWeight α β c h k (p.1 + 1) (p.2 + 1)‖ ≤
      P * (4 * ((h : ℝ) * m) * ((k : ℝ) * n)) ^ r * D := hJ
  have e4 : (4 * ((h : ℝ) * m) * ((k : ℝ) * n)) ^ r = 4 ^ r * ((h : ℝ) * k) ^ r * (m * n) ^ r := by
    rw [← mul_pow, ← mul_pow]
    ring
  rw [norm_mul, hcoef]
  calc ‖a h‖ * ‖a k‖ * ((h : ℝ) ^ (-σ₀) * (k : ℝ) ^ (-σ₀) * m ^ (-(1 / 2 + α.re)) *
        n ^ (-(1 / 2 + β.re))) * ‖Jint W.toWeight α β c h k (p.1 + 1) (p.2 + 1)‖ ≤
      ‖a h‖ * ‖a k‖ * ((h : ℝ) ^ (-σ₀) * (k : ℝ) ^ (-σ₀) * m ^ (-(1 / 2 + α.re)) *
        n ^ (-(1 / 2 + β.re))) * (P * (4 * ((h : ℝ) * m) * ((k : ℝ) * n)) ^ r * D) :=
        mul_le_mul_of_nonneg_left hJ' (by positivity)
    _ = X * Y * P * 4 ^ r * ((h : ℝ) * k) ^ r * Q := by
        rw [e4, hX, hY, hQ]
        ring
    _ ≤ B ^ 2 * P * 4 ^ r * (M : ℝ) ^ (2 * r) * ((2 * T) ^ ((r : ℝ) + 4 / 5) * major6 p) := by
        apply mul_le_mul _ hQle hQ0 (by positivity)
        apply mul_le_mul _ hHK (by positivity) (by positivity)
        apply mul_le_mul_of_nonneg_right _ (by positivity)
        exact mul_le_mul_of_nonneg_right hXY hP0
    _ = P * B ^ 2 * 4 ^ r * (M : ℝ) ^ (2 * r) * ((2 * T) ^ ((r : ℝ) + 4 / 5) * major6 p) := by
        ring

/-- **The off-diagonal, summed, with `2r` integrations by parts.** For every `r` there is `K` with
`‖offSum‖ ≤ K (1 + Σ_{i≤2r} C_i) N T Δ^(−2r) B² M^(2r+2) (2T)^(r+4/5)`, for any coefficients with
`‖a_h‖ h^(−σ₀) ≤ B` on `1 ≤ h ≤ M`, `T ≥ 8`, `L ≥ 1`, `‖α‖, ‖β‖ ≤ 1/10`, `α + β ≠ 0`, `c > 0`. -/
theorem offSum_bound_iter (r : ℕ) :
    ∃ K : ℝ, 0 ≤ K ∧ ∀ (T L : ℝ) (W : WeightAll T L), 8 ≤ T → 1 ≤ L →
      ∀ (M : ℕ) (a : ℕ → ℂ) (σ₀ B : ℝ), 0 ≤ B →
      (∀ h : ℕ, 1 ≤ h → h ≤ M → ‖a h‖ * (h : ℝ) ^ (-σ₀) ≤ B) →
      ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → α + β ≠ 0 → ∀ c : ℝ, 0 < c →
        ‖offSum W.toWeight M a σ₀ α β c‖ ≤ K * wsum W (2 * r) * (1 + 1 / ‖α + β‖ ^ 2) * T *
          ((T / L) ^ (2 * r))⁻¹ * B ^ 2 * (M : ℝ) ^ (2 * r + 2) * (2 * T) ^ ((r : ℝ) + 4 / 5) := by
  have hA : (0 : ℝ) < (r : ℝ) + 4 / 5 := by have := r.cast_nonneg (α := ℝ); linarith
  obtain ⟨K, hK0, hK⟩ := offdiag_term_iter_young r hA
  set S : ℝ := ∑' p : ℕ × ℕ, major6 p with hS
  have hS0 : 0 ≤ S := tsum_nonneg major6_nonneg
  refine ⟨K * 4 ^ r * S, by positivity,
    fun T L W hT hL M a σ₀ B hB0 hB α β hα hβ hαβ c hc => ?_⟩
  have hT0 : 0 < T := by linarith
  set P : ℝ := K * wsum W (2 * r) * (1 + 1 / ‖α + β‖ ^ 2) * T * ((T / L) ^ (2 * r))⁻¹ with hP
  have hP0 : 0 ≤ P := by
    have := wsum_nonneg W (2 * r)
    have : 0 < T / L := div_pos hT0 (by linarith)
    positivity
  set Z : ℝ := P * B ^ 2 * 4 ^ r * (M : ℝ) ^ (2 * r) * (2 * T) ^ ((r : ℝ) + 4 / 5) with hZ
  have hZ0 : 0 ≤ Z := by positivity
  have hrow : ∀ h ∈ Finset.Icc 1 M, ∀ k ∈ Finset.Icc 1 M,
      ‖∑' p : ℕ × ℕ, (if h * (p.1 + 1) = k * (p.2 + 1) then 0 else
        coefY a σ₀ α β h k (p.1 + 1) (p.2 + 1) * Jint W.toWeight α β c h k (p.1 + 1) (p.2 + 1))‖ ≤
        Z * S := by
    intro h hh k hk
    obtain ⟨hh1, hhM⟩ := Finset.mem_Icc.mp hh
    obtain ⟨hk1, hkM⟩ := Finset.mem_Icc.mp hk
    have hs := summable_hk W.toWeight (by linarith) a σ₀ hα hβ hc hh1 hk1
    have hle : ∀ p : ℕ × ℕ, ‖(if h * (p.1 + 1) = k * (p.2 + 1) then 0 else
        coefY a σ₀ α β h k (p.1 + 1) (p.2 + 1) * Jint W.toWeight α β c h k (p.1 + 1) (p.2 + 1))‖ ≤
        Z * major6 p := by
      intro p
      split_ifs with hd
      · rw [norm_zero]
        have := major6_nonneg p
        positivity
      · have := off_term_iter_le r hK hK0 W hT hL M a σ₀ B hB0 hB hα hβ hαβ hc hh1 hhM hk1 hkM p hd
        rw [hZ]
        calc _ ≤ _ := this
          _ = _ := by ring
    have hsn : Summable fun p : ℕ × ℕ => ‖(if h * (p.1 + 1) = k * (p.2 + 1) then 0 else
        coefY a σ₀ α β h k (p.1 + 1) (p.2 + 1) * Jint W.toWeight α β c h k (p.1 + 1) (p.2 + 1))‖ :=
      Summable.of_nonneg_of_le (fun p => norm_nonneg _) (fun p => by
        split_ifs
        · rw [norm_zero]
          exact norm_nonneg _
        · exact le_rfl) hs
    calc _ ≤ ∑' p : ℕ × ℕ, ‖(if h * (p.1 + 1) = k * (p.2 + 1) then 0 else
          coefY a σ₀ α β h k (p.1 + 1) (p.2 + 1) * Jint W.toWeight α β c h k (p.1 + 1) (p.2 + 1))‖ :=
          norm_tsum_le_tsum_norm hsn
      _ ≤ ∑' p : ℕ × ℕ, Z * major6 p :=
          Summable.tsum_le_tsum hle hsn (summable_major6.mul_left _)
      _ = Z * S := by rw [tsum_mul_left]
  unfold offSum
  calc _ ≤ ∑ h ∈ Finset.Icc 1 M, ‖∑ k ∈ Finset.Icc 1 M, ∑' p : ℕ × ℕ,
        (if h * (p.1 + 1) = k * (p.2 + 1) then 0 else
          coefY a σ₀ α β h k (p.1 + 1) (p.2 + 1) * Jint W.toWeight α β c h k (p.1 + 1) (p.2 + 1))‖ :=
        norm_sum_le _ _
    _ ≤ ∑ h ∈ Finset.Icc 1 M, ∑ k ∈ Finset.Icc 1 M, Z * S :=
        Finset.sum_le_sum fun h hh => (norm_sum_le _ _).trans
          (Finset.sum_le_sum fun k hk => hrow h hh k hk)
    _ = (M : ℝ) * ((M : ℝ) * (Z * S)) := by simp
    _ = _ := by rw [hZ, hP]; ring

/-- Young's coefficients: `‖a_h‖ h^(−σ₀) ≤ B` on `1 ≤ h ≤ M`, `B = sup_{[0,1]} |P|`
(`|μ| ≤ 1`, `h^(σ₀−1/2) h^(−σ₀) = h^(−1/2) ≤ 1`). -/
theorem aY_bound (P : Polynomial ℝ) : ∃ B : ℝ, 0 ≤ B ∧ ∀ (T θ R : ℝ) (h : ℕ), 1 ≤ h →
    h ≤ Mof T θ → ‖aY P T θ R h‖ * (h : ℝ) ^ (-sig0 T R) ≤ B := by
  obtain ⟨C, hC⟩ := (isCompact_Icc (a := (0 : ℝ)) (b := 1)).exists_bound_of_continuousOn
    (P.continuous (R := ℝ)).continuousOn
  refine ⟨max C 0, le_max_right _ _, fun T θ R h hh hhM => ?_⟩
  set Mr : ℝ := (Mof T θ : ℝ) with hMr
  have hh0 : (0 : ℝ) < h := by exact_mod_cast hh
  have hh1 : (1 : ℝ) ≤ h := by exact_mod_cast hh
  have hhM' : (h : ℝ) ≤ Mr := by rw [hMr]; exact_mod_cast hhM
  have hM1 : 1 ≤ Mr := hh1.trans hhM'
  set u : ℝ := Real.log (Mr / h) / Real.log Mr with hu
  have hu0 : 0 ≤ u := div_nonneg (Real.log_nonneg ((one_le_div hh0).mpr hhM'))
    (Real.log_nonneg hM1)
  have hu1 : u ≤ 1 := div_le_one_of_le₀
    (Real.log_le_log (div_pos (by linarith) hh0) (div_le_self (by linarith) hh1))
    (Real.log_nonneg hM1)
  have hPu : |P.eval u| ≤ max C 0 := by
    have := hC u ⟨hu0, hu1⟩
    rw [Real.norm_eq_abs] at this
    exact this.trans (le_max_left _ _)
  have hpow : 0 < (h : ℝ) ^ (sig0 T R - 1 / 2) := Real.rpow_pos_of_pos hh0 _
  have hμ : |((ArithmeticFunction.moebius h : ℤ) : ℝ)| ≤ 1 := by
    exact_mod_cast ArithmeticFunction.abs_moebius_le_one
  have hnorm : ‖aY P T θ R h‖ = |((ArithmeticFunction.moebius h : ℤ) : ℝ)| * |P.eval u| *
      (h : ℝ) ^ (sig0 T R - 1 / 2) := by
    unfold aY
    rw [norm_mul, norm_mul, Complex.norm_real, Complex.norm_real, Real.norm_eq_abs,
      Real.norm_eq_abs, abs_of_pos hpow, ← hMr, ← hu]
    congr 2
    rw [Complex.norm_intCast]
  have hcomb : (h : ℝ) ^ (sig0 T R - 1 / 2) * (h : ℝ) ^ (-sig0 T R) ≤ 1 := by
    rw [← Real.rpow_add hh0]
    exact Real.rpow_le_one_of_one_le_of_nonpos hh1 (by linarith)
  rw [hnorm]
  have hB0 : 0 ≤ max C 0 := le_max_right _ _
  calc |((ArithmeticFunction.moebius h : ℤ) : ℝ)| * |P.eval u| * (h : ℝ) ^ (sig0 T R - 1 / 2) *
        (h : ℝ) ^ (-sig0 T R) =
      (|((ArithmeticFunction.moebius h : ℤ) : ℝ)| * |P.eval u|) *
        ((h : ℝ) ^ (sig0 T R - 1 / 2) * (h : ℝ) ^ (-sig0 T R)) := by ring
    _ ≤ (1 * max C 0) * 1 :=
        mul_le_mul (mul_le_mul hμ hPu (abs_nonneg _) zero_le_one) hcomb (by positivity)
          (by positivity)
    _ = max C 0 := by ring

/-- `(log T)^p ≤ (5(p+1))^p T^(1/5)` for `T ≥ 1`. -/
theorem logpow_le (p : ℕ) {T : ℝ} (hT : 1 ≤ T) :
    Real.log T ^ p ≤ (5 * ((p : ℝ) + 1)) ^ p * T ^ (1 / 5 : ℝ) := by
  have hp0 : (0 : ℝ) ≤ p := p.cast_nonneg
  set ε : ℝ := 1 / (5 * ((p : ℝ) + 1)) with hε
  have hε0 : 0 < ε := by positivity
  have hL := Real.log_le_rpow_div (by linarith : (0 : ℝ) ≤ T) hε0
  have e : T ^ ε / ε = 5 * ((p : ℝ) + 1) * T ^ ε := by
    rw [hε, div_div_eq_mul_div, div_one, mul_comm]
  rw [e] at hL
  have h1 := pow_le_pow_left₀ (Real.log_nonneg hT) hL p
  have hεp : ε * p ≤ 1 / 5 := by
    rw [hε, div_mul_eq_mul_div, one_mul, div_le_iff₀ (by positivity)]
    linarith
  have h2 : (T ^ ε) ^ p ≤ T ^ (1 / 5 : ℝ) := by
    rw [← Real.rpow_natCast, ← Real.rpow_mul (by linarith)]
    exact Real.rpow_le_rpow_of_exponent_le hT hεp
  calc Real.log T ^ p ≤ (5 * ((p : ℝ) + 1) * T ^ ε) ^ p := h1
    _ = (5 * ((p : ℝ) + 1)) ^ p * (T ^ ε) ^ p := mul_pow _ _ _
    _ ≤ _ := mul_le_mul_of_nonneg_left h2 (by positivity)

/-- The powers of `T`: `T Δ^(−2r) (T^θ)^(2r+2) (2T)^(r+4/5) ≤ 2^(r+4/5) L^(2r) T^(4/5)`,
`Δ = T/L`, when `r(1 − 2θ) ≥ 2` and `θ < 1/2`. -/
theorem Tpow_le {θ : ℝ} (hθ : θ < 1 / 2) {r : ℕ} (hr : 2 ≤ (r : ℝ) * (1 - 2 * θ)) {T L Mr : ℝ}
    (hT : 1 ≤ T) (hL : 0 < L) (hM0 : 0 ≤ Mr) (hM : Mr ≤ T ^ θ) :
    T * ((T / L) ^ (2 * r))⁻¹ * Mr ^ (2 * r + 2) * (2 * T) ^ ((r : ℝ) + 4 / 5) ≤
      (2 : ℝ) ^ ((r : ℝ) + 4 / 5) * L ^ (2 * r) * T ^ (4 / 5 : ℝ) := by
  have hT0 : 0 < T := by linarith
  have e1 : ((T / L) ^ (2 * r))⁻¹ = L ^ (2 * r) * T ^ (-((2 * r : ℕ) : ℝ)) := by
    rw [div_pow, inv_div, Real.rpow_neg hT0.le, Real.rpow_natCast, div_eq_mul_inv]
  have h2 : Mr ^ (2 * r + 2) ≤ T ^ (θ * ((2 * r + 2 : ℕ) : ℝ)) := by
    rw [Real.rpow_mul hT0.le, Real.rpow_natCast]
    exact pow_le_pow_left₀ hM0 hM _
  have e3 : (2 * T) ^ ((r : ℝ) + 4 / 5) = (2 : ℝ) ^ ((r : ℝ) + 4 / 5) * T ^ ((r : ℝ) + 4 / 5) :=
    Real.mul_rpow (by norm_num) hT0.le
  set E : ℝ := 1 + -((2 * r : ℕ) : ℝ) + θ * ((2 * r + 2 : ℕ) : ℝ) + ((r : ℝ) + 4 / 5) with hE
  have e4 : T * T ^ (-((2 * r : ℕ) : ℝ)) * T ^ (θ * ((2 * r + 2 : ℕ) : ℝ)) *
      T ^ ((r : ℝ) + 4 / 5) = T ^ E := by
    rw [hE, Real.rpow_add hT0 _ ((r : ℝ) + 4 / 5), Real.rpow_add hT0 _ (θ * ((2 * r + 2 : ℕ) : ℝ)),
      Real.rpow_add hT0 1, Real.rpow_one]
  have hE45 : E ≤ 4 / 5 := by
    have : E = 9 / 5 + 2 * θ - (r : ℝ) * (1 - 2 * θ) := by
      rw [hE]
      push_cast
      ring
    rw [this]
    linarith
  have h5 : T ^ E ≤ T ^ (4 / 5 : ℝ) := Real.rpow_le_rpow_of_exponent_le hT hE45
  have hTn : 0 ≤ T ^ (-((2 * r : ℕ) : ℝ)) := by positivity
  rw [e1, e3]
  calc T * (L ^ (2 * r) * T ^ (-((2 * r : ℕ) : ℝ))) * Mr ^ (2 * r + 2) *
        ((2 : ℝ) ^ ((r : ℝ) + 4 / 5) * T ^ ((r : ℝ) + 4 / 5)) ≤
      T * (L ^ (2 * r) * T ^ (-((2 * r : ℕ) : ℝ))) * T ^ (θ * ((2 * r + 2 : ℕ) : ℝ)) *
        ((2 : ℝ) ^ ((r : ℝ) + 4 / 5) * T ^ ((r : ℝ) + 4 / 5)) := by
        apply mul_le_mul_of_nonneg_right _ (by positivity)
        exact mul_le_mul_of_nonneg_left h2 (by positivity)
    _ = (2 : ℝ) ^ ((r : ℝ) + 4 / 5) * L ^ (2 * r) * (T * T ^ (-((2 * r : ℕ) : ℝ)) *
          T ^ (θ * ((2 * r + 2 : ℕ) : ℝ)) * T ^ ((r : ℝ) + 4 / 5)) := by ring
    _ = (2 : ℝ) ^ ((r : ℝ) + 4 / 5) * L ^ (2 * r) * T ^ E := by rw [e4]
    _ ≤ _ := mul_le_mul_of_nonneg_left h5 (by positivity)

/-- **The size of the summed bound.** For `θ < 1/2` and `r(1 − 2θ) ≥ 2` there is `C` with
`(1 + κ²L²) T Δ^(−2r) M^(2r+2) (2T)^(r+4/5) ≤ C T/L` for `T ≥ e`, `0 ≤ M ≤ T^θ`, `L = log T`,
`Δ = T/L`. -/
theorem final_size {θ : ℝ} (hθ : θ < 1 / 2) {r : ℕ} (hr : 2 ≤ (r : ℝ) * (1 - 2 * θ)) (κ : ℝ) :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ T : ℝ, Real.exp 1 ≤ T → ∀ Mr : ℝ, 0 ≤ Mr → Mr ≤ T ^ θ →
      (1 + κ ^ 2 * Real.log T ^ 2) * T * ((T / Real.log T) ^ (2 * r))⁻¹ * Mr ^ (2 * r + 2) *
        (2 * T) ^ ((r : ℝ) + 4 / 5) ≤ C * (T / Real.log T) := by
  set a : ℝ := (r : ℝ) + 4 / 5
  refine ⟨(2 : ℝ) ^ a * (1 + κ ^ 2) * (5 * (((2 * r + 3 : ℕ) : ℝ) + 1)) ^ (2 * r + 3),
    by positivity, fun T hT Mr hM0 hM => ?_⟩
  have hT1 : 1 ≤ T := le_trans (by linarith [Real.add_one_le_exp (1 : ℝ)]) hT
  have hT0 : 0 < T := by linarith
  set L : ℝ := Real.log T with hLdef
  have hL1 : 1 ≤ L := by
    rw [hLdef, ← Real.log_exp 1]
    exact Real.log_le_log (Real.exp_pos 1) hT
  have hL0 : 0 < L := by linarith
  have h1 := Tpow_le hθ hr hT1 hL0 hM0 hM
  have hN : 1 + κ ^ 2 * L ^ 2 ≤ (1 + κ ^ 2) * L ^ 2 := by nlinarith [sq_nonneg κ]
  have hlog := logpow_le (2 * r + 3) hT1
  rw [← hLdef] at hlog
  set G : ℝ := (5 * (((2 * r + 3 : ℕ) : ℝ) + 1)) ^ (2 * r + 3) with hG
  have hG0 : 0 ≤ G := by positivity
  have hTT : T ^ (1 / 5 : ℝ) * T ^ (4 / 5 : ℝ) = T := by
    rw [← Real.rpow_add hT0]
    norm_num
  have hlhs : (1 + κ ^ 2 * L ^ 2) * T * ((T / L) ^ (2 * r))⁻¹ * Mr ^ (2 * r + 2) * (2 * T) ^ a ≤
      (2 : ℝ) ^ a * (1 + κ ^ 2) * L ^ (2 * r + 2) * T ^ (4 / 5 : ℝ) := by
    calc (1 + κ ^ 2 * L ^ 2) * T * ((T / L) ^ (2 * r))⁻¹ * Mr ^ (2 * r + 2) * (2 * T) ^ a =
          (1 + κ ^ 2 * L ^ 2) * (T * ((T / L) ^ (2 * r))⁻¹ * Mr ^ (2 * r + 2) * (2 * T) ^ a) := by
          ring
      _ ≤ ((1 + κ ^ 2) * L ^ 2) * ((2 : ℝ) ^ a * L ^ (2 * r) * T ^ (4 / 5 : ℝ)) :=
          mul_le_mul hN h1 (by positivity) (by positivity)
      _ = _ := by ring
  rw [← mul_div_assoc, le_div_iff₀ hL0]
  calc (1 + κ ^ 2 * L ^ 2) * T * ((T / L) ^ (2 * r))⁻¹ * Mr ^ (2 * r + 2) * (2 * T) ^ a * L ≤
        (2 : ℝ) ^ a * (1 + κ ^ 2) * L ^ (2 * r + 2) * T ^ (4 / 5 : ℝ) * L :=
        mul_le_mul_of_nonneg_right hlhs hL0.le
    _ = (2 : ℝ) ^ a * (1 + κ ^ 2) * T ^ (4 / 5 : ℝ) * L ^ (2 * r + 3) := by ring
    _ ≤ (2 : ℝ) ^ a * (1 + κ ^ 2) * T ^ (4 / 5 : ℝ) * (G * T ^ (1 / 5 : ℝ)) :=
        mul_le_mul_of_nonneg_left hlog (by positivity)
    _ = (2 : ℝ) ^ a * (1 + κ ^ 2) * G * (T ^ (1 / 5 : ℝ) * T ^ (4 / 5 : ℝ)) := by ring
    _ = _ := by rw [hTT]

/-- **The off-diagonal statement over `WeightAll`.** `StmtOffDiag` with the weight carrying (2.3)
for every `j`, its constants bounded by a family `Cs` fixed before `T`:
`offSum = O(T/L)`, the constant depending on `Cs` (and `P`, `θ`, `R`, `κ`). -/
noncomputable
def StmtOffDiagAll (P : Polynomial ℝ) (θ R κ : ℝ) : Prop :=
  ∀ Cs : ℕ → ℝ, ∃ C T₀ : ℝ, 0 ≤ C ∧ ∀ T : ℝ, T₀ ≤ T → ∀ W : WeightAll T (Real.log T),
    (∀ j, W.Cj j ≤ Cs j) → ∀ α β : ℂ, Regime κ T α β →
      ‖offSum W.toWeight (Mof T θ) (aY P T θ R) (sig0 T R) α β 1‖ ≤ C * errY W.toWeight

/-- The number of integrations by parts: `r = ⌈2/(1 − 2θ)⌉₊`, so `r(1 − 2θ) ≥ 2`. -/
theorem r_choice {θ : ℝ} (hθ : θ < 1 / 2) :
    2 ≤ ((⌈2 / (1 - 2 * θ)⌉₊ : ℕ) : ℝ) * (1 - 2 * θ) := by
  have hg : 0 < 1 - 2 * θ := by linarith
  have := Nat.le_ceil (2 / (1 - 2 * θ))
  calc (2 : ℝ) = 2 / (1 - 2 * θ) * (1 - 2 * θ) := by
        field_simp
        try ring
    _ ≤ _ := mul_le_mul_of_nonneg_right this hg.le

/-- `N = 1 + ‖α+β‖^(−2) ≤ 1 + κ² L²` on the range. -/
theorem N_le {κ T : ℝ} (hκ : 0 < κ) (hL : 0 < Real.log T) {α β : ℂ} (h : Regime κ T α β) :
    1 + 1 / ‖α + β‖ ^ 2 ≤ 1 + κ ^ 2 * Real.log T ^ 2 := by
  obtain ⟨_, _, h3⟩ := h
  have hq : 0 < 1 / (κ * Real.log T) := by positivity
  have hn : 0 < ‖α + β‖ := lt_of_lt_of_le hq h3
  have h4 : 1 / ‖α + β‖ ≤ κ * Real.log T := by
    rw [div_le_iff₀ hn]
    rw [div_le_iff₀ (by positivity)] at h3
    linarith
  have h5 : (1 / ‖α + β‖) ^ 2 ≤ (κ * Real.log T) ^ 2 := pow_le_pow_left₀ (by positivity) h4 2
  rw [div_pow, one_pow, mul_pow] at h5
  linarith

/-- **`StmtOffDiag` closed, every `θ < 1/2`**, in the `WeightAll` form: Young's off-diagonal
`offSum = O(T/L)` with `j = 2r`, `r = ⌈2/(1−2θ)⌉₊`, integrations by parts. -/
theorem stmtOffDiag_holds (P : Polynomial ℝ) {θ : ℝ} (hθ : θ < 1 / 2) (R : ℝ) {κ : ℝ}
    (hκ : 0 < κ) : StmtOffDiagAll P θ R κ := by
  intro Cs
  set r : ℕ := ⌈2 / (1 - 2 * θ)⌉₊ with hr
  have hrg := r_choice hθ
  rw [← hr] at hrg
  obtain ⟨K, hK0, hK⟩ := offSum_bound_iter r
  obtain ⟨B, hB0, hB⟩ := aY_bound P
  obtain ⟨C0, hC00, hC0⟩ := final_size hθ hrg κ
  set Wc : ℝ := 1 + ∑ i ∈ Finset.range (2 * r + 1), max (Cs i) 0 with hWc
  have hWc0 : 0 ≤ Wc := by
    have := Finset.sum_nonneg fun i (_ : i ∈ Finset.range (2 * r + 1)) => le_max_right (Cs i) 0
    linarith
  refine ⟨K * Wc * B ^ 2 * C0, max (max 8 (Real.exp 1)) (Real.exp (10 * κ)), by positivity,
    fun T hT W hW α β hreg => ?_⟩
  have hT8 : 8 ≤ T := le_trans (le_trans (le_max_left _ _) (le_max_left _ _)) hT
  have hTe : Real.exp 1 ≤ T := le_trans (le_trans (le_max_right _ _) (le_max_left _ _)) hT
  have hTk : Real.exp (10 * κ) ≤ T := le_trans (le_max_right _ _) hT
  have hT0 : 0 < T := by linarith
  obtain ⟨hα, hβ, hαβ, hL0⟩ := hreg.small hκ hTk
  have hL1 : 1 ≤ Real.log T := by
    rw [← Real.log_exp 1]
    exact Real.log_le_log (Real.exp_pos 1) hTe
  have hb := hK T (Real.log T) W hT8 hL1 (Mof T θ) (aY P T θ R) (sig0 T R) B hB0
    (fun h hh hhM => hB T θ R h hh hhM) α β hα hβ hαβ 1 one_pos
  have hws : wsum W (2 * r) ≤ Wc := by
    unfold wsum
    rw [hWc]
    have := Finset.sum_le_sum fun i (_ : i ∈ Finset.range (2 * r + 1)) =>
      (hW i).trans (le_max_left (Cs i) 0)
    linarith
  have hM0 : (0 : ℝ) ≤ (Mof T θ : ℝ) := Nat.cast_nonneg _
  have hMle : ((Mof T θ : ℕ) : ℝ) ≤ T ^ θ :=
    Nat.floor_le (Real.rpow_nonneg hT0.le θ)
  have hsize := hC0 T hTe (Mof T θ) hM0 hMle
  have hN := N_le hκ hL0 hreg
  have hN0 : 0 ≤ 1 + 1 / ‖α + β‖ ^ 2 := by positivity
  set X : ℝ := T * ((T / Real.log T) ^ (2 * r))⁻¹ * (Mof T θ : ℝ) ^ (2 * r + 2) *
    (2 * T) ^ ((r : ℝ) + 4 / 5) with hX
  have hX0 : 0 ≤ X := by
    have : 0 < T / Real.log T := div_pos hT0 hL0
    positivity
  have herr : T / Real.log T ≤ errY W.toWeight := by
    unfold errY
    have := W.C1_nonneg
    have := W.C2_nonneg
    have : 0 ≤ T / Real.log T := div_nonneg hT0.le hL0.le
    nlinarith
  have hsize' : (1 + κ ^ 2 * Real.log T ^ 2) * X ≤ C0 * (T / Real.log T) := by
    rw [hX]
    calc _ = _ := by ring
      _ ≤ _ := hsize
  calc ‖offSum W.toWeight (Mof T θ) (aY P T θ R) (sig0 T R) α β 1‖ ≤ _ := hb
    _ = K * wsum W (2 * r) * B ^ 2 * ((1 + 1 / ‖α + β‖ ^ 2) * X) := by rw [hX]; ring
    _ ≤ K * Wc * B ^ 2 * ((1 + κ ^ 2 * Real.log T ^ 2) * X) := by
        apply mul_le_mul _ (mul_le_mul_of_nonneg_right hN hX0) (by positivity) (by positivity)
        apply mul_le_mul_of_nonneg_right _ (by positivity)
        exact mul_le_mul_of_nonneg_left hws hK0
    _ ≤ K * Wc * B ^ 2 * (C0 * (T / Real.log T)) :=
        mul_le_mul_of_nonneg_left hsize' (by positivity)
    _ ≤ K * Wc * B ^ 2 * (C0 * errY W.toWeight) :=
        mul_le_mul_of_nonneg_left (mul_le_mul_of_nonneg_left herr hC00) (by positivity)
    _ = K * Wc * B ^ 2 * C0 * errY W.toWeight := by ring

/-! ## Axiom pins -/

/-- info: 'OffDiagClose.phi_iter_bdd' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms phi_iter_bdd

/-- info: 'OffDiagClose.winY_iter_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms winY_iter_le

/-- info: 'OffDiagClose.weightAll_exists' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms weightAll_exists

/-- info: 'OffDiagClose.VY_iter_bound0' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms VY_iter_bound0

/-- info: 'OffDiagClose.Fw_iter_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Fw_iter_bound

/-- info: 'OffDiagClose.offdiag_term_iter' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms offdiag_term_iter

/-- info: 'OffDiagClose.offdiag_term_iter_young' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms offdiag_term_iter_young

/-- info: 'OffDiagClose.decay_trade' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms decay_trade

/-- info: 'OffDiagClose.off_term_iter_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms off_term_iter_le

/-- info: 'OffDiagClose.offSum_bound_iter' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms offSum_bound_iter

/-- info: 'OffDiagClose.aY_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms aY_bound

/-- info: 'OffDiagClose.logpow_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms logpow_le

/-- info: 'OffDiagClose.Tpow_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Tpow_le

/-- info: 'OffDiagClose.final_size' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms final_size

/-- info: 'OffDiagClose.stmtOffDiag_holds' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms stmtOffDiag_holds

end OffDiagClose
