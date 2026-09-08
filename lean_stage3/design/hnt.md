# hNT worksheet — the count-to-argument step

The statement this worksheet targets, copied from the tree and restated
nowhere else. `Stage3/ArgCrude.lean`:

    def StmtSCrude (S : ℝ → ℝ) (B₁ B₃ : ℝ) : Prop :=
      ∀ T : ℝ, 2 ≤ T → |S T| ≤ B₁ * Real.log T + B₃

to be earned at `S = argS` with explicit crude `B₁ B₃`. What it delivers,
by theorems already in the tree: `backlundArg_of_identity stmtArgIdentity_holds`
gives `StmtBacklundArg phaseTheta B₁ B₃`, and `RvM_of_phase_arg backlundPhase_holds`
gives `riemannZeta.Riemann_vonMangoldt_bound (97 + B₁) 0 (98 + B₃)`. Entry 130's
census budget is `B₁ + 97 ≤ 100`; at the Jensen constant `15` this chain lands
at `112`, over by twelve, and that is recorded here before the first module,
so the outcome is a crude sorry-free hNT band that misses the census budget
unless the Stirling half's `97` is also trimmed.

Objects are read at the tree, never defined here (`DESIGN.md` v10).

    def argS (T : ℝ) : ℝ := riemannZeta.N T - (phaseTheta T / Real.pi + 1)
      -- Stage3/ArgIdentity.lean; riemannZeta.N T = zeroes_sum univ (Ioo 0 T) 1 (upstream),
      -- zeros with 0 < Im ρ < T counted with multiplicity, so N is left-continuous in T
    def zetaArgContour (T : ℝ) : ℝ :=
      (1 / Real.pi) * ((∫ t in (0:ℝ)..T, logDeriv riemannZeta (2 + (t : ℂ) * Complex.I)).re
        - (∫ x in (1/2:ℝ)..2, logDeriv riemannZeta ((x : ℂ) + T * Complex.I)).im)
    theorem argS_eq_zetaArgContour {T : ℝ} (hT : 2 ≤ T)
        (hgood : ∀ ρ : ℂ, riemannZeta ρ = 0 → 0 < ρ.re → ρ.im ≠ T) :
        argS T = zetaArgContour T
    def phaseTheta (T : ℝ) : ℝ :=
      (1 / 2) * (∫ t in (0 : ℝ)..T, phasePoint t) - T / 2 * Real.log Real.pi
      -- Stage3/Stirling.lean, with `continuous_phasePoint : Continuous phasePoint`

The plan, three blocks, hardest first. H1 the two contour legs: on a
segment where the path avoids `0`, the imaginary part of `∫ g'/g` moves by
at most `π` between consecutive zeros of `Re g`, so the horizontal leg is at
most `π(q + 1)` with `q` the number of those zeros on `[1/2, 2]`, and the
vertical leg at `Re s = 2` is at most `π/2` because `Re ζ > 0` there. H2 the
count: `q ≤ 15 log T + 64` by Jensen on `G_T(z) = ζ(2z+2+iT) + ζ(2z+2−iT)`,
the template of `JensenCount.zeta_local_zero_count`, and `Re ζ(2+it) ≥ 2 − ζ(2)`
from the Dirichlet series. H3 the assembly: at good heights the identity,
at bad heights the left limit through `N` left-continuous and `phaseTheta`
continuous, then `StmtSCrude argS 15 66` and the band `(112, 0, 164)`.

## H1 The two contour legs — SKETCH
Objects.   `g : ℝ → ℂ` a path with `HasDerivAt g (g' x) x` on `[a, b]`, never
           `0` there. Where `0 ≤ Re g` on `[a, b]` the values sit in the slit
           plane (`0 < re ∨ im ≠ 0`, `Complex.slitPlane`), `log ∘ g` has
           derivative `g'/g` (`HasDerivAt.clog_real`), so
           `∫_a^b g'/g = log g(b) − log g(a)` and its imaginary part is a
           difference of two arguments in `[−π/2, π/2]`
           (`Complex.abs_arg_le_pi_div_two_iff`), at most `π`. Where
           `Re g ≤ 0` the same at `−g`, whose `g'/g` is unchanged. On a segment
           whose zeros of `Re g` inside `(a, b)` lie in a finite `Z`, split
           at the largest such zero and induct on `Z`: at most `π(|Z| + 1)`.
           At `ζ`: the horizontal leg is `g x = ζ(x + iT)` on `[1/2, 2]`,
           `g' = deriv ζ`, so `g'/g = logDeriv ζ`; the vertical leg is
           `g t = ζ(2 + it)`, `g' = I · deriv ζ`, `g'/g = I · logDeriv ζ`, and
           `Im(I·w) = Re w`, giving `Re ∫ logDeriv = arg ζ(2+iT) − arg ζ(2)`
           with `ζ(2) = π²/6` real positive (`riemannZeta_two`).
Sizes.     Exact: the two legs give `|zetaArgContour T| ≤ q + 3/2`. Nothing
           is lost; the crude part is `q`'s bound, which is H2's.
Regime.    L1 `a ≤ b`;  L2 `∀ x ∈ Icc a b, HasDerivAt g (g' x) x`;
           L3 `∀ x ∈ Icc a b, g x ≠ 0`;
           L4 `ContinuousOn (fun x => g' x / g x) (Icc a b)`;
           L5 `ContinuousOn g (Icc a b)`;
           Z1 `∀ x ∈ Ioo a b, (g x).re = 0 → x ∈ Z` for a `Z : Finset ℝ`;
           at `ζ`: T1 `2 ≤ T`;  T2 `∀ x ∈ Icc (1/2) 2, riemannZeta ((x:ℂ) + T * I) ≠ 0`;
           T3 `∀ t ∈ Icc 0 T, 0 < (riemannZeta (2 + (t:ℂ) * I)).re`;
           Z2 `∀ x ∈ Ioo (1/2) 2, (riemannZeta ((x:ℂ) + T * I)).re = 0 → x ∈ Z`.
Defs.      none.
Theorems.  Written as the Lean statements the module carries; the builder
           copies them.
           abs_arg_sub_le_pi — none —
             `theorem abs_arg_sub_le_pi {z w : ℂ} (hz : 0 ≤ z.re) (hw : 0 ≤ w.re) :
                |z.arg - w.arg| ≤ Real.pi`
             (`Complex.abs_arg_le_pi_div_two_iff` twice, `abs_sub_le`-style triangle,
             `linarith`.)
           mem_slitPlane_of_re_nonneg — none —
             `theorem mem_slitPlane_of_re_nonneg {z : ℂ} (hz : 0 ≤ z.re) (hne : z ≠ 0) :
                z ∈ Complex.slitPlane`
             (`Complex.mem_slitPlane_iff`; if `re = 0` then `im ≠ 0` by `Complex.ext_iff`
             against `hne`.)
           integral_logDeriv_eq_log_sub — L1, L2, L4, and slit-plane values —
             `theorem integral_logDeriv_eq_log_sub {g g' : ℝ → ℂ} {a b : ℝ} (hab : a ≤ b)
                (hd : ∀ x ∈ Set.Icc a b, HasDerivAt g (g' x) x)
                (hs : ∀ x ∈ Set.Icc a b, g x ∈ Complex.slitPlane)
                (hc : ContinuousOn (fun x => g' x / g x) (Set.Icc a b)) :
                ∫ x in a..b, g' x / g x = Complex.log (g b) - Complex.log (g a)`
             (`intervalIntegral.integral_eq_sub_of_hasDerivAt` with
             `Set.uIcc_of_le hab`; the derivative at each `x` is `(hd x hx).clog_real (hs x hx)`;
             integrability from `hc.intervalIntegrable` after `Set.uIcc_of_le`.)
           im_integral_le_pi_of_re_nonneg — L1, L2, L3, L4, `∀ x ∈ Icc a b, 0 ≤ (g x).re` —
             `theorem im_integral_le_pi_of_re_nonneg {g g' : ℝ → ℂ} {a b : ℝ} (hab : a ≤ b)
                (hd : ∀ x ∈ Set.Icc a b, HasDerivAt g (g' x) x)
                (hne : ∀ x ∈ Set.Icc a b, g x ≠ 0)
                (hre : ∀ x ∈ Set.Icc a b, 0 ≤ (g x).re)
                (hc : ContinuousOn (fun x => g' x / g x) (Set.Icc a b)) :
                |(∫ x in a..b, g' x / g x).im| ≤ Real.pi`
             (integral_logDeriv_eq_log_sub, `Complex.sub_im`, `Complex.log_im`,
             abs_arg_sub_le_pi at `b` and `a`.)
           im_integral_le_pi_of_re_nonpos — the same with `(g x).re ≤ 0` —
             `theorem im_integral_le_pi_of_re_nonpos {g g' : ℝ → ℂ} {a b : ℝ} (hab : a ≤ b)
                (hd : ∀ x ∈ Set.Icc a b, HasDerivAt g (g' x) x)
                (hne : ∀ x ∈ Set.Icc a b, g x ≠ 0)
                (hre : ∀ x ∈ Set.Icc a b, (g x).re ≤ 0)
                (hc : ContinuousOn (fun x => g' x / g x) (Set.Icc a b)) :
                |(∫ x in a..b, g' x / g x).im| ≤ Real.pi`
             (apply the nonneg version to `-g` with derivative `-g'` (`HasDerivAt.neg`);
             `(-g' x) / (-g x) = g' x / g x` by `neg_div_neg_eq`, so the integrand is
             the same function after `funext`.)
           re_sign_const — L1, L5, `∀ x ∈ Ioo a b, (g x).re ≠ 0` —
             `theorem re_sign_const {g : ℝ → ℂ} {a b : ℝ} (hab : a ≤ b)
                (hcg : ContinuousOn g (Set.Icc a b))
                (hne : ∀ x ∈ Set.Ioo a b, (g x).re ≠ 0) :
                (∀ x ∈ Set.Icc a b, 0 ≤ (g x).re) ∨ (∀ x ∈ Set.Icc a b, (g x).re ≤ 0)`
             (if `a = b` both hold trivially from... take the left disjunct only
             when `0 ≤ (g a).re`, else the right; for `a < b`: two points of `Ioo`
             with opposite strict signs give a zero between them by
             `intermediate_value_Icc` on `Complex.re ∘ g`, against `hne`; so
             `Ioo` has one sign; it extends to `Icc` because `{x | 0 ≤ (g x).re} ∩ Icc`
             is closed in `Icc` (`ContinuousOn.preimage_isClosed_of_isClosed` with
             `isClosed_Icc`, `isClosed_Ici`) and contains `Ioo`, whose closure is
             `Icc` (`closure_Ioo hab.ne`).)
           segment_im_integral_le — L1–L5, Z1 —
             `theorem segment_im_integral_le {g g' : ℝ → ℂ} {a b : ℝ} (hab : a ≤ b)
                (hd : ∀ x ∈ Set.Icc a b, HasDerivAt g (g' x) x)
                (hne : ∀ x ∈ Set.Icc a b, g x ≠ 0)
                (hc : ContinuousOn (fun x => g' x / g x) (Set.Icc a b))
                (hcg : ContinuousOn g (Set.Icc a b))
                (Z : Finset ℝ) (hZ : ∀ x ∈ Set.Ioo a b, (g x).re = 0 → x ∈ Z) :
                |(∫ x in a..b, g' x / g x).im| ≤ Real.pi * ((Z.card : ℝ) + 1)`
             (strong induction on `Z.card` generalising `a`: if no `z ∈ Z` lies in
             `Ioo a b`, then `hZ` gives `hne` for re_sign_const, and one of the two
             piece lemmas closes with bound `π ≤ π(card+1)`; else let `z` be the
             largest element of `Z.filter (· ∈ Ioo a b)` (`Finset.max'`), split
             `∫_a^b = ∫_a^z + ∫_z^b` by `intervalIntegral.integral_add_adjacent_intervals`
             (both integrable from `hc` restricted), bound `∫_z^b` by a piece lemma
             (no element of `Z` in `Ioo z b` by maximality, re_sign_const there) and
             `∫_a^z` by the induction hypothesis at `Z.erase z` (`Finset.card_erase_of_mem`;
             every zero of `Re g` in `Ioo a z` is in `Z` and is not `z`); `Complex.add_im`,
             `abs_add`, arithmetic.)
           vertical_leg_le — T1, T3 —
             `theorem vertical_leg_le {T : ℝ} (hT : 2 ≤ T)
                (hpos : ∀ t ∈ Set.Icc (0:ℝ) T, 0 < (riemannZeta (2 + (t : ℂ) * Complex.I)).re) :
                |(∫ t in (0:ℝ)..T, logDeriv riemannZeta (2 + (t : ℂ) * Complex.I)).re|
                  ≤ Real.pi / 2`
             (`g t = riemannZeta (2 + t*I)`, `g' t = Complex.I * deriv riemannZeta (2 + t*I)`:
             `HasDerivAt` from `differentiableAt_riemannZeta` (the point is `≠ 1` since
             its real part is `2`) composed with the path `t ↦ 2 + t*I`, via
             `HasDerivAt.comp_ofReal` on `e z = ζ (2 + z*I)` whose derivative is
             `deriv ζ (2+z*I) * I` (`HasDerivAt.comp` with `hasDerivAt_id`, `HasDerivAt.mul_const`,
             `HasDerivAt.const_add`). `g'/g = I * logDeriv ζ(2+tI)` by `logDeriv_apply`
             and `mul_div_assoc`; `Complex.mul_im` with `I` gives `Re ∫ logDeriv = Im ∫ g'/g`
             through `intervalIntegral.integral_const_mul`; then integral_logDeriv_eq_log_sub,
             `Complex.log_im`, `riemannZeta_two`, `Complex.arg_ofReal_of_nonneg` for
             `arg ζ(2) = 0`, `Complex.abs_arg_le_pi_div_two_iff` at `ζ(2+iT)`.)
           horizontal_leg_le — T1, T2, Z2 —
             `theorem horizontal_leg_le {T : ℝ} (hT : 2 ≤ T)
                (hgood : ∀ x ∈ Set.Icc (1/2:ℝ) 2, riemannZeta ((x : ℂ) + T * Complex.I) ≠ 0)
                (Z : Finset ℝ)
                (hZ : ∀ x ∈ Set.Ioo (1/2:ℝ) 2, (riemannZeta ((x : ℂ) + T * Complex.I)).re = 0 → x ∈ Z) :
                |(∫ x in (1/2:ℝ)..2, logDeriv riemannZeta ((x : ℂ) + T * Complex.I)).im|
                  ≤ Real.pi * ((Z.card : ℝ) + 1)`
             (segment_im_integral_le with `g x = ζ (x + T*I)`, `g' x = deriv ζ (x + T*I)`;
             `HasDerivAt` via `HasDerivAt.comp_ofReal` on `e z = ζ (z + T*I)`; the point is
             `≠ 1` because its imaginary part is `T ≥ 2`; `logDeriv_apply` rewrites the
             integrand; `hc` from `logDeriv_zeta_continuousAt` at each point,
             `ContinuousAt.continuousOn`-style; `hcg` from `differentiableAt_riemannZeta`.)
           zetaArgContour_le — T1, T2, T3, Z2 —
             `theorem zetaArgContour_le {T : ℝ} (hT : 2 ≤ T)
                (hpos : ∀ t ∈ Set.Icc (0:ℝ) T, 0 < (riemannZeta (2 + (t : ℂ) * Complex.I)).re)
                (hgood : ∀ x ∈ Set.Icc (1/2:ℝ) 2, riemannZeta ((x : ℂ) + T * Complex.I) ≠ 0)
                (Z : Finset ℝ)
                (hZ : ∀ x ∈ Set.Ioo (1/2:ℝ) 2, (riemannZeta ((x : ℂ) + T * Complex.I)).re = 0 → x ∈ Z) :
                |ArgIdentity.zetaArgContour T| ≤ (Z.card : ℝ) + 3 / 2`
             (unfold; `|(1/π)(A − B)| ≤ (1/π)(|A| + |B|) ≤ (1/π)(π/2 + π(card+1))`; the two
             leg lemmas; `abs_sub` triangle, `div` by `Real.pi_pos`.)
Composes.  Exact statements, so the builder opens no other module:
             `ArgIdentity.zetaArgContour (T : ℝ) : ℝ :=
                (1 / Real.pi) * ((∫ t in (0:ℝ)..T, logDeriv riemannZeta (2 + (t : ℂ) * Complex.I)).re
                  - (∫ x in (1/2:ℝ)..2, logDeriv riemannZeta ((x : ℂ) + T * Complex.I)).im)`
             `ArgIdentity.logDeriv_zeta_continuousAt {z : ℂ} (hz1 : z ≠ 1)
                (hzζ : riemannZeta z ≠ 0) : ContinuousAt (logDeriv riemannZeta) z`
             (the namespace of `zetaArgContour` and this lemma is whatever
             `Stage3/ArgIdentity.lean` declares; the builder reads the two declaring
             lines only if the names above do not resolve).
           Mathlib, grepped: Complex.abs_arg_le_pi_div_two_iff, Complex.mem_slitPlane_iff,
           Complex.slitPlane, HasDerivAt.clog_real, intervalIntegral.integral_eq_sub_of_hasDerivAt,
           Set.uIcc_of_le, ContinuousOn.intervalIntegrable, Complex.log_im,
           Complex.arg_ofReal_of_nonneg, riemannZeta_two, differentiableAt_riemannZeta,
           HasDerivAt.comp_ofReal, HasDerivAt.neg, logDeriv_apply,
           intervalIntegral.integral_add_adjacent_intervals, intervalIntegral.integral_neg,
           intermediate_value_Icc, closure_Ioo, ContinuousOn.preimage_isClosed_of_isClosed,
           Finset.induction_on_max, Finset.max'_mem, Finset.le_max', Finset.card_erase_of_mem.
           Candidates the builder greps under LOOP.md § 2: neg_div_neg_eq, abs_sub_le,
           abs_add, isClosed_Icc, isClosed_Ici, Complex.sub_im, Complex.add_im, Complex.mul_im,
           intervalIntegral.integral_const_mul, HasDerivAt.mul_const, HasDerivAt.const_add,
           Complex.ext_iff, Set.mem_Icc, Set.mem_Ioo.
Module.    Stage3/ArgLegs.lean, namespace ArgLegs, importing Stage3.ArgIdentity;
           pins: im_integral_le_pi_of_re_nonneg, segment_im_integral_le,
           horizontal_leg_le, zetaArgContour_le. Built under the relay
           (LOOP.md § 4b), at whatever `version:` line LOOP.md carries.
Open.      H2 supplies `Z` finite with `|Z| ≤ 15 log T + 64` and `hpos`; H3 the
           bad heights and the assembly.
Arithmetic checked here: `(1/π)(π/2 + π(q+1)) = q + 3/2`; on a piece with
`0 ≤ Re g`, `|arg g(b) − arg g(a)| ≤ π/2 + π/2 = π`; the induction adds one piece
per zero, `q` zeros give `q + 1` pieces.

