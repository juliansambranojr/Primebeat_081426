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

### 2026-11-24 · block S10 of `design/stencil.md`, step 4a: `Stage3/Littlewood.lean`

    DONE        `littlewood_rect`: for f analytic near a rectangle
                [a,b]×[c,d], nonzero on its edges, 2π·Σ order·(Re ρ − a) over
                its zeros equals ∫_c^d log‖f(a+it)‖ − ∫_c^d log‖f(b+it)‖ plus the
                two horizontal terms, written with no branch of arg; one unit
    ASSUMED     Julian, 2026-11-24: "Go" (step 4a). Built as the first brick
                of 4d (Levinson): 4b–4c only reach Bohr–Landau, which
                `zero_density` already gives (unit 0513)
    DEPENDS     PNT+ `rectangleIntegral_logDeriv_eq_sum_meromorphicOrderAt`,
                `divisor_support_rectangle_finite`; Mathlib Fubini
    OUT         4b, 4c (covered by `zero_density`); Levinson's lemma and the
                mean value left of the line (4d)

### 2026-11-24 · block S10 of `design/stencil.md`, step 3: `Stage3/LineCount.lean`

    DONE        `rh_iff_line_count` (RH ↔ for every T the zeros on the line
                up to height T, with multiplicity, number as many as all
                nontrivial zeros up to T) and `signChanges_le_line_count`
                (k alternating sign changes of Λ on the line in (0, T] give at
                least k zeros on the line up to T); one unit
    ASSUMED     Julian, 2026-11-24: "Yes log and and start step 3 please".
                The count is a finite sum of `riemannZeta.order` over zeros
                with 0 < Im ≤ T, not the smooth θ(T)/π split (no θ is defined)
    DEPENDS     `HardyZ`, `Kadiri` zero counting (`nontrivialZeros_abs_im_lt_finite`)
    OUT         θ(T)/π and S(T); the floor (step 4)

### 2026-11-24 · block S10 of `design/stencil.md`, steps 1 and 2: `Stage3/HardyZ.lean`

    DONE        `xi_line_real` (Λ(1/2 + it) is real for real t, from
                `completedRiemannZeta_one_sub` and conjugation) and
                `signChange_zero_on_line` (a sign change of t ↦ Λ(1/2 + it)
                on [t₁, t₂] gives ζ(1/2 + iγ) = 0 with γ ∈ [t₁, t₂]); one unit
    ASSUMED     Julian, 2026-11-24: "Yes and loop please" (step 1 of S10).
                Hardy's Z is taken as Λ on the line, which differs from Z by
                the positive factor |Gammaℝ|, so no continuous phase θ is defined
    DEPENDS     Mathlib `completedRiemannZeta`, `Gammaℝ`, `Complex.Gamma_conj`
    OUT         θ(t), the count rh_iff_signChanges (step 3), the floor (step 4)

### 2026-11-24 · block S6 of `design/stencil.md`: `Stage3/ReachRoute.lean`

    DONE        `reached_mode_false`: under H, a mode right of σ reached from
                0 inside the component along points whose distance to it is
                at most M times their distance to every other mode gives
                False; it holds isolation as a special case; one unit
    ASSUMED     Julian, 2026-11-24: case 2 on the ψ ladder (the answer
                "Case 2 on the ψ ladder"). Built by one worker from S6's text
    DEPENDS     `ResidueRoute` (`G_eq_F`, `differentiableAt_G`, `P_bound`,
                `differentiableAt_F`, `summable_coef`, the fibre step)
    OUT         modes that every approach from 0 meets tangentially; a limit
                set that separates the modes from 0; H

### 2026-11-24 · block S5 of `design/stencil.md`: `Stage3/LadderAssembly.lean`

    DONE        `top_mode_on_frontier` (an attained top real part puts its
                mode on the frontier of the component of 0, every σ below
                it) and `rh_of_ladder_tame`: H, and off the line a top zero
                that is attained with its mode isolated, give
                `RiemannHypothesis`; one unit
    ASSUMED     Julian, 2026-11-24: "Start the loop" (steps (D) and the
                assembled theorem). Built by one worker from S5's text
    DEPENDS     `ResidueRoute.isolated_boundary_mode_false`
    OUT         a top real part that is not attained; an attained top mode
                that other modes accumulate on

### 2026-11-24 · block S4 of `design/stencil.md`: `Stage3/ResidueRoute.lean`

    DONE        `isolated_boundary_mode_false`: under the ladder bound H, a
                zero right of σ whose mode is isolated in the closure of the
                modes and on the boundary of the component of its complement
                holding 0 contradicts H; one unit
    ASSUMED     Julian, 2026-11-24: "Start the loop" (ladder-route assembly,
                step (A1)). Built by one worker from the design's paper text
    DEPENDS     `FilterLadder`, `ZeroDensity`, `ZeroSummable`, `FilterAccum`
    OUT         modes accumulating on a set that separates them from 0

### 2026-11-24 · block R16 of `design/runs.md`: `Stage3/WindowsOfRH.lean`

    DONE        `windows_of_rh`: RiemannHypothesis → ∀ θ ∈ (1/2, 1), ∃ δ C,
                0 < δ ∧ LandauWindow.WindowBound θ δ C; with
                `rh_of_windows` the window bound becomes a full face of the
                chain; one unit
    ASSUMED     Julian, 2026-11-24: "do this first": the reverse direction.
                Route S1–S5 of the design block. Built by one worker
    DEPENDS     `Saddle.spiralLink_iff_noRunaway`, `SpiralLink.rh_iff_spiralLink`,
                `LandauMellinG.mellin_G`, `LandauPoleLocal.Phi_regular_at_one`,
                `JointDialGate.log_absorbed`, Mathlib's Abel summation
    OUT         the window bound without RH

### 2026-11-24 · block R15 of `design/runs.md`: `Stage3/Doubling.lean`

    DONE        `alt_scales`: Σ_{k≤N} (−1)^(k+1) ψ(N/k) = log N! − 2 log⌊N/2⌋!;
                `alt_resid_small`: the residuals at the scales, alternating,
                add to O(log N); the induction toward `NoRunaway` attempted
                and its stopping step named; one unit
    ASSUMED     Julian, 2026-11-24: "let's try it": prove `NoRunaway`.
                Built by one worker
    DEPENDS     `SelfBound.self_bound`, `NoHoles.log_factorial_close`,
                `NoHoles.psi_floor`
    OUT         nothing chosen out; the stopping step is reported

### 2026-11-24 · block R14 of `design/runs.md`: `Stage3/PerfectFit.lean`

    DONE        `perfect_fit`: Σ_{k≤N} μ(k)·⌊N/k⌋ = 1 for every N ≥ 1;
                one unit
    ASSUMED     Julian, 2026-11-24: "I do": the harmonic of the integers
                absorbs the primes' signs perfectly. Written and built here
    DEPENDS     `NoHoles.moebius_floor_inversion`
    OUT         the same for the log-weighted harmonic (it is `NoRunaway`)

### 2026-11-24 · block R13 of `design/runs.md`: `Stage3/NoHoles.lean`

    DONE        `moebius_floor_inversion`; `psi_by_integers`: the staircase
                is the Möbius-signed sum of the integers' log-factorials at
                the scales N/k; `log_factorial_close`: each log-factorial is
                its smooth part within a log; `holes_resid`: the residual
                split into the smooth part's sum and the integers' errors;
                the stopping step named; one unit
    ASSUMED     Julian, 2026-11-24: "Do it": use that the integers have no
                holes to bound the residual. Built by one worker
    DEPENDS     `SelfBound.self_bound`, Mathlib's Möbius and Stirling
    OUT         the square-root bound, if the Möbius signs are needed for it

### 2026-11-23 · block J11 of `design/closedloop.md`: `Stage3/WholeChain.lean`

    DONE        `whole_chain` names the channel; `table_side` names the
                sieve's idempotence and the settling on a prime;
                `readings_side` gathers block J10. One unit
    ASSUMED     Julian, 2026-11-23: "do this too": the closing theorem names
                HolyChannel and Readings. Conjunctions of proved theorems
    DEPENDS     `HolyChannel`, `Readings`, `SieveIdem`
    OUT         a proof of the link

### 2026-11-23 · block R12 of `design/runs.md`: `Stage3/SieveIdem.lean`

    DONE        `sieveStep_idem`, `sieveStep_comm`, `mem_sieveStep`,
                `sieveBelow_idem`, `sieveBelow_succ`, `rough_eq_card`,
                `settles_on_prime`; one unit
    ASSUMED     Julian, 2026-11-23: the settling is one slot at a time
                because of idempotence; every step is the same f and scales
                at any x. Written and built here
    DEPENDS     `CompositeSplit.rough`
    OUT         a size for the sum of the roundings

### 2026-11-23 · block J10 of `design/closedloop.md`: `Stage3/Readings.lean`

    DONE        each run and reading of the day stated in Lean where it has
                an exact form, proved where Lean accepts it, the stopping
                step named where it does not; one unit
    ASSUMED     Julian, 2026-11-23: "prove" the runs (0492, 0497, 0499, the
                1.5 table) and the readings (current and wire, 5/6, no memory,
                paper §5.3 (iv)). Measured counts at 2^24 and beyond are not
                checked by the kernel without `native_decide`, which the repo
                refuses. Written and built here
    DEPENDS     `ClosedLoopChain`, `ClosedLoopJoin.restoringForce`,
                `Saddle.spiralLink_iff_noRunaway`
    OUT         SpiralLink itself

### 2026-11-23 · block J9 of `design/closedloop.md`: `Stage3/HolyChannel.lean`

    DONE        `holy_pair_shares`: a zero at the support's share has its
                mirror at the condition's. `member_is_two`: a zero at a
                member's share is two mirrors and does not meet its own.
                `meet_iff_channel`: a zero meets its mirror exactly at the
                Holy Family's midpoint. `spiralLink_iff_channel`; one unit
    ASSUMED     Julian, 2026-11-23: the uneven pair 1/3, 2/3 is the residual
                every prime carries; the zero is the channel it passes
                through. "Yes" to stating the target. Written and built here
    DEPENDS     `ClosedLoopChain.HolyFamily`, `ShareLink.meet_iff`,
                `SpiralLink.mirrorZ_eq_iff`, `SpiralLink.off_line_is_two`
    OUT         a proof that every zero is the channel

### 2026-11-23 · block J8 of `design/closedloop.md`: `Stage3/WholeChain.lean`

    DONE        `whole_chain`: the spiral link with every compiled face.
                `table_side`: the table's exact statements, no zero in them.
                `steps_side`: what a zero does to the staircase and the
                turned steps; one unit
    ASSUMED     Julian, 2026-11-23: today's work was the table and must not
                end somewhere else. Conjunctions of proved theorems. Written
                and built here
    DEPENDS     `OneChain.one_chain`, `Saddle`, `ShareLink`, `BandJoin`,
                `HalfSieve`, `Compression`, `CompositeSplit`, `SelfBound`,
                `SieveExact`, `RunTheorems`, `StepsBelow`, `RateBelow`
    OUT         a proof of the link
    OUTCOME     proved, unit 0496

### 2026-11-23 · block J7 of `design/closedloop.md`: `Stage3/Saddle.lean`

    DONE        `fold_rounding`, `fold_mirror`: one row down is the baker's
                fold on every rounding, and it commutes with the mirror.
                `saddle_area`, `saddle_of_off_line`, `centre_iff`: off the
                line a saddle, on the line a centre. `saddle_runs_away`.
                `spiralLink_iff_noRunaway`, `spiralLink_iff_centres`; one unit
    ASSUMED     Julian, 2026-11-23: "Go for sequence 1-3 and saddle". Written
                and built here
    DEPENDS     `RateBelow.rain_psi`, `ShareLink.mode_size`,
                `Stage3.zeroFreeRight_iff_psiWeakTheta`
    OUT         a proof that the staircase does not run away
    OUTCOME     proved, unit 0495; step (3) stated, unproved

### 2026-11-23 · block J6 of `design/closedloop.md`: `Stage3/ShareLink.lean`

    DONE        `share_is_re`: the real part of a zero is the share of the
                total its mode takes, on the multiplying scale.
                `pair_shares_add`: a zero's share and its mirror's add to
                one. `meet_sqrt_iff`: the mode is the square root of the
                total exactly at one half. `swap_flips_residual`,
                `spiralLink_iff_meet`; one unit
    ASSUMED     Julian, 2026-11-23: "flip the table inside out and it becomes
                a line". Written and built here
    DEPENDS     `SpiralLink.mirrorZ_re`, `ClosedLoopJoin.rh_iff_re_half`
    OUT         that the zeros' mirror is the table's swap
    OUTCOME     proved, unit 0494

### 2026-11-23 · block R11 of `design/runs.md`: `Stage3/Compression.lean`

    DONE        `unique_new_prime`: a number up to `N` has at most one prime
                above `√N`. `compression`: the numbers up to `N` are the
                combinations of the primes up to `√N` and the multiples of
                the new primes, nothing counted twice; one unit
    ASSUMED     Julian, 2026-11-23: "Primes are compression of the composites
                up to that step". Written and built here
    DEPENDS     `SieveExact.card_multiples`, Mathlib `Finset.card_biUnion`
    OUT         the size of the residual of the combinations' count
    OUTCOME     proved, unit 0491

### 2026-11-23 · block R10 of `design/runs.md`: `Stage3/CompositeSplit.lean`

    DONE        `composites_by_least_prime`: every composite up to `N` once,
                under its least prime, no signs. `card_least_prime`: a
                prime's part is the table's count at the scale `N/p`.
                `composites_no_signs`: the composites as a sum of counts; one
                unit
    ASSUMED     Julian, 2026-11-23: "Have you looked at the composite table
                for the answer?" Written and built here
    DEPENDS     `SieveExact.smallPrimes`, Mathlib `Nat.minFac`
    OUT         a bound on the residual from the tie across the scales
    OUTCOME     proved, unit 0490

### 2026-11-23 · block R9 of `design/runs.md`: `Stage3/RateBelow.lean`, `Stage3/StepsBelow.lean`

    DONE        `rain_psi`: at a zero, for every exponent below its real
                part, the staircase leaves the bound at points beyond any
                start. `rain_steps`: the same for the turned steps to a
                cutoff; one unit each
    ASSUMED     Julian, 2026-11-23: "at some point  you can see the rain is
                coming". The staircase from `no_zero_right_of_theta`, written
                and built here. The turned steps by an Opus worker
    DEPENDS     `Stage3.no_zero_right_of_theta`, `StepsPole.steps_pole`,
                `StepsPeak.S`
    OUT         where the rise happens
    OUTCOME     `rain_psi` proved, unit 0489; `rain_steps` proved, unit 0493

### 2026-11-23 · block J5 of `design/closedloop.md`: `Stage3/BandJoin.lean`

    DONE        `zero_image`, `zero_in_band`: every zero lands strictly inside
                the band of the deep zero. `zero_pair`: a zero and its mirror
                multiply to one half, as a cell's two shares do
                (`share_pair`). `spiralLink_iff_middle`: the link is every
                zero on the middle circle; one unit
    ASSUMED     Julian, 2026-11-23: "the inversion of the deep zero flips the
                table into a band". `lean/DeepZeroBand.lean` restated at base
                two, composed by statement. Written and built here
    DEPENDS     `SpiralLink.mirrorZ_re`, `ClosedLoopJoin.rh_iff_re_half`
    OUT         an identification of a cell's share with a zero's real part
    OUTCOME     proved, unit 0488

### 2026-11-23 · block R8 of `design/runs.md`: `Stage3/StepsRate.lean`

    DONE        `norm_K_le_pow`: a zero's kernel is at most the cutoff to the
                gap of the real parts. `rate_upper`: away from the zeros the
                turned steps less their smooth term grow at most as the
                cutoff to the largest real part below the height less the
                real part of the point; one unit
    ASSUMED     Julian, 2026-11-23: "are you going to fix 1, 2, 3 and 4 on
                the list". The second size of item 3, its upper half.
                Written and built here
    DEPENDS     `StepsPeak.peak_formula`, `StepsPeak.K_eq`
    OUT         the lower half of the rate
    OUTCOME     proved, unit 0487

### 2026-11-23 · block R7 of `design/runs.md`: `Stage3/SelfBound.lean`

    DONE        `self_bound`: the staircase read at `N`, `N/2`, …, `N/N` adds
                up to the logarithms of the integers up to `N`, at every `N`.
                `self_bound_resid`: the residuals across those scales add up
                to a quantity with no prime in it; one unit
    ASSUMED     Julian, 2026-11-23: "It holds because it is bounded by itself
                and never more or that wouldn't be the same number line."
                Written and built here
    DEPENDS     Mathlib `ArithmeticFunction.vonMangoldt_sum`,
                `SieveExact.card_multiples`
    OUT         a bound at one scale; the Möbius inversion
    OUTCOME     proved, unit 0486

### 2026-11-23 · block R6 of `design/runs.md`: `Stage3/HalfSieve.lean`

    DONE        `ignition_is_zeta_zero`: the half of every doubling is minus
                zeta at zero. `netRounding_centered`: the half of every
                rounding cancels in the sieve. `resid_of_wobble`: the wobble
                at square-root size carries the residual, no factor lost.
                `spiralLink_iff_wobble`: the spiral link is the wobble at
                square-root size; one unit
    ASSUMED     Julian, 2026-11-23: "Half is the difference that anything is
                differentiated at all". Item 4 of the list, by his route.
                Written and built here
    DEPENDS     `SieveResidual.net_wobble`, `PiToPsi.RH_iff_schoenfeldWeak`,
                `SpiralLink.rh_iff_spiralLink`, Mathlib `riemannZeta_zero`
    OUT         the size of the wobble itself
    OUTCOME     proved, unit 0485

### 2026-11-23 · block R5 of `design/runs.md`: `Stage3/StepsPeak.lean`

    DONE        `peak_formula`: the turned steps to a cutoff `N` with the ramp,
                written through the zeros below `T`, with the error bound.
                `peak_at_zero`: at a zero of order `m` the term `−m·log N`.
                `peak_height`: the other zeros' part when none lies to the
                right; one unit
    ASSUMED     Julian, 2026-11-23: "are you going to fix 1, 2, 3 and 4 on
                the list". The first size left in item 3. An Opus worker
                writes it; read and built here
    DEPENDS     `ExplicitTwo.explicit_formula_all_two`, Mathlib partial
                summation
    OUT         the size rate; summability over all zeros if the tree lacks it
    OUTCOME     proved, unit 0484

### 2026-11-23 · block R4 of `design/runs.md`: `Stage3/StepsPole.lean`

    DONE        `steps_sum`: the turned steps are `−ζ'/ζ` for `Re s > 1`.
                `steps_pole`, `steps_pole_ne_zero`: a pole at every nontrivial
                zero, of weight `m/ρ`. `steps_regular`: none elsewhere; one
                unit
    ASSUMED     Julian, 2026-11-23: "The runs should be theorems." The exact
                core of unit 0472. Written and built here
    DEPENDS     `ContourShift.zeta_local_data_zero`, Mathlib
                `LSeries_vonMangoldt_eq_deriv_riemannZeta_div`
    OUT         the height of a finite peak; the size rate
    OUTCOME     proved, unit 0483

### 2026-11-23 · block R3 of `design/runs.md`: `Stage3/SieveResidual.lean`

    DONE        `net_wobble`: for `N ≥ 2`, the sieve's net rounding less its
                smooth part is minus the residual of the count at `N` less
                the residual at `√N`. `net_wobble_rows`: at row `2m`, the
                table's residual at row `2m` less at row `m`; one unit
    ASSUMED     Julian, 2026-11-23: "are you going to fix 1, 2, 3 and 4 on
                the list". Item 2 in the form the numbers allow: the net
                rounding is of the order of the count (unit 0475, corrected);
                its wobble is the table's residual. Written and built here
    DEPENDS     `SieveExact.netRounding_eq`, `Stage3.Li`
    OUT         the size of the residual at the two rows
    OUTCOME     proved, unit 0482

### 2026-11-23 · block R2 of `design/runs.md`: `Stage3/SieveExact.lean`

    DONE        `pi_by_sieve`, `row_by_sieve`: the count of primes up to `N`
                from the primes up to `√N`, exactly, for every `N ≥ 2`.
                `sieve_by_level`, `level_card`: by levels, each level a
                binomial coefficient of terms. `sieve_split`,
                `smoothPart_eq_prod`: the count is `N·Π(1 − 1/p)` less the
                net of the roundings; one unit
    ASSUMED     Julian, 2026-11-23: "The runs should be theorems." The exact
                core of unit 0475. Written by an Opus worker; read and built
                here
    DEPENDS     Mathlib
    OUT         the size of the net rounding
    OUTCOME     proved, unit 0481

### 2026-11-23 · block R1 of `design/runs.md`: `Stage3/RunTheorems.lean`

    DONE        `mode_fold`: a height shows on the ladder only up to
                `2π/log 2`. `two_mode_beat`, `mode_cross`, `zero_pair_beat`:
                two modes together carry a term turning at the difference of
                their heights, at every row; one unit
    ASSUMED     Julian, 2026-11-23: "The runs should be theorems." The exact
                cores of units 0473 and 0474. Written and built here
    DEPENDS     Mathlib `Complex.normSq_add`, `Complex.exp_int_mul_two_pi_mul_I`
    OUT         the sieve's exact sum (block R2); the runs' sizes
    OUTCOME     proved, unit 0480

### 2026-11-23 · block J4 of `design/closedloop.md`: `Stage3/OneChain.lean`

    DONE        `one_chain`: RH, `SpiralLink`, `OneAtEachHeight`, the force at
                rest at every zero, and every cell of every dyadic ladder at
                square-root size are one statement. `table_of_spiralLink`;
                `spiralLink_of_finite`, `spiralLink_of_attained`,
                `spiralLink_of_attained_psi`,
                `spiralLink_of_finite_accumulation`; `no_exposed_zero`; one
                unit
    ASSUMED     Julian, 2026-11-23: "Is the loop compiled by itself or does
                it connect to every theorem in the tree". The capstone that
                ties the loop to the tree's main theorems. Written and built
                here
    DEPENDS     `SpiralLink.rh_iff_spiralLink`, `CellResidual.RH_iff_cells`,
                `table_cell_resid`, `AttainedPi.attained_off_line_pi`,
                `FiniteOffLinePi.finite_off_line_pi`,
                `FilterAccum.rh_of_finite_accumulation`,
                `CountEuler.euler_exposed_false`
    OUT         `SpiralLink` with no hypothesis; the map
    OUTCOME     proved, unit 0479

### 2026-11-23 · block J3 of `design/closedloop.md`: `Stage3/ClosedLoopChain.lean`

    DONE        the closed loop's Parts I, III, IV, V, VI restated and joined:
                `holyFamily_is_mirror_pair`, `holyFamily_pair_area`,
                `holyFamily_force`; `row_at_midpoint`: the table's row read at
                the doubling's midpoint; `primeBeatTerm_eq_im`: the Beat is
                the imaginary part of the walk; one unit
    ASSUMED     Julian, 2026-11-23: "Join the part to the tree." "The point of
                the lean files is to show that all the theorems connect to
                each other." Written and built here
    DEPENDS     `ClosedLoopJoin.force_eq`, `ClosedLoopJoin.primeWeight`
    OUT         a proof of `SpiralLink.SpiralLink`; the map
    OUTCOME     proved, unit 0478

### 2026-11-23 · block J2 of `design/closedloop.md`: `Stage3/SpiralLink.lean`

    DONE        `SpiralLink`: the handshake at every zero, the paper's "the
                spiral can only converge at σ = 1/2", as a Lean proposition.
                `OneAtEachHeight`: no two zeros share a height. `mirrorZ`,
                `mirrorZ_eq_iff`, `off_line_is_two`: an off-line zero is two
                zeros at one height. `rh_iff_spiralLink`,
                `rh_iff_one_at_each_height`, `spiralLink_iff_one`; one unit
    ASSUMED     Julian, 2026-11-23: "State that link in lean". Stated, and
                shown equal to "there is just one zero" and to RH. Written
                and built here
    DEPENDS     `ClosedLoopJoin.rh_iff_handshake`, `WeilOnLine.conj_mem`,
                Mathlib `riemannZeta_one_sub`
    OUT         a proof of either proposition; the map
    OUTCOME     proved as stated, unit 0477

### 2026-11-23 · block J1 of `design/closedloop.md`: `Stage3/ClosedLoopJoin.lean`

    DONE        `force_join`: the closed loop's restoring force and the
                tree's mirror imbalance are one, up to `2·log b/5`.
                `handshake_iff_sides`: the handshake is the mode and its
                mirror agreeing in size at every prime above three.
                `structural_contradiction`, `off_line_zero`: the closed
                loop's theorem, and the same on a zero of zeta.
                `rh_iff_force_zero`, `rh_iff_handshake`; one unit
    ASSUMED     Julian, 2026-11-23: "I'm pretty sure the restarting force and
                a contradiction proof is in there". They are, in
                `lean_primebeat/PrimeBeat/primebeat_closed_loop.lean`. The
                four definitions restated word for word; written and built
                here
    DEPENDS     `StencilWeil.restoringForce_eq`,
                `MirrorArea.long_side_of_off_line`,
                `LandauWindow.rh_of_zeroFree_half`
    OUT         a statement that the force is zero at a zero of zeta; the map
    OUTCOME     proved, unit 0476

### 2026-11-23 · blocks N2, N3-E of `design/countmodes.md`: `Stage3/CountReduction.lean`, `Stage3/CountEuler.lean`

    DONE        `CountReduction.count_modes_small`: under the ladder bound on
                `π`, `1/2 < σ < Θ ≤ 1`, `β ≤ Θ`: there is `E`, `σ ≤ E < Θ`,
                with `‖Σ'_{β≥σ} m·J_k‖ ≤ A·k²·2^(kE)` for `k ≥ 2`;
                `tail_rate`, `summable_J`; one unit.
                `CountEuler.euler_exposed_false`: no zero with `β > E` has
                its mode strictly outside a disc, centred on the ray
                opposite to it, that holds every other mode right of `σ`;
                one unit
    ASSUMED     Julian, 2026-11-23: "Merge then the count". The design as
                corrected by an independent review; N3-E is the reviewer's
                derivation and the build is its first check. Written by Opus
                workers; read and built here
    DEPENDS     `CountModes.piMode_doubling`, `PiZeros.pi_eq_zero_sum`,
                `FixedRowTwo.norm_tr_efRem_le_height_two`,
                `ZeroDensity.zero_density`, `ZeroSummable.shell_sum_le`,
                `AliasClass.re_order_div_pos`
    OUT         the forms with slits; modes stacked along one ray
    OUTCOME     proved: `CountReduction` unit 0470, `CountEuler` unit 0471

### 2026-11-23 · block N1 of `design/countmodes.md`: `Stage3/CountModes.lean`

    DONE        `piMode_doubling`: for a zero `ρ`, `k ≥ 1`,
                `piMode ρ (2^k) = J_k(ρ·log 2) + c_ρ`, `J_k` the integral of
                the radial segment of modes; `norm_J_le`, `norm_c_le`;
                `im_ne_zero`: no nontrivial zero is real; one unit
    ASSUMED     Julian, 2026-11-23: "Merge then the count". The design as
                corrected by an independent review. Written by an Opus
                worker; read and built here
    DEPENDS     `PiZeros.piMode`, `FiniteOffLinePi.piMode_eq`, PNT+
                `Zeta0EqZeta`
    OUT         blocks N2, N3-E; the forms with slits
    OUTCOME     proved, unit 0469

### 2026-11-23 · design `design/countmodes.md`, blocks N1 to N3: joint 10 on the count's ladder

    DONE        the design reviewed by an independent worker asked to break
                it; no Lean yet
    ASSUMED     Julian, 2026-11-23: "Merge then the count". On the count's
                ladder a zero is a radial segment of modes; the filters of
                units 0466 to 0468 do not remove a segment; the route is the
                generating function with slits
    DEPENDS     `PiZeros.pi_eq_zero_sum`, `ZeroDensity.zero_density`,
                `PiRemainder.zinv_le_log`, `FixedRowTwo.tr_efRem_fixed_two`
    OUT         the Lean of N1 to N3 until the review is in

### 2026-11-23 · blocks S2, S3 of `design/stencil.md`: `Stage3/FilterAttained.lean`, `Stage3/FilterAccum.lean`

    DONE        `FilterAttained.filter_attained_false`: under the ladder bound
                on `ψ`, no filter `q`, `a·deg q < b`, and line `σ > 1/2` has
                its largest rate `|z^b·q(1/z)^a|` attained by a zero above
                `2^(σb)·‖q‖_W^a`. `attained_psi`: the largest real part
                attained, on the ladder of `ψ`; one unit.
                `FilterAccum.finite_accumulation_false`: the modes right of
                `σ` accumulating at finitely many points, with a zero right
                of `σ` off those points, contradict the bound; one unit
    ASSUMED     Julian, 2026-11-23: "So try, it's possible". The design as
                corrected by an independent review. Written by Opus workers;
                read and built here
    DEPENDS     `FilterLadder.filtered_modes_small_sq`,
                `LadderMean.mean_extract`, `ZeroSummable.summable_order_div`,
                `AliasClass.re_order_div_pos`
    OUT         the accumulation set that separates the modes from the
                origin; the residue route; the count in place of `ψ`
    OUTCOME     proved: `FilterAttained` unit 0467, `FilterAccum` unit 0468

### 2026-11-23 · block S1 of `design/stencil.md`: `Stage3/FilterLadder.lean`

    DONE        `filtered_modes_small`: if `|ψ(2^k) − 2^k| ≤ C·k²·√2^k` for
                `k ≥ 1`, then for every polynomial `q`, every `σ > 1/2`, and
                `m·deg q < n`, the zeros with `Re ρ ≥ σ` below height `2^n`,
                each weighted by `q(2^(−ρ))^m`, sum to at most
                `A·n⁴·2^(nσ)·‖q‖_W^m`; one unit
    ASSUMED     Julian, 2026-11-23: "So try, it's possible". A paper
                derivation of one sitting; the build is its first check.
                Written by an Opus worker; read and built here
    DEPENDS     `ExplicitTwo.explicit_formula_all_two`,
                `PiRemainder.zinv_le_log`, `PiZeros.zeroPartialSum_eq_sum`
    OUT         blocks S2, S3; the count in place of `ψ`; the screening
                arrangement
    OUTCOME     proved, unit 0466; the factor is `n²`, the constant free of `σ`

### 2026-11-23 · block G3 of `design/floor.md`: `Stage3/FixedRowTwo.lean`

    DONE        `cell_fixed_row_two` for `r ≥ d + 1`, `pi_fixed_row_two` for
                `x ≥ 2`, `table_cell_fixed_row_two` for `r ≥ d + 2`: T3 at a
                fixed row at every row where the cell's identity holds; one
                unit
    ASSUMED     Julian, 2026-11-23: "Ok do it". The fixed-row theorems
                restated on the formula from `x = 2`. Written by an Opus
                worker; read and built here
    DEPENDS     `ExplicitTwo.explicit_formula_all_two`,
                `CellFixedRow.tendsto_log_sq_div`, `PiZeros.pi_eq_zero_sum`,
                `table_cell_eq_zero_sum`, `PiRemainder.integrable_efRem`
    OUT         joint 10; numerals above the constants
    OUTCOME     proved, unit 0465

### 2026-11-23 · blocks G1, G2 of `design/floor.md`: `Stage3/PerronTwo.lean`, `Stage3/ExplicitTwo.lean`

    DONE        `PerronTwo.explicit_formula_perron_two`: Perron's formula for
                `2 ≤ x`, `2 ≤ T`, error `700·x·log²(xT)/T + 18·log x`; one
                unit. `ExplicitTwo.explicit_formula_all_two`: the explicit
                formula for `2 ≤ x`, every `T ≥ 2`, error
                `c1t·x·log²(xT)/T + c3t·log x + Bleft2·x^(−1/4)`; one unit
    ASSUMED     Julian, 2026-11-23: "The explicit formula below x = 16 is
                still not in the tree". A parallel chain in new files; no
                proved file edited, no existing constant changed. Written by
                Opus workers; read and built here
    DEPENDS     `Stage3/PerronKernel.lean`, `ContourShift.residue_rectangle_of_local`,
                `Glue.zeta_logderiv_good_bound_num`,
                `Slice5.norm_logDerivZeta_of_one_lt_re`,
                `LeftKernel.kernel_bound`, `LeftSmooth.logDeriv_sum`
    OUT         numerals above `c1t`, `c3t`; the cells at the lowest rows
    OUTCOME     proved: `PerronTwo` unit 0463, `ExplicitTwo` unit 0464

### 2026-11-23 · block F4 of `design/leftedge.md`: `Stage3/PiFixedRow.lean`

    DONE        `pi_fixed_row`: for `16 ≤ x`, every tolerance, from some
                height on, `π(⌊x⌋) − Li x` plus the zeros below the height
                (each through `piMode`) plus `tr psiTheta x` is
                `≤ Api·log x + ε`. `table_cell_fixed_row`: the same under the
                stencil for the integer table's cell. `sum_order_inv_sq_le`,
                `norm_low_integral_le`, `tr_efRem_fixed`: the pieces; one unit
    ASSUMED     Julian, 2026-11-23: "Start". The count in place of `ψ` at a
                fixed row. Below `16` the explicit formula is not in the
                tree; there the zeros are integrated by parts in `t`. Written
                by an Opus worker; read and built here
    DEPENDS     `PiZeros.pi_eq_zero_sum`, `table_cell_eq_zero_sum`,
                `LeftSmooth.explicit_formula_all`,
                `PiRemainder.sum_order_inv_le`, `integrable_efRem`
    OUT         the limit of the zero sum as a number; the explicit formula
                below `16`
    OUTCOME     proved, unit 0462

### 2026-11-23 · block F3 of `design/leftedge.md`: `Stage3/CellFixedRow.lean`

    DONE        `cell_fixed_row`: at a fixed row `r ≥ d + 4`, for every
                tolerance, from some height on the cell of `ψ`, less its main
                term, plus the zeros below the height is
                `≤ 2^d·(c3n·log 2·r + Bleft) + ε`. `cell_eq_zero_sum_all`,
                `cell_zero_sum_finset_all`: the cell formula at every height;
                one unit
    ASSUMED     Julian, 2026-11-23: "T3 at a fixed row (the explicit formula
                above x²)." Written by an Opus worker; read and built here
    DEPENDS     `LeftSmooth.explicit_formula_all`,
                `CellZeros.stencil`, `FiniteOffLine.tsum_sub_eq_sum`
    OUT         the same passage for the integer count
    OUTCOME     proved, unit 0461

### 2026-11-23 · block F2 of `design/leftedge.md`: `Stage3/LeftKernel.lean`, `Stage3/LeftSmooth.lean`

    DONE        `LeftKernel.osc_by_parts`, `kernel_bound`, `series_side`: the
                turning factor integrated by parts; the Dirichlet-series half
                of the left edge `≤ Bser·x^(−1/4)` at every height; one unit.
                `LeftSmooth.smooth_side`, `left_edge_bound`,
                `explicit_formula_all`: the gamma-factor half, the edge
                `≤ Bleft·x^(−1/4)`, the formula at every height with no
                logarithm of the height in the last term; one unit
    ASSUMED     Julian, 2026-11-23: "T3 at a fixed row (the explicit formula
                above x²)." Unit 0457's repair. Written by Opus workers; read
                and built here
    DEPENDS     `ExplicitLeft.explicit_formula_left`, Mathlib
                `riemannZeta_one_sub`,
                `LSeries_vonMangoldt_eq_deriv_riemannZeta_div`, PNT+
                `Complex.hasSum_digamma`
    OUT         the cell at a fixed row (block F3)
    OUTCOME     proved: `LeftKernel` unit 0459, `LeftSmooth` unit 0460

### 2026-11-23 · block F1 of `design/leftedge.md`: `Stage3/ExplicitLeft.lean`

    DONE        `explicit_formula_left`: for `16 ≤ x`, `2 ≤ T` the explicit
                formula with no cap on the height and the left edge kept as a
                term. `edge_left_any`: that edge `≤ A·log²T'·x^(−1/4)` at
                every height. `explicit_formula_any`: the two joined; one unit
    ASSUMED     Julian, 2026-11-23: "T3 at a fixed row (the explicit formula
                above x²)." The cap enters `explicit_formula_split_num` once,
                at the left edge. Written by an Opus worker; read and built
                here
    DEPENDS     `PerronKernel.explicit_formula_perron`,
                `ContourShift.residue_identity`,
                `Glue.edge_horizontal_bound_num`,
                `Glue.zeroPartialSum_swap_num`,
                `EdgeBound.edge_bound_core_num`
    OUT         the left edge bounded free of the height (block F2); the cell
                at a fixed row (block F3)
    OUTCOME     proved, unit 0458; the lost factor named in unit 0457

### 2026-11-23 · block C7 of `design/carlson.md`: `Stage3/AttainedPi.lean`

    DONE        `attained_off_line_pi`: one zero has the largest real part,
                and `|π(2^r) − Li(2^r)| ≤ C·r²·√2^r` from some row on; then
                RH. Any number of zeros off the line; one unit
    ASSUMED     Julian, 2026-11-23: "Prove Carlson's bound ourselves". The
                second of unit 0431's three cases. Written by an Opus worker;
                read and built here
    DEPENDS     `ZeroSummable.summable_norm_coef`, `sum_le_const`,
                `LadderMean.line_not_fading_summable`,
                `PiZeros.pi_eq_zero_sum`, `PiRemainder.norm_tr_efRem_le_of`
    OUT         the case where the largest real part is not attained
    OUTCOME     proved, unit 0456

### 2026-11-23 · block C6b of `design/carlson.md`: `Stage3/ZeroSummable.lean`

    DONE        `summable_order_div`: for `σ > 1/2` the order over the size is
                summable over the zeros with `Re ρ ≥ σ`. `summable_norm_coef`:
                the hypothesis of `LadderMean.line_not_fading_summable`, for
                any set of zeros with real parts `≥ σ`; one unit
    ASSUMED     Julian, 2026-11-23: "Prove Carlson's bound ourselves". Written
                by an Opus worker; read and built here
    DEPENDS     `ZeroDensity.zero_density`, `Stage3.zeta_local_zero_count`,
                `WeilOnLine.conjZ`, `WeilBands.order_eq_analyticOrderNatAt`
    OUT         block C7
    OUTCOME     proved, unit 0455

### 2026-11-23 · block C6 of `design/carlson.md`: `Stage3/ZeroDensity.lean`

    DONE        `zero_density`: for `1/2 < σ ≤ 1` there are `θ < 1`, `C`, `T₀`
                with `#Z ≤ C·T^θ` for every finite set `Z` of zeros with
                `σ ≤ Re ρ < 1`, `2 ≤ Im ρ ≤ T − 2`, `T ≥ T₀`;
                `θ = 1 − 5δ²`, `δ = (σ − 1/2)/4`; one unit
    ASSUMED     Julian, 2026-11-23: "Prove Carlson's bound ourselves". A
                saving at every `σ > 1/2`; Carlson's exponent is not claimed.
                Written by an Opus worker; read and built here
    DEPENDS     `ZeroSquares.card_zeros_le`, `MollifiedMean.mean_sq_f_le`
    OUT         summability of `m(ρ)/|ρ|`; block C7
    OUTCOME     proved, unit 0454

### 2026-11-23 · block C5 of `design/carlson.md`, second half: `Stage3/ZeroSquares.lean`

    DONE        `card_zeros_le`: for a finite set `Z` of zeros with
                `σ ≤ Re ρ < 1`, `2 ≤ Im ρ ≤ T − 2`,
                `π·δ²·#Z ≤ 3·(15 log T + 73)·` the integral of `‖f X‖²` over
                `[σ − δ, 1 + δ] × [1, T]`; one unit
    ASSUMED     Julian, 2026-11-23: "Prove Carlson's bound ourselves". Written
                by an Opus worker; read and built here. `σ ≤ 1` was added by
                the worker: the statement fails without it on the empty set
    DEPENDS     `SquareMean.sq_mean_lower`, `Stage3.zeta_local_zero_count`,
                `MollifiedMean.f`
    OUT         blocks C6, C7
    OUTCOME     proved, unit 0453

### 2026-11-23 · block C5 of `design/carlson.md`, first half: `Stage3/SquareMean.lean`

    DONE        `sq_mean_lower`: for `f` differentiable on a set containing
                the closed square of half-side `δ` about `c`,
                `π·δ²·‖f c‖² ≤` the iterated integral of `‖f‖²` over the
                square; one unit
    ASSUMED     Julian, 2026-11-23: "Prove Carlson's bound ourselves". Block
                C5a. Written by an Opus worker; read and built here
    DEPENDS     Mathlib: circle averages, polar coordinates, Fubini
    OUT         the count of zeros; blocks C6, C7
    OUTCOME     proved, unit 0452

### 2026-11-23 · blocks C2 to C4 of `design/carlson.md`: `Mollified`, `ZetaEM`, `MollifiedMean`

    DONE        C2 `Mollified.prod_eq_sum`, `sum_coef_sq_weighted_le`; C3
                `ZetaEM.zeta_eq_em`, `norm_zeta_sub_partial_le`; C4 with C2b
                `MollifiedMean.mean_sq_f_le`, `sum_coef_sq_up_le`: the mean
                square of `ζ·M − 1` on a line right of one half, four terms,
                each below the first power of the height for short `X` and
                `N` a small power above `T`; three units
    ASSUMED     Julian, 2026-11-23: "Prove Carlson's bound ourselves". Each
                written by an Opus worker from a brief; read and built here
    DEPENDS     `ZetaGrowth`, `DirichletMeanW`, Mathlib `bernoulliFun`
    OUT         blocks C5 to C7
    OUTCOME     proved, units 0447, 0448, 0451

### 2026-11-23 · the repair of block C1: `Stage3/DirichletMeanW.lean`, block C1b of `design/carlson.md`

    DONE        `dirichlet_mean_value_weighted`, `_sigma`: the mean square of
                a finite Dirichlet sum over a window is at most the sum of
                `|a_n|²·((T₂ − T₁) + 6n(1 + log N))`; one unit
    ASSUMED     unit 0449: block C1 charges `N` to every term and block C4
                then loses the saving. Written by an Opus worker from a brief
    DEPENDS     `DirichletMean.integral_sq_norm_eq`, `norm_integral_exp_le`
    OUT         block C4
    OUTCOME     proved, unit 0450

### 2026-11-23 · a zero-density bound with a power saving, built here: `lean_stage3/design/carlson.md`

    DONE        nothing yet. Seven blocks C1 to C7 in `design/carlson.md`:
                mean value of a finite Dirichlet sum; the mollified finite
                sum; zeta as a finite sum to any order; the mean square of
                `ζ·M − 1` on a line; zeros from the mean square; the bound
                and summability; joint 10 when the largest real part is
                attained
    ASSUMED     Julian, 2026-11-23: "Prove Carlson's bound ourselves, which
                is a large project". A saving at every real part above one
                half is the target; Carlson's exact exponent is not needed.
                Blocks go to Opus workers one at a time; each file is read
                and built here before it is recorded
    DEPENDS     Mathlib; `ZetaGrowth`; `ArgCount.rvM_crude`; `LadderMean`
    OUT         the case where the real parts approach a line without
                reaching it

### 2026-11-23 · joint 10, the finite case on the count: `Stage3/FiniteOffLinePi.lean`, block J10e of `joints.md`

    DONE        `finite_off_line_pi`: a finite set holds every zero off the
                line, and the prime count at the doublings is within
                `C·r²·√2^r` of `Li`; then RH. With it `norm_ipart_le`,
                `norm_piMode_le`, `norm_piMode_half` (the size of one zero's
                part of the count) and `row_bound`; one unit
    ASSUMED     Julian, 2026-11-23: "work on the open inside these". Written
                by an Opus worker from a brief with the statement and the
                route; read for shortcuts and built here
    DEPENDS     `PiZeros.pi_eq_zero_sum`, `PiRemainder.norm_tr_efRem_le_of`,
                `zinv_le_log`, `LadderFading.line_not_fading`
    OUT         infinitely many zeros off the line; the cells at depth
    OUTCOME     proved, unit 0445; clean on the worker's first build

### 2026-11-23 · the open bound of joint T2: `Stage3/PiRemainder.lean`, block T2b of `joints.md`

    DONE        `norm_tr_efRem_le`: constants `A`, `x₀` with
                `‖tr (efRem x) x‖ ≤ A·√x·log²x` for `x ≥ x₀`, the height
                equal to `x`, no hypothesis on the zeros.
                `norm_tr_efRem_le_of` with `A = Arem`, `x₀ = 256`.
                `zinv_le_log`: the zeros below a height, all of them,
                weighted by order over size, add to at most a constant times
                the square of the logarithm; one unit
    ASSUMED     Julian, 2026-11-23: "work on the open inside these". Written
                by an Opus worker from a brief, as he asked for the limits;
                the file was read for shortcuts and built here
    DEPENDS     `Glue.explicit_formula_split_num`, `PiZeros`,
                `FiniteOffLine.dyadic_count_le`
    OUT         a general height; the finite off-line theorem on the cells
                of the count
    OUTCOME     proved, unit 0444

### 2026-11-22 · a description on every theorem that had none

    DONE        a docstring above each of the 325 theorems the map listed
                with no description, in the three Lean trees; the three
                ported copies in `Stage3/TablePort` given the same lines
    ASSUMED     Julian, 2026-11-22: "go for all of it". The second of the
                items. Written by four workers from the statements; each
                says what its theorem states and no more
    DEPENDS     the three trees build; `check_port.py`, `check_weld.py`,
                `theorem_index.py`, `lean_map.py --check`
    OUT         any change to a statement or a proof
    OUTCOME     463 lines added, no existing line changed; three trees
                build; the index reads 0 theorems with no docstring claim

### 2026-11-22 · joints T2 and T3: `Stage3/PiZeros.lean` (block T2) and `Stage3/CellRows.lean` (block T3a)

    DONE        T2. `pi_eq_zero_sum`: for `x ≥ 2` and any height, the count
                minus Li is minus the sum over the zeros below the height of
                each zero's part `piMode`, plus the passage of the explicit
                formula's remainder, minus the passage of `ψ − θ`; an
                identity. `table_cell_eq_zero_sum`: the same for the table's
                cell. `norm_tr_psiTheta_le`: the `ψ − θ` part is `≤ 8√x`.
                T3a. `cell_eq_zero_sum_rows`, `cell_tail_tendsto`: with the
                height `2^(r−d)` at row `r` the cell and its zero sum differ
                by `≤ A_d·r²`, which over `√2^r` tends to zero; two units
    ASSUMED     Julian, 2026-11-22: "go for all of it". The fourth of four.
                T2 is given as an identity with its remainders named. T3 is
                given along the rows; at a fixed row the height is capped at
                the square of the row's doubling by `cell_eq_zero_sum`
    DEPENDS     `Stage3.pi_sub_Li_eq`, `CellResidual.table_cell_eq`,
                `FiniteOffLine.err_le`, `cell_zero_sum_finset`
    OUT         a bound on the passage of the explicit formula's remainder;
                the explicit formula above the square of `x`
    OUTCOME     proved, units 0441 and 0442

### 2026-11-22 · joint T1 on the table tree's operator: `Stage3/CellBdiff.lean`, block T1b of `joints.md`

    DONE        `stencil_eq_bdiff_iter`: `CellZeros.stencil d` on a row is
                `Chain.bdiff` iterated `d` times on any function of `ℂ` that
                agrees with the row on the integers. `cell_eq_modeSum_bdiff`:
                the cell theorem with `bdiff^[d]`, `Sym`, `mode`, `modeSum`,
                all four the table tree's; one unit
    ASSUMED     Julian, 2026-11-22: "go for all of it". The third of four:
                the NOTEPAD line of the same day says `CellZeros` repeats the
                table tree's operator. `CellZeros` is sealed and stays; the
                equality is proved beside it
    DEPENDS     `CellModes.cell_eq_modeSum`, `Chain.bdiff`,
                Mathlib `fwdDiff_iter_eq_sum_shift`
    OUT         retiring `CellZeros.stencil` from the modules after it
    OUTCOME     proved, unit 0440; clean on the first build

### 2026-11-22 · joint 10, the finite case assembled: `Stage3/FiniteOffLine.lean`, block J10d of `joints.md`

    DONE        `finite_off_line`: a finite set holds every zero off the
                line, and at one depth the cells of the log-weighted count on
                the one ladder are within `C·r²·√2^r` of their main term;
                then RH. With it `sum_order_onLineInv_le`, `dyadic_count_le`
                (the zeros on the line, weighted by `1/|ρ|`, below a height),
                `err_le`, `norm_term_le`; one unit
    ASSUMED     Julian, 2026-11-22: "go for all of it". The first of four:
                the finite-off-line conditional theorem. Stated on the cells
                of `ψ`, as `CellZeros.cell_eq_zero_sum` is; the passage to the
                cells of `π` is joint T2
    DEPENDS     `CellZeros.cell_eq_zero_sum`, `LadderFading.line_not_fading`,
                `ArgCount.rvM_crude`, `Stage3.dyadic_abs_N_sum_le`,
                `LandauWindow.rh_of_zeroFree_half`
    OUT         infinitely many zeros off the line (unit 0431)
    OUTCOME     proved, unit 0439

### 2026-11-22 · the deep zero, inverted, and the band: `lean/DeepZeroBand.lean`

    DONE        `share`: a cell over its total. `share_add`, `share_mirror`:
                the prime share and the composite share add to one, so the
                composite table is `x ↦ 1 − x` on shares. `deep_zero_share`,
                `deep_zero_inverse_share`: at (20,6) they are 0 and 1.
                `deep_zero_on_outer_circle`,
                `deep_zero_inverse_on_inner_circle`: under `z = b^(−x)` those
                are the two edges of `Transform`'s band. `share_pair_product`,
                `share_on_middle_circle_iff`, `share_in_band`,
                `band_in_annulus`; one unit
    ASSUMED     Julian, 2026-11-22: "Build the join". The band is read as
                `Transform`'s annulus between the outer and inner circles;
                the inverse of the deep zero as the composite cell, his
                "the inverse of this table is the dyadic composite table"
    DEPENDS     `Zeros.zero_20_6`, `PairIdentity.pair_identity`,
                `Transform.zmap_pair_product`, `on_critical_line_iff_norm`
    OUT         any identification of a cell's share with the real part of a
                zero of zeta
    OUTCOME     proved, unit 0438; clean on the first build

### 2026-11-22 · the mirror pair as a rectangle of fixed area: `Stage3/MirrorArea.lean`, block S1 of `joints.md`

    DONE        `mirror_area`: a mode at base `b` and its mirror multiply to
                `b`. `mirror_side`: one side gives the other. `square_iff`:
                both sides are `√b` exactly on the line.
                `long_side_of_off_line`: off the line one side is above `√b`.
                `restoringForce_eq_log_ratio`: block T4's force is the
                logarithm of the ratio of the sides; one unit
    ASSUMED     Julian, 2026-11-22: "Yes but look at the lean theroems I feel
                we chased a rectangle before. If not, let build". A first search
                missed it: `lean/Transform.lean` has the rectangle as a pair
                (`zmap_pair_product`, `pair_collapses_iff_critical`). This
                module restates it in Stage 3 and joins it to T4's force. Sides are `‖b^ρ‖` and `‖b^(1−ρ)‖`
    DEPENDS     `StencilWeil.restoringForce`; Mathlib
    OUT         any statement that forces equal sides
    OUTCOME     proved, unit 0437; clean on the first build

### 2026-11-22 · log the two exploratory measurements as run units

    DONE        two run units, each with its script in `run/`, run through
                `lab run`: the residual of the prime count against the
                logarithmic integral at each doubling; the depth-6 cells as
                smooth cell plus wobble
    ASSUMED     Julian, 2026-11-22: "Yes log them". Both EXPLORATORY: no
                prereg, no verdict. `pi2n_cache.json` is the count
    DEPENDS     `pi2n_cache.json`, `mpmath`
    OUT         any reading of the numbers as a verdict; any new measurement
    OUTCOME     units 0435 and 0436 written and checked

### 2026-11-22 · why the number line has zeros: `Stage3/WobbleCount.lean`, block W1 of `joints.md`

    DONE        `count_identity`: the logarithms of the integers up to `N`
                add to the prime content read at `N`, `N/2`, `N/3`, …
                (`Σ log n = Σ_d Σ_{m ≤ N/d} Λ m`). `wobbleSum ρ N`: a wobble
                `x^ρ` read at `N/1, …, N/N` and added. `wobbleSum_expansion`:
                it is `ζ(ρ)·N^ρ + N/(1−ρ) + 1/2` up to a bounded term.
                `invisible_iff`: after the smooth term `N/(1−ρ)` the sum
                stays bounded in `N` exactly when `ζ(ρ) = 0`; one unit
    ASSUMED     Julian, 2026-11-22: "build 'a wobble is invisible to the
                integer count exactly when it sits at a zero'". "Invisible" is
                made exact as: bounded after the smooth term. Stated for
                `0 < Re ρ`, `ρ ≠ 1`, at integer `N`
    DEPENDS     `ZetaGrowth.zeta1_eq_zeta`, `tail_norm_le`; upstream
                `ArithmeticFunction.vonMangoldt_mul_zeta`,
                `sum_Ioc_mul_eq_sum_sum`
    OUT         the size of the wobbles; nothing here bounds a real part
    OUTCOME     done as pinned; unit 0434, clean on its second build

### 2026-11-22 · joint T4, the stencil in Weil's form and the restoring force: `Stage3/StencilWeil.lean`, block T4 of `joints.md`

    DONE        `stencilTest d φ`: the table's depth-`d` stencil applied to a
                test function along the doublings; it is again a test
                function; its transform is the symbol to the depth times
                `φ`'s; so each zero enters Weil's form with weight the symbol
                at the zero times the symbol at its mirror, to the depth; on
                the line that weight is a square; `restoringForce b ρ`, the
                difference of the logarithms of a mode's size and its
                mirror's, equals `2·|Re ρ − 1/2|·log b`, is zero exactly on
                the line, and grows with `b`; with the bridge, the form on
                the stencil equals its prime side; one unit
    ASSUMED     Julian, 2026-11-22: "Yes", to building T4 as the restoring
                force read off the table. The force is the mirror imbalance of
                the mode, the quantity common to the handshake and the
                restoring force of `lean_primebeat`'s closed-loop file, read
                the same day. That it restores, in the sense that an off-line
                zero is impossible, is not claimed and is not in this piece
    DEPENDS     `WeilDetect`, `WeilBridgeLeaf`; `papers/Connes-Measured.md` § E
                (the stencil as a test function, measured, O37)
    OUT         positivity of the form without RH; `StmtDetect`
    OUTCOME     done as pinned; unit 0433, clean on its second build

### 2026-11-22 · joint 10 on one ladder, the general case: a decision unit, and `Stage3/LadderMean.lean`, block J10c of `joints.md`

    DONE        a decision unit recording where the general case stops: the
                reduction (zero density, then an absolutely summable sum of
                modes), the obstruction (summable sums of modes can vanish at
                every row when the modes accumulate; Wolff, Denjoy), the
                sub-case that closes (largest real part attained) and the one
                with no argument (not attained). `LadderMean`: an absolutely
                summable sum of rotations that tends to zero has every folded
                class summing to zero (`mean_extract`, by averaging along the
                rows); so infinitely many zeros on one vertical line, with
                `Σ m/|ρ|` finite, cannot fade from the cells
                (`line_not_fading_summable`); one Lean unit
    ASSUMED     Julian, 2026-11-22: "The harder general case". The general
                case is not closed by this; the decision unit says where and
                why. Summability of `Σ m/|ρ|` over the zeros off the line is a
                hypothesis of the theorem; it follows from a zero-density
                estimate that is not in the tree
    DEPENDS     units 0429, 0430
    OUT         the zero-density estimate; the sub-case with no largest real
                part; the converse itself
    OUTCOME     done as pinned; units 0431 (decision) and 0432 (`LadderMean`,
                clean on its first build)

### 2026-11-22 · joint 10 on one ladder, second piece: `Stage3/LadderFading.lean`, block J10b of `joints.md`

    DONE        `not_tendsto_powerSum`: finitely many distinct modes of one
                size, with a weight that is not zero on one of them, do not
                fade: `Σ c_z·z^r / R^r` does not tend to zero along the rows.
                `line_not_fading`: a nonempty finite set of zeros of ζ on one
                vertical line contributes to the cell `(r, d)` a sum that is
                not `o(2^(rβ))`; one unit
    ASSUMED     Julian, 2026-11-22: "go on to the open step of joint 10". The
                finite case is this piece. The sum over all the zeros is not
                absolutely convergent and the largest real part need not be
                attained; that case is named OPEN in the block and is not in
                this piece. A literature search the same day found no
                statement of the one-ladder converse
    DEPENDS     unit 0429 (`AliasClass`)
    OUT         infinitely many zeros off the line; the converse itself
    OUTCOME     done as pinned; unit 0430, clean on its second build. The
                infinite case is worked on paper in the block: it reduces,
                given a zero-density estimate, to the case where the largest
                real part is attained; the other sub-case has no argument

### 2026-11-22 · joint 10 on one ladder, first piece: `Stage3/AliasClass.lean`, block J10a of `joints.md`

    DONE        `AliasClass`: the reciprocal of a nontrivial zero has positive
                real part; a nonempty finite set of zeros has
                `Σ m(ρ)/ρ ≠ 0`; zeros with the same `2^ρ` have the same
                symbol and the same mode on the ladder; so a nonempty finite
                set of zeros sharing `2^ρ = z` contributes to the cell
                `(Σ m/ρ)·(1 − z⁻¹)^d·z^r`, which is not zero; one unit
    ASSUMED     Julian, 2026-11-22: "Go", after the question whether the table
                continuing is every ladder or the one ladder, read as: work on
                joint 10. The step from "every zero present with nonzero
                weight" to "the cells cannot all stay small" is not in this
                piece and is named in the block as open
    DEPENDS     unit 0426 (`CellModes.sym_two`, `mode_two_int`)
    OUT         the power-sum step; the converse itself
    OUTCOME     done as pinned; unit 0429, clean on its first build

### 2026-11-22 · RH as the size of the cells: `Stage3/PiToPsi.lean`, `Stage3/CellResidual.lean`, block T5 of `joints.md`

    DONE        `PiToPsi`: the bound on `π − Li` at square-root size gives the
                bound on `ψ`, hence `RiemannHypothesis`; with the route of
                today, `RH ↔ ∃ C x₀, StmtSchoenfeldWeak C 1 x₀ π Li`.
                `CellResidual`: for the dyadic ladder started at `a`, the
                cell's residual is the stencil of `π − Li` on the ladder;
                `CellsSqrt C r₀` says every cell of every ladder with
                `1 ≤ a ≤ 2` has residual at most `C` times
                `(1 + 2^(−1/2))^(d+1)·(r+1)·2^(r/2)`; the theorem
                `RiemannHypothesis ↔ ∃ C r₀, CellsSqrt C r₀`; and for the
                table itself (`a = 1`, `Construction.tableFrom rowN`) the
                forward direction; two units
    ASSUMED     Julian, 2026-11-22: "This please", on the sentence "RH holds
                if and only if the residual in every cell stays at square-root
                size as the table continues". The equivalence is stated over
                every ladder `a·2^r`, `1 ≤ a ≤ 2`: on the single ladder
                `a = 1` the converse is joint 10 and stays open, and the
                module says so in its header
    DEPENDS     units 0409, 0413 (`hasDerivAt_Li`), `VonKoch.RH_iff_psiWeak`,
                upstream `Chebyshev.theta_eq_primeCounting_mul_log_sub_integral`
    OUT         joint 10 (one ladder), T2, T3, T4; no constant is made small
    OUTCOME     done as pinned; units 0427 (`PiToPsi`, clean on its third
                build) and 0428 (`CellResidual`, clean on its second)

### 2026-11-22 · the Lean map: `map/` (index `map/README.md`), `utilities/lean_map.py`

    DONE        a generated map of every declaration in every Lean file of
                the three trees: per file a Mermaid diagram and a table with,
                for each theorem, what it proves, what it needs, why (its own
                docstring), what it uses and what uses it; a diagram of the
                files per tree; the lists of ends, of theorems that connect
                to nothing, of `sorry`; a workflow that regenerates it on
                every push that changes a `.lean` file
    ASSUMED     Julian, 2026-11-22: every theorem in every file, visual, the
                same for both readers every time, updating itself. "Uses" is
                read from names in the source; the generator's docstring
                states what that cannot see
    DEPENDS     nothing
    OUT         no Lean changed; `CLAUDE.md` not edited (it is Julian's)
    OUTCOME     done as pinned; every diagram parses in Mermaid

### 2026-11-22 · `Stage3/CellZeros.lean`, block T1 of `joints.md`

    DONE        `stencil`, `stencil_mode`, `stencil_zeroPartialSum`,
                `cell_eq_zero_sum`: the `d`-fold difference of `ψ(2^n)` at
                `r` is `2^r·(1 − 1/2)^d` minus the sum over the zeros below
                `T` of `m·(2^ρ)^r·(1 − 2^(−ρ))^d/ρ`, within the explicit
                formula's error summed over the window; no RH; a unit; then
                the join with `lean/Superposition` (Julian: "and then start
                on this")
    ASSUMED     the stencil is written on rows `ℤ → ℂ` with powers of two as
                integer powers; `Chain.Sym` and `Chain.mode` come with the
                port in the second step
    DEPENDS     unit 0419
    OUT         T2, T3, T4, joint 10
    OUTCOME     done as pinned; units 0425 (`CellZeros`) and 0426
                (`Stage3/CellModes.lean`, with `Chain`, `Superposition`,
                `EulerFactorChain` ported); each clean on its second build

### 2026-11-22 · `SECTIONS.md` "One object", and block T1 of `joints.md` as a draft

    DONE        `SECTIONS.md` reorganised under Julian's statement that the
                table and everything downstream are one object; four joints
                named T1 to T4 beside joint 10; block T1 written as a DRAFT
    ASSUMED     the statement of T1 is from the definitions read today; no
                Lean was run for it
    DEPENDS     units 0401, 0419
    OUT         no Lean, no unit; the build waits for Julian
    OUTCOME     done as pinned

### 2026-11-22 · `Stage3/TableDepths.lean` (block E11 of `joints.md`), and a drift checker for `TablePort`

    DONE        `cell_ne_zero_gen`: the gate on the route at any depth, from a
                numeric check at one row; instances at depths one to eight
                with rows 74, 75, 76, 77, 78, 80, 85, 91;
                `utilities/check_port.py`, which diffs each `TablePort`
                module against its original and fails on any difference not
                in `utilities/port_baseline/`; a unit
    ASSUMED     Julian's "Do both". Depth nine and beyond first hold past
                row 92, outside the computed table, and are left out
    DEPENDS     unit 0423
    OUT         a different floor per depth; `lean/` untouched
    OUTCOME     done as pinned; unit 0424; clean on the first build

### 2026-11-22 · the join between the two trees: a checker, and the gate chain on one toolchain (`Stage3/TableRoute.lean`, block E10 of `joints.md`)

    DONE        `utilities/check_weld.py` compares `gate_hyp_of_RH`'s
                conclusion with `cell_ne_zero_of_route`'s hypothesis; the ten
                modules of the table tree the gate depends on copied into
                `lean_stage3/Stage3/TablePort/` and built on v4.32.2; one
                Stage 3 theorem composing the route with the gate, checked by
                the kernel; units; a NOTEPAD line; `SECTIONS.md`
    ASSUMED     Julian, 2026-11-22: the caveats on the join are problems to
                fix, and are fixed here. The copies are character copies with
                only their `import` lines changed; any line a newer Mathlib
                forces to change is listed in the unit
    DEPENDS     units 0421, 0422
    OUT         `lean/` itself: untouched, its pins as they are
    OUTCOME     done as pinned; unit 0423. Eight modules copied unchanged,
                two with proof steps rewritten; `cell_ne_zero_of_RH` clean
                on its first build

### 2026-11-22 · block E9 built: `Stage3/GateEval.lean` and `lean/RouteCell.lean`

    DONE        Stage 3: `routeConst_le` (`routeConst (2^36) ≤ 414`),
                `gate_ineq` (the gate's gap for real `r ≥ 80` at depth six),
                `gate_hyp_of_RH`; table tree: `cell_ne_zero_of_route`; two
                units; block E9 PROVED
    ASSUMED     Julian's "E9" is the go-ahead for the draft as written
    DEPENDS     units 0412, 0419
    OUT         other depths; any unconditional statement; a weld for the
                hypothesis of `cell_ne_zero_of_route` (it is a statement
                inside a theorem, and the weld checker compares definitions)
    OUTCOME     done as pinned; units 0421 and 0422; each half clean on
                its first build

### 2026-11-22 · block E9 of `joints.md`: the Lean gate, read and drafted

    DONE        the gate's hypotheses read against the route's theorem; a
                floor and a depth chosen; block E9 written as a DRAFT; a
                NOTEPAD line
    ASSUMED     the arithmetic is from a throwaway script, not a logged run
    DEPENDS     units 0412, 0419
    OUT         no Lean, no unit; the build waits for Julian
    OUTCOME     done as pinned; at floor `2^36` the gate's inequality holds
                at depth six from row 80, and fails at row 79

### 2026-11-22 · the gate priced from the proved ceilings (unit 0420)

    DONE        one script: O68's `R_of` on `routeConst` with `c1n`, `c3n`,
                `c4n` at the ceilings of `RouteNum`; a NOTEPAD line
    ASSUMED     EXPLORATORY, no prereg; the gate is the script's
    DEPENDS     unit 0419
    OUT         no Lean
    OUTCOME     done as pinned; depth 6 closes at rung 76

### 2026-11-22 · `Stage3/EdgeNum.lean`, block E8a of `joints.md`

    DONE        the three edge theorems of `EdgeBound.lean` with their
                constants as definitions in place of "there exists":
                `gz_partial_fraction_num` (`C1n`), `ball_order_sum_le_num`
                (`C2n`), `edge_bound_core_num` (`Cen = C1n + C2n + 1/log 2`);
                a unit
    ASSUMED     Julian's "Go on that" is the restatement proposed after unit
                0418. Each proof is the original with its existence step
                replaced (`LOOP.md` § 3); the definitions are closed
                expressions, bounded by numerals in a later block
    DEPENDS     units 0416, 0417
    OUT         `Glue`'s theorems (block E8b); `EdgeBound.lean` untouched
    OUTCOME     done, and E8b and E8c with it in the same sitting:
                `GlueNum.lean`, `RouteNum.lean`; unit 0419 covers the three

### 2026-11-22 · `Stage3/LowEdge.lean`, block E7d of `joints.md`

    DONE        `gz_partial_fraction_low` (the partial fraction at heights
                in `[0, 2]`, with a numeral), `low_ball_count_wide` (at most
                250 zeros of `gz` within `46/25` of the centre there),
                `logDerivZeta_low_edge`, `logDerivZeta_short_segment`
                (`‖ζ′/ζ‖ ≤ 1620000` on `Re = −1/4`, `|t| ≤ 2`: `Mc`); a unit;
                E7d PROVED
    ASSUMED     the radii are the ones `gz_partial_fraction` uses, so the
                numeral is of the size of the existing edge constant
    DEPENDS     units 0416, 0417; upstream `FinalBound`, `ZerosBound`
    OUT         the explicit formula's constants as definitions; nothing
                wired into `Glue.edge_left_bound`
    OUTCOME     done as pinned; unit 0418; clean on the first build

### 2026-11-22 · `Stage3/LowCount.lean`, block E7c of `joints.md`

    DONE        `gz_c0_lower` (`1/14 ≤ ‖gz (c0 T′)‖` at every height),
                `low_ball_count` (at most 119 zeros of `gz`, with
                multiplicity, within `8/5` of `3/2 + iT′` for `0 ≤ T′ ≤ 6`),
                `low_rect_count` (`M0 ≤ 714`); a unit; E7c PROVED
    ASSUMED     the block's seven discs about `3/2 + ih` at radius `0.79`
                became six about `3/2 + i(j + 1/2)` at radius `4/5`: the
                same argument, one disc fewer, no reflection
    DEPENDS     unit 0416; upstream `ZerosBound`, `ZetaFixedLowerBound`
    OUT         E7d; nothing wired into `ball_order_sum_le`
    OUTCOME     done as pinned; unit 0417; clean on the first build

### 2026-11-22 · `Stage3/BoxBounds.lean`, blocks E7a and E7b of `joints.md`

    DONE        `sq_zeta_box` (`‖(s−1)²ζ s‖ ≤ 135` on the box),
                `sq_zeta_band_explicit` (the band bound with the numeral
                135 and no compactness), `norm_zeta_three_halves_le`,
                `one_le_norm_zeta_three`, `zeta_ratio_ge` (`2/7 ≤ ‖ζ 3/ζ(3/2)‖`);
                a unit; the two sub-blocks PROVED
    ASSUMED     Julian's "E7" read as: build block E7, short pieces first
    DEPENDS     `ZetaGrowth.zeta1_eq_zeta_strip`, `tail_norm_le`,
                `zeta_growth_strip`; upstream `Zeta0EqZeta`, `ZetaBnd_aux1b`
    OUT         E7c (`M0`), E7d (`Mc`); nothing wired into `EdgeBound`
    OUTCOME     done as pinned; unit 0416; clean on the second build

### 2026-11-22 · `Stage3/RouteGate.lean`, block E6 of `joints.md`

    DONE        `relErrWindow_route`: unit 0411's theorem with `W` put to
                zero (unit 0414) and the main term written as the formula the
                table tree's interpolant has (unit 0413); a unit; the block
                PROVED; then a DRAFT block E7 for the three box bounds
    ASSUMED     Julian's "Ok" read as: the recommendation just made, the
                substitution now and the box bounds as a draft to read.
                `K0` is not substituted: it sits inside an existential and
                exposing it needs another copy of the explicit formula's
                proof, for a term of size 1e-5 in unit 0410
    DEPENDS     units 0411, 0413, 0414
    OUT         no Lean for the box bounds
    OUTCOME     `relErrWindow_route` done, unit 0415, clean on the first
                build; block E7 written as a DRAFT, nothing built; a sixth
                unnamed quantity found on the read, `‖ζ 3 / ζ (3/2)‖`

### 2026-11-22 · `Stage3/RealSegment.lean`, block E5 of `joints.md`

    DONE        ζ has no zero on the real segment `(0, 1)`; the bucket `W` of
                real nontrivial zeros is empty and
                `weightedZeroHeightBucket = 0`; a unit; the block PROVED
    ASSUMED     Julian's "keep going on the stretch" read as: the next of
                the four unnamed quantities, cheapest first
    DEPENDS     upstream `Zeta0EqZeta`, `ZetaBnd_aux1b`; Mathlib
                `riemannZeta_one_sub`
    OUT         `M0`, `Mc`, the compact patch; nothing wired into the
                route's theorems
    OUTCOME     done as pinned; unit 0414; clean on the second build

### 2026-11-22 · `Stage3/RowLeaves.lean`, block E4 of `joints.md`

    DONE        `Li_two_rpow`: Stage 3's `Li` at `2^x` is
                `2/log 2 + ∫₁ˣ e^(log 2·t)/t dt` for `x > 0`, the formula
                `lean/Interpolant.liRow_eq` has from one half on;
                `norm_logDerivZeta_zero`: `‖ζ′(0)/ζ(0)‖ = log 2π`; a unit;
                the block PROVED
    ASSUMED     the two statements meet the other tree by text; no weld is
                added for a formula inside a theorem
    DEPENDS     unit 0412; Mathlib `deriv_riemannZeta_zero`, `riemannZeta_zero`
    OUT         `W`, `M0`, `Mc`, the compact patch; nothing wired into
                `Glue.lean` or `GlueFloor.lean`
    OUTCOME     done as pinned; unit 0413; clean on the third build

### 2026-11-22 · `lean/Interpolant.lean`, block C1 of `joints.md`

    DONE        `liRow`, a function smooth on the whole line with derivative
                `2^x/x` beyond one half, equal to `2/log 2 + ∫₁ˣ 2^t/t dt`
                from one half on; the gate theorems of `RelativeLi` with the
                interpolant discharged; a unit; the block PROVED
    ASSUMED     Julian's message naming the two open items read as: take
                them up. That `liRow m` equals Stage 3's `Li (2^m)` is not
                proved here (other tree, other definition of `Li`)
    DEPENDS     unit 0403 (`lean/RelativeLi.lean`)
    OUT         the route's constants as numerals: read and reported, not
                built; nothing in `lean_stage3/`
    OUTCOME     done as pinned; unit 0412; clean on the second build

### 2026-11-22 · `Stage3/JointFloorGate.lean`, block E3 of `joints.md`

    DONE        `weakWindow_relErr` (a weak window is the gate's relative
                error with an explicit `ρ`), `relErrWindow_floor_of_RH` (the
                route of unit 0409 carried to `StmtRelErrWindow` on the rows
                of `π` and `Li`); a unit; the block PROVED
    ASSUMED     Julian's "Go" after unit 0410 read as: continue on this
                route; the joint to the gate was the next item listed
    DEPENDS     units 0402 (`JointDialGate.StmtRelErrWindow`, welded), 0409
    OUT         nothing in `lean/`; the gate's own theorem is on the other
                toolchain and is reached by statement text, as joint 5
    OUTCOME     done as pinned; unit 0411; clean on the first build

### 2026-11-22 · the gate priced from `floorConstSplit` (unit 0410)

    DONE        one script: O68's `R_of` on the constant of
                `schoenfeldWeak_floor_split_of_RH`, four cases and a slack
                factor; a NOTEPAD line; a line in `SECTIONS.md`
    ASSUMED     EXPLORATORY, no prereg; floors; one case uses a guessed size
                for a supremum, labelled in the script
    DEPENDS     unit 0409
    OUT         no Lean
    OUTCOME     done as pinned; depth 6 closes at rung 76 as built

### 2026-11-22 · `Stage3/GlueFloor.lean`, block E2 of `joints.md`

    DONE        `edge_left_sharp`, `explicit_formula_split`,
                `StmtExplicitFormulaSplit`, `stmtEF_split`,
                `psiWeak_floor_split`, `schoenfeldWeak_floor_split_of_RH`;
                a unit; the block PROVED
    ASSUMED     three of the proofs are copies with the closing lines
                changed; the constants stay existential
    DEPENDS     units 0407, 0408; `Glue.edge_left_bound`,
                `Glue.explicit_formula_poly`
    OUT         `Glue.lean`, `Assembly.lean`, `AssemblyFloor.lean` untouched;
                no pricing in this unit; no numeral
    OUTCOME     done as pinned; unit 0409; clean on the second build

### 2026-11-22 · block E2 of `joints.md`: the left edge, read and drafted

    DONE        `Glue.edge_left_bound` and its use in `explicit_formula_poly`
                read in full; block E2 written as a DRAFT; a NOTEPAD line
    ASSUMED     the rung figures in the block are an unlogged estimate
    DEPENDS     units 0407, 0408
    OUT         no Lean, no unit; the build waits for Julian
    OUTCOME     done as pinned; the left edge is `72·D·log²x·x^(−1/4)` inside
                the proof and `C·log x` in the statement

### 2026-11-22 · the gate priced from `floorConst` (unit 0408)

    DONE        one script: O68's `R_of` on the constant of
                `schoenfeldWeak_floor_of_RH`, with the two explicit-formula
                constants at unit 0405's floors and at zero; a NOTEPAD line
    ASSUMED     EXPLORATORY, no prereg; floors, as in units 0405 and 0406
    DEPENDS     unit 0407
    OUT         no Lean
    OUTCOME     done as pinned; rungs as in unit 0406; 19 rungs of room with
                the contour constants at zero

### 2026-11-22 · `Stage3/AssemblyFloor.lean`, block E1 of `joints.md`

    DONE        `psiWeak_floor`: the assembly of `psiWeak_of_RH_EF_NT` with
                the floor `x₀` a parameter, `T` the power of two just below
                `x²`, and the closing arithmetic keeping each term's shape;
                `schoenfeldWeak_floor_of_RH` composing it with
                `Glue.stmtEF_poly`, `ArgCount.rvM_crude` and
                `PsiToPi.schoenfeldWeak_of_psiWeak`; a unit; the block PROVED
    ASSUMED     the constants `c₁`, `c₂` stay existential in the composed
                theorem (they are in `stmtEF_poly`); no numeral is claimed
    DEPENDS     units 0405, 0406; `Assembly.norm_zeroPartialSum_le_logsq`
    OUT         `Assembly.lean` untouched; the radii; the three compactness
                constants; any statement about the gate or the table
    OUTCOME     done as pinned; unit 0407; clean on the second build

### 2026-11-22 · the explicit-formula route priced over the height T (unit 0406)

    DONE        a unit with one script: the constant as a function of the
                floor and of `T = x^a`, from the two proved bounds before
                their closing arithmetic; O68's `R_of` on the result; a
                NOTEPAD line; a line in `SECTIONS.md`
    ASSUMED     EXPLORATORY, no prereg; floors as in unit 0405; the model's
                monotonicity in `x` argued in the docstring, checked by no
                theorem
    DEPENDS     unit 0405
    OUT         no Lean in this unit; the restatement is the next one
    OUTCOME     done as pinned; at `a = 2` depth 6 is covered with 3 rungs
                to spare as built and 9 with the radii freed, as floors

### 2026-11-22 · the explicit-formula route: the radii, and a lost √x (unit 0405)

    DONE        a unit with one script: the Borel–Carathéodory factor with
                the three free radii optimised; the bound inside
                `Assembly.psiWeak_of_RH_EF_NT` before `assembly_arith`
                priced with its `√x` kept, as built and with the radii
                freed; a NOTEPAD line; a line in `SECTIONS.md`
    ASSUMED     EXPLORATORY, no prereg; floors only, with four unnamed
                quantities at zero and one value of ζ from mpmath
    DEPENDS     unit 0404; O68_weak_bound_tolerance.py unchanged
    OUT         no Lean. The restated assembly, the choice of `T`, and the
                freed radii are a decision, written as one and left
    OUTCOME     done as pinned; radii alone gain a factor 15; with the √x
                kept the freed case lands on the ceiling rung, as a floor

### 2026-11-22 · the explicit-formula route, priced (unit 0404)

    DONE        a unit holding one script and its JSON: O68's `R_of` imported
                and run on the `√x·log x` shape that
                `Assembly.psiWeak_of_RH_EF_NT` reaches through
                `PsiToPi.schoenfeldWeak_of_psiWeak`; the ceiling for depth 6;
                lower bounds for `Ch`, `Cs` read off `Stage3/EdgeBound.lean`
                and `Stage3/Glue.lean`; `SECTIONS.md` "The constants"
                corrected; a NOTEPAD line
    ASSUMED     EXPLORATORY, no prereg. The lower bounds drop every term the
                files prove non-negative and use `A > 5`; they bound the
                constant the Lean proof produces, they say nothing about the
                best constant
    DEPENDS     O68_weak_bound_tolerance.py unchanged; unit 0365 (`rvM_crude`);
                entry 271 (`stmtEF_poly`)
    OUT         no Lean, no change to any proof, no verdict
    OUTCOME     done as pinned; the route's fixed numerals fit under the
                ceiling, its contour constant does not

### 2026-11-22 · the dial's constants: a correction, and nothing built

    DONE        `SECTIONS.md` "The constants", `joints.md` block 6 and unit
                0403 corrected: a concrete bump has been in the tree since
                NOTEPAD entry 283 (`Stage3/ExplicitBump.lean`), and that
                entry already carries its numeral through to a constant far
                above the gate's ceiling; a NOTEPAD line
    ASSUMED     the figures are quoted from NOTEPAD entries 283 and 233 as
                read; the notebook entries behind them were not opened
    DEPENDS     unit 0403
    OUT         no Lean. A new module written this session under the name
                `Stage3/ExplicitBump.lean` overwrote the existing one before
                a commit; it was restored from git and the new one discarded
    OUTCOME     done as pinned

### 2026-11-22 · joint 6 and the constants: `lean/RelativeLi.lean`, and a trace

    DONE        the v4.28.0 toolchain fetched and `lean/` built in this
                session; `lean/RelativeLi.lean`, the shape-free gate with its
                main-term floor discharged, three theorems, no `sorry`,
                registered in `lean/lakefile.toml`, `lean/THEOREMS.md`
                regenerated; the trace of the dial's constants to the six
                existential quantities and the bump; a unit; `joints.md`
                block 6 and `SECTIONS.md` updated
    ASSUMED     the unit is a formalization unit outside the Stage-3 loop
                (no `loop_version`), the module being in `lean/`
    DEPENDS     `lean/RelativeGate.lean`, `Expansion.lean`, `MainTerm.lean`
    OUT         the interpolant constructed; the constants made explicit;
                README's module and theorem counts for `lean/`, which were
                already behind the index
    OUTCOME     done as pinned, unit 0403; clean first build

### 2026-11-22 · joints 3, 4, 5 of `SECTIONS.md`: `Stage3/JointDialGate.lean`

    DONE        `lean_stage3/design/joints.md` block 3;
                `Stage3/JointDialGate.lean` builds with no `sorry`:
                `StmtRelErrWindow` (a copy of the table tree's, added to
                `utilities/check_weld.py`), `thetaWindow_of_global`,
                `log_absorbed`, `powerSaving_relErr`, `relErrWindow_of_theta`,
                `relErrWindow_of_window`: a window bound on `G` at `θ` gives
                the gate's relative-error statement on the table's rows; a
                formalization unit; `SECTIONS.md` joints 3, 4, 5 marked
    ASSUMED     the exponent moves from `θ` to any `θ' > θ` to absorb the
                logarithm; named in the block
    DEPENDS     units 0389, 0400; `lean/RelativeGate.lean` for the text of
                the definition and of `powerSaving_relErr`
    OUT         joint 6 and the gate's side conditions; the constants; the
                converse; the window bound itself
    OUTCOME     done as pinned, unit 0402: five theorems, no `sorry`, clean
                on the first build; the weld gate holds ten welds, none broken

### 2026-11-22 · joint 9a of `SECTIONS.md`: `Stage3/JointSymbol.lean`

    DONE        `lean_stage3/design/joints.md` block 9a;
                `Stage3/JointSymbol.lean` builds with no `sorry`: `dd`, `cutG`,
                `mellin_shift`, `mellin_dd_iter` (the transform of the
                depth-`d` difference of `G` along the doublings is the
                symbol to the power `d` times `Phi`), `dd_iter_rule` (the
                table's rule), `symPhi_principal_part` (at each zero the
                principal part is reweighted by the symbol to the power
                `d`); a formalization unit; block 9a marked PROVED
    ASSUMED     the forward statement is built on the transform side, where
                it needs no sum over the zeros; the pointwise form is left
                open and said so
    DEPENDS     units 0386 and 0393
    OUT         the pointwise sum over zeros; the converse; joints 3, 4, 5
    OUTCOME     done as pinned, unit 0401: four theorems, no `sorry`, no
                hypothesis added; TRAPS row 46 added

### 2026-11-22 · joint 9, way (b): checked before building

    DONE        `lean_stage3/design/joints.md`: way (b) worked through; its
                premise (a finer ladder brings the type below π) is wrong,
                the heights of the zeros being unbounded; a second route by
                convexity is closed; what is true, 9d (every rational base at
                once gives `WindowBound`), is stated; `SECTIONS.md` joint 10
                restated; a NOTEPAD line
    ASSUMED     hand derivation; nothing built or measured
    DEPENDS     the draft and its first correction, the same day
    OUT         no Lean; whether to build 9d, 9c′ or the forward 9a is
                Julian's
    OUTCOME     done as pinned; nothing built

### 2026-11-22 · joint 9: the draft corrected before building

    DONE        `lean_stage3/design/joints.md` block 9 correction: the
                draft's 9b (meromorphy) is false in general and its 9c is
                derived only when the largest real part of a zero is
                attained; what is lost is named, with three ways on;
                `SECTIONS.md` joints 9 and 10 restated; a NOTEPAD line
    ASSUMED     the correction is a hand derivation too; the citations
                (Wolff, Denjoy, Carlson, Cartwright) are from memory and
                were not opened
    DEPENDS     the draft of the same day
    OUT         no Lean; the choice among (a), (b), (c) is Julian's
    OUTCOME     done as pinned; the build of joint 9 did not start

### 2026-11-22 · joint 9 of `SECTIONS.md`: a statement, drafted

    DONE        `lean_stage3/design/joints.md` block 9, marked DRAFT: three
                statements for the table of `G` along the doublings, with the
                hand derivation, what each would take to build and what is
                not claimed; `SECTIONS.md` joints 9 and 10 updated to point
                at it; a NOTEPAD line
    ASSUMED     unit 0383's identity for `G` (derived there, checked
                numerically there, not formalized); the derivation in the
                block is by hand, not checked numerically or against the
                literature
    DEPENDS     `lean/Chain.lean`, `lean/Superposition.lean` as read
    OUT         no Lean, no unit, no measurement; the statement is Julian's
                to correct before anything is built
    OUTCOME     done as pinned

### 2026-11-22 · joint 1 of `SECTIONS.md`: `Stage3/JointWindowDial.lean`

    DONE        `lean_stage3/design/joints.md` opened, block 1;
                `Stage3/JointWindowDial.lean` builds with no `sorry`:
                `zeroFreeRight_of_window`, `psiWeakTheta_of_window`,
                `schoenfeldWeakTheta_of_window`, a window bound on `G` at `θ`
                gives the dial's zero-free statement and its two bounds on
                the prime residual; a formalization unit; `SECTIONS.md`
                joint 1 marked SEALED
    ASSUMED     the statements of block 1 as written
    DEPENDS     units 0399 (the criterion) and the dial's `ThetaPsi`, `ThetaPi`
    OUT         joints 3, 4, 5, 9, 10; the window bound itself, proved nowhere
    OUTCOME     done as pinned, unit 0400: three theorems, no `sorry`, clean
                on the first build

### 2026-11-22 · the sections and the joints: `SECTIONS.md`

    DONE        `SECTIONS.md` at the repository root: the three Lean trees as
                seven sections with the statement at each end, ten joints
                each marked SEALED, WELD or OPEN, and for each OPEN joint
                what the missing lemma must say; a NOTEPAD line
    ASSUMED     built from a script over theorem headers plus the files
                read in full, which the page lists; proofs not read are not
                vouched for
    DEPENDS     the trees as merged on main at `355b725`
    OUT         no Lean, no unit, no joint built; joint 1 was compiled in a
                scratch file and is not in the tree
    OUTCOME     done as pinned

### 2026-11-22 · the Landau window: block 7d of `design/landau.md`, `Stage3/LandauCriterion.lean`

    DONE        `Stage3/LandauCriterion.lean` builds with no `sorry`:
                `stmtLandauWindow : LandauWindow.StmtLandauWindow`, the
                criterion proved, and `rh_of_windows`, `RiemannHypothesis`
                from a window bound at every `θ` in `(1/2, 1)`; a
                formalization unit; block 7d marked PROVED; the leaf
                `StmtLandauWindow` is discharged
    ASSUMED     the range of indices is chosen from `key_ineq` with a margin
                `μ`, in place of the design's fixed range
    DEPENDS     units 0384, 0396, 0397, 0398
    OUT         the hypothesis of `rh_of_windows`, a window bound on `G` at
                every `θ > 1/2`, is not proved, approached or tested here;
                nothing in this repository proves the Riemann hypothesis
    OUTCOME     done as pinned, unit 0399: three theorems, no `sorry`;
                `StmtLandauWindow` is a theorem; TRAPS row 45 added

### 2026-11-22 · the Landau window: block 7c of `design/landau.md`, `Stage3/LandauRates.lean`

    DONE        `Stage3/LandauRates.lean` builds with no `sorry`: `key_ineq`
                (the one inequality between the two tail rates), `exists_centre`
                (a real `σ₀` with S1 and S3 of the design), `exists_pow_small`;
                a formalization unit; block 7c marked PROVED
    ASSUMED     the design's two brackets are replaced by one inequality,
                `4(λ − log(1−δ/12)) < (1+δ)(log(1+δ/3) − λ)`, which is what the
                existence of a range of `k` needs; the range is then chosen
                from it in block 7d, in place of the design's fixed range
    DEPENDS     Mathlib `Real.log_le_sub_one_of_pos`
    OUT         block 7d; `StmtLandauWindow` stays a leaf
    OUTCOME     done as pinned, unit 0398: three theorems, no `sorry`, clean
                on the first build

### 2026-11-22 · the Landau window: block 7b of `design/landau.md`, `Stage3/LandauZeroSide.lean`

    DONE        `Stage3/LandauZeroSide.lean` builds with no `sorry`:
                `zero_side`, from a zero `ρ₀` with `0 < Re ρ₀` and a real
                `σ₀ > 1` with `|σ₀ − ρ₀| < σ₀`, numbers `r, R, τ, C₁, N₀` with
                `σ₀ − 1 < r ≤ |σ₀ − ρ₀|`, `r < R`, `τ > 0`, such that every `N₀`
                consecutive `k` hold one with
                `τ/r^(k+1) − C₁/R^k ≤ Ik σ₀ k / k!`; a formalization unit;
                block 7b marked PROVED
    ASSUMED     the statement indexes by `k` with exponent `k + 1`, where the
                sketch indexed by `n = k + 1`; the hypothesis `Re ρ₀ < 1` of
                the sketch is not needed (Mathlib has it for every zero)
    DEPENDS     units 0392, 0395, 0396; `ContourShift.zeta_order_conj`;
                Mathlib `riemannZeta_conj`
    OUT         blocks 7c, 7d; `StmtLandauWindow` stays a leaf
    OUTCOME     done as pinned, unit 0397: one theorem, no `sorry`; the
                hypothesis `0 < Re ρ₀` was unused and is dropped

### 2026-11-22 · the Landau window: block 7 designed and split; block 7a, `Stage3/LandauPrimeSide.lean`

    DONE        the design of block 7 written into `lean_stage3/design/landau.md`
                before any of it is built: parameters, the two readings, the
                four terms and their rates, split into 7a to 7d;
                `Stage3/LandauPrimeSide.lean` builds with no `sorry`: `Ik`,
                its integrability, `iteratedDeriv_Phi_eq_Ik`, and `Ik_le`, the
                upper bound on the primes' reading from a window bound and
                `G ≤ 8y`; a formalization unit; block 7a marked PROVED
    ASSUMED     the design's arithmetic is checked on a numeric grid, proved
                nowhere yet (block 7c); the rates differ from unit 0391's
                hand check and supersede it
    DEPENDS     units 0388, 0389, 0390, 0391
    OUT         blocks 7b, 7c, 7d; `StmtLandauWindow` stays a leaf; no claim
                about the window bound or RH
    OUTCOME     done as pinned, unit 0396: three theorems, no `sorry`, no
                hypothesis added; TRAPS row 44 added

### 2026-11-22 · the Landau window: block 3b2 of `design/landau.md`, `Stage3/LandauPoleDisc.lean`

    DONE        `Stage3/LandauPoleDisc.lean` builds with no `sorry`:
                `Phi_taylor_on_disc`, the `k`-th derivative of `Phi` at a
                regular centre equals the sum over the zeros in a disc of
                their residues' contributions, up to `k!·C/R^k`; a
                formalization unit; block 3b2 marked PROVED, which closes
                block 3
    ASSUMED     the statement of block 3b2 as written; any hypothesis the
                build adds is reported here
    DEPENDS     units 0393 and 0394; upstream's finiteness of zeros in a
                compact set
    OUT         block 7; no claim about the window bound or RH
    OUTCOME     done as pinned, unit 0395: one theorem, no `sorry`, clean on
                the first build; block 3 is closed

### 2026-11-22 · the Landau window: block 3b1 of `design/landau.md`, `Stage3/LandauPoleSub.lean`

    DONE        block 3b split into 3b1 (no `ζ`) and 3b2 (`Phi` on a disc);
                `Stage3/LandauPoleSub.lean` builds with no `sorry`:
                `iteratedDeriv_inv_sub`, `exists_differentiableOn_sub_poles`,
                `taylor_coeff_sub_poles`; a formalization unit; block 3b1
                marked PROVED
    ASSUMED     the statements of block 3b1 as written; any hypothesis the
                build adds is reported here
    DEPENDS     Mathlib's iterated derivatives and Cauchy estimate; the
                construction is copied from `ContourShift.residue_rectangle_of_local`
    OUT         block 3b2 and block 7; no claim about the window bound or RH
    OUTCOME     done as pinned, unit 0394: three theorems, no `sorry`; the
                openness of `U` in the gluing theorem was unused and is
                dropped; the block named Cauchy's estimate without its
                namespace, corrected

### 2026-11-22 · the Landau window: block 3a of `design/landau.md`, `Stage3/LandauPoleLocal.lean`

    DONE        block 3 split into 3a (local) and 3b (the disc and the Taylor
                coefficients); `Stage3/LandauPoleLocal.lean` builds with no
                `sorry`: `differentiableAt_Phi`, `Phi_principal_part` (at a
                zero `ρ ≠ 0, 1` of order `m`, `Phi` is an analytic function
                plus `m/(ρ(1−ρ))/(s−ρ)`), `Phi_regular_at_one`; a
                formalization unit; block 3a marked PROVED
    ASSUMED     the statements of block 3a as written; any hypothesis the
                build adds is reported here
    DEPENDS     `Stage3/ContourShift.lean` for the order of a zero; Mathlib's
                `riemannZeta₁`; `Stage3/LandauMellinG.lean` for `Phi`
    OUT         block 3b and block 7; no claim about the window bound or RH
    OUTCOME     done as pinned, unit 0393: three theorems, no `sorry`, no
                hypothesis added

### 2026-11-22 · the Landau window: block 6 of `design/landau.md`, `Stage3/LandauTrig.lean`

    DONE        `Stage3/LandauTrig.lean` builds with no `sorry`:
                `exists_large_in_block`, a real sum `Σ c_j z_j^n` over distinct
                unimodular `z_j`, with nonnegative real part at the frequency
                `1` and some `c_j ≠ 0`, is at least a fixed `τ > 0` somewhere
                in every block of at least `N₀` consecutive `n`; with the
                mean and mean-square bounds it rests on; a formalization
                unit; block 6 marked PROVED
    ASSUMED     the lemma is stated for distinct frequencies and a squared
                modulus; the conjugate-pair note of the worksheet is replaced
                by that statement
    DEPENDS     Mathlib's geometric sums
    OUT         blocks 3, 7; no claim about the window bound or RH
    OUTCOME     done as pinned, unit 0392: five theorems, no `sorry`, no
                hypothesis added

### 2026-11-22 · the Landau window: block 4b of `design/landau.md`, `Stage3/LandauTail.lean`

    DONE        `Stage3/LandauTail.lean` builds with no `sorry`:
                `lower_tail_le` and `upper_tail_le`, the kernel's integral
                over `(1, Y]` and over `(Z, ∞)` bounded by a shift of the
                exponent with a free parameter `b`; a formalization unit;
                block 4b marked PROVED
    ASSUMED     the block proves the two bounds with `b` free; the choice of
                `b` that gives `e^(−cδ²k)` is checked by hand in the block's
                Sizes line and is left to block 7
    DEPENDS     `Stage3/LandauKernel.lean` (unit 0389)
    OUT         blocks 3, 6, 7; no claim about the window bound or RH
    OUTCOME     done as pinned, unit 0391: two theorems, no `sorry`, no error
                on the first build

### 2026-11-22 · the Landau window: block 2c of `design/landau.md`, `Stage3/LandauTaylor.lean`

    DONE        `Stage3/LandauTaylor.lean` builds with no `sorry`: `mellinLog`,
                its integrability, its derivative in `s`, `iteratedDeriv_Phi`
                (the `k`-th derivative of `Phi` on `Re s > 1` is `mellinLog k`)
                and its real form at a real point; a formalization unit;
                block 2c marked PROVED
    ASSUMED     the route is differentiation under the integral with
                induction on `k`, in place of the sketch's power series; the
                statements are the block's
    DEPENDS     units 0386, 0388, 0389; Mathlib's parametric integral
    OUT         blocks 3, 4b, 6, 7; no claim about the window bound or RH
    OUTCOME     done as pinned, unit 0390: four theorems, no `sorry`, clean
                first build; the hypothesis `1 < σ` on `mellinLog_real` was
                unused and is dropped from the statement and the block

### 2026-11-22 · the Landau window: block 4a of `design/landau.md`, `Stage3/LandauKernel.lean`

    DONE        `Stage3/LandauKernel.lean` builds with no `sorry`:
                `log_pow_le`, `log_pow_integrable`, and `log_pow_integral`,
                `∫₁^∞ (log y)^k y^(−a−1) dy = k!/a^(k+1)` for `a > 0`; a
                formalization unit; block 4a marked PROVED
    ASSUMED     the statements of block 4a as written in the worksheet; any
                hypothesis the build adds is reported here
    DEPENDS     Mathlib's improper integrals and `Real.log_le_rpow_div`
    OUT         block 4b (the tail); blocks 2c, 3, 6, 7; no claim about the
                window bound or RH
    OUTCOME     done as pinned, unit 0389: three theorems, no `sorry`, no
                hypothesis added; TRAPS row 43 added

### 2026-11-22 · the Landau worksheet: blocks 2c, 4, 6, 7 checked against the trees

    DONE        `lean_stage3/design/landau.md` updated: section 0b lists the
                pieces found for blocks 2c, 4, 6 and 7 and what no tree
                holds; block 4 is split into 4a (the exact integral) and 4b
                (the tail); block 6 carries the conjugate-pair note; the
                build order the dependencies give is written down
    ASSUMED     searches were by name over `theorem` and `lemma` headers in
                Mathlib, upstream, Stage 3, `lean/`, `lean_bridge/` and the
                zeta23 clone; a piece under an unrelated name is not found
    DEPENDS     the names as they stand at the pinned revisions
    OUT         no Lean, no unit, no block's mark changed
    OUTCOME     done as pinned

### 2026-11-22 · the Landau window: block 5b of `design/landau.md`, `Stage3/LandauChebyshev.lean`

    DONE        `Stage3/LandauChebyshev.lean` builds with no `sorry`:
                `rampSum_le_log`, `G_le` (`G y ≤ 8y`), `neg_le_G`, and
                `abs_G_le_log`, `|G(y)| ≤ 8y(1 + log y)` for `y ≥ 1`; a
                formalization unit; block 5b marked PROVED; section 0's tail
                bound restated with it
    ASSUMED     upstream's `Mertens.E₁Λ.le` as stated at the pinned revision
    DEPENDS     `PrimeNumberTheoremAnd/IEANTN/Mertens.lean`, a new import for
                Stage 3; `Stage3/LandauCrude.lean`
    OUT         blocks 2c, 3, 4, 6, 7; no claim about the window bound or RH
    OUTCOME     done as pinned, unit 0388: four theorems, no `sorry`, clean
                on the first build

### 2026-11-22 · the Landau window: block 5 of `design/landau.md`, `Stage3/LandauCrude.lean`

    DONE        `Stage3/LandauCrude.lean` builds with no `sorry`:
                `rampSum_nonneg`, `rampSum_le`, and `abs_G_le`, the bound
                `|G(y)| ≤ 2y(1 + log y)²` for `y ≥ 1`; a formalization unit;
                block 5 marked PROVED
    ASSUMED     the bound carries one more factor `(1 + log y)` than the
                sketch asked for; the block's Sizes line names it and says
                why the plan's size comparison does not move
    DEPENDS     Mathlib's `vonMangoldt_le_log` and `harmonic_le_one_add_log`;
                `Stage3/LandauWindow.lean`
    OUT         blocks 2c, 3, 4, 6, 7; no claim about the window bound or RH
    OUTCOME     done as pinned, unit 0387: three theorems, no `sorry`; the
                block named one Mathlib lemma wrongly (`γ > 0`), corrected

### 2026-11-22 · the Landau window: block 2b of `design/landau.md`, `Stage3/LandauMellinG.lean`

    DONE        `Stage3/LandauMellinG.lean` builds with no `sorry`: `Phi`,
                the integrability of the ramp sum's and of `G`'s Mellin
                integrand, the integral of `log y · y^(−s)`, and `mellin_G`,
                the Mellin transform of `G` on `Re s > 1` equal to `Phi s`;
                a formalization unit; block 2b marked PROVED
    ASSUMED     the statements of block 2b as written in the worksheet; any
                hypothesis the build adds is reported here
    DEPENDS     `Stage3/LandauMellin.lean` (unit 0385); Mathlib's improper
                integrals and the L-series of `Λ`
    OUT         blocks 2c and 3 to 7; no claim about the window bound or RH
    OUTCOME     done as pinned, unit 0386: six theorems, no `sorry`, no
                hypothesis added; TRAPS rows 40 to 42 added

### 2026-11-22 · the Landau worksheet: blocks 2b and 3 checked against the trees

    DONE        `lean_stage3/design/landau.md` updated: section 0b lists the
                pieces found for blocks 2b and 3, each name opened and its
                statement read; block 3's sketch drops the real-zero line;
                a new block 2c holds the step section 0 uses and no block
                proved, the Taylor coefficients of the transform as
                integrals against powers of `log y`
    ASSUMED     statements only were read; hypotheses may still need adapting
    DEPENDS     the names as they stand at the pinned Mathlib and upstream
    OUT         no Lean, no unit, no block's mark changed
    OUTCOME     done as pinned

### 2026-11-22 · the Landau window: block 2 of `design/landau.md`, `Stage3/LandauMellin.lean`

    DONE        `Stage3/LandauMellin.lean` builds with no `sorry`: the ramp
                kernel's integral, its norm's integral, `rampSum` as a
                `tsum`, and `mellin_rampSum`, the Mellin transform of the
                ramp sum on `Re s > 1`; a formalization unit; block 2 of
                `lean_stage3/design/landau.md` marked PROVED
    ASSUMED     the statements of block 2 as written in the worksheet; any
                hypothesis the build adds is reported here
    DEPENDS     Mathlib's L-series of `Λ` and its power integrals on `(c, ∞)`;
                `Stage3/LandauWindow.lean` for `rampSum`
    OUT         the transform of `G` itself (block 2b); blocks 3 to 7; no
                claim about the window bound or about RH
    OUTCOME     done as pinned, unit 0385: five theorems, no `sorry`, no
                hypothesis added; `rampK_integrable` joined the block's list
                before the build; TRAPS row 39 added

### 2026-09-24 · the atlas's topography: Mathlib and PrimeNumberTheoremAnd

    DONE        two new layers on `atlas/`, each switched on and off: the
                Mathlib ground and the PrimeNumberTheoremAnd ground; the
                extraction keeps each declaration's direct uses of those
                libraries (proofs unchanged, read only); constants weighted
                by rarity so ground every island shares is background;
                drawn as terrain by library area under the islands, the
                exact constants on hover; which islands share ground named
                on the page; two runs byte-identical
    ASSUMED     "topography" is area-level terrain with constants on hover;
                direct uses only (transitive ones reach the same logic under
                everything); lean/ and lean_stage3/ pin different Mathlib
                versions, so shared ground across them is a name match and
                is marked as such
    DEPENDS     the atlas lift of 2026-09-24; no flag
    OUT         changing any proof or project file; a layer for other
                dependencies

### 2026-09-24 · the atlas, Primebeat's own map of its mathematics

    DONE        `atlas/`: a script that reads every declaration of every
                `.lean` file (lean/, lean_stage3/, results/, slice3.lean)
                with the declarations its proof uses (Lean's own list), its
                closure from 0 to 1 (share of its dependency tree free of
                sorry), the bounds on `s.re` its statement names, and the
                git day it first appeared; the units pinned by their
                `refs:`; the scripts, notes, preregs and CONTEXT.md attached
                by the names they mention; one self-contained page in an
                ignored `atlas/build/`, two maps overlaid (territory:
                mathematics and units; commentary: the why), with the strip
                and closure overlays; two runs byte-identical
    ASSUMED     an atlas relates and has no target; the roots are the
                declarations that use nothing else in Primebeat; the
                trajectory is the order of discovery; commentary attaches by
                name only, and commentary naming nothing sits in a labelled
                margin lane; lean/ and lean_stage3/ are read each under its
                own toolchain; a statement with no literal bound on `s.re`
                sits in a labelled lane
    DEPENDS     Julian lifted read-only for this tool only (2026-09-24);
                no flag, since `atlas/` is outside every guarded path
    OUT         any unit, the lab copy, guarded paths; publishing the page;
                roads for shared constants (a layer for later)

### 2026-09-19 · lab R.5 and Q, the story after R.4 — lab PLAN § R.5, § Q

    DONE        R.5: unit ids and bare numbers out of the neighbourhood
                ranking; each component line marked thread or corridor
                from whether its top object recurs; a line under the
                neighbourhoods naming the joints that carried nothing
                because the parent's closing names no object, 0368 to
                0369 first among them. Q.1 to Q.4 as PLAN § Q reads
                them: subrepos.tsv with a re-run of lab check at the
                pinned sha in the pre-commit, name:0012 ids, lab index
                --subrepos, lab find over named objects
    ASSUMED     the story is final enough for Q: R.4 shipped and the
                corridor-thread reading came out of the run on 0351 to
                0373 without a declared rule; a component is a thread
                when its top object sat on two or more joints, else a
                corridor; Primebeat stays on its own lab copy
    DEPENDS     lab main ee1e8b6; the 0351 to 0373 units as drafted;
                the run of 2026-09-19 that gave six components and
                three unattached
    OUT         any change to the 23 units; sealing 0350 to 0374;
                pushing prose_parser; R.3, which waits on Julian's
                reading of narrow and revert as one move or two
    OUTCOME     DONE, 2026-09-19, lab b2100cf, 302 tests. R.5: the
                0361 to 0368 component prints corridor, 0369 to 0373
                thread; blind joints 0355 to 0356 and 0368 to 0369,
                where the parent closing names only unit citations.
                Q.1 lab subrepos and the pre-commit refusing a pin to
                a failing sha; Q.2 name:0012 ids through chain, index,
                story, check; Q.3 INDEX-subrepos.tsv with outcome as a
                dash on every row, no unit carries the field; Q.4 lab
                find, on this repo isTest_phiWC returns 0368 to 0372
                and 0374, the tree untouched. Primebeat still runs its
                own lab copy
    OUTCOME 2   2026-09-19, later: section S, status in the unit. S.1
                status: at birth, lab check nags until the reason is
                written (Julian: a unit is a memory, it is not clean);
                S.2 closes: links; S.3 lab status folds forward, the
                NOTEPAD as a view; S.4 lab status --derive on 0351 to
                0374: 0365 and 0374 open, six set-aside (0352, 0354,
                0356, 0359, 0360, 0373), two blind (0355, 0368), the
                rest held. Derived lines are written to no unit; the
                sweep is Julian's. lab main pushed
    OUTCOME 3   2026-09-19, later: section T, the blueprint. keeps:,
                sets-aside:, opens: generated at seal from the unit's
                own prose, every reason a verbatim sentence, no free
                slot (Julian: a script that runs, so there is no
                choice); T.1b a unit whose closing hands nothing
                forward does not seal; the story reads the fields at
                every joint and ends in an audit. T.5 on a copy of
                0351 to 0374 (Primebeat untouched): FAIL, no closing
                asks a question, 22 of 23 joints hand forward in
                statements ending in Julian's call or word; the fourth
                field is next:. lab main pushed, 435 tests

### 2026-09-18 · unit 0374, the object-trajectory annotation of 0351 to 0373 — lab PLAN § R.1

    DONE        one analysis unit; one row per object per unit over 0351 to
                0373 in id order: object, kind, move, and the verbatim
                prose line that carries the move; kinds and moves invented
                as needed; after each unit the running counts of distinct
                kinds and moves in values.tsv; the closing copies the R.2
                outcome sentence the counts select
    ASSUMED     the foreman annotates and Julian reads the count; a move
                is named by what the unit's prose says happened to the
                object, and two moves are one when the receipt would be
                the same; the plateau rule is § R.2 as committed at lab
                266a4da before this unit existed
    DEPENDS     the 23 units' unit.md prose as sealed or drafted today;
                lab PLAN § R.2's rule text
    OUT         any code in lab; any change to the 23 units; the choice
                between R.3 and R.4, which is Julian's after the count

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

### 2026-09-09 · block 15's first blocking lemma: OffLineBox.Finite — pin after the run

    DONE        Stage3.offLineBox_finite proved in 41 lines (unit 0369),
                a subset argument on Kadiri.zeroes_on_Compact_finite' with
                the strip [1/2 + ε, 1] × [-T, T] as the compact set; the
                first of two lemmas unit 0368 named as blocking block 15
    ASSUMED     nothing; the proof is direct
    DEPENDS     the second lemma, contDiff_one_indicator_Icc, is where the
                work now sits; my first pass on it hit HasDerivWithinAt.congr
                unification cascades at the boundary case and I left it for
                its own unit rather than commit a broken module
    OUT         the C1 indicator lemma; the placeholders in WeilPowerAssembly

### 2026-09-09 · block IndicatorContDiff, under the relay — the second of the two lemmas

    DONE        contDiff_one_indicator_Icc proved (or sorry'd with the goal
                named per LOOP v21) in Stage3/IndicatorContDiff.lean; the
                second of the two lemmas unit 0368 named as blocking block
                15's isTest_phiWC
    ASSUMED     the assembly of contDiff_one_iff_deriv with pointwise
                HasDerivAt at every x and continuity of the indicator
                derivative; the boundary-case at x = a and x = b uses
                either HasDerivWithinAt.union or direct hasDerivAt_iff_tendsto
    DEPENDS     nothing from Julian
    OUT         the follow-up: fill WeilPowerAssembly's three True
                placeholders using offLineBox_finite (unit 0369) and this
                lemma; close detect_gap_exists
    OUTCOME     PROVED, unit 0370, module committed with 0 sorries; closed on
                the relay's first pass in 249 lines; 10 first-build errors from
                five roots (three HasDerivAt.congr_of_eventuallyEq over-.symm,
                two EventuallyEq.continuousAt misuses, four Unknown identifier
                a/b from rcases lt_trichotomy with rfl, one pin cascade), all
                self-corrected by the builder; TRAPS row 38 for the rcases-rfl
                endpoint-substitution trap; both blocking lemmas landed

### 2026-09-09 · block 15 close-out, under the relay — WeilPowerAssembly's remaining sorries

    DONE        WeilPowerAssembly closed as far as one relay pass reaches:
                isTest_phiWC by contDiff_one_indicator_Icc at phiW (unit 0370),
                three placeholders by real signatures using offLineBox_finite
                (unit 0369), detect_gap_exists by the exponential-vs-polynomial
                existence via Real.tendsto_exp_atTop (unit 0371)
    ASSUMED     the placeholder signatures may need adjustment on the first
                try; per LOOP v21 any that don't close cleanly land as sorry
                with the goal in a comment; a partial commit is expected
                and the values.tsv row records what stands
    DEPENDS     nothing from Julian
    OUT         a follow-up unit for any placeholders or detect_gap_exists
                that sorry on this pass; the numeric L (still Julian's call
                whether to compute it explicitly)
    OUTCOME     PARTIAL, unit 0371, module committed with 2 sorries (down from
                0368's 2 but on different, narrower goals). Three placeholders
                lifted to real signatures with clean pins (near_nonneg,
                far_moderate_le, far_large_le); isTest_phiWC has three of four
                conjuncts closed and only the ContDiff conjunct sorries;
                detect_gap_exists still sorries at step (d), the
                exponential-vs-polynomial existence. Assumed pins recorded:
                near_nonneg's h_pointwise carries block 13g per member,
                far_*_le take U_mem / U_far as abstract parameters

### 2026-09-09 · isTest_phiWC ContDiff conjunct, under the relay

    DONE        isTest_phiWC ContDiff conjunct closed via a new helper
                phiW_contDiff_one, using contDiff_one_indicator_Icc (unit 0370)
                at f = W · exp(-u/2) with the four boundary hypotheses closed
                by q(m, ±1) = 0 and q'(m, ±1) = 0 for m ≥ 1 (unit 0372)
    ASSUMED     q(m, ±1) = 0 from sin(π · ±1) = 0; q'(m, ±1) = 0 for m ≥ 1
                from P(±1) = cos²(±π/2) = 0 and cos(π) = -1; the product /
                composition derivative computations use Mathlib names named
                in the brief; any single boundary have that doesn't close on
                one try sorrys with its goal per LOOP v21
    DEPENDS     nothing from Julian
    OUT         detect_gap_exists (the other remaining sorry, its own unit)
    OUTCOME     PROVED, unit 0372, module committed with 1 sorry (only
                detect_gap_exists remains); phiW_contDiff_one landed as a
                new helper with a clean pin; isTest_phiWC's pin flipped from
                sorryAx to clean; the whole chain closed on the relay's
                first pass with 0 errors; row 16 recurred and was worked
                around by named implicit arguments at the boundary
                composition, no new TRAPS row

### 2026-09-09 · detect_gap_exists, under the relay — the last sorry of block 15

    DONE        detect_gap_exists closed as far as one relay pass reaches;
                the value of this unit is naming precisely which sub-step of
                the assembly (target vs on-line + cluster + far) blocks it
                if it does not close (unit 0373)
    ASSUMED     the exponential gap between target's rate ε²/(π²(m+2)) and
                cluster rate (ε² − δ²)/(π²(m+2)) closes by Real.tendsto_exp_atTop
                chained with polynomial-vs-exponential; if the tsum split of
                zeroForm doesn't unfold cleanly, the whole proof sorrys with
                the goal in a comment; expected outcome may be a large sorry
                with the assembly structure named
    DEPENDS     nothing from Julian
    OUT         the numeric L (this is EXISTENCE only); any Mathlib PR needed
                for the tendsto_exp_atTop assembly
    OUTCOME     PARTIAL-BUT-REVERTED, unit 0373, module committed with 1 sorry
                (same as unit 0372). The builder's structural fill committed
                to L = 2 (h = 1) which made the sign step provably-false; the
                foreman reverted to a whole-theorem sorry with the tendsto_exp
                route named in a comment. The lesson: a structural fill that
                boxes the sign into an unprovable case is worse than a whole-
                theorem sorry. Block 15's last theorem stands open until a
                real assembly pass writes the tendsto_exp chain

### 2026-09-18 · lab as its own repo, pinned per project — six sections under the relay

    DONE        ~/GitHub/lab exists with PLAN.md (sections A to F, each with
                a Done-when line); A extract, B templates, C lab init, D the
                pin, E convergence on a throwaway repo and the sibling, F
                publish; a box is ticked by the foreman after running the
                section's check
    ASSUMED     per-repo unit numbering; lab installed by pip from a git
                commit and pinned in requirements.txt and lab.pin; Primebeat
                keeps its own copy until Julian decides otherwise
    DEPENDS     Julian: the GitHub remote for F; the switch of Primebeat
                itself, after E
    OUT         changing what lab check enforces; a template repo separate
                from lab init; touching Primebeat's pre-commit
    OUTCOME     DONE 2026-09-18, all six sections ticked after the foreman
                re-ran each check; github.com/juliansambranojr/lab, first pin
                d66e663; non_convex_zero_crossing switched to the pin. Two
                things changed in what lab enforces, both named in PLAN.md:
                a fresh unit checks clean, and lab seal refuses unreplaced
                scaffold slots. Primebeat keeps its own copy, Julian's call
    OUTCOME 2   2026-09-18, later: sections G to K done under the same
                relay. G: Clarkson et al. 2017 against its compendium,
                all twenty claims refuse (35 absence, 11 disagreement,
                1 derivation), the accumulation rate 4.1 is not the
                paper's own 45 cm over 12.3 kyr. H: lab bench, the
                checker's spec sheet on this corpus (catch 46/70 digit,
                11/28 drop, 2/70 swap; swap is invisible by
                construction). I: python -m lab exited 0 on a finding,
                which had hidden this repo's own copy refusing unit-id
                refs; fixed in lab, not here. J: lab story. K: the seal
                names its commit. This repo's copy still has the exit
                hole; its pre-commit reads the return value itself and
                was never exposed

## Archive

### 2026-11-22 · the Landau window: block 1 of `design/landau.md`, and the bench's measurement of `G`

    DONE        two things. (1) One exploratory unit measuring
                `G(y) = Σ_{n≤y} Λ(n)(y/n − 1) − y log y + (1+γ)y` exactly
                from a sieve, against the sum over the bench's zeros, with
                the windows of the criterion read off; labelled
                EXPLORATORY, no verdict. (2) A worksheet,
                `lean_stage3/design/landau.md`: the criterion as Stage 3's
                own statement for `ζ`, the proof planned from scratch in
                slices with each slice's size, and its first slice built
    ASSUMED     "Do 2 with 1 alongside" (Julian, 2026-11-22): 2 is
                "formalize the criterion in Stage 3 from scratch, as your
                own Landau-type theorem", 1 is "measure G on your bench";
                the statement's shape is read from Alpöge's archive
                (`zeroFree_of_rpow_window`) and cited; no code is copied
                from it, since it carries no licence, and the proof is
                planned independently; the whole criterion is several
                modules, so this task is the plan and the first slice, and
                the block says which slices remain
    DEPENDS     nothing from Julian
    OUT         the proof of the window bound itself (that is the 17
                million lines); Dirichlet characters; a prereg, since the
                measurement tests nothing
    OUTCOME     units 0383 and 0384. Measured: G within K sqrt(n) of
                log 2pi - T at every integer to 1e8, the zeros reproduce
                it. Built: slice 1 of 7, the statement and the reduction to
                RiemannHypothesis; the criterion is a leaf with six slices
                open. Two errors of mine caught by gates: the bound had
                left out the trivial zeros' term, and a figure in the prose
                was from the earlier run

### 2026-11-22 · C, the zero-set lemma: `Stage3/WeilBridgeLeaf.lean`, block 1 of `design/bridge.md`

    DONE        in Stage 3: `zeroForm G` rewritten as the sum over Mathlib's
                zero set with `analyticOrderAt` (the zero-set lemma), and
                `zeroForm G = primeSideM (kOfM G)` for `IsTest L G` from a
                named leaf `StmtWeilBridge`; in `lean_bridge/`: the same
                leaf as a `def`, in Mathlib-only vocabulary, and the
                theorem that it holds; every shared definition copied by
                text and gated by `check_weld.py`; a design block; one unit
    ASSUMED     "The zero-set lemma in Stage 3 to finish C" (Julian,
                2026-11-22); the leaf's discharge is `lean_bridge`'s
                `stmtWeilBridge_holds`, by statement identity, the way
                Stage 3 already composes with `lean/`; shared definitions
                are written with fully qualified names so the text is the
                same under either tree's `open` lines; the leaf has no
                constant, so no budget line
    DEPENDS     nothing from Julian
    OUT         any use of the prime side (positivity); the Dirichlet case
    OUTCOME     built, unit 0382: four theorems in Stage 3, three added in
                the third tree, nine welds OK, both trees build. One pin
                bent: the shared text could not say `Complex.digamma`,
                which Stage 3 does not have in scope there, and says
                `logDeriv Complex.Gamma` in both trees

### 2026-11-22 · C, the third tree: `lean_bridge/`, the bridge proved against zeta23

    DONE        a Lake project `lean_bridge/` on zeta23's toolchain that
                requires `anthropics/formal-math` at a pinned commit
                (subdirectory `zeta23`) and proves, kernel-checked against
                `Zeta23.WeilEF.EF_lit_zetaZeroConfig`, the bridge of unit
                0379: for a test function of the tree's class, the zero
                side equals `literatureRHS` at `k = F ⋆ F⁻`; the tree's
                `laplace` and `IsTest` copied by text and gated by
                `check_weld.py`; axiom pins; one unit
    ASSUMED     "Third tree it is" (Julian, 2026-11-22) chooses the second
                option of unit 0379; the tree's conventions are Stage 3's
                (pins by `#guard_msgs`, no sorry unless declared, one unit
                per module) and `LOOP.md` is followed where it applies to
                a tree that is not `lean_stage3`; the zero side is stated
                over zeta23's own zero set, and the lemma identifying it
                with upstream's `zeroes_sum` is Stage 3 work, out of this
    DEPENDS     a second Lean toolchain and a second Mathlib cache fetched
                into this session, from the hosts already allowed
    OUT         the zero-set lemma in Stage 3; any use of the bridge
                (positivity); Dirichlet L-functions
    OUTCOME     built, unit 0381: `Bridge.weil_bridge`, 13 theorems, no
                sorry, three axioms, against zeta23 at 16a5ce4; two welds
                added to `check_weld.py`, whose pattern now accepts
                `noncomputable def`. All pins stood

### 2026-11-22 · C, the bridge to primes: the statement comparison and its design

    DONE        one decision unit: (a) the three statements side by side,
                the tree's `zeroForm`, upstream `kadiri_thm_3_1_q1` at the
                pin and at HEAD, and zeta23's `EF_lit`; (b) the dictionary
                between the tree's zero side and zeta23's, with every
                normalisation, checked numerically on the tree's window
                against the bench's zeros and the primes; (c) the ways to
                compose them across toolchains, each priced; no Lean
    ASSUMED     "start C" (Julian, 2026-11-22); C is "port or weld the
                sorry-free explicit formula from zeta23, so `zeroForm` has
                a prime side in your tree"; the upstream race rule of
                DESIGN.md § 0 applies, so upstream HEAD is probed first;
                which way to compose is Julian's, since one option is a
                new tree at a third toolchain
    DEPENDS     Julian's choice among the options, after the unit
    OUT         building anything; the Dirichlet L-function formula;
                positivity itself
    OUTCOME     unit 0379: the bridge statement fixed and checked on both
                sides to 3.5e-16; upstream not discharged; three options
                priced and left to Julian

### 2026-11-22 · rung 5 block 16a, `Stage3/WeilPowerTail.lean`: the tail bound

    DONE        block 16a of `lean_stage3/design/rung5.md` written with the
                Lean statements, the hints and the composed statements;
                the module itself, built and pinned, when a build exists
    ASSUMED     the first module of section 16 is the one new analytic
                lemma (unit 0378), since everything else composes it;
                names grepped in the pinned Mathlib source, which is cloned
                here though its cache is not fetched
    DEPENDS     a Lean build. The toolchain and the pinned packages are
                installed in this session; fetching Mathlib's cache was
                refused by the session's permission classifier after the
                host was allowed. Julian's to unblock
    OUT         every other theorem line of section 16; C
    OUTCOME     built, unit 0380: six theorems, no sorry, first build
                clean, statements as the block wrote them. The DEPENDS
                line was met on 2026-11-22: Julian allowed the cache host
                and the fetch

### 2026-11-22 · rung 5 section 16, open items (a) and (c): priced on proved inequalities

    DONE        one unit whose `run/` re-prices unit 0375's nine cells
                using only inequalities in the shape of Lean statements:
                the tree's own where they reach, and each new one named,
                stated, and checked against the exact `S` on a grid before
                it is used; the table of `h₀` proved-form against exact,
                the lost factor per cell, and which tree theorem or new
                lemma carries each zero; items (a) and (c) of the block
                rewritten; the list of new lemmas a module would need
    ASSUMED     "Let's do A then C" (Julian, 2026-11-22): A is finishing
                section 16 as mathematics, this pricing first and a module
                after; a bound counts as the tree's only if its hypotheses
                hold at the cell, checked in the script; `λ = 1` unless a
                hypothesis forces otherwise, and then the block says which
    DEPENDS     nothing to run it. A module after it needs Lean, which is
                not installed in this environment; that is asked for when
                the pricing says a module is feasible
    OUT         the Lean module itself; C (the bridge to primes); auditing
                units 0366 and 0367's pricing of the old window
    OUTCOME     priced, unit 0378: 9 of 9 cells close on proved-form
                bounds within a factor 1.022 of the exact price; one new
                lemma (the tail bound); items (a) and (c) closed. The
                ASSUMED pin on `λ = 1` stood

### 2026-11-22 · rung 5 section 16, open item (d): prior art for the explicit support

    DONE        one unit recording a literature search for section 16's
                two claims of novelty, each with a verdict of KNOWN, PARTLY
                KNOWN or NOT FOUND and the sources opened: (1) a theorem of
                the shape "an off-line zero in a box forces Weil's form
                negative at an explicit support `L(ε, T)`", or its
                contrapositive; (2) the device, a polynomial factor of the
                transform vanishing at unwanted zeros, i.e. a differential
                operator on the test function; plus what the papers after
                arXiv 2608.13637 did with the same form; Open (d) of the
                block rewritten to the verdicts
    ASSUMED     "Yes" (Julian, 2026-11-22) answers "do you want me to run
                the prior-art search next?"; entry 296 of the notebook
                already read Bombieri, Yoshida, Burnol, Suzuki, Connes and
                Consani and the Li side for claim (1) as of 2026-09-01, so
                this search starts from it and does not redo it; a source
                counts as opened only if its text reached this session;
                NOT FOUND means not found in what was searched
    DEPENDS     arxiv.org is the one host this environment allows; a source
                elsewhere is cited from search summaries and marked so
    OUT         any claim of priority; reading sources that are paywalled
                or off arxiv.org beyond their search summaries; items (a),
                (c) of the block
    OUTCOME     searched, unit 0377: the device is KNOWN (Zhu, arXiv
                2608.24827 section 13.2), the uniform explicit support NOT
                FOUND (nearest: Danesh, arXiv 2611.10726). The block's
                sentence about the multiplier's novelty was too easy to
                misread and now points at the verdict

### 2026-11-22 · rung 5 section 16, open item (b): the kept members' sign swept

    DONE        one unit whose `run/` decides T9 of section 16 numerically:
                (a) the phase of a kept member's term against the target's,
                split into its parts, as a bound and as a worst case
                computed exactly at the nine cells of unit 0375; (b) random
                and adversarial ladder configurations at those cells;
                (c) planted ladders on the tree's term at small scale with
                the actual multiplier and rotator, counting kept terms of
                the wrong sign; (d) the least ladder ratio at which the
                sign can flip; the block's T9 and Open (b) rewritten to
                what the run supports
    ASSUMED     "Ok let's do it" (Julian, 2026-11-22) answers "which of the
                four open items do you want first? My pick is the kept
                members' sign"; the sign is decided by the phase of
                `p(a)²·what(a)²` against `p(s₀)²·what(s₀)²`, which the
                rotator makes positive real; `λ = 1`, `ξ = 12N`,
                `θ₀ = π³/(8h)` as in unit 0375; planted zeros are controls
    DEPENDS     nothing from Julian to run it
    OUT         a Lean proof of T9; items (a), (c), (d) of the block;
                re-pricing unit 0375's table at another ladder ratio (the
                number is reported, the table is left)
    OUTCOME     swept, unit 0376: the sign holds with a factor 9.4 to
                spare; no pin was wrong. One error of mine inside the run:
                the fail-case test first used a flip threshold of 4.49 for
                eight members where it is 8.93, and the gate caught it

### 2026-11-22 · rung 5, the annihilating multiplier priced (section 16)

    DONE        one decision unit whose `run/` computes on the tree's
                object (`term_eq_sidebands`, `S_mul_QS`): (a) the identity
                that a constant-coefficient even real operator `p(D)` on
                the window multiplies each zero's term by `p(ρ − 1/2)²`,
                checked numerically; (b) a planted cluster where the
                unmultiplied form has the wrong sign and the multiplied one
                the right sign; (c) the least `h` at which the target beats
                every other zero's worst case, as a table over `ε` and `T`
                with `L` depending on `ε, T` alone; one SKETCH block,
                section 16 of `lean_stage3/design/rung5.md`, in the
                DESIGN.md block shape with the lost factor named
    ASSUMED     "price idea 1 as a SKETCH block before any Lean" (Julian,
                2026-11-22: "Yes") means the worksheet block and its unit,
                no module; the cluster is every off-line zero within `1/2`
                in height of the target, counted by
                `JensenCount.zeta_local_zero_count`; with the cluster
                annihilated the target is any zero of the box, so section
                8's walk is not used and `T' = T`; `λ = 1`, `m + 1 = h` as
                in unit 0366, stated in the block as a choice; the planted
                zeros of (b) are controls and no claim about `ζ`
    DEPENDS     nothing from Julian to run it; whether section 13's mark
                moves, and whether a module follows, are his
    OUT         any Lean; `StmtWeilPositive`, which this route does not
                touch; moving the marks of sections 9, 13, 14; the
                literature search for an explicit-support form of
                Bombieri's Theorem 10 (named in the block as unchecked)
    OUTCOME     priced, unit 0375: 9 of 9 cells close with no gap
                hypothesis. One ASSUMED pin was wrong and the run found it:
                the cluster radius. At `1/2` a zero at real part offset
                `1/2` and height distance `1/2` grows on the exact term and
                beats small `ε`; the radius is `0.9`, inside the same
                count's disk. The other pins stood

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
