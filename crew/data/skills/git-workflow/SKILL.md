---
name: git-workflow
description: Git branching, commit conventions, PR lifecycle, review iteration, and merge patterns. Load when creating branches, commits, PRs, or handling review feedback.
---

# Git Workflow -- Branch, Commit, PR, Review, Merge

## Branch Naming

Create descriptive branches with a type prefix:

- `feature/particle-system` -- new feature
- `fix/flickering-on-resize` -- bug fix
- `refactor/extract-scene-hook` -- code restructuring
- `chore/update-dependencies` -- maintenance
- `docs/api-reference` -- documentation only

Rules:
- Lowercase, hyphens for spaces
- Short but descriptive -- someone reading the branch name should know what it is
- Always branch from `main` (or whatever the project's default branch is)
- One branch per task. Do not combine unrelated work.

## Commit Conventions

Use conventional commits:

```
feat: add scene export endpoint
fix: resolve flickering in useFrame loop
refactor: extract camera controls into custom hook
chore: update three.js to 0.162
docs: add R3F component API reference
test: add integration tests for export flow
```

Rules:
- **One concern per commit.** Do not mix a feature and a refactor in one commit.
- **Present tense, imperative mood.** "add feature" not "added feature."
- **First line under 72 characters.** Add a blank line and body if more detail
  is needed.
- **Small, frequent commits** are better than one large commit. They make review
  easier and git bisect useful.

## PR Lifecycle

### 1. Create

Before creating the PR:
- All tests pass
- Linter/type checks pass
- Code is committed and pushed to the feature branch

Create with `gh pr create`:
```bash
gh pr create --title "feat: brief description" --body "$(cat <<'EOF'
## Summary
One-line description of what this PR does and why.

## Changes
- Specific change 1
- Specific change 2

## How to Test
1. Verification step 1
2. Verification step 2

## Notes
Decisions made, trade-offs, or open questions.
EOF
)"
```

### 2. Notify

After creating the PR, message the Captain on Telegram:
- PR link
- One-line summary
- Key decisions or questions

Keep it scannable -- the Captain reads on mobile.

### 3. Review Feedback

The Captain reviews from phone/tablet and provides feedback via chat.

When receiving feedback:
- Read all feedback before starting changes
- Ask for clarification if anything is ambiguous
- Make changes as new commits on the same branch (never amend pushed commits)
- Push to the same branch
- Message the Captain: "Updated. Changes pushed." with a brief note of what
  changed

### 4. Iterate

Repeat step 3 until the Captain approves. Each iteration should be a clean
commit or set of commits, not an amend or force-push.

### 5. Merge

**Only when the Captain explicitly says to merge.** Never auto-merge.

Preferred merge strategy: squash merge (combines feature branch commits into
one clean commit on main). Use:
```bash
gh pr merge --squash
```

If the Captain specifies a different merge strategy, follow their preference.

### 6. Clean Up

After merge:
```bash
git checkout main
git pull
git branch -d feature/branch-name
```

## Conflict Resolution

If the feature branch conflicts with main:
1. Rebase onto main: `git fetch origin && git rebase origin/main`
2. Resolve conflicts
3. Push (this is the ONE case where force-push is acceptable:
   `git push --force-with-lease` -- NOT `--force`)
4. Notify the Captain: "Rebased onto main and resolved conflicts in X files."

## PR Size Guidelines

- **Small PRs** (< 200 lines changed): ideal, easy to review on mobile
- **Medium PRs** (200-500 lines): acceptable for a coherent feature
- **Large PRs** (> 500 lines): break into smaller PRs if possible. If not
  possible, explain why in the PR description and suggest a review order.

The Captain reviews from a phone. Small, focused PRs get faster turnaround.

## What NOT to Do

- Never push to main directly
- Never force-push (except `--force-with-lease` after a rebase)
- Never merge without explicit approval
- Never amend a commit that has been pushed
- Never combine unrelated changes in one PR
- Never leave failing tests in a PR
