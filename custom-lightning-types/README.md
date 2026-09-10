# Custom Lightning Types

Unofficial skill pack for **Apex-based Custom Lightning Types** on Agentforce chat surfaces.

A Custom Lightning Type (CLT) is how an Agentforce action stops narrating JSON as prose and instead mounts an LWC — a card, a picker, a diagnostics panel — inside the chat host. **The same card can render on all four Agentforce chat surfaces:**

- **Enhanced Chat v2** (customer widget)
- **Service Rep Assistant** (LEX panel)
- **Employee Agent chat** (LEX panel)
- **Agentforce Cowork**

The Apex envelope is one pattern. What differs by surface is write-back (whether a button can talk back to the host), sharing, and the run-as user — not whether the card can show up.

This pack teaches an agent to **generate** those artifacts and **debug** them when they render as text. It also documents SRA-panel write-back: a card button that sends an utterance into the assistant as if the rep typed it.

**Not in this pack:** object-schema Lightning Types for Experience Builder, Prompt Builder, or Mosaic. Those are a different binding.

## Install in 30 seconds

From this folder, or from the repo root with `./install.sh custom-lightning-types`:

```bash
chmod +x install.sh
./install.sh --all
```

| Flag | What it does |
|------|----------------|
| `--all` | Install into every tool detected on this machine (Cursor, Claude Code, Codex) |
| `--cursor` | `~/.cursor/skills/` plus the Cursor rule in `~/.cursor/rules/` |
| `--claude` | `~/.claude/skills/` (Claude Code) |
| `--codex` | `~/.codex/skills/` |
| `--project [DIR]` | Install into a project's `.cursor/` / `.claude/` instead of the user home |
| `--symlink` | Point the skill dirs at this clone so `git pull` updates them |
| `--dry-run` | Print the plan, write nothing |
| `--uninstall` | Remove the skills and rule this pack installed |

New agent session after install. Cursor and Claude Code load user skills at session start.

## What gets installed

| Skill / rule | Role |
|--------------|------|
| `sf-clt-builder` | Generate the DTO, Invocable, Lightning Type bundle, LWC, and GenAiFunction. Pick the surface first. |
| `agentforce-lightning-types` | Debug a card that deploys but will not render (ShowCommand vs InformCommand, ECv2 Connection, ESD republish). |
| `agentforce-lightning-types.mdc` | Cursor rule that fires on `lightningTypes/**` files so envelope mistakes get caught while editing. |

## How it works

Read **[docs/HOW-IT-WORKS.md](./docs/HOW-IT-WORKS.md)** before you generate anything. It covers:

1. The four artifacts and why their names must join explicitly
2. The JSON-string envelope (the pattern that actually deploys)
3. Why the planner must emit `show_command` or the LWC never mounts
4. Where cards render (all four surfaces) vs where buttons can write back (not portable)
5. SRA chat write-back: `acc:execute` vs `copytochat` vs sending to the customer
6. Deploying the metadata to an org, and the checklist for a card that renders as text

Official Salesforce reference for the channel folders: [Lightning Type UI Configuration](https://developer.salesforce.com/docs/platform/lightning-types/guide/lightning-types-ui-config.html).

## Ask the agent

Once the skills are installed:

> Build a Custom Lightning Type for the Service Rep Assistant that shows appointment windows and books the selected slot.

> This CLT deploys but the agent just describes the data in text. Debug it.

> Add a Book button that sends an utterance into the SRA panel so the planner runs Book Technician Visit.

## Disclaimer

Unofficial. Not affiliated with or endorsed by Salesforce.

SRA write-back uses host DOM events (`copytochat`, `acc:execute`) that are **verified empirically in the Service Rep Assistant panel** and are **not in Salesforce reference documentation**. They only fire in that panel, with Service Assistant in Dynamic Plan mode. The documented equivalents on other surfaces are `lightning/accApi` `execute()` (Employee LEX) and `configuration.util.sendTextMessage()` (Enhanced Chat v2). A card wired to one host is silent on the others.
