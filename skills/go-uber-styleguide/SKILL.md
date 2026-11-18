---
name: go-uber-styleguide
description: Apply the Uber Go Style Guide when a repository adopts it or the user explicitly requests Uber Go style or a review against the guide.
license: Apache-2.0
metadata:
  source: https://github.com/uber-go/guide
---

# Uber Go Style Guide

Follow the repository's instructions and established conventions when they differ from the guide. Use the guide as a reference, not a reason to add dependencies or rewrite unrelated code.

The original guide is preserved in [references/uber-go-style-guide.md](references/uber-go-style-guide.md). It covers guidelines, performance, style, patterns, and linting. Search its headings for the topic at hand and read only the relevant sections rather than loading the entire guide. For example:

```bash
rg -n '^#{2,4} ' references/uber-go-style-guide.md
```

Resolve the reference path relative to this skill directory. The guide and its [license](LICENSE) are from [uber-go/guide](https://github.com/uber-go/guide).
