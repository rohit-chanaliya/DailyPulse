#!/usr/bin/env python3
"""PreToolUse guardrail: denies destructive shell commands for DailyPulse."""
import json
import re
import sys

RULES = [
    (
        r"\bfirebase\s+(firestore:delete|database:remove|auth:export)\b|\bfirebase\s+deploy\b",
        "Firebase data deletion or deploy is forbidden without an explicit user request. "
        "Ask the user to run it themselves.",
    ),
    (
        r"\b(release\.bat|gh\s+release\s+(create|delete))\b",
        "Publishing or deleting a GitHub release is forbidden unprompted.",
    ),
    (
        r"\b(cat|grep|egrep|rg|head|tail|more|less|strings|source|bat|sed|awk|cp|mv|scp)\b[^|;&]*"
        r"(\.env(\.[\w.-]+)?(?=\s|$|[\"'])|service[-_]?account[\w.-]*\.json)",
        "Reading or copying secret files (.env, service account JSON) via the terminal is forbidden.",
    ),
    (
        r"(^|[\s/])\.env(\.[\w.-]+)?\s*\|",
        "Piping .env contents to another command is forbidden.",
    ),
    (
        r"\bgit\s+reset\s+--hard\b",
        "'git reset --hard' destroys uncommitted work and is forbidden.",
    ),
    (
        r"\bgit\s+clean\s+(-[a-zA-Z]*f|--force)",
        "'git clean -f' is forbidden without explicit user permission.",
    ),
    (
        r"\bgit\s+(checkout|restore)\s+(--\s+)?\.(\s|$)",
        "Discarding all workspace changes is forbidden.",
    ),
    (
        r"\bgit\s+push\b.*(--force\b|--force-with-lease\b|\s-f(\s|$))",
        "'git push --force' is strictly forbidden.",
    ),
    (
        r"\bgit\s+stash\s+(drop|clear)\b",
        "Dropping stashes can lose the user's work and is forbidden.",
    ),
    (
        r"\brm\s+(-[a-zA-Z]*\s+)*-[a-zA-Z]*[rR][a-zA-Z]*\s+(-[a-zA-Z]+\s+)*"
        r"(/|~|\.|\.\.|\*|/home\S*|\.git|\.agents|lib|test|assets|android|ios|"
        r"\./(lib|test|assets|android|ios))/?(\s|$)",
        "Recursive deletion of the workspace root or core folders is forbidden.",
    ),
]


def extract_command(data):
    if not isinstance(data, dict):
        return ""
    tool_call = data.get("toolCall")
    if isinstance(tool_call, dict):
        args = tool_call.get("args")
        if isinstance(args, dict) and args.get("CommandLine"):
            return args["CommandLine"]
    tool_input = data.get("tool_input")
    if isinstance(tool_input, dict) and tool_input.get("command"):
        return tool_input["command"]
    return data.get("command") or ""


def main():
    raw = sys.stdin.read()
    try:
        cmd = extract_command(json.loads(raw)) if raw.strip() else ""
    except ValueError:
        cmd = ""

    cmd = " ".join(str(cmd).split())
    if not cmd:
        print(json.dumps({"decision": "allow"}))
        return 0

    for pattern, reason in RULES:
        if re.search(pattern, cmd, re.IGNORECASE):
            sys.stderr.write(f"[GUARDRAIL BLOCKED] {reason}\n")
            print(json.dumps({"decision": "deny", "reason": reason}))
            return 2

    print(json.dumps({"decision": "allow"}))
    return 0


if __name__ == "__main__":
    sys.exit(main())
