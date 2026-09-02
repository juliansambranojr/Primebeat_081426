#!/usr/bin/env python3
"""Stop hook: every assistant response must open with the required prefix.

Set by Julian, 2026-09-01. The prefix is verified mechanically here, in the
harness, because a prose instruction proved unenforceable the same day
(stale-ledger incident; CLAUDE.md § Rule — load, don't recall, NOTEPAD
entry 182). A response that does not open with the prefix is blocked and
sent back with the reason; the loop guard lets a second failure through
rather than hanging the session.

Stdin: hook JSON with transcript_path and stop_hook_active.
Stdout on violation: {"decision": "block", "reason": ...}.
Exit 0 always; failing open on any parse error is deliberate — a broken
transcript must not brick the session.
"""

import json
import sys

REQUIRED_PREFIX = "I, Claude, am the asshole"


def last_assistant_text(transcript_path):
    text = None
    with open(transcript_path, encoding="utf-8") as fh:
        for line in fh:
            line = line.strip()
            if not line:
                continue
            try:
                entry = json.loads(line)
            except json.JSONDecodeError:
                continue
            msg = entry.get("message") or {}
            if entry.get("type") != "assistant" or msg.get("role") != "assistant":
                continue
            content = msg.get("content")
            if isinstance(content, str):
                blocks = [content]
            elif isinstance(content, list):
                blocks = [b.get("text", "") for b in content
                          if isinstance(b, dict) and b.get("type") == "text"]
            else:
                continue
            joined = "\n".join(b for b in blocks if b).strip()
            if joined:
                text = joined
    return text


def main():
    try:
        payload = json.load(sys.stdin)
        transcript_path = payload.get("transcript_path")
        if not transcript_path:
            return
        text = last_assistant_text(transcript_path)
        if text is None or text.startswith(REQUIRED_PREFIX):
            return
        if payload.get("stop_hook_active"):
            # Second failure in one stop cycle: let it through rather than
            # loop, but say so where the user can see it.
            print(json.dumps({
                "systemMessage":
                    "check_response_prefix: response still missing the "
                    "required prefix after one block; letting it through."
            }))
            return
        print(json.dumps({
            "decision": "block",
            "reason":
                "Response rejected by check_response_prefix.py: it must "
                f"begin with the exact line \"{REQUIRED_PREFIX}\". Re-issue "
                "the full response with that as the first line.",
        }))
    except Exception:
        return


if __name__ == "__main__":
    main()
