# Security policy

## Reporting a vulnerability

Please report security issues **privately** through GitHub's private vulnerability
reporting: open the affected repository, go to **Security → Report a vulnerability**.
Don't open a public issue or discussion for them.

You'll get an answer when the maintainer is available. This is a one-person hobby
project, so please allow some days.

## Scope

In scope: GlassineOS images, packages, the installer and recovery, our kernel patches,
and default configuration (accounts, network services, update signing).

Out of scope: vulnerabilities in upstream projects (Alpine, the Linux kernel, sway,
Firefox, …) that aren't caused by our changes. Report those upstream.

## Supported versions

Only the latest image release and the current package repository branch receive
fixes. There is no release yet.

## Signing keys

Packages, Flatpak repositories and images are signed. The public keys and their
fingerprints will be published on [glassine.org](https://glassine.org) and in the
`glassine-keys` package.
