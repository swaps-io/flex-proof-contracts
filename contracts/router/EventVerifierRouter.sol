// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {Ownable2Step, Ownable} from "@openzeppelin/contracts/access/Ownable2Step.sol";
import {Multicall} from "@openzeppelin/contracts/utils/Multicall.sol";

import {IEventVerifierRouter, IEventVerifier} from "./interfaces/IEventVerifierRouter.sol";

import {RouterProofLib, RouterProof} from "./libraries/RouterProofLib.sol";

contract EventVerifierRouter is IEventVerifierRouter, Ownable2Step, Multicall {
    mapping(uint256 chain => mapping(uint256 variant => address)) public override chainVariantProvider;

    constructor(address initialOwner_)
        Ownable(initialOwner_) {}

    function setChainVariantProvider(uint256 chain_, uint256 variant_, address provider_) external override onlyOwner {
        address oldProvider = chainVariantProvider[chain_][variant_];
        require(provider_ != oldProvider, SameChainVariantProvider(chain_, variant_, provider_));
        chainVariantProvider[chain_][variant_] = provider_;
        emit ChainVariantProviderUpdate(chain_, variant_, oldProvider, provider_);
    }

    function verifyEvent(
        uint256 chain_,
        address emitter_,
        bytes32[] memory topics_,
        bytes memory data_,
        bytes calldata proof_
    ) external override {
        RouterProof calldata routerProof = RouterProofLib.decode(proof_);
        address provider = chainVariantProvider[chain_][routerProof.variant];
        require(provider != address(0), NoChainVariantProvider(chain_, routerProof.variant));
        IEventVerifier(provider).verifyEvent(chain_, emitter_, topics_, data_, RouterProofLib.consume(proof_));
    }
}
