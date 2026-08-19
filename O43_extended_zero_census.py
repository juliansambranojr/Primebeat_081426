#!/usr/bin/env python3
"""
O43 — extended exact-zero census of the backward dyadic prime difference
      table to r = 92, on published pi(2^n) data. No primes are counted here.

Reads with: preregs/extended_zero_census_v1_locked_20260818.md,
            results/O16_run2.log (section EXACT ZEROS, section TABLE EXTENTS),
            papers/literature/litsearch_2_priority.md (section "Verdict on (i)"),
            pi2n_cache.json,
            O16_centered_difference_table.py (table construction, support rule)

STATUS: PREREGISTERED — but only once
`preregs/extended_zero_census_v1_locked_20260818.md` says LOCKED. While that
file says DRAFT this script must not be run for record. Nothing it prints is
a verdict; it reports the decision rule's mechanical output and the verdict
line is Julian's (CLAUDE.md, section "Prereg discipline").

PROVENANCE: written 2026-08-18, before the prereg was locked and before any
run. The drafting agent did NOT download the b-file — only a HEAD request was
issued — so terms n = 63..92 were unseen at the time this file was written.

=============================================================================
WHAT THIS MEASURES
=============================================================================

The backward, unit-weighted, prime-side dyadic difference table

    N(r)   = pi(2^r) - pi(2^(r-1))          primes in (2^(r-1), 2^r]
    B(r,0) = N(r)
    B(r,d) = B(r,d-1) - B(r-1,d-1)          support r = d+1 .. R

has exactly four exact zeros at depth >= 1 over its whole computed support.
results/O16_run2.log, section "EXACT ZEROS (depth >= 1), all four tables":

    backward_prime:  4 zero(s)
      (r= 2, d= 1)   (r= 4, d= 1)   (r= 8, d= 3)   (r=20, d= 6)

and section "TABLE EXTENTS" gives that table 1953 cells, max r 62, max depth
61.  But r <= 62 is not a structural limit.  It is where pi2n_cache.json
stops: O16_centered_difference_table.py takes R from the cache's own maximum
n (R_full = max(r_avail)), so the census ceiling and the cache ceiling are the
same number by construction.

OEIS A007053 ("Number of primes <= 2^n") publishes a b-file to n = 92.
papers/literature/litsearch_2_priority.md, "Verdict on (i)":

    b-file runs to n = 0..92 (David Baugh, using Kim Walisch's `primecount`;
    terms 0..86 from Greathouse and Staple).  The project's pi2n_cache.json
    (n = 0..62) is a strict prefix of this and agrees at every term I
    spot-checked (pi(2^62) = 109932807585469973 in both).

So the census can be extended 30 rungs on published data, computing no primes
locally.  The question is whether "exactly four" is a property of the table or
an artifact of where the cache ended.

THE HYPOTHESES (prereg, section "Primary hypothesis")
  H0  the rate does not depend on r.  Exact zeros arise at one per-cell rate
      everywhere on the d >= 1 support; four is just what 1891 cells gave, and
      2295 more cells yield more in proportion.
  H1  the four are special.  62 < r <= 92 yields none, or far fewer than
      proportion predicts.  Predicted direction: a deficit, point prediction
      K_new = 0.

  cells at d >= 1, support r = d+1..R:   R = 62 -> 1891    R = 92 -> 4186
  new cells (all have r >= 63)       :   4186 - 1891 = 2295 = sum_{r=63}^{92}(r-1)
  H0 expectation                     :   4 * 2295 / 1891 = 4.854574299312533

  Raising R cannot move an existing cell: B(r,d) depends only on
  N(r-d)..N(r).  That is what makes the reproduction check below a real check
  and not a tautology.

THE FIVE CHECKS, in the order they are reported

  1  INTEGRITY, and it is worth more than the census.  The b-file's terms
     n = 0..62 must equal pi2n_cache.json exactly.  63 independent
     comparisons against a table compiled by other people.  No prior test in
     this tree has checked the cache against anything external.  Any mismatch
     trips `compromised` and the run stops before the table is built.
  2  REPRODUCTION.  Zeros at r <= 62 in the newly built R = 92 table must be
     exactly {(2,1),(4,1),(8,3),(20,6)}, and must equal the set re-parsed from
     results/O16_run2.log at run time.  Failure trips `compromised`.  This is a
     reproduction check, NOT evidence — those four cells are the most inspected
     objects in this tree (prereg, section "Provenance disclosure", item 1).
  3  CENSUS.  K_new and the new-zero list, reported SEPARATELY from the four
     reproduced ones and never merged with them.
  4  RATE TEST.  Exact conditional binomial: given T = 4 + K_new over the
     combined 4186 cells, K_new | T ~ Binomial(T, 2295/4186), one-sided for a
     deficit.  q drops out, so no nuisance parameter is estimated and reused.
     A Poisson test at lambda = 4.8546 is reported as secondary and CANNOT
     change the verdict — it treats the old rate as known without error, and
     that rate rests on four events.
  5  NEAR-MISS PROFILE.  For any H >= 0, #zeros in a region <= #{cells with
     |B| <= H}, exactly, because a zero IS such a cell.  A hard bound, not a
     model.  H = 1024 is locked.  This feeds the `magnitude_floor` branch.

WHY THE NEAR-MISS BRANCH EXISTS
  The uniform null is already falsified by the OLD region.  190 of the 1891
  old cells have r <= 20 and all four zeros are among them: (190/1891)^4 =
  1.019e-4.  Of the 131 old cells with |B| <= 1024 the largest r is 22; the
  smallest |B| anywhere at r >= 60 is 1088117707.  So a deficit at r > 62 is
  the sober expectation, and the prereg pre-commits to reading it soberly via
  `magnitude_floor` rather than appending hedges to a `rate_falls_with_r`
  result after the fact.  (Those old-region numbers are disclosed as
  non-blind in the prereg: they were computed while drafting, and H = 1024 was
  chosen with them in view.)

ARITHMETIC
  EXACT PYTHON INTEGERS for every table value, following
  O16_centered_difference_table.py: at (92,91) the entries exceed anything a
  float64 can hold, and numpy int64 would silently overflow.  numpy is not
  imported.  Floats appear only in the two p-values.

RANDOMNESS
  None.  No Monte Carlo, no permutation, no resampling; both p-values are
  closed form.  There is therefore no --seed flag and nothing to seed.
  REFERENCES.md, section "Constants used across the bench", records seed 2026
  for the tests that need one; this is not one of them.

HOW IT WILL BE RUN (do not run while the prereg says DRAFT)
  .venv/bin/python O43_extended_zero_census.py \
      --bfile-source network \
      --bfile-url https://oeis.org/A007053/b007053.txt \
      --bfile-raw b007053.txt \
      --cache pi2n_cache.json \
      --o16-log results/O16_run2.log \
      --rmax-old 62 --rmax-ext 92 --d-min 1 \
      --near-miss-h 1024 --alpha 0.05 \
      --out results/extended_zero_census.json \
      2>&1 | tee results/O43_extended_zero_census_run1.log

  Every flag is passed explicitly; every flag is required; there are no
  defaults to inherit silently.  --bfile-source local re-reads the already
  fetched --bfile-raw instead of the network, for a pinned re-run.

REQUIREMENTS: standard library only.
"""
import argparse
import datetime
import hashlib
import json
import math
import os
import re
import sys
import urllib.request

_HERE = os.path.dirname(os.path.abspath(__file__))

# ---------------------------------------------------------------------------
# LOCKED, NOT FLAGS
# ---------------------------------------------------------------------------

# The zero set under test.  results/O16_run2.log, section EXACT ZEROS,
# backward_prime; also results/O16_centered_difference_table_run2.json at
# constants.documented_backward_zeros, and DOCUMENTED_BACKWARD_ZEROS in
# O16_centered_difference_table.py.  Re-read from the log at run time and
# compared; a mismatch trips `compromised`.
KNOWN_ZEROS = ((2, 1), (4, 1), (8, 3), (20, 6))

# pi2n_cache.json holds n = 0..62, 63 entries (CONTEXT.md, section Caches).
# Every one of them is an integrity comparison.
EXPECTED_CACHE_N_MIN = 0
EXPECTED_CACHE_N_MAX = 62
EXPECTED_CACHE_ENTRIES = 63

# Fetch method.  papers/literature/litsearch_2_priority.md records that
# WebFetch gets 403 from OEIS and that curl with a browser User-Agent works.
# Locked so the fetch is not improvised at run time.
BFILE_USER_AGENT = (
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) "
    "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0 Safari/537.36"
)
BFILE_TIMEOUT_S = 60

# HEAD-request metadata observed while drafting the prereg, 2026-08-19T02:08:59Z.
# Drift in either is REPORTED, never a `compromised` trip: OEIS may republish.
# Only the 63 term comparisons trip `compromised`.
BFILE_EXPECTED_BYTES = 1572
BFILE_EXPECTED_LAST_MODIFIED = "Wed, 16 Dec 2020 06:02:57 GMT"

PREREG_PATH = "preregs/extended_zero_census_v1_locked_20260818.md"

VERDICT_LABELS = ("rate_constant", "magnitude_floor", "rate_falls_with_r",
                  "ambiguous", "compromised")
PRECEDENCE = ("compromised > rate_constant > magnitude_floor > "
              "rate_falls_with_r > ambiguous")

RULE = "-" * 78


# ---------------------------------------------------------------------------
# housekeeping
# ---------------------------------------------------------------------------

def code_version():
    """sha256 of this file.  CONTEXT.md records the known weakness: this is
    read at write time, not import time, so an edit landing mid-run mislabels
    the result.  Recorded, not fixed here."""
    try:
        with open(os.path.abspath(__file__), "rb") as fh:
            return hashlib.sha256(fh.read()).hexdigest()
    except Exception as exc:                                  # pragma: no cover
        return "unavailable: %s" % exc


def utcnow():
    return datetime.datetime.now(datetime.timezone.utc).strftime(
        "%Y-%m-%dT%H:%M:%SZ")


def resolve(path):
    """Anchor relative paths to the script root so runs are cwd-independent
    (CONTEXT.md, section 'Output schema')."""
    return path if os.path.isabs(path) else os.path.join(_HERE, path)


def head(title):
    print()
    print(RULE)
    print(title)
    print(RULE)


# ---------------------------------------------------------------------------
# inputs
# ---------------------------------------------------------------------------

def fetch_bfile(url, raw_path, source):
    """Retrieve the b-file (or re-read a pinned copy) and record its bytes.

    Returns (raw_bytes, meta).  meta always carries sha256, n_bytes and the
    source; a network fetch adds status and the response headers this prereg
    locked HEAD values for.
    """
    if source == "local":
        with open(raw_path, "rb") as fh:
            raw = fh.read()
        meta = dict(source="local", url=url, path=raw_path, http_status=None,
                    content_length_header=None, last_modified_header=None,
                    retrieved_utc=None)
    else:
        req = urllib.request.Request(url, headers={
            "User-Agent": BFILE_USER_AGENT,
            "Accept": "text/plain,*/*",
        })
        with urllib.request.urlopen(req, timeout=BFILE_TIMEOUT_S) as resp:
            raw = resp.read()
            status = int(resp.status)
            hdrs = dict(resp.headers.items())
        meta = dict(
            source="network", url=url, path=raw_path, http_status=status,
            content_length_header=hdrs.get("Content-Length"),
            last_modified_header=hdrs.get("Last-Modified"),
            retrieved_utc=utcnow(),
        )
        # Write the raw bytes into the tree so the run is reproducible and a
        # later run can pin to this exact input with --bfile-source local.
        try:
            os.makedirs(os.path.dirname(raw_path) or _HERE, exist_ok=True)
            with open(raw_path, "wb") as fh:
                fh.write(raw)
        except Exception as exc:                              # a write failure
            print("  WARNING: could not write raw b-file to %s: %s"
                  % (raw_path, exc), file=sys.stderr)         # must not kill
                                                              # the run
    meta["sha256"] = hashlib.sha256(raw).hexdigest()
    meta["n_bytes"] = len(raw)
    meta["bytes_match_head_probe"] = (len(raw) == BFILE_EXPECTED_BYTES)
    meta["last_modified_matches_head_probe"] = (
        meta.get("last_modified_header") == BFILE_EXPECTED_LAST_MODIFIED)
    return raw, meta


_BFILE_LINE = re.compile(r"^\s*(-?\d+)\s+(-?\d+)\s*$")


def parse_bfile(raw):
    """Parse an OEIS b-file.

    Returns (terms, comments).  terms is {n: value} with exact Python ints;
    comments is the list of '#' lines verbatim, so the file's own attribution
    is on the record rather than assumed (prereg, provenance item 5).
    Malformed non-comment lines are collected and returned as a third element.
    """
    terms = {}
    comments = []
    bad = []
    text = raw.decode("utf-8", errors="replace")
    for line in text.splitlines():
        s = line.strip()
        if not s:
            continue
        if s.startswith("#"):
            comments.append(line.rstrip())
            continue
        m = _BFILE_LINE.match(s)
        if m:
            terms[int(m.group(1))] = int(m.group(2))
        else:
            bad.append(line.rstrip())
    return terms, comments, bad


def read_cache(path):
    """pi2n_cache.json -> {n: pi(2^n)} as exact ints.  Read-only; this script
    never rewrites the cache."""
    with open(path, "r") as fh:
        raw = json.load(fh)
    return {int(k): int(v) for k, v in raw.items()}


_LOG_ZERO = re.compile(r"^\s*\(r=\s*(\d+),\s*d=\s*(\d+)\)")


def read_o16_zeros(path):
    """Re-parse the backward_prime zero set from results/O16_run2.log, section
    'EXACT ZEROS (depth >= 1), all four tables'.  Reading it at run time means
    drift between the prereg's text and the artifact trips `compromised`
    instead of passing silently."""
    zeros = []
    in_block = False
    with open(path, "r") as fh:
        for line in fh:
            if line.strip().startswith("backward_prime:"):
                in_block = True
                continue
            if in_block:
                m = _LOG_ZERO.match(line)
                if m:
                    zeros.append((int(m.group(1)), int(m.group(2))))
                    continue
                if line.strip() == "":
                    continue
                break
    return tuple(sorted(zeros, key=lambda p: (p[1], p[0])))


# ---------------------------------------------------------------------------
# the table — exact integers only, following O16
# ---------------------------------------------------------------------------

def backward_table(seq, R, d_min):
    """B(r,0) = seq[r] for r = 1..R;  B(r,d) = B(r,d-1) - B(r-1,d-1),
    support r = d+1..R, depths 0..R-1.  Identical convention to
    O16_centered_difference_table.py backward_table().  Returns {d: {r: int}}
    for depths d_min-1 .. R-1 inclusive of the depths needed to reach d_min."""
    # Depth 0 is always built (every deeper depth needs it) and always
    # retained; zeros are enumerated only at d >= d_min, by zeros_of().
    tab = {0: {r: seq[r] for r in range(1, R + 1)}}
    for d in range(1, R):
        prev = tab[d - 1]
        tab[d] = {r: prev[r] - prev[r - 1] for r in range(d + 1, R + 1)}
    return tab


def support_cell_count(R, d_min):
    """|{(r,d) : d_min <= d <= R-1, d+1 <= r <= R}|."""
    return sum(len(range(d + 1, R + 1)) for d in range(d_min, R))


def zeros_of(tab, d_min):
    """Sorted (r,d) with B(r,d) exactly 0 at depth >= d_min.  Exact integer
    equality — no tolerance, because these are integers."""
    z = []
    for d, row in tab.items():
        if d < d_min:
            continue
        for r, v in row.items():
            if v == 0:
                z.append((r, d))
    return sorted(z, key=lambda p: (p[1], p[0]))


def near_miss_cells(tab, d_min, H, r_lo, r_hi):
    """(r,d) with |B(r,d)| <= H and r_lo <= r <= r_hi, depth >= d_min.
    A zero IS such a cell, so #zeros <= #near-misses exactly, for any H >= 0."""
    out = []
    for d, row in tab.items():
        if d < d_min:
            continue
        for r, v in row.items():
            if r_lo <= r <= r_hi and abs(v) <= H:
                out.append((r, d))
    return sorted(out, key=lambda p: (p[0], p[1]))


def min_abs_in_band(tab, d_min, r_lo, r_hi):
    """min |B(r,d)| over the band, or None if the band is empty."""
    best = None
    cell = None
    for d, row in tab.items():
        if d < d_min:
            continue
        for r, v in row.items():
            if r_lo <= r <= r_hi:
                a = abs(v)
                if best is None or a < best:
                    best, cell = a, (r, d)
    return best, cell


# ---------------------------------------------------------------------------
# statistics — closed form, no randomness
# ---------------------------------------------------------------------------

def conditional_binomial_p(k, cells_new, cells_ext, n_known):
    """Exact one-sided deficit p under a constant per-cell rate.

    Conditional on the total T = n_known + k over the combined support, the
    split between old and new is Binomial(T, cells_new/cells_ext) and the
    unknown per-cell rate q cancels.  p = P(K <= k | T).
    """
    T = n_known + k
    pn = cells_new / cells_ext
    return sum(math.comb(T, j) * pn ** j * (1.0 - pn) ** (T - j)
               for j in range(0, k + 1))


def poisson_p(k, lam):
    """P(K <= k), K ~ Poisson(lam).  Secondary only: it treats the old-region
    rate as known without error, and that rate rests on four events."""
    return sum(math.exp(-lam) * lam ** j / math.factorial(j)
               for j in range(0, k + 1))


# ---------------------------------------------------------------------------

def main():
    ap = argparse.ArgumentParser(
        description="O43 — extended exact-zero census of the backward dyadic "
                    "prime difference table to r = 92 on OEIS A007053 data.")
    ap.add_argument("--bfile-source", required=True, choices=("network", "local"),
                    help="network: fetch --bfile-url and write --bfile-raw. "
                         "local: re-read --bfile-raw for a pinned re-run.")
    ap.add_argument("--bfile-url", required=True,
                    help="OEIS b-file URL (locked: "
                         "https://oeis.org/A007053/b007053.txt)")
    ap.add_argument("--bfile-raw", required=True,
                    help="path the retrieved bytes are written to / read from "
                         "(locked: b007053.txt at the project root)")
    ap.add_argument("--cache", required=True,
                    help="pi2n_cache.json — READ ONLY, never rewritten here")
    ap.add_argument("--o16-log", required=True,
                    help="results/O16_run2.log, re-parsed for the zero set")
    ap.add_argument("--rmax-old", type=int, required=True,
                    help="old census ceiling (locked: 62)")
    ap.add_argument("--rmax-ext", type=int, required=True,
                    help="extended census ceiling (locked: 92)")
    ap.add_argument("--d-min", type=int, required=True,
                    help="minimum depth a zero is counted at (locked: 1)")
    ap.add_argument("--near-miss-h", type=int, required=True,
                    help="near-miss threshold H (locked: 1024)")
    ap.add_argument("--alpha", type=float, required=True,
                    help="one-sided level (locked: 0.05)")
    ap.add_argument("--out", required=True,
                    help="results JSON path")
    ap.add_argument("--no-json", action="store_true",
                    help="suppress the results JSON write")
    args = ap.parse_args()

    started = utcnow()
    bfile_raw_path = resolve(args.bfile_raw)
    cache_path = resolve(args.cache)
    o16_log_path = resolve(args.o16_log)
    out_path = resolve(args.out)

    R_OLD, R_EXT, D_MIN = args.rmax_old, args.rmax_ext, args.d_min
    H = args.near_miss_h

    compromised = []          # every condition that tripped, in order found

    print("=" * 78)
    print("O43 — EXTENDED EXACT-ZERO CENSUS TO r = %d" % R_EXT)
    print("=" * 78)
    print("  prereg      : %s" % PREREG_PATH)
    print("  started     : %s" % started)
    print("  code_version: %s" % code_version())
    print("  randomness  : none (both p-values closed form; no --seed flag)")
    print("  arithmetic  : exact Python int for the table; float only for p")
    print()
    print("  Nothing printed here is a verdict.  This script reports the")
    print("  decision rule's mechanical output; the verdict line is Julian's")
    print("  (CLAUDE.md, section 'Prereg discipline').")

    # ---------------- fetch --------------------------------------------------
    head("B-FILE RETRIEVAL")
    print("  source      : %s" % args.bfile_source)
    print("  url         : %s" % args.bfile_url)
    print("  raw written : %s" % bfile_raw_path)
    try:
        raw, bmeta = fetch_bfile(args.bfile_url, bfile_raw_path,
                                 args.bfile_source)
    except Exception as exc:
        print("  FETCH FAILED: %s" % exc)
        compromised.append("bfile_fetch_failed: %s" % exc)
        raw, bmeta = b"", dict(source=args.bfile_source, url=args.bfile_url,
                               path=bfile_raw_path, http_status=None,
                               sha256=None, n_bytes=0,
                               content_length_header=None,
                               last_modified_header=None, retrieved_utc=None,
                               bytes_match_head_probe=False,
                               last_modified_matches_head_probe=False)
    print("  http status : %s" % bmeta.get("http_status"))
    print("  bytes       : %s   (HEAD probe at draft time: %d -> %s)"
          % (bmeta.get("n_bytes"), BFILE_EXPECTED_BYTES,
             "match" if bmeta.get("bytes_match_head_probe") else "DRIFT"))
    print("  last-modified: %s   (HEAD probe: %s -> %s)"
          % (bmeta.get("last_modified_header"), BFILE_EXPECTED_LAST_MODIFIED,
             "match" if bmeta.get("last_modified_matches_head_probe")
             else "DRIFT"))
    print("  sha256      : %s" % bmeta.get("sha256"))
    print()
    print("  Metadata drift is REPORTED, never a `compromised` trip — OEIS may")
    print("  republish.  Only the term comparisons below trip `compromised`.")

    if bmeta.get("http_status") is not None and bmeta["http_status"] != 200:
        compromised.append("http_status != 200: %s" % bmeta["http_status"])

    terms, comments, bad_lines = parse_bfile(raw)
    print()
    print("  data lines parsed : %d" % len(terms))
    print("  comment lines     : %d" % len(comments))
    for c in comments:
        print("      %s" % c)
    if bad_lines:
        print("  UNPARSED LINES    : %d" % len(bad_lines))
        for b in bad_lines[:10]:
            print("      %s" % b)

    ns = sorted(terms)
    contiguous = bool(ns) and ns == list(range(ns[0], ns[-1] + 1))
    print("  n range           : %s..%s" % (ns[0] if ns else None,
                                            ns[-1] if ns else None))
    print("  contiguous        : %s" % contiguous)
    if len(terms) < R_EXT + 1:
        compromised.append("bfile has %d data lines, need >= %d"
                           % (len(terms), R_EXT + 1))
    if not contiguous or not ns or ns[0] != 0 or ns[-1] < R_EXT:
        compromised.append("bfile n range is not a contiguous 0..%d" % R_EXT)
    for n in ns:
        v = terms[n]
        if v < 0:
            compromised.append("bfile pi(2^%d) negative: %d" % (n, v))
            break
    for i in range(1, len(ns)):
        if terms[ns[i]] < terms[ns[i - 1]]:
            compromised.append("bfile pi(2^n) not non-decreasing at n=%d"
                               % ns[i])
            break

    # ---------------- CHECK 1 — integrity -----------------------------------
    head("CHECK 1 — INTEGRITY: b-file n = 0..%d vs pi2n_cache.json  "
         "(reported first)" % EXPECTED_CACHE_N_MAX)
    print("  cache : %s   (READ ONLY)" % cache_path)
    try:
        cache = read_cache(cache_path)
    except Exception as exc:
        print("  CACHE READ FAILED: %s" % exc)
        compromised.append("cache_read_failed: %s" % exc)
        cache = {}
    cns = sorted(cache)
    print("  entries : %d   n range : %s..%s"
          % (len(cache), cns[0] if cns else None, cns[-1] if cns else None))
    if (len(cache) != EXPECTED_CACHE_ENTRIES or not cns
            or cns[0] != EXPECTED_CACHE_N_MIN or cns[-1] != EXPECTED_CACHE_N_MAX
            or cns != list(range(EXPECTED_CACHE_N_MIN,
                                 EXPECTED_CACHE_N_MAX + 1))):
        compromised.append(
            "cache is not exactly n = %d..%d with %d entries"
            % (EXPECTED_CACHE_N_MIN, EXPECTED_CACHE_N_MAX,
               EXPECTED_CACHE_ENTRIES))

    comparisons = []
    n_match = n_mismatch = 0
    for n in range(EXPECTED_CACHE_N_MIN, EXPECTED_CACHE_N_MAX + 1):
        cv = cache.get(n)
        bv = terms.get(n)
        ok = (cv is not None and bv is not None and cv == bv)
        comparisons.append(dict(n=n, cache=cv, bfile=bv, equal=bool(ok)))
        if ok:
            n_match += 1
        else:
            n_mismatch += 1
    print()
    print("  independent comparisons : %d" % len(comparisons))
    print("  equal                   : %d" % n_match)
    print("  UNEQUAL                 : %d" % n_mismatch)
    if n_mismatch:
        print()
        print("  MISMATCHES:")
        for c in comparisons:
            if not c["equal"]:
                print("    n=%2d  cache=%s  bfile=%s"
                      % (c["n"], c["cache"], c["bfile"]))
        compromised.append("integrity: %d of %d term comparisons unequal"
                           % (n_mismatch, len(comparisons)))
    else:
        print()
        print("  pi(2^%d) = %s in both."
              % (EXPECTED_CACHE_N_MAX, cache.get(EXPECTED_CACHE_N_MAX)))
        print("  All %d terms agree.  This is the first external witness this"
              % len(comparisons))
        print("  tree's pi(2^n) cache has had.  Every result descending from")
        print("  pi2n_cache.json — 05, 06, 07, O4, O16, O27, O42 — inherits it.")
        print()
        print("  One of the 63 was already known to pass: n = 62 was")
        print("  spot-checked in papers/literature/litsearch_2_priority.md.")
        print("  The other 62 had not been checked by anyone.")

    if compromised:
        head("COMPROMISED — STOPPING BEFORE THE CENSUS")
        for c in compromised:
            print("  %s" % c)
        print()
        print("  The census is NOT reported as a number.  Per the locked")
        print("  decision rule the mechanical output is `compromised` and")
        print("  there is no verdict.")
        _emit(args, out_path, started, bmeta, comments, comparisons,
              n_match, n_mismatch, None, None, None, None, None, None,
              None, None, None, None, compromised, "compromised",
              R_OLD, R_EXT, D_MIN, H)
        return

    # ---------------- table --------------------------------------------------
    head("TABLE — backward prime, R = %d, exact integers" % R_EXT)
    N = {r: terms[r] - terms[r - 1] for r in range(1, R_EXT + 1)}
    tab = backward_table(N, R_EXT, D_MIN)
    cells_old = support_cell_count(R_OLD, D_MIN)
    cells_ext = support_cell_count(R_EXT, D_MIN)
    cells_new = cells_ext - cells_old
    print("  convention  : B(r,d) = B(r,d-1) - B(r-1,d-1), support r = d+1..R")
    print("  depth floor : d >= %d" % D_MIN)
    print("  cells, R=%d : %d" % (R_OLD, cells_old))
    print("  cells, R=%d : %d" % (R_EXT, cells_ext))
    print("  new cells   : %d   (all have r >= %d)" % (cells_new, R_OLD + 1))
    print("  N(%d) = %s" % (R_OLD, N[R_OLD]))
    print("  N(%d) = %s" % (R_EXT, N[R_EXT]))
    mx = max((abs(v), (r, d)) for d, row in tab.items() if d >= D_MIN
             for r, v in row.items())
    print("  max |B|     : %s  at (r=%d, d=%d)" % (mx[0], mx[1][0], mx[1][1]))

    # ---------------- CHECK 2 — reproduction ---------------------------------
    head("CHECK 2 — REPRODUCTION of the known zeros at r <= %d" % R_OLD)
    all_zeros = zeros_of(tab, D_MIN)
    old_zeros = tuple(z for z in all_zeros if z[0] <= R_OLD)
    new_zeros = tuple(z for z in all_zeros if z[0] > R_OLD)
    try:
        log_zeros = read_o16_zeros(o16_log_path)
    except Exception as exc:
        print("  O16 LOG READ FAILED: %s" % exc)
        compromised.append("o16_log_read_failed: %s" % exc)
        log_zeros = ()
    print("  known (prereg)        : %s" % (list(map(list, KNOWN_ZEROS)),))
    print("  re-parsed from log    : %s" % (list(map(list, log_zeros)),))
    print("  rebuilt, r <= %d      : %s" % (R_OLD, list(map(list, old_zeros))))
    repro_ok = (old_zeros == KNOWN_ZEROS)
    log_ok = (log_zeros == KNOWN_ZEROS)
    print("  rebuilt == known      : %s" % repro_ok)
    print("  log     == known      : %s" % log_ok)
    if not repro_ok:
        compromised.append("reproduction: rebuilt r<=%d zeros %s != known %s"
                           % (R_OLD, list(old_zeros), list(KNOWN_ZEROS)))
    if not log_ok:
        compromised.append("o16 log zero set %s != known %s"
                           % (list(log_zeros), list(KNOWN_ZEROS)))
    print()
    print("  This is a REPRODUCTION CHECK, not evidence.  Those four cells are")
    print("  the most inspected objects in this tree (prereg, provenance 1).")
    print("  Raising R cannot move an old cell — B(r,d) depends only on")
    print("  N(r-d)..N(r) — so this checks the new construction, not pi.")

    # ---------------- CHECK 3 — the census -----------------------------------
    head("CHECK 3 — CENSUS: new exact zeros in %d < r <= %d" % (R_OLD, R_EXT))
    K = len(new_zeros)
    print("  reproduced (r <= %d) : %d  %s"
          % (R_OLD, len(old_zeros), list(map(list, old_zeros))))
    print("  NEW (%d < r <= %d)   : %d" % (R_OLD, R_EXT, K))
    if new_zeros:
        for (r, d) in new_zeros:
            print("      (r=%2d, d=%2d)   2^(r-d-1) = %s   r-2d = %d   r-d = %d"
                  % (r, d, 1 << (r - d - 1), r - 2 * d, r - d))
    else:
        print("      (none)")
    print()
    print("  Reported separately from the reproduced four, never merged.")

    # ---------------- CHECK 4 — the rate test --------------------------------
    head("CHECK 4 — RATE TEST")
    n_known = len(KNOWN_ZEROS)
    E_new = n_known * cells_new / cells_old
    p_new_frac = cells_new / cells_ext
    p_cond = conditional_binomial_p(K, cells_new, cells_ext, n_known)
    p_pois = poisson_p(K, E_new)
    print("  H0: one per-cell rate everywhere on the d >= %d support." % D_MIN)
    print("  observed K_new                  : %d" % K)
    print("  H0 expectation  %d * %d / %d    : %.15f"
          % (n_known, cells_new, cells_old, E_new))
    print("  new-cell share  %d / %d         : %.16f"
          % (cells_new, cells_ext, p_new_frac))
    print()
    print("  PRIMARY  exact conditional binomial, K|T ~ Bin(T=%d, %.6f)"
          % (n_known + K, p_new_frac))
    print("           one-sided deficit p     : %.6f   (alpha %.3f -> %s)"
          % (p_cond, args.alpha,
             "fires" if p_cond <= args.alpha else "does not fire"))
    print("  SECONDARY Poisson(lambda=%.6f)   p : %.6f   (cannot change the "
          "verdict)" % (E_new, p_pois))
    print()
    print("  The rate estimate rests on %d events.  The conditional test is"
          % n_known)
    print("  primary because the unknown per-cell rate cancels out of it; the")
    print("  Poisson test treats that rate as known without error.")

    # ---------------- CHECK 5 — near-miss profile ----------------------------
    head("CHECK 5 — NEAR-MISS PROFILE, H = %d  (diagnostic)" % H)
    print("  #zeros in a region <= #{cells with |B| <= H}, exactly, for any")
    print("  H >= 0, because a zero IS such a cell.  A hard bound, not a model.")
    nm_old = near_miss_cells(tab, D_MIN, H, 1, R_OLD)
    nm_new = near_miss_cells(tab, D_MIN, H, R_OLD + 1, R_EXT)
    M_new = len(nm_new)
    print()
    print("  old region 1 <= r <= %d : %d cells with |B| <= %d, max r = %s"
          % (R_OLD, len(nm_old), H,
             max((r for r, _ in nm_old), default=None)))
    print("  NEW region %d < r <= %d : %d cells with |B| <= %d, max r = %s"
          % (R_OLD, R_EXT, M_new, H,
             max((r for r, _ in nm_new), default=None)))
    if nm_new:
        for (r, d) in nm_new:
            print("      (r=%2d, d=%2d)  B = %s" % (r, d, tab[d][r]))
    print()
    print("  per r-band (min |B| over the band, depth >= %d):" % D_MIN)
    bands = []
    lo = 1
    while lo <= R_EXT:
        hi = min(lo + 9, R_EXT)
        cnt = sum(1 for r, _ in nm_old + nm_new if lo <= r <= hi)
        mn, cell = min_abs_in_band(tab, D_MIN, lo, hi)
        bands.append(dict(r_lo=lo, r_hi=hi, near_miss=cnt,
                          min_abs=str(mn) if mn is not None else None,
                          min_abs_cell=list(cell) if cell else None))
        print("    r %2d-%2d : |B|<=%d : %4d    min |B| = %s  at %s"
              % (lo, hi, H, cnt, mn, cell))
        lo = hi + 1

    # ---------------- mechanical decision-rule output ------------------------
    fires = (p_cond <= args.alpha)
    if compromised:
        mech = "compromised"
    elif K >= 1 and not fires:
        mech = "rate_constant"
    elif K == 0 and fires and M_new == 0:
        mech = "magnitude_floor"
    elif K == 0 and fires and M_new >= 1:
        mech = "rate_falls_with_r"
    else:
        mech = "ambiguous"

    print()
    print("=" * 78)
    print("MECHANICAL DECISION-RULE OUTPUT (NOT A VERDICT)")
    print("=" * 78)
    print("  integrity comparisons unequal    : %d" % n_mismatch)
    print("  reproduction of the known four   : %s" % repro_ok)
    print("  K_new                            : %d" % K)
    print("  primary p <= alpha               : %s" % fires)
    print("  M_new (near-miss at H=%d)      : %d" % (H, M_new))
    print("  compromised conditions tripped   : %s"
          % (compromised if compromised else "(none)"))
    print()
    print("  label the decision rule selects  : %s" % mech)
    print("  precedence                       : %s" % PRECEDENCE)
    print()
    print("  The verdict line in the prereg's Run record is Julian's to write.")
    print("  CLAUDE.md, section 'Prereg discipline': an agent may compute the")
    print("  SHA and report the decision rule's mechanical output; it does not")
    print("  stamp the verdict.")

    _emit(args, out_path, started, bmeta, comments, comparisons, n_match,
          n_mismatch, cells_old, cells_ext, cells_new, old_zeros, new_zeros,
          E_new, p_cond, p_pois, nm_old, bands, compromised, mech,
          R_OLD, R_EXT, D_MIN, H, log_zeros=log_zeros, repro_ok=repro_ok,
          nm_new=nm_new, N=N)


# ---------------------------------------------------------------------------
# results envelope — CONTEXT.md, section "Output schema"
# ---------------------------------------------------------------------------

def _emit(args, out_path, started, bmeta, comments, comparisons, n_match,
          n_mismatch, cells_old, cells_ext, cells_new, old_zeros, new_zeros,
          E_new, p_cond, p_pois, nm_old, bands, compromised, mech,
          R_OLD, R_EXT, D_MIN, H, log_zeros=(), repro_ok=None, nm_new=(),
          N=None):
    if args.no_json:
        return
    ended = utcnow()
    payload = dict(
        schema_version="1",
        script=os.path.basename(__file__),
        generated_utc=ended,
        params=dict(
            base=2,
            rmax_old=R_OLD, rmax_ext=R_EXT, d_min=D_MIN,
            near_miss_h=H, alpha=args.alpha,
            bfile_source=args.bfile_source,
            bfile_url=args.bfile_url,
            bfile_raw=args.bfile_raw,
            cache=args.cache,
            o16_log=args.o16_log,
            randomness="none — both p-values closed form; no --seed flag",
            arithmetic="exact Python int for the table; float only for p",
            run_start_at=started, run_end_at=ended,
            code_version=code_version(),
            prereg=PREREG_PATH,
        ),
        constants=dict(
            table_convention="B(r,0)=N(r); B(r,d)=B(r,d-1)-B(r-1,d-1); "
                             "support r = d+1..R",
            counts_convention="N(r) = pi(2^r) - pi(2^(r-1)), primes in "
                              "(2^(r-1), 2^r]",
            known_zeros=[list(z) for z in KNOWN_ZEROS],
            known_zeros_source="results/O16_run2.log, section EXACT ZEROS, "
                               "backward_prime",
            zeros_read_from_o16_log=[list(z) for z in log_zeros],
            bfile_expected_bytes_head_probe=BFILE_EXPECTED_BYTES,
            bfile_expected_last_modified_head_probe=BFILE_EXPECTED_LAST_MODIFIED,
            bfile_head_probe_note="observed by curl -sI while drafting the "
                                  "prereg; drift is reported, never a "
                                  "compromised trip",
            null_primary="constant per-cell rate; exact conditional binomial, "
                         "K|T ~ Bin(T = 4 + K_new, cells_new/cells_ext)",
            null_secondary="Poisson(4*cells_new/cells_old); cannot change the "
                           "verdict",
            near_miss_bound="#zeros in a region <= #{cells with |B| <= H}, "
                            "exactly, for any H >= 0",
            verdict_labels=list(VERDICT_LABELS),
            precedence=PRECEDENCE,
            verdict_note="the verdict line is Julian's; this file records the "
                         "decision rule's mechanical output only",
        ),
        summary=dict(
            bfile=dict(
                url=bmeta.get("url"), source=bmeta.get("source"),
                http_status=bmeta.get("http_status"),
                sha256=bmeta.get("sha256"), n_bytes=bmeta.get("n_bytes"),
                content_length_header=bmeta.get("content_length_header"),
                last_modified_header=bmeta.get("last_modified_header"),
                retrieved_utc=bmeta.get("retrieved_utc"),
                raw_written_to=bmeta.get("path"),
                bytes_match_head_probe=bmeta.get("bytes_match_head_probe"),
                last_modified_matches_head_probe=bmeta.get(
                    "last_modified_matches_head_probe"),
                comment_lines=comments,
            ),
            check_1_integrity=dict(
                range=[EXPECTED_CACHE_N_MIN, EXPECTED_CACHE_N_MAX],
                n_comparisons=len(comparisons),
                n_equal=n_match, n_unequal=n_mismatch,
                passed=bool(n_mismatch == 0),
                already_known_to_pass=[62],
                already_known_source="papers/literature/"
                                     "litsearch_2_priority.md",
            ),
            check_2_reproduction=dict(
                rebuilt_old_zeros=[list(z) for z in (old_zeros or ())],
                matches_known=repro_ok,
                matches_o16_log=bool(tuple(log_zeros) == KNOWN_ZEROS),
                note="reproduction check, not evidence — these four cells are "
                     "fully non-blind",
            ),
            check_3_census=dict(
                cells_old=cells_old, cells_ext=cells_ext, cells_new=cells_new,
                n_reproduced=len(old_zeros or ()),
                K_new=len(new_zeros or ()),
                new_zeros=[list(z) for z in (new_zeros or ())],
            ),
            check_4_rate=dict(
                E_K_new_H0=E_new,
                new_cell_share=(cells_new / cells_ext) if cells_ext else None,
                p_conditional_binomial=p_cond,
                p_poisson_secondary=p_pois,
                alpha=args.alpha,
                primary_fires=(p_cond is not None and p_cond <= args.alpha),
            ),
            check_5_near_miss=dict(
                H=H,
                n_old_region=len(nm_old or ()),
                max_r_old_region=max((r for r, _ in (nm_old or ())),
                                     default=None),
                M_new=len(nm_new or ()),
                new_region_cells=[list(z) for z in (nm_new or ())],
                bands=bands,
            ),
            mechanical_decision_rule_output=mech,
            compromised_conditions=compromised,
        ),
        rows=[dict(n=c["n"], cache=str(c["cache"]) if c["cache"] is not None
                   else None,
                   bfile=str(c["bfile"]) if c["bfile"] is not None else None,
                   equal=c["equal"]) for c in comparisons],
    )
    # N(r) for the extended rungs, as strings: exact and JSON-safe.
    if N is not None:
        payload["summary"]["extended_counts"] = {
            str(r): str(N[r]) for r in range(R_OLD + 1, R_EXT + 1) if r in N}
    try:
        os.makedirs(os.path.dirname(out_path) or ".", exist_ok=True)
        with open(out_path, "w") as fh:
            json.dump(payload, fh, indent=2)
        print()
        print("results written to %s" % out_path)
    except Exception as exc:                       # a write failure must not
        print()                                    # kill the run (CONTEXT.md)
        print("WARNING: results write failed: %s" % exc, file=sys.stderr)


if __name__ == "__main__":
    main()
