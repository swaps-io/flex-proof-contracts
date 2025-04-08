// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {IJushin} from "../libraries/hashi/interfaces/IJushin.sol";

interface IHashiEventReceiver is IJushin {
    error MessageCallerMismatch(address expectedCaller, address caller);
    error MessageChainMismatch(uint256 expectedChain, uint256 chain);
    error MessageSenderMismatch(address expectedSender, address sender);
    error MessageThresholdMismatch(uint256 expectedThreshold, uint256 threshold);
    error MessageAdaptersMismatch(bytes32 expectedAdapterHash, bytes32 adapterHash);
    error MessageLengthMismatch(uint256 expectedLength, uint256 length);

    function sendChain() external view returns (uint256);

    function eventSender() external view returns (address);

    function yaru() external view returns (address);

    function threshold() external view returns (uint256);

    function adaptersHash() external view returns (bytes32);

    function eventHashReceived(bytes32 eventHash) external view returns (bool);
}
