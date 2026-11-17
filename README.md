# Aevum PayLink — Invoice + Escrow Pay-Links in tUSD8

**Aevum Builder Challenge #1 (DoraHacks)** — Track: Invoice Payments (+ agentic payments)
| Item | Value |
|---|---|
| Network | QDay Aevum Testnet, chain ID **44005** |
| RPC | https://rpc-test.qday.info |
| Explorer | https://explorer-test.qday.info |
| Stablecoin | tUSD8 `0x456569838f1d43009A91ebA4263147Afd7233483` (ERC-20, 6 decimals) |
| Faucet | https://faucet.qday.info/en (tQDAY gas + tUSD8) |
| Prize pool | $1,500 USDT — 1st $800 / 2nd $500 / 3rd $200 |
| Build window | 16 Nov 2026 06:00 UTC → 11 Dec 2026 08:00 UTC |
| Judging | 12–14 Dec 2026 · Demo Day (Top 5) 15 Dec 2026 14:00 HKT |

## What it is

**Pay-links + escrow invoices in tUSD8, payable by humans or AI agents.**

1. A seller creates an invoice (amount, recipient, due date, memo) and shares a
   pay-link — no wallet needed to *receive* the link, only to pay it.
2. The payer opens the link, sees a **verified human-readable name**
   (Confirmation-of-Payee-lite via `PayLinkRegistry`), and funds escrow.
3. The buyer confirms delivery → funds release to the seller. A dispute window
   protects both sides: dispute locks funds; auto-release fires after the
   deadline if nobody disputes; cancel/refund paths exist before payment.
4. **Agent angle:** an owner grants an AI agent a *scoped, revocable*
   allowance (`AgentAllowance`) — per-invoice cap, total cap, expiry,
   whitelisted recipients. A small agent script pays whitelisted invoices
   autonomously, within the cap. All enforcement is on-chain in our own
   contracts — it does **not** depend on unreleased QDay agent/x402/ERC-8004
   tooling.

## Why this design wins (judging weights)

| Criterion (weight) | How PayLink scores |
|---|---|
| Innovation & originality (20) | Pay-links + escrow + *agent-payable* invoices in one flow; novel agentic payment primitive, not a template invoice contract |
| UX & presentation (15) | One link → pay in 2 clicks; plain-language status + errors; mobile-friendly |
| Technical quality & platform integration (15) | Foundry unit + fuzz tests, verified source on Blockscout, clean code, retries/idempotency |
| Real-world utility & market potential (15) | Invoicing is a validated pain for freelancers/merchants; clear path to mainnet |
| Safety, trust & controls (15) | Least-privilege agent allowance, spend caps, expiry, instant revoke, full event audit trail |
| Demo clear & well-structured (10) | Reproducible end-to-end testnet demo with live tx hashes + explorer links |
| Comprehensive documentation (10) | This README + architecture diagram + setup steps + API reference |

## Repo layout

```
src/
  InvoiceEscrow.sol     # invoice + escrow core
  PayLinkRegistry.sol   # handle -> address registry (Confirmation of Payee-lite)
  AgentAllowance.sol    # scoped, revocable agent spending allowance
test/
  InvoiceEscrow.t.sol   # unit + invariant fuzz tests
  AgentAllowance.t.sol  # allowance lifecycle tests
script/
  Deploy.s.sol          # Aevum Testnet deploy + verify script
ui/                     # minimal static pay-link UI (viem) — see ui/README.md
agent/                  # Node agent script (viem) — see agent/README.md
```

## Setup

```bash
# 1. Install Foundry (https://getfoundry.sh) — forge 1.9.0 used here
# 2. Add Aevum Testnet to your wallet (chain ID 44005, RPC above)
# 3. Get test funds: https://faucet.qday.info/en (tQDAY for gas, tUSD8 to pay)
# 4. Build + test (from 16 Nov 2026 — build window)
forge build
forge test
```

## Deploy (from 16 Nov 2026)

```bash
# NEVER use a key holding real funds. Testnet only.
forge script script/Deploy.s.sol --rpc-url https://rpc-test.qday.info --broadcast
forge verify-contract --chain-id 44005 --verifier blockscout \
  --verifier-url https://explorer-test.qday.info/api \
  <ADDRESS> src/InvoiceEscrow.sol:InvoiceEscrow
```

## Status

**PREP ONLY — build window opens 16 Nov 2026.** `src/` contains NatSpec
stubs with TODOs, no implementation (hackathon rule: all code developed
during the build window). See `../PREP.md` for the full plan.
