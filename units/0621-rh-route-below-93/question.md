> Source: session transcript, 2026-11-27, and `notes/2026-11-27-handoff-teleport-questions.md`

The question, as asked of the cloud session in the questions file:

> **3. Does the RH route reach below row 93?** The handoff says the π list cannot be built to row 92 in the kernel.

Its answer computed the route constants outside a unit. Asked whether to log them as a unit:

> Yes to log

From `run/below93.py`, the docstring:

```
How far the RH route reaches below row 93, if its floor is moved down.

Usage: python3 -I below93.py

A cell (r, d) is reached when some floor 2^k with 4 <= k <= (r - d - 1) / 2 has routeU(k) <= need(d, r).
Only floor 2^38 is a proved theorem (`RouteSharp.weakWindow13_of_RH`); every other floor is the formula's
value, never stated in Lean.
```
