// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

struct SaveEventProof {
    uint256 flags; // #0: should save verified, #1: no verify attempt after missing save
}
