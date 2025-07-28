# OpenCode.md

## Repository Structure

This repo contains configuration for multiple tools. Each tool has its own folder and config files:
- `nvim/` : Neovim config (modular, Lua code)
- `atuin/` : Atuin shell history sync (config.toml)
- `sesh/` : Sesh session/project manager (sesh.toml)
- More tools may be added; follow this pattern.

## How to Build / Lint / Test

**Neovim (`nvim/`):**
- Launch: `nvim`
- Lint (current buffer): `:lua require('lint').try_lint()`
- Format: `<leader>f` (Conform plugin)
- Plugin mgmt: `:Lazy`, update with `:Lazy update`
- Health: `:checkhealth`

**Atuin (`atuin/`):**
- Config in `config.toml`. After editing, restart your shell or run `atuin reload` (if available).
- Validate config via Atuin CLI: `atuin --config /path/to/config.toml status` (check Atuin docs).

**Sesh (`sesh/`):**
- Config in `sesh.toml`. Reload/refresh sesh if needed in your shell after changes.

## Code Style & Conventions
- Organize config for each tool within its dedicated folder.
- **Neovim:**
  - Use `require` for Lua module imports, modularize config.
  - Format with stylua (via Conform or CLI).
  - Naming: snake_case for variables/functions, PascalCase tables.
  - Use `pcall` for safe plugin imports. Include mapping docs via `desc`.
- **TOML (atuin/sesh):**
  - Use clear, documented key-value pairs. Add comments for purpose/change if not obvious.

---
Agents: Edit config only in the relevant tool’s folder. Ensure changes are validated using the correct tool/method for each.
