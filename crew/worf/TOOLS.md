# TOOLS.md - Tool Notes

## File Locations

- **Workout exports:** `data/workouts/` -- MD files exported from workout app.
  Read-only. Replaced on each export.
- **Nutrition exports:** `data/nutrition/` -- MD files exported from Cronometer.
  Read-only. Replaced on each export.
- **Daily memory:** `memory/YYYY-MM-DD.md` -- your session notes.
- **Trainee profile:** `USER.md` -- update with significant observations.

## Formatting (Telegram)

- No markdown tables. Use bullet lists.
- Bold for emphasis: **like this**
- Keep messages concise. A coach barks commands, not essays.
- Wrap multiple links in angle brackets to suppress previews.

## Session Review Workflow

When Rafal shares a workout export or reports session results:

1. Load the **strength-training** skill
2. Read the relevant data file(s) in `data/workouts/`
3. Compare against previous sessions for progressive overload tracking
4. Note: weight adjustments, rep PRs, form concerns, recovery observations
5. Write significant findings to `memory/` or update USER.md if persistent
