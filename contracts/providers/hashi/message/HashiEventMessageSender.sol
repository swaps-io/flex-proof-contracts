// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {IEventVerifier} from "../../../interfaces/IEventVerifier.sol";

import {EventHashLib} from "../../../libraries/EventHashLib.sol";
import {EventsHashLib} from "../../../libraries/EventsHashLib.sol";

import {IYaho} from "../libraries/hashi/interfaces/IYaho.sol";

import {
    IHashiEventMessageSender,
    HashiBatchEvent,
    HashiBatchEventNoChain,
    HashiBatchEventNoChainEmitter,
    HashiMessageParams
} from "./interfaces/IHashiEventMessageSender.sol";

import {HashiEventMessageDataLib} from "./libraries/HashiEventMessageDataLib.sol";
import {HashiMessageCastLib} from "./libraries/HashiMessageCastLib.sol";

contract HashiEventMessageSender is IHashiEventMessageSender {
    address public immutable eventVerifier;
    address public immutable yaho;

    constructor(
        address eventVerifier_,
        address yaho_
    ) {
        eventVerifier = eventVerifier_;
        yaho = yaho_;
    }

    function sendEvent(
        uint256 chain_,
        address emitter_,
        bytes32[] calldata topics_,
        bytes calldata data_,
        bytes calldata proof_,
        HashiMessageParams calldata params_
    ) external {
        bytes32 eventHash = _verifiedEventHash(chain_, emitter_, topics_, data_, proof_);
        _sendHash(eventHash, params_);
    }

    function sendEventBatch(
        HashiBatchEvent[] calldata events_,
        HashiMessageParams calldata params_
    ) external {
        bytes32[] memory eventHashes = new bytes32[](events_.length);
        for (uint256 i = 0; i < eventHashes.length; i++) {
            HashiBatchEvent calldata e = events_[i];
            eventHashes[i] = _verifiedEventHash(e.chain, e.emitter, e.topics, e.data, e.proof);
        }
        _sendHashBatch(eventHashes, params_);
    }

    function sendEventBatch(
        uint256 chain_,
        HashiBatchEventNoChain[] calldata events_,
        HashiMessageParams calldata params_
    ) external {
        bytes32[] memory eventHashes = new bytes32[](events_.length);
        for (uint256 i = 0; i < eventHashes.length; i++) {
            HashiBatchEventNoChain calldata e = events_[i];
            eventHashes[i] = _verifiedEventHash(chain_, e.emitter, e.topics, e.data, e.proof);
        }
        _sendHashBatch(eventHashes, params_);
    }

    function sendEventBatch(
        uint256 chain_,
        address emitter_,
        HashiBatchEventNoChainEmitter[] calldata events_,
        HashiMessageParams calldata params_
    ) external {
        bytes32[] memory eventHashes = new bytes32[](events_.length);
        for (uint256 i = 0; i < eventHashes.length; i++) {
            HashiBatchEventNoChainEmitter calldata e = events_[i];
            eventHashes[i] = _verifiedEventHash(chain_, emitter_, e.topics, e.data, e.proof);
        }
        _sendHashBatch(eventHashes, params_);
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

    function _sendHashBatch(
        bytes32[] memory eventHashes_,
        HashiMessageParams calldata params_
    ) private {
        bytes32 eventsHash = EventsHashLib.calc(eventHashes_);
        _sendHash(eventsHash, params_);
    }

    function _sendHash(
        bytes32 hash_,
        HashiMessageParams calldata params_
    ) internal {
        IYaho(yaho).dispatchMessageToAdapters(
            params_.targetChainId,
            params_.threshold,
            params_.receiver,
            HashiEventMessageDataLib.encode(hash_),
            HashiMessageCastLib.asReporters(params_.reporters),
            HashiMessageCastLib.asAdapters(params_.adapters)
        );
    }
}
