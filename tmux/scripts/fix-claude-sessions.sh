#!/usr/bin/env bash
# tmux-resurrect post-save-layout hook.
#
# Resurrect records a Claude Code pane as a bare `claude`, so a restore would
# start a fresh conversation. This rewrites each such pane in the save file to
# `claude --resume <session-id>`, using the newest session Claude Code has
# stored for the pane's directory (~/.claude/projects/<dir with non-alphanumerics
# as dashes>/<session-id>.jsonl). Panes sharing a directory get the next newest
# session each, so two panes in one repo don't both resume the same thread.
#
# Panes that already carry --resume/--continue are left alone.

set -o nounset -o pipefail

save_file="${1:-}"
[[ -f "$save_file" ]] || exit 0

projects_dir="$HOME/.claude/projects"
[[ -d "$projects_dir" ]] || exit 0

tmp="$(mktemp "${save_file}.XXXXXX")" || exit 0
trap 'rm -f "$tmp"' EXIT

# Save file columns (tab separated): 1 "pane", 8 ":<dir>", 11 ":<full command>".
# Column 10 (pane_current_command) isn't used: on macOS the native Claude
# binary reports its version (e.g. "2.1.285") there instead of "claude".
awk -F'\t' -v OFS='\t' -v projects="$projects_dir" '
  function newest_unused_session(dir,    key, cmd, path, id) {
    key = dir
    gsub(/[^A-Za-z0-9]/, "-", key)
    cmd = "ls -t \"" projects "/" key "\"/*.jsonl 2>/dev/null"
    id = ""
    while ((cmd | getline path) > 0) {
      sub(/.*\//, "", path)
      sub(/\.jsonl$/, "", path)
      if (!(path in used)) { id = path; break }
    }
    close(cmd)
    if (id != "") used[id] = 1
    return id
  }
  # First pass: reserve sessions that panes already resume explicitly.
  NR == FNR {
    if ($1 == "pane" && match($11, /--resume[ =][^ ]+/)) {
      id = substr($11, RSTART + 9, RLENGTH - 9)
      used[id] = 1
    }
    next
  }
  $1 == "pane" && $11 != ":" {
    full = substr($11, 2)
    split(full, words, " ")
    exe = words[1]; sub(/.*\//, "", exe)
    if (exe == "claude" && full !~ /(^| )(--resume|-r|--continue|-c)( |=|$)/) {
      id = newest_unused_session(substr($8, 2))
      if (id != "") $11 = ":" full " --resume " id
    }
  }
  { print }
' "$save_file" "$save_file" > "$tmp" && mv "$tmp" "$save_file"
