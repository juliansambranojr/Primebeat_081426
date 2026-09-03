"""`lab` — the command line entrypoint.

PHASE 0 of `analysis/2026-09-02/lab_design.md` ships one subcommand,
`lab check`. The design's § The CLI lists eight; the other seven belong to
later phases and are not stubbed here, so that `lab --help` never advertises
something that does not run.

Exit codes are uniform across every subcommand:

    0   clean
    1   the check found something
    2   usage, or a unit that cannot be loaded
"""

import argparse
import sys

from . import __version__, check as check_mod

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

Three kinds of number are exempt, because they are not measurements:
dates, the unit's own id, and the ids of units it names in refs or
supersedes.

Findings print one per line, located by the bold lead-in they sit under,
followed by one summary line. Nothing cites a line number, here or
anywhere else in the container.

<unit> may be a path (units/0305-fixed-window-Lc), a name under the
nearest units/ directory (0305-fixed-window-Lc), or an unambiguous
prefix of one (0305).
"""

EXIT = """\
exit codes:
  0  every number in the prose has evidence
  1  at least one number does not
  2  bad usage, or a unit that could not be loaded
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
    return parser


def main(argv=None):
    parser = build_parser()
    args = parser.parse_args(sys.argv[1:] if argv is None else argv)
    if args.command is None:
        parser.print_help(sys.stderr)
        return 2
    if args.command == "check":
        return check_mod.run(args.unit, sys.stdout, sys.stderr)
    parser.error(f"unknown command {args.command!r}")     # unreachable
    return 2


if __name__ == "__main__":
    sys.exit(main())
