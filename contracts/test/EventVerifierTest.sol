// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {EventHashLib} from "../libraries/EventHashLib.sol";

import {IEventVerifier} from "../interfaces/IEventVerifier.sol";

contract EventVerifierTest {
    event EventVerifyTest(bytes32 indexed eventHash);

    address public immutable eventVerifier;

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
        IEventVerifier(eventVerifier).verifyEvent(chain_, emitter_, topics_, data_, proof_);
        bytes32 eventHash = EventHashLib.calc(chain_, emitter_, topics_, data_);
        emit EventVerifyTest(eventHash);
    }
}
