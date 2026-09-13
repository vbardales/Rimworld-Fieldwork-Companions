---
localization: complete
translation_en: complete
translation_fr: complete
mod:          Fieldwork Companions
packageId:    nelim.fieldworkcompanions
repo:         Rimworld-Fieldwork-Companions
remote:       https://github.com/vbardales/Rimworld-Fieldwork-Companions.git
local_path:   C:\Users\nelim\Documents\rimworld\FieldworkCompanions
visibility:   public
detached:     yes
stage:        done
settings_audit: complete
audit_revision: 928584df23c38bd76901bb9064c2587ff6f91a60
licence:      original
license_spdx: MIT
licence_at:   Original implementation according to ATTRIBUTION.md; no third-party mod code or assets reused. Only the mechanic is inspired by Disney Dreamlight Valley. Root and distributed LICENSE grant MIT. Classification original describes provenance; MIT describes reuse permissions.
dependencies: declared
showcase:     complete
tested_on:
workshop:
maintainer:   Codex, current local repository task
updated:      2026-09-13
remaining:
  - unverified: Execute scenarios 0-16 in game, including both settings access routes, persistence/reset, FR/EN, new-game and existing-save coverage.
  - unverified: RIMMSQOL reveal/open/edit/hide and visibility persistence; no customization integration has been tested interactively.
  - unverified: In-game English/French settings, tooltips, reset dialog and assist mote; check raw keys, fallback, formatting and clipping in both languages.
  - Manual scenarios 0-16 have not been played; actual RimWorld/Mono behavior remains unverified.
  - Steam Workshop publication and visibility have not been established; public refers to GitHub.
---

# Fieldwork Companions — status

This task owns and maintains this STATUS.md as work progresses. The file stays at the
repository root, outside the distributed Mod/ folder.

## Audit fixes and revalidation — 2026-09-13

User follow-up authorized fixes. This section supersedes the earlier audit's unresolved
findings below; the original audit and historical results remain intact.
Stage **preOptions -> done**. `done` means ready for final functional validation in game,
not `tested`. The supplied workflow explicitly places interactive checks at `done -> tested`.

- Based on commit `928584df23c38bd76901bb9064c2587ff6f91a60` plus the local changes
  recorded in `_tools/results/2026-09-13-settings-manifest.json`. No commit or publication.
- Added `Source/MainButtonWorker_Settings.cs` and a MainButtonDef with
  `buttonVisible=false`, `validWithoutMap=true`, and no separate tab window. The worker
  inherits native visibility, so compatible tools can reveal/hide the same definition.
  Activate opens `Dialog_ModSettings(FieldworkCompanionsMod.Instance)`, exactly the native
  primary settings UI. The game dialog calls WriteSettings when closing; no second settings
  store or mandatory customization dependency was introduced.
- All 12 existing settings retained. Stored numeric values now normalize on LoadingVars
  and before saving: finite values clamp to slider ranges; NaN/infinity restore defaults.
  Chance and radius predicates were extracted into production settings methods, preserving
  the existing formula and inclusive radius while making boundary behavior executable in tests.
  The actual dispatcher and BonusCount are tested against the delivered DLL as well.
- EN/FR introductory text now explains immediate global scope and saving on close.
  Shortcut label/description use native English Def values and two French DefInjected entries.
  All 33 Keyed entries remain covered; no redundant English injection file was added.
- Fixed the final Workshop source-code link and added .gitattributes for text/PNG/DLL.
  README, changelog and scenarios 15-16 document the configuration routes and final manual
  checks. The parent's old prompt file was left outside this mod's changes; it is not a gate.

### Validation of the delivered changes

- `dotnet build Source/FieldworkCompanions.csproj -c Release --no-restore --nologo`:
  passed, zero warnings/errors, updated the distributed DLL. SHA-256:
  `EF4432026EAAD0038C08F75B20AC931F131B27CF850826960D76B5AF1D2F08BC`.
- `powershell -NoProfile -ExecutionPolicy Bypass -File _tools/Run-Functional-Tests.ps1`:
  **25/25 passed**, exit 0. Output: `_tools/results/2026-09-13-settings-tests.txt`.
  Ten new checks cover all defaults/reset, numeric limits/nonfinite values, probability
  effects/caps/restoration, every allowed radius, all 16 work-switch combinations, real
  BonusCount changes, real scalar Scribe round-trips, missing/older fields, normalization
  on load, native shortcut Def/worker/dialog contracts and translation coverage.
  The existing 15 compatibility/API/XML tests also pass against the changed DLL.
- The first run had 24/25 passes: its test forced fr-FR numeric culture without game
  initialization, causing Scribe to write comma decimals and read them incorrectly.
  Inspection of the installed Verse.Root confirmed its call to CultureInfoUtility.EnsureEnglish.
  The test now invokes that actual initializer after selecting each EN/FR host culture;
  both round-trips pass. This corrected the harness, not a diagnosed in-game defect.
  Initial failure preserved in `_tools/results/2026-09-13-settings-tests-initial.txt`.
- Scribe uses real game saver/loader and the actual ExposeData method, with isolated files
  under .build/settings-tests. Scalar loading stops after LoadingVars; Unity's profiler and
  final scene-loading lifecycle are not executed. Real user settings are untouched.
- `powershell -NoProfile -ExecutionPolicy Bypass -File ../scripts/Check-DefInjected.ps1
  -TransMod <repository>/Mod`: **2 keys checked, 0 errors**, 11,587 indexed Defs;
  output `_tools/results/2026-09-13-definjected.txt`. XML/resource checks cover the two new
  XML files in addition to About and both Keyed resources. A final About XML comment-only
  change was parsed again; it does not invalidate functional results.
- Native API/visibility/persistence linkage uses the installed RimWorld 1.6.4871 rev590
  assembly. The shortcut Def and worker are instantiated; compiled native dialog calls
  and inherited visibility are checked. This is not a RIMMSQOL interaction test.
- Specialty gating, bond creation and mote delivery retain their production consumers;
  compiled field/call linkage is checked. Full animal eligibility, random bond outcomes,
  map placement, UI rendering and new-game/save lifecycle remain manual scenarios.

Settings and translation gates now pass at the technical/source level specified by the
user. Harmony remains the sole mandatory mod; Odyssey remains optional. Images, naming,
licence and remote validation were unaffected and are retained. Functional scenarios 0-16
are written with preconditions/actions/expectations; automated and XML tests are green.
The sole next workflow transition is `done -> tested`: run those scenarios, inspect logs,
verify FR/EN UI, persistence and optional shortcut interaction, and rerun affected regression
checks after any resulting fix. No game or customization mod was launched in this task.

## Ordered workflow audit — 2026-09-13 (historical, before fixes)

This audit supersedes historical stage conclusions below while preserving their results.
The user's supplied workflow takes precedence over the four parent protocols, all read:
PUBLISHING.md, STYLE_RIMWORLD.md, MOD_SETTINGS.md and TRANSLATIONS.md.
In particular, interactive game tests belong to `done -> tested`, not the options gate.
`preOptions` is the literal workflow state after Preview styling and before the settings
gate; it is not an alias for `preTest`. Previous stage: `done`; retained stage: `preOptions`.

### Scope and revision

- Autonomous repository: `C:\Users\nelim\Documents\rimworld\FieldworkCompanions`;
  distributed content: its `Mod/` subdirectory (eight files). Source, Art and tests are
  outside that directory. Git top-level, git-dir and common-dir confirm independence;
  no superproject is reported. The parent's remote is irrelevant.
- At entry, HEAD was `50b9a35c77e40b16231d9d3bb315e51691ca4e71`, with local changes in
  CHANGELOG.md, STATUS.md, Source/FieldworkCompanionsMod.cs, the shipped DLL and both
  Keyed files. During the audit HEAD advanced externally to
  `928584df23c38bd76901bb9064c2587ff6f91a60`, committing those six files. The working
  tree was clean before this report edit; the reviewed localized category and resource
  contents are included in that revision. This audit made no commit or publication.
- Checked the delivered working files, not only committed source. The audit only edits
  STATUS.md; a separate build output is under ignored `.build/audit-20260913/`.
  No delivered code, DLL, image or historical report was replaced.

### Transition results

| Transition | Result | Direct evidence / limit |
| --- | --- | --- |
| dansMonoRepo -> horsMonoRepo | Validated | Independent Git repository; configured GitHub origin; live `gh repo view` reports PUBLIC and `git ls-remote origin HEAD` returned pushed commit 50b9a35. English README, attribution, MIT licence and changelog exist. Root/distributed licence and attribution pairs have identical SHA-256 hashes. Original provenance is documented, with no third-party implementation/assets identified in the inventory. Title, packageId, repository and directory are coherent without literal identity. |
| horsMonoRepo -> ModIcon generated | Validated | Existing gameplay implementation and four patches present; separate Release build succeeds and matches shipped DLL exactly. PNG icon directly inspected: 128 x 128, 29,749 bytes. The later settings-contract defect is assessed at its explicit workflow gate. |
| ModIcon generated -> Preview generated | Validated | Distributed PNG directly opened: 896 x 504, 635,659 bytes, below 1 MB. High overhead view, tiled ground, miner/companion/resource subject, no concrete camera defect found. No historical generation record is required. |
| Preview generated -> preOptions | Validated | English title/summary and About description. Full-size Preview and existing 268px thumbnail inspected; readable title/version, no clipping or overlap. Jade-green accent separates from warm ochre secondary/ground. Secondary is intentionally unused because the original public title has no prefix, suffix, status tag or linking word requiring special styling. Palette and composition remain in Art/. |
| preOptions -> options | Defect + unverified | Useful primary settings UI exists, but no MainButtonDef, MainTabWindow or equivalent runtime registration exists anywhere in Source/ or Mod/. The required discoverable hidden shortcut is absent. Existing tests do not exercise settings behavior or serialization; see settings audit below. |
| options -> l10n | Independent resource validation retained | All 33 owned keys have nonempty EN/FR resources; source helper arguments and mote traced, placeholders reviewed and checked. No owned DefInjected targets, grammar, XML patches or LoadFolders. This does not bypass the blocked options gate. |
| l10n -> preTest | Independent dependency validation retained | Harmony is actually used and declared with loadAfter; RimWorld 1.6 declared. Odyssey trainables use silent optional lookup; fishing target exists in the installed base assembly. Other DLC loadAfter entries do not make those DLC mandatory. No bundled dependency DLLs or conditional XML/LoadFolders to reconcile. DLC present/absent gameplay remains unverified. |
| preTest -> done | Partially established independently | Existing automated suite and shipped XML checks pass on delivered DLL; 15 gameplay scenarios have setup/actions/expectations. Settings-specific automated coverage and written scenarios for both routes, persistence/reset, FR/EN and new-game validation remain incomplete. No artificial tests added during this audit. |
| done -> tested | Unverified | No game launched and no scenarios executed by this audit. No verified FR/EN UI, Player.log, persistence, shortcut integration, new-game or existing-save results. This is not an observed runtime defect. |

### Settings audit

- Useful settings: four work switches, specialty requirement, base chance, per-training-step
  and bonded bonuses, resource share, radius, bond-creation chance and assist mote (12 values).
  They control real branches/calculations in Companions and the four patches. Primary access
  uses Verse.Mod.SettingsCategory/DoSettingsWindowContents and GetSettings; no customization
  dependency is required. Runtime consumers read the shared settings on each assist.
- Static review: all work switches, specialty and mote default true; chances default to
  15%, 10% per step, 15% bonded, 0.5% bond creation; share 25%, radius 8. Reset and Scribe
  fallback defaults match initializers. UI sliders bound base/bond bonus to 0-100%, step
  bonus to 0-50%, share to 5-200%, radius to 2-30 and bond creation to 0-5%.
  ChanceFor clamps the total to 0-100%; fishing intentionally ignores share and adds one fish.
  Controls use sliders/checkboxes, so invalid free-text entry is not applicable.
- Scope is global ModSettings, not per-save data. Immediate application and persistence are
  supported by source structure, but actual behavior, reset and save/load have not been
  established by executable settings tests. ExposeData has no post-load bounds normalization;
  malformed/older stored numeric values are an unverified robustness case, not an observed crash.
- Defect: shortcut is absent, not merely hidden. A future fix must expose a discoverable
  default-hidden MainButton that opens the same primary configuration and shares persistence.
  No RIMMSQOL or other customization integration was tested. Game data/API inspected:
  RimWorld `1.6.4871 rev590`; no claim of Mono execution.
- Next transition requires the shortcut implementation and applicable automated technical
  settings checks with observed passing results. Rebuild and recheck affected resources/XML
  after that change. Interactive route and integration tests remain for `tested` per the prompt.

### Commands and observed results

- `gh repo view vbardales/Rimworld-Fieldwork-Companions --json nameWithOwner,visibility,url`
  and `git ls-remote origin HEAD`: passed with read-only elevated access after the sandbox
  denied CLI configuration/network access. This initial access limitation was resolved.
- `dotnet build Source/FieldworkCompanions.csproj -c Release --no-restore --nologo
  -p:OutputPath=../.build/audit-20260913/`: exit 0, zero warnings/errors.
  Rebuilt and delivered DLL SHA-256 both
  `79E47BB45C3C5A65CB13BAF84BAD52507BFFE181AF90A3967B83838C1643E120`.
- `powershell -NoProfile -ExecutionPolicy Bypass -File _tools/Run-Functional-Tests.ps1`:
  exit 0, **15/15 passed**, against the delivered DLL and installed game assemblies/data.
  Includes the real compile probe for three non-public members, access grants, four Harmony
  targets, subclass/API checks, vanilla trainables/yield caps, 33/33/33 keys, all three shipped
  XML files, duplicate/empty entries and About identity/dependency metadata. These are
  compatibility/resource checks, not execution of the settings UI or gameplay.
- Additional PowerShell XML comparison of parameters, escaped line breaks and markup:
  zero EN/FR mismatches; sample String.Format succeeds for each parameterized entry.
  Reviewed English/French meaning, labels, tooltips and dynamically supplied PercentRow keys.
  Numeric mote and proper mod name being identical in both languages is intentional.
- Direct image inspection and System.Drawing metadata check completed. Existing Art QA
  measurements are preserved; browser font/contrast measurements were not rerun or claimed
  as new results. No direct visual concern remains requiring a new image.

### Separate publishing follow-ups (not blockers of the next settings transition)

- About.xml currently places a bare source URL in the middle of the description. This is a
  confirmed deviation from PUBLISHING.md's final `[url=...]Source code on GitHub[/url]`
  convention, to address before publication; the English-description workflow criterion passes.
- The standalone repository has no .gitattributes, and the parent still contains
  PROMPT_FIELDWORKCOMPANIONS.md. Repository hygiene follow-ups do not invalidate directly
  verified images or require restoring a monorepo remote. No parent file was removed.
- Steam publication is outside this audit and is not required to reach `tested`.

## Translation audit — 2026-09-13

- Applied ../PUBLISHING.md and ../TRANSLATIONS.md to Source/**/*.cs and all of Mod/.
  No LoadFolders, version folders, owned Defs, XML patches or grammar resources exist.
- Inventory: 33 owned Keyed entries: settings category title, 31 settings labels,
  tooltips and confirmation texts, and the numeric assist mote. Traced PercentRow's
  label/tooltip arguments and numeric formatting, the reset confirmation, and all four
  patches through NoteAssist. No other owned player-facing text was found.
- Fixed the hardcoded settings category with FieldworkCompanions.Settings.Title.
  Both languages retain Fieldwork Companions as a proper name, now localizable.
  The identical +{0} mote is intentionally numeric in both languages.
- Reviewed all English and French entries against the UI and mechanics. Clarified the
  deep-drill exclusion in both languages, corrected French harvesting text to mean
  no bonus, and made the French radius inclusive as implemented. French training
  descriptions use descriptive wording rather than claiming exact vanilla UI labels.
- No dependency translation keys are explicitly reused. Standard confirmation buttons
  and bond notifications are generated by vanilla APIs. Serialization keys, Harmony
  targets, defNames, numeric format patterns and About metadata are not owned UI text.
  DefInjected validation is not applicable because no owned Def fields are shipped.
- Resource checks: 33 source keys, 33 English and 33 French entries; no missing,
  duplicate or empty keys; all shipped XML parses. PowerShell XML/regex comparison
  confirmed matching placeholders, escaped line breaks and markup for every entry;
  String.Format with a sample numeric argument succeeded for both languages.
- Build: dotnet build Source/FieldworkCompanions.csproj -c Release --no-restore --nologo;
  succeeded with zero warnings/errors and refreshed Mod/Assemblies/FieldworkCompanions.dll.
  Initial sandbox SDK access failure was resolved by rerunning with approved access.
- Functional validation: powershell -NoProfile -ExecutionPolicy Bypass -File
  _tools/Run-Functional-Tests.ps1 passed 15/15 against the rebuilt DLL and installed game.
- These complete fields certify the source/resource gate only. In-game English/French
  verification remains unverified in remaining; the historical stage is preserved.

## Identity and publication audit — 2026-09-13

- Independent local Git repository: top-level is the local_path above, git-dir and
  common-dir are both .git, and no superproject is reported. This is not the monorepo.
- GitHub visibility verified live with gh repo view: PUBLIC.
- Title: Fieldwork Companions. No continuation/revival suffix is needed: this is an
  original mod, not a takeover or update of another author's mod.
- GitHub URL is present both in About.xml's url field and, after this audit, in its
  visible description under SOURCE CODE.
- Mod provenance category: original. Explicit distribution licence: MIT, identical in
  LICENSE and Mod/LICENSE. ATTRIBUTION.md documents the inspiration and lack of reused
  third-party code/assets. This is neither forbidden nor silent; open would describe
  explicit permission for a reused source, whereas original identifies this mod's origin.
- Harmony is declared; Odyssey is optional and resolved defensively at runtime.

## Verification — 2026-09-13

- Build: dotnet build Source/FieldworkCompanions.csproj -c Release --no-restore --nologo
  succeeded, zero warnings and zero errors.
- Automated: powershell -NoProfile -ExecutionPolicy Bypass -File _tools/Run-Functional-Tests.ps1
  succeeded: 15/15 tests against the installed game's assemblies and data.
- Coverage: access grants and required non-public members, four Harmony targets and
  signatures, subclass overrides, master/follow API, bond API, trainable defs, yield caps,
  32 English/French translation keys, all shipped XML parsing, duplicate/empty translation
  keys, About identity, supported version, Harmony dependency and visible GitHub link.
- No Defs or XML patches are shipped. Relevant mod XML consists of About.xml and the two
  language files, all checked; relevant vanilla training/stat XML is also inspected.
- The compile probe now reports infrastructure failures explicitly instead of claiming
  that private API members are no longer needed when the SDK is inaccessible.
- Manual: 15 scenarios (0-14) exist in _tools/FUNCTIONAL-SCENARIOS.md. Corrected setup
  to disable the specialty requirement outside its dedicated scenario, and corrected
  scenario 10: missing required Dig training means zero assists, not a 15% chance.
- Limits: no game launched, no manual scenario marked passed. These automated checks
  cover compatibility and metadata, not end-to-end gameplay or Mono behavior. Historical
  mutation checks concern the original suite; no new mutation campaign was performed.

## What this mod taught the repository, and what outlives it

- **The `GenerateAssemblyInfo=false` trap has taken a second mod, and it will take more.**
  Krafs.Publicizer applies `IgnoresAccessChecksTo` through the generated AssemblyInfo; switching
  that property off embeds the attribute's type and never applies it. Here the two members the
  milking patch reads, `ResourceDef` and `ResourceAmount`, are `protected abstract` in the real
  Assembly-CSharp — checked against the game's own file, not against the publicised reference — so
  the desktop CLR would refuse that access. **What it costs in the game is not established**: the
  Architect Studio session found a non-public call of its own, outside any try/catch, in an
  assembly with no waiver, working in a real game: RimWorld's Mono does not seem to enforce the
  check the way the desktop CLR does, and every check we run happens under PowerShell, on the
  desktop CLR. Treat it as a conformance fix, not as the repair of a mod seen dead. Contented
  Livestock had it on fields, this one on properties: the common factor is the switched-off
  property, not the kind of member, and **every mod that switches off `GenerateAssemblyInfo` and
  publicises deserves the same check** — twelve of them, of which two are now fixed. Fixed here in
  `Source/AccessChecks.cs`.

- **Searching the built assembly's bytes for `IgnoresAccessChecksTo` returns a false positive.**
  The type name is in the file whether or not the attribute was applied — that is the shape of the
  trap. The check that counts is one line of reflection on the built assembly:
  `[Reflection.Assembly]::ReflectionOnlyLoadFrom(<dll>).GetCustomAttributesData()`, and the
  attribute is either in that list or it is not. No need to launch the game, or even to resolve
  the assembly's dependencies.

## Preview overlay — 2026-09-13

- Recomposition follows ../STYLE_RIMWORLD.md and the supplied overlay specification.
  Existing title and summary are preserved exactly. No status tag or reduced title
  word applies to this original public mod. Badge 1.6 is read from the highest stable
  supportedVersions entry in Mod/About/About.xml at render time.
- Illustration retained, not replaced: Art/Preview.png is an unmodified copy of
  Art/Preview-source.png; that full-resolution original remains available. The centered
  cover crop preserves the miner, dog, jade pile and lamp. No text was added to either source.
- Final distributed image: Mod/About/Preview.png (896 x 504; 635,659 bytes, below 900 kB).
- Composition and parameters: Art/preview.html; sole palette reference:
  Art/preview-palette.json; reproducible renderer: Art/render-preview.cjs.
  _tools/preview.html redirects to the maintained composition instead of retaining an
  independent old palette. Serve the repository root over HTTP to preview the HTML.
- Palette rationale: the veil takes the dark stone/earth surface near the upper-left
  text area. Secondary ink is a lightened ochre from the dominant warm earth and lamp-lit
  floor family, not an average of the pixels. The accent draws on the green jade pile,
  a meaningful resource beside the companion, strengthened in saturation and lightness.
  Its yellow-green hue separates it from the ochre secondary and warm brown ground.
  Secondary ink is retained in the palette but unused here because no tag or suffix applies.
- Actual fonts verified through Chrome CSS.getPlatformFontsForNode after document.fonts.ready:
  Segoe UI Semibold for the title, Segoe UI for the summary, Segoe UI Bold for the version.
  No fallback font. Text block starts at (50,54); title 46px/600, summary 21px/400;
  standard dark radial veil and text shadow, standard rule and 80px corner badge.
- Contrast measured across every pixel of each text bounding rectangle on a second render
  with text hidden, not merely against the nominal veil colour: title minimum 8.58:1,
  summary 4.86:1; badge digits on opaque accent 11.33:1. All exceed 4.5:1.
  Tag contrast is not applicable because there is no tag.
- Evidence: Art/preview-qa.json (fonts, bounds, contrasts, version and size),
  Art/preview-background.png (actual text-free composited background), Art/preview-268.png.
  Visually checked final 896 x 504 image and 268px thumbnail: title and version identifiable,
  no clipping or overlap, rule visible; subject remains clear. Summary is designed for the
  full image, as the guide specifies. Nothing published.
