// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {EventHashLib} from "../../libraries/EventHashLib.sol";

import {IHashiEventReceiveVerifier} from "./interfaces/IHashiEventReceiveVerifier.sol";
import {IHashiEventReceiver} from "./interfaces/IHashiEventReceiver.sol";

contract HashiEventReceiveVerifier is IHashiEventReceiveVerifier {
    address public immutable eventReceiver;

    constructor(address eventReceiver_) {
        eventReceiver = eventReceiver_;
    }

    function verifyEvent(
        uint256 chain_,
        address emitter_,
        bytes32[] calldata topics_,
        bytes calldata data_,
        bytes calldata /* proof_ */
    ) external view {
        bytes32 eventHash = EventHashLib.calc(chain_, emitter_, topics_, data_);
        require(IHashiEventReceiver(eventReceiver).eventHashReceived(eventHash), EventNotReceived(eventHash));
    }
}
