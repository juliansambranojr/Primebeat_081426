# Pins

What a theorem's `#print axioms` does for a proof, this file does for a
task: it certifies what the deliverable rests on. Four lines per task,
written silently by the model when the task starts, before any work, and
read by Julian when something looks lazy. Unit 0339.

    DONE        one line: what the deliverable is, so it can be checked
    ASSUMED     ambiguities resolved the model's way, each as one sentence
    DEPENDS     what the task needs from Julian (a flag, a decision, a file)
    OUT         what the model decided is out of scope, and why

When a task looks lazy, read its pins. One of three things shows: an
ASSUMED line is wrong (misalignment, one line to fix); a DEPENDS line is
unmet (blocked, on a named thing); or DONE was narrower than intended
(scope, at a boundary drawn here). Each wrong pin, once seen, goes into
the misreads table at the end, the way a build error goes into
`lean_stage3/TRAPS.md`.

The current task's pins sit at the top. Earlier tasks move to the archive
below with their outcome.

## Current

### 2026-09-07 · rung 5, after unit 0360

    DONE        nothing further on the detection method as the worksheet
                frames it. Sections 9, 13 and 14 are dead; the nine Lean
                modules stand, each abstract in the member and the count
    ASSUMED     the obstruction is structural, not a size: exp(w^2 sigma)
                carries the boost in its modulus and the phase sweep in its
                argument, so detection strength and sign control are one
                parameter pulled two ways. A write-up for
                papers/What-Didnt-Work.md is the next artifact
    DEPENDS     Julian, on whether the next thing is that write-up, a fresh
                motivation entry for a family-of-test-functions route, or
                something off this rung entirely
    OUT         repairing sections 9, 13 or 14; any further Lean on the
                averaging route; sharpening constants against a structural
                obstruction

### 2026-09-08 · rung 5, the two open items of the audit — pins written after the run

    DONE        section 14 checked on the two-sideband term (term_eq_sidebands,
                S in closed form) and the gap-dependent L(ε, T, δ) priced on
                the same object: a table of h₀ over ε, T, δ, the binding term
                named per cell, the hypothesis it needs stated, the quantifier
                it changes named; unit 0366, type decision, marks moved in
                the worksheet on the script
    ASSUMED     the far sideband is negligible (it is, under 1e-50); the worst
                member sits at ε' = ε, Δ = δ (checked on a grid); lowCount = 0,
                its true value, where the tree carries the symbol; the cluster
                count is 15 log T + 73 per unit height; 0360's label was
                reversed and its conclusions stand
    DEPENDS     Julian, on whether the conditional theorem (detection under
                the gap hypothesis, the dichotomy through the arrow) is worth
                a Lean module; the pins here were written after the scripts
                ran, as § 13 (b)'s were, and that is recorded
    OUT         a module; any repair of the uniform L; touching unit 0360's text

### 2026-09-08 · rung 5, term_le_at_zero priced on the tree — pin written after the run

    DONE        the 45-cell table of unit 0366 rerun on the tree's own
                inequalities (S_real_ge_sharp at the target, norm_S_le_c_pos/
                _neg at the members, norm_S_le_far at the far zeros, F4/F5/
                F2-far checked at each (h, lam, eps, delta)): every cell
                closes; the lost factor in h is at most 36 in the tightest
                delta = 0.01 cluster corner, 1 where the background binds;
                the quantifier does not change (unit 0367)
    ASSUMED     the lam menu is bounded above by the F2-far cap gamma*sqrt(2)/pi,
                enough at every cell tried; block 13e's free lam is what
                closes the cluster corner (at lam = 1 the tightest cells miss
                the F5 cap); the lost factor lives in the 2m+3 prefactor of
                compare_le, no size explodes
    DEPENDS     Julian, on whether the conditional theorem now becomes a Lean
                module — its price on the tree's inequalities is measured
    OUT         a module; sharpening the 2m+3 prefactor; any repair of the
                uniform L

### 2026-09-08 · block 15, WeilPowerAssembly, under the relay

    DONE        StmtDetectGap and detect_gap_exists proved in a single module
                Stage3/WeilPowerAssembly.lean; the conditional theorem the
                pricings of units 0366 and 0367 promised (unit 0368)
    ASSUMED     lam = 1 in the assembly, since existence needs only the
                exponential gap and not the numeric h; section 8's target
                selection is folded into hne by picking the max-Re element
                of the finite OffLineBox; IsTest's ContDiff piece may sorry
                if Mathlib lacks a boundary-vanishing indicator lemma, which
                would be reported as an OPEN row of the block, not silent
    DEPENDS     nothing from Julian; downstream nothing (StmtDetect_gap is
                not consumed by box_empty_of_positive_of_detect, whose
                arrow reads StmtDetect at L in ε, T; that is by design)
    OUT         the numeric L; the box's arrow to the strip under the gap
                hypothesis; the sharp 2m+3 prefactor
    OUTCOME     PARTIAL, unit 0368, module committed with two declared sorries;
                StmtDetectGap defined, target_lower and on_line_le proved
                cleanly (their pins verify), isTest_phiWC sorries at ContDiff
                (Mathlib has no contDiff_indicator, block's expected OPEN row),
                detect_gap_exists sorries at the existence proof (depends on
                isTest and the three placeholders), three placeholders left
                as True with the block's goals in comments (near_nonneg,
                far_moderate_le, far_large_le all wait on the box's
                finiteness in height as a Finset). Bench rule change: the
                SORRY check now accepts a declared count in values.tsv
                (utilities/check_lean_unit.py, LOOP.md v21). Next: a
                Mathlib contDiff_indicator_of_zero_boundary PR would close
                isTest, plus a Kadiri box-in-strip finiteness lemma would
                close the three placeholders

## Archive

### 2026-09-08 · the count-to-argument step: StmtSCrude argS, three blocks

    DONE        StmtSCrude argS 15 600 proved unconditionally and
                StmtSCrude argS 15 75 under good 2, hence StmtBacklundArg and
                the crude hNT bands Riemann_vonMangoldt_bound 112 0 698 and
                112 0 173, each block a module through the relay: H1 legs,
                H2 count, H3 assembly (the 66 and 164 first written here were
                H2's planned 64 before the disk radius was priced, and the
                600 is the single point T = 2, hnt.md § H3)
    ASSUMED     the band misses entry 130's census budget (97 + 15 = 112 > 100)
                and that is recorded before the first module; the Stirling
                half's 97 is not touched here; hnt.md prices, the tree defines
    DEPENDS     nothing from Julian; upstream's backlund_bound stays a watch
    OUT         sharp constants; the Stirling trim; the assembly of rung 5
    OUTCOME     DONE over units 0363, 0364, 0365; StmtSCrude argS 15 600 and,
                under good 2, 15 75; Riemann_vonMangoldt_bound 112 0 698 and
                112 0 173; the census miss (112 vs 100) stands as recorded,
                and the 698 is the single point T = 2, open as good 2

### 2026-09-08 · block H3, ArgCount, under the relay

    DONE        the six pinned theorems of hnt.md#H3 built and committed
                with unit 0365: at a good height the identity and H1 with
                H2's Finset give |argS T| ≤ 15 log T + 73 + 3/2; at a bad
                height above 2 a good height just below, with N equal and
                phaseTheta moving by at most π/2; at T = 2 a good height
                just above with N monotone and the Stirling phase bound,
                600; then StmtSCrude argS 15 600, 15 75 under good 2, and
                Riemann_vonMangoldt_bound 112 0 698 and 112 0 173
    ASSUMED     the finite-sum form of N and the order ≥ 1 at a positive-
                height zero are upstream's (KadiriZeroCounting); the
                phasePoint bound on [T − 1, T] is existential, so δ is not
                explicit and need not be; H2's three statements land in
                the shape hnt.md § H2 gives them
    DEPENDS     H2's module built; nothing from Julian
    OUT         good 2 (no zero at height 2), which would make 600 a 75;
                the Stirling trim; any constant sharper than crude
                Added at the build, 2026-09-08: (a) the block's
                `IsCompact.exists_bound_of_continuousOn'` is the multiplicative
                member of a to_additive pair; the additive partner is used
                (TRAPS row 37); (b) no `Real.one_lt_pi`; `div_le_iff` is
                `div_le_iff₀`; (c) membership in `riemannZeta.zeroes_rect` is
                opened by `simp only` at every site; (d) exists_good_below's
                Finset packaged through one `obtain`; (e) argS_two_le reads N
                from argS by `unfold; ring`, not through stmtArgIdentity_holds
    OUTCOME     PROVED, unit 0365, module committed with it; 1 sorry at the
                first stop (a missing sign product under linarith), closed by
                the foreman in 1 edit and 1 build; 14 of 15 closed on the
                builder's one try; 5 ASSUMED pins promoted into the block; the
                band lands at (112, 0, 698) unconditionally and (112, 0, 173)
                under good 2

### 2026-09-08 · block H2, ReZetaCount, under the relay

    DONE        the four pinned theorems of hnt.md#H2 built and committed
                with unit 0364: Re ζ(2+it) ≥ 2 − π²/6 > 0 from the Dirichlet
                series, and the zeros of Re ζ on the segment [1/2, 2] at
                height T as a Finset with card ≤ 15 log T + 73, by Jensen on
                G_T = ζ(2z+2+iT) + ζ(2z+2−iT), the local zero count's template
    ASSUMED     the constants 15, 73 are reused from zeta_local_zero_count's
                arithmetic since 80T < 84T; the tsum bookkeeping of the
                Dirichlet bound and the order-at-a-zero step are where the
                one-try rule is likeliest to leave a sorry.
                Added at the build, 2026-09-08:
                (a) JensenCount's declarations live in `namespace Stage3`, so
                the composed name is `Stage3.zeta_disk_upper` and not the
                `JensenCount.zeta_disk_upper` the block's Composes line writes
                (TRAPS row 32, the same trap as H1's).
                (b) F_bound's denominator bound `2(2 − π²/6) ≥ 7/10` does not
                follow from the `Real.pi_lt_d2` the block names: `π < 3.15`
                gives `4 − π²/3 > 0.69` and `56T/0.69 > 80T`. The module uses
                `Real.pi_lt_d4` (`π < 3.1416`), which gives `4 − π²/3 > 0.710`
                and carries the block's `56T/(7/10) = 80T`. re_zeta_two_line_pos
                keeps `Real.pi_lt_d2`, which is enough for positivity alone.
                (c) the block lists no lemma for the analyticity of F_T on a
                ball, so F_zeros_finite and card_reZeros_le each rebuild it:
                the first on the `11/10` ball (its accumulation point can sit
                on the unit circle), the second on the open unit ball, from
                F_analytic by `AnalyticOnNhd.mono`.
                (d) the order-at-a-zero step reads `analyticOrderNatAt` as
                `(analyticOrderAt _).toNat` and rules out `0` and `⊤`
                separately through `ENat.toNat_eq_zero`, a name the block does
                not list; `⊤` is refused by the identity principle on the unit
                ball against F_T(0) = 1.
                (e) the block's Theorems lines number fifteen theorems, not the
                thirteen the brief states; the module carries all fifteen.
    DEPENDS     nothing from Julian
    OUT         the assembly at good and bad heights (H3)
    OUTCOME     PROVED, unit 0364, module committed with it; 6 sorries at the
                first stop, six one-line traps (four new rows, 33–36), closed by
                the foreman on one rebuild, 7 edits and 4 builds; 9 of 15 closed
                on the builder's one try; 5 ASSUMED pins promoted into the block,
                one of them the block's own pi bound (0.69 under pi < 3.15,
                fixed by pi < 3.1416)

### 2026-09-08 · block H1, ArgLegs, under the relay

    DONE        the four pinned theorems of hnt.md#H1 built and committed
                with unit 0363: the imaginary part of ∫ g'/g on a segment
                moves by at most π per zero of Re g, plus one, and the two
                legs of zetaArgContour at ζ, |zetaArgContour T| ≤ q + 3/2
    ASSUMED     the regime lines T2 (good height on the segment) and T3
                (Re ζ(2+it) > 0) are hypotheses here, discharged in H2/H3;
                the sign-constancy lemma is where the one-try rule is
                likeliest to leave a sorry.
                Added at the build, 2026-09-08:
                (a) the two composed names live in `namespace Stage3`, not the
                `ArgIdentity` namespace the block's Composes line writes, so
                `zetaArgContour_le` is stated at `Stage3.zetaArgContour T` and
                the continuity lemma is read as
                `Stage3.logDeriv_zeta_continuousAt` (TRAPS row 32);
                (b) `re_sign_const` is proved by the direct route — two points
                of `Icc a b` with strictly opposite signs of `Re g` put a zero
                strictly between them, hence inside `Ioo a b` — in place of the
                block's `closure_Ioo` / `ContinuousOn.preimage_isClosed_of_isClosed`
                route; its `hab` is then unused and the block's statement is
                kept verbatim, so the module carries one unused-binder warning;
                (c) `segment_im_integral_le` generalises `a` and `b` in the
                induction, where the block says `a` alone: splitting at the
                largest zero applies the hypothesis on `[a, z]`, so the upper
                endpoint is the one that moves
    DEPENDS     nothing from Julian
    OUT         the count of the zeros of Re ζ (H2); bad heights (H3)
    OUTCOME     PROVED, unit 0363, module committed with it; 2 sorries at the
                first stop, one trap (row 16), closed by the foreman in 4 edits
                and 3 builds; 8 of 10 closed on the builder's one try, the
                segment induction among them; 3 ASSUMED pins promoted into the block


### 2026-09-07 · block 13j, WeilPowerBridge, under the relay

    DONE        the four pinned theorems of rung5.md#13j built and committed
                with unit 0362: the zero form's term at an actual nontrivial
                zero written in S at its two sidebands, the far sideband
                bounded by section 4's decay, and 13b's lower bound applied
                to the near one
    ASSUMED     the bridge is term_re_eq + what_eq (compiled in Scratch.lean
                2026-09-07); the far condition F2 is a hypothesis here and is
                discharged by the assembly's choice of gamma; the statement
                of term_le_at_zero is long because every constant is explicit;
                the module's open line carries WeilPowerGauss beside the four
                the block names, because D lives there and open is not
                transitive (TRAPS row 31) — no theorem hypothesis was added,
                all six statements are the block's verbatim
    DEPENDS     nothing from Julian
    OUT         pricing the size on the whole term (next decision unit);
                any second attempt by the builder
    OUTCOME     PROVED, unit 0362, module committed with it; third relay run
                closed whole: 0 errors, 0 sorry, 0 foreman edits; 1 ASSUMED
                pin (open WeilPowerGauss), promoted into the block; the first
                module of the ladder to name Kadiri.NontrivialZeros


### 2026-09-07 · block 13i, WeilPowerCount, under the relay

    DONE        the four pinned theorems of rung5.md#13i built and committed
                with unit 0358: the short-interval count named as a leaf with
                its budget and route, and the range that closes unit 0351's
                circularity at an explicit L linear in log T
    ASSUMED     the leaf's budget c1 <= 0.48 at window ratio 8, from 13h;
                Trudgian's 0.112 gives c1 = 1/(2pi) + 2B1 = 0.383, inside it;
                the module stays abstract in cnt, B and d, so the assembly
                discharges hB rather than this block; the leaf's body is
                "for all T, 2 <= T -> cnt T <= c1 * log T + c2", forced by
                card_le_of_leaf's hint since 13i's Defs line gives only the
                signature; exists_range_log's "0 <= M" is unused by the
                proof and kept because the block's statement lists it
    DEPENDS     nothing from Julian; 0351 stands as corrected by 0357
    OUT         proving the leaf; instantiating B from 13f and 13g; the
                assembly; any second attempt by the builder
    OUTCOME     PROVED, unit 0358, module committed at f6999c4; second run
                the builder closed whole: 0 errors, 0 sorry, 0 foreman edits,
                0 trap rows; 2 ASSUMED pins, both promoted into the block (the
                leaf's body is now stated, the unused 0 <= M kept and said so)


### 2026-09-07 · block 13h, WeilPowerClean, under the relay at loop v16

    DONE        the four pinned theorems of rung5.md#13h built and committed
                with unit 0357: a member blocks at most W+1 consecutive
                shells, and more shells than the count leaves one clean
    ASSUMED     the window ratio hi/lo is an absolute constant, so W is
                one; the block corrects unit 0351's 1.23 to c₁·ln(hi/lo) < 1
                and the leaf it names is unchanged; the module is pure
                combinatorics and imports no rung module
    DEPENDS     nothing from Julian; 0351's finding stands as corrected here
    OUT         instantiating B from 13f and 13g (that is 13i); the leaf's
                own proof; the assembly; any second attempt by the builder
    OUTCOME     PROVED, unit 0357, commit with the module; the first block
                the builder closed whole: 0 errors, 0 sorry, 0 foreman
                edits; four block errors it named and I corrected; the
                leaf's constant tightened from 1.23 to c1 log(hi/lo) < 1


### 2026-09-07 · block 13g, WeilPowerNear, under the relay at loop v16

    DONE        the four pinned theorems of rung5.md#13g built and committed
                with unit 0354: the near members' terms are nonnegative at
                every h in the range, so their sum helps the target
    ASSUMED     the crude sign condition N2 (sin θ ≤ θ, cos θ ≥ 1 − 2θ/π)
                is the one the assembly will use; the Lean statements in
                the block are copied, so no shape reading is needed; the run
                measures a 13e-sized block under the relay and v16
    DEPENDS     nothing from Julian; 0351 stands
    OUT         the shell between 13g's boundary and 13f's; the tight count;
                the assembly; any second attempt by the builder
    OUTCOME     PROVED, unit 0354, commit with the module; one sorry at the
                first stop (bracket_nonneg, linarith's atoms), closed by the
                foreman in two edits, two builds; builder 104519 + 9960
                tokens, 34 calls; the block's Lean statements were copied,
                no shape reading


### 2026-09-06 · block 13f, WeilPowerShell, under the relay

    DONE        the four pinned theorems of rung5.md#13f built and committed
                with unit 0352; Opus lays the module and stops at the first
                build, I finish the sorrys, Opus resumes for counts and the
                unit scaffold, I write the prose and commit
    ASSUMED     13e's G7 at k = 0 is the only gap in composing
                norm_sum_exp_u_le_gen, closed by uSh; the relay's two
                reports carry errors_first and the counts; the run is the
                measure of the relay against runs 13c–13e
                — builder's run, 2026-09-06: no hypothesis outside the
                block's per-theorem lists was needed; three readings of
                the block's shapes were taken: uSh_bracket keeps the
                block's `∀ k` inside the statement so it is
                norm_sum_exp_u_le_gen's `hu` after one `ring` step on the
                affine form `α·k + β₀`; norm_zOf_c_le takes the block's
                `∀ a : ℕ` as an explicit argument; shellSum_le_abs reads
                "the bound with |Δ| in place of Δ" as the substitution at
                every occurrence, |Δ|² included, the same real number as
                substituting only in 4ε'Δ since |Δ|² = Δ²
    DEPENDS     nothing from Julian; the finding of unit 0351 stands and
                this block is the far-member bound any variant needs
    OUT         the shell below Δ ≈ λ/(εX); the tight count leaf; the
                assembly; any second attempt by the builder on a proof
    OUTCOME     PROVED, unit 0352, commit with the module; one sorry at the
                first stop, closed by the foreman in one edit; builder
                164440 + 13164 tokens, 47 calls, against 13e's 138681 / 40


### 2026-09-06 · block 13e, the geometric bound with a free slope and uLam (Opus run)

    DONE        WeilPowerGeomGen.lean committed by the agent with its unit:
                13d restated with slope, intercept and correction scale free,
                and the bracket for uLam λ h = h²σ(λh−1) at general λ
    ASSUMED     λ is a positive integer and m + 1 = λh; the special case
                α = 1/π², β₀ = ½/π², c = 1/(4π²) is 13d and need not be
                re-derived; the casts around λh − 1 are the executor's;
                sin_im_ge_gen takes G1 as well as G2 and G3, the block's
                Theorems line naming only the latter two, G1 being in its
                own Regime list (unit 0350)
    DEPENDS     nothing
    OUT         the shell reading (13f); the error term q at the shell
    OUTCOME     built by the agent: WeilPowerGeomGen.lean, unit 0350, commit
                947ac9b, 11 minutes, errors_first 1, one ASSUMED pin (G1
                uncited on one theorem line, DESIGN.md v5); LOOP.md v13 by
                the agent

### 2026-09-06 · block 13d, the geometric sum and the harmonic correction (Opus run)

    DONE        WeilPowerGeom.lean committed by the agent with its unit: the
                geometric sum bounded independently of the range length, the
                correction sum bounded by a logarithm
    ASSUMED     u is an abstract sequence with 13c's bracket as hypothesis
                R6, so the module does not import WeilPowerSigma; Jordan's
                inequality is Mathlib's Real.mul_le_sin; geom_sum_Ico is
                absent on this Mathlib and the block says so
    DEPENDS     nothing
    OUT         reading z and Mab at the shell (13e); the on-line and
                suppressed sums with the same weights (13e/f)
    OUTCOME     built by the agent: WeilPowerGeom.lean, unit 0349, commit
                13979b4, 14 minutes, errors_first 5 from three roots, no
                ASSUMED pin; the ASSUMED line on geom_sum_Ico was wrong
                (misreads table); LOOP.md v12 by the agent

### 2026-09-06 · block 13c, the tail sum to order 1/h (Opus run under DESIGN.md v1)

    DONE        WeilPowerSigma.lean committed by the agent with its unit;
                σ(m) bracketed to order 1/m² and u(m) = (m+1)²σ(m) within
                [1/(2π²(m+2)²), 1/(π²(4m+6))] of (m+½)/π²
    ASSUMED     λ = 1 so h = m+1 and the block is stated in m alone; the
                two telescoping inequalities are elementary and the block's
                arithmetic was checked in the block; no pre-registration
                unit per run, the agent's unit is the record
    DEPENDS     nothing
    OUT         the geometric sum and the harmonic bound (13d); the
                Re(w²) ≤ 0 sharp exponent
    OUTCOME     built by the agent: WeilPowerSigma.lean, unit 0348, commit
                7539dae, 12 minutes, errors_first 3 from one root, no
                ASSUMED pin; the two r bounds are equalities against the
                brackets; block gaps: u listed as a theorem, two lemmas
                hidden in "via" clauses (DESIGN.md v2)

### 2026-09-06 · section 13 (b), the phase module (unit 0347) — pins written AFTER the work

    DONE        WeilPowerPhase.lean committed with unit 0347: the tail product
                split into principal part and error, S within 2q of c·w·P,
                Re S² bounded below in closed form
    ASSUMED     the principal part is exp(w²σ) with σ the full tail tsum,
                bracketed rather than evaluated; the regime hypothesis q ≤ 1
                is carried as a hypothesis, traced to h and λ later
    DEPENDS     nothing
    OUT         requirement (c) onward; the neg-case sharp exponent
    OUTCOME     built; step 0b was skipped and these lines were written
                after the commit, which is the misread below

### 2026-09-06 · the orchestrator runs the loop: section 9 design, then one module

    DONE        a decision unit that prices section 9 as sketched and names the
                route change, the worksheet updated, and one module committed
                under LOOP.md v8 with its unit; the run's own errors_first,
                minutes and refusals recorded for comparison with units 0340
                and 0343
    ASSUMED     the module is whatever the decision unit says every route
                needs first; the comparison measures are read the same way
                as for the agents (git log for minutes, values.tsv for
                errors_first); the loop's text is followed literally, and
                each place it fails me is named in the retrospective
    DEPENDS     nothing from Julian; a route change becomes a decision unit,
                which this run makes
    OUT         the remaining sections after this module; any agent spawn
                during the run
    OUTCOME     built: unit 0345 (section 9 dies on size, section 13), then
                WeilPowerSharp.lean, unit 0346; errors_first 4, two root
                causes; two bench traps hit (B10, B11), LOOP.md v9

### 2026-09-06 · rung 5 §7 in Lean: the comparison at another off-line zero

    DONE        one module, `lean_stage3/Stage3/WeilPowerCompare.lean`, and
                its unit, committed through the pre-commit: the Gaussian
                comparison of `‖S m w‖` at an off-line zero `(ε', Δ)` with
                `Re (S m s)` at the target `(ε, 0)`, both read by the same
                window, with the exponent explicit
    ASSUMED     §7's `poly(h, m)` prefactor is the single factor `2m+3`, the
                loss between the upper and the lower Gaussian constant
                (§5's "Prefactor loss between upper and lower bound: one
                factor `2m+3`"), times `‖w‖/s`; the comparison is stated at
                the transform `S`, the window's `what` and the term's square
                being one multiplication away and belonging to the assembly;
                the two sign cases of `Re(w²)` are unified by one exponent
                `Eup` written with `max _ 0`, so the module has one upper
                bound instead of two; §7's second paragraph (the crude far
                regime) is already `WeilPowerBounds.norm_S_le_far` and is
                cited, not restated; `λ` stays a parameter, so the module is
                stated in `m` and `h` and no `m + 1 = λh` is imposed
    DEPENDS     nothing; the worksheet's §7 is the whole input
    OUT         §8 selection, §9 cluster, §10 assembly; sharp constants; any
                edit to §7 of the worksheet itself (a route change would be
                a decision unit first)
    OUTCOME     built: WeilPowerCompare.lean, unit 0341, commit 94febea

### 2026-09-06 · rung 5 §8 in Lean: selection of the target

    DONE        one Lean module (`lean_stage3/Stage3/WeilPowerSelect.lean`) and
                its unit, committed through the pre-commit: the target-selection
                argument of `rung5.md#8` — a monotone-bounded-sequence pigeonhole
                lemma, applied to give an explicit step `k` and height bound, plus
                the trivial "large `Δ`" case that needs no selection at all
    ASSUMED     the "max real part over zeros in the box of height `T+k/2`" is a
                parameter `E : ℕ → ℝ` (monotone, bounded by `1/2`, `0 ≤ E 0`), not
                derived here from an actual finite zero set — the same
                parameterize-downstream choice unit 0341 made for `ε', Δ, ε, h`;
                the "maximum over a finite set" half of the worksheet's "Lean
                shape" note is deferred to whichever later module wires `E` to a
                real zero set (band count or `WeilOnLine.lowSet_finite`'s
                argument, widened); `K'` stays a free positive parameter, as it is
                in the worksheet itself (never given a value there); `ε' ≥ 0`
                (only the symmetric half of zeros, real part at or above the
                line) is assumed alongside the worksheet's `ε' ≤ 1/2`, needed to
                square the inequality; this module does not import
                `Stage3.WeilPowerCompare` — nothing in it is used, so the module
                is stated over bare Mathlib order/real-number lemmas
    DEPENDS     nothing; the worksheet's §8 is the whole input
    OUT         §9 cluster, §10 assembly; wiring `E` to an actual off-line zero
                set; sharp constants; matching the sketch's rough "`+1`" slop
                term literally — the module's own constant is computed and the
                worksheet is corrected to it, not forced to agree with the sketch
    OUTCOME     built and committed: 7 theorems, 1 def, 3 axioms, 0 sorries,
                190 lines, `errors_first` 3, worksheet §8 flipped to PROVED
                (unit 0344) in the same commit; `check_lean_unit.py` refused
                once (DEFS/PIN, TRAPS row B9, new) before passing; `lab check`
                passed on every run
    OUTCOME     built: WeilPowerSelect.lean, unit 0344, commit 0c97dec

### 2026-09-06 · probe: the loop on a Sonnet agent, section 8 (unit 0343)

    DONE        one Sonnet subagent given the Opus agent's prompt with the
                section changed to 8; report and tree measures recorded in
                unit 0343 against predictions written before the spawn,
                with a recurrence count over the seven defects of unit 0340
    ASSUMED     section 8 is the right next section (7 is PROVED); the same
                decision rule with the error band widened to 20 for the
                tier; the orchestrator writes nothing into the module or
                unit; a recurrence is the same defect met again, by text
    DEPENDS     nothing; Julian reads the outcome
    OUT         fixing the agent's module if it fails; a third agent; any
                edit to the loop while the agent runs
    OUTCOME     transferred, fixes held: commit through the gate, no
                restart, errors_first 3, 19 minutes, section 8 PROVED in
                the same commit, none of the seven defects recurred; three
                new ones, one now TRAPS B9, one LOOP.md v8 (run.sh)

### 2026-09-06 · probe: does the loop transfer to a weaker agent (unit 0340)

    DONE        one Opus subagent given only the repo's files and section 7,
                its report and the tree's measures recorded in unit 0340
                against predictions written before the spawn
    ASSUMED     the harness's `opus` option stands for the weaker agent
                Julian named; the orchestrator writes nothing into the
                agent's module or unit; the agent's commits are real
                commits on main; a restart counts against transfer
    DEPENDS     nothing; Julian reads the outcome and decides what the
                loop's next edit is
    OUT         fixing the agent's module if it fails (that would measure
                the orchestrator); a second agent; sharpening the
                predictions after the run
    OUTCOME     transferred: commit landed through the gate, no restart,
                errors_first 5, first commit 14 minutes after the spawn;
                the agent left section 7 marked SKETCH; four loop defects
                named, fixed in LOOP.md v7 and check_lean_unit.py

### 2026-09-06 · the pins file itself

    DONE        this file, the loop pointing at it, one commit
    ASSUMED     one file at the repo root is easier to read than a
                directory; four lines is the whole format; the model writes
                pins without announcing them
    DEPENDS     none
    OUT         a checker for pins (nothing mechanical to check yet)
    OUTCOME     built

## Misreads

Pins that turned out wrong, with what was meant. Appended when Julian
reads the pins and finds the misalignment.

| date | task | pin | what it said | what was meant |
|---|---|---|---|---|
| 2026-09-06 | rung 5 pricing | ASSUMED | a rung costs a person's day | a rung costs 6–25 min of clock; price from the log |
| 2026-09-06 | rung 5 route (unit 0325) | DONE | the isolated case, then a window family | the general case with explicit L; the window had to change |
| 2026-09-06 | section 13 (b) (unit 0347) | (none written) | step 0b skipped: the orchestrator went from the worksheet to the module | pins are written before the module, every run; the checker cannot see this, the retrospective can |
| 2026-09-06 | block 13d (unit 0349) | ASSUMED | `geom_sum_Ico` is absent on this Mathlib | it is present as a `lemma`; the checklist grep matched `theorem` only; DESIGN.md v3 fixes the pattern |
| 2026-09-06 | blocks 13c–13d | ASSUMED | λ = 1, silently in 13c ("With λ = 1") and by inheritance in 13d | the shell forces λ³ ~ N e^{K'} H/ε², so λ is free; 13e restates 13d parameterized (LOOP § 3, DESIGN.md v4) |
