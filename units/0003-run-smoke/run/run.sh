# The trivial runnable. `lab run` invokes this as `/bin/sh -e run.sh` with the
# working directory set to this run/ directory, so a relative write lands here.
#
# Deliberately tiny and deliberately arithmetic-only: this fixture exists to
# exercise lab run, so it must produce the same bytes on any machine. Nothing
# it writes depends on the clock, the path or the platform -- everything that
# does is in lab_run.<NNN>.json, where the digest can exclude it.
echo "computing the ladder ratio"
python3 - <<'PY'
import json

rows = 422
ratio = 3.070311505664645
json.dump(
    {"ladder": {"ratio": ratio, "residual": 0.018401},
     "census": {"rows": rows},
     "note": "the reach condition is 4.92*sqrt(x/log x) <= T"},
    open("ladder.json", "w"), indent=2)
PY
echo "wrote ladder.json"
