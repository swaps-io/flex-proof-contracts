// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

library HashiEventMessageDataLib {
    function encode(bytes32 hash_) internal pure returns (bytes memory) {
        return abi.encode(hash_);
    }
}
