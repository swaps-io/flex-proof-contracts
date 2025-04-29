// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {IEventVerifier} from "../../interfaces/IEventVerifier.sol";

interface IHashStorageEventVerifier is IEventVerifier {
    error EventChainMismatch(uint256 chain, uint256 eventChain);
    error TooFewEventTopics(uint256 minTopics, bytes32[] eventTopics);
    error NoEventHashStored(bytes32 eventHash);
}
