ScriptName VPI_Inventory

;;
;; MAJOR NOTE: ALL FUNCTIONS MUST BE GLOBAL WITHOUT CREATION KIT
;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Functions
;;;
Int Function GetItemType(Form baseObject) Global
  VPI_SharedObjectManager:InventoryItemTypes enum = VPI_SharedObjectManager.GetEnumInventoryItemType()
  If (enum == none || !enum)
    Debug.MessageBox("Failed to find the InventoryItemTypes enum.")
    return 0
  EndIf

  If (baseObject is Weapon)
    Return enum.Weapon
  ElseIf baseObject is Armor
    Return enum.Armor
  ElseIf baseObject is Ammo
    Return enum.Ammo
  ElseIf baseObject is Book
    Return enum.Book
  ElseIf baseObject is MiscObject
    Return enum.Misc
  ElseIf baseObject is Potion
    Return enum.Injestible
  Else
    Return enum.Unknown
  EndIf
EndFunction
