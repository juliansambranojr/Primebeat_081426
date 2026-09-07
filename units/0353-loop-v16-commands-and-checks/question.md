> Source: session transcript, 2026-09-07, after the report on unit 0352

> Is loop.md dense?

> But of the loop is forced then we don’t need 1800 lines

> Yes

From `utilities/check_lean_unit.py`, the checks added:

```
  SORRY    the module contains no `sorry`
  SCRATCH  lean_stage3/Stage3/Scratch.lean is not in the tree (LOOP.md § 2)
  RING     no bare `ring` on the line after a `field_simp` in the module
           (LOOP.md § 4; TRAPS.md row 1); units at loop_version 16 and up
  HEADER   the module's header comment, before its first `import`, names
           the block: the part of `design` after `#` (LOOP.md § 1); 16 and up
  PINS     PINS.md names the module or the block (LOOP.md § 0b); 16 and up
```
