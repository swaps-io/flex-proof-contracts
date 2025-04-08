// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {EventHashLib} from "../../libraries/EventHashLib.sol";

import {SaveEventProofLib, SaveEventProof} from "./SaveEventProofLib.sol";

import {ISaveEventVerifier, IEventVerifier} from "./interfaces/ISaveEventVerifier.sol";

contract SaveEventVerifier is ISaveEventVerifier {
    address public immutable eventVerifier;

    mapping(bytes32 eventHash => bool) public eventSaved;

    constructor(address eventVerifier_) {
        eventVerifier = eventVerifier_;
    }

    function verifyEvent(
        uint256 chain_,
        address emitter_,
        bytes32[] calldata topics_,
        bytes calldata data_,
        bytes calldata proof_
    ) external {
        bytes32 eventHash = EventHashLib.calc(chain_, emitter_, topics_, data_);
        if (eventSaved[eventHash]) return; // Valid event saved prior

        SaveEventProof calldata saveProof = SaveEventProofLib.decode(proof_);
        if (saveProof.flags & 2 != 0) revert EventNotSaved(eventHash); // #1: no verify attempt after missing save

        IEventVerifier(eventVerifier).verifyEvent(chain_, emitter_, topics_, data_, SaveEventProofLib.consume(proof_));

        if (saveProof.flags & 1 != 0) eventSaved[eventHash] = true; // #0: should save verified
    }
}
