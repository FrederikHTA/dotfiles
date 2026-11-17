import assert from "node:assert/strict";
import test from "node:test";
import registerSessionNaming from "./session-name.js";

function harness(entries = [], currentName) {
  let tool;
  let beforeStart;
  const names = [];
  const pi = {
    registerTool(definition) { tool = definition; },
    on(event, handler) {
      assert.equal(event, "before_agent_start");
      beforeStart = handler;
    },
    setSessionName(name) {
      names.push(name);
      currentName = name;
      entries.push({ type: "session_info", name });
    },
  };
  registerSessionNaming(pi);
  const ctx = { sessionManager: { getEntries: () => entries, getSessionName: () => currentName } };
  const event = (overrides = {}) => ({
    messageType: "user",
    systemPromptOptions: { selectedTools: ["name_pi_session"], sections: {} },
    ...overrides,
  });
  return { tool, beforeStart, ctx, names, event };
}

test("prompts the agent to load the skill on a new session's first user message", () => {
  const h = harness();
  const first = h.event();
  h.beforeStart(first, h.ctx);
  assert.match(first.systemPromptOptions.sections.pi_session_naming, /pi-session-naming\/SKILL\.md/);
});

test("does not prompt for resumed, named, explicitly cleared, custom, or tool-disabled sessions", () => {
  const cases = [
    { entries: [{ type: "message", message: { role: "user" } }] },
    { entries: [{ type: "session_info", name: "Existing" }], name: "Existing" },
    { entries: [{ type: "session_info" }] },
    { entries: [], event: { messageType: "custom" } },
    { entries: [], event: { systemPromptOptions: { selectedTools: [], sections: {} } } },
  ];
  for (const c of cases) {
    const h = harness(c.entries, c.name);
    const e = h.event(c.event);
    h.beforeStart(e, h.ctx);
    assert.equal(e.systemPromptOptions.sections.pi_session_naming, undefined);
  }
});

test("names the live session once and normalizes whitespace and control characters", async () => {
  const h = harness();
  const result = await h.tool.execute("1", { name: "  DCT\nPayment  Failures  " }, undefined, undefined, h.ctx);
  assert.deepEqual(h.names, ["DCT Payment Failures"]);
  assert.equal(result.details.status, "named");
  const second = await h.tool.execute("2", { name: "Other" }, undefined, undefined, h.ctx);
  assert.equal(second.details.status, "unchanged");
  assert.deepEqual(h.names, ["DCT Payment Failures"]);
});

test("preserves an existing name and a name the user explicitly cleared", async () => {
  for (const h of [harness([{ type: "session_info", name: "Manual" }], "Manual"), harness([{ type: "session_info" }])]) {
    const result = await h.tool.execute("1", { name: "Replacement" }, undefined, undefined, h.ctx);
    assert.equal(result.details.status, "unchanged");
    assert.deepEqual(h.names, []);
  }
});

test("rejects an empty or overly long title without renaming", async () => {
  const h = harness();
  await assert.rejects(h.tool.execute("1", { name: " \n " }, undefined, undefined, h.ctx), /1–80/);
  await assert.rejects(h.tool.execute("2", { name: "a".repeat(81) }, undefined, undefined, h.ctx), /1–80/);
  assert.deepEqual(h.names, []);
});
