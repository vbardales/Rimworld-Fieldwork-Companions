<#
.SYNOPSIS
  Asks the installed game whether it still does what this mod hooks into. No RimWorld launched.

.DESCRIPTION
  FUNCTIONAL-SCENARIOS.md next door lists what to watch for in a running colony. This asks the
  questions that can be settled without one.

  This mod is four Harmony patches on four vanilla methods and a die roll inside each. It owns no
  gameplay def, no comp and no saved colony data; the original checks focus on the
  four hand-offs, and every one of them fails SILENTLY when the game moves underneath it. A
  renamed target means Harmony throws at startup, which is loud. Everything else - a subclass that
  overrides the target, a training def that stops existing, a stat that gains a cap - is quiet.

  The first section is the one that earned this file. On 2026-09-12 this assembly was found with
  no [assembly: IgnoresAccessChecksTo]: Krafs.Publicizer applies it through the SDK's generated
  AssemblyInfo, and this project sets GenerateAssemblyInfo to false, so the attribute's TYPE was
  embedded and the grant never applied. The build was clean and the log said nothing. Contented
  Livestock had the same fault on fields rather than properties.

  READ A FAILURE THERE CORRECTLY. It means "this mod reaches for something it was not granted",
  which is true and worth fixing. It does NOT mean "this mod is broken in play": the Architect
  Studio session found a non-public call of its own, outside any try/catch, in an assembly with no
  grant, working in a real game. RimWorld runs on Mono; everything measured here runs under
  PowerShell on the desktop CLR. Nobody has produced a Player.log with the exception in it.

  The token scan and the access-grant invariant come from FireworkStand and EntityGazing, whose
  sessions wrote them on the back of that diagnosis. The compile probe is EntityGazing's test 7,
  turned around: this mod really does need the publiciser, so the probe asserts WHICH members it
  needs rather than that it needs none. A new name in that list is a new reach into the game's
  private parts, and it should be a decision, not a diff nobody read.

  WHAT IT FOUND ON ITS FIRST RUN. The mod needs THREE non-public members of the game, not the two
  the access-grant commit named: `Pawn_TrainingTracker.GetSteps` is internal, and it is read by
  `Companions.ChanceFor` - the per-training-step part of the chance, which is the mod's own scale.
  So the grant covers the core of the mod and not only its milking patch.

  FIVE OF THESE THIRTEEN HAVE BEEN SEEN TO FAIL, one fault at a time in a copy of the mod, never
  in the real files:

    Source/AccessChecks.cs deleted        -> the grant invariant, and the token scan with it,
                                             naming all three members and where each is reached
    a HarmonyPatch aimed at a wrong name  -> the attribute test
    a key dropped from the French file    -> the translation test
    a key asked for that exists nowhere   -> the translation test
    playerSettings.master read instead
      of the public Master                -> the compile probe, as a reach it does not know about
    the GetSteps call taken out           -> the compile probe, as a member no longer needed

  EIGHT COULD NOT BE, and this says so rather than letting the count imply otherwise. The hook
  signatures, the subclass sweep, the follow-fieldwork field, the bond call, the three DefOf
  fields, where Forage and Dig come from, and the four stat caps are all claims about
  Assembly-CSharp and the shipped defs. Mutating those to prove a test would mean rewriting the
  game. They are the tests that matter most and they are the ones with no red run behind them.

  Exit code 0 when everything passes, 1 otherwise.

.EXAMPLE
  powershell -NoProfile -ExecutionPolicy Bypass -File _tools/Run-Functional-Tests.ps1
#>

param(
    [string]$ModRoot  = (Split-Path -Parent $PSScriptRoot),
    [string]$GameData = 'C:\Program Files (x86)\Steam\steamapps\common\RimWorld\Data',
    [string]$Managed  = 'C:\Program Files (x86)\Steam\steamapps\common\RimWorld\RimWorldWin64_Data\Managed',
    # The mod compiles against Harmony but ships none of it (ExcludeAssets runtime), so reading its
    # [HarmonyPatch] attributes needs a copy from somewhere. The Harmony mod's own is the honest
    # one; the NuGet cache is the fallback for a machine without it subscribed.
    [string]$HarmonyDll = 'C:\Program Files (x86)\Steam\steamapps\workshop\content\294100\2009463077\Current\Assemblies\0Harmony.dll'
)

$ErrorActionPreference = 'Stop'

$script:ran = 0
$script:failed = 0

# A body returns nothing when all is well, or one string per problem. Returning strings rather
# than $true/$false is what lets a test report four faults at once instead of the first.
function It([string]$name, [scriptblock]$body) {
    $script:ran++
    $problems = @()
    try   { $problems = @(& $body | Where-Object { $_ }) }
    catch { $problems = @("threw: $($_.Exception.GetBaseException().Message)") }
    if ($problems.Count -eq 0) { Write-Output "  ok    $name" }
    else {
        $script:failed++
        Write-Output "  FAIL  $name"
        foreach ($p in $problems) { Write-Output "          $p" }
    }
}
function Section([string]$name) { Write-Output ''; Write-Output $name }
function Note([string]$text)    { Write-Host "        $text" -ForegroundColor DarkGray }

# ---------------------------------------------------------------------------------------------
# The two assemblies
# ---------------------------------------------------------------------------------------------

# Assembly-CSharp names Unity assemblies that are not beside this script. Remember what has been
# tried: an unresolvable name asked for twice recurses to a stack overflow rather than an error.
if (-not (Test-Path $HarmonyDll)) {
    $cached = Get-ChildItem (Join-Path $env:USERPROFILE '.nuget\packages\lib.harmony') -Recurse -Filter '0Harmony.dll' -ErrorAction SilentlyContinue |
              Sort-Object FullName | Select-Object -Last 1
    if ($cached) { $HarmonyDll = $cached.FullName }
}
$script:probeDirs = @($Managed)
if (Test-Path $HarmonyDll) { $script:probeDirs += (Split-Path -Parent $HarmonyDll) }

$script:probed = @{}
[System.AppDomain]::CurrentDomain.add_AssemblyResolve([System.ResolveEventHandler]{
    param($sender, $e)
    if ($null -eq $script:probed) { return $null }
    $short = $e.Name.Split(',')[0]
    if ($script:probed.ContainsKey($short)) { return $null }
    $script:probed[$short] = $true
    foreach ($d in $script:probeDirs) {
        $p = Join-Path $d "$short.dll"
        if (Test-Path $p) { return [System.Reflection.Assembly]::LoadFrom($p) }
    }
    return $null
})

# GetTypes() always throws here - Unity is missing - but the exception carries every type it did
# resolve, which is all of them but a handful. PowerShell wraps it, so both shapes are caught.
function Get-AssemblyTypes([System.Reflection.Assembly]$a) {
    try     { return $a.GetTypes() }
    catch [System.Reflection.ReflectionTypeLoadException] { return $_.Exception.Types | Where-Object { $_ } }
    catch   { return $_.Exception.InnerException.Types | Where-Object { $_ } }
}

$BFall = [System.Reflection.BindingFlags]'Public,NonPublic,Instance,Static,DeclaredOnly'
$BFi   = [System.Reflection.BindingFlags]'Public,NonPublic,Instance'
$BFis  = [System.Reflection.BindingFlags]'Public,NonPublic,Instance,Static'
$BFd   = [System.Reflection.BindingFlags]'Public,NonPublic,Instance,DeclaredOnly'
$BFn   = [System.Reflection.BindingFlags]'Public,NonPublic'

$gameAsm  = [System.Reflection.Assembly]::LoadFrom((Join-Path $Managed 'Assembly-CSharp.dll'))
$gameTypes = @(Get-AssemblyTypes $gameAsm)
$byName = @{}
foreach ($t in $gameTypes) { if ($t.Name -and -not $byName.ContainsKey($t.Name)) { $byName[$t.Name] = $t } }

$modDllPath = Join-Path $ModRoot 'Mod\Assemblies\FieldworkCompanions.dll'
$modAsm     = [System.Reflection.Assembly]::LoadFrom($modDllPath)
$modTypes   = @(Get-AssemblyTypes $modAsm)

function Read-Text([string]$p) { Get-Content $p -Raw -Encoding UTF8 }

# ---------------------------------------------------------------------------------------------
# Reading IL
# ---------------------------------------------------------------------------------------------
#
# Only the opcodes this suite asks about, each a byte followed by a four-byte metadata token.
#
# ldflda (0x7C) and ldsflda (0x7F) are in the list on purpose. A field of STRUCT type is read
# through its address, so a scan that knows only ldfld and stfld reports such a field as touched
# by nobody - which looks exactly like a real finding and is not. The EntityGazing session lost a
# run to that on an IntRange.
function Get-Refs($method) {
    $out = @()
    $body = $null
    try { $body = $method.GetMethodBody() } catch { }
    if (-not $body) { return $out }
    $il = $body.GetILAsByteArray()
    if (-not $il) { return $out }
    $mod = $method.Module
    for ($i = 0; $i -lt $il.Length - 4; $i++) {
        $op = $il[$i]
        $kind = $null; $at = $i + 1; $resolve = $null
        if     ($op -eq 0x28 -or $op -eq 0x6F -or $op -eq 0x73) { $kind = 'call'; $resolve = 'method' }
        elseif ($op -in 0x7B, 0x7C, 0x7D, 0x7E, 0x7F, 0x80)     { $kind = 'fld';  $resolve = 'field'  }
        elseif ($op -eq 0x74 -or $op -eq 0x75)                  { $kind = 'type'; $resolve = 'type'   }
        elseif ($op -eq 0xFE -and $i + 5 -lt $il.Length -and ($il[$i+1] -eq 0x06 -or $il[$i+1] -eq 0x07)) {
            $kind = $(if ($il[$i+1] -eq 0x06) { 'ldftn' } else { 'ldvirtftn' })
            $at = $i + 2; $resolve = 'method'
        }
        if (-not $kind) { continue }
        $tok = [BitConverter]::ToInt32($il, $at)
        $m = $null
        try {
            switch ($resolve) {
                'method' { $m = $mod.ResolveMethod($tok) }
                'field'  { $m = $mod.ResolveField($tok) }
                'type'   { $m = $mod.ResolveType($tok) }
            }
        } catch { }
        if ($m) { $out += ,@{ Kind = $kind; Member = $m } }
    }
    return $out
}

function Get-AllMethods([Type]$t) {
    $types = @($t) + @($t.GetNestedTypes($BFn))
    $out = @()
    foreach ($x in $types) {
        $out += @($x.GetMethods($BFall))
        $out += @($x.GetConstructors($BFall))
        foreach ($p in $x.GetProperties($BFd)) {
            $g = $p.GetGetMethod($true); if ($g) { $out += $g }
        }
    }
    return $out
}

function Get-Ancestry([Type]$t) {
    $names = @{}
    $cur = $t
    while ($cur -and $cur.FullName -ne 'System.Object') { $names[$cur.Name] = $true; $cur = $cur.BaseType }
    return $names
}

# The four gestures, as the mod hooks them. Every one of these is patched by full method name, so
# a rename is loud; what is quiet is everything else about them.
$Hooks = @(
    @{ Type = 'Mineable';                      Method = 'DestroyMined';   Params = @('Pawn') }
    @{ Type = 'Plant';                         Method = 'PlantCollected'; Params = @('Pawn', 'PlantDestructionMode') }
    @{ Type = 'FishingUtility';                Method = 'GetCatchesFor';  Params = @('Pawn', 'IntVec3', 'Boolean', 'Boolean&') }
    @{ Type = 'CompHasGatherableBodyResource'; Method = 'Gathered';       Params = @('Pawn') }
)

Write-Output ''
Write-Output 'Fieldwork Companions - functional tests'

# =============================================================================================
Section 'The harness itself'
# =============================================================================================

# Every negative test below - "no subclass overrides this", "no member is reached that should not
# be" - passes for free when its inputs are empty. These are counted first for that reason.
It 'the game and the mod assembly both loaded, with types in them' {
    if ($gameTypes.Count -lt 10000) { "only $($gameTypes.Count) types resolved out of Assembly-CSharp" }
    if ($modTypes.Count -lt 5)      { "only $($modTypes.Count) types resolved out of the mod assembly" }
    foreach ($n in 'Mineable', 'Plant', 'FishingUtility', 'CompHasGatherableBodyResource') {
        if (-not $byName[$n]) { "the game has no $n any more" }
    }
}

# =============================================================================================
Section 'Access: what the publiciser opened, and what the build applied'
# =============================================================================================

# The fault of 2026-09-12, and the check that does not lie. Grepping the DLL for the attribute
# name finds the TYPE whether the grant was applied or not, which is exactly the shape of the trap.
It 'the access grant and the publiciser agree: both declared, or neither' {
    $grant = @($modAsm.GetCustomAttributesData() |
               Where-Object { $_.AttributeType.Name -like 'IgnoresAccessChecksTo*' })
    $publicised = (Read-Text (Join-Path $ModRoot 'Source\FieldworkCompanions.csproj')) -match '<Publicize\b'
    Note ("publiciser declared: $publicised; access grant present: $($grant.Count -gt 0)")
    if ($publicised -ne ($grant.Count -gt 0)) {
        'a publiciser with no grant is the silent failure; a grant with no publiciser means the csproj changed under this test'
    }
}

# The same fault read from the other end: not "is the grant there" but "is anything reached that
# would need it". This one names the offender.
It 'the mod reaches for nothing in the game it is not allowed to reach for' {
    $hasGrant = @($modAsm.GetCustomAttributesData() |
                  Where-Object { $_.AttributeType.Name -like 'IgnoresAccessChecksTo*' }).Count -gt 0
    foreach ($t in $modTypes) {
        $family = Get-Ancestry $t
        foreach ($m in (Get-AllMethods $t)) {
            foreach ($r in (Get-Refs $m)) {
                if ($r.Kind -eq 'type') { continue }
                $member = $r.Member
                $decl = $member.DeclaringType
                if (-not $decl -or $decl.Assembly -ne $gameAsm) { continue }
                if ($member.IsPublic) { continue }
                # A protected member is legal from a subclass, with no grant at all. This is the
                # CS0507 case the FireworkStand session separated out: widening an override is not
                # a reach into anything.
                if (($member.IsFamily -or $member.IsFamilyOrAssembly) -and $family.ContainsKey($decl.Name)) { continue }
                if ($hasGrant) { continue }
                "$($t.Name).$($m.Name) touches $($decl.Name).$($member.Name), which is not public, and this assembly carries no access grant"
            }
        }
    }
}

# EntityGazing's compile probe, turned around. That mod needed nothing non-public, so its version
# asserts a clean build against the game's own assembly. This one DOES need the publiciser, so the
# useful assertion is WHICH members it needs: exactly two, both on the gathering comp. A third
# name appearing here is a new reach into the game's private parts and should be a decision.
It 'the source needs exactly the three non-public members it is known to need' {
    if (-not (Get-Command dotnet -ErrorAction SilentlyContinue)) { Note 'dotnet not on PATH, skipped'; return }
    # A short path on purpose: NuGet writes PublicizedAssemblies\<32 hex> under obj, and a session
    # scratchpad prefix pushes that past MAX_PATH - the build fails, and the cleanup fails after it.
    $probe = Join-Path $env:LOCALAPPDATA ('Temp\fwc-' + [guid]::NewGuid().ToString('N').Substring(0, 6))
    New-Item -ItemType Directory $probe -Force | Out-Null
    try {
        Copy-Item (Join-Path $ModRoot 'Source\*.cs') $probe
        Get-ChildItem (Join-Path $ModRoot 'Source') -Directory | ForEach-Object {
            Copy-Item $_.FullName $probe -Recurse
        }
        # AccessChecks.cs cannot come along: the attribute type it uses is defined BY the
        # publiciser, so without one the probe would fail on our own file and never reach the game.
        Remove-Item (Join-Path $probe 'AccessChecks.cs') -ErrorAction SilentlyContinue
        @"
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <OutputType>Library</OutputType><TargetFramework>net48</TargetFramework>
    <AssemblyName>FwcAccessProbe</AssemblyName>
    <GenerateAssemblyInfo>false</GenerateAssemblyInfo>
  </PropertyGroup>
  <ItemGroup>
    <Reference Include="Assembly-CSharp"><HintPath>$Managed\Assembly-CSharp.dll</HintPath><Private>false</Private></Reference>
    <Reference Include="UnityEngine.CoreModule"><HintPath>$Managed\UnityEngine.CoreModule.dll</HintPath><Private>false</Private></Reference>
    <Reference Include="UnityEngine"><HintPath>$Managed\UnityEngine.dll</HintPath><Private>false</Private></Reference>
    <PackageReference Include="Lib.Harmony" Version="2.*"><ExcludeAssets>runtime</ExcludeAssets></PackageReference>
  </ItemGroup>
</Project>
"@ | Set-Content (Join-Path $probe 'Probe.csproj') -Encoding UTF8
        $out = & dotnet build (Join-Path $probe 'Probe.csproj') -c Release -v q --nologo 2>&1 | Out-String
        $buildExit = $LASTEXITCODE
        $errs = @([regex]::Matches($out, '(?m)error CS\d+:.*$') | ForEach-Object { $_.Value } | Sort-Object -Unique)
        if ($buildExit -ne 0 -and $errs.Count -eq 0) {
            "compile probe failed before C# diagnostics (exit $buildExit): $out"
            return
        }

        # Two codes are the subject here and nothing else is. CS0122 for a protected member,
        # CS1061 for an internal one, which member lookup does not even see across assemblies.
        # Anything else means the probe itself broke rather than the mod reaching too far.
        foreach ($e in @($errs | Where-Object { $_ -notmatch 'error CS(0122|1061):' } | Select-Object -First 3)) {
            "unexpected: $e"
        }
        if (@($errs | Where-Object { $_ -notmatch 'error CS(0122|1061):' })) { return }

        # Identifiers are not translated, so the quoted names survive a localised compiler where
        # the sentence around them does not. Each error must name at least one known member.
        $wanted = @{
            'CompHasGatherableBodyResource.ResourceDef'    = 'the resource a milked or shorn animal gives'
            'CompHasGatherableBodyResource.ResourceAmount' = 'how much of it, and the base of the bonus'
            'GetSteps'                                     = 'Pawn_TrainingTracker.GetSteps, internal, the per-step chance'
        }
        $hit = @{}
        foreach ($e in $errs) {
            $names = @([regex]::Matches($e, "'([A-Za-z_][\w.]*)'") | ForEach-Object { $_.Groups[1].Value })
            $known = @($names | Where-Object { $wanted.ContainsKey($_) })
            if ($known) { foreach ($k in $known) { $hit[$k] = $true } }
            else { "a non-public member is reached that this test does not know about: $e" }
        }
        Note ("non-public members needed: " + (@($hit.Keys | Sort-Object) -join ', '))
        foreach ($k in $wanted.Keys) {
            if (-not $hit.ContainsKey($k)) {
                "$k no longer needs the publiciser ($($wanted[$k])) - either the game made it public, or the mod stopped reading it; if nothing needs it, drop the publiciser and Source/AccessChecks.cs together"
            }
        }
    } finally { Remove-Item $probe -Recurse -Force -ErrorAction SilentlyContinue }
}

# =============================================================================================
Section 'The four hooks'
# =============================================================================================

It 'each patched method is still there, with one overload and the expected signature' {
    foreach ($h in $Hooks) {
        $t = $byName[$h.Type]
        if (-not $t) { "the game has no $($h.Type)"; continue }
        $ms = @($t.GetMethods($BFis) | Where-Object { $_.Name -eq $h.Method })
        if ($ms.Count -eq 0) { "$($h.Type) no longer declares $($h.Method)"; continue }
        # More than one overload is the TrySpawnYield problem: two methods relaying each other,
        # and a patch by name that fires twice or on the wrong one.
        if ($ms.Count -ne 1) { "$($h.Type).$($h.Method) now has $($ms.Count) overloads" ; continue }
        $got = @($ms[0].GetParameters() | ForEach-Object { $_.ParameterType.Name })
        if (($got -join ',') -ne ($h.Params -join ',')) {
            "$($h.Type).$($h.Method) takes ($($got -join ', ')) rather than ($($h.Params -join ', '))"
        }
    }
}

# A Harmony patch by declaring type binds to that type's method. A subclass that overrides it
# would run its own body and the patch would never see the call - silently, for that subclass
# only. Mineable has no subclasses today and Plant has four, none of which override.
It 'no subclass overrides the two virtual-looking targets out from under the patch' {
    foreach ($pair in @(@('Mineable', 'DestroyMined'), @('Plant', 'PlantCollected'))) {
        $base = $byName[$pair[0]]
        if (-not $base) { "the game has no $($pair[0])"; continue }
        $subs = @($gameTypes | Where-Object { $_ -and $_ -ne $base -and $base.IsAssignableFrom($_) })
        foreach ($s in $subs) {
            if ($s.GetMethod($pair[1], $BFd)) { "$($s.Name) overrides $($pair[1]), so the patch misses it" }
        }
    }
}

# Harmony resolves [HarmonyPatch(typeof(X), "Y")] at PatchAll time and throws when it cannot. That
# is loud, but it happens at startup in front of a player; here it is quiet and early.
It 'every HarmonyPatch attribute on the mod resolves to a real method' {
    $seen = 0
    foreach ($t in $modTypes) {
        foreach ($a in $t.GetCustomAttributesData()) {
            if ($a.AttributeType.Name -ne 'HarmonyPatch') { continue }
            $args = @($a.ConstructorArguments)
            if ($args.Count -lt 2) { continue }
            $target = $args[0].Value -as [Type]
            $name = [string]$args[1].Value
            if (-not $target) { "a HarmonyPatch on $($t.Name) names a type that no longer resolves"; continue }
            $seen++
            if (-not @($target.GetMethods($BFis) | Where-Object { $_.Name -eq $name })) {
                "$($t.Name) patches $($target.Name).$name, which does not exist"
            }
        }
    }
    if ($seen -lt 4) { "only $seen HarmonyPatch attributes found, and this mod has four patches" }
}

# =============================================================================================
Section 'The vanilla API the mod calls by name'
# =============================================================================================

It 'the follow-fieldwork toggle and the master are still where the mod reads them' {
    $ps = $byName['Pawn_PlayerSettings']
    if (-not $ps) { 'the game has no Pawn_PlayerSettings'; return }
    $f = $ps.GetField('followFieldwork', $BFi)
    if (-not $f)              { 'Pawn_PlayerSettings.followFieldwork is gone - the mod has no trigger left' }
    elseif (-not $f.IsPublic) { 'followFieldwork is no longer public' }
    elseif ($f.FieldType -ne [bool]) { "followFieldwork is a $($f.FieldType.Name) now" }
    $m = $ps.GetProperty('Master', $BFi)
    if (-not $m) { 'Pawn_PlayerSettings.Master is gone' }
    # Not a rule of this mod: vanilla itself refuses a master without obedience.
    if (-not $ps.GetProperty('RespectsMaster', $BFi)) {
        'Pawn_PlayerSettings.RespectsMaster is gone, so the obedience floor is no longer the game''s own rule'
    }
}

It 'the bond is still developed through the call vanilla uses for taming and training' {
    $ru = $byName['RelationsUtility']
    if (-not $ru) { 'the game has no RelationsUtility'; return }
    $m = @($ru.GetMethods($BFis) | Where-Object { $_.Name -eq 'TryDevelopBondRelation' })
    if ($m.Count -ne 1) { "RelationsUtility.TryDevelopBondRelation has $($m.Count) overloads"; return }
    $got = @($m[0].GetParameters() | ForEach-Object { $_.ParameterType.Name })
    if (($got -join ',') -ne 'Pawn,Pawn,Single') { "it takes ($($got -join ', ')) now" }
}

It 'the three defs the mod names by hand still exist' {
    $obedience = $byName['TrainableDefOf']
    if (-not $obedience -or -not $obedience.GetField('Obedience', $BFis)) { 'TrainableDefOf.Obedience is gone' }
    $rel = $byName['PawnRelationDefOf']
    if (-not $rel -or -not $rel.GetField('Bond', $BFis)) { 'PawnRelationDefOf.Bond is gone' }
    $job = $byName['JobDefOf']
    foreach ($n in 'Harvest', 'HarvestDesignated') {
        if (-not $job -or -not $job.GetField($n, $BFis)) { "JobDefOf.$n is gone, and it is how a harvest is told from a cut" }
    }
}

# Forage and Dig are resolved by GetNamedSilentFail rather than through a DefOf, because they come
# from Odyssey and must be allowed to be absent. That is only the right call as long as they are
# in fact absent from Core - if they ever moved into the base game, a DefOf would be safer and
# the mod's degradation path would be dead code.
It 'Forage and Dig are Odyssey defs, which is why they are looked up silently' {
    $found = @{}
    Get-ChildItem $GameData -Recurse -Filter '*.xml' -ErrorAction SilentlyContinue |
        Where-Object { $_.FullName -match '\\TrainableDefs?\\' -or $_.Name -match 'Trainable' } |
        ForEach-Object {
            $x = New-Object System.Xml.XmlDocument
            try { $x.Load($_.FullName) } catch { return }
            foreach ($n in $x.SelectNodes('//TrainableDef')) {
                if ($n.defName -in 'Forage', 'Dig') {
                    $pack = ($_.FullName.Substring($GameData.Length).TrimStart('\') -split '\\')[0]
                    $found[$n.defName] = $pack
                }
            }
        }
    foreach ($n in 'Forage', 'Dig') {
        if (-not $found.ContainsKey($n)) { "no TrainableDef named $n anywhere in the game data" ; continue }
        Note "$n comes from $($found[$n])"
        if ($found[$n] -eq 'Core') { "$n now lives in Core, so the silent lookup and the degradation path are pointless" }
    }
}

# =============================================================================================
Section 'Why the bonus is an object on the ground and not a StatPart'
# =============================================================================================

# A multiplicative bonus on mining or harvesting would have been eaten by the cap. That is the
# whole reason this mod spawns a separate stack instead, and it stops being true the day the caps
# move - in either direction.
It 'the two capped yields are still capped, and the two uncapped still are not' {
    $expected = @{ MiningYield = $true; PlantHarvestYield = $true; FishingYield = $false; AnimalGatherYield = $false }
    $seen = @{}
    Get-ChildItem $GameData -Recurse -Filter '*.xml' -ErrorAction SilentlyContinue |
        Where-Object { $_.FullName -like '*\Defs\Stats\*' } |
        ForEach-Object {
            $x = New-Object System.Xml.XmlDocument
            try { $x.Load($_.FullName) } catch { return }
            foreach ($n in $x.SelectNodes('//StatDef')) {
                if ($expected.ContainsKey([string]$n.defName)) { $seen[[string]$n.defName] = $n.maxValue }
            }
        }
    foreach ($k in $expected.Keys) {
        if (-not $seen.ContainsKey($k)) { "no StatDef named $k in the game data"; continue }
        $hasCap = [bool]$seen[$k]
        Note ("$k maxValue: " + $(if ($hasCap) { $seen[$k] } else { 'none' }))
        if ($hasCap -ne $expected[$k]) {
            if ($hasCap) { "$k has gained a cap of $($seen[$k]); a multiplicative bonus would now be swallowed there too" }
            else         { "$k has lost its cap, so the reason for spawning a separate stack is weaker than the comment claims" }
        }
    }
}

# =============================================================================================
Section 'The interface'
# =============================================================================================

It 'every key the assembly asks for exists in English, and French matches key for key' {
    $used = @([regex]::Matches((Get-ChildItem (Join-Path $ModRoot 'Source') -Recurse -Filter '*.cs' |
                ForEach-Object { Read-Text $_.FullName } | Out-String),
              '"(FieldworkCompanions\.[A-Za-z0-9.]+)"') | ForEach-Object { $_.Groups[1].Value } |
              Sort-Object -Unique)
    if ($used.Count -lt 10) { "only $($used.Count) keys found in the source, which cannot be right"; return }

    $keysOf = {
        param($p)
        $x = New-Object System.Xml.XmlDocument
        $x.Load($p)
        @($x.DocumentElement.ChildNodes | Where-Object { $_.NodeType -eq 'Element' } | ForEach-Object { $_.Name }) | Sort-Object -Unique
    }
    $en = & $keysOf (Join-Path $ModRoot 'Mod\Languages\English\Keyed\FieldworkCompanions.xml')
    $fr = & $keysOf (Join-Path $ModRoot 'Mod\Languages\French\Keyed\FieldworkCompanions.xml')
    Note ("keys used: $($used.Count); English: $($en.Count); French: $($fr.Count)")

    foreach ($k in $used) { if ($en -notcontains $k) { "$k is asked for by the code and is in no English file" } }
    foreach ($k in $en)   { if ($fr -notcontains $k) { "$k is in English and missing from French" } }
    foreach ($k in $fr)   { if ($en -notcontains $k) { "$k is in French and missing from English" } }
}

It 'all shipped XML parses and translation keys are unique and nonempty' {
    foreach ($file in Get-ChildItem (Join-Path $ModRoot 'Mod') -Recurse -Filter '*.xml') {
        $xml = New-Object System.Xml.XmlDocument
        $xml.Load($file.FullName)
        if ($file.FullName -notmatch '\\Languages\\') { continue }
        if ($xml.DocumentElement.Name -ne 'LanguageData') { "wrong translation root: $($file.Name)" }
        $seen = @{}
        foreach ($node in $xml.DocumentElement.ChildNodes) {
            if ($node.NodeType -ne 'Element') { continue }
            if ($seen.ContainsKey($node.Name)) { "duplicate key $($node.Name) in $($file.FullName)" }
            $seen[$node.Name] = $true
            if ([string]::IsNullOrWhiteSpace($node.InnerText)) { "empty key $($node.Name)" }
        }
    }
}

It 'About declares the identity, supported game, Harmony and visible source link' {
    $xml = New-Object System.Xml.XmlDocument
    $xml.Load((Join-Path $ModRoot 'Mod\About\About.xml'))
    $about = $xml.ModMetaData
    if ($about.name -ne 'Fieldwork Companions') { 'unexpected mod title' }
    if ($about.packageId -ne 'nelim.fieldworkcompanions') { 'unexpected packageId' }
    if (@($about.supportedVersions.li) -notcontains '1.6') { 'RimWorld 1.6 is not declared' }
    if (@($about.modDependencies.li.packageId) -notcontains 'brrainz.harmony') { 'Harmony dependency missing' }
    $url = 'https://github.com/vbardales/Rimworld-Fieldwork-Companions'
    if ($about.url -ne $url -or -not $about.description.Contains($url)) { 'GitHub link missing or inconsistent' }
}

# =============================================================================================
Write-Output ''
. (Join-Path $PSScriptRoot 'Settings-Tests.ps1')

if ($script:failed -eq 0) {
    Write-Output "$($script:ran) tests, all passed."
    exit 0
}
Write-Output "$($script:ran) tests, $($script:failed) failed."
exit 1
