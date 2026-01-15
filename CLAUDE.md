# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when
working with code in this repository.

## Project overview

EKG Maturity is the Maturity Model for the Enterprise Knowledge Graph
(EKG). The repository contains Markdown-based documentation that
generates a website at https://maturity.ekgf.org using MkDocs
Material.

## Build commands

```bash
gmake install                # Install all dependencies (brew packages + Python)
gmake docs-build             # Build the static HTML site
gmake docs-serve             # Serve locally with live reload (strict mode)
gmake docs-serve-non-strict  # Serve without strict mode (ignores warnings)
gmake docs-serve-fresh       # Clean PlantUML diagrams then serve
gmake docs-serve-debug       # Serve with verbose output
gmake info                   # Show environment info (Python, MkDocs versions)
gmake clean                  # Remove site/, .venv/, and lock files
```

The project uses `uv` for Python package management. Dependencies are
defined in `pyproject.toml` and require Python 3.14.2.

## Architecture

### Content structure

- `docs/` - Main documentation source (Markdown files)
- `docs-fragments/` - Reusable content fragments included via
  `include-markdown` plugin
- `metadata/` - RDF/Turtle files (`.ttl`) defining the maturity model
  structure
- `docs/diagrams/src/` - PlantUML source files (`.puml`)
- `docs/diagrams/out/` - Generated diagram output (auto-generated)

### Maturity model

The model is defined in RDF 1.1 Turtle files under `metadata/`:

- `0-model.ttl` - Base model with 5 maturity levels (Level 1-5)
- `a-business-pillar.ttl` + `a-1-*.ttl`, `a-2-*.ttl`, `a-3-*.ttl` -
  Business pillar and capability areas
- `b-organization-pillar.ttl` + `b-1-*.ttl` through `b-5-*.ttl` -
  Organization pillar
- `c-data-pillar.ttl` + `c-1-*.ttl` through `c-4-*.ttl` - Data pillar
- `d-technology-pillar.ttl` + `d-1-*.ttl` through `d-3-*.ttl` -
  Technology pillar

The `docs/generate_maturity_model.py` script uses `ekglib` to parse
these Turtle files and generate pages under `docs/pillar/` during
build (via the `gen-files` plugin).

### Navigation

Navigation uses the mkdocs-awesome-pages plugin. Each directory can
have a `.pages.yaml` file to control page ordering and titles. The
main navigation structure is defined in `docs/.pages.yaml`.

### Key MkDocs plugins

- `material-ekgf` - Custom EKGF theme extensions
- `build_plantuml` - PlantUML diagram rendering (server-side)
- `include-markdown` - Include content from `docs-fragments/`
- `gen-files` - Runs `generate_maturity_model.py` during build
- `git-revision-date-localized` - Adds last-updated timestamps

## Content guidelines

### Markdown formatting

- Maximum line length: 70 characters
- Use `-` for unordered lists (not `*` or `+`)
- Use sentence case for headers (not Title Case)
- Indent nested lists with 2 spaces
- Do not trim trailing whitespace (Markdown uses trailing spaces for
  soft line breaks)
- Add blank line before and after headers and lists

### YAML/frontmatter

- Use multiline syntax (`>-` or `|`) instead of long quoted strings
- Keep lines under 70 characters

### Markdown linting

The project uses markdownlint (config in `.markdownlint.json`):

- Line length: 70 characters (MD013)
- Code blocks: unlimited line length
- Front matter titles: disabled (MD025)

Run manually with:

```bash
markdownlint '**/*.md' --ignore node_modules --ignore site
```

## Git workflow

- Commits follow Angular Conventional Commits:
  `<type>(<scope>): <subject>`
- Types: `build`, `ci`, `docs`, `feat`, `fix`, `perf`, `refactor`,
  `revert`, `style`, `test`
- Scope is required (e.g., `feat(parser):`, `fix(ui):`)
- All lowercase, imperative mood, no period at end
- Note: `chore` is NOT allowed in Angular convention
- Never bypass git hooks with `--no-verify`
- Never execute `git push` - user must push manually
- Never commit without explicit user permission
- Prefer `git rebase` over `git merge` for linear history
- Use `git pull --rebase` when pulling remote changes
