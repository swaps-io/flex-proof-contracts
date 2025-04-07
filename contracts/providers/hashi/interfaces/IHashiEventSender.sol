// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {HashiSendEvent} from "./HashiSendEvent.sol";

interface IHashiEventSender {
    function eventVerifier() external view returns (address);

    function receiveChain() external view returns (uint256);

    function eventReceiver() external view returns (address);

    function yaho() external view returns (address);

    function threshold() external view returns (uint256);

    function reporters() external view returns (address[] memory);

    function adapters() external view returns (address[] memory);

    function sendEvent(
        uint256 chain,
        address emitter,
        bytes32[] calldata topics,
        bytes calldata data,
        bytes calldata proof
    ) external;

    function sendEvents(HashiSendEvent[] calldata events) external;
}
