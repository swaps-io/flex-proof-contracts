// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {IEventVerifier} from "../../../../interfaces/IEventVerifier.sol";

interface IHashiMessageEventVerifier is IEventVerifier {
    error BatchEventHashMismatch(bytes32 eventHash, bytes32 batchEventHash, uint256 batchEventIndex);
    error AdaptersHashMismatch(bytes32 adaptersHash, bytes32 proofAdaptersHash);
    error MessageNotConfirmed(uint256 messageId, address[] adapters);

    function chain() external view returns (uint256);

    function sender() external view returns (address);

    function yaho() external view returns (address);

    function hashi() external view returns (address);

    function threshold() external view returns (uint256);

    function adaptersHash() external view returns (bytes32);
}
