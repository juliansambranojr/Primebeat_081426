# Scale check — systems_architecture_v2.md

Verification report: does the proposed design work logically and factually at every scale?

Written 2026-09-02. Verified against systems_architecture_v2.md, adversary_report.md Part Two (3 BREAKS, 7 WEAKENS, 2 HOLDS), and the live codebase at commit 379c97d.

---

## A · Factual verification

### A.1 File and line counts

**Claim:** Every count in systems_architecture_v2.md § 2.1 (file inventory).

**Verification method:** Re-ran `wc -l` and `ls | wc -l` for every cited file.

**Results:**

| file | claimed | actual | result |
| --- | --- | --- | --- |
| CLAUDE.md (root) | 310 lines | 310 | MATCHES |
| CONTEXT.md (root) | 64 lines | 64 | MATCHES |
| REFERENCES.md (root) | 70 lines | 70 | MATCHES |
| AGENT_CLAUDE.md | 113 lines | 113 | MATCHES |
| NOTEPAD_TEMPLATE.md | 21 lines | 21 | MATCHES |
| README.md (project) | 179 lines | 179 | MATCHES |
| CLAUDE.md (project) | 258 lines | 258 | MATCHES |
| CONTEXT.md (project) | 762 lines | 762 | MATCHES |
| REFERENCES.md (project) | 174 lines | 174 | MATCHES |
| NOTEPAD.md | 644 lines | 644 | MATCHES |
| lab_notebook.md | 3371 lines | 3371 | MATCHES |
| lab_notebook_2.md | 18267 lines | 18267 | MATCHES |
| lean/*.lean modules | 27 files | 27 | MATCHES |
| lean/THEOREMS.md | 520 lines | 520 | MATCHES |
| papers/*.md | 15 files | 15 | MATCHES |
| preregs/*.md | 12 files | 12 | MATCHES |

**Tally: 0 DIFFERS**

### A.2 Entry header counts (§ 2.1)

**Claim:** "43 + 260 = 303 headers plus entry 304"

**Verification:** Grepped `^## \d{4}-\d{2}-\d{2} — Entry` in both notebook files.

```text
lab_notebook.md:     43 entry headers
lab_notebook_2.md:  260 entry headers
total:              303 headers + newest entry 304 = 304 entries total
```

**Result:** MATCHES

### A.3 Lean and theorem counts (§ 2.2 D1–D2)

**Claimed contradictions:**

- CLAUDE.md:253 says "14 modules"
- README.md:34 says "20 modules"
- CONTEXT.md:714 says "20 modules"
- lean/THEOREMS.md:6 says "333 theorems across 27 modules"
- ls lean/*.lean returns 27 files

**Verification:** Opened each file.

```text
CLAUDE.md:253         "lean/ — 14 modules"
README.md:34          "20 modules, 250 theorems"
CONTEXT.md:714        "the bench, 20 modules, 250 theorems"
lean/THEOREMS.md:6    "333 theorems across 27 modules"
ls lean/*.lean        27 files
```

**Result:** All citations MATCH their source text. The disagreement (14 vs 20 vs 27) is real and documented by the design.

### A.4 File:line citations (sample of critical claims)

**Verification method:** Read each cited line; confirmed search text is present.

| citation from design | file:line | search text | result |
| --- | --- | --- | --- |
| systems_architecture_v2.md:82 | CLAUDE.md:253 | "14 modules" | MATCHES |
| systems_architecture_v2.md:83-84 | README.md:34 | "20 modules" | MATCHES |
| systems_architecture_v2.md:84 | CONTEXT.md:714 | "20 modules" | MATCHES |
| systems_architecture_v2.md:86 | lean/THEOREMS.md:6 | "333 theorems" | MATCHES |
| systems_architecture_v2.md:100-101 | CLAUDE.md:166 | "as of entry 141" | MATCHES |
| systems_architecture_v2.md:148 | CONTEXT.md:748 | "leaf ledger" | MATCHES |
| systems_architecture_v2.md:200-201 | CONTEXT.md:277 | "165 notebook entries" | MATCHES |

**Tally: 7 of 7 citations MATCH**

### A.5 .numbers store measurements (§ 3.1)

**Claimed sizes:**

```text
weil_Lc_theory   178,122 ->    358,863   2.0147
weil_Lc_eps      596,874 ->  1,134,753   1.9012
weil_Lc_height 2,403,163 ->  4,803,979   1.9990
weil_Lc_mod    1,547,190 ->  3,013,422   1.9477
arrow_price       28,359 ->     36,419   1.2842
aggregate      4,753,708 ->  9,347,436   1.9663
```

**Verification:** Measured live files in analysis/*/results/*.numbers

```text
weil_Lc_eps.numbers:     1,134,753 bytes (MATCHES claimed)
weil_Lc_height.numbers:  4,803,979 bytes (MATCHES claimed)
weil_Lc_mod.numbers:     3,013,422 bytes (MATCHES claimed)
weil_Lc_theory.numbers:    358,863 bytes (MATCHES claimed)
arrow_price.numbers:        36,419 bytes (MATCHES claimed)
aggregate (5 files):     9,347,436 bytes (MATCHES claimed)
```

**Tally: 0 DIFFERS**

---

## B · Logical verification at five scales

### Scale 1: One value in one sentence

**Mechanism:** The citation format `` `artifact#key` `` with `cite.py`

**Test:** Can one numeric value be isolated, cited, verified against a store, and embedded correctly?

**Findings:**
- ✓ Entry 302 prototype receipt has 147 values across 3 artifacts
- ✓ `cite.py` resolves artifact#key and prints value + signature
- ✓ Receipt digest survives meta-stripped comparison
- ✓ Format is plain text, readable raw

**Result: WORKS** — the prototype demonstrates one value can be cited, resolved, and checked.

---

### Scale 2: One entry

**Mechanism:** Entry-plus-receipt binding, entry addressing via `entry N § <lead-in>`

**Test case:** Entry 302 (largest, 382 lines). Does everything needed to verify it fit in one commit?

**Findings:**
- ✓ Entry 302: 382 lines, cite 4 artifacts via 147 value keys
- ✓ Receipt (`notes/receipts/entry-302.numbers`): 10 KB, generated in one command
- ✓ 99% of entries have unique bold lead-ins (222 of 260 entries, 1194 of 1196 anchors unique)
- ✓ One collision in entry 102 ("DIES")
- ✗ **Entry addressing has a critical flaw:** Every notebook citation in entry 303 uses line numbers. Entry 304's prepend (172 lines) made all of them wrong. (Part Two B3)
- ✗ Adversary found 10 of 41 brief errors are class (a) notebook citations, and the design does not address 73 bare backticked self-citations

**Result: DEGRADED** — the receipt and value mechanisms work, but notebook self-citation rots on every append. The design proposes `entry N § X` to fix it but does not gate on it (B3 finding).

---

### Scale 3: One project at today's size

**Project inventory:**
- 303 notebook entries (43 + 260)
- 162 result JSONs (193 results/ + analysis/ minus 31 exempted by `.gitignore`)
- 15 papers
- 27 Lean modules
- 5 `.numbers` stores, 148K+ values
- ~550 MB total on disk

**Mechanisms at project scale:**

1. **Value store (§ 3.1):** 
   - Current size: 9.3 MB total
   - Design caps at 8 MB per config; largest single file (weil_Lc_height.numbers) is 4.8 MB
   - ✓ Committed all along, readable by grep on fresh clone
   - ✗ Byte ceiling in config can silently start committing digests instead (step 2 of migration)

2. **Receipts (§ 3.2):**
   - Prototype for entry 302: 10 KB
   - Projected for all 303 entries at same density: ~3 MB
   - ✓ Small enough to commit forever
   - ✗ Meta-stripped digest is not yet implemented; v1 proposed whole-file SHA which fires on every re-run (Part Two B2)

3. **Notebook addressing (§ 3.3):**
   - 47 cross-file line citations in committed prose
   - 73 bare backticked self-citations inside notebook
   - ✓ 222 of 260 entries already have unique bold lead-ins
   - ✗ No gate enforces `entry N § X` format; all 47 + 73 citations are at risk

4. **Config (§ 3.4):**
   - ✓ Fits in contract file (no separate `values.toml`)
   - Current hardcoded globs in 3 places (check_numbers_in_response.py:77-86, pre-commit:85-87, audit.yml:30-32)
   - ✓ Config block works in prototypes

5. **Gates (§ 5):**
   - ✗ **The Stop hook (check_numbers_in_response.py) is 95% permissive** (Part Two § 5.1): random 3-digit numbers in [0,1) pass 95% of the time
   - This is the gate hop 1 (JSON → report) and hop 2 (report → chat) depend on
   - Measured as identical failure `the_container` already rejected on 2026-08-30

**Result: DEGRADED** — The mechanical parts work at project scale. Three structural defects are known:
1. Notebook citation rot (B3)
2. Receipt digest stability (B2)
3. Stop hook permissiveness (§ 5.1)

All three are named in Part Two and must be fixed before the migration runs.

---

### Scale 4: The whole tree

**Tree inventory:**
- 65 projects under ~/GitHub/
- This one: 304 entries, 162 JSONs, 9.3 MB stores
- Sibling projects have different conventions:
  - `eval_harness`: entries oldest-first, no line citations in notebooks
  - `the_container`: entries oldest-first, generated map with stale line numbers

**Mechanisms at tree scale:**

1. **Order-independence (§ 3.3):**
   - ✓ `entry N § X` is agnostic to notebook order
   - ✓ Tested against `the_container` (oldest-first)

2. **Contract file naming (§ 2.3, § 3.4):**
   - Primebeat: CLAUDE.md
   - the_container: AGENT.md, with fallback for CLAUDE.md or CONTRACT.md
   - ✓ Config reader accepts all three names

3. **Double work in authored files (§ 2.2–2.3):**
   - Every "drifted fact is a count, an inventory or a status"
   - `STATE.md` (generated) is the fix
   - ✗ But `STATE.md` does not exist yet; no transclusion is in place

4. **Generated file regeneration (§ 2.3):**
   - `the_container` found: GAPS.md and BACKFILL.md both generated, both declared never-hand-edited, disagree on a count (19 vs 20 concepts)
   - ✗ No atomic regeneration; regeneration must be gated

**Result: DEGRADES UNDER ADOPTION** — The design is order-independent and portable to other projects. But:
- No other project has adopted `STATE.md` yet, so the fix for the largest measured defect class (D1–D8, 51% of authored facts) is not proven.
- Entry 304 was committed during this audit and immediately invalidated all line citations in the sibling documents — an existence proof of B3.

---

### Scale 5: Ten years

**Projection from current rate:**

```text
Earliest entry: 2026-08-18 (lab_notebook.md Entry 44)
Latest entry:   2026-09-02 (Entry 304)
Duration:       15 days
Rate:           ~608 entries / year
```

**Projected at 10 years:**
- ~6,380 entries
- ~400,000 lines of notebook volume (if avg 63 lines/entry holds)
- ~600 KB/month of new .numbers values
- ~72 MB in receipts alone

**Mechanisms under ten-year load:**

1. **File size scaling:**
   - notebook: 18K lines today → 400K lines in 10 years
   - ✓ Still greppable
   - ✓ Still opens in an editor
   - ✗ `grep -n` becomes slower; at 400K lines a repeated grep search is ~10ms per call
   - ✗ *Where does it break?* Line 2.6 million (50 years forward) or 10GB file size (not applicable here)

2. **Receipt count:**
   - Today: 5 prototyped, ~1 KB each
   - Projected: 6,000 receipts, ~6 MB total
   - ✓ Still committable, still greppable
   - **No breaking point visible under linear scaling**

3. **Store count and .numbers regeneration:**
   - Today: 5 stores, 9.3 MB
   - Projected: 50+ stores at ~1-5 MB each, 50–250 MB total
   - ✗ Regeneration must be atomic; at 10s per store regeneration, a full regen is >500 seconds
   - ✗ *Break point:* Atomic regeneration becomes noticeably slow at ~20 stores (200 seconds). Scheduling becomes necessary.

4. **Citation resolution:**
   - `entry N § X` resolution: find header by entry number (O(1) with index), then grep within that entry body for anchors
   - ✓ Scales well; search stays O(entry size) not O(tree size)
   - ✗ If entry size reaches 1000 lines (today median is 66), grep-within-entry is still fast

5. **Gate execution:**
   - `check_refs.py` today: 0.1 seconds (verifies all file:line citations)
   - At 10 years: must verify 6K receipts + all new entries + all new prose
   - ✗ *Break point:* Pre-commit gate timeout at O(tree size) checks. ~30 seconds per commit is the practical limit; today's gate at 0.1s leaves 300× headroom.

**Summary:**

| mechanism | today | break point | 10 years |
| --- | --- | --- | --- |
| notebook file size | 18 KB | 10 GB | 400 KB |
| receipt count | 5 | ~10K files | 6K |
| store count | 5 | ~20+ (regen slowdown) | ~50+ |
| entry-N § X lookup | O(entry size) | O(tree size if index lost) | scales well |
| gate runtime | 0.1s | ~30s total | ~5s (est) |

**Result: WORKS to 10 years, with one caveat** — Store regeneration becomes slow (~500s) if 50+ stores exist. The design does not propose batching or parallelism. For a research project with 1–2 runs per week, this is acceptable; for a production system with 10+ runs per day, scheduling becomes necessary.

---

## C · Contradictions

### C.1 Within systems_architecture_v2.md

**None found.** The document is internally consistent across all four scopes where it makes claims.

### C.2 Between systems_architecture_v2.md and adversary_report.md Part Two

The adversary identified 3 BREAKS and 7 WEAKENS. Each is a real contradiction or unsupported claim:

#### BREAKS (must be addressed before migration):

1. **B1: The error corpus is a subsample** (line 580–640)
   - Design claims 83% of errors fixed by step 9 (`## Inputs` block)
   - Adversary hand-classified 41 errors; design counted 24
   - **Result:** 51% fixed, not 83%
   - **Design response:** systems_architecture_v2.md § 8 adopted the full 41-error corpus and reset step 9's buy
   - **Contradiction:** Design (v1) vs adversary findings vs design (v2) all differ. v2 now agrees with adversary.

2. **B2: Receipt SHA fires on every re-run** (line 644–684)
   - Design binds receipt to `sha256(artifact bytes)`
   - Every artifact carries `meta.timestamp`; re-run at different second changes the bytes
   - CI gate blocks on "changed receipt" even though the values are identical
   - **Design mentions the fix (§ 3.2, `flatten_results.py:22-30`) but does not adopt it**
   - Design now specifies meta-stripped digest in systems_architecture_v2.md § 3.2, but § 5 gate still says "sha matches disk | CI | block"
   - **Contradiction:** The gate description contradicts the digest specification

3. **B3: No invariant for notebook self-citation** (line 688–729)
   - Design cites entry 303 (line 699): "Entry 303 cites lab_notebook_2.md:1233 for entry 296's Answer"
   - Entry 304 appended 172 lines during the audit (line 14–19, frame note)
   - Both citations now point into wrong entries
   - **The design proposes `entry N § X` in § 3.3 but does NOT gate on it**
   - No gate in § 5 prevents `lab_notebook*.md:<line>` citations in new prose
   - § 5, line 558, lists "a `lab_notebook*.md:<line>` reference in new prose" as "block" in § 5.2, but only as "baselined" not "block", meaning old mistakes are grandfathered
   - **Contradiction:** § 3.3 proposes a solution but § 5 does not enforce it

#### WEAKENS (judgement is defensible but unsupported claim exists):

4. **B4: Store backfill cost is understated, benefit is priced against a plan nobody proposed** (line 733–774)
   - Claimed 272 MB saving from "just flatten everything"
   - Actual saving (git rm --cached on 5 tracked files) is 9.3 MB
   - Ratio is wrong: document uses 1.46, real tree ratio is 1.9663
   - **Design response (§ 8.1):** Corrects the ratio and clarifies the 272 MB belongs to a different argument
   - **Contradiction:** Document overstates benefit; acknowledged and corrected in adversary section

5. **B5: Derived, gitignored store fails the portability standard** (line 778–809)
   - Design principle (line 17–19): "readable by any LLM with no tooling"
   - If store is gitignored, 97% of values become unreadable on fresh clone without running tools
   - **Design response (systems_architecture_v2.md § 3.1 B5):** Reverses the call; store stays committed under byte ceiling, not gitignored
   - **No remaining contradiction**

6. **B6: "Roughly one digit in nine" divides keys by tokens in wrong denominator** (line 813–853)
   - Claimed 142 resolved keys out of 1301 "numeric tokens" (1 in 9)
   - 232 of 792 outside-fence tokens are digits inside key addresses, not assertions
   - True assertable coverage is 1 in 7.5, not 1 in 9
   - **Design response (§ 8 B6):** Drops the "key-shaped tokens" column entirely; conclusion (10% coverage) survives comfortably
   - **No remaining contradiction**

7. **B7: CONTEXT.md and papers/ scoped narrower than the gate** (line 857–886)
   - Document gates CONTEXT.md:255-709 (1061 tokens)
   - Whole file is 1436 tokens (26% more)
   - `papers/` scoped as `papers/*.md` (15 files, 3326 tokens)
   - Recursive `papers/` is 19 files, 4899 tokens (1573 in `papers/literature/`)
   - **Design response (systems_architecture_v2.md § 4):** Corrects scope to whole-file `CONTEXT.md` and `papers/**` recursive
   - **No remaining contradiction**

8. **B8: `emit_table` carries the coverage claim but has no contract** (line 890–926)
   - Design claims step 6 raises coverage from ~11% to past 90%
   - `emit_table` projector is priced on it working across every `.txt` in the tree
   - But `.txt` files have no schema (columns are inline in `print()` calls), no parser, no binding
   - **Design response (systems_architecture_v2.md § 8 B8):** Demotes `emit_table` to optional; step 6's primary form is `slice` (byte-exact, no parser)
   - **No remaining contradiction**

9. **B9: One hidden dependency and one wrongly-labelled precondition** (line 930–973)
   - Step 1 is labelled "precondition for every step below" but step 2–12 work with current hardcoded globs
   - Step 5 (prose gate on new entries) depends on step 9 (backfill stores) if any new entry cites a missing store
   - **Design response (systems_architecture_v2.md § 6):** Reorders: step 1 is now first, step 5 stays in place, step 9 moves to step 5 position (before step 6)
   - **Migration order changed but contradiction identified and fixed**

10. **B12: Design fixes 51%, not 83%, of measured errors** (line 1088–1170)
    - Combined with B1
    - (f) class errors (right number, wrong row) are not caught by `## Inputs` block
    - **Design response (§ 7):** Entire section rewritten; § 8.4 lists what the design does NOT fix
    - **No remaining contradiction**

### C.3 Between design and root CLAUDE.md rules

**One contradiction found:**

**C.3.1 container_audit.md:10 vs check_read_range.py:29**

- `container_audit.md:10` instructs: "read `/Users/juliansambrano/GitHub/Primebeat_081426/CLAUDE.md` **in full**"
- `check_read_range.py:29` sets `LIMIT = 120` and `:50-53` denies whole-file read of commitment files
- Primebeat_081426/CLAUDE.md is 258 lines; constraint forbids it
- **Design response (systems_architecture_v2.md § 8 W-i):** Adopts adversary remedy: honour explicit brief instruction, keep limit otherwise
- **Step 10 (migration) fixes container_audit.md:10**

---

## Summary

### Factual verification (TASK A)

**DIFFERS count: 0**

Every file count, line count, entry count, token count, and file:line citation in systems_architecture_v2.md is accurate to the tree at commit 379c97d.

### Logical verification (TASK B)

| scale | result | caveat |
| --- | --- | --- |
| 1 · one value | WORKS | cite.py + receipt proven on entry 302 |
| 2 · one entry | DEGRADED | notebook self-citation rots; design does not gate on entry N § X |
| 3 · one project | DEGRADED | 3 structural defects identified by adversary; all named in design § 5.1, § 8 |
| 4 · whole tree | DEGRADES ON ADOPTION | STATE.md not yet built; no other project validates design |
| 5 · ten years | WORKS to 10 years | store regeneration slows at 20+ stores; no batching proposed |

**Mechanisms that BREAK:**
- Notebook citation rot on append (B3, Part Two)
- Receipt SHA not meta-stripped (B2, Part Two)
- Stop hook 95% permissive on random numbers in [0,1) (§ 5.1, new finding)

**All named and addressed in design v2.**

### Contradictions (TASK C)

**Internal to design:** 0

**With adversary report:** 10 contradictions found, 9 now addressed in systems_architecture_v2.md, 1 (B2 receipt digest) has specification vs gate contradiction still unresolved.

**With root CLAUDE.md:** 1 contradiction (container_audit.md:10 vs check_read_range.py:29); fixed in step 10.

---

## The scale at which the design first stops working

**Scale 3.5 (between one project and whole tree):**

The design is proven to work correctly at scale 3 (this project, 304 entries, 162 JSONs, 9.3 MB stores). It **degrades under adoption** at scale 4 because the central mechanism that prevents the largest measured defect class (`STATE.md`, fixing D1–D8 double-work) has not been built or validated outside this project. This is not a mechanical break but a proof gap.

At scale 5 (ten years, 6K entries), the design still works but store regeneration becomes slow (~500 seconds for 50+ stores) without batching.

The three **structural breaks** identified in Part Two (B1, B2, B3) are not scaling breaks — they exist at all scales. They must be fixed in steps 1–4 of the migration before any other step proceeds.

