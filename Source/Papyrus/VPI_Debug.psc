ScriptName VPI_Debug

;;
;; MAJOR NOTE: ALL FUNCTIONS MUST BE GLOBAL WITHOUT CREATION KIT
;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Functions
;;;

;; ****************************************************************************
;; Debug Message Handler
;;
Function DebugMessage(string modName, string moduleName, string functionName, string message, int level, int debugModeEnabled) Global
  If (debugModeEnabled == 0)
    return
  EndIf

  if Debug.OpenUserLog(modName)
    Debug.TraceUser(modName, "\n\n[[--------------------------------------------------------------------------------]]\n" + modName + " LOG\n[[--------------------------------------------------------------------------------]]\n\n", 0)
  endif

  If (level == 1)
    Debug.TraceUser(modName, "VPI_WARN " + moduleName + "(" + functionName + "): " + message, level)
  ElseIf (level == 2)
    Debug.TraceUser(modName, "VPI_ERROR " + moduleName + "(" + functionName + "): " + message, level)
  Else
    Debug.TraceUser(modName, "VPI_DEBUG " + moduleName + "(" + functionName + "): " + message, level)
  EndIf
EndFunction
