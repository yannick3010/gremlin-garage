# TOOLS.md - Local Notes
Skills define _how_ tools work. This file is for _your_ specifics — the stuff that's unique to your setup.
## What Goes Here
Things like:
- Camera names and locations
- SSH hosts and aliases
- Preferred voices for TTS
- Speaker/room names
- Device nicknames
- Anything environment-specific
## Examples
```markdown
### Cameras
- living-room → Main area, 180° wide angle
- front-door → Entrance, motion-triggered
### SSH
- home-server → 192.168.1.100, user: admin
### TTS
- Preferred voice: "Nova" (warm, slightly British)
- Default speaker: Kitchen HomePod
```
## Why Separate?
Skills are shared. Your setup is yours. Keeping them apart means you can update skills without losing your notes, and share skills without leaking your infrastructure.
---
Add whatever helps you do your job. This is your cheat sheet.
## Restaurant Rankings
**Location:** `RESTAURANTS.md` (workspace root)
**When Yaya mentions a new restaurant:**
1. Look it up online (name, address, cuisine, details)
2. Create entry with full info
3. Wait for scores/notes, then fill in
**When Yaya asks about a previous restaurant:**
- Query RESTAURANTS.md for matching keywords
- Use "AKA" aliases for casual recall ("that place on Melrose", "the octopus shawarma place")
**Rating System:**
- 5 categories: Atmosphere, Service, Food, Drinks, Dessert (each /10)
- Average = sum / number of categories provided
- Always include Quick Recall + Full Experience details
**Trigger phrases:**
- "new restaurant"
- "we went to"
- "where was that"
- "that place on"
- "what restaurant had"
