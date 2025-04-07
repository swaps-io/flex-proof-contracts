// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {IHashiEventReceiverInfra} from "./IHashiEventReceiverInfra.sol";

interface IHashiEventReceiver is IHashiEventReceiverInfra {
    function eventHashReceived(bytes32 eventHash) external view returns (bool);
}
