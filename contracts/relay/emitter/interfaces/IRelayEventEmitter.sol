// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {IEventVerifier} from "../../../interfaces/IEventVerifier.sol";

interface IRelayEventEmitter is IEventVerifier {
    event EventVerify(bytes32 indexed eventHash);

    function eventVerifier() external view returns (address);
}
