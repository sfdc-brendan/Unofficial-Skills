# Agentforce

Skills for building Agentforce agents, Agent API integrations, vision, and Agentforce Contact Center (native Salesforce Voice).

Custom Lightning Type cards live in a sibling pack so existing install URLs keep working: **[../custom-lightning-types](../custom-lightning-types/)**.

## Packs

| Pack | What it covers |
|------|----------------|
| [agent-api](./agent-api/) | Agentforce Agent API (`einstein/ai-agent/v1`) — auth, sessions, messaging, variables, citations, review |
| [vision](./vision/) | Give an agent vision: flex prompt + Apex orchestrator + Agent Script, on-platform |
| [contact-center](./contact-center/) | Agentforce Contact Center with native Voice — channel, IVR, media, callbacks, Command Center |

## Install all Agentforce packs

Does **not** include Custom Lightning Types (install that pack separately).

```bash
curl -sSL https://raw.githubusercontent.com/sfdc-brendan/Unofficial-Skills/main/agentforce/install.sh | bash
```

```bash
curl -sSL https://raw.githubusercontent.com/sfdc-brendan/Unofficial-Skills/main/custom-lightning-types/install.sh | bash
```

## Install one pack

```bash
curl -sSL https://raw.githubusercontent.com/sfdc-brendan/Unofficial-Skills/main/agentforce/agent-api/install.sh | bash
curl -sSL https://raw.githubusercontent.com/sfdc-brendan/Unofficial-Skills/main/agentforce/vision/install.sh | bash
curl -sSL https://raw.githubusercontent.com/sfdc-brendan/Unofficial-Skills/main/agentforce/contact-center/install.sh | bash
```
