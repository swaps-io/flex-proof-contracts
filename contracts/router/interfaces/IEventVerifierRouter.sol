// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {IEventVerifier} from "../../interfaces/IEventVerifier.sol";

interface IEventVerifierRouter is IEventVerifier {
    error SameChainVariantProvider(uint256 chain, uint256 variant, address provider);
    error NoChainVariantProvider(uint256 chain, uint256 variant);

    event ChainVariantProviderUpdate(uint256 indexed chain, uint256 indexed variant, address oldProvider, address newProvider);

    function chainVariantProvider(uint256 chain, uint256 variant) external view returns (address);

    function setChainVariantProvider(uint256 chain, uint256 variant, address provider) external; // Only owner
}
