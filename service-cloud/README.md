# Service Cloud

Skills for Service Cloud implementation and Field Service. Contact-center **voice agent** build-out lives under [Agentforce Contact Center](../agentforce/contact-center/) because it is an Agentforce product on Service Cloud.

## Packs

| Pack | What it covers |
|------|----------------|
| [core](./core/) | Cases, Service Console, Omni-Channel, Knowledge, entitlements, email, incidents, Voice/Messaging, AI intake, config APIs, review |
| [field-service](./field-service/) | Work orders, scheduling, dispatch, optimization, mobile technician, inventory, SLAs, service reports |

## Install everything in this product

```bash
curl -sSL https://raw.githubusercontent.com/sfdc-brendan/Unofficial-Skills/main/service-cloud/install.sh | bash
```

## Install one pack

```bash
curl -sSL https://raw.githubusercontent.com/sfdc-brendan/Unofficial-Skills/main/service-cloud/core/install.sh | bash
curl -sSL https://raw.githubusercontent.com/sfdc-brendan/Unofficial-Skills/main/service-cloud/field-service/install.sh | bash
```
