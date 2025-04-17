// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {HashiMessageDataLib} from "../providers/hashi/message/libraries/HashiMessageDataLib.sol";

library HashiMessageDataLibTest {
    function calc(bytes32[] calldata eventHashes_) public pure returns (bytes memory) {
        return HashiMessageDataLib.calc(eventHashes_);
    }
}
