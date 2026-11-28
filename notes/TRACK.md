# Track

What is running, what is done but not committed, what is next, and what we do not have. The Track pane
beside the chat draws this file. Any session may edit it: the Mac session in place, a cloud session by
committing and pushing it (the pane reads the Mac's copy, so a pushed edit shows after it is pulled).

Format: one `## ` heading per section, one `- ` line per item. An item may end with
`(progress: <file>, <regex>, <total>)`; the pane counts the lines of `<file>` that match `<regex>` and draws
a bar out of `<total>`.

## Running

- Mac: row 25 build, one module at a time, then PiRow25 and Census25 (progress: /private/tmp/claude-501/-Users-juliansambrano-GitHub-Primebeat-081426/7d67eb5d-2c2b-4b56-ae67-7289608347b2/scratchpad/build_row_25_c.out, ^PiL25\S* ok, 889)
- Mac: memory watch every 15 s, re-armed every 30 min; alerts under 8 GB free
- Cloud corner-cloud: open-corner exploration on branch claude/corner-cloud, units 0640-0659
- Mac: watcher on claude/corner-cloud, checks every 2 min for notes/corner-questions.md and pings this session
- Cloud corner-cloud: zeros6 (2001052 zeros) and the 3b answer pushed (73252ce)
- Cloud corner-cloud: Julian's answers pushed (8b7d047): follow up the edge excess; C parity run on rows 93+ in the cloud; 2-million-zero table; lead 1 does finite-row certificates
- Cloud old instance: duplicate rows 24-25 build in its container; safe to stop

## Done, not pushed

- Build logs in utilities/pirows/logs/: not committed; row 25's are still being written
- Unit 0622: the Lean proof of RH, its axioms seen on the Mac, from the prebuilt cache and from source (not committed; commit needs Julian's word)

## Next

- When row 25 builds: capstone narrowed to rows 26-92 via Census25.piData25_of_26
- Unit for the rows 24-25 build
- Commit and push (Julian's word)
- Merge claude/corner-cloud here (Julian's word)
- Restore the teleport stash; re-lock folders only if Julian asks

## We do not have

- The zero result for the whole table: rows 1-24 have no assumption; outside the open corner it needs RH and the π list on rows 25-92
- Exact π for the deep cells of rows 26-92: the kernel cannot reach rows near 92; the RH route reaches 362 of 3886 cells, at unproved floors (unit 0621)
- Any theorem in the open corner (depth >= 17, row >= 93, below both lines)
- A rebuild of Mathlib itself, or a second independent kernel, for the RH proof: the project built from source on the Mac (unit 0622), Mathlib came from its official cache
- TuringRun600: stopped by Julian, unverified, uncommitted; the reason is not on file
- Local main commit d7172ee: 4 mail files from 2026-10-12, not on GitHub; Julian decides
