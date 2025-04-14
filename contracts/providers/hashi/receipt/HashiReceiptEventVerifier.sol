// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {RlpEventLib} from "../../../libraries/RlpEventLib.sol";

import {IHashiReceiptEventVerifier} from "./interfaces/IHashiReceiptEventVerifier.sol";

import {HashiProverLib, ReceiptProof} from "../libraries/hashi/prover/HashiProverLib.sol";

import {ReceiptProofLib} from "./libraries/ReceiptProofLib.sol";

contract HashiReceiptEventVerifier is IHashiReceiptEventVerifier {
    address public immutable shoyuBashi;

    constructor(address shoyuBashi_) {
        shoyuBashi = shoyuBashi_;
    }

    function verifyEvent(
        uint256 chain_,
        address emitter_,
        bytes32[] calldata topics_,
        bytes calldata data_,
        bytes calldata proof_
    ) external view {
        ReceiptProof calldata receiptProof = ReceiptProofLib.decode(proof_);
        require(chain_ == receiptProof.chainId, ReceiptChainMismatch(chain_, receiptProof.chainId));
        bytes memory rlpEvent = RlpEventLib.encode(emitter_, topics_, data_);
        bytes memory proofRlpEvent = HashiProverLib.verifyForeignEvent(receiptProof, shoyuBashi);
        require(keccak256(proofRlpEvent) == keccak256(rlpEvent), ReceiptEventMismatch(rlpEvent, proofRlpEvent));
    }
}
