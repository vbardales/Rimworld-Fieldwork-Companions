# Pickle runs: text summaries

One file per completed or attempted run, named `<date>-<pass>.md`. The raw evidence (junit.xml, Player.log,
report.html, screenshots, films) stays **on disk** in `Tests/Pickle/Evidence/<date>-<pass>/` and is ignored by git:
it weighs hundreds of megabytes, and a run on the shared machine can hold other mods' pictures.

A summary says, in this order, and nothing more than the report says:

1. **Which pass**, the command, the date and the machine (WSL, language, map of extra mods).
2. **`exitReason` first**, then scenarios played against features discovered, then outcomes per feature.
3. **Every failure with its message**, and whether the defect is the mod's, the suite's or the environment's.
4. **Captures**: which ones were opened and looked at, and what they showed. A green `@review` scenario proves the
   journey ran, not that the picture is right.
5. **Where the evidence is** on disk, and that it is not in git.

A run that ended without a report is a summary too: it says so, and gives no numbers as a verdict.

## Shrinking a report

After a run, copy its report to `Tests/Pickle/Evidence/<date>-<pass>/` and shrink it in place:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File Tests/Pickle/Minify-Evidence.ps1 -Folder Tests/Pickle/Evidence/<date>-<pass>
```

`report.html` and `messages.ndjson` (tens of megabytes each, both derived from `junit.xml`) are removed and every
screenshot becomes a JPEG of at most 1280 px. `junit.xml`, the summaries, `Player.log` and the films stay. On a
synthetic noisy capture it took 7.6 MB to 0.5 MB; real screenshots shrink further. Keep the original of a capture
that has to be measured to the pixel. Only the latest report that still proves something stays on disk, and the
history is one line per run in `history.md`.
