---
name: sf-service-agentforce-email-agent-connection
description: Connect an Agentforce Service Agent to an Email-to-Case routing address so it answers inbound email. Use when turning on Generative AI in Einstein Setup, adding and activating the Agentforce Service Agent Configuration on the routing address (the step most people miss), or when Agent Builder's "Add Service Email connection" is involved.
disable-model-invocation: true
---
# Agentforce for Service on Email — Agent Connection

## Use This Skill When

- The routing address is configured and Verified, and you need the Agentforce agent to actually respond.
- Cases are created from email but the agent never replies.
- You are unsure whether the Q-Brix created the link between the routing address and the agent.

## Prerequisites

- A Verified Email-to-Case routing address with Case Owner = Agentforce agent user (see `sf-service-agentforce-email-routing`).
- An Agentforce Service Agent that exists and can be activated.

## Core Workflow

1. **Confirm Generative AI is enabled org-wide**
   - Setup > Quick Find > **Einstein Setup** > confirm **Generative AI** is **On**.
   - Fresh SDOs commonly ship with this off; the agent then fails on response even when everything else is wired correctly.
2. **Open the routing address record**
   - Setup > Email-to-Case > Routing Addresses > your routing address.
3. **Add the Agentforce Service Agent Configuration**
   - Open the **Agentforce Service Agent Configuration** related tab on the routing address.
   - Add/create a new configuration and attach your Agentforce agent.
   - Agent Builder > new connections view > **Add Service Email connection** redirects into this same setup page — it is the same step, not a separate one.
4. **Activate the configuration**
   - Confirm the configuration shows as active on the routing address record.
5. **Test** — send an email from an external (non-`@salesforce.com`) sender to the routing address, wait a few minutes, and confirm both a Case and an Agentforce reply.

## Guardrails

- **Always verify the configuration manually.** The Q-Brix is known to fail to create the Agentforce Service Agent Configuration. The routing address and Case Owner can look perfect while no Case or reply ever happens because the link was never created.
- **Opaque agent error = check Einstein first.** "The Agent couldn't respond to the email... Contact Salesforce Customer Support and provide this error code" on a successfully created Case almost always means Generative AI is off in Einstein Setup.
- If you recreate the routing address (e.g. after a stuck verification), re-create the configuration on the **new** record — it does not carry over.

## Deliverables

- Generative AI enabled in Einstein Setup.
- An active Agentforce Service Agent Configuration on the routing address pointing at the intended agent.
- A test email that produces a Case and an Agentforce reply.

## Additional Resources

- Previous step: `sf-service-agentforce-email-routing`. Full sequence: `sf-service-agentforce-email-orchestrator`.
- Symptoms and fixes: `sf-service-agentforce-email-troubleshooting`.
- When designing the agent's planner, topics, and actions for email, ground the design in the official GenAI API docs: https://developer.salesforce.com/docs/einstein/genai/references/about/about-genai-api.html
