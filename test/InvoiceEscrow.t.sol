// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @notice TEST PLAN (stubs only — implement from 16 Nov 2026):
///  - happy path: create -> pay -> confirm -> release (balances exact)
///  - dispute: raise -> refund path; no double-release
///  - expiry: auto-release after dispute window; cancel before pay
///  - agent allowance: cap enforced, expiry enforced, revoke blocks spend
///  - invariant fuzz: escrow balance == sum of unpaid invoice amounts
///  - 6-decimal tUSD8 amounts (no 18-decimal assumptions)
contract InvoiceEscrowTest {
    // TODO: implement from 16 Nov 2026.
}
