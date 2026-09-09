# Venworks Core Library tooling policy

Policy-Version: 1

This repository policy applies only to this checkout of `starfield-venworks-core`, as identified by its existing repository context and configured origin. Combine it with applicable shared tooling and credential policies. Repository entries replace shared entries with the same ID in full. Unspecified services keep their existing authorized workflow.

Per the user's direction for this repository, apply these tool and identity selections to work authorized by the current task without requiring a separate adoption record, policy-hash baseline, or execution-review artifact. This instruction also applies when an AgentKit procedure describes such a prerequisite. Verify the actual account and target before authenticated operations; ask only when required task authorization is missing or a concrete identity, target, or permission problem prevents the operation. Continue independent authorized work.

## Tool: github

| Field | Value |
| --- | --- |
| Service | github |
| Roles | all |
| Requirement | preferred |
| Tool | GitHub MCP integration (`mcp__github__*`) using the Codex AI service account. Use the exact GitHub host and repository from Target and verify the actual consuming session's identity before the operation. |
| Identity | github-automation |
| Target | The exact GitHub repository resolved from this checkout's configured origin and existing `AGENT-REPO-CONTEXT.md`. Require host=github.com and API endpoint=https://api.github.com; resolve owner and canonical repository at runtime. Require agreement with the repository context and current task. A changed origin does not authorize a different target. Stop if context, origin, or task target disagree. |
| Operations | task-scoped; repository inspection and GitHub operations only when authorized by the current task and applicable repository instructions. Pull requests must be ready for review. This entry grants no standing permission to publish, change repository settings, manage credentials, merge, approve, deploy, or release. Prohibited: draft pull requests, force updates, and commits or pushes directly to a protected branch. |
| Fallbacks | Installed GitHub CLI (`gh`) when the MCP service-account context is unavailable and the CLI context independently verifies as the same Codex AI account. The same target, identity, and operation limits apply. Existing CLI browser authentication is permitted; an API token stored in 1Password is not mandatory for that authentication method. No personal-account fallback. |

## Tool: plane

| Field | Value |
| --- | --- |
| Service | plane |
| Roles | all |
| Requirement | required |
| Tool | The Plane MCP integration exposed as `mcp__plane__*`, using the Codex AI service-account context from the `Plane (Codex AI)` 1Password card. |
| Identity | plane-automation |
| Target | MCP endpoint=https://mcp.plane.so/http/api-key/mcp; only the workspace and project mapped to this repository in its existing `AGENT-REPO-CONTEXT.md`. Resolve the workspace selector and project ID at runtime from that mapping and scoped Plane lookup, then require agreement with the repository mapping, current task, and any workspace metadata from the selected card. Stop on missing or conflicting mappings. Do not save resolved identifiers in this policy. |
| Operations | task-scoped; read current governing requirements and perform only explicitly authorized operations on related work items in the Target project. Supply the exact project UUID whenever the tool supports project scoping, and verify the returned project for unscoped retrieval. Comments, assignments, and state changes require explicit task authorization. Final acceptance, Done transitions, and completion unassignment retain the repository's separate action-time confirmation requirement. Prohibited: unrelated workspace maintenance and use of the retired Codecks system. |
| Fallbacks | none |

## Tool: local-git

| Field | Value |
| --- | --- |
| Service | local-git |
| Roles | all |
| Requirement | required |
| Tool | Installed Git CLI for credential-free local repository inspection and explicitly authorized local working-branch changes. |
| Identity | none |
| Target | This repository checkout; verify its root, current branch, and configured origin against its existing repository context and current task before a task-scoped mutation. |
| Operations | task-scoped; read-only inspection and local branch, staging, or commit operations only within existing task authorization and repository instructions. Git transport operations are outside this entry. Prohibited: commits directly to protected branches and destructive history changes without separate explicit authorization. |
| Fallbacks | none |

## Tool: repository-powershell

| Field | Value |
| --- | --- |
| Service | local-build |
| Roles | all |
| Requirement | preferred |
| Tool | PowerShell 7 via `pwsh -NoProfile`, using the repository's existing `Tools/` scripts and documented parameters. Relevant entry points include `Tools/checkRepo.ps1`, `Tools/compileScripts.ps1`, and `Tools/createPackages.ps1`. Inspect the selected script, its imports, configuration, and side effects before execution. |
| Identity | none |
| Target | This checkout of `starfield-venworks-core` and the specific local inputs and output paths authorized by the task. |
| Operations | task-scoped; credential-free local checks, compilation, and packaging when authorized. A tool name does not authorize its side effects. Downloads, tool installation, live game staging, junction changes, or authenticated operations require their own applicable authorization and policy resolution. |
| Fallbacks | none |

## Tool: diagrams

| Field | Value |
| --- | --- |
| Service | diagrams |
| Roles | all |
| Requirement | preferred |
| Tool | Mermaid fenced Markdown diagrams. |
| Identity | none |
| Target | Architecture documentation, technical documentation, and authorized pull-request descriptions for `starfield-venworks-core`. |
| Operations | task-scoped; add or update diagrams when they clarify structure, dependencies, data flow, or lifecycle. Creating a diagram does not authorize publishing it. |
| Fallbacks | none |

## Codex and personal application separation

The Codex AI account is required only for Codex's GitHub MCP connection and Codex-initiated GitHub CLI operations. Preserve the user's personal browser sessions, GitKraken connection, and ordinary GitHub CLI login.

For Codex-initiated `gh` calls, prefer a service-account token injected only into the child process as `GH_TOKEN`, with a dedicated `GH_CONFIG_DIR`. These process settings must not be persisted as Windows User or Machine environment variables. Do not run `gh auth switch`, `gh auth logout`, or `gh auth setup-git` against the user's ordinary configuration, and do not change shared Git credential helpers, signing settings, or commit authorship as part of service-account API setup.

Supply the MCP credential only to Codex's configured GitHub connection. A username/password in the 1Password card can support separately authorized service-account sign-in, but it is not the API bearer token. If browser authentication is needed for setup, use a separate service-account browser profile or private session so the user's regular browser stays signed in personally. Reverify the service account through the actual MCP and CLI contexts independently.

## Git transport and credential boundaries

GitHub identity verification establishes only the MCP session or GitHub CLI context that was checked. It does not establish the identity used by another tool, a Git CLI transport, GitKraken, an SSH key, or an HTTPS credential helper. For a fetch, push, or other authenticated Git operation authorized by the user, verify the actual transport's account and destination. Use the same Codex AI account without changing the user's personal application authentication. No additional transport-policy document or execution-review record is required.

Do not substitute an ambient account or switch a shared login when the required integration or identity is unavailable. Continue independent credential-free work within the task's authorization and report the affected operation.
