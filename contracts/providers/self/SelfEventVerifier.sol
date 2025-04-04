// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {ISelfEventVerifier} from "./interfaces/ISelfEventVerifier.sol";

abstract contract SelfEventVerifier is ISelfEventVerifier {
    function verifyEvent(
        uint256 chain_,
        address emitter_,
        bytes32[] calldata topics_,
        bytes calldata data_,
        bytes calldata proof_
    ) external {
        require(chain_ == block.chainid, EventChainMismatch(chain_, block.chainid));
        require(emitter_ == address(this), EventEmitterMismatch(emitter_, address(this)));
        _selfVerifyEvent(topics_, data_, proof_);
    }

    function _selfVerifyEvent(
        bytes32[] calldata topics_,
        bytes calldata data_,
        bytes calldata proof_
    ) internal virtual;
}
