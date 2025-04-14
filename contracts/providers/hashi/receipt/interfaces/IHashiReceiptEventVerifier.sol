// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {IEventVerifier} from "../../../../interfaces/IEventVerifier.sol";

interface IHashiReceiptEventVerifier is IEventVerifier {
    error ReceiptChainMismatch(uint256 chain, uint256 proofChain);
    error ReceiptEventMismatch(bytes rlpEvent, bytes proofRlpEvent);

    function shoyuBashi() external view returns (address);
}
