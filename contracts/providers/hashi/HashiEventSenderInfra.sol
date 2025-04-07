// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {IYaho, IReporter, IAdapter} from "./libraries/hashi/interfaces/IYaho.sol";

import {IHashiEventSenderInfra} from "./interfaces/IHashiEventSenderInfra.sol";
import {HashiEventSenderInfraConfig} from "./interfaces/HashiEventSenderInfraConfig.sol";

contract HashiEventSenderInfra is IHashiEventSenderInfra {
    address public immutable eventVerifier;
    uint256 public immutable receiveChain;
    address public immutable eventReceiver;
    address public immutable yaho;
    uint256 public immutable threshold;

    address[] private _reporters;
    address[] private _adapters;

    constructor(HashiEventSenderInfraConfig memory config_) {
        eventVerifier = config_.eventVerifier;
        receiveChain = config_.receiveChain;
        eventReceiver = config_.eventReceiver;
        yaho = config_.yaho;
        threshold = config_.threshold;
        _reporters = config_.reporters;
        _adapters = config_.adapters;
    }

    function reporters() public view returns (address[] memory) {
        return _reporters;
    }

    function adapters() public view returns (address[] memory) {
        return _adapters;
    }

    function _sendHashMessage(bytes32 hash_) internal {
        IYaho(yaho).dispatchMessageToAdapters(
            receiveChain,
            threshold,
            eventReceiver,
            abi.encode(hash_),
            _asReporters(_reporters),
            _asAdapters(_adapters)
        );
    }

    function _asReporters(address[] memory a_) private pure returns (IReporter[] memory c) {
        assembly { c := a_ }
    }

    function _asAdapters(address[] memory a_) private pure returns (IAdapter[] memory c) {
        assembly { c := a_ }
    }
}
