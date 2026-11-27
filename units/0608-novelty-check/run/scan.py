# Scan the Lean libraries the tree depends on for prior formalizations of what this session proved.
# Paths are read from the repo checkout three levels up (run/ -> unit -> units -> repo).
import json, pathlib, re
root = pathlib.Path(__file__).resolve().parents[3]
libs = {"mathlib": root / "lean_stage3/.lake/packages/mathlib",
        "pnt_plus": root / "lean_stage3/.lake/packages/PrimeNumberTheoremAnd",
        "zeta23": root / "lean_bridge/.lake/packages/Zeta23"}
pats = {"meissel_lehmer_formula": r"Meissel[-_ ]?Lehmer(?![- ]?Mertens)|meissel_lehmer",
        "legendre_phi_formula": r"primeCounting_eq_phi|Legendre'?s? (prime|phi)|legendrePhi",
        "rvm_bound": r"Riemann_vonMangoldt_bound|RvM|Riemann--von Mangoldt|Riemann-von Mangoldt"}
out = {}
for ln, p in libs.items():
    files = [f for f in p.rglob("*.lean") if ".lake" not in f.relative_to(p).parts]
    row = {"files": len(files)}
    for k, pat in pats.items():
        hits = [f for f in files if re.search(pat, f.read_text(errors="ignore"))]
        row[k] = len(hits)
        row[k + "_sorry_free"] = sum(1 for f in hits if not re.search(r"\bsorry\b", f.read_text(errors="ignore")))
    out[ln] = row
# PNT+'s Backlund statement at the pinned version
k = (libs["pnt_plus"] / "PrimeNumberTheoremAnd/IEANTN/Kadiri.lean").read_text()
m = re.search(r"theorem backlund_bound : riemannZeta\.Riemann_vonMangoldt_bound ([\d.]+) ([\d.]+) ([\d.]+) := by\s*\n\s*(\S+)", k)
out["pnt_backlund"] = {"b1": float(m.group(1)), "b2": float(m.group(2)), "b3": float(m.group(3)),
                       "proof_is_sorry": m.group(4) == "sorry"}
# constants as published, from the sources cited in the prose (2412.15470 table)
out["published"] = {"backlund": [0.137, 0.443, 5.225], "trudgian": [0.112, 0.278, 3.385]}
out["ours_rvM_sharp_b1"] = 15
json.dump(out, open("scan.json", "w"), indent=1); print(json.dumps(out, indent=1))
