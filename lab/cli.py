"""`lab` — the command line entrypoint.

PHASE 0 of `analysis/2026-09-02/lab_design.md` shipped one subcommand,
`lab check`. PHASE 1 adds the rest of the unit's lifecycle: `lab new`,
`lab values` and `lab seal`. PHASE 2b adds `lab run`, which is the verb that
closes the window in which a result exists only in a sentence. PHASE 3 adds
`lab index`, which generates INDEX.md and INDEX-values.tsv. The design's
§ The CLI lists eight; `lab chain` and `lab cite` belong to later phases and
are not stubbed here, so that `lab --help` never advertises something that
does not run.

Exit codes are uniform across every subcommand:

    0   clean
    1   the check found something, or the command refused
    2   usage, or a unit that cannot be loaded
"""

import argparse
import sys

from . import __version__, check as check_mod, index as index_mod
from . import new as new_mod
from . import run as run_mod, seal as seal_mod, values as values_mod

PROGRAM = """\
lab keeps a tree of sealed units honest.

A unit is one directory per notebook entry -- the authored prose, the
question it answered, the code and results as produced, and a generated
values.tsv holding every number the run measured. Nothing outside a unit
is evidence for anything inside it.

The invariant lab enforces: every number in a unit's prose appears in
that unit's own values.tsv. Scoping the pool to one unit is what makes
the check mean anything; a number checked against the whole tree matches
almost by accident.
"""

CHECK = """\
Read a unit's prose and confirm every number in it has evidence.

Each number in units/<unit>/unit.md is looked up in units/<unit>/values.tsv
and must appear there at the precision the prose states -- prose saying
0.0184 is satisfied by a file holding 0.018401, and prose saying 0.03 is
not. Fenced blocks and tables are read like any other prose, because a
number in a table is still a claim.

Numbers that are addresses rather than measurements are exempt, by the list
in lab/exempt.py: dates, unit ids and paths, entry references, refs and
supersedes, sha256 and other hex runs, versions, file citations of the shape
name.ext:NN, list markers and enumerators, digits welded to an identifier,
and backticked keys and paths. A bare integer with no decimal point is still
checked -- lab/exempt.py records that decision and what it costs.

Two findings are not about the pool. A count spelled in words -- `four runs`
where `4 runs` would resolve to a key -- is reported with its digit form, by
the closed noun list in lab/counts.py. A `follows:` that names no unit, or
that names the unit's own id, is reported too; walking the field is a later
phase.

Findings print one per line, located by the bold lead-in they sit under,
followed by one summary line. Nothing cites a line number, here or
anywhere else in the container.

<unit> may be a path (units/0305-fixed-window-Lc), a name under the
nearest units/ directory (0305-fixed-window-Lc), or an unambiguous
prefix of one (0305).
"""

NEW = """\
Scaffold a unit directory under the nearest units/ directory.

The id is the next one free, read off the existing unit directory names --
the directory is what is scanned rather than INDEX.md. The unit is
written with the design's front matter, a body of bold lead-ins to fill in,
an empty question.md for the transcript bracket, an empty run/, and an
empty values.tsv carrying only its header lines.

What it writes loads and passes `lab check` as it stands: no numbers in the
prose and no evidence needed. Drop the run into run/, write the prose, then
`lab values` and `lab check`.
"""

RUN = """\
Execute a unit's runnable and record what produced its artifacts.

A unit declares what to run by holding run/run.sh, which is invoked as
`/bin/sh run.sh` with the working directory set to run/. There is no
fallback: a unit without one is refused by name, because an implicit rule
is one a reader has to already know.

Stdout and stderr are streamed to the terminal and captured, interleaved,
into run/lab_run.<NNN>.log. Beside it goes run/lab_run.<NNN>.json, holding
the exact invocation, the exit code, the wall time, the runnable's sha256,
the interpreter and shell versions, the OS, and the git HEAD and dirty flag
at the moment it ran. The index is the lowest for which neither file exists,
so a second run never overwrites the first.

The record is written BEFORE the run, carrying the invocation and
`status: started`, and completed afterwards with the exit code, the wall
time and the environment. So a unit's run count is a directory listing at
any moment, during a run included, and a run that never finished leaves a
record saying so rather than leaving nothing.

That record is a result file like any other, so `lab values` folds it into
values.tsv and a prose claim about the run has evidence to point at. Every
other field in it is written in a shape the exemption list treats as an
address, so provenance never becomes evidence for a measurement.

On success values.tsv is regenerated. On failure it is left exactly as it
was -- a half-written result must not reach the evidence pool -- and the
log and the record are still written, so the failure is diagnosable. A
sealed unit is refused: a re-run is a new unit that supersedes it.
"""

VALUES = """\
Regenerate a unit's values.tsv from every .json under its run/.

Each result file's keys are prefixed with that file's stem, so two result
files in one unit cannot collide. Values keep each JSON's own order, timing
and provenance leaves take a `meta.` prefix, and nothing else is written --
running it twice gives a byte-identical file.

A result file that will not parse is reported on stderr, recorded in the
generated file as a `# skipped` line, and the command exits 1.
"""

SEAL = """\
Write a unit's UNIT.sha256 and flip its front matter to sealed: true.

The manifest carries one sha256 per file and a digest over those lines,
with values.tsv entering the digest by its stable content -- header lines
and meta. keys removed -- so the declared volatile keys are excluded from
it. From then on `lab check` rehashes the unit and reports any file that
moved.

Sealing is refused for a unit that does not pass `lab check`, and refused
for a unit that is already sealed: a changed result is a new unit that
supersedes the old one.
"""

INDEX = """\
Regenerate INDEX.md and INDEX-values.tsv at the project root.

INDEX.md is the generated inventory of every unit: units by type, artifact
counts, sealed/unsealed status. Authored files lose their count slots and
point at INDEX.md instead.

INDEX-values.tsv is the reverse map: one line per key, listing every unit
whose prose cites the value stored under that key. It costs nothing extra
to build: `lab check` already resolves every number in every unit to a key,
so the reverse map is the same pass written out.

Both files are generated, so neither can drift from the units. Running the
command twice produces byte-identical files.
"""

INDEX_EXIT = """\
exit codes:
  0  INDEX.md and INDEX-values.tsv regenerated
  2  no units/ directory at or above here
"""

EXIT = """\
exit codes:
  0  every number in the prose has evidence
  1  at least one number does not
  2  bad usage, or a unit that could not be loaded
"""

SEAL_EXIT = """\
exit codes:
  0  sealed
  1  refused: the unit does not check clean, or it is already sealed
  2  bad usage, or a unit that could not be loaded
"""

VALUES_EXIT = """\
exit codes:
  0  values.tsv regenerated from every result file in run/
  1  regenerated, with at least one result file skipped
  2  bad usage, or no such unit
"""

RUN_EXIT = """\
exit codes:
  0  the runnable exited 0 and values.tsv was regenerated
  1  refused (sealed, or no run/run.sh), or the runnable exited non-zero,
     or a result file could not be parsed. The runnable's own exit code is
     recorded in run/lab_run.<NNN>.json rather than propagated.
  2  bad usage, a unit that could not be loaded, or a path that is not a
     unit at all -- nothing outside a unit is ever executed
"""

NEW_EXIT = """\
exit codes:
  0  the unit was scaffolded
  1  refused: that directory already exists
  2  bad usage, or no units/ directory at or above here
"""


def build_parser():
    parser = argparse.ArgumentParser(
        prog="lab",
        description=PROGRAM,
        epilog=EXIT,
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    parser.add_argument("--version", action="version",
                        version=f"lab {__version__}")
    subs = parser.add_subparsers(dest="command", metavar="<command>")

    sub = subs.add_parser(
        "check",
        help="confirm every number in a unit's prose is in its values.tsv",
        description=CHECK,
        epilog=EXIT,
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    sub.add_argument("unit", metavar="<unit>",
                     help="unit directory, name, or unambiguous id prefix")

    sub = subs.add_parser(
        "new",
        help="scaffold a unit directory under units/",
        description=NEW,
        epilog=NEW_EXIT,
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    sub.add_argument("slug", metavar="<slug>",
                     help="the unit's name after its id, e.g. fixed-window-Lc")
    sub.add_argument("--type", dest="type_", default="run",
                     help="front matter `type:` (default: run)")
    sub.add_argument("--title", default=None,
                     help="front matter `title:` (default: the slug)")

    sub = subs.add_parser(
        "run",
        help="execute the unit's run/run.sh and record what produced it",
        description=RUN,
        epilog=RUN_EXIT,
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    sub.add_argument("unit", metavar="<unit>",
                     help="unit directory, name, or unambiguous id prefix")

    sub = subs.add_parser(
        "values",
        help="regenerate a unit's values.tsv from its run/",
        description=VALUES,
        epilog=VALUES_EXIT,
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    sub.add_argument("unit", metavar="<unit>",
                     help="unit directory, name, or unambiguous id prefix")

    sub = subs.add_parser(
        "seal",
        help="write UNIT.sha256 and flip the unit to sealed: true",
        description=SEAL,
        epilog=SEAL_EXIT,
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    sub.add_argument("unit", metavar="<unit>",
                     help="unit directory, name, or unambiguous id prefix")

    sub = subs.add_parser(
        "index",
        help="regenerate INDEX.md and INDEX-values.tsv",
        description=INDEX,
        epilog=INDEX_EXIT,
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    sub.add_argument("--cwd", default=None,
                     help="project root or directory at or above units/ "
                          "(default: current directory)")
    return parser


def main(argv=None):
    parser = build_parser()
    args = parser.parse_args(sys.argv[1:] if argv is None else argv)
    if args.command is None:
        parser.print_help(sys.stderr)
        return 2
    if args.command == "check":
        return check_mod.run(args.unit, sys.stdout, sys.stderr)
    if args.command == "new":
        return new_mod.run(args.slug, sys.stdout, sys.stderr,
                           type_=args.type_, title=args.title)
    if args.command == "run":
        return run_mod.run(args.unit, sys.stdout, sys.stderr)
    if args.command == "values":
        return values_mod.run(args.unit, sys.stdout, sys.stderr)
    if args.command == "seal":
        return seal_mod.run(args.unit, sys.stdout, sys.stderr)
    if args.command == "index":
        return index_mod.run(sys.stdout, sys.stderr, cwd=args.cwd)
    parser.error(f"unknown command {args.command!r}")     # unreachable
    return 2


if __name__ == "__main__":
    sys.exit(main())
