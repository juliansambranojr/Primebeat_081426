# Theorem index

**GENERATED** by `utilities/theorem_index.py`. Do not edit by hand;
re-run after any change to `lean/`.

325 theorems across 26 modules. Every one carries a
`#guard_msgs`-pinned `#print axioms`, so the axiom column is checked by
`lake build` rather than asserted here.

`ℂ floor` means `[propext, Classical.choice, Quot.sound]` — unavoidable for
any statement mentioning ℝ or ℂ, since Mathlib builds ℝ with choice. The
rows reading **none** are the tight ones: pure computation, nothing assumed.

## Depending on no axioms at all

| module | theorem | claim |
|---|---|---|
| `Construction` | `tableFrom_isTableOf` | `tableFrom` satisfies its own recurrence. |
| `Construction` | `unique_of_isTableOf` | Uniqueness. |
| `Construction` | `eq_of_same_row` | Two tables over the same row agree everywhere. |
| `Isogeny` | `measured_row_four` | The measured base-4 row, from the 21 pinned values and nothing else. |
| `Isogeny` | `measured_row_eight` | The measured base-8 row, same 21 values read at decimation 3. |
| `PairIdentity` | `base_three_carries_factor` | Base three does carry the factor: the total at `(r,d)` is `2^(d+1)·3^(r−1−d)`, never a bare power of three. |
| `PairIdentity` | `base_four_carries_factor` | Base four likewise: `3^(d+1)·4^(r−1−d)`. |
| `PairIdentity` | `measured_composite_matches_pair_identity` | The falsifier. |
| `Propagation` | `pasc_zero` | The left edge of the triangle is all ones. |
| `Propagation` | `pasc_succ` | Pascal's identity — definitional, because `pasc` is defined by it. |
| `Propagation` | `pasc_eq_zero` | Above the diagonal the binomial vanishes. |
| `SeedPerturbation` | `tableFrom_zero` | The zero row builds the zero table. |
| `SeedPerturbation` | `window_bottoms_correct` | The window bottoms `r − d` of the four zeros are `1, 3, 5, 14`, computed rather than transcribed. |
| `SeedPerturbation` | `protected_at_R_two` | Which zeros the theorem protects when 2 and 3 are the excluded primes. |
| `SeedPerturbation` | `protected_at_R_three` | And when the excess reaches rung 3 — which `silence46` does, since 6 sits in `(4,8]`. |
| `SeedPerturbation` | `silence46_alive_at_three` | And rung 3 genuinely carries excess, so `boundary_can_move` has its `e R ≠ 0`. |
| `SeedPerturbation` | `measured_silence46_matches_shift` | The falsifier. |
| `SeedPerturbation` | `measured_emptied_matches_shift` | The second falsifier, at `R_e = 2`. |
| `ZeroCells` | `construction_eq` | The construction module's list is the computed one. |
| `ZeroCells` | `seedPerturbation_eq` | The seed-perturbation module's list is the computed one. |
| `ZeroCells` | `pairIdentity_eq` | The pair-identity module's list is the computed one. |
| `ZeroCells` | `construction_all_vanish` | Every cell `Construction.measured_zeros` names vanishes — now derived, not transcribed. |
| `ZeroCells` | `seedPerturbation_all_vanish` | Every cell `SeedPerturbation.zero_cells` names vanishes. |
| `ZeroCells` | `pairIdentity_all_vanish` | Every cell `PairIdentity.zero_cells` names vanishes. |
| `ZeroCells` | `all_four_have_length_four` | All four names, one length. |
| `Zeros` | `tableFrom_isTable` | The bench's table is one. |
| `Zeros` | `window_shared_of_composite_exponent` | The (8,3) window is shared. |
| `Zeros` | `zero_2_1` | `(2,1)` vanishes: `1·1 − 1·1 = 0`, computed by the kernel from `pi2`. |
| `Zeros` | `zero_4_1` | `(4,1)` vanishes: `1·2 − 1·2 = 0`. |
| `Zeros` | `zero_8_3` | `(8,3)` vanishes: `23 − 3·13 + 3·7 − 5 = 0`, four values of `π`. |
| `Zeros` | `zero_20_6` | `(20,6)` vanishes: the depth-6 stencil on seven values of `π`, spanning `2^13` to `2^20`. |
| `Zeros` | `measured_zeros_all_vanish` | The list's own claim, as a theorem. |
| `Zeros` | `nonzero_7_3` | A non-zero neighbour, so the check can fail. |
| `Zeros` | `nonzero_19_6` | The `+343` of `papers/The-Fold.md` § C3, the partner of the `−343` that a zero at `(20,6)` forces onto `(20,7)`. |
| `Zeros` | `four_zeros_only` | Four zeros in 1953 cells. |

## Chain (31)

| theorem | claim | axioms | cited by |
|---|---|---|---|
| `bdiff_smul` | `bdiff` is homogeneous: scalars pass through. | ℂ floor | `lab_notebook_2.md` |
| `A4_of_A1` | A1 → A4. | ℂ floor | `lab_notebook_2.md` |
| `B5_of_A4_B4` | A4 ∧ B4 → B5. | ℂ floor | support |
| `C2_of_C1` | C1 → C2. | ℂ floor | support |
| `C3_of_A4_C2` | A4 ∧ C2 → C3. | ℂ floor | `lab_notebook_2.md` |
| `C3lower_of_A4_C2` | A4 ∧ C2 → C3 (decay half). | ℂ floor | `lab_notebook_2.md` |
| `A2` | A2, proved rather than assumed, from `EulerFactorChain.euler_product_riemannZeta` (Mathlib's `riemannZeta_eulerProduct_tprod`). | ℂ floor | `Euler-Factor-Chain.md` |
| `A3` | A3, proved rather than assumed. | ℂ floor | `Euler-Factor-Chain.md` |
| `C1` | C1, proved rather than assumed. | ℂ floor | `Euler-Factor-Chain.md` |
| `C2` | C2, now unconditional. | ℂ floor | `Euler-Factor-Chain.md` |
| `A1` | A1, proved rather than assumed, from `EulerFactorChain.symbol_of_backward_difference`. | ℂ floor | `Euler-Factor-Chain.md` |
| `A4` | A4, now unconditional. | ℂ floor | `Euler-Factor-Chain.md` |
| `B4` | B4, proved rather than assumed, from `EulerFactorChain.h_eq_gain_pow_on_critical_line`. | ℂ floor | `Euler-Factor-Chain.md` |
| `B5` | B5, now unconditional. | ℂ floor | `Euler-Factor-Chain.md` |
| `C3` | C3, now unconditional. | ℂ floor | `Euler-Factor-Chain.md` |
| `C3lower` | C3's decay half, unconditional. | ℂ floor | support |
| `tableFrom_eq_bdiff_iter` | The weld. | ℂ floor | `CONTEXT.md`, `lab_notebook_2.md` |
| `tableFrom_mode` | The chain, welded. | ℂ floor | `NOTEPAD.md`, `lab_notebook_2.md` |
| `tableFrom_norm_on_critical_line` | The table on the critical line. | ℂ floor | `lab_notebook_2.md` |
| `sym_eq_zero_iff` | The pole lattice. | ℂ floor | `NOTEPAD.md`, `README.md`, `lab_notebook_2.md` |
| `sym_periodic` | The symbol is periodic with the lattice period. | ℂ floor | `lab_notebook_2.md` |
| `gain_sq_periodic` | The circle. | ℂ floor | `Euler-Factor-Chain.md`, `NOTEPAD.md`, `lab_notebook_2.md` |
| `period_vacuous_at_one` | The trap `gain_sq_periodic`'s `b ≠ 1` closes: at `b = 1` the period is zero and the statement holds for any function whatsoever. | ℂ floor | `lab_notebook_2.md` |
| `gain_sq_at_floor` | D1, floor half. | ℂ floor | `Euler-Factor-Chain.md`, `lab_notebook_2.md` |
| `gain_sq_at_ceiling` | D1, ceiling half. | ℂ floor | `Euler-Factor-Chain.md`, `lab_notebook_2.md` |
| `C2_floor_attained` | D2. | ℂ floor | `Euler-Factor-Chain.md`, `lab_notebook_2.md` |
| `C2_ceiling_attained` | C2's upper bound is ATTAINED. | ℂ floor | `Euler-Factor-Chain.md`, `lab_notebook_2.md` |
| `ceiling_base` | D4. | ℂ floor | `Euler-Factor-Chain.md`, `lab_notebook_2.md` |
| `ceiling_dominates_floor` | D3. | ℂ floor | `Euler-Factor-Chain.md`, `The-Deep-Ladder.md`, `lab_notebook_2.md` |
| `joint_gain_periodic_of_commensurate` | The collapse. | ℂ floor | `lab_notebook_2.md` |
| `second_ladder_winds_densely` | The torus. | ℂ floor | `lab_notebook_2.md` |

## Construction (6)

| theorem | claim | axioms | cited by |
|---|---|---|---|
| `tableFrom_isTableOf` | `tableFrom` satisfies its own recurrence. | **none** | support |
| `unique_of_isTableOf` | Uniqueness. | **none** | `Formalization.md`, `README.md`, `The-Four-Zeros.md` |
| `eq_of_same_row` | Two tables over the same row agree everywhere. | **none** | `Formalization.md`, `The-Four-Zeros.md` |
| `zero_determined_by_row` | A zero is determined by the row. | propext | `Formalization.md`, `lab_notebook_2.md` |
| `tableFrom_add` | Differencing is linear, at every depth. | propext | `lab_notebook_2.md` |
| `tableFrom_smul` | Scalars pass through the table: the table of `c·N` is `c` times the table of `N`. | propext | `lab_notebook_2.md` |

## Covering (6)

| theorem | claim | axioms | cited by |
|---|---|---|---|
| `exists_near_lattice` | The covering lemma. | ℂ floor | `Formalization.md` |
| `covered_of_half_spacing` | Vacuity. | ℂ floor | `Formalization.md`, `lab_notebook_2.md` |
| `covered_smul` | Selectivity is a ratio. | ℂ floor | support |
| `covering_not_monotone` | Non-monotone by construction. | ℂ floor | `Formalization.md` |
| `bench_is_selective` | The bench sits BELOW the vacuity threshold, so the form genuinely selects. | ℂ floor | record |
| `bench_selects` | And it does select: 25 of 36, not all. | ℂ floor | record |

## Crossover (6)

| theorem | claim | axioms | cited by |
|---|---|---|---|
| `ratio_strictMono` | With distinct ratios `x < y`, the dominance ratio is strictly increasing — the `y`-family gains on the `x`-family monotonically, at every index. | ℂ floor | `Formalization.md`, `lab_notebook_2.md` |
| `at_most_one_crossover` | At most one crossover. | ℂ floor | `Formalization.md`, `lab_notebook_2.md` |
| `dominance_flips` | Before the crossover the `x`-family leads; after it, the `y`-family. | ℂ floor | support |
| `no_crossover_of_single` | A single family has no crossover. | ℂ floor | support |
| `count_does_not_determine_spread` | The coefficient-count account fails. | ℂ floor | `Formalization.md` |
| `spread_is_non_monotone` | The spread is non-monotone. | ℂ floor | record |

## Elephant (29)

| theorem | claim | axioms | cited by |
|---|---|---|---|
| `symbol_of_difference` | The symbol is the difference operator. | ℂ floor | `lab_notebook_2.md` |
| `sym_pow_expand` | The stencil is the symbol, expanded. | ℂ floor | `lab_notebook_2.md` |
| `cpow_neg_pow` | Each term sits at a power of the base. | ℂ floor | `lab_notebook_2.md` |
| `norm_cpow_neg` | The modulus of `b ^ (-s)` is `b ^ (-s.re)`. | ℂ floor | **UNTAGGED** |
| `norm_sym_band` | The band. | ℂ floor | `lab_notebook_2.md` |
| `norm_sym_imaginary` | The gain. | ℂ floor | `lab_notebook_2.md` |
| `sym_eq_zero_iff` | The lattice. | ℂ floor | **UNTAGGED** |
| `lattice_step` | The step. | ℂ floor | `lab_notebook_2.md` |
| `sym_tprod_eq_zeta` | The definition is not an analogy. | ℂ floor | `lab_notebook_2.md` |
| `primeTable_eq_stencil` |  | ℂ floor | **UNTAGGED** |
| `sym_ne_zero_on_critical_line` | The filter and ζ's nontrivial zeros never collide. | ℂ floor | **UNTAGGED** |
| `zeta_zero_weight_band` | The band, at a zeta zero on the critical line, to every depth. | ℂ floor | **UNTAGGED** |
| `bdiff_mode` | One difference multiplies a mode by `Sym`. | ℂ floor | **UNTAGGED** |
| `bdiff_iter_mode` | Depth. | ℂ floor | `lab_notebook_2.md` |
| `bdiff_iter_modeSum` | The same for a finite superposition of modes. | ℂ floor | **UNTAGGED** |
| `primeTable_eq_sym_weighted` | The join. | ℂ floor | **UNTAGGED** |
| `logDeriv_zeta_coeffs` | The Dirichlet coefficients of `-ζ'/ζ` are von Mangoldt. | ℂ floor | **UNTAGGED** |
| `filter_couples_iff_isPrimePow` | The base law. | ℂ floor | `lab_notebook_2.md` |
| `coupling_coeff` | The base law with its magnitude, proved. | ℂ floor | `lab_notebook_2.md` |
| `natCast_mul_cpow` | New lemma. | ℂ floor | `lab_notebook_2.md` |
| `cpow_neg_mul_lseries` | Multiplying by `b^(-s)` shifts an L-series' coefficients up the `b`-ladder. | ℂ floor | `lab_notebook_2.md` |
| `sym_mul_lseries` | The central sentence. | ℂ floor | `lab_notebook_2.md` |
| `sym_mul_logDeriv_zeta` | On ζ. | ℂ floor | `lab_notebook_2.md` |
| `sum_primeIndicator` | Its partial sums ARE `Nat.primeCounting`. | ℂ floor | **UNTAGGED** |
| `sum_shift` | New lemma. | ℂ floor | `lab_notebook_2.md` |
| `summatory_sym` | The summatory reading of `Sym`. | ℂ floor | **UNTAGGED** |
| `primeCount_backward_diff` | For π. | ℂ floor | `lab_notebook_2.md` |
| `zeta_ne_zero_of_re_eq_zero` | ζ has no zeros on the imaginary axis. | ℂ floor | `lab_notebook_2.md` |
| `filter_ne_zero_at_zeta_zero` | The step. | ℂ floor | `lab_notebook_2.md` |

## EulerFactorChain (16)

| theorem | claim | axioms | cited by |
|---|---|---|---|
| `symbol_of_backward_difference` | A1. | ℂ floor | `Euler-Factor-Chain.md`, `lab_notebook_2.md` |
| `diagonal_gain` | The diagonal gain. | ℂ floor | `lab_notebook_2.md` |
| `diagonal_cell` | The cell value along a diagonal in closed form: with `r = d + c`, the mode's `b^(rρ)·(sym b ρ)^d` collapses to `b^(cρ)·(b^ρ − 1)^d`. | ℂ floor | `lab_notebook_2.md` |
| `diagonal_over_column` | dia/col = `b^ρ`. | ℂ floor | `lab_notebook_2.md` |
| `diagonal_over_column_at_half` | At `ρ = 1/2` that ratio is `√b`. | ℂ floor | `lab_notebook_2.md` |
| `symbol_at_one` | A1 at `ρ = 1`. | ℂ floor | `lab_notebook_2.md` |
| `euler_product_riemannZeta` | A2. | ℂ floor | `Euler-Factor-Chain.md`, `The-Deep-Ladder.md` |
| `sym_natCast` | The chain's `sym` at a natural-number base, written the way the Euler product writes its factors. | ℂ floor | `lab_notebook_2.md` |
| `euler_product_sym` | A3, the single-base reading with the `b` index retained. | ℂ floor | `Euler-Factor-Chain.md` |
| `h_functional_equation` | B2a. | ℂ floor | `Euler-Factor-Chain.md`, `lab_notebook_2.md` |
| `h_zero` | B2b. | ℂ floor | `Euler-Factor-Chain.md`, `lab_notebook_2.md` |
| `h_one` | B2b. | ℂ floor | `Euler-Factor-Chain.md` |
| `conj_factor_on_critical_line` | On the critical line the second factor is the conjugate of the first. | ℂ floor | support |
| `h_eq_gain_pow_on_critical_line` | B4. | ℂ floor | `Euler-Factor-Chain.md` |
| `cpow_rect_on_critical_line` | Rectangular form of the Euler factor's reciprocal on the critical line. | ℂ floor | support |
| `gain_sq_on_critical_line` | C1. | ℂ floor | `Euler-Factor-Chain.md`, `lab_notebook_2.md` |

## Expansion (17)

| theorem | claim | axioms | cited by |
|---|---|---|---|
| `exp_eq_rpow` | `e^((log 2)·x) = 2^x`. | ℂ floor | support |
| `F_zero` | `F 0` is the function itself. | ℂ floor | support |
| `c_rec` | The coefficient recurrence — Pascal with the factorial absorbed; the `j = 0` edge dies against the `−j` factor. | ℂ floor | support |
| `hasDerivAt_S` | `S` differentiates term-by-term into the pre-recombination sum. | ℂ floor | `lab_notebook_2.md` |
| `hasDerivAt_F` | The expansion advances: `F d` has derivative `F (d+1)` at `x ≠ 0`. | ℂ floor | support |
| `iteratedDeriv_f2x` | `iteratedDeriv d` of `2^x/x` IS `F d`, on `(0,∞)`. | ℂ floor | `NOTEPAD.md`, `The-Four-Zeros.md`, `lab_notebook_2.md` |
| `t_nonneg` | Every unsigned term is nonnegative on `x > 0`. | ℂ floor | support |
| `S_eq_alt` | `S` is the alternating sum of the unsigned terms. | ℂ floor | support |
| `choose_factorial_step` | The choose-ratio identity, in ℕ where it is clean: `C(d,j+1)·(j+1)! | propext | `lab_notebook_2.md` |
| `t_halves` | The terms halve in the wedge `2d ≤ (log 2)·x`: `t (j+1) ≤ t j / 2`. | ℂ floor | `The-Four-Zeros.md`, `lab_notebook_2.md` |
| `B_peel` | Peeling the head of the tail: `B k = t k − B (k+1)` for `k ≤ d`. | ℂ floor | `lab_notebook_2.md` |
| `B_bounds` | The tail bound `0 ≤ B k ≤ t k`, by downward induction on the tail length, using only that the terms halve. | ℂ floor | `lab_notebook_2.md` |
| `t_zero` | The leading term: `t 0 = (log 2)^d / x`. | ℂ floor | support |
| `S_floor` | The floor on `S`: in the wedge, `S d x ≥ t₀/2 = (log 2)^d/(2x)`. | ℂ floor | `lab_notebook_2.md` |
| `F_floor` | The full floor on the closed form: `F d x ≥ (1/2)·2^x·(log 2)^d/x`. | ℂ floor | `NOTEPAD.md`, `The-Four-Zeros.md`, `lab_notebook_2.md` |
| `hD_of_window` | `hD` discharged. | ℂ floor | `The-Four-Zeros.md`, `lab_notebook_2.md` |
| `tableFrom_ne_zero_of_li` | O67's conditional theorem, with the analysis discharged. | ℂ floor | `NOTEPAD.md`, `The-Four-Zeros.md`, `lab_notebook_2.md` |

## GeneratorPeak (6)

| theorem | claim | axioms | cited by |
|---|---|---|---|
| `score_eq` | The two terms are not independent. | ℂ floor | support |
| `strictMono_of_lt` | If resolution outweighs per-block signal, the score strictly increases with the generator count — more generators is always better, so no interior pea | ℂ floor | support |
| `strictAnti_of_lt` | If per-block signal outweighs resolution, the score strictly decreases — fewer generators is always better, so again no interior peak. | ℂ floor | support |
| `const_of_eq` | If the exponents match, the score does not depend on the generator count. | ℂ floor | support |
| `no_interior_peak` | No power-law tradeoff of this form has an interior peak. | ℂ floor | `CONTEXT.md`, `Formalization.md`, `README.md` +1 |
| `measured_has_interior_peak` | The measurement is not monotone: G4 exceeds both G3 and G5. | ℂ floor | record |

## Isogeny (9)

| theorem | claim | axioms | cited by |
|---|---|---|---|
| `rowOf_eq_rowN` | The bridge: composing `P` with `b^·` turns one into the other. | propext | `lab_notebook_2.md` |
| `telescope` | Telescoping over `Finset.range`. | ℂ floor | support |
| `rowN_eq_blockSum` | The isogeny on the row. | ℂ floor | `CONTEXT.md`, `Commensurate-Ladders.md`, `NOTEPAD.md` +1 |
| `row_two_eq_pair` | Base 4's row is base 2's row summed in pairs. | propext, Quot.sound | `lab_notebook_2.md` |
| `row_three_eq_triple` | Base 8's row is base 2's row summed in triples. | propext, Quot.sound | `lab_notebook_2.md` |
| `rowN_comp` | Decimation composes. | propext | `lab_notebook_2.md` |
| `dyadicRow_eq_rowN` | The weld to the measured row. | propext, Quot.sound | `lab_notebook_2.md` |
| `measured_row_four` | The measured base-4 row, from the 21 pinned values and nothing else. | **none** | `lab_notebook_2.md` |
| `measured_row_eight` | The measured base-8 row, same 21 values read at decimation 3. | **none** | `lab_notebook_2.md` |

## JointLadder (14)

| theorem | claim | axioms | cited by |
|---|---|---|---|
| `two_pow_ne_three_pow` | Parity kills it. | ℂ floor | **UNTAGGED** |
| `nat_log_indep` | The same, over `ℕ` and in logarithmic form: `a·log 2 = b·log 3` forces `a = b = 0`. | — | **UNTAGGED** |
| `log_indep` | `log 2` and `log 3` are independent over `ℤ`. | ℂ floor | **UNTAGGED** |
| `irrational_log_two_div_log_three` | `log 2 / log 3` is irrational. | ℂ floor | **UNTAGGED** |
| `triadic_winds_densely_on_dyadic` | The triadic ladder winds densely on the dyadic circle. | ℂ floor | **UNTAGGED** |
| `offset_of_aliases` | Reading the aliasing relation at a single rung: the phase offset is an integer multiple of `2π`. | — | **UNTAGGED** |
| `jointAliases_iff_eq` | THE JOINT NO-GO, in reverse. | ℂ floor | **UNTAGGED** |
| `exists_dyadic_alias_ne` | Every frequency has a dyadic alias distinct from it — the single ladder's obstruction, restated from `Nyquist.aliases_of_offset`. | — | **UNTAGGED** |
| `dyadic_alias_resolved_jointly` | THE CONTRAST, AS ONE STATEMENT. | ℂ floor | **UNTAGGED** |
| `d2_d3_comm` | The two directions commute, so `Δ₂^a Δ₃^b` is well defined regardless of the order the differences are taken in. | — | **UNTAGGED** |
| `d2_jmode` | The dyadic direction carries the Euler factor at 2. | ℂ floor | **UNTAGGED** |
| `d3_jmode` | The triadic direction carries the Euler factor at 3. | ℂ floor | **UNTAGGED** |
| `d2_iter_jmode` | Iterating the dyadic direction. | ℂ floor | **UNTAGGED** |
| `d3_iter_jmode` | Iterating the triadic direction. | ℂ floor | **UNTAGGED** |

## MainTerm (10)

| theorem | claim | axioms | cited by |
|---|---|---|---|
| `iter_bdiffR_eq_fwdDiff` | The ℝ-domain twin of `Nonvanishing.iter_bdiffZ_eq_fwdDiff`. | ℂ floor | support |
| `iter_bdiffR_eq_sum` | `n` unit differences are the stencil, on the real line. | ℂ floor | `lab_notebook_2.md` |
| `stencilR_eq_iter` | The bridge to `Nonvanishing.stencilR`. | ℂ floor | `lab_notebook_2.md` |
| `deriv_bdiffR` | Δ commutes with d/dx. | ℂ floor | `lab_notebook_2.md` |
| `contDiff_bdiffR` | Δ preserves smoothness. | ℂ floor | support |
| `iteratedDeriv_bdiffR` | Δ commutes with iterated derivatives. | ℂ floor | `lab_notebook_2.md` |
| `bdiffR_lb` | The single step: derivative floor ⟹ difference floor. | ℂ floor | `NOTEPAD.md`, `The-Four-Zeros.md`, `lab_notebook_2.md` |
| `iter_bdiffR_lb` | The induction: MVT retired. | ℂ floor | `NOTEPAD.md`, `The-Four-Zeros.md`, `lab_notebook_2.md` |
| `stencilR_ge_of` | The floor, on the stencil. | ℂ floor | `lab_notebook_2.md` |
| `tableFrom_ne_zero_of_deriv` | The arrow, with hM discharged into a derivative bound. | ℂ floor | `NOTEPAD.md`, `The-Four-Zeros.md`, `lab_notebook_2.md` |

## Measured (7)

| theorem | claim | axioms | cited by |
|---|---|---|---|
| `agreement_offsets_match` | The one numeric relation that carries an inference. | ℂ floor | record |
| `agreement_radius_smooth` | The smooth control sits above `b^(-1) = 0.5` by the measured offset. | ℂ floor | record |
| `agreement_rank_11a1` | Ranks 0 and 2 land inside 0.05. | ℂ floor | record |
| `agreement_rank_389a1` | Rank 2 lands inside 0.01 — the tightest of the three curves. | ℂ floor | record |
| `agreement_rank_37a1` | Rank 1 needs a tolerance of 0.3. | ℂ floor | record |
| `agreement_elliptic` | Agreement at machine epsilon: the deviation is one ulp of a float64. | ℂ floor | record |
| `agreement_weil_balance` | The two sides agree to 5.7e-7 relative. | ℂ floor | record |

## Nonvanishing (8)

| theorem | claim | axioms | cited by |
|---|---|---|---|
| `iter_bdiffZ_eq_fwdDiff` | Backward differencing is `(−1)·fwdDiff` at step `−1` — the ℝ copy of `Zeros.tableFrom_eq_fwdDiff`'s bridge. | ℂ floor | support |
| `iter_bdiffZ_eq_stencilR` | `n` differences are the stencil. | ℂ floor | `lab_notebook_2.md` |
| `stencilR_row` | The Pascal step. | ℂ floor | `lab_notebook_2.md` |
| `stencilR_sub` | Linearity. | ℂ floor | `lab_notebook_2.md` |
| `window_term_le` | Each windowed Schoenfeld bound is at most the top-of-window bound times `2^(−k/2)`: `(r−k) ≤ r` handles the linear factor and `rpow_add` splits the po | ℂ floor | `lab_notebook_2.md` |
| `error_bound` | The error bound. | ℂ floor | `The-Four-Zeros.md`, `lab_notebook_2.md` |
| `nonvanishing_of` | The arrow. | ℂ floor | `The-Four-Zeros.md`, `lab_notebook_2.md` |
| `tableFrom_ne_zero_of` | Onto the integer table. | ℂ floor | `The-Four-Zeros.md`, `lab_notebook_2.md` |

## Nyquist (5)

| theorem | claim | axioms | cited by |
|---|---|---|---|
| `aliases_of_offset` | The aliasing offset. | ℂ floor | `NOTEPAD.md`, `lab_notebook_2.md` |
| `nyquist_no_go` | THE NO-GO. | ℂ floor | `NOTEPAD.md`, `lab_notebook_2.md` |
| `base_bound_of_resolvable` | Entry 26's inequality, as the contrapositive. | ℂ floor | `lab_notebook_2.md` |
| `base_two_past_nyquist` | Base 2 is past its own Nyquist frequency at every `γ ≥ 14`, and `γ₁ = 14.134…` is such a `γ`. | ℂ floor | `lab_notebook_2.md` |
| `base_two_fails_by_three` | Entry 26's "fails by a factor of three", proved. | ℂ floor | `NOTEPAD.md`, `lab_notebook_2.md` |

## NyquistPeak (20)

| theorem | claim | axioms | cited by |
|---|---|---|---|
| `sym_on_imaginary_axis` | The symbol on the imaginary axis is `1 − e^(−iθ)` with `θ = γ log b`. | ℂ floor | support |
| `norm_sym_on_imaginary_axis` | The prereg's formula, derived. | ℂ floor | `lab_notebook_2.md` |
| `gain_eq_norm_sym_pow` | The depth-`d` gain is the symbol's modulus to the `d`. | ℂ floor | `lab_notebook_2.md` |
| `gain_pi` | The gain at phase `π` is `2^d` — the ceiling of the band. | ℂ floor | support |
| `gain_zero_phase` | The gain at phase `0` is `0` at every positive depth: the smooth term, having `γ = 0`, is annihilated outright. | ℂ floor | support |
| `gain_hasDerivAt_pi` | HALF ONE — the derivative vanishes at `θ = π`. | ℂ floor | `lab_notebook_2.md` |
| `deriv_gain_pi` | The same, in `deriv` form. | ℂ floor | support |
| `gain_le_gain_pi` | HALF TWO — `π` is a maximum. | ℂ floor | `lab_notebook_2.md` |
| `gain_lt_gain_pi` | The maximum is STRICT. | ℂ floor | `lab_notebook_2.md` |
| `depth_zero_vacuous` | The degeneracy the depth hypothesis closes. | ℂ floor | `lab_notebook_2.md` |
| `stationary_maximum` | § 5.1 in phase coordinates, as one object. | ℂ floor | record |
| `boundaryBase_pos` | The boundary base is positive. | ℂ floor | support |
| `one_lt_boundaryBase` | At a positive frequency the boundary base exceeds `1`, so it lies in the range `Nyquist.base_bound_of_resolvable` speaks about. | ℂ floor | support |
| `phase_at_boundaryBase` | The boundary base puts the phase exactly at `π`. | ℂ floor | support |
| `nyquist_boundaryBase` | `b*` is exactly the base whose Nyquist frequency is `γ`. | ℂ floor | `NOTEPAD.md`, `lab_notebook_2.md` |
| `norm_sym_pow_at_boundaryBase` | The gain at `b*` is the ceiling `2^d`, and it is the symbol's own modulus that reaches it. | ℂ floor | support |
| `gain_stationary_in_base` | HALF ONE, in the scanned coordinate. | ℂ floor | `lab_notebook_2.md` |
| `gain_continuousAt_boundaryBase` | Not a discontinuity. | ℂ floor | `lab_notebook_2.md` |
| `gain_le_at_boundaryBase` | HALF TWO, in the scanned coordinate. | ℂ floor | record |
| `boundary_is_smooth_stationary_maximum` | § 5.1, as the prereg states it. | ℂ floor | `lab_notebook_2.md` |

## PairIdentity (13)

| theorem | claim | axioms | cited by |
|---|---|---|---|
| `backward_difference_pow` | The same step inside ℤ, where the table lives: `(1 − b⁻¹)·b^(r) = (b−1)·b^(r−1)`. | propext | `lab_notebook_2.md` |
| `tableFrom_of_geometric` | The collapse. | propext, Quot.sound | `lab_notebook_2.md` |
| `tableFrom_add_window` | Linearity, localised. | propext | `lab_notebook_2.md` |
| `pair_identity` | I1, the pair identity. | propext, Quot.sound | `CONTEXT.md`, `NOTEPAD.md`, `README.md` +4 |
| `composite_of_prime_zero` | I5, the pole. | propext, Quot.sound | `lab_notebook_2.md` |
| `coeff_eq_one_iff_base_two` | The corollary. | propext, Quot.sound | `lab_notebook_2.md` |
| `total_eq_pow_iff_base_two` | The corollary, in the identity's own terms. | propext, Quot.sound | `lab_notebook_2.md` |
| `base_three_carries_factor` | Base three does carry the factor: the total at `(r,d)` is `2^(d+1)·3^(r−1−d)`, never a bare power of three. | **none** | `lab_notebook_2.md` |
| `base_four_carries_factor` | Base four likewise: `3^(d+1)·4^(r−1−d)`. | **none** | `lab_notebook_2.md` |
| `exponent_const_on_diagonal` | Along a diagonal the pair identity's exponent is fixed. | propext, Quot.sound | `lab_notebook_2.md` |
| `total_const_on_diagonal` | The diagonal is the trend's own level set, and only at `b = 2`. | propext, Quot.sound | `lab_notebook_2.md` |
| `measured_composite_matches_pair_identity` | The falsifier. | **none** | `lab_notebook_2.md` |
| `composite_at_zero_20_6` | The deep zero, stated through the identity rather than through arithmetic. | propext, Quot.sound | `lab_notebook_2.md` |

## Propagation (9)

| theorem | claim | axioms | cited by |
|---|---|---|---|
| `pasc_zero` | The left edge of the triangle is all ones. | **none** | `lab_notebook_2.md` |
| `pasc_succ` | Pascal's identity — definitional, because `pasc` is defined by it. | **none** | `lab_notebook_2.md` |
| `pasc_eq_zero` | Above the diagonal the binomial vanishes. | **none** | `lab_notebook_2.md` |
| `pasc_pos` | On and below the diagonal it is positive — this is what "no lacunae" rests on: the propagator never vanishes inside its cone. | propext, Quot.sound | `lab_notebook_2.md` |
| `outside_cone_zero` | Outside the forward cone, nothing. | propext, Quot.sound | `NOTEPAD.md`, `lab_notebook_2.md` |
| `propagator` | Inside the cone, the propagator. | propext, Quot.sound | `NOTEPAD.md`, `lab_notebook_2.md` |
| `neg_one_pow` | `(−1)^m` is `1` or `−1`. | propext | `lab_notebook_2.md` |
| `cone_filled` | No lacunae. | propext, Quot.sound | `NOTEPAD.md`, `lab_notebook_2.md` |
| `flux_form` | The flux form. | propext, Quot.sound | `lab_notebook_2.md` |

## Schoenfeld (2)

| theorem | claim | axioms | cited by |
|---|---|---|---|
| `window_of_global` | The bridge: the global sentence implies the bench-shaped window hypothesis whenever the window bottom clears `12`, since `2^12 = 4096 ≥ 2657`. | ℂ floor | `NOTEPAD.md`, `The-Four-Zeros.md`, `lab_notebook_2.md` |
| `tableFrom_ne_zero_of_schoenfeld` | The arrow, with the literature sentence as its one analytic input. | ℂ floor | `CONTEXT.md`, `NOTEPAD.md`, `The-Four-Zeros.md` +1 |

## SeedPerturbation (20)

| theorem | claim | axioms | cited by |
|---|---|---|---|
| `tableFrom_zero` | The zero row builds the zero table. | **none** | `lab_notebook_2.md` |
| `tableFrom_sub` | Linearity, in the form the convention change needs. | propext, Quot.sound | support |
| `tableFrom_eq_zero_of_vanishing_above` | The excess table vanishes past the excess. | propext | `lab_notebook_2.md` |
| `cell_eq_of_seed_perturbation` | The claim. | propext, Quot.sound | `The-Composite-Arm.md`, `lab_notebook_2.md` |
| `zero_stable_of_seed_perturbation` | The corollary. | propext, Quot.sound | support |
| `zero_iff_of_seed_perturbation` | The same statement as an equivalence, which is the honest form: past the excess, the two conventions have the same zero set. | propext, Quot.sound | support |
| `tableFrom_at_boundary` | The boundary cell, exactly. | propext, Quot.sound | `The-Fold.md` |
| `boundary_can_move` | `r − d > R` cannot be relaxed to `r − d ≥ R`. | propext, Quot.sound | `lab_notebook_2.md` |
| `cell_ne_at_boundary` | The same fact said about the two conventions rather than about `e`: at the boundary the cell genuinely differs. | propext, Quot.sound | support |
| `window_bottoms_correct` | The window bottoms `r − d` of the four zeros are `1, 3, 5, 14`, computed rather than transcribed. | **none** | record |
| `protected_at_R_two` | Which zeros the theorem protects when 2 and 3 are the excluded primes. | **none** | record |
| `protected_at_R_three` | And when the excess reaches rung 3 — which `silence46` does, since 6 sits in `(4,8]`. | **none** | record |
| `silence46_vanishes_above_three` | The `silence46` excess is confined to rungs 2 and 3 — the hypothesis `cell_eq_of_seed_perturbation` needs, at `R_e = 3`. | propext, Quot.sound | record |
| `silence46_alive_at_three` | And rung 3 genuinely carries excess, so `boundary_can_move` has its `e R ≠ 0`. | **none** | record |
| `measured_silence46_matches_shift` | The falsifier. | **none** | record |
| `silence46_deep_cells_fixed` | The two deep cells are protected by the theorem, not by arithmetic luck: `8 − 3 = 5 > 3` and `20 − 6 = 14 > 3`, so `cell_eq_of_seed_perturbation` appl | propext, Quot.sound | record |
| `silence46_cell_4_1_moves` | And `(4,1)` is not protected, for the reason the theorem gives rather than by inspection: `4 − 1 = 3 = R_e`, so `boundary_can_move` fires. | propext, Quot.sound | record |
| `emptied_vanishes_above_two` | The emptied variant's excess is confined to rungs 1 and 2 — `R_e = 2`, the same profile as excluding the primes 2 and 3. | propext, Quot.sound | record |
| `measured_emptied_matches_shift` | The second falsifier, at `R_e = 2`. | **none** | record |
| `emptied_protected_cells_fixed` | The three protected cells, again by theorem rather than by computation: `4 − 1 = 3 > 2`, `8 − 3 = 5 > 2`, `20 − 6 = 14 > 2`. | propext, Quot.sound | record |

## Superposition (4)

| theorem | claim | axioms | cited by |
|---|---|---|---|
| `bdiff_sum` | `bdiff` distributes over a finite sum. | ℂ floor | `lab_notebook_2.md` |
| `A4_sum_of_A1` | The licence. | ℂ floor | support |
| `depth_reweights_each_mode` | Corollary — the falsifiable form. | ℂ floor | `lab_notebook_2.md` |
| `tableFrom_eq_modeSum_reweighted` | The table is a superposition, reweighted by depth. | ℂ floor | `CONTEXT.md`, `NOTEPAD.md`, `lab_notebook_2.md` |

## TransferOp (7)

| theorem | claim | axioms | cited by |
|---|---|---|---|
| `bdiffL_apply` | The packaging is definitional: applying the endomorphism is applying `bdiff`. | ℂ floor | `lab_notebook_2.md` |
| `mode_ne_zero'` | A mode never vanishes: `b^(rρ) ≠ 0` for `b ≠ 0`. | ℂ floor | support |
| `mode_ne_zero` | Hence a mode is not the zero function. | ℂ floor | `lab_notebook_2.md` |
| `mode_hasEigenvector` | The mode is an eigenvector, in Mathlib's sense. | ℂ floor | `lab_notebook_2.md` |
| `sym_hasEigenvalue` | `Sym b ρ` is in the point spectrum. | ℂ floor | `lab_notebook_2.md` |
| `mode_pow` | Depth is the operator power on the eigenline. | ℂ floor | `lab_notebook_2.md` |
| `eigenvalue_zero_iff_lattice` | The kernel eigenvalue sits exactly on the pole lattice. | ℂ floor | `lab_notebook_2.md` |

## Transform (39)

| theorem | claim | axioms | cited by |
|---|---|---|---|
| `norm_zmap` | The map. | ℂ floor | `NOTEPAD.md`, `lab_notebook_2.md` |
| `norm_zmap_critical` | The critical line lands on the circle of radius `b^(−1/2)`. | ℂ floor | `Euler-Factor-Chain.md`, `lab_notebook_2.md` |
| `zmap_shift` | The deck transformation. | ℂ floor | `Euler-Factor-Chain.md`, `lab_notebook_2.md` |
| `zmap_period` | The other generator. | ℂ floor | `Euler-Factor-Chain.md`, `lab_notebook_2.md` |
| `zmap_functional_equation` | The functional equation, in `z`. | ℂ floor | `Euler-Factor-Chain.md`, `NOTEPAD.md`, `lab_notebook_2.md` |
| `annulus_modulus` | G7's modulus. | ℂ floor | `Euler-Factor-Chain.md`, `lab_notebook_2.md` |
| `zmap_period_tau` | `τ` is exactly the period `zmap_period` uses. | ℂ floor | `NOTEPAD.md`, `lab_notebook_2.md` |
| `tau_pow` | The power chain. | ℂ floor | `lab_notebook_2.md` |
| `tau_ratio_of_meet` | Meeting ladders have rationally related `τ`, and the ratio is the meeting exponents. | ℂ floor | `lab_notebook_2.md` |
| `one_mem_periodLattice` | The deck generator `1` is in the lattice. | ℂ floor | support |
| `tauI_mem_periodLattice` | The period generator `τ(b)·i` is in the lattice. | ℂ floor | support |
| `tau_pos` | `τ(b) > 0` for `b > 1`, which is what makes the second generator nonzero. | ℂ floor | support |
| `generators_indep` | The lattice has rank 2. | ℂ floor | `Euler-Factor-Chain.md`, `lab_notebook_2.md` |
| `gens_linearIndependent` | `generators_indep` in the form Mathlib's basis constructor wants. | ℂ floor | `lab_notebook_2.md` |
| `periodLattice_eq_span` | The additive closure of the two generators is the ℤ-span of the basis — the bridge from `AddSubgroup.closure` to the `ZLattice` instance that `periodL | ℂ floor | `lab_notebook_2.md` |
| `periodLattice_discrete` | The lattice is discrete. | ℂ floor | `CONTEXT.md`, `lab_notebook_2.md` |
| `torus_shift` | The deck transformation is an identity in the torus. | ℂ floor | `Euler-Factor-Chain.md`, `lab_notebook_2.md` |
| `torus_period` | The period is an identity in the torus. | ℂ floor | `Euler-Factor-Chain.md`, `lab_notebook_2.md` |
| `zmap_period_zsmul` | The `z`-map descends past the whole pole lattice, not just one period. | ℂ floor | `lab_notebook_2.md` |
| `zmap_shift_modulus` | The deck transformation scales the modulus by `b^(−n)`. | ℂ floor | `Euler-Factor-Chain.md`, `lab_notebook_2.md` |
| `inversion_fixes_circle` | The functional equation is inversion in the critical circle, as a theorem. | ℂ floor | `NOTEPAD.md`, `lab_notebook_2.md` |
| `rpow_left_inj` | For `b > 1` the real power is injective in the exponent. | ℂ floor | `NOTEPAD.md`, `lab_notebook_2.md` |
| `zmap_ne_zero` | The image of `s` under the `z`-map is never zero. | ℂ floor | `lab_notebook_2.md` |
| `on_critical_line_iff_norm` | The critical line is exactly the fixed circle. | ℂ floor | `NOTEPAD.md`, `lab_notebook_2.md` |
| `on_critical_line_iff_inversion_fixed` | RH's condition, as a fixed point of the inversion. | ℂ floor | `lab_notebook_2.md` |
| `riemannHypothesis_iff_zeros_inversion_fixed` | The Riemann hypothesis, restated on the torus. | ℂ floor | `NOTEPAD.md`, `lab_notebook_2.md` |
| `norm_zmap_zero_line` | `Re s = 0` lands on the unit circle. | ℂ floor | `lab_notebook_2.md` |
| `strip_is_fundamental_domain` | The critical strip is one fundamental domain of `ℂ*/b^ℤ`. | ℂ floor | `NOTEPAD.md`, `lab_notebook_2.md` |
| `zeros_re_lt_one` | Every zero of ζ has `Re s < 1`, from Mathlib's non-vanishing on the closed half-plane `1 ≤ Re s`. | ℂ floor | `lab_notebook_2.md` |
| `zeros_outside_inner_circle` | Every zero lies strictly outside the inner circle. | ℂ floor | `lab_notebook_2.md` |
| `zeros_re_pos` | Every nontrivial zero has `0 < Re s`. | ℂ floor | `lab_notebook_2.md` |
| `zeros_in_fundamental_annulus` | Every nontrivial zero lies in the open fundamental annulus. | ℂ floor | `NOTEPAD.md`, `README.md`, `lab_notebook_2.md` |
| `riemannHypothesis_iff_zeros_on_middle_circle` | RH, as a statement about one annulus. | ℂ floor | `NOTEPAD.md`, `lab_notebook_2.md` |
| `zmap_pair_product` | The pair identity. | ℂ floor | `NOTEPAD.md`, `lab_notebook_2.md` |
| `pair_collapses_iff_critical` | The pair collapses exactly on the critical line. | ℂ floor | `lab_notebook_2.md` |
| `riemannHypothesis_iff_pair_collapses` | RH: the pair collapses at every zero. | ℂ floor | `NOTEPAD.md`, `lab_notebook_2.md` |
| `sym_zero_on_outer_circle` | A zero of the table's symbol lands on `|z| = 1`. | ℂ floor | `lab_notebook_2.md` |
| `sym_zero_partner_on_inner_circle` | Its inversion partner lands on `|z| = b^(−1)`. | ℂ floor | `lab_notebook_2.md` |
| `critical_circle_is_lattice_inversion_mean` | The table's lattice, inverted, gives the critical circle. | ℂ floor | `NOTEPAD.md`, `README.md`, `lab_notebook_2.md` |

## TwinLattice (3)

| theorem | claim | axioms | cited by |
|---|---|---|---|
| `twin_lower_mod_six` | The lattice. | propext, Quot.sound | `CONTEXT.md`, `The-Twin-Lattice.md`, `lab_notebook_2.md` |
| `twin_pocket` | The pocket. | propext, Quot.sound | `The-Twin-Lattice.md`, `lab_notebook_2.md` |
| `three_five_exceptional` | `(3,5)` is the exception, exhibited rather than assumed. | ℂ floor | `The-Twin-Lattice.md`, `lab_notebook_2.md` |

## ZeroCells (7)

| theorem | claim | axioms | cited by |
|---|---|---|---|
| `construction_eq` | The construction module's list is the computed one. | **none** | record |
| `seedPerturbation_eq` | The seed-perturbation module's list is the computed one. | **none** | `lab_notebook_2.md` |
| `pairIdentity_eq` | The pair-identity module's list is the computed one. | **none** | record |
| `construction_all_vanish` | Every cell `Construction.measured_zeros` names vanishes — now derived, not transcribed. | **none** | record |
| `seedPerturbation_all_vanish` | Every cell `SeedPerturbation.zero_cells` names vanishes. | **none** | record |
| `pairIdentity_all_vanish` | Every cell `PairIdentity.zero_cells` names vanishes. | **none** | record |
| `all_four_have_length_four` | All four names, one length. | **none** | record |

## Zeros (15)

| theorem | claim | axioms | cited by |
|---|---|---|---|
| `tableFrom_isTable` | The bench's table is one. | **none** | support |
| `zero_iff_repeat` | A zero is exactly a repeat one depth up. | propext | `FORMAT.md`, `Formalization.md`, `NOTEPAD.md` +5 |
| `neg_below_zero` | A zero puts its left neighbour, negated, directly beneath it. | propext | `lab_notebook_2.md` |
| `pair_shares_diagonal` | And those two cells share a diagonal. | propext, Quot.sound | `lab_notebook_2.md` |
| `window_shared_of_composite_exponent` | The (8,3) window is shared. | **none** | `lab_notebook_2.md` |
| `zero_2_1` | `(2,1)` vanishes: `1·1 − 1·1 = 0`, computed by the kernel from `pi2`. | **none** | `lab_notebook_2.md` |
| `zero_4_1` | `(4,1)` vanishes: `1·2 − 1·2 = 0`. | **none** | `lab_notebook_2.md` |
| `zero_8_3` | `(8,3)` vanishes: `23 − 3·13 + 3·7 − 5 = 0`, four values of `π`. | **none** | `lab_notebook_2.md` |
| `zero_20_6` | `(20,6)` vanishes: the depth-6 stencil on seven values of `π`, spanning `2^13` to `2^20`. | **none** | `lab_notebook_2.md` |
| `measured_zeros_all_vanish` | The list's own claim, as a theorem. | **none** | `CONTEXT.md`, `README.md`, `The-Four-Zeros.md` +1 |
| `nonzero_7_3` | A non-zero neighbour, so the check can fail. | **none** | `lab_notebook_2.md` |
| `nonzero_19_6` | The `+343` of `papers/The-Fold.md` § C3, the partner of the `−343` that a zero at `(20,6)` forces onto `(20,7)`. | **none** | `lab_notebook_2.md` |
| `four_zeros_only` | Four zeros in 1953 cells. | **none** | support |
| `zero_at_20_6_of_repeat` | The measured repeat gives the deep zero, through the theorem. | propext | `The-Four-Zeros.md`, `lab_notebook_2.md` |
| `zero_at_8_3_of_repeat` | The same for the other deep zero, where the repeated value is 4. | propext | `The-Four-Zeros.md`, `lab_notebook_2.md` |

## ZerosStencil (16)

| theorem | claim | axioms | cited by |
|---|---|---|---|
| `tableFrom_eq_fwdDiff` | The table's `d`-fold backward difference is `(-1)^d` times Mathlib's `d`-fold forward difference at step `-1`. | propext, Quot.sound | `lab_notebook_2.md` |
| `tableFrom_eq_stencil` | The operator IS Pascal. | ℂ floor | `README.md`, `The-Four-Zeros.md`, `lab_notebook_2.md` |
| `stencil_add` | The stencil is linear in the sampled values. | ℂ floor | `NOTEPAD.md`, `lab_notebook_2.md` |
| `stencil_smul` | And scalars pass through — linearity's other half, beside `stencil_add`. | ℂ floor | `lab_notebook_2.md` |
| `stencil_annihilates_const` | The stencil's positive and negative arms carry equal total weight. | ℂ floor | `lab_notebook_2.md` |
| `stencil_eq_wings` | The fold is an identity, not a test. | ℂ floor | `lab_notebook_2.md` |
| `stencil_eq_zero_iff_wings` | A zero is where the wings balance. | ℂ floor | `lab_notebook_2.md` |
| `tableFrom_eq_zero_iff_wings` | The cell, folded. | ℂ floor | `lab_notebook_2.md` |
| `repeat_iff_wings` | Two readings of one fact. | ℂ floor | `lab_notebook_2.md` |
| `stencil_weights_antisymm` | The stencil is antisymmetric when its order is odd. | ℂ floor | `lab_notebook_2.md` |
| `stencil_arms_eq` | The two arms weigh the same. | ℂ floor | `lab_notebook_2.md` |
| `stencil_arm_doubled` | And each arm is `2^(N-1)`. | ℂ floor | `lab_notebook_2.md` |
| `window_exclusive_of_prime_exponent` | The (20,6) window is base-2 exclusive. | ℂ floor | `Commensurate-Ladders.md`, `Formalization.md`, `The-Fold.md` +1 |
| `base_of_meets_two` | Only powers of two reach a dyadic window. | ℂ floor | `lab_notebook_2.md` |
| `factorization_proportional` | Two ladders that meet have proportional exponents. | ℂ floor | `lab_notebook_2.md` |
| `primeFactors_eq_of_meets` | And they are built from the same primes. | ℂ floor | `lab_notebook_2.md` |
