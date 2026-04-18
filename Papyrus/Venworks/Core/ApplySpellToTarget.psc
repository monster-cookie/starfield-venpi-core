ScriptName Venworks:Core:ApplySpellToTarget extends ActiveMagicEffect  

Import Venworks:Core:Logging

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Global Variables
;;;
GlobalVariable Property Venworks_DebugEnabled Auto Const Mandatory
String Property Venworks_ModName="VenworksCore" Auto Const Mandatory

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
  LogSeverity severityTable = new LogSeverity
  Actor target = akTarget.GetSelfAsActor()
	target.AddSpell(AbilityToApply, false)
  LogUser(modName=Venworks_ModName, moduleName="Venworks:Core:ApplySpellToTarget", functionName="OnEffectStart", logMessage="Added ability with form ID " + AbilityToApply + " to target with form ID " + target + ".", severity=severityTable.Info)
EndEvent