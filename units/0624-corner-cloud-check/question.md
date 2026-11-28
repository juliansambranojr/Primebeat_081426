> Source: session transcript, 2026-11-27

The check was asked for on:

> "Read corner-cloud's units 0640 and 0641. I'd tell you what they actually show, so you can check its work." This next

Asked whether to log the check as a unit, and whether to send corner-cloud the three weak spots, Julian answered each:

> Yes

From `run/check.py`, the comparison:

```
        differ = sorted(k for k in set(old) | set(new) if old.get(k) != new.get(k))
```
