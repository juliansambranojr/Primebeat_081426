# Traps

Error pattern, cause, fix. One row per class. Appended after any build
that shows a class with no row (LOOP.md § 7). Rows 1–12 were paid for on
2026-09-06, units 0329–0335; rows 13–17 come from CLAUDE.md § Stage-3;
rows 18–20 were paid for by unit 0341; row 21 and B10–B11 by unit 0346, rows 22–23 by unit 0347, the
orchestrator's own runs of the loop; row 24 by unit 0349.

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
| 18 | `nlinarith` reports `linarith failed to find a contradiction` on a short context whose goal is a positive constant times a bracket | the whole proof is the product of two hypotheses and that product is not in the hint list | name the bracket's positivity as its own `have hb`, then `nlinarith [mul_pos h1 hb]` |
| 19 | `#guard_msgs` refuses a `#print axioms` pin, the diff adding `sorryAx` | a proof earlier in the same module failed, so the theorem is a sorry | fix the earlier errors; these pins are a cascade, they inflate `errors_first` and are not a class to chase |
| 20 | warning `Variable name X is not explicitly referenced` | a hypothesis in the statement the proof never uses | drop it from the statement and prove it follows from the rest (a positive error term can force the sign the dropped hypothesis asserted) |
| 21 | `field_simp` leaves `(1 - (m+2) * 0)`-type residue and the goal is not closed | a literal `- 0` or `* 0` inside the expression (here from a `Tendsto` limit at `0`) | `rw [sub_zero]` / `simp only [mul_zero, sub_zero]` before `field_simp` |
| 22 | `Unknown identifier pow_le_pow_left` (or another order lemma without a subscript) | the lemma was renamed with a `₀` suffix on this Mathlib (`pow_le_pow_left₀`, `div_le_div_iff₀`, `inv_le_comm₀`) | add `₀`; grep the name first (LOOP § 2) |
| 23 | `dsimp made no progress` after `filter_upwards … with n` | the goal is already beta-reduced; `filter_upwards` did it | drop the `dsimp only` |
| 24 | `Unknown identifier le_or_lt`, then `Tactic rcases failed: x is not an inductive datatype` on the next line | the case-split lemma is `le_or_gt` on this Mathlib (`lt_or_ge` for the other order); one root shows as two error lines, the unknown name and the `rcases` left with a metavariable | `rcases le_or_gt 0 x with h | h`; grep the name first (LOOP § 2) |

## Bench and gate traps

| # | pattern | cause | fix |
|---|---|---|---|
| B1 | orient gate refuses a Bash command | working directory drifted into `.lake/packages/mathlib` | re-run `python3 ~/.claude/hooks/orient_gate.py --orient` bare |
| B2 | pre-commit: `results/ and analysis/**/results/ are frozen` | outputs written under a results tree | write to the unit's `run/`; the script's `--out` points there |
| B3 | `lab check`: `UNMATCHED 0324` in prose | a unit id away from the word `unit` | a values row `unit_x 0324`, or put `unit` beside it |
| B4 | `lab check`: `module_lines` mismatch | counted before the last edit | `wc -l` after the final edit |
| B5 | `REFS  X does not match lean/...::name` | a ref that is not `lean_stage3/File.lean::name`, or a primed name | refs are Lean statements only; primed names cannot be refs |
| B6 | quote gate refuses a blockquote | not verbatim | copy from the file or the transcript; never from memory |
| B7 | pre-commit refuses a unit that `python3 -m lab check` passed, with `DIGITS ... three files -> write 3 files` | the installed `lab` console script (`.venv/bin/lab`, what the pre-commit calls) refuses counts spelled in words; the module form only warns | write the digit beside a key: `` `files` 3 files ``; check with `lab check`, the installed one, before committing |
| B8 | pre-commit step 9 refuses a decision unit with `DEFS ... BUILD run/build.log missing` | the unit has a `loop_version` row, which marks it a Lean unit | in a non-Lean unit key the number `loop_ver`; `loop_version` is the Lean-unit marker |
| B9 | `check_lean_unit.py`: `DEFS values defs=N but grep -c ^def=0`, and `PIN <name> has no '#print axioms <name>' line` for every pinned theorem | a def written as `noncomputable def foo` rather than plain `def` inside a `noncomputable section`; the `#print axioms` line placed after `end <Namespace>` so it needs the qualified name `Namespace.foo`, which does not match the checker's `^#print axioms <bare name>$` regex | wrap defs in `noncomputable section … end` (bare `def`, matching `grep -c ^def`); put every `#guard_msgs`/`#print axioms <bare name>` pin before `end <Namespace>`, inside the namespace |
| B10 | zsh: `===== not found` and a `set -e` script dies at an `echo` | a word beginning with `=` is zsh equals-expansion (`=cmd` → path of `cmd`) | never start a word with `=` in a Bash tool command; use `---` as a separator |
| B11 | orient gate refuses a command as one that "may write into `.lake/packages`" | the command text mentions the library path (a `cd` into it, or even a doc edit quoting it) beside writes elsewhere; the gate reads the whole text | grep by full path from the repo root with no `cd`; when a doc edit must quote the path, build the string in a script file and run the file (LOOP.md v9 § 2) |

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
`le_of_tendsto_of_tendsto`, `tendsto_one_div_add_atTop_nhds_zero_nat`,
`Filter.Tendsto.const_sub`, `Filter.Tendsto.const_mul`, `Filter.Tendsto.sub_const`,
`Real.continuous_exp`, `Nat.le_induction`, `Finset.sum_le_sum`, `Finset.Ico_self`,
`Real.summable_one_div_nat_pow`, `summable_nat_add_iff`, `Summable.mul_left`,
`Summable.congr`, `Summable.tendsto_sum_tsum_nat`, `tendsto_sub_atTop_nat`,
`Finset.sum_Ico_eq_sum_range`, `Complex.exp_sum`, `Complex.exp_log`, `Complex.exp_re`,
`Complex.exp_im`, `Complex.norm_exp_sub_one_le`, `Filter.Tendsto.cexp`,
`Complex.continuous_ofReal`, `Complex.abs_re_le_norm`, `neg_le_of_abs_le`,
`pow_le_pow_left₀`, `norm_sum_le`, `Complex.mul_re`, `Complex.mul_im`,
`Nat.centralBinom_le_four_pow`, `Nat.four_pow_le_two_mul_add_one_mul_central_binom`,
`Nat.centralBinom_eq_two_mul_choose`, `Nat.choose_mul_factorial_mul_factorial`,
`Nat.factorial_le_pow`, `Real.pi_lt_d2`, `Real.pi_gt_three`,
`inv_le_comm₀`, `div_le_div_iff₀`, `div_le_iff₀`, `le_div_iff₀`,
`intervalIntegral.integral_mul_deriv_eq_deriv_mul`.

Added by unit 0349, same toolchain and pin: `geom_sum_Ico` (a `lemma`, so a
`theorem`-only grep misses it), `Complex.div_ofReal_re`,
`Complex.div_ofReal_im`, `Complex.ofReal_pow`, `Complex.abs_im_le_norm`,
`Complex.exp_nat_mul`, `Real.exp_nat_mul`, `Real.mul_le_sin`,
`Real.log_le_sub_one_of_pos`, `Real.log_div`, `Real.norm_eq_abs`,
`le_or_gt`, `lt_or_ge`, `Finset.sum_add_distrib`, `mul_div_assoc'`,
`div_mul_div_comm`, `norm_sub_le`, `norm_sub_rev`, `norm_pow`,
`norm_add_le`, `Complex.exp_im`, `Complex.sub_im`.

Added by unit 0341, same toolchain and pin: `Complex.sq_norm` (protected,
`‖z‖ ^ 2 = normSq z`), `Complex.normSq_apply`, `Complex.mul_re`,
`Complex.norm_mul` (protected), `Complex.norm_real`, `max_eq_left`,
`max_eq_right`, `mul_nonpos_of_nonpos_of_nonneg`, `Real.exp_le_exp`,
`Real.exp_add`, `Real.exp_pos`, `mul_le_mul_of_nonneg_left`,
`mul_le_mul_of_nonneg_right`, `pow_pos`, `Nat.cast_nonneg`.
