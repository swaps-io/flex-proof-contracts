// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {Ownable2Step, Ownable} from "@openzeppelin/contracts/access/Ownable2Step.sol";

import {IEventVerifier} from "../interfaces/IEventVerifier.sol";

import {IProofVerifierCompat} from "./interfaces/IProofVerifierCompat.sol";

contract ProofVerifierCompat is IProofVerifierCompat, Ownable2Step {
    address public immutable eventVerifier;
    mapping(uint256 chain => address) public chainEmitter;

    constructor(address eventVerifier_, address initialOwner_)
        Ownable(initialOwner_) {
        eventVerifier = eventVerifier_;
    }

    function setChainEmitter(uint256 chain_, address emitter_) external onlyOwner {
        address oldEmitter = chainEmitter[chain_];
        require(emitter_ != oldEmitter, SameChainEmitter(chain_, emitter_));
        chainEmitter[chain_] = emitter_;
        emit ChainEmitterUpdate(chain_, oldEmitter, emitter_);
    }

    function verifyHashEventProof(
        bytes32 sig_,
        bytes32 hash_,
        uint256 chain_,
        bytes calldata proof_
    ) external override {
        address emitter = chainEmitter[chain_];
        require(emitter != address(0), NoChainEmitter(chain_));

        bytes32[] memory topics = new bytes32[](2);
        topics[0] = sig_;
        topics[1] = hash_;
        bytes memory data = new bytes(0);

        IEventVerifier(eventVerifier).verifyEvent(chain_, emitter, topics, data, proof_);
    }
}
