ScriptName Venworks:Core:Enumerations Extends ScriptObject hidden


Struct Aggression
  Int Unaggressive=0
  Int Aggressive=1
  Int VeryAggressive=2
  Int Frenzied=3
EndStruct

Struct Assists
  Int Nobody=0
  Int Allies=1
  Int FriendsAllies=2
EndStruct

Struct Classes
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

Struct Confidence
  Int Cowardly=0
  Int Cautious=1
  Int Average=2
  Int Brave=3
  Int Foolhardy=4
EndStruct

Struct DifficultyPresets
  Int Story=0
  Int Easy=1
  Int Normal=2
  Int Hard=3
  Int Nightmare=4
  Int Apocalypse=5
EndStruct

Struct Factions
  Int Random       = 0
  Int CrimsonFleet = 1
  Int Ecliptic     = 2
  Int HouseVaruun  = 3
  Int Spacers      = 4
  Int Starborn     = 5
  Int Syndicate    = 6
  Int TheFirst     = 7
EndStruct

Struct InventoryItemTypes
  Int ItemTypeUnknown=0
  Int ItemTypeArmor=1
  Int ItemTypeWeapon=2
  Int ItemTypeAmmo=3
  Int ItemTypeBook=4
  Int ItemTypeMisc=5
  Int ItemTypeInjestible=6
EndStruct

Struct LevelModifier
  Int Random   = -1
  Int Easy     = 0
  Int Medium   = 1
  Int Hard     = 2
  Int Boss     = 3
  Int Disabled = 4
EndStruct

Struct LogSeverity
  Int Verbose  = -1
  Int Info     = 0
  Int Warning  = 1
  Int Error    = 2
  Int Critical = 3
EndStruct

Struct Suspicious
  Int Neutral=0
  Int HuntingTarget=1
  Int FoundTarget=2
EndStruct
