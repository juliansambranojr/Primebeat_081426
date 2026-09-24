# Porting cheat sheet

Greps and lookups to run when porting a script from Primebeat_081426.
Updated by agents after each porting session.

## Before copying the script

```bash
# What unit number is next?
ls -d units/*/ | tail -1

# Which O-numbers are already ported? (maps script filenames to units)
for u in units/*/run/; do
  echo "=== $(basename $(dirname $u)) ==="
  ls "$u"/*.py 2>/dev/null | xargs -I{} basename {}
done
```

## After copying, before patching

Run these on the copied script to find every path that needs rewriting:

```bash
# Path constants — these are the lines you'll patch
grep -n 'DEFAULT_\|_HERE.*results\|_HERE.*zeros\|_HERE.*cache' script.py

# Required flags — if a flag is required=True, it must go in run.sh
grep -n 'required=True' script.py

# Cross-test reads — does this script import or read another O-test?
grep -n 'import.*O[0-9]\|--o[0-9]\|--cache\|--zeros\|--prereg\|--data-dir\|--bfile' script.py

# How does it import other scripts? (importlib = file path, import = sys.path)
grep -n 'importlib\|sys.path\|spec_from_file' script.py
```

## After patching with sed

```bash
# Verify every sed actually matched. sed exits 0 whether it matched or not.
grep -c 'YOUR_REPLACEMENT_TEXT' patched_file.py
# If 0: you misspelled something. Diff your sed pattern against the file.

# Multi-line defaults: some scripts split os.path.join across two lines.
# Single-line sed won't match. Use python or read the exact lines first.
```

## Data file locations

| File | Path from unit run/ dir |
|------|------------------------|
| zeros600.json | `../../../data/zeros/zeros600.json` |
| pi2n_cache.json | `../../../data/cache/pi2n_cache.json` |
| lattice_mapper CSVs | `../../../units/0031-base-ladder-crossing/run/imported/lattice_mapper/32bit` |
| O16 run log | `../../../units/0015-centered-difference-table/run/lab_run.001.log` |
| preregs (stub) | `../../../units/0044-sub-integer-base-scan/run/preregs/` |
| O53 results (cross-unit) | `../../../units/0052-alias-tau/run/results.json` |
| O58 results (cross-unit) | `../../../units/0057-per-zero-exponent/run/results.json` |
| O39 results (cross-unit) | `../../../units/0038-transform-radius/run/results.json` |
| O67 results (cross-unit) | `../../../units/0066-conditional-last-zero/run/results.json` |

## Known gotchas

- **Silent sed failure**: sed exits 0 even when the pattern matches nothing.
  Always grep for the replacement text afterward. If grep returns 0 hits,
  compare your search string against the file character by character —
  it's almost certainly a typo. (2026-09-04, preregs/prereqs one-letter
  difference cost 10 minutes.)

- **Multi-line defaults**: O40, O41 split `default=os.path.join(_HERE, "results",`
  across two lines. Single-line sed fails silently. Read the exact lines
  before writing the sed.

- **All-required flags**: O42, O43 have every CLI flag marked required=True
  with no defaults. Check the docstring's "HOW IT WILL BE RUN" section for
  the full invocation and translate every flag into run.sh.

- **Cache size guards**: O43 expects pi2n_cache.json to have exactly 63
  entries. The repo's cache has 71. Scripts with exact-count integrity
  checks will trip on the larger cache.

- **preregs/ inaccessible**: The prereqs directory in Primebeat_081426 can't
  be opened (stat sees it, ls/cp/python can't). Stub files exist in
  units/0044. Scripts that call file_record() on preregs will crash without
  a stub.

- **O37 has two scripts, O38 has a buggy variant**: O37_weil_form_on_stencil.py
  (full) and O37_weil_form_balance.py (companion) are both real tests.
  O38_weil_form_BUGGY.py is superseded evidence — skip it, port
  O38_weil_bug_diagnosis.py instead.

- **importlib cross-imports**: O46 imports O45, O47 imports O45+O46 via
  importlib.util.spec_from_file_location. The --o45/--o46 flags take the
  script path, so point them at the upstream unit's run/ directory. No
  sys.path hacking needed.

- **prereqs vs preregs**: Scripts inconsistently spell `preregs/` (with g)
  and `prereqs/` (with q). The directory name in the unit must match
  whatever spelling the script hard-codes. Grep the script before
  creating the directory.

- **Cross-unit deps**: When a script imports or reads from another unit,
  add a `run/deps` file. `lab run` reads it before executing `run.sh`
  and creates symlinks or checks paths. Two directives:
  ```
  symlink O90_mode_coherence.py ../../0089-mode-coherence/run/O90_mode_coherence.py
  need ../../0089-mode-coherence/run/results.json
  ```
  `symlink` creates a symlink in `run/` if missing. `need` checks the
  target exists and fails with a clear message if not. This replaces
  manual symlink creation and gives agents a readable error ("Run the
  upstream unit first") instead of a Python traceback.

- **NaN in values.tsv**: O54 produces NaN when no peaks are found at a rung count. check.py's matches() crashed on Decimal(NaN) comparisons — fixed with is_finite() guard.

- **O62 (OEIS submission) writes txt files, not results.json**: values.tsv is sparse — only lab_run metadata. Prose must avoid bare numbers since there are almost no numeric keys to match against.

- **Hyphenated compounds parse as negative numbers**: "stage-3" in prose
  gets extracted as the number -3. Same for "base-2", "step-4", etc. The
  number parser sees the hyphen as a minus sign. Fix: use backticks —
  `` `stage-3` `` is exempt because it contains letters. Or rephrase to
  "stage 3" which is caught by the named-ref exemption.

## Writing unit.md prose

`lab check` catches wrong numbers. It does not catch wrong words around
right numbers. An agent can write "the first zero has 44 roots" — 44 is
in values.tsv, the sentence passes `lab check`, but the claim is
nonsense (a zero doesn't have roots; the generating function does). The
guard against that is the workflow below.

**Source priority:** The script already wrote an accurate narrative. Use it.

1. Read the log: `units/<NNNN>-*/run/lab_run.001.log`. This is the
   script's stdout — it describes what happened in the script's own
   words. The "What it shows" section should condense this, not
   reinterpret it.
2. Read the script's docstring: `head -30 units/<NNNN>-*/run/*.py`. This
   says what the script intended. The "Question" section comes from here.
3. Read values.tsv: `grep -v '^lab_run\|^#\|^meta' units/<NNNN>-*/values.tsv`.
   This tells you which numbers you can cite. The file is at the unit
   level, not inside `run/`.

**Do not compose prose from values.tsv alone.** values.tsv is a bag of
numbers with no narrative. Writing explanations around naked numbers is
how wrong claims get made. The log has the narrative. Condense it.

**Structure rules (prevent wrong relationships between right numbers):**

1. **Name the subject in every claim.** Don't write "the ratio is 4.8x"
   in a paragraph that mentioned two arms. Write "the replicate arm's
   median ratio is 4.8x." The log names its subjects. Keep them.
2. **One log section → one sentence.** Don't merge numbers from different
   log sections into a single sentence. "min 5.514, max 5.173, giving a
   ratio of 4.8x" wires three numbers into a false causal chain — the
   ratio comes from the medians, not from min/max. If each log section
   becomes its own sentence, the false chain can't form.
3. **Scope every claim.** "The check covers 528 cells per base" is wrong
   when the check ran at one base. "The check covers 528 cells at base 2"
   is right. The log says which base/arm/test a result belongs to. Don't
   widen the scope when condensing.

**Number rules:**
1. Only cite numbers that appear in values.tsv.
2. Numbers not in values.tsv cause `lab check` to fail. Use one of:
   - Remove the number from prose entirely.
   - Put it in a `key=value` backtick span: `` `dgamma=0.454` ``. The
     code-span exemption requires at least one letter and no spaces.
   - Rephrase: "six zeros" instead of bare "6".
3. Pure numbers in backticks are NOT exempt. `` `3.07` `` is still
   checked. The code-span exemption requires a letter or colon.
4. Dates, unit paths (`units/0042`), and named references (`Stage 3`,
   `Theorem 1.4`, `Phase 2`) are automatically exempt.
5. Scripts that don't write results.json (like O62) have sparse
   values.tsv — mostly lab_run metadata. Use backtick key=value format
   for everything.

**Citation format (makes claims machine-verifiable):**

Each claim in "What it shows" carries a tag naming the log section and
subject it came from. The format is `[§N subject]`, where N is the
section number from `lab sections <NNNN>` and subject names the arm,
base, or test.

```markdown
**What it shows.**
- [§1 replicate_1.1] Median amplitude 8.324 at zeros vs 1.736 at midpoints, ratio 4.8x.
- [§1 replicate_1.1] Complete separation: min at zero (5.514) exceeds max at midpoint (5.173).
- [§2 fine_1.002] Complete separation at 38 zeros vs 37 midpoints, ratio 36.5x.
- [§3 dyadic_control] Does not separate: 3 of 6 zeros fall below the max midpoint.
```

**Prose style — write sentences, not key dumps:**

The prose is for a human reader. Numbers go in sentences; values.tsv
key names do not. `lab check` matches numbers, not key names — putting
the key in the prose adds nothing the checker uses and makes the
sentence unreadable.

```markdown
DO:   The OLS slope is -0.004068, with CI from -0.004814 to -0.003321.
DON'T: `results.summary.b_obs` = -0.004068, with CI from `results.summary.ci_low` = -0.004814 to `results.summary.ci_high` = -0.003321.
```

If a key name clarifies what the number *is*, use a short form in
parentheses: "symmetry error 0.0 (M_symmetry_error)". Never the full
dotted path. `lab check` flags lines that look like key=value
assignments (KEY_DUMP warning).

`lab check` verifies each tag: §N must exist in the log, the subject
must appear in that section, and every number in the claim must appear
in that section. A wrong tag is a CITATION finding (exit 1).

Units without `[§N ...]` tags are not checked — they predate the format.
Units with any tags have every tag verified.

**Workflow:**
```bash
# 1. Read the log — this is the ground truth for what happened
cat units/<NNNN>-*/run/lab_run.001.log

# 2. See the section map (what §1, §2, etc. refer to)
python3 -m lab sections <NNNN>

# 3. Read the script docstring — this is the ground truth for intent
head -30 units/<NNNN>-*/run/*.py

# 4. See what numeric values are available to cite
grep -v '^lab_run\|^#\|^meta' units/<NNNN>-*/values.tsv | head -40

# 5. Write prose that condenses the log, using numbers from step 4,
#    with [§N subject] tags on each claim in "What it shows"

# 6. Check
python3 -m lab check <NNNN>
```

---

## Log

Agents: after porting, append what you learned here. Format:

```
### YYYY-MM-DD — units ported
- new data path discovered: ...
- new gotcha: ...
- new grep pattern that would have saved time: ...
```

### 2026-09-04 — units 0035-0046 (O37-O47)
- First porting session to use this file (it didn't exist yet).
- All gotchas above discovered during this session.
- O46/O47 cross-unit imports work via --o45/--o46 flags pointing at
  upstream unit run/ dirs — no need to copy scripts or hack sys.path.

### 2026-09-04 — units 0047-0057 (O48-O58)
- All scripts write results.json, no results/ subdirectory
- O54 reads O53's output via cross-unit path
- primecountpy installed system-wide with --break-system-packages on Python 3.14
- O55 (arm involution) takes ~458s, O56 (local-global reciprocal) takes ~171s — the two long-running scripts

### 2026-09-04 — units 0058-0067 (O59-O68)
- O68 depends on O67 — must run 0066 before 0067. O59 depends on O58 (unit 0057). O60 depends on O39 (unit 0038).
