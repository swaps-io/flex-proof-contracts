// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

import {EventHashLib} from "../../libraries/EventHashLib.sol";

import {ISignatureEventVerifier} from "./interfaces/ISignatureEventVerifier.sol";

contract SignatureEventVerifier is ISignatureEventVerifier {
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
        address recovered = ECDSA.recover(eventHash, proof_);
        require(recovered == signer, InvalidSignatureProof(recovered, signer));
    }
}
