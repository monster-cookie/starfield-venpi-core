ScriptName VPI_Inject_LeveledListItem extends Quest

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Global Variables
;;;
GlobalVariable Property Venpi_DebugEnabled Auto Const Mandatory
String Property Venpi_ModName Auto Const Mandatory

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
  VPI_Debug.DebugMessage(Venpi_ModName, "VPI_InjectItem_LeveledList", "OnQuestInit", "Injecting " + ToInjectLeveledItemEntryCount + " " + ToInjectLeveledItemEntryItem + " items at level " + ToInjectLeveledItemEntryLevel + " into " + InjectIntoLeveledItemList +  ".", 0, Venpi_DebugEnabled.GetValueInt())
  InjectIntoLeveledItemList.AddForm(ToInjectLeveledItemEntryItem, ToInjectLeveledItemEntryLevel, ToInjectLeveledItemEntryCount)
EndEvent
