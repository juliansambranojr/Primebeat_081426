# pirows — rows of the π list built in the Lean kernel

π(2^R) by Legendre's formula, π(x) + 1 = φ(x, primes ≤ √x) + π(√x), with φ peeled into one term per prime
(`lean/Legendre.lean`). Each term is checked by one `decide +kernel` in its own file; no `native_decide`.

1. `python3 utilities/pirows/genleg.py R 6` (run in `lean/`): writes `PiW{R}.lean` (the terms' values as a
   table), `PiL{R}_*.lean` (blocks of six terms) and `PiRow{R}.lean` (the assembly, `pi{R}` and `piData_le{R}`).
2. `python3 utilities/pirows/splitrow.py R` (run in `lean/`): splits every block into one-term files, adds the
   recursion limit the assembly needs, registers the modules in `lakefile.toml`, and writes `modsR.txt`
   here, the build order.
3. `utilities/pirows/build_rows.sh R` (from the repo root): builds them one at a time, then `CensusR`.

Rows 24 and 25 are generated and split (`mods24.txt`, `mods25.txt`); their build was in progress when these
scripts were committed. Row 24's single blocks reached about 13 GB in one process; build one module at a time.
`pins.py` reads each theorem's `#guard_msgs` axiom pin from the tree and runs `utilities/check_weld.py`.
