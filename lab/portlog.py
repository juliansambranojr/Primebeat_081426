"""`lab port-log` — record what a porting session taught.

After porting scripts into units, run this to update `units/PORTING.md`.
Each flag targets the section it belongs in:

    --gotcha   adds a bullet to Known gotchas
    --data     adds a row to Data file locations
    --grep     adds a line to the grep block
    --note     adds a bullet to a dated log entry

The positional argument is the log entry heading, e.g. "units 0035-0046
(O37-O47)".  If omitted, only the section-targeted flags are applied.

The file learns from every agent that ports a unit, so the next agent
has a longer checklist and a shorter debugging session.
"""

import datetime
import pathlib
import re

from .unit import units_root

__all__ = ["run"]

PORTING = "PORTING.md"

# Section headings we append into.
_GOTCHA_HEADING = "## Known gotchas"
_DATA_HEADING = "## Data file locations"
_GREP_HEADING = "## After copying, before patching"
_LOG_HEADING = "## Log"


def _find_porting(cwd=None):
    root = units_root(cwd)
    if root is None:
        return None
    return pathlib.Path(root) / PORTING


def _read(path):
    return path.read_text(encoding="utf-8")


def _write(path, text):
    path.write_text(text, encoding="utf-8")


def _section_span(text, heading):
    """Return (start, end) of the section body under `heading`.

    `start` is the character after the heading line's newline.
    `end` is the position just before the next `## ` heading, or the end
    of the file.  Returns None if the heading is missing.
    """
    idx = text.find(heading)
    if idx == -1:
        return None
    body_start = idx + len(heading)
    rest = text[body_start:]
    next_h = re.search(r"\n## ", rest)
    body_end = body_start + next_h.start() if next_h else len(text)
    return body_start, body_end


def _append_gotcha(text, gotcha):
    bullet = f"- {gotcha}"
    span = _section_span(text, _GOTCHA_HEADING)
    if span is None:
        return text + f"\n{_GOTCHA_HEADING}\n\n{bullet}\n"
    _, end = span
    section = text[span[0]:end]
    hr = section.rfind("\n---")
    if hr != -1:
        insert_at = span[0] + hr
    else:
        insert_at = end
    return text[:insert_at].rstrip("\n") + "\n\n" + bullet + "\n" + text[insert_at:]


def _append_data_row(text, name, path_str):
    row = f"| {name} | `{path_str}` |"
    span = _section_span(text, _DATA_HEADING)
    if span is None:
        table = (f"\n{_DATA_HEADING}\n\n"
                 f"| File | Path from unit run/ dir |\n"
                 f"|------|------------------------|\n"
                 f"{row}\n")
        return text + table
    section = text[span[0]:span[1]]
    last_pipe = section.rfind("\n|")
    if last_pipe == -1:
        insert_at = span[1]
        return text[:insert_at].rstrip("\n") + "\n" + row + "\n" + text[insert_at:]
    abs_pos = span[0] + last_pipe
    line_end = text.find("\n", abs_pos + 1)
    if line_end == -1:
        return text + "\n" + row + "\n"
    return text[:line_end + 1] + row + "\n" + text[line_end + 1:]


def _append_grep(text, pattern):
    span = _section_span(text, _GREP_HEADING)
    if span is None:
        return text + f"\n{_GREP_HEADING}\n\n```bash\n{pattern}\n```\n"
    section = text[span[0]:span[1]]
    last_fence = section.rfind("\n```\n")
    if last_fence == -1:
        last_fence = section.rfind("\n```")
    if last_fence == -1:
        insert_at = span[1]
        return (text[:insert_at].rstrip("\n") + "\n\n"
                + f"```bash\n{pattern}\n```\n" + text[insert_at:])
    abs_pos = span[0] + last_fence
    return text[:abs_pos] + "\n" + pattern + text[abs_pos:]


def _append_log_entry(text, heading_line, notes):
    idx = text.find(_LOG_HEADING)
    if idx == -1:
        text = text.rstrip("\n") + f"\n\n{_LOG_HEADING}\n"
        idx = text.find(_LOG_HEADING)
    entry = f"\n### {heading_line}\n"
    for note in notes:
        entry += f"- {note}\n"
    rest = text[idx + len(_LOG_HEADING):]
    insert_at = idx + len(_LOG_HEADING) + len(rest)
    return text[:insert_at].rstrip("\n") + "\n" + entry


def run(out, err, cwd=None, heading=None, gotchas=None, data_entries=None,
        greps=None, notes=None):
    """`lab port-log`: 0 updated, 1 nothing to do, 2 no PORTING.md."""
    path = _find_porting(cwd)
    if path is None or not path.is_file():
        print("lab port-log: no units/PORTING.md found at or above the "
              "working directory", file=err)
        return 2

    gotchas = gotchas or []
    data_entries = data_entries or []
    greps = greps or []
    notes = notes or []

    if not gotchas and not data_entries and not greps and not heading:
        print("lab port-log: nothing to record. Use --gotcha, --data, "
              "--grep, or give a heading for a log entry.", file=err)
        return 1

    text = _read(path)
    changed = False

    for gotcha in gotchas:
        text = _append_gotcha(text, gotcha)
        print(f"GOTCHA     {gotcha[:70]}", file=out)
        changed = True

    for name, rel_path in data_entries:
        text = _append_data_row(text, name, rel_path)
        print(f"DATA       {name} -> {rel_path}", file=out)
        changed = True

    for grep in greps:
        text = _append_grep(text, grep)
        print(f"GREP       {grep[:70]}", file=out)
        changed = True

    if heading:
        today = datetime.date.today().isoformat()
        heading_line = f"{today} — {heading}"
        text = _append_log_entry(text, heading_line, notes)
        print(f"LOG        {heading_line}", file=out)
        for note in notes:
            print(f"           - {note[:70]}", file=out)
        changed = True

    if changed:
        _write(path, text)
        print(f"{path}: updated", file=out)
        return 0
    return 1
