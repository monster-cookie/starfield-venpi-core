ScriptName Venworks:Core:Base:BaseScriptObject Extends ScriptObject
{ Shared base class that all QOG ScriptObject classes derive from it injects some shared functions, constants, etc }


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Imports
;;;
Import Venworks:Core:Enumerations
Import Venworks:Core:Logging


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Utility Functions
;;;
var Function Ternary(Bool conditional, Var result1, Var result2) global
  If (conditional)
    Return result1
  EndIf

  Return result2
EndFunction


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Logging (System) Functions
;;;
Function LogSystemInformational(String creationName, String moduleName, String functionName, String logMessage)
  LogSeverity severityTable = new LogSeverity;
  LogSystem(creationName=creationName, moduleName=moduleName, functionName=functionName, logMessage=logMessage, severity=severityTable.Info)
EndFunction

Function LogSystemWarning(String creationName, String moduleName, String functionName, String logMessage)
  LogSeverity severityTable = new LogSeverity;
  LogSystem(creationName=creationName, moduleName=moduleName, functionName=functionName, logMessage=logMessage, severity=severityTable.Warning)
EndFunction

Function LogSystemError(String creationName, String moduleName, String functionName, String logMessage)
  LogSeverity severityTable = new LogSeverity;
  LogSystem(creationName=creationName, moduleName=moduleName, functionName=functionName, logMessage=logMessage, severity=severityTable.Error)
EndFunction

Function LogSystemCritical(String creationName, String moduleName, String functionName, String logMessage)
  LogSeverity severityTable = new LogSeverity;
  LogSystem(creationName=creationName, moduleName=moduleName, functionName=functionName, logMessage=logMessage, severity=severityTable.Critical)
EndFunction


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Logging (User) Functions
;;;
Function LogUserInformational(String creationName, String moduleName, String functionName, String logMessage)
  LogSeverity severityTable = new LogSeverity;
  LogUser(creationName=creationName, moduleName=moduleName, functionName=functionName, logMessage=logMessage, severity=severityTable.Info)
EndFunction

Function LogUserWarning(String creationName, String moduleName, String functionName, String logMessage)
  LogSeverity severityTable = new LogSeverity;
  LogUser(creationName=creationName, moduleName=moduleName, functionName=functionName, logMessage=logMessage, severity=severityTable.Warning)
EndFunction

Function LogUserError(String creationName, String moduleName, String functionName, String logMessage)
  LogSeverity severityTable = new LogSeverity;
  LogUser(creationName=creationName, moduleName=moduleName, functionName=functionName, logMessage=logMessage, severity=severityTable.Error)
EndFunction

Function LogUserCritical(String creationName, String moduleName, String functionName, String logMessage)
  LogSeverity severityTable = new LogSeverity;
  LogUser(creationName=creationName, moduleName=moduleName, functionName=functionName, logMessage=logMessage, severity=severityTable.Critical)
EndFunction
