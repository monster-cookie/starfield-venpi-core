# Venworks Core Library service-account credential policy

Policy-Version: 1

Use the Codex AI service accounts for GitHub and Plane operations selected by this repository's tooling policy. The only saved credential references are the 1Password card titles below. Resolve account identities, usernames, email addresses, account and vault selectors, item and field identifiers, and token fields from the selected card at runtime. Do not copy their values into this policy or other repository files.

Per the user's direction for this repository, apply these tool and identity selections to work authorized by the current task without requiring a separate adoption record, policy-hash baseline, or execution-review artifact. This instruction also applies when an AgentKit procedure describes such a prerequisite. Verify the actual account and target before authenticated operations; ask only when required task authorization is missing or a concrete identity, target, or permission problem prevents the operation. Continue independent authorized work.

Resolve each exact card title uniquely within the user's approved 1Password account scope. Obtain account, vault, item, and field selectors at runtime and explicitly scope subsequent CLI lookups to that resolved card. Do not assume an account, vault, field name, or field ID. Stop if the card, expected identity, or required credential field is missing or ambiguous. Do not create or modify card fields implicitly. Keep resolved values inside the credential-processing context; report only verification outcomes.

## Identity: github-automation

| Field | Value |
| --- | --- |
| Service | github |
| Expected identity | The Codex AI GitHub service account represented by the named card. Read its login, email, and any saved provider identity fields at runtime. Establish the expected public login and stable provider ID from those fields or a provider-verified association with the card's identity; do not derive the expected account solely from the current tool session or repository owner. Stop if the association cannot be verified. |
| Manager | 1Password CLI (`op`) for runtime card resolution and authorized credential setup; the consuming GitHub integration or CLI retains its existing token context. |
| Reference | card=GitHub (Codex AI); resolve the approved account, vault, item, identity fields, and any required token field at runtime. The card title is a lookup reference, not a credential value or proof of the current tool's identity. |
| Authentication | Reuse an already-correct GitHub MCP or policy-permitted CLI context and verify its identity through that tool. Separately authorized CLI browser sign-in may establish managed OAuth authentication using the account represented by the card; this method does not require a PAT stored in the card. For the configured MCP bearer-token method, resolve the service-account API-token field from the card and supply it only to the consuming host's `GITHUB_MCP_TOKEN` for `https://api.githubcopilot.com/mcp/`. If a user-designated PAT is used with GitHub CLI, `op run` may provide it as child-process `GH_TOKEN`. Stop if a required token field is unavailable. Never substitute a login password for an API token or assume one tool's authentication configures another. |
| Verification | For GitHub MCP, call `mcp__github__get_me` through the same connection used for the operation. For the permitted CLI context, run `gh api --hostname github.com --method GET user`. Compare the returned public login and stable ID against the expected identity resolved from the card and any verified provider association in the protected runtime context. Verify the tooling policy's resolved repository target separately. Stop on mismatch or inability to verify. A successful check in one context does not verify another context or Git transport. |
| Fallback | none |

## Identity: plane-automation

| Field | Value |
| --- | --- |
| Service | plane |
| Expected identity | The Codex AI Plane service account represented by the named card. Read its email and any saved provider identity fields at runtime. Establish the expected stable member identity from those fields or a provider-verified association with the card's identity; display names alone and the current tool session alone do not establish the expected account. Stop if the association cannot be verified. |
| Manager | 1Password CLI (`op`), with the approved account and vault resolved and explicitly selected at runtime. |
| Reference | card=Plane (Codex AI); resolve the approved account, vault, item, identity fields, and the field explicitly identified for the Plane MCP API token at runtime. Never select the login password or a saved one-time code as the token. |
| Authentication | Reuse an already-correct Plane MCP connection after verifying its identity through that connection. When authorized setup or renewal is required, resolve the intended API-token field from the card and supply it through the consuming host process's `PLANE_MCP_PAT`, using 1Password CLI in an isolated process. The configured connector uses `https://mcp.plane.so/http/api-key/mcp` and Bearer authentication. Resolve any card-stored workspace metadata at runtime and verify it against the tooling policy's target before supplying the `x-workspace-slug` header. Do not assume a shell environment change updates an existing MCP session; reinitialize and reverify only within authorized setup scope. Do not switch shared authentication implicitly. |
| Verification | Call `mcp__plane__member` with `action=me` through the same MCP connection used for the operation. Compare the returned member identity and email against the expected identity resolved from the card and any verified provider association in the protected runtime context. Verify the workspace and project resolved by the tooling policy, then inspect that project's current membership before assignment or dependent implementation. Stop on mismatch or inability to verify. |
| Fallback | none |

## Preserve personal authentication

The user requires the browser and GitKraken to remain on the personal account. Codex's GitHub MCP and Codex-initiated GitHub CLI calls must use the separate Codex AI service account. Prefer child-process-only `GH_TOKEN` for Codex's CLI calls and keep any dedicated `GH_CONFIG_DIR` selection process-scoped. Do not overwrite the ordinary CLI login, change shared Git credential helpers, persist a service token in global `GH_TOKEN` or `GITHUB_TOKEN` variables, log the browser out, or reconnect GitKraken. A separately authorized browser sign-in for the service account must use a separate profile or private session. Authentication setup does not authorize changing Git commit authorship or signing.

Keep resolved usernames, emails, account/member/workspace identifiers, vault and item identifiers, token-field identifiers, passwords, tokens, recovery codes, private keys, and saved one-time codes out of repository files, model-visible output, logs, and public review artifacts. Reusing a correctly authenticated integration does not require reading its token again merely because a policy exists. Do not silently fall back to a personal account.
