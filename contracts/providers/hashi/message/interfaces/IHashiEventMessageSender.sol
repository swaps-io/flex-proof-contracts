// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {HashiMessageEvent} from "./HashiMessageEvent.sol";
import {HashiMessageParams} from "./HashiMessageParams.sol";

interface IHashiEventMessageSender {
    error EmptyEventBatch();

    function eventVerifier() external view returns (address);

    function yaho() external view returns (address);

    function sendEventMessage(HashiMessageEvent[] calldata events, HashiMessageParams calldata params) external payable;
}
