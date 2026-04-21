ScriptName Venworks:Core:Inject_SpellToPlayer extends Venworks:Core:Base:BaseQuest


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
Actor Property PlayerRef Auto Const Mandatory
Spell Property SpellToEnable Auto Const Mandatory


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Events
;;;
Event OnQuestInit()
  LogUserInformational(creationName=Venworks_ModName, moduleName="Venworks:Core:Inject_SpellToPlayer", functionName="OnQuestInit", logMessage="Spell " + SpellToEnable + " added to player.")
  PlayerRef.AddSpell(SpellToEnable, false)
EndEvent
