# CLAUDE.md — GlassineOS/.github

Organization defaults (profile, contribution rules, templates, safety scan). This
repository is public-facing: everything here is read by strangers.

- Keep the honest framing: hobby project, largely AI-written, not expert-reviewed.
  Don't soften or remove the disclaimer.
- Never add device state, lab notes, serial numbers, MAC addresses, local paths or
  vendor material. Run `scripts/safety-scan.sh --staged` before committing.
- Commits carry an `Assisted-by:` or `Co-Authored-By:` trailer. Never add
  `Signed-off-by`.
- Never prepare submissions to upstream projects. Some forbid AI-assisted work
  (e.g. postmarketOS); the policy is "nothing upstream unsolicited".
- Changing `scripts/safety-scan.sh` changes CI for every repository: test it on a
  scratch repository with planted findings (key, MAC, `.bin`, home path) and on a clean
  one before committing.
