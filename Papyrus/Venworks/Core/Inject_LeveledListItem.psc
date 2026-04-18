ScriptName Venworks:Core:Inject_LeveledListItem extends Quest

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
LeveledItem Property InjectIntoLeveledItemList Auto Const Mandatory
Form Property ToInjectLeveledItemEntryItem Auto Const Mandatory
Int Property ToInjectLeveledItemEntryLevel Auto Const Mandatory
Int Property ToInjectLeveledItemEntryCount Auto Const Mandatory

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Events
;;;
Event OnQuestInit()
  LogSeverity severityTable = new LogSeverity;
  LogUser(modName=Venworks_ModName, moduleName="Venworks:Core:Inject_LeveledListItem", functionName="OnQuestInit", logMessage="Injecting " + ToInjectLeveledItemEntryCount + " " + ToInjectLeveledItemEntryItem + " items at level " + ToInjectLeveledItemEntryLevel + " into " + InjectIntoLeveledItemList +  ".", severity=severityTable.Info)
  InjectIntoLeveledItemList.AddForm(ToInjectLeveledItemEntryItem, ToInjectLeveledItemEntryLevel, ToInjectLeveledItemEntryCount)
EndEvent
