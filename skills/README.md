# Personal agent skills

These directories use the [Agent Skills specification](https://agentskills.io/specification). Each skill has a `SKILL.md` with a name matching its directory; supporting files are loaded as needed. `~/.agents/skills` links to this directory.

Use `skills-ref validate <skill-directory>` from the [reference library](https://github.com/agentskills/agentskills/tree/main/skills-ref) to check frontmatter and names. The reference library is a demonstration tool, not a production validator. Also check that referenced files exist and that the intended agent can load the skill.

## Pi-specific behavior

`setup-matt-pocock-skills`, `teach`, `untangle-codebase`, and `zoom-out` intentionally use Pi's `disable-model-invocation: true`. They remain available through explicit `/skill:name` commands but are not advertised for automatic selection. The upstream reference validator rejects this Pi-specific field; do not remove it just to make validation pass. Other clients may handle the field differently.

After editing skills, use `/reload` in Pi to refresh discovery.

## Bundled sources

- `golang-testing` includes references from [samber/cc-skills-golang](https://github.com/samber/cc-skills-golang), version 1.4.0, under its bundled MIT license. The integration-testing reference carries an additional local safety warning.
- `go-uber-styleguide` preserves the [Uber Go Style Guide](https://github.com/uber-go/guide) as a reference, with its Apache 2.0 license. Read the relevant sections rather than loading the whole guide.
