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
| **Up Next** | Reviewed, assigned, queued |
| **In Progress** | Actively being worked — ONE card max |
| **Review** | Gizmo checking output vs. requirements |
| **Approval** | Passed review — waiting on Yaya |
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

## Queue Rules

1. **Inbox can have any number of cards**
2. **Only ONE card in In Progress at any time**
3. **Gizmo does not pull the next card until the current one is Done**
4. **Cards move through columns in order — no skipping**

---

## Gizmo's Responsibilities

### On every cron poll:
1. `git pull` the repo
2. Check for new cards in **Inbox**
3. For each new Inbox card:
   - Read and understand the ticket
   - Assign to self (Gizmo), a specialist agent, or Yaya
   - Move to **Up Next**
   - Assign a ticket ID if missing
4. If **In Progress is empty** and **Up Next has cards**:
   - Pull the first Up Next card → move to **In Progress**
   - Begin work immediately
5. Commit and push all changes

### When work is complete:
1. Move card from **In Progress** → **Review**
2. Check output against the card's **Requirements**
3. **Pass:** Move to **Approval**, notify Yaya via Telegram
4. **Fail:** Write clear failure notes in card **Notes**, push back to **In Progress**

### Never:
- Work on more than one card at a time
- Move a card to Approval without self-review first
- Skip columns

---

## Yaya's Responsibilities

- Add cards to **Inbox** (via Obsidian or by messaging Gizmo)
- Review cards in **Approval** and reply: approve or reject
- On **approve:** Gizmo moves to Done, pulls next card
- On **reject:** Gizmo adds feedback notes, pushes back to In Progress

---

## Commit Convention

Every board update is a git commit:

```
kanban: move GG-001 → In Progress
kanban: move GG-002 → Approval (review passed)
kanban: add GG-003 to Up Next (assigned: Gizmo)
```

---

## Notification

- Gizmo notifies Yaya via **Telegram** when a card hits **Approval**
- Gizmo notifies Yaya via **Telegram** if a card fails review (with reason)
- No other notifications unless urgent

---

*System version: 1.0 | Built: 2026-02-24*
