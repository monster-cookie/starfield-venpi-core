ScriptName Venworks:Core:Inventory Extends ScriptObject hidden

Import Venworks:Core:DataEnums
Import Venworks:Core:Logging

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Functions
;;;
Int Function GetItemType(Form baseObject)
  InventoryItemTypes inventoryItemTypes = new InventoryItemTypes
  LogSeverity severityTable = new LogSeverity

  If (baseObject is Weapon)
    Return inventoryItemTypes.ItemTypeWeapon
  ElseIf baseObject is Armor
    Return inventoryItemTypes.ItemTypeArmor
  ElseIf baseObject is Ammo
    Return inventoryItemTypes.ItemTypeAmmo
  ElseIf baseObject is Book
    Return inventoryItemTypes.ItemTypeBook
  ElseIf baseObject is MiscObject
    Return inventoryItemTypes.ItemTypeMisc
  ElseIf baseObject is Potion
    Return inventoryItemTypes.ItemTypeInjestible
  Else
    LogUser(modName="Venworks-Core", moduleName="Venworks:Core:Inventory", functionName="GetItemType", logMessage="Unknown base object type found for base object " + baseObject + ".", severity=severityTable.Warning)
    Return inventoryItemTypes.ItemTypeUnknown
  EndIf
EndFunction
