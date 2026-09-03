"""`lab chain` — walk the follows: chain, compute segments, report findings.

Phase 4 of `analysis/2026-09-02/lab_design.md`.  The design's § Segments and
the chain says:

    "Units group into bounded segments -- an index file per N units.  Each
     segment declares two states:

         inherits: <digest of the previous segment's handoff>
         handoff:  <digest computed from this segment's units>

     Segment B follows A when B's `inherits` equals A's `handoff`."

The design's § The naming is deterministic makes the label a pure function of
the tree:

    "the root segment holds the lowest unit id and is A;
     at any fork the line continues through the child with the lower first
     unit id, and the others become branches;
     segments along a line take the next label in spreadsheet order;
     branches off a segment are ordered by their own first unit id and take
     the dotted labels in that order."

STANDARD LIBRARY ONLY.  No dependency beyond what the lab package already
uses.  The ordering key is the unit id, which is immutable and only increases;
nothing depends on timestamps, file order or directory-listing order.

WHAT A SEGMENT IS.  A bounded group of consecutive units in one line of
the chain.  Each segment carries a label (a cache, recomputed by this
module), an inherits digest (the previous segment's handoff, or None for the
first segment in a line), and a handoff digest (sha256 over its sorted unit
ids).  `lab chain` recomputes all of these from the unit tree and compares
them against the on-disk CHAIN.tsv; a disagreement is a finding.

WHAT CHAIN.tsv IS.  A generated file at the project root, one line per
segment, holding label, unit ids, inherits and handoff.  `lab chain`
regenerates it on every run, exactly as `lab index` regenerates INDEX.md.
Running it twice produces byte-identical output.
"""

import hashlib
from collections import defaultdict

from .unit import (
    FrontMatterError,
    UnitError,
    parse_front_matter,
    split_front_matter,
    units_of,
    units_root,
)

__all__ = [
    "CHAIN_FILE",
    "SEGMENT_SIZE",
    "spreadsheet_label",
    "handoff_digest",
    "build_forest",
    "compute_segments",
    "render_chain",
    "parse_chain",
    "chain",
    "run",
]

SEGMENT_SIZE = 25
CHAIN_FILE = "CHAIN.tsv"


# ---------------------------------------------------------------------------
# Label arithmetic
# ---------------------------------------------------------------------------

def spreadsheet_label(n):
    """0-based index to spreadsheet-column label: 0->A, 25->Z, 26->AA, ...

    Bijective base-26: the mapping from non-negative integers to the sequence
    A, B, ..., Z, AA, AB, ..., AZ, BA, ..., ZZ, AAA, ...  A main-line label
    never contains a dot; branches use a dot, and dot count is depth.
    """
    if n < 0:
        raise ValueError(f"label index must be non-negative, got {n}")
    result = []
    k = n + 1  # convert to 1-based
    while k > 0:
        k -= 1
        result.append(chr(ord("A") + k % 26))
        k //= 26
    return "".join(reversed(result))


# ---------------------------------------------------------------------------
# Digests
# ---------------------------------------------------------------------------

def handoff_digest(unit_ids):
    """sha256 hex digest over a segment's sorted unit ids.

    The content is the sorted unit ids joined by newlines with a trailing
    newline, encoded as UTF-8.  Sorting by id ensures the digest does not
    depend on insertion order.
    """
    content = "\n".join(sorted(unit_ids)) + "\n"
    return hashlib.sha256(content.encode("utf-8")).hexdigest()


# ---------------------------------------------------------------------------
# Forest construction
# ---------------------------------------------------------------------------

def read_follows(root):
    """Read the follows: field from every unit directory under `root`.

    Returns (follows_map, known) where:
      follows_map: {uid: follows_value_or_None}
      known: set of all unit ids found under root
    """
    known_map = units_of(root)
    known = set(known_map)
    follows_map = {}
    for uid, path in known_map.items():
        md = path / "unit.md"
        if not md.is_file():
            follows_map[uid] = None
            continue
        try:
            fm_text, _ = split_front_matter(md.read_text(encoding="utf-8"))
            front = parse_front_matter(fm_text)
        except (FrontMatterError, OSError, UnicodeDecodeError):
            follows_map[uid] = None
            continue
        val = front.get("follows")
        follows_map[uid] = val if isinstance(val, str) else None
    return follows_map, known


def build_forest(follows_map, known):
    """Build the forest structure from follows: relationships.

    Returns (children, roots, gaps, forks, unchained):
      children:  {parent_uid: [child_uids]} sorted by child uid
      roots:     sorted list of root uids (not a child of anything in known)
      gaps:      [(uid, follows_value)] -- follows something not in known
      forks:     [(parent_uid, [child_uids])] -- parent has 2+ children
      unchained: sorted list of uids with no follows: field
    """
    children = defaultdict(list)
    gaps = []
    unchained = []

    for uid in sorted(follows_map):
        follows_val = follows_map[uid]
        if follows_val is None:
            unchained.append(uid)
            continue
        if follows_val not in known:
            gaps.append((uid, follows_val))
        else:
            children[follows_val].append(uid)

    for parent in children:
        children[parent].sort()

    all_children_set = set()
    for kids in children.values():
        all_children_set.update(kids)

    roots = sorted(uid for uid in follows_map if uid not in all_children_set)
    forks = sorted(
        (parent, kids[:])
        for parent, kids in children.items()
        if len(kids) > 1
    )
    return dict(children), roots, gaps, forks, unchained


# ---------------------------------------------------------------------------
# Line tracing
# ---------------------------------------------------------------------------

def _trace_line(start, children):
    """Trace one line from `start`, always following the lowest-id child.

    Returns (line, branch_points) where:
      line:          [uid, ...] in chain order
      branch_points: [(fork_uid, branch_start_uid), ...]
    """
    line = []
    branch_points = []
    current = start
    visited = set()
    while current is not None and current not in visited:
        visited.add(current)
        line.append(current)
        kids = children.get(current, [])
        if not kids:
            break
        continuation = kids[0]
        for branch_uid in kids[1:]:
            branch_points.append((current, branch_uid))
        current = continuation
    return line, branch_points


def _trace_tree(start, children):
    """Recursively trace a tree from `start`.

    Returns (line, [(fork_uid, subtree), ...]) where subtree has the same
    shape.  Branches are sorted by their first unit id.
    """
    line, branch_points = _trace_line(start, children)
    branches = []
    for fork_uid, branch_start in branch_points:
        subtree = _trace_tree(branch_start, children)
        branches.append((fork_uid, subtree))
    # Sort branches by the branch's first unit id.
    branches.sort(key=lambda fb: fb[1][0][0])
    return (line, branches)


# ---------------------------------------------------------------------------
# Segmentation and labelling
# ---------------------------------------------------------------------------

def compute_segments(follows_map, known, segment_size=SEGMENT_SIZE):
    """Compute all segments with deterministic labels.

    Returns (segments, gaps, forks, unchained) where:
      segments:  [{'label', 'unit_ids', 'inherits', 'handoff'}, ...]
                 in label order (main line first, then branches depth-first)
      gaps:      [(uid, follows_value)]
      forks:     [(parent_uid, [child_uids])]
      unchained: [uid]
    """
    children, roots, gaps, forks, unchained = build_forest(
        follows_map, known
    )

    # Trace every root into a tree structure.
    root_trees = [_trace_tree(root, children) for root in roots]
    root_trees.sort(key=lambda t: t[0][0])  # sort by first unit id

    all_segments = []

    def _process(tree, prefix, counter):
        """Cut one tree into labelled segments.  Returns next counter."""
        line, branches = tree
        if not line:
            return counter

        # Cut the line into segments of at most segment_size units.
        line_segs = []
        prev_handoff = None
        for i in range(0, len(line), segment_size):
            chunk = line[i : i + segment_size]
            label = (
                prefix + "." + spreadsheet_label(counter)
                if prefix
                else spreadsheet_label(counter)
            )
            counter += 1
            hoff = handoff_digest(chunk)
            seg = {
                "label": label,
                "unit_ids": chunk,
                "inherits": prev_handoff,
                "handoff": hoff,
            }
            line_segs.append(seg)
            all_segments.append(seg)
            prev_handoff = hoff

        # Map each unit id to the label of the segment it belongs to.
        uid_to_label = {}
        for seg in line_segs:
            for uid in seg["unit_ids"]:
                uid_to_label[uid] = seg["label"]

        # Group branches by the segment their fork point belongs to.
        by_seg = defaultdict(list)
        for fork_uid, subtree in branches:
            seg_label = uid_to_label.get(fork_uid, "")
            by_seg[seg_label].append(subtree)

        for seg_label in sorted(by_seg):
            sub_counter = 0
            for subtree in by_seg[seg_label]:
                sub_counter = _process(subtree, seg_label, sub_counter)

        return counter

    counter = 0
    for tree in root_trees:
        counter = _process(tree, "", counter)

    return all_segments, gaps, forks, unchained


# ---------------------------------------------------------------------------
# CHAIN.tsv rendering and parsing
# ---------------------------------------------------------------------------

def render_chain(segments, gaps, forks, unchained):
    """Render the chain data as text for CHAIN.tsv.

    Running twice with the same segments produces byte-identical output.
    """
    chain_count = sum(len(s["unit_ids"]) for s in segments)
    lines = [
        "# CHAIN.tsv -- GENERATED by `lab chain` from units/. Do not edit.",
        f"# {len(segments)} segment(s), {chain_count} unit(s) in chain, "
        f"{len(unchained)} with no follows: field, "
        f"{len(gaps)} gap(s), {len(forks)} fork(s).",
        "# label\tunits\tinherits\thandoff",
    ]
    for seg in segments:
        units_str = ",".join(seg["unit_ids"])
        inh = seg["inherits"] if seg["inherits"] else "-"
        lines.append(
            f"{seg['label']}\t{units_str}\t{inh}\t{seg['handoff']}"
        )
    return "\n".join(lines) + "\n"


def parse_chain(text):
    """Parse CHAIN.tsv into a list of segment dicts.

    Inverse of `render_chain` for the data lines.  Comment lines and blank
    lines are skipped.
    """
    segments = []
    for line in text.split("\n"):
        if not line.strip() or line.startswith("#"):
            continue
        parts = line.split("\t")
        if len(parts) != 4:
            continue
        label, units_str, inh, hoff = parts
        segments.append({
            "label": label,
            "unit_ids": units_str.split(",") if units_str else [],
            "inherits": None if inh == "-" else inh,
            "handoff": hoff,
        })
    return segments


# ---------------------------------------------------------------------------
# Disagreement detection
# ---------------------------------------------------------------------------

def _check_disagreements(computed, on_disk):
    """Compare computed segments against on-disk CHAIN.tsv segments.

    Returns a list of finding strings.  Three classes:

      LABEL   — same units, different label (the cache disagrees)
      NEW     — a segment in the computed tree has no match on disk
      MISSING — a segment on disk has no match in the computed tree
    """
    findings = []
    computed_by_key = {}
    for seg in computed:
        key = tuple(sorted(seg["unit_ids"]))
        computed_by_key[key] = seg

    disk_by_key = {}
    for seg in on_disk:
        key = tuple(sorted(seg["unit_ids"]))
        disk_by_key[key] = seg

    for key, comp in computed_by_key.items():
        if key in disk_by_key:
            disk = disk_by_key[key]
            if comp["label"] != disk["label"]:
                findings.append(
                    f"LABEL      segment [{','.join(comp['unit_ids'])}]: "
                    f"computed {comp['label']!r}, "
                    f"on disk {disk['label']!r}"
                )
        else:
            findings.append(
                f"NEW        segment {comp['label']} "
                f"[{','.join(comp['unit_ids'])}] not in CHAIN.tsv"
            )

    for key, disk in disk_by_key.items():
        if key not in computed_by_key:
            findings.append(
                f"MISSING    segment {disk['label']} "
                f"[{','.join(disk['unit_ids'])}] in CHAIN.tsv "
                f"but not in computed chain"
            )

    return findings


# ---------------------------------------------------------------------------
# Public API
# ---------------------------------------------------------------------------

def chain(cwd=None, segment_size=SEGMENT_SIZE):
    """Walk the chain, compute segments, return results.

    Returns (segments, gaps, forks, unchained) or raises UnitError.
    """
    root = units_root(cwd=cwd)
    if root is None:
        raise UnitError(
            "no units/ directory at or above the working directory"
        )
    follows_map, known = read_follows(root)
    if not follows_map:
        return [], [], [], []
    return compute_segments(follows_map, known, segment_size=segment_size)


def run(out, err, cwd=None, segment_size=SEGMENT_SIZE):
    """`lab chain`: 0 clean, 1 findings, 2 no units/.

    Walks the chain, computes segments with deterministic labels, and
    generates CHAIN.tsv at the project root.  If CHAIN.tsv already exists
    it is compared against the recomputed state before being overwritten;
    a label disagreement, a missing segment or an extra segment is a finding
    (exit 1).  Gaps and forks are reported for information but do not affect
    the exit code.
    """
    try:
        segments, gaps, forks, unchained = chain(
            cwd=cwd, segment_size=segment_size
        )
    except UnitError as exc:
        print(f"lab chain: {exc}", file=err)
        return 2

    root = units_root(cwd=cwd)
    project_root = root.parent
    chain_path = project_root / CHAIN_FILE

    findings = 0

    # Compare against existing CHAIN.tsv before overwriting.
    if chain_path.is_file():
        on_disk = parse_chain(
            chain_path.read_text(encoding="utf-8")
        )
        for finding in _check_disagreements(segments, on_disk):
            print(finding, file=out)
            findings += 1

    # Regenerate CHAIN.tsv.
    chain_path.write_text(
        render_chain(segments, gaps, forks, unchained),
        encoding="utf-8",
    )

    # Report gaps (informational).
    for uid, follows_val in gaps:
        print(
            f"GAP        {uid} follows {follows_val}, "
            f"which is not a unit",
            file=out,
        )

    # Report forks (informational).
    for parent, kids in forks:
        print(
            f"FORK       {parent} has {len(kids)} followers: "
            f"{', '.join(kids)}",
            file=out,
        )

    # Report unchained units (informational).
    if unchained:
        print(
            f"UNCHAINED  {len(unchained)} unit(s) with no follows: field: "
            f"{', '.join(unchained)}",
            file=out,
        )

    # Report segments.
    for seg in segments:
        inh = (
            seg["inherits"][:12] + "..."
            if seg["inherits"]
            else "(root)"
        )
        hoff = seg["handoff"][:12] + "..."
        ids = ", ".join(seg["unit_ids"])
        print(
            f"SEGMENT    {seg['label']:<8} [{ids}]  "
            f"inherits={inh}  handoff={hoff}",
            file=out,
        )

    # Summary.
    chain_count = sum(len(s["unit_ids"]) for s in segments)
    print(
        f"chain: {len(segments)} segment(s), {chain_count} unit(s), "
        f"{len(unchained)} with no follows: field, "
        f"{len(gaps)} gap(s), {len(forks)} fork(s); "
        f"CHAIN.tsv regenerated",
        file=out,
    )

    return 1 if findings else 0
