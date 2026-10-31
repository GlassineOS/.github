# Organization guidance for coding agents

Every GlassineOS repository imports this file into its agent instructions (`CLAUDE.md`
holds the line `@.glassine/org/AGENTS.md`). It is updated with the submodule.

## Project knowledge

The published documentation (https://docs.glassine.org) holds the device facts, guides,
architecture, decisions and dead ends that apply across repositories. Search it before
you state a fact about a device, the boot chain, a decision or a past approach, and
before you propose an approach that may already have failed:

```sh
pip install "git+https://github.com/GlassineOS/search"   # once
glassine-docs search "how is user data encrypted"        # add --json for tools
```

- Cite the result's link (page and heading) and the docs commit it reports.
- Hardware facts carry a verification date; say when a fact is older than the code
  you are changing.
- If the tool can't be installed (no Python, no onnxruntime), use
  `glassine-docs search --profile static` or read the site directly.
- No result is not proof of absence: say that you didn't find it, not that it isn't so.
- The documentation is public and reviewed. Don't paste search results into commits or
  docs as new facts without checking them against the code or the hardware.
