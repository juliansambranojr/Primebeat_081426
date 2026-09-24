"""The atlas model: pure functions from extracted declarations to the map.

Nothing here reads a file, runs Lean or runs git; `build_atlas.py` does the
reading and hands this module plain data, and `test_atlas.py` hands it a
synthetic fixture. Every ordering is explicit, so the same input gives the
same model byte for byte.

PLACEMENT ON THE STRIP. `bounds(type_text)` reads the pretty-printed type,
whitespace collapsed to single spaces, with these patterns and no others:

    TARGET, real part   `x.re` or `(↑x).re` with `x` an identifier, or an
                        identifier starting with `σ` (`σ`, `σ₁`, `σ'`)
    TARGET, height      `x.im` or `(↑x).im`
    LITERAL             a decimal number, `a / b` of two, either with a
                        leading `-`, a trailing `⁻¹`, or wrapped in
                        parentheses with or without `: ℝ` / `: ℂ`
    1. LITERAL op TARGET          `1 / 2 < s.re`
    2. TARGET op LITERAL          `s.re ≤ 1`, `(↑ρ).re = 1 / 2`
       op one of < ≤ = ≥ >; the operand must stand alone: the character
       before it (spaces skipped) is the start, `(`, `[`, `,`, `:`, `∧`,
       `∨`, `→`, `↔` or `¬`, and after it the end or one of `)`, `]`, `,`,
       `∧`, `∨`, `→`, `↔`; so `x + 1 / 2 < s.re` and `2 * s.re ≤ 1` read
       nothing
    3. TARGET ∈ Set.Ioo a b (Icc, Ico, Ioc; Ioi a, Ici a, Iio b, Iic b)
    4. a point written as LITERAL + ↑y * Complex.I (or + Complex.I * ↑y,
       or - ...), after `(`, `,` or `=`: the real part equals LITERAL
    5. `|x.im| ≤ L` (or <): the height lies in [-L, L]

From the real-part bounds: an equality places the point at its value (the
first in reading order when several differ); otherwise the lower bounds
give lo = their max, the upper hi = their min, and the point sits at the
middle of [lo, hi] cut to the strip [0, 1] when that cut has positive
length, else at the middle of the cut to [1, 1.5] (right of the strip) or
[-0.5, 0] (left). lo > hi (bounds on different variables) places the point
at the first bound read and marks it `conflicting`. A statement with no
real-part bound goes to the lane "no bound on Re s". Height (`place_t`):
an equality gives its value, two finite ends their middle, one end that
end; a statement with no height bound sits in the default band.

CLOSURE. The cone of a declaration is itself with every project
declaration it reaches by `uses`. Its closure is the share of the cone
free of direct sorry; 1.0 when the cone has none.

ROOTS use no other project declaration. DEPTH is the longest `uses` chain
down to a root (a root is 0).

COMMENTARY. A text is split into tokens: Lean-style identifiers (letters,
digits, `_`, `'`, `!`, `?`, subscripts, dots between parts), file names
ending in `.lean`, and four-digit unit ids standing alone. A token names
    a declaration when it equals its full name, or one ends with `.` + the
        other (lab W.12, both directions); a token with no dot counts only
        when it is DISTINCTIVE: four characters or more and containing `_`,
        a digit, or an uppercase letter after the first character. So
        `lobe_bound` and `StmtA1` name, `phi`, `mode` and `Sym` alone do not,
        and `Chain.Sym` does;
    a `.lean` file when the token's last path part equals its file name;
    a unit when it equals the unit's id (`0331`, or `units/0331-...`).
A text naming none of these sits in the margin lane.

GROUND, the topography. A declaration's ground is the Mathlib and
PrimeNumberTheoremAnd constants its type and value name directly
(Extract.lean). Its AREAS are those constants' modules cut by `area`: three
components (`Mathlib.NumberTheory.LSeries`, `Mathlib.Analysis.Complex`), four
under `PrimeNumberTheoremAnd.Mathlib`. An ISLAND is a connected component of a
project's own uses graph (`islands`); its ground is the union of its
declarations'. RARITY is counted over one project's islands: a constant or
area held by more than one third of them is BACKGROUND; any other weighs
ln(islands / islands holding it). Two islands SHARE the non-background areas
both stand on, weighted by rarity (`shared_ground`). lean/ and lean_stage3/
pin different Mathlib versions, so ground shared across them is a match of
area names across two versions and is marked `cross`.
"""


import math
import re

# ── placement ────────────────────────────────────────────────────────────

_NUM = r"\d+(?:\.\d+)?"
_BARE = rf"-?\s*{_NUM}(?:\s*/\s*{_NUM})?(?:⁻¹)?"
LIT = rf"(?:{_BARE}|-?\(\s*{_BARE}\s*(?::\s*[ℝℂ]\s*)?\)(?:⁻¹)?)"
_ID = r"[^\W\d][\w'₀-₉]*"
RE_T = rf"(?:\(↑?{_ID}\)|(?<![\w'.]){_ID})\.re(?![\w'])|(?<![\w'.])σ[\w'₀-₉]*(?![\w'])"
IM_T = rf"(?:\(↑?{_ID}\)|(?<![\w'.]){_ID})\.im(?![\w'])"
OPS = {"<": "lt", "≤": "le", "=": "eq", "≥": "ge", ">": "gt"}
_OP = "(<|≤|=|≥|>)"
LEFT_OK = set("([,:∧∨→↔¬")
RIGHT_OK = set(")],∧∨→↔")
FLIP = {"lt": "gt", "le": "ge", "eq": "eq", "ge": "le", "gt": "lt"}


def lit_value(text):
    """The number a LITERAL denotes."""
    t = text.replace(" ", "")
    neg = False
    if t.startswith("-"):
        neg, t = True, t[1:]
    inv = t.endswith("⁻¹")
    if inv:
        t = t[:-2]
    if t.startswith("("):
        t = t[1:t.index(")")]
        t = t.split(":")[0]
        if t.startswith("-"):
            neg, t = not neg, t[1:]
    if t.endswith("⁻¹"):
        inv, t = not inv, t[:-2]
    if "/" in t:
        a, b = t.split("/")
        v = float(a) / float(b)
    else:
        v = float(t)
    if inv:
        v = 1.0 / v
    return -v if neg else v


def _before_ok(text, i):
    j = i - 1
    while j >= 0 and text[j] == " ":
        j -= 1
    return j < 0 or text[j] in LEFT_OK


def _after_ok(text, i):
    j = i
    while j < len(text) and text[j] == " ":
        j += 1
    return j >= len(text) or text[j] in RIGHT_OK


def _comparisons(text, target):
    """(position, relation of TARGET to the literal, value, excerpt)."""
    out = []
    for m in re.finditer(rf"({LIT})\s*{_OP}\s*({target})", text):
        if _before_ok(text, m.start(1)) and _after_ok(text, m.end(3)):
            # LIT op T  means  T (flipped op) LIT
            out.append((m.start(), FLIP[OPS[m.group(2)]], lit_value(m.group(1)),
                        m.group(0)))
    for m in re.finditer(rf"({target})\s*{_OP}\s*({LIT})", text):
        if _before_ok(text, m.start(1)) and _after_ok(text, m.end(3)):
            out.append((m.start(), OPS[m.group(2)], lit_value(m.group(3)),
                        m.group(0)))
    sets = {"Ioo": ("gt", "lt"), "Icc": ("ge", "le"), "Ico": ("ge", "lt"),
            "Ioc": ("gt", "le")}
    for m in re.finditer(rf"({target})\s*∈\s*Set\.(Ioo|Icc|Ico|Ioc)\s+({LIT})\s+({LIT})",
                         text):
        lo_rel, hi_rel = sets[m.group(2)]
        out.append((m.start(), lo_rel, lit_value(m.group(3)), m.group(0)))
        out.append((m.start() + 1, hi_rel, lit_value(m.group(4)), m.group(0)))
    half = {"Ioi": "gt", "Ici": "ge", "Iio": "lt", "Iic": "le"}
    for m in re.finditer(rf"({target})\s*∈\s*Set\.(Ioi|Ici|Iio|Iic)\s+({LIT})", text):
        out.append((m.start(), half[m.group(2)], lit_value(m.group(3)), m.group(0)))
    return out


def bounds(type_text):
    """The literal bounds a statement puts on Re s and on Im s."""
    text = " ".join(type_text.split())
    re_b = _comparisons(text, RE_T)
    for m in re.finditer(
            rf"({LIT})\s*[+-]\s*(?:↑?{_ID}\s*\*\s*Complex\.I|Complex\.I\s*\*\s*↑?{_ID})"
            rf"(?![\w'.])", text):
        j = m.start() - 1
        while j >= 0 and text[j] == " ":
            j -= 1
        if j < 0 or text[j] in "(,=":
            re_b.append((m.start(), "eq", lit_value(m.group(1)), m.group(0)))
    for m in re.finditer(r"re := (" + LIT + r")", text):
        re_b.append((m.start(), "eq", lit_value(m.group(1)), m.group(0)))
    im_b = _comparisons(text, IM_T)
    for m in re.finditer(rf"\|({IM_T})\|\s*(<|≤)\s*({LIT})", text):
        v = lit_value(m.group(3))
        im_b.append((m.start(), "ge", -v, m.group(0)))
        im_b.append((m.start() + 1, "le", v, m.group(0)))
    re_b.sort(key=lambda b: (b[0], b[1], b[2]))
    im_b.sort(key=lambda b: (b[0], b[1], b[2]))
    return ([(r, v, e) for _p, r, v, e in re_b],
            [(r, v, e) for _p, r, v, e in im_b])


def place(bnds, window=(0.0, 1.0), left=(-0.5, 0.0), right=(1.0, 1.5)):
    """Where a list of (relation, value, excerpt) puts the point.

    Returns (x, lo, hi, note) or None when the list is empty."""
    if not bnds:
        return None
    eqs = [v for r, v, _e in bnds if r == "eq"]
    if eqs:
        return (eqs[0], eqs[0], eqs[0],
                "on" if len(set(eqs)) == 1 else "several equalities; the first")
    los = [v for r, v, _e in bnds if r in ("gt", "ge")]
    his = [v for r, v, _e in bnds if r in ("lt", "le")]
    lo = max(los) if los else None
    hi = min(his) if his else None
    if lo is not None and hi is not None and lo > hi:
        return (bnds[0][1], lo, hi, "conflicting")
    a = float("-inf") if lo is None else lo
    b = float("inf") if hi is None else hi
    for w in (window, right, left):
        c0, c1 = max(a, w[0]), min(b, w[1])
        if c1 > c0:
            return ((c0 + c1) / 2, lo, hi, "between")
    # the interval misses every window: sit at its finite end
    return ((lo if lo is not None else hi), lo, hi, "outside")


def place_t(bnds):
    """Where a list of height bounds puts the point on the t axis.

    Returns (t, lo, hi, note) or None when the list is empty."""
    if not bnds:
        return None
    eqs = [v for r, v, _e in bnds if r == "eq"]
    if eqs:
        return (eqs[0], eqs[0], eqs[0], "on")
    los = [v for r, v, _e in bnds if r in ("gt", "ge")]
    his = [v for r, v, _e in bnds if r in ("lt", "le")]
    lo = max(los) if los else None
    hi = min(his) if his else None
    if lo is not None and hi is not None:
        if lo > hi:
            return (bnds[0][1], lo, hi, "conflicting")
        return ((lo + hi) / 2, lo, hi, "between")
    return ((lo if lo is not None else hi), lo, hi, "one end")


# ── graph ────────────────────────────────────────────────────────────────

def cones(uses):
    """{id: sorted list of ids in its cone, itself included}."""
    memo = {}
    for start in sorted(uses):
        if start in memo:
            continue
        # iterative post-order
        stack = [(start, iter(sorted(uses[start])))]
        onstack = {start}
        acc = {start: {start}}
        while stack:
            node, it = stack[-1]
            nxt = next(it, None)
            if nxt is None:
                stack.pop()
                onstack.discard(node)
                memo[node] = acc[node]
                if stack:
                    acc[stack[-1][0]] |= acc[node]
                continue
            if nxt in memo:
                acc[node] |= memo[nxt]
            elif nxt not in onstack and nxt in uses:
                acc[nxt] = {nxt}
                onstack.add(nxt)
                stack.append((nxt, iter(sorted(uses[nxt]))))
    return {k: sorted(v) for k, v in memo.items()}


def closure(uses, sorry):
    """{id: share of its cone free of direct sorry}."""
    out = {}
    for k, cone in cones(uses).items():
        bad = sum(1 for c in cone if sorry.get(c))
        out[k] = 1.0 if not bad else round((len(cone) - bad) / len(cone), 6)
    return out


def roots(uses):
    return sorted(k for k, v in uses.items() if not v)


def depths(uses):
    memo = {}
    for start in sorted(uses):
        stack = [start]
        while stack:
            n = stack[-1]
            if n in memo:
                stack.pop()
                continue
            pend = [u for u in sorted(uses[n]) if u not in memo and u in uses]
            if pend:
                stack.extend(pend)
                continue
            memo[n] = 1 + max((memo[u] for u in uses[n] if u in memo), default=-1)
            stack.pop()
    return memo


# ── names ────────────────────────────────────────────────────────────────

def same_name(declared, name):
    """lab W.12: equal, or one ends with `.` + the other."""
    return (declared == name or declared.endswith("." + name)
            or name.endswith("." + declared))


def distinctive(token):
    return (len(token) >= 4 and ("_" in token or any(c.isdigit() for c in token)
                                 or any(c.isupper() for c in token[1:])))


TOKEN = re.compile(r"[^\W\d][\w'!?₀-₉]*(?:\.[^\W\d][\w'!?₀-₉]*)*")
LEANFILE = re.compile(r"(?<![\w'-])([\w'-]+\.lean)(?![\w])")
UNITID = re.compile(r"(?<![\w.:/-])(\d{4})(?![\w:/]|\.\d|-\d)|units/(\d{4})-")


class NameIndex:
    """Token -> declaration ids, by the W.12 rule and the distinctive guard."""

    def __init__(self, decls):
        # decls: {id: user name}
        self.full = {}
        self.suffix = {}
        for i in sorted(decls):
            n = decls[i]
            self.full.setdefault(n, []).append(i)
            parts = n.split(".")
            for k in range(1, len(parts)):
                self.suffix.setdefault(".".join(parts[k:]), []).append(i)
        self.names = decls

    def lookup(self, token):
        hits = set()
        dotted = "." in token
        if dotted or distinctive(token):
            hits.update(self.full.get(token, ()))
            hits.update(self.suffix.get(token, ()))
        if dotted:
            # the token ends with `.` + a declaration's full name
            parts = token.split(".")
            for k in range(1, len(parts)):
                tail = ".".join(parts[k:])
                if "." in tail or distinctive(tail):
                    hits.update(self.full.get(tail, ()))
        return hits


def mentions(text, index, lean_files, unit_ids):
    """(declaration ids, .lean file paths, unit ids) a text names."""
    decls, files, units = set(), set(), set()
    for tok in sorted({m.group(0).rstrip(".") for m in TOKEN.finditer(text)}):
        if tok.endswith(".lean"):
            continue
        decls |= index.lookup(tok)
    by_base = {}
    for f in lean_files:
        by_base.setdefault(f.rsplit("/", 1)[-1], []).append(f)
    for m in LEANFILE.finditer(text):
        files.update(by_base.get(m.group(1), ()))
    for m in UNITID.finditer(text):
        u = m.group(1) or m.group(2)
        if u in unit_ids:
            units.add(u)
    return sorted(decls), sorted(files), sorted(units)


# ── first appearance ─────────────────────────────────────────────────────

def first_day(versions, needle):
    """The day of the oldest version whose text contains `needle`.

    `versions` is [(day, text)] oldest first."""
    for day, text in versions:
        if needle in text:
            return day
    return None


def date_x(day, days, x0, x1):
    """Linear place of a YYYY-MM-DD day among the sorted known days."""
    import datetime
    if not days:
        return (x0 + x1) / 2
    d0 = datetime.date.fromisoformat(days[0]).toordinal()
    d1 = datetime.date.fromisoformat(days[-1]).toordinal()
    d = datetime.date.fromisoformat(day).toordinal()
    if d1 == d0:
        return (x0 + x1) / 2
    return x0 + (x1 - x0) * (d - d0) / (d1 - d0)


# ── ground: the libraries under the islands ─────────────────────────────

LIBRARIES = ("Mathlib", "PrimeNumberTheoremAnd")
BACKGROUND_SHARE = 1 / 3
BACKGROUND_TEXT = "more than one third"


def library(module):
    """0 for a Mathlib module, 1 for a PrimeNumberTheoremAnd module, else None
    (the root of the module path decides)."""
    root = module.split(".", 1)[0]
    return LIBRARIES.index(root) if root in LIBRARIES else None


def area(module):
    """The AREA of a library module: its path cut to three components.

    `Mathlib.NumberTheory.LSeries.RiemannZeta` is in
    `Mathlib.NumberTheory.LSeries`; `Mathlib.Order.Basic` is its own area; a
    shorter path is its own area (`PrimeNumberTheoremAnd.ZetaBounds`).
    PrimeNumberTheoremAnd's `Mathlib` subtree mirrors Mathlib's tree one level
    down, so it is cut one component deeper, at four:
    `PrimeNumberTheoremAnd.Mathlib.Analysis.Complex`."""
    parts = module.split(".")
    depth = 4 if parts[:2] == ["PrimeNumberTheoremAnd", "Mathlib"] else 3
    return ".".join(parts[:depth])


def islands(members, uses):
    """The ISLANDS of a project: the connected components of its own uses
    graph, edges taken undirected and only between two of `members`.

    Returns sorted member lists, the largest first, ties by first member."""
    mem = sorted(set(members))
    parent = {m: m for m in mem}

    def find(x):
        while parent[x] != x:
            parent[x] = parent[parent[x]]
            x = parent[x]
        return x

    for m in mem:
        for u in uses.get(m, ()):
            if u in parent:
                a, b = find(m), find(u)
                if a != b:
                    parent[max(a, b)] = min(a, b)
    comps = {}
    for m in mem:
        comps.setdefault(find(m), []).append(m)
    return sorted((sorted(c) for c in comps.values()), key=lambda c: (-len(c), c[0]))


def rarity(sets, share=BACKGROUND_SHARE):
    """{item: (islands holding it, background)} over one project's islands.

    `sets` is one set of items (constants or areas) per island. An item held
    by more than `share` of the islands is BACKGROUND: the ground nearly
    everything stands on, left out of the terrain and of shared ground."""
    n_isl = len(sets)
    count = {}
    for st in sets:
        for it in st:
            count[it] = count.get(it, 0) + 1
    return {it: (n, n > share * n_isl) for it, n in sorted(count.items())}


def weight(n, n_islands):
    """The rarity weight of an item held by n of a project's n_islands:
    ln(n_islands / n); an item every island holds weighs 0."""
    return math.log(n_islands / n)


def shared_ground(areas_a, areas_b, rar_a, rar_b, n_a, n_b):
    """The ground two islands share: the areas both stand on that are
    background in neither island's project, each weighted by rarity (the
    mean of its weight in the two projects; one project, its weight there).

    Returns (total rounded to 6 places, [(area, weight)] heaviest first)."""
    out = []
    for a in sorted(set(areas_a) & set(areas_b)):
        ca, bga = rar_a[a]
        cb, bgb = rar_b[a]
        if bga or bgb:
            continue
        out.append((a, round((weight(ca, n_a) + weight(cb, n_b)) / 2, 6)))
    out.sort(key=lambda t: (-t[1], t[0]))
    return round(sum(w for _a, w in out), 6), out


def pair_ranking(isl, rar, n_isl, top):
    """The island pairs sharing the most ground.

    isl: [{"project", "areas", "pin"}]; rar: {project: rarity of areas};
    n_isl: {project: number of islands}. A pair whose two islands stand on
    different Mathlib pins shares ground by NAME only (`cross`: the same
    area path in two Mathlib versions). Pairs with no shared ground are
    dropped; ties go to the lower island indices."""
    pairs = []
    for i in range(len(isl)):
        for j in range(i + 1, len(isl)):
            a, b = isl[i], isl[j]
            tot, areas = shared_ground(a["areas"], b["areas"], rar[a["project"]],
                                       rar[b["project"]], n_isl[a["project"]],
                                       n_isl[b["project"]])
            if tot > 0:
                pairs.append({"a": i, "b": j, "w": tot, "areas": areas,
                              "cross": a["pin"] != b["pin"]})
    pairs.sort(key=lambda p: (-p["w"], p["a"], p["b"]))
    return pairs[:top] if top is not None else pairs


__all__ = ["bounds", "place", "place_t", "cones", "closure", "roots", "depths",
           "same_name", "distinctive", "NameIndex", "mentions", "first_day",
           "date_x", "lit_value", "library", "area", "islands", "rarity", "weight",
           "shared_ground", "pair_ranking", "LIBRARIES", "BACKGROUND_SHARE"]
