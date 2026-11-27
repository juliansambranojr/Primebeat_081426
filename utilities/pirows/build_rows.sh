#!/bin/bash
# Build rows of the pi list in the kernel, one module at a time (a row-24 block reached about 13 GB in one
# process; lake run on a whole row builds blocks in parallel and runs out of memory).
# Usage, from the repo root:  utilities/pirows/build_rows.sh 24 25
# Reads utilities/pirows/modsN.txt (the build order written by splitrow.py) for each row N, then CensusN.
# Modules already built pass through in seconds. Logs go to utilities/pirows/logs/.
set -u
D=$(cd "$(dirname "$0")" && pwd)
mkdir -p "$D/logs"
cd "$D/../../lean"
T0=$(date +%s)
for R in "$@"; do
  for m in $(cat "$D/mods$R.txt") "Census$R"; do
    t=$(date +%s)
    timeout 3000 lake build "$m" > "$D/logs/$m.log" 2>&1
    e=$?
    if [ $e -ne 0 ]; then echo "$m FAIL $e (exit 137 = out of memory)"; grep -E "^error" "$D/logs/$m.log" | head -5; exit 1; fi
    echo "$m ok $(( $(date +%s) - t ))s"
  done
done
echo "rows $* built in $(( $(date +%s) - T0 ))s"
