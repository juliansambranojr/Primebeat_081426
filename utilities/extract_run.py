#!/usr/bin/env python3
"""Stage a notebook entry from the transcript window around a script run.

  python3 utilities/extract_run.py t23_fold.py            # newest run
  python3 utilities/extract_run.py t23_fold.py --all      # every run
  python3 utilities/extract_run.py t23_fold.py --out FILE

Anchors on the tool_use that ACTUALLY EXECUTED the script -- not every mention.
A script is discussed for hours; it runs in seconds. The window closes at the
next human turn, which is what bounds one exchange.

Output is a DRAFT. `type:` is left for a human to choose from the seven in
notes/notes_format.md; the extractor does not guess it.
"""
import json, re, sys, pathlib, argparse

ROOT = pathlib.Path(__file__).resolve().parent.parent
SELF = pathlib.Path(__file__).name

def transcript():
    slug = re.sub(r"[/_]", "-", str(ROOT))
    d = pathlib.Path.home() / ".claude/projects" / slug
    js = sorted(d.glob("*.jsonl"), key=lambda p: p.stat().st_size, reverse=True)
    if not js: sys.exit(f"no transcript under {d}")
    return js[0]

def blocks(rec):
    return [b for b in (rec.get("message") or {}).get("content") or [] if isinstance(b, dict)]

def next_entry_no():
    hi = 0
    for v in ("lab_notebook.md", "lab_notebook_2.md"):
        f = ROOT / "notes" / v
        if not f.exists(): continue
        body = re.sub(r"```.*?```", "", f.read_text(), flags=re.S)
        for m in re.finditer(r"^## \d{4}-\d\d-\d\d — Entry (\d+)", body, re.M):
            hi = max(hi, int(m.group(1)))
    return hi + 1

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("script"); ap.add_argument("--all", action="store_true")
    ap.add_argument("--transcript"); ap.add_argument("--out")
    ap.add_argument("--append", metavar="FILE",
                    help="prepend a reviewed draft into notes/lab_notebook_2.md")
    a = ap.parse_args()

    recs = []
    for line in open(a.transcript or transcript()):
        try: recs.append(json.loads(line))
        except Exception: pass

    runs = []
    for i, r in enumerate(recs):
        for b in blocks(r):
            if b.get("type") != "tool_use": continue
            cmd = str(b.get("input", {}).get("command", ""))
            if SELF in cmd: continue                       # never extract itself
            # the script must be what the interpreter INVOKES, not a string inside it
            if re.search(r"(?:python3?\s+|\./|bash\s+)\S*" + re.escape(a.script) + r"\b", cmd):
                runs.append((i, r.get("timestamp", "")[:19], cmd))
    if not runs: sys.exit(f"no execution of {a.script} found in the transcript")

    def window_end(i):
        j = i + 1
        while j < len(recs):
            r = recs[j]
            if r.get("type") == "user" and not any(
                    b.get("type") == "tool_result" for b in blocks(r)): return j
            j += 1
        return len(recs)
    clusters, seen = [], -1
    for i, ts, _ in runs:
        if i <= seen: continue                              # already inside a window
        clusters.append((i, ts)); seen = window_end(i)
    if not a.all: clusters = clusters[-1:]

    chunks = []
    for idx, (i, ts) in enumerate(clusters):
        cmds, outs, prose, arts = [], [], [], set()
        j = i
        while j < len(recs):
            r = recs[j]
            if j > i and r.get("type") == "user" and not any(
                    b.get("type") == "tool_result" for b in blocks(r)):
                break                                       # next human turn
            for b in blocks(r):
                t = b.get("type")
                if t == "tool_use":
                    c = str(b.get("input", {}).get("command", ""))
                    if c and SELF not in c:
                        cmds.append(c.strip())
                        for x in re.findall(r"[\w/.\-]*[\w\-]+\.(?:txt|json|csv|log)", c):
                            x = x.replace(str(ROOT) + "/", "").lstrip("./")
                            if x.startswith("/"): continue
                            if (ROOT / x).exists(): arts.add(x)          # only what resolves
                elif t == "tool_result":
                    c = b.get("content")
                    s = c if isinstance(c, str) else " ".join(
                        x.get("text", "") for x in c if isinstance(x, dict))
                    if s.strip(): outs.append(s.strip()[:1200])
                elif t == "text":
                    if b.get("text", "").strip(): prose.append(b["text"].strip())
            j += 1
        chunks.append((ts, cmds, outs, prose, sorted(arts)))

    n = next_entry_no()
    parts = []
    for k, (ts, cmds, outs, prose, arts) in enumerate(chunks):
        p = [f"## {ts[:10]} — Entry {n + k} — DRAFT: {a.script} run at {ts[11:]}",
             "type: <choose one of the seven — notes/notes_format.md>", "refs:", ""]
        p += ["Commands:", "", "```bash"] + cmds + ["```", ""]
        if arts: p += ["Artifacts written or read:", ""] + [f"- `{x}`" for x in arts] + [""]
        if outs: p += ["Output:", "", "```text", *outs, "```", ""]
        if prose: p += ["Reading at the time (verbatim — verify every number "
                        "against the artifact before this lands):", ""] + prose + [""]
        p += [f"`{a.script}" + ("".join(f" · {x}" for x in arts) if arts else "") + "`", ""]
        parts.append("\n".join(p))
    text = ("\n---\n\n".join(parts))
    if a.append:
        draft = pathlib.Path(a.append).read_text()
        if "<choose one of the seven" in draft:
            sys.exit("refusing: `type:` is still unchosen. Pick one from "
                     "notes/notes_format.md, and drop the DRAFT marker, first.")
        if "DRAFT:" in draft:
            sys.exit("refusing: the DRAFT marker is still in the header.")
        nb = ROOT / "notes/lab_notebook_2.md"
        body = nb.read_text()
        i = body.index("\n## ")                       # newest at top, after the header
        nb.write_text(body[:i] + "\n" + draft.rstrip() + "\n" + body[i:])
        print(f"appended -> {nb}")
    elif a.out:
        pathlib.Path(a.out).write_text(text); print(f"staged {len(chunks)} entr(ies) -> {a.out}")
    else:
        print(text)

main()
