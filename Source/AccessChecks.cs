// Krafs.Publicizer publicises the reference assembly, which is what lets the milking patch read
// __instance.ResourceDef and __instance.ResourceAmount at all. In the real Assembly-CSharp both
// are protected abstract: the compiler emits a plain cross-assembly callvirt either way, and the
// CLR allows that instruction only when this assembly declares the waiver below.
//
// Publicizer defines the attribute type for us and normally applies it through the SDK's
// generated AssemblyInfo — which this project switches off with GenerateAssemblyInfo=false. The
// type was therefore embedded and the waiver was not. Nothing said so: the build stayed clean and
// the four patches applied, while milking and shearing would have thrown MethodAccessException on
// the first pail, a quarter of the mod dead behind a clean startup.
//
// Found without launching the game, by reading this assembly's own attribute list: the type name
// is present in the file whether or not the waiver was applied, so grepping the bytes proves
// nothing. Read GetCustomAttributesData(), not the strings.

[assembly: System.Runtime.CompilerServices.IgnoresAccessChecksTo("Assembly-CSharp")]
