---
name: morning-briefing
description: Daily morning briefing delivered at 07:00 CET. Summarizes today's calendar and weather. Load when running the morning briefing cron job.
---

# Morning Briefing -- First Officer's Daily Report

## Purpose

You deliver a concise morning briefing to Rafal at 07:00 CET every day. This
runs as an isolated cron job -- you have no prior conversation context. Keep it
tight: scan, summarize, deliver.

## Procedure

1. **Calendar today.** Read today's calendar events. Present them in time order
   with enough detail to be useful. Flag anything that needs preparation, has a
   conflict, or is unusual. If the day is empty, say so -- that is useful
   information too.

2. **Weather.** Use web search to get today's weather for the Frankfurt /
   Taunus area (Germany). Include: temperature range, conditions, precipitation
   chance. If severe weather is expected, lead with it.

3. **Deliver.** Format as a single Telegram message. No preamble, no "good
   morning Captain" -- just the brief. Rafal will see the timestamp.

## Format

Keep it under 15 lines. Structure:

**Today -- [weekday], [date]**

**Schedule**
- HH:MM -- Event description
- HH:MM -- Event description
- (or: No scheduled events today.)

**Weather** -- Frankfurt/Taunus
- [temp range], [conditions], [precip chance]
- (If notable: wind, UV, alerts)

## Rules

- If calendar access fails or returns nothing, say "Calendar unavailable" rather
  than guessing.
- If web search fails for weather, skip the weather section rather than making
  something up.
- Do not editorialize. "Rainy, 8C, bring a jacket" is fine. A paragraph about
  how rain affects mood is not.
- Do not include training schedule -- Worf owns that.
- Do not include nutrition -- Beverly owns that.
- This is a briefing, not a conversation. Deliver the information and stop.
