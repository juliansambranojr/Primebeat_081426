> Source: session transcript, 2026-11-27

Asked whether to start the RH axioms check:

> yes

Asked which light work to take on while the builds run:

> this

The choice was: "Log a unit for the RH axioms check. That's the cached run from today. I'd add the source-build result to it when that finishes."

From `run/rhaxioms.py`, the docstring:

```
The Lean proof of RH on the Mac: its axioms, and whether its statement is the one the weld names.

Usage: python3 -I rhaxioms.py <clone of leanprover-community/riemann-hypothesis> <Primebeat repo root>

The clone's .olean files came from the repository's prebuilt cache. Printing axioms reads those files; the
kernel did not re-check the proofs from source on this machine in this run. With a third argument, a second
clone built from source with only Mathlib's cache, it also reads that build's log, source_build.log.
```
