# Prereg format

The pattern established by `alpha_depth_trend_v1_locked_20260814.md` is the
house standard. Read this before writing or locking one.

## What earns a verdict

A test earns a verdict only if, **before the run**:

1. H0 and H1 are stated, with a predicted direction under H1.
2. Every parameter is locked in a table (no `--seed` flags added later).
3. The decision rule names its verdict labels verbatim, including a
   `compromised` branch and a precedence order.
4. A vacuousness check states that the criterion has a realistic chance
   of firing in both directions.
5. Provenance is disclosed: which data has already been inspected by
   Julian or an assistant, and which arm is blind.

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
