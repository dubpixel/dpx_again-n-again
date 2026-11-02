# dpx Agent Workflow & Documentation Standards - v1d6

This document provides operational directives for AI coding assistants (GitHub Copilot, Claude Code, Cursor, etc.) working on dubpixel projects. These rules ensure consistent workflow automation, code quality, and documentation maintenance across all repositories.

---

## PROJECT: dpx_again-n-again

**Status:** v0.1.0 (2026-11-02) 🚧  
**Branch:** `main`  
**Version File:** `VERSION` (currently 0.1.0)

### Architecture (2-minute summary)

macOS droplet. Drag any installed app onto `AgainNAgain.app` and it writes `<Name>Again.app` into `~/Applications`: a shell-script-in-an-app that runs `open -n` so every launch is a NEW instance (macOS refuses a second copy of a running app otherwise). If the dropped app's name ends in a version number, the launcher searches for the highest installed `Name <version>.app` (`sort -V`) instead of hardcoding a path. Successor to dpx_tr_again (single-purpose Tessera Remote launcher). Pure AppleScript + POSIX `sh`, no dependencies.

| Component | Tech/Location | Purpose | Notes |
|-----------|---------------|---------|-------|
| Droplet | AppleScript / `src/droplet.applescript` | Receives dropped apps, calls the generator | Compiled by `osacompile`; `on open` handles drops |
| Generator | `sh` / `src/make-again.sh` | Builds `<Name>Again.app` (launcher, Info.plist, borrowed icon) | Source of truth for launcher template; also usable from the CLI |
| Build | `sh` / `build.sh` | Compile droplet, bundle generator, **re-sign ad-hoc**, zip + dmg into `dist/` | `dist/` is git-ignored |
| Installer | `sh` / `install.sh` | Build + install locally (no quarantine); `curl \| sh` friendly | Fetches sources from `main` when piped |

### Agent Rules (for this repo)

- Branch from `main`, bump `VERSION`, tag the merge commit (tag after merge so release archives contain the change)
- After editing the droplet or generator, run `./build.sh`; test the generator against FAKE apps in a scratch dir
- Do not write test launchers into the real `~/Applications` without cleaning them up
- Confirm README changes with the user before committing

### Critical Constraints

**DO NOT:**
- ❌ Name generated launchers with spaces (`SomeAppAgain`, not `Some App Again`): it must never match its own search pattern
- ❌ Drop `-n` from `open`
- ❌ Skip the ad-hoc re-sign in `build.sh` after editing the plist/resources (Apple Silicon)
- ❌ Embed names with quotes/`$`/backticks in a generated script (the generator refuses them)

### Key Decisions

- **Droplet is AppleScript, generator is shell:** a pure shell app cannot receive files dropped on its icon; AppleScript's `on open` can, and delegates the real work to testable `sh`.
- **Generated locally:** a launcher created on the user's Mac is never quarantined.
- **Borrow the target's icon:** copied from the wrapped app's `CFBundleIconFile`.

### Gotchas & Landmines

1. **Gatekeeper:** the droplet itself is unsigned (ad-hoc only); a downloaded copy is quarantined. README documents `Open Anyway` / `xattr -dr com.apple.quarantine`; `install.sh` avoids it.
2. **Trademark:** wrapped apps' names belong to their owners; keep the unaffiliated disclaimer.

---
## 0. Mid-Session Issue Triage (MANDATORY)
**Default: log it, don't fix it mid-session.**

- If something broken or wanted comes up, file a GitHub issue and move on
- Only fix immediately if you explicitly say *"fix this"* or *"fix it now"*
- Start of session: `gh issue list --repo <owner>/<repo>`
- End of session: `gh issue create --repo <owner>/<repo> --title "..." --body "..."`

The rationale: prevents mid-session context-switching that breaks working code.

## 1. Automatic Workflow (MANDATORY)

These actions are **required** and must happen automatically. **NEVER ask permission** for these workflow steps.

### Branching Strategy

**BEFORE starting ANY code changes:**

1. Create a new branch from the default branch (master/main)
2. Never work directly on default branch
3. Branch naming conventions:

| Type | Format | Example |
|------|--------|---------|
| New feature | `feature/brief-description` | `feature/mqtt-decoder` |
| Bug fix | `fix/issue-description` | `fix/telegraf-timeout` |
| Documentation | `docs/what-changed` | `docs/update-architecture` |
| Refactor | `refactor/component-name` | `refactor/docker-volumes` |

### Version Bumping

**BEFORE the first code change:**

Bump the version number according to semantic versioning:

| Change Type | Version Bump | Example |
|-------------|--------------|---------|
| Bug fix, typo fix, documentation update | Patch (0.0.X) | 1.2.3 → 1.2.4 |
| New feature, new endpoint, new capability | Minor (0.X.0) | 1.2.3 → 1.3.0 |
| Breaking change, API removal, incompatible change | Major (X.0.0) | 1.2.3 → 2.0.0 |

#### Semantic Versioning Principles

**Format:** `MAJOR.MINOR.PATCH` (e.g., `2.4.7`)

- **MAJOR**: Incompatible API changes, breaking existing functionality
- **MINOR**: New functionality added in a backwards-compatible manner  
- **PATCH**: Backwards-compatible bug fixes, docs, typos

**Pre-1.0 versions (0.x.y):**
- Anything goes - breaking changes allowed in minor bumps
- Common for projects in initial development
- Move to 1.0.0 when API is stable and production-ready

**Pre-release versions:**
- Alpha: `1.0.0-alpha.1` (early testing, unstable)
- Beta: `1.0.0-beta.2` (feature-complete, testing for bugs)
- Release Candidate: `1.0.0-rc.1` (final testing before release)

#### Version Bumping Decision Tree

**When multiple changes occur, use the highest level:**
- Bug fix + new feature → Minor bump (not patch)
- New feature + breaking change → Major bump (not minor)

**Edge cases:**

| Scenario | Bump Type | Reasoning |
|----------|-----------|-----------|
| Internal refactor, no API change | Patch | No external impact |
| New optional parameter with default | Minor | Backwards-compatible addition |
| Changed parameter order | Major | Breaks existing calls |
| Deprecated feature (still works) | Minor | Deprecation warning added |
| Removed deprecated feature | Major | Functionality removed |
| Performance improvement | Patch | Implementation detail |
| New dependency added | Minor | Expands capabilities |
| Security fix | Patch | Even if behavior changes slightly |
| Database schema change | Major | Requires migration |
| Config file format change | Major | Breaking existing configs |

#### Version Bump Workflow

1. **Determine bump type** based on changes planned
2. **Update version number** in code/config files
3. **Create git commit**: `bump version to X.Y.Z`
4. **Tag the commit**: `git tag vX.Y.Z` (note the `v` prefix)
5. **Push with tags**: `git push && git push --tags`
6. **Update CHANGELOG** (if present) with version and changes
7. **Proceed with feature/fix implementation**

**Version commit should be standalone** - don't mix version bump with other changes.

#### Changelog Integration

If project has CHANGELOG.md, update it with version bump:

```markdown
## [1.2.0] - 2026-02-13

### Added
- New feature description

### Fixed
- Bug fix description

### Changed
- Breaking change description
```
**If no CHANGELOG.MD file exists:** Create one in the root of the project.

**Where to bump version:**
- Python: `__version__` in `__init__.py` or `pyproject.toml`
- Node.js: `version` field in `package.json`
- General: `VERSION` file or constant in main entry point
- Docker: Version tag in `docker-compose.yml` or `Dockerfile` labels

**If no version file exists:** Create one in an appropriate location for the project.

### Version File Standards & Location

To ensure consistent version identification across projects, follow these standards:

#### Python Projects

**Preferred location: `app/__init__.py` or `src/__init__.py`**

```python
"""Project description."""

__version__ = "1.0.0"
__author__ = "dubpixel"
```

**Alternative: `pyproject.toml` (for modern Python packaging)**

```toml
[project]
name = "project-name"
version = "1.0.0"
```

**Alternative: `VERSION` file in project root**

```
1.0.0
```

Then read it in your module:
```python
from pathlib import Path
__version__ = (Path(__file__).parent / "VERSION").read_text().strip()
```

#### Node.js/JavaScript Projects

**Location: `package.json`** (standard)

```json
{
  "name": "project-name",
  "version": "1.0.0",
  "description": "Project description"
}
```

#### Docker Projects

**Location: `docker-compose.yml` labels AND `Dockerfile`**

`docker-compose.yml`:
```yaml
services:
  app:
    build: .
    labels:
      - "org.opencontainers.image.version=1.0.0"
      - "org.opencontainers.image.created=${BUILD_DATE}"
```

`Dockerfile`:
```dockerfile
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.title="Project Name"
```

#### Bash Scripts/Utilities

**Location: Top of main script or separate `VERSION` file**

```bash
#!/bin/bash
VERSION="1.0.0"
SCRIPT_NAME="manage.sh"

# Or read from VERSION file:
# VERSION=$(cat VERSION)
```

#### Version Display (REQUIRED)

**Always provide a way to display the version:**

- Python CLI: `python -m myapp --version`
- Node.js: `npm run version` or built into CLI
- Docker: `docker inspect <image> | grep version`
- Bash: `./script.sh --version`

**Example implementations:**

```python
# In your main.py or CLI entry point
import argparse
from app import __version__

parser = argparse.ArgumentParser()
parser.add_argument('--version', action='version', version=f'%(prog)s {__version__}')
```

```bash
# In bash script
if [[ "$1" == "--version" ]] || [[ "$1" == "-v" ]]; then
    echo "$SCRIPT_NAME version $VERSION"
    exit 0
fi
```

#### Multi-Component Projects

For projects with multiple components (e.g., frontend + backend + Docker):

1. **Synchronized versioning**: All components share the same version
2. **Central `VERSION` file** in project root
3. **Scripts/tools read from central file**

Example structure:
```
project-root/
├── VERSION              # 1.0.0
├── backend/
│   └── __init__.py      # Reads ../VERSION
├── frontend/
│   └── package.json     # Reads ../VERSION via build script
└── docker-compose.yml   # Reads VERSION via envsubst or build args
```

### Pull Request Creation

**AFTER completing the task:**

Create a pull request with this format:

```markdown
## Changes
- [Brief list of what changed]
- [One item per significant change]

## Testing
- [How to verify the changes work]
- [Commands to run or steps to follow]

## User Prompt
[The original request from the user - verbatim]
```

**PR Title Format:** `[Component] Brief description`

Examples:
- `[MQTT] Add BLE decoder support`
- `[Docs] Consolidate architecture documentation`
- `[Telegraf] Fix enum processor deprecation`

**NEVER ask permission to create the PR - just do it.**

### Build Artifact Naming Convention

Non-`main` builds append the branch slug to the filename so artifacts are
self-identifying without opening the run log.

| Branch | Filename |
|--------|----------|
| `main` | `<name>-vX.Y.Z.<ext>` |
| anything else | `<name>-vX.Y.Z-<branch-slug>.<ext>` |

```bash
if [ "$BRANCH" = "main" ]; then
  OUT="myapp-v${VERSION}.ext"
else
  BRANCH_SLUG=$(echo "$BRANCH" | sed 's|/|-|g' | sed 's|[^a-zA-Z0-9._-]|-|g')
  OUT="myapp-v${VERSION}-${BRANCH_SLUG}.ext"
fi
```


## 2. Progress Tracking for Multi-Step Work

When working on tasks that span **more than 3 files** OR **more than 30 minutes of work**:

### Checkpoint Progress

Provide a status update using this template:

```markdown
## Progress Checkpoint

✅ **Completed:**
- Item 1 description
- Item 2 description

⬜ **Remaining:**
- Item 3 description
- Item 4 description

→ **Next Action:** [Specific next step you will take]
```

### When to Checkpoint

- After completing a logical phase of work
- Before switching to a different component
- When encountering a blocker or decision point
- Every 3-5 file edits in large refactors

### Resuming from Checkpoint

When continuing work after a checkpoint:
1. Read the last checkpoint status
2. Start with the "Next Action" item
3. Update checkpoint when that phase completes

**Purpose:** Prevents agents from getting lost in complex multi-step tasks and provides visibility to the user.

---

## 3. File Header Standards

All code files must include a comprehensive header comment section:

```
# ================================================================================
# [FILE TYPE] - [FILE PURPOSE]
# ================================================================================
# you can maybe write some stuff here - tagline etc.
# ================================================================================
# PROJECT: [project_name]
# ================================================================================
#
# File: [filename]
# Purpose: [what this file does]
# Dependencies: [key dependencies if any]
#
# CHANGE LOG: (if needed but should really be in the changelog for the git)
# 
# 2026-03-06: Complete rewrite - Interactive wizard (v2.1.0)
#
# ================================================================================
```

### Header Guidelines

- Use consistent separator lines (80 characters of `=`)
- Adjust comment syntax for the language (`#` for Python/bash, `//` for JS/C++, etc.)


---

## 4. Documentation Standards

### Project Context Documentation

Project-specific architecture, decisions, and operational knowledge should live in the **PROJECT section at the top of this file**. This keeps rules and context unified in one scannable document.

**When to use a separate CONTEXT.md:**
Only create a separate `CONTEXT.md` if reference data becomes large enough to be noisy:
- Long IP/VLAN tables
- Full API response examples  
- Hardware pinout references
- Extensive data schemas

If you create CONTEXT.md for overflow, add a reference in the PROJECT section at the top: "See CONTEXT.md for full network topology."

### How to Document Project Context

**DO:**
- ✅ Keep it clean, factual, and scannable
- ✅ Update when architecture changes
- ✅ Add information when you learn important project details
- ✅ Use tables, code blocks, and clear headings
- ✅ Think: "What does the next agent need to know?"
- ✅ Write in present tense, authoritative voice

**DON'T:**
- ❌ Append conversation transcripts
- ❌ Include timestamps like "On Feb 12 we discussed..."
- ❌ Make it a session log or diary
- ❌ Duplicate content from README.md (link instead)
- ❌ Let it become verbose or messy

**Update frequency:** Whenever you make architectural changes or learn critical project information.

---

## 5. Core Principles


### No Modifications to Working Code

- Do not refactor, optimize, or "improve" code that is working unless explicitly requested
- Avoid drive-by refactors when implementing a feature
- If you see potential improvements, mention them but don't implement without approval

### Comprehensive Commenting

- Document all code with clear, meaningful comments
- Preserve existing comments unless they become obsolete
- Remove or update comments that are no longer accurate
- Document WHY, not just WHAT (the code shows what, comments explain why)

### Small, Incremental Changes

- Make one logical change per commit
- Break large tasks into smaller steps
- Test each change before moving to the next
- Make it easy to review and roll back if needed

### Stay Focused

- Complete the current task before suggesting next steps
- Answer only what is asked
- Don't anticipate or propose additional work unless requested

### Document Everything

- README.md must be updated and maintaned when appropriate as per these guidelines
- CONTEXT.md must be updated and maintaned when appropriate as per these guidelines
- a comprehensive CHANGELOG.md must be kept updated and maintaned when appropriate as per these guidelines
- you can maintain a small changelog in the header if you wish but main changelog should be in the MD

---

## 6. Documentation Standards

### Inline Documentation

- Maintain comprehensive inline documentation
- Update comments when code changes (keep them in sync)
- Document all function parameters and return values
- Include usage examples for complex functions
- Explain algorithms and business logic


### README Files

- Keep README.md current and accurate
- README is user-facing - focus on how to USE the project
- **Confirm all changes to README with the user before committing**
- README should not duplicate CONTEXT.md (different audiences)

### CHANGELOG.MD

- Keep CHANGELOG.md current and accurate
- CHANGELOG is user-facing - focus on changes, version numbers, dates and git hashes if needed
- **keep this automated in background**
- changelog could be retroactively updated to reflect git commit names if that adds clariy
- **any changes to existing changelog line items should be confirmed with user**

### Markdown Style

- Use consistent heading hierarchy (don't skip levels)
- Use tables for structured information
- Include code blocks with language tags
- Use relative links to other project files
- Keep line length reasonable (~80-100 chars for prose)

---

## 7. Code Quality Guidelines

### General Principles

- Write clear, readable code with meaningful names
- Follow established coding patterns within the project
- Implement proper error handling (don't use bare `except:` or `catch`)
- Write testable code with clear interfaces
- Maintain consistent formatting and style

### Language-Specific

Agents should infer and follow the conventions of the language they're working in:
- Python: Follow PEP 8
- JavaScript: Follow project's ESLint config if present
- Bash: Follow Google Shell Style Guide principles
- Other languages: Use community-standard style guides

### Testing

- Add tests alongside new logic when appropriate
- Use deterministic inputs for tests (inject time/randomness, don't read system state)
- Name tests by behavior (e.g., `test_early_finish_extends_break`)
- Include both positive and negative test cases
- if the process includes: using ssh into a remote server, or user input in any way. open a terminal first for the user so you both can read it. 

---

## 8. Change Management

### Commit Practices

- **Commit message format:** Short, plain English, lowercase verb
  - Examples: `add mqtt decoder`, `fix telegraf config`, `update documentation`
- Make one logical change per commit
- Commit functional units (don't commit broken code)

### Before Committing

- Verify the code works (run/test it)
- Update all relevant documentation
- Update file change logs
- Remove debug code and console.log/print statements
- Check that no credentials or secrets are included

### After Committing

- Push to the feature branch
- Create PR (as described in Section 1)
- Include verification steps in PR description

---

## 9. Collaboration Standards

### Respect Existing Architecture

- Understand existing architectural decisions before changing them
- Ask for clarification when requirements are ambiguous
- Suggest alternatives when appropriate, but don't insist
- Consider the impact of changes on the broader codebase

### Maintain Backwards Compatibility

- Don't break existing APIs unless explicitly requested
- Provide migration paths for breaking changes
- Document any compatibility changes in PR description

### Communication

- Explain the reasoning behind suggested changes
- Provide rollback information when making significant changes
- Be transparent about limitations or uncertainties
- Keep responses concise and focused

---

## 10. Configuration & Secrets

### Environment Variables

- Use `.env` files for local development
- Provide `.env.example` with all required variables (use placeholder values)
- **NEVER commit** `.env` files or actual credentials to git
- Document all environment variables in CONTEXT.md or README.md

### Sensitive Data

- Keep credentials in environment variables, not hardcoded
- Use service account files in standard locations (e.g., `~/.config/gcloud/`)
- Add sensitive files to `.gitignore` immediately
- If secrets are accidentally committed, notify the user immediately

---

## Summary: Agent Checklist

Before starting work:
- [ ] Create feature branch
- [ ] Bump version appropriately

While working:
- [ ] Follow file header standards
- [ ] Update change logs in modified files
- [ ] Keep changes small and focused
- [ ] Checkpoint progress if task is large
- [ ] Update PROJECT section if architecture changes

After completing work:
- [ ] Test/verify the changes
- [ ] Update relevant documentation
- [ ] Create PR with proper format
- [ ] No credentials committed

---

*These standards ensure consistent, high-quality AI assistance across all Dubpixel projects.*
