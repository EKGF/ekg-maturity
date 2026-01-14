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
gmake info                   # Show environment info (Python, MkDocs versions)
gmake clean                  # Remove site/, .venv/, and lock files
```

The project uses `uv` for Python package management. Dependencies are
defined in `pyproject.toml` and require Python 3.14.2.

## Architecture

### Content structure

- `docs/` - Main documentation source (Markdown files)
- `docs-fragments/` - Reusable content fragments included in other
  docs
- `metadata/` - RDF/Turtle files (`.ttl`) defining the maturity model
  structure

### Maturity model

The model is defined in RDF 1.1 Turtle files under `metadata/`:

- `0-model.ttl` - Base model with 5 maturity levels
- `a-*.ttl` - Business pillar (Strategy Actuation, Model Elaboration,
  Enablers)
- `b-*.ttl` - Organization pillar (Leadership, Product, Delivery,
  Culture, Capabilities)
- `c-*.ttl` - Data pillar (Strategy, Architecture, Quality,
  Governance)
- `d-*.ttl` - Technology pillar (Strategy, Execution, User Interface)

The `docs/generate_maturity_model.py` script uses `ekglib` to parse
these Turtle files and generate documentation pages during build.

### Navigation

Navigation uses the mkdocs-awesome-pages plugin. Each directory can
have a `.pages.yaml` file to control page ordering and titles.

### Key MkDocs plugins

- `material-ekgf` - Custom EKGF theme extensions
- `build_plantuml` - PlantUML diagram rendering
- `include-markdown` - Include content from other files
- `gen-files` - Run Python scripts during build (generates maturity
  model pages)
- `kroki` - Additional diagram support

## Content guidelines

### Markdown formatting

- Maximum line length: 70 characters
- Use `-` for unordered lists (not `*` or `+`)
- Use sentence case for headers (not Title Case)
- Indent nested lists with 2 spaces
- Do not trim trailing whitespace

### YAML/frontmatter

- Use multiline syntax (`>-` or `|`) instead of long quoted strings
- Keep lines under 70 characters

### Markdown linting and formatting

The project uses markdownlint to enforce markdown formatting rules.
Configuration is in `.markdownlint.json`:

- Line length: 70 characters (MD013)
- Code blocks: unlimited line length
- Front matter titles: disabled (MD025)

#### Editor setup

The `.vscode/settings.json` file configures markdownlint to run
automatically on save:

- `markdownlint.run: "onSave"` - Runs linting when files are saved
- `markdownlint.fixOnSave: true` - Auto-fixes issues where possible
- Editor ruler at 70 characters for visual guidance
- Prettier configured for markdown with 70 character width

#### Dev container

The `.devcontainer/devcontainer.json` includes the same settings for
consistent behavior in development containers. The
`DavidAnson.vscode-markdownlint` extension is automatically installed.

#### Manual linting

If using markdownlint-cli directly:

```bash
markdownlint '**/*.md' --ignore node_modules --ignore site
```

## Git workflow

- Commits follow Angular Conventional Commits:
  `<type>(<scope>): <subject>`
- Types: feat, fix, docs, refactor, test, style, perf, build, ci,
  chore, revert
- Use lowercase for type, scope, and subject start
- Never bypass git hooks with `--no-verify`
- Never execute `git push` - user must push manually
- Prefer `git rebase` over `git merge` for linear history
