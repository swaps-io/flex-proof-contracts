// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {IJushin, IAdapter} from "../providers/hashi/libraries/hashi/interfaces/IJushin.sol";

contract YaruTest {
    function callJushin(
        address jushin_,
        uint256 messageId_,
        uint256 sourceChainId_,
        address sender_,
        uint256 threshold_,
        IAdapter[] calldata adapters_,
        bytes calldata data_
    ) external {
        IJushin(jushin_).onMessage(
            messageId_,
            sourceChainId_,
            sender_,
            threshold_,
            adapters_,
            data_
        );
    }
}
