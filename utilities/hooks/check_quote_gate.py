#!/usr/bin/env python3
"""Stop hook: every blockquote and fenced code block in an assistant message
must appear as an exact substring of the preceding session transcript.

Implements the relay rule from lab_design.md § Transcript is king. A quote
that uses ellipsis (... or …) is split on the delimiter; each surviving
segment must still match exactly. Whitespace is compared as written, not
normalised.

Stdin: hook JSON with transcript_path and stop_hook_active.
Stdout on violation: {"decision": "block", "reason": ...}.
Exit 0 always; failing open on any parse error is deliberate.
"""

import json
import os
import re
import sys


def build_corpus(entries):
    """Build a single string from all transcript entries BEFORE the last
    assistant message. Every text surface is included: user messages, prior
    assistant messages, tool results, system messages."""
    parts = []

    # Find the index of the last assistant message.
    last_asst_idx = None
    for i, entry in enumerate(entries):
        msg = entry.get("message") or {}
        if entry.get("type") == "assistant" or msg.get("role") == "assistant":
            last_asst_idx = i

    # Include everything before that index.
    limit = last_asst_idx if last_asst_idx is not None else len(entries)

    for entry in entries[:limit]:
        msg = entry.get("message") or {}
        content = msg.get("content")
        _extract_text(content, parts)
        # Tool input/result at entry level.
        for field in ("tool_input", "tool_result"):
            val = entry.get(field) or msg.get(field)
            if isinstance(val, str):
                parts.append(val)
            elif isinstance(val, dict):
                # tool_input can be a dict; serialise it.
                parts.append(json.dumps(val))

    return "\n".join(parts)


def _extract_text(content, parts):
    """Extract all text from a content value (string, list of blocks, etc.)."""
    if isinstance(content, str):
        parts.append(content)
    elif isinstance(content, list):
        for block in content:
            if isinstance(block, str):
                parts.append(block)
            elif isinstance(block, dict):
                if block.get("type") == "text":
                    parts.append(block.get("text", ""))
                # tool_result blocks.
                text_val = block.get("text")
                if text_val and block.get("type") != "text":
                    parts.append(text_val)
                # Recurse into nested content.
                nested = block.get("content")
                if nested:
                    _extract_text(nested, parts)


def extract_quotes(text):
    """Extract blockquote paragraphs and fenced code block contents from
    the assistant's message text. Returns a list of quote strings."""
    quotes = []
    lines = text.split("\n")
    i = 0
    while i < len(lines):
        line = lines[i]

        # Fenced code block: opening ```.
        if line.strip().startswith("```"):
            block_lines = []
            i += 1
            while i < len(lines):
                if lines[i].strip().startswith("```"):
                    i += 1
                    break
                block_lines.append(lines[i])
                i += 1
            block_text = "\n".join(block_lines)
            if block_text.strip():
                quotes.append(block_text)
            continue

        # Blockquote paragraph: consecutive lines starting with `> `.
        if line.startswith("> "):
            bq_lines = []
            while i < len(lines) and lines[i].startswith("> "):
                bq_lines.append(lines[i][2:])  # strip `> ` prefix
                i += 1
            bq_text = "\n".join(bq_lines)
            if bq_text.strip():
                quotes.append(bq_text)
            continue

        i += 1

    return quotes


def check_quote(quote, corpus):
    """Check a single quote against the corpus. Returns None on match,
    or the failing segment string on mismatch."""
    # Split on ellipsis markers.
    segments = re.split(r'\.\.\.|…', quote)

    for seg in segments:
        seg = seg.strip()
        if not seg:
            continue
        if seg not in corpus:
            return seg

    return None


def run_hook(transcript_path, stop_hook_active=False):
    """Core logic, separated from stdin/stdout for testability.

    Returns None to allow, or a dict to print as the hook response.
    """
    if os.environ.get("PB_NOQUOTE") == "1":
        return None

    entries = []
    with open(transcript_path, encoding="utf-8") as fh:
        for line in fh:
            line = line.strip()
            if not line:
                continue
            try:
                entries.append(json.loads(line))
            except json.JSONDecodeError:
                continue

    if not entries:
        return None

    # Find the last assistant message text.
    last_text = None
    for entry in entries:
        msg = entry.get("message") or {}
        if entry.get("type") != "assistant" or msg.get("role") != "assistant":
            continue
        content = msg.get("content")
        if isinstance(content, str):
            blocks = [content]
        elif isinstance(content, list):
            blocks = [
                b.get("text", "")
                for b in content
                if isinstance(b, dict) and b.get("type") == "text"
            ]
        else:
            continue
        joined = "\n".join(b for b in blocks if b).strip()
        if joined:
            last_text = joined

    if last_text is None:
        return None

    quotes = extract_quotes(last_text)
    if not quotes:
        return None

    corpus = build_corpus(entries)

    for quote in quotes:
        fail = check_quote(quote, corpus)
        if fail is not None:
            if stop_hook_active:
                return {
                    "systemMessage":
                        "check_quote_gate: a quote still has no transcript "
                        "match after one block; letting it through."
                }
            truncated = fail[:120]
            return {
                "decision": "block",
                "reason":
                    f"Quote gate: no transcript match for: {truncated}",
            }

    return None


def main():
    try:
        payload = json.load(sys.stdin)
        transcript_path = payload.get("transcript_path")
        if not transcript_path:
            return
        result = run_hook(
            transcript_path,
            stop_hook_active=payload.get("stop_hook_active", False),
        )
        if result is not None:
            print(json.dumps(result))
    except Exception:
        return


if __name__ == "__main__":
    main()
