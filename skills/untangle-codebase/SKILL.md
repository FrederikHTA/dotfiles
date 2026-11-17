---
name: untangle-codebase
description: Find and classify what a codebase needs untangled, preview the proposed changes for the user to choose from, then implement only the approved ones, so agents working in it read less per change, break less without noticing, and debug faster.
disable-model-invocation: true
argument-hint: "[optional area or concern to focus on]"
---

Find what is tangled in this codebase, classify it, and preview the proposed changes for the user. Implement only what the user approves.

**Hard gate:** Steps 1–4 analyse only. Before the user explicitly approves specific items, don't edit code, create branches or worktrees, commit, or launch implementation subagents. Once items are approved, treat completing *those items* as a goal.

**Why do this at all?**

- **Better output:** agents write better code in a well-structured codebase.
- **Cheaper & faster changes:** agents spend fewer tokens searching and more on the problem.
- **Fewer silent breaks:** agents break less without noticing.
- **Faster debugging:** agents find root causes faster.

**1. Ask**

Besides untangling the codebase, there are two other things you may do:

| Addition | What it does |
| --- | --- |
| **Comments** | Remove comments that only restate the code. |
| **Tests** | Remove tests that wouldn't catch a real bug, and fix the ones that fail without one. |

List these (with their exact descriptions) for the user and ask which ones to include in the analysis. They appear in the preview like any other item, and are only done if approved there.

**2. List every problem**

Don't change anything yet.

Go through the codebase asking one thing: **should these pieces change together?** Write down every place the code gets the answer wrong, as in the [decision log example](#decision-log-example). There are only three ways to get it wrong.

**Hidden links:** pieces that must change together, where the code doesn't show it.

- Copies of logic or values: change one and the others must change too, but nothing says so.
- A module that reads a global or file set by another module: change that module and this one breaks, but nothing shows it (self-contained code).
- A feature split across folders by layer, or related code in different folders: one change needs all of them, but the layout hides that (domain-driven code, colocation).
- A call order or convention callers just have to know: change it and callers break, but nothing warns them (explicit over implicit).

**Needless links:** pieces tied together that change for different reasons.

- Callers that depend on internals: the internals change for their own reasons, and the callers break anyway (encapsulation).
- Stable code that imports something more volatile: the stable code has to change whenever the volatile code does (dependency direction).
- A general function with a parameter only one workflow understands: the function has to change whenever that workflow does (caller vocabulary).
- A shallow module: its interface changes whenever its internals do, so its callers change with it (deep modules).

**Surplus:** pieces with no reason of their own to change.

- Wrappers: they only change when the thing they wrap does (pass-through wrappers).
- Extension points and config for things that never vary: nothing will ever change them (speculative generality).
- Dead code: nothing uses it, so nothing will ever need it to change.

Also write down every **special case**: code that exists for one situation instead of following from how the system works. Each one is a requirement the design never accounted for, so use them to work out what the system needs to be.

- An `if` for one value
- A parameter for a specific caller
- A swallowed exception
- A retry or sleep
- A disabled test

**3. Redesign from first principles**

Work out the fixes as if the system had known today's requirements from the start. Look for the one fix behind several problems, which often looks nothing like them. Don't fix special cases one by one.

Ask the same thing of every fix, even one that looks better in the code: pieces that change together end up together, pieces that don't aren't tied, and everything depends on what changes less.

Write each fix above the problems it solves, as in the [decision log example](#decision-log-example).

**4. Preview the changes and wait for approval**

Give the user a rundown of every proposed fix, so they can decide what is relevant, what there is time for and what to skip. Save it in the decision log too. Then **stop and wait**.

Give each fix one row, not one per problem, as in the [preview example](#preview-example), with:

- **ID:** used for approval, for example `U1`.
- **Kind:**
  - **Architecture:** a structural, behaviour-neutral change: moving code, a single source of truth, dependency direction, narrower interfaces.
  - **Cleanup:** removing dead code, wrappers or config that never varies. Behaviour-neutral.
  - **Bug fix:** an intended, observable correction of something that is wrong today.
  - **Behaviour change:** observable, and needs a product or owner decision before anyone acts on it.
  - **Comments** or **Tests:** only if the user chose them in step 1.
- **What and why:** one or two lines on what changes, and which problems it removes.
- **Scope:** the packages or areas touched, with rough size.
- **Effort:** S, M or L.
- **Behaviour risk:** none, log-text only, or observable. Say exactly what would be observable.
- **Contract impact:** any persisted or published contract touched: event schemas, stored data, wire values, public API, config defaults. Architecture and Cleanup items should touch none; if one does, call that out.
- **Depends on:** other IDs that must come first.

Then list:

- **Bugs found:** observable problems you came across while analysing, as Bug fix or Behaviour change items. Don't go looking for bugs separately, and never fix one silently.
- **Recommend skipping:** items you found but think aren't worth doing, with reasons. For example: too large for the gain, or needs an upstream change.
- **Kept special cases:** special cases the system still needs, and why.

End with a recommendation, for example "highest leverage for the effort: U1, U3, U4". Ask which IDs to implement.

Approval must name items: specific IDs, a kind ("all Architecture"), or an explicit "all". If the reply is ambiguous, ask instead of assuming. Skipped items stay in the decision log.

**5. Implement the approved items**

Implement only the approved IDs. Remove the special cases the approved redesign makes unnecessary, and keep the ones the system still needs. A structural fix may turn out to change behaviour (or fix a bug) you didn't preview. If so, stop and ask before keeping that change, unless it was approved as part of the item.

If the user approved Comments:

- Comments that restate the implementation, like `// sort first so the binary search works`, only change when it does, so they have no reason of their own to change. Remove them, even if they're phrased as a why.
- Comments about something outside the code, like `// the proxy drops websockets, so we poll`, change when that does, and the code can't show it. Keep them.
- Comments that explain a workaround om the codebase, like `// wait 100ms because the cache isn't ready yet`, only change when the problem behind the workaround does. They go when the redesign removes that problem.

If the user approved Tests, do this last, because tests are your regression safety net. A test should fail on a regression, and only then:

- Tests that repeat the implementation only change when it does, so they have no reason of their own to change. They check the same interpretation against itself, so remove them.
- Tests tied to internals break when the code changes but behavior doesn't, so they change for the wrong reason. Rewrite them to depend on behavior, which changes less.
- Tests that can't fail pass whatever the code does, so no change ever affects them. They aren't checking anything, so remove them.

**6. Check, and repeat until done**

Have subagents search for special cases, hidden links, needless links and surplus. Reviewers only report; they don't fix anything. Present their new findings as a follow-up preview in the same format as step 4, and implement only what the user approves. Repeat until the user says stop or nothing worth fixing is left.

You're done when:

- **As few special cases are left in the system as possible.** How many remain is the best measure of how close you are.
- A typical change lands in one place.
- Every import is reasonable, and nothing imports anything more volatile than itself.
- Subagents have no issues left that are worth fixing, or the user has chosen to skip the rest.
- Intended behavior is the same as when you started, apart from approved bug fixes and behaviour changes. Test this at the end.

**Tips**

- **Start from a skeleton:** script away the function bodies, so the whole codebase fits in context.
- **Summarize with subagents:** have them summarize parts of the codebase, so you can reason across all of it at once.
- **Check the dependency graph often:** script one that shows what imports what, and rerun it as you go.
- **Enter where leverage is highest:** start looking there first.
- **Keep a decision log:** compaction is less of a problem that way.
- **Use Git as evidence:** for how often pieces change, and what changes together.
- **Be open about long waits:** when subagents or long test suites run in the background, tell the user what is running and roughly how long it takes. Don't silently sleep-poll.

<a id="decision-log-example"></a>**Decision log example**

The list of problems:

```md
- `ui/LogoutDialog.tsx:30` waits 100ms after closing and hopes the message input can take focus by then.
- `ui/Toolbar.tsx:40` and `ui/Menu.tsx:22` call the same actions, each with its own check for when they're disabled.
- `checkout/submit.ts:9` depends directly on `payments/stripe.ts`.
- `shortcuts/keymap.ts:18` has a switch with one case per action, separate from the menu's list.
- `ui/CommandPalette.tsx:55` keeps its own list of actions, and it's missing the newer ones.
- `ui/SettingsDialog.tsx:61` sets a global `skipRefocus` flag to stop the logout dialog it opens from sending focus to the message input.
- `history/undo.ts:30` has a special case for every action that can be undone.
- `refunds/refund.ts:22` wraps every Stripe call in `if (order.provider === "paypal")`.
- Every action handler has to call `track()` by hand, and some don't.
- `ui/Toolbar.test.tsx` and `ui/Menu.test.tsx` test the same actions separately.
```

Then with the fixes:

```md
- Make the general `Dialog` give focus back to whatever had it before it opened, so the wait and the flag can both go.
  - `ui/LogoutDialog.tsx:30` waits 100ms after closing and hopes the message input can take focus by then.
  - `ui/SettingsDialog.tsx:61` sets a global `skipRefocus` flag to stop the logout dialog it opens from sending focus to the message input.
- Define a `PaymentProvider` interface that Stripe and PayPal both implement, so checkout and refunds no longer know which one they're using.
  - `checkout/submit.ts:9` depends directly on `payments/stripe.ts`.
  - `refunds/refund.ts:22` wraps every Stripe call in `if (order.provider === "paypal")`.
- Make every user action a command with a name, a handler and an undo, so the toolbar, menu, shortcuts, palette and undo history all run from one list.
  - `ui/Toolbar.tsx:40` and `ui/Menu.tsx:22` call the same actions, each with its own check for when they're disabled.
  - `shortcuts/keymap.ts:18` has a switch with one case per action, separate from the menu's list.
  - `ui/CommandPalette.tsx:55` keeps its own list of actions, and it's missing the newer ones.
  - `history/undo.ts:30` has a special case for every action that can be undone.
  - Every action handler has to call `track()` by hand, and some don't.
  - `ui/Toolbar.test.tsx` and `ui/Menu.test.tsx` test the same actions separately.
```

<a id="preview-example"></a>**Preview example**

```md
| ID | Kind | What and why | Scope | Effort | Behaviour risk | Contract impact | Depends on |
| --- | --- | --- | --- | --- | --- | --- | --- |
| U1 | Architecture | `PaymentProvider` interface; checkout and refunds stop knowing which provider they use (2 problems) | checkout, refunds, payments | M | none | none | – |
| U2 | Architecture | One command list drives toolbar, menu, shortcuts, palette and undo (6 problems) | ui, shortcuts, history | L | none | none | – |
| U3 | Cleanup | Delete unused `legacy/export` package and its config flag | legacy, config | S | none | none | – |
| U4 | Bug fix | Command palette shows the actions it is missing today (falls out of U2) | ui | S | observable: new palette entries | none | U2 |
| U5 | Behaviour change | Refund retries currently swallow provider errors; surface them | refunds | S | observable: callers see errors | none | U1 |

Recommend skipping: rewriting `history/undo.ts` storage (L effort, no current pain).
Kept special cases: the 100ms websocket poll (the proxy drops websockets).
Highest leverage for the effort: U1, U3. Which IDs should I implement?
```
