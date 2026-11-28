# Corner questions for Julian — cloud session, branch `claude/corner-cloud`

Questions from the cloud corner exploration (units 0640, 0641; both exploratory, no outcome marked).
Write your answer on the `Answer:` line under each; the session pulls the branch to read them.

## 1. The edge excess of small cells

On the edge diagonals (row = depth + 1, + 8, + 32, depths to 420, past row 92) the model's cells
fall below a twentieth of their root-square size about twice as often as independent phases
predict; on the five rays they fall at the predicted rate (unit 0640). Follow it up — more edges,
deeper, and whether the excess holds as zeros are added — or leave it?

Answer: (Julian, 2026-11-27, relayed by the Mac session) "follow up"

## 2. The parity identity, run past row 92

π(x) mod 2 is exact through the sum of 2^ω(n), a divisor-sum count; it matched the π list on rows
2–46 and its time grows about 2^(m/2) (unit 0641). Row 93 extrapolates to weeks of numpy here (the
unit's timing, taken while another run shared the machine), less in C. Each row reached certifies the odd corner cells it completes, and no more: the corner past it is
still infinite. Worth a C implementation and a run on rows 93 onward, here or on the Mac?

Answer: (Julian, 2026-11-27, relayed by the Mac session) "yes and in the cloud, so we save ram here". Write the C version and run rows 93 onward in this cloud session.

## 3. Odlyzko's tables

This machine's network policy blocks his host, so lead 1 used the 100000 zeros already in
`imported/twin_count/zeros1.txt`. On the measurements in unit 0640 the conclusions did not move
between 30000 and 100000 zeros except the absolute-sum ratio, which grows without limit. Do you
want the host allowed for the two-million-zero table, or is 100000 enough for this lead?

Answer: (Julian, 2026-11-27, relayed by the Mac session) "yes to getting the 2-million-zero table". The cloud environment's network policy is his setting; the Mac session has asked him to allow the host. Until it is allowed, carry on with the 100000 zeros, and push a line here naming the exact host to allow.

## 3b. The table cannot be fetched from this machine

The exact host is www-users.cse.umn.edu. It is now on this environment's allowlist, but its TLS chain ends at
"emSign Root CA - G1", which is in none of this machine's trust stores (system, certifi, proxy
bundle), so the download is refused and the session will not turn verification off. Two ways on:
(a) download `zeros6` from Odlyzko's zeta_tables page on the Mac and commit it under `imported/`
(the session checks its first 100000 zeros against `imported/twin_count/zeros1.txt` before using
it); or (b) name another source of the same zeros, whose host the session then asks to allow.
Which?

Answer: (Julian, 2026-11-27, relayed by the Mac session) "a". Downloaded on the Mac from https://www-users.cse.umn.edu/~odlyzko/zeta_tables/zeros6 (no TLS error there) and committed at `imported/odlyzko/zeros6`: 36018936 bytes, 2001052 lines, sha256 2ef7b752c2f17405222e670a61098250c8e4e09047f823f41e2b41a7b378e7c6, uncompressed. The Mac compared its first 100000 zeros with `imported/twin_count/zeros1.txt`: max abs difference 0.0. Run your own check before using it.

## 4. Where lead 1 goes next

Unit 0640: the leader never outweighs the absolute sum of the rest at any cell, so a bound of the
form leader less everything else is out; in root-square size the leader is about the size of the
rest on every diagonal; the small cells come at the random rate; a truncated explicit formula needs
zeros far beyond any table, more with every depth. Which of these do you want next: finite-row
certificates (parity, more π rows) with the infinite remainder left as a measure statement, or a
structural idea of yours for the near-harmonic family that the measurements have not tried?

Answer: (Julian, 2026-11-27, relayed by the Mac session) "a for now, i have no idea yet". Finite-row certificates (parity, more π rows), with the infinite remainder left as a measure statement.

## 5. Log the edge follow-up and the C parity code?

Edge follow-up (answer to 1): twelve edges to depth 600 and two rays, 100000 zeros. Small cells on
the edges run about 1.3 times the independent-phase rate, the same factor at a fiftieth, a
twentieth and a tenth of the root-square size; the fifty largest terms (96.5% of the square) at
their own amplitudes do not explain it; the small cells come in runs of about three consecutive
cells, and counted by runs each edge is within about one standard deviation of chance; the factor
fades by the edge at depth plus 64. C parity (answer to 2): exact on every row 2–56 and the even
rows 58–66 against the π list (128-bit past row 63); two minutes at row 66 on four cores, doubling
every two rows. Log them as units 0642 (edges) and 0643 (C parity)?

Answer: (Julian, 2026-11-27, relayed by the Mac session) "Yes". Log them as units 0642 (edges) and 0643 (C parity).

## 6. Row 93's parity: how to get there

The C version, extrapolated, needs about sixteen days on this machine's four cores for row 93
alone, each row after 1.4 times more; a cloud session may be reclaimed before that ends. A faster
route exists on paper: the points floor(sqrt(x/v)) close up under floor(·/k), so a Mertens-style
recursion shares its values, and with a fast divisor sum the cost is about x^(3/7), roughly 10^12
steps at row 93 (hours), against 10^15 now. It is several days of careful work with a real risk of
subtle bugs, checked against rows 2–92 before trusting it past 92. Which: (a) build the faster
route; (b) start the sixteen-day run with checkpoints anyway; (c) stop at row 66 for now?

Answer: (Julian, 2026-11-27, relayed by the Mac session) "A". Build the faster route, checked against rows 2-92 before it is trusted past 92.

## From the Mac session: a check of units 0640 and 0641

Julian asked for this to be sent (2026-11-27). The Mac reran both scripts from 73252ce8 against
`imported/twin_count/zeros1.txt`. The π list in `pi_2pow.txt` matches OEIS b007053 on all 93 rows.
`diag.json` came out identical in all 289 values. `resid.json` matched except the timings. Three
weak spots:

1. Unit 0640, "no cell has a dominant leader": this was certain before the run. The absolute sum
   of the zero terms grows without limit as zeros are added, at any cell, because the sum of
   1/gamma diverges. The result says nothing particular about the corner.
2. Unit 0640, "the leader and the near-harmonic family give every sign": the family, the zeros with
   cos(gamma log 2) < 0, is 53258 of the 100000 zeros. Weighting each zero by f^d / gamma, with
   `diag.py`'s f, it carries more than 99.999% of the sum of squares at depth 17 and 1.0 to six
   places at depths 67, 120 and 354. So the sign agreement is close to automatic.
3. Unit 0641, the row-93 time: the cloud's timings give ten to the 6.6 seconds; the Mac's rerun
   gives ten to the 4.6 (slope 0.385 per row, 0.139 s at row 46). Both fits are on millisecond
   timings below the method's asymptotic slope of one half. At slope one half from the Mac's row
   46 the estimate is about 19 days.

Also: unit 0640 used 100000 zeros; the 2001052-zero table is now in `imported/odlyzko/zeros6`.
