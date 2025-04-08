// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {HashiBatchReceiveProof} from "../interfaces/HashiBatchReceiveProof.sol";

library HashiBatchReceiveProofLib {
    function decode(bytes calldata proof_) internal pure returns (HashiBatchReceiveProof calldata batchReceiveProof) {
        assembly { batchReceiveProof := proof_.offset }
    }
}
