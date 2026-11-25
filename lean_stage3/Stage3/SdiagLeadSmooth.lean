/-
# Stage3.SdiagLeadSmooth — the smooth Möbius sum to `o(1/log M)`, real `x`. 2026-11-25.

Step 2 of the route in `Stage3/DiagMain.lean`'s docstring, at one `d`: for `P(0) = 0`,
`Σ_{n ≤ x} μ(n) P(log(x/n)/λ) n^{−(1+β)} = βP(log x/λ) + P′(log x/λ)/λ + o(1/λ)`, uniformly for
`Y ≤ x`, `log x ≤ λ`, `‖β‖λ ≤ A` (`muSmoothR`), and `O(1/λ)` for every `1 ≤ x` (`muSmooth_crude`).

Route. `n^{−β} = x^{−β} e^{β log(x/n)}` and `G(u) = e^{βu} P(u/λ)` (`Gp`), `G(0) = 0`. Taylor with
the integral remainder, written over `[1, x]` with the kernel `max(log(s/n), 0)/s`
(`taylor_n`): `G(log(x/n)) = log(x/n) G′(0) + ∫₁^x G″(log(x/s)) max(log(s/n),0) ds/s`.
Summed against `μ(n)/n` (`sum_taylor`), the kernel becomes `Ψ(s) = ψ_μ(s)` for `s ≤ x`
(`Psi_eq`), and with `∫₁^x G″(log(x/s)) ds/s = G′(log x) − G′(0)` (`ftc_G1`):
`Σ μ(n)/n G(log(x/n)) − G′(log x) = G′(0)(ψ_μ(x) − 1) + ∫₁^x G″(log(x/s))(ψ_μ(s) − 1) ds/s`
(`err_identity`). `‖G″‖ ≤ K/λ²` on `[0, λ]` (`G2_bound`), `G′(0) = P′(0)/λ`, and
`ψ_μ(s) → 1` (`psiMu_tendsto`, `mMu_tendsto`, through `psiR_eq`) give
`‖err‖ ≤ e^A (|P′(0)|/λ |ψ_μ(x) − 1| + K/λ² (B log s₀ + ε log x))` (`err_bound`): this is
`o(1/λ)`, the size the lost-factor check in `DiagMain` asks for. No factor growing with `λ` is
lost: `log x ≤ λ` costs exactly the `1/λ` that `G″ = O(1/λ²)` pays for.

| name | content | status |
|---|---|---|
| `Gp`, `G1`, `G2`, `Psi`, `psiR` | `e^{βu}p(u/λ)`; `G′`; `G″`; `Σ_{n ≤ x} μ(n)/n max(log(s/n),0)`; `ψ_μ(s)`, real `s` | def |
| `Gp_hasDerivAt`, `G1_hasDerivAt` | the derivatives | proved |
| `taylor_n`, `sum_taylor`, `ftc_G1`, `err_identity` | the exact identities | proved |
| `G2_bound`, `int_piece`, `err_bound` | the sizes | proved |
| `psiR_eq`, `psiR_tendsto`, `psiR_bdd`, `Psi_eq` | `ψ_μ(s) = ψ_μ(⌊s⌋) + m(⌊s⌋) log(s/⌊s⌋) → 1` | proved |
| `sum_cpow_eq` | the `n^{−(1+β)}` sum is `x^{−β} Σ μ(n)/n G(log(x/n))` | proved |
| `muSmoothR`, `muSmooth_crude` | the per-`d` step, `o(1/λ)` for `x ≥ Y`; `O(1/λ)` for `x ≥ 1` | proved |
| `stmtMuSmooth_holds` | `DiagMain.StmtMuSmooth P κ` | proved |

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Stage3.SdiagLeadSwap

namespace SdiagLead

open Complex Finset Filter Topology MeasureTheory DiagMain
open scoped ArithmeticFunction.Moebius

noncomputable section

/-! ## The function `G(u) = e^{βu} P(u/λ)` and its derivatives -/

/-- `G_p(u) = e^{βu} p(u/λ)`. -/
def Gp (p : Polynomial ℝ) (β : ℂ) (lM u : ℝ) : ℂ := cexp (β * u) * ((p.eval (u / lM) : ℝ) : ℂ)

theorem Gp_hasDerivAt (p : Polynomial ℝ) (β : ℂ) (lM u : ℝ) :
    HasDerivAt (Gp p β lM) (β * Gp p β lM u + (lM : ℂ)⁻¹ * Gp p.derivative β lM u) u := by
  have h1 : HasDerivAt (fun u : ℝ => cexp (β * u)) (cexp (β * u) * β) u := by
    have := ((hasDerivAt_id u).ofReal_comp.const_mul β).cexp
    simpa using this
  have h2 : HasDerivAt (fun u : ℝ => ((p.eval (u / lM) : ℝ) : ℂ))
      ((p.derivative.eval (u / lM) * (1 / lM) : ℝ) : ℂ) u := by
    have := (p.hasDerivAt (u / lM)).comp u ((hasDerivAt_id u).div_const lM)
    exact this.ofReal_comp
  refine (h1.mul h2).congr_deriv ?_
  unfold Gp
  push_cast
  ring

theorem Gp_continuous (p : Polynomial ℝ) (β : ℂ) (lM : ℝ) : Continuous (Gp p β lM) :=
  continuous_iff_continuousAt.mpr fun u => (Gp_hasDerivAt p β lM u).continuousAt

/-- `G′`. -/
def G1 (P : Polynomial ℝ) (β : ℂ) (lM u : ℝ) : ℂ :=
  β * Gp P β lM u + (lM : ℂ)⁻¹ * Gp P.derivative β lM u

/-- `G″`. -/
def G2 (P : Polynomial ℝ) (β : ℂ) (lM u : ℝ) : ℂ :=
  β * (β * Gp P β lM u + (lM : ℂ)⁻¹ * Gp P.derivative β lM u) +
    (lM : ℂ)⁻¹ * (β * Gp P.derivative β lM u + (lM : ℂ)⁻¹ * Gp P.derivative.derivative β lM u)

theorem G1_hasDerivAt (P : Polynomial ℝ) (β : ℂ) (lM u : ℝ) :
    HasDerivAt (G1 P β lM) (G2 P β lM u) u :=
  ((Gp_hasDerivAt P β lM u).const_mul β).add ((Gp_hasDerivAt P.derivative β lM u).const_mul _)

theorem G2_continuous (P : Polynomial ℝ) (β : ℂ) (lM : ℝ) : Continuous (G2 P β lM) := by
  unfold G2
  have := Gp_continuous P β lM
  have := Gp_continuous P.derivative β lM
  have := Gp_continuous P.derivative.derivative β lM
  fun_prop

theorem G1_continuous (P : Polynomial ℝ) (β : ℂ) (lM : ℝ) : Continuous (G1 P β lM) :=
  continuous_iff_continuousAt.mpr fun u => (G1_hasDerivAt P β lM u).continuousAt

theorem Gp_zero (P : Polynomial ℝ) (hP0 : P.eval 0 = 0) (β : ℂ) (lM : ℝ) : Gp P β lM 0 = 0 := by
  simp [Gp, hP0]

/-! ## `log(x/s)` -/

theorem hasDerivAt_logdiv {x s : ℝ} (hx : 0 < x) (hs : 0 < s) :
    HasDerivAt (fun t : ℝ => Real.log (x / t)) (-s⁻¹) s := by
  have h := (Real.hasDerivAt_log hs.ne').const_sub (Real.log x)
  refine h.congr_of_eventuallyEq ?_
  filter_upwards [eventually_gt_nhds hs] with t ht
  rw [Real.log_div hx.ne' ht.ne']

theorem hasDerivAt_logdiv' {n s : ℝ} (hn : 0 < n) (hs : 0 < s) :
    HasDerivAt (fun t : ℝ => Real.log (t / n)) s⁻¹ s := by
  have h := (Real.hasDerivAt_log hs.ne').sub_const (Real.log n)
  refine h.congr_of_eventuallyEq ?_
  filter_upwards [eventually_gt_nhds hs] with t ht
  rw [Real.log_div ht.ne' hn.ne']

/-- The real kernel `max(log(s/n), 0)/s` is continuous at `s > 0`. -/
theorem kernel_continuousAt {n : ℝ} (hn : 0 < n) {s : ℝ} (hs : 0 < s) :
    ContinuousAt (fun t : ℝ => max (Real.log (t / n)) 0 / t) s := by
  have h1 : ContinuousAt (fun t : ℝ => Real.log (t / n)) s :=
    (hasDerivAt_logdiv' hn hs).continuousAt
  exact (h1.max continuousAt_const).div continuousAt_id hs.ne'

theorem G2comp_continuousAt (P : Polynomial ℝ) (β : ℂ) (lM : ℝ) {x s : ℝ} (hx : 0 < x)
    (hs : 0 < s) : ContinuousAt (fun t : ℝ => G2 P β lM (Real.log (x / t))) s :=
  (G2_continuous P β lM).continuousAt.comp (hasDerivAt_logdiv hx hs).continuousAt

/-- `Ψ(s)/s` is continuous at `s > 0`. -/
theorem Psi_div_continuousAt (c : ℕ → ℝ) (x : ℝ) {s : ℝ} (hs : 0 < s) :
    ContinuousAt (fun t => (∑ n ∈ Ioc 0 ⌊x⌋₊, c n * max (Real.log (t / n)) 0) / t) s := by
  refine ContinuousAt.div ?_ continuousAt_id hs.ne'
  refine tendsto_finsetSum _ fun n hn => ?_
  obtain ⟨hn0, -⟩ := Finset.mem_Ioc.mp hn
  have hn0' : (0 : ℝ) < n := by exact_mod_cast hn0
  exact continuousAt_const.mul ((hasDerivAt_logdiv' hn0' hs).continuousAt.max continuousAt_const)

/-! ## Taylor's formula at one `n` -/

/-- `G(log(x/n)) = log(x/n) G′(0) + ∫₁^x G″(log(x/s)) max(log(s/n),0) ds/s`, `G(0) = 0`. -/
theorem taylor_n (P : Polynomial ℝ) (hP0 : P.eval 0 = 0) (β : ℂ) (lM : ℝ) {x : ℝ} {n : ℕ}
    (hn : 1 ≤ n) (hnx : (n : ℝ) ≤ x) :
    ∫ s in (1 : ℝ)..x, G2 P β lM (Real.log (x / s)) *
        ((max (Real.log (s / n)) 0 / s : ℝ) : ℂ) =
      Gp P β lM (Real.log (x / n)) - (Real.log (x / n) : ℂ) * G1 P β lM 0 := by
  have hn0 : (0 : ℝ) < n := by exact_mod_cast hn
  have hn1 : (1 : ℝ) ≤ n := by exact_mod_cast hn
  have hx0 : 0 < x := lt_of_lt_of_le hn0 hnx
  set f : ℝ → ℂ := fun s => G2 P β lM (Real.log (x / s)) *
    ((max (Real.log (s / n)) 0 / s : ℝ) : ℂ) with hf
  have hcont : ∀ a b : ℝ, 1 ≤ a → 1 ≤ b → IntervalIntegrable f volume a b := by
    intro a b ha hb
    refine ContinuousOn.intervalIntegrable fun s hs => ?_
    have hs1 : 1 ≤ s := by
      rcases Set.mem_uIcc.mp hs with h | h <;> linarith [h.1]
    have hs0 : 0 < s := by linarith
    exact ((G2comp_continuousAt P β lM hx0 hs0).mul
      (Complex.continuous_ofReal.continuousAt.comp (kernel_continuousAt hn0 hs0))).continuousWithinAt
  rw [← intervalIntegral.integral_add_adjacent_intervals (hcont 1 n le_rfl hn1)
    (hcont n x hn1 (le_trans hn1 hnx))]
  have hz : ∫ s in (1 : ℝ)..n, f s = 0 := by
    rw [intervalIntegral.integral_congr (g := fun _ => (0 : ℂ)), intervalIntegral.integral_zero]
    intro s hs
    rw [Set.uIcc_of_le hn1] at hs
    have hs0 : 0 < s := by linarith [hs.1]
    have hl : Real.log (s / n) ≤ 0 :=
      Real.log_nonpos (by positivity) ((div_le_one hn0).mpr hs.2)
    simp only [hf, max_eq_right hl, zero_div, Complex.ofReal_zero, mul_zero]
  rw [hz, zero_add]
  set H : ℝ → ℂ := fun s => -(G1 P β lM (Real.log (x / s)) * (Real.log (s / n) : ℂ)) -
    Gp P β lM (Real.log (x / s)) with hH
  have hderiv : ∀ s ∈ Set.uIcc (n : ℝ) x, HasDerivAt H (f s) s := by
    intro s hs
    rw [Set.uIcc_of_le hnx] at hs
    have hs0 : 0 < s := by linarith [hs.1]
    have hφ := hasDerivAt_logdiv hx0 hs0
    have hA := (G1_hasDerivAt P β lM (Real.log (x / s))).scomp s hφ
    have hB := (Gp_hasDerivAt P β lM (Real.log (x / s))).scomp s hφ
    have hC := (hasDerivAt_logdiv' hn0 hs0).ofReal_comp
    have hl : 0 ≤ Real.log (s / n) := Real.log_nonneg ((le_div_iff₀ hn0).mpr (by linarith [hs.1]))
    refine ((hA.mul hC).neg.sub hB).congr_deriv ?_
    simp only [hf, max_eq_left hl, Function.comp_apply, G1, real_smul]
    push_cast
    field_simp
    ring
  rw [intervalIntegral.integral_eq_sub_of_hasDerivAt hderiv (hcont n x hn1 (le_trans hn1 hnx))]
  simp only [hH, div_self hx0.ne', Real.log_one, Complex.ofReal_zero, mul_zero, neg_zero,
    zero_sub, Gp_zero P hP0, sub_zero, div_self hn0.ne']
  ring

/-- `Ψ(s) = Σ_{n ≤ x} c_n max(log(s/n), 0)`. -/
def Psi (c : ℕ → ℝ) (x s : ℝ) : ℝ :=
  ∑ n ∈ Ioc 0 ⌊x⌋₊, c n * max (Real.log (s / n)) 0

/-- Summed against `c_n`: `Σ c_n G(log(x/n)) = G′(0) Σ c_n log(x/n) + ∫₁^x G″(log(x/s)) Ψ(s) ds/s`. -/
theorem sum_taylor (P : Polynomial ℝ) (hP0 : P.eval 0 = 0) (β : ℂ) (lM : ℝ) {x : ℝ} (hx : 1 ≤ x)
    (c : ℕ → ℝ) :
    ∑ n ∈ Ioc 0 ⌊x⌋₊, (c n : ℂ) * Gp P β lM (Real.log (x / n)) =
      G1 P β lM 0 * ((∑ n ∈ Ioc 0 ⌊x⌋₊, c n * Real.log (x / n) : ℝ) : ℂ) +
        ∫ s in (1 : ℝ)..x, G2 P β lM (Real.log (x / s)) * ((Psi c x s / s : ℝ) : ℂ) := by
  have hx0 : 0 < x := by linarith
  have hterm : ∀ n ∈ Ioc 0 ⌊x⌋₊, (c n : ℂ) * Gp P β lM (Real.log (x / n)) =
      G1 P β lM 0 * ((c n * Real.log (x / n) : ℝ) : ℂ) +
        ∫ s in (1 : ℝ)..x, (c n : ℂ) * (G2 P β lM (Real.log (x / s)) *
          ((max (Real.log (s / n)) 0 / s : ℝ) : ℂ)) := by
    intro n hn
    obtain ⟨hn0, hnx⟩ := Finset.mem_Ioc.mp hn
    have hnx' : (n : ℝ) ≤ x := (Nat.le_floor_iff hx0.le).mp hnx
    rw [intervalIntegral.integral_const_mul, taylor_n P hP0 β lM hn0 hnx']
    push_cast; ring
  rw [Finset.sum_congr rfl hterm, Finset.sum_add_distrib, ← Finset.mul_sum,
    ← intervalIntegral.integral_finsetSum]
  · congr 1
    · push_cast; rfl
    · refine intervalIntegral.integral_congr fun s _ => ?_
      simp only [Psi]
      rw [Finset.sum_div, Complex.ofReal_sum, Finset.mul_sum]
      refine Finset.sum_congr rfl fun n _ => ?_
      push_cast; ring
  · intro n hn
    obtain ⟨hn0, -⟩ := Finset.mem_Ioc.mp hn
    have hn0' : (0 : ℝ) < n := by exact_mod_cast hn0
    refine ContinuousOn.intervalIntegrable fun s hs => ?_
    have hs1 : 1 ≤ s := by
      rcases Set.mem_uIcc.mp hs with h | h <;> linarith [h.1]
    have hs0 : 0 < s := by linarith
    exact (continuousAt_const.mul ((G2comp_continuousAt P β lM hx0 hs0).mul
      (Complex.continuous_ofReal.continuousAt.comp
        (kernel_continuousAt hn0' hs0)))).continuousWithinAt

/-- `∫₁^x G″(log(x/s)) ds/s = G′(log x) − G′(0)`. -/
theorem ftc_G1 (P : Polynomial ℝ) (β : ℂ) (lM : ℝ) {x : ℝ} (hx : 1 ≤ x) :
    ∫ s in (1 : ℝ)..x, G2 P β lM (Real.log (x / s)) * ((1 / s : ℝ) : ℂ) =
      G1 P β lM (Real.log x) - G1 P β lM 0 := by
  have hx0 : 0 < x := by linarith
  have hderiv : ∀ s ∈ Set.uIcc (1 : ℝ) x, HasDerivAt (fun t => -G1 P β lM (Real.log (x / t)))
      (G2 P β lM (Real.log (x / s)) * ((1 / s : ℝ) : ℂ)) s := by
    intro s hs
    rw [Set.uIcc_of_le hx] at hs
    have hs0 : 0 < s := by linarith [hs.1]
    have h := ((G1_hasDerivAt P β lM (Real.log (x / s))).scomp s (hasDerivAt_logdiv hx0 hs0)).neg
    refine h.congr_deriv ?_
    rw [Complex.real_smul]; push_cast; ring
  rw [intervalIntegral.integral_eq_sub_of_hasDerivAt hderiv]
  · show -G1 P β lM (Real.log (x / x)) - -G1 P β lM (Real.log (x / 1)) = _
    rw [div_self hx0.ne', Real.log_one, div_one]; ring
  · refine ContinuousOn.intervalIntegrable fun s hs => ?_
    have hs1 : 1 ≤ s := by
      rcases Set.mem_uIcc.mp hs with h | h <;> linarith [h.1]
    have hs0 : 0 < s := by linarith
    exact ((G2comp_continuousAt P β lM hx0 hs0).mul
      (Complex.continuous_ofReal.continuousAt.comp
        (continuousAt_const.div continuousAt_id hs0.ne'))).continuousWithinAt

/-- **The error identity**: `Σ c_n G(log(x/n)) − G′(log x) = G′(0)(Σ c_n log(x/n) − 1) +
∫₁^x G″(log(x/s)) (Ψ(s) − 1) ds/s`. -/
theorem err_identity (P : Polynomial ℝ) (hP0 : P.eval 0 = 0) (β : ℂ) (lM : ℝ) {x : ℝ}
    (hx : 1 ≤ x) (c : ℕ → ℝ) :
    ∑ n ∈ Ioc 0 ⌊x⌋₊, (c n : ℂ) * Gp P β lM (Real.log (x / n)) - G1 P β lM (Real.log x) =
      G1 P β lM 0 * ((∑ n ∈ Ioc 0 ⌊x⌋₊, c n * Real.log (x / n) - 1 : ℝ) : ℂ) +
        ∫ s in (1 : ℝ)..x, G2 P β lM (Real.log (x / s)) * (((Psi c x s - 1) / s : ℝ) : ℂ) := by
  have hx0 : 0 < x := by linarith
  have hint : ∀ g : ℝ → ℝ, (∀ s, 0 < s → ContinuousAt g s) → IntervalIntegrable
      (fun s => G2 P β lM (Real.log (x / s)) * ((g s : ℝ) : ℂ)) volume 1 x := by
    intro g hg
    refine ContinuousOn.intervalIntegrable fun s hs => ?_
    have hs1 : 1 ≤ s := by
      rcases Set.mem_uIcc.mp hs with h | h <;> linarith [h.1]
    have hs0 : 0 < s := by linarith
    exact ((G2comp_continuousAt P β lM hx0 hs0).mul
      (Complex.continuous_ofReal.continuousAt.comp (hg s hs0))).continuousWithinAt
  have hPsi : ∀ s, 0 < s → ContinuousAt (fun t => Psi c x t / t) s :=
    fun s hs => Psi_div_continuousAt c x hs
  have hone : ∀ s, 0 < s → ContinuousAt (fun t : ℝ => 1 / t) s :=
    fun s hs => continuousAt_const.div continuousAt_id hs.ne'
  have e1 := sum_taylor P hP0 β lM hx c
  have e2 := ftc_G1 P β lM hx
  have hsplit : ∫ s in (1 : ℝ)..x, G2 P β lM (Real.log (x / s)) *
      (((Psi c x s - 1) / s : ℝ) : ℂ) =
      (∫ s in (1 : ℝ)..x, G2 P β lM (Real.log (x / s)) * ((Psi c x s / s : ℝ) : ℂ)) -
        ∫ s in (1 : ℝ)..x, G2 P β lM (Real.log (x / s)) * ((1 / s : ℝ) : ℂ) := by
    rw [← intervalIntegral.integral_sub (hint _ hPsi) (hint _ hone)]
    refine intervalIntegral.integral_congr fun s _ => ?_
    push_cast; ring
  rw [hsplit, e1, e2]
  push_cast; ring

/-! ## The sizes -/

/-- `‖e^{βu} p(u/λ)‖ ≤ e^A B_p` on `0 ≤ u ≤ λ`, `‖β‖λ ≤ A`. -/
theorem Gp_bound (p : Polynomial ℝ) : ∃ B : ℝ, 0 ≤ B ∧ ∀ (A : ℝ) (β : ℂ) (lM u : ℝ), 0 < lM →
    ‖β‖ * lM ≤ A → 0 ≤ u → u ≤ lM → ‖Gp p β lM u‖ ≤ Real.exp A * B := by
  obtain ⟨B, hB⟩ := (isCompact_Icc (a := (0 : ℝ)) (b := 1)).exists_bound_of_continuousOn
    (p.continuous.continuousOn (s := Set.Icc 0 1))
  have hB0 : 0 ≤ B := le_trans (norm_nonneg _) (hB 0 ⟨le_refl _, zero_le_one⟩)
  refine ⟨B, hB0, fun A β lM u hlM hβ hu0 hu => ?_⟩
  unfold Gp
  rw [norm_mul, Complex.norm_real]
  have h1 : ‖cexp (β * u)‖ ≤ Real.exp A := by
    rw [Complex.norm_exp]
    refine Real.exp_le_exp.mpr ?_
    have : (β * (u : ℂ)).re ≤ ‖β * (u : ℂ)‖ := Complex.re_le_norm _
    rw [norm_mul, Complex.norm_real, Real.norm_eq_abs, abs_of_nonneg hu0] at this
    have : ‖β‖ * u ≤ ‖β‖ * lM := mul_le_mul_of_nonneg_left hu (norm_nonneg _)
    linarith
  have h2 : ‖p.eval (u / lM)‖ ≤ B :=
    hB _ ⟨div_nonneg hu0 hlM.le, (div_le_one hlM).mpr hu⟩
  exact mul_le_mul h1 h2 (norm_nonneg _) (Real.exp_pos _).le

/-- `‖G″(u)‖ ≤ K/λ²` on `0 ≤ u ≤ λ`. -/
theorem G2_bound (P : Polynomial ℝ) {A : ℝ} (hA : 0 ≤ A) : ∃ K : ℝ, 0 ≤ K ∧ ∀ (β : ℂ) (lM u : ℝ),
    0 < lM → ‖β‖ * lM ≤ A → 0 ≤ u → u ≤ lM → ‖G2 P β lM u‖ ≤ K / lM ^ 2 := by
  obtain ⟨B0, hB0, h0⟩ := Gp_bound P
  obtain ⟨B1, hB1, h1⟩ := Gp_bound P.derivative
  obtain ⟨B2, hB2, h2⟩ := Gp_bound P.derivative.derivative
  refine ⟨Real.exp A * (A ^ 2 * B0 + 2 * A * B1 + B2), by positivity,
    fun β lM u hlM hβ hu0 hu => ?_⟩
  have g0 := h0 A β lM u hlM hβ hu0 hu
  have g1 := h1 A β lM u hlM hβ hu0 hu
  have g2 := h2 A β lM u hlM hβ hu0 hu
  have hb : ‖β‖ ≤ A / lM := by rw [le_div_iff₀ hlM]; exact hβ
  have hinv : ‖((lM : ℂ))⁻¹‖ = 1 / lM := by
    rw [norm_inv, Complex.norm_real, Real.norm_eq_abs, abs_of_pos hlM, one_div]
  have e : G2 P β lM u = β ^ 2 * Gp P β lM u + 2 * β * (lM : ℂ)⁻¹ * Gp P.derivative β lM u +
      ((lM : ℂ)⁻¹) ^ 2 * Gp P.derivative.derivative β lM u := by unfold G2; ring
  rw [e]
  refine le_trans (norm_add_le _ _) ?_
  refine le_trans (add_le_add_left (norm_add_le _ _) _) ?_
  rw [norm_mul, norm_mul, norm_mul, norm_mul, norm_mul, norm_pow, norm_pow, hinv]
  have hE := Real.exp_pos A
  have hb0 : 0 ≤ ‖β‖ := norm_nonneg _
  have t0 : ‖β‖ ^ 2 * ‖Gp P β lM u‖ ≤ (A / lM) ^ 2 * (Real.exp A * B0) :=
    mul_le_mul (pow_le_pow_left₀ hb0 hb 2) g0 (norm_nonneg _) (by positivity)
  have t1 : ‖(2 : ℂ)‖ * ‖β‖ * (1 / lM) * ‖Gp P.derivative β lM u‖ ≤
      2 * (A / lM) * (1 / lM) * (Real.exp A * B1) := by
    rw [show ‖(2 : ℂ)‖ = 2 by norm_num]
    have : 2 * ‖β‖ * (1 / lM) ≤ 2 * (A / lM) * (1 / lM) := by
      have := mul_le_mul_of_nonneg_left hb (by norm_num : (0 : ℝ) ≤ 2)
      exact mul_le_mul_of_nonneg_right this (by positivity)
    exact mul_le_mul this g1 (norm_nonneg _) (by positivity)
  have t2 : (1 / lM) ^ 2 * ‖Gp P.derivative.derivative β lM u‖ ≤
      (1 / lM) ^ 2 * (Real.exp A * B2) := mul_le_mul_of_nonneg_left g2 (by positivity)
  have : (A / lM) ^ 2 * (Real.exp A * B0) + 2 * (A / lM) * (1 / lM) * (Real.exp A * B1) +
      (1 / lM) ^ 2 * (Real.exp A * B2) = Real.exp A * (A ^ 2 * B0 + 2 * A * B1 + B2) / lM ^ 2 := by
    field_simp
  linarith

/-- One piece of the remainder integral: `|Ψ − 1| ≤ C` on `[a, b] ⊆ [1, x]` gives
`≤ K/λ² · C · log(b/a)`. -/
theorem int_piece (P : Polynomial ℝ) {A K : ℝ}
    (hK : ∀ (β : ℂ) (lM u : ℝ), 0 < lM → ‖β‖ * lM ≤ A → 0 ≤ u → u ≤ lM →
      ‖G2 P β lM u‖ ≤ K / lM ^ 2) (hK0 : 0 ≤ K)
    (β : ℂ) {lM : ℝ} (hlM : 0 < lM) (hβ : ‖β‖ * lM ≤ A) {x : ℝ} (hxl : Real.log x ≤ lM)
    (Ψ : ℝ → ℝ) {a b C : ℝ} (ha : 1 ≤ a) (hab : a ≤ b) (hbx : b ≤ x)
    (hC : ∀ s, a ≤ s → s ≤ b → |Ψ s - 1| ≤ C) :
    ‖∫ s in a..b, G2 P β lM (Real.log (x / s)) * (((Ψ s - 1) / s : ℝ) : ℂ)‖ ≤
      K / lM ^ 2 * C * Real.log (b / a) := by
  have ha0 : 0 < a := by linarith
  have hC0 : 0 ≤ C := le_trans (abs_nonneg _) (hC a le_rfl hab)
  have hint : ∫ s in a..b, K / lM ^ 2 * C * (1 / s) = K / lM ^ 2 * C * Real.log (b / a) := by
    rw [intervalIntegral.integral_const_mul, integral_one_div_of_pos ha0 (by linarith)]
  rw [← hint]
  refine intervalIntegral.norm_integral_le_of_norm_le hab (Eventually.of_forall fun s hs => ?_) ?_
  · have hs0 : 0 < s := by linarith [hs.1]
    have hu0 : 0 ≤ Real.log (x / s) :=
      Real.log_nonneg ((le_div_iff₀ hs0).mpr (by linarith [hs.2]))
    have hu1 : Real.log (x / s) ≤ lM := by
      have : Real.log (x / s) ≤ Real.log x := by
        rw [Real.log_div (by linarith [hs.2]) hs0.ne']
        linarith [Real.log_nonneg (by linarith [hs.1] : (1 : ℝ) ≤ s)]
      linarith
    have hG := hK β lM _ hlM hβ hu0 hu1
    rw [norm_mul, Complex.norm_real, Real.norm_eq_abs, abs_div, abs_of_pos hs0]
    have hc := hC s (le_of_lt hs.1) hs.2
    have : |Ψ s - 1| / s ≤ C * (1 / s) := by rw [mul_one_div]; exact div_le_div_of_nonneg_right hc hs0.le
    calc ‖G2 P β lM (Real.log (x / s))‖ * (|Ψ s - 1| / s) ≤ K / lM ^ 2 * (C * (1 / s)) :=
          mul_le_mul hG this (by positivity) (by positivity)
      _ = K / lM ^ 2 * C * (1 / s) := by ring
  · refine ContinuousOn.intervalIntegrable fun s hs => ?_
    have hs0 : 0 < s := by
      rcases Set.mem_uIcc.mp hs with h | h <;> linarith [h.1]
    exact (continuousAt_const.mul (continuousAt_const.div continuousAt_id hs0.ne')).continuousWithinAt

/-- **The size of the error**: `‖Σ c_n G(log(x/n)) − G′(log x)‖ ≤ |P′(0)|/λ |ψ(x) − 1| +
K/λ²(B log s₀ + ε log x)`, given `|Ψ − 1| ≤ B` on `[1, x]` and `≤ ε` on `[s₀, x]`. -/
theorem err_bound (P : Polynomial ℝ) (hP0 : P.eval 0 = 0) {A K : ℝ}
    (hK : ∀ (β : ℂ) (lM u : ℝ), 0 < lM → ‖β‖ * lM ≤ A → 0 ≤ u → u ≤ lM →
      ‖G2 P β lM u‖ ≤ K / lM ^ 2) (hK0 : 0 ≤ K)
    (β : ℂ) {lM : ℝ} (hlM : 0 < lM) (hβ : ‖β‖ * lM ≤ A) {x : ℝ} (hx : 1 ≤ x)
    (hxl : Real.log x ≤ lM) (c : ℕ → ℝ) {s₀ B ε : ℝ} (hs₀ : 1 ≤ s₀) (hε0 : 0 ≤ ε)
    (hB : ∀ s, 1 ≤ s → s ≤ x → |Psi c x s - 1| ≤ B)
    (hε : ∀ s, s₀ ≤ s → s ≤ x → |Psi c x s - 1| ≤ ε) :
    ‖∑ n ∈ Ioc 0 ⌊x⌋₊, (c n : ℂ) * Gp P β lM (Real.log (x / n)) - G1 P β lM (Real.log x)‖ ≤
      |(P.derivative.eval 0)| / lM * |∑ n ∈ Ioc 0 ⌊x⌋₊, c n * Real.log (x / n) - 1| +
        K / lM ^ 2 * (B * Real.log s₀ + ε * Real.log x) := by
  have hx0 : 0 < x := by linarith
  have hB0 : 0 ≤ B := le_trans (abs_nonneg _) (hB 1 le_rfl hx)
  rw [err_identity P hP0 β lM hx c]
  refine le_trans (norm_add_le _ _) (add_le_add ?_ ?_)
  · rw [norm_mul, Complex.norm_real, Real.norm_eq_abs]
    refine mul_le_mul_of_nonneg_right (le_of_eq ?_) (abs_nonneg _)
    simp only [G1, Gp, hP0, zero_div, Complex.ofReal_zero, mul_zero, zero_add,
      Complex.exp_zero, one_mul, norm_mul, norm_inv, Complex.norm_real, Real.norm_eq_abs,
      abs_of_pos hlM]
    ring
  · have hlx : 0 ≤ Real.log x := Real.log_nonneg hx
    have hls : 0 ≤ Real.log s₀ := Real.log_nonneg hs₀
    rcases le_or_gt s₀ x with hsx | hsx
    · have hint : ∀ a b : ℝ, 1 ≤ a → 1 ≤ b → IntervalIntegrable
          (fun s => G2 P β lM (Real.log (x / s)) * (((Psi c x s - 1) / s : ℝ) : ℂ)) volume a b := by
        intro a b ha hb
        refine ContinuousOn.intervalIntegrable fun s hs => ?_
        have hs1 : 1 ≤ s := by
          rcases Set.mem_uIcc.mp hs with h | h <;> linarith [h.1]
        have hs0 : 0 < s := by linarith
        refine ((G2comp_continuousAt P β lM hx0 hs0).mul
          (Complex.continuous_ofReal.continuousAt.comp ?_)).continuousWithinAt
        simp only [Psi, sub_div]
        exact (Psi_div_continuousAt c x hs0).sub (continuousAt_const.div continuousAt_id hs0.ne')
      rw [← intervalIntegral.integral_add_adjacent_intervals (hint 1 s₀ le_rfl hs₀)
        (hint s₀ x hs₀ (le_trans hs₀ hsx))]
      refine le_trans (norm_add_le _ _) ?_
      have p1 := int_piece P hK hK0 β hlM hβ hxl (Psi c x) le_rfl hs₀ hsx
        (fun s h1 h2 => hB s h1 (le_trans h2 hsx))
      have p2 := int_piece P hK hK0 β hlM hβ hxl (Psi c x) hs₀ hsx le_rfl
        (fun s h1 h2 => hε s h1 h2)
      rw [div_one] at p1
      have hq : Real.log (x / s₀) ≤ Real.log x := by
        rw [Real.log_div hx0.ne' (by linarith)]; linarith
      have : K / lM ^ 2 * ε * Real.log (x / s₀) ≤ K / lM ^ 2 * ε * Real.log x :=
        mul_le_mul_of_nonneg_left hq (by positivity)
      nlinarith
    · have p1 := int_piece P hK hK0 β hlM hβ hxl (Psi c x) le_rfl hx le_rfl
        (fun s h1 h2 => hB s h1 h2)
      rw [div_one] at p1
      have hq : Real.log x ≤ Real.log s₀ := Real.log_le_log hx0 hsx.le
      have : K / lM ^ 2 * B * Real.log x ≤ K / lM ^ 2 * B * Real.log s₀ :=
        mul_le_mul_of_nonneg_left hq (by positivity)
      have : 0 ≤ K / lM ^ 2 * (ε * Real.log x) := by positivity
      nlinarith

/-! ## `ψ_μ` at a real argument -/

/-- `ψ_μ(s) = Σ_{n ≤ s} μ(n)/n · log(s/n)`, real `s`. -/
def psiR (s : ℝ) : ℝ := ∑ n ∈ Ioc 0 ⌊s⌋₊, (μ n : ℝ) / n * Real.log (s / n)

/-- `c_n = μ(n)/n`. -/
def cmu (n : ℕ) : ℝ := (μ n : ℝ) / n

/-- `Ψ(s) = ψ_μ(s)` for `1 ≤ s ≤ x`. -/
theorem Psi_eq {x s : ℝ} (hs : 1 ≤ s) (hsx : s ≤ x) : Psi cmu x s = psiR s := by
  have hs0 : 0 < s := by linarith
  have hfl : ⌊s⌋₊ ≤ ⌊x⌋₊ := Nat.floor_le_floor hsx
  unfold Psi psiR
  rw [← Finset.sum_Ioc_consecutive _ (Nat.zero_le _) hfl]
  have h2 : ∑ n ∈ Ioc ⌊s⌋₊ ⌊x⌋₊, cmu n * max (Real.log (s / n)) 0 = 0 := by
    refine Finset.sum_eq_zero fun n hn => ?_
    obtain ⟨h1, -⟩ := Finset.mem_Ioc.mp hn
    have hn0 : (0 : ℝ) < n := by exact_mod_cast (by omega : 0 < n)
    have hsn : s < n := (Nat.floor_lt hs0.le).mp h1
    have : Real.log (s / n) ≤ 0 := Real.log_nonpos (by positivity) ((div_le_one hn0).mpr hsn.le)
    rw [max_eq_right this, mul_zero]
  rw [h2, add_zero]
  refine Finset.sum_congr rfl fun n hn => ?_
  obtain ⟨h0, h1⟩ := Finset.mem_Ioc.mp hn
  have hn0 : (0 : ℝ) < n := by exact_mod_cast h0
  have hns : (n : ℝ) ≤ s := (Nat.le_floor_iff hs0.le).mp h1
  rw [max_eq_left (Real.log_nonneg ((le_div_iff₀ hn0).mpr (by linarith))), cmu]

/-- `ψ_μ(s) = ψ_μ(⌊s⌋) + m(⌊s⌋) log(s/⌊s⌋)`. -/
theorem psiR_eq {s : ℝ} (hs : 1 ≤ s) :
    psiR s = psiMu ⌊s⌋₊ + mMu ⌊s⌋₊ * Real.log (s / ⌊s⌋₊) := by
  have hs0 : 0 < s := by linarith
  have hf1 : 1 ≤ ⌊s⌋₊ := Nat.le_floor (by exact_mod_cast hs)
  have hf0 : (0 : ℝ) < ⌊s⌋₊ := by exact_mod_cast hf1
  unfold psiR psiMu mMu
  rw [Finset.sum_mul, ← Finset.sum_add_distrib]
  refine Finset.sum_congr rfl fun n hn => ?_
  obtain ⟨h0, -⟩ := Finset.mem_Ioc.mp hn
  have hn0 : (0 : ℝ) < n := by exact_mod_cast h0
  rw [show s / n = (⌊s⌋₊ / n) * (s / ⌊s⌋₊) by field_simp,
    Real.log_mul (by positivity) (by positivity)]
  ring

theorem log_floor_le {s : ℝ} (hs : 1 ≤ s) :
    0 ≤ Real.log (s / ⌊s⌋₊) ∧ Real.log (s / ⌊s⌋₊) ≤ Real.log 2 := by
  have hs0 : 0 < s := by linarith
  have hf1 : 1 ≤ ⌊s⌋₊ := Nat.le_floor (by exact_mod_cast hs)
  have hf0 : (0 : ℝ) < ⌊s⌋₊ := by exact_mod_cast hf1
  have hf1' : (1 : ℝ) ≤ ⌊s⌋₊ := by exact_mod_cast hf1
  have hle : (⌊s⌋₊ : ℝ) ≤ s := Nat.floor_le hs0.le
  have hlt : s < ⌊s⌋₊ + 1 := Nat.lt_floor_add_one s
  constructor
  · exact Real.log_nonneg ((le_div_iff₀ hf0).mpr (by linarith))
  · refine Real.log_le_log (by positivity) ?_
    rw [div_le_iff₀ hf0]; linarith

/-- `|ψ_μ(s) − 1| ≤ B` for all `s ≥ 1`. -/
theorem psiR_bdd : ∃ B : ℝ, 0 ≤ B ∧ ∀ s : ℝ, 1 ≤ s → |psiR s - 1| ≤ B := by
  obtain ⟨C1, hC1⟩ := isBounded_iff_forall_norm_le.mp
    (Metric.isBounded_range_of_tendsto _ psiMu_tendsto)
  obtain ⟨C2, hC2⟩ := isBounded_iff_forall_norm_le.mp
    (Metric.isBounded_range_of_tendsto _ mMu_tendsto)
  have hC10 : 0 ≤ C1 := le_trans (norm_nonneg _) (hC1 _ ⟨0, rfl⟩)
  have hC20 : 0 ≤ C2 := le_trans (norm_nonneg _) (hC2 _ ⟨0, rfl⟩)
  refine ⟨C1 + 1 + C2 * Real.log 2, by positivity, fun s hs => ?_⟩
  rw [psiR_eq hs]
  have h1 : |psiMu ⌊s⌋₊| ≤ C1 := hC1 _ ⟨_, rfl⟩
  have h2 : |mMu ⌊s⌋₊| ≤ C2 := hC2 _ ⟨_, rfl⟩
  obtain ⟨l0, l2⟩ := log_floor_le hs
  have h3 : |mMu ⌊s⌋₊ * Real.log (s / ⌊s⌋₊)| ≤ C2 * Real.log 2 := by
    rw [abs_mul, abs_of_nonneg l0]; exact mul_le_mul h2 l2 l0 hC20
  calc |psiMu ⌊s⌋₊ + mMu ⌊s⌋₊ * Real.log (s / ⌊s⌋₊) - 1|
      ≤ |psiMu ⌊s⌋₊| + |mMu ⌊s⌋₊ * Real.log (s / ⌊s⌋₊)| + |(1 : ℝ)| := by
        refine le_trans (abs_sub _ _) ?_
        exact add_le_add_left (abs_add_le _ _) _
    _ ≤ C1 + 1 + C2 * Real.log 2 := by rw [abs_one]; linarith

/-- `ψ_μ(s) → 1` along real `s`. -/
theorem psiR_tendsto {ε : ℝ} (hε : 0 < ε) : ∃ s₀ : ℝ, 1 ≤ s₀ ∧ ∀ s : ℝ, s₀ ≤ s →
    |psiR s - 1| ≤ ε := by
  have hl2 : 0 < Real.log 2 := Real.log_pos (by norm_num)
  obtain ⟨N1, hN1⟩ := Metric.tendsto_atTop.mp psiMu_tendsto (ε / 2) (by positivity)
  obtain ⟨N2, hN2⟩ := Metric.tendsto_atTop.mp mMu_tendsto (ε / (2 * Real.log 2)) (by positivity)
  refine ⟨max 1 (max N1 N2), le_max_left _ _, fun s hs => ?_⟩
  have hs1 : 1 ≤ s := le_trans (le_max_left _ _) hs
  have hsN : ∀ N : ℕ, (N : ℝ) ≤ max 1 (max (N1 : ℝ) N2) → N ≤ ⌊s⌋₊ := fun N hN =>
    Nat.le_floor (le_trans hN hs)
  have hf1 : N1 ≤ ⌊s⌋₊ := hsN N1 (le_trans (le_max_left _ _) (le_max_right _ _))
  have hf2 : N2 ≤ ⌊s⌋₊ := hsN N2 (le_trans (le_max_right _ _) (le_max_right _ _))
  have h1 := hN1 _ hf1
  have h2 := hN2 _ hf2
  rw [Real.dist_eq] at h1 h2
  rw [sub_zero] at h2
  obtain ⟨l0, l2⟩ := log_floor_le hs1
  rw [psiR_eq hs1]
  have h3 : |mMu ⌊s⌋₊ * Real.log (s / ⌊s⌋₊)| ≤ ε / (2 * Real.log 2) * Real.log 2 := by
    rw [abs_mul, abs_of_nonneg l0]; exact mul_le_mul h2.le l2 l0 (by positivity)
  have h4 : ε / (2 * Real.log 2) * Real.log 2 = ε / 2 := by field_simp
  have : psiMu ⌊s⌋₊ + mMu ⌊s⌋₊ * Real.log (s / ⌊s⌋₊) - 1 =
      (psiMu ⌊s⌋₊ - 1) + mMu ⌊s⌋₊ * Real.log (s / ⌊s⌋₊) := by ring
  rw [this]
  refine le_trans (abs_add_le _ _) ?_
  linarith

/-! ## Back to `n^{−(1+β)}` -/

/-- The smooth Möbius sum `Σ_{n ≤ x} μ(n) P(log(x/n)/λ) n^{−(1+β)}`. -/
def Smu (P : Polynomial ℝ) (lM x : ℝ) (β : ℂ) : ℂ :=
  ∑ n ∈ Ioc 0 ⌊x⌋₊, ((μ n : ℤ) : ℂ) * ((P.eval (Real.log (x / n) / lM) : ℝ) : ℂ) *
    (n : ℂ) ^ (-(1 + β))

/-- Its main term `βP(log x/λ) + P′(log x/λ)/λ`. -/
def mainS (P : Polynomial ℝ) (lM x : ℝ) (β : ℂ) : ℂ :=
  β * ((P.eval (Real.log x / lM) : ℝ) : ℂ) + ((P.derivative.eval (Real.log x / lM) : ℝ) : ℂ) / lM

theorem sum_cpow_eq (P : Polynomial ℝ) (lM : ℝ) (β : ℂ) {x : ℝ} (hx : 1 ≤ x) :
    Smu P lM x β - mainS P lM x β = cexp (-(β * Real.log x)) *
      (∑ n ∈ Ioc 0 ⌊x⌋₊, (cmu n : ℂ) * Gp P β lM (Real.log (x / n)) -
        G1 P β lM (Real.log x)) := by
  have hx0 : 0 < x := by linarith
  rw [mul_sub, Finset.mul_sum]
  have hmain : mainS P lM x β = cexp (-(β * Real.log x)) * G1 P β lM (Real.log x) := by
    unfold mainS G1 Gp
    have : cexp (-(β * Real.log x)) * cexp (β * Real.log x) = 1 := by
      rw [← Complex.exp_add, neg_add_cancel, Complex.exp_zero]
    rw [show cexp (-(β * Real.log x)) * (β * (cexp (β * Real.log x) *
        ((P.eval (Real.log x / lM) : ℝ) : ℂ)) + (lM : ℂ)⁻¹ * (cexp (β * Real.log x) *
        ((P.derivative.eval (Real.log x / lM) : ℝ) : ℂ))) =
        (cexp (-(β * Real.log x)) * cexp (β * Real.log x)) * (β * ((P.eval (Real.log x / lM) : ℝ) : ℂ) +
          (lM : ℂ)⁻¹ * ((P.derivative.eval (Real.log x / lM) : ℝ) : ℂ)) by ring, this]
    ring
  rw [hmain]
  congr 1
  unfold Smu
  refine Finset.sum_congr rfl fun n hn => ?_
  obtain ⟨h0, -⟩ := Finset.mem_Ioc.mp hn
  have hn0 : (0 : ℝ) < n := by exact_mod_cast h0
  have hnc : (n : ℂ) ≠ 0 := by exact_mod_cast h0.ne'
  have hpow : (n : ℂ) ^ (-(1 + β)) = (n : ℂ)⁻¹ * cexp (-(β * (Real.log n : ℂ))) := by
    rw [show -(1 + β) = (-1 : ℂ) + -β by ring, Complex.cpow_add _ _ hnc, Complex.cpow_neg_one,
      Complex.cpow_def_of_ne_zero hnc, ← Complex.natCast_log]
    congr 2; ring
  have h2 : cexp (-(β * (Real.log x : ℂ))) * cexp (β * (Real.log (x / n) : ℂ)) =
      cexp (-(β * (Real.log n : ℂ))) := by
    rw [← Complex.exp_add, Real.log_div hx0.ne' hn0.ne']; congr 1; push_cast; ring
  unfold cmu Gp
  have key : cexp (-(β * (Real.log x : ℂ))) * ((((μ n : ℤ) : ℝ) / n : ℝ) : ℂ) *
      (cexp (β * (Real.log (x / n) : ℂ)) * ((P.eval (Real.log (x / n) / lM) : ℝ) : ℂ)) =
      ((μ n : ℤ) : ℂ) * ((P.eval (Real.log (x / n) / lM) : ℝ) : ℂ) * ((n : ℂ)⁻¹ *
        (cexp (-(β * (Real.log x : ℂ))) * cexp (β * (Real.log (x / n) : ℂ)))) := by
    push_cast; ring
  rw [← mul_assoc, key, h2, hpow]

/-- `‖x^{−β}‖ ≤ e^A` for `log x ≤ λ`, `‖β‖λ ≤ A`. -/
theorem norm_xpow_le {β : ℂ} {lM A x : ℝ} (hx : 1 ≤ x) (hxl : Real.log x ≤ lM)
    (hβ : ‖β‖ * lM ≤ A) : ‖cexp (-(β * Real.log x))‖ ≤ Real.exp A := by
  rw [Complex.norm_exp]
  refine Real.exp_le_exp.mpr ?_
  have h0 : 0 ≤ Real.log x := Real.log_nonneg hx
  have : (-(β * (Real.log x : ℂ))).re ≤ ‖-(β * (Real.log x : ℂ))‖ := Complex.re_le_norm _
  rw [norm_neg, norm_mul, Complex.norm_real, Real.norm_eq_abs, abs_of_nonneg h0] at this
  have : ‖β‖ * Real.log x ≤ ‖β‖ * lM := mul_le_mul_of_nonneg_left hxl (norm_nonneg _)
  linarith

/-- **The per-`d` step, `o(1/λ)`**: for `P(0) = 0`, `Σ_{n ≤ x} μ(n) P(log(x/n)/λ) n^{−(1+β)} =
βP(ℓ) + P′(ℓ)/λ + o(1/λ)`, `ℓ = log x/λ`, uniformly for `Y ≤ x`, `log x ≤ λ`, `‖β‖λ ≤ A`. -/
theorem muSmoothR (P : Polynomial ℝ) (hP0 : P.eval 0 = 0) {A : ℝ} (hA : 0 ≤ A) {ε : ℝ}
    (hε : 0 < ε) : ∃ Y : ℝ, 1 ≤ Y ∧ ∃ L₀ : ℝ, 0 < L₀ ∧ ∀ lM : ℝ, L₀ ≤ lM → ∀ x : ℝ, Y ≤ x →
      Real.log x ≤ lM → ∀ β : ℂ, ‖β‖ * lM ≤ A →
        ‖Smu P lM x β - mainS P lM x β‖ ≤ ε / lM := by
  obtain ⟨K, hK0, hK⟩ := G2_bound P hA
  obtain ⟨B, hB0, hB⟩ := psiR_bdd
  set D := Real.exp A * (|P.derivative.eval 0| + K + 1) with hD
  have hD0 : 0 < D := by positivity
  set ε₁ := ε / (2 * D) with hε₁
  have hε₁0 : 0 < ε₁ := by positivity
  obtain ⟨s₀, hs₀, hs⟩ := psiR_tendsto hε₁0
  set L₀ := 2 * Real.exp A * K * B * Real.log s₀ / ε + 1 with hL₀
  have hls : 0 ≤ Real.log s₀ := Real.log_nonneg hs₀
  have hL₀0 : 0 < L₀ := by positivity
  refine ⟨s₀, hs₀, L₀, hL₀0, fun lM hlM x hx hxl β hβ => ?_⟩
  have hlM0 : 0 < lM := lt_of_lt_of_le hL₀0 hlM
  have hx1 : 1 ≤ x := le_trans hs₀ hx
  have hlx : 0 ≤ Real.log x := Real.log_nonneg hx1
  have he := err_bound P hP0 hK hK0 β hlM0 hβ hx1 hxl cmu hs₀ hε₁0.le
    (fun s h1 h2 => by rw [Psi_eq h1 h2]; exact hB s h1)
    (fun s h1 h2 => by rw [Psi_eq (le_trans hs₀ h1) h2]; exact hs s h1)
  have hψ : |∑ n ∈ Ioc 0 ⌊x⌋₊, cmu n * Real.log (x / n) - 1| ≤ ε₁ := by
    have := hs x hx
    simp only [psiR] at this
    simpa [cmu] using this
  rw [sum_cpow_eq P lM β hx1, norm_mul]
  have hE := norm_xpow_le hx1 hxl hβ
  have hp : 0 ≤ |P.derivative.eval 0| := abs_nonneg _
  -- the bracket
  have hbr : |(P.derivative.eval 0)| / lM * |∑ n ∈ Ioc 0 ⌊x⌋₊, cmu n * Real.log (x / n) - 1| +
      K / lM ^ 2 * (B * Real.log s₀ + ε₁ * Real.log x) ≤
      (|P.derivative.eval 0| + K) * ε₁ / lM + K * B * Real.log s₀ / lM ^ 2 := by
    have t1 : |(P.derivative.eval 0)| / lM * |∑ n ∈ Ioc 0 ⌊x⌋₊, cmu n * Real.log (x / n) - 1| ≤
        |(P.derivative.eval 0)| / lM * ε₁ := mul_le_mul_of_nonneg_left hψ (by positivity)
    have t2 : K / lM ^ 2 * (ε₁ * Real.log x) ≤ K / lM ^ 2 * (ε₁ * lM) :=
      mul_le_mul_of_nonneg_left (mul_le_mul_of_nonneg_left hxl hε₁0.le) (by positivity)
    have e1 : K / lM ^ 2 * (ε₁ * lM) = K * ε₁ / lM := by field_simp
    have e2 : K / lM ^ 2 * (B * Real.log s₀ + ε₁ * Real.log x) =
        K * B * Real.log s₀ / lM ^ 2 + K / lM ^ 2 * (ε₁ * Real.log x) := by ring
    have e3 : (|P.derivative.eval 0| + K) * ε₁ / lM = |(P.derivative.eval 0)| / lM * ε₁ +
        K * ε₁ / lM := by ring
    linarith
  have hfin : Real.exp A * ((|P.derivative.eval 0| + K) * ε₁ / lM + K * B * Real.log s₀ / lM ^ 2)
      ≤ ε / lM := by
    have a1 : Real.exp A * ((|P.derivative.eval 0| + K) * ε₁) ≤ ε / 2 := by
      have : Real.exp A * ((|P.derivative.eval 0| + K) * ε₁) ≤ D * ε₁ := by
        rw [hD]; nlinarith [Real.exp_pos A, hε₁0]
      have h2 : D * ε₁ = ε / 2 := by rw [hε₁]; field_simp
      linarith
    have a2 : Real.exp A * (K * B * Real.log s₀) / lM ≤ ε / 2 := by
      rw [div_le_iff₀ hlM0]
      have : 2 * Real.exp A * K * B * Real.log s₀ / ε ≤ lM := by linarith
      rw [div_le_iff₀ hε] at this
      nlinarith
    have : Real.exp A * ((|P.derivative.eval 0| + K) * ε₁ / lM + K * B * Real.log s₀ / lM ^ 2) =
        Real.exp A * ((|P.derivative.eval 0| + K) * ε₁) / lM +
          Real.exp A * (K * B * Real.log s₀) / lM / lM := by field_simp
    rw [this]
    have a3 : Real.exp A * (K * B * Real.log s₀) / lM / lM ≤ ε / 2 / lM :=
      div_le_div_of_nonneg_right a2 hlM0.le
    have a4 : Real.exp A * ((|P.derivative.eval 0| + K) * ε₁) / lM ≤ ε / 2 / lM :=
      div_le_div_of_nonneg_right a1 hlM0.le
    have : ε / 2 / lM + ε / 2 / lM = ε / lM := by ring
    linarith
  calc ‖cexp (-(β * Real.log x))‖ * ‖∑ n ∈ Ioc 0 ⌊x⌋₊, (cmu n : ℂ) * Gp P β lM (Real.log (x / n)) -
        G1 P β lM (Real.log x)‖
      ≤ Real.exp A * ((|P.derivative.eval 0| + K) * ε₁ / lM + K * B * Real.log s₀ / lM ^ 2) :=
        mul_le_mul hE (le_trans he hbr) (norm_nonneg _) (Real.exp_pos _).le
    _ ≤ ε / lM := hfin

/-- **The crude size**: `‖Σ_{n ≤ x} μ(n) P(log(x/n)/λ) n^{−(1+β)} − main‖ ≤ C/λ` for every
`1 ≤ x` with `log x ≤ λ`. -/
theorem muSmooth_crude (P : Polynomial ℝ) (hP0 : P.eval 0 = 0) {A : ℝ} (hA : 0 ≤ A) :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ lM : ℝ, 0 < lM → ∀ x : ℝ, 1 ≤ x → Real.log x ≤ lM → ∀ β : ℂ,
      ‖β‖ * lM ≤ A → ‖Smu P lM x β - mainS P lM x β‖ ≤ C / lM := by
  obtain ⟨K, hK0, hK⟩ := G2_bound P hA
  obtain ⟨B, hB0, hB⟩ := psiR_bdd
  refine ⟨Real.exp A * ((|P.derivative.eval 0| + K) * B), by positivity,
    fun lM hlM0 x hx1 hxl β hβ => ?_⟩
  have hlx : 0 ≤ Real.log x := Real.log_nonneg hx1
  have he := err_bound P hP0 hK hK0 β hlM0 hβ hx1 hxl cmu le_rfl hB0
    (fun s h1 h2 => by rw [Psi_eq h1 h2]; exact hB s h1)
    (fun s h1 h2 => by rw [Psi_eq h1 h2]; exact hB s h1)
  have hψ : |∑ n ∈ Ioc 0 ⌊x⌋₊, cmu n * Real.log (x / n) - 1| ≤ B := by
    have := hB x hx1
    simp only [psiR] at this
    simpa [cmu] using this
  rw [sum_cpow_eq P lM β hx1, norm_mul]
  have hE := norm_xpow_le hx1 hxl hβ
  rw [Real.log_one, mul_zero, zero_add] at he
  have hbr : |(P.derivative.eval 0)| / lM * |∑ n ∈ Ioc 0 ⌊x⌋₊, cmu n * Real.log (x / n) - 1| +
      K / lM ^ 2 * (B * Real.log x) ≤ (|P.derivative.eval 0| + K) * B / lM := by
    have t1 : |(P.derivative.eval 0)| / lM * |∑ n ∈ Ioc 0 ⌊x⌋₊, cmu n * Real.log (x / n) - 1| ≤
        |(P.derivative.eval 0)| / lM * B := mul_le_mul_of_nonneg_left hψ (by positivity)
    have t2 : K / lM ^ 2 * (B * Real.log x) ≤ K / lM ^ 2 * (B * lM) :=
      mul_le_mul_of_nonneg_left (mul_le_mul_of_nonneg_left hxl hB0) (by positivity)
    have e1 : K / lM ^ 2 * (B * lM) = K * B / lM := by field_simp
    have e3 : (|P.derivative.eval 0| + K) * B / lM = |(P.derivative.eval 0)| / lM * B +
        K * B / lM := by ring
    linarith
  calc ‖cexp (-(β * Real.log x))‖ * ‖∑ n ∈ Ioc 0 ⌊x⌋₊, (cmu n : ℂ) * Gp P β lM (Real.log (x / n)) -
        G1 P β lM (Real.log x)‖
      ≤ Real.exp A * ((|P.derivative.eval 0| + K) * B / lM) :=
        mul_le_mul hE (le_trans he hbr) (norm_nonneg _) (Real.exp_pos _).le
    _ = Real.exp A * ((|P.derivative.eval 0| + K) * B) / lM := by ring

/-- **`DiagMain.StmtMuSmooth` holds** (the `d = 1` per-`d` step, natural `x`). -/
theorem stmtMuSmooth_holds (P : Polynomial ℝ) (κ : ℝ) : StmtMuSmooth P κ := by
  intro hP0 ε hε
  obtain ⟨Y, hY1, L₀, hL₀, h⟩ := muSmoothR P hP0 (A := max κ 0) (le_max_right _ _) hε
  refine ⟨⌈Y⌉₊, ⌈Real.exp L₀⌉₊, fun M hM x hYx hxM β hβ => ?_⟩
  have hY : Y ≤ (x : ℝ) := le_trans (Nat.le_ceil Y) (by exact_mod_cast hYx)
  have hx1 : (1 : ℝ) ≤ x := le_trans hY1 hY
  have hMe : Real.exp L₀ ≤ M := le_trans (Nat.le_ceil _) (by exact_mod_cast hM)
  have hlM : L₀ ≤ Real.log M := by
    rw [← Real.log_exp L₀]; exact Real.log_le_log (Real.exp_pos _) hMe
  have hxl : Real.log x ≤ Real.log M :=
    Real.log_le_log (by linarith) (by exact_mod_cast hxM)
  have := h (Real.log M) hlM x hY hxl β (le_trans hβ (le_max_left _ _))
  unfold Smu mainS at this
  rw [Nat.floor_natCast] at this
  convert this using 3
  refine Finset.sum_congr rfl fun n _ => ?_
  push_cast; ring

end

/-- info: 'SdiagLead.muSmoothR' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms muSmoothR

/-- info: 'SdiagLead.muSmooth_crude' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms muSmooth_crude

/-- info: 'SdiagLead.stmtMuSmooth_holds' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms stmtMuSmooth_holds

end SdiagLead
