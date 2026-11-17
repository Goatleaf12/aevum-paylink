# Agent — autonomous invoice payer (PLAN ONLY — build from 16 Nov 2026)

Node script (viem) that pays whitelisted invoices autonomously within its
on-chain allowance (`AgentAllowance`: per-invoice cap, total cap, expiry,
whitelisted recipients, instant revoke by owner).

Planned files (create from 16 Nov):
- `pay-agent.mjs` — watches InvoiceCreated events, pays whitelisted
  invoices within cap, logs every payment with tx hash
- `package.json` — viem dependency; `AGENT_PRIVATE_KEY` via env (testnet key only)

Demo scenario (for the video): agent pays invoice #N while the owner shows
the allowance + revoke control in the UI.
