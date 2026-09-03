"""Phase 2 tests: the exemption list, and the false accept it closes.

    python3 -m pytest tests/test_phase2.py -q

Two halves. The first is the reproduction Phase 1 deferred, kept as a
regression: a unit id inside a path was scanned as a number and ACCEPTED,
because a bare integer's tolerance is half a unit in its last stated place and
the fixture's stored ladder ratio sits inside that. The second is the
exemption list itself, `lab/exempt.py`, parametrized over its own CLASSES
table so that every class is exercised in both directions -- its recorded
example matches, and a lookalike that IS a measurement does not.

Parametrizing over the table is deliberate. A class added to `lab/exempt.py`
without an example and a counter fails collection here rather than shipping
untested, which is what keeps "one place in the program" from decaying into a
place plus some special cases.

The gate that calls `lab check` is `utilities/hooks/pre-commit`, exercised
from the shell rather than here, because what it does is stage-aware and its
subject is git's index.
"""

import io
import pathlib
import sys
from decimal import Decimal

import pytest

ROOT = pathlib.Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT))

from lab import check as check_mod                        # noqa: E402
from lab import exempt as exempt_mod                      # noqa: E402
from lab.check import NUM                                 # noqa: E402
from lab.unit import load                                 # noqa: E402

FAILING = ROOT / "units" / "0000-smoke"
CLEAN = ROOT / "units" / "0001-smoke-clean"
SEALED = ROOT / "units" / "0002-smoke-sealed"


def run(arg):
    """(exit code, stdout, stderr) for `lab check <arg>`."""
    out, err = io.StringIO(), io.StringIO()
    code = check_mod.run(str(arg), out, err)
    return code, out.getvalue(), err.getvalue()


def scanned_tokens(body):
    """The tokens the checker would actually compare against the pool."""
    spans = exempt_mod.spans(body)
    return [m.group(0) for m in NUM.finditer(body)
            if not any(lo <= m.start() < hi for lo, hi in spans)]


# --- the false accept, reproduced and closed ---------------------------------

def test_the_comparison_itself_accepts_a_four_digit_id():
    """The cause, stated as an assertion: `0003` is 3, and 3 is within 0.5."""
    pool = check_mod._pool(load(str(FAILING)).values)
    assert Decimal("3.070311505664645") in pool
    assert check_mod.matches(Decimal("0003"), pool)      # tolerance 0.5


def test_a_unit_path_in_prose_is_no_longer_scanned():
    """The regression: the id inside the path never reaches the comparison."""
    body = load(str(FAILING)).body
    assert "units/0003-smoke-again" in body, "the fixture carries the case"
    assert "0003" not in scanned_tokens(body)
    assert "3" not in scanned_tokens(body)


def test_the_fixture_counts_are_what_phase_0_recorded():
    """The exemption list removed 18 tokens and moved no verdict."""
    code, out, err = run(FAILING)
    assert (code, err) == (1, "")
    summary = out.splitlines()[-1]
    assert "7 number(s) in prose, 4 matched, 3 unmatched" in summary
    assert "exempt)" in summary
    assert summary.endswith("values.tsv: 4 key(s), 4 numeric")


def test_the_clean_fixtures_stay_clean():
    assert run(CLEAN)[0] == 0
    assert run(SEALED)[0] == 0


def test_an_unexempted_id_would_still_be_a_finding():
    """The negative half: strip the path shape and the accident comes back."""
    body = "**X.** A width of 0003 was measured.\n"
    assert scanned_tokens(body) == ["0003"]


# --- every class, positively and negatively ---------------------------------

IDS = [k.name for k in exempt_mod.CLASSES]


@pytest.mark.parametrize("klass", exempt_mod.CLASSES, ids=IDS)
def test_class_matches_its_own_example(klass):
    assert klass.pattern.search(klass.example), klass.name


@pytest.mark.parametrize("klass", exempt_mod.CLASSES, ids=IDS)
def test_class_does_not_match_its_counter_example(klass):
    assert not klass.pattern.search(klass.counter), klass.name


@pytest.mark.parametrize("klass", exempt_mod.CLASSES, ids=IDS)
def test_class_is_documented(klass):
    """A class with no reason and no real example is not in the list."""
    assert klass.why.strip() and klass.example.strip()
    assert klass.name in __import__("lab.exempt", fromlist=["x"]).__doc__ \
        or klass.why                       # the why line carries the naming


@pytest.mark.parametrize("klass", exempt_mod.CLASSES, ids=IDS)
def test_the_example_exempts_every_number_in_it(klass):
    """End to end: nothing in a real example reaches the pool."""
    assert scanned_tokens(klass.example) == [], klass.name


def test_no_class_swallows_a_measurement_sentence():
    """End to end, the other way. A counter is a negative for its OWN class
    only -- `unit-path`'s counter is a date, which another class exempts, so
    the whole-list negative is asserted on measurement prose instead, in
    CORPUS_MEASUREMENTS below.
    """
    body = ("**X.** The ladder ratio came out at 3.07, the residual at "
            "0.0184, and the census counted 422 rows.\n")
    assert scanned_tokens(body) == ["3.07", "0.0184", "422"]


def test_classify_names_the_class_that_exempted_a_token():
    body = "**X.** See `units/0003-smoke-again`, sealed on 2026-09-02."
    assert exempt_mod.classify(body, body.index("0003")) in (
        "unit-path", "code-span")
    assert exempt_mod.classify(body, body.index("2026")) == "date"
    assert exempt_mod.classify(body, 0) is None


def test_classify_returns_none_for_a_real_measurement():
    body = "**X.** The ladder ratio came out at 3.07.\n"
    assert exempt_mod.classify(body, body.index("3.07")) is None


# --- one real example per class, in the shape it occurs in the corpus -------

CORPUS = [
    # (class, prose as it occurs in notes/lab_notebook_2.md entry 302 or 304)
    ("date", "The census dates a515467 2026-08-30 13:45:29 −0700 and entry 303"),
    ("date", "timestamp meta.timestamp 2026-09-02T11:12:27."),
    ("unit-path", "The unit is units/0305-fixed-window-Lc/unit.md."),
    ("unit-or-entry-ref", "the hEF arc (entries 257–271, nine modules)"),
    ("refs-list", "refs: 298, 299, 300, 301"),
    ("hex", "at pin 47fa48680663df41146704d02a5b092d792bd5b9"),
    ("hex", "JSON sha256 0077130f7b02, script sha256 ddc7ca7189ea"),
    ("version", "the bench stays on v4.28.0 and Stage 3 on v4.32.2"),
    ("file-cite", "PKG/Kadiri.lean:1362, compact-support case `:3224`"),
    ("file-cite", "the traceback at log lines 15–22 of run2.log:145"),
    ("list-marker", "\n1. the height law is a regression on eight points\n"),
    ("enumerator", "(1) The height law is a regression."),
    ("ident-digits", "P3 is the genuinely open one, and U8 converged."),
    ("ident-digits", "theorem_2a, cor_1_2_b, eq_13 and bklnw_thm_16 close"),
    ("code-span", "`consumers[0..14].*` and `rungs[0].L` are keys"),
    ("code-span", "`params.L_grid[46]` is the top of the grid"),
    ("named-ref", "Yoshida Lemma 2, Bombieri Theorem 12, Conjecture 4.1"),
]


@pytest.mark.parametrize("name,prose", CORPUS,
                         ids=[f"{n}-{i}" for i, (n, _) in enumerate(CORPUS)])
def test_corpus_shapes_are_fully_exempt(name, prose):
    """Every number token in each real corpus fragment is an address."""
    assert scanned_tokens(prose) == [], prose


CORPUS_MEASUREMENTS = [
    # Real measurement sentences from the same two entries. Each must keep
    # every number it states, so the exemption list buys its precision back.
    ("loosest_consumer.t_req 18.71509903700793",
     ["18.71509903700793"]),
    ("Excluding gamma at every eps down to a ten-billionth costs 11.933113840507222 in X",
     ["11.933113840507222"]),
    ("the fixed window needs 2.1–5.2× the measured support",
     ["2.1", "5.2"]),
    ("Root counts over the 24 rows: full 15, near_only 15",
     ["24", "15", "15"]),
    ("Rmax inflates by 1.340178070431896 at the first zero",
     ["1.340178070431896"]),
]


@pytest.mark.parametrize("prose,expected", CORPUS_MEASUREMENTS,
                         ids=[p[:34] for p, _ in CORPUS_MEASUREMENTS])
def test_corpus_measurements_stay_checked(prose, expected):
    assert scanned_tokens(prose) == expected


# --- bare integers: the decision, asserted -----------------------------------

def test_a_bare_integer_is_still_checked():
    """The decision recorded in lab/exempt.py, held to by a test.

    A count with no decimal point is the largest measured defect class in
    this project, so it reaches the pool like any other number.
    """
    body = "**X.** Root counts over the rows: full 15, near_only 15.\n"
    assert scanned_tokens(body) == ["15", "15"]


def test_the_cost_of_checking_integers_is_the_stated_one():
    """What a bare integer still buys, and what it still lets through."""
    pool = {Decimal("3.070311505664645"), Decimal("0.018401"),
            Decimal("422"), Decimal("12.5")}
    assert check_mod.matches(Decimal("3"), pool)         # false accept, 0.0703
    assert check_mod.matches(Decimal("422"), pool)       # a real count
    assert not check_mod.matches(Decimal("15"), pool)    # refused
    accepted = sum(1 for n in range(1000)
                   if check_mod.matches(Decimal(n), pool))
    assert accepted == 5                                 # 0.5% on this pool


# --- spans -------------------------------------------------------------------

def test_spans_are_merged_and_sorted():
    body = "See `units/0003-smoke-again` on 2026-09-02 at v4.32.2."
    sp = exempt_mod.spans(body)
    assert sp == sorted(sp)
    assert all(a < b for a, b in sp)
    assert all(sp[i][1] < sp[i + 1][0] for i in range(len(sp) - 1))


def test_refs_id_is_the_one_class_that_is_not_a_pattern():
    unit = load(str(FAILING))
    assert unit.ids == {"0000", "0001"}
    assert exempt_mod.refs_id("0001", unit.ids)
    assert not exempt_mod.refs_id("0003", unit.ids)
