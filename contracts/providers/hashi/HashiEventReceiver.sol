// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {IAdapter} from "./libraries/hashi/interfaces/IAdapter.sol";

import {IHashiEventReceiver} from "./interfaces/IHashiEventReceiver.sol";

contract HashiEventReceiver is IHashiEventReceiver {
    address public immutable yaro;

    constructor(
        address yaro_
    ) {
        yaro = yaro_;
    }

    function onMessage(
        uint256 messageId_,
        uint256 sourceChainId_,
        address sender_,
        uint256 threshold_,
        IAdapter[] calldata adapters_,
        bytes calldata data_
    ) external returns (bytes memory) {
        // TODO: implement message handling from Yaro
    }

    function verifyEvent(
        uint256 chain_,
        address emitter_,
        bytes32[] calldata topics_,
        bytes calldata data_,
        bytes calldata proof_
    ) external {
        // TODO: implement event verification
    }
}
