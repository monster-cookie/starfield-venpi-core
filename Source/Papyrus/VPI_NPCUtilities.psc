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
    return "Ecliptix PMC"
  ElseIf (npc.HasKeyword(NPC_Spacer))
    return "Spacer"
  Else
    return "Unkown - " + npc
  EndIf
EndFunction
