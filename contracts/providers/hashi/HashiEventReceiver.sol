// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {IHashiEventReceiver} from "./interfaces/IHashiEventReceiver.sol";

import {HashiEventReceiverInfra, HashiEventReceiverInfraConfig} from "./HashiEventReceiverInfra.sol";

contract HashiEventReceiver is IHashiEventReceiver, HashiEventReceiverInfra {
    mapping(bytes32 eventHash => bool) public eventHashReceived;

    constructor(HashiEventReceiverInfraConfig memory config_)
        HashiEventReceiverInfra(config_) {}

    function _receiveHashMessage(bytes32 hash_) internal override {
        eventHashReceived[hash_] = true;
    }
}
