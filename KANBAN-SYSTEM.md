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
| **In Progress** | Actively being worked by a sub-agent |
| **Approval** | Passed Gizmo's review — waiting on Yaya |
| **Done** | Approved and finalized |

---

## Card Format

```markdown
- [ ] **[TICKET-ID] Card Title**
  - **Assigned:** Gizmo / Yaya / AgentName
  - **Added:** YYYY-MM-DD
  - **Description:** What needs to be done
  - **Requirements:** What done looks like
  - **Notes:** (review feedback, proof of delivery, etc.)
```

**Ticket IDs** are sequential: GG-001, GG-002, GG-003...

---

## Architecture — Three Roles

### Role 1: Cron Dispatcher
- Runs every 10 minutes
- Watches Inbox only
- For each new card: assigns ticket ID, moves to Up Next, spawns a sub-agent
- Commits and pushes board changes
- Does NOT do any actual work

### Role 2: Sub-agent (Executor)
- One per ticket
- Moves card from Up Next → In Progress, commits and pushes
- Executes the task described in the card
- Reports back to Gizmo with full results and proof
- Does NOT review its own work
- Does NOT move the card beyond In Progress
- Does NOT notify Yaya

### Role 3: Gizmo (Reviewer + Board Manager)
- Receives sub-agent report
- Reviews output against Requirements — strict
- PASS: moves card to Approval, commits and pushes, notifies Yaya via Telegram
- FAIL: sends feedback to sub-agent, card stays in In Progress, sub-agent retries
- On Yaya approval: moves card to Done, commits and pushes
- On Yaya rejection: sends feedback to sub-agent, card back to In Progress

---

## Sub-agent Responsibilities

### On spawn:
1. `cd ~/projects/gremlin-garage && git pull`
2. Move card from **Up Next → In Progress** in KANBAN.md
3. `git add KANBAN.md && git commit -m "kanban: GG-XXX → In Progress" && git push`
4. Execute the work

### When work is complete:
Report back to Gizmo (sessions_send to parent session) with:
- What you did
- Proof of completion (e.g. Telegram messageId, file created, etc.)
- Any issues encountered

### Sub-agent does NOT:
- Review its own work
- Move card past In Progress
- Notify Yaya
- Make pass/fail decisions

---

## Gizmo's Review Rules (Strict)

- Every requirement must be fully met
- Telegram delivery: tool must return `ok: true` AND a `messageId`
- "Partially done" = FAIL
- Delivery errors = FAIL
- Wrong recipient = FAIL

### On PASS:
1. Move card to **Approval** in KANBAN.md, add proof in Notes
2. `git add KANBAN.md && git commit -m "kanban: GG-XXX → Approval (review passed)" && git push`
3. Send Telegram to Yaya (channel=telegram, target=7424731418):
   ```
   ✅ *GG-XXX* is ready for your approval.
   
   *Task:* [title]
   *What was done:* [summary + proof]
   
   Reply *approve* or *reject*.
   ```

### On FAIL:
1. Card stays in **In Progress**
2. Send feedback to sub-agent with exactly what failed and what to fix
3. Sub-agent retries, reports back again

---

## Cron Dispatcher Prompt Template

```
You are the Gremlin Garage kanban DISPATCHER.
1) cd ~/projects/gremlin-garage && git pull
2) Check Inbox for new cards
3) For each new card: assign next sequential GG-XXX ID, move to Up Next
4) git add KANBAN.md && git commit -m "kanban: queue GG-XXX → Up Next" && git push
5) Spawn a sub-agent (sessions_spawn, mode=run) per card using the Sub-agent Prompt Template below
Do NOT do any actual work.
```

## Sub-agent Prompt Template

```
You are a Gremlin Garage executor for ticket [GG-XXX].

YOUR ONLY JOB: Execute the task and report results back to Gizmo.

Ticket:
- Title: [title]
- Description: [description]  
- Requirements: [requirements]

Steps:
1. cd ~/projects/gremlin-garage && git pull
2. Move card GG-XXX from Up Next → In Progress in KANBAN.md
3. git add KANBAN.md && git commit -m "kanban: GG-XXX → In Progress" && git push
4. Execute the task
5. Report back to Gizmo via sessions_send (sessionKey: [PARENT_SESSION_KEY]) with:
   - What you did
   - Proof (messageId, file path, etc.)
   - Any issues

Do NOT review your own work.
Do NOT move the card past In Progress.
Do NOT notify Yaya.
Just execute and report back.
```

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

## Queue Rules

1. Inbox can have any number of cards
2. Cards in Approval do NOT block the queue
3. Each ticket gets its own sub-agent session
4. Sub-agents report to Gizmo — Gizmo owns the board

---

*System version: 3.0 | Rebuilt: 2026-02-25*
