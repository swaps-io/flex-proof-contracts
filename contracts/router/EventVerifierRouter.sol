// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {Ownable2Step, Ownable} from "@openzeppelin/contracts/access/Ownable2Step.sol";
import {Multicall} from "@openzeppelin/contracts/utils/Multicall.sol";

import {EventHashLib} from "../libraries/EventHashLib.sol";

import {IEventVerifierRouter, IEventVerifier} from "./interfaces/IEventVerifierRouter.sol";

import {RouterProofLib, RouterProof} from "./libraries/RouterProofLib.sol";

contract EventVerifierRouter is IEventVerifierRouter, Ownable2Step, Multicall {
    uint256 private constant EMITTER_VERIFIER_BIT = 1 << 255;
    uint256 private constant EMIT_EVENT_VERIFY_BIT = 1 << 254;
    uint256 private constant PROVIDER_VARIANT_MASK = ~(EMITTER_VERIFIER_BIT | EMIT_EVENT_VERIFY_BIT);
    bytes32 private constant EVENT_VERIFY_SIGNATURE = 0x6cd36dcc6f96864e428558cad95b6c499ce5ea37cfa95110af6c5239fbdf90cf; // keccak256("EventVerify(bytes32)")

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
        RouterProof calldata routerProof = RouterProofLib.decode(proof_);
        for (uint256 i = 0; i < routerProof.relayChains.length; i++) {
            bytes32 eventHash = EventHashLib.calc(chain_, emitter_, topics_, data_);
            chain_ = routerProof.relayChains[i];
            emitter_ = chainRouter[chain_];
            require(emitter_ != address(0), NoChainRouter(chain_));
            topics_ = new bytes32[](2);
            topics_[0] = EVENT_VERIFY_SIGNATURE;
            topics_[1] = eventHash;
            data_ = '';
        }

        address provider;
        if (routerProof.variant & EMITTER_VERIFIER_BIT == 0) {
            uint256 variant = routerProof.variant & PROVIDER_VARIANT_MASK;
            provider = chainVariantProvider[chain_][variant];
            require(provider != address(0), NoChainVariantProvider(chain_, variant));
        } else {
            provider = emitter_;
        }
        IEventVerifier(provider).verifyEvent(chain_, emitter_, topics_, data_, RouterProofLib.consume(proof_));

        if (routerProof.variant & EMIT_EVENT_VERIFY_BIT != 0) {
            bytes32 eventHash = EventHashLib.calc(chain_, emitter_, topics_, data_);
            emit EventVerify(eventHash);
        }
    }
}
