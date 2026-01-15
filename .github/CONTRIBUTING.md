# Contributing to EKGF Projects

Thank you for your interest in contributing to the Enterprise Knowledge
Graph Forum (EKGF) projects!

## Getting Started

### Prerequisites

- Python 3.14.2+ with [uv](https://github.com/astral-sh/uv)
- Node.js (for dev tools)
- Git

### Setup

```bash
# Clone the repository
git clone <repo-url>
cd <repo-name>

# Install Python dependencies
uv sync

# Install Node.js dev tools (commitlint, husky, markdownlint)
npm install
```

## Development Workflow

### Branching

- Create feature branches from `main`
- Use descriptive branch names: `feat/add-search`, `fix/login-bug`
- Keep branches focused on a single change

### Making Changes

1. Create a new branch: `git checkout -b feat/your-feature`
2. Make your changes
3. Test your changes locally
4. Commit using the conventions below
5. Push and create a Pull Request

## Commit Message Format

We use **Angular Conventional Commits**. All commits must follow this
format:

```text
<type>(<scope>): <subject>

[optional body]

[optional footer]
```

### Types

| Type       | Description                                      |
| ---------- | ------------------------------------------------ |
| `feat`     | A new feature                                    |
| `fix`      | A bug fix                                        |
| `docs`     | Documentation changes                            |
| `style`    | Code style changes (formatting, no code change)  |
| `refactor` | Code refactoring (no feature or bug fix)         |
| `perf`     | Performance improvements                         |
| `test`     | Adding or updating tests                         |
| `build`    | Build system or dependency changes               |
| `ci`       | CI/CD configuration changes                      |
| `revert`   | Reverting a previous commit                      |

> **Note:** `chore` is NOT allowed in Angular convention.

### Scope

Scope is **required** and should describe the area of change:

- `feat(parser):` - Changes to the parser module
- `fix(ui):` - Bug fix in the UI
- `docs(readme):` - Documentation updates
- `build(deps):` - Dependency updates

### Subject

- Use imperative mood: "add feature" not "added feature"
- No capitalization at the start
- No period at the end
- Keep under 50 characters

### Examples

```bash
# Good
feat(search): add fuzzy matching support
fix(auth): resolve token refresh issue
docs(api): update endpoint documentation
build(deps): update mkdocs-material to 9.7.0

# Bad
feat: Add new feature          # Missing scope, capitalized
fixed(auth): the login bug     # Wrong type, not imperative
chore(deps): update deps       # chore is not allowed
```

### Multi-line Commits

For commits with a body, use a HEREDOC:

```bash
git commit -m "$(cat <<'EOF'
feat(component): add new validation

Add input validation for user forms with:
- Email format checking
- Password strength requirements

Co-Authored-By: Your Name <email@example.com>
EOF
)"
```

## Code Style

### Markdown

- Maximum line length: 70 characters
- Use `-` for unordered lists (not `*` or `+`)
- Use sentence case for headers (not Title Case)
- Add blank lines before and after headers and lists

### Python

- Format with `ruff format`
- Lint with `ruff check`
- Type hints encouraged

## Pull Requests

1. Ensure all tests pass
2. Update documentation if needed
3. Keep PRs focused and reasonably sized
4. Write a clear PR description
5. Reference any related issues

## Pre-commit Hooks

This project uses Husky to run checks on commit:

- **commitlint**: Validates commit message format
- **markdownlint**: Checks Markdown formatting (if configured)
- **ruff**: Lints Python code (if configured)

Do not bypass hooks with `--no-verify`.

## Questions?

- Open an issue for bugs or feature requests
- Join the [EKGF Slack](https://ekgf.slack.com) for discussions
- Visit [ekgf.org](https://ekgf.org) for more information

## License

By contributing, you agree that your contributions will be licensed
under the same license as the project (see LICENSE file).
