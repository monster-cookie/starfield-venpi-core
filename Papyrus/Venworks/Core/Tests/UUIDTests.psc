ScriptName Venworks:Core:Tests:UUIDTests
{Explicit PC runtime vectors. Not invoked by registration; no UI transport or persistent state.}

; Runs bounded validation vectors. Returns the failure count and writes one Papyrus summary plus any failed assertions.
; Invoke with CGF "Venworks:Core:Tests:UUIDTests.Run". Zero failures is runtime evidence only for this executed build.
Int Function Run() Global
  String lower = "a8098c1a-f86e-4b1e-9d7c-5a102bf38460"
  String upper = "A8098C1A-F86E-4B1E-9D7C-5A102BF38460"
  String mixed = "{A8098c1A-f86E-4b1e-9D7c-5A102bF38460}"
  String compact = "a8098c1af86e4b1e9d7c5a102bf38460"
  Int failures = 0
  failures += Check(Venworks:Core:Utilities:UUID.IsValid(lower), "D valid")
  failures += Check(Venworks:Core:Utilities:UUID.AreEqual(lower, upper), "upper equality")
  failures += Check(Venworks:Core:Utilities:UUID.AreEqual(lower, mixed), "B mixed equality")
  failures += Check(Venworks:Core:Utilities:UUID.AreEqual(lower, compact), "N equality")
  failures += Check(Venworks:Core:Utilities:UUID.AreEqual(lower, Venworks:Core:Utilities:UUID.Normalize(mixed)), "normalize round trip")
  failures += Check(!Venworks:Core:Utilities:UUID.AreEqual(lower, "b8098c1a-f86e-4b1e-9d7c-5a102bf38460"), "distinct values")
  failures += Check(!Venworks:Core:Utilities:UUID.AreEqual("", ""), "invalid never equal")
  failures += Check(Venworks:Core:Utilities:UUID.IsNil("00000000-0000-0000-0000-000000000000"), "nil")
  failures += Check(!Venworks:Core:Utilities:UUID.IsNil(""), "invalid not nil")
  failures += Check(!Venworks:Core:Utilities:UUID.IsValid("a8098c1a-f86e-4b1e-9d7c-5a102bf3846g"), "nonhex")
  failures += Check(!Venworks:Core:Utilities:UUID.IsValid("a8098c1a_f86e-4b1e-9d7c-5a102bf38460"), "separator")
  failures += Check(!Venworks:Core:Utilities:UUID.IsValid(" " + lower), "leading whitespace")
  failures += Check(!Venworks:Core:Utilities:UUID.IsValid(lower + " "), "trailing whitespace")
  failures += Check(!Venworks:Core:Utilities:UUID.IsValid("{" + compact + "}"), "unsupported brace N")
  failures += Check(!Venworks:Core:Utilities:UUID.IsValid("[" + lower + "]"), "wrong wrapper")
  failures += Check(Venworks:Core:Utilities:UUID.Normalize("invalid") == "", "invalid normalize empty")
  failures += Check(Venworks:Core:Utilities:UUID.Format(None) == "", "None nibbles")
  Debug.Trace("VWCORE_UUID_TESTS | validation failures=" + failures)
  Return failures
EndFunction

; Explicitly generates 32 values, checks format/version/variant and duplicates within this sample, and returns failures.
; Invoke with CGF "Venworks:Core:Tests:UUIDTests.RunGeneration". This is not an entropy or global uniqueness proof.
Int Function RunGeneration() Global
  String[] generated = new String[32]
  Int failures = 0
  Int index = 0
  While (index < 32)
    generated[index] = Venworks:Core:Utilities:UUID.GenerateV4()
    Int[] parsed = Venworks:Core:Utilities:UUID.Parse(generated[index])
    If (parsed == None)
      failures += Check(False, "generated parse")
    Else
      failures += Check(parsed[12] == 4, "version 4")
      failures += Check(parsed[16] >= 8 && parsed[16] <= 11, "RFC variant")
      failures += Check(!Venworks:Core:Utilities:UUID.IsNil(generated[index]), "generated non-nil")
    EndIf
    Int previous = 0
    While (previous < index)
      failures += Check(!Venworks:Core:Utilities:UUID.AreEqual(generated[previous], generated[index]), "sample duplicate")
      previous += 1
    EndWhile
    index += 1
  EndWhile
  Debug.Trace("VWCORE_UUID_TESTS | generation failures=" + failures + " | sample=32 | not an entropy proof")
  Return failures
EndFunction

; Adds one failure for a false condition and records the bounded test label in Papyrus.log.
Int Function Check(Bool condition, String label) Global
  If (!condition)
    Debug.Trace("VWCORE_UUID_TEST_FAIL | " + label, 2)
    Return 1
  EndIf
  Return 0
EndFunction
