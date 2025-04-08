// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {IEventVerifier} from "../../../interfaces/IEventVerifier.sol";

interface ISaveEventVerifier is IEventVerifier {
    error EventNotSaved(bytes32 eventHash);

    function eventVerifier() external view returns (address);

    function eventSaved(bytes32 eventHash) external view returns (bool);
}
