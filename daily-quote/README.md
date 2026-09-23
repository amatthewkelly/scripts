# daily-quote

Shows a random quote as a macOS notification every morning at 8:30.

Quotes are drawn without replacement: each one shown is appended to a history
file and excluded from future draws. When every quote has been shown the
history resets and the full pool becomes available again.

## Requires

- **`~/Library/Mobile Documents/com~apple~CloudDocs/quotes.txt`** — the quote
  pool, in iCloud Drive. Quotes are separated by blank lines and may span
  several lines; internal whitespace is collapsed when displayed. The script
  only ever reads this file.
- **`~/Library/Application Support/Daily Quote/`** — created automatically;
  holds `shown-history.txt`.
- **`~/Applications/terminal-notifier.app`** — optional; installed by the
  top-level `install.sh`. With it, clicking the notification opens the
  full quote in a dialog (`daily-quote --show QUOTE`) that closes on dismiss
  and leaves no file behind. Without it the script falls back to `osascript`,
  whose notifications can't set a click action.

If `quotes.txt` is missing the script exits non-zero and the notification is
silently skipped, so check the logs rather than waiting for a notification that
never arrives.

## Notes

The notification previews the quote, truncated to 300 characters with an
ellipsis; click it to read the whole thing. The full quote is carried in the
click command, so an older notification still opens its own quote.

The `osascript` fallback ends with `delay 2`. Without it the script can exit
before the notification daemon picks up the async handoff, and the notification is
intermittently dropped.

## Files

- `daily-quote` — the script
- `com.aaronkelly.daily-quote.plist.template` — launchd schedule

## Logs

`~/Library/Logs/daily-quote.log` and `daily-quote.error.log`

## Run manually

```sh
~/Projects/scripts/daily-quote/daily-quote    # consumes a quote, appends to history
```

It is not on your PATH — launchd runs it by absolute path, so it needs no
symlink in `~/bin`.
