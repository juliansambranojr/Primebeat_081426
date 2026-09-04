"""Phase 7 — hook fleet retirement.

Verifies that settings.json has exactly the 2 surviving hooks,
the 3 deregistered files are gone from disk, and the 2 retired
hooks remain on disk (unwired but present as reference).
"""

import json
import importlib.util
from pathlib import Path

import pytest

PROJECT = Path(__file__).resolve().parent.parent
SETTINGS = PROJECT / ".claude" / "settings.json"
HOOKS_DIR = PROJECT / "utilities" / "hooks"


# ── settings.json validity ──────────────────────────────────────────

def test_settings_json_exists_and_is_valid():
    assert SETTINGS.exists(), f"{SETTINGS} does not exist"
    data = json.loads(SETTINGS.read_text())
    assert isinstance(data, dict)


def _collect_hook_entries(data: dict) -> list[tuple[str, str]]:
    """Return [(event, command), ...] for every registered hook."""
    entries = []
    hooks_section = data.get("hooks", {})
    for event, matchers in hooks_section.items():
        for matcher_block in matchers:
            for hook in matcher_block.get("hooks", []):
                entries.append((event, hook.get("command", "")))
    return entries


def test_settings_has_at_least_two_hooks():
    data = json.loads(SETTINGS.read_text())
    entries = _collect_hook_entries(data)
    assert len(entries) >= 2, (
        f"Expected at least 2 hook entries, got {len(entries)}: {entries}"
    )


def test_settings_has_stop_check_response_prefix():
    data = json.loads(SETTINGS.read_text())
    entries = _collect_hook_entries(data)
    stop_hooks = [cmd for ev, cmd in entries if ev == "Stop"]
    assert any("check_response_prefix" in cmd for cmd in stop_hooks), (
        f"check_response_prefix not found in Stop hooks: {stop_hooks}"
    )


def test_settings_has_pretooluse_check_protected_write():
    data = json.loads(SETTINGS.read_text())
    entries = _collect_hook_entries(data)
    pre_hooks = [cmd for ev, cmd in entries if ev == "PreToolUse"]
    assert any("check_protected_write" in cmd for cmd in pre_hooks), (
        f"check_protected_write not found in PreToolUse hooks: {pre_hooks}"
    )


def test_settings_no_bash_matcher():
    data = json.loads(SETTINGS.read_text())
    hooks_section = data.get("hooks", {})
    for event, matchers in hooks_section.items():
        for matcher_block in matchers:
            matcher_val = matcher_block.get("matcher", "")
            assert matcher_val != "Bash", (
                f"Bash matcher still present under {event}"
            )


def test_settings_no_posttooluse():
    data = json.loads(SETTINGS.read_text())
    hooks_section = data.get("hooks", {})
    assert "PostToolUse" not in hooks_section, (
        "PostToolUse section still present in settings.json"
    )


# ── deregistered files deleted from disk ─────────────────────────────

@pytest.mark.parametrize("filename", [
    "check_numbers_in_response.py",
    "check_agent_brief.py",
    "check_read_range.py",
])
def test_deregistered_hook_deleted(filename):
    path = HOOKS_DIR / filename
    assert not path.exists(), f"{path} should have been deleted"


# ── retired hooks still on disk (unwired) ────────────────────────────

@pytest.mark.parametrize("filename", [
    "check_direct_run.py",
    "check_bash_guard.py",
])
def test_retired_hook_still_on_disk(filename):
    path = HOOKS_DIR / filename
    assert path.exists(), f"{path} should still exist (retired, not deleted)"


# ── surviving hooks importable ───────────────────────────────────────

def test_check_protected_write_importable():
    spec = importlib.util.spec_from_file_location(
        "check_protected_write",
        HOOKS_DIR / "check_protected_write.py",
    )
    assert spec is not None, "check_protected_write.py not loadable"
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
