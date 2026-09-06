#!/bin/sh
# EXPLORATORY -- no prereg, no verdict.  Three invocations, as run on 2026-09-06.
# Outputs land here, in the unit's run/; the script lives in analysis/2026-09-06/.
R=$(cd "$(dirname "$0")" && pwd)
cd "$R/../../../analysis/2026-09-06" || exit 1
python3 probe_window_m.py --sweep-h 6 --sweep-ms 1,2,3,4,6,8,12,16 --out "$R/probe_window_m.json" > "$R/full_h6.log" 2>&1
python3 probe_window_m.py --skip-pin --sweep-h 12 --sweep-ms 1,2,3,4,6,8,12,16,24 --out "$R/sweep_h12.json" > "$R/sweep_h12.log" 2>&1
python3 probe_window_m.py --skip-pin --sweep-h 24 --sweep-ms 1,2,4,8,16,32,64 --out "$R/sweep_h24.json" > "$R/sweep_h24.log" 2>&1
