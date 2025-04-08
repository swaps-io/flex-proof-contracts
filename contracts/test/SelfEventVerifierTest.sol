// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {SelfEventVerifier} from "../providers/self/SelfEventVerifier.sol";

contract SelfEventVerifierTest is SelfEventVerifier {
    error UnexpectedEventSignature();
    error UnexpectedEventArgument();
    error UnexpectedEventDataHash();
    error UnexpectedEventProofLength();

    bytes32 public constant EXPECTED_EVENT_SIGNATURE = keccak256('ExpectedEvent(uint256)');
    uint256 public constant EXPECTED_EVENT_ARGUMENT = 133713371337;
    bytes32 public constant EXPECTED_EVENT_DATA_HASH = keccak256('test-event-data');

    function _selfVerifyEvent(
        bytes32[] calldata topics_,
        bytes calldata data_,
        bytes calldata proof_
    ) internal pure override {
        if (topics_[0] == EXPECTED_EVENT_SIGNATURE) {
            require(topics_[1] == bytes32(EXPECTED_EVENT_ARGUMENT), UnexpectedEventArgument());
            require(keccak256(data_) == EXPECTED_EVENT_DATA_HASH, UnexpectedEventDataHash());
            require(proof_.length == 0, UnexpectedEventProofLength());
            return;
        }
        revert UnexpectedEventSignature();
    }
}
