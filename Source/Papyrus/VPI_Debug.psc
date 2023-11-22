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
Function DebugMessage(string moduleName, string functionName, string message, int level, int debugModeEnabled) Global
  If (debugModeEnabled == 0)
    return
  EndIf

  If (level == 1)
    Debug.Trace("VPI_WARN " + moduleName + "(" + functionName + "): " + message, level)
  ElseIf (level == 2)
    Debug.Trace("VPI_ERROR " + moduleName + "(" + functionName + "): " + message, level)
  Else
    Debug.Trace("VPI_DEBUG " + moduleName + "(" + functionName + "): " + message, level)
  EndIf
EndFunction
