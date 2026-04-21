ScriptName Venworks:Core:Inject_InventoryItem extends Venworks:Core:Base:BaseQuest


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
  LogUserInformational(creationName=Venworks_ModName, moduleName="Venworks:Core:Inject_InventoryItem", functionName="OnQuestInit", logMessage="OnQuestInit triggered.")
  If PlayerRef.GetItemCount(ItemToInject) <= 0
    PlayerRef.AddItem(ItemToInject, 1, false)
    LogUserInformational(creationName=Venworks_ModName, moduleName="Venworks:Core:Inject_InventoryItem", functionName="OnQuestInit", logMessage="Item added to player inventory.")
  EndIf
EndEvent
