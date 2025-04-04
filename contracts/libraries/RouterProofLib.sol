// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {RouterProof} from "../interfaces/RouterProof.sol";

library RouterProofLib {
    function decode(bytes calldata proof_) internal pure returns (RouterProof calldata routerProof) {
        assembly { routerProof := add(proof_.offset, 32) }
    }

    function consume(bytes calldata proof_) internal pure returns (bytes memory) {
        RouterProof calldata routerProof = decode(proof_);
        uint256 size = (2 + routerProof.relayChains.length) * 32;
        return proof_[size:];
    }
}
