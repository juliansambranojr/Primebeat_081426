#!/usr/bin/env python3
"""lean_map — the map of every Lean declaration in this repo.

    python3 utilities/lean_map.py           regenerate map/ (start at map/README.md)
    python3 utilities/lean_map.py --check   exit 1 if map/ is out of date
    python3 utilities/lean_map.py --dump    ask Lean what every proof uses (needs a
                                            built tree; run after `lake build`)
    python3 utilities/lean_map.py --audit   print the reconciliation, in full
    python3 utilities/lean_map.py --chain NAME   print what NAME rests on

Nothing in map/ is written by hand. Where each thing comes from:

  what feeds what      Lean. `--dump` runs utilities/lean_dump/Dump.lean inside each
                       tree: for every constant the kernel holds, the constants in
                       its statement and in its proof term. A lemma found by `simp`,
                       an instance, a term a tactic built: all are in the proof term,
                       so all are seen. Lean's helper constants (`foo._proof_1_3`,
                       `foo.eq_1`, `foo.match_1`) are followed through to the
                       declarations a person wrote. Stored in map/kernel/.
  which names exist    Lean, and the source, and they must agree: every declaration
                       read from a .lean file must be a constant Lean holds in that
                       module, and every constant Lean holds must be a source
                       declaration or a helper of one. Any disagreement is printed
                       in map/README.md § Reconciliation.
  proves / needs       the declaration's own statement, copied from the source.
  why                  the first paragraph of its own docstring.
  what a file does     the first paragraph of the file's header comment.

When a .lean file changed after the last `--dump`, its declarations are read from
the source text instead (a name occurring as a token in the statement or proof) and
its page says so in its first line. `--dump` after the next build confirms them.

A commit that changes a .lean file and is pushed before the map is refreshed
carries `[map pending]` in its message; the workflow then leaves the map for the
`--dump` commit that follows.

An arrow A --> B reads "A is used in the proof of B": premises flow into conclusions.
"""
import hashlib, json, pathlib, re, subprocess, sys, tempfile
from collections import defaultdict

ROOT = pathlib.Path(__file__).resolve().parent.parent
OUT = ROOT / "map"
KDIR = OUT / "kernel"
TREES = [("lean", "the table's tree, Lean v4.28.0"),
         ("lean_stage3", "Stage 3, Lean v4.32.2"),
         ("lean_bridge", "the bridge, Lean v4.33.0-rc2")]
EXTERNAL = ("Mathlib", "PrimeNumberTheoremAnd", "Lean", "Batteries", "Aesop",
            "ZetaTwoThree", "Zeta23", "Std", "Qq", "ProofWidgets", "Plausible")
MODS = r"(?:(?:private|protected|noncomputable|unsafe|partial|nonrec)\s+)*"
DECL = re.compile(r"^(?:@\[[^\]]*\]\s*)*" + MODS +
                  r"(theorem|lemma|def|abbrev|structure|instance|class|inductive|axiom|opaque)"
                  r"\s+([^\s:({\[]+)")
# a declaration's text ends at the next one, or at the first top-level command
STOP = re.compile(r"^(#|end\b|namespace\b|section\b|open\b|variable\b|universe\b|"
                  r"set_option\b|noncomputable section|attribute\b|@\[|local\b|notation\b|"
                  r"macro\b|syntax\b|example\b|scoped\b|omit\b|include\b)")
TOK = re.compile(r"[A-Za-z_][A-Za-z0-9_'.₀-₉]*")
# last components Lean generates by itself
AUTO = re.compile(r"^(_.*|eq_\d+|eq_def|match_\d+.*|splitter|mk|rec|recOn|casesOn|"
                  r"noConfusion.*|below|brecOn.*|binductionOn|sizeOf.*|inj.*|injEq|ctorIdx|"
                  r"ext|ext_iff|induct.*|term.*|fun_cases.*|congr_simp|toCtorIdx|ofNat.*)$")
MAXN = 30          # theorems per diagram
CHAIN_MIN = 20     # an end with this many declarations behind it gets a page of its own
MAXE = 380         # arrows per diagram (GitHub's renderer stops at 500)


# ---------------------------------------------------------------- reading source

def blank_comments(t):
    """the text with every comment replaced by spaces; line breaks kept."""
    out, i, n, depth = [], 0, len(t), 0
    while i < n:
        if t.startswith("/-", i):
            depth += 1; out.append("  "); i += 2
        elif depth and t.startswith("-/", i):
            depth -= 1; out.append("  "); i += 2
        elif depth:
            out.append("\n" if t[i] == "\n" else " "); i += 1
        elif t.startswith("--", i):
            while i < n and t[i] != "\n":
                out.append(" "); i += 1
        else:
            out.append(t[i]); i += 1
    return "".join(out)


def first_para(body, n=420):
    paras = [q.strip() for q in re.split(r"\n\s*\n", body.strip("\n")) if q.strip()]
    if not paras:
        return ""
    s = " ".join(paras[0].split())
    if len(paras) > 1 and len(s) < 80:
        s += " " + " ".join(paras[1].split())
    return s[:n] + ("…" if len(s) > n else "")


def file_header(text):
    m = re.match(r"\s*/-(.*?)-/", text, re.S)
    return first_para(m.group(1).lstrip("!"), 520) if m else ""


def docstring_before(lines, i):
    j = i - 1
    while j >= 0 and re.match(r"^\s*(@\[|set_option .* in|open .* in|omit |include |attribute )",
                              lines[j]):
        j -= 1
    if j < 0 or not lines[j].rstrip().endswith("-/"):
        return ""
    k = j
    while k >= 0 and "/--" not in lines[k]:
        if k < j and lines[k].rstrip().endswith("-/"):
            return ""
        k -= 1
    if k < 0:
        return ""
    body = "\n".join(lines[k:j + 1])
    body = body[body.index("/--") + 3:]
    body = body[:body.rindex("-/")]
    return first_para(body.replace("**", ""), 600)


def split_statement(src):
    """(binders, conclusion) of the text after the declaration's name."""
    depth, i, n = 0, 0, len(src)
    end = n
    while i < n:
        c = src[i]
        if c in "([{⟨":
            depth += 1
        elif c in ")]}⟩":
            depth -= 1
        elif depth == 0 and src.startswith(":=", i):
            end = i
            break
        elif depth == 0 and (src.startswith("\n  |", i) or src.startswith("\n|", i)
                             or re.match(r"\swhere\b", src[i:i + 7])):
            end = i
            break
        i += 1
    stmt = src[:end]
    depth = 0
    for i, c in enumerate(stmt):
        if c in "([{⟨":
            depth += 1
        elif c in ")]}⟩":
            depth -= 1
        elif c == ":" and depth == 0 and not stmt.startswith(":=", i):
            return stmt[:i], stmt[i + 1:], src[end:]
    return stmt, "", src[end:]


def binders(b):
    """explicit `( … : … )` binders, as written."""
    out, depth, start = [], 0, None
    for i, c in enumerate(b):
        if c in "([{⟨":
            if depth == 0 and c == "(":
                start = i
            depth += 1
        elif c in ")]}⟩":
            depth -= 1
            if depth == 0 and start is not None and c == ")":
                out.append(" ".join(b[start + 1:i].split()))
                start = None
            elif depth == 0:
                start = None
    return [x for x in out if ":" in x]


def tree_files(tree):
    tr = ROOT / tree
    if not tr.exists():
        return []
    return [p for p in sorted(tr.rglob("*.lean"))
            if "/.lake/" not in str(p) and p.name not in ("lakefile.lean", "Scratch.lean")]


def module_of(tree, path):
    return ".".join(path.relative_to(ROOT / tree).with_suffix("").parts)


def parse(tree, path):
    text = path.read_text(errors="replace")
    raw = text.split("\n")
    lines = blank_comments(text).split("\n")
    module = module_of(tree, path)
    imports = [m for m in re.findall(r"^import\s+(\S+)", "\n".join(lines), re.M)
               if not m.startswith(EXTERNAL)]
    stack, opens, decls = [], set(), []
    for i, ln in enumerate(lines):
        m = re.match(r"^(?:noncomputable\s+)?(namespace|section)\b\s*(\S*)", ln)
        if m:
            stack.append((m.group(1), m.group(2))); continue
        if re.match(r"^end\b", ln):
            if stack:
                stack.pop()
            continue
        m = re.match(r"^open\s+(.*)", ln)
        if m:
            for w in m.group(1).replace("scoped", " ").split():
                if w in ("in", "hiding", "renaming"):
                    break
                opens.add(w.strip("()"))
            continue
        m = DECL.match(ln)
        if m:
            kind, name = m.group(1), m.group(2)
            ns = ".".join(s[1] for s in stack if s[0] == "namespace")
            if name.startswith("_root_."):
                name, full = name[7:], name[7:]
            else:
                full = (ns + "." + name) if ns else name
            decls.append({"kind": "theorem" if kind == "lemma" else kind, "name": name,
                          "ns": ns, "full": full, "line": i + 1, "start": i,
                          "private": bool(re.match(r"^(?:@\[[^\]]*\]\s*)*.*\bprivate\b", ln[:ln.index(kind)])),
                          "why": docstring_before(raw, i)})
    for k, d in enumerate(decls):
        end = decls[k + 1]["start"] if k + 1 < len(decls) else len(lines)
        for j in range(d["start"] + 1, end):
            if STOP.match(lines[j]):
                end = j
                break
        body = "\n".join(lines[d["start"]:end])
        d["tokens"] = set(TOK.findall(body))
        d["sorry"] = bool(re.search(r"\bsorry\b", body))
        key = d["name"] if d["name"] in body else d["name"].split(".")[-1]
        after = body[body.index(key) + len(key):] if key in body else body
        b, c, rest = split_statement(after)
        d["needs"] = binders(b)
        d["proves"] = " ".join(c.split())
        if d["kind"] != "theorem" and not d["proves"]:
            d["proves"] = " ".join(b.split())
        d["sig"] = " ".join(after.split())
    return {"tree": tree, "path": str(path.relative_to(ROOT)), "module": module,
            "stem": path.stem, "header": file_header(text), "imports": imports,
            "opens": sorted(opens), "namespaces": sorted({d["ns"] for d in decls if d["ns"]}),
            "lines": len(raw), "decls": decls,
            "sha": hashlib.sha256(text.encode()).hexdigest(),
            "copy_of": ("lean/" + path.name) if "/TablePort/" in str(path) else None}


# ---------------------------------------------------------------- reading Lean's dump

def load_kernel():
    """{tree: {constant name: record}}, {path: sha at dump time}."""
    K, shas = {}, {}
    if (KDIR / "sources.json").exists():
        shas = json.loads((KDIR / "sources.json").read_text())
    for tree, _ in TREES:
        f = KDIR / f"{tree}.jsonl"
        if f.exists():
            K[tree] = {}
            for ln in f.read_text().splitlines():
                r = json.loads(ln)
                K[tree][r["n"]] = r
    return K, shas


def bare(n):
    """a kernel name without Lean's private prefix."""
    m = re.match(r"^_private\.(.*?)\.0\.(.*)$", n)
    return m.group(2) if m else n


def dump():
    body = (ROOT / "utilities/lean_dump/Dump.lean").read_text()
    body = body[body.index("open Lean"):]
    KDIR.mkdir(parents=True, exist_ok=True)
    shas = {}
    for tree, _ in TREES:
        files = tree_files(tree)
        if not files:
            continue
        mods = [module_of(tree, p) for p in files]
        roots = sorted({m.split(".")[0] for m in mods})
        src = "".join(f"import {m}\n" for m in mods) + "import Lean\n" + body + \
            "\n#eval dumpAll [" + ", ".join("`" + r for r in roots) + "]\n"
        with tempfile.TemporaryDirectory() as td:
            f = pathlib.Path(td) / "run.lean"
            f.write_text(src)
            r = subprocess.run(["lake", "env", "lean", str(f)], cwd=ROOT / tree,
                               capture_output=True, text=True)
        if r.returncode != 0:
            print(f"DUMP FAILED in {tree}/ (is it built?)\n{r.stderr[:2000]}\n{r.stdout[-2000:]}")
            sys.exit(1)
        rows = sorted((ln for ln in r.stdout.splitlines() if ln.startswith("{")),
                      key=lambda s: json.loads(s)["n"])
        for i, ln in enumerate(rows):
            o = json.loads(ln)
            o["ty"].sort(); o["pf"].sort()
            rows[i] = json.dumps(o, ensure_ascii=False, sort_keys=True, separators=(",", ":"))
        (KDIR / f"{tree}.jsonl").write_text("\n".join(rows) + "\n")
        for p in files:
            shas[str(p.relative_to(ROOT))] = hashlib.sha256(p.read_text(errors="replace").encode()).hexdigest()
        print(f"{tree}: {len(rows)} constants from Lean")
    (KDIR / "sources.json").write_text(json.dumps(shas, indent=0, sort_keys=True) + "\n")


# ---------------------------------------------------------------- joining the two

def collect():
    mods = [parse(tree, p) for tree, _ in TREES for p in tree_files(tree)]
    real = [m for m in mods if not m["copy_of"]]
    K, shas = load_kernel()
    by_full, by_bare = {}, defaultdict(list)
    for m in real:
        for d in m["decls"]:
            d["file"] = m["path"]
            d["id"] = m["path"] + "::" + d["full"]
            by_full.setdefault((m["tree"], d["full"]), d)
            by_full.setdefault(("*", d["full"]), d)
            by_bare[d["name"]].append((m, d))
    rec = {"phantom": [], "unlisted": [], "helpers": 0, "notation": 0, "stale": [],
           "nodump": [], "kernel_total": {t: len(k) for t, k in K.items()},
           "copy_diff": [], "text_vs_lean": None, "only_text": [], "only_lean": []}

    # 1. every source declaration is a constant Lean holds, in that module
    for m in mods:
        k = K.get(m["tree"])
        m["fresh"] = k is not None and shas.get(m["path"]) == m["sha"]
        if not m["fresh"] and not m["copy_of"]:
            rec["stale" if k is not None and m["path"] in shas else "nodump"].append(m["path"])
        keep = []
        for d in m["decls"]:
            d["k"] = None
            if m["fresh"]:
                r = k.get(d["full"]) or k.get(f"_private.{m['module']}.0.{d['full']}")
                if r is None or r["m"] != m["module"]:
                    rec["phantom"].append(f"{m['path']}:{d['line']} {d['kind']} {d['full']}")
                    continue
                d["k"] = r["n"]
                d["kind"] = {"theorem": "theorem", "axiom": "axiom", "inductive": d["kind"],
                             "opaque": "opaque"}.get(r["k"], d["kind"] if d["kind"] != "theorem" else "def")
            keep.append(d)
        m["decls"] = keep

    # 2. every constant Lean holds is a source declaration or a helper of one
    owner = {}                       # (tree, kernel name) -> declaration it is
    for m in mods:
        tgt = m if not m["copy_of"] else None
        for d in m["decls"]:
            if d["k"]:
                if tgt is None:      # a copy: point at the original's declaration
                    o = by_full.get(("lean", d["full"]))
                    if o:
                        owner[(m["tree"], d["k"])] = o
                else:
                    owner[(m["tree"], d["k"])] = d
    fresh_mod = {(m["tree"], m["module"]) for m in mods if m["fresh"]}
    for tree, k in K.items():
        for n, r in k.items():
            if (tree, n) in owner or (tree, r["m"]) not in fresh_mod:
                continue
            parts = bare(n).split(".")
            par = any((tree, ".".join(parts[:i])) in by_full or ("lean", ".".join(parts[:i])) in by_full
                      for i in range(1, len(parts)))
            if AUTO.match(parts[-1]) or any(p.startswith("_") for p in parts):
                rec["helpers" if par else "notation"] += 1
            elif par:
                rec["helpers"] += 1  # a structure's field, held under its parent
            else:
                rec["unlisted"].append(f"{tree}: {n} ({r['k']}, module {r['m']})")

    # 3. what feeds what, from Lean, following helpers through
    memo = {}

    def resolve(tree, n, seen=()):
        key = (tree, n)
        if key in owner:
            return {owner[key]["id"]}
        if key in memo:
            return memo[key]
        r = K[tree].get(n)
        if r is None or n in seen:
            return set()
        out = set()
        for c in r["ty"] + r["pf"]:
            out |= resolve(tree, c, seen + (n,))
        memo[key] = out
        return out

    def lean_uses(tree, d):
        r = K[tree][d["k"]]
        st, pf = set(), set()
        for c in r["ty"]:
            st |= resolve(tree, c)
        for c in r["pf"]:
            pf |= resolve(tree, c)
        st.discard(d["id"]); pf.discard(d["id"])
        return st, pf

    def text_uses(m, d):
        scope = set(m["namespaces"]) | set(m["opens"])
        uses = set()
        for t in d["tokens"]:
            t = t.rstrip(".")
            if t in (d["name"], d["full"]):
                continue
            hit = by_full.get((m["tree"], t)) or (by_full.get(("*", t)) if "." in t else None)
            if hit is None and "." in t:
                for ns in scope:
                    hit = by_full.get((m["tree"], ns + "." + t))
                    if hit:
                        break
            if hit is None and "." not in t and t in by_bare:
                cands = by_bare[t]
                pick = ([c for c in cands if c[0]["path"] == m["path"]] or
                        [c for c in cands if c[1]["ns"] in scope and c[0]["tree"] == m["tree"]])
                if pick:
                    hit = pick[0][1]
            if hit is not None and hit is not d:
                uses.add(hit["id"])
        return uses

    agree = only_text = only_lean = 0
    for m in real:
        for d in m["decls"]:
            t = text_uses(m, d)
            if d["k"]:
                st, pf = lean_uses(m["tree"], d)
                d["stmt"], d["proof"], d["exact"] = sorted(st), sorted(pf - st), True
                l = st | pf
                agree += len(l & t); only_text += len(t - l); only_lean += len(l - t)
                rec["only_text"] += [(d["id"], u) for u in sorted(t - l)]
                rec["only_lean"] += [(d["id"], u) for u in sorted(l - t)]
            else:
                d["stmt"], d["proof"], d["exact"] = [], sorted(t), False
            d["uses"] = sorted(set(d["stmt"]) | set(d["proof"]))
    rec["text_vs_lean"] = (agree, only_text, only_lean)

    # 4. a copy must rest on the same declarations as its original
    for m in mods:
        if not (m["copy_of"] and m["fresh"]):
            continue
        for d in m["decls"]:
            o = by_full.get(("lean", d["full"]))
            if d["k"] and o is not None and o.get("exact"):
                r = K[m["tree"]][d["k"]]
                got = set()
                for c in r["ty"] + r["pf"]:
                    got |= resolve(m["tree"], c)
                got.discard(o["id"])
                if got != set(o["uses"]):
                    rec["copy_diff"].append(f"{m['path']} {d['full']}")

    D = {d["id"]: d for m in real for d in m["decls"]}
    for d in D.values():
        d["used_by"] = []
        d["uses"] = [u for u in d["uses"] if u in D]
        d["stmt"] = [u for u in d["stmt"] if u in D]
        d["proof"] = [u for u in d["proof"] if u in D]
    for d in D.values():
        for u in d["uses"]:
            D[u]["used_by"].append(d["id"])
    for d in D.values():
        d["used_by"].sort()
    pm = {(m["tree"], m["module"]): m["path"] for m in mods}
    for m in mods:
        m["imports_files"] = sorted({pm[(m["tree"], i)] for i in m["imports"] if (m["tree"], i) in pm})
    return mods, real, D, rec


# ---------------------------------------------------------------- writing

def esc(s, n=None):
    s = " ".join(str(s).split())
    if n and len(s) > n:
        s = s[:n] + "…"
    for a, b in (('"', "'"), ("`", "'"), ("<", "＜"), (">", "＞"), ("#", "＃"),
                 ("&", "＆"), ("\\", "＼")):
        s = s.replace(a, b)
    return s


def cell(s, n=900):
    s = " ".join(str(s).split())
    if len(s) > n:
        s = s[:n] + "…"
    return s.replace("|", "\\|").replace("<", "&lt;").replace(">", "&gt;") or "—"


def code(s, n=None):
    """inline code that survives backticks and pipes inside a list item."""
    s = " ".join(str(s).split())
    if n and len(s) > n:
        s = s[:n] + "…"
    return "`` " + s.replace("`", "'") + " ``" if s else "—"


def page_of(path):
    p = pathlib.Path(path)
    return f"{p.parts[0]}/{p.stem}.md" if "TablePort" not in path else f"{p.parts[0]}/TablePort_{p.stem}.md"


def anchor(d):
    return re.sub(r"[^A-Za-z0-9_]", "-", d["full"])


CLASSDEFS = """  classDef thm fill:#eef4ff,stroke:#335,color:#111
  classDef end_ fill:#e7f7e7,stroke:#2a7,color:#111,stroke-width:2px
  classDef lone fill:#fff,stroke:#999,color:#111,stroke-dasharray:4 3
  classDef bad fill:#ffe5e5,stroke:#c22,color:#111,stroke-width:2px
  classDef ext fill:#fff8e1,stroke:#b80,color:#111"""
LEGEND = ("An arrow A → B reads \"A is used in the proof of B\". Blue: theorem. Green: a theorem "
          "nothing else uses (an end). Dashed: connects to nothing. Red: contains `sorry`. "
          "Yellow: theorems in another file, counted; a dotted arrow crosses files. "
          "Definitions are not drawn; they are listed below the diagram.")


def plural(n, w):
    return f"{n} {w}" + ("" if n == 1 else "s")


def is_thm(d):
    return d["kind"] == "theorem"


def klass(d):
    if d["sorry"]:
        return "bad"
    if not d["used_by"] and not d["uses"]:
        return "lone"
    if not d["used_by"]:
        return "end_"
    return "thm"


def diagram(chunk, D, where):
    """theorems of one file; `where` maps a same-file theorem outside the chunk to its diagram."""
    ids = {d["id"]: f"n{k}" for k, d in enumerate(chunk)}
    L = ["flowchart LR"]
    for d in chunk:
        L.append(f'  {ids[d["id"]]}["<b>{esc(d["name"])}</b><br/>{esc(d["proves"], 64)}"]:::{klass(d)}')
    solid, dotted, stubs = set(), set(), {}

    def stub(u, direction):
        e = D[u]
        if u in where:
            key, lab = ("d", where[u]), f"diagram {where[u]}"
        else:
            key, lab = ("f", e["file"]), pathlib.Path(e["file"]).stem
        key += (direction,)
        if key not in stubs:
            stubs[key] = [f"x{len(stubs)}", lab, set()]
        stubs[key][2].add(u)
        return stubs[key][0]
    for d in chunk:
        for u in d["uses"]:
            if not is_thm(D[u]):
                continue
            if u in ids:
                solid.add((ids[u], ids[d["id"]]))
            else:
                dotted.add((stub(u, "in"), ids[d["id"]]))
        for u in d["used_by"]:
            if is_thm(D[u]) and u not in ids:
                dotted.add((ids[d["id"]], stub(u, "out")))
    for s, lab, mem in stubs.values():
        what = "<br/>".join(esc(D[u]["name"], 40) for u in sorted(mem)) if len(mem) <= 3 \
            else f"{len(mem)} theorems"
        L.append(f'  {s}(["<b>{esc(lab)}</b><br/>{what}"]):::ext')
    for a, b in sorted(solid):
        L.append(f"  {a} --> {b}")
    for a, b in sorted(dotted):
        L.append(f"  {a} -.-> {b}")
    L.append(CLASSDEFS)
    return "\n".join(L), len(solid) + len(dotted)


def file_diagrams(m, D):
    thms = [d for d in m["decls"] if is_thm(d)]
    size = MAXN
    while True:
        chunks = [thms[i:i + size] for i in range(0, len(thms), size)]
        where = {d["id"]: k + 1 for k, c in enumerate(chunks) for d in c}
        out = [diagram(c, D, {u: w for u, w in where.items() if w != k + 1})
               for k, c in enumerate(chunks)]
        if all(e <= MAXE for _, e in out) or size <= 6:
            return [g for g, _ in out], chunks
        size = max(6, size * 2 // 3)


def reduce_edges(nodes, edges):
    """transitive reduction of a DAG given as {node: set(preds)}."""
    preds = {n: set(edges.get(n, ())) & set(nodes) - {n} for n in nodes}
    memo = {}

    def anc(n, path=()):
        if n not in memo:
            a = set()
            for p in preds[n]:
                if p not in path:
                    a |= {p} | anc(p, path + (n,))
            memo[n] = a
        return memo[n]
    red = {}
    for n in nodes:
        keep = set(preds[n])
        for p in preds[n]:
            keep -= anc(p)
        red[n] = keep
    return red


def files_diagram(ms):
    nodes = [m["path"] for m in ms]
    red = reduce_edges(nodes, {m["path"]: set(m["imports_files"]) for m in ms})
    ids = {p: f"f{k}" for k, p in enumerate(nodes)}
    L = ["flowchart LR"]
    for m in ms:
        nt = sum(1 for d in m["decls"] if is_thm(d))
        cls = "ext" if m["copy_of"] else ("bad" if any(d["sorry"] for d in m["decls"]) else "thm")
        tag = "copy" if m["copy_of"] else plural(nt, "theorem")
        L.append(f'  {ids[m["path"]]}["{esc(m["stem"])}<br/>{tag}"]:::{cls}')
    for n in nodes:
        for p in sorted(red[n]):
            L.append(f"  {ids[p]} --> {ids[n]}")
    L.append(CLASSDEFS)
    return "\n".join(L)


def closure(d, D):
    seen, stack = set(), list(d["uses"])
    while stack:
        u = stack.pop()
        if u not in seen:
            seen.add(u)
            stack.extend(D[u]["uses"])
    return seen


def build():
    mods, real, D, rec = collect()
    files = {}
    imported_by = defaultdict(set)
    for m in mods:
        for f in m["imports_files"]:
            imported_by[f].add(m["path"])

    def up(frm):
        return "../" * (len(pathlib.Path(frm).parts) - 1)

    def flink(path, frm):
        return f"[`{pathlib.Path(path).stem}`]({up(frm)}{page_of(path)})"

    def dlink(u, frm):
        e = D[u]
        tgt = page_of(e["file"])
        href = f"#{anchor(e)}" if tgt == frm else f"{up(frm)}{tgt}#{anchor(e)}"
        return f"[`{e['full']}`]({href})"

    def feed_lines(ids, frm, cap=60):
        out = []
        for u in ids[:cap]:
            e = D[u]
            where = "" if page_of(e["file"]) == frm else f" ({pathlib.Path(e['file']).stem})"
            what = code(e["proves"], 150) if is_thm(e) else f"{e['kind']}"
            out.append(f"  - {dlink(u, frm)}{where} — {what}")
        if len(ids) > cap:
            out.append(f"  - and {len(ids) - cap} more; the full list is in `map/lean_map.json`")
        return out

    for m in mods:
        pg = page_of(m["path"])
        L = [f"# `{m['path']}`", ""]
        if m["copy_of"]:
            L += [f"A copy of `{m['copy_of']}` on Stage 3's toolchain, held to it by "
                  f"`utilities/check_port.py`. Its declarations are on the original's page: "
                  f"{flink(m['copy_of'], pg)}.", ""]
            files[pg] = "\n".join(L) + "\n"
            continue
        thms = [d for d in m["decls"] if is_thm(d)]
        defs = [d for d in m["decls"] if not is_thm(d)]
        if not m["fresh"]:
            L += ["> **Read from the source text.** This file changed after the last "
                  "`python3 utilities/lean_map.py --dump`, so the arrows on this page are names "
                  "occurring in each proof and have not been confirmed by Lean.", ""]
        L += [m["header"] or "This file has no header comment.", "",
              f"{plural(len(thms), 'theorem')}, {plural(len(defs), 'definition')}, {m['lines']} lines. "
              + ("Arrows are Lean's own record of what each proof uses." if m["fresh"] else ""), "",
              "**Imports:** " + (", ".join(flink(f, pg) for f in m["imports_files"]) or "nothing in this tree") + "  ",
              "**Imported by:** " + (", ".join(flink(f, pg) for f in sorted(imported_by[m["path"]])) or "nothing"), ""]
        dg, chunks = file_diagrams(m, D)
        if dg:
            L += ["## The picture", ""]
        for k, g in enumerate(dg):
            if len(dg) > 1:
                L += [f"### Diagram {k + 1} of {len(dg)}: `{chunks[k][0]['name']}` to `{chunks[k][-1]['name']}`", ""]
            L += ["```mermaid", g, "```", ""]
            files[pg[:-3] + (f".{k + 1}" if len(dg) > 1 else "") + ".mmd"] = g + "\n"
        if dg:
            L += [LEGEND, ""]
        if defs:
            L += ["## Definitions", ""]
            for d in defs:
                L += [f"<a name=\"{anchor(d)}\"></a>", f"### `{d['full']}`", "",
                      f"{d['kind']} · line {d['line']}", ""]
                if d["why"]:
                    L += [d["why"], ""]
                L += ["- **Is:** " + code(d["name"] + " " + d["sig"], 420)]
                if d["uses"]:
                    L += ["- **Built from:** " + ", ".join(dlink(u, pg) for u in d["uses"][:40])]
                ub = d["used_by"]
                L += [f"- **Used by {len(ub)}:** " + (", ".join(dlink(u, pg) for u in ub[:40]) +
                      (f", and {len(ub) - 40} more (full list in `map/lean_map.json`)" if len(ub) > 40 else "")
                      if ub else "nothing"), ""]
        if thms:
            L += ["## Theorems", ""]
        for d in thms:
            tag = "  ⚠ contains `sorry`" if d["sorry"] else ""
            L += [f"<a name=\"{anchor(d)}\"></a>", f"### `{d['full']}`{tag}", "",
                  f"line {d['line']}" + ("" if d["exact"] else " · arrows read from text"), ""]
            if d["why"]:
                L += [f"**Why.** {d['why']}", ""]
            L += ["**Proves**", "", "```lean", d["proves"] or "(statement not parsed; see the source line)", "```", ""]
            if d["needs"]:
                L += ["**Needs** (its hypotheses)", ""] + [f"  - {code(n, 300)}" for n in d["needs"]] + [""]
            st = [u for u in d["stmt"]]
            if st:
                L += ["**Stated with:** " + ", ".join(dlink(u, pg) for u in st), ""]
            pf_t = [u for u in d["proof"] if is_thm(D[u])]
            pf_d = [u for u in d["proof"] if not is_thm(D[u])]
            if pf_t:
                L += [f"**Fed by** ({plural(len(pf_t), 'theorem')} its proof uses)", ""] + feed_lines(pf_t, pg) + [""]
            else:
                L += ["**Fed by:** no theorem of this repo; it stands on Mathlib"
                      + (" and the definitions below" if (pf_d or st) else "") + ".", ""]
            if pf_d:
                L += ["**Definitions its proof touches:** " + ", ".join(dlink(u, pg) for u in pf_d), ""]
            if d["used_by"]:
                L += [f"**Feeds** ({len(d['used_by'])} that use it)", ""] + feed_lines(d["used_by"], pg) + [""]
            else:
                L += ["**Feeds:** nothing. " + ("It is an end." if d["uses"] else "It connects to nothing."), ""]
        files[pg] = "\n".join(L) + "\n"

    # one page per end with a long line behind it: the files it passes through, then
    # every declaration on the way, file by file in dependency order
    order = {m["path"]: i for i, m in enumerate(real)}
    chain_of = {}
    for d in D.values():
        if not (is_thm(d) and d["uses"] and not d["used_by"]):
            continue
        cl = closure(d, D)
        if len(cl) < CHAIN_MIN:
            continue
        pg = f"chains/{anchor(d)}.md"
        chain_of[d["id"]] = pg
        inside = cl | {d["id"]}
        fs = sorted({D[u]["file"] for u in inside}, key=lambda f: order[f])
        fedges = defaultdict(set)
        for u in inside:
            for v in D[u]["uses"]:
                if D[v]["file"] != D[u]["file"]:
                    fedges[D[u]["file"]].add(D[v]["file"])
        done, left = [], list(fs)           # dependency order: a file after all it uses
        while left:
            nxt = next((f for f in left if not (fedges[f] & set(left))), left[0])
            done.append(nxt); left.remove(nxt)
        fs = done
        red = reduce_edges(fs, fedges)
        fid = {f: f"f{k}" for k, f in enumerate(fs)}
        G = ["flowchart LR"]
        for f in fs:
            n = sum(1 for u in cl if D[u]["file"] == f)
            if f == d["file"]:
                G.append(f'  {fid[f]}["<b>{esc(pathlib.Path(f).stem)}</b><br/>{esc(d["name"])}"]:::end_')
            else:
                G.append(f'  {fid[f]}["<b>{esc(pathlib.Path(f).stem)}</b><br/>{n} used"]:::'
                         + ("ext" if f.split("/")[0] != d["file"].split("/")[0] else "thm"))
        for f in fs:
            for q in sorted(red[f], key=fs.index):
                G.append(f"  {fid[q]} --> {fid[f]}")
        G.append(CLASSDEFS)
        g = "\n".join(G)
        files[pg[:-3] + ".mmd"] = g + "\n"
        nt = sum(1 for u in cl if is_thm(D[u]))
        L = [f"# What `{d['full']}` rests on", "",
             f"{dlink(d['id'], pg)} in `{d['file']}`, line {d['line']}.", ""]
        if d["why"]:
            L += [f"**Why.** {d['why']}", ""]
        L += ["**Proves**", "", "```lean", d["proves"], "```", ""]
        if d["needs"]:
            L += ["**Needs** (its hypotheses)", ""] + [f"  - {code(n, 300)}" for n in d["needs"]] + [""]
        L += [f"Behind it: {plural(nt, 'theorem')} and {plural(len(cl) - nt, 'definition')} in "
              f"{plural(len(fs), 'file')}. Every one is listed below; Lean recorded each step.", "",
              "## The files it passes through", "", "```mermaid", g, "```", "",
              "An arrow A → B reads \"B uses something proved or defined in A\"; indirect arrows are "
              "left out. Green: the theorem itself. Yellow: a file in the other tree. The number is "
              "how many of that file's declarations are on the way.", "",
              "## Every declaration on the way", "",
              "Files in dependency order. ★ marks what the theorem's own proof uses directly.", ""]
        for f in fs:
            here = sorted((u for u in cl if D[u]["file"] == f), key=lambda u: D[u]["line"])
            if not here:
                continue
            L += [f"### {flink(f, pg)} — {len(here)}", ""]
            for u in here:
                e = D[u]
                star = "★ " if u in d["uses"] else ""
                what = code(e["proves"], 160) if is_thm(e) else f"*{e['kind']}*"
                L.append(f"- {star}{dlink(u, pg)} — {what}")
            L.append("")
        files[pg] = "\n".join(L) + "\n"

    # the one-line-per-declaration list
    A = ["# Every declaration, one line each", "",
         "Sorted by name. Search this file before saying something is missing.", "",
         "| name | kind | file | proves |", "|---|---|---|---|"]
    for d in sorted(D.values(), key=lambda d: (d["name"].lower(), d["full"])):
        A.append(f"| [`{d['full']}`](./{page_of(d['file'])}#{anchor(d)}) | {d['kind']} | "
                 f"`{pathlib.Path(d['file']).stem}` | {cell(d['proves'], 200)} |")
    files["ALL.md"] = "\n".join(A) + "\n"

    R = ["# Reconciliation, in full", "",
         "The arrows in this map are Lean's. This page lists every place where reading names "
         "out of the source text would have said something different, so the difference can be "
         "opened and looked at.", "",
         f"## Names in the text that Lean does not record as a use ({len(rec['only_text'])})", "",
         "A local variable sharing a definition's name, a same-named theorem in another namespace, "
         "or an abbreviation Lean unfolds while elaborating.", "",
         "| in | the text names | line |", "|---|---|---|"]
    for a, b in rec["only_text"]:
        R.append(f"| {dlink(a, 'RECONCILE.md')} | `{D[b]['full']}` | `{D[a]['file']}:{D[a]['line']}` |")
    R += ["", f"## Uses Lean records that the text does not show ({len(rec['only_lean'])})", "",
          "Found by `simp`, by unfolding, through an instance, or under another name.", "",
          "| in | Lean records | kind |", "|---|---|---|"]
    for a, b in rec["only_lean"]:
        R.append(f"| {dlink(a, 'RECONCILE.md')} | {dlink(b, 'RECONCILE.md')} | {D[b]['kind']} |")
    files["RECONCILE.md"] = "\n".join(R) + "\n"

    thms = [d for d in D.values() if is_thm(d)]
    road, top = road_page(D, thms, chain_of)
    files["ROAD.md"] = road
    files["ROAD.mmd"] = top + "\n"

    # index
    lone = sorted((d for d in thms if not d["uses"] and not d["used_by"]), key=lambda d: d["id"])
    ends = sorted((d for d in thms if d["uses"] and not d["used_by"]), key=lambda d: d["id"])
    sorries = sorted((d for d in D.values() if d["sorry"]), key=lambda d: d["id"])
    exact = sum(1 for d in D.values() if d["exact"])
    a, ot, ol = rec["text_vs_lean"]
    I = ["# The Lean map", "",
         "Every declaration in every Lean file of this repo: what it proves, what it needs, why, "
         "what feeds it and what it feeds. Generated by `python3 utilities/lean_map.py`; nothing "
         "here is written by hand. The workflow `.github/workflows/lean_map.yml` regenerates it on "
         "every push that touches a `.lean` file.", "",
         f"**{len(real)} files, {len(D)} declarations, {len(thms)} theorems.** "
         f"{len(ends)} theorems are ends (nothing in the repo uses them). "
         f"{len(lone)} theorems connect to nothing. {plural(len(sorries), 'declaration')} "
         f"contain{'s' if len(sorries) == 1 else ''} `sorry`. "
         f"{len(mods) - len(real)} files are copies under `TablePort/`.", "",
         "## In five seconds", "",
         "```mermaid", top, "```", "",
         "Red: a statement nobody has proved, here or anywhere. Blue: a theorem Lean has checked. "
         "Green: where a checked line arrives. Left of `RiemannHypothesis`: what would prove it. "
         "Right of it: what it gives the table. Every box, with its statement and what is open: "
         "[`ROAD.md`](./ROAD.md).", "",
         "## How to look something up", "",
         "- **Is it already here?** [`ALL.md`](./ALL.md): every declaration, one line, sorted by name.",
         "- **What does a file do?** The tables below, one row per file.",
         "- **What does a theorem rest on, and what rests on it?** Its file's page: each theorem has "
         "*Proves*, *Needs*, *Fed by*, *Feeds*, each feeder and consumer with its own statement.",
         "- **The whole line behind one theorem:** the table of ends at the bottom of this page "
         "links each long one; for any other, `python3 utilities/lean_map.py --chain NAME`.",
         "- **Did the map read the code right?** [`RECONCILE.md`](./RECONCILE.md).", "",
         "## Reconciliation", "",
         "The arrows are Lean's record of what each statement and proof uses "
         "(`python3 utilities/lean_map.py --dump`, stored in `map/kernel/`). The names are checked "
         "both ways against the source.", "",
         "| check | result |", "|---|---|",
         f"| declarations whose arrows come from Lean | {exact} of {len(D)} |",
         f"| source declarations Lean does not hold | {len(rec['phantom'])} |",
         f"| Lean constants that are neither a source declaration nor a helper of one | {len(rec['unlisted'])} |",
         f"| Lean's helper constants, followed through to their owners | {rec['helpers']} |",
         f"| notation and macro constants | {rec['notation']} |",
         f"| declarations in `TablePort/` copies resting on different declarations than the original | {len(rec['copy_diff'])} |",
         f"| files changed since the last dump (arrows read from text) | {len(rec['stale'])} |",
         f"| files never dumped | {len(rec['nodump'])} |", ""]
    for title, key in (("Source declarations Lean does not hold", "phantom"),
                       ("Lean constants with no source declaration", "unlisted"),
                       ("Copies that differ from the original", "copy_diff"),
                       ("Files changed since the last dump", "stale"),
                       ("Files never dumped", "nodump")):
        if rec[key]:
            I += [f"**{title}:**", ""] + [f"- `{x}`" for x in rec[key]] + [""]
    I += [f"Reading names out of the source text instead, on the same declarations: {a} arrows "
          f"agree with Lean, {ol} that Lean records are not visible in the text, {ot} names occur "
          "in the text without Lean recording a use. That is the error a page carries when it says "
          "\"read from the source text\".", ""]
    for tree, label in TREES:
        ms = [m for m in mods if m["tree"] == tree]
        if not ms:
            continue
        I += [f"## `{tree}/` — {label}", "", "Files, arrows by import (indirect imports left out):", "",
              "```mermaid", files_diagram(ms), "```", ""]
        files[f"{tree}/FILES.mmd"] = files_diagram(ms) + "\n"
        I += ["| file | theorems | what it does (its own header) |", "|---|---|---|"]
        for m in sorted(ms, key=lambda m: m["path"]):
            nt = sum(1 for d in m["decls"] if is_thm(d))
            what = f"copy of `{m['copy_of']}`" if m["copy_of"] else (m["header"] or "no header")
            I.append(f"| [`{m['path']}`](./{page_of(m['path'])}) | {nt} | {cell(what, 300)} |")
        I.append("")
    I += ["## Ends: theorems nothing else uses", "",
          "Each is where a line of the repo arrives. \"Behind it\" counts the declarations it "
          "rests on, through every file; where the number is a link, it opens the whole line: the "
          "files it passes through and every declaration on the way.", "",
          "| theorem | proves | behind it | files behind it |", "|---|---|---|---|"]
    for d in sorted(ends, key=lambda d: (-len(closure(d, D)), d["id"])):
        cl = closure(d, D)
        n = f"[{len(cl)}](./{chain_of[d['id']]})" if d["id"] in chain_of else str(len(cl))
        I.append(f"| [`{d['full']}`](./{page_of(d['file'])}#{anchor(d)}) | {cell(d['proves'], 140)} | "
                 f"{n} | {len({D[u]['file'] for u in cl})} |")
    I += ["", "## Theorems that connect to nothing", "",
          "No repo declaration in their statement or proof, and nothing uses them.", "",
          "| theorem | proves |", "|---|---|"]
    for d in lone:
        I.append(f"| [`{d['full']}`](./{page_of(d['file'])}#{anchor(d)}) | {cell(d['proves'], 140)} |")
    I += ["", "## Declarations containing `sorry`", "", "| declaration | file |", "|---|---|"]
    for d in sorries:
        I.append(f"| [`{d['full']}`](./{page_of(d['file'])}#{anchor(d)}) | `{pathlib.Path(d['file']).stem}` |")
    I.append("")
    drop = ("tokens", "start", "k", "sig", "private")
    slim = [{k: v for k, v in m.items() if k not in ("decls", "sha")} |
            {"decls": [{k: v for k, v in d.items() if k not in drop} for d in m["decls"]]}
            for m in mods]
    files["lean_map.json"] = json.dumps(slim, indent=1, ensure_ascii=False) + "\n"
    counts = (len(real), len(D), len(thms), len(ends), len(lone), len(sorries))
    return "\n".join(I) + "\n", files, counts, (mods, real, D, rec)


RH = "RiemannHypothesis"


def joints():
    """rows of SECTIONS.md whose last column opens with a status word."""
    f = ROOT / "SECTIONS.md"
    out, head = [], ""
    if not f.exists():
        return out
    for ln in f.read_text().splitlines():
        if ln.startswith("## "):
            head = ln[3:].strip()
        m = re.match(r"^\|\s*([^|]+?)\s*\|\s*(.+?)\s*\|\s*(SEALED|OPEN|WELD|FORWARD)\b(.*?)\|?\s*$", ln)
        if m:
            out.append((head, m.group(1), m.group(2), m.group(3), m.group(4).strip(" ;,:.")))
    return out


def road_page(D, thms, chain_of):
    def link(d):
        return f"[`{d['full']}`](./{page_of(d['file'])}#{anchor(d)})"
    into = [d for d in thms if d["proves"].strip() == RH]
    iff = [d for d in thms if d["proves"].strip().startswith(RH + " ↔")]
    outright = [d for d in into if not d["needs"]]
    under = [d for d in thms if any(RH in n for n in d["needs"])]
    under_ends = sorted((d for d in under if not any(D[u] in under for u in d["used_by"])),
                        key=lambda d: (-len(closure(d, D)), d["id"]))
    stmts = [d for d in D.values() if not is_thm(d) and re.match(r"^[Ss]tmt", d["name"])]

    def status(sd):
        pr = [D[u] for u in sd["used_by"] if is_thm(D[u]) and
              re.match(r"^\(?@?([\w.]*\.)?%s\b" % re.escape(sd["name"]), D[u]["proves"].strip())
              and "↔" not in D[u]["proves"]]
        free = [p for p in pr if not p["needs"]]
        return ("proved", free) if free else (("from a hypothesis", pr) if pr else ("open", []))

    # the picture
    G = ["flowchart LR", f'  rh{{{{"<b>{RH}</b><br/>not proved"}}}}:::bad']
    by_name = {sd["name"]: sd for sd in stmts}

    def is_open(n):                      # a hypothesis that is a proved named statement is closed
        t = n.split(":", 1)[1].strip()
        return not (t in by_name and status(by_name[t])[0] == "proved")
    for k, d in enumerate(into):
        hyp = "<br/>".join(esc(n.split(":", 1)[1], 58) for n in d["needs"] if is_open(n)) or "nothing"
        G.append(f'  p{k}["{hyp}"]:::bad')
        G.append(f'  t{k}["<b>{esc(d["name"])}</b>"]:::thm')
        G.append(f"  p{k} --> t{k} --> rh")
    for k, d in enumerate(under_ends[:6]):
        G.append(f'  e{k}["<b>{esc(d["name"])}</b><br/>{esc(d["proves"], 58)}"]:::end_')
        G.append(f"  rh --> e{k}")
    if len(under_ends) > 6:
        G.append(f'  more(["and {len(under_ends) - 6} more ends under RH"]):::end_')
        G.append("  rh --> more")
    G.append(CLASSDEFS)
    top = "\n".join(G)

    L = ["# The road", "",
         "What is closed, what is open, and where `RiemannHypothesis` sits. Generated with the rest "
         "of the map; the joints are read from `SECTIONS.md`, everything else from Lean.", "",
         "```mermaid", top, "```", "",
         f"- **Theorems Lean has checked:** {len(thms)}.",
         f"- **Theorems that prove `{RH}` with no hypothesis:** {len(outright)}."
         + (" " + ", ".join(link(d) for d in outright) if outright else " It is open."),
         f"- **Theorems that prove it from a hypothesis:** {len(into)}. Each hypothesis is a red box: "
         "prove one and the line closes.",
         f"- **Theorems that restate it (`{RH} ↔ …`):** {len(iff)}.",
         f"- **Theorems that assume it:** {len(under)}, arriving at {len(under_ends)} ends.", "",
         f"## Into `{RH}`: what would prove it", "",
         "| theorem | the hypothesis it needs (open) | why (its docstring) |", "|---|---|---|"]
    for d in into:
        L.append(f"| {link(d)} | {cell('; '.join(n for n in d['needs'] if is_open(n)), 400)} | {cell(d['why'], 300)} |")
    L += ["", "## The same statement in other coordinates", "", "| theorem | says |", "|---|---|"]
    for d in iff:
        L.append(f"| {link(d)} | {cell(d['proves'], 300)} |")
    L += ["", f"## Out of `{RH}`: what it gives", "",
          "The ends among the theorems that assume it. \"Behind it\" links the whole line.", "",
          "| theorem | proves | behind it |", "|---|---|---|"]
    for d in under_ends:
        n = len(closure(d, D))
        nn = f"[{n}](./{chain_of[d['id']]})" if d["id"] in chain_of else str(n)
        L.append(f"| {link(d)} | {cell(d['proves'], 200)} | {nn} |")
    L += ["", "## Named statements", "",
          "Every definition named `Stmt…`: a statement the repo set as a target. Open: no theorem "
          "concludes it. From a hypothesis: a theorem concludes it, given something. Proved: a "
          "theorem concludes it outright, at the parameters shown beside it.", "",
          "| statement | status | by | used as a hypothesis in |", "|---|---|---|---|"]
    rank = {"open": 0, "from a hypothesis": 1, "proved": 2}
    for sd in sorted(stmts, key=lambda d: (rank[status(d)[0]], d["full"])):
        st, by = status(sd)
        hyp = sum(1 for u in sd["used_by"] if any(sd["name"] in n for n in D[u]["needs"]))
        mark = {"open": "**OPEN**", "from a hypothesis": "from a hypothesis", "proved": "proved"}[st]
        L.append(f"| {link(sd)} | {mark} | {'<br/>'.join(link(p) + ' ⊢ ' + cell(p['proves'], 90) for p in by[:4]) or '—'} | {hyp} |")
    js = joints()
    if js:
        L += ["", "## Joints", "", "From `SECTIONS.md`, open ones first.", "",
              "| section | joint | what it joins | status |", "|---|---|---|---|"]
        for h, i, t, st, rest in sorted(js, key=lambda j: j[3] != "OPEN"):
            L.append(f"| {cell(h, 60)} | {cell(i)} | {cell(t, 260)} | "
                     f"{'**OPEN**' if st == 'OPEN' else st}{' — ' + cell(rest, 200) if rest else ''} |")
    return "\n".join(L) + "\n", top


def chain(name):
    _, _, _, (mods, real, D, rec) = build()
    hits = [d for d in D.values() if d["full"] == name or d["name"] == name]
    if not hits:
        print("no declaration named", name); sys.exit(1)
    order = {m["path"]: i for i, m in enumerate(real)}
    for d in hits:
        cl = closure(d, D)
        print(f"{d['full']}  ({d['file']}:{d['line']})\n  proves: {d['proves']}")
        print(f"  rests on {len(cl)} declarations in {len({D[u]['file'] for u in cl})} files\n")
        for f in sorted({D[u]["file"] for u in cl}, key=lambda f: order[f]):
            print(f"  {f}")
            for u in sorted((u for u in cl if D[u]["file"] == f), key=lambda u: D[u]["line"]):
                e = D[u]
                mark = "*" if u in d["uses"] else " "
                print(f"   {mark} {e['kind']:8} {e['full']}  ⊢ {e['proves'][:110]}")
        print("\n  * = used directly")


def main():
    if "--dump" in sys.argv:
        dump()
    if "--chain" in sys.argv:
        return chain(sys.argv[sys.argv.index("--chain") + 1])
    index, files, counts, (mods, real, D, rec) = build()
    if "--audit" in sys.argv:
        for k in ("phantom", "unlisted", "copy_diff", "stale", "nodump"):
            print(f"{k}: {len(rec[k])}")
            for x in rec[k]:
                print("   ", x)
        print("helpers", rec["helpers"], "notation", rec["notation"],
              "kernel constants", rec["kernel_total"])
        print("text vs Lean (agree, only text, only Lean):", rec["text_vs_lean"])
        return
    want = {OUT / "README.md": index} | {OUT / k: v for k, v in files.items()}
    keep = {KDIR / "sources.json"} | {KDIR / f"{t}.jsonl" for t, _ in TREES}
    if "--check" in sys.argv:
        stale = [str(p.relative_to(ROOT)) for p, v in want.items()
                 if not p.exists() or p.read_text() != v]
        have = {p for p in OUT.rglob("*") if p.is_file()} if OUT.exists() else set()
        extra = [str(p.relative_to(ROOT)) for p in have - set(want) - keep]
        if stale or extra:
            print("MAP STALE: run python3 utilities/lean_map.py")
            for s in (stale + extra)[:20]:
                print("  ", s)
            sys.exit(1)
        print("MAP OK")
        return
    if OUT.exists():
        for p in sorted(OUT.rglob("*"), reverse=True):
            if p.is_file() and p not in want and p not in keep:
                p.unlink()
    for p, v in want.items():
        p.parent.mkdir(parents=True, exist_ok=True)
        if not p.exists() or p.read_text() != v:
            p.write_text(v)
    print("files %d, declarations %d, theorems %d, ends %d, connect to nothing %d, sorry %d" % counts)
    print("from Lean: %d of %d declarations; phantom %d, unlisted %d, stale files %d" % (
        sum(1 for d in D.values() if d["exact"]), len(D), len(rec["phantom"]),
        len(rec["unlisted"]), len(rec["stale"]) + len(rec["nodump"])))
    print("wrote map/README.md and", len(files), "files under map/")


if __name__ == "__main__":
    main()
