// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

library EventsHashLib {
    function calc(bytes32[] memory eventHashes_) internal pure returns (bytes32 hash) {
        assembly { hash := keccak256(add(eventHashes_, 32), mul(mload(eventHashes_), 32)) }
    }
}
