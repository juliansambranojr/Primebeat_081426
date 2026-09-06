> Source: session transcript, 2026-09-06 (this session), after unit 0335 was reported

> Not yet, can you reflect on your process the tool calls sequence of calls or any other process you are doing implicitly without me knowing it. I only ask cause I se se you improved the loop, cause you have done it multiple time now with clearer and clear next steps. I want you to retain the little shifts so other obstacles inherit it and make it structural fit other instances that don’t have your massive intelligence. It’s like you create the template for them to live inside. If so how do we make it an iterative growth process that happens after every build. Similar to the karpathy loop but used on our loop

> Build it into the loop and name what you built changed acs modified in the chat after you are done. Then log it

CONTEXT.md: § Current state of the world (the Lean tree as of entry 170; this decision postdates it).

NOTEPAD: no line yet.

From `lean_stage3/LOOP.md`, the retrospective step:

```
- Classify each first-build error. A class with no row in `TRAPS.md` gets
  one: pattern, cause, fix.
- A step that was reordered, batched, or skipped without loss gets the
  checklist edited.
- Any recipe edit bumps `version:` above and is committed with the unit
  that caused it. The next units record the new `loop_version`.
- Keep an edit when `errors_first` and the minutes per module trend down
  over the following units; revert it when they do not. The evaluation is
  fixed: the build passes with the pin, both checkers pass, the counts
  match. The recipe is what moves.
```

From `utilities/check_lean_unit.py`, the checks:

```
  MODULE   every ref in unit.md names one lean_stage3 file; that file exists
  LINES    values.tsv module_lines == wc -l of the module
  THEOREMS values.tsv theorems_proved == count of lines starting 'theorem '
  DEFS     values.tsv defs == count of lines starting 'def '
  PIN      every ref name is declared in the module and has a
           '#print axioms <name>' line
  NEXT     unit.md has a paragraph beginning 'What the next slice' or
           'What remains'
  LOOP     values.tsv has loop_version equal to the 'version:' line of
           lean_stage3/LOOP.md
  BUILD    run/build.log exists and ends with 'Build completed successfully'
```
