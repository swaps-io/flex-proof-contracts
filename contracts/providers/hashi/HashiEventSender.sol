// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {EventHashLib} from "../../libraries/EventHashLib.sol";
import {EventsHashLib} from "../../libraries/EventsHashLib.sol";

import {IEventVerifier} from "../../interfaces/IEventVerifier.sol";

import {IYaho, IReporter, IAdapter} from "./libraries/hashi/interfaces/IYaho.sol";

import {IHashiEventSender, HashiSendEvent} from "./interfaces/IHashiEventSender.sol";

contract HashiEventSender is IHashiEventSender {
    address public immutable eventVerifier;
    uint256 public immutable receiveChain;
    address public immutable eventReceiver;
    address public immutable yaho;
    uint256 public immutable threshold;

    address[] private _reporters;
    address[] private _adapters;

    constructor(
        address eventVerifier_,
        uint256 receiveChain_,
        address eventReceiver_,
        address yaho_,
        uint256 threshold_,
        address[] memory reporters_,
        address[] memory adapters_
    ) {
        eventVerifier = eventVerifier_;
        receiveChain = receiveChain_;
        eventReceiver = eventReceiver_;
        yaho = yaho_;
        threshold = threshold_;
        _reporters = reporters_;
        _adapters = adapters_;
    }

    function reporters() public view returns (address[] memory) {
        return _reporters;
    }

    function adapters() public view returns (address[] memory) {
        return _adapters;
    }

    function sendEvent(
        uint256 chain_,
        address emitter_,
        bytes32[] calldata topics_,
        bytes calldata data_,
        bytes calldata proof_
    ) external {
        bytes32 eventHash = _verifiedEventHash(chain_, emitter_, topics_, data_, proof_);
        _sendHashMessage(eventHash);
    }

    function sendEvents(HashiSendEvent[] calldata events_) external {
        bytes32[] memory eventHashes = new bytes32[](events_.length);
        for (uint256 i = 0; i < events_.length; i++) {
            HashiSendEvent calldata e = events_[i];
            eventHashes[i] = _verifiedEventHash(e.chain, e.emitter, e.topics, e.data, e.proof);
        }
        bytes32 eventsHash = EventsHashLib.calc(eventHashes);
        _sendHashMessage(eventsHash);
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

    function _sendHashMessage(bytes32 hash_) private {
        IYaho(yaho).dispatchMessageToAdapters(
            receiveChain,
            threshold,
            eventReceiver,
            abi.encode(hash_),
            _asReporters(_reporters),
            _asAdapters(_adapters)
        );
    }

    function _asReporters(address[] memory a_) private pure returns (IReporter[] memory c) {
        assembly { c := a_ }
    }

    function _asAdapters(address[] memory a_) private pure returns (IAdapter[] memory c) {
        assembly { c := a_ }
    }
}
