# Read the #guard_msgs axiom pins for the named theorems, and the weld check, from the tree.
import json, re, subprocess, sys, pathlib
root = pathlib.Path(sys.argv[1])
names = sys.argv[2].split(",")
out = {"pins": {}}
for p in list((root / "lean").glob("*.lean")) + list((root / "lean_stage3" / "Stage3").glob("*.lean")):
    t = p.read_text()
    for m in re.finditer(r"/-- info: '([^']+)' depends on axioms: \[([^\]]*)\] -/\s*#guard_msgs in\s*#print axioms (\S+)", t):
        short = m.group(1).split(".")[-1]
        if short in names:
            out["pins"][short] = {"file": str(p.relative_to(root)), "axioms": m.group(2),
                                  "clean": m.group(2) == "propext, Classical.choice, Quot.sound"}
w = subprocess.run([sys.executable, str(root / "utilities" / "check_weld.py")], capture_output=True, text=True)
out["weld_exit"] = w.returncode
out["welds_ok"] = w.stdout.count("WELD OK")
out["welds_broken"] = w.stdout.count("WELD BROKEN")
out["missing"] = [n for n in names if n not in out["pins"]]
json.dump(out, open("pins.json", "w"), indent=1)
print(json.dumps(out, indent=1))
