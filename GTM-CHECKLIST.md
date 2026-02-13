# Gremlin Garage — GTM Checklist

## Day 1: Foundation

### Domain & Hosting
- [ ] Check domain availability: `gremlingarage.ai`, `gremlingarage.co`, `gremlin.garage`
- [ ] Register domain
- [ ] Set up DNS

### Business Infrastructure
- [ ] Create business email: hello@gremlingarage.ai
- [ ] Set up Stripe account (or verify existing)
- [ ] Create Stripe products:
  - [ ] OpenClaw Basic — $149
  - [ ] OpenClaw Pro — $299
  - [ ] OpenClaw Premium — $499
  - [ ] Monthly Maintenance — $99/mo (subscription)
- [ ] Set up Cal.com for booking calls (free tier)

### Brand Assets
- [ ] Create simple logo (can use AI tools)
- [ ] Define color palette
- [ ] Create social media profile images

---

## Day 2: Website Build

### Setup
- [ ] Create Framer or Webflow account
- [ ] Set up custom domain

### Pages to Build
- [ ] Homepage (use copy from WEBSITE-COPY.md)
- [ ] /openclaw-setup (★ Priority — this is the money page)
- [ ] /services (overview)
- [ ] /about
- [ ] /contact
- [ ] /book (Calendly/Cal.com embed)

### Integrations
- [ ] Stripe checkout on OpenClaw page
- [ ] Cal.com embed on /book
- [ ] Contact form → email or Notion
- [ ] Google Analytics or Plausible
- [ ] Meta Pixel (for retargeting later)

### Technical
- [ ] Mobile responsive
- [ ] Fast load time (<3s)
- [ ] SSL certificate active
- [ ] Test all CTAs and forms

---

## Day 3: Advertising Setup

### Google Ads Account
- [ ] Create/verify Google Ads account
- [ ] Add payment method
- [ ] Set daily budget ($100-150 to start)

### Campaign 1: High Intent Keywords
**Campaign name:** OpenClaw Setup - High Intent

**Keywords (Exact + Phrase match):**
```
[openclaw install]
[openclaw setup]
[openclaw setup service]
"openclaw installation"
"install openclaw for me"
"openclaw done for you"
[clawdbot setup]
[moltbot install]
```

**Ad Group 1 - Setup Service:**
```
Headline 1: OpenClaw Setup in 24 Hours
Headline 2: Done-For-You Installation
Headline 3: Skip the Docker Headaches
Description 1: Professional OpenClaw setup starting at $149. We handle installation, configuration, and custom skills.
Description 2: Stop debugging. Start automating. 100+ successful installs. Same-day service available.
```

**Ad Group 2 - Problem/Solution:**
```
Headline 1: OpenClaw Install Giving You Trouble?
Headline 2: We Fix It Fast — $149
Headline 3: 24-Hour Turnaround
Description 1: Docker errors? API confusion? We've done 100+ installs. Let us handle it so you can use AI agents today.
Description 2: Professional setup, custom skills included. Get back to business while we handle the technical stuff.
```

### Campaign 2: Problem Keywords
**Campaign name:** OpenClaw Setup - Problems

**Keywords:**
```
"openclaw docker error"
"openclaw not working"
"openclaw installation failed"
"how to install openclaw"
"openclaw npm error"
"openclaw setup guide"
```

### Campaign Settings
- [ ] Location: US, UK, Canada, Australia
- [ ] Language: English
- [ ] Devices: All (but monitor mobile vs desktop)
- [ ] Bid strategy: Maximize conversions (start) → Target CPA (once you have data)
- [ ] Landing page: gremlingarage.ai/openclaw-setup

### Conversion Tracking
- [ ] Set up conversion tracking in Google Ads
- [ ] Track: Purchase completed, Call booked
- [ ] Install Google Ads tag on site

---

## Day 3-4: Fulfillment Setup

### Intake Form (Google Form or Typeform)
Create form with fields:
- [ ] Name
- [ ] Email
- [ ] Package purchased (Basic/Pro/Premium)
- [ ] Platform (Mac / Linux / Windows / VPS)
- [ ] VPS provider (if applicable)
- [ ] Messaging apps to set up (Telegram / Discord / Slack / WhatsApp / Other)
- [ ] What do you want to automate? (free text)
- [ ] Preferred contact method (Email / Telegram / Discord)
- [ ] SSH access details OR "I need help setting up a VPS"
- [ ] Best time for onboarding call (Pro/Premium only)

### Email Templates
- [ ] Purchase confirmation + intake form link
- [ ] Onboarding call scheduled (Pro/Premium)
- [ ] Installation started
- [ ] Installation complete + handoff
- [ ] Day 3 follow-up + testimonial request
- [ ] Day 7 check-in (Pro/Premium)

### Fulfillment Checklist (per customer)
```markdown
## Customer: [Name]
- Package: [Basic/Pro/Premium]
- Platform: [Mac/Linux/VPS]
- Messaging: [Telegram/Discord/etc.]

### Pre-Install
- [ ] Intake form received
- [ ] Access credentials received
- [ ] Server accessible

### Installation
- [ ] OpenClaw installed
- [ ] Node.js/npm configured
- [ ] Docker running (if applicable)
- [ ] API keys configured (OpenAI/Anthropic/etc.)
- [ ] Messaging integration working
- [ ] Test message sent successfully

### Pro/Premium Add-ons
- [ ] Custom skills installed (list:)
- [ ] Browser automation configured
- [ ] Voice/TTS configured (Premium)

### Handoff
- [ ] Video walkthrough recorded
- [ ] Documentation sent
- [ ] Handoff email sent
- [ ] Customer confirmed working
- [ ] Access revoked

### Follow-up
- [ ] Day 3 follow-up sent
- [ ] Testimonial requested
- [ ] Testimonial received? [ ]
```

---

## Day 4-5: Organic Setup

### Twitter/X
- [ ] Create @GremlinGarage account
- [ ] Profile pic: Logo
- [ ] Bio: "Your AI Pit Crew 🔧 | OpenClaw setup & AI automation | We build agents that work while you sleep"
- [ ] Link: gremlingarage.ai
- [ ] Pin tweet: Value-add thread about OpenClaw or AI agents

### Content Calendar (Week 1)
| Day | Content Type | Topic |
|-----|--------------|-------|
| Mon | Thread | "What is OpenClaw and why is everyone talking about it?" |
| Tue | Tip | "3 skills every OpenClaw setup should have" |
| Wed | Behind scenes | "Just finished install #X for [industry] business" |
| Thu | Engagement | Reply to OpenClaw conversations |
| Fri | Offer | "Weekend special: Get your OpenClaw setup done by Monday" |
| Sat | Value | "The #1 mistake people make when setting up OpenClaw" |
| Sun | Social proof | Share testimonial or win |

### Reddit (Soft Presence)
- [ ] Identify relevant subreddits: r/OpenClaw, r/automation, r/artificial, r/SideProject
- [ ] Create account (don't use brand name)
- [ ] Provide genuine help first, build karma
- [ ] Soft-pitch only when highly relevant

---

## Week 1 Metrics Dashboard

### Daily Tracking
| Metric | Day 1 | Day 2 | Day 3 | Day 4 | Day 5 | Day 6 | Day 7 |
|--------|-------|-------|-------|-------|-------|-------|-------|
| Ad Spend | | | | | | | |
| Clicks | | | | | | | |
| CPC | | | | | | | |
| Conversions | | | | | | | |
| Revenue | | | | | | | |
| ROAS | | | | | | | |

### Weekly Summary
- Total ad spend: $___
- Total revenue: $___
- Total customers: ___
- Average order value: $___
- CAC: $___
- ROAS: ___x
- Testimonials collected: ___

---

## Quick Reference: Pricing

| Package | Price | What's Included |
|---------|-------|-----------------|
| Basic | $149 | Install + 1 messaging app + handoff |
| Pro | $299 | Install + all messaging + 3 skills + browser + 30-day support |
| Premium | $499 | Everything + 10 skills + voice + same-day + maintenance option |
| Maintenance | $99/mo | Ongoing support + updates |

---

## Emergency Contacts / Resources

- **Stripe Dashboard:** stripe.com/dashboard
- **Google Ads:** ads.google.com
- **Domain Registrar:** [TBD]
- **Website Editor:** [Framer/Webflow URL]
- **Cal.com:** cal.com/gremlingarage

---

*Go time. Let's hit $10K.* 🚀
