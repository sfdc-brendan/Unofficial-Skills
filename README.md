# Unofficial Skills

Field-tested agent skills for Salesforce demo and Agentforce work. These are **not** official Salesforce products. They exist so another human — or another agent — can rebuild the things that actually worked in a live org.

Each pack installs **from its own folder**. There is no repo-root installer.

## Packs

### [Custom Lightning Types](./custom-lightning-types/)

Apex-based CLT cards that **render** on Enhanced Chat v2, Service Rep Assistant, Employee Agent chat, and Agentforce Cowork. Includes SRA chat write-back.

```bash
curl -sSL https://raw.githubusercontent.com/sfdc-brendan/Unofficial-Skills/main/custom-lightning-types/install.sh | bash
```

See the [pack README](./custom-lightning-types/) for wget, clone, and manual install.

## Disclaimer

Unofficial. Not affiliated with or endorsed by Salesforce. Some of the SRA write-back events documented here are **undocumented host behavior**, verified empirically. They can change without notice. Use at your own risk.
