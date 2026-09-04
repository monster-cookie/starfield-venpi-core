ScriptName Venworks:Core:Utilities:Console
{Explicit diagnostic console output. Stateless; does not mirror logs or use the HUD event bridge.}

; Echo one trusted diagnostic line with a neutral prefix. Empty text prints a prefixed blank line.
; Embedded CR/LF is rejected, not submitted as another console command. Use ConsoleEchoBlock for multiple lines.
; The prefix is a presentation convention, not a native print command; PC output still requires verification.
Function ConsoleEcho(String text = "") Global
  If (text != "")
    Int[] chars = Utility.SplitStringChars(text)
    If (chars == None)
      Debug.ExecuteConsole("RM> CONSOLE_ECHO_REJECTED_INPUT")
      Return
    EndIf
    Int index = 0
    While (index < chars.Length)
      If (chars[index] == 10 || chars[index] == 13)
        Debug.ExecuteConsole("RM> CONSOLE_ECHO_REJECTED_MULTILINE | Use ConsoleEchoBlock with one line per entry.")
        Return
      EndIf
      index += 1
    EndWhile
  EndIf
  Debug.ExecuteConsole("RM> " + text)
EndFunction

; Echo each array entry through the same single-line policy. None/empty arrays emit nothing.
; Entries retain their order within this call, but concurrent callers may interleave; no global lock is taken.
; A rejected entry does not suppress later entries. The caller supplies any mod/operation labels.
Function ConsoleEchoBlock(String[] lines) Global
  If (lines == None)
    Return
  EndIf
  Int index = 0
  While (index < lines.Length)
    ConsoleEcho(lines[index])
    index += 1
  EndWhile
EndFunction
