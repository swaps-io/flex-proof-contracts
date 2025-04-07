// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {HashiBatchEvent, HashiBatchEventNoChain, HashiBatchEventNoChainEmitter} from "./HashiBatchEvent.sol";
import {IHashiEventSenderInfra} from "./IHashiEventSenderInfra.sol";

interface IHashiBatchEventSender is IHashiEventSenderInfra {
    function sendEventBatch(HashiBatchEvent[] calldata events) external;

    function sendEventBatch(uint256 chain, HashiBatchEventNoChain[] calldata events) external;

    function sendEventBatch(uint256 chain, address emitter, HashiBatchEventNoChainEmitter[] calldata events) external;
}
