// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {EventHashLib} from "../../../libraries/EventHashLib.sol";
import {EventsHashLib} from "../../../libraries/EventsHashLib.sol";

import {MessageHashCalculator, Message} from "../libraries/hashi/utils/MessageHashCalculator.sol";
import {MessageIdCalculator} from "../libraries/hashi/utils/MessageIdCalculator.sol";
import {IHashi} from "../libraries/hashi/interfaces/IHashi.sol";

import {IHashiMessageEventVerifier} from "./interfaces/IHashiMessageEventVerifier.sol";

import {HashiMessageProofLib, HashiMessageProof} from "./libraries/HashiMessageProofLib.sol";
import {HashiEventMessageDataLib} from "./libraries/HashiEventMessageDataLib.sol";
import {HashiMessageCastLib} from "./libraries/HashiMessageCastLib.sol";

contract HashiMessageEventVerifier is IHashiMessageEventVerifier, MessageHashCalculator, MessageIdCalculator {
    uint256 public immutable chain;
    address public immutable sender;
    address public immutable yaho;
    address public immutable hashi;
    uint256 public immutable threshold;
    bytes32 public immutable adaptersHash;

    constructor(
        uint256 chain_,
        address sender_,
        address yaho_,
        address hashi_,
        uint256 threshold_,
        address[] memory adapters_
    ) {
        chain = chain_;
        sender = sender_;
        yaho = yaho_;
        hashi = hashi_;
        threshold = threshold_;
        adaptersHash = _calcAdaptersHash(adapters_);
    }

    function verifyEvent(
        uint256 chain_,
        address emitter_,
        bytes32[] calldata topics_,
        bytes calldata data_,
        bytes calldata proof_
    ) external view {
        HashiMessageProof calldata messageProof = HashiMessageProofLib.decode(proof_);
        bytes32 hash = EventHashLib.calc(chain_, emitter_, topics_, data_);
        if (messageProof.batchHashes.length != 0) {
            bytes32 batchHash = messageProof.batchHashes[messageProof.batchIndex];
            require(batchHash == hash, TODO()); // BatchEventHashMismatch(batchProof.batchIndex, batchHash, hash)
            hash = EventsHashLib.calc(messageProof.batchHashes);
        }

        require(adaptersHash == _calcAdaptersHash(messageProof.adapters), TODO());

        Message memory message = Message({
            nonce: messageProof.nonce,
            targetChainId: block.chainid,
            threshold: threshold,
            sender: sender,
            receiver: address(this),
            data: HashiEventMessageDataLib.encode(hash),
            reporters: HashiMessageCastLib.asReporters(messageProof.reporters),
            adapters: HashiMessageCastLib.asAdapters(messageProof.adapters)
        });
        bytes32 messageHash = calculateMessageHash(message);
        uint256 messageId = calculateMessageId(chain, yaho, messageHash);

        require(IHashi(hashi).checkHashWithThresholdFromAdapters(chain, messageId, threshold, message.adapters), TODO());
    }

    function _calcAdaptersHash(address[] memory adapters_) private pure returns (bytes32 hash) {
        assembly { hash := keccak256(add(adapters_, 32), mul(mload(adapters_), 32)) }
    }
}
