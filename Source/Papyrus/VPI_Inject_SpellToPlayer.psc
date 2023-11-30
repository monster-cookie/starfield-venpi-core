scriptname VPI_Inject_SpellToPlayer extends Quest

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Global Variables
;;;
GlobalVariable Property Venpi_DebugEnabled Auto Const Mandatory

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
  PlayerRef.AddSpell(SpellToEnable, false)
  VPI_Debug.DebugMessage("VPI_Inject_SpellToPlayer", "OnQuestInit", "Spell " + SpellToEnable + " added to player.", 0, Venpi_DebugEnabled.GetValueInt())
EndEvent
