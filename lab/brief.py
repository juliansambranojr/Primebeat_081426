"""`lab brief <unit>` -- generate a brief block for an agent prompt.

PHASE 5 of `analysis/2026-09-02/lab_design.md`. The design's § The agent
interface says:

    "A brief carries keys and unit ids. A report carries a generated
     block. No digit crosses either boundary as a keystroke."

The brief is the first half: it gives an agent enough orientation to work
on or with a unit -- its identity, its chain position, the keys it can
ask for via `lab cite`, and the paths to its files -- without putting any
raw numeric values into the prompt. An agent that needs a number calls
`lab cite <unit> <key>` to get it.

THE BRIEF CARRIES KEYS, NOT VALUES. This is the design's load-bearing
constraint for the agent interface. An agent prompt is a keystroke
boundary, and a digit pasted across it is a digit that can be retyped
wrong, rounded, or truncated. The brief lists the key NAMES from
values.tsv so the agent knows what to ask for; the values stay in the
program.

Output is a fenced block (triple-backtick delimited) that an
orchestrator can paste directly into an agent prompt.

Exit codes:

    0   the brief was printed
    2   the unit could not be loaded
"""

import os

from .unit import UnitError, load, units_of

__all__ = ["generate_brief", "run"]


def _follows_chain(unit):
    """(follows, followed_by) for the unit's position in the chain."""
    follows = unit.front_matter.get("follows")
    # Look for units that follow this one
    followed_by = []
    try:
        known = units_of(unit.path.parent)
    except Exception:
        known = {}
    for uid, path in sorted(known.items()):
        if uid == str(unit.id):
            continue
        md = path / "unit.md"
        if not md.is_file():
            continue
        try:
            from .unit import split_front_matter, parse_front_matter
            fm_text, _ = split_front_matter(
                md.read_text(encoding="utf-8"))
            fm = parse_front_matter(fm_text)
            if fm.get("follows") == str(unit.id):
                followed_by.append(uid)
        except Exception:
            continue
    return follows, followed_by


def _agents_lines(unit):
    """Render the agents list from front matter."""
    agents = unit.front_matter.get("agents")
    if not agents:
        return []
    lines = []
    if isinstance(agents, list) and agents:
        if isinstance(agents[0], dict):
            # Block sequence form (0309+)
            for agent in agents:
                aid = agent.get("id", "?")
                role = agent.get("role", "?")
                block = agent.get("block", "")
                parts = [f"id={aid}", f"role={role}"]
                if block:
                    parts.append(f"block={block}")
                lines.append("  " + ", ".join(parts))
        elif isinstance(agents[0], str):
            # Flow list form (0308 sealed format: id:role:block)
            for entry in agents:
                lines.append(f"  {entry}")
    return lines


def _unit_files(unit):
    """List the files present in the unit directory."""
    files = []
    path = unit.path
    for name in sorted(os.listdir(path)):
        full = path / name
        if full.is_file():
            files.append(name)
        elif full.is_dir():
            files.append(f"{name}/")
    return files


def generate_brief(unit_arg, cwd=None):
    """Generate the brief block. Returns the fenced text.

    Raises `UnitError` if the unit cannot be loaded.
    """
    unit = load(unit_arg, cwd=cwd)
    fm = unit.front_matter

    sealed_str = "sealed" if fm.get("sealed") is True else "unsealed"
    follows, followed_by = _follows_chain(unit)

    lines = ["```"]
    lines.append(f"[{unit.id}] {fm.get('title', '')}")
    lines.append(f"  type: {fm.get('type', '?')}  "
                 f"date: {fm.get('date', '?')}  "
                 f"status: {sealed_str}")
    lines.append("")

    # Chain position
    chain_parts = []
    if follows:
        chain_parts.append(f"follows: {follows}")
    if followed_by:
        chain_parts.append(f"followed by: {', '.join(followed_by)}")
    if chain_parts:
        lines.append("  " + "  |  ".join(chain_parts))
        lines.append("")

    # Refs
    refs = fm.get("refs", [])
    if refs:
        lines.append(f"  refs: {', '.join(str(r) for r in refs)}")
        lines.append("")

    # Agents
    agent_lines = _agents_lines(unit)
    if agent_lines:
        lines.append("  agents:")
        lines.extend(agent_lines)
        lines.append("")

    # Keys (names only -- no values cross this boundary)
    keys = sorted(unit.values.keys())
    if keys:
        lines.append(f"  values.tsv keys ({len(keys)}):")
        for k in keys:
            lines.append(f"    {k}")
        lines.append("")
        lines.append("  Use `lab cite " + str(unit.id) + " <key>` "
                     "to retrieve a value.")
        lines.append("")

    # Files
    files = _unit_files(unit)
    if files:
        lines.append("  files:")
        for f in files:
            lines.append(f"    {f}")
        lines.append("")

    # Unit path
    lines.append(f"  path: {unit.path}")

    lines.append("```")
    return "\n".join(lines)


def run(unit_arg, out, err, cwd=None):
    """`lab brief <unit>`: 0 printed, 2 no such unit."""
    try:
        text = generate_brief(unit_arg, cwd=cwd)
    except UnitError as exc:
        print(f"lab brief: {exc}", file=err)
        return 2
    print(text, file=out)
    return 0
