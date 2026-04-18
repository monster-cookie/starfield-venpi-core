ScriptName Venworks:Core:Messaging

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Functions
;;;
Function DisplayMessage(Message MessageToShow)
  MessageToShow.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
EndFunction

Function DisplayHelpText(Message MessageToShow, Float HelpMessageDuration, Float HelpMessageInterval, Int HelpMessageMaxTimes, String HelpMessageContext, Int HelpMessagePriority)
  MessageToShow.ShowAsHelpMessage("None", HelpMessageDuration, HelpMessageInterval, HelpMessageMaxTimes, HelpMessageContext, HelpMessagePriority, None)
EndFunction