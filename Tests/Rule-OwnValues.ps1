param([Parameter(Mandatory)][string]$ModRoot, [string]$SharedDir)

# Own values and facts of this mod: the 13 settings (defaults, reset, bounds, persistence, effect), the markScale mark and its mote def,
# the hidden settings shortcut, the About identity and Harmony dependency, EN and FR Keyed parity, and what the four Harmony hooks ask
# of the game. One consumer, nothing shareable; Tests/Test-Mod.ps1 (generated) runs it after the shared checks. Prints findings, exit 1 on any.
# The generic checks live in the shared scripts: Check-ModBasics, Check-Translations, Check-SettingsContract, Check-HarmonyContract
# (run here only for the mod's own hooks and the non-public members it needs), Check-Steps. The game-bound half (reflection on
# Assembly-CSharp and on the shipped DLL, Scribe) is skipped, loudly, where the game is absent (a GitHub runner), never passed silently.
$ErrorActionPreference = 'Stop'
$root = (Resolve-Path -LiteralPath $ModRoot).Path
$mod = Join-Path $root 'Mod'
$script:findings = @()
$script:ran = 0
$Managed = 'C:\Program Files (x86)\Steam\steamapps\common\RimWorld\RimWorldWin64_Data\Managed'
$BFis = [System.Reflection.BindingFlags]'Public,NonPublic,Instance,Static'

# One rule: the block returns its problems; each is printed under the rule name.
function It([string]$name, [scriptblock]$body) {
    $script:ran++
    try { $problems = @(& $body | Where-Object { $_ }) } catch { $problems = @("threw: $($_.Exception.GetBaseException().Message)") }
    foreach ($p in $problems) { $script:findings += "[$name] $p" }
}
function Read-Text([string]$p) { Get-Content -LiteralPath $p -Raw -Encoding UTF8 }
function Assert-Near([double]$actual, [double]$expected, [string]$context) {
    if ([double]::IsNaN($actual) -or [Math]::Abs($actual - $expected) -gt 0.00001) { throw "$context expected $expected, got $actual" }
}

# ---------------------------------------------------------------------------------------------------------------------
# Without the game: files, defs, texts
# ---------------------------------------------------------------------------------------------------------------------
It 'About identity, Harmony dependency, supported game and visible source link' {
    [xml]$about = Read-Text (Join-Path $mod 'About/About.xml')
    $meta = $about.ModMetaData
    if ($meta.name -cne 'Fieldwork Companions') { 'unexpected mod title' }
    if ($meta.packageId -cne 'nelim.fieldworkcompanions') { 'unexpected packageId' }
    if (@($meta.supportedVersions.li) -notcontains '1.6') { 'RimWorld 1.6 is not declared' }
    if (@($meta.modDependencies.li.packageId) -notcontains 'brrainz.harmony') { 'Harmony dependency missing' }
    $url = 'https://github.com/vbardales/Rimworld-Fieldwork-Companions'
    if ($meta.url -cne $url -or -not $meta.description.Contains($url)) { 'GitHub link missing or inconsistent' }
}

It 'The assist mark def is wired to its class, draws a GUI overlay, and the settings shortcut is hidden by default' {
    [xml]$mote = Read-Text (Join-Path $mod 'Defs/MoteDefs/FieldworkCompanions.xml')
    $d = $mote.Defs.ThingDef
    if ($d.defName -cne 'FieldworkCompanions_AssistMark') { 'mote def renamed' }
    if ($d.thingClass -cne 'FieldworkCompanions.AssistMark') { 'mote class disconnected' }
    if ($d.drawGUIOverlay -cne 'true') { 'mote no longer draws its GUI overlay' }
    [xml]$btn = Read-Text (Join-Path $mod 'Defs/MainButtonDefs/FieldworkCompanions.xml')
    $b = $btn.Defs.MainButtonDef
    if ($b.defName -cne 'FieldworkCompanions_Settings') { 'shortcut def renamed' }
    if ($b.buttonVisible -cne 'false') { 'shortcut must be hidden by default (buttonVisible false)' }
}

It 'Settings page source: markScale slider is greyed out while the mark is off, and the values are stored and bounded' {
    $page = Read-Text (Join-Path $root 'Source/FieldworkCompanionsMod.cs')
    foreach ($needle in 'GUI.enabled = settings.showMote', 'GUI.enabled = wasEnabled', 'FieldworkCompanions.Settings.MarkScaleTip', 'settings.Reset', 'Settings.Normalize()') {
        if (-not $page.Contains($needle)) { "Source/FieldworkCompanionsMod.cs lost '$needle'" }
    }
    $set = Read-Text (Join-Path $root 'Source/FieldworkCompanionsSettings.cs')
    foreach ($needle in 'Scribe_Values.Look(ref markScale, "markScale", 1f)', 'markScale = Bound(markScale, 1f, 4f, 1f)', 'markScale = 1f;') {
        if (-not $set.Contains($needle)) { "Source/FieldworkCompanionsSettings.cs lost '$needle'" }
    }
}

It 'English and French Keyed hold the same keys and the same format tokens, every one formats' {
    [xml]$en = Read-Text (Join-Path $mod 'Languages/English/Keyed/FieldworkCompanions.xml')
    [xml]$fr = Read-Text (Join-Path $mod 'Languages/French/Keyed/FieldworkCompanions.xml')
    $enKeys = @($en.LanguageData.ChildNodes | Where-Object NodeType -eq Element | ForEach-Object Name)
    $frKeys = @($fr.LanguageData.ChildNodes | Where-Object NodeType -eq Element | ForEach-Object Name)
    foreach ($k in $enKeys) { if ($frKeys -cnotcontains $k) { "French lacks $k" } }
    foreach ($k in $frKeys) { if ($enKeys -cnotcontains $k) { "English lacks $k" } }
    foreach ($key in 'MarkScale', 'MarkScaleTip') { if ($enKeys -cnotcontains "FieldworkCompanions.Settings.$key") { "English lacks the $key key" } }
    foreach ($n in $en.LanguageData.ChildNodes | Where-Object NodeType -eq Element) {
        $v = $fr.LanguageData.SelectSingleNode($n.Name).InnerText
        foreach ($pattern in '\{[^}]+\}', '\\n', '</?[^>]+>') {
            if (([regex]::Matches($n.InnerText, $pattern).Value -join '|') -cne ([regex]::Matches($v, $pattern).Value -join '|')) { "Formatting mismatch $($n.Name)" }
        }
        $null = [string]::Format($n.InnerText, 42); $null = [string]::Format($v, 42)
    }
}

# ---------------------------------------------------------------------------------------------------------------------
# With the game: the shipped DLL against Assembly-CSharp. No game: skipped, loudly.
# ---------------------------------------------------------------------------------------------------------------------
$modDll = Join-Path $mod 'Assemblies/FieldworkCompanions.dll'
$gameDll = Join-Path $Managed 'Assembly-CSharp.dll'
$lib = if ($SharedDir) { Join-Path $SharedDir 'lib/GameReflection.ps1' }
if (-not (Test-Path -LiteralPath $gameDll) -or -not $lib -or -not (Test-Path -LiteralPath $lib)) {
    Write-Host 'WARNING Rule-OwnValues: the game or lib/GameReflection.ps1 is absent: settings behaviour, hooks and consumer links SKIPPED, not passed' -ForegroundColor Yellow
} else {
    . $lib
    Initialize-GameReflection -Managed $Managed
    try {
        $gameAsm = [System.Reflection.Assembly]::LoadFrom($gameDll)
        $modAsm = [System.Reflection.Assembly]::LoadFrom($modDll)
        $tSettings = $modAsm.GetType('FieldworkCompanions.FieldworkCompanionsSettings', $true)
        $tMod = $modAsm.GetType('FieldworkCompanions.FieldworkCompanionsMod', $true)
        $tCompanions = $modAsm.GetType('FieldworkCompanions.Companions', $true)
        $tMark = $modAsm.GetType('FieldworkCompanions.AssistMark', $true)
        function New-Settings { [Activator]::CreateInstance($tSettings) }
        function Assert-SettingsEqual($actual, $expected) {
            foreach ($f in $tSettings.GetFields([Reflection.BindingFlags]'Public,Instance,DeclaredOnly')) {
                if ($f.FieldType -eq [float]) { Assert-Near $f.GetValue($actual) $f.GetValue($expected) $f.Name }
                elseif ($f.GetValue($actual) -ne $f.GetValue($expected)) { throw "Mismatch: $($f.Name)" }
            }
        }
        function Has($list, [string]$suffix) { @($list | Where-Object { $_ -like "*.$suffix" }).Count -gt 0 }

        It 'All 13 defaults are the documented ones and Reset restores every one' {
            $s = New-Settings
            foreach ($entry in @{ baseChance = 0.15; perStepBonus = 0.10; bondBonus = 0.15; bonusShare = 0.25; bondChance = 0.005; radius = 8; markScale = 1 }.GetEnumerator()) {
                Assert-Near $s.($entry.Key) $entry.Value $entry.Key
            }
            $bools = @('assistMining', 'assistHarvest', 'assistFishing', 'assistGathering', 'requireSpecialty', 'showMote')
            foreach ($name in $bools) { if (-not $s.$name) { "Default $name must be true" }; $s.$name = $false }
            $s.baseChance = 0.8; $s.perStepBonus = 0.4; $s.bondBonus = 0.8; $s.bonusShare = 1.3; $s.radius = 25; $s.bondChance = 0.03; $s.markScale = 3.5
            $s.Reset(); Assert-SettingsEqual $s (New-Settings)
            $count = @($tSettings.GetFields([Reflection.BindingFlags]'Public,Instance,DeclaredOnly')).Count
            if ($count -ne 13) { "Expected 13 settings fields, found ${count}: the audit and this rule must grow together" }
        }

        It 'Stored values are bounded, nonfinite falls back to the default, normalization is idempotent (markScale 1 to 4 included)' {
            $ranges = @{ baseChance = @(0, 1, 0.15); perStepBonus = @(0, 0.5, 0.1); bondBonus = @(0, 1, 0.15); bonusShare = @(0.05, 2, 0.25); bondChance = @(0, 0.05, 0.005); markScale = @(1, 4, 1) }
            foreach ($name in $ranges.Keys) {
                $r = $ranges[$name]
                foreach ($pair in @(@(-99, $r[0]), @(99, $r[1]), @([float]::NaN, $r[2]), @([float]::PositiveInfinity, $r[2]), @([float]::NegativeInfinity, $r[2]))) {
                    $s = New-Settings; $s.$name = [float]$pair[0]; $s.Normalize()
                    Assert-Near $s.$name $pair[1] "$name from $($pair[0])"; $s.Normalize(); Assert-Near $s.$name $pair[1] "$name idempotence"
                }
            }
            $s = New-Settings; $s.markScale = 2.5; $s.Normalize(); Assert-Near $s.markScale 2.5 'markScale inside the range'
            $s.radius = [int]::MaxValue; $s.Normalize(); Assert-Near $s.radius 30 'radius max'
            $s.radius = [int]::MinValue; $s.Normalize(); Assert-Near $s.radius 2 'radius min'
        }

        It 'The chance responds at once to base, training and bond, never above 100 percent; the radius boundary holds at every radius' {
            $s = New-Settings
            Assert-Near ($s.AssistChance(0, $false)) 0.15 'no specialty'
            Assert-Near ($s.AssistChance(3, $false)) 0.45 'trained'
            Assert-Near ($s.AssistChance(3, $true)) 0.6 'trained and bonded'
            $s.baseChance = 0; $s.perStepBonus = 0; $s.bondBonus = 0
            Assert-Near ($s.AssistChance(3, $true)) 0 'disabled chances'
            $s.baseChance = 0.2; $s.perStepBonus = 0.1; $s.bondBonus = 0.3
            Assert-Near ($s.AssistChance(2, $true)) 0.7 'base, step and bond together'
            $s.perStepBonus = 0.5; Assert-Near ($s.AssistChance(3, $true)) 1 'ceiling'
            $s.Reset(); Assert-Near ($s.AssistChance(3, $true)) 0.6 'restored'
            for ($r = 2; $r -le 30; $r++) {
                $s.radius = $r
                if (-not $s.WithinRadius($r * $r) -or $s.WithinRadius($r * $r + 1) -or -not $s.WithinRadius(0)) { "Radius $r boundary" }
            }
        }

        It 'All 16 work-switch combinations reach the live dispatcher and the bonus share changes the real yield' {
            $s = New-Settings
            $setter = $tMod.GetProperty('Settings').GetSetMethod($true)
            $previous = $tMod.GetProperty('Settings').GetValue($null)
            try {
                $null = $setter.Invoke($null, @($s))
                $enabled = $tCompanions.GetMethod('KindEnabled', $BFis)
                $kindType = $modAsm.GetType('FieldworkCompanions.AssistKind', $true)
                $names = @('assistMining', 'assistHarvest', 'assistFishing', 'assistGathering')
                for ($mask = 0; $mask -lt 16; $mask++) {
                    for ($i = 0; $i -lt 4; $i++) { $s.($names[$i]) = ($mask -band (1 -shl $i)) -ne 0 }
                    for ($i = 0; $i -lt 4; $i++) {
                        if ($enabled.Invoke($null, @([Enum]::ToObject($kindType, $i))) -ne $s.($names[$i])) { "Switch $i, mask $mask" }
                    }
                }
                $bonus = $tCompanions.GetMethod('BonusCount')
                foreach ($pair in @(@(0.05, 1), @(0.25, 5), @(1, 20), @(2, 40))) {
                    $s.bonusShare = $pair[0]; Assert-Near ($bonus.Invoke($null, @(20))) $pair[1] "bonus share $($pair[0])"
                }
                Assert-Near ($bonus.Invoke($null, @(0))) 1 'minimum bonus'
                $s.Reset(); Assert-Near ($bonus.Invoke($null, @(20))) 5 'restored share'
            } finally { $null = $setter.Invoke($null, @($previous)) }
        }

        $scribe = $gameAsm.GetType('Verse.Scribe', $true)
        $saver = $scribe.GetField('saver').GetValue($null)
        $loader = $scribe.GetField('loader').GetValue($null)
        $scratch = Join-Path ([IO.Path]::GetTempPath()) ('fwc-settings-' + [guid]::NewGuid().ToString('N'))
        $null = New-Item -ItemType Directory -Path $scratch -Force
        function Read-TestSettings([string]$path) {
            $s = New-Settings
            try { $loader.InitLoading($path); $s.ExposeData(); return $s } finally { $loader.ForceStop() }
        }
        try {
            It 'The real Scribe round-trips all 13 values from English and French hosts' {
                $byName = @{}
                foreach ($t in @(Get-AssemblyTypes $gameDll)) { if ($t.Name -and -not $byName.ContainsKey($t.Name)) { $byName[$t.Name] = $t } }
                $culture = [Threading.Thread]::CurrentThread.CurrentCulture
                try {
                    foreach ($language in 'en-US', 'fr-FR') {
                        [Threading.Thread]::CurrentThread.CurrentCulture = [Globalization.CultureInfo]::GetCultureInfo($language)
                        $null = $byName['CultureInfoUtility'].GetMethod('EnsureEnglish', $BFis).Invoke($null, @())
                        foreach ($custom in $false, $true) {
                            $s = New-Settings
                            if ($custom) {
                                $s.baseChance = 0.33; $s.perStepBonus = 0.22; $s.bondBonus = 0.44; $s.bonusShare = 1.25; $s.bondChance = 0.023; $s.radius = 17; $s.markScale = 2.75
                                foreach ($f in $tSettings.GetFields() | Where-Object FieldType -eq ([bool])) { $f.SetValue($s, $false) }
                            }
                            $path = Join-Path $scratch "$language-$custom.xml"
                            try { $saver.InitSaving($path, 'settings'); $s.ExposeData(); $saver.FinalizeSaving() } finally { $saver.ForceStop() }
                            Assert-SettingsEqual (Read-TestSettings $path) $s
                        }
                    }
                } finally { [Threading.Thread]::CurrentThread.CurrentCulture = $culture }
            }

            It 'Older and out-of-range files keep the known values, default the missing ones, and are bounded on load (markScale included)' {
                $path = Join-Path $scratch 'older.xml'
                [IO.File]::WriteAllText($path, '<settings><baseChance>0.32</baseChance><showMote>False</showMote><obsolete>ignored</obsolete></settings>')
                $expected = New-Settings; $expected.baseChance = 0.32; $expected.showMote = $false
                Assert-SettingsEqual (Read-TestSettings $path) $expected
                [IO.File]::WriteAllText($path, '<settings><baseChance>NaN</baseChance><perStepBonus>-5</perStepBonus><bondBonus>Infinity</bondBonus><bonusShare>99</bonusShare><radius>2147483647</radius><bondChance>-1</bondChance><markScale>99</markScale></settings>')
                $expected = New-Settings; $expected.perStepBonus = 0; $expected.bonusShare = 2; $expected.radius = 30; $expected.bondChance = 0; $expected.markScale = 4
                Assert-SettingsEqual (Read-TestSettings $path) $expected
                foreach ($pair in @(@('-3', 1), @('NaN', 1), @('3.25', 3.25))) {
                    [IO.File]::WriteAllText($path, "<settings><markScale>$($pair[0])</markScale></settings>")
                    Assert-Near (Read-TestSettings $path).markScale $pair[1] "markScale file value $($pair[0])"
                }
            }
        } finally { Remove-Item -LiteralPath $scratch -Recurse -Force -ErrorAction SilentlyContinue }

        It 'Each setting reaches its production consumer: chance, radius, specialty, bond, mark, mark size and the custom mote' {
            foreach ($pair in @(@('ChanceFor', 'AssistChance'), @('HelperFor', 'WithinRadius'), @('Qualifies', 'get_Settings'), @('TryAssist', 'TryDevelopBondRelation'), @('NoteAssist', 'Throw'))) {
                if (-not (Has (Calls-Of $tCompanions.GetMethod($pair[0], $BFis)) $pair[1])) { "$($pair[0]) no longer calls $($pair[1])" }
            }
            foreach ($pair in @(@('Qualifies', 'requireSpecialty'), @('TryAssist', 'bondChance'), @('NoteAssist', 'showMote'))) {
                if (-not (Has (Fields-Of $tCompanions.GetMethod($pair[0], $BFis)) $pair[1])) { "$($pair[0]) no longer reads $($pair[1])" }
            }
            $throw = $tMark.GetMethod('Throw')
            if (-not (Has (Fields-Of $throw) 'markScale')) { 'AssistMark.Throw does not read the markScale setting' }
            if (-not (Has (Calls-Of $throw) 'get_Settings')) { 'AssistMark.Throw does not read the live settings' }
            if (-not (Has (Fields-Of $tMark.GetMethod('DrawGUIOverlay')) 'scale')) { 'AssistMark.DrawGUIOverlay is no longer gated on scale' }
            $calls = Calls-Of $tMod.GetMethod('WriteSettings')
            foreach ($name in 'Normalize', 'WriteSettings') { if (-not (Has $calls $name)) { "WriteSettings no longer calls $name" } }
        }
    } finally { Remove-GameReflection }

    # What the four hooks ask of the game: the shared contract check, given the mod's own facts (hook signatures, the three non-public
    # members the source needs a publiciser for). ResourceDef and ResourceAmount are protected abstract (milking), GetSteps is internal.
    It 'Harmony contract: the four hooks resolve, and the only non-public members reached are the three known ones' {
        $contract = if ($SharedDir) { Join-Path $SharedDir 'Check-HarmonyContract.ps1' }
        if (-not $contract -or -not (Test-Path -LiteralPath $contract)) { throw 'Check-HarmonyContract.ps1 not found in the shared folder' }
        $out = @(& powershell -NoProfile -ExecutionPolicy Bypass -File $contract -ModRoot $root `
            -Hooks 'CompHasGatherableBodyResource.Gathered,FishingUtility.GetCatchesFor,Mineable.DestroyMined,Plant.PlantCollected' `
            -MinPatches 4 -CompileProbe `
            -ExpectedNonPublic 'CompHasGatherableBodyResource.ResourceDef,CompHasGatherableBodyResource.ResourceAmount,Pawn_TrainingTracker.GetSteps' 2>&1 | ForEach-Object { "$_" })
        if ($LASTEXITCODE -ne 0) { $out | Where-Object { $_ -match '\S' } | Select-Object -Last 15 }
    }
}

if ($script:findings.Count) { $script:findings; exit 1 }
Write-Output "PASS: Rule-OwnValues ($($script:ran) rules)"
