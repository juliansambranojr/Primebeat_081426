#!/usr/bin/env python3
"""check_weld — the toolchain weld is textual; this makes drift break a gate.

lean_stage3/ (toolchain v4.32.2, PNT+ dependency) composes with the bench
tree lean/ (v4.28.0) by statement identity: definitions shared across the
weld must be character-level copies. The kernel checks neither direction
until the toolchains converge, so this script is the only thing standing
between "identical statements" and silent drift.

For each (name, file_a, file_b) below: extract the full `def <name>` block
from both files (from the def line to the first line that is not a
continuation), compare after stripping trailing whitespace. Any difference
is a broken weld: exit 1 and print both blocks.

STATEMENT_WELDS joins a theorem's conclusion in one tree to a named
hypothesis of a theorem in the other (unit 0423). The conclusion runs from a
start marker to ` := by`; the hypothesis from `(<name> : ` to the `) :` that
closes the binder list. Both are compared with whitespace collapsed, after
the substitutions the entry declares: a namespace for a welded definition,
and the instantiation of a variable the consuming theorem leaves free. The
substitutions are part of the claim and are printed with the result.
"""
import pathlib, re, sys

_HERE = pathlib.Path(__file__).resolve().parent.parent

WELDS = [
    ("StmtSchoenfeldWindow",
     _HERE / "lean" / "Nonvanishing.lean",
     _HERE / "lean_stage3" / "Stage3" / "Statement.lean"),
    ("StmtSchoenfeld",
     _HERE / "lean" / "Schoenfeld.lean",
     _HERE / "lean_stage3" / "Stage3" / "Statement.lean"),
    # lean_stage3/ against lean_bridge/ (v4.33.0-rc2, zeta23 dependency), unit 0381
    ("laplace",
     _HERE / "lean_stage3" / "Stage3" / "WeilDetect.lean",
     _HERE / "lean_bridge" / "Bridge" / "WeilBridge.lean"),
    ("IsTest",
     _HERE / "lean_stage3" / "Stage3" / "WeilDetect.lean",
     _HERE / "lean_bridge" / "Bridge" / "WeilBridge.lean"),
    # the bridge leaf and what it is stated with, unit 0382
    ("tiltF",
     _HERE / "lean_stage3" / "Stage3" / "WeilBridgeLeaf.lean",
     _HERE / "lean_bridge" / "Bridge" / "WeilBridge.lean"),
    ("ft",
     _HERE / "lean_stage3" / "Stage3" / "WeilBridgeLeaf.lean",
     _HERE / "lean_bridge" / "Bridge" / "WeilBridge.lean"),
    ("kOfM",
     _HERE / "lean_stage3" / "Stage3" / "WeilBridgeLeaf.lean",
     _HERE / "lean_bridge" / "Bridge" / "WeilBridge.lean"),
    ("primeSideM",
     _HERE / "lean_stage3" / "Stage3" / "WeilBridgeLeaf.lean",
     _HERE / "lean_bridge" / "Bridge" / "WeilBridge.lean"),
    ("StmtWeilBridge",
     _HERE / "lean_stage3" / "Stage3" / "WeilBridgeLeaf.lean",
     _HERE / "lean_bridge" / "Bridge" / "WeilBridge.lean"),
    # the gate's relative-error statement, joints 3 to 5 of SECTIONS.md, unit 0402
    ("StmtRelErrWindow",
     _HERE / "lean" / "RelativeGate.lean",
     _HERE / "lean_stage3" / "Stage3" / "JointDialGate.lean"),
]


STATEMENT_WELDS = [
    # block E9, units 0421 and 0422: the route's conclusion under RH is the
    # hypothesis of the table's gate at depth six
    {"name": "gate_hyp_of_RH -> cell_ne_zero_of_route.hroute",
     "a": _HERE / "lean_stage3" / "Stage3" / "GateEval.lean",
     "a_theorem": "theorem gate_hyp_of_RH", "a_start": "∃ ρ : ℝ,",
     "b": _HERE / "lean" / "RouteCell.lean",
     "b_theorem": "theorem cell_ne_zero_of_route", "b_hyp": "hroute",
     "subs": [("JointDialGate.StmtRelErrWindow", "RelativeGate.StmtRelErrWindow"),
              ("(fun m : ℤ => (Nat.primeCounting ⌊(2 : ℝ) ^ (m : ℝ)⌋₊ : ℝ))", "f")]},
]


def _collapse(t):
    return " ".join(t.split())


def extract_conclusion(path, theorem, start):
    text = path.read_text()
    if text.count(theorem + " ") != 1:
        sys.exit(f"WELD ERROR: {path} has {text.count(theorem + ' ')} of `{theorem}`")
    i = text.index(theorem + " ")
    j = text.index(start, i)
    k = text.index(" := by", j)
    return text[j:k]


def extract_hypothesis(path, theorem, hyp):
    text = path.read_text()
    if text.count(theorem + " ") != 1:
        sys.exit(f"WELD ERROR: {path} has {text.count(theorem + ' ')} of `{theorem}`")
    i = text.index(theorem + " ")
    j = text.index(f"({hyp} : ", i) + len(f"({hyp} : ")
    k = text.index(") :\n", j)
    return text[j:k]


def extract_def(path, name):
    text = path.read_text()
    lines = text.splitlines()
    starts = [i for i, ln in enumerate(lines)
              if re.match(rf'^(?:noncomputable )?def {re.escape(name)}\b', ln)]
    if len(starts) != 1:
        sys.exit(f"WELD ERROR: {path} has {len(starts)} defs named {name}")
    i = starts[0]
    block = [lines[i].rstrip()]
    for ln in lines[i + 1:]:
        if ln.strip() == "" or re.match(r'^\S', ln):
            break
        block.append(ln.rstrip())
    return "\n".join(block)


def main():
    broken = 0
    for name, fa, fb in WELDS:
        a, b = extract_def(fa, name), extract_def(fb, name)
        if a == b:
            print(f"WELD OK      {name}  ({fa.name} == {fb.name})")
        else:
            broken += 1
            print(f"WELD BROKEN  {name}")
            print(f"--- {fa}\n{a}\n--- {fb}\n{b}")
    for w in STATEMENT_WELDS:
        a = extract_conclusion(w["a"], w["a_theorem"], w["a_start"])
        b = extract_hypothesis(w["b"], w["b_theorem"], w["b_hyp"])
        for old, new in w["subs"]:
            if old not in a:
                sys.exit(f"WELD ERROR: substitution source not found in {w['a']}: {old}")
            a = a.replace(old, new)
        if _collapse(a) == _collapse(b):
            print(f"WELD OK      {w['name']}  ({w['a'].name} == {w['b'].name})")
            for old, new in w["subs"]:
                print(f"             with  {old}  :=  {new}")
        else:
            broken += 1
            print(f"WELD BROKEN  {w['name']}")
            print(f"--- {w['a']}\n{_collapse(a)}\n--- {w['b']}\n{_collapse(b)}")
    print(f"\n{broken} broken weld(s)")
    sys.exit(1 if broken else 0)


if __name__ == "__main__":
    main()
