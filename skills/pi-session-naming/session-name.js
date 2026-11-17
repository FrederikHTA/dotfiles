// Provides the live-session operation used by the pi-session-naming skill.
import { homedir } from "node:os";
import { join } from "node:path";

export default function (pi) {
  pi.registerTool({
    name: "name_pi_session",
    label: "Name Pi session",
    description: "Set a short name for the current Pi session if it has not already been named or explicitly cleared.",
    executionMode: "sequential",
    parameters: {
      type: "object",
      properties: {
        name: { type: "string", minLength: 1, maxLength: 80, description: "Concise title based on the first user message." },
      },
      required: ["name"],
      additionalProperties: false,
    },
    async execute(_toolCallId, { name }, _signal, _onUpdate, ctx) {
      const entries = ctx.sessionManager.getEntries();
      const existing = ctx.sessionManager.getSessionName();
      if (existing || entries.some((entry) => entry.type === "session_info")) {
        return {
          content: [{ type: "text", text: existing ? "Session already has a name; left unchanged." : "Session name was explicitly cleared; left unchanged." }],
          details: { status: "unchanged" },
        };
      }

      const title = name.replace(/[\x00-\x1f\x7f-\x9f]/g, " ").replace(/\s+/g, " ").trim();
      if (!title || title.length > 80) throw new Error("Session name must contain 1–80 printable characters.");
      pi.setSessionName(title);
      return {
        content: [{ type: "text", text: `Session named: ${title}` }],
        details: { status: "named", name: title },
      };
    },
  });

  pi.on("before_agent_start", (event, ctx) => {
    if (event.messageType !== "user") return;
    if (!event.systemPromptOptions.selectedTools.includes("name_pi_session")) return;
    const entries = ctx.sessionManager.getEntries();
    if (entries.some((entry) => entry.type === "session_info" || (entry.type === "message" && entry.message.role === "user"))) return;

    const skillPath = join(homedir(), ".agents", "skills", "pi-session-naming", "SKILL.md");
    event.systemPromptOptions.sections.pi_session_naming =
      `This is the first user message in a new Pi session. Read ${skillPath} and follow it before proceeding with the user's request.`;
  });
}
