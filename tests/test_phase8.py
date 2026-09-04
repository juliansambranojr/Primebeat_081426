"""Phase 8 — quote gate.

Verifies that check_quote_gate.py enforces the relay rule: every blockquote
and fenced code block in an assistant message must appear as an exact substring
of the preceding session transcript. Truncation via ellipsis is allowed;
each surviving segment must still match exactly.
"""

import json
import os
import importlib.util
from pathlib import Path

import pytest

PROJECT = Path(__file__).resolve().parent.parent
SETTINGS = PROJECT / ".claude" / "settings.json"
HOOKS_DIR = PROJECT / "utilities" / "hooks"
HOOK_PATH = HOOKS_DIR / "check_quote_gate.py"


# ── helpers ──────────────────────────────────────────────────────────

def _load_hook():
    """Import check_quote_gate.py as a module."""
    spec = importlib.util.spec_from_file_location(
        "check_quote_gate", HOOK_PATH
    )
    assert spec is not None, "check_quote_gate.py not loadable"
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


def _write_transcript(tmp_path, entries):
    """Write a JSONL transcript file from a list of dicts."""
    p = tmp_path / "transcript.jsonl"
    lines = []
    for e in entries:
        lines.append(json.dumps(e))
    p.write_text("\n".join(lines) + "\n")
    return str(p)


def _make_user_entry(text):
    return {
        "type": "user",
        "message": {
            "role": "user",
            "content": text,
        },
    }


def _make_assistant_entry(text):
    return {
        "type": "assistant",
        "message": {
            "role": "assistant",
            "content": [{"type": "text", "text": text}],
        },
    }


def _make_tool_result_entry(text):
    return {
        "type": "tool_result",
        "message": {
            "role": "user",
            "content": [{"type": "tool_result", "text": text}],
        },
    }


# ── 1. module importable ────────────────────────────────────────────

def test_hook_importable():
    mod = _load_hook()
    assert hasattr(mod, "build_corpus"), "missing build_corpus function"
    assert hasattr(mod, "extract_quotes"), "missing extract_quotes function"


# ── 2. env var escape ───────────────────────────────────────────────

def test_env_var_escape(tmp_path, monkeypatch):
    """With PB_NOQUOTE=1, hook allows everything."""
    monkeypatch.setenv("PB_NOQUOTE", "1")
    mod = _load_hook()

    # Build a transcript where the quote does NOT match — should still allow.
    tp = _write_transcript(tmp_path, [
        _make_user_entry("hello world"),
        _make_assistant_entry("> this quote is fabricated entirely"),
    ])
    result = mod.run_hook(tp, stop_hook_active=False)
    assert result is None, "PB_NOQUOTE=1 should allow everything"


# ── 3. no quotes in message ────────────────────────────────────────

def test_no_quotes_allows(tmp_path):
    mod = _load_hook()
    tp = _write_transcript(tmp_path, [
        _make_user_entry("hello world"),
        _make_assistant_entry("Plain text, no quotes at all."),
    ])
    result = mod.run_hook(tp, stop_hook_active=False)
    assert result is None


# ── 4. blockquote matches corpus ────────────────────────────────────

def test_blockquote_matches(tmp_path):
    mod = _load_hook()
    tp = _write_transcript(tmp_path, [
        _make_user_entry("The alpha depth is 0.9375 at N=1000."),
        _make_assistant_entry("> The alpha depth is 0.9375 at N=1000."),
    ])
    result = mod.run_hook(tp, stop_hook_active=False)
    assert result is None


# ── 5. blockquote NOT in corpus ─────────────────────────────────────

def test_blockquote_not_in_corpus(tmp_path):
    mod = _load_hook()
    tp = _write_transcript(tmp_path, [
        _make_user_entry("The alpha depth is 0.9375 at N=1000."),
        _make_assistant_entry("> The alpha depth is 0.9999 at N=2000."),
    ])
    result = mod.run_hook(tp, stop_hook_active=False)
    assert result is not None
    assert result["decision"] == "block"
    assert "Quote gate" in result["reason"]


# ── 6. fenced block matches corpus ─────────────────────────────────

def test_fenced_block_matches(tmp_path):
    mod = _load_hook()
    tp = _write_transcript(tmp_path, [
        _make_user_entry("result = compute(42)"),
        _make_assistant_entry("Here:\n```\nresult = compute(42)\n```"),
    ])
    result = mod.run_hook(tp, stop_hook_active=False)
    assert result is None


# ── 7. fenced block NOT in corpus ───────────────────────────────────

def test_fenced_block_not_in_corpus(tmp_path):
    mod = _load_hook()
    tp = _write_transcript(tmp_path, [
        _make_user_entry("result = compute(42)"),
        _make_assistant_entry("Here:\n```\nresult = compute(99)\n```"),
    ])
    result = mod.run_hook(tp, stop_hook_active=False)
    assert result is not None
    assert result["decision"] == "block"


# ── 8. ellipsis truncation (match) ──────────────────────────────────

def test_ellipsis_match(tmp_path):
    mod = _load_hook()
    tp = _write_transcript(tmp_path, [
        _make_user_entry("The quick brown fox jumps over the lazy dog"),
        _make_assistant_entry("> The quick brown fox ... the lazy dog"),
    ])
    result = mod.run_hook(tp, stop_hook_active=False)
    assert result is None


# ── 9. ellipsis with failing segment ────────────────────────────────

def test_ellipsis_fail(tmp_path):
    mod = _load_hook()
    tp = _write_transcript(tmp_path, [
        _make_user_entry("The quick brown fox jumps over the lazy dog"),
        _make_assistant_entry("> The quick brown fox ... the lazy cat"),
    ])
    result = mod.run_hook(tp, stop_hook_active=False)
    assert result is not None
    assert result["decision"] == "block"


# ── 10. empty fenced block ─────────────────────────────────────────

def test_empty_fenced_block(tmp_path):
    mod = _load_hook()
    tp = _write_transcript(tmp_path, [
        _make_user_entry("some context"),
        _make_assistant_entry("Empty block:\n```\n\n```\nDone."),
    ])
    result = mod.run_hook(tp, stop_hook_active=False)
    assert result is None


# ── 11. multiple quotes, all match ──────────────────────────────────

def test_multiple_quotes_all_match(tmp_path):
    mod = _load_hook()
    tp = _write_transcript(tmp_path, [
        _make_user_entry("alpha is 0.5\nbeta is 0.7"),
        _make_assistant_entry(
            "> alpha is 0.5\n\n> beta is 0.7"
        ),
    ])
    result = mod.run_hook(tp, stop_hook_active=False)
    assert result is None


# ── 12. multiple quotes, one fails ──────────────────────────────────

def test_multiple_quotes_one_fails(tmp_path):
    mod = _load_hook()
    tp = _write_transcript(tmp_path, [
        _make_user_entry("alpha is 0.5"),
        _make_assistant_entry(
            "> alpha is 0.5\n\n> gamma is 0.3"
        ),
    ])
    result = mod.run_hook(tp, stop_hook_active=False)
    assert result is not None
    assert result["decision"] == "block"
    assert "gamma is 0.3" in result["reason"]


# ── 13. whitespace preserved ───────────────────────────────────────

def test_whitespace_preserved(tmp_path):
    """A quote that would match if whitespace were normalized but doesn't
    match as-written should block."""
    mod = _load_hook()
    tp = _write_transcript(tmp_path, [
        _make_user_entry("col1  col2  col3"),
        _make_assistant_entry("> col1 col2 col3"),  # single spaces vs double
    ])
    result = mod.run_hook(tp, stop_hook_active=False)
    assert result is not None
    assert result["decision"] == "block"


# ── 14. loop guard ─────────────────────────────────────────────────

def test_loop_guard(tmp_path):
    mod = _load_hook()
    tp = _write_transcript(tmp_path, [
        _make_user_entry("hello"),
        _make_assistant_entry("> fabricated quote not in corpus"),
    ])
    result = mod.run_hook(tp, stop_hook_active=True)
    assert result is not None
    assert "systemMessage" in result
    assert "decision" not in result


# ── 15. settings.json has the hook ─────────────────────────────────

def test_settings_has_quote_gate():
    data = json.loads(SETTINGS.read_text())
    hooks_section = data.get("hooks", {})
    stop_hooks = hooks_section.get("Stop", [])
    all_commands = []
    for block in stop_hooks:
        for hook in block.get("hooks", []):
            all_commands.append(hook.get("command", ""))
    assert any("check_quote_gate" in cmd for cmd in all_commands), (
        f"check_quote_gate not found in Stop hooks: {all_commands}"
    )
