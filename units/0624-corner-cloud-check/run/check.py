"""A check, on the Mac, of corner-cloud's units 0640 (corner-lower-bounds) and 0641 (corner-residues).

Usage: python3 -I check.py <Primebeat repo root> <commit holding both units>

1. Extracts both units from the commit with `git archive` into a temporary tree beside a link to `imported/`,
   reruns each unit's run/run.sh there, and compares the fresh diag.json and resid.json with the committed
   ones, value by value.
2. Compares the units' pi_2pow.txt with OEIS b007053.txt at the repo root.
3. The near-harmonic family of unit 0640 (zeros with cos(gamma log 2) < 0): its size, and its share of the sum of
   squares when each zero is weighted f^d / gamma, with diag.py's f = sqrt(3 - 2 sqrt 2 cos(gamma log 2)).
"""
import io, json, math, pathlib, subprocess, sys, tarfile, tempfile, time
import numpy as np

root = pathlib.Path(sys.argv[1]).resolve(); commit = sys.argv[2]
UNITS = {"0640": ("0640-corner-lower-bounds", "diag"), "0641": ("0641-corner-residues", "resid")}

def flat(o, p=""):
    if isinstance(o, dict):
        for k, v in o.items(): yield from flat(v, f"{p}.{k}" if p else k)
    elif isinstance(o, list):
        for i, v in enumerate(o): yield from flat(v, f"{p}[{i}]")
    else: yield p, o

out = {"commit": subprocess.run(["git", "rev-parse", commit], cwd=root, capture_output=True, text=True).stdout.strip()}
with tempfile.TemporaryDirectory() as tmp:
    tmp = pathlib.Path(tmp)
    tar = subprocess.run(["git", "archive", commit] + [f"units/{d}" for d, _ in UNITS.values()],
                         cwd=root, capture_output=True, check=True).stdout
    tarfile.open(fileobj=io.BytesIO(tar)).extractall(tmp, filter="data")
    (tmp / "imported").symlink_to(root / "imported")
    for uid, (d, stem) in UNITS.items():
        run = tmp / "units" / d / "run"
        old = dict(flat(json.loads((run / f"{stem}.json").read_text())))
        t0 = time.time()
        p = subprocess.run(["sh", "run.sh"], cwd=run, capture_output=True, text=True)
        new = dict(flat(json.loads((run / f"{stem}.json").read_text())))
        differ = sorted(k for k in set(old) | set(new) if old.get(k) != new.get(k))
        out[f"u{uid}"] = {"exit": p.returncode, "seconds": round(time.time() - t0, 1), "values": len(old),
                          "values_differ": len(differ), "differ_keys": differ}
        if stem == "resid":
            for k in ("parity_identity.extrapolated_log10_seconds_row93", "parity_identity.log2_time_slope_per_row",
                      "parity_identity.seconds.46"):
                out[f"u{uid}"][k.split(".")[-1]] = {"committed": old[k], "mac": new[k]}
            s46 = new["parity_identity.seconds.46"]
            out[f"u{uid}"]["days_row93_at_slope_half_from_mac"] = round(s46 * 2 ** (0.5 * 47) / 86400, 1)
    pi = [int(x) for x in (tmp / "units" / UNITS["0640"][0] / "run" / "pi_2pow.txt").read_text().split()]
    same = (tmp / "units" / UNITS["0640"][0] / "run" / "pi_2pow.txt").read_bytes() == \
           (tmp / "units" / UNITS["0641"][0] / "run" / "pi_2pow.txt").read_bytes()
b = {}
for l in (root / "b007053.txt").read_text().splitlines():
    q = l.split()
    if len(q) == 2 and q[0].isdigit(): b[int(q[0])] = int(q[1])
out["pi_list"] = {"rows": len(pi), "same_in_both_units": same,
                  "rows_compared_to_b007053": sum(1 for m in range(len(pi)) if m in b),
                  "rows_differ_from_b007053": sum(1 for m in range(len(pi)) if m in b and b[m] != pi[m])}
g = np.loadtxt(root / "imported" / "twin_count" / "zeros1.txt"); L2 = math.log(2)
near = np.cos(g * L2) < 0; f = np.sqrt(3 - 2 * math.sqrt(2) * np.cos(g * L2))
fam = {"size": int(near.sum()), "of": len(g), "share_of_squares": {}}
for d in (17, 67, 120, 354):
    w = (f ** d / g) ** 2
    fam["share_of_squares"][f"d{d}"] = float("%.7f" % (w[near].sum() / w.sum()))
out["family"] = fam
json.dump(out, open("check.json", "w"), indent=1, sort_keys=True); print(json.dumps(out, indent=1, sort_keys=True))
