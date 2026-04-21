ScriptName Venworks:Core:Inventory Extends Venworks:Core:Base:BaseScriptObject hidden


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Imports
;;;
Import Venworks:Core:Enumerations
Import Venworks:Core:Logging


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Functions
;;;
Int Function GetItemType(Form baseObject)
  InventoryItemTypes inventoryItemTypes = new InventoryItemTypes

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
    LogUserInformational(creationName="Venworks-Core", moduleName="Venworks:Core:Inventory", functionName="GetItemType", logMessage="Unknown base object type found for base object " + baseObject + ".")
    Return inventoryItemTypes.ItemTypeUnknown
  EndIf
EndFunction
