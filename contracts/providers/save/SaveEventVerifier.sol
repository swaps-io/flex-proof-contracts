// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {EventHashLib} from "../../libraries/EventHashLib.sol";

import {SaveEventProofLib} from "./SaveEventProofLib.sol";

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
        uint256 flags = SaveEventProofLib.decode(proof_).flags;
        if (flags & 1 == 0) { // #0: should perform event verification (else: use saved event)
            bytes32 eventHash = EventHashLib.calc(chain_, emitter_, topics_, data_);
            require(eventSaved[eventHash], EventNotSaved(eventHash));
        } else {
            IEventVerifier(eventVerifier).verifyEvent(chain_, emitter_, topics_, data_, SaveEventProofLib.consume(proof_));
            if (flags & 2 != 0) { // #1: should perform save of verified event
                bytes32 eventHash = EventHashLib.calc(chain_, emitter_, topics_, data_);
                eventSaved[eventHash] = true;
            }
        }
    }
}
