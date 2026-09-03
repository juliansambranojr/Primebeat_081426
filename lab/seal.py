"""`lab seal <unit>` — write `UNIT.sha256` and flip `sealed: true`.

PHASE 1 of `analysis/2026-09-02/lab_design.md`. The design's § The unit
says a unit is "immutable once sealed", and its § Enforcement table makes
an overwritten result unwritable "because sealed units are immutable". This
command is the moment that becomes true of a directory; `lab check` is what
notices afterwards.

TWO REFUSALS.

  - A unit that fails `lab check` is not sealed. Sealing is a claim that
    the unit is finished and correct, and the invariant is what correct
    means here. Sealing a unit whose prose states a number with no evidence
    would freeze the defect and hand it the authority of a digest.
  - A unit whose front matter already says `sealed: true` is not re-sealed.
    Re-sealing is how a sealed unit would be quietly edited and re-blessed:
    change the prose, seal again, and the manifest agrees with the new
    bytes. The design's answer to a changed result is a NEW unit that
    `supersedes:` the old one, so this refuses and says so.

ORDER OF WRITES. `sealed: true` goes into `unit.md` FIRST, then the
manifest is computed over the unit as it then stands. The manifest
therefore records the sealed `unit.md`, and `lab check` recomputes the same
hash. Sealing in the other order would leave every sealed unit reporting
its own `unit.md` as changed.

DECISIONS taken here where the design is silent:

  - The front matter is rewritten through `lab.unit`'s parser and
    formatter, so a unit that cannot be written back losslessly is a unit
    that cannot be sealed. Key order is preserved; a unit with no `sealed`
    key gains one at the end.
  - The manifest format, what the digest hashes and why `values.tsv` enters
    it stably are `lab/digest.py`.
"""

from . import check as check_mod
from . import digest as digest_mod
from .unit import (
    UnitError,
    format_front_matter,
    load,
    parse_front_matter,
    split_front_matter,
)

__all__ = ["seal", "run"]


def _flip_sealed(md_path):
    """Rewrite `unit.md` with `sealed: true`. Returns the new text."""
    text = md_path.read_text(encoding="utf-8")
    fm_text, body = split_front_matter(text)
    front = parse_front_matter(fm_text)
    front["sealed"] = True
    new = "---\n" + format_front_matter(front) + "\n---\n" + body
    md_path.write_text(new, encoding="utf-8")
    return new


def seal(arg, out, cwd=None):
    """Seal one unit. Returns 0 sealed, 1 refused. Raises `UnitError`."""
    unit = load(arg, cwd=cwd)
    if unit.front_matter.get("sealed") is True:
        print(f"REFUSED    {unit.path} is already sealed; a changed result "
              f"is a new unit that supersedes this one", file=out)
        return 1
    code = check_mod.check(str(unit.path), out, cwd=cwd)
    if code != 0:
        print(f"REFUSED    {unit.path} does not pass `lab check`; a unit is "
              f"sealed once its prose has evidence", file=out)
        return 1
    _flip_sealed(unit.path / "unit.md")
    manifest = unit.path / digest_mod.MANIFEST
    manifest.write_text(digest_mod.render(unit.path), encoding="utf-8")
    files, _, unit_digest = digest_mod.parse(
        manifest.read_text(encoding="utf-8"))
    print(f"SEALED     {unit.path}: {len(files)} file(s), digest "
          f"{unit_digest}", file=out)
    return 0


def run(arg, out, err, cwd=None):
    """`lab seal <unit>`: 0 sealed, 1 refused, 2 unloadable."""
    try:
        return seal(arg, out, cwd=cwd)
    except (UnitError, digest_mod.DigestError) as exc:
        print(f"lab seal: {exc}", file=err)
        return 2
