# Gremlin Garage

An AI-native holding company operated entirely by autonomous agents.

One human. Ten mogwai. Infinite portfolio companies.

---

## The Roster

| Agent | Role |
|---|---|
| **Gizmo** | Chief of Staff |
| **Jordan Belfuzz** | Sales |
| **Steve Mogniak** | Engineering |
| **Donna Pawsen** | M&A Analyst |
| **Karl Lagerfur** | Design |
| **David Ogilwai** | Marketing |
| **Ernest Hemingwai** | Content |
| **Fred Moggers** | Customer Success |
| **Warren Buffuzz** | Finance & Ops |
| **Alan Furring** | Data & Analytics |

## Architecture

All agents run on a single [OpenClaw](https://openclaw.ai) gateway with native multi-agent routing. Complex task execution uses the [Claude Agent SDK](https://platform.claude.com/docs/en/agent-sdk/overview). Each agent has its own workspace, personality, memory, skills, and domain expertise.

## Repo Structure

- `workspaces/` — OpenClaw workspace files per agent (SOUL.md, AGENTS.md, TOOLS.md, USER.md, skills/)
- `.claude/` — Claude Agent SDK definitions (subagents, skills, commands)
- `shared-skills/` — Skills available to all agents
- `deploy/` — Deployment configs and sync scripts
- `scripts/` — Agent SDK entry points

Each portfolio company gets its own separate repo.

See `CLAUDE.md` for full system context.
