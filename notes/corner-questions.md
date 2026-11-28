# Corner questions for Julian — cloud session, branch `claude/corner-cloud`

Questions from the cloud corner exploration (units 0640, 0641; both exploratory, no outcome marked).
Write your answer on the `Answer:` line under each; the session pulls the branch to read them.

## 1. The edge excess of small cells

On the edge diagonals (row = depth + 1, + 8, + 32, depths to 420, past row 92) the model's cells
fall below a twentieth of their root-square size about twice as often as independent phases
predict; on the five rays they fall at the predicted rate (unit 0640). Follow it up — more edges,
deeper, and whether the excess holds as zeros are added — or leave it?

Answer:

## 2. The parity identity, run past row 92

π(x) mod 2 is exact through the sum of 2^ω(n), a divisor-sum count; it matched the π list on rows
2–46 and its time grows about 2^(m/2) (unit 0641). Row 93 extrapolates to weeks of numpy here (the
unit's timing, taken while another run shared the machine), less in C. Each row reached certifies the odd corner cells it completes, and no more: the corner past it is
still infinite. Worth a C implementation and a run on rows 93 onward, here or on the Mac?

Answer:

## 3. Odlyzko's tables

This machine's network policy blocks his host, so lead 1 used the 100000 zeros already in
`imported/twin_count/zeros1.txt`. On the measurements in unit 0640 the conclusions did not move
between 30000 and 100000 zeros except the absolute-sum ratio, which grows without limit. Do you
want the host allowed for the two-million-zero table, or is 100000 enough for this lead?

Answer: yes to getting the 2-million-zero table (Julian, in chat, 2026-11-28; copied here by the session)

## 3b. The table cannot be fetched from this machine

The host www-users.cse.umn.edu is now on this environment's allowlist, but its TLS chain ends at
"emSign Root CA - G1", which is in none of this machine's trust stores (system, certifi, proxy
bundle), so the download is refused and the session will not turn verification off. Two ways on:
(a) download `zeros6` from Odlyzko's zeta_tables page on the Mac and commit it under `imported/`
(the session checks its first 100000 zeros against `imported/twin_count/zeros1.txt` before using
it); or (b) name another source of the same zeros, whose host the session then asks to allow.
Which?

Answer:

## 4. Where lead 1 goes next

Unit 0640: the leader never outweighs the absolute sum of the rest at any cell, so a bound of the
form leader less everything else is out; in root-square size the leader is about the size of the
rest on every diagonal; the small cells come at the random rate; a truncated explicit formula needs
zeros far beyond any table, more with every depth. Which of these do you want next: finite-row
certificates (parity, more π rows) with the infinite remainder left as a measure statement, or a
structural idea of yours for the near-harmonic family that the measurements have not tried?

Answer:
