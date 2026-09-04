# Venworks Core Utilities and Shared Objects

## Version 2.1.8 (September 3, 2026)

- Add global function helpers in `Utilities/Console.psc` for single-line and block console diagnostics, with caller-owned labels and rejection of embedded line breaks.
- Fixed the console prefix to no cause the command not found error. TSD is a special disabled command so no error. but means everythigng will be TSD> prefixed.

## Version 2.1.6 (September 3, 2026)

- Added functions from generating, testing, and parsing UUIDs

## Version 2.1.5

- Create Archives will no longer pull in any existing archives.

## Version 2.1.3

- I had to recreate the ESP/ESM from scratch. The current esp/esm is corrupted and keeps trying to write out as sfbgs007.esm. I suspect this because I attempted to convert the old pre-SFCK xEdit esm to a esp using the plugin bridge. With xEdit I was able to manually preserve the FormIDs. This should preserve any save games accessing it.
- Removing the some what safe fast travel stuff for now.

## Version 2.1.1

- Removed the XBox archives from Nexus Mods' version
- Updated the workflow to make separate zips for PC, XBox, and PS5

## Version 2.1.0

- Moving Scene Manager stuff to my new Dynamic Scenes Engine creation/framework.
- Pulling in my shared functions from encounters overhaul.
- Added Game Play Options handler for Core Debug mode.
- Added a shared script handler for game play options any other consuming library should be able to use.
- Added chance globals and condition forms

### Breaking Change

- SFCK for some lame reason generated a Form ID well out of the small master range when it had 4077 free small master IDs left. Unfortunately the only way I could find to fix this was to compact IDs. xEdit would let me change the offending ID but then refused to save it. TLDR: This compaction voids this version against any current save games with out a unity trip or new game. Nothing is really using 2.x currently so I'm not really worried about this but am being transparent.

## Version 2.0.1

- Added new Radiant Engine themes for small, medium, and large manmade clutter packins.
- Radiant Engine is too problematic so pulling in the unreleased SceneManager I wrote for QOG. This will function as a bridge between the cells and Radiant Engine triggers/markers.
- Added my normal debug arrow to help finding PCM models
- Added EnableDisableToggleOnLoad to allow for enabling/disabling an object based on a global variable
- Added several randomization condition forms that disable on debug mode being enabled

## Version 2.0.0

- Recompile against Free Lanes and misc bug fixes
- Stay away from the travel functions I'm still fixing them for SFCK compatibility
- I dropped the leveled lists while I rethink them or if they are even needed

## Version 1.0.21

- Adding new enum for NPC faction titles will be used for index parsing with new faction title form lists for Venworks factions cause the auto title script goes over the property limit.
