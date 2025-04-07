// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {IAdapter} from "./libraries/hashi/interfaces/IAdapter.sol";

import {IHashiEventReceiverInfra} from "./interfaces/IHashiEventReceiverInfra.sol";
import {HashiEventReceiverInfraConfig} from "./interfaces/HashiEventReceiverInfraConfig.sol";

contract HashiEventReceiverInfra is IHashiEventReceiverInfra {
    uint256 public immutable sendChain;
    address public immutable eventSender;
    address public immutable yaru;
    uint256 public immutable threshold;
    bytes32 public immutable adaptersHash;

    constructor(HashiEventReceiverInfraConfig memory config_) {
        sendChain = config_.sendChain;
        eventSender = config_.eventSender;
        yaru = config_.yaru;
        threshold = config_.threshold;
        adaptersHash = _calcAdaptersHash(config_.adapters);
    }

    function onMessage(
        uint256 /* messageId_ */,
        uint256 sourceChainId_,
        address sender_,
        uint256 threshold_,
        IAdapter[] calldata adapters_,
        bytes calldata data_
    ) external returns (bytes memory) {
        // TODO: use custom errors
        require(msg.sender == yaru, "only called by Yaru");
        require(sourceChainId_ == sendChain, "invalid source chain ID");
        require(sender_ == eventSender, "invalid sender address from source chain");
        require(threshold_ == threshold, "invalid number of threshold");
        require(_calcAdaptersHash(_asAddresses(adapters_)) == adaptersHash, "invalid adapters hash");
        require(data_.length == 32, "invalid data length");

        bytes32 hash = bytes32(data_[0:32]);
        _receiveHashMessage(hash);

        return '';
    }

    function _receiveHashMessage(bytes32 hash_) internal virtual {}

    function _calcAdaptersHash(address[] memory adapters_) private pure returns (bytes32 hash) {
        assembly { hash := keccak256(add(adapters_, 32), mul(mload(adapters_), 32)) }
    }

    function _asAddresses(IAdapter[] memory a_) private pure returns (address[] memory c) {
        assembly { c := a_ }
    }
}
