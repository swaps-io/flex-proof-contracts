// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

struct RouterProof {
    uint256 variant; // Flags: emitter verifier (1), emit relay event (1)
    uint256[] relayChains;
}
