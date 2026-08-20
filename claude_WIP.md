# claude_WIP — structure, in progress

Paper format: `papers/FORMAT.md` · Paper agent: `claude_writer.md`

## Rule — load, don't recall

**Stable and global: trust the prior. Local and mutable: open the file.**

How a PDF is structured has not changed in twenty years — recall it. Anything
in this repo could have changed this afternoon — open it. Both feel identical
while generating. That is why the split cannot be a judgment call.

**Failure.** Each of these felt certain, read correctly, and was wrong:

```text
"the claim is at § B4"          that section is unnumbered — no B4 exists
"the output is in results/"     it is two directories away
"that helper is in utils.py"    it was renamed last week
```

Nothing signals the error. A generated reference and a recalled one are the
same experience from the inside.

**Success.** One command before writing the reference:

```text
grep -n '^#' doc.md      ls the directory      grep -rn 'name' .
```

If it does not resolve, ask. Do not write the nearest plausible thing.

- Never write a reference you have not opened in this session.
- A path in context is not a path you read.
- After a compaction, every remembered specific is suspect. The summary keeps
  the filename; the section letter gets regenerated.

**Gate:** `python3 utilities/check_refs.py` exits 0.

**Test:** could this reference have been different last week? Then open it.

## Rule — offer the log

**Deciding what is worth logging is Julian's. Asking is not optional.**

After any run, result, insight, or scope change: ask whether to log it. One
line. If yes, an entry is staged from the transcript window plus a NOTEPAD
line; if no, move on. (The extractor is PENDING — designed, not built.)

**Failure.** `t22`, `t23`, `t24` all ran on 2026-08-20 and produced three
papers. Zero notebook entries, zero NOTEPAD lines, and I never once asked. The
dated record that those scripts ran does not exist.

**Success.** "That's a result — log it?" Then it is his call, and either answer
is fine. The only wrong outcome is not asking.

**Test:** did something happen that a later reader would want dated? Then ask.

