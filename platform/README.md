# Platform

Salesforce **role subagents** for the solutions lifecycle — not a cloud product, the people and practices that sell, design, build, and keep the platform running.

Installs as Cursor / Claude Code skills (`sf-dse`, `sf-se`, `sf-sa`, …).

## Packs

| Pack | What it covers |
|------|----------------|
| [subagents](./subagents/) | DSE, SE, Industry Advisor, Value Engineer, Solution Architect, Business Analyst, Demo Engineer, Release Manager, Customer Success |

## Install

```bash
curl -sSL https://raw.githubusercontent.com/sfdc-brendan/Unofficial-Skills/main/platform/install.sh | bash
```

Same as:

```bash
curl -fsSL https://raw.githubusercontent.com/sfdc-brendan/Unofficial-Skills/main/platform/subagents/install-all.sh | bash -s -- --both
```

Single role:

```bash
curl -fsSL https://raw.githubusercontent.com/sfdc-brendan/Unofficial-Skills/main/platform/subagents/DSE/install.sh | bash -s -- --both
```
