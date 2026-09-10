# Unofficial Skills

Field-tested agent skills for Salesforce demo and Agentforce work. These are **not** official Salesforce products. They exist so another human — or another agent — can rebuild the things that actually worked in a live org.

## Packs

| Pack | What it teaches an agent to do |
|------|--------------------------------|
| **[Custom Lightning Types](./custom-lightning-types/)** | Build and debug Apex-based CLT cards that **render** on Enhanced Chat v2, Service Rep Assistant, Employee Agent chat, and Agentforce Cowork. Includes SRA chat write-back. |

## Install

Clone once, then install into the tools you use:

```bash
git clone https://github.com/brendansheridan/Unofficial-Skills.git
cd Unofficial-Skills
chmod +x install.sh custom-lightning-types/install.sh
./install.sh --all
```

That copies the skills into Cursor, Claude Code, and Codex if those tools are present on the machine. See the [Custom Lightning Types pack](./custom-lightning-types/) for flags (`--cursor`, `--claude`, `--codex`, `--symlink`, `--project`).

## After install

Open a new agent chat and ask something like:

> Build a Custom Lightning Type card for the Service Rep Assistant sidebar that lets a rep pick an appointment window.

The agent should pick up `sf-clt-builder`. If a card deploys but renders as text, `agentforce-lightning-types` owns that debug path.

## Disclaimer

Unofficial. Not affiliated with or endorsed by Salesforce. Some of the SRA write-back events documented here are **undocumented host behavior**, verified empirically. They can change without notice. Use at your own risk.
