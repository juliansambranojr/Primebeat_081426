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

## H1 The two contour legs — PROVED (unit 0363: `ArgLegs.im_integral_le_pi_of_re_nonneg`,
`segment_im_integral_le`, `horizontal_leg_le`, `zetaArgContour_le`)
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
           re_sign_const — L5, `∀ x ∈ Ioo a b, (g x).re ≠ 0` (no `a ≤ b`: the direct
           proof never uses it, and TRAPS row 20 refuses an unused binder) —
             `theorem re_sign_const {g : ℝ → ℂ} {a b : ℝ}
                (hcg : ContinuousOn g (Set.Icc a b))
                (hne : ∀ x ∈ Set.Ioo a b, (g x).re ≠ 0) :
                (∀ x ∈ Set.Icc a b, 0 ≤ (g x).re) ∨ (∀ x ∈ Set.Icc a b, (g x).re ≤ 0)`
             (the direct route, unit 0363: two points of `Icc a b` with strictly
             opposite signs of `Re g` put a zero of `Re g` strictly between them by
             `intermediate_value_Icc` on `Complex.re ∘ g`, hence inside `Ioo a b`,
             against `hne`; so no two points disagree strictly, which is the
             disjunction. No closure argument is needed.)
           segment_im_integral_le — L1–L5, Z1 —
             `theorem segment_im_integral_le {g g' : ℝ → ℂ} {a b : ℝ} (hab : a ≤ b)
                (hd : ∀ x ∈ Set.Icc a b, HasDerivAt g (g' x) x)
                (hne : ∀ x ∈ Set.Icc a b, g x ≠ 0)
                (hc : ContinuousOn (fun x => g' x / g x) (Set.Icc a b))
                (hcg : ContinuousOn g (Set.Icc a b))
                (Z : Finset ℝ) (hZ : ∀ x ∈ Set.Ioo a b, (g x).re = 0 → x ∈ Z) :
                |(∫ x in a..b, g' x / g x).im| ≤ Real.pi * ((Z.card : ℝ) + 1)`
             (strong induction on `Z.card` generalising both `a` and `b`, since the
             split keeps the left piece for the induction hypothesis: if no `z ∈ Z` lies in
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
                |Stage3.zetaArgContour T| ≤ (Z.card : ℝ) + 3 / 2`
             (unfold; `|(1/π)(A − B)| ≤ (1/π)(|A| + |B|) ≤ (1/π)(π/2 + π(card+1))`; the two
             leg lemmas; `abs_sub` triangle, `div` by `Real.pi_pos`.)
Composes.  Exact statements, so the builder opens no other module:
             `Stage3.zetaArgContour (T : ℝ) : ℝ :=   -- Stage3/ArgIdentity.lean declares `namespace Stage3`
                (1 / Real.pi) * ((∫ t in (0:ℝ)..T, logDeriv riemannZeta (2 + (t : ℂ) * Complex.I)).re
                  - (∫ x in (1/2:ℝ)..2, logDeriv riemannZeta ((x : ℂ) + T * Complex.I)).im)`
             `Stage3.logDeriv_zeta_continuousAt {z : ℂ} (hz1 : z ≠ 1)
                (hzζ : riemannZeta z ≠ 0) : ContinuousAt (logDeriv riemannZeta) z`
             (the enclosing namespace is read off `grep -n '^namespace\|^end ' <file>`,
             TRAPS row 32, unit 0363: the file is `ArgIdentity.lean` and the namespace is `Stage3`).
           Mathlib, grepped: Complex.abs_arg_le_pi_div_two_iff, Complex.mem_slitPlane_iff,
           Complex.slitPlane, HasDerivAt.clog_real, intervalIntegral.integral_eq_sub_of_hasDerivAt,
           Set.uIcc_of_le, ContinuousOn.intervalIntegrable, Complex.log_im,
           Complex.arg_ofReal_of_nonneg, riemannZeta_two, differentiableAt_riemannZeta,
           HasDerivAt.comp_ofReal, HasDerivAt.neg, logDeriv_apply,
           intervalIntegral.integral_add_adjacent_intervals, intervalIntegral.integral_neg,
           intermediate_value_Icc, closure_Ioo, ContinuousOn.preimage_isClosed_of_isClosed,
           Finset.induction_on_max, Finset.max'_mem, Finset.le_max', Finset.card_erase_of_mem.
           Candidates the builder greps under LOOP.md § 2: neg_div_neg_eq, abs_sub_le,
           abs_add_le (TRAPS row 17: `abs_add` is the old name), isClosed_Icc, isClosed_Ici, Complex.sub_im, Complex.add_im, Complex.mul_im,
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

## H2 The count: zeros of Re ζ on the segment, and Re ζ > 0 on the line Re s = 2 — SKETCH
Objects.   Two things H1 takes as hypotheses. T3, `Re ζ(2+it) > 0`: from the
           Dirichlet series at `Re s = 2`, `ζ(s) − 1 = Σ_{n≥1} 1/(n+1)^s`
           (`zeta_eq_tsum_one_div_nat_add_one_cpow` with its `n = 0` term
           peeled off), `‖1/(n+1)^s‖ = 1/(n+1)²` (`norm_cpow_eq_rpow_re_of_pos`,
           `Real.rpow_natCast`), and `Σ_{n≥1} 1/(n+1)² = π²/6 − 1`
           (`hasSum_zeta_two` peeled twice), so `‖ζ(s) − 1‖ ≤ π²/6 − 1 < 1` and
           `Re ζ(s) ≥ 2 − π²/6 > 0.35` (`Real.pi_lt_d2`: `π² < 9.93`).
           Z2 with a bound: the zeros of `x ↦ Re ζ(x+iT)` on `(1/2, 2)` are the
           real zeros `z = (x−2)/2 ∈ (−3/4, 0)` of
           `G_T(z) = ζ(2z+2+iT) + ζ(2z+2−iT)`, since for real `z` the second
           term is the conjugate of the first (`riemannZeta_conj`,
           `Complex.add_conj`: `w + conj w = 2 Re w`). `G_T(0) = 2 Re ζ(2+iT) > 0`,
           so `F_T = G_T / G_T(0)` has `F_T(0) = 1`, is analytic on the closed
           unit disk (both arguments avoid `1`: their real part is `1` only at
           `Re z = −1/2`, where `|Im z| < 1 ≤ T/2` keeps the imaginary part
           `2 Im z ± T` away from `0`), and `‖F_T‖ ≤ 80T` on the `15/16` disk
           (`zeta_disk_upper` twice, the second through `riemannZeta_conj` and
           `Complex.norm_conj`, over `|G_T(0)| ≥ 2(2 − π²/6) ≥ 0.7`). Upstream's
           `ZerosBound` at `r = 7/8`, `R = 15/16` then counts the zeros of `F_T`
           in the `7/8` disk with multiplicity by `log(80T)/log(15/14) ≤ 15 log T + 73`,
           the arithmetic `JensenCount.zeta_local_zero_count` already did at `84T`.
           The zeros of `Re ζ` on the segment inject into that set, each with
           order at least `1` (`AnalyticAt.analyticOrderAt_eq_zero`, and the order
           is finite because `F_T` is not eventually zero at any point of a
           disk on which it is `1` at the centre: `analyticOrderAt_eq_top` against
           `AnalyticOnNhd.eqOn_zero_of_preconnected_of_mem_closure`). Finiteness of
           the zero set is the template of `JensenCount.zetaWindowTwo_finite`:
           an infinite subset of a compact disk has an accumulation point
           (`Set.Infinite.exists_accPt_of_subset_isCompact`), which forces
           `F_T ≡ 0` on the ball against `F_T(0) = 1`.
Sizes.     `q(T) ≤ 15 log T + 73`. The constant is the same Jensen geometry as
           the local zero count and is where the crude `15` in the band comes
           from; a sharper disk ratio would need ζ bounded on a larger disk, which
           is the sharp-constant work the leaf's budget records. Lost factor:
           none, the count is what Backlund's method gives at these radii.
Regime.    C1 `2 ≤ T`.
Defs.      `def G (T : ℝ) (z : ℂ) : ℂ :=
              riemannZeta (2 * z + 2 + Complex.I * (T : ℂ)) + riemannZeta (2 * z + 2 - Complex.I * (T : ℂ))`
           `def F (T : ℝ) (z : ℂ) : ℂ := G T z / G T 0`
           `def reZeroSet (T : ℝ) : Set ℝ :=
              {x : ℝ | x ∈ Set.Ioo (1/2 : ℝ) 2 ∧ (riemannZeta ((x : ℂ) + T * Complex.I)).re = 0}`
Theorems.  Written as the Lean statements the module carries; the builder
           copies them.
           norm_zeta_sub_one_le — `s.re = 2` —
             `theorem norm_zeta_sub_one_le {s : ℂ} (hs : s.re = 2) :
                ‖riemannZeta s - 1‖ ≤ Real.pi ^ 2 / 6 - 1`
             (rewrite `ζ s` by `zeta_eq_tsum_one_div_nat_add_one_cpow` (`1 < s.re` from
             `hs`), peel `n = 0` with `Summable.tsum_eq_zero_add` and
             `Complex.summable_one_div_nat_cpow`-style summability of the shifted
             series (`summable_nat_add_iff`), the peeled term is `1/1^s = 1`
             (`Complex.one_cpow`); `norm_tsum_le_tsum_norm`; each norm is
             `1/((n+2:ℝ))^2` by `norm_cpow_eq_rpow_re_of_pos`, `hs`, `Real.rpow_natCast`;
             the real series sums to `π²/6 − 1` from `hasSum_zeta_two` with two terms
             peeled (`HasSum.sum_range_add`-style, or `Summable.tsum_eq_zero_add` twice
             on the real side), the `n = 0` term being `0` in Lean and the `n = 1`
             term `1`.)
           re_zeta_two_line_ge — none —
             `theorem re_zeta_two_line_ge (t : ℝ) :
                2 - Real.pi ^ 2 / 6 ≤ (riemannZeta (2 + (t : ℂ) * Complex.I)).re`
             (norm_zeta_sub_one_le at `s = 2 + tI` (`Complex.add_re`, `Complex.mul_re`
             give `re = 2`); `Complex.abs_re_le_norm` on `ζ s − 1` and `Complex.sub_re`.)
           re_zeta_two_line_pos — none —
             `theorem re_zeta_two_line_pos (t : ℝ) : 0 < (riemannZeta (2 + (t : ℂ) * Complex.I)).re`
             (re_zeta_two_line_ge and `Real.pi_lt_d2`: `π² < 3.15² < 12`, `nlinarith`.)
           G_zero_eq — none —
             `theorem G_zero_eq (T : ℝ) : G T 0 = ((2 * (riemannZeta (2 + Complex.I * (T : ℂ))).re : ℝ) : ℂ)`
             (unfold; `2 - I*T = conj (2 + I*T)` by `Complex.ext_iff`; `riemannZeta_conj`;
             `Complex.add_conj`.)
           G_real — none —
             `theorem G_real (T : ℝ) (x : ℝ) :
                G T (x : ℂ) = ((2 * (riemannZeta (2 * (x : ℂ) + 2 + Complex.I * (T : ℂ))).re : ℝ) : ℂ)`
             (the same with `2x + 2 − iT = conj (2x + 2 + iT)` for real `x`.)
           G_zero_ne — C1 —
             `theorem G_zero_ne {T : ℝ} (hT : 2 ≤ T) : G T 0 ≠ 0`
             (G_zero_eq, re_zeta_two_line_pos at `t = T` after `Complex.I * T = T * I`
             by `mul_comm`, `Complex.ofReal_ne_zero`.)
           F_zero_eq_one — C1 —
             `theorem F_zero_eq_one {T : ℝ} (hT : 2 ≤ T) : F T 0 = 1`
             (`div_self (G_zero_ne hT)`.)
           arg_ne_one — C1, `‖z‖ < 11/10` —
             `theorem arg_ne_one {T : ℝ} (hT : 2 ≤ T) {z : ℂ} (hz : ‖z‖ < 11 / 10) :
                2 * z + 2 + Complex.I * (T : ℂ) ≠ 1 ∧ 2 * z + 2 - Complex.I * (T : ℂ) ≠ 1`
             (if either equals `1`, `Complex.ext_iff` gives `re z = −1/2` and
             `2 im z = ∓T`, so `|im z| = T/2 ≥ 1`; then `‖z‖² = 1/4 + (im z)² ≥ 5/4`
             against `‖z‖² < 121/100` (`Complex.sq_norm`, `Complex.normSq_apply`).)
           F_analytic — C1 —
             `theorem F_analytic {T : ℝ} (hT : 2 ≤ T) :
                AnalyticOnNhd ℂ (F T) (Metric.closedBall (0 : ℂ) 1)`
             (template `JensenCount.jensenF_analytic`; `analyticAt_riemannZeta` at both
             arguments by arg_ne_one (`‖z‖ ≤ 1 < 11/10`), composed with the affine maps
             (`AnalyticAt.comp`, `analyticAt_id`, `analyticAt_const`, `AnalyticAt.add`,
             `AnalyticAt.mul`), `AnalyticAt.add`, then `AnalyticAt.div` by the constant
             `G T 0 ≠ 0`.)
           F_bound — C1, `‖z‖ ≤ 15/16` —
             `theorem F_bound {T : ℝ} (hT : 2 ≤ T) {z : ℂ} (hz : ‖z‖ ≤ 15 / 16) :
                ‖F T z‖ ≤ 80 * T`
             (`‖G T z‖ ≤ 28T + 28T`: `JensenCount.zeta_disk_upper` at `w = 2z+2+iT`,
             `‖w − (2+iT)‖ = 2‖z‖ ≤ 15/8`; for the second argument write it as
             `conj (2 (conj z) + 2 + iT)`, `riemannZeta_conj`, `Complex.norm_conj`, and
             `zeta_disk_upper` at `conj z` (`Complex.norm_conj` again for `‖conj z‖`);
             `‖G T 0‖ = 2 Re ζ(2+iT) ≥ 2(2 − π²/6) ≥ 7/10` by G_zero_eq,
             re_zeta_two_line_ge, `Complex.norm_real`, `Real.pi_lt_d2`; then
             `norm_div`, `div_le_iff₀`-style: `56T/(7/10) = 80T`.)
           F_zeros_finite — C1 —
             `theorem F_zeros_finite {T : ℝ} (hT : 2 ≤ T) : (SetOfZeros 1 (F T)).Finite`
             (template `JensenCount.zetaWindowTwo_finite`: by contradiction,
             `Set.Infinite.exists_accPt_of_subset_isCompact` with `isCompact_closedBall 0 1`,
             analyticity on `Metric.ball 0 (11/10)` from arg_ne_one,
             `AnalyticOnNhd.eqOn_zero_of_preconnected_of_mem_closure` with
             `Metric.isPreconnected_ball`, `mem_closure_iff_clusterPt`,
             `accPt_principal_iff_clusterPt`; the conclusion `F T 0 = 0` against
             F_zero_eq_one.)
           F_count_le — C1 —
             `theorem F_count_le {T : ℝ} (hT : 2 ≤ T) :
                ∑ ρ ∈ (finiteSetOfZeros_mono (by norm_num : (7:ℝ)/8 < 1) (F_zeros_finite hT)).toFinset,
                    (analyticOrderNatAt (F T) ρ : ℝ)
                  ≤ 15 * Real.log T + 73`
             (`ZerosBound (B := 80 * T) (r := 7/8) (R := 15/16) (f := F T)` with the
             four numeric side conditions, F_analytic, F_zero_eq_one, F_zeros_finite,
             F_bound; then the arithmetic of `JensenCount.zeta_local_zero_count`
             from `log(80T)` in place of `log(84T)`: `Real.log_mul`, `Real.log_le_sub_one_of_pos`
             or the numeral `Real.log 80 < 4.39` from `Real.exp_one_gt_d9`-style bounds,
             `1/log(15/14) ≤ 14.5`; `15 log T + 73` is what the `84T` chain proved and
             `80T` is smaller, so reuse its final inequality if it is a named lemma.)
           reZeroSet_finite — C1 —
             `theorem reZeroSet_finite {T : ℝ} (hT : 2 ≤ T) : (reZeroSet T).Finite`
             (the map `x ↦ ((x − 2)/2 : ℂ)` is injective and sends `reZeroSet T` into
             `SetOfZeros (7/8) (F T)`: for `x ∈ (1/2, 2)`, `‖(x−2)/2‖ < 3/4`, and
             `F T z = 0 ↔ G T z = 0` (`div_eq_zero_iff`, G_zero_ne) `↔ Re ζ(2z+2+iT) = 0`
             by G_real with `2z + 2 = x`; `Set.Finite.preimage` with
             `Set.injOn_of_injective`, `Set.Finite.subset`.)
           reZeros — C1 —
             `def reZeros {T : ℝ} (hT : 2 ≤ T) : Finset ℝ := (reZeroSet_finite hT).toFinset`
           mem_reZeros — C1 —
             `theorem mem_reZeros {T : ℝ} (hT : 2 ≤ T) {x : ℝ} :
                x ∈ reZeros hT ↔ x ∈ Set.Ioo (1/2 : ℝ) 2 ∧ (riemannZeta ((x : ℂ) + T * Complex.I)).re = 0`
             (`Set.Finite.mem_toFinset`, unfold `reZeroSet`.)
           card_reZeros_le — C1 —
             `theorem card_reZeros_le {T : ℝ} (hT : 2 ≤ T) :
                ((reZeros hT).card : ℝ) ≤ 15 * Real.log T + 73`
             (the injection of reZeroSet_finite lands in the `7/8` zero set, so
             `(reZeros hT).card ≤` that set's card (`Finset.card_le_card_of_injOn`);
             each zero has `analyticOrderNatAt (F T) ρ ≥ 1`: the order is not `⊤`
             because `F T` is not eventually zero near `ρ` (else `F T ≡ 0` on the ball
             by the preconnected lemma, against `F T 0 = 1`), and not `0` because
             `F T ρ = 0` (`AnalyticAt.analyticOrderAt_eq_zero`); so
             `card ≤ Σ analyticOrderNatAt` (`Finset.card_eq_sum_ones`, `Finset.sum_le_sum`,
             `Nat.one_le_iff_ne_zero`) and F_count_le.)
Composes.  Exact statements, so the builder opens no other module:
             `JensenCount.zeta_disk_upper {T : ℝ} (hT : 2 ≤ T) {w : ℂ}
                (hw : ‖w - (2 + Complex.I * (T : ℂ))‖ ≤ 15 / 8) : ‖ζ w‖ ≤ 28 * T`
             `JensenCount.zeta_centre_ne_zero (T : ℝ) : ζ (2 + Complex.I * (T : ℂ)) ≠ 0`
             `ZerosBound {B r R : ℝ} {f : ℂ → ℂ}
                (r_pos : 0 < r) (r_lt_one : r < 1) (r_lt_R : r < R) (R_lt_one : R < 1)
                (hfAnalytic : AnalyticOnNhd ℂ f (Metric.closedBall (0 : ℂ) 1)) (hf0_eq_one : f 0 = 1)
                (finiteZeros : (SetOfZeros 1 f).Finite) (fz_bound : ∀ z : ℂ, ‖z‖ ≤ R → ‖f z‖ ≤ B) :
                ∑ ρ ∈ (finiteSetOfZeros_mono r_lt_one finiteZeros).toFinset, analyticOrderNatAt f ρ ≤
                  1 / Real.log (R / r) * Real.log B`   (upstream StrongPNT.lean)
             `SetOfZeros (R : ℝ) (f : ℂ → ℂ) : Set ℂ := {ρ : ℂ | ‖ρ‖ ≤ R ∧ f ρ = 0}`   (upstream)
             `finiteSetOfZeros_mono {r : ℝ} {f : ℂ → ℂ}` (upstream, a `lemma`; its two
                arguments are `r < 1` and `(SetOfZeros 1 f).Finite`, as `zeta_local_zero_count` calls it)
             the arithmetic tail of `JensenCount.zeta_local_zero_count` from
                `1 / Real.log (15/16 / (7/8)) * Real.log (84 * T)` to `15 * Real.log T + 73`
                (read those lines only if the numeral chain is not a separate lemma).
           Mathlib, grepped: zeta_eq_tsum_one_div_nat_add_one_cpow, Complex.summable_one_div_nat_cpow,
           norm_cpow_eq_rpow_re_of_pos, Real.rpow_natCast, hasSum_zeta_two, norm_tsum_le_tsum_norm,
           Summable.tsum_eq_zero_add, riemannZeta_conj, Complex.add_conj, Complex.norm_conj,
           Real.pi_lt_d2, analyticAt_riemannZeta, AnalyticOnNhd.eqOn_zero_of_preconnected_of_mem_closure,
           Metric.isPreconnected_ball, Set.Infinite.exists_accPt_of_subset_isCompact,
           accPt_principal_iff_clusterPt, mem_closure_iff_clusterPt, isCompact_closedBall,
           AnalyticAt.analyticOrderAt_eq_zero, analyticOrderAt_eq_top, analyticOrderNatAt,
           Complex.abs_re_le_norm, Complex.sq_norm, Complex.normSq_apply, Finset.card_le_card_of_injOn,
           Finset.sum_le_sum, Nat.one_le_iff_ne_zero, Set.Finite.preimage, Set.Finite.subset,
           Set.Finite.mem_toFinset.
           Candidates the builder greps under LOOP.md § 2: summable_nat_add_iff, Complex.one_cpow,
           Complex.norm_real, Complex.ofReal_ne_zero, div_eq_zero_iff, Set.injOn_of_injective,
           Finset.card_eq_sum_ones, AnalyticAt.div, AnalyticAt.add, AnalyticAt.comp, analyticAt_id,
           analyticAt_const, Real.log_mul, div_le_iff₀.
Module.    Stage3/ReZetaCount.lean, namespace ReZetaCount, importing Stage3.JensenCount;
           pins: re_zeta_two_line_pos, F_count_le, card_reZeros_le, mem_reZeros.
           Built under the relay (LOOP.md § 4b).
Open.      H3 assembles: at a good height `argS T = zetaArgContour T`, H1 with
           `Z = reZeros hT`, this block's `hpos`, and `hgood` from the height being
           good; at a bad height the left limit.
Arithmetic checked here: `π²/6 − 1 < 1` since `π² < 12`; `2(2 − π²/6) = 4 − π²/3 > 4 − 3.31 = 0.69`;
`56T / 0.7 = 80T`; `log(80T)/log(15/14) ≤ 14.5 log T + 14.5·4.39 = 14.5 log T + 63.7 ≤ 15 log T + 73`
for `T ≥ 2`; for real `x ∈ (1/2, 2)`, `(x − 2)/2 ∈ (−3/4, 0)`, inside the `7/8` disk.
