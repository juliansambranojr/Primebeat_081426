# Systems architecture v2 — data flowing unchanged through prose

Design only. Nothing here is built; nothing in the tree was modified.
Standalone — a reader needs no prior document. Written 2026-09-02 against the
tree at `379c97d`, after an adversarial read
(`analysis/2026-09-02/adversary_report.md`, Part Two: 3 BREAKS, 7 WEAKENS,
2 HOLDS) that I treat as correct by default, and after a read-only inventory of
`eval_harness/` and `the_container/` commissioned for the consolidation half.

Every claim about the current system carries a `file:line`. Every measurement
is one I ran in this session and is printed in a fenced block.

**One finding outranks everything else in this document and is new.** The live
Stop hook that both this design and its predecessor lean on —
`utilities/hooks/check_numbers_in_response.py`, wired at
`.claude/settings.json:10-13` — accepts 95% of randomly invented three-decimal
numbers. It is measured in § 5.1. It is the same failure `the_container`
benched and rejected on 2026-08-30, and it gets worse under one of this
document's own decisions. It is migration step 1.

---

## 1 · The principle

A measured value is written once, by a program, into an artifact. Everything
downstream — an agent's report, a chat message, a brief, a notebook entry,
`CONTEXT.md`, a paper — names that value and does not restate it. Where prose
must show the digits, a program puts them there and a gate proves they still
match. The prose stays plain markdown in a flat tree, readable by any LLM with
no tooling, because that is the load-bearing substrate
(`/Users/juliansambrano/GitHub/CLAUDE.md:275-277`), so the mechanism is
**check-in-place**, never render-in-place. The same rule governs the files
themselves: a fact has exactly one home, and every other file that needs it
either points at that home or is generated from it. And a check is bound to
**the command that produced the value**, never to a pool of values that happen
to exist somewhere in the tree — that distinction is what § 5.1 measures and
what most of this design turns on.

Julian keeps synthesis — the verdict, the status transition, the outcome
marking, every commitment-file edit (`CLAUDE.md:46-47`, `:118-121`,
`Primebeat_081426/CLAUDE.md:146-148`, `preregs/FORMAT.md:51-54`). The notebook
is append-only; corrections are new entries; old entries are never retitled or
renumbered (`AGENT_CARD.md:9-11`). Nothing load-bearing lives only in
Claude-specific tooling (`CLAUDE.md:292-297`). Every proposal below is
additive under those four constraints.

---

## 2 · The file inventory, and the minimal set

### 2.1 What exists

```text
ROOT  /Users/juliansambrano/GitHub/
  CLAUDE.md              310 lines   15,741 B      AGENT_CLAUDE.md   113 lines
  CONTEXT.md              64 lines    8,161 B      NOTEPAD_TEMPLATE.md 21 lines
  REFERENCES.md           70 lines    4,518 B

PROJECT  Primebeat_081426/
  README.md              179    8,132 B   CLAUDE.md            258   11,755 B
  CONTEXT.md             762   48,711 B   REFERENCES.md        174    8,450 B
  AGENT_CARD.md           49    2,288 B   container_audit.md   165    7,333 B
  claude_writer.md        49    1,945 B   claude_notes.md       57    2,240 B
  notes/NOTEPAD.md       644  137,566 B   notes/notes_format.md 57    2,443 B
  notes/lab_notebook.md 3371  158,280 B   (entries 1–44, closed)
  notes/lab_notebook_2.md 18267 929,322 B (45 onward)
  papers/FORMAT.md        50    1,844 B   preregs/FORMAT.md    101    5,135 B
  lean/THEOREMS.md       520   43,576 B   GENERATED
  lean/BUILD.md, lean/NEXT.md               authored

CLAUDE-SPECIFIC  ~/.claude/projects/…/memory/
  MEMORY.md + 3 project notes  ·  MEMORY.md + 7 root-scope notes
```

### 2.2 Double work in this project — measured

Every row is a fact stated in more than one hand-maintained file.

**D1 · The Lean bench module count. Five files, four answers.**

```text
CLAUDE.md:253             "lean/ — 14 modules"
README.md:34,:104         "20 modules, 250 theorems"
CONTEXT.md:714            "the bench, 20 modules, 250 theorems"
lean/BUILD.md:8,:98,:123  "all 24 modules"
lean/THEOREMS.md:6        "333 theorems across 27 modules"    [GENERATED]
ls lean/*.lean | wc -l -> 27
```

The one generated file is the one that is right.

**D2 · The theorem total.** `CONTEXT.md:279-280` "327"; `lean/THEOREMS.md:6`
"333". `CONTEXT.md:714`/`:734` decompose 327 as 250 + 77 over 20 + 8 = 28
modules — internally consistent, wrong on both axes.

**D3 · The leaf ledger. Two commitment files carry a ledger the notebook
retired.**

```text
CLAUDE.md:166    "as of entry 141 it reads {hEF, StmtArgCrude}"
CONTEXT.md:748   "The leaf ledger is `{hEF, StmtArgCrude}`."
lab_notebook_2.md:3670
  "## 2026-08-29 — Entry 271 — hEF DISCHARGED: the truncated explicit
   formula, proved sorry-free and welded to the ledger"
```

`CLAUDE.md:165` states the correct rule — "the ledger lives in the newest
notebook entry that touched it" — and the next line hardcodes a snapshot that
has been wrong for four days. The rule is right; the copy beside it is the
defect.

**D4 · Scale.** `CONTEXT.md:277` "165 notebook entries"; actual 43 + 260 = 303
headers plus entry 304. Same sentence: "14 papers, six preregs" against
`ls papers/*.md` = 15 and `ls preregs/*.md` = 12.

**D5 · "Agents append; transitions are Julian's." One invariant, eight
statements, none generated.** Root `CLAUDE.md:118-121`;
`NOTEPAD_TEMPLATE.md:3-4`; project `CLAUDE.md:226-227` **and** `:233-234` (the
same file, twice); `AGENT_CARD.md:9-11`; `notes/notes_format.md:5-7`;
`notes/NOTEPAD.md:3-4`; `claude_notes.md:8-10`. It has not drifted. It has
eight chances to.

**D6 · Agent orientation, three files.** `AGENT_CARD.md` is the current first
move (root `CLAUDE.md:30-38`). `claude_writer.md:5-6` and `claude_notes.md:5-6`
each carry their own copy of the orientation preamble, then add a
role-specific sequence. The preamble duplicates; the sequences do not.

**D7 · A committed instruction a committed hook forbids.**
`container_audit.md:10` instructs: read `Primebeat_081426/CLAUDE.md` **in
full**. `check_read_range.py:29` sets `LIMIT = 120` and `:50-53` denies a
whole-file read of a commitment file above it; `CLAUDE.md` is 258 lines. I hit
the same wall on the root `CLAUDE.md` (310 lines) in this session.

**D8 · Counts in `README.md`.** `README.md:34`, `:104`, `:123` restate D1's
counts. `README.md:104` points at the generator — "see `lean/THEOREMS.md` for
the index" — while restating the number the generator owns.

### 2.3 The same pattern in two other projects — independently found

A read-only inventory of `eval_harness/` and `the_container/` was commissioned
so the design generalises past one repo. Its conclusion, reached without
seeing § 2.2:

> **The reliable predictor of staleness is an authored count of a generated
> thing.** Every disagreement found has that shape. The one restatement that
> has not drifted is the one that is mechanically derived.

Instances, with the inventory's citations:

```text
the_container/CONTEXT.md:38      "the ten rules"        AGENT.md has 13
                                  (:40 records that an earlier version said
                                   nine — the correction fixed the number and
                                   left the new number wrong)
the_container/REPO_MAP.md:119    "2,769 nodes · 5,398 edges"
  vs  map/INDEX.md:7 (GENERATED) "2889 nodes, 5713 edges"
the_container/REPO_MAP.md:38     "20 open threads"      NOTEPAD.md has 29
the_container/FLOW.md:22         "Measured 2026-08-30: 20 lines"
the_container/REPO_MAP.md:37     "18 claims"            CLAIMS.md has 20
eval_harness/CONTEXT.md:94-96    "scaffold phase. No runs yet."
  vs  39 run dirs on disk and README.md:12 "Production-grade state"
eval_harness/experiments/INDEX.md:21-22  two rows "pending"
  vs  lab_notebook.md:2848, :2633 — both closed the same day INDEX was created
```

Three facts from those trees that this design must accommodate:

1. **Notebook order is not a constant.** `eval_harness/CLAUDE.md:102`
   newest-first; `the_container/AGENT.md:118` oldest-first. Both deliberate,
   both stated in the contract file. The addressing scheme of § 3.3 is
   order-independent, which is a virtue rather than an accident.
2. **The contract file has three names.** `CLAUDE.md`, `AGENT.md`, and
   `the_container/README.md:47`: "Rename it `CLAUDE.md` or `CONTRACT.md` if
   your tooling prefers; the gate accepts all three." Any tool that reads
   config out of the contract file (§ 3.4) must accept the set.
3. **A generated file with an authored section carries the stale number.**
   `the_container/GAPS.md:3-5` declares "Never hand-edited — a hand list goes
   stale and then gets defended", and `GAPS.md:53` — inside a section `:48`
   labels "Authored, not measured" — says the battery is 44 questions where
   `CLAIMS.md:30` and `REPO_MAP.md:120` say 45. **`STATE.md` (§ 2.5) therefore
   admits no authored section at all.**

And one more, which is the sharpest: **two generated files regenerated at
different times disagree.** `the_container/GAPS.md:33` says 19 concepts,
`BACKFILL.md:37` says 20 and lists 20; both declare themselves never
hand-edited. Regeneration must be atomic across everything derived from one
source, and gated — which is § 5's `STATE.md` row.

`the_container` had already written the rule this whole section rediscovers.
`BLUEPRINT.md:548-552`: "Two homes, no rule for which wins, guaranteed drift.
Before writing a new governing document, check whether the authoritative home
already exists." And `BACKFILL.md:4-5` states the correct split in one line:
"The counts live in the record; this is the list they were counting."

### 2.4 The minimal set

The rule: **a file is authored if a person's judgement is its content; a file
is generated if a program can produce it from something else.** A generated
file is not a file anyone maintains.

**Root — 4 authored files.**

| file | a/g | owns exclusively |
| --- | --- | --- |
| `CLAUDE.md` | authored | the system-wide contract; the NOTEPAD line format absorbed from `NOTEPAD_TEMPLATE.md`; the citation contract |
| `CONTEXT.md` | authored | how Julian works — voice, decision posture, session patterns. No overlap with any project file. |
| `REFERENCES.md` | authored | the program's principles and worked examples. No overlap. |
| `AGENT_CLAUDE.md` | authored | a spawned agent's envelope and precedence rules |

`NOTEPAD_TEMPLATE.md` **merges** into root `CLAUDE.md § NOTEPAD format`: 21
lines, already pointed at by `CLAUDE.md:126`, already restated in every
project's `NOTEPAD.md` header. Folding it makes `CLAUDE.md:308-310` — "reading
`~/GitHub/CLAUDE.md` plus the relevant project's `CLAUDE.md` … reconstruct the
entire operating contract" — literally true rather than true via a pointer.
**A commitment-file edit; Julian's approval.**

**Project — 14 authored, 4 generated.**

| file | a/g | owns exclusively | loses |
| --- | --- | --- | --- |
| `CLAUDE.md` | authored | project rules, permissions, conventions, the config block (§ 3.4) | the Pointers counts (`:253`); the ledger snapshot (`:166`), keeping the rule at `:165`; the duplicate transitions rule at `:233-234` |
| `CONTEXT.md` | authored | the blueprint — what each test measures and why, the output schema, the caches | § Current state of the world's counts, inventories, statuses → `STATE.md` |
| `REFERENCES.md` | authored | cited documents, sibling repos, constants, packages | nothing |
| `AGENT_CARD.md` | authored | agent orientation + a `§ Roles` section absorbing `claude_writer.md`, `claude_notes.md` | nothing |
| `notes/notes_format.md` | authored | entry header, seven-type vocabulary, the citation conventions of § 3 | nothing |
| `notes/lab_notebook*.md` | authored, append-only | the dated record | nothing |
| `notes/NOTEPAD.md` | authored | the live-thread index | nothing |
| `papers/FORMAT.md` | authored | paper structure and the source-line rule | nothing |
| `preregs/FORMAT.md` | authored | what earns a verdict; naming; lock-commit-run | nothing |
| `container_audit.md` | authored | the audit procedure | its `:10` full-read instruction (D7) |
| `lean/BUILD.md` | authored | how to build | its module counts → transcluded |
| `lean/NEXT.md` | authored | the Lean work order across a compaction | nothing; a handoff, not a fact store |
| `README.md` | authored | the public face | its counts → transcluded |
| `notes/values/*.numbers` | authored | hand-computed values, with attribution (§ 3.1c) | — |
| **`STATE.md`** | **GENERATED** | every count, inventory and status | — |
| `lean/THEOREMS.md` | GENERATED | the theorem index (already correct) | — |
| `notes/receipts/entry-N.numbers` | GENERATED | the value binding per entry | — |
| `results/**/*.numbers` | GENERATED | the flat value store | — |

**Merged away:** `claude_writer.md`, `claude_notes.md` → `AGENT_CARD.md §
Roles`; root `NOTEPAD_TEMPLATE.md` → root `CLAUDE.md § NOTEPAD format`.
**Deleted:** nothing — every removal above is a merge.
**Untouched:** `~/.claude/…/memory/`. Its three project notes each restate a
rule that already lives in `Primebeat_081426/CLAUDE.md`, which is exactly what
`CLAUDE.md:292-297` requires. No load-bearing content may be added there.

### 2.5 `STATE.md` — the new generated file

It exists because § 2.2 and § 2.3 measure the same thing in three independent
trees: **every drifted fact is a count, an inventory or a status; no judgement
has drifted anywhere I looked; and the only files whose counts are right are
the generated ones.** It answers: *what is in this tree right now?*

Owned exclusively by `STATE.md`, removed from every authored file: notebook
entry counts and the newest entry per volume; NOTEPAD thread counts by status;
Lean module/theorem/pin counts per package, from `THEOREMS.md`; paper, prereg
and script counts; the prereg status table including which sidecars verify
(from `check_sidecar.py`); the leaf ledger, extracted from the newest entry
that declares one; coverage — which artifacts have a store, which entries have
a receipt; the environment, from the newest run manifest.

**`STATE.md` has no authored section.** That is a hard rule and § 2.3's
`the_container/GAPS.md § G` is why. **`STATE.md` states no judgement**: a
number in it is a count of something on disk; a status is read from the file
that owns the status. Where a status is Julian's to set — a verdict, a NOTEPAD
transition — it reports what is *written*, never what should be.

---

## 3 · Format decisions

Each is defended against `CLAUDE.md:275-277` — plain markdown in a flat tree,
readable by any LLM with no tooling, no hidden state.

### 3.1 The value store — `<stem>.numbers`, flat `key<TAB>value`

Shape unchanged from `utilities/flatten_results.py:8-19`, because the shape is
right: no parser, greppable, one value per line. Three changes.

**(a) Escape the segment separator.** `flatten_results.py:75-77`'s `seg()`
escapes `\`, tab and newline but not `.`, so a dict key like `k=10|eps=0.01`
puts a non-structural dot in the flat key and the key cannot be split back into
its tree. Measured on `weil_Lc_theory.numbers`:

```text
leaves: old 5581  new 5581   values identical: True
old keys whose dots are NOT all structural: 4113 of 5581
  (criterion: the key contains `|` and a dot followed by a digit)
  key   theory.k=1|eps=0\.01.at_root.h
  parts ['theory', 'k=1|eps=0.01', 'at_root', 'h']
```

One line in `seg()`, a `# format 2` header, and a resolver that strips
backslashes before comparing, so every citation written before today keeps
resolving.

**(b) Emitters beyond JSON.** Same output format: `emit_json` (today's
flattener), `emit_log` for a `.log` line an entry cites, `emit_lean` for
declaration line numbers and `#print axioms` output. `emit_table` for
fixed-width `.txt` is **demoted** — § 3.6.

**(c) An authored store.** `notes/values/<slug>.numbers`, header
`# kind authored` and a required `# by <name> <date> <method>`. Not verifiable
against a producer; **attributable**, which is the honest ceiling, and the
header is what keeps it from being mistaken for a measurement.

**Committed, under a byte ceiling.** v1 proposed gitignoring the store. The
adversary was right on both counts and I reverse the call. All five stores are
already git-tracked; the ratio on the tree's own pairs is not what v1 used:

```text
weil_Lc_theory   178,122 ->    358,863   2.0147
weil_Lc_eps      596,874 ->  1,134,753   1.9012
weil_Lc_height 2,403,163 ->  4,803,979   1.9990
weil_Lc_mod    1,547,190 ->  3,013,422   1.9477
arrow_price       28,359 ->     36,419   1.2842
aggregate      4,753,708 ->  9,347,436   1.9663   (all five git-tracked)
results JSONs in tree: 194,609,475 B = 185.6 MB
```

The realised saving from gitignoring is 8.9 MB, not the 272 MB v1 claimed —
that figure is the cost of flattening all 185.6 MB, which v1 already rejected
doing, and on the correct ratio it is 365 MB. More decisively: a store with
5,581 leaves of which a receipt cites 147 would leave over 97% of its values
unreadable on a fresh clone without running a tool. That is precisely the
reader `CLAUDE.md:275-277` protects, and the reader who finds an *uncited*
value by grep. So the store stays committed, with a **byte ceiling in config**;
above it, or where the artifact is itself gitignored (`.gitignore:6-12` prunes
three large O24 JSONs), the config names the exception and the digest (§ 3.2)
is committed in its place. No `git rm --cached` on tracked content, in a tree
whose CANNOT list (`CLAUDE.md:219-220`) is built around not removing artifacts.

**One interaction, and it is the reason § 5.1 is step 1.** Committing more
stores enlarges the pool that `check_numbers_in_response.py` matches against,
and that hook is already 95% permissive. Key-adjacency removes the interaction
entirely, because adjacency is a per-citation check and never a pool-membership
test. The store decision is only safe *after* step 1.

### 3.2 The receipt — `notes/receipts/entry-N.numbers`, committed

The permanent binding between one entry and the values it cites:

```text
# receipt entry 302   2026-09-02
# artifact weil_Lc_theory	analysis/2026-09-01/results/weil_Lc_theory.json	digest fd762acbd272b2d1…
weil_Lc_theory#theory.k=10|eps=0\.01.L_c_meas	3.070311505664645
```

Prototyped: 147 values across three artifacts for entry 302, about 10 KB,
generated in one command; verifying the entry against it returns
`140 OK, 0 MISMATCH`. It kills the cross-file key collision — measured live,
47 shared keys between the two files entry 302 cites, 33 with different values,
and `check_entry_numbers.py:184-188` resolves by `hits[0]`; it survives the
artifact being pruned; and it is small enough to commit forever.

**The digest is meta-stripped, not `sha256(bytes)`.** Every results JSON carries
`meta.timestamp`, so a bit-identical re-run at a different second changes the
whole-file hash and a byte-hash gate blocks on the most ordinary event in the
tree. The tree already documents the primitive at `flatten_results.py:22-30` —
the `grep -v '^meta\.'` diff *is* the reproduction test. The digest is:

> sha256 over the store's lines, with every `^meta.` line dropped, the repo
> root replaced by `$REPO` in every value, and the remaining lines sorted.

Prototyped against a simulated re-run — new timestamp, new timing, cloned to a
different path:

```text
original                       digest fd762acbd272b2d1…  5578 value lines
whole-file sha256 (v1's bind)  5fab4172638338c8…
simulated re-run + reclone     digest fd762acbd272b2d1…  5578 value lines
whole-file sha256 of that      4242ca13e4c82e7d…

meta-stripped digest stable across re-run: True
whole-file sha256 stable                 : False
digest changes on a real value edit      : True
```

The path normalisation is not hypothetical. Stripping `meta.` from
`weil_Lc_theory.numbers` removes exactly 3 of 5583 lines, and the only
remaining machine-dependent values are two absolute paths — `params.mod_json`
and `params.zeros_file` — which matches the two-line difference observed on the
clean-clone re-run of `analysis/2026-09-01/weil_Lc_theory.py` this afternoon.

`sha256(bytes)` is kept as a `# bytes` provenance note that never gates. A
changed digest is a reviewable event in DVC's sense: CI prints the key-level
diff and blocks. A changed `# bytes` with an unchanged digest prints one line
and passes.

### 3.3 Notebook addressing — the hardest format question, solved

**The failure, measured.** The notebook is newest-first
(`notes_format.md:11-13`), so every new entry prepends and every line-number
citation into an older entry rots. Entry 303 cites
`notes/lab_notebook_2.md:1233` for entry 296's Answer paragraph:

```text
git show 33df8ca:notes/lab_notebook_2.md | sed -n 1233p
   -> "**Answer.** (a) No theorem of the form …"
grep -n for that exact text, today          -> 2022      (drift +789)
33df8ca:2913 "absorbed into `c₂·log x`. One bug the checker caught:"
grep -n for that exact text, today          -> 3702      (drift +789)
```

The rot surface, counted:

```text
lab_notebook*.md:<line> citations in committed prose      47
  adversary_report.md 17 · arrow_tolerance.md 10
  container_audit_report.md 8 · systems_architecture.md 3
  lab_notebook_2.md itself 9
bare backticked `:NNN` self-citations inside the notebook 73
NOTEPAD.md: citations by `entry N`                       623
NOTEPAD.md: citations by line number                       0
```

**`NOTEPAD.md` already solved this and nothing else adopted it.** Root
`CLAUDE.md:127-128` requires `entry N:` for NOTEPAD lines, and 623 comply with
zero line references. `eval_harness` reached the same place independently — the
inventory found 0 line citations in either of its notebooks, and cross-file
references written as `lab_notebook_pre_chain.md:Entry 26`. And
`the_container/NOTEPAD.md:28` has already logged the failure from the other
side: its generated map carries a `line:` field on all 2889 nodes and the
NOTEPAD line flags them as "a stale `status:` snapshot and a `line:` number".

**The scheme.** `entry N § <lead-in>` — entry number, section mark, and the
bold lead-in phrase the entry already carries. Both halves are immune to
prepending: the entry number is permanent (`notes_format.md:11-13`: "Numbering
is continuous, so `entry N` is a unique address project-wide"), and the lead-in
is text inside the entry. It is also order-independent, which § 2.3 requires,
since `the_container` runs oldest-first.

Literal syntax, in prose, unchanged markdown:

```text
entry 296 § Answer
entry 302 § Section 1 — the fixed window's L_c against the measured
entry 271 § What this does to the ledger
```

Resolution: find the single `## <date> — Entry N — …` header outside fences,
then within that entry's body the unique line matching `^\*\*<lead-in>` as a
prefix. No line numbers in the address.

**Is the substrate there?** Measured across the whole notebook:

```text
entries with bold lead-ins: 222 of 260
bold lead-ins total: 1196; unique-within-entry: 1194 (99%)
entries with a duplicated lead-in: 1   (entry 102, "DIES")
entry length in lines: median 66, max 382
```

99% unique on the first try, one collision in 260 entries, and a median entry
of 66 lines so `entry N` alone is already usable when no lead-in fits. **The
scheme costs nothing to adopt** — the anchors are already written, by 222
entries, over months.

**What it costs under append-only.** Nothing is rewritten. The 47 existing line
citations stay as they are; they are already stale and correcting them would
mean editing committed entries, which `AGENT_CARD.md:9-11` forbids. Instead:
new prose uses `entry N § X`, enforced by a gate that denies
`lab_notebook*.md:<digits>` in newly staged prose; old prose is baselined,
the ratchet `pre-commit:36-45` already uses; `tools/entryref.py` resolves an
address to a current line on demand and reports which baselined citations now
land in the wrong entry — a report, never an edit; and `check_refs.py` gains
one check, that an `entry N § X` address resolves.

**Format defence.** `entry 296 § Answer` is plain text. An LLM with no tooling
reads it and knows where to look; a line number sends the same reader to a line
that has moved. The address is strictly more readable than what it replaces —
the rare case where the portability rule and the mechanical rule agree.

### 3.4 Config — a fenced block inside the contract file, not a separate file

v1 proposed `values.toml` at the project root. The objection is
`CLAUDE.md:308-310`: "reading `~/GitHub/CLAUDE.md` plus the relevant project's
`CLAUDE.md` … reconstruct the entire operating contract. No hidden state." A
config file at the root is hidden state. So the config is a
**declared-schema fenced block inside the project's contract file**, under a
`## Config` heading — and per § 2.3 the tool accepts `CLAUDE.md`, `AGENT.md` or
`CONTRACT.md` as that file's name.

````text
## Config

Read by `~/GitHub/tools/*`. Edited only with Julian's approval, like every
other line of this file.

```toml
schema = 2

[layout]
notebook  = "notes/lab_notebook_2.md"
receipts  = "notes/receipts"
values    = "notes/values"
prose     = ["notes/lab_notebook_2.md", "CONTEXT.md", "README.md",
             "papers/**/*.md", "lean/BUILD.md"]

[[artifacts]]
glob    = "results/*.json"
emitter = "json"
[[artifacts]]
glob    = "analysis/*/results/*.json"
emitter = "json"

[store]
committed    = true
byte_ceiling = 8_000_000      # above this, commit the digest only
format       = 2              # escaped-dot segments

[entries]
header       = '^## \d{4}-\d\d-\d\d — Entry (\d+)'
anchor       = '^\*\*(.+?)\*\*'
newest_first = true           # the_container sets this false
append_only  = true

[gates]
response_numbers = "block"    # § 5.1 — turn-bound, not pool-bound
prose_numbers    = "block"
transclusions    = "block"
receipts         = "block"
notebook_refs    = "block"
state_md         = "block"
context_md       = "baseline"
papers           = "baseline"
run_manifests    = "baseline"

[exempt]
artifacts = ["results/O24_gen_xmax3e9_results.json"]
keys      = ["meta.timestamp", "meta.hostname"]
```
````

**What reads it:** a ten-line extractor in `~/GitHub/tools/config.py` pulling
the first ` ```toml ` block under `## Config` and parsing it with `tomllib`
(stdlib since 3.11; the tree runs 3.14.3 per
`container_audit_report.md:609-611`). **What it replaces:** three hardcoded
copies of the same result-glob at `check_numbers_in_response.py:77-86`,
`pre-commit:85-87`, `audit.yml:30-32` — all three in agreement today, each an
independent chance to drift.

**Format defence.** TOML in a fenced block in markdown is plain text in a flat
tree, readable with no tooling, in the one file the auditability rule names. It
inherits the contract file's protection (`check_protected_write.py:70-94`,
`pre-commit:129-143`), so a config change needs Julian's `.approve/` flag —
correct, because a config change is a change to the contract. Rejected: a
separate `values.toml` (hidden state, and gate scope a model could change
without Julian seeing it); JSON (no comments); YAML (not stdlib).

### 3.5 The scalar citation — `` `artifact#key` `` value

```text
the reference row reads `weil_Lc_theory#theory.k=10|eps=0\.01.L_c_meas` 3.0703
```

The value stands literally in the prose at the author's precision; the key
stands beside it; a checker resolves the key **in that entry's receipt** and
compares, rounding-aware at the entry's own stated precision
(`check_values.py:26-31`). Resolving against the receipt rather than a pool is
the same distinction § 5.1 turns on.

The half that removes the retyping is `~/GitHub/tools/cite.py`. Prototyped:

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

`--sig N` is myst-nb `glue`'s format spec: the artifact owns the digit, the
sentence owns the precision.

### 3.6 The block citation — cog's three markers

For the digits that live in tables. From cog
(`https://cog.readthedocs.io/en/latest/running.html`): the generated region
sits literally in the file, the generator is a comment, a checksum rides the
end marker, and `--check` exits nonzero if regeneration would change anything.

```text
<!-- values: slice analysis/2026-09-01/weil_Lc_theory.txt:134-141 -->
```text
  k=1     theory p  -0.2557 (R2 0.9675)   measured p  -0.0631 (R2 0.9897)
  …
```
<!-- end (sum: 35d5bd43d8) -->
```

**The `slice` generator is the primary form.** Byte equality against those
lines, no parser. Its prototype separated entry 302's one byte-exact table from
its two hand-narrowed ones:

```text
DRIFT    entry302:160   weil_Lc_theory.txt:62-77    (a column removed)
DRIFT    entry302:243   weil_Lc_theory.txt:108-120  ('meas = …' clause removed)
OK       entry302:312   weil_Lc_theory.txt:134-141  8 lines  sha 35d5bd43d893
```

**The `table` projector is demoted to optional.** `weil_Lc_theory.txt` has no
table name, no column header, and its columns are inline prose emitted by
`print()` calls that nothing binds a parser to. Where an entry needs a narrower
table the fix is upstream — **the script emits the narrow table into its own
`.txt`**, and the entry slices it. That moves formatting to the place that
already owns it and needs no projector.

**Format defence.** An HTML comment and a fenced block are plain markdown; the
numbers are literally present; a reader with no tooling sees the table.

### 3.7 `STATE.md` format

Generated markdown with the header `lean/THEOREMS.md:3-4` already uses, and the
same three markers as § 3.6 so one `--check` verb gates both:

```text
# STATE — Primebeat_081426

**GENERATED** by `~/GitHub/tools/state.py` from the tree at <git sha>.
Do not edit by hand. Every number is a count of something on disk.

## Notebook
<!-- values: state notebook -->
volume 1   entries 1–44, closed        43 headers
volume 2   entries 45–304             260 headers      newest 304 (2026-09-02)
<!-- end (sum: ………) -->
```

Authored files that need a count **transclude the matching block** instead of
restating it. `README.md`, `lean/BUILD.md` and `CONTEXT.md` each carry a
`<!-- values: state … -->` block rather than a typed number, and D1–D4, D8
become structurally impossible.

---

## 4 · Where the six hops die

| hop | disposition | mechanism |
| --- | --- | --- |
| 1 · JSON → agent report | **mechanised** | the report's factual half is a generated `## Values` block; free prose states the reading, never a digit. Enforced by the **turn-bound** Stop hook of § 5.1 — not by today's pool-bound one. |
| 2 · report → chat | **eliminated for digits** | the orchestrator relays keys and the block verbatim; `cite.py` prints a value when one must be spoken |
| 3 · chat → brief | **mechanised** | `tools/brief.py` emits `## Inputs`: paths resolved, ranges verified, notebook addresses resolved as `entry N § X`, values read, digests computed |
| 4 · brief → entry | **mechanised + gated** | `cite.py`, block markers, receipt at write time, checker at PostToolUse and pre-commit |
| 5 · entry → `CONTEXT.md` | **gated, and shrunk** | counts leave for `STATE.md`; what remains is gated, baseline-ratcheted |
| 6 · entry → `papers/` | **gated, extended** | `check_values.py` resolves `art#key` against receipts, artifact scan as fallback |

**Scope correction.** v1 scoped hops 5 and 6 too narrowly:

```text
CONTEXT.md:255-709 slice   outside fences  1061
CONTEXT.md whole file      outside fences  1436     (+375, 26% more)
papers/*.md   (15 files)   outside fences  3326
papers/ recursive (19)     outside fences  4899     (+1573 under papers/literature/)
```

Gate scope is `CONTEXT.md` whole-file and `papers/**/*.md` recursive, in the
config. `papers/literature/` holds `README.md` and three `litsearch_*.md`.

---

## 5 · Gates

### 5.1 The finding that reorders the migration

`utilities/hooks/check_numbers_in_response.py` is a live Stop hook
(`.claude/settings.json:10-13`). Its invariant is: a citable number in a
response must appear in **some** `.numbers` file, rounding-aware. Its
`table_values()` (`:89-106`) pools every value from every store into one set.
I measured what that set accepts:

```text
stores on disk: 5   distinct values pooled: 59,700
random 3-decimal values in [0,10) that the hook ACCEPTS:  612/2000 = 30.6%
random 3-decimal values in [0,1)  that the hook ACCEPTS: 1902/2000 = 95.1%
random 4-decimal values in [0,1)  that the hook ACCEPTS:  721/2000 = 36.0%
```

**A number invented from nothing passes 95% of the time in the range most of
this project's ratios, R² values and slopes fall in.** The hook does not
distinguish *I read this from a file* from *these digits exist somewhere in the
haystack*.

This is not a new discovery in this system. `the_container` built exactly this
hook, benched it, and rejected it on 2026-08-30.
`experiments/2026-08-30_sidecar/RESULT.md`:

> **Verdict: does not work. 0 of 5 real failures caught.** … Substring matching
> against a 24 MB corpus grounds anything. At that size a two- or three-digit
> quantity occurs somewhere regardless. The test cannot distinguish *I measured
> this* from *these characters exist in the haystack*.

and its prescription, which I adopt verbatim:

> Bind a number to **the command that produced it** — same turn, same tool
> call — not to a haystack. Capture tool results per turn in `PostToolUse`; let
> `Stop` check only against that turn's results.

`the_container/utilities/hooks/sidecar.py` already implements the v2 shape:
every transcript record carries `promptId` and the Stop payload carries
`prompt_id`, so the corpus is only the current prompt's tool results —
"ordered, bounded, and impossible to ground from an earlier echo". It is
written and unwired (`RESULT.md`: "Not installed anywhere"), because that tree's
`.claude/settings.json` never loads.

Three consequences for this design.

1. **Step 1 of the migration is replacing the pool check with a turn-bound
   one.** Everything in § 4's hops 1 and 2 rests on this hook, and it is
   currently near-inert.
2. **It must be turn-bound *and* key-adjacent.** Turn-binding stops the
   haystack; adjacency (the number sits beside a key that resolves in the
   receipt or in this turn's store read) stops the second failure the container
   found — grounding a number by echoing it. Agents may write under
   `analysis/<date>/results/` (`CLAUDE.md:205-206`), so an agent can create a
   store and thereby ground any number. Adjacency to a *cited key* closes that;
   pool membership does not.
3. **It gates § 3.1.** Committing more stores enlarges the pool monotonically.
   The store decision is only safe after step 1, which is why the ordering
   below puts them adjacent.

### 5.2 Inventory

**Surviving unchanged.** `check_protected_write.py` (`:70-94`);
`check_sidecar.py` (pre-commit 4); `check_results_guard.py` (pre-commit 3); the
`.numbers`-header check (pre-commit 5, `audit.yml:28-37`); `check_refs.py`
(pre-commit 1, `audit.yml:23-26`); the commitment-file approval flag
(`pre-commit:129-143`); `check_weld.py` by hand.

**Changing.**

| hook | change | why |
| --- | --- | --- |
| `check_numbers_in_response.py` | **rewrite**: turn-bound corpus via `prompt_id`, plus key-adjacency; enforces the `## Values` block | § 5.1 — 95% permissive, measured |
| `check_agent_brief.py` | replace digit-denial with "carries a generated `## Inputs` block, and every path, notebook address and key in the prose appears in it" | scored 2 of 24 on my corpus; recomputed buy in § 8 B1 |
| `check_direct_run.py` | widen `DIRECT` (`:64-66`) beyond a bare `(O\|0\|t)\w*\.py` to any script under a declared measurement root, path-qualified included | 36 manifests, newest `20260828T044059Z`, while six runs landed 2026-09-01/02 |
| `check_bash_guard.py` | add `cp`, `mv`, `install`, `ln` destination parsing; deny `python3 -c` / heredoc naming a protected basename | its docstring `:25-27` admits the hole |
| `gate.py` | add the prose-number and notebook-address checks; still advisory (`:29`) | drift reported within one tool call |
| `check_values.py` | resolve `art#key` against receipts, keep the artifact scan | 4899 ungated tokens in `papers/` recursive |
| `check_read_range.py` | honour an explicit brief instruction to read in full; keep `LIMIT = 120` otherwise | § 8 W-i |

**New — invariants with no gate today.**

| invariant | where | on fire |
| --- | --- | --- |
| a number in a response is backed by **this turn's** tool output and sits beside a resolving key | Stop | block, name the number |
| every citable number in new prose sits beside a resolving key | PostToolUse advisory + pre-commit block | name the number and its line |
| a marked block regenerates byte-identically | same | print the first differing line |
| every new entry has a receipt and it verifies | pre-commit, staged entries | block |
| a `lab_notebook*.md:<line>` reference in new prose | pre-commit, baselined | block; point at `entry N § X` |
| an `entry N § X` address resolves | `check_refs.py` | block |
| **every `entry N` cited anywhere exists** | `check_refs.py` | block — `eval_harness` cites Entry 6 twice (`lab_notebook_pre_chain.md:2369`, `NOTEPAD.md:41`) and it has no header |
| `STATE.md` regenerates identically | pre-commit + CI | block |
| a transcluded `state` block matches `STATE.md` | pre-commit + CI | block — this is what kills D1–D4, D8 |
| numbers in `CONTEXT.md` / `papers/**` resolve | pre-commit, baselined | block on new breaks only |
| every results JSON has a run manifest | pre-commit, baselined | block on new only |
| every results JSON has a store or a declared exemption | pre-commit | block |
| a receipt's meta-stripped digest matches disk | CI | block, print the key-level diff |
| a receipt's `# bytes` differs while the digest matches | CI | one informational line, pass |

**The two structural holes.** *Shell routes around the write guard*:
destination parsing closes `cp`, `mv`, `install`, `ln`; the parser-free fix is a
`PostToolUse` integrity check hashing every protected file before and after each
tool call, using the already-enumerable set at `check_protected_write.py:70-94`
and the already-registered slot at `.claude/settings.json:17-27`. *A hook cannot
be patched from inside a session* (`check_protected_write.py:90-91`) — correct,
and it stays; what is missing is `utilities/hooks/proposed/`, an unregistered
directory agents may write, which pre-commit refuses to promote and which
`tools/promote_hook.py`, run by Julian, moves into place only after the file's
own `--selftest` exits 0. Every hook already has one.

---

## 6 · Migration

Each row is green and committable alone. Nothing rewrites, retitles or
renumbers an entry — verified row by row, and independently by the adversary.

| # | step | cost | buys |
| --- | --- | --- | --- |
| 1 | **rewrite `check_numbers_in_response.py` turn-bound + key-adjacent**, porting `the_container/utilities/hooks/sidecar.py`'s `prompt_id` binding | a day; the plumbing exists and is verified against the docs | closes a live gate measured 95% permissive; precondition for step 2 and for every § 4 hop-1/2 claim |
| 2 | store format 2 (escaped-dot `seg()`, `# format 2`, backslash-stripping resolver); regenerate the five stores; confirm the byte ceiling | one line + a resolver branch | re-parseable keys, old citations still resolve; safe only after 1 |
| 3 | `cite.py` + `receipt.py` with the meta-stripped digest; receipts for entries 298–304 | a day; all three prototyped | digits copied by a program; key collision becomes an error |
| 4 | notebook addressing: `entry N § X` in `notes_format.md`; `entryref.py`; gate `lab_notebook*.md:<line>` in new prose, baselined; entry-exists check | half a day; anchors already exist in 222 entries | closes the highest-base-rate mechanical failure (47 + 73 rot-prone citations) |
| 5 | `emit_log`, `emit_lean`; backfill stores for the four JSONs with none (`container_audit_report.md:613-616`) | a day | must precede the blocking prose gate: baselining cannot protect a *new* entry citing one of those four |
| 6 | `check_prose_numbers.py` over the notebook against receipts; advisory at PostToolUse, blocking at pre-commit on staged entries | a day | drift caught within one tool call |
| 7 | `slice` block markers with cog checksums; `--check` in pre-commit and CI | a day | the fenced tables come under a gate |
| 8 | `state.py` + `STATE.md`; transclude `state` blocks into `README.md`, `lean/BUILD.md`, `CONTEXT.md`; strip the counts they replace | a day; needs `.approve/` for three commitment files | D1–D4, D8 structurally impossible — the largest measured defect class, in three trees |
| 9 | `brief.py` + rewrite `check_agent_brief.py` around `## Inputs` | a day | 21 of 41 measured brief errors become impossible |
| 10 | add `## Values` to `AGENT_CARD.md`; merge `claude_writer.md` + `claude_notes.md` into `§ Roles`; fix `container_audit.md:10` | half a day | D6, D7; completes hops 1–2 |
| 11 | config block into `CLAUDE.md § Config`; the three hardcoded globs read it; accept `CLAUDE.md`/`AGENT.md`/`CONTRACT.md` | half a day; needs `.approve/CLAUDE.md` | one home for gate scope; no hidden state |
| 12 | extend the prose checker to `CONTEXT.md` whole-file and `papers/**` recursive, baselined | half a day | 1436 + 4899 tokens under a ratchet |
| 13 | widen `check_direct_run.py`; environment capture in `run.py`'s manifest; ratchet manifests | half a day | `container_audit_report.md` findings 2, 4, 7 |
| 14 | `hooks/proposed/` + `promote_hook.py`; bash-guard destination parsing; PostToolUse integrity check | a day | both structural holes |
| 15 | move tools to `~/GitHub/tools/`; fold `NOTEPAD_TEMPLATE.md` into root `CLAUDE.md § NOTEPAD format` | a day; needs root `.approve/CLAUDE.md` | the mechanism reaches the other projects; the auditability rule becomes literally true |
| 16 | adopt in `eval_harness` (four commitment files, a `results/`, and no gates at all — `CLAUDE.md:77-79` says so outright) | half a day | falsifies the generalisation cheaply |
| 17 | **measure it** — run step 9 on one spawn and count the in-entry corrections in the resulting entry against the 41-error baseline over entries 298–303 | one spawn | the adversary predicts (e)+(f) drift *rises* under an `## Inputs` block; this settles it, and it must run before 9–10 are called done |

**Order changed from v1 at four points.** The Stop-hook rewrite is new and is
now first. The receipt tooling moved from position 4 to 3, because without it
nothing has anything to resolve against. The store backfill moved from 9 to 5,
ahead of the blocking prose gate. The config moved from 1 to 11 and is no
longer called a precondition for anything.

**Julian's approval required at:** 8, 10, 11, 15 — each needs the
`.approve/<basename>` flag he creates from his own terminal
(`Primebeat_081426/CLAUDE.md:224-225`, `pre-commit:129-143`).

---

## 7 · What this does not fix

1. **A wrong number, correctly transcribed.** Entry 300's "linear in γ_k" and
   its detection-magnitude price were artefacts of one basis family, corrected
   by entry 301. Every gate here passes them.
2. **A right number attached to the wrong claim — 8 of 41 measured.** Entry 301
   at `lab_notebook_2.md:905`: "k = 100, ε = 0.01 reads 5.0415 (brief 4.9561,
   which is that row's `w = 1` value)". I opened it and confirmed the text. An
   `## Inputs` block resolving `…w=1.L_c` prints 4.9561 correctly and carries
   the error through untouched.
3. **Qualitative drift — 11 of 41, the largest class.** "all eight identical",
   "identical throughout", "four to six orders", "the 1.54–1.62 band starts at
   X = 9". No digit gate touches them. v1 put this class at 4 of 24; it is 11
   of 41.
4. **Slice-then-aggregate.** Entry 219's maximum, wrong by 2.3× for four
   entries, never entered a file (`check_direct_run.py:14-19`).
5. **A correction that is itself wrong.** Entry 299 read a cost as `c·log γ_k`;
   entry 300 "corrected" it to linear; entry 301 restored 299 and identified
   300's correction as a basis artefact. Entry 300's title and correction
   paragraph stand uncorrected, as append-only requires, and a reader arriving
   at entry 300 or its NOTEPAD line inherits two withdrawn claims. **v1 did not
   name this.** Partial mitigation: `STATE.md` can carry a *generated*
   superseded-claims index, extracted from the `corrects`/`corrected`
   construction the notebook already uses in seven entry titles. A pointer,
   never an edit, and useless to a reader who never opens `STATE.md`.
6. **Truncation at write time.** `weil_Lc_height_M96.log` was committed at 0
   bytes because a `tee` truncated it. Step 13's manifest records the empty
   output; it does not prevent it.
7. **Precision theatre.** Citing a key and quoting more digits than the
   measurement supports passes every check here.
8. **Reproduction.** `container_audit_report.md:583-586`: nothing has been
   re-run from a clean checkout as a gate.
9. **The authored store.** Attributable, not verifiable.
10. **Julian's synthesis.** Deliberately untouched.
11. **Gates catch the author's own edits, not the author's false claims.** The
    hardest measurement in the system, from `the_container/REPO_MAP.md:70-75`:
    "**nine** outside reviews produced **~83 findings; the 8 gates produced
    none of them** — they caught 9 regressions from my own edits seconds
    earlier, never a claim that was false when made." Every mechanism in this
    document is a gate. On that tree's evidence the expected yield against
    false-when-made claims is zero, and the adversarial round remains the only
    thing that has ever found one. This design should be read as removing the
    *transcription* class so that outside review can spend itself on the
    *claim* class — not as a substitute for it.

**The honest headline.** On the full corpus the design fixes 21 of 41 measured
brief errors — 51%, not the 83% v1 claimed. The mechanical half is fixed
completely and cheaply. The half it does not fix is (e) + (f) = 19 of 41, every
one a model reading a real number off the wrong row of a real file and
generalising it into a sentence. Step 17 exists because the adversary predicts
an `## Inputs` block makes that class *worse*, and that is testable for one
spawn.

---

## 8 · Changes from v1 — every adversary finding, dispositioned

**B1 · The 24-error corpus is a subsample. BREAKS. ADOPTED.** I re-ran the
count independently with a wider construction:

```text
v1 regex ('the brief for this entry said|cited|left')        24
my wider regex, unwrapped, entries 298–304                   32
adversary regex                                              39
adversary hand-classification (strict)                       41  (+4 soft = 45)
```

My recount confirms the direction; I adopt the hand-classified 41 and its class
mix. Step 9's priced buy falls from 83% to **21 of 41 = 51%**. § 7's class
counts are corrected: (f) from unnamed to 8, (e) from 4 to 11. Step 9 keeps its
day and moves behind the work everything depends on. Step 17 is added to test
the prediction that the residue grows.

**B2 · The receipt's sha fires on every re-run. BREAKS. ADOPTED.** The receipt
binds a meta-stripped, path-normalised, sorted digest (§ 3.2), prototyped stable
across a simulated re-run and reclone and sensitive to a real value edit.
`sha256(bytes)` is demoted to a `# bytes` note that never gates. The
contradiction the adversary identified — key exemptions in config, whole-file
hash for identity — is gone, because the digest and the key exemptions are now
one mechanism.

**B3 · No invariant for notebook self-citation. BREAKS. ADOPTED, extended.**
§ 3.3. I verified the drift and it is +789, not +617: `33df8ca:1233` is at 2022
today, `33df8ca:2913` at 3702. I counted the full rot surface, which the
adversary did not: **47** cross-file line citations plus **73** bare backticked
`:NNN` forms. The fix is `entry N § <lead-in>`, and the measurement that makes
it free is new: 1196 bold lead-ins across 222 of 260 entries, 99% unique, one
collision. `NOTEPAD.md` already uses `entry N` 623 times with zero line
references, and the cross-project inventory found `eval_harness` at zero line
citations too, and `the_container` already logging line-number rot in its
generated map. Migration step 4, gated and baselined, nothing rewritten.

**B4 · Step 3's cost understated, benefit a counterfactual, ratio wrong.
WEAKENS. ADOPTED; judgement reversed.** All five stores are git-tracked
(9,347,436 B). The tree's own pairs give 1.9663, not 1.46 — my sample drew
small `results/*.json` with a different leaf profile — so the projection is
365 MB. Combined with B5 the store stays committed under a config byte ceiling,
no `git rm --cached`, and the 272 MB figure returns to the argument it belongs
to (§ 3.1).

**B5 · A gitignored store fails the document's own portability standard.
WEAKENS. ADOPTED.** The finding that reversed the call: a store with 5,581
leaves of which a receipt cites 147 leaves >97% unreadable on a fresh clone —
exactly the reader the rule protects, and the reader who finds an *uncited*
value by grep. I applied a weaker standard to the store than to the prose.

**B6 · "One digit in nine" divides keys by tokens. WEAKENS. ADOPTED.**
Reproduced: of entry 302's 792 outside-fence tokens, **234 (29%)** sit inside
backticked key spans and are addresses, not assertions. Assertable is
1301 − 234 = 1067, so the ratio is **one in 7.5**. I also drop the
"key-shaped tokens" column entirely — my method was unstated and the adversary
could not reproduce it, which is a fair finding against a measurement column.
The conclusion, coverage near 10%, survives.

**B7 · `CONTEXT.md` and `papers/` scoped narrower than the gate. WEAKENS.
ADOPTED; the gap is larger than reported.** `CONTEXT.md` whole file is 1436
against the 1061 slice; `papers/` recursive is **19 files and 4899 tokens**
against 15 and 3326 — `papers/literature/` carries 1573 tokens outside every
gate v1 proposed. Scope corrected in § 3.4 and § 4.

**B8 · `emit_table` has no contract and carries the coverage claim. WEAKENS.
ADOPTED.** The projector is demoted; `slice` carries step 7; a narrow table is
emitted by the script. I found the same defect from the other direction while
prototyping: the projector returned an empty table because the flat key format
is not re-parseable, which is § 3.1(a).

**B9 · Hidden dependency, wrongly-labelled precondition. WEAKENS. ADOPTED.**
Store backfill moves ahead of the blocking prose gate; the config moves to 11
and is no longer a precondition; the receipt tooling moves up. v1's step 1 is
correctly identified as skippable.

**B10 · What reproduces. HOLDS.** The key-collision measurement (47/33), the
transclusion prototype including its sha, the four entry token counts, both
checker outputs, the manifest count and the leaf count all reproduce here. Two
corrections: my non-structural-dot criterion is now stated (§ 3.1a), per the
adversary's fair complaint that it was not; and the store/JSON counts moved
from 4/203 to 5/204 while the documents were written.

**B11-i · The store call. Reversed to committed** — B4, B5. The adversary
landed on "derived plus a committed digest"; I go further to "committed under a
byte ceiling, plus the digest", because grep-on-fresh-clone is the property
their own Part One audit needed, and because it avoids a destructive index
operation in a tree whose CANNOT list is built around not removing artifacts.

**B11-iii · Which hook enforces the report block. ADOPTED, and it turned out to
be the most important question in the review.** v1 assigned work to the Stop
hook in one section and called it out of scope in another. Settled:
`check_numbers_in_response.py` enforces the `## Values` block — and § 5.1
measures that, as written, it enforces almost nothing. `check_response_prefix.py`
is a separate compliance probe and this design makes no claim on it.

**B12 · Does the design fix the failure that happened? WEAKENS. ADOPTED in
full.** § 7 is rewritten around it: the 51% headline, (f) at 8 with the
verbatim entry-301 example I opened, (e) at 11, and the 299→300→301 reversal
added as item 5 — a gap v1 did not list. Step 17 is the falsification.

### 8.1 What I contest

**W-i · B11-ii, `check_read_range.py`.** The adversary argues `LIMIT = 120`
should stand and that my evidence was one incident with no resulting error.
**I adopt their remedy and contest their premise.** New evidence: this is not
one incident, it is a standing contradiction between two committed files.
`container_audit.md:10` instructs a fresh agent to read
`Primebeat_081426/CLAUDE.md` **in full**; that file is 258 lines and
`check_read_range.py:29,:50-53` denies it. A tree that ships an instruction its
own gate forbids has a defect, and it is not in the instruction —
`CLAUDE.md`'s three rules are narrative, and reading `:31-90` without `:110-137`
gets an agent two of three. So the remedy is theirs (honour an explicit brief
instruction, keep the budget otherwise) and `container_audit.md:10` is fixed in
step 10. I withdraw v1's "make it advisory".

**W-ii · B4's implication that the 272 MB figure was wrong to state.** The
figure is right for what it measures — flattening all 185.6 MB, which v1
rejected doing. The adversary is right that it does not belong in a *benefit*
column, and I moved it. It stays in § 3.1 as the reason the store is not
flattened universally, which is the argument it was always making. A placement
correction, not a measurement error; my recomputed value on the tree's own
pairs (365 MB) is larger.

### 8.2 What v1 got right and v2 keeps

Check-in-place over render-in-place, and the reason: a placeholder in a raw
file violates `CLAUDE.md:275-277`. cog's three markers plus a checksum. The
flat `key<TAB>value` shape and its three named defects. The receipt as the
committed binding unit. `cite.py` as the single highest-value item — it removes
the typing, and everything else here is verification of typing that should not
happen.

### 8.3 New in v2

From Half Two: the file inventory (§ 2.1), eight double-work findings in this
project (§ 2.2), the same pattern independently found in two other projects and
the three generalisation constraints (§ 2.3), the minimal set with
authored/generated marked (§ 2.4), `STATE.md` (§ 2.5, § 3.7), config moving
from a separate file into the contract file (§ 3.4), notebook addressing
(§ 3.3), and § 7 item 11 — the container's measured verdict that eight gates
produced none of nine outside reviews' ~83 findings.

**Not from the adversary and not from Half One: § 5.1.** The cross-project
inventory surfaced `the_container`'s benched-and-rejected sidecar, which sent
me to measure Primebeat's live equivalent. That hook is 95% permissive, it is
the mechanism v1 and this document's § 4 both lean on for hops 1 and 2, and
one of this document's own decisions — committing more stores — makes it worse.
Neither I nor the adversary found it by reading the design. It came from
reading a neighbouring project that had already failed at the same thing.

**Half Two changed Half One in two ways.** `STATE.md` is the mechanism that
makes count drift structurally impossible, and it is the *same* mechanism as
§ 3.6 — a count in `README.md` is a transcluded checksummed block, exactly like
a table in a notebook entry. One primitive, two problems. And § 5.1 reordered
the migration. Both are reasons the consolidation had to precede finalising the
repair.
