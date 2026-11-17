# UI — PayLink static app (PLAN ONLY — build from 16 Nov 2026)

Single-page static app (plain HTML/CSS + viem, no framework).
Hosted on Cloudflare Pages (static, free).

Planned files (create from 16 Nov):
- `index.html` — create-invoice form + pay view + confirm/dispute view
- `app.js` — viem wiring: connect wallet, create, pay, confirm, dispute;
  every step shows tx hash + explorer link; plain-language errors
- `style.css` — minimal, mobile-friendly

Flows:
1. Create: amount (tUSD8, 6 decimals) + recipient handle + due date + memo
   → shareable pay-link (copy button).
2. Pay: shows verified handle (from PayLinkRegistry), amount, due date,
   escrow status → Approve tUSD8 → Pay.
3. Confirm / Dispute: buyer confirms delivery → release; or raises dispute.
