# GlassineOS/.github

Organization-wide defaults for GlassineOS repositories:

| Path | Purpose |
|---|---|
| `profile/README.md` | the organization profile page |
| `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, `SECURITY.md`, `SUPPORT.md` | defaults for every repository without its own |
| `ISSUE_TEMPLATE/`, `PULL_REQUEST_TEMPLATE.md` | default issue forms and PR template |
| `scripts/safety-scan.sh` | blocks vendor binaries, dumps, keys and personal data |
| `scripts/install-hooks.sh` | installs the scan as pre-commit and pre-push hooks |
| `.github/workflows/safety-scan.yml` | the scan as a reusable CI workflow |
| `SPECS.md` | how specs, contracts, acceptance and decisions are organised across repositories |
| `speckit-preset/` | the `glassine` Spec Kit preset: organization constitution + spec template |
| `.github/workflows/org-sync.yml` | soft check: submodule and preset up to date |

## Use the safety scan in a repository

Local hooks:

```sh
path/to/GlassineOS/.github/scripts/install-hooks.sh path/to/repo
```

CI (`.github/workflows/safety.yml` in the repository):

```yaml
name: safety
on: [push, pull_request]
jobs:
  safety:
    uses: GlassineOS/.github/.github/workflows/safety-scan.yml@main
    secrets: inherit
```

Per-repository exceptions go in `.safety-scan` at the repository root (see the header
of `scripts/safety-scan.sh`). Every `allow-path` rule needs a reviewed reason in a
comment above it.

## License

Text in this repository: CC-BY-SA-4.0 (`LICENSE`). Scripts: GPL-2.0-or-later (SPDX
headers). `CODE_OF_CONDUCT.md` is the Contributor Covenant 2.1 (CC-BY-4.0).
