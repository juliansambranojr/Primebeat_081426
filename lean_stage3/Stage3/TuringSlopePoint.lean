/-
TuringSlopePoint — block S14 of `lean_stage3/design/stencil.md`, Turing's slope term: the
one-sided digamma bound on the quarter line. 2026-11-25.

**On paper.** `phasePoint v = Re ψ(z)`, `z = zq v = 1/4 + iv/2`. The digamma series telescopes
against the log-norm steps (`Stage3.re_digamma_sub_log_le`'s route):
`log‖z‖ − Re ψ(z) = lim_N Σ_{n<N} a_n`, `a_n = Re w_n − log‖1 + w_n‖`, `w_n = (n + z)⁻¹`.
`Stage3.re_digamma_sub_log_le` bounds `|a_n| ≤ 8‖w_n‖²` both ways; only the lower side is needed
for the slope, and there `log y ≤ y − 1` at `y = ‖1 + w‖²` gives

  `a_n ≥ −‖w_n‖²/2 = −q_n/2`,  `q_n = ((n + 1/4)² + v²/4)⁻¹`            (`a_term_ge`).

The sum: `q_0 ≤ 4/v²`, and `q_{n} ≤ ∫_{n−1}^{n} (x² + v²/4)⁻¹` for `n ≥ 1`, so
`Σ_{n<N} q_n ≤ 4/v² + (2/v)·arctan(2N/v) ≤ 4/v² + π/v` (`quad_sum_le`). With
`log‖z‖ − log(v/2) = ½ log(1 + 1/(4v²)) ≤ 1/(8v²)` (`log_norm_zq_le`):

  `phasePoint v ≤ log(v/2) + π/(2v) + 17/(8v²)`,   `v ≥ 1`                (`phasePoint_le`).

**Sizes** (`lean_stage3/checks/turingslope/closing_height_slope.out` § 0). The true gap
`Re ψ(z) − log(v/2)` is negative, `≈ −1/(24v²)`; the bound's `π/(2v)` is the cost of the
one-sided Taylor step (`Re w` cancels exactly, the `‖w‖²/2` is kept whole). It is the term that
enters the slope as `π/(4t)`, against `97/(2t)` from `Stage3.stmtDigammaLog_holds`.

| name | content | status |
|---|---|---|
| `re_sub_log_norm_ge` | `1 + w ≠ 0 ⊢ −‖w‖²/2 ≤ Re w − log‖1 + w‖` | proved |
| `a_term_ge` | `−q_n/2 ≤ Re (n + zq v)⁻¹ − (log‖n + 1 + zq v‖ − log‖n + zq v‖)` | proved |
| `quad_sum_le` | `1 ≤ v ⊢ Σ_{n<N} q_n ≤ 4/v² + π/v` | proved |
| `re_digamma_sub_log_le_upper` | `1 ≤ v ⊢ phasePoint v − log‖zq v‖ ≤ 2/v² + π/(2v)` | proved |
| `log_norm_zq_le` | `0 < v ⊢ log‖zq v‖ ≤ log(v/2) + 1/(8v²)` | proved |
| `phasePoint_le` | `1 ≤ v ⊢ phasePoint v ≤ log(v/2) + π/(2v) + 17/(8v²)` | proved |

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Stage3.Stirling

namespace TuringSlope

open Stage3

noncomputable section

/-- **The one-sided log-Taylor step**: `log‖1 + w‖ ≤ Re w + ‖w‖²/2`. -/
theorem re_sub_log_norm_ge (w : ℂ) (hw : 1 + w ≠ 0) :
    -(‖w‖ ^ 2 / 2) ≤ w.re - Real.log ‖1 + w‖ := by
  have hpos : 0 < ‖1 + w‖ := norm_pos_iff.mpr hw
  have h1 : ‖1 + w‖ ^ 2 = (1 + w.re) ^ 2 + w.im ^ 2 := by
    rw [Complex.sq_norm, Complex.normSq_apply]
    simp only [Complex.add_re, Complex.add_im, Complex.one_re, Complex.one_im]
    ring
  have h2 : ‖w‖ ^ 2 = w.re ^ 2 + w.im ^ 2 := by
    rw [Complex.sq_norm, Complex.normSq_apply]
    ring
  have hlog : Real.log (‖1 + w‖ ^ 2) = 2 * Real.log ‖1 + w‖ := by
    rw [Real.log_pow]; push_cast; ring
  have hle := Real.log_le_sub_one_of_pos (pow_pos hpos 2)
  rw [hlog, h1] at hle
  rw [h2]
  nlinarith

/-- **The per-term lower bound** of the telescope. -/
theorem a_term_ge (v : ℝ) (n : ℕ) :
    -((((n : ℝ) + 1 / 4) ^ 2 + (v / 2) ^ 2)⁻¹ / 2)
      ≤ (((n : ℂ) + zq v)⁻¹).re
        - (Real.log ‖((n + 1 : ℕ) : ℂ) + zq v‖ - Real.log ‖(n : ℂ) + zq v‖) := by
  set w : ℂ := ((n : ℂ) + zq v)⁻¹ with hw
  have hz0 : (n : ℂ) + zq v ≠ 0 := add_zq_ne_zero v n
  have hnormsq : ‖(n : ℂ) + zq v‖ ^ 2 = ((n : ℝ) + 1 / 4) ^ 2 + (v / 2) ^ 2 :=
    normSq_add_zq v n
  have hnpos : (0 : ℝ) < ‖(n : ℂ) + zq v‖ := norm_pos_iff.mpr hz0
  have hwsq : ‖w‖ ^ 2 = ((((n : ℝ) + 1 / 4) ^ 2 + (v / 2) ^ 2))⁻¹ := by
    rw [hw, norm_inv, ← hnormsq, inv_pow]
  have hdivpt : ((n + 1 : ℕ) : ℂ) + zq v = ((n : ℂ) + zq v) * (1 + w) := by
    rw [hw]
    field_simp
    push_cast
    ring
  have h1w : 1 + w ≠ 0 := by
    intro h0
    rw [h0, mul_zero] at hdivpt
    exact add_zq_ne_zero v (n + 1) hdivpt
  have hstep : Real.log ‖((n + 1 : ℕ) : ℂ) + zq v‖ - Real.log ‖(n : ℂ) + zq v‖
      = Real.log ‖1 + w‖ := by
    rw [hdivpt, norm_mul, Real.log_mul (ne_of_gt hnpos) (norm_ne_zero_iff.mpr h1w)]
    ring
  rw [hstep, ← hwsq]
  exact re_sub_log_norm_ge w h1w

/-- The quadratic weight integrates to at most `π/v` over `[0, N]`. -/
theorem integral_quad_le {v : ℝ} (hv : 0 < v) (N : ℝ) :
    (∫ x in (0 : ℝ)..N, (x ^ 2 + (v / 2) ^ 2)⁻¹) ≤ Real.pi / v := by
  have hc : v / 2 ≠ 0 := by positivity
  have hg : ∀ x : ℝ, (x ^ 2 + (v / 2) ^ 2)⁻¹ = (4 / v ^ 2) * (1 + (x / (v / 2)) ^ 2)⁻¹ := by
    intro x
    have hv0 : v ≠ 0 := hv.ne'
    rw [div_pow]
    field_simp
    ring
  have hcv := intervalIntegral.integral_comp_div (a := 0) (b := N)
    (fun y : ℝ => (1 + y ^ 2)⁻¹) hc
  beta_reduce at hcv
  rw [intervalIntegral.integral_congr (g := fun x =>
      (4 / v ^ 2) * (1 + (x / (v / 2)) ^ 2)⁻¹) (fun x _ => hg x)]
  rw [intervalIntegral.integral_const_mul, hcv, smul_eq_mul]
  rw [integral_inv_one_add_sq]
  have hat := Real.arctan_lt_pi_div_two (N / (v / 2))
  have h0 : (0 : ℝ) / (v / 2) = 0 := by simp
  rw [h0, Real.arctan_zero, sub_zero]
  have e : 4 / v ^ 2 * (v / 2 * Real.arctan (N / (v / 2)))
      = (2 / v) * Real.arctan (N / (v / 2)) := by
    field_simp
    ring
  rw [e]
  have h2 : (2 / v) * Real.arctan (N / (v / 2)) ≤ (2 / v) * (Real.pi / 2) :=
    mul_le_mul_of_nonneg_left hat.le (by positivity)
  have e2 : (2 / v) * (Real.pi / 2) = Real.pi / v := by ring
  linarith

/-- **The quadratic sum**: `Σ_{n<N} ((n + 1/4)² + v²/4)⁻¹ ≤ 4/v² + π/v`. -/
theorem quad_sum_le {v : ℝ} (hv : 0 < v) (N : ℕ) :
    (∑ n ∈ Finset.range N, (((n : ℝ) + 1 / 4) ^ 2 + (v / 2) ^ 2)⁻¹)
      ≤ 4 / v ^ 2 + Real.pi / v := by
  set q : ℕ → ℝ := fun n => (((n : ℝ) + 1 / 4) ^ 2 + (v / 2) ^ 2)⁻¹ with hq
  have hq0 : ∀ n, 0 ≤ q n := fun n => by simp only [hq]; positivity
  set g : ℝ → ℝ := fun x => (x ^ 2 + (v / 2) ^ 2)⁻¹ with hgdef
  have hmono : AntitoneOn g (Set.Icc 0 (0 + (N : ℝ))) := by
    intro x hx y hy hxy
    simp only [hgdef]
    apply inv_anti₀ (by positivity)
    nlinarith [hx.1, hy.1]
  have hsi := hmono.sum_le_integral
  have hqg : ∀ i : ℕ, q (i + 1) ≤ g (0 + ((i + 1 : ℕ) : ℝ)) := by
    intro i
    simp only [hq, hgdef]
    apply inv_anti₀ (by positivity)
    have hi0 := Nat.cast_nonneg (α := ℝ) i
    push_cast
    rw [zero_add]
    nlinarith
  have hsum1 : (∑ i ∈ Finset.range N, q (i + 1)) ≤ Real.pi / v := by
    calc (∑ i ∈ Finset.range N, q (i + 1))
        ≤ ∑ i ∈ Finset.range N, g (0 + ((i + 1 : ℕ) : ℝ)) :=
          Finset.sum_le_sum (fun i _ => hqg i)
      _ ≤ ∫ x in (0 : ℝ)..0 + (N : ℝ), g x := hsi
      _ ≤ Real.pi / v := by
          rw [zero_add]
          exact integral_quad_le hv N
  have hq0b : q 0 ≤ 4 / v ^ 2 := by
    simp only [hq]
    have : (((0 : ℕ) : ℝ) + 1 / 4) ^ 2 + (v / 2) ^ 2 ≥ (v / 2) ^ 2 := by
      push_cast; nlinarith
    calc ((((0 : ℕ) : ℝ) + 1 / 4) ^ 2 + (v / 2) ^ 2)⁻¹ ≤ ((v / 2) ^ 2)⁻¹ :=
          inv_anti₀ (by positivity) this
      _ = 4 / v ^ 2 := by rw [div_pow, inv_div]; norm_num
  have hsub : (∑ n ∈ Finset.range N, q n) ≤ ∑ n ∈ Finset.range (N + 1), q n :=
    Finset.sum_le_sum_of_subset_of_nonneg (Finset.range_subset_range.mpr (Nat.le_succ N))
      (fun n _ _ => hq0 n)
  rw [Finset.sum_range_succ'] at hsub
  show (∑ n ∈ Finset.range N, q n) ≤ 4 / v ^ 2 + Real.pi / v
  linarith

/-- **The one-sided digamma comparison**: `Re ψ(zq v) − log‖zq v‖ ≤ 2/v² + π/(2v)`. The limit
assembly is `Stage3.re_digamma_sub_log_le`'s, with the per-term bound `a_term_ge`. -/
theorem re_digamma_sub_log_le_upper {t : ℝ} (ht : 1 ≤ t) :
    phasePoint t - Real.log ‖zq t‖ ≤ 2 / t ^ 2 + Real.pi / (2 * t) := by
  have ht0 : (0 : ℝ) < t := by linarith
  have hzre : (zq t).re = 1 / 4 := by
    simp [zq, Complex.add_re, Complex.mul_re, Complex.I_re, Complex.I_im]
  have hcond : ∀ n : ℕ, zq t ≠ -(n : ℂ) := by
    intro n h
    have h2 := congrArg Complex.re h
    rw [hzre] at h2
    simp at h2
    nlinarith [Nat.cast_nonneg (α := ℝ) n, h2]
  have hsum := Complex.hasSum_digamma hcond
  have hre0 := hsum.mapL Complex.reCLM
  have hre : HasSum
      (fun n : ℕ => (1 / ((n : ℂ) + 1) - 1 / ((n : ℂ) + zq t)).re)
      ((Complex.digamma (zq t)).re + Real.eulerMascheroniConstant) := by
    simpa using hre0
  have hP := hre.tendsto_sum_nat
  set ℓ : ℕ → ℝ := fun n => Real.log ‖(n : ℂ) + zq t‖ with hℓdef
  set b : ℕ → ℝ := fun n => (((n : ℂ) + zq t)⁻¹).re with hbdef
  set a : ℕ → ℝ := fun n => b n - (ℓ (n + 1) - ℓ n) with hadef
  have hcre : ∀ n : ℕ,
      (1 / ((n : ℂ) + 1) - 1 / ((n : ℂ) + zq t)).re
        = ((n : ℝ) + 1)⁻¹ - b n := by
    intro n
    rw [Complex.sub_re]
    congr 1
    · have hcast : (1 : ℂ) / ((n : ℂ) + 1) = ((((n : ℝ) + 1)⁻¹ : ℝ) : ℂ) := by
        push_cast
        ring
      rw [hcast, Complex.ofReal_re]
    · simp only [hbdef]
      congr 1
      rw [one_div]
  have hdecomp : ∀ N : ℕ,
      (∑ n ∈ Finset.range N, (1 / ((n : ℂ) + 1) - 1 / ((n : ℂ) + zq t)).re)
        = (∑ n ∈ Finset.range N, ((n : ℝ) + 1)⁻¹) - (ℓ N - ℓ 0)
          - ∑ n ∈ Finset.range N, a n := by
    intro N
    have h1 : (∑ n ∈ Finset.range N,
        (1 / ((n : ℂ) + 1) - 1 / ((n : ℂ) + zq t)).re)
        = ∑ n ∈ Finset.range N, (((n : ℝ) + 1)⁻¹ - b n) :=
      Finset.sum_congr rfl fun n _ => hcre n
    have h2 : (∑ n ∈ Finset.range N, b n)
        = (∑ n ∈ Finset.range N, a n) + (ℓ N - ℓ 0) := by
      have h3 : ∀ n : ℕ, b n = a n + (ℓ (n + 1) - ℓ n) := by
        intro n
        simp only [hadef]
        ring
      rw [Finset.sum_congr rfl fun n _ => h3 n, Finset.sum_add_distrib,
        Finset.sum_range_sub (f := ℓ)]
    rw [h1, Finset.sum_sub_distrib, h2]
    ring
  have hharm : ∀ N : ℕ,
      ((harmonic N : ℚ) : ℝ) = ∑ n ∈ Finset.range N, ((n : ℝ) + 1)⁻¹ := by
    intro N
    rw [harmonic]
    push_cast
    rfl
  set A : ℕ → ℝ := fun N => ∑ n ∈ Finset.range N, a n with hAdef
  have hAeq : ∀ N : ℕ,
      A N = (((harmonic N : ℚ) : ℝ) - Real.log ((N : ℝ) + 1))
        - (ℓ N - Real.log ((N : ℝ) + 1)) + ℓ 0
        - ∑ n ∈ Finset.range N, (1 / ((n : ℂ) + 1) - 1 / ((n : ℂ) + zq t)).re := by
    intro N
    have hd := hdecomp N
    have hh := hharm N
    rw [hAdef]
    linarith [hd, hh]
  have hT1 : Filter.Tendsto
      (fun N : ℕ => ((harmonic N : ℚ) : ℝ) - Real.log ((N : ℝ) + 1))
      Filter.atTop (nhds Real.eulerMascheroniConstant) :=
    Real.tendsto_eulerMascheroniSeq
  have hT2 : Filter.Tendsto
      (fun N : ℕ => ℓ N - Real.log ((N : ℝ) + 1))
      Filter.atTop (nhds 0) := by
    have hnpos : ∀ N : ℕ, (0 : ℝ) < ‖(N : ℂ) + zq t‖ :=
      fun N => norm_pos_iff.mpr (add_zq_ne_zero t N)
    have heq : ∀ N : ℕ, ℓ N - Real.log ((N : ℝ) + 1)
        = Real.log (‖(N : ℂ) + zq t‖ / ((N : ℝ) + 1)) := by
      intro N
      simp only [hℓdef]
      rw [Real.log_div (ne_of_gt (hnpos N)) (by positivity)]
    have hlow : ∀ N : ℕ, ((N : ℝ) + 1 / 4) / ((N : ℝ) + 1)
        ≤ ‖(N : ℂ) + zq t‖ / ((N : ℝ) + 1) := by
      intro N
      have hreN : ((N : ℂ) + zq t).re = (N : ℝ) + 1 / 4 := by
        simp [zq, Complex.add_re, Complex.mul_re, Complex.I_re, Complex.I_im]
      have h1 : (N : ℝ) + 1 / 4 ≤ ‖(N : ℂ) + zq t‖ := by
        calc (N : ℝ) + 1 / 4 = ((N : ℂ) + zq t).re := hreN.symm
          _ ≤ |((N : ℂ) + zq t).re| := le_abs_self _
          _ ≤ ‖(N : ℂ) + zq t‖ := Complex.abs_re_le_norm _
      gcongr
    have hup : ∀ N : ℕ, ‖(N : ℂ) + zq t‖ / ((N : ℝ) + 1)
        ≤ ((N : ℝ) + ‖zq t‖) / ((N : ℝ) + 1) := by
      intro N
      have h1 : ‖(N : ℂ) + zq t‖ ≤ (N : ℝ) + ‖zq t‖ := by
        calc ‖(N : ℂ) + zq t‖ ≤ ‖(N : ℂ)‖ + ‖zq t‖ := norm_add_le _ _
          _ = (N : ℝ) + ‖zq t‖ := by
              rw [Complex.norm_natCast]
      gcongr
    have hden : Filter.Tendsto (fun N : ℕ => (N : ℝ) + 1)
        Filter.atTop Filter.atTop :=
      Filter.tendsto_atTop_add_const_right _ 1 tendsto_natCast_atTop_atTop
    have hlim_of : ∀ c : ℝ, Filter.Tendsto
        (fun N : ℕ => ((N : ℝ) + c) / ((N : ℝ) + 1))
        Filter.atTop (nhds 1) := by
      intro c
      have hrw : ∀ N : ℕ, ((N : ℝ) + c) / ((N : ℝ) + 1)
          = 1 + (c - 1) / ((N : ℝ) + 1) := by
        intro N
        have hN0 : ((N : ℝ) + 1) ≠ 0 := by positivity
        rw [show (N : ℝ) + c = ((N : ℝ) + 1) + (c - 1) by ring, add_div,
          div_self hN0]
      have hz : Filter.Tendsto (fun N : ℕ => (c - 1) / ((N : ℝ) + 1))
          Filter.atTop (nhds 0) :=
        Filter.Tendsto.div_atTop tendsto_const_nhds hden
      have hone := Filter.Tendsto.const_add (1 : ℝ) hz
      rw [add_zero] at hone
      exact hone.congr fun N => (hrw N).symm
    have hratio : Filter.Tendsto
        (fun N : ℕ => ‖(N : ℂ) + zq t‖ / ((N : ℝ) + 1))
        Filter.atTop (nhds 1) :=
      tendsto_of_tendsto_of_tendsto_of_le_of_le
        (hlim_of (1 / 4)) (hlim_of ‖zq t‖) hlow hup
    have hcomp := ((Real.continuousAt_log one_ne_zero).tendsto).comp hratio
    rw [Real.log_one] at hcomp
    exact (hcomp.congr fun N => (heq N).symm)
  have hA : Filter.Tendsto A Filter.atTop
      (nhds (ℓ 0 - (Complex.digamma (zq t)).re)) := by
    have hcomb := ((hT1.sub hT2).add_const (ℓ 0)).sub hP
    have hval : Real.eulerMascheroniConstant - 0 + ℓ 0
        - ((Complex.digamma (zq t)).re + Real.eulerMascheroniConstant)
        = ℓ 0 - (Complex.digamma (zq t)).re := by
      ring
    rw [hval] at hcomb
    exact hcomb.congr fun N => (hAeq N).symm
  -- the one-sided bound on `A`
  have hAbd : ∀ N : ℕ, -(2 / t ^ 2 + Real.pi / (2 * t)) ≤ A N := by
    intro N
    have h1 : ∀ n ∈ Finset.range N,
        -((((n : ℝ) + 1 / 4) ^ 2 + (t / 2) ^ 2)⁻¹ / 2) ≤ a n := by
      intro n _
      simp only [hadef, hbdef, hℓdef]
      exact a_term_ge t n
    have h2 := Finset.sum_le_sum h1
    have h3 := quad_sum_le ht0 N
    have h4 : (∑ n ∈ Finset.range N, -((((n : ℝ) + 1 / 4) ^ 2 + (t / 2) ^ 2)⁻¹ / 2))
        = -((∑ n ∈ Finset.range N, (((n : ℝ) + 1 / 4) ^ 2 + (t / 2) ^ 2)⁻¹) / 2) := by
      rw [Finset.sum_neg_distrib, Finset.sum_div]
    have h5 : (4 / t ^ 2 + Real.pi / t) / 2 = 2 / t ^ 2 + Real.pi / (2 * t) := by
      field_simp
      ring
    rw [hAdef]
    simp only
    linarith
  have hℓ0 : ℓ 0 = Real.log ‖zq t‖ := by
    simp only [hℓdef]
    norm_num
  have hfinal := ge_of_tendsto hA (Filter.Eventually.of_forall hAbd)
  rw [hℓ0] at hfinal
  rw [phasePoint_eq]
  linarith

/-- `log‖zq v‖ ≤ log(v/2) + 1/(8v²)`. -/
theorem log_norm_zq_le {v : ℝ} (hv : 0 < v) :
    Real.log ‖zq v‖ ≤ Real.log (v / 2) + 1 / (8 * v ^ 2) := by
  have hn : ‖zq v‖ ^ 2 = (1 / 4) ^ 2 + (v / 2) ^ 2 := by
    have := normSq_add_zq v 0
    simpa using this
  have hz0 : 0 < ‖zq v‖ := by
    have : (0 : ℝ) < ‖zq v‖ ^ 2 := by rw [hn]; positivity
    exact lt_of_le_of_ne (norm_nonneg _) (fun h => by rw [← h] at this; norm_num at this)
  have h1 : Real.log (‖zq v‖ ^ 2) = 2 * Real.log ‖zq v‖ := by
    rw [Real.log_pow]; push_cast; ring
  have h2 : Real.log ((v / 2) ^ 2) = 2 * Real.log (v / 2) := by
    rw [Real.log_pow]; push_cast; ring
  have hB : (0 : ℝ) < (v / 2) ^ 2 := by positivity
  have h3 : Real.log (‖zq v‖ ^ 2) - Real.log ((v / 2) ^ 2)
      = Real.log (‖zq v‖ ^ 2 / (v / 2) ^ 2) :=
    (Real.log_div (pow_pos hz0 2).ne' hB.ne').symm
  have h4 := Real.log_le_sub_one_of_pos (div_pos (pow_pos hz0 2) hB)
  have h5 : ‖zq v‖ ^ 2 / (v / 2) ^ 2 - 1 = 1 / (4 * v ^ 2) := by
    rw [hn]
    field_simp
    ring
  have h6 : 1 / (4 * v ^ 2) = 2 * (1 / (8 * v ^ 2)) := by
    field_simp
    ring
  linarith

/-- **The one-sided digamma bound on the quarter line**:
`Re ψ(1/4 + iv/2) ≤ log(v/2) + π/(2v) + 17/(8v²)` for `v ≥ 1`. -/
theorem phasePoint_le {v : ℝ} (hv : 1 ≤ v) :
    phasePoint v ≤ Real.log (v / 2) + Real.pi / (2 * v) + 17 / (8 * v ^ 2) := by
  have hv0 : 0 < v := by linarith
  have h1 := re_digamma_sub_log_le_upper hv
  have h2 := log_norm_zq_le hv0
  have e : 2 / v ^ 2 + 1 / (8 * v ^ 2) = 17 / (8 * v ^ 2) := by
    field_simp
    ring
  linarith

end

/-- info: 'TuringSlope.a_term_ge' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms a_term_ge

/-- info: 'TuringSlope.quad_sum_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms quad_sum_le

/-- info: 'TuringSlope.re_digamma_sub_log_le_upper' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms re_digamma_sub_log_le_upper

/-- info: 'TuringSlope.phasePoint_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms phasePoint_le

end TuringSlope
