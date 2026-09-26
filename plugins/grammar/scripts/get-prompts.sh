#!/usr/bin/env bash
# Usage: get-prompts.sh <session_id> [last|all]
# Default: messages since the last /grammar:check. last: the latest message. all: every message.
f="$HOME/.claude/grammar-coach/sessions/${1:-none}.jsonl"
[ -f "$f" ] || { echo "(no prompt log for this session)"; exit 0; }
jq -rs --arg mode "${2:-}" '
  def isCheck: test("^\\s*/grammar:check");
  map(.prompt // "")
  | (if length > 0 and (.[-1] | isCheck) then .[:-1] else . end) as $p   # drop the current /grammar:check
  | ([$p[] | isCheck] | rindex(true)) as $lastCheck
  | (if $mode == "all" or $mode == "last" or $lastCheck == null then $p else $p[$lastCheck+1:] end)
  | map(select(isCheck | not))
  | (if $mode == "last" then .[-1:] else . end)
  | if length == 0 then "(no new messages to review)"
    else to_entries[] | "--- message \(.key + 1) ---\n\(.value)\n" end
' "$f"
