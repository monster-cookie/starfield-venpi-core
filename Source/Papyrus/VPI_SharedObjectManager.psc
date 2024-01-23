ScriptName VPI_SharedObjectManager extends Quest

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Enums/Structs
;;;
Struct InventoryItemTypes
  Int Unknown=0
  Int Armor=1
  Int Weapon=2
  Int Ammo=3
  Int Book=4
  Int Misc=5
  Int Injestible=6
EndStruct

Struct DifficultyPresets
  Int Story=0
  Int Easy=1
  Int Normal=2
  Int Hard=3
  Int Nightmare=4
  Int Apocalypse=5
EndStruct

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Properties
;;;
InventoryItemTypes Property EnumInventoryItemType Auto
DifficultyPresets Property EnumDifficultyPresets Auto

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Events
;;;
Event OnInit()
  EnumInventoryItemType = new InventoryItemTypes
  EnumDifficultyPresets = new DifficultyPresets
EndEvent

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Functions
;;;
InventoryItemTypes Function GetEnumInventoryItemType() Global
  Quest quest = Game.GetFormFromFile(0x71000828, "VenpiCore.esm") as Quest
  If (quest)
    VPI_SharedObjectManager script = quest as VPI_SharedObjectManager
    If (script)
      return script.EnumInventoryItemType
    EndIf
  EndIf

  Return  none ; return none
EndFunction

DifficultyPresets Function GetEnumDifficultyPresets() Global
  Quest quest = Game.GetFormFromFile(0x71000828, "VenpiCore.esm") as Quest
  If (quest)
    VPI_SharedObjectManager script = quest as VPI_SharedObjectManager
    If (script)
      return script.EnumDifficultyPresets
    EndIf
  EndIf

  Return  none ; return none
EndFunction