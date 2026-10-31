# Specs and decisions across GlassineOS repositories

GlassineOS uses [Spec Kit](https://github.com/github/spec-kit) (pinned to **1.1.0**) per
repository, with one organization preset (`speckit-preset/`, id `glassine`) that provides
the shared constitution and spec template.

## What goes where

| Kind | Where | Tool |
|---|---|---|
| Organization principles | `GlassineOS/.github` → `speckit-preset/templates/constitution-template.md` | the `glassine` preset |
| Repository principles | each repository's `.specify/memory/constitution.md`, last section | `/speckit-constitution` |
| Feature work in one repository | that repository's `specs/###-name/` (spec, plan, tasks) | `/speckit-specify` → `plan` → `tasks` → `implement` |
| Interface contracts (protocols, formats, APIs) | the **owning** repository's specs; consumers pin a version | spec + version |
| Bug fixes | the affected repository | Spec Kit `bug` extension, or a plain issue |
| Investigations (hardware faults, research) | issues and the lab notebook until they become a feature or fix | no spec flow |
| End-to-end behaviour of the whole system | `GlassineOS/images` acceptance suite (behavioural scenarios on hardware) | spec + test |
| Decisions spanning repositories | `GlassineOS/docs/decisions/` | decision records |
| Tasks across repositories | issues in the organization project, referencing requirement IDs (`FR-001`) | GitHub Projects; `/speckit-taskstoissues` turns a tasks.md into issues |

## Setting up a repository

```sh
# the organization defaults, pinned
git submodule add https://github.com/GlassineOS/.github .glassine/org

# Spec Kit 1.1.0 from its git tag (this version is not on PyPI), with the org preset
# installed at init so the constitution starts from the organization template
uvx --from git+https://github.com/github/spec-kit.git@v1.1.0 specify init --here --force \
    --integration claude --script sh --preset .glassine/org/speckit-preset

# safety hooks from the same pinned checkout
.glassine/org/scripts/install-hooks.sh .
```

Commit `.specify/` (except what its own `.gitignore` excludes) and `.claude/skills/speckit-*`.
Add the line `@.glassine/org/AGENTS.md` to the repository's `CLAUDE.md`: it imports the
organization guidance for coding agents (project knowledge search).
Then run `/speckit-constitution` once and fill only the repository section.

## Keeping up to date

- **Dependabot** opens a pull request when `GlassineOS/.github` moves on
  (`.github/dependabot.yml`):

  ```yaml
  version: 2
  updates:
    - package-ecosystem: gitsubmodule
      directory: /
      schedule:
        interval: weekly
  ```

- **The `org-sync` check** (reusable workflow) warns when the submodule is behind
  `GlassineOS/.github` main, the installed preset version differs from the submodule's, or
  `CLAUDE.md` lacks the `@.glassine/org/AGENTS.md` line.
  It warns; it doesn't fail the build.

  ```yaml
  jobs:
    org-sync:
      uses: GlassineOS/.github/.github/workflows/org-sync.yml@main
      secrets: inherit
  ```

- After a submodule update:
  `uvx --from git+https://github.com/github/spec-kit.git@v1.1.0 specify preset update glassine --dev .glassine/org/speckit-preset`.

`GlassineOS/.github` is public, so CI reads it with the default token. The
workflows still accept an optional `GLASSINE_ORG_READ` secret (read-only token) for a
caller that ever needs to read a private organization repository; none uses it today.

Verified 2026-10-03 with Spec Kit 1.1.0 and the Claude integration: `init --preset`
materializes the organization constitution, `specify preset resolve` returns the
`glassine` templates as the top layer, the registry lives in `.specify/presets/.registry`.
