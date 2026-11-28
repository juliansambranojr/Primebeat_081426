> Source: session transcript, 2026-11-27

The build was started on:

> ok, lets continue

Asked whether to add the capstone theorem that uses `piData25_of_26`, and whether to log a unit for the rows 24 and 25 build, Julian answered each:

> Yes

From `run/builds.py`, how a build line is read:

```
    ok = {m: int(s) for m, s in re.findall(r"^(\S+) ok (\d+)s$", t, re.M)}
```
