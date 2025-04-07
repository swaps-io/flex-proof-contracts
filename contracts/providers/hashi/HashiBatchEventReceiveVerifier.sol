// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {EventHashLib} from "../../libraries/EventHashLib.sol";
import {EventsHashLib} from "../../libraries/EventsHashLib.sol";

import {HashiBatchReceiveProofLib, HashiBatchReceiveProof} from "./libraries/HashiBatchReceiveProofLib.sol";

import {IHashiBatchEventReceiveVerifier} from "./interfaces/IHashiBatchEventReceiveVerifier.sol";
import {IHashiEventReceiver} from "./interfaces/IHashiEventReceiver.sol";

contract HashiBatchEventReceiveVerifier is IHashiBatchEventReceiveVerifier {
    address public immutable eventReceiver;

    constructor(address eventReceiver_) {
        eventReceiver = eventReceiver_;
    }

    function verifyEvent(
        uint256 chain_,
        address emitter_,
        bytes32[] calldata topics_,
        bytes calldata data_,
        bytes calldata proof_
    ) external view {
        bytes32 eventHash = EventHashLib.calc(chain_, emitter_, topics_, data_);

        HashiBatchReceiveProof calldata batchProof = HashiBatchReceiveProofLib.decode(proof_);
        bytes32 batchEventHash = batchProof.eventHashes[batchProof.eventIndex];
        require(batchEventHash == eventHash, BatchEventHashMismatch(batchProof.eventIndex, batchEventHash, eventHash));

        bytes32 eventsHash = EventsHashLib.calc(batchProof.eventHashes);
        require(IHashiEventReceiver(eventReceiver).eventHashReceived(eventsHash), EventHashNotReceived(eventsHash));
    }
}
