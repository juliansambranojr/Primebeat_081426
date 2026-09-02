# Container audit report — 2026-09-02

Executes `container_audit.md` (committed 33df8ca). One section per § of
that checklist. Each item: what was checked · the command · what it
printed · match or finding.

Two scope amendments applied, both Julian's, both recorded here:

- **Ordering.** §5 ran first while other agents were writing entries
  302/303 and hooks under `utilities/hooks/`. §1–§4 and §6 then ran
  against whatever entries existed.
- **§5.3, §5.4, §5.5 not run — Julian's call, 2026-09-02.** No clean
  clone was made and no analysis script was rerun. §5.1 and §5.2 were
  done as a record check only. What this leaves untested is stated in
  §5.3 below.

Numbers below are cited by `.numbers` key or `file:line`. The
`.numbers` files are the ones committed at 33df8ca; every one was
verified against its JSON (§4).

## 0. Orientation

Read in order: `AGENT_CARD.md`, `/Users/juliansambrano/GitHub/AGENT_CLAUDE.md`,
`CLAUDE.md` (loaded as project instructions), `container_audit.md`,
`notes/notes_format.md`, the header of `notes/NOTEPAD.md`
(`notes/NOTEPAD.md:1-16`), and the docstrings of
`utilities/flatten_results.py:1-37` and
`utilities/check_entry_numbers.py:1-27`.

No commitment file was edited. No commit, no `git add`, no
`git config`. Nothing under `notes/` or `utilities/hooks/` was touched.
Two writes were made, both authorised by §2 of the checklist and
recorded under §2 below.

## 1. Locate the entries

**Checked** — one `##` heading per entry 298–303.

```text
grep -n '^## .*Entry 29[89]\|^## .*Entry 30[0-3]' notes/lab_notebook_2.md
```

printed four headings, one each for 301, 300, 299, 298:

```text
19:  ## 2026-09-02 — Entry 301 — weil_Lc_mod.py: …
264: ## 2026-09-02 — Entry 300 — weil_Lc_height.py: …
558: ## 2026-09-02 — Entry 299 — weil_Lc_eps.py: …
772: ## 2026-09-01 — Entry 298 — weil_rung_min.py: …
```

**Finding (expected, per the ordering amendment).** Entries 302 and 303
have zero matches. `python3 utilities/check_refs.py` printed
`notebook: 300 entries, newest 301 (2026-09-02), next 302` on every
poll from the start of the audit through its end. §1–§4 and §6 below
are therefore audits of entries 298–301 only. The checklist's §4.3
asks for spot checks on "entries 301 and 302"; entry 300 was
substituted for the absent 302.

Every entry read in full. Citations extracted per entry (script over
the entry bodies, `\b[0-9a-f]{64}\b` for hashes):

```text
entry 298  sha256: none
entry 299  sha256: none
entry 300  sha256: 268256e5…, 547e2dd3…, bb931efe…
entry 301  sha256: c2717f26…, cb2811de…
```

## 2. Tree completeness

**Checked** — every file cited by entries 298–301, by `stat -f %z`.
All present, all non-zero except the one known case:

```text
     39170  analysis/2026-09-01/weil_rung_min.py
     17141  analysis/2026-09-01/weil_rung_min.txt
    710508  analysis/2026-09-01/results/weil_rung_min.json
     29745  analysis/2026-09-01/results/weil_rung_min.log
     23634  analysis/2026-09-01/weil_QX.py
     78740  analysis/2026-09-01/results/weil_QX.json
      3658  analysis/2026-09-01/results/weil_QX.txt
     45533  analysis/2026-09-01/weil_Lc_eps.py
     21240  analysis/2026-09-01/weil_Lc_eps.txt
    596874  analysis/2026-09-01/results/weil_Lc_eps.json
     24176  analysis/2026-09-01/results/weil_Lc_eps.log
     36447  analysis/2026-09-01/weil_Lc_height.py
     73224  analysis/2026-09-01/weil_Lc_height.txt
     10701  analysis/2026-09-01/weil_Lc_height_eps0.txt
   2403163  analysis/2026-09-01/results/weil_Lc_height.json
     74798  analysis/2026-09-01/results/weil_Lc_height.log
         0  analysis/2026-09-01/results/weil_Lc_height_M96.log
    295274  analysis/2026-09-01/results/weil_Lc_height_eps0.json
     13182  analysis/2026-09-01/results/weil_Lc_height_eps0.log
     52358  analysis/2026-09-01/weil_Lc_mod.py
     67733  analysis/2026-09-01/weil_Lc_mod.txt
   1547190  analysis/2026-09-01/results/weil_Lc_mod.json
     77356  analysis/2026-09-01/results/weil_Lc_mod.log
   1800000  imported/twin_count/zeros1.txt
```

**Match.** `weil_Lc_height_M96.log` at 0 bytes is the expected case;
`notes/lab_notebook_2.md:517-520` records why (a `tee` that truncated
the file when the rerun was killed). Nothing else is 0 bytes.
`weil_Lc_mod.json` at 1,547,190 bytes matches entry 301's stated size
(`notes/lab_notebook_2.md:65`).

**Checked** — `analysis/2026-09-01/scratch/README.md` lists exactly the
files present.

```text
comm -3 <(ls analysis/2026-09-01/scratch/ | grep -v '^README.md$' | sort) \
        <(grep -o '^| `[^`]*`' analysis/2026-09-01/scratch/README.md | sed 's/^| `//;s/`$//' | sort)
```

printed nothing before the copy below. **Match** — the README's table
and the directory agreed file for file.

**Checked** — the hard-coded scratchpad path in the two scripts that
carry one.

```text
grep -n 'sys.path' analysis/2026-09-01/scratch/final.py analysis/2026-09-01/scratch/sens.py
```

printed, for both files at line 2:

```text
sys.path.insert(0,'/private/tmp/claude-501/-Users-juliansambrano-GitHub-Primebeat-081426/e0529930-f9ed-407f-aa48-0dd5f402f85a/scratchpad')
```

**Finding.** That directory exists today — it is this session's own
scratchpad — and it does contain `rebuild_census_price.py`. It is a
`/private/tmp` path keyed to a session UUID, so it will not exist for a
later reader. `analysis/2026-09-01/scratch/README.md:19-21` already
says to run those two from the scratch directory instead. Not fixed;
reported.

**Checked** — session scratchpad leftovers named in §2 of the
checklist. `ls` of the scratchpad found all of them present:

```text
xcheck_k1.py    2726 bytes   2026-09-02 10:11:37
mod_smoke.json 59568 bytes   2026-09-02 10:10:30
mod_smoke.txt  11895 bytes   2026-09-02 10:10:30
mod_smoke2.json 54983 bytes  2026-09-02 10:13:37
mod_smoke2.txt   4850 bytes  2026-09-02 10:13:37
```

**Action taken, as §2 instructs.** All five copied with `cp -p` into
`analysis/2026-09-01/scratch/` (mtimes preserved) and five rows added
to `analysis/2026-09-01/scratch/README.md`. They are untracked; not
committed. `xcheck_k1.py` is the cross-check entry 301 describes at
`notes/lab_notebook_2.md:210-216` as being "in the session scratchpad,
in no tree file" — it is now in the tree. It reads
`ladder["k=1|eps=0.01|M=16|w=1/2"]` from a `mod_smoke.json` in the
directory passed as `sys.argv[1]` (`xcheck_k1.py:9-11`), so it needs
`mod_smoke.json` beside it, which is why that file came too.

## 3. Hash fidelity

**Checked** — every sha256 recorded in entries 299–301, against
`shasum -a 256`.

| entry | what | recorded | computed | result |
| --- | --- | --- | --- | --- |
| 300 | `analysis/2026-09-01/weil_Lc_height.py` on disk (`:528`) | `bb931efe28bbc66f1fe0e67e4e5daf00aeb827d78024b8f101342f4ed308aa68` | same | match |
| 300 | main-run `params.code_version` (`:526`) | `268256e5c220a1c170f12ac400d88738c6eff482249100d01e1d6e983842ba04` | same field in `weil_Lc_height.json` | match |
| 300 | ε=0 control `params.code_version` (`:527`) | `547e2dd307fd45712c498d644e44c1cd3e7b0441e76063088204fcf632ba18dd` | same field in `weil_Lc_height_eps0.json` | match |
| 301 | `analysis/2026-09-01/results/weil_Lc_mod.json` (`:67`) | `c2717f263ef7cb1435942ecddeb701ad7f9dd0f88ba6d02e34d1e031c64ff1bf` | same | match |
| 301 | `analysis/2026-09-01/weil_Lc_mod.py` (`:72`) | `cb2811deb2dcbee5586f0d6fc71321211b9ad7e53791ed89928e6d5f7fde2599` | same | match |

Every recorded hash matches. No file changed after its entry was
written.

**Finding — three code versions for weil_Lc_height.py.** The two
committed JSONs were produced by two different versions of the script,
and the file on disk is a third. Entry 300 states this plainly
(`notes/lab_notebook_2.md:522-537`) and adds that none of the three
diffs can be reconstructed, the script being untracked before that
commit. The consequence for reproduction: running the committed
`weil_Lc_height.py` cannot produce either committed JSON, and no
artifact in the tree can tell a reader how far off it would be.

**Finding — entries 298 and 299 record no sha256 at all**, for their
artifacts or for their scripts. There is nothing to check, and nothing
that would detect a later edit of `weil_rung_min.py` or
`weil_Lc_eps.py`. `weil_Lc_eps.json` does carry
`params.code_version` `19e79317ed269adc494e5c7480af8870c487029bbb92e837c0e899a1a45e792d`,
which equals the disk sha256 of `analysis/2026-09-01/weil_Lc_eps.py`
— the binding exists in the artifact, the entry just does not quote it.

**Finding — two results JSONs record no `code_version` at all.**

```text
weil_Lc_eps            code_version= 19e79317…  run_start= 2026-09-02T09:59:59Z
weil_Lc_height         code_version= 268256e5…  run_start= 2026-09-02T10:14:59Z
weil_Lc_height_eps0    code_version= 547e2dd3…  run_start= 2026-09-02T10:54:18Z
weil_Lc_mod            code_version= ABSENT     run_start= ABSENT   timestamp= 2026-09-02T10:33:53
weil_Lc_theory         code_version= ABSENT     run_start= ABSENT   timestamp= 2026-09-02T11:12:27
```

For `weil_Lc_mod.json` the only link to the script that made it is
entry 301's hand-computed `cb2811de…`, taken from disk on 2026-09-02
after the run. For `weil_Lc_theory.json` there is no link of any kind.
The two also differ in time convention: `eps`/`height` write
`run_start_at`/`run_end_at` in UTC with a `Z`; `mod`/`theory` write a
naive local `timestamp` at file-write time.

## 4. Number fidelity

**4.1 check_refs.** `python3 utilities/check_refs.py` — exit 0.

```text
notebook: 300 entries, newest 301 (2026-09-02), next 302

0 broken reference(s)
```

**Match** on the broken-reference count. The entry number is 301, not
the 303 the checklist expects; see §1.

**4.2 check_values.** Its docstring
(`utilities/check_values.py:2-10`) describes a checker over
`papers/*.md` that runs at import and takes no arguments, so it is run
bare. `python3 utilities/check_values.py` — exit 0:

```text
141 values confirmed, 0 not found, 395 statements skipped (no artifact in source line)
```

**Match.**

**4.2b .numbers integrity** (added; the amendment made the `.numbers`
files load-bearing for the comparison that was later cancelled).
`python3 utilities/flatten_results.py --check analysis/2026-09-01/results/*.numbers`
— exit 0, four OK lines: `weil_Lc_eps` `f70d485ccab2…`,
`weil_Lc_height` `bb1c869eb4b2…`, `weil_Lc_mod` `c2717f263ef7…`,
`weil_Lc_theory` `0077130f7b02…`. Every `.numbers` header hash equals
its JSON's current sha256. **Match.**

**Finding.** Four results JSONs in the same directory have no sibling
`.numbers`: `weil_Lc_height_eps0.json`, `weil_QX.json`,
`weil_rung_min.json`, `zetazeros_2000.json`. `check_entry_numbers.py`
consequently reports for entry 298: `entry 298 cites no .numbers file
(or .json with a sibling)` — that entry's numbers cannot be machine-
checked at all.

**4.3 check_entry_numbers, entries 298–301.**

```text
python3 utilities/check_entry_numbers.py --entry N
```

| entry | OK | MISMATCH | UNRESOLVED |
| --- | --- | --- | --- |
| 298 | 0 | 0 | 6 (no `.numbers` cited) |
| 299 | 0 | 0 | 12 |
| 300 | 1 | 0 | 25 |
| 301 | 0 | 1 | 20 |

The single MISMATCH, entry 301:

```text
MISMATCH   timings.elapsed_s  entry says 422,
           analysis/2026-09-01/results/weil_Lc_mod.numbers has 1206.065623998642
```

**Not a finding against the entry.** The entry reads "Wall 1206.07 s =
20.1 min (`txt:359`; `log:401`; JSON `timings.elapsed_s`): 422 Z builds
288.7 s" (`notes/lab_notebook_2.md:73-75`). The value sits *before* the
key; the checker takes the nearest number *after* it, which is the
Z-build count. `meta.timings.elapsed_s` is `1206.065623998642` and the
entry's 1206.07 is right. This is a limitation of
`check_entry_numbers.py` on a value-then-key sentence.

The UNRESOLVED lines are overwhelmingly key *shapes* rather than keys
— `ladder["k=K|eps=E|M=16|w=1/2"]`, `fits[eps][form]`,
`minimiser_at_Lc.coef_norm` — plus backticked identifiers like
`mp.eigsy`, `mp.besselj`, `numpy.linalg.lstsq`, which the checker
cannot distinguish from keys. Expected output, per its docstring
(`utilities/check_entry_numbers.py:22-24`).

**4.3b Hand spot-check, entry 301** — first ten cited numbers, read
from `analysis/2026-09-01/results/weil_Lc_mod.numbers` and from the
log lines the entry names.

| entry says | source | file says | result |
| --- | --- | --- | --- |
| wall 1206.07 s | `meta.timings.elapsed_s` | 1206.065623998642 | match |
| 422 Z builds 288.7 s | `meta.timings.nZ`, `meta.timings.Z` | 422, 288.72626638412476 | match |
| 422 S builds 4.1 s | `meta.timings.nS`, `meta.timings.S` | 422, 4.096727132797241 | match |
| 1096 T builds 16.2 s | `meta.timings.nT`, `meta.timings.T` | 1096, 16.231845140457153 | match |
| 1820 eigsolves 835.3 s | `meta.timings.neig`, `meta.timings.eig` | 1820, 835.3429777622223 | match |
| `log:270` prints 1808 / 829.5 s | `results/weil_Lc_mod.log:270` | `pencil eigs 1808 (829.5s)` | match |
| unit tests 52.3 s (`log:49`) | `results/weil_Lc_mod.log:49` | `unit tests: 52.3s` | match |
| k=1, ε=0.001: L_c 1.2835, bracket [1.2618, 1.2835], X_c 3.609 | `ladder.k=1\|eps=0.001\|M=16\|w=1/2.L_c`, `.L_c_bracket[0]`, `[1]`, `.X_c` | 1.2835402603145116, 1.2617769081319183, 1.2835402603145116, 3.6093953322166747 | match |
| 3 bisections | `ladder.k=1\|eps=0.001\|M=16\|w=1/2.n_bisect` | 3 | match |
| ε=0.001 log γ_k fit a −3.5132, b +1.76855, rms 0.2199, R² 0.9934 | `fits.0.001.log_gamma_k.a` / `.b` / `.rms_resid` / `.R2` | −3.5132235419883764, 1.7685542561717171, 0.21988972496244633, 0.9933997636454183 | match |
| k=10, ε=0.01: \|A\|² 1.922e-10, \|B\|² 2.506e-05, Z′ 2.660e-05, tail 1.86e-08, 45 sign changes, ‖c‖ 1.41, kept 32/32 | `ladder.k=10\|eps=0.01\|M=16\|w=1/2.minimiser_at_Lc.*` | 1.9220595568965891e-10, 2.5062350211850983e-05, 2.660197159803731e-05, 1.8585686387622054e-08, 45, 1.4141922447942734, 32 | match |
| 56 ladders (48 + 8 controls) | count of `ladder.*.L_c` keys | 56 | match |
| script 935 lines, txt 359 lines, log 402 lines | `wc -l` | 935, 359, 402 | match |
| `log:401` sha and 20.1 min | `results/weil_Lc_mod.log:401` | `sha256 c2717f26… (20.1 min)` | match |

Zero mismatches.

**4.3c Hand spot-check, entry 300** (substituted for the absent 302) —
read from `analysis/2026-09-01/results/weil_Lc_height.numbers`.

| entry says | source | file says | result |
| --- | --- | --- | --- |
| `params.grid_ratio` 1.146609 | `params.grid_ratio` | 1.1466090462412175 | match |
| local gaps 6.8873, 3.9888, 2.5102, 1.7687 | `params.local_gap.1/2/5/10` | 6.887314497, 3.988817941, 2.510185462, 1.768681597 | match |
| k=5, ε=0.01, M=32: L_c 2.3756, λ(1.5L_c) −3.61e-30, λ(2L_c) −5.08e-32, pos-above 8/12, λ at bracket −1.42e-22 | `ladder.k=5\|eps=0.01\|M=32\|w=1/2.*` | 2.375629080262362, −3.609464759401284e-30, −5.079709106654905e-32, 8 of 12, −1.4249011600946883e-22 | match |
| same row at `log:94` | `results/weil_Lc_height.log:94` | `L_c=2.3756 … lam(1.5Lc)=-3.61e-30 lam(2Lc)=-5.08e-32 pos-above=8/12` | match |
| `ladder["k=10\|eps=0.001\|M=64\|w=1/2"].lam_at_bracket[1]` −3.78e-28 | that key | −3.77957423784366e-28 | match |
| k=1, ε=0.001: L_c 1.2835, X_c 3.609 (M=32 and M=64 identical) | `ladder.k=1\|eps=0.001\|M=32\|w=1/2.L_c`, `…M=64…` | 1.2835402603145116 both | match |
| `run_start_at` 10:14:59Z, `run_end_at` 10:53:05Z | `meta.params.run_start_at` / `run_end_at` | "2026-09-02T10:14:59Z", "2026-09-02T10:53:05Z" | match |
| 3565 eigensolves 1894.1 s, 320 Z builds 184.8 s, 773 T builds 67.3 s | `meta.timings.*` | 3565 / 1894.1368808746338, 320 / 184.77577996253967, 773 / 67.30825757980347 | match |
| wall 38:07.95, 2283.84 s user (`log:440`) | `results/weil_Lc_height.log:440` | `2283.84s user 3.86s system 99% cpu 38:07.95 total` | match |
| log 440 lines, txt 355 lines, eps0.log 118, eps0.txt 76 | `wc -l` | 440, 355, 118, 76 | match |
| the γ_k fit overwrote the raw γ_k list under `fits[…]["gamma_k"]` | `fits.M_used (largest M run per k)\|w=1/2.gamma_k.a` etc. | a dict with `a`/`b`/`residuals`/`rms_resid`/`R2`, no raw list | match |

Zero mismatches.

**4.4 NOTEPAD.** The checklist's command:

```text
awk 'length > 400 {print NR": "length}' notes/NOTEPAD.md
```

printed eight lines: 21 (406), 22 (426), 27 (414), 28 (417), 29 (411),
32 (404), 38 (403), 53 (410).

**Finding — against the checklist, not against NOTEPAD.** macOS `awk`
counts bytes here. Recounted in characters:

```text
line 21: chars 385  bytes 406
line 22: chars 398  bytes 426
line 27: chars 398  bytes 414
line 28: chars 400  bytes 417
line 29: chars 400  bytes 411
line 32: chars 396  bytes 404
line 38: chars 385  bytes 403
line 53: chars 396  bytes 410
```

Every one is ≤ 400 characters. The excess is Greek letters, em-dashes
and primes at 2–3 bytes each. NOTEPAD passes the ≤ 400 rule
(`AGENT_CARD.md:41`); the checklist's byte-counting `awk` is what
fails. Lines 21 and 22 are the new entries 300 and 299.

**Checked** — one `[open]` line per entry.

```text
grep -n 'entry 29[89]:\|entry 30[0-3]:' notes/NOTEPAD.md
```

printed exactly four, one each and in order: line 20 entry 301, 21
entry 300, 22 entry 299, 23 entry 298. **Match** for 298–301; nothing
for 302 or 303, consistent with §1.

## 5. Reproducibility

**5.1 Environment.**

```text
python3 --version                            → Python 3.14.3
python3 -c "import numpy; print(numpy.__version__)"   → 2.5.2
python3 -c "import mpmath; print(mpmath.__version__)" → 1.3.0
python3 -c "import scipy; ..."               → ModuleNotFoundError: No module named 'scipy'
which python3 → /Users/juliansambrano/GitHub/Primebeat_081426/.venv/bin/python3
```

scipy is absent. `grep -rn 'scipy' analysis/2026-09-01/` returns
nothing, so no script in that directory needs it; the missing module
blocks nothing here.

```text
grep -ln 'sys.version\|__version__' analysis/2026-09-01/*.py   → (no output, exit 1)
```

**Finding.** Zero of the six scripts —
`weil_Lc_eps.py`, `weil_Lc_height.py`, `weil_Lc_mod.py`,
`weil_Lc_theory.py`, `weil_QX.py`, `weil_rung_min.py` — records the
interpreter or library versions it ran under. `weil_Lc_height.py` does
not even `import sys` (its imports are
`analysis/2026-09-01/weil_Lc_height.py:50-60`). No artifact in the
tree states that these runs were Python 3.14.3 / numpy 2.5.2 /
mpmath 1.3.0; that pairing exists only in this report.

**5.2 Runtime, from the tail of each committed log.**

| script | log | recorded runtime | source |
| --- | --- | --- | --- |
| `weil_Lc_eps.py` | `results/weil_Lc_eps.log` | ~72 s of component timings; no total line | `results/weil_Lc_eps.log:116` — `Z builds 106 (22.4s), T builds 285 (13.7s), eigs 900 (36.0s)` |
| `weil_Lc_theory.py` | `results/weil_Lc_theory_run2.log` | 50.6 s total | `results/weil_Lc_theory_run2.log:145` — `total 50.6s`; `meta.timings.total_s` 50.62220001220703 |
| `weil_Lc_mod.py` | `results/weil_Lc_mod.log` | 1206.07 s = 20.1 min | `results/weil_Lc_mod.log:401`; `meta.timings.elapsed_s` |
| `weil_Lc_height.py` | `results/weil_Lc_height.log` | 38:07.95 wall, 2283.84 s user | `results/weil_Lc_height.log:440` |
| `weil_Lc_height.py` ε=0 control | `results/weil_Lc_height_eps0.log` | 59 s | `notes/lab_notebook_2.md:330-331`, `eps0.log:71` |

Under the checklist's own 10-minute rule, `weil_Lc_mod.py` (20.1 min)
and `weil_Lc_height.py` (38.1 min) would have been "unrerun, runtime
N" regardless of the amendment. Only `weil_Lc_theory.py` (50.6 s) and
`weil_Lc_eps.py` (~72 s) were ever eligible.

**Finding against the checklist.** `container_audit.md:110` says
"entries 301 and 302 record 52.3 s and 50.6 s". Entry 301's 52.3 s is
its *unit-test* time (`notes/lab_notebook_2.md:77-78`;
`results/weil_Lc_mod.log:49`); its run wall is 1206.07 s. The 50.6 s
belongs to `weil_Lc_theory.py`, whose entry does not exist yet.
Following that sentence would have priced a 20-minute run at 52 s.

**Finding — the unsuffixed theory log is a crash.**
`analysis/2026-09-01/results/weil_Lc_theory.log` (21 lines, committed
at 33df8ca) ends in a traceback:

```text
File ".../analysis/2026-09-01/weil_Lc_theory.py", line 375, in main
    proj = N10 * np.sqrt((2 * n + 1) / (2 * h10)) * h10 * (Wq * xP) @ Vx
ValueError: operands could not be broadcast together with shapes (16,) (8000,)
```

The completed run is `results/weil_Lc_theory_run2.log` (145 lines),
which ends `wrote … weil_Lc_theory.json (sha256 0077130f…) … total
50.6s`. A reader reaching for "the log" by name gets the failure.

**5.3 Clean rerun — not run — Julian's call, 2026-09-02.**
No clone was made; `git clone`, `git checkout`, and every script
invocation were skipped. Nothing was started and killed: no rerun
process was ever launched, and no file was written under any rerun
directory.

**5.4 Comparison — not run — Julian's call, 2026-09-02.** The
`.numbers` diff described in the amendment
(`diff <(grep -v '^meta\.' a.numbers | tail -n +3) …`) was not
executed against any rerun, because there is no rerun to compare
against. The `.numbers` files themselves were verified against their
JSONs (§4.2b).

**5.5 Determinism — not run — Julian's call, 2026-09-02.** No script
was run twice.

**What this leaves untested.** No script in this tree has been
reproduced from a clean checkout. Every sha256 in §3 proves what was
produced — that the bytes on disk are the bytes the entry describes —
and nothing about whether running the committed code again yields
them. Specifically untested: whether `weil_Lc_theory.py` and
`weil_Lc_eps.py` are bit-deterministic run to run; whether either
reproduces its committed JSON; whether a clone with no `__pycache__`,
no `.venv`, and only the tracked files can run any of these scripts at
all. Two facts already in hand narrow what such a test could show —
`weil_Lc_height.py` on disk is a third code version and cannot
reproduce either committed JSON (§3), and no script records its
environment (§5.1), so a future divergence could not be attributed to
a library change.

## 6. Logging completeness

**6.1 Scripts against notebook citations.** `ls analysis/2026-09-01/*.py`
gives six. Each basename grepped against both notebooks, and each hit
mapped to the entry whose heading precedes it:

```text
weil_Lc_eps.py     entries 299, 300
weil_Lc_height.py  entries 299, 300, 301
weil_Lc_mod.py     entry  301
weil_Lc_theory.py  no entry
weil_QX.py         entries 295, 297, 298, 299
weil_rung_min.py   entries 297, 298, 299
```

`grep -c` on `notes/lab_notebook.md` (volume 1) returns 0 for all six.

**Finding.** `analysis/2026-09-01/weil_Lc_theory.py` is cited by no
notebook entry. It ran and its outputs are committed —
`results/weil_Lc_theory.json` (sha256 `0077130f7b029a82479f9ff319f8b3e7ee447694ee70721910c134711202bafa`),
`results/weil_Lc_theory.numbers`, `results/weil_Lc_theory.log`,
`results/weil_Lc_theory_run2.log`, `weil_Lc_theory.txt` (144 lines),
`weil_Lc_theory.md` (183 lines), the script itself (672 lines, sha256
`ddc7ca7189ea147944b7d19bb7eb93aa8524702f324c054ffe5ac8c369a7d2c8`),
all added at 33df8ca whose message reads "(entries 302/303 pending)".
The entries were still pending when this audit finished. Outside
`container_audit.md`, the only file in the tree that mentions
`weil_Lc_theory` is `analysis/2026-09-01/weil_Lc_theory.md` itself.

`analysis/2026-09-01/scratch/` is known unlogged at Julian's decision.
Its contents, after the §2 copy: `README.md`, `adv_census.py`,
`adv_region.py`, `adv_theta.py`, `batch1.txt`, `batch2.txt`,
`batch3.txt`, `batch4.txt`, `chk.lean`, `chk2.lean`, `chk3.lean`,
`final.py`, `gamma1_to_14.py`, `line_0_100.py`, `line_0_100_v2.py`,
`line_0_100_v3.py`, `line_sigma.py`, `mod_smoke.json`,
`mod_smoke.txt`, `mod_smoke2.json`, `mod_smoke2.txt`, `open_august.txt`,
`price_check.py`, `price_check2.py`, `rebuild_census_price.py`,
`sens.py`, `smoke.json`, `smoke_height.json`, `smoke_height2.json`,
`xcheck_k1.py`. Left as they are.

**6.2 The exploratory sentence.** Present in all four entries that
exist, identical opening in each:

```text
:23   entry 301  **Exploratory.** No prereg, no decision rule, no verdict; the script
                 says so in its docstring and stamps every output with it
                 (`analysis/2026-09-01/weil_Lc_mod.py:4,444,850`; …log:1`; `weil_Lc_mod.txt:1`).
:268  entry 300  … (`analysis/2026-09-01/weil_Lc_height.py:1-3,163,499,529,593`;
                 `…weil_Lc_height.log:1,439`; `weil_Lc_height.txt:1`).
:562  entry 299  … (`analysis/2026-09-01/weil_Lc_eps.py:1-3,411,729,759,827`;
                 `weil_Lc_eps.log:1,172`; `weil_Lc_eps.txt:1`).
:776  entry 298  … (`analysis/2026-09-01/weil_rung_min.py:1-3,333,631,671,729`).
```

**Match.** No entry lacks it. The logs corroborate: every committed
`.log` for these runs carries `EXPLORATORY - no prereg, no decision
rule, no verdict.` at line 1 and again at the tail.

**6.3 Preregs.** `ls preregs/` printed FORMAT.md and eleven
locked prereg pairs (`.md` + `.sha256`):
`alpha_depth_trend_v1_locked_20260814`,
`character_sweep_q11_q13_v1_20260826`,
`dense_boundary_scan_v1_20260827`,
`dh_aggregate_spectrum_v1_20260825`,
`dh_coalition_spectrum_v1_20260825`,
`extended_zero_census_v1_locked_20260818`,
`floor_reconstruction_v1_20260828`,
`multibase_synthesis_v1_20260827`,
`small_angle_cross_base_v1_20260821`,
`sub_integer_base_scan_v1_20260818`,
`zero_winding_phase_v1_locked_20260818`.

`grep -rln 'weil' preregs/` printed nothing. **Match** — no prereg
names any `weil_Lc_*` script, or any weil script at all. Every run in
entries 298–301 is correctly labelled exploratory.

## 7. Lean side (read-only)

**7.1 Build.** `cd lean_stage3 && lake build 2>&1 | tail -6`:

```text
ℹ [8735/8736] Replayed Stage3
info: Stage3.lean:63:0: RiemannHypothesis : Prop
info: Stage3.lean:64:0: riemannZeta.Riemann_vonMangoldt_bound : ℝ → ℝ → ℝ → Prop
info: Stage3.lean:65:0: Backlund.zetaCounting_crude_majorant : ∃ A, 0 < A ∧ ∀ (T : ℝ), 2 ≤ T → |riemannZeta.N T| ≤ A * T ^ (3 / 2)
Build completed successfully (8736 jobs).
```

7 seconds, fully replayed from cache. **Match** — builds clean, 8736
jobs, well inside the 15-minute cap.

**7.2 Sorries.** The checklist's command:

```text
grep -rn 'sorry' lean/ lean_stage3/Stage3/ --include='*.lean' | grep -v '^.*--' | wc -l   → 724
```

**Finding — against the checklist.** `lean/` contains
`lean/.lake/packages/mathlib/`, so that command sweeps all of mathlib
and can never print 0; the `grep -v '^.*--'` filter also matches any
line containing `--` anywhere, not only comment lines. (As written the
command also needs `--include='*.lean'` quoted, or zsh fails it with
`no matches found`.) Restricted to project sources:

```text
grep -rn 'sorry' lean/ lean_stage3/Stage3/ --include='*.lean' --exclude-dir='.lake' | wc -l   → 21
grep -rn '^\s*sorry\b\|:= *sorry\b\|by *sorry\b' … --exclude-dir='.lake'                      → 5
```

All 21 are prose inside docstrings and comments — "proved with no
`sorry`", "sorry-free at the pin", "named `sorry`s". All 5 of the
narrower hits are lines beginning "sorry-free …" wrapped from the
previous line. **The project sorry count is 0**, consistent with
`notes/NOTEPAD.md:32` (entry 292, "Stage3 SORRY-FREE").

## 8. Findings, ranked by what breaks a later reader first

1. **A committed result has no notebook entry.**
   `analysis/2026-09-01/weil_Lc_theory.py` and its six committed
   artifacts (JSON sha256 `0077130f7b029a82479f9ff319f8b3e7ee447694ee70721910c134711202bafa`)
   are cited by no entry in either notebook; `check_refs` read
   `newest 301, next 302` throughout this audit. A reader finds a
   result with no dated record of what it measured or why. (§6.1)

2. **Nothing here has been reproduced.** §5.3–§5.5 not run — Julian's
   call, 2026-09-02. Every verified sha256 proves what was produced
   and nothing about whether it reproduces. No script was run from a
   clean checkout; determinism is unmeasured. (§5.3–§5.5)

3. **`weil_Lc_height.py` on disk cannot reproduce either of its
   committed JSONs.** Three code versions are in play — `268256e5…`
   (main run), `547e2dd3…` (ε=0 control), `bb931efe…` (disk) — and
   entry 300 records that none of the three diffs can be
   reconstructed. (§3)

4. **Two results JSONs carry no `code_version`.** `weil_Lc_mod.json`
   is bound to its script only by entry 301's hand-computed
   `cb2811de…`; `weil_Lc_theory.json` is bound to nothing. `eps` and
   `height` record theirs inside the artifact. (§3)

5. **`results/weil_Lc_theory.log` is a crashed run's log** —
   `ValueError` at `weil_Lc_theory.py:375`. The completed run is
   `results/weil_Lc_theory_run2.log`. The plainer name holds the
   failure. (§5.2)

6. **Entries 298 and 299 record no sha256 at all**, so a later edit of
   `weil_rung_min.py` or `weil_Lc_eps.py` would leave no trace in the
   record. (`weil_Lc_eps.json` does carry `params.code_version`
   `19e79317…`, which matches disk; the entry does not quote it.) (§3)

7. **No script records its environment.** Zero of six write
   `sys.version` or a library `__version__`. Python 3.14.3 / numpy
   2.5.2 / mpmath 1.3.0 is recorded nowhere but here. (§5.1)

8. **Four results JSONs have no sibling `.numbers`** —
   `weil_Lc_height_eps0.json`, `weil_QX.json`, `weil_rung_min.json`,
   `zetazeros_2000.json` — so `check_entry_numbers.py` can check
   nothing in entry 298. (§4.2b)

9. **`container_audit.md:110` misprices a 20-minute run at 52 s** by
   reading entry 301's unit-test time as its wall time. (§5.2)

10. **`container_audit.md:153` (§7.2) can never print 0** — it sweeps
    `lean/.lake/packages/mathlib/` and prints 724. The project count
    with `--exclude-dir='.lake'` is 0. (§7.2)

11. **`container_audit.md:95` (§4.4) counts bytes, not characters** —
    it flags eight NOTEPAD lines as over 400 when all eight are ≤ 400
    characters. (§4.4)

12. **`container_audit.md:121-123` (§5.3) orders two runs that its own
    §5.2 rule excludes** — `weil_Lc_mod.py` at 20.1 min and
    `weil_Lc_height.py` at 38.1 min. (§5.2)

13. **`check_entry_numbers.py` reports a false MISMATCH** on a
    value-then-key sentence: entry 301's `timings.elapsed_s` is right
    (1206.07 against 1206.065623998642); the checker read the 422 that
    follows the key. (§4.3)

14. **`scratch/final.py:2` and `scratch/sens.py:2` insert a
    `/private/tmp` session-UUID path.** It resolves today because this
    session shares the UUID; it will not for a later reader.
    `scratch/README.md:19-21` already says to run them from the scratch
    directory. (§2)

15. **Five scratchpad files copied into the tree**, as §2 instructs:
    `xcheck_k1.py`, `mod_smoke.json`, `mod_smoke.txt`,
    `mod_smoke2.json`, `mod_smoke2.txt`, with five rows added to
    `scratch/README.md`. Untracked, uncommitted. `xcheck_k1.py` is the
    cross-check entry 301 describes as living in no tree file. (§2)

16. **`results/weil_Lc_height_M96.log` is 0 bytes** — known,
    explained at `notes/lab_notebook_2.md:517-520`. Recorded for
    completeness. (§2)

Everything else checked clean: all five recorded sha256 values match
(§3), all four `.numbers` headers match their JSONs (§4.2b), twenty-five
hand spot-checked rows across entries 300 and 301 match their
`.numbers` keys and log lines with zero mismatches (§4.3b, §4.3c),
`check_refs` and `check_values` exit 0 (§4.1, §4.2), NOTEPAD carries
one `[open]` line per existing entry and none over 400 characters
(§4.4), all four entries carry the exploratory sentence (§6.2), no
prereg names any weil script (§6.3), and `lean_stage3` builds clean at
8736 jobs with 0 project sorries (§7).
