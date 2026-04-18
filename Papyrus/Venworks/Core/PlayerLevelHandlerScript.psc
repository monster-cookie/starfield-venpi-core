ScriptName Venworks:Core:PlayerLevelHandlerScript extends Quest

Import Venworks:Core:Logging

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Global Variables
;;;
GlobalVariable Property Venworks_DebugEnabled Auto Const Mandatory
String Property Venworks_ModName="VenworksCore" Auto Const Mandatory

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Properties
;;;
ActorValue Property PlayerLevel Auto Const Mandatory

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Events
;;;
Event OnQuestInit()
  LogSeverity severityTable = new LogSeverity;
  LogUser(modName=Venworks_ModName, moduleName="Venworks:Core:PlayerLevelHandlerScript", functionName="OnQuestInit", logMessage="OnQuestInit triggered. Initializing PlayerLevel AV to player's current level.", severity=severityTable.Info)
  Game.GetPlayer().SetValue(PlayerLevel, Game.GetPlayerLevel() as Float)
  Self.Stop()
EndEvent

Event OnStoryIncreaseLevel(int aiNewLevel)
  LogSeverity severityTable = new LogSeverity;
  LogUser(modName=Venworks_ModName, moduleName="Venworks:Core:PlayerLevelHandlerScript", functionName="OnStoryIncreaseLevel", logMessage="OnStoryIncreaseLevel SM Event triggered. Updating PlayerLevel AV to player's current level.", severity=severityTable.Info)
  Game.GetPlayer().SetValue(PlayerLevel, Game.GetPlayerLevel() as Float)
  Self.Stop()
endEvent
