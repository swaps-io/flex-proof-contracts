// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

library EventHashLib {
    // keccak256("Event(uint256 chain,address emitter,bytes32[] topics,bytes data)")
    bytes32 private constant EVENT_TYPE_HASH = 0xba547a928a5c301ff66788fd50849d5b685e0bd0b3147c4917984147f4248c04;

    function calc(
        uint256 chain_,
        address emitter_,
        bytes32[] memory topics_,
        bytes memory data_
    ) internal pure returns (bytes32 hash) {
        assembly { hash := keccak256(add(topics_, 32), mul(mload(topics_), 32)) }
        hash = keccak256(abi.encode(EVENT_TYPE_HASH, chain_, emitter_, hash, keccak256(data_)));
    }
}
