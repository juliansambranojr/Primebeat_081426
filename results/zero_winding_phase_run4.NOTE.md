# zero_winding_phase_run4.json — redundant reproduction, not a run of record

Produced 2026-08-20T23:54:38Z–23:54:39Z on a **false premise**.

The assistant reported that O42's Run record was unfilled. It was not. The
prereg contains a blank *template* Run record at line 310 and the real one at
line 322, and a `grep -m1` returned the template. Julian had already written
the verdict on 2026-08-18 in commit `3616b05`:

    run_start_at 2026-08-18T22:36:26Z, run_end_at 2026-08-18T22:36:27Z,
    verdict `no_constant_angle`, post_compute_sha256 b0101319…, sidecar
    match yes.

**O42 is closed. This file changes nothing.**

It is kept rather than deleted because `CLAUDE.md` § Permissions forbids
deleting `results/*.json`. It is a fourth reproduction of a result already
recorded, run with the locked parameters, and it agrees:
`no_constant_angle`, no `compromised` condition, matching runs 1, 2 and 3.

Do not cite this file. Cite `results/zero_winding_phase_run3.json` and the
Run record in `preregs/zero_winding_phase_v1_locked_20260818.md`.
