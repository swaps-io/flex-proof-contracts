// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {IHashStorageEventVerifier} from "./interfaces/IHashStorageEventVerifier.sol";
import {IHashStorage} from "./interfaces/IHashStorage.sol";

contract HashStorageEventVerifier is IHashStorageEventVerifier {
    function verifyEvent(
        uint256 chain_,
        address emitter_,
        bytes32[] calldata topics_,
        bytes calldata /* data_ */,
        bytes calldata /* proof_ */
    ) external view override {
        require(chain_ == block.chainid, EventChainMismatch(block.chainid, chain_));
        require(topics_.length >= 2, TooFewEventTopics(2, topics_));
        bytes32 eventHash = keccak256(abi.encode(topics_[0], topics_[1])); // `EventHashLib` compat
        require(IHashStorage(emitter_).hasHashStore(eventHash), NoEventHashStored(eventHash));
    }
}
