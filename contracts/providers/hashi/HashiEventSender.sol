// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {EventHashLib} from "../../libraries/EventHashLib.sol";

import {IEventVerifier} from "../../interfaces/IEventVerifier.sol";

import {IHashiEventSender} from "./interfaces/IHashiEventSender.sol";

import {HashiEventSenderInfra, HashiEventSenderInfraConfig} from "./HashiEventSenderInfra.sol";

contract HashiEventSender is IHashiEventSender, HashiEventSenderInfra {
    constructor(HashiEventSenderInfraConfig memory config_)
        HashiEventSenderInfra(config_) {}

    function sendEvent(
        uint256 chain_,
        address emitter_,
        bytes32[] calldata topics_,
        bytes calldata data_,
        bytes calldata proof_
    ) external {
        IEventVerifier(eventVerifier).verifyEvent(chain_, emitter_, topics_, data_, proof_);
        bytes32 eventHash = EventHashLib.calc(chain_, emitter_, topics_, data_);
        _sendHashMessage(eventHash);
    }
}
