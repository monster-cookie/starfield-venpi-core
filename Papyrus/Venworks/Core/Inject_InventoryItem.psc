ScriptName Venworks:Core:Inject_InventoryItem extends Quest

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
Actor Property PlayerRef Auto Const Mandatory
Form Property ItemToInject Auto Const Mandatory

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Events
;;;
Event OnQuestInit()
  LogSeverity severityTable = new LogSeverity;

  LogUser(modName=Venworks_ModName, moduleName="Venworks:Core:Inject_InventoryItem", functionName="OnQuestInit", logMessage="OnQuestInit triggered.", severity=severityTable.Info)
  If PlayerRef.GetItemCount(ItemToInject) <= 0
    PlayerRef.AddItem(ItemToInject, 1, false)
    LogUser(modName=Venworks_ModName, moduleName="Venworks:Core:Inject_InventoryItem", functionName="OnQuestInit", logMessage="Item added to player inventory.", severity=severityTable.Info)
  EndIf
EndEvent
