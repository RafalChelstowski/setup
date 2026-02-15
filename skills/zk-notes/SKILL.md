---
name: zk-notes
description: Search, read, and create markdown notes from the personal knowledge base. Use when looking for reference docs, project notes, or prior decisions.
---

# zk-notes - Personal Knowledge Base

Search and manage markdown notes indexed by zk via the zk MCP server.

## When to use (trigger phrases)

- "check my notes for..."
- "do I have any notes about..."
- "find related notes"
- "create a note about..."
- "what did I write about..."
- "search my knowledge base"

## Available MCP tools

### get_note_paths (default, start here)

Search for notes by content or tags.

- `include_str`: keyword search (fast, always prefer this first)
- `include_str_operand`: `AND` or `OR` for multiple keywords
- `exclude_str`: exclude notes containing specific strings
- `include_tags` / `exclude_tags`: filter by tags
- `include_tags_operand`: `AND` or `OR` for multiple tags
- Returns file paths -- use `get_note` to read content

### get_note

Read the complete content of a specific note by path.

### get_linking_notes

Discover note relationships:

- `link_to_notes`: outbound links from a note
- `linked_by_notes`: backlinks to a note (who references this)
- `related_notes`: notes sharing links but not directly connected

### get_tags

List all available tags in the notebook.

### create_note

Create a new note with title and optional directory.

**CRITICAL:** Notes MUST be created in the `~/md` directory or its subfolders only. Use the `directory` parameter to specify subfolders within ~/md (e.g., `daily`, `projects`, `ideas`). Never create notes outside the ~/md folder hierarchy.

## Default behavior

1. Always start with `get_note_paths` using `include_str` for keyword search
2. Only read full notes (`get_note`) when the path looks relevant to the query
3. Do not read all results -- pick the most relevant 1-3 paths
4. Use `get_linking_notes` only for relationship/context queries
5. When creating notes, use descriptive titles and add relevant tags in frontmatter
6. **ALWAYS create notes in the ~/md directory** - use subfolders like `daily/`, `projects/`, `ideas/` via the `directory` parameter
7. Prefer searching over guessing -- the knowledge base may have relevant context
