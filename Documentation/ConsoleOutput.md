# Console output utilities

VWCORE-5 introduces `Venworks:Core:Utilities:Console` in `Papyrus/Venworks/Core/Utilities/Console.psc`. It has no quest, properties, saved state, registration, guards, timers, watch transport, or extender dependency. The `Debug.ExecuteConsole` echo idiom was demonstrated by the user-supplied OneKUtils example; unrelated functions and timestamp handling were not imported.

## API and boundaries

`ConsoleEcho(String text = "") Global` submits one trusted diagnostic line prefixed with `=> `. The caller supplies any mod/operation label, for example `ConsoleEcho("VWCANVAS: Registry.ConsoleResolve | CONSOLE_RESOLVED")`. Empty text produces a prefixed blank line. Embedded CR or LF rejects the entire entry and emits the fixed `CONSOLE_ECHO_REJECTED_MULTILINE` diagnostic instead. Failure to obtain characters for nonempty input emits `CONSOLE_ECHO_REJECTED_INPUT`.

`ConsoleEchoBlock(String[] lines) Global` calls the same single-line helper for each array entry. `None` and empty arrays emit nothing; blank entries remain blank lines. Rejection of one entry does not suppress later entries. Order is preserved within one call, but concurrent callers may interleave; the helper does not take a lock or promise atomic block output.

These are public globals, not DebugOnly/BetaOnly functions. They do not return a display result, mirror Papyrus logs, or echo normal Core logging automatically. A CGF function's Papyrus return value is not the console feedback mechanism: callers must explicitly emit feedback. Canvas retains its result returns for Papyrus callers and separately invokes this utility after its guarded work finishes.

`=> ` is a presentation convention, not a native console print command. This technique submits prefixed text to the console parser; its visible rendering must be checked in Starfield. This is not a general-purpose command executor, an escaping API for arbitrary untrusted text, a high-frequency logging sink, or a gameplay UI channel. Use controlled diagnostic messages. Do not pass raw external data or console command batches.

## Build and staging

In PowerShell 7, run `Tools/buildConsoleUtilities.ps1 -CompilerPath <PapyrusCompiler.exe> -FlagsPath <Starfield_Papyrus_Flags.flg> -GameSourcePath <BGS-source-directory>`. It compiles only `Utilities/Console.psc` and `Tests/ConsoleOutputTests.psc` into fresh temporary output and publishes only their two PSC/two PEX files after both compiles succeed. The optional `-EnvironmentPath` defaults to this repository's `.env`; only `MODULE_DATABASE_PATH` is read, without executing or importing other settings.

The helper reuses `sharedStagingValidation.ps1`. It requires the existing `Staging` junction to point at the configured physical module directory, rejects redirected destinations, and revalidates before writes. It never repairs, recreates, deletes, or retargets staging, and never synchronizes unrelated files. Keep other staging writers idle: checks are not an atomic filesystem lock, and an I/O failure after publication begins can leave a subset updated. Stop and inspect; do not delete the junction to recover.

This is an unreleased additive increment. Core 2.1.6 ESM, version metadata, and release BA2s are unchanged. The focused build stages loose/source files only; it is not a new Core release. Canvas's diagnostic Host BA2 pins and includes both new PEX files alongside its existing Core dependencies. Test the actual deployed package, not merely a successful repository build.

## Automated validation

```powershell
pwsh -NoProfile -File .\Tools\testConsoleOutput.ps1
pwsh -NoProfile -File .\Tools\testConsoleOutput.ps1 -CompilerPath <PapyrusCompiler.exe> -FlagsPath <Starfield_Papyrus_Flags.flg> -GameSourcePath <BGS-source-directory>
Invoke-ScriptAnalyzer -Path .\Tools -Recurse -Settings .\PSScriptAnalyzerSettings.psd1
git diff --check
```

The test checks source contracts and rejects invalid source mutations, then runs isolated junction/publication regressions against the actual build helper. Synthetic compiler bytes exercise control flow only; the optional real compiler mode verifies real compilation in a disposable fixture. Neither mode changes the live staging folder. Source regexes and successful compilation do not establish Papyrus VM behavior or console rendering.

## Human PC acceptance

First deploy the exact new utility PEX (or the matching Canvas Host BA2), then run:

```text
cgf "Venworks:Core:Utilities:Console.ConsoleEcho" "VWCANVAS: echo smoke test"
```

Expected visible text is `=> VWCANVAS: echo smoke test`. Capture the actual console response, including any parser-generated decoration/errors. If the text is absent or the prefix behaves unexpectedly, stop: no later result is accepted merely because a Papyrus function returned or a build passed.

Then invoke the explicitly packaged probe:

```text
cgf "Venworks:Core:Tests:ConsoleOutputTests.Run"
```

Expect these eleven submitted lines in order (the rejection message's full text includes `| Use ConsoleEchoBlock with one line per entry.`):

1. `=> VWCORE: CONSOLE_TEST_BEGIN`
2. `=> VWCORE: SINGLE_LINE`
3. `=> VWCORE: BLOCK_FIRST`
4. `=> ` (blank entry)
5. `=> VWCORE: BLOCK_LAST`
6. `=> VWCORE: NONE_EMPTY_CHECK_END` (None and empty arrays added no lines)
7. `=> CONSOLE_ECHO_REJECTED_MULTILINE ...` (LF)
8. `=> CONSOLE_ECHO_REJECTED_MULTILINE ...` (invalid block entry)
9. `=> VWCORE: BLOCK_CONTINUES`
10. `=> ` (default argument)
11. `=> VWCORE: CONSOLE_TEST_END | Verify visible lines; this is not a runtime PASS.`

The harmless `VWCORE_HARMLESS_SENTINEL` text must not appear as a separately submitted command. The installed Bethesda compiler rejects `\r` literals, so this probe supplies LF only; the CR/CRLF rejection path is source-checked but remains unexercised in the game VM. Inspect Papyrus logs for runtime errors too. The final marker means only that the probe reached its end, not that output was seen or all checks passed. Record exact package hashes and observed results; PC acceptance is pending until a person performs these checks. No PS5 or HUD delivery acceptance is implied.
