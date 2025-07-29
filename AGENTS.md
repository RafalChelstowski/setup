# AGENTS.md
## Repository Structure & Setup
- Holds configs for tools: atuin, nvim, sesh
- Link configs: run `bash setup-links.sh` at repo root
## Build / Lint / Test (nvim)
- Format: `stylua .` & check: `stylua --check .`
- CI formatting: nvim/.github/workflows/stylua.yml
- Tests: none defined (use busted); run all: `busted`; single test: `busted path/to/test.lua:LINE`
## Code Style (Lua)
- Config: nvim/.stylua.toml (indent=2, width=160, quote=AutoPreferSingle, call_parentheses=None)
- Indentation: 2 spaces; no tabs; Unix line endings
- Strings: single quotes preferred; escape as needed
- Imports: `local mod = require("mod")` at top; modules snake_case under lua/
- Naming: snake_case for locals/functions, CamelCase for modules/constants
- Tables: align braces/fields per StyLua defaults
- Error handling: use pcall() or vim.notify(err, vim.log.levels.ERROR)
- Search: use ripgrep/fd per README
## Cursor & Copilot Rules
- No .cursor/rules or .cursorrules present
- No .github/copilot-instructions.md
