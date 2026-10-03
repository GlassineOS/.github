# Contributing to GlassineOS

Thanks for your interest. These rules apply to every repository in the GlassineOS
organization unless a repository says otherwise.

## How this project is made

GlassineOS is a hobby project. Most of its code and documentation is written with AI
coding agents, guided by one maintainer who is not a kernel developer. We say this
plainly so nobody is misled:

- Code here has **not** been reviewed by subsystem experts.
- AI-assisted commits carry a trailer naming the tool and model, for example
  `Assisted-by: Claude:claude-opus-5-5` or `Co-Authored-By: Claude …`.
- Human contributions are just as welcome. You don't need to use AI tools, and you
  don't need to disclose that you didn't.

## Licensing and sign-off

- Contributions are accepted under the license of the repository you contribute to
  ("inbound = outbound", as in GitHub's terms of service). Our own code is
  **GPL-2.0-or-later**; client libraries and protocol files may be LGPL or MIT; forks
  keep their upstream license; documentation is **CC-BY-SA-4.0**. Check the `LICENSE`
  file of the repository.
- No CLA, no DCO sign-off required.
- Never add `Signed-off-by` on someone else's behalf, and agents never add it at all.

## Upstream projects

Some upstream projects do not accept AI-assisted contributions, others have specific
rules for them. **We do not send our patches upstream unsolicited.** Patches in our
forks are labelled with their status (`Glassine-Upstream: not-submitted (unreviewed)`).
If you are a maintainer or expert and want one of them, take it, review it and submit
it under your own name and the upstream's rules.

Please don't bring GlassineOS questions or AI-made work into upstream communities that
ask not to receive it.

## What must never be committed

The organization's safety scan (`scripts/safety-scan.sh` in this repository, also a
pre-push hook and a CI check) rejects these. Please don't try to work around it:

- Vendor firmware and binaries: waveform files (`*.wbf`), modem/DSP/Wi-Fi firmware,
  vendor `.so` libraries, Onyx or Qualcomm images, signed EDL/firehose loaders.
- Device dumps: partition images, GPT/misc dumps, RAM dumps, logs with serial numbers or
  MAC addresses.
- Private keys and credentials.
- Output of decompilers run on vendor binaries. Written specifications derived from
  them are fine.

Firmware the device needs is extracted from the user's own device at install time.

## Commits and pull requests

- One topic per commit; explain *why* in the message.
- Keep pull requests small and say how you tested (host test, emulator, which device).
- Changes that touch flashing, partitioning, the bootloader or recovery must describe
  the failure mode and the escape route.

## Reporting bugs and devices

Use the issue templates. Device reports for models we don't support yet go to
[Discussions](https://github.com/orgs/GlassineOS/discussions).

## Code of conduct

Everyone taking part follows the [Code of Conduct](CODE_OF_CONDUCT.md).
