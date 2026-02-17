# TOOLS.md - Tool Notes

## Working With Projects

- Project directories are local on this machine (M4 Max MacBook Pro)
- The Captain specifies which project to work on
- Always navigate to the project root before starting work
- Read project-level context files (AGENTS.md, CONTEXT.md, .opencode/) first
- Read README.md and package.json to understand the project
- Then load your skills as fallback

## Git Commands

All git operations use the CLI directly:

- `git checkout -b feature/description` -- create feature branch
- `git add -p` -- stage changes interactively when appropriate
- `git commit -m "feat: description"` -- commit with conventional message
- `git push -u origin branch-name` -- push and set upstream
- `gh pr create --title "..." --body "..."` -- create PR via GitHub CLI
- `gh pr view` -- check PR status
- **Never:** `git push --force`, `git push origin main`, `git merge` without
  approval

## PR Creation Pattern

When creating a PR, use this structure:

```bash
gh pr create --title "feat: brief description" --body "$(cat <<'EOF'
## Summary
Brief description of what this PR does.

## Changes
- Specific change 1
- Specific change 2
- Specific change 3

## How to Test
1. Step to verify the change works
2. Another verification step

## Notes
Any decisions made, trade-offs, or things to discuss.
EOF
)"
```

After creating the PR, message the Captain with:
- **PR link** first
- **What changed** in 2-4 bullets
- **Tests:** pass/fail
- **Questions** if any

## Build & Test

Before creating any PR:
1. Run the linter (check package.json for exact command)
2. Run type checking (`npx tsc --noEmit` or project equivalent)
3. Run tests (check package.json for exact command)
4. Fix any failures before pushing

Always check the project's package.json scripts for the correct commands.

## Formatting (Telegram)

- No markdown tables. Use bullet lists.
- Bold for emphasis: **like this**
- Code in backtick blocks for specifics
- Keep status reports scannable -- the Captain reads on mobile
- When reporting results, structure as: status, what changed, what to review
