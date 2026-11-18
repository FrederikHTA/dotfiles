---
name: write-a-skill
description: Create or revise Agent Skills with portable metadata, progressive disclosure, and supporting files. Use when the user asks to create, update, or validate an agent skill.
---

# Writing Skills

Follow the [Agent Skills specification](https://agentskills.io/specification). Make the directory name match the frontmatter `name`, and use relative paths for bundled resources.

## Process

1. **Gather requirements** - ask user about:
   - What task/domain does the skill cover?
   - What specific use cases should it handle?
   - Does it need executable scripts or just instructions?
   - Any reference materials to include?

2. **Draft the skill** - create:
   - `SKILL.md` with required `name` and `description` frontmatter and concise instructions
   - Focused references for details needed only in some situations
   - Utility scripts if deterministic operations need them

3. **Review with user** - present draft and ask:
   - Does this cover your use cases?
   - Anything missing or unclear?
   - Should any section be more/less detailed?

## Skill Structure

```
skill-name/
├── SKILL.md           # Main instructions (required)
├── references/        # Focused details (optional)
├── assets/            # Templates and resources (optional)
└── scripts/           # Utility scripts (optional)
```

## SKILL.md Template

```md
---
name: skill-name
description: Brief description of capability. Use when [specific triggers].
---

# Skill Name

## Quick start

[Minimal working example]

## Workflows

[Step-by-step processes with checklists for complex tasks]

## Advanced features

[Say when to read a separate reference, if one is needed.]
```

## Description Requirements

The description is **the only thing your agent sees** when deciding which skill to load. It's surfaced in the system prompt alongside all other installed skills. Your agent reads these descriptions and picks the relevant skill based on the user's request.

**Goal**: Give your agent just enough info to know:

1. What capability this skill provides
2. When/why to trigger it (specific keywords, contexts, file types)

**Format**:

- Max 1024 chars; name must match its directory and use lowercase letters, numbers, and hyphens
- Write in third person
- First sentence: what it does
- Second sentence: "Use when [specific triggers]"

**Good example**:

```
Extract text and tables from PDF files, fill forms, merge documents. Use when working with PDF files or when user mentions PDFs, forms, or document extraction.
```

**Bad example**:

```
Helps with documents.
```

The bad example gives your agent no way to distinguish this from other document skills.

## When to Add Scripts

Add utility scripts when:

- Operation is deterministic (validation, formatting)
- Same code would be generated repeatedly
- Errors need explicit handling

Scripts save tokens and improve reliability vs generated code.

## When to Split Files

Split into separate files when:

- `SKILL.md` approaches the specification's recommended 500 lines or 5,000 tokens
- Content has distinct domains or advanced features are rarely needed
- The main instructions can state when to load each reference

## Review Checklist

After drafting, verify:

- [ ] Name matches the directory; description states what the skill does and when to use it
- [ ] Frontmatter uses specification fields and string-valued metadata; document any intentional client-specific fields
- [ ] Preserve explicit-only controls such as Pi's `disable-model-invocation` when needed
- [ ] Main instructions are concise; references are relative, focused, and loaded when needed
- [ ] Referenced files exist; examples and tool requirements are appropriate to the target environment
