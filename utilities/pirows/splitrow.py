import re, glob, sys
R = int(sys.argv[1]); import os; S = os.path.dirname(os.path.abspath(__file__))
blocks = sorted(int(p.split('_')[1].split('.')[0]) for p in glob.glob(f"PiL{R}_*.lean") if re.fullmatch(rf"PiL{R}_\d+\.lean", p))
mods = [f"PiW{R}"]
for b in blocks:
    src = open(f"PiL{R}_{b}.lean").read()
    m = re.search(r"Finset\.Ico (\d+) (\d+)", src); lo, hi = int(m.group(1)), int(m.group(2)); ks = list(range(lo, hi))
    for k in ks:
        open(f"PiL{R}_{b}_{k}.lean", "w").write(f'''import PiW{R}

namespace Legendre

set_option maxHeartbeats 0 in
theorem g{R}_{b}_{k} : ∀ i ∈ Finset.Ico {k} {k+1}, F{R} i = W{R} i := by
  decide +kernel

end Legendre
''')
    imports = "\n".join(f"import PiL{R}_{b}_{k}" for k in ks)
    cases = "\n".join(f"  {'if' if j == 0 else 'else if'} h{j} : i < {k+1} then exact g{R}_{b}_{k} i (Finset.mem_Ico.mpr ⟨by omega, h{j}⟩)" for j, k in enumerate(ks))
    open(f"PiL{R}_{b}.lean", "w").write(f'''{imports}

namespace Legendre

/-- Indices {lo} … {hi-1}, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g{R}_{b} : ∀ i ∈ Finset.Ico {lo} {hi}, F{R} i = W{R} i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
{cases}
  else omega

end Legendre
''')
    mods += [f"PiL{R}_{b}_{k}" for k in ks] + [f"PiL{R}_{b}"]
mods += [f"PiRow{R}"]
row = open(f"PiRow{R}.lean").read()
if "maxRecDepth" not in row:
    row = row.replace(f"theorem F{R}_eq_W{R} ", f"set_option maxRecDepth 20000 in\ntheorem F{R}_eq_W{R} ")
    open(f"PiRow{R}.lean", "w").write(row)
lake = open("lakefile.toml").read()
new = [m for m in mods if f'"{m}"' not in lake]
lake = lake.replace('"]\n', '", ' + ", ".join(f'"{m}"' for m in new) + ']\n', 1) if False else lake
i = lake.rindex(']'); lake = lake[:i] + ", " + ", ".join(f'"{m}"' for m in new) + lake[i:]
open("lakefile.toml", "w").write(lake)
open(f"{S}/mods{R}.txt", "w").write(" ".join(mods))
print(len(blocks), "blocks;", len(mods), "modules")
