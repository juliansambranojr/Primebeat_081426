"""Parse a lab_run log into numbered sections for citation verification.

A section is a stretch of log text under a header. The parser handles
every header style the scripts currently produce:

  --- replicate_1.1:  ratio 1.1 ...          (triple-dash subject)
  === O17_ladder:  x0 = 1000 ...             (triple-equals subject)
  1. GEOMETRY                                (numbered)
  A. functional equation ...                 (letter)
  CHECK 1 — INTEGRITY: ...                   (CHECK N)
  ==============================             (boxed: separator, title,
  1. EXTENT AND EXACT ZEROS                   separator)
  ==============================

The parser assigns sequential numbers: §1, §2, §3, ... regardless of
the log's own numbering. Everything before the first header is §0
(preamble). Same log, same numbers every time.

`lab check --sections <unit>` prints the map so an agent writing
citations knows what §1 means for that unit.
"""

import re

__all__ = ["Section", "parse", "load"]


class Section:
    """One section of a log: its number, title, and text."""

    def __init__(self, number, title, lines):
        self.number = number
        self.title = title
        self.lines = lines

    @property
    def text(self):
        return "\n".join(self.lines)

    def __repr__(self):
        return f"<§{self.number} {self.title!r} ({len(self.lines)} lines)>"


# Header patterns, tested in order. Each returns (title,) or None.
_DASH_HEADER = re.compile(r"^---\s+(.+?)\s*$")
_EQUALS_HEADER = re.compile(r"^===\s+(.+?)\s*$")
_NUMBERED = re.compile(r"^(\d+)\.\s+(.+)$")
_LETTERED = re.compile(r"^([A-Z])\.\s+(.+)$")
_CHECK = re.compile(r"^CHECK\s+\d+\s*[—–-]\s*(.+)$", re.UNICODE)
_DECISION = re.compile(r"^(DECISION RULE\b.*)$")
_SEPARATOR = re.compile(r"^([=\-])\1{9,}\s*$")


def _header_title(line):
    """If `line` is a section header, return its title. Otherwise None."""
    for pat in (_DASH_HEADER, _EQUALS_HEADER, _NUMBERED, _LETTERED,
                _CHECK, _DECISION):
        m = pat.match(line)
        if m:
            return m.group(m.lastindex).strip()
    return None


def parse(text):
    """Parse log text into a list of Section objects.

    §0 is the preamble (everything before the first header).
    §1, §2, ... are the sections in order.
    """
    lines = text.split("\n")
    breaks = []  # (line_index, title)

    # Pass 1: find boxed headers (separator / title / separator).
    boxed = set()
    i = 0
    while i < len(lines) - 2:
        if _SEPARATOR.match(lines[i]):
            candidate = lines[i + 1].strip()
            if candidate and i + 2 < len(lines) and _SEPARATOR.match(lines[i + 2]):
                boxed.add(i + 1)
                breaks.append((i, candidate))
                i += 3
                continue
        i += 1

    # Pass 2: find inline headers (not inside a boxed block).
    for i, line in enumerate(lines):
        if i in boxed:
            continue
        title = _header_title(line)
        if title is not None:
            breaks.append((i, title))

    breaks.sort(key=lambda b: b[0])

    if not breaks:
        return [Section(0, "(preamble)", lines)]

    sections = []
    # §0: preamble
    if breaks[0][0] > 0:
        sections.append(Section(0, "(preamble)", lines[:breaks[0][0]]))

    for j, (start, title) in enumerate(breaks):
        end = breaks[j + 1][0] if j + 1 < len(breaks) else len(lines)
        sections.append(Section(j + 1, title, lines[start:end]))

    return sections


def load(log_path):
    """Parse a log file into sections."""
    import pathlib
    p = pathlib.Path(log_path)
    return parse(p.read_text(encoding="utf-8"))
