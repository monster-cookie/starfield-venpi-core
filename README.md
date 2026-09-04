# Venworks Core

Venworks Core is a Starfield utility and shared-object plugin for Venworks creations.

## Repository Layout

- `Spriggit/`: YAML source for `Venworks-Core.esm`.
- `Papyrus/`: Papyrus source scripts.
- `Staging/`: Committed release-ready game files and generated outputs used by packaging. This is a folder junction to your Vortex/MO2 Staging Folder.
- `Tools/`: Local PowerShell workflows for setup, Papyrus compilation, Spriggit assembly, validation, and BA2 package generation.
- `Documentation/`: Project-specific documentation, including release packaging notes.
- `MarketingSites/`: Nexus and marketing assets.

## Workflow

This repo follows the standard Starfield modding workflow documented in [SFCK Workflow](https://github.com/monster-cookie/starfield-modding-notes/blob/master/Modding/Workflow.md).

The short version for this repository is that source edits and generated game artifacts must stay together. When changing Papyrus, Spriggit YAML, plugin records, or archive contents, regenerate the corresponding files locally before committing.

Release-specific expectations are documented in [Release Packaging(Documentation/ReleasePackaging.md).

## Local Tooling

### Console output diagnostic increment

The [console output helpers](Documentation/ConsoleOutput.md) provide explicitly invoked `Venworks:Core:Utilities:Console.ConsoleEcho` and `ConsoleEchoBlock`. Callers supply their own labels; Core adds a neutral `=> ` prefix through `Debug.ExecuteConsole`. `Tools/buildConsoleUtilities.ps1` compiles and stages only these two scripts and their sources using the existing junction checks. This unreleased increment does not rebuild Core 2.1.6 archives; Canvas pins the new scripts in its diagnostic Host package. Visible output and prefix behavior still require the documented PC checks.

### UUID diagnostic increment

The new [UUID utilities](Documentation/UUID.md) accept case-insensitive supplied identities and provide an explicit convenience generator. `Tools/buildUuidUtilities.ps1` compiles only their source/runtime files without synchronizing unrelated staging content or rebuilding release BA2s. Canvas's GUID probe packages these pinned scripts explicitly; existing Core release archives are unchanged and do not yet deliver this utility. See the linked guide for runtime test commands and the release boundary.

Most local workflows are driven through scripts in `Tools/`. They expect a configured `.env` and local Starfield/Creation Kit tooling.

Common scripts:

- `Tools/setupRepo.ps1`: Prepare local Vortex/MO2 folder junction.
- `Tools/checkRepo.ps1`: Validate expected local staging setup. Unfortunately Windows will randomly reset the junction luckily this is pretty rare.
- `Tools/compileScripts.ps1`: Compile Papyrus scripts and send them and their source to the staging folder. This needs to be ran anytime you change Papyrus code.
- `Tools/SpriggitAssembleDatabaseFromYaml.ps1`: Assemble Spriggit YAML into the staged plugin file. This is dangerous as not all records are fully supported.
- `Tools\SpriggitDumpDatabaseToYaml.ps1`: Dump the ESM database into Spriggit YAML. This needs to be ran anytime you change the ESM/ESP.
- `Tools/createPackages.ps1`: Create BA2 archives from staged content. This needs to be ran any time you change Papyrus code.

## Releases

Releases are created from tags in `v<major>.<minor>.<patch>` format on `master`. The GitHub release workflow produces four zips:

- `Venworks-Core-PC-x.y.z.zip`
- `Venworks-Core-XBox-x.y.z.zip`
- `Venworks-Core-PS5-x.y.z.zip`
- `Venworks-Core-CreationsSite-x.y.z.zip`

Each zip contains `Staging/Venworks-Core.esm` and only the platform BA2 archives for that package. The PS5 package currently uses renamed copies of the PC BA2 archives, and the Creations Site package bundles the PC, XBox, and generated PS5 archive names together. The workflow intentionally excludes `Staging/Venworks-Core.esp`, loose scripts, source files, metadata, and local-only outputs.

GitHub Releases receives all four zips. Nexus Mods receives only the PC zip.

Release notes come from the matching `## Version x.y.z` section in [CHANGELOG.md](CHANGELOG.md). The same notes are converted to BBCode for the Nexus Mods description.

## License

This repository is licensed under the terms in [LICENSE](LICENSE).
