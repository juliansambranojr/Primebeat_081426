# Traps

Error pattern, cause, fix. One row per class. Appended after any build
that shows a class with no row (LOOP.md § 7). Rows 1–12 were paid for on
2026-09-06, units 0329–0335; rows 13–17 come from CLAUDE.md § Stage-3.

| # | pattern in the build output | cause | fix |
|---|---|---|---|
| 1 | `No goals to be solved` at a `ring` after `field_simp` or `simp` | the previous tactic closed the goal | delete the tactic, or `try ring` |
| 2 | `Unknown identifier X` where `X` lives in another `Stage3` namespace | namespace not opened | add it to `open` |
| 3 | `mod_cast has type ¬↑m.succ = 0 but is expected ¬False` | `exact_mod_cast` on a cast nonzero fact | `Nat.cast_add_one_ne_zero m` directly, no cast tactic |
| 4 | goals `instAddCommGroup = ...` after `convert h using 1` on a `HasDerivAt.mul` | `convert` diffed into the instances | `funext` the function equality, `rw` it, then `refine h.congr_deriv ?_` |
| 5 | `linear_combination` leaves a residual with the same monomials, opposite sign | `congr_deriv` states `h's derivative = target`; the hand computation used the other order | negate the coefficient |
| 6 | `ring failed` inside `linear_combination`, residual printed | wrong coefficient | the residual equals (coefficient error)×(hypothesis difference); solve for the coefficient from the printed terms |
| 7 | `rw [Nat.factorial_succ]` rewrites the wrong factorial | first match taken | give the argument: `Nat.factorial_succ (2 * m + 1)` |
| 8 | `fun_prop` says `No theorems found for X` on a new definition | `fun_prop` has no continuity lemma for the def | `attribute [fun_prop] continuous_X` after the lemma |
| 9 | `simp only [..., zero_pow (Nat.succ_ne_zero _)]` leaves `c ^ 2 * c ^ k` | `k + 2` did not unify with `succ _` | state `c_pow_one {n} (hn : n ≠ 0)` and pass `hk : k + 2 ≠ 0` |
| 10 | type mismatch `↑(Real.sinh s)` vs `Complex.sinh ↑s` | `← ofReal_sinh` rewritten by hand while `push_cast` normalizes the other way | drop the hand rewrite; let `push_cast` normalize both sides |
| 11 | `norm_num` turns an equation into `True ∨ x = 0` | it cancelled a common factor | prove the scalar identity as its own `have`, then `rw` |
| 12 | info `Try this: ring_nf` and the goal closed | `ring` fell back to `ring_nf` | write `ring_nf` |
| 13 | `set` bodies with `Nat.floor`, `Nat.log`, tsum defs explode defeq | `set` unfolds in the kernel check | prove the facts, then `clear_value`, or parameterize the def as an equation hypothesis |
| 14 | `linarith` drowns after a large hypothesis enters | default preprocessor | `linarith only [...]` or hint-fed `nlinarith [...]` |
| 15 | `rw [hdef]` fails on a `set` definition | beta | `simp only [hdef]` |
| 16 | dotted `comp` continuity lemma mis-unifies | implicit `g`, `f` | pin `(g := ...) (f := ...)` |
| 17 | `pow_le_pow_left` does not resolve | renamed | `pow_le_pow_left₀`; also `inv_anti₀`, `abs_add_le`, `Summable.tsum_le_tsum`, `norm_pos_iff`, `one_div_le_one_div_of_le` |

## Bench and gate traps

| # | pattern | cause | fix |
|---|---|---|---|
| B1 | orient gate refuses a Bash command | working directory drifted into `.lake/packages/mathlib` | re-run `python3 ~/.claude/hooks/orient_gate.py --orient` bare |
| B2 | pre-commit: `results/ and analysis/**/results/ are frozen` | outputs written under a results tree | write to the unit's `run/`; the script's `--out` points there |
| B3 | `lab check`: `UNMATCHED 0324` in prose | a unit id away from the word `unit` | a values row `unit_x 0324`, or put `unit` beside it |
| B4 | `lab check`: `module_lines` mismatch | counted before the last edit | `wc -l` after the final edit |
| B5 | `REFS  X does not match lean/...::name` | a ref that is not `lean_stage3/File.lean::name`, or a primed name | refs are Lean statements only; primed names cannot be refs |
| B6 | quote gate refuses a blockquote | not verbatim | copy from the file or the transcript; never from memory |

## Names

Verified on v4.32.2 with Mathlib at the pin, 2026-09-06:
`HasDerivAt.pow`, `HasDerivAt.comp_ofReal`, `HasDerivAt.ofReal_comp`,
`integral_exp_mul_complex`, `Real.cos_pi_div_two`, `Real.sin_two_mul`,
`Nat.cast_add_one_ne_zero`, `Finset.prod_le_prod`, `Finset.prod_const`,
`Finset.card_range`, `norm_prod`, `Complex.ofReal_sinh`, `Real.sinh_eq`,
`Complex.tendsto_euler_sin_prod`, `Real.prod_one_add_le_exp_sum`,
`Complex.norm_log_one_add_sub_self_le`, `Complex.sin_mul_I`,
`Complex.norm_exp`, `Complex.ofReal_log`, `le_of_tendsto`, `ge_of_tendsto`,
`Filter.Tendsto.norm`, `Finset.prod_range_mul_prod_Ico`,
`Finset.prod_range_add_one_eq_factorial`, `Finset.sum_Ico_succ_top`,
`Nat.centralBinom_le_four_pow`, `Nat.four_pow_le_two_mul_add_one_mul_central_binom`,
`Nat.centralBinom_eq_two_mul_choose`, `Nat.choose_mul_factorial_mul_factorial`,
`Nat.factorial_le_pow`, `Real.pi_lt_d2`, `Real.pi_gt_three`,
`inv_le_comm₀`, `div_le_div_iff₀`, `div_le_iff₀`, `le_div_iff₀`,
`intervalIntegral.integral_mul_deriv_eq_deriv_mul`.
