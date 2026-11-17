---
name: obsidian-notes
description: Maintains concise Obsidian lookup notes about domain concepts, service responsibilities, and the wider architecture. Use when a conversation introduces or refines reusable domain knowledge, repository responsibilities, ownership boundaries, or business flows, or when asked to update these notes.
---

# Obsidian domain notes

## When to save

During substantive conversations, check for new or clarified domain concepts, service responsibilities, architectural relationships, and business flows. Automatically save reusable insights at useful checkpoints; do not wait for the user to ask. Updating notes supplements the user's task and must not interrupt or replace it.

Do not create a note just because a repository, code change, or technical problem was discussed. Skip generic technical explanations and implementation details unless the user explicitly asks to save them. Respect requests not to save.

## Where to save

- Notes live under `/Users/fhta/obsidian`. The Lunar Obsidian vault is `/Users/fhta/obsidian/Lunar`.
- Search for and read relevant notes before writing. Update an existing note rather than creating a duplicate; follow the existing subject and repository folders.
- For repository facts, read the repository README and relevant domain or architecture documentation it points to. Keep implementation details in those sources, not the note.
- Use descriptive titles and link to related notes when useful. Verify link targets within the applicable vault; do not create placeholders just to link them.
- Update an existing index when a new note merits it, without turning the index into a conversation log.

## What to write

Write for someone who has forgotten the concept and needs a quick lookup—not a transcript or an implementation guide. Be as short and concise as the meaning allows.

- **Domain concept:** what it means, why it matters, and any essential distinction or relationship.
- **Repository or service:** why it exists, its responsibility, and where it fits in the wider architecture.
- **Boundaries and relationships:** what a domain or service owns and does not own, which neighbors own adjacent responsibilities, and how they relate or hand off work.
- **Flow:** include a small diagram only when it makes the relationships clearer, for example `Customer → Service A → Service B`.

Focus on domain knowledge, architecture, and the bigger picture. Omit code, package layouts, schemas, endpoint inventories, framework details, build commands, debugging history, and implementation walkthroughs. Mention a technical detail only if it is necessary to understand the domain or an architectural boundary.

Distinguish verified facts from assumptions, proposals, and reported context. Label uncertainty and open questions instead of filling gaps with guesses; use the conversation and relevant authoritative sources to verify claims. Keep useful links to sources or neighboring notes brief.

## Safe updates

- Integrate new understanding into relevant existing sections; preserve user-written content, useful history, and valid links. If new evidence changes an earlier conclusion, state the correction without preserving obsolete claims as current fact.
- Do not delete, rename, or move notes or change `.obsidian` settings without permission.
- Verify the notes location is accessible before writing. If it is unavailable or unwritable, say so, offer a concise note in the response, and continue the main task; do not create a substitute vault.
- Verify the saved note and links before claiming success. If there is no relevant insight, do nothing and do not manufacture a note for the task.
- After a successful update, briefly list the note paths changed; do not repeat the note in the response unless asked.
