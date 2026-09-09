# Traps

Error pattern, cause, fix. One row per class. Appended after any build
that shows a class with no row (LOOP.md § 7). Rows 1–12 were paid for on
2026-09-06, units 0329–0335; rows 13–17 come from CLAUDE.md § Stage-3;
rows 18–20 were paid for by unit 0341; row 21 and B10–B11 by unit 0346, rows 22–23 by unit 0347, the
orchestrator's own runs of the loop; row 24 by unit 0349; rows 25-28 by
unit 0352, the first module built under the relay (LOOP.md 4b); row 29 by
unit 0354; row 30 by unit 0357; row 31 by unit 0362; row 32 by unit 0363; row 37 by unit 0365; row 38 by unit 0370; rows 33-36 by the ReZetaCount
build, 2026-09-08.

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
| 25 | `simp [<def>]` on a conjugation identity leaves `2 = (starRingEnd ℂ) 2 ∨ <rest> = 0` | `simp` cancelled the leading numeral factor and split the goal into a disjunction (row 11's family, `simp` rather than `norm_num`) | `simp only [<def>, Complex.ofReal_neg, map_mul, map_sub, map_pow, map_add, map_ofNat, Complex.conj_ofReal, Complex.conj_I]`, then `ring` |
| 26 | `Complex.re_sum f` reports a type mismatch whose actual type is `∀ (f : α → ℂ), …` | the `Finset` is a section `variable` and is the first explicit argument, though it appears only in the conclusion | write `Complex.re_sum s f`, or use it as a rewrite: `rw [Complex.re_sum]` |
| 27 | `neg_le_of_abs_le h` rejects `h : |z.re| ≤ ‖z‖` "but is expected to have type `|‖z‖| ≤ z.re`" | the goal `-z.re ≤ ‖z‖` unified with the conclusion `-b ≤ a` the other way round (row 16's family, at a non-dotted lemma) | name the intermediate: `have h1 : -‖z‖ ≤ z.re := neg_le_of_abs_le (Complex.abs_re_le_norm z)`, then `linarith`/`nlinarith` |
| 28 | `nlinarith` fails on `x * y * L ≤ X * Y * L` with `x ≤ X`, `y ≤ Y`, `0 ≤ L`, `0 ≤ x`, `0 < y` all in the hint list | the conclusion is a product of three bounded factors and `nlinarith` multiplies hypothesis pairs, not triples | chain it factorwise, `mul_le_mul` for `x*y ≤ X*Y` and then `mul_le_mul_of_nonneg_right … hlog` (unit 0352's one `sorry`, closed by the foreman with exactly this chain) |
| 29 | `nlinarith [h1, h2]` reports `linarith failed to find a contradiction` on a goal whose certificate is the plain sum `h1 + h2 + h3` of hypotheses already in the context | row 14's family at the hint-fed form: the context also carries derived facts mixing `Real.pi` and `Real.pi⁻¹` monomials (here `hmul`, `hexp`, `hstep`, `hθpi` beside the three that matter), and the products `nlinarith` adds over them bury the linear certificate | `linarith [h1, h2, h3]` alone fails too, because linarith takes each product as one atom; name the rearrangement as its own identity, `have key : (e'^2 - D^2) * (1 - 2*θ/Real.pi) - 2*e'*D*θ = (e'^2 - D^2) - θ * (2*e'*D + 2*(e'^2 - D^2)/Real.pi) := by ring`, then `linarith [h1, h2, h3, key]` (unit 0354's one `sorry`, `WeilPowerNear.bracket_nonneg`, closed by the foreman with exactly this) |
| 30 | warning `` `push_neg` has been deprecated. Prefer using `push Not` instead. `` with a macro suggestion in the message | Mathlib at the pin deprecated `push_neg` | it is a warning, so it does not count in `errors_first` and the build is clean; write `push Not at h`, or drop the tactic where the next step is `omega`, which reads a negated linear hypothesis `¬ x ≤ y` directly (unit 0357's `blocked_card_le`) |
| 31 | `Unknown identifier D` at a statement copied verbatim from a design block, where every module the block's `open` line names is opened | the block's `open` line lists the modules whose theorems it composes; a constant that appears only inside a composed theorem's statement can live in a further namespace, reached in the source module through that module's own `open` and not through the import (`WeilPowerGauss.D` inside `WeilPowerPhase.re_S_sq_ge`), and `open` is not transitive | add the namespace to the module's `open` line and record the addition as an ASSUMED pin; catch it in the § 2 scratch pass by writing every constant of the copied statements as its own one-line `example`, which is where unit 0362 caught this one |
| 32 | `Unknown identifier ArgIdentity.zetaArgContour` at a statement copied verbatim from a design block, where the block's Composes line quotes the declaration under that namespace | the block named the namespace after the file it read (`Stage3/ArgIdentity.lean`), and the file declares `namespace Stage3`; a Stage-3 module's namespace is not its file name, and the older modules put their theorems in `Stage3` | `grep -n '^namespace\|^end ' <file>` for the enclosing namespace of the declaring line and qualify from that (`Stage3.zetaArgContour`), then record the change as an ASSUMED pin; the § 2 scratch pass catches it as a `#check` of every composed name before the module is written, which is where unit 0363 caught this one |
| 33 | `linarith [h0]` fails on a goal `∑' n, 1 / f n = c` whose hypothesis `h0` says exactly that, after a `norm_num at h0` | `norm_num` rewrote `1 / x` to `x⁻¹` inside `h0`'s `tsum` body and left the goal's `1 / x` alone, so the two sums are different atoms and `linarith` sees no relation between them | do not run `norm_num at h0` on a hypothesis carrying a `tsum`; peel the numeral term with a `show`-typed `tsum_congr` rewrite and clear the `n = 0` term with a targeted `simp only`, keeping `1 / x` on both sides |
| 34 | `simp [Complex.ext_iff]` on a conjugation identity closes the real part and leaves `a - T = a + -T` | `Complex.sub_im` normalises the left side to a subtraction and the right side, coming through `starRingEnd`, to an addition of a negation | `simp [Complex.ext_iff, sub_eq_add_neg]` |
| 35 | `rw [h]` reports `Did not find an occurrence of the pattern` and the goal prints as `‖(fun x => e x) x‖ ≤ c` | the function was passed explicitly to a lemma (`Finset.card_le_card_of_injOn (fun x => …)`), so `intro x hx` left the application unreduced; row 15's family at an explicit functional argument rather than a `set` | `beta_reduce` or `show` the reduced goal before the `rw`, or `simp only []` first |
| 36 | `simp only [<def>, ENat.toNat_eq_zero]` reports the second lemma unused and leaves `(<expr>).toNat ≠ 0` | `Ne` is notation for `¬ (_ = _)` and `simp only` does not unfold it, so the `toNat _ = 0` pattern never appears | add `ne_eq` to the simp set |
| 37 | `Application type mismatch` on a lemma the § 2 scratch pass `#check`ed clean, the two instance paths printed as `Real.pseudoMetricSpace` against `SeminormedGroup.toPseudoMetricSpace` | the name is the multiplicative member of a `to_additive` pair and the codomain is `ℝ`; a bare `#check` elaborates it against fresh metavariables and cannot see the mismatch | use the additive partner named in the `@[to_additive …]` attribute (`IsCompact.exists_bound_of_continuousOn'` → `IsCompact.exists_bound_of_continuousOn`); in § 2 write the name as an `example` at the module's own types, never a bare `#check` (unit 0365) |
| 38 | `rcases lt_trichotomy x a with hxa | rfl | hxa` fails downstream with `Unknown identifier 'a'` at every later reference to the endpoint `a` | the middle `rfl` runs `subst` on `x = a` and eliminates the LOCAL variable `a`, not `x`; the body that keeps naming `a` sees it as an unknown | name the equation (`hxa_eq : x = a`) and `rw [hxa_eq]` where the body needs it, so `a` survives as a hypothesis (unit 0370) |

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

Added by unit 0352, same toolchain and pin: `Complex.re_sum` (the `Finset` is
its first explicit argument), `Complex.exp_conj`, `Complex.conj_re`,
`Complex.conj_ofReal`, `Complex.conj_I`, `Complex.norm_div` (protected),
`Complex.norm_pow` (protected), `Complex.ofReal_neg`, `Real.log_le_log` (a
`lemma`, hypotheses `0 < x` then `x ≤ y`), `one_le_pow₀` (a `lemma`), `sq_abs`
(a `lemma`), `max_le`, `abs_pos`, `abs_of_neg`, `abs_of_nonneg`,
`div_nonpos_of_nonpos_of_nonneg`, `Nat.one_le_iff_ne_zero`, `map_ofNat`,
`map_add`, `map_pow`, `map_sub`, `map_mul`, `Nat.lt_of_lt_of_le`.

Added by unit 0362, same toolchain and pin: `Complex.re_le_norm`,
`Complex.re_ofReal_mul` (the real is the *first* factor: `(↑r * z).re = r * z.re`),
`Complex.add_re`, `Complex.add_im`, `norm_mul`, `norm_pow`, `norm_nonneg`,
`sq_nonneg`, `neg_le_neg`, `mul_pow`.

Added by unit 0357, same toolchain and pin: `Finset.card_le_card`,
`Finset.card_range`, `Finset.mem_range`, `Finset.not_subset`,
`Finset.card_biUnion_le`, `Finset.mem_biUnion` (a `lemma`, `@[simp]`),
`Finset.min'_mem`, `Finset.max'_mem`, `Finset.min'_le` (explicit `x` then
`x ∈ s`, the nonemptiness proof supplied as `⟨x, H2⟩` and matched to any
other by proof irrelevance), `Finset.le_max'`, `Finset.mem_Icc`,
`Nat.card_Icc` (a `lemma`, `@[simp]`), `Finset.card_pos` (a `lemma`),
`Finset.eq_empty_or_nonempty`, `pow_le_pow_right₀` (a `lemma`),
`Finset.sum_const`, `smul_eq_mul` (a `lemma`, `Algebra/Group/Action/Defs`),
`pow_add`, `Nat.sub_add_cancel`, `Nat.mul_le_mul_right` (the multiplier `k`
explicit and first: `Nat.mul_le_mul_right k h`), `pow_nonneg`, `mul_le_mul`.
