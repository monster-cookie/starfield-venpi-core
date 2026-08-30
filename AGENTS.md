# Repository Agent Rules

These rules apply throughout the repository.

## Repository-specific context

- Before asking task-specific clarifying questions, defining a goal, planning, using external project-management systems, or editing files, check for `AGENT-REPO-CONTEXT.md` in the repository root.
- When present, read `AGENT-REPO-CONTEXT.md` completely and treat it as required repository-specific instructions, subordinate to this file and all higher-priority instructions.
- Repository mappings, project identifiers, local paths, repository URLs, and external-system identities belong in `AGENT-REPO-CONTEXT.md`, not this shared instruction file.
- Do not assume repository-specific rules, project identifiers, external systems, paths, or conventions from another repository.
- If the repository-specific context declares an external source of truth, retrieve the relevant current information before planning or implementation.
- If required repository context or its declared external source of truth cannot be read or verified, stop and ask the user how to proceed.

## Questions, goals, and approval

- Before planning or editing files, ask the user clarifying questions to confirm the goal, scope, constraints, and definition of done.
- State a concrete goal for the task. Use the available goal-tracking mechanism when one is available; otherwise include a clearly labeled goal in the response.
- Always produce a plan and wait for explicit user approval before editing files.
- Use `AGENT-PLAN-TEMPLATE.md` when present.
- After approval, make only the approved edits.
- Stop and ask before editing additional paths, changing the goal, or expanding the approved scope.
- Stop and ask the user how to proceed when uncertain or before trying an approach that is new to the codebase. Explain the uncertainty or proposed approach and wait for explicit approval before continuing.

## Repo-wide safety rules

- Git and GitHub mutations are governed exclusively by the Git and GitHub boundaries section below.
- Never edit `AGENTS.md`, `AGENTS.override.md`, `AGENT-PLAN-TEMPLATE.md`, `AGENT-REPO-CONTEXT.md`, or other agent-instruction files directly. Propose the changes and wait for explicit approval.
- Keep changes surgical and consistent with existing patterns and naming.
- Avoid unrelated formatting churn, project-wide cleanup, or broad rewrites.
- Do not introduce new third-party dependencies, frameworks, build tools, package managers, or CI actions without explicit approval in the plan.
- Do not claim build, test, packaging, migration, import, or validation success unless the command actually ran successfully.
- If validation cannot run, report the exact command, the failure or blocker, and whether it appears environmental.
- Do not add secrets, credentials, tokens, connection strings, private keys, personal paths, or machine-specific data to source files, documentation, test fixtures, logs, generated output, or workflow files.

## Markdown line wrapping

- Never hard-wrap Markdown prose at a fixed column width.
- Keep each paragraph and list item on one physical line, regardless of length.
- Let Markdown renderers wrap text responsively.
- Use line breaks only for semantic structure, such as headings, separate paragraphs, lists, tables, and code blocks.
- Do not reflow existing Markdown unless explicitly requested.

## Git and GitHub boundaries

### Read-only inspection

- Clearly read-only Git and GitHub inspection commands are allowed without case-by-case approval when needed to understand repository state, history, tracked files, CI results, pull requests, or repository configuration.
- Permitted read-only Git commands include:
  - `git status`
  - `git diff`
  - `git log`
  - `git show`
  - `git blame`
  - `git ls-files`
  - `git rev-list`
  - `git rev-parse`
  - `git branch --show-current`
  - `git symbolic-ref`
  - `git cat-file`
  - `git grep`
  - `git remote -v`
  - `git submodule status`
- Permitted read-only GitHub operations include repository, workflow-run, check, issue, pull-request, ruleset, branch-protection, and security-setting queries. GitHub API calls must use read-only methods such as `GET`.

### Protected branches

- Treat the repository's remote default branch as protected.
- Always treat branches named `main`, `master`, and `trunk` as protected, even if one is not currently the remote default.
- Before any Git or GitHub mutation, determine the current branch with `git branch --show-current`.
- Determine the remote default branch from `refs/remotes/origin/HEAD` when available.
- If the current branch is empty, detached, or cannot be determined confidently, do not perform mutations and stop for user direction.
- If the current branch is protected, do not edit, commit to, or push it. The agent may create and switch to a non-protected working branch only when the exact branch name, intended base, and branch-creation steps are included in an approved task-specific plan.
- Do not make implementation edits directly on a protected branch unless the user explicitly approves that exceptional scope. Even with approval to edit, never commit directly to or push directly to a protected branch.

### Allowed working-branch delivery

- On a non-protected working branch that was either already selected or created and selected under an approved task-specific plan, the agent may perform the following operations only when they are listed in that plan:
  - stage files within the approved task scope;
  - create new commits containing only the approved changes;
  - push the current branch to a same-named branch on `origin`;
  - set the upstream for that same-named remote branch when necessary;
  - create a draft pull request from the current working branch into the protected default branch;
  - update the title or description of the pull request created for the current task.
- Once the user approves a plan containing these delivery steps, no additional case-by-case confirmation is required for those listed operations.
- Stage explicit approved paths. Do not use `git add .`, `git add -A`, or equivalent broad staging unless inspection confirms that every included change belongs to the approved task.
- Before committing, inspect `git status --short` and the staged diff.
- Before pushing, verify again that the destination is the same-named working branch and is not protected.
- Before opening a pull request, verify that its head is the current working branch and its base is the protected default branch.
- Create pull requests as drafts unless the user explicitly requests a ready-for-review pull request.

### Always prohibited

- Never commit directly to, push directly to, or force-update a protected branch.
- Never push the current commit to a differently named remote branch.
- Never use `--force`, `--force-with-lease`, remote ref deletion, or tag pushing.
- Never merge, close, or approve a pull request.
- Never merge, rebase, cherry-pick, revert, reset, amend, restore, or check out files unless separately and explicitly approved in the task-specific plan.
- The agent may create and switch to a non-protected working branch only when the exact branch name and both operations are listed in an approved task-specific plan. Before doing so, verify the current branch, remote default branch, intended base commit, target branch name, and worktree state; confirm the target is not protected; and preserve unrelated changes. Use the `codex/` prefix by default unless the user approves another name.
- Never delete or rename branches.
- Never create or delete tags or stashes.
- Never modify remotes, repository configuration, hooks, worktrees, submodules, branch protection, rulesets, secrets, releases, or repository settings.
- Preserve unrelated staged, unstaged, and untracked user changes.
- If any required branch or destination check fails, stop before mutation and report the exact blocker.

## Delivery and commit-message handoff

- If the approved plan authorizes working-branch delivery, stage only approved paths, create the commit, push the same-named working branch, and create or update its draft pull request.
- Report the resulting commit hash, pushed remote branch, and pull-request URL.
- Do not claim that a commit, push, or pull request succeeded unless the corresponding command actually completed successfully.
- If delivery is not authorized, provide a suggested Git commit title and body instead of staging or committing.
- Use a concise imperative commit title that summarizes the goal.
- In the body, summarize the major implementation, configuration, documentation, staging, and validation changes.
- When providing a suggested commit message, format the title and body in separate code blocks for easy copying.

## Planning requirements

Before edits, produce a plan containing:

- Scope and intent.
- Exact file paths expected to change.
- A code-level checklist.
- UI impacts, if any. Exclude this when it does not apply.
- Data model, persistence, or schema impacts, if any. Exclude this when it does not apply.
- Configuration, environment variable, path, logging, dependency injection, or workflow impacts, if any. Exclude this when it does not apply.
- Documentation impacts, or the exact statement: `Documentation impacts: None.`
- Risks and rollback notes.
- A validation plan with specific commands or manual checks.