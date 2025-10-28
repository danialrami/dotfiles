# Development Standards - Universal Coding Constitution

This document defines coding conventions for this environment. These rules apply regardless of project type, language, or framework.

---

## Project Initialization

### First Steps for New Projects

1. **Detect or establish primary language**:
   ```
   # If existing codebase, detect language distribution
   tokei --output json . | jq '.languages | to_entries | sort_by(-.value.code) | ..key'
   
   # If new project, user specifies language or infer from first file created
   ```

2. **Initialize version control** (if not exists):
   ```
   git init
   git add .
   git commit -m "Initial commit"
   ```

3. **Create essential documentation**:
   - `README.md` - Project overview, setup, usage
   - `CHANGELOG.md` - Version history (start with `## [Unreleased]`)
   - `.gitignore` - Language-specific ignore patterns
   - `.env.example` - Template for environment variables (never commit `.env`)

---

## Language Detection & Consistency

### Determining Project Language

Use `tokei` to detect language distribution:

```
# Install tokei (one-time)
brew install tokei (macOS)
# OR: cargo install tokei

# Get language statistics
tokei
```

**Rules**:
- **Existing projects**: Use the language with most lines of code (LoC)
- **New projects**: Use language specified by user, or first file created
- **Multi-language projects**: Primary language is the one with >50% LoC
- **Stay consistent**: Don't mix languages unless architecturally necessary

### Language-Specific Standards

**Python**:
- 4-space indentation, ~100 char lines
- snake_case for functions/variables, UPPER_CASE for constants
- Docstrings for all public functions
- Use `sys.executable` for subprocess Python calls (never hardcoded `"python3"`)

**JavaScript/TypeScript**:
- 2-space indentation, ~100 char lines
- camelCase for variables/functions, PascalCase for classes
- JSDoc comments for public APIs
- Use `npm` or `pnpm` consistently (not both)

**Go**:
- Use `gofmt` (automatic formatting)
- PascalCase for exported names, camelCase for unexported
- Avoid `panic()` except in initialization code

**Rust**:
- Use `cargo fmt` (automatic formatting)
- snake_case for everything except types (PascalCase)
- `unwrap()` only in examples/tests, use `?` operator in production

**Shell (Bash)**:
```
#!/bin/bash
set -euo pipefail  # ALWAYS use strict mode
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE}")" && pwd)"
```

---

## Documentation & Knowledge Management

### Before Writing Code

**ALWAYS check documentation first using MCP tools**:

1. **Context7 MCP Server** (preferred - structured docs):
   ```
   Use context7 tool to search official documentation
   ```
   - For: React, Vue, Python stdlib, TypeScript, Rust std, etc.
   - Provides versioned, accurate API documentation
   - Example: "Search context7 for React useState hook"

2. **BrowserOS MCP Server** (fallback - web scraping):
   ```
   Use browserOS tool to navigate and extract from web docs
   ```
   - For: Framework docs not in Context7, blog posts, Stack Overflow
   - When Context7 doesn't have the library/framework
   - Example: "Navigate to Next.js 15 docs and summarize App Router"

**Rule**: If documentation exists, **read it before implementing**. Don't guess at API signatures or best practices.

---

## Testing Strategy

### Language-Specific Testing

**Python**:
```
# Use pytest exclusively (never bash test runners)
pytest tests/module_name/ -v     # Run by subdirectory to avoid timeouts
pytest -k "test_specific" -v     # Run specific test
pytest --cov=src tests/ -v       # With coverage
```

**JavaScript/TypeScript**:
```
# Use Jest or Vitest
npm test                         # Run all tests
npm test -- module.test.ts       # Run specific file
npm test -- --watch              # Watch mode
```

**Go**:
```
go test ./...                    # All packages
go test ./pkg/module -v          # Specific package
go test -cover ./...             # With coverage
```

**Rust**:
```
cargo test                       # All tests
cargo test module_name           # Specific module
cargo test --release             # Optimized (for benchmarks)
```

### Testing Conventions

- **Timeout prevention**: Run tests by subdirectory/module, not entire suite at once
- **Mock external dependencies**: APIs, databases, file systems
- **Clear assertions**: Each test should have obvious pass/fail criteria
- **Test naming**: `test_<function>_<scenario>_<expected>`
  - Example: `test_parse_config_missing_file_returns_default()`

---

## Version Control & Commits

### Atomic Commits

Every commit should be **atomic** - one logical change.

**Good commits**:
```
feat: Add user authentication endpoint
fix: Resolve race condition in worker pool
docs: Update API examples in README
refactor: Extract validation logic to separate module
```

**Bad commits**:
```
misc changes
WIP
updates
fixed stuff
```

### Commit Message Format

```
<type>: <subject>

[optional body]

[optional footer]
```

**Types**:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only
- `refactor`: Code restructuring (no behavior change)
- `test`: Adding/updating tests
- `chore`: Tooling, dependencies, config

**Example**:
```
feat: Add PostgreSQL connection pooling

Implement connection pool with configurable size and timeout.
Uses pgx pool for efficient connection reuse.

Resolves #42
```

### Changelog Updates

**ALWAYS** update `CHANGELOG.md` after every commit:

```
## [Unreleased]

### Added
- PostgreSQL connection pooling (commit abc123)
- User authentication endpoints (commit def456)

### Fixed
- Race condition in worker pool (commit ghi789)
```

**Format**:
```
- <Description> (commit <hash>)
```

Get commit hash:
```
git log --oneline -1  # Shows: abc123 feat: Add feature
```

---

## Error Handling

### Universal Pattern

**Python**:
```
try:
    result = risky_operation()
except SpecificError as e:
    logger.warning(f"⚠️  Expected failure: {e}")
    result = fallback_value
except Exception as e:
    logger.error(f"❌ Unexpected error: {e}\n{traceback.format_exc()}")
    result = fallback_value
```

**JavaScript/TypeScript**:
```
try {
  const result = await riskyOperation();
} catch (error) {
  if (error instanceof SpecificError) {
    console.warn(`⚠️  Expected failure: ${error.message}`);
  } else {
    console.error(`❌ Unexpected error: ${error.message}`);
    console.error(error.stack);
  }
}
```

**Go**:
```
result, err := riskyOperation()
if err != nil {
    // Wrap errors for context
    return fmt.Errorf("operation failed: %w", err)
}
```

**Rust**:
```
let result = risky_operation()
    .context("Operation failed")?;  // anyhow crate
```

**Rules**:
- **Catch specific errors first**, generic last
- **Always log errors** with context
- **Never silent failures** - log or propagate
- **Use emoji for visibility**: ⚠️ for expected, ❌ for unexpected

---

## Security & Credentials

### Environment Variables

**Never commit**:
- API keys
- Passwords
- Tokens
- Connection strings
- Private keys

**Always**:
1. Create `.env.example` with dummy values:
   ```
   API_KEY=your_api_key_here
   DATABASE_URL=postgresql://user:pass@localhost/db
   ```

2. Add `.env` to `.gitignore`:
   ```
   echo ".env" >> .gitignore
   ```

3. Load environment variables in code:
   ```
   # Python
   from dotenv import load_dotenv
   load_dotenv()
   
   # JavaScript
   import 'dotenv/config';
   ```

---

## Code Review Checklist

Before committing, verify:

- [ ] Code follows language-specific style guidelines
- [ ] Tests added/updated and passing
- [ ] Documentation updated (README, CHANGELOG)
- [ ] No credentials or secrets in code
- [ ] Error handling implemented
- [ ] Commit message follows format
- [ ] CHANGELOG.md updated with commit hash

---

## Tool Installation

### Required Tools

**Language Detection**:
```
cargo install tokei
# OR: brew install tokei
```

**Testing** (language-specific):
```
# Python
pip install pytest pytest-cov

# JavaScript
npm install -D jest @types/jest

# Go (built-in)
go test -h

# Rust (built-in)
cargo test -h
```

---

## Quick Reference

### New Project Setup
```
# 1. Detect/establish language
tokei .  # Or specify via first file

# 2. Initialize git
git init && git add . && git commit -m "Initial commit"

# 3. Create docs
touch README.md CHANGELOG.md .gitignore .env.example

# 4. Add to CHANGELOG
echo "## [Unreleased]" >> CHANGELOG.md

# 5. Commit docs
git add . && git commit -m "docs: Add project documentation"
```

### Making Changes
```
# 1. Check docs (Context7 or BrowserOS MCP)
# 2. Write code
# 3. Write/update tests
# 4. Run tests
# 5. Update CHANGELOG with commit hash
# 6. Commit atomically
# 7. Verify commit message format
```

---

## Additional Standards to Consider

Some other important conventions I'd suggest adding:

1. **Dependency Management**:
   - Pin exact versions in lock files
   - Document why each major dependency is needed
   - Audit for security vulnerabilities regularly

2. **Performance**:
   - Profile before optimizing
   - Document performance requirements
   - Add benchmarks for critical paths

3. **Logging**:
   - Use structured logging (JSON) in production
   - Include request IDs for tracing
   - Log levels: DEBUG, INFO, WARN, ERROR

4. **API Design**:
   - REST: Follow HTTP semantics (GET = idempotent, etc.)
   - GraphQL: Use nullable fields appropriately
   - Versioning: `/api/v1/` in path

5. **Database Migrations**:
   - Never modify existing migrations
   - Always reversible (up/down)
   - Test on copy of production data

6. **CI/CD**:
   - All tests must pass before merge
   - Automated formatting checks
   - Dependency vulnerability scanning

