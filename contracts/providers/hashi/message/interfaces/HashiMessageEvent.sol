// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

struct HashiMessageEvent {
    uint256 chain;
    address emitter;
    bytes32[] topics;
    bytes data;
    bytes proof;
}
