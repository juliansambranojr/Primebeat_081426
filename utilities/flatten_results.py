#!/usr/bin/env python3
"""Flatten a results JSON to a sibling `<stem>.numbers`: one `key<TAB>value` per leaf.

    python3 utilities/flatten_results.py <results.json> [more.json ...]
    python3 utilities/flatten_results.py --check <file.numbers> [more.numbers ...]

The .numbers file is the citable form of a result. An entry names a value by its
key and the value is read from this file, never retyped from a report. Format:

  line 1   # sha256 <hex of the JSON bytes>
  line 2   # source <repo-relative path of the JSON>
  then     key<TAB>value, one per leaf

Keys are dotted paths. List indices are `[i]`. Dict keys are kept verbatim as one
segment, dots and all, so `ladder` -> `k=10|eps=0.01|M=16|w=1/2` -> `L_c` is the
single line `ladder.k=10|eps=0.01|M=16|w=1/2.L_c`. A key is therefore matched
whole, never re-split on its dots. Values: floats by repr (round-trip precision),
ints as ints, strings by json.dumps, true/false/null as JSON literals. An empty
dict or list is a leaf and is written as `{}` / `[]` so nothing is silently lost.

Order is the JSON's own insertion order, depth-first. Two runs of the same script
therefore produce line-for-line comparable files.

A leaf whose key path carries a timing or provenance token (time, timings,
seconds, elapsed, wall, sha256, hash, hostname, date, timestamp, run_start ...;
see META_TOKENS / META_SUBSTR) is written with the prefix `meta.` so that

    diff <(grep -v '^meta\\.' a.numbers) <(grep -v '^meta\\.' b.numbers)

is the reproduction test between two runs.

  --check    recompute the JSON's sha256 and compare with line 1. The JSON is the
             sibling `<stem>.json` when it exists, else line 2 resolved against
             the repo root.

Exit 0 on success, 1 if any --check differs, 2 on a usage or missing-file error.
"""
import argparse, hashlib, json, pathlib, re, sys

ROOT = pathlib.Path(__file__).resolve().parent.parent

# Matched as whole tokens of the key path (split on anything that is not a
# letter or digit), because plain substring matching mis-filed the data column
# `fits.M=16|w=1/2.Lc_times_eps[i]` under meta. via "time" in "times", and would
# file any `validated`/`update` key under "date". The set is the brief's
# {time, seconds, elapsed, wall, sha256, hash, hostname, date, timestamp,
# code_hash} plus names present in the ladder JSONs that those miss:
# `timings.*`, `run_start_at`, `run_end_at`, `generated_utc`.
META_TOKENS = {"time", "timing", "timings", "seconds", "elapsed", "wall",
               "sha256", "hash", "hostname", "date", "timestamp"}
META_SUBSTR = ("code_hash", "run_start", "run_end", "generated_utc")
_TOK = re.compile(r"[^a-z0-9]+")


def is_meta(path):
    p = path.lower()
    return (any(m in p for m in META_SUBSTR)
            or any(t in META_TOKENS for t in _TOK.split(p)))


def fmt(v):
    if v is None or isinstance(v, bool):
        return json.dumps(v)
    if isinstance(v, int):
        return str(v)
    if isinstance(v, float):
        return repr(v)
    if isinstance(v, str):
        return json.dumps(v, ensure_ascii=False)
    if isinstance(v, (dict, list)) and not v:
        return "{}" if isinstance(v, dict) else "[]"
    raise TypeError(f"unexpected leaf type {type(v).__name__}")


def seg(k):
    # a key containing a tab or newline would break the line format; escape both
    return k.replace("\\", "\\\\").replace("\t", "\\t").replace("\n", "\\n")


def leaves(obj, path=""):
    """Yield (path, value) depth-first in insertion order."""
    if isinstance(obj, dict) and obj:
        for k, v in obj.items():
            yield from leaves(v, f"{path}.{seg(k)}" if path else seg(k))
    elif isinstance(obj, list) and obj:
        for i, v in enumerate(obj):
            yield from leaves(v, f"{path}[{i}]")
    else:
        yield path, obj


def relpath(p):
    p = p.resolve()
    try:
        return p.relative_to(ROOT).as_posix()
    except ValueError:
        return p.as_posix()


def flatten(json_path):
    raw = json_path.read_bytes()
    sha = hashlib.sha256(raw).hexdigest()
    data = json.loads(raw.decode("utf-8"))
    out = json_path.with_suffix(".numbers")
    lines = [f"# sha256 {sha}", f"# source {relpath(json_path)}"]
    n = 0
    for path, v in leaves(data):
        key = f"meta.{path}" if is_meta(path) else path
        lines.append(f"{key}\t{fmt(v)}")
        n += 1
    out.write_text("\n".join(lines) + "\n", encoding="utf-8")
    return out, n, sha


def check(numbers_path):
    """Return (ok, message). ok is False when the JSON's sha256 differs from line 1."""
    with numbers_path.open(encoding="utf-8") as fh:
        l1, l2 = fh.readline().rstrip("\n"), fh.readline().rstrip("\n")
    if not l1.startswith("# sha256 ") or not l2.startswith("# source "):
        return False, f"{numbers_path}: malformed header"
    recorded = l1[len("# sha256 "):].strip()
    src = numbers_path.with_suffix(".json")
    if not src.exists():
        src = ROOT / l2[len("# source "):].strip()
    if not src.exists():
        return False, f"{numbers_path}: source JSON not found ({src})"
    actual = hashlib.sha256(src.read_bytes()).hexdigest()
    if actual != recorded:
        return False, (f"MISMATCH  {numbers_path}\n  recorded {recorded}\n"
                       f"  actual   {actual}  ({relpath(src)})")
    return True, f"OK  {relpath(numbers_path)}  sha256 {actual[:12]}…  ({relpath(src)})"


def main(argv):
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("paths", nargs="+", help="results .json files (or .numbers with --check)")
    ap.add_argument("--check", action="store_true",
                    help="verify each .numbers file's line-1 sha256 against its JSON")
    a = ap.parse_args(argv)

    missing = [p for p in a.paths if not pathlib.Path(p).is_file()]
    if missing:
        for p in missing:
            print(f"no such file: {p}", file=sys.stderr)
        return 2

    failed = 0
    for p in a.paths:
        p = pathlib.Path(p)
        if a.check:
            ok, msg = check(p)
            print(msg)
            failed += not ok
        else:
            out, n, sha = flatten(p)
            print(f"{relpath(out)}  {n} leaves  sha256 {sha[:12]}…")
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
