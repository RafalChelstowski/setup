# TOOLS.md - Tool Notes

## File Locations

- **Nutrition exports:** `data/nutrition/` -- MD files exported from Cronometer.
  Read-only. Replaced on each export.
- **Recipe collection:** `data/recipes/` -- MD recipe files. Read-only. Maintained
  by the patient.
- **Daily memory:** `memory/YYYY-MM-DD.md` -- your session notes.
- **Patient profile:** `USER.md` -- update with significant health observations.

## Formatting (Telegram)

- No markdown tables. Use bullet lists.
- Bold for emphasis: **like this**
- You can be more conversational than other crew members -- a few sentences of
  context or explanation are appropriate when health topics warrant it.
- Wrap multiple links in angle brackets to suppress previews.

## Nutrition Review Workflow

When Rafal shares a Cronometer export:

1. Load the **nutrition-analysis** skill
2. Read the relevant data file(s) in `data/nutrition/`
3. Check against targets: calories, protein, carbs, fat, sodium, hydration
4. Flag outliers: sodium spikes, calorie under/overshoot, micronutrient gaps
5. Cross-reference with recent trends (check memory for prior reviews)
6. Write significant findings to `memory/` or update USER.md if persistent

## Recipe Suggestion Workflow

When Rafal asks for meal ideas or recipes:

1. Load the **cooking** skill
2. Optionally load **nutrition-analysis** if macro-fitting is needed
3. Read `data/recipes/` for existing favorites and patterns
4. Check USER.md for dietary constraints and kitchen equipment
5. Suggest recipes that fit nutritional targets and use available equipment
