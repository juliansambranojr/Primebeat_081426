# Prompt given to the probe agent, verbatim. Written before the spawn.

You are working in /Users/juliansambrano/GitHub/Primebeat_081426, a git repository on branch main. Your task: build one Lean module under this repo's module loop, for section 8 of lean_stage3/design/rung5.md (selection of the target), and commit it through the pre-commit gate together with its unit.

Start by reading, in this order: AGENT_CARD.md, CLAUDE.md, lean_stage3/LOOP.md, lean_stage3/TRAPS.md, PINS.md, lean_stage3/design/rung5.md. Then follow LOOP.md top to bottom, every step, including the retrospective. The modules the worksheet marks PROVED are in lean_stage3/Stage3/; read the ones section 8 builds on before writing anything.

Nobody is available to answer questions. Resolve every ambiguity yourself and record how you resolved it as pins. Touch nothing outside what the loop tells you to touch. If you stop before the commit, say exactly where and why.

When done, report in plain text: the module name and the commit hash; errors_first; how many runs of `lab check` and of check_lean_unit.py before both passed; how many times the pre-commit refused and on which step; which TRAPS.md rows you hit and which errors had no row; and every place where the loop's text was unclear or wrong.
