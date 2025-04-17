// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

library HashiMessageDataLib {
    function calc(bytes32[] memory eventHashes_) internal pure returns (bytes memory data) {
        data = new bytes(32);
        assembly { mstore(add(data, 32), keccak256(add(eventHashes_, 32), mul(mload(eventHashes_), 32))) }
    }
}
