ScriptName Venworks:Core:Console:Travel

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Functions
;;;

;; Call using: CGF "Venworks:Core:Console:Travel.SomeWhatSafeFastTravel"
Function SomeWhatSafeFastTravel(ObjectReference marker) Global
  Actor PlayerRef = Game.GetPlayer()
  
  If(marker.IsInInterior() == true)
    Game.FastTravel(marker)
  Else
    marker.PreloadExteriorCell()
    Game.FastTravel(marker)
  EndIf
  
  marker.WaitFor3dLoad()    
  PlayerRef.WaitFor3dLoad()
  Utility.Wait(1.0)
EndFunction

;; Call using: CGF "Venworks:Core:Console:Travel.SomeWhatSafeMoveTo" 
Function SomeWhatSafeMoveTo(ObjectReference marker) Global
  Actor PlayerRef = Game.GetPlayer()
  
  If(marker.IsInInterior() == true)
    PlayerRef.MoveTo(akTarget = marker, afXoffset = 0.0, afYoffset = 0.0, afZoffset = 0.0, abMatchRotation = true, abRotateOffset = false)
  Else
    marker.PreloadExteriorCell()
    PlayerRef.MoveTo(akTarget = marker, afXoffset = 0.0, afYoffset = 0.0, afZoffset = 0.0, abMatchRotation = true, abRotateOffset = false)
  EndIf
  
  marker.WaitFor3dLoad()    
  PlayerRef.WaitFor3dLoad()
  Utility.Wait(1.0)
EndFunction

;; Call using: CGF "Venworks:Core:Console:Travel.MarkerIsCurrentLocation" 
Bool Function MarkerIsCurrentLocation(ObjectReference marker) Global
  Location markerLocation = marker.GetCurrentLocation()
  Location playerLocation = Game.GetPlayer().GetCurrentLocation()
  return markerLocation == playerLocation
EndFunction
