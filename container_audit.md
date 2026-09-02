# Container audit — fidelity and reproducibility of the Weil-ladder runs

Written 2026-09-02 for a fresh agent with no memory of the session that
produced entries 298–303. Every step is a check with a command and an
expected output. Record what the command printed. Do not fix anything
unless a step says so; report and stop.

## 0. Orientation (do first, every time)

1. Read `/Users/juliansambrano/GitHub/AGENT_CLAUDE.md` — that is your role.
2. Read `/Users/juliansambrano/GitHub/Primebeat_081426/CLAUDE.md` in full.
   The two rules that bind this audit: "load, don't recall" (open every
   file before citing it; count grep matches, files contain templates)
   and "say what is" (state the positive finding, no `X, not Y`).
3. Read `notes/notes_format.md` and `notes/NOTEPAD.md` header.
4. Do not edit `CLAUDE.md`, `CONTEXT.md`, `REFERENCES.md`, anything
   under `files (2)/`, any `results/*.json` or `.log`, or any prereg.
5. Do not transition NOTEPAD lines. Do not stamp verdicts. Do not
   append notebook entries — write the report file (§8) and ask Julian
   whether to log it.
6. Never rerun a script into an existing log. Never write into
   `analysis/2026-09-01/results/`. Rerun output goes to a scratch
   directory (§5).

All paths below are relative to `/Users/juliansambrano/GitHub/Primebeat_081426/`.

## 1. Locate the entries

```text
grep -n '^## .*Entry 29[89]\|^## .*Entry 30[0-3]' notes/lab_notebook_2.md
```

Expect exactly one match per entry number (298–303). If an entry number
has zero or two matches, stop and report. Read each entry in full.
Newest entries are at the TOP of the file.

Build a list: for each entry, every `.py`, `.json`, `.log`, `.txt`,
`.md` filename it cites, and every sha256 it records. This list drives
§2–§4.

## 2. Tree completeness

For every file the entries cite:

```text
ls -la <path>
```

Record: exists / size / 0-byte. Known and expected:
`analysis/2026-09-01/results/weil_Lc_height_M96.log` is 0 bytes (entry
300 records why). Anything else at 0 bytes is a finding.

Also check:

- `analysis/2026-09-01/scratch/README.md` exists and lists the files
  present in that directory (`ls analysis/2026-09-01/scratch/` and
  compare).
- `grep -n 'sys.path' analysis/2026-09-01/scratch/final.py analysis/2026-09-01/scratch/sens.py`
  — report the hard-coded path and whether it exists on disk. Do not
  fix; report.
- Session scratchpad leftovers. Check whether these still exist:
  `/private/tmp/claude-501/-Users-juliansambrano-GitHub-Primebeat-081426/e0529930-f9ed-407f-aa48-0dd5f402f85a/scratchpad/xcheck_k1.py`
  and `.../scratchpad/mod_smoke*`. If present, copy them into
  `analysis/2026-09-01/scratch/` and add them to the README there. If
  absent, record that they are gone.

## 3. Hash fidelity

For every sha256 recorded in entries 299–303:

```text
shasum -a 256 <file>
```

Table: entry · file · recorded hash · computed hash · match. Every row
must match. A mismatch means the file changed after the entry was
written; find the commit with `git log --oneline -- <file>` and report.

Then confirm the code hashes: entries 300, 301, 302 record the sha256
of the `.py` itself. Same table.

## 4. Number fidelity

1. `python3 utilities/check_refs.py` — must exit 0. Record the line it
   prints (expected form: "notebook: N entries, newest 303 (...), next
   304 / 0 broken").
2. Read the docstring of `utilities/check_values.py`, then run it as
   its docstring says. Record exit code and every line of output.
3. Spot-check by hand, entries 301 and 302: pick the first ten numbers
   in each entry that carry a `file:line` or JSON-key citation. Open the
   cited location. Record: number in entry · number in file · match.
   Every mismatch is a finding. Do not edit the entry — corrections are
   new entries and Julian decides whether to write one.
4. Check the NOTEPAD lines for 298–303:
   `awk 'length > 400 {print NR": "length}' notes/NOTEPAD.md` — expect no
   output. Confirm one `[open]` line per entry with
   `grep -n 'entry 29[89]:\|entry 30[0-3]:' notes/NOTEPAD.md`.

## 5. Reproducibility

1. Environment. Record `python3 --version` and
   `python3 -c "import numpy, mpmath, scipy; print(numpy.__version__, mpmath.__version__, scipy.__version__)"`
   (if an import fails, record which). Then
   `grep -ln 'sys.version\|__version__' analysis/2026-09-01/*.py` — this
   tells you which scripts record their environment. Report the list;
   the ones missing are a finding.
2. Runtime. Before rerunning anything, read the tail of each script's
   log for its recorded runtime (entries 301 and 302 record 52.3 s and
   50.6 s). Skip any script whose log shows more than 10 minutes and
   report it as "unrerun, runtime N".
3. Clean rerun. Make a fresh clone into the scratch directory named in
   your system prompt:

   ```text
   git clone /Users/juliansambrano/GitHub/Primebeat_081426 <scratch>/clone
   cd <scratch>/clone && git checkout claude/lean-files-proof-analysis-qd8qg6
   ```

   Read each script's `--help` or argument parsing first; run it with
   the same flags the entry records, and with its output redirected
   under `<scratch>/rerun/`. Order: `weil_Lc_theory.py`,
   `weil_Lc_eps.py`, `weil_Lc_mod.py`, then `weil_Lc_height.py` only if
   §5.2 allows. If a script writes its JSON to a fixed path under
   `results/`, run it inside the clone so the committed file is never
   touched, then compare the clone's `results/` against the original.
4. Compare. For each rerun: `shasum -a 256` of the new JSON against the
   committed one. If they differ, diff the JSON keys
   (`python3 -c` with `json.load` on both, walk keys, print every leaf
   that differs with both values). Timing fields and code-hash fields
   are expected to differ; every other differing leaf is a finding,
   with its magnitude.
5. Determinism. Run `weil_Lc_theory.py` a second time in the clone and
   compare the two rerun hashes against each other. Same for
   `weil_Lc_eps.py`.

## 6. Logging completeness

1. `ls analysis/2026-09-01/*.py` — for each, grep the two notebooks for
   its basename. List every top-level script with zero entries citing
   it. (`scratch/` is known unlogged at Julian's decision; list its
   contents under a separate heading and leave them.)
2. For each of entries 298–303, quote the sentence that labels the run
   exploratory / no prereg. Any entry without that sentence is a
   finding.
3. `ls preregs/` — confirm no prereg names any of the `weil_Lc_*`
   scripts. Record the command output.

## 7. Lean side (read-only, optional if time is short)

1. `cd lean_stage3 && lake build 2>&1 | tail -5` — record whether it
   builds clean and the job count. Skip if the build takes more than
   15 minutes; report the time.
2. `grep -rn 'sorry' lean/ lean_stage3/Stage3/ --include=*.lean | grep -v '^.*--' | wc -l`
   — expect 0. Record the number.

## 8. Report

Write `analysis/2026-09-02/container_audit_report.md` with one section
per § above, each finding as: what was checked · command · what it
printed · match or finding. End with a flat list of findings ranked by
what would break a later reader first (a hash mismatch outranks a
missing version string).

Then ask Julian, in one line, whether to log the report. Do not append
a notebook entry or NOTEPAD line on your own.
