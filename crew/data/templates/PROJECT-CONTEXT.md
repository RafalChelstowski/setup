# Project Context Template

Copy this file to your project root as `AGENTS.md` or `CONTEXT.md`.
Data reads this file when entering a project. It takes precedence over his
general stack skill.

Delete sections that don't apply. Fill in what matters for your project.

---

# Project: [Name]

## Description

One-line description of what this project does.

## Tech Stack

- **Framework:** React / Next.js / Vite / other
- **Language:** TypeScript (strict: yes/no)
- **3D:** Three.js + React Three Fiber + Drei (if applicable)
- **State:** zustand / jotai / context / redux / other
- **Data fetching:** react-query / SWR / fetch / other
- **Routing:** react-router / next.js / other
- **Styling:** tailwind / css modules / styled-components / other

## Project Structure

```
src/
├── components/
├── hooks/
├── ...
```

## Commands

- **Dev:** `npm run dev`
- **Build:** `npm run build`
- **Test:** `npm test`
- **Lint:** `npm run lint`
- **Type check:** `npx tsc --noEmit`

## Conventions

- Naming: [component naming, file naming, variable naming]
- Exports: [named vs default]
- Testing: [framework, patterns, file location]
- State: [where state lives, patterns for shared state]

## Known Gotchas

- [Any project-specific quirks Data should know about]

## Current Focus

- [What's being actively worked on -- update as priorities shift]

## Off Limits

- [Files or areas Data should not modify without asking]
