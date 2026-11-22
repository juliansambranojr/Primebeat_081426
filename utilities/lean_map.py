#!/usr/bin/env python3
"""lean_map — the map of every Lean declaration in this repo, as Mermaid.

    python3 utilities/lean_map.py          regenerate map/ (index: map/README.md)
    python3 utilities/lean_map.py --check  exit 1 if they are out of date

Nothing in the output is written by hand. How each field is made:

  what the file does   the first paragraph of the file's own header comment
  why (per theorem)    the first paragraph of the theorem's own docstring
  needs (input)        the explicit binders `( … : … )` of its statement
  proves (output)      the statement after its top-level colon
  uses / used by       repo declarations whose name occurs as a token in the
                       statement or proof: a qualified `Ns.name`, or a bare
                       `name` declared in the same file or in a namespace
                       the file opens or sits in
  imports              `import` lines naming a module of the same tree

An arrow A --> B reads "A is used by B": premises flow into conclusions.

Limits, stated once: a use through a `simp` set, an instance or a tactic that
finds a lemma by itself is not seen; a bare name shared by two namespaces is
resolved to the same file first. A theorem with no arrows is shown with none.
"""
import hashlib, json, pathlib, re, sys
from collections import defaultdict

ROOT = pathlib.Path(__file__).resolve().parent.parent
OUT = ROOT / "map"
TREES = [("lean", "the table's tree, Lean v4.28.0"),
         ("lean_stage3", "Stage 3, Lean v4.32.2"),
         ("lean_bridge", "the bridge, Lean v4.33.0-rc2")]
EXTERNAL = ("Mathlib", "PrimeNumberTheoremAnd", "Lean", "Batteries", "Aesop",
            "ZetaTwoThree", "Zeta23", "Std", "Qq", "ProofWidgets", "Plausible")
DECL = re.compile(r"^(?:private |protected )?(?:noncomputable )?"
                  r"(theorem|lemma|def|abbrev|structure|instance)\s+([^\s:({\[]+)")
# a declaration's body ends at the next one, or at the first top-level command
STOP = re.compile(r"^(#|end\b|namespace\b|section\b|/-!|/-- info|open\b|variable\b|"
                  r"set_option\b|noncomputable section|attribute\b|@\[)")
TOK = re.compile(r"[A-Za-z_][A-Za-z0-9_'.₀-₉]*")
MAXN = 36          # declarations per diagram
MAXSTUB = 40       # external stubs per diagram before collapsing to files


def strip_comments(t):
    t = re.sub(r"/-.*?-/", " ", t, flags=re.S)
    return re.sub(r"--[^\n]*", " ", t)


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
    return first_para(m.group(1), 520) if m else ""


def docstring_before(lines, i):
    j = i - 1
    while j >= 0 and (lines[j].strip() == "" or re.match(
            r"^\s*(@\[|set_option .* in|open .* in|omit |include |attribute )", lines[j])):
        if lines[j].strip() == "":
            break
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
    return first_para(body.replace("**", ""), 360)


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
        elif depth == 0 and (src.startswith("\n  |", i) or src.startswith(" where", i)):
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
            return stmt[:i], stmt[i + 1:]
    return stmt, ""


def explicit_binders(b):
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


def parse(tree, path):
    text = path.read_text(errors="replace")
    lines = text.split("\n")
    tree_root = ROOT / tree
    rel = path.relative_to(tree_root)
    module = ".".join(rel.with_suffix("").parts)
    imports = [m for m in re.findall(r"^import\s+(\S+)", text, re.M)
               if not m.startswith(EXTERNAL)]
    ns_stack, opens, decls = [], set(), []
    for i, ln in enumerate(lines):
        m = re.match(r"^namespace\s+(\S+)", ln)
        if m:
            ns_stack.append(m.group(1)); continue
        m = re.match(r"^end\s+(\S+)", ln)
        if m and ns_stack and ns_stack[-1] == m.group(1):
            ns_stack.pop(); continue
        m = re.match(r"^open\s+(.*)", ln)
        if m:
            for w in m.group(1).replace("scoped", " ").split():
                if w not in ("in", "hiding", "renaming"):
                    opens.add(w)
            continue
        m = DECL.match(ln)
        if m:
            kind, name = m.group(1), m.group(2)
            ns = ".".join(ns_stack)
            decls.append({"kind": "theorem" if kind == "lemma" else kind, "name": name,
                          "ns": ns, "full": (ns + "." + name) if ns else name,
                          "line": i + 1, "start": i, "why": docstring_before(lines, i)})
    for k, d in enumerate(decls):
        end = decls[k + 1]["start"] if k + 1 < len(decls) else len(lines)
        for j in range(d["start"] + 1, end):
            if STOP.match(lines[j]):
                end = j
                break
        raw = "\n".join(lines[d["start"]:end])
        body = strip_comments(raw)
        d["tokens"] = set(TOK.findall(body))
        d["sorry"] = bool(re.search(r"\bsorry\b", body))
        after = body[body.index(d["name"]) + len(d["name"]):] if d["name"] in body else body
        b, c = split_statement(after)
        d["needs"] = explicit_binders(b)
        d["proves"] = " ".join(c.split())
    return {"tree": tree, "path": str(path.relative_to(ROOT)), "module": module,
            "stem": path.stem, "header": file_header(text), "imports": imports,
            "opens": sorted(opens), "namespaces": sorted({d["ns"] for d in decls if d["ns"]}),
            "lines": len(lines), "decls": decls,
            "copy_of": ("lean/" + path.name) if "/TablePort/" in str(path) else None}


def collect():
    mods = []
    for tree, _ in TREES:
        tr = ROOT / tree
        if not tr.exists():
            continue
        for p in sorted(tr.rglob("*.lean")):
            if "/.lake/" in str(p) or p.name == "lakefile.lean" or p.name == "Scratch.lean":
                continue
            mods.append(parse(tree, p))
    real = [m for m in mods if not m["copy_of"]]
    by_full, by_bare = {}, defaultdict(list)
    for m in real:
        for d in m["decls"]:
            d["file"] = m["path"]
            d["id"] = m["path"] + "::" + d["full"]
            by_full.setdefault((m["tree"], d["full"]), d)
            by_full.setdefault(("*", d["full"]), d)
            by_bare[d["name"]].append((m, d))
    for m in real:
        scope = set(m["namespaces"]) | set(m["opens"])
        for d in m["decls"]:
            uses = {}
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
                    uses[hit["id"]] = hit
            d["uses"] = sorted(uses)
    D = {d["id"]: d for m in real for d in m["decls"]}
    for d in D.values():
        d["used_by"] = []
    for d in D.values():
        for u in d["uses"]:
            D[u]["used_by"].append(d["id"])
    for d in D.values():
        d["used_by"].sort()
    pm = {(m["tree"], m["module"]): m["path"] for m in mods}
    for m in mods:
        m["imports_files"] = sorted({pm[(m["tree"], i)] for i in m["imports"] if (m["tree"], i) in pm})
    return mods, real, D


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


def page_of(path):
    p = pathlib.Path(path)
    return f"{p.parts[0]}/{p.stem}.md" if "TablePort" not in path else f"{p.parts[0]}/TablePort_{p.stem}.md"


CLASSDEFS = """  classDef thm fill:#eef4ff,stroke:#335,color:#111
  classDef dfn fill:#f2f2f2,stroke:#777,color:#111
  classDef end_ fill:#e7f7e7,stroke:#2a7,color:#111,stroke-width:2px
  classDef lone fill:#fff,stroke:#999,color:#111,stroke-dasharray:4 3
  classDef bad fill:#ffe5e5,stroke:#c22,color:#111,stroke-width:2px
  classDef ext fill:#fff8e1,stroke:#b80,color:#111,stroke-dasharray:2 2"""


def klass(d):
    if d["sorry"]:
        return "bad"
    if d["kind"] != "theorem":
        return "dfn"
    if not d["used_by"] and not d["uses"]:
        return "lone"
    if not d["used_by"]:
        return "end_"
    return "thm"


def file_diagrams(m, D):
    decls = m["decls"]
    chunks = [decls[i:i + MAXN] for i in range(0, len(decls), MAXN)] or [[]]
    out = []
    for ci, chunk in enumerate(chunks):
        ids = {d["id"]: f"n{k}" for k, d in enumerate(chunk)}
        L = ["flowchart LR"]
        for d in chunk:
            lab = f"{esc(d['name'])}<br/>⊢ {esc(d['proves'], 70)}" if d["kind"] == "theorem" \
                else f"{esc(d['name'])}<br/>({d['kind']})"
            L.append(f'  {ids[d["id"]]}["{lab}"]:::{klass(d)}')
        ext_in, ext_out = defaultdict(set), defaultdict(set)
        edges = []
        for d in chunk:
            for u in d["uses"]:
                if u in ids:
                    edges.append((ids[u], ids[d["id"]]))
                else:
                    ext_in[u].add(ids[d["id"]])
            for u in d["used_by"]:
                if u not in ids:
                    ext_out[u].add(ids[d["id"]])
        stubs = set(ext_in) | set(ext_out)
        if len(stubs) <= MAXSTUB:
            sid = {u: f"x{k}" for k, u in enumerate(sorted(stubs))}
            for u, s in sid.items():
                e = D[u]
                L.append(f'  {s}(["{esc(pathlib.Path(e["file"]).stem)} · {esc(e["name"])}"]):::ext')
            for u, tg in ext_in.items():
                edges += [(sid[u], t) for t in sorted(tg)]
            for u, sr in ext_out.items():
                edges += [(s, sid[u]) for s in sorted(sr)]
        else:
            fin, fout = defaultdict(set), defaultdict(set)
            cnt = defaultdict(set)
            for u, tg in ext_in.items():
                f = D[u]["file"]; fin[f] |= tg; cnt[f].add(u)
            for u, sr in ext_out.items():
                f = D[u]["file"]; fout[f] |= sr; cnt[f].add(u)
            sid = {f: f"x{k}" for k, f in enumerate(sorted(set(fin) | set(fout)))}
            for f, s in sid.items():
                L.append(f'  {s}(["{esc(pathlib.Path(f).stem)} · {len(cnt[f])} declarations"]):::ext')
            for f, tg in fin.items():
                edges += [(sid[f], t) for t in sorted(tg)]
            for f, sr in fout.items():
                edges += [(s, sid[f]) for s in sorted(sr)]
        for a, b in sorted(set(edges)):
            L.append(f"  {a} --> {b}")
        L.append(CLASSDEFS)
        out.append("\n".join(L))
    return out


def reduce_edges(nodes, edges):
    """transitive reduction of a DAG given as {node: set(preds)}."""
    preds = {n: set(edges.get(n, ())) & set(nodes) for n in nodes}
    memo = {}

    def anc(n):
        if n not in memo:
            a = set()
            for p in preds[n]:
                a |= {p} | anc(p)
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
        nt = sum(1 for d in m["decls"] if d["kind"] == "theorem")
        cls = "ext" if m["copy_of"] else ("bad" if any(d["sorry"] for d in m["decls"]) else "thm")
        tag = "copy" if m["copy_of"] else f"{nt} theorems"
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
    mods, real, D = collect()
    files = {}
    by_path = {m["path"]: m for m in mods}
    imported_by = defaultdict(set)
    for m in mods:
        for f in m["imports_files"]:
            imported_by[f].add(m["path"])

    def link(path, frm):
        up = "../" * (len(pathlib.Path(frm).parts) - 1)
        return f"[`{pathlib.Path(path).stem}`]({up}{page_of(path)})"

    # per-file pages
    for m in mods:
        pg = page_of(m["path"])
        L = [f"# `{m['path']}`", ""]
        if m["copy_of"]:
            L += [f"A copy of `{m['copy_of']}` on Stage 3's toolchain, held to it by "
                  f"`utilities/check_port.py`. Its declarations are on the original's page: "
                  f"{link(m['copy_of'], pg)}.", ""]
            files[pg] = "\n".join(L) + "\n"
            continue
        L += ["**What it does** (its own header): " + (m["header"] or "no header."), ""]
        L += ["**Imports:** " + (", ".join(link(f, pg) for f in m["imports_files"]) or "nothing in this tree") + ".",
              "**Imported by:** " + (", ".join(link(f, pg) for f in sorted(imported_by[m["path"]])) or "nothing") + ".", ""]
        dg = file_diagrams(m, D)
        for k, g in enumerate(dg):
            if len(dg) > 1:
                L += [f"### Diagram {k + 1} of {len(dg)}", ""]
            L += ["```mermaid", g, "```", ""]
            files[pg[:-3] + (f".{k + 1}" if len(dg) > 1 else "") + ".mmd"] = g + "\n"
        L += ["Blue: theorem. Green: a theorem nothing else uses (an end). Dashed white: connects to "
              "nothing. Grey: definition. Red: contains `sorry`. Yellow: in another file. "
              "An arrow A → B reads \"A is used by B\".", ""]
        L += ["## Every declaration", "",
              "| declaration | proves (output) | needs (input) | why (its own docstring) | uses | used by |",
              "|---|---|---|---|---|---|"]
        for d in m["decls"]:
            def names(ids):
                return ", ".join(f"`{D[u]['full']}`" for u in ids[:30]) + (" …" if len(ids) > 30 else "") or "—"
            tag = " **sorry**" if d["sorry"] else ""
            L.append(f"| `{d['full']}`{tag}<br/>{d['kind']}, line {d['line']} | {cell(d['proves'])} | "
                     f"{cell('; '.join(d['needs']))} | {cell(d['why'])} | {names(d['uses'])} | {names(d['used_by'])} |")
        files[pg] = "\n".join(L) + "\n"

    # index
    thms = [d for d in D.values() if d["kind"] == "theorem"]
    lone = sorted((d for d in thms if not d["uses"] and not d["used_by"]), key=lambda d: d["id"])
    ends = sorted((d for d in thms if d["uses"] and not d["used_by"]), key=lambda d: d["id"])
    sorries = sorted((d for d in D.values() if d["sorry"]), key=lambda d: d["id"])
    I = ["# The Lean map", "",
         "Every declaration in every Lean file of this repo: what it proves, what it needs, why, "
         "and what it connects to. Generated by `python3 utilities/lean_map.py` from the `.lean` "
         "files; the workflow `.github/workflows/lean_map.yml` regenerates it on every push that "
         "touches one. Do not edit by hand.", "",
         f"**{len(real)} files, {len(D)} declarations, {len(thms)} theorems.** "
         f"{len(ends)} theorems are ends (nothing in the repo uses them). "
         f"{len(lone)} theorems connect to nothing. {len(sorries)} declarations contain `sorry`. "
         f"{len(mods) - len(real)} files are copies under `TablePort/`.", "",
         "How to read a diagram: an arrow A → B means A is used by B. Blue: theorem. Green: an "
         "end. Dashed white: connects to nothing. Grey: definition. Red: contains `sorry`. "
         "Yellow: a copy, or a declaration in another file.", "",
         "How each field is made, and what the reading of the code cannot see, is in the "
         "docstring of `utilities/lean_map.py`.", ""]
    for tree, label in TREES:
        ms = [m for m in mods if m["tree"] == tree]
        if not ms:
            continue
        I += [f"## `{tree}/` — {label}", "", "Files, arrows by import (indirect imports left out):", "",
              "```mermaid", files_diagram(ms), "```", ""]
        files[f"{tree}/FILES.mmd"] = files_diagram(ms) + "\n"
        I += ["| file | theorems | what it does (its own header) |", "|---|---|---|"]
        for m in sorted(ms, key=lambda m: m["path"]):
            nt = sum(1 for d in m["decls"] if d["kind"] == "theorem")
            what = f"copy of `{m['copy_of']}`" if m["copy_of"] else (m["header"] or "no header")
            I.append(f"| [`{m['path']}`](./{page_of(m['path'])}) | {nt} | {cell(what, 300)} |")
        I.append("")
    I += ["## Ends: theorems nothing else uses", "",
          "Each is where a line of the repo arrives. \"Behind it\" counts the declarations it "
          "rests on, through every file.", "",
          "| theorem | file | behind it | files behind it |", "|---|---|---|---|"]
    for d in sorted(ends, key=lambda d: -len(closure(d, D))):
        cl = closure(d, D)
        I.append(f"| `{d['full']}` | [`{pathlib.Path(d['file']).stem}`](./{page_of(d['file'])}) | "
                 f"{len(cl)} | {len({D[u]['file'] for u in cl})} |")
    I += ["", "## Theorems that connect to nothing", "",
          "No repo declaration in their statement or proof, and nothing uses them.", "",
          "| theorem | file |", "|---|---|"]
    for d in lone:
        I.append(f"| `{d['full']}` | [`{pathlib.Path(d['file']).stem}`](./{page_of(d['file'])}) |")
    I += ["", "## Declarations containing `sorry`", "", "| declaration | file |", "|---|---|"]
    for d in sorries:
        I.append(f"| `{d['full']}` | [`{pathlib.Path(d['file']).stem}`](./{page_of(d['file'])}) |")
    I.append("")
    slim = [{k: v for k, v in m.items() if k != "decls"} |
            {"decls": [{k: v for k, v in d.items() if k not in ("tokens", "start")} for d in m["decls"]]}
            for m in mods]
    files["lean_map.json"] = json.dumps(slim, indent=1, ensure_ascii=False) + "\n"
    return "\n".join(I) + "\n", files, (len(real), len(D), len(thms), len(ends), len(lone), len(sorries))


def main():
    index, files, counts = build()
    want = {OUT / "README.md": index} | {OUT / k: v for k, v in files.items()}
    if "--check" in sys.argv:
        stale = [str(p.relative_to(ROOT)) for p, v in want.items()
                 if not p.exists() or p.read_text() != v]
        have = {p for p in OUT.rglob("*") if p.is_file()} if OUT.exists() else set()
        extra = [str(p.relative_to(ROOT)) for p in have - set(want)]
        if stale or extra:
            print("MAP STALE: run python3 utilities/lean_map.py")
            for s in (stale + extra)[:20]:
                print("  ", s)
            sys.exit(1)
        print("MAP OK")
        return
    if OUT.exists():
        for p in sorted(OUT.rglob("*"), reverse=True):
            if p.is_file() and p not in want:
                p.unlink()
    for p, v in want.items():
        p.parent.mkdir(parents=True, exist_ok=True)
        if not p.exists() or p.read_text() != v:
            p.write_text(v)
    print("files %d, declarations %d, theorems %d, ends %d, connect to nothing %d, sorry %d" % counts)
    print("wrote map/README.md and", len(files), "files under map/")


if __name__ == "__main__":
    main()
