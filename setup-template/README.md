# Gremlin Garage — OpenClaw Setup Template

Automated provisioning for white-glove OpenClaw installations.

---

## What's This?

A template to quickly spin up new OpenClaw instances for clients. 
Handles the technical setup so you can focus on the service.

---

## Directory Structure

```
setup-template/
├── provision-user.sh      # Main provisioning script
├── openclaw.json.template # Config template
├── workspace/
│   ├── USER.md.template     # User context template
│   ├── SOUL.md.template     # AI personality template  
│   ├── MEMORY.md.template   # Memory system template
│   ├── TASKS.md.template    # Task tracker template
│   └── IDENTITY.md.template # AI identity template
└── README.md
```

---

## Quick Start

### 1. Set Environment Variables

```bash
export ANTHROPIC_KEY="sk-ant-..."
export TELEGRAM_TOKEN="123456:ABC-DEF1234ghIkl-zyx57W2v1u123ew11"
```

### 2. Provision a User

```bash
./provision-user.sh john_doe 123456789 john@example.com
```

### 3. Configure & Start

```bash
cd ~/.openclaw/instances/john_doe
nano openclaw.json  # Add user's specific config
./start.sh
```

---

## What Gets Created

Each user instance:
- `~/.openclaw/instances/<username>/`
- `openclaw.json` — Configured for their setup
- `workspace/` — Personal AI environment
- `start.sh` — One-command startup

---

## Per-User Customization

Edit these files after provisioning:
- `workspace/USER.md` — Who the user is
- `workspace/SOUL.md` — AI personality
- `openclaw.json` — API keys, channels

---

## Future Enhancements

- [ ] Docker image for one-command deploy
- [ ] Ansible playbook for VPS provisioning
- [ ] Web UI for client management
- [ ] Automated Telegram bot pairing
- [ ] Subscription/billing integration

---

## Cost Breakdown

Per user (rough):
- VPS: $5-20/month (DigitalOcean, Hetzner, etc.)
- API calls: $10-50/month (depends on usage)
- Your time: Setup ~30min → target ~10min

---

## Support

Built for Gremlin Garage by Gizmo 🤖
