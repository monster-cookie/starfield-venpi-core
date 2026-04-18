ScriptName Venworks:Core:DataEnums Extends ScriptObject hidden

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Enums/Structs
;;;
Struct InventoryItemTypes
  Int ItemTypeUnknown=0
  Int ItemTypeArmor=1
  Int ItemTypeWeapon=2
  Int ItemTypeAmmo=3
  Int ItemTypeBook=4
  Int ItemTypeMisc=5
  Int ItemTypeInjestible=6
EndStruct

Struct DifficultyPresets
  Int Story=0
  Int Easy=1
  Int Normal=2
  Int Hard=3
  Int Nightmare=4
  Int Apocalypse=5
EndStruct

Struct Aggression
  Int Unaggressive=0
  Int Aggressive=1
  Int VeryAggressive=2
  Int Frenzied=3
EndStruct

Struct Confidence
  Int Cowardly=0
  Int Cautious=1
  Int Average=2
  Int Brave=3
  Int Foolhardy=4
EndStruct

Struct Assists
  Int Nobody=0
  Int Allies=1
  Int FriendsAllies=2
EndStruct

Struct Suspicious
  Int Neutral=0
  Int HuntingTarget=1
  Int FoundTarget=2
EndStruct

Struct FactionClasses
  Int Generic=0
  Int Assault=1
  Int Boss=2
  Int Charger=3
  Int Heavy=4
  Int Officer=5
  Int Recruit=6
  Int Sniper=7
  Int Support=8
EndStruct

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Properties
;;;
InventoryItemTypes Property EnumInventoryItemType Auto
DifficultyPresets Property EnumDifficultyPresets Auto
Aggression Property EnumAggression Auto
Confidence Property EnumConfidence Auto
Assists Property EnumAssists Auto
Suspicious Property EnumSuspicious Auto
FactionClasses Property EnumFactionClasses Auto

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Events
;;;
Event OnInit()
  EnumInventoryItemType = new InventoryItemTypes
  EnumDifficultyPresets = new DifficultyPresets
  EnumAggression = new Aggression
  EnumConfidence = new Confidence
  EnumAssists = new Assists
  EnumSuspicious = new Suspicious
  EnumFactionClasses = new FactionClasses
EndEvent
