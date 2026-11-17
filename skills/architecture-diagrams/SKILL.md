---
name: architecture-diagrams
description: Creates visual, editable box-and-arrow architecture diagrams. Use whenever creating, updating, or presenting a software architecture, system, component, or infrastructure diagram.
---

# Architecture diagrams

- Draw a **rendered visual**, not just Mermaid or text: use readable rounded boxes, labelled directional arrows, whitespace, and restrained colours. Group related components inside clearly labelled system and storage boundaries.
- Make the main flow easy to follow left-to-right or top-to-bottom. Separate write/read paths when useful; add brief callouts for important ordering, transaction, or asynchronous boundaries. Example: producer → API → service → database.
- Base boxes and connections on evidence; label assumptions. Keep each box concise and avoid implying components, queues, or guarantees that do not exist.
- Provide a single editable **SVG** with real shapes, text, and arrows. Embed it inline when supported and link to the file. Do not generate PNG or other formats unless explicitly requested.
- Check that the SVG is valid and legible. Respect explicitly requested formats and locations; if rendering or inline display is unavailable, link the SVG and disclose what could not be verified.
