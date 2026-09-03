@{
  Severity = @(
    'Error'
    'Warning'
  )
  ExcludeRules = @(
    # These scripts deliberately use Write-Host for operator-facing progress,
    # status, and installation output where host formatting is part of the UX.
    'PSAvoidUsingWriteHost'

    # Shared release configuration is dot-sourced and intentionally publishes
    # package metadata and load sentinels for repository entry points.
    'PSAvoidGlobalVars'

    # Internal collection helpers use plural nouns to describe plural results.
    'PSUseSingularNouns'

    # State-changing helpers are private implementation details rather than
    # exported commands with user-facing WhatIf and Confirm contracts.
    'PSUseShouldProcessForStateChangingFunctions'

    # Repository text files use UTF-8 without a BOM across PowerShell versions.
    'PSUseBOMForUnicodeEncodedFile'
  )
}
