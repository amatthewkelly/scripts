# daily-reading

Opens a random unread document from `~/reading` every morning at 9:00, using
whatever app macOS associates with the file type.

Selection is without replacement: each file opened is appended to a history
file and excluded from future draws. Once everything has been opened the
history resets and the whole directory becomes available again.

## Requires

- **`~/reading/`** — the document pool, searched recursively. Matches `.pdf`,
  `.epub`, `.mobi`, `.txt`, `.rtf`, `.doc` and `.docx`; `.DS_Store` is skipped.
- **`~/Library/Application Support/Daily Reading/`** — created automatically;
  holds `opened-history.txt`.

If `~/reading` does not exist the script exits non-zero and nothing opens.

## Notes

History is keyed on the full file path, so renaming or moving a document makes
it eligible again.

## Files

- `daily-reading` — the script
- `com.aaronkelly.daily-reading.plist.template` — launchd schedule

## Logs

`~/Library/Logs/daily-reading.log` and `daily-reading.error.log`

## Run manually

```sh
daily-reading    # opens a document and appends to history
```
