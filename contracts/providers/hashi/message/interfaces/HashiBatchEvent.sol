// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

struct HashiBatchEvent {
    uint256 chain;
    address emitter;
    bytes32[] topics;
    bytes data;
    bytes proof;
}

struct HashiBatchEventNoChain {
    address emitter;
    bytes32[] topics;
    bytes data;
    bytes proof;
}

struct HashiBatchEventNoChainEmitter {
    bytes32[] topics;
    bytes data;
    bytes proof;
}
