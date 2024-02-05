# Venworks Core Utilities and Shared Objects

## Version 1.0.17
* Excluded anything from the whole nasa launch tower cell from the safe fast travel list. Some how still getting sent there when all listed map markers and xMarkerHeading referers are excluded. 

## Version 1.0.16
* Excluded the MQ301 locations (Moon and Nasa) from usage they are not properly tagged so were showing up. 

## Version 1.0.15
* Fast Travel/MoveTo Utility Functions with error handling. Thank you SKK50 for the feedback and help with it. 
* Added overridable form list to exclude map markers from safe fast travel targets. The default values into it are know to cause infinite load screens or dump you outside valid space.
* Added a quest and collection list to get a somewhat safe list of fast travel targets

## Version 1.0.14
* New condition forms for detecting if the player is aware of starborn and NG+ mode. 

## Version 1.0.13
* Added shared enum class for difficulty/preset mode for Scale The World and Resize The World.

## Version 1.0.12
* Added utility command to enable use of smartdoc via console hotkey. For the hotkey run: CGF "VPI_SmartdocUtilities.Use"

## Version 1.0.11
* Added default for Venpi_ModName to prevent blank named log files
* Added new shared inventory functions
* Created a shared object manger for shared global objects across mods. Uses an init quest and manager script. 

## Version 1.0.10
* Using user log files instead of the papyrus logs. Thank you SFCP team. 
* This mod will break all my mods I have updates prepped and tested but will probably take an hour to upload them all. So don't update this until all the ones you use are uploaded.

## Version 1.0.9
* Added leveled lists for ingredients

## Version 1.0.8
* Added a bunch of leveled item lists for use in Galactic Pawn/Junk and Cora

## Version 1.0.7
* New condition forms for checking is an NPC is a critter, human, or robot

## Version 1.0.6
* New condition form for checking if an NPC is a creature

## Version 1.0.5
* New cloak ability injector for the upcoming split dynamic scaling mods and new NPC resizer

## Version 1.0.4
* Added injector utilities that will be used by "Cora Wants All The Book" and the new split dynamic scaling mods

## Version 1.0.3
* Added message display utility

## Version 1.0.2
* Moved rare books leveled item list to core so "Cora Can Read" mod can use it also

## Version 1.0.1
* Not implemented message object for Galactic Pet/Pawn Shop

## Version 1.0.0
* Initial Release