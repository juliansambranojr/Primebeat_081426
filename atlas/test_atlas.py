"""The atlas on a tiny synthetic fixture: no Lean, no git.

    python3 -m pytest atlas/test_atlas.py -q      (or: python3 atlas/test_atlas.py)

Checks closure, placement parsing, roots, commentary attachment, the ground
(areas, islands, rarity, shared ground), that the page with the ground layers
off is the page as it was, and that two renders are byte-identical.
"""

import pathlib
import sys

HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import build_atlas  # noqa: E402
import model  # noqa: E402
import page  # noqa: E402

F = "lean_stage3/Stage3/Toy.lean"
G = "lean/Bench.lean"


RE = "Mathlib.Data.Real.Basic"
LS = "Mathlib.NumberTheory.LSeries.RiemannZeta"
CX = "Mathlib.Analysis.Complex.Basic"


def decl(name, uses=(), sorry=False, type_="Prop", file=F, line=1, kind="theorem", lib=()):
    return {"name": name, "kind": kind, "file": file, "line": line, "end_line": line,
            "sorry": sorry, "uses": [[f, n] for f, n in uses], "type": type_, "private": False,
            "lib": [[m, c] for m, c in lib]}


def fixture():
    scopes = [
        {"key": "lean", "label": "lean/", "toolchain": "t1", "decls": [
            decl("Bench.base", file=G, line=3, kind="def", type_="ℕ → ℕ", lib=[(RE, "Real")]),
            decl("Bench.lemma_one", uses=[(G, "Bench.base")], file=G, line=9,
                 type_="∀ (s : ℂ), 1 < s.re → Bench.base 1 = 1",
                 lib=[(LS, "riemannZeta"), (RE, "Real")]),
        ]},
        {"key": "lean_stage3", "label": "lean_stage3/", "toolchain": "t2", "decls": [
            decl("Toy.hole", sorry=True, line=2, type_="∀ {s : ℂ}, 0 < s.re → s.re < 1 → True",
                 lib=[(CX, "Complex"), (RE, "Real"),
                      ("PrimeNumberTheoremAnd.ZetaBounds", "ZetaUpperBnd")]),
            decl("Toy.mid", uses=[(F, "Toy.hole")], line=5,
                 type_="∀ (γ : ℝ), f (1 / 2 + ↑γ * Complex.I) = 0",
                 lib=[("PrimeNumberTheoremAnd.Mathlib.Analysis.Complex.Foo", "Complex.foo"),
                      (LS, "riemannZeta")]),
            decl("Toy.top_bound", uses=[(F, "Toy.mid")], line=8,
                 type_="∀ ρ ∈ S, (↑ρ).re = 1 / 2 ∧ 11 / 10 ≤ (↑ρ).im"),
            decl("Toy.alone", line=11, type_="2 + 2 = 4", lib=[(CX, "Complex.I")]),
        ]},
    ]
    units = [
        {"id": "0901", "dir": "0901-toy", "date": "2026-09-02", "type": "formalization",
         "title": "toy", "refs": [F + "::mid", F + "::Toy.top_bound"]},
        {"id": "0902", "dir": "0902-none", "date": "2026-09-03", "type": "decision",
         "title": "no lean", "refs": ["notes/x.md"]},
    ]
    comm = [
        ("notes/a.md", "We proved top_bound after mid, see Toy.lean and unit 0901."),
        ("scripts/b.py", "phi = 1\nmode = 2\nprint(Toy.alone)\n"),
        ("notes/c.md", "nothing named here at all, 2026 and 0.0901 are not ids"),
    ]
    days = {"Bench.base": "2026-09-01", "Bench.lemma_one": "2026-09-02", "Toy.hole": "2026-09-01",
            "Toy.mid": "2026-09-02", "Toy.top_bound": "2026-09-03", "Toy.alone": "2026-09-03"}
    added = {"notes/a.md": "2026-09-03", "scripts/b.py": "2026-09-01", "notes/c.md": "2026-09-02"}
    return scopes, units, comm, (lambda f, n: days[n]), added


PINS = {"lean": {"Mathlib": "aaaa"}, "lean_stage3": {"Mathlib": "bbbb",
                                                   "PrimeNumberTheoremAnd": "cccc"}}


def ground_fixture():
    """The fixture with more islands, so rarity has room: six in each project.

    lean/: {base, lemma_one}, other, p1, p2, p3, p4. Data.Real is held by 4 of
    6 islands (background), LSeries by 2 (weight ln 3), Analysis.Complex by 1
    (p1, weight ln 6). lean_stage3/: {hole, mid, top_bound}, alone, s1, s2,
    s3, s4. Data.Real by 3 of 6 (background), LSeries by 2, Analysis.Complex
    by 2 (weight ln 3), each PrimeNumberTheoremAnd area by 1 (ln 6)."""
    scopes, units, comm, days_of, added = fixture()
    days = {}
    for name, lib in (("Bench.other", [("Mathlib.NumberTheory.LSeries.Dirichlet", "LSeries"),
                                       (RE, "Real")]),
                      ("Bench.p1", [(RE, "Real"), (CX, "Complex")]),
                      ("Bench.p2", [(RE, "Real.instLT")]), ("Bench.p3", []), ("Bench.p4", [])):
        scopes[0]["decls"].append(decl(name, file=G, line=20 + len(days), kind="def", lib=lib))
        days[name] = "2026-09-03"
    for name, lib in (("Toy.s1", [(LS, "riemannZeta")]), ("Toy.s2", [(RE, "Real")]),
                      ("Toy.s3", [(RE, "Real")]), ("Toy.s4", [])):
        scopes[1]["decls"].append(decl(name, line=20 + len(days), kind="def", lib=lib))
        days[name] = "2026-09-03"
    return scopes, units, comm, (lambda f, n: days.get(n) or days_of(f, n)), added


def build_ground():
    scopes, units, comm, days_of, added = ground_fixture()
    decls, uses, used_by, upins, ct = build_atlas.assemble(scopes, units, comm, days_of, added)
    D = build_atlas.layout(scopes, decls, uses, used_by, units, upins, ct, added, [])
    D["counts"] = build_atlas.counts(D)
    D["ground"] = build_atlas.ground(scopes, decls, uses, D, PINS, {})
    return D


def build():
    scopes, units, comm, days_of, added = fixture()
    decls, uses, used_by, upins, ct = build_atlas.assemble(scopes, units, comm, days_of, added)
    D = build_atlas.layout(scopes, decls, uses, used_by, units, upins, ct, added, [])
    D["counts"] = build_atlas.counts(D)
    return decls, uses, upins, ct, D


def test_closure():
    uses = {"a": ["b"], "b": ["c"], "c": [], "d": []}
    clo = model.closure(uses, {"c": True})
    assert clo == {"a": round(2 / 3, 6), "b": 0.5, "c": 0.0, "d": 1.0}
    decls, _u, _p, _c, _D = build()
    by = {d["name"]: d for d in decls}
    assert by["Toy.top_bound"]["closure"] == round(2 / 3, 6)
    assert by["Toy.alone"]["closure"] == 1.0


def test_roots_and_depth():
    uses = {"a": ["b"], "b": ["c"], "c": [], "d": []}
    assert model.roots(uses) == ["c", "d"]
    assert model.depths(uses) == {"a": 2, "b": 1, "c": 0, "d": 0}
    decls, *_ = build()
    assert sorted(d["name"] for d in decls if d["root"]) == ["Bench.base", "Toy.alone", "Toy.hole"]


def test_placement():
    re_b, im_b = model.bounds("∀ {s : ℂ}, 1 / 2 < s.re → s ≠ 1 → f s ≠ 0")
    assert [(r, v) for r, v, _ in re_b] == [("gt", 0.5)]
    assert model.place(re_b)[0] == 0.75
    re_b, im_b = model.bounds("∀ ρ ∈ S, (↑ρ).re = 1 / 2 ∧ 11 / 10 ≤ (↑ρ).im")
    assert model.place(re_b)[:1] == (0.5,) and model.place(re_b)[3] == "on"
    assert model.place_t(im_b)[0] == 1.1
    assert model.place(model.bounds("∀ s, 1 < s.re → g s")[0])[0] == 1.25
    assert model.place(model.bounds("∀ s, s.re ≤ 0 → g s")[0])[0] == -0.25
    assert model.place(model.bounds("f (1 / 2 + ↑γ * Complex.I) = 0")[0])[0] == 0.5
    assert model.place(model.bounds("σ ∈ Set.Ioo 0 1 → g σ")[0])[0] == 0.5
    assert model.place(model.bounds("∀ σ₁, 1 / 2 < σ₁ → σ₁ ≤ 3 / 4 → g")[0])[0] == 0.625
    # an operand that does not stand alone reads nothing
    assert model.bounds("x + 1 / 2 < s.re → g")[0] == []
    assert model.bounds("2 * s.re ≤ 1 → g")[0] == []
    assert model.bounds("(w ^ 2).re ≤ 0 → g")[0] == []
    assert model.place(model.bounds("2 + 2 = 4")[0]) is None
    assert model.lit_value("(1 / 2 : ℝ)") == 0.5 and model.lit_value("2⁻¹") == 0.5
    assert model.lit_value("-(11 / 10)") == -1.1
    decls, *_ = build()
    by = {d["name"]: d for d in decls}
    assert by["Toy.alone"]["place"] is None
    assert by["Bench.lemma_one"]["place"][0] == 1.25


def test_units_pinned():
    _d, _u, upins, _c, D = build()
    names = [D["decls"][i]["n"] for i in upins[0][0]]
    assert sorted(names) == ["Toy.mid", "Toy.top_bound"]
    assert upins[1] == ([], [])
    assert D["counts"]["units_pinned"] == 1 and D["counts"]["units_in_lane"] == 1


def test_commentary():
    decls, _u, _p, ct, D = build()
    names = lambda ids: sorted(decls[i]["name"] for i in ids)  # noqa: E731
    a, b, c = ct
    assert names(a[1]) == ["Toy.top_bound"]          # `mid` alone is not distinctive
    assert a[2] == [F] and a[3] == ["0901"]
    assert names(b[1]) == ["Toy.alone"] and b[2] == [] and b[3] == []   # `phi`, `mode` name nothing
    assert c[1:] == ([], [], [])                        # margin
    assert D["counts"]["commentary_attached"] == 2 and D["counts"]["commentary_margin"] == 1
    idx = model.NameIndex({0: "Chain.Sym", 1: "WeilLobe.lobe_bound"})
    assert idx.lookup("Sym") == set() and idx.lookup("Chain.Sym") == {0}
    assert idx.lookup("lobe_bound") == {1} and idx.lookup("X.WeilLobe.lobe_bound") == {1}


def test_deterministic():
    one = page.render(build()[4]).encode()
    two = page.render(build()[4]).encode()
    assert one == two
    assert b"http://" not in one and b"https://" not in one


def test_areas():
    assert model.area("Mathlib.NumberTheory.LSeries.RiemannZeta") == "Mathlib.NumberTheory.LSeries"
    assert model.area("Mathlib.Order.Basic") == "Mathlib.Order.Basic"
    assert model.area("PrimeNumberTheoremAnd.ZetaBounds") == "PrimeNumberTheoremAnd.ZetaBounds"
    assert (model.area("PrimeNumberTheoremAnd.Mathlib.Analysis.Complex.Foo")
            == "PrimeNumberTheoremAnd.Mathlib.Analysis.Complex")
    assert model.library("Mathlib.Data.Real.Basic") == 0
    assert model.library("PrimeNumberTheoremAnd.ZetaBounds") == 1
    assert model.library("Batteries.Data.List") is None and model.library("Init.Core") is None
    D = build_ground()
    G = D["ground"]
    A = [a["n"] for a in G["areas"]]
    assert A == ["Mathlib.Analysis.Complex", "Mathlib.Data.Real", "Mathlib.NumberTheory.LSeries",
                 "PrimeNumberTheoremAnd.Mathlib.Analysis.Complex", "PrimeNumberTheoremAnd.ZetaBounds"]
    by = {d["n"]: i for i, d in enumerate(D["decls"])}
    names = lambda cs: sorted(G["consts"][c][1] for c in cs)  # noqa: E731
    assert names(G["dc"][by["Toy.mid"]]) == ["Complex.foo", "riemannZeta"]
    assert names(G["dc"][by["Bench.p3"]]) == []
    # a declaration stands on each area it names directly
    lser = G["areas"][A.index("Mathlib.NumberTheory.LSeries")]
    assert sorted(D["decls"][i]["n"] for i in lser["d"]) == ["Bench.lemma_one", "Bench.other", "Toy.mid",
                                                              "Toy.s1"]


def test_islands_and_rarity():
    assert model.islands(["a", "b", "c", "d"], {"a": ["b"], "c": ["x"], "d": []}) == [
        ["a", "b"], ["c"], ["d"]]
    r = model.rarity([{"x", "y"}, {"x"}, {"x"}, {"z"}, set(), set()])
    assert r == {"x": (3, True), "y": (1, False), "z": (1, False)}
    assert model.rarity([{"x"}, {"x"}, set(), set(), set(), set()])["x"] == (2, False)  # 2/6 = 1/3
    D = build_ground()
    G = D["ground"]
    assert G["counts"]["lean"]["islands"] == 6 and G["counts"]["lean_stage3"]["islands"] == 6
    tops = sorted(D["decls"][x["top"]]["n"] for x in G["islands"] if len(x["m"]) > 1)
    assert tops == ["Bench.lemma_one", "Toy.top_bound"]
    A = {a["n"]: a for a in G["areas"]}
    assert A["Mathlib.Data.Real"]["bg"] == [0, 1]            # 4 of 6 in lean/, 3 of 6 in stage3
    assert A["Mathlib.NumberTheory.LSeries"]["bg"] == []      # 2 of 6 in each
    assert A["Mathlib.NumberTheory.LSeries"]["k"] == [2, 2] and A["Mathlib.NumberTheory.LSeries"]["h"] == 4
    assert A["Mathlib.Data.Real"]["h"] == 0                   # background everywhere: no terrain
    real = [c for c in G["consts"] if c[1] == "Real"][0]
    assert real[2] == [3, 3] and real[3] == 0b11              # 3 of 6 > one third in both
    assert G["counts"]["lean"]["Mathlib"] == {"constants": 5, "areas": 3, "background_areas": 1}
    assert G["counts"]["lean_stage3"]["PrimeNumberTheoremAnd"] == {
        "constants": 2, "areas": 2, "background_areas": 0}


def test_shared_ground():
    import math
    D = build_ground()
    G = D["ground"]
    P, I, A = D["decls"], G["islands"], G["areas"]
    top = lambda k: P[I[k]["top"]]["n"]  # noqa: E731
    pairs = [(top(p["a"]), top(p["b"]), p["w"], p["x"], [A[a]["n"] for a, _w in p["ar"]])
             for p in G["pairs"]]
    w_cx = round((math.log(6) + math.log(3)) / 2, 6)         # Complex: 1 of 6 in lean/, 2 of 6 in stage3
    assert pairs[0] == ("Bench.p1", "Toy.top_bound", w_cx, 1, ["Mathlib.Analysis.Complex"])
    assert pairs[1] == ("Bench.p1", "Toy.alone", w_cx, 1, ["Mathlib.Analysis.Complex"])
    same = [p for p in pairs if p[:2] == ("Bench.lemma_one", "Bench.other")][0]
    # Data.Real is shared too but it is background: only LSeries counts, and no name match
    assert same[2:] == (round(math.log(3), 6), 0, ["Mathlib.NumberTheory.LSeries"])
    assert all(p[2] > 0 for p in pairs)
    assert [p[2] for p in pairs] == sorted((p[2] for p in pairs), reverse=True)
    tot, ar = model.shared_ground({"a", "b"}, {"a", "b"}, {"a": (1, False), "b": (5, True)},
                                  {"a": (2, False), "b": (1, False)}, 6, 4)
    assert ar == [("a", round((math.log(6) + math.log(2)) / 2, 6))] and tot == ar[0][1]


# The page as it was before the ground layers, rendered from the ground fixture
# with its ground removed (atlas/page.py at 4e4e8aa).
BEFORE = "5007bb594bee25fd123df40240dcf6d7e58d58d6988dae4d19a5854698698e48"


def test_toggle_off_equality():
    import hashlib
    D = build_ground()
    bare = {k: v for k, v in D.items() if k != "ground"}
    # the maps' data is untouched by the ground: layout gives the same D
    scopes, units, comm, days_of, added = ground_fixture()
    decls, uses, used_by, upins, ct = build_atlas.assemble(scopes, units, comm, days_of, added)
    D0 = build_atlas.layout(scopes, decls, uses, used_by, units, upins, ct, added, [])
    D0["counts"] = build_atlas.counts(D0)
    assert D0 == bare
    # with no ground the page is the page as it was, byte for byte
    assert hashlib.sha256(page.render(bare).encode()).hexdigest() == BEFORE
    # with the ground it differs only by the toggles, off, and what they carry
    full = page.render(D)
    assert full.count('data-layer="mground">') == 1 and full.count('data-layer="pground">') == 1
    assert 'data-layer="mground" checked' not in full and 'data-layer="pground" checked' not in full
    G = D["ground"]
    old = page.render(bare)
    stripped = (full.replace(page.GCSS, "", 1)
                .replace('\n<span class="grp">ground</span>'
                         '\n<label><input type="checkbox" data-layer="mground"> Mathlib ground</label>'
                         '\n<label><input type="checkbox" data-layer="pground"> PrimeNumberTheoremAnd ground</label>',
                         "", 1)
                .replace(page._ground_section(D), "", 1).replace(page._ground_read(G), "", 1)
                .replace(page._legend(G), page._legend(), 1)
                .replace(page._json_script(D), page._json_script(bare), 1)
                .replace(page._script(G), page._script(None), 1))
    assert stripped == old
    # every ground snippet in the script is gated: none paints while both layers are off
    assert page.GJS["terrain"].startswith("if(layer.mground||layer.pground)")
    assert "if(lv<1)return;[0,1].forEach(function(l){if(!gOn(l))return;" in page.GJS["init"]
    assert "if(!gOn(a.l)||!a.h)return;" in page.GJS["init"]            # hover finds no area


def test_ground_escaped_and_deterministic():
    D = build_ground()
    D["ground"]["areas"][0]["n"] = "Mathlib.<b>&\"x"
    one = page.render(D).encode()
    assert one == page.render(D).encode()
    assert b"Mathlib.<b>" not in one and b"http://" not in one and b"https://" not in one


if __name__ == "__main__":
    for name, fn in sorted(globals().items()):
        if name.startswith("test_"):
            fn()
            print("ok", name)
