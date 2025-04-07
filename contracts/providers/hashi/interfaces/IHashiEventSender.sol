// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {IHashiEventSenderInfra} from "./IHashiEventSenderInfra.sol";

interface IHashiEventSender is IHashiEventSenderInfra {
    function sendEvent(
        uint256 chain,
        address emitter,
        bytes32[] calldata topics,
        bytes calldata data,
        bytes calldata proof
    ) external;
}
