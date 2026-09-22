# scripts

Personal macOS scripts, each in its own folder with whatever it needs to run.

| Script | What it does | Schedule |
| --- | --- | --- |
| [daily-quote](daily-quote) | Notification with a random quote, no repeats until the pool is exhausted | 8:30am daily |
| [daily-reading](daily-reading) | Opens a random unread document from `~/reading` | 9:00am daily |
| [mac-status](mac-status) | Read-only health and storage summary | run by hand |

## Install

```sh
git clone https://github.com/amatthewkelly/scripts.git ~/Projects/scripts
cd ~/Projects/scripts && ./install.sh
```

`install.sh` symlinks each script into `~/.local/bin` and loads the two launchd
agents. It is safe to re-run — do so after changing a plist template.

## Layout

The repo is the source of truth. `~/.local/bin/daily-quote` is a symlink back
into this directory, so editing a script here changes what actually runs; there
is no copy to keep in sync.

The launchd plists work differently. launchd only reads
`~/Library/LaunchAgents`, and it will not reliably follow a symlink, so each
plist is stored here as a `.plist.template` containing a `{{HOME}}` placeholder
that `install.sh` substitutes on the way out. Treat the template as the real
file and the installed copy as build output — edit the template, re-run
`install.sh`.

## Portability

The plists are portable via `{{HOME}}`. The scripts themselves are not: they
hardcode `/Users/aaronkelly` for their data and state directories. On another
machine those paths need editing. See each script's README for what it expects.
