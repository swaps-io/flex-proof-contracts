// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {IEventVerifier} from "../../../interfaces/IEventVerifier.sol";

interface IHashiEventVerifier is IEventVerifier {
    error ProofChainMismatch(uint256 chain, uint256 proofChain);
    error ProofEventMismatch(bytes rlpEvent, bytes proofRlpEvent);

    function shoyuBashi() external view returns (address);
}
