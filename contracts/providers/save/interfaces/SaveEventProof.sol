// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

struct SaveEventProof {
    uint256 flags; // #0: should perform event verification, #1: should perform save of verified event
}
