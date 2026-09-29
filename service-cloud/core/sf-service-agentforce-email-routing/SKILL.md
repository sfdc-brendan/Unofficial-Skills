---
name: sf-service-agentforce-email-routing
description: Configure Email-to-Case intake for Agentforce for Service on Email. Use when enabling Email-to-Case, creating or verifying the routing address the Agentforce Service Agent owns, setting and verifying the External Email Services (forwarding) address, adding an Organization-Wide Email Address, and choosing a safe outbound email template.
disable-model-invocation: true
---
# Agentforce for Service on Email — Email-to-Case Routing

## Use This Skill When

- You are preparing the email intake side of Agentforce for Service on Email.
- A Q-Brix-provisioned routing address is stuck on "Verification pending".
- You need the routing address configured so Cases land with the Agentforce agent, not a queue or human.

## Prerequisites

- The Agentforce Service Agent (and its agent user) exists — run the Agentforce Service Agent and Agentforce | Service on Email Q-Brix, or create the agent manually.
- An external inbox you can open right now to click a verification link.

## Core Workflow

1. **Enable Email-to-Case**
   - Setup > Quick Find > **Email-to-Case** > Edit > check **Enable Email-to-Case** > Save.
2. **Create or verify the routing address**
   - Same page > **Routing Addresses** > **New** (or open the one the Q-Brix provisioned).
   - Leave the generated Salesforce-side **Email Address** as-is (e.g. `...case.salesforce.com`).
   - Set **Case Owner** to your **Agentforce agent user** — not a queue and not a human.
   - Leave **Flow Settings** blank — do **not** attach an Omni-Channel Flow here.
3. **Set and verify the External Email Services Address**
   - On the routing address, set the external forwarding address to a real inbox you can access.
   - Save — this sends a verification email. Open that inbox and click the verification link immediately.
   - Confirm the status shows **Verified** before moving on.
4. **Confirm an Organization-Wide Email Address**
   - Setup > **Organization-Wide Addresses** > New (if none exists) > verify it. Some SDOs are missing one by default.
5. **Use a plain outbound email template**
   - Make sure the template used for agent/auto replies has no default or generic logo image attached.
6. **Hand off** to `sf-service-agentforce-email-agent-connection` to link the agent to this routing address.

## Guardrails

- **Stuck on "Verification pending"?** Don't keep waiting on a Q-Brix forwarding inbox you can't access. Create a brand-new routing address with an email you control, verify it immediately, then re-set the Case Owner and re-attach the Agentforce Service Agent Configuration on the new record.
- **No Omni-Channel Flow on the routing address.** Flow Settings here has caused failures in past setups; leave it blank unless you have a specific reason.
- **Plain template only.** A generic logo image in the outbound template has caused delivery/rendering issues.
- A correctly configured routing address still does nothing without the Agentforce Service Agent Configuration link — never stop at this skill.

## Deliverables

- Email-to-Case enabled.
- A routing address with Case Owner = Agentforce agent user, Flow Settings blank, and external forwarding address **Verified**.
- A verified Organization-Wide Email Address and a plain outbound template.

## Additional Resources

- Next step: `sf-service-agentforce-email-agent-connection`. Full sequence: `sf-service-agentforce-email-orchestrator`.
- General Email-to-Case hardening (threading, spam, parsing): `sf-service-email-to-case`.
- Symptoms and fixes: `sf-service-agentforce-email-troubleshooting`.
