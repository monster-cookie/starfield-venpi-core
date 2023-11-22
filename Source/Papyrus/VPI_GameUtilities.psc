ScriptName VPI_GameUtilities

;;
;; MAJOR NOTE: ALL FUNCTIONS MUST BE GLOBAL WITHOUT CREATION KIT
;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Functions
;;;

;; ****************************************************************************
;; Convert the difficulty int value to the string value
;;
String Function GetDifficulty(int iDifficulty) Global
  if (iDifficulty == 0)
    return "Very Easy"
  ElseIf (iDifficulty == 1)
    return "Easy"
  ElseIf (iDifficulty == 2)
    return "Normal"
  ElseIf (iDifficulty == 3)
    return "Hard"
  ElseIf (iDifficulty == 4)
    return "Very Hard"
  Else
    return "Unknown(" + iDifficulty +")"
  EndIf
EndFunction

;; ****************************************************************************
;; Set a float based form setting 
;;
Function SetFormSettingFloat(String formID, Float value) Global
  Debug.ExecuteConsole("set " + formID + " to " + value)
EndFunction

;; ****************************************************************************
;; Set a integer based form setting 
;;
Function SetFormSettingInt(String formID, Int value) Global
  Debug.ExecuteConsole("set " + formID + " to " + value)
EndFunction

;; ****************************************************************************
;; Set a float based game setting 
;;
Function SetGameSettingFloat(String gameSetting, Float value) Global
  Debug.ExecuteConsole("setgs " + gameSetting + " " + value)
EndFunction

;; ****************************************************************************
;; Set a integer based game setting 
;;
Function SetGameSettingInt(String gameSetting, Int value) Global
  Debug.ExecuteConsole("setgs " + gameSetting + " " + value)
EndFunction
