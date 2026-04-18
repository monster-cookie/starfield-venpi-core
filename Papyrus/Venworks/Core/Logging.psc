ScriptName Venworks:Core:Logging Extends ScriptObject hidden

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Constants
;;;

Int Property CONST_LogSeverity_Verbose=-1 Auto Const Mandatory
Int Property CONST_LogSeverity_Info=0 Auto Const Mandatory
Int Property CONST_LogSeverity_Warning=1 Auto Const Mandatory
Int Property CONST_LogSeverity_Error=2 Auto Const Mandatory
Int Property CONST_LogSeverity_Critical=3 Auto Const Mandatory


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Enums
;;;

Struct LogSeverity
  Int Verbose  = -1
  Int Info     = 0
  Int Warning  = 1
  Int Error    = 2
  Int Critical = 3
EndStruct


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Properties
;;;

LogSeverity Property LogSeverityEnum Auto


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Events
;;;

Event OnInit()
  LogSeverityEnum = new LogSeverity
EndEvent


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Functions
;;;

;; ****************************************************************************
;; Debug Message Handler
;;
Function LogSystem(string modName, string moduleName, string functionName, string logMessage, int severity) Global DebugOnly
  LogSeverity severityTable = new LogSeverity;

  If (severity == severityTable.Critical)
    Debug.Trace(modName + ">> [CRITICAL] <" + moduleName + "> (" + functionName + "): " + logMessage, severity)
  ElseIf (severity == severityTable.Error)
    Debug.Trace(modName + ">>    [ERROR] <" + moduleName + "> (" + functionName + "): " + logMessage, severity)
  ElseIf (severity == severityTable.Warning)
    Debug.Trace(modName + ">>  [WARNING] <" + moduleName + "> (" + functionName + "): " + logMessage, severity)
  ElseIf (severity == severityTable.Info)
    Debug.Trace(modName + ">>     [info] <" + moduleName + "> (" + functionName + "): " + logMessage, severity)
  Else
    Debug.Trace(modName + ">>    [debug] <" + moduleName + "> (" + functionName + "): " + logMessage, severity)
  EndIf
EndFunction

Function LogUser(string modName, string moduleName, string functionName, string logMessage, int severity) Global DebugOnly
  LogSeverity severityTable = new LogSeverity;

  if Debug.OpenUserLog(modName)
    Debug.TraceUser(modName, "\n\n[[--------------------------------------------------------------------------------]]\n" + modName + " LOG\n[[--------------------------------------------------------------------------------]]\n\n", 0)
  endif

  If (severity == severityTable.Critical)
    Debug.TraceUser(modName, "[CRITICAL] <" + moduleName + "> (" + functionName + "): " + logMessage, severity)
  ElseIf (severity == severityTable.Error)
    Debug.TraceUser(modName, "   [ERROR] <" + moduleName + "> (" + functionName + "): " + logMessage, severity)
  ElseIf (severity == severityTable.Warning)
    Debug.TraceUser(modName, " [WARNING] <" + moduleName + "> (" + functionName + "): " + logMessage, severity)
  ElseIf (severity == severityTable.Info)
    Debug.TraceUser(modName, "    [info] <" + moduleName + "> (" + functionName + "): " + logMessage, severity)
  Else
    Debug.TraceUser(modName, "   [debug] <" + moduleName + "> (" + functionName + "): " + logMessage, severity)
  EndIf
EndFunction
