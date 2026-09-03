# UUID utilities

`Venworks:Core:Utilities:UUID` is a vanilla Papyrus utility with no quest, extender, persistence, registration, or UI dependency. VWCORE-3 owns validation/comparison; VWCORE-4 owns explicit generation.

## Input and value contract

`Parse(value)` accepts exactly D (`xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`), B (`{xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx}`), or N (32 hex digits) and returns 32 integer nibbles, or `None` for invalid input. Uppercase, lowercase, and mixed-case ASCII hex are equivalent. Whitespace, URNs, brace-wrapped N, malformed separators, Unicode lookalikes, and partial values are rejected, not repaired. This is structural UUID validation, not a v4-only validator or proof of uniqueness.

`IsValid(value)` includes nil; `IsNil(value)` is true only for a valid all-zero UUID. `AreEqual(left, right)` compares decoded values, independent of text case or shape. Invalid values never compare equal. `Normalize(value)` returns dashed D text or empty on invalid input. It requests lowercase characters, but callers must not assume the Papyrus VM preserves the casing of an existing string. Use `AreEqual`, not byte-sensitive text comparisons. UI/build languages should normalize their own keys before indexing.

`Format(nibbles)` returns D text for exactly 32 values in 0..15 and empty otherwise. `DecodeHex(character)` returns a nibble or -1; `EncodeHex(nibble)` returns a hex digit or empty. These helpers do not modify caller arrays.

## Explicit generation and persistence

`GenerateV4()` uses vanilla `Utility.RandomInt`, fixes the version nibble to 4 and the variant to 8..b, and returns dashed text. It is a convenience generator, not a cryptographic primitive, entropy guarantee, or collision-free allocation service. UUIDv4 layout is defined in [RFC 9562](https://datatracker.ietf.org/doc/html/rfc9562#section-5.4).

For a published consumer, obtain a UUID from any suitable source and retain it across builds, renames, and saves. No Venworks authoring tool is required. Canvas requires an explicitly supplied non-nil identity and checks ownership conflicts. Never regenerate an ID on every quest init/load, and never silently substitute a generated ID for invalid input. For a deliberate save-local use outside that contract, the caller must save the generated result in its own mutable quest-backed state.

## Focused build and current packaging boundary

Run `Tools/buildUuidUtilities.ps1 -CompilerPath <PapyrusCompiler.exe> -FlagsPath <Starfield_Papyrus_Flags.flg> -GameSourcePath <BGS-source-directory>`. It compiles only UUID and UUIDTests into a fresh temporary directory, checks exit status, binary header, source stability and staged hashes, and copies only their PSC/PEX pairs to Staging. It does not synchronize other scripts, alter plugin records, or rebuild Core release archives. Old staged-source deletions are not repaired by this operation.

The Canvas GUID diagnostic package explicitly pins and includes these PEX files with its existing Core fixture. Existing Core release BA2s do not yet include them; this focused change is not a standalone Core release. A separately approved release build must package the production utility before advertising release availability. The tests are explicit diagnostic scripts, not automatic startup behavior.

## Human PC runtime validation

With the new PEX files actually deployed and Papyrus logging enabled, run these console commands:

```text
CGF "Venworks:Core:Tests:UUIDTests.Run"
CGF "Venworks:Core:Tests:UUIDTests.RunGeneration"
```

Expect `VWCORE_UUID_TESTS | validation failures=0` and `generation failures=0`. Capture the exact package hashes and log; compilation alone does not prove these results. The 32-value generator sample checks layout and sample duplicates, not RNG quality. Save/reload persistence, concurrent ownership, and legacy-ID migration are Canvas runtime tests rather than capabilities of this stateless utility. No PC or console runtime success is claimed until these tests execute on that platform.
