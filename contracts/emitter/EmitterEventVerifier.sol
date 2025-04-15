// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {IEmitterEventVerifier, IEventVerifier} from "./interfaces/IEmitterEventVerifier.sol";

contract EmitterEventVerifier is IEmitterEventVerifier {
    function verifyEvent(
        uint256 chain_,
        address emitter_,
        bytes32[] calldata topics_,
        bytes calldata data_,
        bytes calldata proof_
    ) external {
        IEventVerifier(emitter_).verifyEvent(chain_, emitter_, topics_, data_, proof_);
    }
}
