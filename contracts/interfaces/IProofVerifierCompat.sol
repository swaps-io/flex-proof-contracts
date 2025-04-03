// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {IProofVerifier} from "./IProofVerifier.sol";

interface IProofVerifierCompat is IProofVerifier {
    error SameChainEmitter(uint256 chain, address emitter);
    error NoChainEmitter(uint256 chain);

    event ChainEmitterUpdate(uint256 indexed chain, address oldEmitter, address newEmitter);

    function eventVerifier() external view returns (address);

    function chainEmitter(uint256 chain) external view returns (address);

    function setChainEmitter(uint256 chain, address emitter) external; // Only owner
}
