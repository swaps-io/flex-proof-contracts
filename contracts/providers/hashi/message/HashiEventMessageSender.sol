// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {IYaho} from "@gnosis/hashi-evm/contracts/interfaces/IYaho.sol";

import {IEventVerifier} from "../../../interfaces/IEventVerifier.sol";

import {EventHashLib} from "../../../libraries/EventHashLib.sol";

import {IHashiEventMessageSender, HashiMessageEvent, HashiMessageParams} from "./interfaces/IHashiEventMessageSender.sol";

import {HashiMessageDataLib} from "./libraries/HashiMessageDataLib.sol";

contract HashiEventMessageSender is IHashiEventMessageSender {
    address public immutable override eventVerifier;
    address public immutable override yaho;

    constructor(address eventVerifier_, address yaho_) {
        eventVerifier = eventVerifier_;
        yaho = yaho_;
    }

    function sendEventMessage(HashiMessageEvent[] calldata events_, HashiMessageParams calldata params_) external payable override {
        bytes32[] memory eventHashes = new bytes32[](events_.length);
        for (uint256 i = 0; i < eventHashes.length; i++) {
            HashiMessageEvent calldata e = events_[i];
            IEventVerifier(eventVerifier).verifyEvent(e.chain, e.emitter, e.topics, e.data, e.proof);
            eventHashes[i] = EventHashLib.calc(e.chain, e.emitter, e.topics, e.data);
        }

        IYaho(yaho).dispatchMessageToAdapters{value: msg.value}(
            params_.targetChainId,
            params_.threshold,
            params_.receiver,
            HashiMessageDataLib.calc(eventHashes),
            params_.reporters,
            params_.adapters
        );
    }
}
