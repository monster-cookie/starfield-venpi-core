ScriptName VPI_Messaging

;;
;; MAJOR NOTE: ALL FUNCTIONS MUST BE GLOBAL WITHOUT CREATION KIT
;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Functions
;;;
Function DisplayMessage(Message MessageToShow) Global
  MessageToShow.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
EndFunction

Function DisplayHelpText(Message MessageToShow, Float HelpMessageDuration, Float HelpMessageInterval, Int HelpMessageMaxTimes, String HelpMessageContext, Int HelpMessagePriority) Global
  MessageToShow.ShowAsHelpMessage("None", HelpMessageDuration, HelpMessageInterval, HelpMessageMaxTimes, HelpMessageContext, HelpMessagePriority, None)
EndFunction