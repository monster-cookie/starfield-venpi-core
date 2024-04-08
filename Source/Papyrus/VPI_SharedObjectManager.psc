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

  Return None
EndFunction

DifficultyPresets Function GetEnumDifficultyPresets() Global
  Quest quest = Game.GetFormFromFile(0x71000828, "VenpiCore.esm") as Quest
  If (quest)
    VPI_SharedObjectManager script = quest as VPI_SharedObjectManager
    If (script)
      return script.EnumDifficultyPresets
    EndIf
  EndIf

  Return None
EndFunction

Aggression Function GetEnumAggression() Global
  Quest quest = Game.GetFormFromFile(0x71000828, "VenpiCore.esm") as Quest
  If (quest)
    VPI_SharedObjectManager script = quest as VPI_SharedObjectManager
    If (script)
      return script.EnumAggression
    EndIf
  EndIf

  Return None
EndFunction

Confidence Function GetEnumConfidence() Global
  Quest quest = Game.GetFormFromFile(0x71000828, "VenpiCore.esm") as Quest
  If (quest)
    VPI_SharedObjectManager script = quest as VPI_SharedObjectManager
    If (script)
      return script.EnumConfidence
    EndIf
  EndIf

  Return None
EndFunction

Assists Function GetEnumAssists() Global
  Quest quest = Game.GetFormFromFile(0x71000828, "VenpiCore.esm") as Quest
  If (quest)
    VPI_SharedObjectManager script = quest as VPI_SharedObjectManager
    If (script)
      return script.EnumAssists
    EndIf
  EndIf

  Return None
EndFunction

Suspicious Function GetEnumSuspicious() Global
  Quest quest = Game.GetFormFromFile(0x71000828, "VenpiCore.esm") as Quest
  If (quest)
    VPI_SharedObjectManager script = quest as VPI_SharedObjectManager
    If (script)
      return script.EnumSuspicious
    EndIf
  EndIf

  Return None
EndFunction

FactionClasses Function GetEnumFactionClasses() Global
  Quest quest = Game.GetFormFromFile(0x71000828, "VenpiCore.esm") as Quest
  If (quest)
    VPI_SharedObjectManager script = quest as VPI_SharedObjectManager
    If (script)
      return script.EnumFactionClasses
    EndIf
  EndIf

  Return None
EndFunction