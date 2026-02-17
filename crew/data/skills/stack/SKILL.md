---
name: stack
description: General React/TypeScript/Three.js/R3F conventions and patterns. Load when writing code or making architectural decisions. Project-level context files (AGENTS.md, CONTEXT.md) take precedence over these general conventions.
---

# Stack Conventions -- React / TypeScript / Three.js / R3F

**Note:** These are general conventions. Always check the project root for an
AGENTS.md or CONTEXT.md file first. Project-level conventions override everything
in this file.

## TypeScript

- Strict mode enabled
- Prefer `interface` for object shapes, `type` for unions and utility types
- Explicit return types on exported functions
- No `any` -- use `unknown` and narrow, or define proper types
- Prefer `const` assertions where applicable

<!-- TODO: Add project-specific TS conventions (path aliases, barrel exports, etc.) -->

## React

- Functional components only, no class components
- Custom hooks for reusable logic (prefix with `use`)
- Prefer named exports over default exports
- Props interfaces named `ComponentNameProps`
- Colocate component, styles, and tests in the same directory or nearby

<!-- TODO: Add state management approach (zustand, jotai, context, etc.) -->
<!-- TODO: Add data fetching approach (react-query, SWR, etc.) -->
<!-- TODO: Add routing approach (react-router, next.js, etc.) -->

## Three.js / React Three Fiber

- Use R3F declarative approach -- avoid imperative Three.js where possible
- `useFrame` for animation loops -- always check for delta time
- `useThree` for accessing the Three.js context (camera, renderer, scene)
- Drei helpers for common patterns (OrbitControls, Environment, etc.)
- Dispose of geometries, materials, and textures properly to prevent memory leaks
- Use `React.memo` or `useMemo` for expensive Three.js objects
- Keep the scene graph shallow -- deeply nested groups hurt performance

<!-- TODO: Add specific R3F patterns used in your projects -->
<!-- TODO: Add performance targets (FPS, draw calls, triangle budgets) -->
<!-- TODO: Add shader conventions if using custom shaders -->

## Blender Pipeline

- Export format and conventions for 3D assets

<!-- TODO: Add export format (glTF, GLB, FBX) -->
<!-- TODO: Add naming conventions for meshes, materials, animations -->
<!-- TODO: Add optimization pipeline (decimation, texture atlasing, etc.) -->
<!-- TODO: Add Blender version and addon requirements -->

## Project Structure

<!-- TODO: Define your typical project folder structure, e.g.:
src/
├── components/       # React components
│   ├── ui/           # UI components (buttons, modals, etc.)
│   └── scene/        # R3F scene components (meshes, lights, etc.)
├── hooks/            # Custom React hooks
├── stores/           # State management
├── utils/            # Utility functions
├── types/            # Shared TypeScript types
├── assets/           # Static assets (textures, models, etc.)
└── styles/           # Global styles
-->

## Testing

<!-- TODO: Define your testing framework and approach:
- Unit testing framework: Vitest / Jest
- Component testing: React Testing Library
- E2E testing: Playwright / Cypress
- R3F testing approach (if any)
- Test file naming: *.test.ts / *.spec.ts
- Coverage requirements
-->

## Linting & Formatting

<!-- TODO: Define your linting/formatting setup:
- ESLint config (which preset/plugins)
- Prettier config
- Pre-commit hooks (husky, lint-staged)
- Commands: npm run lint, npm run format
-->

## Dependencies of Note

<!-- TODO: List key dependencies and versions:
- react / react-dom version
- three / @react-three/fiber / @react-three/drei versions
- State management library and version
- Any other critical dependencies
-->
