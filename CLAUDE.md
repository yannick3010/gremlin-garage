# Gremlin Garage — Claude Code Context

## What Is This?

Gremlin Garage is an AI-native holding company. Every operational function is run by autonomous AI agents. There is exactly one human in the loop: Yaya (Yannick Lorenz). The company's chief of staff is an AI agent named Gizmo, and every other agent reports to Gizmo. Gizmo only escalates to Yaya when absolutely necessary.

Gremlin Garage spins up portfolio companies (portcos) underneath it, each with a focused product thesis. Agents run each portco's operations autonomously. The first portco is an OpenClaw one-click deploy product for non-technical users.

## Owner

Yaya (Yannick Lorenz) — VP, Strategic Partnerships & Acquisitions at VAN (Veza Agency Network). Yaya is the sole human decision-maker. He operates with a systems-first mindset: repeatable processes, high decision velocity, scalable structures.

---

## Architecture

### Runtime: OpenClaw Multi-Agent Gateway

All agents run on a single OpenClaw gateway instance on AWS EC2 (t4g.small, ARM64, IP: 3.141.85.81). OpenClaw natively supports multi-agent routing — each agent is a fully isolated "brain" with its own workspace, sessions, auth profiles, model config, and skills.

Each agent's identity is defined by four workspace files that OpenClaw injects into the system prompt:

| File | Purpose |
|---|---|
| `SOUL.md` | Personality, identity, communication style, core behavioral rules |
| `AGENTS.md` | Operational instructions, guardrails, team context, routing rules |
| `TOOLS.md` | Tool-specific instructions and usage patterns |
| `USER.md` | Context about the user/owner (Yaya) |

Plus a `skills/` directory containing per-agent skill definitions.

### Execution Layer: Claude Agent SDK

When agents need to execute complex, multi-step tasks (code generation, document creation, research workflows), they call the Claude Agent SDK. The SDK provides the agentic execution loop — tool use, subagent orchestration, skill-based workflows, and MCP integrations.

**The split is clear**: OpenClaw = persistent identity, communication, and routing layer. Agent SDK = task execution engine.

### Agent Communication (Built into OpenClaw)

OpenClaw provides native session tools for inter-agent communication:

| Tool | What It Does |
|---|---|
| `sessions_list` | Discover active agent sessions and their metadata |
| `sessions_history` | Fetch transcript logs from another agent's session |
| `sessions_send` | Send a message to another agent's session; supports synchronous wait (with timeout) and async fire-and-forget |
| `sessions_spawn` | Spawn a sub-agent run in an isolated session |

**Three invocation paths for every agent:**

1. **Delegation** — Gizmo uses `sessions_send` to assign a task to a specialized agent. Supports a ping-pong reply loop (up to 5 turns) for back-and-forth coordination.
2. **Direct contact** — A human messages or tags an agent in Slack. Routing is handled by `bindings[]` in `openclaw.json` which maps channels/peers to agent IDs. Each agent can have their own Slack profile.
3. **Triggers** — Cron jobs (`cron:<job.id>`), webhooks (`hook:<uuid>`), and Gmail pub/sub fire into specific agent sessions automatically.

### Repo Strategy

Multi-repo. This repo (`gremlin-garage`) contains the holding company infrastructure: agent workspace files, shared skills, deployment configs, and documentation. Each portfolio company gets its own separate repo.

---

## The Mogwai Roster

Every agent is a "mogwai" (Mogwai from Gremlins + AI). Each is named after a real or fictional person with a Gremlins-inspired pun.

| Agent | ID | Role | Namesake | Model |
|---|---|---|---|---|
| **Gizmo** | `gizmo` | Chief of Staff — orchestrates all agents, delegates tasks, reports to Yaya | The OG Mogwai | Sonnet (default) / Opus (complex) |
| **Jordan Belfuzz** | `jordan-belfuzz` | Sales — outbound, pipeline, deal closing, follow-ups | Jordan Belfort | Sonnet |
| **Steve Mogniak** | `steve-mogniak` | Engineering — builds products, writes code, manages infra | Steve Wozniak | Sonnet / Opus (architecture) |
| **Donna Pawsen** | `donna-pawsen` | M&A Analyst — deal sourcing, due diligence, competitive intel | Donna Paulsen (Suits) | Sonnet / Opus (analysis) |
| **Karl Lagerfur** | `karl-lagerfur` | Design — UI/UX, brand identity, visual assets, design systems | Karl Lagerfeld | Sonnet |
| **David Ogilwai** | `david-ogilwai` | Marketing — strategy, campaigns, positioning, go-to-market | David Ogilvy | Sonnet |
| **Ernest Hemingwai** | `ernest-hemingwai` | Content — copywriting, docs, social media, thought leadership | Ernest Hemingway | Sonnet |
| **Fred Moggers** | `fred-moggers` | Customer Success — onboarding, support, retention | Fred Rogers (Mr. Rogers) | Sonnet |
| **Warren Buffuzz** | `warren-buffuzz` | Finance & Ops — P&L, burn rate, billing, financial modeling | Warren Buffett | Sonnet |
| **Alan Furring** | `alan-furring` | Data & Analytics — funnels, usage metrics, churn, dashboards | Alan Turing | Sonnet |

---

## Directory Structure

```
gremlin-garage/
├── CLAUDE.md                              ← You are here
├── README.md                              ← Public-facing repo description
├── .gitignore
│
├── .claude/                               ← Claude Agent SDK config (execution layer)
│   ├── skills/                            ← Shared skills for SDK scripts
│   ├── commands/                          ← Slash commands for Claude Code interactive use
│   └── agents/                            ← SDK subagent definitions
│
├── workspaces/                            ← OpenClaw workspace files (identity layer)
│   ├── gizmo/                             ← Maps to ~/.openclaw/workspace-gizmo/ on EC2
│   │   ├── SOUL.md                        ← Personality, identity, behavioral rules
│   │   ├── AGENTS.md                      ← Operational instructions, routing rules
│   │   ├── TOOLS.md                       ← Tool-specific instructions
│   │   ├── USER.md                        ← Context about Yaya
│   │   └── skills/                        ← Gizmo-specific skills
│   ├── jordan-belfuzz/                    ← Maps to ~/.openclaw/workspace-jordan-belfuzz/
│   │   ├── SOUL.md
│   │   ├── AGENTS.md
│   │   ├── TOOLS.md
│   │   ├── USER.md
│   │   └── skills/
│   ├── steve-mogniak/                     ← (same structure for all agents)
│   ├── donna-pawsen/
│   ├── karl-lagerfur/
│   ├── david-ogilwai/
│   ├── ernest-hemingwai/
│   ├── fred-moggers/
│   ├── warren-buffuzz/
│   └── alan-furring/
│
├── shared-skills/                         ← Skills available to ALL agents
│                                            Maps to ~/.openclaw/skills/ on EC2
│
├── deploy/
│   ├── openclaw.agents.jsonc              ← Template for agents.list + bindings in openclaw.json
│   └── sync.sh                            ← Script to push workspace files to EC2
│
├── scripts/                               ← Agent SDK entry points (Python/TypeScript)
└── docs/
    └── architecture/
```

### Why Two Agent Directories?

**`workspaces/`** — OpenClaw workspace files. These define who each agent IS: personality (SOUL.md), instructions (AGENTS.md), tool usage (TOOLS.md), user context (USER.md), and skills. These files are injected into the agent's system prompt by OpenClaw at runtime. **This is the identity layer.** On EC2, each folder maps to `~/.openclaw/workspace-{agentId}/`.

**`.claude/agents/`** — Claude Agent SDK subagent definitions. These define how agents are INVOKED programmatically by the SDK when running scripts. Thin markdown files with YAML frontmatter. **This is the execution layer.**

When building a new agent, always create BOTH: the OpenClaw workspace in `workspaces/` AND the SDK definition in `.claude/agents/`.

---

## OpenClaw Workspace File Conventions

### SOUL.md
The agent's personality and identity. Written in second person ("You are Jordan Belfuzz..."). Contains: name, role, namesake explanation, personality traits, communication style, values, and behavioral boundaries. This is who the agent IS — it doesn't change between tasks.

### AGENTS.md
Operational instructions and guardrails. Contains: team structure, routing rules (who to delegate to and when), escalation policies, decision authority, workflow patterns, and coordination protocols. For Gizmo, this includes the full routing table mapping task types to agent IDs. For specialized agents, this includes how to receive tasks from Gizmo and how to report back.

### TOOLS.md
Tool-specific instructions. Contains: which tools the agent has access to, how to use session tools for inter-agent communication, any tool-specific constraints or best practices. For agents that use the Claude Agent SDK, this documents when and how to invoke SDK scripts.

### USER.md
Context about Yaya (the sole human). Contains: role, preferences, communication style, decision-making patterns, things the agent should know about the owner. Shared across all agents (with minor per-agent variations if needed).

### skills/
Per-agent skill definitions following the SKILL.md format with YAML frontmatter. Skills contain the institutional knowledge — the playbooks for specific tasks. Each skill folder contains a SKILL.md and optional examples/.

---

## Deployment Workflow

When a new agent is ready to go live:

1. **Build workspace files locally** — SOUL.md, AGENTS.md, TOOLS.md, USER.md, and skills
2. **Push to GitHub** — `git push` to the `gremlin-garage` repo
3. **Sync to EC2** — Run `deploy/sync.sh {agent-id}` which copies workspace files to `~/.openclaw/workspace-{agentId}/` on the server
4. **Register the agent** — Add the agent to `agents.list` in `openclaw.json` on EC2 (use `deploy/openclaw.agents.jsonc` as reference)
5. **Add bindings** — Configure channel routing (Slack profile, DM routing, group mentions) in `bindings[]`
6. **Copy auth profiles** — If the agent needs API access, copy relevant credentials from main agent's auth-profiles.json
7. **Restart gateway** — `systemctl --user restart openclaw-gateway.service` — agent is live
8. **Verify** — Run `openclaw agents list --bindings` to confirm routing

### Updating an Existing Agent

1. Edit workspace files in `workspaces/{agent-id}/`
2. Push to GitHub
3. Run `deploy/sync.sh {agent-id}`
4. Restart gateway (or wait for the agent to pick up changes on next session)

---

## Key Principles

### 1. OpenClaw Is the Source of Truth for Identity
SOUL.md, AGENTS.md, TOOLS.md, and USER.md define who the agent is. These files are what OpenClaw injects into the system prompt. If it's not in these files, the agent doesn't know it.

### 2. Skills Are the IP, Scripts Are the Wiring
Skills (SKILL.md files) contain the institutional knowledge — the playbooks. Scripts (Python/TypeScript) are thin config layers that tell the SDK which skill to run, which model, which tools. When you improve a skill, every script that uses it improves automatically.

### 3. Gizmo Routes, Specialists Execute
Gizmo's job is orchestration. He receives tasks, determines which agent should handle them, delegates via `sessions_send`, and monitors quality. Specialized agents focus on their domain and report results back.

### 4. GitHub Is the Single Source of Truth for Code
Workspace files, skills, scripts, agent definitions — everything lives in version control. Updating an agent = merging a PR + syncing to EC2. Every change is reviewable and reversible.

### 5. Right-Size the Model
Default to Sonnet for execution. Opus only for genuinely complex reasoning. Haiku for routing and classification. Never pay for Opus when Sonnet will do.

### 6. Build Agents One at a Time
Do NOT try to build all agents simultaneously. Pick one, get their workspace files right, build their first skill, test with real inputs, iterate. Then move to the next. Gizmo first, always.

---

## Building a New Agent — Checklist

When Claude Code is asked to build or set up a new agent, follow this sequence:

1. **Create the OpenClaw workspace** — All four files in `workspaces/{slug}/`:
   - `SOUL.md` — personality and identity
   - `AGENTS.md` — operational instructions and routing
   - `TOOLS.md` — tool-specific guidance
   - `USER.md` — copy from shared template, customize if needed
2. **Create initial skills** — At least one skill in `workspaces/{slug}/skills/`
3. **Create the SDK definition** — `.claude/agents/{slug}.md` with YAML frontmatter
4. **Create the deploy config** — Add agent entry to `deploy/openclaw.agents.jsonc`
5. **Update Gizmo's AGENTS.md** — Add the new agent to Gizmo's routing table so he knows when to delegate to them
6. **Test with real inputs** — Not contrived examples. Real messy data from the actual workflow.
7. **Deploy** — Run `deploy/sync.sh {slug}`, register in openclaw.json, restart gateway

---

## SDK Configuration Reminders

- Always set `setting_sources=["project"]` — without this, the SDK ignores CLAUDE.md and skills
- Only grant tools the skill actually needs — extra tools expand context and increase cost
- Skill descriptions must be specific trigger conditions, not vague summaries
- Run scripts from the project root (where this CLAUDE.md lives)
- MCP servers are defined per script call (stateless): HubSpot, Slack, Notion, Clay, ClickUp

---

## OpenClaw Configuration Reminders

- Anthropic baseUrl must be `https://api.anthropic.com` (NOT `/v1` — OpenClaw appends it)
- Models use `provider/model-id` format: `anthropic/claude-sonnet-4-20250514`
- Config changes require edits to BOTH `openclaw.json` AND `models.json` to persist through restarts
- Use `openclaw doctor` to check provider cooldown states
- Never init git inside `~/.openclaw/workspace/` — GitHub projects go in `~/projects/`
- Auth profiles are per-agent at `~/.openclaw/agents/{agentId}/agent/auth-profiles.json`
- Never reuse agentDir across agents (causes auth/session collisions)
- Shared skills go in `~/.openclaw/skills/`, per-agent skills in the workspace `skills/` folder

---

## Infrastructure Quick Reference

| Resource | Value |
|---|---|
| EC2 Instance | i-033c0b7a321c95411 (t4g.small, ARM64) |
| IP | 3.141.85.81 |
| SSH | `ssh -i ~/Downloads/openclaw-key.pem ubuntu@3.141.85.81` |
| Dashboard tunnel | `ssh -N -L 18789:127.0.0.1:18789 -i ~/Downloads/openclaw-key.pem ubuntu@3.141.85.81` |
| Gateway service | `systemctl --user start/stop/restart openclaw-gateway.service` |
| Logs | `journalctl --user -u openclaw-gateway.service -f` |
| Agent list | `openclaw agents list --bindings` |
| GitHub | `github.com/yannick3010/gremlin-garage` |

---

## First Portco: OpenClaw One-Click Deploy

A product that lets non-technical people deploy their own OpenClaw instance through a simple web experience. User fills out an onboarding form, answers a few questions, and within minutes has a fully configured AI agent messaging them on Telegram or Slack.

This portco will have its own repo (separate from this one). Steve Mogniak leads the engineering.

---

## What NOT to Do

- Do not build all agents at once. Build one, test it, then move on.
- Do not put secrets, API keys, or credentials in any file. Use environment variables and OpenClaw auth profiles.
- Do not create skills without the YAML frontmatter `description` field.
- Do not give agents tools they don't need. Principle of least privilege.
- Do not skip testing with real inputs.
- Do not modify another agent's workspace files unless explicitly asked by Yaya or delegated by Gizmo.
- Do not reuse agentDir across agents — it causes auth/session collisions.
