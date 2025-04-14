// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

struct HashiMessageProof {
    bytes32[] batchHashes; // Zero length = no batch (single event)
    uint256 batchIndex; // Index in batch (ignored when no batch)
    uint256 nonce;
    address[] reporters;
    address[] adapters;
}
