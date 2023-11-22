ScriptName VPI_ScalingUtilities

;;
;; MAJOR NOTE: ALL FUNCTIONS MUST BE GLOBAL WITHOUT CREATION KIT
;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Functions
;;;

;; ****************************************************************************
;; Get the bracket that applies to the player's current level
;;
Int Function GetBracketForPlayerLevel(int playerLevel) Global
  If (1 <= playerLevel && playerLevel <= 25)
    return 1
  ElseIf (26 <= playerLevel && playerLevel <= 50)
    return 2
  ElseIf (51 <= playerLevel && playerLevel <= 75)
    return 3
  ElseIf (76 <= playerLevel && playerLevel <= 100)
    return 4
  ElseIf (101 <= playerLevel && playerLevel <= 125)
    return 5
  ElseIf (126 <= playerLevel && playerLevel <= 150)
    return 6
  ElseIf (151 <= playerLevel && playerLevel <= 200)
    return 7
  ElseIf (201 <= playerLevel && playerLevel <= 250)
    return 8
  ElseIf (251 <= playerLevel && playerLevel <= 300)
    return 9
  Else
    return 10
  EndIf
EndFunction

;; ****************************************************************************
;; Get, scale, and update a float based game setting 
;;
Function ScaleFormSettingFloat(String formID, Float defaultValue, Float scaleFactor) Global
  Float scaledValue = defaultValue * scaleFactor
  VPI_GameUtilities.SetFormSettingFloat(formID, scaledValue)
EndFunction

;; ****************************************************************************
;; Get, scale, and update a float based game setting 
;;
Function ScaleFormSettingInt(String formID, Int defaultValue, Int scaleFactor) Global
  Int scaledValue = defaultValue * scaleFactor
  VPI_GameUtilities.SetFormSettingInt(formID, scaledValue)
EndFunction

;; ****************************************************************************
;; Get, scale, and update a float based game setting 
;;
Function ScaleGameSettingFloat(String gameSetting, Float defaultValue, Float scaleFactor) Global
  Float scaledValue = defaultValue * scaleFactor
  VPI_GameUtilities.SetGameSettingFloat(gameSetting, scaledValue)
EndFunction

;; ****************************************************************************
;; Get, scale, and update a float based game setting 
;;
Function ScaleGameSettingInt(String gameSetting, Int defaultValue, Float scaleFactor) Global
  Int scaledValue = (defaultValue * scaleFactor) as Int
  VPI_GameUtilities.SetGameSettingInt(gameSetting, scaledValue)
EndFunction
