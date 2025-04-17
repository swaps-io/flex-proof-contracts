// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {IEventVerifier} from "../../../../interfaces/IEventVerifier.sol";

interface IHashiMessageEventVerifier is IEventVerifier {
    error EventHashMismatch(bytes32 eventHash, bytes32 proofEventHash, uint256 proofEventIndex);
    error MessageNotConfirmed(uint256 domain, uint256 messageId, bytes32 messageHash, bytes32 thresholdHash);

    function shoyuBashi() external view returns (address);
}
