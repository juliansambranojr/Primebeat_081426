"""Where this analysis writes, resolved from this file's own location.

The scripts here were copied out of a session scratchpad and wrote their
figures back to that scratchpad's absolute path, so every run had to be
migrated by hand afterwards.  Outputs now land beside the scripts, in
``figures/`` and ``results/`` inside the repository, and nothing needs
migrating again.

Every path below is derived from ``__file__`` rather than from the working
directory, so a script can be run from anywhere.  This follows the house
``_HERE`` convention used by the O-series scripts at the repository root
(see ``O43_extended_zero_census.py``, ``O45_sub_integer_base_scan.py``).
"""

import atexit
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent      # .../2026-08-19_table_structure/scripts
ROOT = HERE.parent                          # .../2026-08-19_table_structure
FIGURES = ROOT / "figures"
RESULTS = ROOT / "results"
REPO = ROOT.parent.parent                   # .../Primebeat_081426

FIGURES.mkdir(parents=True, exist_ok=True)
RESULTS.mkdir(parents=True, exist_ok=True)


class _Tee:
    """Write-through to two streams.  A tee, not a redirect."""

    def __init__(self, stream, handle):
        self._stream = stream
        self._handle = handle

    def write(self, text):
        self._stream.write(text)
        self._handle.write(text)
        return len(text)

    def flush(self):
        self._stream.flush()
        self._handle.flush()

    def isatty(self):
        return self._stream.isatty()


def tee(script_file):
    """Mirror this script's stdout into RESULTS/<script stem>.txt.

    The terminal still gets everything; the file is a copy, not a
    redirect.  Returns the path written.

    Idempotent within a process: if a tee is already installed the call is
    a no-op, so the entry script owns the results file.  Without this, a
    script that imports another tee'd script stacks two handles and both
    files end up holding the union of the two outputs.
    """
    if isinstance(sys.stdout, _Tee):
        return None
    path = RESULTS / (Path(script_file).stem + ".txt")
    handle = open(path, "w", encoding="utf-8")
    original = sys.stdout
    sys.stdout = _Tee(original, handle)

    def _restore():
        sys.stdout = original
        handle.flush()
        handle.close()

    atexit.register(_restore)
    return path
