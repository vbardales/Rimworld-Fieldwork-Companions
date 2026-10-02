# Protocol documents read, and in which version

Kept by the Fieldwork Companions session (`local_e697ae67-65be-4434-a52f-24d7379715a6`), as the TicketDispatcher's
`WELCOME.md` asks (point 5): after a compaction or a new audit, reread, record the version, and note the documents that
were of **no use** so they are not reread when they move.

Last read on **2026-10-02** (audit on `85779de`). Versions: for the protocol documents, the last commit of the protocols
repository (`git --git-dir=../rimworld-protocols.git --work-tree=. log -1 -- <file>`; a plain `git log` from the monorepo
returns the commit that *removed* them, `90d51374`, and lies); for the rest, the last commit in the repository that
carries the file. **M** = modified, not committed (what was read is the working copy). "Read" means the whole file;
"diff" means only what changed since the previous read (2026-09-25, when the full text was read).

## Protocols (monorepo root, protocols repository `4e8f11a`)

| Document | Version | Lines | Read | Use for this mod |
| --- | --- | ---: | --- | --- |
| `AGENTS.md` | `7fd7475` 2026-09-29 | 21 | whole (in context) | evidence rule, ordered gates, CI rules |
| `AUDIT.md` | `d1fdbe1` 2026-10-02 | 276 | whole | the checklist applied today (new `tested` criteria, WSL cleanup at hibernation, branches) |
| `PUBLISHING.md` | `4e8f11a` 2026-10-02 | 789 | diff since `48a19e4b` | single-digit gallery names with `0-` = Preview copy, change note starts with the version, comment voice, CI paths |
| `TRANSLATIONS.md` | `af8427f` 2026-10-02 | 216 | whole | French gender rule + review file (already applied 2026-09-30) |
| `MOD_SETTINGS.md` | `b83933b` 2026-09-23 | 107 | whole | settings gate (already `complete`) |
| `STYLE_RIMWORLD.md` | `c105a43` 2026-10-01 **M** | 716 | headings and the desktop.ini / `.ico` section only | local folder icons (lines 264-290, 700-710); the rest concerns generating images, which this session never does |
| `WORKSHOP_COMMENTS.md` | `7fd7475` 2026-09-29 | 159 | not reread | **no use today**: Harmony's thank-you is already posted; reread before drafting a comment |
| `scripts/SEARCHING.md` | `50de695` 2026-09-28 | 222 | not read | **no use**: how to search the corpus; nothing to search |

## Tools and queue

| Document | Version | Lines | Read | Use for this mod |
| --- | --- | ---: | --- | --- |
| `PickleTools/README.md` | `ff20d89` 2026-09-29 **M** | 89 | not reread | no run planned this session |
| `PickleTools/Headless/README.md` | `ed4e73a` 2026-09-26 | 509 | not reread | no run planned; reread before the final non-regression pass |
| `PickleTools/docs/steps.md` | `da7c3b0` 2026-09-28 **M** | 285 | not reread | no feature written this session |
| `Rimworld-Release-Admin/docs/OPERATIONS.md` | `3c03f51` 2026-09-26 | 112 | whole | CI rules; this mod is listed as still on the semantic-release path to retire |
| `Rimworld-Ticket-Dispatcher/docs/WELCOME.md` | `77ca9d7` 2026-09-27 | 150 | whole | ticket rules, `desktop.ini` / `.ico` must never enter `Mod/` |
| `Rimworld-Ticket-Dispatcher/docs/SUBMIT.md` | `d07b2b8` 2026-09-26 | 133 | first half (options) | submit options; the rest (supervision) is the dispatcher's |

## This mod

| Document | Version | Lines | Read |
| --- | --- | ---: | --- |
| `STATUS.md` | this audit | | front matter, the sections of 2026-09-29/30, this audit |
| `README.md` | `1c533f8` 2026-09-13 | 90 | first 40 lines |
| `CHANGELOG.md` | `c5e3492` 2026-09-29 | 31 | whole |
| `ATTRIBUTION.md`, `LICENSE` | `b76b700`, `0432fea` | 19, 21 | ATTRIBUTION whole; LICENSE not reread (MIT, unchanged) |
| `PUBLICATION.md` | this audit | 121 | gallery, change notes, status |
| `TESTING.md` | this audit | | whole |
| `Mod/About/About.xml` | `3f001ba` 2026-09-27 | 64 | whole |
| `Tests/Pickle/README.md` | `16e992a` 2026-09-27 | 88 | not reread |
| `docs/runs/README.md`, `history.md` | `7ce18d7`+ | | tail only |
| `FRENCH_REVIEW.md` | `85779de` 2026-09-30 | | not reread (generated) |
| `BACKLOG.md`, `NOTES.md`, `BUGS.md` | | | **do not exist**; none needed (original mod, no upstream pull request to track) |

## What changed the handling of this mod since 2026-09-25

- **`tested` gate (AUDIT.md, 2026-10-02):** no `@wip`; every `@requires` scenario has run in a pass that meets its condition;
  no manual test left. Met; recorded in `STATUS.md`, "Ordered audit — 2026-10-02".
- **Evidence:** keep per scenario the latest report for the revision in the repository; `Tests/Pickle/Evidence/` stays on disk
  and out of git; the table in `TESTING.md` says what each folder proves.
- **Gallery:** single-digit names, `0-` the byte copy of the Preview (done today).
- **Folder icons:** `Mod/desktop.ini` and `Mod/*.ico` are ignored; root `desktop.ini` and `Art/*.ico` are tracked (done today).
- **CI:** the semantic-release path is being retired; this mod's migration to `publish-tag.yml` belongs to the CI/CD session.
- **Ordering of Pickle passes:** never-run and red scenarios first, non-regression passes together at the end on the final
  revision (AUDIT.md, 2026-10-02). The retrait chain is the one still to replay.
- **Git:** the pathspec goes on the `commit`, and `git status` is read after it.
