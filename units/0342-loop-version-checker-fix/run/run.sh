#!/bin/sh
# The re-run paired with the fix: the old checker (as of 654150c) and the new
# one (ad7f80c) over every unit whose values.tsv carries a loop_version row.
# Output: compare.log beside this file.
R=$(cd "$(dirname "$0")" && pwd); cd "$R/../../.." || exit 1
git show 654150c:utilities/check_lean_unit.py > "$R/old_check_lean_unit.py"
for u in $(grep -l '^loop_version' units/*/values.tsv | cut -d/ -f2); do
  o=$(python3 "$R/old_check_lean_unit.py" "units/$u" 2>&1 | grep -c 'LOOP ')
  n=$(python3 utilities/check_lean_unit.py "units/$u" 2>&1 | grep -c 'LOOP ')
  r=$(python3 utilities/check_lean_unit.py "units/$u" >/dev/null 2>&1 && echo OK || echo REFUSED)
  printf '%s loop_version=%s old_LOOP_fail=%s new_LOOP_fail=%s new=%s\n' "$u" "$(grep '^loop_version' "units/$u/values.tsv" | cut -f2)" "$o" "$n" "$r"
done > "$R/compare.log"
grep -n '^version' lean_stage3/LOOP.md >> "$R/compare.log"
