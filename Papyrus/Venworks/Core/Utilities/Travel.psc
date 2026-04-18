ScriptName Venworks:Core:Utilities:Travel

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Functions
;;;

Function SomeWhatSafeFastTravel(ObjectReference marker)
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

Function SomeWhatSafeMoveTo(ObjectReference marker)
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

Bool Function MarkerIsCurrentLocation(ObjectReference marker)
  Location markerLocation = marker.GetCurrentLocation()
  Location playerLocation = Game.GetPlayer().GetCurrentLocation()
  return markerLocation == playerLocation
EndFunction

ObjectReference Function GetSomeWhatSafeMarker(RefCollectionAlias knownMarkers)
  ObjectReference mapMarkerRef = None
  While (mapMarkerRef == None)
    mapMarkerRef = knownMarkers.GetRandom()
    If (MarkerIsCurrentLocation(mapMarkerRef)) 
      mapMarkerRef = None
    EndIf
    if (mapMarkerRef.GetCurrentPlanet() == None)
      ;; Probably a pack in cell
      mapMarkerRef = None
    EndIf
  EndWhile
  
  ;; map markers have a linked ref that it the correct marker to teleport to 
  ObjectReference markerRef = mapMarkerRef.GetLinkedRef(None)
  If (markerRef == None)
    markerRef = mapMarkerRef
  EndIf

  return markerRef
EndFunction
