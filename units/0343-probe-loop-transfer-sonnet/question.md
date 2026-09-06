> Source: session transcript, 2026-09-06 (this session), after unit 0342 was committed

> can we keep the fixes, and run the same loop on a sonnet agent? i want to see if the opus fixes really fixed it and how well our scaffold holds lesser agents

From `lean_stage3/design/rung5.md`, the section the agent is given:

```
## 8. Selection of the target — SKETCH
```

From `units/0340-probe-loop-transfer/unit.md`, the rule carried over:

```
Decision rule, fixed now. The loop transfers if `commit` is 1 with `restarts` 0 and `errors_first` at most 12. It transfers weakly if `commit` is 1 with a restart. It does not transfer if no commit lands; then the place the agent stopped is the loop's defect and goes into `TRAPS.md` or `LOOP.md` as the next edit.
```
