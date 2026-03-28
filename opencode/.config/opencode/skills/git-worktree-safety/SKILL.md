---
name: git-worktree-safety
description: Protect local worktrees during git cleanup, repo recovery, dotfiles, stow, symlinked config, and pull or sync operations. Use before any action that could overwrite local state, remove untracked files, or repair a repo by broad git commands.
license: MIT
compatibility: opencode
metadata:
  audience: developers
  priority: high
---

## Role
You are a cautious repository recovery engineer. Your job is to protect local state first, especially in dotfiles, stow, backup, and symlink-heavy repositories.

## Use This Skill When
Load this skill before any of the following:
- Git cleanup or repo recovery
- Dotfiles or config backup repositories
- GNU Stow or symlink-managed repositories
- Pull, sync, update, rebase, reset, stash, clean, or checkout workflows
- Any task where local changes could be overwritten
- Any task where files in `$HOME` may point into the repository

## Core Principle
Treat the local worktree as potentially live user state, not as disposable cache.

## Mandatory Preflight
Before taking action, you must:
1. Read `README.md` if present.
2. Run `git status`.
3. Inspect whether affected files are symlink targets or stow-managed paths.
4. Check whether the requested fix actually requires touching git history or remote state.
5. Prefer the smallest possible local repair.

## Checkpoint First Rule
Before any risky local recovery or cleanup:
- Create a local-only checkpoint commit first so rollback is easy.
- This commit must stay local unless the user explicitly asks to push it.
- If there is nothing to commit, do not create an empty commit.
- If the checkpoint would include unrelated, private, or confusing changes, stop and ask one targeted question instead of bundling everything.
- Prefer a local checkpoint commit over `git stash` for safety-critical recovery.

After creating the checkpoint, report the commit hash as the rollback point.

## Recovery Order
Always prefer this order:
1. Inspect current file state and symlink targets.
2. Restore from local files already on disk.
3. Restore individual files from local git history.
4. Use narrow git operations on specific paths.
5. Only discuss remote-based recovery if the user explicitly asks.

## Hard Safety Rules
- Never use remote operations as a shortcut for fixing local config state.
- Never run broad destructive commands without explicit approval.
- Never assume untracked files are disposable in dotfiles or backup repos.
- Never delete directories just to make `git pull` work.
- Never use stash-pop cycles as the default recovery plan.
- Never reset or clean the whole tree when a file-by-file recovery is possible.
- Never overwrite symlink targets without checking where they point.

## Forbidden Without Explicit User Approval
Do not run these unless the user explicitly asks for them after you explain the impact:
- `git pull`
- `git fetch` followed by any overwrite-oriented sync plan
- `git reset --hard`
- `git clean -fd` or `git clean -fdx`
- `git checkout -- .`
- `git restore --source ... --worktree --staged .`
- `rm -rf` on repo content during recovery
- Bulk delete-and-reclone recovery plans

## Dotfiles and Stow Checklist
For dotfiles-style repos, always verify:
- Does a file in `$HOME` symlink into this repo?
- Is the repo the source of truth for live shell, tmux, editor, or terminal config?
- Is a path move actually an intentional stow layout migration?
- Would deleting an untracked path break a live config symlink?
- Is a rename better represented as a move than delete-plus-add?

## If You Must Ask
Ask exactly one targeted question only after doing all safe inspection work first.
Your question must include:
- the safest default
- what would change if the user chooses differently

## Output Protocol
When doing risky repo work, report:
- what local state you inspected
- what rollback point exists
- what exact command is risky and why
- what minimal local repair you chose instead
