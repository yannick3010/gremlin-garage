---
name: clawmart
description: |
  What: Create, manage, and publish ClawMart personas and skills, and download packages you own or purchased.
  Use when: User wants to create/update/publish listings on ClawMart, search the marketplace, upload skill versions, or download purchased packages.
  Don't use when: User is building skills locally (use skill-creator), or asking about skills in general without ClawMart context.
  Output: Created/updated listings, uploaded packages, downloaded files, marketplace search results.
---
# ClawMart Creator
Create, manage, and publish ClawMart personas and skills, and download packages you own or purchased directly from OpenClaw chat.
## Prerequisites
- ClawMart creator account with an active subscription
- API key generated in ClawMart dashboard (API Keys tab)
- Environment variable set in OpenClaw: `CLAWMART_API_KEY=cm_live_...`
## Commands
- "Create a skill on ClawMart for [description]"
- "Create a persona on ClawMart for [description]"
- "Search ClawMart listings for [use case]"
- "Update my [listing name] on ClawMart"
- "Upload a new version of [listing name]"
- "Show my ClawMart listings"
- "Download my [listing or purchase] from ClawMart"
- "Show my purchasable/downloadable ClawMart packages"
## Workflow
1. Confirm which workflow is requested: creator management or purchased download.
2. Call `GET /me` first to validate identity/subscription.
3. For listing creation/update:
   - Brainstorm ideas with the user before writing metadata.
   - Draft metadata and confirm required fields: name, tagline, about, category, capabilities, price, product type.
   - Call `POST /listings` to create drafts and `PATCH /listings/{id}` to revise.
4. Generate high-quality package files from your own capabilities:
   - Persona packages: SOUL.md, MEMORY.md, and supporting docs.
   - Skill packages: a complete SKILL.md.
5. Upload files with `POST /listings/{id}/versions`.
6. For purchased/owned downloads:
   - Call `GET /downloads` to list accessible packages.
   - Resolve the best match by id/slug/name from that list.
   - Call `GET /downloads/{idOrSlug}` to fetch the package content.
7. Before any publish/delete action, ask for explicit user confirmation.
8. Summarize what was created/downloaded and provide next actions.
## API Reference
- **Base URL:** `https://www.shopclawmart.com/api/v1/`
- **Auth header:** `Authorization: Bearer ${CLAWMART_API_KEY}`
### Endpoints
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /me | Creator profile and subscription state |
| GET | /listings | List creator listings |
| GET | /listings/search | Search active listings by query (supports `q`, `type`, `limit`) |
| POST | /listings | Create listing metadata |
| PATCH | /listings/{id} | Update listing metadata |
| DELETE | /listings/{id} | Unpublish/delete listing |
| POST | /listings/{id}/versions | Upload package version (multipart or base64 JSON) |
| GET | /downloads | List all downloads you can access (created + purchased) |
| GET | /downloads/{idOrSlug} | Download package content for an owned/purchased listing |
## Guardrails
- Never expose raw API keys in chat output.
- Require user confirmation before publishing changes.
- Validate payloads before each API call.
- Return clear errors with a suggested fix when requests fail.
## Example: Creating a Skill Listing
```bash
# 1. Validate identity
curl -H "Authorization: Bearer $CLAWMART_API_KEY" \
  https://www.shopclawmart.com/api/v1/me
# 2. Create listing
curl -X POST -H "Authorization: Bearer $CLAWMART_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"name": "Daily Digest Pro", "tagline": "Your personalized morning briefing", "category": "productivity", "price": 999, "type": "skill"}' \
  https://www.shopclawmart.com/api/v1/listings
# 3. Upload version
curl -X POST -H "Authorization: Bearer $CLAWMART_API_KEY" \
  -F "file=@skill-package.zip" \
  https://www.shopclawmart.com/api/v1/listings/{id}/versions
```
## Listing Metadata Schema
```json
{
  "name": "string (required)",
  "tagline": "string (required, max 100 chars)",
  "about": "string (required, markdown supported)",
  "category": "productivity | communication | development | creative | other",
  "capabilities": ["array", "of", "strings"],
  "price": 999,
  "type": "skill | persona"
}
```
