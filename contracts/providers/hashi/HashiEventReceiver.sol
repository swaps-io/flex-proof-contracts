// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {IAdapter} from "./libraries/hashi/interfaces/IAdapter.sol";

import {IHashiEventReceiver} from "./interfaces/IHashiEventReceiver.sol";

contract HashiEventReceiver is IHashiEventReceiver {
    uint256 public immutable sendChain;
    address public immutable eventSender;
    address public immutable yaru;
    uint256 public immutable threshold;
    bytes32 public immutable adaptersHash;

    mapping(bytes32 eventHash => bool) public eventHashReceived;

    constructor(
        uint256 sendChain_,
        address eventSender_,
        address yaru_,
        uint256 threshold_,
        address[] memory adapters_
    ) {
        sendChain = sendChain_;
        eventSender = eventSender_;
        yaru = yaru_;
        threshold = threshold_;
        adaptersHash = _calcAdaptersHash(adapters_);
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
        eventHashReceived[hash] = true;

        return '';
    }

    function _calcAdaptersHash(address[] memory adapters_) private pure returns (bytes32 hash) {
        assembly { hash := keccak256(add(adapters_, 32), mul(mload(adapters_), 32)) }
    }

    function _asAddresses(IAdapter[] memory a_) private pure returns (address[] memory c) {
        assembly { c := a_ }
    }
}
