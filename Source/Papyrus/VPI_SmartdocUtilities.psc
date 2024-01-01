ScriptName VPI_SmartdocUtilities

;;
;; MAJOR NOTE: ALL FUNCTIONS MUST BE GLOBAL WITHOUT CREATION KIT
;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Functions
;;;

;; Call using: CGF "VPI_SmartdocUtilities.Use" 
Function Use() Global
  Potion smartdoc = Game.GetFormFromFile(0x30000801, "Smartdoc.esm") as Potion
  If (smartdoc == None)
    ;; Smartdoc probably is not installed or the form ID has been changed
    Return
  EndIf

  Actor player = Game.GetPlayer()
  player.EquipItem(smartdoc as Form, false, false)
EndFunction