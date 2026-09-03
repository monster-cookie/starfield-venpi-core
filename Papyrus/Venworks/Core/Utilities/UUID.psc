ScriptName Venworks:Core:Utilities:UUID
{Stateless UUID value utilities. No registration, persistence, UI transport, or automatic generation.}

; Parses D (36), B (38), or N (32) text into 32 hexadecimal nibbles. Returns None on any invalid character/shape.
; Hex case is ignored numerically. Whitespace, URNs, partial values, and brace-wrapped N are deliberately rejected.
Int[] Function Parse(String value) Global
  Int[] chars = Utility.SplitStringChars(value)
  If (chars == None)
    Return None
  EndIf
  Int offset = 0
  Bool dashed = True
  If (chars.Length == 38)
    If (chars[0] != 123 || chars[37] != 125)
      Return None
    EndIf
    offset = 1
  ElseIf (chars.Length == 32)
    dashed = False
  ElseIf (chars.Length != 36)
    Return None
  EndIf
  Int[] result = new Int[32]
  Int index = 0
  Int sourceIndex = offset
  While (index < 32)
    If (dashed && (index == 8 || index == 12 || index == 16 || index == 20))
      If (chars[sourceIndex] != 45)
        Return None
      EndIf
      sourceIndex += 1
    EndIf
    Int nibble = DecodeHex(chars[sourceIndex])
    If (nibble < 0)
      Return None
    EndIf
    result[index] = nibble
    index += 1
    sourceIndex += 1
  EndWhile
  Return result
EndFunction

; Returns true for a structurally valid UUID, including nil and versions other than v4. Has no side effects.
Bool Function IsValid(String value) Global
  Return Parse(value) != None
EndFunction

; Returns true only for a valid all-zero UUID. Invalid input is not nil.
Bool Function IsNil(String value) Global
  Int[] nibbles = Parse(value)
  If (nibbles == None)
    Return False
  EndIf
  Int index = 0
  While (index < 32)
    If (nibbles[index] != 0)
      Return False
    EndIf
    index += 1
  EndWhile
  Return True
EndFunction

; Compares parsed UUID values across case and accepted shapes. Invalid inputs never compare equal, even to themselves.
Bool Function AreEqual(String left, String right) Global
  Int[] first = Parse(left)
  Int[] second = Parse(right)
  If (first == None || second == None)
    Return False
  EndIf
  Int index = 0
  While (index < 32)
    If (first[index] != second[index])
      Return False
    EndIf
    index += 1
  EndWhile
  Return True
EndFunction

; Returns dashed D-format text or empty for invalid input. Requests lowercase hex; callers must still compare by value.
; Papyrus string storage may retain existing letter casing, so byte-for-byte lowercase is not an identity invariant.
String Function Normalize(String value) Global
  Return Format(Parse(value))
EndFunction

; Formats exactly 32 nibbles (0..15) as a dashed UUID. None, wrong length, or invalid values return empty.
String Function Format(Int[] nibbles) Global
  If (nibbles == None)
    Return ""
  EndIf
  If (nibbles.Length != 32)
    Return ""
  EndIf
  String result = ""
  Int index = 0
  While (index < 32)
    If (nibbles[index] < 0 || nibbles[index] > 15)
      Return ""
    EndIf
    If (index == 8 || index == 12 || index == 16 || index == 20)
      result += "-"
    EndIf
    result += EncodeHex(nibbles[index])
    index += 1
  EndWhile
  Return result
EndFunction

; Explicitly creates one UUIDv4-shaped value with vanilla game RNG. Not cryptographic and not a uniqueness guarantee.
; Generate once and persist explicitly; never use as an implicit replacement for a missing published consumer identity.
String Function GenerateV4() Global
  Int[] nibbles = new Int[32]
  Int index = 0
  While (index < 32)
    nibbles[index] = Utility.RandomInt(0, 15)
    index += 1
  EndWhile
  nibbles[12] = 4
  nibbles[16] = Utility.RandomInt(8, 11)
  Return Format(nibbles)
EndFunction

; Converts one ASCII hex character to 0..15, accepting either letter case; returns -1 otherwise.
Int Function DecodeHex(Int character) Global
  If (character >= 48 && character <= 57)
    Return character - 48
  ElseIf (character >= 65 && character <= 70)
    Return character - 55
  ElseIf (character >= 97 && character <= 102)
    Return character - 87
  EndIf
  Return -1
EndFunction

; Converts a nibble to requested lowercase hexadecimal text, or empty for an out-of-range value.
String Function EncodeHex(Int nibble) Global
  If (nibble >= 0 && nibble <= 9)
    Return nibble as String
  ElseIf (nibble == 10)
    Return "a"
  ElseIf (nibble == 11)
    Return "b"
  ElseIf (nibble == 12)
    Return "c"
  ElseIf (nibble == 13)
    Return "d"
  ElseIf (nibble == 14)
    Return "e"
  ElseIf (nibble == 15)
    Return "f"
  EndIf
  Return ""
EndFunction
