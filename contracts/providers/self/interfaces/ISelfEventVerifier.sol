// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {IEventVerifier} from "../../../interfaces/IEventVerifier.sol";

interface ISelfEventVerifier is IEventVerifier {
    error EventChainMismatch(uint256 chain, uint256 expectedChain);
    error EventEmitterMismatch(address emitter, address expectedEmitter);
}
