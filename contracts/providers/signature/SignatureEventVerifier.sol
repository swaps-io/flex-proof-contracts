// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import {MessageHashUtils} from "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";

import {EventHashLib} from "../../libraries/EventHashLib.sol";

import {ISignatureEventVerifier} from "./interfaces/ISignatureEventVerifier.sol";

contract SignatureEventVerifier is ISignatureEventVerifier {
    // keccak256(abi.encode(
    //   keccak256("EIP712Domain(string name,string version)"), // 0xb03948446334eb9b2196d5eb166f69b9d49403eb4a12f36de8d3f9f3cb8e15c3
    //   keccak256("flex-proof/SignatureEventVerifier"),        // 0x0929e396c2fcdb4f4c8a66eefa26e8ad5b3a2d1dfd92895dafaa0472b29dfa26
    //   keccak256("1")                                         // 0xc89efdaa54c0f20c7adf612882df0950f5a951637e0307cdcb4c672f298b8bc6
    // ))
    bytes32 private constant DOMAIN_SEPARATOR = 0x67124e683cf5b4f5f22db58a706ce7ca7e369c50f2563032a2eca1f4c267d94b;

    address public immutable signer;

    constructor(address signer_) {
        signer = signer_;
    }

    function verifyEvent(
        uint256 chain_,
        address emitter_,
        bytes32[] calldata topics_,
        bytes calldata data_,
        bytes calldata proof_
    ) public view override {
        bytes32 eventHash = EventHashLib.calc(chain_, emitter_, topics_, data_);
        eventHash = MessageHashUtils.toTypedDataHash(DOMAIN_SEPARATOR, eventHash);
        address recovered = ECDSA.recover(eventHash, proof_);
        require(recovered == signer, InvalidSignatureProof(recovered, signer));
    }
}
