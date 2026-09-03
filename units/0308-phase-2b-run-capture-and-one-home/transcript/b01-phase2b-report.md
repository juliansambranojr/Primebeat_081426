# Transcript block b01 — agent a0a8bf60ac645202f, role build

Unit 0308. Spawned `general-purpose`, described `Finish phase 2b`. This is
that agent's FINAL REPORT, copied verbatim out of
`~/.claude/projects/<project>/<session>/subagents/agent-a0a8bf60ac645202f.jsonl`,
its last message. Nothing below is edited, summarised or reordered; the
design's § Transcript is king is why it is here at all — the report reaches
a reader through one generation step with no witness, and this file is the
witness.

---

Committed `ccd44f0`, pushed to `main`, CI green (`audit`, success, 13s).

## The interrupted work

Read all of it against the design and reproduced every claim it made. Kept `lab/exempt.py`, `lab/check.py`, `lab/__init__.py`, `lab/cli.py`, `tests/test_phase2.py`, `lab/run.py` and both fixtures — A1, A2 and A3 reproduce exactly as their docstrings record (verified below). Discarded one figure: `lab/check.py` said "157 are strings". Finished four things it had not: the stale wiring paragraph in `utilities/check_units.py`, the whole of Part C, prose for `units/0003-run-smoke/unit.md`, and `tests/test_phase2b.py` — which `lab/run.py`'s docstring already cited as existing and which did not.

## A1 — reproduction and audit

```
prose  "U1 Ψ closed form against 8000-node Gauss–Legendre quadrature"
  BEFORE scanned: []            AFTER scanned: ['8000']
prose  "the 24000-point values agree to 1e-4 relative"
  BEFORE scanned: ['1e-4']      AFTER scanned: ['24000', '1e-4']

entry 302  BEFORE 1301 tokens, 416 exempt (32.0%), 885 scanned
entry 302  AFTER  1301 tokens, 414 exempt (31.8%), 887 scanned
entry 304  BEFORE  331 tokens, 248 exempt (74.9%),  83 scanned
entry 304  AFTER   331 tokens, 248 exempt (74.9%),  83 scanned
```

All twelve, by recomputing spans with each class removed to find tokens whose exemption depends on it alone:

| class | matches | load-bearing | a token it exempts and should not |
| --- | --- | --- | --- |
| date | 26 | 37 | none — ISO dates and a `-0700` offset |
| unit-path | 0 | 0 | none, now. It was `8000` and `24000`; both are counts |
| unit-or-entry-ref | 26 | 27 | none — `entry 301`, `entries 257–271` |
| refs-list | 2 | 8 | none — the two front-matter `refs:` lines |
| hex | 13 | 2 | none — `47` of `47fa486..origin/main` |
| version | 0 | 0 | none — matches nothing in either entry |
| file-cite | 55 | 0 | none — every match also inside a `code-span` |
| list-marker | 0 | 0 | none — matches nothing in either entry |
| enumerator | 9 | 9 | none — `(1)`…`(5)` opening numbered points |
| ident-digits | 232 | 84 | none — `L2`, `U8`, `sha256`, `h10`, `m22`, `eq_13`, `right_6000` |
| code-span | 315 | 196 | none — 245 distinct spans hold a number, every one a key, path or `file:NN` |
| named-ref | 21 | 19 | none — `Section 0`, `Theorem 1.4`, `lines 15–22` |

No second false exemption exists in this corpus. The `code-span` audit is the one worth naming: I listed all 245 distinct spans containing a digit and every one is `theory.k=10|eps=0.01.…`-shaped or a path — the counter `` `3.07` `` (a span with no letter or colon) is what keeps a bare value out.

## A2 — decision and cost

Kept the interrupted agent's decision to admit numbers parsed out of string values, and it is now demonstrated in a committed unit rather than a scratch table. `units/0003-run-smoke`'s `ladder.json` states its reach condition as text, so 4.92 exists in that unit only inside a string — the same shape as entry 304's `consumers[0].t_req_expr`:

```
BEFORE (numbers-only pool)  exit 1
UNMATCHED  4.92   § What the string-value widening buys …  |  … the constant 4.92 exists in this unit
units/0003-run-smoke: 4 in prose, 3 matched, 1 unmatched (6 exempt); 24 key(s), 5 numeric
AFTER  (Phase 2b pool)      exit 0
units/0003-run-smoke: 4 in prose, 4 matched, 0 unmatched (6 exempt); 24 key(s), 5 numeric +1 in strings
```

Cost, from `rates --exact`: eleven values added to the 431-value pool and 48 to the 4285-value one, moving the false-accept rate by at most 0.1 percentage points and not at all on the larger pool's integer column. The exemption list is applied inside the string, so a timestamp there contributes nothing.

## A3 — the numbers that changed

```
$ python3 -m lab.exempt rates --exact analysis/2026-09-02/results/arrow_price.numbers \
      analysis/2026-09-01/results/weil_Lc_theory.numbers units/0000-smoke/values.tsv
EXACT -- every [1, 3]-decimal value in [0, 1000), no draw
pool                                                  values       int        1p        3p
analysis/2026-09-02/results/arrow_price.numbers          431    6.000%    1.400%    0.030%
  + numbers inside string values                         442    6.100%    1.430%    0.031%
analysis/2026-09-01/results/weil_Lc_theory.numbers      4285    7.700%    2.640%    0.166%
  + numbers inside string values                        4333    7.700%    2.650%    0.167%
units/0000-smoke/values.tsv                                4    0.500%    0.040%    0.000%
```

`--seed 20260902` without `--exact` also reproduces byte-for-byte. Three figures moved from the unseeded original: the decimal columns went 1.5%/3.4%/0.1%/0.4% → 1.4%/2.64%/0.03%/0.166%. The integer column is unmoved, because it was never a draw. One claim was wrong rather than imprecise: "an integer check is 15–60× weaker" came from the noisy column; the exact ratios are 46× and 200×.

**A fourth correction, mine.** `lab/check.py` said "157 are strings" and entry 307 says the same. 157 is the count of lines that do not parse as a number — 99 strings plus 42 `false`, 11 `true`, 5 `null`. The file has 769 keys, 612 numeric lines, 431 distinct numeric values, 99 strings, 81 of those holding digits. The docstring now carries the correction and the one-line command that prints `769 612 99`. Entry 307 is Julian's and I left it alone.

## `lab run`

Declaration: `run/run.sh`, invoked `/bin/sh -e run.sh` with cwd `run/`. Chosen over "the single `*.py`" (breaks on a script plus a helper, and cannot hold the flags) and a front-matter key (puts the declaration outside `run/`, which the design says is self-contained). The `-e` was found by the verification, not designed in: without it a crashed python left `sh` returning the last `echo`'s status, so `lab run` reported exit 0 and regenerated values.tsv from a failed run.

Provenance lives in `run/lab_run.<NNN>.json` beside `run/lab_run.<NNN>.log`, sharing an index that is the lowest for which neither exists. It is a JSON under `run/` so `lab values` folds it into `values.tsv` and a claim about the run has evidence — and every field but the exit code and wall time is written in an address shape (`v3.14.3`, `…Z`, hex), so the record contributes exactly two numbers to the pool. Verified on the fixtures:

```
$ lab run units/0003-run-smoke
computing the ladder ratio / wrote ladder.json
LOG    units/0003-run-smoke/run/lab_run.001.log
RECORD units/0003-run-smoke/run/lab_run.001.json
units/0003-run-smoke: exit 0 after 0.023s; values.tsv regenerated, 24 key(s)

$ lab run units/0004-run-fails                 → EXIT 1, "values.tsv is unchanged",
    log holds the traceback, record holds exit_code 1, "never reached" absent
$ lab run units/0002-smoke-sealed              → EXIT 1, REFUSED … supersedes: [0002]
$ lab run analysis/2026-09-02                  → EXIT 2, "refuses to execute anything outside a unit"
$ lab run units/0001-smoke-clean               → EXIT 1, "no run/run.sh"
second run                                     → lab_run.002.*, 001 byte-identical
```

`check_direct_run.py` does **not** cover in-repo execution. Its `DIRECT` regex fires only on an interpreter invoked, at the start of a command or after `; & |`, on a bare root-level filename matching `(O|0|t)\w*\.py` — so `python3 analysis/2026-09-02/arrow_price.py` passes, as does any script under a directory, any name outside that prefix set, `sh run.sh`, `./script.py`, and anything with `--no-json` or `PB_DIRECT=1`. Routing it through `lab run` would take: widening the pattern to any runnable path in the repo; replacing the `utilities/run.py` message with `lab new <slug>` / `lab run <unit>`; and retiring the `--no-json` escape, which no longer means anything, since `lab run` always writes a log and a record. `lab run`'s own child process is not a Bash tool call, so it needs no allowance. I did not edit the file.

## The one-home rule

In `utilities/check_units.py` as rule 3, tested through `GIT_INDEX_FILE=<scratch>/probe.index` with `git read-tree HEAD`, no commit created and the real index untouched:

```
A  results/one_home_probe.json                        → EXIT 1
   -- A result written from here on lives inside a unit --
      NEW  results/one_home_probe.json
      results/ and analysis/**/results/ are frozen: what they already hold stays…
      Put it in a unit instead:  lab new <slug> / lab run <unit>
M  analysis/2026-09-02/results/arrow_price.txt        → EXIT 0
A  analysis/2026-09-02/results/one_home_probe.txt     → EXIT 1
```

The test is `git cat-file -e HEAD:<path>`, not the status letter — a rename into `results/` reports `R` while being a new path in the frozen tree. It asks nothing about how the file got there. It runs before the `lab` probe, so it holds in a checkout without the program installed. `analysis/2026-09-02/lab_design.md` gained § One home for a result and a `2b` phase-table row; the five sections added at 408de2a are untouched.

## Gates

`python3 -m pytest -q` → 202 passed. `bash utilities/hooks/pre-commit` with nothing staged → exit 0; with the phase staged → exit 0, both new units OK. `python3 utilities/check_refs.py` → exit 0, run alone.

## Two things to flag

**A Syncthing conflict landed on a write-guarded hook during this session.** `utilities/hooks/check_direct_run.py` is modified in the working tree — reverted to a version without the slice-warning check — and `utilities/hooks/check_direct_run.sync-conflict-20260902-230134-GS4IH4M.py` sits beside it. Neither is mine and neither is staged or committed. HEAD still holds the full version; `git checkout -- utilities/hooks/check_direct_run.py` restores it, from your terminal.

**Where the design was silent.** It gives `lab run` one line and settles nothing about the declaration mechanism, where provenance lives, whether a failed run regenerates values, or what happens on a second run — all four are recorded as decisions in `lab/run.py`'s docstring. It also says nothing about a result arriving outside a unit by any route other than a run, which is the gap § One home for a result now fills.

That is a result with a dated record — log it as a notebook entry?
