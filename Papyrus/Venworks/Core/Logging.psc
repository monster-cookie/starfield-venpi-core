ScriptName Venworks:Core:Logging Extends ScriptObject hidden


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Imports
;;;
Import Venworks:Core:Enumerations


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Functions
;;;

;; ****************************************************************************
;; Debug Message Handler
;;
Function LogSystem(string creationName, string moduleName, string functionName, string logMessage, int severity) Global DebugOnly
  LogSeverity severityTable = new LogSeverity;

  If (severity == severityTable.Critical)
    Debug.Trace(asTextToPrint=creationName + ">> [CRITICAL] <" + moduleName + "> (" + functionName + "): " + logMessage, aiSeverity=severity)
  ElseIf (severity == severityTable.Error)
    Debug.Trace(asTextToPrint=creationName + ">>    [ERROR] <" + moduleName + "> (" + functionName + "): " + logMessage, aiSeverity=severity)
  ElseIf (severity == severityTable.Warning)
    Debug.Trace(asTextToPrint=creationName + ">>  [WARNING] <" + moduleName + "> (" + functionName + "): " + logMessage, aiSeverity=severity)
  ElseIf (severity == severityTable.Info)
    Debug.Trace(asTextToPrint=creationName + ">>     [info] <" + moduleName + "> (" + functionName + "): " + logMessage, aiSeverity=severity)
  Else
    Debug.Trace(asTextToPrint=creationName + ">>    [debug] <" + moduleName + "> (" + functionName + "): " + logMessage, aiSeverity=severity)
  EndIf
EndFunction

Function LogUser(string creationName, string moduleName, string functionName, string logMessage, int severity) Global DebugOnly
  LogSeverity severityTable = new LogSeverity;

  if Debug.OpenUserLog(asLogName=creationName)
    Debug.TraceUser(asUserLog=creationName, asTextToPrint="\n\n[[--------------------------------------------------------------------------------]]\n" + creationName + " LOG\n[[--------------------------------------------------------------------------------]]\n\n", aiSeverity=severityTable.Info)
  endif

  If (severity == severityTable.Critical)
    Debug.TraceUser(asUserLog=creationName, asTextToPrint="[CRITICAL] <" + moduleName + "> (" + functionName + "): " + logMessage, aiSeverity=severity)
  ElseIf (severity == severityTable.Error)
    Debug.TraceUser(asUserLog=creationName, asTextToPrint="   [ERROR] <" + moduleName + "> (" + functionName + "): " + logMessage, aiSeverity=severity)
  ElseIf (severity == severityTable.Warning)
    Debug.TraceUser(asUserLog=creationName, asTextToPrint=" [WARNING] <" + moduleName + "> (" + functionName + "): " + logMessage, aiSeverity=severity)
  ElseIf (severity == severityTable.Info)
    Debug.TraceUser(asUserLog=creationName, asTextToPrint="    [info] <" + moduleName + "> (" + functionName + "): " + logMessage, aiSeverity=severity)
  Else
    Debug.TraceUser(asUserLog=creationName, asTextToPrint="   [debug] <" + moduleName + "> (" + functionName + "): " + logMessage, aiSeverity=severity)
  EndIf
EndFunction
