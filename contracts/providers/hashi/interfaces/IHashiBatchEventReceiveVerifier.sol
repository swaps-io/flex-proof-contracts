// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {IHashiEventReceiveVerifier} from "./IHashiEventReceiveVerifier.sol";

interface IHashiBatchEventReceiveVerifier is IHashiEventReceiveVerifier {
    error BatchEventHashMismatch(uint256 batchEventIndex, bytes32 batchEventHash, bytes32 eventHash);
}
