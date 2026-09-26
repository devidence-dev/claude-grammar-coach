#!/usr/bin/env bash
# UserPromptSubmit hook: appends the raw prompt to a per-session log.
# Must print nothing (stdout is added to Claude's context) and never fail.
dir="$HOME/.claude/grammar-coach/sessions"
mkdir -p "$dir" 2>/dev/null || exit 0
input=$(cat)
sid=$(jq -r '.session_id // "unknown"' <<<"$input" 2>/dev/null) || exit 0
jq -c '{ts: (now|todate), prompt: .prompt}' <<<"$input" >> "$dir/${sid:-unknown}.jsonl" 2>/dev/null
# cleanup: remove logs older than 30 days
find "$dir" -name '*.jsonl' -mtime +30 -delete 2>/dev/null
exit 0
