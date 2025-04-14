// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {IHashiProofShoyuBashi} from "./IHashiProofShoyuBashi.sol";

interface IHashiLightClientShoyuBashi is IHashiProofShoyuBashi {
    error LightClientChainMismatch(uint256 expectedChain, uint256 chain);
    error LightClientMissingHeader(uint256 blockNumber);

    function chain() external view returns (uint256);

    function lightClient() external view returns (address);
}
