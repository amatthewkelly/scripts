#!/bin/bash
# Installs these scripts onto this Mac:
#   - symlinks each script into ~/.local/bin (which is on PATH)
#   - renders each launchd plist template with this machine's $HOME and
#     loads it from ~/Library/LaunchAgents
#
# Safe to re-run; it replaces whatever is already there.

set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
bin_dir="$HOME/.local/bin"
agents_dir="$HOME/Library/LaunchAgents"

scripts=(daily-quote daily-reading mac-status)
# Scripts with a launchd schedule; the rest are run by hand.
agents=(daily-quote daily-reading)

mkdir -p "$bin_dir" "$agents_dir" "$HOME/Library/Logs"

for name in "${scripts[@]}"; do
  ln -sfn "$repo_dir/$name/$name" "$bin_dir/$name"
  printf 'linked  %s -> %s\n' "$bin_dir/$name" "$repo_dir/$name/$name"
done

for name in "${agents[@]}"; do
  label="com.aaronkelly.$name"
  template="$repo_dir/$name/$label.plist.template"
  plist="$agents_dir/$label.plist"

  sed "s|{{HOME}}|$HOME|g" "$template" > "$plist"

  # Not loaded yet on a fresh machine, so a failed bootout is expected.
  launchctl bootout "gui/$UID/$label" 2>/dev/null || true
  launchctl bootstrap "gui/$UID" "$plist"
  printf 'loaded  %s\n' "$label"
done

printf '\nDone. Run "launchctl list | grep aaronkelly" to confirm the agents.\n'
