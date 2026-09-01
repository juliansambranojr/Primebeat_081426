/-
Abscissa — the contour's abscissa as a parameter, with RH as one instance.

WHY THIS FILE EXISTS. `lean_stage3/Stage3/LineBound.lean:1091` defines

    noncomputable def σRH (X : ℝ) : ℝ := 1 / 2 + 1 / Real.log X

with `1/2` a LITERAL inside a `def`, and RH enters the whole apparatus
through one lemma, `zeta_ne_zero_of_RH` (`LineBound.lean:23`), whose
only job is `ζ ≠ 0` to the right of that abscissa. Everything
downstream — the Perron pull, the vertical `I₃₇` bound, the
horizontals, the Mellin work — is abscissa-agnostic arithmetic that
already compiles. So the hypothesis is welded into a definition rather
than carried as a parameter, and that is a choice, not a necessity.

This module parameterises it:

    σθ θ X = θ + 1/log X                the abscissa, with θ free
    StmtZeroFreeRight θ                 no zeros with re > θ (bar s = 1)
    zeta_ne_zero_right_of               the consumer lemma, from that Prop
    zeroFreeRight_of_RH                 RH ⟹ StmtZeroFreeRight (1/2)
    σθ_half                             σθ (1/2) = σRH, verbatim

`σθ_half` is the weld: at `θ = 1/2` the parameterised abscissa is
DEFINITIONALLY the old one, so nothing downstream regresses, and
`zeroFreeRight_of_RH` makes RH the `θ = 1/2` instance of a statement
that has other instances.

WHY THIS IS WORTH BUILDING. Entry 277 measured the census's real
requirement shape-free: it needs a POWER SAVING, and depth 6 is closed
by `|π − li| ≤ x^0.7464` — strictly weaker than RH and not known to
imply it. A θ-parameterised contour machine is the apparatus that
consumes such a hypothesis. Entry 283 showed the constants side is
measurable rather than notional.

THE CONVERSE. `StmtZeroFreeRight (1/2) → RiemannHypothesis` also holds
— a zero left of the line reflects through `ArgIdentity.xi_one_sub` to
one right of it — but it is NOT proved here and no theorem below
pretends to. Nothing consumes it: the machine only ever USES a
zero-free half-plane, never produces one, so proving it would buy an
`ArgIdentity` dependency and no caller.

THE CRUDE BOUND, GENERALISED. `logDerivZeta_crude_theta` below is
`Slice3.logDerivZeta_crude` (`LineBound.lean:74`) with `θ` free. Tracing
where its numerals come from settles what the generalisation costs:

    3991  Slice3.finalBoundConst_le, at the FIXED radii
          (r' = 3/4, r = 181/200, R' = 29/32, R = 15/16)
    1996  = 3991/2, after the 2z+c rescale is divided out
      29  from 1/log(375/362) ≤ 29 — the Jensen count at those radii
     129  from 29 · log 84 ≤ 129

None of them touches `1/2`. They are fixed by the disk geometry of
`Stage3.jensenF`, which is anchored at the centre `2 + it` and does not
move with `θ`; and `r' = 3/4` stays admissible because
`‖z₀‖ = (2−σ₁)/2 ≤ 3/4` needs only `σ₁ ≥ 1/2`, which holds whenever
`σ₁ > θ ≥ 1/2`. So the numerals survive verbatim and only the
denominator moves, from `σ₁ − 1/2` to `σ₁ − θ`.

The one substantive change is the zero-location step. RH places every
zero of the local model exactly at `re = −3/4`; the proof consumes that
only through `Complex.abs_re_le_norm`, as a LOWER BOUND on the real part
of `z₀ − ρ`. A zero-free half-plane at `θ` gives `2ρ.re + 2 ≤ θ`, hence
`ρ.re ≤ (θ−2)/2`, hence `(z₀ − ρ).re ≥ (σ₁ − θ)/2` — the shape the
distance bound needs. RH's equality was stronger than the argument used.
The trivial-zero case analysis also drops out, `StmtZeroFreeRight` being
stated directly about half-planes.

Notes entry 286 priced this half as a constants re-derivation, on the
grounds that `1/2` occurs twenty times in the 180 lines. Entry 287
corrects that: counting occurrences of a literal is not tracing one to
its source, and every constant traces to the radii.

WHAT THIS DOES NOT CLAIM. No `θ < 1` power saving is proved by anyone;
de la Vallée Poussin gives `exp(−c√log x)`, which is not a power, and
entry 277 recorded every proved zero-free region yielding
`depth_covered = 0`. The interval `(1/2, 1)` is open. This file does not
enter it — it removes the reason the existing machine could not be
pointed at it.

Companion to notes entries 230, 240, 277, 283, 284.
-/
import Mathlib
import Stage3.LineBound

namespace Stage3

open Complex

noncomputable section

local notation "ζ" => riemannZeta

/-! ## The abscissa, with the exponent free -/

/-- **The parameterised abscissa.** `σθ θ X = θ + 1/log X`. The existing
`RHPull.σRH` is the `θ = 1/2` case. -/
def σθ (θ X : ℝ) : ℝ := θ + 1 / Real.log X

/-- **The weld.** At `θ = 1/2` this is the abscissa the built machine
already uses, definitionally. -/
theorem σθ_half (X : ℝ) : σθ (1/2) X = RHPull.σRH X := rfl

theorem σθ_re (θ X t : ℝ) : ((σθ θ X : ℂ) + I * (t : ℂ)).re = σθ θ X := by
  simp [σθ]

/-! ## The hypothesis the abscissa actually needs -/

/-- **A zero-free half-plane at `θ`.** This is the whole content the
contour pull requires: nothing vanishes strictly to the right of `θ`,
the pole at `s = 1` excepted. RH is the case `θ = 1/2`. -/
def StmtZeroFreeRight (θ : ℝ) : Prop :=
  ∀ s : ℂ, θ < s.re → s ≠ 1 → ζ s ≠ 0

/-- **The consumer lemma, in the shape the machine uses.** Mirrors
`RHPull.zeta_ne_zero_of_RH` with the hypothesis carried as a parameter
rather than as RH. -/
theorem zeta_ne_zero_right_of {θ : ℝ} (hθ : StmtZeroFreeRight θ) {s : ℂ}
    (hs : θ < s.re) (hs1 : s ≠ 1) : ζ s ≠ 0 :=
  hθ s hs hs1

/-- **RH is the `θ = 1/2` instance.** The proof is
`RHPull.zeta_ne_zero_of_RH`'s, unchanged — which is the point: the
lemma never needed RH as such, only a zero-free half-plane. -/
theorem zeroFreeRight_of_RH (hRH : RiemannHypothesis) :
    StmtZeroFreeRight (1/2) := by
  intro s hs hs1
  exact RHPull.zeta_ne_zero_of_RH hRH hs hs1

/-- **A weaker exponent is a weaker hypothesis.** Moving the half-plane
right only removes obligations, so the family is monotone in `θ` — this
is what makes `θ` a dial rather than a relabelling. -/
theorem zeroFreeRight_mono {θ θ' : ℝ} (h : θ ≤ θ')
    (hθ : StmtZeroFreeRight θ) : StmtZeroFreeRight θ' :=
  fun s hs hs1 => hθ s (lt_of_le_of_lt h hs) hs1

/-! ## What the abscissa contributes: the power saving, exactly -/

/-- **The abscissa identity at general `θ`.** `X^(θ + 1/log X) = e·X^θ`.
This is the whole arithmetic content of the choice of abscissa: the
`1/log X` correction contributes a bare factor of `e`, and the `θ`
contributes `X^θ`. `RHPull.rpow_σRH` is the `θ = 1/2` case, where
`X^(1/2) = √X`. -/
theorem rpow_σθ {θ X : ℝ} (hX : 0 < X) (hLX : 0 < Real.log X) :
    X ^ (σθ θ X) = Real.exp 1 * X ^ θ := by
  have hsplit : Real.log X * (θ + 1 / Real.log X) = Real.log X * θ + 1 := by
    field_simp
  rw [σθ, Real.rpow_def_of_pos hX, Real.rpow_def_of_pos hX, hsplit,
    Real.exp_add]
  ring

/-- **The `θ = 1/2` case is the built one**, so the generalisation
recovers `RHPull.rpow_σRH` rather than competing with it. -/
theorem rpow_σθ_half {X : ℝ} (hX : 0 < X) (hLX : 4 ≤ Real.log X) :
    X ^ (σθ (1/2) X) = Real.exp 1 * Real.sqrt X := by
  rw [rpow_σθ hX (by linarith), Real.sqrt_eq_rpow]

/-- **Where the power saving comes from.** The vertical segment's bound
carries `X^(σθ θ X)`, and `rpow_σθ` turns that into `e·X^θ`. So a
contour run at abscissa `θ` produces a bound of shape `X^θ·(log X)^k` —
which is exactly the POWER SAVING form entry 277 measured the census to
need, with `θ = 0.7464` closing depth 6. At `θ = 1/2` it is `√X`, the
RH-strength bound the built machine produces. -/
theorem abscissa_gives_power {θ X K : ℝ} (hX : 0 < X) (hLX : 0 < Real.log X)
    (hK : 0 ≤ K) :
    K * X ^ (σθ θ X) = (Real.exp 1 * K) * X ^ θ := by
  rw [rpow_σθ hX hLX]
  ring

/-- **The unconditional endpoint.** `θ = 1` holds outright, from
Mathlib's non-vanishing on the closed half-plane `1 ≤ re s`. So the
family is non-empty and the open question is exactly how far left of
`1` it can be pushed. -/
theorem zeroFreeRight_one : StmtZeroFreeRight 1 :=
  fun _ hs _ => riemannZeta_ne_zero_of_one_le_re (le_of_lt hs)

/-! ## The crude line bound, with the abscissa free

`Slice3.logDerivZeta_crude` at general `θ`. See the header for why the
numerals `1996`, `29`, `129` are unchanged and only the denominator moves.
-/

/-- **The crude bound on `\zeta'/\zeta` on a vertical line, at a general
zero-free abscissa `θ`.** `Slice3.logDerivZeta_crude` is the case
`θ = 1/2`, via `zeroFreeRight_of_RH`, with identical constants. -/
theorem logDerivZeta_crude_theta {θ : ℝ} (hθ : StmtZeroFreeRight θ)
    (hθlo : 1/2 ≤ θ) {t σ₁ : ℝ} (ht : 2 ≤ t)
    (hlo : θ < σ₁) (hhi : σ₁ ≤ 2) :
    ‖deriv ζ ((σ₁ : ℂ) + I * (t : ℂ)) / ζ ((σ₁ : ℂ) + I * (t : ℂ))‖
      ≤ 1996 * Real.log (84 * t) + (29 * Real.log t + 129) / (σ₁ - θ) := by
  classical
  set c : ℂ := 2 + I * (t : ℂ) with hc
  set s : ℂ := (σ₁ : ℂ) + I * (t : ℂ) with hs
  set z0 : ℂ := ((σ₁ - 2 : ℝ) : ℂ) / 2 with hz0
  -- basic real facts.  `σ₁ > θ ≥ 1/2` is what keeps the radius `r' = 3/4` legal.
  have hδ : (0:ℝ) < σ₁ - θ := by linarith
  have hhalf : (1:ℝ)/2 < σ₁ := by linarith
  have htpos : (0:ℝ) < t := by linarith
  have hlogt : Real.log 2 ≤ Real.log t := Real.log_le_log (by norm_num) ht
  have hlogtpos : (0:ℝ) < Real.log t := lt_of_lt_of_le (Real.log_pos (by norm_num)) hlogt
  -- z0 coordinates
  have hz0re : z0.re = (σ₁ - 2)/2 := by
    simp [hz0]
  have hz0norm : ‖z0‖ = (2 - σ₁)/2 := by
    rw [hz0, norm_div, Complex.norm_real, Real.norm_eq_abs,
      abs_of_nonpos (by linarith : σ₁ - 2 ≤ 0)]
    simp only [Complex.norm_ofNat]
    ring
  have h2z0 : 2 * z0 + c = s := by
    rw [hz0, hc, hs]
    push_cast
    ring
  -- s facts
  have hsre : s.re = σ₁ := by simp [hs]
  have hsim : s.im = t := by simp [hs]
  have hsne1 : s ≠ 1 := by
    intro h; rw [h] at hsim; simp at hsim; linarith
  have hszero : ζ s ≠ 0 := zeta_ne_zero_right_of hθ (by rw [hsre]; linarith) hsne1
  -- the local model
  set f : ℂ → ℂ := Stage3.jensenF t with hf
  have hfz0 : f z0 = ζ s / ζ c := by
    rw [hf, Stage3.jensenF, h2z0]
  have hcne : ζ c ≠ 0 := Stage3.zeta_centre_ne_zero t
  have hfz0ne : f z0 ≠ 0 := by
    rw [hfz0]; exact div_ne_zero hszero hcne
  -- derivative transfer
  have hderiv : deriv f z0 / f z0 = 2 * (deriv ζ s / ζ s) := by
    have hd1 : HasDerivAt (fun z : ℂ => 2 * z + c) 2 z0 := by
      simpa using ((hasDerivAt_id z0).const_mul (2:ℂ)).add_const c
    have hd2 : HasDerivAt ζ (deriv ζ s) ((fun z : ℂ => 2 * z + c) z0) := by
      show HasDerivAt ζ (deriv ζ s) (2 * z0 + c)
      rw [h2z0]
      exact (differentiableAt_riemannZeta hsne1).hasDerivAt
    have hd3 : HasDerivAt (fun z : ℂ => ζ (2 * z + c)) (deriv ζ s * 2) z0 := by
      simpa [Function.comp_def] using hd2.comp z0 hd1
    have hd4 : HasDerivAt f (deriv ζ s * 2 / ζ c) z0 := hd3.div_const (ζ c)
    rw [hd4.deriv, hfz0]
    field_simp
    try ring
  -- FinalBound inputs, at the SAME radii as the `θ = 1/2` proof
  have hr1 : (181:ℝ)/200 < 1 := by norm_num
  have hfin : (SetOfZeros 1 f).Finite := Stage3.jensenF_zeros_finite ht
  have hana : AnalyticOnNhd ℂ f (Metric.closedBall (0:ℂ) 1) := Stage3.jensenF_analytic ht
  have hf0 : f 0 = 1 := Stage3.jensenF_zero_eq_one t
  have hbd : ∀ z : ℂ, ‖z‖ ≤ 15/16 → ‖f z‖ ≤ 84 * t := fun z hz => Stage3.jensenF_bound ht hz
  have hBgt : (1:ℝ) < 84 * t := by linarith
  have hmem : z0 ∈ Metric.closedBall (0:ℂ) (3/4) \ SetOfZeros (29/32) f := by
    constructor
    · simp only [Metric.mem_closedBall, dist_zero_right, hz0norm]
      linarith
    · intro hmem2
      exact hfz0ne hmem2.2
  have hFB := FinalBound (B := 84 * t) (r' := 3/4) (r := 181/200) (R' := 29/32) (R := 15/16)
    (f := f) (z := z0) hBgt (by norm_num) (by norm_num) hr1 (by norm_num) (by norm_num)
    (by norm_num) hana hf0 hfin hbd hmem
  have hZB := ZerosBound (B := 84 * t) (r := 181/200) (R := 15/16) (f := f)
    (by norm_num) hr1 (by norm_num) (by norm_num) hana hf0 hfin hbd
  set S := (finiteSetOfZeros_mono hr1 hfin).toFinset with hS
  -- THE ONE SUBSTANTIVE CHANGE.  Under RH the zeros sit exactly at `re = -3/4`;
  -- a zero-free half-plane at `θ` gives only `re ≤ (θ-2)/2`, which is all the
  -- distance bound below consumes.
  have hzeroRe : ∀ ρ ∈ S, ρ.re ≤ (θ - 2)/2 := by
    intro ρ hρ
    rw [hS, Set.Finite.mem_toFinset] at hρ
    obtain ⟨hρn, hρ0⟩ := hρ
    have hw0 : ζ (2 * ρ + c) = 0 := by
      have : f ρ = ζ (2 * ρ + c) / ζ c := rfl
      rw [this, div_eq_zero_iff] at hρ0
      exact hρ0.resolve_right hcne
    have hwc : ‖(2 * ρ + c) - c‖ ≤ 181/100 := by
      rw [show (2 * ρ + c) - c = 2 * ρ by ring, norm_mul]
      simp only [Complex.norm_ofNat]
      linarith
    have hwne1 : (2 * ρ + c) ≠ 1 :=
      Stage3.pole_away_centre ht (by linarith [hwc] : ‖(2*ρ+c) - c‖ < 11/5)
    have hwre : (2 * ρ + c).re = 2 * ρ.re + 2 := by simp [hc]
    by_contra hcon
    push_neg at hcon
    exact hθ (2 * ρ + c) (by rw [hwre]; linarith) hwne1 hw0
  -- distance lower bound, now `(σ₁ - θ)/2`
  have hdist : ∀ ρ ∈ S, (σ₁ - θ)/2 ≤ ‖z0 - ρ‖ := by
    intro ρ hρ
    have h1 : (σ₁ - θ)/2 ≤ (z0 - ρ).re := by
      rw [Complex.sub_re, hz0re]
      linarith [hzeroRe ρ hρ]
    calc (σ₁ - θ)/2 ≤ (z0 - ρ).re := h1
      _ ≤ |(z0 - ρ).re| := le_abs_self _
      _ ≤ ‖z0 - ρ‖ := Complex.abs_re_le_norm _
  -- bound the sum
  have hsum : ‖∑ ρ ∈ S, (analyticOrderNatAt f ρ : ℂ) / (z0 - ρ)‖
      ≤ (2 / (σ₁ - θ)) * ((∑ ρ ∈ S, analyticOrderNatAt f ρ : ℕ) : ℝ) := by
    refine le_trans (norm_sum_le _ _) ?_
    rw [Nat.cast_sum, Finset.mul_sum]
    refine Finset.sum_le_sum ?_
    intro ρ hρ
    rw [norm_div, Complex.norm_natCast]
    have hd := hdist ρ hρ
    have hdpos : (0:ℝ) < ‖z0 - ρ‖ := lt_of_lt_of_le (by linarith) hd
    have hm : (0:ℝ) ≤ (analyticOrderNatAt f ρ : ℝ) := Nat.cast_nonneg _
    have hinvle : 1 / ‖z0 - ρ‖ ≤ 1 / ((σ₁ - θ)/2) :=
      one_div_le_one_div_of_le (by linarith) hd
    have h2 : (1:ℝ) / ((σ₁ - θ)/2) = 2 / (σ₁ - θ) := one_div_div _ _
    rw [h2] at hinvle
    calc ((analyticOrderNatAt f ρ : ℝ)) / ‖z0 - ρ‖
        = (analyticOrderNatAt f ρ : ℝ) * (1 / ‖z0 - ρ‖) := by ring
      _ ≤ (analyticOrderNatAt f ρ : ℝ) * (2 / (σ₁ - θ)) :=
          mul_le_mul_of_nonneg_left hinvle hm
      _ = 2 / (σ₁ - θ) * (analyticOrderNatAt f ρ : ℝ) := by ring
  -- count bound: unchanged, it lives on the fixed radii
  have hlog1514 : (13 : ℝ) / 375 ≤ Real.log (375 / 362) := by
    have h1 : Real.log (362 / 375) ≤ 362 / 375 - 1 := Real.log_le_sub_one_of_pos (by norm_num)
    rw [show (375 : ℝ) / 362 = ((362 : ℝ) / 375)⁻¹ by norm_num, Real.log_inv]
    linarith
  have hlog1514pos : (0 : ℝ) < Real.log (375 / 362) := by linarith
  have hlog84 : Real.log 84 ≤ 4.44 := by
      have h5 : Real.log ((84:ℝ) ^ (5:ℕ)) ≤ Real.log ((2:ℝ) ^ (32:ℕ)) :=
        Real.log_le_log (by positivity) (by norm_num)
      rw [Real.log_pow, Real.log_pow] at h5
      have h3 := Real.log_two_lt_d9
      push_cast at h5
      linarith
  have hlog84nn : (0 : ℝ) ≤ Real.log 84 := Real.log_nonneg (by norm_num)
  have hlogB : Real.log (84 * t) = Real.log 84 + Real.log t :=
    Real.log_mul (by norm_num) (by linarith)
  have hcount : ((∑ ρ ∈ S, analyticOrderNatAt f ρ : ℕ) : ℝ) ≤ 29 * Real.log t + 129 := by
    have hinv : 1 / Real.log (375 / 362) ≤ 29 := by
      rw [div_le_iff₀ hlog1514pos]; linarith
    rw [hS]
    calc ((∑ ρ ∈ (finiteSetOfZeros_mono hr1 hfin).toFinset, analyticOrderNatAt f ρ : ℕ) : ℝ)
        ≤ 1 / Real.log ((15/16) / (181/200)) * Real.log (84 * t) := hZB
      _ = 1 / Real.log (375/362) * Real.log (84 * t) := by norm_num
      _ ≤ 29 * Real.log (84 * t) := by
          refine mul_le_mul_of_nonneg_right hinv ?_
          rw [hlogB]; linarith
      _ = 29 * (Real.log 84 + Real.log t) := by rw [hlogB]
      _ ≤ 29 * Real.log t + 129 := by linarith
  -- assemble
  have hK := Slice3.finalBoundConst_le
  have hlogBnn : (0:ℝ) ≤ Real.log (84 * t) := by rw [hlogB]; linarith
  have hstep : ‖deriv f z0 / f z0‖ ≤ 3991 * Real.log (84 * t)
      + (2 / (σ₁ - θ)) * (29 * Real.log t + 129) := by
    have htri : ‖deriv f z0 / f z0‖
        ≤ ‖deriv f z0 / f z0 - ∑ ρ ∈ S, (analyticOrderNatAt f ρ : ℂ) / (z0 - ρ)‖
          + ‖∑ ρ ∈ S, (analyticOrderNatAt f ρ : ℂ) / (z0 - ρ)‖ := by
      simpa using norm_add_le (deriv f z0 / f z0
        - ∑ ρ ∈ S, (analyticOrderNatAt f ρ : ℂ) / (z0 - ρ))
        (∑ ρ ∈ S, (analyticOrderNatAt f ρ : ℂ) / (z0 - ρ))
    have hA : ‖deriv f z0 / f z0 - ∑ ρ ∈ S, (analyticOrderNatAt f ρ : ℂ) / (z0 - ρ)‖
        ≤ 3991 * Real.log (84 * t) := by
      refine le_trans hFB ?_
      exact mul_le_mul_of_nonneg_right hK hlogBnn
    have hB2 : ‖∑ ρ ∈ S, (analyticOrderNatAt f ρ : ℂ) / (z0 - ρ)‖
        ≤ (2 / (σ₁ - θ)) * (29 * Real.log t + 129) := by
      refine le_trans hsum ?_
      exact mul_le_mul_of_nonneg_left hcount (by positivity)
    linarith
  rw [hderiv] at hstep
  rw [norm_mul] at hstep
  simp only [Complex.norm_ofNat] at hstep
  have hfinal : (2 / (σ₁ - θ)) * (29 * Real.log t + 129)
      = 2 * ((29 * Real.log t + 129) / (σ₁ - θ)) := by field_simp
  rw [hfinal] at hstep
  linarith

/-- **The weld at `θ = 1/2`.** Under RH the general bound specialises to
exactly `Slice3.logDerivZeta_crude`'s statement, numerals included — so the
generalisation recovers the built theorem rather than competing with it. -/
theorem logDerivZeta_crude_half (hRH : RiemannHypothesis) {t σ₁ : ℝ} (ht : 2 ≤ t)
    (hlo : 1/2 < σ₁) (hhi : σ₁ ≤ 2) :
    ‖deriv ζ ((σ₁ : ℂ) + I * (t : ℂ)) / ζ ((σ₁ : ℂ) + I * (t : ℂ))‖
      ≤ 1996 * Real.log (84 * t) + (29 * Real.log t + 129) / (σ₁ - 1/2) :=
  logDerivZeta_crude_theta (zeroFreeRight_of_RH hRH) le_rfl ht hlo hhi


end

/-! ## Axiom check

Each `#guard_msgs` block pins the exact axiom list of one result: if a proof
ever starts depending on anything not listed, the docstring stops matching the
compiler and **`lake build` fails**. This is a check, not a printout.
-/

/-- info: 'Stage3.σθ_half' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.σθ_half

/-- info: 'Stage3.zeta_ne_zero_right_of' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.zeta_ne_zero_right_of

/-- info: 'Stage3.zeroFreeRight_of_RH' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.zeroFreeRight_of_RH

/-- info: 'Stage3.zeroFreeRight_mono' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.zeroFreeRight_mono

/-- info: 'Stage3.zeroFreeRight_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.zeroFreeRight_one

/-- info: 'Stage3.logDerivZeta_crude_theta' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.logDerivZeta_crude_theta

/-- info: 'Stage3.logDerivZeta_crude_half' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.logDerivZeta_crude_half

end Stage3
