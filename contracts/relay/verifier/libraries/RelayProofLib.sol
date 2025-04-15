// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {RelayProof} from "../interfaces/RelayProof.sol";

library RelayProofLib {
    function decode(bytes calldata proof_) internal pure returns (RelayProof calldata relayProof) {
        assembly { relayProof := proof_.offset }
    }

    function consume(bytes calldata proof_) internal pure returns (bytes memory) {
        RelayProof calldata relayProof = decode(proof_);
        uint256 size = (1 + relayProof.relayChains.length) * 32; // 1: `relayChains` length
        return proof_[size:];
    }
}
