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
        assembly ("memory-safe") {
            let ptr := mload(0x40)
            mstore(ptr, EVENT_TYPE_HASH)
            mstore(add(ptr, 0x20), chain_)
            mstore(add(ptr, 0x40), emitter_)
            mstore(add(ptr, 0x60), keccak256(add(topics_, 0x20), mul(mload(topics_), 0x20)))
            mstore(add(ptr, 0x80), keccak256(add(data_, 0x20), mload(data_)))
            hash := keccak256(ptr, 0xa0)
        }
    }
}
