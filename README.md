# LWC Portfolio

A Salesforce DX project that displays a personal portfolio (profile, skills, and contact/social links) on the Home page using a custom Lightning Web Component backed by an `Account` record.

## Screenshot

![Portfolio component on the Home page](screenshots/portfolio-home-page.png)

## Overview

The `portfolio` LWC renders a single "portfolio" `Account` record — the one with the `Is_Portfolio_Account__c` checkbox set to `true` — as a profile card containing:

- Name, professional title, and description/bio
- Skills, shown as badges
- Email, phone, and website
- LinkedIn and GitHub links
- Profile photo (falls back to a default icon when no photo URL is set)

## Project Structure

- **`force-app/main/default/lwc/portfolio/`** – The `portfolio` Lightning Web Component (HTML, JS, CSS)
- **`force-app/main/default/classes/`** – `PortfolioController` (Apex controller that queries the portfolio `Account`) and its test class
- **`force-app/main/default/objects/Account/fields/`** – Custom fields added to `Account`:
  - `Is_Portfolio_Account__c` – checkbox flagging the record to display
  - `Professional_Title__c`
  - `Email__c`
  - `Skills__c` (comma-separated)
  - `LinkedIn_URL__c`
  - `GitHub_URL__c`
  - `Photo_URL__c`
- **`force-app/main/default/permissionsets/`** – `Portfolio_Field_Access` permission set granting access to the custom fields
- **`screenshots/`** – Screenshots of the component running in an org
- **`manifest/package.xml`** – Metadata manifest used for retrieve/deploy operations
- **`scripts/`** – Sample Apex and SOQL scripts

## Prerequisites

- [Salesforce CLI](https://developer.salesforce.com/tools/salesforcecli)
- VS Code with the Salesforce Extension Pack
- A Salesforce org (Developer Edition, sandbox, or scratch org) with an authenticated alias

## Deploy to an Org

```bash
sf project deploy start --source-dir force-app --target-org <your-org-alias>
```

## Set Up the Portfolio Data

1. Assign the `Portfolio_Field_Access` permission set to your user.
2. Create (or edit) an `Account` record and populate the portfolio fields (`Professional_Title__c`, `Email__c`, `Skills__c`, `LinkedIn_URL__c`, `GitHub_URL__c`, `Photo_URL__c`, `Description`).
3. Check the **Is Portfolio Account** (`Is_Portfolio_Account__c`) checkbox on that record.
4. Add the `portfolio` component to the Home page (via Lightning App Builder) if it isn't already there.

## Run Apex Tests

```bash
sf apex run test --target-org <your-org-alias> --code-coverage
```

## Common Salesforce CLI Commands

- `sf org login web` – Authorize an org
- `sf org open` – Open the org in a browser
- `sf project deploy start` – Deploy metadata to the org
- `sf project retrieve start` – Retrieve metadata from the org
- `sf apex run test` – Run Apex tests

