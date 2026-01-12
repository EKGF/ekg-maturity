# Angular Style Commit Convention - Quick Reference

## Format

```
<type>(<scope>): <subject>
```

## Rules

✅ **DO**

- Use lowercase for type: `feat`, `fix`, `docs`
- Use lowercase for scope: `auth`, `api`, `ui`
- Use imperative mood: "add" not "adds" or "added"
- Start subject with lowercase letter
- Keep subject under 100 characters
- Omit period at end

❌ **DON'T**

- Capitalize type: ~~`Feat:`~~, ~~`FIX:`~~
- Capitalize subject: ~~`feat: Add feature`~~
- End with period: ~~`feat: add feature.`~~
- Use past tense: ~~`feat: added feature`~~

## Quick Examples

```bash
# Features
feat: add login form
feat(auth): implement OAuth2 flow

# Fixes
fix: resolve navigation bug
fix(button): correct hover state

# Documentation
docs: update README
docs(api): add endpoint descriptions

# Refactoring
refactor: simplify error handling
refactor(api): extract validation logic

# Performance
perf: optimize image loading
perf(homepage): lazy load components

# Build/Dependencies
build: upgrade dependencies
build(deps): update next to 16.1.1

# CI/CD
ci: add commit lint check
ci(github): configure deployment workflow
```

## Type Order (by frequency)

1. `feat` - New features
2. `fix` - Bug fixes
3. `docs` - Documentation
4. `refactor` - Code refactoring
5. `test` - Tests
6. `style` - Formatting
7. `perf` - Performance
8. `build` - Build/dependencies
9. `ci` - CI/CD
10. `chore` - Maintenance
11. `revert` - Revert commits
