# The three runs of utilities/pirows/build_rows.sh on the Mac, 2026-11-27, read from their outputs as produced:
# build_a.out (`build_rows.sh 24 25`), build_b.out (its rerun, stopped by Julian during row 25),
# build_c.out (`build_rows.sh 25`). Each line is "<module> ok <s>s" or "<module> FAIL <code> ...".
import json, re
root = "../../../utilities/pirows/"
mods = {r: [m for m in open(f"{root}mods{r}.txt").read().split() if m] for r in (24, 25)}
out = {"modules_listed": {str(r): len(v) for r, v in mods.items()}}
ok_any = set()
for name in ("build_a", "build_b", "build_c"):
    t = open(f"{name}.out").read()
    ok = {m: int(s) for m, s in re.findall(r"^(\S+) ok (\d+)s$", t, re.M)}
    fail = re.findall(r"^(\S+) FAIL (\d+)", t, re.M)
    ok_any |= set(ok)
    rec = {"ok": len(ok), "failed": [[m, int(c)] for m, c in fail],
           "exit": int(re.search(r"^EXIT (\d+)", t, re.M).group(1)) if re.search(r"^EXIT", t, re.M) else None}
    tot = re.search(r"built in (\d+)s", t)
    if tot: rec["seconds"] = int(tot.group(1))
    for m in ("PiRow24", "Census24", "PiRow25", "Census25"):
        if m in ok: rec[f"{m}_seconds"] = ok[m]
    out[name] = rec
for r, v in mods.items():
    out[f"row{r}_missing"] = sorted(set(v) - ok_any)
    out[f"row{r}_term_modules"] = sum(1 for m in v if m.startswith(f"PiL{r}"))
out["census_ok"] = [m for m in ("Census24", "Census25") if m in ok_any]
json.dump(out, open("builds.json", "w"), indent=1); print(json.dumps(out, indent=1))
