#!/usr/bin/env python3
"""Check that question.md prose traces to a source and write the receipt.

    python3 utilities/check_prose_source.py units/0007-alpha-depth-trend
    python3 utilities/check_prose_source.py --all

For each unit's question.md, extracts key phrases and searches session
JSONL transcripts, lab notebook, CONTEXT.md, files (2)/, and preregs.
Writes a sources.log into the unit directory with every phrase and the
file:line where it was found. That file is the evidence — commit it.

Surface 2 of the three-surface check.
Exit 0 all found, 1 some missing, 2 error.
"""
import bisect
import json
import pathlib
import re
import sys
from datetime import datetime, timezone

ROOT = pathlib.Path(__file__).resolve().parent.parent
BENCH = pathlib.Path.home() / "GitHub" / "Primebeat_081426"
TRANSCRIPTS = pathlib.Path.home() / ".claude" / "projects"

SESSION_DIRS = [
    TRANSCRIPTS / "-Users-juliansambrano-GitHub-Primebeat-081426",
    TRANSCRIPTS / "-Users-juliansambrano-GitHub-primebeat-program",
]

SOURCE_DOCS = [
    BENCH / "notes" / "lab_notebook.md",
    BENCH / "notes" / "lab_notebook_2.md",
    BENCH / "CONTEXT.md",
    BENCH / "notes" / "NOTEPAD.md",
]


def normalize(text):
    for find, repl in [
        ("‘", "'"), ("’", "'"),
        ("“", '"'), ("”", '"'),
        ("–", "-"), ("—", "-"),
        ("−", "-"),
    ]:
        text = text.replace(find, repl)
    text = re.sub(r"[ \t]+", " ", text)
    return text


class Source:
    """A named, searchable source document."""

    def __init__(self, name, text):
        self.name = name
        self.text = normalize(text)
        self._offsets = []
        offset = 0
        for line in text.splitlines(keepends=True):
            self._offsets.append(offset)
            offset += len(normalize(line))

    def find(self, phrase):
        """Return line number (1-based) if phrase is in text, else None."""
        idx = self.text.find(phrase)
        if idx == -1:
            return None
        line_idx = bisect.bisect_right(self._offsets, idx) - 1
        return line_idx + 1


def load_jsonl_as_source(jsonl_path):
    texts = []
    with open(jsonl_path) as f:
        for line in f:
            try:
                d = json.loads(line)
            except json.JSONDecodeError:
                continue
            if d.get("type") not in ("user", "assistant"):
                continue
            msg = d.get("message", {})
            content = msg.get("content", "")
            if isinstance(content, str):
                texts.append(content)
            elif isinstance(content, list):
                for block in content:
                    if not isinstance(block, dict):
                        continue
                    if block.get("type") == "text":
                        texts.append(block["text"])
                    elif block.get("type") == "tool_use":
                        inp = block.get("input", {})
                        if "content" in inp:
                            texts.append(inp["content"])
                        if "new_string" in inp:
                            texts.append(inp["new_string"])
                        if "command" in inp:
                            texts.append(inp["command"])
                    elif block.get("type") == "tool_result":
                        c = block.get("content", "")
                        if isinstance(c, str):
                            texts.append(c)
                        elif isinstance(c, list):
                            for x in c:
                                if isinstance(x, dict) and x.get("type") == "text":
                                    texts.append(x["text"])
    return "\n".join(texts)


def load_sources():
    """Load all source documents as Source objects."""
    if hasattr(load_sources, "_cache"):
        return load_sources._cache

    sources = []

    # Original documents first — so matches attribute to the source,
    # not to the session where the question.md was composed.
    for doc in SOURCE_DOCS:
        if doc.exists():
            rel = doc.relative_to(BENCH)
            sources.append(Source(str(rel), doc.read_text()))

    files2 = BENCH / "files (2)"
    if files2.exists():
        for f in sorted(files2.glob("*.txt")):
            sources.append(Source(f"files (2)/{f.name}", f.read_text()))

    preregs = BENCH / "preregs"
    if preregs.exists():
        for f in sorted(preregs.glob("*.md")):
            sources.append(Source(f"preregs/{f.name}", f.read_text()))

    # Script docstrings — read the .py files themselves
    for py in sorted(BENCH.glob("O*.py")) + sorted(BENCH.glob("[0-9]*.py")):
        sources.append(Source(f"scripts/{py.name}", py.read_text()))

    # Results JSONs
    results_dir = BENCH / "results"
    if results_dir.exists():
        for f in sorted(results_dir.glob("*.json")):
            sources.append(Source(f"results/{f.name}", f.read_text()))
        for f in sorted(results_dir.glob("*.log")):
            sources.append(Source(f"results/{f.name}", f.read_text()))

    # Session transcripts last — fallback for prose composed in chat
    for session_dir in SESSION_DIRS:
        if not session_dir.exists():
            continue
        for jsonl in sorted(session_dir.glob("*.jsonl")):
            text = load_jsonl_as_source(jsonl)
            if text:
                sources.append(Source(f"session/{jsonl.name}", text))
        for sub_dir in sorted(session_dir.glob("*/subagents")):
            for jsonl in sorted(sub_dir.glob("*.jsonl")):
                text = load_jsonl_as_source(jsonl)
                if text:
                    sources.append(Source(
                        f"session/{sub_dir.parent.name}/subagents/{jsonl.name}",
                        text))

    load_sources._cache = sources
    return sources


def extract_phrases(question_md):
    text = question_md.read_text()
    phrases = []

    for line in text.splitlines():
        line = line.strip()
        if line.startswith(">"):
            content = line.lstrip("> ").strip()
            if len(content) > 20:
                phrases.append(content)

    in_fence = False
    for line in text.splitlines():
        if line.strip().startswith("```"):
            in_fence = not in_fence
            continue
        if in_fence and len(line.strip()) > 30:
            phrases.append(line.strip())

    return phrases


def search_phrase(phrase, sources):
    """Search for phrase across all sources. Return (source_name, line) or None."""
    normalized = normalize(" ".join(phrase.split()))

    for src in sources:
        line = src.find(normalized)
        if line is not None:
            return src.name, line

    prefix = normalized[:40]
    for src in sources:
        line = src.find(prefix)
        if line is not None:
            return src.name, line

    return None


def check_unit(unit_dir, sources, write_log=True):
    name = unit_dir.name
    qmd = unit_dir / "question.md"

    if not qmd.exists():
        return name, [], [], "no question.md"

    phrases = extract_phrases(qmd)
    if not phrases:
        return name, [], [], "no searchable phrases in question.md"

    found = []
    missing = []

    for phrase in phrases:
        result = search_phrase(phrase, sources)
        if result:
            found.append((phrase, result[0], result[1]))
        else:
            missing.append(phrase)

    if write_log:
        log_path = unit_dir / "sources.log"
        with open(log_path, "w") as f:
            ts = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
            f.write(f"# check_prose_source.py  {ts}\n")
            f.write(f"# unit: {name}\n")
            f.write(f"# sources searched: {len(sources)}\n\n")
            for phrase, src_name, src_line in found:
                trunc = phrase[:100] + "..." if len(phrase) > 100 else phrase
                f.write(f"FOUND  {src_name}:{src_line}\n")
                f.write(f"  {trunc}\n\n")
            for phrase in missing:
                trunc = phrase[:100] + "..." if len(phrase) > 100 else phrase
                f.write(f"MISSING\n")
                f.write(f"  {trunc}\n\n")
            f.write(f"# {len(found)} found, {len(missing)} missing\n")

    return name, found, missing, None


def main():
    if len(sys.argv) < 2:
        print("usage: check_prose_source.py <unit-dir> | --all",
              file=sys.stderr)
        return 2

    if sys.argv[1] == "--all":
        units_dir = ROOT / "units"
        dirs = sorted(d for d in units_dir.iterdir()
                      if d.is_dir() and re.match(r"\d{4}-", d.name))
    else:
        dirs = [pathlib.Path(sys.argv[1]).resolve()]

    print("Loading sources...", file=sys.stderr)
    sources = load_sources()
    total_chars = sum(len(s.text) for s in sources)
    print(f"  {len(sources)} sources, {total_chars:,} chars", file=sys.stderr)

    any_missing = False

    for unit_dir in dirs:
        name, found, missing, err = check_unit(unit_dir, sources)

        if err:
            print(f"{name}: {err}")
        elif missing:
            any_missing = True
            print(f"{name}: {len(found)} found, {len(missing)} MISSING "
                  f"-> {unit_dir / 'sources.log'}")
        else:
            print(f"{name}: {len(found)} traced -> {unit_dir / 'sources.log'}")

    return 1 if any_missing else 0


if __name__ == "__main__":
    sys.exit(main())
