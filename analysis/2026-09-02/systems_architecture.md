# Systems architecture — data flowing unchanged through prose

Design only. Nothing here is built. Written 2026-09-02 against the tree as it
stood at `628d393` / `41fa4f6`. Every claim about the current system carries a
`file:line`; every claim about drift carries a measurement I ran, printed in a
fenced block. Prototypes referenced below live in this session's scratchpad and
are not in the tree.

---

## The principle

A measured value is written once, by a program, into an artifact. Everything
downstream — an agent's report, a chat message, a brief, a notebook entry,
`CONTEXT.md`, a paper — names that value and does not restate it. Where prose
must show the digits, a program puts them there and a gate proves they still
match. The prose stays plain markdown in a flat tree, readable by any LLM with
no tooling, because that is the load-bearing substrate
(`/Users/juliansambrano/GitHub/CLAUDE.md:275-277`); so the mechanism is
**check-in-place**, never render-in-place. Julian keeps synthesis — the verdict,
the status transition, the outcome marking, the commitment-file edit
(`CLAUDE.md:46-47`, `:118-121`, `Primebeat_081426/CLAUDE.md:146-148`,
`preregs/FORMAT.md:51-54`) — and no gate proposed here touches any of them. The
notebook is append-only; corrections are new entries
(`AGENT_CARD.md:9-11`); every migration step below is additive.

---

## 1 · The current system, as it actually is

### 1.1 The six hops

| # | hop | who carries it | mechanised today? |
|---|---|---|---|
| 1 | results JSON → agent report | a model, in prose | no |
| 2 | agent report → orchestrator chat | a model, in prose | no |
| 3 | chat → logger's brief | a model, in prose | partly (`check_agent_brief.py`) |
| 4 | brief → notebook entry | a model, in prose | partly (`check_entry_numbers.py`) |
| 5 | entry → `CONTEXT.md` | a model or Julian | no |
| 6 | entry → `papers/` | a model or Julian | partly (`check_values.py`) |

### 1.2 The worked example, traced

One value: the measured critical support length at `k = 10`, `ε = 0.01`.

Its authoritative bytes are `analysis/2026-09-01/results/weil_Lc_mod.json`,
whose sha256 is on line 1 of
`analysis/2026-09-01/results/weil_Lc_mod.numbers`. Traced forward:

```text
STAGE                                                            TRANSCRIPTION?
1  weil_Lc_mod.py computes it, writes weil_Lc_mod.json           machine
2  the same script formats it into weil_Lc_mod.txt:23,:87,:223   machine (2nd formatting)
3  flatten_results.py -> weil_Lc_mod.numbers:22014               machine, exact
4  weil_Lc_theory.py reads the mod JSON, re-emits it as
   theory.k=10|eps=0.01.L_c_meas in weil_Lc_theory.json          machine, exact
5  the same script formats it into weil_Lc_theory.txt:34,:63,:92 machine (3rd formatting)
6  the run agent reports it to the orchestrator                  HOP 1  prose
7  the orchestrator states it in chat                            HOP 2  prose
8  the orchestrator writes the logger's brief                    HOP 3  prose
9  the logger writes lab_notebook_2.md:423 (pasted table)        HOP 4  prose, ungated
   and lab_notebook_2.md:437 (`key` value)                       HOP 4  prose, gated
10 CONTEXT.md § Current state of the world would restate it      HOP 5  prose, ungated
11 papers/*.md would restate it                                  HOP 6  prose, half-gated
12 it is also the worked example in notes/notes_format.md:51,
   utilities/check_entry_numbers.py:14, and
   utilities/hooks/check_agent_brief.py:70                       3 more copies, in the spec
```

**Six prose transcriptions to reach a reader, and three further copies of the
same digits inside the format spec and two checkers.** Five machine stages
precede them, of which three are independent re-formattings of the same number
into text (`.json`, `.txt`, `.numbers`) — nothing checks those three against
each other.

### 1.3 What the current shape actually permits — measured

**a) Store coverage.** Four `.numbers` files exist against 203 results JSONs in
the tree.

```text
find . -name '*.numbers' | wc -l          ->   4
results JSONs in the tree                 -> 203
```

**b) Gated fraction of one good entry.** Entry 302 is the best-practice entry —
it cites keys throughout. `check_entry_numbers.py --entry 302` returns
`142 OK, 0 MISMATCH, 7 UNRESOLVED`. Against the entry's whole digit content:

```text
entry 300: numbers outside fences  727 | inside fences  344 | key-shaped tokens  46
entry 301: numbers outside fences  600 | inside fences  301 | key-shaped tokens  28
entry 302: numbers outside fences  792 | inside fences  509 | key-shaped tokens 166
entry 303: numbers outside fences  297 | inside fences   19 | key-shaped tokens  45
```

Entry 302 holds 1301 numeric tokens. 142 are verified. **Roughly one digit in
nine.** The 509 inside fences are verified by nothing at all:
`check_entry_numbers.py:79` and `check_numbers_in_response.py:56` both strip
fenced blocks before looking.

**c) The fences are not verbatim.** Of entry 302's three data tables, one is a
byte-exact slice of `analysis/2026-09-01/weil_Lc_theory.txt:134-141`; the other
two are hand-narrowed copies with columns deleted mid-line. A transclusion
prototype (below) distinguishes them:

```text
DRIFT    entry302:160   weil_Lc_theory.txt:62-77    (column removed)
DRIFT    entry302:243   weil_Lc_theory.txt:108-120  ('meas = ...' clause removed)
OK       entry302:312   weil_Lc_theory.txt:134-141  8 lines  sha 35d5bd43d893
```

Entry 302's digits themselves are clean — every numeric token in all three
fenced blocks appears somewhere in the source `.txt`. That is the author's
care, and care is precisely what failed in the entries below.

**d) The brief hop leaks, and is measured leaking.** Entries 298–303 each
record errors they caught in their own brief by opening the file. Grepping the
notebook for that construction:

```text
in-entry corrections of the brief: 25
by entry: 303:3  302:2  301:7  300:4  299:3  298:5   (+ one in entry 229)
```

Twenty-four in six consecutive entries — about four per entry — and those are
only the ones the logger caught. Their kinds: twelve wrong line references,
five wrong values or wrong rows, three wrong counts, three wrong durations,
and four range or "identical" claims in words.

I scored the existing brief gate against all twenty-four, feeding each wrong
claim through `utilities/hooks/check_agent_brief.py`'s own `verdict()`:

```text
check_agent_brief.py denies 2 of 24 real brief errors (8%)
```

It catches the two written in scientific notation. It allows every line
reference (`SKIP_BEFORE` at `check_agent_brief.py:31` → `check_numbers_in_response.py:50`
skips anything after `line`, `lines`, `entry`, `:`), every count in words, every
duration under three decimals, and every range claim. **Digit-denial is the
wrong instrument for this hop, because most brief drift is not digits.**

**e) Key collision is live and silently resolved.** `check_entry_numbers.py:184-188`
resolves an unqualified key across every cited `.numbers` file and takes
`hits[0]`. Between the two files entry 302 cites:

```text
shared keys: 47   differing values: 33
  params.L_grid[0]  mod: 0.3                theory: 0.02229612249207783
  meta.timestamp    mod: "2026-09-02T10:33" theory: "2026-09-02T11:12"
```

Entry 302 cites `params.L_grid[0]` and passes because the theory file happened
to be discovered first. Cited in the other order the same correct entry would
have reported a MISMATCH — or a wrong value would have been confirmed.

**f) Known checker defects, from the tree's own audit.**
`analysis/2026-09-02/container_audit_report.md:633-636` records a false
MISMATCH on a value-then-key sentence (since patched at `41fa4f6`);
`:613-616` records four JSONs in one directory with no sibling `.numbers`, so
entry 298 is machine-checkable in no part; `:618-619` records the 20-minute run
mispriced as its unit-test time, which is the wall-time drift instance.
`check_entry_numbers.py` also treats Lean declaration names as candidate keys
— entry 303 returns `0 OK, 0 MISMATCH, 14 UNRESOLVED`, of which ten are
identifiers like `riemannZeta.RH_up_to`.

**g) The runner is bypassed.** `utilities/run.py:23` writes
`results/runs/<utc>_<script>.json` binding artifact to invocation, and
`check_direct_run.py:64-66` forces scripts through it — but only for a bare
`(O|0|t)\w*\.py` immediately after the interpreter. Every `analysis/**/*.py`
script escapes it, and so does any path-qualified invocation. Measured: 36 run
manifests exist, the newest dated 2026-08-28, while six measured runs landed on
2026-09-01/02 with none.

**h) Cost of the obvious fix.** Flattening every results JSON is not free:

```text
results JSONs in tree                    186 MB
measured .numbers/.json size ratio       1.46  (8-file random sample)
projected .numbers if all were flattened ~272 MB, committed
```

That prices "just flatten everything" out, and is why the design below makes
the store derived and the *receipt* the committed thing.

---

## 2 · Prior art, and what I take from it

Researched by a read-only web agent; URLs are ones it fetched.

**cog** (`https://cog.readthedocs.io/en/latest/source.html`,
`https://cog.readthedocs.io/en/latest/running.html`) — the closest fit, and the
shape I am taking. A generated region sits literally in the file between
markers, the generator is a comment, `-c` appends a checksum to the end marker,
and `--check` (3.3.0) exits nonzero if regeneration would change anything.
Right: the file is complete and readable with zero tooling, and drift is an
exit code. Breaks under our constraint: nothing — the cost is marker noise and
duplicated data, defended by the checksum. **Borrowed: the three-marker
structure, the checksum on the end marker, and `--check` as the primary verb.**

**myst-nb `glue`** (`https://myst-nb.readthedocs.io/en/latest/render/glue.html`)
— `{glue:text}`boot_mean:.2f`` and the cross-document form `nb.ipynb::key`.
Right: the key/format split — the artifact owns the digit, the sentence owns the
precision. Breaks: the raw page shows a placeholder where the number should be,
so a reader with no build gets nothing. **Borrowed: the key-plus-format split,
and the `artifact::key` qualified address. Rejected: the placeholder.**

**DVC metrics** (`https://doc.dvc.org/command-reference/metrics`) — metrics are
JSON/YAML/TOML trees and DVC "addresses specific metrics by the tree path".
Right: the unit of authority is a dotted key path into a committed file, which
is exactly what `.numbers` already is. Breaks: no prose side at all. **Borrowed:
the definition of the unit, and `metrics diff` — a changed number is a
reviewable event, not a silent update.**

**org-babel** (`https://orgmode.org/manual/Results-of-Evaluation.html`) —
`#+RESULTS:` writes the value back into the same plain-text file. Right: the
answer persists next to the question with no runtime. Breaks: nothing verifies
the result came from that block; hand-edit it and org is silent. **That gap is
exactly what cog's checksum closes, which settles the choice between them.**

**Quarto / R Markdown** (`https://quarto.org/docs/computations/inline-code.html`,
`https://www.danieldsjoberg.com/gtsummary/articles/inline_text.html`) — inline
`` `{r} radius` ``; the docs say inline expressions should be lookups of
pre-computed values, which is the same architectural split. `gtsummary`'s
`inline_text(tab, variable=, level=, column=, pattern=)` is a real key-path into
a result object. Rejected: the source shows an expression where the number goes,
and needs a live session.

**StatTag** (`https://pmc.ncbi.nlm.nih.gov/articles/PMC7660954/`) — the one tool
whose stated purpose is guaranteeing manuscript numbers match analysis output.
Its data model is a mapping table: tag name, location in the document, source
code, format. Right model. Rejected: it lives in `.docx` field codes — binary,
render-in-place, invisible in a text editor. **Borrowed: the mapping table.
cog's contribution is that the table can live inside the plain file.**

**statcheck** — a pure checker that recomputes reported statistics from
published prose and never writes into the document. **Borrowed: the posture.**

**MyST substitutions / Hugo shortcodes / dbt `{{ doc() }}`**
(`https://myst-parser.readthedocs.io/en/latest/syntax/optional.html`,
`https://gohugo.io/content-management/shortcodes/`,
`https://docs.getdbt.com/docs/build/documentation`) — all render-in-place.
Rejected for the same one reason: an LLM opening the raw file reads `{{ L_c }}`
and learns nothing, which violates `CLAUDE.md:275-277`.

**Content addressing** (`https://docs.ipfs.tech/concepts/content-addressing/`) —
identical bytes, identical identifier. Already the bench's practice via result
sha256 sidecars. Necessary under a value-level mechanism, insufficient alone: a
CID certifies which file you quoted and says nothing about the digit three
sentences later.

**Agents retyping numbers** — one direct hit, Grid-Mind (arXiv 2602.20683):
scan agent output for numeric assertions and gate them on whether a
grounding tool was actually called in that turn. The citation-grounding
literature (arXiv 2606.00898) carries the caution that matters here: **an
incomplete authority store manufactures false violations at a high rate** —
which is precisely the risk of `check_numbers_in_response.py` today, running
against a store of four files. The agent found no prior art on forcing an agent
to cite by key rather than by digit.

---

## 3 · The design

### §1 Canonical data

Three tiers. The distinction that matters: **authoritative**, **derived**, and
**committed** are three different properties, and today `.numbers` is being
asked to be all three.

**Tier 0 — the artifact.** The bytes a run produced: `results/*.json`,
`*.txt`, `*.log`, `*.csv`, a `.lean` file, a page of an imported PDF.
Authoritative because it is what the run wrote. Identity is its sha256. Never
edited (`Primebeat_081426/CLAUDE.md:219-220`). Bound to its invocation by
`results/runs/<utc>_<script>.json` (`utilities/run.py:23`), which already
records argv, interpreter, script sha256, git HEAD and dirty flag.

**Tier 1 — the value store, `<stem>.numbers`.** Flat `key<TAB>value`, header
`# sha256` / `# source`, exactly `utilities/flatten_results.py:8-19`. **Derived
and regenerable — therefore gitignored above a size threshold** (the measured
272 MB in §1.3h is the reason). Three changes:

1. *Escape the segment separator.* `flatten_results.py:75-77`'s `seg()` escapes
   `\`, tab and newline but not `.`, so a dict key like `k=10|eps=0.01` puts a
   non-structural dot in the flat key and the key is not re-parseable into its
   tree. Measured on one file:

   ```text
   leaves: old 5581  new 5581   values identical: True
   old keys whose dots are NOT all structural: 4113 of 5581
     key   theory.k=1|eps=0\.01.at_root.h
     parts ['theory', 'k=1|eps=0.01', 'at_root', 'h']
   ```

   A one-line change to `seg()`, plus a `# format 2` header line, plus a
   resolver that strips backslashes before comparing. Old citations keep
   resolving; only new stores gain structure. This is what makes §2's table
   projection possible at all.
2. *Emitters beyond JSON.* One per producer kind, same output format:
   `emit_json` (today's flattener); `emit_table` for a fixed-width `.txt` table,
   keyed `<table>.<row>.<column>` — this is where 509 of entry 302's numbers
   live and where none are checkable today; `emit_lean` for declaration line
   numbers and `#print axioms` output, which is the entry-303 class (twelve of
   the twenty-four measured brief errors were line references); `emit_log` for
   a `.log` line the entry cites.
3. *An authored store for values with no producer.* `notes/values/<slug>.numbers`,
   header `# kind authored` and a mandatory `# by <name> <date> <method>` line.
   Hand-computed values, literature constants, a figure read off a printed
   table. It is not verifiable against a producer; it is **attributable**, which
   is the honest ceiling, and it must never be silently mixed with derived
   stores — the header is what separates them.

**Tier 2 — the receipt, `notes/receipts/entry-<N>.numbers`. Committed.** The
durable binding between one entry and the values it cites. Fully qualified,
one artifact-sha header per source:

```text
# receipt entry 302   2026-09-02
# artifact weil_Lc_theory	analysis/2026-09-01/results/weil_Lc_theory.json	sha256 0077130f7b02…
weil_Lc_theory#theory.k=10|eps=0\.01.L_c_meas	3.070311505664645
```

Prototyped. For entry 302 it is 147 values across three artifacts, about
10 KB, generated in one command, and verifying the entry against it returns
`140 OK, 0 MISMATCH`. It does three things the `.numbers` file cannot:

- it kills the collision of §1.3e, because every line is qualified — the
  prototype flagged `params.L_grid[0]` and `meta.timestamp` as ambiguous
  instead of guessing;
- it survives the artifact being pruned, so an entry stays checkable after a
  multi-megabyte JSON leaves the tree;
- it is small enough to commit for every entry forever — about 3 MB at 300
  entries, against 272 MB for flattening everything.

**What makes a value authoritative:** the artifact's sha256, recorded in the
receipt, matching the artifact on disk; or, when the artifact is gone, the
receipt standing as the dated record of what the run produced. A hand-computed
value is authoritative by attribution and says so in its header.

**Judgement on `.numbers`.** Right in kind, wrong in three specifics:
unqualified keys, JSON-only, and committed at full size. Keep the format —
flat, greppable, parser-free, LLM-readable — and fix all three. It is not a
stopgap; it is an incomplete implementation of the right idea.

### §2 Reference and resolution

Two notations. Both leave the digits literally in the prose, so a reader with
no tooling sees the number; both are verified by a checker, never written by a
renderer.

**Scalar — `` `artifact#key` `` value.**

```text
the reference row reads `weil_Lc_theory#theory.k=10|eps=0\.01.L_c_meas` 3.0703
```

Unchanged in spirit from `notes/notes_format.md:48-52`; the artifact prefix is
new and is what §1.3e requires. The checker finds the backticked key, resolves
it in the entry's receipt, and compares the nearest number, rounding-aware at
the entry's own stated precision (`check_values.py:26-31`).

The other half — and the part that actually removes the retyping — is an
**insertion tool**. `utilities/cite.py` prints the exact citation string so no
model or person types a digit. Prototyped:

```text
$ cite.py 'weil_Lc_theory#theory.k=10|eps=0.01.L_c_meas'
`weil_Lc_theory#theory.k=10|eps=0.01.L_c_meas` 3.070311505664645

$ cite.py --sig 5 'weil_Lc_theory#theory.k=10|eps=0.01.L_c_meas'
`weil_Lc_theory#theory.k=10|eps=0.01.L_c_meas` 3.0703

$ cite.py 'params.L_grid[0]'
AMBIGUOUS `params.L_grid[0]`:
  weil_Lc_eps#params.L_grid[0] = 0.3
  weil_Lc_height#params.L_grid[0] = 0.3
  weil_Lc_mod#params.L_grid[0] = 0.3
  weil_Lc_theory#params.L_grid[0] = 0.02229612249207783
Qualify it: <artifact>#<key>
```

`--sig N` is myst-nb's format spec: the sentence owns the precision, the
artifact owns the digit.

**Block — cog's three markers.** For the 509 numbers per entry that live in
tables.

```text
<!-- values: slice analysis/2026-09-01/weil_Lc_theory.txt:134-141 -->
```text
  k=1     theory p  -0.2557 (R2 0.9675)   measured p  -0.0631 (R2 0.9897)
  …
```
<!-- end (sum: 35d5bd43d8) -->
```

Two generators. `slice <path>:<a>-<b>` is byte equality against those lines —
the cheapest form, no generator needed. `table <art>#<ns> cols=… sig=N`
projects a sub-table out of the key space, for the case entry 302 hit twice
where the full table is too wide:

```text
<!-- values: table weil_Lc_theory#theory cols=L_c_meas,at_root.h,at_root.n_near sig=5 -->
```

Both are regenerated and compared by `--check`. The prototype of the `slice`
form ran over entry 302 and separated the one byte-exact block from the two
hand-narrowed ones (§1.3c). The `table` form is why §1's escaped-dot change is
load-bearing: without it the row key `k=10|eps=0.01` cannot be told from a
structural path, and the projector produces an empty table — which is what my
first prototype run did, and is how the format defect was found.

**Rejected, one line each.**

- *Render-in-place* (`{{key}}`, MyST substitutions, Hugo shortcodes, dbt
  `{{ doc() }}`, Quarto `` `{r} x` ``): an LLM opening the raw file reads a
  placeholder instead of the number, which is the one thing `CLAUDE.md:275-277`
  forbids.
- *Two-file split* (authored `.src.md` + generated `.md`): the notebook is the
  coordination layer Julian reads and edits (`CLAUDE.md:10-15`); a generated
  notebook is not something he can edit, and the append-only rule then applies
  to a file no human writes.
- *org-babel `#+RESULTS:`*: right instinct, no verification — hand-edit the
  result and it is silent. cog's checksum is the same idea with the gate.
- *StatTag field codes*: binary, invisible in a text editor.
- *Renderer instead of checker, generally*: a renderer that writes into
  `lab_notebook_2.md` would be a program editing the append-only record. A
  checker cannot.

**What breaks under the chosen option.** The value can be stale between the
edit and the check. Closed by putting the check on `PostToolUse` (where
`gate.py` already sits, `.claude/settings.json:17-27`) rather than only at
commit — drift is then reported within one tool call.

### §3 Where the hops die

| hop | disposition | mechanism |
|---|---|---|
| 1 · JSON → agent report | **mechanised** | the report's factual content is a generated `## Values` block — a receipt fragment. Free prose states the *reading*, never a digit. `check_numbers_in_response.py` is strengthened from "the number exists in some `.numbers` file" to "the number is adjacent to a key that resolves". |
| 2 · report → chat | **eliminated for digits** | the orchestrator relays keys and the report's `## Values` block verbatim. When a value must be spoken, `cite.py` prints it. |
| 3 · chat → brief | **mechanised** | `utilities/brief.py` emits a `## Inputs` block: every path resolved and existence-checked, every line range verified against the file, every key's value read from the store, every sha computed. `check_agent_brief.py` is rewritten to require that block and to require every `path:line` and `` `art#key` `` in the prose to appear in it. Budget: 24 measured errors, of which 12 line refs + 5 values + 3 counts + 3 durations = **20 of 24** are things a generated block cannot get wrong. |
| 4 · brief → entry | **mechanised + gated** | `cite.py` for scalars, block markers for tables, receipt generated at write time, `check_prose_numbers.py` at `PostToolUse` and at `pre-commit`. |
| 5 · entry → `CONTEXT.md` | **gated — new** | `CONTEXT.md:255-709` carries 1061 numeric tokens outside fences and **no gate touches one of them**. The same checker runs over `CONTEXT.md`, resolving against receipts. Baseline-ratcheted like `refs_baseline.txt` so an imperfect file still commits and cannot get worse. |
| 6 · entry → `papers/` | **gated — extended** | `papers/*.md` carry 3335 numeric tokens outside fences across 15 files. `check_values.py` covers only statements whose source line names an artifact and skips derived ones (`check_values.py:44-52`, `papers/FORMAT.md:38-44`). Extend it to resolve `art#key` citations against receipts, keeping the artifact-scan as the fallback. |

**What replaces retyped digits in prose that is prose by nature.** An agent
report and a chat message both get a two-part shape: a generated block that
carries every fact, and free prose that carries only the reading. The rule is
stateable in one line — *prose asserts relations, blocks carry values* — and it
is checkable, because a citable number in the prose half must sit beside a key.

### §4 Folders and layout

At `~/GitHub/` — the portability argument. The mechanism exists today in
exactly one of sixty-plus projects. `eval_harness`, `pruned_neural_lineages`,
`the_container` and `miep_parser` all hold results and none has a checker.
`CLAUDE.md:275-277` makes the flat tree the substrate; a mechanism that lives
in one project is not in the substrate.

```text
~/GitHub/
  CLAUDE.md  CONTEXT.md  REFERENCES.md            authored, committed
  AGENT_CLAUDE.md  NOTEPAD_TEMPLATE.md            authored, committed
  VALUES.md                                       NEW — the one-page citation contract
  tools/                                          NEW — one copy, every project reaches it
    cite.py  flatten.py  receipt.py  table.py
    brief.py  check_prose_numbers.py
    emit_table.py  emit_lean.py  emit_log.py
  tools/hooks/                                    NEW — the shared hooks
    check_agent_brief.py  check_protected_write.py
    check_bash_guard.py   check_prose_numbers_stop.py
```

Resolution order: a project's own `utilities/` wins; `~/GitHub/tools/` is the
fallback. Primebeat keeps its own until the migration retires the duplicates.

Inside a project:

```text
<project>/
  CLAUDE.md CONTEXT.md REFERENCES.md NOTEPAD.md   authored, committed
  AGENT_CARD.md                                   authored, committed
  values.toml                                     NEW — authored, committed (see §6)
  notes/
    lab_notebook*.md  NOTEPAD.md  notes_format.md authored, committed
    receipts/entry-<N>.numbers                    GENERATED, committed  (~10 KB each)
    values/<slug>.numbers                         AUTHORED, committed  (hand values)
  results/
    *.json *.log *.txt *.csv                      artifacts, committed
    runs/<utc>_<script>.json                      run manifests, committed
    *.numbers                                     DERIVED, gitignored
  analysis/<date>/
    *.py *.md                                     authored, committed
    results/*.json|log|txt                        artifacts, committed
    results/*.numbers                             DERIVED, gitignored
```

`mkdir -p ~/GitHub/tools/hooks` and, per project,
`mkdir -p notes/receipts notes/values`. Two `.gitignore` lines:
`results/*.numbers`, `analysis/*/results/*.numbers`.

The one judgement call: **`.numbers` becomes gitignored.** It is regenerable
from a committed artifact by a committed tool, the receipt carries what must
survive, and committing it costs the 272 MB of §1.3h. Where an artifact is
itself gitignored (`.gitignore:6-12` excludes three large O24 JSONs) its
`.numbers` is committed instead — that is the one exception, and `values.toml`
declares it.

### §5 Gates — full inventory

**Surviving unchanged.**

| invariant | where | on fire |
|---|---|---|
| a protected path needs a one-use flag | PreToolUse `check_protected_write.py:70-94` | deny, name the flag |
| a locked prereg's pre-image is recoverable | pre-commit 4 → `check_sidecar.py` | block |
| a new results writer is clobber-safe | pre-commit 3 → `check_results_guard.py` | block |
| every `.numbers` header matches its JSON | pre-commit 5, `audit.yml:28-37` | block |
| references resolve, no worse than baseline | pre-commit 1, `audit.yml:23-26` | block |
| a commitment-file change carries `.approve/` | pre-commit 7 | block |
| the toolchain weld is textual | `check_weld.py`, by hand | report |

**Changing.**

| hook | change | why, measured |
|---|---|---|
| `check_agent_brief.py` | replace digit-denial with "carries a generated `## Inputs` block, and every path/line/key claim appears in it" | denies 2 of 24 real brief errors today (§1.3d) |
| `check_numbers_in_response.py` | strengthen from "in some `.numbers` file" to "adjacent to a resolving key"; scan inside fenced blocks that carry markers | the current invariant weakens as stores multiply, and arXiv 2606.00898 says a thin authority store also manufactures false violations |
| `check_direct_run.py` | widen `DIRECT` (`:64-66`) to any `.py` under a declared measurement root, path-qualified included | 36 manifests, newest 2026-08-28, while six runs landed 2026-09-01/02 |
| `check_bash_guard.py` | add `cp`, `mv`, `install`, `ln` destination parsing; deny `python3 -c` / `-` / heredoc whose text names a protected basename | its own docstring `:25-27` admits the hole |
| `gate.py` | add the prose-number check so drift is reported within one tool call, still advisory (`:29`) | today drift is invisible until commit |
| `check_values.py` | resolve `art#key` against receipts, keep the artifact scan as fallback | 3335 ungated tokens in `papers/` |

**Wrong.**

- `check_read_range.py` — it is a context-budget rule wearing a correctness
  hook's clothes. It denied a brief's explicit instruction to read
  `~/GitHub/CLAUDE.md` **in full**, forcing two ranged reads and a stitch, which
  is the recall failure `Primebeat_081426/CLAUDE.md:65-68` exists to prevent.
  Make it advisory, or raise `LIMIT` (`:29`) and honour an explicit brief
  instruction. Cost of leaving it: an agent told to read a spec whole cannot.
- `check_response_prefix.py` — a compliance probe, not a data gate. Out of
  scope for this design; flagged only so the inventory is complete. Julian's
  call.

**New — invariants with no gate today.**

| invariant | where | on fire |
|---|---|---|
| every citable number in an entry sits beside a resolving key | PostToolUse (advisory) + pre-commit (block) | name the number and the entry line |
| a marked block regenerates byte-identically | same | print the first differing line |
| every entry has a receipt, and it verifies | pre-commit, on entries added in the staged diff | block |
| numbers in `CONTEXT.md` resolve to a receipt | pre-commit, baseline-ratcheted | block on new breaks only |
| numbers in `papers/` resolve to a receipt | pre-commit, baseline-ratcheted | block on new breaks only |
| every committed results JSON has a run manifest | pre-commit, baseline-ratcheted | block on new only |
| every results JSON has a `.numbers` or a declared exemption | pre-commit | block |
| a `.txt` table agrees with its JSON | `emit_table` + `--check`, CI | block |
| a script records its environment | `run.py` writes it into the manifest | warn |
| a receipt's artifact sha matches disk | CI | block |

**The two named holes.**

*Shell routes around the write guard.* `cp`, `mv`, `install`, `ln` and
`python3 -c` writes bypass `check_bash_guard.py` (`:25-27`). Destination
parsing closes the first four. The durable fix is destination-parser-free: a
`PostToolUse` **integrity check** that hashes every protected file before and
after every tool call and blocks on an unapproved change. Sketch of the
discharge: the protected set is already enumerable (`check_protected_write.py:70-94`),
it is a few dozen files, hashing them is milliseconds, and the hook already has
a `PostToolUse` slot registered. This catches every route, including ones
nobody has thought of, and it is the only shape that does.

*A hook cannot be patched from inside a session*, because the running version
polices the edit (`check_protected_write.py:90-91`). That is correct and should
stay. What is missing is a way to *stage* a change for review. Add
`utilities/hooks/proposed/` — an unregistered directory agents may write, which
pre-commit refuses to promote, and which `utilities/promote_hook.py`, run by
Julian from his terminal, moves into place only after the file's own
`--selftest` exits 0. Discharge sketch: every hook already has `--selftest`
(`check_bash_guard.py:225-269`, `check_protected_write.py:136-171`,
`check_agent_brief.py:66-80`, `check_read_range.py:56-66`); the promoter is
twenty lines and a `.approve/` flag.

### §6 Config

Today "which directories hold results" is hardcoded in three places that must
agree: `check_numbers_in_response.py:77-86`, `pre-commit:85-87`,
`audit.yml:30-32`. A model can talk itself out of a paragraph of instructions;
it cannot talk itself out of a file three gates read. Propose
`<project>/values.toml`:

```toml
schema = 1

[layout]
notebook        = "notes/lab_notebook_2.md"
receipts        = "notes/receipts"
authored_values = "notes/values"
prose           = ["notes/lab_notebook_2.md", "CONTEXT.md", "papers/*.md"]

[[artifacts]]
glob      = "results/*.json"
emitter   = "json"
manifests = "results/runs"

[[artifacts]]
glob    = "analysis/*/results/*.json"
emitter = "json"

[[artifacts]]
glob    = "analysis/*/*.txt"
emitter = "table"

[store]
committed = false                       # .numbers is derived
commit_when_artifact_ignored = true     # except then
format = 2                              # escaped-dot segments

[entries]
header       = '^## \d{4}-\d\d-\d\d — Entry (\d+)'
newest_first = true
append_only  = true

[gates]
prose_numbers  = "block"
transclusions  = "block"
receipts       = "block"
context_md     = "baseline"             # ratchet, do not block the backlog
papers         = "baseline"
run_manifests  = "baseline"

[precision]
default_sig = 5

[exempt]
artifacts = ["results/O24_gen_xmax3e9_results.json"]   # gitignored, .numbers committed
keys      = ["meta.timestamp", "meta.hostname"]
```

Every field above corresponds to something currently hardcoded or written in
prose. `~/GitHub/tools/` reads `values.toml` and falls back to defaults, so a
project with no config still works — which is what makes the tools portable to
the other sixty projects.

### §7 Agent interface

**Judgement on `AGENT_CARD.md`.** Right idea, and `CLAUDE.md:30-38` already
adopts it system-wide as of 2026-09-02: point the agent at a card, cite line
ranges, carry `.numbers` keys rather than pasted numbers. It cut per-spawn
context, which is real. Its limit is measured: its `## Numbers` section
(`AGENT_CARD.md:26-35`) is six lines of prose, and 22 of 24 brief errors passed
straight through the gate that backs it. **A card instructs; it does not
constrain.** Extend it with a block that is mechanically checked.

**The brief, downward.** Two parts.

```text
Read /Users/juliansambrano/GitHub/Primebeat_081426/AGENT_CARD.md first, then
/Users/juliansambrano/GitHub/AGENT_CLAUDE.md.

## Inputs                       <- GENERATED by tools/brief.py, verbatim
path   analysis/2026-09-01/weil_Lc_theory.py:370-380   sha256 ddc7ca7189ea…
entry  notes/lab_notebook_2.md:254-634                 Entry 302
value  weil_Lc_theory#theory.k=10|eps=0\.01.L_c_meas   3.070311505664645
value  weil_Lc_theory#meta.timings.total_s             50.62220001220703
store  analysis/2026-09-01/results/weil_Lc_theory.numbers  sha256 0077130f7b02…

## Task                         <- AUTHORED. No claim about artifact content.
Read the rows above and say whether the far-tail slope reproduces the measured
one. Do not stamp a verdict.
```

`brief.py` resolves every path, verifies every line range exists, reads every
value from the store, and computes every sha at emit time. The hook requires
the `## Inputs` block and requires every `path:line` and `` `art#key` `` in the
Task half to appear in it. The twelve line-reference errors and the five value
errors of §1.3d become impossible rather than discouraged.

**The report, upward.** Same two parts, inverted.

```text
## Values                       <- GENERATED by tools/receipt.py --fragment
weil_Lc_theory#fits.0\.001.far_only_exact.b   1.7543…
weil_Lc_theory#fits.0\.001.measured.b         1.7686…

## Reading                      <- AUTHORED. Relations, no digits.
The far-tail slope matches the measured slope to better than one percent at the
smallest epsilon; the intercepts do not match.
```

The orchestrator relays the `## Values` block verbatim into the next brief.
**No digit is retyped in either direction, because in both directions the
digits are in a block a program wrote.** The Stop hook enforces the report
half; `check_agent_brief.py` enforces the brief half.

### §8 What this does not fix

Plainly, and none of these is small.

1. **A wrong number, correctly transcribed.** Entry 300's "linear in γ_k" and
   its detection-magnitude figure were artefacts of one basis family, corrected
   two entries later. Every gate here would have passed them at every hop. The
   store guarantees provenance, never correctness.
2. **A right number attached to the wrong claim.** `check_refs.py:10-13`
   already records this failure for references — entry 88, a section cited for
   a claim it does not make. `` `art#key` `` beside the wrong noun is the same
   hole one level down, and no checker reads meaning.
3. **Slice-then-aggregate.** Entry 219's maximum, wrong by a factor of 2.3 and
   standing for four entries, never entered a file — it happened in a throwaway
   `python3 -c` that printed six of seventeen rows
   (`check_direct_run.py:14-19`). A value store cannot see what was never
   written.
4. **Qualitative drift.** Four of the twenty-four measured brief errors are
   claims in words about numbers — "identical", "all eight", "two to four
   times", "the band starts at X = 9". No digit gate touches them, and I do not
   have a mechanism that would.
5. **Precision theatre.** Citing a key and quoting more digits than the
   measurement supports passes every check here.
6. **Reproduction.** `container_audit_report.md:583-586` — nothing in this tree
   has been re-run from a clean checkout. Every sha proves what was produced
   and nothing about whether it reproduces. This design binds prose to
   artifacts; it does not bind artifacts to reality.
7. **Julian's synthesis.** The verdict line, the status transition, the outcome
   marking. Deliberately untouched.
8. **The authored store.** A hand-computed value is attributable, not
   verifiable. That is the ceiling, and the header is the only honest thing to
   do about it.

---

## 4 · Migration

Each row is a state that is green on its own and committable on its own.
Nothing requires rewriting an entry: old entries keep the unqualified key form,
old fences stay unmarked and unchecked, and every new gate is
baseline-ratcheted so the backlog never blocks a commit. No step retitles or
edits an existing entry; corrections, if any are needed, are new entries
(`AGENT_CARD.md:9-11`).

| # | step | cost | buys |
|---|---|---|---|
| 1 | `values.toml` at the Primebeat root; the three hardcoded result-globs read it | half a day; a config file and three call-site edits | one place to change; the precondition for every step below |
| 2 | `flatten.py` format 2 — escaped-dot `seg()`, `# format 2` header, resolver strips backslashes on compare | one line plus a resolver branch; regenerate the four stores | keys re-parseable into their tree; old citations still resolve; unblocks step 6 |
| 3 | `.numbers` becomes derived: gitignore it, commit the exemptions `values.toml` declares, add a CI regeneration check | one `.gitignore` edit, one CI step | ~272 MB never enters the repo; the store stops pretending to be the record |
| 4 | `cite.py` + `receipt.py`; generate receipts for entries 298–303 only | a day; two utilities, both prototyped | the digits are copied by a program from here on; the collision of §1.3e becomes an error instead of a guess |
| 5 | `check_prose_numbers.py` over the notebook, resolving against receipts; wire to `gate.py` (advisory) and pre-commit (block, on entries added in the staged diff) | a day; replaces `check_entry_numbers.py` | drift caught within one tool call rather than at commit; the value-then-key and Lean-identifier false positives go away with the receipt |
| 6 | `table.py` — `slice` and `table` block markers with cog checksums; `--check` in pre-commit and CI | a day; prototyped | the 509 ungated numbers per entry become gated; ~11% coverage rises past 90% |
| 7 | `brief.py` + rewrite `check_agent_brief.py` around the `## Inputs` block | a day | 20 of the 24 measured brief errors become impossible |
| 8 | strengthen `check_numbers_in_response.py` to key-adjacency; add the `## Values` report block to `AGENT_CARD.md` | half a day | hops 1 and 2 stop carrying loose digits |
| 9 | `emit_table.py`, `emit_log.py`, `emit_lean.py`; backfill stores for the four JSONs that have none | a day | entry 298 becomes checkable; the twelve line-reference errors get a store |
| 10 | extend the prose checker to `CONTEXT.md` and `papers/`, both baseline-ratcheted | half a day | 1061 + 3335 ungated tokens come under a ratchet that cannot get worse |
| 11 | widen `check_direct_run.py`; add environment capture to `run.py`'s manifest; baseline-ratchet "every results JSON has a manifest" | half a day | audit findings 2, 4 and 7 get a floor |
| 12 | `utilities/hooks/proposed/` + `promote_hook.py`; extend `check_bash_guard.py` to `cp`/`mv`/`ln`/`install`/`-c`; add the `PostToolUse` integrity check | a day | the two named holes close; hooks become patchable under Julian's approval |
| 13 | move the tools to `~/GitHub/tools/`, leave Primebeat's `utilities/` as thin shims, write `~/GitHub/VALUES.md` | a day | the mechanism reaches the other sixty projects; the contract is reconstructible from root `CLAUDE.md` + `VALUES.md` + a project's `CLAUDE.md` alone |
| 14 | adopt in one second project (`eval_harness` has the four commitment files and a `results/`) | half a day | proves the config generalises; falsifies the design cheaply if it does not |

Steps 1–6 are the load-bearing half: they take the notebook from about one
digit in nine verified to nearly all of them. Steps 7–8 close the brief and
report hops, which is where the measured drift actually is. Steps 9–14 are
completion and portability.

**Where Julian's approval is required, explicitly:** step 1 adds a file at the
project root; steps 5, 10 and 12 change gates that can block his commits; step
13 edits root `CLAUDE.md`'s pointer set and adds `~/GitHub/VALUES.md`; and any
step that touches `CLAUDE.md`, `CONTEXT.md` or `REFERENCES.md` needs the
`.approve/` flag he creates from his own terminal
(`Primebeat_081426/CLAUDE.md:224-225`, `pre-commit:129-143`).
