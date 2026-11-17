// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title InvoiceEscrow — tUSD8 invoice + escrow core (STUB)
/// @notice SCAFFOLD ONLY — no implementation before the build window opens
///         16 Nov 2026 (hackathon rule: all code developed during build window).
///         Planned flow: seller creates invoice (amount tUSD8, recipient, due
///         date, memo) -> payer funds escrow -> buyer confirms delivery ->
///         funds release to seller. Dispute window + auto-release after
///         deadline + cancel/refund paths. Every state change emits an event
///         (on-chain audit trail for the demo).
///         TODO (from 16 Nov): createInvoice / pay / confirmDelivery /
///         raiseDispute / resolveDispute / cancel / autoRelease + events +
///         reentrancy guards + 6-decimal tUSD8 handling.
contract InvoiceEscrow {
    // TODO: implement from 16 Nov 2026.
}
