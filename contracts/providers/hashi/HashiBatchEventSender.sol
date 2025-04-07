// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {EventHashLib} from "../../libraries/EventHashLib.sol";
import {EventsHashLib} from "../../libraries/EventsHashLib.sol";

import {IEventVerifier} from "../../interfaces/IEventVerifier.sol";

import {IHashiBatchEventSender, HashiBatchEvent, HashiBatchEventNoChain, HashiBatchEventNoChainEmitter} from "./interfaces/IHashiBatchEventSender.sol";

import {HashiEventSenderInfra, HashiEventSenderInfraConfig} from "./HashiEventSenderInfra.sol";

contract HashiBatchEventSender is IHashiBatchEventSender, HashiEventSenderInfra {
    constructor(HashiEventSenderInfraConfig memory config_)
        HashiEventSenderInfra(config_) {}

    function sendEventBatch(HashiBatchEvent[] calldata events_) external {
        bytes32[] memory eventHashes = new bytes32[](events_.length);
        for (uint256 i = 0; i < events_.length; i++) {
            HashiBatchEvent calldata e = events_[i];
            eventHashes[i] = _verifiedEventHash(e.chain, e.emitter, e.topics, e.data, e.proof);
        }
        _sendHashBatch(eventHashes);
    }

    function sendEventBatch(uint256 chain_, HashiBatchEventNoChain[] calldata events_) external {
        bytes32[] memory eventHashes = new bytes32[](events_.length);
        for (uint256 i = 0; i < events_.length; i++) {
            HashiBatchEventNoChain calldata e = events_[i];
            eventHashes[i] = _verifiedEventHash(chain_, e.emitter, e.topics, e.data, e.proof);
        }
        _sendHashBatch(eventHashes);
    }

    function sendEventBatch(uint256 chain_, address emitter_, HashiBatchEventNoChainEmitter[] calldata events_) external {
        bytes32[] memory eventHashes = new bytes32[](events_.length);
        for (uint256 i = 0; i < events_.length; i++) {
            HashiBatchEventNoChainEmitter calldata e = events_[i];
            eventHashes[i] = _verifiedEventHash(chain_, emitter_, e.topics, e.data, e.proof);
        }
        _sendHashBatch(eventHashes);
    }

    function _verifiedEventHash(
        uint256 chain_,
        address emitter_,
        bytes32[] calldata topics_,
        bytes calldata data_,
        bytes calldata proof_
    ) private returns (bytes32) {
        IEventVerifier(eventVerifier).verifyEvent(chain_, emitter_, topics_, data_, proof_);
        return EventHashLib.calc(chain_, emitter_, topics_, data_);
    }

    function _sendHashBatch(bytes32[] memory eventHashes_) private {
        bytes32 eventsHash = EventsHashLib.calc(eventHashes_);
        _sendHashMessage(eventsHash);
    }
}
