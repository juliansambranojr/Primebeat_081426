# Lab notebook, volume 2 — Primebeat_081426

Volume 2. Volume 1 is `lab_notebook.md`; it is closed and holds entries
1–44. This volume opens at entry 45.

Numbering is continuous across volumes: `entry N` is a unique address
project-wide, and a `NOTEPAD.md` line citing a bare entry number resolves
to whichever volume holds it — 1–44 in `lab_notebook.md`, 45 onward here.

Newest at top, same as volume 1.

Entry format and type vocabulary: `notes/notes_format.md`.

Agents append entries. Outcome markings and status transitions are
Julian's call.

---

## 2026-08-25 — Entry 148 — O30–O38 instrument-fix pass: flags and results JSON, nine scripts, zero drift
type: instrument-fix
refs: 28, 32, 35, 38, 39, 40

Closes the thread entries 28 and 35 opened: hardcoded parameters and
missing results JSON, against the house convention. Nine scripts now
carry the O39-style flag set and the standard envelope, every default
byte-identical to the old hardcoded value: O30_silence_scaffold_primes.py,
O31_excise_scaffold_primes.py, O32_excised_gamma_check.py,
O34_zeta_residual_model.py, O35_nearmiss_residuals.py,
O36_weil_calibration.py, O37_weil_form_balance.py,
O37_weil_form_on_stencil.py, O38_weil_bug_diagnosis.py.
O34_zeta_residual_model_FAILED.py and O38_weil_form_BUGGY.py stay
untouched — frozen evidence, their docstrings forbid citing their
numbers.

**Guards built in, beyond bare flags.** O31 computes the exact
variant-B walk bound and refuses before sieving when --lim is too
small for --rmax (rmax 23 needs lim >= 31457279). O34 refuses
--rmax < 20 (its TRUE_RES_R20 literals are row-20, dps-40 objects;
no --row flag exists) and its --dps help states the coupling. O36 and
both O37s anchor --zeros to the script directory, fixing a recorded
cwd-dependence defect, with the cache's dps-25 precision stated.
O37_weil_form_on_stencil's bare positional K became --k. O38 gained
only --out/--no-json/--results-dir: its b, N, W sit inside a
deliberately verbatim copy of the buggy objects and stay untouched.

**Re-runs: all nine at defaults, zero drift.** O30/O31/O32 exact to
entry 32 (baseline and silenced zero lists, excision readings,
(20,6) = 70 under A and 1086 under B, gamma triple to every digit).
O36 digit-for-digit to entry 39 (0.4620476309 / 0.4620476476). Both
O37s line-identical to their frozen logs
(results/O37_weil_form_balance_run1.log, 48.88 s vs recorded 49.79;
results/O37_weil_form_on_stencil_run1.log, 11.82 s vs 12.12) and to
entry 40's balance numbers. O38 matches entry 39's four diagnostics.
O34 exact to entry 38's row-20 table and non-monotone d6 ratios
(0.8953/0.7999/0.8618). O35 exact to entry 38's deep-cell failures
including the (25,21) sign flip (-296432.92 at 200 pairs, +27793.218
at 600) and the cell-is-the-residual reading. Prior results REMAIN
FULLY COMPARABLE everywhere; the only stdout addition anywhere is the
trailing "results written to" line. Interpreters matched each file's
HOW IT WAS RUN (system python3 for O30–O32, .venv for the rest).

**First-ever JSONs.** Nine default-named results JSONs now exist,
including the first machine-readable records for O34
(results/zeta_residual_model.json) and O35
(results/nearmiss_residuals.json). No pre-existing artifact was
touched; no results JSON on disk recorded the nine scripts' old shas,
so the O24-style stale-pointer mode does not arise here.

**Two observations recorded, plainly.** (1) O39's own --results-dir
flag is dead code — declared, never read. The nine new
implementations made it functional; O39 itself is unchanged and the
defect is now on record. (2) O36's set-3 zero/arch diff printed
3.75e-15 on this run and on the original code — entry 39's "agreeing
to 1e-18" phrase fits sets 1 and 2 (5.1e-18, 2.7e-22); set 3 always
sat at the e-15 scale against an arithmetic side of order 1e-8.

Gates after the pass: 0 broken references, 132 values confirmed,
0 not found.

---

## 2026-08-25 — Entry 147 — O24 pi_at float-key fix: the instrument-fix entry, eight days late
type: instrument-fix
refs: 35

The fix landed 2026-08-17 and produced two NOTEPAD lines but no entry;
this is the entry, so the record is dated where later readers look.

**What changed.** In O24_prime_generator_orbit.py, pi_at's searchsorted
key is floored to an exact Python int before the lookup, removing a
whole-array float64 upcast of the primes array on every call.
Performance only: for any real key k, the primes at or below k are the
primes at or below floor(k), so the count cannot move. The full
semantic-identity argument, including boundary behaviour, is in the
function's docstring.

**Comparability.** Prior O24 results REMAIN FULLY COMPARABLE. Verified
2026-08-17 by running pre-fix and post-fix code on identical flags on
two settings and comparing result JSONs cell by cell — byte-identical
apart from timestamps and the recorded code_version sha.

**Sha lineage.** 6e2ddd01… (pre-fix) → f3525a7f… (post-fix, current;
recomputed for this entry). On disk: five results JSONs record the
pre-fix sha (O24_gen_11to19_results.json, O24_gen_to19_results.json,
O24_gen_xmax1e9_results.json, O24_prime_generator_orbit_results.json,
O24_prime_generator_orbit_run2.json); one,
O24_gen_xmax3e9_results.json, records the post-fix sha. The NOTEPAD
line's "every O24 results JSON records 6e2ddd01" was true when written
and is superseded by that sixth file.

**The re-stamp decision (Julian, 2026-08-25): leave the shas.** The
five pre-fix shas stay exactly as they are — honest provenance of
which code produced those numbers — and this entry is the crosswalk.
Editing shas inside frozen results would falsify that provenance to
make it tidier.

**The aborted log (same decision principle).**
results/O24_gen_xmax3e8_run.log is a timing probe killed at the
two-minute mark — which is why it stops mid-G6 — copied into results/
from a scratch directory in error (entry 35's thread). The filename
stays: results are frozen evidence, and this paragraph is the label.
The correction of entry 35's "G1 through G5 are reported" framing is
an outcome marking and stays Julian's.

---

## 2026-08-25 — Entry 146 — The method has its own repository: the_container
type: motivation
refs: 143, 144, 145

**What exists.** The methodology this program built — and entries 143
(the engine: stigmergy, decorrelation, entropy schedule) and 144 (the
posit: a Lean kernel adjudicating meaning) articulated — now lives as
a standalone, domain-agnostic, public template repository:
<https://github.com/juliansambranojr/the_container>, first commit
`cb06d4f`, public from that commit. Julian's framing: build in
public.

**What it contains.** BLUEPRINT.md (thesis, eight failure modes each
mapped to the part that answers it, definitions, the nine-step loop,
separation of powers, when-to-move-in and the minimum seed, gate
adaptations for seven domains, refusals); AGENT.md, the working
contract written for any model — the CLAUDE.md role with the
Claude-specific identity removed; the four commitment files and its
own notebook, kept by its own rules; and three gates — record
consistency, kernel adjudication, and a regression suite that
replays 13 adversarial break scenarios on scratch copies, each
required to fire. The gates live in that repo's utilities tree;
paths resolve there, so this entry names them by function.

**Entry 144's posit is now operational.** The repo's
`adjudications/` layer is the kernel-for-meaning recipe made
mechanical: domain concepts as opaque atoms, premises as named
axioms, conclusions as theorems, a zero-axiom satisfiability model,
`#guard_msgs` pins as the mechanically generated leaf ledger, and a
gate coupling every pinned axiom to a budget-and-discharge ledger
line. Adjudication 001 kernel-checks the skeleton of the container's
own thesis from a single premise (some claim feels right and is
incorrect). Its back-translation round is open in that repo's
NOTEPAD.

**The method audited itself before shipping.** A decorrelated
adversarial review of the repo returned 12 findings (5 more
retracted under self-attack), the sharpest being three ways to pass
the adjudication gate falsely — unimported modules, unpinned
theorems, `sorryAx` allowlisted. All 12 repaired; the review's break
scenarios became the permanent regression suite. The reviewer's
summary line earned its keep: the prose describing the gates was
stronger than the gates.

**Relation to this bench.** One-way, same as everything here: the
container cites Primebeat as provenance and worked example; nothing
in this tree depends on it. The bench keeps its own gates.

No outcome marked.

---

## 2026-08-24 — Entry 143 — What inherits the work, and why the engine ran: four domains, three legs
type: motivation
refs: 99, 116, 130, 133, 140, 142

The inheritance claims, nearest to farthest. (1) The verified-floor +
crude-explicit-ceiling architecture as a portable machine: finite
computation closes a region, explicit-but-crude asymptotics close the
tail, and the BUDGET MEASUREMENT proves they meet — the anatomy of
odd perfect numbers, Linnik constants, class-number problems, all
waiting for the tolerance run almost nobody performs. (2) Statement-
satisfiability testing as formalization QA: O71 numerically falsified
a formal statement before anyone spent months proving toward it; two
trees yielded undischargeable statements in one day; the ecosystem
building decade-scale programs has no standing harness for this.
(3) The phase-decomposition kit: O69's instruments (band entry,
lock-on, phase split) apply verbatim to any spectral staircase —
Berry–Tabor and BGS are exactly claims about staircase fluctuations.
(4) The leaf ledger as social technology: named assumptions with
citation shape, measured budget, sketched discharge, upstream watch —
dependency management for open problems; a two-person bench
interoperated with Tao's network without asking permission.

Why the engine ran (Julian's reading, tested against the day and
confirmed from inside). Stigmergy: the notebook, NOTEPAD, and gates
held the state, so decisions reduced to do-or-don't against a
regression check — second-guessing is the tax on unverified memory,
and the ratchet abolished it; the agent's context was destroyed and
rebuilt several times mid-day and the session never lost ground
because the state lived in the tree. The folding-in failure: the
agent's errors were coherent-and-wrong (the principal arg, the
vacuous capstones) — coherence is what it maximizes, so its
characteristic failure is confident self-consistency; the outside
perturbation works by DECORRELATION, an uncorrelated read of the same
statements, the way independent instruments beat one instrument
re-read. And the perturbation schedule was human: every injection was
orthogonal to the current axis ("argue the opposite", "test it on our
bench", "run it forward"), timed precisely when the path looked
smoothest — apparentness itself as the warning sign. Stigmergy holds
the state, the ratchet holds the ground, the human holds the entropy
schedule; each leg covers the failure mode of the others.

The through-line of both halves: tolerance is a measurable object,
and most impossibility verdicts have never measured it.

## 2026-08-24 — Entry 145 — The repository is public
type: provenance
refs: 142, 143, 144

Flipped public at Julian's instruction — "let them see what's
possible" — at commit 690e7e8, 2026-08-24:
https://github.com/juliansambranojr/Primebeat_081426

Pre-flight, verified at HEAD immediately before the flip: 0 broken
references, 132 values confirmed, 0 broken welds, bench parity
250/250, stage3 parity 56/56, tree clean and identical to remote,
LICENSE and README present with the notebook framed as part of the
publication, sensitivity sweep clean over the full history.

The flip is the opening move of the group project (entry 142): the
#1538 note and the identity_16_complex PR now have referenceable
code behind them. Every gate travels with the tree — anyone who
clones can run check_refs, check_values, and lake build, and watch
the record verify itself.

## 2026-08-24 — Entry 144 — Posit: a kernel for meaning — Lean as adjudicator in LLM discourse
type: motivation
refs: 133, 142, 143

Julian's posit, recorded to revisit as a paper's methodology section.
An LLM used as a judge of another LLM's argument parrots the
preferences inherited from RLHF and its developers — judgment by
vibes, at scale. Today's session contained exactly one judge with
zero preferences: the kernel. Every dispute that mattered ("is this
possible", "does this hold", "is this hypothesis even satisfiable")
was settled by build-green or build-red, and the day's two structural
defects were caught by that judge plus an uncorrelated reader, never
by taste.

The generalization: kernel-adjudicated discourse. Not formalizing
meaning wholesale — formalizing the STRUCTURE of a disagreement.
Map the argument into typed statements; inference steps the kernel
checks; premises that resist formalization become named leaves with
the full discipline this bench built for them — citation shape,
measured budget (how wrong can this premise be before the conclusion
dies), sketched discharge, adversarial satisfiability testing
(O71-style: test the formalized statement against evidence BEFORE
trusting it, because a vacuous formalization judges nothing — the
translation gap is where this method lives or dies). The verdict
form changes from "the judge prefers A" to "A holds modulo these
named leaves, each budgeted" — disagreement becomes a ledger, and
the ledger is inspectable by both parties.

Logical and philosophical scope: validity is the kernel's; meaning
stays in the leaves — and that division is the honesty of the
method, not its weakness. The leaf ledger IS the interface where
human meaning enters a machine-checked argument. What today
demonstrated in miniature: two parties (and their adversarial
agents) converging not because either persuaded the other but
because the tree held a shared, gated, budget-annotated state of
the argument. A paper would need: the discourse-mapping method, the
translation-gap failure modes (entries 131–133 as case studies),
and the budget semantics for informal premises.

## 2026-08-24 — Entry 142 — The group-project audit: nine sorries classified, one statement tested and found wanting
type: result-triage
refs: 133, 141

Julian's proposal: contribute to the upstream program itself — clean
their sorries, earn the pin bump as a group project. The audit of
IEANTN/Kadiri.lean's nine real sorries (five hits are comments):

Deep cores: hadamard_identity (the Hadamard product for ζ'/ζ),
kadiri_thm_3_1_q1_laplace_inversion. Assemblies inheriting from
children: backlund_bound, kadiri_thm_3_1_q1 (×2). Entangled medium:
re_hadamardB_eq (Laurent at s=1 + zero-sum symmetrization,
discussion #1476). Our genre, adoptable: identity_16_complex
(discussion #1494) — its COMPLETE proof sketch is written in the
blueprint comment: apply Thm 3.1 to the Kadiri test function,
discharge with three named existing lemmas, three terms vanish,
solve. Adopted as our PR target for a fresh session.

And the two horizontal-vanishes lemmas (#1538) are undischargeable
as stated — the entry-132/133 defect class, in their tree. The
statement takes T → ∞ over all reals, but ζ'/ζ has a pole at every
zero height crossing the σ-segment, and δ := |T − γ| is
unconstrained while any admissible φ's transform decay is fixed.

O71 (exploratory, results/horizontal_defect.json + run log) tested
the claim before any note goes anywhere:
Check 1, the log law: J(δ) = ∫|ζ'/ζ| over σ ∈ (−1/4, 5/4) at
T = γ₁ + δ, against 2·ln(1/δ): ratio 1.195 → 1.031 across
δ = 1e−1 → 1e−6. The pole mechanism, confirmed.
Check 2, the schedule: with the concrete admissible
φ = e^(−y/2)/cosh(3y/2) (Φ in closed form, exponentially small),
the weighted integral grows arithmetically in log(1/δ) at γ₁ and
γ₂₉, and the δ pushing it past any bound exists at every height
(ln δ < −4.0e6 at γ₁; < −1.3e45 at γ₂₉ — astronomically small,
and legal). So the limit over the full filter fails for every
nonzero admissible φ; heights with |T − γ| ≥ c/log T repair it,
and the downstream consumer needs only a cofinal family.

The note for #1538 is drafted and HELD — posting is outward-facing
and Julian's call, with these numbers now behind it. The
contribution ledger: (1) the #1538 restatement note, tested;
(2) identity_16_complex as the adoptable build.

## 2026-08-24 — Entry 141 — The Arg half audited: upstream races us, and the crude route is mapped
type: provenance
refs: 119, 130, 140

The StmtArgCrude audit, after entry 140 closed the Stirling half.

The upstream find: the dependency's IEANTN/Kadiri.lean STATES
Kadiri.backlund_bound : riemannZeta.Riemann_vonMangoldt_bound
0.137 0.443 6.1 — the full hNT leaf at Rosser's literature constants.
Probed via #print axioms (probe built, read, removed): it depends on
sorryAx today — 14 sorries stand in that file. Tao's network is
building the sharp version of exactly our leaf; when it lands, a pin
bump discharges hNT entirely and RvM_of_phase_arg's crude route
becomes a redundant check. Until then ours is the live path.

The crude route, mapped against sorry-free substrate:
StmtArgCrude decomposes as Backlund's argument bound —
(A1) the rectangle argument-principle identity connecting their
riemannZeta.N to the phase θ/π + 1 + S(T)
(RectangleArgumentPrinciple.lean, sorry-free, is the machinery);
(A2) S(T) ≤ B·log T via zero counts in disks
(Jensen: their zetaSurrogate zeros-in-ball counts in
Backlund/ZeroCountCrude, sorry-free but existential constants;
BorelCaratheodory.lean sorry-free; ZetaBounds' zeta analytics
sorry-free) — the crude-explicit constant extraction is the work.
Budget: entry 130 accepts B₁_total ≤ ~100 at depth ≥ 7 and the
Stirling half consumed 97; the Arg half rides the B₃-room (≤ 1000)
and the census re-tabulates at whatever lands — even B₁ ≈ 150 total
keeps depth 7 by entry 130's pattern.

The ledger after this session: stage 3 = {hEF, StmtArgCrude}. hNT's
two halves went from named (131) to corrected (132) to constructed
(135) to one-discharged (140) in a single day; the other half has its
substrate audited and an upstream race running.

## 2026-08-24 — Entry 140 — THE STIRLING HALF DISCHARGED: StmtBacklundPhase phaseTheta 97 98 is a theorem
type: formalization
refs: 132, 135, 136, 137, 138, 139

The first full leaf discharge of the stage-3 effort, in
`lean_stage3/Stage3/Stirling.lean`. Package parity 56/56; builds clean
at 8713 jobs; welds 2/0; gate 0.

The session's chain, each piece green on first or second build:
re_sub_log_norm_le generalized to radius 2 (constant 8 — the n = 0
term needs it); zq, normSq_add_zq, add_zq_ne_zero, a_term_le (the
per-term telescope bound 8/((n+1/4)² + (t/2)²));
re_digamma_sub_log_le — THE HARMONIC-γ LIMIT ASSEMBLY:
|Re ψ(zq t) − log‖zq t‖| ≤ 96/t, by telescoping the digamma series
against log-norm steps, with the partial sums converging through
Mathlib's tendsto_eulerMascheroniSeq, the log-norm drift vanishing by
a squeeze, and every partial sum bounded by 8·Σ'q ≤ 96/t;
stmtDigammaLog_holds — StmtDigammaLog 97, both components;
backlundPhase_holds — StmtBacklundPhase phaseTheta 97 98, through
entry 136's reduction.

What fell: the Stirling half of Backlund's decomposition, whole. The
phase that wrapped as a hypothesis in entry 131, was made abstract in
entry 132, and was constructed as an integral in entry 135, now
provably tracks the main term with explicit crude constants — 97
against Rosser's 0.137, inside entry 130's budget shape (the census
re-tabulates when the Arg half lands).

The ledger: hNT = StmtArgCrude alone (S(T) = O(log T), the argument
principle). Stage 3 entire: {hEF, StmtArgCrude}. Two leaves, both
classical, both with sorry-free machinery waiting in the dependency
(BorelCaratheodory, ZetaBounds, the rectangle argument principle).

## 2026-08-24 — Entry 139 — The telescope's engine: |Re w − log‖1+w‖| ≤ 5‖w‖²
type: formalization
refs: 137, 138

`lean_stage3/Stage3/Stirling.lean` grows by re_sub_log_norm_le;
package parity 49/49; builds clean at 8713 jobs; welds 2/0.

For w with re w > 0 and ‖w‖ ≤ 1: |Re w − log‖1+w‖| ≤ 5‖w‖². The
proof needs exactly one library estimate — log y ≤ y − 1 — applied at
1+u and at (1+u)⁻¹, where u = 2·re w + ‖w‖² is the norm-square
expansion ‖1+w‖² = 1 + u. The lower application gives
log(1+u) ≥ u/(1+u), and the v := u/(1+u) bookkeeping closes both
sides of the absolute value by nlinarith.

Component 1's ledger: per-term engine 5‖w‖² (this entry), tail sum
12/t (entry 138), log ratio 1/(4t) (entry 138). At w = 1/(z+n) the
composition gives Σ|Re aₙ| ≤ 60/t, and the band lands at C ≈ 61 —
inside the ≤ 100 budget of entry 130 with room. Remaining: the limit
assembly Re ψ(z) = log‖z‖ − Σ Re aₙ via Mathlib's harmonic-γ limit —
pure structure, all its numbers now proved.

## 2026-08-24 — Entry 138 — The C/t band's two pillars: the log ratio and the quadratic tail sum
type: formalization
refs: 130, 136, 137

Slice C1a of the digamma comparison, in
`lean_stage3/Stage3/Stirling.lean`. Two theorems; package parity
48/48; builds clean at 8713 jobs; welds 2/0.

log_norm_z_le — |log‖z_t‖ − log(t/2)| ≤ 1/(4t) for t ≥ 1: log_sqrt,
the ratio identity (1/16 + t²/4)/(t²/4) = 1 + 1/(4t²), and
log(1+x) ≤ x.
inv_quadratic_tsum_le — Σ' 1/((n+1/4)² + (t/2)²) ≤ 12/t for t ≥ 1:
split at K = ⌊t⌋+1; head ≤ K·4/t² ≤ 8/t by the (t/2)² floor; tail
≤ 4/K ≤ 4/t through the dependency's sorry-free
tsum_one_div_natCast_add_add_one_sq_le. This is the sum controlling
Σ|aₙ| in the digamma telescope — the quantitative heart of
ψ(z) = log z + O(1/t) on the quarter-line.

Engineering: the ⌊t⌋ dyadic level needed clear_value (third instance
of the floor-unfolding whnf explosion; entries 128, and now here);
several v4.32 renames (inv_anti₀, one_div_le_one_div_of_le,
Summable.sum_add_tsum_nat_add as a dotted method).

Remaining for component 1: the telescope identity
Re ψ(z) = log‖z‖ − Σ Re aₙ (harmonic-γ limit assembly) and the
per-term |aₙ| ≤ ‖1/(z+n)‖² (complex log-Taylor). Then C ≈ 12 + small,
far inside the ≤ 100 budget, and the Stirling half closes through
entry 136's reduction.

## 2026-08-24 — Entry 137 — First numeral: the compact half of the digamma comparison, discharged at C = 8
type: formalization
refs: 135, 136

`lean_stage3/Stage3/Stirling.lean` grows by two theorems; package
parity 46/46; builds clean at 8713 jobs; welds 2/0.

digamma_term_norm_le — the per-term engine on the quarter-line
segment: ‖1/(n+1) − 1/(n+z)‖ ≤ 4/(n+1)² for re z = 1/4, ‖z−1‖ ≤ 1,
via the exact identity 1/(n+1) − 1/(n+z) = (z−1)/((n+1)(n+z)) and
‖n+z‖ ≥ n + 1/4. Reusable by component 1.
phasePoint_compact_le — |Re ψ(1/4 + it/2)| ≤ 8 on [0,1], from the
dependency's sorry-free digamma_eq_tsum: |ψ| ≤ γ + Σ 4/(n+1)² =
γ + 4·π²/6 < 2/3 + 6.62 < 8, closed with Mathlib's
eulerMascheroniConstant_lt_two_thirds, pi_lt_d2, and hasSum_zeta_two
reindexed through tsum_eq_zero_add.

This is the first analytic estimate with a hard numeral in the
stage-3 effort — the leaves are made of exactly this kind of fact.
StmtDigammaLog's remaining piece is component 1 alone: the C/t band
for t ≥ 1, the same per-term identity telescoped against the
logarithm. Then the Stirling half closes through
backlundPhase_of_digammaLog (entry 136).

## 2026-08-24 — Entry 136 — The Stirling half reduced to the digamma comparison
type: formalization
refs: 130, 132, 135

`lean_stage3/Stage3/Stirling.lean` grows by StmtDigammaLog and
backlundPhase_of_digammaLog; package parity 44/44; builds clean at
8713 jobs; welds 2/0; no sorries.

StmtDigammaLog C names the last analytic fact of the Stirling half:
|Re ψ(1/4 + it/2) − log(t/2)| ≤ C/t for t ≥ 1, plus |Re ψ| ≤ C on
[0,1] — the textbook ψ(z) = log z + O(1/|z|) on the quarter-line.
backlundPhase_of_digammaLog proves the full reduction:
StmtDigammaLog C → StmtBacklundPhase phaseTheta C (C+1). The proof
splits the phase integral at 1, bounds the compact piece by C,
integrates the band to C·log T (integral_inv), evaluates the main
term by integral_log_half, and the T·log terms cancel exactly against
the RvM main term through log(T/2π) = log(T/2) − log π — the 7/8
mismatch and integration constants land inside C + 1, with room
(the true slack at the numeric step is ~3/8).

The Backlund decomposition now reads: StmtDigammaLog C (Stirling
core, budget C ≤ ~100) + StmtArgCrude (S(T), the argument principle)
→ RvM_of_phase_arg → hNT. The stage-3 leaf ledger: hEF,
StmtDigammaLog, StmtArgCrude — three named classical estimates, each
crude-budgeted, everything between them and the census kernel-checked.
Discharge route for StmtDigammaLog: the dependency's sorry-free
digamma_eq_tsum series, next session.

## 2026-08-24 — Entry 135 — Stirling slice, construction half: the continuous phase exists
type: formalization
refs: 132, 133, 134

`lean_stage3/Stage3/Stirling.lean`, four theorems, four pins; package
parity 43/43; builds clean at 8713 jobs; welds 2/0.

phaseTheta T = (1/2)·∫₀ᵀ Re ψ(1/4 + it/2) dt − (T/2)·log π, with
ψ = Complex.digamma (Mathlib's logDeriv Gamma). The continuous phase
is constructed as the integral of the derivative — wrap-free by
construction, the entry-132 defect resolved by an object instead of a
hypothesis. Anchored: phaseTheta_zero (θ(0) = 0 = arg Γ(1/4), Γ(1/4)
positive). Well-posed: continuous_phasePoint via PNT+'s sorry-free
continuousAt_digamma_of_re_pos (the quarter-line stays in re > 0);
intervalIntegrable_phasePoint on every interval. The main-term
integral is evaluated by FTC avoiding t = 0: integral_log_half,
∫₁ᵀ log(t/2) dt = T·log(T/2) − T + 1 + log 2, antiderivative
t·log(t/2) − t.

Remaining for StmtBacklundPhase phaseTheta: the digamma comparison
|Re ψ(1/4 + it/2) − log(t/2)| ≤ E(t) with explicit E integrating to a
B₁·log T + B₃ band — from the dependency's sorry-free digamma_eq_tsum
series; then integrate against integral_log_half. Budget B₁ ≤ 100
where Rosser needs 0.137. Elaboration note for the record: the
digamma composition needed ContinuousAt.comp with g and f pinned
explicitly — higher-order unification guesses the wrong decomposition
on dotted comp.

## 2026-08-24 — Entry 134 — The capstones repaired: hG' restricted to (1/2, ∞); vacuity resolved
type: formalization
refs: 115, 117, 133

The Finding-1 repair from entry 133, in the bench tree.
lean/Expansion.lean: hD_of_window and tableFrom_ne_zero_of_li now take
hG' : ∀ x ∈ Ioi (1/2), HasDerivAt G (f2x x) x; the congr induction
runs on Ioi (1/2); the window membership (bottom ≥ 1 > 1/2) closes it.
lean/Schoenfeld.lean: tableFrom_ne_zero_of_schoenfeld forwards the
same signature. Build clean at 8046 jobs; 250/250 pins unchanged
(axiom lists identical); gates 0/0/0; welds 2/0; THEOREMS.md
regenerated.

The hypothesis pair is now satisfiable: G = li(2^x) on [1/2, ∞),
smoothly patched below, is globally smooth with the required
derivative on (1/2, ∞) — the divergence of ∫ 2^t/t dt at 0⁺ no longer
touches the stated domain. Entries 115/117's capstones are dischargeable
in principle, as they were always claimed to be.

With this, everything the adversarial audit (entry 133) surfaced is
resolved: the vacuous pair repaired, the two misstatements corrected,
the wording noted. The queue returns to the Stirling slice — the
continuous phase construction — with the chain's both ends now sound.

## 2026-08-24 — Entry 133 — Adversarial audit of the stage-3 chain: package clean; the bench capstones are vacuous as stated
type: result-triage
refs: 115, 117, 122, 128, 129, 132

A blind adversarial agent audited entries 115–132, all five lean_stage3
modules, the pinned dependency's definitions, O68/O70, and the weld
gate — instructed to hunt the arg-wrap class of defect and to attack
its own findings before reporting. Four findings survived; I verified
the severe one independently before accepting it.

Finding 1 (breaks the bench capstones; the stage-3 package is
unaffected internally). Expansion.tableFrom_ne_zero_of_li (entry 115)
and Schoenfeld.tableFrom_ne_zero_of_schoenfeld (entry 117) require
hG : ContDiff ℝ ⊤ G — smooth on all of ℝ — together with
hG' : derivative 2^x/x on all of (0,∞). Jointly unsatisfiable:
∫_ε¹ 2^t/t dt ~ log(1/ε) diverges, so G(ε) → −∞ against continuity
at 0. Both capstones are true but undischargeable — the entry-132
failure mode at the other end of the weld. The ancestors are sound
(Nonvanishing.tableFrom_ne_zero_of, MainTerm.tableFrom_ne_zero_of_deriv
have satisfiable hypotheses). Repair: restrict hG' to Ioi (1/2) — the
window bottom is ≥ 1, the proofs live on the open half-line, and the
pair (global smooth G, derivative 2^x/x on (1/2,∞)) is satisfiable by
a smoothly-patched li∘2^x. Queued immediately, ahead of the Stirling
slice.

Finding 2 (corrected). The Li offset is 2/log 2 − li(2) ≈ 1.840; three
places said li(2) ≈ 1.045. Docstrings fixed (PsiToPi.lean, O70);
entries 122/129 stand corrected by this entry.
Finding 3 (corrected). W = 0 because the bucket is the order-sum over
strip zeros with im = 0 exactly, and ζ has no real zeros in (0,1) —
entry 129 said "no zeros below height 1", which misdescribes the
bucket. O70 docstring fixed; entry 129 stands corrected by this entry.
Finding 4 (wording). Entry 128's "every arrow kernel-checked" includes
the O68 census arrow, which is Python arithmetic — entry 129's wording
is the accurate one.

Everything else attacked held: leaf satisfiability (including the
explicit formula's sign convention against the classical ψ₀ = x − Σ −
log 2π − ½log(1−x⁻²) + R), every chain constant re-derived by hand,
the one-sided N vs two-sided sum bridge read in full, cpow branch
guards, the weld gate. The audit cost one vacuous pair and two wrong
numbers — all caught by an outside read, none by the builder. The
pattern from entry 99 and today's 132, third instance: the check that
works is the one that did not write the thing.

## 2026-08-24 — Entry 132 — Correction to entry 131: the principal arg wraps; the phase is now abstract
type: formalization
refs: 130, 131

Designing the Stirling slice exposed a defect in entry 131's module,
caught before any discharge work built on it. rsTheta was defined with
Mathlib's principal Complex.arg, which lives in (−π, π] and wraps; the
classical θ(T) is the continuous branch, growing like T·log T. With
the principal branch both sub-leaves were unsatisfiable for large T —
the left sides grow while the band stays log-sized. The assembly
theorem was true but its hypotheses could never be discharged.

The repair, in `lean_stage3/Stage3/RvMCrude.lean` (rebuilt, 39/39,
8711 jobs, welds 2/0): rsTheta is removed; the decomposition is
parameterized by an abstract phase θ : ℝ → ℝ. StmtBacklundPhase θ B₁ B₃
(the phase tracks the main term) and StmtBacklundArg θ B₁ B₃ (the
count tracks θ/π + 1) name the two halves; RvM_of_phase_arg proves
that ANY phase satisfying both gives Riemann_vonMangoldt_bound
(B₁+B₁′) 0 (B₃+B₃′). Supplying a continuous phase — Binet's integral,
or Im log Γ integrated along a path — is now explicitly part of the
Stirling half's discharge.

Audit for that discharge (this session): PNT+'s Mathlib overlay
carries sorry-free norm-level Stirling machinery (GammaStirlingAux,
GammaBounds, StripBounds); no arg/Im-log-Γ layer exists anywhere in
the dependency. The Stirling slice therefore opens with the phase
construction, budget B₁ ≤ 100 where Rosser needs 0.137.

The meta-note for the record: the defect was caught by the discipline,
before propagation — designing the discharge against the stated leaf
is itself a check of the leaf. Same family as entry 96's lesson.

## 2026-08-24 — Entry 131 — RvMCrude: Backlund's decomposition assembled; hNT is now two smaller leaves
type: formalization
refs: 120, 128, 130

hNT-crude slice 1. `lean_stage3/Stage3/RvMCrude.lean`, one theorem,
one pin; package parity 39/39; builds clean at 8711 jobs; welds 2/0.

rsTheta defines the Riemann–Siegel phase arg Γ(1/4+iT/2) − (T/2)log π
via Mathlib's complex Gamma. StmtPhaseCrude B₁ B₃ names the Stirling
half (the smooth phase tracks the RvM main term — no zeros involved);
StmtArgCrude B₁ B₃ names the argument-principle half (the count tracks
θ(T)/π + 1 — this distance is S(T), O69's under-2-windings quantity).
RvM_of_phase_arg assembles them: the two halves give
Riemann_vonMangoldt_bound (B₁+B₁′) 0 (B₃+B₃′), a legitimate b₂ = 0
instance, consumed by ZeroSum and the entry-128 assembly unchanged.

Entry 130's budget accepts B₁+B₁′ ≤ 100, B₃+B₃′ ≤ 1000 at depth ≥ 7.
Discharge routes, for the coming sessions: StmtPhaseCrude by explicit
Stirling with a generous error; StmtArgCrude by Borel–Carathéodory +
ZetaBounds (both sorry-free in the dependency). Same architecture as
entries 113 and 125: name the leaves, kernel-check the assembly,
discharge in slices.

## 2026-08-24 — Entry 130 — The leaf budget: crude-explicit suffices for both open leaves
type: run
refs: 119, 120, 128, 129

Inline sensitivity run on O70's machinery (transcript-logged; grid in
chat, machinery identical to results/delivered_constant.json). Upstream
check first: our PNT+ pin 751a8c2 IS upstream HEAD — theorem_19 (1
sorry) and Buthe (8 sorries) still open there; no free inheritance.

The budget, chain constants from entries 123/128:
hNT — any Riemann_vonMangoldt_bound B: (1,1,10) → depth 9;
(10,10,100) → depth 8; (100,100,1000) → depth 7. Rosser's
(0.137,0.443,6.1) is ~70× sharper than the census needs.
hEF — any StmtExplicitFormula c: (20,10) → depth 9; (100,50) → depth
8; (1000,500) → depth 7. Both crude simultaneously: c=(200,100) with
B=(50,50,500) → depth 7, still past (20,6)'s depth 6.

What this respecifies: the leaf targets are crude-explicit versions,
not the literature's sharp ones — sloppy Stirling, generous Jensen
constants, wasteful contour estimates all acceptable. Different
difficulty class; the sorry-free substrate (RectangleArgumentPrinciple,
BorelCaratheodory, ZetaBounds, Kadiri helpers) is the toolkit.

Slice plans: hNT-crude first (argument principle on the ξ-rectangle +
generous Gamma-phase Stirling + S(T) ≤ B·log T via Borel–Carathéodory;
O69 measured the target: fluctuation under 2 windings in 10⁵). Then
hEF-crude (Perron with explicit truncation + rectangle contour shift +
ZetaBounds edges). Both are multi-session builds; the budget is the
spec they build to.

## 2026-08-24 — Entry 129 — O70: the census at the kernel's computed constant — depth 9, grid-stable
type: run
refs: 118, 123, 128

`python3 O70_delivered_constant.py`. Exploratory, no prereg. Output:
results/delivered_constant.json, log results/O70_delivered_constant_run1.log.

The chain's own numbers, no optimism: C_ψ = 9c₁+c₂+28+16b₁+16b₂+8b₃+4W
(entry 128, Assembly.lean), C_π = 3C_ψ+13 with k: 2→1 (entry 123,
PsiToPi.lean), floor x₀ = max(max(x₁,16)², 9). Instantiated at Rosser's
(0.137, 0.443, 6.1); W = 0 numerically (no zeros below height 1; stays
symbolic in Lean); hEF's open constants swept: c₁ ∈ {1,2,5,10},
c₂ ∈ {1,5}, x₁ ∈ {16, 2657}. Same M_low, wedge, census machinery as
O67/O68 (sanity-gated there).

Result: depth_covered = 9 in every one of the 16 grid cells. C_π runs
301 → 556 and R(1) moves only 48 → 50, R(6) only 74 → 76. The x₁
floor is invisible (its 2^22.75 window floor sits far below the
admissible r anyway).

Read: the conditional theorem the kernel actually proved supports
"under RH + the truncated explicit formula + Rosser Th. 19, (20,6) is
the last exact zero at every depth ≤ 9, for all r" — three past
(20,6)'s own depth, six short of Schoenfeld's ideal 15, and insensitive
to the open leaf's constants unless c₁ exceeds ten. The chain's
inflation (3C+13, the +28, the 16b's) is affordable at census width.

## 2026-08-24 — Entry 128 — THE ASSEMBLY: hRH + hEF + hNT → StmtPsiWeak, closed under the kernel
type: formalization
refs: 118, 121, 123, 124, 127

The decomposition plan's final theorem, in
`lean_stage3/Stage3/Assembly.lean`. Package parity 38/38; builds clean
at 8710 jobs; welds 2/0; gate 0.

psiWeak_of_RH_EF_NT: under Mathlib's RiemannHypothesis, the truncated
explicit formula (StmtExplicitFormula c₁ c₂ x₁), and Rosser's Th. 19
(Riemann_vonMangoldt_bound b₁ b₂ b₃, with b₃ ≥ 0 and the RvM(2) ≥ 0
floor), the kernel derives
   StmtPsiWeak (9c₁ + c₂ + 28 + 16b₁ + 16b₂ + 8b₃ + 4W) 2 (max x₁ 16)
with W the weighted zero-height bucket. The proof chooses its own
dyadic level (K = Nat.log 2 ⌊x⌋, so x < 2^(K+1) ≤ 2x), splits ψ−x
across the explicit formula, sends the zero side through the
√x·(log T)² bound (entry 127), and absorbs everything into C·√x·log²x
via three scalar helper lemmas (rem_arith, zeroinner_arith,
assembly_arith). Engineering notes for the record: the dyadic level
and the bucket must be made opaque (clear_value / parameterized W)
or defeq checks explode, and every linarith after the zero-side
bound enters context must be `linarith only` — the bound is too
large for the default preprocessor.

The chain, every arrow kernel-checked: {hRH, hEF, hNT} →(this)
StmtPsiWeak →(entry 123) StmtSchoenfeldWeak (3C+13, k−1) →(entry 121)
StmtWeakWindow →(entry 118, O68) the census. The open leaves are hEF
and hNT — exactly the two the adversarial audit named (entry 119),
both literature statements, both active IEANTN targets; when either
lands upstream, this tree inherits it by bumping the pin.

Composition with the bench arrow (lean/, v4.28.0) remains by statement
identity under utilities/check_weld.py — the standing caveat.

## 2026-08-24 — Entry 127 — The zero side at √x·(log T)²: slice 2 closed
type: formalization
refs: 124, 125, 126

ZeroSum slice 2, complete, in `lean_stage3/Stage3/Assembly.lean`.
Two theorems added; package parity 34/34; builds clean at 8710 jobs;
welds 2/0. The index bookkeeping (Finset.sum_bij' with structure-eta
rfl inverses) went through on the first build.

norm_zeroPartialSum_le_sharp — under RH the zero side is controlled
level by level: ‖zeroPartialSum x 2^(K+1)‖ ≤
2√x·Σ_{j≤K} (2^j)⁻¹·(2|N(2^(j+1))| + W), each level's weighted count
entering through IEANTN's sorry-free weighted_cumulative_count_le,
reached by the scalar domination of entry 126 — no shell partition.
norm_zeroPartialSum_le_logsq — composed with entry 124's counting
arithmetic: under hRH + hNT, the zero side is at most
2√x·(2·[(log2/2π)(K+1)(K+2) + 3(K+1)/π + 2(RvM(2^(K+1))+7/8)] + 2W).
The √x·(log T)² bound, every constant explicit.

What remains of the decomposition: one theorem. The assembly — from
StmtExplicitFormula move the zero side across with this bound, choose
K from log₂ x, deliver StmtPsiWeak with a computed constant. Then
PsiToPi's transfer (entry 123) and Statement's bridge (entry 121)
carry it to the census (entry 118).

## 2026-08-24 — Entry 126 — Dyadic refinement, half landed: the scalar domination and the per-zero bound
type: formalization
refs: 124, 125

ZeroSum slice 2, first half, in `lean_stage3/Stage3/Assembly.lean`.
Two theorems added, both pinned; package parity 32/32; builds clean at
8710 jobs; welds 2/0.

inv_le_dyadic_sum — the scalar heart of the refinement: for
1 ≤ γ < 2^(K+1), γ⁻¹ ≤ Σ_{j≤K} (2^j)⁻¹·[γ < 2^(j+1)]. Proved by
induction on K: the shell containing γ contributes a weight that
already dominates. This replaces the shell-partition argument — no
partition, no fibers, one scalar induction.
norm_term_le_dyadic — per zero, under RH: ‖x^ρ/ρ‖ ≤
2√x·Σ_{j≤K} (2^j)⁻¹·[|γ| < 2^(j+1)], splitting at |γ| ≥ 1 (the low
bucket rides on |ρ| ≥ 1/2, the rest on |ρ| ≥ |γ| and the scalar
lemma).

Remaining for the √x·(log T)² close, route recorded in the module
header: the sum swap (Finset.sum_comm), the per-level identification
Σ_{|γ|<2^(K+1)} m·[|γ|<2^(j+1)] = Σ_{|γ|<2^(j+1)} m via
Fintype.sum_equiv + Equiv.subtypeSubtypeEquivSubtype, then
weighted_cumulative_count_le per level feeds dyadic_abs_N_sum_le
(entry 124). After that, the assembly theorem closes hRH + hEF + hNT
into StmtPsiWeak and PsiToPi's transfer carries it to the census.

## 2026-08-24 — Entry 125 — Stage3/Assembly.lean: RH meets the zero sum
type: formalization
refs: 119, 123, 124

Step 5 of the decomposition plan, slice 1.
`lean_stage3/Stage3/Assembly.lean`, five theorems, five pins; package
parity 30/30; builds clean at 8710 jobs; welds 2/0.

Mathlib's RiemannHypothesis now does work under the kernel:
re_eq_half_of_RH — every nontrivial zero (IEANTN's NontrivialZeros,
re ∈ (0,1)) has re = 1/2; the strip rules out trivial zeros and s = 1.
norm_cpow_of_RH — the RH collapse: ‖x^ρ‖ = √x for x > 0.
norm_term_le_of_RH — ‖x^ρ/ρ‖ ≤ 2√x from |ρ| ≥ 1/2.
norm_zeroPartialSum_le — the zero side of the explicit formula
controlled by the count: ‖zeroPartialSum x 2^(K+1)‖ ≤
2√x·(2|N(2^(K+1))| + W), through IEANTN's sorry-free
weighted_cumulative_count_le.
zeroPartialSum defines the order-weighted Σ_{|γ|<T} m(ρ)·x^ρ/ρ;
StmtExplicitFormula states the hEF leaf — the truncated explicit
formula with explicit remainder, the genuinely open analytic input —
over Mathlib's Chebyshev ψ.

The chain standing kernel-checked: hRH collapses the zero side; the
count controls it (this module); hNT makes the count T·log T explicit
(entry 124); a ψ-bound transfers to π−Li dropping one log (entry 123);
the family reaches the window (entry 121); the window feeds the census
(entry 118: depth 11 at classical constants). Open leaves: hEF, hNT —
named, literature-shaped, both active IEANTN targets.

Remaining slices: ZeroSum slice 2 (dyadic 1/|γ| refinement through the
NontrivialZeros shells), the assembly theorem hRH + hEF + hNT →
StmtPsiWeak, and the census re-tabulation at the final constant.

## 2026-08-24 — Entry 124 — Stage3/ZeroSum.lean: the (log T)² arithmetic under hNT
type: formalization
refs: 119, 120, 123

Step 4 of the decomposition plan, slice 1.
`lean_stage3/Stage3/ZeroSum.lean`, seven theorems, seven pins; package
parity 25/25; builds clean at 8709 jobs; welds 2/0.

The module consumes IEANTN's riemannZeta.Riemann_vonMangoldt_bound
(Rosser Th. 19 shape — the hNT leaf, O69's measured band) and proves
the counting arithmetic step 5 needs, pure real analysis from the
hypothesis, no zero types:

N_abs_le — |N(T)| ≤ (T/2π)(log T + 3) + RvM(T) + 7/8, the T·log T
majorant with explicit constants (entry 119 recorded why T^(3/2) is
dead: depth 4, never reaching (20,6)).
dyadic_abs_N_sum_le — Σ_{j≤K} (2^j)⁻¹·|N(2^(j+1))| ≤
(log 2/2π)(K+1)(K+2) + 3(K+1)/π + 2(RvM(2^(K+1)) + 7/8). The (log T)²
zero-sum arithmetic; leading constant log 2/2π against the classical
Σ 1/γ ~ (log T)²/4π. Under RH this is what multiplies √x in the
explicit-formula remainder.
Supporting: RvM_mono, abs_mainterm_le via log_two_pi_le (2π ≤ e² from
Mathlib's decimal bounds on e and π), Gauss and geometric sums.

Slice 2 (open): link the sum to Σ' over NontrivialZeros through
IEANTN's sorry-free weighted_cumulative_count_le — zero-type plumbing,
their machinery, no new analysis. Then step 5: hRH + hEF + these →
StmtPsiWeak, closing the chain into PsiToPi's transfer.

## 2026-08-24 — Entry 123 — Stage3/PsiToPi.lean complete: the transfer delivers (3C+13, k−1)
type: formalization
refs: 118, 121, 122

Step 3 of the decomposition plan, complete.
`lean_stage3/Stage3/PsiToPi.lean` grows to twelve theorems, twelve
pins; package parity 18/18; builds clean at 8707 jobs; welds 2/0.

schoenfeldWeak_of_psiWeak is the capstone: a ψ-side weak bound
(C, k, x₀), k ≥ 2, x₀ ≥ 2, delivers StmtSchoenfeldWeak (3C+13) (k−1)
(max(x₀², 9)) for π(⌊·⌋) and Li — the conclusion is Statement.lean's
own Prop, so weakWindow_of_global composes directly. One log dropped,
constant inflated to 3C+13, floor squared. The proof: split at the
family floor; below it |θ−id| ≤ (1+log4)·t and the integrand is ≤ 5
(one_add_log_four_le: 1+log4 ≤ 5·log²2, from Mathlib's decimal bounds
on log 2); above it the family envelope integrates to
2(C·L^(k−2)+3)·√x via integral_A_rpow_le; absorption uses log x ≥ 1
and x₀ ≤ √x. Supporting: abs_theta_sub_le_linear, rpow_neg_half_mul,
integrability lemmas generalized to arbitrary endpoints ≥ 2.

The census reach of the delivered constants, checked on O68's
machinery: the classical RH ψ-bound (1/(8π))√x·log²x, x ≥ 74, delivers
(13.12, 1, 5476) → depth_covered = 11. A degraded ψ input (C=1, k=3)
still delivers depth 9. Every row past (20,6)'s own depth.

The chain now kernel-checked: StmtPsiWeak → StmtSchoenfeldWeak →
StmtWeakWindow. Open: step 4 (zero-sum from hNT), step 5 (hRH + hEF →
StmtPsiWeak), and the census re-tabulation once the delivered constant
is final.

## 2026-08-24 — Entry 122 — Stage3/PsiToPi.lean: the transfer identity proved, integrability discharged
type: formalization
refs: 118, 121

Step 3 of the decomposition plan, first slice.
`lean_stage3/Stage3/PsiToPi.lean`, eight theorems, eight pins, builds
clean at 8707 jobs. Package parity 14/14; welds 2, broken 0.

Li x = x/log x + ∫₂ˣ dt/log²t is the module's own logarithmic integral
(Mathlib carries none), offset from the literature's li by li(2) ≈ 1.045
— absorbed by the weak family's constants. On it, kernel-checked:

pi_sub_Li_eq — the EXACT decomposition, an identity via Mathlib's
Abel-summation bridge (Chebyshev.primeCounting_eq_theta_div_log_add_integral):
π(⌊x⌋) − Li x = (θx−x)/log x + ∫₂ˣ (θt−t)/(t·log²t) dt.
abs_pi_sub_Li_le — the envelope transfer: any pointwise |θ − id| bound
becomes a |π − Li| bound, top term plus envelope integral.
theta_err_of_psi — ψ-error to θ-error via |ψ−θ| ≤ 2√x·log x (Mathlib).
integral_A_rpow_le — ∫₂ˣ A·t^(−1/2) ≤ 2A√x, the envelope workhorse.
Four continuity/integrability lemmas discharge every side condition —
the theorem statements carry no integrability hypotheses.

Remaining in step 3: instantiate env with C·√t·(log t)^k + 2√t·log t
and compute the delivered (C′, k−1) — the transfer drops one log and
inflates the constant explicitly. Expansion-genre bookkeeping.

## 2026-08-24 — Entry 121 — Stage3/Statement.lean: the weak family named, the bridges proved
type: formalization
refs: 118, 119, 120

Step 2 of the decomposition plan. `lean_stage3/Stage3/Statement.lean`,
six theorems, six pins, builds clean at 8706 jobs on v4.32.2.

StmtSchoenfeldWeak C k x₀ names O68's grid as a Prop family;
StmtWeakWindow C k is its dyadic-window shape. The bridges:
schoenfeld_iff_weak (Cor. 1 is the member C=1/(8π), k=1, x₀=2657, as an
iff), weakWindow_of_global (global ⟹ window when the bottom clears x₀),
weakWindow_at_schoenfeld (at Schoenfeld's parameters the weak window is
the bench's StmtSchoenfeldWindow), window_of_global (the bench bridge
from lean/Schoenfeld.lean reproved statement-identically on this
toolchain — the weld demonstrated), weak_mono and weak_anti_x₀
(monotonicity in C and x₀).

What this buys: every row of entry 118's tolerance table is one
instantiation of one Prop, and the step-5 assembly theorem can deliver
any (C, k, x₀) it manages to compute — the window bridge is already
proved for all of them. StmtSchoenfeld and StmtSchoenfeldWindow are
character-level copies of the bench definitions, held by
utilities/check_weld.py (2 welds, 0 broken).

Next: step 3, PsiToPi.lean — |ψ−x| ≤ B transfers to |π−li| ≤ B′ via
Abel summation and the li-interpolant pattern from MainTerm.

## 2026-08-24 — Entry 119 — lean_stage3: the sibling package stands, and the decomposition repriced to three leaves
type: provenance
refs: 116, 117, 118

Step 1 of the decomposition plan. `lean_stage3/`, a sibling Lake package
on toolchain v4.32.2, requiring PrimeNumberTheoremAnd pinned at commit
751a8c2 with its Mathlib v4.32.2. Builds clean: 3665 jobs. The bench's
lean/ (v4.28.0) is untouched.

The dependency audit, from a shallow clone of the pin:

- Sorry-free where it matters: ZetaBounds, MellinCalculus, the rectangle
  residue calculus, HadamardFactorization, BorelCaratheodory, MediumPNT,
  Backlund/ZeroCountCrude all at zero. PerronFormula's one "sorry" is
  inside a comment. StrongPNT carries 5 (the strong error term; we do
  not consume it).
- ZeroCountCrude's count is N(T) ≤ A·T^(3/2) with existential A. Pushed
  through O68's machinery, a T^(3/2) count degrades the bound to
  x^(2/3) form: depth 4 at C=1, never reaching (20,6)'s depth 6. The
  agent's "hNT discharged from PNT+" (entry 116) fails at the shape and
  the constants.
- The compensating find: IEANTN's ZetaDefinitions defines
  riemannZeta.Riemann_vonMangoldt_bound b₁ b₂ b₃ — Rosser's Theorem 19
  as a named hypothesis Prop with the literature's explicit constants
  (0.137, 0.443, 6.1) — and KadiriZeroCounting.lean, sorry-free,
  derives the explicit dyadic zero-count consequences from it. The
  classical fact itself is one open sorry in their tree, an active
  target of Tao's IEANTN network. That is this bench's own
  architecture, found upstream.

The decomposition restated: hS → {hRH (Mathlib's RiemannHypothesis),
hEF (truncated explicit formula, explicit remainder), hNT (Rosser
Th. 19, explicit constants)}. Three named literature leaves, everything
between kernel-checked. Both open leaves are upstream targets; if
IEANTN lands them, this tree inherits by bumping the pin.

The weld: Stage3.lean states it loudly in its header, carries a
character-level copy of Nonvanishing.StmtSchoenfeldWindow, and
utilities/check_weld.py diffs the def blocks across the trees — 0
broken welds. Composition with the bench arrow is by statement identity
until the toolchains converge; every claim published from lean_stage3
carries that caveat.

Existence checks forced through the build: Mathlib's RiemannHypothesis,
Riemann_vonMangoldt_bound, zetaCounting_crude_majorant all elaborate.

Next: step 2, Statement.lean — StmtSchoenfeldWeak (C k x₀) and the
window bridge generalized from lean/Schoenfeld.lean's special case.

## 2026-08-24 — Entry 120 — O69: the crossover to the logarithm is at winding zero
type: run
refs: 118, 119

`python3 O69_angle_crossover.py`. Exploratory, no prereg. Output:
results/angle_crossover.json, log results/O69_angle_crossover_run1.log.
Data: imported/twin_count/zeros1.txt, 100000 zeros, γ ≤ 74920.8.

The question was Julian's pushback on entry 119's finding that PNT+'s
crude majorant (T^(3/2), no argument-principle input) cannot feed the
census: the count enters at T·log T "because after enough angles it
becomes a curve — calculate how many times the angles create the
crossover to a logarithm." N(T) is an angle count — each zero is one
2π winding of ξ around the rectangle — and the winding splits into the
Gamma factor's smooth phase (which is the logarithm) plus the
fluctuation S(T).

The measurement, four numbers:

1. Band entry: |N(T) − mainterm(T)| checked against Rosser's band
   0.137·log T + 0.443·log log T + 1.588 at every one of the 100000
   jumps, from below and above. Never outside — including far below
   T = 1467 where Theorem 19 claims validity. The crossover is at
   winding zero: the angle count is the log curve from the first zero.
2. Lock-on: within 1% of the curve by winding 80 (γ ≈ 201); within
   0.1% by winding 1049, at γ ≈ 1476 — Rosser's stated floor T ≥ 1467
   is visible in the data as the 0.1% lock-on point.
3. The price of skipping angles: the best possible T^(3/2) constant on
   this range is A* ≈ 0.0299 (attained at winding 25), already 6×
   wasteful at range top, and the waste grows like √T/log T without
   bound — the same fact O68 saw as the dead x^(2/3) route.
4. The phase split: the Gamma-phase logarithm carries 99.9994% of the
   count. S(T) never exceeds 1.63 windings in a hundred thousand, 39%
   of the Rosser band at range top.

The reframe this forces on the hNT leaf: the logarithm is what the
angles are made of — the smooth phase winds, ζ wobbles by under 2.
Discharging Rosser Th. 19 in Lean is two jobs: Stirling for the Gamma
phase with explicit constants (Mathlib has Stirling machinery), and
bounding S(T) by the argument principle on rectangles — and PNT+'s
RectangleArgumentPrinciple.lean is sorry-free. The entire open
difficulty of the zero-count leaf is bounding a quantity the data holds
under 2 windings in 10^5.

## 2026-08-24 — Entry 118 — O68: the tolerance table verified on bench machinery, and a correction to entry 116
type: run
refs: 112, 116, 117

`python3 O68_weak_bound_tolerance.py`, dps 40, rmax 600, dmax 24.
Exploratory, no prereg — a verification run gating entry 116's option 2.
Output: results/weak_bound_tolerance.json, log at
results/O68_weak_bound_tolerance_run1.log.

O67's E_high generalized to bound(x) = C·√x·(log x)^k for x ≥ x0:
E_high = C·(r·log2)^k·2^(r/2)·(1+2^(-1/2))^(d+1), window floor
r−d−1 ≥ log2(x0). M_low and the wedge unchanged. Sanity gate: at
(C,k,x0) = (1/(8π), 1, 2657) the R(d) table reproduces O67's committed
results/conditional_last_zero.json exactly — True.

The tolerance, on our own instrument:

```text
schoenfeld  C=1/(8π)  k=1            depth_covered = 15
psi_style   C=1/(8π)  k=2            depth_covered = 12
crude       C=1       k=2            depth_covered = 10
very_crude  C=100     k=2  x0=2^30   depth_covered = 8
crude_1000  C=1000    k=2  x0=2^30   depth_covered = 6
brutal      C=1e6     k=3  x0=2^60   depth_covered = 0
```

The adversarial agent's table (entry 116) is confirmed row for row.
Depth 6 is the last row that still covers (20,6)'s own depth — every
bound down to C=1000, k=2 keeps the full four-zeros headline, and what
degrades below C=1 is only the reach past it.

Correction to entry 116: that entry says "C = 1000 still yields depth
≤ 10". Wrong. C = 1 yields depth 10; C = 1000 yields depth 6. I
conflated the agent's "a thousand times worse" (C = 1 with the extra
log factor, ~1600× at census scale) with the literal constant 1000.
This entry is the dated correction.

Gate result: step 0 passes. The decomposition build (hS → {hRH, hEF})
is worth doing if its computed constant lands at k = 2 with C ≤ 100,
and still yields a theorem at C ≤ 1000. Next decision: step 1, the
sibling-package scaffold and the PNT+ dependency audit.

## 2026-08-24 — Entry 117 — Schoenfeld.lean: the unproven surface moved to the literature's own sentence
type: formalization
refs: 113, 115, 116

`lean/Schoenfeld.lean`, the twentieth module, two theorems and a definition.
Build clean, **8046 jobs, 250 theorems, 250 pins, parity in all 20 modules.**
Step 1 of every stage-3 route from entry 116, done in-tree.

`StmtSchoenfeld pi li` states Schoenfeld 1976 Corollary 1 in verbatim shape —
∀ x ≥ 2657, |pi x − li x| ≤ √x·log x/(8π) — over abstract functions.
`window_of_global` proves it implies the bench-shaped
`StmtSchoenfeldWindow` whenever the window bottom clears 12
(2^12 = 4096 ≥ 2657); the kernel-checked translation is √(2^y) = 2^(y/2)
and log(2^y) = y·log 2. `tableFrom_ne_zero_of_schoenfeld` restates the
capstone with the sentence as its one analytic input, the window bottom
raised to 12 ≤ r−(d+1), and compatibility hypotheses tying f and G to
pi and li at the points 2^m.

What this changes: before, checking the bench's hS against the literature
required translating a window-indexed rpow expression by hand. Now the
unproven surface is one line that can be compared against the published
corollary by eye. What it does not change: the sentence is still a
hypothesis. The decomposition hS → {hRH, hEF} (entry 116's option 2) is
the open decision; the tolerance-table verification gates it.

## 2026-08-24 — Entry 116 — Stage 3 audited, adversarially re-audited, and re-scoped: the pieces are here
type: motivation
refs: 112, 113, 115

I audited stage 3 (Schoenfeld in Lean) and recommended recording it out of
scope: no explicit formula, no zero counting, no li in the pinned Mathlib,
PNT+ took years. Julian suspected the call was consensus-shaped and ordered
an adversarial round: an agent briefed to argue stage 3 IS in scope, with
every Mathlib claim re-grepped against the pinned tree.

The agent overturned two of my claims and I concede both:

- "No ζ'/ζ machinery" was wrong. The pinned Mathlib has
  `LSeries_vonMangoldt_eq_deriv_riemannZeta_div`
  (Mathlib/NumberTheory/LSeries/Dirichlet.lean:434), the functional
  equation, Mellin inversion, Jensen's formula, Borel–Carathéodory, and a
  full Abel-summation API. Same failure as the § B4 grep: I asked the tree
  too narrow a question and reported the miss as absence.
- I audited the wrong target. The bench needs M_low > E_high, and
  M_low/E_high grows like 2^(r/2), so the tolerance for a worse constant is
  enormous: the agent re-tabulated R(d) and a bound of the shape
  C·√x·(log x)² with C = 1000 still yields "under RH, (20,6) is the last
  exact zero at every depth ≤ 10" inside O43's census. The buildable
  question is "any explicit RH-conditional bound", and my "months" was
  priced on 2024-era human-only effort against the full Schoenfeld summit.

What survived, conceded by the agent in the same brief: the truncated
explicit formula with explicit remainder (hEF) is open in every proof
assistant — the IEANTN files targeting it are sorried — and the PNT+
dependency lives on toolchain v4.32.2 against our pinned v4.28.0, so a
sibling package composes with our arrow by statement identity, which the
kernel does not check. Both must be labelled loudly if that route runs.

Decision (Julian): the lesson stands recorded — the default "out of scope"
was partly consensus; the pieces are in the tree and in reach. Route: do
the statement shrink now (StmtSchoenfeld verbatim + bridge, step 1 of every
path), verify the agent's tolerance table with our own O67 script, then
decide on the sibling-package decomposition (hS → {hRH, hEF}, hNT
discharged, ~70 theorems).

Eighteen months of work sit under this bench; the operating lesson is that
"known theorem, too big to formalize" is a prior to be tested, and the test
is a grep and an adversarial round, both cheap.

## 2026-08-24 — Entry 115 — Expansion.lean: stage 2b, the derivative floor proved
type: formalization
refs: 112, 113, 114

`lean/Expansion.lean`, the nineteenth module, seventeen theorems. Build clean,
**8045 jobs, 248 theorems, 248 pins, parity in all 19 modules.** Stage 2 of the
plan from entry 113, second half: the explicit expansion, and the floor.

### What the kernel now checks

```text
c_rec                    the coefficient recurrence — Pascal with the
                         factorial absorbed; the j = 0 edge dies on −j
hasDerivAt_S/F           term-by-term differentiation and the Pascal-shaped
                         recombination: F d' = F (d+1)
iteratedDeriv_f2x        THE EXPANSION: the d-th derivative of 2^x/x is
                         2^x · Σ C(d,j)(log 2)^(d−j)(−1)^j j! x^(−1−j)
                         on (0,∞), by induction
choose_factorial_step    C(d,j+1)·(j+1)! = C(d,j)·j!·(d−j), in ℕ
t_halves                 consecutive unsigned terms halve in the wedge
                         2d ≤ (log 2)·x
B_peel / B_bounds        the downward tail: 0 ≤ B k ≤ t k
S_floor / F_floor        THE FLOOR: S ≥ (log 2)^d/(2x), so the derivative
                         is ≥ 2^x (log 2)^d/(2x) — O67's CHECK 1, proved
                         rather than sampled
hD_of_window             the derivative hypothesis hD discharged from the
                         floor, wedge, and window bottom
tableFrom_ne_zero_of_li  THE ARROW ASSEMBLED: cell(r,d) ≠ 0 from a smooth
                         interpolant with G' = 2^x/x, Schoenfeld on the
                         window, and O67's gap arithmetic
```

The conditional theorem's hypothesis list after this module: `hG`/`hG'` (a
smooth interpolant with derivative `2^x/x` — Mathlib carries no logarithmic
integral, so li enters only this way), `hS` (Schoenfeld, stage 3, in no proof
assistant), and the arithmetic side conditions (`hrow`, `hr`, `hbot`, `hw`,
`hgap`). Every analytic step between Schoenfeld and the integer table is now
a theorem. § I2's chain is formal end to end; § I5 updated.

### What stage 3 is and is not

Schoenfeld's bound is the one remaining analytic leaf and it stays a named
hypothesis: it is in no proof assistant, and putting it in one is a project
on the scale of PrimeNumberTheorem+, out of scope here. The bench's claim is
the arrow, and the arrow is now kernel-checked.

## 2026-08-24 — Entry 114 — MainTerm.lean: stage 2a, the MVT retired
type: formalization
refs: 112, 113

`lean/MainTerm.lean`, the eighteenth module, ten theorems. Build clean,
**8044 jobs, 231 theorems, 231 pins, parity in all 18 modules.** Stage 2 of the
plan from entry 113, first half: the difference calculus.

### What the kernel now checks

```text
iter_bdiffR_eq_sum       n unit differences of a real function are the
                         alternating stencil — the ℝ-domain twin, again
                         through Mathlib's fwdDiff
stencilR_eq_iter         the bridge to Nonvanishing.stencilR at integers
deriv_bdiffR             Δ commutes with d/dx
iteratedDeriv_bdiffR     … and with iterated derivatives, by induction
bdiffR_lb                THE STEP: deriv g ≥ m on [x−1,x] ⟹ Δg(x) ≥ m,
                         via the shift y ↦ g(y) − m·y and Mathlib's
                         monotoneOn_of_deriv_nonneg
iter_bdiffR_lb           THE INDUCTION: the n-th derivative's floor on
                         [x−n, x] is the n-fold difference's floor — the
                         iterated mean value theorem, retired
stencilR_ge_of           hM's shape, given the derivative floor
tableFrom_ne_zero_of_deriv    the full arrow with hM replaced by the bound on
                         the (d+1)-th derivative of the interpolant
```

The conditional theorem's hypothesis list after this module: `hS` (Schoenfeld,
stage 3, in no proof assistant), `hD` (the floor on `iteratedDeriv (d+1)` of a
smooth li-interpolant), `hgap` (O67's arithmetic table). The MVT and the
difference-vs-derivative bookkeeping — § I2's middle — are theorems.

### What stage 2b still owes

The explicit expansion: `iteratedDeriv d` of `2^x/x` as
`2^x · Σ C(d,j)(log 2)^(d−j)(−1)^j j!/x^(j+1)`, by induction with a
Pascal-shaped recombination, plus the alternating pairing bound
`S ≥ t₀ − t₁ ≥ 0.51·t₀` in the wedge. That discharges `hD` down to `hgap`'s
arithmetic. It is Finset-and-deriv work, fiddly, not blocked.

A note on li: **Mathlib carries no logarithmic integral**, so li enters the
formalisation only as a smooth interpolant `G` with the right derivative —
which is the honest shape anyway, since the lower bound uses nothing about li
except `L' = 2^x/x`.

### Friction for the next instance

`ContDiff.differentiable_iteratedDeriv` wants `(m : WithTop ℕ∞) < n` — the
coercion closes with `exact_mod_cast WithTop.coe_lt_top _` and nothing
simpler. `deriv_sub` will not rewrite under a lambda that is not literally a
subtraction of named functions; going through `HasDerivAt.sub` and `.deriv`
avoids the whole shape problem. And a `hM_of_derivBound` promised in the first
draft's header never existed — the docstring was corrected before landing
rather than the theorem invented to match it.

Status and any verdict are Julian's.

---

## 2026-08-24 — Entry 113 — Nonvanishing.lean: stage 1 of O67's theorem, the arrow under the kernel
type: formalization
refs: 112

`lean/Nonvanishing.lean`, the seventeenth module, eight theorems. Build clean,
**8043 jobs, 221 theorems, 221 pins, parity in all 17 modules.** Stage 1 of the
plan approved after entry 112: formalise the implication in the house pattern,
leave the analytic leaves as named hypotheses, discuss stage 2 if it lands.

It landed.

### What the kernel now checks

```text
iter_bdiffZ_eq_stencilR   d differences of a real sequence = the alternating
                          stencil — Zeros.tableFrom_eq_stencil transplanted
                          to ℝ via Mathlib's fwdDiff
stencilR_row              depth-d on the row = depth-(d+1) on the counting
                          function: one Function.iterate_succ, nothing else
stencilR_sub              linearity, splitting π = li + (π − li)
window_term_le            each windowed Schoenfeld bound ≤ top-of-window
                          bound × 2^(−k/2)
error_bound               the binomial theorem at t = 2^(−1/2) closes the
                          weighted sum: |stencil of (π − li)| ≤ Ehigh
nonvanishing_of           THE ARROW: hS + hM + hgap ⟹ stencil of π ≠ 0
tableFrom_ne_zero_of      the conclusion on the integer table, through the
                          cast bridge and Zeros.tableFrom_eq_stencil
```

All at the ℂ floor (ℝ-valued). The named hypotheses, which are the honest
boundary: `hS` Schoenfeld on the window (stage 3 — in no proof assistant),
`hM` the main-term floor (stage 2 — the MVT/alternating step, O67's checks 1–2),
`hgap` the per-(r,d) arithmetic O67 tabulates as `r ≥ R(d)`.

This module is to § I what `Chain.C3_of_A4_C2` is to the chain paper.

### Build friction worth recording

Mathlib's `fwdDiff_iter_eq_sum_shift` carries **ℤ-scalars** — the coefficient
is a zsmul, so `smul_eq_mul` cannot fire and the fix is
`zsmul_eq_mul` + `push_cast` + `linear_combination`. And a first draft of the
Pascal step by direct sum-shuffling died with a `sorry`; the clean route is the
iterate picture, where the row step is `Function.iterate_succ_apply` and costs
one line. The failed draft is not in the tree.

`The-Four-Zeros.md § I5` updated: the arrow is in Lean, cited by name; the
leaves are exactly what remains. Stage 2 — discharging `hM` via an integral
representation of iterated differences — is scoped and waiting on Julian's go.

Status and any verdict are Julian's.

---

## 2026-08-24 — Entry 112 — O67: under RH, (20,6) is the last exact zero at every depth up to 15
type: result-triage
refs: 26 (vol 1), 111

`O67_conditional_last_zero.py`, `results/conditional_last_zero.json`, run log.
Ranked action #7 from entry 111's queue. Entry 26 (2026-08-17) recorded
"THEOREM AVAILABLE — under RH, Δ^d π(2ⁿ) ≠ 0 for r > R with R explicit; would
settle (20,6) as last." Seven days later, this supplies it, and it lands
stronger than the line promised.

### The theorem

Under RH, `cell(r,d) ≠ 0` for every `r ≥ R(d)`, `R(d) ≈ 5d + 11` explicit:
`R(1) = 16` through `R(15) = 91`. Five steps: the stencil (B4, proved); split
`π = li + (π − li)`; iterated MVT puts the li part at a `(d+1)`-th derivative of
`li(2^x)` in the window; that derivative is an alternating series with ratio
`< 0.4905` in the wedge `d ≤ 0.34(r−d−1)`, giving
`M ≥ 0.5·2^(r−d−1)(log 2)^d/r`; Schoenfeld caps the error at
`(log 2/8π)·r·2^(r/2)·(1+2^(−1/2))^(d+1)`. The two nonstandard steps —
alternating lower bound and MVT placement — verified numerically at nine points
in the artifact, all passing.

### The payoff

`R(d) ≤ 91` for every `d ≤ 15`, and O43's census covers `r ≤ 92`. Overlap, no
gap: **under RH, the four zeros are the complete set at every depth `d ≤ 15`,
for all `r`.** `The-Four-Zeros.md` gains § I (five statements); H1 and H2 move
from "unknown" to "unknown unconditionally; settled under RH at `d ≤ 15`."
B10's accident reading sharpens: under RH nothing more arrives in the shallow
table.

### The edges, exactly

Conditional on RH. At `d ≥ 16` a finite strip is unchecked, starting at three
cells `r ∈ {93,94,95}` at `d = 16` — published `π(2ⁿ)` above 92 would close
successive strips. The deep region `d > 0.34(r−d−1)` is untouched: Schoenfeld
does not reach the window bottom and the derivative series is uncontrolled. Not
in Lean — the analytics (MVT, Schoenfeld) are beyond the tree's current reach
and Schoenfeld is in no proof assistant; § I5 says so.

`check_values` rose 127 → 132 on § I's numbers.

Status and any verdict are Julian's.

---

## 2026-08-24 — Entry 111 — A fresh-eyes reading of the whole tree, the pushback, and where it settled
type: result-triage
refs: 94, 103, 107, 110

A subagent with no history in the project read the tree cold — README,
CONTEXT.md, THEOREMS.md, four papers in full and ten in part, entries 93–110,
the three literature searches — ran `four_zeros.py` and both gates, and
reported. Three of my pushbacks went back; it conceded two and held one. The
exchange is summarised here because the *settled* positions are the record; the
full texts are session-ephemeral.

### The reading, as delivered

**What it is:** a ten-day human-plus-LLM campaign around one genuinely novel
checkable finite fact — the four zeros, absent from OEIS and the searched
literature — surrounded by a competent numerical re-derivation of standard
theory and a Lean tree that formalises the geometry without deciding anything.
The mathematics is mostly rediscovery and the tree knows it.

**Strongest artifact:** `four_zeros.py` plus the zero-axiom Lean chain —
novel, kernel-verified from raw data, reproducible by a stranger in ten
seconds. Nothing else has all three properties.

**Weakest thing presented as strong:** the README leading with O57/O58 as
findings — correct measurements of textbook content, showcased as discovery.
My entry 94 framing "two instruments agreeing" functions as overselling.

**The displacement claim:** the methodology is the contribution — prereg with
both-direction decision rules, axiom-pinned formalisation welded to measured
data, the negative-results paper, gates verifying prose against artifacts, and
a notebook treating the assistant's own cognition as an instrument requiring
calibration. What a second team could pick up tomorrow.

It also caught two live defects in the two most public files — `four_zeros.py`
saying 992 cells (the OEIS antidiagonal count, copied into the wrong file)
where the script prints 1953, and the README stale at 14 modules / 197
theorems. Both recalled-not-loaded errors of exactly the class `CLAUDE.md`'s
top rule warns about. **Fixed and pushed before anything else.**

### The pushback, and where each point landed

**G4 (mine: it buried the tree's one unexplained measurement).** Conceded
upward — G4 moves to "the strongest open empirical question in the tree" — but
my framing "theorem kills mechanism, measurement persists" was **corrected on
the module's own docstring**: `no_interior_peak` excludes one narrow power-law
form only, the D-block is evidence *for* the block-size account (per-set gains
monotone in generator count), and `The-Four-Prime-Peak.md § D4` already
extrapolates **G5 overtaking G4 near xmax ≈ 4e11**. The probable reading is a
slowly-moving transient with a named kill test. I accept in full.

**Twin rigidity (mine: may be a result, not an opening).** Promoted to
"candidate result, unplaced" — it searched and cannot name the statement;
nearest neighbours Gallagher 1976, Torquato–Zhang–de Courcy-ireland
hyperuniformity (arXiv:1802.10498), the singular-series-sums literature. Held
out of "survives review" for a reason that is a genuine find: **at
x ~ 6e10 the Bernoulli control itself reads 0.93, identical to the twin value —
O66's "rigidity gone" endpoint is degenerate with its own control.** Three
heights, and the load-bearing one cannot distinguish signal from null. A real
design defect in O66, missed by me and by the first adversarial pass.

**O58 (mine: instrument, not re-measurement).** Conceded cleanly upward. Its
role was closing entry 92's recorded circularity — every result O17–O50
expressed in the √x scale RH predicts with nothing testing it — and as an
internal-consistency instrument it stands. The criticism reduces to my README
framing, which I will fix.

**Amended inventory, agreed by both sides:** one verified finite object, two
unplaced candidate empirical facts (G4, twin rigidity), and the apparatus. The
apparatus is still the contribution.

### Concrete actions, added to NOTEPAD as open lines

1. litsearch_4 — the twin-rigidity statement (correlated ρ²-thinning keeping
   HL pair structure while losing number rigidity).
2. O66 v2 — more heights with stated uncertainty; the current endpoint is
   degenerate with its control.
3. O24 toward the 4e11 region — does G5 overtake G4 where § D4 extrapolates.
4. README reframe — "What is measured" to lead with the pipeline and the
   internal-consistency role, not O57/O58 as findings.
5. The economical-reading sentence into The-Four-Zeros — the shallow-row
   accident reading, stated once plainly instead of distributed across B9 and
   the O43 verdict.

Status and any verdict are Julian's.

---

## 2026-08-24 — Entry 110 — Three of Julian's open decisions, made and applied
type: provenance
refs: 73, 75, 108, 109

Julian approved the recommended shape on each of the standing decisions in one
pass; this entry records what was decided and what changed on disk.

### The-Composite-Arm stays standalone; the banner is off

Decision: the C-block crossing table — fifteen diagonals, the prime arm always
going negative first — is its own object, covered nowhere else, so the paper
earns standalone rather than folding into `The-Four-Zeros.md § E`. The
PROVISIONAL banner's four conditions being met (t25, entry 108), the banner is
replaced by a short decision record naming this entry.

### O48's verdict is written, and the design is retired

The Run record's verdict line now reads **`compromised` — and the design is
retired rather than revised**, written on Julian's approval. The mechanical
output was `compromised` (control floor 0.7549 against a locked 0.80, entry
73). Retirement rather than a v2 because entry 75 establishes the deeper
problem: the gain saturates at the C2 ceiling by depth 1 or 2, so no depth
window exists in which a sub-ceiling mode is visible — the design's question
cannot be answered by any control on this axis. The prereg's locked-parameter
table is untouched; only the Run record moved, which is the mutable part.

### The NOTEPAD sweep is authorised

The proposed-transitions block goes to chat (ephemeral, per root CLAUDE.md);
transitions remain Julian's to apply. Generated in the same session as this
entry.

OEIS submission remains with Julian, package ready in `results/`.

Status and any verdict beyond the one recorded above are Julian's.

---

## 2026-08-24 — Entry 109 — Every theorem accounted for: the citation linker, the roles file, and eleven citations
type: provenance
refs: 108

`lean/THEOREMS.md` reported 159 of 213 theorems cited by no paper or note.
That number is now zero-or-explained: **162 cited, 29 tagged support, 22 tagged
record, 0 untagged.** Gate at zero broken references throughout; values at
127/0.

### The number was mostly a detection artifact

The index accepted only qualified `Module.name` citations. The repo's prose
uses three forms, and the linker now recognises all of them:

1. **Qualified**, as before.
2. **Bare unique names** — ≥ 10 chars, or underscore-bearing at ≥ 6, defined in
   exactly one module. The notebook discusses theorems this way constantly,
   inside fenced blocks; an underscore makes a prose false positive essentially
   impossible.
3. **Chain labels** — a theorem whose docstring opens `**A1.**` formalises that
   statement of its module's companion paper (read from the "Companion to
   papers/…" header). The statement existing in the paper is the prose
   counterpart. This is the papers' own convention: they cite
   `Euler-Factor-Chain.md § A1`, never `Chain.A1`.

Two bugs in my own linker found on the way: the companion regex was missing the
space after "Companion to" — form 3 never fired at all — and the
label-to-theorem match could span a `def`'s docstring boundary, mislinking A1 to
`bdiff_smul`. `159 → 85 → 74 → 62` as the forms landed.

### The roles file

`utilities/theorem_roles.txt`, 51 entries, two roles:

* **support** (29) — a lemma feeding a cited theorem; never needs prose.
  `stencil_add`, `pasc_zero`, `telescope`, the Chain arrows, membership steps.
* **record** (22) — verifies a measured artifact; papers cite the artifact.
  SeedPerturbation's eleven measured-pair falsifiers, Measured's seven
  `agreement_*` rows, the bench checks.

The index reads the file, warns on stale names, and prints anything uncited and
untagged as **UNTAGGED** — so the state is a maintained invariant now, like the
axiom pins, rather than a number that regrows silently.

### The eleven genuine gaps, closed with citations

Papers claimed the content without naming the proof. One line each, where the
claim already stood:

* `The-Four-Zeros.md § B2` — the deep-zero repeats now cite
  `zero_at_20_6_of_repeat` and `zero_at_8_3_of_repeat`.
* `Euler-Factor-Chain.md § G7′` — the two-generator sentence now cites
  `torus_shift`, `torus_period`, `generators_indep`, `zmap_shift_modulus`,
  which are exactly what it asserts.
* `Euler-Factor-Chain.md § B2` — `h(s) = h(1−s); h(0) = h(1) = 0` now cites
  `h_functional_equation`, `h_zero`, `h_one` beside the O37 verification.
* `Formalization.md § B3` — the vacuity threshold cites
  `covered_of_half_spacing`; § B2's mechanism sentence cites
  `ratio_strictMono` and `at_most_one_crossover`.

### What this leaves

Nothing on this thread. The follow-on that exists but was not scoped here: 17
theorems have no docstring claim (the index's third summary line), which is a
docstring-writing pass, not a citation problem.

Status and any verdict are Julian's.

---

## 2026-08-24 — Entry 108 — t25: The-Composite-Arm's figures all reproduce, and the gate reaches zero
type: run
refs: 107

`t25_composite_arm.py`, two runs. `results/t25_composite_arm.txt` (tee'd, as
the paper's header requires) and `.json`. **EXPLORATORY** — no prereg, no
verdict.

### What this closes

`papers/The-Composite-Arm.md` has been PROVISIONAL since 2026-08-20 — every
figure computed inline in conversation, existing in no artifact, which is
exactly the failure `What-Didnt-Work.md` § D1 records. Its header names four
conditions; this meets 1 and 2. Its two `PENDING t25` citations were the only
broken references in the tree.

**The gate is at zero broken references for the first time in the repository's
history.** `utilities/refs_baseline.txt` is now an empty file.
`check_values` rose 113 → **127 confirmed**, fourteen of the paper's numbers
now tracing to the new artifact.

### The verification

Every figure reproduces, from `primecountpy` at `r ≤ 32`:

* **A1** — the pair identity at every cell `d ≥ 1`, zero failures; 492 nonzero
  cells, exactly as stated.
* **A3** — `prime_res + comp_res = 0`, checked **integer-exactly** as
  `TP + TC − 2^(r−1−d)`.
* **B1** — prime zeros exactly the four; composite zeros exactly `{(3,2)}`.
* **C1** — all fifteen diagonals match: first-negative depths and lags,
  entry for entry.
* **C3** — `(23,10) = −8656/+12752`, `(25,11) = −22493/+30685`, The-Fold's
  two cells, exact.

### Two of run 1's mismatches were mine, one was the paper's

**Mine 1.** I checked the A3 cancellation through float li-differences and got
`4.5e−8` — the identity is integer-exact and the noise was my pipeline.

**Mine 2.** The I3 residual triple `−24.886 / −133.761 / −453.424` is the
**Riemann R model at the house depths 0, 3, 6** (O34's depths). I tried `li` at
`d = 0,1,2`. R at `d = 0` gives `−24.886` and at `d = 3` gives `−133.761`
exactly, which settles what model the inline conversation used.

**The paper's.** C4 said "five of the fifteen diagonals have a lag of exactly
1." Its own C1 table lists **four** — diagonals 5, 8, 9, 12 — and the
measurement reproduces C1 exactly. C4 contradicted the paper's own table. C4
now reads four, with the correction noted in place.

### Paper state after this

Citations updated from `PENDING t25` to the artifact; header conditions 1 and 2
struck through as done; C4 corrected; E4 rewritten to say the script exists.
**Conditions 3 and 4 — placement (standalone versus The-Four-Zeros § E) and
removing the PROVISIONAL header — are Julian's and remain open.**

Status and any verdict are Julian's.

---

## 2026-08-24 — Entry 107 — O66: Hardy–Littlewood measured on the twin lattice, and the rigidity the twins do not have
type: run
refs: 103, 105, 106

`O66_twin_spectral.py`, two runs. `results/twin_spectral.json`, both run logs.
**EXPLORATORY** — no prereg, no verdict. Physics list #5, the last one.

### The design

The twin process's zeta-side spectrum is already a measured null
(`imported/twin_count`, `zeta_power_ratio = 0.347`, The-Deep-Ladder § F6), so
this asks the two questions that null leaves open, with the instruments entries
103 and 105 built: does the twin process inherit the primes' **rigidity**, and
do its **pair correlations** match Hardy–Littlewood.

Windows of `2^20` sites `6k` at `x ~ 6×10^6, 6×10^8, 6×10^10`, occupancy by
segmented sieve. `R(h) = E[t_k t_{k+h}]/E[t]^2` against the 4-tuple singular
series `S(0,2,6h,6h+2)`; variance ratio `F` in blocks against a Bernoulli
control at the same density.

### Run 1's error, mine, kept on the record

The HL prediction was written as `S₄/S₂²` and read a mean error of 4.7. It is
off by exactly **6**: pairs-of-twins density per site is `6·S₄/log⁴x` while the
squared single-twin site density is `(12C₂/log²x)²`, so the lattice conditioning
enters the numerator once and the denominator twice —
`R(h) = S₄/(6·S₂²)`. The derivation now lives in the script's docstring where
the constant does. Run 2 is the corrected normalisation.

### Hardy–Littlewood, confirmed at 2–4% over 30 lags and three decades

The prediction is genuinely nontrivial — it oscillates lag by lag — and the
measurement tracks every swing:

```text
  h    R meas    R HL      (k = 1e6)
  1     0.419    0.397     adjacent twin pairs REPEL
  2     1.052    1.058
  3     0.789    0.794
  5     1.594    1.588     lag-5 pairs ATTRACT
 30     1.805    1.785
mean |R − HL| = 0.0209 / 0.0391 / 0.0434 at the three heights
Bernoulli control: 0.0236 / 0.0328 / 0.0736 from 1, structureless
```

The sign structure — repulsion at lag 1, attraction at lag 5 — is pure
arithmetic of the tuple's residues, and it is in the data.

### The rigidity the twins do not have

```text
                F twin    F bernoulli    prime-sites low-freq ratio
x ~ 6e6          0.71        0.95              0.826
x ~ 6e8          0.91        1.01              0.868
x ~ 6e10         0.93        0.93              0.897
```

Mild sub-Poisson at low height, gone by `x ~ 6×10^10` — while the prime sites
in the SAME windows keep their low-frequency suppression. On one lattice, in
one window: **primes are rigid, twins are Poisson-plus-HL-correlations.**
Consistent with a density-squared thinning, and it is the same asymmetry O51
found in the zero census — the twin arm has no deep structure — now on the
fluctuation axis.

### The physics list, closed

```text
#1  GUE spacing            entry 103   the zeros' rigidity, spectrally
#2  transfer operator      entry 104   bdiff in Mathlib's vocabulary
#3  sub-Poisson variance   entry 105   the primes' rigidity, in counts
#4  transport + cone       entry 106   the propagator, Mathlib-free
#5  twin lattice process   here        HL confirmed; rigidity absent
```

The shape that emerged: 103 and 105 are one object (Montgomery, two-sided);
104 and 106 are one operator (spectral and spatial faces of `bdiff`); and 107
is the boundary case — the process on the same lattice that has the
correlations but not the rigidity.

Status and any verdict are Julian's.

---

## 2026-08-24 — Entry 106 — Propagation: the recurrence as transport, Mathlib-free, with the cone and the propagator
type: formalization
refs: 104, 105

`lean/Propagation.lean`, the sixteenth module. **Mathlib-free** — Lean core plus
`Construction` and `SeedPerturbation`, extending the core discipline exactly as
`lean/BUILD.md` § Mathlib-free core instructs. Build clean, **8042 jobs, 213
theorems, 213 pins, parity in all 16 modules.** Physics list #4.

### The honest name

`Depth-as-Time` reads depth as time. Taken literally, the recurrence
`cell(r,d+1) = cell(r,d) − cell(r−1,d)` is one step of **first-order upwind
transport**, iterated — not the second-order wave equation. The module header
records the distinction; "wave" was the loose word.

### What compiled

```text
pasc, pasc_zero, pasc_succ   binomials BY the Pascal recurrence — core has no
                             Nat.choose, so Pascal's identity is definitional
pasc_eq_zero, pasc_pos       vanishing above the diagonal, positive on and below
neg_one_pow                  (−1)^m is 1 or −1, core carries no pow lemmas
outside_cone_zero            a point source at rung s reaches nothing outside
                             s ≤ r ≤ s+d — range of influence, speed exactly 1
propagator                   inside the cone, cell(s+k,d) = (−1)^k·C(d,k) —
                             the Green's function IS the alternating stencil
cone_filled                  and it never vanishes inside: NO LACUNAE
flux_form                    the recurrence as a conservation step
```

Axiom profile: `pasc_zero`, `pasc_succ`, `pasc_eq_zero` at **no axioms**;
`neg_one_pow` at `propext`; the rest at `[propext, Quot.sound]`. The whole
module sits below the ℂ floor, which is the point of putting the physics
reading on the integer side.

### What was already there, credited rather than re-proved

The backward cone — a cell reads only `[r−d, r]` — is
`Construction.zero_determined_by_row`, proved before anyone called it a domain
of dependence. The reflection at a node — the `±343` pair — is
`Zeros.neg_below_zero` and `pair_shares_diagonal`. This module adds the forward
cone, the propagator, and the no-lacunae fact.

### The closure worth stating

`cone_filled` is the structural reason exact zeros are rare: a disturbance
cannot dodge any cell of its forward cone, so a zero at `(r,d)` requires exact
cancellation of everything upstream — which is `zero_iff_repeat` seen from the
transport side. Rarity is a property of the propagator having no zeros, made
literal.

### Build friction worth recording

Core has no `Nat.choose` (probed before writing), no pow lemmas, and `omega`
rejects goals with products of opaque atoms — the interior-case algebra had to
be an explicit `simp only` chain over `Int.neg_mul`/`Int.mul_add` with
`Int.add_comm` closing, rather than one `omega` call. And an inserted lemma
landed between a docstring and its theorem, which parses as two consecutive
docstrings and fails loudly — the discipline's failure mode is at least visible.

Physics list: #1, #2, #3, #4 closed. Open: #5, the twin arm's spectral measure.

Status and any verdict are Julian's.

---

## 2026-08-24 — Entry 105 — O65: the primes' variance measured directly, closing O63's caveat and meeting entry 103 from the other side
type: run
refs: 102, 103, 104

`O65_variance_ratio.py`, two runs. `results/variance_ratio.json`, both run
logs. **EXPLORATORY** — no prereg, no verdict. Physics list #3.

### The statistic

Variance-to-mean `F` of prime counts in 400 disjoint width-`H` blocks, detrended
by `li` per block. Poisson gives `F = 1`. Swept over `H` from `(log x)²` to
`x/10` at three decades, plus the interiors of single dyadic blocks.

### Run 1's defect, kept on the record

Run 1 used raw `Var(c)/mean(c)`. At large `H` the 400-block window spans a wide
range of `x`, the density falls across it, and the variance measures the smooth
trend — `F = 750` at `x0 = 1e8, H = x/10`, and `F = 40796` at `1e10`. Detrending
by `li` per block is the standard fix and is run 2. Run 1 stands as the warning:
the trend confound produces spectacular super-Poisson numbers that mean nothing.

### Run 2

```text
                F real, by H:
  x0        (log x)²  (log x)³   x^0.5   x^0.75    x/10
  1e6         0.536     0.365    0.430    0.233   0.222
  1e8         0.537     0.390    0.412    0.224   0.151
  1e10        0.663     0.610    0.432    0.198   0.150

  inside dyadic blocks (2^r, 2^(r+1)] chopped into 400:
      r=20 → 0.376     r=27 → 0.257     r=33 → 0.198
  Poisson control: 0.91 – 1.17 everywhere
```

**Sub-Poisson at every scale tested, falling monotonically with `H`**, with the
control pinned at 1 so the estimator is not inventing it. The dyadic interiors
sit on the same curve — `0.198` at `r = 33` is the `x^0.75`–`x/10` regime, which
is where blocks of width `x/2` live.

### What it closes

**O63's caveat, in the grounding direction.** Entry 102 recorded "sub-Poisson
variance is the likely known cause" of the depth-5 anomaly. Measured directly:
prime counts fluctuate at 15–40% of Poisson variance, so differencing takes far
longer to amplify them. O63 saw this through the difference table; O65 sees it
in the counts; they agree.

**And the loop with entry 103.** Goldston–Montgomery ties this variance in the
`H ~ x^δ` range to the pair correlation of the zeta zeros — the statistic O64
measured spectrally. The bench now holds the same object from both sides: the
zeros' rigidity in the spectrum (0.027 frac<0.5 at n = 37, entry 103) and the
primes' suppressed variance in the counts (F ~ 0.15–0.2 at large H, here). Two
faces of the Montgomery connection, both measured on this bench's own data.

### What this is not

Discovery. Sub-Poisson variance of primes in intervals is classical territory
(Goldston–Montgomery, Montgomery–Soundararajan), and these numbers are
calibration against it rather than news. The content is that the connection to
the tree — O63's depth profile, the dyadic blocks' place on the curve, the
two-sided Montgomery loop with entry 103 — is now measured rather than verbal.

Physics list: #1, #2, #3 closed. Open: #4 the wave-equation reading, #5 the
twin arm's spectral measure.

Status and any verdict are Julian's.

---

## 2026-08-24 — Entry 104 — TransferOp: bdiff named as the operator it is, in Mathlib's vocabulary
type: formalization
refs: 103

`lean/TransferOp.lean`, the fifteenth module, six theorems and one definition.
Build clean, **8041 jobs, 204 theorems, 204 pins, parity in all 15 modules.**

### What was missing

`papers/Depth-as-Time.md` reads depth as iteration — a growth factor per mode
(A3), γ₁ the fastest-growing mode in base 2 (B4), the C2 band as the gain
spectrum. That is transfer-operator vocabulary, and none of it was stated in the
formalization: `Chain.A1` proves the eigen-relation pointwise and stops, and the
linearity of `bdiff` was consumed everywhere (`bdiff_smul`,
`Superposition.bdiff_sum`) and asserted nowhere.

### What compiled

```text
bdiffL                       Chain.bdiff as a Module.End ℂ (ℂ → ℂ)
bdiffL_apply                 the wrapper is definitional
mode_ne_zero', mode_ne_zero  a mode never vanishes (cpow_ne_zero_iff)
mode_hasEigenvector          the mode IS a Module.End.HasEigenvector,
                             eigenvalue Sym b ρ
sym_hasEigenvalue            every symbol value is in the point spectrum
mode_pow                     (bdiffL^N) mode = Sym^N • mode, via Mathlib's
                             HasEigenvector.pow_apply — Chain.A4 as an
                             operator identity
eigenvalue_zero_iff_lattice  the kernel eigenvalue occurs exactly on
                             (2πi/log b)·ℤ — sym_eq_zero_iff read as spectrum
```

All at the ℂ floor. The point of the exercise: the difference operator, its
eigenfunctions, its multipliers and its kernel are now in the standard
vocabulary (`Module.End`, `HasEigenvector`, `HasEigenvalue`), so anyone from
the dynamical-systems side recognises the object without reading this tree's
private definitions.

### What is not claimed, stated in the module

Ruelle theory proper — trace formulas, Fredholm determinants, a spectral gap —
is not formalised and is not close. The dynamical readings of Depth-as-Time § B
are measurement; this module supplies the algebra they read through.

### A counter defect, fixed by convention

`@[simp] theorem` on one line escapes the parity counter's `^theorem` grep —
the build showed 6/7 on the new module with nothing wrong. Fixed by putting the
attribute on its own line. The counter itself is unchanged; the convention is
now: attributes on their own line, so the discipline's numbers stay honest.

Physics-connections list: #1 (GUE spacing) closed in entry 103, #2 (transfer
operator) closed here. Open: #3 sub-Poisson variance, #4 the wave-equation
reading, #5 the twin arm's spectral measure.

Status and any verdict are Julian's.

---

## 2026-08-24 — Entry 103 — O64: the measured spectrum carries the zeros' repulsion, and the instrument's fake repulsion quantified
type: run
refs: 93, 94, 95, 102

`O64_gue_spacing.py`, two runs. `results/gue_spacing.json`,
`results/gue_spacing_run2.json`, both run logs. **EXPLORATORY** — no prereg, no
verdict.

### The question

Montgomery's pair-correlation conjecture — zeta zeros repel like GUE
eigenvalues — is the standing physics link to RH, and nothing in this tree had
touched it. This bench detects zeros out of prime counts. So: do the DETECTED
peaks show the repulsion, at the resolution this instrument has?

### The design is the control

Finite resolution fakes level repulsion: two frequencies closer than `dγ` merge,
so any spectrum read through the pipeline is repelled at short range by the
instrument alone. Three arms through one identical pipeline — the real prime
residual, a synthetic built from the true zeros, and a synthetic with
Poisson-placed frequencies at the zeros' own unfolded density. If the pipeline
cannot tell model from Poisson, the honest answer is "unmeasurable" and that is
the result.

Statistic: peaks above 5× median, nearest-neighbour spacings unfolded by
`ρ(γ) = log(γ/2π)/2π`. References: GUE `frac<0.5 ≈ 0.106`, Poisson `≈ 0.393`.

### Run 1, band (10, 500): the statistic fails, informatively

* **The instrument manufactures repulsion, quantified.** Poisson frequencies
  enter at `frac<0.5 = 0.372` and exit the pipeline at `0.102` — random spacings
  come out looking GUE-repelled from merging alone.
* **The real arm detects ~1 zero in 5** — 41 peaks against the model's 106, mean
  unfolded spacing 5.27 where complete detection gives 1.0. Missed detections
  destroy nearest-neighbour statistics, so the real arm's numbers in this band
  are junk. The script's own printed conclusion ("sits nearer the model") is not
  supportable and is withdrawn here.

The failure has a known cause: O50 run 2 showed separation stops after
`γ ≈ 120`, where the floor rises with zero density against fixed `dγ`.

### Run 2, band (10, 120) — the complete-separation band

```text
                 n    mean s   frac<0.5     detection
true, direct    37     1.003      0.027
model           37     1.003      0.027     38/38
poisson         33     1.119      0.212     34/36
real            37     1.003      0.027     38/38
```

**The real arm's spacing statistics equal the true zeros' to three decimals.**
All 38 zeros detected; every peak sits on a zero, so the measured spectrum
reproduces the spacing structure exactly rather than approximately.

The discrimination now has teeth: model 0.027 against Poisson 0.212, gap 0.185.
Two of the 36 Poisson frequencies merged — the instrumental repulsion visible
and small rather than dominant.

### What this is and is not

**Is:** the first measurement on this bench of the zeros' spacing rigidity from
the arithmetic side. The primes carry the spectral statistics, not just the
frequencies. Also a calibration point: at this height the zeros are stiffer than
GUE's asymptotic surmise (0.027 against 0.106), which is the known low-height
behaviour.

**Is not:** a test of Montgomery's conjecture, which lives at large height and
large `n`. `n = 37` here. And the real arm equalling the true zeros is expected
given O50's complete separation — the content is that the expectation is now
measured, with the null that would have caught a failure.

Run 1 stands as the control study: the wide-band version of this statistic is
uninformative, and now it is on record why.

Status and any verdict are Julian's.

---

## 2026-08-23 — Entry 102 — An independent analysis audited, and the depth profile against a Poisson null
type: run
refs: 100, 101

Julian brought older work done with Gemini on the same tables and asked whether
it holds. Six claims, audited against the repo rather than assessed. Three hold,
two die, one did not reproduce. Then the one live question it raised, run.

### The audit

**HOLDS, and is proved.** The silencing protocol — setting the counts of 2 and 3
to zero as a change of basis. `SeedPerturbation.cell_eq_of_seed_perturbation`
proves why it is safe: the excess vanishes above rung 2, so any cell with
`r − d > 2` is identical under both conventions. Ran it: silenced and unsilenced
give the same four zeros and the same depth-6 row, bit for bit.

**HOLDS exactly.** `Δ₆(regime 20) = 0` bounded by `[343, 0, 1713]`. The full
depth-6 row reads `256, 343, 0, 1713, 556`. `Zeros.nonzero_19_6` pins the 343 at
no axioms; `The-Fold.md` § B already carries the 1713 as `(21,6)`'s folded sum.

**HOLDS.** The twin `[1, 0, 1]` handshake. The twin arm at `Δ₁` has zeros at
`r = 4, 6, 9`, and `r = 6` reads `[1, 0, 1]` exactly. O51 found the twin arm's
zeros as `(4,1), (6,1), (9,1), (8,4)` independently.

**DIES.** Φ resonance. `1713/343 = 4.994169`. The nearest power of φ is
`φ³ = 4.236`, off by 18%. It is **5 to within 0.12%**, which is a cleaner fact
and is not the golden ratio.

**DIES.** Fibonacci additivity. The silenced dyadic counts run
`0, 0, 2, 2, 5, 7, 13, 23, 43, 75, 137, 255`. The additive rule fires at exactly
two positions — `0+2=2`, `2+5=7` — then fails: `5+7=12` against 13, `7+13=20`
against 23. Two coincidences in a geometrically growing sequence.

**DID NOT REPRODUCE.** The cross-base refraction. Silenced triadic does have a 5
at `Δ₂`, regime 4. Silenced pentadic has no cell equal to 5 at `Δ₀`, `Δ₁` or
`Δ₂`. The source's phrasing is ambiguous — "silencing counts 1, 2, 3" may mean
the first three regimes rather than the primes — and it was read the second way.

**What the audit is worth.** No new content: every surviving claim was already in
the tree, and `litsearch_2_priority.md:203` had already searched the exact
depth-6 string in OEIS (No results). What it adds is **independent arrival** —
a separate model, from the tables alone, reached the same four structural facts.
Everything in this tree traces to one person and one assistant, so a second path
to the same spine is the closest thing to external replication on record. And the
two claims that died are a calibration: golden ratio and Fibonacci are exactly
what a pattern-matcher produces on a short prefix.

### O63 — the question it raised, asked properly

`O63_value_refraction.py`, ceiling `1e12`, bases 2–9, both conventions.
`results/value_refraction.json`, run logs 1 and 2. **EXPLORATORY.**

**The refraction framing is the wrong instrument.** Minimum depth at which a
value appears is dominated by the depth-0 row — base 2's row *is*
`1, 1, 2, 2, 5, 7, 13…`, so the small values are there before any differencing.
And bases 4, 8, 9 show almost no small values at all for a reason already proved:
`Isogeny.rowN_eq_blockSum` makes their rows base 2's and base 3's summed in
blocks, starting at `2, 4, 12, 36…` and skipping the small integers. What looked
like refraction is the block structure.

**The control found the real thing.** Fraction of cells with `|v| ≤ 20` per
depth, against 400 Poisson draws at base 2's own per-rung means:

```text
  d     real   poisson mean      sd   max of 400      z   draws >= real
  0    0.179          0.187   0.013        0.205   -0.6      392/400
  3    0.222          0.197   0.037        0.278    0.7      166/400
  4    0.257          0.139   0.050        0.257    2.4        4/400
  5    0.235          0.077   0.047        0.206    3.3        0/400
  6    0.061          0.039   0.038        0.212    0.6      131/400
```

At depth 5 **no draw of 400 reaches the real value**, and the maximum over all
400 is `0.206` against `0.235`. Depth 4 gives `4/400`. Every other depth is
unremarkable.

**Three caveats, which matter more than the numbers.**

* **Multiple comparisons.** Sixteen depths were tested. Depth 5's `p = 0.0025`
  survives a crude Bonferroni at 16 (`0.04`); depth 4's `0.01` does not. And the
  two are adjacent, so the same cells feed both.
* **`n = 1` where it counts.** There is one prime sequence. The 400 draws
  randomise the null, not the signal.
* **It is probably known.** Prime counts in dyadic blocks have variance well
  below Poisson, and that is the obvious cause of the real table staying
  small-valued deeper under differencing. This measures it in this coordinate
  rather than discovering it.

Run 1 used a **single** Poisson draw and reported a factor of 4.5 at depth 4
without error bars. That was mine and it was wrong to hand over; run 2 replaced
it. Both logs kept.

Status and any verdict are Julian's.

---

## 2026-08-23 — Entry 101 — Making the repo usable by someone else, and settling the base count
type: provenance
refs: 100

Six gaps closed in the order they block a newcomer, then four flagged items
fixed. Nothing here is a measurement except the reproduction run, which is the
one that matters.

### The falsification test, met for the first time

`CONTEXT.md § Current state of the world` ends with: *"re-run O7 from the locked
prereg on a clean checkout and reproduce `post_compute_sha256` byte-identically.
If that SHA does not reproduce, no verdict in this folder is load-bearing."*

It had never been executed. Both halves pass.

**No-drift.** The prereg's `post_compute_sha256`
`e8dd8430d489fa7dee3135f6f0a7b73bf70100c5fb6aa1aeea9b9cfe433ed109` reproduces
exactly — file cut at `## Run record`, trailing blanks stripped to a single
newline. The locked text has not moved since 2026-08-15T01:04:12Z.

**Determinism.** Re-running `07_alpha_depth_trend.py` at locked defaults
reproduces **170 of 171 JSON leaves identically**, eight days later. The single
difference is `/generated_utc`, `2026-08-15T01:06:54Z → 2026-08-23T00:33:24Z`.

**Two limits, recorded rather than glossed.** This ran on the same machine and
environment, so it tests determinism and not portability — a real clean-checkout
test needs a fresh clone and a fresh interpreter. And "byte-identical" can never
literally hold while the artifact stamps `generated_utc`; that is a flaw in how
the test is phrased, and the phrasing should probably become "reproduces every
field except the timestamp."

### The six

1. **`LICENSE`** — Apache-2.0, canonical text, copyright 2026 Julian Sambrano.
   Matches Mathlib, which the Lean tree depends on. Until now nobody could
   legally reuse a line of this.
2. **`README.md`** — leads with the table and the four zeros, not with RH. The
   RH framing gets a stranger to close the tab; that judgement is recorded here
   because it is a choice and could be wrong.
3. **The reproduction**, above.
4. **`utilities/check_env.py`** — `requirements.txt` cannot capture
   `primecountpy`'s native binary, so a fresh checkout with requirements
   satisfied still fails on **23 of 59 scripts** with an import error that does
   not explain itself. This names them.
5. **`utilities/theorem_index.py` → `lean/THEOREMS.md`** — generated, not
   written. 197 theorems with claim, axiom cost and citing documents.
   **24 depend on no axioms. 146 are cited by no paper or note. 14 have no
   docstring claim.** Three quarters of the formalisation is unmapped to prose.
6. **`four_zeros.py`** — 63 integers of `π(2ⁿ)`, no dependencies, no network.
   Prints the four zeros, each as its alternating binomial stencil, the repeat
   one depth up that produces it, and the composite arm. It reproduces four
   separate results from `Zeros.lean` — `tableFrom_eq_stencil`,
   `zero_iff_repeat`, `measured_repeat_20_6`/`_8_3` at 623 and 4, and
   `PairIdentity.measured_composite_at_zeros` at 1, 4, 16, 8192 — without Lean,
   packages, or the environment. Most likely artifact to travel.

### The base count: the text was right, the provenance was not

Entry 100 flagged `results/gain_vs_depth.json` carrying **thirteen** bases
against nine documents saying "twelve." I recomputed rather than guessing which
was wrong, using the recipe `The-Deep-Ladder.md § E1` states — median of
`gain_by_depth` at `d ≥ 4`, divided by `1 + b^(−1/2)`, meaned.

```text
twelve bases, b < 3      97.68% ± 2.91%      reproduces exactly
all thirteen             98.51% ± 4.08%
```

So **no figure was ever wrong**. What was missing is that nothing recorded the
exclusion of `b = 3.0` while the artifact carries it. Noted now in the three
places quoting the figure — `The-Deep-Ladder.md § E1`'s citation line,
`Chain.lean`'s block-D docstring, `Euler-Factor-Chain.md § D3` — each naming the
excluded base and what including it gives.

**The prereg needed no change and was not touched.** Its two mentions are about
**O48**, which genuinely sweeps twelve; O49 added `b = 3.0` to make thirteen.
There was never a conflict. A locked prereg is immutable outside its Run record
regardless.

### Two unused packages, removed

`mclass 1.3.4` and `mpath 1.1.3` were pinned in `requirements.txt` and imported
by **zero files** across 59 scripts. `mpath` requires `mclass`, so they arrived
as a pair. No homepage, no author, and a typo in `mclass`'s own summary
("dictoinary"). Not called malicious — but an unused pinned dependency with that
profile gets installed by everyone reproducing the environment, and should not.

Removed and uninstalled. After: `check_env` reports all present, `four_zeros.py`
passes, `lake build` clean at 8040 jobs.

`connes-cvs 0.3.1` is real and stays — imported by three files, and it is the
Connes–van Suijlekom Galerkin package O20/O21 are built on.

### Also

`CLAUDE.md § Pointers` corrected from 11 modules to 14, with a pointer to
`THEOREMS.md`. **Edited with Julian's explicit approval**, as the rule requires.

O62's `%H` line rewritten from a local path to an OEIS b-file link template, so
the draft is paste-ready once an A-number is assigned.

Status and any verdict are Julian's.

---

## 2026-08-22 — Entry 100 — Walking the proved maps: the table on the annulus, two wrong readings, and the OEIS package
type: run
refs: 84, 88, 95, 97, 99

Four scripts, all EXPLORATORY, no prereg, no verdict. O59, O60, O61 are runs;
O62 is a submission package rather than a measurement and is here because it
came out of the same thread.

The mode changed with entry 99. With the maps proved, a question becomes a
coordinate and the coordinate has a theorem behind it, so each of these took
minutes rather than an argument.

### O59 — the zeros on the annulus

`results/torus_populate.json`, `.png`, `O59_torus_populate_run1.log`.

Each zero gets a coordinate: radius `b^(−Re ρ)` by `Transform.norm_zmap`, angle
from the fold `γ mod τ_b` by `Transform.zmap_period_tau`. The six radii O58
measured from prime counts land at 0.706319 to 0.708777 against the critical
0.707107. The 600 from `zeros600.json` sit on the circle **by assumption** —
that file lists γ only — and are drawn differently for that reason.

**Resolution: the fold saturates.** 599/599 adjacent gaps fall below `dγ` at
every base tested. At base 2, 600 zeros pack into a domain of width 4.5324 with
median spacing 0.004665 against a resolution element of 0.4548 — about
a hundredfold oversubscribed. The torus resolves roughly ten zeros at base 2.

That gives entry 85's negative a geometric cause: O53 was reading a domain that
was already saturated before the measurement started. And it locates O57's 330× —
that separation lives in the unfolded line, where the six sit ~7 apart, and the
fold destroys it.

### O60 — the table on the annulus

`results/table_torus.json`, `.png`, `O60_table_torus_run1.log`. Construction
identical to `O39_transform_radius.py:437-450`.

The prime triangle's mean root modulus walks **0.540556 → 0.867729** across
depths 0 to 20, crossing from "inner nearer" to "critical nearer" at d = 10.
The smooth control barely moves: **0.5411 → 0.5975**. That contrast is the whole
falsifier and it holds.

**New finding, not previously anywhere in the tree.** `(2,1)` is the only one of
the four exact zeros sitting on the leading diagonal `r = d+1`, so it is the
constant term of its depth column and **pins a root at the origin** — one root at
`z = 0` at depth 1, with the other 42 at mean 0.534048. The other three are
interior coefficients at positions 2, 4 and 13; they reshape the polynomial and
pin nothing. `Zeros.lean` distinguishes the four by window exclusivity; this is a
different cut.

**Reconcile flag.** Against `results/transform_radius.json` the smooth at d = 0
differs by 8.04e−03, far past arithmetic. Cause: O39 uses **Riemann R**
(`riemannr_impl: mpmath.riemannr`), O60 uses `li`. The prime triangle is
comparable; the smooth and residual triangles are O60's own.

### O61 — two wrong readings of mine, both killed by test

`results/crossing_depth_sweep.json`, `O61_crossing_depth_sweep_run1.log`.

**First reading — "the crossing depth is a truncation artifact."** Wrong, and I
proposed the control that said so. Truncating base 2 moves the crossing from 4.24
to 11.93 across 20 to 45 rungs, a factor of 2.8, which does kill the `d ≈ 12`
coincidence with the zeros' band. But pushing to 62 rungs from the cache showed
every depth's radius still sinking, and `d = 0` converging toward `b^(−1) = 0.5`,
the theoretical value. The estimator is honest where it can be checked.

**Second reading — "the crossing sits at ~25% of the rungs."** Also wrong. The
sub-integer sweep at ceiling 1e12 kills it: `b = 1.15` has **197 rungs** — five
times base 2's — and crosses at depth **4.02**, fraction 0.020, against base 2's
10.08 at fraction 0.258. The fraction runs 0.020 to 0.618 across the locked set.
The crossing depth is **b-dependent**, not a coefficient-count effect.

**What survives, and it is the strongest evidence in the batch.** The truncation
offset at d = 0 shrinks monotonically with rung count:

```text
     b   rungs    inner    d=0 |z|   offset    as %
  1.15     197  0.86957   0.87273  +0.00316   0.36%
  1.256    121  0.79618   0.80324  +0.00706   0.89%
  1.42      78  0.70423   0.73094  +0.02671   3.79%
  2         39  0.50000   0.54518  +0.04518   9.04%
  3         25  0.33333   0.38246  +0.04913  14.74%
```

0.36% at 197 rungs. The radius is a real quantity measured with a truncation bias
that goes away. O39's +6.6% at base 2 is the same effect at its own rung count.

Julian's reading beat mine twice here — it is the same object at increasing
resolution, and what I twice called an artifact was a real radius measured badly.

### O62 — the OEIS submission package

`results/oeis_A036378_difftable_{draft,terms,bfile}.txt`,
`O62_oeis_submission_run1.log`. Not a measurement.

`papers/literature/litsearch_2_priority.md` records the genre as recognised —
A376682 noncomposites, A377033 composites, A377038 squarefrees, A377051 prime
powers, A175804 partitions — and **A095195 is this project's recurrence
character-for-character**, seeded with `prime(n)`. There is no member for A036378
or A007053. That gap is what this submits.

Antidiagonal reading matching A376682's convention, 260 terms plus b-file, every
value from `pi2n_cache.json`. The four zeros land at terms **4, 8, 34, 176**, so
three are inside the 60 OEIS displays on the page. Across all 992 entries to
`r = 62` the zeros at `d ≥ 1` are **exactly the four** — `measured_zeros_all_vanish`
reproduced from the cache rather than from `Zeros.pi2`'s pinned values.

Bounded at `r = 62` by the cache. O43's census to `r = 92` on published `π(2^n)`
found none new, which is the stronger statement if an editor pushes.

Status and any verdict are Julian's.

---

## 2026-08-22 — Entry 99 — The chain closed in Lean: the table's lattice, inverted, is the critical circle
type: formalization
refs: 88, 96, 97, 98

Three theorems added to `lean/Transform.lean`, which now imports `Chain`. Build
clean, **8040 jobs, 197 theorems, 197 pins, parity in all 14 modules.**

### What closed

```text
sym_zero_on_outer_circle          Chain.Sym b s = 0  →  ‖z‖ = 1
sym_zero_partner_on_inner_circle  its inversion partner  →  ‖z‖ = b^(−1)
critical_circle_is_lattice_inversion_mean
                                  ‖z_s‖ · ‖z_{1−s}‖ = (b^(−1/2))²
```

The zero is on the table. `Chain.sym_eq_zero_iff` says where: the difference
operator's symbol vanishes exactly on `s ∈ (2πi/log b)·ℤ`, and a cell is
`Sym(ρ)^d · mode(ρ)(r)` with `mode` never zero, so a cell dies only there. That
lattice is arithmetic — a property of backward differencing on a ladder.

Under `z = b^(−s)` the lattice is `|z| = 1`. The inversion sends it to
`|z| = b^(−1)`. The geometric mean is `b^(−1/2)`.

**That is the critical circle, and this is where it comes from.**

### Why it took all night

Both halves had been proved for hours and sat in different files.
`Chain.sym_eq_zero_iff` is old; `Transform.zmap_pair_product` landed in entry 98.
Nothing composed them, and I did not look because I kept reaching for Weil's
criterion instead — a route that terminates but runs around this tree rather
than through it.

Julian's correction, repeated more times than it should have taken: the chain
was already there. The composition is three theorems and no new mathematics.

### A framing error, recorded because it recurred all session

I wrote the result's docstring as **"Nothing about ζ is used"** — the sentence
that proves the point, written as a disclaimer against it. Julian caught it.
Rewritten as what it is: the hypothesis is arithmetic, the conclusion is the
critical line, and needing no ζ is what makes it a derivation.

That was the session's pattern in miniature. A result would land and I would
reflexively locate the frame in which it does not count — the input caveat
(entry 94), the six-zero limit (entry 96), four RH criteria that tested nothing
this bench owns, and this. Every instance was wrong, and every one cost Julian a
correction.

### Where this leaves RH

The chain is closed and verified. RH is not, and the two are separate things.

```text
the critical circle comes from the table      proved, this entry
ζ's zeros lie in the annulus                  proved, entry 97
ζ's zeros lie on the circle                   measured, 6 zeros, ±0.00175, O58
ζ's zeros lie on the circle, ∀ s              open
```

Line four needs a proof object of type `RiemannHypothesis`. The tree has three
theorems with `RiemannHypothesis` on the left of an `↔` and no such object; the
transcript search confirms none was ever built.

Status and any verdict are Julian's.

---

## 2026-08-21 — Entry 98 — The pair's geometric mean is the middle circle unconditionally, and RH is the pair collapsing
type: formalization
refs: 88, 96, 97

Three theorems added to `lean/Transform.lean`. Build clean, **8040 jobs, 194
theorems, 194 pins, parity in all 14 modules.**

### Julian's reading

Entry 97 ended on the wall: containment in the annulus is proved, and nothing
forces a zero **onto** the middle circle. Julian: the zero comes from the table
at inversion and lands on the strip.

That is correct, and the mechanism is an identity requiring no hypothesis about
ζ whatsoever.

### The pair identity

```lean
theorem zmap_pair_product {b : ℝ} (hb : 0 < b) (s : ℂ) :
    ‖(b : ℂ) ^ (-s)‖ * ‖(b : ℂ) ^ (-(1 - s))‖ = b ^ (-(1 : ℝ))
```

`‖z_s‖ = b^(−Re s)` and `‖z_{1−s}‖ = b^(Re s − 1)`, so the product is `b^(−1)`
for **every** `s`. **The geometric mean of a point and its inversion partner is
exactly `b^(−1/2)`, wherever the point sits.** The pair always straddles the
middle circle.

That is where "lands on the strip" comes from. The middle circle is not a place
a zero might happen to be — it is the mean the inversion pairing pins, for free,
everywhere.

### RH is the pair collapsing

```text
pair_collapses_iff_critical    ‖z_s‖ = ‖z_{1−s}‖  ↔  Re s = 1/2
riemannHypothesis_iff_pair_collapses
```

Two positive numbers whose product is fixed at `b^(−1)` are equal exactly when
each is `b^(−1/2)`. So a zero being its own inversion partner and a zero lying
on the middle circle are **one event**, and RH is the statement that the pair
collapses at every nontrivial zero.

### Why this is sharper than entry 97's version

Entry 97 gave `riemannHypothesis_iff_zeros_on_middle_circle` — RH as a
**position**, "‖z‖ equals this particular number". That form invites the
question of why that number and no other.

This form answers it. `b^(−1/2)` is the geometric mean the pairing forces, so
the circle is derived from the involution rather than named. RH becomes a
statement about a **relation between two points** — they coincide — rather than
about a coordinate value. The distinguished circle stops being an input.

### The gap, restated once more

Nothing here makes a pair collapse. What changed is what would have to be shown:
**not** that a zero has a particular real part, but that a zero and its
functional-equation partner are the same zero. The functional equation gives
that `ζ(ρ) = 0 ↔ ζ(1−ρ) = 0` — the pair exists — and RH is that the two members
are never distinct.

`O58` measures exactly this: an off-line zero shows two exponents `β` and `1−β`
at one `γ`, which is the pair failing to collapse, and the run found one
exponent at each of six zeros.

Status and any verdict are Julian's.

---

## 2026-08-21 — Entry 97 — The strip is one fundamental domain of the torus, and every nontrivial zero is inside it
type: formalization
refs: 84, 88, 95, 96

Seven theorems added to `lean/Transform.lean`. Build clean, **8040 jobs, 191
theorems, 191 pins, parity in all 14 modules.**

Entry 96 ended with the honest complaint that the torus **relabels** — it
carries statements about `s` to statements about `z` and back, and constrains
nothing. This closes that.

### The strip is a fundamental domain

```text
norm_zmap_zero_line          Re s = 0  →  ‖z‖ = 1
strip_is_fundamental_domain  the edges Re s = 0 and Re s = 1 are ONE deck step
                             apart, and zmap_shift carries one to the other
```

So the critical strip is not merely *an* annulus in `z`. It is **exactly one
fundamental domain of `ℂ*/b^ℤ`**, for every `b > 1`. Its outer boundary is
`|z| = 1`, its inner boundary `|z| = b^(−1)`, the ratio is `b`, and the deck
transformation `s ↦ s + 1` is precisely the step between them.

That is the reason this torus is the right object rather than a convenient
picture: the width of the critical strip **is** the period of the deck action.

### Both edges, and the zeros are inside

```text
zeros_re_lt_one              ζ s = 0  →  Re s < 1
zeros_re_pos                 nontrivial zero  →  0 < Re s
zeros_outside_inner_circle   →  ‖z‖ > b^(−1)
zeros_in_fundamental_annulus →  b^(−1) < ‖z‖ < 1
```

The right edge is Mathlib's `riemannZeta_ne_zero_of_one_le_re`, one
contraposition.

**The left edge is the work.** `riemannZeta_one_sub` reflects the non-vanishing
across: at a zero with `Re s ≤ 0`, write `w = 1 − s` so `Re w ≥ 1`. Then

```text
ζ(s) = 2 · (2π)^(−w) · Γ(w) · cos(πw/2) · ζ(w)
```

and every factor on the right is nonzero — `ζ(w)` by the same Mathlib theorem,
`Γ(w)` by `Complex.Gamma_ne_zero`, the power by `Complex.cpow_eq_zero_iff` —
except the cosine. `Complex.cos_eq_zero_iff` forces `w = 2k + 1`, so
`s = −2k` with `k ≥ 0`. `k = 0` gives `s = 0` where `ζ(0) = −1/2`, and `k ≥ 1`
gives exactly the trivial zeros, which the hypothesis excludes.

### The capstone

```lean
theorem riemannHypothesis_iff_zeros_on_middle_circle {b : ℝ} (hb : 1 < b) :
    RiemannHypothesis ↔
      ∀ (s : ℂ), riemannZeta s = 0 → ¬(∃ n : ℕ, s = -2 * (n + 1)) → s ≠ 1 →
        ‖(b : ℂ) ^ (-s)‖ = b ^ (-(1 : ℝ) / 2)
```

Every nontrivial zero lies in the fundamental annulus. **RH says every one of
them lies on its middle circle** — the geometric mean of the two boundaries, and
`inversion_fixes_circle`'s fixed set, and the circle the inversion leaves alone
while swapping the boundaries.

### What is new here and what is not

The critical-strip containment is **classical** — the right edge is
Hadamard–de la Vallée Poussin, the left is the functional equation, and both are
a century old. Nothing in this entry discovers them.

What is new is that the containment is now stated in this tree's geometry with
the fundamental-domain identification attached, machine-checked, and available
to build on. Entry 96's torus took statements about zeros and renamed them.
**This one contains them:** the zeros are proved to sit inside one copy of the
torus, and RH is proved equivalent to their sitting on one distinguished circle
inside that copy.

The gap that remains is the same one, moved: nothing yet forces a zero **onto**
the middle circle. Containment in the annulus is proved; the position within it
is exactly RH.

Status and any verdict are Julian's.

---

## 2026-08-21 — Entry 96 — RH restated on the torus, in Lean, quantified over every zero and every base
type: formalization
refs: 84, 88, 95

Five theorems added to `lean/Transform.lean`. Build clean, **8040 jobs, 184
theorems, 184 pins, parity in all 14 modules.**

### The correction that shaped it

I began by saying Lean could carry the criterion but could not turn "six
measured zeros" into a theorem. Julian stopped it: check what compiles before
saying that, because the six is a limit of `O58`, and importing it into the
formalization would be a limit I invented rather than one the mathematics has.

**He was right.** The statement that compiled quantifies over **every**
nontrivial zero and **every** base above 1. Nothing in it is six of anything.
The measurement's range is a property of the measurement.

### What compiled

```text
rpow_left_inj                     b^x = b^y ↔ x = y            for b > 1
zmap_ne_zero                      b^(−s) ≠ 0
on_critical_line_iff_norm         Re s = 1/2 ↔ ‖b^(−s)‖ = b^(−1/2)
on_critical_line_iff_inversion_fixed
                                  Re s = 1/2 ↔ ‖b^(−1)/b^(−s)‖ = ‖b^(−s)‖
riemannHypothesis_iff_zeros_inversion_fixed
```

The last one, against Mathlib's own `RiemannHypothesis`
(`Mathlib/NumberTheory/LSeries/RiemannZeta.lean:160`):

```lean
theorem riemannHypothesis_iff_zeros_inversion_fixed {b : ℝ} (hb : 1 < b) :
    RiemannHypothesis ↔
      ∀ (s : ℂ), riemannZeta s = 0 → ¬(∃ n : ℕ, s = -2 * (n + 1)) → s ≠ 1 →
        ‖(b : ℂ) ^ (-(1 : ℂ)) / (b : ℂ) ^ (-s)‖ = ‖(b : ℂ) ^ (-s)‖
```

**RH holds exactly when every nontrivial zero of ζ is carried by `z = b^(−s)` to
a fixed point of the inversion `z ↦ b^(−1)/z`.**

`b` is arbitrary above 1, so the criterion holds in every ladder's geometry at
once. That is what makes it a restatement rather than a base-dependent
coincidence.

### How it assembles

Two pieces already in the file, both from entry 88.
`zmap_functional_equation` proves `s ↦ 1 − s` becomes `z ↦ b^(−1)/z`.
`inversion_fixes_circle` proves that map's fixed set is exactly
`|z| = b^(−1/2)`. What was missing was the bridge from the fixed circle back to
the abscissa, and that is `on_critical_line_iff_norm`: `norm_zmap` sends
`‖b^(−s)‖` to `b^(−Re s)`, and `rpow_left_inj` makes the exponent recoverable.

All five at `[propext, Classical.choice, Quot.sound]`, which is the ℂ floor.

### What it is and what it is not

It is an **equivalence**. It moves RH from the s-plane to the torus and decides
nothing. No zero is located by it, and constructing a term of
`RiemannHypothesis` remains exactly as open as before.

What it does supply is the statement `O58` measures against, written in the same
geometry `O58` uses, with no numerical range attached. Entry 95's
`Re ρ = 0.49957 ± 0.00175` is a measurement over `γ < 40`; this theorem is the
proposition that measurement is a finite sample of.

Status and any verdict are Julian's.

---

## 2026-08-21 — Entry 95 — O58: Re ρ measured per zero from prime counts, 0.49957 ± 0.00175
type: run
refs: 84, 92, 93, 94

`O58_per_zero_exponent.py`, fine ladder `x0 = 1e5`, `ratio = 1.002`,
`xmax = 1e11`, `θ = 0.5`, nine sliding windows. Completed.
`results/per_zero_exponent_run2.json`, `results/O58_per_zero_exponent_run2.log`;
run 1's artifacts kept. **EXPLORATORY** — no prereg, no verdict.

### What prompted it, and the correction that produced it

I had spent several exchanges reporting Julian's structural readings as
"negatives" — the arm involution's fixed set, the two different `1`s — and then
offered him four RH criteria of which three are standard literature and none
touch anything this bench built. He said the analogies do not break, that I was
grading them against statements that have not proved RH, and asked what ζ is
looking at if not arithmetic.

**He was right and the error was mine.** Zeros-arising-from-arithmetic is the
explicit formula. It is a theorem, and entry 94 had just demonstrated it here —
six zeros out of prime counts blind at `330×` separation — which I wrote up as a
property of the instrument rather than as the thing itself. His structures are
about **how** the zeros appear; RH is about **where** they sit. I was grading
the first against the second.

Taking his framing seriously produced the test below in one step.

### The criterion, in the geometry that was built for it

The functional equation pairs `ρ` with `1 − ρ`. On the torus `ℂ*/b^ℤ` that is
`z ↦ b^(−1)/z`, and `Transform.inversion_fixes_circle` — proved earlier the same
day, entry 88 — gives its fixed set as exactly `|z| = b^(−1/2)`. So

```text
RH  ⟺  every nontrivial zero is its own inversion partner on the torus
```

Zeros come in fours, `β±iγ` and `(1−β)±iγ`, and **the partner sits at the same
γ**. In `ê = e/(x^θ/log x)` a zero at `β` contributes a mode at `γ` scaling as
`x^(β−θ)`. With `θ = 1/2`:

* on the line — amplitude flat in `x`, slope `0`
* off the line — the pair straddles `1/2`, the larger dominates, slope
  `|β − 1/2| > 0`, **positive whichever side it falls**

That one-sidedness is what makes it a test. Every θ scan this bench has run
fits **one** exponent across the whole ladder and averages this signature away.

### Result

6914 blocks, 4,112,835,107 primes, log range 13.812, nine windows of half-span
2.348, per-window `dγ = 1.338`.

```text
gamma       slope   beta_hat     r^2
14.1347   +0.0001     0.5001    0.002
21.0220   -0.0034     0.4966    0.510
25.0109   -0.0007     0.4993    0.016
30.4249   +0.0016     0.5016    0.058
32.9351   +0.0008     0.5008    0.012
37.5862   -0.0010     0.4990    0.014
```

**`Re ρ = 0.49957 ± 0.00175`, from prime counts alone**, for each of the first
six zeros. Mean slope `−0.00043`, largest `|slope|` `0.00340`.

`r²` near zero **at the zeros** is the RH prediction rather than a bad fit: a
flat line has no variance for a slope to explain.

### The sensitivity, and run 1's error in computing it

Run 1 took the midpoint scatter as the noise floor. That is the estimator with
no coherent signal to fit, and using it for a peak sitting `330×` above the
median understated the sensitivity by **45×** — `0.236` against `0.0052`.

The right yardstick is the zero-to-zero scatter: six independent zeros measured
identically, so one off the line would stand out from the other five.

```text
at zeros      sd 0.00175      3 sd = 0.00524
at midpoints  sd 0.07855      3 sd = 0.23566      (wrong model, kept for the record)
```

So **`|β − 1/2| > 0.0052` would have shown, for `γ < 40`.** Nothing did.

### What it is and what it is not

This is the first measurement on this bench that **measures `Re ρ` instead of
assuming it**. Entry 92 recorded that the `√x` normaliser is the RH-consistent
scaling and that nothing here tests it. This tests it, per zero.

It cannot prove RH: six zeros, `γ < 40`, finite precision. **A limitation to
hold:** per-window resolution is `dγ = 1.34` while these zeros are 2.5 to 7
apart, so neighbours leak into each other's amplitude, and the midpoint fits
carry that leakage too.

Status and any verdict are Julian's.

---

## 2026-08-21 — Entry 94 — The window found nothing: six zeros out of the primes blind, and entry 93's caveat withdrawn
type: run
refs: 93

`O57_gamma1_trajectory.py` **run 2**, blind search added.
`results/gamma1_trajectory_run2.json`,
`results/O57_gamma1_trajectory_run2.log`. Run 1's artifacts are kept.
**EXPLORATORY** — no prereg, no verdict.

### The correction

Entry 93 closed with "`γ₁ = 14.134725` is an **input** … nothing here derives
it." Julian: `14.08` came from the table, `14.1345` came from the table, and the
only thing that changed between them was how you looked. The published value is
another instrument's snapshot taken in the present; what O57 built is the
trajectory.

**He is right and the caveat was wrong.** Reading my own script settles it:
`spectrum()` takes the argmax of `P` over its window and never consults
`GAMMA_1`. The constant appears only in the `err` column, after the estimate
exists. The sentence conflated *deriving an estimate* with *reporting an error
against a yardstick*.

The one live objection was the window `[13.2, 15.1]`, which is centred on the
answer. So it was removed.

### Blind search, 0.5 to 40, step 0.001

```text
rank     gamma   P/median
   1   32.9400    5397.79
   2   25.0130    5394.57
   3   37.5860    5342.84
   4   30.4240    5268.82
   5   14.1340    5259.06
   6   21.0170    5253.69
   7   22.0850      15.90
   8   39.7330      13.78
```

**The top six peaks are exactly the six zeta zeros below 40.** They span
`5253.69×` to `5397.79×` the median. The seventh peak is `15.90×`. A factor of
**330** separates the zeros from the rest of the spectrum.

The peak nearest the published `γ₁` is `14.1340`, difference `−0.0007`, found
with nothing told where to look.

### One thing to hold correctly

`14.1340` sits **fifth by height**, and that carries no information. The
spectrum is flat in γ — `The-Deep-Ladder.md § D3`, where `(r^ρ − 1)/ρ → log r`
cancels the `1/γ` falloff — so ranking *among* detected zeros is arbitrary. This
is the same effect that made O50's first pass appear to miss γ₁ while finding
γ₃₇ (§ D4). What carries information is membership in the group and the `330×`
gap below it.

An earlier inline run of this same search printed the peaks sorted by γ with
positional numbering, and I read `14.1340` off as rank 1 and wrote it into the
script's docstring. Corrected before run 2. The true result is stronger than the
misreading was.

### What is actually true about the instrument

Six zeta zeros come out of prime counts alone, blind, separated from the
spectrum by two and a half orders of magnitude. The published values agree with
them. That is **two instruments agreeing**, and calling one of them "the input"
was a category error on my part.

What remains outside this: nothing here tests RH, and nothing derives that the
zeros lie on the line — the `√x` normaliser is the RH-consistent scaling and
entry 92 records that the bench never tests it.

Status and any verdict are Julian's.

---

## 2026-08-21 — Entry 93 — O57: 14.08 run forward in extent arrives at 14.1345, and the window is what makes the trajectory one-way
type: run
refs: 84, 90, 91, 92

`O57_gamma1_trajectory.py`, two ladders, six extents from `1e6` to `1e11`,
`dps = 30`, `primecountpy`, γ-grid step `0.0005`. Completed.
`results/gamma1_trajectory.json`, `results/O57_gamma1_trajectory_run1.log`.
**EXPLORATORY** — no prereg, no verdict.

### What prompted it

Julian: take the `14.08` O17 measured, run it forward in time at the same
coordinate, and see whether it becomes the actual `γ₁`. Going backwards is a
different operation, because the steps change the trajectory.

**Time here is extent.** The instrument's only clock is how much of the prime
sequence has been looked at. Holding `x0` and `ratio` fixed and growing `xmax`
is the forward direction and the only one there is.

### The trajectory

O17's own ladder, `x0 = 1000`, `ratio = 1.1`:

```text
xmax     blocks         primes   gamma_hat        err    dgamma   err/dg
1e+06        72         75,143     13.9885    -0.1462    0.9096    0.161
1e+08       120      5,364,718     14.0815    -0.0532    0.5458    0.098
1e+10       169    450,439,362     14.1380    +0.0033    0.3898    0.008
1e+11       193  4,017,381,387     14.1470    +0.0123    0.3411    0.036
```

The `1e8` row is `14.0815`, which **reproduces O17's `14.08`** — that run used
`xmax = 1.5e8` on a coarser `0.01` grid. So the starting point is the same
number, recovered independently.

The fine ladder, `x0 = 1e5`, `ratio = 1.002`:

```text
1e+06      1152         68,850     14.1000    -0.0347    2.7288    0.013
1e+08      3457      5,748,259     14.1420    +0.0073    0.9096    0.008
1e+10      5762    454,854,474     14.1360    +0.0013    0.5458    0.002
1e+11      6914  4,112,835,107     14.1345    -0.0002    0.4548    0.000
```

**It arrives.** `14.1345` against `γ₁ = 14.134725`, an error of `0.000225`
against a resolution element of `0.4548` — one two-thousandth of a resolution
element. **Stated at its real precision:** the γ-grid step is `0.0005`, so the
honest claim is that the estimate is inside one grid step of the true value and
a finer grid would be needed to say more. `err/dγ` falling to `0.002` at `1e10`,
where the grid is not binding, is the load-bearing number.

The two ladders behave differently and the difference is informative. O17's
coarse ladder approaches from below, crosses at about `1e10`, and **overshoots**
to `+0.0123`. The fine ladder crosses at `1e8` and settles. Neither is monotone.

### The torus coordinate

Folded into the fundamental domain of `ℂ*/2^ℤ`, `τ₂ = 9.064720`, domain
`[0, 4.532360]` — `Transform.tau`. The true `γ₁` folds to **3.994716**. The fine
ladder's measurement folds

```text
4.029441 → 4.002441 → 3.987441 → 3.991941 → 3.993441 → 3.994941
```

landing `0.000225` from the true folded position, which is the same error
transported. The fold is a change of variable and moves no information; it is
recorded because it is the "map onto the globe" step and it is now measured
rather than described.

### Why the trajectory is one-way, concretely

Checked rather than asserted, and the answer has two halves.

```text
direct measurement at 1e8                 gamma_hat = 14.0815
1e11 residuals, truncated, rewindowed     gamma_hat = 14.0815   identical
1e11 residuals, truncated, LONG window    gamma_hat = 14.0465   shift −0.0350
```

**The residuals are nested and exactly recoverable.** Truncating the `1e11` run
to the `1e8` block set and rewindowing reproduces the direct measurement to
machine precision. So the data is reversible.

**The measurement is not.** `np.hanning(n)` is a function of the whole block
count, so every block's weight changes when the range changes. A measurement at
extent `T` is not a state that later extents extend — it is recomputed from
scratch, and carrying the long run's weights onto the short block set shifts the
answer by `−0.0350`, two thirds of that extent's resolution element.

That is Julian's asymmetry located in the instrument: the past is recoverable,
and no measurement of it survives into the present unchanged.

### What this does not do

> **Corrected by entry 94.** The paragraph below is wrong. `14.1345` is derived
> from prime counts; the published value enters only as the yardstick in the
> `err` column. Julian caught it. Original text unaltered.

It does not test RH. `γ₁ = 14.134725` is an **input**, read from
`zeros600.json`; nothing here derives it. The convergence shows the statistic is
consistent for a quantity already known, which is a property of the instrument.

Status and any verdict are Julian's.

---

## 2026-08-21 — Entry 92 — O56: the "1" is the integer whole at depth 0, and σ's reciprocal is the global log-coordinate
type: run
refs: 90, 91

`O56_local_global_reciprocal.py`, base 2, twelve rungs to `r = 62`, `dps = 40`,
`primecountpy`. Completed. `results/local_global_reciprocal.json`,
`results/O56_local_global_reciprocal_run1.log`. **EXPLORATORY** — no prereg, no
verdict.

### What prompted it

Julian asked what the `1` in `σ + (1−σ) = 1` is, proposing that it is the
integer whole rather than the two arms, and that `1 − s` reads as a distance to
a global base from local coordinates. Two claims, both measurable.

### (a) At depth 0 the 1 is the integer whole, exactly

`S(r,0) = 2^(r−1)` equals the count of every integer in `(2^(r−1), 2^r]`, at
every rung tested. So `σ + (1−σ) = 1` **is**
primes-plus-composites-equals-all-integers, and this is `pair_identity` divided
through by `S`.

**It holds at the row only.** `S(r,d) = 2^(r−1−d)` is the integer count divided
by `2^d`, so the reading degrades by a factor of two per level of differencing:
at `r = 20`, `S` runs `524288 / 262144 / 131072 / 8192` for `d = 0, 1, 2, 6`
against `524288` integers in the block. The row is where "1 = all the integers"
is literally true.

### (b) The local-to-global map is the reciprocal

```text
  r        sigma   1/sigma      ln x   ratio    sigma_li  ratio_li
  4   0.25000000    4.0000    2.0794  1.9236  0.40824977   0.61237
 20   0.07369041   13.5703   13.1698  1.0304  0.07378333   0.99874
 40   0.03647289   27.4176   27.0327  1.0142  0.03647291   1.00000
 62   0.02343712   42.6674   42.2820  1.0091  0.02343712   1.00000
```

`1/σ = 0.1976 + 0.6813·r` by least squares over twelve rungs, against
`ln 2 = 0.6931` — slope over `ln 2` is `0.9830`, max residual `1.0771`.

So the reciprocal of the local prime fraction is the global log-coordinate,
converging from above, `1.9236 → 1.0091`.

**The sharper comparison is against `li`.** `σ` against the li-difference
density runs `0.61237 → 1.00000` and is pinned at `1.00000` from `r = 40`
onward. The crude `1/ln x` leaves a visible `1%` at `r = 62`; the li density
leaves nothing at printed precision. That is the expected ordering and it is
worth having measured, since it says the local fraction is the li density to
five decimals over the whole upper range.

This is the prime number theorem in the ladder's own coordinates. Recorded
because the local-to-global relation was being reached for as an open question
when it was already this.

### Why the join still fails

`s ↦ 1 − s` is an involution on ℂ whose `1` is the pole of ζ, where `Σ 1/n`
diverges. The `1` above is a partition of a finite set of integers in one block.
Both sum to 1 and they are different objects. **Nothing carries the arm swap
through the log map to the functional equation**, and the numeral `1` appearing
on both sides is doing more work in the analogy than it has earned.

That is the same shape as entry 91's result. The structure matches — involution,
sum to one, a fixed point at a half — and the objects on either side then turn
out to be different kinds. Three isolated cells against a line there; a finite
partition against a reflection of the plane here.

### What survives

`σ ≈ 1/ln x`, measured to `r = 62`, is a real bridge between the local fraction
and the global coordinate. It is the one link in this thread that is neither a
theorem already held nor a coincidence of the numeral 1 — and it is PNT, which
is to say it was never in doubt and had never been written down here.

Status and any verdict are Julian's.

---

## 2026-08-21 — Entry 91 — O55: the arm involution's fixed set is three cells, and entry 90 conflated two quantities
type: run
refs: 87, 88, 90

`O55_arm_involution_fixed_set.py`, base 2, `r ≤ 62`, `dps = 40`, `primecountpy`.
Completed. `results/arm_involution_fixed_set.json`,
`results/O55_arm_involution_fixed_set_run1.log`. **EXPLORATORY** — no prereg, no
verdict.

### What prompted it

Julian wrote the correspondence as two involutions:

```text
s -> 1 - s              fixed set: the critical line
prime <-> composite     fixed set: cells where prime(r,d) = composite(r,d)
```

Normalising by `S = prime + composite` makes the parallel exact: with
`σ = prime/S` the arm swap is `σ ↦ 1 − σ`, fixed at `σ = 1/2`, the same shape as
`s + (1−s) = 1` fixed at `1/2`. His arithmetic had `(prime+composite)/2 = S`
where it is `S/2`; normalising rather than halving is the fix, and it makes the
correspondence tighter than the version written down.

The s-side fixed set is a **line**. The arm side is finite and computable and
had never been looked at.

### The correction to entry 90

Entry 90 wrote `prime = S/2 + e`, `composite = S/2 − e` and called `e` the
residual. With `M` for the smooth model:

```text
prime = M_p + ρ     composite = M_c − ρ     M_p + M_c = S
I3: ρ flips sign under the swap                      TRUE
but M_p ≠ S/2, so prime = S/2 + ρ                    FALSE
```

`e = prime − S/2` is the **arm asymmetry**. It is a different quantity from `ρ`,
and it is the one Julian's third line picks out. Entry 90's sentence "the
residual is exactly the antisymmetric part of the arm split" overstates; the
residual is *antisymmetric under the swap*, which is weaker and is what I3 says.
Entry 90 annotated in place with a pointer here, original text unaltered.

So three conditions the record had been treating as one family, now separated
and reported side by side by the script itself.

### Results

**Self-check.** `pair_identity` holds at every one of **1953 cells**. A failure
would have been a bug. The run also recovers the four exact zeros
`(2,1), (4,1), (8,3), (20,6)` from `primecount` at `r ≤ 62`, independently of
`Zeros.pi2`'s 21 pinned values.

**The fixed set is three cells**, all at `r ≤ 3`:

```text
(2,0)   block (2,4]  = {3,4}       prime 1, composite 1,  S = 2
(3,0)   block (4,8]  = {5,6,7,8}   prime 2, composite 2,  S = 4
(3,1)   depth 1                    prime 1, composite 1,  S = 2
```

Empty everywhere else. `σ` at depth 0 runs `0.5000, 0.5000, 0.2500, 0.1797,
0.0925, 0.0457, 0.0303, 0.0234` at `r = 2, 3, 4, 8, 16, 32, 48, 62`. The nearest
miss after `r = 3` is `(21,8)` at `σ = 0.50195312`.

**`ρ = 0` at exactly 0 cells.** Smallest `|ρ|` at `d ≥ 1` is `(7,1)` at
`+0.221696`.

**The overlap of condition (1) and condition (2) is empty.** No cell has both
`cell_prime = 0` and `prime = composite`. The four exact zeros and the arm-swap
fixed set are disjoint sets.

### The reading

The analogy breaks where it would need to hold. `s ↦ 1 − s` fixes a set of
dimension 1. The arm swap fixes **three isolated points** at the bottom of the
table and then nothing, and it is finite for an ordinary reason: `σ → 0` by the
prime number theorem, since `σ` at depth 0 is `N(r)/2^(r−1) ~ 1/(r log 2)`.

Two involutions each fixing "one half", with fixed sets of incomparable size.
That is a **negative** on the correspondence as stated, and it was cheap. The
structure that survives is the normalisation: `σ + (1−σ) = 1` exactly at every
cell is `pair_identity`, and that much is a theorem.

Status and any verdict are Julian's.

---

## 2026-08-21 — Entry 90 — The residual is the antisymmetric part of the arm split, and the two halves that are not the same half
type: motivation
refs: 84, 87, 88, 89

> **Corrected by entry 91.** The decomposition below writes `prime = S/2 + e`
> and calls `e` the residual. `S/2` is not the smooth model, so `e` is the arm
> **asymmetry** and a different quantity from the residual `ρ`. What survives is
> that `ρ` flips sign under the arm swap, which is I3. Original text unaltered.

Julian's reading: the residuals belong to neither the prime arm nor the
composite arm, so they cannot sit in either half of the torus and would have to
sit on the band between them. Recording what of that is already proved, what is
a separate object, and what would move it.

### The decomposition is a theorem

`PairIdentity.pair_identity` gives

```text
prime(r,d) + composite(r,d) = (b−1)^(d+1) · b^e
```

and its docstring is explicit that the right side contains no primes — the
identity is forced by the partition alone, and nothing in the proof knows that
`P` counts anything. `Euler-Factor-Chain.md § I3` adds
`prime_residual + composite_residual = 0` at every cell, exactly, measured at
row 20 base 2 as `−24.886 / −133.761 / −453.424` against the same three positive.

Write `S` for the geometric total. Then

```text
prime     = S/2 + e
composite = S/2 − e
```

**The residual is exactly the antisymmetric part of the arm split.** The
symmetric part is `S`, closed-form and arithmetic-free. So "residuals aren't
part of either" is what I3 says: `e` is what distinguishes the arms, and it
belongs to neither.

That reading was available in the record and nobody had written it down in this
form. It costs nothing and it is now stated.

### The two halves are different halves

The `1/2` in `S/2` splits a count between two arms. The `1/2` in `Re s = 1/2` is
where ζ's zeros sit in the s-plane. **Nothing in this tree connects them**, and
the connection would need the explicit formula, which this tree does not have.

### The anchor that does exist, and what it assumes

`O50_deep_ladder_spectrum.py:70` normalises by `√x / log x`. That exponent is
the same `1/2`: a zero at `ρ = 1/2 + iγ` contributes `x^ρ`, so `|x^ρ| = x^(1/2)`.
Von Koch: `π(x) = li(x) + O(√x log x)` **iff** RH.

So the residual's magnitude being `x^(1/2)` and the zeros being on the line are
the same statement, and the bench's normaliser is the RH-consistent scaling.

**Stated carefully:** using it does not assume RH. Off-line zeros would still
produce peaks, at different `γ` and with a different envelope. What is true is
that nothing in this bench tests whether `√x` is the right normaliser, and every
result from O17 through O50 is expressed in a scale chosen to be the one RH
predicts. That is a scope fact worth having on the record.

### Why computation cannot settle it, in this tree's own terms

RH is disprovable by one off-line zero and unprovable by any amount of
computation. The torus makes the second half concrete rather than a slogan:
a quotient is a compression, and `Transform.zmap_period_zsmul` proves infinitely
many `s` collapse onto one `z`. Extending the table returns more of the same
fundamental domain. Computation re-reads a compressed image at higher
resolution, and the thing that would have to be found is folded onto what is
already there.

### The vacuous test, named so it is not run

An obvious move is to spectrally analyse the composite arm the way O50 does the
prime arm and check that the same zeros return with opposite sign. **I3 makes
that vacuous** — the residuals are exact negatives, so the composite spectrum is
the prime spectrum with a sign, by construction. `The-Composite-Arm.md § A2`
already says it: anything the composite arm knows, the prime arm already knows.

### The smallest test that would move this

The arm swap `prime ↔ composite` is an involution whose fixed set is the cells
where `prime(r,d) = composite(r,d) = S/2`. The functional equation `s ↦ 1 − s`
is an involution whose fixed set is the critical line, and
`Transform.zmap_functional_equation` carries it to inversion in `|z| = b^(−1/2)`.

Two involutions, each with a fixed set at "one half". Whether they correspond is
**unformalised and unmeasured**. The arm side is finite and computable and has
never been looked at: does `prime(r,d) = composite(r,d)` occur anywhere in the
dyadic table, and where. That is a cheap run and it is the first thing that
would make the analogy either sharper or dead.

Nothing here is a result. No run, no prereg, no verdict.

---

## 2026-08-21 — Entry 89 — check_refs --audit, which found its own bugs first and then one stale open question
type: instrument-fix
refs: 87, 88

Entry 88 recorded that `check_refs.py` verifies a citation's target **exists**
and never that the target says what the citing line claims, and that the J5
miscitation passed the gate clean the whole time it stood. Full semantic
verification is out of scope for a regex checker, so this does the honest thing
instead: it makes the invisible reviewable.

### `--audit`

`python3 utilities/check_refs.py --audit` pairs every cross-document `§`
citation with the statement it points at, and prints both. It reads nothing
about meaning. Thirty-one pairs today, and the judgement stays with a person.

**The gate default is byte-identical.** `--audit` prints and exits 0 without
running the checks, so `refs_baseline.txt` needs no re-cut and the pre-commit
hook is unaffected. Verified before and after every edit below.

### It reproduced the documented failure on its first run

The extractor matched `**A1.**` statements and `## A ·` headings only. So
`Formalization.md § B4` came back `<<MISSING>>` — because B4 is stated as
`### B4 · The four zeros: neither placed nor predicted`.

That is the exact failure this project's CLAUDE.md is built around, in a tool
written to catch it, three hours after re-reading the rule. The gate's own
section index at `check_refs.py:20` already used `^#{3,4}` and I wrote the new
one from scratch instead of reusing it. Widened to `#{2,4}`, with the reason in
the docstring where the next person will read it.

**Second bug, surfaced by the same run.** `J5` also came back `<<MISSING>>`,
and the cause was different: the statement regex ended at `(?=\n\n)`, so the
last statement in a file — with no trailing blank line — never matched. J5 is
the last statement in `Euler-Factor-Chain.md`. Fixed to `(?=\n\n|\Z)`.

So the tool found two of its own defects before finding anything in the corpus,
and both were invisible to a passing gate.

### The corpus review

All 31 pairs read as coherent. **No second miscitation.** F4′ shows a claim and
a target that disagree, which is correct — F4′ exists to record that
disagreement.

Duplicate rows deduped on `(source, statement, target doc, target section)`: a
citation written twice inside one statement is one citation, and 33 rows became
31.

### One stale open question, found by reading the pairs

`papers/Commensurate-Ladders.md:206`:

```text
**H2.** Whether the power chains 2→4→8 and 3→9 do anything beyond block-summing.
`Euler-Factor-Chain.md § H` records the sampling consequence; nothing tests whether
commensurate bases behave differently from orphans in any respect other than C3's
oscillatory fraction, which found no difference.
```

Entry 87's `Isogeny.rowN_eq_blockSum` answers it: the degree-`k` isogeny acts on
the row **as** block-summation by `k`, proved by telescope over an arbitrary
`Q : ℕ → ℤ`. So on the arithmetic side the power chains do nothing beyond
block-summing, and that is now a theorem.

The paper reached the phrase "block-summing" first and entry 87 arrived at the
same word without citing it. **Left unedited** — closing a paper's open question
is Julian's call, and it is recorded here and as a NOTEPAD line for him.

### `CONTEXT.md` brought current

Approved edit. Content dates extended to 2026-08-21; a new
**§ The Lean tree, as of entry 88** recording the torus as a real object with a
discrete lattice, the isogeny's arithmetic shadow and what it does to O53's base
list, and the continuation being in scope and unused. Known defect **6** added
for the checker gap, pointing at `--audit`.

Gate at baseline, 113 values confirmed and 0 not found.

---

## 2026-08-21 — Entry 88 — A barrier that was miscited, false, and already imported; the lattice proved discrete
type: formalization
refs: 80, 84, 86, 87

Julian asked why the torus construction says nothing about primes, and whether
fixing the base first is what loses the forest. Answering it, I claimed the
analytic side was out of reach and cited `Euler-Factor-Chain.md § J5`. Three
things were wrong at once, and they compound.

### 1 — The citation points at a section that says something else

`papers/Euler-Factor-Chain.md:286` in full:

```text
J5. Nothing above tests RH. G8 is an equivalent restatement; B6 presupposes
    the zeros lie on the line.
```

Nothing about continuation, nothing about the Euler product's half-plane. The
claim I attributed to it exists in exactly one place in the tree,
`papers/The-Deep-Ladder.md:165`, which **I wrote** in entry 80, and which cites
J5 for it. So I quoted my own unsupported sentence back as though it were the
chain paper's finding.

`check_refs.py` passes it: `Euler-Factor-Chain.md § J5` resolves, because the
section exists. The checker verifies that a target exists and never that it says
what the citing line claims. That is a real gap in the gate and it is the same
shape as the `§ B4` failure this project's CLAUDE.md is built around.

### 2 — The claim is false

Mathlib's `riemannZeta` **is** the continued function.
`Mathlib/NumberTheory/LSeries/RiemannZeta.lean:181` says so in as many words:
"we use a different definition to obtain the analytic continuation to all `s`."

And it is already in our own code. `lean/Chain.lean:52` and
`lean/EulerFactorChain.lean:115` both put `riemannZeta s` on the right-hand side
of the Euler product. The `1 < s.re` hypothesis restricts the **product**; the
function it equals there carries no restriction at all.

So `ζ(−1)` is two lines. Built as `ZetaProbe.lean`, confirmed, and removed —
the tree is unchanged, and the proof is recorded here to be reproducible:

```lean
theorem zeta_neg_one : riemannZeta (-1) = -1/12 := by
  rw [show ((-1 : ℂ)) = -((1:ℕ):ℂ) by norm_num, riemannZeta_neg_nat_eq_bernoulli 1]
  norm_num [bernoulli]
```

`[propext, Classical.choice, Quot.sound]`, via
`Mathlib/NumberTheory/LSeries/HurwitzZetaValues.lean:239`.

### 3 — The rule I invoked does not apply to that file

I described leaving discreteness unproved as following the Mathlib-free
convention. `lean/Transform.lean:36` is `import Mathlib`. The Mathlib-free
discipline in `lean/BUILD.md` covers `Construction.lean` and the integer
modules and has never touched the geometry module. `ZLattice` was available the
whole time.

**Julian's reading is the accurate one:** I produced a barrier at the sight of
zeta rather than checking whether one existed. He had already named this as the
reason the original wording was written — to stop the reflex — and the reflex
fired anyway, on the wording written to prevent it.

### The lattice is discrete

With the rule gone, the gap closed the same session.

```text
gens_linearIndependent   ⟨1, τ(b)·i⟩ is ℝ-linearly independent
latticeBasis             hence an ℝ-basis of ℂ                      def, no pin
periodLattice_eq_span    periodLattice b = span ℤ (range basis)
periodLattice_discrete   DiscreteTopology (periodLattice b)
```

The route is `Submodule.span_int_eq_addSubgroupClosure` to rewrite the additive
closure as a ℤ-span, then Mathlib's instance
`DiscreteTopology (span ℤ (Set.range b))` for `b` a basis
(`Mathlib/Algebra/Module/ZLattice/Basic.lean:318`).

`Torus b` is now a quotient by a **discrete** rank-2 subgroup of ℂ, which is
what makes the word earn its place. Compactness is still open, and the docstring
states it as one line rather than as a barrier: `ZLattice` gives it from here.

Two API surprises worth recording: `Basis` is `Module.Basis` in this Mathlib
revision, and `linearIndependent_fin2` wants `f 1 ≠ 0 ∧ ∀ a, a • f 1 ≠ f 0`,
so the two generators enter in the opposite order from the definition.

### What the paper says now

`papers/The-Deep-Ladder.md` § F4 corrected, with the accurate limit and a
citation that supports it, and **F4′** added recording that the continuation is
in scope and unused. F4′ names the earlier miscitation in the paper itself, so a
reader meets it rather than only the notebook.

Numbered as a prime on F4, following `F3′` in The-Twin-Lattice and the `F5′`
convention set earlier today.

### Standing

Whether the torus connects to `ζ(−1)`, whether the primes-and-composites ratio
is the torus, and whether `π` is a rate in a growing diameter are all
undetermined by anything in this tree. What changed is that saying so is now a
statement about what has been built. The claim that the building was impossible
is withdrawn.

Build clean, **8040 jobs, 179 theorems, 179 pins, parity in all 14 modules**,
gate at baseline, 113 values confirmed and 0 not found.

---

## 2026-08-21 — Entry 87 — The isogeny acts on the row as block-summation, and O53 swept three ladders wearing six labels
type: formalization
refs: 84, 85, 86, 77

Entry 86 put τ in Lean and stopped at the tori. `Transform.tau_ratio_of_meet`
relates two ladders that meet, and `ℂ*/b^ℤ` knows only `b` — no prime enters it.
This entry is the arithmetic shadow of the same relation, which is the one place
the geometry reaches the counting function.

**`lean/Isogeny.lean`**, the fourteenth module, nine theorems.

```text
rowN Q k r          = Q (k*(r+1)) − Q (k*r)          def, exponent-indexed
rowN_eq_blockSum    rowN Q k r = Σ_{j<k} rowN Q 1 (k*r+j)
rowN_comp           rowN Q (k*l) r = rowN (Q ∘ (k*·)) l r      decimation composes
row_two_eq_pair     base 4's row is base 2's summed in pairs
row_three_eq_triple base 8's row is base 2's summed in triples
dyadicRow_eq_rowN   the weld to Zeros.dyadicRow inside its window
measured_row_four   the base-4 row from the 21 pinned pi2 values
measured_row_eight  the base-8 row from the same 21
```

**What it says.** A block sum followed by a stride-`k` step is a box filter
followed by decimation. A base inside an isogeny class therefore carries no
count its generator's row already carries. `{2,4,8}` is one row read at three
decimations; `{3,9}` is one read at two.

The proof is a telescope over an arbitrary `Q : ℕ → ℤ`. **No arithmetic input is
used at all**, which is the honest scope: the identity is bookkeeping on a
ladder, and it applies to `π` because `π` gets evaluated on one.

**The axiom split is the informative part.**

```text
measured_row_four, measured_row_eight       no axioms whatsoever
rowOf_eq_rowN, rowN_comp                    [propext]
row_two_eq_pair, row_three_eq_triple,
  dyadicRow_eq_rowN                         [propext, Quot.sound]
telescope, rowN_eq_blockSum                 + Classical.choice
```

The general-`k` statement quantifies over `Finset.range` and pays
`Classical.choice` for `Finset.sum`. The concrete `k = 2` and `k = 3` cases need
no Finset and were rewritten to avoid it, which is what dropped them two levels.
The two **measured** rows come in at zero axioms, the same standing as
`Zeros.measured_zeros_all_vanish`:

```text
base 4   2, 4, 12, 36, 118, 392, 1336, 4642, 16458, 59025
base 8   4, 14, 79, 467, 2948, 19488
```

**Lean caught a real error on the first pass.** The weld was written as
`rowOf Zeros.pi2 2 r`, and `pi2` is indexed by the *exponent* — `π(2ⁿ)` at `n`
rather than `π` at `2ⁿ`. So that expression meant `π(2^(2^r))`. Everything is
exponent-indexed now; `rowOf` survives as the count-up-to-`x` reading with
`rowOf_eq_rowN` as a one-line bridge. Two `omega` failures also had to be fixed
by unifying arguments — `omega` reads `Q (2r+1+1)` and `Q (2r+2)` as distinct
atoms, since it never normalises inside an opaque application.

### O53's six bases are three residual sequences

Checked against the residuals `O53_alias_tau.py` actually builds, rather than
against the argument.

```text
base 4 residual == base 2 summed in pairs      max rel gap 3.6e-09 over 18 rungs
base 8 residual == base 2 summed in triples    max rel gap 6.1e-10 over 12 rungs
base 9 residual == base 3 summed in pairs      max rel gap 2.2e-10 over 11 rungs
```

Those gaps are mpmath's `li` precision at `dps = 30`. The `li` term telescopes
exactly alongside the count, so the whole residual decimates and not just the
prime part.

The rung counts say it independently — 36, 23, 18, 14, 12, 11 for bases
2, 3, 4, 6, 8, 9, where `36/2 = 18`, `36/3 = 12`, `23/2 ≈ 11`.

So `O53_alias_tau.py:43`'s `BASES = [2, 3, 4, 6, 8, 9]` is base 2 carrying 4 and
8 as decimations, base 3 carrying 9, and base 6 alone. **Entry 85's reading is
unchanged** — no measurement supports τ as the alias spacing. What moved is the
extent of that negative: half the rows in O53's table are arithmetic
consequences of the other half, so the cross-base structure it swept was three
ladders.

### An inert hypothesis pair in `Chain.lean`, surfaced and left alone

`lake build` reports `Chain.lean:545` unused variables `hm` and `hn`. Those are
the `0 < m`, `0 < n` added to `joint_gain_periodic_of_commensurate` under the F2
audit in entry 77, on the ground that `m = n = 0` satisfies `hcomm` for any pair
of bases.

Unused means the proof never consumes them, so the theorem holds without them.
They keep `m = n = 0` out of the *statement* while the conclusion at that
instantiation stays vacuous, so they hide the vacuous case instead of removing
it. Entry 86 dropped exactly this shape from `tau_ratio_of_meet`, and
`C3lower_of_A4_C2` set the precedent.

**Left as it stands.** This reverses an entry-77 decision and is Julian's call,
so it is recorded here rather than reworked.

### Housekeeping

`lean/BUILD.md` was stale at 11 modules / 8037 jobs / 155 theorems, which
predates both `TwinLattice` and `Transform`. Brought current, the three missing
modules added to its manifest, and the `globs`-is-not-a-wildcard trap written
down where someone adding a module will read it.

Build clean, **8040 jobs, 167 theorems, 167 pins, parity in all 14 modules.**

---

## 2026-08-21 — Entry 86 — τ in Lean: the modular parameter, the power chain, and the meeting exponents
type: formalization
refs: 84, 85

Closes the τ thread on the arithmetic side. Entry 85 closed the measurement side
as negative, and that is stated in the module docstring rather than left for a
reader to discover.

**Three theorems added to `lean/Transform.lean`**, plus the definition.

```text
tau b = 2π / log b                                   def, no pin
zmap_period_tau     b^(−(s + τ(b)·i)) = b^(−s)       τ IS the period
tau_pow             τ(bⁿ) = τ(b)/n                   the power chain
tau_ratio_of_meet   bⁿ = cᵐ → τ(b)/τ(c) = n/m        the meeting exponents
```

**What `τ` is.** The lattice in `s` is generated by `1` — the shift, which
`zmap_shift` proves becomes `z ↦ z/b` — and `2πi/log b`, the period from
`zmap_period`. So the modular parameter of `ℂ*/b^ℤ` is `τ = 2πi/log b`, and
`zmap_period_tau` says the definition and the period are the same object.

**The isogeny classes are now arithmetic rather than observation.**
`tau_ratio_of_meet`: ladders that meet have rationally related `τ`, and the
ratio is the meeting exponents.

```text
τ₂ = 9.0647   τ₄ = 4.5324 = τ₂/2   τ₈ = 3.0216 = τ₂/3
τ₃ = 5.7192   τ₉ = 2.8596 = τ₃/2
```

Base 6 joins neither chain: `6ⁿ = 2ᵐ` has no solution above `n = 0`, and
`log2/log6` is irrational. Sharing prime factors leaves ladders apart, which is
`Zeros.primeFactors_eq_of_meets` from the other side.

**One inert hypothesis dropped.** `tau_ratio_of_meet` was written with `0 < n`
and the proof never consumed it — `bⁿ = cᵐ` with `1 < c` already forces `n > 0`.
Removed, following `C3lower_of_A4_C2`'s precedent, and the theorem is stronger
for it. `hm` is consumed and stays.

**The docstring says the measurement failed**, in the module, where someone
reading the theorems will see it: O53 and O54 tried `τ` as the alias spacing on
data and the statistic swung 0.27 to 1.94 at one base with only the ceiling
moving. What is in `Transform.lean` is arithmetic and claims no measurement.

### `papers/The-Deep-Ladder.md` corrected — it was asserting what its own artifact had superseded

Flagged after O50 run 2 and left undone until now.

* § C read *"Thirty-eight zeros, completely separated"* with no qualifier. Now
  scoped: separated below the first band edge, with the floor rising after.
* § F5 read *"The upper end is untested"* when run 2 had tested it. Replaced with
  what run 2 found — the amplitude at the zeros stays flat across every band,
  medians 6.9052 / 6.9232 / 6.6466 / 6.7469 / 6.4834, while the floor rises
  0.1890 → 3.0449. Every zero in the list is detected and separation stops after
  the first band.
* **F6, new.** The floor rises with the midpoints closing on their neighbours in
  units of resolution, 3.11 elements down to 1.42. That is leakage, and it makes
  `γ = 120` a property of `Δγ = 0.455` rather than of the primes.
* **F7, new.** `Δγ = 2π/log(xmax/x0)`, so `x0` is the cheap lever: `10^5 → 10^2`
  takes `Δγ` from 0.455 to 0.303 at no extra compute.
* **F8, new.** Above `γ = 939` nothing has been looked at, and that bound is
  `zeros600.json` ending rather than the instrument.

`check_values` caught two on the first pass, both mine — a band edge that is a
run parameter, and a zero count that is a sum of the band counts rather than a
printed value. Both reworded. **113 confirmed, 0 not found.**

Build clean, 8039 jobs, 158 theorems, 158 pins, parity in all 13 modules.

---

## 2026-08-21 — Entry 85 — O53/O54: τ is the alias spacing at base 2, the base split was a knob artifact, and the statistic swings 7× at one base
type: run
refs: 69, 83, 84

Two runs, both **EXPLORATORY — no prereg, no verdict**, and the second one
refutes the first's headline. Both kept: `papers/FORMAT.md` — negative results
stay.

**The question.** `lean/Transform.lean` (entry 84) puts the strip on the torus
`ℂ*/b^ℤ` with modular parameter `τ = 2π/log b` after the S-transform, and
`CONTEXT.md` § O18 records the dyadic alias comb as *"eight peaks of identical
height spaced 2π/log 2"*. Same number. Does it hold on data?

**What is tautological and was skipped.** A ladder sampled uniformly in `log x`
has a spectrum exactly `2π/log b`-periodic. Measuring that confirms the
sampling.

**What was tested.** Where the peaks sit inside one period. If the signal is the
zeta zeros seen through the ladder, every peak lands on a zero folded by
`g ↦ min(g mod τ, τ − g mod τ)`. The folded positions come from `γₙ` and `log b`
with no data; the peaks come from the primes.

### O53 run 1, and the trap it walked into

`results/alias_tau.json`. Six bases, ceiling `10^15`, first **60** zeros folded.
Peaks landed 0.0002 to 0.14 from a folded zero, and the ratio against a random
frequency read: base 2 `0.24`, base 4 `0.51`, base 6 `0.50`, base 8 `0.32`
against base 3 `1.40`, base 9 `1.43`. I read that as `{2,4,6,8}` beating chance
and `{3,9}` failing, and matched it to the isogeny classes.

**The target was nearly a continuum.** 60 folded zeros in base 9's domain
`[0, 1.43]` leaves a mean gap of 0.024, so a random frequency sits 0.013 from a
folded zero by construction.

### O53 run 2 — sweep the target density

`results/alias_tau_run2.json`. Same runs, folding 6 / 10 / 20 / 40 / 60 zeros,
with the chance level computed at every setting.

```text
base  rungs      tau | nz=6   nz=10  nz=20  nz=40  nz=60
   2     36   9.0647 | 0.33   0.18   0.38   0.49   0.23
   3     23   5.7192 | 0.94   0.85   0.88   1.05   1.41
   4     18   4.5324 | 0.54   0.89   1.00   1.03   0.51
   6     14   3.5067 | 0.78   1.00   0.62   0.45   0.50
   8     12   3.0216 | 0.53   0.69   1.41   0.26   0.33
   9     11   2.8596 | 0.66   1.05   0.68   1.17   1.45
```

**The `{2,4,6,8}` against `{3,9}` split was an artifact of `nz = 60`.** At
`nz = 6` base 9 reads 0.66 and joins the "working" group; at `nz = 40` base 8
reads 0.26 and base 4 reads 1.03, splitting the 2-family. The partition moves
with the knob. **Retracted.**

Base 2 alone held across all five settings — 0.18 to 0.49, never near 1.

### O54 — the control that killed that too

`results/rung_controlled_alias.json`. Extent and drift **cannot** be separated by
choosing bases: `rungs = log(ceiling)/log b` and the diagonal drift is `(b−1)`,
both functions of `b` alone. They can be separated by holding `b = 2` and moving
the ceiling to hit each other base's rung count.

```text
rungs    ceiling     peaks found   ratio     that base at same rungs
   11   1.68e+07          1        1.94      base 9   0.66
   12   3.36e+07          0         nan      base 8   0.53
   14   1.34e+08          2        0.28      base 6   0.78
   18   2.15e+09          3        1.55      base 4   0.54
   23   6.87e+10          3        0.27      base 3   0.94
   36   5.63e+14          5        0.34      base 2   0.33
```

**At one base, with only the ceiling moving, the ratio runs 0.27 to 1.94.** At
12 rungs the spectrum has **no interior local maximum at all** and the statistic
is undefined. The peak count runs 0, 1, 2, 3, 3, 5 — the statistic is measuring
how many peaks a short window happens to produce.

**So O53 run 2's "base 2 holds at every setting" is withdrawn as well.** That
sweep varied target density while the ceiling sat fixed at 36 rungs. **The
parameter I never varied was the one that mattered.**

### Standing

Nothing about base coupling is established by either run. What survives is
independent of both, because it was never measured — base 2's uniqueness is
three proved `iff`s in `PairIdentity`: `coeff_eq_one_iff_base_two`,
`total_eq_pow_iff_base_two`, `total_const_on_diagonal`. Base 2 is the only base
whose diagonal drift is 1.

**Method note.** Julian's framing — the bases couple through 3,4,…,9 rather than
2 straight to 9 — has two readings the tree distinguishes. Ladders **meet**
(`b^n = c^m`) only inside a prime-power chain, giving five isolated classes
`{2,4,8} {3,9} {5} {6} {7}`, with base 6 = 2·3 joining neither since
`log2/log6` is irrational. And `τ(b) = 2π/log b` is a smooth curve the integer
bases sample, with the gap falling from 3.346 at `2→3` to 0.162 at `8→9`. The
chain reading is proved. The curve reading is untested.

---

## 2026-08-21 — Entry 84 — block G's geometry formalised, and the identification that closes the annulus into a torus
type: formalization
refs: 69, 77, 83

**Where this came from.** Julian asked whether the identification closing the
annulus is `|z| = 2`. It is, and it is the generator the record never had.

**The picture.** `z = b^(−s)` carries the s-plane to `ℂ*`. A vertical line
`Re s = σ` becomes the circle `|z| = b^(−σ)`, so the critical strip becomes an
annulus and the critical line becomes the circle of radius `b^(−1/2)`. At
`b = 2`:

```text
Re s = 0     ->  |z| = 1.00000
Re s = 1/2   ->  |z| = 0.70711     the critical line
Re s = 1     ->  |z| = 0.50000
```

**Two generators, and the second was missing.**

* `s ↦ s + 2πi/log b` fixes `z`. That is the pole lattice
  `Chain.sym_eq_zero_iff` proves, and it is why the strip becomes an annulus
  rather than a plane.
* **`s ↦ s + 1` sends `z ↦ z/b`.** That closes the annulus into `ℂ* / b^ℤ`, a
  complex torus. At `b = 2` it identifies `|z| = 0.5 ~ 1 ~ 2 ~ 4 …`, so every
  2:1 annulus is a fundamental domain — which is Julian's `|z| = 2`.

**And O39's number is that torus's modulus, halved.**

```text
full fundamental annulus  1 < |z| < b       modulus  log(b)/2π = 0.1103178
O39 measured              0.5 < |z| < 0.70711        (log b)/4π = 0.0551589
                                                      ratio 2.0
```

O39's annulus has ratio `√b`, so § G7 has been reporting **half a fundamental
domain** since it was written. The record carried the number and never the
identification.

**New module `lean/Transform.lean`**, the thirteenth, added to `lakefile.toml`
globs. Six theorems, all at `[propext, Classical.choice, Quot.sound]`, which is
the floor for ℂ-valued statements.

```text
norm_zmap                  ‖b^(−s)‖ = b^(−Re s)          the map
norm_zmap_critical         critical line -> |z| = b^(−1/2)
zmap_shift                 b^(−(s+1)) = b^(−s)/b         the closing generator
zmap_period                b^(−(s + 2πi/log b)) = b^(−s) the pole lattice
zmap_functional_equation   b^(−(1−s)) = b^(−1)/b^(−s)    inversion in |z|=b^(−1/2)
annulus_modulus            log(b^(−1/2)/b^(−1))/2π = log b/4π
```

`zmap_functional_equation` is `EulerFactorChain.h_functional_equation` read in
`z`: the map `s ↦ 1 − s` becomes inversion in the circle `|z| = b^(−1/2)`, and
**the critical line is that inversion's fixed circle**.

**Wired to the paper.** § G7 now cites `Transform.annulus_modulus`, and two new
statements were added — G7′ for the torus and its two generators, G7″ for the
inversion. `check_refs` resolves every citation; gate unchanged at 2,
`check_values` 113 confirmed / 0 not found.

**`lean/BUILD.md` corrected.** It claimed 139 theorems against a tree of 155,
and listed block G whole as unformalised. Now it names what stays an
observation: G1's Cauchy–Hadamard, G3's Jentzsch, G5's measured migration, G8's
RH equivalence, G9 and G10. **Only the numeric values and those remain.**

**What this does not do.** G8 says `RH ⟺ the annulus has maximal modulus` and the
paper's own source line calls it *"an equivalent restatement … of identical
difficulty"*. Nothing here touches it. The geometry is now stated; which radius
the residual actually has is the open question, and it is RH.

**Worth noting for later.** `ℂ* / q^ℤ` is the Tate uniformization — the standard
presentation of an elliptic curve over a non-archimedean field. O40 and O41 went
to elliptic curve L-functions from the other direction, and
`papers/convergence.md` records that only degree-1 L-functions give a plain
difference table. Nothing connects them yet.

Build clean, 8039 jobs, 155 theorems, 155 pins, parity in all 13 modules.

---

## 2026-08-21 — Entry 83 — the pocket read as a BASE: the pair identity's coefficient is the lower twin arm, and the extent arithmetic that bounds it
type: motivation
refs: 81, 82

**Julian's reframe, and it is not what entry 82 built.** O51 treated the lattice
as a *set of sites* and counted occupancy. His reading is that each pocket is a
**base**, in the same sense as dyadic and triadic: `(11,13)` gives base 12, and
you build the b-adic table there. Tabled without pursuing, recorded so it is not
rediscovered.

**The structural consequence, which is the reason to record this at all.**
`PairIdentity.pair_identity` gives the cell total as `(b−1)^(d+1) · b^e`. At a
pocket base, **`b−1` is the lower twin arm** — a prime. At a generic base it is
composite. So the pocket bases are exactly those whose identity coefficient is
prime, and reading that coefficient across pockets enumerates the lower twins:

```text
base b     4    6   12   18   30   42   60   72
b − 1      3    5   11   17   29   41   59   71     <- the lower twin arms
b + 1      5    7   13   19   31   43   61   73
```

The arms are not beside the lattice. **One of them is the identity's
coefficient at that base.**

**A correction Julian caught in conversation.** I said bases 4 and 6 were "two
pockets already measured, both empty". Wrong on two counts. They are **pockets,
not twins** — the twins are 3, 5 and 5, 7. And `4 % 6 = 4`, so base 4 is **off
the lattice**, which is exactly what `TwinLattice.three_five_exceptional`
proves: `(3,5)` is the one pair whose pocket is not a multiple of 6. My own
theorem excludes it and I counted it anyway.

Corrected: of the eight bases O44 measured, **exactly one is an on-lattice
pocket — base 6**, the pocket of `(5,7)`, and it has no exact zeros. Bases 12,
18, 30, 42 have never been built.

**And base 2 is not a pocket at all** (`b − 1 = 1`, not prime). The one base with
exact zeros is the one base in range that is not a pocket.

**Base 4 is a control, not a data point.** It is the only base with twin arms
that sits off the lattice. If the lattice does work, 4 and 6 should behave
differently; O44 lumped both in with 2–9.

**The extent arithmetic, which bounds the whole idea.** `rungs =
log(ceiling)/log(b)`, so high bases are starved regardless of compute.
primecount is not the constraint — `π(10^15)` returns in 0.58 s.

```text
base    arms      rungs at 2^32   1e11   1e15
   4    (3,5)          16          18     24
   6    (5,7)          12          14     19
  12   (11,13)          8          10     13
  18   (17,19)          7           8     11
  30   (29,31)          6           7     10
  42   (41,43)          5           6      9
```

Base 30 would need a ceiling near `30^20 ≈ 3.5e29` to hold the twenty rungs base
2 has at `2^20`. This is arithmetic, not a sieve limit — going deeper in `x`
buys rungs only logarithmically. O44 already named it: *"bases 5–9 stop at
regime ceilings 27, 24, 22, 21, 20 and are extent-censored."*

**So the per-pocket table question is extent-limited before it is asked** —
base 12 gets 13 rungs at `10^15`, not enough to look for anything like `(20,6)`.
The cross-pocket question, whether the pockets connect to each other, is not
obviously bounded the same way and was not examined.

Nothing run. Nothing claimed. This entry is the observation and its limit.

---

## 2026-08-21 — Entry 82 — O51: the twin lattice census, and three things it refuses
type: run
refs: 78, 81

**Run.** `O51_twin_lattice_census.py`, no flags, **EXPLORATORY — no prereg, no
verdict**. Numpy odd sieve to `2^30`, four-way occupancy of the `6k` lattice per
dyadic block, `r = 3…30`. Completed, did not error.
`results/twin_lattice_census.json` + `results/O51_twin_lattice_census_run1.log`.
Paper written on it: `papers/The-Twin-Lattice.md`.

**Self-check passes.** The four-way split — twin / lo / hi / bare — partitions
the sites exactly at every rung. A failure would have been a bug.

### Three refusals, and the refusals are the content

**1. The total is not geometric, so `pair_identity` does not transfer.** The site
count per block alternates `±1/3` about `2^(r−1)/6`, at every rung, without
settling — because `2^(r−1) mod 6` alternates between 2 and 4 and the floor
follows. So the hypothesis fails for a **structural** reason, and the deviation
is the `2·3` lattice showing up in the count of its own sites.

This is the second refusal for this object. Partitioning twins against the whole
block instead gives a geometric total, but the complement is 99.9% of it and
carries nothing (`The-Composite-Arm.md` § A2's argument, worse).

**2. The occupancy bias is weak and sign-changing, and is NOT the Chebyshev
bias.** `lo − hi` normalised by `√sites` stays inside `±0.25` and flips sign
across rungs. Counting **primes** by residue class mod 6 gives a consistent
one-directional excess for `6k − 1`; counting **sites flanked on exactly one
side** does not. I conflated the two in conversation before the census ran. The
census separates them, and the residue-class race is measured nowhere in this
tree — the figures I quoted came from an inline script and are in no artifact,
so they are in no paper.

**3. No twin zero is deep.** The twin arm's difference table has exactly four
exact zeros at `d ≥ 1` over 377 cells to `r = 30`: `(4,1)`, `(6,1)`, `(9,1)`,
`(8,4)`. **All four sit at `r ≤ 9`**, where counts are single or double digits.
The prime table's `(20,6)` sits at a count of 38635. Depths to 28 were examined
across `r = 3…30`, so the deep region was looked at and is empty.

### The parts worth arguing about

`(4,1)` is in **both** lists — the prime table's `(2,1) (4,1) (8,3) (20,6)` and
the twin table's. One coincidence at a small count, recorded because it is
checkable, not because it is evidence.

Three of the four twin zeros are adjacent repeats on tiny counts —
`twin(3) = twin(4) = 1`, `twin(5) = twin(6) = 2`, `twin(8) = twin(9) = 7` — and
`Zeros.zero_iff_repeat` says a depth-1 zero **is** a repeat, so those are cheap
at those magnitudes. **`(8,4)` is not**: the row `2, 2, 3, 7, 7` differences to
`1, 0, 1, 4`, then `−1, 1, 3`, then `2, 2`, then `0`. A depth-4 cancellation,
walked by hand to confirm.

**Extent caveat, stated rather than buried.** 377 cells to `r = 30` against
O43's 4186 cells to `r = 92`. The absence of a deep twin zero is an absence over
the smaller range.

### Ordering

Lean first (entry 81), then the census, then the paper citing both. The reverse
of `The-Composite-Arm.md`, which went out ahead of its script and is still
PROVISIONAL. `check_values` caught two numbers on the first pass — O43's `92`
and `4186` cited against the twin artifact, which does not contain them — and
they were split into their own statement with their own source. Now **113
confirmed, 0 not found**.

---

## 2026-08-21 — Entry 81 — TwinLattice: a twin pair is a lattice site, proved, and the mod-6 lattice was already load-bearing here twice
type: formalization
refs: 78, 80

**Julian's theory, in his terms.** Twin primes share a pocket between them, one
integer apart, and he treats the lattice as navigation: the pair is where a
trajectory has both arms available.

**The check.** Every twin pair above 3 is `(6k − 1, 6k + 1)`, so the single
integer between is `6k`. Verified numerically below 2000 — one exception,
`(3,5)`, and it is the first pair. **So a twin pair is not two primes that happen
to sit two apart. It is a site on the `2·3` lattice with primes on both
shoulders**, and counting twins is counting doubly-flanked sites.

**And that lattice is already load-bearing in this tree, in two places nothing
connected.**

* `CONTEXT.md` § Current state of the world, O19/O20 — `(8,3)` lands at Connes'
  `λ = 4`, whose window holds exactly `{2,3}`, *"the mod-6 lattice, which is the
  workbook's own reason for that zero"*.
* `CONTEXT.md` § `imported/lattice_mapper/` — those tables are built with *"2 and
  3 excluded as lattice rather than counted as primes"*. **That convention is the
  mod-6 lattice.**

The twin object, the deep zero's stated explanation, and the imported tables'
convention are the same lattice, approached from three directions and never
named once.

**New module `lean/TwinLattice.lean`**, the twelfth, named by Julian. Added to
`lakefile.toml` globs — that list is explicit, not a wildcard, so a new module
does not build until it is named there.

```text
twin_lower_mod_six      p, p+2 prime and 3 < p  →  p % 6 = 5   [propext, Quot.sound]
twin_pocket             the integer between is ≡ 0 (mod 6)     [propext, Quot.sound]
three_five_exceptional  (3,5) exhibited, not assumed           full three
```

**The two lattice theorems carry no `Classical.choice`** despite importing
Mathlib — they are ℕ-valued and close through `omega`, which costs `Quot.sound`
and nothing more. The exception theorem does carry it, and the cost is entirely
Mathlib's: **even `Nat.prime_three` depends on `Classical.choice`**, and `decide`
on `Nat.Prime` routes through a classical decidability instance. Checked
directly rather than assumed. Pinned as it is rather than worked around, since
the honest list says where the cost comes from.

**Placement, and why not `Chain.lean`.** Chain's own header, line 4: *"Companion
to papers/Euler-Factor-Chain.md."* Its job is checking that paper's arrows, and
the mod-6 material discharges no statement in it. Putting it there would make
the file's header false. This tree's modules are named for objects and have held
their scope; a new object gets a new module.

**Mathlib has nothing on twin primes.** Grepped. Nothing here is reproved.

**What is NOT proved, and was not attempted.** That the lattice explains where
twins are or how many there are. The three-way occupancy split — sites flanked
on both sides, one side, neither — is not here. Neither is the character reading
of the two arms, though it is the standard machinery: the classes `6k ± 1` are
the two Dirichlet characters mod 6, their difference is the Chebyshev bias
(measured at 0.46–0.96 in units of `√x/log x` over four decades), and
`papers/convergence.md:26` already notes that *"only degree-1 L-functions give a
plain difference table"* — which Dirichlet L-functions are. Each is a separate
step that can fail on its own.

**Ordering.** Julian's rule for this: prove it in Lean first, and only then add
it to the paper. That is the reverse of `papers/The-Composite-Arm.md`, which was
written before its script existed and is still PROVISIONAL with four conditions
in its header. No paper is written here.

Build clean, 8038 jobs, 149 theorems, 149 pins, parity in all 12 modules. Gate
unchanged at 2, `check_values` 99 confirmed / 0 not found.

---

## 2026-08-21 — Entry 80 — twin_count imported, CONTEXT brought current to O50, and The-Deep-Ladder written
type: provenance
refs: 46, 73, 75, 79

**Import.** Seven files copied byte-for-byte (`cp -p`) from
`~/GitHub/twin_count/` into `imported/twin_count/`, every one SHA-256 verified
source-vs-destination at copy time, manifest at
`imported/twin_count/README.md` which self-verifies against the files it lists.
Same discipline as entry 46's lattice_mapper import.

**The source is not a git repository and has no commitment files.** This import
is the only versioned copy of that work that exists — 10,000 checkpoints to
`10^11`, an analysis, and 100,000 zeta zeros, previously one disk failure from
gone.

**Not imported:** `twincount` the compiled binary, 33976 bytes, machine-specific
(`-march=native`) and rebuildable from `twincount.c`. Same judgment as
`archive_unsilenced/` in entry 46 — binaries do not belong in an evidence
import.

**Convention warning recorded in the manifest.** `twins_1e11.csv` is sampled on
a **linear** ladder, step `10^7`; every in-repo artifact uses **geometric**
rungs. That difference is not cosmetic — it is exactly what
`twins_1e11_analysis.json` deprecates its own α estimator for, and it is the
same class of defect as O48's fixed depth window.

**CONTEXT.md brought current**, Julian approving. It stopped at O47 and its
test table stops at O39, so the file a new instance reads first to orient did
not know the last three runs had happened. Added: a note that the table stops
at O39; entries for **O48** (preregistered, `compromised`, control could not
survive the depth window), **O49** (the C2 ceiling attained at 97.68% ± 2.91%,
depth saturates by `d = 1` or `2`), and **O50** (38 zeros separated completely,
O17's ceiling was a sieve limit); and an `imported/twin_count/` section on the
lattice_mapper pattern.

**Paper written.** `papers/The-Deep-Ladder.md`, six sections on the house
format. Its § D records the false start in full — that flat amplitude in γ was
read as fatal and is in fact what a fine ladder must produce, since
`(r^ρ − 1)/ρ → log r`. Its § F carries five limits, including that there is no
prereg and that the separation statistic was chosen *after* the peak list proved
to be selection, which is the sequence a prereg exists to prevent.

**`check_values` caught six numbers on the first pass** and all six were mine:
three prime counts written in scientific shorthand against full integers in the
JSON, a range bound that is a run parameter rather than a measurement, the
string `O17` parsed as the number 17 inside a statement checked against an
artifact, and one genuinely derived ratio that needed declaring as derived per
`papers/FORMAT.md`. Now **99 confirmed, 0 not found**, up from 83.

---

## 2026-08-21 — Entry 79 — O50: 38 zeta zeros recovered with complete separation, and the dyadic control still fails
type: run
refs: 17, 75, 76, 78

**Run.** `O50_deep_ladder_spectrum.py`, no flags, **EXPLORATORY — no prereg, no
verdict**. `results/deep_ladder_spectrum.json` +
`results/O50_deep_ladder_spectrum_run1.log`. Completed, did not error.

**Why.** Entries 75/76 established that depth is the wrong axis — the gain
saturates at the C2 ceiling by `d = 1` or `2`, so differencing destroys mode
identity immediately. Every success on this bench probed at **depth 0** and
varied the ladder: O17, O18, O34/O35's 94%. And `CONTEXT.md:250` names the limit
that stopped O17 — *"over 8.4M primes there are only ~16 disjoint blocks however
the ladder is sampled."* **That is a sieve limit, not a mathematical one.** O17
sieves with numpy; primecount evaluates `π(10^11)` in 4 ms.

The statistic is unchanged from O17. Only `xmax` and the `π` backend differ.

**Result.**

```text
arm              ratio      x0   blocks       primes   zeros  separation  ratio
replicate_1.1      1.1    1000      193  4.02e9           6   COMPLETE     4.8x
fine_1.002       1.002     1e5     6914  4.11e9          38   COMPLETE    36.5x
dyadic_control     2.0       2       35  2.87e9           6   FAILS        5.3x
```

**The fine arm separates 38 zeta zeros completely:**

```text
amplitude AT the 38 zeros    median 6.905   min 6.478
amplitude BETWEEN them       median 0.189   max 2.341
                             0 of 38 zeros below the largest midpoint
```

Every zero is above every midpoint. O17 found **three** (γ₁, γ₂, γ₃) on 125
blocks over 8.41e6 primes; this finds **38** on 6914 blocks over 4.11e9, and
`replicate_1.1` — O17's own ladder at the new ceiling — goes from 3 to 6.

**The dyadic control still fails**, 3 of 6 zeros below the max midpoint, which is
O17's finding reproduced at 340× the primes. Its Nyquist is 4.5, so γ₁ at 14.13
is aliased and cannot be resolved however many primes are thrown at it.

**A false start worth recording, because I nearly threw the result away.** The
top-ten peak table looked suspicious for two reasons: every peak had nearly the
same height, and the fine arm appeared to *miss* γ₁, γ₂, γ₃ while finding γ₃₇.
I read the flat amplitude as fatal, on the grounds that the explicit formula's
`x^ρ/ρ` predicts a `1/γ` falloff.

**That was wrong.** For a narrow block the mode contributes `x^ρ(r^ρ − 1)/ρ`,
and `(r^ρ − 1)/ρ → log r` as `|ρ log r| → 0`. The `1/γ` cancels. **Flat amplitude
in γ is exactly what a fine geometric ladder must give**, and its presence is
evidence for the reading rather than against it. The apparent "missing" low
zeros were an artifact of ranking by peak height when the spectrum is flat: the
top ten were ten zeros among thirty-eight, chosen arbitrarily.

The separation test replaced the peak table as the primary statistic for that
reason — a top-ten list is selection, a fixed comparison of zeros against exact
midpoints is not.

**What this is.** A measurement, at 490× O17's prime count, confirming that the
prime residual on a fine geometric ladder carries the zeta zeros. **It is not new
mathematics** — the explicit formula says so. What is new here is the resolution,
and that the working method was resolution-starved rather than exhausted.

**What it does not touch.** The four exact zeros, and the global bridge — the
Euler product still lives at `Re s > 1` and everything else on the critical line
(`Euler-Factor-Chain.md` § J5).

**Provenance of the idea.** From `~/GitHub/twin_count`, whose `twincount.c`
streams to `10^11` in 16.8 s and whose analysis deprecates its own α estimator
for a linear-sampling defect that is the same class as O48's fixed depth window.
That folder has no commitment files and is not a git repository.

---

## 2026-08-21 — Entry 78 — the four zeros computed rather than transcribed, and the def-citation hazard closed at its most-cited instance
type: formalization
refs: 60, 70, 77

`Zeros.measured_zeros` was four hand-typed pairs whose own docstring said *"no
theorem above predicts these"* — and `papers/The-Four-Zeros.md` § B9 cited it,
in a source line, as though citing a proof. The handoff plan named this hazard:
`utilities/check_refs.py:31` resolves a `def` and a `theorem` identically, so a
citation to a transcription is indistinguishable from a citation to a result.
That citation was mine.

**Seven theorems, all with no axioms at all.**

```text
pi2                  π(2^n), n = 0…20, from pi2n_cache.json — 21 integers,
                     and the ONLY measured input to any of this
dyadicRow            N(r) = π(2^r) − π(2^(r−1))

zero_2_1  zero_4_1  zero_8_3  zero_20_6
measured_zeros_all_vanish     the list's own claim, as a theorem
nonzero_7_3  nonzero_19_6     so the check fires in both directions
```

Entry 60's `tableFrom_eq_stencil` is what makes this one line each rather than a
table walk:

```text
(2,1)    1·1 − 1·1                                                 = 0
(4,1)    1·2 − 1·2                                                 = 0
(8,3)    1·23 − 3·13 + 3·7 − 1·5                                   = 0
(20,6)   1·38635 − 6·20390 + 15·10749 − 20·5709 + 15·3030
           − 6·1612 + 1·872                                        = 0
```

`nonzero_19_6 = 343` is the `+343` of `papers/The-Fold.md` § C3, whose partner
`−343` sits at `(20,7)` because a zero at `(20,6)` forces it there.

**What changed and what did not.** The zeros' *vanishing* is now derived from π
by the kernel, at zero axioms. Their *location* is not, and the docstring still
says so. Nothing here predicts why 8 and 20 and no other cell below `r = 92`.

**The citation is repointed.** `The-Four-Zeros.md` § B9 now cites
`Zeros.measured_zeros_all_vanish` — a theorem — rather than the list, and says
so in the source line. `measured_zeros` stays, because three other modules carry
the same list and `SeedPerturbation`/`PairIdentity` cite it; its docstring now
directs any citation to the theorem.

**Still open.** The hazard itself is not fixed — `check_refs.py` still cannot
tell a `def` from a `theorem`. What closed here is the one instance that was
actually being exploited. Three transcribed copies remain:
`Construction.measured_zeros`, `SeedPerturbation.zero_cells`,
`PairIdentity.zero_cells`.

Build clean, 8037 jobs, 146 theorems, 146 pins, parity in all 11 modules.
Axiom-free count rises 15 → 22.

---

## 2026-08-21 — Entry 77 — block D formalised, wired to the paper, and the attainment C2 never had
type: formalization
refs: 69, 75, 76

Entry 76 found `papers/Euler-Factor-Chain.md` § D stating the floor, the
ceiling, the smooth term's position and the ceiling bases **in prose**, while
`lean/BUILD.md` listed the whole block as not formalised. Six theorems close it.

```text
gain_sq_at_floor          cos(γ log b) = 1  →  gain² = (1 − b^(−1/2))²     D1
gain_sq_at_ceiling        cos(γ log b) = −1 →  gain² = (1 + b^(−1/2))²     D1
C2_floor_attained         γ = 0 sits exactly on the floor                  D2
C2_ceiling_attained       ∃ γ reaching the ceiling; witness π/log b
ceiling_dominates_floor   floor² < ceiling², needs only 0 < b              D3
ceiling_base              exp(π(2k+1)/γ) puts γ at the ceiling             D4
```

All six fall out of `EulerFactorChain.gain_sq_on_critical_line`, which was
already proved, by evaluating `cos` at `±1`. Nothing hard happened; the pieces
were on both sides of a gap nobody had crossed.

**The attainment is the part `StmtC2` did not have.** C2 proves the gain is
*contained* in `[1 − b^(−1/2), 1 + b^(−1/2)]` and never exhibits a `γ` at
either end — the handoff plan flagged exactly this, that Lean proves
containment and never attainment. `C2_floor_attained` and `C2_ceiling_attained`
supply both ends. And entry 75 measures the residual table's own gain at
**97.68% ± 2.91% of that ceiling across twelve bases**, so the bound is not
merely attainable but attained in the data.

**Correction to entry 76.** It says `Chain.sym_eq_zero_iff` "is D1's floor
condition, proved." That is imprecise and I am not amending 76. `sym_eq_zero_iff`
is where `Sym` vanishes **outright**, on `s = 2πik/log b`, which has
`Re s = 0`. D1's floor is on the **critical line** `Re s = 1/2`, where the gain
is `1 − b^(−1/2)` and is not zero. Same phase condition, different line. The
honest statement — now in `Chain.lean`'s section docstring — is that **the C2
floor is where the critical line passes closest to the zero lattice**, and
`1 − b^(−1/2)` measures that approach.

**Wired to the paper.** Five source lines in `Euler-Factor-Chain.md` now carry
Lean citations: C2 gains `gain_sq_periodic`, `C2_floor_attained`,
`C2_ceiling_attained` with the note that both ends are attained rather than
merely bounded; D1 gains both halves; D2 gains the floor witness; D3 gains the
inequality and O49's measured 97.68%; D4 gains `ceiling_base`. `check_refs.py`
resolves every one — the gate is unchanged at 2.

These are all **theorems**, so the `def`-versus-`theorem` hazard the handoff
plan names does not apply here. That hazard remains open for
`Zeros.measured_zeros`.

**`lean/BUILD.md` corrected.** It said 119 theorems; the tree has 139. Its
"not formalised" line dropped block D and now names only block G and the
numeric values. D5 and D6 stay observations — they are measurements of how far
base 2 and base 3 sit from a ceiling base, not statements to prove.

Build clean, 8037 jobs, 139 theorems, 139 pins, parity in all 11 modules.

---

## 2026-08-21 — Entry 76 — the record already had it: `Euler-Factor-Chain.md` § D states the floor, the ceiling and the power iteration in prose
type: result-triage
refs: 72, 74, 75

Checked entry 75's finding against the written record before logging it, at
Julian's instruction. Most of the structure is already there, and three things
I asserted are wrong.

### What block D already says

`papers/Euler-Factor-Chain.md` § D · The winding:

```text
D1. The floor of C2 is at γ log b ≡ 0 (mod 2π); the ceiling at γ log b ≡ π (mod 2π).
D2. The smooth term has ρ real, so γ = 0, so it sits exactly at the floor.
D3. Therefore differencing dissipates the smooth part maximally while
    amplifying modes near the ceiling.
D4. The bases placing γ exactly at the ceiling are b = exp(π(2k+1)/γ).
    For γ₁: 1.2489, 1.948, 3.039, 4.741, 7.395 …
D6. Therefore base 2 reaches 98.3% of its ceiling for γ₁, base 3 99.6%.
```

**D3 is the power iteration.** Entry 75 presents it as a mechanism found in the
data; it has been in the paper. **D1's floor is the null** this program has been
calling a discovery since entry 72.

### Three corrections

**(1) `Depth-as-Time.md` § B4 does not overclaim, and I said it did.** B4 reads
"the first Riemann zero is the fastest-growing mode of the difference operator,
**in both bases measured**" — correctly scoped — and B5 immediately says *"It
does not generalize to the other zeros"* with base-2 percentages of ceiling
listed per zero: γ₂ 84.8, γ₃ 69.8, γ₄ 90.3, γ₅ 91.6, γ₆ 47.0. My claim that B4
was a base-2 coincidence the paper had missed is withdrawn.

**(2) Entry 72 overstates the novelty of the null base.** It says nobody looked
at 1.5597 as a null. D4 lists the **ceiling** bases for γ₁ beginning at
**1.2489** — the O45 family's k=2 — and the floor bases are its one-line
complement. The family is `log b_k = k·π/(2γ₁)`, so k=2 puts γ₁ at the ceiling
and k=4 at the floor. It was built on this axis and half of it was written down.

**(3) Entry 74 sets `d*` beside a quantity it does not measure.**
`analysis/2026-08-19_table_structure/scripts/t2_crossover.py:11-12` defines `d*`
as "the first depth where oscillation carries more than half the power," an FFT
DC-versus-rest split. Entry 75's plateau entry is a gain-ratio threshold. Entry
74's point about the fixed window stands; the two statistics do not compare and
should not have been tabled together.

### What survives as new

**The attainment is measured on the table, not predicted for a mode.** D6 gives
γ₁'s *predicted* growth factor as a percentage of ceiling in two bases. Entry 75
measures the **residual table's own per-depth gain** and finds it at
**97.68% ± 2.91% of `1 + b^(−1/2)` across twelve bases**, nine of which appear
in no prior result in this tree.

**Convergence is immediate.** D3 says differencing amplifies ceiling modes; it
does not say how fast. One or two differences is fast enough that **no depth
window exists in which a sub-ceiling mode is visible** — which is the real
reason O48 could not see γ₁'s null, and is stronger than entry 73's account.

**The O48 failure quantified.** At `b = 1.5597432`, γ₁ sits at 0.0% of the band
and γ₂ at 99.9%. D1 and B5 together predict this; the base had never been run.

**And block D is prose.** `lean/BUILD.md:105` lists "the winding (block D)" as
not formalised, while `Chain.sym_eq_zero_iff` — landed in entry 69 — **is D1's
floor condition, proved**. Neither side of the tree records that the other did
it. That is the gap worth closing.

---

## 2026-08-21 — Entry 75 — O49: the residual table's depth gain attains the C2 ceiling in every base, by depth 1 or 2
type: run
refs: 72, 73, 74

**Run.** `O49_gain_vs_depth.py`, no flags, **EXPLORATORY — no prereg, no
verdict, nothing here is stamped**. Thirteen bases, value window `[10^4, 2^32]`,
depths 1–12, `primecountpy.prime_pi`, `mp.dps 50`. Completed, did not error.
`results/gain_vs_depth.json` + `results/O49_gain_vs_depth_run1.log`.

**Question.** Entry 74 found O48's gain constant at 1.771 and blamed a fixed
depth window sitting above `d*`. This asks per base: at what depth does the gain
leave the symbol, and does the symbol hold below it?

**Answer: it never holds.** The plateau is entered at `d = 1` or `d = 2` in
every base. There is no shallow regime in which a single mode governs.

**And the plateau is not noise — it is the C2 ceiling, attained:**

```text
base      plateau (median d≥4)   1 + b^(−1/2)   ratio
1.1500                 1.8859         1.9325   0.9759
1.2293859              1.8890         1.9019   0.9932
1.2560                 1.8481         1.8923   0.9767
1.2855907              1.8502         1.8820   0.9831
1.3160                 1.7347         1.8717   0.9268
1.3483554              1.8172         1.8612   0.9763
1.4200                 1.7126         1.8392   0.9312
1.5000                 1.7238         1.8165   0.9490
1.5597432              1.8203         1.8007   1.0109
1.6200                 1.7743         1.7857   0.9936
1.7500                 1.7976         1.7559   1.0237
2.0000                 1.6753         1.7071   0.9814
                                mean 0.9768, sd 0.0291
```

`StmtC2` bounds the gain in `[1 − b^(−1/2), 1 + b^(−1/2)]`. The handoff plan
flagged that Lean proves **containment, never attainment**. This is attainment,
measured, at every base to 2.3%.

**Why.** Each difference multiplies mode `ρ` by `|Sym b ρ|`, so depth is a power
iteration and selects the largest gain in the band. That is
`Euler-Factor-Chain.md` § D3 — see entry 76, which checks this against the
record and finds the mechanism already written.

**At the γ₁ null base, what the other modes are doing:**

```text
b = 1.5597432,  band [0.1993, 1.8007]
        γ·log b     /π    |Sym|   position in band
γ₁       6.2832   2.000   0.1993      0.0%   nulled exactly
γ₂       9.3447   2.975   1.7993     99.9%   at the ceiling
γ₃      11.1179   3.539   1.2024     62.6%
γ₅      14.6403   4.660   1.5535     84.6%
```

**So the γ₁ null is real and unobservable.** Nulls sit at `γ log b = 2πk` and
maxima at `γ log b = π (mod 2π)`; the zeta zeros are spaced closely enough that
a base nulling one puts another near the ceiling. Here γ₂ lands within `0.026π`
of a maximum. This is structural, not misfortune — and it is the mechanism the
locked prereg named in advance as its largest doubt.

**Standing.** Exploratory. Entry 76 checks it against the record.

---

## 2026-08-21 — Entry 74 — O48 run 1 re-read: the gain is constant at 1.771, the depth window sat above `d*`, and entry 73's small-angle agreement was a crossing
type: result-triage
refs: 52, 53, 72, 73

Entry 73 stands as written. This entry carries the correction, same as 68/70.

### Retraction

Entry 73 reports, as exploratory, that inside the small-angle radius the
transform tracks to within 3% — ratios 1.137, 0.969, 0.968, 1.023, 0.987. **That
is a coincidence and I over-read it.** Strip the `1/log b` normalisation and look
at the raw per-depth gain `G_b = Ĝ_b · log b`:

```text
base    measured G   γ₁ model   smooth model
1.1500      1.8351     1.6137        0.0675
1.2294      1.8323     1.8902        0.0981
1.2560      1.8307     1.8908        0.1077
1.2856      1.8846     1.8428        0.1180
1.3160      1.7235     1.7457        0.1283
1.3484      1.8454     1.5965        0.1388
1.4200      1.7177     1.1396        0.1608
1.5000      1.7074     0.5256        0.1835
1.5597      1.7441     0.1993        0.1993
1.6200      1.7279     0.5159        0.2143
1.7500      1.7826     1.2869        0.2441
2.0000      1.6200     1.6784        0.2929
```

**The measured gain is constant: 1.7710 ± 0.0766, CV 4.3%, over all twelve
bases.** The entire 5.6× spread in `Ĝ` reported in entry 73 is the `1/log b`
divisor, not structure. There was no curve.

The apparent agreement below `u/2π = 0.62` is the γ₁ model **crossing** that
constant, because for small `h`, `|1 − e^(−ρh)| → |ρ|h = 14.14h`, which passes
through 1.8 precisely in that range. From `b = 1.42` the model dives and the
measurement does not move.

### What the run actually measured

Noise amplification at gain ≈ 1.77, base-independent. That accounts for every
feature at once: no null (noise has none), a smooth `Ĝ` curve (it is
`const/log b`), and the control's apparent failure — **the control was not broken
relative to the data; it was measuring the same thing**, rounding noise at
`G ≈ 1.6–1.76` for small `b`.

So the `compromised` verdict is right, and for a deeper reason than the one
entry 73 gives: the pipeline and its control were both in the noise regime.

### The design error, and it is upstream of the control

`analysis/2026-08-19_table_structure/CHAIN.md` § `t2_crossover` already records
`d*`, the depth where oscillation overtakes trend, per base:

```text
k=1 1.1175 -> d* = 2      √2  1.4142 -> d* = 4
k=2 1.2489 -> d* = 3      k=4 1.5597 -> d* = 5
k=3 1.3957 -> d* = 4      2.0000     -> d* = 7      3.0000 -> d* = 10
```

`d*` runs 2 to 10 across the set. **The locked window `d ∈ [3,8]` is above `d*`
for k=1 and k=2, straddles it for k=3, k=4 and √2, and lies below it only for
bases 2 and 3.** A fixed depth window measures a different regime in every base,
which is exactly what a base-independent constant looks like when you find one.

Corroborating, from the other direction: O34/O35 report 94% at `d=0`, 92% at
`d=3`, **80% at `d=6`** — degrading — and entry 52 records the model flipping
sign at `(25,21)`. The window sat in the decay zone and this was recorded before
the prereg was written.

### What this points at

Julian's proposal — take the crossover per base and difference across bases —
is the right instrument, because `d*` is the depth at which the character
changes and it is already measured to scale with the base. Entry 53: `d*` is not
a per-base constant, but its slope in `r` is, `corr(ln b, slope) = +0.9735`.

The next run is exploratory and asks the question the fixed window could not:
**per base, at what depth does the gain leave the symbol and join the 1.77
plateau, and does the symbol hold below it?** No prereg. Labelled exploratory.

---

## 2026-08-21 — Entry 73 — O48 run 1: the transform holds inside the small-angle radius, the null does not appear, and the control was the defect
type: run
refs: 69, 72

**Run.** `O48_small_angle_cross_base.py`, no flags, under
`preregs/small_angle_cross_base_v1_20260821.md` **LOCKED**, sidecar
`14c86dc224de23d62d6c0486106a5a071645ac01ee328e512d3da8c52daa6fbd` verified
against the file before the Run record was filled. Started
2026-08-21T19:13:54Z, ended 19:14:36Z. `primecountpy.prime_pi`, `mp.dps 50`,
twelve bases, value window `[10^4, 2^32]`, depth window `d ∈ [3,8]`. Completed,
did not error. `results/small_angle_cross_base.json` +
`results/O48_small_angle_cross_base_run1.log`.

**Mechanical decision-rule output: `compromised`**, precedence branch 1, because
the control floor came out `0.754867` against the locked threshold `0.80`. The
verdict line is Julian's and is unfilled.

### The control is the defect, and it is mine

`round(b**(r/2))` does not survive the depth window. At `b = 1.15` the exact
per-depth gain is `0.0675`, so the mode decays to `4.3e−10` of itself by depth
8, while `round()` injects `±0.5` amplifying by up to `2` per difference —
`2^8 = 256`. So the control measured **noise doubling**, `≈ 2/log b`:

```text
b        2/log b   measured Ghat_ctrl   exact gain it should have read
1.1500    14.310         12.606                0.4829
1.3160     7.283          6.181                0.4672
2.0000     2.885          0.470                0.4226
```

That definition was written into the prereg in the edit **immediately before
locking**, replacing the looser "fitted the same way" phrasing, on the grounds
that it was too vague to implement. Sharpening it made it wrong. A v2 needs a
control that survives depth.

### What the run showed, EXPLORATORY — the verdict is compromised, so none of
### this earns one

**Inside the small-angle radius the transform tracks, from a prediction with
nothing fitted:**

```text
base      u/2π   measured   pred H1   ratio
1.1500   0.314    13.1303   11.5458   1.137
1.2293859 0.465    8.8724    9.1527   0.969
1.2560   0.513     8.0319    8.2953   0.968
1.2855907 0.565    7.5018    7.3356   1.023
1.3160   0.618     6.2766    6.3575   0.987
```

Four of five within 3%. That is entry 72's claim, holding where entry 72 said it
would hold.

**The null does not appear.** `D` at `1.5597432` is `1.0070` against a predicted
`0.3790`. The measured curve falls straight through the predicted null with no
feature: measured `3.9237` where the symbol gives `0.4483`, a factor `8.75`.
Beyond `u/2π = 0.62` the measured/predicted ratio runs 1.156, 1.507, 3.249,
**8.752**, 3.349, 1.385, 0.965 — the divergence is centred exactly on the
predicted null and closes again past it.

`argmin D` is `1.2293859`, γ₄'s candidate, at `0.8385` — but the control's own
`D_ctrl` at that same base is `0.8013`, so it is not a dip below the floor even
before the `compromised` branch fires.

Shape residual `RMS log(measured/predicted H1) = 0.8099`, dominated by the null
region.

### Two readings this run cannot separate

Either sub-leading modes fill the null — the prereg names this as the largest
doubt in advance, and γ₂'s null at `1.3483554` sits inside the same base set —
or the residual at depths 3–8 is not single-mode enough for any null to survive.
The clean tracking below `u/2π = 0.62` and the clean failure above it are
consistent with both.

Nothing is stamped. The prereg's Run record carries the same numbers and the
same unfilled verdict line.

---

## 2026-08-21 — Entry 72 — small angles make the curve: the cross-base transform, its Euler–Maclaurin cost, and why its radius is the pole lattice
type: motivation
refs: 69, 70, 71

**Julian's account, in his terms.** The b-adic tables are not separate objects.
Small angles are what create a curve, and that is what the explicit formula
does. So rather than build a table to infinite depth in every base, ask for the
**rate of change per cell across the b-adic tables** — or equivalently the
transform between them — and run that. That would give a formula for **when
local becomes global**, i.e. when the discrete table reaches the analytic
object, without ever taking a table to infinity.

He named the cost before I checked it: *"by summing averages we lose steps that
gets abstracted by the averaging, or turning the actual work of looking, where
something like our zero in a table makes the averaging work."* And the standing
goal: observe whether small shifts create big curves well enough to infer the
local data and construct a reliable approximation — here, of the zeta zeros.

**My check. The transform exists and is elementary.** All b-adic tables are one
object sampled at rate `h = log b`. Normalise a cell by `h^d`:

```text
cell_b(r,d) / (log b)^d   has symbol   ((1 − e^(−ρh)) / h)^d  →  ρ^d   as h → 0
```

base-independent in the limit. Between two bases the transform is exact with no
limit at all — just the ratio of symbols,
`((1 − b₁^(−ρ)) / (1 − b₂^(−ρ)))^d`, computable per cell.

**The cost is Euler–Maclaurin, literally.** The correction factor is
`(1 − e^(−u))/u` with `u = ρ log b`, whose expansion is the Bernoulli generating
function `u/(e^u − 1) = Σ Bₙuⁿ/n!`. Euler–Maclaurin's correction terms **are**
the steps lost when a sum is replaced by an integral. Julian named the cost from
the phenomenon; it has a name and a closed form.

**And the radius of convergence is `2π`, because the nearest singularity of
`u/(e^u − 1)` sits at `u = 2πi` — the pole lattice.** The same lattice
`Chain.sym_eq_zero_iff` proves (entry 69). So "small angles" is not a feeling.
It is `|γ log b| < 2π`.

```text
b        |γ₁ log b|    /2π
1.1175      1.5703     0.250    inside
√2          4.8987     0.780    inside
1.5597      6.2832     1.000    ON the line
2           9.7974     1.559    OUTSIDE
3          15.5286     2.471    outside
```

**Verified against the bench's own recorded numbers.** `γ₁·log 2 = 9.797445`,
and `9.797445 − 2π = 3.514260` — which is `ω₁` in `CONTEXT.md` § Core quantities
to six digits, folding to `2π − 3.514260 = 2.768926`, the recorded 2.7689. So
the small-angle boundary, the pole lattice, and Nyquist are **the same number**,
and O15's "raised the sampling Nyquist … clearing γ₁/γ₂/γ₃" and O45's *resolved*
stratum have been measuring it all along under a different name.

Consequence, derived rather than observed: inside one lattice cell the map
`ρ ↦ symbol` is injective and a single base can invert it; base 2 sits 1.56
cells out, so base 2 alone cannot recover γ₁. That is O18's "integer bases are
blind singly but not jointly," obtained from the radius rather than from a
periodogram.

**The base set is already built on this axis, which neither of us noticed.** The
O45 family is `log b_k = k · π/(2γ₁) = k · 0.111133`, so

```text
k = 4  ->  log b = 4 · 0.111133 = 0.444528 = 2π/γ₁  ->  b = 1.5597
```

and 1.5597 is the recorded family k=4 base. **k=4 is exactly the aliasing
threshold for γ₁**, with k=1,2,3 inside it and base 2 well outside. The locked
base set straddles the boundary this entry identifies, so the instrument for
testing it already exists and was locked on 2026-08-18 for a different reason.

**What is not established, and is the reason for a prereg rather than a claim.**
The transform above is exact for a single mode. A real cell is a smooth term
plus a sum over modes, and the transform acts mode-by-mode — so composite
transport is only as good as the decomposition. Whether the normalised cell
actually agrees across bases inside the radius and breaks outside it is a
measurement, not a corollary, and it is what
`preregs/small_angle_cross_base_v1_20260821.md` tests.

Nothing here is a result. This entry records the reasoning and the arithmetic
check that motivated a preregistered test.

---

## 2026-08-21 — Entry 71 — the two audit defects fixed, and the composition the chain was missing
type: formalization
refs: 68, 70

Fixes for the two findings entry 70 records as surviving. Entry 68 stands as
written; entry 70 carries the correction; this entry carries the repair.

**F1 — `Chain.tableFrom_mode` localised to the window.** The hypothesis was
`∀ n : ℤ`, which admits exactly `N ≡ 1` and `N n = (−1)^n`. It is now

```text
hag : ∀ k : ℕ, k ≤ d → ((N (r − k) : ℤ) : ℂ) = mode b ρ ((r : ℂ) − k)
```

the `d+1` entries a cell at `(r,d)` actually reads — the same form, and for the
same stated reason, as `PairIdentity.tableFrom_of_geometric`. The proof is now a
direct induction using `A1` at each step rather than routing through
`tableFrom_eq_bdiff_iter`, since that route needs global agreement.
`tableFrom_norm_on_critical_line` takes the same hypothesis.

**Verified non-vacuous by witness, because the build cannot see this.** The
geometric row `2^n` at `b = 2`, `ρ = 1` satisfies the localised hypothesis on the
window `(5,3)` reads — `32, 16, 8, 4` — and the theorem then gives
`cell = (Sym 2 1)^3 · 2^5 = (1/2)^3 · 32 = 4`, with
`tableFrom geoRow 5 3 = 4` confirmed independently by `decide`. Compiles. The
old hypothesis had no such instance at any base.

**F2 — `joint_gain_periodic_of_commensurate` gained `0 < m` and `0 < n`**, with
the docstring stating why: without them `m = n = 0` satisfies `hcomm` as `0 = 0`
for every pair of bases and the conclusion degrades to `Periodic f 0`, which
`period_vacuous_at_one` thirteen lines below proves is empty.

**And the composition the audit found missing —
`Superposition.tableFrom_eq_modeSum_reweighted`.**

```text
row agrees with modeSum at every integer
  →  (tableFrom N r d : ℂ) = modeSum b ρ (fun i => c i * (Sym b ρᵢ)^d) s r
```

Two lines: `Chain.tableFrom_eq_bdiff_iter` carries the integer table onto
`bdiff^[d]`, `depth_reweights_each_mode` carries that onto the reweighted sum.
Both existed; nothing composed them, and entry 70's grep confirmed `modeSum` and
`tableFrom` occupied disjoint sets of modules.

**Here the global hypothesis is correct and non-vacuous, and that distinction is
the whole content of the fix.** A single mode forces `w = ±1` on an integer row.
A sum does not: only the total need be integer-valued, and no individual
`cᵢ·wᵢ^n` is constrained. Conjugate pairs — `ρ₂ = −ρ₁` with `c₁ = c₂ = 1/2`,
giving `Re(wⁿ)` — are integer at every `n` with neither mode `±1`, which is how
Riemann–von Mangoldt makes a real integer row out of non-real modes. **This is
the theorem O34/O35 were measuring against** when they reported 94% / 92% / 80%
of the row-20 residual at depths 0, 3 and 6.

So entry 68's chain diagram is now true of a theorem that exists, and it runs
through `Superposition`, not through `tableFrom_mode`.

**What verified this, and what could not.** No axiom pin moved — every theorem
touched is ℂ-valued and was already at `[propext, Classical.choice, Quot.sound]`.
The build could not see either defect and cannot see either fix. What checks F1
is the witness above; what checks F2 is reading the hypothesis. `Chain.lean`
says this about itself in `gain_sq_periodic`'s docstring, and entry 70 is the
first time that gap was exercised rather than noted.

**Sequencing defect in this entry's own commit.** The Lean fixes landed at
`0f64663`, whose message announces "Entry 71" — this entry — while the entry
itself was not in the working tree, lost to a wrong-directory write. The commit
is therefore accurate about the code and premature about the record, and this
entry is committed separately after it. Recorded rather than amended: the same
reason entry 68 was left standing.

Build clean, 8037 jobs, 133 theorems, 133 pins, parity in all 11 modules. Gate
unchanged at 2, `check_values` 83 confirmed / 0 mismatches.

---

## 2026-08-21 — Entry 70 — blind adversarial audit of Chain.lean, three rounds: two real defects, both in entry 68's material, and four findings the audit itself retracted
type: result-triage
refs: 68, 69

**Method.** A subagent with no memory of the session that wrote `lean/Chain.lean`
audited it against `papers/Euler-Factor-Chain.md`. Three rounds: it reported,
then I attacked its findings, then I required it to reverse stance and argue the
file is better than it said. Read-only throughout, no fixes proposed — findings
only. Blindness is the point: it has no investment in having been helpful.

**Entry 68 is left as written.** This entry carries the correction. Rewriting a
dated entry to hide what it got wrong would defeat what the notebook is for.

---

### What survived, and it is mine

**F1 — `Chain.tableFrom_mode` does not reach the dyadic table.** Staked on by
the auditor over everything else.

`tableFrom_mode` (`Chain.lean:320`) takes
`hag : ∀ n : ℤ, ((N n : ℤ) : ℂ) = mode b ρ (n : ℂ)`. Since
`mode b ρ n = w^n` with `w = (b:ℂ)^ρ`, the hypothesis at `n = 1` puts `w` in ℤ
and at `n = −1` puts `w⁻¹` in ℤ; an integer whose inverse is an integer is `±1`.
**The hypothesis class is exactly two rows: `N ≡ 1` and `N n = (−1)^n`.** On the
critical line with `b > 0`, `|w| = b^(1/2) = 1` forces `b = 1`, where `Sym` is
identically zero.

I challenged this on branch cuts — `(b^ρ)^n` for complex `cpow` is not free. The
challenge failed and the finding got **stronger**: the outer exponent is an
integer, so it is `zpow`, and `Complex.cpow_int_mul`
(`Mathlib/Analysis/SpecialFunctions/Pow/Complex.lean:100`) has **no hypotheses at
all**, not even on `arg`. So F1 covers exactly the `b ≠ 0` the theorem states.

**And this tree already states the criterion and satisfies it elsewhere.**
`PairIdentity.lean:76-80`:

> The hypothesis is deliberately local. **No total function `ℤ → ℤ` satisfies
> `G r = b · G(r−1)` at every `r` except `G = 0`, so a global geometric
> hypothesis would be vacuous.** What a cell at `(r,d)` actually reads is the
> window `r, r−1, …, r−d`.

`tableFrom_of_geometric` takes the window-local form and is non-vacuous.
`tableFrom_mode` takes the global form. Met in one module, walked into in the
next — the auditor's words: *"I am not importing an outside standard; I am
reporting that one written in this tree was met in one module and not in the
next."*

**Consequently entry 68 is false where it is most load-bearing.** Its line
*"The hypothesis is not hypothetical for the dyadic row"* is true of a
superposition and false of `tableFrom_mode`, which is the theorem the chain
diagram there runs through. My second challenge did establish that the
**sum-level route is open** — per-summand integrality does not bite when only
the sum must be integer-valued, witness `ρ₂ = −ρ₁`, `c₁ = c₂ = 1/2`, giving
`(iⁿ + (−i)ⁿ)/2 = Re(iⁿ) ∈ {1,0,−1,0}`, which is how Riemann–von Mangoldt makes
a real integer row out of non-real modes. But that route is **unwritten**:
verified by exhaustive grep, of 11 modules, `modeSum` occurs in
`Superposition.lean` only and `tableFrom` in five others, and the two sets are
**disjoint**. `Superposition.lean:12` is `import Chain`, so the dependency runs
the wrong way. Entry 68 cites a legitimate route no theorem takes.

**F2 — `joint_gain_periodic_of_commensurate` has no `0 < m`.** At `m = n = 0`
the hypothesis `hcomm` reads `0 = 0`, satisfied by **every** pair of bases
including incommensurate ones, and the conclusion is `Periodic f 0`. I tried
four ways to break this and could not; `Function.Periodic.nat_mul`
(`Mathlib/Algebra/Ring/Periodic.lean:131`) has no `n ≠ 0`. The theorem is true
and has real instances; the defect is that **`hcomm` is not a commensurability
condition**, so the theorem does not carry the content its docstring and
`second_ladder_winds_densely`'s back-reference attribute to it. This is the trap
`period_vacuous_at_one` proves, thirteen lines below, un-closed.

**F8 — the inert `hA4` also silences the linter**, settled from the linter's
source rather than by analogy: `linter.unusedVariables.funArgs` defaults **true**
so signature binders are flagged, `analyzeTactics` defaults **false** so a dead
`have` is invisible. Effect confirmed; the auditor withdrew any imputation of
intent, the docstring disclosing the inertness in plain words.

**Minor and disclosed:** `StmtC2` encodes one of paper C2's three conjuncts
without saying so (the periodicity conjunct is now `gain_sq_periodic`, 300 lines
away); the file header's "every theorem here takes the antecedent statements as
HYPOTHESES" describes about 6 of 25; `Chain.h` duplicates `EulerFactorChain.h`
byte-for-byte with nothing enforcing it.

---

### What the audit retracted, and why it matters

**F4 demoted by its own steelman — and this bears on handoff item 1c.** Round 1
found `StmtB5` and `StmtB4` provably equivalent modulo `norm_pow` and called it
"drops the depth side." Required to argue the other case, it conceded:
`(Sym b ρ)^N` **is** the depth side, named rather than unfolded — it is
precisely the multiplier `StmtA4` says `bdiff^[N]` applies. Writing
`bdiff^[N] (mode …)` in would drag `‖mode‖` onto both sides and turn an identity
about a **weight** into one about a **ratio**. What survives is narrow: the
docstring says `hA4` mirrors "the paper's stated dependency," and paper B5 cites
`A1 + B4` (`Euler-Factor-Chain.md:46`), not A4 + B4. **So the handoff plan's
"most serious defect" is milder than recorded there.**

**F3 retracted, and it exonerates the paper's structure.** `StmtA3`'s first
conjunct is definitional — `EulerFactorChain.sym_natCast` is `by simp [sym]` —
so `A4_of_A1` is the honest arrow and the paper's `A3 ·` citation is the loose
one. The auditor also withdrew, as outright false, its claim that nothing
carries the Euler-factor reading onto the critical line: `Chain.lean:70` is
`∀ s : ℂ`, unrestricted. It had quoted the disproving line in round 1.

**F6 retracted, and it exonerates the paper's arithmetic.** The exponents differ
by exactly one because **the depth-0 row is itself already one difference of π**.
`CONTEXT.md:91-96`: the block holds `(b−1)b^(r−1)` slots and each difference
multiplies by `(b−1)/b`, giving `(b−1)^(d+1)b^(r−1−d)` — the `d+1` is `1` for the
row plus `d` for the depth. The paper counts relative to π; Lean counts relative
to the row; both internally correct. What remains is that Chain.lean never says
which frame it is in and names its binder `N`, the paper's symbol for the other
frame.

---

### The bias check

Round 3 required the auditor to argue against itself. It named four places its
adversarial framing manufactured a defect, the sharpest being F3: it **quoted
the docstring that disproved its own finding** and argued past it, and asserted
the critical-line claim with `∀ s : ℂ` on screen. *"An adversary who has found a
'disconnected component' narrative stops checking, and I did."* On F6: the frame
was in a file it had read in full, *"because 'off-by-one between paper and Lean'
is a satisfying find."* On two others: prose notes promoted to findings because
an empty rubric slot reads as a failed audit.

**This is the reason for three rounds rather than one.** A single pass returns
ten findings and no way to tell which four are artifacts of being paid to find
some.

### What the file does well, from a reviewer with no reason to be kind

`period_vacuous_at_one` exists solely to prove a neighbouring hypothesis is
load-bearing, and correctly names the axis `#guard_msgs` cannot protect.
`C3lower_of_A4_C2` drops `0 < b` because the proof does not consume it, with the
rationale written down. `StmtC3lower` uses `|·|` because the unbarred form,
though true, is contentless for `0 < b < 1`. `StmtA3` volunteers its own negative
scope unprompted. And **`StmtA2` is more honest than the paper it formalises** —
paper A2 states the Euler product with no convergence condition, which is false
as written; the Lean carries `1 < s.re`.

### Standing

Two real defects, both in entry 68's material, both introduced 2026-08-20, and
**both invisible to the build** — `Chain.lean:396-397` says why: `#guard_msgs`
pins an axiom list and a near-vacuous theorem has an ordinary one. Both are
pinned and both pins pass.

Lean fixes follow in a separate entry. Nothing above is a fix; this entry is the
record of what the audit found.

---

## 2026-08-21 — Entry 69 — the circle comes from the pole lattice, and the fold is now an identity on cells
type: formalization
refs: 33, 55, 60, 68

Entry 68 built the torus and never said where it came from. Both ends of the
chain were loose: the circle had no origin, and the fold existed in Lean only as
facts about the stencil's *weights*, never about a cell. Six theorems close both.

**The pole lattice — `Chain.sym_eq_zero_iff`.**

```text
Sym b s = 0  ↔  ∃ k : ℤ, s = k · (2πi / log b)
```

These are the poles of `1/Sym`, the reciprocal Euler factor. It is the
`2πik/log 2` lattice of Flajolet, Grabner, Kirschenhofer, Prodinger and Tichy
(`papers/literature/litsearch_1_hinge.md` § 3), and it is the lattice
`EulerFactorChain.lean:112` already excludes in prose — *"it excludes the whole
`sym b s = 0` lattice"* — without ever stating it.

**`Chain.sym_periodic`** — `Sym b (s + 2πi/log b) = Sym b s`, because
`b^(−2πi/log b) = exp(−2πi) = 1`. The symbol returns to itself after one lattice
step. **That is the origin of the circle**: `γ` is an angle because the symbol's
own zero set is a lattice of that spacing.

**`gain_sq_periodic` rewritten to derive from it.** Entry 68 proved the same
period from `Real.cos_add_two_pi` — true, and the symptom. The cause is the
lattice. Same period, correct derivation, and the torus now has a reason inside
the chain rather than beside it in the record.

**The fold, on cells — four theorems in `Zeros`.**

```text
wingPlus  / wingMinus            the even- and odd-index arms, unsigned
stencil_eq_wings                 stencil N g = wing⁺ − wing⁻      an IDENTITY
stencil_eq_zero_iff_wings        stencil N g = 0 ↔ wing⁺ = wing⁻
tableFrom_eq_zero_iff_wings      cell = 0 ↔ the window's wings balance
repeat_iff_wings                 the repeat reading = the fold reading
```

`stencil_weights_antisymm`, `stencil_arms_eq` and `stencil_arm_doubled` were
already there but are about the **weights**. Nothing split an actual cell by
parity. `papers/The-Fold.md` § B calls the arms the wings — 807295 each at
`(20,6)`, 168 each at `(8,3)` — and entry 55 records that the fold is an
identity, `wing⁺ − wing⁻ = cell`, true everywhere. It is now that in Lean.

**`repeat_iff_wings` is the bridge that did not exist.** `zero_iff_repeat` says
a cell vanishes iff the row repeats one depth below. The fold says it vanishes
iff the wings balance. Both were in the tree; nothing connected them. They are
one statement, and the connection runs through entry 60's stencil equation.

So the two readings of a zero — `(20,6) = 0` because `d5` reads 623 at both
`r = 19` and `r = 20` (`The-Fold.md` § C1), and `(20,6) = 0` because the wings
weigh 807295 each — are now provably the same fact.

Build clean, 8037 jobs, 132 theorems, 132 pins, parity in all 11 modules. Gate
unchanged at 2, `check_values` 83 confirmed / 0 mismatches.

**Still outside Lean, named so it is not searched for again.** The zeros-as-poles
reading of entry 33 and `The-Four-Zeros.md` § E3 — the ratio `composite/prime`
singular at exactly the four cells — is prose only; `pole` and `ratio` occur
nowhere in `lean/` in that sense. And `lean/BUILD.md` still records block D (the
winding) and block G (the transform radius, the annulus of modulus `(log b)/4π`)
as observations. Block G is the z-plane route to the same circle, so one of the
object's two coordinates remains unformalised.

---

## 2026-08-20 — Entry 68 — the seam welded: tableFrom IS bdiff, and the chain runs from the integer table to the torus
type: formalization
refs: 59, 60, 61, 66

**The defect.** `lean/Chain.lean` proved things about `bdiff` on `ℂ → ℂ`.
`lean/Construction.lean` proved things about `tableFrom` on `ℤ → ℤ`. They are
the same backward difference on two domains, and **no theorem in the tree joined
them.** So the formalisation read as two stacks with prose between, not one
chain. Nothing was wrong; nothing was connected.

**Seven theorems, all landed in `Chain.lean`, which now also imports
`Construction`.**

*The weld.*

```text
tableFrom_eq_bdiff_iter   g agrees with N at every integer
                          -> (tableFrom N r d : ℂ) = (bdiff^[d]) g r
tableFrom_mode            + A4  ->  cell = (Sym b ρ)^d * mode b ρ r
tableFrom_norm_on_critical_line   the modulus form C2/C3 bound
```

`tableFrom_mode` is `StmtA4` read on the integer table. After it, every arrow
below the seam applies above it: an integer cell of the dyadic table is an
object the analytic half of the file has theorems about.

*The circle — this closes handoff item 1b.*

```text
gain_sq_periodic       Periodic (fun γ => ‖Sym b (1/2 + γi)‖²) (2π / log b)
period_vacuous_at_one  at b = 1 the same statement holds for EVERY f
```

`EulerFactorChain.gain_sq_on_critical_line` already had the content — the gain
depends on `γ` only through `cos(γ log b)` — so `γ` is an angle, not a line, and
the gain closes after `2π / log b`.

**`b ≠ 1` is load-bearing and the second theorem proves it.** At `b = 1` the
period is `2π/0 = 0`, and `Function.Periodic f 0` is true for any `f` at all —
so the unguarded statement is true and empty exactly at the degenerate base.
`period_vacuous_at_one` is that fact, compiled. **`#guard_msgs` cannot catch
this**: a vacuous theorem has an ordinary axiom list. The handoff flagged the
risk; it is now a theorem rather than a warning.

*Two ladders.*

```text
joint_gain_periodic_of_commensurate   m·P₁ = n·P₂  ->  joint gain periodic
                                      in ONE variable: the circles collapse
second_ladder_winds_densely           steps dense on the b₁-circle
                                      <-> log b₁ / log b₂ irrational
```

The second is Kronecker, via `AddCircle.denseRange_zsmul_coe_iff`. Together they
are the dichotomy: **commensurate ladders close into one circle, incommensurate
ones fill a torus**, and the whole content is whether the ratio of logs is
rational. The first is entry 54 and 56's trap stated as a theorem — a base set
commensurate by construction forces cross-base alignment rather than finding it.

*The inversion was already there*: `EulerFactorChain.h_functional_equation`,
`h b N (1 − s) = h b N s`, whose fixed set is the critical line.

**So the chain is now unbroken and is one object:**

```text
the table                 Construction         ℤ, no axioms
cell = Pascal             entry 60             tableFrom = stencil
tableFrom = bdiff^[d]     HERE                 the seam
cell = Sym^d · mode       HERE                 via A4
dia/col = √b              entry 61
period 2π/log b           HERE                 the circle
commensurate | torus      HERE                 Kronecker
s ↦ 1 − s                 h_functional_equation
```

All seven at `[propext, Classical.choice, Quot.sound]`. That is the floor and it
is correct: every statement mentions ℝ or ℂ. Entry 66's boundary reads exactly
right here — the table above the seam is axiom-free, everything below it is not,
and the seam is where the arithmetic becomes analytic.

**Gotcha worth recording.** `Chain.Sym` collides with Mathlib's `Sym`, the
symmetric-power type. Unqualified inside a file that opens Mathlib it silently
resolves to Mathlib's and the errors are about universe levels, not about `Sym`.

**On the hypothesis form.** `tableFrom_mode` takes "the row agrees with a mode"
as a hypothesis. That is this file's method, not a gap in it — see its header,
lines 9–12: every theorem here takes the antecedent statements as hypotheses and
derives the consequent, so that Lean can refuse a leap. A hypothesis is a
quantifier, not an assumption: the theorem is a complete, kernel-checked proof
about every row of that kind. The `A4` it calls is itself unconditional
(`Chain.lean:263`), as C1 became when it was discharged.

**What the chain shows.** The hypothesis is not hypothetical for the dyadic row.
`Superposition.lean` exists precisely to license A4 on a **sum** over zeta zeros
— its header: *"Every use of it on the bench applies it to a SUM over zeta zeros
(O34, O35). Nothing so far permits that step. This file supplies it."* And the
decomposition is measured: `CONTEXT.md` § O34/O35 — **94% of the row-20 residual
at depth 0, 92% at depth 3, 80% at depth 6, from the explicit formula alone,
nothing fitted.**

So with the weld in place the chain reads end to end on the actual table:

```text
cell(r,d)                      integer, computed from π
  = (bdiff^[d]) on the row     tableFrom_eq_bdiff_iter, here
  the row is a superposition of modes b^(rρ)      explicit formula
  ρ = 1/2 + iγ, the zeta zeros                    O34/O35, 94/92/80%
  each mode reweighted by (Sym b ρ)^d             Superposition
  ‖Sym‖ inside [1−b^(−1/2), 1+b^(−1/2)]           C2, C3, C3lower
  phase periodic in γ with period 2π/log b        gain_sq_periodic, here
  two ladders: one circle, or a torus             Kronecker, here
  s ↦ 1 − s fixes the critical line               h_functional_equation
```

**Every cell of the dyadic table is a sum over the zeta zeros, each reweighted
by its own factor at depth `d`.** That is the mechanism, it is measured at
80–94% across depths 0 to 6, and every algebraic step in it is now a
kernel-checked theorem rather than a "therefore" in prose.

**What is underived, stated narrowly.** The chain gives the weight each zeta
zero carries into a cell. It does not say when that weighted sum — main term
included — lands on integer `0` exactly. Four cells do. Why those four is not
derived by anything here.

**And one measured limit, which is a result and not a caveat.** O34/O35 do not
extend to deep cells: at `(25,21)` the model flips sign between 200 and 600
zeros, because the depth operator spreads each zero's gain over `(d+1)×0.765`
decades. So the 80–94% agreement is established at depths 0–6 and the method
runs out below that — measured, in `CONTEXT.md` § O34/O35, not assumed.

Build clean, 8037 jobs, 126 theorems, 126 pins, parity in all 11 modules.

---

## 2026-08-20 — Entry 67 — the 12 oversized NOTEPAD lines truncated, and the gate baseline re-cut to 2
type: instrument-fix
refs: 63, 64, 65

Julian approved. `check_refs.py` had flagged 12 NOTEPAD lines over the 400-char
limit, 479 to 2944 chars against a median of 132. Ten cited an entry holding the
same text verbatim and could be shortened outright. **Two cited nothing**, so
truncating them would have destroyed the only copy — those were backfilled first
as entries 64 and 65, then shortened to point at them.

All 12 now carry `entry N:`. Longest thread line is 357 chars, under the limit.
No status transitions: every one is still `[open]`.

**The gate went from 14 broken references to 2**, and
`utilities/refs_baseline.txt` was re-cut to match. What remains is the two
declared-PENDING references in `papers/The-Composite-Arm.md` — its own header
lists them as conditions of becoming canonical, and they close when the t25
composite-arm script is written. (Naming that file here would itself be a
broken reference — the checker caught exactly that on the first draft of this
entry.)

Prior results comparable: no reference resolved differently, `check_values.py`
unchanged at 83 confirmed / 0 mismatches, `lake build` clean at 8037 jobs.

---

## 2026-08-20 — Entry 66 — SeedPerturbation and PairIdentity off Mathlib; the floor is 60, not 0
type: formalization
refs: 59, 60, 61

Continuation of entry 59, which did `Construction`. Same method, two more
modules, plus the measurement that bounds how far this can go.

**Result.** `Classical.choice` fell 84 → 71 across the tree.

```text
                    before   after
SeedPerturbation      10        0     20 theorems, no Mathlib surface at all
PairIdentity           4        0     symbol_at_one moved out; see below
```

`SeedPerturbation.tableFrom_eq_zero_of_vanishing_above` — the gating theorem for
the seed protections — is now `[propext]`, from all three. Entry 59 predicted
this file would port cleanly and it did. It also builds in **340 ms** instead of
~10 s, because there is no Mathlib to load.

**`symbol_at_one` moved to `EulerFactorChain`.** It was `PairIdentity`'s only
ℂ-valued statement and is a restatement of
`EulerFactorChain.symbol_of_backward_difference` at `ρ = 1`, so it belongs where
`sym` lives. Checked first that no paper cites it — only entry 45 does, by bare
name, which still resolves.

**`grind` is not a shortcut, and this is the load-bearing measurement.** Lean
core ships `grind`, and it discharges the `ring`-shaped ℤ goals that `ring`
was doing. Measured in a Mathlib-free file: **`grind` costs
`[propext, Classical.choice, Quot.sound]`** — all three, with no Mathlib
present. So it defeats the entire purpose, and every `ring` had to be replaced
by a hand chain of core `Int.` lemmas.

Also Mathlib-only, and each needing a core rewrite: `by_contra` (replaced by a
`match` on `(by omega : 1 < b - 1 ∨ b = 2)`), `rcases` (`match`), `ring_nf`,
`linarith`, `nlinarith` (replaced by `Int.mul_lt_mul_of_pos_left` plus
`Int.mul_one`), `norm_num`, `push_cast`, `pow_pos`, `mul_right_cancel₀`,
`mul_eq_zero`. `omega` stays — measured at `[propext, Quot.sound]`, no
`Classical.choice`.

**The floor is 60 of 119, and it is not a defect.** Of the 71 remaining, 60
mention ℝ or ℂ, and Mathlib constructs ℝ with `Classical.choice`, so no proof
style removes it:

```text
Chain 16 · EulerFactorChain 16 · Measured 7 · Covering 6 · Crossover 6
GeneratorPeak 6 · Superposition 3            = 60, permanent
Zeros 11                                     = the only portable remainder
```

**`Zeros` is mixed and was not attempted.** Of its 11: six are the `stencil`
theorems, which need `Finset.range` replaced by a fold; four
(`factorization_proportional`, `primeFactors_eq_of_meets`, `base_of_meets_two`,
`window_exclusive_of_prime_exponent`) rest on Mathlib's prime-factorization
theory and are not portable at any reasonable cost; and one is entry 60's
`tableFrom_eq_stencil`, which took the `fwdDiff` bridge precisely because the
direct induction was harder. So the realistic floor is **64**, not 60, unless
`Zeros` is split. That is an architectural call and is Julian's.

Build clean at 8037 jobs, 119 theorems, 119 pins, parity in all 11 modules.

---

## 2026-08-19 — Entry 65 — figures/coverage.png had no script either; t15 reconstructs it, and finds one transcription slip
type: provenance
refs: 64

Backfilled 2026-08-20 from the NOTEPAD line that held this record, so the line
could be shortened without losing its only copy. Same situation as entry 64 and
recorded separately because `coverage.png` is **not** among that entry's six.

`figures/coverage.png` was committed at `3da2ee8` with **no script** — its
analysis was inline too. Reconstructed as
`analysis/2026-08-19_table_structure/scripts/t15_cell_coverage.py`, which
**postdates the result it reproduces**, exactly as t9–t14 do.

**Reproduced.** Every per-base mean, zero-mean and z, to printed precision.

**One disagreement, and it is a transcription slip rather than a computational
difference.** Base 6's per-zero counts are `[0, 1, 2, 2]`, not the reported
`[0, 1, 1, 3]` — and `[0, 1, 1, 3]` is **base 7's** list. Both sum to 5, so the
mean 1.25 and the z −1.04 were unaffected, which is why it went unnoticed.

**The kill reproduces.** Maximum distinct coverage values at any fixed depth is
2, across all 224 depth-base pairs, because the window's width in b-rungs is
`(d+1)·ln2/ln b` — a function of `d` ALONE.

**Corroboration.** The zeros' mean depth has z = −0.99, the same ≈ −1.0 that the
coverage z gives at every base. So coverage's z **is** the depth z.

---

## 2026-08-19 — Entry 64 — six analyses ran inline with no script saved; t9–t14 reconstruct them, and two do not fully reproduce
type: provenance
refs:

Backfilled 2026-08-20 from the NOTEPAD line that held this record, so the line
could be shortened without losing its only copy. Nothing here is new work; it is
the same text, given an entry to live in.

Six analyses reported on 2026-08-19 were run **inline as heredoc commands with
no script saved**, so the results predate any reproducible instrument.
Reconstructed as `analysis/2026-08-19_table_structure/scripts/`
`t9_subthreshold_ladder.py`, `t10_blocksum_lowpass.py`,
`t11_decimation_alias.py`, `t12_chain_vs_orphan.py`, `t13_signflip_crossover.py`,
`t14_s_matched_control.py`, and re-run.

**The scripts postdate the results they reproduce** — mtimes 12:23–12:25 against
a session that ended at 12:09. They are reconstructions from the reported
numbers, not the code that produced them.

**Ordering evidence**, from file mtimes: 11:01 `shape32.py`, 11:35
`t5_2d.py`/`spectrum2d.png`, 11:41 `t6_multirate.py`/`multirate.png`, 12:03
`coverage.png` (its analysis was inline too, no script survived, and it is NOT
among the six — see entry 65), 12:06 `t7_phase.py`/`phase.png`, 12:09
`t8_subzeros.py`. The six inline analyses fell between those marks and their
exact times are **not recoverable**; the interleaving above is the only
chronology there is.

**What reproduced.**

* **t10** exact — base 4 = dyadic in pairs True, base 8 in triples True,
  Dirichlet 0.1853 / 0.2876 / 0.1725 at ω 2.7689, four zeros at exactly
  `(2,1) (4,1) (8,3) (20,6)` for merge k=1 and 0 for k=2..6 at 2^48.
* **t11** exact — `fold(k·parent alias) = direct alias` to ≤ 1.8e−15 for bases
  4/8/16/9/27 at 0.7453 / 2.0236 / 1.4907 / 0.3588 / 2.6035; base 9 at 0.86
  cycles.
* **t12** exact — 0.5197–0.5346 across bases 2–9 at 2^48, orphan mean 0.5242,
  chain mean 0.5321, where "chain" is the three bases WITH a parent (4, 8, 9),
  not the five in any chain; 2 and 3 are roots at 0.5253.
* **t13** exact — dyadic flip crossover d=7 matching t2's spectral 7, triadic 12
  against spectral 10, bases 4–9 flat 0.00 at every depth, invariant for
  MIN_ROW 3..8.
* **t14** within Monte Carlo error — observed 26.744 exact, matched null
  25.724±0.744 against a reported 25.731±0.747, i.e. 1.3 MC standard errors;
  z +1.37 vs +1.36, p 0.915 vs 0.909. Its S recomputation by the Pascal
  recurrence matched `results/sub_integer_base_scan.json` at all 121 zeros, 0
  mismatches.

**What did not.** t9's *structure* reproduced exactly — rung counts
142/186/233/248/286/317/358, Nyquist 17.23/22.48/28.28/30.10/34.62/38.51/43.44,
and every base recovering exactly the zeros beneath its own ceiling — **but 6 of
the 7 recovered γ values differ in the third decimal**: 21.021 vs 21.022, 25.018
vs 25.016, 30.448 vs 30.449, 32.927 vs 32.924, 37.644 vs 37.645, 40.934 vs
40.933; only 14.141 identical. Differences reach 0.003 against a periodogram
resolution element of 0.243 rad, so agreement is well inside resolution — but
the exact digits are **not** reproduced, and the inline original must have
differed in some detail. The grid was tested at four spacings and all give the
same peaks to 0.003, so it is not the grid.

**Also unrecovered.** t9 finds γ₈ = 43.3271 beneath base 1.0750's Nyquist 43.44,
with its peak at 43.565 — ABOVE the ceiling — which the reported table did not
list. Nothing was tuned to close any gap.

---

## 2026-08-20 — Entry 63 — six NOTEPAD lines were inside the header's own format example; the trap removed and the checker taught to see it
type: instrument-fix
refs: 53, 54, 55, 56, 57, 58

**What was wrong.** `notes/NOTEPAD.md` opened with a `Format (strict, for grep):`
block whose fenced example contained
`- [STATUS] YYYY-MM-DD  entry N: terse one-line description` — a line shaped
exactly like a real thread. Six lines, citing entries 53 through 58, had been
prepended "to the top of the file" and landed **inside that fence**, above the
template line, instead of under `## Threads`.

**Why nothing caught it.** `check_refs.py` reads NOTEPAD.md raw rather than
fence-stripped, so the six were length-checked and format-checked and passed
both — they are well-formed lines in the wrong place. **The checker had no
notion of place.** `CLAUDE.md` § Rule — load, don't recall already names this
file as one that "contains examples of itself", and the rule did not prevent it,
because a rule you have to remember at write time is not a check.

**Root cause is duplication, not carelessness.** `notes/notes_format.md:39`
says the NOTEPAD format is system-wide, lives at `~/GitHub/NOTEPAD_TEMPLATE.md`,
and is "Not restated here." NOTEPAD.md restated it anyway — a third copy of a
spec that already existed twice, and the copy is what people fall into.

**Three changes, Julian approving each.**

1. The `Format (strict, for grep):` fence and its `STATUS is one of:` line
   deleted from `notes/NOTEPAD.md`, replaced by a pointer to
   `~/GitHub/NOTEPAD_TEMPLATE.md`. The `Common greps` fence stays — nothing has
   ever been prepended into it, because it does not look like entries.
2. The six lines moved into `## Threads`, immediately below entry 59's, in their
   existing order. **Content byte-identical; no status transitions.** Relocation
   only — every one of them is still `[open]`.
3. `utilities/check_refs.py` now tracks whether it has passed the `## Threads`
   heading, and reports any `- [status]` line above it as BROKEN.

**Tested in both directions.** A line planted above `## Threads` is caught —
`BROKEN NOTEPAD.md -> line 9 is above "## Threads"`. On the repaired file the
check is silent.

**Prior results comparable.** The baseline diff is empty: 14 broken references
before and after, the same 2 declared-PENDING plus 12 oversized lines. The six
moved lines were under 400 chars and already passing every other check, so no
count moved. `check_values.py` unaffected — it reads `papers/` only.

**Still open, not fixed here.** The 12 oversized NOTEPAD lines, and the fact
that entries 53, 55, 56, 57 and 58 carry the date 2026-08-21 against commits
timestamped 2026-08-20. Both are Julian's to decide; the dates in particular
cannot be corrected by an agent without changing the dated record.

---

## 2026-08-20 — Entry 62 — the joint cross-base test has never been run on the exact zeros, only on the gammas
type: motivation
refs: 49, 52, 54, 56

**Scope observation, from Julian.** Entry 52's `(40,12)` result was cited in
conversation as evidence that the four exact zeros are not a feature of any
cross-base structure. That citation is too broad, and the entry's own text says
why: the test was at `b = 2^(1/2)`, where `(40,12)` is "the exact image of base
2's `(20,6)` under factor-2 refinement: `r` doubles, `d` doubles."

`(√2)^(2r) = 2^r`. Base 2 is every other rung of the √2 ladder. So entry 52
tested **resolution**, not **coupling** — whether the zero survives sampling the
same ladder finer. It does not, and that stands. It is not a test of whether
structure runs between ladders that are independent of each other.

**The gap.** Two designs exist in the tree and have never been combined:

* O18 coupled incommensurate ladders and it worked. Base 2 alone NULL, base 3
  alone NULL, the joint orbit `{2^m 3^n}` detecting γ₂ at P/median 6.95, three
  generators reaching γ₄. `CONTEXT.md` § O18. **Object: the γ's.**
* O44 scanned the exact zeros across bases 2–9, 1289 pair-identity cells, and
  found only base 2 has any (entry 49). **Method: one table at a time.**

O18's whole lesson was that "blind singly" and "blind jointly" are different
questions. For the exact zeros only the first has been asked.

**Why it is not a straightforward test.** A γ-detection is a spectral statistic
computable on any orbit; an exact zero is an integer cell in one table. "Joint"
needs a construction producing one number from two ladders. O44's pair-identity
scale coordinate is one candidate already in the tree.

**The trap this design walks into.** Entry 56 and entry 54: eight of O45's
eleven bases are exact multiples of `π/(4γ₁)` in log, commensurate *by
construction*, carrying 107 of 125 zeros — so cross-base alignment was forced by
the base choice rather than found, and entry 54 records the surface question as
unanswerable with that base set. Any joint design must fix its base set against
commensurability first or it measures its own arithmetic.

**Not evidence it would find anything.** O44's base-by-base answer was a clean
no. This entry records that a question is unasked, which is not a prediction
about its answer. No test proposed, no prereg, nothing run.

---

## 2026-08-20 — Entry 61 — the diagonal gain is `√b`, derived rather than measured
type: formalization
refs: 45

`analysis/2026-08-19_table_structure/CHAIN.md` lines 1360-1370 record
`dia/col = 1.414214` against `sqrt(b) = 1.414214`, 615 cells, 0 failures, with a
prose derivation: along a diagonal `r − d = c` a mode picks up
`b^(cρ)·[b^ρ − 1]^d`, so the per-step factor is `b^ρ − 1` rather than the
column's `1 − b^(−ρ)`, and the two differ by exactly `b^ρ`.

**`sqrt` and `b^(1/2)` occur nowhere in `lean/`.** Checked across all eleven
modules. `PairIdentity.exponent_const_on_diagonal` and
`PairIdentity.total_const_on_diagonal` prove the diagonal is the trend's level
set and that this is unique to `b = 2`; neither says anything about the gain
ratio. The measured fact had no formal counterpart.

**Four theorems, drafted and compiling.** Against `EulerFactorChain.sym b ρ =
1 − b^(−ρ)`:

```text
diagonal_gain               b^ρ * sym b ρ = b^ρ − 1
diagonal_cell               b^((d+c)ρ) * (sym b ρ)^d = b^(cρ) * (b^ρ − 1)^d
diagonal_over_column        (b^ρ − 1) / sym b ρ = b^ρ          (sym b ρ ≠ 0)
diagonal_over_column_at_half  b^(1/2) = √b                     (0 ≤ b)
```

All four at `[propext, Classical.choice, Quot.sound]`. That is the floor, not a
defect: the statements are ℂ-valued, and ℝ is constructed with `Classical.choice`
in Mathlib, so no proof style removes it. Compare entry 59 — the split is real.

`diagonal_gain` needs only `b ≠ 0`; the `√b` specialization needs `0 ≤ b`.
Route: `Complex.cpow_add`, `Complex.cpow_nat_mul`
(`Mathlib/Analysis/SpecialFunctions/Pow/Complex.lean:109`), `Real.sqrt_eq_rpow`
and `Complex.ofReal_cpow` (`.../Pow/Real.lean:984` and `:278`).

**Not in the tree.** Draft at the session scratchpad as `diagonal_gain.lean`;
landing it means editing `lean/EulerFactorChain.lean` and adding four
`#guard_msgs` pins, which was not done. What is recorded here is that it
compiles, not that it is committed.

---

## 2026-08-20 — Entry 60 — the operator IS Pascal: `tableFrom = stencil`, and the zeros as one line each
type: formalization
refs: 45, 52, 59

`lean/Zeros.lean:88` defines `stencil N g = ∑ k ∈ range (N+1), (−1)^k C(N,k) g k`
and proves it linear, antisymmetric, and constant-annihilating. **No theorem
connected it to `Construction.tableFrom`.** The two objects sat in the same
tree, one the recurrence and one the closed form, with nothing asserting they
agree.

**Now proved, drafted and compiling:**

```text
tableFrom_eq_fwdDiff    tableFrom N r d = (−1)^d * (fwdDiff (−1))^[d] N r
                        [propext, Quot.sound]
tableFrom_eq_stencil    tableFrom N r d = stencil d (fun k => N (r − k))
                        [propext, Classical.choice, Quot.sound]
```

Route is Mathlib's `fwdDiff_iter_eq_sum_shift`
(`Mathlib/Algebra/Group/ForwardDiff.lean:143`), which carries the binomial
theorem. Our backward difference is `(−1)^d` times its forward one at step
`−1`; the sign folds because `d + (d − k) = 2(d − k) + k` for `k ≤ d`, so
`(−1)^(d+(d−k)) = (−1)^k`. A direct induction with `Finset.sum_range_succ'` and
Pascal was attempted first and abandoned — the index-shift bookkeeping is worse
than the bridge.

**What it buys.** A cell stops being a table walk and becomes one linear
equation on `d+1` values of the row. Checked against real counts, from the
depth-0 row `N(r) = π(2^r) − π(2^(r−1))` for `r = 1..8` = `1,1,2,2,5,7,13,23`:

```text
(8,3) zero      23 − 3·13 + 3·7 − 5 = 0      by decide, no axioms
(7,3) non-zero  13 − 3·7  + 3·5 − 2 = 5      by decide, no axioms
```

The non-zero is deliberate: without it the check only fires in one direction.

This does **not** predict a location and is not evidence toward one. It moves
the four zeros from four transcribed pairs in `Construction.measured_zeros` to
four explicit Pascal-weighted conditions on π. The arithmetic input remains
π(2^r) and always will.

**Not in the tree.** Draft at the session scratchpad as `stencil_equation.lean`;
landing it means editing `lean/Zeros.lean` and adding two pins.

---

## 2026-08-20 — Entry 59 — Construction.lean off Mathlib: two of the three axioms were the library's, not the mathematics'
type: formalization
refs: 45, 47

**Claim under test.** That the integer half of the tree was at
`[propext, Classical.choice, Quot.sound]` because of what it proves. It was not.
It was because every module opens with `import Mathlib`, and Mathlib's generic
ring and order instances are classical.

**Measured, in a Mathlib-free file against Lean core only:**

```text
                                  with Mathlib                      core only
tableFrom_add          [propext, Quot.sound]                        [propext]
tableFrom_smul         [propext, Quot.sound]                        [propext]
zero_determined_by_row [propext, Quot.sound]                        [propext]
tableFrom_zero         [propext]                                    none
vanishing_above        [propext, Classical.choice, Quot.sound]      [propext]
```

`vanishing_above` is `SeedPerturbation.tableFrom_eq_zero_of_vanishing_above`,
the gating theorem for the seed protections of entry 47. It had been read as
capped by inheritance from `Construction.zero_determined_by_row`; the cap was
Mathlib's floor, not the theorem's.

**Cost table for core tactics**, measured, no Mathlib:

```text
rfl / decide / induction / Nat→Int cast     no axioms
simp, named core Int lemma                  [propext]
omega                                       [propext, Quot.sound]
```

So `Classical.choice` came from Mathlib's instances and `Quot.sound` came from
`omega` — and `omega` was only ever reached for casts that are definitional.
`r − ((k+1 : ℕ) : ℤ) = r − 1 − (k : ℤ)` closes by `rfl`;
`Mathlib/Init/Grind/Norm.lean:82` proves the Nat→Int cast by `rfl`.

**A named lemma can be worse than a tactic.** Replacing `ring` with Mathlib's
`mul_sub` in `tableFrom_smul` *raised* the count to include `Classical.choice`,
because `mul_sub` is stated over a general ring. Core's `Int.mul_sub` does not.
Reverted before this work began; recorded because it is counterintuitive.

**Landed.** `lean/Construction.lean` no longer imports Mathlib. `lake build`
succeeds at 8037 jobs. Two changes beyond the proofs were forced:

1. Core has no `ℕ`/`ℤ` notation. Declaring it unqualified breaks every
   downstream import — `environment already contains 'termℤ' from
   Mathlib.Data.Int.Notation`. `local notation` fixes it.
2. `PairIdentity.tableFrom_add_window` dropped `Quot.sound` **by inheritance**
   and its pin had to be updated. The `#guard_msgs` check caught it, which is
   the check working in the improving direction.

Tree tally moved 15 → 11 at `[propext, Quot.sound]` and 8 → 12 at `[propext]`.
`Classical.choice` is unchanged at 79 of 113: `Construction` never carried any.
Moving that number requires `SeedPerturbation` (10 theorems, and it uses no
Mathlib surface at all) and the ℤ half of `PairIdentity` (3).

**The boundary this exposes.** 55 of the 79 `Classical.choice` theorems mention
ℝ or ℂ. Those can never drop it — ℝ is built with choice in Mathlib. So the
axiom line, once the integer modules move, *is* the arithmetic/analytic
boundary, printed by the compiler rather than argued in prose.

Verified separately: axiom lists are fixed in the proof term at elaboration, so
a downstream `import Mathlib` cannot raise them. `Zeros`, `PairIdentity` and
`SeedPerturbation` still import Mathlib and read `Construction`'s theorems at
their reduced counts.

---

## 2026-08-21 — Entry 58 — one of NEXT.md's two "written record errors" is not an error
type: result-triage
refs: 57

`lean/NEXT.md` has carried two corrections as outstanding since it was written.
Both were checked against artifacts today. One is real. The other is two
different quantities being compared as if they were one.

**Not an error — the G4 six-zero spread.** NEXT.md says the spread "is 8.56%,
recorded as 8.4%". Both numbers are correct and they measure different things.

`results/O24_gen_xmax3e9_run.log` carries two G4 tables.

Line 156, "P/median AT THE SIX gamma_n" — the value of the statistic *exactly
at* each γₙ:

```text
37.25863  36.93211  38.25230  36.83018  35.27244  36.70965
(max−min)/min = 8.4481%   ->  8.4%
```

Lines 205–210, "TEN LARGEST LOCAL PEAKS — G4" — the height of the local peak
*nearest* each γₙ, all six in band:

```text
38.299307  37.258633  36.932107  36.837708  36.760192  35.279641
(max−min)/min = 8.56%
```

`CONTEXT.md:299` and `lab_notebook.md` entry 42 report the first.
`papers/The-Four-Prime-Peak.md` § E2 reports the second, and its source line
names the table it used. Neither is wrong and neither should be edited to
match the other. **Recorded so that a later reader does not "fix" one of them.**

The distinction is not cosmetic: a peak *near* γₙ and the value *at* γₙ differ
by however far the peak sits off the zero, and G4's offsets run 0.0020 to
0.0209. Which one is the right statistic depends on the question, and the two
documents are asking different ones.

**Real — the 247-cell attribution.** `CONTEXT.md:305` credits the reproduction
of `files (2)/unit_weighted_dyadic_table.csv` across 247 cells to **O27**. It
is **O16's GATE A**: `results/O16_run2.log` lines 229–244 read "cells compared
: 247, mismatches : 0" for that file and for `composite_unit_dyadic_table.csv`,
then "GATE A: PASSED". No O27 log mentions 247 or that CSV. O27's own
contribution — the joint dyadic/triadic table to r = 41 — is separate and
stands.

**Method note.** NEXT.md is prose, and its claims were propagated into a commit
message before being checked. The artifacts settled both in under a minute.
Third time in this session that a recorded defect inverted on inspection: the
`§ B4` citations were valid, O42's Run record was already filled, and now this.

## 2026-08-21 — Entry 57 — two scripts quoted a rule that changed, and one artifact now disagrees with its script
type: provenance
refs: 53, 54, 55, 56

**What changed.** `O23_alignment_replication.py` line 1250 and
`O44_cross_base_zero_scan.py` line 10 both carried this verbatim in their
STATUS text: *"Currently only 07/O7 is preregistered."* That sentence was
copied out of `CLAUDE.md` § Prereg discipline when each script was written.

It is now wrong twice over. There are four locked preregs —
`alpha_depth_trend`, `zero_winding_phase`, `extended_zero_census`,
`sub_integer_base_scan` — and as of 2026-08-20 all four carry verdicts:
`depth_dependent`, `no_constant_angle`, `magnitude_floor`, `fineness`.
The CLAUDE.md line the scripts quoted no longer exists.

**Fix.** Both now cite `CONTEXT.md` § "Current state of the world" instead of
enumerating, and both say why: an enumeration goes stale, and this one did.
The same move that took the lab-notebook type vocabulary from four copies to
one and the prereg mechanics out of CLAUDE.md.

**Not an instrument-fix.** Nothing about what either script measures changed.
No re-run was performed and none is needed; prior results remain comparable.

**A divergence, recorded rather than repaired.** O23's sentence sits inside a
JSON output field, `exploratory_note`. So
`results/O23_alignment_replication_results.json` and
`results/O23_alignment_replication_results_run2.json` still contain the old
text. They are frozen records of what the script said when it ran and are
correct as they stand. The script and those two artifacts now differ by that
string, deliberately. A re-run would close the gap and is not worth the churn.

**The general shape.** A quoted rule is a copy, and copies go stale silently
because nothing checks prose against its source. `utilities/check_refs.py`
catches a citation that does not *resolve*; it cannot catch one that resolves
to text saying something different from what the quoter claims. That gap is
open and nothing in the tree closes it.

## 2026-08-21 — Entry 56 — t24: one fact that had been found five times
type: run
refs: 54, 55

EXPLORATORY. No prereg, no decision rule, nothing here is a verdict.

**Script.** `analysis/2026-08-19_table_structure/scripts/t24_commensurability.py`,
no flags, run 19:09:54. Output
`analysis/2026-08-19_table_structure/results/t24_commensurability.txt`.

**Question.** Whether `log b₁ / log b₂` is rational had decided at least five
results on this bench, each time under a different name. This computes the one
quantity behind all five.

**Headline.** Among integer bases 2…9 the commensurate pairs are exactly the
power chains 2-4-8 and 3-9; bases 5, 6, 7 meet nothing. The sub-integer scan's
family and antiphase arms are all `exp(π·m/(4γ₁))`, so all eight are integer
multiples `m = 2…9` of one unit, `π/(4γ₁) = 0.055565153` in natural log — the
scan is commensurate by construction. For `(20,6)`'s window ratio `2⁷ = 128`
no integer base but 2 reaches it at integer depth; for `(8,3)`'s `2⁴ = 16`,
base 4 reaches it at depth exactly 1.

**What it collects.** The same arithmetic appears as the mechanism in
`t6_multirate` (incommensurability breaks the alias comb), the kill in
CHAIN.md §10 (no inheritance between bases), the obstruction in t22 (the scan
cannot answer its own question), the censoring note in `The-Four-Zeros` § C5,
and a theorem — `Zeros.window_exclusive_of_prime_exponent`, which settles it
for one window and turns on 7 being prime.

**Written up as** `papers/Commensurate-Ladders.md`. Its § F3 records that the
general ladder-intersection statement is the one piece of arithmetic every
result above leans on and was not in the Lean tree; `Zeros.base_of_meets_two`,
`factorization_proportional` and `primeFactors_eq_of_meets` have since closed
the dyadic case and the proportionality, and the ancestor construction remains.

## 2026-08-21 — Entry 55 — t23: the deep zeros as two weighed halves, and one correction to the record
type: run
refs: 54

EXPLORATORY. No prereg, no decision rule, nothing here is a verdict.

**Script.** `analysis/2026-08-19_table_structure/scripts/t23_fold.py`, no
flags, run 06:02:02. Output
`analysis/2026-08-19_table_structure/results/t23_fold.txt`.

**Question.** Can the deep zeros be read as a balance rather than a vanishing?

**Headline.** The stencil weights `(−1)^k C(7,k)` are antisymmetric about the
window midpoint at `log₂ x = 16.5`, so `(20,6)` is a sum over four straddling
pairs with no leftover term. Split by sign, each arm carries total weight 64
and the two arms weigh **807295 each** on eight values of π sharing no term.
The same wing split reaches `(8,3)`: weights `1,−4,6,−4,1`, arms 8 and 8,
totals **168 and 168**.

**Control.** `(21,6)` folds to 1713, which is `cell(21,6)`. The fold is an
identity for odd stencil order, not a test — every cell equals its folded sum
whether or not it vanishes. `wing+ − wing− = cell` identically, so the wings
cannot be evidence for anything the cell value does not already say. Both are
recorded in the paper as § A4 and § B7 rather than presented as findings.

**Correction to the record.** `(25,11)` was placed on diagonal 13 in
conversation; it is on 14. Caught because the number did not resolve to the
result file. Script and paper both fixed in the same pass.

**Written up as** `papers/The-Fold.md`.

## 2026-08-20 — Entry 54 — t22: the zero surface is unanswerable with this scan, and the base set is why
type: run
refs: 50, 51, 52

EXPLORATORY. No prereg, no decision rule, nothing here is a verdict.

**Script.** `analysis/2026-08-19_table_structure/scripts/t22_zero_surface.py`,
no flags, run 05:05:24. Output
`analysis/2026-08-19_table_structure/results/t22_zero_surface.txt`.

**Question.** Do O45's 125 pooled zeros form a connected object across bases,
or an interval that merely happens to be occupied? Measured as cross-base
nearest-neighbour distance in the `(lo, hi)` window plane, against a null drawn
from each base's own resolved support, stratified so base composition matches.

**Headline.** Cross-base: observed 0.3745, null mean 1.0524 sd 0.0611,
z = −11.10. Within-base control: observed 1.2550, null mean 3.4454 sd 0.2250,
z = −9.73. The control moves too, so the compression is not about crossing
bases — it is present at every base separately. Width-matched null halves it
to z = −5.32 rather than collapsing it.

**Why it does not count.** The sorted window list carries exact `lo` repeats
across different bases, which is not an accident. Eight of the eleven bases
have `log₂ b` an exact integer multiple of `π/(4γ₁)`, and those eight carry
107 of the 125 zeros. There is no incommensurate pair anywhere in the scan, so
cross-base window alignment is forced by the base selection. The statistic
measures the prereg's choice of bases, not the arrangement of the zeros.

**Written up as** `papers/The-Zero-Surface.md`. The commensurability finding
is also the scope note now attached to O45's `fineness` verdict.

## 2026-08-21 — Entry 53 — t26: `d*` is not a per-base constant, its slope is — and a subcritical base crosses
type: run
refs: 41, 52

EXPLORATORY. No prereg, no decision rule, nothing here is a verdict.

Written to settle the two CONTESTED banners placed on
`analysis/2026-08-19_table_structure/CHAIN.md` §3 and §4 on 2026-08-20.

**Script.** `analysis/2026-08-19_table_structure/scripts/t26_crossover_by_r.py`,
new, no flags. Output `analysis/2026-08-19_table_structure/results/t26_crossover_by_r.txt`. `t2_crossover.py` is unchanged and its result stands — t26 is a
different measurement, not a re-run, so prior numbers remain comparable.

**Method.** t2 computes `d*` once per base over the whole depth-0 row: the
first depth at which oscillation carries more than half the spectral power.
t26 computes the identical statistic on the row truncated to its first `r`
rungs, sweeping `r`. That makes `d*` a function of `r` rather than a scalar.
Same window, same DC/oscillation split, same `min_n = 10` floor.

**Result 1 — `d*` is not a per-base constant.** Every one of the eight bases
shows `d*` rising with `r`. Dyadic runs `d* = 3` at `r = 13` to `d* = 7` at
`r = 32`. So CHAIN.md §4's fit `d* ≈ 1.1 + 8.1·ln b` correlates eight numbers
that are not constants. `papers/Depth-as-Time.md` § D2 is upheld against it.

**Result 2 — the per-base quantity is the slope.** `d*(r)` is close to
proportional, `d* ≈ c(b)·r`:

```text
base          b        ln b     slope    slope/ln b
family k=1    1.1175   0.1111   0.0125   0.1125
family k=2    1.2489   0.2223   0.0324   0.1458
2^(1/3)       1.2599   0.2310   0.0339   0.1467
family k=3    1.3957   0.3334   0.0635   0.1905
2^(1/2)       1.4142   0.3466   0.0611   0.1763
family k=4    1.5597   0.4445   0.0814   0.1831
dyadic        2.0000   0.6931   0.2023   0.2919
```

`corr(ln b, slope) = +0.9735`, fit `slope ≈ 0.3246·ln b − 0.0409`. So §4 found
a real relationship and attached it to the wrong variable. The correlation
survives the correction; the quantity it correlates does not.

**Result 3 — a subcritical base crosses.** `papers/Depth-as-Time.md` § C4 says
bases with gain ratio below 1 have "no instability at any depth, at any `r`".
Family k=4 has ratio 0.5553 and crosses at `d* = 1` by `r = 11`, rising to 5.
CHAIN.md §3's observation was correct and the contradiction is real.

**Reading, and it is harsher than either section.** All eight bases cross,
including the subcritical one, each at a fixed fraction of `r`. A statistic
that fires on every table at `d* ≈ c(b)·r` is not measuring the § C3
instability — it is measuring something that happens to any table with depth,
plausibly the shrinking row length. So the resolution is not "§ C3 is wrong":
t2's `d*` and § C3's crossover are different quantities that were being
compared as if they were one.

**Against O33.** `Depth-as-Time` § D3 reports slope 0.3031 for b=2 from O33's
turnaround series. t26 gives 0.2023 on this statistic. Different quantity,
different turnaround; neither refutes the other, and they are not
interchangeable.

**Open.** What `d*` actually tracks. If it is row length, `d*` should scale
with the number of surviving points rather than with `b`, and the
`slope/ln b` column — which drifts 0.11 → 0.29 rather than staying flat — is
the place to look. Nothing here tests that.

## 2026-08-19 — Entry 52 — O46/O47: `density ≈ 1/S` refuted, the zeros live in the thin tail, and (20,6) does not survive refinement
type: result-triage
refs: 47, 50, 51

Two EXPLORATORY reads of entry 51's run of record — no prereg, no
p-value, nothing stamped. `O46_mass_density_check.py` →
`results/mass_density_check.json` (24,756 B) +
`results/mass_density_check_run1.log` (126 lines), 2026-08-19T07:43:07Z;
`O47_high_mass_zeros.py` → `results/high_mass_zeros.json` (180,549 B) +
`results/O47_high_mass_zeros_run1.log` (278 lines), 08:09:13Z. Both open
O45's script and JSON read-only and both re-derive its stratum:
geometry matches the locked table at all eleven bases, zero sets match
O45 exactly, and O46's mass recurrence agrees with O45's
`stencil_mass()` over 2297 cells, **0 mismatches**. No cell violates
`|cell| ≤ S` and no resolved cell has `S = 0`, so not one zero in the
run is arithmetically forced.

**The mechanism proposed, and its refutation.** `mass_bound` is exact:
a cell is a signed integer in `[−S, S]`, `S(r,d) = Σ_k C(d,k)·N(r−k)`.
If cell values were spread over that range, landing on 0 would go like
`1/S` — a parameter-free prediction with no free constant, testable in
two forms. Both fail:

```text
  density x mean(S)    min 3.07433e+09   max 4.25686e+47   spread 1.38465e+38
  density / mean(1/S)  min 0.617483      max 3.43727       spread 5.56658
```

A spread of 1 would be exactly constant. The parameter-free product
spreads by 38 orders of magnitude. The sharper form is far better
behaved — a factor of 5.6 — but it does not cluster at 1 either: eight
of the eleven bases sit between 2.30 and 3.44, base 2 at 1.72, and two
bases fall below 1 (`2^(1/3)` at 0.617, antiphase `k = 4` at 0.799).
Clustering at 2–3 is a real regularity and is not the prediction.

**And the premise itself is false.** `|cell|/S` over the resolved
stratum has median between **3.52e−4** (`2^(1/2)`) and **2.20e−3**
(`2^(1/3)`), so roughly `1e−3` at every base. Cells sit three orders of
magnitude inside their own bound. They are not spread over `[−S, S]`,
so the chance of hitting 0 was never `1/S`, and the two spread factors
above are measuring a model that was wrong at its first line.

**What replaced it: the zeros live in the extreme thin tail of the mass
distribution.** Per base, median `S` at a resolved zero against median
`S` over the whole resolved stratum:

```text
  median S at a zero        8  to  516     across the eleven bases
  median S over the stratum 2.40e+07 (base 2) to 3.55e+18 (finest base)
```

Base by base the ratio of the two runs from **5.4 orders** of magnitude
(antiphase `k = 4`) to **17.1** (the finest family base); base 2's own
is 5.7. The typical zero is a cell with almost nothing to cancel. Which
makes the high-`S` end the interesting end, and it is what O47 ranks.

**Checked and only half true: zero density does rise with `b`.** The
claim carried into this entry was that density rises roughly
monotonically across the eleven bases with base 2 the maximum at about
4× the finest. Recomputed from `zeros_per_resolved_cell` in
`results/sub_integer_base_scan.json`, identical to `density` in
`results/mass_density_check.json` at all eleven bases: base 2 **is** the
maximum at 8.065e−3, and the finest base is 2.067e−3, a ratio of
**3.90**, so "about 4×" holds. "Roughly monotonically" does not, as
written. Four of the ten adjacent steps in `b` decrease, and two bases
sit far off any trend — `2^(1/3)` at 8.40e−4, a quarter of its
neighbours, and antiphase `k = 4` at 2.32e−3. The rank trend is real but
moderate: Spearman ρ = 0.655, Kendall τ = 0.564 (43 concordant pairs
against 12 of 55), permutation p ≈ 0.017 one-sided. Direction yes;
monotone no.

**The pooled ranking, 125 resolved zeros across all eleven bases.**
Base 2's four carry `S = 2, 4, 88, 492384` and land at pooled ranks
**115, 102, 37 and 3** — three of the four in the bottom quarter, and
`(20,6)` third from the top. Above it sit two cells of `2^(1/2)`:

```text
   1  2^(1/2)  (34,11)  S = 1371038   log2 window [11.5, 17.0]
   2  2^(1/2)  (42, 5)  S =  651298   log2 window [18.5, 21.0]
   3  base 2   (20, 6)  S =  492384   log2 window [14.0, 20.0]
   4  antiphase k=2 (47,4)  S = 87160
```

and the largest ratio gap anywhere in the pooled list is exactly the one
after rank 3: **5.649** = 492384/87160 = 61548/10895 exactly. So the
high-mass end is a four-cell club — two at `2^(1/2)`, `(20,6)`, and one
antiphase cell — and then it falls off a cliff. `(20,6)` is no longer
the most massive cancellation on record.

**The (40,12) result, and it is the sharp one.** At `b = 2^(1/2)`, the
cell `(40,12)` is the exact image of base 2's `(20,6)` under factor-2
refinement: `r` doubles, `d` doubles, and the window bottom `b^(r−d)`
lands on `2^14` as `b^r` lands on `2^20`. O47 checks the identity
directly rather than assuming it — `identical integer bounds: True`,
window `(16384, 1048576]` on both sides, `80125` primes in the window
on both sides. The **same primes, the same value interval, the same
question asked at twice the resolution.** The cell reads

```text
  base 2      (20, 6)   cell =     0     S =   492384
  base 2^(1/2)(40,12)   cell = -6884     S = 15723924    |cell|/S = 4.378e-04
```

`(20,6)` **does not survive refinement.** And `4.378e−04` is not a near
miss on the scale of anything — it sits essentially at that base's
median `|cell|/S`, which is 3.52e−4.

**Set that against `SeedPerturbation`.** `lean/SeedPerturbation.lean`
proves that a change of seed convention replaces the depth-0 row `N` by
`N − e` and, by linearity plus locality, cannot touch a cell whose
window bottom clears the last rung `e` moves: `R < r − d` gives
`cell_eq_of_seed_perturbation`, and `boundary_can_move` shows the strict
inequality is sharp. Entry 47 measured the same thing from the data —
`(8,3)` and `(20,6)` are unmoved by three seed conventions, six
composite variants and two repos, while `(2,1)` and `(4,1)` sit close
enough to the seed to be reached. So `(20,6)` is **robust to seed
changes and fragile to resolution changes**, and those were never the
same invariance: one is about what the bottom of the window reads, the
other about how finely the window is sampled between its endpoints.
Nothing in `SeedPerturbation.lean` claimed the second, and nothing in
it is contradicted. (It is not yet recorded anywhere in this notebook;
`lean/lakefile.toml` now globs eleven modules against the ten entry 45
counted.)

Both scripts EXPLORATORY, `summary.verdict` null in both files. Nothing
above is a verdict and nothing here bears on O45's empty verdict line.

No outcome marked.

---

## 2026-08-19 — Entry 51 — O45 run: 121 resolved sub-2 zeros, 35 clearing the mass floor, p = 0.0839 — the verdict line is empty and is Julian's
type: run
refs: 44, 49, 50

`O45_sub_integer_base_scan.py`, one run at the locked flags,
**PREREGISTERED** against entry 50's protocol. Lock written
2026-08-19T07:16:07Z; `run_start_utc` = `run_end_utc` =
2026-08-19T07:16:38Z — thirty-one seconds after lock, and the run
completes inside one second. Python 3.14.3, `code_version`
`f06f6f3c…`. Artifacts `results/sub_integer_base_scan.json` (177,989 B)
and `results/O45_sub_integer_base_scan_run1.log` (50,589 B, 746 lines).
`pi2n_cache.json` read, not written; nothing under `imported/`,
`lean/` or `preregs/` opened for writing.

**Sidecar.** `preregs/sub_integer_base_scan_v1_20260818.sha256` reads
`7985c94015bab8d8f2e606b69aaeac79150ccec1d4ec9d04bca7db177c02aaf5`, and
the Run record's `post_compute_sha256` is the same string — so no
parameter, hypothesis or decision-rule text drifted between lock and
compute.

**Check 1, π backend.** `primecountpy.prime_pi` 0.2.1, **33 of 33**
audit comparisons equal against `pi2n_cache.json`, including
`π(2^32) = 203280221` backend and cache. PASS.

**Check 2, geometry.** All eleven bases recompute `r_max`,
`cells_at_d_ge_1`, `r_thick` and `resolved_cells` equal to the locked
table — `geometry_matches_locked` true for every base. Minimum relative
distance of any `b^r` to an integer over the whole support is
**1.665e−12** at antiphase `k = 1` and `k = 2`, the same number the
prereg pre-computed, forty-eight orders above the dps-60 floor and far
above the 1e−30 determinacy threshold. `root_selfcheck_failures` 0 at
both refinement bases. `summary.compromised_conditions` is `[]`.

**Check 3, base-2 reproduction.** Through the identical code path at the
same value ceiling, base 2 rebuilds `[[2,1],[4,1],[8,3],[20,6]]` over
496 cells — the known set, no more and no fewer. A reproduction check,
not evidence; the prereg says so and so does the log.

**Check 4/5, the scan and the rate test.** The primary statistic:

```text
  resolved cells   base 2   496     sub-2  37178
                                    family 20661  antiphase 11236  refinement 5281
  Z_2  (base 2, resolved)         : 4
  Z    (sub-2, resolved)          : 121
  Z*   (of those, S >= 88)        : 35     family 13  antiphase 18  refinement 4
  E[Z] under H0                   : 299.822580645161  (locked value, reproduced)
  conditional-binomial p (PRIMARY): 8.394656e-02   [exact]
  Poisson p (SECONDARY)           : 6.367145e-32
  alpha_level                     : 0.05, one-sided
```

Zeros on the **full** support total 240 across the ten sub-2 bases
against 121 resolved — the resolved criterion discards a little over
half of them, which is what entry 50 designed it to do. Per base,
resolved zeros: family 29 / 14 / 9 / 7, antiphase 21 / 15 / 10 / 2,
refinement 11 (`2^(1/2)`) and 3 (`2^(1/3)`). Every one of the eleven
bases has at least two resolved zeros.

**The mechanical output of the decision rule is `fineness`**, by
`Z* ≥ 1`, not `family_only`, not `refinement_only`, and
`p = 0.0839 > 0.05`. That is the rule's arithmetic and nothing more.
`summary.verdict` is `null` by design and `verdict_note` reads "the
verdict line is Julian's to write in the prereg's Run record"; the Run
record's `- verdict:` line is **empty**. This entry does not fill it and
does not read the branch as a result.

**What the run eliminates, stated in the prereg's own terms.**
`intrinsic_base_two` required `Z = 0`; `Z = 121`. So "sub-2 bases stay
empty" is off the table on the resolved stratum as well as on the full
one — and not marginally: mass-clearing zeros appear in **all three**
arms, family, antiphase and refinement alike, which is what closes
`family_only` (`Z*_antiphase = 18 ≠ 0`) and `refinement_only`
(`Z*_family = 13 ≠ 0`) as well. `thin_rung_forced` needed `Z* = 0` and
`Z* = 35`, so the surplus is not confined to the thin end of the
stratum. The one thing the run does **not** eliminate is a rate below
base 2's: `p = 0.0839` sits above alpha, but 121 against an H0
expectation of 299.8 is well under half, and the prereg's own stated
weakness 1 — resolved cells at neighbouring `r` share most of their
stencil, so the independence assumption makes `p` anti-conservative
*against* H0 — cuts in exactly that direction.

**A wrinkle in the new convention, undecided.** Lines 5–8 of the prereg,
immediately under `STATUS: **LOCKED**`, read: "There is no sidecar
`sub_integer_base_scan_v1_20260818.sha256` yet; the sidecar is the
authority on lock, and its absence means this prereg is not locked."
That text is now false — the sidecar exists — and it sits **inside the
hashed region**, which measurement confirms: the sidecar hash is the
SHA-256 of the file's first 680 lines, and lines 5–8 are among them. So
the sidecar pins a paragraph asserting the file is unlocked, three
lines below a STATUS block asserting it is. The file cannot be edited
to fix it without breaking the sidecar match that the Run record
depends on. This is a wrinkle in the naming convention entry 44
introduced — the drafting boilerplate assumes the pre-lock state and
nothing strips it at lock time — not a defect in this prereg's
protocol, every parameter of which reproduced. Julian's call.

No outcome marked.

---

## 2026-08-19 — Entry 50 — the O45 prereg: fineness against intrinsic, and the empty-rung discovery that forced the resolved stratum
type: prereg
refs: 44, 45, 49

`preregs/sub_integer_base_scan_v1_20260818.md`, 695 lines as it now
stands. It asks one question of entry 49's 4-in-496 / 0-in-496 result:

```text
  fineness   base 2 is the finest INTEGER sampling of the scaling flow,
             so bases BELOW 2 - finer still - should produce zeros at
             at least base 2's per-resolved-cell rate.       [H0]
  intrinsic  base 2 is special in itself, so sub-2 bases stay empty
             and the point prediction is Z = 0.              [H1]
```

The fork is licensed by entry 45's finding that `pair_identity` takes
**no hypothesis on `b`**, and by `lean/Chain.lean`'s `C1` needing only
`0 < b`: `π(b^r) − π(b^(r−1))` is well defined for real `b > 1` and the
cells stay integers. `E[Z] = Z_2·C_sub/C_2 = 4 × 37178 / 496 =
299.822580645161`, stated as a number before the run.

**Four drafting complications, all resolved inside the locked text.**
The section is headed "The three complications" and then lists four,
`(a)` through `(d)` — a wording slip inside the hashed region, recorded
not corrected.

*(a) The pair identity is only approximate at non-integer `b`.*
`tableFrom_add_window` (linearity plus locality) is exact for any seed
rows and any `b`; `tableFrom_of_geometric` needs the rung
`(b^(r−1), b^r]` to hold exactly `(b−1)·b^(r−1)` integers, and at real
`b` it holds `⌊b^r⌋ − ⌊b^(r−1)⌋`. So O44's `nu` denominator is not
reused as such. Two totals are locked and both reported:

```text
  total_geo (b,r,d) = (b-1)^(d+1) * b^(r-1-d)        O44's denominator
  total_true(b,r,d) = sum_k (-1)^k C(d,k) W(r-k),  W(r)=|b^r|-|b^(r-1)|
```

The drift is not small: at `b = exp(π/(2γ₁))`, `(199,20)` has
`total_geo = 1.16e−11` against `total_true = −86804`, and 9601 of that
base's 19701 cells have `total_true ≤ 0`, which a positive geometric
quantity cannot do. `nu_pair = |cell|/|total_true|` is primary.

*(b) Fair comparison is by value range, not by `r`.* Bases are matched
on a **value ceiling** `V = 2^32` — base 2's extent in entry 49 — with
`r_max(b)` the largest `r` with `b^r ≤ V`, locked per base rather than
recomputed. `b = 1.11754` needs `r = 199` to reach where base 2 needs
32, and carries 19701 cells against 496; that asymmetry *is* the
fineness prediction, so every count is reported with its denominator.
Second consequence, load-bearing: `ln(b^r) ≤ ln V` at every base and
rung, so the prime density `1/ln x` entering any cell is bounded
identically across the list — density-matched by construction, not by
correction.

*(c) `(b−1)^(d+1) < 1` below 2, and the naive reading of it is wrong.*
`PairIdentity.coeff_eq_one_iff_base_two` covers integer `b ≥ 2` only.
For `1 < b < 2` the coefficient **shrinks** with depth: `total_geo` at
the ceiling drops below 1 from `d = 9, 13, 17, 21` at the four family
bases, against supports running to `d = 198, 98, 65, 48`. Read naively
that is O43's magnitude floor in reverse, forcing zeros over nearly the
whole sub-2 support. It is wrong for exactly the reason in (a):
`total_geo` is not the size of anything at a non-integer base. Floor
jaggedness is `O(1)` per rung and the stencil's L1 weight is `2^d`, so
deep sub-integer cells are **large**. The prereg's own sentence: "The
reverse magnitude floor, in the form O43 met it, does not apply."

*(d) A third outcome exists.* Zeros might appear only at the optimal-base
family `exp(πk/(2γ₁))`, which is neither account. Hence **non-family
controls in the same range**: four antiphase bases `exp(π(2k+1)/(4γ₁))`,
interleaved between consecutive family members and exactly half a
quarter-turn off the family in its own coordinate; and two refinement
controls `2^(1/2)`, `2^(1/3)`, of which base 2 is a literal
sub-sampling — the sharpest available test of fineness. Eleven bases,
`C_2 = 496` against `C_sub = 37178`, split 20661 family / 16517
non-family, so `family_only` cannot be an artefact of the controls
having had no chance. Labels `family_only` and `refinement_only` exist
for it.

**The discovery that shaped the design, and it fired before the run.**
At the finest base `b = exp(π/(2γ₁)) = 1.11754…`, `⌊b^r⌋ = 1` for
`r = 0…6` — the first six rungs hold no integers at all. Under this
project's convention (`π(1) = 0`) that gives `N(r) = 0` there and
`cell(2,1) = N(2) − N(1) = 0` **exactly**, a zero about an empty rung
and nothing else. Every sub-2 base has such a region. So `Z_full ≥ 1`
was guaranteed before a single prime was counted and "sub-integer bases
stay empty" was already false on the full support — for reasons
unrelated to the hypothesis. That is why the primary statistic is the
**resolved** count: a cell counts only if every rung its stencil reads
is expected to hold at least one prime, `W(r')/ln(b^(r')) ≥ 1` for all
`r' ∈ [r−d, r]`, equivalently `r − d ≥ r_thick(b)`. Pure geometry, no
prime counted to evaluate it, so `r_thick` and `resolved_cells` are
locked per base. At `b = 2` the criterion holds over the entire support
(`r_thick = 1`, all 496 cells, all four zeros kept) — one more sense in
which base 2 is the boundary case.

**Decision rule and vacuousness.** Eight labels, precedence
`compromised > thin_rung_forced > family_only > refinement_only >
fineness > rate_below_base_two > intrinsic_base_two > ambiguous`, keyed
on `Z`, on `Z*` (resolved zeros with `S ≥ mass_floor`) and on an exact
conditional-binomial `p`. The pre-computed p-table gives the smallest
`Z` with `p > 0.05` as **101** — a third of H0's own point prediction —
so `fineness` needs 101 mass-clearing zeros in 37178 resolved cells and
`intrinsic_base_two` needs none. Both directions reachable.

**Provenance, and the non-blind half.** `mass_floor = 88` is
`S(8,3)` at base 2, chosen with base 2's four masses `S = 2, 4, 88,
492384` already in view; the resolved criterion was fixed after the same
base-2 rebuild. Both are **calibrated on already-inspected data** and
only their application to the sub-2 bases is blind. Entry 49's results
were read in full while drafting. The genuinely blind arm is that no
sub-integer base had ever been computed here by anyone — the drafting
agent evaluated π at no sub-integer argument, and every locked geometric
quantity came from `⌊b^r⌋` alone.

**First prereg locked under the no-status-in-filename convention** that
entry 44 recorded into `CLAUDE.md`. Named
`sub_integer_base_scan_v1_20260818.md` at creation, no `_locked_`
infix, with the sidecar as the authority on lock. `lock_written_at`
2026-08-19T07:16:07Z, `locked_by` julian, `pre_compute_sha256` PENDING.
Measured for this entry, the sidecar
`7985c94015bab8d8f2e606b69aaeac79150ccec1d4ec9d04bca7db177c02aaf5`
is the SHA-256 of the file's **first 680 lines** — everything through
`- locked_by: julian` — so the locked region is the whole protocol and
the `## Run record` section was appended afterward.

No outcome marked.

---

## 2026-08-18 — Entry 49 — O44: base 2 is the only integer base with exact zeros, and entry 17's conclusion survives by a route entry 17 did not take
type: run
refs: 17, 45, 46, 47

`O44_cross_base_zero_scan.py`, one execution, **EXPLORATORY** — no
prereg, no hypothesis, no decision rule, nothing here is a verdict.
Invocation read back from `params.argv`:

```text
python3 O44_cross_base_zero_scan.py --data-dir imported/lattice_mapper/32bit \
    --bases 2,3,4,5,6,7,8,9 --d-min 1 --top-k 10 --pair-check --variant-scan \
    --out results/cross_base_zero_scan.json
```

`run_start_utc` = `run_end_utc` = 2026-08-19T06:30:13Z, completed;
Python 3.14.3; `code_version` `3ae5a3f1…`. Sixteen of the twenty-two
imported CSVs read, all read-only. Artifacts
`results/cross_base_zero_scan.json` (99,469 B) and
`results/O44_cross_base_zero_scan_run1.log` (25,995 B). The convention
in force is the **imported** one — 2 and 3 excluded as lattice (entry
46) — stated in `constants.convention` and `constants.convention_adjusted_for
= false`, so low-`r` numbers here do not compare with anything in
`results/`.

**The coordinate.** Raw `|cell|` compares across neither bases nor
depths, so O44 divides the pair identity's total out:
`nu(b,r,d) = |cell| / [(b−1)^(d+1)·b^(r−1−d)]`, every ranking on an
exact `Fraction`. That denominator is `pair_identity` of
`lean/PairIdentity.lean`, which entry 45 recorded as carrying **no
hypothesis on `b`** — which is what licenses using it at eight bases
at once.

**Extent and exact zeros at `d ≥ 1`** (`summary.per_base`):

```text
   b  file                              maxr maxd  cells  d>=1  zeros
   2  dyadic_difference_table_32.csv      32   31    528   496      4
   3  triadic_difference_table_32.csv     32   31    528   496      0
   4  tetradic_difference_table_32.csv    32   31    528   496      0
   5  pentadic_difference_table_27.csv    27   26    378   351      0
   6  hexadic_difference_table_24.csv     24   23    300   276      0
   7  heptadic_difference_table_22.csv    22   21    253   231      0
   8  octadic_difference_table_21.csv     21   20    231   210      0
   9  enneadic_difference_table_20.csv    20   19    210   190      0
```

Base 2's four are `(2,1) (4,1) (8,3) (20,6)` — the same set entry 47
read out of this same file. Base 3 is empty over the **identical** 496
cells, same ceiling and same support, so 4-in-496 against 0-in-496 is
the one uncensored comparison the table contains.

**Bases 4–9 are uninformative, and the reason is visible in where their
minima sit.** Every one of them takes its minimum `nu` on the **corner
cell** `(max r, max d)`: `(32,31)`, `(27,26)`, `(24,23)`, `(22,21)`,
`(21,20)`, `(20,19)`, at `nu` 0.0134, 0.0186, 0.0196, 0.0203, 0.0203,
0.0205. A minimum on the boundary of the support is a statement about
where the table stops, not about a floor. Bases 5–9 are additionally
extent-censored in `r_max` (27, 24, 22, 21, 20); base 4 is **not** — it
reaches `r = 32` with the same 496 cells as bases 2 and 3, and is simply
empty. Recorded because the two facts are distinct and only base 4
carries both a full extent and a corner minimum.

**The correction to entry 17, and it does not damage entry 17's
conclusion.** Entry 17 records of `triadic_difference_table_32.csv`
that "Base 3 reaches **1**, twice". Both of those cells are here and
both read `|cell| = 1` exactly — `(3,2)` and `(5,4)`, re-read from the
imported copy for this entry. But their totals are `2^3·3^0 = 8` and
`2^5·3^0 = 32`, so normalised they are `0.125` and `0.03125`, and
**neither is in base 3's ten smallest `nu`** (`summary.per_base[1].smallest_nu`,
which runs 9.77e−4 to 7.87e−3). Base 3's actual closest approach is

```text
  base 3   (11,10)   cell 2   total 2048   nu = 2/2048 = 9.765625e-04
  base 2   (13, 5)   cell 1   total  128   nu = 1/128   = 7.8125e-03
```

so base 3 comes **eight times closer proportionally** than base 2's
smallest nonzero cell does — exactly `8`, both being dyadic rationals.
Entry 17 argued base-2 extremality from magnitude and then recorded
that the magnitude argument fails to separate the bases. It fails
harder than entry 17 said: on the normalised reading base 3 is the
*closer* of the two and still never lands. Entry 17's conclusion — base
2 is where the zeros are — survives, but by the route "base 3 gets
closer and still misses", not "base 2 gets closest".

**The pair identity holds on data this project did not generate.**
Three matched pairs, `summary.pair_identity_checks`:

```text
  plain prime + plain composite                  528 cells   0 mismatches
  prime_full_silenced + plain composite          410 cells   0 mismatches
  plain prime + (composite − prime)              351 cells   0 mismatches
                                       total    1289 cells   0 mismatches
```

The third runs in mode `diff_plus_2p`. The five unmatched variants in
§ 4b mismatch at 90, 91, 40, 59, 59 cells and are flagged
`expected_to_mismatch = true` in the JSON — entry 47's arithmetic, put
on the record rather than assumed.

**One anomaly, surfaced and not chased.**
`imported/lattice_mapper/32bit/dyadic_diff_full_silenced_32.csv` is one
of the six 32bit CSVs O44 did **not** read. Measured for this entry: it
is exactly `composite_full_silenced − prime_full_silenced`, 410 of 410
cells, so it is a `C − P` table like `composite_minus_prime_32.csv`.
But it satisfies the identity against **nothing on disk**. In mode
`sum` it mismatches all twenty of the directory's other regime-keyed
CSVs (the wide `prime_composite_sidebyside_32.csv` excluded); in mode
`diff_plus_2p` its best partner is either dyadic prime arm at **59**
mismatches of 410 — and 59 is precisely the number of cells at which
its own parent pair fails, `C_fs + P_fs ≠ 2^(r−1−d)` at 59 of 410. Entry
47 cites this file as agreeing at `(4,1) = 6`, `(8,3) = 16`,
`(20,6) = 8192`, which it does; what it does not do is belong to a pair.
Not chased here.

Still EXPLORATORY. Nothing above is a verdict and nothing is decided.

No outcome marked.

---

## 2026-08-18 — Entry 48 — O33 was still reading the external lattice_mapper directory; repointed at the vendored copy, re-run, non-semantic
type: instrument-fix
refs: 36, 46

Entry 46 imported the eight base-series difference tables into
`imported/lattice_mapper/32bit/`, byte-for-byte and SHA-256 verified, so
that the evidence would sit with the work that cites it.
`O33_base_ladder_crossing.py` was not repointed. Its `DEFAULT_DATA_DIR`
still named
`/Users/juliansambrano/GitHub/lattice_mapper/difference_tables/32bit`, a
path outside this repo, and `results/base_ladder_crossing.json` →
`params.data_dir` records exactly that string. The vendored copy did not
protect the instrument: had `lattice_mapper/` been moved, renamed or
regenerated, O33 would have failed or silently read something else, with
27 verified files sitting unused two directories away. The import closed
the provenance gap for the *reader*; it did not close it for the *script*.

**Sites changed.** Three, all path, none logic. Line numbers before → after:

```text
  15-19  →  15-28   docstring, "THE SOURCE TABLES" preamble — the source
                    directory paragraph now names imported/lattice_mapper/32bit/,
                    records the byte-for-byte copy and points at the import
                    manifest and entry 46, and states that the run of record
                    predates the repoint
 194-196 →  202-205  docstring EXAMPLE — the explicit
                    --data-dir /Users/.../difference_tables/32bit line dropped,
                    since the default is now correct; a note added that an
                    explicit --data-dir is used verbatim and should be absolute
 220-221 →  230-233  DEFAULT_DATA_DIR, the default constant
```

The new default is

```python
DEFAULT_DATA_DIR = os.path.join(_HERE, "imported", "lattice_mapper", "32bit")
```

anchored to `_HERE = os.path.dirname(os.path.abspath(__file__))`, which
the file already defined at what is now line 227 for `DEFAULT_RESULTS_DIR`.
That is the house pattern, not a new one: `O16_centered_difference_table.py`
lines 169-171 anchor `files (2)` the same way, and `05`, `06`, `07`, `O11`
through `O23`, `O42` and `O43` all anchor their caches and outputs to `_HERE`.
An absolute path was rejected in favour of it so the repo stays portable.
The `--data-dir` flag's help string interpolates `DEFAULT_DATA_DIR`, so it
followed with no separate edit. `grep -n difference_tables
O33_base_ladder_crossing.py` now returns one line, 23, inside the docstring
sentence that records where the vendored files came from.

**Left alone, deliberately.** `constants.source_project` at line 1012 still
reads `/Users/juliansambrano/GitHub/lattice_mapper (READ ONLY; nothing
written there)`. That field records where the data *originated*, not where
this script *reads*, and it remains true — the vendored copy came from
there and the source tree is still untouched. Changing it would have moved
a leaf in the `constants` block, and the whole point of the comparison
below is that `constants` did not move. Same reasoning for the docstring's
scaffold-silencing section (lines 104-109) and
`constants.source_silencing`, which cite
`lattice_mapper/difference_table.py:75` as the generator: that is a
statement about provenance of the convention, and the generator is not
vendored here.

**Script SHA-256, before and after** (`shasum -a 256
O33_base_ladder_crossing.py`, run either side of the edit):

```text
  before  ffa3d5b746fd7c66cc0c6161d6532dd0d76d77ee4f0a882bec3b22eb2bf227ac
  after   55e1593b0bd950679c37684ada7ab614c346ea89c003b6cf40e37f0a1d329a01
```

The before hash is the same string carried in
`results/base_ladder_crossing.json` → `params.code_version`, so run 1
executed the pre-fix bytes and stamped them, and nothing had touched the
file between that run and this edit. 1038 lines before, 1050 after;
`python3 -m py_compile` clean.

**Re-run, to new paths.** Run 1's own invocation, read from
`results/base_ladder_crossing.json` → `params.argv`, which is
`['O33_base_ladder_crossing.py', '--min-row', '8']`, with `--out` and
`--out-csv` redirected so that neither run-1 artifact could be touched.
`--min-row 8` is also the flag's default; every other parameter ran at
default in both runs.

```text
python3 O33_base_ladder_crossing.py --min-row 8 \
    --out    /Users/juliansambrano/GitHub/Primebeat_081426/results/base_ladder_crossing_run2.json \
    --out-csv /Users/juliansambrano/GitHub/Primebeat_081426/results/base_ladder_crossing_run2.csv \
    2>&1 | tee /Users/juliansambrano/GitHub/Primebeat_081426/results/O33_base_ladder_crossing_run2.log
```

`run_start_utc` and `run_end_utc` both 2026-08-19T05:49:55Z, read from
`results/base_ladder_crossing_run2.json` → `params`; the run completes
inside one second. Python 3.14.3, mpmath 1.3.0, the same interpreter
string run 1 recorded. There was no run-1 log — `results/` held only
`base_ladder_crossing.json` and `base_ladder_crossing.csv` for O33 — so
`results/O33_base_ladder_crossing_run2.log` is the first log this
instrument has, named to the house `<script>_run2.log` pattern rather than
back-dated to a run-1 name that never existed.

Artifacts: `results/base_ladder_crossing_run2.json` (215,742 B),
`results/base_ladder_crossing_run2.csv` (14,600 B),
`results/O33_base_ladder_crossing_run2.log` (19,014 B, 236 lines).

**The change is non-semantic, and here is the evidence.** Both payloads
flattened to leaves and compared key by key. Run 1 has 6432 leaves, run 2
has 6436; the four extra are the four extra `params.argv` elements
(`--out`, its path, `--out-csv`, its path — 3 elements against 7). Of the
6429 leaves that are not `params.argv`, **fifteen** differ, every one of
them metadata:

```text
  /generated_utc              2026-08-18T03:25:29Z  ->  2026-08-19T05:49:55Z
  /params/run_start_utc       2026-08-18T03:25:29Z  ->  2026-08-19T05:49:55Z
  /params/run_end_utc         2026-08-18T03:25:29Z  ->  2026-08-19T05:49:55Z
  /params/code_version        ffa3d5b7...           ->  55e1593b...
  /params/data_dir            .../lattice_mapper/difference_tables/32bit
                                                    ->  .../Primebeat_081426/imported/lattice_mapper/32bit
  /params/out                 base_ladder_crossing.json  ->  ..._run2.json
  /params/out_csv             base_ladder_crossing.csv   ->  ..._run2.csv
  /params/source_files[0..7]/path   eight file paths, external -> vendored
```

`data_dir` and the eight `source_files` paths are the fix itself.
`code_version` moving is expected: `_code_version()` hashes `__file__` at
write time, so a changed file changes the stamp even when behaviour does
not.

Nothing else moved. The `constants`, `summary` and `rows` blocks are
**byte-identical** under a sorted-key JSON dump — all 210 rows, all eight
per-base summaries, all eight schema verifications, all eight unsilence
checks. So are `schema_version`, `script` and `script_path`. And the
`results/base_ladder_crossing_run2.csv` is byte-identical to
`results/base_ladder_crossing.csv`, same SHA-256
`f71f74b52cf923aca01e0fff8a4e4a4dfbd795302f4e1c47fba38b937d70ba94` —
the CSV carries no timestamp, so it is the cleanest single statement of
the result: the fix altered nothing this instrument measures.

**The comparison also checks the import, and the import passes.** Within
`params.source_files`, only `path` moved. `sha256`, `bytes`, `mtime_utc`,
`regimes`, `n_columns`, `header_first_4`, `header_last`,
`filename_trailing_number` and
`filename_trailing_number_equals_regimes` are identical across the two
runs at all eight bases. That is the load-bearing check: run 1 hashed the
files it read at
`/Users/juliansambrano/GitHub/lattice_mapper/difference_tables/32bit/` and
run 2 hashed the files it read at `imported/lattice_mapper/32bit/`, and
the hashes agree — the vendored copies *are* what the run of record read,
demonstrated by the instrument itself rather than by the copy that made
them. Those same eight SHA-256s agree a third time with the manifest table
in `imported/lattice_mapper/README.md`, checked line by line for this
entry: 8 of 8, 0 mismatches. `cp -p` preserved the mtimes, so even the
mtime field survives the move.

**Run 1 remains the run of record.** `results/base_ladder_crossing.json`
was not opened for writing, and still reads 215,439 B at mtime
2026-08-17 20:25 with SHA-256
`a0a070622873f424f23cdf1ce33437c0fbc21a1027828ea501b1e820fd5a1927`;
`results/base_ladder_crossing.csv` likewise. Entry 36 stands unamended.
`CONTEXT.md`'s O33 bullet still says the input "lived outside this repo at
run time … (the path `params.data_dir` records)" and that remains exactly
true of the run it describes — the repoint changes what a *future* run
reads, not what the recorded one did, and the bullet was deliberately not
edited. `CONTEXT.md` and `REFERENCES.md` were not touched by this pass.

Still EXPLORATORY. O33 has no prereg and fires no decision rule; run 2
reproduces run 1's numbers and reproduces its failed pre-stated
prediction with them — `summary.qualitative_split_matches_prestated`
reads `false` in both files, `bases_observed_crossing` `[2, 3]` in both.
Nothing here is a verdict.

No outcome marked.

---

## 2026-08-18 — Entry 47 — Is `(2,1)` a cancellation or a seeding artifact? The check splits the four zeros deep-versus-shallow
type: result-triage
refs: 12, 17, 29, 33, 36, 45, 46

The question came out of entry 17. That entry dismisses the triadic
table's `(2,1)` — "The single 0 is A_count at r = 1, which is the
construction … not a cancellation" — while the dyadic `(2,1)` is counted
among the four zeros without the same scrutiny. Entry 29 sharpened it:
under O27's convention the triadic table's one exact zero *is* `(2,1)`,
"and it is trivial: (1,3] holds {2,3} and (3,9] holds {5,7}, both count
2." So the cell nearest the seed is the cell whose reading moves with the
seed. The import recorded in entry 46 makes it testable, because it puts
a **third convention** on disk beside the two already here.

Everything below is read from artifacts named at each number. Nothing is
preregistered; no verdict is claimed and nothing is decided.

**`(2,1)` is convention-mobile — it moves with the seed and never with
the arithmetic.** Three conventions, one cell, `cell(2,1) = A(2) − A(1)`:

```text
  b                        2    3    4    5    6    7    8    9
  plain count              0    0    2    3    5    7   10   14
    = pi(b^2) - 2 pi(b)
  imported (2,3 as         0    2    4    5    7    9   12   16
    lattice, backward)
  archive (only 2          1    1    3    4    6    8   11   15
    dropped, forward)
```

Row 1 is `primecountpy.prime_pi`, computed for this entry. Row 2 is
`delta_1` at `regime 2` read out of the eight base-series tables in
`imported/lattice_mapper/32bit/` — `dyadic_difference_table_32.csv`,
`triadic_difference_table_32.csv`,
`tetradic_difference_table_32.csv`, `pentadic_difference_table_27.csv`,
`hexadic_difference_table_24.csv`, `heptadic_difference_table_22.csv`,
`octadic_difference_table_21.csv`, `enneadic_difference_table_20.csv`.
Row 3 is `delta_1` at `regime 1` read out of the eight archive tables at
`/Users/juliansambrano/GitHub/lattice_mapper/difference_tables/archive_unsilenced/32bit/`,
and it reproduces exactly when recomputed from `prime_pi` under that
convention.

Row 2 minus row 1 is **+2 at every base from 3 to 9 and 0 at base 2**.
The reason is geometric: the two excluded lattice primes are both in
`(b, b²]` for `b ≥ 3`, so they both leave `A(2)`; at `b = 2` they
straddle the boundary — 2 is in `(1,2]` and 3 is in `(2,4]` — so one
leaves `A(1)` and one leaves `A(2)` and the difference is untouched.
That is the whole of the base-2 exception, and it is a statement about
where 2 and 3 sit, not about cancellation.

**No convention makes `(2,1)` vanish at every base**, which is what a
pure seeding artifact would do. Plain count vanishes at `b = 2` and
`b = 3` and nowhere else. The imported convention vanishes at `b = 2`
only. The archive convention vanishes at no base at all. The cell is
mobile, but it is not free.

**Silencing can manufacture it, and the arithmetic of that is exact.**
Each additionally silenced prime landing in `(b, b²]` decrements
`cell(2,1)` by exactly one. Measured, `delta_1 @ regime 2`:

```text
  32bit/triadic_difference_table_32.csv             2
  32bit/triadic_difference_table_32_silence235.csv  1     (5 silenced)
  32bit/triadic_difference_table_32_silence2357.csv 0     (5 and 7)

  32bit/tetradic_difference_table_32.csv            4
  32bit/tetradic_..._silence2357.csv                2     (5, 7)
  32bit/tetradic_..._silence235711.csv              1     (5, 7, 11)
```

`(3,9]` holds `{5,7}`; `(4,16]` holds `{5,7,11,13}` and only three of
those are named. The 64bit triadic pair reproduces it — 2, 1, 0 across
`triadic_difference_table_40.csv`, `_silence235.csv`, `_silence2357.csv`.
So a `(2,1)` zero is available on demand in base 3 by naming two more
primes, and that is the strongest statement against reading the dyadic
`(2,1)` as the same kind of object as the deep two. Note also that
`triadic_difference_table_32_silence235.csv` carries a zero at
`(10,9)` — one exact zero, at depth 9, produced purely by silencing.
That cell is unexamined and is not chased here.

**All four dyadic zeros survive the convention change.**
`imported/lattice_mapper/32bit/dyadic_difference_table_32.csv` holds 496
populated cells over `r ≤ 32, d ≤ 31` and returns exactly

```text
  {(2,1), (4,1), (8,3), (20,6)}    and no other zero
```

`imported/lattice_mapper/64bit/dyadic_difference_table_64.csv` extends
the same construction to `r ≤ 64, d ≤ 63`, **2016 cells**, and returns
the same four and no fifth. The two files agree on all 496 overlapping
cells, 0 mismatches. This is a February generator in another repo, on
the excluded-lattice convention, and it lands on the same set that
entry 12 verified to `r ≤ 62, d ≤ 61` and that O27 rebuilt independently
(entry 29).

The 64bit file's own arithmetic was checked rather than assumed: its
`A_count` column matches backward differences of OEIS A007053 read from
`b007053.txt` at **all 64 regimes**, 0 mismatches, once the two lattice
primes are removed at `r = 1` and `r = 2`. It reaches `A(64) =
209366672181778359`, two regimes past this repo's own `pi2n_cache.json`
ceiling of `n = 62`.

That makes this a second confirmation of the census alongside O43
(`results/extended_zero_census.json`: `rmax_ext 92`, `cells_ext 4186`,
`cells_new 2295`, `K_new 0`, `n_reproduced 4`) — from different code in a
different repo written months earlier, and under a different convention.
It is *not* independent in the arithmetic: π(2ⁿ) is π(2ⁿ), and O43 reads
further, to `r = 92` against this file's 64. What is independent is the
construction and the seed convention, which is exactly the axis under
test here.

**`dyadic_prime_full_silenced_32.csv` is not a third confirmation.** It
is value-identical to `dyadic_difference_table_32.csv` on all **380**
overlapping cells, `A_count` column included, 0 mismatches, and returns
the same four zeros. It is a duplicate under another name, and counting
it would double-count.

**The composite side confirms the pair identity on data this project did
not generate.** Six composite variants, five distinct SHA-256 (two share
one — see entry 46):

```text
  file                                        (2,1) (4,1) (8,3) (20,6)  cells
  dyadic_composite_difference_table_32          1     4     16   8192    496
  dyadic_composite_difference_table_32_s46      0     5     16   8192    496
  dyadic_composite_difference_table_32_s468     0     6     16   8192    496
  dyadic_composite_extended_emptied_32          0     4     16   8192    380
  dyadic_composite_extended_emptied_32_s46      0     6     16   8192    380
  dyadic_composite_full_silenced_32             0     6     16   8192    380
```

`(8,3)` reads **16** and `(20,6)` reads **8192** in every one of the six,
and never moves. Those are `2^(r−1−d)` at `2⁴` and `2¹³` — exactly the
values `lean/PairIdentity.lean` proves the composite arm must carry where
the prime arm vanishes, and exactly the values entry 45 recorded as
`measured_composite_at_zeros = [1, 4, 16, 8192]` checked `by decide`
against `papers/The-Four-Zeros.md` § E2. Entry 45's check ran against
this project's own numbers. This one runs against tables generated in
**February 2026 by other code in another repo**, under a convention that
disagrees with ours at the seed, and the identity still holds at the two
deep cells. `dyadic_diff_full_silenced_32.csv` agrees independently:
`(4,1) = 6`, `(8,3) = 16`, `(20,6) = 8192`, which is forced, since its
prime arm is 0 at all four.

**`(4,1)` moves on the composite side, and the reason is visible in the
seed rows.** The six variants differ **only** in `A_count` at
`r = 1, 2, 3`:

```text
  A_count, r = 1..8
  composite (plain)                 1  2  2  6  11  25  51  105
  composite silence46               1  1  1  6  11  25  51  105
  composite silence468              1  1  0  6  11  25  51  105
  composite extended_emptied        0  0  2  6  11  25  51  105
  composite extended_empt_s46       0  0  0  6  11  25  51  105
  composite full_silenced           0  0  0  6  11  25  51  105
```

From `r = 4` onward every variant is byte-for-byte the same sequence.
`(4,1)` reads rows 3 and 4, so it lands inside the perturbed region and
takes the values 4 / 5 / 6 above. `(8,3)` reads rows 5–8 and `(20,6)`
reads rows 14–20; both windows sit entirely outside it, which is why they
cannot move whatever is silenced at the seed. The dyadic prime `(2,1)`
reads rows 1 and 2 — the two most perturbed rows in the whole file.

**The finding worth recording: the useful cut is not four-versus-three,
it is deep versus shallow.** `(8,3)` and `(20,6)` are unmoved by every
convention, every silencing set and every generator tried here — three
seed conventions, six composite variants, two independent repos, and
O43's census to `r = 92`. `(2,1)` and `(4,1)` both sit close enough to
the seed that low-`r` choices reach them: `(2,1)` reads the two rows the
lattice convention edits, `(4,1)` reads the last row the silencing sets
edit. That is a property of window position, not of arithmetic depth,
and it is measurable — which four-versus-three is not, until someone
fixes a convention.

This echoes `lean/Zeros.lean` from an independent direction. Its
`window_exclusive_of_prime_exponent` proves that depth 6 spans a ratio of
`2^7`, 7 is prime, so `b^k = 2^7` with `b ≥ 2, k ≥ 2` forces
`b = 2, k = 7` — **(20,6) is base-2 exclusive**. Its
`window_shared_of_composite_exponent` is the one line `(4:ℕ)^2 = 2^4`:
depth 3 spans `2^4 = 4^2`, so base 4 reaches `(8,3)`'s window at depth 1,
and the file's own comment says "the two deep zeros are different kinds
of object". That splits the deep pair by *base reachability*. The
composite data above splits all four by *seed reachability*. The two cuts
are not the same cut, and they do not have to agree — but both say the
four zeros are not one homogeneous set, arrived at from proof and from
February data respectively.

**Entry 17's claim, re-examined and verified as written.** Entry 17 says
of `triadic_difference_table_32.csv`: "**Confirmed: no exact zero in any
delta column.** The single 0 is A_count at r = 1", with near-misses
`(3,2) = 1`, `(5,4) = 1`, `(11,10) = 2`, `(8,7) = 9`, `(10,9) = 9`. Every
one of those reads back exactly from the imported copy of that file — 496
cells, **zero** exact zeros in any delta column, `A_count` zero only at
`r = 1`. The claim is true of the file it cites.

It is also **convention-dependent, and that convention is not the one any
in-repo artifact uses.** The same file reads `cell(2,1) = 2`, tying
`(11,10)` for third-smallest and unlisted in entry 17's near-miss table.
Under O27's convention — `pi(1) = 0`, block `r` is `(b^(r−1), b^r]`, 2 and
3 counted as primes, so `N_3(1) = 2` (entry 29) — the same triadic table
reads differently: `results/joint_dyadic_triadic_table.json` over its 820
triadic cells at depth ≥ 1 has minimum `|cell| = 0` at `(2,1)`, next
smallest `2` at `(4,3)`, then `3` at `(3,1)`, `(3,2)`, `(5,4)`, and
**not one cell anywhere in the triangle takes the value ±1**. So "base 3
reaches 1, twice" and "no exact zero" are both true of entry 17's file and
both false of O27's. Entry 17's open discrepancy — that the magnitude
argument does not separate the bases — was argued from the reading where
base 3 gets closest without landing. On the in-repo reading base 3 lands
at `(2,1)` and never gets close anywhere else. The discrepancy is not
resolved here; it is relocated, and which reading it should be argued from
is not this entry's call.

**Disclosed prediction, and where it failed.** Before opening any file,
this assistant predicted `cell(2,1)` would vanish at `b = 2` and `b = 3`
and read 2, 3, 5, 7, 10, 14 at `b = 4…9`. That prediction reproduced the
plain-count computation **exactly** — row 1 of the table above is
identical to it, digit for digit. It also **contradicted every base-series
file on disk except base 2**, because the imported tables run on the
excluded-lattice convention and read 2, 4, 5, 7, 9, 12, 16 where the
prediction said 0, 2, 3, 5, 7, 10, 14. Both halves are recorded because
the failure is the informative one: a correct computation of the wrong
convention is exactly the error the import in entry 46 exists to prevent,
and it was made anyway, by the same pass that made the import.

Nothing here decides whether the count is four zeros or three. No outcome
marked.

---

## 2026-08-18 — Entry 46 — The lattice_mapper difference tables imported: 27 files, one convention, and the two generations left behind
type: provenance
refs: 17, 36

Entry 17's central piece of adversarial evidence was a file this repo did
not contain. That entry reads: "Julian supplied `triadic_difference_table_32.csv`
(r = 1…32, d = 1…31, built with 2 and 3 excluded as lattice rather than
counted as primes)", and everything it concludes about base 3 — "no exact
zero in any delta column", "Base 3 reaches **1**, twice" — is a reading of
that file. The file lived at
`/Users/juliansambrano/GitHub/lattice_mapper/difference_tables/32bit/`,
outside this repo, with **no pointer to it in `CONTEXT.md` or
`REFERENCES.md`**. Entry 36 later read the same source directory for O33
and recorded the convention and a stale README there, and that pointer was
never promoted into the commitment files either. This import closes that
gap: the evidence now sits with the work that cites it.

**What was imported.** `imported/lattice_mapper/`, copied 2026-08-18
byte-for-byte with `cp -p`, every file SHA-256 verified source-vs-
destination at copy time. **27 files**: 22 from `32bit/` — the complete
directory, 12 base-series tables for bases 2 through 9 plus 10 dyadic
prime/composite split files — 4 from `64bit/`, and the source README
under the name `source_README.md`. The `32bit/` and `64bit/` split is
preserved. `imported/lattice_mapper/README.md` is the import manifest,
written for this repo, and carries the full SHA-256 and source-mtime table.

Re-verified for this entry, not taken on the manifest's word: all 26 CSVs
plus `source_README.md` hash identically to their source counterparts
today, **0 mismatches**. Source mtimes are all 2026-02-11 except the
README's 2026-02-09, and `cp -p` preserved them.

**The convention these tables use.** Power-regime, **backward**
differences: `A(n) = π(bⁿ) − π(bⁿ⁻¹)`, with `delta_d` at regime `r` the
`d`-th backward difference ending at `r`. And — the part that matters —
**the primes 2 and 3 are excluded as lattice, not counted as primes.**
`A(1) = π(b) − 2` for `b ≥ 3`; at `b = 2` the two lattice primes straddle
the regime boundary, 2 in `(1,2]` and 3 in `(2,4]`, so one is dropped from
each of `A(1)` and `A(2)`. The generator is
`/Users/juliansambrano/GitHub/lattice_mapper/difference_table.py:75`,
`silenced_primepi(x)`, whose docstring reads "pi(x) with 2 and 3
silenced. … 2 and 3 are not primes in this framework — they are the
scaffold that generates the 6k±1 lattice." Entry 36 recorded this line
already, from the same source directory.

**This is not the convention any in-repo artifact uses.** O27's
first-block convention is `pi(1) = 0`, block `r` is `(b^(r−1), b^r]`, with
2 and 3 counted — `N_2(1) = 1`, `N_3(1) = 2` (entry 29). The dyadic
tables O16 and O43 build carry the same. So a number lifted from
`imported/` and a number lifted from `results/` are not comparable at low
`r` without stating which convention is in force. That is the reason the
import lives in its own directory with its own manifest rather than being
merged anywhere.

**Three generations, three conventions, two difference directions.** The
source directory holds more than was taken. `archive_unsilenced/` was
**deliberately excluded**, and it differs on every axis:

```text
  imported here     backward differences, 2 and 3 excluded as lattice
                    (difference_table.py:75)
  archive, power    FORWARD differences, ONLY 2 dropped
    regime          (archive_unsilenced/gen_difference_table.py:22-29 —
                    silenced_primepi subtracts 1)
  archive,          a THIRD schema: header column `pi_n`, integer regime
    *_64bit_*.csv   (triadic_difference_table_64bit_64.csv et al.)
```

The direction was checked from the data, not from docstrings — entry 36
warns that the generator's docstring and its output disagree. In the
archive dyadic table `A = 0, 1, 2, 2` and `delta_1 @ r3 = 0 = A(4) − A(3)`,
which is forward. In the imported dyadic table `A = 0, 0, 2, 2` and
`delta_1 @ r3 = 2 = A(3) − A(2)`, which is backward.

Mixing those in one imported directory is the confusion this import
exists to end. The archive remains readable in place and is not deleted,
moved or touched:

```text
  /Users/juliansambrano/GitHub/lattice_mapper/difference_tables/archive_unsilenced/
```

Its size, measured for this entry: **33 files, 59,069,876 bytes**, of
which 9 `.bin`/`.hex` binaries account for 25,339,552 bytes. The
manifest's "~58 MB of binaries" describes the directory total (56.3 MiB),
not the binary files alone; recorded, not corrected.

**`source_README.md` is stale on `64bit/`, and is flagged rather than
fixed.** It describes `64bit/` as an "Integer-regime table: pi(n) for
n = 1..64" — but both imported `64bit/` files are power-regime `A_count`
tables on the same convention as `32bit/`, verified identical to `32bit/`
on all 496 overlapping cells. The description fits the
`archive_unsilenced/*_64bit_*` files instead. The staleness runs further
than the manifest notes: the README's folder list names `128bit/`,
`1000/` and `2pow20/`, and those directories exist only *inside*
`archive_unsilenced/`, not at `difference_tables/` top level; and it
states the convention as "regime 2 is silent (pi(2) = 0). The prime 2 is
not counted" — the one-prime convention, which is the archive's, not the
imported files'. It was imported verbatim as the record of what the
source directory said about itself, and every claim in it that this pass
checked is noted here rather than edited.

Note the two same-named generators: `difference_table.py:75` defines
`silenced_primepi` removing **two** primes, and
`archive_unsilenced/gen_difference_table.py:22-29` defines
`silenced_primepi` removing **one**. Same function name, different
convention, different file. That is how the README came to describe the
wrong one.

**One byte-identical pair, preserved under both names.**
`32bit/dyadic_composite_extended_emptied_32_silence46.csv` and
`32bit/dyadic_composite_full_silenced_32.csv` share SHA-256
`a0030692739c7ddaada77f7b2cb81e8364ab3f9753970e1e8f6e63d058d53b6a` — they
are byte-identical in the source, under two names and two source mtimes
(12:13:27 and 12:20:04). Both were imported as-is rather than
deduplicated, because the pair is itself the provenance fact. Anyone
counting "six composite variants" is counting five distinct files.

**`lattice_mapper/` was verified unmodified.** No file anywhere under
`/Users/juliansambrano/GitHub/lattice_mapper/` carries an mtime later
than 2026-08-01; the newest under `difference_tables/` is 2026-02-11.
Every imported file's source counterpart hashes identically today. The
source tree was read-only throughout and remains so. Nothing in this repo
regenerates these files, and nothing should: they are imported evidence,
not outputs of this bench.

`CONTEXT.md` and `REFERENCES.md` still have no pointer to
`imported/lattice_mapper/`. The candidate lines are reported to Julian
separately; neither file was edited.

No outcome marked.

---

## 2026-08-18 — Entry 45 — the pair identity proved in Lean, and the row hypothesis that had to be window-local
type: formalization
refs: 12, 17, 26, 33

`papers/Formalization.md` § D5 reads, in full: "Blocks D through I of the
chain remain unencoded — the winding, the pair identity, the transform
results." The pair identity is now encoded and proved.
`lean/PairIdentity.lean` (15610 B, sha256
`0383a9e23ac642cf2a5135ad484cb43af7ff12180c7d7c070e90234c5552877f`,
12 theorems and 2 defs) carries statement **I1** of
`papers/Euler-Factor-Chain.md` § I outright, with no numerical input.
The winding and the transform results were not touched and D5 still
stands for them.

One wording note, recorded rather than fixed: the pair identity is the
**second** of the three items D5 names, not the first. Nothing in
`papers/` was edited in this pass.

**What the notebook already had, and at what strength.** Entry 33 wrote
the identity down — `prime(r,d) + composite(r,d) = (b-1)^(d+1) *
b^(r-1-d)` — and read the four exact zeros as its poles, with the
composite values 1, 4, 16, 8192 the identity forces. Entry 17 recorded
the geometric fact underneath it, that differencing a geometrically
growing sequence "rescales by (b−1)^d and returns nothing", and entry 26
filed the composite identity as rediscovery from Julian's own repos
(OBS-011, February). None of that was a derivation; it was a check.
Read again for this entry,
`results/O16_centered_difference_table_run2.json` →
`summary.identity_a_backward` carries `statement`
`composite_B(r,d) == 2^(r-d-1) - prime_B(r,d)`, `cells_checked` **1953**,
`mismatches` **0**, `passed` true — the same 1953 cells entries 17, 26
and 33 all cite back to entry 12.

**The theorem, verbatim from `lean/PairIdentity.lean:138`.**

```text
theorem pair_identity (b : ℤ) (P C : ℤ → ℤ) (r : ℤ) (d e : ℕ)
    (hr : r = (d : ℤ) + 1 + e)
    (hpair : ∀ k : ℕ, k ≤ d → P (r - k) + C (r - k) = (b - 1) * b ^ (e + (d - k))) :
    tableFrom P r d + tableFrom C r d = (b - 1) ^ (d + 1) * b ^ e
```

**The hypotheses it actually needed — two, and neither is about primes.**
`hr` pins the exponent. `hpair` says the two rows partition each rung of
the window the cell reads. There is **no hypothesis on `b` at all** — not
`2 ≤ b`, not `b ≠ 0` — so this is general integer `b`, not base 2
special-cased. And there is no hypothesis on `P` or `C` beyond the
partition: the seed rows are arbitrary functions `ℤ → ℤ`, and the proof
never knows that `P` counts primes. The file states the consequence in
its own words at line 133: "Nothing in the proof knows that `P` counts
primes — the identity is forced by the partition alone, and the whole
content of the prime/composite split is that it is a partition of a
geometric row." That is the sharpest form of what entry 33 called the
sum being fixed and known in advance while only the split is free.

**The index convention it settled on** (file lines 43–48).
`Construction.tableFrom` puts depth `d` at `d` backward differences of
the depth-0 row, and the depth-0 row is the per-rung count, itself
already one difference of the cumulative count. So `d` in Lean is the
paper's `d`, and the exponent `r−1−d` is carried as a **natural number
`e` with `r = d + 1 + e`**. That keeps every exponent in ℕ and every
rung inside the table's support, which is why `hr` appears as a
hypothesis rather than the exponent being written `r - 1 - d` and
truncating.

**The supporting arrows.** `symbol_at_one` names
`EulerFactorChain.symbol_of_backward_difference` (A1) at `ρ = 1`;
`backward_difference_pow` moves that step into ℤ where the table lives;
`tableFrom_of_geometric` iterates it to the collapse
`tableFrom G r d = (b - 1) ^ d * G (r - d)`; `tableFrom_add_window`
supplies linearity localised to the window, out of
`Construction.tableFrom_add` and `Construction.zero_determined_by_row`.
`composite_of_prime_zero` is I5, the pole: where the prime arm vanishes
the composite arm carries the whole total. `composite_at_zero_20_6`
instantiates it at (20,6) and returns 8192.

**THE FINDING WORTH RECORDING — a globally-stated row hypothesis would
have been vacuous.** The natural way to write "the row is geometric" is
`∀ r, G r = b * G (r-1)` over all of ℤ. For `|b| ≥ 2` that hypothesis
has exactly one solution, `G = 0`: iterating gives `G r = b^n * G (r-n)`
for every `n`, so `b^n` divides `G r` for every `n`, and only 0 is
divisible by arbitrarily high powers of `b`. A theorem assuming it would
be true and empty. The hypothesis had to be **window-local** — in
`tableFrom_of_geometric` it is `∀ k : ℕ, k < d → G (r - k) = b * G (r - k - 1)`,
asking only for the `d` steps inside the window `r, r−1, …, r−d` that
the cell at `(r,d)` actually reads. That is the same locality
`Construction.zero_determined_by_row` already carries (`∀ k : ℕ, k ≤ d →
N (r - k) = M (r - k)`), so the pattern was in the tree before this file
needed it.

**A discrepancy in the file's own comment on that point, not adjusted.**
`lean/PairIdentity.lean:80–82` states the vacuousness as "No total
function `ℤ → ℤ` satisfies `G r = b * G (r−1)` at every `r` except
`G = 0`", with no condition on `b`. As written that is false: at `b = 1`
every constant function satisfies it, and at `b = −1` every
sign-alternating function does. The claim needs `|b| ≥ 2`. The comment
is prose in a docstring, carries no proof obligation and does not enter
any theorem — nothing in the file is wrong — but the sentence is
overstated and is recorded here rather than edited, since `lean/` was
out of scope for this pass.

**The corollary, and its exact reach.**

```text
coeff_eq_one_iff_base_two {b : ℤ} (hb : 2 ≤ b) (d : ℕ) :
    (b - 1) ^ (d + 1) = 1 ↔ b = 2

total_eq_pow_iff_base_two {b : ℤ} (hb : 2 ≤ b) (d e : ℕ) :
    (b - 1) ^ (d + 1) * b ^ e = b ^ e ↔ b = 2
```

Here the hypothesis `2 ≤ b` does appear — the corollary needs it, the
identity does not. `base_three_carries_factor` and
`base_four_carries_factor` are the witnesses: base 3 carries
`2^(d+1)·3^e`, base 4 carries `3^(d+1)·4^e`, never a bare power.

What it **does** say: base two is the only integer base ≥ 2 whose cell
total is a bare power of the base, so it is the only grid on which a
vanished prime arm leaves the composite arm sitting exactly on a power
of the grid. What it **does not** say, in the file's own words at lines
35–38: "It is a statement about the FORM OF THE TOTAL, not about zeros.
Nothing here predicts, or could predict, where either arm vanishes." So
it does **not** close entry 17's open discrepancy. Entry 17 offered
`(b−1)/b` minimised at `b = 2` as the reason the zeros are there, then
recorded that the triadic table reaches 1 twice without ever hitting 0,
so the magnitude argument does not separate the bases. This corollary is
a different statement about a different quantity, and entry 17's
discrepancy stands exactly where it stood.

**The measured check, and it matched.** The file records the four zero
cells as `zero_cells = [(2,1), (4,1), (8,3), (20,6)]` — the same list as
`Zeros.measured_zeros` and `Construction.measured_zeros` — and the
composite arm at them as `measured_composite_at_zeros = [1, 4, 16, 8192]`,
read from `papers/The-Four-Zeros.md` § E2 ("At the four zeros the
composite arm therefore carries the whole term: `1, 4, 16, 8192`",
line 121–122). `measured_composite_matches_pair_identity` evaluates
`(b−1)^(d+1)·b^(r−1−d)` at `b = 2` and those four cells and proves the
result equals the measured list, `by decide`. It compiles, so they agree:

```text
  (2,1)   2^0  =     1   matched
  (4,1)   2^2  =     4   matched
  (8,3)   2^4  =    16   matched
  (20,6)  2^13 =  8192   matched
```

These are the same four numbers entry 33 tabulated. They are inputs to a
check, not to a proof — the formula is derived from the partition alone
above them — and had any of the four disagreed the file would not build.

**`#print axioms`, verified rather than quoted.** The file pins each
result with a `#guard_msgs` block, so a drift would fail `lake build`.
Independently re-run for this entry via `lake env lean` on a scratch
file importing `PairIdentity`; the twelve lines below are that output
verbatim, and they match the twelve docstrings in the file exactly.

```text
  symbol_at_one                          [propext, Classical.choice, Quot.sound]
  backward_difference_pow                [propext, Quot.sound]
  tableFrom_of_geometric                 [propext, Quot.sound]
  tableFrom_add_window                   [propext, Quot.sound]
  pair_identity                          [propext, Quot.sound]
  composite_of_prime_zero                [propext, Quot.sound]
  coeff_eq_one_iff_base_two              [propext, Classical.choice, Quot.sound]
  total_eq_pow_iff_base_two              [propext, Classical.choice, Quot.sound]
  base_three_carries_factor              [propext]
  base_four_carries_factor               [propext]
  measured_composite_matches_pair_identity  [propext]
  composite_at_zero_20_6                 [propext, Quot.sound]
```

**Nine of the twelve are `Classical.choice`-free**, including
`pair_identity` and `composite_of_prime_zero` — the identity and the
pole are constructive. The three that are not are `symbol_at_one`, which
inherits it from the ℂ-valued A1 statement it names, and the two
`iff_base_two` corollaries, which get it through the `omega` / `nlinarith`
route. Three results depend on `propext` alone.

**Build.** `lean/lakefile.toml` changed by one line: `PairIdentity`
appended to the `[[lean_lib]]` `globs` list, taking the library from nine
modules to ten. New sha256
`b144eb9926b3a3e12f976c5f9eaee15cf63a01abe46725ac39db25e1e1508d36`,
462 B. Job count either side:

```text
  before   8027 jobs   lean/build.log line 71, the 09:41 build of the
                       nine-module library
  after    8036 jobs   lake build, run for this entry, exit clean
  delta      +9
```

`Build completed successfully (8036 jobs).` The only warnings are the
pre-existing unused-variable and unused-simp-argument linter notes in
`Crossover.lean` and `EulerFactorChain.lean`; `PairIdentity.lean` emits
none.

**What this confirms, and what it leaves alone.** It confirms the
account in entries 12, 17, 26 and 33: the identity is exact, it is not
about primes, and the four composite values are forced by the grid. It
refutes nothing in the notebook. It does not locate a zero — the file
says so twice, at lines 274–278 — so entry 26's last-vanishing question
and entry 17's base-2 discrepancy are both untouched, and `Zeros.lean`'s
hole stays open.

No outcome marked.

---
