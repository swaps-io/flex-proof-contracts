// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {HashiBatchEvent, HashiBatchEventNoChain, HashiBatchEventNoChainEmitter} from "./HashiBatchEvent.sol";
import {HashiMessageParams} from "./HashiMessageParams.sol";


interface IHashiEventMessageSender {
    function eventVerifier() external view returns (address);

    function sendEvent(
        uint256 chain,
        address emitter,
        bytes32[] calldata topics,
        bytes calldata data,
        bytes calldata proof,
        HashiMessageParams calldata params
    ) external;

    function sendEventBatch(
        HashiBatchEvent[] calldata events,
        HashiMessageParams calldata params
    ) external;

    function sendEventBatch(
        uint256 chain,
        HashiBatchEventNoChain[] calldata events,
        HashiMessageParams calldata params
    ) external;

    function sendEventBatch(
        uint256 chain,
        address emitter,
        HashiBatchEventNoChainEmitter[] calldata events,
        HashiMessageParams calldata params
    ) external;
}
