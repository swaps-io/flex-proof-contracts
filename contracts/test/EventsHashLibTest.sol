// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {EventsHashLib} from "../libraries/EventsHashLib.sol";

library EventsHashLibTest {
    function calc(bytes32[] memory eventHashes_) public pure returns (bytes32) {
        return EventsHashLib.calc(eventHashes_);
    }
}
