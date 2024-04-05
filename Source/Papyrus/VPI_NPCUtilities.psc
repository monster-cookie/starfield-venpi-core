ScriptName VPI_NPCUtilities

;;
;; MAJOR NOTE: ALL FUNCTIONS MUST BE GLOBAL WITHOUT CREATION KIT
;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Functions
;;;
Int Function GetType(ObjectReference npc, Keyword NPC_Type_MK5, Keyword NPC_Type_MK4, Keyword NPC_Type_MK3, Keyword NPC_Type_MK2, Keyword NPC_Type_MK1) Global
  If (npc.HasKeyword(NPC_Type_MK5))
    return 5
  ElseIf (npc.HasKeyword(NPC_Type_MK4))
    return 4
  ElseIf (npc.HasKeyword(NPC_Type_MK3))
    return 3
  ElseIf (npc.HasKeyword(NPC_Type_MK2))
    return 2
  ElseIf (npc.HasKeyword(NPC_Type_MK1))
    return 1
  Else
    return 0
  EndIf
EndFunction

String Function GetRace(ObjectReference npc, Keyword NPC_Varuun, Keyword NPC_CrimsonFleet, Keyword NPC_Ecliptic, Keyword NPC_Spacer) Global
  If (npc.HasKeyword(NPC_Varuun))
    return "Va'ruun"
  ElseIf (npc.HasKeyword(NPC_CrimsonFleet))
    return "Crimson Fleet or Pirate"
  ElseIf (npc.HasKeyword(NPC_Ecliptic))
    return "Ecliptic PMC"
  ElseIf (npc.HasKeyword(NPC_Spacer))
    return "Spacer"
  Else
    return "Unknown - " + npc
  EndIf
EndFunction

Function DumpNPCInfo(ObjectReference npcRef) Global
  Actor realNPC = npcRef.GetSelfAsActor()

  String message = "NPC Configuration data:\n"
  ; message += "NPC Form ID:" + realNPC.GetFormID() + "\n" ;; Need the extender part of SFSE
  ; message += "NPC Editor ID:" + realNPC.GetFormEditorID() + "\n" ;; Need the extender part of SFSE
  message += "NPC Level: " + realNPC.GetLevel() + "\n"
  message += "Faction Type: " + GetFactionType(npcRef) + "\n"
  ; message += "Crime Faction: " + realNPC.GetCrimeFaction() + "\n" ;; Need a way to represent as a string or Form ID
  ; message += "Group Faction: " + realNPC.GetGroupFaction() + "\n" ;; Need a way to represent as a string or Form ID
  message += "Combat Role: " + GetCombatRole(npcRef) + "\n"
  ; message += "Combat Style: " + GetCombatStyle(npcRef) + "\n"
  message += "\n\n"
  message += "NPC Stats:\n"
  message += "Scaling Level Selector: " + GetAVScalingTier(npcRef) + "\n"
  message += "Encounter Level: " + GetEncounterLevel(npcRef) + "\n"
  message += "Health: " + GetAVHealth(npcRef) + "\n"
  message += "Power: " + GetAVStarPower(npcRef) + "\n"
  message += "Speed: " + GetAVSpeed(npcRef) + "\n"
  message += "VEOH Bounty: " + GetBountyType(npcRef) + "\n"
  message += "\n\n"
  message += "NPC Resistances:\n"
  message += "Damage Resists (Phy|Eng|EM): " + GetAVDamageResist(npcRef) + " | " + GetAVEnergyResist(npcRef) + " | " + GetAVElectromagneticDamageResist(npcRef) + "\n"
  message += "Env Resists (Air|Corro|Rad|Therm): " + GetAVEnvAirborneResist(npcRef) + " | " + GetAVEnvCorrosiveResist(npcRef) + " | " + GetAVEnvRadiationResist(npcRef) + " | "+ GetAVEnvThermalResist(npcRef) + "\n"
  message += "\n\n"
  message += "NPC AI Data:\n"
  message += "Aggression: " + GetAVAggression(npcRef) + "\n"
  message += "Confidence: " + GetAVConfidence(npcRef) + "\n"
  message += "Suspicious: " + GetAVSuspicious(npcRef) + "\n"
  Debug.MessageBox(message)
  Debug.Trace(message, 2)
EndFunction

Function DumpPlayerInfo() Global
  Actor player = Game.GetPlayer()

  String message = "Player Configuration data:\n"
  message += "Player Level: " + player.GetLevel() + "\n"
  message += "\n\n"
  message += "Player Stats:\n"
  message += "Health: " + GetAVHealth(player) + "\n"
  message += "Power: " + GetAVStarPower(player) + "\n"
  message += "Experience: " + GetAVExperience(player) + "\n"
  message += "Speed: " + GetAVSpeed(player) + "\n"
  message += "\n\n"
  message += "Player Resistances:\n"
  message += "Physical Damage Resist: " + GetAVDamageResist(player) + "\n"
  message += "Energy Damage Resist: " + GetAVEnergyResist(player) + "\n"
  message += "EM Damage Resist: " + GetAVElectromagneticDamageResist(player) + "\n"
  message += "Env Airborne Resist: " + GetAVEnvAirborneResist(player) + "\n"
  message += "Env Corrosive Resist: " + GetAVEnvCorrosiveResist(player) + "\n"
  message += "Env Radiation Resist: " + GetAVEnvRadiationResist(player) + "\n"
  message += "Env Thermal Resist: " + GetAVEnvThermalResist(player) + "\n"
  Debug.MessageBox(message)
  Debug.Trace(message, 2)
EndFunction

String Function GetCombatRole(ObjectReference actorRef) Global
  Keyword CombatRole_Assault_Keyword = Game.GetFormFromFile(0x0006D977, "Starfield.esm") as Keyword
  Keyword CombatRole_Boss_Keyword = Game.GetFormFromFile(0x00000895, "VenworksFactionOverhaul.esm") as Keyword
  Keyword CombatRole_Charger_Keyword = Game.GetFormFromFile(0x0006D976, "Starfield.esm") as Keyword
  Keyword CombatRole_Heavy_Keyword = Game.GetFormFromFile(0x00000892, "VenworksFactionOverhaul.esm") as Keyword
  Keyword CombatRole_Officer_Keyword = Game.GetFormFromFile(0x00000A3D, "VenworksFactionOverhaul.esm") as Keyword
  Keyword CombatRole_Recruit_Keyword = Game.GetFormFromFile(0x00000898, "VenworksFactionOverhaul.esm") as Keyword
  Keyword CombatRole_Sniper_Keyword = Game.GetFormFromFile(0x00000893, "VenworksFactionOverhaul.esm") as Keyword
  Keyword CombatRole_Support_Keyword = Game.GetFormFromFile(0x00000894, "VenworksFactionOverhaul.esm") as Keyword
  If (actorRef.HasKeyword(CombatRole_Assault_Keyword))
    Return "Assault"
  ElseIf (actorRef.HasKeyword(CombatRole_Boss_Keyword))
    Return "Boss"
  ElseIf (actorRef.HasKeyword(CombatRole_Charger_Keyword))
    Return "Charger"
  ElseIf (actorRef.HasKeyword(CombatRole_Heavy_Keyword))
    Return "Heavy"
  ElseIf (actorRef.HasKeyword(CombatRole_Officer_Keyword))
    Return "Officer"
  ElseIf (actorRef.HasKeyword(CombatRole_Recruit_Keyword))
    Return "Recruit"
  ElseIf (actorRef.HasKeyword(CombatRole_Sniper_Keyword))
    Return "Sniper"
  ElseIf (actorRef.HasKeyword(CombatRole_Support_Keyword))
    Return "Support"
  Else
    Return "None"
  EndIf
EndFunction

String Function GetFactionType(ObjectReference actorRef) Global
  Keyword FactionTypeCrimsonFleet = Game.GetFormFromFile(0x000546E0, "Starfield.esm") as Keyword
  Keyword FactionTypeEcliptic = Game.GetFormFromFile(0x00000800, "VenworksFactionOverhaul.esm") as Keyword
  Keyword FactionTypeFreestarCollective = Game.GetFormFromFile(0x000546DF, "Starfield.esm") as Keyword
  Keyword FactionTypeHouseVaruun = Game.GetFormFromFile(0x000546DE, "Starfield.esm") as Keyword
  Keyword FactionTypeRyujinIndustries = Game.GetFormFromFile(0x000546DD, "Starfield.esm") as Keyword
  Keyword FactionTypeSpacer = Game.GetFormFromFile(0x00000A08, "VenworksFactionOverhaul.esm") as Keyword
  Keyword FactionTypeStarborn = Game.GetFormFromFile(0x00000801, "VenworksFactionOverhaul.esm") as Keyword
  Keyword FactionTypeSyndicate = Game.GetFormFromFile(0x00000A09, "VenworksFactionOverhaul.esm") as Keyword
  Keyword FactionTypeTheFirst = Game.GetFormFromFile(0x00000A0A, "VenworksFactionOverhaul.esm") as Keyword
  If (actorRef.HasKeyword(FactionTypeCrimsonFleet))
    Return "Crimson Fleet/Pirate"
  ElseIf (actorRef.HasKeyword(FactionTypeEcliptic))
    Return "Ecliptic"
  ElseIf (actorRef.HasKeyword(FactionTypeFreestarCollective))
    Return "Freestar Collective"
  ElseIf (actorRef.HasKeyword(FactionTypeHouseVaruun))
    Return "House Va'ruun"
  ElseIf (actorRef.HasKeyword(FactionTypeRyujinIndustries))
    Return "Ryujin Industries"
  ElseIf (actorRef.HasKeyword(FactionTypeSpacer))
    Return "Spacer"
  ElseIf (actorRef.HasKeyword(FactionTypeStarborn))
    Return "Starborn"
  ElseIf (actorRef.HasKeyword(FactionTypeSyndicate))
    Return "Syndicate"
  ElseIf (actorRef.HasKeyword(FactionTypeTheFirst))
    Return "1st Cav"
  Else
    Return "None"
  EndIf
EndFunction

Int Function GetAVHealth(ObjectReference actorRef) Global
  Return actorRef.GetValueInt(Game.GetHealthAV())
EndFunction

Int Function GetAVDamageResist(ObjectReference actorRef) Global
  Return actorRef.GetValueInt(Game.GetFormFromFile(0x000002E3, "Starfield.esm") as ActorValue)
EndFunction

Int Function GetAVEnergyResist(ObjectReference actorRef) Global
  Return actorRef.GetValueInt(Game.GetFormFromFile(0x000002EB, "Starfield.esm") as ActorValue)
EndFunction

Int Function GetAVElectromagneticDamageResist(ObjectReference actorRef) Global
  Return actorRef.GetValueInt(Game.GetFormFromFile(0x00000392, "Starfield.esm") as ActorValue)
EndFunction

Int Function GetAVEnvAirborneResist(ObjectReference actorRef) Global
  Return actorRef.GetValueInt(Game.GetFormFromFile(0x00248D31, "Starfield.esm") as ActorValue)
EndFunction

Int Function GetAVEnvCorrosiveResist(ObjectReference actorRef) Global
  Return actorRef.GetValueInt(Game.GetFormFromFile(0x00248D30, "Starfield.esm") as ActorValue)
EndFunction

Int Function GetAVEnvRadiationResist(ObjectReference actorRef) Global
  Return actorRef.GetValueInt(Game.GetFormFromFile(0x00248D2F, "Starfield.esm") as ActorValue)
EndFunction

Int Function GetAVEnvThermalResist(ObjectReference actorRef) Global
  Return actorRef.GetValueInt(Game.GetFormFromFile(0x00248D32, "Starfield.esm") as ActorValue)
EndFunction

Int Function GetEncounterLevel(ObjectReference actorRef) Global
  Return actorRef.CalculateEncounterLevel(Game.GetDifficulty())
EndFunction

String Function GetAVAggression(ObjectReference actorRef) Global
  VPI_SharedObjectManager:Aggression enumAggression = VPI_SharedObjectManager.GetEnumAggression()
  Int aggression = actorRef.GetValueInt(Game.GetAggressionAV())
  If (aggression == enumAggression.Unaggressive)
    Return "Unaggressive"
  ElseIf (aggression == enumAggression.Aggressive)
    Return "Aggressive"
  ElseIf (aggression == enumAggression.VeryAggressive)
    Return "Very Aggressive"
  ElseIf (aggression == enumAggression.Frenzied)
    Return "Frenzied"
  Else
    Return "Unknown (" + aggression + ")"
  EndIf
EndFunction

String Function GetAVConfidence(ObjectReference actorRef) Global
  VPI_SharedObjectManager:Confidence enumConfidence = VPI_SharedObjectManager.GetEnumConfidence()
  Int confidence = actorRef.GetValueInt(Game.GetConfidenceAV())
  If (confidence == enumConfidence.Cowardly)
    Return "Cowardly"
  ElseIf (confidence == enumConfidence.Cautious)
    Return "Cautious"
  ElseIf (confidence == enumConfidence.Average)
    Return "Average"
  ElseIf (confidence == enumConfidence.Brave)
    Return "Brave"
  ElseIf (confidence == enumConfidence.Foolhardy)
    Return "Foolhardy"
  Else
    Return "Unknown (" + confidence + ")"
  EndIf
EndFunction

String Function GetAVSuspicious(ObjectReference actorRef) Global
  VPI_SharedObjectManager:Suspicious enumSuspicious = VPI_SharedObjectManager.GetEnumSuspicious()
  Int suspicious = actorRef.GetValueInt(Game.GetSuspiciousAV())
  If (suspicious == enumSuspicious.Neutral)
    Return "Neutral"
  ElseIf (suspicious == enumSuspicious.HuntingTarget)
    Return "Hunting Target"
  ElseIf (suspicious == enumSuspicious.FoundTarget)
    Return "Found Target"
  Else
    Return "Unknown (" + suspicious + ")"
  EndIf
EndFunction

Int Function GetAVExperience(ObjectReference actorRef) Global
  Return actorRef.GetValueInt(Game.GetFormFromFile(0x000002C9, "Starfield.esm") as ActorValue)
EndFunction

Int Function GetAVSpeed(ObjectReference actorRef) Global
  Return actorRef.GetValueInt(Game.GetFormFromFile(0x000002DA, "Starfield.esm") as ActorValue)
EndFunction

Int Function GetAVStarPower(ObjectReference actorRef) Global
  Return actorRef.GetValueInt(Game.GetFormFromFile(0x00000385, "Starfield.esm") as ActorValue)
EndFunction

String Function GetBountyType(ObjectReference actorRef) Global
  Keyword VEOH_Bounty_Common = Game.GetFormFromFile(0x0000180F, "VenworksEncountersOverhaul.esm") as Keyword
  Keyword VEOH_Bounty_Uncommon = Game.GetFormFromFile(0x00001810, "VenworksEncountersOverhaul.esm") as Keyword
  Keyword VEOH_Bounty_Rare = Game.GetFormFromFile(0x00001811, "VenworksEncountersOverhaul.esm") as Keyword

  If (actorRef.HasKeyword(VEOH_Bounty_Common))
    Return "Common"
  ElseIf (actorRef.HasKeyword(VEOH_Bounty_Uncommon))
    Return "Uncommon"
  ElseIf (actorRef.HasKeyword(VEOH_Bounty_Rare))
    Return "Rare"
  Else
    Return "None"
  EndIf
EndFunction

Int Function GetAVScalingTier(ObjectReference actorRef) Global
  Return actorRef.GetValueInt(Game.GetFormFromFile(0x00000A28, "VenworksFactionOverhaul.esm") as ActorValue)
EndFunction

;; Cannot be done currently they only let you set combat style papyrus side not query it. 
; String Function GetCombatStyle(ObjectReference actorRef) Global
;   CombatStyle csCrimsonFleet_Assault = Game.GetFormFromFile(0x002C5638, "Starfield.esm") as CombatStyle
;   CombatStyle csCrimsonFleet_Charger = Game.GetFormFromFile(0x002C5637, "Starfield.esm") as CombatStyle
;   CombatStyle csCrimsonFleet_Heavy = Game.GetFormFromFile(0x002C5636, "Starfield.esm") as CombatStyle
;   CombatStyle csCrimsonFleet_LowLevel = Game.GetFormFromFile(0x00178CA4, "Starfield.esm") as CombatStyle
;   ;; Spacer Officer Goes here
;   CombatStyle csCrimsonFleet_Recruit = Game.GetFormFromFile(0x002C5635, "Starfield.esm") as CombatStyle
;   CombatStyle csCrimsonFleet_Sniper = Game.GetFormFromFile(0x002C5634, "Starfield.esm") as CombatStyle
;   ;; Spacer Support Goes here
;   CombatStyle csEcliptic_Assault = Game.GetFormFromFile(0x002C5632, "Starfield.esm") as CombatStyle
;   CombatStyle csEcliptic_Charger = Game.GetFormFromFile(0x002C5631, "Starfield.esm") as CombatStyle
;   CombatStyle csEcliptic_Heavy = Game.GetFormFromFile(0x002C5630, "Starfield.esm") as CombatStyle
;   CombatStyle csEcliptic_Officer = Game.GetFormFromFile(0x0026FDB1, "Starfield.esm") as CombatStyle
;   CombatStyle csEcliptic_Sniper = Game.GetFormFromFile(0x002C562F, "Starfield.esm") as CombatStyle
;   CombatStyle csEcliptic_Support = Game.GetFormFromFile(0x002C562E, "Starfield.esm") as CombatStyle
;   CombatStyle csSpacer_Assault = Game.GetFormFromFile(0x002C562D, "Starfield.esm") as CombatStyle
;   CombatStyle csSpacer_Charger = Game.GetFormFromFile(0x002C562C, "Starfield.esm") as CombatStyle
;   CombatStyle csSpacer_Heavy = Game.GetFormFromFile(0x000D2143, "Starfield.esm") as CombatStyle
;   CombatStyle csSpacer_Recruit = Game.GetFormFromFile(0x002C562B, "Starfield.esm") as CombatStyle
;   CombatStyle csSpacer_Sniper = Game.GetFormFromFile(0x000D2144, "Starfield.esm") as CombatStyle
;   CombatStyle csStarborn_Assault = Game.GetFormFromFile(0x00270265, "Starfield.esm") as CombatStyle
;   CombatStyle csStarborn_Charger = Game.GetFormFromFile(0x001AE521, "Starfield.esm") as CombatStyle
;   CombatStyle csStarborn_Heavy = Game.GetFormFromFile(0x00334536, "Starfield.esm") as CombatStyle
;   CombatStyle csStarborn_Sniper = Game.GetFormFromFile(0x0012B471, "Starfield.esm") as CombatStyle
;   CombatStyle csSyndicate_Assault = Game.GetFormFromFile(0x002C563B, "Starfield.esm") as CombatStyle
;   CombatStyle csSyndicate_Charger = Game.GetFormFromFile(0x002C563A, "Starfield.esm") as CombatStyle
;   CombatStyle csSyndicate_Recruit = Game.GetFormFromFile(0x002C5639, "Starfield.esm") as CombatStyle
;   CombatStyle csTheFirst_Assault = Game.GetFormFromFile(0x002C5649, "Starfield.esm") as CombatStyle
;   CombatStyle csTheFirst_Charger = Game.GetFormFromFile(0x002C5648, "Starfield.esm") as CombatStyle
;   CombatStyle csTheFirst_Heavy = Game.GetFormFromFile(0x002C5647, "Starfield.esm") as CombatStyle
;   CombatStyle csTheFirst_Officer = Game.GetFormFromFile(0x002C5646, "Starfield.esm") as CombatStyle
;   CombatStyle csTheFirst_Recruit = Game.GetFormFromFile(0x002C5645, "Starfield.esm") as CombatStyle
;   CombatStyle csTheFirst_Sniper = Game.GetFormFromFile(0x002C5644, "Starfield.esm") as CombatStyle
;   CombatStyle csTheFirst_Support = Game.GetFormFromFile(0x002C5643, "Starfield.esm") as CombatStyle
;   CombatStyle csVaruun_Assault = Game.GetFormFromFile(0x0026FDB6, "Starfield.esm") as CombatStyle
;   CombatStyle csVaruun_Charger = Game.GetFormFromFile(0x002C562A, "Starfield.esm") as CombatStyle
;   If (actorRef.HasKeyword(CombatRole_Assault_Keyword))
;     Return "Assault"
;   ElseIf (actorRef.HasKeyword(CombatRole_Boss_Keyword))
;     Return "Boss"
;   ElseIf (actorRef.HasKeyword(CombatRole_Charger_Keyword))
;     Return "Charger"
;   ElseIf (actorRef.HasKeyword(CombatRole_Heavy_Keyword))
;     Return "Heavy"
;   ElseIf (actorRef.HasKeyword(CombatRole_Officer_Keyword))
;     Return "Officer"
;   ElseIf (actorRef.HasKeyword(CombatRole_Recruit_Keyword))
;     Return "Recruit"
;   ElseIf (actorRef.HasKeyword(CombatRole_Sniper_Keyword))
;     Return "Sniper"
;   ElseIf (actorRef.HasKeyword(CombatRole_Support_Keyword))
;     Return "Support"
;   Else
;     Return "None"
;   EndIf
; EndFunction
