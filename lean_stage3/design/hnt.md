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
from the Dirichlet series (H2's pinned count landed at `15 log T + 73`; the
`64` planned here was the Jensen bound before the disk radius was priced).
H3 the assembly: at good heights the identity, at bad heights above `2` a
good height just below through `N` left-continuous and `phaseTheta`
continuous, then `|argS T| ≤ 15 log T + 75` for `2 < T`. The point `T = 2`
has no good height below it inside the tree's `2 ≤ T`, and the tree holds no
first-zero height, so it is bounded by a good height just above together with
the Stirling half's explicit phase bound, at `600`; so `StmtSCrude argS 15 600`
unconditionally, `StmtSCrude argS 15 75` under `good 2`, and the bands
`(112, 0, 698)` and `(112, 0, 173)`.

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

## H2 The count: zeros of Re ζ on the segment, and Re ζ > 0 on the line Re s = 2 — PROVED (unit 0364: `ReZetaCount.re_zeta_two_line_pos`,
`F_count_le`, `mem_reZeros`, `card_reZeros_le`)
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
           `Complex.norm_conj`, over `|G_T(0)| ≥ 2(2 − π²/6) ≥ 0.71`, `Real.pi_lt_d4`). Upstream's
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
           G_zero_ne — none —
             `theorem G_zero_ne (T : ℝ) : G T 0 ≠ 0`
             (G_zero_eq, re_zeta_two_line_pos at `t = T` after `Complex.I * T = T * I`
             by `mul_comm`, `Complex.ofReal_ne_zero`.)
           F_zero_eq_one — none —
             `theorem F_zero_eq_one (T : ℝ) : F T 0 = 1`
             (`div_self (G_zero_ne T)`.)
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
             (`‖G T z‖ ≤ 28T + 28T`: `Stage3.zeta_disk_upper` at `w = 2z+2+iT`,
             `‖w − (2+iT)‖ = 2‖z‖ ≤ 15/8`; for the second argument write it as
             `conj (2 (conj z) + 2 + iT)`, `riemannZeta_conj`, `Complex.norm_conj`, and
             `zeta_disk_upper` at `conj z` (`Complex.norm_conj` again for `‖conj z‖`);
             `‖G T 0‖ = 2 Re ζ(2+iT) ≥ 2(2 − π²/6) ≥ 7/10` by G_zero_eq,
             re_zeta_two_line_ge, `Complex.norm_real`, `Real.pi_lt_d4` (`π < 3.1416`;
             `Real.pi_lt_d2` gives only `0.69`, below `7/10`, caught at the build); then
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
             `Stage3.zeta_disk_upper {T : ℝ} (hT : 2 ≤ T) {w : ℂ}
                (hw : ‖w - (2 + Complex.I * (T : ℂ))‖ ≤ 15 / 8) : ‖ζ w‖ ≤ 28 * T`
             `Stage3.zeta_centre_ne_zero (T : ℝ) : ζ (2 + Complex.I * (T : ℂ)) ≠ 0`
               (JensenCount.lean declares `namespace Stage3`, TRAPS row 32; unused at the build)
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
Arithmetic checked here: `π²/6 − 1 < 1` since `π² < 12`; `2(2 − π²/6) = 4 − π²/3 > 4 − 3.2899 = 0.710`
with `π < 3.1416` (the first draft wrote `0.69` from `π < 3.15` and then divided by `0.7`; the builder caught it);
`56T / 0.7 = 80T`; `log(80T)/log(15/14) ≤ 14.5 log T + 14.5·4.39 = 14.5 log T + 63.7 ≤ 15 log T + 73`
for `T ≥ 2`; for real `x ∈ (1/2, 2)`, `(x − 2)/2 ∈ (−3/4, 0)`, inside the `7/8` disk.

## H3 The assembly: StmtSCrude argS, good heights by the identity, bad heights by a good one beside them — SKETCH
Objects.   A height `T` is good when no zero of ζ with `0 < Re ρ` has `Im ρ = T`;
           that is the `hgood` of `argS_eq_zetaArgContour`. At a good `T ≥ 2`,
           `argS T = zetaArgContour T`, and H1's `zetaArgContour_le` with
           `Z = reZeros hT` (H2), `hpos` from `re_zeta_two_line_pos` (H2) and
           `hZ` from `mem_reZeros` gives `|argS T| ≤ card + 3/2 ≤ 15 log T + 73 + 3/2`.
           At a bad `T₀ > 2` the identity is unavailable, so compare with a good
           `T` just below: `argS T₀ − argS T = (N T₀ − N T) − (θ T₀ − θ T)/π`.
           The zeros with `0 < Im ρ < T₀` are finitely many (upstream
           `Kadiri.zeroes_rect_univ_positive_height_finite`); let `m` be the
           largest of their imaginary parts and of `a := max 2 (T₀ − δ)`; every
           `T ∈ (m, T₀)` is good and no zero has `Im ∈ [T, T₀)`, so the index
           sets `zeroes_rect univ (Ioo 0 T)` and `(Ioo 0 T₀)` are equal and
           `N T = N T₀`. `phaseTheta T = (1/2)∫₀ᵀ phasePoint − (T/2) log π` with
           `phasePoint` continuous, so `|θ T₀ − θ T| ≤ (T₀ − T)(M/2 + (log π)/2)`
           with `M` a bound for `|phasePoint|` on `[T₀ − 1, T₀]`. With
           `δ := min 1 (π / (M + log π + 1))` the phase moves the bound by at most
           `1/2`, so `|argS T₀| ≤ 15 log T + 75 ≤ 15 log T₀ + 75`.
           At `T₀ = 2` a bad height has no good height below it inside `2 ≤ T`.
           Compare upward with a good `T' ∈ (2, 3)`: `0 ≤ N 2 ≤ N T'` because
           `N` is a finite sum of orders `≥ 1` (upstream
           `Kadiri.riemannZeta_one_le_order_positiveHeightZero`) over a set that
           grows with the height, and `N T' = argS T' + (θ T'/π + 1)` where the
           second term is within `97 log T' + 98` of `zetaCountingMainTerm T'`
           (`backlundPhase_holds`), and `|zetaCountingMainTerm T| ≤ 3` on `[2, 3]`.
           With `log T' ≤ T' − 1 ≤ 2` and `log 2 ≤ 1`: `N T' ≤ 15·2 + 74.5 + 3 + 97·2 + 98 = 399.5`,
           `|θ 2/π + 1| ≤ 3 + 97 + 98 = 198`, `|argS 2| ≤ 399.5 + 198 ≤ 15 log 2 + 600`.
           So `StmtSCrude argS 15 600` unconditionally and `StmtSCrude argS 15 75`
           under `good 2`; through `backlundArg_of_identity stmtArgIdentity_holds`
           and `RvM_of_phase_arg backlundPhase_holds` the bands `(112, 0, 698)`
           and `(112, 0, 173)`.
Sizes.     `B₁ = 15`; `B₃ = 75` for `2 < T` and under `good 2`; `B₃ = 600` from the
           single point `T = 2`, where the phase is bounded by the Stirling half's
           `97 log T + 98` at `T ≤ 3`. The band's `112` misses entry 130's budget
           `100`, as the head records. Lost factor: none; the `600` is one point.
Regime.    C1 `2 ≤ T`; at a bad height the finitely many zeros below it and the
           continuity of `phasePoint`, both from the tree.
Defs.      `def good (T : ℝ) : Prop := ∀ ρ : ℂ, riemannZeta ρ = 0 → 0 < ρ.re → ρ.im ≠ T`
Theorems.  Written as the Lean statements the module carries; the builder
           copies them. `hfin T` abbreviates `Kadiri.zeroes_rect_univ_positive_height_finite T`.
           argS_le_of_good — C1, `good T` —
             `theorem argS_le_of_good {T : ℝ} (hT : 2 ≤ T) (hg : good T) :
                |Stage3.argS T| ≤ 15 * Real.log T + 73 + 3 / 2`
             (`rw [Stage3.argS_eq_zetaArgContour hT hg]`; `ArgLegs.zetaArgContour_le hT`
             with `hpos := fun t _ => ReZetaCount.re_zeta_two_line_pos t`, `hgood` by
             `intro x hx h0; exact hg _ h0 (by simp; linarith [hx.1]) (by simp)`,
             `Z := ReZetaCount.reZeros hT`, `hZ := fun x hx h0 => (ReZetaCount.mem_reZeros hT).2 ⟨hx, h0⟩`;
             then `ReZetaCount.card_reZeros_le hT` and `linarith`.)
           N_eq_sum — none —
             `theorem N_eq_sum (T : ℝ) : riemannZeta.N T
                = ∑ z ∈ (Kadiri.zeroes_rect_univ_positive_height_finite T).toFinset,
                    (1 : ℝ) * (riemannZeta.order z : ℝ)`
             (upstream's own three lines, `KadiriEq12Helpers.lean:484`:
             `rw [riemannZeta.N, riemannZeta.zeroes_sum, ← Finset.tsum_subtype' _ (fun z => (1:ℝ) * (riemannZeta.order z : ℝ)), (hfin T).coe_toFinset]`;
             the cast shape of `order` inside `zeroes_sum` is § 2's, in Scratch.)
           N_nonneg — none —
             `theorem N_nonneg (T : ℝ) : 0 ≤ riemannZeta.N T`
             (`N_eq_sum`, `Finset.sum_nonneg`; a term is `1 * (order z : ℝ)` with
             `(1 : ℤ) ≤ order z` from `Kadiri.riemannZeta_one_le_order_positiveHeightZero ⟨z, (hfin T).mem_toFinset.1 hz⟩`,
             cast by `exact_mod_cast`.)
           N_mono — `T ≤ T'` —
             `theorem N_mono {T T' : ℝ} (h : T ≤ T') : riemannZeta.N T ≤ riemannZeta.N T'`
             (`N_eq_sum` twice; `Finset.sum_le_sum_of_subset_of_nonneg` with
             `(Set.Finite.toFinset_subset_toFinset _ _).2` and the inclusion
             `zeroes_rect univ (Ioo 0 T) ⊆ zeroes_rect univ (Ioo 0 T')` from
             `Set.Ioo_subset_Ioo_right h`; nonnegativity as in N_nonneg.)
           N_eq_of_no_zero_between — `T ≤ T₀`, no zero with `Im ∈ Ico T T₀` —
             `theorem N_eq_of_no_zero_between {T T₀ : ℝ} (hle : T ≤ T₀)
                (hno : ∀ ρ : ℂ, riemannZeta ρ = 0 → ρ.im ∈ Set.Ico T T₀ → False) :
                riemannZeta.N T = riemannZeta.N T₀`
             (`have hset : riemannZeta.zeroes_rect Set.univ (Set.Ioo 0 T) = riemannZeta.zeroes_rect Set.univ (Set.Ioo 0 T₀)`
             by `Set.ext`, unfolding `riemannZeta.zeroes_rect`, `riemannZeta.zeroes`,
             `Set.mem_Ioo`; the forward direction by `lt_of_lt_of_le`, the backward by
             `lt_or_ge ρ.im T` with `hno`; then `unfold riemannZeta.N riemannZeta.zeroes_sum; rw [hset]`.)
           exists_good_below — `0 ≤ a`, `a < T₀` —
             `theorem exists_good_below {a T₀ : ℝ} (ha : 0 ≤ a) (hlt : a < T₀) :
                ∃ T : ℝ, a < T ∧ T < T₀ ∧ good T ∧
                  ∀ ρ : ℂ, riemannZeta ρ = 0 → ρ.im ∈ Set.Ico T T₀ → False`
             (`F := insert a (((hfin T₀).toFinset.image Complex.im))`, nonempty by
             `Finset.insert_nonempty`; `m := F.max' _`; `m < T₀` by `Finset.max'_lt_iff`
             since `a < T₀` and every image element is an `im ∈ Ioo 0 T₀`;
             `T := (m + T₀) / 2`; `a < T` from `Finset.le_max' F a (Finset.mem_insert_self _ _)`;
             `good T`: a zero `ρ` with `ρ.im = T` has `0 < ρ.im` (from `0 ≤ a < T`) and
             `ρ.im < T₀`, so `ρ ∈ zeroes_rect univ (Ioo 0 T₀)`, so `ρ.im ∈ F` by
             `Finset.mem_image_of_mem` after `Set.Finite.mem_toFinset`, so `ρ.im ≤ m < T`,
             contradiction by `linarith`; the last clause the same way from `T ≤ ρ.im`.)
           phasePoint_bound_near — none —
             `theorem phasePoint_bound_near (T₀ : ℝ) :
                ∃ M : ℝ, 0 ≤ M ∧ ∀ t ∈ Set.Icc (T₀ - 1) T₀, |Stage3.phasePoint t| ≤ M`
             (`isCompact_Icc.exists_bound_of_continuousOn' Stage3.continuous_phasePoint.continuousOn`
             gives `C`; take `max C 0`; `Real.norm_eq_abs`, `le_max_left`, `le_max_right`.)
           phaseTheta_sub_le — `T ≤ T₀ ≤ T + 1` —
             `theorem phaseTheta_sub_le {T T₀ M : ℝ} (hle : T ≤ T₀) (h1 : T₀ ≤ T + 1)
                (hM : ∀ t ∈ Set.Icc (T₀ - 1) T₀, |Stage3.phasePoint t| ≤ M) :
                |Stage3.phaseTheta T₀ - Stage3.phaseTheta T|
                  ≤ (T₀ - T) * (M / 2 + Real.log Real.pi / 2)`
             (unfold `Stage3.phaseTheta`; `∫₀^{T₀} − ∫₀^T = ∫_T^{T₀}` by
             `intervalIntegral.integral_interval_sub_left (Stage3.intervalIntegrable_phasePoint 0 T₀) (Stage3.intervalIntegrable_phasePoint 0 T)`;
             `intervalIntegral.norm_integral_le_of_norm_le_const` with `‖phasePoint t‖ ≤ M`
             on `Ι T T₀ ⊆ Icc (T₀ − 1) T₀` (`Set.uIoc_of_le hle`, `Set.mem_Ioc`);
             the `log π` part is `(T₀ − T)/2 · log π` by `ring`; then `abs_sub_le_iff`/`abs_le`
             on each piece and `nlinarith [abs_nonneg ...]`, or `abs_add` then `linarith`.)
           argS_le_gt_two — `2 < T` —
             `theorem argS_le_gt_two {T : ℝ} (hT : 2 < T) : |Stage3.argS T| ≤ 15 * Real.log T + 75`
             (`obtain ⟨M, hM0, hM⟩ := phasePoint_bound_near T`;
             `δ := min 1 (Real.pi / (M + Real.log Real.pi + 1))`, positive by `Real.pi_pos`
             and `Real.log_pi_pos`-free reasoning: `0 < M + log π + 1` since `M ≥ 0` and
             `0 < log π` (`Real.log_pos` with `Real.one_lt_pi`);
             `obtain ⟨T', ha, hlt, hg, hno⟩ := exists_good_below (a := max 2 (T − δ)) (by positivity-free: `le_max_of_le_left`) (by max_lt ...)`;
             `2 ≤ T'` from `lt_max_iff`/`le_max_left`; `T − T' < δ ≤ 1`;
             `N T' = N T` by `N_eq_of_no_zero_between hlt.le hno`;
             `argS T − argS T' = −(θ T − θ T')/π` by `unfold Stage3.argS; rw [hN]; ring`;
             `phaseTheta_sub_le hlt.le (by linarith) hM` gives `|θ T − θ T'| ≤ δ (M/2 + log π/2) ≤ π/2`
             since `δ ≤ π / (M + log π + 1)` and `(M/2 + log π/2)·π/(M + log π + 1) ≤ π/2`
             (`div_le_iff`, `mul_le_mul` with `M + log π ≤ M + log π + 1`);
             `|argS T| ≤ |argS T'| + 1/2` by `abs_sub_le_iff`/`abs_le` and `div_le_iff Real.pi_pos`;
             `argS_le_of_good hT'2 hg`; `Real.log_le_log (by linarith) hlt.le`; `linarith`.)
           mainTerm_abs_le — `2 ≤ T ≤ 3` —
             `theorem mainTerm_abs_le {T : ℝ} (h2 : 2 ≤ T) (h3 : T ≤ 3) :
                |Kadiri.zetaCountingMainTerm T| ≤ 3`
             (`u := T / (2π) ∈ (0, 1/2]` by `Real.pi_gt_three`; `log u ≤ 0` by `Real.log_nonpos`;
             `−u log u = u log (1/u) ≤ u (1/u − 1) = 1 − u` by `Real.log_le_sub_one_of_pos`
             and `Real.log_inv`; so `|u log u − u + 7/8| ≤ (1 − u) + u + 7/8 ≤ 3`;
             `abs_le`, `nlinarith`.)
           argS_two_le — none —
             `theorem argS_two_le : |Stage3.argS 2| ≤ 15 * Real.log 2 + 600`
             (`obtain ⟨T', h2, h3, hg, -⟩ := exists_good_below (a := 2) (T₀ := 3) (by norm_num) (by norm_num)`;
             `hN : riemannZeta.N T' = argS T' + (θ T'/π + 1)` by `unfold Stage3.argS; ring`;
             `Stage3.backlundPhase_holds T' (by linarith)` and `mainTerm_abs_le` give
             `|θ T'/π + 1| ≤ 3 + 97 log T' + 98`; `Real.log_le_sub_one_of_pos` gives
             `log T' ≤ 2` and `log 2 ≤ 1`; `argS_le_of_good h2.le hg`; so `N T' ≤ 399.5`;
             `N_nonneg 2`, `N_mono h2.le`; at `2`, `backlundPhase_holds 2 le_rfl` and
             `mainTerm_abs_le le_rfl (by norm_num)` give `|θ 2/π + 1| ≤ 198`;
             `Real.log_nonneg (by norm_num : (1:ℝ) ≤ 2)`; `unfold Stage3.argS`;
             `abs_le`, `linarith` with `abs_le.1` of each bound.)
           sCrude_holds_of_good_two — `good 2` —
             `theorem sCrude_holds_of_good_two (h2 : good 2) : Stage3.StmtSCrude Stage3.argS 15 75`
             (`intro T hT; rcases hT.lt_or_eq with hlt | rfl`; `argS_le_gt_two hlt`;
             `argS_le_of_good le_rfl h2` and `linarith`.)
           sCrude_holds — none —
             `theorem sCrude_holds : Stage3.StmtSCrude Stage3.argS 15 600`
             (as above with `argS_two_le` at `T = 2` and `argS_le_gt_two` plus `linarith` above it.)
           rvM_crude_of_good_two — `good 2` —
             `theorem rvM_crude_of_good_two (h2 : good 2) :
                riemannZeta.Riemann_vonMangoldt_bound 112 0 173`
             (`have := Stage3.RvM_of_phase_arg Stage3.backlundPhase_holds
                (Stage3.backlundArg_of_identity Stage3.stmtArgIdentity_holds (sCrude_holds_of_good_two h2))`;
             `norm_num at this; exact this`.)
           rvM_crude — none —
             `theorem rvM_crude : riemannZeta.Riemann_vonMangoldt_bound 112 0 698`
             (the same with `sCrude_holds`.)
Composes.  Exact statements, so the builder opens no other module:
             `Stage3.argS (T : ℝ) : ℝ := riemannZeta.N T - (Stage3.phaseTheta T / Real.pi + 1)`
             `Stage3.argS_eq_zetaArgContour {T : ℝ} (hT : 2 ≤ T)
                (hgood : ∀ ρ : ℂ, riemannZeta ρ = 0 → 0 < ρ.re → ρ.im ≠ T) :
                Stage3.argS T = Stage3.zetaArgContour T`
             `ArgLegs.zetaArgContour_le {T : ℝ} (hT : 2 ≤ T)
                (hpos : ∀ t ∈ Set.Icc (0:ℝ) T, 0 < (riemannZeta (2 + (t : ℂ) * Complex.I)).re)
                (hgood : ∀ x ∈ Set.Icc (1/2:ℝ) 2, riemannZeta ((x : ℂ) + T * Complex.I) ≠ 0)
                (Z : Finset ℝ)
                (hZ : ∀ x ∈ Set.Ioo (1/2:ℝ) 2, (riemannZeta ((x : ℂ) + T * Complex.I)).re = 0 → x ∈ Z) :
                |Stage3.zetaArgContour T| ≤ (Z.card : ℝ) + 3 / 2`
             `ReZetaCount.re_zeta_two_line_pos (t : ℝ) : 0 < (riemannZeta (2 + (t : ℂ) * Complex.I)).re`
             `ReZetaCount.reZeros {T : ℝ} (hT : 2 ≤ T) : Finset ℝ`
             `ReZetaCount.mem_reZeros {T : ℝ} (hT : 2 ≤ T) {x : ℝ} :
                x ∈ ReZetaCount.reZeros hT ↔ x ∈ Set.Ioo (1/2 : ℝ) 2 ∧ (riemannZeta ((x : ℂ) + T * Complex.I)).re = 0`
             `ReZetaCount.card_reZeros_le {T : ℝ} (hT : 2 ≤ T) : ((ReZetaCount.reZeros hT).card : ℝ) ≤ 15 * Real.log T + 73`
               (H2's three are the block's statements; the builder reads the built
               `Stage3/ReZetaCount.lean` for the shape that landed)
             `Stage3.phaseTheta (T : ℝ) : ℝ := (1 / 2) * (∫ t in (0 : ℝ)..T, Stage3.phasePoint t) - T / 2 * Real.log Real.pi`
             `Stage3.continuous_phasePoint : Continuous Stage3.phasePoint`
             `Stage3.intervalIntegrable_phasePoint (a b : ℝ) : IntervalIntegrable Stage3.phasePoint MeasureTheory.volume a b`
             `Stage3.StmtSCrude (S : ℝ → ℝ) (B₁ B₃ : ℝ) : Prop := ∀ T : ℝ, 2 ≤ T → |S T| ≤ B₁ * Real.log T + B₃`
             `Stage3.StmtBacklundPhase (θ : ℝ → ℝ) (B₁ B₃ : ℝ) : Prop := ∀ T : ℝ, 2 ≤ T →
                |θ T / Real.pi + 1 - zetaCountingMainTerm T| ≤ B₁ * Real.log T + B₃`
             `Stage3.backlundPhase_holds : Stage3.StmtBacklundPhase Stage3.phaseTheta 97 98`
             `Stage3.stmtArgIdentity_holds : Stage3.StmtArgIdentity Stage3.phaseTheta Stage3.argS`
             `Stage3.backlundArg_of_identity {θ S : ℝ → ℝ} {B₁ B₃ : ℝ}
                (hid : Stage3.StmtArgIdentity θ S) (hS : Stage3.StmtSCrude S B₁ B₃) : Stage3.StmtBacklundArg θ B₁ B₃`
             `Stage3.RvM_of_phase_arg {θ : ℝ → ℝ} {B₁ B₃ B₁' B₃' : ℝ}
                (hPhase : Stage3.StmtBacklundPhase θ B₁ B₃) (hArg : Stage3.StmtBacklundArg θ B₁' B₃') :
                riemannZeta.Riemann_vonMangoldt_bound (B₁ + B₁') 0 (B₃ + B₃')`
             `Kadiri.zetaCountingMainTerm (T : ℝ) : ℝ := T / (2 * Real.pi) * Real.log (T / (2 * Real.pi)) - T / (2 * Real.pi) + 7 / 8`  (upstream KadiriZeroCounting.lean:454)
             `riemannZeta.zeroes : Set ℂ := {s : ℂ | riemannZeta s = 0}`  (upstream ZetaDefinitions.lean:20)
             `riemannZeta.zeroes_rect (I J : Set ℝ) : Set ℂ := {s : ℂ | s.re ∈ I ∧ s.im ∈ J ∧ s ∈ zeroes}`  (ZetaDefinitions.lean:24)
             `riemannZeta.order (s : ℂ) : ℤ := (meromorphicOrderAt (riemannZeta) s).untopD 0`  (ZetaDefinitions.lean:103)
             `riemannZeta.zeroes_sum {α : Type*} [RCLike α] (I J : Set ℝ) (f : ℂ → α) : α :=
                ∑' ρ : riemannZeta.zeroes_rect I J, (f ρ) * (riemannZeta.order ρ)`  (ZetaDefinitions.lean:107)
             `riemannZeta.N (T : ℝ) : ℝ := zeroes_sum Set.univ (Set.Ioo 0 T) (fun _ ↦ 1)`  (ZetaDefinitions.lean:137)
             `riemannZeta.Riemann_vonMangoldt_bound (b₁ b₂ b₃ : ℝ) : Prop :=
                ∀ T ≥ 2, |riemannZeta.N T - (T / (2 * π) * log (T / (2 * π)) - T / (2 * π) + 7 / 8)| ≤ RvM b₁ b₂ b₃ T`  (ZetaDefinitions.lean:161)
             `Kadiri.zeroes_rect_univ_positive_height_finite (T : ℝ) :
                (riemannZeta.zeroes_rect (.univ : Set ℝ) (.Ioo 0 T)).Finite`  (KadiriZeroCounting.lean:340)
             `Kadiri.riemannZeta_one_le_order_positiveHeightZero {T : ℝ}
                (rho : riemannZeta.zeroes_rect (.univ : Set ℝ) (.Ioo 0 T)) :
                (1 : ℤ) ≤ riemannZeta.order (rho : ℂ)`  (KadiriZeroCounting.lean:251)
           Mathlib, grepped: Finset.tprod_subtype' (additive `Finset.tsum_subtype'`,
           InfiniteSum/Basic.lean:530), Set.Finite.coe_toFinset (Set/Finite/Basic.lean:110),
           Set.Finite.toFinset_subset_toFinset (Basic.lean:149),
           Finset.sum_le_sum_of_subset_of_nonneg (Order/BigOperators/Group/Finset.lean:131),
           IsCompact.exists_bound_of_continuousOn' (Normed/Group/Bounded.lean:97),
           intervalIntegral.norm_integral_le_of_norm_le_const (IntervalIntegral/Basic.lean:768),
           intervalIntegral.integral_interval_sub_left (Basic.lean:1120),
           Set.Ioo_subset_Icc_self, Finset.exists_max_image (Finset/Max.lean:528).
           Candidates the builder greps under LOOP.md § 2: Finset.max'_lt_iff, Finset.le_max',
           Finset.mem_image_of_mem, Set.Finite.mem_toFinset, Set.Ioo_subset_Ioo_right,
           Set.uIoc_of_le, Real.log_le_sub_one_of_pos, Real.log_nonpos, Real.log_inv,
           Real.pi_gt_three, Real.one_lt_pi, Real.log_pos, abs_sub_le_iff, abs_le, div_le_iff.
Module.    Stage3/ArgCount.lean, namespace ArgCount, importing Stage3.ArgLegs and
           Stage3.ReZetaCount; pins: argS_le_of_good, argS_le_gt_two, sCrude_holds,
           sCrude_holds_of_good_two, rvM_crude, rvM_crude_of_good_two.
           Built under the relay (LOOP.md § 4b).
Open.      `good 2` — no zero of ζ with `0 < Re ρ` and `Im ρ = 2` — which the tree
           lacks and which would make the `600` a `75`; the band's `112` against
           the budget `100`, which is the Stirling half's to trim.
Arithmetic checked here: `73 + 3/2 + 1/2 = 75`; `97 + 15 = 112`; `98 + 75 = 173`; `98 + 600 = 698`;
`δ (M/2 + log π/2) ≤ π/2` when `δ ≤ π/(M + log π + 1)`; `log T' ≤ log T` for `T' ≤ T`;
`T/(2π) ≤ 3/6 = 1/2` for `T ≤ 3`, `π > 3`; `(1 − u) + u + 7/8 = 15/8 ≤ 3`;
`15·2 + 74.5 + 3 + 97·2 + 98 = 399.5`; `3 + 97 + 98 = 198`; `399.5 + 198 = 597.5 ≤ 600`.
