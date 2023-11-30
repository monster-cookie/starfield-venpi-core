Scriptname VPI_ApplySpellToTarget extends ActiveMagicEffect  

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Global Variables
;;;
GlobalVariable Property Venpi_DebugEnabled Auto Const Mandatory

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Properties
;;;
Spell Property AbilityToApply Auto Const Mandatory

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Events
;;;
Event OnEffectStart(ObjectReference akTarget, Actor akCaster, MagicEffect akBaseEffect, Float afMagnitude, Float afDuration)
  Actor target = akTarget.GetSelfAsActor()
	target.AddSpell(AbilityToApply, false)
  VPI_Debug.DebugMessage("VPI_ApplySpellToTarget", "OnEffectStart", "Added ability with form ID " + AbilityToApply + " to target with form ID " + target + ".", 0, Venpi_DebugEnabled.GetValueInt())
EndEvent