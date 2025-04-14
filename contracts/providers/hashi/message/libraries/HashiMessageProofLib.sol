// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {HashiMessageProof} from "../interfaces/HashiMessageProof.sol";

library HashiMessageProofLib {
    function decode(bytes calldata proof_) internal pure returns (HashiMessageProof calldata messageProof) {
        assembly { messageProof := proof_.offset }
    }
}
