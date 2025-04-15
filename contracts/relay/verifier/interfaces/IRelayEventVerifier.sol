// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {IEventVerifier} from "../../../interfaces/IEventVerifier.sol";

interface IRelayEventVerifier is IEventVerifier {
    error SameChainRelayEmitter(uint256 chain, address emitter);
    error NoChainRelayEmitter(uint256 chain);

    event ChainRelayEmitterUpdate(uint256 indexed chain, address oldEmitter, address newEmitter);

    function eventVerifier() external view returns (address);

    function chainRelayEmitter(uint256 chain) external view returns (address);

    function setChainRelayEmitter(uint256 chain, address emitter) external; // Only owner
}
