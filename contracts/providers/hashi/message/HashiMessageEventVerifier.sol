// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {IShoyuBashi} from "@gnosis/hashi-evm/contracts/interfaces/IShoyuBashi.sol";
import {MessageHashCalculator, Message} from "@gnosis/hashi-evm/contracts/utils/MessageHashCalculator.sol";
import {MessageIdCalculator} from "@gnosis/hashi-evm/contracts/utils/MessageIdCalculator.sol";

import {EventHashLib} from "../../../libraries/EventHashLib.sol";

import {IHashiMessageEventVerifier} from "./interfaces/IHashiMessageEventVerifier.sol";
import {IHashiMessageSenderRouter} from "./interfaces/IHashiMessageSenderRouter.sol";

import {HashiMessageProofLib, HashiMessageProof} from "./libraries/HashiMessageProofLib.sol";
import {HashiMessageDataLib} from "./libraries/HashiMessageDataLib.sol";

contract HashiMessageEventVerifier is IHashiMessageEventVerifier, MessageHashCalculator, MessageIdCalculator {
    address public immutable override shoyuBashi;
    address public immutable override senderRouter;

    constructor(address shoyuBashi_, address senderRouter_) {
        shoyuBashi = shoyuBashi_;
        senderRouter = senderRouter_;
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

        (uint256 threshold, ) = IShoyuBashi(shoyuBashi).getThresholdAndCount(chain_);
        address sender = IHashiMessageSenderRouter(senderRouter).domainSender(chain_);

        Message memory message = Message({
            nonce: messageProof.nonce,
            targetChainId: block.chainid,
            threshold: threshold,
            sender: sender,
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
}
