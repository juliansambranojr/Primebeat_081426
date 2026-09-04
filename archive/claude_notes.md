# claude_notes — the notebook agent

## Role

Read `/Users/juliansambrano/GitHub/AGENT_CLAUDE.md` first — that is your role.
Then `notes/notes_format.md`.

You append. You never transition a status or stamp an outcome — those are
Julian's. Appending the wrong thing is recoverable; flipping `[open]` to
`[closed]` is not.

## Sequence

```
1. Read notes/notes_format.md            → verify: you can name the seven types
2. grep '^## .*Entry' the newest volume  → verify: you have the real highest N
3. Open every artifact you will cite     → verify: the path and number resolve
4. Write entry N+1, newest at top        → verify: one type, from the seven
5. Add one NOTEPAD line, [open]          → verify: it fits on one line
```

## Failure

**Index line carrying the entry.** `notes/NOTEPAD.md` has lines of 2964, 2536
and 2518 characters against a median of 132. The template says "terse one-line
description." A 3000-character line is the entry pasted into the index, and it
destroys the one thing the index is for — `grep '\[open\]'` becomes unreadable.

**Reading a fence as content.** Asked whether the notebook had entries, I
grepped `^## .*Entry`, took the first hit, and got
`## YYYY-MM-DD — Entry N — <title>` — the example inside the header's ```text
block. I reported the notebook as empty. It had eight entries.

**Work landing without an entry.** Nine commits on 2026-08-20 — 12 Lean
theorems, four papers, a checker. Newest entry is 52, dated 2026-08-19.

## Success

```bash
grep '^## .*Entry [0-9]' notes/lab_notebook_2.md | head -1   # skips the fence
```

Highest real N in two seconds. Then the entry carries the detail and the
NOTEPAD line carries one sentence pointing at it.

## Rules

- One type, from the seven. No fit → flag it and stop. Do not invent one.
- Numbering is continuous across volumes. Volume 1 is closed at 44.
- Every number in an entry names the artifact it came from.
- NOTEPAD line: `- [open]   YYYY-MM-DD  entry N: one sentence`.
- Never edit `CLAUDE.md`, `CONTEXT.md`, `REFERENCES.md`, or an existing entry.

## Return

The entry, the NOTEPAD line, and a list of every artifact you opened to write
them. Anything you could not resolve, say so instead of writing it.
