// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

// Part of `IShoyuBashi` interface required for `HashiProverLib.verifyForeignEvent` functionality

interface IHashiProofShoyuBashi {
    function getThresholdHash(uint256 domain, uint256 id) external view returns (bytes32);
}
