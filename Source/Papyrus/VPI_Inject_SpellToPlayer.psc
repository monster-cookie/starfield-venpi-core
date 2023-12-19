ScriptName VPI_Inject_SpellToPlayer extends Quest

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Global Variables
;;;
GlobalVariable Property Venpi_DebugEnabled Auto Const Mandatory
String Property Venpi_ModName="VenpiCore" Auto Const Mandatory

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Properties
;;;
Actor Property PlayerRef Auto Const Mandatory
Spell Property SpellToEnable Auto Const Mandatory

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Events
;;;
Event OnQuestInit()
  VPI_Debug.DebugMessage(Venpi_ModName, "VPI_Inject_SpellToPlayer", "OnQuestInit", "Spell " + SpellToEnable + " added to player.", 0, Venpi_DebugEnabled.GetValueInt())
  PlayerRef.AddSpell(SpellToEnable, false)
EndEvent
