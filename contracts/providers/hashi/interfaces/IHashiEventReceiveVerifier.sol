// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {IEventVerifier} from "../../../interfaces/IEventVerifier.sol";

interface IHashiEventReceiveVerifier is IEventVerifier {
    error EventNotReceived(bytes32 eventHash);

    function eventReceiver() external view returns (address);
}
