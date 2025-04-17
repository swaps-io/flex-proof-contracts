// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {IShoyuBashi, IAdapter} from "@gnosis/hashi-evm/contracts/interfaces/IShoyuBashi.sol";
import {MessageHashCalculator, Message} from "@gnosis/hashi-evm/contracts/utils/MessageHashCalculator.sol";
import {MessageIdCalculator} from "@gnosis/hashi-evm/contracts/utils/MessageIdCalculator.sol";

import {EventHashLib} from "../../../libraries/EventHashLib.sol";

import {IHashiMessageEventVerifier} from "./interfaces/IHashiMessageEventVerifier.sol";

import {HashiMessageProofLib, HashiMessageProof} from "./libraries/HashiMessageProofLib.sol";
import {HashiMessageDataLib} from "./libraries/HashiMessageDataLib.sol";

contract HashiMessageEventVerifier is IHashiMessageEventVerifier, MessageHashCalculator, MessageIdCalculator {
    address public immutable override shoyuBashi;

    constructor(address shoyuBashi_) {
        shoyuBashi = shoyuBashi_;
    }

    function verifyEvent(
        uint256 chain_,
        address emitter_,
        bytes32[] calldata topics_,
        bytes calldata data_,
        bytes calldata proof_
    ) external view override {
        HashiMessageProof calldata messageProof = HashiMessageProofLib.decode(proof_);
        bytes32 eventHash = EventHashLib.calc(chain_, emitter_, topics_, data_);
        bytes32 proofEventHash = messageProof.eventHashes[messageProof.eventIndex];
        require(proofEventHash == eventHash, EventHashMismatch(eventHash, proofEventHash, messageProof.eventIndex));

        Message memory message = Message({
            nonce: messageProof.nonce,
            targetChainId: block.chainid,
            threshold: _getShoyuBashiThreshold(chain_),
            sender: _getShoyuBashiSender(chain_),
            receiver: address(this),
            data: HashiMessageDataLib.calc(messageProof.eventHashes),
            reporters: messageProof.reporters,
            adapters: IShoyuBashi(shoyuBashi).getAdapters(chain_)
        });
        bytes32 messageHash = calculateMessageHash(message);
        uint256 messageId = calculateMessageId(chain_, messageProof.yaho, messageHash);

        bytes32 thresholdHash = IShoyuBashi(shoyuBashi).getThresholdHash(chain_, messageId);
        require(thresholdHash == messageHash, MessageNotConfirmed(chain_, messageId, messageHash, thresholdHash));
    }

    function _getShoyuBashiThreshold(uint256 domain_) private view returns (uint256 threshold) {
        (threshold, ) = IShoyuBashi(shoyuBashi).getThresholdAndCount(domain_);
    }

    function _getShoyuBashiSender(uint256 domain_) private view returns (address sender) {
        uint256 senderDomain = domain_ << 160;
        IAdapter[] memory senderAdapters = IShoyuBashi(shoyuBashi).getAdapters(senderDomain);
        require(senderAdapters.length == 1, InvalidSenderAdapter(domain_, senderDomain, senderAdapters));
        sender = address(senderAdapters[0]);
        require(sender != address(0), InvalidSenderAdapter(domain_, senderDomain, senderAdapters));
    }
}
