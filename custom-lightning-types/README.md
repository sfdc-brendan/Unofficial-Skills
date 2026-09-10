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

Compatible with **Cursor**, **Claude Code**, **Windsurf**, **Codex**, and any AI coding agent with a skills directory.

---

## Quick Install

Copy and paste into your terminal:

```bash
curl -sSL https://raw.githubusercontent.com/sfdc-brendan/Unofficial-Skills/main/custom-lightning-types/install.sh | bash
```

Or with `wget`:

```bash
wget -qO- https://raw.githubusercontent.com/sfdc-brendan/Unofficial-Skills/main/custom-lightning-types/install.sh | bash
```

The installer auto-detects your IDE (Cursor, Claude Code, Windsurf, Codex) and installs **only** this pack: `sf-clt-builder`, `agentforce-lightning-types`, and the Cursor rule. No git clone required. Restart your IDE after installing.

---

## What gets installed

| Skill / rule | Role |
|--------------|------|
| `sf-clt-builder` | Generate the DTO, Invocable, Lightning Type bundle, LWC, and GenAiFunction. Pick the surface first. |
| `agentforce-lightning-types` | Debug a card that deploys but will not render (ShowCommand vs InformCommand, ECv2 Connection, ESD republish). |
| `agentforce-lightning-types.mdc` | Cursor rule that fires on `lightningTypes/**` files so envelope mistakes get caught while editing. |

---

## How it works

Read **[docs/HOW-IT-WORKS.md](./docs/HOW-IT-WORKS.md)** before you generate anything. It covers:

1. The four artifacts and why their names must join explicitly
2. The JSON-string envelope (the pattern that actually deploys)
3. Why the planner must emit `show_command` or the LWC never mounts
4. Where cards render (all four surfaces) vs where buttons can write back (not portable)
5. SRA chat write-back: `acc:execute` vs `copytochat` vs sending to the customer
6. Deploying the metadata to an org, and the checklist for a card that renders as text

Official Salesforce reference for the channel folders: [Lightning Type UI Configuration](https://developer.salesforce.com/docs/platform/lightning-types/guide/lightning-types-ui-config.html).

---

## Installation

### One-Line Install (Recommended)

```bash
curl -sSL https://raw.githubusercontent.com/sfdc-brendan/Unofficial-Skills/main/custom-lightning-types/install.sh | bash
```

Downloads this folder from GitHub and installs the skills. Auto-detects Cursor (`~/.cursor/skills/`), Claude Code (`~/.claude/skills/`), Windsurf (`~/.windsurf/skills/`), and Codex (`~/.codex/skills/`). No git clone required.

### Install From Clone

```bash
git clone https://github.com/sfdc-brendan/Unofficial-Skills.git
cd Unofficial-Skills/custom-lightning-types
bash install.sh
```

When run from a local clone, the installer copies files directly instead of downloading.

### Manual Install

```bash
# Cursor
cp -R sf-clt-builder agentforce-lightning-types ~/.cursor/skills/
cp rules/agentforce-lightning-types.mdc ~/.cursor/rules/

# Claude Code
cp -R sf-clt-builder agentforce-lightning-types ~/.claude/skills/

# Windsurf
cp -R sf-clt-builder agentforce-lightning-types ~/.windsurf/skills/
```

---

## Ask the agent

Once the skills are installed, start a new agent session and try:

> Build a Custom Lightning Type for the Service Rep Assistant that shows appointment windows and books the selected slot.

> This CLT deploys but the agent just describes the data in text. Debug it.

> Add a Book button that sends an utterance into the SRA panel so the planner runs Book Technician Visit.

---

## Updating

Re-run the one-liner to update to the latest version:

```bash
curl -sSL https://raw.githubusercontent.com/sfdc-brendan/Unofficial-Skills/main/custom-lightning-types/install.sh | bash
```

The installer overwrites existing skill files with the latest versions from GitHub.

---

## Disclaimer

Unofficial. Not affiliated with or endorsed by Salesforce.

SRA write-back uses host DOM events (`copytochat`, `acc:execute`) that are **verified empirically in the Service Rep Assistant panel** and are **not in Salesforce reference documentation**. They only fire in that panel, with Service Assistant in Dynamic Plan mode. The documented equivalents on other surfaces are `lightning/accApi` `execute()` (Employee LEX) and `configuration.util.sendTextMessage()` (Enhanced Chat v2). A card wired to one host is silent on the others.
