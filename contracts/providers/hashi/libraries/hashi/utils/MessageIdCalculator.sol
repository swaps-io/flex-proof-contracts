// SPDX-License-Identifier: LGPL-3.0-only
pragma solidity ^0.8.20;

import { IMessageIdCalculator } from "../interfaces/IMessageIdCalculator.sol";

contract MessageIdCalculator is IMessageIdCalculator {
    /// @inheritdoc IMessageIdCalculator
    function calculateMessageId(
        uint256 sourceChainId,
        address dispatcherAddress,
        bytes32 messageHash
    ) public pure returns (uint256) {
        return uint256(keccak256(abi.encode(sourceChainId, dispatcherAddress, messageHash)));
    }
}