// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {IEventVerifier} from "../../interfaces/IEventVerifier.sol";

interface IEventVerifierRouter is IEventVerifier {
    error SameChainRouter(uint256 chain, address router);
    error SameChainVariantProvider(uint256 chain, uint256 variant, address provider);
    error NoChainRouter(uint256 chain);
    error NoChainVariantProvider(uint256 chain, uint256 variant);

    event ChainRouterUpdate(uint256 indexed chain, address oldRouter, address newRouter);
    event ChainVariantProviderUpdate(uint256 indexed chain, uint256 indexed variant, address oldProvider, address newProvider);
    event EventVerify(bytes32 indexed eventHash);

    function chainRouter(uint256 chain) external view returns (address);

    function chainVariantProvider(uint256 chain, uint256 variant) external view returns (address);

    function setChainRouter(uint256 chain, address router) external; // Only owner

    function setChainVariantProvider(uint256 chain, uint256 variant, address provider) external; // Only owner
}
