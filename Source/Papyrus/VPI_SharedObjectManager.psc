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

InventoryItemTypes Property EnumInventoryItemType Auto

Event OnInit()
  EnumInventoryItemType = new InventoryItemTypes
EndEvent

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