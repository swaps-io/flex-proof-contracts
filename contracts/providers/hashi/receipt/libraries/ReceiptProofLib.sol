// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {ReceiptProof} from "@gnosis/hashi-evm/contracts/prover/HashiProverStructs.sol";

library ReceiptProofLib {
    function decode(bytes calldata proof_) internal pure returns (ReceiptProof calldata receiptProof) {
        assembly { receiptProof := proof_.offset }
    }
}
