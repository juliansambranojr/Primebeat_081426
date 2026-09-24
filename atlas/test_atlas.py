"""The atlas on a tiny synthetic fixture: no Lean, no git.

    python3 -m pytest atlas/test_atlas.py -q      (or: python3 atlas/test_atlas.py)

Checks closure, placement parsing, roots, commentary attachment and that two
renders of the same data are byte-identical.
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


def decl(name, uses=(), sorry=False, type_="Prop", file=F, line=1, kind="theorem"):
    return {"name": name, "kind": kind, "file": file, "line": line, "end_line": line,
            "sorry": sorry, "uses": [[f, n] for f, n in uses], "type": type_, "private": False}


def fixture():
    scopes = [
        {"key": "lean", "label": "lean/", "toolchain": "t1", "decls": [
            decl("Bench.base", file=G, line=3, kind="def", type_="ℕ → ℕ"),
            decl("Bench.lemma_one", uses=[(G, "Bench.base")], file=G, line=9,
                 type_="∀ (s : ℂ), 1 < s.re → Bench.base 1 = 1"),
        ]},
        {"key": "lean_stage3", "label": "lean_stage3/", "toolchain": "t2", "decls": [
            decl("Toy.hole", sorry=True, line=2, type_="∀ {s : ℂ}, 0 < s.re → s.re < 1 → True"),
            decl("Toy.mid", uses=[(F, "Toy.hole")], line=5,
                 type_="∀ (γ : ℝ), f (1 / 2 + ↑γ * Complex.I) = 0"),
            decl("Toy.top_bound", uses=[(F, "Toy.mid")], line=8,
                 type_="∀ ρ ∈ S, (↑ρ).re = 1 / 2 ∧ 11 / 10 ≤ (↑ρ).im"),
            decl("Toy.alone", line=11, type_="2 + 2 = 4"),
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


if __name__ == "__main__":
    for name, fn in sorted(globals().items()):
        if name.startswith("test_"):
            fn()
            print("ok", name)
