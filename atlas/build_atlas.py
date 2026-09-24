#!/usr/bin/env python3
"""Primebeat's own atlas: `python3 atlas/build_atlas.py` writes
`atlas/build/atlas.html`, one self-contained page with no network.

TWO MAPS, OVERLAID. The TERRITORY is the mathematics and the units: every
declaration of every committed `.lean` file, read by Lean itself
(`atlas/Extract.lean`, run under each project's own toolchain with
`lake env lean --run`), placed on the critical strip by the literal bounds
its statement puts on Re s (`atlas/model.py` states the patterns), or in
the lane "no bound on Re s" by its depth from the roots; the uses between
declarations are its roads, upstream to downstream; its colour is its
closure from 0 to 1; the units pinned to it by their `refs:` are flags.
The COMMENTARY is every other committed text file, attached by the names
it mentions, with a margin lane for the texts that name nothing.

WHAT IS READ, all at HEAD through git, nothing written outside
`atlas/build/`:
    lean/ (its lakefile globs, its toolchain) and lean_stage3/ (Stage3 and
        Stage3/*), each from its own `.lake` build, which must exist;
    every other committed `.lean` file (results/scratch_lean/, the root,
        analysis/; the atlas's own Extract.lean excepted), compiled to a scratch `.olean` under `atlas/build/`
        with lean_stage3's toolchain, then lean's; a file that builds in
        neither is a GAP with the first error line from each;
    units/*/unit.md frontmatter: id, date, type, title, refs;
    every other committed text file (not units/, not `.lean`, not atlas/,
        not binary) as commentary;
    git history: the day a declaration's name first appears in its file
        (the oldest version of the file containing its last name part, the
        commit `git log -S` would list first), and the day each commentary
        file was added.

The extraction is cached in `atlas/build/extract/` under a key hashing the
extractor, the toolchain, the manifest and every `.lean` source it reads;
`--fresh` ignores the cache. Two runs write the same bytes.
"""

import argparse
import concurrent.futures
import hashlib
import json
import pathlib
import re
import subprocess
import sys

HERE = pathlib.Path(__file__).resolve().parent
ROOT = HERE.parent
sys.path.insert(0, str(HERE))
import model  # noqa: E402
import page  # noqa: E402

BUILD = HERE / "build"
EXTRACT = HERE / "Extract.lean"


def git(*args, input=None):
    return subprocess.run(["git", "-C", str(ROOT), *args], input=input,
                          capture_output=True, check=True).stdout


def head_tree():
    """{path: blob sha} of HEAD."""
    out = {}
    for line in git("ls-tree", "-r", "-z", "HEAD").split(b"\0"):
        if not line:
            continue
        meta, path = line.split(b"\t", 1)
        _mode, kind, sha = meta.split()
        if kind == b"blob":
            out[path.decode()] = sha.decode()
    return out


def cat_blobs(shas):
    """{sha: bytes} through one `git cat-file --batch`."""
    shas = sorted(set(shas))
    if not shas:
        return {}
    raw = git("cat-file", "--batch", input=("\n".join(shas) + "\n").encode())
    out, i = {}, 0
    for sha in shas:
        nl = raw.index(b"\n", i)
        header = raw[i:nl].split()
        size = int(header[2])
        out[sha] = raw[nl + 1:nl + 1 + size]
        i = nl + 1 + size + 1
    return out


# ── extraction ───────────────────────────────────────────────────────────

def project_modules(tree):
    lean = sorted(p[len("lean/"):-5] for p in tree
                  if p.startswith("lean/") and p.endswith(".lean") and p.count("/") == 1)
    s3 = ["Stage3"] + sorted("Stage3." + p[len("lean_stage3/Stage3/"):-5] for p in tree
                             if p.startswith("lean_stage3/Stage3/") and p.endswith(".lean")
                             and p.count("/") == 2)
    return {"lean": lean, "lean_stage3": s3}


def mod_file(scope, mod):
    if scope == "lean":
        return f"lean/{mod}.lean"
    return "lean_stage3/" + mod.replace(".", "/") + ".lean"


def key_of(parts):
    h = hashlib.sha256()
    for p in parts:
        h.update(p if isinstance(p, bytes) else str(p).encode())
        h.update(b"\0")
    return h.hexdigest()


def project_key(proj, tree, blobs_of):
    files = sorted(p for p in tree if p.startswith(proj + "/") and
                   (p.endswith(".lean") or p.endswith("lean-toolchain")
                    or p.endswith("lake-manifest.json") or p.endswith("lakefile.toml")))
    return key_of([EXTRACT.read_bytes()] + [f.encode() + b"=" + tree[f].encode() for f in files])


def run(cmd, cwd):
    return subprocess.run(cmd, cwd=str(cwd), capture_output=True, text=True)


def extract_project(proj, mods, key, fresh):
    out = BUILD / "extract" / f"{proj}.json"
    kfile = out.with_suffix(".key")
    if not fresh and out.is_file() and kfile.is_file() and kfile.read_text() == key:
        return json.loads(out.read_text())
    if not (ROOT / proj / ".lake" / "build").is_dir():
        sys.exit(f"{proj}/.lake/build is missing: build the project first (lake build)")
    out.parent.mkdir(parents=True, exist_ok=True)
    fresh_build = run(["lake", "build", "--no-build"], ROOT / proj)
    if fresh_build.returncode:
        sys.exit(f"{proj}: the .lake build is not current with the sources (lake build "
                 f"--no-build refused); run lake build first\n{fresh_build.stdout[-2000:]}")
    r = run(["lake", "env", "lean", "--run", str(EXTRACT), str(out), *mods, "--", *mods],
            ROOT / proj)
    if r.returncode:
        sys.exit(f"extraction failed in {proj}:\n{r.stdout}\n{r.stderr}")
    kfile.write_text(key)
    return json.loads(out.read_text())


def first_error(text):
    text = text.replace(str(ROOT) + "/", "")
    for line in text.splitlines():
        if "error" in line:
            return line.strip()
    lines = [l for l in text.splitlines() if l.strip()]
    return lines[0].strip() if lines else "no output"


def extract_standalone(path, tree, pkeys, mods, fresh):
    """(scope result dict) for one committed .lean outside the projects."""
    slug = re.sub(r"[^\w]+", "_", path)
    stem = pathlib.PurePosixPath(path).stem
    out = BUILD / "extract" / f"sa_{slug}.json"
    kfile = out.with_suffix(".key")
    key = key_of([EXTRACT.read_bytes(), path, tree[path], pkeys["lean_stage3"], pkeys["lean"]])
    if not fresh and out.is_file() and kfile.is_file() and kfile.read_text() == key:
        return json.loads(out.read_text())
    out.parent.mkdir(parents=True, exist_ok=True)
    src = ROOT / path
    errors = []
    result = None
    for proj in ("lean_stage3", "lean"):
        odir = BUILD / "sa" / proj / slug
        odir.mkdir(parents=True, exist_ok=True)
        r = run(["lake", "env", "lean", "-R", str(src.parent), "-o",
                 str(odir / f"{stem}.olean"), str(src)], ROOT / proj)
        if r.returncode:
            errors.append({"project": proj, "error": first_error(r.stdout + "\n" + r.stderr)})
            continue
        jout = odir / "extract.json"
        r2 = run(["lake", "env", "lean", "--run", str(EXTRACT), str(jout), "--path", str(odir),
                  stem, "--", stem, *mods[proj]], ROOT / proj)
        if r2.returncode:
            errors.append({"project": proj, "error": "extract: " + first_error(r2.stdout + r2.stderr)})
            continue
        result = {"file": path, "project": proj, "module": stem,
                  "extract": json.loads(jout.read_text()), "errors": errors}
        break
    if result is None:
        result = {"file": path, "project": None, "module": stem, "extract": None,
                  "errors": errors}
    out.write_text(json.dumps(result, sort_keys=True, ensure_ascii=False))
    kfile.write_text(key)
    return result


# ── history ──────────────────────────────────────────────────────────────

def versions_of(path):
    """[(day, text)] oldest first, for one path's history."""
    rows = git("log", "--reverse", "--format=%H %cs", "--", path).decode().split("\n")
    rows = [r.split() for r in rows if r.strip()]
    if not rows:
        return []
    raw = git("cat-file", "--batch", input=("\n".join(f"{h}:{path}" for h, _ in rows) + "\n").encode())
    out, i = [], 0
    for _h, day in rows:
        nl = raw.index(b"\n", i)
        header = raw[i:nl].split()
        if header[-1] == b"missing":
            i = nl + 1
            out.append((day, ""))
            continue
        size = int(header[2])
        out.append((day, raw[nl + 1:nl + 1 + size].decode("utf-8", "replace")))
        i = nl + 1 + size + 1
    return out


def added_days():
    """{path: day it first appears in history}."""
    out = {}
    day = None
    for line in git("log", "--reverse", "--format=>%cs", "--name-only",
                    "--no-renames", "--diff-filter=A").decode().splitlines():
        if line.startswith(">"):
            day = line[1:]
        elif line.strip() and line not in out:
            out[line] = day
    return out


# ── units and commentary ─────────────────────────────────────────────────

def read_units(tree, blobs):
    units = []
    for p in sorted(tree):
        m = re.fullmatch(r"units/([^/]+)/unit\.md", p)
        if not m:
            continue
        text = blobs[tree[p]].decode("utf-8", "replace")
        fm = text.split("---")[1] if text.startswith("---") else ""
        f = {}
        for line in fm.splitlines():
            k, _, v = line.partition(":")
            f[k.strip()] = v.strip()
        refs = [r.strip() for r in f.get("refs", "").strip("[]").split(",") if r.strip()]
        units.append({"id": f.get("id", m.group(1)[:4]).strip("'\""), "dir": m.group(1),
                      "date": f.get("date", ""), "type": f.get("type", ""),
                      "title": f.get("title", "").strip("'\""), "refs": refs})
    return units


def comm_kind(p):
    ext = p.rsplit(".", 1)[-1].lower() if "." in p.rsplit("/", 1)[-1] else ""
    if p.startswith("preregs/"):
        return "prereg"
    if p.startswith("notes/"):
        return "note"
    if ext in ("py", "c", "sh") or p.endswith("pre-commit"):
        return "script"
    if ext in ("md", "txt", "tex"):
        return "doc"
    if ext == "log":
        return "log"
    if ext in ("json", "csv", "tsv", "numbers", "sha256"):
        return "data"
    return "other"


def is_commentary(p):
    return not (p.startswith("units/") or p.endswith(".lean") or p.startswith("atlas/"))


# ── the model ────────────────────────────────────────────────────────────

def assemble(scopes, units, comm, days_of, added):
    """Pure: scopes -> the page data.

    scopes: [{"key", "label", "toolchain", "decls": [extracted rows with
    "file" and "uses" as [file, name]]}]; units: read_units rows; comm:
    [(path, text)]; days_of(file, name) -> day or None; added: {path: day}.
    """
    decls = []
    idx = {}
    for si, sc in enumerate(scopes):
        for d in sc["decls"]:
            did = f"{d['file']}::{d['name']}"
            if did in idx:
                continue
            idx[did] = len(decls)
            decls.append(dict(d, id=did, scope=si))
    uses = {}
    for d in decls:
        uses[d["id"]] = sorted({f"{f}::{n}" for f, n in d["uses"]
                                if f"{f}::{n}" in idx and f"{f}::{n}" != d["id"]})
    sorry = {d["id"]: bool(d["sorry"]) for d in decls}
    clo = model.closure(uses, sorry)
    dep = model.depths(uses)
    rootset = set(model.roots(uses))
    used_by = {k: [] for k in uses}
    for k, v in uses.items():
        for u in v:
            used_by[u].append(k)
    for d in decls:
        rb, ib = model.bounds(d["type"])
        d["re"] = rb
        d["im"] = ib
        d["place"] = model.place(rb)
        d["tplace"] = model.place_t(ib)
        d["closure"] = clo[d["id"]]
        d["depth"] = dep[d["id"]]
        d["root"] = d["id"] in rootset
        d["day"] = days_of(d["file"], d["name"])

    # units pinned by refs
    upins = []
    for u in units:
        pins, unresolved = [], []
        for r in u["refs"]:
            if "::" not in r:
                continue
            f, n = r.split("::", 1)
            hits = [i for i, d in enumerate(decls) if d["file"] == f and model.same_name(n, d["name"])]
            if not hits:
                hits = [i for i, d in enumerate(decls) if model.same_name(n, d["name"])
                        and d["file"].rsplit("/", 1)[-1] == f.rsplit("/", 1)[-1]]
            if hits:
                pins.extend(hits)
            else:
                unresolved.append(r)
        upins.append((sorted(set(pins)), unresolved))

    # commentary
    index = model.NameIndex({d["id"]: d["name"] for d in decls})
    lean_files = sorted({d["file"] for d in decls})
    unit_ids = {u["id"] for u in units}
    ctargets = []
    for path, text in comm:
        ds, fs, us = model.mentions(text, index, lean_files, unit_ids)
        ctargets.append((path, [idx[x] for x in ds], fs, us))
    return decls, uses, used_by, upins, ctargets


def layout(scopes, decls, uses, used_by, units, upins, comm_rows, added, gaps):
    """World coordinates and the JSON the page reads."""
    CELL = 13.0
    LCOLS = 10
    xs = [d["place"][0] for d in decls if d["place"]]
    rmin = min([-0.5] + xs)
    rmax = max([1.5] + [x + 0.25 for x in xs])
    lane_items = [i for i, d in enumerate(decls) if not d["place"]]
    maxdep = max([decls[i]["depth"] for i in lane_items] + [1])
    dx = LCOLS * CELL + 16
    # the lane runs from Re s = 0 (the origin) to the right edge of the strip
    K = ((maxdep + 1) * dx + 20) / rmax
    X = lambda re_: (re_ - rmin) * K  # noqa: E731
    xl, xr = X(rmin), X(rmax)

    all_days = sorted({d["day"] for d in decls if d["day"]}
                      | {u["date"] for u in units if u["date"]}
                      | {added.get(p) for p, *_ in comm_rows if added.get(p)})
    dayi = {d: i for i, d in enumerate(all_days)}
    files = sorted({d["file"] for d in decls})
    fidx = {f: i for i, f in enumerate(files)}

    def order(i):
        d = decls[i]
        return (d["day"] or "9999", d["file"], d["line"], d["name"])

    panels = []
    # ── strip: height area for statements bounding Im s literally
    t_items = [i for i, d in enumerate(decls) if d["place"] and d["tplace"]]
    tvals = [v for i in t_items for v in (decls[i]["tplace"][1], decls[i]["tplace"][2]) if v is not None]
    tmax = max([abs(v) for v in tvals] + [1.0])
    t_h = 220.0
    t_top = 60.0
    t_zero = t_top + t_h / 2
    tscale = (t_h / 2 - 16) / tmax
    pos = {}
    seen = {}
    for i in sorted(t_items, key=order):
        d = decls[i]
        x, yy = X(d["place"][0]), t_zero - d["tplace"][0] * tscale
        k = (round(x), round(yy))
        n = seen.get(k, 0)
        seen[k] = n + 1
        pos[i] = (x + CELL * ((n + 1) // 2) * (1 if n % 2 else -1), yy)
    band_top = t_top + t_h + 30
    stacks = {}
    for i, d in enumerate(decls):
        if d["place"] and not d["tplace"]:
            kind = 0 if d["place"][3] in ("on", "several equalities; the first") else 1
            stacks.setdefault((kind, round(d["place"][0], 6)), []).append(i)
    band_h = 0.0
    sub_tops = []
    for kind in (0, 1):
        top = band_top + band_h + (0 if kind == 0 else 24)
        sub_tops.append(top)
        h = 0.0
        for key in sorted(k for k in stacks if k[0] == kind):
            for j, i in enumerate(sorted(stacks[key], key=order)):
                r, c = divmod(j, LCOLS)
                pos[i] = (X(key[1]) + (c - (LCOLS - 1) / 2) * CELL, top + 24 + r * CELL)
                h = max(h, 24 + (r + 1) * CELL)
        band_h = top - band_top + h
    strip_bottom = band_top + max(band_h, 40) + 20
    panels.append({"key": "strip", "label": "the critical strip: statements with a literal bound on Re s",
                   "y0": 0.0, "y1": strip_bottom, "t_top": t_top, "t_zero": t_zero, "t_h": t_h,
                   "tscale": tscale, "tmax": tmax, "band_top": band_top, "sub_tops": sub_tops,
                   "t_label": ("height t: statements bounding Im s literally"
                               if t_items else "no statement here bounds Im s literally")})
    # ── lane: no bound on Re s, x by depth from the roots (origin at Re s = 0)
    x0 = X(0.0)
    y = strip_bottom + 90
    lane_top = y
    lane_bands = []
    for si, sc in enumerate(scopes):
        mine = [i for i in lane_items if decls[i]["scope"] == si]
        if not mine:
            continue
        by = {}
        for i in mine:
            by.setdefault(decls[i]["depth"], []).append(i)
        h = 0.0
        for dp in sorted(by):
            for k, i in enumerate(sorted(by[dp], key=order)):
                r, c = divmod(k, LCOLS)
                pos[i] = (x0 + dp * dx + 10 + c * CELL, y + 30 + r * CELL)
                h = max(h, 30 + (r + 1) * CELL)
        lane_bands.append({"label": sc["label"], "y0": y, "y1": y + h + 10})
        y += h + 24
    lane_bottom = y
    panels.append({"key": "lane", "label": "no bound on Re s: x is depth from the roots, "
                   "the roots at the origin", "y0": lane_top - 70, "y1": lane_bottom,
                   "bands": lane_bands, "dx": dx, "x0": x0, "maxdep": maxdep})

    def by_day_grid(items, day_of, y_top, cell):
        """Items grouped by day, each day a grid at its date's x."""
        groups = {}
        for it in items:
            groups.setdefault(day_of(it) or "", []).append(it)
        keys = sorted(groups)
        xs_ = {k: (model.date_x(k, all_days, xl + 60, xr - 60) if k else xl + 30) for k in keys}
        out, h = {}, 0.0
        for n, k in enumerate(keys):
            nxt = xs_[keys[n + 1]] if n + 1 < len(keys) else xr - 20
            cols_ = max(1, min(12, int((nxt - xs_[k] - 4) // cell)))
            for j, it in enumerate(groups[k]):
                r, c = divmod(j, cols_)
                out[it] = (xs_[k] + c * cell, y_top + 48 + r * cell)
                h = max(h, 48 + (r + 1) * cell)
        return out, h

    # ── units lane: units with no Lean ref, by date
    y = lane_bottom + 50
    ulane = sorted((ui for ui in range(len(units)) if not upins[ui][0]),
                   key=lambda k: (units[k]["date"], units[k]["id"]))
    upos, uh = by_day_grid(ulane, lambda ui: units[ui]["date"], y, 16.0)
    uh = max(uh, 40) + 10
    panels.append({"key": "units", "label": "units with no Lean ref, by date", "y0": y, "y1": y + uh})
    y += uh + 50
    # ── margin lane: commentary naming nothing
    mlane = sorted((ci for ci, (path, ds, fs, us) in enumerate(comm_rows) if not (ds or fs or us)),
                   key=lambda ci: (added.get(comm_rows[ci][0]) or "9999", comm_rows[ci][0]))
    cpos, mh = by_day_grid(mlane, lambda ci: added.get(comm_rows[ci][0]), y, 12.0)
    mh = max(mh, 40) + 10
    panels.append({"key": "margin", "label": "margin: commentary naming no declaration, "
                   "no .lean file and no unit, by the day it was added", "y0": y, "y1": y + mh})
    y += mh
    extent = [xl - 20, -10, xr + 20, y + 20]

    # roads
    didx = {d["id"]: i for i, d in enumerate(decls)}
    roads = []
    for d in decls:
        for u in uses[d["id"]]:
            roads.append([didx[u], didx[d["id"]]])
    roads.sort()

    # commentary per target
    d_cm = {i: [] for i in range(len(decls))}
    f_cm = {f: [] for f in files}
    u_cm = {u["id"]: [] for u in units}
    for ci, (path, ds, fs, us) in enumerate(comm_rows):
        for i in ds:
            d_cm[i].append(ci)
        for f in fs:
            f_cm.setdefault(f, []).append(ci)
        for u in us:
            u_cm.setdefault(u, []).append(ci)
    file_anchor = {}
    for i in sorted(range(len(decls)), key=lambda i: (decls[i]["file"], decls[i]["line"], decls[i]["name"])):
        file_anchor.setdefault(decls[i]["file"], i)
    d_units = {i: [] for i in range(len(decls))}
    for ui, (pins, _unres) in enumerate(upins):
        for i in pins:
            d_units[i].append(ui)

    def rnd(v):
        return round(v, 2)

    D = {
        "extent": [rnd(v) for v in extent],
        "strip": {"xl": rnd(xl), "xr": rnd(xr), "x0": rnd(X(0.0)), "x1": rnd(X(1.0)),
                  "xh": rnd(X(0.5)), "K": K, "rmin": rmin, "rmax": rmax},
        "panels": [{k: (rnd(v) if isinstance(v, float) else v) for k, v in p.items()} for p in panels],
        "days": all_days,
        "scopes": [{"key": s["key"], "label": s["label"], "toolchain": s["toolchain"]} for s in scopes],
        "files": files,
        "decls": [],
        "roads": roads,
        "units": [],
        "comm": [],
        "gaps": gaps,
        "file_cm": {str(fidx[f]): v for f, v in sorted(f_cm.items()) if v and f in fidx},
        "file_anchor": {str(fidx[f]): i for f, i in sorted(file_anchor.items())},
    }
    for i, d in enumerate(decls):
        p = d["place"]
        tp = d["tplace"]
        D["decls"].append({
            "n": d["name"], "k": d["kind"], "f": fidx[d["file"]], "l": d["line"],
            "c": d["closure"], "s": 1 if d["sorry"] else 0, "r": 1 if d["root"] else 0,
            "dp": d["depth"], "d": dayi.get(d["day"], -1), "sc": d["scope"],
            "x": rnd(pos[i][0]), "y": rnd(pos[i][1]),
            "p": None if not p else [p[0], p[1], p[2], p[3]],
            "tp": None if not (p and tp) else [tp[0], tp[1], tp[2], tp[3]],
            "re": [e for _r, _v, e in d["re"]], "im": [e for _r, _v, e in d["im"]],
            "ty": d["type"], "u": [didx[u] for u in uses[d["id"]]],
            "ub": sorted(didx[u] for u in used_by[d["id"]]),
            "un": d_units[i], "cm": d_cm[i], "pv": 1 if d.get("private") else 0,
        })
    for ui, u in enumerate(units):
        pins, unres = upins[ui]
        xy = upos.get(ui)
        D["units"].append({"id": u["id"], "t": u["title"], "date": u["date"], "type": u["type"],
                           "d": dayi.get(u["date"], -1), "pins": pins, "unres": unres,
                           "refs": u["refs"], "dir": u["dir"],
                           "x": rnd(xy[0]) if xy else None, "y": rnd(xy[1]) if xy else None,
                           "cm": u_cm.get(u["id"], [])})
    for ci, (path, ds, fs, us) in enumerate(comm_rows):
        xy = cpos.get(ci)
        D["comm"].append({"p": path, "k": comm_kind(path), "d": dayi.get(added.get(path), -1),
                          "ds": ds, "fs": [fidx[f] for f in fs if f in fidx], "us": us,
                          "x": rnd(xy[0]) if xy else None, "y": rnd(xy[1]) if xy else None})
    return D


def ground(scopes, decls, uses, D, pins, host, top=15, partners=5):
    """Pure: the topography, `D["ground"]`, beside and apart from the maps.

    decls/uses as `assemble` returns them, D as `layout` returns it (the
    points' places), pins: {project: {library: rev}}, host: {scratch file:
    the project it was built in}. Islands are counted per scope (lean/,
    lean_stage3/, the scratch files); rarity per scope over its islands; a
    scratch island stands on its host project's pins."""
    L = model.LIBRARIES
    cone = model.cones(uses)
    didx = {d["id"]: i for i, d in enumerate(decls)}

    def pin_of(d):
        proj = scopes[d["scope"]]["key"]
        proj = host.get(d["file"], proj) if proj == "scratch" else proj
        return proj, pins.get(proj, {})

    # every library constant and area named anywhere, in a fixed order
    allc = sorted({(model.area(m), m, n) for d in decls for m, n in d["lib"]
                   if model.library(m) is not None},
                  key=lambda t: (model.library(t[1]), t[0], t[2], t[1]))
    area_names = sorted({a for a, _m, _n in allc}, key=lambda a: (model.library(a), a))
    aidx = {a: k for k, a in enumerate(area_names)}
    cidx = {}
    consts = []
    for a, m, n in allc:
        if (a, n) not in cidx:
            cidx[(a, n)] = len(consts)
            consts.append({"a": aidx[a], "n": n, "m": m})
    d_consts = [sorted({cidx[(model.area(m), n)] for m, n in d["lib"]
                        if model.library(m) is not None}) for d in decls]
    d_areas = [sorted({consts[c]["a"] for c in cs}) for cs in d_consts]

    # islands, per scope
    isl = []
    d_isl = [None] * len(decls)
    rar_a, rar_c, n_isl = {}, {}, {}
    for si, sc in enumerate(scopes):
        mem = [d["id"] for d in decls if d["scope"] == si]
        comps = model.islands(mem, uses)
        n_isl[si] = len(comps)
        start = len(isl)
        for comp in comps:
            ms = [didx[c] for c in comp]
            inside = set(comp)
            top_ = min(ms, key=lambda i: (-len(inside.intersection(cone[decls[i]["id"]])),
                                          decls[i]["file"], decls[i]["line"], decls[i]["name"]))
            proj, pn = pin_of(decls[ms[0]])
            k = len(isl)
            for i in ms:
                d_isl[i] = k
            isl.append({"sc": si, "m": sorted(ms), "top": top_, "host": proj,
                        "pin": pn.get("Mathlib", ""), "pnt": pn.get("PrimeNumberTheoremAnd", ""),
                        "areas": sorted({a for i in ms for a in d_areas[i]}),
                        "consts": sorted({c for i in ms for c in d_consts[i]})})
        mine = isl[start:]
        rar_a[si] = model.rarity([set(x["areas"]) for x in mine])
        rar_c[si] = model.rarity([set(x["consts"]) for x in mine])

    # areas: who stands on them, how high they rise
    A = []
    for k, a in enumerate(area_names):
        users = [i for i in range(len(decls)) if k in d_areas[i]]
        held = {si: rar_a[si][k][0] for si in sorted(rar_a) if k in rar_a[si]}
        bg = sorted(si for si in held if rar_a[si][k][1])
        stand = [i for i in users if decls[i]["scope"] not in bg]
        rises = sorted({d_isl[i] for i in stand})
        # the label sits at the densest 40-unit cell of the standing points
        cells = {}
        for i in stand:
            p = D["decls"][i]
            cells.setdefault((int(p["y"] // 40), int(p["x"] // 40)), []).append(i)
        anchor = None
        if cells:
            key = min(cells, key=lambda c: (-len(cells[c]), c))
            xs = [D["decls"][i]["x"] for i in cells[key]]
            ys = [D["decls"][i]["y"] for i in cells[key]]
            anchor = [round(sum(xs) / len(xs), 2), round(sum(ys) / len(ys), 2)]
        A.append({"n": a, "l": model.library(a), "d": users,
                  "k": [held.get(si, 0) for si in range(len(scopes))], "bg": bg,
                  "h": len(rises), "i": sorted({d_isl[i] for i in users}), "at": anchor,
                  "c": [c for c in range(len(consts)) if consts[c]["a"] == k]})
    C_out = []
    for c, x in enumerate(consts):
        held = [rar_c[si][c][0] if c in rar_c[si] else 0 for si in range(len(scopes))]
        bgm = sum(1 << si for si in range(len(scopes)) if c in rar_c[si] and rar_c[si][c][1])
        C_out.append([x["a"], x["n"], held, bgm])

    # shared ground between islands
    info = [{"project": x["sc"], "areas": [area_names[a] for a in x["areas"]], "pin": x["pin"]}
            for x in isl]
    rar_named = {si: {area_names[k]: v for k, v in r.items()} for si, r in rar_a.items()}
    ranked = model.pair_ranking(info, rar_named, n_isl, None)
    part = {k: [] for k in range(len(isl))}
    for pr in ranked:
        for me, other in ((pr["a"], pr["b"]), (pr["b"], pr["a"])):
            if len(part[me]) < partners:
                part[me].append([other, pr["w"], 1 if pr["cross"] else 0])

    def pair_out(pr):
        return {"a": pr["a"], "b": pr["b"], "w": pr["w"], "x": 1 if pr["cross"] else 0,
                "ar": [[aidx[a], w] for a, w in pr["areas"]]}

    # the terrain's scale: the median stacked height of a standing point, per library
    f0 = []
    for li in range(len(L)):
        gmax = max([x["h"] for x in A if x["l"] == li] + [0])
        stack = [0.0] * len(decls)
        for x in A:
            if x["l"] == li and x["h"]:
                for i in x["d"]:
                    if decls[i]["scope"] not in x["bg"]:
                        stack[i] += x["h"] / gmax
        nz = sorted(v for v in stack if v > 0)
        f0.append(round(nz[(len(nz) - 1) // 2], 4) if nz else 1.0)

    counts = {}
    for si, sc in enumerate(scopes):
        per = {}
        for li, lib in enumerate(L):
            cs = {c for x in isl if x["sc"] == si for c in x["consts"] if consts[c]["a"] in
                  {k for k in range(len(A)) if A[k]["l"] == li}}
            ar = {a for x in isl if x["sc"] == si for a in x["areas"] if A[a]["l"] == li}
            per[lib] = {"constants": len(cs), "areas": len(ar),
                        "background_areas": sum(1 for a in ar if si in A[a]["bg"])}
        counts[sc["key"]] = {"islands": n_isl[si], **per}
    return {
        "libs": list(L), "share": model.BACKGROUND_TEXT,
        "pins": {k: dict(sorted(v.items())) for k, v in sorted(pins.items())},
        "areas": A, "consts": C_out,
        "islands": [{"sc": x["sc"], "m": x["m"], "top": x["top"], "host": x["host"],
                     "pin": x["pin"], "pnt": x["pnt"], "a": x["areas"], "pp": part[k]}
                    for k, x in enumerate(isl)],
        "di": d_isl, "dc": d_consts,
        "pairs": [pair_out(p) for p in ranked[:top]],
        "counts": counts, "res": 3, "rad": 24, "f0": f0,
    }


def counts(D):
    decls = D["decls"]
    per = {}
    for d in decls:
        per[D["scopes"][d["sc"]]["key"]] = per.get(D["scopes"][d["sc"]]["key"], 0) + 1
    comm_att = sum(1 for c in D["comm"] if c["ds"] or c["fs"] or c["us"])
    return {
        "declarations": len(decls), "per_scope": per, "roads": len(D["roads"]),
        "roots": sum(d["r"] for d in decls), "sorry": sum(d["s"] for d in decls),
        "closure_below_1": sum(1 for d in decls if d["c"] < 1),
        "on_strip": sum(1 for d in decls if d["p"]), "in_lane": sum(1 for d in decls if not d["p"]),
        "with_height": sum(1 for d in decls if d["tp"]),
        "units": len(D["units"]), "units_pinned": sum(1 for u in D["units"] if u["pins"]),
        "units_in_lane": sum(1 for u in D["units"] if not u["pins"]),
        "unit_refs_unresolved": sum(len(u["unres"]) for u in D["units"]),
        "commentary": len(D["comm"]), "commentary_attached": comm_att,
        "commentary_margin": len(D["comm"]) - comm_att, "gaps": len(D["gaps"]),
    }


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    ap.add_argument("--fresh", action="store_true", help="ignore the extraction cache")
    ap.add_argument("--out", default=str(BUILD / "atlas.html"))
    a = ap.parse_args(argv)

    tree = head_tree()
    mods = project_modules(tree)
    pkeys = {p: project_key(p, tree, None) for p in ("lean", "lean_stage3")}
    ex = {p: extract_project(p, mods[p], pkeys[p], a.fresh) for p in ("lean", "lean_stage3")}
    tool = {p: (ROOT / p / "lean-toolchain").read_text().strip() for p in ("lean", "lean_stage3")}
    others = sorted(p for p in tree if p.endswith(".lean")
                    and not p.startswith(("lean/", "lean_stage3/", "atlas/")))
    with concurrent.futures.ThreadPoolExecutor(max_workers=3) as pool:
        sa = list(pool.map(lambda p: extract_standalone(p, tree, pkeys, mods, a.fresh), others))

    def rows(extract, scope_key, own_mod=None, own_file=None, host=None):
        out = []
        for r in extract["decls"]:
            m = r["module"]
            f = own_file if m == own_mod else mod_file(scope_key, m)
            u = []
            for um, un in r["uses"]:
                if um == own_mod:
                    u.append([own_file, un])
                else:
                    u.append([mod_file(host or scope_key, um), un])
            out.append({"name": r["name"], "kind": r["kind"], "file": f, "line": r["line"],
                        "end_line": r["end_line"], "sorry": r["sorry"], "uses": u,
                        "type": r["type"], "private": r["private"],
                        "lib": [list(x) for x in r.get("lib", [])]})
        return out

    scopes = [
        {"key": "lean", "label": f"lean/, the bench ({tool['lean']})", "toolchain": tool["lean"],
         "decls": rows(ex["lean"], "lean")},
        {"key": "lean_stage3", "label": f"lean_stage3/, Stage 3 ({tool['lean_stage3']})",
         "toolchain": tool["lean_stage3"], "decls": rows(ex["lean_stage3"], "lean_stage3")},
    ]
    sa_decls = []
    gaps = []
    for r in sa:
        if r["extract"] is None:
            gaps.append({"file": r["file"], "errors": [
                {"project": e["project"], "error": e["error"].replace(str(ROOT) + "/", "")}
                for e in r["errors"]]})
            continue
        sa_decls += rows(r["extract"], r["project"], own_mod=r["module"], own_file=r["file"],
                         host=r["project"])
    scopes.append({"key": "scratch", "label": "scratch files outside the projects "
                   "(results/scratch_lean/, analysis/, slice3.lean), each built on its own",
                   "toolchain": ", ".join(sorted({tool[r['project']] for r in sa if r['project']})),
                   "decls": sorted(sa_decls, key=lambda d: (d["file"], d["line"], d["name"]))})
    sa_proj = {r["file"]: r["project"] for r in sa}

    # history
    files = sorted({d["file"] for s in scopes for d in s["decls"]})
    vers = {f: versions_of(f) for f in files}

    def days_of(f, name):
        v = vers.get(f, [])
        day = model.first_day(v, name.split(".")[-1])
        return day or (v[0][0] if v else None)

    added = added_days()
    comm_paths = sorted(p for p in tree if is_commentary(p))
    blobs = cat_blobs([tree[p] for p in comm_paths] +
                      [tree[p] for p in tree if re.fullmatch(r"units/[^/]+/unit\.md", p)])
    comm = []
    for p in comm_paths:
        b = blobs[tree[p]]
        if b"\0" in b[:8192]:
            continue
        try:
            comm.append((p, b.decode("utf-8")))
        except UnicodeDecodeError:
            continue
    units = read_units(tree, blobs)

    decls, uses, used_by, upins, ctargets = assemble(scopes, units, comm, days_of, added)
    D = layout(scopes, decls, uses, used_by, units, upins, ctargets, added, gaps)
    D["sa_project"] = sa_proj
    C = counts(D)
    D["counts"] = C
    pins = {}
    for p in ("lean", "lean_stage3"):
        man = json.loads(cat_blobs([tree[f"{p}/lake-manifest.json"]])[tree[f"{p}/lake-manifest.json"]])
        pins[p] = {"Mathlib" if pk["name"] == "mathlib" else pk["name"]: pk["rev"][:10]
                   for pk in man["packages"] if pk["name"] in ("mathlib", "PrimeNumberTheoremAnd")}
    D["ground"] = ground(scopes, decls, uses, D, pins, {k: v for k, v in sa_proj.items() if v})
    html = page.render(D)
    out = pathlib.Path(a.out)
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_bytes(html.encode("utf-8"))
    print(json.dumps(C, sort_keys=True, indent=1))
    G = D["ground"]
    print("ground:", json.dumps(G["counts"], sort_keys=True))
    print("background: an area held by", G["share"], "of a project's islands;",
          {sc["key"]: [A["n"] for A in G["areas"] if si in A["bg"]]
           for si, sc in enumerate(D["scopes"])})
    for pr in G["pairs"]:
        ia, ib = G["islands"][pr["a"]], G["islands"][pr["b"]]
        print(f"pair {pr['w']:8.3f} {'NAME-MATCH ' if pr['x'] else ''}"
              f"{D['scopes'][ia['sc']]['key']}:{D['decls'][ia['top']]['n']}({len(ia['m'])}) ~ "
              f"{D['scopes'][ib['sc']]['key']}:{D['decls'][ib['top']]['n']}({len(ib['m'])}) | "
              + ", ".join(G["areas"][a]["n"] for a, _w in pr["ar"][:6]))
    for g in gaps:
        print("GAP", g["file"], "|", " || ".join(f"{e['project']}: {e['error']}" for e in g["errors"]))
    print("wrote", out.relative_to(ROOT) if out.is_relative_to(ROOT) else out, len(html.encode()), "bytes")


if __name__ == "__main__":
    main()
