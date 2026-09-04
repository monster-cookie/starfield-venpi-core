ScriptName Venworks:Core:Tests:ConsoleOutputTests
{Explicit visual probes only. Run via CGF; completion is not proof the console displayed the expected text.}

; Displays a fixed sequence with harmless sentinels. Does not register, persist, schedule, or change game state.
; The reader must compare console output with Documentation/ConsoleOutput.md; there is no automatic visual pass.
Function Run() Global
  Venworks:Core:Utilities:Console.ConsoleEcho("VWCORE: CONSOLE_TEST_BEGIN")
  Venworks:Core:Utilities:Console.ConsoleEcho("VWCORE: SINGLE_LINE")
  String[] lines = new String[0]
  lines.Add("VWCORE: BLOCK_FIRST")
  lines.Add("")
  lines.Add("VWCORE: BLOCK_LAST")
  Venworks:Core:Utilities:Console.ConsoleEchoBlock(lines)
  String[] missing = None
  Venworks:Core:Utilities:Console.ConsoleEchoBlock(missing)
  String[] empty = new String[0]
  Venworks:Core:Utilities:Console.ConsoleEchoBlock(empty)
  Venworks:Core:Utilities:Console.ConsoleEcho("VWCORE: NONE_EMPTY_CHECK_END")
  Venworks:Core:Utilities:Console.ConsoleEcho("VWCORE: REJECT_LF\nVWCORE_HARMLESS_SENTINEL")
  ; The Bethesda compiler rejects \r literals. CR/CRLF rejection is source-checked, not exercised by this probe.
  String[] mixed = new String[0]
  mixed.Add("VWCORE: REJECT_BLOCK_ENTRY\nVWCORE_HARMLESS_SENTINEL")
  mixed.Add("VWCORE: BLOCK_CONTINUES")
  Venworks:Core:Utilities:Console.ConsoleEchoBlock(mixed)
  Venworks:Core:Utilities:Console.ConsoleEcho()
  Venworks:Core:Utilities:Console.ConsoleEcho("VWCORE: CONSOLE_TEST_END | Verify visible lines; this is not a runtime PASS.")
EndFunction
