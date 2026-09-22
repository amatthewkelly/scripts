# mac-status

Prints a read-only health and storage summary for this Mac. No schedule — run
it when you want it.

```sh
mac-status
```

Reports: OS and model, uptime, OpenCore / OCLP versions, disk usage and the
largest home folders, memory pressure, battery condition and cycle count, Time
Machine destination and local snapshots, and any file over 500 MiB modified in
the last 90 days across Desktop, Documents, Downloads and Movies.

## Notes

The script never uses `sudo` and never changes system state. Sections whose
tools are unavailable are skipped rather than failing.

The storage and large-file sections walk your home directory, so a run takes a
few seconds.

## Files

- `mac-status` — the script
