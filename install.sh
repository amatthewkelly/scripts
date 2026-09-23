#!/bin/bash
# Installs these scripts onto this Mac:
#   - symlinks the hand-run scripts into ~/bin (kept separate from
#     ~/.local/bin, which belongs to installed tools)
#   - renders each launchd plist template and loads it from
#     ~/Library/LaunchAgents
#
# Scheduled scripts are not symlinked: launchd ignores PATH and execs the
# absolute path in the plist, which points straight at this repo. That means
# moving this directory breaks the scheduled runs until you re-run this.
#
# Safe to re-run; it replaces whatever is already there.

set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
bin_dir="$HOME/bin"
agents_dir="$HOME/Library/LaunchAgents"

# Scripts you run yourself, so they need to be on PATH.
linked=(mac-status)
# Scripts launchd runs on a schedule.
agents=(daily-quote daily-reading)

mkdir -p "$bin_dir" "$agents_dir" "$HOME/Library/Logs"

for name in "${linked[@]}"; do
  ln -sfn "$repo_dir/$name/$name" "$bin_dir/$name"
  printf 'linked  %s -> %s\n' "$bin_dir/$name" "$repo_dir/$name/$name"
done

for name in "${agents[@]}"; do
  label="com.aaronkelly.$name"
  template="$repo_dir/$name/$label.plist.template"
  plist="$agents_dir/$label.plist"

  sed -e "s|{{HOME}}|$HOME|g" -e "s|{{REPO}}|$repo_dir|g" "$template" > "$plist"

  # Not loaded yet on a fresh machine, so a failed bootout is expected.
  launchctl bootout "gui/$UID/$label" 2>/dev/null || true
  launchctl bootstrap "gui/$UID" "$plist"
  printf 'loaded  %s (%s)\n' "$label" "$repo_dir/$name/$name"
done

# terminal-notifier lets a click on a notification run a command (plain
# osascript notifications can't set a click action); daily-quote uses it to
# open the full quote. Homebrew needs full Xcode to build it, so fetch the
# prebuilt release and ad-hoc sign it.
tn_app="$HOME/Applications/terminal-notifier.app"
tn_url="https://github.com/julienXX/terminal-notifier/releases/download/2.0.0/terminal-notifier-2.0.0.zip"
if [[ ! -x "$tn_app/Contents/MacOS/terminal-notifier" ]]; then
  tn_tmp="$(mktemp -d)"
  if curl -fsSL -o "$tn_tmp/tn.zip" "$tn_url" && unzip -q "$tn_tmp/tn.zip" -d "$tn_tmp"; then
    mkdir -p "$HOME/Applications"
    rm -rf "$tn_app"
    cp -R "$tn_tmp/terminal-notifier.app" "$tn_app"
    codesign --force --deep -s - "$tn_app"
    printf 'installed terminal-notifier -> %s\n' "$tn_app"
  else
    printf 'warning: could not fetch terminal-notifier; notifications will not be clickable\n' >&2
  fi
  rm -rf "$tn_tmp"
fi

printf '\nDone. Add ~/bin to PATH if it is not already:\n'
printf '  export PATH="$HOME/bin:$PATH"\n'
