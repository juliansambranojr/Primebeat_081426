# Prereg format

The pattern established by `alpha_depth_trend_v1_locked_20260814.md` is the
house standard. Read this before writing or locking one.

## What earns a verdict

A test earns a verdict only if, **before the run**:

1. H0 and H1 are stated, with a predicted direction under H1.
2. Every parameter is locked in a table (no `--seed` flags added later).
3. The decision rule names its verdict labels verbatim, including a
   `compromised` branch and a precedence order. `compromised` is the
   integrity branch: the run executed but the data is corrupt *for
   reasons unrelated to the hypothesis*, so no verdict is earned —
   `alpha_depth_trend_v1_locked_20260814.md:103-107` states both its
   trigger conditions and that reading. Precedence puts it first, ahead
   of every substantive label, with the did-not-discriminate outcome
   last: `compromised > depth_dependent > depth_independent >
   ambiguous` (same file, `:109-110`). Further worked triggers —
   recomputation disagreeing with frozen values, too few blocks, a
   control firing a criterion a theorem forbids — are in
   `dh_aggregate_spectrum_v1_20260825.md:104-106`,
   `character_sweep_q11_q13_v1_20260826.md:124-126` and
   `multibase_synthesis_v1_20260827.md:83-86`.
4. A vacuousness check states that the criterion has a realistic chance
   of firing in both directions. Where the decision rule reads against a
   null distribution, "realistic chance" is stated as measured **power**:
   the probability the rule fires at a named effect size, computed
   *before* the lock, on data that cannot reach the blind arm —
   synthetics, placebo windows, or an already-unblinded parameter.
   A design of unknown power cannot tell "no effect" from "could not
   have seen one", which is what a `null` verdict then fails to mean.
   Worked examples: `dh_aggregate_spectrum_v1_20260825.md` § Power,
   `dense_boundary_scan_v1_20260827.md` § Power.
   A census or a deterministic reconstruction has no null and needs no
   power — `extended_zero_census_v1_locked_20260818.md` and
   `floor_reconstruction_v1_20260828.md` are the shape this exempts;
   the vacuousness check stands alone there.
5. Provenance is disclosed: which data has already been inspected by
   Julian or an assistant, and which arm is blind. A **blind arm** is a
   parameter range or data slice never fitted, inspected or tuned
   before the lock, so the decision rule meets it out of sample. The
   worked case is again the house standard:
   `alpha_depth_trend_v1_locked_20260814.md:59` locks
   `depths (secondary, blind) = 13-18` with the reason "Never fitted.
   The only out-of-sample arm", `:50` says so in prose, and `:92` shows
   the rule consuming it. A prereg with no blind arm says so — it is a
   disclosure, not a requirement.

After the run, the Run record gets `run_start_at`, `run_end_at`, `verdict`,
`post_compute_sha256`, and a sidecar match statement. **The verdict line is
Julian's to write.** An agent may compute the SHA and report the decision
rule's mechanical output; it does not stamp the verdict.

## Prereg file naming and status

A prereg's filename carries no status. Name it
`preregs/<slug>_v<N>_<YYYYMMDD>.md` at creation and never rename it.
Scripts, results JSONs, and notebook entries cite that path from the
moment they are written; a rename strands every one of them.

Status lives in two places instead:

- the `STATUS:` block inside the file, reading `DRAFT` or `LOCKED`
- the presence of a sidecar `preregs/<same-basename>.sha256`, which
  exists only once locked

The sidecar is the authority. A prereg with one is locked; a prereg
without one is not, whatever its STATUS block says — the sidecar is
the thing that pins the text, so it is what a later reader should
trust.

## Lock, commit, then run

**The Run record mutates the file the sidecar pins.** Those two rules
conflict, and the conflict is not cosmetic: on disk, no sidecar in this
directory matches its own prereg. Unless the locked text was committed
*before* the Run record was filled, the text the sidecar pins exists
nowhere and the anti-drift guarantee cannot be checked in either
direction.

So the order is **lock the text, commit it, then run.** A committed
pre-image is what makes the sidecar verifiable afterwards.

`utilities/check_sidecar.py` implements the recovery. A sidecar
verifies if any of these hashes to it: the file as-is; the file
truncated immediately before its `## Run record` heading; any blob of
the file in git history; or any such blob truncated the same way.

Audited 2026-08-27 (notes entry 220): **five of nine verify, four do
not.** The four were edited in place after locking rather than only
appended to. They are listed with their reasons in
`utilities/sidecar_baseline.txt` and print as KNOWN, never as PASS —
for those four the sidecar's promise cannot be checked, which is
recorded because three of them carry stamped verdicts.

The three preregs named before this convention keep their names:
alpha_depth_trend_v1_locked_20260814.md,
zero_winding_phase_v1_locked_20260818.md, and
extended_zero_census_v1_locked_20260818.md.
