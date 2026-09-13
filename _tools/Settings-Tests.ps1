# Dot-sourced by Run-Functional-Tests.ps1 with the delivered DLL and actual game loaded.
# No Unity UI or customization mod is launched. Scribe tests use isolated scalar files.
Section 'Settings behavior and native shortcut contract'
$settingsType=$modAsm.GetType('FieldworkCompanions.FieldworkCompanionsSettings',$true)
$modType=$modAsm.GetType('FieldworkCompanions.FieldworkCompanionsMod',$true)
$companionsType=$modAsm.GetType('FieldworkCompanions.Companions',$true)
function New-Settings { [Activator]::CreateInstance($settingsType) }
function Assert-Near([double]$actual,[double]$expected,[string]$context) {
    if ([double]::IsNaN($actual) -or [Math]::Abs($actual-$expected) -gt 0.00001) {
        throw "$context expected $expected, got $actual"
    }
}
function Assert-SettingsEqual($actual,$expected) {
    foreach($f in $settingsType.GetFields([Reflection.BindingFlags]'Public,Instance,DeclaredOnly')) {
        if($f.FieldType -eq [float]) { Assert-Near $f.GetValue($actual) $f.GetValue($expected) $f.Name }
        elseif($f.GetValue($actual) -ne $f.GetValue($expected)) { throw "Mismatch: $($f.Name)" }
    }
}

It 'all 12 defaults and reset agree, including radius and switches' {
    $s=New-Settings
    foreach($entry in @{baseChance=0.15;perStepBonus=0.10;bondBonus=0.15;bonusShare=0.25;bondChance=0.005;radius=8}.GetEnumerator()) {
        Assert-Near $s.($entry.Key) $entry.Value $entry.Key
    }
    foreach($name in @('assistMining','assistHarvest','assistFishing','assistGathering','requireSpecialty','showMote')) {
        if(-not $s.$name){throw "Default $name"}; $s.$name=$false
    }
    $s.baseChance=0.8; $s.perStepBonus=0.4; $s.bondBonus=0.8; $s.bonusShare=1.3; $s.radius=25; $s.bondChance=0.03
    $s.Reset(); Assert-SettingsEqual $s (New-Settings)
}

It 'loaded numeric ranges reject nonfinite values and normalization is idempotent' {
    $ranges=@{baseChance=@(0,1,0.15);perStepBonus=@(0,0.5,0.1);bondBonus=@(0,1,0.15);bonusShare=@(0.05,2,0.25);bondChance=@(0,0.05,0.005)}
    foreach($name in $ranges.Keys) {
        $r=$ranges[$name]
        foreach($pair in @(@(-99,$r[0]),@(99,$r[1]),@([float]::NaN,$r[2]),@([float]::PositiveInfinity,$r[2]),@([float]::NegativeInfinity,$r[2]))) {
            $s=New-Settings; $s.$name=[float]$pair[0]; $s.Normalize()
            Assert-Near $s.$name $pair[1] $name; $s.Normalize(); Assert-Near $s.$name $pair[1] 'idempotence'
        }
    }
    $s=New-Settings; $s.radius=[int]::MaxValue; $s.Normalize(); Assert-Near $s.radius 30 'radius max'
    $s.radius=[int]::MinValue; $s.Normalize(); Assert-Near $s.radius 2 'radius min'
}

It 'production probability responds immediately to base, training and bond without exceeding 100 percent' {
    $s=New-Settings
    Assert-Near ($s.AssistChance(0,$false)) 0.15 'no specialty'
    Assert-Near ($s.AssistChance(3,$false)) 0.45 'trained'
    Assert-Near ($s.AssistChance(3,$true)) 0.6 'trained and bonded'
    $s.baseChance=0; $s.perStepBonus=0; $s.bondBonus=0
    Assert-Near ($s.AssistChance(3,$true)) 0 'disabled chances'
    $s.baseChance=0.2; Assert-Near ($s.AssistChance(3,$false)) 0.2 'base change'
    $s.perStepBonus=0.1; Assert-Near ($s.AssistChance(2,$false)) 0.4 'step change'
    $s.bondBonus=0.3; Assert-Near ($s.AssistChance(2,$true)) 0.7 'bond change'
    $s.perStepBonus=0.5; Assert-Near ($s.AssistChance(3,$true)) 1 'ceiling'
    $s.Reset(); Assert-Near ($s.AssistChance(3,$true)) 0.6 'restored'
}

It 'production distance check includes the boundary at every allowed radius' {
    $s=New-Settings
    for($r=2;$r -le 30;$r++) {
        $s.radius=$r
        if(-not $s.WithinRadius($r*$r) -or $s.WithinRadius($r*$r+1) -or -not $s.WithinRadius(0)) {throw "Radius $r"}
    }
    $s.Reset(); if($s.WithinRadius(65)){throw 'Radius reset did not take effect'}
}

It 'all 16 work-switch combinations affect the live dispatcher and bonus share affects actual yield' {
    $s=New-Settings
    $setter=$modType.GetProperty('Settings').GetSetMethod($true)
    $previous=$modType.GetProperty('Settings').GetValue($null)
    try {
        $null=$setter.Invoke($null,@($s))
        $enabled=$companionsType.GetMethod('KindEnabled',$BFis)
        $kindType=$modAsm.GetType('FieldworkCompanions.AssistKind',$true)
        $names=@('assistMining','assistHarvest','assistFishing','assistGathering')
        for($mask=0;$mask -lt 16;$mask++) {
            for($i=0;$i -lt 4;$i++) {$s.($names[$i])=($mask -band (1 -shl $i)) -ne 0}
            for($i=0;$i -lt 4;$i++) {
                $actual=$enabled.Invoke($null,@([Enum]::ToObject($kindType,$i)))
                if($actual -ne $s.($names[$i])){throw "Switch $i mask $mask"}
            }
        }
        $bonus=$companionsType.GetMethod('BonusCount')
        foreach($pair in @(@(0.05,1),@(0.25,5),@(1,20),@(2,40))) {
            $s.bonusShare=$pair[0]; Assert-Near ($bonus.Invoke($null,@(20))) $pair[1] 'bonus share'
        }
        Assert-Near ($bonus.Invoke($null,@(0))) 1 'minimum bonus'
        $s.Reset(); Assert-Near ($bonus.Invoke($null,@(20))) 5 'restored share'
    } finally {$null=$setter.Invoke($null,@($previous))}
}

$scribe=$gameAsm.GetType('Verse.Scribe',$true)
$saver=$scribe.GetField('saver').GetValue($null)
$loader=$scribe.GetField('loader').GetValue($null)
$scratch=Join-Path $ModRoot '.build/settings-tests'
$null=New-Item -ItemType Directory -Path $scratch -Force
function Read-TestSettings([string]$path) {
    $s=New-Settings
    try {$loader.InitLoading($path); $s.ExposeData(); return $s}
    finally {$loader.ForceStop()}
    # Scalar settings need no cross-reference pass. FinalizeLoading requires Unity profiling.
}

It 'real Scribe round-trips all values after native culture initialization from EN and FR hosts' {
    $culture=[Threading.Thread]::CurrentThread.CurrentCulture
    try {
        foreach($language in @('en-US','fr-FR')) {
            [Threading.Thread]::CurrentThread.CurrentCulture=[Globalization.CultureInfo]::GetCultureInfo($language)
            # Verse.Root calls this before game initialization, independently of UI language.
            # Without it Scribe writes French commas but parses invariant numbers: a harness error.
            $null=$byName['CultureInfoUtility'].GetMethod('EnsureEnglish',$BFis).Invoke($null,@())
            foreach($custom in @($false,$true)) {
                $s=New-Settings
                if($custom) {
                    $s.baseChance=0.33; $s.perStepBonus=0.22; $s.bondBonus=0.44; $s.bonusShare=1.25; $s.bondChance=0.023; $s.radius=17
                    foreach($f in $settingsType.GetFields() | Where-Object FieldType -eq ([bool])){$f.SetValue($s,$false)}
                }
                $path=Join-Path $scratch "$language-$custom.xml"
                try {$saver.InitSaving($path,'settings'); $s.ExposeData(); $saver.FinalizeSaving()}
                finally {$saver.ForceStop()}
                Assert-SettingsEqual (Read-TestSettings $path) $s
            }
        }
    } finally {[Threading.Thread]::CurrentThread.CurrentCulture=$culture}
}

It 'older and out-of-range files retain known values, default missing fields and normalize on load' {
    $path=Join-Path $scratch 'older.xml'
    [IO.File]::WriteAllText($path,'<settings><baseChance>0.32</baseChance><showMote>False</showMote><obsolete>ignored</obsolete></settings>')
    $expected=New-Settings; $expected.baseChance=0.32; $expected.showMote=$false
    Assert-SettingsEqual (Read-TestSettings $path) $expected
    [IO.File]::WriteAllText($path,'<settings><baseChance>NaN</baseChance><perStepBonus>-5</perStepBonus><bondBonus>Infinity</bondBonus><bonusShare>99</bonusShare><radius>2147483647</radius><bondChance>-2</bondChance></settings>')
    $expected=New-Settings; $expected.perStepBonus=0; $expected.bonusShare=2; $expected.radius=30; $expected.bondChance=0
    Assert-SettingsEqual (Read-TestSettings $path) $expected
}

It 'shortcut definition uses real native fields, is hidden and can be revealed without a second UI' {
    [xml]$xml=Get-Content (Join-Path $ModRoot 'Mod/Defs/MainButtonDefs/FieldworkCompanions.xml') -Raw
    $defType=$gameAsm.GetType('RimWorld.MainButtonDef',$true)
    $def=[Activator]::CreateInstance($defType)
    foreach($n in $xml.Defs.MainButtonDef.ChildNodes | Where-Object NodeType -eq Element) {
        $f=$defType.GetField($n.Name,$BFis); if($null -eq $f){throw "Unknown Def field $($n.Name)"}
        $value=if($f.FieldType -eq [type]){$modAsm.GetType($n.InnerText,$true)}else{[Convert]::ChangeType($n.InnerText,$f.FieldType)}
        $f.SetValue($def,$value)
    }
    $worker=$def.Worker
    if($def.buttonVisible -or -not $def.validWithoutMap -or $null -ne $def.tabWindowClass){throw 'Incorrect hidden shortcut configuration'}
    $def.buttonVisible=$true; if(-not $worker.def.buttonVisible){throw 'Cannot reveal'}
    $def.buttonVisible=$false; if($worker.def.buttonVisible){throw 'Cannot hide again'}
    $visible=$worker.GetType().GetProperty('Visible').GetMethod
    if($visible.DeclaringType.FullName -ne 'RimWorld.MainButtonWorker'){throw 'Overrides native visibility'}
    $visibilityFields=@(Get-Refs $visible | ForEach-Object {$_.Member.Name})
    if($visibilityFields -notcontains 'buttonVisible'){throw 'Native visibility no longer reads buttonVisible'}
    $calls=@(Get-Refs $worker.GetType().GetMethod('Activate') | ForEach-Object { $_.Member.DeclaringType.FullName+'.'+$_.Member.Name })
    foreach($expected in @('FieldworkCompanions.FieldworkCompanionsMod.get_Instance','RimWorld.Dialog_ModSettings..ctor','Verse.WindowStack.Add')) {
        if($calls -notcontains $expected){throw "Missing shortcut call $expected"}
    }
    $dialog=$gameAsm.GetType('RimWorld.Dialog_ModSettings',$true)
    if(@(Get-Refs $dialog.GetMethod('PreClose') | ForEach-Object {$_.Member.Name}) -notcontains 'WriteSettings'){throw 'Native close no longer saves'}
    if(@(Get-Refs $dialog.GetMethod('DoWindowContents') | ForEach-Object {$_.Member.Name}) -notcontains 'DoSettingsWindowContents'){throw 'Native dialog no longer uses primary UI'}
}

It 'production links tested math and remaining settings to their actual consumers' {
    foreach($pair in @(@('ChanceFor','AssistChance'),@('HelperFor','WithinRadius'),@('Qualifies','get_Settings'),@('TryAssist','TryDevelopBondRelation'),@('NoteAssist','ThrowText'))) {
        if(@(Get-Refs $companionsType.GetMethod($pair[0],$BFis) | ForEach-Object {$_.Member.Name}) -notcontains $pair[1]){throw "Missing production call $pair"}
    }
    foreach($pair in @(@('Qualifies','requireSpecialty'),@('TryAssist','bondChance'),@('NoteAssist','showMote'))) {
        if(@(Get-Refs $companionsType.GetMethod($pair[0],$BFis) | ForEach-Object {$_.Member.Name}) -notcontains $pair[1]){throw "Missing production field $pair"}
    }
    $calls=@(Get-Refs $modType.GetMethod('WriteSettings') | ForEach-Object {$_.Member.DeclaringType.FullName+'.'+$_.Member.Name})
    foreach($name in @('FieldworkCompanions.FieldworkCompanionsSettings.Normalize','Verse.Mod.WriteSettings')){if($calls -notcontains $name){throw "Missing close operation $name"}}
}

It 'shortcut EN source and French injection cover both fields; Keyed parameters and line breaks match' {
    [xml]$defs=Get-Content (Join-Path $ModRoot 'Mod/Defs/MainButtonDefs/FieldworkCompanions.xml') -Raw
    [xml]$fr=Get-Content (Join-Path $ModRoot 'Mod/Languages/French/DefInjected/MainButtonDef/FieldworkCompanions.xml') -Raw
    foreach($field in @('label','description')) {
        if([string]::IsNullOrWhiteSpace($defs.Defs.MainButtonDef.$field) -or [string]::IsNullOrWhiteSpace($fr.LanguageData.SelectSingleNode("FieldworkCompanions_Settings.$field").InnerText)){throw "Missing shortcut $field"}
    }
    [xml]$en=Get-Content (Join-Path $ModRoot 'Mod/Languages/English/Keyed/FieldworkCompanions.xml') -Raw
    [xml]$fr=Get-Content (Join-Path $ModRoot 'Mod/Languages/French/Keyed/FieldworkCompanions.xml') -Raw
    foreach($n in $en.LanguageData.ChildNodes | Where-Object NodeType -eq Element) {
        $v=$fr.LanguageData.SelectSingleNode($n.Name).InnerText
        foreach($pattern in @('\{[^}]+\}','\\n','</?[^>]+>')) {
            if(([regex]::Matches($n.InnerText,$pattern).Value -join '|') -cne ([regex]::Matches($v,$pattern).Value -join '|')){throw "Formatting mismatch $($n.Name)"}
        }
        $null=[string]::Format($n.InnerText,42); $null=[string]::Format($v,42)
    }
}
