---
name: sf-service-agentforce-email-orchestrator
description: End-to-end build orchestrator for Agentforce for Service on Email in an SDO or Tech IDO demo org. Use when standing up an Agentforce Service Agent that autonomously answers inbound Email-to-Case email — sequencing the Q-Brix deployments, Generative AI enablement, the Email-to-Case routing address, the Agentforce Service Agent Configuration link, and the end-to-end test — and to decide which focused skill to hand off to next.
disable-model-invocation: true
---
# Agentforce for Service on Email — Build Orchestrator

## Use This Skill When

- You are setting up Agentforce for Service on Email in an SDO or Tech IDO for a demo.
- You need the correct end-to-end sequence and a gate to validate at each phase.
- You need to decide which focused skill applies to the current step (routing address, agent connection, troubleshooting).

## Prerequisites

- An SDO or Tech IDO demo org with an Agentforce Service Agent available.
- An external inbox you control (for the forwarding address verification and for sending test email). Test senders must **not** be `@salesforce.com`.
- Admin access to Setup and the Q-Brix store (App Launcher > Q Branch > Demo Wizard).

## Core Workflow

1. **Phase 0 — Q-Brix deployments** (in this order)
   - Data Cloud | SDO Full Setup with Sales, Service and S3 Streams
   - Agentforce Service Agent
   - Service Gen AI Setup
   - Agentforce | Service on Email
   - **Gate:** each Q-Brix reports success. Do **not** assume the Service on Email Q-Brix wired everything — Phases 2 and 3 verify it.
2. **Phase 1 — Generative AI on** → hand off to `sf-service-agentforce-email-agent-connection`
   - Setup > Einstein Setup > confirm **Generative AI** is **On**. Commonly off in fresh SDOs.
   - **Gate:** toggle shows On.
3. **Phase 2 — Email-to-Case and routing address** → hand off to `sf-service-agentforce-email-routing`
   - Enable Email-to-Case; create/verify the routing address with **Case Owner = the Agentforce agent user** and **Flow Settings blank**; set and verify the External Email Services Address; confirm an Organization-Wide Email Address exists; use a plain outbound template.
   - **Gate:** routing address status is **Verified** (not "Verification pending").
4. **Phase 3 — Link the agent to the routing address** → hand off to `sf-service-agentforce-email-agent-connection`
   - On the routing address record, add and **activate** an **Agentforce Service Agent Configuration** pointing at your agent. This is the step most people miss.
   - **Gate:** an active configuration is listed on the routing address record.
5. **Phase 4 — End-to-end test**
   - Send an email from an external (non-`@salesforce.com`) sender to the routing address. Wait a few minutes.
   - **Gate:** a Case is created **and** the Agentforce agent replies by email.
6. **Throughout — Troubleshooting** → consult `sf-service-agentforce-email-troubleshooting`
   - Split the symptom first: "no Case created" (intake problem) vs "Case created but no reply" (agent/Einstein problem).

## Guardrails

- Follow the phase order — the agent can't reply without Generative AI, and nothing happens at all without a verified routing address linked to the agent.
- Treat every Q-Brix-provisioned piece as unverified. The routing address can be stuck on "Verification pending" and the Agentforce Service Agent Configuration is known to be missing after the Q-Brix runs.
- Don't attach an Omni-Channel Flow to the routing address for this setup.
- When a test "fails", confirm the bounce or auto-reply actually belongs to your test (Case ID, org ID, subject) before changing config.

## Deliverables

- A phased build plan with per-phase gates and the focused skill for each phase.
- A pre-demo checklist: Generative AI on, routing address Verified, Case Owner = agent user, no Omni flow on the routing address, active Agentforce Service Agent Configuration, Organization-Wide Email Address verified, plain email template.
- A validated end-to-end test: external email in, Case created, Agentforce reply out.

## Additional Resources

- Focused skills: `sf-service-agentforce-email-routing`, `sf-service-agentforce-email-agent-connection`, `sf-service-agentforce-email-troubleshooting`.
- General Email-to-Case hardening (threading, spam, parsing): `sf-service-email-to-case`.
- Agent planner, topic, and action design must reference the official GenAI API docs: https://developer.salesforce.com/docs/einstein/genai/references/about/about-genai-api.html
- Source: "Agentforce for Service on Email — TMT Team Setup Guide (SDO/Tech IDO Demo Orgs)" Slack canvas. The canvas was AI-assisted and field-verified by the TMT team; review steps against your org before a live demo.
