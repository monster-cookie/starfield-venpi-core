ScriptName VPI_TravelUtilities

;;
;; MAJOR NOTE: ALL FUNCTIONS MUST BE GLOBAL WITHOUT CREATION KIT
;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Functions
;;;

;; Call using: CGF "VPI_TravelUtilities.SomeWhatSafeFastTravel"
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

;; Call using: CGF "VPI_TravelUtilities.SomeWhatSafeMoveTo" 
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

;; Call using: CGF "VPI_TravelUtilities.MarkerIsCurrentLocation" 
Bool Function MarkerIsCurrentLocation(ObjectReference marker) Global
  Location markerLocation = marker.GetCurrentLocation()
  Location playerLocation = Game.GetPlayer().GetCurrentLocation()
  return markerLocation == playerLocation
EndFunction

;; Call using: CGF "VPI_TravelUtilities.GetSomeWhatSafeMarker" 
ObjectReference Function GetSomeWhatSafeMarker(RefCollectionAlias knownMarkers) Global
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
