# GlassineOS

**A Linux distribution for Boox e-ink tablets, built on Alpine Linux.**

GlassineOS replaces the vendor Android on Onyx Boox devices with a mainline Linux
kernel, an e-ink display engine written for these panels, and a touch- and pen-first
desktop: a tiling Wayland session, an on-screen keyboard, and settings made for e-ink.

> **Read this first.** GlassineOS is a hobby project. Most of its code and documentation
> is written with AI coding agents, guided by one enthusiast who is not a kernel
> developer. Nothing here has been reviewed by subsystem experts. Installing it means
> unlocking the bootloader and repartitioning your device; mistakes can brick it.
> Use at your own risk.

## Status

| Device | SoC | Status |
|---|---|---|
| Onyx Boox Note Air (1st gen) | Snapdragon 636 (sdm660 family) | in development, not installable yet |

No release yet. Follow progress in [Discussions](https://github.com/orgs/GlassineOS/discussions).

## What's in it

- **Kernel:** mainline Linux with patches for the device (display link, touch, pen,
  battery, Wi-Fi, audio, power).
- **E-ink engine:** drives the panel directly (the Note Air has no hardware display
  controller), with refresh modes chosen per region and hints from apps.
- **Desktop:** sway with e-ink patches, a native shell and settings, a themable
  on-screen keyboard.
- **Packages:** our own Alpine and Flatpak repositories for e-ink-friendly builds of
  apps.

## Links

- Website and docs: [glassine.org](https://glassine.org) (coming)
- How to contribute: [CONTRIBUTING](https://github.com/GlassineOS/.github/blob/main/CONTRIBUTING.md)
- Security issues: [SECURITY](https://github.com/GlassineOS/.github/blob/main/SECURITY.md)

GlassineOS is not affiliated with Onyx International. "Onyx" and "Boox" are used only
to name the devices it runs on.
