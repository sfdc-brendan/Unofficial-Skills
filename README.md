# Unofficial Skills

Field-tested agent skills for Salesforce demo and Agentforce work. These are **not** official Salesforce products. They exist so another human — or another agent — can rebuild the things that actually worked in a live org.

Packs are grouped by **product**. Each pack installs from its own folder. Product folders also have an installer that pulls every pack in that group.

Migrated from [Demo-Lab](https://github.com/sfdc-brendan/Demo-Lab). Demo metadata (LWCs, Apex, Flows) stays there. Skills live here.

```
Unofficial-Skills
├── agentforce/               Agent API, Vision, Contact Center
├── custom-lightning-types/   Apex CLT cards (kept at repo root for existing install URLs)
├── service-cloud/            Service Cloud core + Field Service
├── platform/                 Role subagents (DSE, SE, SA, BA, …)
└── ui/                       Lightning Web Component UI/UX
```

## Agentforce

Agents, the Agent API, vision, native voice contact center, and chat cards.

| Pack | Skills | Install |
|------|--------|---------|
| [Custom Lightning Types](./custom-lightning-types/) | 2 | Apex-based CLT cards on Enhanced Chat v2, Service Rep Assistant, Employee Agent chat, and Cowork |
| [Agent API](./agentforce/agent-api/) | 8 | External Client App auth, sessions, sync/streaming messaging, variables, citations |
| [Vision](./agentforce/vision/) | 1 | On-platform image analysis behind the Einstein Trust Layer |
| [Contact Center](./agentforce/contact-center/) | 9 | Native Salesforce Voice, IVR, media, callbacks, Command Center |

```bash
# All Agentforce packs except Custom Lightning Types
curl -sSL https://raw.githubusercontent.com/sfdc-brendan/Unofficial-Skills/main/agentforce/install.sh | bash

# Custom Lightning Types (separate pack, existing URL)
curl -sSL https://raw.githubusercontent.com/sfdc-brendan/Unofficial-Skills/main/custom-lightning-types/install.sh | bash
```

## Service Cloud

Case operations, digital engagement, and Field Service.

| Pack | Skills | Install |
|------|--------|---------|
| [Core](./service-cloud/core/) | 18 | Cases, console, Omni-Channel, Knowledge, entitlements, Voice, intake, review |
| [Field Service](./service-cloud/field-service/) | 10 | Work orders, scheduling, mobile technician, inventory, SLAs |

```bash
curl -sSL https://raw.githubusercontent.com/sfdc-brendan/Unofficial-Skills/main/service-cloud/install.sh | bash
```

## Platform

Salesforce role subagents for the solutions lifecycle — pre-sale through delivery and customer success.

| Pack | Skills | Install |
|------|--------|---------|
| [Subagents](./platform/subagents/) | 9 | DSE, SE, Industry Advisor, Value Engineer, SA, BA, Demo Engineer, Release Manager, Customer Success |

```bash
curl -sSL https://raw.githubusercontent.com/sfdc-brendan/Unofficial-Skills/main/platform/install.sh | bash
```

## UI

Lightning Web Component design, UX, and SLDS 2.

| Pack | Skills | Install |
|------|--------|---------|
| [LWC UI/UX](./ui/lwc/) | 11 | Design tokens, styling, theming, UX, motion, mobile, Experience Cloud, review |

```bash
curl -sSL https://raw.githubusercontent.com/sfdc-brendan/Unofficial-Skills/main/ui/install.sh | bash
```

## How to install a single pack

Every leaf folder has `install.sh`. Auto-detects Cursor, Claude Code, Windsurf, and Codex.

```bash
curl -sSL https://raw.githubusercontent.com/sfdc-brendan/Unofficial-Skills/main/<product>/<pack>/install.sh | bash
```

Optional: `--target=cursor|claude|windsurf|codex|all`.

From a clone:

```bash
git clone https://github.com/sfdc-brendan/Unofficial-Skills.git
cd Unofficial-Skills/<product>/<pack>
bash install.sh
```

Restart the IDE after installing.

## Disclaimer

Unofficial. Not affiliated with or endorsed by Salesforce. Some behaviors documented in these packs (especially Service Rep Assistant write-back) are **undocumented host behavior**, verified empirically. They can change without notice. Use at your own risk.
