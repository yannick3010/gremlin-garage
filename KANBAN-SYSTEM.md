# KANBAN-SYSTEM.md — Gremlin Garage Board Rules

This document defines how the Gremlin Garage kanban board works.
All agents (including Gizmo) must follow these rules exactly.

---

## Board File

**Location:** `KANBAN.md` (repo root)
**Format:** Obsidian Kanban plugin markdown
**Source of truth:** GitHub (`gremlin-garage` repo)

---

## Columns

| Column | Purpose |
|--------|---------|
| **Inbox** | Newly added cards, unreviewed |
| **Up Next** | Reviewed, assigned, queued — waiting their turn |
| **In Progress** | Actively being worked by a persistent sub-agent session |
| **Approval** | Passed Gizmo's review — waiting on Yaya |
| **Done** | Approved and finalized |

---

## Card Format

Each card is a markdown list item:

```markdown
- [ ] **[TICKET-ID] Card Title**
  - **Assigned:** Gizmo / Yaya / AgentName
  - **Added:** YYYY-MM-DD
  - **Description:** What needs to be done
  - **Requirements:** What done looks like
  - **Notes:** (optional — review feedback, context, etc.)
```

**Ticket IDs** are sequential: GG-001, GG-002, GG-003...

---

## Architecture

### Two-layer system:

**Layer 1 — Cron Dispatcher (lightweight, runs every 10 min)**
- Watches Inbox only
- For each new card: assigns it, moves to Up Next, spawns a persistent sub-agent session
- Does NOT do any actual work
- Commits and pushes board changes

**Layer 2 — Sub-agent Session (persistent, per ticket)**
- Spawned by the cron dispatcher for each ticket
- Works the ticket fully
- Loops through work → Gizmo review → retry until review passes
- Once passed: moves card to Approval, notifies Yaya via Telegram, then WAITS
- On Yaya approval: moves card to Done, terminates
- On Yaya rejection: retries with feedback, loops again
- Cards in Approval do NOT block the queue — new tickets can be worked in parallel

---

## Cron Dispatcher Responsibilities

On every poll:
1. `cd ~/projects/gremlin-garage && git pull`
2. Check for new cards in **Inbox**
3. For each new Inbox card:
   - Assign a ticket ID (next sequential GG-XXX)
   - Assign to Gizmo (default)
   - Move card to **Up Next**
   - Spawn a sub-agent session with the ticket context (see Sub-agent Prompt below)
4. `git add KANBAN.md && git commit -m "kanban: queue GG-XXX → Up Next" && git push`
5. Do nothing else — no work, no review

---

## Sub-agent Session Responsibilities

### On spawn:
1. `cd ~/projects/gremlin-garage && git pull`
2. Move assigned card from **Up Next** → **In Progress**
3. `git add KANBAN.md && git commit -m "kanban: GG-XXX → In Progress" && git push`
4. Execute the work described in the card

### Work → Review loop:
1. Complete the work
2. Self-review against **Requirements** — strict:
   - Every requirement must be fully met
   - If task required sending a Telegram message: verify tool returned `ok: true` and a messageId
   - "Partially done" = Fail
   - Delivery errors = Fail
3. **If PASS:**
   - Move card to **Approval** with notes: ✅ what was done and proof (e.g. messageId)
   - `git add KANBAN.md && git commit -m "kanban: GG-XXX → Approval (review passed)" && git push`
   - Send Telegram notification to Yaya: `channel=telegram, target=7424731418`
     - Message format: "✅ **GG-XXX** is ready for your approval.\n\n**Task:** [title]\n**What was done:** [brief summary]\n\nReply **approve** or **reject**."
   - WAIT for Yaya's response (do not terminate)
4. **If FAIL:**
   - Write clear failure notes in card **Notes**
   - Stay in **In Progress** (do not move card)
   - Fix the issue and retry — loop back to step 1

### On Yaya approval:
1. Move card from **Approval** → **Done**
2. Mark card as `- [x]`
3. `git add KANBAN.md && git commit -m "kanban: GG-XXX → Done (approved)" && git push`
4. Terminate session

### On Yaya rejection:
1. Add rejection feedback to card **Notes**
2. Move card from **Approval** → **In Progress**
3. `git add KANBAN.md && git commit -m "kanban: GG-XXX → In Progress (rejected by Yaya)" && git push`
4. Retry work with feedback — loop back to work → review cycle

---

## Sub-agent Spawn Prompt Template

When the cron dispatcher spawns a sub-agent, use this prompt:

```
You are a Gremlin Garage task agent. Your job is to complete ticket [GG-XXX] from start to approval.

Ticket details:
- Title: [title]
- Description: [description]
- Requirements: [requirements]

Board file: ~/projects/gremlin-garage/KANBAN.md
System rules: ~/projects/gremlin-garage/KANBAN-SYSTEM.md
Telegram target for Yaya: channel=telegram, target=7424731418
Gizmo (reviewer) Telegram: channel=telegram, target=7424731418

Follow KANBAN-SYSTEM.md Sub-agent Session Responsibilities exactly.
Do not terminate until the card is marked Done.
```

---

## Queue Rules

1. Inbox can have any number of cards
2. Cards in Approval do NOT block the queue
3. New tickets are picked up as they arrive in Inbox
4. Each ticket gets its own persistent session — no shared state between tickets

---

## Commit Convention

```
kanban: queue GG-001 → Up Next
kanban: GG-001 → In Progress
kanban: GG-001 → Approval (review passed)
kanban: GG-001 → Done (approved)
kanban: GG-001 → In Progress (rejected by Yaya)
```

---

*System version: 2.0 | Rebuilt: 2026-02-25*
