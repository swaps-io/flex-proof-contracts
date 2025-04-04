// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {EventHashLib} from "../libraries/EventHashLib.sol";

library EventHashLibTest {
    function calc(
        uint256 chain_,
        address emitter_,
        bytes32[] memory topics_,
        bytes memory data_
    ) public pure returns (bytes32) {
        return EventHashLib.calc(chain_, emitter_, topics_, data_);
    }
}
