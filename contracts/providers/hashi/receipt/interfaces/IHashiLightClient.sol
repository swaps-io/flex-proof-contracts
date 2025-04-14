// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

interface IHashiLightClient {
    function headers(uint256 blockNumber) external view returns (bytes32);
}
