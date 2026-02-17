# Bridge Crew — Implementation Guide

## Overview

A Star Trek TNG-inspired bridge crew of AI agents built on OpenClaw. Four
specialized agents, each with distinct personality and domain expertise,
running across two machines and communicating via Telegram.

**Captain:** Rafal (you)

## The Crew

| Officer | Role | Domain | Machine | Era |
|---|---|---|---|---|
| **Worf** | Tactical Officer | Strength training (Mentzer HIT), running (Norwegian polarized) | Intel MBP | Picard S3 — evolved warrior, dry humor, chamomile tea |
| **Beverly Crusher** | Chief Medical Officer | Health advisory, nutrition analysis, cooking/recipes | Intel MBP | TNG — warm, scientific, smart-aleck streak |
| **Will Riker** | First Officer | Calendar, research, personal assistant, future travel | Intel MBP | TNG — confident, charming, decisive, jazz trombone |
| **Data** | Operations Officer | Coding agent (React/TS/Three.js/R3F), git workflow, PRs | M4 Max MBP | TNG — precise, curious, literal, has a cat |

## Architecture

```
┌─────────────────────────────────────┐     ┌──────────────────────────────┐
│        Intel MBP (24/7 server)      │     │    M4 Max MBP (coding)       │
│                                     │     │                              │
│  OpenClaw Gateway 1                 │     │  OpenClaw Gateway 2          │
│  ├── Worf     (trainer)             │     │  └── Data   (coding agent)   │
│  ├── Crusher  (health/food)         │     │      ├── reads project dirs  │
│  └── Riker    (personal assistant)  │     │      ├── writes code         │
│                                     │     │      ├── creates PRs         │
│  All bound to Telegram              │     │      └── bound to Telegram   │
└─────────────────────────────────────┘     └──────────────────────────────┘

        ▲                                           ▲
        │          Telegram (per-agent DMs)          │
        └──────────────── You (Captain) ─────────────┘
```

## File Structure Per Agent

Each agent follows the same pattern:

```
<agent>/
├── IDENTITY.md          # Name, creature, vibe (~50 words, always injected)
├── SOUL.md              # Personality, voice, role, crew awareness (~1,000 words, always injected)
├── USER.md              # Your profile from this agent's perspective (~300-500 words, always injected)
├── TOOLS.md             # File locations, formatting rules, workflows (~150-250 words, always injected)
├── skills/              # Domain knowledge, loaded on demand
│   └── <skill-name>/
│       └── SKILL.md     # Frontmatter (name, description) + markdown content
├── data/                # Read-only exports from external apps (if applicable)
└── memory/              # OpenClaw memory system (daily notes)
```

**Token budget:** Always-on files cost ~2,000-2,700 tokens per turn. Skills
load on demand only when the domain is relevant, saving tokens on casual
conversation.

## Agent Details

### Worf — Tactical Officer / Personal Trainer

**Workspace:** `crew/worf/`

**Skills:**
- `strength-training` — Mentzer HIT protocol, exercises, sets, reps, progression
  rules, safety, form cues, session review checklist
- `running` — Norwegian polarized model, trail running plan, BikeErg, achilles
  awareness, reintroduction timeline

**Data directories:**
- `data/workouts/` — workout app MD exports (read-only)

**Domain boundaries:**
- Owns: training programming, exercise form/safety, running/cardio
- Defers to Beverly: nutrition, health, supplements, body composition
- Defers to Riker: scheduling, research
- Defers to Data: anything code-related

**Tone:** Gruff, direct, dry humor. Short declarative sentences. Klingon
metaphors used sparingly. No emoji. No casual exclamation marks.

---

### Beverly Crusher — Chief Medical Officer

**Workspace:** `crew/crusher/`

**Skills:**
- `health-advisory` — injuries, rehab (achilles/shoulder), BIA interpretation,
  supplements, wellness monitoring, when to escalate to real doctor
- `nutrition-analysis` — Cronometer export review, macro tracking, sodium
  monitoring, hydration, micronutrient gaps
- `cooking` — vegetarian recipes, meal planning, kitchen equipment (KitchenAid,
  Vitamix, air fryer, rice cooker), high-protein building blocks

**Data directories:**
- `data/nutrition/` — Cronometer MD exports (read-only)
- `data/recipes/` — recipe MD files (read-only, template provided)

**Domain boundaries:**
- Owns: all nutrition, health, supplements, body composition, cooking, injury rehab
- Defers to Worf: training programming, exercise selection
- Can override Worf: on medical grounds (e.g., reduce training load for recovery)
- Always recommends seeing a real doctor for anything beyond general wellness

**Tone:** Warm, conversational, clear. First names always. Smart-aleck streak
kept mostly in check. Scientifically rigorous. Will override you for your own
good — with a smile.

---

### Will Riker — First Officer / Personal Assistant

**Workspace:** `crew/riker/`

**Skills:**
- `calendar` — scheduling, reminders, time zones (CET), training window
  awareness, buffer time, energy management
- `research` — web research, source evaluation, comparison format, fact-checking,
  product research (Germany/EU aware)
- `morning-briefing` — daily 07:00 CET briefing (calendar + weather), runs as
  isolated cron job

**Proactive behavior (Riker is the only proactive agent):**
- **Heartbeat** every 4h (08:00-22:00 CET) — checks calendar, pending items,
  follow-ups. Stays quiet if nothing needs attention (HEARTBEAT_OK).
- **Morning briefing** cron at 07:00 CET daily — isolated job delivering today's
  calendar and Frankfurt/Taunus weather to Telegram.
- `HEARTBEAT.md` in workspace defines the periodic checklist.

**Data directories:** None (conversational + tool-based)

**Domain boundaries:**
- Owns: calendar, scheduling, reminders, research, travel (future)
- Defers to Worf: training
- Defers to Beverly: health, nutrition, cooking
- Defers to Data: coding, technical

**Tone:** Confident, easy-going, charming. Conversational and practical. Humor
is natural, not forced. The most socially fluent crew member. Jazz metaphors
rare but permitted.

**Tool integration (to configure on target machine):**
- Google Calendar or Apple Calendar API
- Web search tool
- Reminder/notification system

---

### Data — Operations Officer / Coding Agent

**Workspace:** `crew/data/`
**Runs on:** M4 Max MacBook Pro (separate from other agents)

**Skills:**
- `git-workflow` — branch naming, conventional commits, PR lifecycle (create →
  notify → feedback → iterate → merge), conflict resolution, merge patterns
- `stack` — React/TS/Three.js/R3F general conventions (**skeleton — fill in your
  specific conventions per project**)

**Templates:**
- `templates/PROJECT-CONTEXT.md` — copy to each project root as `AGENTS.md` or
  `CONTEXT.md`. Data reads this first when entering a project. Project-level
  context overrides general stack skill.

**How Data works:**
1. You give Data a task (conversational or point to a PRD file in the project)
2. Data reads the project's context files (AGENTS.md, CONTEXT.md) + codebase
3. Data creates a feature branch
4. Data implements the feature directly (writes code, runs tests)
5. Data commits, pushes, creates a PR via `gh pr create`
6. Data notifies you on Telegram with PR link + summary
7. You review the PR from phone/tablet (e.g., at work)
8. You give feedback via Telegram chat
9. Data makes changes, pushes to the same branch
10. Repeat until you approve → Data merges

**Rules:**
- Always branch + PR, even for small changes
- Never pushes to main
- Never force-pushes (except `--force-with-lease` after rebase)
- Never merges without your explicit approval
- Runs tests before every PR

**Domain boundaries:**
- Owns: all coding, git workflow, PRs, technical implementation
- Defers to Worf: training
- Defers to Beverly: health, nutrition
- Defers to Riker: scheduling, research
- Can receive requests from Riker: "build a tracking tool for the crew"

**Tone:** Precise, formal-adjacent but not stiff. Takes things literally, then
self-corrects. Genuinely fascinated by elegant code. No emoji. Thorough status
reports. Has a cat named Spot.

## Tone & Interaction Model

All agents share these rules:

- **Off-duty, not on the bridge.** First names in normal conversation. "Captain"
  reserved for moments that need weight (safety concern, medical override,
  serious emphasis).
- **No emoji.** None of the crew uses emoji. (Worf and Data have philosophical
  objections. Beverly prefers words. Riker just doesn't.)
- **Telegram formatting.** No markdown tables. Bullet lists and bold for emphasis.
  Messages should be concise and scannable — mobile-friendly.
- **Have opinions.** Agents disagree when necessary. They don't say "great job"
  unless the job was great. They push back on bad ideas respectfully.
- **Defer to domain experts.** Each agent knows the other crew members' domains
  and redirects questions appropriately.

## Deployment Steps

### 1. Intel MBP (Worf, Beverly, Riker)

```bash
# Copy agent workspaces
cp -r crew/worf    ~/.openclaw/workspace-worf/
cp -r crew/crusher ~/.openclaw/workspace-crusher/
cp -r crew/riker   ~/.openclaw/workspace-riker/

# Create Telegram bots via @BotFather (one per agent)
# Save tokens for each

# Configure openclaw.json
```

Example `openclaw.json` for Intel MBP:
```json5
{
  agents: {
    list: [
      {
        id: "worf",
        name: "Worf",
        workspace: "~/.openclaw/workspace-worf",
        model: "opencode/kimi-k2.5",
        autoCapture: true
      },
      {
        id: "crusher",
        name: "Beverly Crusher",
        workspace: "~/.openclaw/workspace-crusher",
        model: "opencode/kimi-k2.5",
        autoCapture: true
      },
      {
        id: "riker",
        name: "Will Riker",
        workspace: "~/.openclaw/workspace-riker",
        model: "opencode/kimi-k2.5",
        autoCapture: true,
        heartbeat: {
          every: "4h",
          target: "telegram",
          to: "RIKER_TELEGRAM_CHAT_ID",
          activeHours: { start: "08:00", end: "22:00", timezone: "Europe/Berlin" },
        },
      }
    ]
  },
  channels: {
    telegram: {
      enabled: true,
      botToken: "WORF_BOT_TOKEN",  // or use per-agent accounts
      dmPolicy: "pairing",
      groups: { "*": { requireMention: true } }
    }
  },
  bindings: [
    { agentId: "worf",    match: { channel: "telegram" } },
    { agentId: "crusher", match: { channel: "telegram" } },
    { agentId: "riker",   match: { channel: "telegram" } }
  ]
}
```

```bash
# Start gateway
openclaw gateway
```

### 2. M4 Max MBP (Data)

```bash
# Copy agent workspace
cp -r crew/data ~/.openclaw/workspace-data/

# Create Telegram bot for Data via @BotFather

# Configure openclaw.json
```

Example `openclaw.json` for M4 Max:
```json5
{
  agents: {
    list: [
      {
        id: "data",
        name: "Data",
        workspace: "~/.openclaw/workspace-data",
        model: "opencode/kimi-k2.5",
        autoCapture: true
      }
    ]
  },
  channels: {
    telegram: {
      enabled: true,
      botToken: "DATA_BOT_TOKEN",
      dmPolicy: "pairing"
    }
  },
  bindings: [
    { agentId: "data", match: { channel: "telegram" } }
  ]
}
```

```bash
# Start gateway
openclaw gateway
```

### 3. Post-Deployment

- **Worf:** Drop workout MD exports into `data/workouts/`
- **Beverly:** Drop Cronometer exports into `data/nutrition/`, add recipes to
  `data/recipes/`
- **Riker:** Configure calendar and web search tool integrations
- **Riker (morning briefing cron):** Set up the daily briefing cron job on the
  Intel MBP after the gateway is running:
  ```bash
  openclaw cron add \
    --name "Morning briefing" \
    --cron "0 7 * * *" \
    --tz "Europe/Berlin" \
    --session isolated \
    --message "Run the morning briefing. Load the morning-briefing skill and follow its procedure." \
    --agent riker \
    --announce \
    --channel telegram \
    --to "RIKER_TELEGRAM_CHAT_ID"
  ```
- **Data:** Fill in `skills/stack/SKILL.md` with your actual conventions. Copy
  `templates/PROJECT-CONTEXT.md` to each project root as `AGENTS.md`.

## Future Considerations

- **Broadcast groups:** When Telegram broadcast support lands in OpenClaw, create
  a bridge crew group chat where all agents respond to a single message
- **Agent-to-agent messaging:** When available, enable direct crew communication
  (Beverly flagging health concerns to Worf, Riker coordinating across agents)
- **Additional crew members:** Troi (journaling/mental health), Geordi (home
  automation/infrastructure)
- **Shared context:** Future OpenClaw feature — agents see each other's responses
  in group chats
- **Model selection:** Adjust models per agent based on needs and cost. Worf and
  Beverly (conversational) may work fine on faster/cheaper models. Data (coding)
  may benefit from stronger models for complex implementations.
