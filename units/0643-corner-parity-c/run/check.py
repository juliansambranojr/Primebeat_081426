"""Run the C parity identity (parity.c) on rows 2..66 and check it against the exact pi list. EXPLORATORY.
parity.c prints: m, S(2^m) mod 4, the parity of the prime-power count, the parity of pi(2^m), and the seconds
of its parts (A: e up to c, B: the tau table and the mu sieve, roots: pi at the k-th roots by Lucy's method);
the tau-table seconds go to stderr. Rows past 63 use 128-bit arithmetic for x and for the largest D(y)."""
import json, math, subprocess, time
import numpy as np
pi = [int(x) for x in open('pi_2pow.txt')]
rows = {}; agree = 0
for m in range(2, 67):
    lY = min(26, m)
    t0 = time.time()
    p = subprocess.run(['./parity', str(m), str(lY)], capture_output=True, text=True, check=True)
    wall = time.time() - t0
    f = p.stdout.split()
    tau = float(p.stderr.split()[1]) if p.stderr.strip() else 0.0
    par = int(f[3]); ok = par == pi[m] % 2; agree += ok
    rows[m] = {"S_mod4": int(f[1]), "pi_parity": par, "list_parity": pi[m] % 2, "agree": ok,
               "sec_A": float(f[4]), "sec_B": float(f[5]), "sec_tau": tau, "wall": round(wall, 3)}
out = {"rows_checked": [2, 66], "rows": len(rows), "rows_agree": agree,
       "S_odd_all": all(r["S_mod4"] % 2 == 1 for r in rows.values())}
# cost: the work past the tau table, A + B - tau, on rows 56..66 where it is seconds, not milliseconds
ms = np.arange(56, 67); work = np.array([rows[m]["sec_A"] + rows[m]["sec_B"] - rows[m]["sec_tau"] for m in ms])
slope = float(np.polyfit(ms, np.log2(work), 1)[0])
out["work_seconds_row66"] = round(float(work[-1]), 1)
out["log2_work_slope_rows56_66"] = round(slope, 3)
out["row93_days_at_fitted_slope"] = round(float(work[-1] * 2 ** (slope * (93 - 66)) / 86400), 1)
out["row93_days_at_half"] = round(float(work[-1] * 2 ** (0.5 * (93 - 66)) / 86400), 1)
out["per_row"] = {str(m): r for m, r in rows.items()}
json.dump(out, open("parity.json", "w"), indent=1)
print(json.dumps({k: v for k, v in out.items() if k != "per_row"}, indent=1))
