# Aevum PayLink — Build Plan (16 Nov → 11 Dec 2026)

> Prep only. No implementation before 16 Nov 2026 (hackathon rule).
> See `../PREP.md` for contest summary, risks, and day-by-day schedule.

## Architecture (chosen: Invoice Payments track + agentic angle)

```
                    ┌─────────────────────┐
  seller ──create──▶│  InvoiceEscrow      │──pay-link──▶ payer (human wallet)
  (pay-link URL)    │  - createInvoice    │
                    │  - pay (escrow)     │──confirm──▶ release to seller
                    │  - confirmDelivery  │──dispute──▶ lock → refund/release
                    │  - autoRelease      │
                    └────────┬────────────┘
                             │ reads
                    ┌────────▼────────────┐
                    │  PayLinkRegistry    │  handle -> address
                    │  (Confirmation of   │  (payer sees verified name)
                    │   Payee-lite)       │
                    └─────────────────────┘
                             │ allowance
                    ┌────────▼────────────┐
                    │  AgentAllowance     │  owner grants agent:
                    │  - grant/revoke     │  per-invoice cap, total cap,
                    │  - spend (capped)   │  expiry, whitelisted recipients
                    └────────┬────────────┘
                             │ pays via viem script
                    ┌────────▼────────────┐
                    │  agent/ (Node)      │  watches invoices, pays
                    │  pay-agent.mjs      │  whitelisted ones in-cap
                    └─────────────────────┘
  UI: ui/index.html + app.js (viem) — create / pay / confirm / dispute,
      explorer links + tx hashes on every step. Static hosting (Pages).
```

## Contract function list (to implement from 16 Nov)

### InvoiceEscrow.sol
- `createInvoice(address recipient, uint256 amount, uint64 dueAt, uint64 disputeWindow, string memo) returns (uint256 invoiceId)`
- `pay(uint256 invoiceId)` — pulls tUSD8 into escrow (requires prior ERC-20 approval)
- `confirmDelivery(uint256 invoiceId)` — buyer releases funds to seller
- `raiseDispute(uint256 invoiceId)` — locks funds, starts dispute
- `resolveDispute(uint256 invoiceId, bool refundBuyer)` — seller/buyer agreement path
- `cancelInvoice(uint256 invoiceId)` — seller cancels before payment
- `autoRelease(uint256 invoiceId)` — anyone can call after dispute window passes with no dispute
- Events: `InvoiceCreated`, `Paid`, `DeliveryConfirmed`, `DisputeRaised`, `DisputeResolved`, `Released`, `Refunded`, `Cancelled`
- Guards: reentrancy guard, no double-release, 6-decimal tUSD8 (never assume 18)

### PayLinkRegistry.sol
- `register(string handle, address wallet)` / `update` / `revoke`
- `resolve(string handle) returns (address)`
- Event: `HandleRegistered`, `HandleRevoked`

### AgentAllowance.sol
- `grant(address agent, uint256 perInvoiceCap, uint256 totalCap, uint64 expiry, address[] recipients)`
- `revoke(address agent)`
- `spend(address agent, uint256 invoiceId, uint256 amount)` — called by agent, enforces caps/expiry/whitelist
- Event: `AllowanceGranted`, `AllowanceRevoked`, `AgentSpent`

## Test list (Foundry)
- Happy path: create → pay → confirm → release (exact balances, 6 decimals)
- Dispute: raise → refund; no double-release after release/refund
- Expiry: auto-release after window; cancel before pay; pay after due date reverts
- Agent: cap enforced, expiry enforced, revoke blocks spend, non-whitelisted recipient reverts
- Invariant fuzz: escrow tUSD8 balance == sum of unpaid invoice amounts
- Edge: zero amount reverts, past due date reverts, wrong caller reverts

## UI plan (ui/)
- Single-page static app (viem + plain HTML/CSS, no framework)
- Views: Create invoice → shareable pay-link (copy button) → Pay view
  (shows verified handle, amount, due date, escrow status) → Confirm/Dispute
- Every step shows tx hash + explorer link; plain-language errors
- Host on Cloudflare Pages (static, free)

## Agent demo plan (agent/)
- `pay-agent.mjs` (Node + viem): watches `InvoiceCreated` events, pays
  whitelisted-recipient invoices within its allowance cap
- Demo scenario for video: agent pays invoice #N autonomously while the
  owner shows the allowance + revoke control in the UI

## Demo video plan (1–2 min, recorded 3–5 Dec)
1. (0:00–0:20) Problem + create invoice → pay-link
2. (0:20–0:50) Human pays via link → escrow → confirm → release (explorer tx shown)
3. (0:50–1:20) Agent auto-pays a second invoice within cap → revoke demo
4. (1:20–1:40) Dispute window + auto-release edge case
5. (1:40–2:00) Close: contracts verified on explorer + repo link

## Milestones
- 16–17 Nov: registration + faucet + hello-world deploy + verify flow
- 18–20 Nov: contracts v1 + tests green
- 21–24 Nov: UI + agent script working end-to-end locally
- 25–27 Nov: testnet deploy + verify + full demo rehearsal
- 28 Nov–2 Dec: polish, docs, architecture diagram, fuzz, edge cases
- 3–5 Dec: record + edit demo video
- 6–8 Dec: buffer, final testing, pre-submit checklist
- 9–10 Dec: SUBMIT (early — portals get slow at the end)
- 11 Dec 08:00 UTC: hard deadline (submit done by 10 Dec)
- 12–14 Dec: judging · 15 Dec: Demo Day (Top 5, 3–5 min call)
