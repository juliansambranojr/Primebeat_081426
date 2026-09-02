#!/usr/bin/env python3
"""PreToolUse hook (matcher "Bash"): shell routes around the guards are denied.

Denies a Bash command that
  1. contains `--no-verify`            (skips utilities/hooks/pre-commit)
  2. contains `core.hooksPath`         (re-points git at other hooks)
  3. runs `rm` with -r or -f (any spelling: -rf, -fr, -r -f, --recursive,
     --force) aimed at a protected path, or at a directory holding one
  4. redirects into a protected path: `>` / `>>` (also 1>, 2>, &>, and the
     attached form `>file`), `tee [-a] file`, `sed -i[.suffix] ... file`
  5. mentions `.approve` at all — the flags are Julian's to create from
     his terminal; a command that can `touch` one can approve itself.
     No bypass for this case.

"Protected" is check_protected_write.py's `protected()` — the two guards
share one definition: commitment files, `files (2)/`, `results/*.json`,
`*.log`, locked preregs, `utilities/hooks/*`, `.claude/settings*.json`.

Bypass, one use each, keyed on the target's basename exactly as the write
guard is: `<repo>/.approve/<basename>` allows the command and is deleted.
For the two flag-less cases the key is the flag text itself:
`.approve/no-verify` and `.approve/core.hooksPath`.

Relative paths are resolved against the hook input's `cwd`, then the repo
root. `cp`, `mv`, `python -c "open(..., 'w')"` and heredocs are not
parsed here; the Edit/Write guard is the primary wall and this closes the
shell shapes that were reached for in practice.

Protocol (identical to check_direct_run.py): stdin is the PreToolUse JSON
with tool_name / tool_input; exit 0 allows, exit 2 denies with the reason
on stderr. Fails open on unparseable input.

    --selftest    canned commands: each denied shape, and allowed
                  look-alikes; exits 0 when all behave.
"""
import json
import os
import pathlib
import re
import shlex
import sys

HERE = pathlib.Path(__file__).resolve().parent
ROOT = HERE.parent.parent
sys.path.insert(0, str(HERE))
from check_protected_write import protected, consume_flag, flag_for, APPROVE   # noqa: E402

REDIRECT = re.compile(r"^(?:>>?|&>>?|>&)$")
PRUNE = {".git", ".venv", ".lake", "__pycache__", "node_modules"}
SEPARATORS = {";", "&&", "||", "|", "&", "(", ")", ";;", "|&", "\n"}


def resolve(target, cwd):
    p = pathlib.Path(os.path.expanduser(target))
    if not p.is_absolute():
        p = pathlib.Path(cwd or ROOT) / p
    return pathlib.Path(os.path.normpath(p))


def dir_holds_protected(d):
    """First protected file under directory d, walking with pruning; or None."""
    try:
        rel = pathlib.Path(os.path.normpath(d)).relative_to(ROOT)
    except (ValueError, OSError):
        return None
    if str(rel) == ".":
        return str(ROOT / "CLAUDE.md")
    if any(part in PRUNE for part in rel.parts):
        return None                      # lean/.lake, .venv: nothing protected, huge
    for dirpath, dirnames, filenames in os.walk(d):
        dirnames[:] = [x for x in dirnames if x not in PRUNE]
        for fn in filenames:
            fp = os.path.join(dirpath, fn)
            if protected(fp):
                return fp
    return None


def target_reason(target, cwd):
    """(display path, why) if the target is protected or holds a protected file."""
    p = resolve(target, cwd)
    why = protected(str(p))
    if why:
        return str(p), why
    if p.is_dir():
        hit = dir_holds_protected(p)
        if hit:
            return str(p), f"directory holds {os.path.relpath(hit, ROOT)} ({protected(hit)})"
    return None


def tokens(cmd):
    """Words with shell operators split out: `foo;` -> `foo`, `;` and `>x` -> `>`, `x`.

    punctuation_chars makes runs of `;&|<>()` their own tokens, so `2>` is
    `2`, `>` and `&&` stays whole. A newline is kept as its own separator
    token so a multi-line command's `rm` target list ends at the line."""
    try:
        lex = shlex.shlex(cmd, posix=True, punctuation_chars=True)
        lex.whitespace = " \t\r"
        lex.whitespace_split = True
        return list(lex)
    except ValueError:
        return cmd.replace("\n", " ; ").split()


def rm_targets(toks):
    """Targets of every `rm` carrying -r or -f, in the command's word list."""
    out = []
    i = 0
    while i < len(toks):
        if toks[i] in ("rm", "/bin/rm", "sudo") and (toks[i] != "sudo" or
                                                     (i + 1 < len(toks) and toks[i + 1] == "rm")):
            if toks[i] == "sudo":
                i += 1
            j = i + 1
            forceful, targets = False, []
            while j < len(toks) and toks[j] not in SEPARATORS:
                t = toks[j]
                if t == "--":
                    k = j + 1
                    while k < len(toks) and toks[k] not in SEPARATORS:
                        targets.append(toks[k])
                        k += 1
                    j = k
                    break
                if t.startswith("--"):
                    forceful |= t in ("--recursive", "--force")
                elif t.startswith("-") and len(t) > 1:
                    forceful |= any(c in "rRf" for c in t[1:])
                else:
                    targets.append(t)
                j += 1
            if forceful:
                out += targets
            i = j
        else:
            i += 1
    return out


def redirect_targets(toks):
    out = []
    i = 0
    while i < len(toks):
        t = toks[i]
        if REDIRECT.match(t):
            if i + 1 < len(toks) and toks[i + 1] not in SEPARATORS:
                out.append(toks[i + 1])
                i += 1
        elif t == "tee":
            j = i + 1
            while j < len(toks) and toks[j] not in SEPARATORS:
                if not toks[j].startswith("-"):
                    out.append(toks[j])
                j += 1
            i = j - 1
        elif t == "sed":
            j = i + 1
            inplace, script_seen, args = False, False, []
            while j < len(toks) and toks[j] not in SEPARATORS:
                a = toks[j]
                if a.startswith("-i") or a == "--in-place":
                    inplace = True
                elif a in ("-e", "--expression", "-f", "--file"):
                    script_seen = True
                    j += 1
                elif a.startswith("-"):
                    pass
                elif not script_seen:
                    script_seen = True
                else:
                    args.append(a)
                j += 1
            if inplace:
                out += args
            i = j - 1
        i += 1
    return out


def verdict(cmd, cwd=None):
    """None to allow (consuming a flag if needed), else the denial text."""
    if not cmd.strip():
        return None
    if ".approve" in cmd:
        return ("Command denied by check_bash_guard.py: it mentions `.approve`. "
                "Approval flags are created by Julian from his own terminal "
                "(touch .approve/<basename>); no command run from here may "
                "create, list or remove one.")
    for needle, key in (("--no-verify", "no-verify"), ("core.hooksPath", "core.hooksPath")):
        if needle in cmd:
            if consume_flag(key):
                sys.stderr.write(f"check_bash_guard: consumed {APPROVE / key}\n")
                continue
            return (f"Command denied by check_bash_guard.py: it contains `{needle}`, "
                    f"which routes around the git floor. Julian allows it once "
                    f"with:  touch {APPROVE / key}")
    toks = tokens(cmd)
    hits = []
    for kind, targets in (("rm", rm_targets(toks)), ("redirect", redirect_targets(toks))):
        for t in targets:
            if not t or t in SEPARATORS or t.startswith("/dev/") or t.isdigit():
                continue
            r = target_reason(t, cwd)
            if r:
                hits.append((kind, t) + r)
    if not hits:
        return None
    denied = []
    for kind, raw, shown, why in hits:
        if consume_flag(shown):
            sys.stderr.write(f"check_bash_guard: consumed {flag_for(shown)}\n")
            continue
        denied.append((kind, raw, shown, why))
    if not denied:
        return None
    lines = ["Command denied by check_bash_guard.py:"]
    for kind, raw, shown, why in denied:
        lines.append(f"  {kind} -> {raw}  ({why})")
        lines.append(f"    Julian allows one use with:  touch {flag_for(shown)}")
    return "\n".join(lines)


def selftest():
    R = str(ROOT)
    cases = [
        ("git commit --no-verify -m x", True),
        ("git config core.hooksPath utilities/hooks", True),
        (f"rm -rf '{R}/files (2)'", True),
        ("rm -r results", True),
        ("rm -f results/O47_x.json", True),
        ("rm --force CLAUDE.md", True),
        ("rm -rf preregs", True),
        ("rm -rf .claude", True),
        ("rm analysis/2026-09-01/scratch/tmp.py", False),          # no -r/-f
        ("rm -rf analysis/2026-09-01/scratch/__pycache__", False),
        ("echo x > CONTEXT.md", True),
        ("echo x >>REFERENCES.md", True),
        ("echo x >CLAUDE.md", True),
        ("python3 a.py 2> results/O8_run.log", True),
        ("python3 a.py | tee -a results/O5.log", True),
        ("sed -i '' 's/a/b/' CLAUDE.md", True),
        ("sed -i.bak -e 's/a/b/' utilities/hooks/pre-commit", True),
        ("sed -n '1,5p' CLAUDE.md", False),
        ("echo x > analysis/2026-09-01/scratch/out.txt", False),
        ("cat CLAUDE.md | head", False),
        ("python3 utilities/check_refs.py > /dev/null", False),
        ("cmd 2>&1 | tail -2", False),
        ("rm -f scratch/tmp.txt; git status", False),              # `;` ends the target list
        ("rm -f scratch/tmp.txt\ngit status", False),              # so does a newline
        ("rm -f scratch/tmp.txt; echo done > CONTEXT.md", True),
        ("grep -rn 'core.hooksPath' .", True),                    # substring rule, by design
        ("touch .approve/CLAUDE.md", True),                       # no bypass
        ("ls .approve", True),
    ]
    ok = True
    for cmd, want in cases:
        got = verdict(cmd, R) is not None
        ok &= got == want
        print(f"{'deny ' if got else 'allow'}  {'ok ' if got == want else 'BAD'}  {cmd!r}")
    APPROVE.mkdir(exist_ok=True)
    (APPROVE / "no-verify").touch()
    r = verdict("git commit --no-verify -m x", R)
    gone = not (APPROVE / "no-verify").exists()
    ok &= r is None and gone
    print(f"flag   {'ok ' if r is None and gone else 'BAD'}  --no-verify allowed once, .approve/no-verify consumed")
    print("selftest", "OK" if ok else "FAILED")
    return 0 if ok else 1


def main():
    if "--selftest" in sys.argv:
        sys.exit(selftest())
    try:
        payload = json.load(sys.stdin)
    except Exception:
        sys.exit(0)
    if payload.get("tool_name") not in (None, "Bash"):
        sys.exit(0)
    cmd = (payload.get("tool_input") or {}).get("command", "")
    why = verdict(cmd, payload.get("cwd"))
    if why is None:
        sys.exit(0)
    sys.stderr.write(why + "\n")
    sys.exit(2)


if __name__ == "__main__":
    main()
