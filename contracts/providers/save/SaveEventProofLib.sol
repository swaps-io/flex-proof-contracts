// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {SaveEventProof} from "./interfaces/SaveEventProof.sol";

library SaveEventProofLib {
    function decode(bytes calldata proof_) internal pure returns (SaveEventProof calldata routerProof) {
        assembly { routerProof := add(proof_.offset, 32) }
    }

    function consume(bytes calldata proof_) internal pure returns (bytes memory) {
        return proof_[32:];
    }
}
