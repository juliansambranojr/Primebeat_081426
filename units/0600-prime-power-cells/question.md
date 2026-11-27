> Source: session transcript, 2026-11-27

> Hold the rows for now, log and then attack the zero

From `run/ppcells.py`, the test:

```
    h=sum(1 for r in cells if (A(r)+s*A(r-d))%p!=0)
```
