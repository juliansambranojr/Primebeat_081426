"""`lab values <unit>` — regenerate `values.tsv` from the unit's `run/`.

PHASE 1 of `analysis/2026-09-02/lab_design.md`. The design's § The unit
makes `values.tsv` a GENERATED file, "key<TAB>value, one line per leaf",
and § The invariant makes it the entire pool a unit's prose is checked
against. So this command owns the pool, and nothing hand-edits it.

WHAT MAKES THE POOL UNAMBIGUOUS. Every key is prefixed with its source
file's stem under `run/`. Two result files in one unit therefore cannot
collide: `ladder.json` and `census.json` both holding `rows` become
`ladder.rows` and `census.rows`, two lines, two values. Without the prefix
one file would silently overwrite the other's leaf and a wrong number would
have evidence. For a file in a subdirectory the prefix is its whole
run-relative path with `.json` removed (`sub/ladder`), which is the same
rule and stays unambiguous a level down.

IDEMPOTENT. The output depends only on the bytes under `run/`: the file
list is sorted by path, keys keep each JSON's own insertion order, and no
timestamp or absolute path is written. Running the command twice produces a
byte-identical file, and running it on a freshly scaffolded unit reproduces
exactly the header `lab new` wrote.

FILES IT CANNOT PARSE ARE REPORTED AND SKIPPED. A skip is written into the
generated file as a `# skipped` line and printed on stderr, and the command
exits 1. A skipped file never disappears quietly.

THE FLATTENER IS COPIED, NOT IMPORTED. `META_TOKENS`, `META_SUBSTR`,
`is_meta`, `fmt`, `seg` and `leaves` below are a verbatim copy from
`utilities/flatten_results.py`, which already flattens a results JSON to
`key<TAB>value` with a `meta.` prefix on the volatile fields. Copied for
the reason Phase 0 copied the rounding comparison into `lab/check.py`:
`lab` installs with `pip install -e .` and runs from any working directory,
while `utilities/` is a directory of scripts rather than a package and
resolves its own repo paths at import (`ROOT` on its line 40), so it is not
on the installed program's import path and importing it would tie the
console script to one checkout. When the two drift, this file is the one
the units answer to.

DECISIONS taken here where the design is silent:

  - The header is three fixed comment lines, then one `# source` line per
    result file carrying that file's sha256, then one `# skipped` line per
    file that would not parse. `lab.unit.read_values` already ignores `#`
    lines, so the header costs the pool nothing.
  - `lab new` writes the zero-source header, which is what this command
    produces for an empty `run/`. An empty values file is a real, loadable
    values file: a unit whose prose states no numbers is clean against it.
  - The source sha256 lines are of the JSON bytes as produced, matching
    `utilities/flatten_results.py`'s line-1 header, so a values.tsv can be
    checked back against the results it came from. They are volatile by the
    same argument as the `meta.` keys, and `lab/digest.py` strips `#` lines
    out of the digest for exactly that reason.
  - Only `*.json` under `run/` is a source. Logs are evidence a reader
    reads; they are not a pool of citable leaves, and the design's
    values.tsv is "one line per leaf" of a results JSON.
"""

import hashlib
import json
import pathlib
import re

from .unit import UnitError, locate

__all__ = ["render", "write", "run", "EMPTY", "is_meta", "leaves"]

# --- copied verbatim from utilities/flatten_results.py ----------------------
# See the module docstring for why this is a copy rather than an import.
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
# --- end of copy ------------------------------------------------------------

HEADER = [
    "# values.tsv -- GENERATED by `lab values` from run/. Do not edit it: edit",
    "# run/ and regenerate. Every key carries its source file's stem, so two",
    "# result files in one unit cannot collide.",
]


def _sources(run_dir):
    """Every `*.json` under run/, sorted by run-relative POSIX path."""
    if not run_dir.is_dir():
        return []
    out = [p for p in run_dir.rglob("*.json") if p.is_file()]
    return sorted(out, key=lambda p: p.relative_to(run_dir).as_posix())


def _prefix(run_dir, path):
    """The key prefix for one source: its run-relative path, `.json` dropped."""
    rel = path.relative_to(run_dir).as_posix()
    return rel[:-len(".json")]


def render(unit_path):
    """(text of values.tsv, [skip messages]) for a unit as it stands."""
    unit_path = pathlib.Path(unit_path)
    run_dir = unit_path / "run"
    sources, body, skipped = _sources(run_dir), [], []
    head = list(HEADER)
    for path in sources:
        rel = f"run/{path.relative_to(run_dir).as_posix()}"
        try:
            raw = path.read_bytes()
            data = json.loads(raw.decode("utf-8"))
            lines = []
            for key, value in leaves(data):
                full = f"{_prefix(run_dir, path)}.{key}" if key \
                    else _prefix(run_dir, path)
                lines.append(f"{'meta.' + full if is_meta(full) else full}"
                             f"\t{fmt(value)}")
        except (ValueError, TypeError, OSError) as exc:
            reason = f"{type(exc).__name__}: {exc}"
            skipped.append(f"{rel} -- {reason}")
            head.append(f"# skipped {rel} -- {reason}")
            continue
        head.append(f"# source {rel} sha256 "
                    f"{hashlib.sha256(raw).hexdigest()}")
        body += lines
    if not sources:
        head.append("# source (none)")
    return "".join(line + "\n" for line in head + body), skipped


EMPTY = "".join(line + "\n" for line in HEADER + ["# source (none)"])


def write(unit_path):
    """Regenerate `values.tsv`. Returns (path, key count, [skips])."""
    text, skipped = render(unit_path)
    out = pathlib.Path(unit_path) / "values.tsv"
    out.write_text(text, encoding="utf-8")
    keys = sum(1 for line in text.split("\n") if line and not line.startswith("#"))
    return out, keys, skipped


def run(arg, out, err, cwd=None):
    """`lab values <unit>`: 0 clean, 1 something was skipped, 2 no such unit."""
    try:
        path = locate(arg, cwd=cwd)
    except UnitError as exc:
        print(f"lab values: {exc}", file=err)
        return 2
    if not (path / "unit.md").is_file():
        print(f"lab values: {path}: no unit.md", file=err)
        return 2
    tsv, keys, skipped = write(path)
    for message in skipped:
        print(f"SKIPPED    {message}", file=err)
    sources = len(_sources(path / "run"))
    print(f"{tsv}: {keys} key(s) from {sources - len(skipped)} of "
          f"{sources} result file(s) in run/", file=out)
    return 1 if skipped else 0
