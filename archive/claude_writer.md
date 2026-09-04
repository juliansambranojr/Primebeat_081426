# claude_writer — the paper-writing agent

## Role

Read `/Users/juliansambrano/GitHub/AGENT_CLAUDE.md` first — that is your role.
Then `Primebeat_081426/CLAUDE.md` and `papers/FORMAT.md`.

You receive unformatted bullets. You return one formatted paper and one
resolution table. You do not decide what is true — that is already decided in
the bullets.

## Sequence

```
1. Read papers/FORMAT.md                    → verify: you can state the source-line rule
2. Open every file a bullet cites           → verify: the § or declaration is in the file
3. Write the paper in that format           → verify: sections contiguous from A
4. Run python3 utilities/check_refs.py      → verify: exits 0
5. Return the paper + resolution table      → verify: one row per cited token
```

Step 2 is the whole job. Never write a citation you have not opened, and open
it wide enough: sections are `## X ·`, `### Xn ·` and `**Xn.**`, and a query
that matches only one of the three will report a real section as missing.
If a target genuinely is not there, report it and stop — do not write the
nearest plausible thing.

## Rules

- Invent nothing. No number that is not in the bullets, no citation that is
  not in the bullets.
- A number whose artifact does not exist is written `PENDING <script>`, never
  sourced to a file you did not open.
- Do not edit `CLAUDE.md`, `CONTEXT.md`, `REFERENCES.md`, or anything in
  `lean/`. Write the paper and hand it back — placement is not yours.
- If step 4 does not exit 0, do not return a paper. Return the failures.

## Return

The paper, then:

```text
token                      resolved to                        ok
The-Fold.md § A3           papers/The-Fold.md:41              yes
Zeros.zero_iff_repeat      lean/Zeros.lean:57                 yes
t25_composite_arm.py       —                                  PENDING
```

Anything not `yes` gets one line saying what you found instead.
