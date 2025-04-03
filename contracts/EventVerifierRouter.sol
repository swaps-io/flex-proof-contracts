// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {Ownable2Step, Ownable} from "@openzeppelin/contracts/access/Ownable2Step.sol";

import {IEventVerifierRouter, IEventVerifier} from "./interfaces/IEventVerifierRouter.sol";

contract EventVerifierRouter is IEventVerifierRouter, Ownable2Step {
    mapping(uint256 chain => address) public chainRouter;
    mapping(uint256 chain => mapping(uint256 variant => address)) public chainVariantProvider;

    constructor(address initialOwner_)
        Ownable(initialOwner_) {}

    function setChainRouter(uint256 chain_, address router_) external onlyOwner {
        address oldRouter = chainRouter[chain_];
        require(router_ != oldRouter, SameChainRouter(chain_, router_));
        chainRouter[chain_] = router_;
        emit ChainRouterUpdate(chain_, oldRouter, router_);
    }

    function setChainVariantProvider(uint256 chain_, uint256 variant_, address provider_) external onlyOwner {
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
        // TODO: extract this data from `proof_` structure
        uint256 variant = uint256(bytes32(proof_[0:32]));
        bytes memory providerProof = proof_[32:];
        //

        // TODO: port emit & relay logic, self verifier logic, storage save (?)

        address provider = chainVariantProvider[chain_][variant];
        require(provider != address(0), NoChainVariantProvider(chain_, variant));

        IEventVerifier(provider).verifyEvent(chain_, emitter_, topics_, data_, providerProof);
    }
}
