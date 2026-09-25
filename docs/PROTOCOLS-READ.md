# Protocol documents read, and in which version

Kept by the Fieldwork Companions session (`local_e697ae67-65be-4434-a52f-24d7379715a6`), as the TicketDispatcher's
`WELCOME.md` asks (point 5): after every compaction of the session's context, reread the documents and record which
version was read, so that when a rule moves it is clear which version a decision leaned on. The version is the last
commit that touched the file in its own repository (`git log -1 --format='%h %ad' -- <file>`); **modified, not
committed** when `git status --short -- <file>` shows a change, in which case what was read is the working copy.

Read on **2026-09-25** (the collection's HEAD `a32c50f5`, this mod's HEAD `7ce18d7`). This file replaces
`DOCS_READ.md`, written earlier the same day with a shorter list.

## Collection root (`rimworld/`)

| Document | Last commit | Date | State | Lines |
| --- | --- | --- | --- | ---: |
| `AGENTS.md` | `8ce2aeeb` | 2026-09-24 | committed | 46 |
| `AUDIT.md` | `a32c50f5` | 2026-09-25 | committed (read as `modified` at `48a19e4b`, same content: blob `78c72fd1d1`) | 227 |
| `PUBLISHING.md` | `48a19e4b` | 2026-09-25 | committed | 685 |
| `PUBLISHING_STATE.md` | `5b3104e8` | 2026-09-11 | committed | 170 |
| `TRANSLATIONS.md` | `2e563481` | 2026-09-23 | committed | 100 |
| `MOD_SETTINGS.md` | `2e563481` | 2026-09-23 | committed | 107 |
| `STYLE_RIMWORLD.md` | `2e563481` | 2026-09-23 | committed | 502 |
| `EXTERNAL_TOOLS.md` | `3c78b2e7` | 2026-09-24 | committed | 124 |
| `WORKSHOP_COMMENTS.md` | `fa79963f` | 2026-09-24 | **modified, not committed** | 66 |
| `scripts/PICKLE-WSL.md` | `8c1c0fb1` | 2026-09-21 | committed (a pointer to `PickleTools/Headless`) | 7 |
| `scripts/SEARCHING.md` | `9a52ea1b` | 2026-09-17 | committed | 168 |
| `scripts/Tests/README.md` | `a32c50f5` | 2026-09-25 | committed | 76 |

## Sibling repositories

| Document | Last commit | Date | State | Lines |
| --- | --- | --- | --- | ---: |
| `PickleTools/README.md` | `76e9179` | 2026-09-24 | **modified, not committed** | 82 |
| `PickleTools/Headless/README.md` | `2da3bb5` | 2026-09-24 | committed | 466 |
| `PickleTools/Authoring/README.md` | `6f4ddc5` | 2026-09-24 | committed | 255 |
| `PickleTools/Upstream/PENDING.md` | `730aa20` | 2026-09-24 | **modified, not committed** | 47 |
| `Rimworld-Release-Admin/docs/OPERATIONS.md` | `2ce34a3` | 2026-09-25 | committed | 207 |
| `Rimworld-Ticket-Dispatcher/docs/WELCOME.md` | `7a0f078` | 2026-09-24 | **modified, not committed** (65 lines; an earlier read of 47 lines was of a previous working copy) | 65 |
| Pickle `Docs/steps.md` | `e22b90a0` (tag `v4.9.1`, 2026-09-23) | 2026-09-23 | fetched from `RimWorks/Rimworld-Pickle` with `gh api`, blob `0a868879`; there is no local checkout of Pickle's repository (`pickle-local/` holds reports only) | 577 |

## This mod (`FieldworkCompanions/`)

| Document | Last commit | Date | State | Lines |
| --- | --- | --- | --- | ---: |
| `STATUS.md` | `6dff681` | 2026-09-23 | committed | 593 |
| `README.md` | `1c533f8` | 2026-09-13 | committed | 90 |
| `CHANGELOG.md` | `6dff681` | 2026-09-23 | committed | 27 |
| `ATTRIBUTION.md` | `b76b700` | 2026-09-12 | committed | 19 |
| `LICENSE` | `0432fea` | 2026-09-20 | committed | 21 |
| `PUBLICATION.md` | `504a509` | 2026-09-22 | committed | 120 |
| `TESTING.md` | `7ce18d7` | 2026-09-25 | committed (written by this session) | 159 |
| `Mod/About/About.xml` | `17a0197` | 2026-09-22 | committed | 68 |
| `docs/runs/README.md`, `history.md` | `7ce18d7` | 2026-09-25 | committed (written by this session) | |
| `docs/runs/2026-09-22-English-shared-run.md` | `6dff681` | 2026-09-23 | committed | |
| `Tests/Pickle/README.md` | `fb83402` | 2026-09-22 | committed | 80 |
| `BACKLOG.md`, `NOTES.md`, `BUGS.md` | | | **do not exist in this repository** | |

## What in them changes how this mod is handled

- **Fail fast (AUDIT.md, PUBLISHING.md, 2026-09-25).** The 1.0.0 goes out once no red scenario is open, each failed
  scenario having been replayed green on a build that holds its fix; the gallery, the owner's manual validations, the
  dry-run of the exact commit, the full-SHA `publish` and the rollback target are still required. The regression
  passes run after the publication, in small tickets. Only the owner approves `steam-production`, changes the
  visibility and puts the 1.0.0 into production. The CI creates the tag and the release after a successful upload.
  This mod goes the semantic-release way (`Mod/README.template.md`, which overwrites the live description at every
  publication) unless the owner decides otherwise.
- **Tickets (AUDIT.md, WELCOME.md).** One request per pass through `Submit-PickleRun.ps1`, no process kept in the
  session, no `Monitor`, heartbeat or cron for the queue (the TicketDispatcher wakes the owner). A fix or an exploration
  plays the fewest scenarios, an initial or final pass plays all of them. A request carries no SHA: the mod tree stays
  on the revision under test until `RUN_DONE`, and the SHA goes in `-Label`. `-EvidenceDir` is relative to the rimworld
  root. Keep `summary.json` and `junit.xml`; `report.html` and `messages.ndjson` of a superseded build prove nothing.
  Delete evidence with `robocopy <empty> <target> /MIR` (MAX_PATH).
- **Reading a report (AUDIT.md, Authoring, `steps.md`).** `exitReason` before the counts; scenarios played against
  discovered; a game error logged in a step fails the scenario unless it is tagged `@allow-errors`; the default step
  deadline is five seconds unless the step declares `TimeoutSeconds`, and a scenario has 120 s unless `@timeout:N`;
  `@retry:N` makes a flaky pass that must not certify a gate; an excluded scenario is not reported, a `@requires`
  skip is; Pickle seeds the game before each scenario, so the same colonist makes the same choices every run (this is
  why a wasted milking repeated three times in a row). The game logs in UTC.
- **Passes (AUDIT.md, Headless).** At least two: without and with the optional mods, plus one per declared
  incompatibility; here RIMMSQOL is an integration pass and there is no incompatibility. A filter that excludes names
  the mod first (`Fieldwork Companions - Pickle tests,!@part2,!@part3`). A language is chosen at launch (`-Language`),
  never inside a scenario.
- **Images (STYLE_RIMWORLD.md, PUBLISHING.md).** Only the owner generates the ModIcon; the images to upload sit in one
  folder, numbered `01-`, `02-`…, and the gallery is a manual step on the Steam page.
- **Git (PUBLISHING.md, "Pièges d'outillage").** The pathspec goes on the `commit`, and `git status` is read after it;
  no `--amend` without `git log -1`.
- **Nothing to do with this mod**: `SEARCHING.md`, `EXTERNAL_TOOLS.md`, `scripts/Tests/README.md`,
  `PUBLISHING_STATE.md`, `WORKSHOP_COMMENTS.md` (its register holds no row for Harmony's comment of this mod yet, see
  `PUBLICATION.md`), `Upstream/PENDING.md`.

## Where this session's own work departed from them

Recorded so that it is not repeated, not as a defect of the mod:

- Monitors and a polling watcher were armed for the queue (2026-09-22 to 24) although AUDIT.md says no session does;
  the owner had them stopped. Not repeated.
- Requests were labelled without the SHA (`1fec`, `2908`, `f952`, `f529`, the three parts). The tree was not touched
  between a deposit and its `RUN_DONE` for the three parts; for the four fix checks it was rebuilt just before each
  deposit and only committed afterwards, with no change of content.
- Commit `7ce18d7` was made with `git add -u` and no pathspec on the `commit`. It is this repository's own index and the
  commit holds only this mod's 23 files (checked against `git status` afterwards), but the next one uses a pathspec.
- The evidence folders under `Tests/Pickle/Evidence/` held `report.html` and `messages.ndjson`. Cleaned on 2026-09-25:
  eight superseded folders removed, the four kept ones minified (about 150 MB to 2.6 MB); no `STATUS.md` field pointed
  at a removed folder.

## Things found stale in this mod's own documents, to correct

- `STATUS.md`: the front matter still says `updated: 2026-09-22` and its `remaining` list predates the runs of
  2026-09-24 and 25 (pass 1 played in three parts; fishing has run; the reset scenario has been seen to pass).
- `Tests/Pickle/README.md` (`fb83402`): its "Run" section still calls `Run-PickleWsl.ps1` directly instead of
  `Submit-PickleRun.ps1`, and does not mention the `@part` tags.
- `PUBLICATION.md`: no row of `WORKSHOP_COMMENTS.md` covers the thank-you to Harmony for this mod; the register says
  Harmony is already `posted` (2026-09-22) with a list of covered projects that does not name Fieldwork Companions.
