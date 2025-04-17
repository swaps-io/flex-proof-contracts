// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {EventHashLib} from "../../libraries/EventHashLib.sol";

import {IRelayEventEmitter, IEventVerifier} from "./interfaces/IRelayEventEmitter.sol";

contract RelayEventEmitter is IRelayEventEmitter {
    address public immutable override eventVerifier;

    constructor(address eventVerifier_) {
        eventVerifier = eventVerifier_;
    }

    function verifyEvent(
        uint256 chain_,
        address emitter_,
        bytes32[] memory topics_,
        bytes memory data_,
        bytes calldata proof_
    ) external override {
        IEventVerifier(eventVerifier).verifyEvent(chain_, emitter_, topics_, data_, proof_);
        bytes32 eventHash = EventHashLib.calc(chain_, emitter_, topics_, data_);
        emit EventVerify(eventHash);
    }
}
