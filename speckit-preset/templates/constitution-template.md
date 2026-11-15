# [PROJECT_NAME] Constitution

This repository follows the GlassineOS organization principles (I–VIII). They come from
the `glassine` Spec Kit preset in `GlassineOS/.github` and are not edited per
repository. Repository-specific principles go in the last section.

## Organization principles

### I. Honest framing

GlassineOS is a hobby project, written largely with AI coding agents and not reviewed by
subsystem experts. Every README says so. Pull requests and commit messages state what was
verified and how (host test, emulator, which device and date), and say "untested" where
it applies.

### II. Safety before features

Anything that flashes, partitions, touches the bootloader, recovery, updates or user data
states its failure mode and its escape route before it is implemented. If the escape route
depends on what the change could break, the change needs explicit maintainer approval.
Device-affecting steps never run without the maintainer's go.

### III. Nothing from a device, nothing personal

Nothing copied from a device or from a vendor's own images and updates goes into a
repository, an image or anything we host: partition contents and dumps, display
waveforms, calibration data, modem and DSP images, vendor libraries, vendor-signed
loaders, keys, serial numbers, MAC addresses. What a device needs of that kind is read
from the person's own device when it is needed and stays on it. Firmware that its owner
publishes for redistribution (such as `linux-firmware`) may be part of an image, only as
a package from a distribution's repository, locked like every package and shipped with
its license; no repository commits the files themselves. No decompiler output and no
local paths in any repository. The safety scan must pass.

### IV. Contracts are owned and versioned

Every interface between repositories (protocols, file formats, configuration, D-Bus or
socket APIs) has one owning repository that specifies and versions it. Consumers pin the
version they support and adopt new versions through their own spec. Breaking changes
bump the major version.

### V. Test at the right level

Libraries and daemons test their own behaviour in their own repository (host tests, no
device needed where possible). End-to-end behaviour of the assembled system is specified
and tested only as product acceptance in the `images` repository, as high-level
behavioural scenarios on hardware, never repeating library unit tests.

### VI. Device-neutral by default

No device constants outside device packages and device configuration. Code reads device
facts from configuration so a second device needs no changes outside its own packages.

### VII. E-ink first

Every user-facing change considers refresh cost, ghosting and latency on e-ink. Animations
and continuous redraws need a reason. Latency or power trade-offs are checked by feel on
the device, not by benchmark alone.

### VIII. Upstream and licenses

Our code is GPL-2.0-or-later unless the repository says otherwise; fork commits use the
upstream license. Nothing is submitted upstream unsolicited. AI-assisted commits carry an
`Assisted-by:` or `Co-Authored-By:` trailer; agents never add `Signed-off-by`.

## Repository principles

[REPOSITORY_PRINCIPLES]
<!-- What is specific to this repository: its contracts (owned and consumed, with
     versions), its test strategy, its release cycle, hardware it may touch. -->

## Governance

The organization principles change only in `GlassineOS/.github` (preset version bump);
repositories pick changes up through their `.glassine/org` submodule. Repository
principles change by pull request in this repository. Cross-repository decisions are
recorded as decision records in `GlassineOS/docs`.

Only `spec.md` is committed. It states what a feature does and why, in words that stay
true whatever the code looks like: no languages, modules, routes or other parts of the
implementation. Plans, research, data models, contracts drafted for a plan, and task
lists are working notes for one build. They are not committed, because the code changes
under them and they go stale; pull requests and commit messages record how something was
built and why. An interface other repositories depend on is the exception: it is
specified and versioned by its owner (principle IV).

**Version**: [CONSTITUTION_VERSION] | **Ratified**: [RATIFICATION_DATE] | **Last Amended**: [LAST_AMENDED_DATE]
