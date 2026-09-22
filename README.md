# scripts

Personal macOS scripts, each in its own folder with whatever it needs to run.

| Script | What it does | Schedule |
| --- | --- | --- |
| [daily-quote](daily-quote) | Notification with a random quote, no repeats until the pool is exhausted | 8:30am daily |
| [daily-reading](daily-reading) | Opens a random unread document from `~/reading` | 9:00am daily |
| [mac-status](mac-status) | Read-only health and storage summary | run by hand (on PATH) |

## Install

```sh
git clone https://github.com/amatthewkelly/scripts.git ~/Projects/scripts
cd ~/Projects/scripts && ./install.sh
```

Then add `~/bin` to your PATH if it is not already there:

```sh
export PATH="$HOME/bin:$PATH"
```

`install.sh` symlinks the hand-run scripts into `~/bin` and loads the two
launchd agents. It is safe to re-run — do so after changing a plist template.

## Layout

The repo is the source of truth; nothing is ever copied out of it.

`~/bin` holds symlinks for the scripts you run yourself, and is kept separate
from `~/.local/bin`, which belongs to installed tools. Only `mac-status` is
linked there.

The scheduled scripts get no symlink at all. launchd ignores PATH and execs the
absolute path in the plist, which points straight at this directory — so they
are not typeable as commands, and **moving or renaming this repo breaks the
scheduled runs until you re-run `install.sh`**.

The launchd plists work differently. launchd only reads
`~/Library/LaunchAgents`, and it will not reliably follow a symlink, so each
plist is stored here as a `.plist.template` containing `{{HOME}}` and `{{REPO}}`
placeholders that `install.sh` substitutes on the way out. Treat the template as
the real file and the installed copy as build output — edit the template, re-run
`install.sh`.

## Portability

The plists are portable via `{{HOME}}` and `{{REPO}}`. The scripts themselves
are not: they hardcode `/Users/aaronkelly` for their data and state
directories. On another machine those paths need editing. See each script's
README for what it expects.
