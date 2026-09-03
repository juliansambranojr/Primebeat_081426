"""`lab report <unit>` -- generate a report block from a unit.

PHASE 5 of `analysis/2026-09-02/lab_design.md`. The design's § The agent
interface says:

    "A brief carries keys and unit ids. A report carries a generated
     block. No digit crosses either boundary as a keystroke."

The report is the second half: a structured summary an orchestrator
quotes into chat after a phase completes. It carries the unit's identity,
gate results from its run records, a values summary, its agents, and its
refs. The block is tagged with the unit id (e.g. `[0308]`) so it is
greppable in chat.

THE REPORT IS A GENERATED BLOCK. Its contents come from the unit's own
files and from `lab check`'s output. It is not authored prose; it is what
the program produces from the unit's state, and a reader can reproduce it
by running `lab report <unit>`.

Exit codes:

    0   the report was printed
    2   the unit could not be loaded
"""

import io
import json
import pathlib

from .unit import UnitError, load
from . import check as check_mod

__all__ = ["generate_report", "run"]


def _run_records(unit):
    """Load lab_run.*.json records from the unit's run/ directory.

    Returns a list of (filename, parsed dict), sorted by filename,
    so the last entry is the most recent run.
    """
    run_dir = unit.path / "run"
    if not run_dir.is_dir():
        return []
    records = []
    for path in sorted(run_dir.glob("lab_run.*.json")):
        try:
            data = json.loads(path.read_text(encoding="utf-8"))
            records.append((path.name, data))
        except (ValueError, OSError):
            continue
    return records


def _gate_lines(records):
    """Render gate results from run records."""
    if not records:
        return ["  (no run records)"]
    lines = []
    for name, data in records:
        exit_code = data.get("exit_code", "?")
        meta = data.get("meta", {})
        wall_s = meta.get("wall_s")
        status = data.get("status", "")
        parts = [f"{name}: exit {exit_code}"]
        if wall_s is not None:
            parts.append(f"{wall_s:.1f}s")
        if status:
            parts.append(f"status={status}")
        lines.append("  " + ", ".join(parts))
    return lines


def _agents_lines(unit):
    """Render the agents list."""
    agents = unit.front_matter.get("agents")
    if not agents:
        return []
    lines = []
    if isinstance(agents, list) and agents:
        if isinstance(agents[0], dict):
            for agent in agents:
                aid = agent.get("id", "?")
                role = agent.get("role", "?")
                lines.append(f"  {aid} ({role})")
        elif isinstance(agents[0], str):
            for entry in agents:
                lines.append(f"  {entry}")
    return lines


def _check_summary(unit):
    """Run lab check on the unit and return the summary line."""
    buf = io.StringIO()
    try:
        check_mod.check(str(unit.path), buf)
    except Exception:
        return None
    return buf.getvalue().strip()


def generate_report(unit_arg, cwd=None):
    """Generate the report block. Returns the tagged text.

    Raises `UnitError` if the unit cannot be loaded.
    """
    unit = load(unit_arg, cwd=cwd)
    fm = unit.front_matter

    lines = [f"[{unit.id}] {fm.get('title', '')}"]
    lines.append(f"  type: {fm.get('type', '?')}  "
                 f"date: {fm.get('date', '?')}")
    lines.append("")

    # Gate results
    records = _run_records(unit)
    lines.append("  gate:")
    lines.extend(_gate_lines(records))
    lines.append("")

    # Values summary
    key_count = len(unit.values)
    check_line = _check_summary(unit)
    lines.append(f"  values: {key_count} key(s)")
    if check_line:
        lines.append(f"  check: {check_line}")
    lines.append("")

    # Agents
    agent_lines = _agents_lines(unit)
    if agent_lines:
        lines.append("  agents:")
        lines.extend(agent_lines)
        lines.append("")

    # Refs
    refs = fm.get("refs", [])
    if refs:
        lines.append(f"  refs: {', '.join(str(r) for r in refs)}")

    return "\n".join(lines)


def run(unit_arg, out, err, cwd=None):
    """`lab report <unit>`: 0 printed, 2 no such unit."""
    try:
        text = generate_report(unit_arg, cwd=cwd)
    except UnitError as exc:
        print(f"lab report: {exc}", file=err)
        return 2
    print(text, file=out)
    return 0
