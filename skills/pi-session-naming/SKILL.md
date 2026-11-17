---
name: pi-session-naming
description: Names new Pi sessions with a concise title based on the initial user message. Use when a new Pi session receives its first user message.
---

# Name a new Pi session

On the first user message of a new Pi session, create a short, searchable title describing the user's initial request. Prefer 3–7 words; use fewer when the message is brief. Include a useful project or ticket identifier when relevant, but never include secrets or unnecessary personal information.

Use the `name_pi_session` tool to set the title immediately. Call it directly, or through codemode if that is how tools are exposed. The tool preserves existing or explicitly cleared names. If the user specifies a title or asks not to name the session, follow that request.

Do this without asking permission or interrupting the main task. Do not rename the session as the discussion evolves, modify session files directly, or claim success if the tool is unavailable.

Examples:
- “Explain how DCT handles failed payments” → **DCT Payment Failure Handling**
- “Fix TTN-1234 in the BFF” → **TTN-1234 BFF Fix**
- “Hello” → **Greeting**
