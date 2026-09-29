---
name: sf-service-agentforce-email-troubleshooting
description: Diagnose and fix common Agentforce for Service on Email demo issues. Use when a test email creates no Case, a Case is created but the agent never replies, the agent returns a generic "couldn't respond to the email" error, a routing address is stuck on "Verification pending", the Q-Brix skipped the Agentforce Service Agent Configuration, or stray bounces make a test look like it failed.
disable-model-invocation: true
---
# Agentforce for Service on Email — Troubleshooting (Demo Gotchas)

## Use This Skill When

- An Agentforce for Service on Email demo isn't producing Cases or replies.
- You are validating a fresh setup and want to pre-empt the known failure modes.
- You see bounces or auto-replies and aren't sure they relate to your test.

## Core Workflow

Split the symptom first — "no Case" and "Case but no reply" are different problems.

1. **No Case created at all (intake problem)**
   - Setup > **Email Administration** > **Email Log Files** — confirm Salesforce actually received the email before touching config.
   - Confirm the test came from an external (non-`@salesforce.com`) sender and went to the routing address.
   - Routing address stuck on **"Verification pending"**? Don't wait on a Q-Brix forwarding inbox you can't access. Create a brand-new routing address with an email you control, verify it immediately, then re-set Case Owner (Agentforce agent user) and re-attach the Agentforce Service Agent Configuration.
   - Confirm the External Email Services Address status is **Verified**.
   - Confirm **Flow Settings** on the routing address is blank (no Omni-Channel Flow).
2. **Case created, but no Agentforce reply (agent/Einstein problem)**
   - Open the routing address > **Agentforce Service Agent Configuration** related tab. If empty or inactive, add/activate it. The Q-Brix is known to skip creating this.
   - Agent error "The Agent couldn't respond to the email... Contact Salesforce Customer Support and provide this error code" → Setup > **Einstein Setup** > turn **Generative AI** on.
   - Confirm a verified **Organization-Wide Email Address** exists (Setup > Organization-Wide Addresses). Some SDOs lack one.
   - Confirm the outbound email template is plain — no default/generic logo image.
3. **A bounce or auto-reply looks like a failure**
   - Pre-existing Cases (e.g. from old Q-Brix demo scenarios) can fire their own automation and bounce to your inbox during testing. Check the **Case ID**, the **org ID** in the email headers, and the **subject** before troubleshooting based on it.

## Guardrails

- Diagnose in order: Email Log Files → routing address verification → agent configuration → Einstein Generative AI → Org-Wide Email Address → template.
- Never assume a Q-Brix did its job — verify the routing address status and the Agentforce Service Agent Configuration by hand.
- Don't fix intake config for a "no reply" symptom, or agent config for a "no Case" symptom.

## Deliverables

- A diagnosis mapped to the specific gotcha with the exact fix.
- A pre-demo checklist: Generative AI on; routing address Verified with Case Owner = agent user and no Omni flow; active Agentforce Service Agent Configuration; verified Org-Wide Email Address; plain template; external test sender.

## Additional Resources

- Setup skills: `sf-service-agentforce-email-routing`, `sf-service-agentforce-email-agent-connection`. Full sequence: `sf-service-agentforce-email-orchestrator`.
- Source: "Agentforce for Service on Email — TMT Team Setup Guide (SDO/Tech IDO Demo Orgs)" Slack canvas (AI-assisted, field-verified by the TMT team).
