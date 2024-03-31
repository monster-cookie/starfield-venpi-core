ScriptName VPI_PlayerLevelHandlerScript extends Quest

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Global Variables
;;;
GlobalVariable Property Venpi_DebugEnabled Auto Const Mandatory
String Property Venpi_ModName="VenpiCore" Auto Const Mandatory

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
  VPI_Debug.DebugMessage(Venpi_ModName, "VPI_PlayerLevelHandlerScript", "OnQuestInit", "OnQuestInit triggered. Initializing PlayerLevel AV to player's current level.", 0, Venpi_DebugEnabled.GetValueInt())
  Game.GetPlayer().SetValue(PlayerLevel, Game.GetPlayerLevel() as Float)
  Self.Stop()
EndEvent

Event OnStoryIncreaseLevel(int aiNewLevel)
  VPI_Debug.DebugMessage(Venpi_ModName, "VPI_PlayerLevelHandlerScript", "OnStoryIncreaseLevel", "OnStoryIncreaseLevel SM Event triggered. Updating PlayerLevel AV to player's current level.", 0, Venpi_DebugEnabled.GetValueInt())
  Game.GetPlayer().SetValue(PlayerLevel, Game.GetPlayerLevel() as Float)
  Self.Stop()
endEvent
